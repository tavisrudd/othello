# C1114 — Browser repository persistence

Date: 2026-09-07. Lane: `ergodis`. Status: in progress.

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
