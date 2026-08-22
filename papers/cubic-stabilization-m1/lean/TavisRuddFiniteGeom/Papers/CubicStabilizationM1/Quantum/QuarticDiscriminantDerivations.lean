import Mathlib.Tactic
import Mathlib.RingTheory.Derivation.Basic
import Mathlib.Algebra.MvPolynomial.PDeriv

/-!
# Logarithmic derivatives of the discriminant of a quartic characteristic polynomial

Let `A` be a commutative ring and let

  `P(T) = T ^ 4 + l₃ * T ^ 3 + l₂ * T ^ 2 + l₁ * T + l₀`

be a monic quartic over `A`.  Its discriminant `quarticDiscriminant l₀ l₁ l₂ l₃`
is the usual universal polynomial in the coefficients; when the quartic splits
with roots `r₀, …, r₃` it equals the squared product of the pairwise root
differences, which is the content of `quarticDiscriminant_eq_squared_root_differences`.

The setting of interest is the characteristic polynomial of the endomorphism
`U = E ∘ (·)` of the tangent sheaf of a four-dimensional `F`-manifold at a point
where `U` is regular.  There the powers `X₀ = e`, `X₁ = E`, `X₂ = E ∘ E`,
`X₃ = E ∘ E ∘ E` of the Euler field form a local frame, and Cayley--Hamilton
together with the Witt relations `[Xᵢ, Xⱼ] = (j - i) Xᵢ₊ⱼ₋₁` force each `Xₛ` to
act on the coefficients `l₀, …, l₃` by the displayed formulas of
`EulerCoefficientFrame`.  These are the four-dimensional cases of the
coefficient identities of L. David and C. Hertling, *Regular `F`-manifolds:
initial conditions and Frobenius metrics*, Ann. Sc. Norm. Super. Pisa Cl. Sci.
(5) 17 (2017), 1121--1152, equations (19), (20), (24), (25).

This module proves, from those coefficient identities alone and over an
arbitrary commutative ring, that the discriminant is a logarithmic eigenvector
of each frame derivation:

  `X₀ Δ = 0`,  `X₁ Δ = 12 Δ`,  `X₂ Δ = -6 l₃ Δ`,  `X₃ Δ = (6 l₃ ^ 2 - 10 l₂) Δ`.

Lean constructs no `F`-manifold, no tangent sheaf, and no Euler field: the
canonical frame enters as four abstract derivations of `A` and its action on the
characteristic coefficients enters as the sixteen displayed equations.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace Quantum

variable {A : Type*} [CommRing A]

/-- A derivation kills every numeral of the base ring, since numerals are
integer multiples of the unit. -/
@[simp]
private theorem derivation_ofNat_eq_zero (D : Derivation ℤ A A) (n : ℕ) [n.AtLeastTwo] :
    D (no_index (OfNat.ofNat n) : A) = 0 := by
  rw [← Nat.cast_ofNat]
  exact D.map_natCast n

/-- The discriminant of the monic quartic
`T ^ 4 + l₃ * T ^ 3 + l₂ * T ^ 2 + l₁ * T + l₀`, as the universal polynomial in
its coefficients. -/
def quarticDiscriminant (l₀ l₁ l₂ l₃ : A) : A :=
  256 * l₀ ^ 3 - 192 * l₃ * l₁ * l₀ ^ 2 - 128 * l₂ ^ 2 * l₀ ^ 2 + 144 * l₂ * l₁ ^ 2 * l₀
    - 27 * l₁ ^ 4 + 144 * l₃ ^ 2 * l₂ * l₀ ^ 2 - 6 * l₃ ^ 2 * l₁ ^ 2 * l₀
    - 80 * l₃ * l₂ ^ 2 * l₁ * l₀ + 18 * l₃ * l₂ * l₁ ^ 3 + 16 * l₂ ^ 4 * l₀
    - 4 * l₂ ^ 3 * l₁ ^ 2 - 27 * l₃ ^ 4 * l₀ ^ 2 + 18 * l₃ ^ 3 * l₂ * l₁ * l₀
    - 4 * l₃ ^ 3 * l₁ ^ 3 - 4 * l₃ ^ 2 * l₂ ^ 3 * l₀ + l₃ ^ 2 * l₂ ^ 2 * l₁ ^ 2

