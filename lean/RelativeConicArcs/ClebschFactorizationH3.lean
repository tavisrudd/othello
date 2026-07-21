import RelativeConicArcs.ClebschFactorizationData

/-!
# The `H3` factorization quotient: rank and signed moments

The twenty-two literal quotient vectors over `𝔽₁₁` span a ten-dimensional image.  Their two-sheet
sign has zero first and second moments, while the coordinate cubic `x₀³` has signed sum `3`, hence
the signed cubic tensor is nonzero.  The finite predicates are checked by kernel reduction; the
general rank argument below turns the checked coordinate-basis predicate into the stated image
dimension.  No orbit classification, uniqueness of the sheet partition, or invariant-theoretic
stabilizer statement is asserted.
-/

namespace RelativeConicArcs
namespace ClebschFactorization

/-- The audited `H3` columns selected in the data module are the standard basis. -/
theorem h3_hasCoordinateBasis : HasCoordinateBasis h3Vectors h3BasisColumns := by
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

/-- The `H3` factorization-difference quotient image has dimension ten over `𝔽₁₁`. -/
theorem h3_factorizationImage_finrank :
    Module.finrank (ZMod 11) (LinearMap.range (configurationMap h3Vectors)) = 10 :=
  finrank_range_configurationMap_of_hasCoordinateBasis h3Vectors h3BasisColumns
    h3_hasCoordinateBasis

/-- The finite `H3` data satisfy the lower-moment and cubic-coordinate checker predicate. -/
theorem h3_checksSignedMomentWitness :
    ChecksSignedMomentWitness h3Vectors h3SheetSigns 0 0 0 3 := by
  change signedFirstMoment h3Vectors h3SheetSigns = 0 ∧
    signedSecondMoment h3Vectors h3SheetSigns = 0 ∧
    signedCubicCoordinate h3Vectors h3SheetSigns 0 0 0 = 3 ∧ (3 : ZMod 11) ≠ 0
  decide

/-- Soundness of the signed-moment checker predicate for its four displayed conclusions. -/
private theorem signedMomentWitness_sound {R : Type*} [CommRing R] {n r : ℕ}
    {vectors : Fin n → Fin r → R} {signs : Fin n → R} {i j k : Fin r} {value : R}
    (h : ChecksSignedMomentWitness vectors signs i j k value) :
    signedFirstMoment vectors signs = 0 ∧
      signedSecondMoment vectors signs = 0 ∧
      signedCubicCoordinate vectors signs i j k = value ∧ value ≠ 0 :=
  h

/-- The signed first moment of the two `H3` sheets vanishes. -/
theorem h3_signedFirstMoment_eq_zero :
    signedFirstMoment h3Vectors h3SheetSigns = 0 :=
  (signedMomentWitness_sound h3_checksSignedMomentWitness).1

/-- The signed second moment of the two `H3` sheets vanishes. -/
theorem h3_signedSecondMoment_eq_zero :
    signedSecondMoment h3Vectors h3SheetSigns = 0 :=
  (signedMomentWitness_sound h3_checksSignedMomentWitness).2.1

/-- The `x₀³` coordinate functional evaluates the signed `H3` cubic moment to `3`, so that cubic
moment is nonzero. -/
theorem h3_signedCubicCoordinate_zero_zero_zero :
    signedCubicCoordinate h3Vectors h3SheetSigns 0 0 0 = 3 :=
  (signedMomentWitness_sound h3_checksSignedMomentWitness).2.2.1

/-- The signed cubic moment of the two `H3` sheets is nonzero, as witnessed by `x₀³`. -/
theorem h3_signedCubicCoordinate_ne_zero :
    signedCubicCoordinate h3Vectors h3SheetSigns 0 0 0 ≠ 0 := by
  rw [h3_signedCubicCoordinate_zero_zero_zero]
  exact (signedMomentWitness_sound h3_checksSignedMomentWitness).2.2.2

end ClebschFactorization
end RelativeConicArcs
