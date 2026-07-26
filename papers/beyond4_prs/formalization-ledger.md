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
| Uniform radius arithmetic | `RelativeConicArcs.PRSUniformCoveringRadius.seroussiRothDimensionRange_of_uniformTransverseThreshold` | for \(r\geq6\), the exact transverse threshold implies the complete Seroussi--Roth high-rate range, including exclusion of the even-field dimension-three exception | identification of the natural-square-root threshold with the displayed floor notation uses the elementary identity \(\lfloor2\sqrt n\rfloor=\lfloor\sqrt{4n}\rfloor\) |
| Uniform iterated-package arithmetic | `RelativeConicArcs.PRSUniformCoveringRadius.bottomCurveDeletionBudget_eq`, `exactLinearGraphDeletionBudget_eq`, the two `*DeletionBudget_lt_fieldOrder_add_one` terminals, `intermediateParameterBudget_lt_uniformParameterBudget`, and `UniformIteratedPackageInput.packages_fit_uniform_threshold` | checks the formulas \(13+6(r-5)=6r-17\), \(8+2(r-5)=2r-2\), \(3r-j-2<3r-5\), and that the threshold leaves points after both terminal-package deletions and every stagewise parameter scheme | properness, integrality, rational graph cardinality, and degrees of the concrete schemes, and their identification with the manuscript construction are explicit fields |
| Seroussi--Roth--Dür radius bridge | `RelativeConicArcs.PRSUniformCoveringRadius.SeroussiRothDuerRadiusInput.radiusRange_of_externalSeroussiRothDuer` and `RelativeConicArcs.PRSUniformCoveringRadius.deep_iff_splitFree_of_externalSeroussiRothDuer_uniformTransverseThreshold` | the two cited implications compose with the threshold arithmetic and the existing syndrome interface | the concrete dual-GRS identification, Seroussi--Roth nonextendability, Dür equivalence, field order, and identification of `radiusRange` with \(\rho=r-1\) are separate explicit fields |
| Redundancy-six field-eight endpoint | `RelativeConicArcs.PRSUniformCoveringRadius.SeroussiRothDuerRadiusInput.seroussiRothDimensionRange_six_eight` and `RelativeConicArcs.PRSUniformCoveringRadius.SeroussiRothDuerRadiusInput.radiusRange_six_eight_of_externalSeroussiRothDuer` | checks the exact endpoint \(6=\lfloor8/2\rfloor+2\) and composes the same external inputs | the same coding semantics and cited theorems remain external |
| Predicate-level witness construction | `RelativeConicArcs.PRSFoundation.WitnessConstructionInput.exceptional_has_kernel_member` | component and undeleted-point hypotheses imply the packaged witness predicate | component geometry, rational-point existence, deletion bounds, and the point-to-polynomial construction |
| Polynomial-level witness construction | `RelativeConicArcs.PRSFoundation.GeometricWitnessInput.exceptional_has_kernel_member` | the same implication with an explicit polynomial witness | the concrete polynomial type and every geometric input |
| Extensional witness compatibility | `RelativeConicArcs.PRSFoundation.exceptional_not_splitFree_of_compatible_geometric_kernel_member` | pointwise equivalence of the geometric and Hankel predicates suffices; literal equality of predicate functions is unnecessary | proofs of the pointwise incidence and split-squarefree equivalences |
| Geometric witness excludes deepness | `RelativeConicArcs.PRSFoundation.exceptional_not_deep_of_geometric_kernel_member` | an explicit split squarefree kernel member makes the syndrome shallow using only the structural implication from deepness to split-freeness | the geometric witness and identification of its predicates with the Hankel and coding interfaces; no covering-radius promotion is required |
| Divided-power marker contraction | `RelativeConicArcs.PRSPolarInduction.iteratedProjectiveSequenceContraction_map` and `RelativeConicArcs.PRSPolarInduction.sequenceContraction_agrees_with_finite` | iterated projective contraction agrees with the displayed finite contraction map | identification of the chosen coordinates with a particular projective Reed--Solomon parity check |
| Recursive contained-component descent | `RelativeConicArcs.PRSSquarefreeMarkerDensity.eq_zero_of_splitCoefficientPullback_eval_eq_zero_on_injective` and `RelativeConicArcs.PRSStableComponents.RecursiveContainedGeometryInput.bad_implies_persistent_or_modular` | polynomial density of monic split-squarefree coefficient tuples, closure transport from a dense attainable locus, selection from a finite closed-component cover by irreducibility, and finite induction through persistent/modular one-step lifts | identification of the marker coefficient map and its closure with the catalecticant row space, the exact reduced component ledger, and the geometric classification of its components are explicit structure fields |
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
| Effective transverse induction | conditional terminals checked | `RelativeConicArcs.PRSPolarInduction.CoherentPolarInput.splitFree_implies_persistent_or_modular` proves the contained/transverse dichotomy from explicit lower threshold, carrier degree, collision degree, marker cardinality, component classification, and witness inputs; `PRSUniformCoveringRadius.UniformIteratedPackageInput.packages_fit_uniform_threshold` checks the simultaneous all-stage budget composition | geometric integrality of each identity-Frobenius twist, equations and properness for each concrete bad carrier, genus and deletion calculations, and the cited rational-point bound |
| All-level stable components | density, coordinate, component-selection, and recursive terminals checked | `RelativeConicArcs.PRSSquarefreeMarkerDensity.eq_zero_of_splitCoefficientPullback_eval_eq_zero_on_injective` proves polynomial density of monic split-squarefree coefficient tuples; `RelativeConicArcs.PRSStableComponents.ContainedRowSpaceData.rowSpace_subset_badCarrier` and `exists_component_containing_rowSpace` check the density-to-closure and finite irreducible-component steps; `RecursiveContainedGeometryInput.bad_implies_persistent_or_modular` composes the selected component with recursive descent; the factor, coherent-Fano, modular-kernel, and cyclic-plane declarations check the displayed coordinate identities and termination calculation | identification of the marker coefficient map with the catalecticant row-space closure, the bottom-component primary decomposition, cyclic-ideal elimination and saturation, and geometric classification of each listed component remain manuscript or Certificate SC inputs |
| Redundancy five | conditional terminal checked | `RelativeConicArcs.PRSRedundancyFiveCertified.redundancyFiveSynthesisWithCertificate`; Hankel identities `RelativeConicArcs.PRSRedundancyFive.affine_span_product_mem_hankelKernel` and `RelativeConicArcs.PRSRedundancyFive.affine_pair_infinity_span_product_mem_hankelKernel`; family-count theorems under `RelativeConicArcs.PRSRedundancyFive.FamilyData`; transcribed sporadic table with internally checked arithmetic under `RelativeConicArcs.PRSRedundancyFiveCertificate` | the converse projective span criterion, Seroussi--Roth completeness, Aubry--Perret point bound, cubic-cover stratum classification, genuine group-action derivation of the orbit counts, and semantic validation of the external finite enumeration remain explicit inputs |
| Balanced field-eight quantum consequence | arithmetic and LU/transversal terminals checked; quantum dictionary conditional | `RelativeConicArcs.PRSBalancedQuantumExtension.fieldEightRecord_mem_certifiedFieldRecords`, `fieldEight_projectiveDirectionCount`, `fieldEight_balancedExtensionParameters`, and `fieldEight_uniqueBalancedPrimePowerRow`; `lengthTen_locallyUnitaryEquivalent_implies_locallyCliffordEquivalent` and `lengthTen_encoderConversion_logical_and_physical_isClifford`; `certifiedBalancedExtensions_haveQuantumConsequences` composes the explicit dictionary interface | identification of the projective extension family with the generic MDS submodule model, and the standard MDS--AME and one-party Choi semantics, remain cited inputs; no complete LU/LC orbit count is claimed |
| Redundancies six and seven | conditional terminals checked | `RelativeConicArcs.PRSRedundancySixSeven.redundancySixHighFieldSynthesis` and `redundancySevenHighFieldSynthesis` specialize the polar budgets to `29; 7+6` and `37; 4+8`; `redundancySixAllFieldSynthesis` and `redundancySevenAllFieldSynthesis` combine them with explicit finite bridges; `RelativeConicArcs.PRSRedundancySixSevenCertificate` checks the transcribed R6/R7 field-summary arithmetic and exact exceptional orbit-count inventories | concrete catalecticant and nucleus-component identifications, split-cover geometry, covering-radius inputs, genuine projective and semilinear group actions, and semantic validation of the public finite records remain hypotheses; the R7 rows at `q=7,8,9` are split-free tables only |

