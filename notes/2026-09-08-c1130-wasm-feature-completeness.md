# C1130 — Full Ergodis WASM capability parity

**Lane**: `ergodis`
**Status**: QUEUED, explicitly requested by Tavis on 2026-09-08.

## Objective and architectural requirement

All Ergodis capabilities must be usable via WASM. WASM is a full execution target,
not a reduced solver, demonstration subset, or separate implementation. Preserve
shared engine semantics, schemas/contracts, algebras, compilation, query/update,
optimization/evolution, witnesses, verification, campaign control and portable
load/save/replay workflows. Include existing private domain capabilities through
private adapters, preserving the one-way dependency and publication boundary.
Native host services get appropriate browser/WASM host adapters; OS-specific APIs
need not be identical, but their user workflows must have explicit equivalents.
Platform-specific performance optimizations may be disabled where unavailable.
Browser resource limits must be explicit admission/resource errors, not arbitrary
feature restrictions or silently substituted smaller problems.

## Canonical WASM build and prior work

User clarification: maintain one canonical feature-complete Ergodis WASM build.
Audit current demo/server/build consumers against the Sunday/Monday work; migrate
any divergent demo-specific build to the canonical package, then remove obsolete
active build paths and references. Do not create another reduced browser engine.
Preserve historical source/evidence and unrelated worktrees; consolidation is not
permission for destructive history cleanup. Keep private domain packages behind
the existing one-way dependency boundary.

Loaded in full on 2026-09-08 as required implementation context:

- Sunday: `2026-09-06-c1079-wasm-capability-audit.md` and
  `2026-09-06-c1079-ergodis-evolve-review.md`.
- Monday: `2026-09-07-c1080-admission-pilot.md`,
  `2026-09-07-c1081-language-semantics.md`,
  `2026-09-07-c1083-campaign-transitions.md`,
  `2026-09-07-c1084-portable-control-architecture.md` (complete),
  `2026-09-07-c1085-portable-scalar-language.md`,
  `2026-09-07-c1086-independent-verification.md`,
  `2026-09-07-c1087-portable-campaign-runtime.md`,
  `2026-09-07-c1088-browser-campaign-control.md`,
  `2026-09-07-c1105-offline-browser-inspection.md`,
  `2026-09-07-c1106-offline-verification-forks.md`,
  `2026-09-07-c1114-browser-repository.md` and
  `2026-09-07-c1125-portable-console.md`.

The Sunday audit records a historical C1032 adapter absent after the repository
split. C1080 restored it into current core `wasm/`; later Monday work extended
that adapter with the portable runtime and repository bindings. C1125 explicitly
reused the existing core package, without a separate solver build. C1129 likewise
serves sibling core clients and `wasm/www/pkg` through an allowlist. These records
do not establish current artifact freshness or an exhaustive absence of duplicate
build paths; check consumers/manifests/digests before deleting or rebuilding.

C1084 is the architectural baseline: portable scalar/compiler, independent verifier,
runtime above solver, thin hosts, explicit repository/activation semantics and no
control logic in kernels. Earlier staged limitations are implementation history,
not a license to narrow this task's full-parity objective. Preserve native64 hot
layouts and specialization; do not route native through wasm32 representations.

## Native interface review

Read `2026-09-08-c1130-native-host-review.md` before implementing the parity bridge.
Native non-GF(2) execution primarily uses field-dispatched CLI/library workflows,
application-specific resource/span compilation and separately launched controlled
searches; the new portable CampaignSession is a GF(2) pilot on native too. Native
repository publication is not a universal solve endpoint. Reuse existing typed
operations, compiled/query handles and witness semantics; do not treat a GF(256)
byte decoder or FT10 job-shop solver as already implemented native interfaces.

## Required work

1. Inventory existing native/core/private capability surfaces and their WASM
   availability. Record callable contracts, target/dependency/ISA/threading/host
   blockers, arbitrary binding limits and validation evidence for every gap.
   Cover library capabilities, not only currently visible demo buttons.
2. Close gaps using shared Rust implementations and thin cold host/binding layers.
   Preserve native specialization and dispatch outside hot loops. Do not route
   native execution through JSON, JS, portable fallback kernels or browser limits.
   Keep domain adapters private; do not move them into the public core for exports.
3. Make real recovery, QEC and scheduling workloads executable from loaded inputs
   with their actual engine capabilities. Remove current projection-only/demo
   restrictions where they arise from missing bindings. Do not invent missing
   native mathematical functionality or present a partial projection as parity.
4. Wire the console to the shared contracts: explicit snapshot/runnable contexts,
   load/create/run and applicable staged execution, results, witnesses, checkpoints,
   replay and supported continuation. Opening a snapshot must not execute it.
5. Make parity durable through a capability matrix and automated cross-target
   conformance corpus. Completion requires all inventoried gaps closed, with no
   unimplemented feature silently classified as a platform optimization. Explicit
   platform constraints need documented equivalent workflows or a user decision.

## Mandatory performance rules and native regression gate

Read the complete sibling `ergodis/AGENTS.md`, `ergodis-contrib/PERFORMANCE.md`
and `ergodis-contrib/performance-playbook.md` before implementation/design resumes.
All three were read in full when this task was queued. These rules are acceptance
requirements, not an optimization follow-up:

- Zero allocations in real solve loops, with regression coverage after setup.
- Iterative bounded search; presized worker-owned contiguous storage; asserted
  hot-record size/alignment and range-sized IDs; no dynamic hot records.
- No run-constant per-node branches, target probing, serialization, logging,
  shared locks/queues/counters, contention, false sharing or busy polling.
- Native target-specialized kernels remain selected outside the loop; unavailable
  WASM ISA/thread optimizations fall back without weakening exact semantics.
- Retain native release baselines before changes using `retain-bin.sh`; no baseline
  build trees. For every hot-loop/record change, retain before/after profiles and
  interleaved multi-round A/B hardware counters: instructions, cycles, branches,
  branch misses and relevant cache events, in single-thread and parallel modes.
- Require exact verdict/cost/witness/certificate parity, explain work-count changes,
  assess compilation/load/warm solve/end-to-end boundaries and peak memory. Check
  contention/false sharing for mutable layout or communication changes. Native
  performance regressions must be fixed before acceptance; do not accept native
  slowdown as the price of WASM support. Report uncertainty honestly.
- Use shared configured target directories and ZFS-backed artifacts, at most 12
  workers and prescribed OOM protection; run cache GC dry-run at task close.

## Validation and completion

Run current core fmt, all-target/all-feature Clippy and all-feature tests plus
Python oracle parity (including helper loads). Add actual WASM runtime and browser
Worker tests for each exposed capability, shared native/WASM fixtures for valid,
invalid, unreachable and resource-limited inputs, exact witness/certificate replay,
and loaded real-workload end-to-end console tests. Exercise fallback paths and
native single/parallel semantics. No compile-only claim of feature completeness.

Deliver the committed gap/closure matrix, replayable conformance evidence,
native performance evidence and a working browser console. Scope is full parity;
implementation may proceed in coherent slices without declaring the umbrella
complete early. No engine implementation or performance run occurred at allocation.
