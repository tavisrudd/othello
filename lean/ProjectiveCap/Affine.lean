import ProjectiveCap.BuildGame
import Mathlib.Algebra.Module.Basic

/-!
# Affine cap achievement game

This file formalizes the affine cap-set game from the notes.  A position is a
finite affine cap in a vector space over a field; a move adds one point while
preserving the cap condition; normal play is supplied by `FiniteBuildGame.Win`.
-/

namespace ProjectiveCap
namespace Affine

variable (K V : Type*) [Field K] [AddCommGroup V] [Module K V]

/-- `a`, `b`, `c` are affine-collinear when `c` lies on the affine line through `a,b`. -/
def Collinear (a b c : V) : Prop :=
  ∃ t : K, c - a = t • (b - a)

/-- A finite affine cap: no three distinct selected points are collinear. -/
def Cap (S : Finset V) : Prop :=
  ∀ ⦃a b c : V⦄,
    a ∈ S -> b ∈ S -> c ∈ S ->
      a ≠ b -> a ≠ c -> b ≠ c -> ¬ Collinear K V a b c

variable {K V}

theorem cap_mono {S T : Finset V} (hST : S ⊆ T) (hT : Cap K V T) :
    Cap K V S := by
  intro a b c ha hb hc hab hac hbc
  exact hT (hST ha) (hST hb) (hST hc) hab hac hbc

theorem cap_of_card_le_two {S : Finset V} [DecidableEq V] (hcard : S.card ≤ 2) :
    Cap K V S := by
  intro a b c ha hb hc hab hac hbc hcol
  have hsub : ({a, b, c} : Finset V) ⊆ S := by
    intro x hx
    simp only [Finset.mem_insert, Finset.mem_singleton] at hx
    rcases hx with rfl | rfl | rfl
    · exact ha
    · exact hb
    · exact hc
  have hthree : ({a, b, c} : Finset V).card = 3 := by
    simp [hab, hac, hbc]
  have hle := Finset.card_le_card hsub
  omega

@[simp] theorem cap_empty [DecidableEq V] : Cap K V (∅ : Finset V) :=
  cap_of_card_le_two (K := K) (V := V) (by simp)

@[simp] theorem cap_singleton [DecidableEq V] (a : V) : Cap K V ({a} : Finset V) :=
  cap_of_card_le_two (K := K) (V := V) (by simp)

theorem cap_pair [DecidableEq V] (a b : V) : Cap K V ({a, b} : Finset V) :=
  cap_of_card_le_two (K := K) (V := V) (by
    by_cases h : a = b <;> simp [h])

section Game

variable [Fintype V] [DecidableEq V]

/-- Legal affine cap-game extensions. -/
noncomputable def LegalExtensions (S : Finset V) : Finset V :=
  FiniteBuildGame.LegalExtensions (Cap K V) S

theorem mem_legalExtensions {S : Finset V} {x : V} :
    x ∈ LegalExtensions (K := K) (V := V) S ↔
      x ∉ S ∧ Cap K V (insert x S) :=
  FiniteBuildGame.mem_legalExtensions

/-- Normal-play affine cap-game win predicate. -/
abbrev Win (S : Finset V) : Prop :=
  FiniteBuildGame.Win (Cap K V) S

/-- Target statement for the affine theorem proved in prose: the empty affine game is P. -/
def InitialPStatement : Prop :=
  FiniteBuildGame.IsP (Cap K V) (∅ : Finset V)

end Game

section ClassicalCapSet

variable {W : Type*} [AddCommGroup W]

/-- Three-term arithmetic progression with `b` as midpoint. -/
def ThreeAP (a b c : W) : Prop :=
  a + c = b + b

/-- Classical cap-set predicate, useful over vector spaces of characteristic `3`. -/
def APFree (S : Finset W) : Prop :=
  ∀ ⦃a b c : W⦄,
    a ∈ S -> b ∈ S -> c ∈ S ->
      a ≠ b -> a ≠ c -> b ≠ c -> ¬ ThreeAP a b c

end ClassicalCapSet

end Affine
end ProjectiveCap
