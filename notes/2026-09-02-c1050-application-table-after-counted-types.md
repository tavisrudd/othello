# C1050: the application table after the generic counted-type reduction

**Lane**: `complete-ports`. Working directory for every command below is
`papers/complete-repair-ports/ergodis`.

The question is narrow and the answer is negative in the useful sense: the
generic counted-type scheduler reduction committed in C1038
(`WeightedRepairProblem::solve_counted_types`) moves no published application
row, and it does not subsume the application-specific Azure LRC compiler. Both
halves were measured rather than argued from the source, and the source reading
explains the measurement.

## 1. What was measured, and against what

The control is the retained pre-change executable. `a5e844f73` is the last
commit before the counted-type reduction existed
(`git grep solve_counted_types a5e844f73 -- src/scheduler.rs` is empty; the same
query at `38d8ca7fe`, the C1038 commit, returns ten hits). A temporary
`git worktree` of that commit was created in the scratchpad, `bench_kernels` was
built there into the crate's shared target directory, retained with
`scripts/retain-bin.sh`, and the worktree removed. No per-experiment target
directory was created.

| side | retained executable | SHA-256 | git revision |
| :--- | :------------------ | :------ | :----------- |
| baseline | `~/.cache/ergodis/bin/bench_kernels-a5e844f73` | `ce3e0b06018d5de706f11fa3b0d942632a9e15980e09db92a507475060ff38e1` | `a5e844f73`, clean |
| current | `~/.cache/ergodis/bin/bench_kernels-f40abec7c` | `b645c234d6ed4d0b85370219275c3f5fb70aab025a696483abeb7931c28afbbb` | `f40abec7c`, clean |

Both were built with `rustc 1.93.1 (01f6ddf75 2026-02-11)`, release profile, no
non-default features.

**Protocol.** Fresh process per sample; rotated paired A/B order; both sides
pinned to CPU 3; `choom -n 1000`; model construction and process startup inside
the timed region; process high-water RSS from `/usr/bin/time -f %M`; seven
paired rounds per cell; medians of unrounded samples; every cell well under the
ten-minute budget. Three profiles per row where they exist: `cold` (one solve
per process), `warm_batch` (eight solves per process), and `stress_batch` (the
repetition count the CP-SAT stress table uses for that row — 100,000 for Azure,
1,000 for the repair DAG and vector span, 100 for QC-LDPC and GPU MDS).

**Only the ergodis side was re-measured.** The external controls — Graphillion,
HiGHS, OR-Tools CP-SAT, CryptoMiniSat, OR-Tools max-flow — are untouched by a
change to the Rust scheduler, so re-running them would add host noise to the
published ratios without adding evidence. A row whose ergodis side is unchanged
keeps its published ratio, and that is what every row below did.

**Host caveat.** `/sys/devices/system/cpu/cpufreq/boost` reads `1` on this host,
so `host_metadata` reports `canonical_host_ready = false`. The governor is
`performance`. These are therefore diagnostic-host measurements. That is
sufficient for the question asked, which is whether a row moved: the comparison
is paired, rotated, and same-host, and the answer is that no row moved. It would
not be sufficient to publish a *new* absolute number, and no new absolute number
is published from this run.

Driver: `python/run_c1050_application_ab.py`. Evidence:
`evidence/c1050-application-counted-type-ab.json` with the adjacent
`.raw.jsonl` holding every sample.

```text
python3 python/run_c1050_application_ab.py \
  --baseline ~/.cache/ergodis/bin/bench_kernels-a5e844f73 \
  --current  ~/.cache/ergodis/bin/bench_kernels-f40abec7c \
  --rounds 7 --cpu 3 \
  --raw-jsonl evidence/c1050-application-counted-type-ab.raw.jsonl \
  --output   evidence/c1050-application-counted-type-ab.json
```

## 2. Result: nothing moved

Eleven application variants, twenty-eight cells. `ratio` is baseline median
divided by current median, so above 1 means the current binary is faster.
`exact` is agreement of the benchmark checksum across all fourteen samples of
the cell; `work` is agreement of the reported work counter across the same
fourteen.

