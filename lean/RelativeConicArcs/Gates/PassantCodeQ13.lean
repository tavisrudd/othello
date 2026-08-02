import RelativeConicArcs.PassantCodeQ13.Rank
import RelativeConicArcs.PassantCodeQ13.WeightEight
import RelativeConicArcs.PassantCodeQ13.WeightTen
import RelativeConicArcs.PassantCodeQ13.Reconstruction
import RelativeConicArcs.PassantCodeQ13.LogicalSpine

/-!
# Semantic gate for the passant incidence code over `ZMod 13`

This gate exports the normalized conic incidence model, the conditional rank-to-dimension theorem,
the finite tangent-graph closure checks used in the weight-eight reduction, and the exact
minimum-layer reconstruction interface.

The shared library does not contain the large q=13 weight-ten or minimum-word leaves.  Those leaves
belong to a separate certificate package.  In particular, this gate alone does not prove minimum
distance twelve, enumerate 364 minimum words, or identify the full coordinate-permutation group.
It states the semantic propositions that such an aggregate must establish and the symbolic
consequences that follow from them.  `LogicalSpine` proves the parity-profile,
association-kernel, and four-anchor deductions without native evaluation; certificate leaves are
reserved for their bounded geometric inputs.
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

/-- After projective normalization, row parity saturates the seven passant pencils of a
weight-eight word.  If the classical arc/tangent lemma supplies pairwise passant joins and tangent
holonomy one on the other seven support points, the semantic cyclic-graph identification and its
five-clique bound give a contradiction. -/
theorem weightEight_semantic_transport
    (word : InternalPoint → ZMod 2) (word_mem : word ∈ passantCode)
    (weight : CodingBridge.hammingWeight word = 8)
    (base_mem : WeightEight.basePoint ∈ CodingBridge.hammingSupport word)
    (tangent_identity : ∀ first ∈ CodingBridge.hammingSupport word,
      first ≠ WeightEight.basePoint →
      ∀ second ∈ CodingBridge.hammingSupport word,
        second ≠ WeightEight.basePoint → first ≠ second →
          WeightEight.PassantJoin first second ∧
            WeightEight.TangentHolonomyOne WeightEight.basePoint first second) : False :=
  WeightEight.no_normalized_weightEight_codeword_of_tangent_holonomy
    word word_mem weight base_mem tangent_identity

/-- The weight-ten arithmetic reduction belongs to the human proof spine, not a certificate leaf. -/
theorem weightTen_profile_reduction
    (secantNeighbors : ℕ) (secantNeighbors_even : Even secantNeighbors)
    (seven_nonempty_fibres : 7 ≤ 9 - secantNeighbors) :
    secantNeighbors = 0 ∨ secantNeighbors = 2 :=
  LogicalSpine.weightTen_secant_count_is_zero_or_two secantNeighbors secantNeighbors_even
    seven_nonempty_fibres

/-- The isolated weight-ten case has one three-point fibre and six singleton fibres. -/
theorem weightTen_isolated_fibre_profile
    (fibreSize : Fin 7 → ℕ)
    (positive : ∀ index, 0 < fibreSize index)
    (odd : ∀ index, Odd (fibreSize index))
    (total : ∑ index, fibreSize index = 9) :
    ∃ exceptional, fibreSize exceptional = 3 ∧
      ∀ index, index ≠ exceptional → fibreSize index = 1 :=
  LogicalSpine.seven_positive_odd_fibres_sum_nine fibreSize positive odd total

/-- The cycle weight-ten case has seven singleton passant fibres. -/
theorem weightTen_cycle_fibre_profile
    (fibreSize : Fin 7 → ℕ)
    (positive : ∀ index, 0 < fibreSize index)
    (total : ∑ index, fibreSize index = 7) :
    ∀ index, fibreSize index = 1 :=
  LogicalSpine.seven_positive_fibres_sum_seven fibreSize positive total

/-- Every supported point of an arbitrary weight-ten codeword has one of the two exhaustive
passant-pencil profiles used by the isolated and cycle certificate leaves. -/
theorem arbitrary_weightTen_profile_transport
    (word : InternalPoint → ZMod 2) (word_mem : word ∈ passantCode)
    (weight : CodingBridge.hammingWeight word = 10)
    (base : InternalPoint) (base_mem : base ∈ CodingBridge.hammingSupport word) :
    WeightTen.WeightTenPencilProfile (CodingBridge.hammingSupport word) base :=
  WeightTen.arbitrary_weightTen_word_has_pencil_profile word word_mem weight base base_mem

end RelativeConicArcs.Gates.PassantCodeQ13
