import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:getx_starter/src/modules/menu/views/menu_drawer_item.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MenuDrawerItem Widget Tests', () {
    testWidgets('renders without errors', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MenuDrawerItem(
              label: 'Home',
              icon: Icons.home,
              isSelected: false,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byType(MenuDrawerItem), findsOneWidget);
    });

    testWidgets('displays label text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MenuDrawerItem(
              label: 'Home',
              icon: Icons.home,
              isSelected: false,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('displays icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MenuDrawerItem(
              label: 'Home',
              icon: Icons.home,
              isSelected: false,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.home), findsOneWidget);
    });

    testWidgets('shows selected state with background color', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MenuDrawerItem(
              label: 'Home',
              icon: Icons.home,
              isSelected: true,
              onTap: () {},
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(MenuDrawerItem),
          matching: find.byType(Container),
        ).first,
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, isNotNull);
      expect(decoration.color, isNot(Colors.transparent));
    });

    testWidgets('shows transparent background when not selected', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MenuDrawerItem(
              label: 'Home',
              icon: Icons.home,
              isSelected: false,
              onTap: () {},
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(MenuDrawerItem),
          matching: find.byType(Container),
        ).first,
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, equals(Colors.transparent));
    });

    testWidgets('calls onTap when tapped', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MenuDrawerItem(
              label: 'Home',
              icon: Icons.home,
              isSelected: false,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(MenuDrawerItem));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('has rounded border radius', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MenuDrawerItem(
              label: 'Home',
              icon: Icons.home,
              isSelected: false,
              onTap: () {},
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(MenuDrawerItem),
          matching: find.byType(Container),
        ).first,
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, isNotNull);
    });

    testWidgets('icon and label are horizontally arranged', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MenuDrawerItem(
              label: 'Home',
              icon: Icons.home,
              isSelected: false,
              onTap: () {},
            ),
          ),
        ),
      );

      final row = find.descendant(
        of: find.byType(MenuDrawerItem),
        matching: find.byType(Row),
      );

      expect(row, findsOneWidget);
    });

    testWidgets('multiple drawer items can be displayed', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: [
                MenuDrawerItem(
                  label: 'Home',
                  icon: Icons.home,
                  isSelected: true,
                  onTap: () {},
                ),
                MenuDrawerItem(
                  label: 'Profile',
                  icon: Icons.person,
                  isSelected: false,
                  onTap: () {},
                ),
                MenuDrawerItem(
                  label: 'Settings',
                  icon: Icons.settings,
                  isSelected: false,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(MenuDrawerItem), findsNWidgets(3));
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('has InkWell for tap feedback', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MenuDrawerItem(
              label: 'Home',
              icon: Icons.home,
              isSelected: false,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.descendant(
        of: find.byType(MenuDrawerItem),
        matching: find.byType(InkWell),
      ), findsOneWidget);
    });
  });
}