| row | profile | baseline ns/solve | current ns/solve | ratio | baseline RSS KiB | current RSS KiB | exact | work |
| :-- | :------ | ----------------: | ---------------: | ----: | ---------------: | --------------: | :---- | :--- |
| Ceph XOR (ZDD family) | cold | 81,973 | 81,832 | 1.002 | 2,152 | 2,148 | yes | same |
| Ceph XOR (ZDD family) | warm | 44,474 | 44,786 | 0.993 | 2,156 | 2,152 | yes | same |
| GF(4) represented tower | cold | 571,223 | 582,545 | 0.981 | 2,712 | 2,704 | yes | same |
| GF(4) represented tower | warm | 281,155 | 283,871 | 0.990 | 2,704 | 2,724 | yes | same |
| Azure LRC | cold | 2,745 | 1,703 | 1.612 | 2,160 | 2,120 | yes | same |
| Azure LRC | warm | 288 | 273 | 1.055 | 2,104 | 2,120 | yes | same |
| Azure LRC | stress | 26 | 26 | 0.996 | 2,088 | 2,164 | yes | same |
| Repair DAG | cold | 8,345 | 8,416 | 0.992 | 2,120 | 2,152 | yes | same |
| Repair DAG | warm | 3,306 | 3,334 | 0.992 | 2,100 | 2,144 | yes | same |
| Repair DAG | stress | 2,161 | 2,141 | 1.009 | 2,136 | 2,148 | yes | same |
| QC-LDPC | cold | 1,536,471 | 1,531,782 | 1.003 | 3,848 | 3,884 | yes | same |
| QC-LDPC | warm | 1,530,731 | 1,543,545 | 0.992 | 3,852 | 3,832 | yes | same |
| QC-LDPC | stress | 1,498,072 | 1,479,181 | 1.013 | 3,828 | 3,844 | yes | same |
| vector node span | cold | 58,339 | 57,066 | 1.022 | 2,100 | 2,144 | yes | same |
| vector node span | warm | 26,866 | 18,309 | 1.467 | 2,164 | 2,156 | yes | same |
| vector node span | stress | 10,307 | 10,224 | 1.008 | 2,160 | 2,148 | yes | same |
| Hamming-outer LRC | cold | 103,780,275 | 103,326,130 | 1.004 | 2,320 | 2,152 | yes | same |
| Hamming-outer LRC | warm | 103,510,500 | 103,514,956 | 1.000 | 2,156 | 2,272 | yes | same |
| GPU MDS | cold | 395,817 | 544,814 | 0.727 | 3,256 | 3,248 | yes | same |
| GPU MDS | warm | 160,008 | 157,622 | 1.015 | 3,384 | 3,436 | yes | same |
| GPU MDS | stress | 93,283 | 99,384 | 0.939 | 3,356 | 3,344 | yes | same |
| Ceph scheduling quotient, 10 diamonds | cold | 311,029 | 255,356 | 1.218 | 2,256 | 2,224 | yes | same |
| Ceph scheduling quotient, 10 diamonds | warm | 95,238 | 101,803 | 0.936 | 2,164 | 2,336 | yes | same |
| Ceph scheduling quotient, 30 diamonds | cold | 1,128,912 | 1,214,912 | 0.929 | 3,332 | 3,324 | yes | same |
| Ceph scheduling quotient, 30 diamonds | warm | 828,143 | 818,927 | 1.011 | 3,432 | 3,564 | yes | same |
| Ceph scheduling quotient, 80 diamonds | cold | 7,715,505 | 7,653,199 | 1.008 | 10,772 | 10,768 | yes | same |
| Ceph scheduling quotient, 80 diamonds | warm | 7,670,563 | 7,629,435 | 1.005 | 11,092 | 11,068 | yes | same |

**The work counter is identical on every side of every cell.** That is the
finding, and it is stronger than the wall times: the counted-type reduction
cannot have acted anywhere, because acting would change the transition count.
Answer parity holds identically.

**How to read the outlying ratios.** The full run was done twice, seven rounds
each. The cells with visible scatter are exactly the cheap ones, where process
startup dominates the measured region. Azure cold read 1.368 in the first run
and 1.612 in the second, on a cell of 1.7--2.7 microseconds; GPU MDS cold read
0.991 then 0.727; vector span warm read 1.033 then 1.467. The reliable cell for
Azure is the stress profile, which amortizes 100,000 solves per process and
reads 0.997 and 0.996 in the two runs. None of these is a movement; they
calibrate the noise floor of a fresh-process cell at this magnitude, which is
roughly ±50% below ten microseconds and a few percent above a millisecond.

