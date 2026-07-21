import RelativeConicArcs.Q11BrianchonPetersen

/-!
# Coordinate tables for the `A3`/`H3` reflection-arrangement synthesis

This file records explicit projective-coordinate tables over the finite fields `ZMod 11`, `ZMod 5`,
and `ZMod 2`, and kernel-checks finite incidence, determinant, and projective-map identities about
them by `decide`/`fin_cases`, together with a few integer polynomial identities by `ring`/`norm_num`.
There is no generated certificate tree.

Conventions.  A projective point or line is represented by a nonzero vector in `Fin 3 → K`;
`SameDirection u v` means `v = a • u` for some nonzero `a`.  The predicate is also defined on zero
vectors (in particular, `SameDirection 0 0` holds), so its projective interpretation is used only
when nonzeroness is known.  The operations `cross` and `dot` are the triple product and dot product.
Projective points of `PG(2,11)` and `PG(2,5)` are the fixed
first-nonzero-coordinate-normalized enumerations `projectiveVec` and `projectiveVec5`.

Scope and trust boundary.  Lean here checks coordinate tables and arithmetic only.  The `A3` and
`H3` labels are mnemonic names for the displayed tables; this file asserts no identification with
abstract Coxeter arrangements and does not interpret the integer factorizations as characteristic
polynomials.  The terminal results are the `tau`
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

/-- Equality up to multiplication by a nonzero scalar for concrete coordinate vectors.  On nonzero
vectors this is projective equality; the definition also makes `SameDirection 0 0` true. -/
def SameDirection {K : Type*} [Field K] (u v : Fin 3 → K) : Prop :=
  ∃ a : K, a ≠ 0 ∧ a • u = v

/-- An indexed coordinate table is projectively injective when vectors at distinct indices are not
equal up to multiplication by a nonzero scalar. -/
def ProjectivelyInjective {n : ℕ} {K : Type*} [Field K] (f : Fin n → Fin 3 → K) : Prop :=
  ∀ i j, SameDirection (f i) (f j) → i = j

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

/-- The fifteen raw cross-product vectors of the join-lines, collected as a finite set. -/
def h3Joins : Finset Point11 := Finset.univ.image h3Join

/-- The fifteen displayed directions obtained from
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

/-- The raw join and displayed-direction tables both have cardinality fifteen, and every indexed
entry of either table matches an entry of the other under `SameDirection`. Projective distinctness
of the two tables is stated separately by `h3_join_directions_injective` and
`h3_root_directions_injective`. -/
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

/-- Distinct join indices represent distinct projective directions. -/
theorem h3_join_directions_injective : ProjectivelyInjective h3Join := by
  intro i j
  revert i j
  decide

/-- Distinct displayed-direction indices represent distinct projective directions. -/
theorem h3_root_directions_injective : ProjectivelyInjective h3RootDirection := by
  intro i j
  revert i j
  decide

/-- The displayed 3×3 map `T` over `ZMod 11`, acting on column coordinate vectors. -/
def h3Projectivity (p : Point11) : Point11 :=
  ![
    2 * p 0 + 3 * p 1 + 8 * p 2,
    10 * p 0 + 6 * p 1 + 9 * p 2,
    2 * p 0 + 2 * p 1 + 5 * p 2
  ]

/-- The coordinate map on line normals whose pairing with `h3Projectivity` is preserved. -/
def h3DualProjectivity (l : Point11) : Point11 :=
  ![
    4 * l 0 + 4 * l 1 + 10 * l 2,
    4 * l 0 + 9 * l 1 + 8 * l 2,
    4 * l 0 + 6 * l 1 + 5 * l 2
  ]

/-- The explicit inverse coordinate map to `h3Projectivity`. -/
def h3ProjectivityInverse (p : Point11) : Point11 :=
  ![
    4 * p 0 + 4 * p 1 + 4 * p 2,
    4 * p 0 + 9 * p 1 + 6 * p 2,
    10 * p 0 + 8 * p 1 + 5 * p 2
  ]

/-- The displayed matrix of `T` has determinant `3` in `ZMod 11`; the following declarations prove
nonvanishing, give its explicit inverse, and package its action on normalized projective indices. -/
theorem h3_projectivity_det :
    Matrix.det (![![2, 3, 8], ![10, 6, 9], ![2, 2, 5]] : Matrix (Fin 3) (Fin 3) (ZMod 11)) = 3 := by
  decide

