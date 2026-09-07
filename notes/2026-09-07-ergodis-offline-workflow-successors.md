# Ergodis offline workflow successors

Date: 2026-09-07. Lane: `ergodis`. Status: C1105 complete (core `d5e5504`);
C1106 complete (core `feab0c6`); C1107 complete (core `75b646b`). Reports:
`2026-09-07-c1105-offline-browser-inspection.md`, `2026-09-07-c1106-offline-verification-forks.md`,
`2026-09-07-c1107-repository-contract.md`. Persistent adapter/backend selection and allocation
is the next gate; the existing C1033 analytical read layer remains a downstream integration.

C1101 supplies UUIDv7 run identity and portable records; C1103 supplies bounded bundles.
The next product increment lets users inspect historical work without a running process,
then deliberately verify or fork it. These tasks keep repository and control concerns above
solver kernels. They do not replace autonomous evolve discovery or its semantic-contract work.

## C1105 — Offline inspection (first)

Expose the portable bundle parser through the existing browser/WASM client. Bound file size
before reading/allocating and retain parser item/count limits. Display manifest, record identity,
lineage, declared search mode and missing dependencies. Clearly distinguish an absent parent
from a corrupt included parent. Opening a bundle neither runs a solver nor checks its mathematics.

Acceptance: real-browser tests for complete and partial bundles, corrupt bytes, oversized input,
and opening without a live campaign. Bound transfer/copy memory; avoid a second parser in JS.
Run affected native checks and WASM compilation. Keep existing live campaign functionality intact.
Coordinate with C1032's broader browser prototype; this task owns only offline inspection.

## C1106 — Explicit verification and fork (after C1105)

Add separate user actions for verification and creating a child run. Dispatch only to an admitted,
available checker for the declared format, with limits and explicit coverage. Unknown evidence
remains inspectable but unsupported for checking. A historical evidence reference never grants a
current verified capability. Keep domain-specific source checking in private adapters.

A fork obtains a fresh host-generated UUIDv7, records the exact parent boundary and chosen
specification, and preserves the parent. It does not imply executable resumption or proof reuse.
Missing source/package dependencies must produce actionable diagnostics before any execution.

Acceptance: supported/unsupported/corrupt evidence controls; fresh-ID and parent-preservation
tests; changed-spec fork tests; inspect/verify/fork work without a live daemon. State precisely
what any supported checker establishes. Do not load arbitrary native code from a bundle.

## C1107 — Repository ownership and recovery contract

Define a deep portable repository boundary and an in-memory reference implementation. Specify
content publication versus mutable head advancement, compare-and-swap expectations, writer
fencing, run-ID collision rejection, attempt identity, and immutable record references. Separate
versioned system metadata and user annotations from solver state and mathematical evidence.

Specify restart accounting: logical campaign budgets versus physical attempt work, stale writer
rejection, interrupted publication and ambiguous work. No budget refund merely because an
attempt disappeared. Compatible restart retains run identity; semantic change requires a fork
or explicit admitted migration. A process ID is not ownership authority.

Acceptance: deterministic interleaving/conformance tests for stale writers, competing heads,
partial publication, retries, duplicate IDs and restart accounting. Document native filesystem
and browser storage adapter requirements without assuming Unix sockets, POSIX rename or shared
memory universally. Actual disk/IndexedDB adapters and execution recovery are later slices,
allocated after this contract is concrete. C1107 can be designed independently of the viewer.

## Shared discipline and retained frontiers

All work stays out of solver/update hot loops; preserve native64 layout and alignment assertions.
Measure any changed execution path before claiming performance. Put browser presentation,
portable runtime, checking and storage adapters in their respective compilation units; do not
introduce a universal platform trait carrying unrelated operations.

Private kernel/module distribution and licensing manifests, additional algebra backends,
compact sibling proofs, query/design exploration and autonomous discovery remain separate
frontiers. This queue increment makes completed runs usable; it does not declare the broader
core consolidation finished or make unverified research claims into admissions.
