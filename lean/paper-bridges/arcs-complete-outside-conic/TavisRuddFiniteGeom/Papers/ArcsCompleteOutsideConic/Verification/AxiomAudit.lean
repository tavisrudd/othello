import RelativeConicArcs.Gates.ArcsCompleteOutsideConic
import TavisRuddFiniteGeom.Certificates.Q16.Verification.AxiomAudit
import TavisRuddFiniteGeom.Papers.ArcsCompleteOutsideConic.CertificateCompatibility

/-!
# Axiom audit for the order-sixteen arc compatibility boundary

This module combines the finite-geometry classification audit, the frozen
order-sixteen certificate audit, and the theorems identifying their field and
projective-point models. The certificate remains Mathlib-only; this downstream
module is the first common import. The printed output records the axioms of the
compatibility statements.
-/

#print axioms TavisRuddFiniteGeom.Papers.ArcsCompleteOutsideConic.CertificateCompatibility.certificateFieldEquiv
#print axioms TavisRuddFiniteGeom.Papers.ArcsCompleteOutsideConic.CertificateCompatibility.canonicalVec_eq_human
#print axioms TavisRuddFiniteGeom.Papers.ArcsCompleteOutsideConic.CertificateCompatibility.exhaustive_local_certificate
