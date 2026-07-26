# C634: square-root carrier formalization

**Lane:** `relconic`

**Date:** 2026-07-25

**Status:** implementation now includes polynomial restriction and
Frobenius descent, binary-factor proportionality, projective-representative
invariance of square status, quotient-lift corrections and their finite
interpolation, line-product detection, product nonsquareness, and the conditional
carrier-cardinality theorem, together with the exact-threshold residue
identity.  Dedicated gate builds remain
pending the shared Lean build window.  The manuscript is unchanged, and the
formal boundary below isolates the projective inputs which Lean does not yet
check.

## Mathematical scope

The formal target has three layers.

1. A linear jet on three carrier directions kills the conductor covariant
   whenever the directions satisfy their unique linear relation.
2. In characteristic two, the square of that covariant is the weighted sum of
   the second Hasse coefficients.
3. If every arc in a finite carrier set has size at most `k`, any deletion
   which leaves an arc removes at least `|X|-k` points.

The formalization now also constructs homogeneous linear substitution
\[
 K[X_0,X_1,X_2]\longrightarrow K[U,V]
\]
and the finite product of homogeneous plane-linear factors.  A pairing of
proportional restricted factors produces an explicit square root over a
perfect characteristic-two coefficient ring.  Lean now proves the finite
induction from one-line corrections to a simultaneous extension, the
bounded-degree line-product detection lemma, the squarefree-product nonsquare
obstruction, and their cardinality consequence.  Producing the one-line
correction, divisibility, and concrete factor hypotheses from projective
secants and a general-position carrier arrangement remains geometric.

This belongs in the Lean development and in this verification report now.  It
should not enter the current V1 manuscript as a proved carrier theorem: the
remaining projective inputs are precisely the steps a paper proof would have
to supply.  A later V2 or companion treatment can cite the formal theorem once
those inputs are proved or are stated transparently as hypotheses.

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

`RelativeConicArcs.ChowRestrictionDescent` adds the polynomial bridge:

- `homogeneousLinearPolynomial` and `planeLineRestriction` define the actual
  three-variable to two-variable homogeneous substitution;
- `binaryLinearCoefficientDeterminant`,
  `exists_ne_zero_scale_binaryCoefficients_of_determinant_eq_zero`, and
  `exists_ne_zero_scale_homogeneousLinearPolynomial_of_binary_determinant_eq_zero`
  prove that two nonzero binary linear forms with zero coefficient determinant
  are proportional by a nonzero scalar;
- `homogeneousLinearPolynomial_scale` and its restriction corollary prove the
  exact scalar change caused by rescaling a linear-factor representative;
- `dualLinearFactorProduct` constructs the finite product of dual linear
  factors, and `planeLineRestriction_dualLinearFactorProduct` commutes its
  restriction with that product;
- `dualLinearFactorProduct_rescale` computes the aggregate scalar change under
  independent rescaling of all factor representatives, while
  `exists_dualLinearFactorProduct_rescale_eq_sq_of_exists_eq_sq` and
  `exists_dualLinearFactorProduct_rescale_eq_sq_iff` prove that over a perfect
  characteristic-two field the existence of a square root is invariant under
  every nonzero change of projective representatives;
- `prod_eq_sq_of_equiv_sum` proves the abstract paired-product square identity;
- `planeLineRestriction_dualLinearFactorProduct_eq_sq_of_pairing` supplies an
  explicit restricted root from paired equal factors;
- `prod_eq_scaleProduct_mul_sq_of_equiv_sum` and its polynomial specialization
  replace literal equality by the projectively natural condition that paired
  factors are proportional: their product is the aggregate scalar times a
  square;
- `prod_eq_sq_of_equiv_sum_of_scaleProduct_sq` and
  `planeLineRestriction_dualLinearFactorProduct_eq_sq_of_proportionalPairing`
  construct the corrected root whenever that aggregate scalar is a square;
- `exists_planeLineRestriction_dualLinearFactorProduct_eq_sq_of_proportionalPairing`
  proves that this scalar condition is automatic over a perfect coefficient
  ring of exponent characteristic two, hence in particular over every finite
  characteristic-two field;
