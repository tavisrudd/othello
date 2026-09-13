import WeightedRules.LoweringSquare

/-!
# Lower bounds for deterministic readout summaries

Suppose a finite collection of source states is pairwise distinguished by
readouts after some finite event trace. Any finite deterministic summary that
commutes with source events and preserves current readouts must assign these
states distinct summaries. Its cardinality is therefore at least the size of
the collection. No surjectivity or minimality of the proposed summary is assumed.
-/

namespace WeightedRules.EventLowering

variable {X Y E O Q : Type*} [Fintype Y] [Fintype Q]

/-- Pairwise trace-distinguishable representatives inject into every finite
event-compatible summary preserving the supplied readout. -/
theorem separated_readouts_card_le (F : X → E → X) (G : X → Y)
    (H : Y → E → Y) (readout : X → O) (summaryReadout : Y → O)
    (representative : Q → X) (square : Square F G H)
    (preserves : ∀ x, summaryReadout (G x) = readout x)
    (separates : ∀ a b : Q, a ≠ b → ∃ events : List E,
      readout (run F (representative a) events) ≠
        readout (run F (representative b) events)) :
    Fintype.card Q ≤ Fintype.card Y := by
  apply Fintype.card_le_of_injective (fun q => G (representative q))
  intro a b hab
  change G (representative a) = G (representative b) at hab
  by_contra hne
  obtain ⟨events, hsep⟩ := separates a b hne
  apply hsep
  calc
    readout (run F (representative a) events) =
        summaryReadout (G (run F (representative a) events)) := (preserves _).symm
    _ = summaryReadout (run H (G (representative a)) events) :=
      congrArg summaryReadout (square_trace F G H square _ events)
    _ = summaryReadout (run H (G (representative b)) events) := by rw [hab]
    _ = summaryReadout (G (run F (representative b) events)) :=
      congrArg summaryReadout (square_trace F G H square _ events).symm
    _ = readout (run F (representative b) events) := preserves _

end WeightedRules.EventLowering
