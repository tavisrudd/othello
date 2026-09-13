import WeightedRules.AxiomAudit
import WeightedRules.ConvergenceAxiomAudit
import WeightedRules.IncrementalAxiomAudit
import WeightedRules.LoweringSquareAxiomAudit
import WeightedRules.OracleAxiomAudit
import WeightedRules.OutputConvergenceAxiomAudit
import WeightedRules.FiniteLoweringChecks

/-!
# Finite weighted rules: library root

Importing this module elaborates every terminal of the library: the polynomial
rule contract and its bounded min-plus instance, scalar-round and rule-output
convergence with their sharpness witnesses, reflective certificate checking,
incremental replay, source lowering squares, finite event lowering, readout
minimality, and the external witness examples. Each imported audit module
asserts the exact logical axioms of its terminals through `#guard_msgs`, so a
build of this module fails if any terminal acquires `sorryAx`, a native
evaluation axiom, or any other unexpected dependency.
-/
