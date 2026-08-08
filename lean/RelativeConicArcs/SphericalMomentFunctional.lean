import Mathlib.Algebra.BigOperators.Field
import Mathlib.RingTheory.MvPolynomial.EulerIdentity
import Mathlib.Data.Nat.Factorial.Basic
import Mathlib.Data.Real.Basic

/-!
# The Gaussian moment functional on real ternary forms

Throughout, the ambient ring is `MvPolynomial (Fin 3) ℝ`, the polynomial ring in
the three variables `X 0`, `X 1`, `X 2` over the reals.  The module introduces
one linear functional on that ring, `gaussianMoment`, defined by the explicit
formula

```
gaussianMoment (X 0 ^ a₀ * X 1 ^ a₁ * X 2 ^ a₂) = (a₀ - 1)‼ * (a₁ - 1)‼ * (a₂ - 1)‼
```

on monomials, where `(-1)‼ = 1` and where the double factorial of an even
argument is set to zero, so that a monomial with an odd exponent is annihilated.
The double factorial is `momentFactor`, and `normalizedMean d p
= gaussianMoment p / (d + 1)‼` rescales a form of degree `d` by the divisor that
makes the degree-zero constant one have normalized mean one and makes multiplication by
`X 0 ^ 2 + X 1 ^ 2 + X 2 ^ 2` leave the normalized mean unchanged.

## Scope and trust boundary

`gaussianMoment` and `normalizedMean` are defined here by the displayed monomial
formula and by nothing else.  No statement in this module asserts, uses, or
depends on the classical identification of `normalizedMean` with the normalized
surface integral over the unit two-sphere; that identification is a separate
analytic statement, it is not formalized here, and no theorem below may be read
as a theorem about an integral.  Nothing in the module imports measure theory.

## Main results

* `gaussianMoment_X_mul`: the integration-by-parts recursion
  `gaussianMoment (X i * p) = gaussianMoment (pderiv i p)`.
* `eq_gaussianMoment_of_recursion`: that recursion together with the
  normalization `L 1 = 1` determines a linear functional uniquely.
* `gaussianMoment_comp_linearSubstitution`: invariance under a substitution by an
  orthogonal matrix.
* `normalizedMean_sum` and `normalizedMean_C_mul`: linearity of the normalized
  mean at a fixed degree.
* `gaussianMoment_quadric_mul` and `normalizedMean_quadric_mul`: multiplying a
  form of degree `d` by `X 0 ^ 2 + X 1 ^ 2 + X 2 ^ 2` multiplies the functional
  by `d + 3` and leaves the normalized mean unchanged.
* `gaussianMoment_mul_of_isHomogeneous`: the identity
  `d * gaussianMoment (p * q) = gaussianMoment (laplacian p * q)
      + ∑ i, gaussianMoment (pderiv i p * pderiv i q)`
  for `p` homogeneous of degree `d`.
* `gaussianMoment_mul_eq_zero_of_laplacian_eq_zero` and
  `gaussianMoment_mul_linearForm_pow`: for `p` with vanishing Laplacian and
  homogeneous of degree `d`, the functional kills `p * q` for every form `q` of
  degree below `d`, and on the degree-`d` power of a linear form `∑ i, w i * X i`
  it returns `d ! * eval w p`.  The general apolarity identity expressing
  `gaussianMoment (p * q)` through the differential operator `p (∂)` is not
  stated or used.
-/

namespace RelativeConicArcs.SphericalMomentFunctional

open Finset MvPolynomial

/-- The double factorial `(n - 1)‼` of the predecessor of `n`, with `(-1)‼ = 1`
and with the value at `n = 1` set to zero rather than to `0‼ = 1`.  That choice
is what makes `gaussianMoment` vanish on a monomial with an odd exponent without
a parity case distinction: the recursion `momentFactor (n + 2) = (n + 1) *
momentFactor n` then propagates the zero through every odd argument. -/
def momentFactor : ℕ → ℝ
  | 0 => 1
  | 1 => 0
  | (n + 2) => ((n : ℝ) + 1) * momentFactor n

/-- The empty double factorial `(-1)‼` is one. -/
@[simp] lemma momentFactor_zero : momentFactor 0 = 1 := by simp [momentFactor]

/-- The value at one is zero, which is the convention that makes odd exponents
vanish; it is not the classical `0‼ = 1`. -/
@[simp] lemma momentFactor_one : momentFactor 1 = 0 := by simp [momentFactor]

/-- The defining recursion of the double factorial of the predecessor. -/
lemma momentFactor_add_two (n : ℕ) :
    momentFactor (n + 2) = ((n : ℝ) + 1) * momentFactor n := by
  simp [momentFactor]

