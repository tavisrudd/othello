# C1053 — repair DAG BFS: merge the two per-state maps

**Lane**: `complete-ports` · date 2026-09-02 · crate `papers/complete-repair-ports/ergodis`

Survey item T3 in `notes/2026-09-02-ergodis-core-perf-quick-wins.md`. Not committed; left in
the working tree for review. Touched paths: `src/applications.rs` and
`evidence/c1053-repair-dag-map-merge.tsv` (both under the crate), plus this report.
`BENCHMARKS.md` is deliberately untouched; the numbers C1050 needs are in their own section
below.

## Verdict

The merge is done, exact, and allocation-free, and it removes 3.8% of the instructions and
21% of the branch misses per solve. It does **not** move the published repair-DAG row: wall
time and cycles are statistically indistinguishable from the control, and the warm-batch
wall time is very slightly worse. The survey's 20-40% estimate for this row was based on a
premise the instance does not satisfy, which the pre-change control makes plain (below).
The real cost on this row was an allocation inside the BFS loop, which is now gone.

## Retained control

Produced before any source edit, from a clean `src/` tree at `HEAD = 3c4dd0293`:

```
scripts/retain-bin.sh . bench_kernels
retained /home/tavis/.cache/ergodis/bin/bench_kernels-3c4dd0293
sha256   ce3e0b06018d5de706f11fa3b0d942632a9e15980e09db92a507475060ff38e1
```

The repair-DAG row of `BENCHMARKS.md` is driven by `bench_kernels` through
`scripts/application-readme-ab.sh` → `python/run_application_readme_ab.py`, variant
`application:rdag:rust:21:3`, profiles `cold` (1 repetition per fresh process) and
`warm_batch` (8 repetitions per fresh process).

Accepted candidate: `bench_kernels-c1053-cap64`, sha256
`f6d1bcac3994dabad84a829ebe9592d4b9f45fc5187997832cc2ccefb0483f10`.

## Premise check made before the edit

The retained control reports the instance's real shape:

```
$ bench_kernels-3c4dd0293 application:rdag:rust:21:3 1
{"variant":"application:rdag:rust:21:3","repetitions":1,"elapsed_ns":220290,"work":4,...}
$ bench_kernels-3c4dd0293 application:rdag:rust:21:3 8
{"variant":"application:rdag:rust:21:3","repetitions":8,"elapsed_ns":41347,"work":32,...}
```

`work` is `states_examined`. The headline instance visits **four** BFS states per solve
(three layers plus the goal pop). In `repair_dag_fixture` each layer's 21 tasks load 21
distinct unit-capacity coordinates, so the whole ready set always fits, the fast path fires
at every state, and the subset descent `batch = (batch - 1) & ready` never runs. Total map
traffic per solve is four lookups and three inserts across the two maps — well under a
microsecond out of about 5 µs per warm solve. Halving that cannot be worth 20-40% of the row.

The time on this row sits in the per-solve shape validation (63 tasks x 21 loads) and in
`batch_fits`, which allocated a fresh `vec![0u32; capacities.len()]` on every call from
inside the BFS loop. That allocation violated the non-negotiable allocation-free solve
invariant in `PERFORMANCE.md`, and no zero-allocation test on this BFS could pass while it
stood. Both changes were made, and are attributed separately below.

## The change

In `src/applications.rs`:

1. **One visit map.** `distance: FxHashMap<u64, u16>` and `parent: FxHashMap<u64, (u64, u64)>`
   become one `FxHashMap<u64, RepairVisit>`:

   ```rust
   #[repr(C)]
   #[derive(Clone, Copy, Debug, PartialEq, Eq)]
   struct RepairVisit {
       previous: u64,   // the old parent.0
       batch: u64,      // the old parent.1
       distance: u16,   // the old distance value
   }
   const _: () = assert!(size_of::<RepairVisit>() == 24 && align_of::<RepairVisit>() == 8, ...);
   ```

   24 bytes, 8-byte aligned, plain data, with the compile-time layout assertion the
   performance contract requires. Fields run largest-alignment-first.

