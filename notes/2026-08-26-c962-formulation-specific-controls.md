# C962 formulation-specific exact controls

**Date:** 2026-08-26

**Lane:** `complete-ports`

**Scope:** Replace direct CP-SAT as the primary application benchmark with a
strong open-source exact formulation matched to each application. Retain
direct CP-SAT as a common stress control. This report makes no universal SOTA
claim and does not compare proprietary solvers.

## Result

Every control proves the same objective, feasibility, or infeasibility result
as ERGO-comp. Eleven pinned-core processes were run per matched control. Times
include model or application-state construction; RSS is process high-water
memory.

| application | bounded instance                 | exact control            | ERGO     | control    | result        |
| :---------- | :------------------------------- | :----------------------- | -------: | ---------: | :------------ |
| Ceph XOR    | 8 diamonds, 256 minimal supports | Graphillion ZDD closure | 25,339 us |     864 us | ZDD 29x       |
| Azure LRC   | 100,000 demands, cap 100k        | HiGHS counted MILP      |     <1 us |   4,877 us | ERGO 173,996x |
| repair DAG  | 3 layers x 21 tasks              | CP-SAT intervals        |      2 us |  19,218 us | ERGO 7,881x   |
| QC-LDPC     | lift 50,000, weight 4            | CryptoMiniSat XOR       |  1,517 us | 509,306 us | ERGO 336x     |
| vector span | 64 nodes, 2 symbols per node     | CryptoMiniSat XOR       |     10 us |  48,691 us | ERGO 4,717x   |
| GPU MDS     | 10,000 shards, k=6,000, 64 lost  | OR-Tools max-flow       |    100 us | 103,061 us | ERGO 1,029x   |

| application | ERGO RSS | control RSS |
| :---------- | -------: | ----------: |
| Ceph XOR    |  3.0 MiB |    19.4 MiB |
| Azure LRC   |  2.2 MiB |    61.6 MiB |
| repair DAG  |  2.3 MiB |    79.1 MiB |
| QC-LDPC     |  4.0 MiB |   231.8 MiB |
| vector span |  2.2 MiB |    20.8 MiB |
| GPU MDS     |  3.6 MiB |    69.1 MiB |

The comparison changes the interpretation of the wins. CP-SAT was not the
nearest control for MDS helper assignment or parity. Full bipartite max-flow
and native-XOR SAT reduce the measured ratios substantially, but the remaining
gaps are still large. The Azure row compares two equally counted models, so it
isolates the closed-form six-type capacity criterion from generic integer
optimization. The GPU row isolates the aggregate-capacity/cyclic-realization
theorem from a full failure-by-survivor flow graph.

The Ceph row is a useful negative. ERGO-comp materializes every antichain
member; Graphillion keeps the family compressed as a zero-suppressed decision
diagram. At only 256 outputs, the ZDD is already 29 times faster. This is the
evidence-backed crossover motivating an adaptive explicit/ZDD backend; a
Roaring bitmap can improve large individual supports but cannot itself
compress an exponentially large family.

## Strength of each outcome

| application | control proves                 | ERGO-comp additionally returns                    |
| :---------- | :----------------------------- | :------------------------------------------------ |
| Ceph XOR    | exact compact support family   | every sorted minimal support and closure counters |
| Azure LRC   | maximum repaired count         | mode counts, nine loads, direct capacity check    |
| repair DAG  | optimal makespan and schedule  | canonical batches and ready-state count           |
| QC-LDPC     | no weight-four codeword        | component reason; normalized witness if feasible  |
| vector span | optimum equals four nodes      | canonical helpers, span count, transition count   |
| GPU MDS     | full helper flow is feasible   | every helper shard, all loads, cyclic witness     |

Thus equal scalar outcomes do not mean equal artifacts. The controls establish
the benchmark decision or optimum. ERGO-comp's application front ends also
return replayable domain objects and structural work counters. Conversely, the
Ceph ZDD retains a compact family representation that ERGO-comp does not yet
provide; that is a genuine control advantage, not merely timing.

## Controls and trusted boundary

- Graphillion 2.1 performs ZDD union, join, and minimal-family reduction.
- SciPy 1.16.1 `milp` invokes HiGHS on the exact 18-variable counted Azure
  formulation.
- OR-Tools 9.14.6206 uses interval variables and `NoOverlap` for the repair
  DAG and `SimpleMaxFlow` for the complete GPU bipartite graph.
- CryptoMiniSat 5.14.7 receives native XOR clauses. The QC model uses an exact
  small-cardinality automaton; the vector model proves infeasibility at three
  selected nodes and feasibility at four with sequential cardinality bounds.

The proprietary Gurobi, CPLEX, and IBM CP Optimizer baselines remain unmeasured.
Likewise, the QC row is a strong generic parity control, not a comparison to
every published trapping-set enumerator. These omissions prevent a global SOTA
claim but do not affect the exact bounded comparisons above.

## Independent checks

The benchmark runner requires checksum equality with the Rust result. A
separate exhaustive checker validates 1,538 at-most assignments, 1,792 exact
cardinality assignments, and all 254 expected ZDD supports for diamond depths
one through seven. The Rust test suite independently checks the application
answers, including exhaustive small GPU-capacity agreement between the
aggregate compiler and enumerated helper families and 1,000 seeded Azure
agreements between counted and enumerated schedulers.

## Reproduction

Working directory:
`papers/complete-repair-ports/algorithms/rust`.

```text
nix shell nixpkgs#cargo nixpkgs#rustc --command \
  cargo build --release --bin bench_kernels
python3 run_benchmarks.py --write --application-sota-only --ab-rounds 11
nix shell nixpkgs#uv --command uv run --no-project \
  --with pycryptosat==5.14.7 --with graphillion==2.1 \
  python3 verify_baseline_encodings.py
```

The frozen JSON key is `application_formulation_specific_comparisons`.

| artifact                       | bytes     | SHA-256                                                            |
| :----------------------------- | --------: | :----------------------------------------------------------------- |
| `benchmark_python.py`          |    48,624 | `c7030a06596421ba140e49ee553075e9f4aa63129f4fa7a93194526a4a9493a0` |
| `run_benchmarks.py`            |    62,801 | `a2ce79e4d2342c40dac3193a447c9bf557f8b75e3e44c21f658741cf6c576bfe` |
| `verify_baseline_encodings.py` |     2,204 | `65ece2f92f196713a043bf845b41263de52f3a2082afafc3f7aeb8b347a4074f` |
| `src/bin/bench_kernels.rs`     |    42,376 | `49056dc68c8cabe86fdd75da4f2a551eda38787ba3713666ead19a8e62b7121f` |
| `evidence/benchmarks.json`     | 1,321,932 | `3f07f2848c5d73efe5fe124a28e47eca710f9de857f760fcd011d7d86857b3d9` |

The JSON is canonical sorted-key output. It records every raw sample, median,
RSS value, checksum, package protocol, and source hash. The benchmark does not
claim that the selected synthetic bounded cases model production traces or
that timing proves an asymptotic bound.
