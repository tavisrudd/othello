import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.MultivariableFlatGaugeUniqueness
import Mathlib.RingTheory.LaurentSeries

/-!
# Uniform Laurent bounds from finite bulk support

A matrix-valued multivariate formal series with ordinary Laurent-series
coefficients has an individual Laurent lower bound at every bulk monomial.  A
single lower bound for the whole matrix does not follow without further
control on the bulk support.  This module proves the precise finite-support
bridge: if only finitely many bulk monomials have nonzero coefficient matrices,
then one integer bounds every loop exponent occurring anywhere in the series.

The theorem is purely algebraic.  It neither proves finite bulk support for a
flat gauge modulo a positive filtration nor identifies such support with the
nilpotence mechanism in the manuscript.  No inverse-limit or analytic gauge is
constructed.  The proof is symbolic and kernel checked, with no external
computation or oracle.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Quantum

/-- Only the listed bulk monomials may have nonzero coefficient matrices. -/
def HasFiniteBulkSupport
    (Coordinate Index R : Type*) [Fintype Index] [DecidableEq Index]
    [CommRing R]
    (series : Matrix Index Index
      (MvPowerSeries Coordinate (LaurentSeries R))) : Prop :=
  ∃ support : Finset (Coordinate →₀ ℕ),
    ∀ row column degree, degree ∉ support →
      MvPowerSeries.coeff degree (series row column) = 0

/-- One integer is a lower bound for every Laurent coefficient occurring in
every matrix entry and bulk monomial. -/
def HasMatrixBulkUniformLaurentLowerBound
    (Coordinate Index R : Type*) [Fintype Index] [DecidableEq Index]
    [CommRing R]
    (series : Matrix Index Index
      (MvPowerSeries Coordinate (LaurentSeries R))) : Prop :=
  ∃ lowerBound : ℤ, ∀ row column degree exponent,
    exponent < lowerBound →
      (MvPowerSeries.coeff degree (series row column)).coeff exponent = 0

/-- A finite family of ordinary Laurent series has a common lower bound. -/
theorem finiteFamily_hasUniformLaurentLowerBound
    {Family R : Type*} [Fintype Family] [CommRing R]
    (series : Family → LaurentSeries R) :
    ∃ lowerBound : ℤ, ∀ member exponent,
      exponent < lowerBound → (series member).coeff exponent = 0 := by
  classical
  have finiteOrders : (Set.range fun member ↦ (series member).order).Finite :=
    Set.toFinite _
  obtain ⟨lowerBound, hlowerBound⟩ := finiteOrders.bddBelow
  refine ⟨lowerBound, fun member exponent hexponent ↦ ?_⟩
  apply HahnSeries.coeff_eq_zero_of_lt_order
  exact lt_of_lt_of_le hexponent
    (hlowerBound ⟨member, rfl⟩)

/-- Finite bulk support gives a single Laurent lower bound for the whole
matrix-valued multivariate series. -/
theorem hasUniformLaurentLowerBound_of_finiteBulkSupport
    {Coordinate Index R : Type*} [Fintype Index] [DecidableEq Index]
    [CommRing R]
    (series : Matrix Index Index
      (MvPowerSeries Coordinate (LaurentSeries R)))
    (finiteSupport : HasFiniteBulkSupport Coordinate Index R series) :
    HasMatrixBulkUniformLaurentLowerBound Coordinate Index R series := by
  classical
  obtain ⟨support, hsupport⟩ := finiteSupport
  let Family := Index × Index × {degree // degree ∈ support}
  let coefficient : Family → LaurentSeries R := fun member ↦
    MvPowerSeries.coeff member.2.2.1 (series member.1 member.2.1)
  obtain ⟨lowerBound, hlowerBound⟩ :=
    finiteFamily_hasUniformLaurentLowerBound coefficient
  refine ⟨lowerBound, fun row column degree exponent hexponent ↦ ?_⟩
  by_cases hdegree : degree ∈ support
  · exact hlowerBound (row, column, ⟨degree, hdegree⟩) exponent hexponent
  · rw [hsupport row column degree hdegree]
    simp

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
