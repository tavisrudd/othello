import PassantCodeQ13.Equivariance.SupportInvariance
import PassantCodeQ13.Equivariance.TransporterData

/-!
# Transitivity of the projective action on points and on ordered distinct pairs

The symmetric-square action of the normalized invertible matrices is transitive on the 78 internal
points of the standard conic, and the stabilizer of the first internal coordinate is transitive on
each class of second points cut out by the normalized polar parameter.  Both facts are established
here by exhibiting a transporting matrix for each target and checking, by kernel reduction, that the
exhibited matrix transports as claimed.  The exhibited indices are the generated data of
`PassantCodeQ13.Equivariance.TransporterData`; they carry no trust of their own, since a wrong entry
makes the check below fail rather than making a false statement provable.

Two checks suffice.  The first runs over the 78 internal coordinates and verifies that the point
table carries the first internal coordinate to each of them.  The second runs over the base row of
the pair table and verifies that its entry at index `j` carries one of the six displayed
representative pairs to the pair formed by the first internal coordinate and the coordinate of index
`j`; that all six representatives share their first point is what makes one row of the table
enough.  Combining the two through the inverse of a transporting matrix — the adjugate, whose
symmetric square inverts that of the matrix up to the square of the determinant — gives transitivity
on ordered pairs of distinct internal points: every such pair is the image of one of the six
representative pairs.

The two checks range over 78 indices each and evaluate at most twelve images of a coordinate per
index, so neither is a search over the matrices or over the pairs.
-/

namespace PassantCodeQ13.Equivariance

open RelativeConicArcs.PassantCodeQ13
open PassantCodeQ13.MinimumWords
open PassantCodeQ13.SymmetricSquare
open PassantCodeQ13.WeightTen

/-! ## Inverses -/

/-- The adjugate has the determinant of its matrix. -/
theorem determinant_adjugate (matrix : Matrix2) :
    determinant (adjugate matrix) = determinant matrix := by
  simp only [determinant, adjugate]
  ring

/-- The adjugate composed with the matrix is the determinant times the identity. -/
theorem matrixProduct_adjugate (matrix : Matrix2) :
    matrixProduct (adjugate matrix) matrix = scaleMatrix (determinant matrix) ⟨1, 0, 0, 1⟩ := by
  simp only [matrixProduct, adjugate, scaleMatrix, determinant]
  refine Matrix2.mk.injEq .. ▸ ?_
  refine ⟨by ring, by ring, by ring, by ring⟩

/-- A normalized representative is its own normalization. -/
theorem normalizeTriple_of_mem {point : Triple} (mem : point ∈ projectiveTripleList) :
    normalizeTriple point = point := by
  have step := List.all_eq_true.mp normalizeTriple_scaleTriple_on_projectiveTripleList point mem
  have instance_at := List.all_eq_true.mp step 1 (mem_fieldElements 1)
  rcases Bool.or_eq_true .. ▸ instance_at with zero_case | equal_case
  · exact absurd (by simpa using zero_case) (by decide : (1 : Field13) ≠ 0)
  · have : normalizeTriple (scaleTriple 1 point) = point := by simpa using equal_case
    simpa [scaleTriple] using this

/-- The identity matrix acts trivially on a normalized representative. -/
theorem act_one {point : Triple} (mem : point ∈ projectiveTripleList) :
    act ⟨1, 0, 0, 1⟩ point = point := by
  have expand : act ⟨1, 0, 0, 1⟩ point = normalizeTriple point := by
    rw [act_eq_normalizeTriple_symmetricSquareImage]
    congr 1
    simp only [symmetricSquareImage]
    refine Triple.mk.injEq .. ▸ ?_
    refine ⟨by ring, by ring, by ring⟩
  rw [expand, normalizeTriple_of_mem mem]

/-- The inverse of a normalized invertible matrix, taken through the adjugate. -/
def projectiveInverse (element : ProjectiveElement) : ProjectiveElement :=
  ⟨normalizeMatrix (adjugate element.1),
    normalizeMatrix_mem_projectiveMatrices (by
      rw [determinant_adjugate]
      exact determinant_ne_zero_of_mem element.2)⟩

