import WeightedRules.LoweringSquare

/-!
# Reflection for finite lowering tables

A certificate is a row-major table for the summary transition of a supplied
source transition and lowering map. Its checker enforces exact coverage,
in-range entries and every source/event square. The summary type is nonempty,
as witnessed by an explicit fallback element; fallback and modular reduction
make decoding total, but accepted tables never need either repair.

Acceptance proves the complete lowering square and transport along every finite
event trace. The caller supplies the source semantics and lowering map. Table
parsing, certificate production and source identifiers are outside these proofs.
-/

namespace WeightedRules.EventLowering

variable {n m k : Nat}

/-- Total finite-value decoding, with coverage and range enforced separately. -/
def tableValue (values : List Nat) (fallback : Fin m) (index : Nat) : Fin m :=
  ⟨(values[index]?.getD fallback.val) % m,
    Nat.mod_lt _ (Nat.zero_lt_of_lt fallback.isLt)⟩

/-- Decode a row-major summary/event table. -/
def tableStep (values : List Nat) (fallback : Fin m) : Fin m → Fin k → Fin m :=
  fun s e => tableValue values fallback (s.val * k + e.val)

/-- Check exact table length, the range of every entry and the supplied square. -/
def checkLoweringCertificate (F : Fin n → Fin k → Fin n) (G : Fin n → Fin m)
    (fallback : Fin m) (values : List Nat) : Bool :=
  decide (values.length = m * k ∧ ∀ v ∈ values, v < m) &&
    checkSquare F G (tableStep values fallback)

/-- Every accepted table satisfies the complete source/event lowering square. -/
theorem checkLoweringCertificate_sound (F : Fin n → Fin k → Fin n)
    (G : Fin n → Fin m) (fallback : Fin m) (values : List Nat)
    (h : checkLoweringCertificate F G fallback values = true) :
    Square F G (tableStep values fallback) := by
  exact checkSquare_sound F G _ (Bool.and_eq_true_iff.mp h).2

/-- A summary transition table accompanied by kernel-checkable acceptance. -/
structure CheckedLowering (F : Fin n → Fin k → Fin n) (G : Fin n → Fin m)
    (fallback : Fin m) where
  values : List Nat
  accepted : checkLoweringCertificate F G fallback values = true

/-- The decoded transition of a checked lowering certificate. -/
def CheckedLowering.transition {F : Fin n → Fin k → Fin n} {G : Fin n → Fin m}
    {fallback : Fin m} (c : CheckedLowering F G fallback) : Fin m → Fin k → Fin m :=
  tableStep c.values fallback

/-- A checked lowering commutes with every source event. -/
theorem CheckedLowering.square {F : Fin n → Fin k → Fin n} {G : Fin n → Fin m}
    {fallback : Fin m} (c : CheckedLowering F G fallback) : Square F G c.transition :=
  checkLoweringCertificate_sound F G fallback c.values c.accepted

/-- A checked lowering transports every finite event trace. -/
theorem CheckedLowering.trace {F : Fin n → Fin k → Fin n} {G : Fin n → Fin m}
    {fallback : Fin m} (c : CheckedLowering F G fallback) (s : Fin n) (events : List (Fin k)) :
    G (run F s events) = run c.transition (G s) events :=
  square_trace F G c.transition c.square s events

end WeightedRules.EventLowering
