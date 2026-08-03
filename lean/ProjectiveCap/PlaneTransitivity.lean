import ProjectiveCap.Projective
import Mathlib.LinearAlgebra.Projectivization.Subspace
import Mathlib.Tactic

/-!
# Collinearity, linear transport, and small caps in a projective space

Let `K` be a field and `V` a `K`-vector space, with projective points
`Point K V = Projectivization K V` and the cap predicate of
`ProjectiveCap.Projective`.

This module develops the projective-plane geometry those definitions need,
working throughout with the chosen representative vector `p.rep` of a point `p`:

* the passage between projective points and representative vectors, and the
  equivalence `collinear_iff_dependent` between collinearity of a triple of
  points and linear dependence of their representatives (with its contrapositive
  `not_collinear_iff_independent` and the reformulations
  `independent_triple_iff`, `independent_triple_of_li`);
* transport along a linear equivalence `g : V ≃ₗ[K] W`: the induced point
  bijection `mapLinearEquiv g`, its self-map form `mapEquiv g` for `W = V`, and
  the facts that both preserve collinearity and the cap property
  (`collinear_mapEquiv`, `cap_map_mapEquiv`);
* caps recognized from independence of triples and quadruples
  (`cap_triple_of_independent`, `cap_quad_of_independent`);
* linear-independence bookkeeping for a basis together with its coordinate sum
  (`li_with_sum12`, `li_with_sum13`, `li_with_sum23`, `sum_ne_zero_of_li`) and
  the basis extension `exists_cons_li`;
* in rank three, `quad_normal_form`: any four-point cap can be presented as
  three basis vectors together with their coordinate sum, i.e. every frame is
  projectively equivalent to the standard one.

Nothing in this module mentions a game. The game-theoretic consequences of
these results — single-orbit transitivity of the cap layers, extendability of
small caps, and the reduction of the projective-plane cap-game conjecture to a
single frame position — are in `ProjectiveCap.PlaneTransitivityGame`.
-/

open scoped LinearAlgebra.Projectivization

namespace ProjectiveCap
namespace Projective

open Projectivization Module

variable {K V : Type*} [Field K] [AddCommGroup V] [Module K V]

/-! ## Points versus representative vectors -/

theorem comp_rep_triple (a b c : Point K V) :
    Projectivization.rep ∘ ![a, b, c] = ![a.rep, b.rep, c.rep] := by
  ext i
  fin_cases i <;> rfl

theorem independent_triple_iff {a b c : Point K V} :
    Independent ![a, b, c] ↔ LinearIndependent K ![a.rep, b.rep, c.rep] := by
  rw [independent_iff, comp_rep_triple]

/-- Points built from linearly independent vectors are independent. -/
theorem independent_triple_of_li {x y z : V} (hx : x ≠ 0) (hy : y ≠ 0) (hz : z ≠ 0)
    (h : LinearIndependent K ![x, y, z]) :
    Independent ![Projectivization.mk K x hx, Projectivization.mk K y hy,
      Projectivization.mk K z hz] := by
  have hmk := Independent.mk (K := K) (V := V) ![x, y, z]
    (fun i => by fin_cases i <;> assumption) h
  have hfam : (fun i => Projectivization.mk K (![x, y, z] i)
      (by fin_cases i <;> assumption)) =
      ![Projectivization.mk K x hx, Projectivization.mk K y hy,
        Projectivization.mk K z hz] := by
    ext i
    fin_cases i <;> rfl
  rwa [hfam] at hmk

/-! ## Pair and permutation sublemmas for linear independence -/

theorem li_sub01 {x y z : V} (h : LinearIndependent K ![x, y, z]) :
    LinearIndependent K ![x, y] := by
  have h2 := h.comp ![0, 1] (by decide)
  have hcomp : ![x, y, z] ∘ ![(0 : Fin 3), 1] = ![x, y] := by
    ext i
    fin_cases i <;> rfl
  rwa [hcomp] at h2

theorem li_sub02 {x y z : V} (h : LinearIndependent K ![x, y, z]) :
    LinearIndependent K ![x, z] := by
  have h2 := h.comp ![0, 2] (by decide)
  have hcomp : ![x, y, z] ∘ ![(0 : Fin 3), 2] = ![x, z] := by
    ext i
    fin_cases i <;> rfl
  rwa [hcomp] at h2

theorem li_sub12 {x y z : V} (h : LinearIndependent K ![x, y, z]) :
    LinearIndependent K ![y, z] := by
  have h2 := h.comp ![1, 2] (by decide)
  have hcomp : ![x, y, z] ∘ ![(1 : Fin 3), 2] = ![y, z] := by
    ext i
    fin_cases i <;> rfl
  rwa [hcomp] at h2

theorem li_rotate {x y z : V} (h : LinearIndependent K ![x, y, z]) :
    LinearIndependent K ![z, x, y] := by
  have h2 := h.comp ![2, 0, 1] (by decide)
  have hcomp : ![x, y, z] ∘ ![(2 : Fin 3), 0, 1] = ![z, x, y] := by
    ext i
    fin_cases i <;> rfl
  rwa [hcomp] at h2

/-- Extract point distinctness from vector independence of representatives. -/
theorem ne_of_li_pair {p q : Point K V} (h : LinearIndependent K ![p.rep, q.rep]) :
    p ≠ q :=
  linearIndependent_pair_iff_ne.mp h