/-- The determinant `3` of the displayed matrix is nonzero in `ZMod 11`. -/
theorem h3_projectivity_det_ne_zero :
    Matrix.det (![![2, 3, 8], ![10, 6, 9], ![2, 2, 5]] :
      Matrix (Fin 3) (Fin 3) (ZMod 11)) ≠ 0 := by
  rw [h3_projectivity_det]
  decide

/-- The explicit inverse is a left inverse to `h3Projectivity`. -/
theorem h3_projectivity_inverse_apply (p : Point11) :
    h3ProjectivityInverse (h3Projectivity p) = p := by
  have h44 : (44 : ZMod 11) = 0 := by decide
  have h56 : (56 : ZMod 11) = 1 := by decide
  have h78 : (78 : ZMod 11) = 1 := by decide
  have h88 : (88 : ZMod 11) = 0 := by decide
  have h110 : (110 : ZMod 11) = 0 := by decide
  have h143 : (143 : ZMod 11) = 0 := by decide
  have h177 : (177 : ZMod 11) = 1 := by decide
  funext i
  fin_cases i <;> simp [h3ProjectivityInverse, h3Projectivity] <;> ring_nf <;>
    try simp only [h44, h56, h78, h88, h110, h143, h177, mul_zero, mul_one, add_zero,
      zero_add]

/-- The explicit inverse is a right inverse to `h3Projectivity`. -/
theorem h3_projectivity_apply_inverse (p : Point11) :
    h3Projectivity (h3ProjectivityInverse p) = p := by
  have h45 : (45 : ZMod 11) = 1 := by decide
  have h66 : (66 : ZMod 11) = 0 := by decide
  have h99 : (99 : ZMod 11) = 0 := by decide
  have h100 : (100 : ZMod 11) = 1 := by decide
  have h121 : (121 : ZMod 11) = 0 := by decide
  have h154 : (154 : ZMod 11) = 0 := by decide
  have h166 : (166 : ZMod 11) = 1 := by decide
  funext i
  fin_cases i <;> simp [h3ProjectivityInverse, h3Projectivity] <;> ring_nf <;>
    try simp only [h45, h66, h99, h100, h121, h154, h166, mul_zero, mul_one, add_zero,
      zero_add]

/-- The line-normal map is contragredient to `h3Projectivity`: their coordinate pairing is
unchanged. -/
theorem h3_dual_projectivity_dot (l p : Point11) :
    dot (h3DualProjectivity l) (h3Projectivity p) = dot l p := by
  have h44 : (44 : ZMod 11) = 0 := by decide
  have h56 : (56 : ZMod 11) = 1 := by decide
  have h78 : (78 : ZMod 11) = 1 := by decide
  have h88 : (88 : ZMod 11) = 0 := by decide
  have h110 : (110 : ZMod 11) = 0 := by decide
  have h143 : (143 : ZMod 11) = 0 := by decide
  have h177 : (177 : ZMod 11) = 1 := by decide
  simp [dot, h3DualProjectivity, h3Projectivity]
  ring_nf
  simp only [h44, h56, h78, h88, h110, h143, h177, mul_zero, mul_one, add_zero]

/-- The displayed coordinate map sends nonzero vectors to nonzero vectors. -/
theorem h3_projectivity_ne_zero {p : Point11} (hp : p ≠ 0) :
    h3Projectivity p ≠ 0 := by
  intro hzero
  apply hp
  rw [← h3_projectivity_inverse_apply p, hzero]
  simp [h3ProjectivityInverse]

/-- The explicit inverse coordinate map sends nonzero vectors to nonzero vectors. -/
theorem h3_projectivity_inverse_ne_zero {p : Point11} (hp : p ≠ 0) :
    h3ProjectivityInverse p ≠ 0 := by
  intro hzero
  apply hp
  rw [← h3_projectivity_apply_inverse p, hzero]
  simp [h3Projectivity]

