import ProjectiveCap.ConicLocalization

/-!
# Intrusion calculus: the free conic and the bare-counter theorem

Game-theoretic layer of the intrusion calculus
(`notes/2026-07-07-onconic-intrusion-calculus.md`).  While the played set stays
on a fixed hyperbola, every unplayed hyperbola cell is a legal move (Lemma II,
"the free conic").  Consequently, if no off-conic cell is ever legal above a
position, the residual game is a bare move counter: the game value is the
parity of the unplayed conic cells.

Composed with the geometric no-intrusion kernel
(`NoIntrusionAboveFourStatement` — Theorem IV's finite-geometry input, true
for `q = 5, 7` by the tangency bound, false from `q = 11` on), this proves the
on-conic escape statement, hence the full plane outcome, for those `q`.
-/

namespace ProjectiveCap
namespace ConicLocalization

variable {K : Type*} [Field K] [Fintype K] [DecidableEq K]

/-- Free conic (Lemma II): as long as the played set stays on a hyperbola,
every unplayed hyperbola cell is a legal move. -/
theorem freeConic_mem_legalExtensions
    {rho A B : K} (hB : B ≠ 0) {S : Finset (GridPoint K)}
    (hS : S ⊆ HyperbolaCells (K := K) rho A B)
    {x : GridPoint K} (hx : x ∈ HyperbolaCells (K := K) rho A B) (hxS : x ∉ S) :
    x ∈ GridGame.LegalExtensions (K := K) S := by
  rw [GridGame.mem_legalExtensions]
  exact ⟨hxS, gridCap_mono (Finset.insert_subset hx hS)
    (gridCap_hyperbolaCells (K := K) hB)⟩

/-- No intruder is ever legal above `S`: every legal move from every
intermediate on-conic position lies on the conic. -/
def ConicOnlyAbove (rho A B : K) (S : Finset (GridPoint K)) : Prop :=
  ∀ T : Finset (GridPoint K), S ⊆ T ->
    T ⊆ HyperbolaCells (K := K) rho A B ->
    ∀ x : GridPoint K, x ∈ GridGame.LegalExtensions (K := K) T ->
      x ∈ HyperbolaCells (K := K) rho A B

/-- Under the no-intrusion hypothesis the legal moves from an on-conic
position are exactly the unplayed conic cells. -/
theorem legalExtensions_eq_sdiff_of_conicOnlyAbove
    {rho A B : K} (hB : B ≠ 0) {S T : Finset (GridPoint K)}
    (honly : ConicOnlyAbove (K := K) rho A B S)
    (hST : S ⊆ T) (hT : T ⊆ HyperbolaCells (K := K) rho A B) :
    GridGame.LegalExtensions (K := K) T =
      HyperbolaCells (K := K) rho A B \ T := by
  ext x
  rw [Finset.mem_sdiff]
  constructor
  · intro hx
    exact ⟨honly T hST hT x hx, (GridGame.mem_legalExtensions.mp hx).1⟩
  · rintro ⟨hxC, hxT⟩
    exact freeConic_mem_legalExtensions (K := K) hB hT hxC hxT

