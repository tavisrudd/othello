//! Sparse q0 scout for the private g133 order-2092 multiplier shard.
//!
//! The Z18 projection has ten residue-orbit slots.  Every slot has one
//! scale-one family and seven scale-four families, hence `B=e+4k` with binary
//! `e` and `0<=k<=7`.  Relative to the minimum signed magnitude three, q0 has
//! exact defect budget 83.  This module compiles all mod-four roots and tests
//! their exact row/q0 lifts with bounded iterative kernels.

use serde::Serialize;
use sha2::{Digest, Sha256};
use thiserror::Error;

use crate::bitset_sumset::{bitset_256_contains, xor_sumset_256_into};
use crate::hadamard_2092::CyclicMultiplierOrbitPartition;
use crate::two_adic_autocorrelation::lift_autocorrelation;

const CARRIER: usize = 522;
const QUOTIENT: usize = 18;
const SLOTS: usize = 10;
const SHIFTS: usize = 10;
const MODULUS: u8 = 4;
const DEFECT_TARGET: usize = 83;
const Q1_LIMIT: usize = 8_192;
const MAX_Q2_PROFILES_PER_DOMAIN: usize = 1 << 17;
const MAX_COARSE_HASH_SLOTS: usize = 1 << 27;
const COARSE_HASH_DISCOVERY_SLOTS: usize = 1 << 20;
const MAX_FILTERED_JOINT_PAIRS: usize = 1 << 24;
const MAX_LIFT_PROFILES_PER_DOMAIN: usize = 1 << 17;
const MAX_TOTAL_Q2_PROFILES: u64 = 70_000_000;
const MAX_Q1_PROFILES_PER_DOMAIN: usize = 4_096;
const MAX_PAIR_PROFILES: usize = 4_096;
const ROOT_FILTER_WORDS: usize = 1 << 19;
const POWERS: [u32; SLOTS] = [
    1,
    8,
    64,
    512,
    4_096,
    32_768,
    262_144,
    2_097_152,
    16_777_216,
    134_217_728,
];
const SLOT_RESIDUES: [&[usize]; SLOTS] = [
    &[0],
    &[3],
    &[6],
    &[9],
    &[12],
    &[15],
    &[1, 7, 13],
    &[2, 8, 14],
    &[4, 10, 16],
    &[5, 11, 17],
];

