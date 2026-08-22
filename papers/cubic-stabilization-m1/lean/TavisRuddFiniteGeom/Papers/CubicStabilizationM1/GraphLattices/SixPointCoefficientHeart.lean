import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.PrincipalGluingPacket

/-!
# A six-point characteristic-two coefficient heart

This module gives explicit coordinates for the quotient of the augmentation
hyperplane in `F₂⁶` by its constant line.  Two permutations of the six
coordinates induce displayed four-dimensional matrices.  Kernel reduction of
the displayed matrix equations shows that their common matrix commutant has
the four elements
`0`, `1`, `W`, and `W+1`, where `W²+W+1=0`.

All matrix identities are symbolic apart from closed entrywise normalization
in `F₂`.  An ordinary kernel-reduced check over the sixteen heart vectors
supplies a short normalizing word for each nonzero vector; the resulting
subspace argument proves simplicity.  The module invokes neither native code
nor an external certificate or oracle.

The construction is a concrete simple six-point modular representation.  This
module does not identify its generated permutation group with the manuscript's
specific `A5` action on the six conjugate `D5` subgroups, and therefore does
not by itself identify this representation and commutant with the geometric
coefficient heart.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace GraphLattices

open scoped Matrix

abbrev F2 := ZMod 2

/-- Canonical four coordinates for the six-point augmentation quotient: first
subtract coordinate five, then retain coordinates zero through three. -/
def sixPointHeartCoordinates (vector : Fin 6 → F2) : Fin 4 → F2 :=
  ![vector 0 - vector 5, vector 1 - vector 5,
    vector 2 - vector 5, vector 3 - vector 5]

/-- The normalized augmentation representative attached to four heart
coordinates.  Its fifth coordinate is zero and its fourth coordinate is the
sum of the first four. -/
def sixPointHeartRepresentative (heart : Fin 4 → F2) : Fin 6 → F2 :=
  ![heart 0, heart 1, heart 2, heart 3, ∑ index, heart index, 0]

/-- Every normalized representative belongs to the augmentation hyperplane. -/
theorem sixPointHeartRepresentative_sum_zero (heart : Fin 4 → F2) :
    ∑ point, sixPointHeartRepresentative heart point = 0 := by
  simp [sixPointHeartRepresentative, Fin.sum_univ_succ]
  have characteristicTwo : (2 : F2) = 0 := by decide
  linear_combination characteristicTwo *
    (heart 0 + heart 1 + heart 2 + heart 3)

/-- Normalized representatives recover their four heart coordinates. -/
theorem sixPointHeartCoordinates_representative (heart : Fin 4 → F2) :
    sixPointHeartCoordinates (sixPointHeartRepresentative heart) = heart := by
  ext index
  fin_cases index <;> simp [sixPointHeartCoordinates,
    sixPointHeartRepresentative]

/-- On the augmentation hyperplane, zero heart coordinate means precisely a
constant six-coordinate vector. -/
theorem sixPointHeartCoordinates_eq_zero_iff_constant
    (vector : Fin 6 → F2) (augmentation : ∑ point, vector point = 0) :
    sixPointHeartCoordinates vector = 0 ↔
      ∀ point, vector point = vector 5 := by
  constructor
  · intro zero point
    have coordinate (index : Fin 4) :
        vector ⟨index, by omega⟩ = vector 5 := by
      have equality := congrFun zero index
      fin_cases index <;>
        simpa [sixPointHeartCoordinates, sub_eq_zero] using equality
    fin_cases point
    · exact coordinate 0
    · exact coordinate 1
    · exact coordinate 2
    · exact coordinate 3
    · change vector 4 = vector 5
      have sumExpanded : vector 0 + (vector 1 + (vector 2 +
          (vector 3 + (vector 4 + vector 5)))) = 0 := by
        simpa [Fin.sum_univ_succ] using augmentation
      rw [show vector 0 = vector 5 by exact coordinate 0,
        show vector 1 = vector 5 by exact coordinate 1,
        show vector 2 = vector 5 by exact coordinate 2,
        show vector 3 = vector 5 by exact coordinate 3] at sumExpanded
      have characteristicTwo : (2 : F2) = 0 := by decide
      rw [← sub_eq_zero]
      linear_combination sumExpanded - characteristicTwo * (3 * vector 5)
    · simp
  · intro constant
    funext index
    have equality : vector ⟨index, by omega⟩ = vector 5 :=
      constant ⟨index, by omega⟩
    fin_cases index <;>
      simpa [sixPointHeartCoordinates, sub_eq_zero] using equality

