import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.CompletedNovikovInverseLimit
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.NumericalNovikovCompletion

/-!
# Numerical pushforward on compatible truncation systems

For a surjective degree-compatible quotient of finite-degree effective monoids,
completed numerical pushforward induces a map between the coefficientwise
compatible truncation models.  At every cutoff its finite level is exactly
`AddMonoidAlgebra.mapDomain` applied to the corresponding source level.  Thus
the completed map and all finite quotient maps form an exact commuting square.

This is a coefficientwise map of explicit compatible families.  It is not a
categorical inverse-limit cone, a continuity theorem in a topology, or a
construction of the quantum comparison map.  All proofs are symbolic and
kernel checked, with no external computation or oracle.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace Quantum

variable {Homology Numerical R : Type*}
  [AddCommMonoid Homology] [AddCommMonoid Numerical]

namespace CompletedNumericalQuotient

/-- Numerical pushforward transported to the compatible finite-truncation
model through the completed-family equivalences. -/
noncomputable def pushforwardTruncationFamily
    (data : CompletedNumericalQuotient Homology Numerical) [CommRing R]
    (family : FiniteDegreeAddCommMonoid.DegreeTruncationFamily
      data.homologicalGrading R) :
    FiniteDegreeAddCommMonoid.DegreeTruncationFamily
      data.numericalGrading R :=
  FiniteDegreeAddCommMonoid.DegreeTruncationFamily.ofCompleted
    data.numericalGrading <|
      data.completedPushforward family.toCompleted

/-- Every finite level of truncation-family pushforward is the ordinary
additive-monoid-algebra map induced by the numerical quotient. -/
theorem pushforwardTruncationFamily_level
    (data : CompletedNumericalQuotient Homology Numerical) [CommRing R]
    (family : FiniteDegreeAddCommMonoid.DegreeTruncationFamily
      data.homologicalGrading R) (cutoff : ℕ) :
    (data.pushforwardTruncationFamily family).level cutoff =
      AddMonoidAlgebra.mapDomain data.quotient (family.level cutoff) := by
  change data.numericalGrading.truncation
      (data.completedPushforward family.toCompleted) cutoff = _
  rw [data.truncation_completedPushforward]
  congr 1
  have round_trip :=
    FiniteDegreeAddCommMonoid.DegreeTruncationFamily.ofCompleted_toCompleted
      data.homologicalGrading family
  exact congrArg (fun truncations ↦ truncations.level cutoff) round_trip

/-- Passing a completed series to finite levels before or after numerical
pushforward gives the same compatible family. -/
theorem pushforwardTruncationFamily_ofCompleted
    (data : CompletedNumericalQuotient Homology Numerical) [CommRing R]
    (series : FiniteDegreeAddCommMonoid.CompletedNovikovRing
      data.homologicalGrading R) :
    data.pushforwardTruncationFamily
        (FiniteDegreeAddCommMonoid.DegreeTruncationFamily.ofCompleted
          data.homologicalGrading series) =
      FiniteDegreeAddCommMonoid.DegreeTruncationFamily.ofCompleted
        data.numericalGrading (data.completedPushforward series) := by
  rw [pushforwardTruncationFamily,
    FiniteDegreeAddCommMonoid.DegreeTruncationFamily.toCompleted_ofCompleted]

end CompletedNumericalQuotient

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
