import PassantCodeQ13.Equivariance.SupportInvariance
import PassantCodeQ13.MinimumWords.RowUniqueness.PolarGram

/-!
# Every minimum-word support is an arc of the plane

The minimum-word supports of the passant code are the four projective orbits of the displayed
weight-twelve representatives, encoded as 78-bit sets of internal-point indices.  This module proves
that no support of that family contains three collinear points of `PG(2,13)`: each support is a
twelve-point arc.  Collinearity of three coordinate triples is the vanishing of
`PassantCodeQ13.MinimumWords.RowUniqueness.coordinateDeterminant`, the determinant of the matrix
whose rows they are.

The proof is structural in the orbits and finite only on the four representatives.  The action of a
two-by-two matrix on the plane of binary quadratic forms is the symmetric square of that matrix, and
the symmetric square of a two-by-two matrix has determinant the cube of the matrix determinant, so
substitution multiplies the coordinate determinant of three triples by that cube.  The model's
normalization of a representative rescales each image by a nonzero factor, which multiplies the
determinant by a nonzero factor as well.  An invertible matrix therefore carries a triple of
independent nondegenerate triples to an independent triple, and an arc to an arc, so the arc property
of a whole orbit follows from the arc property of its representative.

For each of the four representatives the property is decided by kernel reduction over its twelve
coordinates in each of three positions, comparing the three arguments for equality and evaluating one
three-by-three determinant over the residue field otherwise.

The consequence recorded at the end is the vanishing of triple concurrence on collinear triples: no
member of the decoded family contains three distinct internal points of one line.  Specialized to the
seven internal points of a passant line, this is the zero-triple signature of the geometric passant
rows, obtained here without enumerating the 364 supports against the 78 rows.
-/

namespace PassantCodeQ13.MinimumWords

open RelativeConicArcs.PassantCodeQ13
open PassantCodeQ13.Equivariance
open PassantCodeQ13.MinimumWords.RowUniqueness
open PassantCodeQ13.PlaneJoin
open PassantCodeQ13.SymmetricSquare
open PassantCodeQ13.WeightTen

/-! ## Nonvanishing of small powers in the residue field -/

/-- A square of a nonzero residue is nonzero. -/
private theorem sq_ne_zero_field {value : Field13} (nonzero : value ≠ 0) : value ^ 2 ≠ 0 := by
  rw [pow_two]
  exact mul_ne_zero_field _ _ nonzero nonzero

/-- A cube of a nonzero residue is nonzero. -/
private theorem cube_ne_zero_field {value : Field13} (nonzero : value ≠ 0) : value ^ 3 ≠ 0 := by
  rw [pow_succ]
  exact mul_ne_zero_field _ _ (sq_ne_zero_field nonzero) nonzero

/-! ## The substitution map on the coordinate determinant -/

/-- Substitution multiplies the coordinate determinant of three triples by the cube of the matrix
determinant, because the symmetric square of a two-by-two matrix has that cube as its own
determinant. -/
theorem coordinateDeterminant_symmetricSquareImage (matrix : Matrix2)
    (first second third : Triple) :
    coordinateDeterminant (symmetricSquareImage matrix first)
        (symmetricSquareImage matrix second) (symmetricSquareImage matrix third)
      = determinant matrix ^ 3 * coordinateDeterminant first second third := by
  simp only [coordinateDeterminant, symmetricSquareImage, determinant]
  ring

