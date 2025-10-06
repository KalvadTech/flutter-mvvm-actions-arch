import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '/src/utils/utils.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:get/get.dart';
import '/src/config/config.dart';
import '/src/utils/binding.dart';
import 'modules/locale/data/services/localization_service.dart';
import 'modules/connections/connection.dart';
import 'modules/theme/theme.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

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
