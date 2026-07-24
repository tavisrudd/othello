import RelativeConicArcs.PRSFoundation
import RelativeConicArcs.PRSRedundancyNine

/-!
# Import gate for projective Reed--Solomon syndrome foundations

This gate exports the common Hankel-kernel, covering-radius, geometric-witness,
persistent-family, and orbit-exhaustion interfaces.  It also imports the redundancy-nine
residual-quadratic synthesis module, confirming that the common layer reuses the established
divided-power contraction API and coexists with its degree-specific interface.

The exported structures contain all geometric component, rational-point, covering-radius, and
orbit-exhaustion assumptions as fields.  No finite certificate, generated data, or external
oracle is imported.
-/
