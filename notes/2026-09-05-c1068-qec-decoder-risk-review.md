# Tiger-blossom decoder risk review: exactness, certificates, and benchmark boundaries

**Lane**: `complete-ports`
**Date**: 2026-09-05
**Task**: C1068 (audit pass over the C1061 probe chain, C1063, C1064, C1065, C1066, C1067)
**Baseline audited**: `ergodis-private` at `256959b` (committed HEAD). The uncommitted C1068
working-tree edits to `tiger_blossom_sparse.rs` and `tiger_blossom_graph.rs` were read only to
separate them from the baseline; findings against them are marked WORKING TREE and are advisory.

## Headline

The load-bearing exactness story — "a sparse blossom matcher's answer is certified by LP duality
before use, so exactness does not depend on the matcher being correct" — is **not what the code
implements**. `SparseMatcher::certify` checks a dual solution and checks that the dual objective
equals the *claimed* primal cost, but it never checks that the claimed cost comes from a feasible
primal object. It does not verify that the pairing is an involution, and it does not verify the
odd-cardinality condition that makes each blossom's dual coefficient a valid inequality — even
though it computes the per-region defect counts needed for exactly that check and then discards
them. A matcher bug that emits an inconsistent pairing produces an under-priced `cost`, and the
certificate's only remaining test is `dual objective == 2 * cost`, which a slack dual can satisfy.
The duality argument is therefore a *self-consistency* check between the matcher's dual state and
the matcher's own price, not an independent proof of optimality, and the published wording
overstates it.

Ranking below is by "what would make a published number or an exactness claim wrong".

---

## 1. CONFIRMED DEFECT — the certificate never checks primal feasibility

**Where**: `src/tiger_blossom_sparse.rs:1477` (`certify`), `src/tiger_blossom_sparse.rs:1367`
(`resolve_pairing`), `src/tiger_blossom.rs:1153-1189` (the pricing loop that produces `cost`).

A minimum-weight-perfect-matching optimality certificate needs three things: a feasible primal, a
feasible dual, and equality of the two objectives. Only the second and third are checked.

`resolve_pairing` writes each match symmetrically (`pairing[left] = right; pairing[right] = left`,
`tiger_blossom_sparse.rs:1402-1403` and again at `1421-1422`), then sweeps for any defect still
`NONE` and declines if it finds one (`1424-1429`). That sweep catches an *unmatched* defect. It does
not catch a *doubly matched* one: if two different outermost regions descend to the same defect `d`,
the second assignment silently overwrites `pairing[d]`, leaving `pairing[p] == d` for the orphaned
first partner `p` while `pairing[d] != p`. Every entry is non-`NONE`, so the sweep passes.

The caller then prices that array in `tiger_blossom.rs:1157-1172`, and it prices a pair only when
`(partner as usize) > index`. Under a broken involution the orphaned partner is either priced
against the wrong defect or not priced at all, so `cost` can be *below* the true optimum. The
certificate's final gate is `objective != 2 * primal as i64 { return false }`
(`tiger_blossom_sparse.rs:1502-1504`). A dual objective is only guaranteed `<= OPT`; it is not
required to be tight. So a run whose dual happens to be slack by exactly the amount the mispricing
removed certifies, and the wrong correction is committed with `overflowed == false` and no census
flag.

Neither `resolve_pairing` nor `certify` contains a `pairing[pairing[i]] == i` check; grepping the
whole file for a mate-symmetry assertion returns nothing at HEAD.

**Cost to close**: one `O(count)` loop over `pairing` in `certify`, before the objective test. It is
the cheapest part of the certificate and it is the part that is missing.

