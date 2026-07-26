import RelativeConicArcs.Certificate

/-!
# A nine-point Heisenberg pair over the field of order nineteen

This module checks the compact algebraic structure of two explicit nine-point sets in the
projective plane over `ZMod 19`.  Two projective transformations generate a regular
`C₃ × C₃` action on each set.  Their linear lifts have a primitive cube-root commutator, and the
two sets lie on distinct cubic semi-invariants with the same character.  One quadratic form
contains six points of the second set and one point of the first, but misses another specified
point of the second set.

The declarations check only this fixed coordinate configuration by kernel reduction and symbolic
ring calculation.  They do not assert that the pair is unique among projective arcs or that it is
an exhaustive obstruction in any finite classification.
-/

namespace RelativeConicArcs
namespace NinePointHeisenbergPair

open Certificate

set_option maxHeartbeats 200000000
set_option maxRecDepth 100000

abbrev K := ZMod 19
abbrev V := Fin 3 → K
abbrev M := Matrix (Fin 3) (Fin 3) K

private instance : Fact (Nat.Prime 19) := ⟨by decide⟩

private def v (x y z : Nat) : V := ![x, y, z]

def selected : List V := [
  v 0 0 1, v 0 1 0, v 1 0 0, v 1 1 1, v 1 2 3,
  v 1 3 11, v 1 4 9, v 1 13 7, v 1 14 15]

def uncovered : List V := [
  v 1 6 10, v 1 6 18, v 1 10 4, v 1 11 16, v 1 15 2,
  v 1 15 18, v 1 16 6, v 1 16 10, v 1 18 4]

def g : M := ![![0, 0, 1], ![3, 0, 0], ![0, 11, 0]]

def h : M := ![![1, 7, 1], ![2, 7, 3], ![3, 7, 11]]

/-- Executable projective containment of every image ray in the same list of rays. -/
def mapsRaysInto (matrix : M) (points : List V) : Bool :=
  points.all fun x => points.any fun y => rayEq (Matrix.mulVec matrix x) y

/-- Executable ray containment between two finite coordinate lists. -/
def raysContained (source target : List V) : Bool :=
  source.all fun x => target.any fun y => rayEq x y

def sameRays (left right : List V) : Bool :=
  raysContained left right && raysContained right left

def heisenbergOrbit (p : V) : List V := [
  p,
  Matrix.mulVec g p,
  Matrix.mulVec (g ^ 2) p,
  Matrix.mulVec h p,
  Matrix.mulVec (g * h) p,
  Matrix.mulVec (g ^ 2 * h) p,
  Matrix.mulVec (h ^ 2) p,
  Matrix.mulVec (g * h ^ 2) p,
  Matrix.mulVec (g ^ 2 * h ^ 2) p]

/-- The first generator has projective order three. -/
theorem g_cube : g ^ 3 = 14 • (1 : M) := by decide

/-- The second generator has projective order three. -/
theorem h_cube : h ^ 3 = 15 • (1 : M) := by decide

/-- The two lifts commute projectively with primitive cube-root multiplier `11`. -/
theorem heisenberg_commutator : g * h = 11 • (h * g) := by decide

theorem cubeRoot_relation : (11 : K) ^ 2 + 11 + 1 = 0 := by decide

theorem cubeRoot_ne_one : (11 : K) ≠ 1 := by decide

theorem g_maps_selected : mapsRaysInto g selected = true := by decide

theorem h_maps_selected : mapsRaysInto h selected = true := by decide

theorem g_maps_uncovered : mapsRaysInto g uncovered = true := by decide

theorem h_maps_uncovered : mapsRaysInto h uncovered = true := by decide

theorem selected_is_heisenbergOrbit :
    sameRays (heisenbergOrbit (v 0 0 1)) selected = true := by decide

theorem uncovered_is_heisenbergOrbit :
    sameRays (heisenbergOrbit (v 1 6 10)) uncovered = true := by decide

def selectedCubic (p : V) : K :=
  p 0 ^ 2 * p 1 + 2 * p 0 ^ 2 * p 2 +
  p 1 ^ 2 * p 0 + 13 * p 1 ^ 2 * p 2 +
  7 * p 2 ^ 2 * p 0 + 7 * p 2 ^ 2 * p 1 +
  7 * p 0 * p 1 * p 2