/-- The adjugate inverts the action on the internal points. -/
theorem orbitMap_projectiveInverse (element : ProjectiveElement) (point : InternalPoint) :
    orbitMap (projectiveInverse element) (orbitMap element point) = point := by
  refine Subtype.ext ?_
  have invertible := determinant_ne_zero_of_mem element.2
  have nondegenerate : pointDiscriminant point.1 ≠ 0 :=
    ((mem_internalCoordinateList_iff _).mp (mem_internalCoordinateList_of_internalPoint point)).2.1
  have mem_projective : point.1 ∈ projectiveTripleList := by
    have member := mem_internalCoordinateList_of_internalPoint point
    rw [internalCoordinateList] at member
    exact List.mem_of_mem_filter member
  show act (normalizeMatrix (adjugate element.1)) (act element.1 point.1) = point.1
  rw [act_normalizeMatrix (by rw [determinant_adjugate]; exact invertible),
    act_act (right := element.1) invertible nondegenerate, matrixProduct_adjugate,
    act_scaleMatrix invertible, act_one mem_projective]

/-- The action of a matrix undoes the action of its adjugate. -/
theorem orbitMap_projectiveInverse_right (element : ProjectiveElement) (point : InternalPoint) :
    orbitMap element (orbitMap (projectiveInverse element) point) = point := by
  have injective := (orbitMap_bijective (projectiveInverse element)).injective
  exact injective (orbitMap_projectiveInverse element _)

/-! ## The checked transporter tables -/

/-- Each entry of the displayed point table carries the first internal coordinate to the coordinate
of its index. -/
def pointTransporterCheck : Bool :=
  (List.range 78).all fun index =>
    match projectiveMatrices[pointTransporterIndices.getD index 0]? with
    | some matrix => act matrix (internalAt 0) == internalAt index
    | none => false

/-- The point table transports as claimed.  Decided over the 78 internal coordinates. -/
theorem pointTransporterCheck_eq_true : pointTransporterCheck = true := by
  decide +kernel

/-- Each entry of the base row of the displayed pair table carries one of the six displayed
representative pairs to the pair formed by the first internal coordinate and the coordinate of its
index. -/
def basePairTransporterCheck : Bool :=
  (List.range 78).all fun index =>
    index == 0 ||
      match projectiveMatrices[pairTransporterIndices.getD index 0]? with
      | some matrix =>
          polarClassRepresentatives.any fun representative =>
            (act matrix (internalAt representative.1) == internalAt 0) &&
              (act matrix (internalAt representative.2) == internalAt index)
      | none => false

/-- The base row of the pair table transports as claimed.  Decided over the 78 internal
coordinates. -/
theorem basePairTransporterCheck_eq_true : basePairTransporterCheck = true := by
  decide +kernel

/-- The six displayed representative pairs, as pairs of internal points. -/
def representativePairs : List (InternalPoint × InternalPoint) :=
  polarClassRepresentatives.map fun representative =>
    (internalPointAt (Fin.ofNat 78 representative.1),
      internalPointAt (Fin.ofNat 78 representative.2))

/-- The coordinates of the six displayed representative pairs are the indexed coordinates. -/
theorem representativePairs_coordinates :
    (polarClassRepresentatives.all fun representative =>
      ((internalPointAt (Fin.ofNat 78 representative.1)).1 == internalAt representative.1) &&
        ((internalPointAt (Fin.ofNat 78 representative.2)).1 ==
          internalAt representative.2)) = true := by
  decide +kernel

/-! ## Transitivity -/

/-- The first internal point in the displayed order, the base point of the transport. -/
def basePoint : InternalPoint := internalPointAt 0

private theorem basePoint_val : basePoint.1 = internalAt 0 := internalPointAt_val 0

/-- A matrix listed at an index that has an entry is one of the normalized invertible matrices. -/
private theorem mem_of_getElem? {index : Nat} {matrix : Matrix2}
    (entry : projectiveMatrices[index]? = some matrix) : matrix ∈ projectiveMatrices := by
  obtain ⟨bound, value⟩ := List.getElem?_eq_some_iff.mp entry
  exact value ▸ List.getElem_mem bound

