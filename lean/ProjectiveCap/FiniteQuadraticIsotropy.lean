import Mathlib.FieldTheory.ChevalleyWarning
import Mathlib.LinearAlgebra.QuadraticForm.IsometryEquiv

/-!
# Isotropy of finite quadratic spaces

This file proves the finite-field input needed by the strict mirror-boundary classification:
over a finite field of odd characteristic, every quadratic form in dimension at least three has a
nonzero isotropic vector. The proof is kernel-checked from Chevalley--Warning after diagonalizing
the form to a weighted sum of squares.
-/

open scoped BigOperators

namespace ProjectiveCap
namespace FiniteQuadraticIsotropy

open MvPolynomial

variable {K ι V : Type*}

/-- The degree-two polynomial representing a weighted sum of squares. -/
noncomputable def weightedSumSquaresPolynomial [Fintype ι] [Field K] (w : ι → K) :
    MvPolynomial ι K :=
  ∑ i, w i • X i ^ 2

theorem weightedSumSquaresPolynomial_totalDegree_le [Fintype ι] [Field K] (w : ι → K) :
    (weightedSumSquaresPolynomial w).totalDegree ≤ 2 := by
  classical
  apply totalDegree_finsetSum_le
  intro i _
  exact (totalDegree_smul_le ..).trans (totalDegree_X_pow i 2).le

@[simp]
theorem eval_weightedSumSquaresPolynomial [Fintype ι] [Field K]
    (w : ι → K) (x : ι → K) :
    eval x (weightedSumSquaresPolynomial w) = QuadraticMap.weightedSumSquares K w x := by
  classical
  simp [weightedSumSquaresPolynomial, QuadraticMap.weightedSumSquares_apply, pow_two,
    smul_eq_mul]

/-- A weighted sum of squares in at least three variables over a finite field has a nonzero zero.
This is the direct Chevalley--Warning core and does not need odd characteristic. -/
theorem exists_ne_zero_weightedSumSquares_eq_zero [Fintype K] [Field K] [Fintype ι]
    (hdim : 3 ≤ Fintype.card ι) (w : ι → K) :
    ∃ x : ι → K, x ≠ 0 ∧ QuadraticMap.weightedSumSquares K w x = 0 := by
  classical
  let f := weightedSumSquaresPolynomial w
  let zeroSol : {x : ι → K // eval x f = 0} := ⟨0, by
    change eval 0 (weightedSumSquaresPolynomial w) = 0
    rw [eval_weightedSumSquaresPolynomial]
    simp⟩
  let N := Fintype.card {x : ι → K // eval x f = 0}
  have hNpos : 0 < N := @Fintype.card_pos _ _ ⟨zeroSol⟩
  have hdegree : f.totalDegree < Fintype.card ι :=
    (weightedSumSquaresPolynomial_totalDegree_le w).trans_lt (by omega)
  haveI : Fact (ringChar K).Prime := ⟨CharP.char_is_prime K (ringChar K)⟩
  have hdiv : ringChar K ∣ N := char_dvd_card_solutions (ringChar K) hdegree
  have hcard : 1 < N :=
    (Fact.out : (ringChar K).Prime).one_lt.trans_le (Nat.le_of_dvd hNpos hdiv)
  obtain ⟨x, hx⟩ := Fintype.exists_ne_of_one_lt_card hcard zeroSol
  refine ⟨x, ?_, ?_⟩
  · intro hx0
    apply hx
    apply Subtype.ext
    exact hx0
  · simpa [f, eval_weightedSumSquaresPolynomial] using x.property

/-- Every quadratic form of dimension at least three over a finite field of odd characteristic is
isotropic. This is the reusable C85 theorem; no nondegeneracy hypothesis is needed. -/
theorem exists_ne_zero_quadraticForm_eq_zero [Fintype K] [Field K]
    [AddCommGroup V] [Module K V] [FiniteDimensional K V]
    (hchar : ringChar K ≠ 2) (Q : QuadraticForm K V)
    (hdim : 3 ≤ Module.finrank K V) :
    ∃ v : V, v ≠ 0 ∧ Q v = 0 := by
  letI : Invertible (2 : K) := invertibleOfNonzero (Ring.two_ne_zero hchar)
  obtain ⟨w, ⟨e⟩⟩ := Q.equivalent_weightedSumSquares
  obtain ⟨x, hx0, hxQ⟩ := exists_ne_zero_weightedSumSquares_eq_zero
    (ι := Fin (Module.finrank K V)) (by simpa using hdim) w
  refine ⟨e.symm x, ?_, ?_⟩
  · intro hzero
    apply hx0
    have := congrArg e hzero
    simpa using this
  · exact (e.symm.map_app x).trans hxQ

theorem not_anisotropic_quadraticForm [Fintype K] [Field K]
    [AddCommGroup V] [Module K V] [FiniteDimensional K V]
    (hchar : ringChar K ≠ 2) (Q : QuadraticForm K V)
    (hdim : 3 ≤ Module.finrank K V) :
    ¬ Q.Anisotropic := by
  rw [QuadraticMap.not_anisotropic_iff_exists]
  exact exists_ne_zero_quadraticForm_eq_zero hchar Q hdim

end FiniteQuadraticIsotropy
end ProjectiveCap
