# Formalization coverage ledger

This ledger records the exact Lean boundary of the projective Reed--Solomon results used in this
paper.  A row marked `kernel checked` means that the named declaration elaborates in the pinned
Lean and mathlib toolchain.  It does not mean that hypotheses supplied to the declaration have
also been proved in Lean.  The declaration-level reconciliation for every numbered manuscript
theorem, proposition, and corollary is
`supplement/LEAN-STATEMENTS.md`.

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
| Divided-power marker contraction | `RelativeConicArcs.PRSPolarInduction.iteratedProjectiveSequenceContraction_map` and `RelativeConicArcs.PRSPolarInduction.sequenceContraction_agrees_with_finite` | iterated projective contraction agrees with the displayed finite contraction map | identification of the chosen coordinates with a particular projective Reed--Solomon parity check |
| Persistent tangent/sigma union | `RelativeConicArcs.PRSFoundation.PersistentFamilies.persistent_card` | the cardinality of a disjoint declared union is the sum of the two cardinalities | parametrization, disjointness, and degree-specific family counts |
| Split-free exhaustion | `RelativeConicArcs.PRSFoundation.OrbitExhaustionInput.splitFree_iff_mem_persistent` | equivalence from two separately named exhaustion implications | the projective and projective-semilinear group actions, stabilizers, orbit representatives, and exhaustion proofs |
| Witness-based coding synthesis | `RelativeConicArcs.PRSFoundation.deep_iff_mem_persistent_of_exceptional_shallow` | persistent syndromes are deep and every exceptional syndrome is shallow imply exact classification | the positive persistent theorem, complement identification, and negative witness theorem; no covering-radius or split-free-exhaustion input is used |
| Radius-based coding synthesis | `RelativeConicArcs.PRSFoundation.deep_iff_mem_persistent_of_compatible` | the Hankel, radius, and exhaustion interfaces compose under pointwise equivalence of their split-free predicates | every concrete input named in the preceding rows |

The import gate is `RelativeConicArcs.Gates.PRSFoundation`.  Its axiom audit is
`RelativeConicArcs.Gates.PRSFoundationAxiomAudit`.  The reusable logical terminals introduce no
project-specific axioms.  Their printed dependencies are either empty or subsets of the standard
Lean/mathlib axioms `propext`, `Classical.choice`, and `Quot.sound`.

## Degree-specific coverage

| Paper result | Formal status | Exact Lean boundary | Missing formal content |
|---|---|---|---|
| Polar construction | conditional terminal checked | `RelativeConicArcs.PRSPolarInduction.projectiveDividedPowerContraction`, `iteratedProjectiveSequenceContraction_map`, `PointedKernelLift.lift_splitSquarefreeKernelMember`, and `mem_modularContractionKernel_iff` | identification with the projective parity-check coordinates, the concrete polynomial multiplication map, and degree-specific nucleus equations |
| Effective transverse induction | conditional terminal checked | `RelativeConicArcs.PRSPolarInduction.CoherentPolarInput.splitFree_implies_persistent_or_modular` proves the contained/transverse dichotomy from explicit lower threshold, carrier degree, collision degree, marker cardinality, component classification, and witness inputs | geometric integrality of each identity-Frobenius twist, genus and deletion calculations, equations and containment for the lower bad carrier, and the cited rational-point bound |
| All-level stable components | coordinate terminals checked | `RelativeConicArcs.PRSStableComponents.symmetricFactor_plucker`, `exchangedFactor_plucker`, and `antiInvariantFactor_plucker` prove the three ordered-root factor calculations; the four `coherentFano_*_hankelMinor` declarations prove the displayed integral coefficient identities; `mem_modularContractionKernel_prod_iff` proves the exact two-coordinate coherent-lift criterion; `cyclicPlaneCatalecticant_blocks_cover` and `cyclicPlaneCatalecticant_no_nonzero_coefficient` prove termination of the characteristic-two cyclic-plane descendant for \(m\geq3\) | density of squarefree marker products, projective row-space closure, the irreducible bottom-component ledger, cyclic-ideal elimination and saturation, and geometric classifications of contained lines remain manuscript proofs supported by Certificate SC |
| Redundancy five | conditional terminal checked | `RelativeConicArcs.PRSRedundancyFiveCertified.redundancyFiveSynthesisWithCertificate`; Hankel identities `RelativeConicArcs.PRSRedundancyFive.affine_span_product_mem_hankelKernel` and `RelativeConicArcs.PRSRedundancyFive.affine_pair_infinity_span_product_mem_hankelKernel`; family-count theorems under `RelativeConicArcs.PRSRedundancyFive.FamilyData`; transcribed sporadic table with internally checked arithmetic under `RelativeConicArcs.PRSRedundancyFiveCertificate` | the converse projective span criterion, Seroussi--Roth completeness, Aubry--Perret point bound, cubic-cover stratum classification, genuine group-action derivation of the orbit counts, and semantic validation of the external finite enumeration remain explicit inputs |
| Redundancies six and seven | conditional terminals checked | `RelativeConicArcs.PRSRedundancySixSeven.redundancySixHighFieldSynthesis` and `redundancySevenHighFieldSynthesis` specialize the polar budgets to `29; 7+6` and `37; 4+8`; `redundancySixAllFieldSynthesis` and `redundancySevenAllFieldSynthesis` combine them with explicit finite bridges; `RelativeConicArcs.PRSRedundancySixSevenCertificate` checks the transcribed R6/R7 field-summary arithmetic and exact exceptional orbit-count inventories | concrete catalecticant and nucleus-component identifications, split-cover geometry, covering-radius inputs, genuine projective and semilinear group actions, and semantic validation of the public finite records remain hypotheses; the R7 rows at `q=7,8,9` are split-free tables only |

