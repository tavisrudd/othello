import PassantCodeQ13.Equivariance.MinimumLayerCounts

/-!
# The fused pair-color split at the six representative pairs

A pair of distinct internal points of pair concurrence six is separated by counting the points whose
pair concurrences with the two given points are both seven; the manuscript's splitter rests on that
count being two or four.  The projective action leaves the decoded minimum-word family invariant and
is transitive on the ordered pairs of distinct internal points that share a value of the normalized
polar parameter, so the count is constant on those six classes and the statement is decided at the
six displayed representative pairs.

The check below runs over those six pairs and, for each, over the 78 displayed indices, counting
over the displayed encoded supports; it is discharged by kernel reduction.  The semantic statement
is obtained from it by the transports of
`PassantCodeQ13.Equivariance.MinimumLayerCounts`.
-/

namespace PassantCodeQ13.Equivariance

open Finset
open RelativeConicArcs
open RelativeConicArcs.PassantCodeQ13
open PassantCodeQ13.MinimumWords
open PassantCodeQ13.MinimumWords.RowUniqueness
open PassantCodeQ13.WeightTen

/-- The displayed representative pairs, as pairs of displayed indices. -/
def representativeIndexPairs : List (Fin 78 × Fin 78) :=
  polarClassRepresentatives.map fun representative =>
    (Fin.ofNat 78 representative.1, Fin.ofNat 78 representative.2)

/-- The points whose pair concurrences with two displayed indices are both seven. -/
def fusedMiddles (first second : Fin 78) : Finset (Fin 78) :=
  Finset.univ.filter fun middle =>
    pairConcurrenceIn minimumWordSupports first.1 middle.1 = 7 ∧
      pairConcurrenceIn minimumWordSupports middle.1 second.1 = 7

/-- At each displayed representative pair, concurrence six forces the fused count to be two or
four. -/
def representativeFusedCheck : Bool :=
  representativeIndexPairs.all fun pair =>
    decide (pairConcurrenceIn minimumWordSupports pair.1.1 pair.2.1 = 6 →
      (fusedMiddles pair.1 pair.2).card = 2 ∨ (fusedMiddles pair.1 pair.2).card = 4)

/-- The six representative pairs pass the fused-color check.  Decided over the six pairs and the
78 displayed indices. -/
theorem representativeFusedCheck_eq_true : representativeFusedCheck = true := by
  decide +kernel

/-- The semantic pair concurrence of two indexed internal points is the count over the displayed
encoded supports. -/
private theorem pairConcurrence_indexed (first second : Fin 78) :
    ConicPassantCode.pairConcurrence semanticMinimumSupports (internalPointAt first)
        (internalPointAt second) = pairConcurrenceIn minimumWordSupports first.1 second.1 := by
  rw [← indexedPairConcurrence_eq_semantic]
  exact indexedPairConcurrence_eq_pairConcurrenceIn first second

/-- The fused-color split holds at each of the six displayed representative pairs. -/
theorem representativePair_fusedSplit {pair : InternalPoint × InternalPoint}
    (mem : pair ∈ representativePairs)
    (colorSix : ConicPassantCode.pairConcurrence semanticMinimumSupports pair.1 pair.2 = 6) :
    (Finset.univ.filter fun middle =>
        ConicPassantCode.pairConcurrence semanticMinimumSupports pair.1 middle = 7 ∧
          ConicPassantCode.pairConcurrence semanticMinimumSupports middle pair.2 = 7).card = 2 ∨
      (Finset.univ.filter fun middle =>
        ConicPassantCode.pairConcurrence semanticMinimumSupports pair.1 middle = 7 ∧
          ConicPassantCode.pairConcurrence semanticMinimumSupports middle pair.2 = 7).card = 4 := by
  obtain ⟨representative, representative_mem, rfl⟩ := List.mem_map.mp mem
  have index_mem : (Fin.ofNat 78 representative.1, Fin.ofNat 78 representative.2) ∈
      representativeIndexPairs := List.mem_map_of_mem representative_mem
  have checked := List.all_eq_true.mp representativeFusedCheck_eq_true _ index_mem
  simp only [decide_eq_true_eq] at checked
  have colorSix_indexed :
      pairConcurrenceIn minimumWordSupports (Fin.ofNat 78 representative.1).1
        (Fin.ofNat 78 representative.2).1 = 6 := by
    rw [← pairConcurrence_indexed]
    exact colorSix
  have middles : (Finset.univ.filter fun middle =>
      ConicPassantCode.pairConcurrence semanticMinimumSupports
          (internalPointAt (Fin.ofNat 78 representative.1)) middle = 7 ∧
        ConicPassantCode.pairConcurrence semanticMinimumSupports middle
          (internalPointAt (Fin.ofNat 78 representative.2)) = 7).card =
      (fusedMiddles (Fin.ofNat 78 representative.1) (Fin.ofNat 78 representative.2)).card := by
    rw [card_filter_univ_internalPoint]
    refine congrArg Finset.card (Finset.filter_congr fun index _ => ?_)
    rw [pairConcurrence_indexed, pairConcurrence_indexed]
  rw [middles]
  exact checked colorSix_indexed

end PassantCodeQ13.Equivariance
