# C1062 probe 7: the compositional lowering, its exactness gate, and the families beyond the flat envelope

**Lane**: `complete-ports`
**Task**: C1062, probe 7
**Plan**: `2026-09-04-c1062-exploration-log.md`
**Unblocking argument**: `2026-09-04-c1062-probe7-novelty-argument.md`
**Inputs**: probe 1a for the carrier cost model, probe 1 for the flat lowering and its
direct-enumeration oracle, probe 2 for the baseline rule and the structural timing failure.
**Code**: `ergodis-private` `d57cb07` (`src/causal_composition.rs`, `src/causal_fixtures.rs`,
`tasks/tools/src/causal_composition_report.rs`)
**Replay**: `cd ~/src/ergodis-private && cargo run --release --package ergodis-tools --
causal-composition-report`
**Evidence**: `ergodis-private` `evidence/2026-09-05-causal-composition-repaired.txt`, the output of
that command after the review repairs. No evidence was retained when this report was written.
**Reviewed**: `2026-09-05-c1062-probe7-review.md`. Corrections from that review are marked
**[corrected]** below and the original text is kept wherever it explains how a number was reached.
**Verdict**: the reduction is exact and it works at a scale the flat lowering cannot approach — a
model with `4.096 x 10^15` exogenous contexts reduces to 4,096, exactly, in 25.6 microseconds, and
the reduced model then compiles through the ordinary flat lowering at 102,400 states. The composed
*quotient* is not the coarsest one, and the reason is structural rather than a defect: anything
computed one coordinate at a time is a product partition, and the flat quotient need not be one.
Every coordinate of every fixture reaches the product ceiling, so the passes give up nothing beyond
that structural price.

**[corrected]**, three items in the verdict.

- The `4.096 x 10^15` to 4,096 figure is a **reduction the fixture declares**, not one the passes
  discover: each source has an exogenous domain of twenty and a threshold mechanism, so its local
  partition has two blocks by construction and the ratio is `(20 / 2)^12 = 10^12`. What was measured
  is that the three passes run to completion on a model whose flat carrier is nine to ten orders of
  magnitude past probe 1a's envelope, and that the reduced model compiles with its class vector
  matching the direct-enumeration oracle exactly. That is the result; the ratio is a dial.
- The 25.6 microseconds is real work, and its input is the mechanism tables rather than the context
  space: nothing in `compile` or `reduce` enumerates contexts, and the cost is linear in the total
  table size and independent of the context count. Putting the two numbers in one sentence invites a
  reading — `4 x 10^15` things processed in 25.6 µs — that is not what happened. It is also a single
  un-repeated sample; replays on the same host give 24.8, 27.5 and 69.7 microseconds.
- "Every coordinate of every fixture reaches the product ceiling" was true of the thirteen fixtures
  this report measured and is **false in general**. The review constructed a four-context
  counterexample, now committed as the `mutually-exclusive-mask` fixture, on which the composed
  quotient is 4 and the ceiling is 2. See the corrections to § 2 and § 8.

## 1. What was built

`ergodis-private/src/causal_composition.rs`, a tier-1 library module, plus
`src/causal_fixtures.rs`, which now holds the shared models so that the flat report and this one
read the same seven fixtures rather than two copies.

`CompositionalReduction::compile` runs three passes over the mechanism tables and never enumerates
`Val(U)`.

1. **Forward reachability.** Per endogenous variable, which values it can take under some admissible
   pin set: the whole domain when the variable is intervenable, otherwise the mechanism's image over
   reachable parents. Parent correlations are ignored, so this over-approximates; an
   over-approximation only ever adds distinctions, which is what keeps everything downstream sound.
2. **Backward observability.** Per endogenous variable `V`, a partition `Pi_V` of its *domain*: the
   coarsest partition, uniform over the configurations of a child's other parents, that every child's
   mechanism carries into the child's own partition. `Pi_V` is discrete at an observed variable. This
   is how a restricted observation set coarsens compositionally instead of by re-enumeration.
