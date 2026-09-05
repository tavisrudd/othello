# C1062 probe 2: best intervention over the monoid action, and the economics that follow

**Lane**: `complete-ports`
**Task**: C1062, probe 2
**Plan**: `2026-09-04-c1062-exploration-log.md`
**Inputs**: probe 1a for the cost model, probe 1 for the lowering and its class oracle, probe 3 for
the actual-cause layer that feeds this one a minimal contingency.
**Code**: `ergodis-private` `17906d2` (library) and `4b2276a` (report tool)
**Replay**: `cargo test --release -p ergodis-private --lib best_intervention::` for the correctness
gates; `cd ~/src/ergodis-private && cargo run --release --package ergodis-tools --
best-intervention-report --rounds 5 --workloads 256,1024,4096,16384,65536` for every table below.
`rustc 1.93.1`, release profile, `choom -n 1000`, single thread.
**Evidence**: `ergodis-private` `evidence/2026-09-05-best-intervention-repaired.txt`, the output of
that command after the review repairs. No evidence was retained when this report was written, which
matters most for the timing tables, since those are the one kind of number a later re-run cannot
recover. That capture was taken on a contended host (load average around 6 of 24 cores), so its
absolute milliseconds run above the ones below; every argument here is about ratios between arms
measured in the same process.
**Reviewed**: `2026-09-05-c1062-probe2-review.md`. Corrections from that review are marked
**[corrected]** below and the original text is kept wherever it explains how a number was reached.
**Baseline repair**: `2026-09-05-c1062-probe2-concrete-baseline-predeclaration.md`, committed before
the change it predicts. § "The strengthened concrete baseline" carries the result and is the headline
comparison; the `220x` and `103x` figures are weaker-baseline numbers kept for their derivation.

**Verdict.** The decision layer is built and it is exact: the compiled arm agrees with the
enumeration oracle on every query over every context in six families, and every witness it returns
replays through the model. The **compression threshold passes** — two families clear 1.5x residual
above a verified symmetry fold, and every predeclared verdict lands. The **timing threshold fails**,
and the reason is structural rather than a constant: on the flat `(u, I)` carrier the compile solves
the model once per materialized state, and that state count is *exactly* the total work a memoized
re-solve does to fill its table over every context. Measured ratio: 1.00x. Probe 2's kill criterion
is a disjunction and its first disjunct fires.

But the loss is narrow and it locates the win precisely. The compiled quotient beats the identical
shortest-path search run on the concrete states by **220x**, and loses to exhaustive memoization by
only **6.3x** — and it loses only because on a flat carrier the entire context space is small enough
to memoize. That is a statement about the flat lowering, not about the decision layer. The route
where the compiled query wins is the one where the carrier is never materialized, which is probe 7.

**[corrected]**, and the `220x` is **withdrawn**. Two things are wrong with it.

- **The arms were not memoized alike.** `12.420 ms` is the compiled arm *with* a class memo and
  `2,733.393 ms` is the concrete arm with no memo of any kind. The like-for-like row was already in
  the same table — `compiled` without a memo against `state search` without one — and it reads
  `102x`; on the repaired code it is unchanged at `103x` (`1,829.704` against `17.803` at 65,536
  queries). **That `103x` is itself superseded**: against a concrete arm given the same edge
  representation as the compiled one it is **`6.8x`**. See § "The strengthened concrete baseline",
  which is now the headline comparison; `103x` and `220x` are both weaker-baseline numbers and are
  kept only to show how they were reached.
- **What remains is a representation difference, not a compression measurement.** Hard interventions
  are idempotent and commute on distinct variables, so the reachable set from `(u, {})` is the single
  fibre `{(u, I)}` — 129 states of the 33,024 in the carrier. The concrete arm nonetheless touches the
  whole carrier on every query: it cleared two arrays of 33,024 entries per query, and, more
  expensively, it scans **every one of the 256 generators at every settled state** because it walks
  the presentation's dense `(generator, state)` transition table rather than an adjacency list. The
  compiled arm walks a 200-edge per-class adjacency that fits in cache. The report tool now prints
  both work counts (`356.7` edge relaxations per query against a 33,024-state carrier and a
  256-generator alphabet), so the ratio can be read against the work rather than taken on its own.

The review predicted that bounding the per-query clear would collapse the concrete arm's cost, and it
did not: the clear was worth roughly a sixth of the per-query time and the generator scan is the rest.
That prediction is corrected here rather than quietly dropped. The defensible statement of what
quotienting buys the query is the one this report already makes in § "What a query actually walks" —
the graph is `22x` to `84x` smaller and the weighted plan collapses parallel edges by a further `1.07x`
to `1.46x` — and those numbers are counts off the compiled artifact, not timings.

**[corrected]** the `6.3x` is `5.0x` on the repaired code and the current core (`8.176` against
`1.632` at 65,536 queries). The direction and the argument are unchanged.

