import ProjectiveCap.BaerQuadraticStabilizerAssumption

/-!
# Conditional parabolic Baer obstruction

Consequences of the quarantined quadratic-stabilizer assumption.  The local descent from a
semisimilitude equation to a fixed quadric point remains kernel-checked; only the production of the
semisimilitude multiplier is assumed.
-/

namespace ProjectiveCap
namespace Projective
namespace BaerSemilinear

variable (F K : Type*) [Field F] [Fintype F] [Field K] [Fintype K] [Algebra F K]

/-- Under the imported stabilizer theorem, coordinate Frobenius preserving a nondegenerate
quadratic zero locus fixes a point on that quadric in dimension at least three. -/
theorem hasFixedPointOn_quadric_of_coordinate_preserves_zeroLocus {n : ℕ}
    (hfinrank : Module.finrank F K = 2) (hchar : ringChar F ≠ 2) (hdim : 3 ≤ n)
    (Q : QuadraticForm K (Fin n → K)) (hQ : Q.Nondegenerate) (hQne : Q ≠ 0)
    (hzero : ∀ v, Q (coordinateFrobenius F K n v) = 0 ↔ Q v = 0) :
    HasFixedPointOn (OnQuadraticForm Q) (projectiveCoordinateFrobenius F K n hfinrank) := by
  have hcharK : ringChar K ≠ 2 := by
    rwa [← Algebra.ringChar_eq F K]
  obtain ⟨μ, _, hsemi⟩ :=
    exists_semisimilitudeMultiplier_of_preserves_zeroLocus F K
      hcharK (by simpa using hdim) Q hQ
      (coordinateFrobenius F K n) (coordinateFrobenius_injective F K n) hzero
  exact hasFixedPointOn_quadric_of_coordinate_semisimilitude F K hfinrank hchar hdim
    Q hQne μ hsemi

/-- A conditional closure of the coordinate parabolic Baer branch from zero-locus preservation. -/
theorem parabolic_coordinate_zeroLocus_route_not_fixedPointFree {m : ℕ} (hm : 1 ≤ m)
    (hfinrank : Module.finrank F K = 2) (hchar : ringChar F ≠ 2)
    (Q : QuadraticForm K (Fin (2 * m + 1) → K))
    (hQ : Q.Nondegenerate) (hQne : Q ≠ 0)
    (hzero : ∀ v,
      Q (coordinateFrobenius F K (2 * m + 1) v) = 0 ↔ Q v = 0) :
    ¬ FixedPointFreeOn (OnQuadraticForm Q)
        (projectiveCoordinateFrobenius F K (2 * m + 1) hfinrank) := by
  apply not_fixedPointFreeOn_of_hasFixedPointOn
  exact hasFixedPointOn_quadric_of_coordinate_preserves_zeroLocus F K hfinrank hchar
    (by omega) Q hQ hQne hzero

end BaerSemilinear
end Projective
end ProjectiveCap
