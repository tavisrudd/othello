import Mathlib.FieldTheory.Finite.Trace
import Mathlib.LinearAlgebra.BilinearForm.Orthogonal
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.PrincipalGluingPacket

/-!
# The trace-determinant polarization on the four-element coefficient heart

This module checks the concrete bilinear algebra used in the principal-gluing
proof.  It does not identify the abstract coefficient heart of an `A5`
representation with this model.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace GraphLattices

noncomputable section

/-- The determinant of two vectors in `F4²`, followed by the field trace to
`F2`, as a bilinear form over `F2`. -/
def f4TraceDeterminantPairing :
    (F4 × F4) →ₗ[ZMod 2] (F4 × F4) →ₗ[ZMod 2] ZMod 2 :=
  LinearMap.mk₂ (ZMod 2)
    (fun left right =>
      Algebra.trace (ZMod 2) F4
        (left.1 * right.2 - left.2 * right.1))
    (by
      intro left₁ left₂ right
      simp only [Prod.fst_add, Prod.snd_add, add_mul]
      rw [add_sub_add_comm, map_add])
    (by
      intro scalar left right
      simp only [Prod.smul_fst, Prod.smul_snd, Algebra.smul_mul_assoc]
      rw [← smul_sub, LinearMap.map_smul])
    (by
      intro left right₁ right₂
      simp only [Prod.fst_add, Prod.snd_add, mul_add]
      rw [← map_add]
      congr 1
      ring)
    (by
      intro scalar left right
      simp only [Prod.smul_fst, Prod.smul_snd, Algebra.mul_smul_comm]
      rw [← smul_sub, LinearMap.map_smul])

/-- Scalar multiplication by an element of `F4`, viewed as an `F2`-linear
endomorphism of `F4²`. -/
def f4ScalarSlope (a : F4) : (F4 × F4) →ₗ[ZMod 2] (F4 × F4) where
  toFun value := (a * value.1, a * value.2)
  map_add' left right := by
    ext <;> simp [mul_add]
  map_smul' scalar value := by
    ext <;> simp [Algebra.smul_def, mul_left_comm]

/-- The trace-determinant pairing has the formula printed in the human
proof. -/
@[simp]
theorem f4TraceDeterminantPairing_apply (left right : F4 × F4) :
    f4TraceDeterminantPairing left right =
      Algebra.trace (ZMod 2) F4
        (left.1 * right.2 - left.2 * right.1) :=
  rfl

/-- Every `F4` scalar is self-adjoint for the `F2` trace-determinant
pairing, exactly as used in the manuscript. -/
theorem f4ScalarSlope_selfAdjoint (a : F4) (left right : F4 × F4) :
    f4TraceDeterminantPairing left (f4ScalarSlope a right) =
      f4TraceDeterminantPairing (f4ScalarSlope a left) right := by
  simp only [f4TraceDeterminantPairing_apply, f4ScalarSlope,
    LinearMap.coe_mk, AddHom.coe_mk]
  congr 1
  ring

/-- The trace-determinant form is skew-symmetric. -/
theorem f4TraceDeterminantPairing_swap (left right : F4 × F4) :
    f4TraceDeterminantPairing right left =
      -f4TraceDeterminantPairing left right := by
  simp only [f4TraceDeterminantPairing_apply]
  rw [← map_neg]
  congr 1
  ring

/-- The concrete coefficient pairing is nondegenerate over `F2`. -/
theorem f4TraceDeterminantPairing_nondegenerate :
    f4TraceDeterminantPairing.Nondegenerate := by
  have traceNondegenerate :=
    traceForm_nondegenerate (ZMod 2) F4
  have separatingLeft : f4TraceDeterminantPairing.SeparatingLeft := by
    intro left vanishes
    have firstZero : left.1 = 0 := by
      apply traceNondegenerate.1 left.1
      intro coefficient
      simpa [Algebra.traceForm_apply] using vanishes (0, coefficient)
    have secondZero : left.2 = 0 := by
      apply traceNondegenerate.1 left.2
      intro coefficient
      have zeroTrace := vanishes (coefficient, 0)
      simpa [Algebra.traceForm_apply] using zeroTrace
    exact Prod.ext firstZero secondZero
  refine ⟨separatingLeft, ?_⟩
  intro right vanishes
  apply separatingLeft right
  intro left
  rw [f4TraceDeterminantPairing_swap]
  simp [vanishes left]

/-- The concrete alternating form on two multiplicity copies. -/
def f4MultiplicityAlternatingForm :
    ((F4 × F4) × (F4 × F4)) →ₗ[ZMod 2]
      ((F4 × F4) × (F4 × F4)) →ₗ[ZMod 2] ZMod 2 :=
  LinearMap.mk₂ (ZMod 2)
    (multiplicityAlternatingPairing f4TraceDeterminantPairing)
    (by
      intro left₁ left₂ right
      simp only [multiplicityAlternatingPairing, Prod.fst_add,
        Prod.snd_add, map_add, LinearMap.add_apply]
      abel)
    (by
      intro scalar left right
      simp only [multiplicityAlternatingPairing, Prod.smul_fst,
        Prod.smul_snd, LinearMap.map_smul, LinearMap.smul_apply,
        smul_sub])
    (by
      intro left right₁ right₂
      simp only [multiplicityAlternatingPairing, Prod.fst_add,
        Prod.snd_add, map_add]
      abel)
    (by
      intro scalar left right
      simp only [multiplicityAlternatingPairing, Prod.smul_fst,
        Prod.smul_snd, LinearMap.map_smul, smul_sub])

