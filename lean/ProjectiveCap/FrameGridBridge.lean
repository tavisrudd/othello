import ProjectiveCap.PlaneTransitivity
import ProjectiveCap.GridGame
import ProjectiveCap.GridSeed
import Mathlib.LinearAlgebra.Matrix.NonsingularInverse
import Mathlib.Tactic

/-!
# Frame-to-grid bridge interface

This module isolates the WP-1 proof obligation from the projective-cap plan.
After two projective directions are fixed, the remaining affine chart should be
equivalent to the residual grid game with the two burned parallel classes.

The coordinate construction and validity bridge are proved in the standard
coordinate model.  The game-theoretic consequence is isolated separately:
normal-play values transport from the fixed projective residual to the residual
grid game through any `FrameGridBridge`.
-/

open scoped LinearAlgebra.Projectivization

namespace ProjectiveCap
namespace Projective

variable (K V A : Type*) [Field K] [AddCommGroup V] [Module K V]
variable [Fintype K] [DecidableEq K] [DecidableEq (Point K V)]

/--
Data for the residual projective-to-grid bridge.

`fixed` is the already-played projective prefix, normally the two burned
directions.  `A` is the affine-chart board inside projective space.  The
load-bearing field is `valid_iff_grid`: adjoining the fixed projective prefix to
the image of a grid position is a projective cap exactly when the grid position
is a residual `GridCap`.
-/
structure FrameGridBridge where
  fixed : Finset (Point K V)
  toAffine : GridPoint K ≃ A
  project : A ↪ Point K V
  valid_iff_grid : ∀ S : Finset (GridPoint K),
    Cap K V (fixed ∪ ((S.map toAffine.toEmbedding).map project)) ↔ GridCap S

namespace FrameGridBridge

variable {K V A}
variable [Fintype A] [DecidableEq A]

/-- The finite building-game validity predicate on the affine-chart board, with
the fixed projective prefix always adjoined. -/
def FixedValid (B : FrameGridBridge K V A) (T : Finset A) : Prop :=
  Cap K V (B.fixed ∪ T.map B.project)

/-- The projective frame represented by a bridge and the normalized residual
seed `{(0,0),(1,1)}`. -/
def projectiveFrame (B : FrameGridBridge K V A) : Finset (Point K V) :=
  B.fixed ∪ ((StandardResidualSeed (K := K)).map B.toAffine.toEmbedding).map B.project

omit [Fintype K] [DecidableEq K] [Fintype A] [DecidableEq A] in
theorem fixedValid_image_iff_grid (B : FrameGridBridge K V A)
    (S : Finset (GridPoint K)) :
    FixedValid B (S.map B.toAffine.toEmbedding) ↔ GridCap S :=
  B.valid_iff_grid S

/--
WP-1 game-value consequence: a completed frame-grid bridge transports the
normal-play value of every residual grid position to the corresponding
fixed-prefix projective residual position.
-/
theorem win_fixedValid_iff_grid (B : FrameGridBridge K V A)
    (S : Finset (GridPoint K)) :
    FiniteBuildGame.Win (FixedValid B) (S.map B.toAffine.toEmbedding) ↔
      GridGame.Win (K := K) S :=
  FiniteBuildGame.win_equiv (α := GridPoint K) (β := A)
    (Validα := GridCap (K := K)) (Validβ := FixedValid B)
    B.toAffine B.valid_iff_grid S

/-- The P-position form of `win_fixedValid_iff_grid`. -/
theorem isP_fixedValid_iff_grid (B : FrameGridBridge K V A)
    (S : Finset (GridPoint K)) :
    FiniteBuildGame.IsP (FixedValid B) (S.map B.toAffine.toEmbedding) ↔
      GridGame.IsP (K := K) S :=
  FiniteBuildGame.isP_equiv (α := GridPoint K) (β := A)
    (Validα := GridCap (K := K)) (Validβ := FixedValid B)
    B.toAffine B.valid_iff_grid S

