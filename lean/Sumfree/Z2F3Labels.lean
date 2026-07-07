import Sumfree.MirrorLemmas
import Mathlib.Data.ZMod.Basic

/-!
Labelled residual formulation for `Z2 x F3^b`.

After the order-two element `m` is played, each `F3` fiber has at most one
chosen element. The residual position is a domain `D` with a `ZMod 2` label.
-/

namespace Sumfree

open Set

variable {V : Type*} [AddCommGroup V] [DecidableEq V]

/-- The labelled Schur condition for the residual `Z2 x V` game. -/
def StarValid (D : Set V) (eps : V -> ZMod 2) : Prop :=
  forall ⦃v w u : V⦄,
    v ∈ D -> w ∈ D -> u ∈ D -> v + w = u ->
      eps v + eps w + eps u = 1

/-- The slot-level mirror sends `y` to `a-y`. -/
def MirrorSlot (a y : V) : V :=
  a - y

/-- The unique slot fixed by `y |-> a-y` in exponent three. It is dead. -/
def DeadSlot (a : V) : V :=
  a + a

/-- The slot-level mirror `v |-> a-v`, with label flip. -/
def LabelMirrorInvariant (a : V) (D : Set V) (eps : V -> ZMod 2) : Prop :=
  forall {v : V}, v ∈ D -> MirrorSlot a v ∈ D ∧ eps (MirrorSlot a v) = 1 - eps v

/-- A fresh labelled move that preserves `StarValid`. -/
def LabelLegal (D : Set V) (eps : V -> ZMod 2) (y : V) (ell : ZMod 2) : Prop :=
  y ∉ D ∧ StarValid (insert y D) (Function.update eps y ell)

theorem LabelLegal.move_ne_of_mem
    {D : Set V} {eps : V -> ZMod 2} {y z : V} {ell : ZMod 2}
    (hy : LabelLegal D eps y ell) (hz : z ∈ D) :
    y ≠ z := by
  intro hyz
  exact hy.1 (by simpa [hyz] using hz)

/-- The anchored base pair `{0 ↦ 1, a ↦ 0}` used by the `Z2 x F3^b` residual proof. -/
def LabelAnchor (a : V) (D : Set V) (eps : V -> ZMod 2) : Prop :=
  0 ∈ D ∧ a ∈ D ∧ eps 0 = 1 ∧ eps a = 0 ∧ a ≠ 0

/-- The opponent's move must avoid the dead mirror slot `2a`. -/
def AvoidsDeadSlot (a y : V) : Prop :=
  y ≠ DeadSlot a

omit [DecidableEq V] in
private lemma add_self_eq_neg_of_char3
    (hchar3 : forall z : V, z + z + z = 0) (z : V) :
    z + z = -z := by
  have h := hchar3 z
  have h' := congrArg (fun t => t + -z) h
  simpa [add_assoc, add_comm, add_left_comm] using h'

omit [DecidableEq V] in
private lemma neg_add_neg_eq_self_of_char3
    (hchar3 : forall z : V, z + z + z = 0) (z : V) :
    -z + -z = z := by
  simpa using add_self_eq_neg_of_char3 hchar3 (-z)

omit [DecidableEq V] in
private lemma zero_of_add_right_eq_self {x v : V}
    (h : x + v = x) : v = 0 := by
  have h' := congrArg (fun t => -x + t) h
  simpa [add_assoc] using h'

omit [DecidableEq V] in
private lemma MirrorSlot_involutive (a y : V) :
    MirrorSlot a (MirrorSlot a y) = y := by
  unfold MirrorSlot
  abel

omit [DecidableEq V] in
private lemma MirrorSlot_add_arg (a y : V) :
    MirrorSlot a y + y = a := by
  unfold MirrorSlot
  abel

omit [DecidableEq V] in
private lemma arg_add_MirrorSlot (a y : V) :
    y + MirrorSlot a y = a := by
  rw [add_comm, MirrorSlot_add_arg]

omit [DecidableEq V] in
private lemma MirrorSlot_add_self
    (hchar3 : forall z : V, z + z + z = 0) (a y : V) :
    MirrorSlot a y + MirrorSlot a y = -a + y := by
  unfold MirrorSlot
  rw [show (a - y) + (a - y) = (a + a) + (-y + -y) by abel]
  rw [add_self_eq_neg_of_char3 hchar3 a,
      neg_add_neg_eq_self_of_char3 hchar3 y]

omit [DecidableEq V] in
private lemma eq_deadSlot_of_MirrorSlot_eq_self
    (hchar3 : forall z : V, z + z + z = 0) {a y : V}
    (h : MirrorSlot a y = y) :
    y = DeadSlot a := by
  unfold MirrorSlot at h
  unfold DeadSlot
  have ha : a = y + y := by
    calc
      a = (a - y) + y := by abel
      _ = y + y := by rw [h]
  have ha_neg : a = -y := by
    simpa [add_self_eq_neg_of_char3 hchar3 y] using ha
  calc
    y = -a := by
      have h' := congrArg Neg.neg ha_neg
      simpa using h'.symm
    _ = a + a := (add_self_eq_neg_of_char3 hchar3 a).symm

