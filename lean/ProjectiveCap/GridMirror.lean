import ProjectiveCap.GridGame
import ProjectiveCap.GridSeed
import Mathlib.Tactic

/-!
# Characteristic-two residual grid mirror

This file starts WP-2: the residual grid game after the normalized projective
frame has a diagonal translation mirror in characteristic two.
-/

namespace ProjectiveCap
namespace GridMirror

variable {K : Type*} [Field K]

/-- Diagonal translation by `(1,1)` on the residual grid. -/
def diagTranslate (p : GridPoint K) : GridPoint K :=
  (p.1 + 1, p.2 + 1)

theorem diagTranslate_involutive (h2 : (2 : K) = 0) (p : GridPoint K) :
    diagTranslate (K := K) (diagTranslate (K := K) p) = p := by
  ext <;> dsimp [diagTranslate] <;> linear_combination h2

theorem diagTranslate_fpf (p : GridPoint K) :
    diagTranslate (K := K) p ≠ p := by
  intro h
  have h1 : p.1 + 1 = p.1 := congrArg Prod.fst h
  have hone : (1 : K) = 0 := by
    linear_combination h1
  exact one_ne_zero hone

theorem diagTranslate_row_ne (p : GridPoint K) :
    (diagTranslate (K := K) p).1 ≠ p.1 := by
  intro h
  change p.1 + 1 = p.1 at h
  have hone : (1 : K) = 0 := by
    linear_combination h
  exact one_ne_zero hone

theorem diagTranslate_col_ne (p : GridPoint K) :
    (diagTranslate (K := K) p).2 ≠ p.2 := by
  intro h
  change p.2 + 1 = p.2 at h
  have hone : (1 : K) = 0 := by
    linear_combination h
  exact one_ne_zero hone

/-- Diagonal translation as a grid equivalence in characteristic two. -/
def diagEquiv (h2 : (2 : K) = 0) : GridPoint K ≃ GridPoint K where
  toFun := diagTranslate (K := K)
  invFun := diagTranslate (K := K)
  left_inv := diagTranslate_involutive (K := K) h2
  right_inv := diagTranslate_involutive (K := K) h2

theorem diagEquiv_apply (h2 : (2 : K) = 0) (p : GridPoint K) :
    diagEquiv (K := K) h2 p = diagTranslate (K := K) p :=
  rfl

theorem collinear_diagTranslate_iff (_h2 : (2 : K) = 0) (p q r : GridPoint K) :
    Collinear (K := K) (diagTranslate (K := K) p)
      (diagTranslate (K := K) q) (diagTranslate (K := K) r) ↔
      Collinear (K := K) p q r := by
  unfold Collinear diagTranslate
  constructor <;> intro h <;> linear_combination h

theorem collinear_swap_left {a b c : GridPoint K} :
    Collinear (K := K) a b c ↔ Collinear (K := K) b a c := by
  unfold Collinear
  constructor <;> intro h <;> linear_combination -h

theorem collinear_rotate {a b c : GridPoint K} :
    Collinear (K := K) a b c ↔ Collinear (K := K) b c a := by
  unfold Collinear
  constructor <;> intro h <;> linear_combination h

theorem collinear_diagTranslate_left_iff (h2 : (2 : K) = 0) (p q r : GridPoint K) :
    Collinear (K := K) (diagTranslate (K := K) p) q r ↔
      Collinear (K := K) p (diagTranslate (K := K) q)
        (diagTranslate (K := K) r) := by
  have h := collinear_diagTranslate_iff (K := K) h2
    (diagTranslate (K := K) p) q r
  simpa [diagTranslate_involutive (K := K) h2 p] using h.symm

theorem collinear_with_mirror_forces_old_line (h2 : (2 : K) = 0)
    {x p : GridPoint K}
    (hcol : Collinear (K := K) x (diagTranslate (K := K) x) p) :
    Collinear (K := K) x p (diagTranslate (K := K) p) := by
  unfold Collinear diagTranslate at hcol ⊢
  linear_combination hcol + (p.1 - x.1 - p.2 + x.2) * h2

