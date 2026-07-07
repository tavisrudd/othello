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
