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
| `thm:lu-lc-rigidity` | none | **Not formalized.** | The diagonal tensor-axis lemma, MDS shortening argument, and deduction that every local unitary normalizes the finite-field Weyl system remain a conceptual paper proof. |
| `thm:lc-pencil` | `pencilZ_eq_iff_samePencilYOrbit` and `admitted_nonGRS_pencil_classified_by_z` | **Algebraic quotient unconditional; classification conditional.** | `PencilClassificationInputs` requires the six-arc property, explicit projectivities for the four deck branches, bracket invariance, and LC-holonomy recovery.  The manuscript supplies these steps. |
| `cor:lu-lc-pencil` | no single declaration | **Not formalized as a composition.** | The LC classification has the conditional interface above; the LU-to-LC implication uses the unformalized rigidity theorem. |
| `thm:logical-phase` | `fixedPartyKernel_eq_specialLinear_or_splitTorus` | **Conditional coverage of the fixed-party clause only.** | `LogicalPhaseInputs` requires special-linearity, torus propagation, conic propagation of every `SL₂` block, and the off-diagonal-to-conic implication.  The party-moving isodualities and resulting normalizer are not formalized. |
| `thm:lu-h3-grs` | `card_marginalTriples`, `card_marginalStars`, `card_perfectMatchings`, `rankFourMultiplicity_eq_sixty_add_concurrency`, and `not_locallyUnitaryEquivalent_of_ten_vs_atMostSix_concurrences` | **Finite graph core unconditional; separator conditional.** | `MarginalMomentModel` and `MarginalLUSeparatorInputs` require the density-matrix trace formula, concurrency/rank equivalence, the H3 ten-count, the GRS six-bound, and LU covariance.  The three finite graph cardinalities use exhaustive native evaluation. |
| `thm:q13-lu` | `contractionMatchingRank_normalizeContractionPattern`, `contractionRankOrbitSum_permuteContractionPattern`, and `q13_zFour_not_locallyUnitaryEquivalent_zTwelve` | **Concrete witness data with a conditional terminal implication.** | `FourCopySeparatorInputs` requires the contraction/rank identities, LU covariance, and exact `720/13^9` and `3024/13^9` rank-orbit evaluations. |
| `thm:transport-divisor` | `negativeSignedCyclePolynomial_factor`, `positiveSignedCyclePolynomial_factor`, `axialCyclePolynomial_factor`, `reducedTransportDivisor_eq_zero_iff_three_factors`, `reducedTransportDivisor_eq_zero_iff_z`, `signedTransportFactor_sub_two_mul_axial`, `reducedTransportDivisor_eq_zero_iff_axial_of_charSeven`, the three `TransportCycleCoverInputs.*_det_factor` declarations, the two `TransportRankBridgeInputs.*` rank declarations, and the two `TransportOrbitGeometryInputs.card_axial_union_*` declarations | **Polynomial and characteristic-seven algebra unconditional; complete transport theorem conditional.** | The six fixed copy actions are parameters rather than instantiated quotient matrices.  The three determinant expansions, systematic rank bridge, generic one-dimensional kernel, and double-coset construction/cardinalities/disjointness remain named inputs.  The formal artifact must not be cited as an unconditional proof of the full divisor-and-multiplicity theorem. |
| `thm:fixed-copy-boundary` | none | **Not formalized.** | The contraction-rank formula, generic-minor argument, and stable-range invariant spanning remain a conceptual paper proof. |

## Trust summary

The aggregate imports every declaration named above in one environment.
Except for the three explicitly identified finite graph cardinalities, the
audited terminals use ordinary kernel elaboration.  The native
cardinality checks are exhaustive over the finite types defined in
`RelativeConicArcs.AMELU.MarginalMoment`; they do not import generated data
or an external certificate.

The conditional structures are mathematical hypotheses, not Lean axioms.
The axiom audit therefore answers a different question from statement
adequacy: it records the logical trust dependencies of each implication,
while this ledger records whether the hypotheses needed to match a
manuscript theorem have themselves been constructed in Lean.
