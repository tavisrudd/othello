import Mathlib.Tactic
import Mathlib.RingTheory.PowerSeries.Basic
import Mathlib.Data.Matrix.Basic
import Mathlib.LinearAlgebra.Matrix.Trace

/-!
# The formal loop connection of a centered atomic factor

This module fixes the formal model in which the loop-direction connection of an
atomic factor, its companion in a base direction, and the sesquilinear pairing
between horizontal sections are single formal objects rather than families of
matrices, and it derives from that model the order-by-order identities used in
the rank-two atomic argument.

## Objects and conventions

Let `B` be a commutative coefficient ring and let `δ : B → B` be a derivation of
it, playing the role of a vector field on the base.  A rank-`ι` factor whose
connection has a simple pole in the loop coordinate `u` after centering the
scalar irregular part is described by

  `A(u) = u⁻¹ * N + A₀ + u * A₁ + u ^ 2 * A₂ + ⋯`,
  `B(u) = u⁻¹ * C + C₀ + u * C₁ + ⋯`

for the loop direction and for the base direction `δ`.  Both are represented
here after clearing the pole: `loop = u * A(u)` and `base = u * B(u)` are formal
power series with coefficients in the matrix ring, so that

  `coeff 0 loop = N`,  `coeff (m + 1) loop = Aₘ`,
  `coeff 0 base = C`,  `coeff (m + 1) base = Cₘ`.

Multiplying a Laurent expansion by the loop coordinate is injective, so no
information is lost, and every identity below is an identity of formal power
series with no convergence or analytic content.

Flatness of the pair, in the form `δ A - u ∂_u B + [A, B] = 0`, becomes after
multiplication by `u ^ 2` the identity

  `[loop, base] + u * (δ loop - u ∂_u base + base) = 0`,

which is `IsFlatPair` below; here `δ` acts entrywise on each coefficient and
`u ∂_u` multiplies the coefficient of `u ^ n` by `n`.

The pairing of the atomic argument is the `u`-sesquilinear form
`ψ(s, t) = (s(u), t(-u))`, whose matrix `P(u) = P₀ + u * P₁ + ⋯` has no pole.
Horizontality in the loop direction, `u ∂_u P + A(u)ᵀ P + P A(-u) = 0`, becomes
after multiplication by `u`

  `u * (u ∂_u P) + loopᵀ * P - P * loop(-u) = 0`,

which is `IsHorizontalPairing` below; substituting `-u` in the cleared series
multiplies the coefficient of `u ^ n` by `(-1) ^ n`, and the extra sign in the
subtraction is the one produced by clearing the pole of `A(-u)`.

## Results

Extracting the coefficients of `u ^ 0` and `u ^ 1` from `IsFlatPair` gives the
two flatness identities used in the rank-two argument: the leading base
coefficient commutes with the leading loop coefficient, and the first-order
identity relating `δ N`, `C`, and two commutators.  Extracting the same two
coefficients from `IsHorizontalPairing` gives self-adjointness of the leading
loop coefficient for the leading pairing coefficient and the four-term relation
between the regular loop coefficient and the first two pairing coefficients.
For a rank-two factor in an adapted frame, where the leading coefficient is a
unit multiple of the upper-right matrix unit, the commutation identity together
with vanishing trace identifies the leading base coefficient as a multiple of
the leading loop coefficient.

Lean constructs no `F`-bundle, spectral cover, atomic factor, quantum product,
or Poincare pairing here, and does not prove that the connection of such a
bundle takes the displayed shape; the shape is the definition of the formal
model, and the geometric statements that a factor supplies such data are
hypotheses wherever they are used.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Quantum

open Matrix PowerSeries

variable {B : Type*} [CommRing B] {ι : Type*} [Fintype ι] [DecidableEq ι]

/-- The coefficient of `u ^ 0` in a product of two formal series. -/
theorem coeff_zero_mul_matrixSeries (f g : PowerSeries (Matrix ι ι B)) :
    coeff 0 (f * g) = coeff 0 f * coeff 0 g := by
  rw [PowerSeries.coeff_mul]
  simp

/-- The coefficient of `u ^ 1` in a product of two formal series. -/
theorem coeff_one_mul_matrixSeries (f g : PowerSeries (Matrix ι ι B)) :
    coeff 1 (f * g) = coeff 0 f * coeff 1 g + coeff 1 f * coeff 0 g := by
  rw [PowerSeries.coeff_mul]
  have decomposition : Finset.antidiagonal 1 = {((0 : ℕ), (1 : ℕ)), ((1 : ℕ), (0 : ℕ))} := rfl
  rw [decomposition, Finset.sum_insert (by decide), Finset.sum_singleton]

