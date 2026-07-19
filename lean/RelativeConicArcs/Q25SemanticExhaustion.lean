import RelativeConicArcs.Q25MinimumClassification
import RelativeConicArcs.Q25Exhaustion

/-!
# C331 semantic equality-orbit exhaustion

`Q25Exhaustion` places every *normalized row* attaining `32` in the `1600`-element union of the five
certified minimizer orbits, and `Q25MinimumClassification` carries the `≥ 32` bound down to every
invariant eight-arc in `PG(2,25)` with exactly two fixed points.  This module lifts exhaustion along
the same two normalizations, closing the asymmetry between the two halves.

The lift consumes the threshold-free normalization steps `exists_base_normalizedConfig` and
`exists_residual_rowConfig` together with the cardinality transports
`card_legalOrbitSet_liftMapIdx` and `card_legalOrbitSet_residual`, which are equalities and so run in
the direction that carries `card = 32` *down* to a normalized row.  Two facts do the remaining work:

* the semantic count is pinned to the indexed one by a sandwich — the indexed legal orbits inject
  into the semantic legal pairs, and the indexed count is already known to be at least `32`, so a
  semantic count of `32` forces the indexed count to be `32` as well; and
* `minimumOrbitUnion` is a union of full residual orbits, so the residual normalization step can be
  absorbed and only the base collineation survives into the statement.
-/

namespace RelativeConicArcs
namespace Q25SemanticExhaustion

open Q25Coordinates Q25PairCertificate Q25Normalization Q25BaseNormalization
  Q25MinimumMask Q25ResidualAction Q25ResidualGroup Q25ResidualEquality
  Q25ResidualMinimumOrbits Q25ResidualCoverData Q25MinimumClassification Q25Exhaustion
  Q25PairResult Q25OrbitDecomposition QuadraticGlobalCount Configuration FiniteFields
open scoped Pointwise

set_option maxHeartbeats 300000000
set_option maxRecDepth 100000

/-! ## Residual transport of the certified minimizer union

`minimumOrbitUnion` is a union of five full residual orbits, so it is invariant under the order-`400`
residual action.  These three lemmas record that invariance in the form the lift needs: a set mapping
onto a member of the union is itself a member.  They live here rather than in `Q25ResidualEquality`
because that module is imported by the generated exhaustion trees, whose re-elaboration is measured
in hours. -/

theorem residualMapsTo_trans {A B D : Finset Idx25}
    (hAB : ResidualMapsTo A B) (hBD : ResidualMapsTo B D) : ResidualMapsTo A D := by
  obtain ⟨g, hg⟩ := hAB
  obtain ⟨h, hh⟩ := hBD
  refine ⟨h * g, ?_⟩
  rw [← smul_eq_map] at hg hh ⊢
  rw [mul_smul, hg, hh]

theorem isMinimumResidualClass_of_residualMapsTo {A B : Finset Idx25}
    (hAB : ResidualMapsTo A B) (hB : IsMinimumResidualClass B) : IsMinimumResidualClass A := by
  rcases hB with h | h | h | h | h
  · exact Or.inl (residualMapsTo_trans hAB h)
  · exact Or.inr (Or.inl (residualMapsTo_trans hAB h))
  · exact Or.inr (Or.inr (Or.inl (residualMapsTo_trans hAB h)))
  · exact Or.inr (Or.inr (Or.inr (Or.inl (residualMapsTo_trans hAB h))))
  · exact Or.inr (Or.inr (Or.inr (Or.inr (residualMapsTo_trans hAB h))))

/-- The union of the five certified minimizer orbits is invariant under the residual action. -/
theorem mem_minimumOrbitUnion_of_residualMapsTo {A B : Finset Idx25}
    (hAB : ResidualMapsTo A B) (hB : B ∈ minimumOrbitUnion) : A ∈ minimumOrbitUnion :=
  (isMinimumResidualClass_iff_mem_minimumOrbitUnion A).1
    (isMinimumResidualClass_of_residualMapsTo hAB
      ((isMinimumResidualClass_iff_mem_minimumOrbitUnion B).2 hB))

/-! ## Exhaustion through the residual normalization -/

/-- Every normalized configuration attaining `32` lies in the `1600`-element union of the five
certified minimizer orbits.  The residual normalization is absorbed, so no map survives here. -/
theorem normalized_mem_minimumOrbitUnion_of_card_eq_32 {a b c : OrbitCode}
    (hab : a ≠ b) (hac : a ≠ c) (hbc : b ≠ c)
    (hraw : RawCap (normalizedConfig a b c))
    (hcard : (legalOrbitSet (normalizedConfig a b c)).card = 32) :
    normalizedConfig a b c ∈ minimumOrbitUnion := by
  obtain ⟨y, z, hy, hz, u, v, hu, huv, hmap⟩ := exists_residual_rowConfig hab hac hbc hraw
  have hrowRaw : RawCap (rowConfig u v) := rawCap_rowConfig_of_residual hraw hmap
  have hrowCard : (legalOrbitSet (rowConfig u v)).card = 32 := by
    rw [← card_legalOrbitSet_residual y z hy hz hmap hraw hrowRaw]
    exact hcard
  exact mem_minimumOrbitUnion_of_residualMapsTo ⟨(⟨y, hy⟩, ⟨z, hz⟩), hmap⟩
    (mem_minimumOrbitUnion_of_normalized_card_eq_32 u v hu huv hrowRaw hrowCard)

