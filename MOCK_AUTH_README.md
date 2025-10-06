# Mock Authentication Guide

## Overview

The app now includes mock authentication for manual testing without requiring a backend server.

## How to Use

### 1. Enable Mock Mode

Mock authentication is controlled by the `_useMockAuth` constant in `auth_service.dart`:

```dart
// lib/src/modules/auth/data/services/auth_service.dart
const bool _useMockAuth = true;  // Set to false to use real API
```

**Current Status**: Mock mode is **ENABLED** (`true`)

### 2. Sign In with Any Credentials

When mock mode is enabled:
- **Any username/email** will work
- **Any password** will work
- No backend connection required

#### Examples:
```
Username: test@example.com
Password: password123

Username: admin
Password: 1234

Username: anything
Password: works
```

All combinations will successfully log you in!

### 3. What Happens During Mock Sign-In

1. **Network Delay Simulation**: 500ms delay to simulate real network request
2. **JWT Token Generation**: Creates valid JWT tokens that can be decoded
3. **Token Storage**: Saves tokens to secure storage
4. **Session Management**: Tokens are valid for:
   - Access Token: 1 day (for testing refresh)
   - Refresh Token: 7 days

### 4. Features Supported in Mock Mode

- ✅ Sign In
- ✅ Sign Up (accepts any data)
- ✅ Token Refresh (generates new access token)
- ✅ Sign Out
- ✅ Session Persistence
- ✅ Token Expiry Checks

### 5. Switching to Real API

When you're ready to connect to a real backend:

1. Open `lib/src/modules/auth/data/services/auth_service.dart`
2. Change the flag:
   ```dart
   const bool _useMockAuth = false;  // Now uses real API
   ```
3. Ensure your API endpoints are configured in `lib/src/config/api_config.dart`

## Technical Details

### Mock JWT Tokens

The mock authentication generates real JWT tokens with:
- **Header**: `{ "alg": "HS256", "typ": "JWT" }`
- **Payload**: Contains `sub` (subject), `iat` (issued at), `exp` (expiry), and `type`
- **Signature**: Mock signature (not cryptographically secure, for testing only)

The tokens are properly base64url encoded and can be decoded by the `jwt_decoder` package.

### Token Expiry

- **Access Token**: Expires after 1 day (allows testing token refresh)
- **Refresh Token**: Expires after 7 days
- The app automatically refreshes expired access tokens using the refresh token

## Important Notes

⚠️ **Security Warning**: Mock authentication should **NEVER** be used in production builds!

⚠️ **Before Release**: Always set `_useMockAuth = false` before releasing to production

✅ **Development Only**: This feature is intended for:
- Manual UI/UX testing
- Development without backend
- Demonstrating the app
- Testing navigation flows

## Testing the App

1. Run the app: `flutter run`
2. You'll see the login screen
3. Enter any credentials (e.g., `test` / `test`)
4. Click "Login"
5. You should be authenticated and see the main app screen

## Troubleshooting

**Problem**: App shows "No Session" error after login

**Solution**: Check that:
- `_useMockAuth` is set to `true`
- You're entering some value in both username and password fields
- The form validation is passing

**Problem**: Want to test logout/login flow

**Solution**:
1. Navigate to logout option in the app
2. Logout clears all tokens
3. You'll be redirected to login screen
4. Can login again with any credentials
