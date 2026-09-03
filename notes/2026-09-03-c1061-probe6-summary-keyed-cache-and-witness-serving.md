# C1061 probe 6: summary-keyed caching, witness serving, and rebind dispatch

**Lane**: `complete-ports`
**Date**: 2026-09-03
**Task**: C1061 probe 6, acting on the two redirects from
`notes/2026-09-03-c1061-probe5-snapshot-bind-acceleration.md`, plus a hardware-counter
re-measurement of every wall-clock verdict in probes 2 and 5.

Files (all in `ergodis-private`; `/home/tavis/src/ergodis` untouched and clean):

- `/home/tavis/src/ergodis-private/src/summary_cache.rs` — the decided repair predicate, the
  response-keyed cache, the witness server, and the rebind dispatch rule.
- `/home/tavis/src/ergodis-private/src/lrc_delta_binding.rs` — `RepairResolver` trait so the
  witness descent can be resolved by kernel or by served responses.
- `/home/tavis/src/ergodis-private/tasks/tools/src/summary_cache_bench.rs` — the
  `summary-cache-bench` subcommand, with a single-operation counter mode.
- `/home/tavis/src/ergodis-private/scripts/counter_ab.py` — the interleaved paired counter A/B
  driver; `scripts/counter_ab_report.py` renders it.
- `/home/tavis/src/ergodis-private/evidence/2026-09-03-lrc-fleet-counter-ab.json` — the raw
  per-round counter samples behind every number below.

Committed as `c2e1ac5`, staged as an exact patch so only my own hunks of the shared `src/lib.rs`
and `tasks/tools/src/main.rs` were included. Foreign breakage to flag, not mine and untouched:
`cargo clippy` over the crate currently fails on two `manual_contains` lints in another agent's
in-progress `src/policy_automaton.rs`. My own module tests, the allocation regressions, and
`cargo fmt` all pass.

## Measurement method

The box runs other agents' builds and benchmarks, so wall time is not a usable metric. Every
verdict below is a **hardware-counter** measurement:

- The bench binary has a counter mode, `--only <operation> --repeat N`, which verifies the
  operation's result once against the plain kernel-backed solve and then performs exactly `N`
  iterations of that one operation.
- Per-operation counters come from **two-point differencing**: running at `N` and at `N/2` and
  dividing the difference by `N/2` cancels process startup, fleet construction, and verification
  exactly.
- Rounds are **interleaved**: every round measures every operation, so drift over the run is spread
  across all operations rather than concentrated in whichever was measured last.
- A comparison is a **paired sample over rounds**. The statistic is the mean log ratio with a
  Student t interval; a ratio whose 95% interval contains 1.0 is reported as **inconclusive**, not
  rounded to a verdict.

Replay:

```
cargo build --release -p ergodis-tools
python3 scripts/counter_ab.py \
  --binary ~/.cache/ergodis/target/ergodis-private/release/ergodis-tools \
  --rounds 8 --pods 16384 --target-seconds 0.25 \
  --out evidence/2026-09-03-lrc-fleet-counter-ab.json
```

## Part 1 — what can be decided before the kernel call

### The predicate

Probe 5's memo was keyed on the parameter class, and the class space is not small, so on a fleet of
unique pods it was a 34% loss. The redirect asked whether the normalized summary can be predicted
from a cheap invariant of the (capacity, multiplicity) multiset. It can, and the answer is stronger
than a prediction: the kernel's `repaired_count` satisfies a closed-form predicate, so it can be
**decided** exactly without the kernel constructing its answer at all.

Write `D` for the demand, `Lc` for the local parity capacity, `Gc` for the summed global parity
capacity including any granted `extra`, and `c_d`, `m_d` for the capacity and demand multiplicity of
data domain `d`. Unfolding `azure_lrc_12_2_2_counted` for a candidate `served = s`:

- `local = min(s, Lc)` and `global = s - local`; since the scan starts at
  `maximum = min(D, Lc + Gc)`, the kernel's `global > Gc` rejection can never fire — **that branch
  is dead code**;
