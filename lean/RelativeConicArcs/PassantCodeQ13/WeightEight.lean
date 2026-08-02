import RelativeConicArcs.PassantCodeQ13.Geometry
import Mathlib.Data.Fintype.EquivFin

/-!
# The cyclic tangent graph used in the weight-eight exclusion

After fixing one internal point, the tangent-product reduction produces a graph on three cyclic
orbits of length fourteen.  The module defines the conic-secant product in the normalized conic
model and identifies its tangent-holonomy compatibility relation with the six cyclic difference
sets.  Row parity saturates the seven passant pencils of a normalized weight-eight word.  Once the
classical arc/tangent lemma supplies pairwise passant joins and tangent holonomy one, the semantic
support therefore maps to a seven-clique.

The finite checks enumerate the 4-cliques, extend each by its common neighbor, and verify that the
resulting 5-cliques have no further common neighbor.  A separate logical lemma turns this
unique-extension certificate into the five-clique bound, excluding the transported seven-clique
without enumerating binary words of length 78.

The terminal checks use native evaluation on 42 vertices.  Their dependency therefore contains the
declaration-local native-decision axiom reported by the pinned Lean toolchain.
-/

namespace RelativeConicArcs.PassantCodeQ13.WeightEight

open Finset

/-- A vertex consists of one of three cyclic orbits and an index modulo fourteen. -/
abbrev Vertex := Fin 3 × Fin 14

/-- Multiplication of a homogeneous coordinate triple by a field scalar. -/
def scaleTriple (scalar : Field13) (point : Triple) : Triple :=
  ⟨scalar * point.x, scalar * point.y, scalar * point.z⟩

/-- The affine-first normalized representative of a nonzero homogeneous triple. -/
def normalizeTriple (point : Triple) : Triple :=
  if point.x ≠ 0 then scaleTriple point.x⁻¹ point
  else if point.y ≠ 0 then scaleTriple point.y⁻¹ point
  else scaleTriple point.z⁻¹ point

/-- The symmetric-square action of the order-fourteen matrix with rows `(1,3)` and `(7,1)`. -/
def cyclicAction (point : Triple) : Triple :=
  normalizeTriple ⟨point.x + 6 * point.y + 9 * point.z,
    7 * point.x + 9 * point.y + 3 * point.z,
    10 * point.x + point.y + point.z⟩

/-- The fixed internal point used to normalize the tangent graph. -/
def basePoint : InternalPoint :=
  ⟨⟨1, 0, 2⟩, by native_decide⟩

/-- The three seeds for the cyclic orbits of passant-join neighbors of `basePoint`. -/
def orbitSeed : Fin 3 → Triple
  | ⟨0, _⟩ => ⟨1, 1, 7⟩
  | ⟨1, _⟩ => ⟨1, 1, 6⟩
  | ⟨2, _⟩ => ⟨1, 2, 10⟩

/-- The normalized internal point represented by a cyclic graph vertex. -/
def vertexTriple (vertex : Vertex) : Triple :=
  (cyclicAction^[vertex.2.1]) (orbitSeed vertex.1)

/-- Every cyclic vertex triple is an internal point of the normalized conic model. -/
theorem vertexTriple_internal : ∀ vertex : Vertex,
    vertexTriple vertex ∈ internalCoordinates := by
  native_decide

/-- The semantic internal point represented by a cyclic graph vertex. -/
def vertexPoint (vertex : Vertex) : InternalPoint :=
  ⟨vertexTriple vertex, vertexTriple_internal vertex⟩

/-- Two internal points have passant join when a passant line contains both. -/
def PassantJoin (first second : InternalPoint) : Prop :=
  ∃ line : PassantLine, Incident line first ∧ Incident line second

instance (first second : InternalPoint) : Decidable (PassantJoin first second) := by
  unfold PassantJoin
  infer_instance

