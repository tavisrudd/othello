import RelativeConicArcs.PassantCodeQ13.PencilJoins
import Mathlib.Data.Fintype.EquivFin

/-!
# The cyclic tangent graph used in the weight-eight exclusion

After fixing one internal point, the tangent-product reduction produces a graph on three cyclic
orbits of length fourteen.  The module forms the product of the conic secants through an internal
point, evaluated at a second point, and identifies the resulting tangent-holonomy compatibility
relation with the six cyclic difference sets.  Row parity saturates the seven passant pencils of a
normalized weight-eight word.  Once the classical arc/tangent lemma supplies pairwise passant joins
and tangent holonomy one, the semantic support therefore maps to a seven-clique.

The finite checks enumerate the 4-cliques, extend each by its common neighbor, and verify that the
resulting 5-cliques have no further common neighbor.  A separate logical lemma turns this
unique-extension certificate into the five-clique bound, excluding the transported seven-clique
without enumerating binary words of length 78.

Every finite check in this module is decided by kernel reduction, and no statement depends on
native evaluation or on an external certificate.  The checks over the 42 vertices read the vertex
triples and their passant and secant pencils from precomputed lists, so each pencil is reduced once
rather than once per vertex pair, and the tangent product is evaluated over the seven conic secants
through a point rather than over all normalized secants.  The agreement of the enumerated
four-clique sets with the four-element clique subsets of the ambient powerset is proved rather than
computed, since materializing that powerset is not feasible for the kernel.
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
  ⟨⟨1, 0, 2⟩, by decide +kernel⟩

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
  decide +kernel

/-- The semantic internal point represented by a cyclic graph vertex. -/
def vertexPoint (vertex : Vertex) : InternalPoint :=
  ⟨vertexTriple vertex, vertexTriple_internal vertex⟩

/-- Two internal points have passant join when a passant line contains both. -/
def PassantJoin (first second : InternalPoint) : Prop :=
  ∃ line : PassantLine, Incident line first ∧ Incident line second

instance (first second : InternalPoint) : Decidable (PassantJoin first second) := by
  unfold PassantJoin
  infer_instance

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
theorem basePassantLines_card : basePassantLines.card = 7 :=
  card_passantLines_through basePoint

/-- A second internal point determines at most one passant line through the base point. -/
theorem passantLine_through_base_unique_for_point : ∀ point : InternalPoint,
    point ≠ basePoint → ∀ first second : PassantLine,
      Incident first basePoint → Incident first point →
      Incident second basePoint → Incident second point → first = second :=
  fun _ distinct _ _ first_base first_point second_base second_point =>
    passantLine_join_unique distinct first_base first_point second_base second_point

/-- No cyclic vertex triple is the base point. -/
private theorem vertexTriple_ne_basePoint : ∀ vertex : Vertex, vertexTriple vertex ≠ basePoint.1 := by
  decide +kernel

/-- Distinct cyclic vertices carry distinct coordinate triples. -/
private theorem vertexTriple_injective : ∀ first second : Vertex,
    vertexTriple first = vertexTriple second → first = second := by
  decide +kernel

/-- Every cyclic vertex triple shares a passant line with the base point. -/
private theorem vertexTriple_meets_base : ∀ vertex : Vertex,
    commonPencilLines (passantPencilList basePoint.1)
      (passantPencilList (vertexTriple vertex)) ≠ [] := by
  decide +kernel

/-- Every cyclic vertex represents a distinct passant-join neighbor of the base point. -/
theorem vertexPoint_is_baseNeighbor : ∀ vertex : Vertex,
    vertexPoint vertex ≠ basePoint ∧ PassantJoin basePoint (vertexPoint vertex) := by
  intro vertex
  refine ⟨fun equal => vertexTriple_ne_basePoint vertex (congrArg Subtype.val equal), ?_⟩
  exact (exists_common_passantLine_iff basePoint (vertexPoint vertex)).mpr
    (vertexTriple_meets_base vertex)

/-- A cyclic vertex as a semantic passant-join neighbor of the base point. -/
def vertexNeighbor (vertex : Vertex) : BaseNeighbor :=
  ⟨vertexPoint vertex, vertexPoint_is_baseNeighbor vertex⟩

/-- The coordinate triples of the internal points sharing a passant line with the base point. -/
def baseNeighborTriples : List Triple :=
  internalCoordinateList.filter fun point =>
    point != basePoint.1 &&
      !(commonPencilLines (passantPencilList basePoint.1) (passantPencilList point)).isEmpty

