import RelativeConicArcs.Q11BrianchonPetersen

/-!
# Coordinate tables for the `A3`/`H3` reflection-arrangement synthesis

This file records explicit projective-coordinate tables over the finite fields `ZMod 11`, `ZMod 5`,
and `ZMod 2`, and kernel-checks finite incidence, determinant, and projective-map identities about
them by `decide`/`fin_cases`, together with a few integer polynomial identities by `ring`/`norm_num`.
There is no generated certificate tree.

Conventions.  A projective point or line is a vector in `Fin 3 → K`; `SameDirection u v` means
`v = a • u` for some nonzero `a`, i.e. projective equality; `cross` and `dot` are the triple product
and dot product.  Projective points of `PG(2,11)` and `PG(2,5)` are the fixed
first-nonzero-coordinate-normalized enumerations `projectiveVec` and `projectiveVec5`.

Scope and trust boundary.  Lean here checks coordinate tables and arithmetic only.  The identification
of the fifteen `ZMod 11` directions with the projectivized `H3` reflection arrangement, of the
four-point `ZMod 5` frame with the essentialized `A3` reflection arrangement, and of the displayed
polynomials with those arrangements' characteristic polynomials (roots `1 +` the exponents
`{1,5,9}` for `H3`, `{1,2,3}` for `A3`) is classical arrangement theory (Orlik & Terao,
*Arrangements of Hyperplanes*, 1992), not proved in this file.  The terminal results are the `tau`
relations, the fivefold-arc and line-coincidence theorems, the projectivity row identities, the
`H3` and `A3` incidence spectra, the pointwise incidence-index equality, and the integer identities;
each carries a `#print axioms` probe at the end of the file.
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

/-- Dot product of two coordinate 3-vectors; `dot l p = 0` expresses incidence of the point `p`
with the line whose normal is `l`. -/
def dot {K : Type*} [CommRing K] (u v : Fin 3 → K) : K :=
  u 0 * v 0 + u 1 * v 1 + u 2 * v 2

/-! ## The `H3` reduction over `F_11` -/

/-- The chosen root of `x^2 = x + 1` in `ZMod 11`, used as the projectivized-`H3` golden-ratio
parameter. -/
def tau11 : ZMod 11 := 8

/-- The chosen parameter satisfies the golden-ratio relation `tau^2 = tau + 1` in `ZMod 11`. -/
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

/-- The fifteen join-lines as a finite set of normalized directions. -/
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

/-- The fifteen displayed root directions as a finite set. -/
def h3RootDirections : Finset Point11 := Finset.univ.image h3RootDirection

/-- The six fivefold points form an arc. -/
theorem h3_fivefold_points_arc :
    ∀ i j k : Fin 6, i ≠ j → i ≠ k → j ≠ k →
      Matrix.det ![h3FivefoldPoint i, h3FivefoldPoint j, h3FivefoldPoint k] ≠ 0 := by
  intro i j k hij hik hjk
  fin_cases i <;> fin_cases j <;> fin_cases k <;> simp_all [h3FivefoldPoint, tau11] <;> decide

/-- The fifteen joins of the six fivefold points and the fifteen displayed root directions are equal
as projective sets: both have cardinality fifteen and each join matches some displayed direction
under `SameDirection` and conversely. -/
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

/-- The displayed 3×3 map `T` over `ZMod 11`, acting on column coordinate vectors. -/
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

/-- The displayed matrix of `T` has determinant `3` in `ZMod 11`. This is the only invertibility
fact proved here; `T` is not packaged as a linear or projective bijection. -/
theorem h3_projectivity_det :
    Matrix.det (![![2, 3, 8], ![10, 6, 9], ![2, 2, 5]] : Matrix (Fin 3) (Fin 3) (ZMod 11)) = 3 := by
  decide

/-- `T` sends each of the six fivefold points to the corresponding Clebsch witness column, under
projective equality. -/
theorem h3_projectivity_maps_fivefold_points (i : Fin 6) :
    SameDirection (h3Projectivity (h3FivefoldPoint i)) (witnessVec i) := by
  fin_cases i <;> decide

/-- The displayed dual map takes each join-line to the corresponding Clebsch secant line, under
projective equality. -/
theorem h3_dual_projectivity_maps_mirrors (i : Fin 15) :
    SameDirection (h3DualProjectivity (h3Join i)) (rawChordLine (chordEdge i)) := by
  fin_cases i <;> decide

/-- For each of the 133 normalized points of `PG(2,11)`, the incidence count with the fifteen
join-lines equals `rawPointIndex` of the displayed image `h3Projectivity (projectiveVec p)`. This is
a pointwise equality of two explicit functions; it does not package `T` as a bijection or identify
the decoder strata. -/
theorem h3_multiplicity_eq_rawPointIndex :
    ∀ p : Fin 133,
      (Finset.univ.filter fun i : Fin 15 => dot (h3Join i) (projectiveVec p) = 0).card =
        rawPointIndex (h3Projectivity (projectiveVec p)) := by
  decide

