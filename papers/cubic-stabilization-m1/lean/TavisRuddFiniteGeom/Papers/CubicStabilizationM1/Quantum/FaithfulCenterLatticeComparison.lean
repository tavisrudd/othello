import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.GradedBulkSourceRing
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.RankTwoCanonicalLattice
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.ExactPrimaryLedger

/-!
# Faithful coefficient extension and rank-two lattice comparison

A loop matrix over a commutative coefficient ring is realized, after a specified
coefficient map, as a paired adapted rank-two connection over a common field.
A regular horizontal comparison and its regular inverse identify this realized
connection with a target connection. Injectivity of the coefficient map then
implies preservation and reflection of the original preimage lattice and of
nonvanishing of the exact modified-residue discriminant.

For the graded completed center source, the coefficient map is the constructed
exponential center homomorphism followed by a supplied embedding of its target
in the common field. Injectivity of the center homomorphism is proved from the
separating divisor pairing. No injectivity of the composite is assumed.

The geometric realization of the coefficient rings, their common-field
embedding, the paired connections, and the regular horizontal comparison and
inverse are explicit data. No geometric blowup or Hodge-fixed-base comparison
is constructed. Residue differences may be integral.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum

/-- An original loop over the source ring, its literal coefficient extension
as a paired connection, and an actual regular horizontal isomorphism over the
common field. Injectivity of the coefficient map is not a field of this data. -/
structure RankTwoCoefficientComparison
    {R F : Type*} [CommRing R] [Field F] (coefficientMap : R →+* F) where
  originalLoop : PowerSeries (Matrix (Fin 2) (Fin 2) R)
  source : AdaptedRankTwoConnection F
  target : AdaptedRankTwoConnection F
  sourceRealization : source.loop = PowerSeries.map
    (coefficientMap.mapMatrix : Matrix (Fin 2) (Fin 2) R →+* Matrix (Fin 2) (Fin 2) F)
    originalLoop
  regular : RegularRankTwoComparison source target

/-- A regular horizontal isomorphism of adapted connections preserves and
reflects membership in the actual canonical preimage lattice. Its constant
lower-right entry is nonzero, as follows from the regular inverse identity. -/
theorem RegularRankTwoComparison.canonicalLattice_iff
    {F : Type*} [Field F] {source target : AdaptedRankTwoConnection F}
    (comparison : RegularRankTwoComparison source target)
    (v : Fin 2 → PowerSeries F) :
    formalRankTwoMatrixAction comparison.comparison v ∈ adaptedCanonicalLattice ↔
      v ∈ adaptedCanonicalLattice := by
  have line := comparison.horizontal.preserves_nilpotentLine source.adapted target.adapted
    (isUnit_iff_ne_zero.mpr target.leadingNonzero)
  simp only [PowerSeries.coeff_zero_eq_constantCoeff] at line
  have entry := congrArg (fun series : PowerSeries (Matrix (Fin 2) (Fin 2) F) => PowerSeries.coeff 0 series 1 1) comparison.leftInverse
  have product : PowerSeries.coeff 0 comparison.comparison 1 1 *
      PowerSeries.coeff 0 comparison.inverse 1 1 = 1 := by
    simpa [coeff_zero_mul_matrixSeries, Matrix.mul_apply, Fin.sum_univ_two, line] using entry
  have nonzero : PowerSeries.coeff 0 comparison.comparison 1 1 ≠ 0 := by
    intro zero
    rw [zero, zero_mul] at product
    exact zero_ne_one product
  simp only [PowerSeries.coeff_zero_eq_constantCoeff] at nonzero
  change PowerSeries.constantCoeff (formalRankTwoMatrixAction comparison.comparison v 1)=0 ↔
    PowerSeries.constantCoeff (v 1)=0
  simp only [formalRankTwoMatrixAction, Fin.sum_univ_two, map_add, map_mul]
  change PowerSeries.coeff 0 comparison.comparison 1 0 * PowerSeries.constantCoeff (v 0) +
    PowerSeries.coeff 0 comparison.comparison 1 1 * PowerSeries.constantCoeff (v 1)=0 ↔ _
  simp [line, nonzero]

/-- Coefficient extension followed by the actual horizontal comparison
preserves and reflects the source preimage lattice when the coefficient map
is injective. Both operations act on the vector's formal coefficients. -/
theorem RankTwoCoefficientComparison.canonicalLattice_iff
    {R F : Type*} [CommRing R] [Field F] {coefficientMap : R →+* F}
    (data : RankTwoCoefficientComparison coefficientMap)
    (injective : Function.Injective coefficientMap) (v : Fin 2 → PowerSeries R) :
    formalRankTwoMatrixAction data.regular.comparison
      (fun i => PowerSeries.map coefficientMap (v i)) ∈ adaptedCanonicalLattice ↔
      v ∈ adaptedCanonicalLattice :=
  data.regular.canonicalLattice_iff _ |>.trans
    (adaptedCanonicalLattice_mem_map_iff coefficientMap injective v)

