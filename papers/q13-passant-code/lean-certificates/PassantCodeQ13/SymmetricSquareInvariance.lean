import PassantCodeQ13.AssociationAlgebra
import PassantCodeQ13.MinimumWords.NormalizedIndexTable

/-!
# Invariance of the normalized polar parameter under the symmetric-square action

A point of the model is a coefficient triple `(x,y,z)` of the binary quadratic form
`x X² + 2y XY + z Y²`, and a projective matrix `M = ⟨a,b,c,d⟩` acts on it by substitution, which is
the symmetric square of `M` in these coordinates.  Write `S_M` for that linear map on triples,
`Q(u) = u_y² - u_x u_z` for the discriminant, and `B(u,v) = 2u_y v_y - u_x v_z - u_z v_x` for its
polarization.  Substitution multiplies both by the square of the determinant,

`Q(S_M u) = (det M)² Q(u)` and `B(S_M u, S_M v) = (det M)² B(u,v)`,

and both are homogeneous in each argument: `Q(λu) = λ²Q(u)` and `B(λu, μv) = λμ B(u,v)`.  The
normalized parameter `B(u,v)² / (Q(u)Q(v))` is therefore bi-homogeneous of degree zero in the two
points and unchanged by substitution.  Since the model's action normalizes its image by rescaling to
the first nonzero coordinate, this is exactly the invariance of the six-valued elliptic relation of
two internal points under the full projective group.

The two displayed transformation laws and the two homogeneity laws are polynomial identities in the
four matrix entries and the six point coordinates and are proved by `ring`.  The scalar facts about
`ZMod 13` used to divide by nonzero elements, the preservation of the quadratic character of the
discriminant, and the agreement of the indexed internal model with the coordinate model are proved
by exhaustive kernel reduction over the stated finite domains: the field itself, ordered pairs of
field elements, the 183 normalized representatives, and the 78 internal coordinates.  No leaf here
uses compiled evaluation.

The consequences recorded for the indexed model are that the action of a normalized invertible
matrix preserves internality, is injective on the internal coordinates, and preserves the polar
parameter.  Together with a further identity for the adjugate, `S_adj(M) ∘ S_M = (det M)² · id`,
these replace the corresponding enumerations over all 2184 matrices.
-/

namespace PassantCodeQ13.SymmetricSquare

open RelativeConicArcs.PassantCodeQ13
open PassantCodeQ13.MinimumWords
open PassantCodeQ13.WeightTen

/-! ## Scalar arithmetic in the prime field

The four facts below are decided exhaustively over `ZMod 13` and over ordered pairs of its
elements. -/

/-- A product of nonzero field elements is nonzero. -/
theorem mul_ne_zero_field : ∀ first second : Field13, first ≠ 0 → second ≠ 0 →
    first * second ≠ 0 := by
  decide +kernel

/-- Inversion is nonzero on nonzero elements. -/
theorem inv_ne_zero_field : ∀ value : Field13, value ≠ 0 → value⁻¹ ≠ 0 := by
  decide +kernel

/-- A nonzero element cancels against its inverse. -/
theorem mul_inv_cancel_field : ∀ value : Field13, value ≠ 0 → value * value⁻¹ = 1 := by
  decide +kernel

/-- Inversion of a product, valid for every pair because the inverse of zero is zero. -/
theorem mul_inv_field : ∀ first second : Field13, (first * second)⁻¹ = first⁻¹ * second⁻¹ := by
  decide +kernel

/-- A common nonzero factor cancels between a numerator and an inverted denominator. -/
theorem common_factor_cancel (factor numerator denominator : Field13) (nonzero : factor ≠ 0) :
    factor * numerator * (factor * denominator)⁻¹ = numerator * denominator⁻¹ := by
  rw [mul_inv_field]
  calc factor * numerator * (factor⁻¹ * denominator⁻¹)
      = factor * factor⁻¹ * (numerator * denominator⁻¹) := by ring
    _ = numerator * denominator⁻¹ := by rw [mul_inv_cancel_field factor nonzero, one_mul]

/-- Multiplying by a nonzero square preserves vanishing of the discriminant value. -/
theorem sq_mul_eq_zero_iff : ∀ factor value : Field13, factor ≠ 0 →
    (factor ^ 2 * value = 0 ↔ value = 0) := by
  decide +kernel