/-- The coefficient of `u ^ 2` in a product of two formal series. -/
theorem coeff_two_mul_matrixSeries (f g : PowerSeries (Matrix ι ι B)) :
    coeff 2 (f * g) = coeff 0 f * coeff 2 g + coeff 1 f * coeff 1 g + coeff 2 f * coeff 0 g := by
  rw [PowerSeries.coeff_mul]
  have decomposition : Finset.antidiagonal 2 =
      {((0 : ℕ), (2 : ℕ)), ((1 : ℕ), (1 : ℕ)), ((2 : ℕ), (0 : ℕ))} := rfl
  rw [decomposition, Finset.sum_insert (by decide), Finset.sum_insert (by decide),
    Finset.sum_singleton, add_assoc]

/-- The Euler operator `u ∂_u` of the loop coordinate, acting on a series
cleared of its pole: it multiplies the coefficient of `u ^ n` by `n`. -/
noncomputable def loopEulerOperator (f : PowerSeries (Matrix ι ι B)) : PowerSeries (Matrix ι ι B) :=
  PowerSeries.mk fun n => n • coeff n f

/-- The Euler operator multiplies the coefficient of `u ^ n` by `n`. -/
@[simp] theorem coeff_loopEulerOperator (n : ℕ) (f : PowerSeries (Matrix ι ι B)) :
    coeff n (loopEulerOperator f) = n • coeff n f := by
  simp [loopEulerOperator]

/-- The Euler operator annihilates the coefficient of `u ^ 0`. -/
@[simp] theorem constantCoeff_loopEulerOperator (f : PowerSeries (Matrix ι ι B)) :
    constantCoeff (loopEulerOperator f) = 0 := by
  rw [← PowerSeries.coeff_zero_eq_constantCoeff_apply, coeff_loopEulerOperator]
  simp

/-- A derivation of the coefficient ring acting entrywise on every coefficient
of a formal series of matrices. -/
noncomputable def seriesDerivation (derivation : B → B) (f : PowerSeries (Matrix ι ι B)) :
    PowerSeries (Matrix ι ι B) :=
  PowerSeries.mk fun n => (coeff n f).map derivation

/-- A derivation of the coefficient ring acts on each coefficient entrywise. -/
@[simp] theorem coeff_seriesDerivation (derivation : B → B) (n : ℕ)
    (f : PowerSeries (Matrix ι ι B)) :
    coeff n (seriesDerivation derivation f) = (coeff n f).map derivation := by
  simp [seriesDerivation]

/-- A derivation of the coefficient ring acts entrywise on the coefficient of
`u ^ 0`. -/
@[simp] theorem constantCoeff_seriesDerivation (derivation : B → B)
    (f : PowerSeries (Matrix ι ι B)) :
    constantCoeff (seriesDerivation derivation f) = (constantCoeff f).map derivation := by
  rw [← PowerSeries.coeff_zero_eq_constantCoeff_apply,
    ← PowerSeries.coeff_zero_eq_constantCoeff_apply, coeff_seriesDerivation]

/-- Substitution of `-u` for the loop coordinate in a series cleared of its
pole: it multiplies the coefficient of `u ^ n` by `(-1) ^ n`. -/
noncomputable def loopSignReversal (f : PowerSeries (Matrix ι ι B)) : PowerSeries (Matrix ι ι B) :=
  PowerSeries.mk fun n => (-1 : B) ^ n • coeff n f

/-- Substituting `-u` multiplies the coefficient of `u ^ n` by `(-1) ^ n`. -/
@[simp] theorem coeff_loopSignReversal (n : ℕ) (f : PowerSeries (Matrix ι ι B)) :
    coeff n (loopSignReversal f) = (-1 : B) ^ n • coeff n f := by
  simp [loopSignReversal]

/-- Substituting `-u` leaves the coefficient of `u ^ 0` unchanged. -/
@[simp] theorem constantCoeff_loopSignReversal (f : PowerSeries (Matrix ι ι B)) :
    constantCoeff (loopSignReversal f) = constantCoeff f := by
  rw [← PowerSeries.coeff_zero_eq_constantCoeff_apply,
    ← PowerSeries.coeff_zero_eq_constantCoeff_apply, coeff_loopSignReversal]
  simp

