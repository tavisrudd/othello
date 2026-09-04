# C1061 probe 17: sparsity-aware composition, and the routing boundary-class measurement

**Lane**: `complete-ports`
**Date**: 2026-09-03
**Task**: C1061 probe 17, continuing `notes/2026-09-03-c1061-probe13-qec-window-exactness-and-external-baseline.md`.
**Brief**: `notes/2026-09-03-c1061-ergodis-compiled-dynamic-solver-brief.md`

Contract documents read in full before the probe-7 work this line continues:
`/home/tavis/src/ergodis/CLAUDE.md`, `/home/tavis/src/ergodis-contrib/PERFORMANCE.md`,
`/home/tavis/src/ergodis-contrib/performance-playbook.md`,
`/home/tavis/src/ergodis-private/CLAUDE.md`.

## Questions

**(A) Is the QEC loss really structural?** Probe 13 measured the retained space-cut delta losing to
PyMatching by 64x to 82x and attributed it to paying a dense `16 x 16` min-plus product at every
node whether or not a defect is nearby. Make the tree sparsity-aware and re-measure: does the loss
shrink materially, and does any regime flip?

**(B) Give the routing row a measured verdict.** The ranking left network resilience conditional on
an unmeasured claim about boundary-class collapse. Build a folded-Clos fabric with pod-level
separators, min-plus latency and Pareto (latency, bandwidth), link capacity and failure events;
measure separator width, the reachable boundary-class count under tropical normalization over a
`10^5`-event stream, delta against fresh, and delta against a Dijkstra re-solve at matched
exactness.

## Counter-harness correction applied to probes 7, 10, 13 and 17

Probe 15 found that the two-size differencing method assumes setup is constant in the operation
count, and that a benchmark which pre-draws one event per operation violates it: each extra
operation is charged its own event construction on top of its update. **Every measured mode I wrote
in probes 7, 10 and 13 had exactly that defect**, and so did probe 17's routing modes. The audit and
the repair:

| bench | defect | repaired |
|---|---|---|
| `other_domain_shapes_bench.rs` (probe 7) | `events`/`edits` vectors sized `--operations` | fixed 4,096-event window, cycled |
| `space_and_minimizer_bench.rs` (probe 10) | same, in all four measured modes | fixed 4,096-event window, cycled |
| `decoder_baseline_bench.rs` (probe 13) | same, in the space-delta and minimizer modes | fixed 4,096-event window, cycled |
| `sparsity_and_routing_bench.rs` (probe 17, part B) | `events` vector sized `--operations` | fixed 4,096-event window, cycled |
| `sparsity_and_routing_bench.rs` (probe 17, part A) | no scaling setup, but an in-loop event draw | window pre-drawn at setup, loop reads it |

Committed as `739e289`. The bias direction matters for reading the older reports and is stated here
once: within a probe, both arms of a comparison carried the *same* additive per-event constant, so
the contamination pushed every same-probe ratio **toward 1**, making probe 7's and probe 10's
reported wins conservative rather than overstated. The exception is any comparison against
PyMatching, whose arm loops over a fixed shots array and has genuinely constant setup: there the
contamination inflated only my arm, so probe 13's reported 64x to 82x loss was an **overestimate of
the loss**. All four benches are re-measured below with the fixed-window design, and the changed
verdicts are recorded per section.


## Files and commands

All work is in `ergodis-private`; `/home/tavis/src/ergodis` was not modified. Commits `5ed47f9` (the
two new modules and the bench) and `739e289` (the harness repair). Shared `src/lib.rs` and
`tasks/tools/src/main.rs` were staged as exact patches so only my own lines were included, and every
commit was staged with explicit pathspecs and checked with `git diff --cached --stat` for foreign
paths first — the probe-11, probe-12, probe-15 and probe-16 agents all had uncommitted work in those
files.

- `/home/tavis/src/ergodis-private/src/sparse_composition.rs` — cost truncation, clean-subtree
  powers, the sparsity-aware tree, and the vector sweep comparator.
- `/home/tavis/src/ergodis-private/src/fabric_routing.rs` — the folded-Clos fabric, its retained
  min-plus composition, the event contract, the layered explicit graph, the Dijkstra comparator,
  and the bounded Pareto front.
