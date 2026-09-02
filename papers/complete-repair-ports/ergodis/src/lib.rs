//! Rust-native exact recovery kernels.
//!
//! The crate is organized around compact state representations and replayable
//! arena witnesses.  It intentionally does not mirror the Python module tree.

// `is_multiple_of` is newer than the crate's Rust 1.87 MSRV. Keep the
// equivalent remainder form until the MSRV advances.
#![allow(clippy::manual_is_multiple_of)]

pub mod alignment;
pub mod applications;
mod arena;
pub mod automata;
pub mod balanced;
pub mod binary_kernel_search;
pub mod bitset;
pub mod bounded_subset_sum;
pub mod bp_osd;
pub mod character_sum;
pub mod coherent_closure;
pub mod commutant;
pub mod composition;
pub mod confinement;
pub mod contextual;
pub mod continuation;
#[cfg(feature = "control-plane")]
pub mod control;
pub mod css_distance;
pub mod cyclic_action;
pub mod defect;
pub mod family_response;
pub mod feature_dag;
pub mod fibre;
pub mod field;
pub mod frozen_shortest_path;
pub mod graph_obstruction;
pub mod group_action;
pub mod group_aggregation;
pub mod group_histogram;
pub mod hall;
pub mod incidence;
pub mod integer_moments;
pub mod interface;
pub mod linear_code;
pub mod matrix;
pub mod modular_power;
pub mod multiset;
pub mod observational;
pub mod orbit;
pub mod orbit_compile;
pub mod ordered_resource;
pub mod packed_ternary;
pub mod parametric_certificate;
pub mod prime_polynomial;
pub mod projective;
pub mod provenance;
pub mod quadratic_window;
pub mod query_design;
pub mod residual_hitting;
pub mod root_execution;
pub mod rpc;
pub mod sat;
pub mod scheduler;
pub mod selector;
pub mod semantic_symmetry;
pub mod span;
pub mod structured_integer_set;
pub mod theorem_search;
pub mod transfer;
pub mod witness;
mod zdd;

#[cfg(test)]
mod test_alloc;

