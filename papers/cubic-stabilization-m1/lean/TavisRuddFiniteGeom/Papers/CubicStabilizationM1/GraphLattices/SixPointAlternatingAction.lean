import Mathlib.GroupTheory.SpecificGroups.Alternating
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixPointCoefficientHeart

/-!
# The five-factor action of the six-point generators

The fifteen pairs of six labelled points carry a displayed one-factorization
into five perfect matchings.  Translation and inversion on the projective-line
labelling preserve this factorization and induce a five-cycle and a double
transposition on its five factors.  The induced factor words exhaust the
alternating group on five letters, and the factor action has exactly the same
word kernel as the six-point action.  Thus the generated six-point action is
faithfully identified with the concrete alternating-group model of `A5`.

All displayed permutation and conjugation identities are closed finite
equalities checked by kernel reduction.  No native execution, external
certificate, or oracle is used.  The module does not identify the six labels
with the manuscript's six conjugate dihedral subgroups, so it does not yet
identify this concrete `A5` action with the manuscript's geometric one.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace GraphLattices

/-- The five perfect matchings in the factorization stabilized by the
six-point translation and inversion generators. -/
def sixPointFactorTable : Fin 5 → Fin 6 → Fin 6 :=
  !![1, 0, 4, 5, 2, 3;
     2, 5, 0, 4, 3, 1;
     3, 2, 1, 0, 5, 4;
     4, 3, 5, 1, 0, 2;
     5, 4, 3, 2, 1, 0]

/-- Each row of `sixPointFactorTable` is a fixed-point-free involution and
therefore represents one perfect matching. -/
def sixPointFactor (factor : Fin 5) : Equiv.Perm (Fin 6) where
  toFun := sixPointFactorTable factor
  invFun := sixPointFactorTable factor
  left_inv point := by fin_cases factor <;> fin_cases point <;> decide
  right_inv point := by fin_cases factor <;> fin_cases point <;> decide

/-- Translation induces this five-cycle on the displayed factors. -/
def sixPointFactorTranslation : Equiv.Perm (Fin 5) where
  toFun := ![2, 3, 4, 0, 1]
  invFun := ![3, 4, 0, 1, 2]
  left_inv factor := by fin_cases factor <;> decide
  right_inv factor := by fin_cases factor <;> decide

/-- Inversion induces this double transposition on the displayed factors. -/
def sixPointFactorInversion : Equiv.Perm (Fin 5) where
  toFun := ![2, 3, 0, 1, 4]
  invFun := ![2, 3, 0, 1, 4]
  left_inv factor := by fin_cases factor <;> decide
  right_inv factor := by fin_cases factor <;> decide

/-- Translation carries each matching to the factor indexed by the displayed
five-cycle. -/
theorem sixPointFactor_translation_conjugation (factor : Fin 5) :
    sixPointTranslationPermutation * sixPointFactor factor *
        sixPointTranslationPermutation⁻¹ =
      sixPointFactor (sixPointFactorTranslation factor) := by
  ext point
  fin_cases factor <;> fin_cases point <;> decide

/-- Inversion carries each matching to the factor indexed by the displayed
double transposition. -/
theorem sixPointFactor_inversion_conjugation (factor : Fin 5) :
    sixPointInversionPermutation * sixPointFactor factor *
        sixPointInversionPermutation⁻¹ =
      sixPointFactor (sixPointFactorInversion factor) := by
  ext point
  fin_cases factor <;> fin_cases point <;> decide

/-- Evaluate a word in the two six-point permutations. -/
def sixPointPermutationWord : List Bool → Equiv.Perm (Fin 6)
  | [] => 1
  | generator :: word =>
      sixPointPermutationWord word *
        (if generator then sixPointInversionPermutation
          else sixPointTranslationPermutation)

/-- Evaluate the same word on the five factors. -/
def sixPointFactorWord : List Bool → Equiv.Perm (Fin 5)
  | [] => 1
  | generator :: word =>
      sixPointFactorWord word *
        (if generator then sixPointFactorInversion
          else sixPointFactorTranslation)

