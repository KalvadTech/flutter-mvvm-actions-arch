# getX_starter

A Flutter application template using getX for state management with pre defined modules and widgets for authentication, connection, localization and theme.

See also: docs/architecture/coding_guidelines.md for naming and coding standards used by this template.

For a full log of changes, migrations, and deprecations, see: CHANGELOG.md


## Getting Started

### Installation
you can use the template in two ways:-

#### Manual
clone the project to your pc and then copy the src directory to your new flutter project lib directory. or only copy the desired modules.
note: if you want to copy only modules make sure you copy the configuration files or other files you need.

#### Mason CLI
<p align="center">
<img src="https://raw.githubusercontent.com/felangel/mason/master/assets/mason_full.png" height="125" alt="mason logo" />
</p>

<p align="center">
<a href="https://pub.dev/packages/mason"><img src="https://img.shields.io/pub/v/mason.svg" alt="Pub"></a>
<a href="https://github.com/felangel/mason/actions"><img src="https://github.com/felangel/mason/workflows/mason/badge.svg" alt="mason"></a>
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>
</p>

you will have to install mason cli to your device first check out mason for that.
after you install mason you can add the template to your global bricks using command

```sh
mason add -g --source git https://github.com/KalvadTech/getX-template --path lib/mason/bricks/get_x_template
```

after that you can call 

```sh
mason list
///or
mason ls

```
you should see something like that in the output
get_x_template - A Flutter application template using getX for state management with pre defined modules for authentication, connections and localizations.


now you can use template in every flutter project from your command line. create new flutter project open your terminal then navigate to lib folder and use command

```sh
mason make get_x_template
```

#### Packages
Remember to add these packages to your pubspec.yaml file (versions indicative; prefer keeping them in sync with this template's pubspec):

```yaml
  get: ^4.6.6
  loader_overlay: ^4.0.3
  flutter_spinkit: ^5.2.1
  connectivity_plus: ^6.1.0
  flutter_svg: ^2.0.13
  get_storage: ^2.1.1
  google_fonts: ^6.2.1
  intl: ^0.19.0
  jwt_decoder: ^2.0.1
  path_provider: ^2.1.5
  flutter_secure_storage: ^9.2.2
```





### Modules
you can find all pre defined modules inside the modules directory.

### Infrastructure Overview
This template splits cross-cutting concerns into clear layers:
- core/: primitives and errors (e.g., src/core/errors/app_exception.dart)
- infrastructure/: concrete adapters
  - http/: ApiService centralizes headers, retry-after-refresh, error mapping, logging, and optional caching.
  - cache/: strategy-based caching (CacheStore, CacheKeyStrategy, CachePolicy, CacheManager). Disabled when not configured; enable at startup.
  - storage/: PreferencesStorage (GetStorage), SecureTokenStorage (Keychain/Keystore), and AppStorageService facade.

Initialize storage and enable caching in main():
```
await AppStorageService.instance.initialize();
final store = await GetStorageCacheStorage.create(container: AppStorageService.container);
final cache = CacheManager(
  store,
  const DefaultCacheKeyStrategy(),
  SimpleTimeToLiveCachePolicy(timeToLive: Duration(hours: 6)),
);
ApiService.configureCache(cache);
```

### Storage facade and deprecation
- Use AppStorageService as the unified facade for device-local storage (preferences + secure tokens).
- MemoryService is deprecated. Do not use it in new code. Migrate existing references to AppStorageService.

### Caching
- ApiService.get uses cache by default; writes (post/put/delete) do not cache unless opted in.
- Cache stores raw response text and decoding happens in ApiService using the provided decoder.
- Disable globally by calling `ApiService.configureCache(null)`.

### File downloads
The ApiService.downloadFile method reuses GetConnect.get with `ResponseType.bytes` for uniform behavior and headers (including retry-after-refresh). It honors ApiService’s timeout and logging, then writes the received bytes to disk. Because GetConnect returns the full body, the optional progress callback reports completion once bytes are written. If you need true streaming progress or proxy/certificate customization, you can implement a specialized downloader as needed.


#### Authentication
contain default login and register process using username and password with validation and logic. you can use default login and register pages or customize them.
go to config/api-config and put your own api urls and routes then go to data/models/user.dart and update user model to meet your api response.


#### connections
handle the connectivity, check if the user is connected to through wifi or mobile data and have internet access or no. contain two widget one for splash screen with connection check. one stack widget for showing connectivity status changes, you can use it to show status throw all pages or for only one page.


#### Localizations
handle the languages changes, check what is the user preferred language in the app and handle the translation of the strings inside the app. all you have to do is go to modules/locale/localization_view_model and add your supported languages. Then add string keys to config/keys. Inside module/locale/lang create a new file for your keys translation. it's already ready for use for arabic and english.


#### Theme
handle the light and dark theme changing. contain custom widget for changing the theme. you can use ThemeSwitch to implement a switch to change the theme from dark to light and vise versa or use the ThemeDrawerItem if you want a icon title leading widget.




A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
