import Mathlib.Data.Nat.Choose.Basic
import Mathlib.Data.Nat.Choose.Sum
import Mathlib.FieldTheory.Finite.Basic
import Mathlib.Tactic

/-!
# Finite-root invariants in one binary weight slice

A vector in the binary weight slice of width `h` is represented by the homogeneous polynomial

`sum_m alpha_m x^m y^(h-m)`.

The upper root acts by simultaneous translation `(x,y) -> (x+t,y+t)`.  Over a finite field with
`h < #K`, invariance under every finite root parameter forces the polynomial to be a scalar
multiple of `(y-x)^h`.  Equivalently, its coefficient vector is a scalar multiple of the
alternating-binomial vector.

The proof uses only the displayed action and degree-bounded polynomial interpolation.  It gives an
exact fixed-space basis for the concrete weight-slice model; no highest-weight classification or
divided-power construction is used.
-/

namespace RelativeConicArcs.ClebschFiniteRootWeightSlice

open Finset Polynomial

noncomputable section

variable {K : Type*} [Field K]

/-- The alternating-binomial coordinate in a binary weight slice. -/
def weightSliceAlternatingCoefficient (h m : ℕ) : K :=
  (-1 : K) ^ m * (Nat.choose h m : K)

/-- The homogeneous binary form represented by a coefficient vector in the width-`h` weight
slice. -/
def weightSliceValue (h : ℕ) (alpha : Fin (h + 1) → K) (x y : K) : K :=
  ∑ m : Fin (h + 1), alpha m * x ^ (m : ℕ) * y ^ (h - (m : ℕ))

/-- The ordinary polynomial obtained by setting the second binary variable equal to one. -/
def weightSlicePolynomial (h : ℕ) (alpha : Fin (h + 1) → K) : K[X] :=
  ∑ m : Fin (h + 1), monomial (m : ℕ) (alpha m)

/-- Evaluating the ordinary weight-slice polynomial agrees with evaluating the homogeneous form
at `(x,1)`. -/
theorem eval_weightSlicePolynomial (h : ℕ) (alpha : Fin (h + 1) → K) (x : K) :
    (weightSlicePolynomial h alpha).eval x = weightSliceValue h alpha x 1 := by
  classical
  rw [weightSlicePolynomial, eval_finsetSum]
  simp [weightSliceValue]

/-- The coefficient of the ordinary weight-slice polynomial at an index inside the slice is the
corresponding vector coordinate. -/
theorem coeff_weightSlicePolynomial (h : ℕ) (alpha : Fin (h + 1) → K)
    (m : Fin (h + 1)) :
    (weightSlicePolynomial h alpha).coeff m = alpha m := by
  classical
  rw [weightSlicePolynomial, finsetSum_coeff]
  rw [Finset.sum_eq_single_of_mem m (Finset.mem_univ m)]
  · rw [coeff_monomial, if_pos rfl]
  · intro b _ hbm
    by_cases heq : (b : ℕ) = (m : ℕ)
    · exact (hbm (Fin.ext heq)).elim
    · rw [coeff_monomial, if_neg (fun hmb => heq hmb)]

/-- The weight-slice polynomial has degree at most its width. -/
theorem natDegree_weightSlicePolynomial_le (h : ℕ) (alpha : Fin (h + 1) → K) :
    (weightSlicePolynomial h alpha).natDegree ≤ h := by
  rw [weightSlicePolynomial]
  apply natDegree_sum_le_of_forall_le
  intro m _
  exact (natDegree_monomial_le (alpha m)).trans (by omega)

/-- Setting the second homogeneous variable to zero leaves only the last coordinate. -/
theorem weightSliceValue_zero_second (h : ℕ) (alpha : Fin (h + 1) → K) (x : K) :
    weightSliceValue h alpha x 0 = alpha ⟨h, Nat.lt_succ_self h⟩ * x ^ h := by
  classical
  rw [weightSliceValue]
  rw [Finset.sum_eq_single_of_mem ⟨h, Nat.lt_succ_self h⟩ (Finset.mem_univ _)]
  · simp
  · intro m _ hne
    have hmlt : (m : ℕ) < h := by
      have hmle : (m : ℕ) ≤ h := by omega
      exact lt_of_le_of_ne hmle (fun heq => hne (Fin.ext heq))
    have hsub : 0 < h - (m : ℕ) := Nat.sub_pos_of_lt hmlt
    rw [zero_pow (Nat.ne_of_gt hsub)]
    simp

/-- Finite upper-root invariance of a homogeneous weight-slice vector. -/
def FiniteRootInvariant (h : ℕ) (alpha : Fin (h + 1) → K) : Prop :=
  ∀ x y t : K,
    weightSliceValue h alpha (x + t) (y + t) = weightSliceValue h alpha x y