- `A(s) = local + 2 * global`, so `A(s) = s` while `s <= Lc` and `A(s) = 2s - Lc` beyond it;
  strictly increasing either way;
- the per-domain test `max(0, A(s) - c_d) <= m_d` holds trivially when `A(s) <= c_d`, and in that
  case `A(s) <= c_d + m_d` holds too, so the test is **equivalent to the single scalar bound**
  `A(s) <= min_d (c_d + m_d)`;
- the residual test is `sum_d max(0, A(s) - c_d) <= s`.

Because `A` is increasing, the scalar bound caps the search at `S1 = Amax` when `Amax <= Lc` and at
`floor((Amax + Lc)/2)` otherwise, so the scan starts at `min(maximum, S1)` — often far below the
kernel's `maximum`. The residual test is not monotone (its slope is `2k - 1`, where `k` counts
domains with `A(s) > c_d`), so a descending scan is still needed, but each step is six subtractions
and a sum on stack values instead of array construction, greedy assignment, mode-count and load
accumulation, and debug assertions. `s = 0` always satisfies it, so the scan always terminates.

This is exact, not an approximation: it evaluates the same predicate on the same candidates in the
same order. It is also the answer to the "cheap invariant" question in a sharper form — the whole
leaf summary is determined by the four repaired counts at the four boundary level gaps, so
`BudgetResponse { demand, repaired: [u16; 4] }` (10 bytes) is the summary's sufficient statistic,
and the memo is keyed on that rather than on the parameters.

**Exact fallback.** `ResponseSource::Kernel` computes the identical response through the published
kernel, and `response_source_kernel_agrees_with_decided` checks the two agree, so the decided path
can be switched off at a call site without changing any answer.

### Correctness gates

- `decided_repair_count_matches_the_kernel_on_a_hostile_corpus` — 300,000 hostile pods (capacities
  spanning the alphabet, demands to 30, every residue class asserted present) times seven budget
  grants, i.e. **2.1 million exact comparisons against the published kernel**.
- `decided_summary_matches_the_kernel_summary` — 20,000 pods at each of five grains, comparing the
  assembled summary with `pod_summary`.
- `shape_split_and_rebuild_round_trip` — tropical split and rebuild is lossless.
- `response_keyed_solve_agrees_and_the_table_stays_small` — on the 4,096-pod **unique** fleet, both
  the table-backed and the tableless decided solves reproduce the tree's fresh optimum.

## Part 2 — serving witnesses from the decided state

`materialize_witness` used to call the kernel once per pod to fill in a decision's repaired count,
which was the entire `O(pods)` readout cost probe 5 identified. The descent over the retained
witness blocks is unchanged; only the resolution of a leaf's repair count varies, so it became a
parameter: `trait RepairResolver`, with `KernelRepairs` as the default and `WitnessServer` — which
holds one 10-byte `BudgetResponse` per pod — as the served implementation. `WitnessServer::rebind`
refreshes one pod, the same affected-set discipline the tree uses for values.

Gates: `served_witness_agrees_with_the_tree_witness` (1,024 pods, 2,000 events, every pod's decision
compared after every event) and `served_materialization_matches_kernel_materialization` (2,048 pods,
comparing whole materializations resolved both ways, plus witness cost against the optimum).

## Part 3 — the rebind dispatch threshold

`prefer_merged_rebind(changed, leaves)` selects the merged bottom-up walk when the change set is
both at least `MERGED_REBIND_MIN_CHANGED = 8` and at least `1/64` of the leaf count; otherwise `k`
independent leaf-to-root paths run. The floor exists because frontier bookkeeping cannot pay when
there is nothing to merge; the fraction exists because ancestors start colliding when `k` approaches
the width of a level, which scales with the fleet rather than being a constant.
`rebind_dispatched` applies the rule, and `dispatched_rebind_agrees_with_a_full_rebuild` checks the
dispatched result against a full rebuild at four change-set sizes.