omit [DecidableEq V] in
private lemma eq_arg_of_MirrorSlot_eq_zero {a y : V}
    (h : MirrorSlot a y = 0) :
    y = a := by
  unfold MirrorSlot at h
  have h' := congrArg (fun t => t + y) h
  simpa [add_assoc, add_comm, add_left_comm] using h'.symm

omit [DecidableEq V] in
private lemma base_eq_zero_of_MirrorSlot_add_self_eq_arg
    (hchar3 : forall z : V, z + z + z = 0) {a y : V}
    (h : MirrorSlot a y + MirrorSlot a y = y) :
    a = 0 := by
  have h' : -a + y = y := by
    rw [← MirrorSlot_add_self hchar3 a y]
    exact h
  have ha : -a = 0 := by
    have h'' := congrArg (fun t => t + -y) h'
    simpa [add_assoc, add_comm, add_left_comm] using h''
  have hneg := congrArg Neg.neg ha
  simpa using hneg

omit [DecidableEq V] in
private lemma base_eq_zero_of_arg_add_self_eq_MirrorSlot
    (hchar3 : forall z : V, z + z + z = 0) {a y : V}
    (h : y + y = MirrorSlot a y) :
    a = 0 := by
  unfold MirrorSlot at h
  have hy : y + y = -y := add_self_eq_neg_of_char3 hchar3 y
  have h' : -y = a - y := by simpa [hy] using h
  have h'' := congrArg (fun t => t + y) h'
  simpa [sub_eq_add_neg, add_assoc, add_comm, add_left_comm] using h''.symm

omit [DecidableEq V] in
private lemma old_add_MirrorSlot_old_eq_arg_of_MirrorSlot_add_old_eq_old
    {a y d e : V} (h : MirrorSlot a y + d = e) :
    d + MirrorSlot a e = y := by
  rw [← h]
  unfold MirrorSlot
  abel

omit [DecidableEq V] in
private lemma arg_add_old_eq_MirrorSlot_old_of_old_add_old_eq_MirrorSlot
    {a y d e : V} (h : d + e = MirrorSlot a y) :
    y + e = MirrorSlot a d := by
  unfold MirrorSlot at h ⊢
  have he : e = (a - y) - d := by
    calc
      e = -d + (d + e) := by abel
      _ = -d + (a - y) := by rw [h]
      _ = (a - y) - d := by abel
  rw [he]
  abel

omit [DecidableEq V] in
private lemma base_add_old_eq_arg_of_MirrorSlot_add_self_eq_old
    (hchar3 : forall z : V, z + z + z = 0) {a y d : V}
    (h : MirrorSlot a y + MirrorSlot a y = d) :
    a + d = y := by
  have hd : d = -a + y := by
    rw [← h]
    exact MirrorSlot_add_self hchar3 a y
  rw [hd]
  abel

omit [DecidableEq V] in
private lemma old_add_arg_eq_MirrorSlot_old_of_MirrorSlot_add_self_eq_old
    (hchar3 : forall z : V, z + z + z = 0) {a y d : V}
    (h : MirrorSlot a y + MirrorSlot a y = d) :
    d + y = MirrorSlot a d := by
  have hd : d = -a + y := by
    rw [← h]
    exact MirrorSlot_add_self hchar3 a y
  rw [hd]
  unfold MirrorSlot
  calc
    (-a + y) + y = -a + (y + y) := by abel
    _ = -a + -y := by rw [add_self_eq_neg_of_char3 hchar3 y]
    _ = (a + a) + -y := by rw [← add_self_eq_neg_of_char3 hchar3 a]
    _ = a - (-a + y) := by abel

omit [DecidableEq V] in
private lemma old_eq_base_of_arg_add_MirrorSlot_eq_old
    {a y d : V} (h : y + MirrorSlot a y = d) :
    d = a := by
  rw [← h]
  exact arg_add_MirrorSlot a y

omit [DecidableEq V] in
private lemma MirrorSlot_old_add_arg_eq_old_of_MirrorSlot_add_old_eq_arg
    (hchar3 : forall z : V, z + z + z = 0) {a y s : V}
    (h : MirrorSlot a y + s = y) :
    MirrorSlot a s + y = s := by
  unfold MirrorSlot at h ⊢
  have hs : s = y - (a - y) := by
    calc
      s = -(a - y) + ((a - y) + s) := by abel
      _ = -(a - y) + y := by rw [h]
      _ = y - (a - y) := by abel
  rw [hs]
  calc
    a - (y - (a - y)) + y = (a + a) + -y := by abel
    _ = -a + -y := by rw [add_self_eq_neg_of_char3 hchar3 a]
    _ = -a + (y + y) := by rw [← add_self_eq_neg_of_char3 hchar3 y]
    _ = y - (a - y) := by abel

