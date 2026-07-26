# Trust manifest — arcs complete outside a conic

This directory is the standalone Lean formalization of
`papers/arcs_complete_outside_conic/`.  It is one-way coupled to the existing `ProjectiveCap`
library: it may import general projective infrastructure, but no existing project imports this
spinoff.

## Machine-checked theorem map

| Layer | Main declarations | Status |
|---|---|---|
| incidence and relative completeness | `Arc`, `CompleteOutside`, `rho`, `ProjectiveBridge.arc_iff_projectiveCap` | defined/proved in Lean |
| cap-game localization | persistent containment/move theorems; `legalExtensions_sdiff_holes_eq_uncovered`; `win_parametrizedHoles_iff`, `isP_parametrizedHoles_iff` | proved in Lean; domain legality is separated from the exact parametrized game-value bridge |
| moments and defect | `pointIndex_le_half_card`, `first_secant_moment`, `second_secant_moment`, defect/coverage/stability theorems in `Defect.lean`, `scaledDefect_eq_zero_or_half_sub_two_le` | proved in Lean; the last theorem is the integral zero-or-gap alternative for nonzero scaled defect |
| exact uncovered-locus reconstruction | `linesAboveUncoveredThreshold_eq_secants`, `verticesOfLineFamily_secants_eq`, `canonical_reconstruction`, `eq_of_ordinaryUncovered_eq`, `stabilizes_iff_stabilizes_ordinaryUncovered` | proved in `UncoveredLocusReconstruction.lean` for abstract finite projective planes; the inverse uses the strict line threshold and `k ≥ 3`, while the stabilizer theorem is stated for any action satisfying the displayed incidence-equivariance hypotheses |
| concurrence and matching rigidity | `concurrence_matching`, `disjoint_arcPairs_existsUnique_concurrence`, `concurrence_matching_injective`, `concurrenceCenter_pointIndex_eq_half`, `concurrenceCenters_card_eq_quotient`, `concurrenceCentersOnPair_card_eq_quotient`, `two_mul_badConcurrenceEdgeCount_le`, `exists_secantDeletionSet` | proved in `MatchingDesignRigidity.lean`; the total and per-secant counts are exact quotient identities for `k ≥ 4`; the final two declarations control respectively the edge count and vertex-cover number of the bad-concurrence graph using `scaledDefect = floor(k/2)·Δ` |
| odd tangent-carrier algebra | `sq_injective_charTwo`, `oddTangentFactorization_rescale`, `oddZerothConductorSq_ne_zero`, `card_additiveConductorMatching_edgeSet`, `existsUnique_additiveConductorMatching_of_ne`, `card_nonzeroOrderedConductorPairs`, `card_nonzeroUnorderedConductorPairs`, `tangentConductorMatching_adj_iff_additiveConductorMatching`, `tangentFiberCompatibilityGraph_isClique_iff_injOn`, `tangentFiberCompatibilityGraph_clique_card_le`, `exists_tangentFiberCompatibilityGraph_clique_card_eq`, `ordinaryGlobalizes_iff_of_transversal_arc_criteria`, `oddCarrierConductor_mul_commonFactor_ne_zero_iff` | proved in `OddTangentCarrier.lean`; Lean checks root uniqueness and rescaling, the nonzero same-fiber zeroth conductor, the canonical additive one-factorization and its deletion to near-perfect tangent matchings, the exact ordered- and unordered-pair counts, the complete multipartite compatibility graph and its exact clique bound, the logical composition of the transversal-arc globalization criterion, and preservation of first-conductor nonvanishing under a common factor. Identifying the finite factor product with the projective dual Chow product for an arc, identifying geometric tangent fibers, proving the regular-oval triple count, and supplying the projective carrier-extension hypotheses remain analytic inputs |
| paired Chow restriction and Frobenius descent | `planeLineRestriction_X`, `planeLineRestrictedCoefficients`, `affinePointOnParametrizedPlaneLine`, `planeLineRestriction_homogeneousLinearPolynomial`, `planeLineRestrictedCoefficients_affinePoint`, `planeLineRestrictedCoefficients_ne_zero_of_affinePoint_ne_zero`, `injective_affineNode_of_pairwise_avoids_incidentPoint`, `exists_ne_zero_scale_planeLineRestriction_homogeneousLinearPolynomial_eq_C_mul_homogenize_X_sub_C`, `exists_ne_zero_scale_planeLineRestriction_eq_C_mul_homogenize_X_sub_C_of_affinePoint`, `exists_scale_planeLineRestriction_eq_C_mul_homogenize_X_sub_C_of_affinePoints`, `injective_affineNode_and_exists_scale_planeLineRestriction_eq_C_mul_homogenize_X_sub_C_of_pairwise_avoids`, `eq_of_sq_eq_sq_expCharTwo`, `eval_eq_of_eval_sq_eq_expCharTwo`, `homogeneousLinearPolynomial_scale`, `planeLineRestriction_homogeneousLinearPolynomial_scale`, `planeLineRestriction_dualLinearFactorProduct`, `prod_eq_sq_of_equiv_sum`, `prod_eq_scaleProduct_mul_sq_of_equiv_sum`, `prod_eq_sq_of_equiv_sum_of_scaleProduct_sq`, `planeLineRestriction_dualLinearFactorProduct_eq_sq_of_pairing`, `planeLineRestriction_dualLinearFactorProduct_eq_scaleProduct_mul_sq_of_pairing`, `planeLineRestriction_dualLinearFactorProduct_eq_sq_of_proportionalPairing`, `exists_planeLineRestriction_dualLinearFactorProduct_eq_sq_of_proportionalPairing`, `globalSquareRoot_restricts`, `exists_globalSquareRoot_of_jointlyDetected_extendedRoots`, `isInSquareFrobeniusImage_of_jointlyDetected_extendedRoots` | proved in `ChowRestrictionDescent.lean`; Lean constructs homogeneous linear substitution and the finite dual-factor product, computes the binary coefficients of a restricted plane-linear equation, and identifies restricted evaluation with plane incidence. Pairwise avoidance derives injective affine-node parameters; for a nontrivially indexed family it also derives restricted nonvanishing and simultaneously identifies every restricted factor up to a nonzero scalar. Equality of squared polynomial-root values forces equality of their values by characteristic-two Frobenius injectivity. Lean further tracks representative rescaling, proves that proportional paired restricted factors give an aggregate scalar times a square, constructs the corrected root when that scalar is a square, makes the scalar condition automatic over perfect exponent-characteristic-two coefficient rings, and descends extended linewise roots through a jointly detecting restriction family. Projective representative independence of the full factor product, the secant-induced proportional pairing, bounded-degree joint detection, and the concrete incidence and factor inputs for interpolation remain geometric inputs |
| binary proportionality and carrier-bound algebra | `exists_ne_zero_scale_binaryCoefficients_of_determinant_eq_zero`, `exists_ne_zero_scale_homogeneousLinearPolynomial_of_binary_determinant_eq_zero`, `homogenize_X_sub_C_eq_homogeneousLinearPolynomial_affineNode`, `exists_ne_zero_scale_homogeneousLinearPolynomial_eq_C_mul_homogenize_X_sub_C`, `dualLinearFactorProduct_rescale`, `exists_dualLinearFactorProduct_rescale_eq_sq_of_exists_eq_sq`, `exists_dualLinearFactorProduct_rescale_eq_sq_iff`, `fintypeProd_X_sub_C_dvd_of_injective_roots`, `fintypeProd_X_sub_C_dvd_sub_of_injective_eval_eq`, `homogenize_fintypeProd_X_sub_C_dvd_homogenize_sub_of_injective_eval_eq`, `natDegree_dehomogenize_le_of_isHomogeneous`, `homogeneousLinearPolynomial_dvd_of_isHomogeneous_eval_projectiveZero`, `fintypeProd_homogeneousLinearPolynomial_dvd_of_isHomogeneous_eval_projectiveZeros`, `fintypeProd_homogeneousLinearPolynomial_dvd_sub_of_isHomogeneous_eval_projectiveZeros_eq`, `fintypeProd_homogeneousLinearPolynomial_dvd_sub_of_isHomogeneous_eval_projectiveZeros_sq_eq`, `homogenize_fintypeProd_X_sub_C_dvd_sub_of_isHomogeneous_eval_eq`, `homogenize_fintypeProd_X_sub_C_eq_prod_homogenize`, `prod_eq_C_prod_mul_homogenize_fintypeProd_X_sub_C`, `prod_dvd_of_homogenize_fintypeProd_X_sub_C_dvd_of_proportional`, `prod_dvd_sub_of_proportional_homogenizedNodeFactors_of_isHomogeneous_eval_eq`, `firstCoordinateHyperplaneRestriction_eq_zero_iff_dvd`, `firstCoordinateHyperplaneRestriction_surjective`, `coordinateTransformedHyperplaneRestriction_eq_zero_iff_dvd`, `coordinateTransformedHyperplaneRestriction_surjective`, `exists_single_correction_of_surjective_of_residual_dvd`, `exists_finset_extension_of_residual_dvd_restrictedEquationProduct`, `exists_finset_coordinateTransformed_extension_of_residual_dvd`, `exists_finset_extension_of_single_correction`, `totalDegree_fintypeProd_of_ne_zero`, `totalDegree_fintypeProd_eq_card_of_degree_one`, `eq_zero_of_pairwise_isRelPrime_dvd_of_totalDegree_lt_card`, `exists_eq_C_mul_fintypeProd_of_pairwise_isRelPrime_dvd_of_totalDegree_le_card`, `not_exists_eq_sq_of_squarefree_of_not_isUnit`, `not_exists_fintypeProd_eq_sq_of_pairwise_isRelPrime_of_squarefree`, `card_le_of_linewiseSquareRoots_extend_and_jointlyDetect`, `exists_extendedRoot_difference_eq_C_mul_lineProduct`, `exists_coordinateTransformed_extendedRoot_difference_eq_C_mul_lineProduct`, `card_le_of_linewiseSquareRoots_extend_of_lineProductDetection` | proved in `ChowRestrictionDescent.lean` and `CarrierArcBound.lean`; Lean checks binary determinant-zero proportionality, representative-invariance of square status over perfect characteristic-two fields, coordinate-free divisibility of a homogeneous binary form by a nonzero linear form from vanishing at its canonical projective zero, the corresponding finite-product and characteristic-two square-agreement forms, the retained affine specialization, restriction-kernel divisibility and surjectivity for coordinate-transformed lines, quotient-lift corrections and their finite iteration, line-product degree detection and exact-threshold classification, product nonsquareness, and the resulting conditional carrier identities.  Concrete projective incidence, equality of squared values from the ambient Chow restriction, pairwise relative primality, and the remaining line and factor hypotheses remain explicit inputs. |
| projective carrier incidence algebra | `MvPolynomial.IsHomogeneous.eval_smul_point`, `eval_planeLineRestriction`, `binaryLinearCoefficientDeterminant_planeLineRestrictedCoefficients`, `eval_homogeneousLinearPolynomial_canonicalProjectiveZero`, `eval_planeCovector_pointOnParametrizedLine_canonicalRestrictedZero`, `eval_planeLineRestrictions_eq_of_pointOnParametrizedLine_eq`, `eval_eq_of_planeLineRestriction_sq_eq_at_shared_plane_representative`, `mvPolynomial_irreducible_of_totalDegree_eq_one`, `homogeneousLinearPolynomial_isRelPrime_of_binaryCoefficientDeterminant_ne_zero`, `pairwise_isRelPrime_planeLineRestrictedLinearFactors_of_determinant_ne_zero`, `fintypeProd_planeLineRestrictedLinearFactors_dvd_sub_of_projectiveZero_sq_eq` | proved in `ChowRestrictionDescent.lean` and `CarrierArcBound.lean`; homogeneous scaling and restriction naturality control representative changes, the restricted-factor determinant is the explicit three-term Cauchy--Binet pairing, canonical binary zeros map to incident plane representatives, nonzero determinants imply pairwise relative primality of the actual restricted factors, and exact shared plane representatives give root-value compatibility by characteristic-two Frobenius injectivity.  Geometric determinant nonvanishing, coherent construction of exact shared representatives for a concrete carrier, interpolation, and bounded-degree joint detection remain analytic inputs. |
| charted projective carrier theorem | `binaryLinearCoefficientDeterminant_restrictions_eq_planeVectorDeterminant_normal`, `pairwise_restrictedDeterminant_ne_zero_of_normal_eq_scale`, `planeLineRestriction_center_eq_zero_of_normal_eq_scale`, `exists_binaryPreimage_of_restrictedCovectorProjectiveZero`, `planeLineRestriction_homogeneousComponent`, `PlaneLineCoordinateChart.planeLineRestriction_surjective`, `PlaneLineCoordinateChart.lineEquation_isRelPrime_of_restricted_ne_zero`, `planeLineRestriction_finsetLineProduct_dvd_root_sub_restriction`, `exists_finset_homogeneous_carrierRoot_extension_of_coordinateCharts`, `card_le_two_mul_degree_of_coordinateCharts_carrierRoots`, `fintype_card_le_two_mul_degree_of_coordinateCharts_carrierRoots` | proved in `ProjectiveCarrierGeometry.lean`; a line chart packages its nonzero center representative, rank-two homogeneous parametrization, exact incident-vector reconstruction, polynomial lift, and principal restriction kernel.  Cauchy--Binet converts no-three-collinearity into restricted-factor relative primality; exact intersection representatives give square compatibility; homogeneous-component projection preserves the degree in quotient-lift interpolation; and line-product detection bounds every finite nonsquare carrier family by twice the root degree.  Constructing these charts from the projectivized arc model and identifying the arc's representative product and maximum-index restrictions with the dual Chow hypotheses remain analytic inputs. |
| unique-fixed-point orbit congruence | `card_mod_group_order_eq_one_of_unique_fixed_point_action`, `card_mod_four_eq_one_of_unique_fixed_point_action`, `no_unique_fixed_point_four_group_action_on_card_ninety_one` | proved in `KleinFourOrbitCongruence.lean` from Burnside's lemma: a nontrivial finite-group action whose nonidentity elements fix the same singleton has set cardinality congruent to one modulo the group order; the order-four specialization excludes cardinality 91 |
| upper even equality branch | `upper_even_equality_branch_holeIncidence`, `ZeroDefectConicInvariance.maximumIndexParameters_card_eq_two_mul_sub_one`, `TangentPairFourGroup.upper_even_equality_branch_half_even`, `TangentPairFourGroup.no_upper_even_equality_branch` | proved in `EqualityConsequences.lean`, `ZeroDefectConicInvariance.lean`, and `TangentPairFourGroup.lean`; zero defect gives one conic incidence per secant and an invariant maximum-index set of size \(2m-1\), while the characteristic-two field order forces \(m\) even. A tangent secant then produces three unique-fixed-point involutions on a set of cardinality three modulo four, contradicting permutation sign. The nucleus is correctly excluded: its chord map is the identity |
| arbitrary holes and conic bounds | `completeOutside_bound_general`, `NonsingularConic.finite_lower_bound`, `L1_le_L2`, `L2_le_rho`, `even_completeOutside_zeroDefect_order_spectrum`, `odd_completeOutside_zeroDefect_order_spectrum` | proved in Lean; the general bound depends only on hole cardinality and incidence, and the last two theorems give the three possible plane orders for even and odd zero-defect arcs complete outside any hole set of cardinality \(q+1\) |
| complete affine arcs | `CompleteAffine`, `completeAffine_iff_completeOutside`, `holeIncidence_pointsOnLine`, `completeAffine_bound`, `completeAffine_bound_eq_iff`, `completeAffine_equality_order` | proved in `Affine.lean` and `EqualityConsequences.lean`; deleting a line is definitionally the line-hole case, every secant contributes one ideal incidence, and equality forces one of the two displayed plane orders |
| asymptotics | `parityFreeNecessary`, `rhoC_explicit_additive_lower_bound`, `eventually_lt_centered`, and the Big-O/liminf wrappers in `Asymptotic.lean` | proved in Lean; the paper's isolated polynomial estimate is the `hExpansion`/`hB2`/`hB1`/`hB0`/`hR` block of `explicit_additive_lower_bound`, with the same error `8 / sqrt(2q)`. `eventually_lt_centered` is unconditional along unbounded orders; the literal real-valued liminf wrapper adds coboundedness because `ℝ` cannot encode `+∞` |
| averaging | `exists_completeOutside_of_completeArc`, `rhoC_le_t2`, `rhoC_le_of_kimVuBound` | proved in Lean for arbitrary holes under `|A||H| < |PG(2,K)|`; Kim--Vu remains an explicit theorem parameter |
| characteristic two | hyperoval/nucleus/tangent classification, `complete_holeIncidence_pos`, nucleus-in/out inequalities in `Nucleus.lean`, `odd_standardConic_zeroDefect_charTwo_order`, `TangentPairFourGroup.no_upper_even_equality_branch`, and `TangentPairFourGroup.even_standardConic_zeroDefect_charTwo_order` | proved in Lean; the terminals collapse the odd equality spectrum to \(q=k-1\), exclude the upper even branch without Ramanujan--Nagell, and conclude \(q=k-2\) for every even zero-defect arc complete outside the standard conic. The converse identification of an arbitrary oval with a nucleus-containing prescribed conic, the parallel arbitrary-hyperoval interpretation, and projective transport of the standard-conic terminal are not formalized |
| certificate bridge | relative and ordinary canonical-coverage soundness; `rawArc_iff_projectiveCap`; `check_sound`, `check_sound_empty` | proved in Lean for every finite field |
| ordinary uncovered obstruction | `ordinaryUncovered_subset_holes`, `ordinaryUncovered_card_le_holes`, `ordinaryUncovered_arc`, `NonsingularConic.points_arc`, `completeOutside_ordinaryUncovered_arc`, `completeOutside_ordinaryUncovered_card_le` | proved in `OrdinaryUncoveredObstruction.lean`; completeness outside a nonsingular conic forces the ordinary uncovered locus to be an arc of cardinality at most `q+1`. Finite assertions that a particular classified locus is oversized or contains a collinear triple remain external unless separately imported |
| evaluation obstruction | `evaluationMap`; injective-evaluation and selected-functional span obstructions in `EvaluationObstruction.lean` | proved over every commutative semiring; no finite-dimensionality assumption |
| finite-field evaluation dichotomy | common-zero and distinct-hyperplane counts; `exists_ne_zero_forall_apply_ne_zero`; sharp `q+1` plane cover and equality model; `evaluation_avoidance_iff`; `evaluation_ker_le_ker_iff_mem_span`; `feature_evaluation_avoidance_iff`; `exists_outside_hyperplanes_not_mem_of_cubic_bound`; `exists_ne_zero_apply_ne_zero_not_mem_of_cubic_bound` | proved in `EvaluationDichotomy.lean` and `GoodFormAvoidance.lean`; the uniform threshold is `|A|≤q`, the rank-sensitive count is `(q-1)q^(r-2)(q+1-m)`, and at most `q-3` proper hyperplanes cannot force every remaining vector into an exceptional set of cardinality at most `3q^(r-1)` when `q≥5` and `r≥2`; identifying such an exceptional set with a conic discriminant zero locus is outside this formal claim |
| projective syndrome geometry | distance-one/two/three trichotomy; exact weight-two support count; `completeOutside_iff_distanceThreeDirections_subset`; one-column and simultaneous extension theorems; maximal extension/graph-independence bridge; leader moment and defect restatements | proved in `SyndromeGeometry.lean`; the general simultaneous object includes pair and triple conflicts, while an arc-confined extension locus reduces exactly to the pair graph |
| transparent coding bridge | `parityCheckCode`; `[n,n-3,4]` MDS parameter package; affine syndrome distance; actual-leader/support cardinality bijection through weight three; exact `choose(n,3)` weight-three leader count; covering-radius-three predicate; indexed projective arc/triple-independence equivalence | proved in `CodingBridge.lean` without an external coding API; codewords, supports, distance, and leaders are explicit finite functions; `card_syndromeLeadersOfWeight_eq_supports` makes the incidence count literally an affine coefficient-word count |
| finite examples | `Examples.rhoC_ZMod5`, `rho_points_ZMod5`, `rhoC_GF8`, `rhoC_GF9`, `rhoC_ZMod11`, `rhoC_GF16` | kernel-checked; all five values exact; the q=5 leaf is the projective four-frame transported to the standard conic, then `NonsingularConic.rho_points_eq_rhoC` transports the value to every nonsingular model |
| C637 small-odd upper witnesses | `C637WitnessData.q13Normalization_det`, `q17Normalization_det`, `q13Normalization_maps`, `q17Normalization_maps`, `q13Normalization_conicForm`, `q17Normalization_conicForm`; `C637Witnesses.q13_check`, `q17_check`, `q19_check`, `q19_ordinaryCoverage`, `q19_complete`, `rhoC_ZMod13_le_eight`, `rhoC_ZMod17_le_nine`, `rhoC_ZMod19_le_ten` | kernel-checked normalization matrices, pullback identities for the displayed conics, and rules-only upper bounds; Lean verifies the exact coordinate transports, arc, standard-conic disjointness, and relative coverage for all three lists, and ordinary completeness for the q=19 ten-arc. The exact equalities at q=13,17,19 additionally use exhaustive lower-bound classifications which are external computations and are not claimed by any Lean declaration |
| nine-point Heisenberg pair over q=19 | the eighteen terminals in `NinePointHeisenbergPair.lean` | kernel-checks two explicit nine-point projective orbits, the projective order-three matrix relations and primitive cube-root commutator, preservation of both point sets, their common cubic semi-invariant character, and one six-point conic obstruction. The assertion that this pair is the sole uncovered-arc residue, the exact order of its full stabilizer, and the 126 five-subset conic profile remain external computations |
| q=16 projective classification | `StepBook.coverage`; `StepBooksValid`; `classifiedAt_level8_of_frame`; `arbitrary_eight_arc_classification_chain`; `arbitrary_eight_arc_projectiveQuadraticAvoidance`; `rejection_profile`; `exceptional_leaf_records`; `exceptionalKernelOne/Two/Three`; `no_completeOutside_GF16_card_eight` | every legal move is represented by a certified transition into the next list, and the books cover the current parent list exactly, so the lists of lengths 4/61/454/2633 form a kernel-checked exhaustive cover. Lean checks the exact 2630+3 split, identifies the three exceptional records and their one-dimensional kernels, and proves the full singular-or-nonsingular quadratic-avoidance theorem for every abstract eight-arc, including projective transport of ordinary uncoveredness and zero sets |
| q=9 terminal game | `Q9Terminal.complete`, `legalExtensions_eq_empty`, `isP` | certified witness is an ordinary complete arc and actual terminal projective P-position |
| q=11 residual game | residual graph theorems, `continuation_rawArc_iff`, `seed_isP` | every seeded continuation is exactly an icosahedral independent set; the actual projective seed is P by localization and antipodal mirror |
| q=11 code and extension spectrum | `witness_mds_columns`, `witness_code_minimum_distance_four`, `projective_distanceThreeDirections_eq_standardConic`, `affine_distanceThree_iff_mem_standardConic`, `witness_code_coveringRadius_three`, `mem_affineSyndromesOfDistance_iff`, `affine_coset_distance_distribution`, `syndromeLeaderSupports_two_eq_raw`, `distance_two_leader_distribution`, `no_nonzero_quadratic_vanishing`, `witness_not_hasGRSQuadratic`, `witness_not_projectivelyGRS_of_implies_quadratic`, `extension_independence_spectrum`, `maximal_extension_spectrum`, `maximal_independent_extension_complete`, `completed_witness_matchings_oneFactorization` | Lean proves the `[6,3,4]₁₁` code/radius/deep-hole claims and closes the implication from the classical NRC/GRS quadratic consequence to non-GRS. The NRC/GRS dictionary itself remains the cited classical input. The affine distribution and `(900,150,100)` split range over actual syndromes and actual finite coefficient words, with a proved ray bijection and support equality. Every counted maximal extension is ordinarily complete, and the six distinct antipodal additions give a checked one-factorization. |
| quadratic global count, invisible-center bound, inverse collision balance, and q=25 pair extension | `QuadraticGlobalCount.card_globalLegalPairs_eq_legalCount`, `QuadraticInvisible.s_add_three_sub_f_sub_e_le_card_empty_through_crossPair_center`, `QuadraticInvisible.aggregate_firstOrder_equality_iff_centers_avoid_carriers_and_collisionFree`, `QuadraticInvisible.aggregate_firstOrder_excess_eq_iff_centerIncidence_add_redundancy_eq`, `Q25PairResult.f2_pair_extension`, `Q25ProfileFour.profile_four_pair_extension`, `Q25ProfileZero.profile_zero_pair_extension`, `Q25AllProfiles.pair_extension` | the semantic global finset of fresh legal Frobenius pairs is exactly the disjoint carrierwise union counted by `legalCount`; equality in the aggregate first-order count is exactly universal center/carrier avoidance plus injective local charging, and excess `k` is exactly center-incidence mass plus collision redundancy; every cross-pair orbit in an `(f,e)` profile is invisible on at least the natural-number value `s+3-f-e` empty carriers; every Frobenius-invariant eight-arc over q=25 has a fresh conjugate-pair extension, with both new points explicitly outside the old arc; `f=2` uses checked normalization and all 46,056 finite rows, while `f=0,4` are certificate-free moment/center-incidence proofs and `f=6,8` use the strict count |