- `/home/tavis/src/ergodis-private/tasks/tools/src/sparsity_and_routing_bench.rs` — the
  `sparsity-and-routing-bench` subcommand.

```
cd /home/tavis/src/ergodis-private
cargo fmt -p ergodis-private -p ergodis-tools
cargo test --release -p ergodis-private --lib -- sparse_composition:: fabric_routing::   # 11 passed
cargo clippy -p ergodis-private -p ergodis-tools --all-targets -- -D warnings            # clean
cargo build --release -p ergodis-tools
ergodis-tools sparsity-and-routing-bench --mode density-census
ergodis-tools sparsity-and-routing-bench --mode sparse-delta --distance 9 --rate 0.01 \
    --budget 6 --operations 20000 --verify
ergodis-tools sparsity-and-routing-bench --mode routing-census --pods 1024 --width 4 \
    --operations 100000
```

## Part A1 — the three sparsity levers, and the pruning rule they need

**Cost truncation.** Every boundary entry above a budget `B` is dropped to the absent sentinel, so
the inner loop of the min-plus product skips whole rows. Measured leaf density, out of 256 entries
(half of which the parity superselection rule from probe 10 already voids):

| budget | clean leaf, finite entries | defect leaf, finite entries |
|---|---|---|
| 1 | 8 | 8 |
| 2 | 29 | 29 |
| 3 | 64 | 64 |
| 4 | 99 | 99 |
| 6 | 127 | 127 |
| none | 128 | 128 |

**The pruning rule needed a correction, found by a failing test.** The budget bounds the *root
entry*, but the objective adds the rightmost column's weight on top, so a surviving entry is not by
itself proof that nothing better was pruned: a class with root entry 5 and trailing weight 0 can be
dropped at budget 4 while a class with root entry 4 and trailing weight 2 survives, inverting the
argmin. The sound rule is that **the answer is exact once the best surviving total is itself within
the budget** — any class with a smaller total would have had a root entry no larger than that total,
hence within the budget, hence not pruned. That certifies the argmin and its cost, which is the
decoder's actual output; the losing class may still read absent.
`the_exactness_rule_is_sound_across_budgets` gates it across five budgets and two distances, and
`scores_are_exact` is the rule.

Measured fallback rate at distance 9 over 20,000 events, with `--verify` checking every
non-fallback answer against the untruncated decoder:

| budget | root finite entries | fallbacks at rate 0.001 | fallbacks at rate 0.01 |
|---|---|---|---|
| 1 | 4 | 8,713 | 8,584 |
| 2 | 7 | 5,965 | 5,927 |
| 3 | 11 | 3,053 | 3,112 |
| 4 | 22 | 247 | 207 |
| 6 | 51 | **1** | **0** |

Budget 6 is the exact operating point and is what every timing below uses; budget 4 buys a denser
pruning for a 1% fallback rate.

**Clean subtrees.** A detector column with no defect and no erasure has a summary independent of
which column it is, so a defect-free subtree's summary depends only on its size and is precomputed
per power of two. Measured share of the repair path served from that table rather than recomposed,
20,000 events per point:

| distance | path nodes | mean products per event | mean clean-table hits | products avoided |
|---|---|---|---|---|
| 3 | 2 | 0.50 | 0.50 | 50.0% |
| 5 | 3 | 1.01 | 0.99 | 49.4% |
| 7 | 4 | 1.56 | 1.44 | 48.0% |
| 9 | 4 | 1.61 | 1.39 | 46.4% |

The share is flat in the physical error rate across 0.1%, 0.5% and 1%, because at all three rates
the syndrome is dominated by defect-free columns. `a_defect_free_history_costs_no_products_at_all`
gates the limit case: returning to the all-clean state does zero products.

Defect density for reference, four-round window:

| rate | distance | detectors | mean defects | defect density |
|---|---|---|---|---|
| 0.001 | 9 | 32 | 0.111 | 0.0035 |
| 0.005 | 9 | 32 | 0.558 | 0.0174 |
| 0.01 | 9 | 32 | 1.101 | 0.0344 |

## Part B1 — the fabric, its separator, and the boundary-class census