/-- The bare-counter theorem: with no intrusion available above `S`, the game
value of any on-conic position is the parity of its unplayed conic cells. -/
theorem isP_iff_even_card_sdiff_of_conicOnlyAbove
    {rho A B : K} (hB : B ≠ 0) {S : Finset (GridPoint K)}
    (honly : ConicOnlyAbove (K := K) rho A B S)
    (hS : S ⊆ HyperbolaCells (K := K) rho A B) :
    (GridGame.IsP (K := K) S ↔
      Even ((HyperbolaCells (K := K) rho A B \ S).card)) := by
  suffices h : ∀ n : ℕ, ∀ T : Finset (GridPoint K), S ⊆ T ->
      T ⊆ HyperbolaCells (K := K) rho A B ->
      (HyperbolaCells (K := K) rho A B \ T).card = n ->
      (GridGame.IsP (K := K) T ↔ Even n) by
    exact h _ S subset_rfl hS rfl
  intro n
  induction n using Nat.strong_induction_on with
  | _ n ih =>
    intro T hST hTC hcard
    have hlegal :=
      legalExtensions_eq_sdiff_of_conicOnlyAbove (K := K) hB honly hST hTC
    by_cases hn : n = 0
    · subst hn
      have hempty : HyperbolaCells (K := K) rho A B \ T = ∅ :=
        Finset.card_eq_zero.mp hcard
      have hnomove : ∀ x : GridPoint K, ¬ GridGame.Move (K := K) T x := by
        intro x hx
        have hmem : x ∈ GridGame.LegalExtensions (K := K) T :=
          GridGame.mem_legalExtensions.mpr ⟨hx.1, hx.2⟩
        rw [hlegal, hempty] at hmem
        exact absurd hmem (Finset.notMem_empty x)
      exact ⟨fun _ => ⟨0, by omega⟩,
        fun _ => FiniteBuildGame.isP_of_no_moves hnomove⟩
    · have hnpos : 0 < n := Nat.pos_of_ne_zero hn
      have hchild : ∀ x : GridPoint K,
          x ∈ HyperbolaCells (K := K) rho A B \ T ->
            (GridGame.IsP (K := K) (insert x T) ↔ Even (n - 1)) := by
        intro x hx
        rcases Finset.mem_sdiff.mp hx with ⟨hxC, hxT⟩
        refine ih (n - 1) (by omega) (insert x T)
          (hST.trans (Finset.subset_insert x T))
          (Finset.insert_subset hxC hTC) ?_
        have hsd : HyperbolaCells (K := K) rho A B \ insert x T =
            (HyperbolaCells (K := K) rho A B \ T).erase x := by
          ext y
          simp only [Finset.mem_sdiff, Finset.mem_erase, Finset.mem_insert,
            not_or]
          tauto
        rw [hsd, Finset.card_erase_of_mem hx, hcard]
      constructor
      · intro hP
        obtain ⟨x, hx⟩ := Finset.card_pos.mp (hcard ▸ hnpos)
        have hxmove : GridGame.Move (K := K) T x := by
          have hmem : x ∈ GridGame.LegalExtensions (K := K) T := by
            rw [hlegal]; exact hx
          exact GridGame.mem_legalExtensions.mp hmem
        have hxWin := (GridGame.isP_iff_all_children_win.mp hP) x hxmove
        have hxNotP : ¬ GridGame.IsP (K := K) (insert x T) := fun h => h hxWin
        have hnotEven : ¬ Even (n - 1) := fun h =>
          hxNotP ((hchild x hx).mpr h)
        rcases Nat.even_or_odd n with he | ho
        · exact he
        · obtain ⟨k, hk⟩ := ho
          exact absurd ⟨k, by omega⟩ hnotEven
      · intro hEven
        rw [GridGame.isP_iff_all_children_win]
        intro x hxmove
        have hxmem : x ∈ HyperbolaCells (K := K) rho A B \ T := by
          rw [← hlegal]
          exact GridGame.mem_legalExtensions.mpr ⟨hxmove.1, hxmove.2⟩
        have hnotEven : ¬ Even (n - 1) := by
          obtain ⟨k, hk⟩ := hEven
          rintro ⟨m, hm⟩
          omega
        have hxNotP : ¬ GridGame.IsP (K := K) (insert x T) := fun h =>
          hnotEven ((hchild x hxmem).mp h)
        exact of_not_not hxNotP

/-- No-intrusion propagates upward: if every legal extension of `S` itself
lies on the conic, the same holds above every intermediate on-conic `T`,
because legality is antitone in the position.  This collapses the
no-intrusion obligation to the size-four seed alone. -/
theorem conicOnlyAbove_of_forall_legal_mem
    {rho A B : K} {S : Finset (GridPoint K)}
    (h : ∀ x : GridPoint K, x ∈ GridGame.LegalExtensions (K := K) S ->
      x ∈ HyperbolaCells (K := K) rho A B) :
    ConicOnlyAbove (K := K) rho A B S := by
  intro T hST _hTC x hx
  rw [GridGame.mem_legalExtensions] at hx
  refine h x ?_
  rw [GridGame.mem_legalExtensions]
  exact ⟨fun hxS => hx.1 (hST hxS),
    gridCap_mono (Finset.insert_subset_insert x hST) hx.2⟩

/--
Geometric no-intrusion kernel: above every on-conic size-four position, no
off-conic cell is ever legal.  This is Theorem IV's finite-geometry input
(the tangency-count bound, Lemma III(4) of the intrusion note).

WARNING (route status): per-`q` target only — TRUE for `q = 5` and `q = 7`
(where it proves the plane outcome below), FALSE from `q = 11` on: legal
intruders exist in the intrusion census
(`notes/2026-07-07-onconic-intrusion-calculus.md` §7).  Do not proof-search
the universal statement.
-/
def NoIntrusionAboveFourStatement : Prop :=
  ∀ rho A B : K, B ≠ 0 ->
    ∀ S : Finset (GridPoint K), S.card = 4 ->
      S ⊆ HyperbolaCells (K := K) rho A B ->
      ConicOnlyAbove (K := K) rho A B S

/-- With no intrusion available, every on-conic size-four position of an odd
plane is a bare counter of even length, hence a P-position. -/
theorem isP_of_card_four_of_conicOnlyAbove
    (hq : Odd (Fintype.card K))
    {rho A B : K} (hB : B ≠ 0) {S : Finset (GridPoint K)}
    (hcard : S.card = 4) (hS : S ⊆ HyperbolaCells (K := K) rho A B)
    (honly : ConicOnlyAbove (K := K) rho A B S) :
    GridGame.IsP (K := K) S := by
  rw [isP_iff_even_card_sdiff_of_conicOnlyAbove (K := K) hB honly hS,
    Finset.card_sdiff_of_subset hS, card_hyperbolaCells (K := K) hB, hcard]
  obtain ⟨k, hk⟩ := hq
  exact ⟨k - 2, by omega⟩

