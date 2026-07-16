# C215 functional-cost API

**Lane:** `repairports`

**Status:** unpointed and pointed definition/search slices implemented.

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

## Validation

Guarded elaboration of `RepairPorts/FunctionalCost.lean` passes. The printed headline theorems use
only `propext`, `Classical.choice`, and `Quot.sound`; the source contains no `sorry`, `admit`, or
new axiom declaration.

The future `RepairPorts.lean` aggregate requires a new Lake library entry. Shared build
configuration is owned by `build-sys`, so this lane does not edit it unilaterally.

## Next step

Derive a fiberwise first-obstruction formula for `pointedNonembeddedCost`: separate the
zero-functional and nonzero outer-functional cases, express the latter through constrained inner
fiber costs, and prove equivalence to the exhaustive definition. This is the algorithmic reduction
needed before optimized decoding or examples.