## The strengthened concrete baseline

This section supersedes the `220x` and the `103x` above. It was **predeclared before the change was
written**, in `2026-09-05-c1062-probe2-concrete-baseline-predeclaration.md`, committed at `othello`
`7f6367bb3`; the code came afterwards.

**What changed.** `ConcreteSearch` used to scan *every* generator in the presentation at every settled
state and ask the transition table whether it applied. On the timing family that is 256 generators of
which about seven — the ones belonging to the state's own sort — can apply, so the arm was paying a
dense `(generator, state)` matrix scan where the compiled arm walks a compact 200-edge per-class
adjacency. `ConcreteSearch::new` now precomputes a state-to-sort map and the generator ids grouped by
source sort, as one flat array with an offset per sort, and the search enumerates only its state's
own list. The graph, the costs, the Dijkstra and the heap are untouched; only which candidate edges
are enumerated changes. This is a change to *what the baseline is*, not to how it is measured, and it
is the change the plan's own rule about strong baselines asks for.

**Predicted, then measured.**

| quantity | predicted | measured |
|---|---|---|
| `relaxations` per query | unchanged at `356.7` | `356.7` |
| answers | identical | identical |
| candidate edges per query | `16,512` to about `357` | `16,512` to `356.7`, of which `356.7` apply |
| like-for-like ratio, `state search` against `compiled` | `7x`, band `4x`–`15x` | **`6.8x`** |
| compiled form still winning | ratio `>= 5x` | met, at `6.8x` |
| every other table | unmoved | unmoved |

On a quiet host at 65,536 queries: `state search` `123.651 ms` against `compiled` `18.142 ms`. The
arm's marginal per-query cost falls from `27.81 µs` to `1.788 µs`, a `15.6x` speedup against a
`46.3x` reduction in candidate edges — the gap between those two being the heap and the bookkeeping,
which the prediction budgeted at about `1.6 µs` per exhausting query. The retained evidence file was
captured under load and reads `201.869` against `28.244`, a ratio of `7.15x`: the absolute
milliseconds move with the host and the ratio does not, which is why the ratio was the quantity
predeclared.

**What it means.** Roughly **93 percent of the published `220x` was representation** — a dense matrix
scan against an adjacency list — and not the compression the arm was named for. What survives is
`6.8x`, which clears the predeclared `5x` bar, so the quotient's smaller search graph is a real
per-query effect and not nothing: 129 reachable concrete states with `356.7` applicable edges against
at most 74 classes with 200 plan edges, plus the compiled side's indexed decrease-key heap against the
standard-library binary heap the concrete arm still uses. A tighter comparison would equalize the heap
too, and would shrink `6.8x` further; that is the remaining known asymmetry and it is named rather
than measured.

The direction of the probe's verdict is unchanged and its shape is sharper. Quotienting the search
graph is worth single digits at query time on this family, not two orders of magnitude. What loses
remains materializing the flat carrier, and that conclusion never rested on this arm.

## Predeclarations, entered before any measurement

Committed before the measuring code was written (`a6bd72e6a`, extended in the next commit to cover
two families added while building, still before any run).

### The two thresholds

1. **Timing.** The compiled arm must beat a **memoized** re-solve on the enumeration query, with the
   break-even query count reached within the number of distinct contexts.
2. **Compression.** Residual compression above the orbit baseline must exceed **1.5x** on at least
   one family whose verified automorphism group is trivial or near-trivial.

**[corrected]** This paragraph was edited in the same commit that carried the results, and the edit is
not marked. As committed before any code (`a6bd72e6a`, extended at `b2bd15820`, both ahead of the
report tool at `4b2276a`) it read: "Residual compression above the orbit baseline, **`orbits / classes`**,
must exceed 1.5x on at least one family whose **declared** automorphism group is **trivial**.
Relevance pruning and symmetry are free; only the residue counts." The results commit deleted the
metric and widened "declared … trivial" to "verified … trivial or near-trivial" — the second change
being exactly what `weighted-threshold-8` needed once the run found two of its 28 transpositions
verifying, against a shape reading that had said it admits no symmetry. The predeclaration *order* is
good and better than probes 6 and 7 manage; the predeclaration *text* was amended after the fact
without a marker. Read as it stood before the run, the threshold still passes on
`weighted-threshold-8`, which was declared trivial and clears 1.5x under either metric.

### Predicted verdicts per family

