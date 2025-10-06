import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:getx_starter/src/modules/theme/controllers/theme_view_model.dart';
import 'package:getx_starter/src/modules/theme/data/services/theme_service.dart';
import 'package:getx_starter/src/modules/theme/views/theme_mode_switch.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ThemeModeSwitch Widget Tests', () {
    late ThemeViewModel viewModel;

    setUp(() {
      Get.testMode = true;

      // Create and register ViewModel
      viewModel = ThemeViewModel(ThemeService());
      Get.put<ThemeViewModel>(viewModel);
    });

    tearDown(() {
      Get.reset();
    });

    Widget createTestWidget() {
      return GetMaterialApp(
        home: Scaffold(
          body: ThemeModeSwitch(),
        ),
      );
    }

    testWidgets('renders without errors', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(ThemeModeSwitch), findsOneWidget);
    });

    testWidgets('displays CupertinoSwitch', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(CupertinoSwitch), findsOneWidget);
    });

    testWidgets('switch is off for light theme', (WidgetTester tester) async {
      viewModel.changeTheme(ThemeMode.light);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final switchWidget = tester.widget<CupertinoSwitch>(
        find.byType(CupertinoSwitch),
      );

      expect(switchWidget.value, isFalse);
    });

    testWidgets('switch is on for dark theme', (WidgetTester tester) async {
      viewModel.changeTheme(ThemeMode.dark);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final switchWidget = tester.widget<CupertinoSwitch>(
        find.byType(CupertinoSwitch),
      );

      expect(switchWidget.value, isTrue);
    });

    testWidgets('tapping switch changes theme to dark', (WidgetTester tester) async {
      viewModel.changeTheme(ThemeMode.light);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap the switch
      await tester.tap(find.byType(CupertinoSwitch));
      await tester.pumpAndSettle();

      // Theme should be dark now
      expect(viewModel.themeMode, equals(ThemeMode.dark));
      expect(viewModel.isDark, isTrue);
    });

    testWidgets('tapping switch changes theme to light', (WidgetTester tester) async {
      viewModel.changeTheme(ThemeMode.dark);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap the switch
      await tester.tap(find.byType(CupertinoSwitch));
      await tester.pumpAndSettle();

      // Theme should be light now
      expect(viewModel.themeMode, equals(ThemeMode.light));
      expect(viewModel.isDark, isFalse);
    });

    testWidgets('switch updates when theme changes externally', (WidgetTester tester) async {
      viewModel.changeTheme(ThemeMode.light);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      var switchWidget = tester.widget<CupertinoSwitch>(
        find.byType(CupertinoSwitch),
      );
      expect(switchWidget.value, isFalse);

      // Change theme externally
      viewModel.changeTheme(ThemeMode.dark);
      await tester.pumpAndSettle();

      switchWidget = tester.widget<CupertinoSwitch>(
        find.byType(CupertinoSwitch),
      );
      expect(switchWidget.value, isTrue);
    });

    testWidgets('multiple taps toggle correctly', (WidgetTester tester) async {
      viewModel.changeTheme(ThemeMode.light);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // First tap - should be dark
      await tester.tap(find.byType(CupertinoSwitch));
      await tester.pumpAndSettle();
      expect(viewModel.isDark, isTrue);

      // Second tap - should be light
      await tester.tap(find.byType(CupertinoSwitch));
      await tester.pumpAndSettle();
      expect(viewModel.isDark, isFalse);

      // Third tap - should be dark again
      await tester.tap(find.byType(CupertinoSwitch));
      await tester.pumpAndSettle();
      expect(viewModel.isDark, isTrue);
    });

    testWidgets('uses GetWidget controller binding', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Widget should render without calling Get.find multiple times
      expect(find.byType(ThemeModeSwitch), findsOneWidget);
    });

    testWidgets('switch is interactive', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final switchWidget = tester.widget<CupertinoSwitch>(
        find.byType(CupertinoSwitch),
      );

      // onChanged should be set (not null)
      expect(switchWidget.onChanged, isNotNull);
    });
  });
}
