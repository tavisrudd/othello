import RelativeConicArcs.Gates.PRSFoundation
import RelativeConicArcs.Gates.PRSRedundancyFive
import RelativeConicArcs.Gates.PRSPolarInductionRedundancySixSeven
import RelativeConicArcs.Gates.PRSStableComponents
import RelativeConicArcs.PRSUniformCoveringRadius

/-!
# Aggregate import gate for projective Reed--Solomon results beyond redundancy four

This gate is the paper-facing import closure for the formal results adopted by the
redundancy-five through redundancy-seven manuscript.  It imports the shared Hankel and coding
interfaces, redundancy-five algebra and finite-table arithmetic, coherent polar contraction,
the recursive contained-component and redundancy-six/seven synthesis interfaces, the
stable-component coordinate algebra, and the uniform iteration-budget and covering-radius
threshold bridges.

The imported synthesis theorems are conditional.  Concrete projective-coordinate dictionaries,
the Seroussi--Roth nonextendability theorem, Dür's completeness--radius equivalence, geometric
component classifications, rational-point bounds, genuine
projective and semilinear group actions, and semantic validation of externally generated finite
records remain explicit hypotheses or structure fields.  The closure imports no project-local
axiom, generated evaluator, native decision procedure, or external oracle.
-/