/-- The normalized projective frame has the residual-grid value of
`StandardResidualSeed`. -/
theorem isP_projectiveFrame_iff_standardResidualSeed (B : FrameGridBridge K V A) :
    FiniteBuildGame.IsP (FixedValid B)
        ((StandardResidualSeed (K := K)).map B.toAffine.toEmbedding) ↔
      GridGame.IsP (K := K) (StandardResidualSeed (K := K)) :=
  isP_fixedValid_iff_grid B (StandardResidualSeed (K := K))

/-- Statement target for WP-1: construct an affine-chart board and a bridge. -/
def Statement : Prop :=
  Nonempty (FrameGridBridge K V (GridPoint K))

end FrameGridBridge

namespace FrameGridBridge
namespace Coordinate

variable {K : Type*} [Field K]

/-- Coordinate model for the projective plane used by the residual-grid bridge. -/
abbrev PlaneVec (K : Type*) := Fin 3 -> K

def rowDirectionVec : PlaneVec K :=
  ![(1 : K), 0, 0]

def colDirectionVec : PlaneVec K :=
  ![(0 : K), 1, 0]

def affineVec (p : GridPoint K) : PlaneVec K :=
  ![p.1, p.2, (1 : K)]

theorem rowDirectionVec_ne_zero : rowDirectionVec (K := K) ≠ 0 := by
  intro h
  have h0 := congrFun h 0
  simp [rowDirectionVec] at h0

theorem colDirectionVec_ne_zero : colDirectionVec (K := K) ≠ 0 := by
  intro h
  have h1 := congrFun h 1
  simp [colDirectionVec] at h1

theorem affineVec_ne_zero (p : GridPoint K) : affineVec (K := K) p ≠ 0 := by
  intro h
  have h2 := congrFun h 2
  simp [affineVec] at h2

/-- The first burned direction in the normalized coordinate plane. -/
def rowDirection : Point K (PlaneVec K) :=
  Projectivization.mk K (rowDirectionVec (K := K)) rowDirectionVec_ne_zero

/-- The second burned direction in the normalized coordinate plane. -/
def colDirection : Point K (PlaneVec K) :=
  Projectivization.mk K (colDirectionVec (K := K)) colDirectionVec_ne_zero

/-- Affine chart point `(r,c) ↦ [r:c:1]`. -/
def affinePoint (p : GridPoint K) : Point K (PlaneVec K) :=
  Projectivization.mk K (affineVec (K := K) p) (affineVec_ne_zero p)

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

theorem affinePoint_ne_rowDirection (p : GridPoint K) :
    affinePoint (K := K) p ≠ rowDirection (K := K) := by
  intro h
  obtain ⟨a, ha⟩ := (Projectivization.mk_eq_mk_iff' K
    (affineVec (K := K) p) (rowDirectionVec (K := K))
    (affineVec_ne_zero p) rowDirectionVec_ne_zero).mp h
  have h2 := congrFun ha 2
  simp [affineVec, rowDirectionVec] at h2

theorem affinePoint_ne_colDirection (p : GridPoint K) :
    affinePoint (K := K) p ≠ colDirection (K := K) := by
  intro h
  obtain ⟨a, ha⟩ := (Projectivization.mk_eq_mk_iff' K
    (affineVec (K := K) p) (colDirectionVec (K := K))
    (affineVec_ne_zero p) colDirectionVec_ne_zero).mp h
  have h2 := congrFun ha 2
  simp [affineVec, colDirectionVec] at h2

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

theorem det_rowDirection_affine_affine (p q : GridPoint K) :
    Matrix.det ![rowDirectionVec (K := K), affineVec (K := K) p,
      affineVec (K := K) q] = p.2 - q.2 := by
  rw [Matrix.det_fin_three]
  simp [rowDirectionVec, affineVec]

