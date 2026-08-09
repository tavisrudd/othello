import RelativeConicArcs.Q11CertificateModel
import RelativeConicArcs.Q11SemanticBase

/-!
# Compatibility of the frozen order-eleven certificate model

The certificate package can state and prove its results using the self-contained
coordinate model.  This downstream adapter identifies that model with the human
coding interface and transports certificate theorems without making the certificate
depend on the human library.
-/

namespace RelativeConicArcs.Q11CertificateCompatibility

/-- The frozen certificate witness table equals the human coding witness table. -/
theorem witnessVec_eq_human :
    Q11CertificateModel.witnessVec = Examples.Q11Coding.witnessVec := by
  funext i
  fin_cases i <;> rfl

/-- The frozen canonical point enumeration equals the human coding enumeration. -/
theorem projectiveVec_eq_human :
    Q11CertificateModel.projectiveVec = Examples.Q11Coding.projectiveVec := by
  rfl

/-- A certificate theorem transports to the human witness table through the proved
coordinate compatibility, with no upstream import from the certificate model. -/
theorem pointVec_witnessIndex_human (i : Fin 6) :
    Q11CertificateModel.pointVec (Q11CertificateModel.witnessIndex i) =
      Examples.Q11Coding.witnessVec i := by
  rw [← witnessVec_eq_human]
  exact Q11CertificateModel.pointVec_witnessIndex i

end RelativeConicArcs.Q11CertificateCompatibility
