# C634: square-root carrier formalization

**Lane:** `relconic`

**Date:** 2026-07-25

**Status:** implementation complete; dedicated gate build pending the shared
Lean build window.  The stable local and combinatorial core of C626's
square-root carrier theorem is formalized without enlarging the manuscript or
claiming that Lean checks the global Chow-product gluing argument.

## Mathematical scope

The formal target has three layers.

1. A linear jet on three carrier directions kills the conductor covariant
   whenever the directions satisfy their unique linear relation.
2. In characteristic two, the square of that covariant is the weighted sum of
   the second Hasse coefficients.
3. If every arc in a finite carrier set has size at most `k`, any deletion
   which leaves an arc removes at least `|X|-k` points.

The global statement that square restrictions of the dual Chow product glue
over a general-position line arrangement remains an analytic theorem unless a
short axiom-free implementation is supported by the pinned polynomial and
projectivization APIs.

## `ej`, degrees of freedom, and Tao stress pass

The useful upgrade is the normalization-conductor formulation.  At a point
where `s` carrier lines meet, pairwise equality of the canonical square roots
settles their common value but leaves
\[
 \binom{s-1}{2}
\]
local compatibility coordinates.  For `s=3`, the sole coordinate is the
first-jet covariant formalized here.  Higher multiplicity requires jets
through order `s-2`; pretending that pairwise values suffice would incorrectly
force the global Chow product to be a square.

The unexplained degrees of freedom are:

- the scalar representative of the Chow product, absorbed by perfectness;
- representatives of the carrier directions and their one linear relation;
- the local trivialization of the degree-`m` line bundle;
- the distribution of carrier-line multiplicities above three;
- the missing upper bound on the resulting conductor class; and
- in odd characteristic or odd arc size, the noncanonical removal of the
  residual tangent factor.

The zero or nonzero value of the first-jet covariant is unchanged by the first
three choices.  The fourth is genuine mathematical data.  The fifth is the
remaining route to a defect gap.  The sixth marks the current parity boundary.

The Tao-style check asks for the invariant object rather than a coordinate
formula.  It is the class of the tuple of canonical linewise square roots in
the conductor quotient of the normalization of the carrier-line arrangement.
Its square descends because it is the restriction of the global Chow product,
while the class itself need not vanish.  The local first-jet covariant is the
first coordinate of this Frobenius-killed obstruction.

## Acceptance gate

- dedicated Lean module elaborates through `lean/scripts/guarded-lean`;
- dedicated import-only gate elaborates and prints the axioms of every public
  terminal;
- all terminals use only the standard kernel trust boundary reported by
  `#print axioms`;
- the module-wide prose and naming audit passes; and
- the report distinguishes formalized statements from the analytic global
  carrier theorem.

## Formalized declarations

`RelativeConicArcs.SquareRootCarrier` proves:

- `carrierConductor_eq_zero_of_linearJet`: a common linear jet annihilates the
  weighted first-derivative conductor coordinate;
- `carrierConductor_eq_of_rescale`: simultaneous direction and relation
  rescaling leaves the coordinate unchanged;
- `carrierConductor_change_of_trivialization`: a common local change of
  trivialization scales the coordinate by its common scalar;
- `carrierConductor_change_of_trivialization_eq_zero_iff`: a change with
  nonzero common scalar preserves the coordinate's zero or nonzero status;
- `carrierConductor_sq` and `carrierConductor_sq_eq_hasse`: in characteristic
  two, the conductor square is the relation-weighted sum of the squared
  derivatives, hence of prescribed second Hasse coefficients;
- `localConductorCoordinateCount`: after the common-value equations at an
  ordinary `s`-fold point, exactly `choose (s-1) 2` conductor coordinates
  remain;
- `card_sub_le_of_sdiff_arc` and `card_le_card_add_of_sdiff_arc`: an arc bound
  on a finite carrier set gives the exact `|X|-k` deletion bound; and
- `card_le_card_mul_of_biUnion_cover`: the finite fiber-cover inequality which
  is the double-counting kernel behind the collinear-triple lower bound.

The dedicated gate
`RelativeConicArcs.Gates.SquareRootCarrier` imports the module and audits all
ten public terminals.

## Formal boundary

Lean checks the local conductor algebra, its representative and
trivialization invariance, the characteristic-two Frobenius identity, the
deletion implication, and the finite-cover counting kernel.

Lean does not yet check:

- the construction of the dual Chow product from an even projective arc;
- the equivalence between maximum secant index and square restriction;
- polynomial interpolation of the linewise roots in general position;
- the deduction that the maximum-centre set has arc number at most `k`; or
- the specialization of the finite-cover kernel to all `(k+1)`-subsets and
  their collinear triples.

Those remain the analytic inputs proved in the C626 report.  No axiom standing
for them is introduced.

## Validation

- `lean/scripts/guarded-lean RelativeConicArcs/SquareRootCarrier.lean`:
  **PASS**, warning-free.
- `RelativeConicArcs.SquareRootCarrier` through the guarded build queue:
  **PASS**, `5.81s`, maximum resident set size `1,394,312 KiB`.
- `lean/scripts/guarded-lean
  RelativeConicArcs/Gates/SquareRootCarrier.lean`: **PASS** for the
  nine-terminal version.
- A fresh source-local audit after the zero-invariance upgrade reports all ten
  terminals with exactly `propext`, `Classical.choice`, and `Quot.sound`.
- Whole-module prose and naming audit: **PASS**.  The source and gate contain
  no workflow identifiers, internal-record references, status language, or
  unqualified formalization claims.
- Re-elaboration of the ten-terminal gate, exact-target gate build, and
  `--no-build` confirmation: pending release of
  the shared Lean build-owner lock.  The first aggregate attempt correctly
  failed closed because the new gate itself had not yet been built.
