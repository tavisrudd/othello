# RepairCodes trust boundary

This library uses the strict kernel-checking profile established in `lean/TRUST.md`:

- no `sorry`, `admit`, `native_decide`, `unsafe`, or code-generation trust;
- closed finite checks use kernel `decide` only;
- finite and algebraic headline declarations are audited with `#print axioms` and depend only on
  `propext`, `Classical.choice`, and `Quot.sound`;
- the asymptotic family headline depends additionally on exactly one quarantined literature axiom,
  `Imported.stichtenoth_selfDual_TVZ_6561`.

## Axis–twisted-cubic theorem chain

The finite q=9 and uniform characteristic-three results are machine checked end to end:

1. `FiniteGeom.AxisTwistedCubic` proves the point-system parameters
   `[2q+1,4,q-1]_q`.
2. `FiniteGeom.AxisTwistedCubicCircuits` classifies the small circuits and proves the unique
   three-cubic/one-axis completion.
3. `RepairCodes.AxisTwistedCubic` constructs the row code, proves exact locality two/three,
   proves global dual distance three, and identifies the complete bounded-radius repair
   hypergraphs from actual dual supports.
4. `FiniteGeom.ExplicitRainbowMatching` proves the consecutive-power rainbow perfect matching
   over every finite characteristic-three field. `RepairCodes.AxisTwistedCubicInvariants` proves
   the shifted-inverse completion identity, the exact cubic row `((q-1)/2,q-2)`, the uniform axis
   formulas, strict all-symbol `tau > nu`, and the exact cubic repair-edge count.
5. `RepairCodes.Q9Uniform` proves the `[19,4,8]_9` row table
   `(nu,tau)=(4,7),(6,12),(7,13)` and the exact `28`, `36+8`, and `36+12` repair counts.
6. `RepairCodes.Q9CircuitInventory` proves the exact `120`/`84` support inventory.
7. `RepairCodes.SeedLift` and `RepairCodes.Q9SeedLift` construct the concatenated code and prove
   its dimension and distance bound, equality of the complete repair hypergraph with the embedded
   inner hypergraph, generic preservation of every exact locality below the transfer radius,
   all-symbol locality, row invariants, and `7 nu <= 4 tau`.
8. `RepairCodes.TraceDual` proves the finite-separable trace-pairing bridge from ordinary
   extension-field dual distance to the coordinate-free functional-dual gate.
9. `RepairCodes.Q9ExtensionLift` proves the actual degree-four restricted-scalar lift, its
   `[19N,4K,>=8D]_9` parameters, a disjoint exhaustive coordinate-type partition with exact
   multiplicities `9N,9N,N`, exact mixed locality three/two, exact repair-row transfer, and
   helper-failure thresholds `6,11,12`.
10. `RepairCodes.Asymptotic` proves the analytic reduction, constructs concrete `GF(9) ⊆ GF(6561)`
    models, and derives the unbounded family with rate `2/19`, eventual relative distance greater
    than every fixed `c < 39/190`, and a bundled disjoint coordinate distribution containing exact
    multiplicities, mixed locality, repair rows, and helper-failure thresholds. The clean displayed
    corollary `1/5` remains explicit; equality at `39/190` is not claimed.

The transfer theorem uses the hypothesis `r+1 < 2*d(I^perp)`, not the stronger and false
requirement `d(I^perp)=r+1`.  This matters here: the full axis–twisted-cubic code has global dual
distance three because of its axis locality-two circuits, while radius-three transfer still follows
from `4 < 2*3`.

## Imported asymptotic boundary

The finite seed-and-lift theorem is conditional on properties of the supplied outer code:

- base-field dimension;
- symbol minimum distance;
- `HasFunctionalDualDistanceAtLeast` for the coordinate-free functional dual.

These are theorem arguments, not global axioms.  `hasFunctionalDualDistanceAtLeast_top` proves
that the gate is nonvacuous.  The trace-duality bridge is now kernel-proved.

The only nonformalized mathematics is Stichtenoth's deep self-dual TVZ-family theorem
(arXiv:math/0506264, Theorem 1.6(ii)), stated once in `RepairCodes/Imported.lean`.  The concrete
asymptotic corollary's axiom report contains exactly this import plus the standard logical axioms.

The PGL(2,9) orbit description of the ten-point axis is computational/literature provenance only.
It is not used by the formal construction, which defines the full projective axis directly.

## Reproduction

From `lean/`:

```sh
choom -n 1000 -- nix develop --command lake build RepairCodes
```

The finite and asymptotic dated adversarial reviews are
`notes/2026-07-12-axis-twisted-cubic-adversarial-review.md` and
`notes/2026-07-13-repaircodes-asymptotic-adversarial-review.md`.