The five exact arithmetic thresholds are also explicit theorems:
`L2_five = 4`, `L2_eight = 6`, `L2_nine = 6`, `L2_eleven = 6`, and
`L2_sixteen = 8`.

## Certificate contract

`Certificate.check` is a rules-only Boolean checker.  It checks:

1. every listed vector is off `XZ = Y²`;
2. every projectively distinct listed triple has nonzero determinant; and
3. every canonical projective representative `[1:y:z]`, `[0:1:z]`, or `[0:0:1]` is on the
   conic, represents a listed point, or lies on a secant of two projectively distinct listed
   points.

`check_sound` proves that acceptance implies `CompleteOutside` for the corresponding projective
point set.  The normalization proof is generic and shows that these `q²+q+1` representatives
cover every projective point.  The accepted list need not be normalized, duplicate-free, or use a
unique representative per projective point.

The checker and all concrete field laws use Lean's kernel-reduced `decide`.  No theorem uses
`native_decide` or an external evaluator.  The `q=16` proof is split into independent field-law,
arc, disjointness, and canonical-coverage leaves solely to bound build memory; the aggregate
theorem composes their checked propositions.

## Toolchain and exact replay

The checked toolchain is Lean `4.32.0-rc1` (Lake `5.0.0-src+b4812ae`), pinned by
`lean-toolchain`, with Mathlib revision
`571b8a8e54219b4d393f75f4b8653fac08197fcc` pinned by `lake-manifest.json`.
From the repository's `lean/` directory, fetch the pinned Mathlib cache and build the
paper-facing closure with:

