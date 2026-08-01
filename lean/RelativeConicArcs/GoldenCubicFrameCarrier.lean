import RelativeConicArcs.GoldenCubicNodesBase

/-!
# The six-node frame and its double-cubic linear system

The six centered Golden node vectors form a projective frame in dimension
four: the first five are linearly independent and the sum of all six is zero.
After sending that frame to the five coordinate points and the all-ones point,
squarefree cubic coefficients form a ten-dimensional space.  The five first
derivatives at the all-ones point are the rows of an explicit incidence
matrix.  This module proves that their common kernel has dimension five and
that every cubic in the kernel vanishes on all fifteen frame edges.
-/

namespace RelativeConicArcs.GoldenCubicFrameCarrier

open GoldenCubicNodesBase

/-- The first five centered node vectors are linearly independent. -/
theorem centeredNode_castSucc_linearIndependent :
    LinearIndependent ℚ (fun i : Fin 5 => centeredNode i.castSucc) := by
  classical
  rw [Fintype.linearIndependent_iff]
  intro c hsum j
  have h0 := congrFun hsum 0
  have h1 := congrFun hsum 1
  have h2 := congrFun hsum 2
  have h3 := congrFun hsum 3
  have h4 := congrFun hsum 4
  simp [centeredNode, Fin.sum_univ_succ] at h0 h1 h2 h3 h4
  have hc0 : c 0 = 0 := by linarith
  have hc1 : c 1 = 0 := by linarith
  have hc2 : c 2 = 0 := by linarith
  have hc3 : c 3 = 0 := by linarith
  have hc4 : c 4 = 0 := by linarith
  fin_cases j
  · exact hc0
  · exact hc1
  · exact hc2
  · exact hc3
  · exact hc4

/-- The six centered frame vectors have the all-ones linear relation. -/
theorem sum_centeredNode_eq_zero :
    ∑ i : Fin 6, centeredNode i = 0 := by
  funext j
  fin_cases j <;> norm_num [centeredNode, Fin.sum_univ_succ]

/-- Incidence of the five variables with the ten squarefree monomials of
degree three, ordered as
\(012,013,014,023,024,034,123,124,134,234\). -/
def incidenceMatrix : Matrix (Fin 5) (Fin 10) ℚ :=
  !![1,1,1,1,1,1,0,0,0,0;
     1,1,1,0,0,0,1,1,1,0;
     1,0,0,1,1,0,1,1,0,1;
     0,1,0,1,0,1,1,0,1,1;
     0,0,1,0,1,1,0,1,1,1]

/-- The five derivative conditions at the all-ones frame point. -/
def incidence : (Fin 10 → ℚ) →ₗ[ℚ] (Fin 5 → ℚ) :=
  Matrix.toLin' incidenceMatrix

private def incidenceWeight (v : Fin 5 → ℚ) (i : Fin 5) : ℚ :=
  v i / 3 - (∑ j, v j) / 18

/-- A right inverse to the incidence map, obtained from the inverse of the
Gram matrix \(3I_5+3J_5\). -/
def incidenceRightInverse (v : Fin 5 → ℚ) : Fin 10 → ℚ :=
  let w := incidenceWeight v
  ![w 0+w 1+w 2, w 0+w 1+w 3, w 0+w 1+w 4,
    w 0+w 2+w 3, w 0+w 2+w 4, w 0+w 3+w 4,
    w 1+w 2+w 3, w 1+w 2+w 4, w 1+w 3+w 4,
    w 2+w 3+w 4]

