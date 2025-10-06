import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:getx_starter/src/modules/menu/controllers/menu_view_model.dart';
import 'package:getx_starter/src/modules/menu/data/models/menu_item.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MenuViewModel', () {
    late MenuViewModel viewModel;

    setUp(() {
      Get.testMode = true;
      viewModel = Get.put(MenuViewModel());
    });

    tearDown(() {
      Get.reset();
    });

    group('initialization', () {
      test('initializes with empty menu items', () {
        expect(viewModel.menuItems, isEmpty);
      });

      test('initializes with default page', () {
        expect(viewModel.currentPage, isA<Widget>());
      });

      test('initializes with zero selected index', () {
        expect(viewModel.selectedIndex, equals(0));
      });
    });

    group('configureMenu', () {
      test('configures menu with provided items', () {
        final items = [
          const MenuItem(id: 'home', label: 'Home', icon: Icons.home, page: Placeholder()),
          const MenuItem(id: 'profile', label: 'Profile', icon: Icons.person, page: Placeholder()),
        ];

        viewModel.configureMenu(items);

        expect(viewModel.menuItems.length, equals(2));
        expect(viewModel.menuItems[0].id, equals('home'));
        expect(viewModel.menuItems[1].id, equals('profile'));
      });

      test('sets first page as current when configuring menu', () {
        const firstPage = Placeholder(key: Key('first'));
        final items = [
          const MenuItem(id: 'home', label: 'Home', icon: Icons.home, page: firstPage),
          const MenuItem(id: 'profile', label: 'Profile', icon: Icons.person, page: Placeholder()),
        ];

        viewModel.configureMenu(items);

        expect(viewModel.currentPage, equals(firstPage));
      });

      test('sets selected index to 0 when configuring menu', () {
        viewModel.selectMenuItemByIndex(2);

        final items = [
          const MenuItem(id: 'home', label: 'Home', icon: Icons.home, page: Placeholder()),
        ];

        viewModel.configureMenu(items);

        expect(viewModel.selectedIndex, equals(0));
      });

      test('handles empty menu configuration', () {
        viewModel.configureMenu([]);

        expect(viewModel.menuItems, isEmpty);
        expect(viewModel.selectedIndex, equals(0));
      });
    });

    group('selectMenuItemByIndex', () {
      setUp(() {
        viewModel.configureMenu([
          const MenuItem(id: 'page1', label: 'Page 1', icon: Icons.looks_one, page: Placeholder(key: Key('page1'))),
          const MenuItem(id: 'page2', label: 'Page 2', icon: Icons.looks_two, page: Placeholder(key: Key('page2'))),
          const MenuItem(id: 'page3', label: 'Page 3', icon: Icons.looks_3, page: Placeholder(key: Key('page3'))),
        ]);
      });

      test('selects menu item by valid index', () {
        viewModel.selectMenuItemByIndex(1);

        expect(viewModel.selectedIndex, equals(1));
      });

      test('updates current page when selecting by index', () {
        const page2 = Placeholder(key: Key('page2'));
        viewModel.configureMenu([
          const MenuItem(id: 'page1', label: 'Page 1', icon: Icons.looks_one, page: Placeholder(key: Key('page1'))),
          const MenuItem(id: 'page2', label: 'Page 2', icon: Icons.looks_two, page: page2),
        ]);

        viewModel.selectMenuItemByIndex(1);

        expect(viewModel.currentPage, equals(page2));
      });

      test('ignores invalid index (negative)', () {
        viewModel.selectMenuItemByIndex(0);
        final initialIndex = viewModel.selectedIndex;

        viewModel.selectMenuItemByIndex(-1);

        expect(viewModel.selectedIndex, equals(initialIndex));
      });

      test('ignores invalid index (out of bounds)', () {
        viewModel.selectMenuItemByIndex(0);
        final initialIndex = viewModel.selectedIndex;

        viewModel.selectMenuItemByIndex(999);

        expect(viewModel.selectedIndex, equals(initialIndex));
      });

      test('does not change page if menu item has no page', () {
        const initialPage = Placeholder(key: Key('initial'));
        viewModel.configureMenu([
          const MenuItem(id: 'page1', label: 'Page 1', icon: Icons.looks_one, page: initialPage),
          const MenuItem(id: 'page2', label: 'Page 2', icon: Icons.looks_two), // No page
        ]);

        viewModel.selectMenuItemByIndex(1);

        expect(viewModel.currentPage, equals(initialPage));
      });
    });

    group('selectMenuItemById', () {
      setUp(() {
        viewModel.configureMenu([
          const MenuItem(id: 'home', label: 'Home', icon: Icons.home, page: Placeholder(key: Key('home'))),
          const MenuItem(id: 'profile', label: 'Profile', icon: Icons.person, page: Placeholder(key: Key('profile'))),
          const MenuItem(id: 'settings', label: 'Settings', icon: Icons.settings, page: Placeholder(key: Key('settings'))),
        ]);
      });

      test('selects menu item by valid id', () {
        viewModel.selectMenuItemById('profile');

        expect(viewModel.selectedIndex, equals(1));
      });

      test('updates current page when selecting by id', () {
        const profilePage = Placeholder(key: Key('profile'));
        viewModel.configureMenu([
          const MenuItem(id: 'home', label: 'Home', icon: Icons.home, page: Placeholder(key: Key('home'))),
          const MenuItem(id: 'profile', label: 'Profile', icon: Icons.person, page: profilePage),
        ]);

        viewModel.selectMenuItemById('profile');

        expect(viewModel.currentPage, equals(profilePage));
      });

      test('ignores invalid id', () {
        viewModel.selectMenuItemByIndex(0);
        final initialIndex = viewModel.selectedIndex;

        viewModel.selectMenuItemById('nonexistent');

        expect(viewModel.selectedIndex, equals(initialIndex));
      });
    });

    group('selectMenuItem', () {
      late MenuItem homeItem;
      late MenuItem profileItem;

      setUp(() {
        homeItem = const MenuItem(id: 'home', label: 'Home', icon: Icons.home, page: Placeholder(key: Key('home')));
        profileItem = const MenuItem(id: 'profile', label: 'Profile', icon: Icons.person, page: Placeholder(key: Key('profile')));

        viewModel.configureMenu([homeItem, profileItem]);
      });

      test('selects menu item by object reference', () {
        viewModel.selectMenuItem(profileItem);

        expect(viewModel.selectedIndex, equals(1));
      });

      test('updates current page when selecting by menu item', () {
        viewModel.selectMenuItem(profileItem);

        expect(viewModel.currentPage, equals(profileItem.page));
      });

      test('selects menu item with matching id even if different instance', () {
        const anotherProfileInstance = MenuItem(
          id: 'profile',
          label: 'Different Label',
          icon: Icons.person_outline,
        );

        viewModel.selectMenuItem(anotherProfileInstance);

        expect(viewModel.selectedIndex, equals(1));
      });

      test('ignores menu item not in list', () {
        const unknownItem = MenuItem(id: 'unknown', label: 'Unknown', icon: Icons.help);

        viewModel.selectMenuItemByIndex(0);
        final initialIndex = viewModel.selectedIndex;

        viewModel.selectMenuItem(unknownItem);

        expect(viewModel.selectedIndex, equals(initialIndex));
      });
    });

    group('isSelected', () {
      setUp(() {
        viewModel.configureMenu([
          const MenuItem(id: 'page1', label: 'Page 1', icon: Icons.looks_one, page: Placeholder()),
          const MenuItem(id: 'page2', label: 'Page 2', icon: Icons.looks_two, page: Placeholder()),
          const MenuItem(id: 'page3', label: 'Page 3', icon: Icons.looks_3, page: Placeholder()),
        ]);
      });

      test('returns true for selected index', () {
        viewModel.selectMenuItemByIndex(1);

        expect(viewModel.isSelected(1), isTrue);
      });

      test('returns false for non-selected index', () {
        viewModel.selectMenuItemByIndex(1);

        expect(viewModel.isSelected(0), isFalse);
        expect(viewModel.isSelected(2), isFalse);
      });

      test('returns false for invalid index', () {
        expect(viewModel.isSelected(-1), isFalse);
        expect(viewModel.isSelected(999), isFalse);
      });
    });

    group('reactive behavior', () {
      test('menu items is reactive', () {
        final items = [
          const MenuItem(id: 'home', label: 'Home', icon: Icons.home, page: Placeholder()),
        ];

        viewModel.configureMenu(items);

        expect(viewModel.menuItems.length, equals(1));

        final newItems = [
          const MenuItem(id: 'home', label: 'Home', icon: Icons.home, page: Placeholder()),
          const MenuItem(id: 'profile', label: 'Profile', icon: Icons.person, page: Placeholder()),
        ];

        viewModel.configureMenu(newItems);

        expect(viewModel.menuItems.length, equals(2));
      });

      test('selected index is reactive', () {
        viewModel.configureMenu([
          const MenuItem(id: 'page1', label: 'Page 1', icon: Icons.looks_one, page: Placeholder()),
          const MenuItem(id: 'page2', label: 'Page 2', icon: Icons.looks_two, page: Placeholder()),
        ]);

        expect(viewModel.selectedIndex, equals(0));

        viewModel.selectMenuItemByIndex(1);

        expect(viewModel.selectedIndex, equals(1));
      });

      test('current page is reactive', () {
        const page1 = Placeholder(key: Key('page1'));
        const page2 = Placeholder(key: Key('page2'));

        viewModel.configureMenu([
          const MenuItem(id: 'page1', label: 'Page 1', icon: Icons.looks_one, page: page1),
          const MenuItem(id: 'page2', label: 'Page 2', icon: Icons.looks_two, page: page2),
        ]);

        expect(viewModel.currentPage, equals(page1));

        viewModel.selectMenuItemByIndex(1);

        expect(viewModel.currentPage, equals(page2));
      });
    });

    group('edge cases', () {
      test('handles rapid menu item selection', () {
        viewModel.configureMenu([
          const MenuItem(id: 'page1', label: 'Page 1', icon: Icons.looks_one, page: Placeholder()),
          const MenuItem(id: 'page2', label: 'Page 2', icon: Icons.looks_two, page: Placeholder()),
          const MenuItem(id: 'page3', label: 'Page 3', icon: Icons.looks_3, page: Placeholder()),
        ]);

        expect(() {
          viewModel.selectMenuItemByIndex(0);
          viewModel.selectMenuItemByIndex(1);
          viewModel.selectMenuItemByIndex(2);
          viewModel.selectMenuItemByIndex(0);
        }, returnsNormally);

        expect(viewModel.selectedIndex, equals(0));
      });

      test('handles reconfiguration with different number of items', () {
        viewModel.configureMenu([
          const MenuItem(id: 'page1', label: 'Page 1', icon: Icons.looks_one, page: Placeholder()),
          const MenuItem(id: 'page2', label: 'Page 2', icon: Icons.looks_two, page: Placeholder()),
        ]);

        viewModel.selectMenuItemByIndex(1);

        viewModel.configureMenu([
          const MenuItem(id: 'page1', label: 'Page 1', icon: Icons.looks_one, page: Placeholder()),
        ]);

        expect(viewModel.selectedIndex, equals(0));
        expect(viewModel.menuItems.length, equals(1));
      });
    });
  });
}
