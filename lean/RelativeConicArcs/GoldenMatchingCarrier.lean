import RelativeConicArcs.GoldenCubicNodesBase
import RelativeConicArcs.GoldenMatchingCubics

/-!
# The five-dimensional Golden matching carrier

The five noncrossing matching products become cubic forms on the centered
five-space after inserting the negative coordinate sum.  This module proves
that those five forms are linearly independent and vanish to second order at
each of the six centered frame vectors.  Both claims are symbolic kernel
proofs over the rationals.
-/

namespace RelativeConicArcs.GoldenMatchingCarrier

open GoldenCubicNodesBase
open GoldenMatchingCubics

/-- The \(k\)-th noncrossing matching cubic on centered coordinates. -/
def matchingForm (k : Fin 5) (x : Fin 5 → ℚ) : ℚ :=
  matchingCubics (centeredLift x) k

/-- Five evaluation points giving a triangular nonsingular evaluation matrix
for the matching forms. -/
def matchingTestPoint : Fin 5 → Fin 5 → ℚ :=
  ![![-1,-1,-1,0,0], ![-1,-1,0,-1,0], ![-1,-1,0,0,-1],
    ![-1,0,-1,-1,0], ![-1,0,-1,0,-1]]

/-- Centering the displayed five-coordinate node restores the full
six-coordinate vector with one exceptional entry. -/
theorem centeredLift_centeredNode (i : Fin 6) :
    centeredLift (centeredNode i : Fin 5 → ℚ) =
      fun q => if i = q then -5 else 1 := by
  funext q
  fin_cases i <;> fin_cases q <;>
    norm_num [centeredLift, centeredNode, Fin.sum_univ_succ]

/-- The five centered matching cubic forms are linearly independent. -/
theorem matchingForm_linearIndependent :
    LinearIndependent ℚ (fun k : Fin 5 => matchingForm k) := by
  classical
  rw [Fintype.linearIndependent_iff]
  intro c hsum k
  have h0 := congrFun hsum (matchingTestPoint 0)
  have h1 := congrFun hsum (matchingTestPoint 1)
  have h2 := congrFun hsum (matchingTestPoint 2)
  have h3 := congrFun hsum (matchingTestPoint 3)
  have h4 := congrFun hsum (matchingTestPoint 4)
  simp only [Fin.sum_univ_succ] at h0 h1 h2 h3 h4
  dsimp [matchingForm, matchingTestPoint, matchingCubics, bracket, centeredLift]
    at h0 h1 h2 h3 h4
  norm_num at h0 h1 h2 h3 h4
  have hc0 : c 0 = 0 := by linarith
  have hc1 : c 1 = 0 := by linarith
  have hc2 : c 2 = 0 := by linarith
  have hc3 : c 3 = 0 := by linarith
  have hc4 : c 4 = 0 := by linarith
  fin_cases k
  · exact hc0
  · exact hc1
  · exact hc2
  · exact hc3
  · exact hc4

/-- Restriction of a matching form to one coordinate line, represented as a
univariate polynomial. -/
noncomputable def matchingCoordinatePolynomial
    (k : Fin 5) (x : Fin 5 → ℚ) (j : Fin 5) : Polynomial ℚ :=
  let y := Function.update (fun a => Polynomial.C (x a)) j Polynomial.X
  matchingCubics (centeredLift y) k

/-- A bracket after replacing one centered coordinate by the polynomial
variable. -/
noncomputable def coordinateBracketPolynomial
    (x : Fin 5 → ℚ) (j : Fin 5) (a b : Fin 6) : Polynomial ℚ :=
  let y := Function.update (fun q => Polynomial.C (x q)) j Polynomial.X
  bracket (centeredLift y) a b

/-- Evaluating a coordinate bracket at the original coordinate restores the
original centered bracket. -/
theorem coordinateBracketPolynomial_eval
    (x : Fin 5 → ℚ) (j : Fin 5) (a b : Fin 6) :
    (coordinateBracketPolynomial x j a b).eval (x j) =
      bracket (centeredLift x) a b := by
  let y := Function.update (fun q => Polynomial.C (x q)) j Polynomial.X
  have hy (q : Fin 5) : (y q).eval (x j) = x q := by
    by_cases hq : q = j
    · subst q
      simp [y]
    · simp [y, hq]
  have hcenter (q : Fin 6) :
      (centeredLift y q).eval (x j) = centeredLift x q := by
    fin_cases q <;> simp [centeredLift, hy]
  change (bracket (centeredLift y) a b).eval (x j) = _
  simp [bracket, hcenter]