/-- The action of an invertible matrix carries three independent nondegenerate coordinate triples to
three independent ones: substitution multiplies the coordinate determinant by the cube of the matrix
determinant, and normalization of the three image representatives multiplies it by three further
nonzero factors. -/
theorem coordinateDeterminant_act_ne_zero {matrix : Matrix2}
    (invertible : determinant matrix ≠ 0) {first second third : Triple}
    (first_nondegenerate : pointDiscriminant first ≠ 0)
    (second_nondegenerate : pointDiscriminant second ≠ 0)
    (third_nondegenerate : pointDiscriminant third ≠ 0)
    (independent : coordinateDeterminant first second third ≠ 0) :
    coordinateDeterminant (act matrix first) (act matrix second) (act matrix third) ≠ 0 := by
  have image_ne_zero : ∀ point : Triple, pointDiscriminant point ≠ 0 →
      symmetricSquareImage matrix point ≠ ⟨0, 0, 0⟩ := by
    intro point nondegenerate
    refine ne_zero_of_pointDiscriminant_ne_zero ?_
    rw [pointDiscriminant_symmetricSquareImage]
    exact mul_ne_zero_field _ _ (sq_ne_zero_field invertible) nondegenerate
  obtain ⟨firstFactor, firstFactor_nonzero, first_rescaled⟩ :=
    normalizeTriple_eq_scaleTriple (image_ne_zero first first_nondegenerate)
  obtain ⟨secondFactor, secondFactor_nonzero, second_rescaled⟩ :=
    normalizeTriple_eq_scaleTriple (image_ne_zero second second_nondegenerate)
  obtain ⟨thirdFactor, thirdFactor_nonzero, third_rescaled⟩ :=
    normalizeTriple_eq_scaleTriple (image_ne_zero third third_nondegenerate)
  rw [act_eq_normalizeTriple_symmetricSquareImage, act_eq_normalizeTriple_symmetricSquareImage,
    act_eq_normalizeTriple_symmetricSquareImage, first_rescaled, second_rescaled, third_rescaled,
    coordinateDeterminant_scaleTriple, coordinateDeterminant_symmetricSquareImage]
  exact mul_ne_zero_field _ _
    (mul_ne_zero_field _ _ (mul_ne_zero_field _ _ firstFactor_nonzero secondFactor_nonzero)
      thirdFactor_nonzero)
    (mul_ne_zero_field _ _ (cube_ne_zero_field invertible) independent)

/-! ## The arc property of a displayed coordinate list -/

/-- Whether no three pairwise distinct points of a displayed coordinate list are collinear. -/
def noCollinearTriple (support : List Triple) : Bool :=
  support.all fun first => support.all fun second => support.all fun third =>
    first == second || first == third || second == third ||
      coordinateDeterminant first second third != 0

/-- Three pairwise distinct points of a checked coordinate list are independent. -/
private theorem coordinateDeterminant_ne_zero_of_noCollinearTriple {support : List Triple}
    (checked : noCollinearTriple support = true) {first second third : Triple}
    (first_mem : first ∈ support) (second_mem : second ∈ support) (third_mem : third ∈ support)
    (first_ne_second : first ≠ second) (first_ne_third : first ≠ third)
    (second_ne_third : second ≠ third) :
    coordinateDeterminant first second third ≠ 0 := by
  have outer := List.all_eq_true.mp checked first first_mem
  have middle := List.all_eq_true.mp outer second second_mem
  have inner := List.all_eq_true.mp middle third third_mem
  simp only [Bool.or_eq_true, beq_iff_eq, bne_iff_ne, ne_eq] at inner
  rcases inner with ((equal | equal) | equal) | independent
  · exact absurd equal first_ne_second
  · exact absurd equal first_ne_third
  · exact absurd equal second_ne_third
  · exact independent

/-- The displayed representative with symmetric stabilizer is an arc.  Decided over its twelve
coordinates in each of three positions. -/
theorem representativeS4_noCollinearTriple : noCollinearTriple representativeS4 = true := by
  decide +kernel

/-- The first displayed dihedral representative is an arc.  Decided over its twelve coordinates in
each of three positions. -/
theorem representativeDihedralA_noCollinearTriple :
    noCollinearTriple representativeDihedralA = true := by
  decide +kernel

/-- The second displayed dihedral representative is an arc.  Decided over its twelve coordinates in
each of three positions. -/
theorem representativeDihedralB_noCollinearTriple :
    noCollinearTriple representativeDihedralB = true := by
  decide +kernel

/-- The third displayed dihedral representative is an arc.  Decided over its twelve coordinates in
each of three positions. -/
theorem representativeDihedralC_noCollinearTriple :
    noCollinearTriple representativeDihedralC = true := by
  decide +kernel

