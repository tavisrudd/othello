import Mathlib.GroupTheory.Perm.Sign
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.SixPointStableHalfFrobenius

/-!
# The odd label permutation whose heart action is the packet Frobenius

The six labels of the coefficient heart are the six points `0,1,2,3,4,∞` of the
projective line over the field with five elements, and the two displayed
generators of the heart action are the translation `x ↦ x+1` and the involution
`x ↦ -1/x`.  Both are even permutations of the six labels, and both commute with
the whole quadratic commutant of the heart, so their diagonal action on two
copies of the heart fixes every member of the five-member packet of diagonally
stable halves.  Consequently the packet cannot be moved by the group those two
generators generate.

This module displays one further label permutation, multiplication by the
non-square scalar `2` on the projective line over the field with five elements.
It is the four-cycle `(1 2 4 3)` of the labels, hence an odd permutation, and its
induced matrix on the four heart coordinates conjugates the distinguished
commutant element `W` to its conjugate `W+1`.  Conjugation of the slope is
exactly what the diagonal action does to a graph member, so the diagonal action
of this one odd permutation on the packet is the transported Frobenius
involution of the labelling field: it fixes the vertical copy and the graphs of
the prime-field slopes `0` and `1`, and it exchanges the graphs of `W` and
`W+1`.

The consequence for marking is that the marking condition is a statement about
the six labels rather than about the labelling field: a packet member is
Frobenius marked exactly when it is not invariant under the diagonal heart
action of this odd label permutation, while it is invariant under the action of
each even displayed generator.

All matrix identities here are closed finite equalities over the field with two
elements, checked by kernel reduction.  No native execution, external
certificate, or oracle is used.  The module constructs no geometric isogeny,
torsion group scheme, or arithmetic Frobenius of an actual family, and it does
not identify the six labels with the manuscript's six conjugate dihedral
subgroups; it identifies the transported involution of the packet with the heart
action of an explicit permutation of the labels, nothing more.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace GraphLattices

open scoped Matrix

/-- Inverse scaling by the non-square scalar `2` on the six-point
projective-line labelling `0,1,2,3,4,∞`: the map `x ↦ 3x`, written as the
preimage permutation. -/
def sixPointScalingPreimage : Fin 6 → Fin 6 := ![0, 3, 1, 4, 2, 5]

/-- Scaling by the non-square scalar `2` on the six-point projective-line
labelling over the field with five elements. -/
def sixPointScalingPermutation : Equiv.Perm (Fin 6) where
  toFun := ![0, 2, 4, 1, 3, 5]
  invFun := sixPointScalingPreimage
  left_inv point := by fin_cases point <;> decide
  right_inv point := by fin_cases point <;> decide

/-- Scaling by a non-square scalar is the four-cycle `(1 2 4 3)` of the labels,
hence an odd permutation of the six labels. -/
theorem sixPointScalingPermutation_sign :
    Equiv.Perm.sign sixPointScalingPermutation = -1 := by
  decide

/-- Translation of the labelling is a five-cycle, hence an even permutation of
the six labels. -/
theorem sixPointTranslationPermutation_sign :
    Equiv.Perm.sign sixPointTranslationPermutation = 1 := by
  decide

/-- The labelling involution `x ↦ -1/x` is a product of two transpositions,
hence an even permutation of the six labels. -/
theorem sixPointInversionPermutation_sign :
    Equiv.Perm.sign sixPointInversionPermutation = 1 := by
  decide

/-- The matrix induced by scaling on the normalized four-dimensional
characteristic-two heart. -/
def sixPointHeartScaling : Matrix (Fin 4) (Fin 4) F2 :=
  !![1, 0, 0, 0;
     0, 0, 0, 1;
     0, 1, 0, 0;
     1, 1, 1, 1]

/-- The matrix induced by inverse scaling on the normalized four-dimensional
characteristic-two heart. -/
def sixPointHeartScalingInverse : Matrix (Fin 4) (Fin 4) F2 :=
  !![1, 0, 0, 0;
     0, 0, 1, 0;
     1, 1, 1, 1;
     0, 1, 0, 0]

/-- Permuting a normalized representative by inverse scaling induces the
displayed scaling matrix on heart coordinates. -/
theorem sixPointHeartCoordinates_scaling (heart : Fin 4 → F2) :
    sixPointHeartCoordinates
        (sixPointHeartRepresentative heart ∘ sixPointScalingPreimage) =
      Matrix.mulVec sixPointHeartScaling heart := by
  ext index
  fin_cases index <;>
    simp [sixPointHeartCoordinates, sixPointHeartRepresentative,
      sixPointScalingPreimage, sixPointHeartScaling,
      Matrix.mulVec, dotProduct, Fin.sum_univ_succ, CharTwo.sub_eq_add]

/-- The displayed scaling matrix is invertible, with the displayed inverse. -/
theorem sixPointHeartScaling_mul_inverse :
    sixPointHeartScaling * sixPointHeartScalingInverse = 1 := by
  ext row column
  fin_cases row <;> fin_cases column <;> decide

/-- The displayed inverse is a two-sided inverse of the scaling matrix. -/
theorem sixPointHeartScalingInverse_mul :
    sixPointHeartScalingInverse * sixPointHeartScaling = 1 := by
  ext row column
  fin_cases row <;> fin_cases column <;> decide

/-- Conjugation by the scaling matrix carries the distinguished commutant
element to its conjugate. -/
theorem sixPointHeartScaling_conjugate_commutantRoot :
    sixPointHeartScaling * sixPointHeartCommutantRoot *
        sixPointHeartScalingInverse = sixPointHeartCommutantRoot + 1 := by
  ext row column
  fin_cases row <;> fin_cases column <;> decide

