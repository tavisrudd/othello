import ProjectiveCap.PlaneTransitivity
import ProjectiveCap.Grid

/-!
# The affine chart of a projective plane, in standard coordinates

Work in the coordinate projective plane over a field `K`: `PlaneVec K = Fin 3 → K`
and the points are `Point K (PlaneVec K) = Projectivization K (PlaneVec K)`.

Fix the two points `rowDirection = [1 : 0 : 0]` and `colDirection = [0 : 1 : 0]`.
Their join is the line at infinity `Z = 0`, and its complement is the affine
chart, parametrized by `affinePoint : GridPoint K → Point K (PlaneVec K)`,
`(x, y) ↦ [x : y : 1]`, where `GridPoint K = K × K` (defined in
`ProjectiveCap.Grid`). This module proves that `affinePoint` is injective, that
its image is exactly the complement of the two fixed directions together with
the rest of the line at infinity (`point_eq_affine_or_collinear_row_col`), and
that it embeds the grid `GridPoint K ↪ Point K (PlaneVec K)`.

The collinearity dictionary is the content: three points of the coordinate
plane are collinear exactly when the determinant of their representative
vectors vanishes (`mk_collinear_iff_det_eq_zero`), and specializing that to the
fixed directions gives
`collinear_rowDirection_affine_iff` (two affine points are collinear with
`rowDirection` exactly when they share a coordinate), its column counterpart,
`not_collinear_row_col_affine`, and `collinear_affine_iff_grid`, which matches
projective collinearity of three affine points against the grid collinearity
predicate of `ProjectiveCap.Grid`.

Consequently a set of grid points is a grid cap exactly when the corresponding
projective set — the two fixed directions together with the affine image — is a
projective cap (`gridCap_of_projectiveCap` and `projectiveCap_of_gridCap`), and
the cardinalities match (`fixed_union_affine_image_card`).

Everything here is static incidence geometry; no game is played on these points.
The transport of game values across this dictionary is in
`ProjectiveCap.FrameGridBridge`.
-/

open scoped LinearAlgebra.Projectivization

namespace ProjectiveCap
namespace Projective
namespace FrameGridBridge
namespace Coordinate


variable {K : Type*} [Field K]

/-- Representative space `Fin 3 → K` for the coordinate projective plane over `K`. -/
abbrev PlaneVec (K : Type*) := Fin 3 -> K

/-- The coordinate vector `(1, 0, 0)`, representing the first fixed direction on the
line at infinity. -/
def rowDirectionVec : PlaneVec K :=
  ![(1 : K), 0, 0]

/-- The coordinate vector `(0, 1, 0)`, representing the second fixed direction on the
line at infinity. -/
def colDirectionVec : PlaneVec K :=
  ![(0 : K), 1, 0]

/-- The chart representative `(p₁, p₂, 1)` of a cell `p` of `K × K`, normalized to
have third coordinate `1`. -/
def affineVec (p : GridPoint K) : PlaneVec K :=
  ![p.1, p.2, (1 : K)]

/-- The vector `(1, 0, 0)` is nonzero, so it represents a projective point. -/
theorem rowDirectionVec_ne_zero : rowDirectionVec (K := K) ≠ 0 := by
  intro h
  have h0 := congrFun h 0
  simp [rowDirectionVec] at h0

/-- The vector `(0, 1, 0)` is nonzero, so it represents a projective point. -/
theorem colDirectionVec_ne_zero : colDirectionVec (K := K) ≠ 0 := by
  intro h
  have h1 := congrFun h 1
  simp [colDirectionVec] at h1

/-- The chart representative of a cell is nonzero, its third coordinate being `1`. -/
theorem affineVec_ne_zero (p : GridPoint K) : affineVec (K := K) p ≠ 0 := by
  intro h
  have h2 := congrFun h 2
  simp [affineVec] at h2

/-- The point `[1 : 0 : 0]` of the coordinate projective plane, the first of the two
fixed directions spanning the line at infinity. -/
def rowDirection : Point K (PlaneVec K) :=
  Projectivization.mk K (rowDirectionVec (K := K)) rowDirectionVec_ne_zero

/-- The point `[0 : 1 : 0]` of the coordinate projective plane, the second of the two
fixed directions spanning the line at infinity. -/
def colDirection : Point K (PlaneVec K) :=
  Projectivization.mk K (colDirectionVec (K := K)) colDirectionVec_ne_zero

/-- Affine chart point `(r,c) ↦ [r:c:1]`. -/
def affinePoint (p : GridPoint K) : Point K (PlaneVec K) :=
  Projectivization.mk K (affineVec (K := K) p) (affineVec_ne_zero p)

/-- The two fixed directions `[1 : 0 : 0]` and `[0 : 1 : 0]` are distinct points of
the coordinate projective plane. -/
theorem rowDirection_ne_colDirection :
    rowDirection (K := K) ≠ colDirection (K := K) := by
  intro h
  obtain ⟨a, ha⟩ := (Projectivization.mk_eq_mk_iff' K
    (rowDirectionVec (K := K)) (colDirectionVec (K := K))
    rowDirectionVec_ne_zero colDirectionVec_ne_zero).mp h
  have h1 := congrFun ha 1
  have ha0 : a = 0 := by
    simpa [rowDirectionVec, colDirectionVec] using h1
  have h0 := congrFun ha 0
  simp [rowDirectionVec, colDirectionVec, ha0] at h0

