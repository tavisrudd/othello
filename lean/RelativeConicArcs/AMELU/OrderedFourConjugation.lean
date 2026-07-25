import RelativeConicArcs.AMELU.SubsystemConjugation
import RelativeConicArcs.AMELU.DiagonalTensorEquiv

/-!
# Ordered four-array form of product conjugation

An ordering `Fin 4 ≃ S` identifies functions on the subsystem product
Weyl labels with four-arrays.  Under this identification, subsystem
product-unitary conjugation is exactly `mapFourArray` applied to the four
single-party Weyl-coordinate conjugation equivalences.

All arguments are symbolic and kernel checked.  The module contains no
generated data, native evaluation, axioms, or admitted declarations.
-/

namespace RelativeConicArcs.AMELU

open Finset

variable {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]
variable {κ : Type*} [Fintype κ] [DecidableEq κ]

/-- Read a function on labels of an ordered four-set as a four-array. -/
def orderedFourArray {S : Finset Party} (e : Fin 4 ≃ S)
    (T : (S → κ) → ℂ) : FourArray κ :=
  fun a b c d =>
    T (fun i => ![a, b, c, d] (e.symm i))

private theorem function_eq_sum_coordinateVector'
    (x : κ → ℂ) :
    x = ∑ p, x p • coordinateVector p 1 := by
  classical
  funext i
  simp [coordinateVector]