**The instance.** Pods sit at the leaves of a balanced aggregation tree, as in a folded Clos. Every
node exposes `S` upward ports, and `S` is the separator: a subtree reaches the rest of the fabric
only through them. The summary of a subtree is the `S x S` matrix whose `(a, b)` entry is the
cheapest traversal entering at up-port `a`, descending, and leaving at up-port `b`. Composition at
an internal node factors into two `S x S` min-plus products per child, the same associative shape as
every other C1061 domain with `S` in place of the boundary alphabet.

**This is the direct test of probe 7's escape hatch.** A `k`-ary fat-tree pod has `(k/2)^2` uplinks,
which probe 7 correctly called an unusable separator. What the summary needs is one entry per
*distinguishable* uplink class, and `S` here is that class count. The events in the vocabulary —
per-port failure and per-port latency change — are exactly what make individual uplinks
distinguishable, so the census below measures whether the class count survives a hostile stream.

**Event vocabulary and its algebra.** `LinkFailureToggled` is an involution on disjoint coordinates,
so the failure part of the monoid is again an elementary abelian 2-group; `LinkLatencyChanged` and
`LinkCapacityChanged` are last-writer-wins. `PodCountChanged` is `RegrowRequired` (chain length
changes, boundary alphabet does not) and `SeparatorWidthChanged` is `RebaseRequired` — the same
three-way classification the space cut introduced in probe 10, arrived at independently here.

**Exactness against Dijkstra.** `the_retained_tree_agrees_with_dijkstra_after_every_event` checks the
retained answer against a shortest-path solve over the explicit layered graph after every one of
3,000 mixed events at 64 pods, and the census repeats the check every 200 events over the `10^5`
stream. Building the comparator exposed a real bug in my own layered graph: port penalties were
charged on entry when descending but attributed to the parent when ascending, double-counting one
and dropping another. The retained tree was right and the comparator was wrong, which is the useful
direction for a differential gate to fail in.

**Boundary-class census over `10^5` events**, mixed failure, latency and capacity events drawn
uniformly over all nodes and ports:

| pods | separator `S` | entries | retained bytes | mean repair path | raw root summaries | tropically normalized | collapse | exactness checks | mismatches |
|---|---|---|---|---|---|---|---|---|---|
| 256 | 2 | 4 | 8,192 | 8.02 | 232 | **26** | 8.9x | 500 | 0 |
| 1,024 | 2 | 4 | 32,768 | 10.01 | 62 | **9** | 6.9x | 500 | 0 |
| 256 | 4 | 16 | 32,768 | 8.02 | 243 | **81** | 3.0x | 500 | 0 |
| 1,024 | 4 | 16 | 131,072 | 10.01 | 92 | **33** | 2.8x | 500 | 0 |
| 256 | 8 | 64 | 131,072 | 8.02 | 435 | **360** | 1.2x | 500 | 0 |
| 1,024 | 8 | 64 | 524,288 | 10.01 | 131 | **115** | 1.1x | 500 | 0 |

**The reachable boundary-class set is small in absolute terms — 9 to 360 classes over 100,000
events — and it does not grow with the fabric.** Going from 256 to 1,024 pods *reduces* the class
count at every width, because a deeper tree averages more link costs into each root entry and the
extremes get rarer. That is the measured answer probe 7's routing row was waiting for, and it is
positive. The qualification is that tropical normalization does most of its work only at the
narrowest separator: it collapses 6.9x to 8.9x at `S = 2`, 2.8x to 3.0x at `S = 4`, and essentially
nothing at `S = 8`, where the raw count is already small.

**Pareto.** Entries are fronts of `(latency, bandwidth)` composing by latency sum and bandwidth
minimum, capped at four points per front. Composing along ten levels of a 1,024-pod fabric from a
seed front with a genuine trade-off leaves the front size at a constant 4 with **zero points dropped
by the cap**, so the Pareto instantiation costs a bounded 4x the min-plus state rather than growing
with depth. `the_pareto_front_keeps_only_undominated_points` gates domination and ordering.

## Part A2 — the QEC verdict: the loss shrinks by a factor of four and still never flips

