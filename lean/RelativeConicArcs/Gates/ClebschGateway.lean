import RelativeConicArcs.ClebschGatewayQ11Extension
import RelativeConicArcs.ClebschGatewayQ11Conic
import RelativeConicArcs.ClebschGatewayQ11Matching
import RelativeConicArcs.ClebschGatewayQ11Fusion
import RelativeConicArcs.ClebschGatewayCoxeterPhase
import RelativeConicArcs.ClebschGatewayA5FourierPhase

/-!
# Import-only gate for the Clebsch gateway modules

This gate imports the generic arc/code interfaces, the coordinate-level q=11 extension and conic
termination theorems, and the displayed matching and fusion data.  The q=11 coordinate theorems are
kernel-connected to their finite predicates.  The matching and fusion modules check literal tables
but do not prove their geometric parent, group-action, relation-orbit, or Fourier semantics.

Importing this gate therefore establishes elaboration of a mixed-trust API; it is not by itself a
claim-level trust manifest.  Cubic-surface, tensor-extension, geometric fibre-completeness, and
general biplane statements are outside the import closure.
-/