2. **One probe per state.** Insertion goes through `Entry::Vacant` instead of
   `contains_key` followed by two `insert` calls, and `distance[&done]` — previously
   re-probed once per successor — is read once per popped state into `done_distance`.

3. **Presized, non-growing containers.** The map and the queue are reserved before the loop
   from `budget.min(2^tasks.len()).min(REPAIR_DAG_RESERVATION_CAP)`, with the cap at 64
   entries (see the reservation-size experiment below). `batch_fits` now takes a
   caller-owned `&mut [u32]` accumulator that it clears on entry, allocated once before the
   BFS, so the loop performs no allocation at all.

4. **Search separated from serialization.** The goal state now breaks out of the loop and
   the witness backtrack runs after it, so the `#[cfg(test)]`
   `HotLoopAllocationGuard::enter()` brackets the search alone and the batch vectors — which
   are output serialization — are built outside it.

## Why the visit order is unchanged

The ready mask, the whole-ready fast path, the subset descent `batch = (batch - 1) & ready`,
and the FIFO queue are byte-for-byte the same logic. The only thing that could reorder
visits is the visited predicate, and it is the same set: the old code tested
`distance.contains_key`, and `distance`'s key set was always `{0}` united with `parent`'s
key set, because every successor line inserted into both maps under the same key on
consecutive statements. The start state 0 is the sole key in `distance` and not in `parent`,
and it is inserted into the merged map with the same `distance = 0`. The one boundary case
is an empty `ready` mask reaching the fast path: old and new both compute `next == done`,
find it already visited, and skip. So the same successors are enqueued in the same sequence
from the same states, and `states_examined` counts the same pops. The argument is repeated
as a comment above the loop in the source.

Removing the redundant `distance[&done]` re-probe cannot change order either: within one
popped state, `distance[&done]` is loop-invariant, since the only writes are to keys `next`
that are provably absent from the map, and `next != done` whenever a write happens.

## Parity

- **Differential test on 400 randomized instances.** A test-only
  `schedule_repair_dag_two_map_reference` holds the pre-change two-map body verbatim.
  `repair_dag_merged_map_matches_the_two_map_reference_exactly` compares the full `Result`
  — `slots`, `task_batches` (the witness), `states_examined`, and the error variant — on 400
  xorshift-generated instances with 1-3 capacity coordinates, 1-10 tasks, randomized
  acyclic predecessor masks, and randomized budgets that make `Budget` errors common. All
  400 agree exactly.
- **Existing suite.** Every existing applications test passes unchanged, including
  `repair_dag_scheduler_respects_precedence_and_full_duplex_capacity`, which asserts the
  batch witness contents.
- **Headline instance, old binary vs new.** Over all 216 A/B samples the reported `work`
  (`states_examined`) and `checksum` (accumulated `slots`) sets are single-valued and equal
  across arms: cold `work=4, checksum=3`; warm-batch `work=32, checksum=24`; the 1024-
  repetition profile `work=4096, checksum=3072`. `bench_kernels` additionally asserts
  `slots == layers` on every solve.

## A/B

Interleaved, order-rotated by round, one process per sample, pinned to CPU 3 with `taskset`,
`choom -n 1000`, counters from `perf stat -x,` on `instructions`, `cycles`, `branches`,
`branch-misses`, peak RSS from the binary's own `peak_rss_kib`. Single-threaded throughout —
this kernel has no parallel mode, so the single/parallel pair required by the contract
collapses to the single-thread case. 36 paired rounds per profile for the accepted
candidate. Profiles `cold` (1 repetition) and `warm_batch` (8 repetitions) are exactly the
`BENCHMARKS.md` boundaries; `kernel` (1024 repetitions) is added here so that process
startup, which dominates the other two profiles, stops hiding the kernel's own counters.