/-- The cyclic vertices carry exactly the passant-join neighbors of the base point. -/
theorem baseNeighborTriples_toFinset :
    baseNeighborTriples.toFinset = (vertices.map vertexTriple).toFinset := by
  decide +kernel

/-- The cyclic coordinates enumerate all 42 passant-join neighbors of the base point once. -/
theorem vertexNeighbor_bijective : Function.Bijective vertexNeighbor := by
  constructor
  · intro first second equal
    exact vertexTriple_injective first second (congrArg (fun neighbor => neighbor.1.1) equal)
  · intro neighbor
    have triple_mem : neighbor.1.1 ∈ baseNeighborTriples := by
      refine List.mem_filter.mpr ⟨mem_internalCoordinateList neighbor.1, ?_⟩
      have distinct : ¬ neighbor.1.1 = basePoint.1 :=
        fun equal => neighbor.2.1 (Subtype.ext equal)
      have meets : commonPencilLines (passantPencilList basePoint.1)
          (passantPencilList neighbor.1.1) ≠ [] :=
        (exists_common_passantLine_iff basePoint neighbor.1).mp neighbor.2.2
      simp [distinct, meets]
    have vertex_mem : neighbor.1.1 ∈ vertices.map vertexTriple := by
      rw [← List.mem_toFinset, ← baseNeighborTriples_toFinset, List.mem_toFinset]
      exact triple_mem
    obtain ⟨vertex, -, triple_eq⟩ := List.mem_map.mp vertex_mem
    exact ⟨vertex, Subtype.ext (Subtype.ext triple_eq)⟩

/-- The cyclic tangent vertices are equivalent to the semantic passant-join neighbors. -/
noncomputable def vertexNeighborEquiv : Vertex ≃ BaseNeighbor :=
  Equiv.ofBijective vertexNeighbor vertexNeighbor_bijective

/-- The evaluation product of a list of dual lines at a point. -/
def pencilEvaluationProduct (pencil : List Triple) (argument : Triple) : Field13 :=
  (pencil.map fun line => lineValue line argument).prod

/-- The tangent product is the evaluation product of the point's displayed secant pencil. -/
theorem tangentProduct_eq_pencilEvaluationProduct (point argument : InternalPoint) :
    tangentProduct point argument
      = pencilEvaluationProduct (secantPencilList point.1) argument.1 := by
  have guarded_prod := prod_secantLine
    fun line => if lineValue line point.1 = 0 then lineValue line argument.1 else 1
  rw [tangentProduct, guarded_prod]
  exact prod_guarded_eq_prod_pencil secantCoordinateList point.1
    fun line => lineValue line argument.1

/-- The position of a cyclic vertex in the displayed vertex list. -/
def vertexIndex (vertex : Vertex) : Nat := 14 * vertex.1.1 + vertex.2.1

/-- The coordinate triples of the cyclic vertices, in the displayed vertex order. -/
def vertexTriples : List Triple := vertices.map vertexTriple

/-- The passant pencils of the cyclic vertex triples, in the displayed vertex order. -/
def vertexPassantPencils : List (List Triple) := vertexTriples.map passantPencilList

/-- The secant pencils of the cyclic vertex triples, in the displayed vertex order. -/
def vertexSecantPencils : List (List Triple) := vertexTriples.map secantPencilList

/-- The secant pencil of the normalized base point. -/
def baseSecantPencil : List Triple := secantPencilList basePoint.1

/-- The coordinate triple of a cyclic vertex, read from the precomputed list. -/
def vertexTripleAt (vertex : Vertex) : Triple :=
  vertexTriples.getD (vertexIndex vertex) ⟨0, 0, 0⟩

/-- The passant pencil of a cyclic vertex, read from the precomputed list. -/
def vertexPassantPencil (vertex : Vertex) : List Triple :=
  vertexPassantPencils.getD (vertexIndex vertex) []

/-- The secant pencil of a cyclic vertex, read from the precomputed list. -/
def vertexSecantPencil (vertex : Vertex) : List Triple :=
  vertexSecantPencils.getD (vertexIndex vertex) []

/-- The precomputed triple of a vertex is its coordinate triple. -/
private theorem vertexTripleAt_eq : ∀ vertex : Vertex,
    vertexTripleAt vertex = vertexTriple vertex := by
  decide +kernel

