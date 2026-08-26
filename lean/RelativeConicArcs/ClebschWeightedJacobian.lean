import Mathlib.LinearAlgebra.FiniteDimensional.Basic
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring

/-!
# The reduced weighted Jacobian for the golden six-point configuration

The order-three fixed space in the weighted-Jacobian argument has the basis
`u₁,…,u₅` used in the manuscript.  In that basis the twenty Jacobian rows
collapse, up to nonzero row multiples, to the eight rows encoded below.  This
module proves directly that their common kernel over `ℚ` is the scaling line
spanned by `(1,1,1,1,-1)`, and hence that the reduced Jacobian has rank four.

The final theorem isolates the representation-theoretic bridge used in the
paper: if every kernel direction outside the scaling line produces an
order-three-fixed kernel direction outside that line, then control of the
fixed kernel forces control of the full kernel.
-/

namespace RelativeConicArcs.ClebschWeightedJacobian

/-- The scaling direction in the five order-three orbit-sum coordinates. -/
def scalingDirection : Fin 5 → ℚ := ![1, 1, 1, 1, -1]

/-- The eight distinct content-normalized rows of the weighted Jacobian on the
order-three fixed space. -/
def reducedJacobian : (Fin 5 → ℚ) →ₗ[ℚ] (Fin 8 → ℚ) where
  toFun x :=
    ![-2 * x 0 + x 1 + x 2,
      -x 0 + x 1 + x 2 - x 3,
      -x 1 - x 2 + x 3 - x 4,
      x 0 - 3 * x 1 + 2 * x 2 + x 3 + x 4,
      x 0 - 2 * x 1 + 3 * x 2 - x 3 + x 4,
      x 0 + 2 * x 1 - 3 * x 2 + x 3 + x 4,
      x 0 + 3 * x 1 - 2 * x 2 - x 3 + x 4,
      -x 1 - x 2 - 2 * x 4]
  map_add' x y := by
    ext i
    fin_cases i <;> simp <;> ring
  map_smul' c x := by
    ext i
    fin_cases i <;> simp <;> ring

/-- Homogeneity puts the scaling direction in the reduced kernel. -/
theorem reducedJacobian_scalingDirection :
    reducedJacobian scalingDirection = 0 := by
  ext i
  fin_cases i <;> norm_num [reducedJacobian, scalingDirection,
    Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four]

/-- The displayed eight-by-five table has exactly the scaling line as kernel. -/
theorem reducedJacobian_ker :
    LinearMap.ker reducedJacobian = ℚ ∙ scalingDirection := by
  ext x
  rw [LinearMap.mem_ker, Submodule.mem_span_singleton]
  constructor
  · intro hx
    have h₀ : -2 * x 0 + x 1 + x 2 = 0 := by
      simpa [reducedJacobian] using congrFun hx 0
    have h₁ : -x 0 + x 1 + x 2 - x 3 = 0 := by
      simpa [reducedJacobian] using congrFun hx 1
    have h₂ : -x 1 - x 2 + x 3 - x 4 = 0 := by
      simpa [reducedJacobian] using congrFun hx 2
    have h₃ : x 0 - 3 * x 1 + 2 * x 2 + x 3 + x 4 = 0 := by
      simpa [reducedJacobian] using congrFun hx 3
    have hx₁ : x 1 = x 0 := by linarith
    have hx₂ : x 2 = x 0 := by linarith
    have hx₃ : x 3 = x 0 := by linarith
    have hx₄ : x 4 = -x 0 := by linarith
    refine ⟨x 0, ?_⟩
    ext i
    fin_cases i <;> simp [scalingDirection, hx₁, hx₂, hx₃, hx₄,
      Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four]
  · rintro ⟨c, rfl⟩
    simp [reducedJacobian_scalingDirection]

section FixedDetection

variable {K W V : Type*} [Field K] [AddCommGroup W] [Module K W]
  [AddCommGroup V] [Module K V]

/-- Fixed-vector detection is the exact logical bridge in the equivariant
weighted-Jacobian proof.  A representation-theoretic argument supplies
`hdetect`; the reduced table supplies `hfixed`. -/
theorem kernel_eq_scaling_of_fixed_detection
    (J : W →ₗ[K] V) (h : W →ₗ[K] W) (a : W)
    (hJa : J a = 0)
    (hfixed : ∀ x, J x = 0 → h x = x → x ∈ K ∙ a)
    (hdetect : ∀ x, J x = 0 → x ∉ K ∙ a →
      ∃ y, J y = 0 ∧ h y = y ∧ y ∉ K ∙ a) :
    LinearMap.ker J = K ∙ a := by
  apply le_antisymm
  · intro x hx
    by_contra hxa
    obtain ⟨y, hJy, hhy, hya⟩ := hdetect x hx hxa
    exact hya (hfixed y hJy hhy)
  · rw [Submodule.span_singleton_le_iff_mem, LinearMap.mem_ker]
    exact hJa

end FixedDetection

end RelativeConicArcs.ClebschWeightedJacobian
