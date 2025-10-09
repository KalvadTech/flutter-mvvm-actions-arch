import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/src/core/routing/route_manager.dart';
import '../connection.dart';
import '/src/config/assets.dart';


/// **ConnectivityCheckerSplash**
///
/// Splash screen that waits for connectivity initialization before navigating
/// to the next route. Useful when the app experience should begin only when
/// basic network availability is confirmed.
///
/// Parameters
/// - `nextRouteName`: Route to navigate to after initialization (default: '/auth').
/// - `delayInSeconds`: Optional delay before navigating to allow the logo to show.
///
/// Usage
/// ```dart
/// const ConnectivityCheckerSplash(nextRouteName: '/auth', delayInSeconds: 1)
/// ```
///
/// Notes
/// - Delegates connectivity checks and navigation timing to [ConnectionActions].
// ────────────────────────────────────────────────
class ConnectivityCheckerSplash extends StatefulWidget {
  final String nextRouteName;
  final int delayInSeconds;
  const ConnectivityCheckerSplash({super.key, this.nextRouteName = RouteManager.authRoute, this.delayInSeconds = 1});

  @override
  State<ConnectivityCheckerSplash> createState() => _ConnectivityCheckerSplashState();
}

class _ConnectivityCheckerSplashState extends State<ConnectivityCheckerSplash> {

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConnectionHandler(
          tryAgainAction: _init,
          connectedWidget: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SvgPicture.asset(
              AssetsManager.logoPath,
              height: MediaQuery.of(context).size.height / 3,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  void _init(){
    ConnectionActions.instance.initSplash(widget.nextRouteName, widget.delayInSeconds);
  }

}