/-- For a split quartic `∏ (T - rᵢ)`, whose coefficients are the signed
elementary symmetric functions of the roots, the discriminant is the squared
product of the pairwise root differences. -/
theorem quarticDiscriminant_eq_squared_root_differences (r₀ r₁ r₂ r₃ : A) :
    quarticDiscriminant (r₀ * r₁ * r₂ * r₃)
        (-(r₀ * r₁ * r₂ + r₀ * r₁ * r₃ + r₀ * r₂ * r₃ + r₁ * r₂ * r₃))
        (r₀ * r₁ + r₀ * r₂ + r₀ * r₃ + r₁ * r₂ + r₁ * r₃ + r₂ * r₃)
        (-(r₀ + r₁ + r₂ + r₃)) =
      ((r₀ - r₁) * (r₀ - r₂) * (r₀ - r₃) * (r₁ - r₂) * (r₁ - r₃) * (r₂ - r₃)) ^ 2 := by
  unfold quarticDiscriminant
  ring

/-- The unit field annihilates the discriminant: a derivation acting on the
characteristic coefficients by `D lₖ = -(k + 1) lₖ₊₁`, with `l₄ = 1`, kills the
discriminant. -/
theorem quarticDiscriminant_unitField (D : Derivation ℤ A A) {l₀ l₁ l₂ l₃ : A}
    (h₀ : D l₀ = -l₁) (h₁ : D l₁ = -2 * l₂) (h₂ : D l₂ = -3 * l₃) (h₃ : D l₃ = -4) :
    D (quarticDiscriminant l₀ l₁ l₂ l₃) = 0 := by
  simp only [quarticDiscriminant, map_sub, map_add, Derivation.leibniz, Derivation.leibniz_pow,
    smul_eq_mul, derivation_ofNat_eq_zero, nsmul_eq_mul, Nat.cast_ofNat, h₀, h₁, h₂, h₃]
  ring

/-- The Euler field scales the discriminant by twelve: a derivation acting on
the characteristic coefficients by `D lₖ = (4 - k) lₖ`, the Euler operator of the
grading in which `lₖ` has degree `4 - k`, multiplies the discriminant by its own
degree twelve. -/
theorem quarticDiscriminant_eulerField (D : Derivation ℤ A A) {l₀ l₁ l₂ l₃ : A}
    (h₀ : D l₀ = 4 * l₀) (h₁ : D l₁ = 3 * l₁) (h₂ : D l₂ = 2 * l₂) (h₃ : D l₃ = l₃) :
    D (quarticDiscriminant l₀ l₁ l₂ l₃) = 12 * quarticDiscriminant l₀ l₁ l₂ l₃ := by
  simp only [quarticDiscriminant, map_sub, map_add, Derivation.leibniz, Derivation.leibniz_pow,
    smul_eq_mul, derivation_ofNat_eq_zero, nsmul_eq_mul, Nat.cast_ofNat, h₀, h₁, h₂, h₃]
  ring

/-- The square of the Euler field multiplies the discriminant by `-6 l₃`: a
derivation acting on the characteristic coefficients by
`D lₖ = -l₃ lₖ + (5 - k) lₖ₋₁`, with `l₋₁ = 0` and `l₄ = 1`, satisfies this
logarithmic identity. -/
theorem quarticDiscriminant_squareField (D : Derivation ℤ A A) {l₀ l₁ l₂ l₃ : A}
    (h₀ : D l₀ = -(l₃ * l₀)) (h₁ : D l₁ = -(l₃ * l₁) + 4 * l₀)
    (h₂ : D l₂ = -(l₃ * l₂) + 3 * l₁) (h₃ : D l₃ = -(l₃ * l₃) + 2 * l₂) :
    D (quarticDiscriminant l₀ l₁ l₂ l₃) = -6 * l₃ * quarticDiscriminant l₀ l₁ l₂ l₃ := by
  simp only [quarticDiscriminant, map_sub, map_add, Derivation.leibniz, Derivation.leibniz_pow,
    smul_eq_mul, derivation_ofNat_eq_zero, nsmul_eq_mul, Nat.cast_ofNat, h₀, h₁, h₂, h₃]
  ring

