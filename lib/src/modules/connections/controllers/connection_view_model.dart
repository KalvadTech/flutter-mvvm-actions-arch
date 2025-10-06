import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '/src/core/errors/app_exception.dart';
import '/src/config/config.dart';
import '/src/utils/utils.dart';

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
class ConnectionViewModel extends GetxController {
  /// Observable to track the current connection type.
  Rx<ConnectivityType> connectionType = ConnectivityType.connecting.obs;

  /// Instance of `Connectivity` to monitor network changes.
  late final Connectivity _connectivity;

  /// Subscription to listen to connectivity changes.
  StreamSubscription? _streamSubscription;

  /// Debounce timer to prevent rapid flapping updates.
  Timer? _debounce;

  /// Fixed debounce duration for PR1 (configurable in PR2).
  final Duration _debounceDuration = const Duration(milliseconds: 250);

  /// Stores the timestamp when the connection was lost.
  DateTime? _connectionLostDate;

  /// Timer to track the duration of connection loss.
  Timer? _connectionLostTimer;

  /// Number of seconds the connection has been lost.
  double _timerSeconds = 0.0;

  /// Formatted string to display the lost connection duration.
  String dialogTimer = "00:00:00";

  /// Constructor to initialize the connectivity listener.
  ConnectionViewModel() {
    _connectivity = Connectivity();
    getConnectivity(); // Check the initial connectivity state.
    _listenToConnectivity(); // Start listening to connectivity changes.
  }

  /// Starts listening to connectivity changes and updates the state accordingly.
  void _listenToConnectivity() {
    _streamSubscription = _connectivity.onConnectivityChanged.listen((result) {
      _debounce?.cancel();
      _debounce = Timer(_debounceDuration, () => _updateState(result));
    });
  }

  /// Checks the initial connectivity status and updates the state.
  Future<void> getConnectivity() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    await _updateState(connectivityResult);
  }

  /// Resets the timer and cancels the connection lost timer if it exists.
  void _resetAndCancelTimer() {
    _timerSeconds = 0.0; // Reset the timer.
    _connectionLostTimer?.cancel(); // Cancel the timer to stop tracking.
  }

  /// Called when the connection is restored, stops the lost connection timer.
  void _onConnected() {
    _resetAndCancelTimer(); // Reset and cancel the timer.
  }

  /// Called when the connection is lost, starts a timer to track how long it's lost.
  void _onLostConnection() {
    if (_connectionLostTimer?.isActive == true) return; // guard against duplicate timers
    _connectionLostDate = DateTime.now(); // Store the time when the connection was lost.
    _connectionLostTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _timerSeconds = DateTime.now().difference(_connectionLostDate!).inSeconds.toDouble();
      dialogTimer = Utils.printDuration(Duration(seconds: _timerSeconds.toInt())); // Format the duration.
      update(); // Update the UI with the new timer value.
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
        connectionType.value = ConnectivityType.mobileData;
        await _checkInternetConnection(); // Verify internet access.
        break;
      case ConnectivityResult.wifi:
      case ConnectivityResult.ethernet:
      case ConnectivityResult.bluetooth:
      case ConnectivityResult.vpn:
      case ConnectivityResult.other:
        // Treat these as having a transport; verify reachability next.
        connectionType.value = ConnectivityType.wifi;
        await _checkInternetConnection();
        break;
      case ConnectivityResult.none:
        connectionType.value = ConnectivityType.disconnected;
        _onLostConnection(); // Start the lost connection timer.
        break;
    }
  }

  /// Checks if the internet is reachable by pinging 'google.com'.
  Future<void> _checkInternetConnection() async {
    if (!kIsWeb) {
      try {
        final result = await InternetAddress.lookup('google.com')
            .timeout(const Duration(seconds: 3));
        if (result.isEmpty) throw const SocketException('No addresses');
        _onConnected(); // Reset the timer if the internet is accessible.
      } catch (e) {
        connectionType.value = ConnectivityType.noInternet;
        _onLostConnection(); // start timer for no-internet condition as well
        // Do not throw; UI widgets will react to state and inform the user.
      }
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