/-- Multiplying by a nonzero square preserves the quadratic character. -/
theorem isNonzeroSquare_sq_mul : ∀ factor value : Field13, factor ≠ 0 →
    isNonzeroSquare (factor ^ 2 * value) = isNonzeroSquare value := by
  decide +kernel

/-! ## The unnormalized substitution map -/

/-- Scalar multiple of a homogeneous coordinate triple. -/
def scaleTriple (factor : Field13) (point : Triple) : Triple :=
  ⟨factor * point.x, factor * point.y, factor * point.z⟩

/-- The symmetric square of a two-by-two matrix acting on a coefficient triple, before the model's
normalization of the representative. -/
def symmetricSquareImage (matrix : Matrix2) (point : Triple) : Triple :=
  ⟨matrix.a ^ 2 * point.x + 2 * matrix.a * matrix.b * point.y + matrix.b ^ 2 * point.z,
    matrix.a * matrix.c * point.x +
      (matrix.a * matrix.d + matrix.b * matrix.c) * point.y +
      matrix.b * matrix.d * point.z,
    matrix.c ^ 2 * point.x + 2 * matrix.c * matrix.d * point.y + matrix.d ^ 2 * point.z⟩

/-- The adjugate of a two-by-two matrix. -/
def adjugate (matrix : Matrix2) : Matrix2 :=
  ⟨matrix.d, -matrix.b, -matrix.c, matrix.a⟩

/-- The model's action is the substitution map followed by normalization of the representative. -/
theorem act_eq_normalizeTriple_symmetricSquareImage (matrix : Matrix2) (point : Triple) :
    act matrix point = normalizeTriple (symmetricSquareImage matrix point) := rfl

/-- Substitution multiplies the discriminant by the square of the determinant. -/
theorem pointDiscriminant_symmetricSquareImage (matrix : Matrix2) (point : Triple) :
    pointDiscriminant (symmetricSquareImage matrix point) =
      determinant matrix ^ 2 * pointDiscriminant point := by
  simp only [pointDiscriminant, symmetricSquareImage, determinant]
  ring

/-- Substitution multiplies the polar form by the square of the determinant. -/
theorem polarValue_symmetricSquareImage (matrix : Matrix2) (first second : Triple) :
    polarValue (symmetricSquareImage matrix first) (symmetricSquareImage matrix second) =
      determinant matrix ^ 2 * polarValue first second := by
  simp only [polarValue, symmetricSquareImage, determinant]
  ring

/-- The substitution map is linear in the point, in the form needed for rescaled representatives. -/
theorem symmetricSquareImage_scaleTriple (matrix : Matrix2) (factor : Field13) (point : Triple) :
    symmetricSquareImage matrix (scaleTriple factor point) =
      scaleTriple factor (symmetricSquareImage matrix point) := by
  simp only [symmetricSquareImage, scaleTriple]
  refine Triple.mk.injEq .. ▸ ?_
  refine ⟨by ring, by ring, by ring⟩

/-- Composing with the adjugate returns the square of the determinant. -/
theorem symmetricSquareImage_adjugate (matrix : Matrix2) (point : Triple) :
    symmetricSquareImage (adjugate matrix) (symmetricSquareImage matrix point) =
      scaleTriple (determinant matrix ^ 2) point := by
  simp only [symmetricSquareImage, adjugate, scaleTriple, determinant]
  refine Triple.mk.injEq .. ▸ ?_
  refine ⟨by ring, by ring, by ring⟩

/-- The discriminant is homogeneous of degree two. -/
theorem pointDiscriminant_scaleTriple (factor : Field13) (point : Triple) :
    pointDiscriminant (scaleTriple factor point) = factor ^ 2 * pointDiscriminant point := by
  simp only [pointDiscriminant, scaleTriple]
  ring

/-- The polar form is homogeneous of degree one in each argument. -/
theorem polarValue_scaleTriple (first second : Field13) (left right : Triple) :
    polarValue (scaleTriple first left) (scaleTriple second right) =
      first * second * polarValue left right := by
  simp only [polarValue, scaleTriple]
  ring

