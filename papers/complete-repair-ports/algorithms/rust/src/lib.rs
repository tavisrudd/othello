//! Rust-native exact recovery kernels.
//!
//! The crate is organized around compact state representations and replayable
//! arena witnesses.  It intentionally does not mirror the Python module tree.

pub mod applications;
mod arena;
pub mod balanced;
pub mod bitset;
pub mod composition;
pub mod confinement;
pub mod defect;
pub mod field;
pub mod incidence;
pub mod matrix;
pub mod orbit;
pub mod orbit_compile;
pub mod packed_ternary;
pub mod projective;
pub mod scheduler;
pub mod span;
pub mod transfer;
pub mod witness;

pub use applications::{
    azure_lrc_12_2_2_upgrade_domains, ceph_xor_repair_supports, gpu_checkpoint_mds_recovery,
    minimum_node_span_repair, schedule_repair_dag, ApplicationError, CephRepairAnswer,
    CephXorLayer, NodeSpanRepairAnswer, QcLdpcCode, QcTrappingSetAnswer, RepairDagAnswer,
    RepairTask,
};
pub use composition::{
    CompositionAnswer, CompositionError, CompositionTable, CompositionTower, CostTable,
    TowerAnswer, TowerLevel, TowerWitness,
};
pub use confinement::{
    confinement_by_generators, confinement_by_generators_field, confinement_by_syndrome,
    ConfinementAnswer, ConfinementError, ConfinementSector,
};
pub use field::{FieldError, FiniteField, Gf4, Prime};
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
pub use scheduler::{
    maximum_parallel_repairs, CapacityCut, ParallelRepairResult, PositiveGradingCertificate,
    RepairSupportChoice, SchedulerError, WeightedParallelRepairResult, WeightedRepairProblem,
    WeightedRepairWorkspace, WeightedSchedulerBackend,
};
pub use span::{GeneratedSpanTable, SpanAnswer, SpanError};
pub use transfer::{
    compile_binary_inner_dual, compile_binary_rank_one, compile_binary_target_subspace,
    BinaryRankOneProfile, BinaryTargetProfile, CoefficientWitness, MatrixCoefficientWitness,
    TransferError,
};
