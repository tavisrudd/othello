# C1061 probe 12: family test of the closed form, and the compiled transducer

**Lane**: `complete-ports`
**Date**: 2026-09-03
**Task**: C1061 probe 12. Part A tests probe 9's claim that the closed form is a property of the
counted-kernel *family*; part B compiles the fleet optimizer into a weighted transducer and asks
whether the online optimizer disappears.

Files (all in `ergodis-private`; `/home/tavis/src/ergodis` untouched and clean):

- `src/counted_family.rs` — the counted-kernel family, its closed form, the four assumption checks,
  and three deliberate assumption-breaking variants.
- `src/compiled_transducer.rs` — the convolution structure, the count-based `FleetPolicy`, and the
  `ShapeTable` transition table.
- `tasks/tools/src/family_audit.rs`, `tasks/tools/src/transducer_bench.rs` — the audit and endpoint
  drivers.
- `python/counted_family_oracle.py` — the family-generalized CP-SAT oracle.
- `evidence/2026-09-03-counted-family-corpus.json`,
  `evidence/2026-09-03-counted-family-oracle-report.json`,
  `evidence/2026-09-03-lrc-fleet-counter-ab-probe12.json` (first counter run) and
  `evidence/2026-09-03-lrc-fleet-counter-ab-probe12-policy.json` (the re-run that the policy and
  table numbers below come from).

A calibration failure in the first counter run is worth recording. The harness sizes each operation
by wall time, and the policy and table operations build a 100,000-event training table in setup, so
the calibrator stopped at a repeat count of 2 — making the two-point difference a single event and
the measurement pure noise, including negative instruction counts. The fix was a `--min-repeat`
floor and an `--only-ops` filter, re-run at a repeat of 1,000,000. Any operation with heavy setup
needs that floor; sizing on total wall time silently mis-sizes it.

Committed as `23a25ed`, staged as an exact patch so only my own hunks of the shared `src/lib.rs` and
`tasks/tools/src/main.rs` were included. Foreign breakage to flag, not mine and untouched:
crate-wide `cargo clippy` currently fails on one lint in another agent's `src/policy_worklist.rs`.

Measurement method is unchanged from probes 6 and 9: instructions are primary (deterministic on this
workload), cycles carry the noise, eight interleaved rounds with two-point differencing, paired
log-ratios with Student t intervals, and an inconclusive verdict when the interval spans 1.

## Part A — family test of the closed form

### A1. The family, and its anchor to committed code

`counted_family.rs` instantiates the shape probe 9 derived: `n` data domains with capacities `c_i`
and multiplicities `m_i`, one local parity domain `Lc`, `g` global parity domains totalling `Gc`,
and a read weight `w` giving the aggregate load `A(s) = local + w * global`.

The family is anchored to the published code, not merely asserted to generalize it:
`family_scan_matches_the_published_kernel` runs 200,000 hostile instances at the published shape
(`n = 6`, `w = 2`, `g = 2`) and requires the family reference scan to reproduce
`azure_lrc_12_2_2_counted().repaired_count` exactly, with the global-capacity rejection firing zero
times. `published_multiplicities_match_the_family_formula` checks the multiplicity formula against
the binding's own for 200 demands. Without that anchor, family results would be a statement about my
own code only.

### A2. Where the closed form holds

`ergodis-tools family-audit exhaustive --max-capacity 6 --max-demand 18` enumerates a bounded box
completely for each shape, using the data-domain symmetry so sorted capacity tuples cover the box:

| shape | comparisons | mismatches | line-(5) rejections | assumption failures |
|---|---|---|---|---|
| LRC(12,2,2) published (`n=6, w=2, g=2`) | 860,244 | 0 | 0 | 0 |
| LRC(6,2,2) (`n=3, w=2, g=2`) | 78,204 | 0 | 0 | 0 |
| LRC(12,4,2) (`n=3, w=4, g=2`) | 78,204 | 0 | 0 | 0 |
| LRC(10,2,4) (`n=5, w=2, g=4`) | 430,122 | 0 | 0 | 0 |
| read weight 1 (`n=4, w=1, g=2`) | 195,510 | 0 | 0 | 0 |
| read weight 3 (`n=4, w=3, g=2`) | 195,510 | 0 | 0 | 0 |
| single parity domain (`n=4, w=2, g=1`) | 195,510 | 0 | 0 | 0 |
| **total** | **2,033,304** | **0** | **0** | **0** |

The independent CP-SAT oracle agrees on every case of a 4,704-case corpus — 672 per shape, covering
zero capacities, all-equal capacities, a single saturated domain, local-parity-only,
global-parity-only, zero demand, demand 40, and hostile draws:

