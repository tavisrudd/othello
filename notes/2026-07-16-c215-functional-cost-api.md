# C215 functional-cost API

**Lane:** `repairports`

**Status:** initial definition and verified finite-search slice implemented.

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

## Validation

Guarded elaboration of `RepairPorts/FunctionalCost.lean` passes. The printed headline theorems use
only `propext`, `Classical.choice`, and `Quot.sound`; the source contains no `sorry`, `admit`, or
new axiom declaration.

The future `RepairPorts.lean` aggregate requires a new Lake library entry. Shared build
configuration is owned by `build-sys`, so this lane does not edit it unilaterally.

## Next step

Define the pointed functional-fiber cost with an honest infinity value for empty constrained
fibers, then derive a finite search and bridge it to the existing pointed nonembedded-witness
predicate. Do not encode emptiness as natural-number zero.
