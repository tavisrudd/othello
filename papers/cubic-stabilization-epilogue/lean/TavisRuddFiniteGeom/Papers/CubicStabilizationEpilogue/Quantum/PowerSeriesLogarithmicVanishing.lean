import Mathlib.Tactic
import Mathlib.RingTheory.MvPowerSeries.Basic
import Mathlib.Data.Finsupp.Weight
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.QuarticDiscriminantDerivations

/-!
# Vanishing of a formal power series with a logarithmic differential

Let `K` be a commutative domain of characteristic zero and let `F` be a formal
power series in the variables `σ` over `K`.  Suppose that every formal partial
derivative of `F` is a multiple of `F`,

  `∂ᵢ F = F * ωᵢ`,

which is the statement that the differential of `F` is `F` times a regular
one-form.  If in addition the constant coefficient of `F` vanishes, then `F` is
the zero series.

The proof is the coefficient form of the classical argument: pick a monomial of
least total degree with a nonzero coefficient in `F`; differentiating in a
variable occurring in that monomial produces a nonzero coefficient in total
degree one lower, while the product `F * ωᵢ` has no coefficient below the least
degree of `F` at all.

The application is to the discriminant of the characteristic polynomial of Euler
multiplication on a regular four-dimensional `F`-manifold, where the four
logarithmic derivatives along the canonical frame are supplied by
`EulerCoefficientFrame.frameField_discriminant`.  The two are combined in
`EulerCoefficientFrame.discriminant_eq_zero_of_constantCoeff_eq_zero`: on a
formal power-series germ whose coordinate derivations are ring-coefficient
combinations of the canonical frame, a discriminant vanishing at the base point
vanishes identically.

Lean models the germ by a formal power-series ring.  It does not construct an
analytic or rigid-analytic germ, the isomorphism of a completed local ring with
a power-series ring, or the injectivity of a Noetherian local ring in its
completion; the results below therefore concern the formal model only.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Quantum

open MvPowerSeries

variable {σ : Type*} {R : Type*} [CommRing R]

/-- The formal partial derivative of a multivariate formal power series in the
variable `i`, defined coefficientwise by
`∂ᵢ F` at `d` equal to `(d i + 1) * F` at `d + eᵢ`. -/
noncomputable def formalPartialDerivative (i : σ) (F : MvPowerSeries σ R) : MvPowerSeries σ R :=
  fun d => ((d i + 1 : ℕ) : R) * coeff (d + Finsupp.single i 1) F

/-- The defining coefficient formula of the formal partial derivative. -/
theorem coeff_formalPartialDerivative (i : σ) (F : MvPowerSeries σ R) (d : σ →₀ ℕ) :
    coeff d (formalPartialDerivative i F) =
      ((d i + 1 : ℕ) : R) * coeff (d + Finsupp.single i 1) F :=
  rfl

/-- If every coefficient of `F` in total degree below `m` vanishes, then so does
every coefficient of `F * G` in total degree below `m`: in a factorization of a
monomial of degree below `m` the left factor also has degree below `m`. -/
theorem coeff_mul_eq_zero_of_degree_lt [DecidableEq σ] {F G : MvPowerSeries σ R} {m : ℕ}
    (hF : ∀ d : σ →₀ ℕ, Finsupp.degree d < m → coeff d F = 0)
    {d : σ →₀ ℕ} (hd : Finsupp.degree d < m) : coeff d (F * G) = 0 := by
  rw [coeff_mul]
  refine Finset.sum_eq_zero ?_
  rintro ⟨a, b⟩ hab
  rw [Finset.mem_antidiagonal] at hab
  have hle : Finsupp.degree a ≤ Finsupp.degree d := by
    rw [← hab, map_add]
    exact Nat.le_add_right _ _
  rw [hF a (lt_of_le_of_lt hle hd), zero_mul]

