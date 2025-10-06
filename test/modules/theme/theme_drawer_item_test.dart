import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:getx_starter/src/modules/theme/controllers/theme_view_model.dart';
import 'package:getx_starter/src/modules/theme/data/services/theme_service.dart';
import 'package:getx_starter/src/modules/theme/views/theme_drawer_item.dart';
import 'package:getx_starter/src/modules/theme/views/theme_mode_label.dart';
import 'package:getx_starter/src/modules/theme/views/theme_mode_switch.dart';
import 'package:getx_starter/src/modules/locale/data/services/localization_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ThemeDrawerItem Widget Tests', () {
    late ThemeViewModel viewModel;

    setUp(() {
      Get.testMode = true;

      // Initialize localization for translations
      LocalizationService.init();

      // Create and register ViewModel
      viewModel = ThemeViewModel(ThemeService());
      Get.put<ThemeViewModel>(viewModel);
    });

    tearDown(() {
      Get.reset();
    });

    Widget createTestWidget() {
      return GetMaterialApp(
        translations: LocalizationService(),
        locale: LocalizationService.locale,
        fallbackLocale: LocalizationService.fallbackLocale,
        home: Scaffold(
          body: ThemeDrawerItem(),
        ),
      );
    }

    testWidgets('renders without errors', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(ThemeDrawerItem), findsOneWidget);
    });

    testWidgets('displays ListTile', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(ListTile), findsOneWidget);
    });

    testWidgets('displays moon icon', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.brightness_3), findsOneWidget);
    });

    testWidgets('displays ThemeModeLabel', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(ThemeModeLabel), findsOneWidget);
    });

    testWidgets('displays ThemeModeSwitch', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(ThemeModeSwitch), findsOneWidget);
    });

    testWidgets('displays "Dark mode" text', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Should show either English or Arabic dark mode text
      expect(
        find.textContaining('Dark mode', findRichText: true).evaluate().isNotEmpty ||
        find.textContaining('الوضع الداكن', findRichText: true).evaluate().isNotEmpty,
        isTrue,
      );
    });

    testWidgets('has correct structure - icon, label, switch', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final listTile = tester.widget<ListTile>(find.byType(ListTile));

      // Check leading is Icon
      expect(listTile.leading, isA<Icon>());

      // Check title is ThemeModeLabel
      expect(listTile.title, isA<ThemeModeLabel>());

      // Check trailing is ThemeModeSwitch
      expect(listTile.trailing, isA<ThemeModeSwitch>());
    });

    testWidgets('switch is functional within drawer item', (WidgetTester tester) async {
      viewModel.changeTheme(ThemeMode.light);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(viewModel.isDark, isFalse);

      // Tap the switch
      await tester.tap(find.byType(CupertinoSwitch));
      await tester.pumpAndSettle();

      // Theme should change
      expect(viewModel.isDark, isTrue);
    });

    testWidgets('works in a drawer context', (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          translations: LocalizationService(),
          locale: LocalizationService.locale,
          fallbackLocale: LocalizationService.fallbackLocale,
          home: Scaffold(
            drawer: Drawer(
              child: ListView(
                children: const [
                  ThemeDrawerItem(),
                ],
              ),
            ),
            appBar: AppBar(
              title: const Text('Test'),
              leading: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Open drawer using the menu icon
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // Find drawer item
      expect(find.byType(ThemeDrawerItem), findsOneWidget);
    });

    testWidgets('icon has correct properties', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final icon = tester.widget<Icon>(find.byIcon(Icons.brightness_3));

      expect(icon.icon, equals(Icons.brightness_3));
    });

    testWidgets('all components render correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // All three main components should be present
      expect(find.byIcon(Icons.brightness_3), findsOneWidget);
      expect(find.byType(ThemeModeLabel), findsOneWidget);
      expect(find.byType(ThemeModeSwitch), findsOneWidget);
    });
  });
}
