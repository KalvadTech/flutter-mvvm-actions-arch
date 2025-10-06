# Connectivity Module

Status: stable (PR1+PR2 implemented), tests+docs added in PR3 | Last updated: 2025-10-06

This document summarizes the connectivity module responsibilities, states, configuration options, lifecycle behavior, theming, and testing notes.


## Why
- Provide a single source of truth for connectivity across the app.
- Differentiate between link-layer transport availability (Wi‑Fi/Cellular) and actual internet reachability.
- Offer a consistent, non-crashing UX for offline/connecting states.


## High-level overview
- State controller: ConnectionViewModel (GetX)
  - Exposes `Rx<ConnectivityType>` and a reactive offline duration timer (`dialogTimer`).
  - Debounces connectivity change events (default 250 ms; configurable).
  - Performs lightweight reachability probes via an injectable ReachabilityService.
  - Lifecycle-aware: always re-checks connectivity when the app is resumed.
  - Telemetry hooks: optional callbacks for went offline/back online.
- Overlays/widgets
  - ConnectionOverlay shows a slim bar during `connecting` and a full-width card for `noInternet`/`disconnected`.
  - ConnectionHandler gates a section of UI and offers a manual retry when offline.


## States
- ConnectivityType.mobileData: Connected via cellular (internet confirmed).
- ConnectivityType.wifi: Connected via Wi‑Fi/Ethernet/VPN/Bluetooth transports (internet confirmed).
- ConnectivityType.disconnected: No network transport.
- ConnectivityType.noInternet: Transport exists but internet is not reachable (e.g., captive portal).
- ConnectivityType.connecting: Transitional state while probing reachability after a transport becomes available.

Notes
- `isConnected()` returns true only for `wifi` and `mobileData` (connecting is excluded by design).


## ReachabilityService
Path: lib/src/modules/connections/data/services/reachability_service.dart

- Strategy: `dnsLookup` (default) or `httpHead`.
- Config:
  - host (for DNS, default `google.com`)
  - timeout (default 3s)
  - healthEndpoint (for HTTP strategy)
- Web note: on web, DNS sockets are unavailable; service returns true to avoid false negatives (prefer an HTTP health endpoint if you require stricter semantics on web).

Example
```text
final vm = ConnectionViewModel(
  reachability: ReachabilityService(
    strategy: ReachabilityStrategy.dnsLookup,
    host: 'google.com',
    timeout: const Duration(seconds: 3),
  ),
);
```

To switch to an HTTP health endpoint later:
```text
final vm = ConnectionViewModel(
  reachability: ReachabilityService(
    strategy: ReachabilityStrategy.httpHead,
    healthEndpoint: Uri.parse('https://api.example.com/health'),
    timeout: const Duration(seconds: 2),
  ),
);
```


## ConnectionViewModel constructor options
```text
ConnectionViewModel({
  ReachabilityService? reachability,           // default: DNS google.com
  Duration debounceDuration = const Duration(milliseconds: 250),
  VoidCallback? onWentOfflineCallback,         // fire-and-forget notification
  void Function(Duration)? onBackOnlineCallback, // includes offline duration
  bool autoInit = true,                        // set false in tests to avoid platform calls
})
```

- Debounce duration reduces UI flapping on rapid connectivity changes.
- Telemetry callbacks are optional; inject your own logic when needed.
- `autoInit` is primarily for tests so they can avoid platform `connectivity_plus` calls.


## Lifecycle behavior
- Implements `WidgetsBindingObserver` and re-runs a connectivity check on `resumed`.
- Overlays update automatically based on the reactive state.


## Theming and accessibility
- Material 3 colors:
  - `surfaceVariant` for the connecting bar.
  - `errorContainer`/`onErrorContainer` for the offline card.
- Overlays are wrapped in `SafeArea` and provide basic `Semantics` labels.


## Usage
Wrap pages with an overlay
```text
ConnectionOverlay(child: YourPage())
```

Gate a section of UI with a manual retry
```text
ConnectionHandler(
  connectedWidget: Content(),
  tryAgainAction: () => ConnectionActions.instance.checkConnectivity(),
)
```


## Testing notes
- Use `ConnectionViewModel(autoInit: false)` in tests to avoid platform dependencies.
- Set `vm.connectionType.value` directly to simulate states.
- `NoInternetWidget` binds to `dialogTimer` via `Obx`; you can set `dialogTimer.value` to assert rendering.


## Future improvements
- Extract a central app-wide backoff for repeated manual retries.
- Provide a pluggable strategy registry for reachability, including multi-host probing.
- Optional analytics hooks (wire telemetry callbacks to your analytics sink).
