//! Rust-native exact recovery kernels.
//!
//! The crate is organized around compact state representations and replayable
//! arena witnesses.  It intentionally does not mirror the Python module tree.

pub mod applications;
mod arena;
pub mod automata;
pub mod balanced;
pub mod bitset;
pub mod composition;
pub mod confinement;
pub mod contextual;
pub mod css_distance;
pub mod defect;
pub mod family_response;
pub mod field;
pub mod group_action;
pub mod incidence;
pub mod interface;
pub mod matrix;
pub mod observational;
pub mod orbit;
pub mod orbit_compile;
pub mod ordered_resource;
pub mod packed_ternary;
pub mod projective;
pub mod provenance;
pub mod sat;
pub mod scheduler;
pub mod selector;
pub mod semantic_symmetry;
pub mod span;
pub mod transfer;
pub mod witness;
mod zdd;

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
pub use css_distance::{
    BoundedCssDistanceResult, CompiledCssDistance, ConnectedSearchStats, CssDistanceError,
};
pub use family_response::{
    compile_minima_family_responses, FamilyResponseDictionary, FamilyResponseError,
    FamilyResponseTable,
};
pub use field::{FieldError, FiniteField, Gf4, Prime};
pub use group_action::{
    compile_binary_gl_rref, compile_permutation_orbits,
    compile_permutation_orbits_with_deferred_verification, quotient_presentation_by_binary_gl_rref,
    quotient_presentation_by_orbits, verify_binary_gl_rref, verify_permutation_orbits,
    BinaryGlPresentationError, BinaryGlProbeAction, BinaryGlProbeError, BinaryGlRrefQuotient,
    BinaryRightLinearMap, FinitePermutationAction, OrbitCompileError, OrbitPartition,
    OrbitQuotientError, OrbitStorage,
};
pub use interface::{
    lift_class_witnesses, present_finite_interface, present_witnessed_pareto_interface,
    FiniteInterfaceAdapter, FiniteInterfaceWitness, InterfaceCompileError, ParetoInterfaceError,
    VerifiedParetoWitnesses, WitnessedParetoPresentation,
};
pub use matrix::{Matrix, MatrixError};
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
    ParetoWorkspace, WitnessedParetoFront, WitnessedParetoWorkspace,
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
pub use span::{CanonicalTargetImage, GeneratedSpanTable, SpanAnswer, SpanError};
pub use transfer::{
    compile_binary_inner_dual, compile_binary_rank_one, compile_binary_target_subspace,
    BinaryRankOneProfile, BinaryTargetProfile, CoefficientWitness, MatrixCoefficientWitness,
    TransferError,
};
