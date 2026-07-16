import RelativeConicArcs.Q16QuadraticAvoidance

/-!
# Coordinate transport for arbitrary quadratic forms over GF(16)

This is the algebraic bridge used when a general eight-arc is normalized to a certified leaf.
-/

namespace RelativeConicArcs.Q16Classification

open Certificate FiniteFields Matrix

private abbrev K := GF16

/-- Pull a quadratic coefficient vector back through a linear coordinate matrix. -/
def pullbackQuadratic (M : Matrix (Fin 3) (Fin 3) K) (q : Fin 6 → K) : Fin 6 → K :=
  fun k =>
    let c (j : Fin 3) : Vec K := fun i => M i j
    match k with
    | 0 => dotProduct (monomial (c 0)) q
    | 1 => dotProduct (monomial (c 1)) q
    | 2 => dotProduct (monomial (c 2)) q
    | 3 => dotProduct (monomial (c 0 + c 1)) q +
        dotProduct (monomial (c 0)) q + dotProduct (monomial (c 1)) q
    | 4 => dotProduct (monomial (c 0 + c 2)) q +
        dotProduct (monomial (c 0)) q + dotProduct (monomial (c 2)) q
    | 5 => dotProduct (monomial (c 1 + c 2)) q +
        dotProduct (monomial (c 1)) q + dotProduct (monomial (c 2)) q

/-- Evaluation commutes with the explicit coefficient pullback. -/
theorem eval_pullbackQuadratic (M : Matrix (Fin 3) (Fin 3) K) (q : Fin 6 → K)
    (v : Vec K) :
    dotProduct (monomial v) (pullbackQuadratic M q) =
      dotProduct (monomial (M *ᵥ v)) q := by
  simp [pullbackQuadratic, monomial, dotProduct, Matrix.mulVec, Fin.sum_univ_succ]
  ring_nf
  simp [show (2 : K) = 0 by decide]

theorem quadratic_eq_zero_of_eval_zero {q : Fin 6 → K}
    (h : ∀ v : Vec K, dotProduct (monomial v) q = 0) : q = 0 := by
  funext i
  fin_cases i
  · simpa [monomial, dotProduct, Fin.sum_univ_succ] using h ![1, 0, 0]
  · simpa [monomial, dotProduct, Fin.sum_univ_succ] using h ![0, 1, 0]
  · simpa [monomial, dotProduct, Fin.sum_univ_succ] using h ![0, 0, 1]
  · have h0 := h ![1, 0, 0]
    have h1 := h ![0, 1, 0]
    have h01 := h ![1, 1, 0]
    simp [monomial, dotProduct, Fin.sum_univ_succ] at h0 h1 h01
    change q 3 = 0
    linear_combination h01 - h0 - h1
  · have h0 := h ![1, 0, 0]
    have h2 := h ![0, 0, 1]
    have h02 := h ![1, 0, 1]
    simp [monomial, dotProduct, Fin.sum_univ_succ] at h0 h2 h02
    change q 4 = 0
    linear_combination h02 - h0 - h2
  · have h1 := h ![0, 1, 0]
    have h2 := h ![0, 0, 1]
    have h12 := h ![0, 1, 1]
    simp [monomial, dotProduct, Fin.sum_univ_succ] at h1 h2 h12
    change q 5 = 0
    linear_combination h12 - h1 - h2

/-- An invertible coordinate change cannot turn a nonzero quadratic into zero. -/
theorem pullbackQuadratic_ne_zero {M : Matrix (Fin 3) (Fin 3) K}
    (hM : IsUnit M.det) {q : Fin 6 → K} (hq : q ≠ 0) : pullbackQuadratic M q ≠ 0 := by
  intro hpull
  apply hq
  apply quadratic_eq_zero_of_eval_zero
  intro w
  let e : (Fin 3 → K) ≃ₗ[K] (Fin 3 → K) :=
    M.toLinearEquiv' (Matrix.invertibleOfIsUnitDet _ hM)
  obtain ⟨v, rfl⟩ := e.surjective w
  have he (v : Vec K) : e v = M *ᵥ v := by
    have h := LinearMap.congr_fun
      (Matrix.toLinearEquiv'_apply M (Matrix.invertibleOfIsUnitDet _ hM)) v
    rw [Matrix.toLin'_apply] at h
    exact h
  rw [he, ← eval_pullbackQuadratic, hpull]
  simp [dotProduct]

#print axioms eval_pullbackQuadratic
#print axioms pullbackQuadratic_ne_zero

end RelativeConicArcs.Q16Classification
