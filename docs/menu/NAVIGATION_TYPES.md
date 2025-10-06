# Menu Navigation Types

The template provides **two navigation patterns** ready to use. Choose the one that best fits your app's needs.

## 📱 Navigation Options

### 1. Side Drawer Navigation (Default)
**File**: `MenuPage` in `menu_page.dart`

```
┌─────────────────────┐
│  ☰  Title      ⚙    │ AppBar
├─────────────────────┤
│                     │
│   Page Content      │
│                     │
│                     │
└─────────────────────┘
```
- Hamburger menu (☰) opens drawer from left
- Menu items in side drawer
- Settings & logout in drawer
- Best for: 5+ menu items, deep navigation

### 2. Bottom Navigation Bar
**File**: `MenuPageWithBottomNav` in `menu_page_bottom_nav.dart`

```
┌─────────────────────┐
│     Title      ⚙    │ AppBar
├─────────────────────┤
│                     │
│   Page Content      │
│                     │
├─────────────────────┤
│ 🏠  ⚙️  👤  📊  ➕  │ Bottom Nav
└─────────────────────┘
```
- Settings icon (⚙) opens drawer from right
- Menu items in bottom bar
- Settings & logout in end drawer
- Best for: 3-5 main menu items

---

## 🔄 How to Switch

### Option 1: Side Drawer (Current Default)

**In `lib/src/modules/auth/views/auth.dart`:**

```dart
import '/src/modules/menu/menu.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthHandler(
      onAuthenticated: const MenuPage(),  // 👈 Side drawer version
      onNotAuthenticated: LoginPage(),
      onChecking: const SplashPage(),
    );
  }
}
```

### Option 2: Bottom Navigation

**In `lib/src/modules/auth/views/auth.dart`:**

```dart
import '/src/modules/menu/menu.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthHandler(
      onAuthenticated: const MenuPageWithBottomNav(),  // 👈 Bottom nav version
      onNotAuthenticated: LoginPage(),
      onChecking: const SplashPage(),
    );
  }
}
```

**That's it!** Just replace `MenuPage()` with `MenuPageWithBottomNav()`.

---

## 📋 Comparison

| Feature | Side Drawer | Bottom Navigation |
|---------|-------------|-------------------|
| **Menu Access** | Hamburger icon (☰) | Always visible |
| **Best For** | 5+ items | 3-5 items |
| **Settings Access** | In drawer | Settings icon (⚙) |
| **Screen Space** | More space for content | Bottom bar always visible |
| **One-Handed Use** | Harder to reach | Easy thumb access |
| **Material Design** | Classic pattern | Modern pattern |

---

## 🎨 Bottom Navigation Variants

### Material 3 Style (Default)
Uses `NavigationBar` widget:

```dart
bottomNavigationBar: const MenuBottomNavigation()
```

### Material 2 / Legacy Style
Uses classic `BottomNavigationBar`:

```dart
bottomNavigationBar: const MenuBottomNavigationLegacy()
```

To use legacy style, update `menu_page_bottom_nav.dart`:

```dart
// Replace this:
bottomNavigationBar: const MenuBottomNavigation(),

// With this:
bottomNavigationBar: const MenuBottomNavigationLegacy(),
```

---

## ⚙️ Customization

### Limit Bottom Nav Items

Bottom navigation works best with 3-5 items. The widget automatically limits to 5 items:

```dart
// In menu_bottom_navigation.dart
final items = controller.menuItems.take(5).toList();
```

To change the limit:

```dart
final items = controller.menuItems.take(4).toList();  // Max 4 items
```

### Add Settings to Bottom Nav Drawer

The bottom nav version has a settings drawer. To add theme/language/logout:

**In `menu_page_bottom_nav.dart`**, replace placeholder items:

```dart
// Import widgets
import '/src/modules/theme/theme.dart';
import '/src/modules/locale/locale.dart';

// In _buildSettingsItems():
Widget _buildSettingsItems() {
  return Column(
    children: [
      const ThemeDrawerItem(),       // Theme switcher
      const LanguageDrawerItem(),    // Language switcher
      const Divider(),
      const LogoutDrawerItem(),      // Logout button
    ],
  );
}
```

### Customize Drawer Header

For side drawer, edit `side_menu_drawer.dart`:

