import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.CompatibleMonodromySystem

/-!
# Compatible conjugacy by pro-Laurent gauges

This module joins the two finite-level algebraic packets: a compatible
pro-Laurent gauge system and a compatible family of square matrices over the
same Laurent-series coefficient rings.  Conjugation at every level remains
compatible with reduction, and its characteristic polynomial agrees with that
of the original matrix at every level.

The matrix families and gauges are supplied data.  No differential equation,
horizontal solution, single-valued analytic gauge, or framed monodromy operator
is constructed.  All proofs are symbolic and kernel checked, with no external
computation or oracle.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace Quantum

universe u v

/-- Compatible Laurent-series matrices together with the compatible invertible
gauges that conjugate them. -/
structure ProLaurentMonodromyGaugeSystem
    (Index : Type v) [Fintype Index] [DecidableEq Index] where
  gaugeSystem : ProLaurentGaugeSystem.{u, v} Index
  monodromy : ∀ level,
    letI := gaugeSystem.coefficientRing level
    Matrix Index Index (LaurentSeries (gaugeSystem.Coefficient level))
  monodromy_compatible : ∀ level row column,
    letI := gaugeSystem.coefficientRing level
    letI := gaugeSystem.coefficientRing (level + 1)
    gaugeSystem.reduction level (monodromy (level + 1) row column) =
      monodromy level row column

namespace ProLaurentMonodromyGaugeSystem

/-- The supplied gauge and inverse form a matrix unit at every level. -/
noncomputable def gaugeUnit
    {Index : Type*} [Fintype Index] [DecidableEq Index]
    (system : ProLaurentMonodromyGaugeSystem Index) (level : ℕ) :
    letI := system.gaugeSystem.coefficientRing level
    (Matrix Index Index
      (LaurentSeries (system.gaugeSystem.Coefficient level)))ˣ := by
  letI := system.gaugeSystem.coefficientRing level
  exact ⟨system.gaugeSystem.gauge level,
    system.gaugeSystem.inverse level,
    system.gaugeSystem.leftInverse level,
    system.gaugeSystem.rightInverse level⟩

/-- Levelwise conjugation by the supplied Laurent-series gauge. -/
noncomputable def conjugatedMonodromy
    {Index : Type*} [Fintype Index] [DecidableEq Index]
    (system : ProLaurentMonodromyGaugeSystem Index) (level : ℕ) :
    letI := system.gaugeSystem.coefficientRing level
    Matrix Index Index
      (LaurentSeries (system.gaugeSystem.Coefficient level)) := by
  letI := system.gaugeSystem.coefficientRing level
  exact system.gaugeSystem.gauge level * system.monodromy level *
    system.gaugeSystem.inverse level

/-- Reduction maps the higher-level gauge to the preceding gauge matrix. -/
theorem map_gauge
    {Index : Type*} [Fintype Index] [DecidableEq Index]
    (system : ProLaurentMonodromyGaugeSystem Index) (level : ℕ) :
    letI := system.gaugeSystem.coefficientRing level
    letI := system.gaugeSystem.coefficientRing (level + 1)
    (system.gaugeSystem.gauge (level + 1)).map
        (system.gaugeSystem.reduction level) =
      system.gaugeSystem.gauge level := by
  letI := system.gaugeSystem.coefficientRing level
  letI := system.gaugeSystem.coefficientRing (level + 1)
  apply Matrix.ext
  intro row column
  exact system.gaugeSystem.gauge_compatible level row column

/-- Reduction maps the higher-level inverse gauge to the preceding inverse. -/
theorem map_inverse
    {Index : Type*} [Fintype Index] [DecidableEq Index]
    (system : ProLaurentMonodromyGaugeSystem Index) (level : ℕ) :
    letI := system.gaugeSystem.coefficientRing level
    letI := system.gaugeSystem.coefficientRing (level + 1)
    (system.gaugeSystem.inverse (level + 1)).map
        (system.gaugeSystem.reduction level) =
      system.gaugeSystem.inverse level := by
  letI := system.gaugeSystem.coefficientRing level
  letI := system.gaugeSystem.coefficientRing (level + 1)
  apply Matrix.ext
  intro row column
  exact system.gaugeSystem.inverse_compatible level row column

/-- Reduction maps the higher-level monodromy matrix to the preceding matrix. -/
theorem map_monodromy
    {Index : Type*} [Fintype Index] [DecidableEq Index]
    (system : ProLaurentMonodromyGaugeSystem Index) (level : ℕ) :
    letI := system.gaugeSystem.coefficientRing level
    letI := system.gaugeSystem.coefficientRing (level + 1)
    (system.monodromy (level + 1)).map
        (system.gaugeSystem.reduction level) =
      system.monodromy level := by
  letI := system.gaugeSystem.coefficientRing level
  letI := system.gaugeSystem.coefficientRing (level + 1)
  apply Matrix.ext
  intro row column
  exact system.monodromy_compatible level row column

/-- The conjugated matrices remain compatible under coefficient reduction. -/
theorem conjugatedMonodromy_compatible
    {Index : Type*} [Fintype Index] [DecidableEq Index]
    (system : ProLaurentMonodromyGaugeSystem Index) (level : ℕ) :
    letI := system.gaugeSystem.coefficientRing level
    letI := system.gaugeSystem.coefficientRing (level + 1)
    (system.conjugatedMonodromy (level + 1)).map
        (system.gaugeSystem.reduction level) =
      system.conjugatedMonodromy level := by
  letI := system.gaugeSystem.coefficientRing level
  letI := system.gaugeSystem.coefficientRing (level + 1)
  simp only [conjugatedMonodromy, Matrix.map_mul]
  rw [system.map_gauge level, system.map_monodromy level,
    system.map_inverse level]

/-- The characteristic polynomial is invariant under the supplied conjugacy at
every Laurent-series level. -/
theorem conjugatedMonodromy_charpoly
    {Index : Type*} [Fintype Index] [DecidableEq Index]
    (system : ProLaurentMonodromyGaugeSystem Index) (level : ℕ) :
    letI := system.gaugeSystem.coefficientRing level
    (system.conjugatedMonodromy level).charpoly =
      (system.monodromy level).charpoly := by
  letI := system.gaugeSystem.coefficientRing level
  rw [conjugatedMonodromy]
  calc
    (system.gaugeSystem.gauge level * system.monodromy level *
        system.gaugeSystem.inverse level).charpoly =
      (system.gaugeSystem.inverse level *
        (system.gaugeSystem.gauge level * system.monodromy level)).charpoly :=
      Matrix.charpoly_mul_comm _ _
    _ = (system.monodromy level).charpoly := by
      rw [← Matrix.mul_assoc, system.gaugeSystem.rightInverse level,
        one_mul]

end ProLaurentMonodromyGaugeSystem

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
