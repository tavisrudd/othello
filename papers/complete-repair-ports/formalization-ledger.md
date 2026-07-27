# Formalization ledger

This ledger maps stable paper statements to their exact Lean coverage.  A list
of related declarations is not by itself an adequacy verdict.

| Paper label | Existing Lean coverage | Present boundary | Missing terminal or bridge | Owner |
|---|---|---|---|---|
| `def:complete-port` | Existing support declarations plus `RepairPorts.coefficientPort`, `coefficientPortSpan`, `mem_repairHypergraph_iff_exists_mem_coefficientPort`, and `reconstructedCode_eq` | Support/coefficient layers and their code-recovery meaning are exact | Probability layer remains separate under C675 | C672, C675 |
| `def:reconstruction-radius` | `RepairPorts.ReconstructsAt`, `reconstructionRadius`, `PointedCoefficientPortIso.reconstructsAt_iff`, and `.reconstructionRadius_eq` | Exact intrinsic coefficient-port interface | None | C672 |
| `thm:mds-reconstruction` | `HasMDSDualParameters.exists_normalized_word`, `.repairHypergraph_eq_powersetCard`, `.reconstructsAt`, `.reconstructsAt_iff`, `.reconstructionRadius_eq`; double-dual recovery in `FiniteGeom.CodeDuality` | Complete paper-facing theorem under the explicit standard dual-parameter characterization and \(k>0\) | None | C672 |
| `thm:transfer` | `RepairPorts.exactFunctionalStrata`, `RepairPorts.exactPointedConfinementAndTransfer`, and the exact cost terminals re-exported by `RepairPorts.Gates.CompletePorts` | Exact zero/singleton/multisupport profiles, pointed zero/nonzero minimum, and the cost-to-port-equality implication match the printed proof | None | C673 |
| `cor:strict-transfer` | `RepairCodes.projectiveAxisTwistedCubic_strict_weighted_transfer_of_regular_projective_action` | Exact functional distance five/not six, weighted threshold six, coordinate surjectivity, and radius-four transfer, conditional on the displayed regular Singer action | None | C673 |
| `thm:prescribed` | `RepairPorts.pointedConfinement_iff_zeroCost_of_outerDualDistance`, `eventually_pointedConfinement_iff_zeroCost`, `eventually_prescribedPorts`, `representedTargets_density`, `concatenatedRestrictedCode_parameters` | Exact trace bridge, eventual iff, support/coefficient equality, density, dimension, and distance are formal; random-GV or AG/TVZ existence is the explicit classical input | None | C674 |
| `cor:mds-fingerprints` | `RepairPorts.HasMDSDualParameters.pointedZeroFunctionalCost_eq`, `eventually_mdsMinimumCoefficientFingerprints`, plus the C672 MDS terminals | Exact \(z_x=2(k+1)\), generic support clutter, coefficient reconstruction, repeated copies, and density | None | C674 |
| `thm:reliability` | `RepairPorts.portReliability_delete_contract`, `hasDerivAt_portReliability_update`, `hasDerivAt_homogeneous_portReliability`, `blockerCount_eq_minimalBlockerCount_at_minimum`, and `blockerFailurePolynomial_eq_minimum_term_add_remainder` | Exact finite multilinear conditioning, pivotal derivative, Russo--Margulis sum, and minimum-blocker leading term with a remainder divisible by \(p^{\tau+1}\); exact profiles are not dependencies | None | C675 |
| `prop:bounded-exit` | `RepairPorts.erasureFailureProbability_delete_contract`, `noRepairProbability_eq_erasureFailure`, `truncatePort_mono`, `cheapestRepairRadiusProbability`, and `cheapestRepairRadiusProbability_eq_failure_sub` | Exact extrinsic erasure sign, no-repair convention, radius filtration, and cheapest-radius transform | None | C675 |
| `thm:tutte` | None | Cited classical identity and manuscript derivation only | Formalize the exact finite-rank specialization and pointed duality used by the paper | C676 |
| `prop:filtration-boundary` | None | Certified \(q=9\) witness only | Prefer a symbolic formal counterexample; otherwise remove theorem status from the body | C676 |
| `thm:cubic` | `FiniteGeom.axisTwistedCubic_code_parameters` and the `RepairCodes` circuit/locality/invariant chain | Strong existing coverage | One paper-facing application terminal and exact range/axiom reconciliation | C678 |
| `thm:harmonic` | No retained paper-facing Lean chain | Human/classical proof and finite certificates only | Formal code parameters, harmonic circuit characterization, port structure, and any retained reliability consequences | C677 |

## Aggregate gate

C679 must run the declaration-level axiom report for every admitted stable
label.  Standard logical axioms are allowed.  Every mathematical literature
input must be isolated, named, and matched to the paper's imported statement.
Certificates, native execution, and generated finite records may not occur in
the dependency closure of a main-spine terminal.