section Game

variable [Fintype K] [DecidableEq K]

/-- A residual grid position symmetric under the characteristic-two diagonal mirror. -/
def DiagMirrorGood (h2 : (2 : K) = 0) (S : Finset (GridPoint K)) : Prop :=
  GridCap (K := K) S ∧ S.map (diagEquiv (K := K) h2).toEmbedding = S

omit [Fintype K] [DecidableEq K] in
theorem mem_of_diag_image_eq_self (h2 : (2 : K) = 0) {S : Finset (GridPoint K)}
    (hinv : S.map (diagEquiv (K := K) h2).toEmbedding = S) {p : GridPoint K}
    (hp : p ∈ S) :
    diagTranslate (K := K) p ∈ S := by
  rw [← hinv]
  exact Finset.mem_map_of_mem _ hp

omit [Fintype K] [DecidableEq K] in
theorem mem_iff_of_diag_image_eq_self (h2 : (2 : K) = 0)
    {S : Finset (GridPoint K)}
    (hinv : S.map (diagEquiv (K := K) h2).toEmbedding = S) {p : GridPoint K} :
    diagTranslate (K := K) p ∈ S ↔ p ∈ S := by
  constructor
  · intro hp
    have hpre := mem_of_diag_image_eq_self (K := K) h2 hinv hp
    simpa [diagTranslate_involutive (K := K) h2 p] using hpre
  · exact mem_of_diag_image_eq_self (K := K) h2 hinv

omit [Fintype K] in
theorem standardResidualSeed_diagMirrorGood (h2 : (2 : K) = 0) :
    DiagMirrorGood (K := K) h2 (StandardResidualSeed (K := K)) := by
  refine ⟨standardResidualSeed_gridCap (K := K), ?_⟩
  ext p
  simp only [Finset.mem_map, Equiv.toEmbedding_apply, diagEquiv_apply]
  constructor
  · rintro ⟨q, hq, rfl⟩
    simp only [StandardResidualSeed, Finset.mem_insert, Finset.mem_singleton] at hq ⊢
    rcases hq with rfl | rfl
    · right
      ext <;> simp [diagTranslate]
    · left
      ext <;> dsimp [diagTranslate] <;> linear_combination h2
  · intro hp
    simp only [StandardResidualSeed, Finset.mem_insert, Finset.mem_singleton] at hp
    rcases hp with rfl | rfl
    · refine ⟨((1 : K), (1 : K)), ?_, ?_⟩
      · simp [StandardResidualSeed]
      · ext <;> dsimp [diagTranslate] <;> linear_combination h2
    · refine ⟨((0 : K), (0 : K)), ?_, ?_⟩
      · simp [StandardResidualSeed]
      · ext <;> simp [diagTranslate]

omit [Fintype K] in
/-- A diagonal-mirror reply is fresh. -/
theorem diag_reply_not_mem (h2 : (2 : K) = 0) {S : Finset (GridPoint K)}
    (hinv : S.map (diagEquiv (K := K) h2).toEmbedding = S)
    {x : GridPoint K} (hxmove : GridGame.Move (K := K) S x) :
    diagTranslate (K := K) x ∉ insert x S := by
  intro hy
  rcases Finset.mem_insert.mp hy with hyx | hyS
  · exact diagTranslate_fpf (K := K) x hyx
  · have hxS : x ∈ S :=
      (mem_iff_of_diag_image_eq_self (K := K) h2 hinv).mp hyS
    exact hxmove.1 hxS

