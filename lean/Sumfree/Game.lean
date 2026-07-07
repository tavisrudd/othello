import CapGame.BuildGame
import Sumfree.MirrorLemmas

/-!
# Finite normal-play sum-free game

This file connects the local Set-level mirror lemmas in `Sumfree.MirrorLemmas`
to the shared finite building-game kernel.
-/

namespace Sumfree
namespace Game

open Set

variable {G : Type*} [AddCommGroup G] [Fintype G] [DecidableEq G]

/-- Finite-position validity for the sum-free building game. -/
def Valid (S : Finset G) : Prop :=
  SumFree (S : Set G)

/-- Legal finite-game move. -/
abbrev Move (S : Finset G) (x : G) : Prop :=
  FiniteBuildGame.Move Valid S x

/-- Normal-play win predicate for finite sum-free play. -/
abbrev Win (S : Finset G) : Prop :=
  FiniteBuildGame.Win Valid S

/-- P-position predicate for finite sum-free play. -/
abbrev IsP (S : Finset G) : Prop :=
  FiniteBuildGame.IsP Valid S

omit [Fintype G] in
theorem move_iff_legal {S : Finset G} {x : G} :
    Move S x ↔ Legal (S : Set G) x := by
  simp [Move, FiniteBuildGame.Move, Valid, Legal]

omit [Fintype G] in
theorem legal_of_move {S : Finset G} {x : G} (h : Move S x) :
    Legal (S : Set G) x :=
  move_iff_legal.1 h

omit [Fintype G] in
theorem move_of_legal {S : Finset G} {x : G} (h : Legal (S : Set G) x) :
    Move S x :=
  move_iff_legal.2 h

omit [Fintype G] [DecidableEq G] in
theorem valid_empty : Valid (∅ : Finset G) := by
  intro a b c ha
  simp at ha

omit [Fintype G] [DecidableEq G] in
theorem valid_singleton_of_ne_zero {o : G} (ho0 : o ≠ 0) :
    Valid ({o} : Finset G) := by
  intro a b c ha hb hc hsum
  simp only [Finset.mem_coe, Finset.mem_singleton] at ha hb hc
  subst a
  subst b
  subst c
  have ho : o = 0 := by
    have h' := congrArg (fun t => t + -o) hsum
    simpa [add_assoc, add_comm, add_left_comm] using h'
  exact ho0 ho

omit [Fintype G] [DecidableEq G] in
theorem valid_singleton_iff {o : G} :
    Valid ({o} : Finset G) ↔ o ≠ 0 := by
  constructor
  · intro hvalid ho0
    exact hvalid
      (a := o) (b := o) (c := o)
      (by simp) (by simp) (by simp)
      (by simp [ho0])
  · exact valid_singleton_of_ne_zero

omit [Fintype G] in
theorem empty_move_iff_ne_zero {o : G} :
    Move (∅ : Finset G) o ↔ o ≠ 0 := by
  simp [Move, FiniteBuildGame.Move, valid_singleton_iff]

omit [Fintype G] [DecidableEq G] in
theorem legal_ne_zero {A : Set G} {x : G} (hx : Legal A x) :
    x ≠ 0 := by
  intro hx0
  exact hx.2 (Or.inl rfl) (Or.inl rfl) (Or.inl rfl) (by simp [hx0])

section Neg

/-- Mirror-ready positions for the negation strategy. -/
def NegGood (S : Finset G) : Prop :=
  Valid S ∧ NegInvariant (S : Set G)

omit [Fintype G] [DecidableEq G] in
theorem negInvariant_empty :
    NegInvariant ((∅ : Finset G) : Set G) := by
  intro x hx
  simp at hx

omit [Fintype G] [DecidableEq G] in
theorem negInvariant_insert_pair {A : Set G} {y : G}
    (hA : NegInvariant A) :
    NegInvariant (insert (-y) (insert y A)) := by
  intro z hz
  rcases hz with hzNeg | hzRest
  · subst z
    exact Or.inr (Or.inl (by simp))
  · rcases hzRest with hzY | hzA
    · subst z
      exact Or.inl rfl
    · exact Or.inr (Or.inr (hA hzA))

