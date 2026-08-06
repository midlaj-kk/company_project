/// Single central Demo Mode flag.
///
/// When [demoMode] is `true` the app runs fully offline using
/// in-memory demo data: login accepts any non-empty email + password
/// and every service returns local data instead of calling the real
/// backend.
///
/// Set back to `false` to restore the real backend — no other code
/// needs to change.
const bool demoMode = true;