### Why nothing moved: the source reading

`solve_counted_types` acts only through `WeightedRepairProblem`'s adaptive entry
points. None of the eight published application variants reaches them:

| row | kernel it actually calls | reaches the scheduler? |
| :-- | :----------------------- | :--------------------- |
| Ceph XOR | `ceph_xor_repair_family`, ZDD closure | no |
| GF(4) tower | represented-tower min--sum composition | no |
| Azure LRC | `applications::azure_lrc_12_2_2_counted`, closed form | no |
| Repair DAG | `applications::schedule_repair_dag`, its own subset BFS | no |
| QC-LDPC | `QcLdpcCode::search_trapping_set` | no |
| vector node span | `minimum_node_span_repair` | no |
| Hamming-outer LRC | Jin--Fu min--sum composition | no |
| GPU MDS | `gpu_checkpoint_mds_same_rack_recovery`, closed form | no |

The one application variant that does construct a `WeightedRepairProblem` and
call `solve_adaptive` is the Ceph scheduling-quotient column of the compressed
Ceph kernel table (`application:ceph-aggregate:rust:<diamonds>:2:2`), which is
why it was added to the sweep even though it is not one of the headline rows.
It solves **two** demands, so `self.families.len() < COUNTED_TYPE_MIN_REPETITION
* kinds` and the profitability gate declines before any work is done. Measured:
flat at all three published diamond counts, identical work.

## 3. What changed in BENCHMARKS.md and README.md

Nothing, and that is the correct outcome of step 3: the instruction was to
update only rows that moved, and no row moved. The published values in the
headline application table, the RSS table, the direct CP-SAT stress table and
the compressed Ceph kernel table all stand as recorded, and they were re-derived
from the same binaries the documents describe. No hash in
`evidence/c985-application-readme-ab.json` or `evidence/benchmarks.json` was
touched, because no measurement those files back was superseded.

The old row values therefore remain the current row values; the evidence history
is extended, not rewritten, by the new file
`evidence/c1050-application-counted-type-ab.json`.

## 4. Subsumption: the Azure compiler is not subsumed

**Verdict: keep `applications::azure_lrc_12_2_2_counted`. No code was retired.**

The two paths were compared directly on a grid of Azure LRC(12,2,2)
upgrade-domain instances by `examples/c1050_azure_subsumption.rs`, which runs on
each instance the bespoke compiler, the generic reduction
`azure_lrc_12_2_2_upgrade_domains(..).solve_counted_types()`, and
`solve_adaptive` as an independent oracle. Certificate:
`evidence/c1050-azure-subsumption.tsv`.

```text
nix shell nixpkgs#cargo nixpkgs#rustc --command \
  cargo build --release --example c1050_azure_subsumption
choom -n 1000 -- taskset -c 3 \
  <shared-target-dir>/release/examples/c1050_azure_subsumption \
  > evidence/c1050-azure-subsumption.tsv
```

Three separate facts each independently block retirement.

**The published instance is not even constructible for the generic path.**
`solve_counted_types` requires `dense_state_space()`, which is the product of
`capacity + 1` over all nine upgrade domains and is capped at
`MAX_DENSE_LATTICE_STATES = 2^24`. The headline Azure row has nine domains at
capacity 100,000, so the product is `100,001^9`, about `10^45`. The method
returns `Ok(None)` before doing any work. Every capacity-100,000 row of the
probe reports `not-constructible` for this reason. There is no instance-size
tuning that fixes this; it is a declared cap in the source, and raising it to
cover the published row would mean materializing more states than there are
atoms in reach.

**Where the generic path can run, it usually declines.** Across capacities 1
through 12, it certifies only at capacity 5 and below, and only once the demand
count is large enough (24 demands at capacity 1--4, 60 at capacity 5). At
capacity 6, 8 and 12 it declines at every demand count from 1 to 1,200 — its
multiplicity certificate fails, exactly the boundary C1038 described. The
bespoke compiler answers all of them.

**Where it does certify, parity holds and it is orders of magnitude slower.**
Every certifying cell agrees with the bespoke compiler and with the
`solve_adaptive` oracle; there is no `GENERIC-MISMATCH` or
`BESPOKE-ORACLE-MISMATCH` anywhere in the probe. But the cost gap is not noise:

