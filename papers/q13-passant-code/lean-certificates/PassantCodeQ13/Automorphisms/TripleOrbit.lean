import PassantCodeQ13.Automorphisms.Base
import PassantCodeQ13.SymmetricSquareInvariance

/-!
# Regular projective orbit of the first three anchors

The 2184 normalized invertible matrices act bijectively on the 78 internal coordinates and preserve
the polar relation.  Both statements are proved from the transformation laws of the discriminant and
its polar form under substitution, so neither quantifies over the matrices by evaluation.

Native evaluation remains in this module for the relation pattern `(10,3,9)` of the first three
anchors, the length of the normalized matrix list, and the identification of the images of the first
three anchors with the ordered triples carrying that pattern.  The last check also records that all
2184 images are distinct, so this is the regular triple orbit used by the automorphism argument.
Each of those three theorems therefore carries the declaration-local axiom that compiled evaluation
introduces.
-/

namespace PassantCodeQ13.Automorphisms

open RelativeConicArcs.PassantCodeQ13
open PassantCodeQ13.AssociationAlgebra
open PassantCodeQ13.MinimumWords
open PassantCodeQ13.WeightTen

/-- The first three displayed anchors have relation pattern `(10,3,9)`. -/
theorem anchorTriplePattern :
    rhoAt (anchors 0) (anchors 1) = 10 ∧ rhoAt (anchors 0) (anchors 2) = 3 ∧
      rhoAt (anchors 1) (anchors 2) = 9 := by
  native_decide

/-- The normalized projective matrix list has the order of `PGL(2,13)`. -/
theorem projectiveMatrices_length :
    PassantCodeQ13.MinimumWords.projectiveMatrices.length = 2184 := by
  native_decide

/-- Every normalized symmetric-square matrix action is a permutation of the internal points.

Injectivity is the coordinate statement that substitution by a matrix of nonzero determinant is
injective on normalized representatives, which follows from the adjugate identity; surjectivity is
injectivity on a finite type. -/
theorem matrixAction_bijective (matrix : Fin PassantCodeQ13.MinimumWords.projectiveMatrices.length) :
    Function.Bijective (matrixAction matrix) := by
  have matrix_mem := List.get_mem PassantCodeQ13.MinimumWords.projectiveMatrices matrix
  refine Finite.injective_iff_bijective.mp ?_
  intro first second equal_images
  have first_mem := SymmetricSquare.internalAt_mem_internalCoordinateList first
  have second_mem := SymmetricSquare.internalAt_mem_internalCoordinateList second
  have first_acted := SymmetricSquare.act_mem_internalCoordinateList matrix_mem first_mem
  have second_acted := SymmetricSquare.act_mem_internalCoordinateList matrix_mem second_mem
  have coordinates :
      act (PassantCodeQ13.MinimumWords.projectiveMatrices.get matrix) (internalAt first.val) =
        act (PassantCodeQ13.MinimumWords.projectiveMatrices.get matrix) (internalAt second.val) := by
    have transported := congrArg (fun index : Coordinate => internalAt index.val) equal_images
    rwa [SymmetricSquare.internalAt_ofNat_internalIndex first_acted,
      SymmetricSquare.internalAt_ofNat_internalIndex second_acted] at transported
  exact SymmetricSquare.internalAt_injective first second
    (SymmetricSquare.act_injective_on_internalCoordinateList matrix_mem first_mem second_mem
      coordinates)

/-- Every normalized symmetric-square matrix action preserves the polar relation.

The polar form and the discriminant both acquire the factor `(det M)²` under substitution, and the
normalized parameter is bi-homogeneous of degree zero, so the parameter is unchanged. -/
theorem matrixAction_preservesRho
    (matrix : Fin PassantCodeQ13.MinimumWords.projectiveMatrices.length) :
    PreservesRho (matrixAction matrix) := by
  intro first second
  have matrix_mem := List.get_mem PassantCodeQ13.MinimumWords.projectiveMatrices matrix
  have first_mem := SymmetricSquare.internalAt_mem_internalCoordinateList first
  have second_mem := SymmetricSquare.internalAt_mem_internalCoordinateList second
  have first_acted := SymmetricSquare.act_mem_internalCoordinateList matrix_mem first_mem
  have second_acted := SymmetricSquare.act_mem_internalCoordinateList matrix_mem second_mem
  have first_nondegenerate :=
    ((SymmetricSquare.mem_internalCoordinateList_iff _).mp first_mem).2.1
  have second_nondegenerate :=
    ((SymmetricSquare.mem_internalCoordinateList_iff _).mp second_mem).2.1
  rw [SymmetricSquare.rhoAt_eq_polarInvariant, SymmetricSquare.rhoAt_eq_polarInvariant,
    SymmetricSquare.internalAt_ofNat_internalIndex first_acted,
    SymmetricSquare.internalAt_ofNat_internalIndex second_acted]
  exact SymmetricSquare.polarInvariant_act
    (SymmetricSquare.determinant_ne_zero_of_mem matrix_mem) first_nondegenerate
    second_nondegenerate

/-- The projective images of the first three anchors are exactly the triples of pattern
`(10,3,9)`, and all 2184 images are distinct. -/
theorem projectiveAnchorTriples_eq_patterned :
    projectiveAnchorTriples = patternedTriples ∧ projectiveAnchorTriples.card = 2184 := by
  native_decide

end PassantCodeQ13.Automorphisms
