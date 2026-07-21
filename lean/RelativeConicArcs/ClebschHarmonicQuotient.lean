import RelativeConicArcs.ClebschConicMatchingQuotient
import Mathlib.RingTheory.MvPolynomial.EulerIdentity
import Mathlib.RingTheory.MvPolynomial.Basic
import Mathlib.Algebra.Field.ZMod

/-!
# The conic Laplacian and the low-degree harmonic/radial decomposition

Working in the polynomial ring `R[X₀, X₁, X₂]`, write the standard conic form as
`Q = X₀ X₂ − X₁²` (the polynomial whose evaluation is `conicForm` of the pairing-forgetting
quotient).  The **conic Laplacian** is the constant-coefficient second-order operator dual to `Q`,

```
Δ = 4 ∂₀∂₂ − ∂₁².
```

Its central algebraic property is the commutator identity with multiplication by `Q`: for every
polynomial `P`,

```
Δ(Q · P) = 6 • P + 4 • 𝔈 P + Q · Δ P,        𝔈 P = ∑ᵢ Xᵢ · ∂ᵢ P    (the Euler operator).
```

On a homogeneous polynomial of degree `m`, `𝔈 P = m • P`, so `Δ(Q·P) = (6 + 4m) • P + Q · Δ P`.
This single identity drives the harmonic/radial (Fischer) decomposition of the space of homogeneous
polynomials of a given degree into the kernel of `Δ` (the harmonic part) and the `Q`-multiples of
lower-degree polynomials (the radial part).  Whether that decomposition holds is governed entirely
by the invertibility in `R` of the integer scalars `6 + 4m` that appear along the radial ladder, so
the statement is genuinely characteristic-dependent and every division is carried as an explicit
hypothesis.

This module develops the identity over an arbitrary commutative ring and the decomposition over a
field with the relevant scalars invertible, in the degrees needed downstream.
-/

namespace RelativeConicArcs
namespace ConicHarmonicQuotient

open MvPolynomial

/-! ## The conic form, the Laplacian, and the Euler operator -/

section Core

variable (R : Type*) [CommRing R]

/-- The standard conic form `Q = X₀ X₂ − X₁²` as a polynomial in `R[X₀, X₁, X₂]`.  Its evaluation
`(x₀, x₁, x₂) ↦ x₀ x₂ − x₁²` is the `conicForm` of the pairing-forgetting quotient. -/
noncomputable def conic : MvPolynomial (Fin 3) R := X 0 * X 2 - X 1 ^ 2

/-- The conic Laplacian `Δ = 4 ∂₀∂₂ − ∂₁²`, as an `R`-linear endomorphism of `R[X₀, X₁, X₂]`. -/
noncomputable def lapl : MvPolynomial (Fin 3) R →ₗ[R] MvPolynomial (Fin 3) R :=
  (4 : R) • ((pderiv 0).toLinearMap ∘ₗ (pderiv 2).toLinearMap)
    - (pderiv 1).toLinearMap ∘ₗ (pderiv 1).toLinearMap

/-- The Euler (degree) operator `𝔈 P = ∑ᵢ Xᵢ · ∂ᵢ P`. -/
noncomputable def euler : MvPolynomial (Fin 3) R →ₗ[R] MvPolynomial (Fin 3) R :=
  ∑ i : Fin 3, (LinearMap.mulLeft R (X i)) ∘ₗ (pderiv i).toLinearMap

variable {R}

@[simp] theorem lapl_apply (P : MvPolynomial (Fin 3) R) :
    lapl R P = (4 : R) • pderiv 0 (pderiv 2 P) - pderiv 1 (pderiv 1 P) := by
  simp [lapl]

@[simp] theorem euler_apply (P : MvPolynomial (Fin 3) R) :
    euler R P = X 0 * pderiv 0 P + X 1 * pderiv 1 P + X 2 * pderiv 2 P := by
  simp [euler, Fin.sum_univ_three, LinearMap.mulLeft_apply]

@[simp] theorem pderiv_ofNat (i : Fin 3) (n : ℕ) [n.AtLeastTwo] :
    pderiv i (no_index (OfNat.ofNat n) : MvPolynomial (Fin 3) R) = 0 := by
  rw [show (OfNat.ofNat n : MvPolynomial (Fin 3) R) = C (OfNat.ofNat n) from
    (map_ofNat C n).symm, pderiv_C]

@[simp] theorem pderiv_zero_conic : pderiv 0 (conic R) = X 2 := by
  simp [conic]

