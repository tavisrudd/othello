import RelativeConicArcs.PRSRedundancyFive
import RelativeConicArcs.PRSRedundancyFiveCertificate

/-!
# Certified redundancy-five projective Reed--Solomon synthesis

The characteristic-free Hankel and family synthesis is specialized to the public finite
certificate's semantic evidence interface.  The algebra is in
`RelativeConicArcs.PRSRedundancyFive`; the candidate finite rows and validation predicates are in
`RelativeConicArcs.PRSRedundancyFiveCertificate`.

The wrapper fixes the generic certificate-evidence type to
`RelativeConicArcs.PRSRedundancyFiveCertificate.CertificateValidation`.
Consequently, a finite-bridge classification cannot reach this paper-facing theorem by supplying
an unrelated evidence type.
-/

namespace RelativeConicArcs.PRSRedundancyFiveCertified

open PRSRedundancyFive
open PRSRedundancyFiveCertificate

/-- Every field order whose classification depends on the finite bridge is inside the
public certificate's own sub-threshold domain. -/
theorem requiredBridgeFieldOrders_subset_certifiedBridgeFieldOrders :
    ∀ q ∈ PRSRedundancyFive.requiredBridgeFieldOrders,
      q ∈ PRSRedundancyFiveCertificate.certifiedBridgeFieldOrders := by
  decide

/-- The certificate's sub-threshold domain exceeds the required bridge in exactly one
field order, the binary field of order sixteen, which
`PRSRedundancyFive.splitMembers_pos_of_characteristicTwoBranchBudget` closes
geometrically.  Its certificate row is therefore an independent check of a field the
classification does not need it for. -/
theorem certifiedBridgeFieldOrders_exceed_required_only_at_sixteen :
    ∀ q ∈ PRSRedundancyFiveCertificate.certifiedBridgeFieldOrders,
      q ∈ PRSRedundancyFive.requiredBridgeFieldOrders ∨ q = 16 := by
  decide

/-- Redundancy-five synthesis with the exact public-certificate validation
interface as its finite evidence type. -/
theorem redundancyFiveSynthesisWithCertificate
    {K : Type*} {q : ℕ} [Field K] [Fintype K] [DecidableEq K]
    (input : ExceptionalCoverClassificationInput K CertificateValidation q)
    (orbits : OrbitData input.orbitCase)
    (hSeroussiRoth : input.seroussiRothCompleteness)
    (hGeometricRange :
      GeometricClassificationRange input.families.characteristic q →
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
  redundancyFiveSynthesis input orbits hSeroussiRoth hGeometricRange

end RelativeConicArcs.PRSRedundancyFiveCertified
