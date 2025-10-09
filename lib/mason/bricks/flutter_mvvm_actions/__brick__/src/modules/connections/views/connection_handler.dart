import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/src/modules/locale/data/keys.dart';
import '../connection.dart';

/// **ConnectionHandler**
///
/// Simple switcher that observes connection state via [ConnectionViewModel]
/// and renders one of three states:
/// - `connectedWidget` when connected,
/// - `onConnectingWidget` while probing reachability,
/// - a retry UI when offline.
///
/// Why
/// - Centralize connection gating around a section of the UI.
/// - Provide a consistent retry affordance when offline.
/// - Avoid showing connected content while the app is still checking connectivity.
///
/// Parameters
/// - `connectedWidget`: Rendered when `isConnected()` is true.
/// - `onConnectingWidget`: Optional widget while `ConnectivityType.connecting`; defaults to a centered spinner.
/// - `notConnectedWidget`: Optional custom offline UI; defaults to a basic prompt with retry.
/// - `tryAgainAction`: Callback invoked when user taps to retry (offline states only).
class ConnectionHandler extends GetWidget<ConnectionViewModel> {
  /// The widget to display when the device is connected to the internet.
  final Widget connectedWidget;

  /// The widget to display while the app is probing connectivity.
  final Widget? onConnectingWidget;

  /// The widget to display when the device is not connected.
  /// Defaults to a column with an icon and "try again" text.
  final Widget? notConnectedWidget;

  /// The action to perform when the user taps the retry button.
  final VoidCallback tryAgainAction;

  /// Constructor to create an instance of `ConnectionHandler`.
  const ConnectionHandler({
    super.key,
    required this.connectedWidget,
    required this.tryAgainAction,
    this.onConnectingWidget,
    this.notConnectedWidget,
  });

  /// Builds the UI based on the current connection state using an `Obx` widget.
  ///
  /// When connected, shows `connectedWidget`. While probing, shows `onConnectingWidget`
  /// (or a default spinner). When offline, shows `notConnectedWidget` or a default
  /// UI with a retry tap handler. The retry action is only triggered by user input
  /// to avoid repeated calls on rebuilds.
  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final state = controller.connectionType.value;
        if (controller.isConnected()) {
          return connectedWidget;
        }
        if (state == ConnectivityType.connecting) {
          return onConnectingWidget ?? const Center(child: CircularProgressIndicator());
        }
        // Offline (disconnected or noInternet): show retry UI
        return InkWell(
          onTap: tryAgainAction,
          child: notConnectedWidget ??
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_off,
                    size: MediaQuery.of(context).size.height / 4,
                  ),
                  const SizedBox(height: 16.0),
                  Text(tkTryAgainBtn.tr),
                ],
              ),
        );
      },
    );
  }
}
