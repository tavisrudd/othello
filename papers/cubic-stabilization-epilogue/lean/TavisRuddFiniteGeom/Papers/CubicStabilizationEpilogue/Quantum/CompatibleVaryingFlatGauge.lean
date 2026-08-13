import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.VaryingFlatGauge

/-!
# Compatible one-variable varying formal flat gauges

Fix a finite matrix index.  At every natural-number level, let the coefficient
ring be a commutative `ℚ`-algebra, let adjacent levels be related by a
`ℚ`-algebra homomorphism, and supply every coefficient of a one-variable
connection matrix compatibly under reduction.  Lean constructs the unique
normalized formal power-series solution of `dG/dt=-A(t)G(t)` at each level.
Its coefficients and its whole formal series commute with every adjacent
reduction, and the solution is an invertible matrix over the power-series ring.

The coefficient rings, reductions, and connection coefficients are supplied
abstractly.  This module does not identify them with an ideal-quotient tower or
with a quantum connection.  It represents one formal variable and ordinary
power series, not multivariable bulk coordinates, Laurent dependence on a loop
parameter, convergence, or an analytic gauge.  The proofs are symbolic and
kernel checked, with no external computation or oracle.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Quantum

universe u v

/-- A natural-number-indexed system of one-variable connection coefficients
over commutative rational algebras, compatible under adjacent coefficient
reductions. -/
structure CompatibleVaryingConnectionSystem
    (Index : Type v) [Fintype Index] [DecidableEq Index] where
  Coefficient : ℕ → Type u
  coefficientRing : ∀ level, CommRing (Coefficient level)
  coefficientAlgebra : ∀ level, Algebra ℚ (Coefficient level)
  reduction : ∀ level, Coefficient (level + 1) →ₐ[ℚ] Coefficient level
  connectionCoefficient :
    ∀ level : ℕ, ℕ → Matrix Index Index (Coefficient level)
  connection_compatible : ∀ (level degree : ℕ),
    letI := coefficientRing level
    letI := coefficientRing (level + 1)
    (connectionCoefficient (level + 1) degree).map
        (reduction level).toRingHom = connectionCoefficient level degree

namespace CompatibleVaryingConnectionSystem

/-- The normalized varying flat-gauge coefficient at a specified coefficient
level and power-series degree. -/
noncomputable def gaugeCoefficient
    {Index : Type*} [Fintype Index] [DecidableEq Index]
    (system : CompatibleVaryingConnectionSystem Index)
    (level degree : ℕ) :
    letI := system.coefficientRing level
    letI := system.coefficientAlgebra level
    Matrix Index Index (system.Coefficient level) := by
  letI := system.coefficientRing level
  letI := system.coefficientAlgebra level
  exact varyingFlatGaugeCoefficient
    (system.connectionCoefficient level) degree

/-- The entrywise one-variable connection series at a specified coefficient
level. -/
noncomputable def connectionSeries
    {Index : Type*} [Fintype Index] [DecidableEq Index]
    (system : CompatibleVaryingConnectionSystem Index) (level : ℕ) :
    letI := system.coefficientRing level
    Matrix Index Index (PowerSeries (system.Coefficient level)) := by
  letI := system.coefficientRing level
  exact varyingConnectionSeries (system.connectionCoefficient level)

/-- The normalized one-variable varying flat-gauge series at a specified
coefficient level. -/
noncomputable def gaugeSeries
    {Index : Type*} [Fintype Index] [DecidableEq Index]
    (system : CompatibleVaryingConnectionSystem Index) (level : ℕ) :
    letI := system.coefficientRing level
    letI := system.coefficientAlgebra level
    Matrix Index Index (PowerSeries (system.Coefficient level)) := by
  letI := system.coefficientRing level
  letI := system.coefficientAlgebra level
  exact varyingFlatGaugeSeries (system.connectionCoefficient level)

/-- Every normalized varying flat-gauge coefficient commutes with adjacent
coefficient reduction. -/
theorem gaugeCoefficient_compatible
    {Index : Type*} [Fintype Index] [DecidableEq Index]
    (system : CompatibleVaryingConnectionSystem Index)
    (level degree : ℕ) :
    letI := system.coefficientRing level
    letI := system.coefficientRing (level + 1)
    letI := system.coefficientAlgebra level
    letI := system.coefficientAlgebra (level + 1)
    (system.gaugeCoefficient (level + 1) degree).map
        (system.reduction level).toRingHom =
      system.gaugeCoefficient level degree := by
  letI := system.coefficientRing level
  letI := system.coefficientRing (level + 1)
  letI := system.coefficientAlgebra level
  letI := system.coefficientAlgebra (level + 1)
  rw [gaugeCoefficient, gaugeCoefficient,
    varyingFlatGaugeCoefficient_map]
  congr 1
  funext coefficientDegree
  exact system.connection_compatible level coefficientDegree

