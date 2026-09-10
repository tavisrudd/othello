import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.SuperRankOneVanishing
import Mathlib.LinearAlgebra.Matrix.BilinearForm

/-!
# The pairing on the odd part

For a finite-dimensional associative superalgebra with an even nondegenerate
Frobenius trace, the trace pairing on the full odd part is nondegenerate and
skew-symmetric, hence its dimension is even in characteristic zero. The proof
uses the supplied even/odd spanning decomposition and parity of multiplication;
it does not assume nondegeneracy on the odd part. Finite-dimensionality and
the algebraic parity hypotheses are explicit, without a geometric realization.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum

/-- The trace-of-product bilinear form on a submodule of an associative algebra.
The submodule need not itself be closed under multiplication. -/
noncomputable def submoduleTracePairing {K A : Type*} [Field K] [Ring A] [Algebra K A]
    (sub : Submodule K A) (trace : A →ₗ[K] K) : LinearMap.BilinForm K sub where
  toFun x :=
    { toFun := fun y => trace ((x : A)*(y : A))
      map_add' := by intro y z; simp [mul_add]
      map_smul' := by intro c y; simp }
  map_add' := by intro x y; ext z; simp [add_mul]
  map_smul' := by intro c x; ext y; simp

/-- A nondegenerate skew-symmetric form over a characteristic-zero field has
even dimension, by comparing the determinant with that of its negative transpose. -/
theorem even_finrank_of_nondegenerate_skew
    {K V : Type*} [Field K] [CharZero K] [AddCommGroup V] [Module K V]
    [FiniteDimensional K V] (form : LinearMap.BilinForm K V)
    (skew : ∀ x y, form x y = -form y x) (nondegenerate : form.Nondegenerate) :
    Even (Module.finrank K V) := by
  classical
  let basis := Module.finBasis K V
  let matrix := LinearMap.BilinForm.toMatrix basis form
  have nonzero : matrix.det ≠ 0 :=
    (LinearMap.BilinForm.nondegenerate_iff_det_ne_zero basis).mp nondegenerate
  have transpose : matrix.transpose = -matrix := by
    ext i j
    simpa only [matrix, Matrix.transpose_apply, Matrix.neg_apply,
      LinearMap.BilinForm.toMatrix_apply] using skew (basis j) (basis i)
  have determinant := congrArg Matrix.det transpose
  rw [Matrix.det_transpose, Matrix.det_neg] at determinant
  rcases Nat.even_or_odd (Module.finrank K V) with h | h
  · exact h
  · have sign : (-1 : K)^(Module.finrank K V) = -1 := h.neg_one_pow
    simp only [Fintype.card_fin, sign, neg_one_mul] at determinant
    have two : (2 : K)*matrix.det=0 := by linear_combination determinant
    exact False.elim (nonzero ((mul_eq_zero.mp two).resolve_left (by norm_num)))

/-- The full odd trace pairing is nondegenerate, and its dimension is even.
The spanning and parity assumptions derive restricted nondegeneracy from the
whole-algebra trace pairing; no restricted nondegeneracy is a premise. -/
theorem oddTracePairing_nondegenerate_and_even
    {K A : Type*} [Field K] [CharZero K] [Ring A] [Algebra K A]
    [FiniteDimensional K A]
    (even odd : Submodule K A)
    (spanning : ∀ y : A, ∃ u ∈ even, ∃ v ∈ odd, y=u+v)
    (oddEven : ∀ x ∈ odd, ∀ y ∈ even, x*y ∈ odd)
    (anticommute : ∀ x ∈ odd, ∀ y ∈ odd, x*y=-(y*x))
    (trace : A →ₗ[K] K) (traceOdd : ∀ x ∈ odd, trace x=0)
    (nondegenerate : ∀ x : A, (∀ y : A, trace (x*y)=0) → x=0) :
    (submoduleTracePairing odd trace).Nondegenerate ∧ Even (Module.finrank K odd) := by
  let form := submoduleTracePairing odd trace
  have skew : ∀ x y, form x y = -form y x := by
    intro x y
    change trace ((x : A)*(y : A)) = -trace ((y : A)*(x : A))
    rw [anticommute x x.property y y.property, map_neg]
  have left : ∀ x, (∀ y, form x y=0) → x=0 := by
    intro x hx
    apply Subtype.ext
    apply nondegenerate (x : A)
    intro y
    obtain ⟨u,hu,v,hv,rfl⟩ := spanning y
    rw [mul_add, map_add, traceOdd _ (oddEven x x.property u hu)]
    exact zero_add (trace ((x : A)*v)) |>.trans (hx ⟨v,hv⟩)
  have nd : form.Nondegenerate := by
    refine ⟨left, ?_⟩
    intro x hx
    apply left x
    intro y
    rw [skew x y, hx y, neg_zero]
  exact ⟨nd, even_finrank_of_nondegenerate_skew form skew nd⟩

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum
