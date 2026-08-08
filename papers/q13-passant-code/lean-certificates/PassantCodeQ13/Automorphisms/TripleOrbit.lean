import PassantCodeQ13.Automorphisms.AnchorOrbit

/-!
# Regular projective orbit of the first three anchors

The 2184 normalized invertible matrices act bijectively on the 78 internal coordinates and preserve
the polar relation.  Both statements are proved from the transformation laws of the discriminant and
its polar form under substitution, so neither quantifies over the matrices by evaluation.

The relation pattern `(10,3,9)` of the first three anchors and the length of the normalized matrix
list are decided by kernel reduction, the first over three pairs of coordinates and the second over
the displayed matrix list.  The images of the first three anchors are then identified with the
ordered triples carrying that pattern.  One inclusion is the invariance of the relation; the other
and the count of the images come from the two kernel-reduced checks of
`PassantCodeQ13.Automorphisms.AnchorOrbit`, so the orbit is regular and no terminal of this module
carries a compiled-evaluation axiom.
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
  decide +kernel

/-- The normalized projective matrix list has the order of `PGL(2,13)`. -/
theorem projectiveMatrices_length :
    PassantCodeQ13.MinimumWords.projectiveMatrices.length = 2184 := by
  decide +kernel

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
    -- The indexed action is the coordinate action followed by re-indexing, and the transport
    -- lemma is stated about that re-indexing, so the index map is expanded before rewriting.
    simp only [matrixAction] at transported
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
  rw [SymmetricSquare.rhoAt_eq_polarInvariant, SymmetricSquare.rhoAt_eq_polarInvariant]
  -- The indexed action is expanded here too, so that the transport lemma applies to the
  -- re-indexing it is stated about.
  simp only [matrixAction]
  rw [SymmetricSquare.internalAt_ofNat_internalIndex first_acted,
    SymmetricSquare.internalAt_ofNat_internalIndex second_acted]
  exact SymmetricSquare.polarInvariant_act
    (SymmetricSquare.determinant_ne_zero_of_mem matrix_mem) first_nondegenerate
    second_nondegenerate

set_option maxRecDepth 10000 in
/-- The projective images of the first three anchors are exactly the triples of pattern
`(10,3,9)`, and all 2184 images are distinct. -/
theorem projectiveAnchorTriples_eq_patterned :
    projectiveAnchorTriples = patternedTriples ∧ projectiveAnchorTriples.card = 2184 := by
  have subset : projectiveAnchorTriples ⊆ patternedTriples := by
    intro triple triple_mem
    obtain ⟨matrix, _, image⟩ := Finset.mem_image.mp triple_mem
    subst image
    simp only [patternedTriples, Finset.mem_filter, Finset.mem_univ, true_and]
    exact ⟨(matrixAction_preservesRho matrix _ _).trans anchorTriplePattern.1,
      (matrixAction_preservesRho matrix _ _).trans anchorTriplePattern.2.1,
      (matrixAction_preservesRho matrix _ _).trans anchorTriplePattern.2.2⟩
  have superset : patternedTriples ⊆ projectiveAnchorTriples := by
    intro triple triple_mem
    simp only [patternedTriples, Finset.mem_filter, Finset.mem_univ, true_and] at triple_mem
    obtain ⟨matrix, image⟩ :=
      exists_matrixAction_of_pattern triple_mem.1 triple_mem.2.1 triple_mem.2.2
    exact Finset.mem_image.mpr ⟨matrix, Finset.mem_univ _, image⟩
  refine ⟨Finset.Subset.antisymm subset superset, ?_⟩
  rw [projectiveAnchorTriples, Finset.card_image_of_injective _ anchorImageTriple_injective,
    Finset.card_univ, Fintype.card_fin, projectiveMatrices_length]

end PassantCodeQ13.Automorphisms
