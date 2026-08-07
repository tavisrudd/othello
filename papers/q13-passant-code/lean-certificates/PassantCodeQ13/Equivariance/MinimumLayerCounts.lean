import PassantCodeQ13.Equivariance.Transporter
import PassantCodeQ13.MinimumWords.RowUniqueness.ConcurrenceTransport
import RelativeConicArcs.PassantCodeQ13.StructuralUpgrade

/-!
# Counts over the decoded minimum layer, and their behaviour under the projective action

Three quantities of the pair-only reconstruction argument are counts over the decoded minimum-word
family: the number of supports through one internal point, the number through an ordered pair, and
the number of points whose two pair counts with a given pair are both seven.  This module gives each
of them an equivalent form counted over the encoded supports through the displayed point indices,
and records how each behaves under the symmetric-square action of the normalized invertible
matrices.

The encoded forms are equal to the semantic ones because decoding is injective on the encoded
family and the bits of an encoded support are exactly the displayed indices of the points of its
decoding.  The action leaves the family invariant, so all three counts are constant on the orbits of
the action; combined with transitivity on the internal points and on the ordered pairs of distinct
internal points, a statement about all points reduces to the first internal point, and a statement
about all ordered distinct pairs reduces to the six displayed representative pairs.

The polar row of a point and the concurrence-eight neighbourhood of a point are both carried by the
action to the corresponding object of the image point, so the two families they generate agree as
soon as they agree at the first internal point.
-/

namespace PassantCodeQ13.Equivariance

set_option maxRecDepth 4000

open Finset
open RelativeConicArcs
open RelativeConicArcs.PassantCodeQ13
open PassantCodeQ13.MinimumWords
open PassantCodeQ13.MinimumWords.RowUniqueness
open PassantCodeQ13.SymmetricSquare
open PassantCodeQ13.WeightTen

/-! ## Encoded forms of the two membership counts -/

/-- The encoded family has no repetitions.  Decided over the displayed 364 supports. -/
theorem minimumSupportCodes_nodup : minimumSupportCodes.Nodup := by
  rw [minimumSupportCodes_eq]
  decide +kernel

/-- The number of encoded minimum-word supports through the displayed index of a point. -/
def indexedUnaryDegree (point : InternalPoint) : Nat :=
  minimumSupportCodes.countP fun support => support.testBit (internalPointIndex point)

/-- The number of encoded minimum-word supports through the displayed indices of two points. -/
def indexedPairConcurrence (first second : InternalPoint) : Nat :=
  minimumSupportCodes.countP fun support =>
    support.testBit (internalPointIndex first) && support.testBit (internalPointIndex second)

/-- Counting encoded supports through one index is counting decoded supports through the point. -/
theorem indexedUnaryDegree_eq_card (point : InternalPoint) :
    indexedUnaryDegree point =
      (semanticMinimumSupports.filter fun support => point ∈ support).card := by
  obtain ⟨index, rfl⟩ := internalPointAt_bijective.surjective point
  have image_eq :
      (minimumSupportCodes.toFinset.filter fun support =>
          support.testBit index.1 = true).image decodedSupport =
        semanticMinimumSupports.filter fun support => internalPointAt index ∈ support := by
    ext support
    constructor
    · intro support_mem
      obtain ⟨encoded, encoded_mem, rfl⟩ := Finset.mem_image.mp support_mem
      have encoded_data := Finset.mem_filter.mp encoded_mem
      refine Finset.mem_filter.mpr ⟨Finset.mem_image.mpr ⟨encoded, encoded_data.1, rfl⟩, ?_⟩
      exact (mem_decodedSupport encoded index).mpr encoded_data.2
    · intro support_mem
      have semantic_data := Finset.mem_filter.mp support_mem
      obtain ⟨encoded, encoded_mem, rfl⟩ := Finset.mem_image.mp semantic_data.1
      exact Finset.mem_image.mpr ⟨encoded, Finset.mem_filter.mpr ⟨encoded_mem,
        (mem_decodedSupport encoded index).mp semantic_data.2⟩, rfl⟩
  unfold indexedUnaryDegree
  rw [internalPointIndex_internalPointAt]
  rw [countP_eq_card_filter_toFinset minimumSupportCodes
    (fun support => support.testBit index.1) minimumSupportCodes_nodup, ← image_eq,
    Finset.card_image_of_injOn (decodedSupport_injOn.mono (Finset.filter_subset _ _))]