/-- Incidence count of the normalized projective point `projectiveVec p` with the fifteen
join-lines. -/
def h3Multiplicity (p : Fin 133) : ℕ :=
  (Finset.univ.filter fun i : Fin 15 => dot (h3Join i) (projectiveVec p) = 0).card

/-- The normalized `PG(2,11)` points whose incidence count with the fifteen join-lines equals `m`. -/
def h3PointsOfMultiplicity (m : ℕ) : Finset (Fin 133) :=
  Finset.univ.filter fun p => h3Multiplicity p = m

/-- Indices in the normalized `PG(2,11)` enumeration `projectiveVec` of the six displayed fivefold
points. -/
def h3FivefoldIndex (i : Fin 6) : Fin 133 :=
  ![⟨125, by omega⟩, ⟨128, by omega⟩, ⟨44, by omega⟩,
    ⟨77, by omega⟩, ⟨8, by omega⟩, ⟨3, by omega⟩] i

/-- Each fivefold index picks out the corresponding fivefold point under `projectiveVec`. -/
theorem h3_fivefold_index_vec (i : Fin 6) :
    projectiveVec (h3FivefoldIndex i) = h3FivefoldPoint i := by
  fin_cases i <;> decide

/-- The incidence-five locus is exactly the image of the six fivefold indices. -/
theorem h3_fivefold_points_exact :
    h3PointsOfMultiplicity 5 = Finset.univ.image h3FivefoldIndex := by
  decide

/-- Incidence spectrum over the 133 normalized points of `PG(2,11)`: twelve points on no line, ninety
on one, fifteen on two, ten on three, six on five (the five cardinalities sum to 133). -/
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

/-- The chosen root of `x^2 = x + 1` in `ZMod 5`. -/
def tau5 : ZMod 5 := 3

/-- The chosen parameter satisfies the golden-ratio relation `tau^2 = tau + 1` in `ZMod 5`. -/
theorem tau5_relation : tau5 ^ 2 = tau5 + 1 := by decide

/-- The fifteen displayed `H3` directions at `tau=3` in characteristic five. -/
def h3RootDirection5 (i : Fin 15) : Point5 :=
  ![
    ![0, 0, 1], ![0, 1, 0], ![1, 0, 0],
    ![1, 2, 1], ![1, 2, 2], ![1, 2, 3], ![1, 2, 4],
    ![1, 3, 1], ![1, 3, 2], ![1, 3, 3], ![1, 3, 4],
    ![1, 4, 2], ![1, 4, 3], ![1, 1, 2], ![1, 1, 3]
  ] i

/-- The 31 points of `PG(2,5)` as first-nonzero-coordinate-normalized representatives: leading `1`
for the 25 affine points, then `(0,1,*)`, then `(0,0,1)`. -/
def projectiveVec5 (i : Fin 31) : Point5 :=
  if _h₁ : i.1 < 25 then
    ![1, ((i.1 / 5 : ℕ) : ZMod 5), ((i.1 % 5 : ℕ) : ZMod 5)]
  else if _h₂ : i.1 < 30 then
    ![0, 1, ((i.1 - 25 : ℕ) : ZMod 5)]
  else ![0, 0, 1]

/-- Incidence count of the normalized point `projectiveVec5 p` with the fifteen characteristic-five
`H3` lines. -/
def h3Multiplicity5 (p : Fin 31) : ℕ :=
  (Finset.univ.filter fun i : Fin 15 => dot (h3RootDirection5 i) (projectiveVec5 p) = 0).card

/-- The normalized `PG(2,5)` points whose characteristic-five `H3` incidence count equals `m`. -/
def h3PointsOfMultiplicity5 (m : ℕ) : Finset (Fin 31) :=
  Finset.univ.filter fun p => h3Multiplicity5 p = m

/-- In characteristic five all 31 points of `PG(2,5)` lie on at least two of the fifteen lines, with
incidence spectrum `15_2, 10_3, 6_5`. -/
theorem h3_characteristic_five_spectrum :
    (h3PointsOfMultiplicity5 2).card = 15 ∧
    (h3PointsOfMultiplicity5 3).card = 10 ∧
    (h3PointsOfMultiplicity5 5).card = 6 := by
  decide

/-! ## The `A3` four-frame reduction over `F_5` -/

/-- The four-point projective frame `(1,0,0)`, `(0,1,0)`, `(0,0,1)`, `(1,1,1)` in `PG(2,5)`. -/
def a3FramePoint (i : Fin 4) : Point5 :=
  ![![1, 0, 0], ![0, 1, 0], ![0, 0, 1], ![1, 1, 1]] i

/-- The six unordered pairs of the four frame points. -/
def a3Pair (i : Fin 6) : Fin 4 × Fin 4 :=
  ![(0, 1), (0, 2), (0, 3), (1, 2), (1, 3), (2, 3)] i

