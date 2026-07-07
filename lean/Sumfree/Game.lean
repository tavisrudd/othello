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