Raw samples, medians, paired statistics, and the sampler are in
`evidence/c1053-repair-dag-map-merge.tsv`
(sha256 `e827516056104b214ab0d3a09e2283a2a36fe58b76ec8a6582f1bc731f982dc0`).

Paired log-ratios, new over old (geometric mean; negative is better):

| profile    | metric        | pairs | new/old | delta   | t      |
| :--------- | :------------ | ----: | ------: | ------: | -----: |
| cold       | elapsed_ns    |    36 |  0.9283 |  -7.17% |  -1.08 |
| cold       | cycles        |    36 |  0.9898 |  -1.02% |  -0.92 |
| cold       | instructions  |    36 |  0.9980 |  -0.20% | -12.29 |
| cold       | branches      |    36 |  0.9986 |  -0.14% |  -5.23 |
| cold       | branch-misses |    36 |  1.0008 |  +0.08% |  +0.36 |
| warm_batch | elapsed_ns    |    36 |  1.0368 |  +3.68% |  +3.04 |
| warm_batch | cycles        |    36 |  1.0077 |  +0.77% |  +0.94 |
| warm_batch | instructions  |    36 |  0.9815 |  -1.85% | -228.7 |
| warm_batch | branches      |    36 |  0.9871 |  -1.29% |  -98.1 |
| warm_batch | branch-misses |    36 |  1.0010 |  +0.10% |  +0.50 |
| kernel     | elapsed_ns    |    36 |  1.0016 |  +0.16% |  +0.04 |
| kernel     | cycles        |    36 |  1.0028 |  +0.28% |  +0.20 |
| kernel     | instructions  |    36 |  0.9618 |  -3.82% | -27748 |
| kernel     | branches      |    36 |  0.9775 |  -2.25% | -10670 |
| kernel     | branch-misses |    36 |  0.7918 | -20.82% |  -27.5 |

Per-solve medians on the startup-amortized `kernel` profile:

| metric        |    old |    new | delta   |
| :------------ | -----: | -----: | :------ |
| instructions  | 58,486 | 56,255 | -3.82%  |
| branches      | 13,057 | 12,763 | -2.25%  |
| branch-misses |   20.1 |   16.1 | -20.8%  |
| cycles        | 18,621 | 18,845 | +1.21%  |
| wall ns       |  7,620 |  7,699 | +1.04%  |

Reading. The instruction, branch, and branch-miss reductions are real and, being
deterministic, carry enormous t-scores. The cycle and wall-time effects are not
distinguishable from zero on the cold and 1024-repetition profiles. The warm-batch wall
regression of +3.7% has t = 3.04, so it is small but detectable: it is about 250 ns per
solve, consistent with the cost of the three presizing allocations on an instance that only
visits four states. On this instance the reservation is pure overhead; on any instance the
kernel is actually intended for it is what keeps the search allocation-free. The host was
carrying concurrent load from other lanes during these runs (the same control binary's
1024-repetition wall time varied 2.3-7.8 ms across runs), which is why cycles and wall
carry large variance while instruction counts do not.

## Peak RSS

Unchanged at the reported resolution. Median `peak_rss_kib` over the 36 accepted-candidate
rounds: cold 2,120 old / 2,120 new; warm-batch 2,072 old / 2,076 new; 1024-repetition 2,088
old / 2,088 new. The `BENCHMARKS.md` repair-DAG RSS figure of 2.0 MiB is unaffected. The
64-entry reservation costs about 2.5 KiB, which is below that table's resolution — this was
the reason for choosing that cap over the larger ones.

## Reservation size: the experiment that set the cap

The presize cap is measured, not guessed. Three candidates were built and A/B'd against the
same retained control on the same protocol:

| cap  | reserved bytes | cold wall | warm-batch wall | kernel instructions | verdict  |
| :--- | -------------: | --------: | --------------: | ------------------: | :------- |
| 4096 |       ~134 KiB |   +59.11% |         +35.56% |              -3.22% | rejected |
| 256  |       ~8.5 KiB |    +2.38% |          +9.07% |              -2.61% | rejected |
| 64   |       ~2.5 KiB |    -3.98% |          +3.43% |              -3.82% | accepted |