omit [Fintype G] in
theorem negGood_step_of_live_no_obstructions
    (hfixed : ∀ {S : Finset G} {y : G}, NegGood S -> Move S y -> -y ≠ y)
    (hnoO3 : ∀ {S : Finset G} {y : G}, NegGood S -> Move S y -> y + y ≠ -y) :
    ∀ {S : Finset G}, NegGood S -> ∀ y : G, Move S y ->
      ∃ r : G, Move (insert y S) r ∧ NegGood (insert r (insert y S)) := by
  intro S hgood y hymove
  have hfixed_y : -y ≠ y := hfixed hgood hymove
  have hnoO3_y : y + y ≠ -y := hnoO3 hgood hymove
  rcases hgood with ⟨hvalid, hneg⟩
  let r := -y
  have hylegal : Legal (S : Set G) y := legal_of_move hymove
  have hrlegal : Legal (insert y (S : Set G)) r := by
    simpa [r] using neg_mirror_legal
      (G := G) (A := (S : Set G)) (x := y)
      hvalid hneg hylegal hfixed_y hnoO3_y
  have hrmove : Move (insert y S) r :=
    move_of_legal (S := insert y S) (x := r) (by simpa using hrlegal)
  refine ⟨r, hrmove, ?_⟩
  refine ⟨hrmove.2, ?_⟩
  intro z
  simpa [r, Finset.mem_coe] using
    (negInvariant_insert_pair (A := (S : Set G)) (y := y) hneg (x := z))

omit [Fintype G] in
theorem negGood_step
    (hfixed : ∀ x : G, x ≠ 0 -> -x ≠ x)
    (hnoO3 : ∀ x : G, x ≠ 0 -> x + x ≠ -x) :
    ∀ {S : Finset G}, NegGood S -> ∀ y : G, Move S y ->
      ∃ r : G, Move (insert y S) r ∧ NegGood (insert r (insert y S)) := by
  exact negGood_step_of_live_no_obstructions
    (G := G)
    (fun {S} {y} _ hymove =>
      hfixed y (legal_ne_zero (legal_of_move (S := S) hymove)))
    (fun {S} {y} _ hymove =>
      hnoO3 y (legal_ne_zero (legal_of_move (S := S) hymove)))

theorem negGood_isP_of_live_no_obstructions
    (hfixed : ∀ {S : Finset G} {y : G}, NegGood S -> Move S y -> -y ≠ y)
    (hnoO3 : ∀ {S : Finset G} {y : G}, NegGood S -> Move S y -> y + y ≠ -y)
    {S : Finset G} (hgood : NegGood S) :
    IsP S :=
  FiniteBuildGame.isP_of_replyStrategy
    (Valid := Valid) (Good := NegGood)
    (negGood_step_of_live_no_obstructions (G := G) hfixed hnoO3) S hgood

/--
If negation has no nonzero fixed point and no nonzero order-three collision,
the empty sum-free game is a P-position.
-/
theorem initial_isP_of_negation_no_obstructions
    (hfixed : ∀ x : G, x ≠ 0 -> -x ≠ x)
    (hnoO3 : ∀ x : G, x ≠ 0 -> x + x ≠ -x) :
    IsP (∅ : Finset G) := by
  have hgood : NegGood (G := G) (∅ : Finset G) :=
    ⟨valid_empty (G := G), negInvariant_empty (G := G)⟩
  exact FiniteBuildGame.isP_of_replyStrategy
    (Valid := Valid) (Good := NegGood)
    (negGood_step (G := G) hfixed hnoO3) (∅ : Finset G) hgood

omit [Fintype G] [DecidableEq G] in
private theorem neg_eq_self_of_add_self_eq_zero {m : G} (hm2 : m + m = 0) :
    -m = m := by
  have h := congrArg (fun t => -m + t) hm2
  simpa [add_assoc] using h.symm