omit [DecidableEq V] in
private lemma base_add_MirrorSlot_old_eq_arg_of_MirrorSlot_add_old_eq_arg
    (hchar3 : forall z : V, z + z + z = 0) {a y s : V}
    (h : MirrorSlot a y + s = y) :
    a + MirrorSlot a s = y := by
  unfold MirrorSlot at h ⊢
  have hs : s = y - (a - y) := by
    calc
      s = -(a - y) + ((a - y) + s) := by abel
      _ = -(a - y) + y := by rw [h]
      _ = y - (a - y) := by abel
  rw [hs]
  calc
    a + (a - (y - (a - y))) = (a + a + a) + -(y + y) := by abel
    _ = 0 + -(y + y) := by rw [hchar3 a]
    _ = y := by
      rw [add_self_eq_neg_of_char3 hchar3 y]
      simp

omit [DecidableEq V] in
private lemma arg_add_arg_eq_MirrorSlot_old_of_arg_add_old_eq_MirrorSlot
    {a y d : V}
    (h : y + d = MirrorSlot a y) :
    y + y = MirrorSlot a d := by
  unfold MirrorSlot at h ⊢
  have hd : d = a - y - y := by
    calc
      d = -y + (y + d) := by abel
      _ = -y + (a - y) := by rw [h]
      _ = a - y - y := by abel
  rw [hd]
  abel

private lemma zmod2_anchor_same (ell : ZMod 2) :
    (1 - ell) + 1 + (1 - ell) = 1 := by
  fin_cases ell <;> decide

private lemma zmod2_anchor_mixed (ell : ZMod 2) :
    (1 - ell) + ell + 0 = 1 := by
  fin_cases ell <;> decide

private lemma zmod2_reflect_left {ed ee ell : ZMod 2}
    : ed + (1 - ee) + ell = 1 ->
      (1 - ell) + ed + ee = 1 := by
  fin_cases ed <;> fin_cases ee <;> fin_cases ell <;> decide

private lemma zmod2_reflect_right {ed ee ell : ZMod 2}
    : ell + ee + (1 - ed) = 1 ->
      ed + ee + (1 - ell) = 1 := by
  fin_cases ed <;> fin_cases ee <;> fin_cases ell <;> decide

private lemma zmod2_double_reply {ed ell : ZMod 2}
    : ed + ell + (1 - ed) = 1 ->
      0 + ed + ell = 1 ->
      (1 - ell) + (1 - ell) + ed = 1 := by
  fin_cases ed <;> fin_cases ell <;> decide

private lemma zmod2_between_reply {es ell : ZMod 2}
    : (1 - es) + ell + es = 1 ->
      0 + (1 - es) + ell = 1 ->
      (1 - ell) + es + ell = 1 := by
  fin_cases es <;> fin_cases ell <;> decide

private lemma zmod2_arg_to_reply {ed ell : ZMod 2}
    : ell + ell + (1 - ed) = 1 ->
      ell + ed + (1 - ell) = 1 := by
  fin_cases ed <;> fin_cases ell <;> decide

/--
The dead slot `2a` is never a legal labelled move from the anchored position.

In exponent three, `DeadSlot a + DeadSlot a = a`; with the anchor label
`eps a = 0`, adding `DeadSlot a` would force an even labelled Schur triple.
-/
theorem deadSlot_not_labelLegal
    {D : Set V} {eps : V -> ZMod 2} {a : V} {ell : ZMod 2}
    (hchar3 : forall z : V, z + z + z = 0)
    (hanchor : LabelAnchor a D eps) :
    ¬ LabelLegal D eps (DeadSlot a) ell := by
  intro hleg
  have ha : a ∈ D := hanchor.2.1
  have hepsa : eps a = 0 := hanchor.2.2.2.1
  have ha0 : a ≠ 0 := hanchor.2.2.2.2
  have hdead_add : DeadSlot a + DeadSlot a = a := by
    unfold DeadSlot
    calc
      (a + a) + (a + a) = (a + a + a) + a := by abel
      _ = 0 + a := by rw [hchar3 a]
      _ = a := by simp
  have hdead_ne_a : DeadSlot a ≠ a := by
    intro h
    have h0 : a = 0 := by
      have h' := congrArg (fun t => t + -a) h
      simpa [DeadSlot, add_assoc, add_comm, add_left_comm] using h'
    exact ha0 h0
  have ha_ne_dead : a ≠ DeadSlot a := fun h => hdead_ne_a h.symm
  have hstar := hleg.2 (by simp) (by simp) (Or.inr ha) hdead_add
  have hstar' : ell + ell + eps a = 1 := by
    simpa [Function.update_of_ne ha_ne_dead] using hstar
  rw [hepsa] at hstar'
  fin_cases ell
  · exact (by decide : ¬ (((0 : ZMod 2) + 0) = 1)) hstar'
  · exact (by decide : ¬ (((1 : ZMod 2) + 1) = 1)) hstar'

