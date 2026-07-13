import FiniteGeom.BaerCompletion.Secant

/-!
# Involutive incidence geometry for Baer secants

This file isolates the part of Baer geometry that uses only an incidence-preserving involution.
The intended instance is Frobenius on points and lines of `PG(2,s²)`.
-/

namespace FiniteGeom.BaerCompletion

open Finset

variable {P L : Type*} [Fintype P] [DecidableEq P] [DecidableEq L]

/-- Points, lines, incidence, and compatible involutions. -/
structure InvolutiveIncidence (P L : Type*) where
  incident : P → L → Prop
  pointConj : P ≃ P
  lineConj : L ≃ L
  point_involutive : ∀ p, pointConj (pointConj p) = p
  line_involutive : ∀ l, lineConj (lineConj l) = l
  incident_conj_iff : ∀ p l, incident (pointConj p) (lineConj l) ↔ incident p l

variable (G : InvolutiveIncidence P L) [DecidableRel G.incident]

def IsFixedPoint (p : P) : Prop := G.pointConj p = p

def IsFixedLine (l : L) : Prop := G.lineConj l = l

/-- A selected point set is invariant under conjugation. -/
def IsInvariant (C : Finset P) : Prop := C.map G.pointConj.toEmbedding = C

/-- The selected trace cut out by a line. -/
def lineTrace (C : Finset P) (l : L) : Finset P := C.filter fun p => G.incident p l

omit [Fintype P] [DecidableEq P] [DecidableEq L] [DecidableRel G.incident] in
theorem mem_of_invariant_conj {C : Finset P} (hC : IsInvariant G C) {p : P}
    (hp : p ∈ C) : G.pointConj p ∈ C := by
  rw [← hC]
  exact Finset.mem_map.mpr ⟨p, hp, rfl⟩

omit [Fintype P] [DecidableEq P] [DecidableEq L] [DecidableRel G.incident] in
theorem mem_invariant_iff {C : Finset P} (hC : IsInvariant G C) {p : P} :
    G.pointConj p ∈ C ↔ p ∈ C := by
  constructor
  · intro hp
    have := mem_of_invariant_conj G hC hp
    simpa [G.point_involutive p] using this
  · exact mem_of_invariant_conj G hC

omit [Fintype P] [DecidableEq P] [DecidableEq L] in
/-- Conjugation transports the trace on `l` to the trace on its conjugate line. -/
theorem lineTrace_conj {C : Finset P} (hC : IsInvariant G C) (l : L) :
    (lineTrace G C l).map G.pointConj.toEmbedding = lineTrace G C (G.lineConj l) := by
  ext q
  constructor
  · intro hq
    obtain ⟨p, hp, hpq⟩ := Finset.mem_map.mp hq
    subst q
    have hpC : p ∈ C := (Finset.mem_filter.mp hp).1
    have hpil : G.incident p l := (Finset.mem_filter.mp hp).2
    exact Finset.mem_filter.mpr ⟨mem_of_invariant_conj G hC hpC,
      (G.incident_conj_iff p l).2 hpil⟩
  · intro hq
    have hqC : q ∈ C := (Finset.mem_filter.mp hq).1
    have hqil : G.incident q (G.lineConj l) := (Finset.mem_filter.mp hq).2
    let p := G.pointConj q
    have hpC : p ∈ C := mem_of_invariant_conj G hC hqC
    have hpil : G.incident p l := by
      have := (G.incident_conj_iff q (G.lineConj l)).2 hqil
      simpa [p, G.point_involutive q, G.line_involutive l] using this
    refine Finset.mem_map.mpr ⟨p, Finset.mem_filter.mpr ⟨hpC, hpil⟩, ?_⟩
    exact G.point_involutive q

omit [Fintype P] [DecidableEq P] [DecidableEq L] in
/-- A fixed line cuts an invariant trace from an invariant point set. -/
theorem lineTrace_invariant_of_fixed {C : Finset P} (hC : IsInvariant G C) {l : L}
    (hl : IsFixedLine G l) : IsInvariant G (lineTrace G C l) := by
  unfold IsInvariant
  rw [lineTrace_conj G hC, hl]

omit [Fintype P] [DecidableEq L] [DecidableRel G.incident] in
/-- A two-point invariant trace containing a nonfixed point is exactly its conjugate pair. -/
theorem invariant_pair_eq_conjugate {S : Finset P} (hS : IsInvariant G S)
    (hcard : S.card = 2) {p : P} (hpS : p ∈ S) (hp : ¬ IsFixedPoint G p) :
    S = {p, G.pointConj p} := by
  have hcpS : G.pointConj p ∈ S := mem_of_invariant_conj G hS hpS
  have hne : G.pointConj p ≠ p := by
    intro h
    exact hp h
  symm
  apply Finset.eq_of_subset_of_card_le
  · exact Finset.insert_subset hpS (Finset.singleton_subset_iff.mpr hcpS)
  · simp [hcard, hne.symm]

omit [Fintype P] [DecidableEq L] [DecidableRel G.incident] in
/-- Hence a fixed secant trace is either pointwise fixed or one conjugate pair. -/
theorem invariant_pair_fixed_or_conjugate {S : Finset P} (hS : IsInvariant G S)
    (hcard : S.card = 2) :
    (∀ p ∈ S, IsFixedPoint G p) ∨
      ∃ p, p ∈ S ∧ ¬ IsFixedPoint G p ∧ S = {p, G.pointConj p} := by
  by_cases h : ∀ p ∈ S, IsFixedPoint G p
  · exact Or.inl h
  · push Not at h
    obtain ⟨p, hpS, hp⟩ := h
    exact Or.inr ⟨p, hpS, hp, invariant_pair_eq_conjugate G hS hcard hpS hp⟩

omit [Fintype P] [DecidableEq P] [DecidableEq L] in
/-- Conjugate nonfixed lines through an external common point cut disjoint selected traces.

`hunique` is the projective-plane axiom specialized to the two lines: their only common point is
`x`. -/
theorem conjugate_lineTraces_disjoint {C : Finset P} {x : P} {l : L}
    (hxC : x ∉ C)
    (hunique : ∀ q, G.incident q l → G.incident q (G.lineConj l) → q = x) :
    Disjoint (lineTrace G C l) (lineTrace G C (G.lineConj l)) := by
  rw [Finset.disjoint_left]
  intro q hql hqcl
  have hql' := (Finset.mem_filter.mp hql).2
  have hqcl' := (Finset.mem_filter.mp hqcl).2
  have hqx : q = x := hunique q hql' hqcl'
  subst q
  exact hxC (Finset.mem_filter.mp hql).1

end FiniteGeom.BaerCompletion
