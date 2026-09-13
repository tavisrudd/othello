import WeightedRules.FiniteTableImport
import WeightedRules.FiniteLoweringReflection
import WeightedRules.ReadoutMinimality

/-!
# Finite lowering reflection controls

The source is addition modulo four by an event in `{0,1}`; the summary is
parity. Kernel reduction checks the complete eight-cell lowering square and
rejects incomplete, out-of-range and semantically incorrect tables. Separate
elaboration controls reject malformed JSON table entries. The JSON fixture is
test data, and its imported values acquire authority only through checking.
-/

namespace WeightedRules.EventLowering

private def paritySource (s : Fin 4) (e : Fin 2) : Fin 4 :=
  ⟨(s.val + e.val) % 4, Nat.mod_lt _ (by decide)⟩

private def paritySummary (s : Fin 4) : Fin 2 :=
  ⟨s.val % 2, Nat.mod_lt _ (by decide)⟩

private def parityTable : List Nat :=
  nat_table_from_json "fixtures/finite-tables.json" at ["valid"]

/-- The imported parity table satisfies exact coverage and all source events. -/
theorem parity_table_accepted :
    checkLoweringCertificate paritySource paritySummary 0 parityTable = true := by
  decide +kernel

/-- Invalid coverage, a wrapped out-of-range entry, a wrong transition, and a
wrong caller source are all rejected. -/
theorem lowering_rejection_controls :
    checkLoweringCertificate paritySource paritySummary 0 [] = false ∧
    checkLoweringCertificate paritySource paritySummary 0 [0, 1, 1] = false ∧
    checkLoweringCertificate paritySource paritySummary 0 [2, 1, 1, 0] = false ∧
    checkLoweringCertificate paritySource paritySummary 0 [0, 0, 1, 0] = false ∧
    checkLoweringCertificate (fun (_ : Fin 4) (_ : Fin 2) => 0)
      paritySummary 0 parityTable = false := by
  decide +kernel

/-- error: table entry must be a natural number -/
#guard_msgs in
example : List Nat := nat_table_from_json "fixtures/finite-tables.json" at ["negative"]

/-- error: table entry must be a natural number -/
#guard_msgs in
example : List Nat := nat_table_from_json "fixtures/finite-tables.json" at ["fractional"]

/-- error: table entry must be a natural number -/
#guard_msgs in
example : List Nat := nat_table_from_json "fixtures/finite-tables.json" at ["string"]

/-- error: table entry must be a natural number -/
#guard_msgs in
example : List Nat := nat_table_from_json "fixtures/finite-tables.json" at ["boolean"]

/-- error: table entry exceeds natural-number limit -/
#guard_msgs in
example : List Nat := nat_table_from_json "fixtures/finite-tables.json" at ["too_large"]

/-- error: expected a table array -/
#guard_msgs in
example : List Nat := nat_table_from_json "fixtures/finite-tables.json" at ["not_array"]

#print axioms WeightedRules.EventLowering.checkLoweringCertificate_sound
#print axioms WeightedRules.EventLowering.CheckedLowering.trace
#print axioms WeightedRules.EventLowering.parity_table_accepted
#print axioms WeightedRules.EventLowering.lowering_rejection_controls
#print axioms WeightedRules.EventLowering.separated_readouts_card_le

end WeightedRules.EventLowering
