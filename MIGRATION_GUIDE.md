# 🔄 Migration Guide

This guide helps you migrate from older versions of the template to the latest version with structural improvements.

## 📋 Table of Contents

- [Breaking Changes Overview](#breaking-changes-overview)
- [File Structure Changes](#file-structure-changes)
- [Import Path Updates](#import-path-updates)
- [API Changes](#api-changes)
- [Pattern Updates](#pattern-updates)
- [Step-by-Step Migration](#step-by-step-migration)

---

## 🚨 Breaking Changes Overview

### Major Refactoring (Latest)

**What Changed:**
1. **Core directory created** - Route management and bindings moved to `/src/core/`
2. **Utilities reorganized** - Better separation of concerns with extensions
3. **Cleaner APIs** - Removed redundant methods, improved naming
4. **Better dependency management** - AuthViewModel with state callbacks

**Impact:**
- Import paths changed for routing and bindings
- Some utility class methods replaced with extensions
- Validator method names simplified
- AuthBindings now handles feature module registration

---

## 📁 File Structure Changes

### 1. Core Directory Created

**Before:**
```
lib/src/
├── utils/
│   ├── route_manager.dart
│   ├── binding.dart
│   ├── screen_utils.dart
│   ├── validator.dart
│   └── date_time_utils.dart
```

**After:**
```
lib/src/
├── core/
│   ├── bindings/
│   │   └── bindings.dart          # Moved from utils/binding.dart
│   └── routing/
│       └── route_manager.dart     # Moved from utils/route_manager.dart
├── utils/
│   ├── responsive_utils.dart      # Renamed from screen_utils.dart
│   ├── form_validators.dart       # Renamed from validator.dart
│   ├── date_time_extensions.dart  # Changed from date_time_utils.dart
│   └── themes.dart
```

### 2. Barrel Export Updates

**`/src/core/core.dart`** (new):
```dart
export 'bindings/bindings.dart';
export 'routing/route_manager.dart';
export 'errors/app_exception.dart';
export 'presentation/api_response.dart';
export 'presentation/actions/action_presenter.dart';
```

**`/src/utils/utils.dart`** (updated):
```dart
export 'date_time_extensions.dart';  // Changed from date_time_utils.dart
export 'form_validators.dart';       // Changed from validator.dart
export 'responsive_utils.dart';      // Changed from screen_utils.dart
export 'themes.dart';

```

---

## 🔄 Import Path Updates

### 1. Route Manager

**Before:**
```dart
import '/src/utils/route_manager.dart';
// or
import '/src/utils/utils.dart';  // RouteManager not exported
```

**After:**
```dart
import '/src/core/core.dart';
// or
import '/src/core/routing/route_manager.dart';
```

### 2. Initial Bindings

**Before:**
```dart
import '/src/utils/binding.dart';
// or
import '/src/utils/utils.dart';
```

**After:**
```dart
import '/src/core/core.dart';
// or
import '/src/core/bindings/bindings.dart';
```

### 3. Validators

**Before:**
```dart
import '/src/utils/validator.dart';
```

**After:**
```dart
import '/src/utils/form_validators.dart';
// or
import '/src/utils/utils.dart';
```

### 4. Responsive Utilities

**Before:**
```dart
import '/src/utils/screen_utils.dart';
```

**After:**
```dart
import '/src/utils/responsive_utils.dart';
// or
import '/src/utils/utils.dart';
```

### 5. DateTime Utilities

**Before:**
```dart
import '/src/utils/date_time_utils.dart';
```

**After:**
```dart
import '/src/utils/date_time_extensions.dart';
// or
import '/src/utils/utils.dart';
```

---

## 🔧 API Changes

### 1. Form Validators - Simplified Names

**Before:**
```dart
TextFormField(
  validator: FormValidators.emailValidator,
)
```

**After:**
```dart
TextFormField(
  validator: FormValidators.email,
)
```

**All Changes:**
- `emailValidator` → `email`
- `phoneValidator` → `phone`
- `passwordValidator` → `password`
- `nameValidator` → `name`
- `usernameValidator` → `username`

**Migration:**
```dart
// Find and replace in your project:
FormValidators.emailValidator    → FormValidators.email
FormValidators.phoneValidator    → FormValidators.phone
FormValidators.passwordValidator → FormValidators.password
FormValidators.nameValidator     → FormValidators.name
FormValidators.usernameValidator → FormValidators.username
```

### 2. Responsive Utilities - Renamed Class

**Before:**
```dart
ScreenUtils.isMobile(context)
ScreenUtils.getFontSize(context, 16)
ScreenUtils.getScreenHeight(context, 0.5)
```

**After:**
```dart
ResponsiveUtils.isMobile(context)
ResponsiveUtils.scaledFontSize(context, 16)
ResponsiveUtils.screenHeight(context, 0.5)
```

**Migration:**
```dart
// Find and replace:
ScreenUtils → ResponsiveUtils
.getFontSize → .scaledFontSize
.getScreenHeight → .screenHeight
.getScreenWidth → .screenWidth
```

**New Features:**
```dart
// Device type detection
if (ResponsiveUtils.isMobile(context)) { }
if (ResponsiveUtils.isTablet(context)) { }
if (ResponsiveUtils.isDesktop(context)) { }
if (ResponsiveUtils.isWideDesktop(context)) { }

// Responsive values
double padding = ResponsiveUtils.valueByDevice(
  context,
  mobile: 16,
  tablet: 24,
  desktop: 32,
  wide: 40,
);

// Helpers
double padding = ResponsiveUtils.padding(context);
int columns = ResponsiveUtils.gridColumns(context);
```

### 3. DateTime - Changed to Extensions

**Before:**
```dart
DateTimeUtils.isToday(date)
DateTimeUtils.formatDate(date)
DateTimeUtils.timeAgo(date)
DateTimeUtils.formatDuration(duration)
```

**After:**
```dart
date.isToday
date.format()
date.timeAgo()
duration.format()
```

**All DateTime Extension Methods:**
```dart
// Date comparisons (getters)
date.isToday
date.isYesterday
date.isTomorrow

// Date comparisons (methods)
date.isSameDay(otherDate)
date.isSameMonth(otherDate)
date.isSameYear(otherDate)

// Date manipulation (getters)
date.startOfDay
date.endOfDay

// Calculations
date.daysBetween(otherDate)

// Formatting
date.format()                    // Default: dd/MM/yyyy
date.format('yyyy-MM-dd')
date.formatTime()                // Default: HH:mm
date.formatDateTime()            // Default: dd/MM/yyyy HH:mm
date.timeAgo()                   // "2 hours ago", "in 3 days"

// Duration extensions
duration.format()                // "02:05:30"
```

**Migration Example:**
```dart
// Before
if (DateTimeUtils.isToday(selectedDate)) {
  String formatted = DateTimeUtils.formatDate(selectedDate);
  String relative = DateTimeUtils.timeAgo(selectedDate);
}

// After
if (selectedDate.isToday) {
  String formatted = selectedDate.format();
  String relative = selectedDate.timeAgo();
}
```

### 4. Route Manager - Enhanced API

**Before:**
```dart
RouteManager.toRegisterPage();
Get.back();
Get.toNamed('/some-route');
Get.offNamed('/some-route');
```

**After:**
```dart
RouteManager.toRegister();
RouteManager.back();
RouteManager.to('/some-route');
RouteManager.off('/some-route');
```

**New Navigation Helpers:**
```dart
// Specific routes
RouteManager.toAuth();
RouteManager.toRegister();
RouteManager.toMenu();
RouteManager.toInitial();

// Auth flows
RouteManager.logout();         // Clear stack and go to auth
RouteManager.loginSuccess();   // Clear stack and go to menu

// Generic navigation
RouteManager.to('/route', arguments: data);
RouteManager.off('/route');
RouteManager.offAll('/route');
RouteManager.back(result: data);
RouteManager.until('/route');

// Utilities
String current = RouteManager.currentRoute;
bool isOnAuth = RouteManager.isCurrentRoute(RouteManager.authRoute);
dynamic args = RouteManager.arguments;
```

---

## 🎯 Pattern Updates

### 1. AuthViewModel - State Change Callbacks

**New Pattern:**
```dart
// AuthBindings now passes callbacks
class AuthBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthService(), fenix: true);
    Get.lazyPut(
      () => AuthViewModel(
        Get.find(),
        onAuthenticated: _onAuthenticated,
        onNotAuthenticated: _onNotAuthenticated,
      ),
    );
  }

  void _onAuthenticated() {
    // Register feature modules for logged-in users
    MenuBindings().dependencies();
    PostsBindings().dependencies();
  }

  void _onNotAuthenticated() {
    // Optional cleanup
  }
}
```

**Why This Matters:**
- AuthViewModel no longer depends on Menu/Posts modules
- Better separation of concerns
- Feature modules only loaded when needed
- More testable

### 2. InitialBindings - Simplified

**Before:**
```dart
class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(ConnectionViewModel(), permanent: true);
    ThemeBindings().dependencies();
    LocaleBindings().dependencies();
    AuthBindings().dependencies();
    MenuBindings().dependencies();
    PostsBindings().dependencies();
  }
}
```

**After:**
```dart
class InitialBindings extends Bindings {
  @override
  void dependencies() {
    // Only core, permanent dependencies
    ConnectionsBindings().dependencies();
    ThemeBindings().dependencies();
    LocaleBindings().dependencies();

    // Auth, Menu, Posts registered via route bindings
    // and auth success callbacks
  }
}
```

**Why This Matters:**
- Smaller initial bundle
- Feature modules loaded on-demand
- Clearer dependency lifecycle

---

## 📝 Step-by-Step Migration

### Step 1: Update Imports

Run these find-and-replace operations across your project:

```dart
// Route Manager
"/src/utils/route_manager.dart" → "/src/core/routing/route_manager.dart"
"/src/utils/binding.dart" → "/src/core/bindings/bindings.dart"

// Or use barrel exports
"/src/utils/route_manager.dart" → "/src/core/core.dart"
"/src/utils/binding.dart" → "/src/core/core.dart"

// Utilities
"/src/utils/validator.dart" → "/src/utils/form_validators.dart"
"/src/utils/screen_utils.dart" → "/src/utils/responsive_utils.dart"
"/src/utils/date_time_utils.dart" → "/src/utils/date_time_extensions.dart"
```

### Step 2: Update Validator Calls

```dart
// Find and replace
FormValidators.emailValidator → FormValidators.email
FormValidators.phoneValidator → FormValidators.phone
FormValidators.passwordValidator → FormValidators.password
FormValidators.nameValidator → FormValidators.name
FormValidators.usernameValidator → FormValidators.username
```

### Step 3: Update Responsive Utils

```dart
// Find and replace
ScreenUtils → ResponsiveUtils
.getFontSize → .scaledFontSize
.getScreenHeight → .screenHeight
.getScreenWidth → .screenWidth
```

### Step 4: Convert DateTime Utilities to Extensions

```dart
// Before
DateTimeUtils.isToday(date)
DateTimeUtils.formatDate(date)
DateTimeUtils.timeAgo(date)
DateTimeUtils.formatDuration(duration)

// After
date.isToday
date.format()
date.timeAgo()
duration.format()
```

### Step 5: Update Navigation Calls

```dart
// Replace direct Get calls with RouteManager
Get.back() → RouteManager.back()
Get.toNamed('/route') → RouteManager.to('/route')
Get.offNamed('/route') → RouteManager.off('/route')
Get.offAllNamed('/route') → RouteManager.offAll('/route')
```

### Step 6: Update Custom Bindings (if any)

If you created custom feature bindings, update how they're registered:

```dart
// Before: Registered in InitialBindings
class InitialBindings extends Bindings {
  void dependencies() {
    // ...
    MyFeatureBindings().dependencies();
  }
}

// After: Register via route binding or auth callback
GetPage(
  name: '/my-feature',
  page: () => MyFeaturePage(),
  binding: MyFeatureBindings(),
)

// Or in AuthBindings if auth-only:
void _onAuthenticated() {
  MenuBindings().dependencies();
  PostsBindings().dependencies();
  MyFeatureBindings().dependencies();  // Add here
}
```

### Step 7: Run Analysis

```bash
flutter analyze
flutter test
```

---

## ✅ Migration Checklist

- [ ] Update all imports for `route_manager.dart`
- [ ] Update all imports for `binding.dart`
- [ ] Update all imports for validators/responsive/datetime
- [ ] Replace `FormValidators.*Validator` with short names
- [ ] Replace `ScreenUtils` with `ResponsiveUtils`
- [ ] Convert `DateTimeUtils.*` to extension methods
- [ ] Replace `Get.back()` / `Get.toNamed()` with `RouteManager.*`
- [ ] Review custom bindings registration
- [ ] Run `flutter analyze` - fix any errors
- [ ] Run tests - ensure nothing broke
- [ ] Update team documentation
- [ ] Test app thoroughly

---

## 🆘 Troubleshooting

### Import Errors

**Error:** `Undefined name 'RouteManager'`
**Fix:** Update import from `/src/utils/route_manager.dart` to `/src/core/core.dart`

**Error:** `Undefined name 'ScreenUtils'`
**Fix:** Replace with `ResponsiveUtils` and update import

**Error:** `Undefined class 'DateTimeUtils'`
**Fix:** Replace static methods with extension methods (e.g., `date.isToday`)

### Validator Errors

**Error:** `The getter 'emailValidator' isn't defined for 'FormValidators'`
**Fix:** Use short name: `FormValidators.email`

### Navigation Errors

**Error:** `The method 'toRegisterPage' isn't defined for 'RouteManager'`
**Fix:** Use new name: `RouteManager.toRegister()`

---

## 💡 Benefits of These Changes

1. **Better Organization**: Core framework code separated from utilities
2. **Cleaner APIs**: Extensions feel more natural than static utility methods
3. **Less Boilerplate**: Shorter method names, more intuitive usage
4. **Better Performance**: Feature modules loaded on-demand
5. **More Testable**: Better separation of concerns
6. **Improved DX**: Better autocomplete and discoverability

---

## 📞 Need Help?

If you encounter issues during migration:

1. Check this guide's troubleshooting section
2. Review the CHANGELOG.md for detailed changes
3. Check the updated coding guidelines in `docs/architecture/coding_guidelines.md`
4. Open an issue on GitHub with migration questions

---

**Last Updated:** 2025-01-08