/-- A point made from `v` differs from `p` when `v` and `p.rep` are
independent. -/
theorem mk_ne_of_li_pair {v : V} (hv : v ≠ 0) {p : Point K V}
    (h : LinearIndependent K ![v, p.rep]) : Projectivization.mk K v hv ≠ p := by
  intro heq
  obtain ⟨a, ha⟩ := (Projectivization.mk_eq_mk_iff' K v p.rep hv p.rep_nonzero).mp
    (by rw [heq, Projectivization.mk_rep])
  have h0 := Fintype.linearIndependent_iff.mp h ![1, -a] (by
    rw [Fin.sum_univ_two]
    simp only [Matrix.cons_val_zero, Matrix.cons_val_one]
    rw [one_smul, ← ha]
    module)
  have h1 := h0 0
  simp at h1

/-! ## Collinearity versus linear dependence -/

theorem dependent_of_collinear {a b c : Point K V}
    (h : Collinear K V a b c) : Dependent ![a, b, c] := by
  rw [dependent_iff_not_independent]
  intro hindep
  obtain ⟨M, hMfin, hMrank, hMsub⟩ := h
  have hmem : ∀ p : Point K V, p ∈ ({a, b, c} : Set (Point K V)) ->
      p.rep ∈ Subspace.submodule M := by
    intro p hp
    rw [Subspace.mem_submodule_iff M p.rep_nonzero, Projectivization.mk_rep]
    exact hMsub hp
  have hli : LinearIndependent K ![a.rep, b.rep, c.rep] :=
    independent_triple_iff.mp hindep
  have hspan : Submodule.span K (Set.range ![a.rep, b.rep, c.rep]) ≤
      Subspace.submodule M := by
    rw [Submodule.span_le]
    rintro x ⟨i, rfl⟩
    fin_cases i
    · exact hmem a (by simp)
    · exact hmem b (by simp)
    · exact hmem c (by simp)
  have h3 : finrank K (Submodule.span K (Set.range ![a.rep, b.rep, c.rep])) = 3 := by
    rw [finrank_span_eq_card hli]
    simp
  have hle := Submodule.finrank_mono hspan
  omega

/-- A point lies in the projectivization of a submodule containing its
representative. -/
theorem mem_projectivization_of_rep_mem {s : Submodule K V} {p : Point K V}
    (h : p.rep ∈ s) : p ∈ s.projectivization := by
  rw [Submodule.mem_projectivization_iff_submodule_le, Projectivization.submodule_eq,
    Submodule.span_singleton_le_iff_mem]
  exact h

theorem collinear_of_dependent {a b c : Point K V}
    (h : Dependent ![a, b, c]) : Collinear K V a b c := by
  classical
  by_cases hab : a = b
  · subst hab
    have hset : ({a, a, c} : Set (Point K V)) = {a, c} := by
      ext x; simp
    unfold Collinear
    rw [hset]
    exact isCollinear_pair a c
  by_cases hac : a = c
  · subst hac
    have hset : ({a, b, a} : Set (Point K V)) = {a, b} := by
      ext x
      simp only [Set.mem_insert_iff, Set.mem_singleton_iff]
      tauto
    unfold Collinear
    rw [hset]
    exact isCollinear_pair a b
  by_cases hbc : b = c
  · subst hbc
    have hset : ({a, b, b} : Set (Point K V)) = {a, b} := by
      ext x; simp
    unfold Collinear
    rw [hset]
    exact isCollinear_pair a b
  -- all distinct: c lies on the span of the (independent) pair a, b
  have hpair : LinearIndependent K ![a.rep, b.rep] :=
    linearIndependent_pair_iff_ne.mpr hab
  have hdep : ¬ LinearIndependent K ![a.rep, b.rep, c.rep] := by
    intro hli
    exact (dependent_iff_not_independent.mp h) (independent_triple_iff.mpr hli)
  have hcmem : c.rep ∈ Submodule.span K {a.rep, b.rep} := by
    by_contra hcnot
    apply hdep
    have hsnoc : ![a.rep, b.rep, c.rep] = Fin.snoc ![a.rep, b.rep] c.rep := by
      ext i
      fin_cases i <;> simp [Fin.snoc]
    rw [hsnoc, linearIndependent_finSnoc]
    refine ⟨hpair, ?_⟩
    rwa [Matrix.range_cons_cons_empty]
  refine ⟨(Submodule.span K {a.rep, b.rep}).projectivization, ?_, ?_, ?_⟩
  · rw [Subspace.submodule.apply_symm_apply]
    exact Module.Finite.span_of_finite _ (Set.toFinite _)
  · rw [Subspace.submodule.apply_symm_apply]
    have h2 := finrank_span_eq_card hpair
    rw [Matrix.range_cons_cons_empty] at h2
    simp only [Fintype.card_fin] at h2
    omega
  · intro p hp
    rw [SetLike.mem_coe]
    apply mem_projectivization_of_rep_mem
    rcases hp with rfl | rfl | rfl
    · exact Submodule.mem_span_of_mem (by simp)
    · exact Submodule.mem_span_of_mem (by simp)
    · exact hcmem

theorem collinear_iff_dependent {a b c : Point K V} :
    Collinear K V a b c ↔ Dependent ![a, b, c] :=
  ⟨dependent_of_collinear, collinear_of_dependent⟩

theorem not_collinear_iff_independent {a b c : Point K V} :
    ¬ Collinear K V a b c ↔ Independent ![a, b, c] := by
  rw [collinear_iff_dependent, ← independent_iff_not_dependent]

theorem rep_mem_span_pair_of_collinear {a b c : Point K V} (hab : a ≠ b)
    (hcol : Collinear K V a b c) :
    c.rep ∈ Submodule.span K {a.rep, b.rep} := by
  have hpair : LinearIndependent K ![a.rep, b.rep] :=
    linearIndependent_pair_iff_ne.mpr hab
  have hdep : ¬ LinearIndependent K ![a.rep, b.rep, c.rep] := by
    intro hli
    exact (dependent_iff_not_independent.mp ((collinear_iff_dependent (K := K) (V := V)).mp hcol))
      (independent_triple_iff.mpr hli)
  by_contra hcnot
  apply hdep
  have hsnoc : ![a.rep, b.rep, c.rep] = Fin.snoc ![a.rep, b.rep] c.rep := by
    ext i
    fin_cases i <;> simp [Fin.snoc]
  rw [hsnoc, linearIndependent_finSnoc]
  refine ⟨hpair, ?_⟩
  rwa [Matrix.range_cons_cons_empty]

theorem collinear_of_collinear_pair {a b c d : Point K V} (hab : a ≠ b)
    (hc : Collinear K V a b c) (hd : Collinear K V a b d) :
    Collinear K V a c d := by
  have hpair : LinearIndependent K ![a.rep, b.rep] :=
    linearIndependent_pair_iff_ne.mpr hab
  have hcspan : c.rep ∈ Submodule.span K {a.rep, b.rep} :=
    rep_mem_span_pair_of_collinear (K := K) (V := V) hab hc
  have hdspan : d.rep ∈ Submodule.span K {a.rep, b.rep} :=
    rep_mem_span_pair_of_collinear (K := K) (V := V) hab hd
  refine ⟨(Submodule.span K {a.rep, b.rep}).projectivization, ?_, ?_, ?_⟩
  · rw [Subspace.submodule.apply_symm_apply]
    exact Module.Finite.span_of_finite _ (Set.toFinite _)
  · rw [Subspace.submodule.apply_symm_apply]
    have h2 := finrank_span_eq_card hpair
    rw [Matrix.range_cons_cons_empty] at h2
    simp only [Fintype.card_fin] at h2
    omega
  · intro p hp
    rw [SetLike.mem_coe]
    apply mem_projectivization_of_rep_mem
    rcases hp with rfl | rfl | rfl
    · exact Submodule.mem_span_of_mem (by simp)
    · exact hcspan
    · exact hdspan

/-! ## Projective transport along linear equivalences -/

section LinearEquivTransport

variable {W : Type*} [AddCommGroup W] [Module K W]

/-- The equivalence of projective points induced by a linear equivalence of
the underlying vector spaces. -/
def mapLinearEquiv (g : V ≃ₗ[K] W) : Point K V ≃ Point K W where
  toFun := Projectivization.map (g : V →ₗ[K] W) g.injective
  invFun := Projectivization.map (g.symm : W →ₗ[K] V) g.symm.injective
  left_inv p := by
    induction p using Projectivization.ind with | h v hv =>
    rw [Projectivization.map_mk, Projectivization.map_mk]
    simp
  right_inv p := by
    induction p using Projectivization.ind with | h v hv =>
    rw [Projectivization.map_mk, Projectivization.map_mk]
    simp

theorem mapLinearEquiv_mk (g : V ≃ₗ[K] W) {v : V} (hv : v ≠ 0) :
    mapLinearEquiv g (Projectivization.mk K v hv) =
      Projectivization.mk K (g v) (by simp [hv]) := by
  simp [mapLinearEquiv, Projectivization.map_mk]

@[simp] theorem mapLinearEquiv_symm_eq (g : V ≃ₗ[K] W) :
    (mapLinearEquiv g).symm = mapLinearEquiv g.symm :=
  rfl

@[simp] theorem mapLinearEquiv_symm_apply (g : V ≃ₗ[K] W) (p : Point K V) :
    mapLinearEquiv g.symm (mapLinearEquiv g p) = p := by
  exact (mapLinearEquiv g).symm_apply_apply p

@[simp] theorem mapLinearEquiv_apply_symm (g : V ≃ₗ[K] W) (p : Point K W) :
    mapLinearEquiv g (mapLinearEquiv g.symm p) = p := by
  exact (mapLinearEquiv g).apply_symm_apply p

theorem independent_triple_mapLinearEquiv (g : V ≃ₗ[K] W) {a b c : Point K V}
    (h : Independent ![a, b, c]) :
    Independent ![mapLinearEquiv g a, mapLinearEquiv g b, mapLinearEquiv g c] := by
  have hli : LinearIndependent K ![a.rep, b.rep, c.rep] := independent_triple_iff.mp h
  have hgli : LinearIndependent K ![g a.rep, g b.rep, g c.rep] := by
    have h2 := hli.map' (g : V →ₗ[K] W) g.ker
    have hcomp : (g : V →ₗ[K] W) ∘ ![a.rep, b.rep, c.rep] =
        ![g a.rep, g b.rep, g c.rep] := by
      ext i
      fin_cases i <;> rfl
    rwa [hcomp] at h2
  have hpts := independent_triple_of_li
    (by simpa using (Projectivization.rep_nonzero a))
    (by simpa using (Projectivization.rep_nonzero b))
    (by simpa using (Projectivization.rep_nonzero c)) hgli
  have hconv : ∀ p : Point K V, mapLinearEquiv g p = Projectivization.mk K (g p.rep)
      (by simp [Projectivization.rep_nonzero p]) := by
    intro p
    conv_lhs => rw [← Projectivization.mk_rep p]
    rw [mapLinearEquiv_mk]
  rw [hconv a, hconv b, hconv c]
  exact hpts

theorem collinear_mapLinearEquiv (g : V ≃ₗ[K] W) {a b c : Point K V} :
    Collinear K W (mapLinearEquiv g a) (mapLinearEquiv g b) (mapLinearEquiv g c) ↔
      Collinear K V a b c := by
  rw [← not_iff_not, not_collinear_iff_independent, not_collinear_iff_independent]
  constructor
  · intro h
    have h2 := independent_triple_mapLinearEquiv g.symm h
    simpa using h2
  · exact independent_triple_mapLinearEquiv g

/-- A projective cap maps to a projective cap under a linear equivalence. -/
theorem cap_image_mapLinearEquiv [DecidableEq (Point K V)] [DecidableEq (Point K W)]
    (g : V ≃ₗ[K] W) {S : Finset (Point K V)} (hS : Cap K V S) :
    Cap K W (S.map (mapLinearEquiv g).toEmbedding) := by
  intro a b c ha hb hc hab hac hbc hcol
  rw [Finset.mem_map_equiv] at ha hb hc
  exact hS ha hb hc
    (fun h => hab (by rw [← Equiv.apply_symm_apply (mapLinearEquiv g) a,
      ← Equiv.apply_symm_apply (mapLinearEquiv g) b, h]))
    (fun h => hac (by rw [← Equiv.apply_symm_apply (mapLinearEquiv g) a,
      ← Equiv.apply_symm_apply (mapLinearEquiv g) c, h]))
    (fun h => hbc (by rw [← Equiv.apply_symm_apply (mapLinearEquiv g) b,
      ← Equiv.apply_symm_apply (mapLinearEquiv g) c, h]))
    (by
      have hcol' :
          Collinear K W
            (mapLinearEquiv g ((mapLinearEquiv g).symm a))
            (mapLinearEquiv g ((mapLinearEquiv g).symm b))
            (mapLinearEquiv g ((mapLinearEquiv g).symm c)) := by
        simpa using hcol
      exact (collinear_mapLinearEquiv g).mp hcol')

theorem cap_map_mapLinearEquiv [DecidableEq (Point K V)] [DecidableEq (Point K W)]
    (g : V ≃ₗ[K] W) (S : Finset (Point K V)) :
    Cap K W (S.map (mapLinearEquiv g).toEmbedding) ↔ Cap K V S := by
  constructor
  · intro hS
    have hback := cap_image_mapLinearEquiv (K := K) (V := W) (W := V) g.symm hS
    have htwice :
        (S.map (mapLinearEquiv g).toEmbedding).map
          (mapLinearEquiv g.symm).toEmbedding = S := by
      ext p
      simp [Finset.mem_map_equiv]
    rwa [htwice] at hback
  · exact cap_image_mapLinearEquiv g

end LinearEquivTransport

/-! ## The point permutation induced by a linear automorphism -/

/-- The permutation of projective points induced by a linear automorphism. -/
def mapEquiv (g : V ≃ₗ[K] V) : Point K V ≃ Point K V where
  toFun := Projectivization.map (g : V →ₗ[K] V) g.injective
  invFun := Projectivization.map (g.symm : V →ₗ[K] V) g.symm.injective
  left_inv p := by
    induction p using Projectivization.ind with | h v hv =>
    rw [Projectivization.map_mk, Projectivization.map_mk]
    simp
  right_inv p := by
    induction p using Projectivization.ind with | h v hv =>
    rw [Projectivization.map_mk, Projectivization.map_mk]
    simp

theorem mapEquiv_mk (g : V ≃ₗ[K] V) {v : V} (hv : v ≠ 0) :
    mapEquiv g (Projectivization.mk K v hv) =
      Projectivization.mk K (g v) (by simp [hv]) := by
  simp [mapEquiv, Projectivization.map_mk]

@[simp] theorem mapEquiv_symm_eq (g : V ≃ₗ[K] V) :
    (mapEquiv g).symm = mapEquiv g.symm :=
  rfl

@[simp] theorem mapEquiv_symm_mapEquiv (g : V ≃ₗ[K] V) (p : Point K V) :
    mapEquiv g.symm (mapEquiv g p) = p := by
  induction p using Projectivization.ind with | h v hv =>
  rw [mapEquiv_mk, mapEquiv_mk]
  simp

@[simp] theorem mapEquiv_mapEquiv_symm (g : V ≃ₗ[K] V) (p : Point K V) :
    mapEquiv g (mapEquiv g.symm p) = p := by
  induction p using Projectivization.ind with | h v hv =>
  rw [mapEquiv_mk, mapEquiv_mk]
  simp

/-- The induced permutation sends `mk v` to `mk w` whenever `g v = w`. -/
theorem mapEquiv_mk_eq_mk {g : V ≃ₗ[K] V} {v w : V} (hv : v ≠ 0) (hw : w ≠ 0)
    (h : g v = w) :
    mapEquiv g (Projectivization.mk K v hv) = Projectivization.mk K w hw := by
  rw [mapEquiv_mk]
  exact (Projectivization.mk_eq_mk_iff' K _ _ _ hw).mpr ⟨1, by rw [one_smul, h]⟩

/-- The induced permutation sends `p` to `q` whenever `g` matches their
representatives. -/
theorem mapEquiv_eq_of_rep_eq (g : V ≃ₗ[K] V) {p q : Point K V}
    (h : g p.rep = q.rep) : mapEquiv g p = q := by
  conv_lhs => rw [← Projectivization.mk_rep p]
  conv_rhs => rw [← Projectivization.mk_rep q]
  exact mapEquiv_mk_eq_mk p.rep_nonzero q.rep_nonzero h

theorem independent_triple_map (g : V ≃ₗ[K] V) {a b c : Point K V}
    (h : Independent ![a, b, c]) :
    Independent ![mapEquiv g a, mapEquiv g b, mapEquiv g c] := by
  have hli : LinearIndependent K ![a.rep, b.rep, c.rep] := independent_triple_iff.mp h
  have hgli : LinearIndependent K ![g a.rep, g b.rep, g c.rep] := by
    have h2 := hli.map' (g : V →ₗ[K] V) g.ker
    have hcomp : (g : V →ₗ[K] V) ∘ ![a.rep, b.rep, c.rep] =
        ![g a.rep, g b.rep, g c.rep] := by
      ext i
      fin_cases i <;> rfl
    rwa [hcomp] at h2
  have hpts := independent_triple_of_li
    (by simp [Projectivization.rep_nonzero a])
    (by simp [Projectivization.rep_nonzero b])
    (by simp [Projectivization.rep_nonzero c]) hgli
  have hconv' : ∀ p : Point K V, mapEquiv g p = Projectivization.mk K (g p.rep)
      (by simp [Projectivization.rep_nonzero p]) := by
    intro p
    conv_lhs => rw [← Projectivization.mk_rep p]
    rw [mapEquiv_mk]
  rw [hconv' a, hconv' b, hconv' c]
  exact hpts

theorem collinear_mapEquiv (g : V ≃ₗ[K] V) {a b c : Point K V} :
    Collinear K V (mapEquiv g a) (mapEquiv g b) (mapEquiv g c) ↔
      Collinear K V a b c := by
  rw [← not_iff_not, not_collinear_iff_independent, not_collinear_iff_independent]
  constructor
  · intro h
    have h2 := independent_triple_map g.symm h
    simpa using h2
  · exact independent_triple_map g

/-- Cap positions are preserved by induced point permutations: the validity
transport hypothesis of `CapTransitiveStatement`. -/
theorem cap_map_mapEquiv [DecidableEq (Point K V)] (g : V ≃ₗ[K] V)
    (S : Finset (Point K V)) :
    Cap K V (S.map (mapEquiv g).toEmbedding) ↔ Cap K V S := by
  have haux : ∀ (g' : V ≃ₗ[K] V) (U : Finset (Point K V)), Cap K V U ->
      Cap K V (U.map (mapEquiv g').toEmbedding) := by
    intro g' U hU a b c ha hb hc hab hac hbc hcol
    rw [Finset.mem_map_equiv] at ha hb hc
    have hcol' : Collinear K V (mapEquiv g' ((mapEquiv g').symm a))
        (mapEquiv g' ((mapEquiv g').symm b)) (mapEquiv g' ((mapEquiv g').symm c)) := by
      simpa using hcol
    exact hU ha hb hc
      (fun h => hab (by rw [← Equiv.apply_symm_apply (mapEquiv g') a,
        ← Equiv.apply_symm_apply (mapEquiv g') b, h]))
      (fun h => hac (by rw [← Equiv.apply_symm_apply (mapEquiv g') a,
        ← Equiv.apply_symm_apply (mapEquiv g') c, h]))
      (fun h => hbc (by rw [← Equiv.apply_symm_apply (mapEquiv g') b,
        ← Equiv.apply_symm_apply (mapEquiv g') c, h]))
      ((collinear_mapEquiv g').mp hcol')
  refine ⟨fun h => ?_, haux g S⟩
  have h2 := haux g.symm _ h
  have hSS : (S.map (mapEquiv g).toEmbedding).map (mapEquiv g.symm).toEmbedding = S := by
    ext p
    simp [Finset.mem_map_equiv]
  rwa [hSS] at h2

/-! ## Caps from triple independence -/

theorem cap_of_forall_triple [DecidableEq (Point K V)] {S : Finset (Point K V)}
    (h : ∀ T : Finset (Point K V), T ⊆ S -> T.card = 3 ->
      ¬ IsCollinear (T : Set (Point K V))) :
    Cap K V S := by
  intro a b c ha hb hc hab hac hbc hcol
  refine h {a, b, c} ?_ ?_ ?_
  · intro x hx
    simp only [Finset.mem_insert, Finset.mem_singleton] at hx
    rcases hx with rfl | rfl | rfl <;> assumption
  · rw [Finset.card_insert_of_notMem (by simp [hab, hac]),
      Finset.card_insert_of_notMem (by simp [hbc]), Finset.card_singleton]
  · have hset : ((({a, b, c} : Finset (Point K V))) : Set (Point K V)) =
        ({a, b, c} : Set (Point K V)) := by
      simp
    rw [hset]
    exact hcol

/-- A three-point set built from an independent point triple is a cap. -/
theorem cap_triple_of_independent [DecidableEq (Point K V)] {p q r : Point K V}
    (h : Independent ![p, q, r]) :
    Cap K V ({p, q, r} : Finset (Point K V)) := by
  have hli := independent_triple_iff.mp h
  have hpq : p ≠ q := ne_of_li_pair (li_sub01 hli)
  have hpr : p ≠ r := ne_of_li_pair (li_sub02 hli)
  have hqr : q ≠ r := ne_of_li_pair (li_sub12 hli)
  have hcard : ({p, q, r} : Finset (Point K V)).card = 3 := by
    rw [Finset.card_insert_of_notMem (by simp [hpq, hpr]),
      Finset.card_insert_of_notMem (by simp [hqr]), Finset.card_singleton]
  apply cap_of_forall_triple
  intro T hTsub hT3
  have hTeq : T = {p, q, r} :=
    Finset.eq_of_subset_of_card_le hTsub (by omega)
  subst hTeq
  have hset : ((({p, q, r} : Finset (Point K V))) : Set (Point K V)) =
      ({p, q, r} : Set (Point K V)) := by
    simp
  rw [hset]
  exact not_collinear_iff_independent.mpr h

/-- A four-point set all of whose point triples are independent is a cap. -/
theorem cap_quad_of_independent [DecidableEq (Point K V)] {p1 p2 p3 p4 : Point K V}
    (h123 : Independent ![p1, p2, p3]) (h124 : Independent ![p1, p2, p4])
    (h134 : Independent ![p1, p3, p4]) (h234 : Independent ![p2, p3, p4]) :
    Cap K V ({p1, p2, p3, p4} : Finset (Point K V)) ∧
      ({p1, p2, p3, p4} : Finset (Point K V)).card = 4 := by
  have hli123 := independent_triple_iff.mp h123
  have hli124 := independent_triple_iff.mp h124
  have hli134 := independent_triple_iff.mp h134
  have h12 : p1 ≠ p2 := ne_of_li_pair (li_sub01 hli123)
  have h13 : p1 ≠ p3 := ne_of_li_pair (li_sub02 hli123)
  have h23 : p2 ≠ p3 := ne_of_li_pair (li_sub12 hli123)
  have h14 : p1 ≠ p4 := ne_of_li_pair (li_sub02 hli124)
  have h24 : p2 ≠ p4 := ne_of_li_pair (li_sub12 hli124)
  have h34 : p3 ≠ p4 := ne_of_li_pair (li_sub12 hli134)
  have hcard : ({p1, p2, p3, p4} : Finset (Point K V)).card = 4 := by
    rw [Finset.card_insert_of_notMem (by simp [h12, h13, h14]),
      Finset.card_insert_of_notMem (by simp [h23, h24]),
      Finset.card_insert_of_notMem (by simp [h34]), Finset.card_singleton]
  refine ⟨cap_of_forall_triple ?_, hcard⟩
  intro T hTsub hT3
  obtain ⟨x, hxS, hxT⟩ : ∃ x ∈ ({p1, p2, p3, p4} : Finset (Point K V)), x ∉ T := by
    have hne : (({p1, p2, p3, p4} : Finset (Point K V)) \ T).Nonempty := by
      rw [Finset.sdiff_nonempty]
      intro hsub
      have hle := Finset.card_le_card hsub
      omega
    obtain ⟨x, hx⟩ := hne
    exact ⟨x, (Finset.mem_sdiff.mp hx).1, (Finset.mem_sdiff.mp hx).2⟩
  have hTerase : T = ({p1, p2, p3, p4} : Finset (Point K V)).erase x := by
    apply Finset.eq_of_subset_of_card_le
    · intro t ht
      exact Finset.mem_erase.mpr ⟨fun h => hxT (h ▸ ht), hTsub ht⟩
    · rw [Finset.card_erase_of_mem hxS, hcard, hT3]
  have herase : ∀ (u v w : Point K V), Independent ![u, v, w] ->
      ¬ IsCollinear (({u, v, w} : Finset (Point K V)) : Set (Point K V)) := by
    intro u v w hind hcol
    have hset : ((({u, v, w} : Finset (Point K V))) : Set (Point K V)) =
        ({u, v, w} : Set (Point K V)) := by
      simp
    rw [hset] at hcol
    exact not_collinear_iff_independent.mpr hind hcol
  rw [hTerase]
  simp only [Finset.mem_insert, Finset.mem_singleton] at hxS
  rcases hxS with hx | hx | hx | hx <;> rw [hx]
  · have he : ({p1, p2, p3, p4} : Finset (Point K V)).erase p1 = {p2, p3, p4} := by
      rw [Finset.erase_insert (by simp [h12, h13, h14])]
    rw [he]
    exact herase _ _ _ h234
  · have he : ({p1, p2, p3, p4} : Finset (Point K V)).erase p2 = {p1, p3, p4} := by
      rw [Finset.erase_insert_of_ne h12,
        Finset.erase_insert (by simp [h23, h24])]
    rw [he]
    exact herase _ _ _ h134
  · have he : ({p1, p2, p3, p4} : Finset (Point K V)).erase p3 = {p1, p2, p4} := by
      rw [Finset.erase_insert_of_ne h13, Finset.erase_insert_of_ne h23,
        Finset.erase_insert (by simp [h34])]
    rw [he]
    exact herase _ _ _ h124
  · have he : ({p1, p2, p3, p4} : Finset (Point K V)).erase p4 = {p1, p2, p3} := by
      rw [Finset.erase_insert_of_ne h14, Finset.erase_insert_of_ne h24,
        Finset.erase_insert_of_ne h34]
      simp
    rw [he]
    exact herase _ _ _ h123

/-! ## Independence with the coordinate-sum vector -/

theorem li_with_sum12 {v1 v2 v3 : V} (h : LinearIndependent K ![v1, v2, v3]) :
    LinearIndependent K ![v1, v2, v1 + v2 + v3] := by
  rw [Fintype.linearIndependent_iff] at h ⊢
  intro g hg
  have hexp : g 0 • v1 + g 1 • v2 + g 2 • (v1 + v2 + v3) = 0 := by
    rw [Fin.sum_univ_three] at hg
    simpa only [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
      Matrix.head_cons, Matrix.tail_cons] using hg
  have h0 := h ![g 0 + g 2, g 1 + g 2, g 2] (by
    rw [Fin.sum_univ_three]
    simp only [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
      Matrix.head_cons, Matrix.tail_cons]
    linear_combination (norm := module) hexp)
  have e0 := h0 0
  have e1 := h0 1
  have e2 := h0 2
  simp only [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
    Matrix.head_cons, Matrix.tail_cons] at e0 e1 e2
  intro i
  have hz0 : g 0 = 0 := by linear_combination e0 - e2
  have hz1 : g 1 = 0 := by linear_combination e1 - e2
  fin_cases i
  · exact hz0
  · exact hz1
  · exact e2

theorem li_with_sum13 {v1 v2 v3 : V} (h : LinearIndependent K ![v1, v2, v3]) :
    LinearIndependent K ![v1, v3, v1 + v2 + v3] := by
  rw [Fintype.linearIndependent_iff] at h ⊢
  intro g hg
  have hexp : g 0 • v1 + g 1 • v3 + g 2 • (v1 + v2 + v3) = 0 := by
    rw [Fin.sum_univ_three] at hg
    simpa only [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
      Matrix.head_cons, Matrix.tail_cons] using hg
  have h0 := h ![g 0 + g 2, g 2, g 1 + g 2] (by
    rw [Fin.sum_univ_three]
    simp only [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
      Matrix.head_cons, Matrix.tail_cons]
    linear_combination (norm := module) hexp)
  have e0 := h0 0
  have e1 := h0 1
  have e2 := h0 2
  simp only [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
    Matrix.head_cons, Matrix.tail_cons] at e0 e1 e2
  intro i
  have hz0 : g 0 = 0 := by linear_combination e0 - e1
  have hz1 : g 1 = 0 := by linear_combination e2 - e1
  fin_cases i
  · exact hz0
  · exact hz1
  · exact e1

theorem li_with_sum23 {v1 v2 v3 : V} (h : LinearIndependent K ![v1, v2, v3]) :
    LinearIndependent K ![v2, v3, v1 + v2 + v3] := by
  rw [Fintype.linearIndependent_iff] at h ⊢
  intro g hg
  have hexp : g 0 • v2 + g 1 • v3 + g 2 • (v1 + v2 + v3) = 0 := by
    rw [Fin.sum_univ_three] at hg
    simpa only [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
      Matrix.head_cons, Matrix.tail_cons] using hg
  have h0 := h ![g 2, g 0 + g 2, g 1 + g 2] (by
    rw [Fin.sum_univ_three]
    simp only [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
      Matrix.head_cons, Matrix.tail_cons]
    linear_combination (norm := module) hexp)
  have e0 := h0 0
  have e1 := h0 1
  have e2 := h0 2
  simp only [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
    Matrix.head_cons, Matrix.tail_cons] at e0 e1 e2
  intro i
  have hz0 : g 0 = 0 := by linear_combination e1 - e0
  have hz1 : g 1 = 0 := by linear_combination e2 - e0
  fin_cases i
  · exact hz0
  · exact hz1
  · exact e0

theorem sum_ne_zero_of_li {v1 v2 v3 : V} (h : LinearIndependent K ![v1, v2, v3]) :
    v1 + v2 + v3 ≠ 0 := by
  intro hzero
  have h0 := Fintype.linearIndependent_iff.mp h ![1, 1, 1] (by
    rw [Fin.sum_univ_three]
    simp only [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
      Matrix.head_cons, Matrix.tail_cons, one_smul]
    exact hzero)
  have h1 := h0 0
  simp at h1

/-! ## Basis extension in rank three -/

theorem exists_cons_li (hrank : finrank K V = 3) {n : ℕ} (hn : n < 3)
    (f : Fin n → V) (hf : LinearIndependent K f) :
    ∃ w : V, LinearIndependent K (Matrix.vecCons w f) := by
  have hspan : Submodule.span K (Set.range f) ≠ ⊤ := by
    intro htop
    have h1 : finrank K (Submodule.span K (Set.range f)) = n := by
      rw [finrank_span_eq_card hf]
      simp
    rw [htop, finrank_top] at h1
    omega
  have hnotall : ¬ ∀ w, w ∈ Submodule.span K (Set.range f) :=
    fun hall => hspan (Submodule.eq_top_iff'.mpr hall)
  obtain ⟨w, hw⟩ := not_forall.mp hnotall
  exact ⟨w, linearIndependent_finCons.mpr ⟨hf, hw⟩⟩

/-! ## Normal form for a four-point cap in rank three -/

section QuadNormalForm

variable [DecidableEq (Point K V)]

/-- Normal form for a four-point cap: scaled representatives of the first
three points form a basis whose coordinate sum represents the fourth. -/
theorem quad_normal_form (hrank : finrank K V = 3) {p1 p2 p3 p4 : Point K V}
    (hS : Cap K V ({p1, p2, p3, p4} : Finset (Point K V)))
    (h12 : p1 ≠ p2) (h13 : p1 ≠ p3) (h14 : p1 ≠ p4)
    (h23 : p2 ≠ p3) (h24 : p2 ≠ p4) (h34 : p3 ≠ p4) :
    ∃ u : Fin 3 → V, LinearIndependent K u ∧
      (∃ h1 : u 0 ≠ 0, Projectivization.mk K (u 0) h1 = p1) ∧
      (∃ h2 : u 1 ≠ 0, Projectivization.mk K (u 1) h2 = p2) ∧
      (∃ h3 : u 2 ≠ 0, Projectivization.mk K (u 2) h3 = p3) ∧
      u 0 + u 1 + u 2 = p4.rep := by
  have htriple : ∀ (a b c : Point K V),
      a ∈ ({p1, p2, p3, p4} : Finset (Point K V)) ->
      b ∈ ({p1, p2, p3, p4} : Finset (Point K V)) ->
      c ∈ ({p1, p2, p3, p4} : Finset (Point K V)) ->
      a ≠ b -> a ≠ c -> b ≠ c ->
      LinearIndependent K ![a.rep, b.rep, c.rep] := by
    intro a b c ha hb hc hab hac hbc
    exact independent_triple_iff.mp (not_collinear_iff_independent.mp
      (hS ha hb hc hab hac hbc))
  have hli123 : LinearIndependent K ![p1.rep, p2.rep, p3.rep] :=
    htriple p1 p2 p3 (by simp) (by simp) (by simp) h12 h13 h23
  have hli124 : LinearIndependent K ![p1.rep, p2.rep, p4.rep] :=
    htriple p1 p2 p4 (by simp) (by simp) (by simp) h12 h14 h24
  have hli134 : LinearIndependent K ![p1.rep, p3.rep, p4.rep] :=
    htriple p1 p3 p4 (by simp) (by simp) (by simp) h13 h14 h34
  have hli234 : LinearIndependent K ![p2.rep, p3.rep, p4.rep] :=
    htriple p2 p3 p4 (by simp) (by simp) (by simp) h23 h24 h34
  have hcard3 : Fintype.card (Fin 3) = finrank K V := by simp [hrank]
  set b := basisOfLinearIndependentOfCardEqFinrank hli123 hcard3 with hb_def
  set a : Fin 3 -> K := fun i => b.repr p4.rep i with ha_def
  have hcoe : ⇑b = ![p1.rep, p2.rep, p3.rep] := by
    rw [hb_def]; exact coe_basisOfLinearIndependentOfCardEqFinrank _ _
  have hb0 : b 0 = p1.rep := by rw [hcoe, Matrix.cons_val_zero]
  have hb1 : b 1 = p2.rep := by rw [hcoe, Matrix.cons_val_one, Matrix.cons_val_zero]
  have hb2 : b 2 = p3.rep := by
    rw [hcoe, Matrix.cons_val_two, Matrix.tail_cons, Matrix.head_cons]
  have hsum : a 0 • p1.rep + a 1 • p2.rep + a 2 • p3.rep = p4.rep := by
    have hrepr := b.sum_repr p4.rep
    rw [Fin.sum_univ_three, hb0, hb1, hb2] at hrepr
    exact hrepr
  have ha0 : a 0 ≠ 0 := by
    intro hzero
    have hrel : a 1 • p2.rep + a 2 • p3.rep + (-1 : K) • p4.rep = 0 := by
      rw [← hsum, hzero]
      module
    have h0 := Fintype.linearIndependent_iff.mp hli234 ![a 1, a 2, -1] (by
      rw [Fin.sum_univ_three]
      simp only [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
        Matrix.head_cons, Matrix.tail_cons]
      exact hrel)
    have h2 := h0 2
    simp at h2
  have ha1 : a 1 ≠ 0 := by
    intro hzero
    have hrel : a 0 • p1.rep + a 2 • p3.rep + (-1 : K) • p4.rep = 0 := by
      rw [← hsum, hzero]
      module
    have h0 := Fintype.linearIndependent_iff.mp hli134 ![a 0, a 2, -1] (by
      rw [Fin.sum_univ_three]
      simp only [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
        Matrix.head_cons, Matrix.tail_cons]
      exact hrel)
    have h2 := h0 2
    simp at h2
  have ha2 : a 2 ≠ 0 := by
    intro hzero
    have hrel : a 0 • p1.rep + a 1 • p2.rep + (-1 : K) • p4.rep = 0 := by
      rw [← hsum, hzero]
      module
    have h0 := Fintype.linearIndependent_iff.mp hli124 ![a 0, a 1, -1] (by
      rw [Fin.sum_univ_three]
      simp only [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
        Matrix.head_cons, Matrix.tail_cons]
      exact hrel)
    have h2 := h0 2
    simp at h2
  refine ⟨![a 0 • p1.rep, a 1 • p2.rep, a 2 • p3.rep], ?_, ?_, ?_, ?_, ?_⟩
  · have hunits := hli123.units_smul ![Units.mk0 (a 0) ha0, Units.mk0 (a 1) ha1,
      Units.mk0 (a 2) ha2]
    have hconv : (![Units.mk0 (a 0) ha0, Units.mk0 (a 1) ha1, Units.mk0 (a 2) ha2] •
        ![p1.rep, p2.rep, p3.rep]) = ![a 0 • p1.rep, a 1 • p2.rep, a 2 • p3.rep] := by
      ext i
      fin_cases i <;> simp [Pi.smul_apply', Units.smul_def]
    rwa [hconv] at hunits
  · refine ⟨smul_ne_zero ha0 p1.rep_nonzero, ?_⟩
    show Projectivization.mk K (a 0 • p1.rep) _ = p1
    exact ((Projectivization.mk_eq_mk_iff' K _ _ _ p1.rep_nonzero).mpr
      ⟨a 0, rfl⟩).trans (Projectivization.mk_rep p1)
  · refine ⟨smul_ne_zero ha1 p2.rep_nonzero, ?_⟩
    show Projectivization.mk K (a 1 • p2.rep) _ = p2
    exact ((Projectivization.mk_eq_mk_iff' K _ _ _ p2.rep_nonzero).mpr
      ⟨a 1, rfl⟩).trans (Projectivization.mk_rep p2)
  · refine ⟨smul_ne_zero ha2 p3.rep_nonzero, ?_⟩
    show Projectivization.mk K (a 2 • p3.rep) _ = p3
    exact ((Projectivization.mk_eq_mk_iff' K _ _ _ p3.rep_nonzero).mpr
      ⟨a 2, rfl⟩).trans (Projectivization.mk_rep p3)
  · show a 0 • p1.rep + a 1 • p2.rep + a 2 • p3.rep = p4.rep
    exact hsum

end QuadNormalForm

end Projective
end ProjectiveCap
