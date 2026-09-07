# C1114 — Browser repository persistence

Date: 2026-09-07. Lane: `ergodis`. Status: complete. Core `96a81b5`.

User-approved scope: browser/WASM and native persistence share the portable repository
contract; browser first (C1114), native filesystem companion next (C1115). Automatic
execution resumption and analytical projection integration remain separate slices.

C1114 owns portable bounded repository replay/transport, WASM glue, IndexedDB storage,
saved-run inspection/verification/fork demo integration, native conformance and real
browser tests. Native adapter work is C1115. Solver kernels are outside the edit scope.
Allowed core paths: `crates/runtime/src/repository.rs`, `crates/runtime/src/run_record.rs`,
`crates/runtime/src/repository_journal.rs`, `crates/runtime/src/lib.rs`,
`crates/runtime/tests/repository_journal.rs`, `wasm/src/`, `wasm/www/`,
`wasm/scripts/`, `docs/run-repository.md`, `wasm/README.md`, and regenerated WASM package.

The adapter must acknowledge only completed transactions, persist receipts/fences/accounting
atomically, reject stale concurrent writes, report missing storage instead of silently
recreating it, and allow saved runs to reopen without a live campaign. Test denied storage,
abort/quota paths, lost acknowledgements, multiple owners and actual browser restart.

## Result and gates

Portable `ERGREP01` replay images retain admitted uploads/commands with exact receipts,
fences, reservations and sidecars. Replay uses MemoryRepository; JavaScript has no second
semantic engine. 16 MiB/1024-event/16 KiB-command limits; decimal-string u64 counters;
checksummed framing and validated identities. Identical upload/request retries do not grow
images. Replay alone remains Volatile. The host acknowledges RestartPersistent only after
an IndexedDB transaction completes. Worker preparation plus exact-generation CAS keeps
WASM awaits outside transactions and rejects competing updates.

The offline demo creates a local library, saves selected sequence-zero Start/Fork records,
reopens saved runs, explicitly verifies supported snapshots and saves fresh-ID children.
It registers historical runs with zero execution budgets. Parent records remain unchanged;
reopening clears verification results. No execution resumption or domain authority claim.

Validation: ten existing repository contract tests and four new replay tests pass; full
native fmt/clippy/all-feature tests and eight-case Python parity pass. Release wasm-pack
build passes. Actual Chromium API/UI tests pass competing browsing contexts, stale callbacks,
abort-after-put, injected quota/denial, explicit missing/deleted storage, save/reopen/verify/fork,
and complete process-group SIGKILL/restart with the same origin/profile. Recovered heads,
reservations, interrupted owner, exact retry receipts, parent and child all agree.

Run-quiet captures:
- Native/release WASM targeted: `20260907-143327-nix-shell-nixpkgscargo-nixpkgsrustc-nixpkgsrustfmt-nixpkgsclippy-nixpkgswasm-pack`.
- Full native/Python: `20260907-143534-nix-shell-nixpkgscargo-nixpkgsrustc-nixpkgsclippy-nixpkgsrustfmt-nixpkgspython3-c`.
- Browser final: `20260907-143826-nix-shell-nixpkgsnodejs-nixpkgschromium-command-node-browser-smoke.mjs`.

Replay: core AGENTS.md full native gate; WASM README wasm-pack build and
`nix shell nixpkgs#nodejs nixpkgs#chromium --command node wasm/scripts/browser-smoke.mjs`.
The restart test initially evaluated the new DevTools target before its document context
was ready; the driver now checks the actual document URL/readiness before imports.
This was a test harness startup race, not a recovered-data failure.

Limits: full bounded image reconstruction/rewrite, not large-history performance. Aggregate
bundle export retains existing bounds. Strict IDB commit is requested; power-loss, physical
disk-full and automatic eviction are not proven. Missing storage is reported, never silently
reinitialized. Fault injection establishes failure handling only. Site-data retention remains
browser-owned; keep downloaded bundles. No solver loop/layout changed; no performance claim.

Closeout: retry capacity and exact wide JSON counters are covered. No incidental mathematical
discovery or genuine research mystery. C1115 owns the native filesystem companion; analytical
projection and execution recovery remain separate successor gates. No export or push.
