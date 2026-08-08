import PassantCodeQ13.MinimumWords.RowUniqueness.BitangentWitness
import PassantCodeQ13.MinimumWords.RowUniqueness.GeometricRows

/-!
# Semantic uniqueness of the reconstructed passant rows

A finite set of internal points is *admissible* when it has seven elements, its points are pairwise
joined by a passant, and no support of the decoded minimum-word hypergraph contains three of them.
This module proves that an admissible set is the point set of a passant line, which with the
converse supplied by `geometric_rows_have_zero_triple_concurrence` identifies the intrinsically
reconstructed family with the family of geometric passant-row supports.

The argument is the Gram relation of four internal points.  Choosing for each point a coordinate
representative of the fixed conic value `normalizedLiftDiscriminant`, a pair of points acquires a
normalized trace, which lies in `joinTraces` exactly because the pair is joined by a passant; a
triple acquires the residue admissibility condition `tripleAdmissible`, because no member of the
decoded minimum-word family contains all three of its points; and a quadruple has vanishing
four-by-four trace Gram determinant, because four coordinate triples are linearly dependent.  The
exhaustion `admissible_trace_quadruple_has_vanishing_triple_grams` then forces every triple Gram
determinant of the quadruple to vanish, which says that every three of the four points are
collinear.

Applying this to a triple of the admissible set together with any fourth point of it — available
because the set has seven elements — makes every triple of the set collinear.  The set therefore
lies on the unique line through any two of its points, which is a passant because the two points are
passant-joined, and a passant carries exactly seven internal points, so the inclusion is an
equality.
-/

namespace PassantCodeQ13.MinimumWords.RowUniqueness

open Finset
open RelativeConicArcs.PassantCodeQ13
open PassantCodeQ13.PlaneJoin
open PassantCodeQ13.SymmetricSquare

