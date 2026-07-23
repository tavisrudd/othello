import RelativeConicArcs.ClebschSurvivalBoundaryData
import Mathlib.Tactic

/-!
# Bounded survival and erasure theorems

This module kernel-checks four exact finite boundaries.

The companion search ranges over exactly four companion matching orbits and four cyclotomic
reductions.  The stronger weight search ranges over the full four-dimensional descended
companion-weight space after localization at two; a displayed minor of its stacked linear and
quadratic moment map is invertible over `ZMod 11`.

The cross-sheet calculation concerns only the displayed seven-by-seven and eleven-by-eleven
shared-edge and disjoint incidence matrices.  Explicit inverse formulas show that all four maps
are invertible over the rationals, excluding a smaller image or a nonzero kernel for these
particular maps.

Finally, three functionals annihilate the tested 35-dimensional five-space cubic image and give
an invertible evaluation matrix on the three displayed relative cubics.  This excludes an
intersection for that frozen linear test.  It does not exclude nonlinear maps, non-equivariant
coordinate coincidences, other five-spaces, or other integral tensor constructions.

The congruence theorem is conditional on the frozen arithmetic interpretation: golden splitting
is supplied by the residue classes modulo five and transporter visibility by the residue classes
modulo eight.  The theorem proves the resulting finite partition modulo forty; it constructs no
parent, marker, transporter, or ordinary character, and makes no density claim.
-/

namespace RelativeConicArcs
namespace ClebschSurvivalBoundary

set_option maxRecDepth 100000
set_option maxHeartbeats 2000000

local instance : Fact (Nat.Prime 11) := ⟨by norm_num⟩

private theorem mulVec_injective_of_leftInverse {n : Nat} {K : Type*}
    [Field K] (A B : Matrix (Fin n) (Fin n) K) (h : B * A = 1) :
    Function.Injective (Matrix.mulVec A) := by
  intro x y hxy
  have h' := congrArg (Matrix.mulVec B) hxy
  simpa [Matrix.mulVec_mulVec, h] using h'

/-! ## Companion routes -/

/-- Each of the four reductions has exactly one sheet-hitting companion, and each companion
hits at exactly one reduction.  This is the complete `4 × 4` searched domain. -/
theorem companion_sheet_hit_bijection :
    (∀ r : Fin 4,
      (Finset.univ.filter fun c : Fin 4 ↦ companionSheetHits r c = true).card = 1) ∧
    (∀ c : Fin 4,
      (Finset.univ.filter fun r : Fin 4 ↦ companionSheetHits r c = true).card = 1) := by
  decide

/-- Conjugation consists of two transpositions and fixes no companion. -/
theorem companion_conjugation_has_no_fixed_candidate :
    (∀ c : Fin 4, companionConjugation (companionConjugation c) = c) ∧
    (∀ c : Fin 4, companionConjugation c ≠ c) := by
  decide

/-- The observed four companions do not satisfy the proposed unique-companion stop condition. -/
theorem four_companions_fail_unique_stop_condition : (4 : Nat) ≠ 1 := by
  decide

private theorem lowerMomentMinor_leftInverse :
    lowerMomentMinorInverse * lowerMomentMinor = 1 := by
  decide

/-- The selected lower-moment minor is injective, hence the full stacked degree-one/degree-two
map has zero kernel on the four-dimensional descended weight space. -/
theorem descended_companion_lowerMoment_kernel_zero :
    Function.Injective (Matrix.mulVec lowerMomentMinor) :=
  @mulVec_injective_of_leftInverse 4 F11 inferInstance lowerMomentMinor
    lowerMomentMinorInverse lowerMomentMinor_leftInverse

/-- Any descended companion weight whose selected linear and quadratic coordinates vanish is
zero.  Thus no nonzero weight in the searched four-dimensional family reaches a cubic test. -/
theorem no_nonzero_descended_weight_passes_lowerMoment_gate
    (w : Fin 4 → F11) (h : Matrix.mulVec lowerMomentMinor w = 0) : w = 0 := by
  exact descended_companion_lowerMoment_kernel_zero (by simpa using h)

/-! ## Cross-sheet incidence maps -/

private def sevenSharedInverse : Matrix (Fin 7) (Fin 7) ℚ :=
  fun i j ↦ (2 * sevenSharedEdge j i - 1) / 4

private def sevenDisjointInverse : Matrix (Fin 7) (Fin 7) ℚ :=
  fun i j ↦ (3 * sevenDisjoint j i - 1) / 6

private def elevenSharedInverse : Matrix (Fin 11) (Fin 11) ℚ :=
  fun i j ↦ (2 * elevenSharedEdge j i - 1) / 6

private def elevenDisjointInverse : Matrix (Fin 11) (Fin 11) ℚ :=
  fun i j ↦ (5 * elevenDisjoint j i - 2) / 15