omit [Fintype K] in
theorem old_row_ne_diag_reply (h2 : (2 : K) = 0)
    {S : Finset (GridPoint K)} (hinv : S.map (diagEquiv (K := K) h2).toEmbedding = S)
    {x z : GridPoint K} (hxmove : GridGame.Move (K := K) S x) (hzS : z ∈ S) :
    (diagTranslate (K := K) x).1 ≠ z.1 := by
  intro hrow
  have hdiagzS : diagTranslate (K := K) z ∈ S :=
    mem_of_diag_image_eq_self (K := K) h2 hinv hzS
  have hrowDiag : x.1 = (diagTranslate (K := K) z).1 := by
    change x.1 + 1 = z.1 at hrow
    have h11 : (1 : K) + 1 = 0 := by linear_combination h2
    calc
      x.1 = x.1 + 0 := by rw [add_zero]
      _ = x.1 + (1 + 1) := by rw [h11]
      _ = (x.1 + 1) + 1 := by ring
      _ = z.1 + 1 := by rw [hrow]
      _ = (diagTranslate (K := K) z).1 := by rfl
  have hx_eq_diagz : x = diagTranslate (K := K) z :=
    hxmove.2.1.1 (by simp) (by simp [hdiagzS]) hrowDiag
  have hz_eq_y : z = diagTranslate (K := K) x := by
    calc
      z = diagTranslate (K := K) (diagTranslate (K := K) z) :=
        (diagTranslate_involutive (K := K) h2 z).symm
      _ = diagTranslate (K := K) x := by rw [← hx_eq_diagz]
  exact diag_reply_not_mem (K := K) h2 hinv hxmove (by
    exact Finset.mem_insert.mpr (Or.inr (hz_eq_y ▸ hzS)))

omit [Fintype K] in
theorem old_col_ne_diag_reply (h2 : (2 : K) = 0)
    {S : Finset (GridPoint K)} (hinv : S.map (diagEquiv (K := K) h2).toEmbedding = S)
    {x z : GridPoint K} (hxmove : GridGame.Move (K := K) S x) (hzS : z ∈ S) :
    (diagTranslate (K := K) x).2 ≠ z.2 := by
  intro hcol
  have hdiagzS : diagTranslate (K := K) z ∈ S :=
    mem_of_diag_image_eq_self (K := K) h2 hinv hzS
  have hcolDiag : x.2 = (diagTranslate (K := K) z).2 := by
    change x.2 + 1 = z.2 at hcol
    have h11 : (1 : K) + 1 = 0 := by linear_combination h2
    calc
      x.2 = x.2 + 0 := by rw [add_zero]
      _ = x.2 + (1 + 1) := by rw [h11]
      _ = (x.2 + 1) + 1 := by ring
      _ = z.2 + 1 := by rw [hcol]
      _ = (diagTranslate (K := K) z).2 := by rfl
  have hx_eq_diagz : x = diagTranslate (K := K) z :=
    hxmove.2.1.2 (by simp) (by simp [hdiagzS]) hcolDiag
  have hz_eq_y : z = diagTranslate (K := K) x := by
    calc
      z = diagTranslate (K := K) (diagTranslate (K := K) z) :=
        (diagTranslate_involutive (K := K) h2 z).symm
      _ = diagTranslate (K := K) x := by rw [← hx_eq_diagz]
  exact diag_reply_not_mem (K := K) h2 hinv hxmove (by
    exact Finset.mem_insert.mpr (Or.inr (hz_eq_y ▸ hzS)))

omit [Fintype K] in
theorem rowSparse_insert_diag_reply (h2 : (2 : K) = 0)
    {S : Finset (GridPoint K)} (hinv : S.map (diagEquiv (K := K) h2).toEmbedding = S)
    {x : GridPoint K} (hxmove : GridGame.Move (K := K) S x) :
    RowSparse (K := K) (insert (diagTranslate (K := K) x) (insert x S)) := by
  intro p q hp hq hrow
  let y := diagTranslate (K := K) x
  have hrowx : RowSparse (K := K) (insert x S) := hxmove.2.1.1
  by_cases hpy : p = y
  · subst hpy
    rcases Finset.mem_insert.mp hq with hqy | hqOld
    · exact hqy.symm
    · rcases Finset.mem_insert.mp hqOld with hqx | hqS
      · exact (diagTranslate_row_ne (K := K) x (by simpa [y, hqx] using hrow)).elim
      · exact (old_row_ne_diag_reply (K := K) h2 hinv hxmove hqS hrow).elim
  · have hpOld : p ∈ insert x S := by
      rcases Finset.mem_insert.mp hp with hpY | hpOld
      · exact (hpy hpY).elim
      · exact hpOld
    rcases Finset.mem_insert.mp hq with hqy | hqOld
    · subst hqy
      rcases Finset.mem_insert.mp hpOld with hpx | hpS
      · exact (diagTranslate_row_ne (K := K) x (by simpa [y, hpx] using hrow.symm)).elim
      · exact (old_row_ne_diag_reply (K := K) h2 hinv hxmove hpS hrow.symm).elim
    · exact hrowx hpOld hqOld hrow