```text
nix develop --command lake exe cache get
nix develop --command env LEAN_NUM_THREADS=1 \
  lake build RelativeConicArcs.Gates.Relconic
```

Success means exit status zero and a final Lake success report for
`RelativeConicArcs.Gates.Relconic`; the import-only gate has no runtime output.  A direct
single-thread elaboration of the gate against fetched dependencies took 26 seconds on the
development host.  For a fresh replay, allow 30 minutes, 8 GiB of RAM, and 10 GiB of free disk.
The largest generated q=16 leaves have a measured peak of approximately 1.3 GiB each; the
single-thread command above prevents concurrent leaf peaks.  These resource figures are an
execution envelope, not part of the mathematical claim.

The odd tangent-carrier algebra has a narrower import-only replay:

```text
nix develop --command env LEAN_NUM_THREADS=1 \
  lake build RelativeConicArcs.Gates.OddTangentCarrier
```

## Frozen witness provenance

Source verifier:
`papers/arcs_complete_outside_conic/verify_relative_conic_arcs.py`

SHA-256:
`e9508958d604e68c6c3d09fd3afadfaa8a3126508a51f1dfa993e7a7aed5d36a`

The q=5 four-frame is checked separately in `ExampleChecks/Q5.lean`; its displayed coordinates
are the image of the standard four-frame under an invertible matrix carrying its nonsingular
conic to the standard conic.  The remaining coordinate lists in `Examples.lean` are copied
verbatim from the general verifier:

