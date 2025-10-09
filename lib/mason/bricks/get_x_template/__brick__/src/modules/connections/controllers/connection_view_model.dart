import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '/src/utils/utils.dart';
import '../data/services/reachability_service.dart';

/// The `ConnectionViewModel` class is responsible for monitoring network connectivity changes
/// and managing the app's response to different network states.
///
/// It uses `Connectivity` from the `connectivity_plus` package to detect changes in WiFi,
/// mobile data, or disconnection. This class also tracks how long the connection is lost,
/// updates a timer to display this duration, and handles switching between different
/// connectivity states. Additionally, it verifies active internet access and manages timers
/// related to connection loss or restoration.
/// **ConnectivityType**
///
/// High-level connectivity states consumed by connection-aware widgets.
///
/// - `mobileData`: Connected via cellular data.
/// - `wifi`: Connected via Wi‑Fi.
/// - `disconnected`: No network transport reported.
/// - `noInternet`: Transport present but internet not reachable (DNS/route failure).
/// - `connecting`: Transitional state used while probing.
// ────────────────────────────────────────────────
enum ConnectivityType { mobileData, wifi, disconnected, noInternet, connecting }

/// **ConnectionViewModel**
///
/// GetX controller that monitors device connectivity using `connectivity_plus`
/// and exposes a reactive `connectionType`. It also tracks how long the app has
/// been offline and formats a timer string for UI overlays.
///
/// Why
/// - Provide a single source of truth for connection state across the app.
/// - Avoid throwing from stream callbacks; instead drive UI from state.
///
/// Key Features
/// - Subscribes to connectivity changes and performs a lightweight reachability
///   check (DNS lookup) to detect captive portals or offline routers.
/// - Emits granular states: transports vs. internet reachability.
/// - Tracks disconnection duration and exposes a formatted timer string.
///
/// Notes
/// - DNS lookup is a pragmatic reachability probe; adjust for your backend as needed.
/// - On Web, reachability probing is skipped as sockets/DNS are not available.
// ────────────────────────────────────────────────

class ConnectionViewModel extends GetxController with WidgetsBindingObserver {
  /// Observable to track the current connection type.
  Rx<ConnectivityType> connectionType = ConnectivityType.connecting.obs;

  /// Instance of `Connectivity` to monitor network changes.
  late final Connectivity _connectivity;

  /// Reachability probe service (DNS/HTTP), injectable.
  late final ReachabilityService _reachability;

  /// Telemetry callbacks (optional).
  final VoidCallback? onWentOfflineCallback;
  final void Function(Duration offlineDuration)? onBackOnlineCallback;

  /// Subscription to listen to connectivity changes.
  StreamSubscription? _streamSubscription;

  /// Debounce timer to prevent rapid flapping updates.
  Timer? _debounce;

  /// Debounce duration (configurable via constructor; defaults to 250ms).
  late final Duration _debounceDuration;

  /// Tracks whether the initial connectivity check has completed to avoid
  /// flashing a misleading offline state at app start.
  bool _initialCheckCompleted = false;

  /// Stores the timestamp when the connection was lost.
  DateTime? _connectionLostDate;

  /// Timer to track the duration of connection loss.
  Timer? _connectionLostTimer;

  /// Number of seconds the connection has been lost.
  double _timerSeconds = 0.0;

  /// Formatted string to display the lost connection duration (reactive).
  final RxString dialogTimer = '00:00:00'.obs;

  /// Constructor to initialize the connectivity listener and dependencies.
  ConnectionViewModel({
    ReachabilityService? reachability,
    Duration debounceDuration = const Duration(milliseconds: 250),
    this.onWentOfflineCallback,
    this.onBackOnlineCallback,
    bool autoInit = true,
  })  : _reachability = reachability ?? ReachabilityService(),
        _debounceDuration = debounceDuration {
    _connectivity = Connectivity();
    if (autoInit) {
      getConnectivity(); // Check the initial connectivity state.
      _listenToConnectivity(); // Start listening to connectivity changes.
    }
  }

  /// Starts listening to connectivity changes and updates the state accordingly.
  void _listenToConnectivity() {
    _streamSubscription = _connectivity.onConnectivityChanged.listen((dynamic result) {
      _debounce?.cancel();
      _debounce = Timer(_debounceDuration, () {
        if (result is List<ConnectivityResult>) {
          final ConnectivityResult first = result.isNotEmpty ? result.first : ConnectivityResult.none;
          _updateState(first);
        } else if (result is ConnectivityResult) {
          _updateState(result);
        } else {
          _updateState(ConnectivityResult.none);
        }
      });
    });
  }