/-! ## Transport along one orbit -/

/-- Three pairwise distinct points of the image of a checked coordinate list under an invertible
matrix are independent. -/
private theorem coordinateDeterminant_ne_zero_of_mem_map_act {support : List Triple}
    (internal : ∀ point ∈ support, point ∈ internalCoordinateList)
    (checked : noCollinearTriple support = true)
    {matrix : Matrix2} (matrix_mem : matrix ∈ projectiveMatrices) {first second third : Triple}
    (first_mem : first ∈ support.map (act matrix))
    (second_mem : second ∈ support.map (act matrix))
    (third_mem : third ∈ support.map (act matrix))
    (first_ne_second : first ≠ second) (first_ne_third : first ≠ third)
    (second_ne_third : second ≠ third) :
    coordinateDeterminant first second third ≠ 0 := by
  obtain ⟨firstSource, firstSource_mem, rfl⟩ := List.mem_map.mp first_mem
  obtain ⟨secondSource, secondSource_mem, rfl⟩ := List.mem_map.mp second_mem
  obtain ⟨thirdSource, thirdSource_mem, rfl⟩ := List.mem_map.mp third_mem
  have nondegenerate : ∀ point ∈ support, pointDiscriminant point ≠ 0 := fun point member =>
    ((mem_internalCoordinateList_iff point).mp (internal point member)).2.1
  refine coordinateDeterminant_act_ne_zero (determinant_ne_zero_of_mem matrix_mem)
    (nondegenerate _ firstSource_mem) (nondegenerate _ secondSource_mem)
    (nondegenerate _ thirdSource_mem) ?_
  exact coordinateDeterminant_ne_zero_of_noCollinearTriple checked firstSource_mem secondSource_mem
    thirdSource_mem (fun equal => first_ne_second (congrArg (act matrix) equal))
    (fun equal => first_ne_third (congrArg (act matrix) equal))
    (fun equal => second_ne_third (congrArg (act matrix) equal))

/-- Distinct internal-point indices below 78 name distinct coordinate triples. -/
private theorem internalAt_ne {first second : Nat} (first_lt : first < 78) (second_lt : second < 78)
    (different : first ≠ second) : internalAt first ≠ internalAt second := by
  intro equal
  exact different (congrArg Fin.val
    (internalAt_injective ⟨first, first_lt⟩ ⟨second, second_lt⟩ equal))

/-- A set bit of an encoded image list names one of its points. -/
private theorem internalAt_mem_of_testBit {support : List Triple}
    (internal : ∀ point ∈ support, point ∈ internalCoordinateList) {column : Nat}
    (bit : (encodeSupport support).testBit column = true) : internalAt column ∈ support := by
  rw [testBit_encodeSupport, List.any_eq_true] at bit
  obtain ⟨candidate, candidate_mem, index_eq⟩ := bit
  have index_value : internalIndex candidate = column := by simpa using index_eq
  have recovered : internalAt (internalIndex candidate) = candidate :=
    internalAt_internalIndex (internal candidate candidate_mem)
  rw [index_value] at recovered
  exact recovered ▸ candidate_mem

/-- Three pairwise distinct internal points of a support in the orbit of a checked representative are
independent. -/
private theorem coordinateDeterminant_ne_zero_of_mem_supportOrbit {support : List Triple}
    (internal : ∀ point ∈ support, point ∈ internalCoordinateList)
    (checked : noCollinearTriple support = true) {code : Nat}
    (code_mem : code ∈ supportOrbit support) {first second third : Nat}
    (first_lt : first < 78) (second_lt : second < 78) (third_lt : third < 78)
    (first_ne_second : first ≠ second) (first_ne_third : first ≠ third)
    (second_ne_third : second ≠ third)
    (first_bit : code.testBit first = true) (second_bit : code.testBit second = true)
    (third_bit : code.testBit third = true) :
    coordinateDeterminant (internalAt first) (internalAt second) (internalAt third) ≠ 0 := by
  obtain ⟨matrix, matrix_mem, rfl⟩ := (mem_supportOrbit_iff support code).mp code_mem
  have image_internal : ∀ point ∈ support.map (act matrix), point ∈ internalCoordinateList := by
    rintro point member
    obtain ⟨source, source_mem, rfl⟩ := List.mem_map.mp member
    exact act_mem_internalCoordinateList matrix_mem (internal source source_mem)
  exact coordinateDeterminant_ne_zero_of_mem_map_act internal checked matrix_mem
    (internalAt_mem_of_testBit image_internal first_bit)
    (internalAt_mem_of_testBit image_internal second_bit)
    (internalAt_mem_of_testBit image_internal third_bit)
    (internalAt_ne first_lt second_lt first_ne_second)
    (internalAt_ne first_lt third_lt first_ne_third)
    (internalAt_ne second_lt third_lt second_ne_third)

