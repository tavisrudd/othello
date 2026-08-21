import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.PaperInterface.Imports

/-!
# Categorical one-step reviewer terminals

Effective block ledgers, operation adapters, and occurrence-indexed descent.
Geometric and literature inputs remain explicit in the declaration types.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

open TensorProduct

open scoped MatrixGroups

/-- Reviewer-facing universal property of the effective block ledger.  A
component weight has a unique extension to an additive map from the multiset
of regular-isomorphism components into any commutative additive monoid. -/
theorem effectiveBlockLedger_fold_unique
    {A : Type*} [AddCommMonoid A]
    (presentation : Quantum.BlockPresentation)
    (weight : presentation.Component → A)
    (homomorphism : presentation.EffectiveLedger →+ A)
    (onSingleton : ∀ component,
      homomorphism ({component} : presentation.EffectiveLedger) = weight component) :
    homomorphism = presentation.fold weight :=
  presentation.fold_unique weight homomorphism onSingleton
/-- Reviewer-facing categorical adapter for the projective-bundle QDM
comparison.  A multiplicity-preserving block matching on a common coefficient
spine, with singleton markers preserved pairwise, yields the folded
projective-bundle marker formula.  Construction of that matching from the
Iritani--Koto comparison remains an explicit geometric input. -/
theorem qdmProjectiveBundle_markerFormula_of_blockComparison
    {Variety Center Occurrence A : Type*} [AddCommMonoid A]
    {presentation : Quantum.BlockPresentation}
    (data : Quantum.OccurrenceIndexedLedger Variety Center Occurrence presentation)
    (fold : presentation.EffectiveLedger →+ A)
    (base total : Variety) (rank : ℕ)
    (baseSmooth : data.smoothProjective base)
    (totalSmooth : data.smoothProjective total)
    (rankPositive : 1 ≤ rank)
    (dimensionFormula : data.dimension total = data.dimension base + rank - 1)
    (comparison : Quantum.BlockPresentation.FoldCompatibleLedgerComparison
      presentation fold (data.varietyLedger total)
        (rank • data.varietyLedger base)) :
    Quantum.ProjectiveBundleMarkerFormula data fold base total rank :=
  Quantum.projectiveBundleMarkerFormula_of_ledgerComparison
    data fold base total rank baseSmooth totalSmooth rankPositive
      dimensionFormula comparison
/-- Reviewer-facing categorical adapter for the blowup QDM comparison.  A
blockwise matching on a common coefficient spine, preserving the chosen fold
and retaining the literal finite family of center occurrences, yields the
folded blowup marker formula.  Construction of the matching from Iritani's
comparison remains an explicit geometric input. -/
theorem qdmBlowup_markerFormula_of_occurrenceBlockComparison
    {Variety Center Occurrence A : Type*} [AddCommMonoid A]
    {presentation : Quantum.BlockPresentation}
    (data : Quantum.OccurrenceIndexedLedger Variety Center Occurrence presentation)
    (fold : presentation.EffectiveLedger →+ A)
    (lower upper : Variety) {codimension : ℕ}
    (occurrence : Fin (codimension - 1) → Occurrence)
    (comparison : Quantum.BlockPresentation.FoldCompatibleLedgerComparison
      presentation fold (data.varietyLedger upper)
        (data.varietyLedger lower +
          ∑ index, data.occurrenceLedger (occurrence index))) :
    data.varietyMarker fold upper = data.varietyMarker fold lower +
      ∑ index, data.occurrenceMarker fold (occurrence index) :=
  Quantum.blowupMarkerFormula_of_ledgerComparison
    data fold lower upper occurrence comparison
