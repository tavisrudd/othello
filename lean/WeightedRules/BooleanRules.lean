import WeightedRules.OrderedConvergence
import WeightedRules.BoundedMinPlus
import Mathlib.Data.Bool.Basic
import Mathlib.Order.Basic

/-!
# Boolean reachability rules

The Boolean carrier has alternative `or` and composition `and`; `false` is the
additive zero and `true` the multiplicative unit. Under the linear order
`true < false`, the dual of the standard order on `Bool`, this algebra is
ordered inflationary: `or` is the minimum and `and` lies above both factors.
The generic counting argument therefore bounds every Boolean program by its
scalar count and by its distinct-output count.

The lift `true ↦ 0`, `false ↦ infinity` is a semiring homomorphism from the
Boolean carrier into bounded min-plus, so the iterates of a Boolean program
are the lifted iterates of the corresponding min-plus program whose facts
are zero or infinity. A producer may therefore evaluate a Boolean program on
the min-plus kernel and decode; the theorem `boolLift_iterate` establishes
that this decoding is exact at every round.

A three-vertex transitive closure is checked by kernel reduction: its nine
edge coordinates, nine path coordinates and the unit converge after three
rounds, and the symbolic leastness theorem supplies the meaning of that
certificate. No theorem here concerns an external parser or transport.
-/

namespace WeightedRules

variable {n : Nat}

/-- Boolean reachability obeys every idempotent semiring law. -/
def booleanRules : ScalarAlgebra Bool where
  zero := false
  one := true
  add := or
  mul := and
  add_assoc := by decide
  add_comm := by decide
  add_zero := by decide
  add_idem := by decide
  mul_assoc := by decide
  mul_one := by decide
  one_mul := by decide
  mul_zero := by decide
  zero_mul := by decide
  left_distrib := by decide
  right_distrib := by decide

/-- Composition cannot improve the multiplicative unit. -/
theorem booleanRules_zero_stable : UniformlyStable booleanRules 0 := by
  intro u
  cases u <;> rfl

/-- Comparison minus retains a value exactly when it was not already held. -/
def booleanMinus : MinusContract booleanRules where
  minus v u := v && !u
  join := by decide
  empty := by
    intro v u
    unfold InfoLe
    cases v <;> cases u <;> decide

/-- Under the order `true < false`, Boolean reachability is ordered inflationary. -/
theorem booleanRules_orderedInflationary :
    OrderedInflationary (W := Boolᵒᵈ) booleanRules where
  add_min a b := by
    cases a <;> cases b <;> decide
  le_mul_left a b := by
    cases a <;> cases b <;> decide
  le_mul_right a b := by
    cases a <;> cases b <;> decide

/-- Every Boolean program is fixed after `n` rounds, where `n` counts all
scalar coordinates, including fixed inputs. -/
theorem booleanRules_iterate_fixed (P : Program Bool n) :
    step booleanRules P (iterate booleanRules P n) = iterate booleanRules P n :=
  booleanRules_orderedInflationary.iterate_fixed P

/-- The scalar-count iterate of a Boolean program is its least fixed valuation. -/
theorem booleanRules_iterate_least (P : Program Bool n) :
    step booleanRules P (iterate booleanRules P n) = iterate booleanRules P n ∧
    ∀ y, step booleanRules P y = y → StateLe booleanRules (iterate booleanRules P n) y :=
  booleanRules_orderedInflationary.iterate_least P

/-- Every Boolean program is fixed within one round beyond its number of
distinct rule outputs, capped by its total scalar count. -/
theorem booleanRules_rule_output_least (P : Program Bool n) :
    step booleanRules P (iterate booleanRules P (ruleOutputBound P)) =
      iterate booleanRules P (ruleOutputBound P) ∧
    ∀ y, step booleanRules P y = y →
      StateLe booleanRules (iterate booleanRules P (ruleOutputBound P)) y :=
  booleanRules_orderedInflationary.rule_output_least P

/-- The lift of a truth value into bounded min-plus: reached is cost zero,
unreached is infinity. -/
def boolLift : Bool → Cost
  | true => ⟨0, by decide⟩
  | false => infinity

/-- The lift respects alternatives. -/
theorem boolLift_add (a b : Bool) : costAdd (boolLift a) (boolLift b) = boolLift (a || b) := by
  cases a <;> cases b <;> decide

/-- The lift respects composition. -/
theorem boolLift_mul (a b : Bool) : costMul (boolLift a) (boolLift b) = boolLift (a && b) := by
  cases a <;> cases b <;> decide