/-- Conjugating a matching by a six-point word agrees with applying the
corresponding five-factor word to its index. -/
theorem sixPointFactor_word_conjugation (word : List Bool) (factor : Fin 5) :
    sixPointPermutationWord word * sixPointFactor factor *
        (sixPointPermutationWord word)⁻¹ =
      sixPointFactor (sixPointFactorWord word factor) := by
  induction word generalizing factor with
  | nil => simp [sixPointPermutationWord, sixPointFactorWord]
  | cons generator word induction =>
      by_cases inversion : generator
      · subst generator
        simp only [sixPointPermutationWord, sixPointFactorWord, if_true,
          mul_inv_rev]
        calc
          sixPointPermutationWord word * sixPointInversionPermutation *
                sixPointFactor factor *
              (sixPointInversionPermutation⁻¹ *
                (sixPointPermutationWord word)⁻¹) =
              sixPointPermutationWord word *
                (sixPointInversionPermutation * sixPointFactor factor *
                  sixPointInversionPermutation⁻¹) *
                (sixPointPermutationWord word)⁻¹ := by group
          _ = sixPointPermutationWord word *
                sixPointFactor (sixPointFactorInversion factor) *
                (sixPointPermutationWord word)⁻¹ := by
              rw [sixPointFactor_inversion_conjugation]
          _ = sixPointFactor
                (sixPointFactorWord word (sixPointFactorInversion factor)) :=
              induction (sixPointFactorInversion factor)
          _ = sixPointFactor
                ((sixPointFactorWord word * sixPointFactorInversion) factor) := rfl
      · have generatorFalse : generator = false := Bool.eq_false_of_not_eq_true inversion
        subst generator
        simp only [sixPointPermutationWord, sixPointFactorWord, mul_inv_rev]
        calc
          sixPointPermutationWord word * sixPointTranslationPermutation *
                sixPointFactor factor *
              (sixPointTranslationPermutation⁻¹ *
                (sixPointPermutationWord word)⁻¹) =
              sixPointPermutationWord word *
                (sixPointTranslationPermutation * sixPointFactor factor *
                  sixPointTranslationPermutation⁻¹) *
                (sixPointPermutationWord word)⁻¹ := by group
          _ = sixPointPermutationWord word *
                sixPointFactor (sixPointFactorTranslation factor) *
                (sixPointPermutationWord word)⁻¹ := by
              rw [sixPointFactor_translation_conjugation]
          _ = sixPointFactor
                (sixPointFactorWord word (sixPointFactorTranslation factor)) :=
              induction (sixPointFactorTranslation factor)
          _ = sixPointFactor
                ((sixPointFactorWord word * sixPointFactorTranslation) factor) := rfl

/-- Both induced factor generators are even permutations. -/
theorem sixPointFactor_generators_even :
    sixPointFactorTranslation ∈ alternatingGroup (Fin 5) ∧
      sixPointFactorInversion ∈ alternatingGroup (Fin 5) := by
  constructor <;> rw [Equiv.Perm.mem_alternatingGroup] <;> decide

/-- Every factor permutation induced by a generator word is even. -/
theorem sixPointFactorWord_even (word : List Bool) :
    sixPointFactorWord word ∈ alternatingGroup (Fin 5) := by
  induction word with
  | nil => simp [sixPointFactorWord]
  | cons generator word induction =>
      simp only [sixPointFactorWord]
      apply Subgroup.mul_mem _ induction
      by_cases inversion : generator
      · simpa [inversion] using sixPointFactor_generators_even.2
      · simpa [inversion] using sixPointFactor_generators_even.1

