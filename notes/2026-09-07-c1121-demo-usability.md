# C1121 — Offline demo usability

Date: 2026-09-07. Lane: `ergodis`. Status: in progress.

User reports the newly opened demo is confusing. Scope: reversible presentation and
onboarding improvements in core `wasm/www/bundle.html`, `bundle.css`, `bundle.js`,
a checked-in synthetic example derived from the existing bundle fixture, its extraction
script, related browser UI tests and `wasm/README.md`. Preserve the underlying repository,
verification and fork semantics. No Rust, kernel, persistence architecture or gate change.

Observed: the first screen leads with an empty library and storage setup, asks for an
unprovided file, and exposes implementation vocabulary before a useful action. Provide
an example-first entry, clear action outcomes and disclosure of advanced details.
