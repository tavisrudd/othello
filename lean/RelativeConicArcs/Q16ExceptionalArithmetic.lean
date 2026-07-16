import RelativeConicArcs.Q16Profile

/-!
# Arithmetic anatomy of the three q=16 forced-hit leaves

These small checks formalize the explanatory `2630+3` profile paragraph.  They consume no search
data beyond the three already certified leaf point sets.
-/

namespace RelativeConicArcs.Q16Classification

open Certificate Conic Finset Matrix FiniteFields Q16CertificateData

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

def exceptionalRejectOne : ForcedHitReject :=
  { members := ![0, 1, 17, 34, 52, 67, 159, 205]
    points := ![176, 190, 220, 235, 249, 176]
    coeffs := ![7, 6, 1, 7, 6, 0]
    hit := 159 }

def exceptionalRejectTwo : ForcedHitReject :=
  { members := ![0, 1, 17, 34, 52, 69, 86, 99]
    points := ![128, 138, 151, 171, 189, 128]
    coeffs := ![4, 13, 15, 2, 4, 0]
    hit := 0 }

def exceptionalRejectThree : ForcedHitReject :=
  { members := ![0, 1, 17, 34, 54, 99, 125, 200]
    points := ![140, 158, 191, 215, 233, 140]
    coeffs := ![12, 0, 9, 0, 4, 0]
    hit := 125 }

/-- The displayed objects are definitionally the three forced-hit records in the checked data. -/
theorem exceptional_leaf_records :
    leafL_011_1 = ⟨exceptionalArcOne, .forcedHit exceptionalRejectOne⟩ ∧
    leafL_011_2 = ⟨exceptionalArcTwo, .forcedHit exceptionalRejectTwo⟩ ∧
    leafL_328_7 = ⟨exceptionalArcThree, .forcedHit exceptionalRejectThree⟩ := by
  decide

/-- The three displayed arcs really occur in the exhaustively checked level-eight list. -/
theorem exceptional_arcs_mem_level8 :
    exceptionalArcOne ∈ level8 ∧ exceptionalArcTwo ∈ level8 ∧ exceptionalArcThree ∈ level8 := by
  decide

/-- The identified records themselves occur in the aggregate checked rejection list. -/
theorem exceptional_records_mem_rejectedLeaves :
    leafL_011_1 ∈ rejectedLeaves ∧ leafL_011_2 ∈ rejectedLeaves ∧
      leafL_328_7 ∈ rejectedLeaves := by
  decide

def exceptionalEvaluationMatrix (r : ForcedHitReject) : Matrix (Fin 6) (Fin 6) K :=
  fun i => monomial (vec (r.points i))

def outerMatrix (q r : Fin 6 → K) : Matrix (Fin 6) (Fin 6) K :=
  fun i j => q i * r j

private def exceptionalKernelFunctionalOne : Fin 6 → K := ![g 1, g 0, g 0, g 0, g 0, g 0]
private def exceptionalKernelFunctionalTwo : Fin 6 → K := ![g 0, g 0, g 0, g 11, g 0, g 0]
private def exceptionalKernelFunctionalThree : Fin 6 → K := ![g 9, g 0, g 0, g 0, g 0, g 0]

private def decodeKernelMatrix (m : Matrix (Fin 6) (Fin 6) (Fin 16)) :
    Matrix (Fin 6) (Fin 6) K := fun i j => g (m i j).1

private def exceptionalKernelLeftInverseOne : Matrix (Fin 6) (Fin 6) K :=
  decodeKernelMatrix ![![0,0,0,0,0,0], ![8,11,13,0,15,0], ![14,12,10,0,9,0],
    ![13,8,14,1,11,0], ![12,8,8,7,10,0], ![6,6,0,6,6,0]]

private def exceptionalKernelLeftInverseTwo : Matrix (Fin 6) (Fin 6) K :=
  decodeKernelMatrix ![![6,9,11,11,14,0], ![8,4,8,9,13,0], ![4,13,15,2,4,0],
    ![0,0,0,0,0,0], ![10,13,13,4,14,0], ![2,11,14,7,0,0]]