/-- Index of the first-nonzero-coordinate normalization of a coordinate vector.  The zero vector is
sent to the final index; the projective interpretation below is used only for nonzero inputs. -/
def projectiveIndex11 (s : Point11) : Fin 133 :=
  if h₀ : s 0 ≠ 0 then
    ⟨(s 1 / s 0).val * 11 + (s 2 / s 0).val, by
      have h₁ := (s 1 / s 0).val_lt
      have h₂ := (s 2 / s 0).val_lt
      omega⟩
  else if h₁ : s 1 ≠ 0 then
    ⟨121 + (s 2 / s 1).val, by
      have h₂ := (s 2 / s 1).val_lt
      omega⟩
  else ⟨132, by omega⟩

/-- A nonzero vector is a nonzero scalar multiple of the normalized representative selected by
`projectiveIndex11`. -/
theorem projective_index11_direction (s : Point11) (hs : s ≠ 0) :
    SameDirection (projectiveVec (projectiveIndex11 s)) s := by
  unfold projectiveIndex11
  split_ifs with h₀ h₁
  · have h₁lt := (s 1 / s 0).val_lt
    have h₂lt := (s 2 / s 0).val_lt
    have hidx : (s 1 / s 0).val * 11 + (s 2 / s 0).val < 121 := by omega
    have hdiv : ((s 1 / s 0).val * 11 + (s 2 / s 0).val) / 11 =
        (s 1 / s 0).val := by omega
    have hmod : ((s 1 / s 0).val * 11 + (s 2 / s 0).val) % 11 =
        (s 2 / s 0).val := by omega
    refine ⟨s 0, h₀, ?_⟩
    funext i
    fin_cases i <;> simp [projectiveVec, hidx, hdiv, hmod] <;> try field_simp
  · have h₂lt := (s 2 / s 1).val_lt
    have hidx : 121 + (s 2 / s 1).val < 132 := by omega
    have hs₀ : s 0 = 0 := not_ne_iff.mp h₀
    refine ⟨s 1, h₁, ?_⟩
    funext i
    fin_cases i <;> simp [projectiveVec, hidx, hs₀] <;> try field_simp
  · have h₂ : s 2 ≠ 0 := by
      intro h₂
      apply hs
      funext i
      fin_cases i <;> simp_all
    have hs₀ : s 0 = 0 := not_ne_iff.mp h₀
    have hs₁ : s 1 = 0 := not_ne_iff.mp h₁
    refine ⟨s 2, h₂, ?_⟩
    funext i
    fin_cases i <;> simp [projectiveVec, hs₀, hs₁]

/-- The normalized projective index of the image of the `p`-th normalized point under the displayed
invertible coordinate map. -/
def h3ProjectiveIndex (p : Fin 133) : Fin 133 :=
  projectiveIndex11 (h3Projectivity (projectiveVec p))

/-- The normalized representative selected by `h3ProjectiveIndex` lies in the same direction as the
displayed image. -/
theorem h3_projective_index_direction (p : Fin 133) :
    SameDirection (projectiveVec (h3ProjectiveIndex p))
      (h3Projectivity (projectiveVec p)) := by
  exact projective_index11_direction _ (h3_projectivity_ne_zero (projectiveVec_ne_zero p))

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

/-- Multiplying a coordinate vector by a nonzero scalar does not change its Clebsch secant index. -/
theorem rawPointIndex_smul (a : ZMod 11) (ha : a ≠ 0) (x : Point11) :
    rawPointIndex (a • x) = rawPointIndex x := by
  unfold rawPointIndex
  congr 1
  ext e
  have hdet : Matrix.det ![a • x, witnessVec e.1, witnessVec e.2] =
      a * Matrix.det ![x, witnessVec e.1, witnessVec e.2] := by
    simp [Matrix.det_fin_three]
    ring
  simp [hdet, ha]

/-- The incidence count at a normalized point is the Clebsch secant index at the normalized
projective representative of its displayed image. -/
theorem h3_multiplicity_eq_normalized_rawPointIndex (p : Fin 133) :
    (Finset.univ.filter fun i : Fin 15 => dot (h3Join i) (projectiveVec p) = 0).card =
      rawPointIndex (projectiveVec (h3ProjectiveIndex p)) := by
  rw [h3_multiplicity_eq_rawPointIndex]
  obtain ⟨a, ha, hdir⟩ := h3_projective_index_direction p
  rw [← hdir, rawPointIndex_smul a ha]

/-- The explicit inverse coordinate map commutes with scalar multiplication. -/
theorem h3_projectivity_inverse_smul (a : ZMod 11) (p : Point11) :
    h3ProjectivityInverse (a • p) = a • h3ProjectivityInverse p := by
  funext i
  fin_cases i <;> simp [h3ProjectivityInverse] <;> ring

