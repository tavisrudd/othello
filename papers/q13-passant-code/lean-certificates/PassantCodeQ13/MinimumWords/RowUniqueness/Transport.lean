import PassantCodeQ13.MinimumWords.RowUniqueness.Aggregate
import PassantCodeQ13.MinimumWords.RowUniqueness.GeometricRows
import PassantCodeQ13.MinimumWords.RowUniqueness.PairTransport

/-!
# Semantic uniqueness of the reconstructed passant rows

A finite set of internal points is *admissible* when it has seven elements, its points are pairwise
joined by a passant, and no support of the decoded minimum-word hypergraph contains three of them.
Listing such a set in the displayed index order turns it into an increasing list of seven indices
below `78` satisfying the hypotheses of
`PassantCodeQ13.MinimumWords.RowUniqueness.rowExtensionCheckAt_sound`, so the indexed certificate
identifies it with the point list of a displayed passant row, and the point of each listed index is
incident to the corresponding passant line.  With the converse direction supplied by
`geometric_rows_have_zero_triple_concurrence`, the intrinsically reconstructed family is exactly the
family of geometric passant-row supports.
-/

namespace PassantCodeQ13.MinimumWords.RowUniqueness

open Finset
open RelativeConicArcs.PassantCodeQ13
open PassantCodeQ13.WeightTen

/-- The displayed indices of a finite set of internal points, in increasing order. -/
def indexedVertices (vertices : Finset InternalPoint) : List Nat :=
  (verticesInOrder vertices).map internalPointIndex

/-- An index occurs in the listing exactly when it is displayed and its point belongs to the set. -/
theorem mem_indexedVertices {vertices : Finset InternalPoint} {index : Fin 78} :
    index.1 ∈ indexedVertices vertices ↔ internalPointAt index ∈ vertices := by
  constructor
  · intro index_mem
    obtain ⟨point, point_mem, point_index⟩ := List.mem_map.mp index_mem
    obtain ⟨source, rfl⟩ := internalPointAt_bijective.surjective point
    rw [internalPointIndex_internalPointAt] at point_index
    have source_eq : source = index := Fin.ext point_index
    subst source_eq
    exact (mem_verticesInOrder _ vertices).mp point_mem
  · intro point_mem
    exact List.mem_map.mpr ⟨internalPointAt index,
      (mem_verticesInOrder _ vertices).mpr point_mem, internalPointIndex_internalPointAt index⟩

/-- Every index in the listing is displayed. -/
theorem lt_of_mem_indexedVertices {vertices : Finset InternalPoint} {index : Nat}
    (index_mem : index ∈ indexedVertices vertices) : index < 78 := by
  obtain ⟨point, _, point_index⟩ := List.mem_map.mp index_mem
  obtain ⟨source, rfl⟩ := internalPointAt_bijective.surjective point
  rw [internalPointIndex_internalPointAt] at point_index
  exact point_index ▸ source.2

/-- The listing has one entry for each point of the set. -/
theorem length_indexedVertices (vertices : Finset InternalPoint) :
    (indexedVertices vertices).length = vertices.card := by
  rw [indexedVertices, List.length_map, verticesInOrder_length]

/-- The listing is strictly increasing. -/
theorem indexedVertices_pairwise_lt (vertices : Finset InternalPoint) :
    (indexedVertices vertices).Pairwise (· < ·) := by
  have order_pairwise : internalPointOrder.Pairwise
      fun first second => internalPointIndex first < internalPointIndex second := by
    rw [internalPointOrder, List.pairwise_ofFn]
    intro first second first_lt_second
    rw [internalPointIndex_internalPointAt, internalPointIndex_internalPointAt]
    exact first_lt_second
  exact List.pairwise_map.mpr ((order_pairwise.filter _))