- `q=8`: six points over `F₂[a]/(a³+a+1)`, binary polynomial-basis encoding;
- `q=9`: six points over `F₃[a]/(a²+1)`, encoding `a₀+3a₁`;
- `q=11`: six points over `ZMod 11`;
- `q=16`: nine points over `F₂[a]/(a⁴+a+1)`, binary polynomial-basis encoding.

The verifier's frozen report is:

```text
q=8  k=6 points=73  conic_points=9  secants=15 required_points=58  I_C=16 L2=6
q=9  k=6 points=91  conic_points=10 secants=15 required_points=75  I_C=13 L2=6
q=11 k=6 points=133 conic_points=12 secants=15 required_points=115 I_C=0  L2=6
q=16 k=9 points=273 conic_points=17 secants=36 required_points=247 I_C=32 L2=8
```

The Python verifier is provenance and an independent cross-check, not part of the Lean proof.

## C637 small-odd provenance and trust split

The C637 exact-value report is
`notes/2026-07-25-c637-secant-hull-coupling.md`.  Its upper-bound witnesses are represented in
`C637Witnesses.lean`.  The q=13 and q=17 lists are projective normalizations of the displayed
C637 witnesses to the standard conic; the matrices and transformed coordinates are retained in
`notes/2026-07-25-c641-conic-normalizations.json`.  The q=19 list already avoids the standard
conic.  `Certificate.check` recomputes all arc, disjointness, and relative-coverage conditions by
kernel reduction, so neither the Python normalization search nor any C637 JSON verdict is a proof
input to these upper bounds.  `q19_ordinaryCoverage` separately checks every projective point,
showing that this ten-arc is ordinary complete.

