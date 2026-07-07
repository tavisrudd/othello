import Sumfree.Z2F3Labels

/-!
# Bridge from labelled residual positions to the actual `ZMod 2 x V` game

`Sumfree.Z2F3Labels` proves the local labelled pair-completion lemma.  This
file checks that the labelled objects really encode ordinary sum-free positions
and ordinary legal moves in the product group.
-/

namespace Sumfree

open Set

variable {V : Type*} [AddCommGroup V] [DecidableEq V]

/-- The actual game group in the labelled residual model. -/
abbrev Z2V (V : Type*) := ZMod 2 × V

/-- The actual group element encoded by a slot and a `ZMod 2` label. -/
def LabelledPoint (v : V) (ell : ZMod 2) : Z2V V :=
  (ell, v)

/-- The actual selected set encoded by a labelled residual domain. -/
def LabelledSet (D : Set V) (eps : V -> ZMod 2) : Set (Z2V V) :=
  {x | x.2 ∈ D ∧ x.1 = eps x.2}

omit [AddCommGroup V] [DecidableEq V] in
theorem labelledPoint_mem_iff
    {D : Set V} {eps : V -> ZMod 2} {v : V} {ell : ZMod 2} :
    LabelledPoint v ell ∈ LabelledSet D eps ↔ v ∈ D ∧ ell = eps v := by
  rfl

omit [AddCommGroup V] [DecidableEq V] in
/-- The labelled encoding has at most one selected point over each `V` slot. -/
theorem labelledSet_slot_unique
    {D : Set V} {eps : V -> ZMod 2} {x y : Z2V V}
    (hx : x ∈ LabelledSet D eps) (hy : y ∈ LabelledSet D eps)
    (hslot : x.2 = y.2) :
    x = y := by
  rcases hx with ⟨_, hxLabel⟩
  rcases hy with ⟨_, hyLabel⟩
  ext
  · calc
      x.1 = eps x.2 := hxLabel
      _ = eps y.2 := by rw [hslot]
      _ = y.1 := hyLabel.symm
  · exact hslot

private lemma zmod2_add_self (x : ZMod 2) : x + x = 0 := by
  fin_cases x <;> decide

private lemma zmod2_eq_zero_or_one (x : ZMod 2) : x = 0 ∨ x = 1 := by
  fin_cases x
  · exact Or.inl rfl
  · exact Or.inr rfl

private lemma zmod2_add_one_eq_of_ne {a b : ZMod 2} (h : a ≠ b) :
    a + 1 = b := by
  rcases zmod2_eq_zero_or_one a with rfl | rfl <;>
    rcases zmod2_eq_zero_or_one b with rfl | rfl
  · exact (h rfl).elim
  · decide
  · decide
  · exact (h rfl).elim

private lemma zmod2_sum_eq_zero_of_add_eq {a b c : ZMod 2}
    (h : a + b = c) :
    a + b + c = 0 := by
  rw [h]
  exact zmod2_add_self c

private lemma zmod2_add_eq_of_sum_eq_zero {a b c : ZMod 2}
    (h : a + b + c = 0) :
    a + b = c := by
  have h' := congrArg (fun t => t + c) h
  simpa [add_assoc, add_comm, add_left_comm, zmod2_add_self] using h'

omit [DecidableEq V] in
/-- The labelled `(★)` condition implies ordinary sum-freeness of the encoded set. -/
theorem sumFree_labelledSet_of_starValid
    {D : Set V} {eps : V -> ZMod 2}
    (hstar : StarValid D eps) :
    SumFree (LabelledSet D eps) := by
  intro x y z hx hy hz hsum
  rcases hx with ⟨hxD, hxLabel⟩
  rcases hy with ⟨hyD, hyLabel⟩
  rcases hz with ⟨hzD, hzLabel⟩
  have hslot : x.2 + y.2 = z.2 := by
    exact congrArg Prod.snd hsum
  have hlabelEq : x.1 + y.1 = z.1 := by
    exact congrArg Prod.fst hsum
  have hzero : eps x.2 + eps y.2 + eps z.2 = 0 := by
    rw [← hxLabel, ← hyLabel, ← hzLabel]
    exact zmod2_sum_eq_zero_of_add_eq hlabelEq
  have hone := hstar hxD hyD hzD hslot
  rw [hzero] at hone
  exact (by decide : ¬ ((0 : ZMod 2) = 1)) hone

omit [DecidableEq V] in
/-- Ordinary sum-freeness of the encoded set implies the labelled `(★)` condition. -/
theorem starValid_of_sumFree_labelledSet
    {D : Set V} {eps : V -> ZMod 2}
    (hfree : SumFree (LabelledSet D eps)) :
    StarValid D eps := by
  intro v w u hv hw hu hsum
  by_contra hne
  have hzero : eps v + eps w + eps u = 0 := by
    rcases zmod2_eq_zero_or_one (eps v + eps w + eps u) with h | h
    · exact h
    · exact (hne h).elim
  have hlabelEq : eps v + eps w = eps u :=
    zmod2_add_eq_of_sum_eq_zero hzero
  exact hfree
    (a := LabelledPoint v (eps v))
    (b := LabelledPoint w (eps w))
    (c := LabelledPoint u (eps u))
    ⟨hv, rfl⟩
    ⟨hw, rfl⟩
    ⟨hu, rfl⟩
    (by
      ext <;> simp [LabelledPoint, hsum, hlabelEq])