/-- No chart image `[p₁ : p₂ : 1]` equals the direction `[1 : 0 : 0]`, since a chart
representative has third coordinate `1`. -/
theorem affinePoint_ne_rowDirection (p : GridPoint K) :
    affinePoint (K := K) p ≠ rowDirection (K := K) := by
  intro h
  obtain ⟨a, ha⟩ := (Projectivization.mk_eq_mk_iff' K
    (affineVec (K := K) p) (rowDirectionVec (K := K))
    (affineVec_ne_zero p) rowDirectionVec_ne_zero).mp h
  have h2 := congrFun ha 2
  simp [affineVec, rowDirectionVec] at h2

/-- No chart image `[p₁ : p₂ : 1]` equals the direction `[0 : 1 : 0]`, since a chart
representative has third coordinate `1`. -/
theorem affinePoint_ne_colDirection (p : GridPoint K) :
    affinePoint (K := K) p ≠ colDirection (K := K) := by
  intro h
  obtain ⟨a, ha⟩ := (Projectivization.mk_eq_mk_iff' K
    (affineVec (K := K) p) (colDirectionVec (K := K))
    (affineVec_ne_zero p) colDirectionVec_ne_zero).mp h
  have h2 := congrFun ha 2
  simp [affineVec, colDirectionVec] at h2

/-- The affine chart is injective: two cells with the same image `[p₁ : p₂ : 1]` are
equal, because the normalization of the third coordinate to `1` pins down the scalar
relating the two representatives. -/
theorem affinePoint_injective : Function.Injective (affinePoint (K := K)) := by
  intro p q hpq
  obtain ⟨a, ha⟩ := (Projectivization.mk_eq_mk_iff' K
    (affineVec (K := K) p) (affineVec (K := K) q)
    (affineVec_ne_zero p) (affineVec_ne_zero q)).mp hpq
  have ha1 : a = 1 := by
    have h2 := congrFun ha 2
    simpa [affineVec] using h2
  have hrow : p.1 = q.1 := by
    have h0 := congrFun ha 0
    have h0' : q.1 = p.1 := by
      simpa [affineVec, ha1] using h0
    exact h0'.symm
  have hcol : p.2 = q.2 := by
    have h1 := congrFun ha 1
    have h1' : q.2 = p.2 := by
      simpa [affineVec, ha1] using h1
    exact h1'.symm
  exact Prod.ext hrow hcol

/-- The affine chart as an embedding into projective points. -/
def affineEmbedding : GridPoint K ↪ Point K (PlaneVec K) where
  toFun := affinePoint (K := K)
  inj' := affinePoint_injective (K := K)

/-- Determinant criterion for collinearity in the coordinate projective plane: three
points represented by nonzero vectors `x`, `y`, `z` of `Fin 3 → K` lie on a common
projective line exactly when the determinant of the matrix with these rows
vanishes. -/
theorem mk_collinear_iff_det_eq_zero {x y z : PlaneVec K}
    (hx : x ≠ 0) (hy : y ≠ 0) (hz : z ≠ 0) :
    Projective.Collinear K (PlaneVec K)
        (Projectivization.mk K x hx)
        (Projectivization.mk K y hy)
        (Projectivization.mk K z hz) ↔
      Matrix.det ![x, y, z] = 0 := by
  constructor
  · intro hcol
    by_contra hdet
    have hli : LinearIndependent K ![x, y, z] :=
      Matrix.linearIndependent_rows_of_det_ne_zero hdet
    have hind :
        Projectivization.Independent
          ![Projectivization.mk K x hx, Projectivization.mk K y hy,
            Projectivization.mk K z hz] :=
      Projective.independent_triple_of_li (K := K) (V := PlaneVec K) hx hy hz hli
    have hdep :
        Projectivization.Dependent
          ![Projectivization.mk K x hx, Projectivization.mk K y hy,
            Projectivization.mk K z hz] :=
      (Projective.collinear_iff_dependent (K := K) (V := PlaneVec K)).mp hcol
    exact (Projectivization.dependent_iff_not_independent.mp hdep) hind
  · intro hdet
    have hnli : ¬ LinearIndependent K ![x, y, z] := by
      intro hli
      let A : Matrix (Fin 3) (Fin 3) K := ![x, y, z]
      have hliA : LinearIndependent K A.row := by
        simpa [A, Matrix.row] using hli
      have hmatunit : IsUnit A :=
        (Matrix.linearIndependent_rows_iff_isUnit (A := A)).mp hliA
      have hunit : IsUnit A.det :=
        (Matrix.isUnit_iff_isUnit_det A).mp hmatunit
      have hdetA : A.det = 0 := by
        simpa [A] using hdet
      exact hunit.ne_zero hdetA
    have hdep :
        Projectivization.Dependent
          ![Projectivization.mk K x hx, Projectivization.mk K y hy,
            Projectivization.mk K z hz] := by
      have hraw := Projectivization.Dependent.mk (K := K) (V := PlaneVec K)
        ![x, y, z] (fun i => by fin_cases i <;> assumption) hnli
      convert hraw using 1
      ext i
      fin_cases i <;> rfl
    exact (Projective.collinear_iff_dependent (K := K) (V := PlaneVec K)).mpr hdep