/-- Counting encoded supports through two indices is the semantic pair concurrence. -/
theorem indexedPairConcurrence_eq_semantic (first second : InternalPoint) :
    indexedPairConcurrence first second =
      ConicPassantCode.pairConcurrence semanticMinimumSupports first second := by
  obtain ⟨firstIndex, rfl⟩ := internalPointAt_bijective.surjective first
  obtain ⟨secondIndex, rfl⟩ := internalPointAt_bijective.surjective second
  have image_eq :
      (minimumSupportCodes.toFinset.filter fun support =>
          (support.testBit firstIndex.1 && support.testBit secondIndex.1) = true).image
            decodedSupport =
        semanticMinimumSupports.filter fun support =>
          internalPointAt firstIndex ∈ support ∧ internalPointAt secondIndex ∈ support := by
    ext support
    constructor
    · intro support_mem
      obtain ⟨encoded, encoded_mem, rfl⟩ := Finset.mem_image.mp support_mem
      have encoded_data := Finset.mem_filter.mp encoded_mem
      refine Finset.mem_filter.mpr ⟨Finset.mem_image.mpr ⟨encoded, encoded_data.1, rfl⟩, ?_⟩
      simpa [mem_decodedSupport, Bool.and_eq_true] using encoded_data.2
    · intro support_mem
      have semantic_data := Finset.mem_filter.mp support_mem
      obtain ⟨encoded, encoded_mem, rfl⟩ := Finset.mem_image.mp semantic_data.1
      refine Finset.mem_image.mpr ⟨encoded, Finset.mem_filter.mpr ⟨encoded_mem, ?_⟩, rfl⟩
      simpa [mem_decodedSupport, Bool.and_eq_true] using semantic_data.2
  unfold indexedPairConcurrence
  rw [internalPointIndex_internalPointAt, internalPointIndex_internalPointAt]
  show minimumSupportCodes.countP
      (fun support => support.testBit firstIndex.1 && support.testBit secondIndex.1) = _
  rw [countP_eq_card_filter_toFinset minimumSupportCodes
    (fun support => support.testBit firstIndex.1 && support.testBit secondIndex.1)
    minimumSupportCodes_nodup]
  show (minimumSupportCodes.toFinset.filter fun support =>
      (support.testBit firstIndex.1 && support.testBit secondIndex.1) = true).card =
    (semanticMinimumSupports.filter fun support =>
      internalPointAt firstIndex ∈ support ∧ internalPointAt secondIndex ∈ support).card
  rw [← image_eq,
    Finset.card_image_of_injOn (decodedSupport_injOn.mono (Finset.filter_subset _ _))]

/-! ## Invariance of the polar relation -/

