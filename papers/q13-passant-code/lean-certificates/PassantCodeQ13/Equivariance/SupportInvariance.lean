import PassantCodeQ13.Equivariance.GroupAction
import PassantCodeQ13.MinimumWords.RowUniqueness.Base

/-!
# Invariance of the decoded minimum-word family under the projective action

The minimum-word supports of the passant code are the union of the four orbits of the displayed
weight-twelve representatives under the symmetric-square action of the normalized invertible
matrices, encoded as 78-bit numbers and decoded into finite sets of internal points.  Because each
orbit is an orbit, the decoded family is carried to itself by the action: applying a further
normalized invertible matrix to the support obtained from a matrix `M` gives the support obtained
from the normalized product, which occurs in the same orbit.

The module first identifies the decoding of an encoded list: a set bit of `encodeSupport` is exactly
an occurrence in the list, so for a list of internal coordinates the decoded support is the set of
its members.  Equivariance of the decoding follows, and then invariance of the whole family, stated
as `image_orbitMap_semanticMinimumSupports`.  The equality is obtained from the inclusion together
with injectivity of the action, so no enumeration over the matrices or over the supports occurs
anywhere in this module; the only finite check is the agreement of the two displayed indexings of
the internal points, decided over the 78 indices, and internality of the four displayed
representatives, decided over their twelve coordinates each.

The immediate consequence recorded here is that every quantity computed from the family and a tuple
of internal points — a membership count, a pair concurrence — takes the same value at a tuple and at
its image under the action.
-/

namespace PassantCodeQ13.Equivariance

open Finset
open RelativeConicArcs.PassantCodeQ13
open PassantCodeQ13.MinimumWords
open PassantCodeQ13.MinimumWords.RowUniqueness
open PassantCodeQ13.SymmetricSquare
open PassantCodeQ13.WeightTen
open RelativeConicArcs

/-! ## Bits of an encoded support -/

/-- Bits of the number obtained by setting the internal index of every point of a list, starting
from an arbitrary initial value. -/
private theorem testBit_encodeFold (column : Nat) :
    ∀ (support : List Triple) (initial : Nat),
      (support.foldl (fun value point => value ||| (1 <<< internalIndex point))
          initial).testBit column
        = (initial.testBit column || support.any fun point => decide (internalIndex point = column))
  | [], initial => by simp
  | point :: rest, initial => by
    rw [List.foldl_cons, testBit_encodeFold column rest, Nat.testBit_or, Nat.one_shiftLeft,
      Nat.testBit_two_pow, List.any_cons]
    rcases Bool.eq_false_or_eq_true (initial.testBit column) with initial_bit | initial_bit <;>
      simp [initial_bit]

/-- A bit of an encoded support is set exactly at the internal index of one of its points. -/
theorem testBit_encodeSupport (support : List Triple) (column : Nat) :
    (encodeSupport support).testBit column
      = support.any fun point => decide (internalIndex point = column) := by
  rw [encodeSupport, testBit_encodeFold]
  simp

/-! ## Decoding an encoded support -/

/-- The two displayed indexings of the internal points agree.  Decided over the 78 indices. -/
theorem internalPointAt_val : ∀ index : Fin 78, (internalPointAt index).1 = internalAt index.1 := by
  decide +kernel

/-- Decoding the encoding of a list of internal coordinates recovers its members. -/
theorem mem_decodedSupport_encodeSupport {support : List Triple}
    (internal : ∀ point ∈ support, point ∈ internalCoordinateList) (point : InternalPoint) :
    point ∈ decodedSupport (encodeSupport support) ↔ point.1 ∈ support := by
  obtain ⟨index, rfl⟩ := internalPointAt_bijective.surjective point
  rw [mem_decodedSupport, testBit_encodeSupport, List.any_eq_true, internalPointAt_val]
  constructor
  · rintro ⟨candidate, candidate_mem, index_eq⟩
    have index_value : internalIndex candidate = index.1 := by simpa using index_eq
    have recovered : internalAt (internalIndex candidate) = candidate :=
      internalAt_internalIndex (internal candidate candidate_mem)
    rw [index_value] at recovered
    exact recovered ▸ candidate_mem
  · intro member
    refine ⟨internalAt index.1, member, ?_⟩
    have recovered : internalAt (internalIndex (internalAt index.1)) = internalAt index.1 :=
      internalAt_internalIndex (internal _ member)
    have bound : internalIndex (internalAt index.1) < 78 := internalIndex_lt (internal _ member)
    have index_eq : (⟨internalIndex (internalAt index.1), bound⟩ : Fin 78) = index :=
      internalAt_injective _ _ recovered
    have value : internalIndex (internalAt index.1) = index.1 := congrArg Fin.val index_eq
    simpa using value