/-- A nonzero scalar may be cancelled from a rescaled triple. -/
theorem scaleTriple_injective {factor : Field13} (nonzero : factor ≠ 0) {left right : Triple}
    (equal : scaleTriple factor left = scaleTriple factor right) : left = right := by
  obtain ⟨lx, ly, lz⟩ := left
  obtain ⟨rx, ry, rz⟩ := right
  simp only [scaleTriple, Triple.mk.injEq] at equal
  refine Triple.mk.injEq .. ▸ ⟨?_, ?_, ?_⟩ <;>
    [ (have := equal.1); (have := equal.2.1); (have := equal.2.2) ] <;>
    · have cancel := congrArg (fun value => factor⁻¹ * value) this
      simpa [← mul_assoc, mul_comm factor⁻¹ factor, mul_inv_cancel_field factor nonzero] using cancel

/-! ## Normalization as a rescaling -/

/-- A coordinate triple with nonzero discriminant is nonzero. -/
theorem ne_zero_of_pointDiscriminant_ne_zero {point : Triple}
    (nonzero : pointDiscriminant point ≠ 0) : point ≠ ⟨0, 0, 0⟩ := by
  intro degenerate
  apply nonzero
  rw [degenerate]
  simp [pointDiscriminant]

/-- Normalization rescales a nonzero triple by a nonzero factor. -/
theorem normalizeTriple_eq_scaleTriple {point : Triple} (nonzero : point ≠ ⟨0, 0, 0⟩) :
    ∃ factor : Field13, factor ≠ 0 ∧ normalizeTriple point = scaleTriple factor point := by
  obtain ⟨x, y, z⟩ := point
  by_cases first_zero : x = 0
  · by_cases second_zero : y = 0
    · have third_nonzero : z ≠ 0 := by
        intro third_zero
        exact nonzero (by simp [first_zero, second_zero, third_zero])
      refine ⟨z⁻¹, inv_ne_zero_field z third_nonzero, ?_⟩
      simp [normalizeTriple, scaleTriple, verticalTriple, first_zero, second_zero,
        mul_comm, mul_inv_cancel_field z third_nonzero]
    · refine ⟨y⁻¹, inv_ne_zero_field y second_zero, ?_⟩
      simp [normalizeTriple, scaleTriple, first_zero, second_zero, bne_iff_ne, ne_eq,
        mul_comm, mul_inv_cancel_field y second_zero]
  · refine ⟨x⁻¹, inv_ne_zero_field x first_zero, ?_⟩
    simp [normalizeTriple, scaleTriple, first_zero, bne_iff_ne, ne_eq,
      mul_comm, mul_inv_cancel_field x first_zero]

/-- Rescaling a normalized representative by a nonzero factor does not change its normalization.
Decided over all 183 representatives and all 13 scalars. -/
theorem normalizeTriple_scaleTriple_on_projectiveTripleList :
    projectiveTripleList.all (fun point =>
      fieldElements.all fun factor =>
        factor == 0 || normalizeTriple (scaleTriple factor point) == point) = true := by
  decide +kernel

/-- Every field element occurs in the displayed field list. -/
theorem mem_fieldElements : ∀ value : Field13, value ∈ fieldElements := by
  decide +kernel

/-- Two normalized representatives that differ by a nonzero scalar are equal. -/
theorem eq_of_scaleTriple_mem {point image : Triple} {factor : Field13} (nonzero : factor ≠ 0)
    (point_mem : point ∈ projectiveTripleList) (image_mem : image ∈ projectiveTripleList)
    (rescaled : image = scaleTriple factor point) : image = point := by
  have step := List.all_eq_true.mp normalizeTriple_scaleTriple_on_projectiveTripleList point
    point_mem
  have instance_at := List.all_eq_true.mp step factor (mem_fieldElements factor)
  have normalized : normalizeTriple (scaleTriple factor point) = point := by
    rcases Bool.or_eq_true .. ▸ instance_at with zero_case | equal_case
    · exact absurd (by simpa using zero_case) nonzero
    · simpa using equal_case
  -- a representative already in the list is its own normalization
  have self : normalizeTriple image = image := by
    have identity := List.all_eq_true.mp normalizeTriple_scaleTriple_on_projectiveTripleList image
      image_mem
    have one_case := List.all_eq_true.mp identity 1 (mem_fieldElements 1)
    have : normalizeTriple (scaleTriple 1 image) = image := by
      rcases Bool.or_eq_true .. ▸ one_case with zero_case | equal_case
      · exact absurd (by simpa using zero_case) (by decide : (1 : Field13) ≠ 0)
      · simpa using equal_case
    simpa [scaleTriple] using this
  rw [rescaled] at self
  rw [rescaled]
  exact self.symm.trans normalized