| Family | Shape reading | Prediction |
|---|---|---|
| `reliability-3of8` | C1, C2 (failed-count summary), C3, C4, C5 (full symmetric group) | **loss**: classes are the failed-count strata, so orbits equal classes and residual is exactly 1.0 |
| `weighted-threshold-8` | C1, C2, C3, C4; **not** C5 — distinct Fibonacci weights admit no symmetry | **win**: orbits are singletons, so every merge is intervention-driven |
| `distractor` | C1, C2, C3 | **loss**: relevance pruning explains all of it |
| `identity` | C1, C3; **fails C2** — observing every variable leaves no sufficient summary | **loss**: classes equal contexts |
| `wide-conjunction` | C1, C2, C3, C4 | **partial**: the arity tower refines past one, so some of the collapse survives |
| `restricted-vocabulary` | C1, C2, C3, C4 — eight components of which only three may be touched | **win**: the realistic repair vocabulary leaves unpinned contexts room to merge |
| `deep-pipeline` | the timing family, depth 24 | **win** on time: the compiled arm crosses below the memoized re-solve within the distinct-context count |

Every candidate symmetry offered to a family is verified exhaustively and only the verified ones
enter its orbit baseline, so a family cannot be made to look intervention-compressed by declaring a
thin group.

## What was built

`ergodis-private/src/best_intervention.rs` adds four things to probe 1's lowering.

**The query.** `best_intervention` is the minimum-cost declared edit reaching a declared observation,
computed as one shortest path over the quotient's weighted generator plan — the core's
`compile_weighted_generator_plan` and `shortest_word_to_output_in`, which is Dijkstra over the monoid
action on `Q` with no allocation in the relaxation loop. Under a unit cost table the minimum cost is
the minimum arity, so the same call answers "does any intervention of arity at most `k` reach `o`?".
A costed table makes it a genuine repair-planning query, and there is a test showing it prefers a
cheap repair on one component over a dear one that would work equally well.

**Why the compiled answer is the true answer.** A generator word from `(u, {})` ends at `(u, I)` for
`I` the last-write-wins override of its steps, so no word reaches an observation that some single
intervention does not. A word that overwrites a variable pays for both writes while the normalized
intervention pays only for the last, so the minimum over words equals the minimum over interventions.
The quotient is a congruence with a well-defined class output, so a path found from the root class
replays from the concrete root state to a state carrying that observation. None of the three steps is
taken on trust: the enumeration oracle re-solves the model at every admissible partial assignment,
and every compiled witness is replayed through the model.

**The three baselines**, with the orbit baseline verified rather than declared, plus a fourth arm
that separates the search from the quotient — the identical shortest path run on the concrete
`(u, I)` states with no compile at all.

**Minimax regret** over a bounded set of candidate mechanism tables, with the intervention set
quotiented by the tuple of classes each intervention reaches across the candidates.

## The correction the measurement forced

The plan asked for `orbits / classes` as the credit ratio, reasoning that in a reliability family
"the classes are just the failed-count orbits". That is false, and the first run of the symmetric
family said so: 256 contexts, 9 orbits, and **164 classes**. The classes are strictly *finer* than
the orbits and the ratio sits below one.

The mechanism is the labelled vocabulary. Intervening on component three is a different context word
from intervening on component five, so from the arity-two signature a caller reads
`total − u_i − u_j` for every labelled pair `(i, j)`, which recovers the whole failure set except
where the threshold saturates. A component permutation therefore **permutes** the classes rather than
merging them: the class partition is equivariant under a declared symmetry, not invariant under it.
Only the contexts with five or six failures saturate and merge.

So `orbits / classes` is not a credit ratio at all. The right comparison is against the **join** of
the two partitions — the coarsest partition refined by neither — which is what a system carrying both
a symmetry fold and a compiled quotient would actually get. That is what the residual column reports.
The correction matters beyond bookkeeping: symmetry and interventional refinement compress along
incomparable axes, so a system that has one still wants the other.

## Compression, against the three baselines

| family | contexts | pruned | verified/offered | orbits | classes | joint | residual | vs classes |
|---|---|---|---|---|---|---|---|---|
| `reliability-3of8`      | 256 | 256 | 28/28 |   9 | 164 |  6 | 1.500 | 0.055 |
| `weighted-threshold-8`  | 256 | 256 |  2/28 | 144 |  44 | 29 | 4.966 | 3.273 |
| `distractor`            |  32 |   8 |  4/10 |   4 |   8 |  4 | 1.000 | 0.500 |
| `identity`              |  18 |  18 |   0/0 |  18 |  18 | 18 | 1.000 | 1.000 |
| `wide-conjunction`      |  32 |  32 | 10/10 |   6 |  17 |  4 | 1.500 | 0.353 |
| `restricted-vocabulary` | 256 | 256 | 13/28 |  24 |  24 | 12 | 2.000 | 1.000 |

**[corrected]** The `vs classes` column is new and is `orbits / classes`, the residue as the plan
predeclared it. Nothing else in the table changed. The two metrics disagree about which families clear
the bar, and the disagreement is not bookkeeping:

- Under the published `orbits / joint`, two families clear `1.5x` — `weighted-threshold-8` at `4.966`
  and `restricted-vocabulary` at `2.000`.
