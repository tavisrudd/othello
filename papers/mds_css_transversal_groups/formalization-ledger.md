# Formalization ledger

The mathematical namespace is `RelativeConicArcs.AMELU`. This paper's formal
companion has two semantic roots:

- `RelativeConicArcs.Gates.MDSCSSTransversalGeometry` — the import-only gate
  whose transitive closure is the whole of this paper's checked Lean surface;
- `RelativeConicArcs.Gates.MDSCSSTransversalGeometryAxioms` — the axiom audit,
  which imports only that gate and prints the dependencies of every cited
  declaration.

The trust contract is computed recursively from those two roots and recorded in
`lean/trust/areas/relconic.toml` and `lean/trust/facts/`; the paper-level
registration is in `lean/trust/papers.toml` and
`lean/trust/paper-facts/mds_css_transversal_groups.json`. Neither the shared
`AMELU` namespace as a whole nor the mixed aggregate gate is this paper's
formal closure.

## Status by manuscript result

| Manuscript result | Formal status | Boundary |
|---|---|---|
| MDS--CSS/six-arc dictionary | unconditional dictionary and stabilizer-dictionary declarations | none at statement level |
| Diagonal multiplier line and nullity | unconditional `DiagonalIsoduality` declarations | none at statement level |
| Exact affine carrier dichotomy | conditional `EncoderTransversal` interface | special-linearity, propagation, block-to-multiplier converse, and complete translation fiber remain inputs |
| Weil lift and Heisenberg nonsplitting | none | manuscript and cited representation theory |
| Pencil quotient | unconditional scalar quotient plus hypothesis-explicit classification interface | projectivity and holonomy inputs explicit; prime-field quantum scope manuscript controlled |
| Frobenius-sector divisors | unconditional `ExtensionFieldPencil` declarations | two representation-theoretic orbit bridges excluded |
| Syndrome geometry | unconditional `SyndromeGeometry` core | cited Clebsch conic/count/orbit external to this paper's formal source |
| Marginal/four-copy/transport applications | unconditional algebra and conditional terminals | finite evaluations and geometry bridges remain certificate inputs |
| Party splitting | unconditional abstract splitting consequences | twelve concrete complements remain certificate checked |
| Six-arc self-association and logical phase | conditional `LogicalPhase` interface | the Gale/conic equivalence is manuscript proof |
| Fixed-copy contraction boundary | none | manuscript proof |
| Concurrent matchings on a conic | none | manuscript proof |

## Crosswalk to exact declarations

Every name below is prefixed by `RelativeConicArcs.AMELU.` and lies in the
closure of the gate above. Rows marked *interface* derive their conclusion from
a structure whose fields state unproved geometric, propagation, orbit, or
finite-certificate inputs.