/-- Inverse translation on the six-point projective-line labelling
`0,1,2,3,4,∞`. -/
def sixPointTranslationPreimage : Fin 6 → Fin 6 := ![4, 0, 1, 2, 3, 5]

/-- The involution `x ↦ -1/x` on the six-point projective-line labelling
over `F5`, written as the preimage permutation. -/
def sixPointInversionPreimage : Fin 6 → Fin 6 := ![5, 4, 2, 3, 1, 0]

/-- Translation on the six-point projective-line labelling. -/
def sixPointTranslationPermutation : Equiv.Perm (Fin 6) where
  toFun := ![1, 2, 3, 4, 0, 5]
  invFun := sixPointTranslationPreimage
  left_inv point := by fin_cases point <;> decide
  right_inv point := by fin_cases point <;> decide

/-- Inversion on the six-point projective-line labelling. -/
def sixPointInversionPermutation : Equiv.Perm (Fin 6) where
  toFun := sixPointInversionPreimage
  invFun := sixPointInversionPreimage
  left_inv point := by fin_cases point <;> decide
  right_inv point := by fin_cases point <;> decide

/-- The induced translation matrix on the normalized four-dimensional
characteristic-two heart. -/
def sixPointHeartTranslation : Matrix (Fin 4) (Fin 4) F2 :=
  !![1, 1, 1, 1;
     1, 0, 0, 0;
     0, 1, 0, 0;
     0, 0, 1, 0]

/-- The induced inversion matrix on the normalized four-dimensional
characteristic-two heart. -/
def sixPointHeartInversion : Matrix (Fin 4) (Fin 4) F2 :=
  !![1, 0, 0, 0;
     0, 1, 1, 1;
     1, 0, 1, 0;
     1, 0, 0, 1]

/-- Apply a word in the translation (`false`) and inversion (`true`)
generators to a heart vector. -/
def sixPointHeartWordAction : List Bool → (Fin 4 → F2) → (Fin 4 → F2)
  | [], vector => vector
  | generator :: word, vector =>
      sixPointHeartWordAction word
        (Matrix.mulVec (if generator then sixPointHeartInversion
          else sixPointHeartTranslation) vector)

/-- The matrix of a word in the translation and inversion generators. -/
def sixPointHeartWordMatrix : List Bool → Matrix (Fin 4) (Fin 4) F2
  | [] => 1
  | generator :: word =>
      sixPointHeartWordMatrix word *
        (if generator then sixPointHeartInversion
          else sixPointHeartTranslation)

/-- The recursively defined word action is multiplication by its word
matrix. -/
theorem sixPointHeartWordAction_eq_mulVec (word : List Bool)
    (vector : Fin 4 → F2) :
    sixPointHeartWordAction word vector =
      Matrix.mulVec (sixPointHeartWordMatrix word) vector := by
  induction word generalizing vector with
  | nil => simp [sixPointHeartWordAction, sixPointHeartWordMatrix]
  | cons generator word induction =>
      simp only [sixPointHeartWordAction, sixPointHeartWordMatrix]
      rw [induction, Matrix.mulVec_mulVec]

/-- A finite list of words that sends every nonzero heart vector to the first
standard basis vector. -/
def sixPointHeartNormalizingWords : List (List Bool) :=
  [[], [false, false, true, false], [false, false, false, false],
    [true, false, false, false], [false, true, false],
    [false, false, false], [false, false, false, true], [false],
    [false, false, false, true, false], [true, false],
    [true, false, true, false], [false, false], [true],
    [false, true], [false, false, true]]

/-- The displayed word list covers every nonzero vector of the sixteen-element
heart.  This closed finite statement is checked by kernel reduction. -/
theorem sixPointHeartNormalizingWords_covers (vector : Fin 4 → F2)
    (nonzero : vector ≠ 0) :
    ∃ word ∈ sixPointHeartNormalizingWords,
      sixPointHeartWordAction word vector = ![1, 0, 0, 0] := by
  revert vector
  decide

