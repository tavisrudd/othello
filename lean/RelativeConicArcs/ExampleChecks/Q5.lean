import RelativeConicArcs.Certificate

namespace RelativeConicArcs.Examples

open Certificate
open Conic
open Matrix

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

private instance : Fact (Nat.Prime 5) := ⟨by decide⟩
noncomputable local instance : Fintype (Conic.Point (ZMod 5)) := Fintype.ofFinite _
noncomputable local instance : DecidableEq (Conic.Point (ZMod 5)) := Classical.decEq _

private def v5 (x y z : Nat) : Vec (ZMod 5) :=
  ![x, y, z]

/-- The coordinate matrix carrying the displayed C187 frame conic to the standard model. -/
def q5FrameMatrix : Matrix (Fin 3) (Fin 3) (ZMod 5) :=
  ![![1, 2, 3], ![0, 1, 3], ![3, 2, 4]]

/-- The displayed C187 quadratic `X²+Y²+Z²+XY+XZ+YZ`. -/
def q5DisplayedQuadratic (v : Vec (ZMod 5)) : ZMod 5 :=
  v 0 ^ 2 + v 1 ^ 2 + v 2 ^ 2 + v 0 * v 1 + v 0 * v 2 + v 1 * v 2

/-- The four standard frame vectors in the order used by C187. -/
def q5StandardFrameVectors : List (Vec (ZMod 5)) :=
  [v5 1 0 0, v5 0 1 0, v5 0 0 1, v5 1 1 1]

/-- The C187 projective four-frame, transported to the standard conic `XZ - Y² = 0` by
the matrix with rows `(1,2,3)`, `(0,1,3)`, `(3,2,4)`.  That matrix has determinant `2` over
`ZMod 5`; pulling back the standard equation gives a nonzero scalar multiple of the displayed
quadratic `X² + Y² + Z² + XY + XZ + YZ`. -/
def q5FrameWitness : List (RawPoint (ZMod 5)) := [
  ⟨v5 1 0 3, by decide⟩,
  ⟨v5 2 1 2, by decide⟩,
  ⟨v5 3 3 4, by decide⟩,
  ⟨v5 1 4 4, by decide⟩]

theorem q5FrameMatrix_det : q5FrameMatrix.det = 2 := by decide

theorem q5FrameMatrix_isUnit : IsUnit q5FrameMatrix := by
  rw [Matrix.isUnit_iff_isUnit_det]
  exact isUnit_iff_ne_zero.mpr (by rw [q5FrameMatrix_det]; decide)

/-- Pulling the standard conic equation back along the matrix gives twice the displayed
quadratic.  Since `2 ≠ 0` in `ZMod 5`, the projective zero loci agree under transport. -/
theorem q5FrameMatrix_conicForm (v : Vec (ZMod 5)) :
    ProjectiveCap.Sym2Bridge.conicForm (q5FrameMatrix *ᵥ v) =
      2 * q5DisplayedQuadratic v := by
  simp [q5FrameMatrix, q5DisplayedQuadratic, ProjectiveCap.Sym2Bridge.conicForm,
    Matrix.mulVec, dotProduct, Fin.sum_univ_succ]
  have hfive : (5 : ZMod 5) = 0 := by decide
  linear_combination
    -(2 * v 1 * v 2 + 2 * v 1 * v 0 + v 1 ^ 2 + 3 * v 2 * v 0 +
      v 2 ^ 2 + v 0 ^ 2) * hfive

/-- The same matrix sends the standard four-frame to the four raw vectors checked by the q=5
relative-completeness certificate. -/
theorem q5FrameMatrix_maps_frame :
    q5StandardFrameVectors.map (q5FrameMatrix *ᵥ ·) = q5FrameWitness.map Subtype.val := by
  decide

/-- Strict-kernel verification that the transported C187 frame is an arc, is disjoint from the
standard conic, and covers every projective point outside it. -/
theorem q5_frame_check : check (K := ZMod 5) q5FrameWitness = true := by decide

/-- The corrected arithmetic threshold is exact at field order five. -/
theorem L2_five : L2 5 = 4 := by
  apply Nat.le_antisymm
  · apply Nat.sInf_le
    norm_num [L2Admissible, Nat.choose]
  · have hadm : L2Admissible 5 (L2 5) := by
      rw [L2]
      change sInf {k : ℕ | L2Admissible 5 k} ∈ {k : ℕ | L2Admissible 5 k}
      exact Nat.sInf_mem ⟨4, by norm_num [L2Admissible, Nat.choose]⟩
    by_contra h
    have hlt : L2 5 < 4 := by omega
    interval_cases hval : L2 5 <;>
      norm_num [L2Admissible, Nat.choose, hval] at hadm

/-- The projective four-frame gives the exact relative-conic value over `GF(5)`. -/
theorem rhoC_ZMod5 : rhoC (K := ZMod 5) = 4 := by
  apply Nat.le_antisymm
  · simpa [q5FrameWitness] using rhoC_le_length_of_check q5_frame_check
  · calc
      4 = L2 5 := L2_five.symm
      _ ≤ rhoC (K := ZMod 5) := by
        simpa using (NonsingularConic.standard (K := ZMod 5)).finite_lower_bound.2

/-- The exact value transported from the standard model to every nonsingular conic over
`GF(5)`, including the displayed C187 frame conic. -/
theorem rho_points_ZMod5 (C : NonsingularConic (K := ZMod 5)) :
    rho (L := Conic.Point (ZMod 5)) C.points = 4 := by
  rw [C.rho_points_eq_rhoC, rhoC_ZMod5]

#print axioms q5_frame_check
#print axioms q5FrameMatrix_maps_frame
#print axioms q5FrameMatrix_conicForm
#print axioms L2_five
#print axioms rhoC_ZMod5
#print axioms rho_points_ZMod5

end RelativeConicArcs.Examples