/-- The six joins of the four frame points. -/
def a3Join (i : Fin 6) : Point5 :=
  cross (a3FramePoint (a3Pair i).1) (a3FramePoint (a3Pair i).2)

/-- The six essentialized braid directions `X, Y, Z, X-Y, X-Z, Y-Z`. -/
def a3RootDirection (i : Fin 6) : Point5 :=
  ![![1, 0, 0], ![0, 1, 0], ![0, 0, 1], ![1, -1, 0], ![1, 0, -1], ![0, 1, -1]] i

/-- Each of the six frame joins is projectively equal to some displayed braid direction. This is the
one-sided coverage only: the reverse inclusion and the cardinality of the two projective sets are not
asserted. -/
theorem a3_frame_joins_are_braid_mirrors :
    ∀ i : Fin 6, ∃ j : Fin 6, SameDirection (a3Join i) (a3RootDirection j) := by
  intro i
  fin_cases i <;> first | exact ⟨0, by decide⟩ | exact ⟨1, by decide⟩ |
    exact ⟨2, by decide⟩ | exact ⟨3, by decide⟩ | exact ⟨4, by decide⟩ |
    exact ⟨5, by decide⟩

/-- Incidence count of the normalized point `projectiveVec5 p` with the six frame join-lines. -/
def a3Multiplicity (p : Fin 31) : ℕ :=
  (Finset.univ.filter fun i : Fin 6 => dot (a3Join i) (projectiveVec5 p) = 0).card

/-- The normalized `PG(2,5)` points whose frame-join incidence count equals `m`. -/
def a3PointsOfMultiplicity (m : ℕ) : Finset (Fin 31) :=
  Finset.univ.filter fun p => a3Multiplicity p = m

/-- Incidence spectrum of the six frame join-lines over the 31 normalized points of `PG(2,5)`: six
points on no line, eighteen on one, three on two, four on three. -/
theorem a3_intersection_spectrum :
    (a3PointsOfMultiplicity 0).card = 6 ∧
    (a3PointsOfMultiplicity 1).card = 18 ∧
    (a3PointsOfMultiplicity 2).card = 3 ∧
    (a3PointsOfMultiplicity 3).card = 4 := by
  decide

/-! ## Ledger polynomial and conic-size arithmetic -/

/-- Integer identity `6*(5-1) + 10*(3-1) + 15*(2-1) = 59` for the weighted incidence sum. -/
theorem h3_mobius_sum : 6 * (5 - 1) + 10 * (3 - 1) + 15 * (2 - 1) = 59 := by norm_num

/-- Integer polynomial factorization `t^3 - 15 t^2 + 59 t - 45 = (t-1)(t-5)(t-9)`; the roots are
`1 +` the `H3` exponents `{1,5,9}`, matching the classical `H3` characteristic polynomial. -/
theorem h3_characteristic_polynomial (t : ℤ) :
    t ^ 3 - 15 * t ^ 2 + 59 * t - 45 = (t - 1) * (t - 5) * (t - 9) := by ring

/-- Integer polynomial factorization `t^3 - 6 t^2 + 11 t - 6 = (t-1)(t-2)(t-3)`; the roots are
`1 +` the `A3` exponents `{1,2,3}`, matching the classical `A3` characteristic polynomial. -/
theorem a3_characteristic_polynomial (t : ℤ) :
    t ^ 3 - 6 * t ^ 2 + 11 * t - 6 = (t - 1) * (t - 2) * (t - 3) := by ring

/-- Integer identity `(q-5)(q-9) - (q+1) = (q-4)(q-11)` used for the `H3` complement-code conic-size
relation. -/
theorem h3_conic_size_factorization (q : ℤ) :
    (q - 5) * (q - 9) - (q + 1) = (q - 4) * (q - 11) := by ring

/-- Integer identity `(q-2)(q-3) - (q+1) = (q-1)(q-5)` used for the `A3` complement-code conic-size
relation. -/
theorem a3_conic_size_factorization (q : ℤ) :
    (q - 2) * (q - 3) - (q + 1) = (q - 1) * (q - 5) := by ring

#print axioms tau11_relation
#print axioms tau5_relation
#print axioms h3_fivefold_points_arc
#print axioms h3_joins_are_root_directions
#print axioms h3_projectivity_det
#print axioms h3_projectivity_maps_fivefold_points
#print axioms h3_dual_projectivity_maps_mirrors
#print axioms h3_multiplicity_eq_rawPointIndex
#print axioms h3_fivefold_index_vec
#print axioms h3_intersection_spectrum
#print axioms h3_fivefold_points_exact
#print axioms h3_characteristic_two_boundary
#print axioms h3_characteristic_five_spectrum
#print axioms a3_frame_joins_are_braid_mirrors
#print axioms a3_intersection_spectrum
#print axioms h3_mobius_sum
#print axioms h3_characteristic_polynomial
#print axioms a3_characteristic_polynomial
#print axioms h3_conic_size_factorization
#print axioms a3_conic_size_factorization

end RelativeConicArcs.Examples.ReflectionArrangements