/-! ## The arc property of the decoded minimum-word family -/

/-- No support of the decoded minimum-word family contains three collinear internal points: every
member of the family is a twelve-point arc of the plane. -/
theorem coordinateDeterminant_ne_zero_of_mem_minimumSupportCodes {code : Nat}
    (code_mem : code ∈ minimumSupportCodes) {first second third : Nat}
    (first_lt : first < 78) (second_lt : second < 78) (third_lt : third < 78)
    (first_ne_second : first ≠ second) (first_ne_third : first ≠ third)
    (second_ne_third : second ≠ third)
    (first_bit : code.testBit first = true) (second_bit : code.testBit second = true)
    (third_bit : code.testBit third = true) :
    coordinateDeterminant (internalAt first) (internalAt second) (internalAt third) ≠ 0 := by
  have transport : ∀ representative : List Triple,
      representative.all (fun point => internalCoordinateList.contains point) = true →
      noCollinearTriple representative = true → code ∈ supportOrbit representative →
      coordinateDeterminant (internalAt first) (internalAt second) (internalAt third) ≠ 0 := by
    intro representative representative_internal checked orbit_mem
    refine coordinateDeterminant_ne_zero_of_mem_supportOrbit ?_ checked orbit_mem first_lt second_lt
      third_lt first_ne_second first_ne_third second_ne_third first_bit second_bit third_bit
    intro point member
    have := List.all_eq_true.mp representative_internal point member
    simpa using this
  rw [minimumSupportCodes, List.mem_eraseDups] at code_mem
  rcases List.mem_append.mp code_mem with head | dihedralC
  · rcases List.mem_append.mp head with head' | dihedralB
    · rcases List.mem_append.mp head' with symmetric | dihedralA
      · exact transport _ representativeS4_internal representativeS4_noCollinearTriple symmetric
      · exact transport _ representativeDihedralA_internal
          representativeDihedralA_noCollinearTriple dihedralA
    · exact transport _ representativeDihedralB_internal representativeDihedralB_noCollinearTriple
        dihedralB
  · exact transport _ representativeDihedralC_internal representativeDihedralC_noCollinearTriple
      dihedralC

/-- Triple concurrence in the decoded minimum layer vanishes on every collinear triple of distinct
internal points: no member of the family contains three points of one line. -/
theorem tripleConcurrenceIn_minimumSupportCodes_eq_zero_of_collinear {first second third : Nat}
    (first_lt : first < 78) (second_lt : second < 78) (third_lt : third < 78)
    (first_ne_second : first ≠ second) (first_ne_third : first ≠ third)
    (second_ne_third : second ≠ third)
    (collinear :
      coordinateDeterminant (internalAt first) (internalAt second) (internalAt third) = 0) :
    tripleConcurrenceIn minimumSupportCodes first second third = 0 := by
  rw [tripleConcurrenceIn, List.countP_eq_zero]
  intro code code_mem bits
  simp only [Bool.and_eq_true] at bits
  exact coordinateDeterminant_ne_zero_of_mem_minimumSupportCodes code_mem first_lt second_lt third_lt
    first_ne_second first_ne_third second_ne_third bits.1.1 bits.1.2 bits.2 collinear

end PassantCodeQ13.MinimumWords
