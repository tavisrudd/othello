# C1130: offline worker loading and failure contracts

Private contributor context; not for public export.

Native provider rejection and uncertain worker failure are now distinct in the
browser adapter. Recoverable admission rejection requires the execute operation,
status 1 and a declared `admit` effect. Host errors fail every pending request and
close the session; mutations are not retried. Discovery failures retain each
family's existing policy, with visible diagnostics for optional discovery.

Generated module schedules passed 10,000 cases / 108,889 steps, with shrunk,
replayed mutation controls. Core offline bundle/repository actions now share
compiled engine code while retaining disposable workers and isolated heaps. The
30-second action budget includes loading. Validation records imported source
hashes and fails if code changes during a run.

The full frozen-source suite passed 49 of 50 checks. Chromium's intermittent
worker-import cancellation remains open and has a fresh-browser reproduction;
compiled-code reuse and disabling HTTP caching are not claimed to fix it. The
seven loader tests and actual refreshed 8770 recovery save/open/replay passed.
Native formatting, Clippy, all-feature tests and bounded Python parity passed;
no native hot loop or canonical WASM binary changed.

Implementation: private `ab2a680`, `3abcfc9`, `eaf0782`, `7a45747`; core `fb244fd`,
`727a73f`. Current private reports:

- `ergodis-private/analysis/interface-review/2026-09-10-race-failure-contracts.md`
- `ergodis-private/analysis/property-tests/2026-09-10-module-schedule-validation.md`
- `ergodis-private/analysis/interface-review/2026-09-10-offline-worker-loading.md`

Next diagnostic boundary: retain the isolated worker-loading reproduction and
identify the initiator of canceled JS module requests. Do not retry actions or
mute failed checks. Asset version pinning across live rebuilds, Safari/iPhone,
Firefox and broader native/JS workflow convergence remain separate gaps.