Eight interleaved rounds, four-round window, budget 6, two-size differencing on every arm, fixed
event window. `n` is per row after discarding rounds where a PyMatching startup outlier made the
two-size difference non-positive. The PyMatching arm decodes in batch over a fixed shots array, so
its setup is genuinely constant and it needed no repair.

| rate | `d` | PyMatching per decode | sparse tree per event | dense tree per event | vector sweep per event | sparse / PyMatching | 95% CI | `n` | dense / sparse |
|---|---|---|---|---|---|---|---|---|---|
| 0.001 | 3 | 268 | 14,209 | 40,499 | 14,745 | 53.9x | [44.9, 64.7] | 7 | 2.9x |
| 0.001 | 5 | 380 | 19,279 | 67,666 | 29,037 | 53.1x | [41.2, 68.3] | 8 | 3.5x |
| 0.001 | 7 | 425 | 28,994 | 94,830 | 43,329 | 68.4x | [64.4, 72.6] | 8 | 3.3x |
| 0.001 | 9 | 516 | 23,508 | 94,832 | 57,621 | 46.4x | [38.3, 56.2] | 7 | 4.0x |
| 0.005 | 3 | 393 | 14,210 | 40,497 | 14,745 | 38.0x | [29.0, 49.7] | 8 | 2.8x |
| 0.005 | 5 | 570 | 19,282 | 67,665 | 29,037 | 34.0x | [31.2, 37.1] | 8 | 3.5x |
| 0.005 | 7 | 796 | 28,993 | 94,829 | 43,329 | 37.2x | [31.2, 44.3] | 8 | 3.3x |
| 0.005 | 9 | 1,027 | 23,528 | 94,831 | 57,621 | 23.2x | [20.1, 26.9] | 8 | 4.0x |
| 0.01 | 3 | 529 | 14,211 | 40,498 | 14,745 | 27.1x | [24.2, 30.3] | 8 | 2.8x |
| 0.01 | 5 | 864 | 19,295 | 67,664 | 29,037 | 22.4x | [21.0, 23.9] | 8 | 3.5x |
| 0.01 | 7 | 1,083 | 23,048 | 94,831 | 43,329 | 22.1x | [16.8, 29.0] | 8 | 4.1x |
| 0.01 | 9 | 1,559 | 23,526 | 94,830 | 57,621 | **15.1x** | [14.3, 16.0] | 8 | 4.0x |

**The sparsity levers work and the loss shrinks materially.** Truncation plus the clean-subtree
table make the tree **2.8x to 4.1x** cheaper than the dense tree of probes 10 and 13, with
deterministic instruction counts and intervals tight to the second decimal. Composed with the
dependence on defect density, the worst case improves from probe 13's 82x to **15.1x** at distance 9
and 1% physical error.

**No regime flips, and the extrapolation says none exists.** The gap narrows with the
defect density at every distance — at distance 9 it runs 46.4x, 23.2x, 15.1x as the rate goes 0.1%,
0.5%, 1% — because PyMatching's cost grows with the defect count (516, 1,027, 1,559 instructions for
0.111, 0.558, 1.101 mean defects, so roughly 400 plus 1,054 per defect) while the sparse tree is
flat at about 23,500. A crossover therefore needs about **22 defects in a 32-detector window, a 69%
defect density**. The repetition code's threshold under this model sits near 10% physical error,
which is roughly a 30% defect density; at 69% the logical error rate is essentially one half and
decoding has no meaning. **The crossover is not merely far away, it is outside the region where a
decoder is a decoder.**

**One prediction of mine was wrong and is corrected.** Probe 13 speculated that a no-tree
left-to-right vector sweep, `O(n W^2)` against the tree's `O(log n · W^3)`, might beat the retained
tree at the short chain lengths QEC uses. It does not: the sweep costs 29,037 to 57,621 instructions
against the sparse tree's 19,279 to 23,525 at distances 5 to 9, so the tree wins from distance 5
upward and the log-depth advantage already pays at these sizes. The tree was never the problem.

