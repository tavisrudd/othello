import RelativeConicArcs.PRSRedundancyFive
import RelativeConicArcs.PRSRedundancyFiveCertificate

/-!
# Certified redundancy-five projective Reed--Solomon synthesis

This module joins two independently elaborated leaves: the characteristic-free
Hankel and family synthesis in `RelativeConicArcs.PRSRedundancyFive`, and the
exact finite sporadic records and semantic checker interface in
`RelativeConicArcs.PRSRedundancyFiveCertificate`.

The wrapper fixes the generic certificate-evidence type to
`RelativeConicArcs.PRSRedundancyFiveCertificate.CertificateValidation`.
Consequently, a finite-bridge classification cannot reach this paper-facing
terminal by supplying an unrelated evidence type.
-/

namespace RelativeConicArcs.PRSRedundancyFiveCertified

open PRSRedundancyFive
open PRSRedundancyFiveCertificate

/-- The algebraic synthesis and public certificate use the same exact finite
bridge field band. -/
theorem finiteBridgeFieldOrders_agree :
    PRSRedundancyFive.finiteBridgeFieldOrders =
      PRSRedundancyFiveCertificate.finiteBridgeFieldOrders := by
  rfl

/-- Redundancy-five synthesis with the exact public-certificate validation
interface as its finite evidence type. -/
theorem redundancyFiveSynthesisWithCertificate
    {K : Type*} {q : ℕ} [Field K] [Fintype K] [DecidableEq K]
    (input : ExceptionalCoverClassificationInput K CertificateValidation q)
    (orbits : OrbitData input.orbitCase)
    (hSeroussiRoth : input.seroussiRothCompleteness)
    (hHighField : q ≥ 23 →
      input.aubryPerretPointBound ∧ input.cubicCoverStrataClassified) :
    (∀ s, input.coveringRadius.isDeep s ↔ s ∈ input.families.deep) ∧
      2 * input.families.deep.card =
        nonsporadicDeepCardDoubled input.families.cyclicCase q +
          2 * input.families.sporadic.card ∧
      (orbits.projectiveOrbitCount, orbits.semilinearOrbitCount) =
        (nonsporadicOrbitCount input.orbitCase +
            orbits.sporadicProjectiveOrbitCount,
         nonsporadicOrbitCount input.orbitCase +
            orbits.sporadicSemilinearOrbitCount) :=
  redundancyFiveSynthesis input orbits hSeroussiRoth hHighField

end RelativeConicArcs.PRSRedundancyFiveCertified
