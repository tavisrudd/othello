import Mathlib.Data.Fin.Basic
import Mathlib.Logic.Function.Iterate

/-!
# Finite weighted rule contracts

A program is a finite system of polynomial equations over an idempotent semiring.
Its information order is `a ≤ᵢ b` when `a + b = b`; for min-plus this reverses
numerical cost order. A certificate supplies a finite iterate from zero and checks
that it is fixed. The terminal theorem establishes that this iterate is the least
fixed point. It assumes no unproved global convergence theorem.

Scalar stability, source-lowering commutation and symmetry are separate obligations.
All results in this module are symbolic kernel proofs. Parsing, machine arithmetic
and foreign function calls are outside their conclusions.
-/

namespace WeightedRules

variable {W S : Type} {n : Nat}

/-- The operations and laws of an idempotent semiring, with ordered multiplication. -/
structure ScalarAlgebra (W : Type) where
  zero : W
  one : W
  add : W → W → W
  mul : W → W → W
  add_assoc : ∀ a b c, add (add a b) c = add a (add b c)
  add_comm : ∀ a b, add a b = add b a
  add_zero : ∀ a, add a zero = a
  add_idem : ∀ a, add a a = a
  mul_assoc : ∀ a b c, mul (mul a b) c = mul a (mul b c)
  mul_one : ∀ a, mul a one = a
  one_mul : ∀ a, mul one a = a
  mul_zero : ∀ a, mul a zero = zero
  zero_mul : ∀ a, mul zero a = zero
  left_distrib : ∀ a b c, mul a (add b c) = add (mul a b) (mul a c)
  right_distrib : ∀ a b c, mul (add a b) c = add (mul a c) (mul b c)

/-- Information increases when an alternative can absorb the previous value. -/
def InfoLe (A : ScalarAlgebra W) (a b : W) : Prop := A.add a b = b

/-- Every value absorbs itself. -/
theorem info_refl (A : ScalarAlgebra W) (a : W) : InfoLe A a a := A.add_idem a

/-- Absorption is transitive. -/
theorem info_trans (A : ScalarAlgebra W) {a b c : W}
    (hab : InfoLe A a b) (hbc : InfoLe A b c) : InfoLe A a c := by
  unfold InfoLe at *
  calc
    A.add a c = A.add a (A.add b c) := by rw [hbc]
    _ = A.add (A.add a b) c := (A.add_assoc a b c).symm
    _ = c := by rw [hab, hbc]

/-- Mutual absorption is equality. -/
theorem info_antisymm (A : ScalarAlgebra W) {a b : W}
    (hab : InfoLe A a b) (hba : InfoLe A b a) : a = b := by
  calc
    a = A.add b a := hba.symm
    _ = A.add a b := A.add_comm b a
    _ = b := hab

/-- Zero is least in the information order. -/
theorem zero_le (A : ScalarAlgebra W) (a : W) : InfoLe A A.zero a := by
  unfold InfoLe
  rw [A.add_comm, A.add_zero]

private theorem add_mono_left (A : ScalarAlgebra W) {a b : W}
    (h : InfoLe A a b) (c : W) : InfoLe A (A.add a c) (A.add b c) := by
  unfold InfoLe at *
  calc
    A.add (A.add a c) (A.add b c) = A.add a (A.add c (A.add b c)) := A.add_assoc ..
    _ = A.add a (A.add (A.add c b) c) := by rw [A.add_assoc c b c]
    _ = A.add a (A.add (A.add b c) c) := by rw [A.add_comm c b]
    _ = A.add a (A.add b (A.add c c)) := by rw [A.add_assoc b c c]
    _ = A.add (A.add a b) c := by rw [A.add_idem, A.add_assoc]
    _ = A.add b c := by rw [h]

/-- Addition preserves the information order in both arguments. -/
theorem add_mono (A : ScalarAlgebra W) {a b c d : W}
    (hab : InfoLe A a b) (hcd : InfoLe A c d) :
    InfoLe A (A.add a c) (A.add b d) := by
  apply info_trans A (add_mono_left A hab c)
  simpa only [A.add_comm b c, A.add_comm b d] using add_mono_left A hcd b

/-- Multiplication preserves information on both ordered factors. -/
theorem mul_mono (A : ScalarAlgebra W) {a b c d : W}
    (hab : InfoLe A a b) (hcd : InfoLe A c d) :
    InfoLe A (A.mul a c) (A.mul b d) := by
  apply info_trans A (b := A.mul b c)
  · unfold InfoLe at *
    rw [← A.right_distrib, hab]
  · unfold InfoLe at *
    rw [← A.left_distrib, hcd]

/-- Truncated geometric sum `1 + u + ... + u^p`, with multiplication on the left. -/
def starSum (A : ScalarAlgebra W) (u : W) : Nat → W
  | 0 => A.one
  | p + 1 => A.add A.one (A.mul u (starSum A u p))

/-- Uniform scalar stability is equality of consecutive truncated geometric sums. -/
def UniformlyStable (A : ScalarAlgebra W) (p : Nat) : Prop :=
  ∀ u, starSum A u p = starSum A u (p + 1)

/-- Comparison minus preserves the join with held information. -/
structure MinusContract (A : ScalarAlgebra W) where
  minus : W → W → W
  join : ∀ v u, A.add u (minus v u) = A.add u v
  empty : ∀ v u, minus v u = A.zero ↔ InfoLe A v u