/-- Reviewer-facing packaged blowup adapter.  In addition to the folded
formula, this terminal retains the center, the source equality for every
indexed occurrence, and the smoothness, dimension, and codimension metadata
consumed by occurrence-indexed weak-factorization descent. -/
theorem qdmBlowup_step_of_occurrenceBlockComparison
    {Variety Center Occurrence A : Type*} [AddCommMonoid A]
    {presentation : Quantum.BlockPresentation}
    (data : Quantum.OccurrenceIndexedLedger Variety Center Occurrence presentation)
    (fold : presentation.EffectiveLedger →+ A)
    (ambientDimension : ℕ) (lower upper : Variety)
    (center : Center) (codimension : ℕ)
    (occurrence : Fin (codimension - 1) → Occurrence)
    (occurrenceSource :
      ∀ index, data.occurrenceSource (occurrence index) = center)
    (lowerSmooth : data.smoothProjective lower)
    (upperSmooth : data.smoothProjective upper)
    (centerSmooth : data.smoothCenter center)
    (lowerDimension : data.dimension lower = ambientDimension)
    (upperDimension : data.dimension upper = ambientDimension)
    (codimensionAtLeastTwo : 2 ≤ codimension)
    (centerAmbientDimension :
      data.centerDimension center + codimension = ambientDimension)
    (comparison : Quantum.BlockPresentation.FoldCompatibleLedgerComparison
      presentation fold (data.varietyLedger upper)
        (data.varietyLedger lower +
          ∑ index, data.occurrenceLedger (occurrence index))) :
    Nonempty
      (Quantum.OccurrenceBlowupStep data fold ambientDimension lower upper) :=
  ⟨Quantum.occurrenceBlowupStep_of_ledgerComparison
    data fold ambientDimension lower upper center codimension occurrence
      occurrenceSource lowerSmooth upperSmooth centerSmooth lowerDimension
      upperDimension codimensionAtLeastTwo centerAmbientDimension comparison⟩
/-- Reviewer-facing low-dimensional nullity theorem for the direct residue
marker.  A classified center induction, intrinsic projective-bundle and
point-blowup formulas, and the comparison with every actual QDM occurrence
supply the nullity premise used by categorical descent in dimension four. -/
theorem rankTwoResidueMarker_lowDimensionalOccurrenceNullity
    {K Variety Center Occurrence : Type*} [CommRing K]
    (presentation : Quantum.RankTwoResiduePresentation K)
    (data : Quantum.OccurrenceIndexedLedger Variety Center Occurrence
      presentation.toBlockPresentation)
    (geometry : Applications.RankTwoResidueCenterGeometry Center)
    (input : Applications.RankTwoResidueLowDimensionalInput
      presentation data geometry) :
    Quantum.LowDimensionalOccurrenceNullity data presentation.fold 4 :=
  Applications.rankTwoResidue_lowDimensionalOccurrenceNullity
    presentation data geometry input
/-- Reviewer-facing occurrence-indexed marker theorem in arbitrary ambient
dimension and with arbitrary commutative additive target.  Weak factorization,
the folded operation formulas, and low-dimensional center nullity are explicit
premises of the provider and nullity inputs. -/
theorem occurrenceIndexedMarker_eq_of_birational
    {Variety Center Occurrence A : Type*} [AddCommMonoid A]
    {presentation : Quantum.BlockPresentation}
    (data : Quantum.OccurrenceIndexedLedger Variety Center Occurrence presentation)
    (fold : presentation.EffectiveLedger →+ A) (dimension : ℕ)
    (birational : Setoid Variety)
    (provider : Quantum.BirationalFactorizationProvider data fold dimension birational)
    (nullity : Quantum.LowDimensionalOccurrenceNullity data fold dimension)
    {left right : Variety}
    (leftSmooth : data.smoothProjective left)
    (rightSmooth : data.smoothProjective right)
    (leftDimension : data.dimension left = dimension)
    (rightDimension : data.dimension right = dimension)
    (related : birational.r left right) :
    data.varietyMarker fold left = data.varietyMarker fold right :=
  provider.marker_eq_of_related data fold dimension birational nullity
    leftSmooth rightSmooth leftDimension rightDimension related