3. **Local exogenous classes.** Per exogenous variable `U_j`, a partition of its domain: two values
   are equivalent when, for every endogenous child and every configuration of that child's other
   parents, the mechanism's output lands in the same `Pi` block. Factoring on the *exogenous* side is
   what makes a shared exogenous parent correct by construction rather than by a side condition —
   probe 0's clause about an exogenous variable feeding several endogenous ones is satisfied without
   a special case.

`reduce` turns those local classes into a model: the same endogenous variables, mechanisms,
observation set, intervenable set and arity bound, over an exogenous alphabet of `m_j` values per
variable, with each mechanism table rewritten at the class representatives. `class_of_digits`,
`class_of_context` and `class_index` write into a caller-owned buffer and allocate nothing, so a
query loop reuses one buffer.

**The variable set is never partitioned**, as the novelty argument requires. `Pi_V` partitions one
variable's values, which coarsens the observation channel; no macro-variable is constructed.

## 2. The two statements the code rests on

**Exactness of the reduction.** For every pin set `I` and every context `u`,
`O(M_I(u)) = O(M'_I(class(u)))`. A mechanism's output stays inside its `Pi` block when one exogenous
coordinate moves inside its local class (the local pass's definition) or when one endogenous parent
moves inside its own `Pi` block (the backward pass's definition), and both conditions are quantified
over configuration sets that contain every intermediate point of a coordinate-by-coordinate swap.
Chaining along the topological order carries block equality to every variable, and `Pi` is discrete
at an observed one. Pinning only removes dependence, so neither the arity bound nor the declared
intervenable set weakens this. **The reduction is therefore exact for every observation set, every
intervenable set and every arity.**

**The product ceiling.** The composed quotient is a product partition of the exogenous coordinates,
because it is computed one coordinate at a time. Define the coarsest product partition refining the
flat quotient: per coordinate, two values are equivalent when swapping one for the other never
changes the flat class, for any setting of the other coordinates. Its product refines the flat
quotient by swapping one coordinate at a time, and every product partition refining the flat
quotient is contained in it. So `composed <= ceiling <= flat` as partitions, and the middle term
separates *the price of factoring* from *a defect in the three passes*. The report measures both
gaps rather than only the outer one.

This replaces a weaker hypothesis I had entered before running: "at most one exogenous parent per
mechanism, every endogenous variable intervenable, arity not binding". The diamond fixture satisfies
all three and is still strictly finer, because `V3 = AND(V1, OR(V0, u1))` reduces to `u1`, so `u0`'s
effect is masked exactly when `u1 = 1`. Masking is a context-dependent phenomenon and no
coordinate-wise construction can see it. The product-partition statement is the correct one and it
predicts every row.

**[corrected]** The ceiling is an upper bound the passes reach contingently, not always. The
inequality `composed <= ceiling <= flat` holds unconditionally and is what the code now asserts —
coordinate by coordinate, `refines(local_j, ceiling_j)` — but equality between the composed quotient
and the ceiling does not. The mechanism is the forward pass's own over-approximation, described in
§ 1: reachability is recorded per variable and every later quantification ranges over the *product*
of those sets, so two endogenous variables that can each take the value one and never do so together
are still enumerated at `(1, 1)`. A mechanism reading an exogenous variable only at that impossible
configuration is split by the local pass and merged by the flat quotient. The `mutually-exclusive-mask`
fixture is exactly that, at four contexts: composed 4, ceiling 2, flat 2, still sound. So the sentence
"the middle term separates *the price of factoring* from *a defect in the three passes*" is right as
a decomposition, and this report measured the second term at zero on its own families rather than
establishing that it is always zero. The same correlation problem blocks the arity dial in § 6, so
the two open items in § 8 are one problem.

## 3. Gates

**Gate 1: the predeclared verdict per family.** Every fixture's verdict was entered in
`compositional_fixtures()` before the run, and the prediction rule is mechanical rather than a guess:
exact when the flat partition is a product, strictly finer when it is not.

| fixture                      | contexts | composed | ceiling | at ceiling | flat | predicted      | agree |
|------------------------------|----------|----------|---------|------------|------|----------------|-------|
| chain                        | 2        | 2        | 2       | 1/1        | 2    | exact          | yes   |
| fork                         | 3        | 3        | 3       | 1/1        | 3    | exact          | yes   |
| collider-disjunctive         | 4        | 4        | 4       | 2/2        | 4    | exact          | yes   |
| diamond-conjunctive          | 4        | 4        | 4       | 2/2        | 3    | strictly finer | yes   |
| wide-conjunction             | 16       | 16       | 16      | 4/4        | 16   | exact          | yes   |
| identity-predicted-loss      | 6        | 6        | 6       | 2/2        | 6    | exact          | yes   |
| response-function            | 60       | 32       | 32      | 3/3        | 32   | exact          | yes   |
| collapsing-chain             | 6        | 2        | 2       | 1/1        | 2    | exact          | yes   |
| saturating-count-5-symmetric | 7,776    | 32       | 32      | 5/5        | 32   | exact          | yes   |
| saturating-count-5-distinct  | 32,768   | 32       | 32      | 5/5        | 32   | exact          | yes   |
| shared-mechanism-parity      | 4        | 4        | 4       | 2/2        | 2    | strictly finer | yes   |
| saturating-count-5-sealed    | 7,776    | 32       | 32      | 5/5        | 4    | strictly finer | yes   |
| wide-conjunction-arity-1     | 16       | 16       | 16      | 4/4        | 6    | strictly finer | yes   |
| mutually-exclusive-mask      | 4        | 4        | 2       | 1/2        | 2    | strictly finer | yes   |
| shared-source-merging        | 6        | 4        | 4       | 1/1        | 4    | exact          | yes   |

**[corrected]** The table gains an `at ceiling` column and the last two rows, both added by the
review; every row's `predicted` and `agree` value is unchanged. `at ceiling` counts the coordinates
whose composed local partition equals the ceiling's, and it is `1/2` on `mutually-exclusive-mask`,
which is the fixture that makes the equality contingent. `shared-source-merging` is the one shape the
original thirteen did not cover: an exogenous variable with two endogenous children whose local class
actually merges, so the joint-tuple-across-children construction is exercised where a per-child
mistake would show. In `fork` and `diamond-conjunctive`, the only other fixtures with a multi-child
exogenous parent, that variable's local partition is discrete and nothing merges.

Fifteen of fifteen predictions hold, and five are predicted losses. The Balke–Pearl
response-function gate that probe 1 uses for the flat lowering also passes here: 60 contexts to 32
classes, computed without materializing the 1,140-state carrier.

**[corrected]** on how much that count is worth. Six of the original thirteen verdicts were not
entered per family: `compositional_fixtures()` assigns them from a `_ => Exact` wildcard over probe
1's fixture list, so a later probe 1 fixture would inherit a prediction nobody made. The two rows
added by the review carry their verdicts explicitly. The prediction rule itself — "exact when the flat
partition is a product" — also cannot be applied without first computing the flat partition, so
applying it is a hand-computation of the answer rather than a prediction; and the verdicts, the code
and the measurement all landed in one commit (`d57cb07`), so nothing on disk separates entry from
result. What the gate genuinely establishes is that the implementation agrees with a hand-computed
product-partition analysis on fifteen families, which is worth having and is not what "predeclared"
promises.

**The ceiling column never differs from the composed column.** On every coordinate of every fixture
the composed local partition equals the coarsest one any coordinate-wise construction could produce.
So the whole gap to the flat quotient is the product-partition price, and the three passes are not
leaving anything on the table on these families.

**[corrected]** That was true of the thirteen fixtures as they stood and is now false of the
fixture list: `mutually-exclusive-mask` reaches one of its two coordinates' ceilings. The sentence
that survives is the last clause — on the families where the ceiling is reached, the whole gap is the
product-partition price — and the general statement it was standing in for does not hold.

**[corrected]** the fourth predicted loss is not a fourth non-product shape. Three of the five losses
are genuinely non-product flat partitions with distinct causes: masking (`diamond-conjunctive`), two
exogenous parents on one mechanism (`shared-mechanism-parity`), and sources not intervenable
(`saturating-count-5-sealed`); the fifth is the review's correlated-parents fixture. But
`wide-conjunction-arity-1` is an **arity-rung mismatch**, not a shape: the passes compute the
full-arity rung and the fixture declares arity one, and at full arity the composed quotient equals the
flat quotient exactly at 16. Recomputing the flat quotient at full arity on every fixture gives an
identical partition to the declared-arity one on twelve of the original thirteen, the sole exception
being that family. So no comparison in this table silently mixes rungs, and the one row where the
rungs differ is a limitation of § 6 rather than an instance of the product-partition phenomenon.

**Gate 2: the reduction preserves the flat partition, exhaustively.** For every fixture with at most
65,536 contexts, two contexts share a flat class exactly when their class representatives do.

| fixture                      | contexts | reduced | ratio    | partition kept |
|------------------------------|----------|---------|----------|----------------|
| response-function            | 60       | 32      | 1.88x    | yes            |
| collapsing-chain             | 6        | 2       | 3.00x    | yes            |
| saturating-count-5-symmetric | 7,776    | 32      | 243.00x  | yes            |
| saturating-count-5-distinct  | 32,768   | 32      | 1024.00x | yes            |
| saturating-count-5-sealed    | 7,776    | 32      | 243.00x  | yes            |
| shared-source-merging        | 6        | 4       | 1.50x    | yes            |

The remaining eight fixtures reduce by 1.00x and also keep the partition; they are models whose
exogenous alphabets carry no redundancy, and they are in the table so the ratio column is not read
as a selected set.

**[corrected]** on which gate carries the exactness claim. The `1.00x` rows cannot fail: a fixture
that reduces by `1.00x` has every exogenous class a singleton, so each value is its own
representative, `reduce` rebuilds an identical model, and "partition kept" is a tautology there.
Of the rows that do reduce, three are the same `saturating_count` shape at different symmetry and
intervenability settings, so this table covers four distinct shapes — the Balke–Pearl response
function, a collapsing chain, a saturating count, and now the review's shared-source model.

The gate that actually carries exactness is elsewhere and is stronger: the unconditional
`ensure!(refines(&composed, &flat))` that runs on **every** fixture before anything else in Gate 1.
Every composed class lies inside a flat class, and each context's representative is in its own
composed class by construction, so that assertion says precisely that `u` and `class(u)` have
identical signatures under every admissible pin set — which is `O(M_I(u)) = O(M'_I(class(u)))`. The
exhaustive exactness evidence is fifteen fixtures, not five. What neither gate checks is observation
*values* as against the partition they induce: `signature_classes` labels by first appearance, so
both compare partitions, and value equality follows from `reduce` reusing the source tables verbatim
at the representatives rather than being asserted anywhere on the small fixtures.

**Gate 3: separating-intervention witnesses for the losses.** Each predicted loss prints the pair it
splits and the flat quotient merges, so the incompleteness is exhibited rather than asserted:
diamond-conjunctive splits contexts 1 and 3, shared-mechanism-parity splits 1 and 2,
saturating-count-5-sealed splits 4 and 24, wide-conjunction-arity-1 splits 0 and 1.

**Gate 4: randomized exactness above the flat envelope.** On the twelve-source model there is no flat
arm, so exactness is checked directly: 200,000 sampled `(context, pin set)` pairs, seed
`0x5deece66d`, comparing the source model solved at `u` against the reduced model solved at
`class(u)`. All 200,000 agree. This is a check, not a proof; the proof is section 2 and the
exhaustive small-model gate.

**[corrected]** on what that check can reach. The sampling itself has no hole — the context is
uniform over the full `4.096 x 10^15` range and the pin draw covers the empty set and every single
pin, which is the whole admissible vocabulary at arity one. The model is the limitation. On
`beyond_flat_envelope(12, 20)` each exogenous variable feeds exactly one endogenous variable, that
variable is a threshold so its local partition is exactly `{below, at-or-above}`, and the observation
is the saturating count of the fired thresholds — so the observation is a function of the composed
class *by construction of the fixture*. Nothing there could disagree unless the digit packing, the
representative selection or the table rewrite were broken. The 200,000 samples are therefore a
plumbing check at scale, which is the only thing testable above the envelope and is worth having;
they cannot reach any situation in which the theorem has content — a shared exogenous parent with
several children, a non-discrete `Pi_V` on a variable with more than one child, masking, or the
correlated-reachability gap of the § 2 correction — all of which live only in the small fixtures.
So section 8's "the theorem, the exhaustive gate on small models, and the 200,000-sample randomized
check at scale agree" should not be read as three independent confirmations; the weight sits on the
theorem and on the fifteen-fixture soundness assertion.

## 4. Beyond the flat envelope

Twelve thresholded sources over an exogenous domain of 20, feeding a saturating count, observing only
the count, arity 1.

| quantity                                   | value                              |
|--------------------------------------------|------------------------------------|
| source contexts                            | 4,096,000,000,000,000              |
| composed classes                           | 4,096                              |
| local class counts                         | 2 per source, twelve of them       |
| flat carrier over the source alphabet      | 102,400,000,000,000,000 states     |
| flat carrier over the reduced alphabet     | 102,400 states, 1,179,648 bytes    |
| reduction ratio                            | `1.000e12x` on contexts and on carrier states |
| compile and reduce, wall clock             | 25.588 microseconds                |
| compiled reduced model                     | 300 classes, agreeing with the direct oracle |

Probe 1a's flat envelope is about `1.2 x 10^7` carrier states. The source carrier here is
`1.024 x 10^17`, ten orders of magnitude past it; the reduced carrier is 102,400, which the flat
lowering compiles in the ordinary way, and its 300 classes agree with the independent
direct-enumeration oracle. **This is the pipeline the probe existed to build**: reduce exactly on the
factored side, then run the flat compiler on the reduced model.

One row further out, twenty sources over domain 20: `1.048576 x 10^26` source contexts to 524,288
composed classes. The source context index exceeds `u64`, so only the compile is available there —
`class_of_context` and `solve_into` both take a packed `u64` context, which is now the binding limit
rather than memory.

**[corrected]** That row no longer exists, and its disappearance is the finding rather than a loss.
The probe 1 review's repair made `CausalModel::new` **refuse** an exogenous alphabet whose product
overflows `u64` (`CausalError::ExogenousOverflow`) instead of saturating silently, so the
twenty-source model cannot be constructed at all; the report tool now prints the refusal —
`refused: the exogenous alphabet overflows u64 at variable 14` — and, in its place, the widest
alphabet the constructor still admits:

| quantity                     | value                              |
|------------------------------|------------------------------------|
| 14 sources, domain 20        | `1,638,400,000,000,000,000` source contexts to `16,384` composed classes |

The `u64` context index is therefore enforced now rather than merely observed, which is what the
mystery-ledger item asked for. The headline twelve-source row is unaffected: `20^12` is well inside
`u64` and it is only the row past it that the cap removes.

**An incidental finding worth its line.** That row gives `2^19`, not `2^20`, because the twentieth
source has threshold 20 on a domain of 20 and can therefore never fire. The local pass gives it one
class and the reduction deletes it. Ancestor-based relevance pruning, which probe 1 put into the flat
lowering, keeps that source: it *is* an ancestor of the observation. **The local pass subsumes
relevance pruning and strictly extends it**, from "not an ancestor" to "has no effect", and it does so
without a separate analysis.

## 5. The baselines, per the probe 2 rule

On `saturating-count-5-symmetric`, the one family with a real automorphism group — five
interchangeable sources — so that symmetry is never credited to the composition.

| baseline                          | classes |
|-----------------------------------|---------|
| contexts                          | 7,776   |
| contexts after relevance pruning   | 7,776   |
| orbits of the declared symmetry   | 252     |
| composed classes                  | 32      |
| flat classes                      | 32      |
| join of composed with the orbits  | 6       |

Relevance pruning buys nothing here; every source is an ancestor. The composition's own credit is
243x, from 7,776 contexts to 32 classes, and it is not symmetry credit: the composed partition is
finer than the orbit partition in some places and coarser in others, and their join is 6. The 5.33x
from 32 down to 6 is compression the composition does **not** find, and an orbit layer would. This
agrees with probe 2's correction that symmetry orbits and the compiled quotient are separate axes
whose credit is taken against their join.

## 6. What was rejected, and why

**`ergodis::composition`.** The exploration log named it as the vehicle for composing along the DAG.
It is not one: `CompositionTable` and `CostTable` are a min-plus algebra over matrix-labelled costs,
built for the recovery-cost composition, and there is no cost semiring in this problem — the object
being composed is a partition, not a cost. Forcing it would have meant encoding partitions as costs.
The three passes are a hundred lines and read as what they are. The C1061 retained-tree machinery is
likewise a witness-tree replayer for cost composition and has no role here.

**Arity as a count.** The composed passes use the intervenable *set* but not the arity *count*, so
they compute the rung at full arity. This is sound at every arity — pinning only removes dependence —
and it is exactly why `wide-conjunction-arity-1` is a predicted loss: the flat quotient at arity one
has 6 classes and the composed quotient has 16. An arity-aware compositional pass would have to track
which parent configurations a bounded number of simultaneous pins can actually reach, which is a
correlation problem, and it is left open.

## 7. The three sentences the novelty argument required

1. The carrier is the exogenous space held factored over exogenous variables. `RePaRe`
   (Madaleno, Misra and Markham, arXiv:2601.10531) partitions the variable set. Neither answer is a
   coarsening of the other, and this probe declines the pivot onto their carrier rather than arguing
   against it.
2. The factored partition-refinement technique is imported from the model-minimization line
   descending from Givan, Dean and Greig (*Artificial Intelligence* 147, 2003), not invented here.
   What is claimed is the object — the exact reduction of the exogenous alphabet of a known finite
   structural causal model under a declared observation set and intervention vocabulary — together
   with the two declared dials, the witness pairs, and exactness against a learned alternative.
   **[corrected]** two items in that list of claims. It is **one** declared dial, not two: the
   observation set is compositional — that is what the backward pass computes — and the arity bound
   is not implemented at all (§ 6), so the arity tower has no compositional form and the novelty
   argument's § 3 ingredient 3 promised something this probe did not build. And the witness pairs are
   not the witness the novelty argument asked for: `refinement_witness` returns a pair of *contexts*
   that the composed quotient splits and the flat quotient merges, which exhibits this probe's own
   incompleteness, whereas the difference claimed against `RePaRe` is a separating *intervention word*,
   decoded and replayable against the model. The novelty argument gave two permitted outcomes — carry
   it through the factorization, or say that it did not — and this report should say that it did not.
3. Variable merging is out of scope on purpose. The "hundred thousand variables become a fifty-state
   machine" line is retired. What this probe measured instead is that
   `4.096 x 10^15` exogenous contexts fall into 4,096 classes, exactly, in 25.6 microseconds, and the
   reduced model then compiles to 300 observational classes.

## 8. Mystery ledger

- **Why does the composed quotient reach the product ceiling on every coordinate of every fixture?**
  Settled as far as the evidence goes, not proved. The construction is uniform over configurations
  and the ceiling is defined per coordinate over the same configurations, so the two coincide
  whenever the flat quotient's per-coordinate structure is itself uniform. A fixture where the passes
  fall strictly short of the ceiling would need a *non-uniform* per-coordinate effect that still
  produces a coordinate-wise partition, and I could not construct one. **Open, with a named gate**: a
  proof that the composed local partition always equals the coarsest product refinement, or a
  counterexample. Either would be a real result and neither is needed for the reduction's exactness.
  **[corrected] — closed in the negative.** The review supplied the counterexample and it is now the
  `mutually-exclusive-mask` fixture: four contexts, composed 4, ceiling 2, flat 2. The guess about
  what such a fixture would need was wrong. It does not need a non-uniform per-coordinate effect; it
  needs **correlated endogenous parents** plus a mechanism that reads an exogenous variable only where
  the correlation forbids. `V0` and `V1` can each be one and never together, the forward pass records
  reachability per variable so `(1, 1)` is enumerated anyway, and `V2 = V0 AND V1 AND u1` therefore
  splits `u1` while the flat quotient merges it. The successor question is narrower and worth stating:
  does the composed local partition equal the ceiling whenever every product of per-variable reachable
  values is actually realized under some context and admissible pin set? A joint-configuration
  reachability pass would close the gap and is the same correlation problem the arity dial needs, so
  the next item and this one are one piece of work.
- **The arity dial is not compositional.** Measured, not mysterious, but unresolved: the composed
  passes compute the full-arity rung, so the arity tower — which probe 1 shipped for the flat
  lowering and which is one of the two dials the whole task hands a user — has no compositional form.
  Owning successor: an arity-aware reachability pass, or a statement that the tower is only available
  inside the flat envelope.
- **The `u64` context index is now the binding limit, not memory.** At twenty sources over domain 20
  the compile succeeds and the arithmetic does not. This is a plain interface fact rather than a
  mystery, and it caps the scale claim at whatever fits `u64`; a digit-vector `solve_into` would lift
  it. Named, not fixed. **[corrected] — now enforced.** `CausalModel::new` refuses such an alphabet
  rather than saturating, so the twenty-source model cannot be built and the compile no longer
  succeeds either; the widest admissible row is fourteen sources at `1.6384 x 10^18` contexts. A
  digit-vector `solve_into` remains the lift.
- **The composition finds no symmetry.** Predeclared and measured at 5.33x left on the table on the
  symmetric family. That is not a defect of these passes — orbits are a different partition — but it
  does mean the compositional route alone should never be presented as the whole compression story.
- **No genuine mystery remains in the exactness result itself.** The theorem, the exhaustive gate on
  small models, and the 200,000-sample randomized check at scale agree, and the four predicted losses
  all land where the product-partition statement says they must. **[corrected]** The exactness result
  stands and the review re-derived every fixture independently, but this sentence overstates its
  support in two ways. The three items are not independent confirmations: the randomized check is a
  plumbing check on a model where exactness is forced by construction (Gate 4 correction), so the
  weight sits on the theorem and on the fifteen-fixture soundness assertion. And one of the losses,
  `wide-conjunction-arity-1`, lands where the *arity* limitation of § 6 says it must rather than where
  the product-partition statement does.

## 9. Next

Probe 8 (the unrolled sequential window) is the other surviving direction from probe 2's finding, and
it is unchanged by this probe. Within probe 7's own territory the ranked follow-ons are the
arity-aware pass, the digit-vector solve interface that lifts the `u64` context limit, and the
product-ceiling proposition. None of them blocks anything.