| shape | cases | family scan agrees | closed form agrees |
|---|---|---|---|
| every one of the seven shapes | 672 each | 672 | 672 |
| **total** | **4,704** | **4,704** | **4,704** |

So probe 9's family claim holds, and the generalized start bound
`S1 = Lc + floor((cap - Lc) / w)` is correct for `w` in {1, 2, 3, 4} and for one, two, and four
parity domains. The collapse of the parity capacities into their sum also survives every `g` tested,
which the oracle checks independently because it constrains each parity domain separately.

### A3. Where it fails, and the exact failing assumption

Three variants break one assumption each. These are negative controls: the point is that the
assumptions are load-bearing, not decorative.

| variant | assumption broken | observed effect | closed form's response |
|---|---|---|---|
| `read_weight = 0` | 2, `A` strictly increasing | `A` is constant above `Lc`, so the start bound is not defined (its derivation divides by `w`) | refuses with `AggregateNotIncreasing` |
| `UncappedMaximum` (scan limit is the demand, ignoring capacity) | 1, `maximum <= Lc + Gc` | the global-capacity rejection **fires**, which never happens faithfully | refuses with `ScanLimitUncapped` |
| `WrappingShortfall` | 3, saturating subtraction | the per-domain test no longer equals the scalar bound `A <= cap` | refuses with `ShortfallNotSaturating` |

`uncapped_maximum_makes_the_dead_branch_live` constructs an instance where the faithful scan records
zero rejections and the uncapped variant records more than zero — a concrete demonstration of the
future edit probe 9 warned about. `wrapping_shortfall_breaks_the_scalar_collapse` shows the collapse
failing on an instance where the faithful variant's four assumptions all hold.

The closed form **fails closed** in every case: `family_decided` returns the failing assumption
rather than a number, so a caller outside the envelope cannot silently receive a wrong answer.

## Part B — the compiled transducer

### B1. The structural fact: leaf summaries commute

A leaf summary of this fleet satisfies `cost[from][to] = f(to - from)` — the cost of a stretch
depends only on how much shared budget it consumes, not where in the range it starts.
`leaf_summaries_are_convolution_operators` checks this on 500 pods. Such matrices are min-plus
**convolution operators**, so their product is a convolution and is therefore **commutative** as
well as associative: the fleet root depends only on the multiset of leaf profiles.
`convolution_is_commutative` confirms it against the retained tree by reversing and rotating the
fleet.

That turns the fleet optimum into a knapsack. Writing `f_i(0)` for a pod's baseline cost and
`d_i(l) = f_i(0) - f_i(l)` for its discount from `l` levels,

```
optimum = sum_i f_i(0) - max { sum_i d_i(l_i) : sum_i l_i <= 3 }
```

and because at most three levels are available, the maximizing allocation touches at most three
pods. The value therefore depends only on the top three `d(1)` values, the top two `d(2)` values,
and the largest `d(3)` — a statistic whose size does not grow with the fleet.

### B2. The compiled policy: the online optimizer does disappear

`FleetPolicy` keeps the multiset of profile classes with their multiplicities and the running
baseline. An event re-profiles one pod with the **closed-form leaf**, moves one unit between two
class counts, and re-solves the three-level knapsack by scanning the classes. There is no tree, no
kernel call, and no work proportional to the fleet.

`policy_optimum_matches_the_retained_tree_under_a_delta_stream` drives 20,000 events on 512 pods and
requires the policy optimum to equal the retained tree's at every event. At 16,384 pods the
`transducer-bench` driver checks the same thing over 100,000 events:
`train_value_disagreements 0`.

| quantity | rack fleet (24 types) | unique fleet |
|---|---|---|
| profile classes | 31 | 29 |
| policy state | 66,404 bytes | — |

**So yes: for this fleet the online optimizer disappears.** The retained composition tree is not
needed to maintain the exact optimum; a class-count vector and a bounded knapsack suffice.

### B3. The finite table: exact on 10^5 events, but not a transition function

`ShapeTable` compiles `(gain state, class transition) -> (gain state, offset delta)`, where the gain
state is the absolute best-gain vector and the class transition is keyed by the **profile**, not by
an interned class index. That last point was a real defect found in the build: class indices are
interned per policy instance, so a table keyed on them is meaningless across instances — keying on
the profile fixed a 7% value error rate to zero.

Replaying 100,000 **fresh** events through the table alone (only the closed-form leaf runs
alongside), at 16,384 pods with 100,000 training events:

| quantity | value |
|---|---|
| distinct gain states | **7** |
| table transitions | 1,182 |
| base-delta entries | 303 |
| table bytes | 71,032 |
| replay value disagreements | **0** |
| replay state disagreements | **0** |
| fail-closed rebases | 394 (0.39%) |