/-- Reviewer-facing object-set descent square for the occurrence-indexed
marker: the marker factors through the quotient by the supplied birational
equivalence relation. -/
theorem occurrenceIndexedMarker_descends_to_birationalClasses
    {Variety Center Occurrence A : Type*} [AddCommMonoid A]
    {presentation : Quantum.BlockPresentation}
    (data : Quantum.OccurrenceIndexedLedger Variety Center Occurrence presentation)
    (fold : presentation.EffectiveLedger →+ A) (dimension : ℕ)
    (birational : Setoid Variety)
    (provider : Quantum.BirationalFactorizationProvider data fold dimension birational)
    (nullity : Quantum.LowDimensionalOccurrenceNullity data fold dimension) :
    ∃ descended : Quotient
        (Quantum.BirationalFactorizationProvider.smoothAmbientBirational
          data dimension birational) → A,
      ∀ variety : Quantum.BirationalFactorizationProvider.SmoothAmbientObject
          data dimension,
        descended (Quotient.mk
          (Quantum.BirationalFactorizationProvider.smoothAmbientBirational
            data dimension birational) variety) =
          data.varietyMarker fold variety.1 :=
  ⟨provider.descendedMarker data fold dimension birational nullity,
    provider.descendedMarker_mk data fold dimension birational nullity⟩
/-- Reviewer-facing small even block reduction of a smooth cubic threefold.
Over a field of characteristic zero and for a nonzero square root `r` of three
times the line-class Novikov variable, the displayed constant change of basis
has determinant `-486 r ^ 5`, conjugates the doubled Euler multiplication
matrix to `diag (6 r, -6 r, J)` with `J` a single rank-two Jordan block at the
eigenvalue zero, and conjugates the grading matrix to the displayed separated
form; the two supplied block-off-diagonal gauge coefficients then make the
first and second coefficients of the transformed system block diagonal, with
rank-two blocks `diag (-19 / 18, 19 / 18)` and
`!![0, -14 / (81 r ^ 2); -8 / 81, 0]`.  Uniqueness of the normalized gauge and
the orders beyond the second are not formalized. -/
theorem cubicSmallEven_blockReduction {K : Type*} [Field K] [CharZero K]
    (r : K) (hr : r ≠ 0) :
    (Quantum.cubicBlockBasis r).det = -486 * r ^ 5 ∧
      Quantum.cubicEulerMatrix r * Quantum.cubicBlockBasis r =
        Quantum.cubicBlockBasis r * Quantum.cubicEulerBlockForm r ∧
      Quantum.cubicGradingMatrix * Quantum.cubicBlockBasis r =
        Quantum.cubicBlockBasis r * Quantum.cubicGradingBlockForm r ∧
      Quantum.cubicEulerBlockForm r * Quantum.cubicGaugeFirst r -
          Quantum.cubicGaugeFirst r * Quantum.cubicEulerBlockForm r +
          Quantum.cubicGradingBlockForm r = Quantum.cubicReducedFirst ∧
      Quantum.cubicEulerBlockForm r * Quantum.cubicGaugeSecond r -
          Quantum.cubicGaugeSecond r * Quantum.cubicEulerBlockForm r +
          (Quantum.cubicGradingBlockForm r * Quantum.cubicGaugeFirst r -
            Quantum.cubicGaugeFirst r * Quantum.cubicReducedFirst -
            Quantum.cubicGaugeFirst r) = Quantum.cubicReducedSecond r ∧
      (Quantum.cubicZeroBlockLeading (K := K) * Quantum.cubicZeroBlockLeading = 0 ∧
        Quantum.cubicZeroBlockLeading (K := K) ≠ 0) :=
  ⟨Quantum.cubicBlockBasis_det r, Quantum.cubicEulerMatrix_mul_blockBasis r,
    Quantum.cubicGradingMatrix_mul_blockBasis r hr,
    Quantum.cubicReduction_first_order r hr, Quantum.cubicReduction_second_order r hr,
    Quantum.cubicZeroBlockLeading_sq_eq_zero_and_ne_zero⟩