theorem avoidsDeadSlot_of_labelLegal
    {D : Set V} {eps : V -> ZMod 2} {a y : V} {ell : ZMod 2}
    (hchar3 : forall z : V, z + z + z = 0)
    (hanchor : LabelAnchor a D eps)
    (hy : LabelLegal D eps y ell) :
    AvoidsDeadSlot a y := by
  intro hydead
  exact deadSlot_not_labelLegal hchar3 hanchor (hydead ▸ hy)

theorem LabelLegal.move_ne_zero_of_anchor
    {D : Set V} {eps : V -> ZMod 2} {a y : V} {ell : ZMod 2}
    (hy : LabelLegal D eps y ell) (hanchor : LabelAnchor a D eps) :
    y ≠ 0 :=
  LabelLegal.move_ne_of_mem hy hanchor.1

theorem LabelLegal.move_ne_anchor_of_anchor
    {D : Set V} {eps : V -> ZMod 2} {a y : V} {ell : ZMod 2}
    (hy : LabelLegal D eps y ell) (hanchor : LabelAnchor a D eps) :
    y ≠ a :=
  LabelLegal.move_ne_of_mem hy hanchor.2.1

/--
The explicit conclusion of pair-completion.

Besides the reply's legality, this records the review-critical side conditions:
the mirror slot is not the just-played slot, not in the old domain, not the
anchor slots `0` and `a`, and the mirror invariant is restored after the reply.
-/
def PairCompleted (a : V) (D : Set V) (eps : V -> ZMod 2) (y : V) (ell : ZMod 2) :
    Prop :=
  let ystar := MirrorSlot a y
  let epsY := Function.update eps y ell
  let D' := insert ystar (insert y D)
  let eps' := Function.update epsY ystar (1 - ell)
  ystar ≠ y ∧
    ystar ∉ D ∧
    ystar ≠ 0 ∧
    ystar ≠ a ∧
    LabelLegal (insert y D) epsY ystar (1 - ell) ∧
    LabelMirrorInvariant a D' eps'

theorem PairCompleted.reply_ne_move
    {a : V} {D : Set V} {eps : V -> ZMod 2} {y : V} {ell : ZMod 2}
    (h : PairCompleted a D eps y ell) :
    MirrorSlot a y ≠ y := by
  dsimp [PairCompleted] at h
  exact h.1

theorem PairCompleted.reply_not_mem_old
    {a : V} {D : Set V} {eps : V -> ZMod 2} {y : V} {ell : ZMod 2}
    (h : PairCompleted a D eps y ell) :
    MirrorSlot a y ∉ D := by
  dsimp [PairCompleted] at h
  exact h.2.1

theorem PairCompleted.reply_ne_zero
    {a : V} {D : Set V} {eps : V -> ZMod 2} {y : V} {ell : ZMod 2}
    (h : PairCompleted a D eps y ell) :
    MirrorSlot a y ≠ 0 := by
  dsimp [PairCompleted] at h
  exact h.2.2.1

theorem PairCompleted.reply_ne_anchor
    {a : V} {D : Set V} {eps : V -> ZMod 2} {y : V} {ell : ZMod 2}
    (h : PairCompleted a D eps y ell) :
    MirrorSlot a y ≠ a := by
  dsimp [PairCompleted] at h
  exact h.2.2.2.1

theorem PairCompleted.legal
    {a : V} {D : Set V} {eps : V -> ZMod 2} {y : V} {ell : ZMod 2}
    (h : PairCompleted a D eps y ell) :
    LabelLegal
      (insert y D)
      (Function.update eps y ell)
      (MirrorSlot a y)
      (1 - ell) := by
  dsimp [PairCompleted] at h
  exact h.2.2.2.2.1

theorem PairCompleted.reply_not_mem_after_move
    {a : V} {D : Set V} {eps : V -> ZMod 2} {y : V} {ell : ZMod 2}
    (h : PairCompleted a D eps y ell) :
    MirrorSlot a y ∉ insert y D :=
  (PairCompleted.legal h).1

theorem PairCompleted.mirrorInvariant
    {a : V} {D : Set V} {eps : V -> ZMod 2} {y : V} {ell : ZMod 2}
    (h : PairCompleted a D eps y ell) :
    LabelMirrorInvariant a
      (insert (MirrorSlot a y) (insert y D))
      (Function.update (Function.update eps y ell) (MirrorSlot a y) (1 - ell)) := by
  dsimp [PairCompleted] at h
  exact h.2.2.2.2.2