- `RestrictionFamily.JointlyDetects` states injectivity of the combined
  restriction map;
- `exists_globalSquareRoot_of_jointlyDetected_extendedRoots` proves descent
  when the linewise roots extend to one ambient polynomial; and
- `isInSquareFrobeniusImage_of_jointlyDetected_extendedRoots` specializes the
  conclusion to the image of Frobenius in exponent characteristic two.

The import-only gate
`RelativeConicArcs.Gates.ChowRestrictionDescent` audits its nineteen public
terminals.

`RelativeConicArcs.CarrierArcBound` formalizes the surviving global algebra:

- `fintypeProd_X_sub_C_dvd_of_injective_roots` proves that a polynomial
  vanishing at finitely many distinctly indexed affine nodes is divisible by
  the product of their monic linear factors, and
  `fintypeProd_X_sub_C_dvd_sub_of_injective_eval_eq` applies this to the
  difference of two polynomials agreeing at every node;
- `exists_finset_extension_of_single_correction` proves the elementary
  interpolation induction: a correction which fits one new restriction and
  vanishes on those already fitted yields a simultaneous extension on every
  finite family;
- `firstCoordinateHyperplaneRestriction_surjective` and
  `coordinateTransformedHyperplaneRestriction_surjective` prove that every
  section on a coordinate-transformed line has an ambient lift;
- `exists_single_correction_of_surjective_of_residual_dvd` constructs the
  one-line correction by lifting the quotient of a divisible residual and
  multiplying it by an ambient element vanishing on the previous
  restrictions;
- `exists_finset_extension_of_residual_dvd_restrictedEquationProduct` and
  `exists_finset_coordinateTransformed_extension_of_residual_dvd` iterate
  these corrections, reducing interpolation on a finite line family to
  residual divisibility by the restricted product of the previous line
  equations;
- `totalDegree_fintypeProd_of_ne_zero` and
  `totalDegree_fintypeProd_eq_card_of_degree_one` compute the total degree of a
  finite product of nonzero degree-one forms;
- `eq_zero_of_pairwise_isRelPrime_dvd_of_totalDegree_lt_card` proves the line
  detection lemma: a polynomial of degree below the number of pairwise
  relatively prime linear divisors is zero;
- `firstCoordinateHyperplaneRestriction_eq_zero_iff_dvd` identifies the kernel
  of restriction to `X₀ = 0` with the principal ideal `(X₀)`, while
  `coordinateTransformedHyperplaneRestriction_eq_zero_iff_dvd` transports the
  statement through a coefficient-preserving polynomial automorphism;
- `exists_eq_C_mul_fintypeProd_of_pairwise_isRelPrime_dvd_of_totalDegree_le_card`
  classifies the exact threshold: a polynomial of degree at most the number of
  pairwise relatively prime degree-one divisors is a constant multiple of
  their product;
- `not_exists_eq_sq_of_squarefree_of_not_isUnit` and
  `not_exists_fintypeProd_eq_sq_of_pairwise_isRelPrime_of_squarefree` prove the
  nonsquare obstruction for a squarefree nonunit and for a pairwise relatively
  prime finite product of squarefree factors;
- `card_le_of_linewiseSquareRoots_extend_and_jointlyDetect` gives the abstract
  carrier-cardinality contradiction; and
- `exists_extendedRoot_difference_eq_C_mul_lineProduct` gives
  `F-G² = C(c)∏L_y` at the degree threshold, while
  `exists_coordinateTransformed_extendedRoot_difference_eq_C_mul_lineProduct`
  discharges restriction-zero divisibility for a family of lines presented by
  coordinate changes; and
- `card_le_of_linewiseSquareRoots_extend_of_lineProductDetection` composes
  actual multivariable line divisors, a degree bound, extended linewise roots,
  and ambient nonsquareness into `Y.card ≤ degreeBound`.

The import-only gate `RelativeConicArcs.Gates.CarrierArcBound` audits these
twenty terminals.

## Formal boundary

Lean checks the local conductor algebra, its representative and
trivialization invariance, the characteristic-two Frobenius identity, the
deletion implication, and the finite-cover counting kernel.