/-- Conjugation by the scaling matrix carries the conjugate commutant element
back to the distinguished one. -/
theorem sixPointHeartScaling_conjugate_commutantRootConjugate :
    sixPointHeartScaling * (sixPointHeartCommutantRoot + 1) *
        sixPointHeartScalingInverse = sixPointHeartCommutantRoot := by
  ext row column
  fin_cases row <;> fin_cases column <;> decide

/-- Conjugation fixes the zero slope. -/
theorem sixPointHeartScaling_conjugate_zero :
    sixPointHeartScaling * (0 : Matrix (Fin 4) (Fin 4) F2) *
        sixPointHeartScalingInverse = 0 := by
  simp

/-- Conjugation fixes the unit slope. -/
theorem sixPointHeartScaling_conjugate_one :
    sixPointHeartScaling * (1 : Matrix (Fin 4) (Fin 4) F2) *
        sixPointHeartScalingInverse = 1 := by
  rw [mul_one, sixPointHeartScaling_mul_inverse]

/-- The diagonal action of a heart matrix on two copies of the coefficient
heart. -/
def sixPointHeartPairMap (matrix : Matrix (Fin 4) (Fin 4) F2) :
    (SixPointHeart × SixPointHeart) →ₗ[F2] SixPointHeart × SixPointHeart :=
  (Matrix.toLin' matrix).prodMap (Matrix.toLin' matrix)