/-- Sixty explicit positive words that give normal forms for all even
permutations of the five factors.  Here `false` denotes translation and
`true` denotes inversion. -/
def sixPointFactorNormalWords : List (List Bool) := [
  [], [false], [true],
  [false, false], [false, true], [true, false],
  [false, false, false], [false, false, true], [false, true, false],
  [true, false, false], [true, false, true], [false, false, false, false],
  [false, false, false, true], [false, false, true, false], [false, true, false, false],
  [false, true, false, true], [true, false, false, false], [true, false, false, true],
  [true, false, true, false], [false, false, false, true, false],
  [false, false, true, false, false], [false, false, true, false, true],
  [false, true, false, false, false], [false, true, false, false, true],
  [true, false, false, false, true], [true, false, false, true, false],
  [true, false, true, false, false], [false, false, false, true, false, false],
  [false, false, false, true, false, true], [false, false, true, false, false, false],
  [false, false, true, false, false, true], [false, true, false, false, false, true],
  [true, false, false, false, true, false], [true, false, false, true, false, false],
  [true, false, false, true, false, true], [true, false, true, false, false, false],
  [true, false, true, false, false, true], [false, false, false, true, false, false, false],
  [false, false, false, true, false, false, true],
  [false, false, true, false, false, false, true],
  [false, true, false, false, false, true, false],
  [true, false, false, false, true, false, false],
  [true, false, false, false, true, false, true],
  [true, false, false, true, false, false, false],
  [true, false, false, true, false, false, true],
  [true, false, true, false, false, false, true],
  [false, false, false, true, false, false, false, true],
  [false, false, true, false, false, false, true, false],
  [false, true, false, false, false, true, false, false],
  [false, true, false, false, false, true, false, true],
  [true, false, false, false, true, false, false, true],
  [true, false, false, true, false, false, false, true],
  [false, false, false, true, false, false, false, true, false],
  [false, false, true, false, false, false, true, false, false],
  [false, false, true, false, false, false, true, false, true],
  [false, true, false, false, false, true, false, false, true],
  [true, false, false, true, false, false, false, true, false],
  [false, false, false, true, false, false, false, true, false, false],
  [false, false, false, true, false, false, false, true, false, true],
  [false, false, true, false, false, false, true, false, false, true]]

/-- The displayed normal words cover every even permutation of the five
factors.  This is a closed finite equality check over the sixty normal forms. -/
theorem sixPointFactorNormalWords_complete :
    ∀ permutation : Equiv.Perm (Fin 5),
      Equiv.Perm.sign permutation = 1 →
        ∃ word ∈ sixPointFactorNormalWords,
          sixPointFactorWord word = permutation := by
  set_option maxRecDepth 10000 in
    decide

/-- The five displayed matchings have distinct indices. -/
theorem sixPointFactor_injective : Function.Injective sixPointFactor := by
  decide

/-- The action of a six-point permutation on the displayed factorization is
faithful: a permutation centralizing every displayed matching is trivial. -/
theorem sixPointFactorization_faithful
    (permutation : Equiv.Perm (Fin 6))
    (centralizes : ∀ factor : Fin 5,
      permutation * sixPointFactor factor * permutation⁻¹ =
        sixPointFactor factor) :
    permutation = 1 := by
  have commutes (factor : Fin 5) :
      permutation * sixPointFactor factor =
        sixPointFactor factor * permutation := by
    calc
      permutation * sixPointFactor factor =
          (permutation * sixPointFactor factor * permutation⁻¹) *
            permutation := by group
      _ = sixPointFactor factor * permutation := by rw [centralizes factor]
  have action (factor : Fin 5) (point : Fin 6) :
      permutation (sixPointFactor factor point) =
        sixPointFactor factor (permutation point) := by
    exact DFunLike.congr_fun (commutes factor) point
  have initial : permutation 0 = 0 := by
    have atOneFromZero := action 0 0
    have atTwoFromOne := action 1 0
    have atThreeFromFour := action 4 2
    have atOneFromThree := action 3 3
    have atTwo : permutation 2 = sixPointFactor 1 (permutation 0) := by
      simpa [sixPointFactor, sixPointFactorTable] using atTwoFromOne
    have atThree : permutation 3 = sixPointFactor 4 (permutation 2) := by
      simpa [sixPointFactor, sixPointFactorTable] using atThreeFromFour
    have constraint :
        sixPointFactor 0 (permutation 0) =
          sixPointFactor 3
            (sixPointFactor 4 (sixPointFactor 1 (permutation 0))) := by
      calc
        sixPointFactor 0 (permutation 0) = permutation 1 := by
          simpa [sixPointFactor, sixPointFactorTable] using atOneFromZero.symm
        _ = sixPointFactor 3 (permutation 3) := by
          simpa [sixPointFactor, sixPointFactorTable] using atOneFromThree
        _ = sixPointFactor 3 (sixPointFactor 4 (permutation 2)) := by
          rw [atThree]
        _ = sixPointFactor 3
              (sixPointFactor 4 (sixPointFactor 1 (permutation 0))) := by
          rw [atTwo]
    generalize valueEquality : permutation 0 = value at constraint ⊢
    fin_cases value <;>
      simp [sixPointFactor, sixPointFactorTable] at constraint ⊢
  apply Equiv.ext
  intro point
  fin_cases point
  · exact initial
  · simpa [initial, sixPointFactor, sixPointFactorTable] using action 0 0
  · simpa [initial, sixPointFactor, sixPointFactorTable] using action 1 0
  · simpa [initial, sixPointFactor, sixPointFactorTable] using action 2 0
  · simpa [initial, sixPointFactor, sixPointFactorTable] using action 3 0
  · simpa [initial, sixPointFactor, sixPointFactorTable] using action 4 0

