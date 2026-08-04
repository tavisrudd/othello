import RelativeConicArcs.PassantCodeQ13.AssociationAlgebra
import RelativeConicArcs.PassantCodeQ13.PencilJoins

/-!
# Reconstruction from the minimum-support hypergraph

The input to reconstruction is an unlabeled finite hypergraph on the 78 code coordinates.  Pair
and triple concurrence are computed from that hypergraph.  A recovered passant row is a seven-set
whose pairs have a passant join and whose triples have concurrence zero.

`MinimumLayerCertificate` is the semantic interface for the finite leaves: it requires exact
equality with the weight-twelve support layer, its cardinality, recovery of the six elliptic
relations, and equality of the reconstructed and geometric row families.  Consequently a consumer
cannot obtain a reconstruction theorem from hashes or from a sampled list alone.
-/

namespace RelativeConicArcs.PassantCodeQ13

open Finset

/-- Two internal points have a passant join when a passant line contains both. -/
def HasPassantJoin (first second : InternalPoint) : Prop :=
  ∃ line : PassantLine, Incident line first ∧ Incident line second

instance : DecidableRel HasPassantJoin := fun first second =>
  if witness : (Finset.univ.filter fun line : PassantLine =>
      Incident line first ∧ Incident line second).Nonempty then
    isTrue (by
      obtain ⟨line, lineMem⟩ := witness
      simp only [Finset.mem_filter, Finset.mem_univ, true_and] at lineMem
      exact ⟨line, lineMem⟩)
  else
    isFalse (by
      rintro ⟨line, lineIncidence⟩
      exact witness ⟨line, by simp [lineIncidence]⟩)

/-- A finite vertex set has all its distinct pairs joined by passants. -/
def IsPassantClique (vertices : Finset InternalPoint) : Prop :=
  ∀ first ∈ vertices, ∀ second ∈ vertices,
    first ≠ second → HasPassantJoin first second

/-- The seven-subsets selected intrinsically from a proposed minimum-support hypergraph. -/
noncomputable def reconstructedRows (minimumSupports : Finset (Finset InternalPoint)) :
    Finset (Finset InternalPoint) :=
  by
    classical
    exact (Finset.univ.powersetCard 7).filter fun vertices =>
      IsPassantClique vertices ∧
        ∀ triple ∈ vertices.powersetCard 3,
          ∀ first ∈ triple, ∀ second ∈ triple, ∀ third ∈ triple,
            first ≠ second → first ≠ third → second ≠ third →
              ConicPassantCode.tripleConcurrence minimumSupports first second third = 0

/-- Coordinate permutations preserving a finite support hypergraph. -/
def PreservesSupportHypergraph (minimumSupports : Finset (Finset InternalPoint))
    (permutation : Equiv.Perm InternalPoint) : Prop :=
  minimumSupports.image (Finset.image permutation) = minimumSupports

/-- Exact interface identifying all support-hypergraph automorphisms with a faithful finite group
action.  For the concrete theorem, `GroupModel` is the symmetric-square permutation model of
`PGL(2,13)` and has cardinality 2184. -/
structure CoordinateAutomorphismIdentification
    (minimumSupports : Finset (Finset InternalPoint))
    (GroupModel : Type*) [Group GroupModel] [Fintype GroupModel] where
  action : GroupModel →* Equiv.Perm InternalPoint
  faithful : Function.Injective action
  group_card : Fintype.card GroupModel = 2184
  preserves_iff_in_range : ∀ permutation : Equiv.Perm InternalPoint,
    PreservesSupportHypergraph minimumSupports permutation ↔
      permutation ∈ Set.range action

/-- Exact semantic interface for a complete minimum-layer and reconstruction certificate. -/
structure MinimumLayerCertificate
    (minimumSupports : Finset (Finset InternalPoint)) where
  exact_weight_layer : minimumSupports = ConicPassantCode.supportsOfWeight Incident 12
  support_count : minimumSupports.card = 364
  support_sizes : ∀ support ∈ minimumSupports, support.card = 12
  concurrence_recovers_relations : ConcurrenceRecoversRelations minimumSupports
  rows_recovered : reconstructedRows minimumSupports = ConicPassantCode.rowSupports Incident

