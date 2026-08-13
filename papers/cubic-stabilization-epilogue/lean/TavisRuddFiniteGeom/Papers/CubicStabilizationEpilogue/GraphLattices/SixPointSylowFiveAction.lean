import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.SixPointAlternatingAction

/-!
# The six order-five subgroups in the concrete alternating group

This module realizes the six labels of the coefficient-heart model as six
explicit order-five subgroups of the concrete alternating group on five
letters.  The factor translation and inversion conjugate these subgroups by
exactly the displayed six-point projective-line permutations.  Their
pairwise distinctness gives the concrete order-five subgroup packet behind
the manuscript's abstract six-label action.

All finite identities are checked by kernel reduction.  No native execution,
external certificate, or oracle is used.  This is a concrete group-theoretic
model; identifying it with the six geometrically constructed elliptic
quotients and axes remains a separate geometric step.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace GraphLattices

/-- One generator for each of the six order-five subgroups, in the labelling
for which conjugation agrees with the projective-line translation and
inversion permutations. -/
def sixPointFiveGeneratorTable : Fin 6 → Fin 5 → Fin 5 :=
  !![1, 4, 3, 0, 2;
     2, 4, 3, 1, 0;
     3, 2, 4, 1, 0;
     3, 2, 0, 4, 1;
     3, 4, 1, 2, 0;
     4, 0, 1, 2, 3]

/-- The permutation represented by a row of `sixPointFiveGeneratorTable`. -/
def sixPointFiveGeneratorPermutation (label : Fin 6) : Equiv.Perm (Fin 5) where
  toFun := sixPointFiveGeneratorTable label
  invFun := fun point =>
    (sixPointFiveGeneratorTable label
      (sixPointFiveGeneratorTable label
        (sixPointFiveGeneratorTable label
          (sixPointFiveGeneratorTable label point))))
  left_inv point := by fin_cases label <;> fin_cases point <;> decide
  right_inv point := by fin_cases label <;> fin_cases point <;> decide

/-- Every displayed generator is even, hence belongs to the concrete `A5`. -/
theorem sixPointFiveGeneratorPermutation_even (label : Fin 6) :
    sixPointFiveGeneratorPermutation label ∈ alternatingGroup (Fin 5) := by
  rw [Equiv.Perm.mem_alternatingGroup]
  fin_cases label <;> decide

/-- The displayed generator as an element of the concrete alternating group. -/
def sixPointFiveGenerator (label : Fin 6) : alternatingGroup (Fin 5) :=
  ⟨sixPointFiveGeneratorPermutation label,
    sixPointFiveGeneratorPermutation_even label⟩

/-- Every displayed generator has fifth power one. -/
theorem sixPointFiveGenerator_pow_five (label : Fin 6) :
    sixPointFiveGenerator label ^ 5 = 1 := by
  apply Subtype.ext
  apply Equiv.ext
  intro point
  fin_cases label <;> fin_cases point <;> decide

@[simp] theorem sixPointFiveGenerator_pow_six (label : Fin 6) :
    sixPointFiveGenerator label ^ 6 = sixPointFiveGenerator label := by
  rw [show 6 = 5 + 1 by omega, pow_add,
    sixPointFiveGenerator_pow_five, one_mul, pow_one]

@[simp] theorem sixPointFiveGenerator_pow_seven (label : Fin 6) :
    sixPointFiveGenerator label ^ 7 = sixPointFiveGenerator label ^ 2 := by
  rw [show 7 = 5 + 2 by omega, pow_add,
    sixPointFiveGenerator_pow_five, one_mul]

@[simp] theorem sixPointFiveGenerator_pow_eight (label : Fin 6) :
    sixPointFiveGenerator label ^ 8 = sixPointFiveGenerator label ^ 3 := by
  rw [show 8 = 5 + 3 by omega, pow_add,
    sixPointFiveGenerator_pow_five, one_mul]

@[simp] theorem sixPointFiveGenerator_inv (label : Fin 6) :
    (sixPointFiveGenerator label)⁻¹ = sixPointFiveGenerator label ^ 4 := by
  calc
    (sixPointFiveGenerator label)⁻¹ =
        (sixPointFiveGenerator label)⁻¹ *
          sixPointFiveGenerator label ^ 5 := by
      rw [sixPointFiveGenerator_pow_five, mul_one]
    _ = sixPointFiveGenerator label ^ 4 := by group

/-- The five-element cyclic subgroup associated with one six-point label. -/
def sixPointFiveSubgroup (label : Fin 6) :
    Subgroup (alternatingGroup (Fin 5)) :=
  Subgroup.zpowers (sixPointFiveGenerator label)

/-- No positive power below five of a displayed generator is one. -/
theorem sixPointFiveGenerator_pow_ne_one (label : Fin 6) (power : ℕ)
    (positive : 0 < power) (belowFive : power < 5) :
    sixPointFiveGenerator label ^ power ≠ 1 := by
  intro equality
  have permutationEquality :
      (sixPointFiveGeneratorPermutation label) ^ power = 1 :=
    congrArg Subtype.val equality
  have atZero := DFunLike.congr_fun permutationEquality 0
  fin_cases label <;> interval_cases power <;>
    simp [pow_succ, sixPointFiveGeneratorPermutation,
      sixPointFiveGeneratorTable] at atZero