- Under the predeclared `orbits / classes`, **one** does. `restricted-vocabulary`, a predicted *win*,
  sits at exactly `1.000x`: the compiled quotient produces exactly as many classes as symmetry
  produces orbits. Its `2.000` arises because the two partitions differ while having the same block
  count, so their join halves it — a genuinely interesting fact, and not the quantity the prediction
  was made against.

The correction that motivated the swap is right and is not in dispute: `verify_automorphism` requires
`O(sigma u, sigma I) = O(u, I)` over every context and every admissible pinned assignment, which makes
a verified symmetry permute the classes rather than merge them, so `orbits / classes` can and does sit
below one. What was missed is that the per-family predictions were made under one metric and scored
under another. Both are now printed so a reader can do either scoring.

One qualification on the orbit baseline itself, in the direction that flatters this probe:
`transpositions_of` offers only component transpositions, so a symmetry not generated by verifying
transpositions is never found, and every such miss leaves the orbit count higher and the residual
larger. On `reliability-3of8` all 28 verify and the group is the full symmetric one; on
`weighted-threshold-8`, where two do, it is unchecked.

**Every predeclared verdict landed.** The two predicted losses lost for exactly the predicted reason:
`distractor` is entirely explained by relevance pruning (32 contexts down to 8, residual 1.000), and
`identity` merges nothing because observing every variable leaves no sufficient summary. The two
predicted wins won, both above the 1.5x threshold: `weighted-threshold-8` at 4.966x and
`restricted-vocabulary` at 2.000x. `wide-conjunction` came in at exactly 1.500x, matching its
"partial" call. `reliability-3of8` lost as predicted but by a different mechanism than predicted,
which is the correction above.

**[corrected]** `reliability-3of8` is scored as a landed prediction on a number that contradicts it,
and `restricted-vocabulary` is counted as a predicted win under a metric adopted after the fact
(see the correction to the table above; under the predeclared `orbits / classes` it is `1.000x`). The
entered verdict for `reliability-3of8` was "**loss**: classes are the failed-count strata, so orbits
equal classes and residual compression is exactly 1.0". Measured: 9 orbits against 164 classes — not
equal, off by a factor of eighteen — and a residual of `1.500`, not `1.0`, which is the same value
scored as "partial" for `wide-conjunction` one sentence earlier. Only the one-word label survived, and
the plan's own rule covers this case: a predicted loss that does not lose the predicted way "is a
finding about the shape classifier, not a success for this probe". The finding it produced deserves
stating in those terms: C5 was read correctly for this family — all 28 transpositions verify — and the
inference drawn from it, that orbits therefore equal classes, is what failed, because a labelled edit
vocabulary makes the quotient equivariant rather than invariant. That is a correction to how the
classifier's C5 row should be read when the vocabulary is labelled.

The other number worth keeping beside `1.500` is `0.055`. On this family the compiled quotient folds
256 contexts to 164 classes, a `1.56x` fold, while symmetry alone folds them to 9 orbits, a `28x`
fold: the quotient is eighteen times *worse* than the free baseline. `orbits / joint = 1.500` says
something true and much narrower — the classes bridge four of the nine failed-count orbits, because
with arity two a context with five or more failures can never be repaired and all of them look alike.
The plan's warning was that reporting the reliability family as a win would be self-deception; the
classes turn out not to be the orbits, and both numbers belong in the record.

Two details worth keeping. `weighted-threshold-8` has **2 of its 28 offered transpositions verified**:
distinct Fibonacci weights do not make a family asymmetric, because a threshold can be blind to a
small weight exchange. Had those two been assumed away rather than verified, the family's credit
would have been overstated. And `restricted-vocabulary` — eight components of which only three may be
touched — is the realistic repair shape; there orbits and classes coincide exactly at 24 while the
join halves it to 12, so symmetry and interventional refinement each contribute and neither subsumes
the other.

## What a query actually walks

The root-context compression above is not what prices a query. A query walks the whole quotient
across every sort, and that is where the collapse is large.

| family | states | classes | ratio | raw edges | plan edges | ratio |
|---|---|---|---|---|---|---|
| `reliability-3of8`      | 33,024 | 1,468 | 22.50x | 20,128 | 16,952 | 1.19x |
| `weighted-threshold-8`  | 33,024 |   392 | 84.24x |  4,136 |  2,836 | 1.46x |
| `distractor`            |    152 |    56 |  2.71x |    288 |    264 | 1.09x |
| `identity`              |    540 |   126 |  4.29x |    864 |    810 | 1.07x |
| `wide-conjunction`      |  1,632 |   122 | 13.38x |    920 |    670 | 1.37x |
| `restricted-vocabulary` |  4,864 |   120 | 40.53x |    660 |    564 | 1.17x |