theorem det_colDirection_affine_affine (p q : GridPoint K) :
    Matrix.det ![colDirectionVec (K := K), affineVec (K := K) p,
      affineVec (K := K) q] = q.1 - p.1 := by
  rw [Matrix.det_fin_three]
  simp [colDirectionVec, affineVec]
  ring

theorem det_rowDirection_colDirection_affine (p : GridPoint K) :
    Matrix.det ![rowDirectionVec (K := K), colDirectionVec (K := K),
      affineVec (K := K) p] = 1 := by
  rw [Matrix.det_fin_three]
  simp [rowDirectionVec, colDirectionVec, affineVec]

theorem det_rowDirection_colDirection_vec (v : PlaneVec K) :
    Matrix.det ![rowDirectionVec (K := K), colDirectionVec (K := K), v] = v 2 := by
  rw [Matrix.det_fin_three]
  simp [rowDirectionVec, colDirectionVec]

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

theorem det_affine_affine_affine (p q r : GridPoint K) :
    Matrix.det ![affineVec (K := K) p, affineVec (K := K) q,
      affineVec (K := K) r] =
      (q.1 - p.1) * (r.2 - p.2) - (q.2 - p.2) * (r.1 - p.1) := by
  rw [Matrix.det_fin_three]
  simp [affineVec]
  ring

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

theorem not_collinear_row_col_affine (p : GridPoint K) :
    ¬ Projective.Collinear K (PlaneVec K) (rowDirection (K := K))
      (colDirection (K := K)) (affinePoint (K := K) p) := by
  intro hcol
  have hdet := (mk_collinear_iff_det_eq_zero
    (K := K) rowDirectionVec_ne_zero colDirectionVec_ne_zero (affineVec_ne_zero p)).mp
    (by simpa [rowDirection, colDirection, affinePoint] using hcol)
  simp [det_rowDirection_colDirection_affine] at hdet

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

/-- The fixed pair of burned directions in the standard coordinate model. -/
def fixedDirections : Finset (Point K (PlaneVec K)) :=
  ({rowDirection (K := K), colDirection (K := K)} : Finset (Point K (PlaneVec K)))

theorem rowDirection_mem_fixedDirections :
    rowDirection (K := K) ∈ fixedDirections (K := K) := by
  simp [fixedDirections]

theorem colDirection_mem_fixedDirections :
    colDirection (K := K) ∈ fixedDirections (K := K) := by
  simp [fixedDirections]

theorem insert_affine_fixed_union_image [DecidableEq K] {S : Finset (GridPoint K)}
    (p : GridPoint K) :
    insert (affinePoint (K := K) p)
        (fixedDirections (K := K) ∪ S.map (affineEmbedding (K := K))) =
      fixedDirections (K := K) ∪ (insert p S).map (affineEmbedding (K := K)) := by
  ext x
  simp [Finset.map_insert, affineEmbedding]

omit [DecidableEq (Point K (PlaneVec K))] in
theorem affinePoint_mem_map {S : Finset (GridPoint K)} {p : GridPoint K} (hp : p ∈ S) :
    affinePoint (K := K) p ∈ S.map (affineEmbedding (K := K)) := by
  exact Finset.mem_map.mpr ⟨p, hp, rfl⟩

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

