import WeightedRules.Contract
import Mathlib.Data.Fintype.Pi

/-!
# Bounded nonnegative min-plus rules

Costs are the integers from zero through `2^32 - 1`. The last value denotes
infinity. Alternative is minimum; composition is addition saturated at infinity.
The scalar algebra and its zero-stability are proved symbolically. A finite
four-vertex shortest-path example includes the directed cycle `1 → 3 → 2 → 1`.
Its 21 scalar coordinates are 16 edges, four distances and the multiplicative
unit. Four synchronous rounds reach a fixed point; kernel reduction checks the
example certificate, and the symbolic leastness theorem supplies its meaning.

The bounded carrier identifies every sum at least `2^32 - 1` with infinity.
No theorem here distinguishes an absent path from a path exceeding that cap,
or establishes correctness of an external parser or foreign-function transport.
-/

namespace WeightedRules

/-- The bounded scalar carrier, including the infinity sentinel. -/
abbrev Cost := Fin 4294967296

/-- The absent-path value. -/
def infinity : Cost := ⟨4294967295, by decide⟩

/-- Alternative paths select the smaller represented cost. -/
def costAdd (a b : Cost) : Cost := ⟨min a.val b.val, lt_of_le_of_lt (min_le_left ..) a.isLt⟩

/-- Composition adds costs and saturates at the absent-path sentinel. -/
def costMul (a b : Cost) : Cost :=
  ⟨min 4294967295 (a.val + b.val), by omega⟩

/-- Bounded min-plus obeys every idempotent semiring law. -/
def boundedMinPlus : ScalarAlgebra Cost where
  zero := infinity
  one := ⟨0, by decide⟩
  add := costAdd
  mul := costMul
  add_assoc := by intro a b c; apply Fin.ext; simp only [costAdd]; omega
  add_comm := by intro a b; apply Fin.ext; simp only [costAdd]; omega
  add_zero := by intro a; have := a.isLt; apply Fin.ext; simp only [costAdd, infinity]; omega
  add_idem := by intro a; apply Fin.ext; simp only [costAdd]; omega
  mul_assoc := by intro a b c; apply Fin.ext; simp only [costMul]; omega
  mul_one := by intro a; have := a.isLt; apply Fin.ext; simp only [costMul]; omega
  one_mul := by intro a; have := a.isLt; apply Fin.ext; simp only [costMul]; omega
  mul_zero := by intro a; apply Fin.ext; simp only [costMul, infinity]; omega
  zero_mul := by intro a; apply Fin.ext; simp only [costMul, infinity]; omega
  left_distrib := by intro a b c; apply Fin.ext; simp only [costMul, costAdd]; omega
  right_distrib := by intro a b c; apply Fin.ext; simp only [costMul, costAdd]; omega

/-- Nonnegative scalar costs cannot improve the multiplicative unit. -/
theorem boundedMinPlus_zero_stable : UniformlyStable boundedMinPlus 0 := by
  intro u
  apply Fin.ext
  simp only [starSum, boundedMinPlus, costAdd, costMul]
  omega

/-- Comparison minus retains only a strict cost improvement. -/
def costMinus (v u : Cost) : Cost := if v.val < u.val then v else infinity

/-- Comparison minus preserves alternatives and is empty exactly for absorbed values. -/
def boundedMinus : MinusContract boundedMinPlus where
  minus := costMinus
  join := by
    intro v u
    dsimp [costMinus, boundedMinPlus]
    split
    · rfl
    · have hu := u.isLt
      apply Fin.ext
      change min u.val 4294967295 = min u.val v.val
      omega
  empty := by
    intro v u
    change (if v.val < u.val then v else infinity) = infinity ↔ costAdd v u = u
    by_cases h : v.val < u.val
    · rw [if_pos h]
      constructor
      · intro eq
        have hv := congrArg Fin.val eq
        change v.val = 4294967295 at hv
        have hu := u.isLt
        omega
      · intro eq
        have he := congrArg Fin.val eq
        change min v.val u.val = u.val at he
        omega
    · rw [if_neg h]
      constructor
      · intro _
        apply Fin.ext
        change min v.val u.val = u.val
        omega
      · intro _
        rfl

/-- Fixed edge facts and the distance-zero source in row-major relation order. -/
def distanceInputs (i : Fin 21) : Cost :=
  match i.val with
  | 1 => ⟨7, by decide⟩
  | 2 => ⟨2, by decide⟩
  | 7 => ⟨3, by decide⟩
  | 9 => ⟨1, by decide⟩
  | 14 => ⟨0, by decide⟩
  | 16 => ⟨0, by decide⟩
  | 20 => ⟨0, by decide⟩
  | _ => infinity

/-- Grounding of `dist(y) :- dist(x), edge(x,y)` over four vertices. -/
def distanceRules : List (ProductRule 21) :=
  (List.finRange 4).flatMap fun x => (List.finRange 4).map fun y =>
    { output := ⟨16 + y.val, by omega⟩
      left := ⟨16 + x.val, by omega⟩
      right := ⟨4 * x.val + y.val, by omega⟩ }

/-- The four-vertex recursive distance program, including fixed edge coordinates. -/
def distanceProgram : Program Cost 21 := ⟨distanceInputs, distanceRules⟩

set_option maxRecDepth 8192 in
/-- Kernel-checked convergence of the recursive distance program within its scalar bound. -/
def distanceCertificate : Certificate boundedMinPlus distanceProgram 21 where
  rounds := 4
  within := by decide
  fixed := by decide

/-- The four-round valuation is the least solution of the supplied distance equations. -/
theorem distance_least :
    step boundedMinPlus distanceProgram (iterate boundedMinPlus distanceProgram 4) =
      iterate boundedMinPlus distanceProgram 4 ∧
    ∀ y, step boundedMinPlus distanceProgram y = y →
      StateLe boundedMinPlus (iterate boundedMinPlus distanceProgram 4) y :=
  certificate_least boundedMinPlus distanceProgram 21 distanceCertificate

set_option maxRecDepth 8192 in
/-- The distances from vertex zero are respectively zero, three, two and six. -/
theorem distance_values :
    ((List.finRange 4).map fun i =>
      (iterate boundedMinPlus distanceProgram 4 ⟨16 + i.val, by omega⟩).val) = [0, 3, 2, 6] := by
  decide

end WeightedRules