@[simp] theorem pderiv_one_conic : pderiv 1 (conic R) = -(2 * X 1) := by
  simp [conic]

@[simp] theorem pderiv_two_conic : pderiv 2 (conic R) = X 0 := by
  simp [conic]

/-- **Conic Laplacian commutator.**  For every polynomial `P`,
`Δ(Q·P) = 6 • P + 4 • 𝔈 P + Q · Δ P`, where `𝔈` is the Euler operator.  This constant-coefficient
identity is the algebraic engine of the harmonic/radial decomposition. -/
theorem lapl_mul_conic (P : MvPolynomial (Fin 3) R) :
    lapl R (conic R * P) = (6 : R) • P + (4 : R) • euler R P + conic R * lapl R P := by
  simp only [lapl_apply, euler_apply, pderiv_mul, map_add, map_neg,
    pderiv_zero_conic, pderiv_one_conic, pderiv_two_conic, pderiv_X_self, pderiv_ofNat]
  simp only [conic, smul_eq_C_mul, map_ofNat]
  ring

/-! ### Behaviour on homogeneous polynomials -/

/-- **Euler's identity for this operator.**  On a homogeneous polynomial of degree `m`, the Euler
operator acts as multiplication by `m`. -/
theorem euler_smul_of_homog {P : MvPolynomial (Fin 3) R} {m : ℕ} (h : P.IsHomogeneous m) :
    euler R P = m • P := by
  rw [euler_apply, ← Fin.sum_univ_three fun i => X i * pderiv i P]
  exact h.sum_X_mul_pderiv

/-- A homogeneous polynomial of degree `0` is a constant, so each partial derivative vanishes. -/
theorem pderiv_of_isHomogeneous_zero {c : MvPolynomial (Fin 3) R} (h : c.IsHomogeneous 0)
    (i : Fin 3) : pderiv i c = 0 := by
  ext m
  have hc : c.coeff (m + Finsupp.single i 1) = 0 := by
    refine h.coeff_eq_zero ?_
    rw [map_add]
    simp
  rw [coeff_pderiv, coeff_zero, hc, zero_mul]

/-- The conic Laplacian annihilates constants: `Δ c = 0` when `c` is homogeneous of degree `0`. -/
theorem lapl_of_isHomogeneous_zero {c : MvPolynomial (Fin 3) R} (h : c.IsHomogeneous 0) :
    lapl R c = 0 := by
  simp [lapl_apply, pderiv_of_isHomogeneous_zero h]

/-- The conic Laplacian lowers homogeneous degree by two. -/
theorem lapl_isHomogeneous {P : MvPolynomial (Fin 3) R} {d : ℕ} (h : P.IsHomogeneous d) :
    (lapl R P).IsHomogeneous (d - 2) := by
  rw [lapl_apply, ← mem_homogeneousSubmodule]
  have h1 : pderiv 0 (pderiv 2 P) ∈ homogeneousSubmodule (Fin 3) R (d - 2) := by
    have h' := (h.pderiv (i := 2)).pderiv (i := 0)
    rwa [Nat.sub_sub] at h'
  have h2 : pderiv 1 (pderiv 1 P) ∈ homogeneousSubmodule (Fin 3) R (d - 2) := by
    have h' := (h.pderiv (i := 1)).pderiv (i := 1)
    rwa [Nat.sub_sub] at h'
  exact Submodule.sub_mem _ (Submodule.smul_mem _ _ h1) h2

/-- The commutator on a degree-`0` polynomial `c`: `Δ(Q·c) = 6 • c` (the radial ladder scalar at
`m = 0`).  Its unit status governs the degree-`2` decomposition. -/
theorem lapl_conic_mul_homog_zero {c : MvPolynomial (Fin 3) R} (h : c.IsHomogeneous 0) :
    lapl R (conic R * c) = (6 : R) • c := by
  rw [lapl_mul_conic, euler_smul_of_homog h, lapl_of_isHomogeneous_zero h]
  simp

/-- The commutator on a degree-`2` polynomial `P`: `Δ(Q·P) = 14 • P + Q · Δ P` (the radial ladder
scalar at `m = 2`).  Its unit status, together with the `m = 0` scalar, governs the degree-`4`
decomposition. -/
theorem lapl_conic_mul_homog_two {P : MvPolynomial (Fin 3) R} (h : P.IsHomogeneous 2) :
    lapl R (conic R * P) = (14 : R) • P + conic R * lapl R P := by
  rw [lapl_mul_conic, euler_smul_of_homog h, two_nsmul, smul_add]
  module