/-- Each displayed cyclic subgroup has order five. -/
theorem sixPointFiveSubgroup_card (label : Fin 6) :
    Nat.card (sixPointFiveSubgroup label) = 5 := by
  rw [sixPointFiveSubgroup, Nat.card_zpowers]
  exact (orderOf_eq_iff (by norm_num)).2
    ⟨sixPointFiveGenerator_pow_five label,
      fun power below positive =>
        sixPointFiveGenerator_pow_ne_one label power positive below⟩

/-- Membership in a displayed order-five subgroup is exactly membership in
the five listed natural powers of its generator. -/
theorem mem_sixPointFiveSubgroup_iff
    (label : Fin 6) (element : alternatingGroup (Fin 5)) :
    element ∈ sixPointFiveSubgroup label ↔
      element = 1 ∨ element = sixPointFiveGenerator label ∨
        element = sixPointFiveGenerator label ^ 2 ∨
        element = sixPointFiveGenerator label ^ 3 ∨
        element = sixPointFiveGenerator label ^ 4 := by
  constructor
  · rw [sixPointFiveSubgroup, Subgroup.mem_zpowers_iff]
    rintro ⟨power, rfl⟩
    have reduction := zpow_mod_orderOf (sixPointFiveGenerator label) power
    have order : orderOf (sixPointFiveGenerator label) = 5 := by
      rw [← Nat.card_zpowers, ← sixPointFiveSubgroup,
        sixPointFiveSubgroup_card]
    rw [order] at reduction
    have nonnegative : 0 ≤ power % (5 : ℤ) := Int.emod_nonneg power (by norm_num)
    have below : power % (5 : ℤ) < 5 := Int.emod_lt_of_pos power (by norm_num)
    interval_cases remainder : power % (5 : ℤ)
    all_goals rw [← reduction]
    · exact Or.inl rfl
    · exact Or.inr (Or.inl rfl)
    · exact Or.inr (Or.inr (Or.inl rfl))
    · exact Or.inr (Or.inr (Or.inr (Or.inl rfl)))
    · exact Or.inr (Or.inr (Or.inr (Or.inr rfl)))
  · intro membership
    rw [sixPointFiveSubgroup]
    rcases membership with rfl | rfl | rfl | rfl | rfl
    · exact Subgroup.one_mem _
    · exact Subgroup.mem_zpowers _
    · exact Subgroup.npow_mem_zpowers _ 2
    · exact Subgroup.npow_mem_zpowers _ 3
    · exact Subgroup.npow_mem_zpowers _ 4

/-- The factor translation as an element of the concrete alternating group. -/
def sixPointFactorTranslationA5 : alternatingGroup (Fin 5) :=
  ⟨sixPointFactorTranslation, sixPointFactor_generators_even.1⟩

/-- The factor inversion as an element of the concrete alternating group. -/
def sixPointFactorInversionA5 : alternatingGroup (Fin 5) :=
  ⟨sixPointFactorInversion, sixPointFactor_generators_even.2⟩

private theorem zpowers_pow_two_eq (generator : alternatingGroup (Fin 5))
    (fifthPower : generator ^ 5 = 1) :
    Subgroup.zpowers (generator ^ 2) = Subgroup.zpowers generator := by
  apply le_antisymm
  · rw [Subgroup.zpowers_le]
    exact Subgroup.npow_mem_zpowers generator 2
  · rw [Subgroup.zpowers_le]
    have membership := Subgroup.npow_mem_zpowers (generator ^ 2) 3
    have powerEquality : (generator ^ 2) ^ 3 = generator := by
      rw [← pow_mul, show 2 * 3 = 5 + 1 by omega, pow_add,
        fifthPower, one_mul, pow_one]
    simpa only [powerEquality] using membership

private theorem zpowers_pow_three_eq (generator : alternatingGroup (Fin 5))
    (fifthPower : generator ^ 5 = 1) :
    Subgroup.zpowers (generator ^ 3) = Subgroup.zpowers generator := by
  apply le_antisymm
  · rw [Subgroup.zpowers_le]
    exact Subgroup.npow_mem_zpowers generator 3
  · rw [Subgroup.zpowers_le]
    have membership := Subgroup.npow_mem_zpowers (generator ^ 3) 2
    have powerEquality : (generator ^ 3) ^ 2 = generator := by
      rw [← pow_mul, show 3 * 2 = 5 + 1 by omega, pow_add,
        fifthPower, one_mul, pow_one]
    simpa only [powerEquality] using membership

private theorem zpowers_pow_four_eq (generator : alternatingGroup (Fin 5))
    (fifthPower : generator ^ 5 = 1) :
    Subgroup.zpowers (generator ^ 4) = Subgroup.zpowers generator := by
  apply le_antisymm
  · rw [Subgroup.zpowers_le]
    exact Subgroup.npow_mem_zpowers generator 4
  · rw [Subgroup.zpowers_le]
    have membership := Subgroup.npow_mem_zpowers (generator ^ 4) 4
    have powerEquality : (generator ^ 4) ^ 4 = generator := by
      rw [← pow_mul, show 4 * 4 = 5 * 3 + 1 by omega, pow_add,
        pow_mul, fifthPower, one_pow, one_mul, pow_one]
    simpa only [powerEquality] using membership

