import Mathlib.Data.Fin.VecNotation
import Mathlib.Data.Fintype.Card
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.Ring

/-!
# Noncrossing matching cubics on six labelled points

For six labelled affine coordinates, a perfect matching determines the product
of its three pairwise differences.  This module fixes the five noncrossing
matchings in the standard cyclic order.  Their cubic evaluations are unchanged
by common translation and have weight three under common scaling.

The final theorems evaluate the representative `3+3` collision plane.  When
the first three coordinates coincide and the last three coordinates coincide,
four matching products vanish and the rainbow matching is the cube of the
difference between the two block values.  All statements are symbolic kernel
proofs over an arbitrary commutative ring.
-/

namespace RelativeConicArcs.GoldenMatchingCubics

/-- The affine bracket attached to two labelled coordinates. -/
def bracket {R : Type*} [Sub R] (x : Fin 6 → R) (i j : Fin 6) : R :=
  x i - x j

/--
The five cubic products belonging to the noncrossing perfect matchings of six
cyclically ordered labels.  Their order is fixed by the displayed vector and
is part of the coordinate convention.
-/
def matchingCubics {R : Type*} [CommRing R] (x : Fin 6 → R) : Fin 5 → R :=
  ![bracket x 0 1 * bracket x 2 3 * bracket x 4 5,
    bracket x 0 1 * bracket x 2 5 * bracket x 3 4,
    bracket x 0 3 * bracket x 1 2 * bracket x 4 5,
    bracket x 0 5 * bracket x 1 2 * bracket x 3 4,
    bracket x 0 5 * bracket x 1 4 * bracket x 2 3]

/-- Common translation of all six affine coordinates leaves every matching
cubic unchanged. -/
theorem matchingCubics_translate {R : Type*} [CommRing R]
    (x : Fin 6 → R) (t : R) :
    matchingCubics (fun i => x i + t) = matchingCubics x := by
  funext k
  fin_cases k <;> simp [matchingCubics, bracket]

/-- Common scaling of the six coordinates scales every matching cubic by the
third power of the scalar. -/
theorem matchingCubics_scale {R : Type*} [CommRing R]
    (x : Fin 6 → R) (s : R) :
    matchingCubics (fun i => s * x i) =
      fun k => s ^ 3 * matchingCubics x k := by
  funext k
  fin_cases k <;> simp [matchingCubics, bracket] <;> ring

/-- The five matching cubics transform with affine weight three. -/
theorem matchingCubics_affine {R : Type*} [CommRing R]
    (x : Fin 6 → R) (s t : R) :
    matchingCubics (fun i => s * x i + t) =
      fun k => s ^ 3 * matchingCubics x k := by
  rw [show (fun i => s * x i + t) = (fun i => (fun j => s * x j) i + t) by rfl]
  rw [matchingCubics_translate, matchingCubics_scale]

/-- A standard point of the collision plane with blocks `{0,1,2}` and
`{3,4,5}`. -/
def threeThreePoint {R : Type*} (u v : R) : Fin 6 → R :=
  ![u, u, u, v, v, v]

/-- On the standard `3+3` collision plane, only the rainbow matching can be
nonzero. -/
theorem matchingCubics_threeThreePoint {R : Type*} [CommRing R] (u v : R) :
    matchingCubics (threeThreePoint u v) =
      ![0, 0, 0, 0, (u - v) ^ 3] := by
  ext k
  fin_cases k <;> simp [matchingCubics, bracket, threeThreePoint]
  ring

/-- Coordinate-equality hypothesis form of the same labelled `3+3`
collision evaluation. -/
theorem matchingCubics_eq_rainbow_of_threeThree {R : Type*} [CommRing R]
    (x : Fin 6 → R) (h01 : x 0 = x 1) (h12 : x 1 = x 2)
    (h34 : x 3 = x 4) (h45 : x 4 = x 5) :
    matchingCubics x = ![0, 0, 0, 0, (x 2 - x 5) ^ 3] := by
  ext k
  fin_cases k <;>
    simp [matchingCubics, bracket, h01, h12, h34, h45]
  ring

end RelativeConicArcs.GoldenMatchingCubics