/-- The alternating-binomial vector represents `(y-x)^h`. -/
theorem weightSliceValue_alternatingBinomial (h : ℕ) (x y : K) :
    weightSliceValue h
      (fun m => weightSliceAlternatingCoefficient (K := K) h m) x y = (y - x) ^ h := by
  classical
  have hbinomial := add_pow (-x) y h
  rw [add_comm (-x) y] at hbinomial
  rw [weightSliceValue]
  calc
    (∑ m : Fin (h + 1),
        weightSliceAlternatingCoefficient (K := K) h m * x ^ (m : ℕ) *
          y ^ (h - (m : ℕ))) =
        ∑ m : Fin (h + 1),
          (-x) ^ (m : ℕ) * y ^ (h - (m : ℕ)) * (Nat.choose h m : K) := by
      apply Finset.sum_congr rfl
      intro m _
      rw [weightSliceAlternatingCoefficient, neg_pow]
      ring
    _ = ∑ m ∈ Finset.range (h + 1),
        (-x) ^ m * y ^ (h - m) * (Nat.choose h m : K) :=
      Fin.sum_univ_eq_sum_range
        (fun m : ℕ => (-x) ^ m * y ^ (h - m) * (Nat.choose h m : K)) (h + 1)
    _ = (y - x) ^ h := by simpa [sub_eq_add_neg] using hbinomial.symm

/-- The alternating-binomial vector is fixed by every simultaneous translation. -/
theorem alternatingBinomial_finiteRootInvariant (h : ℕ) :
    FiniteRootInvariant h
      (fun m => weightSliceAlternatingCoefficient (K := K) h m) := by
  intro x y t
  rw [weightSliceValue_alternatingBinomial, weightSliceValue_alternatingBinomial]
  congr 1
  ring

/-- The coefficientwise positive-root equation on a binary weight slice. -/
def SatisfiesWeightSliceRecurrence (h : ℕ) (alpha : Fin (h + 1) → K) : Prop :=
  ∀ m : Fin h,
    ((m + 1 : ℕ) : K) * alpha ⟨m + 1, by omega⟩ =
      -((h - m : ℕ) : K) * alpha ⟨m, by omega⟩

/-- The coefficient vector of `(y-x)^h` satisfies the positive-root recurrence. -/
theorem alternatingBinomial_satisfiesWeightSliceRecurrence (h : ℕ) :
    SatisfiesWeightSliceRecurrence h
      (fun m => weightSliceAlternatingCoefficient (K := K) h m) := by
  intro m
  change (((m : ℕ) + 1 : ℕ) : K) *
      weightSliceAlternatingCoefficient (K := K) h ((m : ℕ) + 1) =
    -((h - (m : ℕ) : ℕ) : K) *
      weightSliceAlternatingCoefficient (K := K) h m
  have hchoose := Nat.choose_succ_right_eq h (m : ℕ)
  have hchooseK :
      (Nat.choose h ((m : ℕ) + 1) : K) * (((m : ℕ) + 1 : ℕ) : K) =
        (Nat.choose h m : K) * ((h - (m : ℕ) : ℕ) : K) := by
    have hcast := congrArg (fun n : ℕ => (n : K)) hchoose
    simpa only [Nat.cast_mul] using hcast
  rw [weightSliceAlternatingCoefficient, weightSliceAlternatingCoefficient, pow_succ]
  calc
    (((m : ℕ) + 1 : ℕ) : K) *
          (((-1 : K) ^ (m : ℕ) * -1) * (Nat.choose h ((m : ℕ) + 1) : K)) =
        -((-1 : K) ^ (m : ℕ)) *
          ((Nat.choose h ((m : ℕ) + 1) : K) * (((m : ℕ) + 1 : ℕ) : K)) := by ring
    _ = -((-1 : K) ^ (m : ℕ)) *
          ((Nat.choose h m : K) * ((h - (m : ℕ) : ℕ) : K)) := by rw [hchooseK]
    _ = -((h - (m : ℕ) : ℕ) : K) *
          ((-1 : K) ^ (m : ℕ) * (Nat.choose h m : K)) := by ring

section FiniteField

variable [Fintype K]

