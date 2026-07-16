import RelativeConicArcs.Q11BrianchonPetersen

/-!
# The compact `A3/H3` reflection-arrangement bridge

This file kernel-checks the coordinate layer used in the Clebsch paper's reflection-arrangement
synthesis.  It deliberately uses small transparent tables and the existing Brianchon and decoder
theorems; there is no generated certificate tree.
-/

namespace RelativeConicArcs.Examples.ReflectionArrangements

open Certificate Matrix
open RelativeConicArcs.Examples.Q11Coding
open RelativeConicArcs.Examples.Q11BrianchonPetersen

set_option maxHeartbeats 30000000
set_option maxRecDepth 100000

private instance : Fact (Nat.Prime 11) := ⟨by decide⟩
private instance : Fact (Nat.Prime 5) := ⟨by decide⟩

abbrev Point11 := Vec (ZMod 11)
abbrev Point5 := Vec (ZMod 5)

/-- Projective equality for concrete coordinate vectors. -/
def SameDirection {K : Type*} [Field K] (u v : Fin 3 → K) : Prop :=
  ∃ a : K, a ≠ 0 ∧ a • u = v

instance {K : Type*} [Field K] [Fintype K] [DecidableEq K] (u v : Fin 3 → K) :
    Decidable (SameDirection u v) := by
  unfold SameDirection
  infer_instance

/-- Cross product, used for both joins of points and intersections of line normals. -/
def cross {K : Type*} [CommRing K] (u v : Fin 3 → K) : Fin 3 → K :=
  ![
    u 1 * v 2 - u 2 * v 1,
    u 2 * v 0 - u 0 * v 2,
    u 0 * v 1 - u 1 * v 0
  ]

def dot {K : Type*} [CommRing K] (u v : Fin 3 → K) : K :=
  u 0 * v 0 + u 1 * v 1 + u 2 * v 2

/-! ## The `H3` reduction over `F_11` -/

def tau11 : ZMod 11 := 8

theorem tau11_relation : tau11 ^ 2 = tau11 + 1 := by decide

/-- The six displayed fivefold points, ordered so that the projectivity lands on `witnessVec`. -/
def h3FivefoldPoint (i : Fin 6) : Point11 :=
  ![
    ![0, 1, 1 - tau11],
    ![0, 1, tau11 - 1],
    ![1, 1 - tau11, 0],
    ![1, tau11 - 1, 0],
    ![1, 0, tau11],
    ![1, 0, -tau11]
  ] i

/-- The fifteen unordered pairs of the six fivefold points. -/
def h3Pair (i : Fin 15) : Fin 6 × Fin 6 := chordEdge i

/-- The fifteen joins of the displayed fivefold points. -/
def h3Join (i : Fin 15) : Point11 :=
  cross (h3FivefoldPoint (h3Pair i).1) (h3FivefoldPoint (h3Pair i).2)

def h3Joins : Finset Point11 := Finset.univ.image h3Join

/-- The specialized positive-root directions obtained from
`(1,0,0)`, `(0,1,0)`, `(0,0,1)`, and cyclic permutations of
`(1, ±tau11, ±(tau11-1))`. -/
def h3RootDirection (i : Fin 15) : Point11 :=
  ![
    ![0, 0, 1], ![0, 1, 0], ![1, 0, 0],
    ![1, 3, 2], ![1, 3, 4], ![1, 3, 7], ![1, 3, 9],
    ![1, 5, 4], ![1, 5, 7], ![1, 6, 4], ![1, 6, 7],
    ![1, 8, 2], ![1, 8, 4], ![1, 8, 7], ![1, 8, 9]
  ] i

def h3RootDirections : Finset Point11 := Finset.univ.image h3RootDirection

/-- The six fivefold points form an arc. -/
theorem h3_fivefold_points_arc :
    ∀ i j k : Fin 6, i ≠ j → i ≠ k → j ≠ k →
      Matrix.det ![h3FivefoldPoint i, h3FivefoldPoint j, h3FivefoldPoint k] ≠ 0 := by
  intro i j k hij hik hjk
  fin_cases i <;> fin_cases j <;> fin_cases k <;> simp_all [h3FivefoldPoint, tau11] <;> decide