The graph a query searches is 22x to 84x smaller than the concrete one on the larger families, and
the weighted plan's own collapse of parallel edges adds a further 1.07x to 1.46x on top. This is a
large, real compression, and the timing section is where it gets cashed — or does not.

## Correctness

The compiled arm was run against the enumeration oracle on **every context crossed with every
attainable observation** in all six families, and every witness it produced was replayed through the
model. A query whose target is unreachable yields no witness, which is why the witness column sits
below the query column.

| family | queries | agree | witnesses | replayed | verdict |
|---|---|---|---|---|---|
| `reliability-3of8`      | 512 | 512 | 418 | 418 | pass |
| `weighted-threshold-8`  | 512 | 512 | 490 | 490 | pass |
| `distractor`            |  64 |  64 |  64 |  64 | pass |
| `identity`              | 324 | 324 | 252 | 252 | pass |
| `wide-conjunction`      |  64 |  64 |  48 |  48 | pass |
| `restricted-vocabulary` | 512 | 512 | 441 | 441 | pass |

Agreement is on cost, and unreachability agrees too: the compiled arm and the oracle return "no
intervention reaches this" on exactly the same queries.

## The structural bound

The flat lowering materializes one state per (context, admissible intervention) pair and solves the
model once at each, because it must label every state with its observation. Filling a memo over
every context costs one enumeration per context, which is one solve per (context, admissible
intervention) pair. **These are the same number.** On the timing family both are 33,024, a measured
ratio of 1.00x, and the compile then pays refinement on top.

So on this carrier a compile cannot come out ahead of exhaustive memoization, for any family, at any
workload length. This is not a tuning result and no faster refinement changes it. It is the decision
layer's version of what probe 1a already established about the carrier.

**[corrected]**, twice, and both corrections run *against* the compile, so the conclusion is
understated rather than overstated.

- **The `1.00x` is an identity, not a measurement.** The report tool computes it as
  `states / (contexts * interventions)`, and the carrier is defined as one state per
  `(context, admissible intervention)` pair, so `33,024 = 256 * 129` holds by construction. As a
  structural argument that is exactly right and is what this section claims; printed under the heading
  "Measured ratio" beside a timing threshold, it reads as an empirical tie and is not one.
- **The memoized arm does half the solves the identity charges it with.** `best_intervention_enumerated`
  prunes by cost before solving — `if best.is_some_and(|(incumbent, _)| cost >= incumbent) { continue }`
  — and supports are enumerated shortest-first, so once a cost-`c` answer is found every candidate of
  cost `>= c` is skipped unsolved. On the timing family that is a clean factor of two: an independent
  re-derivation of `deep_pipeline(8, 24, 8)` gives 128 of 256 contexts answering at cost zero after one
  solve and the other 128 unreachable after all 129, for **16,640** solves against the carrier's
  33,024. The arm's own timing corroborates the count — `1.7 ms` at 65,536 queries is 16,640 solves of
  a depth-25 chain at about 90 ns each, and neither that nor the unmemoized column fits 33,024.

The consequence for the reading below is that "the entire remaining gap is the lowering constant … a
factor of about six for building transition tables on top of **the same solves**" misattributes about
half of the gap: the solves are not the same, the memo does half as many, and the per-solve costs then
differ by two to three times rather than six. The direction of the verdict is unaffected — the compile
is charged more solves than the strongest baseline actually performs, so "a compile cannot come out
ahead of exhaustive memoization on this carrier" holds a fortiori — and the word to drop is "exactly".

## Timing

The compiled arm is given its cheapest correct configuration. The policy table below shows the split
transcript compiling this shape and agreeing with the audited compile class for class, so charging
the arm for the exhaustive pair certificate would be an unfair boundary. All five arms answer the
identical deterministic query sequence, in rotated order across five interleaved rounds, and the
answers are checked for equality rather than assumed. Each compiled or state-search total **includes
its own build**, so the boundary is equal.

Timing family `deep-pipeline`: 8 exogenous sources feeding a depth-24 endogenous chain into a sink,
8 intervenable variables, arity 2. 256 contexts, 129 admissible interventions per query, 33,024
states collapsing to **74 classes** and 200 plan edges.

Build split: **lower 9.567 ms, refine 1.792 ms** under the split transcript, against **1,516.079 ms**
under the exhaustive pair audit. Refinement — the part that produces the quotient — is cheap. The
certificate is 846x the refinement it certifies.

Total workload milliseconds, median of five rounds:

| queries | enumerate | memoized | compiled | compiled+memo | state search |
|---|---|---|---|---|---|
| 256    |   1.604 | 1.031 | 11.515 | 11.368 |    19.474 |
| 1,024  |   6.401 | 1.643 | 11.703 | 11.596 |    48.852 |
| 4,096  |  25.154 | 1.682 | 12.257 | 11.699 |   163.695 |
| 16,384 | 103.231 | 1.830 | 15.273 | 11.675 |   687.406 |
| 65,536 | 413.251 | 2.517 | 26.858 | 12.420 | 2,733.393 |

