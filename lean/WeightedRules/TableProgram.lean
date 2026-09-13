import WeightedRules.Reflection
import WeightedRules.FiniteTableImport

/-!
# Scalar programs imported from natural-number tables

A producer that grounds a relational source into scalar coordinates can emit
its grounding as two natural-number tables: the input valuation, one entry per
coordinate, and the product rules as a flat list of `output, left, right`
triples. The definitions here turn such tables into a `Program Cost n` on the
caller's declared coordinate count `n`, so that a certificate can be checked
against the producer's own grounding rather than against a transcription.

Out-of-range entries are not errors at import time: a cost at or above the
carrier size saturates to `infinity`, and a coordinate at or above `n` maps to
coordinate zero, while a trailing incomplete triple is dropped. Any such
defect changes the imported program, and the certificate checks that consume
it then fail for the program actually imported. Correspondence with a
hand-written program is a separate decidable equality on the resulting
inputs and rule list.
-/

namespace WeightedRules

/-- A natural number as a bounded cost, saturating at `infinity`. -/
def costOfNat (value : Nat) : Cost :=
  if h : value < 4294967296 then ⟨value, h⟩ else infinity

/-- A natural-number table as a cost list. -/
def costList (values : List Nat) : List Cost := values.map costOfNat

/-- A natural number as a coordinate, with out-of-range entries at zero. -/
def coordinate (n : Nat) [NeZero n] (value : Nat) : Fin n :=
  if h : value < n then ⟨value, h⟩ else ⟨0, Nat.pos_of_neZero n⟩

/-- Product rules from a flat `output, left, right` table. -/
def productRules (n : Nat) [NeZero n] : List Nat → List (ProductRule n)
  | output :: left :: right :: rest =>
      ⟨coordinate n output, coordinate n left, coordinate n right⟩ :: productRules n rest
  | _ => []

/-- The scalar program with the tabulated inputs and product rules. -/
def programOfTables (n : Nat) [NeZero n] (inputs products : List Nat) : Program Cost n :=
  ⟨listState (costList inputs), productRules n products⟩

end WeightedRules