/-- Reviewer-facing residue of the canonical elementary modification of the
reduced rank-two zero block, computed from the block reduction rather than
assumed: the residue is `!![-19 / 18, 2; -8 / 81, 1 / 18]`, its trace is `-1`,
its determinant is `5 / 36`, and its characteristic polynomial is the rank-two
indicial polynomial whose roots are the exponents `-1 / 6` and `-5 / 6`. -/
theorem cubicZeroBlock_modifiedResidue_indicialPolynomial (r : ℚ) :
    Quantum.modifiedBlockResidue (Quantum.cubicZeroBlockLeading (K := ℚ))
          Quantum.cubicZeroBlockRegular (Quantum.cubicZeroBlockSecond r) =
        !![-19 / 18, 2; -8 / 81, 1 / 18] ∧
      Quantum.cubicZeroPacketResidue =
        Quantum.modifiedBlockResidue (Quantum.cubicZeroBlockLeading (K := ℚ))
          Quantum.cubicZeroBlockRegular (Quantum.cubicZeroBlockSecond r) ∧
      Quantum.cubicIndicialPolynomial =
        ((Polynomial.X ^ 2 -
          Polynomial.C
            (Quantum.modifiedBlockResidue (Quantum.cubicZeroBlockLeading (K := ℚ))
              (Quantum.cubicZeroBlockRegular (K := ℚ))
              (Quantum.cubicZeroBlockSecond r)).trace * Polynomial.X +
          Polynomial.C
            (Quantum.modifiedBlockResidue (Quantum.cubicZeroBlockLeading (K := ℚ))
              (Quantum.cubicZeroBlockRegular (K := ℚ))
              (Quantum.cubicZeroBlockSecond r)).det : Polynomial ℚ)) :=
  ⟨Quantum.cubicModifiedBlockResidue r,
    Quantum.cubicZeroPacketResidue_eq_modifiedBlockResidue r,
    Quantum.cubicModifiedBlockResidue_indicialPolynomial r⟩
/-- Reviewer-facing statement that the regular coefficient of an even rank-two
atomic factor preserves the nilpotent line.  The line is the image of the
square-zero part `N` of the centered leading Euler operator, and the conclusion
is stated as the matrix identity `N * A₀ * N = 0`, together with its vector
form: the regular coefficient carries every vector in the image of `N` back
into its kernel, and for a nonzero square-zero rank-two matrix that image and
that kernel are the same line.  The premises are the ones
the manuscript obtains from horizontality of the Poincare pairing on a
separated spectral factor: the leading pairing coefficient is invertible, `N` is
self-adjoint for it, and the constant coefficient of horizontality holds.  Lean
constructs neither the pairing nor the factor. -/
theorem atomicRankTwo_regularCoefficient_preserves_nilpotentLine
    {K : Type*} [Field K] {N P₀ P₁ A₀ : Matrix (Fin 2) (Fin 2) K}
    (twoNeZero : (2 : K) ≠ 0)
    (squareZero : N * N = 0) (nonzero : N ≠ 0)
    (nondegenerate : P₀.det ≠ 0)
    (selfAdjoint : N.transpose * P₀ = P₀ * N)
    (constantCoefficient :
      A₀.transpose * P₀ + P₀ * A₀ + N.transpose * P₁ - P₁ * N = 0) :
    N * A₀ * N = 0 ∧
      ∀ vector : Fin 2 → K,
        N.mulVec (A₀.mulVec (N.mulVec vector)) = 0 :=
  ⟨Quantum.regularCoefficient_preserves_nilpotentLine twoNeZero squareZero nonzero
      nondegenerate selfAdjoint constantCoefficient,
    Quantum.regularCoefficient_image_subset_kernel
      (Quantum.regularCoefficient_preserves_nilpotentLine twoNeZero squareZero
        nonzero nondegenerate selfAdjoint constantCoefficient)⟩
