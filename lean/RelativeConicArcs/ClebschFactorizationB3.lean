import RelativeConicArcs.ClebschFactorizationData

/-!
# The `B3` factorization quotient: rank and signed moments

The fourteen literal quotient vectors over `𝔽₇` span a six-dimensional image.  Their two-sheet sign
has zero first and second moments, while the coordinate cubic `x₀³` has signed sum `2`, hence the
signed cubic tensor is nonzero.  The finite predicates are checked by kernel reduction; the general
rank argument below turns the checked coordinate-basis predicate into the stated image dimension.
No orbit classification, uniqueness of the sheet partition, or invariant-theoretic stabilizer
statement is asserted.
-/

namespace RelativeConicArcs
namespace ClebschFactorization

/-- The audited `B3` columns selected in the data module are the standard basis. -/
theorem b3_hasCoordinateBasis : HasCoordinateBasis b3Vectors b3BasisColumns := by
  intro i j
  fin_cases i <;> fin_cases j <;> decide

/-- A finite configuration containing every standard basis vector spans its coordinate space. -/
private theorem finrank_range_configurationMap_of_hasCoordinateBasis
    {K : Type*} [Field K] {n r : ℕ} (vectors : Fin n → Fin r → K)
    (basisColumns : Fin r → Fin n) (h : HasCoordinateBasis vectors basisColumns) :
    Module.finrank K (LinearMap.range (configurationMap vectors)) = r := by
  classical
  change (∀ i j, vectors (basisColumns i) j = if i = j then 1 else 0) at h
  have hsurj : Function.Surjective (configurationMap vectors) := by
    intro target
    let coefficients : Fin n → K := ∑ i, Pi.single (basisColumns i) (target i)
    refine ⟨coefficients, ?_⟩
    funext coordinate
    change (∑ column, ((∑ i : Fin r, Pi.single (basisColumns i) (target i)) : Fin n → K) column
      * vectors column coordinate) = target coordinate
    simp only [Finset.sum_apply]
    simp_rw [Finset.sum_mul]
    rw [Finset.sum_comm]
    have hinner (i : Fin r) :
        (∑ column, (Pi.single (basisColumns i) (target i) : Fin n → K) column
          * vectors column coordinate) =
          target i * vectors (basisColumns i) coordinate := by
      rw [Finset.sum_eq_single (basisColumns i)]
      · simp
      · intro column _ hne
        simp [hne.symm]
      · simp
    simp_rw [hinner]
    simp [h]
  rw [LinearMap.range_eq_top.mpr hsurj, finrank_top, Module.finrank_pi]
  simp

/-- The `B3` factorization-difference quotient image has dimension six over `𝔽₇`. -/
theorem b3_factorizationImage_finrank :
    Module.finrank (ZMod 7) (LinearMap.range (configurationMap b3Vectors)) = 6 :=
  finrank_range_configurationMap_of_hasCoordinateBasis b3Vectors b3BasisColumns
    b3_hasCoordinateBasis

/-- The finite `B3` data satisfy the lower-moment and cubic-coordinate checker predicate. -/
theorem b3_checksSignedMomentWitness :
    ChecksSignedMomentWitness b3Vectors b3SheetSigns 0 0 0 2 := by
  change signedFirstMoment b3Vectors b3SheetSigns = 0 ∧
    signedSecondMoment b3Vectors b3SheetSigns = 0 ∧
    signedCubicCoordinate b3Vectors b3SheetSigns 0 0 0 = 2 ∧ (2 : ZMod 7) ≠ 0
  decide

/-- Soundness of the signed-moment checker predicate for its four displayed conclusions. -/
private theorem signedMomentWitness_sound {R : Type*} [CommRing R] {n r : ℕ}
    {vectors : Fin n → Fin r → R} {signs : Fin n → R} {i j k : Fin r} {value : R}
    (h : ChecksSignedMomentWitness vectors signs i j k value) :
    signedFirstMoment vectors signs = 0 ∧
      signedSecondMoment vectors signs = 0 ∧
      signedCubicCoordinate vectors signs i j k = value ∧ value ≠ 0 :=
  h

/-- The signed first moment of the two `B3` sheets vanishes. -/
theorem b3_signedFirstMoment_eq_zero :
    signedFirstMoment b3Vectors b3SheetSigns = 0 :=
  (signedMomentWitness_sound b3_checksSignedMomentWitness).1

/-- The signed second moment of the two `B3` sheets vanishes. -/
theorem b3_signedSecondMoment_eq_zero :
    signedSecondMoment b3Vectors b3SheetSigns = 0 :=
  (signedMomentWitness_sound b3_checksSignedMomentWitness).2.1

/-- The `x₀³` coordinate functional evaluates the signed `B3` cubic moment to `2`, so that cubic
moment is nonzero. -/
theorem b3_signedCubicCoordinate_zero_zero_zero :
    signedCubicCoordinate b3Vectors b3SheetSigns 0 0 0 = 2 :=
  (signedMomentWitness_sound b3_checksSignedMomentWitness).2.2.1

/-- The signed cubic moment of the two `B3` sheets is nonzero, as witnessed by `x₀³`. -/
theorem b3_signedCubicCoordinate_ne_zero :
    signedCubicCoordinate b3Vectors b3SheetSigns 0 0 0 ≠ 0 := by
  rw [b3_signedCubicCoordinate_zero_zero_zero]
  exact (signedMomentWitness_sound b3_checksSignedMomentWitness).2.2.2

end ClebschFactorization
end RelativeConicArcs
