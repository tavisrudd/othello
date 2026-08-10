import RelativeConicArcs.Q16Classification
import TavisRuddFiniteGeom.Certificates.Q16.Certificate

/-!
# Compatibility of the order-sixteen certificate with the projective model

The certificate and the human geometric development use separate four-bit
implementations of the field with sixteen elements.  This module identifies
their polynomial-basis codes and canonical representatives of `PG(2,16)`.
The certificate package remains independent of the geometric library.
-/

namespace TavisRuddFiniteGeom.Papers.ArcsCompleteOutsideConic.CertificateCompatibility

/-- The certificate field and the human coordinate field have identical four-bit arithmetic. -/
def fieldEquiv :
    TavisRuddFiniteGeom.Certificates.Q16.GF16 ≃+*
      RelativeConicArcs.FiniteFields.GF16 where
  toFun a := ⟨a.val⟩
  invFun a := ⟨a.val⟩
  left_inv a := by cases a; rfl
  right_inv a := by cases a; rfl
  map_add' a b := by cases a; cases b; rfl
  map_mul' a b := by cases a; cases b; rfl

/-- The field equivalence carries each certificate point code to the human canonical vector. -/
theorem vec_eq_human (i : Fin 273) :
    (fun j => fieldEquiv (TavisRuddFiniteGeom.Certificates.Q16.vec i j)) =
      RelativeConicArcs.Q16Classification.vec i := by
  funext j
  unfold TavisRuddFiniteGeom.Certificates.Q16.vec
    RelativeConicArcs.Q16Classification.vec
  split_ifs <;> fin_cases j <;> rfl

/-- The exhaustive local classification certificate, exposed at the paper boundary. -/
alias exhaustive_local_certificate :=
  TavisRuddFiniteGeom.Certificates.Q16.exhaustive_local_certificate

end TavisRuddFiniteGeom.Papers.ArcsCompleteOutsideConic.CertificateCompatibility