omit [DecidableEq V] in
/-- The residual `(★)` condition is exactly ordinary sum-freeness after encoding. -/
theorem starValid_iff_sumFree_labelledSet
    {D : Set V} {eps : V -> ZMod 2} :
    StarValid D eps ↔ SumFree (LabelledSet D eps) :=
  ⟨sumFree_labelledSet_of_starValid, starValid_of_sumFree_labelledSet⟩

omit [AddCommGroup V] in
theorem labelledSet_insert_eq
    {D : Set V} {eps : V -> ZMod 2} {y : V} {ell : ZMod 2}
    (hy : y ∉ D) :
    LabelledSet (insert y D) (Function.update eps y ell) =
      insert (LabelledPoint y ell) (LabelledSet D eps) := by
  ext x
  constructor
  · intro hx
    rcases hx with ⟨hxD, hxLabel⟩
    rcases hxD with hxY | hxOld
    · left
      ext <;> simp [LabelledPoint, hxY, hxLabel]
    · right
      have hne : x.2 ≠ y := by
        intro hxy
        exact hy (by simpa [hxy] using hxOld)
      rw [Function.update_of_ne hne] at hxLabel
      exact ⟨hxOld, hxLabel⟩
  · intro hx
    rcases hx with hxNew | hxOld
    · subst x
      exact ⟨Or.inl rfl, by simp [LabelledPoint]⟩
    · rcases hxOld with ⟨hxD, hxLabel⟩
      have hne : x.2 ≠ y := by
        intro hxy
        exact hy (by simpa [hxy] using hxD)
      exact ⟨Or.inr hxD, by simpa [Function.update_of_ne hne] using hxLabel⟩

/-- The residual base domain after the first player opens at `(1,0)` and the
second player chooses the paired anchor `(0,a)`. -/
def BaseDomain (a : V) : Set V :=
  {v | v = 0 ∨ v = a}

/-- The residual base labels for `{0 ↦ 1, a ↦ 0}`. -/
def BaseLabel (_a : V) (v : V) : ZMod 2 :=
  if v = 0 then 1 else 0

theorem baseLabel_zero (a : V) :
    BaseLabel a 0 = 1 := by
  simp [BaseLabel]

theorem baseLabel_self {a : V} (ha0 : a ≠ 0) :
    BaseLabel a a = 0 := by
  simp [BaseLabel, ha0]

theorem baseStarValid {a : V} (ha0 : a ≠ 0) :
    StarValid (BaseDomain a) (BaseLabel a) := by
  intro v w u hv hw hu hsum
  rcases hv with hv0 | hvA <;>
    rcases hw with hw0 | hwA <;>
    rcases hu with hu0 | huA
  · simpa [BaseLabel, hv0, hw0, hu0] using
      (by decide : (1 : ZMod 2) + 1 = 0)
  · have h0 : a = 0 := by
      simpa [hv0, hw0, huA] using hsum.symm
    exact (ha0 h0).elim
  · have h0 : a = 0 := by
      simpa [hv0, hwA, hu0] using hsum
    exact (ha0 h0).elim
  · simp [BaseLabel, hv0, hwA, huA, ha0]
  · have h0 : a = 0 := by
      simpa [hvA, hw0, hu0] using hsum
    exact (ha0 h0).elim
  · simp [BaseLabel, hvA, hw0, huA, ha0]
  · simp [BaseLabel, hvA, hwA, hu0, ha0]
  · have haa : a + a = a := by
      simpa [hvA, hwA, huA] using hsum
    have h0 : a = 0 := by
      have h' := congrArg (fun t => t + -a) haa
      simpa [add_assoc, add_comm, add_left_comm] using h'
    exact (ha0 h0).elim

theorem baseLabelAnchor {a : V} (ha0 : a ≠ 0) :
    LabelAnchor a (BaseDomain a) (BaseLabel a) := by
  exact ⟨Or.inl rfl, Or.inr rfl, by simp [BaseLabel],
    by simp [BaseLabel, ha0], ha0⟩

theorem baseLabelMirrorInvariant {a : V} (ha0 : a ≠ 0) :
    LabelMirrorInvariant a (BaseDomain a) (BaseLabel a) := by
  intro v hv
  rcases hv with rfl | rfl
  · constructor
    · exact Or.inr (by simp [MirrorSlot])
    · simp [MirrorSlot, BaseLabel, ha0]
  · constructor
    · exact Or.inl (by simp [MirrorSlot])
    · simp [MirrorSlot, BaseLabel, ha0]

