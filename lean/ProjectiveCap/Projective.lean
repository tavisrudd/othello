import Mathlib.LinearAlgebra.Projectivization.Collinear

/-!
# Caps in a projective space

Let `K` be a field and `V` a `K`-vector space.  The points of the associated
projective space are the elements of `Projectivization K V`, i.e. the nonzero
vectors of `V` up to scalar multiplication.

This module fixes the basic vocabulary used throughout: `Point K V` for a
projective point, the ternary predicate `Collinear K V a b c` saying that the
set `{a, b, c}` lies on a projective line (Mathlib's
`Projectivization.IsCollinear`), and `Cap K V S` saying that the finite set of
points `S` is a *cap*: no three pairwise distinct members of `S` are collinear.
Note that `Collinear` is stated for an unordered triple with no distinctness
assumption, so a repeated point is collinear with anything; the distinctness
hypotheses are carried explicitly by `Cap`.

The lemmas here record that the cap property is inherited by subsets and that
every set of at most two points is a cap.  Nothing in this module refers to a
game; the achievement game played on these caps is in
`ProjectiveCap.ProjectiveCapGame`.
-/

open scoped LinearAlgebra.Projectivization

namespace ProjectiveCap
namespace Projective

variable (K V : Type*) [Field K] [AddCommGroup V] [Module K V]

/-- Points of projective space. -/
abbrev Point := Projectivization K V

/-- Three projective points are collinear if the corresponding set is collinear in mathlib. -/
def Collinear (a b c : Point K V) : Prop :=
  Projectivization.IsCollinear ({a, b, c} : Set (Point K V))

/-- A projective cap: no three distinct selected points are collinear. -/
def Cap (S : Finset (Point K V)) : Prop :=
  ∀ ⦃a b c : Point K V⦄,
    a ∈ S -> b ∈ S -> c ∈ S ->
      a ≠ b -> a ≠ c -> b ≠ c -> ¬ Collinear K V a b c

variable {K V}

theorem cap_mono {S T : Finset (Point K V)} (hST : S ⊆ T) (hT : Cap K V T) :
    Cap K V S := by
  intro a b c ha hb hc hab hac hbc
  exact hT (hST ha) (hST hb) (hST hc) hab hac hbc

theorem cap_of_card_le_two {S : Finset (Point K V)} [DecidableEq (Point K V)]
    (hcard : S.card ≤ 2) : Cap K V S := by
  intro a b c ha hb hc hab hac hbc hcol
  have hsub : ({a, b, c} : Finset (Point K V)) ⊆ S := by
    intro x hx
    simp only [Finset.mem_insert, Finset.mem_singleton] at hx
    rcases hx with rfl | rfl | rfl
    · exact ha
    · exact hb
    · exact hc
  have hthree : ({a, b, c} : Finset (Point K V)).card = 3 := by
    simp [hab, hac, hbc]
  have hle := Finset.card_le_card hsub
  omega

@[simp] theorem cap_empty [DecidableEq (Point K V)] :
    Cap K V (∅ : Finset (Point K V)) :=
  cap_of_card_le_two (K := K) (V := V) (by simp)

@[simp] theorem cap_singleton [DecidableEq (Point K V)] (a : Point K V) :
    Cap K V ({a} : Finset (Point K V)) :=
  cap_of_card_le_two (K := K) (V := V) (by simp)

theorem cap_pair [DecidableEq (Point K V)] (a b : Point K V) :
    Cap K V ({a, b} : Finset (Point K V)) :=
  cap_of_card_le_two (K := K) (V := V) (by
    by_cases h : a = b <;> simp [h])

end Projective
end ProjectiveCap