| Label | Formal class | Declarations |
|---|---|---|
| `thm:dictionary` | unconditional | `isMDSCode634_arcKernel`, `isAME_equalPhaseState_arcKernel`, `isAME_equalPhaseState_iff_isMDSCode634`, `projectivelyEquivalent_equalPhaseState_locallyCliffordEquivalent`, `tensorWeylAction_equalPhaseState_of_mem_cssLabelSpace`, `cssLabelSpace_isPauliLagrangian`, `mem_cssSupportedLabelSpace_iff_support_subset`, `equalPhaseState_hasMinimalComputationalSupport` |
| `prop:diagonal-multiplier-line` | unconditional | `diagonalMultiplier_ne_zero_at`, `diagonalMultiplierSpace_finrank_le_one`, `diagonalMultiplierSpace_self_eq_span_one`, `diagonalDualityMultiplierSpace_finrank_eq_zero_or_one`, `isDiagonallyIsodual_iff_finrank_eq_one`, `not_isDiagonallyIsodual_iff_finrank_eq_zero`, `diagonalDuality_existsUnique_unit_smul_eq`, `diagonalDuality_multiplier_ratio_eq`, `GenericDiagonalDuality.diagonalMultiplierBilinForm_eq_zero`, `genericDiagonalDualityOfMultiplier` |
| `cor:diagonal-isodual-transversal-group` | interface | `fixedPartyProjectiveTransversal_eq_affineSpecialLinear_or_splitTorus`, `diagonallyIsodual_fixedPartyProjectiveTransversal_dichotomy`, `diagonalDualityNullity_fixedPartyProjectiveTransversal_dichotomy`, `offDiagonalBlock_fixedPartyProjectiveTransversal_eq_affineSpecialLinear`, `grs_projectiveTransversal_eq_affineSpecialLinear`, `affineSpecialLinearOrder_seven`; supporting unconditional shears `genericCSSLabel_lowerDualityShear`, `genericCSSLabel_upperDualityShear` and code parameters `oneLegQuantumMDSParameters_singletonEquality`, `isMDSCode2m_oneLegQuantumMDSParameters` |
| `lem:six-arc-self-association`, `thm:logical-phase` | interface plus unconditional block algebra | `fixedPartyKernel_eq_specialLinear_or_splitTorus`; `splitTorusWeylBlock_isSpecialLinear`, `splitTorusWeylBlock_mul_self`, `splitTorusWeylBlock_mul_splitTorusBlock` |
| `thm:lc-pencil`, `cor:lu-lc-pencil` | unconditional quotient plus interface | `pencilZ_eq_iff_samePencilYOrbit`, `pencilFrameRatio_crossDifference`, `pencilFrameRatio_eq_iff`; `admitted_nonGRS_pencil_classified_by_z`, `locallyUnitaryEquivalent_equalPhaseState_implies_locallyCliffordEquivalent`, `locallyUnitaryEquivalent_admitted_nonGRS_pencil_iff_pencilZ_eq` |
| `prop:frobenius-sector-divisors` | unconditional | `twistedPencilGaleDivisor_refl`, `pencilGalePairing_multiplier`, `pencilGalePairing_multiplier_zero_iff`, `twistedPencil_sectors_disjoint`, `map_pencilGRSQuartic`, `map_pencilA`, `map_pencilB`, `map_pencilZ`, `admitted_nonGRS_map_iff` |
| `lem:coset-syndrome-charts`, `prop:clebsch-x-syndrome` | unconditional core, cited external geometry | `tensorWeylAction_X_equalPhaseState_eq_translated`, `translatedEqualPhaseState_eq_iff`, `stateInnerProduct_translatedEqualPhaseState_eq_zero`, `tensorWeylAction_Z_translatedEqualPhaseState`, `supportedArcSyndrome_bijective_of_card_three`, `existsUnique_arcSyndrome_supported_on_three`, `existsUnique_arcSyndrome_weight_three_on_support` |
| `thm:lu-h3-grs` | interface; three cardinalities native-evaluated, and the multiplicity identity and separator inherit the star-count evaluation axiom | `card_marginalTriples`, `card_marginalStars`, `card_perfectMatchings`, `rankFourMultiplicity_eq_sixty_add_concurrency`, `not_locallyUnitaryEquivalent_of_ten_vs_atMostSix_concurrences` |
| `thm:q13-lu` | interface over certificate inputs | `contractionMatchingRank_normalizeContractionPattern`, `contractionRankOrbitSum_permuteContractionPattern`, `q13_zFour_not_locallyUnitaryEquivalent_zTwelve` |
| `thm:transport-divisor` | unconditional algebra plus interfaces | `negativeSignedCyclePolynomial_factor`, `positiveSignedCyclePolynomial_factor`, `axialCyclePolynomial_factor`, `reducedTransportDivisor_eq_zero_iff_three_factors`, `reducedTransportDivisor_eq_zero_iff_z`, `signedTransportFactor_sub_two_mul_axial`, `reducedTransportDivisor_eq_zero_iff_axial_of_charSeven`; `TransportCycleCoverInputs.*_det_factor`, `TransportRankBridgeInputs.matchingRank_eq_twenty_of_transportRank_eq_eight`, `TransportRankBridgeInputs.matchingRank_eq_twentyOne_of_transportRank_eq_nine`, `TransportOrbitGeometryInputs.card_axial_union_negative`, `TransportOrbitGeometryInputs.card_axial_union_positive` |
| `cor:computed-party-splitting` | unconditional abstract consequences; complements certificate-checked | `GroupExtension.factorSet_change`, `GroupExtension.factorSet_trivializable_iff_splitting`, `GroupExtension.Splitting.semidirectProductEquiv`, `genericPartyPermutationFactorSet_associativity`, `genericPartyPermutationFactorSet_change`, `genericPartyPermutationFactorSet_trivializable_iff_splits`, `genericPartyPermutationExtension_splits_iff`, `genericPartyPermutationGroupExtensionSplitting`, `genericPartyPermutationSemidirectProductEquiv`, `genericPartyPermutation_natCard` |
| `thm:fixed-copy-boundary` | manuscript only | none |
| `lem:conic-matchings` | manuscript only | none |
| `thm:lu-lc-rigidity` (imported) | companion-owned; the equal-phase specialization used here is in this closure | `genericLocallyUnitaryEquivalent_equalPhaseState_implies_genericLocallyCliffordEquivalent`, `locallyUnitaryEquivalent_equalPhaseState_implies_locallyCliffordEquivalent_from_generic` |
| `cor:transversal-clifford` (imported) | companion-owned; present in this closure | `encoderConversion_inverseTranspose_chosenLeg`, `encoderConversion_inverseTranspose_and_physical_isClifford`, `encoderConversion_logical_and_physical_isClifford` |
| `lem:pauli-phase-correction` (imported) | companion-owned; only its character-realization ingredient is here | `pauliSymplecticToDual_injective`, `exists_pauliLabel_pairing_eq_dual` |
| Imported minimum-support atlas | companion-owned | none in this closure |

The arbitrary-additive supported-label, minimum-support atlas, and
holonomy-centralizer developments are outside this closure, as are the
companion paper's quantitative rounding, partial-Weyl recognition, two-uniform,
and robust-atlas modules.
