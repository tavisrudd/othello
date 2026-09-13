import WeightedRules.BoundedMinPlus
import WeightedRules.OrderedConvergence

/-!
# Scalar-round convergence of bounded min-plus rules

A grounded program with `n` scalar coordinates reaches its least fixed point
after at most `n` synchronous iterations from infinity. Rules may be cyclic,
and both factors of a product may refer to the same coordinate. Addition of
costs saturates at `2^32 - 1`, with the same sentinel convention as the scalar
algebra.

Bounded min-plus is an ordered inflationary algebra under the numerical cost
order: alternatives select the minimum and a saturated nonnegative sum lies
above both summands. The theorems below instantiate the generic counting
argument of `WeightedRules.OrderedInflationary` and restate it in terms of
numerical cost values. All proofs use ordinary kernel-checked terms.
-/

namespace WeightedRules

variable {n : Nat}

/-- Bounded min-plus is ordered inflationary under the numerical cost order. -/
theorem boundedMinPlus_orderedInflationary : OrderedInflationary boundedMinPlus where
  add_min a b := by
    rcases le_total a b with hab | hab
    · rw [min_eq_left hab]
      apply Fin.ext
      have := Fin.le_def.mp hab
      change min a.val b.val = a.val
      omega
    · rw [min_eq_right hab]
      apply Fin.ext
      have := Fin.le_def.mp hab
      change min a.val b.val = b.val
      omega
  le_mul_left a b := by
    rw [Fin.le_def]
    have := a.isLt
    change a.val ≤ min 4294967295 (a.val + b.val)
    omega
  le_mul_right a b := by
    rw [Fin.le_def]
    have := b.isLt
    change b.val ≤ min 4294967295 (a.val + b.val)
    omega

/-- Numerical costs never increase along from-zero bounded min-plus iteration. -/
theorem boundedMinPlus_iterate_succ_cost (P : Program Cost n) (k : Nat) (i : Fin n) :
    (iterate boundedMinPlus P (k + 1) i).val ≤
      (iterate boundedMinPlus P k i).val :=
  Fin.le_def.mp (boundedMinPlus_orderedInflationary.iterate_succ_le P k i)

/-- A strict step improvement occurs at a rule output and has an improving
prior coordinate whose cost is no greater than the new output cost. -/
theorem boundedMinPlus_step_improvement (P : Program Cost n) (x y : State Cost n) (i : Fin n)
    (h : (step boundedMinPlus P x i).val < (step boundedMinPlus P y i).val) :
    i ∈ P.rules.map (·.output) ∧
      ∃ j, (x j).val < (y j).val ∧ (x j).val ≤ (step boundedMinPlus P x i).val := by
  obtain ⟨hi, j, hj, hjc⟩ :=
    boundedMinPlus_orderedInflationary.step_improvement P x y i (Fin.lt_def.mpr h)
  exact ⟨hi, j, Fin.lt_def.mp hj, Fin.le_def.mp hjc⟩

/-- A strict improvement in round `k + 1` requires at least `k + 1` scalar
coordinates, independently of the number of rules and of represented costs. -/
theorem boundedMinPlus_improvement_round_le (P : Program Cost n) (k : Nat) (i : Fin n)
    (h : (iterate boundedMinPlus P (k + 1) i).val <
      (iterate boundedMinPlus P k i).val) : k + 1 ≤ n :=
  boundedMinPlus_orderedInflationary.improvement_round_le P k i (Fin.lt_def.mpr h)

/-- Every bounded min-plus program is fixed after `n` rounds, where `n` counts
all scalar coordinates, including fixed inputs. The statement includes `n = 0`. -/
theorem boundedMinPlus_iterate_fixed (P : Program Cost n) :
    step boundedMinPlus P (iterate boundedMinPlus P n) =
      iterate boundedMinPlus P n :=
  boundedMinPlus_orderedInflationary.iterate_fixed P

/-- Every iteration after the scalar bound equals the valuation at that bound. -/
theorem boundedMinPlus_iterate_add (P : Program Cost n) (k : Nat) :
    iterate boundedMinPlus P (n + k) = iterate boundedMinPlus P n :=
  boundedMinPlus_orderedInflationary.iterate_add P k

/-- Every bounded min-plus program admits a convergence certificate with the
scalar count as its round bound; existence does not require an external solver. -/
def boundedMinPlusCertificate (P : Program Cost n) : Certificate boundedMinPlus P n :=
  boundedMinPlus_orderedInflationary.certificate P

/-- The valuation after the scalar-count number of rounds is the least solution
in information order, equivalently the greatest numerical fixed valuation. -/
theorem boundedMinPlus_iterate_least (P : Program Cost n) :
    step boundedMinPlus P (iterate boundedMinPlus P n) =
      iterate boundedMinPlus P n ∧
    ∀ y, step boundedMinPlus P y = y → StateLe boundedMinPlus
      (iterate boundedMinPlus P n) y :=
  certificate_least boundedMinPlus P n (boundedMinPlusCertificate P)

end WeightedRules