/-- The assembled varying connection series commutes with adjacent coefficient
reduction. -/
theorem connectionSeries_compatible
    {Index : Type*} [Fintype Index] [DecidableEq Index]
    (system : CompatibleVaryingConnectionSystem Index) (level : ℕ) :
    letI := system.coefficientRing level
    letI := system.coefficientRing (level + 1)
    letI := system.coefficientAlgebra level
    letI := system.coefficientAlgebra (level + 1)
    (system.connectionSeries (level + 1)).map
        (PowerSeries.map (system.reduction level).toRingHom) =
      system.connectionSeries level := by
  letI := system.coefficientRing level
  letI := system.coefficientRing (level + 1)
  letI := system.coefficientAlgebra level
  letI := system.coefficientAlgebra (level + 1)
  rw [connectionSeries, connectionSeries,
    varyingConnectionSeries_map]
  congr 1
  funext coefficientDegree
  exact system.connection_compatible level coefficientDegree

/-- The assembled normalized varying flat-gauge series commutes with adjacent
coefficient reduction. -/
theorem gaugeSeries_compatible
    {Index : Type*} [Fintype Index] [DecidableEq Index]
    (system : CompatibleVaryingConnectionSystem Index) (level : ℕ) :
    letI := system.coefficientRing level
    letI := system.coefficientRing (level + 1)
    letI := system.coefficientAlgebra level
    letI := system.coefficientAlgebra (level + 1)
    (system.gaugeSeries (level + 1)).map
        (PowerSeries.map (system.reduction level).toRingHom) =
      system.gaugeSeries level := by
  letI := system.coefficientRing level
  letI := system.coefficientRing (level + 1)
  letI := system.coefficientAlgebra level
  letI := system.coefficientAlgebra (level + 1)
  rw [gaugeSeries, gaugeSeries, varyingFlatGaugeSeries_map]
  congr 1
  funext coefficientDegree
  exact system.connection_compatible level coefficientDegree

/-- At every coefficient level, the normalized series satisfies the exact
one-variable formal equation `dG/dt=-A(t)G(t)`. -/
theorem gaugeSeries_derivative
    {Index : Type*} [Fintype Index] [DecidableEq Index]
    (system : CompatibleVaryingConnectionSystem Index) (level : ℕ) :
    letI := system.coefficientRing level
    letI := system.coefficientAlgebra level
    (system.gaugeSeries level).map PowerSeries.derivativeFun =
      -(system.connectionSeries level) * system.gaugeSeries level := by
  letI := system.coefficientRing level
  letI := system.coefficientAlgebra level
  exact varyingFlatGaugeSeries_derivative
    (system.connectionCoefficient level)

/-- At every coefficient level, the constructed series is the unique
normalized formal matrix solution of the supplied varying connection. -/
theorem gaugeSeries_unique
    {Index : Type*} [Fintype Index] [DecidableEq Index]
    (system : CompatibleVaryingConnectionSystem Index) (level : ℕ)
    (candidate :
      letI := system.coefficientRing level
      Matrix Index Index (PowerSeries (system.Coefficient level)))
    (normalized :
      letI := system.coefficientRing level
      candidate.map (PowerSeries.coeff 0) = 1)
    (flatEquation :
      letI := system.coefficientRing level
      candidate.map PowerSeries.derivativeFun =
        -(system.connectionSeries level) * candidate) :
    letI := system.coefficientRing level
    letI := system.coefficientAlgebra level
    candidate = system.gaugeSeries level := by
  letI := system.coefficientRing level
  letI := system.coefficientAlgebra level
  exact varyingFlatGaugeSeries_unique
    (system.connectionCoefficient level) candidate normalized flatEquation

/-- At every coefficient level, the normalized varying flat-gauge series is
an invertible square matrix over the power-series ring. -/
theorem gaugeSeries_isUnit
    {Index : Type*} [Fintype Index] [DecidableEq Index]
    (system : CompatibleVaryingConnectionSystem Index) (level : ℕ) :
    letI := system.coefficientRing level
    letI := system.coefficientAlgebra level
    IsUnit (system.gaugeSeries level) := by
  letI := system.coefficientRing level
  letI := system.coefficientAlgebra level
  exact varyingFlatGaugeSeries_isUnit
    (system.connectionCoefficient level)

end CompatibleVaryingConnectionSystem

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