/-- The action of a normalized invertible matrix carries the decoding of a list of internal
coordinates to the decoding of the image list. -/
theorem image_orbitMap_decodedSupport (element : ProjectiveElement) {support : List Triple}
    (internal : ∀ point ∈ support, point ∈ internalCoordinateList) :
    (decodedSupport (encodeSupport support)).image (orbitMap element) =
      decodedSupport (encodeSupport (support.map (act element.1))) := by
  have image_internal : ∀ point ∈ support.map (act element.1),
      point ∈ internalCoordinateList := by
    rintro point member
    obtain ⟨source, source_mem, rfl⟩ := List.mem_map.mp member
    exact act_mem_internalCoordinateList element.2 (internal source source_mem)
  ext point
  rw [Finset.mem_image, mem_decodedSupport_encodeSupport image_internal]
  constructor
  · rintro ⟨source, source_mem, rfl⟩
    exact List.mem_map_of_mem
      ((mem_decodedSupport_encodeSupport internal source).mp source_mem)
  · intro member
    obtain ⟨source, source_mem, source_image⟩ := List.mem_map.mp member
    refine ⟨⟨source, (mem_internalCoordinateList_iff_mem_internalCoordinates _).mp
      (internal source source_mem)⟩, ?_, Subtype.ext source_image⟩
    exact (mem_decodedSupport_encodeSupport internal _).mpr source_mem

/-! ## Invariance of the four displayed orbits -/

/-- Membership in the orbit of a displayed support. -/
theorem mem_supportOrbit_iff (support : List Triple) (code : Nat) :
    code ∈ supportOrbit support ↔
      ∃ matrix ∈ projectiveMatrices, encodeSupport (support.map (act matrix)) = code := by
  rw [supportOrbit, List.mem_eraseDups, List.mem_map]

/-- Acting on the image of a list of internal coordinates under one matrix is acting under the
normalized product of the two matrices. -/
theorem map_act_map_act {left right : Matrix2} (left_mem : left ∈ projectiveMatrices)
    (right_mem : right ∈ projectiveMatrices) {support : List Triple}
    (internal : ∀ point ∈ support, point ∈ internalCoordinateList) :
    (support.map (act right)).map (act left) =
      support.map (act (normalizeMatrix (matrixProduct left right))) := by
  have product_invertible : determinant (matrixProduct left right) ≠ 0 := by
    rw [determinant_matrixProduct]
    exact mul_ne_zero_field _ _ (determinant_ne_zero_of_mem left_mem)
      (determinant_ne_zero_of_mem right_mem)
  rw [List.map_map]
  refine List.map_congr_left fun point member => ?_
  have nondegenerate : pointDiscriminant point ≠ 0 :=
    ((mem_internalCoordinateList_iff _).mp (internal point member)).2.1
  show act left (act right point) = _
  rw [act_normalizeMatrix product_invertible]
  exact act_act (determinant_ne_zero_of_mem right_mem) nondegenerate