/-- The min-plus program with the same rules and lifted facts. -/
def liftProgram (P : Program Bool n) : Program Cost n :=
  ⟨fun i => boolLift (P.inputs i), P.rules⟩

/-- Lifted contributions are the contributions of the lifted valuation. -/
theorem boolLift_contributions (rs : List (ProductRule n)) (x : State Bool n) (i : Fin n) :
    contributions boundedMinPlus rs (fun j => boolLift (x j)) i =
      boolLift (contributions booleanRules rs x i) := by
  induction rs with
  | nil => rfl
  | cons r rs ih =>
    simp only [contributions]
    by_cases ho : r.output = i
    · simp only [ho, if_true]
      rw [ih]
      change costAdd (costMul (boolLift (x r.left)) (boolLift (x r.right)))
        (boolLift (contributions booleanRules rs x i)) =
        boolLift ((x r.left && x r.right) || contributions booleanRules rs x i)
      rw [boolLift_mul, boolLift_add]
    · simp only [ho, if_false]
      rw [ih]
      exact boolLift_add false _

/-- One lifted step is the step of the lifted program. -/
theorem boolLift_step (P : Program Bool n) (x : State Bool n) :
    step boundedMinPlus (liftProgram P) (fun j => boolLift (x j)) =
      fun i => boolLift (step booleanRules P x i) := by
  funext i
  simp only [step, liftProgram]
  rw [boolLift_contributions]
  exact boolLift_add _ _

/-- Every iterate of the lifted program is the lift of the Boolean iterate, so
evaluating a Boolean program on the bounded min-plus kernel and decoding
`infinity` as `false` is exact at every round. -/
theorem boolLift_iterate (P : Program Bool n) (k : Nat) :
    iterate boundedMinPlus (liftProgram P) k = fun i => boolLift (iterate booleanRules P k i) := by
  induction k with
  | zero => rfl
  | succ k ih =>
    change step boundedMinPlus (liftProgram P) (iterate boundedMinPlus (liftProgram P) k) = _
    rw [ih]
    exact boolLift_step P _

/-- Edge facts `0 → 1` and `1 → 2` in row-major order, then the unit. -/
def closureInputs (i : Fin 19) : Bool :=
  match i.val with
  | 1 => true
  | 5 => true
  | 18 => true
  | _ => false

/-- Grounding of `path(x,y) :- edge(x,y)` and `path(x,z) :- path(x,y), edge(y,z)`
over three vertices; unary rules multiply by the unit coordinate. -/
def closureRules : List (ProductRule 19) :=
  ((List.finRange 3).flatMap fun x => (List.finRange 3).map fun y =>
    { output := ⟨9 + 3 * x.val + y.val, by omega⟩
      left := ⟨3 * x.val + y.val, by omega⟩
      right := ⟨18, by omega⟩ }) ++
  ((List.finRange 3).flatMap fun x => (List.finRange 3).flatMap fun y =>
    (List.finRange 3).map fun z =>
      { output := ⟨9 + 3 * x.val + z.val, by omega⟩
        left := ⟨9 + 3 * x.val + y.val, by omega⟩
        right := ⟨3 * y.val + z.val, by omega⟩ })

/-- The three-vertex transitive closure program, including fixed edge coordinates. -/
def closureProgram : Program Bool 19 := ⟨closureInputs, closureRules⟩

set_option maxRecDepth 8192 in
/-- Kernel-checked convergence of the closure program within its scalar bound. -/
def closureCertificate : Certificate booleanRules closureProgram 19 where
  rounds := 3
  within := by decide
  fixed := by decide

/-- The three-round valuation is the least solution of the closure equations. -/
theorem closure_least :
    step booleanRules closureProgram (iterate booleanRules closureProgram 3) =
      iterate booleanRules closureProgram 3 ∧
    ∀ y, step booleanRules closureProgram y = y →
      StateLe booleanRules (iterate booleanRules closureProgram 3) y :=
  certificate_least booleanRules closureProgram 19 closureCertificate

set_option maxRecDepth 8192 in
/-- The reachable pairs are `0 → 1`, `0 → 2` and `1 → 2`. -/
theorem closure_values :
    ((List.finRange 9).map fun i =>
      iterate booleanRules closureProgram 3 ⟨9 + i.val, by omega⟩) =
      [false, true, true, false, false, true, false, false, false] := by
  decide

end WeightedRules