private def sixPointTranslationConjugationExponent : Fin 6 → Fin 5 :=
  ![1, 1, 1, 3, 2, 1]

private def sixPointInversionConjugationExponent : Fin 6 → Fin 5 :=
  ![4, 3, 4, 4, 2, 4]

/-- Conjugation of the chosen order-five generator by factor translation is
a nonzero power of the chosen generator at the translated label. -/
theorem sixPointFiveGenerator_translation_conjugation (label : Fin 6) :
    ∃ exponent : Fin 5, exponent ≠ 0 ∧
      MulAut.conj sixPointFactorTranslationA5 (sixPointFiveGenerator label) =
        sixPointFiveGenerator (sixPointTranslationPermutation label) ^
          (exponent : ℕ) := by
  refine ⟨sixPointTranslationConjugationExponent label, ?_, ?_⟩
  · fin_cases label <;> decide
  · apply Subtype.ext
    apply Equiv.ext
    intro point
    fin_cases label <;> fin_cases point <;> decide

/-- Conjugation of the chosen order-five generator by factor inversion is a
nonzero power of the chosen generator at the inverted label. -/
theorem sixPointFiveGenerator_inversion_conjugation (label : Fin 6) :
    ∃ exponent : Fin 5, exponent ≠ 0 ∧
      MulAut.conj sixPointFactorInversionA5 (sixPointFiveGenerator label) =
        sixPointFiveGenerator (sixPointInversionPermutation label) ^
          (exponent : ℕ) := by
  refine ⟨sixPointInversionConjugationExponent label, ?_, ?_⟩
  · fin_cases label <;> decide
  · apply Subtype.ext
    apply Equiv.ext
    intro point
    fin_cases label <;> fin_cases point <;> decide

/-- Conjugation by factor translation acts on the six order-five subgroups by
the displayed six-point translation. -/
theorem sixPointFiveSubgroup_translation_conjugation (label : Fin 6) :
    (sixPointFiveSubgroup label).map
        (MulAut.conj sixPointFactorTranslationA5) =
      sixPointFiveSubgroup (sixPointTranslationPermutation label) := by
  rw [sixPointFiveSubgroup, MonoidHom.map_zpowers]
  change Subgroup.zpowers
      (MulAut.conj sixPointFactorTranslationA5
        (sixPointFiveGenerator label)) = _
  obtain ⟨exponent, nonzero, equality⟩ :=
    sixPointFiveGenerator_translation_conjugation label
  rw [equality]
  fin_cases exponent
  · simp at nonzero
  · rfl
  · exact zpowers_pow_two_eq _
      (sixPointFiveGenerator_pow_five _)
  · exact zpowers_pow_three_eq _
      (sixPointFiveGenerator_pow_five _)
  · exact zpowers_pow_four_eq _
      (sixPointFiveGenerator_pow_five _)

/-- Conjugation by factor inversion acts on the six order-five subgroups by
the displayed six-point inversion. -/
theorem sixPointFiveSubgroup_inversion_conjugation (label : Fin 6) :
    (sixPointFiveSubgroup label).map
        (MulAut.conj sixPointFactorInversionA5) =
      sixPointFiveSubgroup (sixPointInversionPermutation label) := by
  rw [sixPointFiveSubgroup, MonoidHom.map_zpowers]
  change Subgroup.zpowers
      (MulAut.conj sixPointFactorInversionA5
        (sixPointFiveGenerator label)) = _
  obtain ⟨exponent, nonzero, equality⟩ :=
    sixPointFiveGenerator_inversion_conjugation label
  rw [equality]
  fin_cases exponent
  · simp at nonzero
  · rfl
  · exact zpowers_pow_two_eq _
      (sixPointFiveGenerator_pow_five _)
  · exact zpowers_pow_three_eq _
      (sixPointFiveGenerator_pow_five _)
  · exact zpowers_pow_four_eq _
      (sixPointFiveGenerator_pow_five _)

set_option maxHeartbeats 2000000 in
/-- The six displayed order-five subgroups are pairwise distinct. -/
theorem sixPointFiveSubgroup_injective :
    Function.Injective sixPointFiveSubgroup := by
  intro left right equality
  have generatorMembership :
      sixPointFiveGenerator left ∈ sixPointFiveSubgroup right := by
    rw [← equality, sixPointFiveSubgroup]
    exact Subgroup.mem_zpowers _
  have listed :=
    (mem_sixPointFiveSubgroup_iff right (sixPointFiveGenerator left)).mp
      generatorMembership
  fin_cases left <;> fin_cases right
  all_goals try rfl
  all_goals rcases listed with equality | equality | equality | equality | equality
  all_goals exfalso
  all_goals revert equality
  all_goals decide

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