/-- Scalar multiplication preserves homogeneity. -/
theorem smul_isHomogeneous {P : MvPolynomial (Fin 3) R} {n : ℕ} (c : R) (h : P.IsHomogeneous n) :
    (c • P).IsHomogeneous n :=
  (mem_homogeneousSubmodule _ _).mp (Submodule.smul_mem _ c ((mem_homogeneousSubmodule _ _).mpr h))

/-- The conic form is homogeneous of degree two. -/
theorem conic_isHomogeneous : (conic R).IsHomogeneous 2 := by
  rw [conic]
  exact ((isHomogeneous_X R 0).mul (isHomogeneous_X R 2)).sub ((isHomogeneous_X R 1).pow 2)

/-- **Degree-one polynomials are harmonic.**  The Laplacian annihilates every homogeneous
polynomial of degree one, so the degree-one harmonic space is the whole space, with no radial part.
This holds over any commutative ring. -/
theorem lapl_of_isHomogeneous_one {P : MvPolynomial (Fin 3) R} (h : P.IsHomogeneous 1) :
    lapl R P = 0 := by
  rw [lapl_apply, pderiv_of_isHomogeneous_zero (h.pderiv (i := 2)) 0,
    pderiv_of_isHomogeneous_zero (h.pderiv (i := 1)) 1, smul_zero, sub_zero]

/-- The Laplacian of the conic form is the constant `6 = Δ Q`, the `m = 0` radial ladder scalar. -/
theorem lapl_conic : lapl R (conic R) = (6 : R) • 1 := by
  have h := lapl_conic_mul_homog_zero (R := R) (c := 1) (isHomogeneous_one (Fin 3) R)
  rwa [mul_one] at h

/-- `Δ(Q²) = 20 · Q`, over any commutative ring.  The scalar `20 = 4·5` is the `m = 2, k = 2` radial
ladder value; its vanishing is exactly the obstruction to the degree-four decomposition in
characteristic five. -/
theorem lapl_conic_sq : lapl R (conic R * conic R) = (20 : R) • conic R := by
  rw [lapl_conic_mul_homog_two conic_isHomogeneous, lapl_conic, mul_smul_comm, mul_one]
  module

/-- `X₀²` is harmonic: `Δ(X₀²) = 0`. -/
theorem lapl_X_zero_sq : lapl R (X 0 ^ 2 : MvPolynomial (Fin 3) R) = 0 := by
  simp [lapl_apply]

/-- The conic form is nonzero (it evaluates to `1` at `(1, 0, 1)`). -/
theorem conic_ne_zero [Nontrivial R] : conic R ≠ 0 := by
  intro hc
  have h1 : eval ![1, 0, 1] (conic R) = 0 := by rw [hc, map_zero]
  rw [conic] at h1
  simp at h1

end Core

/-! ## Bridge to the conic pairing-forgetting quotient

The pairing-forgetting quotient represents each secant of the standard conic by the linear form
`secant`, and its four-endpoint switch difference is a multiple of the conic form `conicForm`.
Evaluated on the coordinate generators `X₀, X₁, X₂` with the endpoint coordinates embedded as
constants, that switch difference becomes `Q` times a constant: a radial degree-two polynomial with
no harmonic component.  This identifies the pairing data forgotten by the conic restriction with the
radial part quotiented out by the harmonic decomposition. -/

section Bridge

variable {R : Type*} [CommRing R]

open ConicMatchingQuotient

/-- **The switch difference is radial.**  With endpoint coordinates embedded as constants and the
plane coordinates taken to be the generators `X₀, X₁, X₂`, the four-endpoint secant switch difference
of the pairing-forgetting quotient equals `Q` times the constant `[a,d][b,c]`.  It therefore lies in
the radial (conic-ideal) part of the degree-two space, so its harmonic part is zero. -/
theorem secant_switch_radial (sa ta sb tb sc tc sd td : R) :
    secant (C sa) (C ta) (C sb) (C tb) (X 0) (X 1) (X 2)
        * secant (C sc) (C tc) (C sd) (C td) (X 0) (X 1) (X 2)
      - secant (C sa) (C ta) (C sc) (C tc) (X 0) (X 1) (X 2)
        * secant (C sb) (C tb) (C sd) (C td) (X 0) (X 1) (X 2)
      = conic R * C (bracket sa ta sd td * bracket sb tb sc tc) := by
  have hb : ∀ a b c d : R,
      bracket (C a : MvPolynomial (Fin 3) R) (C b) (C c) (C d) = C (bracket a b c d) := by
    intro a b c d; simp [ConicMatchingQuotient.bracket, map_mul, map_sub]
  have hcf : conicForm (X 0 : MvPolynomial (Fin 3) R) (X 1) (X 2) = conic R := by
    simp [ConicMatchingQuotient.conicForm, conic]
  rw [secant_switch, hb, hb, hcf, ← map_mul]
  ring

