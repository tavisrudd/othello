import ProjectiveCap.PlaneTransitivity
import ProjectiveCap.ProjectiveCapGame

/-!
# Frame reduction for the projective-plane cap game

Let `K` be a field and `V` a `K`-vector space of rank three, so that the
projective space on `V` is a projective plane; when `K` is finite this is
`PG(2, q)`.  Caps and the achievement game played on them are defined in
`ProjectiveCap.Projective` and `ProjectiveCap.ProjectiveCapGame`.

This module collects the game-theoretic consequences of the plane geometry
proved in `ProjectiveCap.PlaneTransitivity`:

* `capTransitiveStatement_one` through `capTransitiveStatement_four` — for
  `k = 1, 2, 3, 4` the caps of size `k` form a single orbit under the point
  permutations induced by linear automorphisms of `V`, so every size-`k` cap
  has the same normal-play value;
* `cap_extendable` — every cap of size at most three admits a legal move;
* `exists_frame` — a four-point cap (a frame) exists;
* `initialPStatement_iff_isP_frame_of_finrank` — combining these, the assertion
  that the empty cap position is a previous-player win is equivalent to the
  same assertion about one arbitrary frame.

Also here is `isP_mapLinearEquiv`, the transport of the previous-player-win
value along the point bijection induced by a linear equivalence `V ≃ₗ[K] W`;
it holds in any rank, and is separated from the underlying cap transport
`cap_map_mapLinearEquiv` only because it mentions the game.

Every statement below refers to the achievement game.  The purely geometric
transitivity, collinearity, and normal-form results it rests on remain in
`ProjectiveCap.PlaneTransitivity`, which mentions no game.
-/

open scoped LinearAlgebra.Projectivization

namespace ProjectiveCap
namespace Projective

open Projectivization Module

variable {K V : Type*} [Field K] [AddCommGroup V] [Module K V]

/-! ## Value transport along a linear equivalence -/

section LinearEquivTransport

variable {W : Type*} [AddCommGroup W] [Module K W]

theorem isP_mapLinearEquiv [Fintype (Point K V)] [DecidableEq (Point K V)]
    [Fintype (Point K W)] [DecidableEq (Point K W)]
    (g : V ≃ₗ[K] W) (S : Finset (Point K V)) :
    FiniteBuildGame.IsP (Cap K W) (S.map (mapLinearEquiv g).toEmbedding) ↔
      FiniteBuildGame.IsP (Cap K V) S :=
  FiniteBuildGame.isP_equiv (mapLinearEquiv g)
    (fun U => cap_map_mapLinearEquiv g U) S

end LinearEquivTransport

/-! ## Transitivity on cap layers, rank three -/

section Transitivity

variable [DecidableEq (Point K V)]

/-- Package a linear automorphism with prescribed images into the transitivity
witness format. -/
theorem capTransitive_of_mapEquiv {S T : Finset (Point K V)} (g : V ≃ₗ[K] V)
    (hmap : S.map (mapEquiv g).toEmbedding = T) :
    ∃ e : Point K V ≃ Point K V,
      (∀ U : Finset (Point K V), Cap K V (U.map e.toEmbedding) ↔ Cap K V U) ∧
        S.map e.toEmbedding = T :=
  ⟨mapEquiv g, fun U => cap_map_mapEquiv g U, hmap⟩