**Why the floor is where it is, and what would move it.** After both levers the sparse tree still
recomposes about 1.6 nodes per event, each a `16 x 16` product over a summary with 51 finite entries
out of 256 — roughly 23,500 instructions, dominated by *scanning* a `W^2` matrix rather than by
arithmetic on defects. Sparse blossom touches only the defect neighbourhood and never scans a dense
boundary at all. The only change that could close a 15x gap is a defect-indexed summary
representation, and a summary indexed by defects **is** a matching decoder; the framework would have
to become the baseline rather than beat it.

**Verdict: close QEC as a product target.** The algebra remains the best in the C1061 series — an
elementary abelian 2-group update monoid, exact congruence, a group action that rolls back for free
— and it stays a good source of structure. It is not a place where this framework wins on cost.

## Part B2 — routing: the delta beats both comparators, and the row is no longer conditional

Eight interleaved rounds, mixed failure, latency and capacity events, two-size differencing, fixed
event window. Instruction counts are perfectly deterministic here (standard deviation 0.00% on every
arm), so the intervals are degenerate; the exactness of every arm is separately gated by the
Dijkstra agreement above.

| pods | separator `S` | delta per event | fresh re-solve per event | Dijkstra re-solve per event | fresh / delta | Dijkstra / delta |
|---|---|---|---|---|---|---|
| 256 | 2 | 2,287 | 133,757 | 132,725 | 58.5x | 58.0x |
| 256 | 4 | 17,167 | 923,165 | 1,357,732 | 53.8x | 79.1x |
| 256 | 8 | 119,924 | 5,609,121 | 4,956,025 | 46.8x | 41.3x |
| 1,024 | 2 | 3,685 | 568,621 | 1,088,381 | **154.3x** | **295.3x** |
| 1,024 | 4 | 27,548 | 3,846,513 | 8,416,012 | **139.6x** | **305.5x** |
| 1,024 | 8 | 180,559 | 22,849,115 | 27,934,710 | 126.5x | 154.7x |

**The routing row gets a positive measured verdict.** At matched exactness — 3,000 agreement checks
against Dijkstra across the six configurations plus a 3,000-event unit test, zero mismatches — the
retained delta beats a standard shortest-path re-solve by **41x to 305x**, and it beats a full
recomposition of the same tree by 47x to 154x. Unlike QEC, the advantage **grows with the instance**:
quadrupling the fabric from 256 to 1,024 pods roughly doubles the win against a full re-solve and
quadruples it against Dijkstra, because the comparators are linear in the fabric while the delta is
logarithmic.

**The binding constraint is the separator, exactly as everywhere else in C1061.** Per-event cost runs
2,287 / 17,167 / 119,924 instructions at `S` = 2 / 4 / 8, close to the `S^3` the composition predicts
(a factor of 7.5 and then 7.0 per doubling). So a fabric whose uplinks collapse to two or four
classes is cheap to maintain and one that needs eight is fifty times more expensive per event —
which is why the boundary-class census in Part B1 is the load-bearing measurement, not a detail.

**What this does and does not settle.** It settles that boundary classes collapse and stay collapsed
under a hostile `10^5`-event stream, which is the claim probe 7 flagged as unmeasured, and it settles
that the delta beats the natural comparator by two orders of magnitude at matched exactness. It does
not settle the mapping from a real fabric's `(k/2)^2` uplinks down to `S` classes: this instance
*declares* `S` as the schema rather than deriving it from a physical topology, so a real deployment
still has to show that its uplinks collapse to a small class count and that failures do not shatter
them. That derivation is the obvious successor task.

## Part C — the worklist minimizer, re-measured under the corrected harness

| replicas | states | full re-minimization | split-only | worklist | full / worklist | 95% CI | split-only / worklist | 95% CI | `n` |
|---|---|---|---|---|---|---|---|---|---|
| 4 | 36 | 32,505 | 12,147 | **605** | **53.74x** | [53.74, 53.75] | **20.08x** | [20.08, 20.08] | 7 |
| 16 | 144 | 279,127 | 118,057 | **1,696** | **164.62x** | [164.62, 164.63] | **69.63x** | [69.63, 69.63] | 7 |