/-! ## The normalized polar parameter on coordinate triples -/

/-- The normalized polar parameter of two coordinate triples, in the form used by the indexed
elliptic relation. -/
def polarInvariant (first second : Triple) : Field13 :=
  polarValue first second ^ 2 * (pointDiscriminant first * pointDiscriminant second)⁻¹

/-- The indexed elliptic parameter is the coordinate parameter of the indexed points. -/
theorem rhoAt_eq_polarInvariant (first second : Nat) :
    PassantCodeQ13.AssociationAlgebra.rhoAt first second =
      polarInvariant (internalAt first) (internalAt second) := rfl

/-- The normalized polar parameter is unchanged by the projective action, for points whose
discriminant does not vanish and a matrix of nonzero determinant. -/
theorem polarInvariant_act {matrix : Matrix2} (invertible : determinant matrix ≠ 0)
    {first second : Triple} (first_nondegenerate : pointDiscriminant first ≠ 0)
    (second_nondegenerate : pointDiscriminant second ≠ 0) :
    polarInvariant (act matrix first) (act matrix second) = polarInvariant first second := by
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
    firstNormalized, secondNormalized]
  rw [polarInvariant, polarValue_scaleTriple, polarValue_symmetricSquareImage,
    pointDiscriminant_scaleTriple, pointDiscriminant_scaleTriple,
    pointDiscriminant_symmetricSquareImage, pointDiscriminant_symmetricSquareImage]
  set commonFactor : Field13 := (firstFactor * secondFactor * determinant matrix ^ 2) ^ 2 with
    commonFactor_def
  have commonFactor_nonzero : commonFactor ≠ 0 := by
    rw [commonFactor_def, pow_two (firstFactor * secondFactor * determinant matrix ^ 2),
      pow_two (determinant matrix)]
    exact mul_ne_zero_field _ _
      (mul_ne_zero_field _ _
        (mul_ne_zero_field _ _ firstFactor_nonzero secondFactor_nonzero)
        (mul_ne_zero_field _ _ invertible invertible))
      (mul_ne_zero_field _ _
        (mul_ne_zero_field _ _ firstFactor_nonzero secondFactor_nonzero)
        (mul_ne_zero_field _ _ invertible invertible))
  have numerator :
      (firstFactor * secondFactor * (determinant matrix ^ 2 * polarValue first second)) ^ 2 =
        commonFactor * polarValue first second ^ 2 := by
    rw [commonFactor_def]; ring
  have denominator :
      firstFactor ^ 2 * (determinant matrix ^ 2 * pointDiscriminant first) *
          (secondFactor ^ 2 * (determinant matrix ^ 2 * pointDiscriminant second)) =
        commonFactor * (pointDiscriminant first * pointDiscriminant second) := by
    rw [commonFactor_def]; ring
  rw [numerator, denominator]
  exact common_factor_cancel commonFactor _ _ commonFactor_nonzero

/-! ## Consequences for the indexed internal model -/

/-- A matrix of the displayed projective list has nonzero determinant. -/
theorem determinant_ne_zero_of_mem {matrix : Matrix2} (mem : matrix ∈ projectiveMatrices) :
    determinant matrix ≠ 0 := by
  have := (List.mem_filter.mp mem).2
  simpa using this

/-- Membership in the internal coordinate list is normalization together with the two
discriminant conditions. -/
theorem mem_internalCoordinateList_iff (point : Triple) :
    point ∈ internalCoordinateList ↔
      point ∈ projectiveTripleList ∧
        pointDiscriminant point ≠ 0 ∧ isNonzeroSquare (pointDiscriminant point) = false := by
  rw [internalCoordinateList, List.mem_filter]
  constructor
  · rintro ⟨mem, condition⟩
    have both := Bool.and_eq_true .. ▸ condition
    exact ⟨mem, by simpa using both.1, by simpa using both.2⟩
  · rintro ⟨mem, nonzero, nonsquare⟩
    refine ⟨mem, ?_⟩
    simp [nonzero, nonsquare]