/-! ## Exhaustion through the base normalization -/

/-- Every indexed invariant exceptional-profile eight-cap attaining `32` is carried into the
`1600`-element union by a base-field collineation. -/
theorem indexed_exists_base_normalization_mem_minimumOrbitUnion {S : Finset Idx25}
    (hArc : RawCap S) (hInv : IsConjInvariant S)
    (hcard : S.card = 8) (hfixed : (fixedPart S).card = 2)
    (heq : (legalOrbitSet S).card = 32) :
    ∃ g : Vec5 ≃ₗ[F5] Vec5, S.map (liftMapIdx g).toEmbedding ∈ minimumOrbitUnion := by
  obtain ⟨g, a, b, c, hab, hac, hbc, hnorm⟩ := exists_base_normalizedConfig hInv hcard hfixed
  have hTArc : RawCap (S.map (liftMapIdx g).toEmbedding) := (rawCap_liftMapIdx g S).2 hArc
  have hnormArc : RawCap (normalizedConfig a b c) := by rwa [hnorm] at hTArc
  have hnormCard : (legalOrbitSet (normalizedConfig a b c)).card = 32 := by
    rw [← hnorm, ← card_legalOrbitSet_liftMapIdx g (C := S)
      (D := S.map (liftMapIdx g).toEmbedding) rfl hArc hTArc]
    exact heq
  refine ⟨g, ?_⟩
  rw [hnorm]
  exact normalized_mem_minimumOrbitUnion_of_card_eq_32 hab hac hbc hnormArc hnormCard

/-! ## The semantic terminals -/

/-- A semantic count of `32` pins the indexed count to `32`.  The indexed legal orbits inject into
the semantic legal pairs, and the indexed count is already at least `32`. -/
theorem card_legalOrbitSet_eq_32_of_globalLegalPairs_eq_32
    (C : Finset Point25)
    (hArc : Arc (L := Point25) C)
    (hInv : FiniteGeom.BaerCompletion.IsInvariant
      (QuadraticFrobenius.incidence F5 K25 Q25PairResult.gf25_degree) C)
    (hcard : C.card = 8)
    (hfixed : (QuadraticLineCounting.fixedArcPoints F5 K25 C).card = 2)
    (heq : (globalLegalPairs F5 K25 Q25PairResult.gf25_degree C).card = 32) :
    (legalOrbitSet (indexSet C)).card = 32 := by
  have hlower := indexed_f2_card_legalOrbitSet_ge_32 (rawCap_indexSet C hArc)
    (isConjInvariant_indexSet C hInv) (card_indexSet C hcard) (card_fixedPart_indexSet C hfixed)
  have hupper := card_legalOrbitSet_le_card_globalLegalPairs C hArc
  rw [heq] at hupper
  omega

/-- **Projective exceptional-profile exhaustion.** Every invariant eight-arc in `PG(2,25)` with
exactly two fixed points attaining the minimum `32` normalizes, under a base-field collineation, into
the `1600`-element union of the five certified minimizer orbits. -/
theorem f2_normalizes_into_minimumOrbitUnion
    (C : Finset Point25)
    (hArc : Arc (L := Point25) C)
    (hInv : FiniteGeom.BaerCompletion.IsInvariant
      (QuadraticFrobenius.incidence F5 K25 Q25PairResult.gf25_degree) C)
    (hcard : C.card = 8)
    (hfixed : (QuadraticLineCounting.fixedArcPoints F5 K25 C).card = 2)
    (heq : (globalLegalPairs F5 K25 Q25PairResult.gf25_degree C).card = 32) :
    ∃ g : Vec5 ≃ₗ[F5] Vec5, (indexSet C).map (liftMapIdx g).toEmbedding ∈ minimumOrbitUnion :=
  indexed_exists_base_normalization_mem_minimumOrbitUnion (rawCap_indexSet C hArc)
    (isConjInvariant_indexSet C hInv) (card_indexSet C hcard) (card_fixedPart_indexSet C hfixed)
    (card_legalOrbitSet_eq_32_of_globalLegalPairs_eq_32 C hArc hInv hcard hfixed heq)

/-- The contrapositive form: an invariant eight-arc whose every base normalization avoids the five
certified orbits carries at least `33` semantic legal conjugate-pair extensions. -/
theorem f2_card_globalLegalPairs_ge_33_of_not_normalizing
    (C : Finset Point25)
    (hArc : Arc (L := Point25) C)
    (hInv : FiniteGeom.BaerCompletion.IsInvariant
      (QuadraticFrobenius.incidence F5 K25 Q25PairResult.gf25_degree) C)
    (hcard : C.card = 8)
    (hfixed : (QuadraticLineCounting.fixedArcPoints F5 K25 C).card = 2)
    (hout : ∀ g : Vec5 ≃ₗ[F5] Vec5,
      (indexSet C).map (liftMapIdx g).toEmbedding ∉ minimumOrbitUnion) :
    33 ≤ (globalLegalPairs F5 K25 Q25PairResult.gf25_degree C).card := by
  by_contra hlt
  have hge := f2_card_globalLegalPairs_ge_32 C hArc hInv hcard hfixed
  have heq : (globalLegalPairs F5 K25 Q25PairResult.gf25_degree C).card = 32 := by omega
  obtain ⟨g, hg⟩ := f2_normalizes_into_minimumOrbitUnion C hArc hInv hcard hfixed heq
  exact hout g hg

end Q25SemanticExhaustion
end RelativeConicArcs