def NegGoodWith (m : G) (S : Finset G) : Prop :=
  NegGood S ∧ m ∈ S

omit [Fintype G] [DecidableEq G] in
theorem negInvariant_orderTwo_singleton {m : G} (hm2 : m + m = 0) :
    NegInvariant (({m} : Finset G) : Set G) := by
  intro x hx
  simp only [Finset.mem_coe, Finset.mem_singleton] at hx ⊢
  subst x
  exact neg_eq_self_of_add_self_eq_zero hm2

omit [Fintype G] in
theorem negGoodWith_step_of_no_other_obstructions {m : G}
    (hfixed : ∀ x : G, x ≠ 0 -> x ≠ m -> -x ≠ x)
    (hnoO3 : ∀ x : G, x ≠ 0 -> x ≠ m -> x + x ≠ -x) :
    ∀ {S : Finset G}, NegGoodWith m S -> ∀ y : G, Move S y ->
      ∃ r : G, Move (insert y S) r ∧ NegGoodWith m (insert r (insert y S)) := by
  intro S hgood y hymove
  rcases hgood with ⟨hnegGood, hmS⟩
  rcases hnegGood with ⟨hvalid, hneg⟩
  let r := -y
  have hylegal : Legal (S : Set G) y := legal_of_move hymove
  have hy0 : y ≠ 0 := legal_ne_zero hylegal
  have hym : y ≠ m := by
    intro h
    exact hymove.1 (by simpa [h] using hmS)
  have hrlegal : Legal (insert y (S : Set G)) r := by
    simpa [r] using neg_mirror_legal
      (G := G) (A := (S : Set G)) (x := y)
      hvalid hneg hylegal (hfixed y hy0 hym) (hnoO3 y hy0 hym)
  have hrmove : Move (insert y S) r :=
    move_of_legal (S := insert y S) (x := r) (by simpa using hrlegal)
  refine ⟨r, hrmove, ?_⟩
  refine ⟨⟨hrmove.2, ?_⟩, ?_⟩
  · intro z
    simpa [r, Finset.mem_coe] using
      (negInvariant_insert_pair (A := (S : Set G)) (y := y) hneg (x := z))
  · exact by simp [hmS]

theorem orderTwo_singleton_isP_of_negation_no_other_obstructions {m : G}
    (hm2 : m + m = 0) (hm0 : m ≠ 0)
    (hfixed : ∀ x : G, x ≠ 0 -> x ≠ m -> -x ≠ x)
    (hnoO3 : ∀ x : G, x ≠ 0 -> x ≠ m -> x + x ≠ -x) :
    IsP ({m} : Finset G) := by
  have hgood : NegGoodWith (G := G) m ({m} : Finset G) :=
    ⟨⟨valid_singleton_of_ne_zero (G := G) hm0,
        negInvariant_orderTwo_singleton (G := G) hm2⟩,
      by simp⟩
  exact FiniteBuildGame.isP_of_replyStrategy
    (Valid := Valid) (Good := NegGoodWith m)
    (negGoodWith_step_of_no_other_obstructions (G := G) hfixed hnoO3)
    ({m} : Finset G) hgood

theorem initial_win_of_orderTwo_no_other_negation_obstructions {m : G}
    (hm2 : m + m = 0) (hm0 : m ≠ 0)
    (hfixed : ∀ x : G, x ≠ 0 -> x ≠ m -> -x ≠ x)
    (hnoO3 : ∀ x : G, x ≠ 0 -> x ≠ m -> x + x ≠ -x) :
    Win (∅ : Finset G) := by
  have hmove : Move (∅ : Finset G) m :=
    (empty_move_iff_ne_zero (G := G)).2 hm0
  exact FiniteBuildGame.win_of_move_to_isP hmove
    (by
      simpa using orderTwo_singleton_isP_of_negation_no_other_obstructions
        (G := G) hm2 hm0 hfixed hnoO3)

end Neg

section FiniteObstructions

