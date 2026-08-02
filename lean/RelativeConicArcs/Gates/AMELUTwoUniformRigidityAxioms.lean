import RelativeConicArcs.Gates.AMELUTwoUniformRigidity

/-!
# Axiom audit for the two-uniform rigidity package

This audit prints the dependencies of the polarized second-moment isometry and
its injectivity, the single-exponential identity for product operators, the
traceless/scalar splitting of Hermitian local generators, the vanishing of the
traceless generators of a continuous product-unitary ray symmetry, the
invariance of the defect under exact ray symmetries, and the terminal of the
conditional decomposition interface.
-/

open RelativeConicArcs.AMELU.Multipartite

#print axioms stateInner_localGeneratorSum_mulVec
#print axioms stateInner_self_localGeneratorSum_mulVec
#print axioms eq_zero_of_stateInner_self_eq_zero
#print axioms eq_zero_of_localGeneratorSum_mulVec_eq_zero
#print axioms tensorOperator_mul
#print axioms tensorOperator_eq_noncommProd
#print axioms exp_siteOperator
#print axioms tensorOperator_exp
#print axioms localGeneratorSum_eq_traceless_add_scalar
#print axioms tensorOperator_exp_eq_exp_traceless_add_scalar
#print axioms localGenerator_eq_zero_of_ray_invariant
#print axioms localGeneratorSum_eq_zero_of_ray_invariant
#print axioms tracelessPart_eq_zero_of_productUnitary_ray_invariant
#print axioms raySymmetry_eigenvalue
#print axioms defectSq_symmetry_mul
#print axioms defectSq_mul_symmetry
#print axioms approximate_decomposition