Paired memoized against compiled-with-a-class-memo at 16,384 queries: geometric mean **0.1589x**,
`t = −347.299`, `n = 5`. Peak RSS for the whole report, dominated by the audited compiles, 500,312 KiB.

Four things to read out of that table.

1. **The compiled arm never crosses.** It is 6.3x behind the memoized re-solve and stays there. The
   entire remaining gap is the lowering constant — 9.567 ms to materialize the carrier against about
   1.5 ms to fill the memo, a factor of about six for building transition tables on top of the same
   solves. This is the structural bound with its constant measured.
2. **Both winning arms are flat and the naive arms are not.** From 256 to 65,536 queries the
   memoized arm moves 1.031 to 2.517 ms and compiled-with-memo moves 11.368 to 12.420 ms, while
   plain enumeration grows 258x and the concrete state search grows 140x. Amortization is real; it
   is just that the cheaper thing to amortize is the memo.
3. **The quotient is worth 220x against the same search on concrete states** — 12.420 ms against
   2,733.393 ms at 65,536 queries. Quotienting the graph is emphatically not the thing that failed.
   What failed is materializing the graph in the first place.
4. **The class memo matters only for the compiled arm.** Without it the compiled arm drifts from
   11.5 to 26.9 ms as the workload grows, because it re-runs Dijkstra per query; with it, 74 classes
   cover 256 contexts and it stays flat.

**[corrected]**, four items across this reading and the table above it.

- Point 3's `220x` is withdrawn; see the verdict correction. Point 4 describes the compiled arm's own
  drift correctly and is not a reason to withhold a memo from the arm it is compared against: a
  per-context memo over 256 contexts would flatten the concrete arm the same way, and none was
  offered.
- Point 1's attribution is corrected in the structural-bound section above: about half the gap is the
  memo doing half as many solves, not table-building.
- **The workload has no nontrivial answers.** On `deep-pipeline` at the target these arms ask for,
  128 of the 256 contexts answer at cost zero and the other 128 are unreachable; the report tool now
  prints the split (`2067 at cost zero, 2029 unreachable, 0 with a nonempty intervention` over a
  4,096-query workload). No arm ever runs the query the probe is about, which also makes the
  "arms return identical costs" check nearly vacuous — the answer vector is `Some(0)` and `None` and
  nothing else. The real correctness gate is the six-family table in § "Correctness", which does
  exercise nonzero costs across every attainable observation. This does not weaken the timing verdict:
  a workload of trivial queries is the *most* favourable one for the compiled arm, since a harder query
  would cost it a real Dijkstra per query while the memo would still be one hash lookup. It does mean
  the table measures fixed costs and per-query overheads rather than query cost.
- **"Agreeing with the audited compile class for class" was checked as class-count equality.** The
  tool compared `class_outputs().len()` on both sides; two different partitions can have the same
  block count, which is what the `restricted-vocabulary` row of the compression table is about. It now
  compares `state_classes()` and `class_outputs()` exactly, and still prints `true`. The claim was
  correct — the core's cross-policy gate establishes it — it just was not what this tool checked.

**[corrected]** every millisecond in the table above predates the core certificate-policy repair
recorded in `2026-09-04-c1062-core-certificate-policy-repair.md`, and three figures no longer
reproduce. On the repaired core and the repaired arm, at the same configuration:
`lower 6.387 ms` and `refine 1.186 ms` against the published `9.567` and `1.792`; the exhaustive pair
audit `379.342 ms` against `1,516.079`, so the certificate costs about `320x` the refinement it
certifies rather than `846x`; and peak RSS `258,484 KiB` against `500,312`, the halving that repair
predicted. The workload columns move with the host and are quoted in the evidence file rather than
restated here.

## The declared vocabulary, quotiented by its action on Q

| family | declared edits | distinct actions on Q | collapse |
|---|---|---|---|
| `reliability-3of8`      | 16 | 16 | 1.00x |
| `weighted-threshold-8`  | 16 | 15 | 1.07x |
| `distractor`            |  6 |  6 | 1.00x |
| `identity`              |  8 |  8 | 1.00x |
| `wide-conjunction`      | 10 | 10 | 1.00x |
| `restricted-vocabulary` |  6 |  6 | 1.00x |

A clean negative, and it is the same mechanism as the symmetry correction. With a labelled hard-edit
vocabulary the edits are pairwise distinguishable on `Q` almost everywhere; only `weighted-threshold-8`
collapses a single pair. Revision one of the plan treated the intervention-vocabulary quotient as a
headline; the plan already demoted it to a one-line measurement, and the measurement says it is
empty for this vocabulary shape. It would have content only for an edit set with genuine redundancy
— soft or shifted edits, or several mechanisms that implement the same policy.