/-- The precomputed passant pencil of a vertex is the pencil of its coordinate triple. -/
private theorem vertexPassantPencil_eq : ∀ vertex : Vertex,
    vertexPassantPencil vertex = passantPencilList (vertexTriple vertex) := by
  decide +kernel

/-- The precomputed secant pencil of a vertex is the pencil of its coordinate triple. -/
private theorem vertexSecantPencil_eq : ∀ vertex : Vertex,
    vertexSecantPencil vertex = secantPencilList (vertexTriple vertex) := by
  decide +kernel

/-- Adjacency agrees with distinctness, a shared passant, and the tangent-holonomy identity,
all read from the precomputed vertex pencils. -/
private theorem adjacent_iff_pencil_check : ∀ first second : Vertex,
    adjacent first second = true ↔
      (vertexTripleAt first ≠ vertexTripleAt second ∧
        commonPencilLines (vertexPassantPencil first) (vertexPassantPencil second) ≠ [] ∧
        pencilEvaluationProduct baseSecantPencil (vertexTripleAt first)
              * pencilEvaluationProduct (vertexSecantPencil first) (vertexTripleAt second)
              * pencilEvaluationProduct (vertexSecantPencil second) basePoint.1
            = pencilEvaluationProduct baseSecantPencil (vertexTripleAt second)
              * pencilEvaluationProduct (vertexSecantPencil second) (vertexTripleAt first)
              * pencilEvaluationProduct (vertexSecantPencil first) basePoint.1) := by
  decide +kernel

/-- The six cyclic difference sets are exactly the semantic tangent compatibility relation. -/
theorem adjacent_iff_tangentCompatibleAtBase : ∀ first second : Vertex,
    adjacent first second = true ↔
      TangentCompatibleAtBase (vertexPoint first) (vertexPoint second) := by
  intro first second
  have distinct_iff : (vertexTriple first ≠ vertexTriple second) ↔
      (vertexPoint first ≠ vertexPoint second) :=
    not_congr ⟨fun equal => Subtype.ext equal, fun equal => congrArg Subtype.val equal⟩
  have join_iff : commonPencilLines (passantPencilList (vertexTriple first))
        (passantPencilList (vertexTriple second)) ≠ [] ↔
      PassantJoin (vertexPoint first) (vertexPoint second) :=
    (exists_common_passantLine_iff (vertexPoint first) (vertexPoint second)).symm
  have holonomy_iff :
      (pencilEvaluationProduct baseSecantPencil (vertexTriple first)
            * pencilEvaluationProduct (secantPencilList (vertexTriple first))
                (vertexTriple second)
            * pencilEvaluationProduct (secantPencilList (vertexTriple second)) basePoint.1
          = pencilEvaluationProduct baseSecantPencil (vertexTriple second)
            * pencilEvaluationProduct (secantPencilList (vertexTriple second))
                (vertexTriple first)
            * pencilEvaluationProduct (secantPencilList (vertexTriple first)) basePoint.1) ↔
      TangentHolonomyOne basePoint (vertexPoint first) (vertexPoint second) := by
    unfold TangentHolonomyOne
    simp only [tangentProduct_eq_pencilEvaluationProduct]
    rfl
  rw [adjacent_iff_pencil_check first second]
  simp only [vertexTripleAt_eq, vertexPassantPencil_eq, vertexSecantPencil_eq]
  unfold TangentCompatibleAtBase
  exact and_congr distinct_iff (and_congr join_iff holonomy_iff)

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

/-- The displayed vertex list repeats no vertex. -/
private theorem vertices_nodup : vertices.Nodup := by
  decide +kernel

/-- The displayed vertex list enumerates every vertex. -/
private theorem vertices_toFinset : vertices.toFinset = (Finset.univ : Finset Vertex) := by
  decide +kernel

/-- A finite set of size `n` inside a duplicate-free list is the member set of one of that list's
sublists of length `n`. -/
private theorem exists_sublistsLen_toFinset {α : Type*} [DecidableEq α] {enumeration : List α}
    (nodup : enumeration.Nodup) {members : Finset α} {size : ℕ}
    (subset : members ⊆ enumeration.toFinset) (card_members : members.card = size) :
    ∃ chosen ∈ enumeration.sublistsLen size, chosen.toFinset = members := by
  obtain ⟨listed, listed_eq⟩ := Quotient.exists_rep members.val
  have toFinset_val : enumeration.toFinset.val = (enumeration : Multiset α) := by
    rw [List.toFinset_val, nodup.dedup]
  have members_le : members.val ≤ (enumeration : Multiset α) := by
    rw [← toFinset_val]
    exact Finset.val_le_iff.mpr subset
  rw [← listed_eq] at members_le
  obtain ⟨chosen, chosen_perm, chosen_sublist⟩ := Multiset.coe_le.mp members_le
  have chosen_coe : (chosen : Multiset α) = members.val := by
    rw [← listed_eq]
    exact Quotient.sound chosen_perm
  refine ⟨chosen, List.mem_sublistsLen.mpr ⟨chosen_sublist, ?_⟩, ?_⟩
  · have card_eq : Multiset.card (chosen : Multiset α) = members.card := by
      rw [chosen_coe]
      rfl
    simpa [card_members] using card_eq
  · ext element
    rw [List.mem_toFinset, ← Multiset.mem_coe, chosen_coe]
    rfl