private theorem derivative_three_product_eval_eq_zero
    (p q r : Polynomial ℚ) (a : ℚ)
    (hzeros :
      (p.eval a = 0 ∧ q.eval a = 0) ∨
      (p.eval a = 0 ∧ r.eval a = 0) ∨
      (q.eval a = 0 ∧ r.eval a = 0)) :
    ((p * q * r).derivative.eval a) = 0 := by
  rcases hzeros with hpq | hpr | hqr
  · rcases hpq with ⟨hp, hq⟩
    simp [Polynomial.derivative_mul, hp, hq]
  · rcases hpr with ⟨hp, hr⟩
    simp [Polynomial.derivative_mul, hp, hr]
  · rcases hqr with ⟨hq, hr⟩
    simp [Polynomial.derivative_mul, hq, hr]

/-- The matching form itself vanishes at every centered node vector. -/
theorem matchingForm_centeredNode (k : Fin 5) (i : Fin 6) :
    matchingForm k (centeredNode i) = 0 := by
  fin_cases k <;> fin_cases i <;>
    dsimp [matchingForm, matchingCubics, bracket, centeredLift, centeredNode] <;>
    norm_num

/-- Every coordinate derivative of every matching form vanishes at each
centered node vector. -/
theorem derivative_matchingCoordinatePolynomial_centeredNode
    (k : Fin 5) (i : Fin 6) (j : Fin 5) :
    (matchingCoordinatePolynomial k (centeredNode i) j).derivative.eval
      (centeredNode i j) = 0 := by
  fin_cases k
  · change ((coordinateBracketPolynomial (centeredNode i) j 0 1 *
        coordinateBracketPolynomial (centeredNode i) j 2 3 *
        coordinateBracketPolynomial (centeredNode i) j 4 5).derivative.eval
      (centeredNode i j)) = 0
    apply derivative_three_product_eval_eq_zero
    simp only [coordinateBracketPolynomial_eval]
    simp only [centeredLift_centeredNode]
    fin_cases i <;>
      norm_num [bracket, Fin.ext_iff]
  · change ((coordinateBracketPolynomial (centeredNode i) j 0 1 *
        coordinateBracketPolynomial (centeredNode i) j 2 5 *
        coordinateBracketPolynomial (centeredNode i) j 3 4).derivative.eval
      (centeredNode i j)) = 0
    apply derivative_three_product_eval_eq_zero
    simp only [coordinateBracketPolynomial_eval]
    simp only [centeredLift_centeredNode]
    fin_cases i <;>
      norm_num [bracket, Fin.ext_iff]
  · change ((coordinateBracketPolynomial (centeredNode i) j 0 3 *
        coordinateBracketPolynomial (centeredNode i) j 1 2 *
        coordinateBracketPolynomial (centeredNode i) j 4 5).derivative.eval
      (centeredNode i j)) = 0
    apply derivative_three_product_eval_eq_zero
    simp only [coordinateBracketPolynomial_eval]
    simp only [centeredLift_centeredNode]
    fin_cases i <;>
      norm_num [bracket, Fin.ext_iff]
  · change ((coordinateBracketPolynomial (centeredNode i) j 0 5 *
        coordinateBracketPolynomial (centeredNode i) j 1 2 *
        coordinateBracketPolynomial (centeredNode i) j 3 4).derivative.eval
      (centeredNode i j)) = 0
    apply derivative_three_product_eval_eq_zero
    simp only [coordinateBracketPolynomial_eval]
    simp only [centeredLift_centeredNode]
    fin_cases i <;>
      norm_num [bracket, Fin.ext_iff]
  · change ((coordinateBracketPolynomial (centeredNode i) j 0 5 *
        coordinateBracketPolynomial (centeredNode i) j 1 4 *
        coordinateBracketPolynomial (centeredNode i) j 2 3).derivative.eval
      (centeredNode i j)) = 0
    apply derivative_three_product_eval_eq_zero
    simp only [coordinateBracketPolynomial_eval]
    simp only [centeredLift_centeredNode]
    fin_cases i <;>
      norm_num [bracket, Fin.ext_iff]

end RelativeConicArcs.GoldenMatchingCarrier
