import RelativeConicArcs.ClebschFactorizationData

/-!
# The `A3` factorization quotient: image rank

The five literal quotient vectors over `𝔽₅` span a three-dimensional image.  Kernel reduction checks
that selected columns are the standard coordinate basis; the general rank argument below turns
that finite predicate into the stated image dimension.  No signed-sheet statement is made because
the `A3` configuration is a single orbit of the projective special linear subgroup.
-/

namespace RelativeConicArcs
namespace ClebschFactorization

/-- The audited `A3` columns selected in the data module are the standard basis. -/
theorem a3_hasCoordinateBasis : HasCoordinateBasis a3Vectors a3BasisColumns := by
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

/-- The `A3` factorization-difference quotient image has dimension three over `𝔽₅`. -/
theorem a3_factorizationImage_finrank :
    Module.finrank (ZMod 5) (LinearMap.range (configurationMap a3Vectors)) = 3 :=
  finrank_range_configurationMap_of_hasCoordinateBasis a3Vectors a3BasisColumns
    a3_hasCoordinateBasis

end ClebschFactorization
end RelativeConicArcs
