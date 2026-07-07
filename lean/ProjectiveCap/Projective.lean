import CapGame.BuildGame
import Mathlib.LinearAlgebra.Projectivization.Collinear

/-!
# Projective cap achievement game

This is the projective analogue of `CapGame.Affine`: positions are finite
sets of points of projective space with no three selected points on a projective
line, and moves add one point while preserving that predicate.
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

section Game

variable [Fintype (Point K V)] [DecidableEq (Point K V)]

/-- Legal projective cap-game extensions. -/
noncomputable def LegalExtensions (S : Finset (Point K V)) : Finset (Point K V) :=
  FiniteBuildGame.LegalExtensions (Cap K V) S

theorem mem_legalExtensions {S : Finset (Point K V)} {x : Point K V} :
    x ∈ LegalExtensions (K := K) (V := V) S ↔
      x ∉ S ∧ Cap K V (insert x S) :=
  FiniteBuildGame.mem_legalExtensions

/-- Normal-play projective cap-game win predicate. -/
abbrev Win (S : Finset (Point K V)) : Prop :=
  FiniteBuildGame.Win (Cap K V) S

/-- Target statement for the projective conjecture: the empty projective game is P. -/
def InitialPStatement : Prop :=
  FiniteBuildGame.IsP (Cap K V) (∅ : Finset (Point K V))

/-- Single-orbit transitivity of cap-preserving point permutations on one size
layer of cap positions.  For `k ≤ 4` this is the game-facing form of
`PGL`-transitivity on points, pairs, triangles, and frames. -/
def CapTransitiveStatement (k : ℕ) : Prop :=
  ∀ ⦃S T : Finset (Point K V)⦄, Cap K V S -> Cap K V T ->
    S.card = k -> T.card = k ->
      ∃ e : Point K V ≃ Point K V,
        (∀ U : Finset (Point K V), Cap K V (U.map e.toEmbedding) ↔ Cap K V U) ∧
          S.map e.toEmbedding = T

/--
Frame reduction, game-theoretic half: single-orbit transitivity at sizes
`1..4` plus extendability below size `4` collapse the projective conjecture to
the value of a single frame position.  The four transitivity hypotheses and
the extendability hypothesis are the remaining geometric obligations.
-/
theorem initialPStatement_iff_isP_frame
    (h1 : CapTransitiveStatement (K := K) (V := V) 1)
    (h2 : CapTransitiveStatement (K := K) (V := V) 2)
    (h3 : CapTransitiveStatement (K := K) (V := V) 3)
    (h4 : CapTransitiveStatement (K := K) (V := V) 4)
    (hext : ∀ S : Finset (Point K V), Cap K V S -> S.card ≤ 3 ->
      ∃ x : Point K V, FiniteBuildGame.Move (Cap K V) S x)
    {F : Finset (Point K V)} (hF : Cap K V F) (hFcard : F.card = 4) :
    (InitialPStatement (K := K) (V := V) ↔ FiniteBuildGame.IsP (Cap K V) F) :=
  FiniteBuildGame.isP_empty_iff_isP_of_frame_chain
    (FiniteBuildGame.sizeValueConstant_of_transitive h1)
    (FiniteBuildGame.sizeValueConstant_of_transitive h2)
    (FiniteBuildGame.sizeValueConstant_of_transitive h3)
    (FiniteBuildGame.sizeValueConstant_of_transitive h4)
    hext (cap_empty (K := K) (V := V)) hF hFcard

end Game

end Projective
end ProjectiveCap