## Mathematical dependency ledger

The paper-facing closure has no mathematical dependency on another repository
paper. `RelativeConicArcs` modules imported by the gate are shared
infrastructure or formalizations of results proved in this manuscript, not
authority imported from a separate project paper.

| External source | Exact statement consumed | Manuscript use and formal boundary |
|---|---|---|
| Seroussi--Roth, *On MDS extensions of generalized Reed--Solomon codes* (1986), DOI `10.1109/TIT.1986.1057188`, Theorem 1 | the complete high-rate one-coordinate MDS-extension classification, including the even-characteristic `k=3` exception | nonextendability input for `prop:r5-radius`, the R6/R7 radius promotion, and the automatic all-level radius equality for \(q\geq Q_r\). Lean treats the radius result as a structure field. |
| Dür, *On the covering radius of Reed--Solomon codes* (1994), DOI `10.1016/0012-365X(94)90256-9` | completeness of the dual normal rational curve is equivalent to covering radius \(q-k\) for the length-\(q+1\) Reed--Solomon code | noncircular passage from Seroussi--Roth nonextendability to the R5, R6, R7, and all-level radius equalities. Lean treats this coding/geometric equivalence as external. |
| Kaipa, *Deep holes and MDS extensions of Reed--Solomon codes* (2017), DOI `10.1109/TIT.2017.2706677`, arXiv `1612.05447` | Proposition 1 (syndrome/MDS-extension correspondence); Section IV's theorem of Dür (completeness iff covering radius \(q-k\)); Proposition 4(1) (Seroussi--Roth range) | coding dictionary, persistent families, and the noncircular passage from dual nonextendability to the radius gate. Concrete coding semantics remain external to Lean. |
| Zhang--Wan--Kaipa, *Deep holes of projective Reed--Solomon codes* (2020), DOI `10.1109/TIT.2019.2940962`, arXiv `1901.05445` | Lemma II.4 and Theorems I.4--I.6 | projective syndrome/normal-rational-curve dictionary and the tangent/conjugate-secant families and counts. |
| Aubry--Perret, *A Weil theorem for singular curves* (1995), DOI `10.1007/BF02567835`, p. 468 | the arithmetic-genus point lower bound used with correction `κ=1` | R5 and polar lower-cover point counts. Lean records genus/deletion data but obtains witnesses from the separate `lowerWitness` field; it does not derive this bound. |
| Gmainer--Havlicek, *Nuclei of normal rational curves* (2000; arXiv version 2013), DOI `10.1007/BF01237480`, arXiv `1304.0088`, Lemma 1 and Theorem 1 | Lucas' binomial congruence and the nucleus basis criterion | modular-kernel support and `cor:large-characteristic-stable`. The geometric identification is a manuscript proof. |
| Wang--Wu--Hu, *3-Designs from \(\mathrm{GL}_2(\mathbb F_q)\)-Invariant Subspaces of \(\mathbb F_q[X,Y]_k\)* (2026), arXiv `2604.21183v4`, Proposition 11 | the Lucas-subspace projective-subline block family for \(k=p^a+1\) is nonempty exactly when \(a\mid e\) over \(\mathbb F_{p^e}\) | prior equivalent projective form of the canonical divisibility clause in `prop:higher-lucas-endpoint`; the coherent Hankel-endpoint identification and the full-\(e_7\)-orbit conclusion remain manuscript proofs and have no direct Lean declaration. |
| Wang, *Factorization types in families of polynomials over finite fields* (2026), arXiv `2606.12810v1`, Theorem 3.6 | factorization type equals Frobenius cycle type on the étale locus | splitting-family semantics only; it does not prove the marked Hankel induction or contained-component classification. |

## Trust boundary

The paper-facing closure is
`RelativeConicArcs.Gates.PRSBeyondRedundancyFour`, with tracked audit
`RelativeConicArcs.Gates.PRSBeyondRedundancyFourAxiomAudit`. It imports exactly the foundation,
redundancy-five, polar-induction and redundancy-six/seven, and stable-component gates.
It also directly imports `RelativeConicArcs.PRSUniformCoveringRadius`, whose literature adapter
keeps the Seroussi--Roth and Dür implications as separate structure fields.
The cross-paper quantum corollary has the separate import-only gate
`RelativeConicArcs.Gates.PRSBalancedQuantumExtension` and tracked audit
`RelativeConicArcs.Gates.PRSBalancedQuantumExtensionAxiomAudit`; keeping it
separate prevents the AME--LU dependency closure from being misreported as
part of the geometric R5--R7 aggregate.

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
