import PassantCodeQ13.SymmetricSquareInvariance

/-!
# The symmetric-square action as a group action on the internal points

The normalized invertible two-by-two matrices over `ZMod 13` act on the coefficient triples of
binary quadratic forms through their symmetric square, and the model normalizes the image
representative by its first nonzero coordinate.  This module upgrades that map to a genuine action:
the symmetric square is multiplicative, normalizing a matrix rescales it, and rescaling a matrix or
a triple leaves the normalized image unchanged, so composing the maps of two normalized matrices is
the map of the normalized product, which is again normalized and invertible.

Concretely, writing `S_M` for the symmetric square of `M` on triples, the module proves
`S_{MN} = S_M ∘ S_N` and `S_{λM} = λ² S_M` as polynomial identities in the eight matrix entries and
three coordinates, together with `det(MN) = det M · det N` and `det(λM) = λ² det M`.  Normalization
of a triple is invariant under rescaling, so the model's map `act M` depends only on the projective
class of `M`, and `act M ∘ act N = act (MN)` on triples of nonvanishing discriminant.

The resulting action on the subtype of internal points is recorded as `orbitMap`, which is a
bijection of the 78 internal points for every normalized invertible matrix, and satisfies
`orbitMap g ∘ orbitMap h = orbitMap (g * h)` for the composition `projectiveCompose`.  No finite
check in this module ranges over the matrices: the only computations are scalar identities in
`ZMod 13`, each decided by kernel reduction over the field or over ordered pairs of field elements.
-/

namespace PassantCodeQ13.Equivariance

open RelativeConicArcs.PassantCodeQ13
open PassantCodeQ13.MinimumWords
open PassantCodeQ13.SymmetricSquare

/-! ## Scalar arithmetic used to cancel normalization factors -/

/-- A nonzero factor may be cancelled from a vanishing product. -/
theorem mul_eq_zero_field : ∀ factor value : Field13, factor ≠ 0 →
    (factor * value = 0 ↔ value = 0) := by
  decide +kernel

/-- A nonzero element cancels against its inverse on the left. -/
theorem inv_mul_cancel_field : ∀ value : Field13, value ≠ 0 → value⁻¹ * value = 1 := by
  decide +kernel

/-! ## Products and rescalings of matrices -/

/-- The ordinary product of two-by-two matrices in the displayed entry order. -/
def matrixProduct (left right : Matrix2) : Matrix2 :=
  ⟨left.a * right.a + left.b * right.c, left.a * right.b + left.b * right.d,
    left.c * right.a + left.d * right.c, left.c * right.b + left.d * right.d⟩

/-- The scalar multiple of a two-by-two matrix. -/
def scaleMatrix (factor : Field13) (matrix : Matrix2) : Matrix2 :=
  ⟨factor * matrix.a, factor * matrix.b, factor * matrix.c, factor * matrix.d⟩

/-- The determinant is multiplicative. -/
theorem determinant_matrixProduct (left right : Matrix2) :
    determinant (matrixProduct left right) = determinant left * determinant right := by
  simp only [determinant, matrixProduct]
  ring

/-- The determinant is homogeneous of degree two. -/
theorem determinant_scaleMatrix (factor : Field13) (matrix : Matrix2) :
    determinant (scaleMatrix factor matrix) = factor ^ 2 * determinant matrix := by
  simp only [determinant, scaleMatrix]
  ring

/-- The symmetric square is multiplicative on the coefficient triples. -/
theorem symmetricSquareImage_matrixProduct (left right : Matrix2) (point : Triple) :
    symmetricSquareImage (matrixProduct left right) point =
      symmetricSquareImage left (symmetricSquareImage right point) := by
  simp only [symmetricSquareImage, matrixProduct]
  refine Triple.mk.injEq .. ▸ ?_
  refine ⟨by ring, by ring, by ring⟩

/-- Rescaling a matrix rescales its symmetric square by the square of the factor. -/
theorem symmetricSquareImage_scaleMatrix (factor : Field13) (matrix : Matrix2) (point : Triple) :
    symmetricSquareImage (scaleMatrix factor matrix) point =
      scaleTriple (factor ^ 2) (symmetricSquareImage matrix point) := by
  simp only [symmetricSquareImage, scaleMatrix, scaleTriple]
  refine Triple.mk.injEq .. ▸ ?_
  refine ⟨by ring, by ring, by ring⟩

/-! ## Normalization of a triple depends only on its projective class -/