/-- Stability under the two displayed generator matrices. -/
def SixPointHeartGeneratorStable
    (subspace : Submodule F2 (Fin 4 → F2)) : Prop :=
  (∀ vector ∈ subspace,
    Matrix.mulVec sixPointHeartTranslation vector ∈ subspace) ∧
  (∀ vector ∈ subspace,
    Matrix.mulVec sixPointHeartInversion vector ∈ subspace)

/-- A generator-stable subspace is stable under every generator word. -/
theorem sixPointHeartGeneratorStable_word
    (subspace : Submodule F2 (Fin 4 → F2))
    (stable : SixPointHeartGeneratorStable subspace)
    (word : List Bool) (vector : Fin 4 → F2) (member : vector ∈ subspace) :
    sixPointHeartWordAction word vector ∈ subspace := by
  induction word generalizing vector with
  | nil => exact member
  | cons generator word induction =>
      apply induction
      by_cases inversion : generator
      · simpa [inversion] using stable.2 vector member
      · simpa [inversion] using stable.1 vector member

/-- The explicit four-dimensional heart is simple for the action generated by
translation and inversion: a stable subspace is zero or the whole heart. -/
theorem sixPointHeartGeneratorStable_simple
    (subspace : Submodule F2 (Fin 4 → F2))
    (stable : SixPointHeartGeneratorStable subspace) :
    subspace = ⊥ ∨ subspace = ⊤ := by
  by_cases zero : subspace = ⊥
  · exact Or.inl zero
  · right
    obtain ⟨⟨vector, member⟩, nonzero⟩ := Submodule.nonzero_mem_of_bot_lt
      (bot_lt_iff_ne_bot.mpr zero)
    have vectorNonzero : vector ≠ 0 := by
      intro vectorZero
      apply nonzero
      apply Subtype.ext
      exact vectorZero
    obtain ⟨word, _, normalized⟩ :=
      sixPointHeartNormalizingWords_covers vector vectorNonzero
    have firstBasis : ![1, 0, 0, 0] ∈ subspace := by
      rw [← normalized]
      exact sixPointHeartGeneratorStable_word subspace stable word vector member
    have secondBasis : ![0, 1, 0, 0] ∈ subspace := by
      have transformed := sixPointHeartGeneratorStable_word subspace stable
        [false, false, true, false, false] ![1, 0, 0, 0] firstBasis
      have actionEquality : sixPointHeartWordAction
          [false, false, true, false, false] ![1, 0, 0, 0] =
          ![0, 1, 0, 0] := by decide
      rw [← actionEquality]
      exact transformed
    have thirdBasis : ![0, 0, 1, 0] ∈ subspace := by
      have transformed := sixPointHeartGeneratorStable_word subspace stable
        [false, false, true] ![1, 0, 0, 0] firstBasis
      have actionEquality : sixPointHeartWordAction
          [false, false, true] ![1, 0, 0, 0] = ![0, 0, 1, 0] := by decide
      rw [← actionEquality]
      exact transformed
    have fourthBasis : ![0, 0, 0, 1] ∈ subspace := by
      have transformed := sixPointHeartGeneratorStable_word subspace stable
        [false, false, false, false] ![1, 0, 0, 0] firstBasis
      have actionEquality : sixPointHeartWordAction
          [false, false, false, false] ![1, 0, 0, 0] =
          ![0, 0, 0, 1] := by decide
      rw [← actionEquality]
      exact transformed
    apply top_unique
    intro arbitrary _
    have decomposition : arbitrary =
        arbitrary 0 • ![1, 0, 0, 0] + arbitrary 1 • ![0, 1, 0, 0] +
        arbitrary 2 • ![0, 0, 1, 0] + arbitrary 3 • ![0, 0, 0, 1] := by
      ext index
      fin_cases index <;> simp
    rw [decomposition]
    exact subspace.add_mem
      (subspace.add_mem
        (subspace.add_mem (subspace.smul_mem _ firstBasis)
          (subspace.smul_mem _ secondBasis))
        (subspace.smul_mem _ thirdBasis))
      (subspace.smul_mem _ fourthBasis)

