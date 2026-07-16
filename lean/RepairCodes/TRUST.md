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
8. `RepairCodes.TransferBoundary` gives nondegenerate `GF(3)` repetition/single-parity-check
   examples proving literal complete-repair-hypergraph inequality at each numerical boundary.
   The two headline counterexamples use only kernel `decide` for closed finite support facts and
   have the standard logical axiom profile.
9. `RepairCodes.TraceDual` proves the finite-separable trace-pairing bridge from ordinary
   extension-field dual distance to the coordinate-free functional-dual gate.
10. `RepairCodes.Q9ExtensionLift` proves the actual degree-four restricted-scalar lift, its
   `[19N,4K,>=8D]_9` parameters, a disjoint exhaustive coordinate-type partition with exact
   multiplicities `9N,9N,N`, exact mixed locality three/two, exact repair-row transfer, and
   helper-failure thresholds `6,11,12`.
11. `RepairCodes.Asymptotic` proves the analytic reduction, constructs concrete `GF(9) ⊆ GF(6561)`
    models, and derives the unbounded family with rate `2/19`, eventual relative distance greater
    than every fixed `c < 39/190`, and a bundled disjoint coordinate distribution containing exact
    multiplicities, mixed locality, repair rows, and helper-failure thresholds. The clean displayed
    corollary `1/5` remains explicit; equality at `39/190` is not claimed.

The transfer theorem uses the hypothesis `r+1 < 2*d(I^perp)`, not the stronger and false
requirement `d(I^perp)=r+1`.  This matters here: the full axis–twisted-cubic code has global dual
distance three because of its axis locality-two circuits, while radius-three transfer still follows
from `4 < 2*3`.
`RepairCodes.TransferBoundary` separately proves that equality at the inner boundary and lowering
the outer functional-dual threshold to `r+1` both fail for some nondegenerate codes. This is
uniform non-weakenability, not necessity for each fixed concatenation.

## Imported asymptotic boundary

The finite seed-and-lift theorem is conditional on properties of the supplied outer code:

- base-field dimension;
- symbol minimum distance;
- `HasFunctionalDualDistanceAtLeast` for the coordinate-free functional dual.

These are theorem arguments, not global axioms.  `hasFunctionalDualDistanceAtLeast_top` proves
that the gate is nonvacuous.  The trace-duality bridge is now kernel-proved.

The only nonformalized mathematics introduced as a global project axiom is Stichtenoth's deep self-dual TVZ-family theorem
(arXiv:math/0506264, Theorem 1.6(ii)), stated once in `RepairCodes/Imported.lean`.  The concrete
asymptotic corollary's axiom report contains exactly this import plus the standard logical axioms.

The PGL(2,9) orbit description of the ten-point axis is computational/literature provenance only.
It is not used by the formal construction, which defines the full projective axis directly.

The strict weighted example in `RepairCodes.WeightedStrictExample` takes the classical Singer
regular-action/disjoint-multiplier fact as an explicit theorem argument, not an axiom.  From that
argument Lean proves the generalized-SPC functional-dual description, exact functional support
distance five, weighted distance at least six, coordinate surjectivity, and literal completed-seed
radius-four repair-hypergraph transfer.  Lean also proves that the seed has twenty coordinate
classes, that unit realization cost is exactly membership in a nonzero scalar coordinate orbit,
and that dual distance three makes those orbits pairwise distinct.  Singer's theorem is cited in
the manuscript.

## Projectively completed seed

`FiniteGeom.ProjectiveAxisTwistedCubic` adds the projective cubic point at infinity and proves the
completed system has parameters `[2q+2,4,q]_q` over every finite characteristic-three field. Its
plane-section proof treats cubic infinity explicitly and proves that every nonzero plane containing
the axis meets the full cubic in exactly one point. `RepairCodes.ProjectiveAxisTwistedCubic` proves
that distinct columns are pairwise linearly independent and that the completed row code has exact
global dual distance three, witnessed by an explicit three-axis-point word.

`RepairCodes.ProjectiveAxisTwistedCubicInvariants` proves the exact complete inner repair
profiles. The generic code-derived chain in `FiniteGeom.Repair` proves that helpers in an
inclusion-minimal repair are linearly independent, so a `k`-row generator has at most `k` helpers
and its minimal repair clutter stabilizes at radius `k`. It also proves both directions of the
full-port local-primal correspondence: a transversal separates the target column from all
surviving columns, while every target-nonzero linear functional supplies a transversal. Applied to
the completed rank-four seed, radius four is the full minimal inner port, with exact uniform rows

- cubic coordinates: `(nu,tau)=((q-1)/2,q-1)`;
- axis coordinates: `(nu,tau)=((5q-3)/6,2q-3)`.

The matching upper bounds account for every minimal radius-four repair without assuming an
unproved five-circuit catalogue: every cubic-target edge consumes at least two cubic helpers, and
every axis-target edge has weighted cost at least one when cubic helpers have weight `1/3` and axis
helpers weight `1/2`. The target-avoiding section maxima are `q+2` and `4`, respectively. Monomial
transport relabels both complete bounded repair hypergraphs and their minimal clutters. All these
finite headlines have only the standard logical axiom profile. The candidate five-weight
distribution is not part of these proved repair-port theorems.

`RepairCodes.ProjectiveAxisTwistedCubicLift` proves completed q9 lift parameters
`[20N,4K,>=9D]_9`, exact coordinate multiplicities `10N` cubic and `10N` axis, exact locality
three/two, and exact radius-four rows `(nu,tau)=(4,8)` and `(7,15)`. The transfer assumes ordinary
outer dual distance at least six and identifies only the bounded radius-four hypergraphs with one
embedded inner block; it does not identify the lift's unbounded full repair port.

`RepairCodes.ProjectiveAxisTwistedCubicAsymptotic` applies the quarantined Stichtenoth import to
prove an unbounded q9 family with exact rate `1/10`, eventual relative distance greater than every
fixed `c<351/1600` (hence the clean eventual `1/5` bound), equal coordinate classes, exact mixed
locality, and the bounded radius-four rows. Its concrete family theorem adds only
`Imported.stichtenoth_selfDual_TVZ_6561` to the standard logical axioms.

`RepairCodes.OperationalCoefficients` retains the dual-word witness behind every repair edge and
proves its exact scalar recovery equation. It also kernel-checks closed coefficient formulas for
the axis-pair, cubic-infinity, and zero-sum cubic repairs, with every displayed coefficient
nonzero. A concrete column-rescaling theorem makes the trust boundary explicit: while the target
coefficient stays fixed, any prescribed nonzero helper coefficient can occur in a monomially
equivalent presentation of the same axis-pair support. These results certify a direct
one-symbol-per-helper scalar protocol; they do not claim minimum bandwidth or access under
subpacketization.

## Reproduction

From `lean/`:

```sh
choom -n 1000 -- nix develop --command lake build RepairCodes
```

The finite and asymptotic dated adversarial reviews are
`notes/2026-07-12-axis-twisted-cubic-adversarial-review.md` and
`notes/2026-07-13-repaircodes-asymptotic-adversarial-review.md`.
