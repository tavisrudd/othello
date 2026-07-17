# C215 functional-cost API

**Lane:** `repairports`

**Status:** exact pointed first-obstruction split implemented; zero-term closed form remains.

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

Derive the zero-sector closed form when another block exists and the inner dual is nontrivial: the
target-pointed inner-dual cost plus one off-target word of weight `dualDist I`. Prove the singleton
block, trivial-dual, and empty target-fiber cases as `top`, then replace the remaining direct
zero-sector search in the full minimum formula.