private theorem linearEquiv_apply_eq_sum_coordinates
    (A : (κ → ℂ) ≃ₗ[ℂ] (κ → ℂ))
    (x : κ → ℂ) (i : κ) :
    A x i =
      ∑ p, x p * A (coordinateVector p 1) i := by
  conv_lhs =>
    rw [function_eq_sum_coordinateVector' x]
  simp [map_sum, map_smul]

/-- Pointwise expansion of independent action on a four-array. -/
theorem mapFourArray_apply_eq_sum
    (A B C D : (κ → ℂ) ≃ₗ[ℂ] (κ → ℂ))
    (T : FourArray κ) (i j k l : κ) :
    mapFourArray A B C D T i j k l =
      ∑ a, ∑ b, ∑ c, ∑ d,
        T a b c d *
          A (coordinateVector a 1) i *
          B (coordinateVector b 1) j *
          C (coordinateVector c 1) k *
          D (coordinateVector d 1) l := by
  classical
  unfold mapFourArray mapFourFirst mapFourSecond mapFourThird mapFourFourth
  rw [linearEquiv_apply_eq_sum_coordinates]
  apply Finset.sum_congr rfl
  intro a _
  rw [linearEquiv_apply_eq_sum_coordinates]
  rw [Finset.sum_mul]
  apply Finset.sum_congr rfl
  intro b _
  rw [linearEquiv_apply_eq_sum_coordinates]
  rw [Finset.sum_mul, Finset.sum_mul]
  apply Finset.sum_congr rfl
  intro c _
  rw [linearEquiv_apply_eq_sum_coordinates]
  rw [Finset.sum_mul, Finset.sum_mul, Finset.sum_mul]
  apply Finset.sum_congr rfl
  intro d _
  ring

/-- Four functions are equivalent to their four displayed values. -/
def finFourFunctionEquiv (κ : Type*) :
    (Fin 4 → κ) ≃ κ × (κ × (κ × κ)) where
  toFun f := (f 0, f 1, f 2, f 3)
  invFun t := ![t.1, t.2.1, t.2.2.1, t.2.2.2]
  left_inv f := by
    funext i
    fin_cases i <;> rfl
  right_inv t := by
    rcases t with ⟨a, b, c, d⟩
    rfl

private theorem linearEquiv_apply_function_eq_sum
    {S : Finset Party}
    (A : ((S → κ) → ℂ) ≃ₗ[ℂ] ((S → κ) → ℂ))
    (T : (S → κ) → ℂ) (u : S → κ) :
    A T u =
      ∑ v, T v * A (coordinateVector v 1) u := by
  conv_lhs =>
    rw [function_eq_sum_coordinateVector' T]
  simp [map_sum, map_smul]

/-- Under an ordering of a four-set, subsystem product conjugation is
the independent action of the four local conjugation maps. -/
theorem orderedFourArray_subsystemUnitaryConjugation
    (w : WeylConvention 𝔽) {S : Finset Party} (e : Fin 4 ≃ S)
    (U : S → LocalMatrix 𝔽) (hU : ∀ i, IsUnitaryMatrix (U i))
    (T : (S → 𝔽 × 𝔽) → ℂ) :
    orderedFourArray e
        (subsystemUnitaryConjugationWeylEquiv w S U hU T) =
      mapFourArray
        (unitaryConjugationWeylEquiv w (U (e 0)) (hU (e 0)))
        (unitaryConjugationWeylEquiv w (U (e 1)) (hU (e 1)))
        (unitaryConjugationWeylEquiv w (U (e 2)) (hU (e 2)))
        (unitaryConjugationWeylEquiv w (U (e 3)) (hU (e 3)))
        (orderedFourArray e T) := by
  classical
  funext i j k l
  rw [mapFourArray_apply_eq_sum]
  let u : S → 𝔽 × 𝔽 :=
    fun r => ![i, j, k, l] (e.symm r)
  change
    subsystemUnitaryConjugationWeylEquiv w S U hU T u = _
  rw [linearEquiv_apply_function_eq_sum]
  simp_rw [subsystemUnitaryConjugationWeylEquiv_coordinateVector]
  let ef : (Fin 4 → 𝔽 × 𝔽) ≃ (S → 𝔽 × 𝔽) :=
    Equiv.arrowCongr e (Equiv.refl (𝔽 × 𝔽))
  calc
    (∑ v : S → 𝔽 × 𝔽,
      T v *
        ∏ r : S,
          unitaryConjugationWeylEquiv w (U r) (hU r)
            (coordinateVector (v r) 1) (u r)) =
      ∑ x : Fin 4 → 𝔽 × 𝔽,
        T (ef x) *
          ∏ r : S,
            unitaryConjugationWeylEquiv w (U r) (hU r)
              (coordinateVector ((ef x) r) 1) (u r) :=
        (Fintype.sum_equiv ef _ _ (fun _ => rfl)).symm
    _ = ∑ t : (𝔽 × 𝔽) ×
          ((𝔽 × 𝔽) × ((𝔽 × 𝔽) × (𝔽 × 𝔽))),
        T (ef ((finFourFunctionEquiv (𝔽 × 𝔽)).symm t)) *
          ∏ r : S,
            unitaryConjugationWeylEquiv w (U r) (hU r)
              (coordinateVector
                ((ef ((finFourFunctionEquiv (𝔽 × 𝔽)).symm t)) r) 1)
              (u r) := by
        exact Fintype.sum_equiv (finFourFunctionEquiv (𝔽 × 𝔽)) _ _
          (fun _ => by simp)
    _ = ∑ a, ∑ b, ∑ c, ∑ d,
        orderedFourArray e T a b c d *
          unitaryConjugationWeylEquiv w (U (e 0)) (hU (e 0))
            (coordinateVector a 1) i *
          unitaryConjugationWeylEquiv w (U (e 1)) (hU (e 1))
            (coordinateVector b 1) j *
          unitaryConjugationWeylEquiv w (U (e 2)) (hU (e 2))
            (coordinateVector c 1) k *
          unitaryConjugationWeylEquiv w (U (e 3)) (hU (e 3))
            (coordinateVector d 1) l := by
      rw [Fintype.sum_prod_type]
      apply Finset.sum_congr rfl
      intro a _
      rw [Fintype.sum_prod_type]
      apply Finset.sum_congr rfl
      intro b _
      rw [Fintype.sum_prod_type]
      apply Finset.sum_congr rfl
      intro c _
      apply Finset.sum_congr rfl
      intro d _
      have hef :
          ef ((finFourFunctionEquiv (𝔽 × 𝔽)).symm
            (a, (b, (c, d)))) =
            fun r => ![a, b, c, d] (e.symm r) := by
        funext r
        simp [ef, finFourFunctionEquiv, Equiv.arrowCongr]
      rw [hef]
      change
        T (fun r => ![a, b, c, d] (e.symm r)) *
            (∏ x : S,
              unitaryConjugationWeylEquiv w (U x) (hU x)
                (coordinateVector (![a, b, c, d] (e.symm x)) 1)
                (![i, j, k, l] (e.symm x))) =
          T (fun r => ![a, b, c, d] (e.symm r)) *
              unitaryConjugationWeylEquiv w (U (e 0)) (hU (e 0))
                (coordinateVector a 1) i *
            unitaryConjugationWeylEquiv w (U (e 1)) (hU (e 1))
              (coordinateVector b 1) j *
            unitaryConjugationWeylEquiv w (U (e 2)) (hU (e 2))
              (coordinateVector c 1) k *
            unitaryConjugationWeylEquiv w (U (e 3)) (hU (e 3))
              (coordinateVector d 1) l
      have hprod :
          (∏ x : S,
            unitaryConjugationWeylEquiv w (U x) (hU x)
              (coordinateVector (![a, b, c, d] (e.symm x)) 1)
              (![i, j, k, l] (e.symm x))) =
            ∏ r : Fin 4,
              unitaryConjugationWeylEquiv w (U (e r)) (hU (e r))
                (coordinateVector (![a, b, c, d] r) 1)
                (![i, j, k, l] r) := by
        symm
        exact Fintype.prod_equiv e _ _ (fun _ => by simp)
      rw [hprod]
      simp [Fin.prod_univ_succ]
      ring

end RelativeConicArcs.AMELU