/-- The action is transitive on the internal points. -/
theorem exists_orbitMap_basePoint (point : InternalPoint) :
    ∃ element : ProjectiveElement, orbitMap element basePoint = point := by
  obtain ⟨index, rfl⟩ := internalPointAt_bijective.surjective point
  have checked := pointTransporterCheck_eq_true
  rw [pointTransporterCheck, List.all_eq_true] at checked
  have entry := checked index.1 (List.mem_range.mpr index.2)
  rcases table : projectiveMatrices[pointTransporterIndices.getD index.1 0]? with _ | matrix
  · rw [table] at entry; exact absurd entry (by simp)
  · rw [table] at entry
    have transported : act matrix (internalAt 0) = internalAt index.1 := by simpa using entry
    refine ⟨⟨matrix, mem_of_getElem? table⟩, Subtype.ext ?_⟩
    show act matrix basePoint.1 = (internalPointAt index).1
    rw [basePoint_val, internalPointAt_val, transported]

/-- The action is transitive on the ordered pairs of distinct internal points that share a value of
the normalized polar parameter: every such pair is the image of one of the six displayed
representative pairs. -/
theorem exists_orbitMap_representativePair {first second : InternalPoint}
    (different : first ≠ second) :
    ∃ element : ProjectiveElement, ∃ pair ∈ representativePairs,
      orbitMap element pair.1 = first ∧ orbitMap element pair.2 = second := by
  obtain ⟨carrier, carrier_image⟩ := exists_orbitMap_basePoint first
  set pulled : InternalPoint := orbitMap (projectiveInverse carrier) second with pulled_def
  have pulled_image : orbitMap carrier pulled = second := by
    rw [pulled_def, orbitMap_projectiveInverse_right]
  have pulled_ne : pulled ≠ basePoint := by
    intro equal
    exact different (by rw [← carrier_image, ← equal, pulled_image])
  obtain ⟨index, index_image⟩ := internalPointAt_bijective.surjective pulled
  have index_ne : index.1 ≠ 0 := by
    intro zero
    refine pulled_ne ?_
    have index_zero : index = (0 : Fin 78) := Fin.ext (by simpa using zero)
    rw [← index_image, index_zero]
    rfl
  have checked := basePairTransporterCheck_eq_true
  rw [basePairTransporterCheck, List.all_eq_true] at checked
  have entry := checked index.1 (List.mem_range.mpr index.2)
  rw [show (index.1 == 0) = false by simpa using index_ne, Bool.false_or] at entry
  rcases table : projectiveMatrices[pairTransporterIndices.getD index.1 0]? with _ | matrix
  · rw [table] at entry; exact absurd entry (by simp)
  · rw [table] at entry
    obtain ⟨representative, representative_mem, transported⟩ := List.any_eq_true.mp entry
    obtain ⟨first_image, second_image⟩ := Bool.and_eq_true .. ▸ transported
    have coordinates := List.all_eq_true.mp representativePairs_coordinates representative
      representative_mem
    obtain ⟨first_coordinate, second_coordinate⟩ := Bool.and_eq_true .. ▸ coordinates
    refine ⟨projectiveCompose carrier ⟨matrix, mem_of_getElem? table⟩,
      (internalPointAt (Fin.ofNat 78 representative.1),
        internalPointAt (Fin.ofNat 78 representative.2)),
      List.mem_map_of_mem representative_mem, ?_, ?_⟩
    · rw [← orbitMap_projectiveCompose]
      have step : orbitMap (⟨matrix, mem_of_getElem? table⟩ : ProjectiveElement)
          (internalPointAt (Fin.ofNat 78 representative.1)) = basePoint := by
        refine Subtype.ext ?_
        show act matrix (internalPointAt (Fin.ofNat 78 representative.1)).1 = basePoint.1
        rw [basePoint_val, (by simpa using first_coordinate :
          (internalPointAt (Fin.ofNat 78 representative.1)).1 = internalAt representative.1)]
        simpa using first_image
      rw [step, carrier_image]
    · rw [← orbitMap_projectiveCompose]
      have step : orbitMap (⟨matrix, mem_of_getElem? table⟩ : ProjectiveElement)
          (internalPointAt (Fin.ofNat 78 representative.2)) = pulled := by
        refine Subtype.ext ?_
        show act matrix (internalPointAt (Fin.ofNat 78 representative.2)).1 = pulled.1
        rw [(by simpa using second_coordinate :
            (internalPointAt (Fin.ofNat 78 representative.2)).1 = internalAt representative.2),
          ← index_image, internalPointAt_val]
        simpa using second_image
      rw [step, pulled_image]

end PassantCodeQ13.Equivariance
