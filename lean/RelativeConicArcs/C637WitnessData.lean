import RelativeConicArcs.Certificate

/-!
# C637 upper-witness data

The `q = 13` and `q = 17` checked lists are the C637 witnesses after explicit invertible
coordinate changes.  The `q = 19` list already avoids the standard conic.  Rules-only checks are
split into small downstream leaves so kernel reduction stays within the measured memory envelope.
-/

namespace RelativeConicArcs
namespace C637WitnessData

open Certificate Conic

set_option maxHeartbeats 200000000
set_option maxRecDepth 100000

private instance : Fact (Nat.Prime 13) := ⟨by decide⟩
private instance : Fact (Nat.Prime 17) := ⟨by decide⟩
private instance : Fact (Nat.Prime 19) := ⟨by decide⟩

private def v13 (x y z : Nat) : Vec (ZMod 13) := ![x, y, z]
private def v17 (x y z : Nat) : Vec (ZMod 17) := ![x, y, z]
private def v19 (x y z : Nat) : Vec (ZMod 19) := ![x, y, z]

def q13Witness : List (RawPoint (ZMod 13)) := [
  ⟨v13 4 0 5, by decide⟩,
  ⟨v13 3 12 7, by decide⟩,
  ⟨v13 2 3 10, by decide⟩,
  ⟨v13 9 2 9, by decide⟩,
  ⟨v13 7 1 0, by decide⟩,
  ⟨v13 6 0 2, by decide⟩,
  ⟨v13 8 12 11, by decide⟩,
  ⟨v13 7 11 0, by decide⟩]

def q17Witness : List (RawPoint (ZMod 17)) := [
  ⟨v17 0 11 0, by decide⟩,
  ⟨v17 0 8 1, by decide⟩,
  ⟨v17 3 5 15, by decide⟩,
  ⟨v17 3 7 16, by decide⟩,
  ⟨v17 3 3 0, by decide⟩,
  ⟨v17 3 0 1, by decide⟩,
  ⟨v17 3 7 2, by decide⟩,
  ⟨v17 3 12 7, by decide⟩,
  ⟨v17 3 16 14, by decide⟩]

def q19Witness : List (RawPoint (ZMod 19)) := [
  ⟨v19 0 1 8, by decide⟩,
  ⟨v19 1 1 0, by decide⟩,
  ⟨v19 1 3 14, by decide⟩,
  ⟨v19 1 9 0, by decide⟩,
  ⟨v19 1 9 12, by decide⟩,
  ⟨v19 1 11 11, by decide⟩,
  ⟨v19 1 13 9, by decide⟩,
  ⟨v19 1 16 1, by decide⟩,
  ⟨v19 1 16 12, by decide⟩,
  ⟨v19 1 18 7, by decide⟩]

def q13OriginalVectors : List (Vec (ZMod 13)) := [
  v13 0 0 1, v13 0 1 0, v13 1 0 0, v13 1 1 1,
  v13 1 2 3, v13 1 3 2, v13 1 4 5, v13 1 5 4]

def q17OriginalVectors : List (Vec (ZMod 17)) := [
  v17 0 0 1, v17 0 1 0, v17 1 0 0, v17 1 1 1, v17 1 2 3,
  v17 1 3 2, v17 1 4 5, v17 1 9 8, v17 1 16 11]

def q13Normalization : Matrix (Fin 3) (Fin 3) (ZMod 13) :=
  ![![2, 3, 4], ![3, 12, 0], ![10, 7, 5]]

def q17Normalization : Matrix (Fin 3) (Fin 3) (ZMod 17) :=
  ![![3, 0, 0], ![5, 8, 11], ![15, 1, 0]]

def q13DisplayedQuadratic (v : Vec (ZMod 13)) : ZMod 13 :=
  6 * v 0 ^ 2 + 5 * v 1 ^ 2 + 5 * v 2 ^ 2 +
    6 * v 0 * v 1 + 6 * v 0 * v 2 + v 1 * v 2

def q17DisplayedQuadratic (v : Vec (ZMod 17)) : ZMod 17 :=
  8 * v 0 ^ 2 + 5 * v 1 ^ 2 + 6 * v 2 ^ 2 +
    10 * v 0 * v 1 + 7 * v 0 * v 2 + v 1 * v 2

theorem q13Normalization_det : q13Normalization.det = 4 := by decide

theorem q17Normalization_det : q17Normalization.det = 1 := by decide

theorem q13Normalization_maps :
    q13OriginalVectors.map (fun v => Matrix.mulVec q13Normalization v) =
      q13Witness.map Subtype.val := by decide

theorem q17Normalization_maps :
    q17OriginalVectors.map (fun v => Matrix.mulVec q17Normalization v) =
      q17Witness.map Subtype.val := by decide

theorem q13Normalization_conicForm (v : Vec (ZMod 13)) :
    ProjectiveCap.Sym2Bridge.conicForm (Matrix.mulVec q13Normalization v) =
      9 * q13DisplayedQuadratic v := by
  simp [q13Normalization, q13DisplayedQuadratic, ProjectiveCap.Sym2Bridge.conicForm,
    Matrix.mulVec, dotProduct, Fin.sum_univ_succ]
  have hthirteen : (13 : ZMod 13) = 0 := by decide
  linear_combination
    (-2 * v 0 * v 1 - 8 * v 0 * v 2 - 5 * v 0 ^ 2 -
      4 * v 1 * v 2 + 6 * v 1 ^ 2 - 5 * v 2 ^ 2) * hthirteen

theorem q17Normalization_conicForm (v : Vec (ZMod 17)) :
    ProjectiveCap.Sym2Bridge.conicForm (Matrix.mulVec q17Normalization v) =
      6 * q17DisplayedQuadratic v := by
  simp [q17Normalization, q17DisplayedQuadratic, ProjectiveCap.Sym2Bridge.conicForm,
    Matrix.mulVec, dotProduct, Fin.sum_univ_succ]
  have hseventeen : (17 : ZMod 17) = 0 := by decide
  linear_combination
    (v 0 * v 1 + 4 * v 0 * v 2 - 4 * v 0 ^ 2 +
      10 * v 1 * v 2 + 2 * v 1 ^ 2 + 5 * v 2 ^ 2) * hseventeen

end C637WitnessData
end RelativeConicArcs