| capacity | demands | generic status | bespoke ns | generic ns | generic / bespoke |
| -------: | ------: | :------------- | ---------: | ---------: | ----------------: |
| 1 | 1,200 | certified | 150 | 178,422 | 1,189x |
| 2 | 1,200 | certified | 60 | 152,444 | 2,541x |
| 3 | 1,200 | certified | 100 | 478,942 | 4,789x |
| 4 | 1,200 | certified | 1,252 | 16,815,753 | 13,431x |
| 5 | 1,200 | certified | 822 | 52,209,486 | 63,515x |
| 6 | 1,200 | declined | 932 | 3,258,991 | -- |
| 12 | 1,200 | declined | 181 | 136,384 | -- |
| 100,000 | 100,000 | not constructible | 50 | -- | -- |

The generic path pays instance construction linear in the demand count plus a
dynamic program over the dense nine-dimensional capacity lattice; the bespoke
compiler's work is `totals_checked`, bounded by the capacity, and it never
builds a `WeightedRepairProblem`. So the requirement "parity holds and the
generic path is not slower by more than noise" fails on both clauses at once.

The bespoke compiler has exactly two callers, `bench_kernels`'s `azure` variant
and the `ergodis` CLI's `azure-lrc-12-2-2` subcommand; both call the same
function, so this verdict covers every row that uses it. No other row uses it.

Because nothing was retired, no core file under `src/` was edited, and the
PERFORMANCE.md gates for a core edit (zero-allocation test, counter A/B against
a retained binary, parity) do not apply to a change that was not made. The
counter A/B that does exist for the counted-type reduction itself is C1038's,
in `evidence/c1038-counted-type-ab.tsv`, and it is unaffected.

## 5. A harder repair-DAG instance, predeclared as a diagnostic

Raised by C1053 (`notes/2026-09-02-c1053-repair-dag-map-merge.md`, commit
`546cf2fec`): the published repair-DAG row — three layers of twenty-one tasks,
unit capacities — visits only **four** BFS states per solve, because every ready
set fits the capacities whole and `schedule_repair_dag` takes its whole-ready
fast path at every layer. That row therefore never enters the
`batch = (batch - 1) & ready` subset descent, which is where the kernel's cost
lives. The published row is not wrong and is not being replaced; it is simply
not diagnostic of the descent.

Per C1053's request, the published repair-DAG row's application A/B was not
re-run for their change. The measurements in section 2 above compare `a5e844f73`
with `f40abec7c`, both of which precede `546cf2fec`, so they say nothing about
C1053's edit. The one sentence C1053 supports about their own change is that it
costs 3.8% fewer instructions and 21% fewer branch misses at unchanged cycles.

**Predeclaration, fixed before the new row was measured.** A contended repair
DAG has the same layered precedence structure but two shared resource
dimensions, each of capacity `c`, with task `j` of every layer loading one unit
of dimension `j mod 2`. When `c` is smaller than the per-dimension ready count,
no ready set fits whole, the fast path never fires, and the subset descent runs
on every popped state. Predicted before measurement:

1. `states_examined` rises from 4 to at least three orders of magnitude more;
2. the optimal makespan rises above `layers`, to `layers` times the per-layer
   slot count forced by the capacity;
3. ergodis still returns the exact optimum faster than the CP-SAT interval
   control, but by a visibly smaller margin than the published row's 167x,
   because the descent cost is now real work rather than a fast-path skip.

This is recorded as a diagnostic row, in the sense of the negative-control tier:
its purpose is to measure the kernel where its cost lives, not to add a
favourable headline.

**The instance.** Twelve tasks per layer, three layers, two resource dimensions
at capacity three. Thirty-six tasks is the largest layered instance of this
shape that fits the kernel's 63-task `u64` state mask at width twelve. The
closed-form optimum is six unit slots, two per layer, and the example asserts
its answer against that closed form. Fixture and driver:
`examples/c1050_repair_dag_contended.rs`; independent control:
`python/c1050_repair_dag_contended_control.py`, OR-Tools 9.14 CP-SAT with
cumulative unit intervals and one worker, written against starts, precedence and
per-dimension capacity only — it never mentions batches or ready sets. Both
sides prove the same optimum of six on every sample.

**Measured**, seven paired rounds, same protocol as section 1, run twice:

| profile | ergodis end to end | control end to end | ratio | ergodis in process | control in process |
| :------ | -----------------: | -----------------: | ----: | -----------------: | -----------------: |
| cold (1 solve) | 116.3 ms | 509.7 ms | 4.38x to ergodis | 111.6 ms | 48.1 ms |
| warm batch (8 solves) | 115.2 ms | 83.5 ms | 1.38x to the control | 114.4 ms | 24.6 ms |

Peak RSS: 2.7 MiB against 74.0 MiB. States examined: 9,955 per solve, against
four on the published row. The second run reproduced the ratios at 4.54x cold
and 1.25x to the control warm.

**Two predictions held, the third failed, and the failure is the finding.**
States rose from 4 to 9,955 and the makespan rose from three to six, both as
predicted. But ergodis does not win this instance on solve work: excluding
process startup, the control is 4.66x faster on the warm profile. The 4.38x cold
margin is almost entirely the control's Python interpreter and OR-Tools import,
about 460 ms, which the fresh-process protocol correctly charges to it. Reported
as a loss rather than moved or dropped.

The mechanism is visible in the kernel. The descent enumerates every subset of
the ready mask at each popped state — `batch = (batch - 1) & ready`, so `2^12`
subsets per state here — and tests each with `batch_fits`, whereas CP-SAT
propagates the cumulative constraint instead of enumerating. The absorption
mechanisms this shape names are a capacity-aware batch enumeration that skips
infeasible subsets rather than testing them, and a dominance rule over batches
that keeps only maximal feasible ones. Neither is implemented, and neither is
claimed here to be sufficient to overtake the control.

A new subsection was added to `BENCHMARKS.md` recording this row next to the
published one, with the same caveats. The published repair-DAG row was not
altered.

## 6. Gates

Run through `~/.claude/bin/run-quiet` in
`papers/complete-repair-ports/ergodis`, with the `nix shell nixpkgs#cargo
nixpkgs#rustc` toolchain, after the final edit.

| gate | command | result |
| :--- | :------ | :----- |
| format | `cargo fmt --all --check` | exit 0, no output |
| lint | `cargo clippy --all-targets --all-features -- -D warnings` | exit 0, `Finished dev profile ... in 15.16s`, no warnings |
| tests | `cargo test --all-features` | `561 passed; 4 failed`, all four `sat::tests::*` |
| manifest | `sha256sum -c SHA256SUMS` | `BENCHMARKS.md: OK` after refreshing its line |

The four test failures are the pre-existing `sat` failures C1038 recorded in its
section 7: `accepts_direct_coloring_domains_wider_than_one_word`,
`certifies_clique_without_multipartite_graph`,
`certifies_triangle_with_two_colors` and
`rejects_non_coloring_clause_shapes`. This task changed no file
under `src/`, so it cannot have caused them, and the count is identical to
C1038's.

**A pre-existing test-gating defect, raised not fixed.** A plain `cargo test`
without `--all-features` fails a fifth test,
`tests/cli.rs::transfer_tower_parallel_cli_matches_sequential_json`, which
passes under `--all-features`. The test compares the parallel CLI path against
the sequential one but is not gated on the `parallel` feature, so it fails
whenever the feature is off. The crate's own validation gate in `AGENTS.md`
specifies `--all-features`, so the documented gate is green; the defect is that
the default `cargo test` is not. It is untouched here.

## 7. What did not move, stated exactly

The following are unchanged and were **not** re-measured against their external
controls, because the ergodis side of each was re-measured and found identical
in work and answer, and the controls are unaffected by a Rust scheduler change:
the cold and warm speedup columns and the RSS columns of the six-row headline
application table; the direct and counted CP-SAT stress table; the compressed
Ceph kernel table; and every ratio in the Jin--Fu, MATA, contextual-state and
GF(27) sections, which this task did not touch at all.

No claim is made about any row not listed in section 2. In particular the
external control times in `BENCHMARKS.md` are quoted from
`evidence/c985-application-readme-ab.json` and `evidence/benchmarks.json` as
recorded; this task did not rerun Graphillion, HiGHS, CryptoMiniSat, OR-Tools
max-flow or CP-SAT for those rows.

## 8. Artifacts and hashes