/-- The finite set of nonzero order-two elements. -/
noncomputable def NonzeroOrderTwoElements : Finset G :=
  Finset.univ.filter fun v => v + v = 0 ∧ v ≠ 0

theorem mem_nonzeroOrderTwoElements {v : G} :
    v ∈ NonzeroOrderTwoElements (G := G) ↔ v + v = 0 ∧ v ≠ 0 := by
  classical
  simp [NonzeroOrderTwoElements]

/-- The finite set of nonzero elements causing the negation order-three obstruction. -/
noncomputable def NonzeroOrderThreeElements : Finset G :=
  Finset.univ.filter fun v => v + v = -v ∧ v ≠ 0

theorem mem_nonzeroOrderThreeElements {v : G} :
    v ∈ NonzeroOrderThreeElements (G := G) ↔ v + v = -v ∧ v ≠ 0 := by
  classical
  simp [NonzeroOrderThreeElements]

omit [Fintype G] [DecidableEq G] in
private theorem add_self_eq_zero_of_neg_eq_self {x : G} (hx : -x = x) :
    x + x = 0 := by
  calc
    x + x = x + -x := by simp [hx]
    _ = 0 := by simp

/--
Concrete finite-set version of the no-obstruction negation theorem: if there
are no nonzero order-two or order-three obstruction elements, the empty game is
P.
-/
theorem initial_isP_of_no_nonzero_orderTwo_or_three
    (h2 : (NonzeroOrderTwoElements (G := G)).card = 0)
    (h3 : (NonzeroOrderThreeElements (G := G)).card = 0) :
    IsP (∅ : Finset G) := by
  refine initial_isP_of_negation_no_obstructions (G := G) ?_ ?_
  · intro x hx0 hneg
    have hx2 : x + x = 0 := add_self_eq_zero_of_neg_eq_self hneg
    have hxmem : x ∈ NonzeroOrderTwoElements (G := G) :=
      (mem_nonzeroOrderTwoElements (G := G) (v := x)).2 ⟨hx2, hx0⟩
    have hempty : NonzeroOrderTwoElements (G := G) = ∅ :=
      Finset.card_eq_zero.mp h2
    rw [hempty] at hxmem
    simp at hxmem
  · intro x hx0 hx3
    have hxmem : x ∈ NonzeroOrderThreeElements (G := G) :=
      (mem_nonzeroOrderThreeElements (G := G) (v := x)).2 ⟨hx3, hx0⟩
    have hempty : NonzeroOrderThreeElements (G := G) = ∅ :=
      Finset.card_eq_zero.mp h3
    rw [hempty] at hxmem
    simp at hxmem

/--
If `m` is the unique nonzero order-two element and there are no nonzero
order-three obstructions, opening at `m` wins.
-/
theorem initial_win_of_unique_orderTwo_no_nonzero_orderThree {m : G}
    (hm : m ∈ NonzeroOrderTwoElements (G := G))
    (hunique : ∀ {x : G}, x ∈ NonzeroOrderTwoElements (G := G) -> x = m)
    (h3 : (NonzeroOrderThreeElements (G := G)).card = 0) :
    Win (∅ : Finset G) := by
  have hm' := (mem_nonzeroOrderTwoElements (G := G) (v := m)).1 hm
  refine initial_win_of_orderTwo_no_other_negation_obstructions
    (G := G) (m := m) hm'.1 hm'.2 ?_ ?_
  · intro x hx0 hxm hneg
    have hx2 : x + x = 0 := add_self_eq_zero_of_neg_eq_self hneg
    have hxmem : x ∈ NonzeroOrderTwoElements (G := G) :=
      (mem_nonzeroOrderTwoElements (G := G) (v := x)).2 ⟨hx2, hx0⟩
    exact hxm (hunique hxmem)
  · intro x hx0 _ hx3
    have hxmem : x ∈ NonzeroOrderThreeElements (G := G) :=
      (mem_nonzeroOrderThreeElements (G := G) (v := x)).2 ⟨hx3, hx0⟩
    have hempty : NonzeroOrderThreeElements (G := G) = ∅ :=
      Finset.card_eq_zero.mp h3
    rw [hempty] at hxmem
    simp at hxmem