/-- Reviewer-facing regularity of the base connection after the elementary
modification.  In the adapted frame the only possible pole is a multiple of the
lower-left matrix unit, and the order `u ^ (-1)` coefficient of flatness in the
modified lattice forces that multiple to vanish, because the upper-right entry
of the residue is the unit coming from the square-zero leading operator. -/
theorem atomicRankTwo_modifiedBase_pole_eq_zero
    {K : Type*} [Field K] {R : Matrix (Fin 2) (Fin 2) K} {value : K}
    (upperRightUnit : R 0 1 ≠ 0)
    (flatness : Quantum.modifiedBasePole value +
      (R * Quantum.modifiedBasePole value -
        Quantum.modifiedBasePole value * R) = 0) :
    value = 0 :=
  Quantum.modifiedBasePole_eq_zero upperRightUnit flatness
/-- Reviewer-facing constancy of the residue discriminant along the base.  A
map of the coefficient ring that is additive and satisfies the Leibniz rule,
applied entrywise, models a base derivation; the modified flatness equation
says it carries the residue to a commutator with a regular matrix.  Lean proves
that such a map annihilates the residue discriminant, which is the rigidity
conclusion of the manuscript.  The differential-geometric passage from flatness
to that commutator equation is not formalized. -/
theorem atomicRankTwo_residueDiscriminant_constant_along_base
    {A : Type*} [CommRing A] {derivation : A → A}
    (additive : ∀ x y, derivation (x + y) = derivation x + derivation y)
    (leibniz : ∀ x y, derivation (x * y) = derivation x * y + x * derivation y)
    (R G : Matrix (Fin 2) (Fin 2) A)
    (lax : R.map derivation = G * R - R * G) :
    derivation (Quantum.residueDiscriminant R) = 0 :=
  Quantum.lax_residueDiscriminant_map_eq_zero additive leibniz R G lax
/-- Reviewer-facing regularity of the base direction after the elementary
modification, derived from flatness of the connection rather than from a
supplied coefficient equation.  The connection of a centered rank-two factor is
presented by the two power series `loop = u * A(u)` and `base = u * B(u)`
obtained from its loop and base connection matrices by clearing their simple
poles, and flatness is the single series identity `IsFlatPair`.  In an adapted
frame, where the leading coefficient of the loop direction is the square-zero
matrix with a unit in its upper-right entry and the regular coefficient
preserves the nilpotent line, flatness forces the leading coefficient of the
modified base direction to vanish: the modified connection has no pole in the
base direction.  Lean constructs no `F`-bundle, spectral cover, or atomic
factor; that such a factor supplies a connection of this shape in an adapted
frame is the geometric input. -/
theorem atomicRankTwo_modifiedBase_regular_of_flat_connection
    {B : Type*} [CommRing B] {derivation : B → B}
    (additive : ∀ x y, derivation (x + y) = derivation x + derivation y)
    (leibniz : ∀ x y, derivation (x * y) = derivation x * y + x * derivation y)
    {loop base : PowerSeries (Matrix (Fin 2) (Fin 2) B)} {unitValue : B}
    (unitProperty : IsUnit unitValue) (twoUnit : IsUnit (2 : B))
    (adapted : PowerSeries.coeff 0 loop = Quantum.adaptedLeadingOperator unitValue)
    (nilpotentLine : (PowerSeries.coeff 1 loop) 1 0 = 0)
    (flat : Quantum.IsFlatPair derivation loop base) :
    PowerSeries.coeff 0 (Quantum.modifiedBase base) = 0 :=
  Quantum.modifiedBase_leadingCoefficient_eq_zero_of_isFlatPair additive leibniz
    unitProperty twoUnit adapted nilpotentLine flat
