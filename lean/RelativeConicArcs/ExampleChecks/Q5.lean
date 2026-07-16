import RelativeConicArcs.Certificate

namespace RelativeConicArcs.Examples

open Certificate

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

private instance : Fact (Nat.Prime 5) := ⟨by decide⟩

private def v5 (x y z : Nat) : Vec (ZMod 5) :=
  ![x, y, z]

/-- The C187 projective four-frame, transported to the standard conic `XZ - Y² = 0` by
the matrix with rows `(1,2,3)`, `(0,1,3)`, `(3,2,4)`.  That matrix has determinant `2` over
`ZMod 5` and carries the displayed quadratic
`X² + Y² + Z² + XY + XZ + YZ` to `3 * (XZ - Y²)`. -/
def q5FrameWitness : List (RawPoint (ZMod 5)) := [
  ⟨v5 1 0 3, by decide⟩,
  ⟨v5 2 1 2, by decide⟩,
  ⟨v5 3 3 4, by decide⟩,
  ⟨v5 1 4 4, by decide⟩]

/-- Strict-kernel verification that the transported C187 frame is an arc, is disjoint from the
standard conic, and covers every projective point outside it. -/
theorem q5_frame_check : check (K := ZMod 5) q5FrameWitness = true := by decide

end RelativeConicArcs.Examples
