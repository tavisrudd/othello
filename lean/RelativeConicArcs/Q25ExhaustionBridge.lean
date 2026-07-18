import RelativeConicArcs.Q25ResidualCoverBridge
import RelativeConicArcs.Q25ResidualEquality

/-!
# Semantic bridge for the C151 exhaustion layer

Exhaustion needs two facts that the committed `≥ 32` layer does not state.

The first is a threshold-generic form of `card_legalOrbitSet_ge_32`.  Every generated class
certificate pins its `card_le` field at `32`, but its `fresh`, `secants`, and `carrier` fields are
threshold-free, and `toReflectedMaskCertificate` derives soundness from those three alone.  So the
committed certificates are reusable at `33` against a fresh cardinality `decide` on the same
literal mask, without editing `Q25MinimumMask` and invalidating the generated closure.

The second is that a checked row transport is an element of the certified residual action, not
merely an eight-point permutation.  `ResidualParameter` is a pair of coordinates with nonzero
imaginary part, which is exactly what `TransportValid` supplies, so a valid payload whose canonical
representative is a minimizer places its source row in that representative's residual orbit.
-/

namespace RelativeConicArcs
namespace Q25ExhaustionBridge

open Q25Coordinates Q25PairCertificate Q25OrbitDecomposition Q25MinimumChecker Q25MinimumMask
  Q25ResidualAction Q25ResidualCoverData Q25ResidualEquality Q25ResidualMinimumOrbits

set_option maxHeartbeats 300000000
set_option maxRecDepth 100000

/-- Sound mask bits inject into the legal-pair set at any threshold.  This is
`card_legalOrbitSet_ge_32` with the bound left free; the committed leaves supply `hsound` and a
fresh `decide` on the literal mask supplies `hcard`. -/
theorem card_legalOrbitSet_ge_of_sound {n : ℕ} {S : Finset Idx25} {mask : OrbitMask}
    (hInv : IsConjInvariant S)
    (hsound : ∀ m : Fin 310, maskBit mask m = true → ReflectedLegal S (orbitCodeOfNumber m))
    (hcard : n ≤ (maskOrbitSet mask).card) :
    n ≤ (legalOrbitSet S).card := by
  apply hcard.trans
  apply Finset.card_le_card
  intro o ho
  have hbit : maskBit mask (orbitNumberFin o) = true :=
    (Finset.mem_filter.mp ho).2
  have hreflected : ReflectedLegal S o := by
    simpa [orbitNumberFin] using hsound (orbitNumberFin o) hbit
  exact Finset.mem_filter.mpr
    ⟨Finset.mem_univ o, (legalPair_iff_reflectedLegal hInv o).2 hreflected⟩

/-- A checked transport exhibits its source row as a residual-action image of the canonical
representative it names. -/
theorem ValidRowPayload.residualMapsTo_canonical {b : Fin 310} {p : ValidRowPayload}
    (h : p.TransportValid b) :
    ResidualMapsTo (rowConfig b p.c) p.canonicalConfig :=
  ⟨(⟨p.y, h.1⟩, ⟨p.z, h.2.1⟩), ValidRowPayload.map_eq_canonicalConfig h⟩

/-- The minimizer branch of the exhaustion dispatch: a valid payload naming one of the five
certified representatives places its source row in `minimumOrbitUnion`. -/
theorem isMinimumResidualClass_of_transport {b : Fin 310} {p : ValidRowPayload}
    (h : p.TransportValid b)
    (hmin : p.canonicalConfig = minimumRow0065 ∨ p.canonicalConfig = minimumRow0267 ∨
      p.canonicalConfig = minimumRow0445 ∨ p.canonicalConfig = minimumRow0772 ∨
      p.canonicalConfig = minimumRow1002) :
    IsMinimumResidualClass (rowConfig b p.c) := by
  have hmaps := ValidRowPayload.residualMapsTo_canonical h
  rcases hmin with hm | hm | hm | hm | hm <;> rw [hm] at hmaps
  · exact Or.inl hmaps
  · exact Or.inr (Or.inl hmaps)
  · exact Or.inr (Or.inr (Or.inl hmaps))
  · exact Or.inr (Or.inr (Or.inr (Or.inl hmaps)))
  · exact Or.inr (Or.inr (Or.inr (Or.inr hmaps)))

/-- The per-row exhaustion terminal, in the form the generated conclusion leaves will produce.
Combined with `isMinimumResidualClass_iff_mem_minimumOrbitUnion`, a row attaining `32` lies in the
`1600`-element union of the five certified orbits. -/
theorem mem_minimumOrbitUnion_of_card_eq_32 {S : Finset Idx25}
    (h : 33 ≤ (legalOrbitSet S).card ∨ IsMinimumResidualClass S)
    (hcard : (legalOrbitSet S).card = 32) :
    S ∈ Q25ResidualMinimumOrbits.minimumOrbitUnion := by
  rcases h with hge | hmin
  · rw [hcard] at hge
    omega
  · exact (isMinimumResidualClass_iff_mem_minimumOrbitUnion S).1 hmin

end Q25ExhaustionBridge
end RelativeConicArcs
