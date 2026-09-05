# C1062 probe 7: the compositional lowering, its exactness gate, and the families beyond the flat envelope

**Lane**: `complete-ports`
**Task**: C1062, probe 7
**Plan**: `2026-09-04-c1062-exploration-log.md`
**Unblocking argument**: `2026-09-04-c1062-probe7-novelty-argument.md`
**Inputs**: probe 1a for the carrier cost model, probe 1 for the flat lowering and its
direct-enumeration oracle, probe 2 for the baseline rule and the structural timing failure.
**Code**: `ergodis-private` `d57cb07` (`src/causal_composition.rs`, `src/causal_fixtures.rs`,
`tasks/tools/src/causal_composition_report.rs`)
**Replay**: `cargo run --release --package ergodis-tools -- causal-composition-report`
**Verdict**: the reduction is exact and it works at a scale the flat lowering cannot approach — a
model with `4.096 x 10^15` exogenous contexts reduces to 4,096, exactly, in 25.6 microseconds, and
the reduced model then compiles through the ordinary flat lowering at 102,400 states. The composed
*quotient* is not the coarsest one, and the reason is structural rather than a defect: anything
computed one coordinate at a time is a product partition, and the flat quotient need not be one.
Every coordinate of every fixture reaches the product ceiling, so the passes give up nothing beyond
that structural price.

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

## 3. Gates

**Gate 1: the predeclared verdict per family.** Every fixture's verdict was entered in
`compositional_fixtures()` before the run, and the prediction rule is mechanical rather than a guess:
exact when the flat partition is a product, strictly finer when it is not.

| fixture                      | contexts | composed | ceiling | flat | predicted      | agree |
|------------------------------|----------|----------|---------|------|----------------|-------|
| chain                        | 2        | 2        | 2       | 2    | exact          | yes   |
| fork                         | 3        | 3        | 3       | 3    | exact          | yes   |
| collider-disjunctive         | 4        | 4        | 4       | 4    | exact          | yes   |
| diamond-conjunctive          | 4        | 4        | 4       | 3    | strictly finer | yes   |
| wide-conjunction             | 16       | 16       | 16      | 16   | exact          | yes   |
| identity-predicted-loss      | 6        | 6        | 6       | 6    | exact          | yes   |
| response-function            | 60       | 32       | 32      | 32   | exact          | yes   |
| collapsing-chain             | 6        | 2        | 2       | 2    | exact          | yes   |
| saturating-count-5-symmetric | 7,776    | 32       | 32      | 32   | exact          | yes   |
| saturating-count-5-distinct  | 32,768   | 32       | 32      | 32   | exact          | yes   |
| shared-mechanism-parity      | 4        | 4        | 4       | 2    | strictly finer | yes   |
| saturating-count-5-sealed    | 7,776    | 32       | 32      | 4    | strictly finer | yes   |
| wide-conjunction-arity-1     | 16       | 16       | 16      | 6    | strictly finer | yes   |

Thirteen of thirteen predictions hold, and four are predicted losses. The Balke–Pearl
response-function gate that probe 1 uses for the flat lowering also passes here: 60 contexts to 32
classes, computed without materializing the 1,140-state carrier.

**The ceiling column never differs from the composed column.** On every coordinate of every fixture
the composed local partition equals the coarsest one any coordinate-wise construction could produce.
So the whole gap to the flat quotient is the product-partition price, and the three passes are not
leaving anything on the table on these families.

**Gate 2: the reduction preserves the flat partition, exhaustively.** For every fixture with at most
65,536 contexts, two contexts share a flat class exactly when their class representatives do.

| fixture                      | contexts | reduced | ratio    | partition kept |
|------------------------------|----------|---------|----------|----------------|
| response-function            | 60       | 32      | 1.88x    | yes            |
| collapsing-chain             | 6        | 2       | 3.00x    | yes            |
| saturating-count-5-symmetric | 7,776    | 32      | 243.00x  | yes            |
| saturating-count-5-distinct  | 32,768   | 32      | 1024.00x | yes            |
| saturating-count-5-sealed    | 7,776    | 32      | 243.00x  | yes            |

The remaining eight fixtures reduce by 1.00x and also keep the partition; they are models whose
exogenous alphabets carry no redundancy, and they are in the table so the ratio column is not read
as a selected set.

**Gate 3: separating-intervention witnesses for the losses.** Each predicted loss prints the pair it
splits and the flat quotient merges, so the incompleteness is exhibited rather than asserted:
diamond-conjunctive splits contexts 1 and 3, shared-mechanism-parity splits 1 and 2,
saturating-count-5-sealed splits 4 and 24, wide-conjunction-arity-1 splits 0 and 1.

**Gate 4: randomized exactness above the flat envelope.** On the twelve-source model there is no flat
arm, so exactness is checked directly: 200,000 sampled `(context, pin set)` pairs, seed
`0x5deece66d`, comparing the source model solved at `u` against the reduced model solved at
`class(u)`. All 200,000 agree. This is a check, not a proof; the proof is section 2 and the
exhaustive small-model gate.

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
- **The arity dial is not compositional.** Measured, not mysterious, but unresolved: the composed
  passes compute the full-arity rung, so the arity tower — which probe 1 shipped for the flat
  lowering and which is one of the two dials the whole task hands a user — has no compositional form.
  Owning successor: an arity-aware reachability pass, or a statement that the tower is only available
  inside the flat envelope.
- **The `u64` context index is now the binding limit, not memory.** At twenty sources over domain 20
  the compile succeeds and the arithmetic does not. This is a plain interface fact rather than a
  mystery, and it caps the scale claim at whatever fits `u64`; a digit-vector `solve_into` would lift
  it. Named, not fixed.
- **The composition finds no symmetry.** Predeclared and measured at 5.33x left on the table on the
  symmetric family. That is not a defect of these passes — orbits are a different partition — but it
  does mean the compositional route alone should never be presented as the whole compression story.
- **No genuine mystery remains in the exactness result itself.** The theorem, the exhaustive gate on
  small models, and the 200,000-sample randomized check at scale agree, and the four predicted losses
  all land where the product-partition statement says they must.

## 9. Next

Probe 8 (the unrolled sequential window) is the other surviving direction from probe 2's finding, and
it is unchanged by this probe. Within probe 7's own territory the ranked follow-ons are the
arity-aware pass, the digit-vector solve interface that lifts the `u64` context limit, and the
product-ceiling proposition. None of them blocks anything.