end FiniteObstructions

section Tau

/-- Mirror-ready positions for translation by an order-two element. -/
def TauGood (v : G) (S : Finset G) : Prop :=
  Valid S ∧ (S : Set G).Nonempty ∧ TauInvariant v (S : Set G)

omit [Fintype G] [DecidableEq G] in
theorem tauInvariant_empty (v : G) :
    TauInvariant v (∅ : Set G) := by
  intro x
  simp

omit [Fintype G] [DecidableEq G] in
theorem tauInvariant_insert_pair {A : Set G} {v y : G}
    (hv2 : v + v = 0) (hA : TauInvariant v A) :
    TauInvariant v (insert (y + v) (insert y A)) := by
  have hinvol : ∀ t : G, (t + v) + v = t := by
    intro t
    simp [add_assoc, hv2]
  have hforward :
      ∀ {z : G}, z ∈ insert (y + v) (insert y A) ->
        z + v ∈ insert (y + v) (insert y A) := by
    intro z hz
    rcases hz with hzReply | hzRest
    · rw [hzReply, hinvol y]
      exact Or.inr (Or.inl rfl)
    · rcases hzRest with hzY | hzA
      · rw [hzY]
        exact Or.inl rfl
      · exact Or.inr (Or.inr ((hA (x := z)).mp hzA))
  intro z
  constructor
  · exact hforward
  · intro hz
    have h := hforward (z := z + v) hz
    simpa [hinvol z] using h

omit [Fintype G] in
theorem tauGood_step {v : G} (hv2 : v + v = 0) (hv0 : v ≠ 0) :
    ∀ {S : Finset G}, TauGood v S -> ∀ y : G, Move S y ->
      ∃ r : G, Move (insert y S) r ∧ TauGood v (insert r (insert y S)) := by
  intro S hgood y hymove
  rcases hgood with ⟨hvalid, hnonempty, htau⟩
  let r := y + v
  have hylegal : Legal (S : Set G) y := legal_of_move hymove
  have hy_ne_v : y ≠ v := by
    intro hy
    exact tau_self_blocks hnonempty htau (by simpa [hy] using hylegal)
  have hrlegal : Legal (insert y (S : Set G)) r := by
    simpa [r] using tau_mirror_legal
      (G := G) (v := v) (x := y) hv2 hv0 hvalid htau hylegal hy_ne_v
  have hrmove : Move (insert y S) r := by
    exact move_of_legal (S := insert y S) (x := r) (by simpa using hrlegal)
  refine ⟨r, hrmove, ?_⟩
  refine ⟨hrmove.2, ?_, ?_⟩
  · exact ⟨r, by simp⟩
  · intro z
    simpa [r, Finset.mem_coe] using
      (tauInvariant_insert_pair (A := (S : Set G)) (v := v) (y := y) hv2 htau (x := z))

theorem tauGood_isP {v : G} (hv2 : v + v = 0) (hv0 : v ≠ 0)
    {S : Finset G} (hgood : TauGood v S) :
    IsP S :=
  FiniteBuildGame.isP_of_replyStrategy
    (Valid := Valid) (Good := TauGood v)
    (tauGood_step (G := G) hv2 hv0) S hgood

