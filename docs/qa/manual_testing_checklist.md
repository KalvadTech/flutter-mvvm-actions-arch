# QA Manual Testing Checklist

Status: added | Last updated: 2025-10-06 11:05

This document provides a practical, step-by-step checklist to validate the app’s main behaviors on a simulator or device: connectivity overlay/handler, auth flows, networking and caching, storage, theming, and error/loader UX. Each item includes how to test and what you should observe.


## 1) App boot and shell smoke test
- What to test
  - The app boots into the auth gate and the global connectivity overlay is attached on top of GetMaterialApp.
- How to test
  - Run: `flutter run -d <your_simulator>`.
  - On launch, you should briefly see a connecting bar if the device is still probing, then it should disappear once reachability is confirmed.
  - Navigate around; the overlay should be globally available (appears on any screen when states change).
- Expected
  - No crash on launch. The overlay appears only during `connecting` or offline states and hides when connected.


## 2) Connectivity UX: connecting, offline, no-internet
- What to test
  - ConnectionOverlay surfaces:
    - Shows a non-blocking bar for `connecting`.
    - Shows a full-width card for `disconnected` and `noInternet`.
  - ConnectionHandler gating:
    - Renders `onConnectingWidget` while probing.
    - Renders `connectedWidget` only when truly connected (`wifi` or `mobileData`).
    - Shows retry UI when offline; retry only fires on tap.
- How to test (Android Emulator)
  - Use Emulator Extended Controls → Cellular → turn off/limit data; and Wi‑Fi → turn off to simulate `disconnected`.
  - Re-enable Wi‑Fi/Cellular, then immediately open a page with network usage to observe `connecting` then success.
  - Optional: Add bad DNS in host OS or block your test endpoint with a tool (e.g., Little Snitch/Charles) to simulate `noInternet`. Alternatively, temporarily configure `ReachabilityService(host: 'nonexistent.invalid')` in ConnectionBindings to force `noInternet`.
- How to test (iOS Simulator)
  - iOS Simulator doesn’t have a direct Wi‑Fi toggle, so simulate by disconnecting your Mac from the internet or blocking the endpoint (proxy/firewall). Network Link Conditioner (Additional Tools for Xcode) can help.
- Expected
  - Connecting: small bar using `colorScheme.surfaceVariant` and a spinner.
  - No internet/disconnected: full card using `errorContainer/onErrorContainer` with a timer; tapping Refresh triggers `ConnectionActions.instance.checkConnectivity()`.
  - `connectedWidget` never shows while connecting.


## 3) Connectivity lifecycle and debounce
- What to test
  - Re-check on app resume and reduced flapping via debounce.
- How to test
  - Put the app into background and resume (Android: Home; iOS: Cmd+Shift+H then re-open). The overlay should re-evaluate connectivity within ~1s.
  - Rapidly toggle network settings and confirm the overlay doesn’t flicker excessively. The 250 ms debounce should smooth transitions.
- Expected
  - On resume, if the network changed, the overlay updates promptly.
  - No rapid flicker between states during quick toggles.


## 4) Offline timer and telemetry callbacks
- What to test
  - Timer starts once when entering `disconnected` or `noInternet` and resets on reconnect.
  - Telemetry hooks are available (even if you don’t wire them yet).
- How to test
  - Go offline for ~5–10 seconds, watch the timer increment in the offline card.
  - Reconnect and confirm the overlay disappears and the timer resets.
  - Optional: Pass dummy callbacks in `ConnectionViewModel` (via ConnectionBindings) to log transitions to console and verify they trigger once per transition.
- Expected
  - Timer increments once per second, no duplicate timers, resets on reconnection.


## 5) Auth flows: sign-in, sign-up, logout
- What to test
  - Form validation and action orchestration via `AuthActions` + loader overlay + snackbars.
  - Token persistence/clearing via `AppStorageService`.
- How to test (with a reachable backend)
  - Login: Enter valid/invalid credentials. On submit, loader overlay appears; success → success snackbar; failure → error snackbar.
  - Sign-up: Navigate from login to register. Submit valid data; loader overlay shows; success → route pops (if possible) and snackbar prompts login.
  - Logout: Trigger logout from menu; state switches to `notAuthenticated` and login screen shows.
- How to test (without a real backend)
  - Point API URLs to a local mock (Mockoon/JSON Server) that returns expected shapes:
    - Sign-in response must be `{ "access": "<jwt>", "refresh": "<jwt>" }`.
    - Refresh endpoint must return `{ "access": "<jwt>" }`.
- Expected
  - Overlay loader shows/hides safely; snackbars render; navigation is guarded (no crashes).
  - After sign-in, protected screens appear; after logout, back to login.


## 6) Networking guarantees: headers, 401 refresh+retry, error mapping
- What to test
  - Header rule: when you pass `headers` to ApiService, they’re used as-is; otherwise `getAuthorizedHeader()` is applied and `Authorization` is only included if a token exists.
  - On 401, a single refresh attempt occurs; if refresh succeeds, the original request retries once.
  - Error mapping avoids secondary decode errors and produces typed exceptions.
- How to test
  - Use a mock API to force scenarios:
    - Normal 200 JSON → success; logs in debug should redact `Authorization`.
    - 401 on initial request, then a successful refresh endpoint returns a new `access`, and the re-tried request returns 200.
    - 404/408/500 to confirm exceptions (`APIException`, timeouts) map and show snackbars via `ActionPresenter` where used.
