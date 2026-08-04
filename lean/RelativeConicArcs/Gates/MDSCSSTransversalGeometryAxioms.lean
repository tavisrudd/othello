import RelativeConicArcs.Gates.MDSCSSTransversalGeometry

/-!
# Axiom audit for diagonal isoduality and transversal Clifford groups of MDS--CSS codes

This module imports only the semantic gate of the MDS--CSS transversal-group
development and prints the axiom dependencies of every declaration that this
manuscript cites: the six-arc/MDS/CSS/AME dictionary, the stabilizer
dictionary and the character realization behind the Pauli phase correction,
the diagonal multiplier line and nullity test, the exact fixed-party carrier
dichotomies with their generalized Reed--Solomon and order-16464 instances,
the coset and syndrome geometry, the admitted-pencil quotient and its
projective, local-Clifford, and local-unitary classifications, the
Frobenius-sector divisors of the twisted pencil, the marginal-moment
separator, the fixed-party logical phase, the four-copy separator at
`q = 13`, the transport divisor, and the abstract party-extension splitting
consequences.

Several audited declarations are the conclusions of hypothesis-explicit
interfaces.  Their assumptions are ordinary structure arguments, not axioms,
so they do not appear in the printed dependencies; the gate header states
which inputs those structures carry.

The three six-party graph cardinalities `card_marginalTriples`,
`card_marginalStars`, and `card_perfectMatchings` are discharged by exhaustive
native evaluation and therefore expose declaration-local implementation axioms
of the pinned toolchain in addition to the standard three.
`rankFourMultiplicity_eq_sixty_add_concurrency` and
`not_locallyUnitaryEquivalent_of_ten_vs_atMostSix_concurrences` are proved from
the star count and inherit its evaluation axiom.  Every other listed
declaration is checked by kernel reduction and depends on no more than
propositional extensionality, choice, and quotient soundness.
-/

open RelativeConicArcs.AMELU

-- Six-arc, MDS, CSS, and AME dictionary.
#print axioms isMDSCode634_arcKernel
#print axioms isAME_equalPhaseState_arcKernel
#print axioms isAME_equalPhaseState_iff_isMDSCode634
#print axioms projectivelyEquivalent_equalPhaseState_locallyCliffordEquivalent

-- Stabilizer dictionary and the character realization behind the phase correction.
#print axioms tensorWeylAction_equalPhaseState_of_mem_cssLabelSpace
#print axioms cssLabelSpace_isPauliLagrangian
#print axioms mem_cssSupportedLabelSpace_iff_support_subset
#print axioms equalPhaseState_hasMinimalComputationalSupport
#print axioms pauliSymplecticToDual_injective
#print axioms exists_pauliLabel_pairing_eq_dual

-- Diagonal duality multiplier line and nullity test.
#print axioms diagonalMultiplier_ne_zero_at
#print axioms diagonalMultiplierSpace_finrank_le_one
#print axioms diagonalMultiplierSpace_self_eq_span_one
#print axioms diagonalDualityMultiplierSpace_finrank_eq_zero_or_one
#print axioms isDiagonallyIsodual_iff_finrank_eq_one
#print axioms not_isDiagonallyIsodual_iff_finrank_eq_zero
#print axioms diagonalDuality_existsUnique_unit_smul_eq
#print axioms diagonalDuality_multiplier_ratio_eq
#print axioms GenericDiagonalDuality.diagonalMultiplierBilinForm_eq_zero
#print axioms genericDiagonalDualityOfMultiplier

-- Exact fixed-party transversal carrier and its instances.
#print axioms genericCSSLabel_lowerDualityShear
#print axioms genericCSSLabel_upperDualityShear
#print axioms fixedPartyProjectiveTransversal_eq_affineSpecialLinear_or_splitTorus
#print axioms diagonallyIsodual_fixedPartyProjectiveTransversal_dichotomy
#print axioms diagonalDualityNullity_fixedPartyProjectiveTransversal_dichotomy
#print axioms offDiagonalBlock_fixedPartyProjectiveTransversal_eq_affineSpecialLinear
#print axioms grs_projectiveTransversal_eq_affineSpecialLinear
#print axioms affineSpecialLinearOrder_seven
#print axioms oneLegQuantumMDSParameters_singletonEquality
#print axioms isMDSCode2m_oneLegQuantumMDSParameters