/-- Every admissible seven-set of internal points is the point set of a passant line. -/
theorem admissible_seven_set_is_geometric_row
    (vertices : Finset InternalPoint)
    (vertices_card : vertices.card = 7)
    (vertices_clique : IsPassantClique vertices)
    (vertices_zero : ∀ first ∈ vertices, ∀ second ∈ vertices, ∀ third ∈ vertices,
      first ≠ second → first ≠ third → second ≠ third →
        RelativeConicArcs.ConicPassantCode.tripleConcurrence
          semanticMinimumSupports first second third = 0) :
    vertices ∈ RelativeConicArcs.ConicPassantCode.rowSupports Incident := by
  have listed_mem : ∀ index ∈ indexedVertices vertices,
      ∃ source : Fin 78, source.1 = index ∧ internalPointAt source ∈ vertices := by
    intro index index_mem
    refine ⟨⟨index, lt_of_mem_indexedVertices index_mem⟩, rfl, ?_⟩
    exact mem_indexedVertices.mp index_mem
  have classified := rowExtensionCheckAt_sound (indexedVertices vertices)
    (by rw [length_indexedVertices, vertices_card])
    (fun index index_mem => lt_of_mem_indexedVertices index_mem)
    (indexedVertices_pairwise_lt vertices)
    (by
      intro first first_mem second second_mem distinct
      obtain ⟨firstSource, rfl, firstPoint⟩ := listed_mem first first_mem
      obtain ⟨secondSource, rfl, secondPoint⟩ := listed_mem second second_mem
      refine (hasPassantJoin_eq_true_iff firstSource secondSource).mpr ?_
      exact vertices_clique _ firstPoint _ secondPoint
        (fun equality => distinct (congrArg Fin.val
          (internalPointAt_bijective.injective equality))))
    (by
      intro first first_mem second second_mem third third_mem
        first_ne_second first_ne_third second_ne_third
      obtain ⟨firstSource, rfl, firstPoint⟩ := listed_mem first first_mem
      obtain ⟨secondSource, rfl, secondPoint⟩ := listed_mem second second_mem
      obtain ⟨thirdSource, rfl, thirdPoint⟩ := listed_mem third third_mem
      have semantic := vertices_zero _ firstPoint _ secondPoint _ thirdPoint
        (fun equality => first_ne_second (congrArg Fin.val
          (internalPointAt_bijective.injective equality)))
        (fun equality => first_ne_third (congrArg Fin.val
          (internalPointAt_bijective.injective equality)))
        (fun equality => second_ne_third (congrArg Fin.val
          (internalPointAt_bijective.injective equality)))
      rw [← minimumSupportCodes_eq]
      have indexed := indexedTripleConcurrence_eq_semantic (internalPointAt firstSource)
        (internalPointAt secondSource) (internalPointAt thirdSource)
      rw [indexedTripleConcurrence, internalPointIndex_internalPointAt,
        internalPointIndex_internalPointAt, internalPointIndex_internalPointAt] at indexed
      rw [indexed, semantic])
    (fun first first_lt => row_extension_check_all_indices first first_lt)
  obtain ⟨line, line_mem, row_eq⟩ := List.mem_map.mp classified
  have line_lt : line < 78 := List.mem_range.mp line_mem
  refine Finset.mem_image.mpr ⟨passantLineAt ⟨line, line_lt⟩, Finset.mem_univ _, ?_⟩
  ext point
  obtain ⟨index, rfl⟩ := internalPointAt_bijective.surjective point
  rw [RelativeConicArcs.ConicPassantCode.rowSupport, Finset.mem_filter]
  constructor
  · intro point_data
    refine mem_indexedVertices.mp ?_
    rw [← row_eq]
    refine List.mem_filter.mpr ⟨List.mem_range.mpr index.2, ?_⟩
    rw [tabulatedIncidentAt_eq_incidentAt line_lt index.2]
    exact (PencilTransport.incidentAt_iff ⟨line, line_lt⟩ index).mpr point_data.2
  · intro point_mem
    refine ⟨Finset.mem_univ _, ?_⟩
    have index_mem : index.1 ∈ passantRowPoints line := by
      rw [row_eq]
      exact mem_indexedVertices.mpr point_mem
    have incident := (List.mem_filter.mp index_mem).2
    rw [tabulatedIncidentAt_eq_incidentAt line_lt index.2] at incident
    exact (PencilTransport.incidentAt_iff ⟨line, line_lt⟩ index).mp incident

/-- The minimum-support hypergraph recovers exactly the 78 geometric passant-row supports. -/
theorem reconstructed_rows_eq_geometric_passant_rows :
    reconstructedRows semanticMinimumSupports =
      RelativeConicArcs.ConicPassantCode.rowSupports Incident := by
  apply reconstructedRows_eq_passantRows_of_sevenSet_transport semanticMinimumSupports
    geometric_rows_have_zero_triple_concurrence
  intro vertices vertices_card vertices_clique triple_zero
  apply admissible_seven_set_is_geometric_row vertices vertices_card vertices_clique
  intro first first_mem second second_mem third third_mem
    first_ne_second first_ne_third second_ne_third
  let triple : Finset InternalPoint := {first, second, third}
  have triple_mem : triple ∈ vertices.powersetCard 3 := by
    apply Finset.mem_powersetCard.mpr
    constructor
    · intro point point_mem
      simp only [triple, mem_insert, mem_singleton] at point_mem
      rcases point_mem with rfl | rfl | rfl
      · exact first_mem
      · exact second_mem
      · exact third_mem
    · simp [triple, first_ne_second, first_ne_third, second_ne_third]
  exact triple_zero triple triple_mem first (by simp [triple]) second (by simp [triple])
    third (by simp [triple]) first_ne_second first_ne_third second_ne_third

end PassantCodeQ13.MinimumWords.RowUniqueness
