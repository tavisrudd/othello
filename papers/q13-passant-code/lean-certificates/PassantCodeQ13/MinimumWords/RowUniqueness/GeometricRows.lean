import PassantCodeQ13.MinimumWords.RowUniqueness.ConcurrenceTransport
import PassantCodeQ13.MinimumWords.RowUniqueness.PassantJoinInvariant
import PassantCodeQ13.MinimumWords.SupportArc
import PassantCodeQ13.WeightTen.PencilTransport

/-!
# Zero triple concurrence on the geometric passant rows

Every passant line carries seven internal points, and no minimum-word support contains three of them.
This module proves that statement from the arc property of the minimum-word family, so nothing here
ranges over the 364 supports or the 78 rows.

Two steps.  Three internal points incident with one passant line have vanishing coordinate
determinant: two distinct points of a line determine that line, so the line is the normalized join of
the first two, and incidence of the third with the join is exactly the vanishing of the determinant
of the three coordinate triples.  And no support of the decoded minimum-word family contains three
points with vanishing coordinate determinant, which is
`PassantCodeQ13.MinimumWords.tripleConcurrenceIn_minimumSupportCodes_eq_zero_of_collinear`.  The
transport between the subtype presentation of the points and their displayed indices is the existing
concurrence dictionary.
-/

namespace PassantCodeQ13.MinimumWords.RowUniqueness

open RelativeConicArcs.PassantCodeQ13
open PassantCodeQ13.Equivariance
open PassantCodeQ13.MinimumWords
open PassantCodeQ13.PlaneJoin
open PassantCodeQ13.SymmetricSquare
open PassantCodeQ13.WeightTen

/-- The coordinate triple of an internal point is one of the displayed projective representatives. -/
private theorem coordinates_mem_projectiveTripleList (point : InternalPoint) :
    point.1 ∈ projectiveTripleList := by
  have point_internal : point.1 ∈ internalCoordinateList :=
    List.mem_toFinset.mp (by rw [internalCoordinateList_toFinset]; exact point.2)
  exact ((mem_internalCoordinateList_iff point.1).mp point_internal).1

/-- Three internal points incident with one passant line have vanishing coordinate determinant.  The
line is the normalized join of the first two, which are distinct, and pairing that join with the
third coordinate triple is the determinant of the three. -/
theorem coordinateDeterminant_eq_zero_of_incident {line : PassantLine}
    {first second third : InternalPoint} (first_ne_second : first ≠ second)
    (first_incident : Incident line first) (second_incident : Incident line second)
    (third_incident : Incident line third) :
    coordinateDeterminant first.1 second.1 third.1 = 0 := by
  have coordinates_ne : first.1 ≠ second.1 := fun equality => first_ne_second (Subtype.ext equality)
  obtain ⟨joinFactor, joinFactor_nonzero, rescaled⟩ := normalizeTriple_eq_scaleTriple
    (joinTriple_ne_zero (coordinates_mem_projectiveTripleList first)
      (coordinates_mem_projectiveTripleList second) coordinates_ne)
  have rescale_dot : ∀ point : Triple,
      dotTriple (scaleTriple joinFactor (joinTriple first.1 second.1)) point
        = joinFactor * dotTriple (joinTriple first.1 second.1) point := by
    intro point
    simp only [dotTriple, scaleTriple]
    ring
  have line_data : line.1 ∈ projectiveTripleList ∧
      dotTriple line.1 first.1 = 0 ∧ dotTriple line.1 second.1 = 0 := by
    refine ⟨?_, first_incident, second_incident⟩
    have line_mem := line.2
    rw [mem_passantCoordinates_iff] at line_mem
    exact line_mem.1
  have join_data : normalizeTriple (joinTriple first.1 second.1) ∈ projectiveTripleList ∧
      dotTriple (normalizeTriple (joinTriple first.1 second.1)) first.1 = 0 ∧
      dotTriple (normalizeTriple (joinTriple first.1 second.1)) second.1 = 0 := by
    refine ⟨normalizeTriple_mem_projectiveTripleList _, ?_, ?_⟩
    · rw [rescaled, rescale_dot, dotTriple_joinTriple_left, mul_zero]
    · rw [rescaled, rescale_dot, dotTriple_joinTriple_right, mul_zero]
  have line_eq : line.1 = normalizeTriple (joinTriple first.1 second.1) := by
    obtain ⟨_, _, uniqueness⟩ := existsUnique_incident
      (coordinates_mem_projectiveTripleList first) (coordinates_mem_projectiveTripleList second)
      coordinates_ne
    rw [uniqueness line.1 line_data, uniqueness _ join_data]
  have third_dot : dotTriple line.1 third.1 = 0 := third_incident
  rw [line_eq, rescaled, rescale_dot, dotTriple_joinTriple_eq_coordinateDeterminant] at third_dot
  exact eq_zero_of_mul_eq_zero_field _ _ joinFactor_nonzero third_dot

/-- Every geometric passant row has zero triple concurrence in the decoded minimum layer: three
distinct internal points of a passant line are collinear, and no member of the minimum-word family
contains three collinear points. -/
theorem geometric_rows_have_zero_triple_concurrence :
    GeometricRowsHaveZeroTripleConcurrence := by
  intro line first second third first_incident second_incident third_incident
    first_ne_second first_ne_third second_ne_third
  have vanishing : coordinateDeterminant first.1 second.1 third.1 = 0 :=
    coordinateDeterminant_eq_zero_of_incident first_ne_second first_incident second_incident
      third_incident
  obtain ⟨firstIndex, rfl⟩ := internalPointAt_bijective.surjective first
  obtain ⟨secondIndex, rfl⟩ := internalPointAt_bijective.surjective second
  obtain ⟨thirdIndex, rfl⟩ := internalPointAt_bijective.surjective third
  rw [internalPointAt_val, internalPointAt_val, internalPointAt_val] at vanishing
  rw [← indexedTripleConcurrence_eq_semantic, indexedTripleConcurrence,
    internalPointIndex_internalPointAt, internalPointIndex_internalPointAt,
    internalPointIndex_internalPointAt]
  exact tripleConcurrenceIn_minimumSupportCodes_eq_zero_of_collinear firstIndex.2 secondIndex.2
    thirdIndex.2
    (fun equality => first_ne_second (congrArg internalPointAt (Fin.ext equality)))
    (fun equality => first_ne_third (congrArg internalPointAt (Fin.ext equality)))
    (fun equality => second_ne_third (congrArg internalPointAt (Fin.ext equality)))
    vanishing

end PassantCodeQ13.MinimumWords.RowUniqueness
