import RelativeConicArcs.PaperIOrientationCover
import RelativeConicArcs.PaperIOrientationPentagon
import RelativeConicArcs.PaperIOrientationHolonomy
import RelativeConicArcs.PaperIOrientationDeterminant
import RelativeConicArcs.PaperIOrientationTraceDual
import RelativeConicArcs.PaperIOrientationNodes
import RelativeConicArcs.PaperIOrientationSymmetry
import RelativeConicArcs.PaperIOrientationCommutant

/-!
# Orientation proof spine for the Clebsch support cubic

This import-only module collects the eight formal mechanisms behind the
orientation construction: the antipodal homogeneous cover, its signed golden
orbital, switching-invariant triangle holonomy, the determinant pencil, the
cross-golden trace dual, the six ordinary nodes, the recovered `S₅/A₅`
symmetry boundary, and the rational and integral commutants.

The commutant terminals are conditional on
`PaperIOrientationCommutant.ClassicalOddA5ThreePlusThreeSplitting`.  That
interface states the classical conjugate `3+3'` decomposition, Schur-lemma,
and Galois-descent input explicitly.  Golden equivariance and the
diagonal/off-diagonal integral descent are kernel checked in the imported
commutant module.
-/