/-- The cube of the Euler field multiplies the discriminant by
`6 l₃ ^ 2 - 10 l₂`: a derivation acting on the characteristic coefficients by
`D lₖ = (l₃ ^ 2 - 2 l₂) lₖ + (6 - k) lₖ₋₂ - l₃ lₖ₋₁`, with `l₋₁ = l₋₂ = 0` and
`l₄ = 1`, satisfies this logarithmic identity. -/
theorem quarticDiscriminant_cubeField (D : Derivation ℤ A A) {l₀ l₁ l₂ l₃ : A}
    (h₀ : D l₀ = (l₃ ^ 2 - 2 * l₂) * l₀)
    (h₁ : D l₁ = (l₃ ^ 2 - 2 * l₂) * l₁ - l₃ * l₀)
    (h₂ : D l₂ = (l₃ ^ 2 - 2 * l₂) * l₂ + 4 * l₀ - l₃ * l₁)
    (h₃ : D l₃ = (l₃ ^ 2 - 2 * l₂) * l₃ + 3 * l₁ - l₃ * l₂) :
    D (quarticDiscriminant l₀ l₁ l₂ l₃) =
      (6 * l₃ ^ 2 - 10 * l₂) * quarticDiscriminant l₀ l₁ l₂ l₃ := by
  simp only [quarticDiscriminant, map_sub, map_add, Derivation.leibniz, Derivation.leibniz_pow,
    smul_eq_mul, derivation_ofNat_eq_zero, nsmul_eq_mul, Nat.cast_ofNat, h₀, h₁, h₂, h₃]
  ring

/-- The characteristic coefficients of Euler multiplication on a regular
four-dimensional `F`-manifold, together with the four derivations by which the
canonical frame `X₀ = e`, `X₁ = E`, `X₂ = E ∘ E`, `X₃ = E ∘ E ∘ E` acts on them.

The fields `lam0, …, lam3` are the coefficients of the characteristic polynomial
`T ^ 4 + lam3 * T ^ 3 + lam2 * T ^ 2 + lam1 * T + lam0` of Euler multiplication,
and `frameField s` is the derivation by which `X_s` acts on functions.  The
sixteen equations are the four-dimensional coefficient identities forced by
Cayley--Hamilton and the Witt relations of a regular `F`-manifold, in the
conventions `lam4 = 1` and `lam_j = 0` for `j < 0`; see L. David and
C. Hertling, *Regular `F`-manifolds: initial conditions and Frobenius metrics*,
Ann. Sc. Norm. Super. Pisa Cl. Sci. (5) 17 (2017), 1121--1152, equations (19),
(20), (24), (25).