/-- The orbit of a list of internal coordinates is carried to itself by the action. -/
theorem image_orbitMap_mem_supportOrbit (element : ProjectiveElement) {support : List Triple}
    (internal : ∀ point ∈ support, point ∈ internalCoordinateList) {code : Nat}
    (code_mem : code ∈ supportOrbit support) :
    ∃ image ∈ supportOrbit support,
      (decodedSupport code).image (orbitMap element) = decodedSupport image := by
  obtain ⟨matrix, matrix_mem, rfl⟩ := (mem_supportOrbit_iff support code).mp code_mem
  have image_internal : ∀ point ∈ support.map (act matrix), point ∈ internalCoordinateList := by
    rintro point member
    obtain ⟨source, source_mem, rfl⟩ := List.mem_map.mp member
    exact act_mem_internalCoordinateList matrix_mem (internal source source_mem)
  refine ⟨encodeSupport (support.map (act (normalizeMatrix (matrixProduct element.1 matrix)))),
    (mem_supportOrbit_iff support _).mpr
      ⟨normalizeMatrix (matrixProduct element.1 matrix),
        (projectiveCompose element ⟨matrix, matrix_mem⟩).2, rfl⟩, ?_⟩
  rw [image_orbitMap_decodedSupport element image_internal,
    map_act_map_act element.2 matrix_mem internal]

/-! ## Invariance of the decoded minimum-word family -/

/-- The displayed representative with symmetric stabilizer consists of internal coordinates. -/
theorem representativeS4_internal :
    representativeS4.all (fun point => internalCoordinateList.contains point) = true := by
  decide +kernel

/-- The first displayed dihedral representative consists of internal coordinates. -/
theorem representativeDihedralA_internal :
    representativeDihedralA.all (fun point => internalCoordinateList.contains point) = true := by
  decide +kernel

/-- The second displayed dihedral representative consists of internal coordinates. -/
theorem representativeDihedralB_internal :
    representativeDihedralB.all (fun point => internalCoordinateList.contains point) = true := by
  decide +kernel

/-- The third displayed dihedral representative consists of internal coordinates. -/
theorem representativeDihedralC_internal :
    representativeDihedralC.all (fun point => internalCoordinateList.contains point) = true := by
  decide +kernel

private theorem internal_of_all {support : List Triple}
    (checked : support.all (fun point => internalCoordinateList.contains point) = true) :
    ∀ point ∈ support, point ∈ internalCoordinateList := by
  intro point member
  have := List.all_eq_true.mp checked point member
  simpa using this

/-- Each of the four orbits contributing to the minimum-word family is invariant, and every code of
the family lies in one of them. -/
theorem image_orbitMap_mem_minimumSupportCodes (element : ProjectiveElement) {code : Nat}
    (code_mem : code ∈ minimumSupportCodes) :
    ∃ image ∈ minimumSupportCodes,
      (decodedSupport code).image (orbitMap element) = decodedSupport image := by
  have symmetric_internal := internal_of_all representativeS4_internal
  have dihedralA_internal := internal_of_all representativeDihedralA_internal
  have dihedralB_internal := internal_of_all representativeDihedralB_internal
  have dihedralC_internal := internal_of_all representativeDihedralC_internal
  rw [minimumSupportCodes, List.mem_eraseDups] at code_mem
  have transport : ∀ (representative : List Triple),
      (∀ point ∈ representative, point ∈ internalCoordinateList) →
      code ∈ supportOrbit representative →
      ∃ image ∈ supportOrbit representative,
        (decodedSupport code).image (orbitMap element) = decodedSupport image :=
    fun representative internal member =>
      image_orbitMap_mem_supportOrbit element internal member
  rcases List.mem_append.mp code_mem with head | tail
  · rcases List.mem_append.mp head with head' | dihedralB
    · rcases List.mem_append.mp head' with symmetric | dihedralA
      · obtain ⟨image, image_mem, transported⟩ := transport _ symmetric_internal symmetric
        exact ⟨image, List.mem_eraseDups.mpr (List.mem_append.mpr (Or.inl
          (List.mem_append.mpr (Or.inl (List.mem_append.mpr (Or.inl image_mem)))))), transported⟩
      · obtain ⟨image, image_mem, transported⟩ := transport _ dihedralA_internal dihedralA
        exact ⟨image, List.mem_eraseDups.mpr (List.mem_append.mpr (Or.inl
          (List.mem_append.mpr (Or.inl (List.mem_append.mpr (Or.inr image_mem)))))), transported⟩
    · obtain ⟨image, image_mem, transported⟩ := transport _ dihedralB_internal dihedralB
      exact ⟨image, List.mem_eraseDups.mpr (List.mem_append.mpr (Or.inl
        (List.mem_append.mpr (Or.inr image_mem)))), transported⟩
  · obtain ⟨image, image_mem, transported⟩ := transport _ dihedralC_internal tail
    exact ⟨image, List.mem_eraseDups.mpr (List.mem_append.mpr (Or.inr image_mem)), transported⟩