Lean does not yet check:

- the passage from projective arc points to the dual-factor product (its
  square status is now representative-independent, although the product
  itself changes by the explicit aggregate scalar);
- the incidence argument which turns the secant pairing into the determinant
  hypotheses for the restricted binary factors;
- the local binary-form lemma that compatibility at the preceding nodes makes
  each new residual divisible by the restricted product of their linear
  factors; the distinct-affine-node factor theorem, quotient-lift correction,
  and finite induction are formalized, but the passage between homogeneous
  binary forms and an affine chart, including the point at infinity and
  homogeneous degree control, is not yet attached;
- the construction of a linear coordinate change for each concrete projective
  line and the facts that the resulting equations have degree one and are
  pairwise relatively prime;
- squarefreeness and nonunit status of the particular dual-factor product;
- the deduction that the maximum-centre set has arc number at most `k`; or
- the specialization of the finite-cover kernel to all `(k+1)`-subsets and
  their collinear triples.

Those remain the geometric inputs proved in the C626 report.  No axiom
standing for them is introduced.

## Mystery ledger

| Feature | Disposition |
|:--|:--|
| Must paired restricted factors be literally equal? | **Settled negatively by the `ej` pass:** projective representatives give proportional factors.  The formal interface now exposes their aggregate scalar. |
| When do proportional pairs still give a square? | **Settled for the target fields:** the aggregate scalar has a Frobenius preimage over every perfect characteristic-two coefficient ring, including every finite characteristic-two field. |
| Is the full dual-factor product representative-independent? | **Settled at the invariant strength actually used:** the product changes by the aggregate scalar, so literal equality is false; over a perfect characteristic-two field its square status is invariant under all nonzero representative changes. |
| Do compatible linewise roots extend? | **Reduced to projective homogenization and degree control:** agreement at distinctly indexed affine nodes now formally gives product divisibility, restriction is surjective, the quotient-lift correction is kernel-checked, and the corrections iterate over every finite family.  The remaining evidence gap is transporting this affine factor theorem to homogeneous binary forms, handling a possible point at infinity, and preserving the required homogeneous degree. |
| Do the carrier restrictions detect that ambient form? | **Reduced to concrete projective linear algebra:** restriction-zero is equivalent to divisibility for `X₀ = 0` and every coordinate-transformed hypersurface; line-product detection and the cardinal contradiction are kernel-checked.  The remaining evidence gap is presenting each concrete line by a linear coordinate change, plus pairwise relative primality and the required degree statements. |
| Why is the dual-factor product nonsquare? | **Reduced:** a pairwise relatively prime product of squarefree factors is formally nonsquare when it is a nonunit.  The remaining evidence gap is irreducibility or squarefreeness and nonunit status for the concrete projective linear factors. |
| What survives at the exact threshold? | **Settled algebraically:** the difference from the extended ambient square is exactly `C(c)` times the product of the carrier-line equations.  The geometric consequences of this divisor identity remain unexplored. |

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
- `lean/scripts/guarded-lean
  RelativeConicArcs/ChowRestrictionDescent.lean`: **PASS**, warning-free.
- The source-local audit of its nineteen terminals reports no axioms beyond
  `propext`, `Classical.choice`, and `Quot.sound`; `globalSquareRoot_restricts`
  uses none.
- `lean/scripts/guarded-lean RelativeConicArcs/CarrierArcBound.lean`:
  **PASS**, warning-free.
- The source-local audit of its twenty terminals reports no axioms beyond
  `propext`, `Classical.choice`, and `Quot.sound`;
  `exists_finset_extension_of_single_correction` uses only `propext` and
  `Quot.sound`, as does
  `exists_single_correction_of_surjective_of_residual_dvd`.
- Re-elaboration of the ten-terminal gate, exact-target gate build, and
  `--no-build` confirmation, together with the nineteen-terminal polynomial gate
  and twenty-terminal carrier gate builds: pending release of the shared Lean
  build-owner lock.  The latest exact two-gate attempt failed closed because
  the foreign `RelativeConicArcs.Gates.ClebschRigidityTrust` build owns that
  lock.