/-- The determinant of `(1, 0, 0)` and the chart representatives `(p₁, p₂, 1)`,
`(q₁, q₂, 1)` of two cells is the difference `p₂ - q₂` of their second
coordinates. -/
theorem det_rowDirection_affine_affine (p q : GridPoint K) :
    Matrix.det ![rowDirectionVec (K := K), affineVec (K := K) p,
      affineVec (K := K) q] = p.2 - q.2 := by
  rw [Matrix.det_fin_three]
  simp [rowDirectionVec, affineVec]

/-- The determinant of `(0, 1, 0)` and the chart representatives `(p₁, p₂, 1)`,
`(q₁, q₂, 1)` of two cells is the difference `q₁ - p₁` of their first
coordinates. -/
theorem det_colDirection_affine_affine (p q : GridPoint K) :
    Matrix.det ![colDirectionVec (K := K), affineVec (K := K) p,
      affineVec (K := K) q] = q.1 - p.1 := by
  rw [Matrix.det_fin_three]
  simp [colDirectionVec, affineVec]
  ring

/-- The determinant of `(1, 0, 0)`, `(0, 1, 0)` and the chart representative
`(p₁, p₂, 1)` of a cell equals `1`. -/
theorem det_rowDirection_colDirection_affine (p : GridPoint K) :
    Matrix.det ![rowDirectionVec (K := K), colDirectionVec (K := K),
      affineVec (K := K) p] = 1 := by
  rw [Matrix.det_fin_three]
  simp [rowDirectionVec, colDirectionVec, affineVec]

/-- The determinant of `(1, 0, 0)`, `(0, 1, 0)` and an arbitrary vector `v` of
`Fin 3 → K` is the third coordinate of `v`. -/
theorem det_rowDirection_colDirection_vec (v : PlaneVec K) :
    Matrix.det ![rowDirectionVec (K := K), colDirectionVec (K := K), v] = v 2 := by
  rw [Matrix.det_fin_three]
  simp [rowDirectionVec, colDirectionVec]

/-- A point whose representative has vanishing third coordinate lies on the line at
infinity, hence is collinear with the two fixed directions `[1 : 0 : 0]` and
`[0 : 1 : 0]`. -/
theorem collinear_row_col_mk_of_coord2_eq_zero {v : PlaneVec K} (hv : v ≠ 0)
    (h2 : v 2 = 0) :
    Projective.Collinear K (PlaneVec K) (rowDirection (K := K))
      (colDirection (K := K)) (Projectivization.mk K v hv) := by
  change Projective.Collinear K (PlaneVec K)
      (Projectivization.mk K (rowDirectionVec (K := K)) rowDirectionVec_ne_zero)
      (Projectivization.mk K (colDirectionVec (K := K)) colDirectionVec_ne_zero)
      (Projectivization.mk K v hv)
  rw [mk_collinear_iff_det_eq_zero rowDirectionVec_ne_zero colDirectionVec_ne_zero hv,
    det_rowDirection_colDirection_vec, h2]

/-- Every point of the coordinate projective plane is either a chart image
`[p₁ : p₂ : 1]` for some cell `p ∈ K × K`, or lies on the line at infinity through
`[1 : 0 : 0]` and `[0 : 1 : 0]`. Dividing by the nonzero third coordinate produces
the cell in the first case. -/
theorem point_eq_affine_or_collinear_row_col
    (x : Point K (PlaneVec K)) :
    (∃ p : GridPoint K, x = affinePoint (K := K) p) ∨
      Projective.Collinear K (PlaneVec K) (rowDirection (K := K))
        (colDirection (K := K)) x := by
  induction x using Projectivization.ind with
  | h v hv =>
      by_cases h2 : v 2 = 0
      · right
        exact collinear_row_col_mk_of_coord2_eq_zero (K := K) hv h2
      · left
        let p : GridPoint K := (v 0 / v 2, v 1 / v 2)
        refine ⟨p, ?_⟩
        change Projectivization.mk K v hv =
          Projectivization.mk K (affineVec (K := K) p) (affineVec_ne_zero p)
        refine (Projectivization.mk_eq_mk_iff' K v (affineVec (K := K) p)
          hv (affineVec_ne_zero p)).mpr ?_
        refine ⟨v 2, ?_⟩
        ext i
        fin_cases i <;> simp [p, affineVec]
        · field_simp [h2]
        · field_simp [h2]

