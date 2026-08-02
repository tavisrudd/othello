import RelativeConicArcs.PassantCodeQ13.AssociationAlgebra

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

end RelativeConicArcs.PassantCodeQ13
