# C1161 — recursive runtime queries

**Lane**: `ergodis`
**Date**: 2026-09-12
**Status**: IN PROGRESS.

User authorized two hours of continued work on this series, starting
2026-09-12 23:30:51 UTC, ending 2026-09-13 01:30:51 UTC. Continue the allocated
programme autonomously during that window; C1161 is first. C1164 is complete at
monorepo `e94b5fcce`. General automation is design input, not a scope pivot.

Scope: sparse semi-naive execution and safe incremental fact replacement through
the C1163 rule contract, runtime sequencing and independently checked certificates,
and a real recursive campaign-lineage readout over existing RunRecord forks.
New origin roots improve the readout incrementally; retractions replay from zero.
The finite supplied catalogue is the query domain, not all repository history.

Admission and certificates retain the scalar N-round bound. The operational loop
must reject failure to converge rather than return an unchecked answer. Runtime
transaction failures preserve held source, values, sequence and certificate.

Fermi estimate before loop changes: a 32-node sparse chain currently scans1024
products for each of32 rounds plus initialization; a dependency frontier should
visit roughly32 products per active distance round, reducing product visits by
about an order of magnitude. Dense frontiers may lose to contiguous full scans;
measure both and retain a negative-control policy if necessary. No speed claim yet.

Baseline setup is a reusable deterministic core example,
`crates/rules/examples/replay_profile.rs`. It uses the unchanged C1163 evaluator.
Retain its executable before modifying the solve loop. Gates: full native suite,
independent Python oracle, actual native/WASM ABI parity, zero allocations, single
and parallel exact results/work counts, retained interleaved performance counters,
runtime stale/rollback/identity/update controls, and ej+tt closeout.
