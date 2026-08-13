import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.ConstantFlatGauge

/-!
# Compatible constant-coefficient formal flat gauges

Fix a finite matrix index.  At every natural-number level, let the coefficient
ring be a commutative `ℚ`-algebra, let adjacent levels be related by a
`ℚ`-algebra homomorphism, and supply a constant connection matrix compatible
with those reductions.  Lean proves that every normalized exponential
coefficient and the assembled entrywise formal power-series matrix are
compatible under reduction.  At every level the series still satisfies the
constant-coefficient equation `dG/dt = -AG`; the series for the negated
connection gives a compatible two-sided inverse.

The coefficient rings, reductions, and compatible connection matrices are
supplied abstractly.  No ideal filtration, quantum product, varying or
multivariable connection, Laurent loop coordinate, convergence,
or analytic gauge is represented.  The proofs are symbolic and kernel checked,
with no external computation or oracle.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Quantum

universe u v

/-- A natural-number-indexed system of constant connection matrices over
commutative rational algebras, compatible under adjacent coefficient
reductions. -/
structure CompatibleConstantConnectionSystem
    (Index : Type v) [Fintype Index] [DecidableEq Index] where
  Coefficient : ℕ → Type u
  coefficientRing : ∀ level, CommRing (Coefficient level)
  coefficientAlgebra : ∀ level, Algebra ℚ (Coefficient level)
  reduction : ∀ level, Coefficient (level + 1) →ₐ[ℚ] Coefficient level
  connection : ∀ level, Matrix Index Index (Coefficient level)
  connection_compatible : ∀ level,
    letI := coefficientRing level
    letI := coefficientRing (level + 1)
    (connection (level + 1)).map (reduction level).toRingHom = connection level

namespace CompatibleConstantConnectionSystem

/-- The normalized constant-flat-gauge coefficient at a specified level. -/
noncomputable def gaugeCoefficient
    {Index : Type*} [Fintype Index] [DecidableEq Index]
    (system : CompatibleConstantConnectionSystem Index)
    (level degree : ℕ) :
    letI := system.coefficientRing level
    letI := system.coefficientAlgebra level
    Matrix Index Index (system.Coefficient level) := by
  letI := system.coefficientRing level
  letI := system.coefficientAlgebra level
  exact constantFlatGaugeCoefficient (system.connection level) degree

/-- The entrywise formal flat-gauge series at a specified level. -/
noncomputable def gaugeSeries
    {Index : Type*} [Fintype Index] [DecidableEq Index]
    (system : CompatibleConstantConnectionSystem Index) (level : ℕ) :
    letI := system.coefficientRing level
    letI := system.coefficientAlgebra level
    Matrix Index Index (PowerSeries (system.Coefficient level)) := by
  letI := system.coefficientRing level
  letI := system.coefficientAlgebra level
  exact constantFlatGaugeSeries (system.connection level)

/-- The inverse formal series at one level, constructed from the negated
constant connection matrix. -/
noncomputable def inverseSeries
    {Index : Type*} [Fintype Index] [DecidableEq Index]
    (system : CompatibleConstantConnectionSystem Index) (level : ℕ) :
    letI := system.coefficientRing level
    letI := system.coefficientAlgebra level
    Matrix Index Index (PowerSeries (system.Coefficient level)) := by
  letI := system.coefficientRing level
  letI := system.coefficientAlgebra level
  exact constantFlatGaugeSeries (-(system.connection level))

/-- Every normalized coefficient is compatible with adjacent coefficient
reduction. -/
theorem gaugeCoefficient_compatible
    {Index : Type*} [Fintype Index] [DecidableEq Index]
    (system : CompatibleConstantConnectionSystem Index)
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
    constantFlatGaugeCoefficient_map]
  rw [system.connection_compatible level]

/-- The assembled formal gauge series is compatible with adjacent coefficient
reduction, entry by entry and coefficient by coefficient. -/
theorem gaugeSeries_compatible
    {Index : Type*} [Fintype Index] [DecidableEq Index]
    (system : CompatibleConstantConnectionSystem Index) (level : ℕ) :
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
  ext row column degree
  simpa [gaugeSeries, gaugeCoefficient, constantFlatGaugeSeries] using
    congrArg (fun matrix ↦ matrix row column)
      (system.gaugeCoefficient_compatible level degree)

/-- The inverse series constructed from the negated connection is compatible
with adjacent coefficient reduction. -/
theorem inverseSeries_compatible
    {Index : Type*} [Fintype Index] [DecidableEq Index]
    (system : CompatibleConstantConnectionSystem Index) (level : ℕ) :
    letI := system.coefficientRing level
    letI := system.coefficientRing (level + 1)
    letI := system.coefficientAlgebra level
    letI := system.coefficientAlgebra (level + 1)
    (system.inverseSeries (level + 1)).map
        (PowerSeries.map (system.reduction level).toRingHom) =
      system.inverseSeries level := by
  letI := system.coefficientRing level
  letI := system.coefficientRing (level + 1)
  letI := system.coefficientAlgebra level
  letI := system.coefficientAlgebra (level + 1)
  ext row column degree
  simp only [inverseSeries, constantFlatGaugeSeries,
    Matrix.map_apply, PowerSeries.coeff_map, PowerSeries.coeff_mk]
  have mapped := constantFlatGaugeCoefficient_map
    (system.reduction level) (-(system.connection (level + 1))) degree
  rw [Matrix.map_neg _ (fun value ↦ map_neg _ value),
    system.connection_compatible level] at mapped
  exact congrArg (fun matrix ↦ matrix row column) mapped

/-- At each coefficient level, the assembled series satisfies the exact
constant-coefficient formal differential equation. -/
theorem gaugeSeries_derivative
    {Index : Type*} [Fintype Index] [DecidableEq Index]
    (system : CompatibleConstantConnectionSystem Index) (level : ℕ) :
    letI := system.coefficientRing level
    letI := system.coefficientAlgebra level
    (system.gaugeSeries level).map PowerSeries.derivativeFun =
      (system.connection level).map (fun value ↦ PowerSeries.C (-value)) *
        system.gaugeSeries level := by
  letI := system.coefficientRing level
  letI := system.coefficientAlgebra level
  exact constantFlatGaugeSeries_derivative (system.connection level)

/-- At every level, the negated-connection series is a two-sided inverse of
the normalized flat-gauge series. -/
theorem gaugeSeries_inverse
    {Index : Type*} [Fintype Index] [DecidableEq Index]
    (system : CompatibleConstantConnectionSystem Index) (level : ℕ) :
    letI := system.coefficientRing level
    letI := system.coefficientAlgebra level
    system.gaugeSeries level * system.inverseSeries level = 1 ∧
      system.inverseSeries level * system.gaugeSeries level = 1 := by
  letI := system.coefficientRing level
  letI := system.coefficientAlgebra level
  exact ⟨constantFlatGaugeSeries_mul_neg_eq_one (system.connection level),
    constantFlatGaugeSeries_neg_mul_eq_one (system.connection level)⟩

end CompatibleConstantConnectionSystem

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
