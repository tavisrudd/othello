import Sumfree.Game
import Sumfree.Z2F3Bridge

/-!
# Finite game bridge for `ZMod 2 × F_3^b`

This file connects the labelled pair-completion theorem to the shared finite
normal-play game semantics.  The first target is the anchored post-move
position `{(1,0), (0,a)}`.
-/

namespace Sumfree
namespace Z2F3Game

open Set

variable {V : Type*} [AddCommGroup V] [Fintype V] [DecidableEq V]

/-- The finite sum-free game on `ZMod 2 × V`. -/
abbrev Valid (S : Finset (Z2V V)) : Prop :=
  Game.Valid S

abbrev Move (S : Finset (Z2V V)) (x : Z2V V) : Prop :=
  Game.Move S x

abbrev Win (S : Finset (Z2V V)) : Prop :=
  Game.Win S

abbrev IsP (S : Finset (Z2V V)) : Prop :=
  Game.IsP S

/-- Positions encoded by a labelled residual state with the anchored sigma invariant. -/
def EncodedGood (a : V) (S : Finset (Z2V V)) : Prop :=
  ∃ D : Set V, ∃ eps : V -> ZMod 2,
    (S : Set (Z2V V)) = LabelledSet D eps ∧
      StarValid D eps ∧
      LabelMirrorInvariant a D eps ∧
      LabelAnchor a D eps

omit [Fintype V] [DecidableEq V] in
theorem valid_of_encodedGood {a : V} {S : Finset (Z2V V)}
    (hgood : EncodedGood a S) :
    Valid S := by
  rcases hgood with ⟨D, eps, hS, hstar, _, _⟩
  intro x y z hx hy hz hsum
  exact sumFree_labelledSet_of_starValid hstar
    (by simpa [hS] using hx)
    (by simpa [hS] using hy)
    (by simpa [hS] using hz)
    hsum

omit [Fintype V] in
theorem encodedGood_step
    (hchar3 : ∀ z : V, z + z + z = 0) {a : V} :
    ∀ {S : Finset (Z2V V)}, EncodedGood a S -> ∀ x : Z2V V, Move S x ->
      ∃ r : Z2V V, Move (insert x S) r ∧ EncodedGood a (insert r (insert x S)) := by
  intro S hgood x hxmove
  rcases hgood with ⟨D, eps, hS, hstar, hmir, hanchor⟩
  let y : V := x.2
  let ell : ZMod 2 := x.1
  let r : Z2V V := LabelledPoint (MirrorSlot a y) (1 - ell)
  have hxlegalS : Legal (S : Set (Z2V V)) x := Game.legal_of_move hxmove
  have hxlabel : LabelledPoint y ell = x := by
    cases x
    rfl
  have hxlegalEncoded : Legal (LabelledSet D eps) (LabelledPoint y ell) := by
    rw [← hS]
    simpa [y, ell, hxlabel] using hxlegalS
  have hyLabel : LabelLegal D eps y ell :=
    labelLegal_of_legal_labelledPoint_of_anchor hanchor hxlegalEncoded
  have hpair : PairCompleted a D eps y ell :=
    pair_completion hchar3 hstar hmir hanchor hyLabel
  have hrlegalLabel :
      Legal
        (insert (LabelledPoint y ell) (LabelledSet D eps))
        (LabelledPoint (MirrorSlot a y) (1 - ell)) :=
    legal_group_reply_of_pairCompleted hyLabel hpair
  have hrlegalActual : Legal ((insert x S : Finset (Z2V V)) : Set (Z2V V)) r := by
    simpa [r, hxlabel, hS] using hrlegalLabel
  have hrmove : Move (insert x S) r :=
    Game.move_of_legal (S := insert x S) (x := r) hrlegalActual
  let epsY : V -> ZMod 2 := Function.update eps y ell
  let D' : Set V := insert (MirrorSlot a y) (insert y D)
  let eps' : V -> ZMod 2 := Function.update epsY (MirrorSlot a y) (1 - ell)
  have hfirst :
      LabelledSet (insert y D) epsY =
        insert (LabelledPoint y ell) (LabelledSet D eps) := by
    simpa [epsY] using labelledSet_insert_eq hyLabel.1
  have hsecond :
      LabelledSet D' eps' =
        insert r (LabelledSet (insert y D) epsY) := by
    simpa [D', eps', epsY, r] using labelledSet_insert_eq (PairCompleted.legal hpair).1
  have hlabelNew : LabelledSet D' eps' = insert r (insert x (S : Set (Z2V V))) := by
    rw [hsecond, hfirst, ← hS]
    simp [hxlabel]
  have hnewSet :
      ((insert r (insert x S) : Finset (Z2V V)) : Set (Z2V V)) = LabelledSet D' eps' := by
    rw [hlabelNew]
    ext z
    simp
  refine ⟨r, hrmove, ?_⟩
  refine ⟨D', eps', hnewSet, ?_, ?_, ?_⟩
  · exact (PairCompleted.legal hpair).2
  · exact PairCompleted.mirrorInvariant hpair
  · exact PairCompleted.labelAnchor hyLabel hanchor hpair