/-- Permuting a normalized representative by inverse translation induces the
displayed translation matrix on heart coordinates. -/
theorem sixPointHeartCoordinates_translation (heart : Fin 4 → F2) :
    sixPointHeartCoordinates
        (sixPointHeartRepresentative heart ∘ sixPointTranslationPreimage) =
      Matrix.mulVec sixPointHeartTranslation heart := by
  ext index
  fin_cases index <;>
    simp [sixPointHeartCoordinates, sixPointHeartRepresentative,
      sixPointTranslationPreimage, sixPointHeartTranslation,
      Matrix.mulVec, dotProduct, Fin.sum_univ_succ, CharTwo.sub_eq_add]

/-- Permuting a normalized representative by the inverse of `x ↦ -1/x`
induces the displayed inversion matrix on heart coordinates. -/
theorem sixPointHeartCoordinates_inversion (heart : Fin 4 → F2) :
    sixPointHeartCoordinates
        (sixPointHeartRepresentative heart ∘ sixPointInversionPreimage) =
      Matrix.mulVec sixPointHeartInversion heart := by
  ext index
  fin_cases index <;>
    simp [sixPointHeartCoordinates, sixPointHeartRepresentative,
      sixPointInversionPreimage, sixPointHeartInversion,
      Matrix.mulVec, dotProduct, Fin.sum_univ_succ, CharTwo.sub_eq_add]
  all_goals ring_nf
  all_goals simp [show (2 : F2) = 0 by decide]

/-- A distinguished nontrivial element of the common commutant. -/
def sixPointHeartCommutantRoot : Matrix (Fin 4) (Fin 4) F2 :=
  !![0, 0, 1, 1;
     1, 1, 1, 0;
     0, 1, 1, 1;
     1, 1, 0, 0]

/-- The distinguished commutant element satisfies the irreducible quadratic
relation `W²+W+1=0`. -/
theorem sixPointHeartCommutantRoot_quadratic :
    sixPointHeartCommutantRoot ^ 2 + sixPointHeartCommutantRoot + 1 = 0 := by
  ext row column
  fin_cases row <;> fin_cases column <;>
    decide

