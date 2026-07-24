# Formalization coverage ledger

This ledger records the exact Lean boundary of the projective Reed--Solomon results used in this
paper.  A row marked `kernel checked` means that the named declaration elaborates in the pinned
Lean and mathlib toolchain.  It does not mean that hypotheses supplied to the declaration have
also been proved in Lean.

## Shared interfaces

| Mathematical role | Lean declaration | Kernel-checked content | Explicit unformalized input |
|---|---|---|---|
| Hankel-kernel dictionary | `RelativeConicArcs.PRSFoundation.HankelKernelDictionary.splitFree_iff_no_kernel_member` | the interface identifies split-freeness with absence of a split squarefree kernel member | the concrete Hankel matrix and the proof that its kernel has the stated coding semantics |
| Kernel member contradicts split-freeness | `RelativeConicArcs.PRSFoundation.HankelKernelDictionary.not_splitFree_of_kernel_member` | formal implication from kernel incidence and split-squarefreeness | construction of the member |
| Constructive negation boundary | `RelativeConicArcs.PRSFoundation.HankelKernelDictionary.not_splitFree_iff_not_not_has_kernel_member` | failure of split-freeness is equivalent to double negation of kernel-member existence without classical choice | removal of the double negation requires decidability or classical logic |
| Covering-radius promotion | `RelativeConicArcs.PRSFoundation.CoveringRadiusInput.deep_iff_splitFree` | deepness and split-freeness coincide under the named radius-range proposition | the external covering-radius theorem and verification that the code parameters lie in its range |
| Predicate-level witness construction | `RelativeConicArcs.PRSFoundation.WitnessConstructionInput.exceptional_has_kernel_member` | component and undeleted-point hypotheses imply the packaged witness predicate | component geometry, rational-point existence, deletion bounds, and the point-to-polynomial construction |
| Polynomial-level witness construction | `RelativeConicArcs.PRSFoundation.GeometricWitnessInput.exceptional_has_kernel_member` | the same implication with an explicit polynomial witness | the concrete polynomial type and every geometric input |
| Extensional witness compatibility | `RelativeConicArcs.PRSFoundation.exceptional_not_splitFree_of_compatible_geometric_kernel_member` | pointwise equivalence of the geometric and Hankel predicates suffices; literal equality of predicate functions is unnecessary | proofs of the pointwise incidence and split-squarefree equivalences |
| Geometric witness excludes deepness | `RelativeConicArcs.PRSFoundation.exceptional_not_deep_of_geometric_kernel_member` | an explicit split squarefree kernel member makes the syndrome shallow using only the structural implication from deepness to split-freeness | the geometric witness and identification of its predicates with the Hankel and coding interfaces; no covering-radius promotion is required |
| Divided-power marker contraction | `RelativeConicArcs.PRSResidualQuadratic.dividedPowerContraction_comm` and `RelativeConicArcs.PRSResidualQuadratic.dividedPowerContraction_twice_apply` | marker contractions commute and have the displayed two-marker coordinate formula over every commutative ring | identification of the chosen coordinates with a particular projective Reed--Solomon parity check |
| Persistent tangent/sigma union | `RelativeConicArcs.PRSFoundation.PersistentFamilies.persistent_card` | the cardinality of a disjoint declared union is the sum of the two cardinalities | parametrization, disjointness, and degree-specific family counts |
| Split-free exhaustion | `RelativeConicArcs.PRSFoundation.OrbitExhaustionInput.splitFree_iff_mem_persistent` | equivalence from two separately named exhaustion implications | the projective and projective-semilinear group actions, stabilizers, orbit representatives, and exhaustion proofs |
| Coding synthesis | `RelativeConicArcs.PRSFoundation.deep_iff_mem_persistent_of_compatible` | the Hankel, radius, and exhaustion interfaces compose under pointwise equivalence of their split-free predicates | every concrete input named in the preceding rows |

The import gate is `RelativeConicArcs.Gates.PRSFoundation`.  Its axiom audit is
`RelativeConicArcs.Gates.PRSFoundationAxiomAudit`.  The reusable logical terminals introduce no
project-specific axioms.  Their printed dependencies are either empty or subsets of the standard
Lean/mathlib axioms `propext`, `Classical.choice`, and `Quot.sound`.

## Degree-specific coverage

| Paper result | Formal status | Exact Lean boundary | Missing formal content |
|---|---|---|---|
| Polar construction | interface checked | common divided-power contraction and witness-construction interfaces above | projective coordinate bridge, iterated polar flags, squarefree lifting, and the degree-specific forbidden diagonal |
| Effective transverse induction | interface checked | thresholded component and rational-point hypotheses are explicit structure fields | the curve component theorem, genus and deletion calculations, and the cited rational-point bound |
| Redundancy five | conditional terminal checked | `RelativeConicArcs.PRSRedundancyFiveCertified.redundancyFiveSynthesisWithCertificate`; Hankel identities `RelativeConicArcs.PRSRedundancyFive.affine_span_product_mem_hankelKernel` and `RelativeConicArcs.PRSRedundancyFive.affine_pair_infinity_span_product_mem_hankelKernel`; family-count theorems under `RelativeConicArcs.PRSRedundancyFive.FamilyData`; transcribed sporadic table with internally checked arithmetic under `RelativeConicArcs.PRSRedundancyFiveCertificate` | the converse projective span criterion, Seroussi--Roth completeness, Aubry--Perret point bound, cubic-cover stratum classification, genuine group-action derivation of the orbit counts, and semantic validation of the external finite enumeration remain explicit inputs |
| Redundancies six and seven | no terminal declaration | shared contraction, witness, radius, and exhaustion interfaces are available | coherent polar induction, contained components, exceptional finite bridges, and the radius-restricted coding promotion |
| Redundancy eight | no terminal declaration | shared contraction and conditional synthesis interfaces are available | three-marker construction, the field-order threshold, contained components, and exact orbit arithmetic |
| Redundancy nine | conditional terminal checked | `RelativeConicArcs.PRSRedundancyNine.redundancyNineSynthesis` | geometric integrality, rational-point existence after deletions, coding identification, exhaustion, and genuine group-action derivation of the orbit table |
| Characteristic-two ordered Hessian | no terminal declaration | common contraction and explicit-hypothesis conventions are available | doubled discriminant, ordered-Hessian carrier geometry, root-compatible pullback, and containment synthesis |
| Power-of-two Lucas endpoints and the distinguished degree-nine orbit | no terminal declaration | common explicit witness and exhaustion interfaces are available | Lucas overlap identities, linearized covers, trace lifting, additive subspace-polynomial witnesses, and orbit transport |

## Trust boundary

The gates import no generated certificate, native evaluator, external oracle, or project-local
axiom.  Finite classification records and externally proved covering-radius or rational-point
theorems require separate public artifacts and citations.  A constructed split squarefree kernel
member proves shallowness without a covering-radius theorem; covering radius is needed to promote
the absence of such witnesses to deepness.  Numerical orbit tables supplied as structure fields are
checked only as hypotheses unless a later module constructs the corresponding group actions and
proves their exhaustion.
