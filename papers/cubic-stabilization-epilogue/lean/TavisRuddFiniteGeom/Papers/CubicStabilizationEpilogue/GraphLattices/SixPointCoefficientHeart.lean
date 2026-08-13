import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.PrincipalGluingPacket

/-!
# A six-point characteristic-two coefficient heart

This module gives explicit coordinates for the quotient of the augmentation
hyperplane in `F₂⁶` by its constant line.  Two permutations of the six
coordinates induce displayed four-dimensional matrices.  Kernel reduction of
the displayed matrix equations shows that their common matrix commutant has
the four elements
`0`, `1`, `W`, and `W+1`, where `W²+W+1=0`.

All proofs are symbolic, apart from closed entrywise normalization in `F₂`;
the module invokes neither native code nor an external certificate or oracle.

The construction is a concrete six-point modular representation.  This module
does not identify its generated permutation group with the manuscript's
specific `A5` action on the six conjugate `D5` subgroups, and therefore does
not by itself identify this commutant with the geometric coefficient heart.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

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

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
