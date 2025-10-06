# Menu Module Documentation

## Overview

The menu module provides a side drawer navigation system with configurable menu items. The current menu pages (Dashboard, Settings, Profile) are **mock-ups for demonstration purposes only** and should be replaced with your actual application pages.

## Architecture

```
MenuPageWithDrawer (Main Container)
├── AppBar (with hamburger menu)
├── Drawer (SideMenuDrawer)
│   ├── Menu Items
│   ├── Settings (Theme, Language)
│   └── Logout
└── Body (Current selected page)
```

## Current Mock Pages

⚠️ **Important**: These are example pages, not functional implementations:

- **DashboardPage** - Sample dashboard with mock stats cards
- **SettingsPage** - Example settings layout with dummy options
- **ProfilePage** - Mock profile page with placeholder data

**Location**: `lib/src/modules/menu/views/sample_pages.dart`

These pages are meant to showcase the UI structure. Replace them with your actual application pages.

## Adding Menu Items

### Step 1: Create Your Page

Create your page widget in your module:

```dart
// lib/src/modules/your_module/views/your_page.dart
import 'package:flutter/material.dart';

class YourPage extends StatelessWidget {
  const YourPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Your Page Content'),
    );
  }
}
```

### Step 2: Configure Menu Items

Edit `lib/src/modules/menu/menu_bindings.dart`:

```dart
@override
List<MenuItem> configureMenuItems() {
  return [
    const MenuItem(
      id: 'your_page',           // Unique identifier
      label: 'Your Page',         // Display name in menu
      icon: Icons.your_icon,      // Menu icon
      page: YourPage(),           // Your page widget
    ),
    // Add more menu items...
  ];
}
```

### Step 3: Import Your Page

At the top of `menu_bindings.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'menu.dart';
import '/src/modules/your_module/views/your_page.dart'; // Add this
```

## Menu Item Model

```dart
class MenuItem {
  final String id;        // Unique identifier
  final String label;     // Display text
  final IconData icon;    // Menu icon
  final Widget? page;     // Page to display (optional)
}
```

## Complete Example

Replace the mock menu items with your real pages:

```dart
// lib/src/modules/menu/menu_bindings.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'menu.dart';
// Import your actual pages
import '/src/modules/home/views/home_page.dart';
import '/src/modules/products/views/products_page.dart';
import '/src/modules/orders/views/orders_page.dart';
import '/src/modules/account/views/account_page.dart';

class MenuBindings implements Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<MenuViewModel>()) {
      Get.lazyPut<MenuViewModel>(() {
        final viewModel = MenuViewModel();
        viewModel.configureMenu(configureMenuItems());
        return viewModel;
      });
    }
  }

  @override
  List<MenuItem> configureMenuItems() {
    return [
      const MenuItem(
        id: 'home',
        label: 'Home',
        icon: Icons.home,
        page: HomePage(),
      ),
      const MenuItem(
        id: 'products',
        label: 'Products',
        icon: Icons.inventory,
        page: ProductsPage(),
      ),
      const MenuItem(
        id: 'orders',
        label: 'Orders',
        icon: Icons.shopping_cart,
        page: OrdersPage(),
      ),
      const MenuItem(
        id: 'account',
        label: 'Account',
        icon: Icons.person,
        page: AccountPage(),
      ),
    ];
  }
}
```

## Accessing Pages

### Navigation Pattern: Side Drawer

1. **After login** → First menu item displays automatically
2. **Tap hamburger icon (☰)** in AppBar → Drawer opens
3. **Tap menu item** → Page displays, drawer closes

The hamburger icon is automatically added by Flutter when you have a drawer.

## Built-in Drawer Features

The side drawer includes:

### Settings Section
- **Theme Switcher**: Toggle between dark and light mode
- **Language Switcher**: Change app language (English/Arabic)

### Logout
- Logout button with confirmation dialog
- Clears session and returns to login

These are automatically included and don't need to be added as menu items.

## Customizing the Drawer

### Change Drawer Header

Edit `lib/src/modules/menu/views/side_menu_drawer.dart`:

