# C215 functional-cost API

**Lane:** `repairports`

**Status:** exact fully fiberwise formula and verified finite reference evaluator implemented.

## Result

`lean/RepairPorts/FunctionalCost.lean` packages the minimum Hamming cost of realizing an
outer-symbol functional through a fixed inner encoder. The API is independent of a particular
search procedure:

- `functionalFiberCost` is the canonical minimum cost of one functional fiber;
- `functionalTupleCost` is the additive cost of an outer functional tuple;
- both minima are attained, and every realization is bounded below by the corresponding cost;
- `HasWeightedFunctionalDualDistanceAtLeast` is characterized exactly by lower bounds on
  `functionalTupleCost`;
- `functionalFiberCostSearch` exhaustively searches a finite field, and
  `functionalFiberCostSearch_eq` proves that it computes the canonical cost.

This turns the C214 lower-bound predicate into a reusable invariant and supplies a verified
reference algorithm without building q=9 coordinates or Singer data into the definition.

The pointed extension uses `WithTop Nat` so an empty constrained witness set has cost `top`:

- `IsPointedNonembeddedWitness` isolates exactly the witnesses relevant at a coordinate;
- `pointedNonembeddedCost_eq_top_iff` proves that the cost is infinite exactly when no such
  witness exists;
- `hasPointedNonembeddedDualDistanceAtLeast_iff_le_pointedCost` identifies the existing pointed
  lower-bound predicate with comparison against the exact cost;
- `pointedNonembeddedCostSearch_eq` proves that finite exhaustive witness search computes it.

The first-obstruction reduction now avoids full block-word enumeration in the nonzero outer
functional sector:

- `pointedFunctionalFiberCost` is the infinity-valued minimum cost of representing a functional
  nontrivially at the distinguished inner coordinate;
- its `top`/emptiness equivalence, lower bound, and finite-cost attainment are kernel-checked;
- `pointedFunctionalTupleRealizationCost_eq` proves the exact additive formula: one constrained
  target-fiber cost plus the ordinary minimum costs of every off-target fiber;
- `nonzeroOuterPointedRealizationCost_eq_fiberCost` lifts the formula through the infimum over all
  nonzero outer functional-dual tuples.

The full pointed obstruction is now classified by functional stratum:

- `zeroFunctionalPointedNonembeddedCost` retains exactly the zero-functional witnesses that are
  nonzero at the target and are not the embedded one-block inner-dual word;
- a nonzero functional tuple is proved incapable of being embedded at the distinguished block;
- `pointedNonembeddedCost_eq_min_zero_nonzero` proves that the exact full pointed cost is the
  minimum of the zero-functional term and `nonzeroOuterPointedFiberCost`.

The zero sector is now closed as well. If another outer block exists and `dualCode I` is
nontrivial, its exact value is

```text
pointedFunctionalFiberCost I e x 0 + dualDist I.
```

Otherwise it is `top`; an empty pointed target fiber also makes the displayed sum `top`.
`zeroFunctionalPointedNonembeddedCost_eq_closed` proves all cases, and
`pointedNonembeddedCost_eq_min_closed_nonzero` substitutes the result into the full minimum. Thus
the complete target-conditioned first obstruction is expressed through independent inner-fiber
costs, the ordinary inner dual distance, and an infimum over nonzero outer functional-dual tuples.

The finite formula evaluator is now kernel-checked:

- `pointedFunctionalFiberCostSearch_eq` handles constrained inner fibers, including empty fibers;
- `pointedFunctionalTupleCostSearch_eq` evaluates the additive tuple formula;
- `nonzeroOuterPointedFiberCostSearch_eq` enumerates the finite nonzero outer functional-dual
  tuples;
- `pointedNonembeddedCostFormulaSearch_eq_fullSearch` proves equality with exhaustive pointed
  block-word search.

The two exposed finite domains have sizes `|F|^|κ|` for ambient inner blocks and at most
`|V*|^|ι|` for outer functional tuples, versus `|F|^(|ι| |κ|)` full block families. The
current Lean evaluator calls the fiber searches extensionally and does not implement a shared
memoized table, so these domain counts are not yet a runtime or asymptotic-complexity claim.

This is an exact decomposition, not a field-priority claim. The classical concatenated-dual fiber
structure remains prior art; the target-conditioned repair-obstruction use still requires a
dedicated literature audit before any novelty language.

## Validation

Guarded elaboration of `RepairPorts/FunctionalCost.lean` passes. The printed headline theorems use
only `propext`, `Classical.choice`, and `Quot.sound`; the source contains no `sorry`, `admit`, or
new axiom declaration.

The future `RepairPorts.lean` aggregate requires a new Lake library entry. Shared build
configuration is owned by `build-sys`, so this lane does not edit it unilaterally.

## Next step

Implement an actual cached table evaluator that traverses the inner ambient space once, records
ordinary and coordinate-pointed minima by functional class, and then scans the outer
functional-dual tuples. Prove it equal to the reference formula evaluator before making a measured
runtime claim. In parallel, begin the targeted prior-art audit before treating the pointed use as
a contribution.