```dart
Widget _buildDrawerHeader(BuildContext context) {
  return Container(
    // Your custom design
  );
}
```

For bottom nav settings drawer, edit `menu_page_bottom_nav.dart`:

```dart
DrawerHeader(
  decoration: BoxDecoration(
    color: Theme.of(context).primaryColor,
  ),
  child: // Your custom design
)
```

---

## 🔧 Use Both Simultaneously

You can offer both options to users as a setting:

### 1. Add Navigation Type to Settings

```dart
// In settings or preferences
enum NavigationType { drawer, bottomNav }

class AppSettings {
  static NavigationType navigationType = NavigationType.drawer;
}
```

### 2. Switch Based on Setting

```dart
class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthHandler(
      onAuthenticated: AppSettings.navigationType == NavigationType.drawer
          ? const MenuPage()
          : const MenuPageWithBottomNav(),
      onNotAuthenticated: LoginPage(),
      onChecking: const SplashPage(),
    );
  }
}
```

### 3. Let Users Toggle

Add a setting to switch between navigation types at runtime.

---

## 📝 Quick Start Examples

### E-commerce App (Bottom Nav)

```dart
// 4 main sections
List<MenuItem> configureMenuItems() {
  return [
    MenuItem(id: 'shop', label: 'Shop', icon: Icons.store, page: ShopPage()),
    MenuItem(id: 'cart', label: 'Cart', icon: Icons.shopping_cart, page: CartPage()),
    MenuItem(id: 'orders', label: 'Orders', icon: Icons.receipt, page: OrdersPage()),
    MenuItem(id: 'profile', label: 'Profile', icon: Icons.person, page: ProfilePage()),
  ];
}
```

Use: **Bottom Navigation** ✅

### Admin Dashboard (Side Drawer)

```dart
// Many sections and sub-pages
List<MenuItem> configureMenuItems() {
  return [
    MenuItem(id: 'dashboard', label: 'Dashboard', icon: Icons.dashboard, page: DashboardPage()),
    MenuItem(id: 'users', label: 'Users', icon: Icons.people, page: UsersPage()),
    MenuItem(id: 'products', label: 'Products', icon: Icons.inventory, page: ProductsPage()),
    MenuItem(id: 'orders', label: 'Orders', icon: Icons.receipt, page: OrdersPage()),
    MenuItem(id: 'analytics', label: 'Analytics', icon: Icons.analytics, page: AnalyticsPage()),
    MenuItem(id: 'settings', label: 'Settings', icon: Icons.settings, page: SettingsPage()),
    MenuItem(id: 'reports', label: 'Reports', icon: Icons.assessment, page: ReportsPage()),
  ];
}
```

Use: **Side Drawer** ✅

---

## 🐛 Troubleshooting

**Q: Bottom nav items not showing?**
- Check that menu items are configured in `MenuBindings`
- Ensure maximum 5 items for bottom nav
- Verify `MenuPageWithBottomNav` is being used

**Q: Settings drawer doesn't open on bottom nav?**
- Tap the settings icon (⚙) in the AppBar (top-right)
- The drawer opens from the right side (`endDrawer`)

**Q: Want icons only (no labels) on bottom nav?**
- Use `NavigationBar` with `labelBehavior: NavigationDestinationLabelBehavior.alwaysHide`
- Or customize `MenuBottomNavigation` widget

**Q: Bottom nav overlaps content?**
- Ensure your page content accounts for bottom nav height
- Use `SafeArea` or padding bottom: `MediaQuery.of(context).padding.bottom + 80`

---

## 📚 Files Reference

```
lib/src/modules/menu/views/
├── menu_page.dart                   # Side drawer version
├── menu_page_bottom_nav.dart        # Bottom nav version
├── side_menu_drawer.dart            # Side drawer content
├── menu_bottom_navigation.dart      # Bottom nav bar widget
└── menu_drawer_item.dart            # Drawer menu item widget
```

## 🎯 Recommendation

- **3-5 main sections**: Use Bottom Navigation
- **5+ sections or nested navigation**: Use Side Drawer
- **Mobile-first app**: Bottom Navigation
- **Desktop/tablet app**: Side Drawer
- **When in doubt**: Start with Bottom Nav (easier to reach on mobile)

Both patterns are fully implemented and ready to use!