private theorem sevenShared_gram :
    sevenSharedEdge * sevenSharedEdge.transpose =
      fun i j ↦ if i = j then 4 else 2 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [sevenSharedEdge, Matrix.mul_apply, Matrix.transpose_apply, Fin.sum_univ_succ]

private theorem sevenDisjoint_gram :
    sevenDisjoint * sevenDisjoint.transpose =
      fun i j ↦ if i = j then 3 else 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [sevenDisjoint, Matrix.mul_apply, Matrix.transpose_apply, Fin.sum_univ_succ]

private theorem elevenShared_gram :
    elevenSharedEdge * elevenSharedEdge.transpose =
      fun i j ↦ if i = j then 6 else 3 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [elevenSharedEdge, Matrix.mul_apply, Matrix.transpose_apply, Fin.sum_univ_succ]

private theorem elevenDisjoint_gram :
    elevenDisjoint * elevenDisjoint.transpose =
      fun i j ↦ if i = j then 5 else 2 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [elevenDisjoint, Matrix.mul_apply, Matrix.transpose_apply, Fin.sum_univ_succ]

/-- The four displayed cross-sheet matrices have the exact symmetric-design Gram identities
`2I+2J`, `2I+J`, `3I+3J`, and `3I+2J`, respectively. -/
theorem crossSheet_gram_identities :
    (sevenSharedEdge * sevenSharedEdge.transpose =
      fun i j ↦ if i = j then 4 else 2) ∧
    (sevenDisjoint * sevenDisjoint.transpose =
      fun i j ↦ if i = j then 3 else 1) ∧
    (elevenSharedEdge * elevenSharedEdge.transpose =
      fun i j ↦ if i = j then 6 else 3) ∧
    (elevenDisjoint * elevenDisjoint.transpose =
      fun i j ↦ if i = j then 5 else 2) :=
  ⟨sevenShared_gram, sevenDisjoint_gram, elevenShared_gram, elevenDisjoint_gram⟩

private theorem sevenShared_leftInverse : sevenSharedInverse * sevenSharedEdge = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [sevenSharedInverse, sevenSharedEdge, Matrix.mul_apply, Fin.sum_univ_succ]

private theorem sevenDisjoint_leftInverse : sevenDisjointInverse * sevenDisjoint = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [sevenDisjointInverse, sevenDisjoint, Matrix.mul_apply, Fin.sum_univ_succ]

private theorem elevenShared_leftInverse : elevenSharedInverse * elevenSharedEdge = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [elevenSharedInverse, elevenSharedEdge, Matrix.mul_apply, Fin.sum_univ_succ]

private theorem elevenDisjoint_leftInverse : elevenDisjointInverse * elevenDisjoint = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [elevenDisjointInverse, elevenDisjoint, Matrix.mul_apply, Fin.sum_univ_succ]

/-- Both seven-sheet relation maps are injective over the rationals. -/
theorem seven_crossSheet_maps_injective :
    Function.Injective (Matrix.mulVec sevenSharedEdge) ∧
    Function.Injective (Matrix.mulVec sevenDisjoint) :=
  ⟨mulVec_injective_of_leftInverse sevenSharedEdge sevenSharedInverse sevenShared_leftInverse,
    mulVec_injective_of_leftInverse sevenDisjoint sevenDisjointInverse sevenDisjoint_leftInverse⟩

/-- Both eleven-sheet relation maps are injective over the rationals.  In particular neither
displayed map has a six-dimensional image with five-dimensional kernel. -/
theorem eleven_crossSheet_maps_injective :
    Function.Injective (Matrix.mulVec elevenSharedEdge) ∧
    Function.Injective (Matrix.mulVec elevenDisjoint) :=
  ⟨mulVec_injective_of_leftInverse elevenSharedEdge elevenSharedInverse
      elevenShared_leftInverse,
    mulVec_injective_of_leftInverse elevenDisjoint elevenDisjointInverse
      elevenDisjoint_leftInverse⟩

/-! ## Five-space/relative-cubic test -/

private theorem relativeCubicQuotient_leftInverse :
    relativeCubicQuotientInverse * relativeCubicQuotient = 1 := by
  decide

/-- The three quotient evaluations separate all three relative-cubic coefficients. -/
theorem relativeCubic_quotient_injective :
    Function.Injective (Matrix.mulVec relativeCubicQuotient) :=
  @mulVec_injective_of_leftInverse 3 F11 inferInstance relativeCubicQuotient
    relativeCubicQuotientInverse relativeCubicQuotient_leftInverse

/-- The tested five-space cubic columns vanish under the three quotient functionals. -/
theorem tested_fiveSpace_cubics_have_zero_quotient :
    fiveSpaceCubicQuotient = 0 := rfl

