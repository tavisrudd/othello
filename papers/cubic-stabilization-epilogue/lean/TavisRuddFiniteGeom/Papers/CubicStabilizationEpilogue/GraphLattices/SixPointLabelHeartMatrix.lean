import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.SixPointOddLabelHeartAction

/-!
# The heart matrix of an arbitrary permutation of the six labels

Permuting the six labels acts on characteristic-two functions of the labels by
precomposition with the inverse permutation.  That action preserves the
augmentation hyperplane and the line of constant functions, hence descends to
the four-dimensional coefficient heart, the quotient of the augmentation
hyperplane by the constants in its normalized four-coordinate model.  This
module attaches to every permutation of the six labels the matrix of that
descended action.

Results.  The matrix of a permutation is defined by its action on the
normalized representatives of the four coordinate vectors, and it implements the
descended action on every vector of the augmentation hyperplane.  The
assignment is multiplicative and unital, so every such matrix is invertible with
the matrix of the inverse permutation as its two-sided inverse.  On the
displayed translation, the involution `x ↦ -1/x`, and scaling by the non-square
scalar of the labelling field it returns the three displayed heart matrices,
and on a word in those three generators it returns the word's heart matrix; on
the five transpositions of adjacent labels it returns the five matrices
displayed here, which generate the whole action because those transpositions
generate the symmetric group on the labels.

All matrix identities are closed finite equalities over the field with two
elements, checked by kernel reduction.  No native execution, external
certificate, or oracle is used.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace GraphLattices

open scoped Matrix

/-- The four labels carrying the heart coordinates: the heart coordinate of
index `i` is the difference of the values at label `i` and at the last label. -/
def sixPointHeartCoordinateLabel : Fin 4 → Fin 6 := ![0, 1, 2, 3]

/-- Each heart coordinate is the difference of two labelled values. -/
theorem sixPointHeartCoordinates_apply (vector : Fin 6 → F2) (index : Fin 4) :
    sixPointHeartCoordinates vector index =
      vector (sixPointHeartCoordinateLabel index) - vector 5 := by
  fin_cases index <;> rfl

/-- The normalized representative is linear in its heart coordinates: at every
label it is the corresponding combination of the representatives of the four
coordinate vectors. -/
theorem sixPointHeartRepresentative_expand (heart : Fin 4 → F2)
    (label : Fin 6) :
    sixPointHeartRepresentative heart label =
      ∑ index : Fin 4,
        heart index *
          sixPointHeartRepresentative (Pi.single index 1) label := by
  fin_cases label <;>
    simp [sixPointHeartRepresentative, Pi.single, Function.update,
      Fin.sum_univ_succ]

/-- The heart matrix of a permutation of the six labels: its columns are the
heart coordinates of the permuted normalized representatives of the four
coordinate vectors. -/
def sixPointHeartPermutationMatrix (permutation : Equiv.Perm (Fin 6)) :
    Matrix (Fin 4) (Fin 4) F2 :=
  Matrix.of fun row column ↦
    sixPointHeartCoordinates
      (sixPointHeartRepresentative (Pi.single column 1) ∘ permutation.symm) row

/-- The heart matrix implements the label action on normalized
representatives. -/
theorem sixPointHeartCoordinates_permutedRepresentative
    (permutation : Equiv.Perm (Fin 6)) (heart : Fin 4 → F2) :
    sixPointHeartCoordinates
        (sixPointHeartRepresentative heart ∘ permutation.symm) =
      Matrix.mulVec (sixPointHeartPermutationMatrix permutation) heart := by
  funext row
  rw [sixPointHeartCoordinates_apply]
  simp only [Function.comp_apply, Matrix.mulVec, dotProduct,
    sixPointHeartPermutationMatrix, Matrix.of_apply,
    sixPointHeartCoordinates_apply, Function.comp_apply]
  rw [sixPointHeartRepresentative_expand heart,
    sixPointHeartRepresentative_expand heart, ← Finset.sum_sub_distrib]
  exact Finset.sum_congr rfl fun column _ ↦ by ring

