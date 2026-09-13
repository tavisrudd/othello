# C1161 — recursive runtime queries

**Lane**: `ergodis`
**Date**: 2026-09-12
**Status**: COMPLETE.

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

Fermi estimate before loop changes: a 32-node sparse chain currently scans 1024
products for each of 32 rounds plus initialization; a dependency frontier should
visit roughly 32 products per active distance round, reducing product visits by
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
generator is `python/benchmark_rule_replay.py`. Warm wall speedups are 15.35×/14.62×
(sparse, 1/4 workers) and 5.22×/4.26× (dense). No end-to-end or single-query parallel
speedup claim. The dense variant becomes a sparse frontier after its first broad
wave; no universal dense-workload claim is warranted. Unpadded initial measurements
are in `frontier-ab.json`; explicit payload isolation was added before acceptance.

Core commits: baseline driver `b4d6e9f`, sparse kernel `1aea1e2`, checked runtime and
evidence `9cd2980`. Next allocated independent task: C1162.

## Runtime acceptance

`RecursiveQuery` owns a source, sparse workspace, independently checked graph,
certificate and bounded sequence. Fact replacements bind source digest, sequence
and expected old aggregate value. Candidate workspace and checker are committed
only after independent transition checking; invalid requests preserve every held
observation. No-ops consume a revision. Certificates use the enforced N-round
from-infinity bound; incremental propagation sweeps are separate work metadata.

`LineageReadout` consumes existing encoded Start/Update/Fork RunRecords. It checks
unique boundaries and run/sequence positions, parent closure and parent validity,
and computes minimum fork depth from a mutable origin set. Same-run updates add
no depth. Domain: at most 32 runs, 4,096 records, 4 MiB input, 1,000,000 updates.
Catalogue digest and sorted UUID mapping are stable under input permutation.
The claim is for the supplied catalogue, not all history or authenticated events.

Thin `RecursiveSession` / `LineageSession` bindings live in the existing WASM
package. Actual Node-target WASM agrees exactly with the native transcript on all
13 observations, including stale-request rollback. Existing C ABI native/WASM
provider replay passes all 129 programs with Python parity. The Lean oracle's
four-node certificate remains byte-identical; no toolchain change was needed.

Full workspace fmt/Clippy/test gate passes: 916 tests, zero failures, three ignored.
The closeout adds one passing nonlinear test: 27 fact settings, 81 updates,
independent Python fixed-point enumeration, including an aliased square product.
The main dynamic rule corpus additionally checks 512 Python update cases.
WASM all-target Clippy encountered an existing `items_after_test_module` warning
in `wasm/src/bundle.rs:101`; that unrelated file was not changed. Production-library
Clippy and all 11 WASM unit tests pass separately. Cache GC completed in dry-run mode; no foreign artifacts were deleted.

Committed evidence bundle (core):
- `evidence/2026-09-12-rule-frontier-ab.json` and `.samples.jsonl`;
- `evidence/2026-09-12-rule-frontier.md`, exact retained-binary replay and limits;
- `evidence/2026-09-12-recursive-runtime-transcript.json`;
- `python/benchmark_rule_replay.py`, runtime Python oracles and WASM replay script;
- refreshed `SHA256SUMS`.

## Mystery ledger — ej + tt

- Settled: incremental sweep count is not the from-zero certificate bound.
  Runtime always certifies N, and reports incremental work separately.
- Settled: both product factors may improve in one wave, including the same
  factor twice. Exhaustive nonlinear fixed-point checks cover the aliased product
  and cyclic dependencies; no single-factor delta assumption remains.
- Settled: removing all origins must make every run unreachable despite cycles.
  Python differential and real-record BFS tests cover removal and restoration.
- Open scope limit: dense fixture speedups do not predict permanently dense
  frontiers. A concrete workload gates broader benchmark and join-engine work.
- Open proof coverage: the derivation-tree pruning argument explains the generic
  N-round bound; the Lean companion proves bounded reflection and checks concrete
  iterations, not the universal N-round theorem. No stronger Lean claim is made.
- No incidental discovery-track entry: these were task-owned checks, not an
  unexpected research lead. General automation remains a consumer-side option
  for a concrete IR obligation, not a replacement for kernel reflection.