| path | SHA-256 |
| :--- | :------ |
| `evidence/c1050-application-counted-type-ab.json` | `7cc4bd5ee4c41cc9f81376428602cfec3c9a3d263804ac0573bccb1077a7af17` |
| `evidence/c1050-application-counted-type-ab.raw.jsonl` | `5b28d114b42d3560506f1815a56f0dfe069db762ce501495c9cdded3556a3e84` |
| `evidence/c1050-azure-subsumption.tsv` | `4a7ad6b464076efdd45a3007913495e299955e8be66d6a5d24189592ccf06635` |
| `evidence/c1050-repair-dag-contended-ab.json` | `d7b7e76d7a5e3b2d3347e1bffb53e8d742b169409b5fd8245aaf161ed9d859d6` |
| `evidence/c1050-repair-dag-contended-ab.raw.jsonl` | `d681152ae29862c3817ebc896e411927899d6b7f99a06de903b90ff6c156b53c` |
| `examples/c1050_azure_subsumption.rs` | `cca014e9ed8ea17160bd73750aa28ddab1f6c9c20f40aaf90f46f29d3fcb1049` |
| `examples/c1050_repair_dag_contended.rs` | `99e70ae0be1e2dbb8af43024511f12101dfc2340199db835e3f31ee5dc577e9c` |
| `python/run_c1050_application_ab.py` | `46f4d391162eff6760879c1cd790b743db7cd1ba99c3f5944681905c8237bb0f` |
| `python/run_c1050_repair_dag_contended_ab.py` | `a729086b903556200fa6b551ffad07265aa28f519642ccac3660422138c894b2` |
| `python/c1050_repair_dag_contended_control.py` | `7479b2378f93697ee23d201daf04dea2dbcbc6ccada705265de43206bf9d76a9` |
| `BENCHMARKS.md` after the diagnostic subsection | `da278d12525624e356798573542d8a5ab421c21fb7131157b5b243516268e673` |

`SHA256SUMS` records `BENCHMARKS.md`, so its line was refreshed to the value
above. That manifest carries pre-existing drift unrelated to this task —
`Cargo.lock`, `Cargo.toml`, `README.md`, `python/README.md` and several
`python/check_c997_*.py` entries that no longer exist all fail `sha256sum -c`
before and after. Only the line this task invalidated was refreshed; regenerating
the manifest with `python/generate_evidence.py` would also rewrite
`evidence/results.json`, which this task does not own.

The work is left uncommitted in the working tree for review.

## 9. Mystery ledger

**Settled by this task.**

- *Why the published Azure row is 160x while the same-shape W3 row was 2.35x.*
  Settled by reading and confirmed by the probe: they do not share a code path,
  and the generic path cannot even construct the published Azure instance. The
  `dense_state_space` cap of `2^24` against a `100,001^9` lattice is not a
  tuning gap but a categorical one.
- *Whether the counted-type reduction quietly improved any published row.* It
  did not, and the identical work counters on every cell make that a positive
  result rather than an absence of evidence.

**Open, with the gate named.**

- *The repair-DAG kernel loses on its own descent.* On the contended instance
  CP-SAT is 4.66x faster on solve work. The gap is a subset enumeration against
  a propagator, and it is unexplored territory: nothing measures where the
  crossover sits as the ready width or the capacity varies. A ladder over ready
  width at fixed capacity, in the style of the C1038 bounded subset-sum ladder,
  would locate it. Owning successor: a new task in this lane; not allocated
  here.
- *The counted-type certification rate on Azure-shaped instances is low and its
  boundary is not characterized.* The probe shows it certifying at capacity 5
  and below and declining at 6 and above, at every demand count from 1 to 1,200.
  C1038 named two mechanisms that would raise the rate — tie-breaking the
  relaxed witness to spread usage across types, and re-solving with only the
  binding multiplicity constraints added — and neither is implemented. This
  probe adds the observation that the decline boundary tracks the capacity, not
  the demand count, which is the opposite of what the multiplicity argument
  suggests on its own and is not yet explained.
- *Why `solve_adaptive` costs 93.7 seconds on nine domains at capacity 12 with
  24 demands.* Visible in the probe's oracle column and consistent with the
  quadratic dominance scan C1038 diagnosed on L2, but not separately confirmed
  here. Evidence gap: no frontier-size instrumentation was collected on these
  instances.

No mystery is manufactured: the three items above are the only unexplained
features this task surfaced.