**Severity**: this does not mean any published number is wrong today — I could not construct a
concrete input that produces a doubly-descended defect, and `descend`'s bookkeeping may well make it
unreachable. It means the *claim* is wrong, in the exact words it is published in:
`notes/2026-09-05-c1067-tiger-matcher-performance-contract-audit.md:50-52` ("Exactness does not
depend on the matcher being correct") and the doc comment it audits at
`src/tiger_blossom.rs:88-91` ("Every answer is certified by LP duality before use, so a matcher
defect costs a flagged shot, never a wrong answer"). Both assert a property the code does not have.

## 2. CONFIRMED DEFECT — the blossom odd-cardinality condition is computed and then thrown away

**Where**: `src/tiger_blossom_sparse.rs:1481-1492` (the `under` forward pass), and the objective loop
immediately after at `1496-1504`.

`certify` opens by computing, for every region, how many defects sit under it: singletons get 1,
blossoms accumulate their children's counts in one forward pass. The array is `self.under`. Grepping
HEAD for `under[` returns exactly three lines — 1481, 1490, 1492 — all inside that computation. The
array is never read again, in `certify` or anywhere else.

The value it computes is the one thing that makes the odd-cut dual valid. The dual the comment
describes ("every region is an odd set of defects whose cut must carry a matched edge, so each
region contributes its radius exactly once") is only a valid relaxation for **odd** sets: an
even-cardinality set can be matched entirely within itself, so `x(delta(S)) >= 1` is not a valid
inequality for it, and a positive dual on an even set lets the dual objective exceed the true
optimum. Once the dual objective can exceed `OPT`, `objective == 2 * primal` no longer implies
`primal == OPT`, and a suboptimal matching certifies.

**Mitigating structural fact (CHECKED)**: at HEAD, blossoms are odd by construction.
`contract` refuses an even cycle explicitly — `if length % 2 == 0 || length > self.cycle_region.len()
{ self.reason_odd_cycle += 1; return SparseOutcome::NeedsBlossom; }`, around
`src/tiger_blossom_sparse.rs:2226` in the working tree (same guard at HEAD). By induction over
children, every allocated blossom therefore has odd defect cardinality. So this is a defense-in-depth
hole rather than a live miscompute — but it is the *second* place where the certificate leans on the
matcher being correct, which is precisely what the published story says it does not do.

**Also checked and clean here**: the sign condition is correctly restricted. `if region >= count &&
radius < 0 { return false }` (`1498-1500`) enforces non-negativity on blossoms only and leaves
singleton duals free in sign, which is right for the degree-equality formulation. The per-defect
boundary constraint *is* checked: `if own > 2 * spec.boundary_distance[node] as i64 { return false }`
(`1516-1518`), where `own` is the full chain sum including the defect's own radius, which is the
correct left-hand side for a boundary edge. The pair constraint is checked for all `count*(count-1)/2`
pairs in `pairs_within`, with the crossing dual computed as `left_dual + right_dual - 2*shared` —
subtracting the regions containing both defects twice, which is the correct "separating regions only"
sum. Doubled units are handled consistently (`2 * bound`, `2 * primal`).

## 3. CONFIRMED DEFECT — the PyMatching arm's per-decode divisor does not match the decodes it performed

**Where**: `scripts/tiger_blossom_ab.py:36-37` (`PY_SMALL = 81_920`, `PY_LARGE = 819_200`),
`scripts/tiger_blossom_ab.py:109` (the differencing divisor),
`scripts/tiger_blossom_pymatching_baseline.py:111-112` (`window = len(shots)`,
`batches = operations // window`).

The PyMatching arm decodes in whole batches over the emitted shot file. That file is emitted with
`--operations 20000` (`tiger_blossom_ab.py:172` in `external`, `:373` in `usage`), so its window is
20,000 shots. `operations // window` therefore truncates:

| requested | window | batches | decodes actually performed |
|-----------|--------|---------|----------------------------|
| 81,920    | 20,000 | 4       | 80,000                     |
| 819,200   | 20,000 | 40      | 800,000                    |

The work difference between the two sizes is 720,000 decodes. `per_operation` divides the counter
difference by `large - small` = 737,280. PyMatching's published per-decode cost is therefore
`720000/737280 = 0.9766` of its true value — it is credited as **2.34 per cent cheaper than it is**,
on every cell of every PyMatching comparison ever run through `external` or `usage`.

The Tiger arm has no such error: `SHOT_WINDOW = 4_096` (`tasks/tools/src/tiger_blossom_bench.rs:27`)
divides both 16,384 and 81,920 exactly, so its performed count equals its requested count and its
divisor is right.

**Direction**: this makes the published `tiger / pymatching` ratios about **2.4 per cent worse for
Tiger than the truth**. It is a real arithmetic defect in every headline number, but it is
conservative — it does not flatter Tiger. The repair is to make `PY_SMALL`/`PY_LARGE` multiples of
the emitted window, or to divide by `batches * window` reported by the script (which the script
already prints as `operations_performed` and which `per_operation` ignores).

## 4. PLAUSIBLE RISK — the two arms replay working sets that differ by 5x, and this one does flatter Tiger

**Where**: `tasks/tools/src/tiger_blossom_bench.rs:27` and `:240-249` (Tiger draws
`SHOT_WINDOW = 4096` shots once, in `setup`, then replays them),
`scripts/tiger_blossom_pymatching_baseline.py:111` (PyMatching replays all 20,000 emitted shots),
`scripts/tiger_blossom_ab.py:362-363` (the `usage` docstring's claim).

**CHECKED-CLEAN first, because the brief asked**: the shot generator is *not* inside the Tiger arm's
measured loop. `setup` fills the shot buffer before `Instant::now()`
(`tiger_blossom_bench.rs:241-249`, timer at `:275`), and the measured loop is whole batches over
that fixed buffer. Both arms are replaying pre-generated syndromes; neither pays for `draw_events`
inside the difference. The hypothesis in the brief does not hold.

**What does not hold is the symmetry the harness claims.** `usage`'s docstring says "Shot files are
emitted once per cell and reused across rounds, so both arms decode the same syndromes on the same
graph." The Tiger arm never reads that file. It re-derives its own 4,096 shots from
`ShotGenerator::new(rate, seed ^ 0x9999)`, the same seed the emitter used, so Tiger decodes the
*first 4,096* of the emitted 20,000 and repeats them; PyMatching cycles all 20,000. The two arms
therefore replay working sets that differ by 4.9x in shot count, and by considerably more in bytes:
Tiger's syndromes are packed `u64` bitwords (`4096 * words * 8` bytes, tens to hundreds of KiB,
comfortably L2-resident), while PyMatching's are a dense `np.uint8` array of `20000 * detectors`
bytes — 14.4 MB at surface `d = 11` with 720 detectors under the circuit-level model, which is an
L3-or-memory working set.

This asymmetry runs **in Tiger's favour**, and it is not a property of the two decoders — it is a
choice of the harness. Sizing PyMatching's window at 4,096 would cut its resident set fivefold.

**How large**: I could not bound it without running, which the brief forbids. The evidence carries
the signature, though: at `d = 25`, `p = 0.001` the instruction ratio is 0.091 while the
L1-dcache-load-miss ratio is 0.205 and the cache-miss ratio is 0.014
(`benchmarks/tiger-blossom/2026-09-04-c1063-6b6999a-vs-pymatching-eighteen-cells.log`). Tiger's
absolute cache-misses per decode round to 0.0 with a 94 per cent round-to-round spread; PyMatching's
are 0.4. A 20-to-100x last-level-cache-miss ratio on a workload whose instruction ratio is 11x is
consistent with a resident-set difference doing part of the work. The instruction-count ratios,
which are the ones the reports lead with, are insensitive to this and remain sound.

## 5. CONFIRMED DEFECT — the A/B harness calls level 4 "production" after level 5 became production

**Where**: `scripts/tiger_blossom_ab.py:272` ("baselines on the production level 4"), `:276` and
`:321` (both print `baseline: level 4 specialized (production)`), against
`src/tiger_blossom.rs:97-104`, where `LEVEL_ROUTED = 5` is documented as "The production arm" and
`LEVEL_SPARSE = 4` is not.

C1063 shipped `LEVEL_ROUTED` as the default. The `stack` and `ladder` modes still baseline every
ratio on level 4 and print it as "production". Any ratio read out of a `stack` or `ladder` log — and
the emitted header line is what a cold reader trusts — is *arm / level 4*, not *arm / production*.

The gap between the two arms is not small. In
`benchmarks/tiger-blossom/2026-09-04-c1063-6b6999a-vs-pymatching-real-usage.log`, surface `d = 11`
at `p = 0.0005`: level 4 costs 1,785.2 instructions per decode, level 5 costs 904.2 — level 4 is
**1.97x the real production arm** in that cell. A ladder ratio quoted as "against production" there
is understating the arm it is compared to by nearly a factor of two.

`external` and `usage` are clean here: both print `level4`/`level5` per row
(`tiger_blossom_ab.py:181`, `:404`) and measure both arms against the same PyMatching run, so a
reader can tell them apart. The defect is confined to the two internal-ladder headers, and to any
report sentence that repeats "production" from them.

## 6. CONFIRMED DEFECT — the C1064 evidence set is absent from the manifest that C1067 declared complete

**Where**: `benchmarks/tiger-blossom/SHA256SUMS` (58 entries; all 58 files exist and the paths now
resolve), against the 73 evidence files in that directory.
`notes/2026-09-05-c1067-tiger-matcher-performance-contract-audit.md:134-137`.

C1067's "Also repaired" section found that eleven manifest entries carried a repository-root path
prefix, normalized them, and concluded "all fifty-eight now check from the evidence directory". That
is true and it is the wrong test: it verified the manifest's *internal* consistency, not its
*coverage*. Fifteen evidence files in the same directory have no hash at all:

- all ten C1064 files — `2026-09-04-c1064-dem-manifest.txt`,
  `-fast-path-census-both-models.txt`, `-observable-component-split.log`,
  `-weighted-arm-profile.log`, `-weighted-latency-operating.txt`,
  `-weighted-pymatching-exactness.txt`, `-weighted-routed-ladder-ab.log`,
  `-weighted-vs-pymatching-operating.log`, `-weight-scale-cost-ab.log`, `-weight-scale-knee.txt`;
- three probe-28b files — `2026-09-04-probe28b-binaries-ab.log`, `-6750d5e-binaries-ab.log`,
  `-dfd4ee0-binaries-ab.log`;
- two C1065 files — `2026-09-05-c1065-phenomenological-level4-ab.log`,
  `2026-09-05-c1065-weight-scale-retest.txt`.

Every load-bearing number in the whole C1064 weighted circuit-level task — the PyMatching operating
grid, the weighted routed ladder, the exactness cross-check, the weight-scale knee, and the
fast-path census — cites a file (`2026-09-04-c1064-weighted-circuit-level-dem.md:81, 141, 173, 221,
234, 262, 291, 294, 314`) that carries no hash. Under
`notes/research-reproducibility-conventions.md` that is the compact-certificate half of the bundle
missing for an entire task's results.

**This is where C1067 looked and where it did not.** It looked at: allocation in the decode loop,
per-node instrumentation in the shipped build, run-constant dispatch, bounded stacks, workspace
size, manifest path hygiene, and a dead `#[test]` attribute. It did not look at: manifest coverage,
the certificate's own completeness (findings 1 and 2), the discarded schedule result (finding 7),
or any part of the measurement harness.

## 7. CONFIRMED DEFECT — one schedule failure is silently discarded instead of declining

**Where**: `src/tiger_blossom_sparse.rs:2852`, inside `dissolve`:

```rust
let _ = self.touch_region(spec, index);
```

`touch_region` is `#[must_use]`-shaped in intent: it returns `false` when a required queue entry
could not be armed — a late candidate, a push past the bucket horizon, or an exhausted entry pool.
Every other call site in the file treats that as fatal to the solve, incrementing
`reason_schedule` and returning `SparseOutcome::Exhausted`. This is the only site in the file that
discards it; grepping HEAD for `let _ = self.touch` returns exactly this one line.

The consequence is a queue entry that should exist and does not, which is a *missed* event: a region
keeps growing past a constraint it should have stopped at, or an augmentation that should have been
found is not. It does not corrupt silently — a missed event leaves either an infeasible dual (caught
by `certify`'s boundary or pair constraint) or a slack dual against a suboptimal primal (caught by
`objective != 2 * primal`) — so the shot fails closed to `bounded_fallback` with `overflowed` set.
But it does so **uncounted**: `reason_schedule` never increments, so the decline-reason census
misattributes it, and the census is the only instrument anyone has for how often the bounded path
runs.

## 8. CHECKED, WITH A SCOPE CORRECTION — the certified path is a minority of decodes

**Where**: `src/tiger_blossom.rs:1012-1043` (`solve_member_block`),
`benchmarks/tiger-blossom/2026-09-04-c1064-fast-path-census-both-models.txt`.

The claim "every block the sparse matcher answers is certified before use" is true as written and
is *narrower than it reads*. Only blocks larger than `min(dp_cutoff, DP_CAPACITY)` reach the sparse
matcher. Everything else — the empty, singleton, pair and four-defect closed forms, and the subset
dynamic program up to eight defects — commits without any certificate, as does the cluster
decomposition that produced the blocks, and all of them are priced from the compiled closure tables.

The measured split, 200,000 shots per cell:

| cell                                     | sparse answered | share of shots |
|------------------------------------------|-----------------|----------------|
| surface `d = 9`, `p = 0.001`, phenom.     | 2,613           | 1.3%           |
| surface `d = 9`, `p = 0.001`, circuit     | 64,113          | 32%            |
| repetition `d = 25`, `p = 0.001`, phenom. | 5,658           | 2.8%           |

At the phenomenological operating point that the reports call the cell real hardware sits in, about
**99 per cent of decodes never touch the certified path at all**. Their exactness rests on the
closed forms being right, the exchange argument behind the cluster decomposition being right, and
the compiled closure being right.

**And the certificate cannot check the closure.** `certify` tests the dual against
`spec.closure_distance` / `spec.closure_narrow` (`tiger_blossom_sparse.rs:1544-1548`), which is the
same table the caller priced the primal from (`tiger_blossom.rs:1166`, `:1171`). A wrong entry in
the compiled closure — from the interior neighbour-offset relaxation at `tiger_blossom.rs:808-812`,
say — moves both sides of the equality together and is invisible to the certificate by construction.
The certificate proves the matching optimal *in the compiled metric*; it says nothing about whether
the compiled metric is the graph's.

**Mitigating evidence, and it is strong**: PyMatching 2.4.0 is verified against the routed arm at
20,000 shots on each of 51 cells with zero weight disagreements
(`benchmarks/tiger-blossom/2026-09-04-c1063-6b6999a-pymatching-exactness.txt`, and the weighted
equivalent for C1064/C1065). An independent decoder agreeing on the solution *weight* on a million
shots is a direct empirical test of the closure, the closed forms, the decomposition, and the
matcher together, and it is the reason I rate findings 1 and 2 as claim defects rather than as
live miscomputes. It is not a substitute for the check, because it is an empirical sample and the
claim is a guarantee — but it is the right backstop and it is in place.

## 9. CHECKED-CLEAN — the release-build scheduling invariant fails closed

**Where**: `src/tiger_blossom_sparse.rs:760-776` (`push_event`), `:1323-1355` (the event loop),
`:2488` (`check_no_late_entry`, `#[cfg(debug_assertions)]`).

The brief's concern is that the queue's contract is enforced only by a debug oracle. The picture is
better than that, in one direction and worse in another, and both are worth stating precisely.

**The late-entry direction is enforced in release.** `push_event` refuses any candidate with
`time < self.clock` unconditionally — the `debug_assert!` fires first in a debug build, but the
`reason_late += 1; return false` runs in every build (`:769-775`). Callers propagate that `false` to
`SparseOutcome::Exhausted`, which declines the block. So the violation the counter names does fail
closed, in the shipped binary, with a count.

**The dangerous direction is the opposite one and it is not enforced anywhere**: an event whose true
time is *earlier* than any queued entry — a handler that changed a rate and failed to re-arm what it
changed — pushes nothing, so `push_event` never sees it. Nothing in the release build detects it.
What catches it is `certify`, and only `certify`: growing past a constraint makes the dual
infeasible, which the boundary and pair checks reject, and stopping short of one leaves the dual
slack against a suboptimal primal, which the objective equality rejects. The decode then declines
and is flagged.

That is a genuine fail-closed story, and it is why findings 1 and 2 matter more than they would in
isolation: **the certificate is the only release-build guard on the entire scheduling invariant**,
so the two holes in the certificate are also the two holes in the scheduling guard. A missed event
that produced a non-involutive pairing would pass both.

Measured decline rate on the shipped configuration: `needs_blossom 0 exhausted 0 uncertified 0
overflowed_shots 0` on every cell of the 200,000-shot census
(`2026-09-04-c1064-fast-path-census-both-models.txt`). The bounded path is not observed to run at
all at the operating points.

## 10. CHECKED-CLEAN — performance-contract conformance of C1065, C1066 and C1067

Verified independently of C1067's conclusions, against
`~/src/ergodis-contrib/PERFORMANCE.md` and `performance-playbook.md`:

- **Zero allocation in the decode loop.** Every `vec!`, `Vec::`, `push`, `Box::new` and `collect`
  in `tiger_blossom_sparse.rs` at HEAD sits inside `SparseMatcher::new` (lines 474-592). No
  allocation appears in `solve`, any handler, `resolve_pairing`, or `certify`. The occupancy bitmap
  `bucket_bits` and the undo lists are allocated at construction like everything else.
- **Layout assertions are present and are compile-time.** `const _: () = assert!(size_of::<T>() ==
  .. && align_of::<T>() == ..)` for `NodeState` (16/4), `RegionRate` (8/4), `EdgeState` (16/4),
  `Incident` (8/4) and `Event` (8/4) — `tiger_blossom_sparse.rs:192, 203, 214, 225, 241`. There is
  also a runtime construction-time check that an event key fits an undo entry (`:529-535`).
- **Per-node instrumentation is out of the shipped build.** The `traffic!` macro expands to
  `#[cfg(feature = "tiger-traffic")]` (`tiger_blossom_sparse.rs:141-148`); the feature is declared
  in `Cargo.toml:18` and re-exported in `tasks/tools/Cargo.toml:15`. This is C1067's finding 1 and
  it holds.
- **The counter-build label is plumbed, which closes the trap the gating opens.** With the feature
  off, `last_events` stays zero and `census.sparse_events` is silently zero. Every bench mode that
  prints an events figure prints `counters on`/`counters off` beside it
  (`tiger_blossom_bench.rs:366, 454, 642, 835`), so a zero cannot be misread as a measurement.
- **Two-arm dispatch is resolved at graph-compile time.** `SparseArm` holds one monomorphization,
  chosen on the compiled largest edge weight, and only the selected arm is allocated
  (`tiger_blossom_sparse.rs:2862-2870`); `on_arm!` is a two-way `match` on the enum, not a branch
  inside any loop.
- **Exhaustion paths are bounded.** The event loop carries an explicit budget,
  `(nodes * max_degree + count) * 32 + 4096`, decremented per pop, declining on underflow
  (`:1324-1332`). `walk_stack`, `cycle_*` and `task_*` are sized at the region count and the
  structures walked are forests, as C1067 argued; I re-derived that and it holds.

**One caveat C1067 did not name.** `record_undo` (`tiger_blossom_sparse.rs:381`, set at `:1832`,
read at `:1737` and `:1751`) is a *per-shot* run-time bool read on every key touch. It is
shot-constant rather than run-constant, so it cannot be a const generic without duplicating the
solve, and the branch is perfectly predictable within a shot. It is a defensible exception to
"no run-constant branch in the production instantiation", but it is an exception, and C1067's
"run-constant choices are dispatched outside the loop" reads as though there were none.

## 11. PLAUSIBLE RISK — the invalidated surface numbers were never restated at their own site

**Where**: `notes/2026-09-04-c1063-tiger-blossom-routing-and-real-usage-grid.md:19-66` (the
distance-one defect in `RotatedSurfaceCode::new` and the invalidation sentence), against
`notes/2026-09-04-c1061-probe28h-margin-radius-and-the-surface-d9-rederivation.md`.

C1063 states plainly: "This invalidates surface-family numbers taken before 2026-09-04, including
probe 28h's distance-9 surface rows, which were themselves a re-derivation." That is the correct
call and the accompanying accuracy census (logical error rising with distance, matching `rounds * p`
to three digits) is convincing evidence that the pre-repair code was distance one.

The probe 28h report was not annotated. Grepping it for `C1063` returns nothing. It still presents,
as current results:

- the margin-radius grid rows for surface `d = 5` and `d = 9`
  (`probe28h...md:48-49`),
- the region-shape table rows for surface radius 1 and radius 2 (`:72-73`),
- the whole "Part two: the surface d=9 rows, re-derived" section (`:104-135`), which re-derived
  those rows for the *earlier* 32-bit-mask defect and was itself invalidated hours later by the
  distance-one defect.

A cold reader arriving at probe 28h — which is exactly what the report index invites — takes those
surface rows as standing. The backing evidence file
`benchmarks/tiger-blossom/2026-09-04-probe28h-margin-radius-grid.txt` is in `SHA256SUMS`, so the
manifest positively attests a file whose surface rows are known to be wrong; the hash certifies the
bytes, and nothing in the directory says the bytes are stale.

**Why PLAUSIBLE RISK and not CONFIRMED**: I found no *later* report that reuses a stale surface
number. C1063 restated both PyMatching grids on the repaired builder, C1064 and C1065 built on
C1063, and the repetition-family numbers — which C1063 correctly notes carry every TigerBlossom
performance figure and the whole PyMatching comparison — never used that builder and are untouched.
The risk is forward-looking: the stale rows are still readable as current, in a committed report and
in a hashed evidence file, with the correction recorded only in a different document.

**Cheap repair**: a dated superseded-by line at the head of probe 28h's Part two, and a comment line
in `SHA256SUMS` beside the probe-28h entry.

## 12. CHECKED-CLEAN — statistical practice in the A/B driver

- **Two-size differencing is sound in principle and the setup really is constant.** Tiger's
  `setup` (graph compile, workspace, shot draw) does not scale with `--operations`
  (`tiger_blossom_bench.rs:236-265`), and PyMatching's `load`+`build` does not scale with its
  operation count (`tiger_blossom_pymatching_baseline.py:107-110`). The difference does isolate
  per-decode work, modulo finding 3's divisor.
- **Interleaving is real.** Arms alternate inside each round (`tiger_blossom_ab.py:174-177`,
  `:387-396`), so thermal drift is shared. Ratios are paired log-ratios with a t-interval
  (`:112-129`), which is the right estimator for this design.
- **Interrupted runs are labelled as such and are used only to reject.** Both occurrences —
  C1065's undo-list-as-only-clear (`notes/2026-09-05-c1065-...:294-299`) and C1066's heap arm
  (`notes/2026-09-05-c1066-...:49-53`) — are negative controls stopped once the verdict was uniform
  against the candidate, and both say so in the sentence that cites them. Stopping early on a
  uniform loss is legitimate; neither is used to support a shipped change.
- **The reports disclose the PyMatching arm's instability.** C1063 states that PyMatching's spread
  is "one to thirty per cent between rounds, against about 0.01 per cent for the kernel, so its
  ratios are worth one significant figure and no more", and names the specific cell where that
  visibly distorts a row (`notes/2026-09-04-c1063-...:—the paragraph citing the real-usage log`).
  That is the correct disclosure and it is made where the numbers are published.

**The residual, stated for completeness**: sample counts are small and the driver drops samples
silently. `paired_ratio` filters to `a > 0 and b > 0` (`tiger_blossom_ab.py:114-118`), so any round
whose two-size difference came out non-positive — noise exceeding signal — vanishes without a
notice. In `2026-09-04-c1063-6b6999a-vs-pymatching-real-usage.log`, of 133 rows: 106 have `n 3`,
17 have `n 2`, 7 have `n 1` and 2 have `n 0`. The `n 1` and `n 0` rows print `ratio nan`, which is
visible. The `n 2` rows print a point estimate against a t-quantile of 12.71 and confidence
intervals like `[0.021, 0.994]` — an interval that is technically correct and practically empty.
Those rows should not be quoted as figures. C1063's own "worth one significant figure" caveat
covers this in spirit; nothing in the log marks which rows it applies hardest to.

## 13. WORKING TREE (advisory, C1068 in flight) — the saturating closure cap is sound

Not part of the audited baseline, but read while separating it out, and worth recording because it
touches the certificate.

The in-flight change replaces `closure_narrow` with `closure_bound` plus `closure_bound_cap`, where
`cap = 2 * max(boundary_distance)` and `closure_bound[i] = min(closure_distance[i], cap)`
(`src/tiger_blossom_graph.rs:457-471`, working tree). The certificate reads `closure_bound` in the
pair constraint, so a capped entry makes the test `crossing > 2 * cap` rather than
`crossing > 2 * true_distance` — strictly tighter, hence fail-closed rather than fail-open.

It is also lossless, which is the part worth stating: once the per-defect boundary constraints have
passed, `crossing <= own_left + own_right <= 2*bd_left + 2*bd_right <= 4*max(bd) = 2*cap`, so the
capped comparison can never fire spuriously. Capping at twice the largest boundary distance is
exactly the point above which the pair constraint is vacuous. The change is correct and it removes
the `closure_narrow`-is-empty fallback that HEAD needed on graphs with a pair distance past `u16`.

The other working-tree change, hoisting `defect_top` so a pair whose defects sit under different
outermost regions skips both chain walks, rests on containment chains being nested — a region
holding both defects would be an ancestor of both, so their chains would end at it. That reasoning
is sound for a forest, and the forest property is the same one the bounded-stack argument uses.

---

## Checked clean

Consolidated, so it can be read without hunting through the findings:

1. **The shot generator is not inside the Tiger arm's measured loop.** Shots are drawn once in
   `setup`, before the timer (`tasks/tools/src/tiger_blossom_bench.rs:241-249, :275`). Both arms
   replay pre-generated syndromes. The brief's hypothesis does not hold.
2. **Both arms decode the same graph and the same quantized integer weights.** The emitter writes
   the kernel's own compiled weights into the shot file and the PyMatching graph is rebuilt from
   them (`tiger_blossom_bench.rs` emit header comment; `tiger_blossom_pymatching_baseline.py:59-77`),
   so a weight disagreement in the exactness runs is a decoding disagreement, not a rounding one.
3. **The dual's sign, boundary and pair constraints are all checked, and correctly.** Details in
   finding 2's closing paragraph. Doubled units are consistent throughout.
4. **Blossoms are odd by construction.** `contract` refuses an even cycle before allocating.
5. **The late-entry refusal runs in release, not only in debug.** `push_event:769-775`.
6. **Zero allocation in the decode loop; compile-time layout assertions present.** Finding 10.
7. **Traffic counters are feature-gated out of the shipped build, and every printed events figure
   is labelled with whether the counters were on.** Finding 10.
8. **The queue-discipline arm is chosen at graph-compile time and only the chosen arm is
   allocated.** `SparseArm`, `tiger_blossom_sparse.rs:2862-2870`.
9. **Interrupted runs are labelled and used only to reject candidates**, in both places they occur.
10. **The reports disclose PyMatching's round-to-round instability where the ratios are published**,
    and name the specific cell it distorts.
11. **The manifest's 58 entries all resolve and all their files exist.** C1067's repair works; it is
    the coverage that is short (finding 6).
12. **The observed decline rate is zero** across 200,000 shots per cell on both noise models:
    `needs_blossom 0 exhausted 0 uncertified 0 overflowed_shots 0`.

## What I could not check, and why

1. **Whether finding 1 is reachable.** Establishing that `descend` can or cannot deliver the same
   defect to two outermost regions needs either a proof about `child_index_containing` and the
   blossom forest or a fuzz run. The brief forbids running anything, and I did not find the argument
   by reading. The finding stands as a claim defect regardless; whether it is also a live miscompute
   is open. **This is the single highest-value follow-up**: the check costs `O(count)` and closes it
   either way.
2. **The magnitude of the working-set asymmetry in finding 4.** Bounding it means re-running the
   PyMatching arm at a 4,096-shot window and differencing, which is a measurement.
3. **Whether the 2.34 per cent divisor error in finding 3 is the whole story for the Python arm.**
   PyMatching's per-decode instruction counts vary 2 to 21 per cent round to round on a deterministic
   workload, which says the two-size difference is not fully isolating decode work in that arm. I
   could not separate interpreter jitter from the divisor without running.
4. **The predecoder path.** The brief asks whether the predecoder commits without a certificate.
   Probe 28c's report describes TigerBlossom as the *oracle behind* a separately certified
   predecoder, and the predecoder itself lives outside the four files named in the brief. I did not
   go looking for it — scoping rules — so I can say nothing about whether its own certificate is
   complete. Given that findings 1 and 2 are about an incomplete certificate in the file I did read,
   **the predecoder's certificate deserves the same read** and has not had one here.
5. **The probe reports before 28c.** These were consulted only through the index in
   `notes/2026-09-03-c1061-exploration-log.md`. No risk trail led back into them, so their numbers
   are unaudited here.
6. **`RotatedSurfaceCode::new` itself.** I took C1063's distance-one diagnosis on the strength of its
   accuracy census (error rising with distance and matching `rounds * p` to three digits, which is a
   signature that cannot be faked) rather than re-deriving the code distance. The builder is outside
   the four named files.
7. **Anything requiring a build, a test run, or a benchmark.** No `cargo`, `perf`, or Python was run.
   Every number in this review is read from a committed evidence file or derived arithmetically from
   the scripts' constants.
