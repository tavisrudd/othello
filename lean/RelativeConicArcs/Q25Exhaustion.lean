import RelativeConicArcs.Q25ExhaustionDispatchData.All

/-!
# C151 equality-orbit exhaustion

The generated exhaustion tree gives, for every normalized row containing orbit number `5`, the
disjunction `33 ≤ legal orbits ∨ the row is one of the five certified minimizer classes`.  A row
attaining `32` therefore cannot take the left branch, so it lies in the `1600`-element union of the
five certified residual orbits.

Together with `normalized_card_legalOrbitSet_ge_32` this closes the normalized-row half of the exact
Q25 minimum: `32` is attained, and exactly on `minimumOrbitUnion`.
-/

namespace RelativeConicArcs
namespace Q25Exhaustion

open Q25Coordinates Q25MinimumMask Q25ResidualCoverData Q25ResidualEquality
  Q25ResidualMinimumOrbits Q25ExhaustionDispatchData

set_option maxHeartbeats 300000000
set_option maxRecDepth 100000

/-- Every normalized row attaining the minimum `32` lies in the union of the five certified
minimizer orbits. -/
theorem mem_minimumOrbitUnion_of_normalized_card_eq_32 (b c : Fin 310)
    (hb : 5 < b.val) (hbc : b.val < c.val) (hraw : RawCap (rowConfig b c))
    (hcard : (legalOrbitSet (rowConfig b c)).card = 32) :
    rowConfig b c ∈ minimumOrbitUnion :=
  Q25ExhaustionBridge.mem_minimumOrbitUnion_of_card_eq_32
    (concludeNormalizedRowExhaustion b c hb hbc hraw) hcard

/-- The exhaustion statement in its contrapositive form: a normalized row outside the five certified
orbits carries strictly more than the minimum. -/
theorem card_ge_33_of_not_mem_minimumOrbitUnion (b c : Fin 310)
    (hb : 5 < b.val) (hbc : b.val < c.val) (hraw : RawCap (rowConfig b c))
    (hmem : rowConfig b c ∉ minimumOrbitUnion) :
    33 ≤ (legalOrbitSet (rowConfig b c)).card := by
  rcases concludeNormalizedRowExhaustion b c hb hbc hraw with hge | hmin
  · exact hge
  · exact absurd ((isMinimumResidualClass_iff_mem_minimumOrbitUnion _).1 hmin) hmem

end Q25Exhaustion
end RelativeConicArcs
