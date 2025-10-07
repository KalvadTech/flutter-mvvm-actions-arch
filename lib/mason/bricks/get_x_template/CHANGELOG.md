# Changelog

## 0.3.0 - 2025-10-07

### Added
- **Posts Example Module**: Complete reference implementation demonstrating API integration pattern
  - Uses JSONPlaceholder public API
  - Shows `apiFetch → ApiResponse → ApiHandler` pattern
  - Pull-to-refresh, error handling, loading states
- **Comprehensive Documentation**:
  - Enhanced README with architecture overview
  - Core components explanation
  - API integration pattern guide
  - Quick start checklist
- **Mason Brick Support**: Template now available as Mason brick
  - Configurable module selection
  - Project name and organization templating
  - Post-generation instructions

### Changed
- **Naming Standardization**:
  - Renamed `post_bindings.dart` → `posts_bindings.dart` (PostsBindings)
  - Renamed `connection_bindings.dart` → `connections_bindings.dart` (ConnectionsBindings)
  - Standardized `model` → `models` folders (plural)
- **ViewModel Initialization**: Use `onInit()` instead of constructor for initialization
- **Bindings Registration**: PostViewModel registered as permanent to persist across navigation
- **Documentation Updates**:
  - Added explicit naming conventions in coding guidelines
  - Module structure with `controllers/` vs `viewmodels/` clarification
  - API URL configuration best practices

### Removed
- **Grades Module**: Removed project-specific module in favor of universal Posts example

## 0.2.0 - 2025-10-02

### Added
- Infrastructure layer split: `core/` and `infrastructure/`
- Strategy-based HTTP response caching
- Unified storage facade: `AppStorageService`
- Secure token storage with `flutter_secure_storage`
- `ApiResponse<T>` with immutable design and `apiFetch` helper
- File download support with progress callbacks

### Changed
- `ApiService` hardening: better auth headers, retry logic, error mapping
- Moved `api_handler.dart` and `api_response.dart` to proper locations
- Auth module improvements: state machine fixes, validation

### Deprecated
- `MemoryService` deprecated in favor of `AppStorageService`

### Fixed
- Authorization header formatting
- Cache writes and error response caching
- Download file implementation

## 0.1.0 - 2025-08-15

### Added
- Initial template release
- MVVM + Actions Layer architecture
- Authentication module with login/register
- Connectivity monitoring module
- Localization module (Arabic/English)
- Theme switching module (Light/Dark)
- GetX state management
- ActionPresenter base class
- Basic documentation

### Features
- Username/password authentication
- Token management with refresh
- Real-time connectivity detection
- Multi-language support
- Material 3 theming
- Form validation
- Error handling with Sentry