/-- The normalized secant lines of the standard conic. -/
def secantCoordinates : Finset Triple :=
  projectiveTriples.filter fun line =>
    lineDiscriminant line ≠ 0 ∧ isNonzeroSquare (lineDiscriminant line) = true

/-- A normalized conic-secant line in the fixed dual-coordinate model. -/
abbrev SecantLine := {line : Triple // line ∈ secantCoordinates}

/-- Evaluation of a homogeneous dual line at a homogeneous point. -/
def lineValue (line : Triple) (point : Triple) : Field13 :=
  line.x * point.x + line.y * point.y + line.z * point.z

/-- The product of the seven conic-secants through an internal point, evaluated at another point. -/
def tangentProduct (point argument : InternalPoint) : Field13 :=
  ∏ line : SecantLine, if lineValue line.1 point.1 = 0 then lineValue line.1 argument.1 else 1

/-- The cross-multiplied tangent holonomy identity for an ordered triple. -/
def TangentHolonomyOne (first second third : InternalPoint) : Prop :=
  tangentProduct first second * tangentProduct second third * tangentProduct third first =
    tangentProduct first third * tangentProduct third second * tangentProduct second first

instance (first second third : InternalPoint) : Decidable (TangentHolonomyOne first second third) :=
  decEq _ _

/-- The geometric compatibility relation after fixing the normalized base point. -/
def TangentCompatibleAtBase (first second : InternalPoint) : Prop :=
  first ≠ second ∧ PassantJoin first second ∧ TangentHolonomyOne basePoint first second

instance (first second : InternalPoint) : Decidable (TangentCompatibleAtBase first second) := by
  unfold TangentCompatibleAtBase
  infer_instance

/-- The forty-two vertices in orbit-major cyclic order. -/
def vertices : List Vertex :=
  List.ofFn fun index : Fin 42 =>
    (⟨index.1 / 14, by omega⟩, ⟨index.1 % 14, Nat.mod_lt _ (by decide)⟩)

/-- The allowed positive cyclic differences for an ordered pair of orbit labels. -/
def allowedDifference (first second : Fin 3) (difference : Fin 14) : Bool :=
  match first.1, second.1 with
  | 0, 0 => difference.1 ∈ [4, 6, 8, 10]
  | 0, 1 => difference.1 ∈ [6, 7, 11, 12]
  | 0, 2 => difference.1 ∈ [1, 3]
  | 1, 1 => difference.1 ∈ [6, 8]
  | 1, 2 => difference.1 ∈ [3, 5, 6, 8, 9, 11]
  | 2, 2 => difference.1 ∈ [2, 4, 10, 12]
  | _, _ => false

/-- Adjacency in the symmetric three-orbit cyclic tangent graph. -/
def adjacent (first second : Vertex) : Bool :=
  if first.1.1 ≤ second.1.1 then
    allowedDifference first.1 second.1
      ⟨(second.2.1 + 14 - first.2.1) % 14, Nat.mod_lt _ (by decide)⟩
  else
    allowedDifference second.1 first.1
      ⟨(first.2.1 + 14 - second.2.1) % 14, Nat.mod_lt _ (by decide)⟩

/-- The semantic passant-join neighbors of the normalized base point. -/
abbrev BaseNeighbor :=
  {point : InternalPoint // point ≠ basePoint ∧ PassantJoin basePoint point}

/-- The seven passant lines through the normalized base point. -/
def basePassantLines : Finset PassantLine :=
  Finset.univ.filter fun line => Incident line basePoint

/-- Exactly seven passant lines contain the normalized base point. -/
theorem basePassantLines_card : basePassantLines.card = 7 := by
  native_decide

/-- A second internal point determines at most one passant line through the base point. -/
theorem passantLine_through_base_unique_for_point : ∀ point : InternalPoint,
    point ≠ basePoint → ∀ first second : PassantLine,
      Incident first basePoint → Incident first point →
      Incident second basePoint → Incident second point → first = second := by
  native_decide

/-- Every cyclic vertex represents a distinct passant-join neighbor of the base point. -/
theorem vertexPoint_is_baseNeighbor : ∀ vertex : Vertex,
    vertexPoint vertex ≠ basePoint ∧ PassantJoin basePoint (vertexPoint vertex) := by
  native_decide

/-- A cyclic vertex as a semantic passant-join neighbor of the base point. -/
def vertexNeighbor (vertex : Vertex) : BaseNeighbor :=
  ⟨vertexPoint vertex, vertexPoint_is_baseNeighbor vertex⟩

/-- The cyclic coordinates enumerate all 42 passant-join neighbors of the base point once. -/
theorem vertexNeighbor_bijective : Function.Bijective vertexNeighbor := by
  native_decide

/-- The cyclic tangent vertices are equivalent to the semantic passant-join neighbors. -/
noncomputable def vertexNeighborEquiv : Vertex ≃ BaseNeighbor :=
  Equiv.ofBijective vertexNeighbor vertexNeighbor_bijective

/-- The six cyclic difference sets are exactly the semantic tangent compatibility relation. -/
theorem adjacent_iff_tangentCompatibleAtBase : ∀ first second : Vertex,
    adjacent first second = true ↔
      TangentCompatibleAtBase (vertexPoint first) (vertexPoint second) := by
  native_decide

/-- Executable clique predicate for a finite vertex set. -/
def isClique (members : List Vertex) : Bool :=
  members.all fun first =>
    members.all fun second => first == second || adjacent first second

/-- A finite vertex set is a clique when every two distinct members are adjacent. -/
def IsCliqueSet (members : Finset Vertex) : Prop :=
  ∀ ⦃first⦄, first ∈ members → ∀ ⦃second⦄, second ∈ members →
    first ≠ second → adjacent first second = true

instance (members : Finset Vertex) : Decidable (IsCliqueSet members) := by
  unfold IsCliqueSet
  infer_instance

/-- Common neighbors of a finite vertex set, excluding the set itself. -/
def commonNeighborSet (members : Finset Vertex) : Finset Vertex :=
  Finset.univ.filter fun candidate =>
    candidate ∉ members ∧ ∀ member ∈ members, adjacent candidate member = true

/-- Vertices outside a set adjacent to every member of the set. -/
def commonNeighbors (members : List Vertex) : List Vertex :=
  vertices.filter fun candidate =>
    !members.contains candidate && members.all fun member => adjacent candidate member

/-- All 4-cliques in the tangent graph. -/
def fourCliques : List (List Vertex) :=
  (vertices.sublistsLen 4).filter isClique

/-- The enumerated four-vertex cliques, represented as unordered vertex sets. -/
def fourCliqueSets : List (Finset Vertex) :=
  fourCliques.map List.toFinset

/-- The list enumeration contains every four-vertex clique. -/
theorem fourCliqueSets_complete : fourCliqueSets.toFinset =
    (Finset.univ.powersetCard 4 |>.filter IsCliqueSet) := by
  native_decide

/-- The orbit-major bit encoding of a finite vertex list. -/
def encodeVertices (members : List Vertex) : Nat :=
  members.foldl (fun answer vertex => answer ||| (1 <<< (14 * vertex.1.1 + vertex.2.1))) 0

/-- The distinct 5-cliques obtained by adjoining the unique common neighbor of a 4-clique. -/
def fiveCliqueCodes : List Nat :=
  (fourCliques.flatMap fun members =>
    (commonNeighbors members).map fun candidate => encodeVertices (candidate :: members)).eraseDups

/-- There are exactly seventy 4-cliques in the tangent graph. -/
theorem fourCliques_length : fourCliques.length = 70 := by
  native_decide

/-- Every enumerated 4-clique has exactly one common neighbor. -/
theorem fourClique_unique_extension_check :
    fourCliques.all (fun members => (commonNeighbors members).length == 1) = true := by
  native_decide

/-- Unique extension collapses the seventy 4-cliques to fourteen 5-cliques. -/
theorem fiveCliqueCodes_length : fiveCliqueCodes.length = 14 := by
  native_decide

/-- None of the fourteen 5-cliques admits a further common neighbor. -/
theorem fiveClique_maximality_check :
    fourCliques.all (fun members =>
      (commonNeighbors members).all fun candidate =>
        (commonNeighbors (candidate :: members)).isEmpty) = true := by
  native_decide

/-- Every enumerated four-vertex clique has exactly one common neighbor. -/
theorem fourCliqueSet_unique_extension_check :
    fourCliqueSets.all (fun members => (commonNeighborSet members).card == 1) = true := by
  native_decide

/-- Every four-vertex clique in the cyclic graph has exactly one common neighbor. -/
theorem fourCliqueSet_unique_extension (members : Finset Vertex)
    (card_members : members.card = 4) (clique : IsCliqueSet members) :
    (commonNeighborSet members).card = 1 := by
  have members_mem : members ∈ fourCliqueSets := by
    apply List.mem_toFinset.mp
    rw [fourCliqueSets_complete]
    simp [card_members, clique]
  have checked := List.all_eq_true.mp fourCliqueSet_unique_extension_check members
    members_mem
  simpa using checked

/-- Every clique in the cyclic tangent graph has at most five vertices. -/
theorem cliqueSet_card_le_five (members : Finset Vertex)
    (clique : IsCliqueSet members) : members.card ≤ 5 := by
  by_contra too_large
  have six_le : 6 ≤ members.card := by omega
  obtain ⟨four, four_subset, four_card⟩ :=
    Finset.exists_subset_card_eq (show 4 ≤ members.card by omega)
  have four_clique : IsCliqueSet four := by
    intro first first_mem second second_mem distinct
    exact clique (four_subset first_mem) (four_subset second_mem) distinct
  have complement_subset : members \ four ⊆ commonNeighborSet four := by
    intro candidate candidate_mem
    have candidate_in_members : candidate ∈ members := (Finset.mem_sdiff.mp candidate_mem).1
    have candidate_not_in_four : candidate ∉ four := (Finset.mem_sdiff.mp candidate_mem).2
    simp only [commonNeighborSet, Finset.mem_filter, Finset.mem_univ, true_and]
    refine ⟨candidate_not_in_four, ?_⟩
    intro member member_mem
    exact clique candidate_in_members (four_subset member_mem) fun equal =>
      candidate_not_in_four (equal ▸ member_mem)
  have complement_card : 2 ≤ (members \ four).card := by
    rw [Finset.card_sdiff_of_subset four_subset, four_card]
    omega
  have common_card := Finset.card_le_card complement_subset
  rw [fourCliqueSet_unique_extension four four_card four_clique] at common_card
  omega

/-- A zero binary row sum containing a nonzero coordinate contains another nonzero coordinate. -/
theorem row_parity_forces_companion (word : InternalPoint → ZMod 2)
    (line : PassantLine) (point : InternalPoint) (incident : Incident line point)
    (point_nonzero : word point ≠ 0)
    (row_sum : ∑ other : InternalPoint,
      word other * ConicPassantCode.incidenceBit Incident line other = 0) :
    ∃ other : InternalPoint,
      other ≠ point ∧ word other ≠ 0 ∧ Incident line other := by
  by_contra no_companion
  push Not at no_companion
  have sum_is_point :
      (∑ other : InternalPoint,
        word other * ConicPassantCode.incidenceBit Incident line other) = word point := by
    rw [Finset.sum_eq_single point]
    · simp [ConicPassantCode.incidenceBit, incident]
    · intro other _ distinct
      by_cases other_zero : word other = 0
      · simp [other_zero]
      · have not_incident : ¬Incident line other :=
          fun other_incident => no_companion other distinct other_zero other_incident
        simp [ConicPassantCode.incidenceBit, not_incident]
    · simp
  rw [row_sum] at sum_is_point
  exact point_nonzero sum_is_point.symm

/-- A normalized weight-eight codeword has passant join from the base point to every other support
point.  This is the saturation step preceding the lemma of tangents. -/
theorem weightEight_base_joins
    (word : InternalPoint → ZMod 2) (word_mem : word ∈ passantCode)
    (weight : CodingBridge.hammingWeight word = 8)
    (base_mem : basePoint ∈ CodingBridge.hammingSupport word) :
    ∀ point ∈ CodingBridge.hammingSupport word,
      point ≠ basePoint → PassantJoin basePoint point := by
  classical
  let support := CodingBridge.hammingSupport word
  have support_card : support.card = 8 := weight
  have base_nonzero : word basePoint ≠ 0 := CodingBridge.mem_hammingSupport.mp base_mem
  have row_sums := (mem_passantCode_iff_row_sums word).mp word_mem
  have companion_exists : ∀ line : {line // line ∈ basePassantLines},
      ∃ point : InternalPoint,
        point ∈ support.erase basePoint ∧ Incident line.1 point := by
    intro line
    have line_incident : Incident line.1 basePoint :=
      (Finset.mem_filter.mp line.2).2
    obtain ⟨point, distinct, point_nonzero, point_incident⟩ :=
      row_parity_forces_companion word line.1 basePoint line_incident base_nonzero
        (row_sums line.1)
    exact ⟨point, Finset.mem_erase.mpr
      ⟨distinct, CodingBridge.mem_hammingSupport.mpr point_nonzero⟩, point_incident⟩
  let companion : {line // line ∈ basePassantLines} →
      {point // point ∈ support.erase basePoint} := fun line =>
    ⟨Classical.choose (companion_exists line), (Classical.choose_spec (companion_exists line)).1⟩
  have companion_incident (line : {line // line ∈ basePassantLines}) :
      Incident line.1 (companion line).1 :=
    (Classical.choose_spec (companion_exists line)).2
  have companion_injective : Function.Injective companion := by
    intro first second equal
    apply Subtype.ext
    apply passantLine_through_base_unique_for_point (companion first).1
    · exact (Finset.mem_erase.mp (companion first).2).1
    · exact (Finset.mem_filter.mp first.2).2
    · exact companion_incident first
    · exact (Finset.mem_filter.mp second.2).2
    · rw [equal]
      exact companion_incident second
  have domain_card : Fintype.card {line // line ∈ basePassantLines} = 7 := by
    simpa only [Fintype.card_coe] using basePassantLines_card
  have support_erase_card : (support.erase basePoint).card = 7 := by
    rw [Finset.card_erase_of_mem base_mem, support_card]
  have codomain_card : Fintype.card {point // point ∈ support.erase basePoint} = 7 := by
    simpa only [Fintype.card_coe] using support_erase_card
  have companion_surjective : Function.Surjective companion := by
    exact (Fintype.bijective_iff_injective_and_card companion).mpr
      ⟨companion_injective, domain_card.trans codomain_card.symm⟩ |>.2
  intro point point_mem distinct
  let supportedPoint : {point // point ∈ support.erase basePoint} :=
    ⟨point, Finset.mem_erase.mpr ⟨distinct, point_mem⟩⟩
  obtain ⟨line, line_maps⟩ := companion_surjective supportedPoint
  refine ⟨line.1, ?_, ?_⟩
  · exact (Finset.mem_filter.mp line.2).2
  · have := companion_incident line
    rw [line_maps] at this
    exact this

/-- Eight normalized internal points containing the base point cannot satisfy the tangent-graph
compatibility supplied by the lemma of tangents. -/
theorem no_eight_point_tangent_configuration_at_base
    (support : Finset InternalPoint) (support_card : support.card = 8)
    (base_mem : basePoint ∈ support)
    (base_joins : ∀ point ∈ support, point ≠ basePoint → PassantJoin basePoint point)
    (tangent_compatible : ∀ first ∈ support, first ≠ basePoint →
      ∀ second ∈ support, second ≠ basePoint → first ≠ second →
        TangentCompatibleAtBase first second) : False := by
  classical
  let toNeighbor : {point // point ∈ support.erase basePoint} → BaseNeighbor :=
    fun point => ⟨point.1, (Finset.mem_erase.mp point.2).1,
      base_joins point.1 (Finset.mem_erase.mp point.2).2
        (Finset.mem_erase.mp point.2).1⟩
  let toVertex : {point // point ∈ support.erase basePoint} → Vertex :=
    fun point => vertexNeighborEquiv.symm (toNeighbor point)
  have toVertex_injective : Function.Injective toVertex := by
    intro first second equal
    have neighbor_equal : toNeighbor first = toNeighbor second :=
      vertexNeighborEquiv.symm.injective equal
    exact Subtype.ext (congrArg (fun neighbor : BaseNeighbor => neighbor.1) neighbor_equal)
  let selected : Finset Vertex := (support.erase basePoint).attach.image toVertex
  have erase_card : (support.erase basePoint).card = 7 := by
    rw [Finset.card_erase_of_mem base_mem, support_card]
  have selected_card : selected.card = 7 := by
    rw [show selected = (support.erase basePoint).attach.image toVertex by rfl,
      Finset.card_image_of_injective _ toVertex_injective]
    simpa using erase_card
  have vertexPoint_toVertex : ∀ point : {point // point ∈ support.erase basePoint},
      vertexPoint (toVertex point) = point.1 := by
    intro point
    have inverse := congrArg Subtype.val
      (vertexNeighborEquiv.apply_symm_apply (toNeighbor point))
    exact inverse
  have selected_clique : IsCliqueSet selected := by
    intro first first_mem second second_mem distinct
    obtain ⟨firstPoint, firstPoint_mem, rfl⟩ := Finset.mem_image.mp first_mem
    obtain ⟨secondPoint, secondPoint_mem, rfl⟩ := Finset.mem_image.mp second_mem
    rw [adjacent_iff_tangentCompatibleAtBase,
      vertexPoint_toVertex firstPoint, vertexPoint_toVertex secondPoint]
    have first_data := Finset.mem_erase.mp firstPoint.2
    have second_data := Finset.mem_erase.mp secondPoint.2
    apply tangent_compatible firstPoint.1 first_data.2 first_data.1
      secondPoint.1 second_data.2 second_data.1
    intro equal_points
    apply distinct
    exact congrArg toVertex (Subtype.ext equal_points)
  have bound := cliqueSet_card_le_five selected selected_clique
  omega

/-- A normalized weight-eight codeword is impossible once the arc/tangent lemma supplies passant
joins and tangent holonomy one for every pair of nonbase support points. -/
theorem no_normalized_weightEight_codeword_of_tangent_holonomy
    (word : InternalPoint → ZMod 2) (word_mem : word ∈ passantCode)
    (weight : CodingBridge.hammingWeight word = 8)
    (base_mem : basePoint ∈ CodingBridge.hammingSupport word)
    (tangent_identity : ∀ first ∈ CodingBridge.hammingSupport word,
      first ≠ basePoint →
      ∀ second ∈ CodingBridge.hammingSupport word, second ≠ basePoint →
        first ≠ second →
          PassantJoin first second ∧ TangentHolonomyOne basePoint first second) : False := by
  apply no_eight_point_tangent_configuration_at_base
    (CodingBridge.hammingSupport word) weight base_mem
    (weightEight_base_joins word word_mem weight base_mem)
  intro first first_mem first_ne_base second second_mem second_ne_base distinct
  exact ⟨distinct, tangent_identity first first_mem first_ne_base
    second second_mem second_ne_base distinct⟩

end RelativeConicArcs.PassantCodeQ13.WeightEight