/-- The heart matrix implements the label action on every vector of the
augmentation hyperplane. -/
theorem sixPointHeartCoordinates_permutation
    (permutation : Equiv.Perm (Fin 6)) (vector : Fin 6 → F2)
    (augmentation : ∑ label, vector label = 0) :
    sixPointHeartCoordinates (vector ∘ permutation.symm) =
      Matrix.mulVec (sixPointHeartPermutationMatrix permutation)
        (sixPointHeartCoordinates vector) := by
  have decomposition :
      vector ∘ permutation.symm =
        fun label ↦
          (sixPointHeartRepresentative (sixPointHeartCoordinates vector) ∘
            permutation.symm) label + vector 5 := by
    funext label
    have pointwise :=
      congrFun (sixPointHeartRepresentative_coordinates vector augmentation)
        (permutation.symm label)
    show vector (permutation.symm label) = _
    simp only [Function.comp_apply]
    rw [pointwise, add_assoc, CharTwo.add_self_eq_zero, add_zero]
  rw [decomposition, sixPointHeartCoordinates_add_constant,
    sixPointHeartCoordinates_permutedRepresentative]

/-- Two heart matrices agreeing on every heart vector are equal. -/
theorem sixPointHeartMatrix_ext {left right : Matrix (Fin 4) (Fin 4) F2}
    (agreement : ∀ heart : Fin 4 → F2,
      Matrix.mulVec left heart = Matrix.mulVec right heart) :
    left = right := by
  ext row column
  have evaluated := congrFun (agreement (Pi.single column 1)) row
  simpa [Matrix.mulVec_single] using evaluated

/-- The identity permutation of the labels induces the identity heart
matrix. -/
theorem sixPointHeartPermutationMatrix_one :
    sixPointHeartPermutationMatrix 1 = 1 := by
  refine sixPointHeartMatrix_ext fun heart ↦ ?_
  rw [← sixPointHeartCoordinates_permutedRepresentative, Matrix.one_mulVec]
  exact sixPointHeartCoordinates_representative heart

/-- The heart matrix of a composite label permutation is the product of the
heart matrices. -/
theorem sixPointHeartPermutationMatrix_mul
    (left right : Equiv.Perm (Fin 6)) :
    sixPointHeartPermutationMatrix (left * right) =
      sixPointHeartPermutationMatrix left *
        sixPointHeartPermutationMatrix right := by
  refine sixPointHeartMatrix_ext fun heart ↦ ?_
  have augmentation :
      ∑ label,
          (sixPointHeartRepresentative heart ∘ right.symm) label = 0 := by
    simp only [Function.comp_apply]
    rw [Equiv.sum_comp right.symm (sixPointHeartRepresentative heart)]
    exact sixPointHeartRepresentative_sum_zero heart
  calc Matrix.mulVec (sixPointHeartPermutationMatrix (left * right)) heart
      = sixPointHeartCoordinates
          (sixPointHeartRepresentative heart ∘ (left * right).symm) :=
        (sixPointHeartCoordinates_permutedRepresentative _ _).symm
    _ = sixPointHeartCoordinates
          ((sixPointHeartRepresentative heart ∘ right.symm) ∘ left.symm) := rfl
    _ = Matrix.mulVec (sixPointHeartPermutationMatrix left)
          (sixPointHeartCoordinates
            (sixPointHeartRepresentative heart ∘ right.symm)) :=
        sixPointHeartCoordinates_permutation left _ augmentation
    _ = Matrix.mulVec (sixPointHeartPermutationMatrix left)
          (Matrix.mulVec (sixPointHeartPermutationMatrix right) heart) := by
        rw [sixPointHeartCoordinates_permutedRepresentative]
    _ = Matrix.mulVec (sixPointHeartPermutationMatrix left *
          sixPointHeartPermutationMatrix right) heart :=
        Matrix.mulVec_mulVec heart _ _

/-- The heart matrix of the inverse permutation is a two-sided inverse. -/
theorem sixPointHeartPermutationMatrix_mul_inverse
    (permutation : Equiv.Perm (Fin 6)) :
    sixPointHeartPermutationMatrix permutation *
        sixPointHeartPermutationMatrix permutation⁻¹ = 1 ∧
      sixPointHeartPermutationMatrix permutation⁻¹ *
        sixPointHeartPermutationMatrix permutation = 1 := by
  constructor
  · rw [← sixPointHeartPermutationMatrix_mul, mul_inv_cancel,
      sixPointHeartPermutationMatrix_one]
  · rw [← sixPointHeartPermutationMatrix_mul, inv_mul_cancel,
      sixPointHeartPermutationMatrix_one]

/-- The heart matrix of the displayed translation is the displayed translation
matrix. -/
theorem sixPointHeartPermutationMatrix_translation :
    sixPointHeartPermutationMatrix sixPointTranslationPermutation =
      sixPointHeartTranslation := by
  refine sixPointHeartMatrix_ext fun heart ↦ ?_
  rw [← sixPointHeartCoordinates_permutedRepresentative]
  exact sixPointHeartCoordinates_translation heart

/-- The heart matrix of the displayed involution is the displayed inversion
matrix. -/
theorem sixPointHeartPermutationMatrix_inversion :
    sixPointHeartPermutationMatrix sixPointInversionPermutation =
      sixPointHeartInversion := by
  refine sixPointHeartMatrix_ext fun heart ↦ ?_
  rw [← sixPointHeartCoordinates_permutedRepresentative]
  exact sixPointHeartCoordinates_inversion heart

/-- The heart matrix of scaling by the non-square scalar is the displayed
scaling matrix. -/
theorem sixPointHeartPermutationMatrix_scaling :
    sixPointHeartPermutationMatrix sixPointScalingPermutation =
      sixPointHeartScaling := by
  refine sixPointHeartMatrix_ext fun heart ↦ ?_
  rw [← sixPointHeartCoordinates_permutedRepresentative]
  exact sixPointHeartCoordinates_scaling heart

/-- The heart matrix of a displayed generator is the displayed generator
matrix. -/
theorem sixPointHeartPermutationMatrix_generator (letter : Fin 3) :
    sixPointHeartPermutationMatrix (sixPointLabelGenerator letter) =
      sixPointHeartGeneratorMatrix letter := by
  fin_cases letter
  · exact sixPointHeartPermutationMatrix_translation
  · exact sixPointHeartPermutationMatrix_inversion
  · exact sixPointHeartPermutationMatrix_scaling

/-- The heart matrix of the label permutation of a word is the word's heart
matrix. -/
theorem sixPointHeartPermutationMatrix_labelWord (word : List (Fin 3)) :
    sixPointHeartPermutationMatrix (sixPointLabelWordPermutation word) =
      sixPointHeartLabelWordMatrix word := by
  induction word with
  | nil =>
      rw [sixPointLabelWordPermutation, sixPointHeartLabelWordMatrix,
        sixPointHeartPermutationMatrix_one]
  | cons letter word induction =>
      rw [sixPointLabelWordPermutation, sixPointHeartLabelWordMatrix,
        sixPointHeartPermutationMatrix_mul,
        sixPointHeartPermutationMatrix_generator, induction]

/-- The five heart matrices of the transpositions of adjacent labels. -/
def sixPointHeartAdjacentTransposition : Fin 5 → Matrix (Fin 4) (Fin 4) F2 :=
  ![!![0, 1, 0, 0;
      1, 0, 0, 0;
      0, 0, 1, 0;
      0, 0, 0, 1],
    !![1, 0, 0, 0;
      0, 0, 1, 0;
      0, 1, 0, 0;
      0, 0, 0, 1],
    !![1, 0, 0, 0;
      0, 1, 0, 0;
      0, 0, 0, 1;
      0, 0, 1, 0],
    !![1, 0, 0, 0;
      0, 1, 0, 0;
      0, 0, 1, 0;
      1, 1, 1, 1],
    !![0, 1, 1, 1;
      1, 0, 1, 1;
      1, 1, 0, 1;
      1, 1, 1, 0]]

/-- The heart matrix of the transposition of two adjacent labels is the
displayed matrix of that transposition. -/
theorem sixPointHeartPermutationMatrix_adjacentTransposition (index : Fin 5) :
    sixPointHeartPermutationMatrix
        (Equiv.swap index.castSucc index.succ) =
      sixPointHeartAdjacentTransposition index := by
  fin_cases index <;> decide

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
