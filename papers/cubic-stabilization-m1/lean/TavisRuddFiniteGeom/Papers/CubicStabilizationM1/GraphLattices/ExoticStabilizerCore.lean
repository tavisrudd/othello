import Mathlib.LinearAlgebra.Matrix.GeneralLinearGroup.Card
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.TraceDeterminantPairing

/-!
# Algebraic core of the exotic stabilizer calculation

This module proves the trace-rigidity and group-order calculations used in
the principal-gluing stabilizer paragraph.  It does not identify the
permutation stabilizer with the special linear group or with `A5`.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace GraphLattices

noncomputable section

open Matrix
open scoped MatrixGroups

/-- If multiplication by `d` preserves the field trace against every test
element, then `d=1`.  This is the exact nondegenerate-trace inference in the
human stabilizer proof. -/
theorem f4_eq_one_of_trace_mul_eq_trace (d : F4)
    (tracePreserved : ∀ z : F4,
      Algebra.trace (ZMod 2) F4 (d * z) =
        Algebra.trace (ZMod 2) F4 z) :
    d = 1 := by
  apply sub_eq_zero.mp
  apply (traceForm_nondegenerate (ZMod 2) F4).1 (d - 1)
  intro z
  rw [Algebra.traceForm_apply, sub_mul, one_mul, map_sub,
    tracePreserved, sub_self]

/-- The matrix special linear group is the kernel of determinant on the
general linear group. -/
def specialLinearEquivDetKernel (n : Type*) [DecidableEq n] [Fintype n]
    (K : Type*) [Field K] :
    Matrix.SpecialLinearGroup n K ≃*
      (Matrix.GeneralLinearGroup.det (n := n) (R := K)).ker where
  toFun matrix := ⟨Matrix.SpecialLinearGroup.toGL matrix, by simp⟩
  invFun matrix :=
    ⟨(matrix.1 : Matrix n n K), by
      have determinantOne := matrix.2
      exact congrArg Units.val determinantOne⟩
  left_inv matrix := by
    apply Matrix.SpecialLinearGroup.ext
    intro row column
    rfl
  right_inv matrix := by
    apply Subtype.ext
    apply Units.ext
    rfl
  map_mul' left right := by
    apply Subtype.ext
    apply Units.ext
    rfl

/-- `GL₂(F4)` has order `180`, obtained from the general finite-field
cardinality formula. -/
theorem f4_generalLinearGroup_two_card :
    Nat.card (GL (Fin 2) F4) = 180 := by
  letI : Fintype F4 := Fintype.ofFinite F4
  rw [Matrix.card_GL_field]
  have fieldCard : Fintype.card F4 = 4 := by
    simpa [Nat.card_eq_fintype_card] using natCard_F4
  simp [fieldCard, Fin.prod_univ_two]

/-- The determinant kernel in `GL₂(F4)` has order `60`. -/
theorem f4_generalLinearGroup_detKernel_card :
    Nat.card
      (Matrix.GeneralLinearGroup.det (n := Fin 2) (R := F4)).ker = 60 := by
  let determinant := Matrix.GeneralLinearGroup.det (n := Fin 2) (R := F4)
  have determinantSurjective : Function.Surjective determinant :=
    Matrix.GeneralLinearGroup.det_surjective
  have rangeTop : determinant.range = ⊤ :=
    determinant.range_eq_top_of_surjective determinantSurjective
  have unitsCard : Nat.card F4ˣ = 3 := by
    rw [Nat.card_units, natCard_F4]
  have kernelTimesIndex := determinant.ker.card_mul_index
  rw [Subgroup.index_ker determinant, rangeTop] at kernelTimesIndex
  have topCard : Nat.card (⊤ : Subgroup F4ˣ) = 3 := by
    simpa using unitsCard
  rw [topCard, f4_generalLinearGroup_two_card] at kernelTimesIndex
  apply Nat.eq_of_mul_eq_mul_right (by norm_num : 0 < 3)
  calc
    Nat.card determinant.ker * 3 = 180 := kernelTimesIndex
    _ = 60 * 3 := by norm_num

/-- The special linear group `SL₂(F4)` has order `60`. -/
theorem f4_specialLinearGroup_two_card :
    Nat.card (SL(2, F4)) = 60 := by
  rw [Nat.card_congr (specialLinearEquivDetKernel (Fin 2) F4).toEquiv]
  exact f4_generalLinearGroup_detKernel_card

end

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