```dart
Widget _buildDrawerHeader(BuildContext context) {
  return Container(
    // Your custom header design
  );
}
```

### Remove Settings Section

If you don't want theme/language switchers in the drawer:

```dart
// In side_menu_drawer.dart, remove:
const ThemeDrawerItem(),
const LanguageDrawerItem(),
```

### Remove Logout

```dart
// In side_menu_drawer.dart, remove:
const LogoutDrawerItem(),
```

## Programmatic Navigation

Navigate to menu items programmatically using MenuActions:

```dart
// Navigate by index
MenuActions.selectPage(0);  // First menu item

// Navigate by ID
MenuActions.selectPageById('products');

// Get current selection
int currentIndex = MenuActions.selectedIndex;
```

## Menu Structure Files

```
lib/src/modules/menu/
├── controllers/
│   └── menu_view_model.dart          # State management
├── data/
│   └── models/
│       └── menu_item.dart            # MenuItem model
├── views/
│   ├── menu_page_with_drawer.dart    # Main page with drawer
│   ├── side_menu_drawer.dart         # Drawer content
│   ├── menu_drawer_item.dart         # Individual menu item widget
│   ├── logout_drawer_item.dart       # Logout button
│   └── sample_pages.dart             # ⚠️ MOCK PAGES - REPLACE THESE
├── actions/
│   └── menu_actions.dart             # Navigation helpers
├── menu_bindings.dart                # 👈 CONFIGURE MENU HERE
└── menu.dart                         # Barrel export
```

## Best Practices

1. **Replace Mock Pages**: Don't use the sample pages in production
2. **Unique IDs**: Ensure each MenuItem has a unique `id`
3. **Consistent Icons**: Use Material Icons for consistent design
4. **Logical Order**: Place most important items first
5. **Limit Items**: Keep menu concise (3-7 items recommended)

## Migration from Mock Pages

To replace the mock pages:

1. **Delete or ignore** `sample_pages.dart`
2. **Create your pages** in their respective modules
3. **Update `menu_bindings.dart`** with your pages
4. **Remove imports** to sample_pages.dart if not needed

```dart
// Remove this import if deleting sample_pages.dart
// import 'views/sample_pages.dart';

// Replace with your actual pages
import '/src/modules/your_module/views/your_page.dart';
```

## Example: E-commerce App Menu

```dart
List<MenuItem> configureMenuItems() {
  return [
    const MenuItem(
      id: 'shop',
      label: 'Shop',
      icon: Icons.store,
      page: ShopPage(),
    ),
    const MenuItem(
      id: 'cart',
      label: 'Cart',
      icon: Icons.shopping_cart,
      page: CartPage(),
    ),
    const MenuItem(
      id: 'orders',
      label: 'My Orders',
      icon: Icons.receipt_long,
      page: OrdersPage(),
    ),
    const MenuItem(
      id: 'wishlist',
      label: 'Wishlist',
      icon: Icons.favorite,
      page: WishlistPage(),
    ),
    const MenuItem(
      id: 'profile',
      label: 'Profile',
      icon: Icons.person,
      page: ProfilePage(),
    ),
  ];
}
```

## Troubleshooting

**Q: Menu items not showing?**
- Check that `MenuBindings.configureMenuItems()` returns a non-empty list
- Verify imports are correct
- Ensure pages are valid widgets

**Q: Drawer doesn't open?**
- Tap the hamburger icon (☰) in the AppBar
- Or swipe from left edge of screen
- Make sure you're on MenuPage (logged in)

**Q: Page doesn't change when selecting menu item?**
- Ensure MenuItem has a `page` parameter
- Check that the page widget builds without errors
- Verify MenuViewModel is registered in bindings

**Q: Want bottom navigation instead of drawer?**
- ✅ **Already implemented!** See [NAVIGATION_TYPES.md](./NAVIGATION_TYPES.md)
- Simply replace `MenuPage()` with `MenuPageWithBottomNav()` in `auth.dart`
- Both navigation patterns are ready to use
