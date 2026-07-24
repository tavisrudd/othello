import RelativeConicArcs.Gates.PRSFoundation
import RelativeConicArcs.Gates.PRSRedundancyFive
import RelativeConicArcs.Gates.PRSPolarInductionRedundancySixSeven
import RelativeConicArcs.Gates.PRSRedundancyEight
import RelativeConicArcs.Gates.PRSRedundancyNine
import RelativeConicArcs.Gates.PRSCharacteristicTwoHessianLucas

/-!
# Aggregate import gate for projective Reed--Solomon results beyond redundancy four

This gate is the paper-facing import closure for the formal results on redundancies five through
nine and the characteristic-two ordered-Hessian and Lucas-carrier boundary.  It imports the
shared Hankel and coding interfaces, the redundancy-five algebra and finite-table arithmetic,
coherent polar contraction and the redundancy-six/seven synthesis interfaces, the
redundancy-eight specialization, the redundancy-nine residual-quadratic package, and the
characteristic-two modular package.

The imported synthesis theorems are conditional.  Concrete projective-coordinate dictionaries,
covering-radius results, geometric component classifications, rational-point bounds, genuine
projective and semilinear group actions, and semantic validation of externally generated finite
records remain explicit hypotheses or structure fields.  The closure imports no project-local
axiom, generated evaluator, native decision procedure, or external oracle.
-/