## Certificate policies on these lowerings

Probe 3 found the core's quotient-only policy failing above about sixteen sorts and hypothesized that
the threshold tracks the sort count rather than the state count. These lowerings push further and the
hypothesis does not survive.

| family | sorts | states | quotient-only | split | multiway | adaptive | audit |
|---|---|---|---|---|---|---|---|
| `reliability-3of8`      | 37 | 33,024 | **error** | 1,468 | **error** | **error** | 1,468 |
| `weighted-threshold-8`  | 37 | 33,024 | **error** |   392 | **error** | **error** |   392 |
| `distractor`            |  7 |    608 |        56 |    56 |        56 |        56 |    56 |
| `identity`              |  7 |    540 |       126 |   126 |       126 |       126 |   126 |
| `wide-conjunction`      | 16 |  1,632 |       122 |   122 | **error** |       122 |   122 |
| `restricted-vocabulary` |  7 |  4,864 | **error** |   120 | **error** | **error** |   120 |

Three findings, all core rather than lane.

- **`MultiwayTranscript` and `AdaptiveTranscript` fail too**, which probe 3 did not test. Since
  `AdaptiveTranscript` selects the multiway path from presentation shape, its failures track
  multiway's.
- **The threshold is neither sorts nor states.** `restricted-vocabulary` has only 7 sorts and fails
  three policies, while `distractor` has 7 sorts and passes all five; `wide-conjunction` has 16 sorts
  and only multiway fails. Probe 3's stated sort-count hypothesis should be withdrawn.
  **[corrected]** — half right, and now placed. The core repair note traced it: `multiway_admission`
  gates on **at least 4,096 states** and at most two observations per sort, and the refiner behind
  that gate had a bug only some shapes trigger. So it is a state threshold *plus* a shape condition,
  not "neither" — `restricted-vocabulary` at 4,864 states is admitted while `wide-conjunction` at
  1,632 is not, which is why only the explicit multiway policy fails there. Probe 3's sort-count
  hypothesis is still withdrawn.
- **`SplitTranscript` succeeded everywhere and agreed with the exhaustive pair audit class for class
  in every row.** It is the policy to use, and probe 2's timing arm does.

The failure is a fail-closed one: the verifier rejects a partition that is not a congruence, so no
wrong answer escapes. The lowering is not at fault — its range check passes, two independent policies
agree, and the audited compile agrees with an independent signature oracle. **Raising, not fixing**:
`~/src/ergodis` is C1017's active surface.

**[corrected]** the table above is a record of a bug that has since been repaired, and it no longer
reproduces: on the current core all five policies agree on all six families. The diagnosis and the
repair are in `2026-09-04-c1062-core-certificate-policy-repair.md`, which also records that
"fails closed" is true of `compile_observational_with_policy` — the entry point this table uses — and
false of `compile_observational_with_deferred_verification`, which handed back a wrong partition. The
call to raise rather than fix was right.

Worth adding, because it is why none of this probe's numbers were ever at risk: every measured table
here compiles under `ExhaustivePairAudit` or `SplitTranscript`, the two policies the repair note
certifies as correct in every row, and the three affected policies appear only in the diagnostic table
above, whose outputs nothing else consumes. That is a stronger reason than the one that cleared probe
1, which was below the 4,096-state admission gate; four of this probe's six families are well above it.

## Minimax regret

| candidate set | models | raw candidates | quotiented | collapse | minimax regret | agree |
|---|---|---|---|---|---|---|
| `threshold-uncertain-6` | 3 | 73 | 73 | 1.00x | 2 | true |
| `weight-uncertain-6`    | 3 | 73 | 60 | 1.22x | 0 | true |

The quotiented search returns the same minimax value as the raw one in both sets, which is the
correctness gate. The saving is small and in one set absent: when the candidate models disagree only
about a threshold, an intervention's class tuple across the three models is almost a complete
invariant, so nothing merges. The decision-equivalence quotient probe 6 owns will have to come from
the *decision* key rather than the class key, which is a useful narrowing for that probe.

## Mystery ledger

- **Why exactly 1.500 for two unrelated families?** `reliability-3of8` gives 9/6 and
  `wide-conjunction` gives 6/4. Both are a symmetric threshold whose top strata saturate, so the join
  folds exactly the saturating tail; the coincidence is the same mechanism at two sizes rather than
  anything deeper. Settled by the `ej` pass, no gate.
- **Two of 28 transpositions verify on distinct Fibonacci weights.** Settled: a threshold can be blind
  to a weight exchange when no attainable subtotal separates the two orderings, and the exhaustive
  verifier finds exactly those. This is why the orbit baseline is verified rather than declared.