end Bridge

/-! ## The harmonic/radial decomposition over a field

Over a field, a homogeneous polynomial `P` of degree `d` splits as `P = H + Q · R` with `H` harmonic
(`Δ H = 0`) of degree `d` and `R` of degree `d − 2` — the harmonic/radial (Fischer) decomposition —
provided the radial ladder scalars are invertible.  Degree `1` is unconditional; degree `2` needs
`6 ≠ 0`; degree `4` needs `14 ≠ 0` and `20 ≠ 0`.  Both the existence of the split and the triviality
of the harmonic∩radial intersection are proved; together they exhibit the direct sum.

The harmonic representative is produced by an explicit projection built from `Δ`, so "harmonic" is
the genuine differential condition `Δ H = 0` and the decomposition is not true by definition.  The
scalars are carried as hypotheses, making the statement characteristic-aware. -/

section Decomposition

variable {K : Type*} [Field K]

/-- A polynomial is **harmonic** for the conic Laplacian when `Δ` annihilates it. -/
def IsHarmonic (P : MvPolynomial (Fin 3) K) : Prop := lapl K P = 0

/-- **Degree one: everything is harmonic.**  Every homogeneous polynomial of degree one lies in the
kernel of the conic Laplacian; the radial part is zero. -/
theorem isHarmonic_of_isHomogeneous_one {P : MvPolynomial (Fin 3) K} (h : P.IsHomogeneous 1) :
    IsHarmonic P :=
  lapl_of_isHomogeneous_one h

/-- **Degree-two harmonic/radial decomposition — existence.**  When `6 ≠ 0`, every homogeneous
degree-two polynomial `P` writes as `H + Q · R` with `H` harmonic of degree two and `R` a constant
(degree zero).  The projection is `R = 6⁻¹ · Δ P`. -/
theorem decomposition_two {P : MvPolynomial (Fin 3) K} (h : P.IsHomogeneous 2) (h6 : (6 : K) ≠ 0) :
    ∃ H R', P = H + conic K * R' ∧ IsHarmonic H ∧ H.IsHomogeneous 2 ∧ R'.IsHomogeneous 0 := by
  have hR0 : ((6 : K)⁻¹ • lapl K P).IsHomogeneous 0 := smul_isHomogeneous _ (lapl_isHomogeneous h)
  refine ⟨P - conic K * ((6 : K)⁻¹ • lapl K P), (6 : K)⁻¹ • lapl K P, by ring, ?_, ?_, hR0⟩
  · show lapl K (P - conic K * ((6 : K)⁻¹ • lapl K P)) = 0
    rw [map_sub, mul_smul_comm, map_smul, lapl_conic_mul_homog_zero (lapl_isHomogeneous h),
      smul_smul, inv_mul_cancel₀ h6, one_smul, sub_self]
  · exact h.sub (conic_isHomogeneous.mul hR0)