/-- The projective action preserves internality of a coordinate. -/
theorem act_mem_internalCoordinateList {matrix : Matrix2} (mem : matrix ∈ projectiveMatrices)
    {point : Triple} (internal : point ∈ internalCoordinateList) :
    act matrix point ∈ internalCoordinateList := by
  have invertible := determinant_ne_zero_of_mem mem
  obtain ⟨_, nonzero, nonsquare⟩ := (mem_internalCoordinateList_iff point).mp internal
  have image_nondegenerate : pointDiscriminant (symmetricSquareImage matrix point) ≠ 0 := by
    rw [pointDiscriminant_symmetricSquareImage]
    intro vanishes
    exact nonzero ((sq_mul_eq_zero_iff _ _ invertible).mp vanishes)
  obtain ⟨factor, factor_nonzero, normalized⟩ :=
    normalizeTriple_eq_scaleTriple (ne_zero_of_pointDiscriminant_ne_zero image_nondegenerate)
  have discriminant_value :
      pointDiscriminant (act matrix point) =
        (factor * determinant matrix) ^ 2 * pointDiscriminant point := by
    rw [act_eq_normalizeTriple_symmetricSquareImage, normalized, pointDiscriminant_scaleTriple,
      pointDiscriminant_symmetricSquareImage]
    ring
  have scale_nonzero : factor * determinant matrix ≠ 0 :=
    mul_ne_zero_field _ _ factor_nonzero invertible
  refine (mem_internalCoordinateList_iff _).mpr ⟨act_mem_projectiveTripleList matrix point, ?_, ?_⟩
  · rw [discriminant_value]
    intro vanishes
    exact nonzero ((sq_mul_eq_zero_iff _ _ scale_nonzero).mp vanishes)
  · rw [discriminant_value, isNonzeroSquare_sq_mul _ _ scale_nonzero]
    exact nonsquare

/-- The projective action is injective on the internal coordinates. -/
theorem act_injective_on_internalCoordinateList {matrix : Matrix2}
    (mem : matrix ∈ projectiveMatrices) {left right : Triple}
    (left_internal : left ∈ internalCoordinateList) (right_internal : right ∈ internalCoordinateList)
    (equal_images : act matrix left = act matrix right) : left = right := by
  have invertible := determinant_ne_zero_of_mem mem
  obtain ⟨left_mem, left_nonzero, _⟩ := (mem_internalCoordinateList_iff left).mp left_internal
  obtain ⟨right_mem, right_nonzero, _⟩ := (mem_internalCoordinateList_iff right).mp right_internal
  have left_image_nondegenerate : pointDiscriminant (symmetricSquareImage matrix left) ≠ 0 := by
    rw [pointDiscriminant_symmetricSquareImage]
    intro vanishes
    exact left_nonzero ((sq_mul_eq_zero_iff _ _ invertible).mp vanishes)
  have right_image_nondegenerate : pointDiscriminant (symmetricSquareImage matrix right) ≠ 0 := by
    rw [pointDiscriminant_symmetricSquareImage]
    intro vanishes
    exact right_nonzero ((sq_mul_eq_zero_iff _ _ invertible).mp vanishes)
  obtain ⟨leftFactor, leftFactor_nonzero, leftNormalized⟩ :=
    normalizeTriple_eq_scaleTriple (ne_zero_of_pointDiscriminant_ne_zero left_image_nondegenerate)
  obtain ⟨rightFactor, rightFactor_nonzero, rightNormalized⟩ :=
    normalizeTriple_eq_scaleTriple (ne_zero_of_pointDiscriminant_ne_zero right_image_nondegenerate)
  have rescaled_images :
      scaleTriple leftFactor (symmetricSquareImage matrix left) =
        scaleTriple rightFactor (symmetricSquareImage matrix right) := by
    rw [← leftNormalized, ← rightNormalized,
      ← act_eq_normalizeTriple_symmetricSquareImage, ← act_eq_normalizeTriple_symmetricSquareImage]
    exact equal_images
  have adjugate_equal :
      scaleTriple leftFactor (scaleTriple (determinant matrix ^ 2) left) =
        scaleTriple rightFactor (scaleTriple (determinant matrix ^ 2) right) := by
    have transported := congrArg (symmetricSquareImage (adjugate matrix)) rescaled_images
    rwa [symmetricSquareImage_scaleTriple, symmetricSquareImage_scaleTriple,
      symmetricSquareImage_adjugate, symmetricSquareImage_adjugate] at transported
  have squared_nonzero : determinant matrix ^ 2 ≠ 0 := by
    have := mul_ne_zero_field _ _ invertible invertible
    simpa [pow_two] using this
  have proportional : left = scaleTriple (leftFactor⁻¹ * rightFactor) right := by
    apply scaleTriple_injective squared_nonzero
    apply scaleTriple_injective leftFactor_nonzero
    have expand :
        scaleTriple leftFactor (scaleTriple (determinant matrix ^ 2)
            (scaleTriple (leftFactor⁻¹ * rightFactor) right)) =
          scaleTriple rightFactor (scaleTriple (determinant matrix ^ 2) right) := by
      have scalar : ∀ coordinate : Field13,
          leftFactor * (determinant matrix ^ 2 * (leftFactor⁻¹ * rightFactor * coordinate))
            = rightFactor * (determinant matrix ^ 2 * coordinate) := by
        intro coordinate
        calc leftFactor * (determinant matrix ^ 2 * (leftFactor⁻¹ * rightFactor * coordinate))
            = leftFactor * leftFactor⁻¹ *
                (rightFactor * (determinant matrix ^ 2 * coordinate)) := by ring
          _ = rightFactor * (determinant matrix ^ 2 * coordinate) := by
              rw [mul_inv_cancel_field leftFactor leftFactor_nonzero, one_mul]
      obtain ⟨rx, ry, rz⟩ := right
      simp only [scaleTriple, Triple.mk.injEq]
      exact ⟨scalar rx, scalar ry, scalar rz⟩
    rw [expand]
    exact adjugate_equal
  have factor_nonzero : leftFactor⁻¹ * rightFactor ≠ 0 :=
    mul_ne_zero_field _ _ (inv_ne_zero_field _ leftFactor_nonzero) rightFactor_nonzero
  exact eq_of_scaleTriple_mem factor_nonzero right_mem left_mem proportional