omit [Fintype K] in
theorem colSparse_insert_diag_reply (h2 : (2 : K) = 0)
    {S : Finset (GridPoint K)} (hinv : S.map (diagEquiv (K := K) h2).toEmbedding = S)
    {x : GridPoint K} (hxmove : GridGame.Move (K := K) S x) :
    ColSparse (K := K) (insert (diagTranslate (K := K) x) (insert x S)) := by
  intro p q hp hq hcol
  let y := diagTranslate (K := K) x
  have hcolx : ColSparse (K := K) (insert x S) := hxmove.2.1.2
  by_cases hpy : p = y
  · subst hpy
    rcases Finset.mem_insert.mp hq with hqy | hqOld
    · exact hqy.symm
    · rcases Finset.mem_insert.mp hqOld with hqx | hqS
      · exact (diagTranslate_col_ne (K := K) x (by simpa [y, hqx] using hcol)).elim
      · exact (old_col_ne_diag_reply (K := K) h2 hinv hxmove hqS hcol).elim
  · have hpOld : p ∈ insert x S := by
      rcases Finset.mem_insert.mp hp with hpY | hpOld
      · exact (hpy hpY).elim
      · exact hpOld
    rcases Finset.mem_insert.mp hq with hqy | hqOld
    · subst hqy
      rcases Finset.mem_insert.mp hpOld with hpx | hpS
      · exact (diagTranslate_col_ne (K := K) x (by simpa [y, hpx] using hcol.symm)).elim
      · exact (old_col_ne_diag_reply (K := K) h2 hinv hxmove hpS hcol.symm).elim
    · exact hcolx hpOld hqOld hcol

omit [Fintype K] [DecidableEq K] in
theorem diagTranslate_ne_of_ne (h2 : (2 : K) = 0) {p q : GridPoint K} (hpq : p ≠ q) :
    diagTranslate (K := K) p ≠ diagTranslate (K := K) q := by
  intro h
  apply hpq
  calc
    p = diagTranslate (K := K) (diagTranslate (K := K) p) :=
      (diagTranslate_involutive (K := K) h2 p).symm
    _ = diagTranslate (K := K) (diagTranslate (K := K) q) := by rw [h]
    _ = q := diagTranslate_involutive (K := K) h2 q

