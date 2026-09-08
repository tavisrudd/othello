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