/-- Two generator words induce the same permutation of the six points exactly
when they induce the same permutation of the five factors.  This makes the
factor action a faithful realization of the six-point generated action. -/
theorem sixPointFactorWord_eq_iff_permutationWord_eq
    (left right : List Bool) :
    sixPointFactorWord left = sixPointFactorWord right ↔
      sixPointPermutationWord left = sixPointPermutationWord right := by
  constructor
  · intro factorEquality
    have centralizes : ∀ factor : Fin 5,
        ((sixPointPermutationWord right)⁻¹ * sixPointPermutationWord left) *
              sixPointFactor factor *
            ((sixPointPermutationWord right)⁻¹ *
              sixPointPermutationWord left)⁻¹ =
          sixPointFactor factor := by
      intro factor
      have leftConjugation := sixPointFactor_word_conjugation left factor
      have rightConjugation := sixPointFactor_word_conjugation right factor
      rw [factorEquality] at leftConjugation
      rw [← rightConjugation] at leftConjugation
      calc
        ((sixPointPermutationWord right)⁻¹ * sixPointPermutationWord left) *
                sixPointFactor factor *
              ((sixPointPermutationWord right)⁻¹ *
                sixPointPermutationWord left)⁻¹ =
            (sixPointPermutationWord right)⁻¹ *
              (sixPointPermutationWord left * sixPointFactor factor *
                (sixPointPermutationWord left)⁻¹) *
              sixPointPermutationWord right := by group
        _ = (sixPointPermutationWord right)⁻¹ *
              (sixPointPermutationWord right * sixPointFactor factor *
                (sixPointPermutationWord right)⁻¹) *
              sixPointPermutationWord right := by rw [leftConjugation]
        _ = sixPointFactor factor := by group
    have quotientTrivial := sixPointFactorization_faithful
      ((sixPointPermutationWord right)⁻¹ * sixPointPermutationWord left)
      centralizes
    have multiplied := congrArg
      (fun permutation => sixPointPermutationWord right * permutation)
      quotientTrivial
    simpa using multiplied
  · intro permutationEquality
    apply Equiv.ext
    intro factor
    apply sixPointFactor_injective
    have leftConjugation := sixPointFactor_word_conjugation left factor
    have rightConjugation := sixPointFactor_word_conjugation right factor
    rw [permutationEquality] at leftConjugation
    exact leftConjugation.symm.trans rightConjugation

/-- The generated six-point action is represented faithfully and onto by the
concrete alternating group on the five factors.  The first two clauses say
that the factor words are exactly `A₅`; the third says that this factor action
has precisely the same word kernel as the six-point action. -/
theorem sixPointGeneratedAction_realizes_alternatingGroup :
    (∀ word : List Bool,
      sixPointFactorWord word ∈ alternatingGroup (Fin 5)) ∧
    (∀ permutation : Equiv.Perm (Fin 5),
      permutation ∈ alternatingGroup (Fin 5) →
        ∃ word : List Bool, sixPointFactorWord word = permutation) ∧
    (∀ left right : List Bool,
      sixPointFactorWord left = sixPointFactorWord right ↔
        sixPointPermutationWord left = sixPointPermutationWord right) := by
  refine ⟨sixPointFactorWord_even, ?_, sixPointFactorWord_eq_iff_permutationWord_eq⟩
  intro permutation even
  exact (sixPointFactorNormalWords_complete permutation
    (Equiv.Perm.mem_alternatingGroup.mp even)).imp fun word existence => existence.2

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