def uncoveredCubic (p : V) : K :=
  p 0 ^ 3 + 16 * p 1 ^ 3 + 15 * p 2 ^ 3 +
  3 * p 0 ^ 2 * p 1 + 6 * p 0 ^ 2 * p 2 +
  3 * p 1 ^ 2 * p 0 + p 1 ^ 2 * p 2 +
  2 * p 2 ^ 2 * p 0 + 2 * p 2 ^ 2 * p 1 +
  p 0 * p 1 * p 2

def allVanish (form : V → K) (points : List V) : Bool :=
  points.all fun p => decide (form p = 0)

theorem selected_on_selectedCubic : allVanish selectedCubic selected = true := by decide

theorem uncovered_on_uncoveredCubic :
    allVanish uncoveredCubic uncovered = true := by decide

theorem selectedCubic_g (p : V) :
    selectedCubic (Matrix.mulVec g p) = 14 * selectedCubic p := by
  simp [selectedCubic, g, Matrix.mulVec, dotProduct, Fin.sum_univ_succ]
  have hnineteen : (19 : K) = 0 := by decide
  linear_combination
    (67 * p 0 ^ 2 * p 1 - p 0 ^ 2 * p 2 +
      133 * p 0 * p 1 ^ 2 + 35 * p 1 ^ 2 * p 2 -
      5 * p 0 * p 2 ^ 2 - 4 * p 1 * p 2 ^ 2 +
      7 * p 0 * p 1 * p 2) * hnineteen

theorem uncoveredCubic_g (p : V) :
    uncoveredCubic (Matrix.mulVec g p) = 14 * uncoveredCubic p := by
  simp [uncoveredCubic, g, Matrix.mulVec, dotProduct, Fin.sum_univ_succ]
  have hnineteen : (19 : K) = 0 := by decide
  linear_combination
    (22 * p 0 ^ 3 + 1039 * p 1 ^ 3 - 11 * p 2 ^ 3 +
      3 * p 0 ^ 2 * p 1 - 3 * p 0 ^ 2 * p 2 +
      36 * p 0 * p 1 ^ 2 + 12 * p 1 ^ 2 * p 2 -
      p 0 * p 2 ^ 2 + 2 * p 1 * p 2 ^ 2 +
      p 0 * p 1 * p 2) * hnineteen

theorem selectedCubic_h (p : V) :
    selectedCubic (Matrix.mulVec h p) = 15 * selectedCubic p := by
  simp [selectedCubic, h, Matrix.mulVec, dotProduct, Fin.sum_univ_succ]
  have hnineteen : (19 : K) = 0 := by decide
  linear_combination
    (21 * p 0 ^ 3 + 686 * p 1 ^ 3 + 260 * p 2 ^ 3 +
      207 * p 0 ^ 2 * p 1 + 156 * p 0 ^ 2 * p 2 +
      662 * p 0 * p 1 ^ 2 + 1795 * p 1 ^ 2 * p 2 +
      362 * p 0 * p 2 ^ 2 + 1351 * p 1 * p 2 ^ 2 +
      1085 * p 0 * p 1 * p 2) * hnineteen

theorem uncoveredCubic_h (p : V) :
    uncoveredCubic (Matrix.mulVec h p) = 15 * uncoveredCubic p := by
  simp [uncoveredCubic, h, Matrix.mulVec, dotProduct, Fin.sum_univ_succ]
  have hnineteen : (19 : K) = 0 := by decide
  linear_combination
    (33 * p 0 ^ 3 + 890 * p 1 ^ 3 + 1125 * p 2 ^ 3 +
      285 * p 0 ^ 2 * p 1 + 300 * p 0 ^ 2 * p 2 +
      859 * p 0 * p 1 ^ 2 + 2279 * p 1 ^ 2 * p 2 +
      994 * p 0 * p 2 ^ 2 + 2528 * p 1 * p 2 ^ 2 +
      1621 * p 0 * p 1 * p 2) * hnineteen

def sixPointConic (p : V) : K :=
  p 0 ^ 2 + 4 * p 1 ^ 2 + 5 * p 2 ^ 2 +
  15 * p 0 * p 1 + 3 * p 0 * p 2 + 11 * p 1 * p 2

theorem sixPointConic_values :
    (uncovered.take 5).map sixPointConic = [0, 0, 0, 0, 0] ∧
    sixPointConic (v 1 18 4) = 0 ∧
    sixPointConic (v 1 3 11) = 0 ∧
    sixPointConic (v 1 15 18) = 13 := by decide

end NinePointHeisenbergPair
end RelativeConicArcs