/-! ## Admissible seven-sets -/

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
  classical
  choose liftFactor liftFactor_nonzero liftValue using exists_normalizedLift
  set lift : InternalPoint → Triple := fun point => scaleTriple (liftFactor point) point.1
    with lift_def
  have lift_eq : ∀ point : InternalPoint, lift point = scaleTriple (liftFactor point) point.1 :=
    fun _ => rfl
  -- Zero triple concurrence says that no member of the family contains all three points.
  have no_common : ∀ first ∈ vertices, ∀ second ∈ vertices, ∀ third ∈ vertices,
      first ≠ second → first ≠ third → second ≠ third →
      ∀ support ∈ semanticMinimumSupports,
        ¬(first ∈ support ∧ second ∈ support ∧ third ∈ support) := by
    intro first first_mem second second_mem third third_mem first_ne_second first_ne_third
      second_ne_third support support_mem contains
    have vanishing := vertices_zero first first_mem second second_mem third third_mem
      first_ne_second first_ne_third second_ne_third
    rw [RelativeConicArcs.ConicPassantCode.tripleConcurrence, Finset.card_eq_zero,
      Finset.filter_eq_empty_iff] at vanishing
    exact vanishing support_mem contains
  -- Hence every triple of the set satisfies the residue admissibility condition.
  have admissible : ∀ first ∈ vertices, ∀ second ∈ vertices, ∀ third ∈ vertices,
      first ≠ second → first ≠ third → second ≠ third →
      tripleAdmissible (normalizedTrace (lift first) (lift second)).val
        (normalizedTrace (lift first) (lift third)).val
        (normalizedTrace (lift second) (lift third)).val = true := by
    intro first first_mem second second_mem third third_mem first_ne_second first_ne_third
      second_ne_third
    exact tripleAdmissible_of_no_common_support (liftFactor_nonzero first)
      (liftFactor_nonzero second) (liftFactor_nonzero third) (lift_eq first) (lift_eq second)
      (lift_eq third) (liftValue first) (liftValue second) (liftValue third)
      (no_common first first_mem second second_mem third third_mem first_ne_second
        first_ne_third second_ne_third)
  -- Every pair of the set is passant-joined, so its normalized trace is one of six residues.
  have joined : ∀ first ∈ vertices, ∀ second ∈ vertices, first ≠ second →
      (normalizedTrace (lift first) (lift second)).val ∈ joinTraces := by
    intro first first_mem second second_mem different
    exact val_normalizedTrace_mem_joinTraces (liftFactor_nonzero first)
      (liftFactor_nonzero second) (lift_eq first) (lift_eq second) (liftValue first)
      (liftValue second) different (vertices_clique first first_mem second second_mem different)
  -- A seven-set has a fourth point outside any three of its points.
  have fourth : ∀ first ∈ vertices, ∀ second ∈ vertices, ∀ third ∈ vertices,
      ∃ extra ∈ vertices, extra ≠ first ∧ extra ≠ second ∧ extra ≠ third := by
    intro first first_mem second second_mem third third_mem
    by_contra absent
    push Not at absent
    have subset : vertices ⊆ ({first, second, third} : Finset InternalPoint) := by
      intro point point_mem
      rcases eq_or_ne point first with rfl | point_ne_first
      · simp
      rcases eq_or_ne point second with rfl | point_ne_second
      · simp
      have := absent point point_mem point_ne_first point_ne_second
      simp [this]
    have bound : ({first, second, third} : Finset InternalPoint).card ≤ 3 := by
      refine le_trans (Finset.card_insert_le _ _) (Nat.succ_le_succ ?_)
      refine le_trans (Finset.card_insert_le _ _) ?_
      simp
    have counted := Finset.card_le_card subset
    rw [vertices_card] at counted
    omega
  -- Four points of the set have all four of their triples collinear.
  have collinear : ∀ first ∈ vertices, ∀ second ∈ vertices, ∀ third ∈ vertices,
      first ≠ second → first ≠ third → second ≠ third →
      coordinateDeterminant first.1 second.1 third.1 = 0 := by
    intro first first_mem second second_mem third third_mem first_ne_second first_ne_third
      second_ne_third
    obtain ⟨extra, extra_mem, extra_ne_first, extra_ne_second, extra_ne_third⟩ :=
      fourth first first_mem second second_mem third third_mem
    have vanishing := admissible_trace_quadruple_has_vanishing_triple_grams
      (joined first first_mem second second_mem first_ne_second)
      (joined first first_mem third third_mem first_ne_third)
      (joined first first_mem extra extra_mem (Ne.symm extra_ne_first))
      (joined second second_mem third third_mem second_ne_third)
      (joined second second_mem extra extra_mem (Ne.symm extra_ne_second))
      (joined third third_mem extra extra_mem (Ne.symm extra_ne_third))
      (admissible first first_mem second second_mem third third_mem first_ne_second
        first_ne_third second_ne_third)
      (admissible first first_mem second second_mem extra extra_mem first_ne_second
        (Ne.symm extra_ne_first) (Ne.symm extra_ne_second))
      (admissible first first_mem third third_mem extra extra_mem first_ne_third
        (Ne.symm extra_ne_first) (Ne.symm extra_ne_third))
      (admissible second second_mem third third_mem extra extra_mem second_ne_third
        (Ne.symm extra_ne_second) (Ne.symm extra_ne_third))
      (gramDet4_eq_zero (liftValue first) (liftValue second) (liftValue third) (liftValue extra))
    have lifted := (tripleGram_eq_zero_iff (liftValue first) (liftValue second)
      (liftValue third)).mp vanishing.1
    rw [coordinateDeterminant_scaleTriple] at lifted
    exact eq_zero_of_mul_eq_zero_field _ _
      (mul_ne_zero_field _ _ (mul_ne_zero_field _ _ (liftFactor_nonzero first)
        (liftFactor_nonzero second)) (liftFactor_nonzero third)) lifted
  -- Two distinct points of the set determine a passant carrying the whole set.
  obtain ⟨base, base_mem, other, other_mem, base_ne_other⟩ :=
    Finset.one_lt_card.mp (by rw [vertices_card]; norm_num)
  obtain ⟨line, base_incident, other_incident⟩ :=
    vertices_clique base base_mem other other_mem base_ne_other
  have coordinates_mem : ∀ point : InternalPoint, point.1 ∈ projectiveTripleList := by
    intro point
    have point_internal : point.1 ∈ internalCoordinateList :=
      List.mem_toFinset.mp (by rw [internalCoordinateList_toFinset]; exact point.2)
    exact ((mem_internalCoordinateList_iff point.1).mp point_internal).1
  have base_ne_coordinates : base.1 ≠ other.1 := fun equality =>
    base_ne_other (Subtype.ext equality)
  obtain ⟨joinFactor, joinFactor_nonzero, rescaled⟩ := normalizeTriple_eq_scaleTriple
    (joinTriple_ne_zero (coordinates_mem base) (coordinates_mem other) base_ne_coordinates)
  have rescale_dot : ∀ point : Triple,
      dotTriple (scaleTriple joinFactor (joinTriple base.1 other.1)) point
        = joinFactor * dotTriple (joinTriple base.1 other.1) point := by
    intro point
    simp only [dotTriple, scaleTriple]
    ring
  have line_data : line.1 ∈ projectiveTripleList ∧
      dotTriple line.1 base.1 = 0 ∧ dotTriple line.1 other.1 = 0 := by
    refine ⟨?_, base_incident, other_incident⟩
    have line_mem := line.2
    rw [mem_passantCoordinates_iff] at line_mem
    exact line_mem.1
  have join_data : normalizeTriple (joinTriple base.1 other.1) ∈ projectiveTripleList ∧
      dotTriple (normalizeTriple (joinTriple base.1 other.1)) base.1 = 0 ∧
      dotTriple (normalizeTriple (joinTriple base.1 other.1)) other.1 = 0 := by
    refine ⟨normalizeTriple_mem_projectiveTripleList _, ?_, ?_⟩
    · rw [rescaled, rescale_dot, dotTriple_joinTriple_left, mul_zero]
    · rw [rescaled, rescale_dot, dotTriple_joinTriple_right, mul_zero]
  have line_eq : line.1 = normalizeTriple (joinTriple base.1 other.1) := by
    obtain ⟨_, _, uniqueness⟩ := existsUnique_incident (coordinates_mem base)
      (coordinates_mem other) base_ne_coordinates
    rw [uniqueness line.1 line_data, uniqueness _ join_data]
  have subset : vertices ⊆ RelativeConicArcs.ConicPassantCode.rowSupport Incident line := by
    intro point point_mem
    refine Finset.mem_filter.mpr ⟨Finset.mem_univ _, ?_⟩
    rcases eq_or_ne point base with rfl | point_ne_base
    · exact base_incident
    rcases eq_or_ne point other with rfl | point_ne_other
    · exact other_incident
    have determinant := collinear base base_mem other other_mem point point_mem
      base_ne_other (Ne.symm point_ne_base) (Ne.symm point_ne_other)
    show dotTriple line.1 point.1 = 0
    rw [line_eq, rescaled, rescale_dot, dotTriple_joinTriple_eq_coordinateDeterminant,
      determinant, mul_zero]
  have equality : vertices = RelativeConicArcs.ConicPassantCode.rowSupport Incident line :=
    Finset.eq_of_subset_of_card_le subset (by rw [passantRow_card, vertices_card])
  exact Finset.mem_image.mpr ⟨line, Finset.mem_univ _, equality.symm⟩

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