#[cfg(feature = "control-plane")]
pub use alignment::search_alignment_attachment_controlled;
pub use alignment::{
    compile_alignment_attachment, search_alignment_attachment, search_alignment_attachment_from,
    AlignmentAttachment, AlignmentBranchFeatures, AlignmentError, AlignmentFractionalContext,
    AlignmentSearchControl, AlignmentSearchMetrics, AlignmentSearchPoint, AlignmentSearchWorkspace,
};
pub use applications::{
    azure_lrc_12_2_2_counted, azure_lrc_12_2_2_upgrade_domains, ceph_xor_repair_family,
    ceph_xor_repair_supports, ceph_xor_repair_supports_compressed, gpu_checkpoint_mds_recovery,
    gpu_checkpoint_mds_same_rack_recovery, minimum_node_span_repair, parse_ceph_xor_layers,
    schedule_repair_dag, ApplicationError, AzureLrcBatchAnswer, CephAggregatedRepairOption,
    CephAggregatedRepairProblem, CephCompressedRepairAnswer, CephCompressedRepairFamily,
    CephReliabilityPolynomial, CephRepairAnswer, CephXorLayer, GpuCheckpointBatchAnswer,
    GpuCheckpointCapacities, NodeSpanRepairAnswer, QcLdpcCode, QcSearchResult, QcTrappingSetAnswer,
    RepairDagAnswer, RepairTask,
};
pub use automata::{ExplicitMataDfa, ExplicitMataError};
pub use binary_kernel_search::{
    BinaryKernelSearchError, BinaryKernelSearchSummary, BinaryKernelSearchWorkspace,
    BinaryKernelTrialOptions, CompiledBinaryKernelSearch,
};
pub use bounded_subset_sum::{
    BoundedSubsetSumBounds, BoundedSubsetSumCertificate, BoundedSubsetSumError,
    BoundedSubsetSumPlan, BoundedSubsetSumSnapshot, BoundedSubsetSumWorkspace,
    BOUNDED_SUBSET_SUM_SNAPSHOT_VERSION, MAX_SUBSET_SUM_ITEMS, MAX_SUBSET_SUM_REACHABILITY_WORDS,
    MAX_SUBSET_SUM_TRANSITIONS, MAX_SUBSET_SUM_WIDTH,
};
pub use character_sum::{
    CharacterCensus, CharacterSumError, CyclotomicCensus, PolynomialDegeneracy,
    PrimeMultiplicativeCharacter, PrimeQuadraticCharacter, RootOfUnityCensus,
};
pub use coherent_closure::{
    compile_coherent_closure, verify_coherent_closure, CoherentClosure, CoherentClosureError,
    MAX_COHERENT_ORDER,
};
pub use commutant::{
    binary_commutant_workspace_upper_bound, certify_binary_extension_field,
    certify_binary_extension_field_exhaustive, compile_binary_commutant,
    compile_binary_css_logical_action, compile_binary_quotient_action,
    compile_binary_subspace_action, verify_binary_commutant, verify_binary_css_logical_action,
    verify_binary_extension_field, verify_binary_invariant_split, verify_binary_quotient_action,
    verify_binary_subspace_action, BinaryCommutant, BinaryCommutantError, BinaryExtensionField,
    BinaryExtensionFieldSearch, BinaryInvariantSplit, PackedBinaryAction, PackedBinaryLinearMap,
    PackedBinarySubspace,
};
pub use composition::{
    CompositionAnswer, CompositionError, CompositionTable, CompositionTower, CostTable,
    TowerAnswer, TowerLevel, TowerWitness,
};
pub use confinement::{
    certify_rank_one_transfer_by_generators, certify_rank_one_transfer_by_generators_field,
    confinement_by_generators, confinement_by_generators_field, confinement_by_syndrome,
    ConfinementAnswer, ConfinementError, ConfinementSector, RankOneTransferCertificate,
};
pub use contextual::{
    CanonicalContextBasis, ContextCost, ContextExecution, ContextPlan, ContextStrategy,
    ContextWork, ContextualError, FrozenRankStratifiedEnvelope, PlannedContextCost,
    RankBoundedContextCache, RankEnvelopeAnswer, RankEnvelopeStorage, RankOneProbeCache,
    RankStratifiedEnvelope,
};
pub use continuation::{
    compile_continuation_hierarchy, ContinuationHierarchy, ContinuationHierarchyError,
    ContinuationLevel,
};
pub use css_distance::{
    css_search_semantics_blake3, verify_css_anchor_transversal, verify_css_coordinate_equivalence,
    BoundedCssDistanceResult, CompiledCssDistance, CompiledExtraWideCssDistance,
    CompiledWideCssDistance, ConnectedSearchStats, CssAnchorOrbitCertificate, CssAnchorOrbitError,
    CssCoordinateEquivalenceCertificate, CssCoordinateEquivalenceError, CssDistanceArtifactError,
    CssDistanceError, CssSearchSemanticsError, CssSearchShard, CssShardFrontierCommitment,
};
#[cfg(feature = "large-css")]
pub use css_distance::{
    CompiledColossalCssDistance, CompiledHugeCssDistance, CompiledLargeCssDistance,
};
pub use cyclic_action::{CyclicOrbitLockError, CyclicOrbitLocks};
pub use family_response::{
    compile_minima_family_responses, FamilyResponseDictionary, FamilyResponseError,
    FamilyResponseTable,
};
pub use feature_dag::{
    ConflictFeatureExpansion, DiagnosticFeatureDagBundle, DiagnosticFeatureDagBundleError,
    FeatureBankBounds, FeatureBankError, FeatureDag, FeatureDagError, FeatureDagSnapshot,
    FeatureId, FeatureNode, FeatureOp, FeaturePredicateCensus, FeaturePresentationBinding,
    FeaturePresentationTransition, FeaturePresentationTransitionError, FeatureScopeBank,
    FeatureWorkspace, FeatureZeroBank, FeatureZeroClassMember, FeatureZeroConjunction,
    FeatureZeroQuotient, RawFeatureExpansion, DIAGNOSTIC_FEATURE_DAG_BUNDLE_VERSION,
    FEATURE_DAG_SNAPSHOT_VERSION, FEATURE_PRESENTATION_TRANSITION_VERSION,
    MAX_FEATURE_PRESENTATION_CELLS, MAX_FEATURE_PRESENTATION_ROWS,
};
pub use fibre::{
    compile_dense_fibres, verify_dense_fibres, DenseFibreBounds, DenseFibreError, DenseFibreIndex,
    ExhaustiveFibre, FibreRepresentative,
};
pub use field::{
    BinaryElement, BinarySmallField, FieldElement, FieldError, FieldPresentation, FiniteField, Gf4,
    Prime, SmallField,
};
pub use frozen_shortest_path::{
    FrozenShortestPathError, FrozenShortestPathMetrics, FrozenShortestPathPlan,
    FrozenShortestPathResult, FrozenShortestPathWorkspace, ValidatedFrozenShortestPathObjective,
    ABSENT_SHORTEST_PATH_COST,
};
pub use graph_obstruction::{cluster_graph_census, ClusterGraphCensus, GraphObstructionError};
pub use group_action::{
    compile_binary_gl_rref, compile_generator_closure, compile_permutation_orbits,
    compile_permutation_orbits_with_deferred_verification, quotient_presentation_by_binary_gl_rref,
    quotient_presentation_by_orbits, verify_binary_gl_rref, verify_permutation_orbits,
    BinaryGlPresentationError, BinaryGlProbeAction, BinaryGlProbeError, BinaryGlRrefQuotient,
    BinaryRightLinearMap, ExplicitPermutationAction, ExplicitPermutationError,
    FinitePermutationAction, GeneratorClosure, GeneratorClosureWorkspace, OrbitCompileError,
    OrbitPartition, OrbitQuotientError, OrbitStorage,
};
pub use group_aggregation::{
    propose_equal_marginal_scopes, GroupAggregateOp, GroupAggregateSpec, GroupAggregationBounds,
    GroupAggregationError, GroupAggregationPlan, GroupAggregationPlanSnapshot,
    GroupAggregationProposalBounds, GroupScopeProposalBounds, GROUP_AGGREGATION_SNAPSHOT_VERSION,
    MAX_AGGREGATION_GROUPS, MAX_AGGREGATION_INPUTS, MAX_AGGREGATION_MEMBERS,
    MAX_AGGREGATION_OUTPUTS, MAX_AGGREGATION_PROPOSAL_CELLS, MAX_AGGREGATION_PROPOSAL_ROWS,
    MAX_AGGREGATION_PROPOSED_VALUES,
};
pub use group_histogram::{
    GroupHistogramBounds, GroupHistogramCertificate, GroupHistogramError, GroupHistogramPlan,
    GroupHistogramSnapshot, GroupHistogramSummary, GROUP_HISTOGRAM_SNAPSHOT_VERSION,
    MAX_GROUP_HISTOGRAM_INPUTS, MAX_GROUP_HISTOGRAM_MEMBERS, MAX_GROUP_HISTOGRAM_VALUES,
};
pub use hall::{
    solve_hall, verify_hall_certificate, verify_hall_result, DenseHallGraph, HallError,
    HallReplayError, HallResult, HallWorkspace,
};
pub use integer_moments::{
    enumerate_integer_moments, seidel_integer_spectrum_is_type2, IntegerMomentError,
    IntegerMomentMetrics, IntegerMomentProblem, IntegerMomentWorkspace,
};
pub use interface::{
    lift_class_witnesses, present_finite_interface, present_witnessed_pareto_interface,
    FiniteInterfaceAdapter, FiniteInterfaceWitness, InterfaceCompileError, ParetoInterfaceError,
    VerifiedParetoWitnesses, WitnessedParetoPresentation,
};
pub use linear_code::{
    BinaryLinearAlgorithm, BinaryLinearCodeError, BinaryLinearCodeWorkspace,
    BinaryLinearWeightResult, BinaryLinearWeightSummary, CompiledBinaryLinearCode,
};
pub use matrix::{Matrix, MatrixError};
pub use modular_power::{
    certify_integer_matrix_powers, verify_integer_matrix_powers, ModularPowerCertificate,
    ModularPowerError,
};
pub use multiset::{
    compile_bounded_multiset_aggregates, MultisetAggregateError, MultisetAggregateTable,
    MultisetBounds, MultisetStatistic,
};
#[doc(hidden)]
pub use orbit::ternary_orbit_syndrome_meet_in_middle_unreserved;
pub use orbit::{
    ternary_orbit_syndrome_meet_in_middle, ternary_orbit_syndrome_meet_in_middle_count_split,
    ternary_orbit_syndrome_search, ternary_orbit_syndrome_search_correlated, OrbitError,
    OrbitMeetResult, OrbitOption, OrbitSyndromeResult,
};
pub use orbit_compile::{
    compile_integer_affine_constraints, compile_ternary_affine_constraints,
    IntegerAffineCompilation, IntegerAffineProblem, IntegerLatticeObstruction,
    TernaryAffineCompilation, TernaryAffineObstruction, TernaryAffineProblem,
};
pub use ordered_resource::{
    evaluate_frozen_pareto_dag, validate_finite_ordered_monoid, CappedAdditiveMonoid,
    FiniteOrderedMonoid, FrozenParetoError, FrozenParetoEvaluationMetrics, FrozenParetoPlan,
    FrozenParetoQueryPlan, OrderedMonoidCertificate, OrderedResourceError, ParetoFront,
    ParetoObservationTable, ParetoResponseDictionary, ParetoWitness, ParetoWitnessError,
    ParetoWorkspace, ValidatedParetoObjective, ValidatedTransitionParetoObjective,
    WitnessedParetoFront, WitnessedParetoWorkspace,
};
pub use parametric_certificate::{
    verify_parametric_certificate, verify_payload, ParametricCertificate,
    ParametricCertificateError, ParametricCompositionDag, ParametricCompositionNode,
    ParametricCover, ParametricFamily, ParametricVerificationLimits, PayloadDigest,
    PayloadDigestAlgorithm, PolynomialOp, PolynomialProgram, VerifiedParametricCertificate,
};
pub use prime_polynomial::{
    reduce_prime_polynomial_function, PrimePolynomialError, PrimePolynomialRecurrence,
};
pub use quadratic_window::concave_quadratic_window;
pub use query_design::{
    compile_greedy_adaptive_queries, compile_greedy_nonadaptive_queries,
    pair_query_nonadaptive_lower_bound, verify_adaptive_queries, verify_nonadaptive_queries,
    AdaptiveQueryCertificate, AdaptiveQueryMetrics, AdaptiveQueryNode, NonadaptiveQueryCertificate,
    QueryDesignError,
};
pub use residual_hitting::{
    verify_residual_hitting_refutation, ResidualHittingError, ResidualHittingWorkspace,
};
pub use scheduler::{
    maximum_parallel_repairs, CapacityCut, ParallelRepairResult, PositiveGradingCertificate,
    RepairSupportChoice, SchedulerError, WeightedParallelRepairResult, WeightedRepairProblem,
    WeightedRepairWorkspace, WeightedSchedulerBackend,
};
pub use selector::{
    CompiledSelector, CompiledSelectorWorkspace, DenseSelector, DenseSelectorWorkspace,
    SelectorAnswer, SelectorBackend, SelectorError, SelectorRunError, SelectorStep,
    SelectorStrategy, SparseSelector, SparseSelectorWorkspace,
};
pub use semantic_symmetry::{
    compile_nonempty_support_orbit_cover, compile_verified_explicit_binary_support,
    verify_explicit_binary_support_invariance, verify_nonempty_support_orbit_cover,
    AnchoredBackendResult, AnchoredBackendResultError, AnchoredBinarySupportOptimum,
    AnchoredModelWriteError, AnchoredSupportSubproblem, BinarySupportCandidate,
    ExplicitBinarySupportError, ExplicitBinarySupportProblem, ExplicitSupportSymmetryError,
    NonemptySupportOrbitCover, SemanticModelFingerprint, VerifiedExplicitBinarySupportProblem,
};
pub use span::{
    CanonicalTargetImage, GeneratedSpanTable, SpanAnswer, SpanBuildLimits, SpanError, SpanResource,
    DEFAULT_SPAN_BUILD_LIMITS,
};
pub use theorem_search::{
    assemble_sound_decision_list, drive_ranked_evolution_streaming, evolve_implications,
    evolve_implications_streaming, evolve_ranked_streaming, probe_structural_separability,
    select_quality_diversity_parents, CandidateTrial, CensusReduction, CensusReductionError,
    DecisionListConfig, DecisionListError, DecisionListRule, DiagnosticTheoremArchiveBinding,
    DiagnosticTheoremArchiveSnapshot, DiagnosticTheoremPointSnapshot, EvolutionConfig,
    EvolutionError, EvolutionResult, EvolutionRunError, EvolutionSelectionPhase, EvolutionSummary,
    FailureCore, FailureCoreAdmission, FailureCoreBank, FailureCoreKind, ImplicationScore,
    QualityDiversityError, QualityDiversitySchedule, RankedCandidateTrial, RankedEvolutionDriver,
    RankedEvolutionRunError, RankedEvolutionSummary, ReplayRowCount, SeparabilityBounds,
    SeparabilityError, SeparabilityReport, SeparatingReplayCore, SeparatingReplayCoreError,
    SeparatingReplayCoreSnapshot, SoundDecisionList, SoundTheoremArchive, SoundTheoremPoint,
    TheoremArchiveAdmission, TheoremArchiveError, DIAGNOSTIC_THEOREM_ARCHIVE_SNAPSHOT_VERSION,
    MAX_DIAGNOSTIC_THEOREM_ARCHIVE_POINTS, SEPARATING_REPLAY_CORE_SNAPSHOT_VERSION,
};
pub use transfer::{
    compile_binary_inner_dual, compile_binary_rank_one, compile_binary_target_subspace,
    BinaryRankOneProfile, BinaryTargetProfile, CoefficientWitness, MatrixCoefficientWitness,
    TransferError,
};
