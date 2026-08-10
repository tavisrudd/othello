import RelativeConicArcs.Gates.ClebschRigidityTrust
import TavisRuddFiniteGeom.Certificates.Q11.Verification.AxiomAudit
import TavisRuddFiniteGeom.Papers.ClebschRigidity.CertificateCompatibility

/-!
# Axiom audit for the Clebsch rigidity compatibility boundary

This module combines the finite-geometry rigidity audit, the frozen order-eleven
certificate audit, and the two equalities identifying their coordinate models.
The certificate remains Mathlib-only; this downstream module is the first common
import. The printed output records the axioms of the compatibility statements.
-/

#print axioms TavisRuddFiniteGeom.Papers.ClebschRigidity.CertificateCompatibility.witnessVec_eq_human
#print axioms TavisRuddFiniteGeom.Papers.ClebschRigidity.CertificateCompatibility.projectiveVec_eq_human
#print axioms TavisRuddFiniteGeom.Papers.ClebschRigidity.CertificateCompatibility.twoGenerator_pointOrbit_partition