-- Encoder conversions and equal-phase rigidity imported from the companion paper.
#print axioms encoderConversion_inverseTranspose_chosenLeg
#print axioms encoderConversion_inverseTranspose_and_physical_isClifford
#print axioms encoderConversion_logical_and_physical_isClifford
#print axioms genericLocallyUnitaryEquivalent_equalPhaseState_implies_genericLocallyCliffordEquivalent
#print axioms locallyUnitaryEquivalent_equalPhaseState_implies_locallyCliffordEquivalent_from_generic

-- Coset and syndrome geometry.
#print axioms tensorWeylAction_X_equalPhaseState_eq_translated
#print axioms translatedEqualPhaseState_eq_iff
#print axioms stateInnerProduct_translatedEqualPhaseState_eq_zero
#print axioms tensorWeylAction_Z_translatedEqualPhaseState
#print axioms supportedArcSyndrome_bijective_of_card_three
#print axioms existsUnique_arcSyndrome_supported_on_three
#print axioms existsUnique_arcSyndrome_weight_three_on_support

-- Admitted-pencil quotient and classifications.
#print axioms pencilZ_eq_iff_samePencilYOrbit
#print axioms admitted_nonGRS_pencil_classified_by_z
#print axioms locallyUnitaryEquivalent_equalPhaseState_implies_locallyCliffordEquivalent
#print axioms locallyUnitaryEquivalent_admitted_nonGRS_pencil_iff_pencilZ_eq
#print axioms pencilFrameRatio_crossDifference
#print axioms pencilFrameRatio_eq_iff

-- Frobenius sectors of the twisted pencil.
#print axioms twistedPencilGaleDivisor_refl
#print axioms pencilGalePairing_multiplier
#print axioms pencilGalePairing_multiplier_zero_iff
#print axioms twistedPencil_sectors_disjoint
#print axioms map_pencilGRSQuartic
#print axioms map_pencilA
#print axioms map_pencilB
#print axioms map_pencilZ
#print axioms admitted_nonGRS_map_iff

-- Marginal-moment separator; the three cardinalities use native evaluation.
#print axioms card_marginalTriples
#print axioms card_marginalStars
#print axioms card_perfectMatchings
#print axioms rankFourMultiplicity_eq_sixty_add_concurrency
#print axioms not_locallyUnitaryEquivalent_of_ten_vs_atMostSix_concurrences

-- Fixed-party logical phase.
#print axioms fixedPartyKernel_eq_specialLinear_or_splitTorus
#print axioms splitTorusWeylBlock_isSpecialLinear
#print axioms splitTorusWeylBlock_mul_self
#print axioms splitTorusWeylBlock_mul_splitTorusBlock

-- Four-copy separator.
#print axioms contractionMatchingRank_normalizeContractionPattern
#print axioms contractionRankOrbitSum_permuteContractionPattern
#print axioms q13_zFour_not_locallyUnitaryEquivalent_zTwelve

-- Transport divisor.
#print axioms negativeSignedCyclePolynomial_factor
#print axioms positiveSignedCyclePolynomial_factor
#print axioms axialCyclePolynomial_factor
#print axioms reducedTransportDivisor_eq_zero_iff_three_factors
#print axioms reducedTransportDivisor_eq_zero_iff_z
#print axioms signedTransportFactor_sub_two_mul_axial
#print axioms reducedTransportDivisor_eq_zero_iff_axial_of_charSeven
#print axioms TransportCycleCoverInputs.negativeSigned_det_factor
#print axioms TransportCycleCoverInputs.positiveSigned_det_factor
#print axioms TransportCycleCoverInputs.axial_det_factor
#print axioms TransportRankBridgeInputs.matchingRank_eq_twenty_of_transportRank_eq_eight
#print axioms TransportRankBridgeInputs.matchingRank_eq_twentyOne_of_transportRank_eq_nine
#print axioms TransportOrbitGeometryInputs.card_axial_union_negative
#print axioms TransportOrbitGeometryInputs.card_axial_union_positive

-- Party-extension splitting consequences.
#print axioms GroupExtension.factorSet_change
#print axioms GroupExtension.factorSet_trivializable_iff_splitting
#print axioms GroupExtension.Splitting.semidirectProductEquiv
#print axioms genericPartyPermutationFactorSet_associativity
#print axioms genericPartyPermutationFactorSet_change
#print axioms genericPartyPermutationFactorSet_trivializable_iff_splits
#print axioms genericPartyPermutationExtension_splits_iff
#print axioms genericPartyPermutationGroupExtensionSplitting
#print axioms genericPartyPermutationSemidirectProductEquiv
#print axioms genericPartyPermutation_natCard