/-- Rescaling by a nonzero factor does not change the normalized representative. -/
theorem normalizeTriple_scaleTriple {factor : Field13} (nonzero : factor ≠ 0) (point : Triple) :
    normalizeTriple (scaleTriple factor point) = normalizeTriple point := by
  obtain ⟨x, y, z⟩ := point
  by_cases first_zero : x = 0
  · by_cases second_zero : y = 0
    · simp [normalizeTriple, scaleTriple, first_zero, second_zero]
    · have scaled_second : factor * y ≠ 0 := fun vanishes =>
        second_zero ((mul_eq_zero_field factor y nonzero).mp vanishes)
      simp only [normalizeTriple, scaleTriple, bne_iff_ne, ne_eq, scaled_second,
        first_zero, second_zero, not_true_eq_false, not_false_eq_true,
        if_neg, if_pos]
      exact Triple.mk.injEq .. ▸ ⟨rfl, rfl, common_factor_cancel factor z y nonzero⟩
  · have scaled_first : factor * x ≠ 0 := fun vanishes =>
      first_zero ((mul_eq_zero_field factor x nonzero).mp vanishes)
    simp only [normalizeTriple, scaleTriple, bne_iff_ne, ne_eq, scaled_first, first_zero,
      not_false_eq_true, if_pos]
    exact Triple.mk.injEq .. ▸
      ⟨rfl, common_factor_cancel factor y x nonzero, common_factor_cancel factor z x nonzero⟩

/-- The model's map depends only on the projective class of the matrix. -/
theorem act_scaleMatrix {factor : Field13} (nonzero : factor ≠ 0) (matrix : Matrix2)
    (point : Triple) : act (scaleMatrix factor matrix) point = act matrix point := by
  have square_nonzero : factor ^ 2 ≠ 0 := by
    have := mul_ne_zero_field factor factor nonzero nonzero
    simpa [pow_two] using this
  rw [act_eq_normalizeTriple_symmetricSquareImage, act_eq_normalizeTriple_symmetricSquareImage,
    symmetricSquareImage_scaleMatrix, normalizeTriple_scaleTriple square_nonzero]

/-- Composition of the maps of two matrices is the map of their product, at a point whose
discriminant does not vanish and for a right factor of nonzero determinant. -/
theorem act_act {left right : Matrix2} (right_invertible : determinant right ≠ 0)
    {point : Triple} (nondegenerate : pointDiscriminant point ≠ 0) :
    act left (act right point) = act (matrixProduct left right) point := by
  have image_nondegenerate : pointDiscriminant (symmetricSquareImage right point) ≠ 0 := by
    rw [pointDiscriminant_symmetricSquareImage]
    intro vanishes
    exact nondegenerate ((sq_mul_eq_zero_iff _ _ right_invertible).mp vanishes)
  obtain ⟨factor, factor_nonzero, normalized⟩ :=
    normalizeTriple_eq_scaleTriple (ne_zero_of_pointDiscriminant_ne_zero image_nondegenerate)
  rw [act_eq_normalizeTriple_symmetricSquareImage (matrix := right), normalized,
    act_eq_normalizeTriple_symmetricSquareImage, symmetricSquareImage_scaleTriple,
    normalizeTriple_scaleTriple factor_nonzero, act_eq_normalizeTriple_symmetricSquareImage,
    symmetricSquareImage_matrixProduct]

/-! ## The normalized representative of an invertible matrix -/

/-- The normalized representative of an invertible matrix: rescale so that the first nonzero entry,
in the order `a, b, c, d`, becomes one. -/
def normalizeMatrix (matrix : Matrix2) : Matrix2 :=
  if matrix.a ≠ 0 then scaleMatrix matrix.a⁻¹ matrix
  else if matrix.b ≠ 0 then scaleMatrix matrix.b⁻¹ matrix
  else if matrix.c ≠ 0 then scaleMatrix matrix.c⁻¹ matrix
  else scaleMatrix matrix.d⁻¹ matrix

