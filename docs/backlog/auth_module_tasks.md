Auth Module Backlog — Tasks to Handle Later

Scope
- This file tracks follow-ups for the Auth module after the P0 correctness/safety fixes shipped.
- Ignore unit tests for now, but test items are captured for future work.

P1 — Ergonomics and DX (nice improvements)
- AuthViewModel: reduce risk of null assertions on credentials (choose one)
  - Option A: Keep current parameterless signIn(), add guards for non-empty credentials and clear password on success.
  - Option B: Switch to signIn({required String username, required String password}) and pass values from the view.
- LoginPage UX polish
  - Ensure password field obscures text; use TextInputAction.done and submit on enter.
  - Disable login button while loader overlay is visible (or rely on overlay to block taps).
  - Optionally reset form on successful login.
- AuthHandler (optional)
  - Consider an error rendering path if you later surface errors from checkSession(); otherwise keep current routing.
- Documentation
  - README: brief “Auth flow” overview (state transitions; validation at view; error handling in actions; service responsibilities).
  - Coding guidelines: note “do not pop unless Navigator.canPop()” in actions; loader overlay guard in presenters.

P2 — Tests and Template Alignment (defer until tests are prioritized)
- Unit tests (later)
  - AuthService.signIn: stores tokens on happy path; throws APIException on malformed response.
  - AuthViewModel.checkSession transitions:
    - No tokens → notAuthenticated.
    - Access expired, refresh valid → refresh then authenticated.
    - Refresh expired → clear tokens and notAuthenticated.
  - AuthActions.signIn: does not pop when Navigator.canPop() == false.
  - ActionPresenter: no crash when overlay missing.
- Mason brick/template sync
  - Mirror all auth changes (guards and navigation rules) in the brick template so generated apps inherit the fixes.

Open Decisions (need maintainer input)
- Auth error message localization
  - Replace hardcoded invalid-credentials copy in ActionPresenter with a translation key (e.g., tkInvalidCredentials). Provide key and default string.
- AuthViewModel.signIn signature
  - Keep parameterless signIn() (current flow) or migrate to parameterized signIn({required username, required password}) for stricter API? (affects AuthActions/LoginPage.)
- Expiry check contract
  - Should isAccessTokenExpired()/isRefreshTokenExpired() return true when tokens are null instead of throwing? Current callers check isLoggedIn() first; document and keep consistent either way.
- ActionPresenter relocation (organizational)
  - Move to src/presentation/actions/ (and update imports/brick) to match the new layer structure.

Nice-to-Haves (future hardening)
- Error mapping
  - Expand API error mapping (400/403/409/422/429/5xx) and RFC 7807 parsing; localize user-facing messages.
- Retry policy
  - Optional bounded backoff for transient errors (408/429/5xx) on idempotent methods.
- Auth profile
  - Optionally fetch profile post sign-in and expose a canonical user in AuthViewModel.

Notes
- P0 shipped: definitive checkSession outcomes (no sticky “checking”); logout awaits signOut; sign-in response validation; overlay guard and clearer auth errors in ActionPresenter; avoid unsafe pops in AuthActions.
- This backlog intentionally excludes unit tests for now, per instruction.