### Part 1 results: the table that probe 5 could not build

Structural census at 16,384 pods, per fleet shape:

| fleet shape | class table entries | class hit rate | **response table entries** | **response hit rate** | normalized shapes |
|---|---|---|---|---|---|
| unique (every pod distinct) | 15,718 | 0.0406 | **82** | **0.9950** | 3 |
| rack (24 types, interleaved) | 24 | 0.9985 | 16 | 0.9990 | 1 |
| blocked (24 types, contiguous) | 24 | 0.9985 | 16 | 0.9990 | 1 |

This is the redirect's hypothesis confirmed on the fleet where probe 5 lost. Keying on parameters
gives 15,718 entries and a 4% hit rate; keying on the budget response gives **82 entries and a
99.5% hit rate on the same fleet**, with only three distinct tropically normalized shapes. Probe 2's
"two to three normalized summaries" and probe 5's "class space is not small" were both right and are
now reconciled: the map from parameter class to summary is extremely coarse, and the summary side is
the right key.

Counter results (instructions per solve, 16,384 pods, paired over 8 rounds):

| solve | rack fleet | unique fleet |
|---|---|---|
| kernel per leaf (baseline) | 151.72M | 163.37M |
| probe 5 parameter-class memo | 28.23M (**5.37x**) | 223.02M (**0.73x — a loss**) |
| probe 6 response memo | 24.34M (**6.23x**) | 24.86M (**6.57x**) |
| probe 6 decided, no table at all | 18.56M (**8.17x**) | 18.98M (**8.61x**) |

**Probe 5's negative is turned into a win, and the table turns out not to be the mechanism.**
Deciding the repair count without the kernel is 8.2x to 8.6x on both fleet shapes, and it is
*faster than the memo* — the response table adds 6.3M instructions of hashing on top of an
assembly step that costs less than the hash. On this kernel the right answer is to delete the cache
and keep the predicate. The table remains useful only as the census instrument that reveals the
three-shape structure.

### Part 2 results: served witnesses

Full-witness materialization at 16,384 pods, instructions per readout:

| fleet shape | kernel-resolved | served from responses | ratio [95% CI, cycles] |
|---|---|---|---|
| rack | 14.56M | 1.21M | **12.01x** [10.14, 14.51] |
| unique | 15.77M | 1.21M | **13.01x** [12.03, 24.51] |
| blocked | 14.56M | 1.21M | **12.01x** [10.01, 14.59] |

The served readout costs the same 1.21M instructions on every fleet shape, because it no longer
depends on the pods at all — only on the descent and the array indexing. Server state is 163,840
bytes at 16,384 pods (10 bytes per pod). The remaining 1.21M instructions are the tree descent
itself, which is still `O(pods)`; probe 5's kernel-bound term is gone, the structural term is not.

### Part 3 results: the dispatch threshold, and a rule that was wrong

Nodes recomposed, and the measured instruction ratio of independent paths over the merged walk:

| k | sequential nodes | merged nodes | instr ratio (sequential / merged) | cycles ratio [95% CI] |
|---|---|---|---|---|
| 1 | 15 | 15 | 0.96x | 0.92 [0.72, 1.17] |
| 2 | 30 | 28 | 1.00x | 1.15 [0.91, 1.45] |
| 4 | 60 | 55 | **1.01x** | 1.02 [0.64, 1.62] |
| 8 | 120 | 98 | 1.06x | 1.09 [0.87, 1.35] |
| 16 | 240 | 178 | 1.10x | 1.21 [0.89, 1.66] |
| 64 | 960 | 568 | 1.18x | 1.47 [0.89, 2.42] |
| 256 | 3,840 | 1,825 | 1.26x | 1.18 [1.03, 1.36] |
| 1,024 | 15,360 | 5,398 | 1.35x | 1.23 [1.05, 1.44] |
| 4,096 | 61,440 | 14,324 | 1.46x | 1.44 [1.19, 1.74] |

