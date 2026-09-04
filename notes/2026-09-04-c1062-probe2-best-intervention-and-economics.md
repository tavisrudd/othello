# C1062 probe 2: best intervention over the monoid action, and the economics that follow

**Lane**: `complete-ports`
**Task**: C1062, probe 2
**Plan**: `2026-09-04-c1062-exploration-log.md`
**Inputs**: probe 1a for the cost model, probe 1 for the lowering and its class oracle, probe 3 for
the actual-cause layer that feeds this one a minimal contingency.
**Code**: `ergodis-private` `17906d2` (library) and `4b2276a` (report tool)
**Replay**: `cargo test --release -p ergodis-private --lib best_intervention::` for the correctness
gates; `ergodis-tools best-intervention-report --rounds 5 --workloads 256,1024,4096,16384,65536`
for every table below. `rustc 1.93.1`, release profile, `choom -n 1000`, single thread.

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

## Predeclarations, entered before any measurement

Committed before the measuring code was written (`a6bd72e6a`, extended in the next commit to cover
two families added while building, still before any run).

### The two thresholds

1. **Timing.** The compiled arm must beat a **memoized** re-solve on the enumeration query, with the
   break-even query count reached within the number of distinct contexts.
2. **Compression.** Residual compression above the orbit baseline must exceed **1.5x** on at least
   one family whose verified automorphism group is trivial or near-trivial.

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

| family | contexts | pruned | verified/offered | orbits | classes | joint | residual |
|---|---|---|---|---|---|---|---|
| `reliability-3of8`      | 256 | 256 | 28/28 |   9 | 164 |  6 | 1.500 |
| `weighted-threshold-8`  | 256 | 256 |  2/28 | 144 |  44 | 29 | 4.966 |
| `distractor`            |  32 |   8 |  4/10 |   4 |   8 |  4 | 1.000 |
| `identity`              |  18 |  18 |   0/0 |  18 |  18 | 18 | 1.000 |
| `wide-conjunction`      |  32 |  32 | 10/10 |   6 |  17 |  4 | 1.500 |
| `restricted-vocabulary` | 256 | 256 | 13/28 |  24 |  24 | 12 | 2.000 |

**Every predeclared verdict landed.** The two predicted losses lost for exactly the predicted reason:
`distractor` is entirely explained by relevance pruning (32 contexts down to 8, residual 1.000), and
`identity` merges nothing because observing every variable leaves no sufficient summary. The two
predicted wins won, both above the 1.5x threshold: `weighted-threshold-8` at 4.966x and
`restricted-vocabulary` at 2.000x. `wide-conjunction` came in at exactly 1.500x, matching its
"partial" call. `reliability-3of8` lost as predicted but by a different mechanism than predicted,
which is the correction above.

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
- **`SplitTranscript` succeeded everywhere and agreed with the exhaustive pair audit class for class
  in every row.** It is the policy to use, and probe 2's timing arm does.

The failure is a fail-closed one: the verifier rejects a partition that is not a congruence, so no
wrong answer escapes. The lowering is not at fault — its range check passes, two independent policies
agree, and the audited compile agrees with an independent signature oracle. **Raising, not fixing**:
`~/src/ergodis` is C1017's active surface.

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