/-- The decoded minimum-word family is carried to itself by the action of every normalized
invertible matrix. -/
theorem image_orbitMap_semanticMinimumSupports (element : ProjectiveElement) :
    semanticMinimumSupports.image (Finset.image (orbitMap element)) = semanticMinimumSupports := by
  have injective : Function.Injective (Finset.image (orbitMap element)) :=
    Finset.image_injective (orbitMap_bijective element).injective
  refine Finset.eq_of_subset_of_card_le ?_ ?_
  · intro family member
    rw [Finset.mem_image] at member
    obtain ⟨source, source_mem, rfl⟩ := member
    rw [semanticMinimumSupports, Finset.mem_image] at source_mem
    obtain ⟨code, code_mem, rfl⟩ := source_mem
    obtain ⟨image, image_mem, transported⟩ :=
      image_orbitMap_mem_minimumSupportCodes element (List.mem_toFinset.mp code_mem)
    exact transported ▸ Finset.mem_image.mpr ⟨image, List.mem_toFinset.mpr image_mem, rfl⟩
  · exact le_of_eq (Finset.card_image_of_injective semanticMinimumSupports injective).symm

/-! ## Invariance of the quantities computed from the family -/

/-- The number of minimum-word supports through a point is unchanged by the action. -/
theorem card_filter_mem_orbitMap (element : ProjectiveElement) (point : InternalPoint) :
    (semanticMinimumSupports.filter fun support => orbitMap element point ∈ support).card =
      (semanticMinimumSupports.filter fun support => point ∈ support).card := by
  conv_lhs => rw [← image_orbitMap_semanticMinimumSupports element]
  rw [Finset.filter_image, Finset.card_image_of_injective _
    (Finset.image_injective (orbitMap_bijective element).injective)]
  refine congrArg Finset.card (Finset.filter_congr fun support _ => ?_)
  constructor
  · intro member
    obtain ⟨source, source_mem, source_image⟩ := Finset.mem_image.mp member
    exact ((orbitMap_bijective element).injective source_image) ▸ source_mem
  · intro member
    exact Finset.mem_image_of_mem _ member

/-- The number of minimum-word supports through a pair of points is unchanged by the action. -/
theorem pairConcurrence_orbitMap (element : ProjectiveElement) (first second : InternalPoint) :
    ConicPassantCode.pairConcurrence semanticMinimumSupports (orbitMap element first)
        (orbitMap element second) =
      ConicPassantCode.pairConcurrence semanticMinimumSupports first second := by
  show (semanticMinimumSupports.filter fun support =>
      orbitMap element first ∈ support ∧ orbitMap element second ∈ support).card = _
  conv_lhs => rw [← image_orbitMap_semanticMinimumSupports element]
  rw [Finset.filter_image, Finset.card_image_of_injective _
    (Finset.image_injective (orbitMap_bijective element).injective)]
  refine congrArg Finset.card (Finset.filter_congr fun support _ => ?_)
  constructor
  · rintro ⟨first_member, second_member⟩
    obtain ⟨source, source_mem, source_image⟩ := Finset.mem_image.mp first_member
    obtain ⟨other, other_mem, other_image⟩ := Finset.mem_image.mp second_member
    exact ⟨((orbitMap_bijective element).injective source_image) ▸ source_mem,
      ((orbitMap_bijective element).injective other_image) ▸ other_mem⟩
  · rintro ⟨first_member, second_member⟩
    exact ⟨Finset.mem_image_of_mem _ first_member, Finset.mem_image_of_mem _ second_member⟩

end PassantCodeQ13.Equivariance
