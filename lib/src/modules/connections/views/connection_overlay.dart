import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/src/config/config.dart';
import '/src/utils/utils.dart';
import '/src/presentation/custom/customs.dart';
import '../connection.dart';

/// **ConnectionOverlay**
///
/// Widget that overlays its [child] with a small status surface when the
/// device is attempting to reconnect or has no internet connectivity.
///
/// Why
/// - Provide ambient feedback without blocking the entire screen.
/// - Keep feature UIs responsive while connection issues resolve.
///
/// Usage
/// ```dart
/// ConnectionOverlay(child: YourPage())
/// ```
class ConnectionOverlay extends GetWidget<ConnectionViewModel> {
  /// The child widget to overlay with the connection status.
  final Widget child;

  /// The alignment of the overlay.
  final Alignment? alignment;

  /// Constructor for the `ConnectionOverlay` widget.
  const ConnectionOverlay({
    super.key,
    required this.child,
    this.alignment = Alignment.bottomCenter,
  });

  /// Builds the overlay with the appropriate connection status widget.
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Obx(() {
          switch (controller.connectionType.value) {
            case ConnectivityType.connecting:
              return const InfoItem(label: 'Please wait, trying to reconnect');
            case ConnectivityType.disconnected:
            case ConnectivityType.noInternet:
              return const NoInternetWidget();
            default:
              return Container();
          }
        }),
      ],
    );
  }
}

/// **NoInternetWidget**
///
/// Full-width card shown when the app determines there is no internet
/// connectivity. Displays a timer since disconnection and offers a manual
/// refresh action.
class NoInternetWidget extends StatefulWidget {
  const NoInternetWidget({super.key});

  @override
  State<NoInternetWidget> createState() => _NoInternetWidgetState();
}

class _NoInternetWidgetState extends State<NoInternetWidget> {
  /// Initializes the connection lost handler.
  @override
  void initState() {
    ConnectionActions.instance.onConnectionLost();
    super.initState();
  }

  /// Builds the UI for the no-internet widget.
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white10,
      child: Container(
        padding: const EdgeInsets.all(24.0),
        alignment: Alignment.center,
        child: CustomCard(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.wifi_off_outlined,
                color: Colors.white,
                size: 40,
              ),
              SizedBox(height: ScreenUtils.getScreenHeight(context, 0.01)),
              CustomText.title(
                "CONNECTION LOST",
                color: Colors.red,
                fontSize: 20,
              ),
              const CustomText.title(
                'Looks like you have no internet connection.',
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
              SizedBox(height: ScreenUtils.getScreenHeight(context, 0.01)),
              const CustomText.title(
                '(This popup will disappear automatically\nwhen the connection is reestablished.)',
                fontSize: 16,
                fontWeight: FontWeight.w800,
                textAlign: TextAlign.center,
              ),
              GetBuilder<ConnectionViewModel>(
                builder: (controller) {
                  return CustomText.title(
                    '(${controller.dialogTimer})',
                    fontSize: 16,
                  );
                },
              ),
              const SizedBox(height: 12.0),
              InkWell(
                onTap: _refresh,
                child: const CustomText.title(
                  'Refresh',
                  color: ColorManager.primaryColor,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Refreshes the connectivity state when the widget is disposed.
  @override
  void dispose() {
    ConnectionActions.instance.refreshData();
    super.dispose();
  }

  /// Refreshes the connection status and data.
  void _refresh() {
    ConnectionActions.instance.checkConnectivity();
    ConnectionActions.instance.refreshData();
  }
}

/// A reusable widget to display information with an optional trailing widget.
class InfoItem extends StatelessWidget {
  /// The label to display.
  final String label;

  /// An optional trailing widget (e.g., a progress indicator).
  final Widget? trailing;

  /// An optional callback for user interaction.
  final VoidCallback? onPressed;

  /// Constructor for the `InfoItem` widget.
  const InfoItem({
    super.key,
    required this.label,
    this.trailing,
    this.onPressed,
  });

  /// Builds the UI for the `InfoItem`.
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black38,
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          Expanded(child: CustomText(label)),
          trailing ?? const CircularProgressIndicator(),
        ],
      ),
    );
  }
}