theorem PairCompleted.labelAnchor
    {a : V} {D : Set V} {eps : V -> ZMod 2} {y : V} {ell : ZMod 2}
    (hy : LabelLegal D eps y ell)
    (hanchor : LabelAnchor a D eps)
    (h : PairCompleted a D eps y ell) :
    LabelAnchor a
      (insert (MirrorSlot a y) (insert y D))
      (Function.update (Function.update eps y ell) (MirrorSlot a y) (1 - ell)) := by
  rcases hanchor with ⟨h0D, haD, heps0, hepsa, ha0⟩
  have hy0 : y ≠ 0 := by
    exact LabelLegal.move_ne_zero_of_anchor hy ⟨h0D, haD, heps0, hepsa, ha0⟩
  have hya : y ≠ a := by
    exact LabelLegal.move_ne_anchor_of_anchor hy ⟨h0D, haD, heps0, hepsa, ha0⟩
  have hstar0 : MirrorSlot a y ≠ 0 := h.reply_ne_zero
  have hstara : MirrorSlot a y ≠ a := h.reply_ne_anchor
  refine ⟨?_, ?_, ?_, ?_, ha0⟩
  · exact Or.inr (Or.inr h0D)
  · exact Or.inr (Or.inr haD)
  · rw [Function.update_of_ne (Ne.symm hstar0)]
    rw [Function.update_of_ne (Ne.symm hy0)]
    exact heps0
  · rw [Function.update_of_ne (Ne.symm hstara)]
    rw [Function.update_of_ne (Ne.symm hya)]
    exact hepsa

/--
Pair-completion lemma for `Z2 x F3^b`.

