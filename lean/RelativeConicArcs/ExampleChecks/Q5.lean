import RelativeConicArcs.Certificate

namespace RelativeConicArcs.Examples

open Certificate
open Conic

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

private instance : Fact (Nat.Prime 5) := ⟨by decide⟩
noncomputable local instance : Fintype (Conic.Point (ZMod 5)) := Fintype.ofFinite _
noncomputable local instance : DecidableEq (Conic.Point (ZMod 5)) := Classical.decEq _

private def v5 (x y z : Nat) : Vec (ZMod 5) :=
  ![x, y, z]

/-- The C187 projective four-frame, transported to the standard conic `XZ - Y² = 0` by
the matrix with rows `(1,2,3)`, `(0,1,3)`, `(3,2,4)`.  That matrix has determinant `2` over
`ZMod 5`; pulling back the standard equation gives a nonzero scalar multiple of the displayed
quadratic `X² + Y² + Z² + XY + XZ + YZ`. -/
def q5FrameWitness : List (RawPoint (ZMod 5)) := [
  ⟨v5 1 0 3, by decide⟩,
  ⟨v5 2 1 2, by decide⟩,
  ⟨v5 3 3 4, by decide⟩,
  ⟨v5 1 4 4, by decide⟩]

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
#print axioms L2_five
#print axioms rhoC_ZMod5
#print axioms rho_points_ZMod5

end RelativeConicArcs.Examples
