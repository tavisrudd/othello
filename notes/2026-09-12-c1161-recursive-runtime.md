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

## Validated kernel checkpoint

The sparse evaluator and fact replacement pass scoped Clippy, all rule tests,
512 independent Python update cases, zero-allocation improvement/retraction tests,
and eight-workspace cache-line separation. Retained naive baseline:
`rule-replay-naive-b4d6e9f`, SHA256
`1a12abd00003527ade69fe5fb518853e8dc92f272bb76795b49c12a4ba842d70`.
Padded candidate: `rule-replay-isolated-b4d6e9f`, SHA256
`f9691554e82b4dce09d2a9fed6a786acd789ff3bb27a7345b1b638b98d5d475e`.
Both are under `~/.cache/ergodis/bin/`; candidate manifest records the dirty
source before the coherent kernel commit. Baseline driver commit is `b4d6e9f`.

Five interleaved pairs in each of sparse/dense × one/four independent workers
pass with exact values and work counts. `~/.cache/ergodis/rule-runtime/isolated-ab.json`
and `.samples.jsonl` retain counters/RSS and raw measurements; the committed
generator is `python/benchmark_rule_replay.py`. Warm wall speedups are15.35×/14.62×
(sparse,1/4workers) and5.22×/4.26× (dense). No end-to-end or single-query parallel
speedup claim. The dense variant becomes a sparse frontier after its first broad
wave; no universal dense-workload claim is warranted. Unpadded initial measurements
are in `frontier-ab.json`; explicit payload isolation was added before acceptance.

Unvalidated owned runtime paths: `crates/runtime/Cargo.toml`, `src/lib.rs`,
new `src/recursive.rs`, new `src/lineage.rs` (all relative to that crate).
Runtime admission/replay and actual WASM binding still require their own gates.
No completion claim is made for the task yet. Evidence will be retained in the
final committed bundle, not left solely in the cache.