/-- The determinant of the three chart representatives `(p₁, p₂, 1)`, `(q₁, q₂, 1)`,
`(r₁, r₂, 1)` is the affine cross product
`(q₁ - p₁)(r₂ - p₂) - (q₂ - p₂)(r₁ - p₁)`. -/
theorem det_affine_affine_affine (p q r : GridPoint K) :
    Matrix.det ![affineVec (K := K) p, affineVec (K := K) q,
      affineVec (K := K) r] =
      (q.1 - p.1) * (r.2 - p.2) - (q.2 - p.2) * (r.1 - p.1) := by
  rw [Matrix.det_fin_three]
  simp [affineVec]
  ring

/-- The direction `[1 : 0 : 0]` is collinear with the chart images of two cells `p`
and `q` exactly when those cells share their second coordinate, that is, exactly
when they lie in the same column of the grid. -/
theorem collinear_rowDirection_affine_iff (p q : GridPoint K) :
    Projective.Collinear K (PlaneVec K) (rowDirection (K := K))
      (affinePoint (K := K) p) (affinePoint (K := K) q) ↔ p.2 = q.2 := by
  change Projective.Collinear K (PlaneVec K)
      (Projectivization.mk K (rowDirectionVec (K := K)) rowDirectionVec_ne_zero)
      (Projectivization.mk K (affineVec (K := K) p) (affineVec_ne_zero p))
      (Projectivization.mk K (affineVec (K := K) q) (affineVec_ne_zero q)) ↔ p.2 = q.2
  rw [mk_collinear_iff_det_eq_zero rowDirectionVec_ne_zero (affineVec_ne_zero p)
    (affineVec_ne_zero q), det_rowDirection_affine_affine]
  exact sub_eq_zero

/-- The direction `[0 : 1 : 0]` is collinear with the chart images of two cells `p`
and `q` exactly when those cells share their first coordinate, that is, exactly when
they lie in the same row of the grid. -/
theorem collinear_colDirection_affine_iff (p q : GridPoint K) :
    Projective.Collinear K (PlaneVec K) (colDirection (K := K))
      (affinePoint (K := K) p) (affinePoint (K := K) q) ↔ p.1 = q.1 := by
  change Projective.Collinear K (PlaneVec K)
      (Projectivization.mk K (colDirectionVec (K := K)) colDirectionVec_ne_zero)
      (Projectivization.mk K (affineVec (K := K) p) (affineVec_ne_zero p))
      (Projectivization.mk K (affineVec (K := K) q) (affineVec_ne_zero q)) ↔ p.1 = q.1
  rw [mk_collinear_iff_det_eq_zero colDirectionVec_ne_zero (affineVec_ne_zero p)
    (affineVec_ne_zero q), det_colDirection_affine_affine]
  rw [sub_eq_zero]
  exact eq_comm

/-- No affine point lies on the line at infinity: the two fixed directions
`[1 : 0 : 0]` and `[0 : 1 : 0]` are never collinear with a chart image
`[p₁ : p₂ : 1]`, because the corresponding determinant equals `1`. -/
theorem not_collinear_row_col_affine (p : GridPoint K) :
    ¬ Projective.Collinear K (PlaneVec K) (rowDirection (K := K))
      (colDirection (K := K)) (affinePoint (K := K) p) := by
  intro hcol
  have hdet := (mk_collinear_iff_det_eq_zero
    (K := K) rowDirectionVec_ne_zero colDirectionVec_ne_zero (affineVec_ne_zero p)).mp
    (by simpa [rowDirection, colDirection, affinePoint] using hcol)
  simp [det_rowDirection_colDirection_affine] at hdet

/-- The chart identifies the two notions of collinearity: three cells `p`, `q`, `r`
of `K × K` satisfy the division-free affine collinearity relation exactly when their
chart images `[p₁ : p₂ : 1]`, `[q₁ : q₂ : 1]`, `[r₁ : r₂ : 1]` lie on a common
projective line. Both sides are the vanishing of the same determinant. -/
theorem collinear_affine_iff_grid (p q r : GridPoint K) :
    Projective.Collinear K (PlaneVec K) (affinePoint (K := K) p)
      (affinePoint (K := K) q) (affinePoint (K := K) r) ↔
      ProjectiveCap.Collinear (K := K) p q r := by
  change Projective.Collinear K (PlaneVec K)
      (Projectivization.mk K (affineVec (K := K) p) (affineVec_ne_zero p))
      (Projectivization.mk K (affineVec (K := K) q) (affineVec_ne_zero q))
      (Projectivization.mk K (affineVec (K := K) r) (affineVec_ne_zero r)) ↔
    ProjectiveCap.Collinear (K := K) p q r
  rw [mk_collinear_iff_det_eq_zero (affineVec_ne_zero p) (affineVec_ne_zero q)
    (affineVec_ne_zero r), det_affine_affine_affine]
  unfold ProjectiveCap.Collinear
  constructor <;> intro h
  · linear_combination h
  · linear_combination h

variable [DecidableEq (Point K (PlaneVec K))]