/-- A formal power series over a commutative domain of characteristic zero whose
constant coefficient vanishes and each of whose formal partial derivatives is a
multiple of the series itself is identically zero. -/
theorem eq_zero_of_constantCoeff_eq_zero_of_logarithmic {K : Type*} [CommRing K]
    [NoZeroDivisors K] [CharZero K] {F : MvPowerSeries σ K} {ω : σ → MvPowerSeries σ K}
    (hconst : coeff 0 F = 0)
    (hlog : ∀ i : σ, formalPartialDerivative i F = F * ω i) :
    F = 0 := by
  classical
  by_contra hF
  have hex : ∃ n : ℕ, ∃ d : σ →₀ ℕ, Finsupp.degree d = n ∧ coeff d F ≠ 0 := by
    by_contra hnone
    push Not at hnone
    exact hF (MvPowerSeries.ext fun d => by simpa using hnone (Finsupp.degree d) d rfl)
  obtain ⟨d₀, hdeg, hne⟩ := Nat.find_spec hex
  have hmin : ∀ d : σ →₀ ℕ, Finsupp.degree d < Nat.find hex → coeff d F = 0 := by
    intro d hlt
    by_contra hcon
    exact absurd (Nat.find_le ⟨d, rfl, hcon⟩) (not_le.mpr hlt)
  have hpos : 0 < Nat.find hex := by
    rcases Nat.eq_zero_or_pos (Nat.find hex) with h | h
    · rw [h] at hdeg
      rw [Finsupp.degree_eq_zero_iff] at hdeg
      exact absurd (hdeg ▸ hconst) hne
    · exact h
  have hd₀ : d₀ ≠ 0 := by
    intro h
    rw [h] at hdeg
    simp only [map_zero] at hdeg
    omega
  obtain ⟨i, hi⟩ := Finsupp.ne_iff.mp hd₀
  simp only [Finsupp.coe_zero, Pi.zero_apply] at hi
  set e : σ →₀ ℕ := d₀ - Finsupp.single i 1 with he
  have hsingle : Finsupp.single i 1 ≤ d₀ := by
    rw [Finsupp.single_le_iff]
    omega
  have hadd : e + Finsupp.single i 1 = d₀ := by
    rw [he, tsub_add_cancel_of_le hsingle]
  have hei : e i + 1 = d₀ i := by
    have := congrArg (fun f : σ →₀ ℕ => f i) hadd
    simpa using this
  have hdegree : Finsupp.degree e + 1 = Nat.find hex := by
    have := congrArg Finsupp.degree hadd
    rw [map_add, Finsupp.degree_single, hdeg] at this
    exact this
  have hlt : Finsupp.degree e < Nat.find hex := by omega
  have hleft : coeff e (formalPartialDerivative i F) = ((d₀ i : ℕ) : K) * coeff d₀ F := by
    rw [coeff_formalPartialDerivative, hadd, hei]
  rw [hlog i, coeff_mul_eq_zero_of_degree_lt hmin hlt] at hleft
  have hcast : ((d₀ i : ℕ) : K) ≠ 0 := Nat.cast_ne_zero.mpr hi
  exact hne (by
    rcases mul_eq_zero.mp hleft.symm with h | h
    · exact absurd h hcast
    · exact h)

namespace EulerCoefficientFrame

/-- On a formal power-series germ whose coordinate derivations are
ring-coefficient combinations of the canonical frame `X₀, …, X₃`, a discriminant
of the characteristic polynomial of Euler multiplication that vanishes at the
base point vanishes identically.

The hypothesis `hframe` is the statement that `X₀, …, X₃` is a frame: each
formal partial derivative is expressed in it with power-series coefficients.
The conclusion is the vanishing statement of the discriminant lemma for a
regular four-dimensional `F`-manifold.

Lean constructs neither the `F`-manifold, its Euler field, nor the germ; the
frame, the coefficient identities carried by `EulerCoefficientFrame`, and the
vanishing of the discriminant at the base point are hypotheses. -/
theorem discriminant_eq_zero_of_constantCoeff_eq_zero {K : Type*} [CommRing K]
    [NoZeroDivisors K] [CharZero K] (S : EulerCoefficientFrame (MvPowerSeries σ K))
    (c : σ → Fin 4 → MvPowerSeries σ K)
    (hframe : ∀ (i : σ) (F : MvPowerSeries σ K),
      formalPartialDerivative i F = ∑ s, c i s * S.frameField s F)
    (hconst : coeff 0 S.discriminant = 0) :
    S.discriminant = 0 := by
  refine eq_zero_of_constantCoeff_eq_zero_of_logarithmic
    (ω := fun i => 12 * c i 1 - 6 * S.lam3 * c i 2 + (6 * S.lam3 ^ 2 - 10 * S.lam2) * c i 3)
    hconst (fun i => ?_)
  rw [S.logarithmic_of_frame_combination (formalPartialDerivative i) (c i) (hframe i), mul_comm]

end EulerCoefficientFrame

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