The lower bounds have a different trust status.  `OrdinaryUncoveredObstruction.lean`
kernel-checks the structural reduction: completeness outside a nonsingular conic forces the
ordinary uncovered locus to be an arc of cardinality at most `q+1`.  The assertions that every
classified seven-arc at q=13 has an uncovered collinear triple, every classified eight-arc at q=17
has more than `q+1` uncovered points, and all but one tested nine-arc extension at q=19 have an
uncovered collinear triple remain exhaustive external computations.  The exceptional q=19
extension's two nine-point orbits, projective Heisenberg relations, cubic semi-invariants, and one
six-point conic evaluation are kernel-checked in `NinePointHeisenbergPair.lean`.  Its uniqueness
among the tested extensions, full stabilizer order, and complete five-subset conic profile remain
external.  Projective-class coverage and the predicates selecting the exceptional extension have
not been imported as local Lean certificates.
Consequently Lean proves only
`rhoC (ZMod 13) ≤ 8`, `rhoC (ZMod 17) ≤ 9`, and `rhoC (ZMod 19) ≤ 10`;
the exact equalities \(8,9,10\) remain external-computation-backed results.

Replay the kernel-checked portion from `lean/` with:

```text
nix develop --command env LEAN_NUM_THREADS=1 \
  lake build RelativeConicArcs.Gates.C637Witnesses
```