#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
struct BinaryProfile {
    signature: u32,
    mask: u16,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
struct BinaryPair {
    signature: u32,
    first: u16,
    second: u16,
}

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct Q1Profile {
    q1: u16,
    energy: u8,
    reserved: u8,
    digits: u32,
}

const _: () =
    assert!(std::mem::size_of::<Q1Profile>() == 8 && std::mem::align_of::<Q1Profile>() == 4);

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct Q1PairProfile {
    q1: u16,
    first: u16,
    second: u16,
    energy: u8,
    reserved: [u8; 9],
}

const _: () = assert!(
    std::mem::size_of::<Q1PairProfile>() == 16 && std::mem::align_of::<Q1PairProfile>() == 2
);

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct Q2Profile {
    state: u64,
    digits: u32,
    reserved: u32,
}

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
struct JointShiftProfile {
    state: u64,
    digits: u32,
    reserved: u32,
}

const _: () = assert!(
    std::mem::size_of::<JointShiftProfile>() == 16
        && std::mem::align_of::<JointShiftProfile>() == 8
);

const _: () =
    assert!(std::mem::size_of::<Q2Profile>() == 16 && std::mem::align_of::<Q2Profile>() == 8);

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct Q2ResidueProfile {
    residues: u64,
    q1: u16,
    minimum: u16,
    maximum: u16,
    energy: u8,
    reserved: u8,
}

const _: () = assert!(
    std::mem::size_of::<Q2ResidueProfile>() == 16 && std::mem::align_of::<Q2ResidueProfile>() == 8
);

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct Q2PairResidueProfile {
    residues: u64,
    q1: u16,
    minimum: u16,
    maximum: u16,
    energy: u8,
    reserved: u8,
}

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
struct LiftProfile {
    state: u64,
    digits: u32,
    reserved: u32,
}

const _: () =
    assert!(std::mem::size_of::<LiftProfile>() == 16 && std::mem::align_of::<LiftProfile>() == 8);

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct LiftKeyProfile {
    signatures: [u64; 4],
    q1: u16,
    energy: u8,
    reserved: [u8; 5],
}

const _: () = assert!(
    std::mem::size_of::<LiftKeyProfile>() == 40 && std::mem::align_of::<LiftKeyProfile>() == 8
);

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct LiftPairProfile {
    signatures: [u64; 4],
    q1: u16,
    energy: u8,
    reserved: [u8; 5],
}

#[repr(C)]
#[derive(Clone, Debug, PartialEq, Eq)]
struct Mod16DenseKey {
    fibres: [[u64; 4]; 256],
    q1: u16,
    energy: u8,
    reserved: [u8; 5],
}

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct Mod16SparsePairKey {
    offset: u32,
    q1: u16,
    energy: u8,
    len: u8,
}

const _: () = assert!(
    std::mem::size_of::<Mod16SparsePairKey>() == 8
        && std::mem::align_of::<Mod16SparsePairKey>() == 4
);

#[derive(Clone, Debug, PartialEq, Eq)]
struct Mod16SparsePairDomain {
    keys: Box<[Mod16SparsePairKey]>,
    signatures: Box<[u16]>,
}

#[repr(C)]
#[derive(Clone, Debug, PartialEq, Eq)]
struct Q2DenseKey {
    values: [u64; 256],
    q1: u16,
    energy: u8,
    reserved: [u8; 5],
}

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct ScalarSparsePairKey {
    residues: u64,
    offset: u32,
    q1: u16,
    minimum: u16,
    maximum: u16,
    holes_len: u16,
    exact_len: u16,
    energy: u8,
    reserved: [u8; 7],
}

const _: () = assert!(
    std::mem::size_of::<ScalarSparsePairKey>() == 32
        && std::mem::align_of::<ScalarSparsePairKey>() == 8
);

#[derive(Clone, Debug, PartialEq, Eq)]
struct ScalarSparsePairDomain {
    keys: Box<[ScalarSparsePairKey]>,
    holes: Box<[u16]>,
}

const _: () =
    assert!(std::mem::size_of::<Q2DenseKey>() == 2_056 && std::mem::align_of::<Q2DenseKey>() == 8);

const _: () = assert!(
    std::mem::size_of::<Mod16DenseKey>() == 8_200 && std::mem::align_of::<Mod16DenseKey>() == 8
);

const _: () = assert!(
    std::mem::size_of::<LiftPairProfile>() == 40 && std::mem::align_of::<LiftPairProfile>() == 8
);

const _: () = assert!(
    std::mem::size_of::<Q2PairResidueProfile>() == 16
        && std::mem::align_of::<Q2PairResidueProfile>() == 8
);

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct Q1Key {
    energy: u8,
    q1: u16,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct Q1ClassWitness {
    keys: [Q1Key; 4],
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct Q2ClassWitness {
    states: [u64; 4],
}

#[derive(Clone, Debug, PartialEq, Eq)]
struct EnergyDomain {
    witnesses: [u32; DEFECT_TARGET + 1],
    energies: u128,
    configurations: u32,
    q1_profiles: Box<[Q1Profile]>,
    q1_hash: u64,
    q2_profiles: Option<Box<[Q2Profile]>>,
    q2_hash: u64,
    lift_profiles: Option<Box<[LiftProfile]>>,
    lift_hash: u64,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G133SparseQ2ProfileReport {
    pub block_domains_compiled: u16,
    pub minimum_domain_profiles: u32,
    pub maximum_domain_profiles: u32,
    pub total_domain_profiles: u64,
    pub special_q2_classes: u16,
    pub zero_q2_classes: u16,
    pub profile_bytes: u64,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G133JointShiftProfileReport {
    pub block_domains_compiled: u16,
    pub total_configurations: u64,
    pub total_unique_states: u64,
    pub minimum_domain_configurations: u32,
    pub maximum_domain_configurations: u32,
    pub minimum_domain_unique_states: u32,
    pub maximum_domain_unique_states: u32,
    pub maximum_state_multiplicity: u32,
    pub profile_workspace_bytes: u64,
    pub provenance: &'static str,
}

#[repr(C)]
#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq)]
pub struct G133CellRootRepresentative {
    pub masks: [u16; 4],
    pub cell_id: u32,
    pub reserved: u32,
}

const _: () = assert!(
    std::mem::size_of::<G133CellRootRepresentative>() == 16
        && std::mem::align_of::<G133CellRootRepresentative>() == 4
);

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G133JointShiftRootShape {
    pub cell_id: u32,
    pub masks: [u16; 4],
    pub configurations: [u32; 4],
    pub unique_states: [u32; 4],
    pub left_pair_envelope: u64,
    pub right_pair_envelope: u64,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G133JointShiftRootShapeReport {
    pub cells: u32,
    pub unique_typed_masks: u16,
    pub minimum_pair_envelope: u64,
    pub maximum_pair_envelope: u64,
    pub rows: Box<[G133JointShiftRootShape]>,
    pub provenance: &'static str,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G133JointShiftCoarsePairReport {
    pub cell_id: u32,
    pub masks: [u16; 4],
    pub pairing: [u8; 4],
    pub unique_states: [u32; 4],
    pub coarse_groups: [u32; 4],
    pub left_pair_envelope: u64,
    pub right_pair_envelope: u64,
    pub left_coarse_pair_envelope: u64,
    pub right_coarse_pair_envelope: u64,
    pub right_coarse_sum_keys: u64,
    pub left_coarse_sum_keys: u64,
    pub left_joint_pairs_with_coarse_complement: u64,
    pub right_joint_pairs_with_coarse_complement: u64,
    pub hash_slots: u64,
    pub hash_bytes: u64,
    pub provenance: &'static str,
}

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct JointCoarseGroup {
    key: u64,
    offset: u32,
    states: u32,
}

const _: () = assert!(
    std::mem::size_of::<JointCoarseGroup>() == 16 && std::mem::align_of::<JointCoarseGroup>() == 8
);

#[derive(Clone, Debug, PartialEq, Eq)]
struct JointCoarseDomain {
    groups: Box<[JointCoarseGroup]>,
    states: Box<[JointShiftProfile]>,
}

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct JointFilteredPair {
    key: u32,
    first_digits: u32,
    second_digits: u32,
    reserved: u32,
}

const _: () = assert!(
    std::mem::size_of::<JointFilteredPair>() == 16
        && std::mem::align_of::<JointFilteredPair>() == 4
);

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G133JointShiftExactRootReport {
    pub cell_id: u32,
    pub masks: [u16; 4],
    pub pairing: [u8; 4],
    pub left_filtered_pairs: u32,
    pub right_filtered_pairs: u32,
    pub left_exact_keys: u32,
    pub right_exact_keys: u32,
    pub common_witness: bool,
    pub witness_digits: Option<[u32; 4]>,
    pub pair_workspace_bytes: u64,
    pub provenance: &'static str,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G133JointShiftExactOracleReport {
    pub cell_id: u32,
    pub masks: [u16; 4],
    pub pairing: [u8; 4],
    pub left_exact_keys: u32,
    pub right_exact_keys: u32,
    pub common_witness: bool,
    pub maximum_sorted_coarse_pairs: u64,
    pub workspace_bytes: u64,
    pub provenance: &'static str,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G133JointShiftPairPoints {
    pub cell_id: u32,
    pub pairing: [u8; 4],
    pub left: Box<[[i32; 2]]>,
    pub right: Box<[[i32; 2]]>,
    pub provenance: &'static str,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G133JointShiftClassRefinementReport {
    pub special_masks: u16,
    pub zero_masks: u16,
    pub special_q6_classes: u16,
    pub zero_q6_classes: u16,
    pub special_joint_classes: u16,
    pub zero_joint_classes: u16,
    pub split_q6_classes: u16,
    pub maximum_joint_classes_per_q6_class: u16,
    pub retained_joint_state_words: u64,
    pub retained_joint_state_bytes: u64,
    pub provenance: &'static str,
}

#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq)]
pub struct G133JointShiftRefinedCell {
    pub q6_cell_id: u32,
    pub joint_cell_id: u32,
    pub masks: [u16; 4],
    pub joint_classes: [u16; 4],
    pub mod4_roots: u64,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G133JointShiftRefinedCellReport {
    pub supplied_q6_cells: u32,
    pub matched_mod4_roots: u64,
    pub refined_joint_cells: u32,
    pub special_joint_classes: u16,
    pub zero_joint_classes: u16,
    pub rows: Box<[G133JointShiftRefinedCell]>,
    pub provenance: &'static str,
}

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct CycleMod11State {
    key: u64,
    digits: u32,
    reserved: u32,
}

const _: () = assert!(
    std::mem::size_of::<CycleMod11State>() == 16 && std::mem::align_of::<CycleMod11State>() == 8
);

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct CycleMod11Group {
    key: u64,
    residues: u16,
    reserved: [u8; 6],
}

const _: () = assert!(
    std::mem::size_of::<CycleMod11Group>() == 16 && std::mem::align_of::<CycleMod11Group>() == 8
);

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct CycleMod11PairSlot {
    key_plus_one: u64,
    residues: u16,
    reserved: [u8; 6],
}

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct CycleMod11OracleKey {
    key: u64,
}

const _: () = assert!(std::mem::size_of::<CycleMod11OracleKey>() == 8);

const EMPTY_CYCLE_MOD11_PAIR_SLOT: CycleMod11PairSlot = CycleMod11PairSlot {
    key_plus_one: 0,
    residues: 0,
    reserved: [0; 6],
};

const _: () = assert!(
    std::mem::size_of::<CycleMod11PairSlot>() == 16
        && std::mem::align_of::<CycleMod11PairSlot>() == 8
);

struct CycleMod11Domain {
    groups: Box<[CycleMod11Group]>,
    configurations: u32,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G133CycleMod11CellRow {
    pub cell_id: u32,
    pub masks: [u16; 4],
    pub pairing: [u8; 4],
    pub block_groups: [u32; 4],
    pub left_group_pairs: u64,
    pub right_group_pairs: u64,
    pub right_pair_keys: u32,
    pub mod11_compatible: bool,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G133CycleMod11Report {
    pub cells: u32,
    pub excluded_cells: u32,
    pub compatible_cells: u32,
    pub unique_typed_masks: u16,
    pub total_configurations: u64,
    pub maximum_pair_keys: u32,
    pub workspace_bytes: u64,
    pub rows: Box<[G133CycleMod11CellRow]>,
    pub provenance: &'static str,
}

#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq)]
pub struct G133CycleMod11OracleCellRow {
    pub cell_id: u32,
    pub masks: [u16; 4],
    pub pairing: [u8; 4],
    pub raw_right_pairs: u64,
    pub right_pair_keys: u32,
    pub mod11_compatible: bool,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G133CycleMod11OracleReport {
    pub cells: u32,
    pub excluded_cells: u32,
    pub compatible_cells: u32,
    pub unique_typed_masks: u16,
    pub total_configurations: u64,
    pub maximum_raw_right_pairs: u64,
    pub maximum_pair_keys: u32,
    pub workspace_bytes: u64,
    pub rows: Box<[G133CycleMod11OracleCellRow]>,
    pub provenance: &'static str,
}

#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq)]
pub struct G133CycleMod11RefinedCell {
    pub q6_cell_id: u32,
    pub cycle_cell_id: u32,
    pub masks: [u16; 4],
    pub cycle_classes: [u16; 4],
    pub mod4_roots: u64,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G133CycleMod11RefinedCellReport {
    pub supplied_q6_cells: u32,
    pub matched_mod4_roots: u64,
    pub refined_cycle_cells: u32,
    pub special_q6_classes: u16,
    pub zero_q6_classes: u16,
    pub special_cycle_classes: u16,
    pub zero_cycle_classes: u16,
    pub split_q6_classes: u16,
    pub maximum_cycle_classes_per_q6_class: u16,
    pub block_domains_compiled: u16,
    pub retained_group_bytes: u64,
    pub rows: Box<[G133CycleMod11RefinedCell]>,
    pub provenance: &'static str,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G133SparseQ2Mod64Report {
    pub shift: u8,
    pub modulus: u8,
    pub target_residue: u8,
    pub mod4_roots: u64,
    pub q2_mod64_survivors: u64,
    pub q2_mod64_excluded: u64,
    pub special_q2_classes: u16,
    pub zero_q2_classes: u16,
    pub class_quadruples: u32,
    pub compatible_class_quadruples: u32,
    pub minimum_pair_profiles: u32,
    pub maximum_pair_profiles: u32,
    pub total_pair_profiles: u64,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G133SparseQ0Report {
    pub mod4_roots: u64,
    pub constructive_q0_hits: u64,
    pub exhaustive_q0_misses: u64,
    pub block_domains_compiled: u16,
    pub minimum_domain_energies: u8,
    pub maximum_domain_energies: u8,
    pub minimum_domain_configurations: u32,
    pub maximum_domain_configurations: u32,
    pub total_domain_configurations: u64,
    pub minimum_domain_q1_profiles: u32,
    pub maximum_domain_q1_profiles: u32,
    pub total_domain_q1_profiles: u64,
    pub special_q1_classes: u16,
    pub zero_q1_classes: u16,
    pub q1_pair_classes: u16,
    pub minimum_q1_pair_profiles: u32,
    pub maximum_q1_pair_profiles: u32,
    pub total_q1_pair_profiles: u64,
    pub constructive_q1_hits: u64,
    pub exhaustive_q1_misses: u64,
    pub q1_witness_full_mod8_hits: u64,
    pub q1_witness_mod8_mismatch_histogram: [u64; 9],
    pub q1_witness_full_mod16_hits: u64,
    pub q1_witness_mod16_mismatch_histogram: [u64; 9],
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G133SparseJointMod8Report {
    pub mod4_roots: u64,
    pub q0_q1_roots: u64,
    pub joint_mod8_survivors: u64,
    pub joint_mod8_exclusions: u64,
    pub special_lift_classes: u16,
    pub zero_lift_classes: u16,
    pub compatible_class_quadruples: u32,
    pub total_class_quadruples: u32,
    pub requested_class_signatures: u32,
    pub maximum_signatures_per_class: u16,
    pub minimum_domain_profiles: u32,
    pub maximum_domain_profiles: u32,
    pub total_domain_profiles: u64,
    pub minimum_pair_profiles: u32,
    pub maximum_pair_profiles: u32,
    pub total_pair_profiles: u64,
    pub provenance: &'static str,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G133SparseMod16ClassReport {
    pub block_domains_compiled: u16,
    pub special_classes: u16,
    pub zero_classes: u16,
    pub minimum_domain_profiles: u32,
    pub maximum_domain_profiles: u32,
    pub total_domain_profiles: u64,
    pub profile_bytes: u64,
    pub mod4_roots: u64,
    pub requested_class_cells: u32,
    pub conflicting_target_cells: u32,
    pub requested_left_pair_classes: u16,
    pub requested_right_pair_classes: u16,
    pub provenance: &'static str,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G133SparseMod16PairShapeReport {
    pub special_mask: u16,
    pub zero_mask: u16,
    pub special_block_keys: u32,
    pub zero_block_keys: u32,
    pub special_zero_pair_keys: u32,
    pub zero_zero_pair_keys: u32,
    pub special_zero_full_keys: u32,
    pub zero_zero_full_keys: u32,
    pub special_zero_minimum_signatures: u32,
    pub special_zero_maximum_signatures: u32,
    pub zero_zero_minimum_signatures: u32,
    pub zero_zero_maximum_signatures: u32,
    pub provenance: &'static str,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G133SparseJointMod16Report {
    pub mod4_roots: u64,
    pub q0_q1_roots: u64,
    pub joint_mod16_candidates: u64,
    pub candidate_reduction: u64,
    pub requested_class_cells: u32,
    pub q0_q1_class_cells: u32,
    pub compatible_class_cells: u32,
    pub requested_left_pair_classes: u16,
    pub requested_right_pair_classes: u16,
    pub total_pair_keys: u64,
    pub total_pair_signatures: u64,
    pub maximum_signatures_per_pair_key: u16,
    pub provenance: &'static str,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G133SparseExactQ2PairShapeReport {
    pub special_mask: u16,
    pub zero_mask: u16,
    pub special_zero_pair_keys: u32,
    pub zero_zero_pair_keys: u32,
    pub special_zero_interval_keys: u32,
    pub zero_zero_interval_keys: u32,
    pub special_zero_relaxation_excess: u64,
    pub zero_zero_relaxation_excess: u64,
    pub maximum_relaxation_excess_per_key: u32,
    pub provenance: &'static str,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G133SparseExactShiftPairShapeReport {
    pub shift: u8,
    pub special_mask: u16,
    pub zero_mask: u16,
    pub special_zero_pair_keys: u32,
    pub zero_zero_pair_keys: u32,
    pub special_zero_interval_keys: u32,
    pub zero_zero_interval_keys: u32,
    pub special_zero_relaxation_excess: u64,
    pub zero_zero_relaxation_excess: u64,
    pub maximum_relaxation_excess_per_key: u32,
    pub provenance: &'static str,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G133SparseExactQ2Report {
    pub mod4_roots: u64,
    pub q0_q1_roots: u64,
    pub exact_q2_candidates: u64,
    pub exact_q2_reduction: u64,
    pub special_classes: u16,
    pub zero_classes: u16,
    pub q0_q1_class_cells: u32,
    pub exact_q2_class_cells: u32,
    pub total_pair_keys: u64,
    pub total_pair_values: u64,
    pub stored_pair_holes: u64,
    pub maximum_values_per_pair_key: u16,
    pub independent_pair_oracle: bool,
    pub candidate_digest: [u8; 32],
    pub provenance: &'static str,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G133SparseExactShiftReport {
    pub shift: u8,
    pub mod4_roots: u64,
    pub q0_q1_roots: u64,
    pub exact_shift_candidates: u64,
    pub exact_shift_reduction: u64,
    pub special_classes: u16,
    pub zero_classes: u16,
    pub q0_q1_class_cells: u32,
    pub exact_shift_class_cells: u32,
    pub total_pair_keys: u64,
    pub total_pair_values: u64,
    pub stored_pair_holes: u64,
    pub maximum_values_per_pair_key: u16,
    pub independent_pair_oracle: bool,
    pub candidate_digest: [u8; 32],
    pub provenance: &'static str,
}

#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq)]
pub struct G133ExactShiftCellRow {
    pub id: u32,
    pub weight: u64,
    pub survives: bool,
    pub block_configurations: [u32; 4],
    pub block_energy_values: [u16; 4],
    pub block_q1_profiles: [u32; 4],
    pub block_shift_profiles: [u32; 4],
    pub left_pair_keys: u32,
    pub left_pair_values: u32,
    pub right_pair_keys: u32,
    pub right_pair_values: u32,
    pub left_pair_holes: u32,
    pub right_pair_holes: u32,
    pub left_interval_keys: u32,
    pub right_interval_keys: u32,
    pub left_maximum_holes: u16,
    pub right_maximum_holes: u16,
    pub left_residue_bits: u32,
    pub right_residue_bits: u32,
    pub base_sumset_pairs: u32,
    pub hole_covered_pairs: u32,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G133ExactShiftCellCorpus {
    pub report: G133SparseExactShiftReport,
    pub rows: Box<[G133ExactShiftCellRow]>,
    pub provenance: &'static str,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct G133ExactShiftRootFilter {
    pub report: G133SparseExactShiftReport,
    root_count: u64,
    candidates: Box<[u64]>,
}

impl G133ExactShiftRootFilter {
    #[must_use]
    pub const fn root_count(&self) -> u64 {
        self.root_count
    }

    #[must_use]
    pub fn contains(&self, root: u64) -> bool {
        root < self.root_count && self.candidates[root as usize / 64] & (1_u64 << (root % 64)) != 0
    }
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G133SparseExactShiftIntersectionReport {
    pub shifts: [u8; 2],
    pub mod4_roots: u64,
    pub q0_q1_roots: u64,
    pub first_shift_candidates: u64,
    pub second_shift_candidates: u64,
    pub intersection_candidates: u64,
    pub intersection_reduction: u64,
    pub candidate_digest: [u8; 32],
    pub provenance: &'static str,
}

#[derive(Clone, Debug, Error, PartialEq, Eq)]
pub enum G133SparseError {
    #[error("g133 Z18 multiplier projection is not canonical")]
    OrbitProjection,
    #[error("mod-four root or sparse-state budget exceeded")]
    StateBudget,
    #[error("g133 sparse arithmetic or direct replay failed")]
    SemanticMismatch,
}

fn binary_word(mask: u16) -> [u16; QUOTIENT] {
    let mut word = [0_u16; QUOTIENT];
    for (slot, residues) in SLOT_RESIDUES.iter().enumerate() {
        let value = (mask >> slot) & 1;
        for &residue in *residues {
            word[residue] = value;
        }
    }
    word
}

fn paf(word: &[u16; QUOTIENT], shift: usize) -> u32 {
    (0..QUOTIENT)
        .map(|position| u32::from(word[position] * word[(position + shift) % QUOTIENT]))
        .sum()
}

/// Canonical PAF shift under the multiplier-133 action on the Z18 quotient.
///
/// Quotient words are constant on multiplication-by-seven orbits because
/// `133 == 7 (mod 18)`.  Substitution in the cyclic autocorrelation sum and
/// reflection therefore identify shifts in the same `<7,-1>` orbit.
pub fn g133_shift_orbit_representative(shift: usize) -> Result<u8, G133SparseError> {
    if shift == 0 || shift >= QUOTIENT {
        return Err(G133SparseError::StateBudget);
    }
    let start = shift;
    let mut point = shift;
    let mut representative = shift.min(QUOTIENT - shift);
    loop {
        point = point * 7 % QUOTIENT;
        representative = representative.min(point.min(QUOTIENT - point));
        if point == start {
            break;
        }
    }
    u8::try_from(representative).map_err(|_| G133SparseError::StateBudget)
}

fn pack_signature(values: [u8; SHIFTS]) -> u32 {
    values
        .into_iter()
        .enumerate()
        .map(|(shift, value)| u32::from(value) << (2 * shift))
        .sum()
}

fn add_signatures(left: u32, right: u32) -> u32 {
    let mut output = 0_u32;
    for shift in 0..SHIFTS {
        let digit = ((left >> (2 * shift)) & 3) + ((right >> (2 * shift)) & 3);
        output |= (digit & 3) << (2 * shift);
    }
    output
}

fn complement_signature(value: u32) -> u32 {
    let targets = [3_u8, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    let mut output = 0_u32;
    for (shift, target) in targets.into_iter().enumerate() {
        let digit = ((value >> (2 * shift)) & 3) as u8;
        output |= u32::from((target + MODULUS - digit) % MODULUS) << (2 * shift);
    }
    output
}

fn compile_binary_profiles(row_residue: u8) -> Vec<BinaryProfile> {
    let mut profiles = Vec::with_capacity(1 << SLOTS);
    for mask in 0_u16..1 << SLOTS {
        let word = binary_word(mask);
        let row = word.iter().copied().sum::<u16>();
        if row % u16::from(MODULUS) != u16::from(row_residue) {
            continue;
        }
        let signature = pack_signature(std::array::from_fn(|shift| {
            (paf(&word, shift) % u32::from(MODULUS)) as u8
        }));
        profiles.push(BinaryProfile { signature, mask });
    }
    profiles
}

fn compile_mod4_frontier() -> (Vec<BinaryProfile>, Vec<BinaryProfile>, Vec<BinaryPair>) {
    let special = compile_binary_profiles(0);
    let zero = compile_binary_profiles(1);
    let mut right = Vec::with_capacity(zero.len() * zero.len());
    for first in &zero {
        for second in &zero {
            right.push(BinaryPair {
                signature: add_signatures(first.signature, second.signature),
                first: first.mask,
                second: second.mask,
            });
        }
    }
    right.sort_unstable();
    (special, zero, right)
}

fn defect_cost(base: u16, digit: u16, multiplicity: u16) -> Option<u8> {
    let coefficient = i32::from(base + 4 * digit);
    let signed = 2 * coefficient - 29;
    let excess = signed.checked_mul(signed)?.checked_sub(9)?;
    if excess < 0 || excess % 16 != 0 {
        return None;
    }
    u8::try_from((excess / 16) * i32::from(multiplicity)).ok()
}

fn decode_word(mask: u16, digits: u32) -> [u16; QUOTIENT] {
    let mut word = [0_u16; QUOTIENT];
    let mut code = digits;
    for (slot, residues) in SLOT_RESIDUES.iter().enumerate() {
        let digit = (code & 7) as u16;
        code >>= 3;
        let value = ((mask >> slot) & 1) + 4 * digit;
        for &residue in *residues {
            word[residue] = value;
        }
    }
    word
}

#[cfg(test)]
fn mod8_lift_signature(
    base: &[u16; QUOTIENT],
    word: &[u16; QUOTIENT],
) -> Result<u8, G133SparseError> {
    let mut signature = 0_u8;
    for shift in 2..SHIFTS {
        let delta = paf(word, shift)
            .checked_sub(paf(base, shift))
            .ok_or(G133SparseError::SemanticMismatch)?;
        if delta & 3 != 0 {
            return Err(G133SparseError::SemanticMismatch);
        }
        signature |= ((delta >> 2) as u8 & 1) << (shift - 2);
    }
    Ok(signature)
}

#[cfg(test)]
fn mod16_lift_signature(
    base: &[u16; QUOTIENT],
    word: &[u16; QUOTIENT],
) -> Result<u16, G133SparseError> {
    let mut signature = 0_u16;
    for shift in 2..SHIFTS {
        let delta = paf(word, shift)
            .checked_sub(paf(base, shift))
            .ok_or(G133SparseError::SemanticMismatch)?;
        if delta & 3 != 0 {
            return Err(G133SparseError::SemanticMismatch);
        }
        signature |= ((delta >> 2) as u16 & 3) << (2 * (shift - 2));
    }
    Ok(signature)
}

fn theorem_mod8_lift_signature(
    base: &[u16; QUOTIENT],
    packed_digits: u32,
) -> Result<u8, G133SparseError> {
    let mut lift = [0_u8; QUOTIENT];
    let mut code = packed_digits;
    for residues in SLOT_RESIDUES {
        let bit = (code & 1) as u8;
        code >>= 3;
        for &residue in residues {
            lift[residue] = bit;
        }
    }
    let mut signature = 0_u8;
    for shift in 2..SHIFTS {
        let lifted = lift_autocorrelation(base, &lift, shift, 2)
            .map_err(|_| G133SparseError::SemanticMismatch)?;
        let base_value = (paf(base, shift) & 7) as u16;
        let difference = (lifted + 8 - base_value) & 7;
        if difference != 0 && difference != 4 {
            return Err(G133SparseError::SemanticMismatch);
        }
        signature |= ((difference >> 2) as u8) << (shift - 2);
    }
    Ok(signature)
}

fn theorem_mod16_lift_signature(
    base: &[u16; QUOTIENT],
    packed_digits: u32,
) -> Result<u16, G133SparseError> {
    let mut low_lift = [0_u8; QUOTIENT];
    let mut high_lift = [0_u8; QUOTIENT];
    let mut code = packed_digits;
    for residues in SLOT_RESIDUES {
        let digit = (code & 7) as u8;
        code >>= 3;
        for &residue in residues {
            low_lift[residue] = digit & 1;
            high_lift[residue] = (digit >> 1) & 1;
        }
    }
    let base_mod8: [u16; QUOTIENT] =
        std::array::from_fn(|point| base[point] + 4 * u16::from(low_lift[point]));
    let mut signature = 0_u16;
    for shift in 2..SHIFTS {
        let lifted = lift_autocorrelation(&base_mod8, &high_lift, shift, 3)
            .map_err(|_| G133SparseError::SemanticMismatch)?;
        let base_value = (paf(base, shift) & 15) as u16;
        let difference = (lifted + 16 - base_value) & 15;
        if difference & 3 != 0 {
            return Err(G133SparseError::SemanticMismatch);
        }
        signature |= (difference >> 2) << (2 * (shift - 2));
    }
    Ok(signature)
}

fn compile_energy_domain(
    mask: u16,
    row_target: u16,
    extra_shift: Option<usize>,
    lift_bits: u8,
) -> Result<EnergyDomain, G133SparseError> {
    if extra_shift.is_some_and(|shift| !(2..SHIFTS).contains(&shift)) {
        return Err(G133SparseError::StateBudget);
    }
    let base = binary_word(mask);
    let multiplicities: [u16; SLOTS] = std::array::from_fn(|slot| SLOT_RESIDUES[slot].len() as u16);
    let mut remaining_weight = [0_i16; SLOTS + 1];
    for slot in (0..SLOTS).rev() {
        remaining_weight[slot] = remaining_weight[slot + 1] + multiplicities[slot] as i16;
    }
    let mut next_digit = [0_u8; SLOTS];
    let mut chosen = [0_u8; SLOTS];
    let mut row_prefix = [0_u16; SLOTS + 1];
    let mut energy_prefix = [0_u8; SLOTS + 1];
    let mut depth = 0_usize;
    let mut witnesses = [u32::MAX; DEFECT_TARGET + 1];
    let mut configurations = 0_u32;
    let mut q1_seen = vec![0_u64; (DEFECT_TARGET + 1) * Q1_LIMIT / 64];
    let mut q1_profiles = Vec::with_capacity(MAX_Q1_PROFILES_PER_DOMAIN);
    let mut q2_profiles = Vec::<Q2Profile>::new();
    if extra_shift.is_some() {
        q2_profiles
            .try_reserve_exact(MAX_Q2_PROFILES_PER_DOMAIN)
            .map_err(|_| G133SparseError::StateBudget)?;
    }
    if lift_bits > 2 {
        return Err(G133SparseError::StateBudget);
    }
    let mut lift_profiles = Vec::<LiftProfile>::new();
    if lift_bits != 0 {
        lift_profiles
            .try_reserve_exact(MAX_LIFT_PROFILES_PER_DOMAIN)
            .map_err(|_| G133SparseError::StateBudget)?;
    }
    loop {
        if depth == SLOTS {
            if row_prefix[depth] == row_target {
                configurations = configurations
                    .checked_add(1)
                    .ok_or(G133SparseError::StateBudget)?;
                let energy = usize::from(energy_prefix[depth]);
                let packed = chosen
                    .iter()
                    .enumerate()
                    .map(|(slot, &digit)| u32::from(digit) * POWERS[slot])
                    .sum::<u32>();
                let word = decode_word(mask, packed);
                let q1 = paf(&word, 1) as usize;
                if q1 >= Q1_LIMIT {
                    return Err(G133SparseError::StateBudget);
                }
                let q1_index = energy * Q1_LIMIT + q1;
                let q1_bit = 1_u64 << (q1_index % 64);
                if q1_seen[q1_index / 64] & q1_bit == 0 {
                    if q1_profiles.len() == MAX_Q1_PROFILES_PER_DOMAIN {
                        return Err(G133SparseError::StateBudget);
                    }
                    q1_seen[q1_index / 64] |= q1_bit;
                    q1_profiles.push(Q1Profile {
                        q1: q1 as u16,
                        energy: energy as u8,
                        reserved: 0,
                        digits: packed,
                    });
                }
                if let Some(shift) = extra_shift {
                    if q2_profiles.len() == MAX_Q2_PROFILES_PER_DOMAIN {
                        return Err(G133SparseError::StateBudget);
                    }
                    let q2 = paf(&word, shift) as usize;
                    if q2 >= Q1_LIMIT {
                        return Err(G133SparseError::StateBudget);
                    }
                    q2_profiles.push(Q2Profile {
                        state: ((energy as u64) << 26) | ((q1 as u64) << 13) | q2 as u64,
                        digits: packed,
                        reserved: 0,
                    });
                }
                if lift_bits != 0 {
                    if lift_profiles.len() == MAX_LIFT_PROFILES_PER_DOMAIN {
                        return Err(G133SparseError::StateBudget);
                    }
                    let signature = if lift_bits == 1 {
                        u16::from(theorem_mod8_lift_signature(&base, packed)?)
                    } else {
                        theorem_mod16_lift_signature(&base, packed)?
                    };
                    lift_profiles.push(LiftProfile {
                        state: ((energy as u64) << 29) | ((q1 as u64) << 16) | u64::from(signature),
                        digits: packed,
                        reserved: 0,
                    });
                }
                if witnesses[energy] == u32::MAX {
                    witnesses[energy] = packed;
                }
            }
            depth -= 1;
            continue;
        }
        if next_digit[depth] == 8 {
            next_digit[depth] = 0;
            if depth == 0 {
                break;
            }
            depth -= 1;
            continue;
        }
        let digit = next_digit[depth];
        next_digit[depth] += 1;
        let energy = defect_cost(
            base[SLOT_RESIDUES[depth][0]],
            u16::from(digit),
            multiplicities[depth],
        )
        .ok_or(G133SparseError::SemanticMismatch)?;
        let Some(next_energy) = energy_prefix[depth].checked_add(energy) else {
            continue;
        };
        if usize::from(next_energy) > DEFECT_TARGET {
            continue;
        }
        let value = ((mask >> depth) & 1) + 4 * u16::from(digit);
        let next_row = row_prefix[depth] + multiplicities[depth] * value;
        if next_row > row_target {
            continue;
        }
        let remaining = remaining_weight[depth + 1] as u16;
        if next_row + remaining * 29 < row_target {
            continue;
        }
        chosen[depth] = digit;
        row_prefix[depth + 1] = next_row;
        energy_prefix[depth + 1] = next_energy;
        depth += 1;
    }
    let mut energies = 0_u128;
    for (energy, &witness) in witnesses.iter().enumerate() {
        if witness != u32::MAX {
            energies |= 1_u128 << energy;
        }
    }
    if energies == 0 {
        return Err(G133SparseError::SemanticMismatch);
    }
    let mut q1_hash = 0xcbf2_9ce4_8422_2325_u64;
    for &word in &q1_seen {
        q1_hash ^= word;
        q1_hash = q1_hash.wrapping_mul(0x100_0000_01b3);
    }
    q1_profiles.sort_unstable_by_key(|profile| (profile.energy, profile.q1));
    let (q2_profiles, q2_hash) = if extra_shift.is_some() {
        q2_profiles.sort_unstable_by_key(|profile| profile.state);
        q2_profiles.dedup_by_key(|profile| profile.state);
        let mut hash = 0xcbf2_9ce4_8422_2325_u64;
        for profile in &q2_profiles {
            hash ^= profile.state;
            hash = hash.wrapping_mul(0x100_0000_01b3);
        }
        (Some(q2_profiles.into_boxed_slice()), hash)
    } else {
        (None, 0)
    };
    let (lift_profiles, lift_hash) = if lift_bits != 0 {
        lift_profiles.sort_unstable_by_key(|profile| profile.state);
        lift_profiles.dedup_by_key(|profile| profile.state);
        let mut hash = 0xcbf2_9ce4_8422_2325_u64;
        for profile in &lift_profiles {
            hash ^= profile.state;
            hash = hash.wrapping_mul(0x100_0000_01b3);
        }
        (Some(lift_profiles.into_boxed_slice()), hash)
    } else {
        (None, 0)
    };
    Ok(EnergyDomain {
        witnesses,
        energies,
        configurations,
        q1_profiles: q1_profiles.into_boxed_slice(),
        q1_hash,
        q2_profiles,
        q2_hash,
        lift_profiles,
        lift_hash,
    })
}

#[inline(always)]
fn joint_shift_profile(
    mask: u16,
    packed_digits: u32,
    energy: u8,
) -> Result<JointShiftProfile, G133SparseError> {
    let word = decode_word(mask, packed_digits);
    let q1 = paf(&word, 1);
    let q3 = paf(&word, 3);
    let q6 = paf(&word, 6);
    let q9 = paf(&word, 9);
    if [q1, q3, q6, q9]
        .into_iter()
        .any(|value| value >= Q1_LIMIT as u32)
    {
        return Err(G133SparseError::StateBudget);
    }
    Ok(JointShiftProfile {
        state: (u64::from(energy) << 52)
            | (u64::from(q1) << 39)
            | (u64::from(q3) << 26)
            | (u64::from(q6) << 13)
            | u64::from(q9),
        digits: packed_digits,
        reserved: 0,
    })
}

/// Cycle-decomposition identity for shifts 3, 6, and 9 on the length-18
/// quotient. This is an exact algebraic identity, not an enumerated claim.
pub fn verify_three_cycle_energy_identity(word: &[u16; QUOTIENT]) -> bool {
    let mut cycle_sums = [0_u64; 3];
    for (index, &value) in word.iter().enumerate() {
        cycle_sums[index % 3] += u64::from(value);
    }
    let square_sum = cycle_sums.iter().map(|&sum| sum * sum).sum::<u64>();
    let paf0 = u64::from(paf(word, 0));
    let paf3 = u64::from(paf(word, 3));
    let paf6 = u64::from(paf(word, 6));
    let paf9 = u64::from(paf(word, 9));
    square_sum == paf0 + 2 * paf3 + 2 * paf6 + paf9
}

#[inline(always)]
fn three_cycle_affine_residue(word: &[u16; QUOTIENT], modulus: u32) -> u32 {
    let mut cycle_sums = [0_u64; 3];
    for (index, &value) in word.iter().enumerate() {
        cycle_sums[index % 3] += u64::from(value);
    }
    let square_sum = cycle_sums.iter().map(|&sum| sum * sum).sum::<u64>();
    let value = i64::from(paf(word, 0)) + 2 * i64::from(paf(word, 6))
        - i64::try_from(square_sum).expect("length-18 cycle square sum fits i64");
    value.rem_euclid(i64::from(modulus)) as u32
}

fn compile_cycle_mod11_domain(
    mask: u16,
    row_target: u16,
) -> Result<CycleMod11Domain, G133SparseError> {
    let base = binary_word(mask);
    let multiplicities: [u16; SLOTS] = std::array::from_fn(|slot| SLOT_RESIDUES[slot].len() as u16);
    let mut remaining_weight = [0_i16; SLOTS + 1];
    for slot in (0..SLOTS).rev() {
        remaining_weight[slot] = remaining_weight[slot + 1] + multiplicities[slot] as i16;
    }
    let mut states = Vec::new();
    states
        .try_reserve_exact(MAX_Q2_PROFILES_PER_DOMAIN)
        .map_err(|_| G133SparseError::StateBudget)?;
    let mut next_digit = [0_u8; SLOTS];
    let mut chosen = [0_u8; SLOTS];
    let mut row_prefix = [0_u16; SLOTS + 1];
    let mut energy_prefix = [0_u8; SLOTS + 1];
    let mut depth = 0_usize;
    let mut configurations = 0_u32;
    loop {
        if depth == SLOTS {
            if row_prefix[depth] == row_target {
                configurations = configurations
                    .checked_add(1)
                    .ok_or(G133SparseError::StateBudget)?;
                if states.len() == MAX_Q2_PROFILES_PER_DOMAIN {
                    return Err(G133SparseError::StateBudget);
                }
                let packed_digits = chosen
                    .iter()
                    .enumerate()
                    .map(|(slot, &digit)| u32::from(digit) * POWERS[slot])
                    .sum::<u32>();
                let word = decode_word(mask, packed_digits);
                let q1 = paf(&word, 1);
                let q6 = paf(&word, 6);
                if q1 >= Q1_LIMIT as u32 || q6 >= Q1_LIMIT as u32 {
                    return Err(G133SparseError::StateBudget);
                }
                let coarse =
                    (u64::from(energy_prefix[depth]) << 26) | (u64::from(q1) << 13) | u64::from(q6);
                let residue = three_cycle_affine_residue(&word, 11);
                states.push(CycleMod11State {
                    key: (coarse << 4) | u64::from(residue),
                    digits: packed_digits,
                    reserved: 0,
                });
            }
            depth -= 1;
            continue;
        }
        if next_digit[depth] == 8 {
            next_digit[depth] = 0;
            if depth == 0 {
                break;
            }
            depth -= 1;
            continue;
        }
        let digit = next_digit[depth];
        next_digit[depth] += 1;
        let energy = defect_cost(
            base[SLOT_RESIDUES[depth][0]],
            u16::from(digit),
            multiplicities[depth],
        )
        .ok_or(G133SparseError::SemanticMismatch)?;
        let Some(next_energy) = energy_prefix[depth].checked_add(energy) else {
            continue;
        };
        if usize::from(next_energy) > DEFECT_TARGET {
            continue;
        }
        let value = ((mask >> depth) & 1) + 4 * u16::from(digit);
        let next_row = row_prefix[depth] + multiplicities[depth] * value;
        if next_row > row_target {
            continue;
        }
        let remaining = remaining_weight[depth + 1] as u16;
        if next_row + remaining * 29 < row_target {
            continue;
        }
        chosen[depth] = digit;
        row_prefix[depth + 1] = next_row;
        energy_prefix[depth + 1] = next_energy;
        depth += 1;
    }
    states.sort_unstable_by_key(|state| state.key);
    states.dedup_by_key(|state| state.key);
    let mut groups = Vec::new();
    groups
        .try_reserve_exact(states.len())
        .map_err(|_| G133SparseError::StateBudget)?;
    for state in &states {
        let coarse = state.key >> 4;
        let residue = (state.key & 15) as u32;
        if residue >= 11 {
            return Err(G133SparseError::SemanticMismatch);
        }
        if groups
            .last()
            .is_none_or(|group: &CycleMod11Group| group.key != coarse)
        {
            groups.push(CycleMod11Group {
                key: coarse,
                residues: 0,
                reserved: [0; 6],
            });
        }
        groups
            .last_mut()
            .ok_or(G133SparseError::SemanticMismatch)?
            .residues |= 1_u16 << residue;
    }
    let reference = compile_energy_domain(mask, row_target, Some(6), 0)?;
    if configurations != reference.configurations {
        return Err(G133SparseError::SemanticMismatch);
    }
    let reference = reference
        .q2_profiles
        .as_deref()
        .ok_or(G133SparseError::SemanticMismatch)?;
    if groups.len() != reference.len()
        || !groups
            .iter()
            .zip(reference)
            .all(|(group, profile)| group.key == profile.state)
    {
        return Err(G133SparseError::SemanticMismatch);
    }
    Ok(CycleMod11Domain {
        groups: groups.into_boxed_slice(),
        configurations,
    })
}

fn cycle_q6_domain_equal(left: &CycleMod11Domain, right: &CycleMod11Domain) -> bool {
    left.groups
        .iter()
        .map(|group| group.key)
        .eq(right.groups.iter().map(|group| group.key))
}

fn cycle_full_domain_equal(left: &CycleMod11Domain, right: &CycleMod11Domain) -> bool {
    left.groups == right.groups
}

fn classify_cycle_domains(
    domains: &[Option<CycleMod11Domain>; 1 << SLOTS],
    equal: fn(&CycleMod11Domain, &CycleMod11Domain) -> bool,
) -> Result<(u16, [u16; 1 << SLOTS]), G133SparseError> {
    let mut representatives = Vec::<usize>::new();
    let mut classes = [u16::MAX; 1 << SLOTS];
    for (mask, domain) in domains.iter().enumerate() {
        let Some(domain) = domain else {
            continue;
        };
        let class = if let Some(class) = representatives.iter().position(|&representative| {
            domains[representative]
                .as_ref()
                .is_some_and(|candidate| equal(candidate, domain))
        }) {
            class
        } else {
            representatives.push(mask);
            representatives.len() - 1
        };
        classes[mask] = u16::try_from(class).map_err(|_| G133SparseError::StateBudget)?;
    }
    Ok((
        u16::try_from(representatives.len()).map_err(|_| G133SparseError::StateBudget)?,
        classes,
    ))
}

fn cycle_refinement_shape(
    q6_classes: u16,
    q6_map: &[u16; 1 << SLOTS],
    cycle_map: &[u16; 1 << SLOTS],
) -> Result<(u16, u16), G133SparseError> {
    let mut refinements = Vec::<Vec<u16>>::with_capacity(usize::from(q6_classes));
    for _ in 0..q6_classes {
        refinements.push(Vec::new());
    }
    for mask in 0..1 << SLOTS {
        if q6_map[mask] == u16::MAX || cycle_map[mask] == u16::MAX {
            continue;
        }
        let classes = &mut refinements[usize::from(q6_map[mask])];
        if !classes.contains(&cycle_map[mask]) {
            classes.push(cycle_map[mask]);
        }
    }
    let mut splits = 0_u16;
    let mut maximum = 0_u16;
    for classes in refinements {
        let count = u16::try_from(classes.len()).map_err(|_| G133SparseError::StateBudget)?;
        splits += u16::from(count > 1);
        maximum = maximum.max(count);
    }
    Ok((splits, maximum))
}

fn compile_joint_shift_profiles_into(
    mask: u16,
    row_target: u16,
    output: &mut Vec<JointShiftProfile>,
) -> Result<u32, G133SparseError> {
    if output.capacity() < MAX_Q2_PROFILES_PER_DOMAIN {
        return Err(G133SparseError::StateBudget);
    }
    output.clear();
    let base = binary_word(mask);
    let multiplicities: [u16; SLOTS] = std::array::from_fn(|slot| SLOT_RESIDUES[slot].len() as u16);
    let mut remaining_weight = [0_i16; SLOTS + 1];
    for slot in (0..SLOTS).rev() {
        remaining_weight[slot] = remaining_weight[slot + 1] + multiplicities[slot] as i16;
    }
    let mut next_digit = [0_u8; SLOTS];
    let mut chosen = [0_u8; SLOTS];
    let mut row_prefix = [0_u16; SLOTS + 1];
    let mut energy_prefix = [0_u8; SLOTS + 1];
    let mut depth = 0_usize;
    loop {
        if depth == SLOTS {
            if row_prefix[depth] == row_target {
                if output.len() == MAX_Q2_PROFILES_PER_DOMAIN {
                    return Err(G133SparseError::StateBudget);
                }
                let packed_digits = chosen
                    .iter()
                    .enumerate()
                    .map(|(slot, &digit)| u32::from(digit) * POWERS[slot])
                    .sum::<u32>();
                output.push(joint_shift_profile(
                    mask,
                    packed_digits,
                    energy_prefix[depth],
                )?);
            }
            depth -= 1;
            continue;
        }
        if next_digit[depth] == 8 {
            next_digit[depth] = 0;
            if depth == 0 {
                break;
            }
            depth -= 1;
            continue;
        }
        let digit = next_digit[depth];
        next_digit[depth] += 1;
        let energy = defect_cost(
            base[SLOT_RESIDUES[depth][0]],
            u16::from(digit),
            multiplicities[depth],
        )
        .ok_or(G133SparseError::SemanticMismatch)?;
        let Some(next_energy) = energy_prefix[depth].checked_add(energy) else {
            continue;
        };
        if usize::from(next_energy) > DEFECT_TARGET {
            continue;
        }
        let value = ((mask >> depth) & 1) + 4 * u16::from(digit);
        let next_row = row_prefix[depth] + multiplicities[depth] * value;
        if next_row > row_target {
            continue;
        }
        let remaining = remaining_weight[depth + 1] as u16;
        if next_row + remaining * 29 < row_target {
            continue;
        }
        chosen[depth] = digit;
        row_prefix[depth + 1] = next_row;
        energy_prefix[depth + 1] = next_energy;
        depth += 1;
    }
    output.sort_unstable();
    u32::try_from(output.len()).map_err(|_| G133SparseError::StateBudget)
}

fn replay_q0_hit(assignment: [u16; 4], digits: [u32; 4]) -> Result<(), G133SparseError> {
    let targets = [260_u16, 261, 261, 261];
    let words: [[u16; QUOTIENT]; 4] =
        std::array::from_fn(|block| decode_word(assignment[block], digits[block]));
    for block in 0..4 {
        if words[block].iter().copied().sum::<u16>() != targets[block] {
            return Err(G133SparseError::SemanticMismatch);
        }
    }
    if words.iter().map(|word| paf(word, 0)).sum::<u32>() != 15_603 {
        return Err(G133SparseError::SemanticMismatch);
    }
    Ok(())
}

fn replay_q1_hit(assignment: [u16; 4], digits: [u32; 4]) -> Result<(), G133SparseError> {
    replay_q0_hit(assignment, digits)?;
    let words: [[u16; QUOTIENT]; 4] =
        std::array::from_fn(|block| decode_word(assignment[block], digits[block]));
    if words.iter().map(|word| paf(word, 1)).sum::<u32>() != 15_080 {
        return Err(G133SparseError::SemanticMismatch);
    }
    Ok(())
}

fn replay_shift_hit(
    assignment: [u16; 4],
    digits: [u32; 4],
    shift: usize,
) -> Result<(), G133SparseError> {
    if !(2..SHIFTS).contains(&shift) {
        return Err(G133SparseError::StateBudget);
    }
    replay_q1_hit(assignment, digits)?;
    let words: [[u16; QUOTIENT]; 4] =
        std::array::from_fn(|block| decode_word(assignment[block], digits[block]));
    if words.iter().map(|word| paf(word, shift)).sum::<u32>() != 15_080 {
        return Err(G133SparseError::SemanticMismatch);
    }
    Ok(())
}

fn energy_sumset(mut left: u128, right: u128) -> u128 {
    let mut output = 0_u128;
    while left != 0 {
        let energy = left.trailing_zeros();
        left &= left - 1;
        output |= right << energy;
    }
    output & ((1_u128 << (DEFECT_TARGET + 1)) - 1)
}

fn pair_witness(first: &EnergyDomain, second: &EnergyDomain, target: usize) -> Option<(u32, u32)> {
    for first_energy in 0..=target {
        let second_energy = target - first_energy;
        if first.witnesses[first_energy] != u32::MAX && second.witnesses[second_energy] != u32::MAX
        {
            return Some((
                first.witnesses[first_energy],
                second.witnesses[second_energy],
            ));
        }
    }
    None
}

fn q1_domain_equal(left: &EnergyDomain, right: &EnergyDomain) -> bool {
    left.q1_profiles
        .iter()
        .map(|profile| (profile.energy, profile.q1))
        .eq(right
            .q1_profiles
            .iter()
            .map(|profile| (profile.energy, profile.q1)))
}

fn q1_class_representatives(
    domains: &[Option<EnergyDomain>],
) -> Result<Vec<&EnergyDomain>, G133SparseError> {
    let mut representatives = Vec::<&EnergyDomain>::new();
    for domain in domains.iter().flatten() {
        if let Some(representative) = representatives
            .iter()
            .copied()
            .find(|candidate| candidate.q1_hash == domain.q1_hash)
        {
            if !q1_domain_equal(representative, domain) {
                return Err(G133SparseError::SemanticMismatch);
            }
        } else {
            representatives.push(domain);
        }
    }
    Ok(representatives)
}

fn compile_q1_pair_profiles(
    first: &EnergyDomain,
    second: &EnergyDomain,
    seen: &mut [u64],
) -> Result<Box<[Q1PairProfile]>, G133SparseError> {
    seen.fill(0);
    let mut profiles = Vec::with_capacity(MAX_PAIR_PROFILES);
    for (first_index, left) in first.q1_profiles.iter().enumerate() {
        for (second_index, right) in second.q1_profiles.iter().enumerate() {
            let Some(energy) = left.energy.checked_add(right.energy) else {
                return Err(G133SparseError::SemanticMismatch);
            };
            if usize::from(energy) > DEFECT_TARGET {
                continue;
            }
            let Some(q1) = left.q1.checked_add(right.q1) else {
                return Err(G133SparseError::SemanticMismatch);
            };
            if usize::from(q1) >= 2 * Q1_LIMIT {
                return Err(G133SparseError::StateBudget);
            }
            let index = usize::from(energy) * (2 * Q1_LIMIT) + usize::from(q1);
            let bit = 1_u64 << (index % 64);
            if seen[index / 64] & bit == 0 {
                if profiles.len() == MAX_PAIR_PROFILES {
                    return Err(G133SparseError::StateBudget);
                }
                seen[index / 64] |= bit;
                profiles.push(Q1PairProfile {
                    q1,
                    first: u16::try_from(first_index).map_err(|_| G133SparseError::StateBudget)?,
                    second: u16::try_from(second_index)
                        .map_err(|_| G133SparseError::StateBudget)?,
                    energy,
                    reserved: [0; 9],
                });
            }
        }
    }
    profiles.sort_unstable_by_key(|profile| (profile.energy, profile.q1));
    Ok(profiles.into_boxed_slice())
}

fn q1_class_map(
    domains: &[Option<EnergyDomain>],
    representatives: &[&EnergyDomain],
) -> Result<[u8; 1 << SLOTS], G133SparseError> {
    let mut classes = [u8::MAX; 1 << SLOTS];
    for (mask, domain) in domains.iter().enumerate() {
        let Some(domain) = domain else {
            continue;
        };
        let class = representatives
            .iter()
            .position(|representative| {
                representative.q1_hash == domain.q1_hash && q1_domain_equal(representative, domain)
            })
            .ok_or(G133SparseError::SemanticMismatch)?;
        classes[mask] = u8::try_from(class).map_err(|_| G133SparseError::StateBudget)?;
    }
    Ok(classes)
}

fn q1_key(domain: &EnergyDomain, index: u16) -> Result<Q1Key, G133SparseError> {
    let profile = domain
        .q1_profiles
        .get(usize::from(index))
        .ok_or(G133SparseError::SemanticMismatch)?;
    Ok(Q1Key {
        energy: profile.energy,
        q1: profile.q1,
    })
}

fn q1_digits(domain: &EnergyDomain, key: Q1Key) -> Result<u32, G133SparseError> {
    let index = domain
        .q1_profiles
        .binary_search_by_key(&(key.energy, key.q1), |profile| {
            (profile.energy, profile.q1)
        })
        .map_err(|_| G133SparseError::SemanticMismatch)?;
    Ok(domain.q1_profiles[index].digits)
}

fn q2_domain_equal(left: &EnergyDomain, right: &EnergyDomain) -> bool {
    left.q2_profiles
        .as_deref()
        .into_iter()
        .flatten()
        .map(|profile| profile.state)
        .eq(right
            .q2_profiles
            .as_deref()
            .into_iter()
            .flatten()
            .map(|profile| profile.state))
}

fn q2_class_representatives(
    domains: &[Option<EnergyDomain>],
) -> Result<Vec<&EnergyDomain>, G133SparseError> {
    let mut representatives = Vec::<&EnergyDomain>::new();
    for domain in domains.iter().flatten() {
        if domain.q2_profiles.is_none() {
            return Err(G133SparseError::SemanticMismatch);
        }
        if let Some(representative) = representatives
            .iter()
            .copied()
            .find(|candidate| candidate.q2_hash == domain.q2_hash)
        {
            if !q2_domain_equal(representative, domain) {
                return Err(G133SparseError::SemanticMismatch);
            }
        } else {
            representatives.push(domain);
        }
    }
    Ok(representatives)
}

fn q2_class_count(domains: &[Option<EnergyDomain>]) -> Result<u16, G133SparseError> {
    u16::try_from(q2_class_representatives(domains)?.len())
        .map_err(|_| G133SparseError::StateBudget)
}

fn q2_class_map(
    domains: &[Option<EnergyDomain>],
    representatives: &[&EnergyDomain],
) -> Result<[u8; 1 << SLOTS], G133SparseError> {
    let mut classes = [u8::MAX; 1 << SLOTS];
    for (mask, domain) in domains.iter().enumerate() {
        let Some(domain) = domain else {
            continue;
        };
        let class = representatives
            .iter()
            .position(|representative| {
                representative.q2_hash == domain.q2_hash && q2_domain_equal(representative, domain)
            })
            .ok_or(G133SparseError::SemanticMismatch)?;
        classes[mask] = u8::try_from(class).map_err(|_| G133SparseError::StateBudget)?;
    }
    Ok(classes)
}

fn lift_domain_equal(left: &EnergyDomain, right: &EnergyDomain) -> bool {
    left.lift_profiles
        .as_deref()
        .into_iter()
        .flatten()
        .map(|profile| profile.state)
        .eq(right
            .lift_profiles
            .as_deref()
            .into_iter()
            .flatten()
            .map(|profile| profile.state))
}

fn lift_class_representatives(
    domains: &[Option<EnergyDomain>],
) -> Result<Vec<&EnergyDomain>, G133SparseError> {
    let mut representatives = Vec::<&EnergyDomain>::new();
    for domain in domains.iter().flatten() {
        if domain.lift_profiles.is_none() {
            return Err(G133SparseError::SemanticMismatch);
        }
        if let Some(representative) = representatives
            .iter()
            .copied()
            .find(|candidate| candidate.lift_hash == domain.lift_hash)
        {
            if !lift_domain_equal(representative, domain) {
                return Err(G133SparseError::SemanticMismatch);
            }
        } else {
            representatives.push(domain);
        }
    }
    Ok(representatives)
}

fn lift_class_map(
    domains: &[Option<EnergyDomain>],
    representatives: &[&EnergyDomain],
) -> Result<[u16; 1 << SLOTS], G133SparseError> {
    let mut classes = [u16::MAX; 1 << SLOTS];
    for (mask, domain) in domains.iter().enumerate() {
        let Some(domain) = domain else {
            continue;
        };
        let class = representatives
            .iter()
            .position(|representative| {
                representative.lift_hash == domain.lift_hash
                    && lift_domain_equal(representative, domain)
            })
            .ok_or(G133SparseError::SemanticMismatch)?;
        classes[mask] = u16::try_from(class).map_err(|_| G133SparseError::StateBudget)?;
    }
    Ok(classes)
}

fn lift_key_profiles(domain: &EnergyDomain) -> Result<Box<[LiftKeyProfile]>, G133SparseError> {
    let profiles = domain
        .lift_profiles
        .as_deref()
        .ok_or(G133SparseError::SemanticMismatch)?;
    let mut output = Vec::<LiftKeyProfile>::with_capacity(domain.q1_profiles.len());
    for profile in profiles {
        let energy = (profile.state >> 29) as u8;
        let q1 = ((profile.state >> 16) & 0x1fff) as u16;
        let signature = profile.state as u8;
        if output
            .last()
            .is_none_or(|previous| previous.energy != energy || previous.q1 != q1)
        {
            if output.len() == MAX_Q1_PROFILES_PER_DOMAIN {
                return Err(G133SparseError::StateBudget);
            }
            output.push(LiftKeyProfile {
                signatures: [0; 4],
                q1,
                energy,
                reserved: [0; 5],
            });
        }
        let current = output.last_mut().ok_or(G133SparseError::SemanticMismatch)?;
        current.signatures[usize::from(signature >> 6)] |= 1_u64 << (signature & 63);
    }
    Ok(output.into_boxed_slice())
}

fn compile_lift_pair_profiles(
    first: &[LiftKeyProfile],
    second: &[LiftKeyProfile],
    positions: &mut [u32],
    touched: &mut Vec<usize>,
) -> Result<Box<[LiftPairProfile]>, G133SparseError> {
    let mut profiles = Vec::<LiftPairProfile>::with_capacity(MAX_PAIR_PROFILES);
    for left in first {
        for right in second {
            let energy = left
                .energy
                .checked_add(right.energy)
                .ok_or(G133SparseError::SemanticMismatch)?;
            if usize::from(energy) > DEFECT_TARGET {
                continue;
            }
            let q1 = left
                .q1
                .checked_add(right.q1)
                .ok_or(G133SparseError::SemanticMismatch)?;
            if usize::from(q1) >= 2 * Q1_LIMIT {
                return Err(G133SparseError::StateBudget);
            }
            let key = usize::from(energy) * (2 * Q1_LIMIT) + usize::from(q1);
            let position = positions[key];
            let output = if position == u32::MAX {
                if profiles.len() == MAX_PAIR_PROFILES || touched.len() == MAX_PAIR_PROFILES {
                    return Err(G133SparseError::StateBudget);
                }
                positions[key] =
                    u32::try_from(profiles.len()).map_err(|_| G133SparseError::StateBudget)?;
                touched.push(key);
                profiles.push(LiftPairProfile {
                    signatures: [0; 4],
                    q1,
                    energy,
                    reserved: [0; 5],
                });
                profiles
                    .last_mut()
                    .ok_or(G133SparseError::SemanticMismatch)?
            } else {
                profiles
                    .get_mut(position as usize)
                    .ok_or(G133SparseError::SemanticMismatch)?
            };
            xor_sumset_256_into(
                &mut output.signatures,
                &left.signatures,
                &right.signatures,
                0,
            );
        }
    }
    for &key in touched.iter() {
        positions[key] = u32::MAX;
    }
    touched.clear();
    profiles.sort_unstable_by_key(|profile| (profile.energy, profile.q1));
    Ok(profiles.into_boxed_slice())
}

fn g133_mod8_target_signature(masks: [u16; 4]) -> Result<u8, G133SparseError> {
    let words = masks.map(binary_word);
    let mut signature = 0_u8;
    for shift in 2..SHIFTS {
        let base = words.iter().map(|word| paf(word, shift)).sum::<u32>();
        let difference = (15_080_i64 - i64::from(base)).rem_euclid(8);
        if difference & 3 != 0 {
            return Err(G133SparseError::SemanticMismatch);
        }
        signature |= ((difference >> 2) as u8) << (shift - 2);
    }
    Ok(signature)
}

fn g133_mod16_target_signature(masks: [u16; 4]) -> Result<u16, G133SparseError> {
    let words = masks.map(binary_word);
    let mut signature = 0_u16;
    for shift in 2..SHIFTS {
        let base = words.iter().map(|word| paf(word, shift)).sum::<u32>();
        let difference = (15_080_i64 - i64::from(base)).rem_euclid(16);
        if difference & 3 != 0 {
            return Err(G133SparseError::SemanticMismatch);
        }
        signature |= ((difference >> 2) as u16) << (2 * (shift - 2));
    }
    Ok(signature)
}

fn split_mod16_lift_signature(signature: u16) -> (u8, u8) {
    let mut low = 0_u8;
    let mut high = 0_u8;
    for coordinate in 0..8 {
        let digit = ((signature >> (2 * coordinate)) & 3) as u8;
        low |= (digit & 1) << coordinate;
        high |= (digit >> 1) << coordinate;
    }
    (low, high)
}

fn mod16_dense_block_keys(domain: &EnergyDomain) -> Result<Vec<Mod16DenseKey>, G133SparseError> {
    let profiles = domain
        .lift_profiles
        .as_deref()
        .ok_or(G133SparseError::SemanticMismatch)?;
    let mut output = Vec::<Mod16DenseKey>::with_capacity(MAX_Q1_PROFILES_PER_DOMAIN);
    for profile in profiles {
        let energy = (profile.state >> 29) as u8;
        let q1 = ((profile.state >> 16) & 0x1fff) as u16;
        if output
            .last()
            .is_none_or(|previous| previous.energy != energy || previous.q1 != q1)
        {
            if output.len() == MAX_Q1_PROFILES_PER_DOMAIN {
                return Err(G133SparseError::StateBudget);
            }
            output.push(Mod16DenseKey {
                fibres: [[0; 4]; 256],
                q1,
                energy,
                reserved: [0; 5],
            });
        }
        let signature = profile.state as u16;
        let (low, high) = split_mod16_lift_signature(signature);
        let current = output.last_mut().ok_or(G133SparseError::SemanticMismatch)?;
        current.fibres[usize::from(low)][usize::from(high >> 6)] |= 1_u64 << (high & 63);
    }
    Ok(output)
}

fn compile_mod16_dense_pair_keys(
    first: &[Mod16DenseKey],
    second: &[Mod16DenseKey],
    positions: &mut [u32],
    touched: &mut Vec<usize>,
) -> Result<Vec<Mod16DenseKey>, G133SparseError> {
    let mut output = Vec::<Mod16DenseKey>::with_capacity(MAX_PAIR_PROFILES);
    for left in first {
        for right in second {
            let energy = left
                .energy
                .checked_add(right.energy)
                .ok_or(G133SparseError::SemanticMismatch)?;
            if usize::from(energy) > DEFECT_TARGET {
                continue;
            }
            let q1 = left
                .q1
                .checked_add(right.q1)
                .ok_or(G133SparseError::SemanticMismatch)?;
            if usize::from(q1) >= 2 * Q1_LIMIT {
                return Err(G133SparseError::StateBudget);
            }
            let index = usize::from(energy) * (2 * Q1_LIMIT) + usize::from(q1);
            let position = positions[index];
            let pair = if position == u32::MAX {
                if output.len() == MAX_PAIR_PROFILES || touched.len() == MAX_PAIR_PROFILES {
                    return Err(G133SparseError::StateBudget);
                }
                positions[index] =
                    u32::try_from(output.len()).map_err(|_| G133SparseError::StateBudget)?;
                touched.push(index);
                output.push(Mod16DenseKey {
                    fibres: [[0; 4]; 256],
                    q1,
                    energy,
                    reserved: [0; 5],
                });
                output.last_mut().ok_or(G133SparseError::SemanticMismatch)?
            } else {
                output
                    .get_mut(position as usize)
                    .ok_or(G133SparseError::SemanticMismatch)?
            };
            for left_low in 0_u16..=255 {
                let left_high = &left.fibres[usize::from(left_low)];
                if left_high.iter().all(|&word| word == 0) {
                    continue;
                }
                for right_low in 0_u16..=255 {
                    let right_high = &right.fibres[usize::from(right_low)];
                    if right_high.iter().all(|&word| word == 0) {
                        continue;
                    }
                    let low = (left_low ^ right_low) as u8;
                    let carry = (left_low & right_low) as u8;
                    xor_sumset_256_into(
                        &mut pair.fibres[usize::from(low)],
                        left_high,
                        right_high,
                        carry,
                    );
                }
            }
        }
    }
    for &index in touched.iter() {
        positions[index] = u32::MAX;
    }
    touched.clear();
    output.sort_unstable_by_key(|profile| (profile.energy, profile.q1));
    Ok(output)
}

fn dense_key_signature_count(key: &Mod16DenseKey) -> u32 {
    key.fibres
        .iter()
        .flatten()
        .map(|word| word.count_ones())
        .sum()
}

fn join_signature_mod4(left: u16, right: u16) -> u16 {
    let mut output = 0_u16;
    for coordinate in 0..8 {
        let shift = 2 * coordinate;
        let digit = ((left >> shift) & 3) + ((right >> shift) & 3);
        output |= (digit & 3) << shift;
    }
    output
}

fn complement_signature_mod4(value: u16, target: u16) -> u16 {
    let mut output = 0_u16;
    for coordinate in 0..8 {
        let shift = 2 * coordinate;
        let value_digit = (value >> shift) & 3;
        let target_digit = (target >> shift) & 3;
        output |= ((target_digit + 4 - value_digit) & 3) << shift;
    }
    output
}

fn compress_mod16_dense_pairs(
    dense: &[Mod16DenseKey],
) -> Result<Mod16SparsePairDomain, G133SparseError> {
    const MAX_SIGNATURES: usize = 1 << 22;
    let mut keys = Vec::with_capacity(dense.len());
    let mut signatures = Vec::<u16>::new();
    signatures
        .try_reserve_exact(dense.len().saturating_mul(64).min(MAX_SIGNATURES))
        .map_err(|_| G133SparseError::StateBudget)?;
    for profile in dense {
        let offset = u32::try_from(signatures.len()).map_err(|_| G133SparseError::StateBudget)?;
        for low in 0_u16..=255 {
            for (word_index, &word) in profile.fibres[usize::from(low)].iter().enumerate() {
                let mut bits = word;
                while bits != 0 {
                    let high = (word_index * 64 + bits.trailing_zeros() as usize) as u8;
                    bits &= bits - 1;
                    let mut signature = 0_u16;
                    for coordinate in 0..8 {
                        let digit =
                            ((low >> coordinate) & 1) | (u16::from((high >> coordinate) & 1) << 1);
                        signature |= digit << (2 * coordinate);
                    }
                    if signatures.len() == MAX_SIGNATURES {
                        return Err(G133SparseError::StateBudget);
                    }
                    signatures.push(signature);
                }
            }
        }
        let len = signatures.len() - offset as usize;
        if len > usize::from(u8::MAX) {
            return Err(G133SparseError::StateBudget);
        }
        signatures[offset as usize..].sort_unstable();
        keys.push(Mod16SparsePairKey {
            offset,
            q1: profile.q1,
            energy: profile.energy,
            len: len as u8,
        });
    }
    Ok(Mod16SparsePairDomain {
        keys: keys.into_boxed_slice(),
        signatures: signatures.into_boxed_slice(),
    })
}

fn sparse_pair_signatures<'a>(
    domain: &'a Mod16SparsePairDomain,
    key: &Mod16SparsePairKey,
) -> Result<&'a [u16], G133SparseError> {
    let begin = key.offset as usize;
    let end = begin + usize::from(key.len);
    domain
        .signatures
        .get(begin..end)
        .ok_or(G133SparseError::SemanticMismatch)
}

fn mod16_pair_domains_compatible(
    left: &Mod16SparsePairDomain,
    right: &Mod16SparsePairDomain,
    target: u16,
) -> Result<(bool, bool), G133SparseError> {
    let mut q0_q1 = false;
    for left_key in left.keys.iter() {
        if usize::from(left_key.energy) > DEFECT_TARGET || u32::from(left_key.q1) > 15_080 {
            continue;
        }
        let required = (
            (DEFECT_TARGET - usize::from(left_key.energy)) as u8,
            (15_080 - u32::from(left_key.q1)) as u16,
        );
        let Ok(position) = right
            .keys
            .binary_search_by_key(&required, |key| (key.energy, key.q1))
        else {
            continue;
        };
        q0_q1 = true;
        let left_signatures = sparse_pair_signatures(left, left_key)?;
        let right_signatures = sparse_pair_signatures(right, &right.keys[position])?;
        for &left_signature in left_signatures {
            let required_signature = complement_signature_mod4(left_signature, target);
            if right_signatures.binary_search(&required_signature).is_ok() {
                debug_assert_eq!(
                    join_signature_mod4(left_signature, required_signature),
                    target
                );
                return Ok((true, true));
            }
        }
    }
    Ok((q0_q1, false))
}

fn q2_dense_block_keys(domain: &EnergyDomain) -> Result<Vec<Q2DenseKey>, G133SparseError> {
    let profiles = domain
        .q2_profiles
        .as_deref()
        .ok_or(G133SparseError::SemanticMismatch)?;
    let mut output = Vec::<Q2DenseKey>::with_capacity(MAX_Q1_PROFILES_PER_DOMAIN);
    for profile in profiles {
        let energy = ((profile.state >> 26) & 127) as u8;
        let q1 = ((profile.state >> 13) & 0x1fff) as u16;
        let q2 = (profile.state & 0x1fff) as usize;
        if output
            .last()
            .is_none_or(|previous| previous.energy != energy || previous.q1 != q1)
        {
            if output.len() == MAX_Q1_PROFILES_PER_DOMAIN {
                return Err(G133SparseError::StateBudget);
            }
            output.push(Q2DenseKey {
                values: [0; 256],
                q1,
                energy,
                reserved: [0; 5],
            });
        }
        let current = output.last_mut().ok_or(G133SparseError::SemanticMismatch)?;
        current.values[q2 / 64] |= 1_u64 << (q2 % 64);
    }
    Ok(output)
}

fn compile_q2_dense_pair_keys(
    first: &[Q2DenseKey],
    second: &[Q2DenseKey],
    positions: &mut [u32],
    touched: &mut Vec<usize>,
) -> Result<Vec<Q2DenseKey>, G133SparseError> {
    let mut output = Vec::<Q2DenseKey>::with_capacity(MAX_PAIR_PROFILES);
    for left in first {
        for right in second {
            let energy = left
                .energy
                .checked_add(right.energy)
                .ok_or(G133SparseError::SemanticMismatch)?;
            if usize::from(energy) > DEFECT_TARGET {
                continue;
            }
            let q1 = left
                .q1
                .checked_add(right.q1)
                .ok_or(G133SparseError::SemanticMismatch)?;
            if usize::from(q1) >= 2 * Q1_LIMIT {
                return Err(G133SparseError::StateBudget);
            }
            let index = usize::from(energy) * (2 * Q1_LIMIT) + usize::from(q1);
            let position = positions[index];
            let pair = if position == u32::MAX {
                if output.len() == MAX_PAIR_PROFILES || touched.len() == MAX_PAIR_PROFILES {
                    return Err(G133SparseError::StateBudget);
                }
                positions[index] =
                    u32::try_from(output.len()).map_err(|_| G133SparseError::StateBudget)?;
                touched.push(index);
                output.push(Q2DenseKey {
                    values: [0; 256],
                    q1,
                    energy,
                    reserved: [0; 5],
                });
                output.last_mut().ok_or(G133SparseError::SemanticMismatch)?
            } else {
                output
                    .get_mut(position as usize)
                    .ok_or(G133SparseError::SemanticMismatch)?
            };
            for (left_word_index, &left_word) in left.values.iter().enumerate() {
                let mut left_bits = left_word;
                while left_bits != 0 {
                    let left_value = left_word_index * 64 + left_bits.trailing_zeros() as usize;
                    left_bits &= left_bits - 1;
                    for (right_word_index, &right_word) in right.values.iter().enumerate() {
                        let mut right_bits = right_word;
                        while right_bits != 0 {
                            let right_value =
                                right_word_index * 64 + right_bits.trailing_zeros() as usize;
                            right_bits &= right_bits - 1;
                            let value = left_value + right_value;
                            if value >= 16_384 {
                                return Err(G133SparseError::StateBudget);
                            }
                            pair.values[value / 64] |= 1_u64 << (value % 64);
                        }
                    }
                }
            }
        }
    }
    for &index in touched.iter() {
        positions[index] = u32::MAX;
    }
    touched.clear();
    output.sort_unstable_by_key(|profile| (profile.energy, profile.q1));
    Ok(output)
}

fn or_shifted_q2_bitset(output: &mut [u64; 256], input: &[u64; 256], shift: usize) {
    let word_shift = shift / 64;
    let bit_shift = shift % 64;
    for (source, &word) in input.iter().enumerate() {
        if word == 0 || source + word_shift >= output.len() {
            continue;
        }
        output[source + word_shift] |= word << bit_shift;
        if bit_shift != 0 && source + word_shift + 1 < output.len() {
            output[source + word_shift + 1] |= word >> (64 - bit_shift);
        }
    }
}

fn compile_q2_dense_pair_keys_shift_oracle(
    first: &[Q2DenseKey],
    second: &[Q2DenseKey],
    positions: &mut [u32],
    touched: &mut Vec<usize>,
) -> Result<Vec<Q2DenseKey>, G133SparseError> {
    let mut output = Vec::<Q2DenseKey>::with_capacity(MAX_PAIR_PROFILES);
    for left in first {
        for right in second {
            let energy = left
                .energy
                .checked_add(right.energy)
                .ok_or(G133SparseError::SemanticMismatch)?;
            if usize::from(energy) > DEFECT_TARGET {
                continue;
            }
            let q1 = left
                .q1
                .checked_add(right.q1)
                .ok_or(G133SparseError::SemanticMismatch)?;
            if usize::from(q1) >= 2 * Q1_LIMIT {
                return Err(G133SparseError::StateBudget);
            }
            let index = usize::from(energy) * (2 * Q1_LIMIT) + usize::from(q1);
            let position = positions[index];
            let pair = if position == u32::MAX {
                if output.len() == MAX_PAIR_PROFILES || touched.len() == MAX_PAIR_PROFILES {
                    return Err(G133SparseError::StateBudget);
                }
                positions[index] =
                    u32::try_from(output.len()).map_err(|_| G133SparseError::StateBudget)?;
                touched.push(index);
                output.push(Q2DenseKey {
                    values: [0; 256],
                    q1,
                    energy,
                    reserved: [0; 5],
                });
                output.last_mut().ok_or(G133SparseError::SemanticMismatch)?
            } else {
                output
                    .get_mut(position as usize)
                    .ok_or(G133SparseError::SemanticMismatch)?
            };
            for (word_index, &word) in left.values.iter().enumerate() {
                let mut bits = word;
                while bits != 0 {
                    let value = word_index * 64 + bits.trailing_zeros() as usize;
                    bits &= bits - 1;
                    or_shifted_q2_bitset(&mut pair.values, &right.values, value);
                }
            }
        }
    }
    for &index in touched.iter() {
        positions[index] = u32::MAX;
    }
    touched.clear();
    output.sort_unstable_by_key(|profile| (profile.energy, profile.q1));
    Ok(output)
}

fn q2_pair_shape(profiles: &[Q2DenseKey]) -> (u32, u64, u32) {
    let mut intervals = 0_u32;
    let mut relaxation_excess = 0_u64;
    let mut maximum_excess = 0_u32;
    for profile in profiles {
        let minimum = profile
            .values
            .iter()
            .position(|&word| word != 0)
            .map(|word| word * 64 + profile.values[word].trailing_zeros() as usize)
            .unwrap_or(0);
        let maximum = profile
            .values
            .iter()
            .rposition(|&word| word != 0)
            .map(|word| word * 64 + 63 - profile.values[word].leading_zeros() as usize)
            .unwrap_or(0);
        let exact = profile
            .values
            .iter()
            .map(|word| word.count_ones())
            .sum::<u32>();
        intervals += u32::from(exact as usize == maximum - minimum + 1);
        let mut residues = 0_u64;
        for value in minimum..=maximum {
            if profile.values[value / 64] & (1_u64 << (value % 64)) != 0 {
                residues |= 1_u64 << (value % 64);
            }
        }
        let relaxed = (minimum..=maximum)
            .filter(|value| residues & (1_u64 << (value % 64)) != 0)
            .count() as u32;
        let excess = relaxed - exact;
        relaxation_excess += u64::from(excess);
        maximum_excess = maximum_excess.max(excess);
    }
    (intervals, relaxation_excess, maximum_excess)
}

fn compress_q2_dense_pairs(
    dense: &[Q2DenseKey],
) -> Result<ScalarSparsePairDomain, G133SparseError> {
    // Exact set identity: S = ([min,max] intersect R) minus H, where R is
    // the observed residue set modulo 64 and H is the sorted list of holes.
    // The dense compiler remains the authority; this is only its bounded
    // representation.  Membership and sum witnesses allocate nothing.
    const MAX_HOLES: usize = 1 << 24;
    let mut keys = Vec::with_capacity(dense.len());
    let mut holes = Vec::<u16>::new();
    holes
        .try_reserve_exact(dense.len().saturating_mul(16).min(MAX_HOLES))
        .map_err(|_| G133SparseError::StateBudget)?;
    for profile in dense {
        let minimum = profile
            .values
            .iter()
            .position(|&word| word != 0)
            .map(|word| word * 64 + profile.values[word].trailing_zeros() as usize)
            .ok_or(G133SparseError::SemanticMismatch)?;
        let maximum = profile
            .values
            .iter()
            .rposition(|&word| word != 0)
            .map(|word| word * 64 + 63 - profile.values[word].leading_zeros() as usize)
            .ok_or(G133SparseError::SemanticMismatch)?;
        let exact_len = profile
            .values
            .iter()
            .map(|word| word.count_ones())
            .sum::<u32>();
        let mut residues = 0_u64;
        for (word_index, &word) in profile.values.iter().enumerate() {
            let mut bits = word;
            while bits != 0 {
                let value = word_index * 64 + bits.trailing_zeros() as usize;
                bits &= bits - 1;
                residues |= 1_u64 << (value & 63);
            }
        }
        let offset = u32::try_from(holes.len()).map_err(|_| G133SparseError::StateBudget)?;
        for value in minimum..=maximum {
            if residues & (1_u64 << (value & 63)) != 0
                && profile.values[value / 64] & (1_u64 << (value & 63)) == 0
            {
                if holes.len() == MAX_HOLES {
                    return Err(G133SparseError::StateBudget);
                }
                holes.push(u16::try_from(value).map_err(|_| G133SparseError::StateBudget)?);
            }
        }
        let holes_len = holes.len() - offset as usize;
        keys.push(ScalarSparsePairKey {
            residues,
            offset,
            q1: profile.q1,
            minimum: u16::try_from(minimum).map_err(|_| G133SparseError::StateBudget)?,
            maximum: u16::try_from(maximum).map_err(|_| G133SparseError::StateBudget)?,
            holes_len: u16::try_from(holes_len).map_err(|_| G133SparseError::StateBudget)?,
            exact_len: u16::try_from(exact_len).map_err(|_| G133SparseError::StateBudget)?,
            energy: profile.energy,
            reserved: [0; 7],
        });
    }
    Ok(ScalarSparsePairDomain {
        keys: keys.into_boxed_slice(),
        holes: holes.into_boxed_slice(),
    })
}

fn scalar_pair_holes<'a>(
    domain: &'a ScalarSparsePairDomain,
    key: &ScalarSparsePairKey,
) -> Result<&'a [u16], G133SparseError> {
    let begin = key.offset as usize;
    let end = begin + usize::from(key.holes_len);
    domain
        .holes
        .get(begin..end)
        .ok_or(G133SparseError::SemanticMismatch)
}

fn scalar_pair_exact_values(domain: &ScalarSparsePairDomain) -> u64 {
    domain.keys.iter().map(|key| u64::from(key.exact_len)).sum()
}

fn scalar_pair_shape_features(domain: &ScalarSparsePairDomain) -> (u32, u32, u16, u32) {
    let mut interval_keys = 0_u32;
    let mut maximum_holes = 0_u16;
    let mut residue_bits = 0_u32;
    for key in domain.keys.iter() {
        interval_keys +=
            u32::from(u32::from(key.exact_len) == u32::from(key.maximum - key.minimum) + 1);
        maximum_holes = maximum_holes.max(key.holes_len);
        residue_bits += key.residues.count_ones();
    }
    (
        domain.holes.len() as u32,
        interval_keys,
        maximum_holes,
        residue_bits,
    )
}

#[cfg(test)]
#[inline(always)]
fn scalar_pair_contains(holes: &[u16], key: &ScalarSparsePairKey, value: u16) -> bool {
    value >= key.minimum
        && value <= key.maximum
        && key.residues & (1_u64 << (value & 63)) != 0
        && holes.binary_search(&value).is_err()
}

fn scalar_pair_sum_witness(
    left: &ScalarSparsePairDomain,
    left_key: &ScalarSparsePairKey,
    right: &ScalarSparsePairDomain,
    right_key: &ScalarSparsePairKey,
    target: u16,
) -> Result<Option<u16>, G133SparseError> {
    if u32::from(target) < u32::from(left_key.minimum) + u32::from(right_key.minimum)
        || u32::from(target) > u32::from(left_key.maximum) + u32::from(right_key.maximum)
    {
        return Ok(None);
    }
    let minimum = left_key
        .minimum
        .max(target.saturating_sub(right_key.maximum));
    let maximum = left_key
        .maximum
        .min(target.saturating_sub(right_key.minimum));
    if minimum > maximum {
        return Ok(None);
    }
    let left_holes = scalar_pair_holes(left, left_key)?;
    let right_holes = scalar_pair_holes(right, right_key)?;
    for residue in 0_u16..64 {
        let right_residue = target.wrapping_sub(residue) & 63;
        if left_key.residues & (1_u64 << residue) == 0
            || right_key.residues & (1_u64 << right_residue) == 0
        {
            continue;
        }
        let delta = residue.wrapping_sub(minimum & 63) & 63;
        let mut value = minimum + delta;
        while value <= maximum {
            let complement = target - value;
            if left_holes.binary_search(&value).is_err()
                && right_holes.binary_search(&complement).is_err()
            {
                return Ok(Some(value));
            }
            let Some(next) = value.checked_add(64) else {
                break;
            };
            value = next;
        }
    }
    Ok(None)
}

fn scalar_pair_base_sum_possible(
    left_key: &ScalarSparsePairKey,
    right_key: &ScalarSparsePairKey,
    target: u16,
) -> bool {
    if u32::from(target) < u32::from(left_key.minimum) + u32::from(right_key.minimum)
        || u32::from(target) > u32::from(left_key.maximum) + u32::from(right_key.maximum)
    {
        return false;
    }
    let minimum = left_key
        .minimum
        .max(target.saturating_sub(right_key.maximum));
    let maximum = left_key
        .maximum
        .min(target.saturating_sub(right_key.minimum));
    for residue in 0_u16..64 {
        let right_residue = target.wrapping_sub(residue) & 63;
        if left_key.residues & (1_u64 << residue) == 0
            || right_key.residues & (1_u64 << right_residue) == 0
        {
            continue;
        }
        let delta = residue.wrapping_sub(minimum & 63) & 63;
        if minimum + delta <= maximum {
            return true;
        }
    }
    false
}

fn scalar_pair_sumset_counts(
    left: &ScalarSparsePairDomain,
    right: &ScalarSparsePairDomain,
) -> Result<(u32, u32), G133SparseError> {
    let mut base_pairs = 0_u32;
    let mut hole_covered_pairs = 0_u32;
    for left_key in left.keys.iter() {
        if usize::from(left_key.energy) > DEFECT_TARGET || u32::from(left_key.q1) > 15_080 {
            continue;
        }
        let required = (
            (DEFECT_TARGET - usize::from(left_key.energy)) as u8,
            (15_080 - u32::from(left_key.q1)) as u16,
        );
        let Ok(position) = right
            .keys
            .binary_search_by_key(&required, |key| (key.energy, key.q1))
        else {
            continue;
        };
        let right_key = &right.keys[position];
        if !scalar_pair_base_sum_possible(left_key, right_key, 15_080) {
            continue;
        }
        base_pairs = base_pairs
            .checked_add(1)
            .ok_or(G133SparseError::StateBudget)?;
        if scalar_pair_sum_witness(left, left_key, right, right_key, 15_080)?.is_none() {
            hole_covered_pairs = hole_covered_pairs
                .checked_add(1)
                .ok_or(G133SparseError::StateBudget)?;
        }
    }
    Ok((base_pairs, hole_covered_pairs))
}

fn q2_state_components(state: u64) -> (u8, u16, u16) {
    (
        ((state >> 26) & 127) as u8,
        ((state >> 13) & 0x1fff) as u16,
        (state & 0x1fff) as u16,
    )
}

fn reconstruct_q2_pair(
    first: &EnergyDomain,
    second: &EnergyDomain,
    target: (u8, u16, u16),
) -> Result<[u64; 2], G133SparseError> {
    let first_profiles = first
        .q2_profiles
        .as_deref()
        .ok_or(G133SparseError::SemanticMismatch)?;
    let second_profiles = second
        .q2_profiles
        .as_deref()
        .ok_or(G133SparseError::SemanticMismatch)?;
    for profile in first_profiles {
        let (energy, q1, q2) = q2_state_components(profile.state);
        if energy > target.0 || q1 > target.1 || q2 > target.2 {
            continue;
        }
        let required = ((u64::from(target.0 - energy)) << 26)
            | ((u64::from(target.1 - q1)) << 13)
            | u64::from(target.2 - q2);
        if second_profiles
            .binary_search_by_key(&required, |candidate| candidate.state)
            .is_ok()
        {
            return Ok([profile.state, required]);
        }
    }
    Err(G133SparseError::SemanticMismatch)
}

fn q2_digits(domain: &EnergyDomain, state: u64) -> Result<u32, G133SparseError> {
    let profiles = domain
        .q2_profiles
        .as_deref()
        .ok_or(G133SparseError::SemanticMismatch)?;
    let position = profiles
        .binary_search_by_key(&state, |profile| profile.state)
        .map_err(|_| G133SparseError::SemanticMismatch)?;
    Ok(profiles[position].digits)
}

fn q2_class_witness(
    left: &ScalarSparsePairDomain,
    right: &ScalarSparsePairDomain,
    domains: [&EnergyDomain; 4],
) -> Result<(bool, Option<Q2ClassWitness>), G133SparseError> {
    let mut q0_q1 = false;
    for left_key in left.keys.iter() {
        if usize::from(left_key.energy) > DEFECT_TARGET || u32::from(left_key.q1) > 15_080 {
            continue;
        }
        let required = (
            (DEFECT_TARGET - usize::from(left_key.energy)) as u8,
            (15_080 - u32::from(left_key.q1)) as u16,
        );
        let Ok(position) = right
            .keys
            .binary_search_by_key(&required, |key| (key.energy, key.q1))
        else {
            continue;
        };
        q0_q1 = true;
        let right_key = &right.keys[position];
        if let Some(left_value) = scalar_pair_sum_witness(left, left_key, right, right_key, 15_080)?
        {
            let right_value = 15_080 - left_value;
            let left_states = reconstruct_q2_pair(
                domains[0],
                domains[1],
                (left_key.energy, left_key.q1, left_value),
            )?;
            let right_states = reconstruct_q2_pair(
                domains[2],
                domains[3],
                (
                    right.keys[position].energy,
                    right.keys[position].q1,
                    right_value,
                ),
            )?;
            return Ok((
                true,
                Some(Q2ClassWitness {
                    states: [
                        left_states[0],
                        left_states[1],
                        right_states[0],
                        right_states[1],
                    ],
                }),
            ));
        }
    }
    Ok((q0_q1, None))
}

fn q2_residue_profiles(domain: &EnergyDomain) -> Result<Box<[Q2ResidueProfile]>, G133SparseError> {
    let exact = domain
        .q2_profiles
        .as_deref()
        .ok_or(G133SparseError::SemanticMismatch)?;
    let mut profiles = Vec::with_capacity(domain.q1_profiles.len());
    for profile in domain.q1_profiles.iter() {
        profiles.push(Q2ResidueProfile {
            residues: 0,
            q1: profile.q1,
            minimum: u16::MAX,
            maximum: 0,
            energy: profile.energy,
            reserved: 0,
        });
    }
    let mut index = 0_usize;
    for profile in exact {
        let energy = ((profile.state >> 26) & 127) as u8;
        let q1 = ((profile.state >> 13) & 8_191) as u16;
        let q2 = (profile.state & 8_191) as u16;
        while index < profiles.len() && (profiles[index].energy, profiles[index].q1) < (energy, q1)
        {
            index += 1;
        }
        if index == profiles.len() || (profiles[index].energy, profiles[index].q1) != (energy, q1) {
            return Err(G133SparseError::SemanticMismatch);
        }
        profiles[index].residues |= 1_u64 << (q2 % 64);
        profiles[index].minimum = profiles[index].minimum.min(q2);
        profiles[index].maximum = profiles[index].maximum.max(q2);
    }
    if profiles
        .iter()
        .any(|profile| profile.residues == 0 || profile.minimum > profile.maximum)
    {
        return Err(G133SparseError::SemanticMismatch);
    }
    Ok(profiles.into_boxed_slice())
}

fn residue_sumset64(mut left: u64, right: u64) -> u64 {
    let mut output = 0_u64;
    while left != 0 && output != u64::MAX {
        let shift = left.trailing_zeros();
        left &= left - 1;
        output |= right.rotate_left(shift);
    }
    output
}

fn compile_q2_pair_residues(
    first: &[Q2ResidueProfile],
    second: &[Q2ResidueProfile],
    positions: &mut [u32],
    touched: &mut Vec<usize>,
) -> Result<Box<[Q2PairResidueProfile]>, G133SparseError> {
    touched.clear();
    let mut profiles = Vec::with_capacity(MAX_PAIR_PROFILES);
    for left in first {
        for right in second {
            let Some(energy) = left.energy.checked_add(right.energy) else {
                return Err(G133SparseError::SemanticMismatch);
            };
            if usize::from(energy) > DEFECT_TARGET {
                continue;
            }
            let Some(q1) = left.q1.checked_add(right.q1) else {
                return Err(G133SparseError::SemanticMismatch);
            };
            if usize::from(q1) >= 2 * Q1_LIMIT {
                return Err(G133SparseError::StateBudget);
            }
            let state = usize::from(energy) * (2 * Q1_LIMIT) + usize::from(q1);
            let residues = residue_sumset64(left.residues, right.residues);
            let minimum = left
                .minimum
                .checked_add(right.minimum)
                .ok_or(G133SparseError::SemanticMismatch)?;
            let maximum = left
                .maximum
                .checked_add(right.maximum)
                .ok_or(G133SparseError::SemanticMismatch)?;
            let position = positions[state];
            if position == u32::MAX {
                if profiles.len() == MAX_PAIR_PROFILES || touched.len() == MAX_PAIR_PROFILES {
                    return Err(G133SparseError::StateBudget);
                }
                positions[state] =
                    u32::try_from(profiles.len()).map_err(|_| G133SparseError::StateBudget)?;
                touched.push(state);
                profiles.push(Q2PairResidueProfile {
                    residues,
                    q1,
                    minimum,
                    maximum,
                    energy,
                    reserved: 0,
                });
            } else {
                let profile = &mut profiles[position as usize];
                profile.residues |= residues;
                profile.minimum = profile.minimum.min(minimum);
                profile.maximum = profile.maximum.max(maximum);
            }
        }
    }
    for &state in touched.iter() {
        positions[state] = u32::MAX;
    }
    profiles.sort_unstable_by_key(|profile| (profile.energy, profile.q1));
    Ok(profiles.into_boxed_slice())
}

/// Joint q2--q9 mod-eight lift scout above exact row/q0/q1 constraints.
///
/// Every block state stores the eight one-bit lift coordinates derived from
/// the canonical mod-four word.  Pair images are 256-bit XOR sumsets indexed
/// by exact `(energy,q1)`, so the four-block join is same-witness rather than
/// an intersection of scalar marginals.  This first scout is discovery-only:
/// exclusions require the independent reconstruction/replay gate.
pub fn scout_g133_sparse_joint_mod8() -> Result<G133SparseJointMod8Report, G133SparseError> {
    verify_projection()?;
    let (special_profiles, zero_profiles, right_frontier) = compile_mod4_frontier();
    let mut special: [Option<EnergyDomain>; 1 << SLOTS] = std::array::from_fn(|_| None);
    let mut zero: [Option<EnergyDomain>; 1 << SLOTS] = std::array::from_fn(|_| None);
    let mut minimum_domain_profiles = u32::MAX;
    let mut maximum_domain_profiles = 0_u32;
    let mut total_domain_profiles = 0_u64;
    for (profiles, domains, row_target) in [
        (&special_profiles, &mut special, 260_u16),
        (&zero_profiles, &mut zero, 261_u16),
    ] {
        for profile in profiles {
            let slot = &mut domains[usize::from(profile.mask)];
            if slot.is_some() {
                continue;
            }
            let domain = compile_energy_domain(profile.mask, row_target, None, 1)?;
            let count = u32::try_from(
                domain
                    .lift_profiles
                    .as_ref()
                    .ok_or(G133SparseError::SemanticMismatch)?
                    .len(),
            )
            .map_err(|_| G133SparseError::StateBudget)?;
            minimum_domain_profiles = minimum_domain_profiles.min(count);
            maximum_domain_profiles = maximum_domain_profiles.max(count);
            total_domain_profiles = total_domain_profiles
                .checked_add(u64::from(count))
                .ok_or(G133SparseError::StateBudget)?;
            if total_domain_profiles > MAX_TOTAL_Q2_PROFILES {
                return Err(G133SparseError::StateBudget);
            }
            *slot = Some(domain);
        }
    }

    let special_representatives = lift_class_representatives(&special)?;
    let zero_representatives = lift_class_representatives(&zero)?;
    let special_class_map = lift_class_map(&special, &special_representatives)?;
    let zero_class_map = lift_class_map(&zero, &zero_representatives)?;
    let mut special_keys = Vec::with_capacity(special_representatives.len());
    for domain in &special_representatives {
        special_keys.push(lift_key_profiles(domain)?);
    }
    let mut zero_keys = Vec::with_capacity(zero_representatives.len());
    for domain in &zero_representatives {
        zero_keys.push(lift_key_profiles(domain)?);
    }

    let mut positions = vec![u32::MAX; (DEFECT_TARGET + 1) * (2 * Q1_LIMIT)];
    let mut touched = Vec::with_capacity(MAX_PAIR_PROFILES);
    let mut special_zero_pairs =
        Vec::<Box<[LiftPairProfile]>>::with_capacity(special_keys.len() * zero_keys.len());
    let mut zero_zero_pairs =
        Vec::<Box<[LiftPairProfile]>>::with_capacity(zero_keys.len() * zero_keys.len());
    let mut minimum_pair_profiles = u32::MAX;
    let mut maximum_pair_profiles = 0_u32;
    let mut total_pair_profiles = 0_u64;
    for (left_classes, right_classes, pair_domains) in [
        (&special_keys, &zero_keys, &mut special_zero_pairs),
        (&zero_keys, &zero_keys, &mut zero_zero_pairs),
    ] {
        for left in left_classes {
            for right in right_classes {
                let profiles =
                    compile_lift_pair_profiles(left, right, &mut positions, &mut touched)?;
                let count =
                    u32::try_from(profiles.len()).map_err(|_| G133SparseError::StateBudget)?;
                minimum_pair_profiles = minimum_pair_profiles.min(count);
                maximum_pair_profiles = maximum_pair_profiles.max(count);
                total_pair_profiles = total_pair_profiles
                    .checked_add(u64::from(count))
                    .ok_or(G133SparseError::StateBudget)?;
                pair_domains.push(profiles);
            }
        }
    }

    let special_classes = special_keys.len();
    let zero_classes = zero_keys.len();
    let class_cells = special_classes
        .checked_mul(zero_classes)
        .and_then(|value| value.checked_mul(zero_classes))
        .and_then(|value| value.checked_mul(zero_classes))
        .ok_or(G133SparseError::StateBudget)?;
    if class_cells > 1 << 20 {
        return Err(G133SparseError::StateBudget);
    }
    let mut reachable = vec![[0_u64; 4]; class_cells];
    let mut compatible_class_quadruples = 0_u32;
    for special_class in 0..special_classes {
        for first_zero_class in 0..zero_classes {
            let left = &special_zero_pairs[special_class * zero_classes + first_zero_class];
            for second_zero_class in 0..zero_classes {
                for third_zero_class in 0..zero_classes {
                    let right =
                        &zero_zero_pairs[second_zero_class * zero_classes + third_zero_class];
                    let index = (((special_class * zero_classes + first_zero_class)
                        * zero_classes
                        + second_zero_class)
                        * zero_classes)
                        + third_zero_class;
                    for left_profile in left.iter() {
                        if usize::from(left_profile.energy) > DEFECT_TARGET
                            || u32::from(left_profile.q1) > 15_080
                        {
                            continue;
                        }
                        let required = (
                            (DEFECT_TARGET - usize::from(left_profile.energy)) as u8,
                            (15_080 - u32::from(left_profile.q1)) as u16,
                        );
                        let Ok(position) = right.binary_search_by_key(&required, |profile| {
                            (profile.energy, profile.q1)
                        }) else {
                            continue;
                        };
                        xor_sumset_256_into(
                            &mut reachable[index],
                            &left_profile.signatures,
                            &right[position].signatures,
                            0,
                        );
                    }
                    compatible_class_quadruples +=
                        u32::from(reachable[index].iter().any(|&word| word != 0));
                }
            }
        }
    }

    let mut roots = 0_u64;
    let mut q0_q1_roots = 0_u64;
    let mut survivors = 0_u64;
    let mut requested = vec![[0_u64; 4]; class_cells];
    for first in &special_profiles {
        for second in &zero_profiles {
            let required = complement_signature(add_signatures(first.signature, second.signature));
            let begin = right_frontier.partition_point(|pair| pair.signature < required);
            let end = right_frontier.partition_point(|pair| pair.signature <= required);
            for pair in &right_frontier[begin..end] {
                roots = roots.checked_add(1).ok_or(G133SparseError::StateBudget)?;
                let classes = [
                    usize::from(special_class_map[usize::from(first.mask)]),
                    usize::from(zero_class_map[usize::from(second.mask)]),
                    usize::from(zero_class_map[usize::from(pair.first)]),
                    usize::from(zero_class_map[usize::from(pair.second)]),
                ];
                if classes[0] >= special_classes
                    || classes[1..].iter().any(|&class| class >= zero_classes)
                {
                    return Err(G133SparseError::SemanticMismatch);
                }
                let index = (((classes[0] * zero_classes + classes[1]) * zero_classes
                    + classes[2])
                    * zero_classes)
                    + classes[3];
                if reachable[index].iter().all(|&word| word == 0) {
                    continue;
                }
                q0_q1_roots = q0_q1_roots
                    .checked_add(1)
                    .ok_or(G133SparseError::StateBudget)?;
                let target =
                    g133_mod8_target_signature([first.mask, second.mask, pair.first, pair.second])?;
                requested[index][usize::from(target >> 6)] |= 1_u64 << (target & 63);
                survivors = survivors
                    .checked_add(u64::from(bitset_256_contains(&reachable[index], target)))
                    .ok_or(G133SparseError::StateBudget)?;
            }
        }
    }
    let mut requested_class_signatures = 0_u32;
    let mut maximum_signatures_per_class = 0_u16;
    for signatures in requested {
        let count = signatures.iter().map(|word| word.count_ones()).sum::<u32>();
        requested_class_signatures = requested_class_signatures
            .checked_add(count)
            .ok_or(G133SparseError::StateBudget)?;
        maximum_signatures_per_class = maximum_signatures_per_class.max(count as u16);
    }
    Ok(G133SparseJointMod8Report {
        mod4_roots: roots,
        q0_q1_roots,
        joint_mod8_survivors: survivors,
        joint_mod8_exclusions: q0_q1_roots - survivors,
        special_lift_classes: special_classes as u16,
        zero_lift_classes: zero_classes as u16,
        compatible_class_quadruples,
        total_class_quadruples: class_cells as u32,
        requested_class_signatures,
        maximum_signatures_per_class,
        minimum_domain_profiles,
        maximum_domain_profiles,
        total_domain_profiles,
        minimum_pair_profiles,
        maximum_pair_profiles,
        total_pair_profiles,
        provenance: "discovery-only exact same-witness q2--q9 mod-eight lift image above exact rows/q0/q1; candidates are not certificate positives and exclusions have no authority until independent reconstruction/replay",
    })
}

pub fn census_g133_sparse_mod16_classes() -> Result<G133SparseMod16ClassReport, G133SparseError> {
    verify_projection()?;
    let (special_profiles, zero_profiles, right_frontier) = compile_mod4_frontier();
    let mut special: [Option<EnergyDomain>; 1 << SLOTS] = std::array::from_fn(|_| None);
    let mut zero: [Option<EnergyDomain>; 1 << SLOTS] = std::array::from_fn(|_| None);
    let mut compiled = 0_u16;
    let mut minimum = u32::MAX;
    let mut maximum = 0_u32;
    let mut total = 0_u64;
    for (profiles, domains, row_target) in [
        (&special_profiles, &mut special, 260_u16),
        (&zero_profiles, &mut zero, 261_u16),
    ] {
        for profile in profiles {
            let slot = &mut domains[usize::from(profile.mask)];
            if slot.is_some() {
                continue;
            }
            let domain = compile_energy_domain(profile.mask, row_target, None, 2)?;
            let count = u32::try_from(
                domain
                    .lift_profiles
                    .as_ref()
                    .ok_or(G133SparseError::SemanticMismatch)?
                    .len(),
            )
            .map_err(|_| G133SparseError::StateBudget)?;
            minimum = minimum.min(count);
            maximum = maximum.max(count);
            total = total
                .checked_add(u64::from(count))
                .ok_or(G133SparseError::StateBudget)?;
            if total > MAX_TOTAL_Q2_PROFILES {
                return Err(G133SparseError::StateBudget);
            }
            *slot = Some(domain);
            compiled = compiled
                .checked_add(1)
                .ok_or(G133SparseError::StateBudget)?;
        }
    }
    let special_representatives = lift_class_representatives(&special)?;
    let zero_representatives = lift_class_representatives(&zero)?;
    let special_classes = special_representatives.len();
    let zero_classes = zero_representatives.len();
    let special_class_map = lift_class_map(&special, &special_representatives)?;
    let zero_class_map = lift_class_map(&zero, &zero_representatives)?;
    let class_cells = special_classes
        .checked_mul(zero_classes)
        .and_then(|value| value.checked_mul(zero_classes))
        .and_then(|value| value.checked_mul(zero_classes))
        .ok_or(G133SparseError::StateBudget)?;
    if class_cells > 1 << 20 {
        return Err(G133SparseError::StateBudget);
    }
    let mut targets = vec![u16::MAX; class_cells];
    let mut requested_class_cells = 0_u32;
    let mut conflicting = vec![false; class_cells];
    let mut conflicting_target_cells = 0_u32;
    let mut requested_left_pairs = vec![false; special_classes * zero_classes];
    let mut requested_right_pairs = vec![false; zero_classes * zero_classes];
    let mut mod4_roots = 0_u64;
    for first in &special_profiles {
        for second in &zero_profiles {
            let required = complement_signature(add_signatures(first.signature, second.signature));
            let begin = right_frontier.partition_point(|pair| pair.signature < required);
            let end = right_frontier.partition_point(|pair| pair.signature <= required);
            for pair in &right_frontier[begin..end] {
                mod4_roots = mod4_roots
                    .checked_add(1)
                    .ok_or(G133SparseError::StateBudget)?;
                let classes = [
                    usize::from(special_class_map[usize::from(first.mask)]),
                    usize::from(zero_class_map[usize::from(second.mask)]),
                    usize::from(zero_class_map[usize::from(pair.first)]),
                    usize::from(zero_class_map[usize::from(pair.second)]),
                ];
                let index = (((classes[0] * zero_classes + classes[1]) * zero_classes
                    + classes[2])
                    * zero_classes)
                    + classes[3];
                let target = g133_mod16_target_signature([
                    first.mask,
                    second.mask,
                    pair.first,
                    pair.second,
                ])?;
                if targets[index] == u16::MAX {
                    targets[index] = target;
                    requested_class_cells += 1;
                    requested_left_pairs[classes[0] * zero_classes + classes[1]] = true;
                    requested_right_pairs[classes[2] * zero_classes + classes[3]] = true;
                } else if targets[index] != target && !conflicting[index] {
                    conflicting[index] = true;
                    conflicting_target_cells += 1;
                }
            }
        }
    }
    Ok(G133SparseMod16ClassReport {
        block_domains_compiled: compiled,
        special_classes: special_classes as u16,
        zero_classes: zero_classes as u16,
        minimum_domain_profiles: minimum,
        maximum_domain_profiles: maximum,
        total_domain_profiles: total,
        profile_bytes: total
            .checked_mul(std::mem::size_of::<LiftProfile>() as u64)
            .ok_or(G133SparseError::StateBudget)?,
        mod4_roots,
        requested_class_cells,
        conflicting_target_cells,
        requested_left_pair_classes: requested_left_pairs
            .into_iter()
            .map(u16::from)
            .sum(),
        requested_right_pair_classes: requested_right_pairs
            .into_iter()
            .map(u16::from)
            .sum(),
        provenance: "discovery-only exact theorem-derived q2--q9 mod-sixteen block classes above canonical rows; no root or certificate authority",
    })
}

pub fn scout_g133_sparse_mod16_pair_shape(
) -> Result<G133SparseMod16PairShapeReport, G133SparseError> {
    verify_projection()?;
    let (special_profiles, zero_profiles, _) = compile_mod4_frontier();
    let special_mask = special_profiles
        .first()
        .ok_or(G133SparseError::SemanticMismatch)?
        .mask;
    let zero_mask = zero_profiles
        .first()
        .ok_or(G133SparseError::SemanticMismatch)?
        .mask;
    let special_domain = compile_energy_domain(special_mask, 260, None, 2)?;
    let zero_domain = compile_energy_domain(zero_mask, 261, None, 2)?;
    let special = mod16_dense_block_keys(&special_domain)?;
    let zero = mod16_dense_block_keys(&zero_domain)?;
    let mut positions = vec![u32::MAX; (DEFECT_TARGET + 1) * (2 * Q1_LIMIT)];
    let mut touched = Vec::with_capacity(MAX_PAIR_PROFILES);
    let special_zero =
        compile_mod16_dense_pair_keys(&special, &zero, &mut positions, &mut touched)?;
    let zero_zero = compile_mod16_dense_pair_keys(&zero, &zero, &mut positions, &mut touched)?;
    let shape = |profiles: &[Mod16DenseKey]| {
        let mut full = 0_u32;
        let mut minimum = u32::MAX;
        let mut maximum = 0_u32;
        for profile in profiles {
            let count = dense_key_signature_count(profile);
            full += u32::from(count == 65_536);
            minimum = minimum.min(count);
            maximum = maximum.max(count);
        }
        (full, minimum, maximum)
    };
    let (special_zero_full, special_zero_minimum, special_zero_maximum) = shape(&special_zero);
    let (zero_zero_full, zero_zero_minimum, zero_zero_maximum) = shape(&zero_zero);
    Ok(G133SparseMod16PairShapeReport {
        special_mask,
        zero_mask,
        special_block_keys: special.len() as u32,
        zero_block_keys: zero.len() as u32,
        special_zero_pair_keys: special_zero.len() as u32,
        zero_zero_pair_keys: zero_zero.len() as u32,
        special_zero_full_keys: special_zero_full,
        zero_zero_full_keys: zero_zero_full,
        special_zero_minimum_signatures: special_zero_minimum,
        special_zero_maximum_signatures: special_zero_maximum,
        zero_zero_minimum_signatures: zero_zero_minimum,
        zero_zero_maximum_signatures: zero_zero_maximum,
        provenance: "discovery-only exact mod-sixteen dense pair-image shape for the first canonical special/zero semantic domains; no root authority",
    })
}

pub fn scout_g133_sparse_exact_shift_pair_shape(
    shift: usize,
) -> Result<G133SparseExactShiftPairShapeReport, G133SparseError> {
    if !(2..SHIFTS).contains(&shift) {
        return Err(G133SparseError::StateBudget);
    }
    verify_projection()?;
    let (special_profiles, zero_profiles, _) = compile_mod4_frontier();
    let special_mask = special_profiles
        .first()
        .ok_or(G133SparseError::SemanticMismatch)?
        .mask;
    let zero_mask = zero_profiles
        .first()
        .ok_or(G133SparseError::SemanticMismatch)?
        .mask;
    let special_domain = compile_energy_domain(special_mask, 260, Some(shift), 0)?;
    let zero_domain = compile_energy_domain(zero_mask, 261, Some(shift), 0)?;
    let special = q2_dense_block_keys(&special_domain)?;
    let zero = q2_dense_block_keys(&zero_domain)?;
    let mut positions = vec![u32::MAX; (DEFECT_TARGET + 1) * (2 * Q1_LIMIT)];
    let mut touched = Vec::with_capacity(MAX_PAIR_PROFILES);
    let special_zero = compile_q2_dense_pair_keys(&special, &zero, &mut positions, &mut touched)?;
    let zero_zero = compile_q2_dense_pair_keys(&zero, &zero, &mut positions, &mut touched)?;
    let (special_zero_intervals, special_zero_excess, special_zero_maximum) =
        q2_pair_shape(&special_zero);
    let (zero_zero_intervals, zero_zero_excess, zero_zero_maximum) = q2_pair_shape(&zero_zero);
    Ok(G133SparseExactShiftPairShapeReport {
        shift: shift as u8,
        special_mask,
        zero_mask,
        special_zero_pair_keys: special_zero.len() as u32,
        zero_zero_pair_keys: zero_zero.len() as u32,
        special_zero_interval_keys: special_zero_intervals,
        zero_zero_interval_keys: zero_zero_intervals,
        special_zero_relaxation_excess: special_zero_excess,
        zero_zero_relaxation_excess: zero_zero_excess,
        maximum_relaxation_excess_per_key: special_zero_maximum.max(zero_zero_maximum),
        provenance: "discovery-only exact scalar-shift pair images for the first canonical special/zero domains compared with the retained mod-64-plus-range relaxation; no root authority",
    })
}

pub fn scout_g133_sparse_exact_q2_pair_shape(
) -> Result<G133SparseExactQ2PairShapeReport, G133SparseError> {
    let report = scout_g133_sparse_exact_shift_pair_shape(2)?;
    Ok(G133SparseExactQ2PairShapeReport {
        special_mask: report.special_mask,
        zero_mask: report.zero_mask,
        special_zero_pair_keys: report.special_zero_pair_keys,
        zero_zero_pair_keys: report.zero_zero_pair_keys,
        special_zero_interval_keys: report.special_zero_interval_keys,
        zero_zero_interval_keys: report.zero_zero_interval_keys,
        special_zero_relaxation_excess: report.special_zero_relaxation_excess,
        zero_zero_relaxation_excess: report.zero_zero_relaxation_excess,
        maximum_relaxation_excess_per_key: report.maximum_relaxation_excess_per_key,
        provenance: "discovery-only exact q2 pair images for the first canonical special/zero domains compared with the retained mod-64-plus-range relaxation; no root authority",
    })
}

fn compile_g133_sparse_exact_shift<const CELLS: bool, const ROOT_BITS: bool>(
    shift: usize,
) -> Result<
    (
        G133SparseExactShiftReport,
        Box<[G133ExactShiftCellRow]>,
        Box<[u64]>,
    ),
    G133SparseError,
> {
    if !(2..SHIFTS).contains(&shift) {
        return Err(G133SparseError::StateBudget);
    }
    verify_projection()?;
    let (special_profiles, zero_profiles, right_frontier) = compile_mod4_frontier();
    let mut special: [Option<EnergyDomain>; 1 << SLOTS] = std::array::from_fn(|_| None);
    let mut zero: [Option<EnergyDomain>; 1 << SLOTS] = std::array::from_fn(|_| None);
    let mut total_block_profiles = 0_u64;
    for (profiles, domains, row_target) in [
        (&special_profiles, &mut special, 260_u16),
        (&zero_profiles, &mut zero, 261_u16),
    ] {
        for profile in profiles {
            let slot = &mut domains[usize::from(profile.mask)];
            if slot.is_some() {
                continue;
            }
            let domain = compile_energy_domain(profile.mask, row_target, Some(shift), 0)?;
            total_block_profiles = total_block_profiles
                .checked_add(
                    domain
                        .q2_profiles
                        .as_ref()
                        .ok_or(G133SparseError::SemanticMismatch)?
                        .len() as u64,
                )
                .ok_or(G133SparseError::StateBudget)?;
            if total_block_profiles > MAX_TOTAL_Q2_PROFILES {
                return Err(G133SparseError::StateBudget);
            }
            *slot = Some(domain);
        }
    }
    let special_representatives = q2_class_representatives(&special)?;
    let zero_representatives = q2_class_representatives(&zero)?;
    let special_class_map = q2_class_map(&special, &special_representatives)?;
    let zero_class_map = q2_class_map(&zero, &zero_representatives)?;
    let special_classes = special_representatives.len();
    let zero_classes = zero_representatives.len();
    let mut special_dense = Vec::with_capacity(special_classes);
    for domain in &special_representatives {
        special_dense.push(q2_dense_block_keys(domain)?);
    }
    let mut zero_dense = Vec::with_capacity(zero_classes);
    for domain in &zero_representatives {
        zero_dense.push(q2_dense_block_keys(domain)?);
    }
    let mut positions = vec![u32::MAX; (DEFECT_TARGET + 1) * (2 * Q1_LIMIT)];
    let mut touched = Vec::with_capacity(MAX_PAIR_PROFILES);
    let mut left_pairs = Vec::with_capacity(special_classes * zero_classes);
    let mut right_pairs = Vec::with_capacity(zero_classes * zero_classes);
    let mut total_pair_keys = 0_u64;
    let mut total_pair_values = 0_u64;
    let mut total_pair_holes = 0_u64;
    let mut maximum_values_per_pair_key = 0_u16;
    const MAX_TOTAL_PAIR_KEYS: u64 = 4_000_000;
    const MAX_TOTAL_PAIR_HOLES: u64 = 100_000_000;
    for special_class in 0..special_classes {
        for zero_class in 0..zero_classes {
            let dense = compile_q2_dense_pair_keys(
                &special_dense[special_class],
                &zero_dense[zero_class],
                &mut positions,
                &mut touched,
            )?;
            let oracle = compile_q2_dense_pair_keys_shift_oracle(
                &special_dense[special_class],
                &zero_dense[zero_class],
                &mut positions,
                &mut touched,
            )?;
            if dense != oracle {
                return Err(G133SparseError::SemanticMismatch);
            }
            let sparse = compress_q2_dense_pairs(&dense)?;
            total_pair_keys = total_pair_keys
                .checked_add(sparse.keys.len() as u64)
                .ok_or(G133SparseError::StateBudget)?;
            total_pair_values = total_pair_values
                .checked_add(scalar_pair_exact_values(&sparse))
                .ok_or(G133SparseError::StateBudget)?;
            total_pair_holes = total_pair_holes
                .checked_add(sparse.holes.len() as u64)
                .ok_or(G133SparseError::StateBudget)?;
            if total_pair_keys > MAX_TOTAL_PAIR_KEYS || total_pair_holes > MAX_TOTAL_PAIR_HOLES {
                return Err(G133SparseError::StateBudget);
            }
            maximum_values_per_pair_key = maximum_values_per_pair_key.max(
                sparse
                    .keys
                    .iter()
                    .map(|key| key.exact_len)
                    .max()
                    .unwrap_or(0),
            );
            left_pairs.push(sparse);
        }
    }
    for first_zero_class in 0..zero_classes {
        for second_zero_class in 0..zero_classes {
            let dense = compile_q2_dense_pair_keys(
                &zero_dense[first_zero_class],
                &zero_dense[second_zero_class],
                &mut positions,
                &mut touched,
            )?;
            let oracle = compile_q2_dense_pair_keys_shift_oracle(
                &zero_dense[first_zero_class],
                &zero_dense[second_zero_class],
                &mut positions,
                &mut touched,
            )?;
            if dense != oracle {
                return Err(G133SparseError::SemanticMismatch);
            }
            let sparse = compress_q2_dense_pairs(&dense)?;
            total_pair_keys = total_pair_keys
                .checked_add(sparse.keys.len() as u64)
                .ok_or(G133SparseError::StateBudget)?;
            total_pair_values = total_pair_values
                .checked_add(scalar_pair_exact_values(&sparse))
                .ok_or(G133SparseError::StateBudget)?;
            total_pair_holes = total_pair_holes
                .checked_add(sparse.holes.len() as u64)
                .ok_or(G133SparseError::StateBudget)?;
            if total_pair_keys > MAX_TOTAL_PAIR_KEYS || total_pair_holes > MAX_TOTAL_PAIR_HOLES {
                return Err(G133SparseError::StateBudget);
            }
            maximum_values_per_pair_key = maximum_values_per_pair_key.max(
                sparse
                    .keys
                    .iter()
                    .map(|key| key.exact_len)
                    .max()
                    .unwrap_or(0),
            );
            right_pairs.push(sparse);
        }
    }
    let class_cells = special_classes
        .checked_mul(zero_classes)
        .and_then(|value| value.checked_mul(zero_classes))
        .and_then(|value| value.checked_mul(zero_classes))
        .ok_or(G133SparseError::StateBudget)?;
    let mut q0_q1_cells = vec![false; class_cells];
    let mut q2_witnesses = vec![None::<Q2ClassWitness>; class_cells];
    let mut root_weights = if CELLS {
        vec![0_u64; class_cells]
    } else {
        Vec::new()
    };
    let mut q0_q1_class_cells = 0_u32;
    let mut exact_q2_class_cells = 0_u32;
    for special_class in 0..special_classes {
        for first_zero_class in 0..zero_classes {
            let left = &left_pairs[special_class * zero_classes + first_zero_class];
            for second_zero_class in 0..zero_classes {
                for third_zero_class in 0..zero_classes {
                    let right = &right_pairs[second_zero_class * zero_classes + third_zero_class];
                    let index = (((special_class * zero_classes + first_zero_class)
                        * zero_classes
                        + second_zero_class)
                        * zero_classes)
                        + third_zero_class;
                    let (q0_q1, witness) = q2_class_witness(
                        left,
                        right,
                        [
                            special_representatives[special_class],
                            zero_representatives[first_zero_class],
                            zero_representatives[second_zero_class],
                            zero_representatives[third_zero_class],
                        ],
                    )?;
                    q0_q1_cells[index] = q0_q1;
                    q2_witnesses[index] = witness;
                    q0_q1_class_cells += u32::from(q0_q1);
                    exact_q2_class_cells += u32::from(witness.is_some());
                }
            }
        }
    }

    let mut roots = 0_u64;
    let mut q0_q1_roots = 0_u64;
    let mut q2_candidates = 0_u64;
    let mut candidate_bits = if ROOT_BITS {
        vec![0_u64; ROOT_FILTER_WORDS]
    } else {
        Vec::new()
    };
    let mut candidate_hasher = Sha256::new();
    for first in &special_profiles {
        for second in &zero_profiles {
            let required = complement_signature(add_signatures(first.signature, second.signature));
            let begin = right_frontier.partition_point(|pair| pair.signature < required);
            let end = right_frontier.partition_point(|pair| pair.signature <= required);
            for pair in &right_frontier[begin..end] {
                let root = roots;
                roots = roots.checked_add(1).ok_or(G133SparseError::StateBudget)?;
                if ROOT_BITS && root as usize / 64 >= candidate_bits.len() {
                    return Err(G133SparseError::StateBudget);
                }
                let classes = [
                    usize::from(special_class_map[usize::from(first.mask)]),
                    usize::from(zero_class_map[usize::from(second.mask)]),
                    usize::from(zero_class_map[usize::from(pair.first)]),
                    usize::from(zero_class_map[usize::from(pair.second)]),
                ];
                let index = (((classes[0] * zero_classes + classes[1]) * zero_classes
                    + classes[2])
                    * zero_classes)
                    + classes[3];
                q0_q1_roots += u64::from(q0_q1_cells[index]);
                if CELLS && q0_q1_cells[index] {
                    root_weights[index] = root_weights[index]
                        .checked_add(1)
                        .ok_or(G133SparseError::StateBudget)?;
                }
                if let Some(witness) = q2_witnesses[index] {
                    let masks = [first.mask, second.mask, pair.first, pair.second];
                    let domains = [
                        special[usize::from(masks[0])]
                            .as_ref()
                            .ok_or(G133SparseError::SemanticMismatch)?,
                        zero[usize::from(masks[1])]
                            .as_ref()
                            .ok_or(G133SparseError::SemanticMismatch)?,
                        zero[usize::from(masks[2])]
                            .as_ref()
                            .ok_or(G133SparseError::SemanticMismatch)?,
                        zero[usize::from(masks[3])]
                            .as_ref()
                            .ok_or(G133SparseError::SemanticMismatch)?,
                    ];
                    let mut digits = [0_u32; 4];
                    for block in 0..4 {
                        digits[block] = q2_digits(domains[block], witness.states[block])?;
                    }
                    replay_shift_hit(masks, digits, shift)?;
                    q2_candidates += 1;
                    if ROOT_BITS {
                        candidate_bits[root as usize / 64] |= 1_u64 << (root % 64);
                    }
                    for mask in masks {
                        candidate_hasher.update(mask.to_le_bytes());
                    }
                }
            }
        }
    }
    let report = G133SparseExactShiftReport {
        shift: shift as u8,
        mod4_roots: roots,
        q0_q1_roots,
        exact_shift_candidates: q2_candidates,
        exact_shift_reduction: q0_q1_roots - q2_candidates,
        special_classes: special_classes as u16,
        zero_classes: zero_classes as u16,
        q0_q1_class_cells,
        exact_shift_class_cells: exact_q2_class_cells,
        total_pair_keys,
        total_pair_values,
        stored_pair_holes: total_pair_holes,
        maximum_values_per_pair_key,
        independent_pair_oracle: true,
        candidate_digest: candidate_hasher.finalize().into(),
        provenance: "discovery-only exact same-witness scalar-shift interior-gap join above canonical rows/q0/q1; every retained root reconstructs and directly replays rows/q0/q1/the selected shift, but exclusions have no authority until an independent verifier",
    };
    let mut rows = Vec::new();
    if CELLS {
        rows.try_reserve_exact(q0_q1_class_cells as usize)
            .map_err(|_| G133SparseError::StateBudget)?;
        for special_class in 0..special_classes {
            for first_zero_class in 0..zero_classes {
                let left = &left_pairs[special_class * zero_classes + first_zero_class];
                for second_zero_class in 0..zero_classes {
                    for third_zero_class in 0..zero_classes {
                        let index = (((special_class * zero_classes + first_zero_class)
                            * zero_classes
                            + second_zero_class)
                            * zero_classes)
                            + third_zero_class;
                        let weight = root_weights[index];
                        if weight == 0 {
                            continue;
                        }
                        let right =
                            &right_pairs[second_zero_class * zero_classes + third_zero_class];
                        let domains = [
                            special_representatives[special_class],
                            zero_representatives[first_zero_class],
                            zero_representatives[second_zero_class],
                            zero_representatives[third_zero_class],
                        ];
                        let block_configurations =
                            std::array::from_fn(|block| domains[block].configurations);
                        let block_energy_values = std::array::from_fn(|block| {
                            domains[block].energies.count_ones() as u16
                        });
                        let block_q1_profiles =
                            std::array::from_fn(|block| domains[block].q1_profiles.len() as u32);
                        let block_shift_profiles = std::array::from_fn(|block| {
                            domains[block]
                                .q2_profiles
                                .as_ref()
                                .map_or(0, |profiles| profiles.len() as u32)
                        });
                        let (left_holes, left_intervals, left_maximum_holes, left_residue_bits) =
                            scalar_pair_shape_features(left);
                        let (right_holes, right_intervals, right_maximum_holes, right_residue_bits) =
                            scalar_pair_shape_features(right);
                        let (base_sumset_pairs, hole_covered_pairs) =
                            scalar_pair_sumset_counts(left, right)?;
                        if (base_sumset_pairs != hole_covered_pairs)
                            != q2_witnesses[index].is_some()
                        {
                            return Err(G133SparseError::SemanticMismatch);
                        }
                        rows.push(G133ExactShiftCellRow {
                            id: index as u32,
                            weight,
                            survives: q2_witnesses[index].is_some(),
                            block_configurations,
                            block_energy_values,
                            block_q1_profiles,
                            block_shift_profiles,
                            left_pair_keys: left.keys.len() as u32,
                            left_pair_values: u32::try_from(scalar_pair_exact_values(left))
                                .map_err(|_| G133SparseError::StateBudget)?,
                            right_pair_keys: right.keys.len() as u32,
                            right_pair_values: u32::try_from(scalar_pair_exact_values(right))
                                .map_err(|_| G133SparseError::StateBudget)?,
                            left_pair_holes: left_holes,
                            right_pair_holes: right_holes,
                            left_interval_keys: left_intervals,
                            right_interval_keys: right_intervals,
                            left_maximum_holes,
                            right_maximum_holes,
                            left_residue_bits,
                            right_residue_bits,
                            base_sumset_pairs,
                            hole_covered_pairs,
                        });
                    }
                }
            }
        }
        if rows.iter().map(|row| row.weight).sum::<u64>() != q0_q1_roots {
            return Err(G133SparseError::SemanticMismatch);
        }
    }
    if ROOT_BITS {
        candidate_bits.truncate((roots as usize).div_ceil(64));
        if candidate_bits
            .iter()
            .map(|word| word.count_ones() as u64)
            .sum::<u64>()
            != q2_candidates
        {
            return Err(G133SparseError::SemanticMismatch);
        }
    }
    Ok((
        report,
        rows.into_boxed_slice(),
        candidate_bits.into_boxed_slice(),
    ))
}

pub fn scout_g133_sparse_exact_shift(
    shift: usize,
) -> Result<G133SparseExactShiftReport, G133SparseError> {
    Ok(compile_g133_sparse_exact_shift::<false, false>(shift)?.0)
}

pub fn compile_g133_exact_shift_cell_corpus(
    shift: usize,
) -> Result<G133ExactShiftCellCorpus, G133SparseError> {
    let (report, rows, _) = compile_g133_sparse_exact_shift::<true, false>(shift)?;
    Ok(G133ExactShiftCellCorpus {
        report,
        rows,
        provenance: "discovery-only weighted semantic-cell corpus for Ergodis evolution; opaque class IDs are row identifiers only and never learnable fields; no pruning or certificate authority",
    })
}

pub fn compile_g133_exact_shift_root_filter(
    shift: usize,
) -> Result<G133ExactShiftRootFilter, G133SparseError> {
    let (report, _, candidates) = compile_g133_sparse_exact_shift::<false, true>(shift)?;
    Ok(G133ExactShiftRootFilter {
        root_count: report.mod4_roots,
        report,
        candidates,
    })
}

pub fn scout_g133_sparse_exact_shift_intersection(
    first_shift: usize,
    second_shift: usize,
) -> Result<G133SparseExactShiftIntersectionReport, G133SparseError> {
    if first_shift == second_shift {
        return Err(G133SparseError::StateBudget);
    }
    let first = compile_g133_exact_shift_root_filter(first_shift)?;
    let second = compile_g133_exact_shift_root_filter(second_shift)?;
    if first.root_count != second.root_count
        || first.candidates.len() != second.candidates.len()
        || first.report.q0_q1_roots != second.report.q0_q1_roots
    {
        return Err(G133SparseError::SemanticMismatch);
    }
    let mut intersection_candidates = 0_u64;
    let mut digest = Sha256::new();
    digest.update(b"c1016-g133-canonical-mod4-root-order-v1");
    digest.update([first.report.shift, second.report.shift]);
    digest.update(first.root_count.to_le_bytes());
    for (&left, &right) in first.candidates.iter().zip(second.candidates.iter()) {
        let word = left & right;
        intersection_candidates = intersection_candidates
            .checked_add(u64::from(word.count_ones()))
            .ok_or(G133SparseError::StateBudget)?;
        digest.update(word.to_le_bytes());
    }
    if intersection_candidates > first.report.exact_shift_candidates
        || intersection_candidates > second.report.exact_shift_candidates
    {
        return Err(G133SparseError::SemanticMismatch);
    }
    Ok(G133SparseExactShiftIntersectionReport {
        shifts: [first.report.shift, second.report.shift],
        mod4_roots: first.root_count,
        q0_q1_roots: first.report.q0_q1_roots,
        first_shift_candidates: first.report.exact_shift_candidates,
        second_shift_candidates: second.report.exact_shift_candidates,
        intersection_candidates,
        intersection_reduction: first.report.q0_q1_roots - intersection_candidates,
        candidate_digest: digest.finalize().into(),
        provenance: "proved necessary-only intersection of two exact scalar-shift marginal images; each marginal survivor is independently reconstructed and directly replayed, but the two shifts may use different witnesses and no certificate-positive claim is made",
    })
}

pub fn scout_g133_sparse_exact_q2() -> Result<G133SparseExactQ2Report, G133SparseError> {
    let report = scout_g133_sparse_exact_shift(2)?;
    Ok(G133SparseExactQ2Report {
        mod4_roots: report.mod4_roots,
        q0_q1_roots: report.q0_q1_roots,
        exact_q2_candidates: report.exact_shift_candidates,
        exact_q2_reduction: report.exact_shift_reduction,
        special_classes: report.special_classes,
        zero_classes: report.zero_classes,
        q0_q1_class_cells: report.q0_q1_class_cells,
        exact_q2_class_cells: report.exact_shift_class_cells,
        total_pair_keys: report.total_pair_keys,
        total_pair_values: report.total_pair_values,
        stored_pair_holes: report.stored_pair_holes,
        maximum_values_per_pair_key: report.maximum_values_per_pair_key,
        independent_pair_oracle: report.independent_pair_oracle,
        candidate_digest: report.candidate_digest,
        provenance: "discovery-only exact same-witness q2 interior-gap join above canonical rows/q0/q1; every retained root reconstructs and directly replays rows/q0/q1/q2, but exclusions have no authority until an independent verifier",
    })
}

pub fn scout_g133_sparse_joint_mod16() -> Result<G133SparseJointMod16Report, G133SparseError> {
    verify_projection()?;
    let (special_profiles, zero_profiles, right_frontier) = compile_mod4_frontier();
    let mut special: [Option<EnergyDomain>; 1 << SLOTS] = std::array::from_fn(|_| None);
    let mut zero: [Option<EnergyDomain>; 1 << SLOTS] = std::array::from_fn(|_| None);
    let mut total_block_profiles = 0_u64;
    for (profiles, domains, row_target) in [
        (&special_profiles, &mut special, 260_u16),
        (&zero_profiles, &mut zero, 261_u16),
    ] {
        for profile in profiles {
            let slot = &mut domains[usize::from(profile.mask)];
            if slot.is_some() {
                continue;
            }
            let domain = compile_energy_domain(profile.mask, row_target, None, 2)?;
            total_block_profiles = total_block_profiles
                .checked_add(
                    domain
                        .lift_profiles
                        .as_ref()
                        .ok_or(G133SparseError::SemanticMismatch)?
                        .len() as u64,
                )
                .ok_or(G133SparseError::StateBudget)?;
            if total_block_profiles > MAX_TOTAL_Q2_PROFILES {
                return Err(G133SparseError::StateBudget);
            }
            *slot = Some(domain);
        }
    }
    let special_representatives = lift_class_representatives(&special)?;
    let zero_representatives = lift_class_representatives(&zero)?;
    let special_class_map = lift_class_map(&special, &special_representatives)?;
    let zero_class_map = lift_class_map(&zero, &zero_representatives)?;
    let special_classes = special_representatives.len();
    let zero_classes = zero_representatives.len();
    let class_cells = special_classes
        .checked_mul(zero_classes)
        .and_then(|value| value.checked_mul(zero_classes))
        .and_then(|value| value.checked_mul(zero_classes))
        .ok_or(G133SparseError::StateBudget)?;
    if class_cells > 1 << 20 {
        return Err(G133SparseError::StateBudget);
    }

    let mut targets = vec![u16::MAX; class_cells];
    let mut requested_left = vec![false; special_classes * zero_classes];
    let mut requested_right = vec![false; zero_classes * zero_classes];
    let mut requested_class_cells = 0_u32;
    let mut mod4_roots = 0_u64;
    for first in &special_profiles {
        for second in &zero_profiles {
            let required = complement_signature(add_signatures(first.signature, second.signature));
            let begin = right_frontier.partition_point(|pair| pair.signature < required);
            let end = right_frontier.partition_point(|pair| pair.signature <= required);
            for pair in &right_frontier[begin..end] {
                mod4_roots = mod4_roots
                    .checked_add(1)
                    .ok_or(G133SparseError::StateBudget)?;
                let classes = [
                    usize::from(special_class_map[usize::from(first.mask)]),
                    usize::from(zero_class_map[usize::from(second.mask)]),
                    usize::from(zero_class_map[usize::from(pair.first)]),
                    usize::from(zero_class_map[usize::from(pair.second)]),
                ];
                let index = (((classes[0] * zero_classes + classes[1]) * zero_classes
                    + classes[2])
                    * zero_classes)
                    + classes[3];
                let target = g133_mod16_target_signature([
                    first.mask,
                    second.mask,
                    pair.first,
                    pair.second,
                ])?;
                if targets[index] == u16::MAX {
                    targets[index] = target;
                    requested_class_cells += 1;
                    requested_left[classes[0] * zero_classes + classes[1]] = true;
                    requested_right[classes[2] * zero_classes + classes[3]] = true;
                } else if targets[index] != target {
                    return Err(G133SparseError::SemanticMismatch);
                }
            }
        }
    }

    let mut special_dense = Vec::with_capacity(special_classes);
    for domain in &special_representatives {
        special_dense.push(mod16_dense_block_keys(domain)?);
    }
    let mut zero_dense = Vec::with_capacity(zero_classes);
    for domain in &zero_representatives {
        zero_dense.push(mod16_dense_block_keys(domain)?);
    }
    let mut left_pairs: Vec<Option<Mod16SparsePairDomain>> =
        (0..requested_left.len()).map(|_| None).collect();
    let mut right_pairs: Vec<Option<Mod16SparsePairDomain>> =
        (0..requested_right.len()).map(|_| None).collect();
    let mut positions = vec![u32::MAX; (DEFECT_TARGET + 1) * (2 * Q1_LIMIT)];
    let mut touched = Vec::with_capacity(MAX_PAIR_PROFILES);
    let mut total_pair_keys = 0_u64;
    let mut total_pair_signatures = 0_u64;
    let mut maximum_signatures_per_pair_key = 0_u16;
    for special_class in 0..special_classes {
        for zero_class in 0..zero_classes {
            let index = special_class * zero_classes + zero_class;
            if !requested_left[index] {
                continue;
            }
            let dense = compile_mod16_dense_pair_keys(
                &special_dense[special_class],
                &zero_dense[zero_class],
                &mut positions,
                &mut touched,
            )?;
            let sparse = compress_mod16_dense_pairs(&dense)?;
            total_pair_keys += sparse.keys.len() as u64;
            total_pair_signatures += sparse.signatures.len() as u64;
            maximum_signatures_per_pair_key = maximum_signatures_per_pair_key.max(
                sparse
                    .keys
                    .iter()
                    .map(|key| u16::from(key.len))
                    .max()
                    .unwrap_or(0),
            );
            left_pairs[index] = Some(sparse);
        }
    }
    for first_zero_class in 0..zero_classes {
        for second_zero_class in 0..zero_classes {
            let index = first_zero_class * zero_classes + second_zero_class;
            if !requested_right[index] {
                continue;
            }
            let dense = compile_mod16_dense_pair_keys(
                &zero_dense[first_zero_class],
                &zero_dense[second_zero_class],
                &mut positions,
                &mut touched,
            )?;
            let sparse = compress_mod16_dense_pairs(&dense)?;
            total_pair_keys += sparse.keys.len() as u64;
            total_pair_signatures += sparse.signatures.len() as u64;
            maximum_signatures_per_pair_key = maximum_signatures_per_pair_key.max(
                sparse
                    .keys
                    .iter()
                    .map(|key| u16::from(key.len))
                    .max()
                    .unwrap_or(0),
            );
            right_pairs[index] = Some(sparse);
        }
    }
    if total_pair_keys > 4_000_000 || total_pair_signatures > 100_000_000 {
        return Err(G133SparseError::StateBudget);
    }

    let mut q0_q1_cells = vec![false; class_cells];
    let mut compatible_cells = vec![false; class_cells];
    let mut q0_q1_class_cells = 0_u32;
    let mut compatible_class_cells = 0_u32;
    for (index, &target) in targets.iter().enumerate() {
        if target == u16::MAX {
            continue;
        }
        let mut value = index;
        let fourth = value % zero_classes;
        value /= zero_classes;
        let third = value % zero_classes;
        value /= zero_classes;
        let second = value % zero_classes;
        let first = value / zero_classes;
        let left = left_pairs[first * zero_classes + second]
            .as_ref()
            .ok_or(G133SparseError::SemanticMismatch)?;
        let right = right_pairs[third * zero_classes + fourth]
            .as_ref()
            .ok_or(G133SparseError::SemanticMismatch)?;
        let (q0_q1, compatible) = mod16_pair_domains_compatible(left, right, target)?;
        q0_q1_cells[index] = q0_q1;
        compatible_cells[index] = compatible;
        q0_q1_class_cells += u32::from(q0_q1);
        compatible_class_cells += u32::from(compatible);
    }

    let mut q0_q1_roots = 0_u64;
    let mut candidates = 0_u64;
    for first in &special_profiles {
        for second in &zero_profiles {
            let required = complement_signature(add_signatures(first.signature, second.signature));
            let begin = right_frontier.partition_point(|pair| pair.signature < required);
            let end = right_frontier.partition_point(|pair| pair.signature <= required);
            for pair in &right_frontier[begin..end] {
                let classes = [
                    usize::from(special_class_map[usize::from(first.mask)]),
                    usize::from(zero_class_map[usize::from(second.mask)]),
                    usize::from(zero_class_map[usize::from(pair.first)]),
                    usize::from(zero_class_map[usize::from(pair.second)]),
                ];
                let index = (((classes[0] * zero_classes + classes[1]) * zero_classes
                    + classes[2])
                    * zero_classes)
                    + classes[3];
                q0_q1_roots = q0_q1_roots
                    .checked_add(u64::from(q0_q1_cells[index]))
                    .ok_or(G133SparseError::StateBudget)?;
                candidates = candidates
                    .checked_add(u64::from(compatible_cells[index]))
                    .ok_or(G133SparseError::StateBudget)?;
            }
        }
    }
    Ok(G133SparseJointMod16Report {
        mod4_roots,
        q0_q1_roots,
        joint_mod16_candidates: candidates,
        candidate_reduction: q0_q1_roots - candidates,
        requested_class_cells,
        q0_q1_class_cells,
        compatible_class_cells,
        requested_left_pair_classes: requested_left.into_iter().map(u16::from).sum(),
        requested_right_pair_classes: requested_right.into_iter().map(u16::from).sum(),
        total_pair_keys,
        total_pair_signatures,
        maximum_signatures_per_pair_key,
        provenance: "discovery-only exact same-witness q2--q9 mod-sixteen candidate join above exact rows/q0/q1; no negative or certificate authority until independent reconstruction and direct original-equation replay",
    })
}

/// Measure the exact `(energy,q1,q2)` state growth before selecting a q2 join.
///
/// Every domain is bounded by the complete `8^10` digit cube and the tighter
/// retained-profile cap above.  States and one reconstruction witness occupy
/// one 16-byte Tiger record; the census retains at most 70 million records and
/// fails closed beyond it.
pub fn census_g133_sparse_q2_profiles() -> Result<G133SparseQ2ProfileReport, G133SparseError> {
    verify_projection()?;
    let (special_profiles, zero_profiles, _) = compile_mod4_frontier();
    let mut special: [Option<EnergyDomain>; 1 << SLOTS] = std::array::from_fn(|_| None);
    let mut zero: [Option<EnergyDomain>; 1 << SLOTS] = std::array::from_fn(|_| None);
    let mut compiled = 0_u16;
    let mut minimum = u32::MAX;
    let mut maximum = 0_u32;
    let mut total = 0_u64;
    for (profiles, domains, row_target) in [
        (&special_profiles, &mut special, 260_u16),
        (&zero_profiles, &mut zero, 261_u16),
    ] {
        for profile in profiles {
            let slot = &mut domains[usize::from(profile.mask)];
            if slot.is_some() {
                continue;
            }
            let domain = compile_energy_domain(profile.mask, row_target, Some(2), 0)?;
            let count = u32::try_from(
                domain
                    .q2_profiles
                    .as_ref()
                    .ok_or(G133SparseError::SemanticMismatch)?
                    .len(),
            )
            .map_err(|_| G133SparseError::StateBudget)?;
            minimum = minimum.min(count);
            maximum = maximum.max(count);
            total = total
                .checked_add(u64::from(count))
                .ok_or(G133SparseError::StateBudget)?;
            if total > MAX_TOTAL_Q2_PROFILES {
                return Err(G133SparseError::StateBudget);
            }
            *slot = Some(domain);
            compiled = compiled
                .checked_add(1)
                .ok_or(G133SparseError::StateBudget)?;
        }
    }
    Ok(G133SparseQ2ProfileReport {
        block_domains_compiled: compiled,
        minimum_domain_profiles: minimum,
        maximum_domain_profiles: maximum,
        total_domain_profiles: total,
        special_q2_classes: q2_class_count(&special)?,
        zero_q2_classes: q2_class_count(&zero)?,
        profile_bytes: total
            .checked_mul(std::mem::size_of::<Q2Profile>() as u64)
            .ok_or(G133SparseError::StateBudget)?,
    })
}

/// Exact census of the common quotient-shift state carried by every sparse
/// digit configuration. This is discovery data only: it neither joins four
/// blocks nor authorizes pruning.
pub fn census_g133_joint_shift_profiles() -> Result<G133JointShiftProfileReport, G133SparseError> {
    verify_projection()?;
    let (special_profiles, zero_profiles, _) = compile_mod4_frontier();
    let mut seen = [[false; 1 << SLOTS]; 2];
    let mut workspace = Vec::new();
    workspace
        .try_reserve_exact(MAX_Q2_PROFILES_PER_DOMAIN)
        .map_err(|_| G133SparseError::StateBudget)?;
    let mut block_domains_compiled = 0_u16;
    let mut total_configurations = 0_u64;
    let mut total_unique_states = 0_u64;
    let mut minimum_domain_configurations = u32::MAX;
    let mut maximum_domain_configurations = 0_u32;
    let mut minimum_domain_unique_states = u32::MAX;
    let mut maximum_domain_unique_states = 0_u32;
    let mut maximum_state_multiplicity = 0_u32;
    for (kind, profiles, row_target) in [
        (0_usize, &special_profiles, 260_u16),
        (1_usize, &zero_profiles, 261_u16),
    ] {
        for profile in profiles {
            let mask = usize::from(profile.mask);
            if seen[kind][mask] {
                continue;
            }
            seen[kind][mask] = true;
            let configurations =
                compile_joint_shift_profiles_into(profile.mask, row_target, &mut workspace)?;
            let reference = compile_energy_domain(profile.mask, row_target, None, 0)?;
            if configurations != reference.configurations {
                return Err(G133SparseError::SemanticMismatch);
            }
            let mut unique_states = 0_u32;
            let mut cursor = 0_usize;
            while cursor < workspace.len() {
                let state = workspace[cursor].state;
                let begin = cursor;
                cursor += 1;
                while cursor < workspace.len() && workspace[cursor].state == state {
                    cursor += 1;
                }
                unique_states = unique_states
                    .checked_add(1)
                    .ok_or(G133SparseError::StateBudget)?;
                maximum_state_multiplicity = maximum_state_multiplicity
                    .max(u32::try_from(cursor - begin).map_err(|_| G133SparseError::StateBudget)?);
            }
            block_domains_compiled = block_domains_compiled
                .checked_add(1)
                .ok_or(G133SparseError::StateBudget)?;
            total_configurations = total_configurations
                .checked_add(u64::from(configurations))
                .ok_or(G133SparseError::StateBudget)?;
            total_unique_states = total_unique_states
                .checked_add(u64::from(unique_states))
                .ok_or(G133SparseError::StateBudget)?;
            minimum_domain_configurations = minimum_domain_configurations.min(configurations);
            maximum_domain_configurations = maximum_domain_configurations.max(configurations);
            minimum_domain_unique_states = minimum_domain_unique_states.min(unique_states);
            maximum_domain_unique_states = maximum_domain_unique_states.max(unique_states);
        }
    }
    Ok(G133JointShiftProfileReport {
        block_domains_compiled,
        total_configurations,
        total_unique_states,
        minimum_domain_configurations,
        maximum_domain_configurations,
        minimum_domain_unique_states,
        maximum_domain_unique_states,
        maximum_state_multiplicity,
        profile_workspace_bytes: (workspace.capacity() * std::mem::size_of::<JointShiftProfile>())
            as u64,
        provenance: "discovery-only exact common-state census over quotient shifts 1/3/6/9; every state is recomputed directly from its digit vector and cross-checked against the independent row/energy enumerator; no four-block join or pruning authority",
    })
}

fn refine_joint_classes(
    profiles: &[BinaryProfile],
    row_target: u16,
    q6_domains: &[Option<EnergyDomain>; 1 << SLOTS],
    q6_class_map: &[u8; 1 << SLOTS],
    q6_classes: usize,
    joint_profiles: &mut Vec<JointShiftProfile>,
    joint_states: &mut Vec<u64>,
    q6_projection: &mut Vec<u64>,
    joint_class_map: &mut [u16; 1 << SLOTS],
) -> Result<(u16, u16, u16, u16, u64), G133SparseError> {
    let mut representatives = Vec::<Vec<Box<[u64]>>>::with_capacity(q6_classes);
    for _ in 0..q6_classes {
        representatives.push(Vec::new());
    }
    let mut seen = [false; 1 << SLOTS];
    let mut masks = 0_u16;
    let mut retained_words = 0_u64;
    for profile in profiles {
        let mask = usize::from(profile.mask);
        if seen[mask] {
            continue;
        }
        seen[mask] = true;
        masks = masks.checked_add(1).ok_or(G133SparseError::StateBudget)?;
        compile_joint_shift_profiles_into(profile.mask, row_target, joint_profiles)?;
        joint_states.clear();
        let mut previous = None;
        for profile in joint_profiles.iter() {
            if previous != Some(profile.state) {
                joint_states.push(profile.state);
                previous = Some(profile.state);
            }
        }

        q6_projection.clear();
        for &state in joint_states.iter() {
            let energy = state >> 52;
            let q1 = (state >> 39) & 8_191;
            let q6 = (state >> 13) & 8_191;
            q6_projection.push((energy << 26) | (q1 << 13) | q6);
        }
        q6_projection.sort_unstable();
        q6_projection.dedup();
        let q6_domain = q6_domains[mask]
            .as_ref()
            .ok_or(G133SparseError::SemanticMismatch)?;
        let q6_profiles = q6_domain
            .q2_profiles
            .as_deref()
            .ok_or(G133SparseError::SemanticMismatch)?;
        if q6_projection.len() != q6_profiles.len()
            || !q6_projection
                .iter()
                .zip(q6_profiles)
                .all(|(&state, profile)| state == profile.state)
        {
            return Err(G133SparseError::SemanticMismatch);
        }

        let q6_class = usize::from(q6_class_map[mask]);
        let class = representatives
            .get_mut(q6_class)
            .ok_or(G133SparseError::SemanticMismatch)?;
        let subclass = if let Some(subclass) = class
            .iter()
            .position(|representative| representative.as_ref() == joint_states.as_slice())
        {
            subclass
        } else {
            retained_words = retained_words
                .checked_add(joint_states.len() as u64)
                .ok_or(G133SparseError::StateBudget)?;
            class.push(joint_states.as_slice().to_vec().into_boxed_slice());
            class.len() - 1
        };
        joint_class_map[mask] =
            (u16::try_from(q6_class).map_err(|_| G133SparseError::StateBudget)? << 8)
                | u16::try_from(subclass).map_err(|_| G133SparseError::StateBudget)?;
    }
    let mut joint_classes = 0_u16;
    let mut split_classes = 0_u16;
    let mut maximum_per_q6 = 0_u16;
    let mut offsets = Vec::with_capacity(representatives.len());
    for class in &representatives {
        offsets.push(joint_classes);
        let count = u16::try_from(class.len()).map_err(|_| G133SparseError::StateBudget)?;
        joint_classes = joint_classes
            .checked_add(count)
            .ok_or(G133SparseError::StateBudget)?;
        split_classes += u16::from(count > 1);
        maximum_per_q6 = maximum_per_q6.max(count);
    }
    for (mask, &present) in seen.iter().enumerate() {
        if !present {
            continue;
        }
        let local = joint_class_map[mask];
        let q6_class = usize::from(local >> 8);
        joint_class_map[mask] = offsets[q6_class]
            .checked_add(local & 255)
            .ok_or(G133SparseError::StateBudget)?;
    }
    Ok((
        masks,
        joint_classes,
        split_classes,
        maximum_per_q6,
        retained_words,
    ))
}

/// Determine whether exact q6 semantic classes already determine the full
/// `(energy,q1,q3,q6,q9)` block-state set. Equality is checked on sorted state
/// slices, while the q6 projection is independently compared with the exact
/// q6 compiler for every typed mask.
fn compile_g133_joint_shift_class_refinement() -> Result<
    (
        G133JointShiftClassRefinementReport,
        [u16; 1 << SLOTS],
        [u16; 1 << SLOTS],
        [u8; 1 << SLOTS],
        [u8; 1 << SLOTS],
    ),
    G133SparseError,
> {
    verify_projection()?;
    let (special_profiles, zero_profiles, _) = compile_mod4_frontier();
    let mut special: [Option<EnergyDomain>; 1 << SLOTS] = std::array::from_fn(|_| None);
    let mut zero: [Option<EnergyDomain>; 1 << SLOTS] = std::array::from_fn(|_| None);
    for (profiles, domains, row_target) in [
        (&special_profiles, &mut special, 260_u16),
        (&zero_profiles, &mut zero, 261_u16),
    ] {
        for profile in profiles {
            let slot = &mut domains[usize::from(profile.mask)];
            if slot.is_none() {
                *slot = Some(compile_energy_domain(profile.mask, row_target, Some(6), 0)?);
            }
        }
    }
    let special_q6_representatives = q2_class_representatives(&special)?;
    let zero_q6_representatives = q2_class_representatives(&zero)?;
    let special_q6_map = q2_class_map(&special, &special_q6_representatives)?;
    let zero_q6_map = q2_class_map(&zero, &zero_q6_representatives)?;

    let mut joint_profiles = Vec::new();
    joint_profiles
        .try_reserve_exact(MAX_Q2_PROFILES_PER_DOMAIN)
        .map_err(|_| G133SparseError::StateBudget)?;
    let mut joint_states = Vec::new();
    joint_states
        .try_reserve_exact(MAX_Q2_PROFILES_PER_DOMAIN)
        .map_err(|_| G133SparseError::StateBudget)?;
    let mut q6_projection = Vec::new();
    q6_projection
        .try_reserve_exact(MAX_Q2_PROFILES_PER_DOMAIN)
        .map_err(|_| G133SparseError::StateBudget)?;
    let mut special_joint_map = [u16::MAX; 1 << SLOTS];
    let mut zero_joint_map = [u16::MAX; 1 << SLOTS];

    let special_result = refine_joint_classes(
        &special_profiles,
        260,
        &special,
        &special_q6_map,
        special_q6_representatives.len(),
        &mut joint_profiles,
        &mut joint_states,
        &mut q6_projection,
        &mut special_joint_map,
    )?;
    let zero_result = refine_joint_classes(
        &zero_profiles,
        261,
        &zero,
        &zero_q6_map,
        zero_q6_representatives.len(),
        &mut joint_profiles,
        &mut joint_states,
        &mut q6_projection,
        &mut zero_joint_map,
    )?;
    let retained_joint_state_words = special_result
        .4
        .checked_add(zero_result.4)
        .ok_or(G133SparseError::StateBudget)?;
    let report = G133JointShiftClassRefinementReport {
        special_masks: special_result.0,
        zero_masks: zero_result.0,
        special_q6_classes: u16::try_from(special_q6_representatives.len())
            .map_err(|_| G133SparseError::StateBudget)?,
        zero_q6_classes: u16::try_from(zero_q6_representatives.len())
            .map_err(|_| G133SparseError::StateBudget)?,
        special_joint_classes: special_result.1,
        zero_joint_classes: zero_result.1,
        split_q6_classes: special_result.2 + zero_result.2,
        maximum_joint_classes_per_q6_class: special_result.3.max(zero_result.3),
        retained_joint_state_words,
        retained_joint_state_bytes: retained_joint_state_words
            .checked_mul(std::mem::size_of::<u64>() as u64)
            .ok_or(G133SparseError::StateBudget)?,
        provenance: "discovery-only exact refinement of q6 block classes by full q1/q3/q6/q9 state sets; every comparison uses sorted full states and independently verifies its q6 projection against the exact q6 compiler; no root authority",
    };
    Ok((
        report,
        special_joint_map,
        zero_joint_map,
        special_q6_map,
        zero_q6_map,
    ))
}

pub fn census_g133_joint_shift_class_refinement(
) -> Result<G133JointShiftClassRefinementReport, G133SparseError> {
    Ok(compile_g133_joint_shift_class_refinement()?.0)
}

/// Refine caller-supplied q6 cells by exact joint block-state equivalence.
/// Root enumeration is allocation-free after one bounded direct-index table
/// is allocated; every retained cell carries a canonical root representative.
pub fn map_g133_joint_shift_refined_cells(
    cell_ids: &[u32],
) -> Result<G133JointShiftRefinedCellReport, G133SparseError> {
    if cell_ids.is_empty()
        || cell_ids.len() > MAX_PAIR_PROFILES
        || cell_ids.windows(2).any(|pair| pair[0] >= pair[1])
    {
        return Err(G133SparseError::StateBudget);
    }
    let (refinement, special_joint_map, zero_joint_map, special_q6_map, zero_q6_map) =
        compile_g133_joint_shift_class_refinement()?;
    let zero_q6_classes = usize::from(refinement.zero_q6_classes);
    let zero_joint_classes = usize::from(refinement.zero_joint_classes);
    let q6_cell_count = usize::from(refinement.special_q6_classes)
        .checked_mul(zero_q6_classes)
        .and_then(|value| value.checked_mul(zero_q6_classes))
        .and_then(|value| value.checked_mul(zero_q6_classes))
        .ok_or(G133SparseError::StateBudget)?;
    if cell_ids
        .last()
        .is_some_and(|&cell| cell as usize >= q6_cell_count)
    {
        return Err(G133SparseError::StateBudget);
    }
    let mut selected_q6_cells = vec![0_u64; q6_cell_count.div_ceil(64)];
    for &cell in cell_ids {
        let cell = cell as usize;
        selected_q6_cells[cell / 64] |= 1_u64 << (cell % 64);
    }
    let joint_cell_count = usize::from(refinement.special_joint_classes)
        .checked_mul(zero_joint_classes)
        .and_then(|value| value.checked_mul(zero_joint_classes))
        .and_then(|value| value.checked_mul(zero_joint_classes))
        .ok_or(G133SparseError::StateBudget)?;
    let empty = G133JointShiftRefinedCell {
        q6_cell_id: u32::MAX,
        joint_cell_id: u32::MAX,
        masks: [u16::MAX; 4],
        joint_classes: [u16::MAX; 4],
        mod4_roots: 0,
    };
    let mut joint_cells = Vec::new();
    joint_cells
        .try_reserve_exact(joint_cell_count)
        .map_err(|_| G133SparseError::StateBudget)?;
    joint_cells.resize(joint_cell_count, empty);

    let (special_profiles, zero_profiles, right_frontier) = compile_mod4_frontier();
    let mut matched_mod4_roots = 0_u64;
    for first in &special_profiles {
        for second in &zero_profiles {
            let required = complement_signature(add_signatures(first.signature, second.signature));
            let begin = right_frontier.partition_point(|pair| pair.signature < required);
            let end = right_frontier.partition_point(|pair| pair.signature <= required);
            for pair in &right_frontier[begin..end] {
                let masks = [first.mask, second.mask, pair.first, pair.second];
                let q6_classes = [
                    usize::from(special_q6_map[usize::from(masks[0])]),
                    usize::from(zero_q6_map[usize::from(masks[1])]),
                    usize::from(zero_q6_map[usize::from(masks[2])]),
                    usize::from(zero_q6_map[usize::from(masks[3])]),
                ];
                let q6_cell = (((q6_classes[0] * zero_q6_classes + q6_classes[1])
                    * zero_q6_classes
                    + q6_classes[2])
                    * zero_q6_classes)
                    + q6_classes[3];
                if selected_q6_cells[q6_cell / 64] & (1_u64 << (q6_cell % 64)) == 0 {
                    continue;
                }
                let joint_classes = [
                    special_joint_map[usize::from(masks[0])],
                    zero_joint_map[usize::from(masks[1])],
                    zero_joint_map[usize::from(masks[2])],
                    zero_joint_map[usize::from(masks[3])],
                ];
                let joint_cell = (((usize::from(joint_classes[0]) * zero_joint_classes
                    + usize::from(joint_classes[1]))
                    * zero_joint_classes
                    + usize::from(joint_classes[2]))
                    * zero_joint_classes)
                    + usize::from(joint_classes[3]);
                let row = &mut joint_cells[joint_cell];
                if row.mod4_roots == 0 {
                    *row = G133JointShiftRefinedCell {
                        q6_cell_id: q6_cell as u32,
                        joint_cell_id: joint_cell as u32,
                        masks,
                        joint_classes,
                        mod4_roots: 1,
                    };
                } else {
                    if row.q6_cell_id != q6_cell as u32 || row.joint_classes != joint_classes {
                        return Err(G133SparseError::SemanticMismatch);
                    }
                    row.mod4_roots = row
                        .mod4_roots
                        .checked_add(1)
                        .ok_or(G133SparseError::StateBudget)?;
                }
                matched_mod4_roots = matched_mod4_roots
                    .checked_add(1)
                    .ok_or(G133SparseError::StateBudget)?;
            }
        }
    }
    let mut rows = Vec::new();
    rows.try_reserve_exact(joint_cell_count.min(MAX_PAIR_PROFILES))
        .map_err(|_| G133SparseError::StateBudget)?;
    for row in joint_cells {
        if row.mod4_roots != 0 {
            if rows.len() == MAX_PAIR_PROFILES {
                return Err(G133SparseError::StateBudget);
            }
            rows.push(row);
        }
    }
    Ok(G133JointShiftRefinedCellReport {
        supplied_q6_cells: cell_ids.len() as u32,
        matched_mod4_roots,
        refined_joint_cells: rows.len() as u32,
        special_joint_classes: refinement.special_joint_classes,
        zero_joint_classes: refinement.zero_joint_classes,
        rows: rows.into_boxed_slice(),
        provenance: "discovery-only exact refinement of caller-supplied q6 cells into full q1/q3/q6/q9 block-state equivalence cells; each row counts all canonical mod-four roots and stores one representative; no pruning authority",
    })
}

/// Map semantic q6 class cells back to the first canonical mod-four root in
/// each cell. The caller supplies the cells; this function grants no survival
/// authority and is intended only for scoped discovery probes.
pub fn map_g133_exact_shift_cell_roots(
    shift: usize,
    cell_ids: &[u32],
) -> Result<Box<[G133CellRootRepresentative]>, G133SparseError> {
    if !(2..SHIFTS).contains(&shift)
        || cell_ids.is_empty()
        || cell_ids.len() > MAX_PAIR_PROFILES
        || cell_ids.windows(2).any(|pair| pair[0] >= pair[1])
    {
        return Err(G133SparseError::StateBudget);
    }
    verify_projection()?;
    let (special_profiles, zero_profiles, right_frontier) = compile_mod4_frontier();
    let mut special: [Option<EnergyDomain>; 1 << SLOTS] = std::array::from_fn(|_| None);
    let mut zero: [Option<EnergyDomain>; 1 << SLOTS] = std::array::from_fn(|_| None);
    let mut total_block_profiles = 0_u64;
    for (profiles, domains, row_target) in [
        (&special_profiles, &mut special, 260_u16),
        (&zero_profiles, &mut zero, 261_u16),
    ] {
        for profile in profiles {
            let slot = &mut domains[usize::from(profile.mask)];
            if slot.is_some() {
                continue;
            }
            let domain = compile_energy_domain(profile.mask, row_target, Some(shift), 0)?;
            total_block_profiles = total_block_profiles
                .checked_add(
                    domain
                        .q2_profiles
                        .as_ref()
                        .ok_or(G133SparseError::SemanticMismatch)?
                        .len() as u64,
                )
                .ok_or(G133SparseError::StateBudget)?;
            if total_block_profiles > MAX_TOTAL_Q2_PROFILES {
                return Err(G133SparseError::StateBudget);
            }
            *slot = Some(domain);
        }
    }
    let special_representatives = q2_class_representatives(&special)?;
    let zero_representatives = q2_class_representatives(&zero)?;
    let special_class_map = q2_class_map(&special, &special_representatives)?;
    let zero_class_map = q2_class_map(&zero, &zero_representatives)?;
    let zero_classes = zero_representatives.len();
    let class_cells = special_representatives
        .len()
        .checked_mul(zero_classes)
        .and_then(|value| value.checked_mul(zero_classes))
        .and_then(|value| value.checked_mul(zero_classes))
        .ok_or(G133SparseError::StateBudget)?;
    if cell_ids
        .last()
        .is_some_and(|&cell| cell as usize >= class_cells)
    {
        return Err(G133SparseError::StateBudget);
    }
    let mut output = cell_ids
        .iter()
        .map(|&cell_id| G133CellRootRepresentative {
            masks: [u16::MAX; 4],
            cell_id,
            reserved: 0,
        })
        .collect::<Vec<_>>();
    let mut remaining = output.len();
    'roots: for first in &special_profiles {
        for second in &zero_profiles {
            let required = complement_signature(add_signatures(first.signature, second.signature));
            let begin = right_frontier.partition_point(|pair| pair.signature < required);
            let end = right_frontier.partition_point(|pair| pair.signature <= required);
            for pair in &right_frontier[begin..end] {
                let classes = [
                    usize::from(special_class_map[usize::from(first.mask)]),
                    usize::from(zero_class_map[usize::from(second.mask)]),
                    usize::from(zero_class_map[usize::from(pair.first)]),
                    usize::from(zero_class_map[usize::from(pair.second)]),
                ];
                let index = (((classes[0] * zero_classes + classes[1]) * zero_classes
                    + classes[2])
                    * zero_classes)
                    + classes[3];
                let Ok(position) = cell_ids.binary_search(&(index as u32)) else {
                    continue;
                };
                if output[position].masks[0] == u16::MAX {
                    output[position].masks = [first.mask, second.mask, pair.first, pair.second];
                    remaining -= 1;
                    if remaining == 0 {
                        break 'roots;
                    }
                }
            }
        }
    }
    if remaining != 0 {
        return Err(G133SparseError::SemanticMismatch);
    }
    Ok(output.into_boxed_slice())
}

fn count_sorted_joint_states(profiles: &[JointShiftProfile]) -> Result<u32, G133SparseError> {
    let mut unique = 0_u32;
    let mut cursor = 0_usize;
    while cursor < profiles.len() {
        let state = profiles[cursor].state;
        cursor += 1;
        while cursor < profiles.len() && profiles[cursor].state == state {
            cursor += 1;
        }
        unique = unique.checked_add(1).ok_or(G133SparseError::StateBudget)?;
    }
    Ok(unique)
}

/// Size the exact two-pair materialization envelope for scoped representative
/// roots. The result counts pair products only; it is not a join result.
pub fn census_g133_joint_shift_root_shapes(
    representatives: &[G133CellRootRepresentative],
) -> Result<G133JointShiftRootShapeReport, G133SparseError> {
    if representatives.is_empty() || representatives.len() > MAX_PAIR_PROFILES {
        return Err(G133SparseError::StateBudget);
    }
    let mut special = [None::<(u32, u32)>; 1 << SLOTS];
    let mut zero = [None::<(u32, u32)>; 1 << SLOTS];
    let mut workspace = Vec::new();
    workspace
        .try_reserve_exact(MAX_Q2_PROFILES_PER_DOMAIN)
        .map_err(|_| G133SparseError::StateBudget)?;
    let mut unique_typed_masks = 0_u16;
    let mut rows = Vec::new();
    rows.try_reserve_exact(representatives.len())
        .map_err(|_| G133SparseError::StateBudget)?;
    let mut minimum_pair_envelope = u64::MAX;
    let mut maximum_pair_envelope = 0_u64;
    for representative in representatives {
        let mut configurations = [0_u32; 4];
        let mut unique_states = [0_u32; 4];
        for block in 0..4 {
            let mask = usize::from(representative.masks[block]);
            if mask >= 1 << SLOTS {
                return Err(G133SparseError::SemanticMismatch);
            }
            let row_target = if block == 0 { 260_u16 } else { 261_u16 };
            let cache = if block == 0 { &mut special } else { &mut zero };
            let (count, unique) = if let Some(cached) = cache[mask] {
                cached
            } else {
                let count = compile_joint_shift_profiles_into(
                    representative.masks[block],
                    row_target,
                    &mut workspace,
                )?;
                let reference =
                    compile_energy_domain(representative.masks[block], row_target, None, 0)?;
                if count != reference.configurations {
                    return Err(G133SparseError::SemanticMismatch);
                }
                let unique = count_sorted_joint_states(&workspace)?;
                cache[mask] = Some((count, unique));
                unique_typed_masks = unique_typed_masks
                    .checked_add(1)
                    .ok_or(G133SparseError::StateBudget)?;
                (count, unique)
            };
            configurations[block] = count;
            unique_states[block] = unique;
        }
        let left_pair_envelope = u64::from(unique_states[0]) * u64::from(unique_states[1]);
        let right_pair_envelope = u64::from(unique_states[2]) * u64::from(unique_states[3]);
        minimum_pair_envelope = minimum_pair_envelope
            .min(left_pair_envelope)
            .min(right_pair_envelope);
        maximum_pair_envelope = maximum_pair_envelope
            .max(left_pair_envelope)
            .max(right_pair_envelope);
        rows.push(G133JointShiftRootShape {
            cell_id: representative.cell_id,
            masks: representative.masks,
            configurations,
            unique_states,
            left_pair_envelope,
            right_pair_envelope,
        });
    }
    Ok(G133JointShiftRootShapeReport {
        cells: rows.len() as u32,
        unique_typed_masks,
        minimum_pair_envelope,
        maximum_pair_envelope,
        rows: rows.into_boxed_slice(),
        provenance: "discovery-only common-shift state and raw two-pair materialization envelope for supplied representative roots; counts replay direct digit enumeration but do not assert a four-block witness or exclusion",
    })
}

#[inline(always)]
fn joint_coarse_key(state: u64) -> u64 {
    ((state >> 52) << 26) | (((state >> 39) & 0x1fff) << 13) | ((state >> 13) & 0x1fff)
}

fn compile_joint_coarse_domain(
    mask: u16,
    row_target: u16,
) -> Result<JointCoarseDomain, G133SparseError> {
    let mut profiles = Vec::new();
    profiles
        .try_reserve_exact(MAX_Q2_PROFILES_PER_DOMAIN)
        .map_err(|_| G133SparseError::StateBudget)?;
    let configurations = compile_joint_shift_profiles_into(mask, row_target, &mut profiles)?;
    let reference = compile_energy_domain(mask, row_target, None, 0)?;
    if configurations != reference.configurations {
        return Err(G133SparseError::SemanticMismatch);
    }
    let mut cursor = 0_usize;
    let mut unique = 0_usize;
    while cursor < profiles.len() {
        let state = profiles[cursor].state;
        profiles[unique] = profiles[cursor];
        unique += 1;
        cursor += 1;
        while cursor < profiles.len() && profiles[cursor].state == state {
            cursor += 1;
        }
    }
    profiles.truncate(unique);
    profiles.sort_unstable_by_key(|profile| (joint_coarse_key(profile.state), profile.state));
    let mut groups = Vec::new();
    groups
        .try_reserve_exact(profiles.len())
        .map_err(|_| G133SparseError::StateBudget)?;
    cursor = 0;
    while cursor < profiles.len() {
        let key = joint_coarse_key(profiles[cursor].state);
        let begin = cursor;
        cursor += 1;
        while cursor < profiles.len() && joint_coarse_key(profiles[cursor].state) == key {
            cursor += 1;
        }
        groups.push(JointCoarseGroup {
            key,
            offset: u32::try_from(begin).map_err(|_| G133SparseError::StateBudget)?,
            states: u32::try_from(cursor - begin).map_err(|_| G133SparseError::StateBudget)?,
        });
    }
    Ok(JointCoarseDomain {
        groups: groups.into_boxed_slice(),
        states: profiles.into_boxed_slice(),
    })
}

#[inline(always)]
fn add_joint_coarse(left: u64, right: u64) -> Option<u64> {
    let energy = (left >> 26).checked_add(right >> 26)?;
    let q1 = ((left >> 13) & 0x1fff).checked_add((right >> 13) & 0x1fff)?;
    let q6 = (left & 0x1fff).checked_add(right & 0x1fff)?;
    (energy <= DEFECT_TARGET as u64 && q1 <= 15_080 && q6 <= 15_080)
        .then_some((energy << 28) | (q1 << 14) | q6)
}

#[inline(always)]
fn complement_joint_coarse(pair: u64) -> u64 {
    let energy = pair >> 28;
    let q1 = (pair >> 14) & 0x3fff;
    let q6 = pair & 0x3fff;
    (((DEFECT_TARGET as u64 - energy) << 28) | ((15_080_u64 - q1) << 14) | (15_080_u64 - q6)) + 1
}

#[inline(always)]
fn coarse_hash(value: u64, mask: usize) -> usize {
    let mut mixed = value;
    mixed ^= mixed >> 30;
    mixed = mixed.wrapping_mul(0xbf58_476d_1ce4_e5b9);
    mixed ^= mixed >> 27;
    mixed = mixed.wrapping_mul(0x94d0_49bb_1331_11eb);
    ((mixed ^ (mixed >> 31)) as usize) & mask
}

#[inline(always)]
fn coarse_hash_insert(table: &mut [u64], value: u64) -> Result<bool, G133SparseError> {
    debug_assert!(value != 0 && table.len().is_power_of_two());
    let mask = table.len() - 1;
    let mut slot = coarse_hash(value, mask);
    for _ in 0..table.len() {
        if table[slot] == value {
            return Ok(false);
        }
        if table[slot] == 0 {
            table[slot] = value;
            return Ok(true);
        }
        slot = (slot + 1) & mask;
    }
    Err(G133SparseError::StateBudget)
}

#[inline(always)]
fn coarse_hash_contains(table: &[u64], value: u64) -> bool {
    debug_assert!(value != 0 && table.len().is_power_of_two());
    let mask = table.len() - 1;
    let mut slot = coarse_hash(value, mask);
    for _ in 0..table.len() {
        let stored = table[slot];
        if stored == value {
            return true;
        }
        if stored == 0 {
            return false;
        }
        slot = (slot + 1) & mask;
    }
    false
}

#[inline(always)]
fn residue_sumset11(mut left: u16, right: u16) -> u16 {
    let mut output = 0_u16;
    while left != 0 {
        let shift = left.trailing_zeros();
        left &= left - 1;
        let shift = shift as u16;
        let rotated = if shift == 0 {
            right
        } else {
            ((right << shift) | (right >> (11 - shift))) & 0x07ff
        };
        output |= rotated;
    }
    output
}

#[inline(always)]
fn cycle_mod11_pair_insert(
    table: &mut [CycleMod11PairSlot],
    key: u64,
    residues: u16,
) -> Result<bool, G133SparseError> {
    debug_assert!(table.len().is_power_of_two() && residues & !0x07ff == 0);
    let key_plus_one = key.checked_add(1).ok_or(G133SparseError::StateBudget)?;
    let mask = table.len() - 1;
    let mut slot = coarse_hash(key_plus_one, mask);
    for _ in 0..table.len() {
        let stored = table[slot].key_plus_one;
        if stored == key_plus_one {
            table[slot].residues |= residues;
            return Ok(false);
        }
        if stored == 0 {
            table[slot] = CycleMod11PairSlot {
                key_plus_one,
                residues,
                reserved: [0; 6],
            };
            return Ok(true);
        }
        slot = (slot + 1) & mask;
    }
    Err(G133SparseError::StateBudget)
}

#[inline(always)]
fn cycle_mod11_pair_lookup(table: &[CycleMod11PairSlot], key: u64) -> u16 {
    let Some(key_plus_one) = key.checked_add(1) else {
        return 0;
    };
    let mask = table.len() - 1;
    let mut slot = coarse_hash(key_plus_one, mask);
    for _ in 0..table.len() {
        let stored = table[slot].key_plus_one;
        if stored == key_plus_one {
            return table[slot].residues;
        }
        if stored == 0 {
            return 0;
        }
        slot = (slot + 1) & mask;
    }
    0
}

fn insert_cycle_mod11_pair_image(
    first: &[CycleMod11Group],
    second: &[CycleMod11Group],
    table: &mut [CycleMod11PairSlot],
) -> Result<u32, G133SparseError> {
    let mut keys = 0_u32;
    for left in first {
        for right in second {
            let Some(key) = add_joint_coarse(left.key, right.key) else {
                continue;
            };
            let residues = residue_sumset11(left.residues, right.residues);
            if cycle_mod11_pair_insert(table, key, residues)? {
                keys = keys.checked_add(1).ok_or(G133SparseError::StateBudget)?;
                if usize::try_from(keys).map_err(|_| G133SparseError::StateBudget)? * 4
                    >= table.len() * 3
                {
                    return Err(G133SparseError::StateBudget);
                }
            }
        }
    }
    Ok(keys)
}

fn cycle_mod11_pair_images_compatible(
    first: &[CycleMod11Group],
    second: &[CycleMod11Group],
    complement_table: &[CycleMod11PairSlot],
) -> bool {
    const TARGET_RESIDUE: u16 = 3;
    for left in first {
        for right in second {
            let Some(sum) = add_joint_coarse(left.key, right.key) else {
                continue;
            };
            let complement = complement_joint_coarse(sum) - 1;
            let complement_residues = cycle_mod11_pair_lookup(complement_table, complement);
            if complement_residues == 0 {
                continue;
            }
            let residues = residue_sumset11(left.residues, right.residues);
            if residue_sumset11(residues, complement_residues) & (1_u16 << TARGET_RESIDUE) != 0 {
                return true;
            }
        }
    }
    false
}

fn insert_coarse_pair_sums(
    first: &[JointCoarseGroup],
    second: &[JointCoarseGroup],
    table: &mut [u64],
) -> Result<u64, G133SparseError> {
    let mut inserted = 0_u64;
    for left in first {
        for right in second {
            if let Some(sum) = add_joint_coarse(left.key, right.key) {
                inserted += u64::from(coarse_hash_insert(table, sum + 1)?);
            }
        }
    }
    Ok(inserted)
}

fn count_coarse_compatible_joint_pairs(
    first: &[JointCoarseGroup],
    second: &[JointCoarseGroup],
    complement_table: &[u64],
) -> Result<u64, G133SparseError> {
    let mut pairs = 0_u64;
    for left in first {
        for right in second {
            let Some(sum) = add_joint_coarse(left.key, right.key) else {
                continue;
            };
            if coarse_hash_contains(complement_table, complement_joint_coarse(sum)) {
                pairs = pairs
                    .checked_add(u64::from(left.states) * u64::from(right.states))
                    .ok_or(G133SparseError::StateBudget)?;
            }
        }
    }
    Ok(pairs)
}

/// Exact coarse compatibility count for one scoped representative root. It
/// enforces energy/q1/q6 on the same joint states but does not yet enforce
/// q3/q9, so the result is a discovery work bound rather than a survivor count.
pub fn scout_g133_joint_shift_coarse_pairs(
    representative: G133CellRootRepresentative,
) -> Result<G133JointShiftCoarsePairReport, G133SparseError> {
    let domains = [
        compile_joint_coarse_domain(representative.masks[0], 260)?,
        compile_joint_coarse_domain(representative.masks[1], 261)?,
        compile_joint_coarse_domain(representative.masks[2], 261)?,
        compile_joint_coarse_domain(representative.masks[3], 261)?,
    ];
    let groups: [&[JointCoarseGroup]; 4] =
        std::array::from_fn(|block| domains[block].groups.as_ref());
    let unique_states: [u32; 4] =
        std::array::from_fn(|block| groups[block].iter().map(|group| group.states).sum::<u32>());
    let coarse_groups = std::array::from_fn(|block| groups[block].len() as u32);
    let pairings = [[0_usize, 1, 2, 3], [0, 2, 1, 3], [0, 3, 1, 2]];
    let pairing = pairings
        .into_iter()
        .min_by_key(|pairing| {
            (u64::from(unique_states[pairing[0]]) * u64::from(unique_states[pairing[1]]))
                .max(u64::from(unique_states[pairing[2]]) * u64::from(unique_states[pairing[3]]))
        })
        .ok_or(G133SparseError::SemanticMismatch)?;
    let left_pair_envelope =
        u64::from(unique_states[pairing[0]]) * u64::from(unique_states[pairing[1]]);
    let right_pair_envelope =
        u64::from(unique_states[pairing[2]]) * u64::from(unique_states[pairing[3]]);
    let left_coarse_pair_envelope =
        groups[pairing[0]].len() as u64 * groups[pairing[1]].len() as u64;
    let right_coarse_pair_envelope =
        groups[pairing[2]].len() as u64 * groups[pairing[3]].len() as u64;
    let maximum_coarse_pairs = left_coarse_pair_envelope.max(right_coarse_pair_envelope);
    let requested_slots = maximum_coarse_pairs
        .checked_add(maximum_coarse_pairs / 2)
        .and_then(|value| usize::try_from(value).ok())
        .and_then(usize::checked_next_power_of_two)
        .ok_or(G133SparseError::StateBudget)?
        .min(COARSE_HASH_DISCOVERY_SLOTS);
    if requested_slots > MAX_COARSE_HASH_SLOTS {
        return Err(G133SparseError::StateBudget);
    }
    let mut table = Vec::new();
    table
        .try_reserve_exact(requested_slots)
        .map_err(|_| G133SparseError::StateBudget)?;
    table.resize(requested_slots, 0_u64);
    let right_coarse_sum_keys =
        insert_coarse_pair_sums(&groups[pairing[2]], &groups[pairing[3]], &mut table)?;
    let left_joint_pairs_with_coarse_complement =
        count_coarse_compatible_joint_pairs(&groups[pairing[0]], &groups[pairing[1]], &table)?;
    table.fill(0);
    let left_coarse_sum_keys =
        insert_coarse_pair_sums(&groups[pairing[0]], &groups[pairing[1]], &mut table)?;
    let right_joint_pairs_with_coarse_complement =
        count_coarse_compatible_joint_pairs(&groups[pairing[2]], &groups[pairing[3]], &table)?;
    Ok(G133JointShiftCoarsePairReport {
        cell_id: representative.cell_id,
        masks: representative.masks,
        pairing: pairing.map(|block| block as u8),
        unique_states,
        coarse_groups,
        left_pair_envelope,
        right_pair_envelope,
        left_coarse_pair_envelope,
        right_coarse_pair_envelope,
        right_coarse_sum_keys,
        left_coarse_sum_keys,
        left_joint_pairs_with_coarse_complement,
        right_joint_pairs_with_coarse_complement,
        hash_slots: requested_slots as u64,
        hash_bytes: (requested_slots * std::mem::size_of::<u64>()) as u64,
        provenance: "discovery-only exact same-state energy/q1/q6 coarse pair compatibility for one externally scoped representative root; q3/q9 are deliberately not enforced and no survivor or exclusion authority follows",
    })
}

#[inline(always)]
fn joint_q3_q9_pair_key(left: u64, right: u64) -> Option<u32> {
    let q3 = ((left >> 26) & 0x1fff).checked_add((right >> 26) & 0x1fff)?;
    let q9 = (left & 0x1fff).checked_add(right & 0x1fff)?;
    (q3 <= 15_080 && q9 <= 15_080).then_some(((q3 as u32) << 14) | q9 as u32)
}

#[inline(always)]
fn complement_joint_q3_q9(key: u32) -> u32 {
    let q3 = key >> 14;
    let q9 = key & 0x3fff;
    ((15_080 - q3) << 14) | (15_080 - q9)
}

fn compile_filtered_joint_pairs(
    first: &JointCoarseDomain,
    second: &JointCoarseDomain,
    complement_table: &[u64],
) -> Result<Vec<JointFilteredPair>, G133SparseError> {
    let mut capacity = 0_u64;
    for left in first.groups.iter() {
        for right in second.groups.iter() {
            let Some(sum) = add_joint_coarse(left.key, right.key) else {
                continue;
            };
            if coarse_hash_contains(complement_table, complement_joint_coarse(sum)) {
                capacity = capacity
                    .checked_add(u64::from(left.states) * u64::from(right.states))
                    .ok_or(G133SparseError::StateBudget)?;
            }
        }
    }
    let capacity = usize::try_from(capacity).map_err(|_| G133SparseError::StateBudget)?;
    if capacity > MAX_FILTERED_JOINT_PAIRS {
        return Err(G133SparseError::StateBudget);
    }
    let mut output = Vec::new();
    output
        .try_reserve_exact(capacity)
        .map_err(|_| G133SparseError::StateBudget)?;
    for left in first.groups.iter() {
        for right in second.groups.iter() {
            let Some(sum) = add_joint_coarse(left.key, right.key) else {
                continue;
            };
            if !coarse_hash_contains(complement_table, complement_joint_coarse(sum)) {
                continue;
            }
            let left_begin = left.offset as usize;
            let right_begin = right.offset as usize;
            for first_state in &first.states[left_begin..left_begin + left.states as usize] {
                for second_state in &second.states[right_begin..right_begin + right.states as usize]
                {
                    if let Some(key) = joint_q3_q9_pair_key(first_state.state, second_state.state) {
                        output.push(JointFilteredPair {
                            key,
                            first_digits: first_state.digits,
                            second_digits: second_state.digits,
                            reserved: 0,
                        });
                    }
                }
            }
        }
    }
    output.sort_unstable_by_key(|pair| pair.key);
    Ok(output)
}

fn count_sorted_filtered_pair_keys(pairs: &[JointFilteredPair]) -> u32 {
    let mut keys = 0_u32;
    let mut previous = None;
    for pair in pairs {
        if previous != Some(pair.key) {
            keys += 1;
            previous = Some(pair.key);
        }
    }
    keys
}

struct JointExactInput {
    pairing: [usize; 4],
    left: Vec<JointFilteredPair>,
    right: Vec<JointFilteredPair>,
    requested_slots: usize,
}

fn compile_joint_exact_input(
    representative: G133CellRootRepresentative,
) -> Result<JointExactInput, G133SparseError> {
    let domains = [
        compile_joint_coarse_domain(representative.masks[0], 260)?,
        compile_joint_coarse_domain(representative.masks[1], 261)?,
        compile_joint_coarse_domain(representative.masks[2], 261)?,
        compile_joint_coarse_domain(representative.masks[3], 261)?,
    ];
    let unique_states: [u32; 4] = std::array::from_fn(|block| domains[block].states.len() as u32);
    let pairings = [[0_usize, 1, 2, 3], [0, 2, 1, 3], [0, 3, 1, 2]];
    let pairing = pairings
        .into_iter()
        .min_by_key(|pairing| {
            (u64::from(unique_states[pairing[0]]) * u64::from(unique_states[pairing[1]]))
                .max(u64::from(unique_states[pairing[2]]) * u64::from(unique_states[pairing[3]]))
        })
        .ok_or(G133SparseError::SemanticMismatch)?;
    let left_coarse_pairs =
        domains[pairing[0]].groups.len() as u64 * domains[pairing[1]].groups.len() as u64;
    let right_coarse_pairs =
        domains[pairing[2]].groups.len() as u64 * domains[pairing[3]].groups.len() as u64;
    let requested_slots = left_coarse_pairs
        .max(right_coarse_pairs)
        .checked_add(left_coarse_pairs.max(right_coarse_pairs) / 2)
        .and_then(|value| usize::try_from(value).ok())
        .and_then(usize::checked_next_power_of_two)
        .ok_or(G133SparseError::StateBudget)?
        .min(COARSE_HASH_DISCOVERY_SLOTS);
    if requested_slots > MAX_COARSE_HASH_SLOTS {
        return Err(G133SparseError::StateBudget);
    }
    let mut table = Vec::new();
    table
        .try_reserve_exact(requested_slots)
        .map_err(|_| G133SparseError::StateBudget)?;
    table.resize(requested_slots, 0_u64);
    insert_coarse_pair_sums(
        &domains[pairing[2]].groups,
        &domains[pairing[3]].groups,
        &mut table,
    )?;
    let left = compile_filtered_joint_pairs(&domains[pairing[0]], &domains[pairing[1]], &table)?;
    table.fill(0);
    insert_coarse_pair_sums(
        &domains[pairing[0]].groups,
        &domains[pairing[1]].groups,
        &mut table,
    )?;
    let right = compile_filtered_joint_pairs(&domains[pairing[2]], &domains[pairing[3]], &table)?;
    Ok(JointExactInput {
        pairing,
        left,
        right,
        requested_slots,
    })
}

/// Extract the exact q3/q9 pair-key observations remaining after the common
/// energy/q1/q6 filter. Feature synthesis consumes these anonymous 2D point
/// sets; it receives no theorem or mask semantics.
pub fn extract_g133_joint_shift_pair_points(
    representative: G133CellRootRepresentative,
) -> Result<G133JointShiftPairPoints, G133SparseError> {
    let input = compile_joint_exact_input(representative)?;
    let mut left = Vec::new();
    left.try_reserve_exact(count_sorted_filtered_pair_keys(&input.left) as usize)
        .map_err(|_| G133SparseError::StateBudget)?;
    let mut previous = None;
    for pair in &input.left {
        if previous == Some(pair.key) {
            continue;
        }
        left.push([(pair.key >> 14) as i32, (pair.key & 0x3fff) as i32]);
        previous = Some(pair.key);
    }
    let mut right = Vec::new();
    right
        .try_reserve_exact(count_sorted_filtered_pair_keys(&input.right) as usize)
        .map_err(|_| G133SparseError::StateBudget)?;
    previous = None;
    for pair in &input.right {
        if previous == Some(pair.key) {
            continue;
        }
        right.push([(pair.key >> 14) as i32, (pair.key & 0x3fff) as i32]);
        previous = Some(pair.key);
    }
    Ok(G133JointShiftPairPoints {
        cell_id: representative.cell_id,
        pairing: input.pairing.map(|block| block as u8),
        left: left.into_boxed_slice(),
        right: right.into_boxed_slice(),
        provenance: "discovery-only anonymous two-coordinate pair-key observations after exact common energy/q1/q6 filtering; labels and scopes are not supplied to generic feature synthesis",
    })
}

/// Complete common-witness q1/q3/q6/q9 join for one scoped representative
/// root. This remains discovery-only until a separate implementation replays
/// the negative case; any positive is directly replayed against every joined
/// quotient equation before return.
pub fn scout_g133_joint_shift_exact_root(
    representative: G133CellRootRepresentative,
) -> Result<G133JointShiftExactRootReport, G133SparseError> {
    let JointExactInput {
        pairing,
        left,
        right,
        requested_slots,
    } = compile_joint_exact_input(representative)?;
    let left_exact_keys = count_sorted_filtered_pair_keys(&left);
    let right_exact_keys = count_sorted_filtered_pair_keys(&right);
    let mut witness_digits = None;
    for left_pair in &left {
        let required = complement_joint_q3_q9(left_pair.key);
        let Ok(position) = right.binary_search_by_key(&required, |pair| pair.key) else {
            continue;
        };
        let right_pair = right[position];
        let mut digits = [0_u32; 4];
        digits[pairing[0]] = left_pair.first_digits;
        digits[pairing[1]] = left_pair.second_digits;
        digits[pairing[2]] = right_pair.first_digits;
        digits[pairing[3]] = right_pair.second_digits;
        for shift in [1_usize, 3, 6, 9] {
            replay_shift_hit(representative.masks, digits, shift)?;
        }
        witness_digits = Some(digits);
        break;
    }
    Ok(G133JointShiftExactRootReport {
        cell_id: representative.cell_id,
        masks: representative.masks,
        pairing: pairing.map(|block| block as u8),
        left_filtered_pairs: left.len() as u32,
        right_filtered_pairs: right.len() as u32,
        left_exact_keys,
        right_exact_keys,
        common_witness: witness_digits.is_some(),
        witness_digits,
        pair_workspace_bytes: (requested_slots * std::mem::size_of::<u64>()
            + (left.capacity() + right.capacity()) * std::mem::size_of::<JointFilteredPair>())
            as u64,
        provenance: "discovery-only exact same-witness q1/q3/q6/q9 join for one externally scoped representative root; positives replay all joined quotient equations, while a negative has no authority pending an independent join implementation",
    })
}

/// Refine exact q6 survivor cells using only the structural modulus-11 cycle
/// interface. This recompiles all typed masks and enumerates every canonical
/// mod-four root; it does not depend on the earlier full q3/q9 state classes.
pub fn map_g133_cycle_mod11_refined_cells(
    cell_ids: &[u32],
) -> Result<G133CycleMod11RefinedCellReport, G133SparseError> {
    if cell_ids.is_empty()
        || cell_ids.len() > MAX_PAIR_PROFILES
        || cell_ids.windows(2).any(|pair| pair[0] >= pair[1])
    {
        return Err(G133SparseError::StateBudget);
    }
    verify_projection()?;
    let (special_profiles, zero_profiles, right_frontier) = compile_mod4_frontier();
    let mut special: [Option<CycleMod11Domain>; 1 << SLOTS] = std::array::from_fn(|_| None);
    let mut zero: [Option<CycleMod11Domain>; 1 << SLOTS] = std::array::from_fn(|_| None);
    let mut block_domains_compiled = 0_u16;
    let mut retained_group_bytes = 0_u64;
    for (profiles, domains, row_target) in [
        (&special_profiles, &mut special, 260_u16),
        (&zero_profiles, &mut zero, 261_u16),
    ] {
        for profile in profiles {
            let slot = &mut domains[usize::from(profile.mask)];
            if slot.is_none() {
                let domain = compile_cycle_mod11_domain(profile.mask, row_target)?;
                block_domains_compiled = block_domains_compiled
                    .checked_add(1)
                    .ok_or(G133SparseError::StateBudget)?;
                retained_group_bytes = retained_group_bytes
                    .checked_add(
                        (domain.groups.len() * std::mem::size_of::<CycleMod11Group>()) as u64,
                    )
                    .ok_or(G133SparseError::StateBudget)?;
                *slot = Some(domain);
            }
        }
    }
    let (special_q6_classes, special_q6_map) =
        classify_cycle_domains(&special, cycle_q6_domain_equal)?;
    let (zero_q6_classes, zero_q6_map) = classify_cycle_domains(&zero, cycle_q6_domain_equal)?;
    let (special_cycle_classes, special_cycle_map) =
        classify_cycle_domains(&special, cycle_full_domain_equal)?;
    let (zero_cycle_classes, zero_cycle_map) =
        classify_cycle_domains(&zero, cycle_full_domain_equal)?;
    let (special_splits, special_maximum) =
        cycle_refinement_shape(special_q6_classes, &special_q6_map, &special_cycle_map)?;
    let (zero_splits, zero_maximum) =
        cycle_refinement_shape(zero_q6_classes, &zero_q6_map, &zero_cycle_map)?;

    let zero_q6_classes_usize = usize::from(zero_q6_classes);
    let q6_cell_count = usize::from(special_q6_classes)
        .checked_mul(zero_q6_classes_usize)
        .and_then(|value| value.checked_mul(zero_q6_classes_usize))
        .and_then(|value| value.checked_mul(zero_q6_classes_usize))
        .ok_or(G133SparseError::StateBudget)?;
    if cell_ids
        .last()
        .is_some_and(|&cell| cell as usize >= q6_cell_count)
    {
        return Err(G133SparseError::StateBudget);
    }
    let mut selected_q6_cells = vec![0_u64; q6_cell_count.div_ceil(64)];
    for &cell in cell_ids {
        let cell = cell as usize;
        selected_q6_cells[cell / 64] |= 1_u64 << (cell % 64);
    }

    let zero_cycle_classes_usize = usize::from(zero_cycle_classes);
    let cycle_cell_count = usize::from(special_cycle_classes)
        .checked_mul(zero_cycle_classes_usize)
        .and_then(|value| value.checked_mul(zero_cycle_classes_usize))
        .and_then(|value| value.checked_mul(zero_cycle_classes_usize))
        .ok_or(G133SparseError::StateBudget)?;
    let empty = G133CycleMod11RefinedCell {
        q6_cell_id: u32::MAX,
        cycle_cell_id: u32::MAX,
        masks: [u16::MAX; 4],
        cycle_classes: [u16::MAX; 4],
        mod4_roots: 0,
    };
    let mut cycle_cells = Vec::new();
    cycle_cells
        .try_reserve_exact(cycle_cell_count)
        .map_err(|_| G133SparseError::StateBudget)?;
    cycle_cells.resize(cycle_cell_count, empty);
    let mut matched_mod4_roots = 0_u64;
    for first in &special_profiles {
        for second in &zero_profiles {
            let required = complement_signature(add_signatures(first.signature, second.signature));
            let begin = right_frontier.partition_point(|pair| pair.signature < required);
            let end = right_frontier.partition_point(|pair| pair.signature <= required);
            for pair in &right_frontier[begin..end] {
                let masks = [first.mask, second.mask, pair.first, pair.second];
                let q6_classes = [
                    usize::from(special_q6_map[usize::from(masks[0])]),
                    usize::from(zero_q6_map[usize::from(masks[1])]),
                    usize::from(zero_q6_map[usize::from(masks[2])]),
                    usize::from(zero_q6_map[usize::from(masks[3])]),
                ];
                let q6_cell = (((q6_classes[0] * zero_q6_classes_usize + q6_classes[1])
                    * zero_q6_classes_usize
                    + q6_classes[2])
                    * zero_q6_classes_usize)
                    + q6_classes[3];
                if selected_q6_cells[q6_cell / 64] & (1_u64 << (q6_cell % 64)) == 0 {
                    continue;
                }
                let cycle_classes = [
                    special_cycle_map[usize::from(masks[0])],
                    zero_cycle_map[usize::from(masks[1])],
                    zero_cycle_map[usize::from(masks[2])],
                    zero_cycle_map[usize::from(masks[3])],
                ];
                let cycle_cell = (((usize::from(cycle_classes[0]) * zero_cycle_classes_usize
                    + usize::from(cycle_classes[1]))
                    * zero_cycle_classes_usize
                    + usize::from(cycle_classes[2]))
                    * zero_cycle_classes_usize)
                    + usize::from(cycle_classes[3]);
                let row = &mut cycle_cells[cycle_cell];
                if row.mod4_roots == 0 {
                    *row = G133CycleMod11RefinedCell {
                        q6_cell_id: q6_cell as u32,
                        cycle_cell_id: cycle_cell as u32,
                        masks,
                        cycle_classes,
                        mod4_roots: 1,
                    };
                } else {
                    if row.q6_cell_id != q6_cell as u32 || row.cycle_classes != cycle_classes {
                        return Err(G133SparseError::SemanticMismatch);
                    }
                    row.mod4_roots = row
                        .mod4_roots
                        .checked_add(1)
                        .ok_or(G133SparseError::StateBudget)?;
                }
                matched_mod4_roots = matched_mod4_roots
                    .checked_add(1)
                    .ok_or(G133SparseError::StateBudget)?;
            }
        }
    }
    let mut rows = Vec::new();
    rows.try_reserve_exact(cycle_cell_count.min(MAX_PAIR_PROFILES))
        .map_err(|_| G133SparseError::StateBudget)?;
    for row in cycle_cells {
        if row.mod4_roots != 0 {
            if rows.len() == MAX_PAIR_PROFILES {
                return Err(G133SparseError::StateBudget);
            }
            rows.push(row);
        }
    }
    Ok(G133CycleMod11RefinedCellReport {
        supplied_q6_cells: cell_ids.len() as u32,
        matched_mod4_roots,
        refined_cycle_cells: rows.len() as u32,
        special_q6_classes,
        zero_q6_classes,
        special_cycle_classes,
        zero_cycle_classes,
        split_q6_classes: special_splits + zero_splits,
        maximum_cycle_classes_per_q6_class: special_maximum.max(zero_maximum),
        block_domains_compiled,
        retained_group_bytes,
        rows: rows.into_boxed_slice(),
        provenance: "discovery-only exact refinement of supplied q6 cells by structural three-cycle modulus-11 block interfaces; every block interface independently projects to the exact q6 compiler and all canonical mod-four roots are enumerated; no q3/q9 state partition is used",
    })
}

/// Structural modulus-11 cycle-sum obstruction on supplied root cells.
///
/// Block interfaces retain only exact `(energy,q1,q6)` plus the residue of
/// `P0 + 2 P6 - sum_r C_r^2`. The three-cycle identity proves this residue is
/// `-2 P3-P9`, so a negative pair join excludes a full q3/q9 witness without
/// storing either scalar image.
pub fn scout_g133_cycle_mod11_cells(
    representatives: &[G133CellRootRepresentative],
) -> Result<G133CycleMod11Report, G133SparseError> {
    if representatives.is_empty() || representatives.len() > MAX_PAIR_PROFILES {
        return Err(G133SparseError::StateBudget);
    }
    let mut special: [Option<CycleMod11Domain>; 1 << SLOTS] = std::array::from_fn(|_| None);
    let mut zero: [Option<CycleMod11Domain>; 1 << SLOTS] = std::array::from_fn(|_| None);
    let mut table = Vec::new();
    table
        .try_reserve_exact(COARSE_HASH_DISCOVERY_SLOTS)
        .map_err(|_| G133SparseError::StateBudget)?;
    table.resize(COARSE_HASH_DISCOVERY_SLOTS, EMPTY_CYCLE_MOD11_PAIR_SLOT);
    let mut rows = Vec::new();
    rows.try_reserve_exact(representatives.len())
        .map_err(|_| G133SparseError::StateBudget)?;
    let mut unique_typed_masks = 0_u16;
    let mut total_configurations = 0_u64;
    let mut retained_group_bytes = 0_u64;
    let mut maximum_pair_keys = 0_u32;
    let mut compatible_cells = 0_u32;
    for representative in representatives {
        if representative
            .masks
            .iter()
            .any(|&mask| usize::from(mask) >= 1 << SLOTS)
        {
            return Err(G133SparseError::SemanticMismatch);
        }
        for block in 0..4 {
            let mask = usize::from(representative.masks[block]);
            let row_target = if block == 0 { 260 } else { 261 };
            let cache = if block == 0 { &mut special } else { &mut zero };
            if cache[mask].is_none() {
                let domain = compile_cycle_mod11_domain(representative.masks[block], row_target)?;
                unique_typed_masks = unique_typed_masks
                    .checked_add(1)
                    .ok_or(G133SparseError::StateBudget)?;
                total_configurations = total_configurations
                    .checked_add(u64::from(domain.configurations))
                    .ok_or(G133SparseError::StateBudget)?;
                retained_group_bytes = retained_group_bytes
                    .checked_add(
                        (domain.groups.len() * std::mem::size_of::<CycleMod11Group>()) as u64,
                    )
                    .ok_or(G133SparseError::StateBudget)?;
                cache[mask] = Some(domain);
            }
        }
        let domains = [
            special[usize::from(representative.masks[0])]
                .as_ref()
                .ok_or(G133SparseError::SemanticMismatch)?,
            zero[usize::from(representative.masks[1])]
                .as_ref()
                .ok_or(G133SparseError::SemanticMismatch)?,
            zero[usize::from(representative.masks[2])]
                .as_ref()
                .ok_or(G133SparseError::SemanticMismatch)?,
            zero[usize::from(representative.masks[3])]
                .as_ref()
                .ok_or(G133SparseError::SemanticMismatch)?,
        ];
        let block_groups = std::array::from_fn(|block| domains[block].groups.len() as u32);
        let pairings = [[0_usize, 1, 2, 3], [0, 2, 1, 3], [0, 3, 1, 2]];
        let pairing = pairings
            .into_iter()
            .min_by_key(|pairing| {
                (u64::from(block_groups[pairing[0]]) * u64::from(block_groups[pairing[1]]))
                    .max(u64::from(block_groups[pairing[2]]) * u64::from(block_groups[pairing[3]]))
            })
            .ok_or(G133SparseError::SemanticMismatch)?;
        let left_group_pairs =
            u64::from(block_groups[pairing[0]]) * u64::from(block_groups[pairing[1]]);
        let right_group_pairs =
            u64::from(block_groups[pairing[2]]) * u64::from(block_groups[pairing[3]]);
        table.fill(EMPTY_CYCLE_MOD11_PAIR_SLOT);
        let right_pair_keys = insert_cycle_mod11_pair_image(
            &domains[pairing[2]].groups,
            &domains[pairing[3]].groups,
            &mut table,
        )?;
        maximum_pair_keys = maximum_pair_keys.max(right_pair_keys);
        let mod11_compatible = cycle_mod11_pair_images_compatible(
            &domains[pairing[0]].groups,
            &domains[pairing[1]].groups,
            &table,
        );
        compatible_cells += u32::from(mod11_compatible);
        rows.push(G133CycleMod11CellRow {
            cell_id: representative.cell_id,
            masks: representative.masks,
            pairing: pairing.map(|block| block as u8),
            block_groups,
            left_group_pairs,
            right_group_pairs,
            right_pair_keys,
            mod11_compatible,
        });
    }
    Ok(G133CycleMod11Report {
        cells: rows.len() as u32,
        excluded_cells: rows.len() as u32 - compatible_cells,
        compatible_cells,
        unique_typed_masks,
        total_configurations,
        maximum_pair_keys,
        workspace_bytes: (table.capacity() * std::mem::size_of::<CycleMod11PairSlot>()) as u64
            + retained_group_bytes,
        rows: rows.into_boxed_slice(),
        provenance: "discovery-only exact modulus-11 join over structural three-cycle residues on supplied cells; block profiles are independently projected to the exact q6 compiler, but cell-transfer authority is external",
    })
}

#[inline(always)]
fn oracle_add_cycle_coarse(left: u64, right: u64) -> Option<u64> {
    let energy = (left >> 26).checked_add(right >> 26)?;
    let q1 = ((left >> 13) & 0x1fff).checked_add((right >> 13) & 0x1fff)?;
    let q6 = (left & 0x1fff).checked_add(right & 0x1fff)?;
    if energy > DEFECT_TARGET as u64 || q1 > 15_080 || q6 > 15_080 {
        return None;
    }
    Some((energy << 28) | (q1 << 14) | q6)
}

#[inline(always)]
fn oracle_residue_sumset11(left: u16, right: u16) -> u16 {
    let mut output = 0_u16;
    for first in 0..11_u32 {
        if left & (1_u16 << first) == 0 {
            continue;
        }
        for second in 0..11_u32 {
            if right & (1_u16 << second) != 0 {
                output |= 1_u16 << ((first + second) % 11);
            }
        }
    }
    output
}

#[inline(always)]
fn oracle_cycle_complement(sum: u64) -> u64 {
    let energy = sum >> 28;
    let q1 = (sum >> 14) & 0x3fff;
    let q6 = sum & 0x3fff;
    ((DEFECT_TARGET as u64 - energy) << 28) | ((15_080_u64 - q1) << 14) | (15_080_u64 - q6)
}

fn compile_cycle_mod11_oracle_image(
    first: &[CycleMod11Group],
    second: &[CycleMod11Group],
) -> Result<(Vec<CycleMod11OracleKey>, Vec<u16>, u64), G133SparseError> {
    let raw_pairs = first
        .len()
        .checked_mul(second.len())
        .ok_or(G133SparseError::StateBudget)?;
    if raw_pairs > MAX_COARSE_HASH_SLOTS {
        return Err(G133SparseError::StateBudget);
    }
    let mut keys = Vec::new();
    keys.try_reserve_exact(raw_pairs)
        .map_err(|_| G133SparseError::StateBudget)?;
    for left in first {
        for right in second {
            if let Some(key) = oracle_add_cycle_coarse(left.key, right.key) {
                keys.push(CycleMod11OracleKey { key });
            }
        }
    }
    keys.sort_unstable_by_key(|record| record.key);
    keys.dedup_by_key(|record| record.key);
    let mut residues = Vec::new();
    residues
        .try_reserve_exact(keys.len())
        .map_err(|_| G133SparseError::StateBudget)?;
    residues.resize(keys.len(), 0_u16);
    for left in first {
        for right in second {
            let Some(key) = oracle_add_cycle_coarse(left.key, right.key) else {
                continue;
            };
            let position = keys
                .binary_search_by_key(&key, |record| record.key)
                .map_err(|_| G133SparseError::SemanticMismatch)?;
            residues[position] |= oracle_residue_sumset11(left.residues, right.residues);
        }
    }
    Ok((keys, residues, raw_pairs as u64))
}

fn cycle_mod11_oracle_compatible(
    first: &[CycleMod11Group],
    second: &[CycleMod11Group],
    complement_keys: &[CycleMod11OracleKey],
    complement_residues: &[u16],
) -> Result<bool, G133SparseError> {
    if complement_keys.len() != complement_residues.len() {
        return Err(G133SparseError::SemanticMismatch);
    }
    for left in first {
        for right in second {
            let Some(sum) = oracle_add_cycle_coarse(left.key, right.key) else {
                continue;
            };
            let complement = oracle_cycle_complement(sum);
            let Ok(position) =
                complement_keys.binary_search_by_key(&complement, |record| record.key)
            else {
                continue;
            };
            let residues = oracle_residue_sumset11(left.residues, right.residues);
            if oracle_residue_sumset11(residues, complement_residues[position]) & (1_u16 << 3) != 0
            {
                return Ok(true);
            }
        }
    }
    Ok(false)
}

/// Independent ordered-vector replay of the structural modulus-11 join.
///
/// This implementation shares the sealed block extractor but neither the
/// primary open-addressing table nor its rotate-based residue convolution.
/// It allocates its bounded workspaces before the pair loops, then performs
/// generation, reduction, and lookup without allocation or recursion.
pub fn oracle_g133_cycle_mod11_cells(
    representatives: &[G133CellRootRepresentative],
) -> Result<G133CycleMod11OracleReport, G133SparseError> {
    if representatives.is_empty() || representatives.len() > MAX_PAIR_PROFILES {
        return Err(G133SparseError::StateBudget);
    }
    let mut special: [Option<CycleMod11Domain>; 1 << SLOTS] = std::array::from_fn(|_| None);
    let mut zero: [Option<CycleMod11Domain>; 1 << SLOTS] = std::array::from_fn(|_| None);
    let mut rows = Vec::new();
    rows.try_reserve_exact(representatives.len())
        .map_err(|_| G133SparseError::StateBudget)?;
    let mut unique_typed_masks = 0_u16;
    let mut total_configurations = 0_u64;
    let mut retained_group_bytes = 0_u64;
    let mut maximum_raw_right_pairs = 0_u64;
    let mut maximum_pair_keys = 0_u32;
    let mut maximum_workspace_bytes = 0_u64;
    let mut compatible_cells = 0_u32;
    for representative in representatives {
        if representative
            .masks
            .iter()
            .any(|&mask| usize::from(mask) >= 1 << SLOTS)
        {
            return Err(G133SparseError::SemanticMismatch);
        }
        for block in 0..4 {
            let mask = usize::from(representative.masks[block]);
            let row_target = if block == 0 { 260 } else { 261 };
            let cache = if block == 0 { &mut special } else { &mut zero };
            if cache[mask].is_none() {
                let domain = compile_cycle_mod11_domain(representative.masks[block], row_target)?;
                unique_typed_masks = unique_typed_masks
                    .checked_add(1)
                    .ok_or(G133SparseError::StateBudget)?;
                total_configurations = total_configurations
                    .checked_add(u64::from(domain.configurations))
                    .ok_or(G133SparseError::StateBudget)?;
                retained_group_bytes = retained_group_bytes
                    .checked_add(
                        (domain.groups.len() * std::mem::size_of::<CycleMod11Group>()) as u64,
                    )
                    .ok_or(G133SparseError::StateBudget)?;
                cache[mask] = Some(domain);
            }
        }
        let domains = [
            special[usize::from(representative.masks[0])]
                .as_ref()
                .ok_or(G133SparseError::SemanticMismatch)?,
            zero[usize::from(representative.masks[1])]
                .as_ref()
                .ok_or(G133SparseError::SemanticMismatch)?,
            zero[usize::from(representative.masks[2])]
                .as_ref()
                .ok_or(G133SparseError::SemanticMismatch)?,
            zero[usize::from(representative.masks[3])]
                .as_ref()
                .ok_or(G133SparseError::SemanticMismatch)?,
        ];
        let block_groups: [u64; 4] =
            std::array::from_fn(|block| domains[block].groups.len() as u64);
        let pairing = [[0_usize, 1, 2, 3], [0, 2, 1, 3], [0, 3, 1, 2]]
            .into_iter()
            .min_by_key(|pairing| {
                (block_groups[pairing[0]] * block_groups[pairing[1]])
                    .max(block_groups[pairing[2]] * block_groups[pairing[3]])
            })
            .ok_or(G133SparseError::SemanticMismatch)?;
        let (keys, residues, raw_right_pairs) = compile_cycle_mod11_oracle_image(
            &domains[pairing[2]].groups,
            &domains[pairing[3]].groups,
        )?;
        let mod11_compatible = cycle_mod11_oracle_compatible(
            &domains[pairing[0]].groups,
            &domains[pairing[1]].groups,
            &keys,
            &residues,
        )?;
        compatible_cells += u32::from(mod11_compatible);
        maximum_raw_right_pairs = maximum_raw_right_pairs.max(raw_right_pairs);
        maximum_pair_keys = maximum_pair_keys
            .max(u32::try_from(keys.len()).map_err(|_| G133SparseError::StateBudget)?);
        maximum_workspace_bytes = maximum_workspace_bytes.max(
            retained_group_bytes
                + (keys.capacity() * std::mem::size_of::<CycleMod11OracleKey>()) as u64
                + (residues.capacity() * std::mem::size_of::<u16>()) as u64,
        );
        rows.push(G133CycleMod11OracleCellRow {
            cell_id: representative.cell_id,
            masks: representative.masks,
            pairing: pairing.map(|block| block as u8),
            raw_right_pairs,
            right_pair_keys: keys.len() as u32,
            mod11_compatible,
        });
    }
    Ok(G133CycleMod11OracleReport {
        cells: rows.len() as u32,
        excluded_cells: rows.len() as u32 - compatible_cells,
        compatible_cells,
        unique_typed_masks,
        total_configurations,
        maximum_raw_right_pairs,
        maximum_pair_keys,
        workspace_bytes: maximum_workspace_bytes,
        rows: rows.into_boxed_slice(),
        provenance: "exact independent ordered-vector replay of the structural modulus-11 join; block extraction is sealed and cross-projected to the exact q6 compiler, while coarse arithmetic and residue convolution do not share the primary hash implementation",
    })
}

fn compile_sorted_coarse_pair_sums(
    first: &[JointCoarseGroup],
    second: &[JointCoarseGroup],
) -> Result<Vec<u64>, G133SparseError> {
    let capacity = first
        .len()
        .checked_mul(second.len())
        .ok_or(G133SparseError::StateBudget)?;
    if capacity > MAX_COARSE_HASH_SLOTS {
        return Err(G133SparseError::StateBudget);
    }
    let mut sums = Vec::new();
    sums.try_reserve_exact(capacity)
        .map_err(|_| G133SparseError::StateBudget)?;
    for left in first {
        for right in second {
            if let Some(sum) = add_joint_coarse(left.key, right.key) {
                sums.push(sum);
            }
        }
    }
    sums.sort_unstable();
    sums.dedup();
    Ok(sums)
}

fn compile_oracle_exact_keys(
    first: &JointCoarseDomain,
    second: &JointCoarseDomain,
    complement_sums: &[u64],
) -> Result<Vec<u32>, G133SparseError> {
    let mut capacity = 0_u64;
    for left in first.groups.iter() {
        for right in second.groups.iter() {
            let Some(sum) = add_joint_coarse(left.key, right.key) else {
                continue;
            };
            let complement = complement_joint_coarse(sum) - 1;
            if complement_sums.binary_search(&complement).is_ok() {
                capacity = capacity
                    .checked_add(u64::from(left.states) * u64::from(right.states))
                    .ok_or(G133SparseError::StateBudget)?;
            }
        }
    }
    let capacity = usize::try_from(capacity).map_err(|_| G133SparseError::StateBudget)?;
    if capacity > MAX_FILTERED_JOINT_PAIRS {
        return Err(G133SparseError::StateBudget);
    }
    let mut keys = Vec::new();
    keys.try_reserve_exact(capacity)
        .map_err(|_| G133SparseError::StateBudget)?;
    for left in first.groups.iter() {
        for right in second.groups.iter() {
            let Some(sum) = add_joint_coarse(left.key, right.key) else {
                continue;
            };
            let complement = complement_joint_coarse(sum) - 1;
            if complement_sums.binary_search(&complement).is_err() {
                continue;
            }
            let left_begin = left.offset as usize;
            let right_begin = right.offset as usize;
            for first_state in &first.states[left_begin..left_begin + left.states as usize] {
                for second_state in &second.states[right_begin..right_begin + right.states as usize]
                {
                    if let Some(key) = joint_q3_q9_pair_key(first_state.state, second_state.state) {
                        keys.push(key);
                    }
                }
            }
        }
    }
    keys.sort_unstable();
    keys.dedup();
    Ok(keys)
}

/// Independent sorted-vector oracle for the scoped exact join. It shares the
/// typed block extractor but not the primary hash table or pair records.
pub fn verify_g133_joint_shift_exact_root(
    representative: G133CellRootRepresentative,
) -> Result<G133JointShiftExactOracleReport, G133SparseError> {
    let domains = [
        compile_joint_coarse_domain(representative.masks[0], 260)?,
        compile_joint_coarse_domain(representative.masks[1], 261)?,
        compile_joint_coarse_domain(representative.masks[2], 261)?,
        compile_joint_coarse_domain(representative.masks[3], 261)?,
    ];
    let unique_states: [u32; 4] = std::array::from_fn(|block| domains[block].states.len() as u32);
    let pairings = [[0_usize, 1, 2, 3], [0, 2, 1, 3], [0, 3, 1, 2]];
    let pairing = pairings
        .into_iter()
        .min_by_key(|pairing| {
            (u64::from(unique_states[pairing[0]]) * u64::from(unique_states[pairing[1]]))
                .max(u64::from(unique_states[pairing[2]]) * u64::from(unique_states[pairing[3]]))
        })
        .ok_or(G133SparseError::SemanticMismatch)?;
    let right_sums =
        compile_sorted_coarse_pair_sums(&domains[pairing[2]].groups, &domains[pairing[3]].groups)?;
    let maximum_sorted_coarse_pairs = (domains[pairing[2]].groups.len() as u64
        * domains[pairing[3]].groups.len() as u64)
        .max(domains[pairing[0]].groups.len() as u64 * domains[pairing[1]].groups.len() as u64);
    let mut workspace_bytes = right_sums.capacity() * std::mem::size_of::<u64>();
    let left_keys =
        compile_oracle_exact_keys(&domains[pairing[0]], &domains[pairing[1]], &right_sums)?;
    workspace_bytes = workspace_bytes
        .checked_add(left_keys.capacity() * std::mem::size_of::<u32>())
        .ok_or(G133SparseError::StateBudget)?;
    drop(right_sums);
    let left_sums =
        compile_sorted_coarse_pair_sums(&domains[pairing[0]].groups, &domains[pairing[1]].groups)?;
    workspace_bytes = workspace_bytes.max(
        left_sums.capacity() * std::mem::size_of::<u64>()
            + left_keys.capacity() * std::mem::size_of::<u32>(),
    );
    let right_keys =
        compile_oracle_exact_keys(&domains[pairing[2]], &domains[pairing[3]], &left_sums)?;
    workspace_bytes = workspace_bytes
        .checked_add(right_keys.capacity() * std::mem::size_of::<u32>())
        .ok_or(G133SparseError::StateBudget)?;
    let common_witness = left_keys.iter().any(|&key| {
        right_keys
            .binary_search(&complement_joint_q3_q9(key))
            .is_ok()
    });
    Ok(G133JointShiftExactOracleReport {
        cell_id: representative.cell_id,
        masks: representative.masks,
        pairing: pairing.map(|block| block as u8),
        left_exact_keys: left_keys.len() as u32,
        right_exact_keys: right_keys.len() as u32,
        common_witness,
        maximum_sorted_coarse_pairs,
        workspace_bytes: workspace_bytes as u64,
        provenance: "independent exact-computational sorted-vector replay of the scoped q1/q3/q6/q9 join; it shares only the typed direct block-state extractor with the primary fixed-hash/pair-record implementation",
    })
}

/// Discovery-only exact-state compiler followed by a necessary quotient-shift
/// congruence.
///
/// The returned exclusions are mathematically exact modulo 64, but this scout
/// intentionally carries no pruning authority until an independent replay is
/// added. Pair construction is bounded by the finite `(energy,q1)` carrier
/// and stores one 64-bit shifted-PAF residue set per retained pair state.
pub fn scout_g133_sparse_shift_mod64(
    shift: usize,
) -> Result<G133SparseQ2Mod64Report, G133SparseError> {
    if !(2..SHIFTS).contains(&shift) {
        return Err(G133SparseError::StateBudget);
    }
    verify_projection()?;
    let (special_profiles, zero_profiles, right_frontier) = compile_mod4_frontier();
    let mut special: [Option<EnergyDomain>; 1 << SLOTS] = std::array::from_fn(|_| None);
    let mut zero: [Option<EnergyDomain>; 1 << SLOTS] = std::array::from_fn(|_| None);
    let mut total_exact_profiles = 0_u64;
    for (profiles, domains, row_target) in [
        (&special_profiles, &mut special, 260_u16),
        (&zero_profiles, &mut zero, 261_u16),
    ] {
        for profile in profiles {
            let slot = &mut domains[usize::from(profile.mask)];
            if slot.is_some() {
                continue;
            }
            let domain = compile_energy_domain(profile.mask, row_target, Some(shift), 0)?;
            total_exact_profiles = total_exact_profiles
                .checked_add(
                    domain
                        .q2_profiles
                        .as_ref()
                        .ok_or(G133SparseError::SemanticMismatch)?
                        .len() as u64,
                )
                .ok_or(G133SparseError::StateBudget)?;
            if total_exact_profiles > MAX_TOTAL_Q2_PROFILES {
                return Err(G133SparseError::StateBudget);
            }
            *slot = Some(domain);
        }
    }
    let special_representatives = q2_class_representatives(&special)?;
    let zero_representatives = q2_class_representatives(&zero)?;
    let special_classes = special_representatives.len();
    let zero_classes = zero_representatives.len();
    let special_class_map = q2_class_map(&special, &special_representatives)?;
    let zero_class_map = q2_class_map(&zero, &zero_representatives)?;
    let mut special_residues = Vec::with_capacity(special_classes);
    for domain in &special_representatives {
        special_residues.push(q2_residue_profiles(domain)?);
    }
    let mut zero_residues = Vec::with_capacity(zero_classes);
    for domain in &zero_representatives {
        zero_residues.push(q2_residue_profiles(domain)?);
    }
    let mut positions = vec![u32::MAX; (DEFECT_TARGET + 1) * (2 * Q1_LIMIT)];
    let mut touched = Vec::with_capacity(4_096);
    let mut special_zero_pairs =
        Vec::<Box<[Q2PairResidueProfile]>>::with_capacity(special_classes * zero_classes);
    let mut zero_zero_pairs =
        Vec::<Box<[Q2PairResidueProfile]>>::with_capacity(zero_classes * zero_classes);
    let mut minimum_pair_profiles = u32::MAX;
    let mut maximum_pair_profiles = 0_u32;
    let mut total_pair_profiles = 0_u64;
    for (left_classes, right_classes, pair_domains) in [
        (&special_residues, &zero_residues, &mut special_zero_pairs),
        (&zero_residues, &zero_residues, &mut zero_zero_pairs),
    ] {
        for left in left_classes {
            for right in right_classes {
                let profiles = compile_q2_pair_residues(left, right, &mut positions, &mut touched)?;
                let count =
                    u32::try_from(profiles.len()).map_err(|_| G133SparseError::StateBudget)?;
                minimum_pair_profiles = minimum_pair_profiles.min(count);
                maximum_pair_profiles = maximum_pair_profiles.max(count);
                total_pair_profiles = total_pair_profiles
                    .checked_add(u64::from(count))
                    .ok_or(G133SparseError::StateBudget)?;
                pair_domains.push(profiles);
            }
        }
    }
    let class_quadruples = special_classes
        .checked_mul(zero_classes)
        .and_then(|value| value.checked_mul(zero_classes))
        .and_then(|value| value.checked_mul(zero_classes))
        .ok_or(G133SparseError::StateBudget)?;
    let mut compatibility = vec![false; class_quadruples];
    let mut compatible_class_quadruples = 0_u32;
    const TARGET_RESIDUE: u32 = (15_080 % 64) as u32;
    for special_class in 0..special_classes {
        for first_zero_class in 0..zero_classes {
            let left = &special_zero_pairs[special_class * zero_classes + first_zero_class];
            for second_zero_class in 0..zero_classes {
                for third_zero_class in 0..zero_classes {
                    let right =
                        &zero_zero_pairs[second_zero_class * zero_classes + third_zero_class];
                    let mut compatible = false;
                    for left_profile in left.iter() {
                        if usize::from(left_profile.energy) > DEFECT_TARGET
                            || u32::from(left_profile.q1) > 15_080
                        {
                            continue;
                        }
                        let required = (
                            (DEFECT_TARGET - usize::from(left_profile.energy)) as u8,
                            (15_080 - u32::from(left_profile.q1)) as u16,
                        );
                        let Ok(position) = right.binary_search_by_key(&required, |profile| {
                            (profile.energy, profile.q1)
                        }) else {
                            continue;
                        };
                        let right_profile = right[position];
                        if u32::from(left_profile.minimum) + u32::from(right_profile.minimum)
                            > 15_080
                            || u32::from(left_profile.maximum) + u32::from(right_profile.maximum)
                                < 15_080
                        {
                            continue;
                        }
                        if residue_sumset64(left_profile.residues, right_profile.residues)
                            & (1_u64 << TARGET_RESIDUE)
                            != 0
                        {
                            compatible = true;
                            break;
                        }
                    }
                    let index = (((special_class * zero_classes + first_zero_class)
                        * zero_classes
                        + second_zero_class)
                        * zero_classes)
                        + third_zero_class;
                    compatibility[index] = compatible;
                    compatible_class_quadruples += u32::from(compatible);
                }
            }
        }
    }
    let mut roots = 0_u64;
    let mut survivors = 0_u64;
    for first in &special_profiles {
        for second in &zero_profiles {
            let required = complement_signature(add_signatures(first.signature, second.signature));
            let begin = right_frontier.partition_point(|pair| pair.signature < required);
            let end = right_frontier.partition_point(|pair| pair.signature <= required);
            for pair in &right_frontier[begin..end] {
                roots = roots.checked_add(1).ok_or(G133SparseError::StateBudget)?;
                let special_class = usize::from(special_class_map[usize::from(first.mask)]);
                let first_zero_class = usize::from(zero_class_map[usize::from(second.mask)]);
                let second_zero_class = usize::from(zero_class_map[usize::from(pair.first)]);
                let third_zero_class = usize::from(zero_class_map[usize::from(pair.second)]);
                if special_class >= special_classes
                    || first_zero_class >= zero_classes
                    || second_zero_class >= zero_classes
                    || third_zero_class >= zero_classes
                {
                    return Err(G133SparseError::SemanticMismatch);
                }
                let index = (((special_class * zero_classes + first_zero_class) * zero_classes
                    + second_zero_class)
                    * zero_classes)
                    + third_zero_class;
                survivors = survivors
                    .checked_add(u64::from(compatibility[index]))
                    .ok_or(G133SparseError::StateBudget)?;
            }
        }
    }
    Ok(G133SparseQ2Mod64Report {
        shift: shift as u8,
        modulus: 64,
        target_residue: TARGET_RESIDUE as u8,
        mod4_roots: roots,
        q2_mod64_survivors: survivors,
        q2_mod64_excluded: roots - survivors,
        special_q2_classes: special_classes as u16,
        zero_q2_classes: zero_classes as u16,
        class_quadruples: class_quadruples as u32,
        compatible_class_quadruples,
        minimum_pair_profiles,
        maximum_pair_profiles,
        total_pair_profiles,
    })
}

pub fn scout_g133_sparse_q2_mod64() -> Result<G133SparseQ2Mod64Report, G133SparseError> {
    scout_g133_sparse_shift_mod64(2)
}

pub fn census_g133_sparse_q0() -> Result<G133SparseQ0Report, G133SparseError> {
    verify_projection()?;
    let (special_profiles, zero_profiles, right_frontier) = compile_mod4_frontier();
    let mut special: [Option<EnergyDomain>; 1 << SLOTS] = std::array::from_fn(|_| None);
    let mut zero: [Option<EnergyDomain>; 1 << SLOTS] = std::array::from_fn(|_| None);
    let mut compiled = 0_u16;
    for profile in &special_profiles {
        if special[usize::from(profile.mask)].is_none() {
            special[usize::from(profile.mask)] =
                Some(compile_energy_domain(profile.mask, 260, None, 0)?);
            compiled += 1;
        }
    }
    for profile in &zero_profiles {
        if zero[usize::from(profile.mask)].is_none() {
            zero[usize::from(profile.mask)] =
                Some(compile_energy_domain(profile.mask, 261, None, 0)?);
            compiled += 1;
        }
    }
    let mut minimum = u32::MAX;
    let mut maximum = 0_u32;
    let mut minimum_configurations = u32::MAX;
    let mut maximum_configurations = 0_u32;
    let mut total_configurations = 0_u64;
    let mut minimum_q1_profiles = u32::MAX;
    let mut maximum_q1_profiles = 0_u32;
    let mut total_q1_profiles = 0_u64;
    for domain in special.iter().chain(zero.iter()).flatten() {
        let count = domain.energies.count_ones();
        minimum = minimum.min(count);
        maximum = maximum.max(count);
        minimum_configurations = minimum_configurations.min(domain.configurations);
        maximum_configurations = maximum_configurations.max(domain.configurations);
        total_configurations = total_configurations
            .checked_add(u64::from(domain.configurations))
            .ok_or(G133SparseError::StateBudget)?;
        let q1_profile_count = domain.q1_profiles.len() as u32;
        minimum_q1_profiles = minimum_q1_profiles.min(q1_profile_count);
        maximum_q1_profiles = maximum_q1_profiles.max(q1_profile_count);
        total_q1_profiles = total_q1_profiles
            .checked_add(u64::from(q1_profile_count))
            .ok_or(G133SparseError::StateBudget)?;
    }
    let special_representatives = q1_class_representatives(&special)?;
    let zero_representatives = q1_class_representatives(&zero)?;
    let special_q1_classes = special_representatives.len();
    let zero_q1_classes = zero_representatives.len();
    let special_class_map = q1_class_map(&special, &special_representatives)?;
    let zero_class_map = q1_class_map(&zero, &zero_representatives)?;
    let mut pair_seen = vec![0_u64; (DEFECT_TARGET + 1) * (2 * Q1_LIMIT) / 64];
    let mut minimum_pair_profiles = u32::MAX;
    let mut maximum_pair_profiles = 0_u32;
    let mut total_pair_profiles = 0_u64;
    let mut pair_classes = 0_u16;
    let mut special_zero_pairs =
        Vec::<Box<[Q1PairProfile]>>::with_capacity(special_q1_classes * zero_q1_classes);
    let mut zero_zero_pairs =
        Vec::<Box<[Q1PairProfile]>>::with_capacity(zero_q1_classes * zero_q1_classes);
    for (left_classes, right_classes, pair_domains) in [
        (
            &special_representatives,
            &zero_representatives,
            &mut special_zero_pairs,
        ),
        (
            &zero_representatives,
            &zero_representatives,
            &mut zero_zero_pairs,
        ),
    ] {
        for &left in left_classes {
            for &right in right_classes {
                let profiles = compile_q1_pair_profiles(left, right, &mut pair_seen)?;
                let count =
                    u32::try_from(profiles.len()).map_err(|_| G133SparseError::StateBudget)?;
                minimum_pair_profiles = minimum_pair_profiles.min(count);
                maximum_pair_profiles = maximum_pair_profiles.max(count);
                total_pair_profiles = total_pair_profiles
                    .checked_add(u64::from(count))
                    .ok_or(G133SparseError::StateBudget)?;
                pair_classes = pair_classes
                    .checked_add(1)
                    .ok_or(G133SparseError::StateBudget)?;
                pair_domains.push(profiles);
            }
        }
    }
    let compatibility_cells = special_q1_classes
        .checked_mul(zero_q1_classes)
        .and_then(|value| value.checked_mul(zero_q1_classes))
        .and_then(|value| value.checked_mul(zero_q1_classes))
        .ok_or(G133SparseError::StateBudget)?;
    let mut q1_compatibility = vec![None::<Q1ClassWitness>; compatibility_cells];
    for special_class in 0..special_q1_classes {
        for first_zero_class in 0..zero_q1_classes {
            let left_index = special_class * zero_q1_classes + first_zero_class;
            let left = &special_zero_pairs[left_index];
            for second_zero_class in 0..zero_q1_classes {
                for third_zero_class in 0..zero_q1_classes {
                    let right_index = second_zero_class * zero_q1_classes + third_zero_class;
                    let right = &zero_zero_pairs[right_index];
                    let mut witness = None;
                    for left_profile in left.iter() {
                        if usize::from(left_profile.energy) > DEFECT_TARGET
                            || u32::from(left_profile.q1) > 15_080
                        {
                            continue;
                        }
                        let required = (
                            (DEFECT_TARGET - usize::from(left_profile.energy)) as u8,
                            (15_080 - u32::from(left_profile.q1)) as u16,
                        );
                        let Ok(position) = right.binary_search_by_key(&required, |profile| {
                            (profile.energy, profile.q1)
                        }) else {
                            continue;
                        };
                        let right_profile = right[position];
                        witness = Some(Q1ClassWitness {
                            keys: [
                                q1_key(special_representatives[special_class], left_profile.first)?,
                                q1_key(
                                    zero_representatives[first_zero_class],
                                    left_profile.second,
                                )?,
                                q1_key(
                                    zero_representatives[second_zero_class],
                                    right_profile.first,
                                )?,
                                q1_key(
                                    zero_representatives[third_zero_class],
                                    right_profile.second,
                                )?,
                            ],
                        });
                        break;
                    }
                    let compatibility_index =
                        (((special_class * zero_q1_classes + first_zero_class) * zero_q1_classes
                            + second_zero_class)
                            * zero_q1_classes)
                            + third_zero_class;
                    q1_compatibility[compatibility_index] = witness;
                }
            }
        }
    }
    let cache_cells = 1 << (2 * SLOTS);
    let mut special_zero_sums = vec![0_u128; cache_cells];
    let mut zero_zero_sums = vec![0_u128; cache_cells];
    for first in &special_profiles {
        for second in &zero_profiles {
            let index = usize::from(first.mask) * (1 << SLOTS) + usize::from(second.mask);
            special_zero_sums[index] = energy_sumset(
                special[usize::from(first.mask)]
                    .as_ref()
                    .expect("special energy domain exists")
                    .energies,
                zero[usize::from(second.mask)]
                    .as_ref()
                    .expect("zero energy domain exists")
                    .energies,
            );
        }
    }
    for first in &zero_profiles {
        for second in &zero_profiles {
            let index = usize::from(first.mask) * (1 << SLOTS) + usize::from(second.mask);
            zero_zero_sums[index] = energy_sumset(
                zero[usize::from(first.mask)]
                    .as_ref()
                    .expect("zero energy domain exists")
                    .energies,
                zero[usize::from(second.mask)]
                    .as_ref()
                    .expect("zero energy domain exists")
                    .energies,
            );
        }
    }

    let mut roots = 0_u64;
    let mut hits = 0_u64;
    let mut q1_hits = 0_u64;
    let mut q1_witness_full_mod8_hits = 0_u64;
    let mut q1_witness_mod8_mismatch_histogram = [0_u64; 9];
    let mut q1_witness_full_mod16_hits = 0_u64;
    let mut q1_witness_mod16_mismatch_histogram = [0_u64; 9];
    for first in &special_profiles {
        for second in &zero_profiles {
            let required = complement_signature(add_signatures(first.signature, second.signature));
            let begin = right_frontier.partition_point(|pair| pair.signature < required);
            let end = right_frontier.partition_point(|pair| pair.signature <= required);
            let left_index = usize::from(first.mask) * (1 << SLOTS) + usize::from(second.mask);
            let left_sums = special_zero_sums[left_index];
            for pair in &right_frontier[begin..end] {
                roots = roots.checked_add(1).ok_or(G133SparseError::StateBudget)?;
                let right_index = usize::from(pair.first) * (1 << SLOTS) + usize::from(pair.second);
                let right_sums = zero_zero_sums[right_index];
                let mut left_remaining = left_sums;
                let mut decomposition = None;
                while left_remaining != 0 {
                    let left_energy = left_remaining.trailing_zeros() as usize;
                    left_remaining &= left_remaining - 1;
                    if left_energy <= DEFECT_TARGET
                        && right_sums & (1_u128 << (DEFECT_TARGET - left_energy)) != 0
                    {
                        decomposition = Some((left_energy, DEFECT_TARGET - left_energy));
                        break;
                    }
                }
                if let Some((left_energy, right_energy)) = decomposition {
                    let special_domain = special[usize::from(first.mask)]
                        .as_ref()
                        .expect("special energy domain exists");
                    let second_domain = zero[usize::from(second.mask)]
                        .as_ref()
                        .expect("zero energy domain exists");
                    let third_domain = zero[usize::from(pair.first)]
                        .as_ref()
                        .expect("zero energy domain exists");
                    let fourth_domain = zero[usize::from(pair.second)]
                        .as_ref()
                        .expect("zero energy domain exists");
                    let (first_digits, second_digits) =
                        pair_witness(special_domain, second_domain, left_energy)
                            .ok_or(G133SparseError::SemanticMismatch)?;
                    let (third_digits, fourth_digits) =
                        pair_witness(third_domain, fourth_domain, right_energy)
                            .ok_or(G133SparseError::SemanticMismatch)?;
                    replay_q0_hit(
                        [first.mask, second.mask, pair.first, pair.second],
                        [first_digits, second_digits, third_digits, fourth_digits],
                    )?;
                    hits = hits.checked_add(1).ok_or(G133SparseError::StateBudget)?;
                }
                let special_class = usize::from(special_class_map[usize::from(first.mask)]);
                let first_zero_class = usize::from(zero_class_map[usize::from(second.mask)]);
                let second_zero_class = usize::from(zero_class_map[usize::from(pair.first)]);
                let third_zero_class = usize::from(zero_class_map[usize::from(pair.second)]);
                if special_class >= special_q1_classes
                    || first_zero_class >= zero_q1_classes
                    || second_zero_class >= zero_q1_classes
                    || third_zero_class >= zero_q1_classes
                {
                    return Err(G133SparseError::SemanticMismatch);
                }
                let compatibility_index = (((special_class * zero_q1_classes + first_zero_class)
                    * zero_q1_classes
                    + second_zero_class)
                    * zero_q1_classes)
                    + third_zero_class;
                if let Some(witness) = q1_compatibility[compatibility_index] {
                    if decomposition.is_none() {
                        return Err(G133SparseError::SemanticMismatch);
                    }
                    let domains = [
                        special[usize::from(first.mask)]
                            .as_ref()
                            .expect("special energy domain exists"),
                        zero[usize::from(second.mask)]
                            .as_ref()
                            .expect("zero energy domain exists"),
                        zero[usize::from(pair.first)]
                            .as_ref()
                            .expect("zero energy domain exists"),
                        zero[usize::from(pair.second)]
                            .as_ref()
                            .expect("zero energy domain exists"),
                    ];
                    let mut digits = [0_u32; 4];
                    for block in 0..4 {
                        digits[block] = q1_digits(domains[block], witness.keys[block])?;
                    }
                    replay_q1_hit([first.mask, second.mask, pair.first, pair.second], digits)?;
                    q1_hits = q1_hits.checked_add(1).ok_or(G133SparseError::StateBudget)?;
                    let masks = [first.mask, second.mask, pair.first, pair.second];
                    let words: [[u16; QUOTIENT]; 4] =
                        std::array::from_fn(|block| decode_word(masks[block], digits[block]));
                    let mut mod8_mismatches = 0_usize;
                    let mut mod16_mismatches = 0_usize;
                    for shift in 2..SHIFTS {
                        let value = words.iter().map(|word| paf(word, shift)).sum::<u32>();
                        mod8_mismatches += usize::from(value % 8 != 15_080 % 8);
                        mod16_mismatches += usize::from(value % 16 != 15_080 % 16);
                    }
                    q1_witness_mod8_mismatch_histogram[mod8_mismatches] =
                        q1_witness_mod8_mismatch_histogram[mod8_mismatches]
                            .checked_add(1)
                            .ok_or(G133SparseError::StateBudget)?;
                    q1_witness_full_mod8_hits = q1_witness_full_mod8_hits
                        .checked_add(u64::from(mod8_mismatches == 0))
                        .ok_or(G133SparseError::StateBudget)?;
                    q1_witness_mod16_mismatch_histogram[mod16_mismatches] =
                        q1_witness_mod16_mismatch_histogram[mod16_mismatches]
                            .checked_add(1)
                            .ok_or(G133SparseError::StateBudget)?;
                    q1_witness_full_mod16_hits = q1_witness_full_mod16_hits
                        .checked_add(u64::from(mod16_mismatches == 0))
                        .ok_or(G133SparseError::StateBudget)?;
                }
            }
        }
    }
    Ok(G133SparseQ0Report {
        mod4_roots: roots,
        constructive_q0_hits: hits,
        exhaustive_q0_misses: roots - hits,
        block_domains_compiled: compiled,
        minimum_domain_energies: minimum as u8,
        maximum_domain_energies: maximum as u8,
        minimum_domain_configurations: minimum_configurations,
        maximum_domain_configurations: maximum_configurations,
        total_domain_configurations: total_configurations,
        minimum_domain_q1_profiles: minimum_q1_profiles,
        maximum_domain_q1_profiles: maximum_q1_profiles,
        total_domain_q1_profiles: total_q1_profiles,
        special_q1_classes: special_q1_classes as u16,
        zero_q1_classes: zero_q1_classes as u16,
        q1_pair_classes: pair_classes,
        minimum_q1_pair_profiles: minimum_pair_profiles,
        maximum_q1_pair_profiles: maximum_pair_profiles,
        total_q1_pair_profiles: total_pair_profiles,
        constructive_q1_hits: q1_hits,
        exhaustive_q1_misses: roots - q1_hits,
        q1_witness_full_mod8_hits,
        q1_witness_mod8_mismatch_histogram,
        q1_witness_full_mod16_hits,
        q1_witness_mod16_mismatch_histogram,
    })
}

fn verify_projection() -> Result<(), G133SparseError> {
    let partition = CyclicMultiplierOrbitPartition::compile(CARRIER as u32, 133)
        .map_err(|_| G133SparseError::OrbitProjection)?;
    let mut families = [[0_u8; 2]; SLOTS];
    for orbit in 0..partition.orbit_count() as usize {
        let representative = partition.representatives()[orbit] as usize;
        let mut histogram = [0_u8; QUOTIENT];
        let mut point = representative;
        loop {
            histogram[point % QUOTIENT] += 1;
            point = point * 133 % CARRIER;
            if point == representative {
                break;
            }
        }
        let Some((slot, scale)) = SLOT_RESIDUES
            .iter()
            .enumerate()
            .find_map(|(slot, residues)| {
                for scale in [1_u8, 4] {
                    if (0..QUOTIENT).all(|residue| {
                        histogram[residue]
                            == if residues.contains(&residue) {
                                scale
                            } else {
                                0
                            }
                    }) {
                        return Some((slot, scale));
                    }
                }
                None
            })
        else {
            return Err(G133SparseError::OrbitProjection);
        };
        families[slot][usize::from(scale == 4)] += 1;
    }
    if families != [[1, 7]; SLOTS] {
        return Err(G133SparseError::OrbitProjection);
    }
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::allocation_test::tracked_allocations;

    #[test]
    fn projection_and_signature_arithmetic_replay() {
        verify_projection().unwrap();
        for left in [0, 1, 0x3ff, 0xaaaaa] {
            assert_eq!(add_signatures(left, 0), left & 0xfffff);
        }
    }

    #[test]
    fn one_energy_domain_replays_all_retained_energies() {
        let domain = compile_energy_domain(0, 260, None, 0).unwrap();
        for (energy, &digits) in domain.witnesses.iter().enumerate() {
            if digits == u32::MAX {
                continue;
            }
            let word = decode_word(0, digits);
            assert_eq!(word.iter().copied().sum::<u16>(), 260);
            let signed = word
                .iter()
                .map(|&value| {
                    let signed = 2 * i32::from(value) - 29;
                    signed * signed
                })
                .sum::<i32>();
            assert_eq!((signed - 9 * QUOTIENT as i32) / 16, energy as i32);
        }
    }

    #[test]
    fn q2_profiles_replay_and_residue_projection_is_exact() {
        let domain = compile_energy_domain(0, 260, Some(2), 0).unwrap();
        let exact = domain.q2_profiles.as_deref().unwrap();
        for profile in exact {
            let word = decode_word(0, profile.digits);
            assert_eq!(word.iter().copied().sum::<u16>(), 260);
            let energy = ((profile.state >> 26) & 127) as u8;
            let q1 = ((profile.state >> 13) & 8_191) as u16;
            let q2 = (profile.state & 8_191) as u16;
            let signed = word
                .iter()
                .map(|&value| {
                    let signed = 2 * i32::from(value) - 29;
                    signed * signed
                })
                .sum::<i32>();
            assert_eq!((signed - 9 * QUOTIENT as i32) / 16, i32::from(energy));
            assert_eq!(paf(&word, 1), u32::from(q1));
            assert_eq!(paf(&word, 2), u32::from(q2));
        }
        let residues = q2_residue_profiles(&domain).unwrap();
        for profile in residues.iter() {
            let mut expected = 0_u64;
            let mut minimum = u16::MAX;
            let mut maximum = 0_u16;
            for exact_profile in exact {
                let energy = ((exact_profile.state >> 26) & 127) as u8;
                let q1 = ((exact_profile.state >> 13) & 8_191) as u16;
                if (energy, q1) == (profile.energy, profile.q1) {
                    let q2 = (exact_profile.state & 8_191) as u16;
                    expected |= 1_u64 << (q2 % 64);
                    minimum = minimum.min(q2);
                    maximum = maximum.max(q2);
                }
            }
            assert_eq!(profile.residues, expected);
            assert_eq!((profile.minimum, profile.maximum), (minimum, maximum));
        }
    }

    #[test]
    fn mod8_lift_profiles_match_direct_autocorrelation_oracle() {
        let domain = compile_energy_domain(0, 260, None, 1).unwrap();
        let exact = domain.lift_profiles.as_deref().unwrap();
        let base = binary_word(0);
        for profile in exact.iter().step_by(97) {
            let word = decode_word(0, profile.digits);
            let energy = (profile.state >> 29) as u8;
            let q1 = ((profile.state >> 16) & 0x1fff) as u16;
            let signature = profile.state as u8;
            assert_eq!(word.iter().copied().sum::<u16>(), 260);
            assert_eq!(paf(&word, 1), u32::from(q1));
            assert_eq!(
                theorem_mod8_lift_signature(&base, profile.digits).unwrap(),
                signature
            );
            assert_eq!(mod8_lift_signature(&base, &word).unwrap(), signature);
            let signed = word
                .iter()
                .map(|&value| {
                    let signed = 2 * i32::from(value) - 29;
                    signed * signed
                })
                .sum::<i32>();
            assert_eq!((signed - 9 * QUOTIENT as i32) / 16, i32::from(energy));
        }

        let keys = lift_key_profiles(&domain).unwrap();
        for profile in exact.iter().step_by(101) {
            let key = (
                (profile.state >> 29) as u8,
                ((profile.state >> 16) & 0x1fff) as u16,
            );
            let position = keys
                .binary_search_by_key(&key, |candidate| (candidate.energy, candidate.q1))
                .unwrap();
            assert!(bitset_256_contains(
                &keys[position].signatures,
                profile.state as u8
            ));
        }
    }

    #[test]
    fn mod16_lift_profiles_match_direct_autocorrelation_oracle() {
        let domain = compile_energy_domain(0, 260, None, 2).unwrap();
        let exact = domain.lift_profiles.as_deref().unwrap();
        let base = binary_word(0);
        for profile in exact.iter().step_by(97) {
            let word = decode_word(0, profile.digits);
            let signature = profile.state as u16;
            assert_eq!(
                theorem_mod16_lift_signature(&base, profile.digits).unwrap(),
                signature
            );
            assert_eq!(mod16_lift_signature(&base, &word).unwrap(), signature);
        }
    }

    #[test]
    fn residue_sumset_matches_direct_modular_addition() {
        for left in [1_u64, 0x55, 1 << 63, 0x8040_2010_0804_0201] {
            for right in [1_u64, 0xaa, 1 << 63, 0x0102_0408_1020_4080] {
                let mut expected = 0_u64;
                for first in 0..64 {
                    if left & (1_u64 << first) == 0 {
                        continue;
                    }
                    for second in 0..64 {
                        if right & (1_u64 << second) != 0 {
                            expected |= 1_u64 << ((first + second) % 64);
                        }
                    }
                }
                assert_eq!(residue_sumset64(left, right), expected);
            }
        }
    }

    fn dense_key_with_signatures(energy: u8, q1: u16, signatures: &[u16]) -> Mod16DenseKey {
        let mut key = Mod16DenseKey {
            fibres: [[0; 4]; 256],
            q1,
            energy,
            reserved: [0; 5],
        };
        for &signature in signatures {
            let (low, high) = split_mod16_lift_signature(signature);
            key.fibres[usize::from(low)][usize::from(high >> 6)] |= 1_u64 << (high & 63);
        }
        key
    }

    #[test]
    fn mod16_dense_pair_image_matches_direct_digitwise_oracle() {
        let left_signatures = [0x0000_u16, 0x0001, 0x5555, 0xa5c3];
        let right_signatures = [0x0000_u16, 0x0003, 0xaaaa, 0x1357];
        let left = [dense_key_with_signatures(20, 4_000, &left_signatures)];
        let right = [dense_key_with_signatures(30, 5_000, &right_signatures)];
        let mut positions = vec![u32::MAX; (DEFECT_TARGET + 1) * (2 * Q1_LIMIT)];
        let mut touched = Vec::with_capacity(MAX_PAIR_PROFILES);
        let dense =
            compile_mod16_dense_pair_keys(&left, &right, &mut positions, &mut touched).unwrap();
        assert_eq!(dense.len(), 1);
        let sparse = compress_mod16_dense_pairs(&dense).unwrap();
        let actual = sparse_pair_signatures(&sparse, &sparse.keys[0]).unwrap();
        let mut expected = Vec::new();
        for &first in &left_signatures {
            for &second in &right_signatures {
                expected.push(join_signature_mod4(first, second));
            }
        }
        expected.sort_unstable();
        expected.dedup();
        assert_eq!(actual, expected);
        for target in [0_u16, 1, 0x5555, 0xffff, 0x693a] {
            let direct = expected.contains(&target);
            let (_, compiled) = mod16_pair_domains_compatible(
                &sparse,
                &Mod16SparsePairDomain {
                    keys: Box::new([Mod16SparsePairKey {
                        offset: 0,
                        q1: 6_080,
                        energy: 33,
                        len: 1,
                    }]),
                    signatures: Box::new([0]),
                },
                target,
            )
            .unwrap();
            assert_eq!(compiled, direct);
        }
    }

    #[test]
    fn mod4_signature_complement_is_exact() {
        let mut random = 0x7ea1_b94c_36d8_205f_u64;
        for _ in 0..65_536 {
            random ^= random << 13;
            random ^= random >> 7;
            random ^= random << 17;
            let left = random as u16;
            let target = (random >> 32) as u16;
            assert_eq!(
                join_signature_mod4(left, complement_signature_mod4(left, target)),
                target
            );
        }
    }

    #[test]
    fn exact_q2_dense_pair_image_matches_direct_sumset() {
        let mut left = Q2DenseKey {
            values: [0; 256],
            q1: 4_000,
            energy: 20,
            reserved: [0; 5],
        };
        let mut right = Q2DenseKey {
            values: [0; 256],
            q1: 5_000,
            energy: 30,
            reserved: [0; 5],
        };
        let left_values = [0_usize, 7, 64, 1_023, 8_191];
        let right_values = [1_usize, 9, 65, 2_000, 7_000];
        for &value in &left_values {
            left.values[value / 64] |= 1_u64 << (value % 64);
        }
        for &value in &right_values {
            right.values[value / 64] |= 1_u64 << (value % 64);
        }
        let left = [left];
        let right = [right];
        let mut positions = vec![u32::MAX; (DEFECT_TARGET + 1) * (2 * Q1_LIMIT)];
        let mut touched = Vec::with_capacity(MAX_PAIR_PROFILES);
        let dense =
            compile_q2_dense_pair_keys(&left, &right, &mut positions, &mut touched).unwrap();
        let oracle =
            compile_q2_dense_pair_keys_shift_oracle(&left, &right, &mut positions, &mut touched)
                .unwrap();
        assert_eq!(dense, oracle);
        let sparse = compress_q2_dense_pairs(&dense).unwrap();
        let key = &sparse.keys[0];
        let holes = scalar_pair_holes(&sparse, key).unwrap();
        let mut expected = Vec::new();
        for &first in &left_values {
            for &second in &right_values {
                expected.push((first + second) as u16);
            }
        }
        expected.sort_unstable();
        expected.dedup();
        assert_eq!(usize::from(key.exact_len), expected.len());
        for value in key.minimum..=key.maximum {
            assert_eq!(
                scalar_pair_contains(holes, key, value),
                expected.contains(&value)
            );
        }
    }

    #[test]
    fn scalar_gap_sum_witness_matches_direct_oracle_without_hot_allocations() {
        let dense = |values: &[u16]| {
            let mut key = Q2DenseKey {
                values: [0; 256],
                q1: 0,
                energy: 0,
                reserved: [0; 5],
            };
            for &value in values {
                key.values[usize::from(value) / 64] |= 1_u64 << (value & 63);
            }
            compress_q2_dense_pairs(&[key]).unwrap()
        };
        let left_values = [0_u16, 1, 63, 64, 129, 511, 1_023];
        let right_values = [2_u16, 7, 65, 130, 510, 1_024];
        let left = dense(&left_values);
        let right = dense(&right_values);
        for target in 0_u16..=2_047 {
            let expected = left_values
                .iter()
                .any(|&first| right_values.iter().any(|&second| first + second == target));
            let actual =
                scalar_pair_sum_witness(&left, &left.keys[0], &right, &right.keys[0], target)
                    .unwrap();
            assert_eq!(actual.is_some(), expected);
            if let Some(first) = actual {
                assert!(left_values.contains(&first));
                assert!(right_values.contains(&(target - first)));
            }
        }
        let (_, allocations) = tracked_allocations(|| {
            for target in 0_u16..=2_047 {
                std::hint::black_box(
                    scalar_pair_sum_witness(&left, &left.keys[0], &right, &right.keys[0], target)
                        .unwrap(),
                );
            }
        });
        assert_eq!(allocations, 0);
    }

    #[test]
    fn hole_coverage_counts_explain_exact_sumset_obstruction() {
        let dense = |values: &[u16], energy: u8, q1: u16| {
            let mut key = Q2DenseKey {
                values: [0; 256],
                q1,
                energy,
                reserved: [0; 5],
            };
            for &value in values {
                key.values[usize::from(value) / 64] |= 1_u64 << (value & 63);
            }
            compress_q2_dense_pairs(&[key]).unwrap()
        };
        let blocked_left = dense(&[0, 128], 20, 4_000);
        let surviving_left = dense(&[0, 64, 128], 20, 4_000);
        let right = dense(&[15_016], 63, 11_080);
        assert_eq!(
            scalar_pair_sumset_counts(&blocked_left, &right).unwrap(),
            (1, 1)
        );
        assert_eq!(
            scalar_pair_sumset_counts(&surviving_left, &right).unwrap(),
            (1, 0)
        );
    }

    #[test]
    fn shifted_q2_bitset_kernel_allocates_nothing() {
        let input = [0x8040_2010_0804_0201_u64; 256];
        let mut output = [0_u64; 256];
        let (_, allocations) = tracked_allocations(|| {
            for shift in 0..8_192 {
                output.fill(0);
                or_shifted_q2_bitset(&mut output, &input, shift);
                std::hint::black_box(&output);
            }
        });
        assert_eq!(allocations, 0);
    }

    #[test]
    fn exact_shift_root_filter_lookup_allocates_nothing() {
        let filter = G133ExactShiftRootFilter {
            report: G133SparseExactShiftReport {
                shift: 6,
                mod4_roots: 64,
                q0_q1_roots: 2,
                exact_shift_candidates: 2,
                exact_shift_reduction: 0,
                special_classes: 0,
                zero_classes: 0,
                q0_q1_class_cells: 0,
                exact_shift_class_cells: 0,
                total_pair_keys: 0,
                total_pair_values: 0,
                stored_pair_holes: 0,
                maximum_values_per_pair_key: 0,
                independent_pair_oracle: true,
                candidate_digest: [0; 32],
                provenance: "test",
            },
            root_count: 64,
            candidates: Box::new([0x8000_0000_0000_0001]),
        };
        let (_, allocations) = tracked_allocations(|| {
            for root in 0..1_000_000_u64 {
                std::hint::black_box(filter.contains(root & 63));
            }
        });
        assert_eq!(allocations, 0);
        assert!(filter.contains(0));
        assert!(filter.contains(63));
        assert!(!filter.contains(64));
    }

    #[test]
    fn joint_shift_profile_replays_all_four_quotient_shifts() {
        let domain = compile_energy_domain(0, 260, None, 0).unwrap();
        let (energy, &digits) = domain
            .witnesses
            .iter()
            .enumerate()
            .find(|(_, digits)| **digits != u32::MAX)
            .unwrap();
        let profile = joint_shift_profile(0, digits, energy as u8).unwrap();
        let word = decode_word(0, digits);
        assert_eq!((profile.state >> 52) & 127, energy as u64);
        assert_eq!((profile.state >> 39) & 0x1fff, u64::from(paf(&word, 1)));
        assert_eq!((profile.state >> 26) & 0x1fff, u64::from(paf(&word, 3)));
        assert_eq!((profile.state >> 13) & 0x1fff, u64::from(paf(&word, 6)));
        assert_eq!(profile.state & 0x1fff, u64::from(paf(&word, 9)));
    }

    #[test]
    fn three_cycle_identity_is_exact_and_allocation_free() {
        let mut state = 0x1016_2092_d00d_feed_u64;
        let (_, allocations) = tracked_allocations(|| {
            for _ in 0..10_000 {
                let word = std::array::from_fn(|_| {
                    state = state
                        .wrapping_mul(6_364_136_223_846_793_005)
                        .wrapping_add(1);
                    ((state >> 59) & 31) as u16
                });
                assert!(verify_three_cycle_energy_identity(&word));
                let evolved = (-2_i64 * i64::from(paf(&word, 3)) - i64::from(paf(&word, 9)))
                    .rem_euclid(11) as u32;
                assert_eq!(three_cycle_affine_residue(&word, 11), evolved);
            }
        });
        assert_eq!(allocations, 0);
    }

    #[test]
    fn rotate_and_direct_mod11_sumsets_agree_without_allocation() {
        for left in 0..11_u32 {
            for right in 0..11_u32 {
                let left = 1_u16 << left;
                let right = 1_u16 << right;
                assert_eq!(
                    residue_sumset11(left, right),
                    oracle_residue_sumset11(left, right)
                );
            }
        }
        let mut state = 0xc101_6013_3209_2d00_u64;
        let (_, allocations) = tracked_allocations(|| {
            for _ in 0..100_000 {
                state = state
                    .wrapping_mul(6_364_136_223_846_793_005)
                    .wrapping_add(1);
                let left = (state as u16) & 0x07ff;
                state = state
                    .wrapping_mul(6_364_136_223_846_793_005)
                    .wrapping_add(1);
                let right = (state as u16) & 0x07ff;
                assert_eq!(
                    residue_sumset11(left, right),
                    oracle_residue_sumset11(left, right)
                );
            }
        });
        assert_eq!(allocations, 0);
    }

    #[test]
    fn hash_and_ordered_cycle_pair_images_have_the_same_semantics() {
        let first = [
            CycleMod11Group {
                key: (3_u64 << 26) | (100_u64 << 13) | 200,
                residues: 0b101,
                reserved: [0; 6],
            },
            CycleMod11Group {
                key: (4_u64 << 26) | (110_u64 << 13) | 210,
                residues: 0b1_0000,
                reserved: [0; 6],
            },
        ];
        let second = [
            CycleMod11Group {
                key: (5_u64 << 26) | (120_u64 << 13) | 220,
                residues: 0b10,
                reserved: [0; 6],
            },
            CycleMod11Group {
                key: (6_u64 << 26) | (130_u64 << 13) | 230,
                residues: 0b1000_0000,
                reserved: [0; 6],
            },
        ];
        let mut table = [EMPTY_CYCLE_MOD11_PAIR_SLOT; 16];
        let keys = insert_cycle_mod11_pair_image(&first, &second, &mut table).unwrap();
        let (oracle_keys, oracle_residues, raw_pairs) =
            compile_cycle_mod11_oracle_image(&first, &second).unwrap();
        assert_eq!(raw_pairs, 4);
        assert_eq!(usize::try_from(keys).unwrap(), oracle_keys.len());
        for (record, &residues) in oracle_keys.iter().zip(&oracle_residues) {
            assert_eq!(cycle_mod11_pair_lookup(&table, record.key), residues);
        }
        let (_, allocations) = tracked_allocations(|| {
            for _ in 0..10_000 {
                std::hint::black_box(cycle_mod11_pair_images_compatible(&first, &second, &table));
                std::hint::black_box(
                    cycle_mod11_oracle_compatible(&first, &second, &oracle_keys, &oracle_residues)
                        .unwrap(),
                );
            }
        });
        assert_eq!(allocations, 0);
    }

    #[test]
    fn joint_shift_profile_kernels_allocate_nothing() {
        let mut workspace = Vec::with_capacity(MAX_Q2_PROFILES_PER_DOMAIN);
        compile_joint_shift_profiles_into(0, 260, &mut workspace).unwrap();
        let (_, allocations) = tracked_allocations(|| {
            std::hint::black_box(
                compile_joint_shift_profiles_into(0, 260, &mut workspace).unwrap(),
            );
            for profile in workspace.iter().take(10_000) {
                std::hint::black_box(
                    joint_shift_profile(0, profile.digits, (profile.state >> 52) as u8).unwrap(),
                );
            }
        });
        assert_eq!(allocations, 0);
    }

    #[test]
    fn coarse_pair_hash_and_complement_are_exact_and_allocation_free() {
        let left = (20_u64 << 26) | (3_000_u64 << 13) | 4_000;
        let right = (10_u64 << 26) | (2_000_u64 << 13) | 1_000;
        let sum = add_joint_coarse(left, right).unwrap();
        let complement = complement_joint_coarse(sum);
        let expected = ((53_u64 << 28) | (10_080_u64 << 14) | 10_080) + 1;
        assert_eq!(complement, expected);
        let mut table = [0_u64; 16];
        assert!(coarse_hash_insert(&mut table, complement).unwrap());
        assert!(!coarse_hash_insert(&mut table, complement).unwrap());
        assert!(coarse_hash_contains(&table, complement));
        let (_, allocations) = tracked_allocations(|| {
            for value in 1..10_000_u64 {
                table.fill(0);
                coarse_hash_insert(&mut table, value).unwrap();
                std::hint::black_box(coarse_hash_contains(&table, value));
            }
        });
        assert_eq!(allocations, 0);
    }

    #[test]
    fn exact_shift_boundaries_fail_closed() {
        assert_eq!(
            scout_g133_sparse_exact_shift_pair_shape(1),
            Err(G133SparseError::StateBudget)
        );
        assert_eq!(
            scout_g133_sparse_exact_shift_pair_shape(SHIFTS),
            Err(G133SparseError::StateBudget)
        );
        assert_eq!(
            scout_g133_sparse_exact_shift(1),
            Err(G133SparseError::StateBudget)
        );
        assert_eq!(
            scout_g133_sparse_exact_shift(SHIFTS),
            Err(G133SparseError::StateBudget)
        );
        assert_eq!(
            scout_g133_sparse_exact_shift_intersection(2, 2),
            Err(G133SparseError::StateBudget)
        );
        assert_eq!(
            g133_shift_orbit_representative(0),
            Err(G133SparseError::StateBudget)
        );
        assert_eq!(
            g133_shift_orbit_representative(QUOTIENT),
            Err(G133SparseError::StateBudget)
        );
        assert_eq!(
            map_g133_exact_shift_cell_roots(6, &[]),
            Err(G133SparseError::StateBudget)
        );
    }

    #[test]
    fn multiplier_shift_orbits_match_direct_paf() {
        let expected = [1_u8, 2, 3, 2, 1, 6, 1, 2, 9];
        for residues in SLOT_RESIDUES {
            for &residue in residues {
                assert!(residues.contains(&(7 * residue % QUOTIENT)));
            }
        }
        for (shift, &representative) in (1..SHIFTS).zip(&expected) {
            assert_eq!(
                g133_shift_orbit_representative(shift).unwrap(),
                representative
            );
        }
        for mask in 0_u16..1 << SLOTS {
            let word = binary_word(mask);
            for shift in 1..SHIFTS {
                let representative = usize::from(g133_shift_orbit_representative(shift).unwrap());
                assert_eq!(paf(&word, shift), paf(&word, representative));
            }
        }
    }
}