/-- The transpose of a formal series of matrices, taken coefficientwise. -/
noncomputable def seriesTranspose (f : PowerSeries (Matrix ι ι B)) : PowerSeries (Matrix ι ι B) :=
  PowerSeries.mk fun n => (coeff n f)ᵀ

/-- Transposition acts on each coefficient of a formal series of matrices. -/
@[simp] theorem coeff_seriesTranspose (n : ℕ) (f : PowerSeries (Matrix ι ι B)) :
    coeff n (seriesTranspose f) = (coeff n f)ᵀ := by
  simp [seriesTranspose]

/-- Transposition acts on the coefficient of `u ^ 0`. -/
@[simp] theorem constantCoeff_seriesTranspose (f : PowerSeries (Matrix ι ι B)) :
    constantCoeff (seriesTranspose f) = (constantCoeff f)ᵀ := by
  rw [← PowerSeries.coeff_zero_eq_constantCoeff_apply,
    ← PowerSeries.coeff_zero_eq_constantCoeff_apply, coeff_seriesTranspose]

/-- The Leibniz rule for the Euler operator of the loop coordinate. -/
theorem loopEulerOperator_mul (f g : PowerSeries (Matrix ι ι B)) :
    loopEulerOperator (f * g) = loopEulerOperator f * g + f * loopEulerOperator g := by
  refine PowerSeries.ext fun n => ?_
  have pointwise : ∀ pair ∈ Finset.antidiagonal n,
      n • (coeff pair.1 f * coeff pair.2 g)
        = coeff pair.1 (loopEulerOperator f) * coeff pair.2 g
          + coeff pair.1 f * coeff pair.2 (loopEulerOperator g) := by
    intro pair membership
    have decomposition : pair.1 + pair.2 = n := Finset.mem_antidiagonal.mp membership
    simp only [coeff_loopEulerOperator]
    rw [← decomposition, add_smul, smul_mul_assoc, mul_smul_comm]
  calc coeff n (loopEulerOperator (f * g))
      = ∑ pair ∈ Finset.antidiagonal n, n • (coeff pair.1 f * coeff pair.2 g) := by
        rw [coeff_loopEulerOperator, PowerSeries.coeff_mul, Finset.smul_sum]
    _ = ∑ pair ∈ Finset.antidiagonal n,
          (coeff pair.1 (loopEulerOperator f) * coeff pair.2 g
            + coeff pair.1 f * coeff pair.2 (loopEulerOperator g)) :=
        Finset.sum_congr rfl pointwise
    _ = coeff n (loopEulerOperator f * g + f * loopEulerOperator g) := by
        rw [map_add, PowerSeries.coeff_mul, PowerSeries.coeff_mul, Finset.sum_add_distrib]