omit [Fintype G] in
theorem tauPairGood_from_empty {v x : G}
    (hv2 : v + v = 0) (hv0 : v ≠ 0)
    (hxmove : Move (∅ : Finset G) x) (hx_ne_v : x ≠ v) :
    ∃ r : G, Move (insert x (∅ : Finset G)) r ∧
      TauGood v (insert r (insert x (∅ : Finset G))) := by
  let r := x + v
  have hxlegal : Legal (((∅ : Finset G) : Set G)) x := legal_of_move hxmove
  have htauEmpty : TauInvariant v ((∅ : Finset G) : Set G) := by
    intro z
    simp
  have hrlegal : Legal (insert x (((∅ : Finset G) : Set G))) r := by
    simpa [r] using tau_mirror_legal
      (G := G) (A := ((∅ : Finset G) : Set G)) (v := v) (x := x)
      hv2 hv0 valid_empty htauEmpty hxlegal hx_ne_v
  have hrmove : Move (insert x (∅ : Finset G)) r := by
    exact move_of_legal (S := insert x (∅ : Finset G)) (x := r) (by simpa using hrlegal)
  refine ⟨r, hrmove, ?_⟩
  refine ⟨hrmove.2, ?_, ?_⟩
  · exact ⟨r, by simp⟩
  · intro z
    simpa [r, Finset.mem_coe] using
      (tauInvariant_insert_pair (A := ((∅ : Finset G) : Set G)) (v := v) (y := x)
        hv2 htauEmpty (x := z))

theorem win_after_nonexception_opening_of_orderTwoMirror {v x : G}
    (hv2 : v + v = 0) (hv0 : v ≠ 0)
    (hxmove : Move (∅ : Finset G) x) (hx_ne_v : x ≠ v) :
    Win (insert x (∅ : Finset G)) := by
  rcases tauPairGood_from_empty (G := G) hv2 hv0 hxmove hx_ne_v with
    ⟨r, hrmove, hgood⟩
  exact FiniteBuildGame.win_of_move_to_isP hrmove (tauGood_isP (G := G) hv2 hv0 hgood)

/--
If every legal opening has a distinct nonzero order-two translation available,
then the empty game is a P-position.

This is the abstract Lean form of the `s₂ >= 2` spare-order-two argument.
-/
theorem initial_isP_of_spare_orderTwo
    (hspare : ∀ x : G, Move (∅ : Finset G) x ->
      ∃ v : G, v + v = 0 ∧ v ≠ 0 ∧ x ≠ v) :
    IsP (∅ : Finset G) := by
  change FiniteBuildGame.IsP Valid (∅ : Finset G)
  rw [FiniteBuildGame.isP_iff_all_children_win]
  intro x hxmove
  rcases hspare x hxmove with ⟨v, hv2, hv0, hxv⟩
  exact win_after_nonexception_opening_of_orderTwoMirror
    (G := G) (v := v) (x := x) hv2 hv0 hxmove hxv

/--
If there are at least two nonzero order-two elements, every opening has a
distinct order-two translation available, so the empty game is P.
-/
theorem initial_isP_of_two_nonzero_orderTwo
    (hcard : 1 < (NonzeroOrderTwoElements (G := G)).card) :
    IsP (∅ : Finset G) := by
  refine initial_isP_of_spare_orderTwo (G := G) ?_
  intro x hxmove
  rcases Finset.one_lt_card.mp hcard with ⟨a, ha, b, hb, hab⟩
  by_cases hxa : x = a
  · have hb' := (mem_nonzeroOrderTwoElements (G := G) (v := b)).1 hb
    refine ⟨b, hb'.1, hb'.2, ?_⟩
    intro hxb
    exact hab (by rw [← hxa, hxb])
  · have ha' := (mem_nonzeroOrderTwoElements (G := G) (v := a)).1 ha
    exact ⟨a, ha'.1, ha'.2, hxa⟩

/--
For any fixed nonzero order-two element `m`, all openings except `m` are
answered by the `tau_m` mirror. Thus the empty game is P exactly when the
singleton `{m}` is N.
-/
theorem initial_isP_iff_orderTwo_child_win {m : G}
    (hm2 : m + m = 0) (hm0 : m ≠ 0) :
    IsP (∅ : Finset G) ↔ Win ({m} : Finset G) := by
  constructor
  · intro hP
    have hmove : Move (∅ : Finset G) m :=
      (empty_move_iff_ne_zero (G := G)).2 hm0
    have hall := (FiniteBuildGame.isP_iff_all_children_win
      (Valid := Valid) (S := (∅ : Finset G))).mp hP
    simpa using hall m hmove
  · intro hmwin
    change FiniteBuildGame.IsP Valid (∅ : Finset G)
    rw [FiniteBuildGame.isP_iff_all_children_win]
    intro x hxmove
    by_cases hxm : x = m
    · subst x
      simpa using hmwin
    · exact win_after_nonexception_opening_of_orderTwoMirror
        (G := G) (v := m) (x := x) hm2 hm0 hxmove hxm