/-- Evaluation of the packaged two-copy bilinear form agrees definitionally
with the previously defined alternating-pairing formula. -/
@[simp]
theorem f4MultiplicityAlternatingForm_apply
    (left right : (F4 × F4) × (F4 × F4)) :
    f4MultiplicityAlternatingForm left right =
      multiplicityAlternatingPairing f4TraceDeterminantPairing left right :=
  rfl

/-- The alternating form on the two-copy coefficient heart is
nondegenerate. -/
theorem f4MultiplicityAlternatingForm_nondegenerate :
    f4MultiplicityAlternatingForm.Nondegenerate := by
  have coefficientNondegenerate :=
    f4TraceDeterminantPairing_nondegenerate
  have separatingLeft : f4MultiplicityAlternatingForm.SeparatingLeft := by
    intro left vanishes
    have firstZero : left.1 = 0 := by
      apply coefficientNondegenerate.1 left.1
      intro coefficient
      simpa [f4MultiplicityAlternatingForm_apply,
        multiplicityAlternatingPairing] using
        vanishes (0, coefficient)
    have secondZero : left.2 = 0 := by
      apply coefficientNondegenerate.1 left.2
      intro coefficient
      have zeroPairing := vanishes (coefficient, 0)
      have negated : -f4TraceDeterminantPairing left.2 coefficient = 0 := by
        simpa [f4MultiplicityAlternatingForm_apply,
          multiplicityAlternatingPairing] using zeroPairing
      exact neg_eq_zero.mp negated
    exact Prod.ext firstZero secondZero
  refine ⟨separatingLeft, ?_⟩
  intro right vanishes
  have firstZero : right.1 = 0 := by
    apply coefficientNondegenerate.2 right.1
    intro coefficient
    have zeroPairing := vanishes (0, coefficient)
    have negated : -f4TraceDeterminantPairing coefficient right.1 = 0 := by
      simpa [f4MultiplicityAlternatingForm_apply,
        multiplicityAlternatingPairing] using zeroPairing
    exact neg_eq_zero.mp negated
  have secondZero : right.2 = 0 := by
    apply coefficientNondegenerate.2 right.2
    intro coefficient
    simpa [f4MultiplicityAlternatingForm_apply,
      multiplicityAlternatingPairing] using
      vanishes (coefficient, 0)
  exact Prod.ext firstZero secondZero

/-- Consequently every concrete scalar graph is isotropic for the
alternating two-copy pairing used in the principal-gluing proof. -/
theorem f4ScalarGraph_isotropic (a : F4) (left right : F4 × F4) :
    multiplicityAlternatingPairing f4TraceDeterminantPairing
        (graphEmbedding (f4ScalarSlope a) left)
        (graphEmbedding (f4ScalarSlope a) right) = 0 :=
  graphEmbedding_isotropic_of_selfAdjoint
    f4TraceDeterminantPairing (f4ScalarSlope a)
    (f4ScalarSlope_selfAdjoint a) left right

/-- Each concrete scalar graph is its own orthogonal complement.  This is
the precise maximal-isotropic statement behind the polarization paragraph
of the human proof. -/
theorem f4ScalarGraph_orthogonal_eq (a : F4) :
    LinearMap.BilinForm.orthogonal f4MultiplicityAlternatingForm
        (LinearMap.range (graphEmbedding (f4ScalarSlope a))) =
      LinearMap.range (graphEmbedding (f4ScalarSlope a)) := by
  apply le_antisymm
  · intro point orthogonal
    have differenceZero : point.2 - f4ScalarSlope a point.1 = 0 := by
      apply f4TraceDeterminantPairing_nondegenerate.2
      intro coefficient
      have graphMembership :
          graphEmbedding (f4ScalarSlope a) coefficient ∈
            LinearMap.range (graphEmbedding (f4ScalarSlope a)) :=
        ⟨coefficient, rfl⟩
      have vanishes := orthogonal
        (graphEmbedding (f4ScalarSlope a) coefficient) graphMembership
      have graphVanishes :
          f4TraceDeterminantPairing coefficient point.2 -
            f4TraceDeterminantPairing
              (f4ScalarSlope a coefficient) point.1 = 0 := by
        simpa [f4MultiplicityAlternatingForm_apply,
          multiplicityAlternatingPairing, graphEmbedding] using vanishes
      calc
        f4TraceDeterminantPairing coefficient
            (point.2 - f4ScalarSlope a point.1) =
          f4TraceDeterminantPairing coefficient point.2 -
            f4TraceDeterminantPairing coefficient
              (f4ScalarSlope a point.1) := by rw [map_sub]
        _ = f4TraceDeterminantPairing coefficient point.2 -
            f4TraceDeterminantPairing
              (f4ScalarSlope a coefficient) point.1 := by
          rw [f4ScalarSlope_selfAdjoint]
        _ = 0 := graphVanishes
    refine ⟨point.1, ?_⟩
    apply Prod.ext
    · rfl
    · simp only [graphEmbedding, f4ScalarSlope, LinearMap.prod_apply,
        LinearMap.id_coe, LinearMap.coe_mk, AddHom.coe_mk]
      exact (sub_eq_zero.mp differenceZero).symm
  · intro point graphMembership
    obtain ⟨value, rfl⟩ := graphMembership
    intro other otherMembership
    obtain ⟨otherValue, rfl⟩ := otherMembership
    exact f4ScalarGraph_isotropic a otherValue value

end

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