/-- One binary, ordered monomial contributing to an output scalar. -/
structure ProductRule (n : Nat) where
  output : Fin n
  left : Fin n
  right : Fin n
  deriving DecidableEq, Repr

/-- A finite scalar valuation. Matrix-valued relations have one scalar per entry. -/
abbrev State (W : Type) (n : Nat) := Fin n → W

/-- A grounded relation contract: base facts and ordered product contributions. -/
structure Program (W : Type) (n : Nat) where
  inputs : State W n
  rules : List (ProductRule n)

/-- Evaluate all rule contributions, adding alternatives with the same output. -/
def contributions (A : ScalarAlgebra W) : List (ProductRule n) → State W n → State W n
  | [], _ => fun _ => A.zero
  | r :: rs, x => fun i => A.add
      (if r.output = i then A.mul (x r.left) (x r.right) else A.zero)
      (contributions A rs x i)

/-- One synchronous application of the supplied finite equations. -/
def step (A : ScalarAlgebra W) (P : Program W n) (x : State W n) : State W n :=
  fun i => A.add (P.inputs i) (contributions A P.rules x i)

/-- Pointwise information order on valuations. -/
def StateLe (A : ScalarAlgebra W) (x y : State W n) : Prop := ∀ i, InfoLe A (x i) (y i)

private theorem contributions_mono (A : ScalarAlgebra W) (rs : List (ProductRule n))
    {x y : State W n} (h : StateLe A x y) :
    StateLe A (contributions A rs x) (contributions A rs y) := by
  induction rs with
  | nil => intro i; exact info_refl A _
  | cons r rs ih =>
    intro i
    apply add_mono A
    · split
      · exact mul_mono A (h r.left) (h r.right)
      · exact info_refl A _
    · exact ih i

/-- Polynomial rule evaluation is monotone in the information order. -/
theorem step_mono (A : ScalarAlgebra W) (P : Program W n)
    {x y : State W n} (h : StateLe A x y) : StateLe A (step A P x) (step A P y) :=
  fun i => add_mono A (info_refl A _) (contributions_mono A P.rules h i)

/-- Kleene iteration starts with no facts, represented by the additive zero. -/
def iterate (A : ScalarAlgebra W) (P : Program W n) : Nat → State W n
  | 0 => fun _ => A.zero
  | k + 1 => step A P (iterate A P k)

/-- Every finite iterate is below every fixed solution. -/
theorem iterate_le_fixed (A : ScalarAlgebra W) (P : Program W n)
    (y : State W n) (hy : step A P y = y) (k : Nat) : StateLe A (iterate A P k) y := by
  induction k with
  | zero => exact fun i => zero_le A (y i)
  | succ k ih => simpa only [iterate, hy] using step_mono A P ih

/-- A certificate checks convergence within a declared scalar-round bound. -/
structure Certificate (A : ScalarAlgebra W) (P : Program W n) (bound : Nat) where
  rounds : Nat
  within : rounds ≤ bound
  fixed : step A P (iterate A P rounds) = iterate A P rounds

/-- A checked finite convergence certificate establishes the least fixed point. -/
theorem certificate_least (A : ScalarAlgebra W) (P : Program W n) (bound : Nat)
    (c : Certificate A P bound) :
    step A P (iterate A P c.rounds) = iterate A P c.rounds ∧
      ∀ y, step A P y = y → StateLe A (iterate A P c.rounds) y :=
  ⟨c.fixed, fun y hy => iterate_le_fixed A P y hy c.rounds⟩

/-- Two least fixed solutions of the same program are identical. -/
theorem certificates_agree (A : ScalarAlgebra W) (P : Program W n) (b c : Nat)
    (x : Certificate A P b) (y : Certificate A P c) :
    iterate A P x.rounds = iterate A P y.rounds := by
  funext i
  exact info_antisymm A (iterate_le_fixed A P _ y.fixed _ i)
    (iterate_le_fixed A P _ x.fixed _ i)

/-- A source lowering identifies zero and commutes with one semantic step. -/
structure Lowering (A : ScalarAlgebra W) (P : Program W n)
    (sourceZero : S) (sourceStep : S → S) where
  map : S → State W n
  zero : map sourceZero = iterate A P 0
  commute : ∀ s, map (sourceStep s) = step A P (map s)

/-- Iteration commutes with every lowering satisfying the semantic square. -/
theorem lowering_iterate (A : ScalarAlgebra W) (P : Program W n)
    (z : S) (f : S → S) (L : Lowering A P z f) (k : Nat) :
    L.map (f^[k] z) = iterate A P k := by
  induction k with
  | zero => exact L.zero
  | succ k ih =>
    rw [Function.iterate_succ_apply', L.commute, ih]
    rfl

/-- An admitted state symmetry preserves zero and commutes with rule evaluation. -/
structure Symmetry (A : ScalarAlgebra W) (P : Program W n) where
  permute : State W n ≃ State W n
  zero : permute (iterate A P 0) = iterate A P 0
  commute : ∀ x, permute (step A P x) = step A P (permute x)

/-- Every finite iterate is invariant under an admitted symmetry. -/
theorem symmetry_iterate (A : ScalarAlgebra W) (P : Program W n)
    (s : Symmetry A P) (k : Nat) : s.permute (iterate A P k) = iterate A P k := by
  induction k with
  | zero => exact s.zero
  | succ k ih => simp only [iterate, s.commute, ih]

end WeightedRules