/-- The pair of fixed directions `{[1 : 0 : 0], [0 : 1 : 0]}` spanning the line at
infinity of the coordinate projective plane. -/
def fixedDirections : Finset (Point K (PlaneVec K)) :=
  ({rowDirection (K := K), colDirection (K := K)} : Finset (Point K (PlaneVec K)))

/-- The direction `[1 : 0 : 0]` belongs to the fixed pair of directions. -/
theorem rowDirection_mem_fixedDirections :
    rowDirection (K := K) ∈ fixedDirections (K := K) := by
  simp [fixedDirections]

/-- The direction `[0 : 1 : 0]` belongs to the fixed pair of directions. -/
theorem colDirection_mem_fixedDirections :
    colDirection (K := K) ∈ fixedDirections (K := K) := by
  simp [fixedDirections]

/-- The two fixed directions are distinct, so the set holding them has two
elements. -/
theorem fixedDirections_card :
    (fixedDirections (K := K)).card = 2 := by
  simp [fixedDirections, rowDirection_ne_colDirection]

/-- Adding a cell commutes with forming the attached projective set: inserting the
chart image of `p` into the union of the two fixed directions with the affine image
of `S` gives the set attached to `insert p S`. -/
theorem insert_affine_fixed_union_image [DecidableEq K] {S : Finset (GridPoint K)}
    (p : GridPoint K) :
    insert (affinePoint (K := K) p)
        (fixedDirections (K := K) ∪ S.map (affineEmbedding (K := K))) =
      fixedDirections (K := K) ∪ (insert p S).map (affineEmbedding (K := K)) := by
  ext x
  simp [Finset.map_insert, affineEmbedding]

omit [DecidableEq (Point K (PlaneVec K))] in
/-- A cell of `S` has its chart image `[p₁ : p₂ : 1]` in the affine image of `S`. -/
theorem affinePoint_mem_map {S : Finset (GridPoint K)} {p : GridPoint K} (hp : p ∈ S) :
    affinePoint (K := K) p ∈ S.map (affineEmbedding (K := K)) := by
  exact Finset.mem_map.mpr ⟨p, hp, rfl⟩

/-- Case analysis on membership in the projective set attached to `S`: a point of
the union of the two fixed directions with the affine image of `S` is either
`[1 : 0 : 0]`, or `[0 : 1 : 0]`, or `[p₁ : p₂ : 1]` for some cell `p ∈ S`. -/
theorem mem_fixed_union_image_cases [DecidableEq K] {S : Finset (GridPoint K)}
    {x : Point K (PlaneVec K)}
    (hx : x ∈ fixedDirections (K := K) ∪ S.map (affineEmbedding (K := K))) :
    x = rowDirection (K := K) ∨ x = colDirection (K := K) ∨
      ∃ p : GridPoint K, p ∈ S ∧ x = affinePoint (K := K) p := by
  rcases Finset.mem_union.mp hx with hfixed | himage
  · have hfixed' : x = rowDirection (K := K) ∨ x = colDirection (K := K) := by
      simpa [fixedDirections] using hfixed
    rcases hfixed' with hrow | hcol
    · exact Or.inl hrow
    · exact Or.inr (Or.inl hcol)
  · rcases Finset.mem_map.mp himage with ⟨p, hp, hpx⟩
    exact Or.inr (Or.inr ⟨p, hp, hpx.symm⟩)

/-- The two fixed directions `[1 : 0 : 0]` and `[0 : 1 : 0]` lie on the line at
infinity, so they are disjoint from the affine image of any finite set of grid
cells. -/
theorem fixedDirections_disjoint_affineImage [DecidableEq K]
    (S : Finset (GridPoint K)) :
    Disjoint (fixedDirections (K := K)) (S.map (affineEmbedding (K := K))) := by
  rw [Finset.disjoint_left]
  intro x hxFixed hxImage
  have hfixed : x = rowDirection (K := K) ∨ x = colDirection (K := K) := by
    simpa [fixedDirections] using hxFixed
  rcases Finset.mem_map.mp hxImage with ⟨p, _hp, hpx⟩
  rcases hfixed with hrow | hcol
  · have hpRow : affinePoint (K := K) p = rowDirection (K := K) := by
      simpa [affineEmbedding] using hpx.trans hrow
    exact affinePoint_ne_rowDirection (K := K) p hpRow
  · have hpCol : affinePoint (K := K) p = colDirection (K := K) := by
      simpa [affineEmbedding] using hpx.trans hcol
    exact affinePoint_ne_colDirection (K := K) p hpCol

/-- Cardinality of the projective set attached to a finite set `S` of grid cells:
the two fixed directions together with the affine image of `S` have exactly
`2 + S.card` elements, since the two directions are distinct, the affine chart is
injective, and no affine point equals a fixed direction. -/
theorem fixed_union_affine_image_card [DecidableEq K]
    (S : Finset (GridPoint K)) :
    (fixedDirections (K := K) ∪ S.map (affineEmbedding (K := K))).card =
      2 + S.card := by
  rw [Finset.card_union_of_disjoint (fixedDirections_disjoint_affineImage (K := K) S),
    fixedDirections_card (K := K), Finset.card_map]

