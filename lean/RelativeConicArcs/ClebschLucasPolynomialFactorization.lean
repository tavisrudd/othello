import Mathlib.Algebra.Polynomial.Expand
import Mathlib.Tactic

/-!
# Digitwise coefficients of Frobenius-expanded polynomial products

Let `p > 0`.  If `P` has degree below `p`, then the coefficient of degree `m + p*n` in

`P(X) * Q(X^p)`

is `P_m Q_n` whenever `m < p`.  Indeed, a contributing exponent from `P` is below `p`, while an
exponent from `Q(X^p)` is divisible by `p`; their sum has a unique base-`p` zeroth digit.

Iterating this identity proves the digitwise coefficient factorization for a list of polynomial
factors.  This is the polynomial form of the Lucas no-carry mechanism.  It is valid over every
commutative semiring and does not use a representation-theoretic decomposition.
-/

namespace RelativeConicArcs.ClebschLucasPolynomialFactorization

open Polynomial Finset

noncomputable section

variable {R : Type*} [CommSemiring R]

/-- The coefficient at `m + p*n` in `P(X)Q(X^p)` factors when `P` and the zeroth digit `m` both
have size below `p`. -/
theorem coeff_mul_expand_at_digit {p m n : ℕ} (hp : 0 < p) (hm : m < p)
    (P Q : R[X]) (hP : P.natDegree < p) :
    (P * expand R p Q).coeff (m + p * n) = P.coeff m * Q.coeff n := by
  rw [coeff_mul]
  calc
    ∑ x ∈ antidiagonal (m + p * n), P.coeff x.1 * (expand R p Q).coeff x.2 =
        P.coeff m * (expand R p Q).coeff (p * n) := by
      apply Finset.sum_eq_single (m, p * n)
      · intro index hindex hne
        rcases index with ⟨i, j⟩
        simp only [Finset.mem_antidiagonal] at hindex
        by_cases hi : i < p
        · have hjNotDvd : ¬p ∣ j := by
            intro hj
            obtain ⟨c, rfl⟩ := hj
            have hmod := congrArg (fun a : ℕ => a % p) hindex
            have him : i = m := by
              simpa [Nat.add_mod, Nat.mul_mod, Nat.mod_eq_of_lt hi,
                Nat.mod_eq_of_lt hm] using hmod
            subst i
            have hpc : p * c = p * n := Nat.add_left_cancel hindex
            have hc : c = n := by nlinarith [hpc]
            apply hne
            subst c
            rfl
          rw [coeff_expand hp, if_neg hjNotDvd, mul_zero]
        · have hPi : P.natDegree < i := lt_of_lt_of_le hP (Nat.le_of_not_gt hi)
          rw [coeff_eq_zero_of_natDegree_lt hPi, zero_mul]
      · intro hmissing
        simp at hmissing
    _ = P.coeff m * Q.coeff n := by rw [coeff_expand_mul' hp]

/-- Base-`p` value of a least-significant-digit-first list. -/
def digitValue (p : ℕ) : List ℕ → ℕ
  | [] => 0
  | m :: ms => m + p * digitValue p ms

/-- Iterated Frobenius expansion of a least-significant-factor-first polynomial list. -/
def expandedProduct (R : Type*) [CommSemiring R] (p : ℕ) : List R[X] → R[X]
  | [] => 1
  | P :: Ps => P * expand R p (expandedProduct R p Ps)

/-- Product of selected coefficients from parallel least-significant-digit-first lists.  A missing
polynomial or digit contributes no coefficient, so the definition is used only with equal-length
lists in the factorization theorem. -/
def selectedCoefficientProduct : List R[X] → List ℕ → R
  | [], [] => 1
  | P :: Ps, m :: ms => P.coeff m * selectedCoefficientProduct Ps ms
  | _, _ => 0

/-- Coefficients of an iterated Frobenius-expanded product factor digitwise when the polynomial
degrees and selected digits are all below `p`. -/
theorem coeff_expandedProduct_digitValue
    {p : ℕ} (hp : 0 < p) :
    ∀ (Ps : List R[X]) (ms : List ℕ), Ps.length = ms.length →
      (∀ P ∈ Ps, P.natDegree < p) → (∀ m ∈ ms, m < p) →
        (expandedProduct R p Ps).coeff (digitValue p ms) =
          selectedCoefficientProduct Ps ms := by
  intro Ps
  induction Ps with
  | nil =>
      intro ms hlength _ _
      have hms : ms = [] := List.eq_nil_of_length_eq_zero (by simpa using hlength.symm)
      subst ms
      simp [expandedProduct, digitValue, selectedCoefficientProduct]
  | cons P Ps ih =>
      intro ms hlength hdegrees hdigits
      cases ms with
      | nil => simp at hlength
      | cons m ms =>
        have htailLength : Ps.length = ms.length := by simpa using hlength
        have hP : P.natDegree < p := hdegrees P (by simp)
        have hm : m < p := hdigits m (by simp)
        have htailDegrees : ∀ Q ∈ Ps, Q.natDegree < p := by
          intro Q hQ
          exact hdegrees Q (List.mem_cons_of_mem P hQ)
        have htailDigits : ∀ a ∈ ms, a < p := by
          intro a ha
          exact hdigits a (List.mem_cons_of_mem m ha)
        simp only [expandedProduct, digitValue, selectedCoefficientProduct]
        rw [coeff_mul_expand_at_digit hp hm P (expandedProduct R p Ps) hP]
        rw [ih ms htailLength htailDegrees htailDigits]

end

end RelativeConicArcs.ClebschLucasPolynomialFactorization