(Medians; the 4096 and 256 rows are 11 and 15 rounds respectively, on separate runs, so
compare each against its own control column in the evidence file rather than across rows.)

At 4096 entries the reservation's page faults cost about 8 µs per fresh process, which is
larger than the entire solve. This is the reason the cap exists and why it is small. The
residual: an instance that reaches more than 64 states still grows both containers, so it is
not allocation-free. Bounding that properly needs the designed capacity-exhaustion return
path `PERFORMANCE.md` calls for, which is a larger change than C1053 and is not attempted
here. The zero-allocation test asserts its instance stays inside the reservation so the test
cannot silently become vacuous.

## Zero-allocation test

`repair_dag_bfs_allocates_nothing_after_entering_the_search` runs a width-3, 3-layer
instance with capacities `[1, 1]` and per-task loads chosen so the whole ready set never
fits — the subset descent and the repeated `batch_fits` calls are both exercised, unlike the
headline fixture. It warms up once outside the measurement, then enters the BFS eight more
times, each time asserting the answer equals the warm-up answer and that
`AllocationEvents` is all zeros. It uses `measure_allocations` rather than
`measure_current_thread_allocations` on purpose: the measured region must be the guard
inside `schedule_repair_dag`, which brackets the search alone, not the whole call including
presizing and witness serialization. The instance examines 19 states, inside the 64-entry
reservation.

The test fails on the pre-change code, as it should: run against the old body it reports
`allocations: 10, reallocations: 8, deallocations: 3`.

## Gate output, verbatim

Run through `~/.claude/bin/run-quiet` in `papers/complete-repair-ports/ergodis`:

```
$ cargo fmt --all --check
exit=0 time=1sec 709ms 477µs 224ns
stdout: 0 lines
stderr: 0 lines

$ cargo clippy --all-targets -- -D warnings
exit=0 time=7sec 562ms 623µs 747ns
   Checking ergodis v0.1.0 (/home/tavis/src/othello/papers/complete-repair-ports/ergodis)
    Finished `dev` profile [unoptimized + debuginfo] target(s) in 6.88s

$ cargo test
exit=0 time=19sec 503ms 775µs 439ns
test result: ok. 441 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 8.16s
(every other target and the doc-tests: 0 failed)
```

One environment note that is not mine and not a regression: `cargo test` with
`XDG_CACHE_HOME` unset fails four `sat::tests` cases. `test_cache()` in `src/sat.rs` falls
back to `current_dir().join("target")`, which does not exist because the crate builds
out-of-tree per its `.cargo/config.toml`, so the tests cannot create their CNF scratch
files. Setting `XDG_CACHE_HOME` to any existing directory makes the whole suite pass. The
failure reproduces identically at `HEAD` without my change. Worth a small fix by whoever
owns `sat.rs` — the fallback should be the crate's real target directory or a `tempfile`.

## Numbers for C1050 to fold into BENCHMARKS.md

C1050 owns `BENCHMARKS.md` today, so nothing there was edited. What that file needs:

1. **The repair-DAG headline row does not change.** Cold and warm speedups (167.12x /
   275.15x), the cold wall/solve figure, and the 2.0 MiB ergodis RSS all stand as published.
   Wall time is statistically unchanged; the counter improvements are below the resolution
   of a speedup ratio.
2. If a per-row counter note is wanted, the defensible sentence is: the repair-DAG kernel
   executes 3.8% fewer instructions and 21% fewer mispredicted branches per solve after
   C1053, with wall time and cycles unchanged, measured over 36 interleaved paired rounds
   against retained control `bench_kernels-3c4dd0293`
   (`evidence/c1053-repair-dag-map-merge.tsv`).