private def exceptionalKernelLeftInverseThree : Matrix (Fin 6) (Fin 6) K :=
  decodeKernelMatrix ![![0,0,0,0,0,0], ![1,15,0,3,4,0], ![0,8,5,9,13,0],
    ![1,1,10,11,10,0], ![4,2,8,15,10,0], ![11,9,7,0,12,0]]

private theorem kernel_eq_span_of_projection
    (M : Matrix (Fin 6) (Fin 6) K) (q r : Fin 6 → K) (L : Matrix (Fin 6) (Fin 6) K)
    (hproj : L * M + outerMatrix q r = 1) (hq : M *ᵥ q = 0) :
    ∀ c, M *ᵥ c = 0 ↔ ∃ a : K, c = a • q := by
  intro c
  constructor
  · intro hc
    refine ⟨dotProduct r c, ?_⟩
    calc
      c = (1 : Matrix (Fin 6) (Fin 6) K) *ᵥ c := by simp
      _ = (L * M + outerMatrix q r) *ᵥ c := by rw [hproj]
      _ = outerMatrix q r *ᵥ c := by
        rw [Matrix.add_mulVec, ← Matrix.mulVec_mulVec, hc]
        simp
      _ = dotProduct r c • q := by
        ext i
        simp [outerMatrix, Matrix.mulVec, dotProduct, Fin.sum_univ_succ]
        ring
  · rintro ⟨a, rfl⟩
    rw [Matrix.mulVec_smul, hq, smul_zero]

private theorem exceptionalKernelProjectionOne :
    exceptionalKernelLeftInverseOne * exceptionalEvaluationMatrix exceptionalRejectOne +
      outerMatrix exceptionalFormOne exceptionalKernelFunctionalOne = 1 := by decide

private theorem exceptionalKernelProjectionTwo :
    exceptionalKernelLeftInverseTwo * exceptionalEvaluationMatrix exceptionalRejectTwo +
      outerMatrix exceptionalFormTwo exceptionalKernelFunctionalTwo = 1 := by decide

private theorem exceptionalKernelProjectionThree :
    exceptionalKernelLeftInverseThree * exceptionalEvaluationMatrix exceptionalRejectThree +
      outerMatrix exceptionalFormThree exceptionalKernelFunctionalThree = 1 := by decide

/-- The first exceptional evaluation matrix has exactly the displayed one-dimensional kernel. -/
theorem exceptionalKernelOne (c : Fin 6 → K) :
    exceptionalEvaluationMatrix exceptionalRejectOne *ᵥ c = 0 ↔
      ∃ a : K, c = a • exceptionalFormOne := by
  exact kernel_eq_span_of_projection _ _ _ _ exceptionalKernelProjectionOne (by decide) c

/-- The middle exceptional evaluation matrix has exactly the displayed one-dimensional kernel. -/
theorem exceptionalKernelTwo (c : Fin 6 → K) :
    exceptionalEvaluationMatrix exceptionalRejectTwo *ᵥ c = 0 ↔
      ∃ a : K, c = a • exceptionalFormTwo := by
  exact kernel_eq_span_of_projection _ _ _ _ exceptionalKernelProjectionTwo (by decide) c

/-- The third exceptional evaluation matrix has exactly the displayed one-dimensional kernel. -/
theorem exceptionalKernelThree (c : Fin 6 → K) :
    exceptionalEvaluationMatrix exceptionalRejectThree *ᵥ c = 0 ↔
      ∃ a : K, c = a • exceptionalFormThree := by
  exact kernel_eq_span_of_projection _ _ _ _ exceptionalKernelProjectionThree (by decide) c

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
#print axioms exceptional_leaf_records
#print axioms exceptional_arcs_mem_level8
#print axioms exceptional_records_mem_rejectedLeaves
#print axioms exceptionalKernelOne
#print axioms exceptionalKernelTwo
#print axioms exceptionalKernelThree

end RelativeConicArcs.Q16Classification