No `F`-manifold structure is part of this data: only a commutative ring, four of
its elements, four derivations of it, and the displayed equations. -/
structure EulerCoefficientFrame (A : Type*) [CommRing A] where
  /-- The constant coefficient of the characteristic polynomial. -/
  lam0 : A
  /-- The linear coefficient of the characteristic polynomial. -/
  lam1 : A
  /-- The quadratic coefficient of the characteristic polynomial. -/
  lam2 : A
  /-- The cubic coefficient of the characteristic polynomial. -/
  lam3 : A
  /-- The derivations by which the canonical frame `X₀, …, X₃` acts. -/
  frameField : Fin 4 → Derivation ℤ A A
  /-- The unit field lowers the coefficient index: `X₀ lam0 = -lam1`. -/
  unit_lam0 : frameField 0 lam0 = -lam1
  /-- The unit field lowers the coefficient index: `X₀ lam1 = -2 lam2`. -/
  unit_lam1 : frameField 0 lam1 = -2 * lam2
  /-- The unit field lowers the coefficient index: `X₀ lam2 = -3 lam3`. -/
  unit_lam2 : frameField 0 lam2 = -3 * lam3
  /-- The unit field lowers the coefficient index: `X₀ lam3 = -4 lam4 = -4`. -/
  unit_lam3 : frameField 0 lam3 = -4
  /-- The Euler field scales by the coefficient degree: `X₁ lam0 = 4 lam0`. -/
  euler_lam0 : frameField 1 lam0 = 4 * lam0
  /-- The Euler field scales by the coefficient degree: `X₁ lam1 = 3 lam1`. -/
  euler_lam1 : frameField 1 lam1 = 3 * lam1
  /-- The Euler field scales by the coefficient degree: `X₁ lam2 = 2 lam2`. -/
  euler_lam2 : frameField 1 lam2 = 2 * lam2
  /-- The Euler field scales by the coefficient degree: `X₁ lam3 = lam3`. -/
  euler_lam3 : frameField 1 lam3 = lam3
  /-- The square of the Euler field acts by `X₂ lam0 = -lam3 lam0`. -/
  square_lam0 : frameField 2 lam0 = -(lam3 * lam0)
  /-- The square of the Euler field acts by `X₂ lam1 = -lam3 lam1 + 4 lam0`. -/
  square_lam1 : frameField 2 lam1 = -(lam3 * lam1) + 4 * lam0
  /-- The square of the Euler field acts by `X₂ lam2 = -lam3 lam2 + 3 lam1`. -/
  square_lam2 : frameField 2 lam2 = -(lam3 * lam2) + 3 * lam1
  /-- The square of the Euler field acts by `X₂ lam3 = -lam3 lam3 + 2 lam2`. -/
  square_lam3 : frameField 2 lam3 = -(lam3 * lam3) + 2 * lam2
  /-- The cube of the Euler field acts by `X₃ lam0 = (lam3 ^ 2 - 2 lam2) lam0`. -/
  cube_lam0 : frameField 3 lam0 = (lam3 ^ 2 - 2 * lam2) * lam0
  /-- The cube of the Euler field acts by
  `X₃ lam1 = (lam3 ^ 2 - 2 lam2) lam1 - lam3 lam0`. -/
  cube_lam1 : frameField 3 lam1 = (lam3 ^ 2 - 2 * lam2) * lam1 - lam3 * lam0
  /-- The cube of the Euler field acts by
  `X₃ lam2 = (lam3 ^ 2 - 2 lam2) lam2 + 4 lam0 - lam3 lam1`. -/
  cube_lam2 : frameField 3 lam2 = (lam3 ^ 2 - 2 * lam2) * lam2 + 4 * lam0 - lam3 * lam1
  /-- The cube of the Euler field acts by
  `X₃ lam3 = (lam3 ^ 2 - 2 lam2) lam3 + 3 lam1 - lam3 lam2`. -/
  cube_lam3 : frameField 3 lam3 = (lam3 ^ 2 - 2 * lam2) * lam3 + 3 * lam1 - lam3 * lam2

namespace EulerCoefficientFrame

variable (S : EulerCoefficientFrame A)

/-- The discriminant of the characteristic polynomial of Euler multiplication. -/
def discriminant : A :=
  quarticDiscriminant S.lam0 S.lam1 S.lam2 S.lam3