omit [Fintype K] in
theorem not_collinear_diag_reply_old_old (h2 : (2 : K) = 0)
    {S : Finset (GridPoint K)} (hinv : S.map (diagEquiv (K := K) h2).toEmbedding = S)
    {x p q : GridPoint K} (hxmove : GridGame.Move (K := K) S x)
    (hp : p ∈ insert x S) (hq : q ∈ insert x S)
    (_hyp : diagTranslate (K := K) x ≠ p) (_hyq : diagTranslate (K := K) x ≠ q)
    (hpq : p ≠ q) :
    ¬ Collinear (K := K) (diagTranslate (K := K) x) p q := by
  intro hcol
  have hcapx : GridCap (K := K) (insert x S) := hxmove.2
  rcases Finset.mem_insert.mp hp with hpx | hpS
  · rcases Finset.mem_insert.mp hq with hqx | hqS
    · exact hpq (hpx.trans hqx.symm)
    · have hdiagqS : diagTranslate (K := K) q ∈ S :=
        mem_of_diag_image_eq_self (K := K) h2 hinv hqS
      have hx_diagq : x ≠ diagTranslate (K := K) q := fun h => hxmove.1 (h ▸ hdiagqS)
      have hline : Collinear (K := K) x q (diagTranslate (K := K) q) :=
        collinear_with_mirror_forces_old_line (K := K) h2
          (by simpa [hpx] using (collinear_swap_left (K := K)).mp hcol)
      exact hcapx.2 (by simp) (Finset.mem_insert.mpr (Or.inr hqS))
        (Finset.mem_insert.mpr (Or.inr hdiagqS))
        (fun hxq => hpq (hpx.trans hxq)) hx_diagq
        (diagTranslate_fpf (K := K) q).symm hline
  · rcases Finset.mem_insert.mp hq with hqx | hqS
    · have hdiagpS : diagTranslate (K := K) p ∈ S :=
        mem_of_diag_image_eq_self (K := K) h2 hinv hpS
      have hx_diagp : x ≠ diagTranslate (K := K) p := fun h => hxmove.1 (h ▸ hdiagpS)
      have hlineYX : Collinear (K := K) x (diagTranslate (K := K) x) p :=
        by simpa [hqx] using
          (collinear_rotate (K := K)).mp ((collinear_rotate (K := K)).mp hcol)
      have hline : Collinear (K := K) x p (diagTranslate (K := K) p) :=
        collinear_with_mirror_forces_old_line (K := K) h2 hlineYX
      exact hcapx.2 (by simp) (Finset.mem_insert.mpr (Or.inr hpS))
        (Finset.mem_insert.mpr (Or.inr hdiagpS))
        (fun hxp => hpq (hxp.symm.trans hqx.symm)) hx_diagp
        (diagTranslate_fpf (K := K) p).symm hline
    · have hdiagpS : diagTranslate (K := K) p ∈ S :=
        mem_of_diag_image_eq_self (K := K) h2 hinv hpS
      have hdiagqS : diagTranslate (K := K) q ∈ S :=
        mem_of_diag_image_eq_self (K := K) h2 hinv hqS
      have hx_diagp : x ≠ diagTranslate (K := K) p := fun h => hxmove.1 (h ▸ hdiagpS)
      have hx_diagq : x ≠ diagTranslate (K := K) q := fun h => hxmove.1 (h ▸ hdiagqS)
      have hdiagpq : diagTranslate (K := K) p ≠ diagTranslate (K := K) q :=
        diagTranslate_ne_of_ne (K := K) h2 hpq
      have hline : Collinear (K := K) x
          (diagTranslate (K := K) p) (diagTranslate (K := K) q) :=
        (collinear_diagTranslate_left_iff (K := K) h2 x p q).mp hcol
      exact hcapx.2 (by simp) (by simp [hdiagpS]) (by simp [hdiagqS])
        hx_diagp hx_diagq hdiagpq hline

omit [Fintype K] in
theorem affineCap_insert_diag_reply (h2 : (2 : K) = 0)
    {S : Finset (GridPoint K)} (hinv : S.map (diagEquiv (K := K) h2).toEmbedding = S)
    {x : GridPoint K} (hxmove : GridGame.Move (K := K) S x) :
    AffineCap (K := K) (insert (diagTranslate (K := K) x) (insert x S)) := by
  intro a b c ha hb hc hab hac hbc hcol
  let y := diagTranslate (K := K) x
  have hcapx : GridCap (K := K) (insert x S) := hxmove.2
  by_cases hay : a = y
  · subst hay
    have hbOld : b ∈ insert x S := by
      rcases Finset.mem_insert.mp hb with hbY | hbOld
      · exact (hab hbY.symm).elim
      · exact hbOld
    have hcOld : c ∈ insert x S := by
      rcases Finset.mem_insert.mp hc with hcY | hcOld
      · exact (hac hcY.symm).elim
      · exact hcOld
    exact not_collinear_diag_reply_old_old (K := K) h2 hinv hxmove
      hbOld hcOld hab hac hbc hcol
  · have haOld : a ∈ insert x S := by
      rcases Finset.mem_insert.mp ha with haY | haOld
      · exact (hay haY).elim
      · exact haOld
    by_cases hby : b = y
    · subst hby
      have hcOld : c ∈ insert x S := by
        rcases Finset.mem_insert.mp hc with hcY | hcOld
        · exact (hbc hcY.symm).elim
        · exact hcOld
      exact not_collinear_diag_reply_old_old (K := K) h2 hinv hxmove
        haOld hcOld hab.symm hbc hac ((collinear_swap_left (K := K)).mp hcol)
    · have hbOld : b ∈ insert x S := by
        rcases Finset.mem_insert.mp hb with hbY | hbOld
        · exact (hby hbY).elim
        · exact hbOld
      by_cases hcy : c = y
      · subst hcy
        have hcol' : Collinear (K := K) y a b :=
          (collinear_rotate (K := K)).mp ((collinear_rotate (K := K)).mp hcol)
        exact not_collinear_diag_reply_old_old (K := K) h2 hinv hxmove
          haOld hbOld hac.symm hbc.symm hab hcol'
      · have hcOld : c ∈ insert x S := by
          rcases Finset.mem_insert.mp hc with hcY | hcOld
          · exact (hcy hcY).elim
          · exact hcOld
        exact hcapx.2 haOld hbOld hcOld hab hac hbc hcol

omit [Fintype K] in
theorem diag_mirror_move_legal (h2 : (2 : K) = 0) {S : Finset (GridPoint K)}
    (hgood : DiagMirrorGood (K := K) h2 S) {x : GridPoint K}
    (hxmove : GridGame.Move (K := K) S x) :
    GridGame.Move (K := K) (insert x S) (diagTranslate (K := K) x) := by
  rcases hgood with ⟨_hcapS, hinv⟩
  refine ⟨diag_reply_not_mem (K := K) h2 hinv hxmove, ?_⟩
  exact ⟨⟨rowSparse_insert_diag_reply (K := K) h2 hinv hxmove,
    colSparse_insert_diag_reply (K := K) h2 hinv hxmove⟩,
    affineCap_insert_diag_reply (K := K) h2 hinv hxmove⟩

omit [Fintype K] in
theorem diagMirrorGood_step (h2 : (2 : K) = 0) :
    ∀ {S : Finset (GridPoint K)}, DiagMirrorGood (K := K) h2 S ->
      ∀ x : GridPoint K, GridGame.Move (K := K) S x ->
        ∃ y : GridPoint K,
          GridGame.Move (K := K) (insert x S) y ∧
            DiagMirrorGood (K := K) h2 (insert y (insert x S)) := by
  intro S hgood x hxmove
  let y := diagTranslate (K := K) x
  have hymove : GridGame.Move (K := K) (insert x S) y :=
    diag_mirror_move_legal (K := K) h2 hgood hxmove
  refine ⟨y, hymove, ?_⟩
  refine ⟨hymove.2, ?_⟩
  rcases hgood with ⟨_hcapS, hinv⟩
  subst y
  simp [Finset.map_insert, hinv, diagEquiv_apply,
    diagTranslate_involutive (K := K) h2 x, Finset.insert_comm]

theorem isP_of_diagMirrorGood (h2 : (2 : K) = 0) {S : Finset (GridPoint K)}
    (hgood : DiagMirrorGood (K := K) h2 S) :
    GridGame.IsP (K := K) S :=
  FiniteBuildGame.isP_of_replyStrategy
    (Valid := GridCap (K := K)) (Good := DiagMirrorGood (K := K) h2)
    (diagMirrorGood_step (K := K) h2) S hgood

/-- WP-2 residual theorem: in characteristic two, the normalized frame residual is P. -/
theorem standardResidualSeed_isP_of_charTwo (h2 : (2 : K) = 0) :
    GridGame.IsP (K := K) (StandardResidualSeed (K := K)) :=
  isP_of_diagMirrorGood (K := K) h2 (standardResidualSeed_diagMirrorGood (K := K) h2)

end Game

end GridMirror
end ProjectiveCap