/-- An additive map of the coefficient ring commutes with a finite sum of
matrices taken entrywise. -/
theorem map_sum_of_additive {derivation : B → B} {κ index : Type*} (s : Finset κ)
    (M : κ → Matrix index index B)
    (additive : ∀ x y, derivation (x + y) = derivation x + derivation y) :
    (∑ index ∈ s, M index).map derivation = ∑ index ∈ s, (M index).map derivation := by
  ext row column
  simp only [Matrix.map_apply, Matrix.sum_apply]
  exact map_sum (AddMonoidHom.mk' derivation additive) _ _

omit [DecidableEq ι] in
/-- An entrywise derivation of the coefficient ring obeys the Leibniz rule for a
product of matrices. -/
theorem map_mul_of_entrywise_derivation {derivation : B → B}
    (additive : ∀ x y, derivation (x + y) = derivation x + derivation y)
    (leibniz : ∀ x y, derivation (x * y) = derivation x * y + x * derivation y)
    (M N : Matrix ι ι B) :
    (M * N).map derivation = M.map derivation * N + M * N.map derivation := by
  ext row column
  simp only [Matrix.map_apply, Matrix.mul_apply, Matrix.add_apply]
  have expansion : derivation (∑ index, M row index * N index column) =
      ∑ index, derivation (M row index * N index column) :=
    map_sum (AddMonoidHom.mk' derivation additive)
      (fun index => M row index * N index column) Finset.univ
  rw [expansion]
  simp only [leibniz, Finset.sum_add_distrib]

/-- The Leibniz rule for an entrywise derivation acting on a product of formal
series of matrices. -/
theorem seriesDerivation_mul {derivation : B → B}
    (additive : ∀ x y, derivation (x + y) = derivation x + derivation y)
    (leibniz : ∀ x y, derivation (x * y) = derivation x * y + x * derivation y)
    (f g : PowerSeries (Matrix ι ι B)) :
    seriesDerivation derivation (f * g) =
      seriesDerivation derivation f * g + f * seriesDerivation derivation g := by
  refine PowerSeries.ext fun n => ?_
  have pointwise : ∀ pair ∈ Finset.antidiagonal n,
      (coeff pair.1 f * coeff pair.2 g).map derivation
        = coeff pair.1 (seriesDerivation derivation f) * coeff pair.2 g
          + coeff pair.1 f * coeff pair.2 (seriesDerivation derivation g) := by
    intro pair _
    simp only [coeff_seriesDerivation]
    exact map_mul_of_entrywise_derivation additive leibniz _ _
  calc coeff n (seriesDerivation derivation (f * g))
      = ∑ pair ∈ Finset.antidiagonal n, (coeff pair.1 f * coeff pair.2 g).map derivation := by
        rw [coeff_seriesDerivation, PowerSeries.coeff_mul, map_sum_of_additive _ _ additive]
    _ = ∑ pair ∈ Finset.antidiagonal n,
          (coeff pair.1 (seriesDerivation derivation f) * coeff pair.2 g
            + coeff pair.1 f * coeff pair.2 (seriesDerivation derivation g)) :=
        Finset.sum_congr rfl pointwise
    _ = coeff n (seriesDerivation derivation f * g + f * seriesDerivation derivation g) := by
        rw [map_add, PowerSeries.coeff_mul, PowerSeries.coeff_mul, Finset.sum_add_distrib]

/-- An entrywise derivation is additive on formal series of matrices. -/
theorem seriesDerivation_add {derivation : B → B}
    (additive : ∀ x y, derivation (x + y) = derivation x + derivation y)
    (f g : PowerSeries (Matrix ι ι B)) :
    seriesDerivation derivation (f + g) =
      seriesDerivation derivation f + seriesDerivation derivation g := by
  ext n row column
  simp only [coeff_seriesDerivation, map_add, Matrix.map_apply, Matrix.add_apply]
  exact additive _ _

/-- The Euler operator of the loop coordinate is additive. -/
theorem loopEulerOperator_add (f g : PowerSeries (Matrix ι ι B)) :
    loopEulerOperator (f + g) = loopEulerOperator f + loopEulerOperator g := by
  ext n
  simp only [coeff_loopEulerOperator, map_add, smul_add]

/-- An entrywise derivation commutes with subtraction of formal series. -/
theorem seriesDerivation_sub {derivation : B → B}
    (additive : ∀ x y, derivation (x + y) = derivation x + derivation y)
    (f g : PowerSeries (Matrix ι ι B)) :
    seriesDerivation derivation (f - g) =
      seriesDerivation derivation f - seriesDerivation derivation g := by
  have subtraction : ∀ x y : B, derivation (x - y) = derivation x - derivation y := by
    intro x y
    have expansion := additive (x - y) y
    rw [sub_add_cancel] at expansion
    linear_combination -expansion
  ext n row column
  simp only [coeff_seriesDerivation, map_sub, Matrix.map_apply, Matrix.sub_apply]
  exact subtraction _ _

/-- The Euler operator of the loop coordinate commutes with subtraction. -/
theorem loopEulerOperator_sub (f g : PowerSeries (Matrix ι ι B)) :
    loopEulerOperator (f - g) = loopEulerOperator f - loopEulerOperator g := by
  ext n
  simp only [coeff_loopEulerOperator, map_sub, smul_sub]

/-- Flatness of the loop and base connection matrices of a centered factor,
written for the series obtained from them by clearing the simple pole.  It is
the identity `δ A - u ∂_u B + [A, B] = 0` multiplied by `u ^ 2`. -/
def IsFlatPair (derivation : B → B) (loop base : PowerSeries (Matrix ι ι B)) : Prop :=
  loop * base - base * loop
      + PowerSeries.X * (seriesDerivation derivation loop - loopEulerOperator base + base) = 0

/-- Horizontality of the `u`-sesquilinear pairing for the loop connection,
written for the loop series cleared of its pole.  It is the identity
`u ∂_u P + A(u)ᵀ P + P A(-u) = 0` multiplied by `u`. -/
def IsHorizontalPairing (loop pairing : PowerSeries (Matrix ι ι B)) : Prop :=
  PowerSeries.X * loopEulerOperator pairing
      + seriesTranspose loop * pairing - pairing * loopSignReversal loop = 0

/-- The coefficient of `u ^ (-2)` in flatness: the leading coefficient of the
base direction commutes with the leading coefficient of the loop direction. -/
theorem leadingCoefficients_commute_of_isFlatPair {derivation : B → B}
    {loop base : PowerSeries (Matrix ι ι B)} (flat : IsFlatPair derivation loop base) :
    coeff 0 loop * coeff 0 base - coeff 0 base * coeff 0 loop = 0 := by
  have coefficient := congrArg (fun f => coeff 0 f) flat
  simpa [IsFlatPair, coeff_zero_mul_matrixSeries] using coefficient

/-- The coefficient of `u ^ (-1)` in flatness: the first-order identity between
the derivative of the leading loop coefficient, the leading base coefficient,
and the two commutators formed from the coefficients of order zero and one. -/
theorem firstOrder_identity_of_isFlatPair {derivation : B → B}
    {loop base : PowerSeries (Matrix ι ι B)} (flat : IsFlatPair derivation loop base) :
    (coeff 0 loop).map derivation + coeff 0 base
        + (coeff 0 loop * coeff 1 base - coeff 1 base * coeff 0 loop)
        + (coeff 1 loop * coeff 0 base - coeff 0 base * coeff 1 loop) = 0 := by
  have coefficient := congrArg (fun f => coeff 1 f) flat
  simp only [map_add, map_sub, map_zero, coeff_one_mul_matrixSeries,
    PowerSeries.coeff_succ_X_mul, coeff_seriesDerivation, coeff_loopEulerOperator] at coefficient
  simp only [zero_smul] at coefficient
  linear_combination (norm := abel) coefficient

/-- The coefficient of `u ^ 0` in flatness: the second-order identity between
the derivative of the regular loop coefficient and the three commutators formed
from the coefficients of order at most two. -/
theorem secondOrder_identity_of_isFlatPair {derivation : B → B}
    {loop base : PowerSeries (Matrix ι ι B)} (flat : IsFlatPair derivation loop base) :
    (coeff 1 loop).map derivation
        + (coeff 0 loop * coeff 2 base - coeff 2 base * coeff 0 loop)
        + (coeff 1 loop * coeff 1 base - coeff 1 base * coeff 1 loop)
        + (coeff 2 loop * coeff 0 base - coeff 0 base * coeff 2 loop) = 0 := by
  have coefficient := congrArg (fun f => coeff 2 f) flat
  simp only [map_add, map_sub, map_zero, coeff_two_mul_matrixSeries,
    PowerSeries.coeff_succ_X_mul, coeff_seriesDerivation, coeff_loopEulerOperator] at coefficient
  simp only [one_smul] at coefficient
  linear_combination (norm := abel) coefficient

/-- The coefficient of `u ^ 0` in horizontality: the leading loop coefficient is
self-adjoint for the leading pairing coefficient. -/
theorem leadingCoefficient_selfAdjoint_of_isHorizontalPairing
    {loop pairing : PowerSeries (Matrix ι ι B)} (horizontal : IsHorizontalPairing loop pairing) :
    (coeff 0 loop)ᵀ * coeff 0 pairing - coeff 0 pairing * coeff 0 loop = 0 := by
  have coefficient := congrArg (fun f => coeff 0 f) horizontal
  simpa [IsHorizontalPairing, coeff_zero_mul_matrixSeries] using coefficient

/-- The coefficient of `u ^ 1` in horizontality: the four-term relation between
the regular loop coefficient, the first two pairing coefficients, and the
leading loop coefficient. -/
theorem regularCoefficient_identity_of_isHorizontalPairing
    {loop pairing : PowerSeries (Matrix ι ι B)} (horizontal : IsHorizontalPairing loop pairing) :
    (coeff 1 loop)ᵀ * coeff 0 pairing + coeff 0 pairing * coeff 1 loop
        + (coeff 0 loop)ᵀ * coeff 1 pairing - coeff 1 pairing * coeff 0 loop = 0 := by
  have coefficient := congrArg (fun f => coeff 1 f) horizontal
  simp only [map_add, map_sub, map_zero, coeff_one_mul_matrixSeries,
    PowerSeries.coeff_succ_X_mul, coeff_seriesTranspose, coeff_loopSignReversal,
    coeff_loopEulerOperator] at coefficient
  simp only [zero_smul, pow_zero, one_smul, pow_one] at coefficient
  have expansion : coeff 0 pairing * ((-1 : B) • coeff 1 loop) =
      -(coeff 0 pairing * coeff 1 loop) := by
    simp
  rw [expansion] at coefficient
  linear_combination (norm := abel) coefficient

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