omit [DecidableEq (Point K (PlaneVec K))] in
/-- Collinearity of a triple of points of the coordinate projective plane depends
only on the underlying set: if `{a, b, c} = {a', b', c'}` as sets, then the first
triple is collinear exactly when the second is. This licenses reordering the three
arguments. -/
theorem projectiveCollinear_congr_set {a b c a' b' c' : Point K (PlaneVec K)}
    (hset : ({a, b, c} : Set (Point K (PlaneVec K))) = {a', b', c'}) :
    Projective.Collinear K (PlaneVec K) a b c ↔
      Projective.Collinear K (PlaneVec K) a' b' c' := by
  unfold Projective.Collinear
  rw [hset]

omit [DecidableEq (Point K (PlaneVec K))] in
/-- Two distinct cells of a grid cap are not collinear with the direction
`[1 : 0 : 0]`: that would force them to share their second coordinate, contradicting
the at-most-one-point-per-column condition. -/
theorem not_collinear_row_affine_affine {S : Finset (GridPoint K)}
    (hS : GridCap (K := K) S) {p q : GridPoint K}
    (hp : p ∈ S) (hq : q ∈ S) (hpq : p ≠ q) :
    ¬ Projective.Collinear K (PlaneVec K) (rowDirection (K := K))
      (affinePoint (K := K) p) (affinePoint (K := K) q) := by
  intro hcol
  have heq : p.2 = q.2 := (collinear_rowDirection_affine_iff (K := K) p q).mp hcol
  exact hpq (hS.1.2 hp hq heq)

omit [DecidableEq (Point K (PlaneVec K))] in
/-- Two distinct cells of a grid cap are not collinear with the direction
`[0 : 1 : 0]`: that would force them to share their first coordinate, contradicting
the at-most-one-point-per-row condition. -/
theorem not_collinear_col_affine_affine {S : Finset (GridPoint K)}
    (hS : GridCap (K := K) S) {p q : GridPoint K}
    (hp : p ∈ S) (hq : q ∈ S) (hpq : p ≠ q) :
    ¬ Projective.Collinear K (PlaneVec K) (colDirection (K := K))
      (affinePoint (K := K) p) (affinePoint (K := K) q) := by
  intro hcol
  have heq : p.1 = q.1 := (collinear_colDirection_affine_iff (K := K) p q).mp hcol
  exact hpq (hS.1.1 hp hq heq)

omit [DecidableEq (Point K (PlaneVec K))] in
/-- Three distinct cells of a grid cap have projectively non-collinear images: since
`S` contains no three distinct collinear cells, the points `[p₁ : p₂ : 1]`,
`[q₁ : q₂ : 1]`, `[r₁ : r₂ : 1]` do not lie on a common projective line. -/
theorem not_collinear_affine_affine_affine {S : Finset (GridPoint K)}
    (hS : GridCap (K := K) S) {p q r : GridPoint K}
    (hp : p ∈ S) (hq : q ∈ S) (hr : r ∈ S)
    (hpq : p ≠ q) (hpr : p ≠ r) (hqr : q ≠ r) :
    ¬ Projective.Collinear K (PlaneVec K) (affinePoint (K := K) p)
      (affinePoint (K := K) q) (affinePoint (K := K) r) := by
  intro hcol
  exact hS.2 hp hq hr hpq hpr hqr
    ((collinear_affine_iff_grid (K := K) p q r).mp hcol)

/-- A projective cap gives a grid cap. If the two fixed directions `[1 : 0 : 0]` and
`[0 : 1 : 0]` together with the affine image of `S ⊆ K × K` form a cap in the
coordinate projective plane, then `S` meets each row and each column at most once and
contains no three pairwise distinct collinear cells. Collinearity with the fixed
directions is what forces the row and column conditions. -/
theorem gridCap_of_projectiveCap [DecidableEq K] {S : Finset (GridPoint K)}
    (hcap : Cap K (PlaneVec K)
      (fixedDirections (K := K) ∪ S.map (affineEmbedding (K := K)))) :
    GridCap (K := K) S := by
  constructor
  · constructor
    · intro p q hp hq hrow
      by_cases hpq : p = q
      · exact hpq
      · exfalso
        have hcol :
            Projective.Collinear K (PlaneVec K) (colDirection (K := K))
              (affinePoint (K := K) p) (affinePoint (K := K) q) :=
          (collinear_colDirection_affine_iff (K := K) p q).mpr hrow
        have hcolMem :
            colDirection (K := K) ∈
              fixedDirections (K := K) ∪ S.map (affineEmbedding (K := K)) :=
          Finset.mem_union_left _ (colDirection_mem_fixedDirections (K := K))
        have hpMem :
            affinePoint (K := K) p ∈
              fixedDirections (K := K) ∪ S.map (affineEmbedding (K := K)) :=
          Finset.mem_union_right _ (affinePoint_mem_map (K := K) hp)
        have hqMem :
            affinePoint (K := K) q ∈
              fixedDirections (K := K) ∪ S.map (affineEmbedding (K := K)) :=
          Finset.mem_union_right _ (affinePoint_mem_map (K := K) hq)
        exact hcap hcolMem hpMem hqMem
          ((affinePoint_ne_colDirection (K := K) p).symm)
          ((affinePoint_ne_colDirection (K := K) q).symm)
          (fun hpqPoint => hpq ((affinePoint_injective (K := K)) hpqPoint))
          hcol
    · intro p q hp hq hcolEq
      by_cases hpq : p = q
      · exact hpq
      · exfalso
        have hcol :
            Projective.Collinear K (PlaneVec K) (rowDirection (K := K))
              (affinePoint (K := K) p) (affinePoint (K := K) q) :=
          (collinear_rowDirection_affine_iff (K := K) p q).mpr hcolEq
        have hrowMem :
            rowDirection (K := K) ∈
              fixedDirections (K := K) ∪ S.map (affineEmbedding (K := K)) :=
          Finset.mem_union_left _ (rowDirection_mem_fixedDirections (K := K))
        have hpMem :
            affinePoint (K := K) p ∈
              fixedDirections (K := K) ∪ S.map (affineEmbedding (K := K)) :=
          Finset.mem_union_right _ (affinePoint_mem_map (K := K) hp)
        have hqMem :
            affinePoint (K := K) q ∈
              fixedDirections (K := K) ∪ S.map (affineEmbedding (K := K)) :=
          Finset.mem_union_right _ (affinePoint_mem_map (K := K) hq)
        exact hcap hrowMem hpMem hqMem
          ((affinePoint_ne_rowDirection (K := K) p).symm)
          ((affinePoint_ne_rowDirection (K := K) q).symm)
          (fun hpqPoint => hpq ((affinePoint_injective (K := K)) hpqPoint))
          hcol
  · intro p q r hp hq hr hpq hpr hqr hgrid
    have hpMem :
        affinePoint (K := K) p ∈
          fixedDirections (K := K) ∪ S.map (affineEmbedding (K := K)) :=
      Finset.mem_union_right _ (affinePoint_mem_map (K := K) hp)
    have hqMem :
        affinePoint (K := K) q ∈
          fixedDirections (K := K) ∪ S.map (affineEmbedding (K := K)) :=
      Finset.mem_union_right _ (affinePoint_mem_map (K := K) hq)
    have hrMem :
        affinePoint (K := K) r ∈
          fixedDirections (K := K) ∪ S.map (affineEmbedding (K := K)) :=
      Finset.mem_union_right _ (affinePoint_mem_map (K := K) hr)
    exact hcap hpMem hqMem hrMem
      (fun hpqPoint => hpq ((affinePoint_injective (K := K)) hpqPoint))
      (fun hprPoint => hpr ((affinePoint_injective (K := K)) hprPoint))
      (fun hqrPoint => hqr ((affinePoint_injective (K := K)) hqrPoint))
      ((collinear_affine_iff_grid (K := K) p q r).mpr hgrid)

/-- A grid cap gives a projective cap. If the finite set `S ⊆ K × K` meets each row
and each column at most once and has no three distinct collinear cells, then the set
consisting of the two fixed directions `[1 : 0 : 0]` and `[0 : 1 : 0]` together with
the affine image of `S` contains no three pairwise distinct collinear points of the
coordinate projective plane. -/
theorem projectiveCap_of_gridCap [DecidableEq K] {S : Finset (GridPoint K)}
    (hS : GridCap (K := K) S) :
    Cap K (PlaneVec K)
      (fixedDirections (K := K) ∪ S.map (affineEmbedding (K := K))) := by
  intro a b c ha hb hc hab hac hbc hcol
  rcases mem_fixed_union_image_cases (K := K) ha with rfl | rfl | ⟨pa, hpa, rfl⟩
  · rcases mem_fixed_union_image_cases (K := K) hb with rfl | rfl | ⟨pb, hpb, rfl⟩
    · exact hab rfl
    · rcases mem_fixed_union_image_cases (K := K) hc with rfl | rfl | ⟨pc, hpc, rfl⟩
      · exact hac rfl
      · exact hbc rfl
      · exact not_collinear_row_col_affine (K := K) pc hcol
    · rcases mem_fixed_union_image_cases (K := K) hc with rfl | rfl | ⟨pc, hpc, rfl⟩
      · exact hac rfl
      · have hcanon :
            Projective.Collinear K (PlaneVec K) (rowDirection (K := K))
              (colDirection (K := K)) (affinePoint (K := K) pb) :=
          (projectiveCollinear_congr_set (K := K)
            (by ext x; simp [or_left_comm, or_comm])).mp hcol
        exact not_collinear_row_col_affine (K := K) pb hcanon
      · have hpbpc : pb ≠ pc := by
          intro h
          exact hbc (by simp [h])
        exact not_collinear_row_affine_affine (K := K) hS hpb hpc hpbpc hcol
  · rcases mem_fixed_union_image_cases (K := K) hb with rfl | rfl | ⟨pb, hpb, rfl⟩
    · rcases mem_fixed_union_image_cases (K := K) hc with rfl | rfl | ⟨pc, hpc, rfl⟩
      · exact hbc rfl
      · exact hac rfl
      · have hcanon :
            Projective.Collinear K (PlaneVec K) (rowDirection (K := K))
              (colDirection (K := K)) (affinePoint (K := K) pc) :=
          (projectiveCollinear_congr_set (K := K)
            (by ext x; simp [or_left_comm, or_comm])).mp hcol
        exact not_collinear_row_col_affine (K := K) pc hcanon
    · exact hab rfl
    · rcases mem_fixed_union_image_cases (K := K) hc with rfl | rfl | ⟨pc, hpc, rfl⟩
      · have hcanon :
            Projective.Collinear K (PlaneVec K) (rowDirection (K := K))
              (colDirection (K := K)) (affinePoint (K := K) pb) :=
          (projectiveCollinear_congr_set (K := K)
            (by ext x; simp [or_left_comm, or_comm])).mp hcol
        exact not_collinear_row_col_affine (K := K) pb hcanon
      · exact hac rfl
      · have hpbpc : pb ≠ pc := by
          intro h
          exact hbc (by simp [h])
        exact not_collinear_col_affine_affine (K := K) hS hpb hpc hpbpc hcol
  · rcases mem_fixed_union_image_cases (K := K) hb with rfl | rfl | ⟨pb, hpb, rfl⟩
    · rcases mem_fixed_union_image_cases (K := K) hc with rfl | rfl | ⟨pc, hpc, rfl⟩
      · exact hbc rfl
      · have hcanon :
            Projective.Collinear K (PlaneVec K) (rowDirection (K := K))
              (colDirection (K := K)) (affinePoint (K := K) pa) :=
          (projectiveCollinear_congr_set (K := K)
            (by ext x; simp [or_left_comm, or_comm])).mp hcol
        exact not_collinear_row_col_affine (K := K) pa hcanon
      · have hpapc : pa ≠ pc := by
          intro h
          exact hac (by simp [h])
        have hcanon :
            Projective.Collinear K (PlaneVec K) (rowDirection (K := K))
              (affinePoint (K := K) pa) (affinePoint (K := K) pc) :=
          (projectiveCollinear_congr_set (K := K)
            (by ext x; simp [or_left_comm, or_comm])).mp hcol
        exact not_collinear_row_affine_affine (K := K) hS hpa hpc hpapc hcanon
    · rcases mem_fixed_union_image_cases (K := K) hc with rfl | rfl | ⟨pc, hpc, rfl⟩
      · have hcanon :
            Projective.Collinear K (PlaneVec K) (rowDirection (K := K))
              (colDirection (K := K)) (affinePoint (K := K) pa) :=
          (projectiveCollinear_congr_set (K := K)
            (by ext x; simp [or_left_comm, or_comm])).mp hcol
        exact not_collinear_row_col_affine (K := K) pa hcanon
      · exact hbc rfl
      · have hpapc : pa ≠ pc := by
          intro h
          exact hac (by simp [h])
        have hcanon :
            Projective.Collinear K (PlaneVec K) (colDirection (K := K))
              (affinePoint (K := K) pa) (affinePoint (K := K) pc) :=
          (projectiveCollinear_congr_set (K := K)
            (by ext x; simp [or_left_comm, or_comm])).mp hcol
        exact not_collinear_col_affine_affine (K := K) hS hpa hpc hpapc hcanon
    · rcases mem_fixed_union_image_cases (K := K) hc with rfl | rfl | ⟨pc, hpc, rfl⟩
      · have hpapb : pa ≠ pb := by
          intro h
          exact hab (by simp [h])
        have hcanon :
            Projective.Collinear K (PlaneVec K) (rowDirection (K := K))
              (affinePoint (K := K) pa) (affinePoint (K := K) pb) :=
          (projectiveCollinear_congr_set (K := K)
            (by ext x; simp [or_left_comm, or_comm])).mp hcol
        exact not_collinear_row_affine_affine (K := K) hS hpa hpb hpapb hcanon
      · have hpapb : pa ≠ pb := by
          intro h
          exact hab (by simp [h])
        have hcanon :
            Projective.Collinear K (PlaneVec K) (colDirection (K := K))
              (affinePoint (K := K) pa) (affinePoint (K := K) pb) :=
          (projectiveCollinear_congr_set (K := K)
            (by ext x; simp [or_left_comm, or_comm])).mp hcol
        exact not_collinear_col_affine_affine (K := K) hS hpa hpb hpapb hcanon
      · have hpapb : pa ≠ pb := by
          intro h
          exact hab (by simp [h])
        have hpapc : pa ≠ pc := by
          intro h
          exact hac (by simp [h])
        have hpbpc : pb ≠ pc := by
          intro h
          exact hbc (by simp [h])
        exact not_collinear_affine_affine_affine (K := K) hS
          hpa hpb hpc hpapb hpapc hpbpc hcol

end Coordinate
end FrameGridBridge
end Projective
end ProjectiveCap