/-- Joining the six fivefold points recovers exactly the fifteen displayed `H3` mirrors,
up to the harmless scalar choice of line normal. -/
theorem h3_joins_are_root_directions :
    h3Joins.card = 15 ∧ h3RootDirections.card = 15 ∧
      (∀ i : Fin 15, ∃ j : Fin 15, SameDirection (h3Join i) (h3RootDirection j)) ∧
      (∀ j : Fin 15, ∃ i : Fin 15, SameDirection (h3Join i) (h3RootDirection j)) := by
  refine ⟨by decide, by decide, ?_, ?_⟩
  · intro i
    fin_cases i <;> first | exact ⟨0, by decide⟩ | exact ⟨1, by decide⟩ |
      exact ⟨2, by decide⟩ | exact ⟨3, by decide⟩ | exact ⟨4, by decide⟩ |
      exact ⟨5, by decide⟩ | exact ⟨6, by decide⟩ | exact ⟨7, by decide⟩ |
      exact ⟨8, by decide⟩ | exact ⟨9, by decide⟩ | exact ⟨10, by decide⟩ |
      exact ⟨11, by decide⟩ | exact ⟨12, by decide⟩ | exact ⟨13, by decide⟩ |
      exact ⟨14, by decide⟩
  · intro j
    fin_cases j <;> first | exact ⟨0, by decide⟩ | exact ⟨1, by decide⟩ |
      exact ⟨2, by decide⟩ | exact ⟨3, by decide⟩ | exact ⟨4, by decide⟩ |
      exact ⟨5, by decide⟩ | exact ⟨6, by decide⟩ | exact ⟨7, by decide⟩ |
      exact ⟨8, by decide⟩ | exact ⟨9, by decide⟩ | exact ⟨10, by decide⟩ |
      exact ⟨11, by decide⟩ | exact ⟨12, by decide⟩ | exact ⟨13, by decide⟩ |
      exact ⟨14, by decide⟩

/-- The manuscript's projectivity `T`. -/
def h3Projectivity (p : Point11) : Point11 :=
  ![
    2 * p 0 + 3 * p 1 + 8 * p 2,
    10 * p 0 + 6 * p 1 + 9 * p 2,
    2 * p 0 + 2 * p 1 + 5 * p 2
  ]

/-- The row-vector dual action by the displayed inverse of `T`. -/
def h3DualProjectivity (l : Point11) : Point11 :=
  ![
    4 * l 0 + 4 * l 1 + 10 * l 2,
    4 * l 0 + 9 * l 1 + 8 * l 2,
    4 * l 0 + 6 * l 1 + 5 * l 2
  ]

theorem h3_projectivity_det :
    Matrix.det (![![2, 3, 8], ![10, 6, 9], ![2, 2, 5]] : Matrix (Fin 3) (Fin 3) (ZMod 11)) = 3 := by
  decide

theorem h3_projectivity_maps_fivefold_points (i : Fin 6) :
    SameDirection (h3Projectivity (h3FivefoldPoint i)) (witnessVec i) := by
  fin_cases i <;> decide

/-- The induced dual projectivity takes each `H3` join to the corresponding Clebsch secant. -/
theorem h3_dual_projectivity_maps_mirrors (i : Fin 15) :
    SameDirection (h3DualProjectivity (h3Join i)) (rawChordLine (chordEdge i)) := by
  fin_cases i <;> decide

/-- Multiplicity of a canonical projective point in the reduced `H3` arrangement. -/
def h3Multiplicity (p : Fin 133) : ℕ :=
  (Finset.univ.filter fun i : Fin 15 => dot (h3Join i) (projectiveVec p) = 0).card

def h3PointsOfMultiplicity (m : ℕ) : Finset (Fin 133) :=
  Finset.univ.filter fun p => h3Multiplicity p = m

/-- Canonical projective indices of the six displayed fivefold points. -/
def h3FivefoldIndex (i : Fin 6) : Fin 133 :=
  ![⟨125, by omega⟩, ⟨128, by omega⟩, ⟨44, by omega⟩,
    ⟨77, by omega⟩, ⟨8, by omega⟩, ⟨3, by omega⟩] i

theorem h3_fivefold_index_vec (i : Fin 6) :
    projectiveVec (h3FivefoldIndex i) = h3FivefoldPoint i := by
  fin_cases i <;> decide

theorem h3_fivefold_points_exact :
    h3PointsOfMultiplicity 5 = Finset.univ.image h3FivefoldIndex := by
  decide

/-- The complete projective multiplicity spectrum `6_5,10_3,15_2`, with 90 ordinary mirror
points and 12 complement points. -/
theorem h3_intersection_spectrum :
    (h3PointsOfMultiplicity 0).card = 12 ∧
    (h3PointsOfMultiplicity 1).card = 90 ∧
    (h3PointsOfMultiplicity 2).card = 15 ∧
    (h3PointsOfMultiplicity 3).card = 10 ∧
    (h3PointsOfMultiplicity 5).card = 6 := by
  decide

/-- In characteristic two the sign distinction used by the displayed `H3` model collapses, and
the golden-ratio equation has no solution in `F_2`. -/
theorem h3_characteristic_two_boundary :
    (-1 : ZMod 2) = 1 ∧ ¬∃ tau : ZMod 2, tau ^ 2 = tau + 1 := by
  decide

/-- The modular golden-ratio parameter in characteristic five. -/
def tau5 : ZMod 5 := 3

theorem tau5_relation : tau5 ^ 2 = tau5 + 1 := by decide

/-- The fifteen reduced `H3` roots at `tau=3` in characteristic five. -/
def h3RootDirection5 (i : Fin 15) : Point5 :=
  ![
    ![0, 0, 1], ![0, 1, 0], ![1, 0, 0],
    ![1, 2, 1], ![1, 2, 2], ![1, 2, 3], ![1, 2, 4],
    ![1, 3, 1], ![1, 3, 2], ![1, 3, 3], ![1, 3, 4],
    ![1, 4, 2], ![1, 4, 3], ![1, 1, 2], ![1, 1, 3]
  ] i