/-- The explicit incidence right inverse is exact. -/
theorem incidence_incidenceRightInverse (v : Fin 5 → ℚ) :
    incidence (incidenceRightInverse v) = v := by
  funext i
  fin_cases i <;>
    simp [incidence, incidenceMatrix, incidenceRightInverse, incidenceWeight,
      Matrix.toLin'_apply, Matrix.mulVec, dotProduct, Fin.sum_univ_succ] <;>
    ring

/-- The five derivative conditions at the sixth frame point are independent. -/
theorem incidence_surjective : Function.Surjective incidence := by
  intro v
  exact ⟨incidenceRightInverse v, incidence_incidenceRightInverse v⟩

/-- Coefficient space of squarefree cubics double at the six standard frame
points.  Double vanishing at the five coordinate points is automatic; the
kernel imposes the five derivative conditions at the all-ones point. -/
def frameDoubleCarrier : Submodule ℚ (Fin 10 → ℚ) :=
  LinearMap.ker incidence

/-- The complete linear system of cubics double at the six-point projective
frame has vector-space dimension five. -/
theorem finrank_frameDoubleCarrier :
    Module.finrank ℚ frameDoubleCarrier = 5 := by
  change Module.finrank ℚ (LinearMap.ker incidence) = 5
  have hrange :
      Module.finrank ℚ (LinearMap.range incidence) = 5 := by
    rw [LinearMap.range_eq_top.mpr incidence_surjective,
      Submodule.topEquiv.finrank_eq, Module.finrank_pi]
    norm_num
  have hrankNullity := incidence.finrank_range_add_finrank_ker
  rw [hrange, Module.finrank_pi] at hrankNullity
  norm_num at hrankNullity
  omega

/-- A five-dimensional subspace contained in the frame-double carrier equals
the complete carrier. -/
theorem eq_frameDoubleCarrier_of_le_of_finrank
    (W : Submodule ℚ (Fin 10 → ℚ))
    (hle : W ≤ frameDoubleCarrier)
    (hdim : Module.finrank ℚ W = 5) :
    W = frameDoubleCarrier := by
  apply Submodule.eq_of_le_of_finrank_eq hle
  rw [hdim, finrank_frameDoubleCarrier]

/-- Evaluation of a squarefree cubic in the fixed monomial order. -/
def evalSquarefreeCubic (c : Fin 10 → ℚ) (x : Fin 5 → ℚ) : ℚ :=
  c 0*x 0*x 1*x 2 + c 1*x 0*x 1*x 3 + c 2*x 0*x 1*x 4 +
  c 3*x 0*x 2*x 3 + c 4*x 0*x 2*x 4 + c 5*x 0*x 3*x 4 +
  c 6*x 1*x 2*x 3 + c 7*x 1*x 2*x 4 + c 8*x 1*x 3*x 4 +
  c 9*x 2*x 3*x 4

/-- The formal coordinate gradient of a squarefree cubic in the fixed
monomial order. -/
def gradientSquarefreeCubic (c : Fin 10 → ℚ) (x : Fin 5 → ℚ) : Fin 5 → ℚ :=
  ![c 0*x 1*x 2 + c 1*x 1*x 3 + c 2*x 1*x 4 +
      c 3*x 2*x 3 + c 4*x 2*x 4 + c 5*x 3*x 4,
    c 0*x 0*x 2 + c 1*x 0*x 3 + c 2*x 0*x 4 +
      c 6*x 2*x 3 + c 7*x 2*x 4 + c 8*x 3*x 4,
    c 0*x 0*x 1 + c 3*x 0*x 3 + c 4*x 0*x 4 +
      c 6*x 1*x 3 + c 7*x 1*x 4 + c 9*x 3*x 4,
    c 1*x 0*x 1 + c 3*x 0*x 2 + c 5*x 0*x 4 +
      c 6*x 1*x 2 + c 8*x 1*x 4 + c 9*x 2*x 4,
    c 2*x 0*x 1 + c 4*x 0*x 2 + c 5*x 0*x 3 +
      c 7*x 1*x 2 + c 8*x 1*x 3 + c 9*x 2*x 3]

/-- The standard six-point projective frame: five coordinate points followed
by the all-ones point. -/
def standardFramePoint : Fin 6 → Fin 5 → ℚ :=
  ![![1,0,0,0,0], ![0,1,0,0,0], ![0,0,1,0,0],
    ![0,0,0,1,0], ![0,0,0,0,1], ![1,1,1,1,1]]

/-- Membership in the carrier is the vanishing of all five incidence
derivatives at the all-ones point. -/
theorem mem_frameDoubleCarrier_iff (c : Fin 10 → ℚ) :
    c ∈ frameDoubleCarrier ↔ ∀ i, incidence c i = 0 := by
  rw [frameDoubleCarrier, LinearMap.mem_ker]
  constructor
  · intro h i
    rw [h]
    rfl
  · intro h
    funext i
    exact h i

/-- The incidence-kernel definition is equivalent to value and first-order
vanishing at all six standard frame points. -/
theorem mem_frameDoubleCarrier_iff_double_standardFramePoint
    (c : Fin 10 → ℚ) :
    c ∈ frameDoubleCarrier ↔
      ∀ i : Fin 6,
        evalSquarefreeCubic c (standardFramePoint i) = 0 ∧
        ∀ j, gradientSquarefreeCubic c (standardFramePoint i) j = 0 := by
  rw [mem_frameDoubleCarrier_iff]
  constructor
  · intro h
    have h0 := h 0
    have h1 := h 1
    have h2 := h 2
    have h3 := h 3
    have h4 := h 4
    simp [incidence, incidenceMatrix, Matrix.toLin'_apply, Matrix.mulVec,
      dotProduct, Fin.sum_univ_succ] at h0 h1 h2 h3 h4
    have htotal : c 0+c 1+c 2+c 3+c 4+c 5+c 6+c 7+c 8+c 9 = 0 := by
      linear_combination (h0 + h1 + h2 + h3 + h4) / 3
    intro i
    constructor
    · fin_cases i
      all_goals simp [evalSquarefreeCubic, standardFramePoint] <;> linarith
    · intro j
      fin_cases i <;> fin_cases j <;>
        simp [gradientSquarefreeCubic, standardFramePoint] <;>
        linarith
  · intro h j
    have hj := (h 5).2 j
    fin_cases j <;>
      simp [gradientSquarefreeCubic, standardFramePoint, incidence,
        incidenceMatrix, Matrix.toLin'_apply, Matrix.mulVec, dotProduct,
        Fin.sum_univ_succ] at hj ⊢ <;>
      ring_nf at hj ⊢ <;>
      exact hj

/-- Every carrier cubic vanishes identically on each of the fifteen lines
joining two distinct standard frame points. -/
theorem eval_line_standardFramePoint_eq_zero
    (c : Fin 10 → ℚ) (hc : c ∈ frameDoubleCarrier)
    (i j : Fin 6) (hij : i ≠ j) (s t : ℚ) :
    evalSquarefreeCubic c
      (s • standardFramePoint i + t • standardFramePoint j) = 0 := by
  rw [mem_frameDoubleCarrier_iff] at hc
  have h0 := hc 0
  have h1 := hc 1
  have h2 := hc 2
  have h3 := hc 3
  have h4 := hc 4
  simp [incidence, incidenceMatrix, Matrix.toLin'_apply, Matrix.mulVec,
    dotProduct, Fin.sum_univ_succ] at h0 h1 h2 h3 h4
  have hsum :
      3 * (c 0+c 1+c 2+c 3+c 4+c 5+c 6+c 7+c 8+c 9) = 0 := by
    linear_combination h0 + h1 + h2 + h3 + h4
  have htotal : c 0+c 1+c 2+c 3+c 4+c 5+c 6+c 7+c 8+c 9 = 0 := by
    linarith
  have h0st := congrArg (fun q : ℚ => q * s * t^2) h0
  have h1st := congrArg (fun q : ℚ => q * s * t^2) h1
  have h2st := congrArg (fun q : ℚ => q * s * t^2) h2
  have h3st := congrArg (fun q : ℚ => q * s * t^2) h3
  have h4st := congrArg (fun q : ℚ => q * s * t^2) h4
  have h0ts := congrArg (fun q : ℚ => q * t * s^2) h0
  have h1ts := congrArg (fun q : ℚ => q * t * s^2) h1
  have h2ts := congrArg (fun q : ℚ => q * t * s^2) h2
  have h3ts := congrArg (fun q : ℚ => q * t * s^2) h3
  have h4ts := congrArg (fun q : ℚ => q * t * s^2) h4
  have htt := congrArg (fun q : ℚ => q * t^3) htotal
  have hss := congrArg (fun q : ℚ => q * s^3) htotal
  fin_cases i <;> fin_cases j <;>
    simp [evalSquarefreeCubic, standardFramePoint] at hij ⊢ <;>
    ring_nf at h0st h1st h2st h3st h4st h0ts h1ts h2ts h3ts h4ts htt hss ⊢ <;>
    linarith

/-- A homogeneous binary cubic with double zeros at both coordinate endpoints
is the zero cubic.  This is the coordinate mechanism behind frame-edge
vanishing. -/
theorem binaryCubic_eq_zero_of_double_endpoints
    {a b c d : ℚ} (ha : a = 0) (hb : b = 0) (hc : c = 0) (hd : d = 0)
    (s t : ℚ) :
    a*s^3 + b*s^2*t + c*s*t^2 + d*t^3 = 0 := by
  simp [ha, hb, hc, hd]

end RelativeConicArcs.GoldenCubicFrameCarrier