/-- The recursion in the form used to verify the integration-by-parts identity:
raising the argument by one past `n` multiplies the double factorial of the
predecessor by `n`.  At `n = 0` both sides vanish because `momentFactor 1 = 0`. -/
lemma momentFactor_succ (n : ℕ) : momentFactor (n + 1) = (n : ℝ) * momentFactor (n - 1) := by
  cases n with
  | zero => simp
  | succ m => simp [momentFactor_add_two, Nat.cast_succ]

/-- The value of the Gaussian moment functional on the monomial with exponent
vector `a` and coefficient one: the product over the three variables of the
double factorial of the predecessor of the exponent. -/
noncomputable def momentWeight (a : Fin 3 →₀ ℕ) : ℝ := ∏ i, momentFactor (a i)

/-- The monomial weight of the constant monomial is one. -/
@[simp] lemma momentWeight_zero : momentWeight 0 = 1 := by simp [momentWeight]

/-- Adjoining one to the `i`-th exponent multiplies the monomial weight by that
exponent and removes one from it instead.  This is the monomial form of the
integration-by-parts recursion. -/
private lemma momentWeight_single_add (i : Fin 3) (a : Fin 3 →₀ ℕ) :
    momentWeight (Finsupp.single i 1 + a) = (a i : ℝ) * momentWeight (a - Finsupp.single i 1) := by
  have hcongr : ∀ x ∈ Finset.univ.erase i,
      momentFactor ((Finsupp.single i 1 + a : Fin 3 →₀ ℕ) x) =
        momentFactor ((a - Finsupp.single i 1 : Fin 3 →₀ ℕ) x) := by
    intro x hx
    have hxi : x ≠ i := Finset.ne_of_mem_erase hx
    simp [hxi]
  have hi : (Finsupp.single i 1 + a : Fin 3 →₀ ℕ) i = a i + 1 := by
    simp [Nat.add_comm]
  have hi' : (a - Finsupp.single i 1 : Fin 3 →₀ ℕ) i = a i - 1 := by
    simp
  rw [momentWeight, momentWeight,
    ← Finset.mul_prod_erase _ _ (Finset.mem_univ i),
    ← Finset.mul_prod_erase _ _ (Finset.mem_univ i),
    Finset.prod_congr rfl hcongr, hi, hi', momentFactor_succ]
  ring

/-- The Gaussian moment functional on real ternary forms: the `ℝ`-linear map that
sends the monomial with exponent vector `a` to `momentWeight a`.  It is defined
by this monomial formula alone; see the module header for the trust boundary. -/
noncomputable def gaussianMoment : MvPolynomial (Fin 3) ℝ →ₗ[ℝ] ℝ :=
  (Finsupp.linearCombination ℝ momentWeight).comp
    (AddMonoidAlgebra.coeffLinearEquiv (S := ℝ) (M := Fin 3 →₀ ℕ) ℝ).toLinearMap

/-- The defining formula: on the monomial with exponent vector `a` and
coefficient `c` the Gaussian moment functional returns `c * momentWeight a`. -/
@[simp] lemma gaussianMoment_monomial (a : Fin 3 →₀ ℕ) (c : ℝ) :
    gaussianMoment (monomial a c) = c * momentWeight a := by
  have hcoeff : (AddMonoidAlgebra.coeffLinearEquiv (S := ℝ) (M := Fin 3 →₀ ℕ) ℝ) (monomial a c)
      = Finsupp.single a c := rfl
  simp [gaussianMoment, hcoeff, Finsupp.linearCombination_single]

/-- The Gaussian moment functional returns a constant unchanged. -/
@[simp] lemma gaussianMoment_C (c : ℝ) : gaussianMoment (C c) = c := by
  rw [MvPolynomial.C_apply, gaussianMoment_monomial, momentWeight_zero, mul_one]

/-- The Gaussian moment functional is normalized: it sends the constant one to
one. -/
theorem gaussianMoment_one : gaussianMoment 1 = 1 := by
  simpa using gaussianMoment_C 1

/-- A constant factor passes through the Gaussian moment functional. -/
lemma gaussianMoment_C_mul (c : ℝ) (p : MvPolynomial (Fin 3) ℝ) :
    gaussianMoment (C c * p) = c * gaussianMoment p := by
  rw [MvPolynomial.C_mul', map_smul, smul_eq_mul]

/-- Integration by parts.  Multiplying by the variable `X i` and applying the
Gaussian moment functional is the same as differentiating with respect to `X i`
and applying it.  This is the algebraic shadow of the Gaussian integration-by-parts
formula, proved here directly from the monomial definition. -/
theorem gaussianMoment_X_mul (i : Fin 3) (p : MvPolynomial (Fin 3) ℝ) :
    gaussianMoment (X i * p) = gaussianMoment (pderiv i p) := by
  induction p using MvPolynomial.induction_on' with
  | monomial a c =>
    rw [MvPolynomial.X, monomial_mul, one_mul, pderiv_monomial, gaussianMoment_monomial,
      gaussianMoment_monomial, momentWeight_single_add]
    ring
  | add p q hp hq => rw [mul_add, map_add, map_add, map_add, hp, hq]

/-- Removing one from an exponent cannot raise the total degree. -/
private lemma sum_sub_single_le (i : Fin 3) (a : Fin 3 →₀ ℕ) :
    ∑ j, (a - Finsupp.single i 1 : Fin 3 →₀ ℕ) j ≤ ∑ j, a j :=
  Finset.sum_le_sum fun j _ => by simp

/-- Removing one from an exponent that is present lowers the total degree by
exactly one. -/
private lemma sum_sub_single_succ (i : Fin 3) (a : Fin 3 →₀ ℕ) (h : a i ≠ 0) :
    (∑ j, (a - Finsupp.single i 1 : Fin 3 →₀ ℕ) j) + 1 = ∑ j, a j := by
  have key : ∀ j : Fin 3,
      (a - Finsupp.single i 1 : Fin 3 →₀ ℕ) j + (if j = i then 1 else 0) = a j := by
    intro j
    by_cases hj : j = i
    · subst hj
      have hval : (a - Finsupp.single j 1 : Fin 3 →₀ ℕ) j = a j - 1 := by simp
      rw [hval, if_pos rfl]
      omega
    · simp [hj]
  calc (∑ j, (a - Finsupp.single i 1 : Fin 3 →₀ ℕ) j) + 1
      = ∑ j, ((a - Finsupp.single i 1 : Fin 3 →₀ ℕ) j + (if j = i then 1 else 0)) := by
        rw [Finset.sum_add_distrib]; simp
    _ = ∑ j, a j := Finset.sum_congr rfl fun j _ => key j

/-- Normalization and the integration-by-parts recursion characterize the
Gaussian moment functional.  Any `ℝ`-linear functional `L` on real ternary forms
with `L 1 = 1` and `L (X i * p) = L (pderiv i p)` for all `i` and `p` is
`gaussianMoment`.  The proof is an induction on the total degree of a monomial:
a monomial of positive degree is `X i` times a monomial of degree one lower for
any variable `X i` occurring in it, and differentiating that smaller monomial
drops the degree again. -/
theorem eq_gaussianMoment_of_recursion (L : MvPolynomial (Fin 3) ℝ →ₗ[ℝ] ℝ)
    (hone : L 1 = 1)
    (hrec : ∀ (i : Fin 3) (p : MvPolynomial (Fin 3) ℝ), L (X i * p) = L (pderiv i p)) :
    L = gaussianMoment := by
  have hconst : ∀ c : ℝ, L (C c) = gaussianMoment (C c) := by
    intro c
    rw [gaussianMoment_C, MvPolynomial.C_eq_smul_one, map_smul, hone, smul_eq_mul, mul_one]
  have key : ∀ (n : ℕ) (a : Fin 3 →₀ ℕ), (∑ j, a j) ≤ n → ∀ c : ℝ,
      L (monomial a c) = gaussianMoment (monomial a c) := by
    intro n
    induction n with
    | zero =>
      intro a ha c
      have : a = 0 := by
        ext j
        have := (Finset.sum_eq_zero_iff.mp (Nat.le_zero.mp ha)) j (Finset.mem_univ j)
        simpa using this
      subst this
      simpa using hconst c
    | succ n ih =>
      intro a ha c
      by_cases h0 : ∀ j, a j = 0
      · have : a = 0 := by ext j; simpa using h0 j
        subst this
        simpa using hconst c
      · obtain ⟨i, hi⟩ : ∃ i, a i ≠ 0 := by
          by_contra hcon
          exact h0 fun j => not_not.mp (fun hj => hcon ⟨j, hj⟩)
        set b := a - Finsupp.single i 1 with hb
        have hab : Finsupp.single i 1 + b = a := by
          rw [hb, add_comm]
          exact Finsupp.sub_add_single_one_cancel hi
        have hbsum : (∑ j, b j) + 1 = ∑ j, a j := sum_sub_single_succ i a hi
        have hbound : (∑ j, (b - Finsupp.single i 1 : Fin 3 →₀ ℕ) j) ≤ n := by
          have h1 : (∑ j, (b - Finsupp.single i 1 : Fin 3 →₀ ℕ) j) ≤ ∑ j, b j :=
            sum_sub_single_le i b
          omega
        have hsplit : monomial a c = X i * monomial b c := by
          rw [MvPolynomial.X, monomial_mul, one_mul, hab]
        rw [hsplit, hrec, gaussianMoment_X_mul, pderiv_monomial]
        exact ih _ hbound _
  refine MvPolynomial.linearMap_ext fun a => LinearMap.ext fun c => ?_
  simpa using key (∑ j, a j) a le_rfl c

/-- The normalized mean of a form of degree `d`: the Gaussian moment divided by
`(d + 1)‼ = momentFactor (d + 2)`.  Two properties fix that divisor:
`normalizedMean 0 1 = 1`, and multiplying a form of degree `d` by
`X 0 ^ 2 + X 1 ^ 2 + X 2 ^ 2` leaves the normalized mean unchanged, which is
`normalizedMean_quadric_mul` below.  As with `gaussianMoment`, this is an
explicitly defined quotient of polynomial data and carries no analytic content;
see the module header. -/
noncomputable def normalizedMean (d : ℕ) (p : MvPolynomial (Fin 3) ℝ) : ℝ :=
  gaussianMoment p / momentFactor (d + 2)

/-- The normalized mean of a finite sum of forms is the sum of their normalized
means.  Both sides use the same degree `d`, so the identity is the linearity of
`gaussianMoment` followed by division by the fixed constant
`momentFactor (d + 2)`. -/
lemma normalizedMean_sum {ι : Type*} (d : ℕ) (s : Finset ι)
    (f : ι → MvPolynomial (Fin 3) ℝ) :
    normalizedMean d (∑ i ∈ s, f i) = ∑ i ∈ s, normalizedMean d (f i) := by
  simp only [normalizedMean, map_sum, Finset.sum_div]

/-- A constant factor passes through the normalized mean of a fixed degree. -/
lemma normalizedMean_C_mul (d : ℕ) (c : ℝ) (p : MvPolynomial (Fin 3) ℝ) :
    normalizedMean d (C c * p) = c * normalizedMean d p := by
  rw [normalizedMean, normalizedMean, gaussianMoment_C_mul, mul_div_assoc]

/-- The sum of the squares of the three variables. -/
noncomputable def quadric : MvPolynomial (Fin 3) ℝ := ∑ i, X i ^ 2

/-- The linear form `∑ i, w i * X i` attached to a coefficient vector `w`. -/
noncomputable def linearForm (w : Fin 3 → ℝ) : MvPolynomial (Fin 3) ℝ := ∑ i, C (w i) * X i

/-- The Laplacian `∑ i, ∂ᵢ ∘ ∂ᵢ` on real ternary forms, as an `ℝ`-linear
endomorphism of the polynomial ring. -/
noncomputable def laplacian : MvPolynomial (Fin 3) ℝ →ₗ[ℝ] MvPolynomial (Fin 3) ℝ :=
  ∑ i : Fin 3, (pderiv i).toLinearMap ∘ₗ (pderiv i).toLinearMap

/-- The Laplacian evaluated at a form is the sum over the three variables of the
second partial derivative along that variable. -/
lemma laplacian_apply (p : MvPolynomial (Fin 3) ℝ) :
    laplacian p = ∑ i, pderiv i (pderiv i p) := by
  simp [laplacian, LinearMap.sum_apply]

/-- The partial derivative of a linear form along `X i` is the constant `w i`. -/
@[simp] lemma pderiv_linearForm (w : Fin 3 → ℝ) (i : Fin 3) :
    pderiv i (linearForm w) = C (w i) := by
  rw [linearForm, map_sum, Finset.sum_eq_single i]
  · rw [pderiv_C_mul, pderiv_X_self, mul_one]
  · intro j _ hj
    rw [pderiv_C_mul, pderiv_X_of_ne hj, mul_zero]
  · intro h
    exact absurd (Finset.mem_univ i) h

/-- The partial derivative of the sum of the squares of the variables along
`X i` is `2 * X i`. -/
@[simp] lemma pderiv_quadric (i : Fin 3) : pderiv i quadric = 2 * X i := by
  rw [quadric, map_sum, Finset.sum_eq_single i]
  · rw [pderiv_pow, pderiv_X_self, mul_one]
    norm_num
  · intro j _ hj
    rw [pderiv_pow, pderiv_X_of_ne hj, mul_zero]
  · intro h
    exact absurd (Finset.mem_univ i) h

/-- A linear form is homogeneous of degree one. -/
lemma isHomogeneous_linearForm (w : Fin 3 → ℝ) : (linearForm w).IsHomogeneous 1 :=
  IsHomogeneous.sum _ _ _ fun i _ => isHomogeneous_C_mul_X (w i) i

/-- The sum of the squares of the variables is homogeneous of degree two. -/
lemma isHomogeneous_quadric : quadric.IsHomogeneous 2 :=
  IsHomogeneous.sum _ _ _ fun i _ => isHomogeneous_X_pow i 2

/-- Differentiating a form that is homogeneous of degree `d + 1` gives a form
that is homogeneous of degree `d`. -/
theorem isHomogeneous_pderiv {p : MvPolynomial (Fin 3) ℝ} {d : ℕ}
    (hp : p.IsHomogeneous (d + 1)) (i : Fin 3) : (pderiv i p).IsHomogeneous d := by
  simpa using hp.pderiv (i := i)

/-- Mixed partial derivatives commute. -/
private lemma pderiv_comm (i j : Fin 3) (p : MvPolynomial (Fin 3) ℝ) :
    pderiv i (pderiv j p) = pderiv j (pderiv i p) := by
  rcases eq_or_ne i j with rfl | hij
  · rfl
  · refine MvPolynomial.ext _ _ fun m => ?_
    rw [coeff_pderiv, coeff_pderiv, coeff_pderiv, coeff_pderiv]
    have hmi : (m + Finsupp.single i 1 : Fin 3 →₀ ℕ) j = m j := by
      rw [Finsupp.add_apply, Finsupp.single_eq_of_ne hij.symm, add_zero]
    have hmj : (m + Finsupp.single j 1 : Fin 3 →₀ ℕ) i = m i := by
      rw [Finsupp.add_apply, Finsupp.single_eq_of_ne hij, add_zero]
    have hadd : (m + Finsupp.single i 1 + Finsupp.single j 1 : Fin 3 →₀ ℕ)
        = m + Finsupp.single j 1 + Finsupp.single i 1 := add_right_comm _ _ _
    rw [hmi, hmj, hadd]
    ring

/-- The Laplacian commutes with each partial derivative. -/
lemma laplacian_pderiv (i : Fin 3) (p : MvPolynomial (Fin 3) ℝ) :
    laplacian (pderiv i p) = pderiv i (laplacian p) := by
  rw [laplacian_apply, laplacian_apply, map_sum]
  exact Finset.sum_congr rfl fun j _ => by rw [pderiv_comm j i, pderiv_comm j i]

section OrthogonalInvariance

/-- The substitution of the linear forms `∑ k, M j k * X k` for the variables
`X j`, as an `ℝ`-algebra endomorphism of the polynomial ring. -/
noncomputable def linearSubstitution (M : Fin 3 → Fin 3 → ℝ) :
    MvPolynomial (Fin 3) ℝ →ₐ[ℝ] MvPolynomial (Fin 3) ℝ :=
  aeval fun j => linearForm (M j)

/-- A linear substitution sends the variable `X j` to the linear form built from
the `j`-th row of the matrix. -/
@[simp] lemma linearSubstitution_X (M : Fin 3 → Fin 3 → ℝ) (j : Fin 3) :
    linearSubstitution M (X j) = linearForm (M j) := by
  simp [linearSubstitution]

/-- The chain rule for a linear substitution: differentiating the substituted
polynomial with respect to `X i` produces the `i`-th column of the matrix paired
with the substituted partial derivatives. -/
theorem pderiv_linearSubstitution (M : Fin 3 → Fin 3 → ℝ) (i : Fin 3)
    (p : MvPolynomial (Fin 3) ℝ) :
    pderiv i (linearSubstitution M p) = ∑ j, C (M j i) * linearSubstitution M (pderiv j p) := by
  induction p using MvPolynomial.induction_on with
  | C c => simp
  | add p q hp hq => simp [hp, hq, mul_add, Finset.sum_add_distrib]
  | mul_X p k ih =>
      have hXk : ∀ j : Fin 3,
          pderiv j (X k : MvPolynomial (Fin 3) ℝ) = if j = k then 1 else 0 := by
        intro j
        by_cases h : j = k
        · subst h; simp
        · rw [if_neg h, pderiv_X_of_ne (Ne.symm h)]
      have hterm : ∀ j : Fin 3, C (M j i) * linearSubstitution M (pderiv j (p * X k))
          = C (M j i) * linearSubstitution M (pderiv j p) * linearForm (M k)
            + (if j = k then C (M j i) * linearSubstitution M p else 0) := by
        intro j
        rw [pderiv_mul, hXk j, map_add, map_mul, map_mul, linearSubstitution_X]
        by_cases h : j = k
        · subst h; simp; ring
        · simp [h, mul_assoc]
      rw [Finset.sum_congr rfl fun j _ => hterm j, Finset.sum_add_distrib, ← Finset.sum_mul, ← ih,
        map_mul, linearSubstitution_X, pderiv_mul, pderiv_linearForm]
      simp [mul_comm]

/-- Invariance of the Gaussian moment functional under an orthogonal
substitution.  The hypothesis says that the rows of `M` are orthonormal; the
proof checks that the composite functional again satisfies the normalization and
the integration-by-parts recursion, and appeals to
`eq_gaussianMoment_of_recursion`.  Orthogonality enters exactly once, to collapse
the row inner products produced by the chain rule. -/
theorem gaussianMoment_comp_linearSubstitution (M : Fin 3 → Fin 3 → ℝ)
    (hM : ∀ i j, ∑ k, M i k * M j k = if i = j then 1 else 0) :
    gaussianMoment.comp (linearSubstitution M).toLinearMap = gaussianMoment := by
  refine eq_gaussianMoment_of_recursion _ ?_ ?_
  · show gaussianMoment (linearSubstitution M 1) = 1
    rw [map_one, gaussianMoment_one]
  · intro i p
    show gaussianMoment (linearSubstitution M (X i * p))
        = gaussianMoment (linearSubstitution M (pderiv i p))
    rw [map_mul, linearSubstitution_X, linearForm, Finset.sum_mul, map_sum]
    have step : ∀ k : Fin 3,
        gaussianMoment (C (M i k) * X k * linearSubstitution M p)
          = ∑ j, M i k * M j k * gaussianMoment (linearSubstitution M (pderiv j p)) := by
      intro k
      rw [mul_assoc, gaussianMoment_C_mul, gaussianMoment_X_mul, pderiv_linearSubstitution,
        map_sum, Finset.mul_sum]
      exact Finset.sum_congr rfl fun j _ => by rw [gaussianMoment_C_mul]; ring
    rw [Finset.sum_congr rfl fun k _ => step k, Finset.sum_comm]
    have collapse : ∀ j : Fin 3,
        ∑ k, M i k * M j k * gaussianMoment (linearSubstitution M (pderiv j p))
          = (if i = j then 1 else 0) * gaussianMoment (linearSubstitution M (pderiv j p)) := by
      intro j
      rw [← Finset.sum_mul, hM i j]
    rw [Finset.sum_congr rfl fun j _ => collapse j]
    simp

/-- Pointwise form of the invariance of the Gaussian moment functional under an
orthogonal substitution. -/
theorem gaussianMoment_linearSubstitution (M : Fin 3 → Fin 3 → ℝ)
    (hM : ∀ i j, ∑ k, M i k * M j k = if i = j then 1 else 0)
    (p : MvPolynomial (Fin 3) ℝ) :
    gaussianMoment (linearSubstitution M p) = gaussianMoment p := by
  simpa using DFunLike.congr_fun (gaussianMoment_comp_linearSubstitution M hM) p

end OrthogonalInvariance

/-- Euler's identity read through the Gaussian moment functional: for a form `p`
homogeneous of degree `d`, the sum over the variables of the moments of
`X i * pderiv i p` is `d` times the moment of `p`. -/
theorem sum_gaussianMoment_X_mul_pderiv {p : MvPolynomial (Fin 3) ℝ} {d : ℕ}
    (hp : p.IsHomogeneous d) :
    ∑ i, gaussianMoment (X i * pderiv i p) = (d : ℝ) * gaussianMoment p := by
  rw [← map_sum, hp.sum_X_mul_pderiv, map_nsmul, nsmul_eq_mul]

/-- Multiplying a form homogeneous of degree `d` by `X 0 ^ 2 + X 1 ^ 2 + X 2 ^ 2`
multiplies its Gaussian moment by `d + 3`. -/
theorem gaussianMoment_quadric_mul {p : MvPolynomial (Fin 3) ℝ} {d : ℕ}
    (hp : p.IsHomogeneous d) :
    gaussianMoment (quadric * p) = ((d : ℝ) + 3) * gaussianMoment p := by
  have step : ∀ i : Fin 3, gaussianMoment (X i ^ 2 * p)
      = gaussianMoment p + gaussianMoment (X i * pderiv i p) := by
    intro i
    have hsq : (X i : MvPolynomial (Fin 3) ℝ) ^ 2 * p = X i * (X i * p) := by ring
    rw [hsq, gaussianMoment_X_mul, pderiv_mul, pderiv_X_self, one_mul, map_add]
  rw [quadric, Finset.sum_mul, map_sum, Finset.sum_congr rfl fun i _ => step i,
    Finset.sum_add_distrib, sum_gaussianMoment_X_mul_pderiv hp, Finset.sum_const]
  simp
  ring

/-- The normalized mean is unchanged by multiplication by
`X 0 ^ 2 + X 1 ^ 2 + X 2 ^ 2`, the degree bookkeeping being absorbed by the
normalizing double factorial. -/
theorem normalizedMean_quadric_mul {p : MvPolynomial (Fin 3) ℝ} {d : ℕ}
    (hp : p.IsHomogeneous d) :
    normalizedMean (d + 2) (quadric * p) = normalizedMean d p := by
  have hfac : momentFactor (d + 2 + 2) = ((d : ℝ) + 3) * momentFactor (d + 2) := by
    rw [momentFactor_add_two (d + 2)]
    push_cast
    ring
  rw [normalizedMean, normalizedMean, gaussianMoment_quadric_mul hp, hfac,
    mul_div_mul_left _ _ (by positivity : ((d : ℝ) + 3) ≠ 0)]

/-- The identity that carries the apolarity argument.  For `p` homogeneous of
degree `d` and any form `q`,
`d * gaussianMoment (p * q) = gaussianMoment (laplacian p * q)
    + ∑ i, gaussianMoment (pderiv i p * pderiv i q)`.
It comes from Euler's identity for `p`, multiplied by `q`, followed by the
integration-by-parts recursion and the product rule for `pderiv`.  No homogeneity
of `q` is required. -/
theorem gaussianMoment_mul_of_isHomogeneous {p : MvPolynomial (Fin 3) ℝ} {d : ℕ}
    (hp : p.IsHomogeneous d) (q : MvPolynomial (Fin 3) ℝ) :
    (d : ℝ) * gaussianMoment (p * q)
      = gaussianMoment (laplacian p * q) + ∑ i, gaussianMoment (pderiv i p * pderiv i q) := by
  have euler : ∑ i, X i * pderiv i p * q = (d : ℕ) • (p * q) := by
    rw [← Finset.sum_mul, hp.sum_X_mul_pderiv, smul_mul_assoc]
  have h1 : (d : ℝ) * gaussianMoment (p * q)
      = ∑ i, gaussianMoment (X i * (pderiv i p * q)) := by
    have hstep : ∑ i, gaussianMoment (X i * (pderiv i p * q))
        = gaussianMoment ((d : ℕ) • (p * q)) := by
      rw [← euler, map_sum]
      exact Finset.sum_congr rfl fun i _ => by rw [mul_assoc]
    rw [hstep, map_nsmul, nsmul_eq_mul]
  have h2 : ∀ i : Fin 3, gaussianMoment (X i * (pderiv i p * q))
      = gaussianMoment (pderiv i (pderiv i p) * q)
        + gaussianMoment (pderiv i p * pderiv i q) := by
    intro i
    rw [gaussianMoment_X_mul, pderiv_mul, map_add]
  rw [h1, Finset.sum_congr rfl fun i _ => h2 i, Finset.sum_add_distrib]
  congr 1
  rw [laplacian_apply, Finset.sum_mul, map_sum]

/-- Lower-degree vanishing.  If `p` is homogeneous of degree `d` and its
Laplacian vanishes, then the Gaussian moment of `p * q` is zero for every form
`q` homogeneous of degree strictly below `d`.  The induction is on `d`: the
identity `gaussianMoment_mul_of_isHomogeneous` replaces the pair `(p, q)` by the
pairs `(pderiv i p, pderiv i q)`, whose degrees have both dropped by one. -/
theorem gaussianMoment_mul_eq_zero_of_laplacian_eq_zero :
    ∀ (d : ℕ) (p : MvPolynomial (Fin 3) ℝ), p.IsHomogeneous d → laplacian p = 0 →
      ∀ (e : ℕ), e < d → ∀ q : MvPolynomial (Fin 3) ℝ, q.IsHomogeneous e →
        gaussianMoment (p * q) = 0 := by
  intro d
  induction d with
  | zero => intro _ _ _ e he; exact absurd he (Nat.not_lt_zero e)
  | succ d ih =>
    intro p hp hlap e he q hq
    have key := gaussianMoment_mul_of_isHomogeneous hp q
    rw [hlap, zero_mul, map_zero, zero_add] at key
    have hzero : ∀ i : Fin 3, gaussianMoment (pderiv i p * pderiv i q) = 0 := by
      intro i
      have hpi : (pderiv i p).IsHomogeneous d := isHomogeneous_pderiv hp i
      have hlapi : laplacian (pderiv i p) = 0 := by rw [laplacian_pderiv, hlap, map_zero]
      cases e with
      | zero =>
        obtain ⟨c, rfl⟩ : ∃ c, q = C c :=
          ⟨coeff 0 q, totalDegree_eq_zero_iff_eq_C.mp (Nat.le_zero.mp hq.totalDegree_le)⟩
        rw [pderiv_C, mul_zero, map_zero]
      | succ e => exact ih _ hpi hlapi e (by omega) _ (isHomogeneous_pderiv hq i)
    rw [Finset.sum_congr rfl fun i _ => hzero i, Finset.sum_const_zero] at key
    exact (mul_eq_zero.mp key).resolve_left (Nat.cast_ne_zero.mpr (Nat.succ_ne_zero d))

/-- Apolar evaluation against a power of a linear form.  If `p` is homogeneous of
degree `d` and its Laplacian vanishes, then for every coefficient vector `w` the
Gaussian moment of `p` against the `d`-th power of `linearForm w` is
`d ! * eval w p`.  Only these two clauses of apolarity — this one and
`gaussianMoment_mul_eq_zero_of_laplacian_eq_zero` — are proved here; the general
identity expressing `gaussianMoment (p * q)` through the differential operator
obtained by substituting `pderiv` for the variables of `p` is neither stated nor
used. -/
theorem gaussianMoment_mul_linearForm_pow :
    ∀ (d : ℕ) (p : MvPolynomial (Fin 3) ℝ), p.IsHomogeneous d → laplacian p = 0 →
      ∀ w : Fin 3 → ℝ,
        gaussianMoment (p * linearForm w ^ d) = (Nat.factorial d : ℝ) * eval w p := by
  intro d
  induction d with
  | zero =>
    intro p hp _ w
    obtain ⟨c, rfl⟩ : ∃ c, p = C c :=
      ⟨coeff 0 p, totalDegree_eq_zero_iff_eq_C.mp (Nat.le_zero.mp hp.totalDegree_le)⟩
    simp
  | succ d ih =>
    intro p hp hlap w
    have key := gaussianMoment_mul_of_isHomogeneous hp (linearForm w ^ (d + 1))
    rw [hlap, zero_mul, map_zero, zero_add] at key
    have hpd : ∀ i : Fin 3, pderiv i (linearForm w ^ (d + 1))
        = C ((d + 1 : ℕ) : ℝ) * C (w i) * linearForm w ^ d := by
      intro i
      rw [pderiv_pow, pderiv_linearForm, Nat.add_sub_cancel,
        ← map_natCast (C : ℝ →+* MvPolynomial (Fin 3) ℝ) (d + 1)]
      ring
    have hharm : ∀ i : Fin 3, laplacian (pderiv i p) = 0 := by
      intro i
      rw [laplacian_pderiv, hlap, map_zero]
    have hterm : ∀ i : Fin 3,
        gaussianMoment (pderiv i p * pderiv i (linearForm w ^ (d + 1)))
          = ((d + 1 : ℕ) : ℝ) * (w i * ((Nat.factorial d : ℝ) * eval w (pderiv i p))) := by
      intro i
      rw [hpd i]
      have hrearrange : pderiv i p * (C ((d + 1 : ℕ) : ℝ) * C (w i) * linearForm w ^ d)
          = C ((d + 1 : ℕ) : ℝ) * (C (w i) * (pderiv i p * linearForm w ^ d)) := by ring
      rw [hrearrange, gaussianMoment_C_mul, gaussianMoment_C_mul,
        ih (pderiv i p) (isHomogeneous_pderiv hp i) (hharm i) w]
    have heuler : ∑ i, w i * eval w (pderiv i p) = ((d + 1 : ℕ) : ℝ) * eval w p := by
      have hE := congrArg (eval w) hp.sum_X_mul_pderiv
      rw [map_sum] at hE
      simpa using hE
    rw [Finset.sum_congr rfl fun i _ => hterm i, ← Finset.mul_sum] at key
    have hsum : ∑ i, w i * ((Nat.factorial d : ℝ) * eval w (pderiv i p))
        = (Nat.factorial d : ℝ) * (((d + 1 : ℕ) : ℝ) * eval w p) := by
      rw [← heuler, Finset.mul_sum]
      exact Finset.sum_congr rfl fun i _ => by ring
    rw [hsum] at key
    refine mul_left_cancel₀ (Nat.cast_ne_zero.mpr (Nat.succ_ne_zero d) :
      ((d + 1 : ℕ) : ℝ) ≠ 0) ?_
    rw [key, Nat.factorial_succ]
    push_cast
    ring

end RelativeConicArcs.SphericalMomentFunctional