## Strengthening-check provenance

The finite-field evaluation threshold and q11 structure were independently replayed by:

```text
6ed309bd2461ce9998cbd3bcaa5396379e6973b7503ce2dcdfb32c9806386566  check_evaluation_dichotomy.py
0abe909c9aadce0db4c75f296c8de25e929dd1065c906996da8dec017e534d69  check_q11_structure.py
1753674172d48f1d056d350e30baa9eb67de0810c84a96da0440947768ae041c  check_q11_structure.cpp
```

The Python and separately written C++ q11 programs agree on projective directions, syndrome
distances, leader multiplicities, chord classes, and group-action data. Coordinate transformation
and relabelling preserve every invariant. A one-point witness perturbation changes the extension
count from 12 to 20 and the stabilizer size from 60 to 2; a mutated generator is rejected. Frozen
2026-07-13 output hashes are:

```text
88be03eb8a81bb906083457a4b4201cfd1ef6bcaa9de01928175840f61ac55ff  evaluation output
b096305a809b062c274129c157d51a57d65e9aec0e44662370ec53c8c773110f  q11 Python output
380cab47923cbfb3a9bfcc54ee89cf0eb79aa551d936d2e91cbb4949ae56477d  q11 C++ output
```

The exact replay protocol on the development host was:

```text
python3 check_evaluation_dichotomy.py > /var/tmp/arcs-evaluation.out
python3 check_q11_structure.py > /var/tmp/arcs-q11-python.out
g++ -std=c++20 -O2 check_q11_structure.cpp -o /var/tmp/check_q11_structure
/var/tmp/check_q11_structure > /var/tmp/arcs-q11-cpp.out
sha256sum /var/tmp/arcs-evaluation.out /var/tmp/arcs-q11-python.out /var/tmp/arcs-q11-cpp.out
```

