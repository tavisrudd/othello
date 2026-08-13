import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.MultivariableLaurentBounds
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.FilteredCoefficientQuotients

/-!
# Finite bulk support from positive-degree truncation

For finitely many bulk coordinates, only finitely many multivariate monomials
have total degree below a fixed natural-number cutoff.  Consequently, a
matrix-valued multivariate series whose coefficients vanish in every degree at
or above that cutoff has finite bulk support and therefore has a uniform
Laurent lower bound by
`hasUniformLaurentLowerBound_of_finiteBulkSupport`.

This module isolates the combinatorial truncation step.  The vanishing of
high-total-degree coefficients is an explicit hypothesis: Lean does not infer
it from a geometric positive-filtration or nilpotence statement.  No quotient
tower, inverse-limit Laurent gauge, or analytic specialization is constructed.
The proofs are symbolic and kernel checked, with no external computation or
oracle.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Quantum

/-- The finite set of monomials obtained by allowing every coordinate exponent
to range below `cutoff`.  It contains every monomial of total degree below the
cutoff, although it can contain additional monomials. -/
noncomputable def bulkMonomialBoxBelow
    (Coordinate : Type*) [Fintype Coordinate] (cutoff : ℕ) :
    Finset (Coordinate →₀ ℕ) := by
  classical
  exact (Finset.univ : Finset (Coordinate → Fin cutoff)).image
    (fun exponent ↦
      Finsupp.equivFunOnFinite.symm (fun coordinate ↦ (exponent coordinate : ℕ)))

/-- Every monomial of total degree below the cutoff lies in the finite exponent
box. -/
theorem mem_bulkMonomialBoxBelow_of_totalDegree_lt
    {Coordinate : Type*} [Fintype Coordinate]
    (cutoff : ℕ) (degree : Coordinate →₀ ℕ)
    (degree_lt : multivariableTotalDegree degree < cutoff) :
    degree ∈ bulkMonomialBoxBelow Coordinate cutoff := by
  classical
  let exponent : Coordinate → Fin cutoff := fun coordinate ↦
    ⟨degree coordinate, lt_of_le_of_lt
      (Finsupp.single_eval_le_sum degree (g := id) rfl
        (fun value ↦ Nat.zero_le value) coordinate)
      degree_lt⟩
  refine Finset.mem_image.mpr ⟨exponent, Finset.mem_univ _, ?_⟩
  apply Finsupp.ext
  intro coordinate
  have evaluation := congrFun
    (Finsupp.equivFunOnFinite.apply_symm_apply
      (fun coordinate ↦ (exponent coordinate : ℕ))) coordinate
  simpa [exponent] using evaluation

/-- Vanishing of all coefficients at or above one total-degree cutoff gives
finite bulk support. -/
theorem hasFiniteBulkSupport_of_coefficients_eq_zero_of_cutoff_le_totalDegree
    {Coordinate Index R : Type*} [Fintype Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing R]
    (series : Matrix Index Index
      (MvPowerSeries Coordinate (LaurentSeries R)))
    (cutoff : ℕ)
    (vanishes : ∀ row column degree,
      cutoff ≤ multivariableTotalDegree degree →
        MvPowerSeries.coeff degree (series row column) = 0) :
    HasFiniteBulkSupport Coordinate Index R series := by
  classical
  refine ⟨bulkMonomialBoxBelow Coordinate cutoff, fun row column degree outside ↦ ?_⟩
  apply vanishes row column degree
  by_contra not_le
  exact outside (mem_bulkMonomialBoxBelow_of_totalDegree_lt cutoff degree
    (Nat.lt_of_not_ge not_le))

/-- A total-degree cutoff therefore yields one Laurent lower bound for the
whole matrix-valued multivariate series. -/
theorem hasUniformLaurentLowerBound_of_coefficients_eq_zero_of_cutoff_le_totalDegree
    {Coordinate Index R : Type*} [Fintype Coordinate]
    [Fintype Index] [DecidableEq Index] [CommRing R]
    (series : Matrix Index Index
      (MvPowerSeries Coordinate (LaurentSeries R)))
    (cutoff : ℕ)
    (vanishes : ∀ row column degree,
      cutoff ≤ multivariableTotalDegree degree →
        MvPowerSeries.coeff degree (series row column) = 0) :
    HasMatrixBulkUniformLaurentLowerBound Coordinate Index R series :=
  hasUniformLaurentLowerBound_of_finiteBulkSupport series
    (hasFiniteBulkSupport_of_coefficients_eq_zero_of_cutoff_le_totalDegree
      series cutoff vanishes)

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