theorem capTransitiveStatement_one (hrank : finrank K V = 3) :
    CapTransitiveStatement (K := K) (V := V) 1 := by
  intro S T _hS _hT hSk hTk
  obtain ⟨p, rfl⟩ := Finset.card_eq_one.mp hSk
  obtain ⟨q, rfl⟩ := Finset.card_eq_one.mp hTk
  have h1 : LinearIndependent K ![p.rep] :=
    linearIndependent_unique_iff.mpr (by simpa using p.rep_nonzero)
  obtain ⟨w2, hw2⟩ := exists_cons_li hrank (by omega) _ h1
  obtain ⟨w3, hw3⟩ := exists_cons_li hrank (by omega) _ hw2
  have h1' : LinearIndependent K ![q.rep] :=
    linearIndependent_unique_iff.mpr (by simpa using q.rep_nonzero)
  obtain ⟨u2, hu2⟩ := exists_cons_li hrank (by omega) _ h1'
  obtain ⟨u3, hu3⟩ := exists_cons_li hrank (by omega) _ hu2
  have hcard3 : Fintype.card (Fin 3) = finrank K V := by simp [hrank]
  set b := basisOfLinearIndependentOfCardEqFinrank hw3 hcard3 with hb_def
  set b' := basisOfLinearIndependentOfCardEqFinrank hu3 hcard3 with hb'_def
  set g : V ≃ₗ[K] V := b.equiv b' (Equiv.refl _) with hg_def
  have hcoe : ⇑b = ![w3, w2, p.rep] := by
    rw [hb_def]; exact coe_basisOfLinearIndependentOfCardEqFinrank _ _
  have hcoe' : ⇑b' = ![u3, u2, q.rep] := by
    rw [hb'_def]; exact coe_basisOfLinearIndependentOfCardEqFinrank _ _
  have hbp : b 2 = p.rep := by
    rw [hcoe, Matrix.cons_val_two, Matrix.tail_cons, Matrix.head_cons]
  have hbq : b' 2 = q.rep := by
    rw [hcoe', Matrix.cons_val_two, Matrix.tail_cons, Matrix.head_cons]
  have hg : g p.rep = q.rep := by
    have happ := Basis.equiv_apply (b := b) (b' := b') (e := Equiv.refl (Fin 3))
      (i := (2 : Fin 3))
    rw [← hg_def, Equiv.refl_apply, hbp, hbq] at happ
    exact happ
  apply capTransitive_of_mapEquiv g
  rw [Finset.map_singleton,
    show ((mapEquiv g).toEmbedding p) = mapEquiv g p from rfl,
    mapEquiv_eq_of_rep_eq g hg]

theorem capTransitiveStatement_two (hrank : finrank K V = 3) :
    CapTransitiveStatement (K := K) (V := V) 2 := by
  intro S T _hS _hT hSk hTk
  obtain ⟨p, q, hpq, rfl⟩ := Finset.card_eq_two.mp hSk
  obtain ⟨p', q', hpq', rfl⟩ := Finset.card_eq_two.mp hTk
  have h2 : LinearIndependent K ![p.rep, q.rep] :=
    linearIndependent_pair_iff_ne.mpr hpq
  obtain ⟨w3, hw3⟩ := exists_cons_li hrank (by omega) _ h2
  have h2' : LinearIndependent K ![p'.rep, q'.rep] :=
    linearIndependent_pair_iff_ne.mpr hpq'
  obtain ⟨u3, hu3⟩ := exists_cons_li hrank (by omega) _ h2'
  have hcard3 : Fintype.card (Fin 3) = finrank K V := by simp [hrank]
  set b := basisOfLinearIndependentOfCardEqFinrank hw3 hcard3 with hb_def
  set b' := basisOfLinearIndependentOfCardEqFinrank hu3 hcard3 with hb'_def
  set g : V ≃ₗ[K] V := b.equiv b' (Equiv.refl _) with hg_def
  have hcoe : ⇑b = ![w3, p.rep, q.rep] := by
    rw [hb_def]; exact coe_basisOfLinearIndependentOfCardEqFinrank _ _
  have hcoe' : ⇑b' = ![u3, p'.rep, q'.rep] := by
    rw [hb'_def]; exact coe_basisOfLinearIndependentOfCardEqFinrank _ _
  have hbp : b 1 = p.rep := by
    rw [hcoe, Matrix.cons_val_one, Matrix.cons_val_zero]
  have hbq : b 2 = q.rep := by
    rw [hcoe, Matrix.cons_val_two, Matrix.tail_cons, Matrix.head_cons]
  have hbp' : b' 1 = p'.rep := by
    rw [hcoe', Matrix.cons_val_one, Matrix.cons_val_zero]
  have hbq' : b' 2 = q'.rep := by
    rw [hcoe', Matrix.cons_val_two, Matrix.tail_cons, Matrix.head_cons]
  have hgp : g p.rep = p'.rep := by
    have happ := Basis.equiv_apply (b := b) (b' := b') (e := Equiv.refl (Fin 3))
      (i := (1 : Fin 3))
    rw [← hg_def, Equiv.refl_apply, hbp, hbp'] at happ
    exact happ
  have hgq : g q.rep = q'.rep := by
    have happ := Basis.equiv_apply (b := b) (b' := b') (e := Equiv.refl (Fin 3))
      (i := (2 : Fin 3))
    rw [← hg_def, Equiv.refl_apply, hbq, hbq'] at happ
    exact happ
  apply capTransitive_of_mapEquiv g
  rw [Finset.map_insert, Finset.map_singleton,
    show ((mapEquiv g).toEmbedding p) = mapEquiv g p from rfl,
    show ((mapEquiv g).toEmbedding q) = mapEquiv g q from rfl,
    mapEquiv_eq_of_rep_eq g hgp, mapEquiv_eq_of_rep_eq g hgq]

theorem capTransitiveStatement_three (hrank : finrank K V = 3) :
    CapTransitiveStatement (K := K) (V := V) 3 := by
  intro S T hS hT hSk hTk
  obtain ⟨p, q, r, hpq, hpr, hqr, rfl⟩ := Finset.card_eq_three.mp hSk
  obtain ⟨p', q', r', hpq', hpr', hqr', rfl⟩ := Finset.card_eq_three.mp hTk
  have hli : LinearIndependent K ![p.rep, q.rep, r.rep] :=
    independent_triple_iff.mp (not_collinear_iff_independent.mp
      (hS (by simp) (by simp) (by simp) hpq hpr hqr))
  have hli' : LinearIndependent K ![p'.rep, q'.rep, r'.rep] :=
    independent_triple_iff.mp (not_collinear_iff_independent.mp
      (hT (by simp) (by simp) (by simp) hpq' hpr' hqr'))
  have hcard3 : Fintype.card (Fin 3) = finrank K V := by simp [hrank]
  set b := basisOfLinearIndependentOfCardEqFinrank hli hcard3 with hb_def
  set b' := basisOfLinearIndependentOfCardEqFinrank hli' hcard3 with hb'_def
  set g : V ≃ₗ[K] V := b.equiv b' (Equiv.refl _) with hg_def
  have hcoe : ⇑b = ![p.rep, q.rep, r.rep] := by
    rw [hb_def]; exact coe_basisOfLinearIndependentOfCardEqFinrank _ _
  have hcoe' : ⇑b' = ![p'.rep, q'.rep, r'.rep] := by
    rw [hb'_def]; exact coe_basisOfLinearIndependentOfCardEqFinrank _ _
  have hgp : g p.rep = p'.rep := by
    have happ := Basis.equiv_apply (b := b) (b' := b') (e := Equiv.refl (Fin 3))
      (i := (0 : Fin 3))
    rw [← hg_def, Equiv.refl_apply] at happ
    rwa [show b 0 = p.rep from by rw [hcoe, Matrix.cons_val_zero],
      show b' 0 = p'.rep from by rw [hcoe', Matrix.cons_val_zero]] at happ
  have hgq : g q.rep = q'.rep := by
    have happ := Basis.equiv_apply (b := b) (b' := b') (e := Equiv.refl (Fin 3))
      (i := (1 : Fin 3))
    rw [← hg_def, Equiv.refl_apply] at happ
    rwa [show b 1 = q.rep from by rw [hcoe, Matrix.cons_val_one, Matrix.cons_val_zero],
      show b' 1 = q'.rep from by
        rw [hcoe', Matrix.cons_val_one, Matrix.cons_val_zero]] at happ
  have hgr : g r.rep = r'.rep := by
    have happ := Basis.equiv_apply (b := b) (b' := b') (e := Equiv.refl (Fin 3))
      (i := (2 : Fin 3))
    rw [← hg_def, Equiv.refl_apply] at happ
    rwa [show b 2 = r.rep from by
        rw [hcoe, Matrix.cons_val_two, Matrix.tail_cons, Matrix.head_cons],
      show b' 2 = r'.rep from by
        rw [hcoe', Matrix.cons_val_two, Matrix.tail_cons, Matrix.head_cons]] at happ
  apply capTransitive_of_mapEquiv g
  rw [Finset.map_insert, Finset.map_insert, Finset.map_singleton,
    show ((mapEquiv g).toEmbedding p) = mapEquiv g p from rfl,
    show ((mapEquiv g).toEmbedding q) = mapEquiv g q from rfl,
    show ((mapEquiv g).toEmbedding r) = mapEquiv g r from rfl,
    mapEquiv_eq_of_rep_eq g hgp, mapEquiv_eq_of_rep_eq g hgq,
    mapEquiv_eq_of_rep_eq g hgr]

theorem capTransitiveStatement_four (hrank : finrank K V = 3) :
    CapTransitiveStatement (K := K) (V := V) 4 := by
  intro S T hS hT hSk hTk
  obtain ⟨p4, S3, hp4, rfl, hS3⟩ := Finset.card_eq_succ.mp hSk
  obtain ⟨p1, p2, p3, h12, h13, h23, rfl⟩ := Finset.card_eq_three.mp hS3
  obtain ⟨q4, T3, hq4, rfl, hT3⟩ := Finset.card_eq_succ.mp hTk
  obtain ⟨q1, q2, q3, h12', h13', h23', rfl⟩ := Finset.card_eq_three.mp hT3
  simp only [Finset.mem_insert, Finset.mem_singleton, not_or] at hp4 hq4
  have hSset : (insert p4 ({p1, p2, p3} : Finset (Point K V))) = {p1, p2, p3, p4} := by
    ext z
    simp only [Finset.mem_insert, Finset.mem_singleton]
    tauto
  have hTset : (insert q4 ({q1, q2, q3} : Finset (Point K V))) = {q1, q2, q3, q4} := by
    ext z
    simp only [Finset.mem_insert, Finset.mem_singleton]
    tauto
  rw [hSset] at hS ⊢
  rw [hTset] at hT ⊢
  obtain ⟨u, hu, ⟨hu0, hp1⟩, ⟨hu1, hp2⟩, ⟨hu2, hp3⟩, husum⟩ :=
    quad_normal_form hrank hS h12 h13 (fun h => hp4.1 h.symm) h23
      (fun h => hp4.2.1 h.symm) (fun h => hp4.2.2 h.symm)
  obtain ⟨w, hw, ⟨hw0, hq1⟩, ⟨hw1, hq2⟩, ⟨hw2, hq3⟩, hwsum⟩ :=
    quad_normal_form hrank hT h12' h13' (fun h => hq4.1 h.symm) h23'
      (fun h => hq4.2.1 h.symm) (fun h => hq4.2.2 h.symm)
  have hcard3 : Fintype.card (Fin 3) = finrank K V := by simp [hrank]
  set bu := basisOfLinearIndependentOfCardEqFinrank hu hcard3 with hbu_def
  set bw := basisOfLinearIndependentOfCardEqFinrank hw hcard3 with hbw_def
  set g : V ≃ₗ[K] V := bu.equiv bw (Equiv.refl _) with hg_def
  have hcoeu : ⇑bu = u := by
    rw [hbu_def]; exact coe_basisOfLinearIndependentOfCardEqFinrank _ _
  have hcoew : ⇑bw = w := by
    rw [hbw_def]; exact coe_basisOfLinearIndependentOfCardEqFinrank _ _
  have hg : ∀ i : Fin 3, g (u i) = w i := by
    intro i
    have happ := Basis.equiv_apply (b := bu) (b' := bw) (e := Equiv.refl (Fin 3))
      (i := i)
    rw [← hg_def, Equiv.refl_apply] at happ
    rwa [show bu i = u i from by rw [hcoeu],
      show bw i = w i from by rw [hcoew]] at happ
  have hg4 : g p4.rep = q4.rep := by
    have hmap : g (u 0 + u 1 + u 2) = w 0 + w 1 + w 2 := by
      rw [map_add, map_add, hg 0, hg 1, hg 2]
    rw [husum, hwsum] at hmap
    exact hmap
  have e1 : mapEquiv g p1 = q1 := by
    rw [← hp1, ← hq1]
    exact mapEquiv_mk_eq_mk hu0 hw0 (hg 0)
  have e2 : mapEquiv g p2 = q2 := by
    rw [← hp2, ← hq2]
    exact mapEquiv_mk_eq_mk hu1 hw1 (hg 1)
  have e3 : mapEquiv g p3 = q3 := by
    rw [← hp3, ← hq3]
    exact mapEquiv_mk_eq_mk hu2 hw2 (hg 2)
  have e4 : mapEquiv g p4 = q4 := mapEquiv_eq_of_rep_eq g hg4
  apply capTransitive_of_mapEquiv g
  rw [Finset.map_insert, Finset.map_insert, Finset.map_insert, Finset.map_singleton,
    show ((mapEquiv g).toEmbedding p1) = mapEquiv g p1 from rfl,
    show ((mapEquiv g).toEmbedding p2) = mapEquiv g p2 from rfl,
    show ((mapEquiv g).toEmbedding p3) = mapEquiv g p3 from rfl,
    show ((mapEquiv g).toEmbedding p4) = mapEquiv g p4 from rfl,
    e1, e2, e3, e4]

end Transitivity

/-! ## Extendability of small caps -/

section Extendability

variable [DecidableEq (Point K V)]

theorem cap_extendable (hrank : finrank K V = 3) :
    ∀ S : Finset (Point K V), Cap K V S -> S.card ≤ 3 ->
      ∃ x : Point K V, FiniteBuildGame.Move (Cap K V) S x := by
  have hnontriv : Nontrivial V := Module.nontrivial_of_finrank_pos
    (R := K) (by omega)
  intro S hS hcard
  obtain h0 | h1 | h2 | h3 : S.card = 0 ∨ S.card = 1 ∨ S.card = 2 ∨ S.card = 3 := by
    omega
  · -- empty position: play anywhere
    rw [Finset.card_eq_zero.mp h0]
    obtain ⟨x⟩ : Nonempty (Point K V) := inferInstance
    exact ⟨x, by simp, by simp⟩
  · -- one point: any second point works
    obtain ⟨p, rfl⟩ := Finset.card_eq_one.mp h1
    have hli1 : LinearIndependent K ![p.rep] :=
      linearIndependent_unique_iff.mpr (by simpa using p.rep_nonzero)
    obtain ⟨w, hw⟩ := exists_cons_li hrank (by omega) _ hli1
    have hw' : LinearIndependent K ![w, p.rep] := hw
    have hw0 : w ≠ 0 := hw'.ne_zero 0
    have hwp : Projectivization.mk K w hw0 ≠ p := mk_ne_of_li_pair hw0 hw'
    refine ⟨Projectivization.mk K w hw0, by simpa using hwp, ?_⟩
    have hins : (insert (Projectivization.mk K w hw0) {p} : Finset (Point K V)) =
        {Projectivization.mk K w hw0, p} := rfl
    rw [hins]
    exact cap_pair (K := K) (V := V) _ _
  · -- two points: escape the spanned line
    obtain ⟨p, q, hpq, rfl⟩ := Finset.card_eq_two.mp h2
    have hli2 : LinearIndependent K ![p.rep, q.rep] :=
      linearIndependent_pair_iff_ne.mpr hpq
    obtain ⟨w, hw⟩ := exists_cons_li hrank (by omega) _ hli2
    have hw' : LinearIndependent K ![w, p.rep, q.rep] := hw
    have hw0 : w ≠ 0 := hw'.ne_zero 0
    have hxp : Projectivization.mk K w hw0 ≠ p := mk_ne_of_li_pair hw0 (li_sub01 hw')
    have hxq : Projectivization.mk K w hw0 ≠ q := mk_ne_of_li_pair hw0 (li_sub02 hw')
    have hind : Independent ![Projectivization.mk K w hw0, p, q] := by
      have hmk := independent_triple_of_li hw0 p.rep_nonzero q.rep_nonzero hw'
      simpa [Projectivization.mk_rep] using hmk
    refine ⟨Projectivization.mk K w hw0, by simp [hxp, hxq], ?_⟩
    have hins : (insert (Projectivization.mk K w hw0) {p, q} : Finset (Point K V)) =
        {Projectivization.mk K w hw0, p, q} := rfl
    rw [hins]
    exact cap_triple_of_independent hind
  · -- three points: the coordinate-sum point completes a frame
    obtain ⟨p, q, r, hpq, hpr, hqr, rfl⟩ := Finset.card_eq_three.mp h3
    have hli : LinearIndependent K ![p.rep, q.rep, r.rep] :=
      independent_triple_iff.mp (not_collinear_iff_independent.mp
        (hS (by simp) (by simp) (by simp) hpq hpr hqr))
    have hs0 : p.rep + q.rep + r.rep ≠ 0 := sum_ne_zero_of_li hli
    set x := Projectivization.mk K (p.rep + q.rep + r.rep) hs0 with hx_def
    have hxpq : Independent ![x, p, q] := by
      have hmk := independent_triple_of_li hs0 p.rep_nonzero q.rep_nonzero
        (li_rotate (li_with_sum12 hli))
      simpa [← hx_def, Projectivization.mk_rep] using hmk
    have hxpr : Independent ![x, p, r] := by
      have hmk := independent_triple_of_li hs0 p.rep_nonzero r.rep_nonzero
        (li_rotate (li_with_sum13 hli))
      simpa [← hx_def, Projectivization.mk_rep] using hmk
    have hxqr : Independent ![x, q, r] := by
      have hmk := independent_triple_of_li hs0 q.rep_nonzero r.rep_nonzero
        (li_rotate (li_with_sum23 hli))
      simpa [← hx_def, Projectivization.mk_rep] using hmk
    have hpqr : Independent ![p, q, r] := independent_triple_iff.mpr hli
    obtain ⟨hcap4, _hcard4⟩ := cap_quad_of_independent hxpq hxpr hxqr hpqr
    have hxp : x ≠ p := ne_of_li_pair (li_sub01 (independent_triple_iff.mp hxpq))
    have hxq : x ≠ q := ne_of_li_pair (li_sub02 (independent_triple_iff.mp hxpq))
    have hxr : x ≠ r := ne_of_li_pair (li_sub02 (independent_triple_iff.mp hxpr))
    refine ⟨x, by simp [hxp, hxq, hxr], ?_⟩
    have hins : (insert x {p, q, r} : Finset (Point K V)) = {x, p, q, r} := rfl
    rw [hins]
    exact hcap4

end Extendability

/-! ## The frame reduction for the projective plane -/

section FrameReduction

variable [Fintype (Point K V)] [DecidableEq (Point K V)]

omit [Fintype (Point K V)] in
/-- A frame (four-point cap) exists in every rank-three space. -/
theorem exists_frame (hrank : finrank K V = 3) :
    ∃ F : Finset (Point K V), Cap K V F ∧ F.card = 4 := by
  have hfin : FiniteDimensional K V := .of_finrank_pos (by omega)
  set b : Basis (Fin 3) K V := (Module.finBasis K V).reindex (finCongr hrank)
    with hb_def
  have hli : LinearIndependent K ![b 0, b 1, b 2] := by
    have hb := b.linearIndependent
    have hconv : ![b 0, b 1, b 2] = ⇑b := by
      ext i
      fin_cases i <;> rfl
    rwa [hconv]
  have hs0 : b 0 + b 1 + b 2 ≠ 0 := sum_ne_zero_of_li hli
  have h1 : Independent ![Projectivization.mk K (b 0) (hli.ne_zero 0),
      Projectivization.mk K (b 1) (hli.ne_zero 1),
      Projectivization.mk K (b 2) (hli.ne_zero 2)] := by
    have := independent_triple_of_li (hli.ne_zero 0) (hli.ne_zero 1)
      (hli.ne_zero 2) hli
    exact this
  have h2 : Independent ![Projectivization.mk K (b 0) (hli.ne_zero 0),
      Projectivization.mk K (b 1) (hli.ne_zero 1),
      Projectivization.mk K (b 0 + b 1 + b 2) hs0] :=
    independent_triple_of_li _ _ _ (li_with_sum12 hli)
  have h3 : Independent ![Projectivization.mk K (b 0) (hli.ne_zero 0),
      Projectivization.mk K (b 2) (hli.ne_zero 2),
      Projectivization.mk K (b 0 + b 1 + b 2) hs0] :=
    independent_triple_of_li _ _ _ (li_with_sum13 hli)
  have h4 : Independent ![Projectivization.mk K (b 1) (hli.ne_zero 1),
      Projectivization.mk K (b 2) (hli.ne_zero 2),
      Projectivization.mk K (b 0 + b 1 + b 2) hs0] :=
    independent_triple_of_li _ _ _ (li_with_sum23 hli)
  obtain ⟨hcap, hcard⟩ := cap_quad_of_independent h1 h2 h3 h4
  exact ⟨_, hcap, hcard⟩

/--
Frame reduction for the projective plane, geometric obligations discharged:
over a rank-three space the projective cap-game conjecture is equivalent to
the P-position status of any single frame.
-/
theorem initialPStatement_iff_isP_frame_of_finrank (hrank : finrank K V = 3)
    {F : Finset (Point K V)} (hF : Cap K V F) (hFcard : F.card = 4) :
    (InitialPStatement (K := K) (V := V) ↔ FiniteBuildGame.IsP (Cap K V) F) :=
  initialPStatement_iff_isP_frame
    (capTransitiveStatement_one hrank) (capTransitiveStatement_two hrank)
    (capTransitiveStatement_three hrank) (capTransitiveStatement_four hrank)
    (cap_extendable hrank) hF hFcard

end FrameReduction

end Projective
end ProjectiveCap