/-- Canonical representatives of the 31 points of `PG(2,5)`. -/
def projectiveVec5 (i : Fin 31) : Point5 :=
  if _h₁ : i.1 < 25 then
    ![1, ((i.1 / 5 : ℕ) : ZMod 5), ((i.1 % 5 : ℕ) : ZMod 5)]
  else if _h₂ : i.1 < 30 then
    ![0, 1, ((i.1 - 25 : ℕ) : ZMod 5)]
  else ![0, 0, 1]

def h3Multiplicity5 (p : Fin 31) : ℕ :=
  (Finset.univ.filter fun i : Fin 15 => dot (h3RootDirection5 i) (projectiveVec5 p) = 0).card

def h3PointsOfMultiplicity5 (m : ℕ) : Finset (Fin 31) :=
  Finset.univ.filter fun p => h3Multiplicity5 p = m

/-- Characteristic five is lattice-faithful: all 31 projective points are singular, with the same
`6_5,10_3,15_2` ledger. -/
theorem h3_characteristic_five_spectrum :
    (h3PointsOfMultiplicity5 2).card = 15 ∧
    (h3PointsOfMultiplicity5 3).card = 10 ∧
    (h3PointsOfMultiplicity5 5).card = 6 := by
  decide

/-! ## The `A3` four-frame reduction over `F_5` -/

def a3FramePoint (i : Fin 4) : Point5 :=
  ![![1, 0, 0], ![0, 1, 0], ![0, 0, 1], ![1, 1, 1]] i

def a3Pair (i : Fin 6) : Fin 4 × Fin 4 :=
  ![(0, 1), (0, 2), (0, 3), (1, 2), (1, 3), (2, 3)] i

def a3Join (i : Fin 6) : Point5 :=
  cross (a3FramePoint (a3Pair i).1) (a3FramePoint (a3Pair i).2)

/-- The six essentialized braid mirrors `X,Y,Z,X-Y,X-Z,Y-Z`. -/
def a3RootDirection (i : Fin 6) : Point5 :=
  ![![1, 0, 0], ![0, 1, 0], ![0, 0, 1], ![1, -1, 0], ![1, 0, -1], ![0, 1, -1]] i

theorem a3_frame_joins_are_braid_mirrors :
    ∀ i : Fin 6, ∃ j : Fin 6, SameDirection (a3Join i) (a3RootDirection j) := by
  intro i
  fin_cases i <;> first | exact ⟨0, by decide⟩ | exact ⟨1, by decide⟩ |
    exact ⟨2, by decide⟩ | exact ⟨3, by decide⟩ | exact ⟨4, by decide⟩ |
    exact ⟨5, by decide⟩

def a3Multiplicity (p : Fin 31) : ℕ :=
  (Finset.univ.filter fun i : Fin 6 => dot (a3Join i) (projectiveVec5 p) = 0).card

def a3PointsOfMultiplicity (m : ℕ) : Finset (Fin 31) :=
  Finset.univ.filter fun p => a3Multiplicity p = m

theorem a3_intersection_spectrum :
    (a3PointsOfMultiplicity 0).card = 6 ∧
    (a3PointsOfMultiplicity 1).card = 18 ∧
    (a3PointsOfMultiplicity 2).card = 3 ∧
    (a3PointsOfMultiplicity 3).card = 4 := by
  decide

/-! ## Characteristic-polynomial and conic-size arithmetic -/

theorem h3_mobius_sum : 6 * (5 - 1) + 10 * (3 - 1) + 15 * (2 - 1) = 59 := by norm_num

theorem h3_characteristic_polynomial (t : ℤ) :
    t ^ 3 - 15 * t ^ 2 + 59 * t - 45 = (t - 1) * (t - 5) * (t - 9) := by ring

theorem a3_characteristic_polynomial (t : ℤ) :
    t ^ 3 - 6 * t ^ 2 + 11 * t - 6 = (t - 1) * (t - 2) * (t - 3) := by ring

theorem h3_conic_size_factorization (q : ℤ) :
    (q - 5) * (q - 9) - (q + 1) = (q - 4) * (q - 11) := by ring

theorem a3_conic_size_factorization (q : ℤ) :
    (q - 2) * (q - 3) - (q + 1) = (q - 1) * (q - 5) := by ring

#print axioms tau11_relation
#print axioms h3_fivefold_points_arc
#print axioms h3_joins_are_root_directions
#print axioms h3_projectivity_maps_fivefold_points
#print axioms h3_dual_projectivity_maps_mirrors
#print axioms h3_intersection_spectrum
#print axioms h3_fivefold_points_exact
#print axioms h3_characteristic_two_boundary
#print axioms h3_characteristic_five_spectrum
#print axioms a3_intersection_spectrum

end RelativeConicArcs.Examples.ReflectionArrangements