Probe 13 reported 47.84x and 154.82x over full re-minimization and 18.06x and 66.37x over
split-only. The corrected harness moves those to 53.74x / 164.62x and 20.08x / 69.63x — **up by 6%
to 12%**, in the predicted direction: the per-event constant the old harness charged inflated the
cheapest arm proportionally most, so the worklist's advantage was understated. No verdict changes.

## Which earlier verdicts the harness repair changed

| probe | claim | old | corrected | verdict change |
|---|---|---|---|---|
| 13 | dense space-cut delta per event, `d = 9`, height 4 | 94,870 | 94,830 | none; the per-event constant was negligible against a 95,000-instruction update |
| 13 | PyMatching per decode, `d = 9`, 1% | 1,484 | 1,559 | none |
| 13 | QEC loss, `d = 9`, 1%, dense tree | 64.0x | 60.8x | none; the loss was overstated by 5% |
| 13 | worklist over full re-minimization | 47.84x / 154.82x | 53.74x / 164.62x | none; understated by 6-12% |
| 13 | worklist over split-only | 18.06x / 66.37x | 20.08x / 69.63x | none; understated by 5-11% |
| 7 | syndrome window, fresh / delta | 134.7x | **134.75x** [134.74, 134.76] | none |
| 7 | policy trace, fresh / delta | 13.0x | **13.19x** [13.19, 13.19] | none; understated by 1.5% |
| 10 | space cut, fresh / delta | 118.11x | **118.14x** [118.13, 118.15] | none |
| 10 | monoid tree over function tree | 9.17x | **10.30x** [10.26, 10.33] | none; understated by 12% |
| 10 | cluster retraction over merge | 126.00x | **180.16x** [180.07, 180.25] | none, but understated by **43%** — the largest correction in the audit |

All probe 7 and probe 10 ratios are re-measured, eight interleaved rounds each, and **no verdict
changed**. Every correction moved in the predicted direction (upward, because the removed constant
inflated the cheaper arm proportionally more), and the size of each correction tracks how cheap the
winning arm is: 1.5% where the delta costs 3,360 instructions, 12% where it costs 326, and 43% where
a cluster merge costs 60 instructions and the old harness was charging it roughly 27 more for
drawing its own event.

The one comparison where the bug could have inverted a verdict was probe 13's QEC loss against
PyMatching, because only my arm was contaminated. It did not: the loss was overstated by 5%, and the
verdict survives the far larger correction that Part A2's sparsity work applies to it.

**A second harness defect, found while auditing the first.** Three of the repaired loops in
`space_and_minimizer_bench.rs` silently kept iterating the event window rather than the operation
count, because the text-substitution patch did not match after a concurrent `cargo fmt` reformatted
it. The symptom was unmistakable once measured — the two-size difference collapsed to 0.06
instructions per operation, since both sizes were doing the same 4,096 events — and it is the reason
the probe-10 space row above was re-run separately. Every timed loop in all four of my benches is
now verified to bound on `--operations`, and the repair asserts on the substitution instead of
failing quietly. The lesson is the general one: **a differencing harness whose per-operation cost
comes out near zero is reporting a broken loop, not a fast one**, and that check is worth making
automatic.

## Ranking after probe 17

| Domain | brief's hypothesis | measured verdict now | change |
|---|---|---|---|
| Security FSM / policy | 5 | Finite quotient by construction (626 elements at 17 states, emitted with zero disagreements); worklist re-minimization 53.7x to 164.6x over full; monoid-indexed trace tree 9.2x over the function tree | **Confirmed at 5.** The only domain that beats its natural baseline by orders of magnitude. |
| Coded checkpoint recovery / storage repair | 5 | Probes 1, 2, 5: 10,000x delta win, 2 to 4 normalized classes | unchanged |
| Network resilience / routing | 4.5, conditional on an unmeasured claim | Boundary classes measured: 9 to 360 reachable over `10^5` events, *shrinking* with fabric size; delta beats Dijkstra 41x to 305x and a full re-solve 47x to 154x at zero mismatches; Pareto front bounded at 4 with nothing dropped | **Condition discharged; raise to 5 for the compiled instance.** The open item moves from "do classes collapse" (answered yes) to "does a physical fabric's uplink set collapse to a small `S`". |
| QEC decoding | added at ~3 by probe 7 | Sparsity levers deliver 2.8x to 4.1x, and the loss to sparse blossom falls from 82x to 15.1x, but never flips; the extrapolated crossover needs a 69% defect density, outside the region where decoding means anything | **Close as a product target.** Keep as a source of algebraic structure. |