theorem baseLabelledSet_mem_iff {a : V} (ha0 : a ≠ 0) {x : Z2V V} :
    x ∈ LabelledSet (BaseDomain a) (BaseLabel a) ↔
      x = LabelledPoint 0 1 ∨ x = LabelledPoint a 0 := by
  constructor
  · intro hx
    rcases hx with ⟨hxSlot, hxLabel⟩
    rcases hxSlot with hzero | ha
    · left
      ext
      · calc
          x.1 = BaseLabel a x.2 := hxLabel
          _ = 1 := by simp [BaseLabel, hzero]
      · exact hzero
    · right
      ext
      · calc
          x.1 = BaseLabel a x.2 := hxLabel
          _ = 0 := by simp [BaseLabel, ha, ha0]
      · exact ha
  · intro hx
    rcases hx with rfl | rfl
    · exact ⟨Or.inl rfl, by simp [LabelledPoint, BaseLabel]⟩
    · exact ⟨Or.inr rfl, by simp [LabelledPoint, BaseLabel, ha0]⟩

/--
An ordinary legal move in the encoded group is necessarily a fresh labelled
slot move.  The anchor `(1,0)` rules out playing the opposite label in an
already occupied slot: the new point plus `(1,0)` would equal the old point in
that slot.
-/
theorem labelLegal_of_legal_labelledPoint
    {D : Set V} {eps : V -> ZMod 2} {y : V} {ell : ZMod 2}
    (hzero : 0 ∈ D) (hzeroLabel : eps 0 = 1)
    (hlegal : Legal (LabelledSet D eps) (LabelledPoint y ell)) :
    LabelLegal D eps y ell := by
  rcases hlegal with ⟨hnotMem, hfree⟩
  have hyFresh : y ∉ D := by
    intro hyD
    by_cases hlabel : ell = eps y
    · exact hnotMem ⟨hyD, hlabel⟩
    · have hlabelAdd : ell + eps 0 = eps y := by
        rw [hzeroLabel]
        exact zmod2_add_one_eq_of_ne hlabel
      have hsum :
          LabelledPoint y ell + LabelledPoint 0 (eps 0) =
            LabelledPoint y (eps y) := by
        ext <;> simp [LabelledPoint, hlabelAdd]
      exact hfree
        (a := LabelledPoint y ell)
        (b := LabelledPoint 0 (eps 0))
        (c := LabelledPoint y (eps y))
        (Or.inl rfl)
        (Or.inr ⟨hzero, rfl⟩)
        (Or.inr ⟨hyD, rfl⟩)
        hsum
  exact ⟨hyFresh,
    starValid_of_sumFree_labelledSet
      (by simpa [labelledSet_insert_eq hyFresh] using hfree)⟩

theorem labelLegal_of_legal_labelledPoint_of_anchor
    {D : Set V} {eps : V -> ZMod 2} {a y : V} {ell : ZMod 2}
    (hanchor : LabelAnchor a D eps)
    (hlegal : Legal (LabelledSet D eps) (LabelledPoint y ell)) :
    LabelLegal D eps y ell :=
  labelLegal_of_legal_labelledPoint hanchor.1 hanchor.2.2.1 hlegal

/-- A labelled legal move is an ordinary legal move in the encoded product group. -/
theorem legal_labelledPoint_of_labelLegal
    {D : Set V} {eps : V -> ZMod 2} {y : V} {ell : ZMod 2}
    (hy : LabelLegal D eps y ell) :
    Legal (LabelledSet D eps) (LabelledPoint y ell) := by
  constructor
  · intro hmem
    exact hy.1 hmem.1
  · have hfree :=
      sumFree_labelledSet_of_starValid
        (D := insert y D) (eps := Function.update eps y ell) hy.2
    simpa [labelledSet_insert_eq hy.1] using hfree

/--
The completed labelled mirror reply is an ordinary legal reply after encoding.

This is the bridge from `pair_completion` to actual legal play in `ZMod 2 x V`.
-/
theorem legal_group_reply_of_pairCompleted
    {D : Set V} {eps : V -> ZMod 2} {a y : V} {ell : ZMod 2}
    (hy : LabelLegal D eps y ell)
    (hpair : PairCompleted a D eps y ell) :
    Legal
      (insert (LabelledPoint y ell) (LabelledSet D eps))
      (LabelledPoint (MirrorSlot a y) (1 - ell)) := by
  have hlegal := legal_labelledPoint_of_labelLegal (PairCompleted.legal hpair)
  simpa [labelledSet_insert_eq hy.1] using hlegal

/--
The pair-completion theorem produces an ordinary legal group reply, not just a
labelled one.
-/
theorem legal_group_reply_of_pair_completion
    {D : Set V} {eps : V -> ZMod 2} {a y : V} {ell : ZMod 2}
    (hchar3 : forall z : V, z + z + z = 0)
    (hstar : StarValid D eps)
    (hmir : LabelMirrorInvariant a D eps)
    (hanchor : LabelAnchor a D eps)
    (hy : LabelLegal D eps y ell) :
    Legal
      (insert (LabelledPoint y ell) (LabelledSet D eps))
      (LabelledPoint (MirrorSlot a y) (1 - ell)) :=
  legal_group_reply_of_pairCompleted hy
    (pair_completion hchar3 hstar hmir hanchor hy)

end Sumfree