## Mathematical dependency ledger

The paper-facing closure has no mathematical dependency on another repository
paper. `RelativeConicArcs` modules imported by the gate are shared
infrastructure or formalizations of results proved in this manuscript, not
authority imported from a separate project paper.

| External source | Exact statement consumed | Manuscript use and formal boundary |
|---|---|---|
| Seroussi--Roth, *On MDS extensions of generalized Reed--Solomon codes* (1986), DOI `10.1109/TIT.1986.1057188`, Theorem 1 | the complete high-rate one-coordinate MDS-extension classification, including the even-characteristic `k=3` exception | `prop:r5-radius` and the R6/R7 radius promotion; Kaipa's Theorem 2 supplies the geometric restatement. Lean treats the radius result as a structure field. |
| Kaipa, *Deep holes and MDS extensions of Reed--Solomon codes* (2017), DOI `10.1109/TIT.2017.2706677`, arXiv `1612.05447` | Proposition 1 (syndrome/MDS-extension correspondence) and Theorem 2 (geometric Seroussi--Roth restatement) | coding dictionary, persistent families, and the radius gate. Concrete coding semantics remain external to Lean. |
| Zhang--Wan--Kaipa, *Deep holes of projective Reed--Solomon codes* (2020), DOI `10.1109/TIT.2019.2940962`, arXiv `1901.05445` | Lemma II.4 and Theorems I.4--I.6 | projective syndrome/normal-rational-curve dictionary and the tangent/conjugate-secant families and counts. |
| Aubry--Perret, *A Weil theorem for singular curves* (1995), DOI `10.1007/BF02567835`, p. 468 | the arithmetic-genus point lower bound used with correction `κ=1` | R5 and polar lower-cover point counts. Lean records genus/deletion data but obtains witnesses from the separate `lowerWitness` field; it does not derive this bound. |
| Gmainer--Havlicek, *Nuclei of normal rational curves* (2000; arXiv version 2013), DOI `10.1007/BF01237480`, arXiv `1304.0088`, Lemma 1 and Theorem 1 | Lucas' binomial congruence and the nucleus basis criterion | modular-kernel support and `cor:large-characteristic-stable`. The geometric identification is a manuscript proof. |
| Wang, *Factorization types in families of polynomials over finite fields* (2026), arXiv `2606.12810v1`, Theorem 3.6 | factorization type equals Frobenius cycle type on the étale locus | splitting-family semantics only; it does not prove the marked Hankel induction or contained-component classification. |

## Trust boundary

The paper-facing closure is
`RelativeConicArcs.Gates.PRSBeyondRedundancyFour`, with tracked audit
`RelativeConicArcs.Gates.PRSBeyondRedundancyFourAxiomAudit`. It imports exactly the foundation,
redundancy-five, polar-induction and redundancy-six/seven, and stable-component gates.

The closure imports no generated Lean certificate, native evaluator, external oracle, or
project-local axiom.  The aggregate audit reports only the standard Lean/mathlib dependencies
`propext`, `Classical.choice`, and `Quot.sound`; many algebraic and finite-table terminals are
axiom-free.  Finite classification records and externally proved covering-radius or rational-point
theorems require separate public artifacts and citations.  The R5--R7 transcription modules name
`supplement/CLASSIFICATION-RECORDS.json`, SHA-256
`b3441d983798793f211878de7e72b976be9170b580041f460cf981a73dbf66a2`;
Lean checks the transcribed arithmetic but keeps semantic validation and exhaustive-search
coverage as explicit structure fields.

A constructed split squarefree kernel member proves shallowness without a covering-radius theorem;
covering radius is needed to promote the absence of such witnesses to deepness.  Consequently,
exact classification may follow either from a radius-plus-exhaustion theorem or from positive
deepness on the persistent locus together with explicit shallow witnesses on its complement.
Numerical orbit tables supplied as structure fields are checked only as hypotheses unless a module
constructs the corresponding group actions and proves their exhaustion.