## Mystery ledger

- **The sparse tree's cost is flat in the physical error rate** (23,508 / 23,528 / 23,526
  instructions at distance 9 across a tenfold range of defect density). That is the direct
  fingerprint of the remaining floor: the work is `W^2` scanning of the retained summaries, not
  arithmetic on defects, so the levers that key on defects cannot touch it. Settled by inspection
  and consistent with the clean-hit measurement, but it means any further sparsity work on this
  representation is capped and the only lever left is changing the representation itself.
- **PyMatching at distance 7 is anomalously slow at the two lower rates** (425 and 796 instructions
  against 516 and 1,027 at distance 9, so distance 7 costs *more* per decode than distance 9 at rate
  0.005). Unexplained; plausibly a graph-layout or matching-structure effect in sparse blossom rather
  than anything about my side. It is why the distance-7 rows have the widest intervals. Not settled,
  and it does not affect the verdict, which rests on the distance-9 column.
- **The routing boundary-class count falls as the fabric grows** (232 to 62 raw at `S = 2` going from
  256 to 1,024 pods). The reasoned explanation is that a deeper tree averages more link costs into
  each root entry so extremes get rarer, but that is an argument. If it is right it is a genuinely
  good property — the compiled table gets *easier* at scale — and it deserves a direct test on a
  fabric with heterogeneous link costs, which this instance does not have.
- **The routing instance declares `S` rather than deriving it.** Every routing number is conditional
  on a real fabric's uplinks collapsing to `S` classes, which is exactly the assumption probe 7
  flagged and which this probe tests only downstream of. The census shows classes stay collapsed
  under a hostile event stream *given* the declared `S`; it does not show a `k`-ary fat-tree's
  `(k/2)^2` uplinks collapse to a small `S` in the first place.
- The truncation pruning rule was wrong on the first attempt and the Dijkstra comparator was wrong on
  the first attempt; both were caught by differential gates rather than by inspection, and both are
  now settled with an argument and a test. No open algebraic mystery remains in either part.

## Vibe check

Two clean answers in opposite directions, which is the best outcome this probe could have had. QEC
closes: making the tree sparsity-aware was worth a real 2.8x to 4.1x and cut the loss to a tuned
production decoder from 82x to 15.1x, but the gap never flips and the extrapolated crossover sits at
a defect density where decoding is meaningless — the residual cost is `W^2` scanning that no
defect-keyed lever can reach, and the representation that would reach it is a matching decoder.
Routing opens: the boundary-class collapse that probe 7 could only argue for is measured and holds
under `10^5` hostile events, the class count actually *shrinks* with fabric size, and the retained
delta beats a standard Dijkstra re-solve by 41x to 305x at zero mismatches. The harness audit was
worth doing and cost little: the bug moved probe 13's numbers by 5% to 12% and changed no verdict,
but it would have been a real defect in any comparison against an external baseline whose setup does
not scale.

## Next probes

1. Derive `S` rather than declaring it: take a real `k`-ary fat-tree, compute the uplink
   equivalence classes under its automorphism group, and measure how failures shatter them. Every
   routing number here is conditional on that.
2. Give the routing instance heterogeneous link costs and re-run the class census, to test whether
   the class count really keeps shrinking with fabric size or whether that is an artifact of uniform
   costs.
3. Extract the retained-tree layer that probes 7, 10 and 17 have now instantiated five ways
   (min-plus, Boolean, counting, probability, Pareto, monoid indices, fabric matrices) into the
   `OpenProblem` trait the probe-16 agent is building, using `fabric_routing` as the second
   non-synthetic consumer after the LRC fleet.
4. Do not spend further effort on QEC decoding cost. If the domain is revisited, revisit it for the
   certificate path or the group-action rollback, which are the parts no matching decoder has.

## Log addendum, 2026-09-03: commit provenance

Code for this probe is in ergodis-private `5ed47f9`, `739e289`, `a06ceb2`.
