import RelativeConicArcs.QuadraticGlobalCount
import RelativeConicArcs.Q25AllProfiles
import RelativeConicArcs.Q25AlternateOrbitRepair

/-!
# Q25 validation gate for the `alt-orbit-repair` lane

This is the compatible Q25 portion of the paper-facing target set.  The profile-envelope and
parameterized terminals have separate gates because importing those independently compiled modules
into the same Lean environment currently collides on synthesized instance names.
-/
