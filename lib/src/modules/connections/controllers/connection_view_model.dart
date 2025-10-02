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
enum ConnectivityType { mobileData, wifi, disconnected, noInternet, connecting }

class ConnectionViewModel extends GetxController {
  /// Observable to track the current connection type.
  Rx<ConnectivityType> connectionType = ConnectivityType.connecting.obs;

  /// Instance of `Connectivity` to monitor network changes.
  late final Connectivity _connectivity;

  /// Subscription to listen to connectivity changes.
  StreamSubscription? _streamSubscription;

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
    _streamSubscription = _connectivity.onConnectivityChanged.listen(_updateState);
  }

  /// Checks the initial connectivity status and updates the state.
  Future<void> getConnectivity() async {
    var connectivityResult = await _connectivity.checkConnectivity(); // first call always return no internet
    connectivityResult = await _connectivity.checkConnectivity();
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
        connectionType.value == ConnectivityType.mobileData ||
        connectionType.value == ConnectivityType.connecting;
  }

  /// Updates the connection state based on the last connectivity result.
  Future<void> _updateState(List<ConnectivityResult> result) async {
    switch (result.last) {
      case ConnectivityResult.wifi:
        connectionType.value = ConnectivityType.wifi;
        await _checkInternetConnection(); // Verify internet access.
        break;
      case ConnectivityResult.mobile:
        connectionType.value = ConnectivityType.mobileData;
        await _checkInternetConnection(); // Verify internet access.
        break;
      case ConnectivityResult.none:
        connectionType.value = ConnectivityType.disconnected;
        _onLostConnection(); // Start the lost connection timer.
        throw NetworkException(tkNoInternetMsg); // Trigger an error for no connection.
      default:
        connectionType.value = ConnectivityType.disconnected;
        _onLostConnection(); // Handle unknown state.
        throw NetworkException(tkCheckNetworkFailedMsg); // Trigger a generic error.
    }
  }

  /// Checks if the internet is reachable by pinging 'google.com'.
  Future<void> _checkInternetConnection() async {
    if (!kIsWeb) {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isEmpty) throw Exception();
        _onConnected(); // Reset the timer if the internet is accessible.
      } catch (e) {
        connectionType.value = ConnectivityType.noInternet;
        throw NetworkException(tkNoInternetMsg); // Handle no internet scenario.
      }
    }
  }

  @override
  void onClose() {
    _streamSubscription?.cancel(); // Cancel the connectivity subscription.
    _resetAndCancelTimer(); // Reset and cancel the lost connection timer.
    super.onClose(); // Call the parent class's onClose method.
  }
}