/-- A complete certificate recovers exactly the geometric passant-row family. -/
theorem reconstructedRows_eq_passantRows
    {minimumSupports : Finset (Finset InternalPoint)}
    (certificate : MinimumLayerCertificate minimumSupports) :
    reconstructedRows minimumSupports = ConicPassantCode.rowSupports Incident :=
  certificate.rows_recovered

/-- A complete certificate identifies its listed supports with all weight-twelve code supports. -/
theorem minimumSupports_eq_weightTwelveLayer
    {minimumSupports : Finset (Finset InternalPoint)}
    (certificate : MinimumLayerCertificate minimumSupports) :
    minimumSupports = ConicPassantCode.supportsOfWeight Incident 12 :=
  certificate.exact_weight_layer

/-- Every passant row in the normalized `q = 13` model contains seven internal points. -/
theorem passantRow_card (line : PassantLine) :
    (ConicPassantCode.rowSupport Incident line).card = 7 :=
  card_internalPoints_on line

/-- A complete transport for admissible seven-sets identifies the reconstructed row family.

The first finite input checks the zero-concurrence signature of every geometric row.  The second
classifies every seven-set satisfying the intrinsic passant-clique and zero-triple conditions as a
geometric row.  The theorem packages the two directions of the reconstruction equality. -/
theorem reconstructedRows_eq_passantRows_of_sevenSet_transport
    (minimumSupports : Finset (Finset InternalPoint))
    (geometric_triples_zero : ∀ line : PassantLine,
      ∀ first second third : InternalPoint,
        Incident line first → Incident line second → Incident line third →
          first ≠ second → first ≠ third → second ≠ third →
          ConicPassantCode.tripleConcurrence minimumSupports first second third = 0)
    (admissible_seven_set_is_row : ∀ vertices : Finset InternalPoint,
      vertices.card = 7 → IsPassantClique vertices →
      (∀ triple ∈ vertices.powersetCard 3,
        ∀ first ∈ triple, ∀ second ∈ triple, ∀ third ∈ triple,
          first ≠ second → first ≠ third → second ≠ third →
            ConicPassantCode.tripleConcurrence minimumSupports first second third = 0) →
        vertices ∈ ConicPassantCode.rowSupports Incident) :
    reconstructedRows minimumSupports = ConicPassantCode.rowSupports Incident := by
  classical
  ext vertices
  constructor
  · intro vertices_mem
    simp only [reconstructedRows, mem_filter, mem_powersetCard] at vertices_mem
    obtain ⟨⟨_, vertices_card⟩, vertices_clique, vertices_zero⟩ := vertices_mem
    apply admissible_seven_set_is_row vertices vertices_card vertices_clique
    intro triple triple_mem
    exact vertices_zero triple (Finset.mem_powersetCard.mp triple_mem)
  · intro vertices_mem
    obtain ⟨line, _, rfl⟩ := Finset.mem_image.mp vertices_mem
    simp only [reconstructedRows, mem_filter, mem_powersetCard]
    refine ⟨⟨subset_univ _, passantRow_card line⟩, ?_, ?_⟩
    · intro first first_mem second second_mem first_ne_second
      exact ⟨line, (ConicPassantCode.mem_rowSupport Incident line first).mp first_mem,
        (ConicPassantCode.mem_rowSupport Incident line second).mp second_mem⟩
    · intro triple triple_mem first first_mem second second_mem third third_mem
        first_ne_second first_ne_third second_ne_third
      exact geometric_triples_zero line first second third
        ((ConicPassantCode.mem_rowSupport Incident line first).mp
          (triple_mem.1 first_mem))
        ((ConicPassantCode.mem_rowSupport Incident line second).mp
          (triple_mem.1 second_mem))
        ((ConicPassantCode.mem_rowSupport Incident line third).mp
          (triple_mem.1 third_mem)) first_ne_second first_ne_third second_ne_third

end RelativeConicArcs.PassantCodeQ13