/-- A field of odd cardinality has `2 ≠ 0`: the shift `x ↦ x + 1` would
otherwise be a fixed-point-free involution pairing up the whole field. -/
theorem two_ne_zero_of_odd_card (hq : Odd (Fintype.card K)) : (2 : K) ≠ 0 := by
  intro h2
  have heven : Even (Finset.univ : Finset K).card :=
    even_card_of_involutive_fpf_on_finset (Finset.univ : Finset K)
      (fun x => x + 1)
      (fun x _ => Finset.mem_univ _)
      (fun x _ => by rw [add_assoc, one_add_one_eq_two, h2, add_zero])
      (fun x _ hfix => by
        have h0 : x + 1 = x + 0 := by rw [add_zero]; exact hfix
        exact one_ne_zero (add_left_cancel h0))
  rw [Finset.card_univ] at heven
  exact (Nat.not_even_iff_odd.mpr hq) heven

/--
**The order-five no-intrusion kernel (Theorem IV, `q = 5` case).**  Over a
field of cardinality five the conic has `q − 1 = 4` affine cells, so an
on-conic size-four position IS the whole affine conic — which is a maximal
grid cap in odd characteristic.  No intruder is ever legal, with no case
analysis at all.
-/
theorem noIntrusionAboveFourStatement_of_card_eq_five
    (hcard : Fintype.card K = 5) :
    NoIntrusionAboveFourStatement (K := K) := by
  intro rho A B hB S hS4 hSsub T hST hTC x hx
  exfalso
  have h2 : (2 : K) ≠ 0 :=
    two_ne_zero_of_odd_card (K := K) (by rw [hcard]; exact ⟨2, rfl⟩)
  have hCcard : (HyperbolaCells (K := K) rho A B).card = 4 := by
    rw [card_hyperbolaCells (K := K) hB, hcard]
  have hSC : S = HyperbolaCells (K := K) rho A B :=
    Finset.eq_of_subset_of_card_le hSsub (le_of_eq (hCcard.trans hS4.symm))
  have hTeq : T = HyperbolaCells (K := K) rho A B :=
    subset_antisymm hTC (hSC ▸ hST)
  rw [GridGame.mem_legalExtensions, hTeq] at hx
  exact (maximalGridCap_hyperbolaCells_of_two_ne_zero (K := K) h2 hB).2
    x hx.1 hx.2

/-- Theorem IV, game half: the per-`q` no-intrusion kernel yields the on-conic
escape statement for odd `q` — every size-three seed's conic completions are
all escapes. -/
theorem onConicEscapeStatement_of_noIntrusionAboveFour
    (hq : Odd (Fintype.card K))
    (hno : NoIntrusionAboveFourStatement (K := K)) :
    OnConicEscapeStatement (K := K) := by
  intro S hcard hS
  obtain ⟨rho, A, B, hB, hfit⟩ :=
    exists_hyperbolaNormalForm (K := K) hcard hS
  have hSsub : S ⊆ HyperbolaCells (K := K) rho A B := fun p hp =>
    mem_hyperbolaCells.mpr (hfit p hp)
  have hcards : S.card ≤ (HyperbolaCells (K := K) rho A B).card :=
    Finset.card_le_card hSsub
  have hq5 : 5 ≤ Fintype.card K := by
    rw [card_hyperbolaCells (K := K) hB, hcard] at hcards
    obtain ⟨k, hk⟩ := hq
    omega
  have hpos : 0 < (HyperbolaCells (K := K) rho A B \ S).card := by
    rw [Finset.card_sdiff_of_subset hSsub, card_hyperbolaCells (K := K) hB, hcard]
    omega
  obtain ⟨p, hp⟩ := Finset.card_pos.mp hpos
  rcases Finset.mem_sdiff.mp hp with ⟨hpC, hpS⟩
  have hS4card : (insert p S).card = 4 := by
    rw [Finset.card_insert_of_notMem hpS, hcard]
  have hS4sub : insert p S ⊆ HyperbolaCells (K := K) rho A B :=
    Finset.insert_subset hpC hSsub
  have hP : GridGame.IsP (K := K) (insert p S) :=
    isP_of_card_four_of_conicOnlyAbove (K := K) hq hB hS4card hS4sub
      (hno rho A B hB (insert p S) hS4card hS4sub)
  have hpLegal : p ∈ GridGame.LegalExtensions (K := K) S :=
    freeConic_mem_legalExtensions (K := K) hB hSsub hpC hpS
  exact ⟨rho, A, B, p, hB, hfit,
    mem_onConicLegalExtensions.mpr ⟨mem_hyperbolaCells.mp hpC, hpLegal⟩, hP⟩

end ConicLocalization
end ProjectiveCap