/-- Reviewer-facing Lax equation for the residue of the modified lattice,
derived from flatness.  With no pole left in the base direction, the next order
of flatness in the modified lattice says that the derivation of the coefficient
ring carries the modified residue to its commutator with the regular
coefficient of the modified base direction, which is the manuscript's Lax
equation.  The regular coefficient is not supplied: it is the first coefficient
of the modified base direction. -/
theorem atomicRankTwo_modifiedResidue_lax_of_flat_connection
    {B : Type*} [CommRing B] {derivation : B → B}
    (additive : ∀ x y, derivation (x + y) = derivation x + derivation y)
    (leibniz : ∀ x y, derivation (x * y) = derivation x * y + x * derivation y)
    {loop base : PowerSeries (Matrix (Fin 2) (Fin 2) B)} {unitValue : B}
    (unitProperty : IsUnit unitValue) (twoUnit : IsUnit (2 : B))
    (adapted : PowerSeries.coeff 0 loop = Quantum.adaptedLeadingOperator unitValue)
    (nilpotentLine : (PowerSeries.coeff 1 loop) 1 0 = 0)
    (flat : Quantum.IsFlatPair derivation loop base) :
    (Quantum.modifiedResidue loop).map derivation
      = PowerSeries.coeff 1 (Quantum.modifiedBase base) * Quantum.modifiedResidue loop
        - Quantum.modifiedResidue loop * PowerSeries.coeff 1 (Quantum.modifiedBase base) :=
  Quantum.modifiedResidue_lax_of_isFlatPair additive leibniz unitProperty twoUnit
    adapted nilpotentLine flat
/-- Reviewer-facing rank-two rigidity chain in one statement.  For a centered
rank-two factor in an adapted frame, with a pairing that is horizontal for the
loop direction and whose leading coefficient has invertible determinant, and
with a flat pair of connection matrices, every derivation of the coefficient
ring annihilates the residue discriminant of the canonical elementary
modification.  Horizontality supplies the property of the regular coefficient
that makes the modification regular, and flatness supplies both the vanishing of
the residual base pole and the Lax equation; neither is assumed. -/
theorem atomicRankTwo_residueDiscriminant_frozen_by_horizontality_and_flatness
    {B : Type*} [CommRing B] {derivation : B → B}
    (additive : ∀ x y, derivation (x + y) = derivation x + derivation y)
    (leibniz : ∀ x y, derivation (x * y) = derivation x * y + x * derivation y)
    {loop base pairing : PowerSeries (Matrix (Fin 2) (Fin 2) B)} {unitValue : B}
    (unitProperty : IsUnit unitValue) (twoUnit : IsUnit (2 : B))
    (adapted : PowerSeries.coeff 0 loop = Quantum.adaptedLeadingOperator unitValue)
    (nondegenerate : IsUnit ((PowerSeries.coeff 0 pairing).det))
    (horizontal : Quantum.IsHorizontalPairing loop pairing)
    (flat : Quantum.IsFlatPair derivation loop base) :
    derivation (Quantum.residueDiscriminant (Quantum.modifiedResidue loop)) = 0 :=
  Quantum.residueDiscriminant_modifiedResidue_map_eq_zero_of_horizontal_flat additive
    leibniz unitProperty twoUnit adapted nondegenerate horizontal flat
/-- Reviewer-facing constancy of the residue discriminant over a formal germ of
the base.  The germ is modelled by the ring of multivariate formal power series
in its coordinates over a field of characteristic zero.  For a centered rank-two
factor in an adapted frame whose leading operator has an invertible upper-right
entry, with a horizontal pairing whose leading coefficient has invertible
determinant and a connection flat in every coordinate direction, the residue
discriminant of the canonical elementary modification is a constant series.  No
property of the regular coefficient is assumed: it is supplied by horizontality,
and two is invertible in the germ ring because it is the image of an invertible
scalar.  Lean does not identify this formal model with a rigid-analytic germ,
and constructs neither the connection nor the pairing. -/
theorem atomicRankTwo_residueDiscriminant_constant_over_formal_germ
    {σ : Type*} [DecidableEq σ] {K : Type*} [Field K] [CharZero K]
    {loop pairing : PowerSeries (Matrix (Fin 2) (Fin 2) (MvPowerSeries σ K))}
    {baseDirection : σ → PowerSeries (Matrix (Fin 2) (Fin 2) (MvPowerSeries σ K))}
    {unitValue : MvPowerSeries σ K} (unitProperty : IsUnit unitValue)
    (adapted : PowerSeries.coeff 0 loop = Quantum.adaptedLeadingOperator unitValue)
    (nondegenerate : IsUnit ((PowerSeries.coeff 0 pairing).det))
    (horizontal : Quantum.IsHorizontalPairing loop pairing)
    (flat : ∀ direction, Quantum.IsFlatPair (Quantum.formalPartialDerivative direction)
      loop (baseDirection direction)) :
    Quantum.residueDiscriminant (Quantum.modifiedResidue loop)
      = MvPowerSeries.C
          (MvPowerSeries.constantCoeff
            (Quantum.residueDiscriminant (Quantum.modifiedResidue loop))) :=
  Quantum.residueDiscriminant_modifiedResidue_eq_constant_of_horizontal_flat unitProperty
    adapted nondegenerate horizontal flat
