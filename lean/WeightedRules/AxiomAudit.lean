import WeightedRules.BoundedMinPlus

/-!
# Axiom audit for finite weighted rule certificates

The imported declarations cover polynomial monotonicity, leastness of finite
convergence certificates, source-lowering commutation, symmetry invariance,
bounded min-plus laws and a 21-coordinate cyclic distance example. The print
commands expose their transitive logical axioms. Concrete certificate checks
use kernel reduction rather than native evaluation or an external oracle.
-/

#print axioms WeightedRules.step_mono
#print axioms WeightedRules.certificate_least
#print axioms WeightedRules.certificates_agree
#print axioms WeightedRules.lowering_iterate
#print axioms WeightedRules.symmetry_iterate
#print axioms WeightedRules.boundedMinPlus
#print axioms WeightedRules.boundedMinPlus_zero_stable
#print axioms WeightedRules.boundedMinus
#print axioms WeightedRules.distanceCertificate
#print axioms WeightedRules.distance_least
#print axioms WeightedRules.distance_values