/-- The common matrix commutant of the two six-point heart generators has
exactly four elements, written as the quadratic algebra generated by `W`. -/
theorem sixPointHeart_commonCommutant_classification
    (matrix : Matrix (Fin 4) (Fin 4) F2) :
    (matrix * sixPointHeartTranslation = sixPointHeartTranslation * matrix ∧
      matrix * sixPointHeartInversion = sixPointHeartInversion * matrix) ↔
      matrix = 0 ∨ matrix = 1 ∨ matrix = sixPointHeartCommutantRoot ∨
        matrix = sixPointHeartCommutantRoot + 1 := by
  constructor
  · rintro ⟨commutesTranslation, commutesInversion⟩
    have t00 := congrArg (fun value => value 0 0) commutesTranslation
    have t01 := congrArg (fun value => value 0 1) commutesTranslation
    have t02 := congrArg (fun value => value 0 2) commutesTranslation
    have t03 := congrArg (fun value => value 0 3) commutesTranslation
    have t10 := congrArg (fun value => value 1 0) commutesTranslation
    have t11 := congrArg (fun value => value 1 1) commutesTranslation
    have t12 := congrArg (fun value => value 1 2) commutesTranslation
    have t13 := congrArg (fun value => value 1 3) commutesTranslation
    have t20 := congrArg (fun value => value 2 0) commutesTranslation
    have t21 := congrArg (fun value => value 2 1) commutesTranslation
    have t22 := congrArg (fun value => value 2 2) commutesTranslation
    have t23 := congrArg (fun value => value 2 3) commutesTranslation
    have s00 := congrArg (fun value => value 0 0) commutesInversion
    have s02 := congrArg (fun value => value 0 2) commutesInversion
    simp [Matrix.mul_apply, sixPointHeartTranslation,
      Fin.sum_univ_succ] at t00
    simp [Matrix.mul_apply, sixPointHeartTranslation,
      Fin.sum_univ_succ] at t01
    simp [Matrix.mul_apply, sixPointHeartTranslation,
      Fin.sum_univ_succ] at t02
    simp [Matrix.mul_apply, sixPointHeartTranslation,
      Fin.sum_univ_succ] at t03
    simp [Matrix.mul_apply, sixPointHeartTranslation,
      Fin.sum_univ_succ] at t10
    simp [Matrix.mul_apply, sixPointHeartTranslation,
      Fin.sum_univ_succ] at t11
    simp [Matrix.mul_apply, sixPointHeartTranslation,
      Fin.sum_univ_succ] at t12
    simp [Matrix.mul_apply, sixPointHeartTranslation,
      Fin.sum_univ_succ] at t13
    simp [Matrix.mul_apply, sixPointHeartTranslation,
      Fin.sum_univ_succ] at t20
    simp [Matrix.mul_apply, sixPointHeartTranslation,
      Fin.sum_univ_succ] at t21
    simp [Matrix.mul_apply, sixPointHeartTranslation,
      Fin.sum_univ_succ] at t22
    simp [Matrix.mul_apply, sixPointHeartTranslation,
      Fin.sum_univ_succ] at t23
    simp [Matrix.mul_apply, sixPointHeartInversion,
      Fin.sum_univ_succ] at s00
    simp [Matrix.mul_apply, sixPointHeartInversion,
      Fin.sum_univ_succ] at s02
    have characteristicTwo : (2 : F2) = 0 := by decide
    have normalForm : matrix =
        !![matrix 0 0, 0, matrix 0 2, matrix 0 2;
           matrix 0 2, matrix 0 0 + matrix 0 2, matrix 0 2, 0;
           0, matrix 0 2, matrix 0 0 + matrix 0 2, matrix 0 2;
           matrix 0 2, matrix 0 2, 0, matrix 0 0] := by
      ext row column
      fin_cases row <;> fin_cases column
      · rfl
      · change matrix 0 1 = 0
        linear_combination s02
      · rfl
      · change matrix 0 3 = matrix 0 2
        linear_combination s00 - characteristicTwo * matrix 0 2
      · change matrix 1 0 = matrix 0 2
        linear_combination t13 + s00 - characteristicTwo * matrix 0 2
      · change matrix 1 1 = matrix 0 0 + matrix 0 2
        linear_combination t10 + t13 + s00 -
          characteristicTwo * (matrix 0 2 + matrix 1 0)
      · change matrix 1 2 = matrix 0 2
        linear_combination t11 + t13 + s00 + s02 -
          characteristicTwo * (matrix 0 2 + matrix 1 0)
      · change matrix 1 3 = 0
        linear_combination t12 + t13 + s00 - characteristicTwo * matrix 1 0
      · change matrix 2 0 = 0
        linear_combination t12 + t13 + t23 + s00 -
          characteristicTwo * matrix 1 0
      · change matrix 2 1 = matrix 0 2
        linear_combination t12 + t20 + t23 - characteristicTwo * matrix 2 0
      · change matrix 2 2 = matrix 0 0 + matrix 0 2
        linear_combination t10 + t12 + t21 + t23 -
          characteristicTwo * (matrix 1 0 + matrix 2 0)
      · change matrix 2 3 = matrix 0 2
        linear_combination t11 + t12 + t22 + t23 + s02 -
          characteristicTwo * (matrix 1 0 + matrix 2 0)
      · change matrix 3 0 = matrix 0 2
        linear_combination t00 + t12 + t23 + s02 +
          characteristicTwo * (matrix 3 0 - matrix 0 1)
      · change matrix 3 1 = matrix 0 2
        linear_combination t01 + t10 + t12 + t13 + t20 + t23 + s00 + s02 +
          characteristicTwo *
            (matrix 3 1 - matrix 0 2 - matrix 1 0 - matrix 2 0)
      · change matrix 3 2 = 0
        linear_combination t02 + t10 + t11 + t12 + t13 + t21 + t23 + s02 +
          characteristicTwo *
            (matrix 3 2 + matrix 0 2 - 2 * matrix 1 0 - matrix 2 0)
      · change matrix 3 3 = matrix 0 0
        linear_combination t03 + t11 + t13 + t22 + t23 + s02 +
          characteristicTwo *
            (matrix 3 3 + matrix 0 3 + matrix 1 3 - matrix 0 0 -
              matrix 1 0 - matrix 2 0)
    have entryCases (value : F2) : value = 0 ∨ value = 1 := by
      have valueRange : value.val = 0 ∨ value.val = 1 := by
        have := value.val_lt
        omega
      rcases valueRange with valueZero | valueOne
      · left
        apply ZMod.val_injective 2
        simpa using valueZero
      · right
        apply ZMod.val_injective 2
        rw [valueOne]
        decide
    rcases entryCases (matrix 0 0) with diagonalZero | diagonalOne <;>
      rcases entryCases (matrix 0 2) with rootZero | rootOne
    · left
      rw [normalForm, diagonalZero, rootZero]
      ext row column
      fin_cases row <;> fin_cases column <;> decide
    · right; right; left
      rw [normalForm, diagonalZero, rootOne]
      ext row column
      fin_cases row <;> fin_cases column <;> decide
    · right; left
      rw [normalForm, diagonalOne, rootZero]
      ext row column
      fin_cases row <;> fin_cases column <;> decide
    · right; right; right
      rw [normalForm, diagonalOne, rootOne]
      ext row column
      fin_cases row <;> fin_cases column <;> decide
  · rintro (rfl | rfl | rfl | rfl) <;>
      constructor <;> ext row column <;>
      fin_cases row <;> fin_cases column <;> decide