/-- Reviewer-facing exponent interpretation of the residue discriminant.  Over
a coefficient ring in which the residue of the canonical modified lattice has
eigenvalues `r₁` and `r₂`, counted with algebraic multiplicity, the residue
discriminant is their squared separation, and it is unchanged by adding a
scalar multiple of the identity to the residue.  The identification of the
eigenvalue classes modulo the integers with the formal exponent classes of the
centered rank-two module is not formalized. -/
theorem residueDiscriminant_eq_squared_eigenvalue_separation
    {A : Type*} [CommRing A] (R : Matrix (Fin 2) (Fin 2) A) (r₁ r₂ : A)
    (traceValue : Matrix.trace R = r₁ + r₂) (detValue : R.det = r₁ * r₂) :
    Quantum.residueDiscriminant R = (r₁ - r₂) ^ 2 ∧
      ∀ shift : A, Quantum.residueDiscriminant
        (R + shift • (1 : Matrix (Fin 2) (Fin 2) A)) =
          Quantum.residueDiscriminant R :=
  ⟨Quantum.residueDiscriminant_eq_sq_sub_of_trace_det R r₁ r₂ traceValue detValue,
    Quantum.residueDiscriminant_add_scalar R⟩
/-- Reviewer-facing derivation of the rank-two pairing equations from
horizontality, and of the nilpotent-line preservation they give.  The connection
of the centered even rank-two atomic factor has square-zero residue `residue`
and regular coefficients `regular`, and the pairing has coefficients `pairing`,
the leading one invertible.  Vanishing of the coefficient of `u ^ (-1)` in the
loop-direction horizontality identity is exactly self-adjointness of the residue
for the leading pairing coefficient, and vanishing of the constant coefficient is
the four-term relation between the regular coefficient, the first two pairing
coefficients, and the residue.  Those are the two inputs of the rank-two
rigidity argument, whose conclusion is that the residue, the regular
coefficient, and the residue again have vanishing product, equivalently that the
regular coefficient carries every vector in the image of the residue back into
its kernel.

Lean constructs neither the `A`-model `F`-bundle, the spectral cover, the atomic
factor, nor the Poincare pairing; horizontality enters as the vanishing of two
matrix coefficients. -/
theorem atomicRankTwo_pairingEquations_of_loopHorizontality
    {K : Type*} [Field K] {residue : Matrix (Fin 2) (Fin 2) K}
    {regular pairing : ℕ → Matrix (Fin 2) (Fin 2) K}
    (twoNeZero : (2 : K) ≠ 0)
    (squareZero : residue * residue = 0) (nonzero : residue ≠ 0)
    (nondegenerate : (pairing 0).det ≠ 0)
    (leading : Quantum.loopPairingHorizontalityCoefficient residue regular residue regular
      pairing 0 = 0)
    (constant : Quantum.loopPairingHorizontalityCoefficient residue regular residue regular
      pairing 1 = 0) :
    residue.transpose * pairing 0 = pairing 0 * residue ∧
      (regular 0).transpose * pairing 0 + pairing 0 * regular 0
          + residue.transpose * pairing 1 - pairing 1 * residue = 0 ∧
        residue * regular 0 * residue = 0 ∧
          ∀ vector : Fin 2 → K,
            residue.mulVec ((regular 0).mulVec (residue.mulVec vector)) = 0 := by
  have preservation : residue * regular 0 * residue = 0 :=
    Quantum.regularCoefficient_preserves_nilpotentLine_of_loopHorizontality twoNeZero
      squareZero nonzero nondegenerate leading constant
  exact ⟨Quantum.leadingResidue_selfAdjoint_of_horizontality leading,
    Quantum.constantOrder_relation_of_loopHorizontality constant, preservation,
    Quantum.regularCoefficient_image_subset_kernel preservation⟩
