import RelativeConicArcs.EvaluationDichotomy
import RelativeConicArcs.Results
import RelativeConicArcs.Q9Terminal
import RelativeConicArcs.Q11Residual
import RelativeConicArcs.Q11Coding

/-!
# Validation gate for the `relconic` lane

This import-only module is the transitive kernel-checking boundary for the relative-conic paper and
its game/code consumers.  It deliberately excludes the Q25 certificate and repair subtrees, which
belong to other lanes.
-/