/-- The projective action preserves vanishing of the polar form. -/
theorem polarValue_act_eq_zero_iff {matrix : Matrix2} (invertible : determinant matrix ≠ 0)
    {first second : Triple} (first_nondegenerate : pointDiscriminant first ≠ 0)
    (second_nondegenerate : pointDiscriminant second ≠ 0) :
    polarValue (act matrix first) (act matrix second) = 0 ↔ polarValue first second = 0 := by
  have first_image_nondegenerate :
      pointDiscriminant (symmetricSquareImage matrix first) ≠ 0 := by
    rw [pointDiscriminant_symmetricSquareImage]
    intro vanishes
    exact first_nondegenerate ((sq_mul_eq_zero_iff _ _ invertible).mp vanishes)
  have second_image_nondegenerate :
      pointDiscriminant (symmetricSquareImage matrix second) ≠ 0 := by
    rw [pointDiscriminant_symmetricSquareImage]
    intro vanishes
    exact second_nondegenerate ((sq_mul_eq_zero_iff _ _ invertible).mp vanishes)
  obtain ⟨firstFactor, firstFactor_nonzero, firstNormalized⟩ :=
    normalizeTriple_eq_scaleTriple (ne_zero_of_pointDiscriminant_ne_zero first_image_nondegenerate)
  obtain ⟨secondFactor, secondFactor_nonzero, secondNormalized⟩ :=
    normalizeTriple_eq_scaleTriple (ne_zero_of_pointDiscriminant_ne_zero second_image_nondegenerate)
  rw [act_eq_normalizeTriple_symmetricSquareImage, act_eq_normalizeTriple_symmetricSquareImage,
    firstNormalized, secondNormalized, polarValue_scaleTriple, polarValue_symmetricSquareImage]
  rw [mul_eq_zero_field _ _ (mul_ne_zero_field _ _ firstFactor_nonzero secondFactor_nonzero),
    mul_eq_zero_field _ _ (by
      have := mul_ne_zero_field _ _ invertible invertible
      simpa [pow_two] using this)]

/-- The polar row of an image point is the image of the polar row. -/
theorem polarRow_orbitMap (element : ProjectiveElement) (point : InternalPoint) :
    polarRow (orbitMap element point) = (polarRow point).image (orbitMap element) := by
  have invertible := determinant_ne_zero_of_mem element.2
  ext other
  obtain ⟨source, rfl⟩ := (orbitMap_bijective element).surjective other
  have point_nondegenerate : pointDiscriminant point.1 ≠ 0 :=
    ((mem_internalCoordinateList_iff _).mp (mem_internalCoordinateList_of_internalPoint point)).2.1
  have source_nondegenerate : pointDiscriminant source.1 ≠ 0 :=
    ((mem_internalCoordinateList_iff _).mp (mem_internalCoordinateList_of_internalPoint source)).2.1
  rw [polarRow, Finset.mem_filter, polarRow]
  constructor
  · rintro ⟨-, vanishes⟩
    refine Finset.mem_image.mpr ⟨source, Finset.mem_filter.mpr ⟨Finset.mem_univ _, ?_⟩, rfl⟩
    exact (polarValue_act_eq_zero_iff invertible point_nondegenerate source_nondegenerate).mp
      vanishes
  · intro member
    obtain ⟨candidate, candidate_mem, candidate_image⟩ := Finset.mem_image.mp member
    have candidate_eq : candidate = source := (orbitMap_bijective element).injective candidate_image
    subst candidate_eq
    refine ⟨Finset.mem_univ _, ?_⟩
    exact (polarValue_act_eq_zero_iff invertible point_nondegenerate source_nondegenerate).mpr
      (Finset.mem_filter.mp candidate_mem).2

/-- The concurrence-eight neighbourhood of an image point is the image of the neighbourhood. -/
theorem pairNeighborhood_orbitMap (element : ProjectiveElement) (color : ℕ)
    (point : InternalPoint) :
    pairNeighborhood semanticMinimumSupports color (orbitMap element point) =
      (pairNeighborhood semanticMinimumSupports color point).image (orbitMap element) := by
  ext other
  obtain ⟨source, rfl⟩ := (orbitMap_bijective element).surjective other
  rw [pairNeighborhood, Finset.mem_filter, pairNeighborhood]
  constructor
  · rintro ⟨-, different, colored⟩
    refine Finset.mem_image.mpr ⟨source, Finset.mem_filter.mpr ⟨Finset.mem_univ _, ?_, ?_⟩, rfl⟩
    · exact fun equal => different (congrArg (orbitMap element) equal)
    · rwa [pairConcurrence_orbitMap] at colored
  · intro member
    obtain ⟨candidate, candidate_mem, candidate_image⟩ := Finset.mem_image.mp member
    have candidate_eq : candidate = source := (orbitMap_bijective element).injective candidate_image
    subst candidate_eq
    obtain ⟨-, different, colored⟩ := Finset.mem_filter.mp candidate_mem
    refine ⟨Finset.mem_univ _, ?_, ?_⟩
    · exact fun equal => different ((orbitMap_bijective element).injective equal)
    · rwa [pairConcurrence_orbitMap]

