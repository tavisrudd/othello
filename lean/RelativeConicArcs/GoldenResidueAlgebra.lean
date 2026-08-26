import Mathlib.RingTheory.AdjoinRoot
import RelativeConicArcs.GoldenQuadraticCharacters

/-!
# The golden residue algebra

This module formalizes the quadratic residue algebra occurring in the complete
fibre over `[xyz]`: `ℚ[t]/(t²-t-1)`.  The defining polynomial is irreducible,
so the quotient is a field.  Its canonical element `2t-1` squares to five,
and the nontrivial deck map sends `t` to `1-t` and negates that square root.

The geometric assertion identifying this algebra with the complete incidence
fibre remains a separate input.
-/

namespace RelativeConicArcs.GoldenResidueAlgebra

open Polynomial

/-- The monic golden quadratic relation. -/
noncomputable abbrev relation : ℚ[X] := X ^ 2 - X - 1

/-- The residue algebra `ℚ[t]/(t²-t-1)`. -/
abbrev GoldenAlgebra := AdjoinRoot relation

/-- The distinguished golden root. -/
noncomputable def goldenRoot : AdjoinRoot relation := AdjoinRoot.root relation

/-- The distinguished root satisfies `t²=t+1`. -/
theorem goldenRoot_relation : goldenRoot ^ 2 = goldenRoot + 1 := by
  have h := AdjoinRoot.eval₂_root relation
  rw [eval₂_sub, eval₂_sub, eval₂_pow, eval₂_X, eval₂_one] at h
  have h' : goldenRoot ^ 2 - goldenRoot = 1 := sub_eq_zero.mp h
  simpa [add_comm] using (sub_eq_iff_eq_add.mp h')

private theorem relation_eval_conjugate :
    relation.eval₂ (AdjoinRoot.of relation)
      ((1 : AdjoinRoot relation) - goldenRoot) = 0 := by
  have hconj := GoldenQuadraticCharacters.goldenConjugate_relation goldenRoot_relation
  simp only [GoldenQuadraticCharacters.goldenConjugate] at hconj
  rw [eval₂_sub, eval₂_sub, eval₂_pow, eval₂_X, eval₂_one]
  have hconj' : (1 - goldenRoot) ^ 2 = 1 + (1 - goldenRoot) := by
    simpa [add_comm] using hconj
  exact sub_eq_zero.mpr ((sub_eq_iff_eq_add).mpr hconj')

/-- The golden quadratic is irreducible over the rationals. -/
theorem relation_irreducible : Irreducible relation := by
  apply Polynomial.irreducible_of_degree_le_three_of_not_isRoot
  · have hdeg : relation.natDegree = 2 := by
      unfold relation
      compute_degree
      norm_num
    rw [hdeg]
    norm_num
  · intro x hx
    have hx₀ : x ^ 2 - x - 1 = 0 := by
      simpa [relation, Polynomial.IsRoot] using hx
    have hrel : x ^ 2 = x + 1 := by linarith
    have hsquare : IsSquare (5 : ℚ) :=
      ⟨2 * x - 1,
        by simpa [pow_two] using
          (GoldenQuadraticCharacters.golden_discriminant_square hrel).symm⟩
    have : ¬ IsSquare (5 : ℚ) := by norm_num
    exact this hsquare

noncomputable instance relationIrreducibleFact : Fact (Irreducible relation) :=
  ⟨relation_irreducible⟩

/-- The quotient by the irreducible golden quadratic is a field. -/
noncomputable instance : Field (AdjoinRoot relation) := AdjoinRoot.instField

/-- The canonical square root of five in the residue field. -/
noncomputable def sqrtFive : AdjoinRoot relation := 2 * goldenRoot - 1

/-- The canonical element `2t-1` squares to five. -/
theorem sqrtFive_sq : sqrtFive ^ 2 = 5 :=
  GoldenQuadraticCharacters.golden_discriminant_square goldenRoot_relation

/-- The golden generator is recovered from the square root of five. -/
theorem goldenRoot_eq_one_add_sqrtFive_div_two :
    goldenRoot = (1 + sqrtFive) / 2 := by
  simp only [sqrtFive]
  ring

/-- The nontrivial deck endomorphism of the golden residue field. -/
noncomputable def deck : AdjoinRoot relation →+* AdjoinRoot relation :=
  AdjoinRoot.lift (AdjoinRoot.of relation) (1 - goldenRoot) relation_eval_conjugate

/-- Deck exchange sends the distinguished root to its conjugate. -/
@[simp]
theorem deck_goldenRoot : deck goldenRoot = 1 - goldenRoot := by
  exact AdjoinRoot.lift_root relation_eval_conjugate

/-- Applying deck exchange twice is the identity. -/
theorem deck_involutive : Function.Involutive deck := by
  intro x
  have hcomp : deck.comp deck = RingHom.id (AdjoinRoot relation) := by
    apply AdjoinRoot.ringHom_ext
    · ext q
      simp [deck]
    · change deck (deck goldenRoot) = goldenRoot
      rw [deck_goldenRoot, map_sub, map_one, deck_goldenRoot]
      ring
  exact DFunLike.congr_fun hcomp x

/-- The nontrivial deck map as a ring automorphism. -/
noncomputable def deckEquiv :
    AdjoinRoot relation ≃+* AdjoinRoot relation where
  toFun := deck
  invFun := deck
  left_inv := deck_involutive
  right_inv := deck_involutive
  map_mul' := deck.map_mul
  map_add' := deck.map_add

/-- Deck exchange negates the canonical square root of five. -/
@[simp]
theorem deck_sqrtFive : deck sqrtFive = -sqrtFive := by
  simp only [sqrtFive, map_sub, map_mul, map_ofNat, map_one, deck_goldenRoot]
  ring

end RelativeConicArcs.GoldenResidueAlgebra
