import WeightedRules.Oracle

/-!
# A six-vertex distance chain

The directed chain `0 → 1 → 2 → 3 → 4 → 5` has unit edge costs and a
zero-distance fact at vertex zero. Its grounding has 36 edge coordinates,
six distance coordinates and one multiplicative unit. A second program lowers
only the last edge cost to zero. The old least distance readout is `[0,1,2,3,4,5]`;
the modified readout is `[0,1,2,3,4,4]`.

The baseline witness is obtained through the external ABI and checked against
the supplied formal program by kernel reduction. The input fixture is a source
description, not a theorem about parser or grounding correctness.
-/

namespace WeightedRules

set_option maxRecDepth 32768
set_option maxHeartbeats 4000000

/-- Five unit-cost chain edges, the zero-distance origin and the scalar unit. -/
def chainDistanceInputs (i : Fin 43) : Cost :=
  if i.val = 36 ∨ i.val = 42 then ⟨0, by decide⟩
  else if i.val < 30 ∧ i.val % 7 = 1 then ⟨1, by decide⟩ else infinity

/-- All grounded distance-extension products on six vertices. -/
def chainDistanceRules : List (ProductRule 43) :=
  (List.finRange 6).flatMap fun x => (List.finRange 6).map fun y =>
    { output := ⟨36 + y.val, by omega⟩
      left := ⟨36 + x.val, by omega⟩
      right := ⟨6 * x.val + y.val, by omega⟩ }

/-- The grounded unit-cost six-vertex chain. -/
def chainDistanceProgram : Program Cost 43 := ⟨chainDistanceInputs, chainDistanceRules⟩

/-- The same chain with edge `4 → 5` decreased from one to zero. -/
def chainDistanceImprovedProgram : Program Cost 43 :=
  { chainDistanceProgram with
    inputs := fun i => if i.val = 29 then ⟨0, by decide⟩ else chainDistanceInputs i }

/-- Externally obtained baseline values with a checked from-zero certificate. -/
def chainDistanceBaseline : CheckedSolution chainDistanceProgram :=
  ergodis_solution chainDistanceProgram from "WeightedRules/fixtures/chain-distance.json"

/-- The baseline distances are the six vertex indices. -/
theorem chainDistanceBaseline_values :
    ((List.finRange 6).map fun i =>
      (listState chainDistanceBaseline.values (⟨36 + i.val, by omega⟩ : Fin 43)).val) =
      [0, 1, 2, 3, 4, 5] := by
  decide +kernel

end WeightedRules
