# RepairCodes trust boundary

This library uses the strict kernel-checking profile established in `lean/TRUST.md`:

- no `sorry`, `admit`, project axioms, `native_decide`, `unsafe`, or code-generation trust;
- closed finite checks use kernel `decide` only;
- headline declarations are audited with `#print axioms` and depend only on
  `propext`, `Classical.choice`, and `Quot.sound`.

## Axis–twisted-cubic theorem chain

The finite q=9 and uniform characteristic-three results are machine checked end to end:

1. `FiniteGeom.AxisTwistedCubic` proves the point-system parameters
   `[2q+1,4,q-1]_q`.
2. `FiniteGeom.AxisTwistedCubicCircuits` classifies the small circuits and proves the unique
   three-cubic/one-axis completion.
3. `RepairCodes.AxisTwistedCubic` constructs the row code, proves exact locality two/three,
   proves global dual distance three, and identifies the complete bounded-radius repair
   hypergraphs from actual dual supports.
4. `RepairCodes.AxisTwistedCubicInvariants` proves the uniform matching/transversal formulas,
   strict all-symbol `tau > nu`, and the exact cubic repair-edge count.
5. `RepairCodes.Q9Uniform` proves the `[19,4,8]_9` row table
   `(nu,tau)=(4,7),(6,12),(7,13)` and the exact `28`, `36+8`, and `36+12` repair counts.
6. `RepairCodes.Q9CircuitInventory` proves the exact `120`/`84` support inventory.
7. `RepairCodes.SeedLift` and `RepairCodes.Q9SeedLift` construct the concatenated code and prove
   its dimension and distance bound, equality of the complete repair hypergraph with the embedded
   inner hypergraph, all-symbol locality, row invariants, and `7 nu <= 4 tau`.

The transfer theorem uses the sharp hypothesis `r+1 < 2*d(I^perp)`, not the stronger and false
requirement `d(I^perp)=r+1`.  This matters here: the full axis–twisted-cubic code has global dual
distance three because of its axis locality-two circuits, while radius-three transfer still follows
from `4 < 2*3`.

## Explicit hypotheses and nonformalized inputs

The finite seed-and-lift theorem is conditional on properties of the supplied outer code:

- base-field dimension;
- symbol minimum distance;
- `HasFunctionalDualDistanceAtLeast` for the coordinate-free functional dual.

These are theorem arguments, not global axioms.  `hasFunctionalDualDistanceAtLeast_top` proves
that the gate is nonvacuous.  The standard trace-duality bridge from a conventional
extension-field-linear outer dual to this functional-dual formulation, and the existence of an
asymptotically good outer family satisfying the resulting gate, are prose/literature inputs and
are not claimed as Lean theorems.

The PGL(2,9) orbit description of the ten-point axis is computational/literature provenance only.
It is not used by the formal construction, which defines the full projective axis directly.

## Reproduction

From `lean/`:

```sh
choom -n 1000 -- nix develop --command lake build RepairCodes
```

The dated adversarial review is
`notes/2026-07-12-axis-twisted-cubic-adversarial-review.md`.