Paper source: `2026-07-05-sumfree-zmf3b-theorem.md`, "Pair-completion
Lemma". `hchar3` captures that `V` has exponent three.
-/
theorem pair_completion
    {D : Set V} {eps : V -> ZMod 2} {a y : V} {ell : ZMod 2}
    (hchar3 : forall z : V, z + z + z = 0)
    (hstar : StarValid D eps)
    (hmir : LabelMirrorInvariant a D eps)
    (hanchor : LabelAnchor a D eps)
    (hy : LabelLegal D eps y ell) :
    PairCompleted a D eps y ell := by
  let ystar := MirrorSlot a y
  let epsY := Function.update eps y ell
  let eps' := Function.update epsY ystar (1 - ell)
  have hy_dead : AvoidsDeadSlot a y := avoidsDeadSlot_of_labelLegal hchar3 hanchor hy
  have h0D : 0 ∈ D := hanchor.1
  have haD : a ∈ D := hanchor.2.1
  have heps0 : eps 0 = 1 := hanchor.2.2.1
  have hepsa : eps a = 0 := hanchor.2.2.2.1
  have ha0 : a ≠ 0 := hanchor.2.2.2.2
  have hy_notD : y ∉ D := hy.1
  have hyStar : StarValid (insert y D) epsY := by
    simpa [epsY] using hy.2
  have hreply_ne : ystar ≠ y := by
    intro h
    exact hy_dead (eq_deadSlot_of_MirrorSlot_eq_self hchar3 (by simpa [ystar] using h))
  have hreply_notD : ystar ∉ D := by
    intro hD
    have hyD : y ∈ D := by
      have hm := (hmir hD).1
      simpa [ystar, MirrorSlot_involutive] using hm
    exact hy_notD hyD
  have hreply_ne_zero : ystar ≠ 0 := by
    intro h0
    have hya : y = a := eq_arg_of_MirrorSlot_eq_zero (by simpa [ystar] using h0)
    exact hy_notD (by rw [hya]; exact haD)
  have hreply_ne_anchor : ystar ≠ a := by
    intro hstara
    exact hreply_notD (by simpa [ystar, hstara] using haD)
  have hy_ne_zero : y ≠ 0 := by
    exact LabelLegal.move_ne_zero_of_anchor hy hanchor
  have hDins {t : V} (ht : t ∈ D) : t ∈ insert y D := Or.inr ht
  have hYins {t : V} (ht : t = y) : t ∈ insert y D := by
    rw [ht]
    exact Or.inl rfl
  have hMirrorD {t : V} (ht : t ∈ D) : MirrorSlot a t ∈ D :=
    (hmir ht).1
  have hMirrorLabel {t : V} (ht : t ∈ D) :
      eps (MirrorSlot a t) = 1 - eps t :=
    (hmir ht).2
  have epsY_y : epsY y = ell := by
    dsimp [epsY]
    simp
  have epsY_old {t : V} (ht : t ∈ D) : epsY t = eps t := by
    dsimp [epsY]
    rw [Function.update_of_ne (show t ≠ y from by
      intro ht_eq
      exact hy_notD (by simpa [ht_eq] using ht))]
  have eps'_ystar : Function.update epsY ystar (1 - ell) ystar = 1 - ell := by
    simp
  have eps'_y : Function.update epsY ystar (1 - ell) y = ell := by
    rw [Function.update_of_ne (show y ≠ ystar from by
      intro h
      exact hreply_ne h.symm)]
    exact epsY_y
  have eps'_old {t : V} (ht : t ∈ D) : Function.update epsY ystar (1 - ell) t = eps t := by
    rw [Function.update_of_ne (show t ≠ ystar from by
      intro ht_eq
      exact hreply_notD (by simpa [ht_eq] using ht))]
    exact epsY_old ht
  have eps'_zero : Function.update epsY ystar (1 - ell) 0 = 1 := by
    simpa [heps0] using eps'_old h0D
  have eps'_a : Function.update epsY ystar (1 - ell) a = 0 := by
    simpa [hepsa] using eps'_old haD
  have classifyFinal {t : V} (ht : t ∈ insert ystar (insert y D)) :
      t = ystar ∨ t = y ∨ t ∈ D := by
    rcases ht with ht_star | ht_rest
    · exact Or.inl ht_star
    · rcases ht_rest with ht_y | ht_D
      · exact Or.inr (Or.inl ht_y)
      · exact Or.inr (Or.inr ht_D)
  have hlegal : LabelLegal (insert y D) epsY ystar (1 - ell) := by
    constructor
    · intro hmem
      rcases hmem with h_eq_y | hD
      · exact hreply_ne h_eq_y
      · exact hreply_notD hD
    · intro v w u hv hw hu hsum
      rcases classifyFinal hv with hvStar | hvY | hvD
      · rcases classifyFinal hw with hwStar | hwY | hwD
        · rcases classifyFinal hu with huStar | huY | huD
          · have h : ystar + ystar = ystar := by
              simpa [hvStar, hwStar, huStar] using hsum
            exact (hreply_ne_zero (zero_of_add_right_eq_self h)).elim
          · have h : MirrorSlot a y + MirrorSlot a y = y := by
              simpa [ystar, hvStar, hwStar, huY] using hsum
            exact (ha0 (base_eq_zero_of_MirrorSlot_add_self_eq_arg hchar3 h)).elim
          · have hzz : MirrorSlot a y + MirrorSlot a y = u := by
              simpa [ystar, hvStar, hwStar] using hsum
            have hmateEq : u + y = MirrorSlot a u :=
              old_add_arg_eq_MirrorSlot_old_of_MirrorSlot_add_self_eq_old hchar3 hzz
            have hanchorEq : a + u = y :=
              base_add_old_eq_arg_of_MirrorSlot_add_self_eq_old hchar3 hzz
            have hmate := hyStar (hDins huD) (Or.inl rfl)
              (hDins (hMirrorD huD)) hmateEq
            have hmate' : eps u + ell + (1 - eps u) = 1 := by
              simpa [epsY_old huD, epsY_y, epsY_old (hMirrorD huD),
                hMirrorLabel huD] using hmate
            have hanchor' : 0 + eps u + ell = 1 := by
              have hanc := hyStar (hDins haD) (hDins huD) (Or.inl rfl) hanchorEq
              simpa [epsY_old haD, epsY_old huD, epsY_y, hepsa] using hanc
            have htarget := zmod2_double_reply hmate' hanchor'
            simpa [hvStar, hwStar, eps'_ystar, eps'_old huD,
              add_assoc, add_comm, add_left_comm] using htarget
        · rcases classifyFinal hu with huStar | huY | huD
          · have h : ystar + y = ystar := by
              simpa [hvStar, hwY, huStar] using hsum
            exact (hy_ne_zero (zero_of_add_right_eq_self h)).elim
          · have h : y + ystar = y := by
              simpa [add_comm, hvStar, hwY, huY] using hsum
            exact (hreply_ne_zero (zero_of_add_right_eq_self h)).elim
          · have hzy : y + MirrorSlot a y = u := by
              simpa [ystar, add_comm, hvStar, hwY] using hsum
            have hua : u = a := old_eq_base_of_arg_add_MirrorSlot_eq_old hzy
            simp [hvStar, hwY, eps'_y, eps'_a, hua, add_comm]
        · rcases classifyFinal hu with huStar | huY | huD
          · have h : ystar + w = ystar := by
              simpa [hvStar, huStar] using hsum
            have hw0 : w = 0 := zero_of_add_right_eq_self h
            have htarget := zmod2_anchor_same ell
            simpa [hvStar, huStar, eps'_ystar, eps'_zero, hw0,
              add_assoc, add_comm, add_left_comm] using htarget
          · have hzy : MirrorSlot a y + w = y := by
              simpa [ystar, hvStar, huY] using hsum
            have hmateEq : MirrorSlot a w + y = w :=
              MirrorSlot_old_add_arg_eq_old_of_MirrorSlot_add_old_eq_arg hchar3 hzy
            have hanchorEq : a + MirrorSlot a w = y :=
              base_add_MirrorSlot_old_eq_arg_of_MirrorSlot_add_old_eq_arg hchar3 hzy
            have hmate := hyStar (hDins (hMirrorD hwD)) (Or.inl rfl) (hDins hwD) hmateEq
            have hmate' : (1 - eps w) + ell + eps w = 1 := by
              simpa [epsY_old (hMirrorD hwD), epsY_y, epsY_old hwD,
                hMirrorLabel hwD] using hmate
            have hanchor' : 0 + (1 - eps w) + ell = 1 := by
              have hanc := hyStar (hDins haD) (hDins (hMirrorD hwD)) (Or.inl rfl) hanchorEq
              simpa [epsY_old haD, epsY_old (hMirrorD hwD), epsY_y, hepsa,
                hMirrorLabel hwD] using hanc
            have htarget := zmod2_between_reply hmate' hanchor'
            simpa [hvStar, huY, eps'_ystar, eps'_old hwD, eps'_y,
              add_assoc, add_comm, add_left_comm] using htarget
          · have hze : MirrorSlot a y + w = u := by
              simpa [ystar, hvStar] using hsum
            have hreflect : w + MirrorSlot a u = y :=
              old_add_MirrorSlot_old_eq_arg_of_MirrorSlot_add_old_eq_old hze
            have hleg := hyStar (hDins hwD) (hDins (hMirrorD huD)) (Or.inl rfl) hreflect
            have hleg' : eps w + (1 - eps u) + ell = 1 := by
              simpa [epsY_old hwD, epsY_old (hMirrorD huD), epsY_y,
                hMirrorLabel huD] using hleg
            have htarget := zmod2_reflect_left hleg'
            simpa [hvStar, eps'_ystar, eps'_old hwD, eps'_old huD,
              add_assoc, add_comm, add_left_comm] using htarget
      · rcases classifyFinal hw with hwStar | hwY | hwD
        · rcases classifyFinal hu with huStar | huY | huD
          · have h : ystar + y = ystar := by
              simpa [ystar, add_comm, hvY, hwStar, huStar] using hsum
            exact (hy_ne_zero (zero_of_add_right_eq_self h)).elim
          · have h : y + ystar = y := by
              simpa [hvY, hwStar, huY] using hsum
            exact (hreply_ne_zero (zero_of_add_right_eq_self h)).elim
          · have hzy : y + MirrorSlot a y = u := by
              simpa [ystar, hvY, hwStar] using hsum
            have hua : u = a := old_eq_base_of_arg_add_MirrorSlot_eq_old hzy
            simp [hvY, hwStar, eps'_y, eps'_a, hua, add_comm]
        · rcases classifyFinal hu with huStar | huY | huD
          · have h : y + y = MirrorSlot a y := by
              simpa [ystar, hvY, hwY, huStar] using hsum
            exact (ha0 (base_eq_zero_of_arg_add_self_eq_MirrorSlot hchar3 h)).elim
          · have hleg := hyStar (hYins hvY) (hYins hwY) (hYins huY) hsum
            simpa [hvY, hwY, huY, eps'_y, epsY_y] using hleg
          · have hleg := hyStar (hYins hvY) (hYins hwY) (hDins huD) hsum
            simpa [hvY, hwY, eps'_y, eps'_old huD, epsY_y, epsY_old huD] using hleg
        · rcases classifyFinal hu with huStar | huY | huD
          · have hyd : y + w = MirrorSlot a y := by
              simpa [ystar, hvY, huStar] using hsum
            have hreflect : y + y = MirrorSlot a w :=
              arg_add_arg_eq_MirrorSlot_old_of_arg_add_old_eq_MirrorSlot hyd
            have hleg := hyStar (Or.inl rfl) (Or.inl rfl) (hDins (hMirrorD hwD)) hreflect
            have hleg' : ell + ell + (1 - eps w) = 1 := by
              simpa [epsY_y, epsY_old (hMirrorD hwD), hMirrorLabel hwD] using hleg
            have htarget := zmod2_arg_to_reply hleg'
            simpa [hvY, huStar, eps'_y, eps'_old hwD, eps'_ystar,
              add_assoc, add_comm, add_left_comm] using htarget
          · have hleg := hyStar (hYins hvY) (hDins hwD) (hYins huY) hsum
            simpa [hvY, huY, eps'_y, eps'_old hwD, epsY_y, epsY_old hwD] using hleg
          · have hleg := hyStar (hYins hvY) (hDins hwD) (hDins huD) hsum
            simpa [hvY, eps'_y, eps'_old hwD, eps'_old huD, epsY_y, epsY_old hwD,
              epsY_old huD] using hleg
      · rcases classifyFinal hw with hwStar | hwY | hwD
        · rcases classifyFinal hu with huStar | huY | huD
          · have h : ystar + v = ystar := by
              simpa [ystar, add_comm, hwStar, huStar] using hsum
            have hv0 : v = 0 := zero_of_add_right_eq_self h
            have htarget := zmod2_anchor_same ell
            simpa [hwStar, huStar, eps'_zero, eps'_ystar, hv0,
              add_assoc, add_comm, add_left_comm] using htarget
          · have hzy : MirrorSlot a y + v = y := by
              simpa [ystar, add_comm, hwStar, huY] using hsum
            have hmateEq : MirrorSlot a v + y = v :=
              MirrorSlot_old_add_arg_eq_old_of_MirrorSlot_add_old_eq_arg hchar3 hzy
            have hanchorEq : a + MirrorSlot a v = y :=
              base_add_MirrorSlot_old_eq_arg_of_MirrorSlot_add_old_eq_arg hchar3 hzy
            have hmate := hyStar (hDins (hMirrorD hvD)) (Or.inl rfl) (hDins hvD) hmateEq
            have hmate' : (1 - eps v) + ell + eps v = 1 := by
              simpa [epsY_old (hMirrorD hvD), epsY_y, epsY_old hvD,
                hMirrorLabel hvD] using hmate
            have hanchor' : 0 + (1 - eps v) + ell = 1 := by
              have hanc := hyStar (hDins haD) (hDins (hMirrorD hvD)) (Or.inl rfl) hanchorEq
              simpa [epsY_old haD, epsY_old (hMirrorD hvD), epsY_y, hepsa,
                hMirrorLabel hvD] using hanc
            have htarget := zmod2_between_reply hmate' hanchor'
            simpa [hwStar, huY, eps'_old hvD, eps'_ystar, eps'_y,
              add_assoc, add_comm, add_left_comm] using htarget
          · have hze : MirrorSlot a y + v = u := by
              simpa [ystar, add_comm, hwStar] using hsum
            have hreflect : v + MirrorSlot a u = y :=
              old_add_MirrorSlot_old_eq_arg_of_MirrorSlot_add_old_eq_old hze
            have hleg := hyStar (hDins hvD) (hDins (hMirrorD huD)) (Or.inl rfl) hreflect
            have hleg' : eps v + (1 - eps u) + ell = 1 := by
              simpa [epsY_old hvD, epsY_old (hMirrorD huD), epsY_y,
                hMirrorLabel huD] using hleg
            have htarget := zmod2_reflect_left hleg'
            simpa [hwStar, eps'_old hvD, eps'_ystar, eps'_old huD,
              add_assoc, add_comm, add_left_comm] using htarget
        · rcases classifyFinal hu with huStar | huY | huD
          · have hdy : y + v = MirrorSlot a y := by
              simpa [ystar, add_comm, hwY, huStar] using hsum
            have hreflect : y + y = MirrorSlot a v :=
              arg_add_arg_eq_MirrorSlot_old_of_arg_add_old_eq_MirrorSlot hdy
            have hleg := hyStar (Or.inl rfl) (Or.inl rfl) (hDins (hMirrorD hvD)) hreflect
            have hleg' : ell + ell + (1 - eps v) = 1 := by
              simpa [epsY_y, epsY_old (hMirrorD hvD), hMirrorLabel hvD] using hleg
            have htarget := zmod2_arg_to_reply hleg'
            simpa [hwY, huStar, eps'_old hvD, eps'_y, eps'_ystar,
              add_assoc, add_comm, add_left_comm] using htarget
          · have hleg := hyStar (hDins hvD) (hYins hwY) (hYins huY) hsum
            simpa [hwY, huY, eps'_old hvD, eps'_y, epsY_old hvD, epsY_y] using hleg
          · have hleg := hyStar (hDins hvD) (hYins hwY) (hDins huD) hsum
            simpa [hwY, eps'_old hvD, eps'_y, eps'_old huD, epsY_old hvD, epsY_y,
              epsY_old huD] using hleg
        · rcases classifyFinal hu with huStar | huY | huD
          · have hde : v + w = MirrorSlot a y := by
              simpa [ystar, huStar] using hsum
            have hreflect : y + w = MirrorSlot a v :=
              arg_add_old_eq_MirrorSlot_old_of_old_add_old_eq_MirrorSlot hde
            have hleg := hyStar (Or.inl rfl) (hDins hwD) (hDins (hMirrorD hvD)) hreflect
            have hleg' : ell + eps w + (1 - eps v) = 1 := by
              simpa [epsY_y, epsY_old hwD, epsY_old (hMirrorD hvD),
                hMirrorLabel hvD] using hleg
            have htarget := zmod2_reflect_right hleg'
            simpa [huStar, eps'_old hvD, eps'_old hwD, eps'_ystar,
              add_assoc, add_comm, add_left_comm] using htarget
          · have hleg := hyStar (hDins hvD) (hDins hwD) (hYins huY) hsum
            simpa [huY, eps'_old hvD, eps'_old hwD, eps'_y, epsY_old hvD,
              epsY_old hwD, epsY_y] using hleg
          · have hleg := hstar hvD hwD huD hsum
            simpa [eps'_old hvD, eps'_old hwD, eps'_old huD] using hleg
  have hmirrorFinal : LabelMirrorInvariant a (insert ystar (insert y D)) eps' := by
    intro v hv
    rcases classifyFinal hv with hvStar | hvY | hvD
    · constructor
      · rw [hvStar]
        have hm : MirrorSlot a ystar = y := by
          simpa [ystar] using MirrorSlot_involutive a y
        rw [hm]
        exact Or.inr (Or.inl rfl)
      · simp [eps', hvStar, ystar, MirrorSlot_involutive, eps'_y]
    · constructor
      · rw [hvY]
        exact Or.inl rfl
      · simp [eps', hvY, ystar, eps'_y]
    · have hmvD : MirrorSlot a v ∈ D := hMirrorD hvD
      constructor
      · exact Or.inr (Or.inr hmvD)
      · have hlabel := hMirrorLabel hvD
        simpa [eps', eps'_old hmvD, eps'_old hvD] using hlabel
  dsimp [PairCompleted]
  exact ⟨hreply_ne, hreply_notD, hreply_ne_zero, hreply_ne_anchor, hlegal, hmirrorFinal⟩

end Sumfree
