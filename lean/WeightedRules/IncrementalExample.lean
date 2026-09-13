import WeightedRules.OracleExample

/-!
# Checked incremental distance witnesses through the external ABI

The four-vertex distance program first lowers edge `0 → 1` from seven to one,
then lowers edge `0 → 2` from two to zero. The external provider returns complete
witness values for each modified source. Lean checks three synchronous steps
from the old checked valuation for the first update, and two for the second.
The distance readouts become `[0,1,2,4]` and `[0,1,0,4]`, respectively.

The provider still solves its supplied source independently. Incrementality here
describes the Lean proof replay, not an assertion about the provider's internal
algorithm or its work counters. Converted certificates retain the original
from-zero semantics and scalar-count round bound. The external parser, source
hash and implementation remain outside the proofs.
-/

namespace WeightedRules

set_option maxRecDepth 16384

/-- The distance program with edge `0 → 1` decreased to one. -/
def improvedDistanceProgram : Program Cost 21 :=
  { distanceProgram with
    inputs := fun i => if i.val = 1 then ⟨1, by decide⟩ else distanceInputs i }

/-- The distance program with edges `0 → 1` and `0 → 2` decreased to one and zero. -/
def twiceImprovedDistanceProgram : Program Cost 21 :=
  { improvedDistanceProgram with
    inputs := fun i => if i.val = 2 then ⟨0, by decide⟩ else improvedDistanceProgram.inputs i }

/-- Externally returned values checked by three steps from the prior certificate. -/
def oracleImprovedDistance : CheckedImprovement oracleDistance improvedDistanceProgram :=
  ergodis_improvement oracleDistance to improvedDistanceProgram
    from "WeightedRules/fixtures/distance-improved.json" replay 3

/-- A second external witness checked by two steps from the converted first result. -/
def oracleTwiceImprovedDistance :
    CheckedImprovement oracleImprovedDistance.toCheckedSolution twiceImprovedDistanceProgram :=
  ergodis_improvement oracleImprovedDistance.toCheckedSolution to twiceImprovedDistanceProgram
    from "WeightedRules/fixtures/distance-improved-twice.json" replay 2

/-- Reusing unchanged source data admits zero incremental replay rounds. -/
def oracleDistanceNoop : CheckedImprovement oracleDistance distanceProgram :=
  ergodis_improvement oracleDistance to distanceProgram
    from "WeightedRules/fixtures/distance.json" replay 0

/-- The first improved distance readout is zero, one, two and four. -/
theorem oracleImprovedDistance_values :
    ((List.finRange 4).map fun i =>
      (listState oracleImprovedDistance.values (⟨16 + i.val, by omega⟩ : Fin 21)).val) =
      [0, 1, 2, 4] := by
  decide +kernel

/-- The second improved distance readout is zero, one, zero and four. -/
theorem oracleTwiceImprovedDistance_values :
    ((List.finRange 4).map fun i =>
      (listState oracleTwiceImprovedDistance.values (⟨16 + i.val, by omega⟩ : Fin 21)).val) =
      [0, 1, 0, 4] := by
  decide +kernel

/-- Chained external improvements yield the least solution of the final program. -/
theorem oracleTwiceImprovedDistance_least :
    IsLeastFixed twiceImprovedDistanceProgram
      (listState oracleTwiceImprovedDistance.toCheckedSolution.values) :=
  oracleTwiceImprovedDistance.toCheckedSolution.least

/-- Incremental work counts remain distinct from the converted from-zero bound. -/
theorem oracle_incremental_round_counts :
    oracleImprovedDistance.rounds = 3 ∧ oracleTwiceImprovedDistance.rounds = 2 ∧
    oracleDistanceNoop.rounds = 0 ∧ oracleTwiceImprovedDistance.toCheckedSolution.rounds = 21 := by
  decide +kernel

end WeightedRules
