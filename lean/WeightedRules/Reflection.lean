import WeightedRules.BoundedMinPlus

/-!
# Reflection for bounded min-plus certificates

An external certificate supplies a list of costs and a round count. The checker
compares every value with iteration of the caller's formal program from infinity,
checks fixedness, and enforces the scalar round bound. Its soundness theorem gives
the least fixed valuation. The caller's program is an input to the theorem; no
program returned by an external process can replace it. Checking uses kernel
reduction, with no native decision axiom or trusted foreign result.
-/

namespace WeightedRules

/-- Interpret a cost list in scalar order; the checker separately requires exact length. -/
def listState {n : Nat} (values : List Cost) : State Cost n :=
  fun i => values[i.val]?.getD infinity

/-- Finite replay, exact coverage and fixedness against the caller's program. -/
def checkCertificate {n : Nat} (P : Program Cost n) (rounds : Nat)
    (values : List Cost) : Bool :=
  decide (values.length = n ∧ rounds ≤ n ∧
    (∀ i, iterate boundedMinPlus P rounds i = listState values i) ∧
    (∀ i, step boundedMinPlus P (listState values) i = listState values i))

/-- A valuation solves the equations and lies below every solution in information order. -/
def IsLeastFixed {n : Nat} (P : Program Cost n) (x : State Cost n) : Prop :=
  step boundedMinPlus P x = x ∧
    ∀ y, step boundedMinPlus P y = y → StateLe boundedMinPlus x y

/-- Acceptance proves leastness for all coordinates of the caller's formal program. -/
theorem checkCertificate_sound {n : Nat} (P : Program Cost n) (rounds : Nat)
    (values : List Cost) (accepted : checkCertificate P rounds values = true) :
    IsLeastFixed P (listState values) := by
  have h := of_decide_eq_true accepted
  have equal : iterate boundedMinPlus P rounds = listState values := funext h.2.2.1
  refine ⟨funext h.2.2.2, ?_⟩
  intro y hy
  rw [← equal]
  exact iterate_le_fixed boundedMinPlus P y hy rounds

/-- A returned valuation carries a proof of replay acceptance, including the round bound. -/
structure CheckedSolution {n : Nat} (P : Program Cost n) where
  rounds : Nat
  values : List Cost
  accepted : checkCertificate P rounds values = true

/-- Every checked solution supplies a kernel proof of least fixedness. -/
theorem CheckedSolution.least {n : Nat} {P : Program Cost n} (s : CheckedSolution P) :
    IsLeastFixed P (listState s.values) :=
  checkCertificate_sound P s.rounds s.values s.accepted

/-- In min-plus information order, the certified numerical costs are at least
those of every other fixed point; unsupported smaller cyclic costs do not win. -/
theorem CheckedSolution.cost_order {n : Nat} {P : Program Cost n} (s : CheckedSolution P)
    (y : State Cost n) (hy : step boundedMinPlus P y = y) (i : Fin n) :
    (y i).val ≤ (listState s.values i).val := by
  have h := congrArg Fin.val (s.least.2 y hy i)
  change min (listState s.values i).val (y i).val = (y i).val at h
  omega

end WeightedRules