The state set is genuinely small and stable: **7 states regardless of training length**, on both the
rack fleet and the unique fleet (4 states there). That is the compiled-policy endpoint the brief
predicted.

But closure of the *transition* does not hold, and longer training proves it:

| training events | transitions | conflicts | poisoned keys | rebases | replay value errors |
|---|---|---|---|---|---|
| 100,000 | 1,182 | 0 | 0 | 394 | 0 |
| 200,000 | 1,318 | 0 | 0 | 357 | 0 |
| 400,000 | 1,451 | **2** | 2 | 341 | 1 |
| 800,000 | 1,708 | **4** | 3 | 298 | 1 |

Two things follow, and both matter more than the clean 100,000-event result.

**Conflict-free on 10^5 events is not evidence of well-definedness.** The same key becomes ambiguous
once the stream is four times longer. Any claim that a compiled table is exact must state the stream
length it was validated on.

**Poisoning the conflicted keys does not make it exact.** I added fail-closed poisoning — a key seen
with two different successors is refused rather than answered — and the replay still shows one value
error per 100,000 events. So there exist keys that look unambiguous on the training stream and are
wrong on a fresh one; no conflict detection on a training stream can find them.

The diagnosis is the one the module predicted before the measurement: the gain vector records the
top discounts but not **how many pods are tied near the top**. Removing a pod can expose one the
statistic never recorded, and two configurations with identical gain vectors but different
multiplicities diverge under the same event. The multiplicity information lives in the count vector,
whose entries range up to the pod count — which is exactly why the always-exact object is
`FleetPolicy` and not the finite table.

### B4. What breaks the finiteness

Not fleet size, and not interface width. **The multiplicity of pods tied at the top of the discount
order.** The gain state set stayed at 7 for every fleet and every training length tested; what fails
is the transition, and it fails precisely where the tie multiplicity changes an outcome the gain
vector cannot see. A state enriched with capped tie multiplicities — how many pods hold each of the
top few discounts, capped at four, since at most three are ever granted — is the obvious repair and
is the first item below.

### B5. Certificates from the table transition