/-- The four logarithmic derivatives of the discriminant along the canonical
frame of a regular four-dimensional `F`-manifold: the unit field annihilates the
discriminant, the Euler field scales it by twelve, and the two higher powers
scale it by `-6 lam3` and by `6 lam3 ^ 2 - 10 lam2`. -/
theorem frameField_discriminant :
    S.frameField 0 S.discriminant = 0 ∧
      S.frameField 1 S.discriminant = 12 * S.discriminant ∧
        S.frameField 2 S.discriminant = -6 * S.lam3 * S.discriminant ∧
          S.frameField 3 S.discriminant =
            (6 * S.lam3 ^ 2 - 10 * S.lam2) * S.discriminant :=
  ⟨quarticDiscriminant_unitField _ S.unit_lam0 S.unit_lam1 S.unit_lam2 S.unit_lam3,
    quarticDiscriminant_eulerField _ S.euler_lam0 S.euler_lam1 S.euler_lam2 S.euler_lam3,
    quarticDiscriminant_squareField _ S.square_lam0 S.square_lam1 S.square_lam2 S.square_lam3,
    quarticDiscriminant_cubeField _ S.cube_lam0 S.cube_lam1 S.cube_lam2 S.cube_lam3⟩

/-- Every operator expressed as a ring-coefficient combination of the canonical
frame multiplies the discriminant by an element of the ring, namely the same
combination of the four logarithmic factors.  Where the canonical frame is a
frame, this is the statement that the differential of the discriminant is the
discriminant times a regular one-form. -/
theorem logarithmic_of_frame_combination (D : A → A) (c : Fin 4 → A)
    (hD : ∀ x, D x = ∑ s, c s * S.frameField s x) :
    D S.discriminant =
      (12 * c 1 - 6 * S.lam3 * c 2 + (6 * S.lam3 ^ 2 - 10 * S.lam2) * c 3) * S.discriminant := by
  obtain ⟨h0, h1, h2, h3⟩ := S.frameField_discriminant
  rw [hD, Fin.sum_univ_four, h0, h1, h2, h3]
  ring

end EulerCoefficientFrame

open MvPolynomial in
/-- The derivation `∑ᵢ μᵢ ^ s ∂/∂μᵢ` of the polynomial ring in four root
variables `μ₀, …, μ₃` over the rationals. -/
private noncomputable def rootDerivation (s : ℕ) :
    Derivation ℚ (MvPolynomial (Fin 4) ℚ) (MvPolynomial (Fin 4) ℚ) :=
  (X 0 : MvPolynomial (Fin 4) ℚ) ^ s • pderiv (0 : Fin 4)
    + (X 1 : MvPolynomial (Fin 4) ℚ) ^ s • pderiv (1 : Fin 4)
    + (X 2 : MvPolynomial (Fin 4) ℚ) ^ s • pderiv (2 : Fin 4)
    + (X 3 : MvPolynomial (Fin 4) ℚ) ^ s • pderiv (3 : Fin 4)

open MvPolynomial in
/-- The root derivation viewed as a derivation over the integers, which is the
base ring used by the frame data. -/
private noncomputable def rootFrameField (s : ℕ) :
    Derivation ℤ (MvPolynomial (Fin 4) ℚ) (MvPolynomial (Fin 4) ℚ) :=
  (rootDerivation s).restrictScalars ℤ

open MvPolynomial in
/-- Restriction of scalars does not change the underlying map. -/
private theorem rootFrameField_apply (s : ℕ) (p : MvPolynomial (Fin 4) ℚ) :
    rootFrameField s p = rootDerivation s p :=
  rfl

open MvPolynomial in
/-- The universal root model of the frame data: the polynomial ring in four root
variables over the rationals, with characteristic coefficients the signed
elementary symmetric functions of those variables and with `Xₛ` acting by the
derivation `∑ᵢ μᵢ ^ s ∂/∂μᵢ`.