/-- The target's exact modified-residue discriminant is the coefficient image
of the original source discriminant. Pairing horizontality supplies the
nilpotent-line conditions; neither discriminant equality nor nonresonance is
an input. -/
theorem RankTwoCoefficientComparison.residueDiscriminant_eq
    {R F : Type*} [CommRing R] [Field F] [CharZero F] {coefficientMap : R →+* F}
    (data : RankTwoCoefficientComparison coefficientMap) :
    residueDiscriminant (modifiedResidue data.target.loop) =
      coefficientMap (residueDiscriminant (modifiedResidue data.originalLoop)) := by
  have equal := residueDiscriminant_eq_of_horizontal_pairings_and_inverse
    (isUnit_iff_ne_zero.mpr (by norm_num : (2 : F) ≠ 0))
    data.regular.horizontal data.regular.inverseHorizontal
    data.source.adapted data.target.adapted
    (isUnit_iff_ne_zero.mpr data.source.leadingNonzero)
    (isUnit_iff_ne_zero.mpr data.target.leadingNonzero)
    (isUnit_iff_ne_zero.mpr data.source.pairingNonzero)
    (isUnit_iff_ne_zero.mpr data.target.pairingNonzero)
    data.source.horizontalPairing data.target.horizontalPairing
    data.regular.leftInverse data.regular.rightInverse
  rw [equal, data.sourceRealization, modifiedResidue_coefficient_map,
    residueDiscriminant_coefficient_map]

/-- A faithful source extension and regular comparison preserve and reflect
nonvanishing of the canonical discriminant, including resonant cases. -/
theorem RankTwoCoefficientComparison.residueDiscriminant_ne_zero_iff
    {R F : Type*} [CommRing R] [Field F] [CharZero F] {coefficientMap : R →+* F}
    (data : RankTwoCoefficientComparison coefficientMap)
    (injective : Function.Injective coefficientMap) :
    residueDiscriminant (modifiedResidue data.target.loop) ≠ 0 ↔
      residueDiscriminant (modifiedResidue data.originalLoop) ≠ 0 := by
  rw [data.residueDiscriminant_eq]
  constructor
  · intro nonzero zero
    exact nonzero (by rw [zero, map_zero])
  · intro nonzero zero
    exact nonzero (injective (zero.trans (map_zero coefficientMap).symm))

/-- The constructed graded center homomorphism followed by a faithful target
embedding transports the original lattice and exact residue together.
The ring map's injectivity is derived from the separating integral divisor
pairing and nonzero exceptional parameter. All connection realization and
regular comparison data are supplied separately from that injectivity proof. -/
theorem gradedCenterCoefficientComparison_transport
    {Curve TargetCurve K F : Type*} [AddCommMonoid Curve] [AddCommMonoid TargetCurve]
    [Field K] [CharZero K] [Field F] [CharZero F] {bulkRank divisorRank : ℕ}
    (quotient : CompletedNumericalQuotient Curve TargetCurve)
    (curveGrade : Curve →+ ℤ) (bulkDegree : Fin bulkRank → ℕ)
    (pairing : Curve →+ (Fin divisorRank → ℤ)) (separates : Function.Injective pairing)
    (exceptionalDegree : Curve →+ ℤ)
    (parameter : FractionRing (MvPolynomial (Option (Fin bulkRank)) K)) (nonzero : parameter ≠ 0)
    (targetEmbedding : quotient.numericalGrading.CompletedNovikovRing
      (MvPowerSeries (Fin divisorRank) (FractionRing (MvPolynomial (Option (Fin bulkRank)) K))) →+* F)
    (embeddingInjective : Function.Injective targetEmbedding)
    (data : RankTwoCoefficientComparison (targetEmbedding.comp
      (gradedCompletedBulkCenterRingHom quotient curveGrade bulkDegree pairing exceptionalDegree parameter nonzero))) :
    let coefficientMap := targetEmbedding.comp
      (gradedCompletedBulkCenterRingHom quotient curveGrade bulkDegree pairing exceptionalDegree parameter nonzero)
    Function.Injective coefficientMap ∧
      (∀ v, formalRankTwoMatrixAction data.regular.comparison
        (fun i => PowerSeries.map coefficientMap (v i)) ∈ adaptedCanonicalLattice ↔
          v ∈ adaptedCanonicalLattice) ∧
      residueDiscriminant (modifiedResidue data.target.loop) =
        coefficientMap (residueDiscriminant (modifiedResidue data.originalLoop)) ∧
      (residueDiscriminant (modifiedResidue data.target.loop) ≠ 0 ↔
        residueDiscriminant (modifiedResidue data.originalLoop) ≠ 0) := by
  dsimp only
  have faithful := embeddingInjective.comp
    (gradedCompletedBulkCenterRingHom_injective quotient curveGrade bulkDegree pairing separates
      exceptionalDegree parameter nonzero)
  exact ⟨faithful, data.canonicalLattice_iff faithful, data.residueDiscriminant_eq,
    data.residueDiscriminant_ne_zero_iff faithful⟩

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum
