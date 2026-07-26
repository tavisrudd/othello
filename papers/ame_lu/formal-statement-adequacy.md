# Formal statement adequacy

This ledger compares each manuscript result with the exact public Lean
declarations available under `RelativeConicArcs.AMELU`.  “Unconditional”
means that the declaration proves the stated mathematical implication from
ordinary typeclass assumptions.  “Conditional interface” means that a
public structure names mathematical or computational inputs not proved in
the module; constructing that structure remains part of the paper proof or
certificate boundary.

The aggregate import is
`RelativeConicArcs.Gates.AMELUAggregate`.  Its axiom audit is
`RelativeConicArcs.Gates.AMELUAggregateAxioms`.  The checked toolchain is
Lean `v4.32.0-rc1`.

| Manuscript result | Exact Lean declarations | Adequacy verdict | Boundary that must remain visible |
|---|---|---|---|
| `thm:dictionary` | `isMDSCode634_arcKernel`, `isAME_equalPhaseState_arcKernel`, `tensorWeylAction_equalPhaseState_of_mem_cssLabelSpace`, `cssLabelSpace_isPauliLagrangian`, `mem_cssSupportedLabelSpace_iff_support_subset`, `equalPhaseState_hasMinimalComputationalSupport`, `isAME_equalPhaseState_iff_isMDSCode634`, and `projectivelyEquivalent_equalPhaseState_locallyCliffordEquivalent` | **Unconditional statement coverage.**  The six-arc/MDS, stabilizer, AME, minimal-support, and projective-to-LC clauses in the proposition are all represented. | The paper still explains why its notation agrees with the formal ordered-arc, trace-phase, and party-action conventions. |
| `prop:full-weyl-marginal`; `cor:full-weyl-cover`; `thm:lu-lc-rigidity`; `cor:transversal-clifford` | `all_isClifford_of_fullWeylDiagonal_intertwining`, `genericMarginalWeylCoefficient_equalPhaseState_cases`, `genericReindexedMarginalArray_eq_diagonal`, `genericMarginalWeylCoordinates_eq_of_localAction_eq`, `familyFactor_coordinateAxes_of_diagonal_equivalent`, `generic_all_isClifford_of_localAction_equalPhaseState`, `genericLocallyUnitaryEquivalent_equalPhaseState_implies_genericLocallyCliffordEquivalent`, `encoderConversion_inverseTranspose_chosenLeg`, `IsCliffordMatrix.conjTranspose`, `IsCliffordMatrix.conjugate`, `IsCliffordMatrix.transpose`, and `encoderConversion_logical_and_physical_isClifford`; compatibility: `locallyUnitaryEquivalent_equalPhaseState_implies_locallyCliffordEquivalent_from_generic` | **The full-Weyl local criterion, diagonal-axis core, arbitrary-\(m\) LU-to-LC theorem, and factorwise two-encoder transversal no-go are unconditional.  The manuscript's abstract cover criterion is not a separate Lean terminal; its MDS specialization is checked by `generic_all_isClifford_of_localAction_equalPhaseState`.** | `EncoderConversionInputs.choi_conversion` is the forward normalized Choi equation `(I⊗U_phys)Ψ_C=(Lᵀ⊗I)Ψ_D`; the manuscript identifies it with the encoder equation `U_phys V_C=V_D L`. |
| `cor:discrete-lu-symmetry`; `cor:diagonal-isodual-transversal-group` | The exact-sequence and topological terminals from `AutomorphismExactSequence`; `GroupExtension.outerAction_eq_sectionClass`, `GroupExtension.factorSet_associativity`, `GroupExtension.factorSet_change`, `GroupExtension.factorSet_trivializable_iff_splitting`, `genericPartyPermutationFactorSet_associativity`, `genericPartyPermutationFactorSet_change`, and `genericPartyPermutationFactorSet_trivializable_iff_splits`; `IsDiagonallyIsodual`, `DiagonalIsodualityTransversalInputs`, and `diagonallyIsodual_fixedPartyProjectiveTransversal_dichotomy` from `EncoderTransversal` | **The finite discrete quotients, realized party-permutation extension, canonical outer action, normalized nonabelian factor-set laws, and splitting obstruction are unconditional.  The exact diagonal-isodual/split-torus carrier equality is a conditional formal interface with no GRS evaluation hypothesis.  The manuscript's arbitrary-length multiplier converse, Weil splitting on the linear factor, and Heisenberg non-splitting on the full affine one-qudit group are not formalized.** | `DiagonalIsodualityTransversalInputs` exposes the five exact proof obligations: special-linearity, torus propagation, isodual propagation, the off-diagonal converse, and the complete translation fiber.  It supplies neither a coherent unitary Weil representation nor a normalized kernel-valued cochain trivializing the realized party-permutation factor set. |
| `thm:lc-pencil` | `pencilZ_eq_iff_samePencilYOrbit` and `admitted_nonGRS_pencil_classified_by_z` | **Algebraic quotient unconditional; field-linear classification conditional.** | `PencilClassificationInputs` requires the six-arc property, explicit projectivities for the four deck branches, bracket invariance, and LC-holonomy recovery. The manuscript identifies this field-linear interface with the full quantum Clifford group only over prime fields. |
| `cor:lu-lc-pencil` | `locallyUnitaryEquivalent_admitted_nonGRS_pencil_iff_pencilZ_eq_from_generic` | **Generic-terminal composition formalized, conditional on `PencilClassificationInputs`.** | The LU-to-LC step is unconditional; the geometric and LC-holonomy inputs remain those of the LC classification. The manuscript identifies the field-linear Clifford interface with the full quantum Clifford group only over prime fields; extension-field Frobenius Cliffords remain outside the corollary. |
| `thm:logical-phase`; `cor:six-arc-fixed-party-group` | `fixedPartyKernel_eq_specialLinear_or_splitTorus` and `fixedPartyProjectiveTransversal_eq_affineSpecialLinear_or_splitTorus` | **Conditional coverage of both the field-linear fixed-party clause and the exact projective affine carrier.** | `LogicalPhaseInputs` requires special-linearity, torus propagation, conic propagation of every `SL₂` block, and the off-diagonal-to-conic implication. `FixedPartyProjectiveTransversalInputs.transversal_iff_linear_mem` states that every translation occurs over every realized linear block. The manuscript theorem is restricted to prime fields; extension-field full Clifford blocks and uniform party-moving groups are not formalized. |
| `thm:lu-h3-grs` | `card_marginalTriples`, `card_marginalStars`, `card_perfectMatchings`, `rankFourMultiplicity_eq_sixty_add_concurrency`, and `not_locallyUnitaryEquivalent_of_ten_vs_atMostSix_concurrences` | **Finite graph core unconditional; separator conditional.** | `MarginalMomentModel` and `MarginalLUSeparatorInputs` require the density-matrix trace formula, concurrency/rank equivalence, the H3 ten-count, the GRS six-bound, and LU covariance.  The three finite graph cardinalities use exhaustive native evaluation. |
| `thm:q13-lu` | `contractionMatchingRank_normalizeContractionPattern`, `contractionRankOrbitSum_permuteContractionPattern`, and `q13_zFour_not_locallyUnitaryEquivalent_zTwelve` | **Concrete witness data with a conditional terminal implication.** | `FourCopySeparatorInputs` requires the contraction/rank identities, LU covariance, and exact `720/13^9` and `3024/13^9` rank-orbit evaluations. |
| `thm:transport-divisor` | `negativeSignedCyclePolynomial_factor`, `positiveSignedCyclePolynomial_factor`, `axialCyclePolynomial_factor`, `reducedTransportDivisor_eq_zero_iff_three_factors`, `reducedTransportDivisor_eq_zero_iff_z`, `signedTransportFactor_sub_two_mul_axial`, `reducedTransportDivisor_eq_zero_iff_axial_of_charSeven`, the three `TransportCycleCoverInputs.*_det_factor` declarations, the two `TransportRankBridgeInputs.*` rank declarations, and the two `TransportOrbitGeometryInputs.card_axial_union_*` declarations | **Polynomial and characteristic-seven algebra unconditional; complete transport theorem conditional.** | The six fixed copy actions are parameters rather than instantiated quotient matrices.  The three determinant expansions, systematic rank bridge, generic one-dimensional kernel, and double-coset construction/cardinalities/disjointness remain named inputs.  The formal artifact must not be cited as an unconditional proof of the full divisor-and-multiplicity theorem. |
| `thm:fixed-copy-boundary` | none | **Not formalized.** | The componentwise irreducible-family scope, contraction-rank formula, generic-minor argument, and stable-range invariant spanning remain a conceptual paper proof. |

## Trust summary

The aggregate imports every declaration named above in one environment.
Except for the three explicitly identified finite graph cardinalities, the
audited terminals report only `propext`, `Classical.choice`, and
`Quot.sound`.  The three exhaustive native checks additionally report the
declaration-local axioms
`card_marginalTriples._native.native_decide.ax_1_1`,
`card_marginalStars._native.native_decide.ax_1_1`, and
`card_perfectMatchings._native.native_decide.ax_1_1`.  These cardinality
checks range over the finite types defined in
`RelativeConicArcs.AMELU.MarginalMoment`; they do not import generated data
or an external certificate.

The conditional structures are mathematical hypotheses, not Lean axioms.
The axiom audit therefore answers a different question from statement
adequacy: it records the logical trust dependencies of each implication,
while this ledger records whether the hypotheses needed to match a
manuscript theorem have themselves been constructed in Lean.

## Field-by-field closure of conditional inputs

The reverse map below closes the conditional interfaces field by field.
“Constructed” means that the cited manuscript passage supplies the
mathematical argument. “Certificate-supported” means that the paper-local
evidence package checks the exact finite or symbolic input. Some rows have
both statuses because the prose gives the proof mechanism and the certificate
replays its load-bearing algebra.

| Structure field | Manuscript source | Evidence source | Status |
|---|---|---|---|
| `PencilClassificationInputs.oddCharacteristic` | Section 4 opening and (4.1) | C396 row of `supplement/EVIDENCE.md` | domain hypothesis |
| `.admitted_isSixArc` | Section 4, explanation after (4.1) | C396 symbolic and twelve-field replay | constructed and certificate-supported |
| `.equal_z_implies_projectivelyEquivalent` | Section 4, (4.2) and the four-row projectivity table | C396 explicit-projectivity replay | constructed and certificate-supported |
| `.projectivelyEquivalent_implies_equal_z` | Section 4, bracket multiset (4.3) and its multiplicity argument | C396 symbolic bracket replay | constructed and certificate-supported |
| `.locallyCliffordEquivalent_implies_equal_z` | Section 4, shortened-plane holonomy paragraph and (4.4) | C396 direct-Lagrangian holonomy replay | constructed and certificate-supported |
| `LogicalPhaseInputs.kernel_specialLinear` | Section 5, first paragraph and first proof paragraph | C397 full-Lagrangian row-space replay | constructed and certificate-supported |
| `.splitTorus_subset_kernel` | Section 5, “Diagonal anchor blocks always propagate” | C397 group-closure replay | constructed and certificate-supported |
| `.conic_specialLinear_subset_kernel` | Section 5, GRS dual-multiplier propagation paragraph | C397 Gale and group-closure replays | constructed and certificate-supported |
| `.offDiagonal_kernel_implies_conic` | Section 5, coordinatewise scaling/Gale-fixed paragraph | C397 symbolic Gale replay | constructed and certificate-supported |
| `MarginalMomentModel.traceMoment` and `.commonConcurrent` | Section 6, first two paragraphs of the marginal-moment subsection | C402 row | constructed definitions |
| `.trace_eq_card_pow_rank` | Section 6, stabilizer expansion (6.1) | C402 direct Lagrangian-rank replay | constructed and certificate-supported |
| `.rank_eq_four_iff` | Section 6, star/perfect-matching reduction through (6.2) | C402 chord/rank replay | constructed and certificate-supported |
| `MarginalLUSeparatorInputs.source` and `.target` | Theorem 6.1 and its proof: H3 and arbitrary same-field GRS states | C402 exact-domain row | constructed instances |
| `.source_concurrency` | Theorem 6.1 proof, ten integral H3 determinants | C402 exact `Q(τ)` certificate | certificate-supported mathematical input |
| `.target_concurrency` | Theorem 6.1 proof, projective involution classification | C402 finite-permutation replay; Dickson for the finite-field families and Faber for the modern classification over general fields | constructed and independently certificate-supported |
| `.lu_implies_equal_rankFourMultiplicity` | Section 6 opening: simultaneous reduced-operator conjugation and party relabelling | no computation required | constructed implication |
| `FourCopySeparatorInputs.sourceContractionOrbitSum` and `.targetContractionOrbitSum` | Section 6, definition of `J_σ` and (6.4) | C397 row | constructed definitions |
| `.source_contraction_eq_rankOrbitSum` and `.target_contraction_eq_rankOrbitSum` | solution-counting identity (6.3) and the proof of Theorem 6.2 | C397 independent orbit-sum replay | constructed and certificate-supported |
| `.source_rankOrbitSum_evaluation` and `.target_rankOrbitSum_evaluation` | rank histograms and values in (6.4) | C397 exhaustive 720-permutation evaluation | certificate-supported inputs |
| `.lu_implies_equal_contractionOrbitSum` | Section 6 copy-contraction definition and party-orbit symmetrization | no finite computation required | constructed implication |
| `TransportCycleCoverInputs.*Actions` | Appendix A, the six copy permutations, systematic matrices `Q_p`, quotient actions `ρ_i`, and block operator (A.2)--(A.3) | C550 section/transport replay | constructed and certificate-supported |
| `.negativeSigned_det_cycleCover`, `.positiveSigned_det_cycleCover`, `.axial_det_cycleCover` | Theorem A.1 proof, three displayed determinant formulas | C550 signed cycle-cover and fraction-free determinant paths | constructed and certificate-supported |
| `TransportRankBridgeInputs.matchingRank`, `.transportRank`, `.matchingRank_le`, `.transportRank_le`, `.kernelExcess_eq` | Appendix A, the `24×21` and `9×9` constructions and (A.4) | C550 comparison at all 720 assignments for six exact points | constructed; identity certificate-supported |
| `TransportOrbitGeometryInputs.*Support` | Theorem A.1 proof, three active party-assignment double cosets | C550 double-coset certificate | constructed and certificate-supported |
| `.axial_card`, `.negativeSigned_card`, `.positiveSigned_card` | The two orbit-stabilizer quotients in the proof of Theorem A.1 | C550 exact orbit enumeration | constructed and certificate-supported |
| `.axial_disjoint_negative`, `.axial_disjoint_positive`, `.negative_disjoint_positive` | Theorem A.1 proof, signed-sheet and axial type separation | C550 exact support sets | certificate-supported inputs |

This table also supplies the reverse check: each paper-facing conditional
declaration in the aggregate audit appears above, and each cited manuscript
passage maps to the declaration listed for its theorem in the main adequacy
table. The aggregate import and
`RelativeConicArcs.Gates.AMELUAggregateAxioms` remain release artifacts;
`release/RELEASE-MANIFEST.json` records their immutable public identity
together with all 72 files in the complete project-owned AME--LU
verification graph.  Two foreign-owned transitive dependencies are not yet
referee-prose clean: `RelativeConicArcs/Plane.lean:7` reverse-references
another paper directory, and `FiniteGeom/Code.lean:16` cites an internal
handoff and work phase.  Neither defect changes an elaborated statement or
axiom dependency, but both must be repaired by their owners before the
formal companion is described as referee-ready.