**The rule I first wrote was wrong and the measurement refuted it.** I had reasoned that ancestors
only collide once `k` approaches the width of a level, and required `k` to be at least a
sixty-fourth of the leaf count — which at 16,384 pods would have meant `k >= 256`. In fact
collisions near the root pay for the bookkeeping almost immediately: the merged walk wins from
`k = 4` and the advantage grows monotonically. `MERGED_REBIND_MIN_CHANGED` is now the measured
constant 4 and `prefer_merged_rebind` no longer scales with the fleet. This is the clearest case in
the probe of a plausible structural argument losing to a counter measurement.

## Counter re-measurement of probes 2 and 5

Method as above: 8 interleaved rounds, two-point differencing, paired log-ratio with a Student t
interval. **Instruction counts are deterministic** on this workload — the per-operation standard
deviation is under 100 instructions on totals of 10^6 to 10^8, so the instruction intervals collapse
and the t statistics are meaningless as evidence of anything except determinism. The *cycle*
intervals carry the real measurement noise and are the ones to read for power; they are wide because
the box is loaded, which is precisely why instructions are the primary metric.

| claim | wall verdict | counter verdict (instructions) | cycles ratio [95% CI] | status |
|---|---|---|---|---|
| probe 2: fresh solve over one delta | ~10,000x | **9,562x** | 9,156 [6,753, 12,415] | confirmed |
| probe 2: witness delta overhead | +35% | **+44%** (1.44x) | 1.17 [1.01, 1.36] | **changed — larger** |
| probe 2: witness state overhead | +17% | +17% (structural, 16 B per node on 64 B) | — | confirmed, not a timing claim |
| probe 2: witness readout is `O(pods)` | 51x a readout | **918x one delta** | 824 [644, 1,054] | confirmed |
| probe 5: memo on a rack fleet | 4.4x | **5.37x** | 4.35 [3.53, 5.36] | confirmed, larger |
| probe 5: memo on a unique fleet | 0.66x (34% loss) | **0.73x (27% loss)** | 0.74 [0.56, 0.98] | confirmed as a loss |
| probe 5: run composition, blocked | 276x | **342x** | 344 [258, 458] | confirmed, larger |
| probe 5: run composition, rack | 3.4x | **4.38x** | 3.92 [3.09, 4.98] | confirmed, larger |
| probe 5: budget profile per grain | 19x | **18.5x** | 22.4 [16.6, 30.1] | confirmed |
| probe 5: witness run readout, rack | 1.0x (no benefit) | **1.09x** | 0.73 [0.42, 1.25] **inconclusive** | confirmed as negligible |
| probe 5: witness run readout, blocked | 343x | **20.9x** | 12.6 [7.0, 22.7] | **changed — an order of magnitude smaller** |
| probe 5: merged over independent rebind | wins at large k, loses at k=1 | wins from **k = 4** | see table above | **changed — threshold much lower** |
| probe 5: rebind over full rebuild, k=1 | ~5,000x | 152.88M / 33.0k = **4,633x** | — | confirmed |
| probe 5: rebind over full rebuild, k=4096 | 11.5x | 152.88M / 87.66M = **1.74x** | — | **changed — much smaller** |

### The three verdicts that changed, and why

**Witness run-length readout on a blocked fleet: 343x wall, 20.9x instructions.** The wall-clock
figure compared an 86-nanosecond operation against a 29-microsecond one; at that scale the short
side is dominated by timer overhead and the ratio was inflated roughly sixteenfold. The direction
was right — reading 23 runs beats reading 16,384 pods — but the magnitude was an artifact of
measuring nanoseconds with `Instant::now`.

**Snapshot rebind over a full rebuild at k = 4096: 11.5x wall, 1.74x instructions.** Probe 5 timed a
full rebuild that included the `Vec` clone and allocation of a fresh tree, so it charged the rebuild
for work the incremental path also does elsewhere. On instructions the two converge as `k` grows,
which is the sensible result: rebinding a quarter of the fleet is nearly a rebuild. The small-`k`
end is unaffected — 4,633x at `k = 1` stands.