/-! ## Reduction to representatives -/

/-- Two families generated by equivariant point functions agree as soon as they agree at the first
internal point. -/
theorem image_univ_eq_of_orbitMap_equivariant
    {left right : InternalPoint → Finset InternalPoint}
    (left_equivariant : ∀ (element : ProjectiveElement) (point : InternalPoint),
      left (orbitMap element point) = (left point).image (orbitMap element))
    (right_equivariant : ∀ (element : ProjectiveElement) (point : InternalPoint),
      right (orbitMap element point) = (right point).image (orbitMap element))
    (agree : left basePoint = right basePoint) :
    Finset.univ.image left = Finset.univ.image right := by
  ext family
  constructor <;> intro member <;> obtain ⟨point, -, rfl⟩ := Finset.mem_image.mp member <;>
    obtain ⟨element, rfl⟩ := exists_orbitMap_basePoint point
  · exact Finset.mem_image.mpr ⟨orbitMap element basePoint, Finset.mem_univ _, by
      rw [left_equivariant, right_equivariant, agree]⟩
  · exact Finset.mem_image.mpr ⟨orbitMap element basePoint, Finset.mem_univ _, by
      rw [left_equivariant, right_equivariant, agree]⟩

/-- The number of points whose pair counts with two given points are both seven is unchanged by the
action. -/
theorem fusedCount_orbitMap (element : ProjectiveElement) (first second : InternalPoint) :
    (Finset.univ.filter fun middle =>
        ConicPassantCode.pairConcurrence semanticMinimumSupports (orbitMap element first) middle
            = 7 ∧
          ConicPassantCode.pairConcurrence semanticMinimumSupports middle
            (orbitMap element second) = 7).card =
      (Finset.univ.filter fun middle =>
        ConicPassantCode.pairConcurrence semanticMinimumSupports first middle = 7 ∧
          ConicPassantCode.pairConcurrence semanticMinimumSupports middle second = 7).card := by
  have injective := (orbitMap_bijective element).injective
  rw [← Finset.card_image_of_injective (Finset.univ.filter fun middle =>
    ConicPassantCode.pairConcurrence semanticMinimumSupports first middle = 7 ∧
      ConicPassantCode.pairConcurrence semanticMinimumSupports middle second = 7) injective]
  congr 1
  ext middle
  rw [Finset.mem_filter, Finset.mem_image]
  constructor
  · rintro ⟨-, firstColored, secondColored⟩
    obtain ⟨source, rfl⟩ := (orbitMap_bijective element).surjective middle
    rw [pairConcurrence_orbitMap] at firstColored secondColored
    exact ⟨source, Finset.mem_filter.mpr ⟨Finset.mem_univ _, firstColored, secondColored⟩, rfl⟩
  · rintro ⟨source, source_mem, rfl⟩
    obtain ⟨-, firstColored, secondColored⟩ := Finset.mem_filter.mp source_mem
    exact ⟨Finset.mem_univ _, by rwa [pairConcurrence_orbitMap],
      by rwa [pairConcurrence_orbitMap]⟩

/-! ## The counts at the level of the displayed indices

The displayed supports of `PassantCodeQ13.MinimumWords.minimumWordSupports` are the encoded
minimum-word family, so every count below is a count over a displayed list of literals.
-/

/-- The number of supports of a displayed encoded family through a displayed index. -/
def unaryDegreeIn (supports : List Nat) (index : Nat) : Nat :=
  supports.countP fun support => support.testBit index

/-- The unary degree at a displayed index is a count over the displayed supports. -/
theorem indexedUnaryDegree_eq_unaryDegreeIn (index : Fin 78) :
    indexedUnaryDegree (internalPointAt index) = unaryDegreeIn minimumWordSupports index.1 := by
  unfold indexedUnaryDegree unaryDegreeIn
  rw [internalPointIndex_internalPointAt, minimumSupportCodes_eq]

