import FiniteGeom.BaerCompletion.Obstruction

/-!
# Secant resilience

The incidence geometry needed for a planar arc reduces to one finite hypergraph fact: the occupied
secants through an external point cut out nonempty, pairwise-disjoint obstruction traces. Their
transversal number, and hence the insertion distance, is exactly their number.
-/

namespace FiniteGeom.BaerCompletion

open Finset

variable {V : Type*} [Fintype V] [DecidableEq V]

/-- A pairwise-disjoint nonempty hypergraph has transversal number equal to its number of edges. -/
theorem transversalNumber_eq_card_of_pairwise_disjoint (H : Finset (Finset V))
    (hne : ∀ e ∈ H, e.Nonempty)
    (hdisj : ∀ ⦃a⦄, a ∈ H → ∀ ⦃b⦄, b ∈ H → a ≠ b → Disjoint a b) :
    transversalNumber H = H.card := by
  classical
  have hmatching : IsMatching H H := ⟨subset_refl _, hdisj⟩
  have hlower : H.card ≤ transversalNumber H :=
    le_trans (card_le_matchingNumber hmatching) (nu_le_tau H hne)
  let pick : {e // e ∈ H} → V := fun e => (hne e e.property).choose
  let T : Finset V := H.attach.image pick
  have hT : IsTransversal H T := by
    intro e he
    let ee : {e // e ∈ H} := ⟨e, he⟩
    have hpick : pick ee ∈ e := (hne e he).choose_spec
    have hpickT : pick ee ∈ T := by
      exact Finset.mem_image.mpr ⟨ee, Finset.mem_attach H ee, rfl⟩
    exact ⟨pick ee, Finset.mem_inter.mpr ⟨hpickT, hpick⟩⟩
  have hupper : transversalNumber H ≤ H.card := by
    calc
      transversalNumber H ≤ T.card := transversalNumber_le_card hT
      _ ≤ H.attach.card := Finset.card_image_le
      _ = H.card := Finset.card_attach
  omega

variable (I : IndependenceSystem V) [DecidablePred I.indep]

/-- The exact hypotheses supplied by occupied secants through an external point of an arc. `H`
contains the minimal pair traces; `insertion_iff` says they generate every dependent trace. -/
structure IsSecantObstructionFamily (C : Finset V) (x : V)
    (H : Finset (Finset V)) : Prop where
  edge_subset : ∀ e ∈ H, e ⊆ C
  edge_card_two : ∀ e ∈ H, e.card = 2
  edge_disjoint : ∀ ⦃a⦄, a ∈ H → ∀ ⦃b⦄, b ∈ H → a ≠ b → Disjoint a b
  insertion_iff : ∀ D,
    I.indep (insert x (C \ D)) ↔ ∀ A ∈ H, ¬ A ⊆ C \ D

omit [Fintype V] [DecidablePred I.indep] in
/-- A generating secant family computes the genuine insertion distance through the abstract
completion-distance definition. -/
theorem insertionDistance_eq_completionDistance_of_secants
    {C : Finset V} {x : V} {H : Finset (Finset V)}
    (hsec : IsSecantObstructionFamily I C x H) :
    insertionDistance I C x = completionDistance H C := by
  unfold insertionDistance completionDistance
  congr 1
  ext n
  simp only [Set.mem_setOf_eq]
  constructor
  · rintro ⟨D, hDC, hI, rfl⟩
    exact ⟨D, hDC, (hsec.insertion_iff D).mp hI, rfl⟩
  · rintro ⟨D, hDC, hH, rfl⟩
    exact ⟨D, hDC, (hsec.insertion_iff D).mpr hH, rfl⟩

omit [DecidablePred I.indep] in
/-- **Secant resilience.** When the generating insertion obstructions are disjoint pairs, the
number of deletions required to insert `x` equals the number of occupied secants through `x`. -/
theorem insertionDistance_eq_secantCount {C : Finset V} {x : V}
    {H : Finset (Finset V)} (hsec : IsSecantObstructionFamily I C x H) :
    insertionDistance I C x = H.card := by
  have hne : ∀ A ∈ H, A.Nonempty := by
    intro A hA
    rw [Finset.nonempty_iff_ne_empty]
    intro hzero
    have hcard := hsec.edge_card_two A hA
    simp [hzero] at hcard
  calc
    insertionDistance I C x = completionDistance H C :=
      insertionDistance_eq_completionDistance_of_secants I hsec
    _ = transversalNumber H :=
      completionDistance_eq_transversalNumber H C hsec.edge_subset hne
    _ = H.card := transversalNumber_eq_card_of_pairwise_disjoint H hne hsec.edge_disjoint

/-- Minimum insertion distance over a finite set of external candidate points. -/
noncomputable def globalInsertionDistance (I : IndependenceSystem V) (C X : Finset V) : ℕ :=
  sInf {n | ∃ x ∈ X, insertionDistance I C x = n}

omit [DecidablePred I.indep] in
/-- Global secant resilience: when every candidate has disjoint pair obstructions, the global
completion distance is the minimum occupied-secant count. -/
theorem globalInsertionDistance_eq_min_secantCount {C X : Finset V}
    (secants : V → Finset (Finset V))
    (hsec : ∀ x ∈ X, IsSecantObstructionFamily I C x (secants x)) :
    globalInsertionDistance I C X =
      sInf {n | ∃ x ∈ X, (secants x).card = n} := by
  unfold globalInsertionDistance
  congr 1
  ext n
  constructor
  · rintro ⟨x, hx, hxn⟩
    exact ⟨x, hx, (insertionDistance_eq_secantCount I (hsec x hx)).symm.trans hxn⟩
  · rintro ⟨x, hx, hxn⟩
    exact ⟨x, hx, (insertionDistance_eq_secantCount I (hsec x hx)).trans hxn⟩

end FiniteGeom.BaerCompletion