omit [DecidableEq (Point K (PlaneVec K))] in
theorem projectiveCollinear_congr_set {a b c a' b' c' : Point K (PlaneVec K)}
    (hset : ({a, b, c} : Set (Point K (PlaneVec K))) = {a', b', c'}) :
    Projective.Collinear K (PlaneVec K) a b c ↔
      Projective.Collinear K (PlaneVec K) a' b' c' := by
  unfold Projective.Collinear
  rw [hset]

omit [DecidableEq (Point K (PlaneVec K))] in
theorem not_collinear_row_affine_affine {S : Finset (GridPoint K)}
    (hS : GridCap (K := K) S) {p q : GridPoint K}
    (hp : p ∈ S) (hq : q ∈ S) (hpq : p ≠ q) :
    ¬ Projective.Collinear K (PlaneVec K) (rowDirection (K := K))
      (affinePoint (K := K) p) (affinePoint (K := K) q) := by
  intro hcol
  have heq : p.2 = q.2 := (collinear_rowDirection_affine_iff (K := K) p q).mp hcol
  exact hpq (hS.1.2 hp hq heq)

omit [DecidableEq (Point K (PlaneVec K))] in
theorem not_collinear_col_affine_affine {S : Finset (GridPoint K)}
    (hS : GridCap (K := K) S) {p q : GridPoint K}
    (hp : p ∈ S) (hq : q ∈ S) (hpq : p ≠ q) :
    ¬ Projective.Collinear K (PlaneVec K) (colDirection (K := K))
      (affinePoint (K := K) p) (affinePoint (K := K) q) := by
  intro hcol
  have heq : p.1 = q.1 := (collinear_colDirection_affine_iff (K := K) p q).mp hcol
  exact hpq (hS.1.1 hp hq heq)

omit [DecidableEq (Point K (PlaneVec K))] in
theorem not_collinear_affine_affine_affine {S : Finset (GridPoint K)}
    (hS : GridCap (K := K) S) {p q r : GridPoint K}
    (hp : p ∈ S) (hq : q ∈ S) (hr : r ∈ S)
    (hpq : p ≠ q) (hpr : p ≠ r) (hqr : q ≠ r) :
    ¬ Projective.Collinear K (PlaneVec K) (affinePoint (K := K) p)
      (affinePoint (K := K) q) (affinePoint (K := K) r) := by
  intro hcol
  exact hS.2 hp hq hr hpq hpr hqr
    ((collinear_affine_iff_grid (K := K) p q r).mp hcol)

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

/-- After the two coordinate directions are fixed, every legal full-projective
move is represented by a fresh affine-grid move. -/
theorem projectiveMove_exists_gridMove [Fintype K] [DecidableEq K]
    {S : Finset (GridPoint K)} {x : Point K (PlaneVec K)}
    (hxmove : FiniteBuildGame.Move (Cap K (PlaneVec K))
      (fixedDirections (K := K) ∪ S.map (affineEmbedding (K := K))) x) :
    ∃ p : GridPoint K, x = affinePoint (K := K) p ∧ GridGame.Move (K := K) S p := by
  rcases point_eq_affine_or_collinear_row_col (K := K) x with ⟨p, hxaff⟩ | hline
  · subst x
    have hpnot : p ∉ S := by
      intro hp
      exact hxmove.1 (Finset.mem_union_right _
        (affinePoint_mem_map (K := K) hp))
    have hcap :
        Cap K (PlaneVec K)
          (fixedDirections (K := K) ∪ (insert p S).map (affineEmbedding (K := K))) := by
      simpa [insert_affine_fixed_union_image (K := K) (S := S) p] using hxmove.2
    have hgrid : GridCap (K := K) (insert p S) :=
      gridCap_of_projectiveCap (K := K) hcap
    exact ⟨p, rfl, ⟨hpnot, hgrid⟩⟩
  · exfalso
    have hrowOld :
        rowDirection (K := K) ∈
          fixedDirections (K := K) ∪ S.map (affineEmbedding (K := K)) :=
      Finset.mem_union_left _ (rowDirection_mem_fixedDirections (K := K))
    have hcolOld :
        colDirection (K := K) ∈
          fixedDirections (K := K) ∪ S.map (affineEmbedding (K := K)) :=
      Finset.mem_union_left _ (colDirection_mem_fixedDirections (K := K))
    have hrowMem :
        rowDirection (K := K) ∈
          insert x (fixedDirections (K := K) ∪ S.map (affineEmbedding (K := K))) :=
      Finset.mem_insert_of_mem hrowOld
    have hcolMem :
        colDirection (K := K) ∈
          insert x (fixedDirections (K := K) ∪ S.map (affineEmbedding (K := K))) :=
      Finset.mem_insert_of_mem hcolOld
    have hxMem :
        x ∈ insert x (fixedDirections (K := K) ∪ S.map (affineEmbedding (K := K))) :=
      Finset.mem_insert_self _ _
    have hx_ne_row : x ≠ rowDirection (K := K) := by
      intro h
      exact hxmove.1 (h ▸ hrowOld)
    have hx_ne_col : x ≠ colDirection (K := K) := by
      intro h
      exact hxmove.1 (h ▸ hcolOld)
    exact hxmove.2 hrowMem hcolMem hxMem
      (rowDirection_ne_colDirection (K := K))
      (Ne.symm hx_ne_row) (Ne.symm hx_ne_col) hline

/-- Every legal residual-grid move gives the corresponding legal full-projective
move from the fixed coordinate-direction prefix. -/
theorem gridMove_to_projectiveMove [Fintype K] [DecidableEq K]
    {S : Finset (GridPoint K)} {p : GridPoint K}
    (hpmove : GridGame.Move (K := K) S p) :
    FiniteBuildGame.Move (Cap K (PlaneVec K))
      (fixedDirections (K := K) ∪ S.map (affineEmbedding (K := K)))
      (affinePoint (K := K) p) := by
  constructor
  · intro hpold
    rcases mem_fixed_union_image_cases (K := K) hpold with hrow | hcol | ⟨q, hq, hpq⟩
    · exact affinePoint_ne_rowDirection (K := K) p hrow
    · exact affinePoint_ne_colDirection (K := K) p hcol
    · exact hpmove.1 (((affinePoint_injective (K := K)) hpq).symm ▸ hq)
  · have hcap :
        Cap K (PlaneVec K)
          (fixedDirections (K := K) ∪ (insert p S).map (affineEmbedding (K := K))) :=
      projectiveCap_of_gridCap (K := K) hpmove.2
    simpa [insert_affine_fixed_union_image (K := K) (S := S) p] using hcap

/-- The fixed-prefix full projective game has the same normal-play value as
the residual grid game.  The proof uses `projectiveMove_exists_gridMove` to
show that the full board has no legal non-affine continuations after the two
coordinate directions have been played. -/
theorem win_fixedDirections_iff_grid [Fintype K] [DecidableEq K]
    [Fintype (Point K (PlaneVec K))]
    (S : Finset (GridPoint K)) :
    FiniteBuildGame.Win (Cap K (PlaneVec K))
        (fixedDirections (K := K) ∪ S.map (affineEmbedding (K := K))) ↔
      GridGame.Win (K := K) S := by
  change FiniteBuildGame.Win (Cap K (PlaneVec K))
        (fixedDirections (K := K) ∪ S.map (affineEmbedding (K := K))) ↔
      FiniteBuildGame.Win (GridCap (K := K)) S
  rw [FiniteBuildGame.win_iff_exists_move, FiniteBuildGame.win_iff_exists_move]
  constructor
  · rintro ⟨x, hxmove, hxlose⟩
    rcases projectiveMove_exists_gridMove (K := K) (S := S) hxmove with
      ⟨p, hxaff, hpmove⟩
    refine ⟨p, hpmove, ?_⟩
    intro hgridWin
    subst x
    exact hxlose (by
      simpa [insert_affine_fixed_union_image (K := K) (S := S) p] using
        (win_fixedDirections_iff_grid (insert p S)).mpr hgridWin)
  · rintro ⟨p, hpmove, hpLose⟩
    refine ⟨affinePoint (K := K) p, gridMove_to_projectiveMove (K := K) hpmove, ?_⟩
    intro hprojWin
    apply hpLose
    exact (win_fixedDirections_iff_grid (insert p S)).mp (by
      simpa [insert_affine_fixed_union_image (K := K) (S := S) p] using hprojWin)
termination_by Fintype.card (GridPoint K) - S.card
decreasing_by
  · classical
    have hp : p ∉ S := hpmove.1
    have hcard : (insert p S).card = S.card + 1 :=
      Finset.card_insert_of_notMem hp
    have hlt : S.card < Fintype.card (GridPoint K) := by
      have hsubset : S ⊆ (Finset.univ : Finset (GridPoint K)) := by
        intro y _
        exact Finset.mem_univ y
      have hproper : S ⊂ (Finset.univ : Finset (GridPoint K)) :=
        (Finset.ssubset_iff_of_subset hsubset).mpr ⟨p, Finset.mem_univ p, hp⟩
      simpa using Finset.card_lt_card hproper
    rw [hcard]
    omega
  · classical
    have hp : p ∉ S := hpmove.1
    have hcard : (insert p S).card = S.card + 1 :=
      Finset.card_insert_of_notMem hp
    have hlt : S.card < Fintype.card (GridPoint K) := by
      have hsubset : S ⊆ (Finset.univ : Finset (GridPoint K)) := by
        intro y _
        exact Finset.mem_univ y
      have hproper : S ⊂ (Finset.univ : Finset (GridPoint K)) :=
        (Finset.ssubset_iff_of_subset hsubset).mpr ⟨p, Finset.mem_univ p, hp⟩
      simpa using Finset.card_lt_card hproper
    rw [hcard]
    omega

/-- P-position form of `win_fixedDirections_iff_grid`. -/
theorem isP_fixedDirections_iff_grid [Fintype K] [DecidableEq K]
    [Fintype (Point K (PlaneVec K))]
    (S : Finset (GridPoint K)) :
    FiniteBuildGame.IsP (Cap K (PlaneVec K))
        (fixedDirections (K := K) ∪ S.map (affineEmbedding (K := K))) ↔
      GridGame.IsP (K := K) S :=
  not_congr (win_fixedDirections_iff_grid S)

/--
Concrete coordinate bridge for WP-1: the projective cap condition with the two
direction points adjoined is exactly the residual grid cap condition.
-/
def ValidityStatement [Fintype K] [DecidableEq K] : Prop :=
  ∀ S : Finset (GridPoint K),
    Cap K (PlaneVec K) (fixedDirections (K := K) ∪ S.map (affineEmbedding (K := K))) ↔
      GridCap S

/-- The coordinate frame-to-grid validity bridge. -/
theorem validityStatement [Fintype K] [DecidableEq K] :
    ValidityStatement (K := K) := by
  intro S
  constructor
  · exact gridCap_of_projectiveCap (K := K)
  · exact projectiveCap_of_gridCap (K := K)

/-- The coordinate validity statement instantiates the abstract bridge. -/
noncomputable def bridgeOfValidity [Fintype K] [DecidableEq K]
    (h : ValidityStatement (K := K)) :
    FrameGridBridge K (PlaneVec K) (GridPoint K) where
  fixed := fixedDirections (K := K)
  toAffine := Equiv.refl (GridPoint K)
  project := affineEmbedding (K := K)
  valid_iff_grid := by
    intro S
    simpa using h S

theorem statement_of_validity [Fintype K] [DecidableEq K]
    (h : ValidityStatement (K := K)) :
    Statement (K := K) (V := PlaneVec K) := by
  exact ⟨bridgeOfValidity (K := K) h⟩

/-- The standard coordinate frame-grid bridge. -/
noncomputable def coordinateBridge [Fintype K] [DecidableEq K] :
    FrameGridBridge K (PlaneVec K) (GridPoint K) :=
  bridgeOfValidity (K := K) (validityStatement (K := K))

/-- WP-1 completed in the standard coordinate projective plane. -/
theorem coordinateStatement [Fintype K] [DecidableEq K] :
    Statement (K := K) (V := PlaneVec K) :=
  statement_of_validity (K := K) (validityStatement (K := K))

end Coordinate
end FrameGridBridge

end Projective
end ProjectiveCap