/-- **Degree-two harmonic/radial decomposition — uniqueness of the radial part.**  When `6 ≠ 0`, the
only constant `R` with `Q · R` harmonic is `R = 0`; hence the harmonic and radial subspaces meet only
in zero. -/
theorem radial_eq_zero_two {R' : MvPolynomial (Fin 3) K} (h : R'.IsHomogeneous 0)
    (hker : IsHarmonic (conic K * R')) (h6 : (6 : K) ≠ 0) : R' = 0 := by
  rw [IsHarmonic, lapl_conic_mul_homog_zero h] at hker
  exact (smul_eq_zero.mp hker).resolve_left h6

/-- **Degree-four harmonic/radial decomposition — existence.**  When `14 ≠ 0` and `20 ≠ 0`, every
homogeneous degree-four polynomial `P` writes as `H + Q · R` with `H` harmonic of degree four and `R`
of degree two.  The projection is `R = 14⁻¹ · Δ P − (14·20)⁻¹ · Q · Δ² P`. -/
theorem decomposition_four {P : MvPolynomial (Fin 3) K} (h : P.IsHomogeneous 4)
    (h14 : (14 : K) ≠ 0) (h20 : (20 : K) ≠ 0) :
    ∃ H R', P = H + conic K * R' ∧ IsHarmonic H ∧ H.IsHomogeneous 4 ∧ R'.IsHomogeneous 2 := by
  have hS : (lapl K P).IsHomogeneous 2 := lapl_isHomogeneous h
  have hT : (lapl K (lapl K P)).IsHomogeneous 0 := lapl_isHomogeneous hS
  set R' : MvPolynomial (Fin 3) K :=
    (14 : K)⁻¹ • lapl K P
      - ((14 : K)⁻¹ * (20 : K)⁻¹) • (conic K * lapl K (lapl K P)) with hR'
  have hR'h : R'.IsHomogeneous 2 :=
    (smul_isHomogeneous _ hS).sub (smul_isHomogeneous _ (conic_isHomogeneous.mul hT))
  refine ⟨P - conic K * R', R', by ring, ?_, h.sub (conic_isHomogeneous.mul hR'h), hR'h⟩
  show lapl K (P - conic K * R') = 0
  have e2 : lapl K (conic K * (conic K * lapl K (lapl K P)))
      = (20 : K) • (conic K * lapl K (lapl K P)) := by
    rw [lapl_conic_mul_homog_two (conic_isHomogeneous.mul hT), lapl_conic_mul_homog_zero hT,
      mul_smul_comm]
    module
  have key : lapl K (conic K * R') = lapl K P := by
    rw [hR', mul_sub]
    simp only [mul_smul_comm, map_sub, map_smul]
    rw [lapl_conic_mul_homog_two hS, e2]
    match_scalars <;> (field_simp; try ring)
  rw [map_sub, key, sub_self]

/-- **Degree-four harmonic/radial decomposition — uniqueness of the radial part.**  When `14 ≠ 0`
and `20 ≠ 0`, the only degree-two `R` with `Q · R` harmonic is `R = 0`; hence the harmonic and
radial subspaces meet only in zero. -/
theorem radial_eq_zero_four {R' : MvPolynomial (Fin 3) K} (h : R'.IsHomogeneous 2)
    (hker : IsHarmonic (conic K * R')) (h14 : (14 : K) ≠ 0) (h20 : (20 : K) ≠ 0) : R' = 0 := by
  rw [IsHarmonic, lapl_conic_mul_homog_two h] at hker
  have hLR : (lapl K R').IsHomogeneous 0 := lapl_isHomogeneous h
  have h20lap : (20 : K) • lapl K R' = 0 := by
    have hc := congrArg (lapl K) hker
    rw [map_add, map_smul, lapl_conic_mul_homog_zero hLR, map_zero] at hc
    rw [show (20 : K) • lapl K R' = (14 : K) • lapl K R' + (6 : K) • lapl K R' from by module, hc]
  have hlaplR : lapl K R' = 0 := (smul_eq_zero.mp h20lap).resolve_left h20
  rw [hlaplR, mul_zero, add_zero] at hker
  exact (smul_eq_zero.mp hker).resolve_left h14

/-! ### Characteristic obstructions to the degree-four decomposition

When a radial ladder scalar vanishes, the harmonic and radial subspaces of the degree-four space
intersect nontrivially, so no direct-sum decomposition `Δ⁻¹0 ⊕ Q·(deg 2)` of the degree-four space
exists.  Two independent obstructions occur: `20 = 0` makes `Q²` harmonic, and `14 = 0` makes
`Q · X₀²` harmonic. -/

/-- **Obstruction at `20 = 0`.**  If `20 = 0` then `Q²` is a nonzero degree-two multiple of `Q` whose
product with `Q` (namely `Q²`) is harmonic, so the harmonic and radial degree-four subspaces meet
outside zero and the degree-four decomposition fails. -/
theorem harmonic_radial_meet_of_twenty_eq_zero (h20 : (20 : K) = 0) :
    ∃ R', R'.IsHomogeneous 2 ∧ IsHarmonic (conic K * R') ∧ R' ≠ 0 :=
  ⟨conic K, conic_isHomogeneous, by rw [IsHarmonic, lapl_conic_sq, h20, zero_smul], conic_ne_zero⟩

/-- **Obstruction at `14 = 0`.**  If `14 = 0` then `X₀²` is a nonzero harmonic degree-two polynomial
with `Q · X₀²` harmonic, so the harmonic and radial degree-four subspaces meet outside zero and the
degree-four decomposition fails. -/
theorem harmonic_radial_meet_of_fourteen_eq_zero (h14 : (14 : K) = 0) :
    ∃ R', R'.IsHomogeneous 2 ∧ IsHarmonic (conic K * R') ∧ R' ≠ 0 := by
  refine ⟨X 0 ^ 2, (isHomogeneous_X K 0).pow 2, ?_, pow_ne_zero 2 (X_ne_zero 0)⟩
  rw [IsHarmonic, lapl_conic_mul_homog_two ((isHomogeneous_X K 0).pow 2), lapl_X_zero_sq,
    mul_zero, add_zero, h14, zero_smul]

end Decomposition

/-! ## The bounded degrees over the prime fields `𝔽₅, 𝔽₇, 𝔽₁₁`

The degree-one and degree-two decompositions hold over each of `𝔽₅, 𝔽₇, 𝔽₁₁`.  The degree-four
decomposition holds over `𝔽₁₁` (where `14, 20 ≠ 0`) but **fails** over `𝔽₅` (where `20 = 0`) and over
`𝔽₇` (where `14 = 0`); the failures are witnessed by explicit harmonic radial polynomials. -/

section FiniteFields

instance : Fact (Nat.Prime 5) := ⟨by norm_num⟩
instance : Fact (Nat.Prime 7) := ⟨by norm_num⟩
instance : Fact (Nat.Prime 11) := ⟨by norm_num⟩

/-- Degree-two decomposition over `𝔽₅`. -/
theorem decomposition_two_zmod5 {P : MvPolynomial (Fin 3) (ZMod 5)} (h : P.IsHomogeneous 2) :
    ∃ H R', P = H + conic (ZMod 5) * R' ∧ IsHarmonic H ∧ H.IsHomogeneous 2 ∧ R'.IsHomogeneous 0 :=
  decomposition_two h (by decide)

/-- Degree-two decomposition over `𝔽₇`. -/
theorem decomposition_two_zmod7 {P : MvPolynomial (Fin 3) (ZMod 7)} (h : P.IsHomogeneous 2) :
    ∃ H R', P = H + conic (ZMod 7) * R' ∧ IsHarmonic H ∧ H.IsHomogeneous 2 ∧ R'.IsHomogeneous 0 :=
  decomposition_two h (by decide)

/-- Degree-two decomposition over `𝔽₁₁`. -/
theorem decomposition_two_zmod11 {P : MvPolynomial (Fin 3) (ZMod 11)} (h : P.IsHomogeneous 2) :
    ∃ H R', P = H + conic (ZMod 11) * R' ∧ IsHarmonic H ∧ H.IsHomogeneous 2 ∧ R'.IsHomogeneous 0 :=
  decomposition_two h (by decide)

/-- Degree-four decomposition over `𝔽₁₁` (existence). -/
theorem decomposition_four_zmod11 {P : MvPolynomial (Fin 3) (ZMod 11)} (h : P.IsHomogeneous 4) :
    ∃ H R', P = H + conic (ZMod 11) * R' ∧ IsHarmonic H ∧ H.IsHomogeneous 4 ∧ R'.IsHomogeneous 2 :=
  decomposition_four h (by decide) (by decide)

/-- Degree-four decomposition over `𝔽₁₁` (uniqueness of the radial part). -/
theorem radial_eq_zero_four_zmod11 {R' : MvPolynomial (Fin 3) (ZMod 11)} (h : R'.IsHomogeneous 2)
    (hker : IsHarmonic (conic (ZMod 11) * R')) : R' = 0 :=
  radial_eq_zero_four h hker (by decide) (by decide)

/-- **Degree-four decomposition fails over `𝔽₅`**: `Q²` lies in the harmonic and radial subspaces. -/
theorem decomposition_four_fails_zmod5 :
    ∃ R' : MvPolynomial (Fin 3) (ZMod 5),
      R'.IsHomogeneous 2 ∧ IsHarmonic (conic (ZMod 5) * R') ∧ R' ≠ 0 :=
  harmonic_radial_meet_of_twenty_eq_zero (by decide)

/-- **Degree-four decomposition fails over `𝔽₇`**: `Q · X₀²` lies in the harmonic and radial
subspaces. -/
theorem decomposition_four_fails_zmod7 :
    ∃ R' : MvPolynomial (Fin 3) (ZMod 7),
      R'.IsHomogeneous 2 ∧ IsHarmonic (conic (ZMod 7) * R') ∧ R' ≠ 0 :=
  harmonic_radial_meet_of_fourteen_eq_zero (by decide)

end FiniteFields

end ConicHarmonicQuotient
end RelativeConicArcs
