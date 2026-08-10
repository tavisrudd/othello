import RelativeConicArcs.Q11Coding
import TavisRuddFiniteGeom.Certificates.Q11.PointOrbits

/-!
# Compatibility of the order-eleven certificate with the Clebsch coordinates

The certificate and the human coding development use separate definitions of
the same six witness vectors and the same enumeration of the 133 normalized
points of `PG(2,11)`.  The equalities below connect those definitions while
keeping the certificate package independent of the human library.
-/

namespace TavisRuddFiniteGeom.Papers.ClebschRigidity.CertificateCompatibility

/-- The certificate and human models use the same six displayed witness vectors. -/
theorem witnessVec_eq_human :
    TavisRuddFiniteGeom.Certificates.Q11.Model.witnessVec =
      RelativeConicArcs.Examples.Q11Coding.witnessVec := by
  funext i
  fin_cases i <;> rfl

/-- The certificate and human models enumerate the normalized projective points identically. -/
theorem projectiveVec_eq_human :
    TavisRuddFiniteGeom.Certificates.Q11.Model.projectiveVec =
      RelativeConicArcs.Examples.Q11Coding.projectiveVec := by
  rfl

/-- The frozen two-generator orbit certificate, exposed at the paper boundary. -/
alias twoGenerator_pointOrbit_partition :=
  TavisRuddFiniteGeom.Certificates.Q11.PointOrbits.twoGenerator_pointOrbit_partition

end TavisRuddFiniteGeom.Papers.ClebschRigidity.CertificateCompatibility