/-- The pair concurrence at two displayed indices is a count over the displayed supports. -/
theorem indexedPairConcurrence_eq_pairConcurrenceIn (first second : Fin 78) :
    indexedPairConcurrence (internalPointAt first) (internalPointAt second) =
      pairConcurrenceIn minimumWordSupports first.1 second.1 := by
  unfold indexedPairConcurrence pairConcurrenceIn
  rw [internalPointIndex_internalPointAt, internalPointIndex_internalPointAt,
    minimumSupportCodes_eq]

/-- Counting internal points satisfying a condition is counting their displayed indices. -/
theorem card_filter_univ_internalPoint (predicate : InternalPoint → Prop)
    [DecidablePred predicate] :
    (Finset.univ.filter predicate).card =
      (Finset.univ.filter fun index : Fin 78 => predicate (internalPointAt index)).card := by
  rw [← Finset.card_image_of_injective (Finset.univ.filter fun index : Fin 78 =>
    predicate (internalPointAt index)) internalPointAt_bijective.injective]
  congr 1
  ext point
  obtain ⟨index, rfl⟩ := internalPointAt_bijective.surjective point
  simp [Finset.mem_image, internalPointAt_bijective.injective.eq_iff]

/-! ## The two checks at the first displayed index -/

/-- The first displayed index lies on 56 of the displayed supports. -/
theorem unaryDegreeIn_zero : unaryDegreeIn minimumWordSupports 0 = 56 := by
  decide +kernel

/-- At the first displayed index, the indices of pair concurrence eight are exactly the indices of
its polar row.  Decided over the 78 displayed indices. -/
theorem pairColorEightIn_zero : ∀ index : Fin 78,
    (index.1 ≠ 0 ∧ pairConcurrenceIn minimumWordSupports 0 index.1 = 8) ↔
      polarValue (internalAt 0) (internalAt index.1) = 0 := by
  decide +kernel

/-! ## The two statements at the first internal point -/

/-- The first internal point lies on 56 minimum-word supports. -/
theorem card_filter_mem_basePoint :
    (semanticMinimumSupports.filter fun support => basePoint ∈ support).card = 56 := by
  rw [← indexedUnaryDegree_eq_card, show basePoint = internalPointAt 0 from rfl,
    indexedUnaryDegree_eq_unaryDegreeIn 0]
  exact unaryDegreeIn_zero

/-- The displayed index of an internal point is the first one exactly when the point is the base
point. -/
private theorem internalPointAt_eq_basePoint_iff (index : Fin 78) :
    internalPointAt index = basePoint ↔ index.1 = 0 := by
  constructor
  · intro equal
    have : index = (0 : Fin 78) := internalPointAt_bijective.injective equal
    simpa using congrArg Fin.val this
  · intro zero
    have : index = (0 : Fin 78) := Fin.ext (by simpa using zero)
    rw [this]
    rfl

/-- At the first internal point, the concurrence-eight neighbourhood is the polar row. -/
theorem pairNeighborhood_basePoint_eq_polarRow :
    pairNeighborhood semanticMinimumSupports 8 basePoint = polarRow basePoint := by
  ext other
  obtain ⟨index, rfl⟩ := internalPointAt_bijective.surjective other
  have coordinates : polarValue basePoint.1 (internalPointAt index).1
      = polarValue (internalAt 0) (internalAt index.1) := by
    rw [show basePoint.1 = internalAt 0 from internalPointAt_val 0, internalPointAt_val index]
  have concurrence :
      ConicPassantCode.pairConcurrence semanticMinimumSupports basePoint (internalPointAt index) =
        pairConcurrenceIn minimumWordSupports 0 index.1 := by
    rw [← indexedPairConcurrence_eq_semantic]
    exact indexedPairConcurrence_eq_pairConcurrenceIn 0 index
  simp only [pairNeighborhood, polarRow, Finset.mem_filter, Finset.mem_univ, true_and]
  rw [coordinates, concurrence, ne_eq, internalPointAt_eq_basePoint_iff index, ← ne_eq]
  exact pairColorEightIn_zero index

end PassantCodeQ13.Equivariance
