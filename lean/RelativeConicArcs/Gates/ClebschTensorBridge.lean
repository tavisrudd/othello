import RelativeConicArcs.ClebschTensorBridge

/-!
# Import-only gate for the finite-field Clebsch tensor

This gate exposes the explicit twenty-coordinate cubic tensor, its ten-by-four contraction matrix,
and the exhaustive native-decision theorem identifying the resulting 64-entry tensor with four
times the Clebsch polarization over `ZMod 11`.  The imported module treats the tensor and matrix as
certificate data; matching-orbit provenance and equivariance are not in this import closure.
-/

#print axioms RelativeConicArcs.ClebschTensorBridge.restrictedCubic_eq_four_mul_clebschPolarization
#print axioms RelativeConicArcs.ClebschTensorBridge.restrictedCubic_nonzero
#print axioms RelativeConicArcs.ClebschTensorBridge.gauntDenominator_divisibleBy_eleven