/-! ## The indexed coordinate model -/

/-- Every indexed internal coordinate lies in the internal coordinate list. -/
theorem internalAt_mem_internalCoordinateList :
    ∀ index : Fin 78, internalAt index.val ∈ internalCoordinateList := by
  decide +kernel

/-- The internal index of an internal coordinate is below the list length. -/
theorem internalIndex_lt_on_internalCoordinateList :
    internalCoordinateList.all (fun point => internalIndex point < 78) = true := by
  decide +kernel

/-- Indexing inverts the internal-index lookup on the internal coordinate list. -/
theorem internalAt_internalIndex_on_internalCoordinateList :
    internalCoordinateList.all (fun point => internalAt (internalIndex point) == point) = true := by
  decide +kernel

/-- Indexing inverts the internal-index lookup at an internal coordinate. -/
theorem internalAt_internalIndex {point : Triple} (mem : point ∈ internalCoordinateList) :
    internalAt (internalIndex point) = point := by
  have := List.all_eq_true.mp internalAt_internalIndex_on_internalCoordinateList point mem
  simpa using this

/-- The internal index of an internal coordinate is below the list length. -/
theorem internalIndex_lt {point : Triple} (mem : point ∈ internalCoordinateList) :
    internalIndex point < 78 := by
  have := List.all_eq_true.mp internalIndex_lt_on_internalCoordinateList point mem
  simpa using this

/-- Distinct indices name distinct internal coordinates. -/
theorem internalAt_injective : ∀ first second : Fin 78,
    internalAt first.val = internalAt second.val → first = second := by
  decide +kernel

/-- The indexed coordinate of the acted point is the acted coordinate. -/
theorem internalAt_ofNat_internalIndex {point : Triple} (mem : point ∈ internalCoordinateList) :
    internalAt (Fin.ofNat 78 (internalIndex point)).val = point := by
  have bound := internalIndex_lt mem
  have reduced : (Fin.ofNat 78 (internalIndex point)).val = internalIndex point := by
    simpa [Fin.ofNat] using Nat.mod_eq_of_lt bound
  rw [reduced, internalAt_internalIndex mem]

end PassantCodeQ13.SymmetricSquare
