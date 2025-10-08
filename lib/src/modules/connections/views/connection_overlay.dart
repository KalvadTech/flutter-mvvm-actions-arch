import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/src/utils/utils.dart';
import '/src/presentation/custom/customs.dart';
import '/src/modules/locale/data/keys.dart';
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
              return InfoItem(label: tkReconnecting.tr);
            case ConnectivityType.disconnected:
            case ConnectivityType.noInternet:
              return const OfflineStatusCard();
            default:
              return const SizedBox.shrink();
          }
        }),
      ],
    );
  }
}

/// **OfflineStatusCard**
///
/// Full-screen modal card shown when the app determines there is no internet
/// connectivity. Displays a timer since disconnection and offers a manual
/// refresh action.
///
/// **Why**
/// - Provide clear, blocking feedback when connectivity is lost.
/// - Show user how long they've been offline with a live timer.
///
/// **Key Features**
/// - Full-screen overlay with semi-transparent background.
/// - Live offline duration timer via ConnectionViewModel.
/// - Manual refresh button to retry connectivity check.
/// - Material 3 theming (errorContainer/onErrorContainer).
/// - Auto-dismisses when connectivity is restored.
///
// ────────────────────────────────────────────────
class OfflineStatusCard extends StatefulWidget {
  const OfflineStatusCard({super.key});

  @override
  State<OfflineStatusCard> createState() => _OfflineStatusCardState();
}

class _OfflineStatusCardState extends State<OfflineStatusCard> {
  /// Initializes the connection lost handler.
  @override
  void initState() {
    ConnectionActions.instance.onConnectionLost();
    super.initState();
  }

  /// Builds the UI for the no-internet widget.
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: Colors.black26,
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(24.0),
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: cs.errorContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Semantics(
                  label: tkNoInternetMsg.tr,
                  child: Icon(
                    Icons.wifi_off_outlined,
                    color: cs.onErrorContainer,
                    size: 40,
                  ),
                ),
                SizedBox(height: ResponsiveUtils.screenHeight(context, 0.01)),
                CustomText.title(
                  tkConnectionLost.tr,
                  color: cs.onErrorContainer,
                ),
                CustomText.subtitle(
                  tkNoInternetConnectionMessage.tr,
                  color: cs.onErrorContainer,
                ),
                SizedBox(height: ResponsiveUtils.screenHeight(context, 0.01)),
                CustomText.subtitle(
                  tkConnectionAutoReconnect.tr,
                  color: cs.onErrorContainer,
                  textAlign: TextAlign.center,
                ),
                Obx(() => CustomText.subtitle(
                      '(${Get.find<ConnectionViewModel>().dialogTimer.value})',
                      color: cs.onErrorContainer,
                    )),
                const SizedBox(height: 12.0),
                InkWell(
                  onTap: _refresh,
                  child: CustomText.subtitle(
                    tkRefreshBtn.tr,
                    color: cs.primary,
                  ),
                ),
              ],
            ),
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
    final cs = Theme.of(context).colorScheme;
    return SafeArea(
      child: Semantics(
        label: tkReconnecting.tr,
        child: Container(
          color: cs.surfaceContainerHighest,
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(child: CustomText(label)),
              trailing ?? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2)),
            ],
          ),
        ),
      ),
    );
  }
}