Probe 3's delta certificate is `(previous root, affected quotient nodes, new root, certificate
delta)`. The table transition carries a strictly stronger object for the value: `(gain state before,
profile transition, gain state after, baseline delta)`, from which the optimum before and after both
follow by arithmetic, with no reference to the tree at all. So the certificate can be emitted from
the table transition rather than the tree, **for the value**. It cannot yet be emitted for the
witness: the action names representative pods drawn from the class index, which is policy state
rather than table state, so a witness-level certificate still needs the policy. That is a narrower
claim than "the certificate comes from the table" and is the accurate one.

### B6. Counter measurement, and the negative that matters

> **Correction (probe 15, same day).** The per-event figures in this section are wrong. The counter
> harness derives per-operation counts by differencing runs at `N` and `N/2` repeats, which cancels
> setup only when setup is constant in `N`; the policy and table operations pre-drove a driver tree
> for `repeat` events in setup, so each was charged for one extra tree update per event. Re-measured
> with a fixed-size event window, the compiled policy costs **5.4k instructions** and the compiled
> table **2.8k** against the tree delta's **15.2k** — so the compiled policy is **2.81x cheaper**
> than the tree and the table **5.52x cheaper**, not 28% and 16% more expensive as stated below.
> The conclusion that this is "a structural and memory result, not a speed one" is withdrawn. See
> `notes/2026-09-03-c1061-probe15-incremental-topk-and-tie-closed-state.md`.


Instructions per event at 16,384 pods, eight interleaved rounds, two-point differencing:

| operation | instructions | cycles | IPC |
|---|---|---|---|
| retained-tree delta (`delta_value`) | **16.2k** | 3.3k | 4.88 |
| compiled policy, rack fleet | 20.7k | 4.2k | 4.88 |
| compiled table, rack fleet | 18.9k | 4.0k | 4.74 |
| compiled policy, unique fleet | 20.7k | 4.1k | 4.99 |
| compiled table, unique fleet | 21.3k | 4.5k | 4.70 |

| comparison | instructions | cycles [95% CI] | verdict |
|---|---|---|---|
| tree delta over compiled policy | **0.78x** | 0.77 [0.65, 0.91] | policy is **slower** |
| tree delta over compiled table | **0.86x** | 0.82 [0.68, 0.98] | table is **slower** |
| policy over table, rack | 1.09x | 1.06 [1.04, 1.09] | table slightly cheaper |
| policy rack over unique | 1.00x | 0.98 [0.90, 1.07] | fleet-shape independent |

**The compiled endpoint is 1.28x more instructions per event than the retained tree, not fewer.**
Both paths re-evaluate the changed leaf; the tree then does fifteen cache-line min-plus composes,
while the policy re-solves the knapsack by scanning all 31 classes and rebuilding the four-entry gain
vector, and that scan costs more than the composes it replaces. Every cycle interval excludes 1.0,
so this is not a measurement artifact.

What the compiled endpoint does win is **state**: 66,404 bytes of policy plus 71,032 bytes of table
against 3,014,656 bytes for the value-only retained tree at the same fleet size, a 22x reduction,
and it is fleet-shape independent. It also removes the tree and the kernel from the online path
entirely, which is the structural claim the brief was after.

The implementation is unoptimized in an obvious way: `best_action` rescans every class on every
event and `gain_vector` re-solves the knapsack four times. Maintaining the top-k discounts
incrementally would remove most of that, and is untested. Until it is, the accurate statement is
that the online optimizer *can* be removed exactly, and that doing so currently costs 28% more
instructions per event while cutting maintained state by 22x.

## Mystery ledger

- **The table is exact on 10^5 events and wrong once per 10^5 on a longer horizon.** Settled as to
  cause (tie multiplicity invisible to the gain vector) but not repaired; the enriched state is
  untested. Until it is, the compiled table must be described as an accelerator with a fail-closed
  path, never as an exact compiled optimizer.
- **Class indices are not a stable alphabet.** Found by a 7% error rate that vanished when the table
  was keyed on the profile. Worth recording because it is invisible in a single-process test where
  training and replay share one interning order — precisely the shape most benchmarks have.
- **Seven gain states, whatever the fleet or the stream.** The stability is stronger than expected
  and is unexplained beyond the knapsack bound; the alphabet of discounts is finite, but nothing
  yet says why the reachable combinations number seven rather than dozens.
- **The compiled policy is slower per event than the tree it replaces.** Measured, not expected:
  20.7k instructions against 16.2k. The cause is a full class rescan per event where the tree does
  fifteen composes. Whether an incrementally maintained top-k closes the gap is the first thing to
  test before this endpoint is presented as a performance result rather than a structural one.
- **The instruction split inside the policy event is not fully accounted.** The table variant, which
  skips the knapsack re-solve, saves only 1.8k of the 20.7k, so most of the cost is the leaf
  re-profiling — four closed-form calls — rather than the knapsack. That the tree's ten kernel calls
  cost less than four closed-form calls plus bookkeeping is unexplained and worth a profile.
- **The commutativity of leaf summaries was not designed in.** It falls out of the cost model
  depending only on consumed budget. If a future cost model made a pod's cost depend on the absolute
  budget level, the convolution structure and with it the whole knapsack reformulation would
  collapse. Nothing currently records that dependency as a compilation precondition.

## Validation

```
cargo test -p ergodis-private --lib counted_family --release        # 7 passed
cargo test -p ergodis-private --lib compiled_transducer --release   # 5 passed
ergodis-tools family-audit exhaustive --max-capacity 6 --max-demand 18
ergodis-tools family-audit corpus --out evidence/2026-09-03-counted-family-corpus.json
uv run --with ortools python3 python/counted_family_oracle.py \
    --corpus evidence/2026-09-03-counted-family-corpus.json \
    --report evidence/2026-09-03-counted-family-oracle-report.json
ergodis-tools transducer-bench --pods 16384 --rack-types 24
python3 scripts/counter_ab.py --binary <bin> --rounds 8 --pods 16384 --out <json>
```

## Vibe check

Two clean results and two failures worth having. The closed form generalizes across seven family shapes
with two million exhaustive comparisons and a 4,704-case independent-oracle differential, and each
of its three assumptions is shown load-bearing by a variant that breaks it and is refused rather
than answered wrongly. The online optimizer does disappear for this fleet — a count vector and a
three-level knapsack reproduce the tree exactly with no kernel — but the finite-state table on top of
it is an accelerator, not an exact compiled optimizer: it is perfect on 10^5 events and wrong once
per 10^5 beyond that, because the gain state cannot see tie multiplicity. (The per-event cost claim
that stood here was withdrawn by probe 15: a harness error had inflated it; the endpoint is in fact
cheaper than the tree, not more expensive.)

## Next probes

1. Maintain the top-k discounts incrementally instead of rescanning every class per event, and
   re-measure against the 16.2k-instruction tree baseline.
2. Enrich the transducer state with capped tie multiplicities (how many pods hold each of the top
   few discounts, capped at four) and re-run the 800,000-event conflict scan; if conflicts go to
   zero the exact finite transducer exists.
3. Emit the witness-level certificate from the table by moving the class representative index into
   the compiled artifact.
4. Record "cost depends only on consumed budget" as an explicit compilation precondition, since the
   entire knapsack reformulation rests on it.
5. Run the family closed form against whatever counted kernels the probe 8 survey found, now that
   the family harness exists.