/-- A matrix commutes with the entire generated six-point heart action exactly
when it commutes with the two displayed generators. -/
theorem sixPointHeart_commutes_all_words_iff
    (matrix : Matrix (Fin 4) (Fin 4) F2) :
    (∀ word : List Bool,
      matrix * sixPointHeartWordMatrix word =
        sixPointHeartWordMatrix word * matrix) ↔
      matrix * sixPointHeartTranslation =
          sixPointHeartTranslation * matrix ∧
        matrix * sixPointHeartInversion =
          sixPointHeartInversion * matrix := by
  constructor
  · intro commutes
    constructor
    · simpa [sixPointHeartWordMatrix] using commutes [false]
    · simpa [sixPointHeartWordMatrix] using commutes [true]
  · rintro ⟨commutesTranslation, commutesInversion⟩ word
    induction word with
    | nil => simp [sixPointHeartWordMatrix]
    | cons generator word induction =>
        simp only [sixPointHeartWordMatrix]
        have commutesGenerator :
            matrix *
                (if generator then sixPointHeartInversion
                  else sixPointHeartTranslation) =
              (if generator then sixPointHeartInversion
                else sixPointHeartTranslation) * matrix := by
          by_cases inversion : generator
          · simpa [inversion] using commutesInversion
          · simpa [inversion] using commutesTranslation
        calc
          matrix *
                (sixPointHeartWordMatrix word *
                  (if generator then sixPointHeartInversion
                    else sixPointHeartTranslation)) =
              (matrix * sixPointHeartWordMatrix word) *
                (if generator then sixPointHeartInversion
                  else sixPointHeartTranslation) := by rw [mul_assoc]
          _ = (sixPointHeartWordMatrix word * matrix) *
                (if generator then sixPointHeartInversion
                  else sixPointHeartTranslation) := by rw [induction]
          _ = sixPointHeartWordMatrix word *
                (matrix *
                  (if generator then sixPointHeartInversion
                    else sixPointHeartTranslation)) := by rw [mul_assoc]
          _ = sixPointHeartWordMatrix word *
                ((if generator then sixPointHeartInversion
                    else sixPointHeartTranslation) * matrix) := by
              rw [commutesGenerator]
          _ = (sixPointHeartWordMatrix word *
                (if generator then sixPointHeartInversion
                  else sixPointHeartTranslation)) * matrix := by rw [mul_assoc]

/-- The commutant of the full generated heart action is the same four-element
quadratic algebra as the common commutant of the two generators. -/
theorem sixPointHeart_fullActionCommutant_classification
    (matrix : Matrix (Fin 4) (Fin 4) F2) :
    (∀ word : List Bool,
      matrix * sixPointHeartWordMatrix word =
        sixPointHeartWordMatrix word * matrix) ↔
      matrix = 0 ∨ matrix = 1 ∨
        matrix = sixPointHeartCommutantRoot ∨
          matrix = sixPointHeartCommutantRoot + 1 := by
  rw [sixPointHeart_commutes_all_words_iff,
    sixPointHeart_commonCommutant_classification]

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
