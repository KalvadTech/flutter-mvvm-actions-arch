import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:getx_starter/src/modules/menu/data/models/menu_item.dart';

void main() {
  group('MenuItem', () {
    group('construction', () {
      test('creates menu item with required parameters', () {
        const menuItem = MenuItem(
          id: 'home',
          label: 'Home',
          icon: Icons.home,
        );

        expect(menuItem.id, equals('home'));
        expect(menuItem.label, equals('Home'));
        expect(menuItem.icon, equals(Icons.home));
        expect(menuItem.page, isNull);
      });

      test('creates menu item with page parameter', () {
        const testPage = Placeholder();
        const menuItem = MenuItem(
          id: 'home',
          label: 'Home',
          icon: Icons.home,
          page: testPage,
        );

        expect(menuItem.page, equals(testPage));
      });
    });

    group('equality', () {
      test('menu items with same id are equal', () {
        const item1 = MenuItem(
          id: 'home',
          label: 'Home',
          icon: Icons.home,
        );

        const item2 = MenuItem(
          id: 'home',
          label: 'Different Label',
          icon: Icons.house,
        );

        expect(item1, equals(item2));
      });

      test('menu items with different ids are not equal', () {
        const item1 = MenuItem(
          id: 'home',
          label: 'Home',
          icon: Icons.home,
        );

        const item2 = MenuItem(
          id: 'profile',
          label: 'Home',
          icon: Icons.home,
        );

        expect(item1, isNot(equals(item2)));
      });

      test('identical menu items are equal', () {
        const item = MenuItem(
          id: 'home',
          label: 'Home',
          icon: Icons.home,
        );

        expect(item, equals(item));
      });
    });

    group('hashCode', () {
      test('menu items with same id have same hashCode', () {
        const item1 = MenuItem(
          id: 'home',
          label: 'Home',
          icon: Icons.home,
        );

        const item2 = MenuItem(
          id: 'home',
          label: 'Different',
          icon: Icons.house,
        );

        expect(item1.hashCode, equals(item2.hashCode));
      });

      test('menu items with different ids have different hashCodes', () {
        const item1 = MenuItem(
          id: 'home',
          label: 'Home',
          icon: Icons.home,
        );

        const item2 = MenuItem(
          id: 'profile',
          label: 'Home',
          icon: Icons.home,
        );

        expect(item1.hashCode, isNot(equals(item2.hashCode)));
      });
    });

    group('toString', () {
      test('returns string representation with id and label', () {
        const menuItem = MenuItem(
          id: 'home',
          label: 'Home',
          icon: Icons.home,
        );

        final string = menuItem.toString();

        expect(string, contains('home'));
        expect(string, contains('Home'));
        expect(string, contains('MenuItem'));
      });
    });

    group('usage in collections', () {
      test('can be used in Sets', () {
        const item1 = MenuItem(id: 'home', label: 'Home', icon: Icons.home);
        const item2 = MenuItem(id: 'home', label: 'Home2', icon: Icons.house);
        const item3 = MenuItem(id: 'profile', label: 'Profile', icon: Icons.person);

        final set = {item1, item2, item3};

        // item1 and item2 have same id, so set should only have 2 items
        expect(set.length, equals(2));
      });

      test('can be used in Maps as keys', () {
        const item1 = MenuItem(id: 'home', label: 'Home', icon: Icons.home);
        const item2 = MenuItem(id: 'profile', label: 'Profile', icon: Icons.person);

        final map = {item1: 'page1', item2: 'page2'};

        expect(map[item1], equals('page1'));
        expect(map[item2], equals('page2'));
      });
    });
  });
}