theorem encodedGood_isP
    (hchar3 : ∀ z : V, z + z + z = 0) {a : V} {S : Finset (Z2V V)}
    (hgood : EncodedGood a S) :
    IsP S :=
  FiniteBuildGame.isP_of_replyStrategy
    (Valid := Game.Valid) (Good := EncodedGood a)
    (encodedGood_step (V := V) hchar3) S hgood

omit [Fintype V] in
/-- The anchored base pair `{(1,0), (0,a)}` satisfies the encoded invariant. -/
theorem basePair_encodedGood {a : V} (ha0 : a ≠ 0) :
    EncodedGood a
      ({LabelledPoint 0 1, LabelledPoint a 0} : Finset (Z2V V)) := by
  refine ⟨BaseDomain a, BaseLabel a, ?_, baseStarValid ha0,
    baseLabelMirrorInvariant ha0, baseLabelAnchor ha0⟩
  ext x
  constructor
  · intro hx
    simp only [Finset.mem_coe, Finset.mem_insert, Finset.mem_singleton] at hx
    exact (baseLabelledSet_mem_iff ha0).2 hx
  · intro hx
    simpa [Finset.mem_coe] using (baseLabelledSet_mem_iff ha0).1 hx

/-- After the anchor pair has been played, the residual position is P. -/
theorem basePair_isP
    (hchar3 : ∀ z : V, z + z + z = 0) {a : V} (ha0 : a ≠ 0) :
    IsP ({LabelledPoint 0 1, LabelledPoint a 0} : Finset (Z2V V)) :=
  encodedGood_isP hchar3 (basePair_encodedGood ha0)

omit [Fintype V] in
/-- From the order-two opening `(1,0)`, playing `(0,a)` reaches the anchored P-position. -/
theorem anchor_move_from_orderTwo {a : V} (ha0 : a ≠ 0) :
    Move ({LabelledPoint 0 1} : Finset (Z2V V)) (LabelledPoint a 0) := by
  refine ⟨?_, ?_⟩
  · simp [LabelledPoint]
  · have hvalid : Valid ({LabelledPoint 0 1, LabelledPoint a 0} : Finset (Z2V V)) :=
      valid_of_encodedGood (basePair_encodedGood ha0)
    have hpair :
        ({LabelledPoint a 0, LabelledPoint 0 1} : Finset (Z2V V)) =
          ({LabelledPoint 0 1, LabelledPoint a 0} : Finset (Z2V V)) := by
      ext z
      simp [or_comm]
    simpa [hpair] using hvalid

/-- The order-two singleton is an N-position in `ZMod 2 × V`. -/
theorem afterOrderTwo_win
    (hchar3 : ∀ z : V, z + z + z = 0) {a : V} (ha0 : a ≠ 0) :
    Win ({LabelledPoint 0 1} : Finset (Z2V V)) := by
  have hpair :
      ({LabelledPoint a 0, LabelledPoint 0 1} : Finset (Z2V V)) =
        ({LabelledPoint 0 1, LabelledPoint a 0} : Finset (Z2V V)) := by
    ext z
    simp [or_comm]
  have hP :
      FiniteBuildGame.IsP Game.Valid
        ({LabelledPoint a 0, LabelledPoint 0 1} : Finset (Z2V V)) := by
    simpa [hpair] using basePair_isP hchar3 ha0
  exact FiniteBuildGame.win_of_move_to_isP
    (anchor_move_from_orderTwo ha0)
    hP

/-- Full `ZMod 2 × F_3^b` root theorem: the empty position is P. -/
theorem initial_isP [Nontrivial V]
    (hchar3 : ∀ z : V, z + z + z = 0) :
    IsP (∅ : Finset (Z2V V)) := by
  obtain ⟨a, ha_ne_zero⟩ := exists_ne (0 : V)
  have ha0 : a ≠ 0 := ha_ne_zero
  let m : Z2V V := LabelledPoint 0 1
  have hm2 : m + m = 0 := by
    ext
    · have h : (1 : ZMod 2) + 1 = 0 := by decide
      simpa [m, LabelledPoint] using h
    · simp [m, LabelledPoint]
  have hm0 : m ≠ 0 := by
    intro hm
    have hfst : (1 : ZMod 2) = 0 := by
      simpa [m, LabelledPoint] using congrArg Prod.fst hm
    exact (by decide : (1 : ZMod 2) ≠ 0) hfst
  change FiniteBuildGame.IsP Game.Valid (∅ : Finset (Z2V V))
  rw [FiniteBuildGame.isP_iff_all_children_win]
  intro x hxmove
  by_cases hx_m : x = m
  · subst x
    simpa [m] using afterOrderTwo_win hchar3 ha0
  · exact Game.win_after_nonexception_opening_of_orderTwoMirror
      (G := Z2V V) (v := m) (x := x) hm2 hm0 hxmove hx_m

end Z2F3Game
end Sumfree