The compiler was `g++ (GCC) 14.3.0`; `/var/tmp` is used because `/tmp` is tmpfs on this host.
These programs are adversarial provenance only. The mathematical q11 claims used in the
manuscript's proposition have corresponding Lean theorems, but the checkers' auxiliary
group-generation, orbit-label, coordinate-invariance, and mutation diagnostics are not all
separate Lean declarations and are not inputs to the proof.

## Exact q=16 classification provenance

Source generator:
`papers/arcs_complete_outside_conic/search_rhoc16.cpp`

SHA-256:
`589af8430e94b4c9c23ce895e6d32d2b3b5b9b387b1fb23ed6d3875cdee39031`

Frozen report:
`papers/arcs_complete_outside_conic/search_rhoc16_output.txt`

SHA-256:
`6989079b5cb64b0e57d5c42b872093fff99f861300b8fbb909daef450c15cc63`

The nine-line frozen report is a generation summary, not the transition or leaf certificate.
The generator enumerates all projective caps extending the standard four-frame and emits four
layers of locally checked transitions.  Each row contains an explicit invertible matrix and a
source/target/scalar equality for every selected point; lightweight `StepBook` modules reference
those semantic row theorems and separately check that their moves cover every legal extension.
The Lean soundness theorem therefore does not trust the generator's canonical labels or its
coverage assertions.  The kernel-checked exhaustive covering lists at sizes five through eight
have lengths `4, 61, 454, 2633`; the certificate does not require pairwise inequivalence or
deduplication.  The final ordinary eight-arc class count was already reported by
Al-Seraji--Al-Ogali (2018), and the matching list length is an external consistency check.

For every eight-leaf, the generated rejection records ordinary-uncovered points.  In 2630 leaves,
six quadratic evaluation rows have an explicitly checked inverse.  In the remaining three leaves,
an explicitly checked linear combination forces any conic equation through the uncovered locus to
vanish at a selected point. `Q16Profile.lean` checks the exact 2630+3 split, while
`Q16ExceptionalArithmetic.lean` identifies the actual three forced-hit records and proves that
their evaluation kernels are precisely the three displayed coefficient lines, in addition to the
factorizations, hit counts `(2,7,2)`, and middle nonsingular model.
`Q16QuadraticTransport.lean` proves the end-to-end arbitrary-eight-arc quadratic-avoidance theorem,
including projective invariance of ordinary uncoveredness and quadratic zero sets. The C++ program and report are reproducible
provenance only; the theorem depends on the emitted data through kernel-checked local predicates.

## Ten-point matching-design realization provenance

The manuscript's rank-three classification of the two
`MATCH(10,5,1)` designs is supported by the paper-local bundle:

```text
papers/arcs_complete_outside_conic/check_match10_rank_three.py
papers/arcs_complete_outside_conic/check_match10_rank_three.json
papers/arcs_complete_outside_conic/check_match10_rank_three.sha256
```

