# Formalization ledger

This ledger maps stable paper statements to their exact Lean coverage.  A list
of related declarations is not by itself an adequacy verdict.

| Paper label | Existing Lean coverage | Present boundary | Missing terminal or bridge | Owner |
|---|---|---|---|---|
| `def:complete-port` | `FiniteGeom.repairHypergraph`, `minimalRepairHypergraph`, coefficient recovery declarations, matching/transversal invariance | Support port and normalized recovery vectors are checked | Package the three layers and intrinsic pointed-port transport at the paper's abstraction level | C672 |
| `def:reconstruction-radius` | None | New paper object | Define reconstruction from coefficient fibers and prove pointed-monomial invariance | C672 |
| `thm:mds-reconstruction` | General MDS/code infrastructure only | No paper-facing result | Minimum coefficient fibers span the required dual data; reconstruct the pointed code; identify the generic uniform support clutter | C672 |
| `thm:transfer` | `RepairCodes.WeightedTransfer*`, including exact zero/singleton/multisupport profiles, pointed threshold, transfer, surjective reduction, and nonsurjective counterexample | Mathematical content is broadly checked | Assemble a small paper-facing terminal with exactly the printed hypotheses and conclusion; audit its axioms | C673 |
| `cor:strict-transfer` | Completed-seed functional-cost, Singer translate, generalized-SPC, and radius-four transfer declarations | Conditional on cited Singer regularity | Package the paper corollary and record the imported input verbatim | C673 |
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

