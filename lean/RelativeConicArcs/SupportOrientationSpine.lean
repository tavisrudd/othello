import RelativeConicArcs.SupportOrientationCover
import RelativeConicArcs.SupportOrientationPentagon
import RelativeConicArcs.SupportOrientationHolonomy
import RelativeConicArcs.SupportOrientationDeterminant
import RelativeConicArcs.SupportOrientationTraceDual
import RelativeConicArcs.SupportOrientationNodes
import RelativeConicArcs.SupportOrientationSymmetry
import RelativeConicArcs.SupportOrientationCommutant

/-!
# Orientation proof spine for the Clebsch support cubic

This import-only module collects the eight formal mechanisms behind the
orientation construction: the antipodal homogeneous cover, its signed golden
orbital, switching-invariant triangle holonomy, the determinant pencil, the
cross-golden trace dual, the six ordinary nodes, the recovered `S₅/A₅`
symmetry boundary, and the rational and integral commutants.

The commutant module proves golden equivariance on all sixty action matrices
and proves the reverse containment from the rank-34 rational linear system
imposed by an explicit five-cycle and three-cycle.  Thus the rational and
integral commutant equalities are unconditional kernel-checked theorems.
-/