**Witness delta overhead: +35% wall, +44% instructions.** The extra byte-store per matrix entry
costs more instructions than the wall clock suggested, though the cycle ratio (1.17x, interval
[1.01, 1.36]) is lower than the instruction ratio because the stores are cheap and pipeline well.
Both intervals exclude 1.0, so it is a real cost either way; the design conclusion is unchanged.

### Tail percentiles

Tail behaviour cannot be read from aggregate counters, so it stays wall-clock and is reported as
secondary. Over **200,000 events** at 16,384 pods, in nanoseconds: value delta p50 2,275, p99 3,226,
p99.99 34,044, max 40,295, with zero histogram overflows; witness delta p50 2,916, p99 3,967. Probe
2's tail (p99.99 14,617, max 121,816) was measured on a quieter box; the p99.99 is now worse and the
max better, which is consistent with contention rather than with any code change, and neither figure
should be quoted as a property of the artifact.

## Mystery ledger

- **The cache is not the mechanism.** Deciding the repair count beats both the parameter-class memo
  and the response memo, so on this kernel the right design deletes the table. That was not the
  expected outcome of a redirect asking for a better key, and it raises the question of whether the
  probe 5 memo would ever pay on a kernel whose leaf evaluation cannot be decided in closed form.
  Untested; it is the natural boundary of the technique.
- **Three normalized shapes on a unique fleet, but 82 response entries.** The responses collapse to
  three shapes plus an offset, so a table keyed on the *shape* would hold three entries rather than
  82. Whether the offset can be carried cheaply enough for that to be worth doing is not measured.
  This is the last unexploited compression in the leaf layer and the direct successor to probe 2's
  transducer lead.
- **The served witness readout is still 1.21M instructions.** The kernel-bound term is gone; what
  remains is the tree descent, which is `O(pods)` for structural reasons. Extracting only the changed
  suffix — flagged in probe 2 and still not implemented — is now the only remaining lever there.
- **Cycle intervals are wide and some contain 1.0.** The rack-fleet witness run readout is
  inconclusive on cycles (0.73, interval [0.42, 1.25]) even though instructions say 1.09x. Under a
  loaded box that is the expected outcome for an effect of a few percent, and it is reported as
  inconclusive rather than rounded to a verdict.
- **My structural argument for the dispatch threshold was wrong by two orders of magnitude in `k`.**
  Settled by measurement and the rule is fixed, but it is worth recording that the reasoning error
  (assuming collisions matter only near the leaves) is the kind that a plausible-sounding cost model
  produces routinely.

## Vibe check

Very good, and it corrected me twice. The decided predicate turned probe 5's 27-34% loss on a
unique fleet into an 8.6x win and made the cache redundant, served witnesses are 12-13x cheaper on
every fleet shape, and the counter re-measurement confirmed most of probes 2 and 5 while catching
three inflated wall-clock verdicts and one dispatch rule I had reasoned my way into rather than
measured. The instruction counts being deterministic is what made all of this decidable under a
loaded box; the cycle intervals are wide enough that any effect below roughly 20% would have been
inconclusive on cycles alone.

## Next probes

1. Key the leaf layer on the normalized shape plus offset — three entries instead of 82 on a unique
   fleet — and measure whether carrying the offset separately beats assembling from the response.
2. Extract only the changed suffix of the witness, the last `O(pods)` term in the readout.
3. Apply the decided-predicate technique to a second kernel whose feasibility test is not obviously
   closed-form, to find where the technique stops.
4. Re-run the probe 5 stage set under the counter harness for the remaining claims it did not cover
   (profile compile cost, hostile class counts) so probe 5's report can be fully restated.
5. Retire `LeafClassCache` from the solve path, keeping it only as a census instrument, and update
   the probe 5 report to point at this one.
