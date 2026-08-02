import RelativeConicArcs.PassantCodeQ13.Rank
import RelativeConicArcs.PassantCodeQ13.WeightEight
import RelativeConicArcs.PassantCodeQ13.Reconstruction

/-!
# Semantic gate for the passant incidence code over `ZMod 13`

This gate exports the normalized conic incidence model, the conditional rank-to-dimension theorem,
the finite tangent-graph closure checks used in the weight-eight reduction, and the exact
minimum-layer reconstruction interface.

The shared library does not contain the large q=13 weight-ten or minimum-word leaves.  Those leaves
belong to a separate certificate package.  In particular, this gate alone does not prove minimum
distance twelve, enumerate 364 minimum words, or identify the full coordinate-permutation group.
It states the semantic propositions that such an aggregate must establish and the symbolic
consequences that follow from them.
-/

namespace RelativeConicArcs.Gates.PassantCodeQ13

open RelativeConicArcs.PassantCodeQ13

/-- The shared q=13 geometry fixes 78 code coordinates and 78 passant checks. -/
theorem incidence_shape :
    Fintype.card InternalPoint = 78 ∧ Fintype.card PassantLine = 78 :=
  ⟨internalPoint_card, passantLine_card⟩

/-- A checked rank-42 certificate yields the paper's dimension value 36. -/
theorem dimension_from_rank_certificate
    (certificate : IncidenceMapHasRankFortyTwo) :
    Module.finrank (ZMod 2) passantCode = 36 :=
  passantCode_finrank_eq_thirtySix certificate

/-- The tangent graph has seventy four-cliques, each with one extension, producing fourteen
maximal five-cliques. -/
theorem tangent_graph_certificate :
    WeightEight.fourCliques.length = 70 ∧
      WeightEight.fourCliques.all
        (fun members => (WeightEight.commonNeighbors members).length == 1) = true ∧
      WeightEight.fiveCliqueCodes.length = 14 ∧
      WeightEight.fourCliques.all (fun members =>
        (WeightEight.commonNeighbors members).all fun candidate =>
          (WeightEight.commonNeighbors (candidate :: members)).isEmpty) = true :=
  ⟨WeightEight.fourCliques_length, WeightEight.fourClique_unique_extension_check,
    WeightEight.fiveCliqueCodes_length, WeightEight.fiveClique_maximality_check⟩

end RelativeConicArcs.Gates.PassantCodeQ13