/-- Reviewer-facing existence and uniqueness of the normalized gauge of the
separated small even system of a smooth cubic threefold.  The system is the
separated Euler matrix at order zero and the separated grading matrix at order
one, over a field of characteristic zero in a nonzero square root of three times
the line-class variable; the coordinates are partitioned into the two simple
Euler eigenvalues and the rank-two zero block.  Lean proves that the separated
Euler matrix is block diagonal for that partition, that its three eigenvalues
have unit pairwise differences and that it differs from their diagonal matrix by
a square-zero matrix, so the general theorem applies.  The identification of
these two matrices with the small even quantum connection of a cubic threefold
is the imported datum. -/
theorem cubicSmallEven_normalizedGauge_exists_and_unique {K : Type*} [Field K] [CharZero K]
    {r : K} (nonzero : r ≠ 0) :
    (∃ gauge reduced : ℕ → Matrix (Fin 4) (Fin 4) K,
        Quantum.IsNormalizedGauge Quantum.cubicBlockLabel (Quantum.cubicSeparatedSystem r)
          gauge reduced) ∧
      ∀ gauge reduced gaugeOther reducedOther : ℕ → Matrix (Fin 4) (Fin 4) K,
        Quantum.IsNormalizedGauge Quantum.cubicBlockLabel (Quantum.cubicSeparatedSystem r)
            gauge reduced →
          Quantum.IsNormalizedGauge Quantum.cubicBlockLabel (Quantum.cubicSeparatedSystem r)
              gaugeOther reducedOther →
            ∀ order, gauge order = gaugeOther order ∧ reduced order = reducedOther order :=
  ⟨Quantum.exists_normalizedGauge_cubicSeparatedSystem nonzero,
    fun _ _ _ _ first second =>
      Quantum.normalizedGauge_cubicSeparatedSystem_unique nonzero first second⟩
/-- Reviewer-facing identification of the exhibited coefficients of the small
even block reduction with the coefficients of the unique normalized gauge.  For
every normalized gauge of the separated small even system, the first two gauge
coefficients are the two matrices exhibited by the block reduction and the first
two coefficients of the reduced system are the exhibited block-diagonal ones,
whose rank-two blocks are the displayed `D₀` and `E₀`.  The exhibited matrices
are therefore not one admissible choice among many: they are the coefficients of
the normalized gauge. -/
theorem cubicSmallEven_normalizedGauge_coefficients {K : Type*} [Field K] [CharZero K]
    {r : K} (nonzero : r ≠ 0) {gauge reduced : ℕ → Matrix (Fin 4) (Fin 4) K}
    (normalized : Quantum.IsNormalizedGauge Quantum.cubicBlockLabel
      (Quantum.cubicSeparatedSystem r) gauge reduced) :
    gauge 1 = Quantum.cubicGaugeFirst r ∧ reduced 1 = Quantum.cubicReducedFirst
      ∧ gauge 2 = Quantum.cubicGaugeSecond r ∧ reduced 2 = Quantum.cubicReducedSecond r :=
  Quantum.normalizedGauge_cubicSeparatedSystem_coefficients nonzero normalized

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