/-- No nonzero relative cubic has the same quotient image as a tested five-space cubic.
This is exactly the frozen linear intersection test; the semantic identification of the
35 columns is supplied by the external certificate. -/
theorem tested_fiveSpace_relativeCubic_intersection_zero
    (fiveCoefficients : Fin 35 → F11) (relativeCoefficients : Fin 3 → F11)
    (h : Matrix.mulVec fiveSpaceCubicQuotient fiveCoefficients =
      Matrix.mulVec relativeCubicQuotient relativeCoefficients) :
    relativeCoefficients = 0 := by
  apply relativeCubic_quotient_injective
  simpa [tested_fiveSpace_cubics_have_zero_quotient] using h.symm

/-! ## Conditional mod-forty law -/

/-- The residue condition supplied by golden splitting. -/
def goldenSplitResidue (r : Fin 40) : Bool := r.val % 5 = 1 || r.val % 5 = 4

/-- The residue condition supplied by the frozen determinant-two transporter. -/
def transporterVisibleResidue (r : Fin 40) : Bool := r.val % 8 = 3 || r.val % 8 = 5

/-- Reduced residue classes that are golden-split and transporter-visible. -/
def visibleResidues : Finset (Fin 40) :=
  Finset.univ.filter fun r ↦ Nat.Coprime r.val 40 ∧
    goldenSplitResidue r = true ∧ transporterVisibleResidue r = true

/-- All sixteen reduced residue classes modulo forty. -/
def reducedResidues : Finset (Fin 40) :=
  Finset.univ.filter fun r ↦ Nat.Coprime r.val 40

/-- Reduced residue classes that are golden-split but transporter-fused. -/
def fusedResidues : Finset (Fin 40) :=
  Finset.univ.filter fun r ↦ Nat.Coprime r.val 40 ∧
    goldenSplitResidue r = true ∧ transporterVisibleResidue r = false

/-- Reduced residue classes that are golden-inert, so the visibility test is not reached. -/
def inertResidues : Finset (Fin 40) :=
  Finset.univ.filter fun r ↦ Nat.Coprime r.val 40 ∧ goldenSplitResidue r = false

/-- Exact finite classification of the sixteen reduced residue classes modulo forty. -/
theorem exact_mod40_residue_partition :
    visibleResidues = {11, 19, 21, 29} ∧
    fusedResidues = {1, 9, 31, 39} ∧
    inertResidues = {3, 7, 13, 17, 23, 27, 33, 37} := by
  decide

/-- The three outcome sets exhaust the reduced residue classes and are pairwise disjoint. -/
theorem mod40_residue_partition_complete :
    visibleResidues ∪ fusedResidues ∪ inertResidues = reducedResidues ∧
    Disjoint visibleResidues fusedResidues ∧
    Disjoint visibleResidues inertResidues ∧
    Disjoint fusedResidues inertResidues := by
  decide

/-- Conditional interpretation of the finite residue partition.  The two equivalences are the
frozen arithmetic/transporter hypotheses; this theorem does not prove them or construct the
objects they name. -/
theorem mod40_prediction_of_frozen_hypotheses
    (r : Fin 40) (goldenSplit pslVisible : Prop)
    (hreduced : Nat.Coprime r.val 40)
    (hsplit : goldenSplit ↔ goldenSplitResidue r = true)
    (hvisible : pslVisible ↔ goldenSplit ∧ transporterVisibleResidue r = true) :
    (pslVisible ↔ r ∈ visibleResidues) ∧
    (goldenSplit ∧ ¬ pslVisible ↔ r ∈ fusedResidues) ∧
    (¬ goldenSplit ↔ r ∈ inertResidues) := by
  simp only [visibleResidues, fusedResidues, inertResidues, Finset.mem_filter,
    Finset.mem_univ, true_and]
  constructor
  · constructor
    · intro hp
      exact ⟨hreduced, hsplit.mp (hvisible.mp hp).1, (hvisible.mp hp).2⟩
    · rintro ⟨_, hs, hv⟩
      exact hvisible.mpr ⟨hsplit.mpr hs, hv⟩
  constructor
  · constructor
    · rintro ⟨hs, hp⟩
      refine ⟨hreduced, hsplit.mp hs, ?_⟩
      cases ht : transporterVisibleResidue r with
      | false => rfl
      | true => exact False.elim (hp (hvisible.mpr ⟨hs, ht⟩))
    · rintro ⟨_, hs, ht⟩
      refine ⟨hsplit.mpr hs, ?_⟩
      intro hp
      have := (hvisible.mp hp).2
      simp [ht] at this
  · constructor
    · intro hs
      refine ⟨hreduced, ?_⟩
      cases ht : goldenSplitResidue r with
      | false => rfl
      | true => exact False.elim (hs (hsplit.mpr ht))
    · rintro ⟨_, ht⟩ hs
      have := hsplit.mp hs
      simp [ht] at this

end ClebschSurvivalBoundary
end RelativeConicArcs
