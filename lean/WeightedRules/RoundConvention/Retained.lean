import WeightedRules.TableProgram
import WeightedRules.ChainDistance

/-!
# Grounding correspondence for the hand-written programs

The four-vertex distance program and the six-vertex chain are transcribed by
hand from their relational sources, with the coordinate layout stated in
their docstrings: relations in declaration order, row-major with the last
argument fastest, and the multiplicative unit last. The producer grounds the
same two sources and emits its inputs and product triples as tables; here
the imported programs are compared with the hand-written ones coordinate by
coordinate and rule by rule, by kernel reduction. Rule lists are compared as
lists, so the producer's product order is part of the correspondence.
-/

namespace WeightedRules.RoundConvention

set_option maxRecDepth 32768
set_option maxHeartbeats 4000000

/-- The producer's grounding of the four-vertex distance source. -/
def importedDistanceProgram : Program Cost 21 := programOfTables 21
  (nat_table_from_json "../fixtures/round-convention/distance-grounding.json" at ["inputs"])
  (nat_table_from_json "../fixtures/round-convention/distance-grounding.json" at ["products"])

/-- The imported and hand-written four-vertex programs agree. -/
theorem importedDistanceProgram_eq :
    (∀ i, importedDistanceProgram.inputs i = distanceProgram.inputs i) ∧
      importedDistanceProgram.rules = distanceProgram.rules := by
  decide +kernel

/-- The producer's grounding of the six-vertex chain source. -/
def importedChainDistanceProgram : Program Cost 43 := programOfTables 43
  (nat_table_from_json "../fixtures/round-convention/chain-distance-grounding.json" at ["inputs"])
  (nat_table_from_json "../fixtures/round-convention/chain-distance-grounding.json" at ["products"])

/-- The imported and hand-written chain programs agree. -/
theorem importedChainDistanceProgram_eq :
    (∀ i, importedChainDistanceProgram.inputs i = chainDistanceProgram.inputs i) ∧
      importedChainDistanceProgram.rules = chainDistanceProgram.rules := by
  decide +kernel

end WeightedRules.RoundConvention
