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
| `thm:prescribed` | `RepairPorts.FunctionalCost` and `RepairCodes.WeightedTransferExact` finite core | Trace/random/AG existence and asymptotic parameter assembly remain prose | Formal conditional outer-family interface and final density/rate/distance theorem | C674 |
| `cor:mds-fingerprints` | Depends on C672+C674 | No terminal | Derive the general MDS and named geometric consequences | C674 |
| `thm:reliability` | None | Existing scripts check selected polynomials, not the theorem | Finite-sum reliability, deletion--contraction, pivotal derivative, blocker expansion | C675 |
| `prop:bounded-exit` | None | Existing script checks selected curves | Radius filtration, erasure-sign recurrence, cheapest-radius distribution, and exact convention bridge | C675 |
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