/-- The diagonal action multiplies both components of a pair by the matrix. -/
@[simp]
theorem sixPointHeartPairMap_apply (matrix : Matrix (Fin 4) (Fin 4) F2)
    (pair : SixPointHeart × SixPointHeart) :
    sixPointHeartPairMap matrix pair =
      (Matrix.mulVec matrix pair.1, Matrix.mulVec matrix pair.2) := by
  simp [sixPointHeartPairMap, Matrix.toLin'_apply]

/-- An invertible heart matrix acts surjectively on one copy of the heart. -/
theorem sixPointHeartMatrix_range_eq_top
    {matrix inverse : Matrix (Fin 4) (Fin 4) F2}
    (rightInverse : matrix * inverse = 1) :
    LinearMap.range (Matrix.toLin' matrix) = ⊤ := by
  rw [LinearMap.range_eq_top]
  intro vector
  refine ⟨Matrix.mulVec inverse vector, ?_⟩
  rw [Matrix.toLin'_apply, Matrix.mulVec_mulVec, rightInverse,
    Matrix.one_mulVec]

/-- The diagonal action of an invertible heart matrix carries the graph of a
slope to the graph of the conjugated slope. -/
theorem sixPointHeartPairMap_graphRange
    {matrix inverse : Matrix (Fin 4) (Fin 4) F2}
    (rightInverse : matrix * inverse = 1) (leftInverse : inverse * matrix = 1)
    (slope : Matrix (Fin 4) (Fin 4) F2) :
    Submodule.map (sixPointHeartPairMap matrix)
        (LinearMap.range (graphEmbedding (K := F2) (Matrix.toLin' slope))) =
      LinearMap.range (graphEmbedding (K := F2)
        (Matrix.toLin' (matrix * slope * inverse))) := by
  have composition :
      (sixPointHeartPairMap matrix).comp
          (graphEmbedding (K := F2) (Matrix.toLin' slope)) =
        (graphEmbedding (K := F2)
            (Matrix.toLin' (matrix * slope * inverse))).comp
          (Matrix.toLin' matrix) := by
    refine LinearMap.ext fun vector ↦ Prod.ext ?_ ?_
    · simp [graphEmbedding, Matrix.toLin'_apply]
    · have slopeIdentity :
          matrix * slope * inverse * matrix = matrix * slope := by
        rw [mul_assoc (matrix * slope) inverse matrix, leftInverse, mul_one]
      simp only [LinearMap.comp_apply, sixPointHeartPairMap_apply,
        graphEmbedding, LinearMap.prod_apply, Function.prod_apply,
        LinearMap.id_coe, id_eq, Matrix.toLin'_apply]
      rw [Matrix.mulVec_mulVec, Matrix.mulVec_mulVec, slopeIdentity]
  rw [← LinearMap.range_comp, composition, LinearMap.range_comp,
    sixPointHeartMatrix_range_eq_top rightInverse, Submodule.map_top]

/-- The diagonal action of an invertible heart matrix preserves the vertical
copy. -/
theorem sixPointHeartPairMap_verticalRange
    {matrix inverse : Matrix (Fin 4) (Fin 4) F2}
    (rightInverse : matrix * inverse = 1) :
    Submodule.map (sixPointHeartPairMap matrix)
        (LinearMap.range (verticalEmbedding (K := F2) (H := SixPointHeart))) =
      LinearMap.range (verticalEmbedding (K := F2) (H := SixPointHeart)) := by
  have composition :
      (sixPointHeartPairMap matrix).comp
          (verticalEmbedding (K := F2) (H := SixPointHeart)) =
        (verticalEmbedding (K := F2) (H := SixPointHeart)).comp
          (Matrix.toLin' matrix) := by
    refine LinearMap.ext fun vector ↦ Prod.ext ?_ ?_
    · simp [verticalEmbedding]
    · simp [verticalEmbedding, Matrix.toLin'_apply]
  rw [← LinearMap.range_comp, composition, LinearMap.range_comp,
    sixPointHeartMatrix_range_eq_top rightInverse, Submodule.map_top]

/-- The diagonal action of a heart matrix commuting with a slope fixes the
graph of that slope. -/
theorem sixPointHeartPairMap_graphRange_of_commutes
    {matrix inverse slope : Matrix (Fin 4) (Fin 4) F2}
    (rightInverse : matrix * inverse = 1) (leftInverse : inverse * matrix = 1)
    (commutes : matrix * slope = slope * matrix) :
    Submodule.map (sixPointHeartPairMap matrix)
        (LinearMap.range (graphEmbedding (K := F2) (Matrix.toLin' slope))) =
      LinearMap.range (graphEmbedding (K := F2) (Matrix.toLin' slope)) := by
  have conjugation : matrix * slope * inverse = slope := by
    rw [commutes, mul_assoc, rightInverse, mul_one]
  rw [sixPointHeartPairMap_graphRange rightInverse leftInverse slope,
    conjugation]

noncomputable section

/-- The diagonal heart action of the odd label permutation carries each labelled
packet member to the member named by the Frobenius conjugate label. -/
theorem sixPointHeartStableHalfOfProjectiveChart_scaling_map
    (point : Option F4) :
    Submodule.map (sixPointHeartPairMap sixPointHeartScaling)
        (sixPointHeartStableHalfOfProjectiveChart point) =
      sixPointHeartStableHalfOfProjectiveChart (f4ProjectiveFrobenius point) := by
  obtain ⟨vertical, zero, one, root, conjugate⟩ :=
    sixPointHeartStableHalfOfProjectiveChart_values
  have graphMap := sixPointHeartPairMap_graphRange
    sixPointHeartScaling_mul_inverse sixPointHeartScalingInverse_mul
  match point with
  | none =>
      rw [show f4ProjectiveFrobenius none = none from rfl, vertical]
      exact sixPointHeartPairMap_verticalRange sixPointHeartScaling_mul_inverse
  | some scalar =>
      rcases f4_eq_zero_or_one_or_markedRoot_or_conjugate scalar with
        atZero | atOne | atRoot | atConjugate <;> subst scalar
      · rw [show f4ProjectiveFrobenius (some (0 : F4)) = some 0 from
            (f4ProjectiveFrobenius_fixed_iff (some 0)).mpr
              (Or.inr (Or.inl rfl)),
          zero, graphMap, sixPointHeartScaling_conjugate_zero]
      · rw [show f4ProjectiveFrobenius (some (1 : F4)) = some 1 from
            (f4ProjectiveFrobenius_fixed_iff (some 1)).mpr
              (Or.inr (Or.inr rfl)),
          one, graphMap, sixPointHeartScaling_conjugate_one]
      · rw [sixAxisQuadraticSlope_markedProjectivePair.1, conjugate, root,
          graphMap, sixPointHeartScaling_conjugate_commutantRoot]
      · rw [sixAxisQuadraticSlope_markedProjectivePair.2.1, root, conjugate,
          graphMap, sixPointHeartScaling_conjugate_commutantRootConjugate]

/-- The transported Frobenius involution of the packet is the diagonal heart
action of the odd label permutation.  Marking a packet member is therefore a
condition on the six labels: the member is moved by the heart action of an odd
permutation of them. -/
theorem sixPointHeartStableHalfPacketFrobenius_eq_scalingMap
    (member : {subspace // subspace ∈ SixPointHeartStableHalfPacket}) :
    (sixPointHeartStableHalfPacketFrobenius member).1 =
      Submodule.map (sixPointHeartPairMap sixPointHeartScaling) member.1 := by
  obtain ⟨point, rfl⟩ :=
    sixPointHeartProjectiveChartEquivStableHalfPacket.surjective member
  rw [sixPointHeartStableHalfPacketFrobenius_chart,
    sixPointHeartProjectiveChartEquivStableHalfPacket_val,
    sixPointHeartProjectiveChartEquivStableHalfPacket_val,
    sixPointHeartStableHalfOfProjectiveChart_scaling_map]

/-- The diagonal heart action of the odd label permutation preserves the
packet. -/
theorem sixPointHeartStableHalfPacket_scaling_mem
    {subspace : Submodule F2 (SixPointHeart × SixPointHeart)}
    (member : subspace ∈ SixPointHeartStableHalfPacket) :
    Submodule.map (sixPointHeartPairMap sixPointHeartScaling) subspace ∈
      SixPointHeartStableHalfPacket := by
  have equality :=
    sixPointHeartStableHalfPacketFrobenius_eq_scalingMap ⟨subspace, member⟩
  exact equality ▸ (sixPointHeartStableHalfPacketFrobenius
    ⟨subspace, member⟩).2

/-- Frobenius marking of a packet member is exactly failure to be invariant
under the diagonal heart action of the odd label permutation. -/
theorem sixPointHeartFrobeniusMarked_iff_scaling_moves
    {subspace : Submodule F2 (SixPointHeart × SixPointHeart)}
    (member : subspace ∈ SixPointHeartStableHalfPacket) :
    SixPointHeartFrobeniusMarked subspace ↔
      Submodule.map (sixPointHeartPairMap sixPointHeartScaling) subspace ≠
        subspace := by
  constructor
  · intro marked equality
    refine marked member ?_
    apply Subtype.ext
    rw [sixPointHeartStableHalfPacketFrobenius_eq_scalingMap ⟨subspace, member⟩,
      equality]
  · intro moved other fixed
    refine moved ?_
    rw [← sixPointHeartStableHalfPacketFrobenius_eq_scalingMap
      ⟨subspace, other⟩, fixed]

end

/-- The matrix induced on the heart by inverse translation of the labelling,
the fourth power of the translation matrix. -/
def sixPointHeartTranslationInverse : Matrix (Fin 4) (Fin 4) F2 :=
  !![0, 1, 0, 0;
     0, 0, 1, 0;
     0, 0, 0, 1;
     1, 1, 1, 1]

/-- The displayed translation matrix is invertible, with the displayed
inverse. -/
theorem sixPointHeartTranslation_mul_inverse :
    sixPointHeartTranslation * sixPointHeartTranslationInverse = 1 := by
  ext row column
  fin_cases row <;> fin_cases column <;> decide

/-- The displayed inverse is a two-sided inverse of the translation matrix. -/
theorem sixPointHeartTranslationInverse_mul :
    sixPointHeartTranslationInverse * sixPointHeartTranslation = 1 := by
  ext row column
  fin_cases row <;> fin_cases column <;> decide

/-- The inversion matrix is its own inverse. -/
theorem sixPointHeartInversion_mul_self :
    sixPointHeartInversion * sixPointHeartInversion = 1 := by
  ext row column
  fin_cases row <;> fin_cases column <;> decide

/-- An invertible heart matrix commuting with the distinguished commutant
element fixes every member of the packet under its diagonal action: it commutes
with all four commutant slopes, and it preserves the vertical copy. -/
theorem sixPointHeartStableHalfPacket_map_eq_self_of_commutesRoot
    {matrix inverse : Matrix (Fin 4) (Fin 4) F2}
    (rightInverse : matrix * inverse = 1) (leftInverse : inverse * matrix = 1)
    (commutesRoot :
      matrix * sixPointHeartCommutantRoot =
        sixPointHeartCommutantRoot * matrix)
    {subspace : Submodule F2 (SixPointHeart × SixPointHeart)}
    (member : subspace ∈ SixPointHeartStableHalfPacket) :
    Submodule.map (sixPointHeartPairMap matrix) subspace = subspace := by
  simp only [SixPointHeartStableHalfPacket, Set.mem_union,
    Set.mem_singleton_iff, Set.mem_insert_iff] at member
  rcases member with vertical | zero | one | root | rootOne
  · subst subspace
    exact sixPointHeartPairMap_verticalRange rightInverse
  · subst subspace
    exact sixPointHeartPairMap_graphRange_of_commutes rightInverse leftInverse
      (by simp)
  · subst subspace
    exact sixPointHeartPairMap_graphRange_of_commutes rightInverse leftInverse
      (by simp)
  · subst subspace
    exact sixPointHeartPairMap_graphRange_of_commutes rightInverse leftInverse
      commutesRoot
  · subst subspace
    refine sixPointHeartPairMap_graphRange_of_commutes rightInverse leftInverse
      ?_
    rw [mul_add, add_mul, commutesRoot, mul_one, one_mul]

/-- Each even displayed generator fixes every packet member under its diagonal
heart action.  The packet therefore cannot be moved by the group generated by
the two even generators, and the marking of a member is not a statement about
that group. -/
theorem sixPointHeartStableHalfPacket_evenGenerators_fix
    {subspace : Submodule F2 (SixPointHeart × SixPointHeart)}
    (member : subspace ∈ SixPointHeartStableHalfPacket) :
    Submodule.map (sixPointHeartPairMap sixPointHeartTranslation) subspace =
        subspace ∧
      Submodule.map (sixPointHeartPairMap sixPointHeartInversion) subspace =
        subspace := by
  obtain ⟨commutesTranslation, commutesInversion⟩ :=
    (sixPointHeart_commonCommutant_classification
      sixPointHeartCommutantRoot).mpr (Or.inr (Or.inr (Or.inl rfl)))
  exact ⟨sixPointHeartStableHalfPacket_map_eq_self_of_commutesRoot
      sixPointHeartTranslation_mul_inverse
      sixPointHeartTranslationInverse_mul commutesTranslation.symm member,
    sixPointHeartStableHalfPacket_map_eq_self_of_commutesRoot
      sixPointHeartInversion_mul_self sixPointHeartInversion_mul_self
      commutesInversion.symm member⟩

/-- Every member of the prime-field triple is fixed by the diagonal action of
every invertible heart matrix: the vertical copy, the graph of the zero slope,
and the diagonal are preserved by any invertible change of the heart.  No
hypothesis of invariance under a group of heart matrices can therefore separate
those three members from each other or move any of them. -/
theorem sixPointHeartPrimeFieldHalfTriple_map_eq_self
    {matrix inverse : Matrix (Fin 4) (Fin 4) F2}
    (rightInverse : matrix * inverse = 1) (leftInverse : inverse * matrix = 1)
    {subspace : Submodule F2 (SixPointHeart × SixPointHeart)}
    (member : subspace ∈ SixPointHeartPrimeFieldHalfTriple) :
    Submodule.map (sixPointHeartPairMap matrix) subspace = subspace := by
  simp only [SixPointHeartPrimeFieldHalfTriple, Set.mem_insert_iff,
    Set.mem_singleton_iff] at member
  rcases member with vertical | zero | one
  · subst subspace
    exact sixPointHeartPairMap_verticalRange rightInverse
  · subst subspace
    exact sixPointHeartPairMap_graphRange_of_commutes rightInverse leftInverse
      (by simp)
  · subst subspace
    exact sixPointHeartPairMap_graphRange_of_commutes rightInverse leftInverse
      (by simp)

/-- A packet member moved by the diagonal action of any invertible heart matrix
is one of the two exotic members.  Marking by such an action is therefore never
stronger than Frobenius marking. -/
theorem sixPointHeartStableHalfPacket_moved_mem_exoticPair
    {matrix inverse : Matrix (Fin 4) (Fin 4) F2}
    (rightInverse : matrix * inverse = 1) (leftInverse : inverse * matrix = 1)
    {subspace : Submodule F2 (SixPointHeart × SixPointHeart)}
    (member : subspace ∈ SixPointHeartStableHalfPacket)
    (moved : Submodule.map (sixPointHeartPairMap matrix) subspace ≠ subspace) :
    subspace ∈ SixPointHeartExoticHalfPair := by
  simp only [SixPointHeartStableHalfPacket, Set.mem_union,
    Set.mem_singleton_iff, Set.mem_insert_iff] at member
  rcases member with vertical | zero | one | root | rootOne
  · exact absurd (sixPointHeartPrimeFieldHalfTriple_map_eq_self rightInverse
      leftInverse (by simp [SixPointHeartPrimeFieldHalfTriple, vertical])) moved
  · exact absurd (sixPointHeartPrimeFieldHalfTriple_map_eq_self rightInverse
      leftInverse (by simp [SixPointHeartPrimeFieldHalfTriple, zero])) moved
  · exact absurd (sixPointHeartPrimeFieldHalfTriple_map_eq_self rightInverse
      leftInverse (by simp [SixPointHeartPrimeFieldHalfTriple, one])) moved
  · simp [SixPointHeartExoticHalfPair, root]
  · simp [SixPointHeartExoticHalfPair, rootOne]

/-- The three displayed label permutations: translation, the involution
`x ↦ -1/x`, and scaling by the non-square scalar `2`. -/
def sixPointLabelGenerator : Fin 3 → Equiv.Perm (Fin 6) :=
  ![sixPointTranslationPermutation, sixPointInversionPermutation,
    sixPointScalingPermutation]

/-- The heart matrices induced by the three displayed label permutations. -/
def sixPointHeartGeneratorMatrix : Fin 3 → Matrix (Fin 4) (Fin 4) F2 :=
  ![sixPointHeartTranslation, sixPointHeartInversion, sixPointHeartScaling]

/-- The inverses of the three displayed heart matrices. -/
def sixPointHeartGeneratorInverseMatrix : Fin 3 → Matrix (Fin 4) (Fin 4) F2 :=
  ![sixPointHeartTranslationInverse, sixPointHeartInversion,
    sixPointHeartScalingInverse]

/-- Over the field with two elements a common summand cancels from a difference
of two coordinates. -/
private theorem sixPointHeartF2_add_constant_cancel (left right constant : F2) :
    left + constant + (right + constant) = left + right := by
  have cancellation : constant + constant = 0 := CharTwo.add_self_eq_zero constant
  linear_combination cancellation

/-- Adding a constant to all six labelled coordinates does not change the heart
coordinates. -/
theorem sixPointHeartCoordinates_add_constant (vector : Fin 6 → F2)
    (constant : F2) :
    sixPointHeartCoordinates (fun point ↦ vector point + constant) =
      sixPointHeartCoordinates vector := by
  ext index
  fin_cases index <;>
    simp [sixPointHeartCoordinates, CharTwo.sub_eq_add,
      sixPointHeartF2_add_constant_cancel]

/-- On the augmentation hyperplane the normalized representative of the heart
coordinates differs from the original vector by the constant given by its last
coordinate. -/
theorem sixPointHeartRepresentative_coordinates (vector : Fin 6 → F2)
    (augmentation : ∑ point, vector point = 0) :
    sixPointHeartRepresentative (sixPointHeartCoordinates vector) =
      fun point ↦ vector point + vector 5 := by
  have sumExpanded : vector 0 + (vector 1 + (vector 2 +
      (vector 3 + (vector 4 + vector 5)))) = 0 := by
    simpa [Fin.sum_univ_succ] using augmentation
  ext index
  fin_cases index <;>
    simp [sixPointHeartRepresentative, sixPointHeartCoordinates,
      CharTwo.sub_eq_add, Fin.sum_univ_succ]
  · linear_combination (norm := (ring_nf; simp [CharTwo.two_eq_zero]))
      sumExpanded
  · simp [CharTwo.add_self_eq_zero]

/-- Permuting the six labels by the inverse of a displayed generator induces the
displayed heart matrix of that generator on heart coordinates, for every vector
of the augmentation hyperplane. -/
theorem sixPointHeartCoordinates_generator (letter : Fin 3)
    (vector : Fin 6 → F2) (augmentation : ∑ point, vector point = 0) :
    sixPointHeartCoordinates
        (vector ∘ (sixPointLabelGenerator letter).symm) =
      Matrix.mulVec (sixPointHeartGeneratorMatrix letter)
        (sixPointHeartCoordinates vector) := by
  have decomposition :
      vector = fun point ↦
        sixPointHeartRepresentative (sixPointHeartCoordinates vector) point +
          vector 5 := by
    ext point
    rw [sixPointHeartRepresentative_coordinates vector augmentation]
    rw [add_assoc, CharTwo.add_self_eq_zero, add_zero]
  have permuted (permutation : Equiv.Perm (Fin 6)) :
      vector ∘ permutation.symm =
        fun point ↦ (sixPointHeartRepresentative
            (sixPointHeartCoordinates vector) ∘ permutation.symm) point +
          vector 5 := by
    funext point
    exact congrFun decomposition (permutation.symm point)
  rw [permuted, sixPointHeartCoordinates_add_constant]
  fin_cases letter
  · exact sixPointHeartCoordinates_translation _
  · exact sixPointHeartCoordinates_inversion _
  · exact sixPointHeartCoordinates_scaling _

/-- The label permutation of a word in the three displayed generators. -/
def sixPointLabelWordPermutation : List (Fin 3) → Equiv.Perm (Fin 6)
  | [] => 1
  | letter :: word =>
      sixPointLabelGenerator letter * sixPointLabelWordPermutation word

/-- The heart matrix of a word in the three displayed generators. -/
def sixPointHeartLabelWordMatrix : List (Fin 3) → Matrix (Fin 4) (Fin 4) F2
  | [] => 1
  | letter :: word =>
      sixPointHeartGeneratorMatrix letter * sixPointHeartLabelWordMatrix word

/-- The inverse heart matrix of a word in the three displayed generators. -/
def sixPointHeartLabelWordInverse : List (Fin 3) → Matrix (Fin 4) (Fin 4) F2
  | [] => 1
  | letter :: word =>
      sixPointHeartLabelWordInverse word *
        sixPointHeartGeneratorInverseMatrix letter

/-- Whether a word contains an odd number of scaling letters. -/
def sixPointLabelWordOdd : List (Fin 3) → Bool
  | [] => false
  | letter :: word =>
      xor (decide (letter = 2)) (sixPointLabelWordOdd word)

/-- The heart action of the label permutation of a word is multiplication by
the word's heart matrix, on every vector of the augmentation hyperplane. -/
theorem sixPointHeartCoordinates_labelWord (word : List (Fin 3))
    (vector : Fin 6 → F2) (augmentation : ∑ point, vector point = 0) :
    sixPointHeartCoordinates
        (vector ∘ (sixPointLabelWordPermutation word).symm) =
      Matrix.mulVec (sixPointHeartLabelWordMatrix word)
        (sixPointHeartCoordinates vector) := by
  induction word with
  | nil =>
      have identity :
          vector ∘ (sixPointLabelWordPermutation []).symm = vector := by
        funext point
        rfl
      rw [identity, sixPointHeartLabelWordMatrix, Matrix.one_mulVec]
  | cons letter word induction =>
      have permutedAugmentation :
          ∑ point, (vector ∘ (sixPointLabelWordPermutation word).symm) point =
            0 := by
        rw [← augmentation]
        exact Equiv.sum_comp (sixPointLabelWordPermutation word).symm vector
      have composition :
          vector ∘ (sixPointLabelWordPermutation (letter :: word)).symm =
            (vector ∘ (sixPointLabelWordPermutation word).symm) ∘
              (sixPointLabelGenerator letter).symm := by
        funext point
        rfl
      rw [composition,
        sixPointHeartCoordinates_generator letter _ permutedAugmentation,
        induction, Matrix.mulVec_mulVec, sixPointHeartLabelWordMatrix]

/-- The displayed inverse heart matrices are two-sided inverses of the displayed
generator matrices. -/
theorem sixPointHeartGeneratorMatrix_mul_inverse (letter : Fin 3) :
    sixPointHeartGeneratorMatrix letter *
        sixPointHeartGeneratorInverseMatrix letter = 1 ∧
      sixPointHeartGeneratorInverseMatrix letter *
        sixPointHeartGeneratorMatrix letter = 1 := by
  fin_cases letter
  · exact ⟨sixPointHeartTranslation_mul_inverse,
      sixPointHeartTranslationInverse_mul⟩
  · exact ⟨sixPointHeartInversion_mul_self, sixPointHeartInversion_mul_self⟩
  · exact ⟨sixPointHeartScaling_mul_inverse, sixPointHeartScalingInverse_mul⟩

/-- The heart matrix of a word is invertible, with the word's inverse matrix as
a two-sided inverse. -/
theorem sixPointHeartLabelWordMatrix_mul_inverse (word : List (Fin 3)) :
    sixPointHeartLabelWordMatrix word * sixPointHeartLabelWordInverse word =
        1 ∧
      sixPointHeartLabelWordInverse word * sixPointHeartLabelWordMatrix word =
        1 := by
  induction word with
  | nil => simp [sixPointHeartLabelWordMatrix, sixPointHeartLabelWordInverse]
  | cons letter word induction =>
      obtain ⟨wordRight, wordLeft⟩ := induction
      obtain ⟨generatorRight, generatorLeft⟩ :=
        sixPointHeartGeneratorMatrix_mul_inverse letter
      constructor
      · calc
          sixPointHeartLabelWordMatrix (letter :: word) *
                sixPointHeartLabelWordInverse (letter :: word) =
              sixPointHeartGeneratorMatrix letter *
                (sixPointHeartLabelWordMatrix word *
                  sixPointHeartLabelWordInverse word) *
                sixPointHeartGeneratorInverseMatrix letter := by
            simp only [sixPointHeartLabelWordMatrix,
              sixPointHeartLabelWordInverse]
            noncomm_ring
          _ = 1 := by rw [wordRight, mul_one, generatorRight]
      · calc
          sixPointHeartLabelWordInverse (letter :: word) *
                sixPointHeartLabelWordMatrix (letter :: word) =
              sixPointHeartLabelWordInverse word *
                (sixPointHeartGeneratorInverseMatrix letter *
                  sixPointHeartGeneratorMatrix letter) *
                sixPointHeartLabelWordMatrix word := by
            simp only [sixPointHeartLabelWordMatrix,
              sixPointHeartLabelWordInverse]
            noncomm_ring
          _ = 1 := by rw [generatorLeft, mul_one, wordLeft]

/-- Of the three displayed label permutations only scaling by a non-square
scalar is odd. -/
theorem sixPointLabelGenerator_sign (letter : Fin 3) :
    Equiv.Perm.sign (sixPointLabelGenerator letter) =
      if letter = 2 then -1 else 1 := by
  fin_cases letter <;>
    simp [sixPointLabelGenerator, sixPointTranslationPermutation_sign,
      sixPointInversionPermutation_sign, sixPointScalingPermutation_sign]

/-- The sign of the label permutation of a word is the parity of its number of
scaling letters: the translation and the involution `x ↦ -1/x` are even, and
scaling by a non-square scalar is odd. -/
theorem sixPointLabelWordPermutation_sign (word : List (Fin 3)) :
    Equiv.Perm.sign (sixPointLabelWordPermutation word) =
      if sixPointLabelWordOdd word then -1 else 1 := by
  induction word with
  | nil => simp [sixPointLabelWordPermutation, sixPointLabelWordOdd]
  | cons letter word induction =>
      rw [sixPointLabelWordPermutation, map_mul, induction,
        sixPointLabelWordOdd]
      rw [sixPointLabelGenerator_sign]
      by_cases atScaling : letter = 2 <;>
        rcases Bool.eq_false_or_eq_true (sixPointLabelWordOdd word) with
          parity | parity <;>
        simp [atScaling, parity]

/-- Conjugation by a displayed generator matrix fixes the distinguished
commutant element for the two even generators and carries it to its conjugate
for the odd one. -/
theorem sixPointHeartGeneratorMatrix_conjugate_commutantRoot (letter : Fin 3) :
    sixPointHeartGeneratorMatrix letter * sixPointHeartCommutantRoot *
        sixPointHeartGeneratorInverseMatrix letter =
      if letter = 2 then sixPointHeartCommutantRoot + 1
        else sixPointHeartCommutantRoot := by
  fin_cases letter <;> decide

/-- Conjugation by a displayed generator matrix fixes the conjugate commutant
element for the two even generators and carries it back to the distinguished one
for the odd one. -/
theorem sixPointHeartGeneratorMatrix_conjugate_commutantRootConjugate
    (letter : Fin 3) :
    sixPointHeartGeneratorMatrix letter * (sixPointHeartCommutantRoot + 1) *
        sixPointHeartGeneratorInverseMatrix letter =
      if letter = 2 then sixPointHeartCommutantRoot
        else sixPointHeartCommutantRoot + 1 := by
  fin_cases letter <;> decide

/-- Conjugation by the heart matrix of a word acts on the distinguished
commutant element through the parity of the word: an even word fixes it and an
odd word carries it to its conjugate. -/
theorem sixPointHeartLabelWordMatrix_conjugate_commutantRoot
    (word : List (Fin 3)) :
    sixPointHeartLabelWordMatrix word * sixPointHeartCommutantRoot *
        sixPointHeartLabelWordInverse word =
      if sixPointLabelWordOdd word then sixPointHeartCommutantRoot + 1
        else sixPointHeartCommutantRoot := by
  induction word with
  | nil => simp [sixPointHeartLabelWordMatrix, sixPointHeartLabelWordInverse,
      sixPointLabelWordOdd]
  | cons letter word induction =>
      have expansion :
          sixPointHeartLabelWordMatrix (letter :: word) *
              sixPointHeartCommutantRoot *
              sixPointHeartLabelWordInverse (letter :: word) =
            sixPointHeartGeneratorMatrix letter *
              (sixPointHeartLabelWordMatrix word *
                sixPointHeartCommutantRoot *
                sixPointHeartLabelWordInverse word) *
              sixPointHeartGeneratorInverseMatrix letter := by
        simp only [sixPointHeartLabelWordMatrix, sixPointHeartLabelWordInverse]
        noncomm_ring
      rw [expansion, induction, sixPointLabelWordOdd]
      rcases Bool.eq_false_or_eq_true (sixPointLabelWordOdd word) with
        parity | parity <;> rw [parity]
      · simp only [if_true, Bool.xor_true]
        rw [sixPointHeartGeneratorMatrix_conjugate_commutantRootConjugate]
        by_cases atScaling : letter = 2 <;> simp [atScaling]
      · simp only [if_false, Bool.xor_false, Bool.false_eq_true]
        rw [sixPointHeartGeneratorMatrix_conjugate_commutantRoot]
        by_cases atScaling : letter = 2 <;> simp [atScaling]

/-- The diagonal action of a product of heart matrices is the composition of
their diagonal actions. -/
theorem sixPointHeartPairMap_mul (left right : Matrix (Fin 4) (Fin 4) F2) :
    sixPointHeartPairMap (left * right) =
      (sixPointHeartPairMap left).comp (sixPointHeartPairMap right) := by
  refine LinearMap.ext fun pair ↦ Prod.ext ?_ ?_ <;>
    simp [Matrix.mulVec_mulVec]

noncomputable section

/-- A word whose label permutation is even fixes every packet member under its
diagonal heart action. -/
theorem sixPointHeartStableHalfPacket_evenLabelWord_fix
    (word : List (Fin 3))
    (even : Equiv.Perm.sign (sixPointLabelWordPermutation word) = 1)
    {subspace : Submodule F2 (SixPointHeart × SixPointHeart)}
    (member : subspace ∈ SixPointHeartStableHalfPacket) :
    Submodule.map (sixPointHeartPairMap (sixPointHeartLabelWordMatrix word))
        subspace = subspace := by
  obtain ⟨wordRight, wordLeft⟩ :=
    sixPointHeartLabelWordMatrix_mul_inverse word
  have parity : sixPointLabelWordOdd word = false := by
    rcases Bool.eq_false_or_eq_true (sixPointLabelWordOdd word) with
      atTrue | atFalse
    · rw [sixPointLabelWordPermutation_sign word, atTrue] at even
      exact absurd even (by decide)
    · exact atFalse
  have conjugation :
      sixPointHeartLabelWordMatrix word * sixPointHeartCommutantRoot *
          sixPointHeartLabelWordInverse word = sixPointHeartCommutantRoot := by
    rw [sixPointHeartLabelWordMatrix_conjugate_commutantRoot word, parity]
    rfl
  have commutes :
      sixPointHeartLabelWordMatrix word * sixPointHeartCommutantRoot =
        sixPointHeartCommutantRoot * sixPointHeartLabelWordMatrix word := by
    calc
      sixPointHeartLabelWordMatrix word * sixPointHeartCommutantRoot =
          sixPointHeartLabelWordMatrix word * sixPointHeartCommutantRoot *
            sixPointHeartLabelWordInverse word *
            sixPointHeartLabelWordMatrix word := by
        rw [mul_assoc (sixPointHeartLabelWordMatrix word *
          sixPointHeartCommutantRoot), wordLeft, mul_one]
      _ = sixPointHeartCommutantRoot * sixPointHeartLabelWordMatrix word := by
        rw [conjugation]
  exact sixPointHeartStableHalfPacket_map_eq_self_of_commutesRoot wordRight
    wordLeft commutes member

/-- A word whose label permutation is odd acts on the packet as the transported
Frobenius involution.  Together with the previous statement, the packet action
of the group generated by the three displayed label permutations factors through
the sign character of the six labels. -/
theorem sixPointHeartStableHalfPacket_oddLabelWord_frobenius
    (word : List (Fin 3))
    (odd : Equiv.Perm.sign (sixPointLabelWordPermutation word) = -1)
    (member : {subspace // subspace ∈ SixPointHeartStableHalfPacket}) :
    Submodule.map (sixPointHeartPairMap (sixPointHeartLabelWordMatrix word))
        member.1 = (sixPointHeartStableHalfPacketFrobenius member).1 := by
  obtain ⟨wordRight, wordLeft⟩ :=
    sixPointHeartLabelWordMatrix_mul_inverse word
  have parity : sixPointLabelWordOdd word = true := by
    rcases Bool.eq_false_or_eq_true (sixPointLabelWordOdd word) with
      atTrue | atFalse
    · exact atTrue
    · rw [sixPointLabelWordPermutation_sign word, atFalse] at odd
      exact absurd odd (by decide)
  have conjugation :
      sixPointHeartLabelWordMatrix word * sixPointHeartCommutantRoot *
          sixPointHeartLabelWordInverse word =
        sixPointHeartCommutantRoot + 1 := by
    rw [sixPointHeartLabelWordMatrix_conjugate_commutantRoot word, parity]
    rfl
  have wordCommutes :
      sixPointHeartLabelWordMatrix word * sixPointHeartCommutantRoot =
        (sixPointHeartCommutantRoot + 1) *
          sixPointHeartLabelWordMatrix word := by
    calc
      sixPointHeartLabelWordMatrix word * sixPointHeartCommutantRoot =
          sixPointHeartLabelWordMatrix word * sixPointHeartCommutantRoot *
            sixPointHeartLabelWordInverse word *
            sixPointHeartLabelWordMatrix word := by
        rw [mul_assoc (sixPointHeartLabelWordMatrix word *
          sixPointHeartCommutantRoot), wordLeft, mul_one]
      _ = (sixPointHeartCommutantRoot + 1) *
            sixPointHeartLabelWordMatrix word := by
        rw [conjugation]
  have scalingCommutes :
      sixPointHeartScalingInverse * (sixPointHeartCommutantRoot + 1) =
        sixPointHeartCommutantRoot * sixPointHeartScalingInverse := by
    ext row column
    fin_cases row <;> fin_cases column <;> decide
  have residualCommutes :
      sixPointHeartScalingInverse * sixPointHeartLabelWordMatrix word *
          sixPointHeartCommutantRoot =
        sixPointHeartCommutantRoot *
          (sixPointHeartScalingInverse *
            sixPointHeartLabelWordMatrix word) := by
    calc
      sixPointHeartScalingInverse * sixPointHeartLabelWordMatrix word *
            sixPointHeartCommutantRoot =
          sixPointHeartScalingInverse *
            (sixPointHeartLabelWordMatrix word *
              sixPointHeartCommutantRoot) := by
        rw [mul_assoc]
      _ = sixPointHeartScalingInverse * ((sixPointHeartCommutantRoot + 1) *
            sixPointHeartLabelWordMatrix word) := by rw [wordCommutes]
      _ = sixPointHeartScalingInverse * (sixPointHeartCommutantRoot + 1) *
            sixPointHeartLabelWordMatrix word := by rw [mul_assoc]
      _ = sixPointHeartCommutantRoot *
            (sixPointHeartScalingInverse *
              sixPointHeartLabelWordMatrix word) := by
        rw [scalingCommutes, mul_assoc]
  have residualRight :
      sixPointHeartScalingInverse * sixPointHeartLabelWordMatrix word *
          (sixPointHeartLabelWordInverse word * sixPointHeartScaling) = 1 := by
    calc
      sixPointHeartScalingInverse * sixPointHeartLabelWordMatrix word *
            (sixPointHeartLabelWordInverse word * sixPointHeartScaling) =
          sixPointHeartScalingInverse * (sixPointHeartLabelWordMatrix word *
            sixPointHeartLabelWordInverse word) * sixPointHeartScaling := by
        noncomm_ring
      _ = 1 := by
        rw [wordRight, mul_one, sixPointHeartScalingInverse_mul]
  have residualLeft :
      sixPointHeartLabelWordInverse word * sixPointHeartScaling *
          (sixPointHeartScalingInverse *
            sixPointHeartLabelWordMatrix word) = 1 := by
    calc
      sixPointHeartLabelWordInverse word * sixPointHeartScaling *
            (sixPointHeartScalingInverse *
              sixPointHeartLabelWordMatrix word) =
          sixPointHeartLabelWordInverse word * (sixPointHeartScaling *
            sixPointHeartScalingInverse) *
            sixPointHeartLabelWordMatrix word := by
        noncomm_ring
      _ = 1 := by
        rw [sixPointHeartScaling_mul_inverse, mul_one, wordLeft]
  have factorization :
      sixPointHeartLabelWordMatrix word =
        sixPointHeartScaling * (sixPointHeartScalingInverse *
          sixPointHeartLabelWordMatrix word) := by
    rw [← mul_assoc, sixPointHeartScaling_mul_inverse, one_mul]
  rw [sixPointHeartStableHalfPacketFrobenius_eq_scalingMap member,
    factorization, sixPointHeartPairMap_mul, Submodule.map_comp,
    sixPointHeartStableHalfPacket_map_eq_self_of_commutesRoot residualRight
      residualLeft residualCommutes member.2]

end

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
