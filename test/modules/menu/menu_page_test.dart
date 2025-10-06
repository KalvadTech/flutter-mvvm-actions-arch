import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:getx_starter/src/modules/menu/controllers/menu_view_model.dart';
import 'package:getx_starter/src/modules/menu/data/models/menu_item.dart';
import 'package:getx_starter/src/modules/menu/views/menu_page_with_drawer.dart';
import 'package:getx_starter/src/modules/menu/views/side_menu_drawer.dart';
import 'package:getx_starter/src/modules/theme/theme.dart';
import 'package:getx_starter/src/modules/locale/locale.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MenuPageWithDrawer Widget Tests', () {
    late MenuViewModel viewModel;

    setUp(() {
      Get.testMode = true;

      // Register theme dependencies
      if (!Get.isRegistered<ThemeViewModel>()) {
        Get.put(ThemeViewModel(ThemeService()));
      }

      // Register locale dependencies
      if (!Get.isRegistered<LocalizationViewModel>()) {
        Get.put(LocalizationViewModel());
      }

      // Create and register ViewModel
      viewModel = MenuViewModel();
      Get.put<MenuViewModel>(viewModel);

      // Configure menu items
      viewModel.configureMenu([
        const MenuItem(
          id: 'home',
          label: 'Home',
          icon: Icons.home,
          page: Placeholder(key: Key('home_page')),
        ),
        const MenuItem(
          id: 'profile',
          label: 'Profile',
          icon: Icons.person,
          page: Placeholder(key: Key('profile_page')),
        ),
      ]);
    });

    tearDown(() {
      Get.reset();
    });

    Widget createTestWidget() {
      return const GetMaterialApp(
        home: MenuPageWithDrawer(),
      );
    }

    testWidgets('renders without errors', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(MenuPageWithDrawer), findsOneWidget);
    });

    testWidgets('displays Scaffold', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('displays AppBar', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('has drawer configured', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.drawer, isNotNull);
    });

    testWidgets('displays current page content', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('home_page')), findsOneWidget);
    });

    testWidgets('app bar shows selected menu item label', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('updates displayed page when menu item selected', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('home_page')), findsOneWidget);

      // Select profile page
      viewModel.selectMenuItemByIndex(1);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('profile_page')), findsOneWidget);
      expect(find.byKey(const Key('home_page')), findsNothing);
    });

    testWidgets('updates app bar title when menu item selected', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);

      // Select profile page
      viewModel.selectMenuItemByIndex(1);
      await tester.pumpAndSettle();

      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('drawer can be opened and shows SideMenuDrawer', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final ScaffoldState state = tester.firstState(find.byType(Scaffold));
      state.openDrawer();
      await tester.pump(); // Start drawer animation
      await tester.pump(const Duration(seconds: 1)); // Complete drawer animation

      expect(find.byType(Drawer), findsOneWidget);
      expect(find.byType(SideMenuDrawer), findsOneWidget);
    });

    testWidgets('is reactive to menu changes', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('home_page')), findsOneWidget);

      // Change page programmatically
      viewModel.selectMenuItemById('profile');
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('profile_page')), findsOneWidget);
    });
  });
}
