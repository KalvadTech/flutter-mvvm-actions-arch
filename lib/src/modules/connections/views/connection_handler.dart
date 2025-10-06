import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../connection.dart';

/// **ConnectionHandler**
///
/// Simple switcher that observes connection state via [ConnectionViewModel]
/// and renders either a `connectedWidget` or a retry UI when offline.
///
/// Why
/// - Centralize connection gating around a section of the UI.
/// - Provide a consistent retry affordance when offline.
///
/// Parameters
/// - `connectedWidget`: Rendered when `isConnected()` is true.
/// - `notConnectedWidget`: Optional custom offline UI; defaults to a basic prompt.
/// - `tryAgainAction`: Callback invoked when user taps to retry.
class ConnectionHandler extends GetWidget<ConnectionViewModel> {
  /// The widget to display when the device is connected to the internet.
  final Widget connectedWidget;

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
    this.notConnectedWidget,
  });

  /// Builds the UI based on the current connection state using an `Obx` widget.
  ///
  /// When the connection is established, the `connectedWidget` is displayed.
  /// If not connected, the `notConnectedWidget` or a default UI with a retry
  /// tap handler is shown. The retry action is only triggered by user input to
  /// avoid repeated calls on rebuilds.
  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        // Return the appropriate widget based on the connection state.
        return controller.isConnected()
            ? connectedWidget
            : InkWell(
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
                        const Text('Try again'),
                      ],
                    ),
              );
      },
    );
  }
}