- Expected
  - Bearer header only when you have a token; no extra leading/trailing spaces.
  - Exactly one refresh attempt on 401, then retry; if refresh fails, final error is thrown.
  - Debug logs redact token and truncate long responses.


## 7) Caching behavior (GET default, writes opt-in)
- What to test
  - GET requests are cached by default; POST/PUT/DELETE are not unless opted in.
  - Cache keys include method, URL with sorted query, and a compact header fingerprint (language, auth presence) — not the token.
  - Errors are never cached.
- How to test
  - Choose a deterministic GET endpoint (e.g., `/public/list`).
  - First run online: confirm network hit.
  - Without changing query or language/auth presence, request again and observe a cache hit path (debug prints/logs may indicate).
  - Turn off internet and call the same GET with `useCache: true`. If it’s cached and not expired, you should still get data from cache.
  - Change `Accept-Language` or toggle auth presence (sign-in/out) and confirm the cache key changes (no accidental cross-user or cross-language cache hits).
- Expected
  - Repeat GETs serve from cache; offline reads succeed when data is cached; writes do not cache by default.


## 8) Secure storage and preferences
- What to test
  - Tokens live in secure storage with in-memory caches; preferences in `GetStorage`.
- How to test
  - After sign-in, kill and relaunch the app; `AuthViewModel.checkSession()` should authenticate without re-login (if tokens valid).
  - On logout, relaunch; it should show login.
  - Optionally, inspect the simulator’s keychain/keystore via platform tools to verify tokens are not in plaintext preferences.
- Expected
  - Session persists across restarts until logout or expiry; clearing tokens logs out deterministically.


## 9) Loader overlay and error surfaces safety
- What to test
  - `ActionPresenter` guards `loaderOverlay` show/hide and navigator usage.
- How to test
  - Trigger actions (sign-in/up) from screens with and without a `GlobalLoaderOverlay`/`Navigator` (e.g., a minimal shell or a dialog context) and ensure no crashes; errors are reported to Sentry (in debug, it’ll just call the method).
- Expected
  - No exceptions if overlay/navigator is missing; user feedback still shows where possible.


## 10) Theming and accessibility
- What to test
  - Material 3 rosy‑red theme application.
  - Overlay colors use `ColorScheme.surfaceVariant` (connecting) and `errorContainer/onErrorContainer` (offline).
  - Basic `Semantics` labels for screen readers.
- How to test
  - Toggle light/dark mode in the simulator and confirm legibility/contrast.
  - Use accessibility inspector (VoiceOver/TalkBack) to confirm labels like “Reconnecting” and “No internet connection” are exposed.
- Expected
  - Consistent M3 styling, adequate contrast, and basic accessibility semantics.


## 11) Performance sanity checks
- What to test
  - No jank when the overlay appears/disappears.
  - Debounce prevents redundant rebuilds.
- How to test
  - Enable Flutter Performance Overlay (press `P` in `flutter run` for debug or use DevTools) and toggle connectivity; verify no large frame spikes.
- Expected
  - Smooth transitions; minimal rebuilds.


## 12) Suggested tester scripts and quick toggles
- Run app
  - `flutter run -d ios` or `flutter run -d emulator-5554` (Android).
- Hot reload
  - Press `r` for hot reload, `R` for hot restart in the terminal.
- Android emulator network toggles
  - Extended Controls → Cellular/Wi‑Fi → disable/enable.
- iOS network simulation
  - Use host Mac’s network off/on or Network Link Conditioner; or temporarily use `ReachabilityService(host: 'nonexistent.invalid')` for a quick `noInternet` simulation.


## 13) Optional targeted changes for manual test scenarios
- Force `noInternet` briefly
  - In your `ConnectionBindings`, inject `ReachabilityService(host: 'nonexistent.invalid')` temporarily to verify the offline card.
- Verify debounce tuning
  - Temporarily set `debounceDuration: Duration(milliseconds: 50)` in `ConnectionViewModel` via bindings to see more flapping, then restore to 250 ms.
- Telemetry callbacks
  - Pass `onWentOfflineCallback: () => debugPrint('went offline')` and `onBackOnlineCallback: (d) => debugPrint('back after $d')` to verify firing once per transition.


## 14) Minimal acceptance checklist
- App boots without crash; overlay present globally.
- Connecting bar appears only during probe; offline card appears on transport loss or unreachable internet.
- ConnectionHandler shows connecting UI while probing, retry UI when offline, connected content only when connected.
- Resuming app triggers connectivity re-check.
- Offline timer starts once and resets on reconnect.
- Auth sign-in/up/logout flows work with loader and snackbars; session persists; logout clears tokens.
- Networking: header rule honored; single 401 refresh+retry; typed errors mapped; logs redact `Authorization`.
- Caching: repeat GETs hit cache; offline GET with cache works; writes not cached.
- Theming: M3 colors applied; overlay uses `surfaceVariant`/`errorContainer`; accessibility labels present.


---

Notes
- Many of these tests benefit from a simple mock API server (e.g., Mockoon) to force specific responses (200, 401 with refresh, 404/500, etc.).
- For automated coverage, see `test/modules/connections/*` and extend with additional unit/widget tests as needed.