The generator canonically reconstructs representatives of the two published
abstract classes through the Reichard--Woldar overlarge-`S(3,4,8)` model,
checks their matching-design axioms and automorphism orders, and forms the
189 normalized projective concurrency equations for each class.  Singular
4.4.1 computes two monomial-order certificates in characteristics 2 and 37
and exact rational module lifts whose only denominator prime is 2.  The JSON
also records the triangular characteristic-two basis for the regular-hyperoval
class and an independent direct `GF(8)` incidence construction with an exact
transporter.  The same finite-field checker records the regular hyperoval
and the nonsingular conic
`X²+Y²+Z²+3YZ=0`, verifies that their point sets are disjoint, and checks
the conic's nine points and nonvanishing gradient.

Four vertices are normalized to `(1,0,0)`, `(0,1,0)`, `(0,0,1)`, and
`(1,1,1)`; the remaining vertices are `(xi,yi,1)`.  Every arc realization
has `x9 ≠ 0` and `x9 ≠ 1`, since these are the determinants of the triples
formed by vertices `(1,2,9)` and `(1,3,9)`.  The Singular ideals are
saturated by `x9*(x9-1)`.  This is deliberately only a necessary open
condition, not a replacement for all arc inequations: proving the relaxed
saturated ideal is the unit ideal is sufficient to exclude the smaller
arc-realization locus.  The characteristic-two regular-hyperoval converse
is checked separately by the direct `GF(8)` arc and incidence construction.

Replay from the paper directory:

```text
nix shell nixpkgs#singular --command \
  python3 check_match10_rank_three.py --check
sha256sum -c check_match10_rank_three.sha256
```

The script is 23,229 bytes with SHA-256
`700ab7ba7a7606249448d8e6569f4638bee3c4b1354da80334cff49cd3613ed5`;
the 79,326-byte JSON certificate has SHA-256
`c2c3619a1c074bd28a9e0b967a4ac1762496589ede0cc636431f484d67fba357`.
Exact Python integer/finite-field arithmetic and Singular Gröbner bases and
module lifts remain trusted executions.  The second monomial order and direct
`GF(8)` incidence construction are independent checks.  Abstract completeness
is Mathon's published two-class theorem.  Alspach and Heinrich, “Matching
Designs,” *Australasian Journal of Combinatorics* 2 (1990), 39--55, define
`MATCH(n,k,λ)` designs on pp. 39--40 and record there that Mathon proved
precisely two nonisomorphic `MATCH(10,5,1)` designs.  Their definition allows
repeated matchings, but `λ=1` makes repetition impossible.  Reichard and
Woldar, “Constructing partial geometries from overlarge sets of Steiner
systems,” *Beiträge zur Algebra und Geometrie* 63 (2022),
doi:10.1007/s13366-021-00570-7, Section 6, identify Mathon's result as the
full classification of `pg(5,7,3)` and construct both classes in
Proposition 5.1.5 and Corollary 5.1.6.  The paper-local enumeration
reconstructs and checks representatives of those two external classes; it
does not certify abstract completeness.  No Lean theorem consumes this
certificate.

## Axiom audit

`#print axioms` for the cap-game localization and parametrized-value bridges, the ordinary
coverage checker, `Certificate.check_sound`,
`rhoC_le_length_of_check`, the complete-affine specialization and equality criterion, all five
`L2` theorems, all five final finite-example theorems, the
q=16 eight-arc nonexistence, profile, exceptional-arithmetic, arbitrary-classification-chain, and
quadratic-pullback theorems, the q=9 terminal P theorem, q=11 residual and actual
seeded P theorems, the q11 MDS/radius/deep-hole/leader/extension/chord theorems, and the public
q=13,17,19 upper-witness checks, upper bounds, and q=19 ordinary-completeness theorem, the public
syndrome/coding bridges, together with the public finite-field evaluation-dichotomy, quantitative-count,
sharp-cover, equality-model, kernel/span, and feature-closure theorems, as well as the exact
uncovered-locus reconstruction, matching-rigidity, bad-edge, secant-deletion, and four-group
unique-fixed-point congruence terminals
reports exactly:

```text
[propext, Classical.choice, Quot.sound]
```

These are the accepted Mathlib foundations used throughout the projective quotient development.
There is no `sorryAx`, custom axiom, `admit`, or `native_decide` dependency.

## Explicit external boundary

The only deep asymptotic estimate intentionally not reproved is the Kim--Vu complete-arc bound.
It is represented by the named hypothesis `KimVuBound`, appears in theorem signatures rather than
as a global axiom, and is not used by the five finite-example results. The q=11 projectively-GRS
interpretation separately uses the cited classical normal-rational-curve/GRS dictionary; Lean
checks the complete algebraic implication after that dictionary. The cited ordinary q=16 class
count is only an external consistency check and is not a proof input.

The paper's six-point matching-design realization calculation and cited seven-point
nonrealizability result are not represented as a field-linear realization classification in Lean.
The C637 lower-bound classifications at q=13,17,19 are likewise external: Lean checks the
attaining witnesses but does not prove the three exact equalities.
Likewise, the Beyond-4, Clebsch rigidity/factorization, and AME-LU references attached to the
coding/design comparisons are contextual citations, not formal proof inputs; the underlying
parity-check-code parameters, syndrome-distance dictionary, and matching decomposition are the
separately listed checked bridges.