/-- Normalization rescales an invertible matrix by a nonzero factor. -/
theorem normalizeMatrix_eq_scaleMatrix {matrix : Matrix2} (invertible : determinant matrix ≠ 0) :
    ∃ factor : Field13, factor ≠ 0 ∧ normalizeMatrix matrix = scaleMatrix factor matrix := by
  by_cases first_nonzero : matrix.a ≠ 0
  · exact ⟨matrix.a⁻¹, inv_ne_zero_field _ first_nonzero, by simp [normalizeMatrix, first_nonzero]⟩
  · by_cases second_nonzero : matrix.b ≠ 0
    · exact ⟨matrix.b⁻¹, inv_ne_zero_field _ second_nonzero, by
        simp [normalizeMatrix, first_nonzero, second_nonzero]⟩
    · by_cases third_nonzero : matrix.c ≠ 0
      · exact ⟨matrix.c⁻¹, inv_ne_zero_field _ third_nonzero, by
          simp [normalizeMatrix, first_nonzero, second_nonzero, third_nonzero]⟩
      · have first_zero : matrix.a = 0 := not_not.mp first_nonzero
        have second_zero : matrix.b = 0 := not_not.mp second_nonzero
        have third_zero : matrix.c = 0 := not_not.mp third_nonzero
        have fourth_nonzero : matrix.d ≠ 0 := by
          intro fourth_zero
          exact invertible (by simp [determinant, first_zero, second_zero, third_zero, fourth_zero])
        exact ⟨matrix.d⁻¹, inv_ne_zero_field _ fourth_nonzero, by
          simp [normalizeMatrix, first_nonzero, second_nonzero, third_nonzero]⟩

/-- The normalized representative of an invertible matrix acts as the matrix itself. -/
theorem act_normalizeMatrix {matrix : Matrix2} (invertible : determinant matrix ≠ 0)
    (point : Triple) : act (normalizeMatrix matrix) point = act matrix point := by
  obtain ⟨factor, nonzero, rescaled⟩ := normalizeMatrix_eq_scaleMatrix invertible
  rw [rescaled, act_scaleMatrix nonzero]

/-- The normalized representative of an invertible matrix is again invertible. -/
theorem determinant_normalizeMatrix_ne_zero {matrix : Matrix2}
    (invertible : determinant matrix ≠ 0) : determinant (normalizeMatrix matrix) ≠ 0 := by
  obtain ⟨factor, nonzero, rescaled⟩ := normalizeMatrix_eq_scaleMatrix invertible
  rw [rescaled, determinant_scaleMatrix]
  have square_nonzero : factor ^ 2 ≠ 0 := by
    have := mul_ne_zero_field factor factor nonzero nonzero
    simpa [pow_two] using this
  intro vanishes
  exact invertible ((sq_mul_eq_zero_iff _ _ nonzero).mp vanishes)

/-- The normalized representative of an invertible matrix occurs in the displayed matrix list. -/
theorem normalizeMatrix_mem_projectiveMatrices {matrix : Matrix2}
    (invertible : determinant matrix ≠ 0) : normalizeMatrix matrix ∈ projectiveMatrices := by
  have determinant_nonzero := determinant_normalizeMatrix_ne_zero invertible
  refine List.mem_filter.mpr ⟨?_, by simpa using determinant_nonzero⟩
  by_cases first_nonzero : matrix.a ≠ 0
  · have expand : normalizeMatrix matrix = scaleMatrix matrix.a⁻¹ matrix := by
      rw [normalizeMatrix, if_pos first_nonzero]
    refine List.mem_append.mpr (Or.inl (List.mem_append.mpr (Or.inl (List.mem_append.mpr
      (Or.inl ?_)))))
    refine List.mem_flatMap.mpr ⟨(normalizeMatrix matrix).b, mem_fieldElements _, ?_⟩
    refine List.mem_flatMap.mpr ⟨(normalizeMatrix matrix).c, mem_fieldElements _, ?_⟩
    refine List.mem_map.mpr ⟨(normalizeMatrix matrix).d, mem_fieldElements _, ?_⟩
    rw [expand]
    simp [scaleMatrix, inv_mul_cancel_field _ first_nonzero]
  · have first_zero : matrix.a = 0 := not_not.mp first_nonzero
    by_cases second_nonzero : matrix.b ≠ 0
    · have expand : normalizeMatrix matrix = scaleMatrix matrix.b⁻¹ matrix := by
        rw [normalizeMatrix, if_neg first_nonzero, if_pos second_nonzero]
      refine List.mem_append.mpr (Or.inl (List.mem_append.mpr (Or.inl (List.mem_append.mpr
        (Or.inr ?_)))))
      refine List.mem_flatMap.mpr ⟨(normalizeMatrix matrix).c, mem_fieldElements _, ?_⟩
      refine List.mem_map.mpr ⟨(normalizeMatrix matrix).d, mem_fieldElements _, ?_⟩
      rw [expand]
      simp [scaleMatrix, first_zero, inv_mul_cancel_field _ second_nonzero]
    · have second_zero : matrix.b = 0 := not_not.mp second_nonzero
      by_cases third_nonzero : matrix.c ≠ 0
      · have expand : normalizeMatrix matrix = scaleMatrix matrix.c⁻¹ matrix := by
          rw [normalizeMatrix, if_neg first_nonzero, if_neg second_nonzero, if_pos third_nonzero]
        refine List.mem_append.mpr (Or.inl (List.mem_append.mpr (Or.inr ?_)))
        refine List.mem_map.mpr ⟨(normalizeMatrix matrix).d, mem_fieldElements _, ?_⟩
        rw [expand]
        simp [scaleMatrix, first_zero, second_zero, inv_mul_cancel_field _ third_nonzero]
      · have third_zero : matrix.c = 0 := not_not.mp third_nonzero
        have fourth_nonzero : matrix.d ≠ 0 := by
          intro fourth_zero
          exact invertible (by simp [determinant, first_zero, second_zero, third_zero, fourth_zero])
        have expand : normalizeMatrix matrix = scaleMatrix matrix.d⁻¹ matrix := by
          rw [normalizeMatrix, if_neg first_nonzero, if_neg second_nonzero, if_neg third_nonzero]
        refine List.mem_append.mpr (Or.inr (List.mem_singleton.mpr ?_))
        rw [expand]
        simp [scaleMatrix, first_zero, second_zero, third_zero,
          inv_mul_cancel_field _ fourth_nonzero]

