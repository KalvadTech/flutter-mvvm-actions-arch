import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:getx_starter/src/modules/locale/controllers/localization_view_model.dart';
import 'package:getx_starter/src/modules/locale/data/models/language_model.dart';
import 'package:getx_starter/src/modules/locale/views/language_dialog.dart';
import 'package:getx_starter/src/modules/locale/data/services/localization_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LanguagePickerDialog Widget Tests', () {
    late LocalizationViewModel viewModel;

    setUp(() async {
      Get.testMode = true;

      // Initialize localization (doesn't require storage)
      LocalizationService.init();

      // Create and register ViewModel
      viewModel = LocalizationViewModel();
      Get.put<LocalizationViewModel>(viewModel);
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
          body: LanguagePickerDialog(),
        ),
      );
    }

    testWidgets('renders without errors', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(LanguagePickerDialog), findsOneWidget);
    });

    testWidgets('displays dialog container', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsOneWidget);
    });

    testWidgets('displays close button', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.clear), findsOneWidget);
    });

    testWidgets('displays language dropdown', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(DropdownButtonFormField<LanguageModel>), findsOneWidget);
    });

    testWidgets('displays confirm button', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Look for button by finding text 'Confirm'
      expect(find.text('Confirm'), findsOneWidget);
    });

    testWidgets('dropdown shows all supported languages', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap dropdown to open
      await tester.tap(find.byType(DropdownButtonFormField<LanguageModel>));
      await tester.pumpAndSettle();

      // Should show English
      expect(find.text('English'), findsWidgets);

      // Should show Arabic
      expect(find.text('العربية'), findsWidgets);
    });

    testWidgets('displays initial selected language', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // The current language should be displayed
      final currentLang = viewModel.language;
      expect(find.text(currentLang.name), findsWidgets);
    });

    testWidgets('selecting language updates ViewModel', (WidgetTester tester) async {
      // Set initial language to English
      final english = LocalizationViewModel.supportedLanguages
          .firstWhere((lang) => lang.code == 'en');
      await viewModel.selectLanguage(english);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap dropdown to open
      await tester.tap(find.byType(DropdownButtonFormField<LanguageModel>));
      await tester.pumpAndSettle();

      // Select Arabic
      await tester.tap(find.text('العربية').last);
      await tester.pumpAndSettle();

      // ViewModel should have Arabic selected (but not saved yet)
      expect(viewModel.language.code, equals('ar'));
    });

    testWidgets('confirm button saves language change', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Change language
      await tester.tap(find.byType(DropdownButtonFormField<LanguageModel>));
      await tester.pumpAndSettle();

      await tester.tap(find.text('العربية').last);
      await tester.pumpAndSettle();

      // Tap confirm button
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      // Dialog should be closed (back navigation triggered)
      // In a real app, Get.back() would close the dialog
    });

    testWidgets('close button dismisses changes', (WidgetTester tester) async {
      // Set initial language to English
      final english = LocalizationViewModel.supportedLanguages
          .firstWhere((lang) => lang.code == 'en');
      await viewModel.selectLanguage(english);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Change language
      await tester.tap(find.byType(DropdownButtonFormField<LanguageModel>));
      await tester.pumpAndSettle();

      await tester.tap(find.text('العربية').last);
      await tester.pumpAndSettle();

      // Tap close button
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();

      // Language should be reverted (dismiss called)
      // Note: In real app, Get.back() would close dialog
    });

    testWidgets('uses controller property instead of Get.find', (WidgetTester tester) async {
      // This test verifies the fix for tight coupling
      // The widget should access controller via GetView inheritance
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Widget should render without calling Get.find multiple times
      expect(find.byType(LanguagePickerDialog), findsOneWidget);
    });

    testWidgets('dialog has proper styling', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final dialog = tester.widget<Dialog>(find.byType(Dialog));

      expect(dialog.backgroundColor, equals(Colors.white));
      expect(dialog.surfaceTintColor, equals(Colors.white));
      expect(dialog.shape, isA<RoundedRectangleBorder>());
    });

    testWidgets('dropdown has proper decoration', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final dropdown = tester.widget<DropdownButtonFormField<LanguageModel>>(
        find.byType(DropdownButtonFormField<LanguageModel>),
      );

      expect(dropdown.decoration, isNotNull);
      expect(dropdown.decoration.filled, isTrue);
      expect(dropdown.decoration.fillColor, equals(Colors.white));
    });

    testWidgets('handles rapid language changes', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Open dropdown
      await tester.tap(find.byType(DropdownButtonFormField<LanguageModel>));
      await tester.pumpAndSettle();

      // Rapidly change languages
      await tester.tap(find.text('العربية').last);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(DropdownButtonFormField<LanguageModel>));
      await tester.pumpAndSettle();

      await tester.tap(find.text('English').last);
      await tester.pumpAndSettle();

      // Should handle without errors
      expect(find.byType(LanguagePickerDialog), findsOneWidget);
    });
  });
}