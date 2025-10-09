import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:get/get.dart';
import 'config/config.dart';
import 'core/core.dart';
import 'modules/locale/data/services/localization_service.dart';
import 'modules/connections/connection.dart';
import 'modules/theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Get ThemeViewModel to observe theme changes
    final themeVM = Get.find<ThemeViewModel>();

    return GlobalLoaderOverlay(
      overlayWidgetBuilder: (context) => const SpinKitCubeGrid(
        color: Colors.white,
        size: 50.0,
      ),
      child: ConnectionOverlay(
        child: Obx(
          () => GetMaterialApp(
            initialBinding: InitialBindings(),
            getPages: RouteManager.instance.pages,
            translations: LocalizationService(),
            locale: LocalizationService.locale,
            fallbackLocale: LocalizationService.fallbackLocale,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeVM.themeMode,
          ),
        ),
      ),
    );
  }
}