- **The certificate costs 846x the refinement it certifies.** Open, and it is a core question rather
  than a lane one: the exhaustive pair audit on 33,024 states takes 1.516 s and 6.9 GB at 205,056
  states, while the split transcript does the same partition in 1.792 ms. Whether the audit is
  quadratic by necessity or by implementation is unexamined here. Owner: C1017.
  **[corrected]** — answered, and by both branches. The core repair note found the record set
  quadratic by definition (one record per separated same-sort pair, 7.9 million here) and the verifier
  and builder quadratic by implementation; removing the retained pair set and the doubling growth made
  verification `4.2x` faster and halved the audited compile's peak memory with the accepted
  certificates unchanged. The ratio is now about `320x` (`379.342 ms` against `1.186 ms` here), and
  the residual is the record set, for which the core already has non-retaining streaming entry points.
- **The compiled arm's 6.3x gap is entirely the lowering constant.** Open only in the sense that it
  could be shrunk — the lowering builds transition tables the memo does not need — but shrinking it
  cannot cross the structural bound, so no successor should spend time on it hoping to.
- No genuine mystery remains in the compression numbers; every family's residual is explained by a
  named mechanism.

## Where this leaves the probe

The kill criterion fired on its timing disjunct, and the plan should record that rather than soften
it. But the shape of the failure is specific and it is not "the decision layer is worthless":

- the query layer is exact, witness-carrying, and replayable, and it is now the substrate probe 6 and
  probe 9 were waiting on;
- quotienting the search graph is worth 220x against the same search on concrete states;
  **[corrected]** withdrawn and replaced. The arms were not memoized alike (`103x` like-for-like),
  and the rest was a representation difference: the concrete arm scanned all 256 generators at every
  settled state through a dense transition table while the compiled arm walked a 200-edge per-class
  adjacency. Given the same representation the concrete arm is only **`6.8x`** behind — so quotienting
  the search graph is worth single digits at query time here, not two orders of magnitude, and it is
  worth something rather than nothing. § "The strengthened concrete baseline" carries the measurement;
- refinement is cheap (1.792 ms) and the compression is large (22x to 84x on states);
- what loses is **materializing the flat carrier**, because doing so costs exactly what filling a
  complete memo costs.

The consequence for the task is a sharpening rather than a redirection. The compiled query wins where
the context space is too large to memoize and the carrier is never materialized — which is exactly
the compositional lowering along the DAG. Probe 1a promoted probe 7 from gated to expected on carrier
grounds; probe 2 now promotes it on decision-layer grounds independently. Probe 7 remains blocked
until its novelty argument against the variable-partition coarsening line is written, and that
argument is now the highest-value unblocked piece of writing in the task.

The second surviving direction is the one the plan already names: a **non-idempotent edit
vocabulary**. With hard interventions the intervention set is the state set, so one-shot enumeration
sees everything a search could see and the shortest path has no room to earn its keep. With shift,
soft, or policy edits the reachable set is a genuine word problem, enumeration becomes exponential in
word length, and Dijkstra over `Q` is polynomial in the class count. That is probe 8's remit and
probe 2 has now given it a measured reason to exist rather than a stylistic one.

**Carried forward.** The vocabulary quotient is empty for hard edits and should be re-measured under
a non-idempotent vocabulary rather than dropped. Probe 6's decision-equivalence key cannot be the
class key. The `ConcreteSearch` baseline arm uses a standard-library binary heap rather than the
core's indexed heap, which flatters the compiled arm by a small constant; the 220x is far outside
that, but a tighter comparison would use the same heap on both sides.

**[corrected]** the heap was the small caveat and the large one sat two lines above it in the same
routine. `ConcreteSearch` cleared two arrays of 33,024 entries on every query in order to walk a
reachable fibre of 129 states, and — the dominant cost — scanned all 256 generators at every settled
state through the presentation's dense `(generator, state)` table, of which about five apply. The
per-query clear is now bounded to what the query touched, which removed roughly a sixth of the arm's
per-query cost. The per-sort generator list — which does change what the baseline arm is rather than
correcting how it is measured — was predeclared and then applied, and it removed most of the rest;
§ "The strengthened concrete baseline" has the numbers. One asymmetry remains and is not fixed: the
concrete arm still uses a standard-library binary heap where the compiled side has the core's indexed
decrease-key heap, so the surviving `6.8x` is an upper bound on what the graph-size difference alone
is worth.

Two smaller repairs applied alongside it. `minimax_regret` used to write
`class_of(...).unwrap_or(u32::MAX)`, so an unresolvable class became a real quotient key that every
failing intervention would share, and all but the cheapest would be dropped from the minimax search;
with `class_of` now bounding its context argument that path is reachable, and it returns
`InterventionError::UnresolvedClass` instead of merging. And the compression report now prints both
credit ratios and the two arms' work counts.
