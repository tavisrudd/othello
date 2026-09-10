import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.PowerSeriesLogarithmicVanishing

/-!
# Vanishing for homogeneous formal differential systems

Over a characteristic-zero domain, a finite family of multivariate power series
with zero constant coefficients is zero if every coordinate derivative is a
linear combination of that family with power-series coefficients. The proof
uses the least total degree occurring anywhere in the family. This concerns
formal power series; no identification with an analytic germ is assumed.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum

open MvPowerSeries

/-- A finite family with zero initial values solving a homogeneous linear system
of formal partial differential equations over a characteristic-zero domain
vanishes identically. The variables need not form a finite type. -/
theorem family_eq_zero_of_constantCoeff_eq_zero_of_differential_system
    {σ ι K : Type*} [Fintype ι] [CommRing K] [NoZeroDivisors K] [CharZero K]
    (F : ι → MvPowerSeries σ K) (ω : σ → ι → ι → MvPowerSeries σ K)
    (hconst : ∀ j, coeff 0 (F j) = 0)
    (hsystem : ∀ i j, formalPartialDerivative i (F j) = ∑ k, F k * ω i j k) :
    ∀ j, F j = 0 := by
  classical
  intro j
  by_contra hF
  have hex : ∃ n : ℕ, ∃ j, ∃ d : σ →₀ ℕ, Finsupp.degree d = n ∧ coeff d (F j) ≠ 0 := by
    by_contra hnone
    push Not at hnone
    exact hF (MvPowerSeries.ext fun d => by simpa using hnone (Finsupp.degree d) j d rfl)
  obtain ⟨j₀, d₀, hdeg, hne⟩ := Nat.find_spec hex
  have hmin : ∀ j, ∀ d : σ →₀ ℕ, Finsupp.degree d < Nat.find hex → coeff d (F j) = 0 := by
    intro j d hlt
    by_contra hcon
    exact absurd (Nat.find_le ⟨j, d, rfl, hcon⟩) (not_le.mpr hlt)
  have hpos : 0 < Nat.find hex := by
    rcases Nat.eq_zero_or_pos (Nat.find hex) with h | h
    · rw [h] at hdeg
      rw [Finsupp.degree_eq_zero_iff] at hdeg
      exact absurd (hdeg ▸ hconst j₀) hne
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
  have hleft : coeff e (formalPartialDerivative i (F j₀)) = ((d₀ i : ℕ) : K) * coeff d₀ (F j₀) := by
    rw [coeff_formalPartialDerivative, hadd, hei]
  have hright : coeff e (formalPartialDerivative i (F j₀)) = 0 := by
    rw [hsystem i j₀, map_sum]
    exact Finset.sum_eq_zero fun k _ => coeff_mul_eq_zero_of_degree_lt (hmin k) hlt
  rw [hright] at hleft
  have hcast : ((d₀ i : ℕ) : K) ≠ 0 := Nat.cast_ne_zero.mpr hi
  exact hne (by
    rcases mul_eq_zero.mp hleft.symm with h | h
    · exact absurd h hcast
    · exact h)

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum
