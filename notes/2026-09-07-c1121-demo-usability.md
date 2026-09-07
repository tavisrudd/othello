# C1121 — Offline demo usability

Date: 2026-09-07. Lane: `ergodis`. Status: complete. Core `b219db3`.

User reports the newly opened demo is confusing. Scope: reversible presentation and
onboarding improvements in core `wasm/www/bundle.html`, `bundle.css`, `bundle.js`,
a checked-in synthetic example derived from the existing bundle fixture, its extraction
script, related browser UI tests and `wasm/README.md`. Preserve the underlying repository,
verification and fork semantics. No Rust, kernel, persistence architecture or gate change.

Observed: the first screen leads with an empty library and storage setup, asks for an
unprovided file, and exposes implementation vocabulary before a useful action. Provide
an example-first entry, clear action outcomes and disclosure of advanced details.

## Result

The page now starts with Open example run, backed by the canonical supported synthetic
fixture. No user-supplied file or storage setup is needed. An opened run has a readable
name, an explicit unchecked/checked badge and two main action groups: check evidence,
or save/download. Saving handles first-use IndexedDB initialization in response to the
explicit Save action; opening still performs no persistence. A new-run panel, full
identities, specification settings and JSON remain expandable. The initial library state
is a plain empty state rather than a storage failure. Desktop and mobile layouts have
visible keyboard focus and no horizontal overflow in the tested viewport.

The example is synthetic, not a new solved-workload or mathematical claim. Regenerate:
`nix shell nixpkgs#nodejs --command node wasm/scripts/extract-demo-bundle.mjs`.
Example SHA-256: `3e3ef95fc9c2249fb01fcb652a1c539acf6044f96f2fab0818d0f332ecece1a0`.
The browser test compares served bytes with `wasm/tests/fixtures/bundles.json`.

## Validation and limits

Real Chromium passes the existing inspection/verification/fork controls and repository
interleaving/crash-restart suite, plus one-click example loading, readable names,
collapsed advanced controls, first-save initialization, checked-state reset on reopen,
and the 390-pixel mobile layout. Desktop/mobile screenshots were visually inspected:
`~/.cache/ergodis/browser-control-review/saved-run-demo.png` and `saved-run-mobile.png`.
The file-loading controls now enter a loading state before fetching the example so old
results cannot masquerade as the newly opened file. The integration driver starts the
repository phase in a fresh document after UI fault injection/mobile emulation; storage
is retained and all original crash/recovery assertions still run.

Final browser capture: `20260907-150213-nix-shell-nixpkgsnodejs-nixpkgschromium-command-node-browser-smoke.mjs`.
Full native fmt/clippy/all-feature tests and eight-case Python parity pass:
`20260907-145754-nix-shell-nixpkgscargo-nixpkgsrustc-nixpkgsclippy-nixpkgsrustfmt-nixpkgspython3-c`.
No Rust or WASM binary change, performance claim or persistence/verification semantic change.
Replay browser checks using the documented `node wasm/scripts/browser-smoke.mjs` Nix command.

No incidental mathematical discovery or research mystery. Existing architecture gates for
analytical integration and execution recovery remain as before. The running local server
serves the updated page; the user can refresh `http://127.0.0.1:8765/bundle.html`.
No export or push.