end Tau

section F3

variable {V : Type*} [AddCommGroup V] [Fintype V] [DecidableEq V]

/-- Mirror-ready post-opening positions for the `F_3` affine reflection. -/
def F3Good (o : V) (S : Finset V) : Prop :=
  Valid S ∧ o ∈ S ∧ SigmaInvariant o (S : Set V)

omit [Fintype V] in
theorem f3Good_step
    (hchar3 : ∀ z : V, z + z + z = 0) {o : V} (ho0 : o ≠ 0) :
    ∀ {S : Finset V}, F3Good o S -> ∀ y : V, Move S y ->
      ∃ r : V, Move (insert y S) r ∧ F3Good o (insert r (insert y S)) := by
  intro S hgood y hymove
  rcases hgood with ⟨hvalid, hoS, hsigma⟩
  let r := sigmaF3 o y
  have hylegal : Legal (S : Set V) y := legal_of_move hymove
  have hy_ne_o : y ≠ o := by
    intro hyo
    exact hymove.1 (by simpa [hyo] using hoS)
  have hrlegal : Legal (insert y (S : Set V)) r := by
    simpa [r] using
      f3_affine_mirror_legal (V := V) hchar3 hvalid hoS hsigma hylegal hy_ne_o ho0
  have hrmove : Move (insert y S) r := by
    exact move_of_legal (S := insert y S) (x := r) (by simpa using hrlegal)
  refine ⟨r, hrmove, ?_⟩
  refine ⟨hrmove.2, ?_, ?_⟩
  · simp [hoS]
  · intro z
    simpa [r, Finset.mem_coe] using
      (sigmaInvariant_insert_pair (A := (S : Set V)) (o := o) (y := y) hsigma (x := z))

/-- After any nonzero opening in exponent three, the child is a P-position. -/
theorem f3_postOpening_isP
    (hchar3 : ∀ z : V, z + z + z = 0) {o : V} (ho0 : o ≠ 0) :
    IsP ({o} : Finset V) := by
  have hgood : F3Good o ({o} : Finset V) := by
    have hcenter : sigmaF3 o o = o := by
      have h := char3_add_self_eq_neg hchar3 (-o)
      simpa [sigmaF3, sub_eq_add_neg] using h
    refine ⟨valid_singleton_of_ne_zero (G := V) ho0, by simp, ?_⟩
    intro z
    constructor
    · intro hz
      simp only [Finset.mem_coe, Finset.mem_singleton] at hz
      subst z
      simp [hcenter]
    · intro hz
      simp only [Finset.mem_coe, Finset.mem_singleton] at hz ⊢
      have hz' : sigmaF3 o (sigmaF3 o z) = sigmaF3 o o := by
        rw [hz]
      simpa [sigmaF3_involutive, hcenter] using hz'
  exact FiniteBuildGame.isP_of_replyStrategy
    (Valid := Valid) (Good := F3Good o)
    (f3Good_step (V := V) hchar3 ho0) ({o} : Finset V) hgood

/-- If the finite exponent-three group is nontrivial, the empty sum-free game is N. -/
theorem f3_initial_win [Nontrivial V]
    (hchar3 : ∀ z : V, z + z + z = 0) :
    Win (∅ : Finset V) := by
  obtain ⟨o, ho_ne_zero⟩ := exists_ne (0 : V)
  have ho0 : o ≠ 0 := by
    exact ho_ne_zero
  have hmove : Move (∅ : Finset V) o := by
    exact (empty_move_iff_ne_zero (G := V)).2 ho0
  exact FiniteBuildGame.win_of_move_to_isP hmove (f3_postOpening_isP hchar3 ho0)

end F3

end Game
end Sumfree