3. **Do not re-run the full application A/B on my account.** The Python-control side is
   untouched, and the ergodis side did not move; re-running would only re-roll noise into a
   published table.

## Accepted and rejected variants

Accepted:

- one `FxHashMap<u64, RepairVisit>` (24-byte `#[repr(C)]` record) replacing the two maps;
- `Entry::Vacant` insertion in place of `contains_key` plus two inserts;
- `done_distance` hoisted to one read per popped state;
- `batch_fits` taking a caller-owned load accumulator;
- goal handling moved out of the loop so the allocation guard covers search only;
- presize cap of 64 entries.

Rejected, with the reason, so this is not re-tried:

- **Presize cap 4096** (the natural "reserve the budget" reading of the survey item): cold
  wall +59%, warm-batch wall +36%. About 134 KiB of fresh pages per process on an instance
  that visits four states. The page-fault cost dwarfs the whole solve.
- **Presize cap 256**: cold +2.4%, warm-batch +9.1%, about 7,000 cycles per solve. Still
  above the malloc arena's cheap path.
- **Presizing from `budget` or `2^tasks.len()` without a cap**: not viable — the benchmark
  passes `budget = 1 << 28` and the headline instance has 63 tasks, so both bounds are
  astronomically larger than the reachable state count.
- **Dropping the presize entirely and keeping only the map merge**: gives the best wall time
  on this particular row, but the queue then grows inside the loop and the zero-allocation
  gate this task requires cannot pass. Rejected on the contract, not on the measurement.
- **Packing `distance` into a spare bit range of `previous` to shrink `RepairVisit` to 16
  bytes**: not attempted. The map is not the bottleneck on any measured instance, so a
  denser record would buy nothing here and would cost a mask-and-shift on every read.

## Mystery ledger

1. **Why the published row is 167x/275x at all, given a four-state BFS.** Settled by the
   `ej`/`tt` pass: the ergodis side of the row is not a search at all on this fixture — the
   layered unit-capacity structure makes every ready set fit, so the kernel is really
   measuring per-solve validation and `batch_fits` against a CP-SAT control that builds and
   solves a real interval model. The multiplier is honest as a matched end-to-end
   comparison, but it is not evidence about BFS search quality, and no future optimization
   of the BFS proper will move it. **Open item for the lane:** the repair-DAG row's
   bounded instance does not exercise the subset descent, which is where this kernel's
   exponential behaviour lives. A second bounded instance with contended capacities would
   make the row informative about the search. Not allocated; needs a C-ID and C1050's
   agreement since it changes `BENCHMARKS.md`.
2. **Why cycles do not follow instructions.** -3.8% instructions and -21% branch misses buy
   +0.3% cycles (t = 0.20, i.e. nothing). The kernel is not front-end or
   mispredict-limited; at ~3.1 instructions per cycle it is running well and the removed
   work was on paths the machine was already absorbing. Partially settled — the loaded host
   inflates cycle variance enough that a genuine 1-2% cycle effect could hide inside these
   error bars. Re-measuring on a quiet host would close it; it does not change the verdict.
3. **The warm-batch +3.7% wall regression.** Attributed to the three presizing allocations
   per solve, on the arithmetic (250 ns per solve, three allocations, one of them a ~2 KiB
   hashbrown reserve that memsets control bytes). Not independently confirmed by a
   perf-record attribution, because the effect is a few hundred nanoseconds inside a 5 µs
   process. Evidence gap stated; the cap sweep across 4096/256/64 shows the monotone
   relationship between reserved bytes and this regression, which is the supporting
   argument.
4. **The allocation-free invariant is still only conditionally satisfied.** Instances
   reaching more than 64 states grow the map and queue. This is a real, stated gap against
   the non-negotiable invariant in `PERFORMANCE.md`, owned by a successor task that adds the
   designed capacity-exhaustion path. C1053 strictly improves the position — the old code
   grew from empty on every instance and allocated inside `batch_fits` on every call — but
   does not close it.