/-- In width below the field cardinality, every finite-root-invariant vector is a scalar multiple
of the alternating-binomial vector. -/
theorem finiteRootInvariant_eq_scalar_alternatingBinomial
    (h : ℕ) (hh : h < Fintype.card K) (alpha : Fin (h + 1) → K)
    (hinvariant : FiniteRootInvariant h alpha) :
    ∃ c : K, ∀ m,
      alpha m = c * weightSliceAlternatingCoefficient (K := K) h m := by
  let last : Fin (h + 1) := ⟨h, Nat.lt_succ_self h⟩
  let canonical : Fin (h + 1) → K :=
    fun m => weightSliceAlternatingCoefficient (K := K) h m
  let c : K := alpha last * (-1 : K) ^ h
  have heval : ∀ x : K,
      (weightSlicePolynomial h alpha).eval x =
        (c • weightSlicePolynomial h canonical).eval x := by
    intro x
    rw [eval_weightSlicePolynomial]
    have htranslate := hinvariant (x - 1) 0 1
    simp only [zero_add, sub_add_cancel] at htranslate
    rw [htranslate, weightSliceValue_zero_second]
    rw [eval_smul, eval_weightSlicePolynomial]
    rw [weightSliceValue_alternatingBinomial]
    change alpha last * (x - 1) ^ h =
      (alpha last * (-1 : K) ^ h) * (1 - x) ^ h
    rw [show (1 - x) ^ h = (-1 : K) ^ h * (x - 1) ^ h by
      rw [show 1 - x = -(x - 1) by ring, neg_pow]]
    have hsquare : (-1 : K) ^ h * (-1 : K) ^ h = 1 := by
      rw [← mul_pow]
      simp
    calc
      alpha last * (x - 1) ^ h = alpha last * 1 * (x - 1) ^ h := by ring
      _ = alpha last * ((-1 : K) ^ h * (-1 : K) ^ h) * (x - 1) ^ h := by rw [hsquare]
      _ = (alpha last * (-1 : K) ^ h) * ((-1 : K) ^ h * (x - 1) ^ h) := by
        ac_rfl
  have hpoly : weightSlicePolynomial h alpha = c • weightSlicePolynomial h canonical := by
    apply Polynomial.eq_of_natDegree_lt_card_of_eval_eq
      _ _ Function.injective_id heval
    exact max_lt
      (lt_of_le_of_lt (natDegree_weightSlicePolynomial_le h alpha) hh)
      (lt_of_le_of_lt
        ((natDegree_smul_le c (weightSlicePolynomial h canonical)).trans
          (natDegree_weightSlicePolynomial_le h canonical)) hh)
  refine ⟨c, ?_⟩
  intro m
  have hcoeff := congrArg (fun P : K[X] => P.coeff m) hpoly
  simpa [coeff_weightSlicePolynomial, canonical] using hcoeff

/-- In width below the field cardinality, the concrete finite-root action implies the same
coefficient recurrence used by the one-digit root-equation model. -/
theorem finiteRootInvariant_satisfiesWeightSliceRecurrence
    (h : ℕ) (hh : h < Fintype.card K) (alpha : Fin (h + 1) → K)
    (hinvariant : FiniteRootInvariant h alpha) :
    SatisfiesWeightSliceRecurrence h alpha := by
  obtain ⟨c, hc⟩ := finiteRootInvariant_eq_scalar_alternatingBinomial h hh alpha hinvariant
  intro m
  rw [hc, hc]
  have hcanonical := alternatingBinomial_satisfiesWeightSliceRecurrence (K := K) h m
  calc
    ((m + 1 : ℕ) : K) *
          (c * weightSliceAlternatingCoefficient (K := K) h ((m : ℕ) + 1)) =
        c * (((m + 1 : ℕ) : K) *
          weightSliceAlternatingCoefficient (K := K) h ((m : ℕ) + 1)) := by ring
    _ = c * (-((h - m : ℕ) : K) *
          weightSliceAlternatingCoefficient (K := K) h m) := by rw [hcanonical]
    _ = -((h - m : ℕ) : K) *
          (c * weightSliceAlternatingCoefficient (K := K) h m) := by ring

/-- The concrete finite-root fixed space is exactly the scalar line generated by the
alternating-binomial vector. -/
theorem finiteRootInvariant_iff_exists_scalar_alternatingBinomial
    (h : ℕ) (hh : h < Fintype.card K) (alpha : Fin (h + 1) → K) :
    FiniteRootInvariant h alpha ↔
      ∃ c : K, alpha = fun m : Fin (h + 1) =>
        c * weightSliceAlternatingCoefficient (K := K) h m := by
  constructor
  · intro hinvariant
    obtain ⟨c, hc⟩ := finiteRootInvariant_eq_scalar_alternatingBinomial h hh alpha hinvariant
    exact ⟨c, funext hc⟩
  · rintro ⟨c, rfl⟩
    intro x y t
    have hscale (a b : K) :
        weightSliceValue h
            (fun m : Fin (h + 1) =>
              c * weightSliceAlternatingCoefficient (K := K) h m) a b =
          c * weightSliceValue h
            (fun m => weightSliceAlternatingCoefficient (K := K) h m) a b := by
      rw [weightSliceValue, weightSliceValue, Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro m _
      ring
    rw [hscale, hscale]
    exact congrArg (c * ·) (alternatingBinomial_finiteRootInvariant h x y t)

end FiniteField

end

end RelativeConicArcs.ClebschFiniteRootWeightSlice