/-! ## The action on the internal points -/

/-- A normalized invertible matrix, one representative per element of the projective group. -/
abbrev ProjectiveElement := {matrix : Matrix2 // matrix ∈ projectiveMatrices}

/-- The composition of two normalized invertible matrices, normalized again. -/
def projectiveCompose (left right : ProjectiveElement) : ProjectiveElement :=
  ⟨normalizeMatrix (matrixProduct left.1 right.1),
    normalizeMatrix_mem_projectiveMatrices (by
      rw [determinant_matrixProduct]
      exact mul_ne_zero_field _ _ (determinant_ne_zero_of_mem left.2)
        (determinant_ne_zero_of_mem right.2))⟩

/-- The displayed internal coordinate list enumerates the internal coordinate set. -/
theorem mem_internalCoordinateList_iff_mem_internalCoordinates (point : Triple) :
    point ∈ internalCoordinateList ↔ point ∈ internalCoordinates := by
  rw [← internalCoordinateList_toFinset, List.mem_toFinset]

/-- An internal point is an element of the displayed internal coordinate list. -/
theorem mem_internalCoordinateList_of_internalPoint (point : InternalPoint) :
    point.1 ∈ internalCoordinateList :=
  (mem_internalCoordinateList_iff_mem_internalCoordinates _).mpr point.2

/-- The action of a normalized invertible matrix on the internal points. -/
def orbitMap (element : ProjectiveElement) (point : InternalPoint) : InternalPoint :=
  ⟨act element.1 point.1,
    (mem_internalCoordinateList_iff_mem_internalCoordinates _).mp
      (act_mem_internalCoordinateList element.2
        (mem_internalCoordinateList_of_internalPoint point))⟩

@[simp] theorem orbitMap_coe (element : ProjectiveElement) (point : InternalPoint) :
    (orbitMap element point).1 = act element.1 point.1 := rfl

/-- The action of a normalized invertible matrix is a bijection of the internal points. -/
theorem orbitMap_bijective (element : ProjectiveElement) :
    Function.Bijective (orbitMap element) := by
  refine Finite.injective_iff_bijective.mp ?_
  intro first second equal_images
  exact Subtype.ext (act_injective_on_internalCoordinateList element.2
    (mem_internalCoordinateList_of_internalPoint first)
    (mem_internalCoordinateList_of_internalPoint second)
    (congrArg Subtype.val equal_images))

/-- The maps of two normalized invertible matrices compose to the map of their composition. -/
theorem orbitMap_projectiveCompose (left right : ProjectiveElement) (point : InternalPoint) :
    orbitMap left (orbitMap right point) = orbitMap (projectiveCompose left right) point := by
  refine Subtype.ext ?_
  have nondegenerate : pointDiscriminant point.1 ≠ 0 :=
    ((mem_internalCoordinateList_iff _).mp (mem_internalCoordinateList_of_internalPoint point)).2.1
  have product_invertible : determinant (matrixProduct left.1 right.1) ≠ 0 := by
    rw [determinant_matrixProduct]
    exact mul_ne_zero_field _ _ (determinant_ne_zero_of_mem left.2)
      (determinant_ne_zero_of_mem right.2)
  show act left.1 (act right.1 point.1)
    = act (normalizeMatrix (matrixProduct left.1 right.1)) point.1
  rw [act_normalizeMatrix product_invertible]
  exact act_act (determinant_ne_zero_of_mem right.2) nondegenerate

end PassantCodeQ13.Equivariance