/-- Two normalized representatives in the same nonzero direction have the same projective index. -/
theorem projectiveVec_sameDirection_injective {p q : Fin 133}
    (h : SameDirection (projectiveVec p) (projectiveVec q)) : p = q := by
  obtain ⟨a, ha, hdir⟩ := h
  let a' : NonzeroScalar := ⟨a, ha⟩
  let one' : NonzeroScalar := ⟨1, one_ne_zero⟩
  have hray : affineRayVec (p, a') = affineRayVec (q, one') := by
    simpa [affineRayVec, a', one'] using hdir
  have hray' : (⟨affineRayVec (p, a'), affineRayVec_ne_zero (p, a')⟩ :
      {s : Vec (ZMod 11) // s ≠ 0}) =
      ⟨affineRayVec (q, one'), affineRayVec_ne_zero (q, one')⟩ := Subtype.ext hray
  exact congrArg Prod.fst (affineRayVec_bijective.1 hray')

/-- The normalized projective-index map induced by the displayed coordinate map is injective. -/
theorem h3_projective_index_injective : Function.Injective h3ProjectiveIndex := by
  intro p q hpq
  obtain ⟨a, ha, hp⟩ := h3_projective_index_direction p
  obtain ⟨b, hb, hq⟩ := h3_projective_index_direction q
  have hn : projectiveVec (h3ProjectiveIndex p) = projectiveVec (h3ProjectiveIndex q) := by
    rw [hpq]
  have himage : SameDirection (h3Projectivity (projectiveVec p))
      (h3Projectivity (projectiveVec q)) := by
    refine ⟨b / a, div_ne_zero hb ha, ?_⟩
    calc
      (b / a) • h3Projectivity (projectiveVec p) =
          (b / a) • (a • projectiveVec (h3ProjectiveIndex p)) := by rw [hp]
      _ = b • projectiveVec (h3ProjectiveIndex p) := by
        ext i
        simp
        field_simp
      _ = b • projectiveVec (h3ProjectiveIndex q) := by rw [hn]
      _ = h3Projectivity (projectiveVec q) := hq
  apply projectiveVec_sameDirection_injective
  obtain ⟨c, hc, hcmap⟩ := himage
  refine ⟨c, hc, ?_⟩
  calc
    c • projectiveVec p = c • h3ProjectivityInverse (h3Projectivity (projectiveVec p)) := by
      rw [h3_projectivity_inverse_apply]
    _ = h3ProjectivityInverse (c • h3Projectivity (projectiveVec p)) := by
      rw [h3_projectivity_inverse_smul]
    _ = h3ProjectivityInverse (h3Projectivity (projectiveVec q)) := by rw [hcmap]
    _ = projectiveVec q := h3_projectivity_inverse_apply _

/-- The normalized projective-index map induced by the displayed invertible coordinate map is a
bijection of the 133 normalized projective points. -/
theorem h3_projective_index_bijective : Function.Bijective h3ProjectiveIndex := by
  refine (Fintype.bijective_iff_injective_and_card h3ProjectiveIndex).mpr ?_
  exact ⟨h3_projective_index_injective, rfl⟩

/-- Incidence count of the normalized projective point `projectiveVec p` with the fifteen
join-lines. -/
def h3Multiplicity (p : Fin 133) : ℕ :=
  (Finset.univ.filter fun i : Fin 15 => dot (h3Join i) (projectiveVec p) = 0).card

/-- The normalized `PG(2,11)` points whose incidence count with the fifteen join-lines equals `m`. -/
def h3PointsOfMultiplicity (m : ℕ) : Finset (Fin 133) :=
  Finset.univ.filter fun p => h3Multiplicity p = m

/-- Every normalized point has incidence multiplicity `0`, `1`, `2`, `3`, or `5` with the fifteen
join-lines. -/
theorem h3_multiplicity_cases (p : Fin 133) :
    h3Multiplicity p = 0 ∨ h3Multiplicity p = 1 ∨ h3Multiplicity p = 2 ∨
      h3Multiplicity p = 3 ∨ h3Multiplicity p = 5 := by
  revert p
  decide

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

/-- The six displayed braid-form directions `X, Y, Z, X-Y, X-Z, Y-Z`. -/
def a3RootDirection (i : Fin 6) : Point5 :=
  ![![1, 0, 0], ![0, 1, 0], ![0, 0, 1], ![1, -1, 0], ![1, 0, -1], ![0, 1, -1]] i

/-- The six raw cross-product vectors of the frame joins, collected as a finite set. -/
def a3Joins : Finset Point5 := Finset.univ.image a3Join

/-- The six displayed braid directions, collected as a finite set. -/
def a3RootDirections : Finset Point5 := Finset.univ.image a3RootDirection

/-- The two raw vector tables both have cardinality six, and each indexed frame join matches a
displayed braid-form direction under `SameDirection` and conversely. Projective distinctness is
stated separately by `a3_join_directions_injective` and `a3_root_directions_injective`. -/
theorem a3_frame_joins_are_braid_mirrors :
    a3Joins.card = 6 ∧ a3RootDirections.card = 6 ∧
      (∀ i : Fin 6, ∃ j : Fin 6, SameDirection (a3Join i) (a3RootDirection j)) ∧
      (∀ j : Fin 6, ∃ i : Fin 6, SameDirection (a3Join i) (a3RootDirection j)) := by
  refine ⟨by decide, by decide, ?_, ?_⟩
  · intro i
    fin_cases i <;> first | exact ⟨0, by decide⟩ | exact ⟨1, by decide⟩ |
      exact ⟨2, by decide⟩ | exact ⟨3, by decide⟩ | exact ⟨4, by decide⟩ |
      exact ⟨5, by decide⟩

  · intro j
    fin_cases j <;> first | exact ⟨0, by decide⟩ | exact ⟨1, by decide⟩ |
      exact ⟨2, by decide⟩ | exact ⟨3, by decide⟩ | exact ⟨4, by decide⟩ |
      exact ⟨5, by decide⟩

/-- Distinct frame-join indices represent distinct projective directions. -/
theorem a3_join_directions_injective : ProjectivelyInjective a3Join := by
  intro i j
  revert i j
  decide

/-- Distinct braid-form indices represent distinct projective directions. -/
theorem a3_root_directions_injective : ProjectivelyInjective a3RootDirection := by
  intro i j
  revert i j
  decide

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

/-- Integer polynomial factorization `t^3 - 15 t^2 + 59 t - 45 = (t-1)(t-5)(t-9)`. -/
theorem h3_characteristic_polynomial (t : ℤ) :
    t ^ 3 - 15 * t ^ 2 + 59 * t - 45 = (t - 1) * (t - 5) * (t - 9) := by ring

/-- Integer polynomial factorization `t^3 - 6 t^2 + 11 t - 6 = (t-1)(t-2)(t-3)`. -/
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
#print axioms h3_join_directions_injective
#print axioms h3_root_directions_injective
#print axioms h3_projectivity_det
#print axioms h3_projectivity_det_ne_zero
#print axioms h3_projectivity_inverse_apply
#print axioms h3_projectivity_apply_inverse
#print axioms h3_dual_projectivity_dot
#print axioms h3_projectivity_ne_zero
#print axioms h3_projectivity_inverse_ne_zero
#print axioms h3_projective_index_direction
#print axioms h3_projectivity_maps_fivefold_points
#print axioms h3_dual_projectivity_maps_mirrors
#print axioms h3_multiplicity_eq_rawPointIndex
#print axioms h3_multiplicity_eq_normalized_rawPointIndex
#print axioms h3_projectivity_inverse_smul
#print axioms projectiveVec_sameDirection_injective
#print axioms h3_projective_index_injective
#print axioms h3_projective_index_bijective
#print axioms h3_multiplicity_cases
#print axioms h3_fivefold_index_vec
#print axioms h3_intersection_spectrum
#print axioms h3_fivefold_points_exact
#print axioms h3_characteristic_two_boundary
#print axioms h3_characteristic_five_spectrum
#print axioms a3_frame_joins_are_braid_mirrors
#print axioms a3_join_directions_injective
#print axioms a3_root_directions_injective
#print axioms a3_intersection_spectrum
#print axioms h3_mobius_sum
#print axioms h3_characteristic_polynomial
#print axioms a3_characteristic_polynomial
#print axioms h3_conic_size_factorization
#print axioms a3_conic_size_factorization

end RelativeConicArcs.Examples.ReflectionArrangements