This model satisfies the sixteen coefficient identities, so the hypotheses
collected in `EulerCoefficientFrame` are consistent and every theorem deduced
from them has content. -/
noncomputable def rootEulerFrame : EulerCoefficientFrame (MvPolynomial (Fin 4) ℚ) where
  lam0 := X 0 * X 1 * X 2 * X 3
  lam1 := -(X 0 * X 1 * X 2 + X 0 * X 1 * X 3 + X 0 * X 2 * X 3 + X 1 * X 2 * X 3)
  lam2 := X 0 * X 1 + X 0 * X 2 + X 0 * X 3 + X 1 * X 2 + X 1 * X 3 + X 2 * X 3
  lam3 := -(X 0 + X 1 + X 2 + X 3)
  frameField := fun s => rootFrameField (s : ℕ)
  unit_lam0 := by
    show rootDerivation 0 (X 0 * X 1 * X 2 * X 3) = _
    simp [rootDerivation, Derivation.leibniz]
    ring
  unit_lam1 := by
    show rootDerivation 0 (-(X 0 * X 1 * X 2 + X 0 * X 1 * X 3 + X 0 * X 2 * X 3 + X 1 * X 2 * X 3)) = _
    simp [rootDerivation, Derivation.leibniz]
    ring
  unit_lam2 := by
    show rootDerivation 0 (X 0 * X 1 + X 0 * X 2 + X 0 * X 3 + X 1 * X 2 + X 1 * X 3 + X 2 * X 3) = _
    simp [rootDerivation, Derivation.leibniz]
    ring
  unit_lam3 := by
    show rootDerivation 0 (-(X 0 + X 1 + X 2 + X 3)) = _
    simp [rootDerivation]
    ring
  euler_lam0 := by
    show rootDerivation 1 (X 0 * X 1 * X 2 * X 3) = _
    simp [rootDerivation, Derivation.leibniz]
    ring
  euler_lam1 := by
    show rootDerivation 1 (-(X 0 * X 1 * X 2 + X 0 * X 1 * X 3 + X 0 * X 2 * X 3 + X 1 * X 2 * X 3)) = _
    simp [rootDerivation, Derivation.leibniz]
    ring
  euler_lam2 := by
    show rootDerivation 1 (X 0 * X 1 + X 0 * X 2 + X 0 * X 3 + X 1 * X 2 + X 1 * X 3 + X 2 * X 3) = _
    simp [rootDerivation, Derivation.leibniz]
    ring
  euler_lam3 := by
    show rootDerivation 1 (-(X 0 + X 1 + X 2 + X 3)) = _
    simp [rootDerivation]
    ring
  square_lam0 := by
    show rootDerivation 2 (X 0 * X 1 * X 2 * X 3) = _
    simp [rootDerivation, Derivation.leibniz]
    ring
  square_lam1 := by
    show rootDerivation 2 (-(X 0 * X 1 * X 2 + X 0 * X 1 * X 3 + X 0 * X 2 * X 3 + X 1 * X 2 * X 3)) = _
    simp [rootDerivation, Derivation.leibniz]
    ring
  square_lam2 := by
    show rootDerivation 2 (X 0 * X 1 + X 0 * X 2 + X 0 * X 3 + X 1 * X 2 + X 1 * X 3 + X 2 * X 3) = _
    simp [rootDerivation, Derivation.leibniz]
    ring
  square_lam3 := by
    show rootDerivation 2 (-(X 0 + X 1 + X 2 + X 3)) = _
    simp [rootDerivation]
    ring
  cube_lam0 := by
    show rootDerivation 3 (X 0 * X 1 * X 2 * X 3) = _
    simp [rootDerivation, Derivation.leibniz]
    ring
  cube_lam1 := by
    show rootDerivation 3 (-(X 0 * X 1 * X 2 + X 0 * X 1 * X 3 + X 0 * X 2 * X 3 + X 1 * X 2 * X 3)) = _
    simp [rootDerivation, Derivation.leibniz]
    ring
  cube_lam2 := by
    show rootDerivation 3 (X 0 * X 1 + X 0 * X 2 + X 0 * X 3 + X 1 * X 2 + X 1 * X 3 + X 2 * X 3) = _
    simp [rootDerivation, Derivation.leibniz]
    ring
  cube_lam3 := by
    show rootDerivation 3 (-(X 0 + X 1 + X 2 + X 3)) = _
    simp [rootDerivation]
    ring

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
