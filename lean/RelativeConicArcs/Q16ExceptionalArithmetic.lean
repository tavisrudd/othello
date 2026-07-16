import RelativeConicArcs.Q16Classification

/-!
# Arithmetic anatomy of the three q=16 forced-hit leaves

These small checks formalize the explanatory `2630+3` profile paragraph.  They consume no search
data beyond the three already certified leaf point sets.
-/

namespace RelativeConicArcs.Q16Classification

open Certificate Conic Finset Matrix FiniteFields

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

private abbrev K := GF16
private def g (n : ℕ) : K := GF16.ofNat n

def exceptionalFormOne : Fin 6 → K := ![g 1, g 1, g 1, g 1, g 1, g 0]
def exceptionalFormTwo : Fin 6 → K := ![g 0, g 0, g 0, g 5, g 4, g 1]
def exceptionalFormThree : Fin 6 → K := ![g 2, g 1, g 1, g 5, g 5, g 1]

def evalQuadratic (q : Fin 6 → K) (v : Vec K) : K := dotProduct (monomial v) q

def exceptionalArcOne : Finset Idx := {0, 1, 17, 34, 52, 67, 159, 205}
def exceptionalArcTwo : Finset Idx := {0, 1, 17, 34, 52, 69, 86, 99}
def exceptionalArcThree : Finset Idx := {0, 1, 17, 34, 54, 99, 125, 200}

/-- The first deficient quadratic is the product of the two displayed linear forms. -/
theorem exceptionalFormOne_factorization : ∀ v : Vec K,
    evalQuadratic exceptionalFormOne v =
      (v 0 + g 6 * v 1 + g 6 * v 2) * (v 0 + g 7 * v 1 + g 7 * v 2) := by
  intro v
  simp [evalQuadratic, exceptionalFormOne, monomial, dotProduct, Fin.sum_univ_succ]
  have hadd : g 6 + g 7 = 1 := by decide
  have hmul : g 6 * g 7 = 1 := by decide
  have hcross : g 6 * g 7 * 2 = 0 := by decide
  simp only [show g 0 = 0 by decide, show g 1 = 1 by decide,
    mul_zero, mul_one, one_mul, add_zero]
  linear_combination
    -(v 0 * v 1 + v 0 * v 2) * hadd -
    (v 1 ^ 2 + v 2 ^ 2) * hmul - v 1 * v 2 * hcross

/-- The third deficient quadratic has the second displayed split factorization. -/
theorem exceptionalFormThree_factorization : ∀ v : Vec K,
    evalQuadratic exceptionalFormThree v =
      g 2 * (v 0 + g 4 * v 1 + g 15 * v 2) *
        (v 0 + g 15 * v 1 + g 4 * v 2) := by
  intro v
  simp [evalQuadratic, exceptionalFormThree, monomial, dotProduct, Fin.sum_univ_succ]
  have hadd : g 2 * (g 4 + g 15) = g 5 := by decide
  have hmul : g 2 * g 4 * g 15 = 1 := by decide
  have hsquares : g 2 * (g 4 ^ 2 + g 15 ^ 2) = 1 := by decide
  simp only [show g 1 = 1 by decide, mul_one, one_mul]
  linear_combination
    -(v 0 * v 1 + v 0 * v 2) * hadd -
    (v 1 ^ 2 + v 2 ^ 2) * hmul - v 1 * v 2 * hsquares

theorem exceptionalFormOne_arc_hits :
    (exceptionalArcOne.filter (fun i => evalQuadratic exceptionalFormOne (vec i) = 0)).card =
      2 := by
  decide

theorem exceptionalFormTwo_arc_hits :
    (exceptionalArcTwo.filter (fun i => evalQuadratic exceptionalFormTwo (vec i) = 0)).card =
      7 := by
  decide

theorem exceptionalFormThree_arc_hits :
    (exceptionalArcThree.filter
      (fun i => evalQuadratic exceptionalFormThree (vec i) = 0)).card = 2 := by
  decide

/-- The middle form has exactly the `q+1=17` rational points of a nonsingular conic. -/
theorem exceptionalFormTwo_zero_count :
    (Finset.univ.filter (fun i : Idx => evalQuadratic exceptionalFormTwo (vec i) = 0)).card =
      17 := by
  decide

/-- An explicit coordinate change presenting the middle form as the standard nonsingular conic. -/
def exceptionalFormTwoMatrix : Matrix (Fin 3) (Fin 3) K :=
  ![![g 0, g 1, g 10], ![g 0, g 0, g 15], ![g 5, g 0, g 1]]

theorem exceptionalFormTwoMatrix_det : exceptionalFormTwoMatrix.det = g 6 := by decide

theorem exceptionalFormTwoMatrix_isUnit : IsUnit exceptionalFormTwoMatrix.det := by
  rw [exceptionalFormTwoMatrix_det]
  exact isUnit_iff_ne_zero.mpr (by decide)

theorem exceptionalFormTwoMatrix_coeffs :
    quadraticCoeffs exceptionalFormTwoMatrix = exceptionalFormTwo := by decide

noncomputable def exceptionalFormTwoEquiv : (Fin 3 → K) ≃ₗ[K] (Fin 3 → K) :=
  exceptionalFormTwoMatrix.toLinearEquiv'
    (Matrix.invertibleOfIsUnitDet _ exceptionalFormTwoMatrix_isUnit)

theorem exceptionalFormTwoEquiv_apply (v : Vec K) :
    exceptionalFormTwoEquiv v = exceptionalFormTwoMatrix *ᵥ v := by
  have h := LinearMap.congr_fun
    (Matrix.toLinearEquiv'_apply exceptionalFormTwoMatrix
      (Matrix.invertibleOfIsUnitDet _ exceptionalFormTwoMatrix_isUnit)) v
  rw [Matrix.toLin'_apply] at h
  exact h

noncomputable def exceptionalFormTwoConic : NonsingularConic (K := K) where
  coordinateChange := exceptionalFormTwoEquiv.symm

theorem exceptionalFormTwo_conic_equation (v : Vec K) :
    ProjectiveCap.Sym2Bridge.conicForm
        (exceptionalFormTwoConic.coordinateChange.symm v) =
      evalQuadratic exceptionalFormTwo v := by
  change ProjectiveCap.Sym2Bridge.conicForm (exceptionalFormTwoEquiv v) = _
  rw [exceptionalFormTwoEquiv_apply]
  rw [conicForm_mulVec_eq_dotProduct, exceptionalFormTwoMatrix_coeffs]
  rfl

#print axioms exceptionalFormOne_factorization
#print axioms exceptionalFormThree_factorization
#print axioms exceptionalFormTwo_arc_hits
#print axioms exceptionalFormTwo_conic_equation

end RelativeConicArcs.Q16Classification