  /// Checks the initial connectivity status and updates the state.
  ///
  /// Special handling: On the very first check, if the transport reports `none`,
  /// we keep the UI in `connecting` instead of flipping to `disconnected` to avoid
  /// a misleading initial "not connected" flash during app startup.
  Future<void> getConnectivity() async {
    final dynamic connectivityResult = await _connectivity.checkConnectivity();
    // Determine the single ConnectivityResult to evaluate
    final ConnectivityResult result = connectivityResult is List<ConnectivityResult>
        ? (connectivityResult.isNotEmpty ? connectivityResult.first : ConnectivityResult.none)
        : (connectivityResult is ConnectivityResult ? connectivityResult : ConnectivityResult.none);

    // First-check guard: if we haven't completed an initial check and the result is none,
    // stay in connecting and do not start the offline timer yet.
    if (!_initialCheckCompleted && result == ConnectivityResult.none) {
      connectionType.value = ConnectivityType.connecting;
      _initialCheckCompleted = true;
      return;
    }

    _initialCheckCompleted = true;
    await _updateState(result);
  }

  /// Resets the timer and cancels the connection lost timer if it exists.
  void _resetAndCancelTimer() {
    _timerSeconds = 0.0; // Reset the timer.
    _connectionLostTimer?.cancel(); // Cancel the timer to stop tracking.
  }

  /// Called when the connection is restored, stops the lost connection timer.
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Always re-check on resume
      getConnectivity();
    }
  }

  void _onConnected() {
    final wasOfflineFor = _connectionLostDate == null
        ? Duration.zero
        : DateTime.now().difference(_connectionLostDate!);
    _resetAndCancelTimer(); // Reset and cancel the timer.
    // Telemetry callback when back online
    if (onBackOnlineCallback != null) onBackOnlineCallback!(wasOfflineFor);
  }

  /// Called when the connection is lost, starts a timer to track how long it's lost.
  void _onLostConnection() {
    if (_connectionLostTimer?.isActive == true) return; // guard against duplicate timers
    _connectionLostDate = DateTime.now(); // Store the time when the connection was lost.
    // Telemetry callback when first going offline
    onWentOfflineCallback?.call();
    _connectionLostTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _timerSeconds = DateTime.now().difference(_connectionLostDate!).inSeconds.toDouble();
      dialogTimer.value = Duration(seconds: _timerSeconds.toInt()).format(); // Format the duration.
    });
  }

  /// Checks if the device is currently connected to a network.
  bool isConnected() {
    return connectionType.value == ConnectivityType.wifi ||
        connectionType.value == ConnectivityType.mobileData;
  }

  /// Updates the connection state based on the latest connectivity result.
  Future<void> _updateState(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.mobile:
        connectionType.value = ConnectivityType.connecting; // probe before confirming
        await _checkInternetConnection(mobile: true); // Verify internet access.
        break;
      case ConnectivityResult.wifi:
      case ConnectivityResult.ethernet:
      case ConnectivityResult.bluetooth:
      case ConnectivityResult.vpn:
      case ConnectivityResult.other:
        // Treat these as having a transport; verify reachability next.
        connectionType.value = ConnectivityType.connecting;
        await _checkInternetConnection();
        break;
      case ConnectivityResult.none:
        connectionType.value = ConnectivityType.disconnected;
        _onLostConnection(); // Start the lost connection timer.
        break;
    }
  }

  /// Checks if the internet is reachable using [_reachability].
  Future<void> _checkInternetConnection({bool mobile = false}) async {
    final ok = await _reachability.isReachable().catchError((_) => false);
    if (ok) {
      connectionType.value = mobile ? ConnectivityType.mobileData : ConnectivityType.wifi;
      _onConnected(); // Reset the timer if the internet is accessible.
    } else {
      connectionType.value = ConnectivityType.noInternet;
      _onLostConnection(); // start timer for no-internet condition as well
      // Do not throw; UI widgets will react to state and inform the user.
    }
  }

  @override
  void onClose() {
    _debounce?.cancel();
    _streamSubscription?.cancel(); // Cancel the connectivity subscription.
    _resetAndCancelTimer(); // Reset and cancel the lost connection timer.
    super.onClose(); // Call the parent class's onClose method.
  }
}