/-- A vertex list is a clique exactly when its member set is one. -/
private theorem isClique_iff_isCliqueSet {chosen : List Vertex} :
    isClique chosen = true ↔ IsCliqueSet chosen.toFinset := by
  simp only [isClique, List.all_eq_true, Bool.or_eq_true, beq_iff_eq, IsCliqueSet,
    List.mem_toFinset]
  constructor
  · intro all first first_mem second second_mem distinct
    exact (all first first_mem second second_mem).resolve_left distinct
  · intro clique first first_mem second second_mem
    by_cases equal : first = second
    · exact Or.inl equal
    · exact Or.inr (clique first_mem second_mem equal)

/-- The list enumeration contains every four-vertex clique. -/
theorem fourCliqueSets_complete : fourCliqueSets.toFinset =
    (Finset.univ.powersetCard 4 |>.filter IsCliqueSet) := by
  ext members
  simp only [List.mem_toFinset, Finset.mem_filter, Finset.mem_powersetCard, fourCliqueSets,
    fourCliques, List.mem_map, List.mem_filter]
  constructor
  · rintro ⟨chosen, ⟨sublist_mem, clique⟩, chosen_eq⟩
    obtain ⟨sublist, length⟩ := List.mem_sublistsLen.mp sublist_mem
    have nodup : chosen.Nodup := vertices_nodup.sublist sublist
    subst chosen_eq
    exact ⟨⟨Finset.subset_univ _, by rw [List.toFinset_card_of_nodup nodup, length]⟩,
      isClique_iff_isCliqueSet.mp clique⟩
  · rintro ⟨⟨-, card_members⟩, clique⟩
    obtain ⟨chosen, chosen_mem, chosen_eq⟩ :=
      exists_sublistsLen_toFinset vertices_nodup
        (by rw [vertices_toFinset]; exact Finset.subset_univ members) card_members
    exact ⟨chosen, ⟨chosen_mem, isClique_iff_isCliqueSet.mpr (chosen_eq ▸ clique)⟩, chosen_eq⟩

/-- The orbit-major bit encoding of a finite vertex list. -/
def encodeVertices (members : List Vertex) : Nat :=
  members.foldl (fun answer vertex => answer ||| (1 <<< (14 * vertex.1.1 + vertex.2.1))) 0

/-- The distinct 5-cliques obtained by adjoining the unique common neighbor of a 4-clique. -/
def fiveCliqueCodes : List Nat :=
  (fourCliques.flatMap fun members =>
    (commonNeighbors members).map fun candidate => encodeVertices (candidate :: members)).eraseDups

/-- There are exactly seventy 4-cliques in the tangent graph. -/
theorem fourCliques_length : fourCliques.length = 70 := by
  decide +kernel

/-- Every enumerated 4-clique has exactly one common neighbor. -/
theorem fourClique_unique_extension_check :
    fourCliques.all (fun members => (commonNeighbors members).length == 1) = true := by
  decide +kernel

/-- Unique extension collapses the seventy 4-cliques to fourteen 5-cliques. -/
theorem fiveCliqueCodes_length : fiveCliqueCodes.length = 14 := by
  decide +kernel

/-- None of the fourteen 5-cliques admits a further common neighbor. -/
theorem fiveClique_maximality_check :
    fourCliques.all (fun members =>
      (commonNeighbors members).all fun candidate =>
        (commonNeighbors (candidate :: members)).isEmpty) = true := by
  decide +kernel

/-- Every enumerated four-vertex clique has exactly one common neighbor. -/
theorem fourCliqueSet_unique_extension_check :
    fourCliqueSets.all (fun members => (commonNeighborSet members).card == 1) = true := by
  decide +kernel

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
