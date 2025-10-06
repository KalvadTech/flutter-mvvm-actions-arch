# Menu Module Usage Guide

## How the Menu Works

The menu module uses a **side drawer navigation** pattern (not bottom navigation).

### Navigation Flow

```
Login (Mock Auth)
    ↓
MenuPage displays
    ├─ AppBar with title "Dashboard"
    ├─ Hamburger menu icon (☰) on the left
    └─ Dashboard page content in body
```

### Accessing Menu Items

1. **After Login**: You'll see the Dashboard page automatically
2. **Open Menu**: Click the **hamburger icon (☰)** in the top-left of the AppBar
3. **Side Drawer Opens** with:
   - 📊 Dashboard
   - ⚙️ Settings
   - 👤 Profile
   - **Settings Section:**
     - 🌙 Theme (Dark/Light)
     - 🌍 Language
   - 🚪 Logout

4. **Select Page**: Tap any menu item → page changes, drawer closes

## Menu Structure

```
MenuPage (Scaffold)
├── AppBar
│   ├── Leading: Hamburger Icon (auto-added by Flutter)
│   └── Title: Current page name
├── Drawer: SideMenuDrawer
│   ├── App Logo & Name
│   ├── Menu Items (Dashboard, Settings, Profile)
│   ├── Divider
│   ├── Settings Section
│   │   ├── Theme Switcher
│   │   └── Language Switcher
│   ├── Divider
│   └── Logout
└── Body: Current selected page content
```

## Available Pages

### 1. Dashboard Page
- Stats cards (Projects, Tasks, Alerts, Completed)
- Recent activity feed
- Scrollable content

### 2. Settings Page
- Account section (Profile, Privacy)
- Preferences section (Notifications, Storage)
- About section (App Info, Help)

### 3. Profile Page
- User avatar
- User information cards
- Edit profile button

## Testing the Menu

### Step 1: Login
```
Username: test
Password: test
(or any credentials - mock auth accepts all)
```

### Step 2: You Should See
- Dashboard page with stats cards
- AppBar with "Dashboard" title
- Hamburger menu icon (☰) in top-left

### Step 3: Open Drawer
- Click the hamburger icon
- Drawer slides in from left
- Shows all menu items and settings

### Step 4: Navigate
- Tap "Settings" → Settings page displays
- Tap "Profile" → Profile page displays
- AppBar title updates automatically

## Customizing Menu Items

Edit `lib/src/modules/menu/menu_bindings.dart`:

```dart
@override
List<MenuItem> configureMenuItems() {
  return [
    const MenuItem(
      id: 'dashboard',
      label: 'Dashboard',
      icon: Icons.dashboard,
      page: DashboardPage(),
    ),
    // Add your custom pages here
  ];
}
```

## Why Side Drawer (Not Bottom Navigation)?

This template uses a **side drawer** pattern because:
- ✅ Works well with hamburger menu
- ✅ Doesn't take up screen space
- ✅ Can fit many menu items
- ✅ Supports settings and logout naturally
- ✅ Common pattern in Material Design

If you prefer **bottom navigation**, you would need to:
1. Replace `drawer` with `bottomNavigationBar` in MenuPage
2. Create a BottomNavigationBar widget
3. Update MenuViewModel to work with bottom nav

## Troubleshooting

**Problem**: Don't see hamburger menu icon

**Solution**:
- The icon is auto-added by Flutter when `drawer` is present
- Make sure you're logged in (not on login screen)
- Check that MenuPage is rendering (should see Dashboard content)

**Problem**: Drawer doesn't open

**Solution**:
- Tap the hamburger icon in the AppBar (top-left)
- Or swipe from left edge of screen
- Make sure MenuBindings is loaded (check that pages have content)

**Problem**: Menu items not showing

**Solution**:
1. Check MenuBindings.configureMenuItems() is being called
2. Verify MenuViewModel.menuItems is not empty
3. Check console for any binding errors

## Current Configuration

**Menu Items:**
- Dashboard (Icons.dashboard)
- Settings (Icons.settings)
- Profile (Icons.person)

**Settings:**
- Theme Switcher (Dark/Light mode)
- Language Switcher (English/Arabic)

**Actions:**
- Logout (with confirmation dialog)

## Architecture

```
MenuPage (UI)
    ↓
MenuViewModel (State)
    ↓
MenuBindings (Configuration)
    ↓
MenuItem Model (Data)
```

The menu is fully reactive using GetX:
- Change page → ViewModel updates → UI rebuilds
- Theme change → All UI updates automatically
- Language change → Text updates automatically
