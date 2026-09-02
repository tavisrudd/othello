//! Discovery-only fine-orbit evolution beneath exact g41 quotient witnesses.

use ergodis::root_execution::{reduce_roots, RootKernel, RootOrdinal};
use serde::Serialize;
use thiserror::Error;

use crate::bitset_sumset::xor_sumset_256_into;
use crate::cyclic_residual_features::{
    extract_cyclic_residual_motif, mine_cyclic_invariant_actions_into, CyclicInvariantAction,
    MAX_CYCLIC_MODULUS,
};
use crate::two_adic_autocorrelation::{
    autocorrelation_total_from_row_sum, lift_autocorrelation,
    synthesize_binary_orbit_autocorrelation_form, BinaryOrbitQuadraticForm,
};
use crate::z2k_subgroup::subgroup_membership_z2k;

use crate::g41_joint_quotient_search::{
    census_g41_joint_full_mitm, enumerate_g41_joint_digit_witnesses, replay_witness,
    G41JointDigitWitnessReport, G41JointQuotientSearchError, G41JointQuotientWitness,
};
use crate::hadamard_2092::CyclicMultiplierOrbitPartition;

const CARRIER: usize = 522;
const QUOTIENT: usize = 18;
const SLOTS: usize = 6;
const SCALES: [u8; SLOTS] = [4, 4, 2, 2, 2, 2];
const SHIFTS_PACK: [u8; SLOTS] = [0, 3, 6, 10, 14, 18];
const SLOT_RESIDUES: [&[usize]; SLOTS] = [
    &[0],
    &[9],
    &[6, 12],
    &[3, 15],
    &[2, 4, 8, 10, 14, 16],
    &[1, 5, 7, 11, 13, 17],
];
pub const Q29_COSETS: [[usize; 4]; 7] = [
    [1, 12, 28, 17],
    [2, 24, 27, 5],
    [3, 7, 26, 22],
    [4, 19, 25, 10],
    [6, 14, 23, 15],
    [8, 9, 21, 20],
    [11, 16, 18, 13],
];

#[repr(transparent)]
#[derive(Clone, Copy)]
struct ResidualTuple<T, const N: usize>([T; N]);

const _: () = assert!(std::mem::size_of::<ResidualTuple<i32, 7>>() == 28);

#[repr(C, align(64))]
#[derive(Clone, Copy)]
pub(crate) struct FineOrbit {
    pub(crate) points: [u16; 12],
    pub(crate) residue_histogram: [u8; 29],
    pub(crate) len: u8,
    _pad: [u8; 10],
}

const _: () =
    assert!(std::mem::size_of::<FineOrbit>() == 64 && std::mem::align_of::<FineOrbit>() == 64);

const EMPTY_ORBIT: FineOrbit = FineOrbit {
    points: [0; 12],
    residue_histogram: [0; 29],
    len: 0,
    _pad: [0; 10],
};

pub(crate) struct FineInventory {
    pub(crate) small: [FineOrbit; SLOTS],
    pub(crate) large: [[FineOrbit; 14]; SLOTS],
    pub(crate) large_len: [u8; SLOTS],
}

#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q29Selection {
    pub root_id: u32,
    pub digits: [u32; 4],
    pub orbit_masks: [u16; 24],
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q29SelectionReplayReport {
    pub selection: G41Q29Selection,
    pub row_sums: [u16; 4],
    pub q29_block_defects: [[u16; 7]; 4],
    pub q29_residual: u64,
    pub q29_fibre_dimensions: [u8; 4],
    pub q29_fibre_dimension: u16,
    pub paf_mismatches: u16,
    pub paf_l1_residual: u64,
    pub paf_max_abs_residual: u32,
    pub first_paf_mismatch: Option<[u32; 2]>,
    pub full_paf_hit: bool,
    pub provenance: &'static str,
}

fn q29_fibre_dimensions(
    inventory: &FineInventory,
    orbit_masks: &[u16; 24],
) -> Result<[u8; 4], G41Q29EvolveError> {
    let mut dimensions = [0_u8; 4];
    for block in 0..4 {
        for slot in 0..SLOTS {
            let len = usize::from(inventory.large_len[slot]);
            let mut grouped = [false; 14];
            for first in 0..len {
                if grouped[first] {
                    continue;
                }
                let mut group_mask = 0_u16;
                let signature = inventory.large[slot][first].residue_histogram;
                for second in first..len {
                    if inventory.large[slot][second].residue_histogram == signature {
                        grouped[second] = true;
                        group_mask |= 1_u16 << second;
                    }
                }
                let group_size = group_mask.count_ones();
                if group_size != 1 && group_size != 2 {
                    return Err(G41Q29EvolveError::SemanticMismatch);
                }
                if group_size == 2
                    && (orbit_masks[block * SLOTS + slot] & group_mask).count_ones() == 1
                {
                    dimensions[block] += 1;
                }
            }
        }
    }
    Ok(dimensions)
}

#[derive(Clone, Copy, Debug, Default, Serialize, PartialEq, Eq)]
pub struct G41Q29ResidualMotif {
    pub multiplier: u16,
    pub support_mask: u64,
    pub positive_mask: u64,
    pub negative_mask: u64,
    pub l1: u32,
    pub l2: u32,
    pub signed_sum: i32,
    pub best_residual: u64,
    pub roots: u32,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q29EvolveReport {
    pub threads: u16,
    pub balance_weight: u8,
    pub roots_examined: u32,
    pub restarts_per_root: u16,
    pub mutations_per_restart: u32,
    pub mutations: u64,
    pub q29_character_hits: u32,
    pub full_paf_hits: u32,
    pub best_residual: u64,
    pub best_correlation: [u32; 29],
    pub best_selection: Option<G41Q29Selection>,
    pub residual_motifs: [G41Q29ResidualMotif; 16],
    pub residual_motif_count: u8,
    pub residual_motif_overflow_roots: u32,
    pub nonzero_residual_sum_roots: u32,
    pub nonzero_residual_sum_scope: [u64; 12],
    pub first_q29_root: Option<u32>,
    pub first_q29_selection: Option<G41Q29Selection>,
    pub first_full_root: Option<u32>,
    pub first_full_selection: Option<G41Q29Selection>,
    pub provenance: &'static str,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q29AllDigitEvolveReport {
    pub threads: u16,
    pub balance_weight: u8,
    pub roots_covered: u32,
    pub interfaces_examined: u64,
    pub minimum_root_interfaces: u32,
    pub maximum_root_interfaces: u32,
    pub restarts_per_interface: u16,
    pub mutations_per_restart: u32,
    pub mutations: u64,
    pub q29_character_hits: u32,
    pub full_paf_hits: u32,
    pub best_residual: u64,
    pub best_correlation: [u32; 29],
    pub best_selection: Option<G41Q29Selection>,
    pub best_residual_motif: Option<G41Q29ResidualMotif>,
    pub first_q29_interface: Option<u32>,
    pub first_q29_selection: Option<G41Q29Selection>,
    pub first_full_interface: Option<u32>,
    pub first_full_selection: Option<G41Q29Selection>,
    pub provenance: &'static str,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q29ThreeMoveScoutReport {
    pub root_id: u32,
    pub initial_residual: u64,
    pub single_moves: [u16; 4],
    pub triple_combinations: u64,
    pub four_move_pair_records: u32,
    pub four_move_pairs_probed: u64,
    pub exact_two_swap_moves: [u32; 4],
    pub radius_2110_pair_records: u64,
    pub radius_2110_profiles_probed: u64,
    pub radius_2110_hit: bool,
    pub radius_2200_records: u64,
    pub radius_2200_profiles_probed: u64,
    pub radius_2200_hit: bool,
    pub radius_2111_pair_records: u64,
    pub radius_2111_profiles_probed: u64,
    pub radius_2111_hit: bool,
    pub radius_2210_records: u64,
    pub radius_2210_profiles_probed: u64,
    pub radius_2210_hit: bool,
    pub triple_block_scope: u8,
    pub recomputed_three_swap_candidates: u32,
    pub radius_3100_records: u64,
    pub radius_3100_profiles_probed: u64,
    pub radius_3100_hit: bool,
    pub radius_3110_records: u64,
    pub radius_3110_profiles_probed: u64,
    pub radius_3110_hit: bool,
    pub radius_3200_records: u64,
    pub radius_3200_profiles_probed: u64,
    pub radius_3200_hit: bool,
    pub best_residual: u64,
    pub q29_hit: bool,
    pub full_paf_hit: bool,
    pub selection: Option<G41Q29Selection>,
    pub provenance: &'static str,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q29BatchedEvolveReport {
    pub root_id: u32,
    pub batch_swaps: u8,
    pub restarts: u16,
    pub mutations_per_restart: u32,
    pub mutations: u64,
    pub accepted_mutations: u64,
    pub uphill_accepted_mutations: u64,
    pub initial_residual: u64,
    pub best_residual: u64,
    pub q29_hit: bool,
    pub full_paf_hit: bool,
    pub best_selection: G41Q29Selection,
    pub provenance: &'static str,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q174EvolveReport {
    pub threads: u16,
    pub attempts: u64,
    pub mutations_per_attempt: u32,
    pub mutations: u64,
    pub accepted_mutations: u64,
    pub q174_hits: u64,
    pub full_paf_hits: u64,
    pub best_initial_q174_squared_residual: u64,
    pub best_q174_squared_residual: u64,
    pub best_q174_l1_residual: u64,
    pub best_q174_max_residual: u16,
    pub best_q174_defect_sum: u64,
    pub best_q174_min_defect: u16,
    pub best_q174_max_defect: u16,
    pub best_q174_zero_energy: u16,
    pub best_selection: Option<G41Q29Selection>,
    pub first_full_selection: Option<G41Q29Selection>,
    pub provenance: &'static str,
}

#[repr(C)]
#[derive(Clone, Copy, Debug, Default)]
struct Q29SingleMove {
    defects: [u32; 7],
    block: u8,
    slot: u8,
    removed: u8,
    added: u8,
}

const _: () = assert!(
    std::mem::size_of::<Q29SingleMove>() == 32 && std::mem::align_of::<Q29SingleMove>() == 4
);

const MAX_Q29_SINGLE_MOVES: usize = 256;

#[repr(C)]
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq, PartialOrd, Ord)]
struct Q29PairDefect {
    values: [u16; 7],
    first: u8,
    second: u8,
}

const _: () = assert!(
    std::mem::size_of::<Q29PairDefect>() == 16 && std::mem::align_of::<Q29PairDefect>() == 2
);

const MAX_Q29_MOVE_PAIRS: usize = MAX_Q29_SINGLE_MOVES * MAX_Q29_SINGLE_MOVES;

#[repr(C)]
#[derive(Clone, Copy, Debug, Default)]
struct Q29Swap {
    slot: u8,
    removed: u8,
    added: u8,
    _pad: u8,
}

const _: () = assert!(std::mem::size_of::<Q29Swap>() == 4);

#[repr(C, align(64))]
#[derive(Clone, Copy, Debug, Default)]
struct Q29DoubleMove {
    defects: [u32; 7],
    swaps: [Q29Swap; 2],
    _pad: [u8; 28],
}

const _: () = assert!(
    std::mem::size_of::<Q29DoubleMove>() == 64 && std::mem::align_of::<Q29DoubleMove>() == 64
);

const MAX_Q29_DOUBLE_MOVES: usize = 1 << 15;

#[repr(C, align(64))]
#[derive(Clone, Copy, Debug, Default)]
struct Q29TripleMove {
    defects: [u32; 7],
    swaps: [Q29Swap; 3],
    _pad: [u8; 24],
}

const _: () = assert!(
    std::mem::size_of::<Q29TripleMove>() == 64 && std::mem::align_of::<Q29TripleMove>() == 64
);

const MAX_Q29_TRIPLE_MOVES: usize = 1 << 21;

#[repr(C)]
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq, PartialOrd, Ord)]
struct Q29DoubleDefectKey {
    values: [u16; 7],
    index: u16,
}

const _: () = assert!(
    std::mem::size_of::<Q29DoubleDefectKey>() == 16
        && std::mem::align_of::<Q29DoubleDefectKey>() == 2
);

#[repr(C)]
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq, PartialOrd, Ord)]
struct Q29OtherDefectKey {
    values: [u16; 7],
    first: u16,
    second: u16,
    _pad: [u8; 14],
}

const _: () = assert!(
    std::mem::size_of::<Q29OtherDefectKey>() == 32
        && std::mem::align_of::<Q29OtherDefectKey>() == 2
);

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q29SeedMod2Report {
    pub roots_examined: u32,
    pub feasible_seed_witnesses: u32,
    pub infeasible_seed_witnesses: u32,
    pub feasible_root_ids: Box<[u32]>,
    pub provenance: &'static str,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q29StructuralParityReport {
    pub roots_examined: u32,
    pub compatible_seed_witnesses: u32,
    pub incompatible_seed_witnesses: u32,
    pub incompatible_root_ids: Box<[u32]>,
    pub synthesized_diagonal: u64,
    pub provenance: &'static str,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q29TwoSwapReport {
    pub root_id: u32,
    pub base_residual: u64,
    pub best_residual: u64,
    pub legal_single_swaps: u32,
    pub single_evaluations: u64,
    pub double_evaluations: u64,
    pub q29_character_hit: bool,
    pub full_paf_hit: bool,
    pub best_selection: G41Q29Selection,
    pub provenance: &'static str,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q29SeedMod4Report {
    pub root_id: u32,
    pub block_correlation_profiles: [u32; 4],
    pub mod4_feasible: bool,
    pub exact_residual: Option<u64>,
    pub full_paf_hit: bool,
    pub selection: Option<G41Q29Selection>,
    pub provenance: &'static str,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q29SeedMod8Report {
    pub root_id: u32,
    pub block_correlation_profiles: [u32; 4],
    pub mod8_feasible: bool,
    pub representative_exact_residual: Option<u64>,
    pub full_paf_hit: bool,
    pub selection: Option<G41Q29Selection>,
    pub provenance: &'static str,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q29SeedMod16Report {
    pub root_id: u32,
    pub block_correlation_profiles: [u32; 4],
    pub mod16_feasible: bool,
    pub representative_exact_residual: Option<u64>,
    pub full_paf_hit: bool,
    pub selection: Option<G41Q29Selection>,
    pub provenance: &'static str,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q29TwoAdicCompressionReport {
    pub root_id: u32,
    pub block: u8,
    pub low_fibres_after_slot: [u32; 6],
    pub full_states_after_slot: [u64; 6],
    pub final_max_fibre: u16,
    pub mod16_correlation_profiles: u32,
    pub additive_base: u32,
    pub additive_affine_image: bool,
    pub additive_hull_profiles: u64,
    pub additive_generator_count: u8,
    pub additive_generators: [u32; 16],
    pub provenance: &'static str,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q29TwoAdicJointReport {
    pub root_id: u32,
    pub block_correlation_profiles: [u32; 4],
    pub block_hull_profiles: [u64; 4],
    pub combined_generator_count: u8,
    pub combined_generators: Vec<u32>,
    pub combined_hull_profiles: u64,
    pub target_in_combined_hull: bool,
    pub pivot_count: u8,
    pub pivot_valuations: [u8; 8],
    pub quotient_row_transform: [[u16; 8]; 8],
    pub base_quotient_residue: [u16; 8],
    pub target_quotient_residue: [u16; 8],
    pub structural_base_invariants: [u16; 2],
    pub structural_target_invariants: [u16; 2],
    pub structural_expected_weighted_sum: u16,
    pub structural_witness_coefficient_parity: u8,
    pub witness_index_32_kernel_proved: bool,
    pub pair_samples: u32,
    pub sampled_left_pair_profiles: u32,
    pub sampled_mod16_match: Option<[u32; 4]>,
    pub sampled_selection: Option<G41Q29Selection>,
    pub sampled_exact_residual: Option<u64>,
    pub sampled_full_paf_hit: bool,
    pub provenance: &'static str,
}

#[repr(C)]
#[derive(Clone, Copy)]
struct OrbitSwap {
    index: u8,
    removed: u8,
    added: u8,
    reserved: u8,
}

const _: () =
    assert!(std::mem::size_of::<OrbitSwap>() == 4 && std::mem::align_of::<OrbitSwap>() == 1);

#[repr(C)]
#[derive(Clone, Copy)]
struct Mod4Choice {
    orbit_masks: [u16; 6],
    state: u16,
    reserved: u16,
}

const _: () =
    assert!(std::mem::size_of::<Mod4Choice>() == 16 && std::mem::align_of::<Mod4Choice>() == 2);

#[repr(C)]
#[derive(Clone, Copy)]
struct Mod4Contribution {
    state: u16,
    orbit_mask: u16,
}

const _: () = assert!(
    std::mem::size_of::<Mod4Contribution>() == 4 && std::mem::align_of::<Mod4Contribution>() == 2
);

#[repr(C)]
#[derive(Clone, Copy)]
struct Mod8Choice {
    state: u32,
    orbit_masks: [u16; 6],
}

const _: () =
    assert!(std::mem::size_of::<Mod8Choice>() == 16 && std::mem::align_of::<Mod8Choice>() == 4);

#[repr(C)]
#[derive(Clone, Copy)]
struct Mod8Contribution {
    state: u32,
    orbit_mask: u16,
    reserved: u16,
}

const _: () = assert!(
    std::mem::size_of::<Mod8Contribution>() == 8 && std::mem::align_of::<Mod8Contribution>() == 4
);

struct Mod8Workspace {
    keys: Box<[u32]>,
    values: Box<[u64]>,
    occupied: Box<[u8]>,
    touched: Vec<u32>,
}

#[repr(C, align(64))]
#[derive(Clone, Copy)]
struct LiftFibre {
    lift_bits: [u64; 4],
    low_state: u32,
    reserved: [u8; 28],
}

const _: () =
    assert!(std::mem::size_of::<LiftFibre>() == 64 && std::mem::align_of::<LiftFibre>() == 64);

impl LiftFibre {
    fn singleton(low_state: u32, lift_state: u8) -> Self {
        let mut output = Self {
            lift_bits: [0; 4],
            low_state,
            reserved: [0; 28],
        };
        output.lift_bits[usize::from(lift_state >> 6)] |= 1_u64 << (lift_state & 63);
        output
    }

    fn cardinality(&self) -> u16 {
        self.lift_bits
            .iter()
            .map(|word| word.count_ones() as u16)
            .sum()
    }
}

struct LiftFibreWorkspace {
    keys: Box<[u32]>,
    values: Box<[u32]>,
    touched: Vec<u32>,
}

impl LiftFibreWorkspace {
    const EMPTY: u32 = u32::MAX;
    const CAPACITY: usize = 1 << 23;
    const MAX_STATES: usize = 3 * Self::CAPACITY / 4;

    fn new() -> Self {
        Self {
            keys: vec![Self::EMPTY; Self::CAPACITY].into_boxed_slice(),
            values: vec![0; Self::CAPACITY].into_boxed_slice(),
            touched: Vec::with_capacity(Self::MAX_STATES),
        }
    }

    fn index_or_insert(&mut self, key: u32, value: u32) -> Result<(u32, bool), G41Q29EvolveError> {
        let mut slot = (key.wrapping_mul(0x9e37_79b1) as usize) & (Self::CAPACITY - 1);
        loop {
            if self.keys[slot] == key {
                return Ok((self.values[slot], false));
            }
            if self.keys[slot] == Self::EMPTY {
                if self.touched.len() == Self::MAX_STATES {
                    return Err(G41Q29EvolveError::StateBudget);
                }
                self.keys[slot] = key;
                self.values[slot] = value;
                self.touched.push(slot as u32);
                return Ok((value, true));
            }
            slot = (slot + 1) & (Self::CAPACITY - 1);
        }
    }

    fn get(&self, key: u32) -> Option<u32> {
        let mut slot = (key.wrapping_mul(0x9e37_79b1) as usize) & (Self::CAPACITY - 1);
        loop {
            if self.keys[slot] == key {
                return Some(self.values[slot]);
            }
            if self.keys[slot] == Self::EMPTY {
                return None;
            }
            slot = (slot + 1) & (Self::CAPACITY - 1);
        }
    }

    fn reset(&mut self) {
        for &slot in &self.touched {
            self.keys[slot as usize] = Self::EMPTY;
        }
        self.touched.clear();
    }
}

impl Mod8Workspace {
    const CAPACITY: usize = 1 << 24;
    const MAX_STATES: usize = 3 * Self::CAPACITY / 4;
    fn new() -> Self {
        Self {
            keys: vec![0; Self::CAPACITY].into_boxed_slice(),
            values: vec![0; Self::CAPACITY].into_boxed_slice(),
            occupied: vec![0; Self::CAPACITY].into_boxed_slice(),
            touched: Vec::with_capacity(Self::MAX_STATES),
        }
    }

    fn insert(&mut self, state: u32) -> Result<bool, G41Q29EvolveError> {
        self.insert_with_value(state, 0)
    }

    fn insert_with_value(&mut self, state: u32, value: u64) -> Result<bool, G41Q29EvolveError> {
        let mut slot = (state.wrapping_mul(0x9e37_79b1) as usize) & (Self::CAPACITY - 1);
        loop {
            if self.occupied[slot] != 0 && self.keys[slot] == state {
                return Ok(false);
            }
            if self.occupied[slot] == 0 {
                if self.touched.len() == Self::MAX_STATES {
                    return Err(G41Q29EvolveError::StateBudget);
                }
                self.keys[slot] = state;
                self.values[slot] = value;
                self.occupied[slot] = 1;
                self.touched.push(slot as u32);
                return Ok(true);
            }
            slot = (slot + 1) & (Self::CAPACITY - 1);
        }
    }

    fn get(&self, state: u32) -> Option<u64> {
        let mut slot = (state.wrapping_mul(0x9e37_79b1) as usize) & (Self::CAPACITY - 1);
        loop {
            if self.occupied[slot] != 0 && self.keys[slot] == state {
                return Some(self.values[slot]);
            }
            if self.occupied[slot] == 0 {
                return None;
            }
            slot = (slot + 1) & (Self::CAPACITY - 1);
        }
    }

    fn reset(&mut self) {
        for &slot in &self.touched {
            self.occupied[slot as usize] = 0;
        }
        self.touched.clear();
    }
}

#[derive(Clone, Debug, Error, PartialEq, Eq)]
pub enum G41Q29EvolveError {
    #[error("g41 q29 orbit inventory or replay mismatch")]
    SemanticMismatch,
    #[error("g41 q29 search budget exceeded")]
    StateBudget,
    #[error("unsupported g41 q29 balance weight {0}; expected one of 0, 1, 2, or 4")]
    UnsupportedBalanceWeight(u8),
    #[error(
        "g41 q29 power-image budget exceeded at mod 2^{bits}, block {block}, slot {slot}, phase {phase}, after {states} states"
    )]
    PowerStateBudget {
        bits: u8,
        block: u8,
        slot: u8,
        phase: &'static str,
        states: u32,
    },
    #[error("parallel root executor rejected the campaign")]
    ParallelExecution,
    #[error(transparent)]
    Quotient(#[from] G41JointQuotientSearchError),
}

fn next_random(state: &mut u64) -> u64 {
    let mut value = *state;
    value ^= value << 13;
    value ^= value >> 7;
    value ^= value << 17;
    *state = value;
    value
}

pub(crate) fn compile_inventory() -> Result<FineInventory, G41Q29EvolveError> {
    let partition = CyclicMultiplierOrbitPartition::compile(CARRIER as u32, 41)
        .map_err(|_| G41Q29EvolveError::SemanticMismatch)?;
    let mut small = [EMPTY_ORBIT; SLOTS];
    let mut small_seen = [false; SLOTS];
    let mut large = [[EMPTY_ORBIT; 14]; SLOTS];
    let mut large_len = [0_u8; SLOTS];
    for &representative in partition.representatives() {
        let mut orbit = EMPTY_ORBIT;
        let mut quotient_histogram = [0_u8; QUOTIENT];
        let mut point = representative as usize;
        loop {
            let index = usize::from(orbit.len);
            if index == orbit.points.len() {
                return Err(G41Q29EvolveError::SemanticMismatch);
            }
            orbit.points[index] = point as u16;
            orbit.residue_histogram[point % 29] += 1;
            quotient_histogram[point % QUOTIENT] += 1;
            orbit.len += 1;
            point = point * 41 % CARRIER;
            if point == representative as usize {
                break;
            }
        }
        let mut family = None;
        for slot in 0..SLOTS {
            for (kind, scale) in [1_u8, SCALES[slot]].into_iter().enumerate() {
                if (0..QUOTIENT).all(|residue| {
                    quotient_histogram[residue]
                        == if SLOT_RESIDUES[slot].contains(&residue) {
                            scale
                        } else {
                            0
                        }
                }) {
                    family = Some((slot, kind));
                }
            }
        }
        let (slot, kind) = family.ok_or(G41Q29EvolveError::SemanticMismatch)?;
        if kind == 0 {
            if small_seen[slot] {
                return Err(G41Q29EvolveError::SemanticMismatch);
            }
            small[slot] = orbit;
            small_seen[slot] = true;
        } else {
            let index = usize::from(large_len[slot]);
            if index == large[slot].len() {
                return Err(G41Q29EvolveError::StateBudget);
            }
            large[slot][index] = orbit;
            large_len[slot] += 1;
        }
    }
    if !small_seen.iter().all(|&seen| seen) || large_len != [7, 7, 14, 14, 14, 14] {
        return Err(G41Q29EvolveError::SemanticMismatch);
    }
    for slot in 0..SLOTS {
        for orbit in
            std::iter::once(&small[slot]).chain(large[slot][..usize::from(large_len[slot])].iter())
        {
            for coset in Q29_COSETS {
                let value = orbit.residue_histogram[coset[0]];
                if coset
                    .iter()
                    .any(|&residue| orbit.residue_histogram[residue] != value)
                {
                    return Err(G41Q29EvolveError::SemanticMismatch);
                }
            }
        }
    }
    Ok(FineInventory {
        small,
        large,
        large_len,
    })
}

pub(crate) fn digit_counts(packed: u32) -> [u8; SLOTS] {
    std::array::from_fn(|slot| {
        let bits = if slot < 2 { 3 } else { 4 };
        ((packed >> SHIFTS_PACK[slot]) & ((1_u32 << bits) - 1)) as u8
    })
}

fn random_fixed_mask(len: u8, count: u8, random: &mut u64) -> u16 {
    let mut mask = 0_u16;
    while mask.count_ones() < u32::from(count) {
        mask |= 1_u16 << (next_random(random) % u64::from(len));
    }
    mask
}

fn initialize_selection(
    witness: &G41JointQuotientWitness,
    inventory: &FineInventory,
    random: &mut u64,
) -> [u16; 24] {
    let mut selection = [0_u16; 24];
    for block in 0..4 {
        let counts = digit_counts(witness.digits[block]);
        for slot in 0..SLOTS {
            selection[block * SLOTS + slot] =
                random_fixed_mask(inventory.large_len[slot], counts[slot], random);
        }
    }
    selection
}

fn add_orbit(coefficients: &mut [u16; 29], orbit: &FineOrbit) {
    for residue in 0..29 {
        coefficients[residue] += u16::from(orbit.residue_histogram[residue]);
    }
}

fn compile_coefficients(
    witness: &G41JointQuotientWitness,
    inventory: &FineInventory,
    selection: &[u16; 24],
) -> [[u16; 29]; 4] {
    std::array::from_fn(|block| compile_block_coefficients(witness, inventory, selection, block))
}

fn compile_block_coefficients(
    witness: &G41JointQuotientWitness,
    inventory: &FineInventory,
    selection: &[u16; 24],
    block: usize,
) -> [u16; 29] {
    let mut coefficients = [0_u16; 29];
    for slot in 0..SLOTS {
        if witness.masks[block] & (1 << slot) != 0 {
            add_orbit(&mut coefficients, &inventory.small[slot]);
        }
        let selected = selection[block * SLOTS + slot];
        for orbit in 0..inventory.large_len[slot] {
            if selected & (1 << orbit) != 0 {
                add_orbit(
                    &mut coefficients,
                    &inventory.large[slot][usize::from(orbit)],
                );
            }
        }
    }
    coefficients
}

fn block_correlations(coefficients: &[u16; 29]) -> [u32; 29] {
    let mut output = [0_u32; 29];
    for shift in 0..29 {
        for residue in 0..29 {
            output[shift] +=
                u32::from(coefficients[residue]) * u32::from(coefficients[(residue + shift) % 29]);
        }
    }
    output
}

fn correlations(coefficients: &[[u16; 29]; 4]) -> ([[u32; 29]; 4], [u32; 29]) {
    let block: [[u32; 29]; 4] =
        std::array::from_fn(|index| block_correlations(&coefficients[index]));
    let total = std::array::from_fn(|shift| block.iter().map(|row| row[shift]).sum());
    (block, total)
}

fn q29_residual(correlation: &[u32; 29]) -> u64 {
    let target = i64::from(correlation[0]) - 523;
    let residuals: ResidualTuple<i32, 7> = ResidualTuple(std::array::from_fn(|class| {
        let representative = Q29_COSETS[class][0];
        i32::try_from(i64::from(correlation[representative]) - target)
            .expect("q29 correlation residual fits i32")
    }));
    residuals
        .0
        .iter()
        .map(|&value| 4 * u64::from(value.unsigned_abs()))
        .sum()
}

#[inline(always)]
fn q29_residual_sum(zero_shift: u32) -> i32 {
    const ROW_SQUARE_SUM: i64 = 260_i64 * 260 + 3 * 261_i64 * 261;
    const NONZERO_SHIFTS: i64 = 28;
    const TARGET_OFFSET: i64 = 523;
    const COSET_SIZE: i64 = 4;
    let numerator = ROW_SQUARE_SUM - 29 * i64::from(zero_shift) + NONZERO_SHIFTS * TARGET_OFFSET;
    debug_assert_eq!(numerator.rem_euclid(COSET_SIZE), 0);
    i32::try_from(numerator / COSET_SIZE).expect("q29 residual sum fits i32")
}

#[inline(always)]
#[cfg(test)]
fn q29_guided_score<const BALANCE_WEIGHT: u8>(correlation: &[u32; 29], residual: u64) -> u64 {
    residual
        + u64::from(BALANCE_WEIGHT) * 4 * u64::from(q29_residual_sum(correlation[0]).unsigned_abs())
}

#[inline(always)]
fn block_q29_defects(coefficients: &[u16; 29]) -> ResidualTuple<u32, 7> {
    ResidualTuple(std::array::from_fn(|class| {
        let shift = Q29_COSETS[class][0];
        let mut doubled = 0_u32;
        for coordinate in 0..29 {
            let difference =
                coefficients[coordinate].abs_diff(coefficients[(coordinate + shift) % 29]);
            doubled += u32::from(difference) * u32::from(difference);
        }
        debug_assert_eq!(doubled & 1, 0);
        doubled / 2
    }))
}

pub fn replay_g41_q29_selection_defects(
    selection: G41Q29Selection,
) -> Result<[[u16; 7]; 4], G41Q29EvolveError> {
    let quotient = census_g41_joint_full_mitm()?;
    let root = quotient
        .witnesses
        .iter()
        .find(|witness| witness.root_id == selection.root_id)
        .ok_or(G41Q29EvolveError::SemanticMismatch)?;
    let witness = G41JointQuotientWitness {
        root_id: root.root_id,
        masks: root.masks,
        digits: selection.digits,
    };
    replay_witness(&witness)?;
    let inventory = compile_inventory()?;
    for block in 0..4 {
        let counts = digit_counts(witness.digits[block]);
        for slot in 0..SLOTS {
            let mask = selection.orbit_masks[block * SLOTS + slot];
            if mask >> inventory.large_len[slot] != 0
                || mask.count_ones() != u32::from(counts[slot])
            {
                return Err(G41Q29EvolveError::SemanticMismatch);
            }
        }
    }
    let coefficients = compile_coefficients(&witness, &inventory, &selection.orbit_masks);
    let profiles = std::array::from_fn(|block| block_q29_defects(&coefficients[block]));
    let output = std::array::from_fn(|block| {
        std::array::from_fn(|coordinate| {
            u16::try_from(profiles[block].0[coordinate])
                .expect("g41 q29 block defect fits the exact profile carrier")
        })
    });
    let total = total_q29_defects(&profiles);
    let direct_residual = q29_defect_residual(&total);
    let (_, correlation) = correlations(&coefficients);
    if direct_residual != q29_residual(&correlation) {
        return Err(G41Q29EvolveError::SemanticMismatch);
    }
    Ok(output)
}

pub fn replay_g41_q29_selection(
    selection: G41Q29Selection,
) -> Result<G41Q29SelectionReplayReport, G41Q29EvolveError> {
    let quotient = census_g41_joint_full_mitm()?;
    let root = quotient
        .witnesses
        .iter()
        .find(|witness| witness.root_id == selection.root_id)
        .ok_or(G41Q29EvolveError::SemanticMismatch)?;
    let witness = G41JointQuotientWitness {
        root_id: root.root_id,
        masks: root.masks,
        digits: selection.digits,
    };
    replay_witness(&witness)?;
    let inventory = compile_inventory()?;
    for block in 0..4 {
        let counts = digit_counts(witness.digits[block]);
        for slot in 0..SLOTS {
            let mask = selection.orbit_masks[block * SLOTS + slot];
            if mask >> inventory.large_len[slot] != 0
                || mask.count_ones() != u32::from(counts[slot])
            {
                return Err(G41Q29EvolveError::SemanticMismatch);
            }
        }
    }
    let coefficients = compile_coefficients(&witness, &inventory, &selection.orbit_masks);
    let profiles: [ResidualTuple<u32, 7>; 4] =
        std::array::from_fn(|block| block_q29_defects(&coefficients[block]));
    let q29_block_defects: [[u16; 7]; 4] = std::array::from_fn(|block| {
        std::array::from_fn(|coordinate| profiles[block].0[coordinate] as u16)
    });
    let (_, correlation) = correlations(&coefficients);
    let q29_residual = q29_residual(&correlation);
    let q29_fibre_dimensions = q29_fibre_dimensions(&inventory, &selection.orbit_masks)?;
    let q29_fibre_dimension = q29_fibre_dimensions
        .iter()
        .map(|&value| u16::from(value))
        .sum();

    let mut words = [[0_u8; CARRIER]; 4];
    for block in 0..4 {
        for slot in 0..SLOTS {
            let mut apply = |orbit: &FineOrbit| {
                for &point in &orbit.points[..usize::from(orbit.len)] {
                    words[block][usize::from(point)] = 1;
                }
            };
            if witness.masks[block] & (1 << slot) != 0 {
                apply(&inventory.small[slot]);
            }
            let selected = selection.orbit_masks[block * SLOTS + slot];
            for orbit in 0..inventory.large_len[slot] {
                if selected & (1 << orbit) != 0 {
                    apply(&inventory.large[slot][usize::from(orbit)]);
                }
            }
        }
    }
    let row_sums = std::array::from_fn(|block| {
        words[block]
            .iter()
            .map(|&value| u16::from(value))
            .sum::<u16>()
    });
    let mut paf_mismatches = 0_u16;
    let mut paf_l1_residual = 0_u64;
    let mut paf_max_abs_residual = 0_u32;
    let mut first_paf_mismatch = None;
    for shift in 1..CARRIER {
        let mut paf = 0_u32;
        for word in &words {
            for position in 0..CARRIER {
                paf += u32::from(word[position] * word[(position + shift) % CARRIER]);
            }
        }
        let residual = paf.abs_diff(520);
        if residual != 0 {
            paf_mismatches += 1;
            paf_l1_residual += u64::from(residual);
            paf_max_abs_residual = paf_max_abs_residual.max(residual);
            first_paf_mismatch.get_or_insert([shift as u32, paf]);
        }
    }
    let full_paf_hit = row_sums == [260, 261, 261, 261] && paf_mismatches == 0;
    Ok(G41Q29SelectionReplayReport {
        selection,
        row_sums,
        q29_block_defects,
        q29_residual,
        q29_fibre_dimensions,
        q29_fibre_dimension,
        paf_mismatches,
        paf_l1_residual,
        paf_max_abs_residual,
        first_paf_mismatch,
        full_paf_hit,
        provenance: "direct replay from the sealed quotient witness and six fine-orbit masks per block; row sums and all 521 nonzero binary PAF equations are recomputed from 522-bit words, independently of q29 profile packing",
    })
}

fn scan_three_move_lists(
    base_total: &ResidualTuple<u32, 7>,
    base_blocks: &[ResidualTuple<u32, 7>; 4],
    blocks: [usize; 3],
    lists: [&[Q29SingleMove]; 3],
) -> (u64, u64, Option<[u8; 3]>) {
    let mut best = u64::MAX;
    let mut tested = 0_u64;
    let mut best_indices = None;
    for (first_index, first) in lists[0].iter().enumerate() {
        for (second_index, second) in lists[1].iter().enumerate() {
            for (third_index, third) in lists[2].iter().enumerate() {
                tested += 1;
                let moves = [first, second, third];
                let mut residual = 0_u64;
                for coordinate in 0..7 {
                    let mut defect = base_total.0[coordinate];
                    for move_index in 0..3 {
                        defect = defect - base_blocks[blocks[move_index]].0[coordinate]
                            + moves[move_index].defects[coordinate];
                    }
                    residual += 4 * u64::from(defect.abs_diff(523));
                }
                if residual < best {
                    best = residual;
                    best_indices = Some([first_index as u8, second_index as u8, third_index as u8]);
                    if best == 0 {
                        return (best, tested, best_indices);
                    }
                }
            }
        }
    }
    (best, tested, best_indices)
}

fn find_four_move_hit(
    lists: [&[Q29SingleMove]; 4],
    workspace: &mut [Q29PairDefect],
) -> (Option<[u8; 4]>, u32, u64) {
    let mut records = 0_usize;
    for (first_index, first) in lists[0].iter().enumerate() {
        for (second_index, second) in lists[1].iter().enumerate() {
            let mut values = [0_u16; 7];
            let mut feasible = true;
            for coordinate in 0..7 {
                let sum = first.defects[coordinate] + second.defects[coordinate];
                if sum > 523 {
                    feasible = false;
                    break;
                }
                values[coordinate] = sum as u16;
            }
            if !feasible {
                continue;
            }
            if records == workspace.len() {
                return (None, u32::MAX, 0);
            }
            workspace[records] = Q29PairDefect {
                values,
                first: first_index as u8,
                second: second_index as u8,
            };
            records += 1;
        }
    }
    workspace[..records].sort_unstable();
    let mut probed = 0_u64;
    for (third_index, third) in lists[2].iter().enumerate() {
        for (fourth_index, fourth) in lists[3].iter().enumerate() {
            probed += 1;
            let mut needed = [0_u16; 7];
            let mut feasible = true;
            for coordinate in 0..7 {
                let sum = third.defects[coordinate] + fourth.defects[coordinate];
                let Some(value) = 523_u32.checked_sub(sum) else {
                    feasible = false;
                    break;
                };
                needed[coordinate] = value as u16;
            }
            if !feasible {
                continue;
            }
            let start = workspace[..records].partition_point(|record| record.values < needed);
            if start < records && workspace[start].values == needed {
                return (
                    Some([
                        workspace[start].first,
                        workspace[start].second,
                        third_index as u8,
                        fourth_index as u8,
                    ]),
                    records as u32,
                    probed,
                );
            }
        }
    }
    (None, records as u32, probed)
}

fn find_double_two_single_hit(
    doubles: &[Q29DoubleMove],
    first: &[Q29SingleMove],
    second: &[Q29SingleMove],
    omitted_defects: &ResidualTuple<u32, 7>,
    workspace: &mut [Q29PairDefect],
) -> (Option<(u16, u8, u8)>, u32, u64) {
    let mut records = 0_usize;
    for (first_index, left) in first.iter().enumerate() {
        for (second_index, right) in second.iter().enumerate() {
            let mut values = [0_u16; 7];
            let mut feasible = true;
            for coordinate in 0..7 {
                let sum = omitted_defects.0[coordinate]
                    + left.defects[coordinate]
                    + right.defects[coordinate];
                if sum > 523 {
                    feasible = false;
                    break;
                }
                values[coordinate] = (left.defects[coordinate] + right.defects[coordinate]) as u16;
            }
            if !feasible {
                continue;
            }
            if records == workspace.len() {
                return (None, u32::MAX, 0);
            }
            workspace[records] = Q29PairDefect {
                values,
                first: first_index as u8,
                second: second_index as u8,
            };
            records += 1;
        }
    }
    workspace[..records].sort_unstable();
    let mut probed = 0_u64;
    for (double_index, double) in doubles.iter().enumerate() {
        probed += 1;
        let mut needed = [0_u16; 7];
        let mut feasible = true;
        for coordinate in 0..7 {
            let partial = omitted_defects.0[coordinate] + double.defects[coordinate];
            let Some(value) = 523_u32.checked_sub(partial) else {
                feasible = false;
                break;
            };
            needed[coordinate] = value as u16;
        }
        if !feasible {
            continue;
        }
        let start = workspace[..records].partition_point(|record| record.values < needed);
        if start < records && workspace[start].values == needed {
            return (
                Some((
                    double_index as u16,
                    workspace[start].first,
                    workspace[start].second,
                )),
                records as u32,
                probed,
            );
        }
    }
    (None, records as u32, probed)
}

fn find_two_double_hit(
    first: &[Q29DoubleMove],
    second: &[Q29DoubleMove],
    fixed: [&ResidualTuple<u32, 7>; 2],
    workspace: &mut [Q29DoubleDefectKey],
) -> (Option<(u16, u16)>, u32, u64) {
    let mut records = 0_usize;
    for (index, item) in first.iter().enumerate() {
        let mut values = [0_u16; 7];
        let mut feasible = true;
        for coordinate in 0..7 {
            let partial =
                fixed[0].0[coordinate] + fixed[1].0[coordinate] + item.defects[coordinate];
            if partial > 523 {
                feasible = false;
                break;
            }
            values[coordinate] = item.defects[coordinate] as u16;
        }
        if !feasible {
            continue;
        }
        if records == workspace.len() {
            return (None, u32::MAX, 0);
        }
        workspace[records] = Q29DoubleDefectKey {
            values,
            index: index as u16,
        };
        records += 1;
    }
    workspace[..records].sort_unstable();
    let mut probed = 0_u64;
    for (second_index, item) in second.iter().enumerate() {
        probed += 1;
        let mut needed = [0_u16; 7];
        let mut feasible = true;
        for coordinate in 0..7 {
            let partial =
                fixed[0].0[coordinate] + fixed[1].0[coordinate] + item.defects[coordinate];
            let Some(value) = 523_u32.checked_sub(partial) else {
                feasible = false;
                break;
            };
            needed[coordinate] = value as u16;
        }
        if !feasible {
            continue;
        }
        let start = workspace[..records].partition_point(|record| record.values < needed);
        if start < records && workspace[start].values == needed {
            return (
                Some((workspace[start].index, second_index as u16)),
                records as u32,
                probed,
            );
        }
    }
    (None, records as u32, probed)
}

fn find_double_single_two_single_hit(
    doubles: &[Q29DoubleMove],
    remaining: &[Q29SingleMove],
    paired_first: &[Q29SingleMove],
    paired_second: &[Q29SingleMove],
    workspace: &mut [Q29PairDefect],
) -> (Option<(u16, u8, u8, u8)>, u32, u64) {
    let mut records = 0_usize;
    for (first_index, first) in paired_first.iter().enumerate() {
        for (second_index, second) in paired_second.iter().enumerate() {
            let mut values = [0_u16; 7];
            let mut feasible = true;
            for coordinate in 0..7 {
                let sum = first.defects[coordinate] + second.defects[coordinate];
                if sum > 523 {
                    feasible = false;
                    break;
                }
                values[coordinate] = sum as u16;
            }
            if !feasible {
                continue;
            }
            if records == workspace.len() {
                return (None, u32::MAX, 0);
            }
            workspace[records] = Q29PairDefect {
                values,
                first: first_index as u8,
                second: second_index as u8,
            };
            records += 1;
        }
    }
    workspace[..records].sort_unstable();
    let mut probed = 0_u64;
    for (double_index, double) in doubles.iter().enumerate() {
        for (remaining_index, single) in remaining.iter().enumerate() {
            probed += 1;
            let mut needed = [0_u16; 7];
            let mut feasible = true;
            for coordinate in 0..7 {
                let partial = double.defects[coordinate] + single.defects[coordinate];
                let Some(value) = 523_u32.checked_sub(partial) else {
                    feasible = false;
                    break;
                };
                needed[coordinate] = value as u16;
            }
            if !feasible {
                continue;
            }
            let start = workspace[..records].partition_point(|record| record.values < needed);
            if start < records && workspace[start].values == needed {
                return (
                    Some((
                        double_index as u16,
                        remaining_index as u8,
                        workspace[start].first,
                        workspace[start].second,
                    )),
                    records as u32,
                    probed,
                );
            }
        }
    }
    (None, records as u32, probed)
}

fn find_two_double_single_hit(
    first: &[Q29DoubleMove],
    second: &[Q29DoubleMove],
    single: &[Q29SingleMove],
    fixed: &ResidualTuple<u32, 7>,
    workspace: &mut [Q29DoubleDefectKey],
) -> (Option<(u16, u16, u8)>, u32, u64) {
    let mut records = 0_usize;
    for (index, item) in first.iter().enumerate() {
        let mut values = [0_u16; 7];
        let mut feasible = true;
        for coordinate in 0..7 {
            if fixed.0[coordinate] + item.defects[coordinate] > 523 {
                feasible = false;
                break;
            }
            values[coordinate] = item.defects[coordinate] as u16;
        }
        if !feasible {
            continue;
        }
        if records == workspace.len() {
            return (None, u32::MAX, 0);
        }
        workspace[records] = Q29DoubleDefectKey {
            values,
            index: index as u16,
        };
        records += 1;
    }
    workspace[..records].sort_unstable();
    let mut probed = 0_u64;
    for (second_index, double) in second.iter().enumerate() {
        for (single_index, item) in single.iter().enumerate() {
            probed += 1;
            let mut needed = [0_u16; 7];
            let mut feasible = true;
            for coordinate in 0..7 {
                let partial =
                    fixed.0[coordinate] + double.defects[coordinate] + item.defects[coordinate];
                let Some(value) = 523_u32.checked_sub(partial) else {
                    feasible = false;
                    break;
                };
                needed[coordinate] = value as u16;
            }
            if !feasible {
                continue;
            }
            let start = workspace[..records].partition_point(|record| record.values < needed);
            if start < records && workspace[start].values == needed {
                return (
                    Some((
                        workspace[start].index,
                        second_index as u16,
                        single_index as u8,
                    )),
                    records as u32,
                    probed,
                );
            }
        }
    }
    (None, records as u32, probed)
}

fn compile_triple_moves(
    witness: &G41JointQuotientWitness,
    inventory: &FineInventory,
    selection: &mut [u16; 24],
    block: usize,
    singles: &[Q29SingleMove],
    output: &mut [Q29TripleMove],
) -> Result<usize, G41Q29EvolveError> {
    let mut length = 0_usize;
    for first_index in 0..singles.len() {
        let first = singles[first_index];
        for second_index in first_index + 1..singles.len() {
            let second = singles[second_index];
            for third in &singles[second_index + 1..] {
                let items = [first, second, *third];
                let mut valid = true;
                for left in 0..3 {
                    for right in left + 1..3 {
                        if items[left].slot == items[right].slot
                            && (items[left].removed == items[right].removed
                                || items[left].added == items[right].added)
                        {
                            valid = false;
                        }
                    }
                }
                if !valid {
                    continue;
                }
                if length == output.len() {
                    return Err(G41Q29EvolveError::StateBudget);
                }
                for item in items {
                    let index = block * SLOTS + usize::from(item.slot);
                    selection[index] ^= (1 << item.removed) | (1 << item.added);
                }
                let coefficients = compile_block_coefficients(witness, inventory, selection, block);
                output[length] = Q29TripleMove {
                    defects: block_q29_defects(&coefficients).0,
                    swaps: items.map(|item| Q29Swap {
                        slot: item.slot,
                        removed: item.removed,
                        added: item.added,
                        _pad: 0,
                    }),
                    _pad: [0; 24],
                };
                length += 1;
                for item in items.into_iter().rev() {
                    let index = block * SLOTS + usize::from(item.slot);
                    selection[index] ^= (1 << item.removed) | (1 << item.added);
                }
            }
        }
    }
    Ok(length)
}

fn find_triple_other_hit(
    triples: &[Q29TripleMove],
    fixed: [u32; 7],
    records: &mut [Q29OtherDefectKey],
    record_count: usize,
) -> (Option<(u32, u16, u16)>, u64) {
    records[..record_count].sort_unstable();
    let mut probed = 0_u64;
    for (triple_index, triple) in triples.iter().enumerate() {
        probed += 1;
        let mut needed = [0_u16; 7];
        let mut feasible = true;
        for coordinate in 0..7 {
            let partial = fixed[coordinate] + triple.defects[coordinate];
            let Some(value) = 523_u32.checked_sub(partial) else {
                feasible = false;
                break;
            };
            needed[coordinate] = value as u16;
        }
        if !feasible {
            continue;
        }
        let start = records[..record_count].partition_point(|record| record.values < needed);
        if start < record_count && records[start].values == needed {
            return (
                Some((
                    triple_index as u32,
                    records[start].first,
                    records[start].second,
                )),
                probed,
            );
        }
    }
    (None, probed)
}

pub fn scout_g41_q29_seed_three_moves(
    seed: G41Q29Selection,
    triple_block_scope: u8,
) -> Result<G41Q29ThreeMoveScoutReport, G41Q29EvolveError> {
    if triple_block_scope >= 4 {
        return Err(G41Q29EvolveError::StateBudget);
    }
    let quotient = census_g41_joint_full_mitm()?;
    let root = quotient
        .witnesses
        .iter()
        .find(|witness| witness.root_id == seed.root_id)
        .ok_or(G41Q29EvolveError::SemanticMismatch)?;
    let witness = G41JointQuotientWitness {
        root_id: root.root_id,
        masks: root.masks,
        digits: seed.digits,
    };
    replay_witness(&witness)?;
    let inventory = compile_inventory()?;
    let mut selection = seed.orbit_masks;
    for block in 0..4 {
        let counts = digit_counts(witness.digits[block]);
        for slot in 0..SLOTS {
            let mask = selection[block * SLOTS + slot];
            if mask >> inventory.large_len[slot] != 0
                || mask.count_ones() != u32::from(counts[slot])
            {
                return Err(G41Q29EvolveError::SemanticMismatch);
            }
        }
    }
    let coefficients = compile_coefficients(&witness, &inventory, &selection);
    let block_defects: [ResidualTuple<u32, 7>; 4] =
        std::array::from_fn(|block| block_q29_defects(&coefficients[block]));
    let base_total = total_q29_defects(&block_defects);
    let initial_residual = q29_defect_residual(&base_total);
    let mut moves = [[Q29SingleMove::default(); MAX_Q29_SINGLE_MOVES]; 4];
    let mut lengths = [0_usize; 4];
    for block in 0..4 {
        for slot in 0..SLOTS {
            let index = block * SLOTS + slot;
            let mask = selection[index];
            for removed in 0..inventory.large_len[slot] {
                if mask & (1 << removed) == 0 {
                    continue;
                }
                for added in 0..inventory.large_len[slot] {
                    if mask & (1 << added) != 0 {
                        continue;
                    }
                    if lengths[block] == MAX_Q29_SINGLE_MOVES {
                        return Err(G41Q29EvolveError::StateBudget);
                    }
                    selection[index] = mask ^ (1 << removed) ^ (1 << added);
                    let next_coefficients =
                        compile_block_coefficients(&witness, &inventory, &selection, block);
                    moves[block][lengths[block]] = Q29SingleMove {
                        defects: block_q29_defects(&next_coefficients).0,
                        block: block as u8,
                        slot: slot as u8,
                        removed,
                        added,
                    };
                    lengths[block] += 1;
                }
            }
            selection[index] = mask;
        }
    }
    let mut doubles: [Box<[Q29DoubleMove]>; 4] = std::array::from_fn(|_| {
        vec![Q29DoubleMove::default(); MAX_Q29_DOUBLE_MOVES].into_boxed_slice()
    });
    let mut double_lengths = [0_usize; 4];
    for block in 0..4 {
        for first_index in 0..lengths[block] {
            let first = moves[block][first_index];
            for second_index in first_index + 1..lengths[block] {
                let second = moves[block][second_index];
                if first.slot == second.slot
                    && (first.removed == second.removed || first.added == second.added)
                {
                    continue;
                }
                if double_lengths[block] == MAX_Q29_DOUBLE_MOVES {
                    return Err(G41Q29EvolveError::StateBudget);
                }
                let first_mask_index = block * SLOTS + usize::from(first.slot);
                let second_mask_index = block * SLOTS + usize::from(second.slot);
                selection[first_mask_index] ^= (1 << first.removed) | (1 << first.added);
                selection[second_mask_index] ^= (1 << second.removed) | (1 << second.added);
                let next_coefficients =
                    compile_block_coefficients(&witness, &inventory, &selection, block);
                doubles[block][double_lengths[block]] = Q29DoubleMove {
                    defects: block_q29_defects(&next_coefficients).0,
                    swaps: [
                        Q29Swap {
                            slot: first.slot,
                            removed: first.removed,
                            added: first.added,
                            _pad: 0,
                        },
                        Q29Swap {
                            slot: second.slot,
                            removed: second.removed,
                            added: second.added,
                            _pad: 0,
                        },
                    ],
                    _pad: [0; 28],
                };
                double_lengths[block] += 1;
                selection[second_mask_index] ^= (1 << second.removed) | (1 << second.added);
                selection[first_mask_index] ^= (1 << first.removed) | (1 << first.added);
            }
        }
    }

    let mut best_residual = initial_residual;
    let mut best_choice = None;
    let mut triple_combinations = 0_u64;
    for omitted in 0..4 {
        let mut blocks = [0_usize; 3];
        let mut cursor = 0;
        for block in 0..4 {
            if block != omitted {
                blocks[cursor] = block;
                cursor += 1;
            }
        }
        let (residual, tested, indices) = scan_three_move_lists(
            &base_total,
            &block_defects,
            blocks,
            [
                &moves[blocks[0]][..lengths[blocks[0]]],
                &moves[blocks[1]][..lengths[blocks[1]]],
                &moves[blocks[2]][..lengths[blocks[2]]],
            ],
        );
        triple_combinations += tested;
        if residual < best_residual {
            best_residual = residual;
            best_choice = indices.map(|indices| (blocks, indices));
        }
        if best_residual == 0 {
            break;
        }
    }
    let mut pair_workspace = vec![Q29PairDefect::default(); MAX_Q29_MOVE_PAIRS].into_boxed_slice();
    let (four_move_hit, four_move_pair_records, four_move_pairs_probed) = find_four_move_hit(
        [
            &moves[0][..lengths[0]],
            &moves[1][..lengths[1]],
            &moves[2][..lengths[2]],
            &moves[3][..lengths[3]],
        ],
        &mut pair_workspace,
    );
    if four_move_pair_records == u32::MAX {
        return Err(G41Q29EvolveError::StateBudget);
    }
    if let Some(indices) = four_move_hit {
        best_residual = 0;
        best_choice = None;
        for block in 0..4 {
            let item = moves[block][usize::from(indices[block])];
            let index = block * SLOTS + usize::from(item.slot);
            selection[index] ^= (1 << item.removed) | (1 << item.added);
        }
    }
    let mut radius_2110_pair_records = 0_u64;
    let mut radius_2110_profiles_probed = 0_u64;
    let mut radius_2110_selection = None;
    if four_move_hit.is_none() {
        'radius: for double_block in 0..4 {
            for omitted in 0..4 {
                if omitted == double_block {
                    continue;
                }
                let mut single_blocks = [0_usize; 2];
                let mut cursor = 0;
                for block in 0..4 {
                    if block != double_block && block != omitted {
                        single_blocks[cursor] = block;
                        cursor += 1;
                    }
                }
                let (hit, records, probed) = find_double_two_single_hit(
                    &doubles[double_block][..double_lengths[double_block]],
                    &moves[single_blocks[0]][..lengths[single_blocks[0]]],
                    &moves[single_blocks[1]][..lengths[single_blocks[1]]],
                    &block_defects[omitted],
                    &mut pair_workspace,
                );
                if records == u32::MAX {
                    return Err(G41Q29EvolveError::StateBudget);
                }
                radius_2110_pair_records += u64::from(records);
                radius_2110_profiles_probed += probed;
                if let Some((double_index, first_index, second_index)) = hit {
                    let mut orbit_masks = seed.orbit_masks;
                    for swap in doubles[double_block][usize::from(double_index)].swaps {
                        let index = double_block * SLOTS + usize::from(swap.slot);
                        orbit_masks[index] ^= (1 << swap.removed) | (1 << swap.added);
                    }
                    for (block, move_index) in [
                        (single_blocks[0], first_index),
                        (single_blocks[1], second_index),
                    ] {
                        let item = moves[block][usize::from(move_index)];
                        let index = block * SLOTS + usize::from(item.slot);
                        orbit_masks[index] ^= (1 << item.removed) | (1 << item.added);
                    }
                    radius_2110_selection = Some(G41Q29Selection {
                        orbit_masks,
                        ..seed
                    });
                    best_residual = 0;
                    best_choice = None;
                    break 'radius;
                }
            }
        }
    }
    let mut radius_2200_records = 0_u64;
    let mut radius_2200_profiles_probed = 0_u64;
    let mut radius_2200_selection = None;
    if four_move_hit.is_none() && radius_2110_selection.is_none() {
        let mut double_workspace =
            vec![Q29DoubleDefectKey::default(); MAX_Q29_DOUBLE_MOVES].into_boxed_slice();
        'pairs: for first_block in 0..4 {
            for second_block in first_block + 1..4 {
                let mut fixed_blocks = [0_usize; 2];
                let mut cursor = 0;
                for block in 0..4 {
                    if block != first_block && block != second_block {
                        fixed_blocks[cursor] = block;
                        cursor += 1;
                    }
                }
                let (hit, records, probed) = find_two_double_hit(
                    &doubles[first_block][..double_lengths[first_block]],
                    &doubles[second_block][..double_lengths[second_block]],
                    [
                        &block_defects[fixed_blocks[0]],
                        &block_defects[fixed_blocks[1]],
                    ],
                    &mut double_workspace,
                );
                if records == u32::MAX {
                    return Err(G41Q29EvolveError::StateBudget);
                }
                radius_2200_records += u64::from(records);
                radius_2200_profiles_probed += probed;
                if let Some((first_index, second_index)) = hit {
                    let mut orbit_masks = seed.orbit_masks;
                    for (block, double_index) in
                        [(first_block, first_index), (second_block, second_index)]
                    {
                        for swap in doubles[block][usize::from(double_index)].swaps {
                            let index = block * SLOTS + usize::from(swap.slot);
                            orbit_masks[index] ^= (1 << swap.removed) | (1 << swap.added);
                        }
                    }
                    radius_2200_selection = Some(G41Q29Selection {
                        orbit_masks,
                        ..seed
                    });
                    best_residual = 0;
                    best_choice = None;
                    break 'pairs;
                }
            }
        }
    }
    let mut radius_2111_pair_records = 0_u64;
    let mut radius_2111_profiles_probed = 0_u64;
    let mut radius_2111_selection = None;
    if four_move_hit.is_none() && radius_2110_selection.is_none() && radius_2200_selection.is_none()
    {
        'radius_2111: for double_block in 0..4 {
            let mut single_blocks = [0_usize; 3];
            let mut cursor = 0;
            for block in 0..4 {
                if block != double_block {
                    single_blocks[cursor] = block;
                    cursor += 1;
                }
            }
            let (hit, records, probed) = find_double_single_two_single_hit(
                &doubles[double_block][..double_lengths[double_block]],
                &moves[single_blocks[0]][..lengths[single_blocks[0]]],
                &moves[single_blocks[1]][..lengths[single_blocks[1]]],
                &moves[single_blocks[2]][..lengths[single_blocks[2]]],
                &mut pair_workspace,
            );
            if records == u32::MAX {
                return Err(G41Q29EvolveError::StateBudget);
            }
            radius_2111_pair_records += u64::from(records);
            radius_2111_profiles_probed += probed;
            if let Some((double_index, remaining_index, first_index, second_index)) = hit {
                let mut orbit_masks = seed.orbit_masks;
                for swap in doubles[double_block][usize::from(double_index)].swaps {
                    let index = double_block * SLOTS + usize::from(swap.slot);
                    orbit_masks[index] ^= (1 << swap.removed) | (1 << swap.added);
                }
                for (block, move_index) in [
                    (single_blocks[0], remaining_index),
                    (single_blocks[1], first_index),
                    (single_blocks[2], second_index),
                ] {
                    let item = moves[block][usize::from(move_index)];
                    let index = block * SLOTS + usize::from(item.slot);
                    orbit_masks[index] ^= (1 << item.removed) | (1 << item.added);
                }
                radius_2111_selection = Some(G41Q29Selection {
                    orbit_masks,
                    ..seed
                });
                best_residual = 0;
                best_choice = None;
                break 'radius_2111;
            }
        }
    }
    let mut radius_2210_records = 0_u64;
    let mut radius_2210_profiles_probed = 0_u64;
    let mut radius_2210_selection = None;
    if four_move_hit.is_none()
        && radius_2110_selection.is_none()
        && radius_2200_selection.is_none()
        && radius_2111_selection.is_none()
    {
        let mut double_workspace =
            vec![Q29DoubleDefectKey::default(); MAX_Q29_DOUBLE_MOVES].into_boxed_slice();
        'radius_2210: for omitted in 0..4 {
            for single_block in 0..4 {
                if single_block == omitted {
                    continue;
                }
                let mut double_blocks = [0_usize; 2];
                let mut cursor = 0;
                for block in 0..4 {
                    if block != omitted && block != single_block {
                        double_blocks[cursor] = block;
                        cursor += 1;
                    }
                }
                let (hit, records, probed) = find_two_double_single_hit(
                    &doubles[double_blocks[0]][..double_lengths[double_blocks[0]]],
                    &doubles[double_blocks[1]][..double_lengths[double_blocks[1]]],
                    &moves[single_block][..lengths[single_block]],
                    &block_defects[omitted],
                    &mut double_workspace,
                );
                if records == u32::MAX {
                    return Err(G41Q29EvolveError::StateBudget);
                }
                radius_2210_records += u64::from(records);
                radius_2210_profiles_probed += probed;
                if let Some((first_index, second_index, single_index)) = hit {
                    let mut orbit_masks = seed.orbit_masks;
                    for (block, double_index) in [
                        (double_blocks[0], first_index),
                        (double_blocks[1], second_index),
                    ] {
                        for swap in doubles[block][usize::from(double_index)].swaps {
                            let index = block * SLOTS + usize::from(swap.slot);
                            orbit_masks[index] ^= (1 << swap.removed) | (1 << swap.added);
                        }
                    }
                    let item = moves[single_block][usize::from(single_index)];
                    let index = single_block * SLOTS + usize::from(item.slot);
                    orbit_masks[index] ^= (1 << item.removed) | (1 << item.added);
                    radius_2210_selection = Some(G41Q29Selection {
                        orbit_masks,
                        ..seed
                    });
                    best_residual = 0;
                    best_choice = None;
                    break 'radius_2210;
                }
            }
        }
    }
    let triple_block = usize::from(triple_block_scope);
    let mut triple_workspace =
        vec![Q29TripleMove::default(); MAX_Q29_TRIPLE_MOVES].into_boxed_slice();
    let triple_length = if best_residual == 0 {
        0
    } else {
        compile_triple_moves(
            &witness,
            &inventory,
            &mut selection,
            triple_block,
            &moves[triple_block][..lengths[triple_block]],
            &mut triple_workspace,
        )?
    };
    let triples = &triple_workspace[..triple_length];
    let mut other_workspace =
        vec![Q29OtherDefectKey::default(); MAX_Q29_MOVE_PAIRS].into_boxed_slice();
    let mut radius_3100_records = 0_u64;
    let mut radius_3100_profiles_probed = 0_u64;
    let mut radius_3100_selection = None;
    if best_residual != 0 {
        'radius_3100: for single_block in 0..4 {
            if single_block == triple_block {
                continue;
            }
            let mut fixed = [0_u32; 7];
            for block in 0..4 {
                if block != triple_block && block != single_block {
                    for coordinate in 0..7 {
                        fixed[coordinate] += block_defects[block].0[coordinate];
                    }
                }
            }
            let mut records = 0_usize;
            for (index, item) in moves[single_block][..lengths[single_block]]
                .iter()
                .enumerate()
            {
                if (0..7).any(|coordinate| fixed[coordinate] + item.defects[coordinate] > 523) {
                    continue;
                }
                other_workspace[records] = Q29OtherDefectKey {
                    values: item.defects.map(|value| value as u16),
                    first: index as u16,
                    second: u16::MAX,
                    _pad: [0; 14],
                };
                records += 1;
            }
            radius_3100_records += records as u64;
            let (hit, probed) =
                find_triple_other_hit(triples, fixed, &mut other_workspace, records);
            radius_3100_profiles_probed += probed;
            if let Some((triple_index, single_index, _)) = hit {
                let mut orbit_masks = seed.orbit_masks;
                for swap in triples[triple_index as usize].swaps {
                    let index = triple_block * SLOTS + usize::from(swap.slot);
                    orbit_masks[index] ^= (1 << swap.removed) | (1 << swap.added);
                }
                let item = moves[single_block][usize::from(single_index)];
                let index = single_block * SLOTS + usize::from(item.slot);
                orbit_masks[index] ^= (1 << item.removed) | (1 << item.added);
                radius_3100_selection = Some(G41Q29Selection {
                    orbit_masks,
                    ..seed
                });
                best_residual = 0;
                best_choice = None;
                break 'radius_3100;
            }
        }
    }
    let mut radius_3110_records = 0_u64;
    let mut radius_3110_profiles_probed = 0_u64;
    let mut radius_3110_selection = None;
    if best_residual != 0 {
        'radius_3110: for omitted in 0..4 {
            if omitted == triple_block {
                continue;
            }
            let mut single_blocks = [0_usize; 2];
            let mut cursor = 0;
            for block in 0..4 {
                if block != triple_block && block != omitted {
                    single_blocks[cursor] = block;
                    cursor += 1;
                }
            }
            let mut records = 0_usize;
            for (first_index, first) in moves[single_blocks[0]][..lengths[single_blocks[0]]]
                .iter()
                .enumerate()
            {
                for (second_index, second) in moves[single_blocks[1]][..lengths[single_blocks[1]]]
                    .iter()
                    .enumerate()
                {
                    let mut values = [0_u16; 7];
                    let mut feasible = true;
                    for coordinate in 0..7 {
                        let sum = first.defects[coordinate] + second.defects[coordinate];
                        if block_defects[omitted].0[coordinate] + sum > 523 {
                            feasible = false;
                            break;
                        }
                        values[coordinate] = sum as u16;
                    }
                    if feasible {
                        other_workspace[records] = Q29OtherDefectKey {
                            values,
                            first: first_index as u16,
                            second: second_index as u16,
                            _pad: [0; 14],
                        };
                        records += 1;
                    }
                }
            }
            radius_3110_records += records as u64;
            let (hit, probed) = find_triple_other_hit(
                triples,
                block_defects[omitted].0,
                &mut other_workspace,
                records,
            );
            radius_3110_profiles_probed += probed;
            if let Some((triple_index, first_index, second_index)) = hit {
                let mut orbit_masks = seed.orbit_masks;
                for swap in triples[triple_index as usize].swaps {
                    let index = triple_block * SLOTS + usize::from(swap.slot);
                    orbit_masks[index] ^= (1 << swap.removed) | (1 << swap.added);
                }
                for (block, move_index) in [
                    (single_blocks[0], first_index),
                    (single_blocks[1], second_index),
                ] {
                    let item = moves[block][usize::from(move_index)];
                    let index = block * SLOTS + usize::from(item.slot);
                    orbit_masks[index] ^= (1 << item.removed) | (1 << item.added);
                }
                radius_3110_selection = Some(G41Q29Selection {
                    orbit_masks,
                    ..seed
                });
                best_residual = 0;
                best_choice = None;
                break 'radius_3110;
            }
        }
    }
    let mut radius_3200_records = 0_u64;
    let mut radius_3200_profiles_probed = 0_u64;
    let mut radius_3200_selection = None;
    if best_residual != 0 {
        'radius_3200: for double_block in 0..4 {
            if double_block == triple_block {
                continue;
            }
            let mut fixed = [0_u32; 7];
            for block in 0..4 {
                if block != triple_block && block != double_block {
                    for coordinate in 0..7 {
                        fixed[coordinate] += block_defects[block].0[coordinate];
                    }
                }
            }
            let mut records = 0_usize;
            for (index, item) in doubles[double_block][..double_lengths[double_block]]
                .iter()
                .enumerate()
            {
                if (0..7).any(|coordinate| fixed[coordinate] + item.defects[coordinate] > 523) {
                    continue;
                }
                other_workspace[records] = Q29OtherDefectKey {
                    values: item.defects.map(|value| value as u16),
                    first: index as u16,
                    second: u16::MAX,
                    _pad: [0; 14],
                };
                records += 1;
            }
            radius_3200_records += records as u64;
            let (hit, probed) =
                find_triple_other_hit(triples, fixed, &mut other_workspace, records);
            radius_3200_profiles_probed += probed;
            if let Some((triple_index, double_index, _)) = hit {
                let mut orbit_masks = seed.orbit_masks;
                for swap in triples[triple_index as usize].swaps {
                    let index = triple_block * SLOTS + usize::from(swap.slot);
                    orbit_masks[index] ^= (1 << swap.removed) | (1 << swap.added);
                }
                for swap in doubles[double_block][usize::from(double_index)].swaps {
                    let index = double_block * SLOTS + usize::from(swap.slot);
                    orbit_masks[index] ^= (1 << swap.removed) | (1 << swap.added);
                }
                radius_3200_selection = Some(G41Q29Selection {
                    orbit_masks,
                    ..seed
                });
                best_residual = 0;
                best_choice = None;
                break 'radius_3200;
            }
        }
    }
    let best_selection = best_choice.map(|(blocks, indices)| {
        let mut orbit_masks = seed.orbit_masks;
        for move_index in 0..3 {
            let item = moves[blocks[move_index]][usize::from(indices[move_index])];
            let index = usize::from(item.block) * SLOTS + usize::from(item.slot);
            orbit_masks[index] ^= (1 << item.removed) | (1 << item.added);
        }
        G41Q29Selection {
            orbit_masks,
            ..seed
        }
    });
    let best_selection = if let Some(candidate) = radius_3200_selection {
        Some(candidate)
    } else if let Some(candidate) = radius_3110_selection {
        Some(candidate)
    } else if let Some(candidate) = radius_3100_selection {
        Some(candidate)
    } else if let Some(candidate) = radius_2210_selection {
        Some(candidate)
    } else if let Some(candidate) = radius_2111_selection {
        Some(candidate)
    } else if let Some(candidate) = radius_2200_selection {
        Some(candidate)
    } else if let Some(candidate) = radius_2110_selection {
        Some(candidate)
    } else if four_move_hit.is_some() {
        Some(G41Q29Selection {
            orbit_masks: selection,
            ..seed
        })
    } else {
        best_selection
    };
    let (q29_hit, full_paf_hit) = if let Some(candidate) = best_selection {
        let replayed = compile_coefficients(&witness, &inventory, &candidate.orbit_masks);
        let (_, correlation) = correlations(&replayed);
        if q29_residual(&correlation) != best_residual {
            return Err(G41Q29EvolveError::SemanticMismatch);
        }
        (
            best_residual == 0,
            best_residual == 0 && direct_full_replay(&witness, &inventory, &candidate.orbit_masks),
        )
    } else {
        (false, false)
    };
    Ok(G41Q29ThreeMoveScoutReport {
        root_id: seed.root_id,
        initial_residual,
        single_moves: lengths.map(|length| length as u16),
        triple_combinations,
        four_move_pair_records,
        four_move_pairs_probed,
        exact_two_swap_moves: double_lengths.map(|length| length as u32),
        radius_2110_pair_records,
        radius_2110_profiles_probed,
        radius_2110_hit: radius_2110_selection.is_some(),
        radius_2200_records,
        radius_2200_profiles_probed,
        radius_2200_hit: radius_2200_selection.is_some(),
        radius_2111_pair_records,
        radius_2111_profiles_probed,
        radius_2111_hit: radius_2111_selection.is_some(),
        radius_2210_records,
        radius_2210_profiles_probed,
        radius_2210_hit: radius_2210_selection.is_some(),
        triple_block_scope,
        recomputed_three_swap_candidates: triple_length as u32,
        radius_3100_records,
        radius_3100_profiles_probed,
        radius_3100_hit: radius_3100_selection.is_some(),
        radius_3110_records,
        radius_3110_profiles_probed,
        radius_3110_hit: radius_3110_selection.is_some(),
        radius_3200_records,
        radius_3200_profiles_probed,
        radius_3200_hit: radius_3200_selection.is_some(),
        best_residual,
        q29_hit,
        full_paf_hit,
        selection: best_selection,
        provenance: "discovery-only exact three-distinct-block single-swap neighbourhood around an independently replayed seed; block defects are recomputed after every proposed swap, so no same-block additive delta assumption is used; positives replay q29 and every original PAF equation, while misses have only local-neighbourhood meaning",
    })
}

fn evolve_seeded_batch_const<const BATCH: usize>(
    witness: &G41JointQuotientWitness,
    inventory: &FineInventory,
    seed: G41Q29Selection,
    restarts: u16,
    mutations: u32,
) -> Result<G41Q29BatchedEvolveReport, G41Q29EvolveError> {
    let mut random = 0xa076_1d64_78bd_642f_u64 ^ u64::from(seed.root_id) ^ BATCH as u64;
    let mut best = u64::MAX;
    let mut best_selection = seed.orbit_masks;
    let mut initial_residual = 0_u64;
    let mut evaluated = 0_u64;
    let mut accepted_mutations = 0_u64;
    let mut uphill_accepted_mutations = 0_u64;
    let mut q29_hit = false;
    let mut full_paf_hit = false;
    'search: for restart in 0..restarts {
        let mut selection = if restart == 0 {
            seed.orbit_masks
        } else {
            initialize_selection(witness, inventory, &mut random)
        };
        let mut coefficients = compile_coefficients(witness, inventory, &selection);
        let mut block_defects: [ResidualTuple<u32, 7>; 4] =
            std::array::from_fn(|block| block_q29_defects(&coefficients[block]));
        let mut defects = total_q29_defects(&block_defects);
        let residual = q29_defect_residual(&defects);
        if restart == 0 {
            initial_residual = residual;
        }
        let mut score = residual;
        if residual < best {
            best = residual;
            best_selection = selection;
        }
        for _ in 0..mutations {
            let old_selection = selection;
            let old_coefficients = coefficients;
            let old_block_defects = block_defects;
            let old_defects = defects;
            let mut affected = 0_u8;
            for _ in 0..BATCH {
                let block = next_random(&mut random) as usize % 4;
                let mut slot = next_random(&mut random) as usize % SLOTS;
                for _ in 0..SLOTS {
                    let mask = selection[block * SLOTS + slot];
                    let count = mask.count_ones();
                    if count != 0 && count != u32::from(inventory.large_len[slot]) {
                        break;
                    }
                    slot = (slot + 1) % SLOTS;
                }
                let index = block * SLOTS + slot;
                let mask = selection[index];
                if mask == 0 || mask.count_ones() == u32::from(inventory.large_len[slot]) {
                    continue;
                }
                let mut removed = next_random(&mut random) as u8 % inventory.large_len[slot];
                while mask & (1 << removed) == 0 {
                    removed = (removed + 1) % inventory.large_len[slot];
                }
                let mut added = next_random(&mut random) as u8 % inventory.large_len[slot];
                while mask & (1 << added) != 0 {
                    added = (added + 1) % inventory.large_len[slot];
                }
                selection[index] ^= (1 << removed) | (1 << added);
                affected |= 1 << block;
            }
            defects = old_defects;
            for block in 0..4 {
                if affected & (1 << block) == 0 {
                    continue;
                }
                coefficients[block] =
                    compile_block_coefficients(witness, inventory, &selection, block);
                block_defects[block] = block_q29_defects(&coefficients[block]);
                for coordinate in 0..7 {
                    defects.0[coordinate] = defects.0[coordinate]
                        - old_block_defects[block].0[coordinate]
                        + block_defects[block].0[coordinate];
                }
            }
            let next_residual = q29_defect_residual(&defects);
            evaluated += 1;
            let accept = next_residual <= score
                || (next_residual <= score.saturating_add(128 * BATCH as u64)
                    && next_random(&mut random) & 15 == 0);
            if accept {
                accepted_mutations += 1;
                uphill_accepted_mutations += u64::from(next_residual > score);
                score = next_residual;
                if next_residual < best {
                    best = next_residual;
                    best_selection = selection;
                }
            } else {
                selection = old_selection;
                coefficients = old_coefficients;
                block_defects = old_block_defects;
                defects = old_defects;
            }
            if score == 0 {
                let (_, correlation) = correlations(&coefficients);
                if q29_residual(&correlation) != 0 {
                    return Err(G41Q29EvolveError::SemanticMismatch);
                }
                q29_hit = true;
                full_paf_hit = direct_full_replay(witness, inventory, &selection);
                best_selection = selection;
                break 'search;
            }
        }
    }
    let replayed = compile_coefficients(witness, inventory, &best_selection);
    let (_, correlation) = correlations(&replayed);
    if q29_residual(&correlation) != best {
        return Err(G41Q29EvolveError::SemanticMismatch);
    }
    Ok(G41Q29BatchedEvolveReport {
        root_id: seed.root_id,
        batch_swaps: BATCH as u8,
        restarts,
        mutations_per_restart: mutations,
        mutations: evaluated,
        accepted_mutations,
        uphill_accepted_mutations,
        initial_residual,
        best_residual: best,
        q29_hit,
        full_paf_hit,
        best_selection: G41Q29Selection {
            orbit_masks: best_selection,
            ..seed
        },
        provenance: "discovery-only const-generic batched fine-orbit evolution; every batch mutates live masks sequentially and then recomputes each affected block exactly, including repeated same-block moves; positives directly replay q29 and all original PAF equations, while misses have no authority",
    })
}

pub fn evolve_g41_q29_seeded_batched(
    seed: G41Q29Selection,
    restarts: u16,
    mutations: u32,
    batch_swaps: u8,
) -> Result<G41Q29BatchedEvolveReport, G41Q29EvolveError> {
    if restarts == 0 || mutations == 0 {
        return Err(G41Q29EvolveError::StateBudget);
    }
    let quotient = census_g41_joint_full_mitm()?;
    let root = quotient
        .witnesses
        .iter()
        .find(|witness| witness.root_id == seed.root_id)
        .ok_or(G41Q29EvolveError::SemanticMismatch)?;
    let witness = G41JointQuotientWitness {
        root_id: root.root_id,
        masks: root.masks,
        digits: seed.digits,
    };
    replay_witness(&witness)?;
    let inventory = compile_inventory()?;
    for block in 0..4 {
        let counts = digit_counts(witness.digits[block]);
        for slot in 0..SLOTS {
            let mask = seed.orbit_masks[block * SLOTS + slot];
            if mask >> inventory.large_len[slot] != 0
                || mask.count_ones() != u32::from(counts[slot])
            {
                return Err(G41Q29EvolveError::SemanticMismatch);
            }
        }
    }
    match batch_swaps {
        2 => evolve_seeded_batch_const::<2>(&witness, &inventory, seed, restarts, mutations),
        3 => evolve_seeded_batch_const::<3>(&witness, &inventory, seed, restarts, mutations),
        4 => evolve_seeded_batch_const::<4>(&witness, &inventory, seed, restarts, mutations),
        6 => evolve_seeded_batch_const::<6>(&witness, &inventory, seed, restarts, mutations),
        8 => evolve_seeded_batch_const::<8>(&witness, &inventory, seed, restarts, mutations),
        _ => Err(G41Q29EvolveError::StateBudget),
    }
}

#[inline(always)]
fn total_q29_defects(blocks: &[ResidualTuple<u32, 7>; 4]) -> ResidualTuple<u32, 7> {
    ResidualTuple(std::array::from_fn(|class| {
        blocks.iter().map(|block| block.0[class]).sum()
    }))
}

#[inline(always)]
fn q29_defect_residual(defects: &ResidualTuple<u32, 7>) -> u64 {
    defects
        .0
        .iter()
        .map(|&defect| 4 * u64::from(defect.abs_diff(523)))
        .sum()
}

#[inline(always)]
fn q29_guided_defect_score<const BALANCE_WEIGHT: u8>(
    defects: &ResidualTuple<u32, 7>,
    residual: u64,
) -> u64 {
    let signed_sum = defects
        .0
        .iter()
        .map(|&defect| 523_i64 - i64::from(defect))
        .sum::<i64>();
    residual + u64::from(BALANCE_WEIGHT) * 4 * signed_sum.unsigned_abs()
}

#[cfg(test)]
fn q29_residual_direct(correlation: &[u32; 29]) -> u64 {
    let target = i64::from(correlation[0]) - 523;
    correlation[1..]
        .iter()
        .map(|&value| (i64::from(value) - target).unsigned_abs())
        .sum()
}

fn mine_q29_residual_motif(
    correlation: &[u32; 29],
) -> Result<G41Q29ResidualMotif, G41Q29EvolveError> {
    let target = i32::try_from(correlation[0])
        .map_err(|_| G41Q29EvolveError::SemanticMismatch)?
        .checked_sub(523)
        .ok_or(G41Q29EvolveError::SemanticMismatch)?;
    let mut residual = [0_i32; 29];
    for coordinate in 1..29 {
        residual[coordinate] = i32::try_from(correlation[coordinate])
            .map_err(|_| G41Q29EvolveError::SemanticMismatch)?
            - target;
    }
    let mut actions = [CyclicInvariantAction::default(); MAX_CYCLIC_MODULUS];
    let used = mine_cyclic_invariant_actions_into(&residual, 29, &mut actions)
        .map_err(|_| G41Q29EvolveError::SemanticMismatch)?;
    let action = actions[..used]
        .iter()
        .copied()
        .min_by_key(|action| (action.orbit_count, action.multiplier))
        .ok_or(G41Q29EvolveError::SemanticMismatch)?;
    let motif = extract_cyclic_residual_motif(&residual, 29, action)
        .map_err(|_| G41Q29EvolveError::SemanticMismatch)?;
    if motif.signed_sum != q29_residual_sum(correlation[0]) {
        return Err(G41Q29EvolveError::SemanticMismatch);
    }
    Ok(G41Q29ResidualMotif {
        multiplier: action.multiplier,
        support_mask: motif.support_mask,
        positive_mask: motif.positive_mask,
        negative_mask: motif.negative_mask,
        l1: motif.l1,
        l2: motif.l2,
        signed_sum: motif.signed_sum,
        best_residual: q29_residual(correlation),
        roots: 1,
    })
}

fn same_residual_motif(left: G41Q29ResidualMotif, right: G41Q29ResidualMotif) -> bool {
    left.multiplier == right.multiplier
        && left.support_mask == right.support_mask
        && left.positive_mask == right.positive_mask
        && left.negative_mask == right.negative_mask
        && left.l1 == right.l1
        && left.l2 == right.l2
        && left.signed_sum == right.signed_sum
}

fn merge_residual_motif(
    report: &mut G41Q29EvolveReport,
    motif: G41Q29ResidualMotif,
) -> Result<(), G41Q29EvolveError> {
    let used = usize::from(report.residual_motif_count);
    if let Some(existing) = report.residual_motifs[..used]
        .iter_mut()
        .find(|existing| same_residual_motif(**existing, motif))
    {
        existing.roots = existing
            .roots
            .checked_add(motif.roots)
            .ok_or(G41Q29EvolveError::StateBudget)?;
        existing.best_residual = existing.best_residual.min(motif.best_residual);
        return Ok(());
    }
    if used < report.residual_motifs.len() {
        report.residual_motifs[used] = motif;
        report.residual_motif_count += 1;
        return Ok(());
    }
    let worst = report.residual_motifs[..used]
        .iter()
        .enumerate()
        .max_by_key(|(_, candidate)| candidate.best_residual)
        .map(|(index, _)| index)
        .ok_or(G41Q29EvolveError::SemanticMismatch)?;
    if motif.best_residual < report.residual_motifs[worst].best_residual {
        report.residual_motif_overflow_roots = report
            .residual_motif_overflow_roots
            .checked_add(report.residual_motifs[worst].roots)
            .ok_or(G41Q29EvolveError::StateBudget)?;
        report.residual_motifs[worst] = motif;
    } else {
        report.residual_motif_overflow_roots = report
            .residual_motif_overflow_roots
            .checked_add(motif.roots)
            .ok_or(G41Q29EvolveError::StateBudget)?;
    }
    Ok(())
}

fn singleton_residual_motifs(
    correlation: &[u32; 29],
) -> Result<([G41Q29ResidualMotif; 16], u8), G41Q29EvolveError> {
    let mut motifs = [G41Q29ResidualMotif::default(); 16];
    motifs[0] = mine_q29_residual_motif(correlation)?;
    Ok((motifs, 1))
}

fn singleton_residual_scope(ordinal: RootOrdinal, nonzero: bool) -> [u64; 12] {
    let mut scope = [0_u64; 12];
    let ordinal = ordinal.0 as usize;
    if nonzero && ordinal < 768 {
        scope[ordinal / 64] = 1_u64 << (ordinal % 64);
    }
    scope
}

fn capture_scoped_residual<const ROOT_SCOPE: bool>(
    correlation: &[u32; 29],
    ordinal: RootOrdinal,
) -> Result<([G41Q29ResidualMotif; 16], u8, u32, [u64; 12]), G41Q29EvolveError> {
    if ROOT_SCOPE {
        let (motifs, count) = singleton_residual_motifs(correlation)?;
        let nonzero = motifs[0].signed_sum != 0;
        Ok((
            motifs,
            count,
            u32::from(nonzero),
            singleton_residual_scope(ordinal, nonzero),
        ))
    } else {
        Ok(([G41Q29ResidualMotif::default(); 16], 0, 0, [0; 12]))
    }
}

fn orbit_coefficient_state_mod2(orbit: &FineOrbit) -> Result<u8, G41Q29EvolveError> {
    let mut state = orbit.residue_histogram[0] & 1;
    for (class, coset) in Q29_COSETS.iter().enumerate() {
        let parity = orbit.residue_histogram[coset[0]] & 1;
        if coset
            .iter()
            .any(|&residue| orbit.residue_histogram[residue] & 1 != parity)
        {
            return Err(G41Q29EvolveError::SemanticMismatch);
        }
        state |= parity << (class + 1);
    }
    Ok(state)
}

fn orbit_nonzero_class_parity(orbit: &FineOrbit) -> Result<u8, G41Q29EvolveError> {
    Ok(((orbit_coefficient_state_mod2(orbit)? >> 1).count_ones() & 1) as u8)
}

fn witness_nonzero_class_parity(
    witness: &G41JointQuotientWitness,
    inventory: &FineInventory,
) -> Result<u8, G41Q29EvolveError> {
    let mut large_parity = [0_u8; SLOTS];
    for (slot, parity) in large_parity.iter_mut().enumerate() {
        *parity = orbit_nonzero_class_parity(&inventory.large[slot][0])?;
        for orbit in 1..inventory.large_len[slot] {
            if orbit_nonzero_class_parity(&inventory.large[slot][usize::from(orbit)])? != *parity {
                return Err(G41Q29EvolveError::SemanticMismatch);
            }
        }
    }

    let mut parity = 0_u8;
    for block in 0..4 {
        let counts = digit_counts(witness.digits[block]);
        for slot in 0..SLOTS {
            if witness.masks[block] & (1 << slot) != 0 {
                parity ^= orbit_nonzero_class_parity(&inventory.small[slot])?;
            }
            parity ^= (counts[slot] & 1) & large_parity[slot];
        }
    }
    Ok(parity)
}

fn set_bit(bits: &mut [u64; 4], state: u8) {
    bits[usize::from(state) / 64] |= 1_u64 << (state % 64);
}

fn has_bit(bits: &[u64; 4], state: u8) -> bool {
    bits[usize::from(state) / 64] & (1_u64 << (state % 64)) != 0
}

fn block_coefficient_states_mod2(
    witness: &G41JointQuotientWitness,
    inventory: &FineInventory,
    block: usize,
) -> Result<[u64; 4], G41Q29EvolveError> {
    let counts = digit_counts(witness.digits[block]);
    let mut initial = 0_u8;
    for slot in 0..SLOTS {
        if witness.masks[block] & (1 << slot) != 0 {
            initial ^= orbit_coefficient_state_mod2(&inventory.small[slot])?;
        }
    }
    let mut reachable = [0_u64; 4];
    set_bit(&mut reachable, initial);
    for slot in 0..SLOTS {
        let len = inventory.large_len[slot];
        let mut contributions = [false; 256];
        for selection in 0_u16..1_u16 << len {
            if selection.count_ones() != u32::from(counts[slot]) {
                continue;
            }
            let mut state = 0_u8;
            for orbit in 0..len {
                if selection & (1 << orbit) != 0 {
                    state ^=
                        orbit_coefficient_state_mod2(&inventory.large[slot][usize::from(orbit)])?;
                }
            }
            contributions[usize::from(state)] = true;
        }
        let mut next = [0_u64; 4];
        for state in 0_u8..=u8::MAX {
            if !has_bit(&reachable, state) {
                continue;
            }
            for contribution in 0_u8..=u8::MAX {
                if contributions[usize::from(contribution)] {
                    set_bit(&mut next, state ^ contribution);
                }
            }
        }
        reachable = next;
    }
    Ok(reachable)
}

fn correlation_state_mod2(coefficient_state: u8) -> u8 {
    let mut coefficients = [0_u8; 29];
    coefficients[0] = coefficient_state & 1;
    for (class, coset) in Q29_COSETS.iter().enumerate() {
        for &residue in coset {
            coefficients[residue] = (coefficient_state >> (class + 1)) & 1;
        }
    }
    let mut state = 0_u8;
    for (coordinate, shift) in std::iter::once(0)
        .chain(Q29_COSETS.iter().map(|coset| coset[0]))
        .enumerate()
    {
        let value = (0..29).fold(0_u8, |parity, residue| {
            parity ^ (coefficients[residue] & coefficients[(residue + shift) % 29])
        });
        state |= value << coordinate;
    }
    state
}

fn block_correlation_states_mod2(
    witness: &G41JointQuotientWitness,
    inventory: &FineInventory,
    block: usize,
) -> Result<[u64; 4], G41Q29EvolveError> {
    let coefficients = block_coefficient_states_mod2(witness, inventory, block)?;
    let mut correlations = [0_u64; 4];
    for state in 0_u8..=u8::MAX {
        if has_bit(&coefficients, state) {
            set_bit(&mut correlations, correlation_state_mod2(state));
        }
    }
    Ok(correlations)
}

fn seed_witness_mod2_feasible(
    witness: &G41JointQuotientWitness,
    inventory: &FineInventory,
) -> Result<bool, G41Q29EvolveError> {
    let mut profiles = [[0_u64; 4]; 4];
    for (block, profile) in profiles.iter_mut().enumerate() {
        *profile = block_correlation_states_mod2(witness, inventory, block)?;
    }
    let mut left = [0_u64; 4];
    let mut right = [0_u64; 4];
    for first in 0_u8..=u8::MAX {
        if !has_bit(&profiles[0], first) {
            continue;
        }
        for second in 0_u8..=u8::MAX {
            if has_bit(&profiles[1], second) {
                set_bit(&mut left, first ^ second);
            }
        }
    }
    for third in 0_u8..=u8::MAX {
        if !has_bit(&profiles[2], third) {
            continue;
        }
        for fourth in 0_u8..=u8::MAX {
            if has_bit(&profiles[3], fourth) {
                set_bit(&mut right, third ^ fourth);
            }
        }
    }
    const TARGET: u8 = 1;
    Ok((0_u8..=u8::MAX).any(|state| has_bit(&left, state) && has_bit(&right, state ^ TARGET)))
}

fn orbit_coefficient_state_mod4(orbit: &FineOrbit) -> Result<u16, G41Q29EvolveError> {
    let mut state = u16::from(orbit.residue_histogram[0] & 3);
    for (class, coset) in Q29_COSETS.iter().enumerate() {
        let value = orbit.residue_histogram[coset[0]] & 3;
        if coset
            .iter()
            .any(|&index| orbit.residue_histogram[index] & 3 != value)
        {
            return Err(G41Q29EvolveError::SemanticMismatch);
        }
        state |= u16::from(value) << (2 * (class + 1));
    }
    Ok(state)
}

fn add_states_mod4(left: u16, right: u16) -> u16 {
    let mut output = 0_u16;
    for coordinate in 0..8 {
        let shift = 2 * coordinate;
        output |= (((left >> shift) + (right >> shift)) & 3) << shift;
    }
    output
}

fn correlation_state_mod4(coefficient_state: u16) -> u16 {
    let mut coefficients = [0_u8; 29];
    coefficients[0] = (coefficient_state & 3) as u8;
    for (class, coset) in Q29_COSETS.iter().enumerate() {
        let value = ((coefficient_state >> (2 * (class + 1))) & 3) as u8;
        for &residue in coset {
            coefficients[residue] = value;
        }
    }
    let mut output = 0_u16;
    for (coordinate, shift) in std::iter::once(0)
        .chain(Q29_COSETS.iter().map(|coset| coset[0]))
        .enumerate()
    {
        let value = (0..29).fold(0_u16, |sum, residue| {
            sum + u16::from(coefficients[residue]) * u16::from(coefficients[(residue + shift) % 29])
        }) & 3;
        output |= value << (2 * coordinate);
    }
    output
}

fn complement_state_mod4(value: u16) -> u16 {
    const TARGET: u16 = 3;
    let mut output = 0_u16;
    for coordinate in 0..8 {
        let shift = 2 * coordinate;
        let target = (TARGET >> shift) & 3;
        let digit = (value >> shift) & 3;
        output |= ((target + 4 - digit) & 3) << shift;
    }
    output
}

fn compile_block_mod4_profiles(
    witness: &G41JointQuotientWitness,
    inventory: &FineInventory,
    block: usize,
) -> Result<Vec<Mod4Choice>, G41Q29EvolveError> {
    const STATES: usize = 1 << 16;
    let counts = digit_counts(witness.digits[block]);
    let mut initial = 0_u16;
    for slot in 0..SLOTS {
        if witness.masks[block] & (1 << slot) != 0 {
            initial = add_states_mod4(
                initial,
                orbit_coefficient_state_mod4(&inventory.small[slot])?,
            );
        }
    }
    let mut current = Vec::with_capacity(STATES);
    let mut next = Vec::with_capacity(STATES);
    let mut contributions = Vec::with_capacity(1 << 14);
    let mut seen_contribution = vec![false; STATES];
    let mut seen_next = vec![false; STATES];
    current.push(Mod4Choice {
        orbit_masks: [0; 6],
        state: initial,
        reserved: 0,
    });
    for slot in 0..SLOTS {
        contributions.clear();
        seen_contribution.fill(false);
        let len = inventory.large_len[slot];
        for selection in 0_u16..1_u16 << len {
            if selection.count_ones() != u32::from(counts[slot]) {
                continue;
            }
            let mut state = 0_u16;
            for orbit in 0..len {
                if selection & (1 << orbit) != 0 {
                    state = add_states_mod4(
                        state,
                        orbit_coefficient_state_mod4(&inventory.large[slot][usize::from(orbit)])?,
                    );
                }
            }
            if !seen_contribution[usize::from(state)] {
                seen_contribution[usize::from(state)] = true;
                contributions.push(Mod4Contribution {
                    state,
                    orbit_mask: selection,
                });
            }
        }
        next.clear();
        seen_next.fill(false);
        'product: for choice in &current {
            for contribution in &contributions {
                let state = add_states_mod4(choice.state, contribution.state);
                if seen_next[usize::from(state)] {
                    continue;
                }
                seen_next[usize::from(state)] = true;
                let mut output = *choice;
                output.state = state;
                output.orbit_masks[slot] = contribution.orbit_mask;
                next.push(output);
                if next.len() == STATES {
                    break 'product;
                }
            }
        }
        std::mem::swap(&mut current, &mut next);
    }
    let mut correlation_seen = vec![false; STATES];
    let mut profiles = Vec::with_capacity(current.len());
    for mut choice in current {
        let correlation = correlation_state_mod4(choice.state);
        if !correlation_seen[usize::from(correlation)] {
            correlation_seen[usize::from(correlation)] = true;
            choice.state = correlation;
            profiles.push(choice);
        }
    }
    Ok(profiles)
}

fn orbit_coefficient_state_power(orbit: &FineOrbit, bits: u8) -> Result<u32, G41Q29EvolveError> {
    let mask = (1_u8 << bits) - 1;
    let mut state = u32::from(orbit.residue_histogram[0] & mask);
    for (class, coset) in Q29_COSETS.iter().enumerate() {
        let value = orbit.residue_histogram[coset[0]] & mask;
        if coset
            .iter()
            .any(|&index| orbit.residue_histogram[index] & mask != value)
        {
            return Err(G41Q29EvolveError::SemanticMismatch);
        }
        state |= u32::from(value) << (usize::from(bits) * (class + 1));
    }
    Ok(state)
}

fn add_states_power(left: u32, right: u32, bits: u8) -> u32 {
    let mask = (1_u32 << bits) - 1;
    let mut output = 0_u32;
    for coordinate in 0..8 {
        let shift = u32::from(bits) * coordinate;
        let left_digit = (left >> shift) & mask;
        let right_digit = (right >> shift) & mask;
        output |= ((left_digit + right_digit) & mask) << shift;
    }
    output
}

fn correlation_state_power(coefficient_state: u32, bits: u8) -> u32 {
    let mask = (1_u32 << bits) - 1;
    let mut coefficients = [0_u8; 29];
    coefficients[0] = (coefficient_state & mask) as u8;
    for (class, coset) in Q29_COSETS.iter().enumerate() {
        let value = ((coefficient_state >> (usize::from(bits) * (class + 1))) & mask) as u8;
        for &residue in coset {
            coefficients[residue] = value;
        }
    }
    let mut output = 0_u32;
    for (coordinate, shift) in std::iter::once(0)
        .chain(Q29_COSETS.iter().map(|coset| coset[0]))
        .enumerate()
    {
        let value = (0..29).fold(0_u32, |sum, residue| {
            sum + u32::from(coefficients[residue]) * u32::from(coefficients[(residue + shift) % 29])
        }) & mask;
        output |= value << (u32::from(bits) * coordinate as u32);
    }
    output
}

fn q29_profile_structural_invariants(profile: u32) -> [u16; 2] {
    let zero = (profile & 15) as u16;
    let mut nonzero_sum = 0_u16;
    let mut nonzero_parity = 0_u16;
    for coordinate in 1..8 {
        let value = ((profile >> (4 * coordinate)) & 15) as u16;
        nonzero_sum = nonzero_sum.wrapping_add(value);
        nonzero_parity ^= value & 1;
    }
    [(zero + 4 * nonzero_sum) & 15, nonzero_parity]
}

fn q29_binary_profile_form() -> Result<BinaryOrbitQuadraticForm, G41Q29EvolveError> {
    let mut point_classes = [0_u8; 29];
    let mut shifts = [0_u16; 7];
    for (class, coset) in Q29_COSETS.iter().enumerate() {
        shifts[class] = coset[0] as u16;
        for &point in coset {
            point_classes[point] = (class + 1) as u8;
        }
    }
    synthesize_binary_orbit_autocorrelation_form::<29, 8, 7>(&point_classes, &shifts, &[1; 7])
        .map_err(|_| G41Q29EvolveError::SemanticMismatch)
}

fn complement_state_power(value: u32, bits: u8) -> u32 {
    let modulus = 1_u32 << bits;
    let mask = modulus - 1;
    let mut output = 0_u32;
    for coordinate in 0..8 {
        let shift = u32::from(bits) * coordinate;
        let target = if coordinate == 0 { 9_883 } else { 9_360 } & mask;
        let digit = (value >> shift) & mask;
        output |= ((target + modulus - digit) & mask) << shift;
    }
    output
}

fn q29_mod16_from_mod8_lift(base_state: u32, lift_state: u8) -> Result<u32, G41Q29EvolveError> {
    let mut base = [0_u16; 29];
    let mut lift = [0_u8; 29];
    base[0] = (base_state & 7) as u16;
    lift[0] = lift_state & 1;
    for (class, coset) in Q29_COSETS.iter().enumerate() {
        let base_value = ((base_state >> (3 * (class + 1))) & 7) as u16;
        let lift_value = (lift_state >> (class + 1)) & 1;
        for &residue in coset {
            base[residue] = base_value;
            lift[residue] = lift_value;
        }
    }
    let mut output = 0_u32;
    for (coordinate, shift) in std::iter::once(0)
        .chain(Q29_COSETS.iter().map(|coset| coset[0]))
        .enumerate()
    {
        let value = lift_autocorrelation(&base, &lift, shift, 3)
            .map_err(|_| G41Q29EvolveError::SemanticMismatch)?;
        output |= u32::from(value) << (4 * coordinate);
    }
    Ok(output)
}

fn split_mod16_coefficient_state(state: u32) -> (u32, u8) {
    let mut low = 0_u32;
    let mut lift = 0_u8;
    for coordinate in 0..8 {
        let digit = (state >> (4 * coordinate)) & 15;
        low |= (digit & 7) << (3 * coordinate);
        lift |= ((digit >> 3) as u8) << coordinate;
    }
    (low, lift)
}

fn add_mod8_low_states(left: u32, right: u32) -> (u32, u8) {
    let mut low = 0_u32;
    let mut carry = 0_u8;
    for coordinate in 0..8 {
        let shift = 3 * coordinate;
        let sum = ((left >> shift) & 7) + ((right >> shift) & 7);
        low |= (sum & 7) << shift;
        carry |= ((sum >> 3) as u8) << coordinate;
    }
    (low, carry)
}

fn subtract_states_power(left: u32, right: u32, bits: u8) -> u32 {
    let modulus = 1_u32 << bits;
    let mask = modulus - 1;
    let mut output = 0_u32;
    for coordinate in 0..8 {
        let shift = u32::from(bits) * coordinate;
        let left_digit = (left >> shift) & mask;
        let right_digit = (right >> shift) & mask;
        output |= ((left_digit + modulus - right_digit) & mask) << shift;
    }
    output
}

struct AffineProfileImage {
    is_affine: bool,
    hull_size: u64,
    generator_count: u8,
    generators: [u32; 16],
}

fn unpack_state_power(value: u32, bits: u8) -> [u16; 8] {
    let mask = (1_u32 << bits) - 1;
    std::array::from_fn(|coordinate| {
        ((value >> (u32::from(bits) * coordinate as u32)) & mask) as u16
    })
}

fn analyze_additive_affine_image(
    profiles: &[u32],
) -> Result<AffineProfileImage, G41Q29EvolveError> {
    let Some(&base) = profiles.first() else {
        return Ok(AffineProfileImage {
            is_affine: false,
            hull_size: 0,
            generator_count: 0,
            generators: [0; 16],
        });
    };
    let mut differences = Vec::with_capacity(profiles.len());
    for &profile in profiles {
        differences.push(subtract_states_power(profile, base, 4));
    }
    differences.sort_unstable();
    differences.dedup();
    if differences.len() != profiles.len() || differences.first().copied() != Some(0) {
        return Err(G41Q29EvolveError::SemanticMismatch);
    }

    let mut generators = [0_u32; 16];
    let mut generator_vectors = [[0_u16; 8]; 16];
    let mut generator_count = 0_usize;
    for &candidate in &differences {
        let candidate_vector = unpack_state_power(candidate, 4);
        if subgroup_membership_z2k(&generator_vectors[..generator_count], candidate_vector, 4)
            .map_err(|_| G41Q29EvolveError::SemanticMismatch)?
            .contains
        {
            continue;
        }
        if generator_count == generators.len() {
            return Ok(AffineProfileImage {
                is_affine: false,
                hull_size: u64::MAX,
                generator_count: generator_count as u8,
                generators,
            });
        }
        generators[generator_count] = candidate;
        generator_vectors[generator_count] = candidate_vector;
        generator_count += 1;
        let diagonal = subgroup_membership_z2k(&generator_vectors[..generator_count], [0; 8], 4)
            .map_err(|_| G41Q29EvolveError::SemanticMismatch)?;
        let exponent: u32 = diagonal.pivot_valuations[..usize::from(diagonal.pivot_count)]
            .iter()
            .map(|&valuation| u32::from(4 - valuation))
            .sum();
        if exponent == 32 {
            break;
        }
    }
    let diagonal = subgroup_membership_z2k(&generator_vectors[..generator_count], [0; 8], 4)
        .map_err(|_| G41Q29EvolveError::SemanticMismatch)?;
    let hull_exponent: u32 = diagonal.pivot_valuations[..usize::from(diagonal.pivot_count)]
        .iter()
        .map(|&valuation| u32::from(4 - valuation))
        .sum();
    let hull_size = 1_u64 << hull_exponent;
    let is_affine = hull_size == differences.len() as u64;
    Ok(AffineProfileImage {
        is_affine,
        hull_size,
        generator_count: generator_count as u8,
        generators,
    })
}

fn compile_block_power_profiles(
    witness: &G41JointQuotientWitness,
    inventory: &FineInventory,
    block: usize,
    workspace: &mut Mod8Workspace,
    bits: u8,
) -> Result<Vec<Mod8Choice>, G41Q29EvolveError> {
    let counts = digit_counts(witness.digits[block]);
    let mut initial = 0_u32;
    for slot in 0..SLOTS {
        if witness.masks[block] & (1 << slot) != 0 {
            initial = add_states_power(
                initial,
                orbit_coefficient_state_power(&inventory.small[slot], bits)?,
                bits,
            );
        }
    }
    let mut current = Vec::with_capacity(Mod8Workspace::MAX_STATES);
    let mut next = Vec::with_capacity(Mod8Workspace::MAX_STATES);
    let mut contributions = Vec::with_capacity(1 << 14);
    current.push(Mod8Choice {
        state: initial,
        orbit_masks: [0; 6],
    });
    for slot in 0..SLOTS {
        contributions.clear();
        workspace.reset();
        let len = inventory.large_len[slot];
        for selection in 0_u16..1_u16 << len {
            if selection.count_ones() != u32::from(counts[slot]) {
                continue;
            }
            let mut state = 0_u32;
            for orbit in 0..len {
                if selection & (1 << orbit) != 0 {
                    state = add_states_power(
                        state,
                        orbit_coefficient_state_power(
                            &inventory.large[slot][usize::from(orbit)],
                            bits,
                        )?,
                        bits,
                    );
                }
            }
            if workspace.insert(state).map_err(|error| match error {
                G41Q29EvolveError::StateBudget => G41Q29EvolveError::PowerStateBudget {
                    bits,
                    block: block as u8,
                    slot: slot as u8,
                    phase: "slot-contributions",
                    states: workspace.touched.len() as u32,
                },
                other => other,
            })? {
                contributions.push(Mod8Contribution {
                    state,
                    orbit_mask: selection,
                    reserved: 0,
                });
            }
        }
        workspace.reset();
        next.clear();
        for choice in &current {
            for contribution in &contributions {
                let state = add_states_power(choice.state, contribution.state, bits);
                if workspace.insert(state).map_err(|error| match error {
                    G41Q29EvolveError::StateBudget => G41Q29EvolveError::PowerStateBudget {
                        bits,
                        block: block as u8,
                        slot: slot as u8,
                        phase: "coefficient-image",
                        states: workspace.touched.len() as u32,
                    },
                    other => other,
                })? {
                    let mut output = *choice;
                    output.state = state;
                    output.orbit_masks[slot] = contribution.orbit_mask;
                    next.push(output);
                }
            }
        }
        workspace.reset();
        std::mem::swap(&mut current, &mut next);
    }
    let mut profiles = Vec::with_capacity(current.len());
    workspace.reset();
    for mut choice in current {
        let correlation = correlation_state_power(choice.state, bits);
        if workspace.insert(correlation).map_err(|error| match error {
            G41Q29EvolveError::StateBudget => G41Q29EvolveError::PowerStateBudget {
                bits,
                block: block as u8,
                slot: SLOTS as u8,
                phase: "correlation-image",
                states: workspace.touched.len() as u32,
            },
            other => other,
        })? {
            choice.state = correlation;
            profiles.push(choice);
        }
    }
    workspace.reset();
    Ok(profiles)
}

fn compile_block_two_adic_fibres(
    witness: &G41JointQuotientWitness,
    inventory: &FineInventory,
    block: usize,
    slots: usize,
    workspace: &mut LiftFibreWorkspace,
) -> Result<(Vec<LiftFibre>, [u32; 6], [u64; 6]), G41Q29EvolveError> {
    if slots > SLOTS {
        return Err(G41Q29EvolveError::SemanticMismatch);
    }
    let counts = digit_counts(witness.digits[block]);
    let mut initial = 0_u32;
    for slot in 0..SLOTS {
        if witness.masks[block] & (1 << slot) != 0 {
            initial = add_states_power(
                initial,
                orbit_coefficient_state_power(&inventory.small[slot], 4)?,
                4,
            );
        }
    }
    let (initial_low, initial_lift) = split_mod16_coefficient_state(initial);
    let mut current = Vec::with_capacity(LiftFibreWorkspace::MAX_STATES);
    let mut next = Vec::with_capacity(LiftFibreWorkspace::MAX_STATES);
    let mut contributions = Vec::with_capacity(1 << 14);
    current.push(LiftFibre::singleton(initial_low, initial_lift));
    let mut low_counts = [0_u32; 6];
    let mut full_counts = [0_u64; 6];
    for slot in 0..slots {
        contributions.clear();
        workspace.reset();
        let len = inventory.large_len[slot];
        for selection in 0_u16..1_u16 << len {
            if selection.count_ones() != u32::from(counts[slot]) {
                continue;
            }
            let mut state = 0_u32;
            for orbit in 0..len {
                if selection & (1 << orbit) != 0 {
                    state = add_states_power(
                        state,
                        orbit_coefficient_state_power(
                            &inventory.large[slot][usize::from(orbit)],
                            4,
                        )?,
                        4,
                    );
                }
            }
            let (low, lift) = split_mod16_coefficient_state(state);
            let candidate_index = contributions.len() as u32;
            let (index, inserted) = workspace.index_or_insert(low, candidate_index)?;
            if inserted {
                contributions.push(LiftFibre::singleton(low, lift));
            } else {
                let fibre = &mut contributions[index as usize];
                fibre.lift_bits[usize::from(lift >> 6)] |= 1_u64 << (lift & 63);
            }
        }
        workspace.reset();
        next.clear();
        for left in &current {
            for right in &contributions {
                let (low, carry) = add_mod8_low_states(left.low_state, right.low_state);
                let candidate_index = next.len() as u32;
                let (index, inserted) = workspace.index_or_insert(low, candidate_index)?;
                if inserted {
                    next.push(LiftFibre {
                        lift_bits: [0; 4],
                        low_state: low,
                        reserved: [0; 28],
                    });
                }
                xor_sumset_256_into(
                    &mut next[index as usize].lift_bits,
                    &left.lift_bits,
                    &right.lift_bits,
                    carry,
                );
            }
        }
        workspace.reset();
        std::mem::swap(&mut current, &mut next);
        low_counts[slot] = current.len() as u32;
        full_counts[slot] = current
            .iter()
            .map(|fibre| u64::from(fibre.cardinality()))
            .sum();
    }
    Ok((current, low_counts, full_counts))
}

fn compile_two_adic_correlation_profiles(
    fibres: &[LiftFibre],
    workspace: &mut LiftFibreWorkspace,
) -> Result<Vec<u32>, G41Q29EvolveError> {
    workspace.reset();
    let mut profiles = Vec::with_capacity(LiftFibreWorkspace::MAX_STATES);
    for fibre in fibres {
        for (word_index, &word) in fibre.lift_bits.iter().enumerate() {
            let mut bits = word;
            while bits != 0 {
                let lift = (word_index * 64 + bits.trailing_zeros() as usize) as u8;
                bits &= bits - 1;
                let correlation = q29_mod16_from_mod8_lift(fibre.low_state, lift)?;
                let candidate = profiles.len() as u32;
                let (_, inserted) = workspace.index_or_insert(correlation, candidate)?;
                if inserted {
                    profiles.push(correlation);
                }
            }
        }
    }
    workspace.reset();
    Ok(profiles)
}

fn contribution_state_mod16(
    inventory: &FineInventory,
    slot: usize,
    selection: u16,
) -> Result<u32, G41Q29EvolveError> {
    let mut state = 0_u32;
    for orbit in 0..inventory.large_len[slot] {
        if selection & (1 << orbit) != 0 {
            state = add_states_power(
                state,
                orbit_coefficient_state_power(&inventory.large[slot][usize::from(orbit)], 4)?,
                4,
            );
        }
    }
    Ok(state)
}

fn reconstruct_block_mod16_selection(
    witness: &G41JointQuotientWitness,
    inventory: &FineInventory,
    block: usize,
    target_profile: u32,
    workspace: &mut LiftFibreWorkspace,
) -> Result<Option<[u16; 6]>, G41Q29EvolveError> {
    let (final_fibres, _, _) =
        compile_block_two_adic_fibres(witness, inventory, block, SLOTS, workspace)?;
    let mut target_state = None;
    'fibres: for fibre in &final_fibres {
        for (word_index, &word) in fibre.lift_bits.iter().enumerate() {
            let mut bits = word;
            while bits != 0 {
                let lift = (word_index * 64 + bits.trailing_zeros() as usize) as u8;
                bits &= bits - 1;
                if q29_mod16_from_mod8_lift(fibre.low_state, lift)? == target_profile {
                    let mut state = 0_u32;
                    for coordinate in 0..8 {
                        let low = (fibre.low_state >> (3 * coordinate)) & 7;
                        let high = u32::from((lift >> coordinate) & 1);
                        state |= (low | (high << 3)) << (4 * coordinate);
                    }
                    target_state = Some(state);
                    break 'fibres;
                }
            }
        }
    }
    let Some(mut target_state) = target_state else {
        return Err(G41Q29EvolveError::SemanticMismatch);
    };

    let counts = digit_counts(witness.digits[block]);
    let mut selections = [0_u16; 6];
    for slot in (0..SLOTS).rev() {
        let (prefix_fibres, _, _) =
            compile_block_two_adic_fibres(witness, inventory, block, slot, workspace)?;
        workspace.reset();
        for (index, fibre) in prefix_fibres.iter().enumerate() {
            workspace.index_or_insert(fibre.low_state, index as u32)?;
        }
        let len = inventory.large_len[slot];
        let mut chosen = None;
        for selection in 0_u16..1_u16 << len {
            if selection.count_ones() != u32::from(counts[slot]) {
                continue;
            }
            let contribution = contribution_state_mod16(inventory, slot, selection)?;
            let previous = subtract_states_power(target_state, contribution, 4);
            let (low, lift) = split_mod16_coefficient_state(previous);
            let Some(index) = workspace.get(low) else {
                continue;
            };
            let fibre = &prefix_fibres[index as usize];
            if fibre.lift_bits[usize::from(lift >> 6)] & (1_u64 << (lift & 63)) != 0 {
                chosen = Some((selection, previous));
                break;
            }
        }
        workspace.reset();
        let Some((selection, previous)) = chosen else {
            return Err(G41Q29EvolveError::SemanticMismatch);
        };
        selections[slot] = selection;
        target_state = previous;
    }

    let mut full_selection = [0_u16; 24];
    full_selection[block * SLOTS..(block + 1) * SLOTS].copy_from_slice(&selections);
    let coefficients = compile_block_coefficients(witness, inventory, &full_selection, block);
    let mut coefficient_state = u32::from(coefficients[0] & 15);
    for (class, coset) in Q29_COSETS.iter().enumerate() {
        coefficient_state |= u32::from(coefficients[coset[0]] & 15) << (4 * (class + 1));
    }
    if correlation_state_power(coefficient_state, 4) != target_profile {
        return Err(G41Q29EvolveError::SemanticMismatch);
    }
    Ok(Some(selections))
}

pub fn scout_g41_q29_two_adic_compression(
    root_id: u32,
    block: u8,
) -> Result<G41Q29TwoAdicCompressionReport, G41Q29EvolveError> {
    if usize::from(block) >= 4 {
        return Err(G41Q29EvolveError::SemanticMismatch);
    }
    let quotient = census_g41_joint_full_mitm()?;
    let witness = quotient
        .witnesses
        .iter()
        .find(|witness| witness.root_id == root_id)
        .ok_or(G41Q29EvolveError::SemanticMismatch)?;
    let inventory = compile_inventory()?;
    let mut workspace = LiftFibreWorkspace::new();
    let (fibres, low_counts, full_counts) = compile_block_two_adic_fibres(
        witness,
        &inventory,
        usize::from(block),
        SLOTS,
        &mut workspace,
    )?;
    let max_fibre = fibres.iter().map(LiftFibre::cardinality).max().unwrap_or(0);
    let correlation_profiles = compile_two_adic_correlation_profiles(&fibres, &mut workspace)?;
    let affine = analyze_additive_affine_image(&correlation_profiles)?;
    Ok(G41Q29TwoAdicCompressionReport {
        root_id,
        block,
        low_fibres_after_slot: low_counts,
        full_states_after_slot: full_counts,
        final_max_fibre: max_fibre,
        mod16_correlation_profiles: correlation_profiles.len() as u32,
        additive_base: correlation_profiles.first().copied().unwrap_or(0),
        additive_affine_image: affine.is_affine,
        additive_hull_profiles: affine.hull_size,
        additive_generator_count: affine.generator_count,
        additive_generators: affine.generators,
        provenance: "exact root-local 2-adic coefficient fibres for one retained quotient witness; theorem-derived mod-16 images are replayable, but this discovery report has no root-exclusion authority",
    })
}

fn scout_g41_q29_two_adic_joint_with_samples(
    root_id: u32,
    pair_samples: u32,
) -> Result<G41Q29TwoAdicJointReport, G41Q29EvolveError> {
    if pair_samples > 1 << 24 {
        return Err(G41Q29EvolveError::StateBudget);
    }
    let quotient = census_g41_joint_full_mitm()?;
    let witness = quotient
        .witnesses
        .iter()
        .find(|witness| witness.root_id == root_id)
        .ok_or(G41Q29EvolveError::SemanticMismatch)?;
    let inventory = compile_inventory()?;
    let mut fibre_workspace = LiftFibreWorkspace::new();
    let mut profiles: [Vec<u32>; 4] = std::array::from_fn(|_| Vec::new());
    for (block, output) in profiles.iter_mut().enumerate() {
        let (fibres, _, _) =
            compile_block_two_adic_fibres(witness, &inventory, block, SLOTS, &mut fibre_workspace)?;
        *output = compile_two_adic_correlation_profiles(&fibres, &mut fibre_workspace)?;
    }
    let profile_counts = std::array::from_fn(|block| profiles[block].len() as u32);
    let mut block_hulls = [0_u64; 4];
    let mut combined_base = 0_u32;
    let mut combined_generators = [0_u32; 64];
    let mut combined_generator_vectors = [[0_u16; 8]; 64];
    let mut combined_generator_count = 0_usize;
    for block in 0..4 {
        let image = analyze_additive_affine_image(&profiles[block])?;
        block_hulls[block] = image.hull_size;
        let base = profiles[block]
            .first()
            .copied()
            .ok_or(G41Q29EvolveError::SemanticMismatch)?;
        combined_base = add_states_power(combined_base, base, 4);
        for &generator in &image.generators[..usize::from(image.generator_count)] {
            let vector = unpack_state_power(generator, 4);
            if subgroup_membership_z2k(
                &combined_generator_vectors[..combined_generator_count],
                vector,
                4,
            )
            .map_err(|_| G41Q29EvolveError::SemanticMismatch)?
            .contains
            {
                continue;
            }
            combined_generators[combined_generator_count] = generator;
            combined_generator_vectors[combined_generator_count] = vector;
            combined_generator_count += 1;
        }
    }
    drop(fibre_workspace);
    let target = 9_883_u32 & 15;
    let target_delta = subtract_states_power(target, combined_base, 4);
    let membership = subgroup_membership_z2k(
        &combined_generator_vectors[..combined_generator_count],
        unpack_state_power(target_delta, 4),
        4,
    )
    .map_err(|_| G41Q29EvolveError::SemanticMismatch)?;
    let base_membership = subgroup_membership_z2k(
        &combined_generator_vectors[..combined_generator_count],
        unpack_state_power(combined_base, 4),
        4,
    )
    .map_err(|_| G41Q29EvolveError::SemanticMismatch)?;
    let target_membership = subgroup_membership_z2k(
        &combined_generator_vectors[..combined_generator_count],
        unpack_state_power(target, 4),
        4,
    )
    .map_err(|_| G41Q29EvolveError::SemanticMismatch)?;
    if base_membership.row_transform != membership.row_transform
        || target_membership.row_transform != membership.row_transform
    {
        return Err(G41Q29EvolveError::SemanticMismatch);
    }
    let hull_exponent: u32 = membership.pivot_valuations[..usize::from(membership.pivot_count)]
        .iter()
        .map(|&valuation| u32::from(4 - valuation))
        .sum();
    let structural_base_invariants = q29_profile_structural_invariants(combined_base);
    let structural_target_invariants = q29_profile_structural_invariants(target);
    let structural_expected_weighted_sum = [260_u64, 261, 261, 261]
        .into_iter()
        .try_fold(0_u16, |sum, row_sum| {
            autocorrelation_total_from_row_sum(row_sum, 4).map(|value| (sum + value) & 15)
        })
        .map_err(|_| G41Q29EvolveError::SemanticMismatch)?;
    let generators_satisfy_structural_kernel = combined_generators[..combined_generator_count]
        .iter()
        .all(|&generator| q29_profile_structural_invariants(generator) == [0, 0]);
    let binary_form = q29_binary_profile_form()?;
    let structural_witness_coefficient_parity = witness_nonzero_class_parity(witness, &inventory)?;
    let witness_index_32_kernel_proved = binary_form.diagonal == 0xfe
        && binary_form.mixed_upper.iter().all(|&row| row == 0)
        && structural_witness_coefficient_parity == 0
        && generators_satisfy_structural_kernel
        && hull_exponent == 27
        && structural_base_invariants == [structural_expected_weighted_sum, 0]
        && structural_base_invariants == structural_target_invariants;
    let mut sampled_match = None;
    let mut sampled_left_pair_profiles = 0_u32;
    if membership.contains && pair_samples != 0 {
        let mut pair_workspace = Mod8Workspace::new();
        let mut random = 0x98ce_17a4_5b30_d26f_u64 ^ u64::from(root_id);
        for _ in 0..pair_samples {
            let first = next_random(&mut random) as usize % profiles[0].len();
            let second = next_random(&mut random) as usize % profiles[1].len();
            let state = add_states_power(profiles[0][first], profiles[1][second], 4);
            pair_workspace.insert_with_value(state, first as u64 | ((second as u64) << 32))?;
        }
        sampled_left_pair_profiles = pair_workspace.touched.len() as u32;
        for _ in 0..pair_samples {
            let third = next_random(&mut random) as usize % profiles[2].len();
            let fourth = next_random(&mut random) as usize % profiles[3].len();
            let state = add_states_power(profiles[2][third], profiles[3][fourth], 4);
            if let Some(packed) = pair_workspace.get(complement_state_power(state, 4)) {
                sampled_match = Some([
                    profiles[0][packed as u32 as usize],
                    profiles[1][(packed >> 32) as u32 as usize],
                    profiles[2][third],
                    profiles[3][fourth],
                ]);
                break;
            }
        }
        pair_workspace.reset();
    }
    if let Some(matched) = sampled_match {
        let sum = matched
            .into_iter()
            .fold(0_u32, |sum, value| add_states_power(sum, value, 4));
        if sum != target {
            return Err(G41Q29EvolveError::SemanticMismatch);
        }
    }
    let mut sampled_selection = None;
    let mut sampled_exact_residual = None;
    let mut sampled_full_paf_hit = false;
    if let Some(matched) = sampled_match {
        let mut selection = [0_u16; 24];
        let mut reconstruction_workspace = LiftFibreWorkspace::new();
        for block in 0..4 {
            let block_selection = reconstruct_block_mod16_selection(
                witness,
                &inventory,
                block,
                matched[block],
                &mut reconstruction_workspace,
            )?
            .ok_or(G41Q29EvolveError::SemanticMismatch)?;
            selection[block * SLOTS..(block + 1) * SLOTS].copy_from_slice(&block_selection);
        }
        let coefficients = compile_coefficients(witness, &inventory, &selection);
        let (_, correlation) = correlations(&coefficients);
        let residual = q29_residual(&correlation);
        sampled_full_paf_hit = residual == 0 && direct_full_replay(witness, &inventory, &selection);
        sampled_exact_residual = Some(residual);
        sampled_selection = Some(G41Q29Selection {
            root_id,
            digits: witness.digits,
            orbit_masks: selection,
        });
    }
    Ok(G41Q29TwoAdicJointReport {
        root_id,
        block_correlation_profiles: profile_counts,
        block_hull_profiles: block_hulls,
        combined_generator_count: combined_generator_count as u8,
        combined_generators: combined_generators[..combined_generator_count].to_vec(),
        combined_hull_profiles: 1_u64 << hull_exponent,
        target_in_combined_hull: membership.contains,
        pivot_count: membership.pivot_count,
        pivot_valuations: membership.pivot_valuations,
        quotient_row_transform: membership.row_transform,
        base_quotient_residue: base_membership.quotient_residue(),
        target_quotient_residue: target_membership.quotient_residue(),
        structural_base_invariants,
        structural_target_invariants,
        structural_expected_weighted_sum,
        structural_witness_coefficient_parity,
        witness_index_32_kernel_proved,
        pair_samples,
        sampled_left_pair_profiles,
        sampled_mod16_match: sampled_match,
        sampled_selection,
        sampled_exact_residual,
        sampled_full_paf_hit,
        provenance: "exact mod-16 order-29 profile images for one retained quotient witness, enclosed in theorem-replayed additive hulls over Z/16; target nonmembership excludes only this witness, sampled misses have no authority, and every reported modular hit is checked by exact packed addition but is not a full PAF positive",
    })
}

pub fn scout_g41_q29_two_adic_joint(
    root_id: u32,
) -> Result<G41Q29TwoAdicJointReport, G41Q29EvolveError> {
    scout_g41_q29_two_adic_joint_with_samples(root_id, 1 << 20)
}

pub fn scout_g41_q29_two_adic_hull(
    root_id: u32,
) -> Result<G41Q29TwoAdicJointReport, G41Q29EvolveError> {
    scout_g41_q29_two_adic_joint_with_samples(root_id, 0)
}

#[cfg(test)]
fn add_states_mod8(left: u32, right: u32) -> u32 {
    add_states_power(left, right, 3)
}

#[cfg(test)]
fn correlation_state_mod8(coefficient_state: u32) -> u32 {
    correlation_state_power(coefficient_state, 3)
}

#[cfg(test)]
fn complement_state_mod8(value: u32) -> u32 {
    complement_state_power(value, 3)
}

fn direct_full_replay(
    witness: &G41JointQuotientWitness,
    inventory: &FineInventory,
    selection: &[u16; 24],
) -> bool {
    let mut words = [[0_u8; CARRIER]; 4];
    for block in 0..4 {
        for slot in 0..SLOTS {
            let mut apply = |orbit: &FineOrbit| {
                for &point in &orbit.points[..usize::from(orbit.len)] {
                    words[block][usize::from(point)] = 1;
                }
            };
            if witness.masks[block] & (1 << slot) != 0 {
                apply(&inventory.small[slot]);
            }
            let selected = selection[block * SLOTS + slot];
            for orbit in 0..inventory.large_len[slot] {
                if selected & (1 << orbit) != 0 {
                    apply(&inventory.large[slot][usize::from(orbit)]);
                }
            }
        }
    }
    if words[0].iter().map(|&value| u16::from(value)).sum::<u16>() != 260
        || words[1..]
            .iter()
            .any(|word| word.iter().map(|&value| u16::from(value)).sum::<u16>() != 261)
    {
        return false;
    }
    for shift in 1..CARRIER {
        let mut paf = 0_u32;
        for word in &words {
            for position in 0..CARRIER {
                paf += u32::from(word[position] * word[(position + shift) % CARRIER]);
            }
        }
        if paf != 520 {
            return false;
        }
    }
    true
}

fn add_orbit_q174(coefficients: &mut [u8; 174], orbit: &FineOrbit) {
    for &point in &orbit.points[..usize::from(orbit.len)] {
        coefficients[usize::from(point) % 174] += 1;
    }
}

fn subtract_orbit_q174(coefficients: &mut [u8; 174], orbit: &FineOrbit) {
    for &point in &orbit.points[..usize::from(orbit.len)] {
        coefficients[usize::from(point) % 174] -= 1;
    }
}

fn block_q174_coefficients(
    witness: &G41JointQuotientWitness,
    inventory: &FineInventory,
    selection: &[u16; 24],
    block: usize,
) -> [u8; 174] {
    let mut coefficients = [0_u8; 174];
    for slot in 0..SLOTS {
        if witness.masks[block] & (1 << slot) != 0 {
            add_orbit_q174(&mut coefficients, &inventory.small[slot]);
        }
        let selected = selection[block * SLOTS + slot];
        for orbit in 0..inventory.large_len[slot] {
            if selected & (1 << orbit) != 0 {
                add_orbit_q174(
                    &mut coefficients,
                    &inventory.large[slot][usize::from(orbit)],
                );
            }
        }
    }
    coefficients
}

fn block_q174_defects(coefficients: &[u8; 174]) -> [u16; 87] {
    let zero = coefficients
        .iter()
        .map(|&value| u32::from(value) * u32::from(value))
        .sum::<u32>();
    std::array::from_fn(|index| {
        let shift = index + 1;
        let correlation = (0..174)
            .map(|position| {
                u32::from(coefficients[position])
                    * u32::from(coefficients[(position + shift) % 174])
            })
            .sum::<u32>();
        (zero - correlation) as u16
    })
}

fn q174_swap_defects(
    coefficients: &[u8; 174],
    defects: &[u16; 87],
    removed: &FineOrbit,
    added: &FineOrbit,
) -> [u16; 87] {
    let mut delta = [0_i8; 174];
    let mut touched = [false; 174];
    let mut changed = [0_u8; 24];
    let mut changed_len = 0_usize;
    for &point in &removed.points[..usize::from(removed.len)] {
        let position = usize::from(point) % 174;
        if !touched[position] {
            touched[position] = true;
            changed[changed_len] = position as u8;
            changed_len += 1;
        }
        delta[position] -= 1;
    }
    for &point in &added.points[..usize::from(added.len)] {
        let position = usize::from(point) % 174;
        if !touched[position] {
            touched[position] = true;
            changed[changed_len] = position as u8;
            changed_len += 1;
        }
        delta[position] += 1;
    }
    let mut energy_delta = 0_i32;
    for &position in &changed[..changed_len] {
        let position = usize::from(position);
        let value = i32::from(coefficients[position]);
        let change = i32::from(delta[position]);
        energy_delta += 2 * value * change + change * change;
    }
    std::array::from_fn(|index| {
        let shift = index + 1;
        let mut correlation_delta = 0_i32;
        for &position in &changed[..changed_len] {
            let position = usize::from(position);
            let change = i32::from(delta[position]);
            correlation_delta += change
                * (i32::from(coefficients[(position + shift) % 174])
                    + i32::from(coefficients[(position + 174 - shift) % 174])
                    + i32::from(delta[(position + shift) % 174]));
        }
        let updated = i32::from(defects[index]) + energy_delta - correlation_delta;
        debug_assert!(updated >= 0);
        updated as u16
    })
}

fn q174_score(blocks: &[[u16; 87]; 4]) -> (u64, u64, u16) {
    let mut squared = 0_u64;
    let mut l1 = 0_u64;
    let mut maximum = 0_u16;
    for shift in 0..87 {
        let combined = blocks
            .iter()
            .map(|block| u32::from(block[shift]))
            .sum::<u32>();
        let residual = combined.abs_diff(523) as u16;
        squared += u64::from(residual) * u64::from(residual);
        l1 += u64::from(residual);
        maximum = maximum.max(residual);
    }
    (squared, l1, maximum)
}

fn q174_summary(blocks: &[[u16; 87]; 4], coefficients: &[[u8; 174]; 4]) -> (u64, u16, u16, u16) {
    let mut sum = 0_u64;
    let mut minimum = u16::MAX;
    let mut maximum = 0_u16;
    for shift in 0..87 {
        let combined = blocks.iter().map(|block| block[shift]).sum::<u16>();
        sum += u64::from(combined);
        minimum = minimum.min(combined);
        maximum = maximum.max(combined);
    }
    let zero_energy = coefficients
        .iter()
        .flatten()
        .map(|&value| u16::from(value) * u16::from(value))
        .sum::<u16>();
    (sum, minimum, maximum, zero_energy)
}

pub fn evolve_g41_q174_discovery(
    threads: usize,
    attempts: u64,
    mutations_per_attempt: u32,
) -> Result<G41Q174EvolveReport, G41Q29EvolveError> {
    let interfaces = enumerate_g41_joint_digit_witnesses()?;
    evolve_g41_q174_discovery_from_interfaces(
        &interfaces.witnesses,
        threads,
        attempts,
        mutations_per_attempt,
    )
}

pub fn evolve_g41_q174_discovery_from_interfaces(
    interfaces: &[G41JointQuotientWitness],
    threads: usize,
    attempts: u64,
    mutations_per_attempt: u32,
) -> Result<G41Q174EvolveReport, G41Q29EvolveError> {
    use std::sync::atomic::{AtomicU64, Ordering};

    if threads == 0 || threads > 32 || attempts == 0 || mutations_per_attempt == 0 {
        return Err(G41Q29EvolveError::StateBudget);
    }
    if interfaces.is_empty() {
        return Err(G41Q29EvolveError::SemanticMismatch);
    }
    let inventory = compile_inventory()?;
    let next = AtomicU64::new(0);
    let reports = std::thread::scope(|scope| {
        let mut handles = Vec::with_capacity(threads);
        for worker in 0..threads {
            let inventory = &inventory;
            let next = &next;
            handles.push(scope.spawn(move || {
                let mut random = 0x9e37_79b9_7f4a_7c15_u64
                    ^ (worker as u64).wrapping_mul(0xd1b5_4a32_d192_ed03);
                let mut report = G41Q174EvolveReport {
                    threads: 1,
                    attempts: 0,
                    mutations_per_attempt,
                    mutations: 0,
                    accepted_mutations: 0,
                    q174_hits: 0,
                    full_paf_hits: 0,
                    best_initial_q174_squared_residual: u64::MAX,
                    best_q174_squared_residual: u64::MAX,
                    best_q174_l1_residual: u64::MAX,
                    best_q174_max_residual: u16::MAX,
                    best_q174_defect_sum: 0,
                    best_q174_min_defect: 0,
                    best_q174_max_defect: 0,
                    best_q174_zero_energy: 0,
                    best_selection: None,
                    first_full_selection: None,
                    provenance: "discovery-only q174 evolution over exact source interfaces; misses have no authority, while every zero is reconstructed from fine-orbit masks and checked against all original PAF equations",
                };
                loop {
                    let attempt = next.fetch_add(1, Ordering::Relaxed);
                    if attempt >= attempts {
                        break;
                    }
                    report.attempts += 1;
                    let witness =
                        &interfaces[next_random(&mut random) as usize % interfaces.len()];
                    let mut selection = initialize_selection(witness, inventory, &mut random);
                    let mut coefficients: [[u8; 174]; 4] = std::array::from_fn(|block| {
                        block_q174_coefficients(witness, inventory, &selection, block)
                    });
                    let mut block_defects: [[u16; 87]; 4] =
                        std::array::from_fn(|block| block_q174_defects(&coefficients[block]));
                    let mut score = q174_score(&block_defects);
                    report.best_initial_q174_squared_residual = report
                        .best_initial_q174_squared_residual
                        .min(score.0);
                    if score.0 < report.best_q174_squared_residual {
                        report.best_q174_squared_residual = score.0;
                        report.best_q174_l1_residual = score.1;
                        report.best_q174_max_residual = score.2;
                        let summary = q174_summary(&block_defects, &coefficients);
                        report.best_q174_defect_sum = summary.0;
                        report.best_q174_min_defect = summary.1;
                        report.best_q174_max_defect = summary.2;
                        report.best_q174_zero_energy = summary.3;
                        report.best_selection = Some(G41Q29Selection {
                            root_id: witness.root_id,
                            digits: witness.digits,
                            orbit_masks: selection,
                        });
                    }
                    for _ in 0..mutations_per_attempt {
                        let block = next_random(&mut random) as usize % 4;
                        let mut slot = next_random(&mut random) as usize % SLOTS;
                        for _ in 0..SLOTS {
                            let selected = selection[block * SLOTS + slot];
                            let count = selected.count_ones();
                            if count != 0 && count != u32::from(inventory.large_len[slot]) {
                                break;
                            }
                            slot = (slot + 1) % SLOTS;
                        }
                        let index = block * SLOTS + slot;
                        let old_mask = selection[index];
                        if old_mask == 0
                            || old_mask.count_ones() == u32::from(inventory.large_len[slot])
                        {
                            continue;
                        }
                        let mut removed =
                            next_random(&mut random) as u8 % inventory.large_len[slot];
                        while old_mask & (1 << removed) == 0 {
                            removed = (removed + 1) % inventory.large_len[slot];
                        }
                        let mut added =
                            next_random(&mut random) as u8 % inventory.large_len[slot];
                        while old_mask & (1 << added) != 0 {
                            added = (added + 1) % inventory.large_len[slot];
                        }
                        let removed_orbit = &inventory.large[slot][usize::from(removed)];
                        let added_orbit = &inventory.large[slot][usize::from(added)];
                        let candidate_defects = q174_swap_defects(
                            &coefficients[block],
                            &block_defects[block],
                            removed_orbit,
                            added_orbit,
                        );
                        let old_defects = block_defects[block];
                        block_defects[block] = candidate_defects;
                        let candidate = q174_score(&block_defects);
                        report.mutations += 1;
                        let tolerance = 32_u64.saturating_add(score.0 / 4096);
                        let accept = candidate.0 <= score.0
                            || (candidate.0 <= score.0.saturating_add(tolerance)
                                && next_random(&mut random) & 31 == 0);
                        if accept {
                            report.accepted_mutations += 1;
                            selection[index] ^= (1 << removed) | (1 << added);
                            subtract_orbit_q174(&mut coefficients[block], removed_orbit);
                            add_orbit_q174(&mut coefficients[block], added_orbit);
                            score = candidate;
                            if score.0 < report.best_q174_squared_residual {
                                report.best_q174_squared_residual = score.0;
                                report.best_q174_l1_residual = score.1;
                                report.best_q174_max_residual = score.2;
                                let summary = q174_summary(&block_defects, &coefficients);
                                report.best_q174_defect_sum = summary.0;
                                report.best_q174_min_defect = summary.1;
                                report.best_q174_max_defect = summary.2;
                                report.best_q174_zero_energy = summary.3;
                                report.best_selection = Some(G41Q29Selection {
                                    root_id: witness.root_id,
                                    digits: witness.digits,
                                    orbit_masks: selection,
                                });
                            }
                        } else {
                            block_defects[block] = old_defects;
                        }
                        if score.0 == 0 {
                            report.q174_hits += 1;
                            let selected = G41Q29Selection {
                                root_id: witness.root_id,
                                digits: witness.digits,
                                orbit_masks: selection,
                            };
                            if direct_full_replay(witness, inventory, &selection) {
                                report.full_paf_hits += 1;
                                report.first_full_selection.get_or_insert(selected);
                            }
                            break;
                        }
                    }
                }
                report
            }));
        }
        handles
            .into_iter()
            .map(|handle| {
                handle
                    .join()
                    .map_err(|_| G41Q29EvolveError::ParallelExecution)
            })
            .collect::<Result<Vec<_>, _>>()
    })?;
    let mut merged = G41Q174EvolveReport {
        threads: threads as u16,
        attempts: 0,
        mutations_per_attempt,
        mutations: 0,
        accepted_mutations: 0,
        q174_hits: 0,
        full_paf_hits: 0,
        best_initial_q174_squared_residual: u64::MAX,
        best_q174_squared_residual: u64::MAX,
        best_q174_l1_residual: u64::MAX,
        best_q174_max_residual: u16::MAX,
        best_q174_defect_sum: 0,
        best_q174_min_defect: 0,
        best_q174_max_defect: 0,
        best_q174_zero_energy: 0,
        best_selection: None,
        first_full_selection: None,
        provenance: "discovery-only q174 evolution over exact source interfaces; misses have no authority, while every zero is reconstructed from fine-orbit masks and checked against all original PAF equations",
    };
    for report in reports {
        merged.attempts += report.attempts;
        merged.mutations += report.mutations;
        merged.accepted_mutations += report.accepted_mutations;
        merged.q174_hits += report.q174_hits;
        merged.full_paf_hits += report.full_paf_hits;
        merged.best_initial_q174_squared_residual = merged
            .best_initial_q174_squared_residual
            .min(report.best_initial_q174_squared_residual);
        if report.best_q174_squared_residual < merged.best_q174_squared_residual {
            merged.best_q174_squared_residual = report.best_q174_squared_residual;
            merged.best_q174_l1_residual = report.best_q174_l1_residual;
            merged.best_q174_max_residual = report.best_q174_max_residual;
            merged.best_q174_defect_sum = report.best_q174_defect_sum;
            merged.best_q174_min_defect = report.best_q174_min_defect;
            merged.best_q174_max_defect = report.best_q174_max_defect;
            merged.best_q174_zero_energy = report.best_q174_zero_energy;
            merged.best_selection = report.best_selection;
        }
        if merged.first_full_selection.is_none() {
            merged.first_full_selection = report.first_full_selection;
        }
    }
    Ok(merged)
}

struct Q29Kernel<const BALANCE_WEIGHT: u8, const ROOT_SCOPE: bool> {
    inventory: FineInventory,
    restarts: u16,
    mutations: u32,
    seed: Option<G41Q29Selection>,
}

struct Q29Worker;

impl<const BALANCE_WEIGHT: u8, const ROOT_SCOPE: bool> RootKernel
    for Q29Kernel<BALANCE_WEIGHT, ROOT_SCOPE>
{
    type Root = G41JointQuotientWitness;
    type Worker = Q29Worker;
    type Output = Result<G41Q29EvolveReport, G41Q29EvolveError>;

    fn create_worker(&self) -> Self::Worker {
        Q29Worker
    }

    fn evaluate(
        &self,
        _worker: &mut Self::Worker,
        ordinal: RootOrdinal,
        witness: &Self::Root,
    ) -> Self::Output {
        let mut random = 0xd1b5_4a32_d192_ed03_u64 ^ u64::from(ordinal.0);
        let mut best = u64::MAX;
        let mut best_selection = [0_u16; 24];
        let mut evaluated = 0_u64;
        for restart in 0..self.restarts {
            let mut selection = if restart == 0 {
                self.seed
                    .filter(|seed| seed.root_id == witness.root_id && seed.digits == witness.digits)
                    .map(|seed| seed.orbit_masks)
                    .unwrap_or_else(|| initialize_selection(witness, &self.inventory, &mut random))
            } else {
                initialize_selection(witness, &self.inventory, &mut random)
            };
            for block in 0..4 {
                let counts = digit_counts(witness.digits[block]);
                for slot in 0..SLOTS {
                    let mask = selection[block * SLOTS + slot];
                    if mask >> self.inventory.large_len[slot] != 0
                        || mask.count_ones() != u32::from(counts[slot])
                    {
                        return Err(G41Q29EvolveError::SemanticMismatch);
                    }
                }
            }
            let mut coefficients = compile_coefficients(witness, &self.inventory, &selection);
            let expected_rows = [260_u16, 261, 261, 261];
            if (0..4).any(|block| coefficients[block].iter().sum::<u16>() != expected_rows[block]) {
                return Err(G41Q29EvolveError::SemanticMismatch);
            }
            let mut block_defects: [ResidualTuple<u32, 7>; 4] =
                std::array::from_fn(|block| block_q29_defects(&coefficients[block]));
            let mut defects = total_q29_defects(&block_defects);
            let initial_residual = q29_defect_residual(&defects);
            let mut score = q29_guided_defect_score::<BALANCE_WEIGHT>(&defects, initial_residual);
            if initial_residual < best {
                best = initial_residual;
                best_selection = selection;
            }
            for _ in 0..self.mutations {
                let block = next_random(&mut random) as usize % 4;
                let mut slot = next_random(&mut random) as usize % SLOTS;
                for _ in 0..SLOTS {
                    let mask = selection[block * SLOTS + slot];
                    let count = mask.count_ones();
                    if count != 0 && count != u32::from(self.inventory.large_len[slot]) {
                        break;
                    }
                    slot = (slot + 1) % SLOTS;
                }
                let index = block * SLOTS + slot;
                let old_mask = selection[index];
                if old_mask == 0
                    || old_mask.count_ones() == u32::from(self.inventory.large_len[slot])
                {
                    continue;
                }
                let mut removed = next_random(&mut random) as u8 % self.inventory.large_len[slot];
                while old_mask & (1 << removed) == 0 {
                    removed = (removed + 1) % self.inventory.large_len[slot];
                }
                let mut added = next_random(&mut random) as u8 % self.inventory.large_len[slot];
                while old_mask & (1 << added) != 0 {
                    added = (added + 1) % self.inventory.large_len[slot];
                }
                selection[index] ^= (1 << removed) | (1 << added);
                let old_coefficients = coefficients[block];
                let old_block_defects = block_defects[block];
                let old_defects = defects;
                coefficients[block] =
                    compile_block_coefficients(witness, &self.inventory, &selection, block);
                block_defects[block] = block_q29_defects(&coefficients[block]);
                for class in 0..7 {
                    defects.0[class] = old_defects.0[class] - old_block_defects.0[class]
                        + block_defects[block].0[class];
                }
                let next_residual = q29_defect_residual(&defects);
                let next_score = q29_guided_defect_score::<BALANCE_WEIGHT>(&defects, next_residual);
                evaluated += 1;
                let accept = next_score <= score
                    || (next_score <= score.saturating_add(128)
                        && next_random(&mut random) & 15 == 0);
                if accept {
                    score = next_score;
                    if next_residual < best {
                        best = next_residual;
                        best_selection = selection;
                    }
                } else {
                    selection[index] = old_mask;
                    coefficients[block] = old_coefficients;
                    block_defects[block] = old_block_defects;
                    defects = old_defects;
                }
                if score == 0 {
                    let (_, correlation) = correlations(&coefficients);
                    if q29_residual(&correlation) != 0 {
                        return Err(G41Q29EvolveError::SemanticMismatch);
                    }
                    let selected = G41Q29Selection {
                        root_id: witness.root_id,
                        digits: witness.digits,
                        orbit_masks: selection,
                    };
                    let full = direct_full_replay(witness, &self.inventory, &selection);
                    let (
                        residual_motifs,
                        residual_motif_count,
                        nonzero_residual_sum_roots,
                        nonzero_residual_sum_scope,
                    ) = capture_scoped_residual::<ROOT_SCOPE>(&correlation, ordinal)?;
                    return Ok(G41Q29EvolveReport {
                        threads: 0,
                        balance_weight: BALANCE_WEIGHT,
                        roots_examined: 1,
                        restarts_per_root: self.restarts,
                        mutations_per_restart: self.mutations,
                        mutations: evaluated,
                        q29_character_hits: 1,
                        full_paf_hits: u32::from(full),
                        best_residual: 0,
                        best_correlation: correlation,
                        best_selection: Some(selected),
                        residual_motifs,
                        residual_motif_count,
                        residual_motif_overflow_roots: 0,
                        nonzero_residual_sum_roots,
                        nonzero_residual_sum_scope,
                        first_q29_root: Some(ordinal.0),
                        first_q29_selection: Some(selected),
                        first_full_root: full.then_some(ordinal.0),
                        first_full_selection: full.then_some(selected),
                        provenance: "discovery-only q29 evolution; misses have no authority; every q29 hit is replayed against all original PAF equations",
                    });
                }
            }
        }
        let best_coefficients = compile_coefficients(witness, &self.inventory, &best_selection);
        let (_, best_correlation) = correlations(&best_coefficients);
        if q29_residual(&best_correlation) != best {
            return Err(G41Q29EvolveError::SemanticMismatch);
        }
        let (
            residual_motifs,
            residual_motif_count,
            nonzero_residual_sum_roots,
            nonzero_residual_sum_scope,
        ) = capture_scoped_residual::<ROOT_SCOPE>(&best_correlation, ordinal)?;
        Ok(G41Q29EvolveReport {
            threads: 0,
            balance_weight: BALANCE_WEIGHT,
            roots_examined: 1,
            restarts_per_root: self.restarts,
            mutations_per_restart: self.mutations,
            mutations: evaluated,
            q29_character_hits: 0,
            full_paf_hits: 0,
            best_residual: best,
            best_correlation,
            best_selection: Some(G41Q29Selection {
                root_id: witness.root_id,
                digits: witness.digits,
                orbit_masks: best_selection,
            }),
            residual_motifs,
            residual_motif_count,
            residual_motif_overflow_roots: 0,
            nonzero_residual_sum_roots,
            nonzero_residual_sum_scope,
            first_q29_root: None,
            first_q29_selection: None,
            first_full_root: None,
            first_full_selection: None,
            provenance: "discovery-only q29 evolution; misses have no authority; every q29 hit is replayed against all original PAF equations",
        })
    }
}

fn merge_reports(
    left: Result<G41Q29EvolveReport, G41Q29EvolveError>,
    right: Result<G41Q29EvolveReport, G41Q29EvolveError>,
) -> Result<G41Q29EvolveReport, G41Q29EvolveError> {
    let mut left = left?;
    let right = right?;
    if left.balance_weight != right.balance_weight {
        return Err(G41Q29EvolveError::SemanticMismatch);
    }
    left.roots_examined += right.roots_examined;
    left.mutations += right.mutations;
    left.q29_character_hits += right.q29_character_hits;
    left.full_paf_hits += right.full_paf_hits;
    left.nonzero_residual_sum_roots = left
        .nonzero_residual_sum_roots
        .checked_add(right.nonzero_residual_sum_roots)
        .ok_or(G41Q29EvolveError::StateBudget)?;
    for (left_word, right_word) in left
        .nonzero_residual_sum_scope
        .iter_mut()
        .zip(right.nonzero_residual_sum_scope)
    {
        *left_word |= right_word;
    }
    left.residual_motif_overflow_roots = left
        .residual_motif_overflow_roots
        .checked_add(right.residual_motif_overflow_roots)
        .ok_or(G41Q29EvolveError::StateBudget)?;
    for motif in right.residual_motifs[..usize::from(right.residual_motif_count)]
        .iter()
        .copied()
    {
        merge_residual_motif(&mut left, motif)?;
    }
    if right.best_residual < left.best_residual {
        left.best_residual = right.best_residual;
        left.best_correlation = right.best_correlation;
        left.best_selection = right.best_selection;
    }
    if right.first_q29_root.is_some()
        && (left.first_q29_root.is_none() || right.first_q29_root < left.first_q29_root)
    {
        left.first_q29_root = right.first_q29_root;
        left.first_q29_selection = right.first_q29_selection;
    }
    if right.first_full_root.is_some()
        && (left.first_full_root.is_none() || right.first_full_root < left.first_full_root)
    {
        left.first_full_root = right.first_full_root;
        left.first_full_selection = right.first_full_selection;
    }
    Ok(left)
}

pub fn evolve_g41_q29(
    threads: usize,
    restarts: u16,
    mutations: u32,
) -> Result<G41Q29EvolveReport, G41Q29EvolveError> {
    evolve_g41_q29_weighted(threads, restarts, mutations, 0)
}

pub fn evolve_g41_q29_weighted(
    threads: usize,
    restarts: u16,
    mutations: u32,
    balance_weight: u8,
) -> Result<G41Q29EvolveReport, G41Q29EvolveError> {
    match balance_weight {
        0 => evolve_g41_q29_impl::<0>(threads, restarts, mutations),
        1 => evolve_g41_q29_impl::<1>(threads, restarts, mutations),
        2 => evolve_g41_q29_impl::<2>(threads, restarts, mutations),
        4 => evolve_g41_q29_impl::<4>(threads, restarts, mutations),
        _ => Err(G41Q29EvolveError::UnsupportedBalanceWeight(balance_weight)),
    }
}

fn evolve_g41_q29_impl<const BALANCE_WEIGHT: u8>(
    threads: usize,
    restarts: u16,
    mutations: u32,
) -> Result<G41Q29EvolveReport, G41Q29EvolveError> {
    if threads == 0 || threads > 16 || restarts == 0 || mutations == 0 {
        return Err(G41Q29EvolveError::StateBudget);
    }
    let quotient = census_g41_joint_full_mitm()?;
    let kernel = Q29Kernel::<BALANCE_WEIGHT, true> {
        inventory: compile_inventory()?,
        restarts,
        mutations,
        seed: None,
    };
    let mut report = reduce_roots(
        &kernel,
        &quotient.witnesses,
        threads,
        || {
            Ok(G41Q29EvolveReport {
                threads: 0,
                balance_weight: BALANCE_WEIGHT,
                roots_examined: 0,
                restarts_per_root: restarts,
                mutations_per_restart: mutations,
                mutations: 0,
                q29_character_hits: 0,
                full_paf_hits: 0,
                best_residual: u64::MAX,
                best_correlation: [0; 29],
                best_selection: None,
                residual_motifs: [G41Q29ResidualMotif::default(); 16],
                residual_motif_count: 0,
                residual_motif_overflow_roots: 0,
                nonzero_residual_sum_roots: 0,
                nonzero_residual_sum_scope: [0; 12],
                first_q29_root: None,
                first_q29_selection: None,
                first_full_root: None,
                first_full_selection: None,
                provenance: "discovery-only q29 evolution; misses have no authority; every q29 hit is replayed against all original PAF equations",
            })
        },
        merge_reports,
    )
    .map_err(|_| G41Q29EvolveError::ParallelExecution)??;
    report.threads = threads as u16;
    let scoped = report
        .nonzero_residual_sum_scope
        .iter()
        .map(|word| word.count_ones())
        .sum::<u32>();
    if scoped != report.nonzero_residual_sum_roots {
        return Err(G41Q29EvolveError::SemanticMismatch);
    }
    Ok(report)
}

pub fn evolve_g41_q29_all_digit_interfaces(
    threads: usize,
    restarts: u16,
    mutations: u32,
    balance_weight: u8,
) -> Result<G41Q29AllDigitEvolveReport, G41Q29EvolveError> {
    match balance_weight {
        0 => evolve_g41_q29_all_digit_interfaces_impl::<0>(threads, restarts, mutations),
        1 => evolve_g41_q29_all_digit_interfaces_impl::<1>(threads, restarts, mutations),
        2 => evolve_g41_q29_all_digit_interfaces_impl::<2>(threads, restarts, mutations),
        4 => evolve_g41_q29_all_digit_interfaces_impl::<4>(threads, restarts, mutations),
        _ => Err(G41Q29EvolveError::UnsupportedBalanceWeight(balance_weight)),
    }
}

fn evolve_g41_q29_all_digit_interfaces_impl<const BALANCE_WEIGHT: u8>(
    threads: usize,
    restarts: u16,
    mutations: u32,
) -> Result<G41Q29AllDigitEvolveReport, G41Q29EvolveError> {
    let interfaces = enumerate_g41_joint_digit_witnesses()?;
    evolve_g41_q29_all_digit_interfaces_from_report_impl::<BALANCE_WEIGHT>(
        &interfaces,
        threads,
        restarts,
        mutations,
    )
}

pub fn evolve_g41_q29_all_digit_interfaces_from_report(
    interfaces: &G41JointDigitWitnessReport,
    threads: usize,
    restarts: u16,
    mutations: u32,
    balance_weight: u8,
) -> Result<G41Q29AllDigitEvolveReport, G41Q29EvolveError> {
    match balance_weight {
        0 => evolve_g41_q29_all_digit_interfaces_from_report_impl::<0>(
            interfaces, threads, restarts, mutations,
        ),
        1 => evolve_g41_q29_all_digit_interfaces_from_report_impl::<1>(
            interfaces, threads, restarts, mutations,
        ),
        2 => evolve_g41_q29_all_digit_interfaces_from_report_impl::<2>(
            interfaces, threads, restarts, mutations,
        ),
        4 => evolve_g41_q29_all_digit_interfaces_from_report_impl::<4>(
            interfaces, threads, restarts, mutations,
        ),
        _ => Err(G41Q29EvolveError::UnsupportedBalanceWeight(balance_weight)),
    }
}

fn evolve_g41_q29_all_digit_interfaces_from_report_impl<const BALANCE_WEIGHT: u8>(
    interfaces: &G41JointDigitWitnessReport,
    threads: usize,
    restarts: u16,
    mutations: u32,
) -> Result<G41Q29AllDigitEvolveReport, G41Q29EvolveError> {
    if threads == 0 || threads > 16 || restarts == 0 {
        return Err(G41Q29EvolveError::StateBudget);
    }
    if interfaces.roots_examined != 768
        || interfaces.digit_witnesses != interfaces.witnesses.len() as u64
        || interfaces.root_offsets.len() != 769
    {
        return Err(G41Q29EvolveError::SemanticMismatch);
    }
    let kernel = Q29Kernel::<BALANCE_WEIGHT, false> {
        inventory: compile_inventory()?,
        restarts,
        mutations,
        seed: None,
    };
    let report = reduce_roots(
        &kernel,
        &interfaces.witnesses,
        threads,
        || {
            Ok(G41Q29EvolveReport {
                threads: 0,
                balance_weight: BALANCE_WEIGHT,
                roots_examined: 0,
                restarts_per_root: restarts,
                mutations_per_restart: mutations,
                mutations: 0,
                q29_character_hits: 0,
                full_paf_hits: 0,
                best_residual: u64::MAX,
                best_correlation: [0; 29],
                best_selection: None,
                residual_motifs: [G41Q29ResidualMotif::default(); 16],
                residual_motif_count: 0,
                residual_motif_overflow_roots: 0,
                nonzero_residual_sum_roots: 0,
                nonzero_residual_sum_scope: [0; 12],
                first_q29_root: None,
                first_q29_selection: None,
                first_full_root: None,
                first_full_selection: None,
                provenance: "discovery-only all-digit q29 evolution; misses have no authority; every q29 hit is replayed against all original PAF equations",
            })
        },
        merge_reports,
    )
    .map_err(|_| G41Q29EvolveError::ParallelExecution)??;
    if u64::from(report.roots_examined) != interfaces.digit_witnesses
        || report.nonzero_residual_sum_roots != 0
        || report.nonzero_residual_sum_scope != [0; 12]
    {
        return Err(G41Q29EvolveError::SemanticMismatch);
    }
    let best_residual_motif = if report.best_selection.is_some() {
        Some(mine_q29_residual_motif(&report.best_correlation)?)
    } else {
        None
    };
    Ok(G41Q29AllDigitEvolveReport {
        threads: threads as u16,
        balance_weight: BALANCE_WEIGHT,
        roots_covered: interfaces.roots_examined,
        interfaces_examined: interfaces.digit_witnesses,
        minimum_root_interfaces: interfaces.minimum_root_witnesses,
        maximum_root_interfaces: interfaces.maximum_root_witnesses,
        restarts_per_interface: restarts,
        mutations_per_restart: mutations,
        mutations: report.mutations,
        q29_character_hits: report.q29_character_hits,
        full_paf_hits: report.full_paf_hits,
        best_residual: report.best_residual,
        best_correlation: report.best_correlation,
        best_selection: report.best_selection,
        best_residual_motif,
        first_q29_interface: report.first_q29_root,
        first_q29_selection: report.first_q29_selection,
        first_full_interface: report.first_full_root,
        first_full_selection: report.first_full_selection,
        provenance: "discovery-only exhaustive common-quotient digit-interface coverage followed by bounded q29 evolution; misses have no authority; every positive is bound to its exact digit interface and directly replays all original PAF equations",
    })
}

pub fn evolve_g41_q29_seeded(
    seed: G41Q29Selection,
    restarts: u16,
    mutations: u32,
) -> Result<G41Q29EvolveReport, G41Q29EvolveError> {
    if restarts == 0 || mutations == 0 {
        return Err(G41Q29EvolveError::StateBudget);
    }
    let quotient = census_g41_joint_full_mitm()?;
    let witness = quotient
        .witnesses
        .iter()
        .find(|witness| witness.root_id == seed.root_id && witness.digits == seed.digits)
        .ok_or(G41Q29EvolveError::SemanticMismatch)?;
    let kernel = Q29Kernel::<0, true> {
        inventory: compile_inventory()?,
        restarts,
        mutations,
        seed: Some(seed),
    };
    let mut worker = Q29Worker;
    let mut report = kernel.evaluate(&mut worker, RootOrdinal(seed.root_id), witness)?;
    report.threads = 1;
    Ok(report)
}

pub fn census_g41_q29_seed_mod2() -> Result<G41Q29SeedMod2Report, G41Q29EvolveError> {
    let quotient = census_g41_joint_full_mitm()?;
    let inventory = compile_inventory()?;
    let mut feasible = Vec::with_capacity(quotient.witnesses.len());
    for witness in &quotient.witnesses {
        if seed_witness_mod2_feasible(witness, &inventory)? {
            feasible.push(witness.root_id);
        }
    }
    Ok(G41Q29SeedMod2Report {
        roots_examined: quotient.witnesses.len() as u32,
        feasible_seed_witnesses: feasible.len() as u32,
        infeasible_seed_witnesses: (quotient.witnesses.len() - feasible.len()) as u32,
        feasible_root_ids: feasible.into_boxed_slice(),
        provenance: "exact mod-2 order-29 image of one retained quotient witness per root; infeasible seeds do not exclude roots",
    })
}

pub fn census_g41_q29_structural_parity() -> Result<G41Q29StructuralParityReport, G41Q29EvolveError>
{
    let quotient = census_g41_joint_full_mitm()?;
    let inventory = compile_inventory()?;
    let form = q29_binary_profile_form()?;
    if form.diagonal != 0xfe || form.mixed_upper.iter().any(|&row| row != 0) {
        return Err(G41Q29EvolveError::SemanticMismatch);
    }
    let mut incompatible = Vec::with_capacity(quotient.witnesses.len());
    for witness in &quotient.witnesses {
        if witness_nonzero_class_parity(witness, &inventory)? != 0 {
            incompatible.push(witness.root_id);
        }
    }
    Ok(G41Q29StructuralParityReport {
        roots_examined: quotient.witnesses.len() as u32,
        compatible_seed_witnesses: (quotient.witnesses.len() - incompatible.len()) as u32,
        incompatible_seed_witnesses: incompatible.len() as u32,
        incompatible_root_ids: incompatible.into_boxed_slice(),
        synthesized_diagonal: form.diagonal,
        provenance: "proved binary quadratic identity on canonical q29 orbit classes, then exact parity derivation for one retained quotient witness per root; incompatible witnesses are impossible, but roots retain no exclusion authority until every quotient witness is covered",
    })
}

pub fn scout_g41_q29_two_swap(
    root_id: u32,
    selection: [u16; 24],
) -> Result<G41Q29TwoSwapReport, G41Q29EvolveError> {
    let quotient = census_g41_joint_full_mitm()?;
    let witness = quotient
        .witnesses
        .iter()
        .find(|witness| witness.root_id == root_id)
        .ok_or(G41Q29EvolveError::SemanticMismatch)?;
    let inventory = compile_inventory()?;
    for block in 0..4 {
        let counts = digit_counts(witness.digits[block]);
        for slot in 0..SLOTS {
            let mask = selection[block * SLOTS + slot];
            if mask >> inventory.large_len[slot] != 0
                || mask.count_ones() != u32::from(counts[slot])
            {
                return Err(G41Q29EvolveError::SemanticMismatch);
            }
        }
    }
    let base_coefficients = compile_coefficients(witness, &inventory, &selection);
    let (_, base_correlation) = correlations(&base_coefficients);
    let base_residual = q29_residual(&base_correlation);
    let mut best_residual = base_residual;
    let mut best_selection = selection;
    let mut swaps = Vec::with_capacity(2_048);
    for index in 0..24 {
        let slot = index % SLOTS;
        let mask = selection[index];
        for removed in 0..inventory.large_len[slot] {
            if mask & (1 << removed) == 0 {
                continue;
            }
            for added in 0..inventory.large_len[slot] {
                if mask & (1 << added) != 0 {
                    continue;
                }
                if swaps.len() == swaps.capacity() {
                    return Err(G41Q29EvolveError::StateBudget);
                }
                swaps.push(OrbitSwap {
                    index: index as u8,
                    removed,
                    added,
                    reserved: 0,
                });
            }
        }
    }
    let evaluate = |candidate: &[u16; 24]| {
        let coefficients = compile_coefficients(witness, &inventory, candidate);
        let (_, correlation) = correlations(&coefficients);
        q29_residual(&correlation)
    };
    for swap in &swaps {
        let mut candidate = selection;
        candidate[usize::from(swap.index)] ^= (1 << swap.removed) | (1 << swap.added);
        let residual = evaluate(&candidate);
        if residual < best_residual {
            best_residual = residual;
            best_selection = candidate;
        }
    }
    let mut double_evaluations = 0_u64;
    'pairs: for first in 0..swaps.len() {
        for second in first + 1..swaps.len() {
            let mut candidate = selection;
            for swap in [swaps[first], swaps[second]] {
                candidate[usize::from(swap.index)] ^= (1 << swap.removed) | (1 << swap.added);
            }
            if (0..24).any(|index| candidate[index].count_ones() != selection[index].count_ones()) {
                continue;
            }
            double_evaluations += 1;
            let residual = evaluate(&candidate);
            if residual < best_residual {
                best_residual = residual;
                best_selection = candidate;
                if residual == 0 {
                    break 'pairs;
                }
            }
        }
    }
    let q29_character_hit = best_residual == 0;
    let full_paf_hit =
        q29_character_hit && direct_full_replay(witness, &inventory, &best_selection);
    Ok(G41Q29TwoSwapReport {
        root_id,
        base_residual,
        best_residual,
        legal_single_swaps: swaps.len() as u32,
        single_evaluations: swaps.len() as u64,
        double_evaluations,
        q29_character_hit,
        full_paf_hit,
        best_selection: G41Q29Selection {
            root_id,
            digits: witness.digits,
            orbit_masks: best_selection,
        },
        provenance: "exact radius-two orbit-swap neighborhood; misses have no global authority; q29 hits replay every original PAF equation",
    })
}

pub fn scout_g41_q29_seed_mod4(root_id: u32) -> Result<G41Q29SeedMod4Report, G41Q29EvolveError> {
    const STATES: usize = 1 << 16;
    let quotient = census_g41_joint_full_mitm()?;
    let witness = quotient
        .witnesses
        .iter()
        .find(|witness| witness.root_id == root_id)
        .ok_or(G41Q29EvolveError::SemanticMismatch)?;
    let inventory = compile_inventory()?;
    let mut profiles: [Vec<Mod4Choice>; 4] = std::array::from_fn(|_| Vec::new());
    for (block, output) in profiles.iter_mut().enumerate() {
        *output = compile_block_mod4_profiles(witness, &inventory, block)?;
    }
    let profile_counts = std::array::from_fn(|block| profiles[block].len() as u32);
    let mut left_witness = vec![u32::MAX; STATES];
    let mut left_states = 0_usize;
    'left: for (first_index, first) in profiles[0].iter().enumerate() {
        for (second_index, second) in profiles[1].iter().enumerate() {
            let state = add_states_mod4(first.state, second.state);
            if left_witness[usize::from(state)] == u32::MAX {
                left_witness[usize::from(state)] =
                    first_index as u32 | ((second_index as u32) << 16);
                left_states += 1;
                if left_states == STATES {
                    break 'left;
                }
            }
        }
    }
    let mut matched = None;
    'right: for (third_index, third) in profiles[2].iter().enumerate() {
        for (fourth_index, fourth) in profiles[3].iter().enumerate() {
            let state = add_states_mod4(third.state, fourth.state);
            let packed = left_witness[usize::from(complement_state_mod4(state))];
            if packed != u32::MAX {
                matched = Some((
                    packed as u16 as usize,
                    (packed >> 16) as u16 as usize,
                    third_index,
                    fourth_index,
                ));
                break 'right;
            }
        }
    }
    let Some(indices) = matched else {
        return Ok(G41Q29SeedMod4Report {
            root_id,
            block_correlation_profiles: profile_counts,
            mod4_feasible: false,
            exact_residual: None,
            full_paf_hit: false,
            selection: None,
            provenance: "exact mod-4 order-29 image of one retained quotient witness; infeasibility does not exclude the root",
        });
    };
    let mut selection = [0_u16; 24];
    for (block, index) in [indices.0, indices.1, indices.2, indices.3]
        .into_iter()
        .enumerate()
    {
        selection[block * SLOTS..(block + 1) * SLOTS]
            .copy_from_slice(&profiles[block][index].orbit_masks);
    }
    let coefficients = compile_coefficients(witness, &inventory, &selection);
    let (_, correlation) = correlations(&coefficients);
    let exact_residual = q29_residual(&correlation);
    let full_paf_hit = exact_residual == 0 && direct_full_replay(witness, &inventory, &selection);
    Ok(G41Q29SeedMod4Report {
        root_id,
        block_correlation_profiles: profile_counts,
        mod4_feasible: true,
        exact_residual: Some(exact_residual),
        full_paf_hit,
        selection: Some(G41Q29Selection {
            root_id,
            digits: witness.digits,
            orbit_masks: selection,
        }),
        provenance: "exact mod-4 order-29 image of one retained quotient witness; modular hits are not full positives and are directly rescored",
    })
}

struct PowerSeedOutcome {
    block_correlation_profiles: [u32; 4],
    feasible: bool,
    representative_exact_residual: Option<u64>,
    full_paf_hit: bool,
    selection: Option<G41Q29Selection>,
}

fn scout_g41_q29_seed_power(root_id: u32, bits: u8) -> Result<PowerSeedOutcome, G41Q29EvolveError> {
    if bits == 0 || bits > 4 {
        return Err(G41Q29EvolveError::SemanticMismatch);
    }
    let quotient = census_g41_joint_full_mitm()?;
    let witness = quotient
        .witnesses
        .iter()
        .find(|witness| witness.root_id == root_id)
        .ok_or(G41Q29EvolveError::SemanticMismatch)?;
    let inventory = compile_inventory()?;
    let mut workspace = Mod8Workspace::new();
    let mut profiles: [Vec<Mod8Choice>; 4] = std::array::from_fn(|_| Vec::new());
    for (block, output) in profiles.iter_mut().enumerate() {
        *output = compile_block_power_profiles(witness, &inventory, block, &mut workspace, bits)?;
    }
    let profile_counts = std::array::from_fn(|block| profiles[block].len() as u32);
    workspace.reset();
    for (first_index, first) in profiles[0].iter().enumerate() {
        for (second_index, second) in profiles[1].iter().enumerate() {
            let state = add_states_power(first.state, second.state, bits);
            let packed = first_index as u64 | ((second_index as u64) << 32);
            // This table deliberately retains only the first preimage of each
            // modular state.  Consequently the later exact rescore is a seed
            // diagnostic, never a minimum (or bound) over the state's fibre.
            workspace
                .insert_with_value(state, packed)
                .map_err(|error| match error {
                    G41Q29EvolveError::StateBudget => G41Q29EvolveError::PowerStateBudget {
                        bits,
                        block: 4,
                        slot: 0,
                        phase: "left-pair-image",
                        states: workspace.touched.len() as u32,
                    },
                    other => other,
                })?;
        }
    }
    let mut matched = None;
    'right: for (third_index, third) in profiles[2].iter().enumerate() {
        for (fourth_index, fourth) in profiles[3].iter().enumerate() {
            let state = add_states_power(third.state, fourth.state, bits);
            if let Some(packed) = workspace.get(complement_state_power(state, bits)) {
                matched = Some((
                    packed as u32 as usize,
                    (packed >> 32) as u32 as usize,
                    third_index,
                    fourth_index,
                ));
                break 'right;
            }
        }
    }
    workspace.reset();
    let Some(indices) = matched else {
        return Ok(PowerSeedOutcome {
            block_correlation_profiles: profile_counts,
            feasible: false,
            representative_exact_residual: None,
            full_paf_hit: false,
            selection: None,
        });
    };
    let mut selection = [0_u16; 24];
    for (block, index) in [indices.0, indices.1, indices.2, indices.3]
        .into_iter()
        .enumerate()
    {
        selection[block * SLOTS..(block + 1) * SLOTS]
            .copy_from_slice(&profiles[block][index].orbit_masks);
    }
    let coefficients = compile_coefficients(witness, &inventory, &selection);
    let (_, correlation) = correlations(&coefficients);
    let exact_residual = q29_residual(&correlation);
    let full_paf_hit = exact_residual == 0 && direct_full_replay(witness, &inventory, &selection);
    Ok(PowerSeedOutcome {
        block_correlation_profiles: profile_counts,
        feasible: true,
        representative_exact_residual: Some(exact_residual),
        full_paf_hit,
        selection: Some(G41Q29Selection {
            root_id,
            digits: witness.digits,
            orbit_masks: selection,
        }),
    })
}

pub fn scout_g41_q29_seed_mod8(root_id: u32) -> Result<G41Q29SeedMod8Report, G41Q29EvolveError> {
    let outcome = scout_g41_q29_seed_power(root_id, 3)?;
    Ok(G41Q29SeedMod8Report {
        root_id,
        block_correlation_profiles: outcome.block_correlation_profiles,
        mod8_feasible: outcome.feasible,
        representative_exact_residual: outcome.representative_exact_residual,
        full_paf_hit: outcome.full_paf_hit,
        selection: outcome.selection,
        provenance: "exact mod-8 state image of one retained quotient witness; the reported residual rescored one arbitrary retained preimage and is not a fibre minimum; modular infeasibility is root-local only, while a zero representative is directly replayed",
    })
}

pub fn scout_g41_q29_seed_mod16(root_id: u32) -> Result<G41Q29SeedMod16Report, G41Q29EvolveError> {
    let outcome = scout_g41_q29_seed_power(root_id, 4)?;
    Ok(G41Q29SeedMod16Report {
        root_id,
        block_correlation_profiles: outcome.block_correlation_profiles,
        mod16_feasible: outcome.feasible,
        representative_exact_residual: outcome.representative_exact_residual,
        full_paf_hit: outcome.full_paf_hit,
        selection: outcome.selection,
        provenance: "exact mod-16 state image of one retained quotient witness; the reported residual rescored one arbitrary retained preimage and is not a fibre minimum; modular infeasibility is root-local only, while a zero representative is directly replayed",
    })
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::allocation_test::tracked_allocations;

    #[test]
    fn inventory_has_exact_multiplier_families() {
        let inventory = compile_inventory().unwrap();
        assert_eq!(inventory.large_len, [7, 7, 14, 14, 14, 14]);
        assert!(inventory.small.iter().all(|orbit| orbit.len != 0));
    }

    #[test]
    fn structural_parity_derivation_agrees_with_direct_seed_image() {
        let witness = G41JointQuotientWitness {
            root_id: 3_759_256,
            masks: [24, 50, 21, 14],
            digits: [2_217_246, 1_958_432, 1_958_307, 1_972_636],
        };
        let inventory = compile_inventory().unwrap();
        let small = std::array::from_fn::<_, SLOTS, _>(|slot| {
            orbit_nonzero_class_parity(&inventory.small[slot]).unwrap()
        });
        let large = std::array::from_fn::<_, SLOTS, _>(|slot| {
            orbit_nonzero_class_parity(&inventory.large[slot][0]).unwrap()
        });
        assert_eq!(small, [0; SLOTS]);
        assert_eq!(large, [1; SLOTS]);
        let structural = witness_nonzero_class_parity(&witness, &inventory).unwrap();
        let mut observed = None;
        for block in 0..4 {
            let states = block_coefficient_states_mod2(&witness, &inventory, block).unwrap();
            let mut block_parity = None;
            for state in 0_u8..=u8::MAX {
                if has_bit(&states, state) {
                    let parity = ((state >> 1).count_ones() & 1) as u8;
                    assert!(block_parity.is_none() || block_parity == Some(parity));
                    block_parity = Some(parity);
                }
            }
            observed = Some(observed.unwrap_or(0) ^ block_parity.unwrap());
        }
        assert_eq!(Some(structural), observed);
    }

    #[test]
    fn q29_residual_recognizes_the_exact_affine_shape() {
        let mut correlation = [9_360_u32; 29];
        correlation[0] = 9_883;
        assert_eq!(q29_residual(&correlation), 0);
        for coordinate in Q29_COSETS[2] {
            correlation[coordinate] += 1;
        }
        for coordinate in Q29_COSETS[4] {
            correlation[coordinate] -= 1;
        }
        assert_eq!(q29_residual(&correlation), 8);
        assert_eq!(
            q29_residual(&correlation),
            q29_residual_direct(&correlation)
        );
    }

    #[test]
    fn balance_guidance_is_the_proved_sum_lower_bound() {
        let mut correlation = [9_360_u32; 29];
        correlation[0] = 9_879;
        let residual = q29_residual(&correlation);
        assert_eq!(q29_residual_sum(correlation[0]), 29);
        assert_eq!(q29_guided_score::<0>(&correlation, residual), residual);
        assert_eq!(
            q29_guided_score::<2>(&correlation, residual),
            residual + 2 * 4 * 29
        );
        let defects = ResidualTuple([494, 523, 523, 523, 523, 523, 523]);
        assert_eq!(q29_defect_residual(&defects), 4 * 29);
        assert_eq!(
            q29_guided_defect_score::<2>(&defects, 4 * 29),
            4 * 29 + 2 * 4 * 29
        );
    }

    #[test]
    fn unsupported_balance_weight_fails_before_compilation() {
        assert_eq!(
            evolve_g41_q29_weighted(1, 1, 1, 3),
            Err(G41Q29EvolveError::UnsupportedBalanceWeight(3))
        );
    }

    #[test]
    fn seven_tuple_residual_matches_direct_oracle_without_allocation() {
        // The digit groups spell the task and sector this fixture seed belongs to.
        #[allow(clippy::unusual_byte_groupings)]
        let mut state = 0x41_29_c1016_d00d_u64;
        let (_, allocations) = tracked_allocations(|| {
            for _ in 0..100_000 {
                state = state
                    .wrapping_mul(6_364_136_223_846_793_005)
                    .wrapping_add(1);
                let zero_delta = ((state >> 61) & 3) as i32 - 1;
                let zero_shift = 9_883_i32 + 4 * zero_delta;
                let target = zero_shift - 523;
                let required_sum = q29_residual_sum(zero_shift as u32);
                let mut partial_sum = 0_i32;
                let mut correlation = [target as u32; 29];
                correlation[0] = zero_shift as u32;
                for coset in &Q29_COSETS[..6] {
                    state = state
                        .wrapping_mul(6_364_136_223_846_793_005)
                        .wrapping_add(1);
                    let delta = ((state >> 60) & 7) as i32 - 3;
                    partial_sum += delta;
                    for &coordinate in coset {
                        correlation[coordinate] = (target + delta) as u32;
                    }
                }
                let final_delta = required_sum - partial_sum;
                for coordinate in Q29_COSETS[6] {
                    correlation[coordinate] = (target + final_delta) as u32;
                }
                assert_eq!(
                    q29_residual(&correlation),
                    q29_residual_direct(&correlation)
                );
                assert!(q29_residual(&correlation) >= 4 * required_sum.unsigned_abs() as u64);
            }
        });
        assert_eq!(allocations, 0);
    }

    #[test]
    fn q29_defect_kernel_matches_full_correlation_without_allocation() {
        // The digit groups spell the task and sector this fixture seed belongs to.
        #[allow(clippy::unusual_byte_groupings)]
        let mut random = 0x29_41_c1016_defe_c7_u64;
        let (_, allocations) = tracked_allocations(|| {
            for _ in 0..100_000 {
                let mut coefficients = [[0_u16; 29]; 4];
                for block in &mut coefficients {
                    random = random
                        .wrapping_mul(6_364_136_223_846_793_005)
                        .wrapping_add(1);
                    block[0] = (random % 19) as u16;
                    for coset in Q29_COSETS {
                        random = random
                            .wrapping_mul(6_364_136_223_846_793_005)
                            .wrapping_add(1);
                        let value = (random % 19) as u16;
                        for coordinate in coset {
                            block[coordinate] = value;
                        }
                    }
                }
                let (block_correlations, correlation) = correlations(&coefficients);
                let block_defects: [ResidualTuple<u32, 7>; 4] =
                    std::array::from_fn(|block| block_q29_defects(&coefficients[block]));
                for block in 0..4 {
                    for class in 0..7 {
                        assert_eq!(
                            block_defects[block].0[class],
                            block_correlations[block][0]
                                - block_correlations[block][Q29_COSETS[class][0]]
                        );
                    }
                }
                let defects = total_q29_defects(&block_defects);
                let residual = q29_residual(&correlation);
                assert_eq!(q29_defect_residual(&defects), residual);
            }
        });
        assert_eq!(allocations, 0);
    }

    #[test]
    fn packed_radix_fifteen_digits_keep_the_low_bit() {
        let packed = 7 | (6 << 3) | (15 << 6) | (13 << 10) | (11 << 14) | (9 << 18);
        assert_eq!(digit_counts(packed), [7, 6, 15, 13, 11, 9]);
    }

    #[test]
    fn mod2_correlation_state_matches_direct_constant_profiles() {
        assert_eq!(correlation_state_mod2(0), 0);
        assert_eq!(correlation_state_mod2(u8::MAX), u8::MAX);
        assert_eq!(correlation_state_mod2(1), 1);
    }

    #[test]
    fn mod4_state_arithmetic_and_correlation_match_small_oracle() {
        assert_eq!(correlation_state_mod4(0), 0);
        assert_eq!(correlation_state_mod4(1), 1);
        assert_eq!(correlation_state_mod4(u16::MAX), 0x5555);
        let left = 0x1234;
        let right = complement_state_mod4(left);
        assert_eq!(add_states_mod4(left, right), 3);
    }

    #[test]
    fn mod8_state_arithmetic_and_correlation_match_small_oracle() {
        assert_eq!(correlation_state_mod8(0), 0);
        assert_eq!(correlation_state_mod8(1), 1);
        let left = 0x0054_3210;
        let right = complement_state_mod8(left);
        assert_eq!(add_states_mod8(left, right), 3);
    }

    #[test]
    fn mod16_state_arithmetic_matches_target_digits() {
        let left = 0x7654_3210;
        let right = complement_state_power(left, 4);
        assert_eq!(add_states_power(left, right, 4), 0x0000_000b);
        assert_eq!(correlation_state_power(0, 4), 0);
        assert_eq!(correlation_state_power(1, 4), 1);
    }

    #[test]
    fn q29_two_adic_lift_matches_direct_mod16_correlation() {
        let mut random = 0x8317_9ac5_d40e_62b1_u64;
        for _ in 0..4_096 {
            let mut base = 0_u32;
            let mut combined = 0_u32;
            for coordinate in 0..8 {
                let low = (next_random(&mut random) & 7) as u32;
                let high = (next_random(&mut random) & 1) as u32;
                base |= low << (3 * coordinate);
                combined |= (low | (high << 3)) << (4 * coordinate);
            }
            let lift = (0..8).fold(0_u8, |state, coordinate| {
                state | ((((combined >> (4 * coordinate)) >> 3) & 1) as u8) << coordinate
            });
            assert_eq!(
                q29_mod16_from_mod8_lift(base, lift).unwrap(),
                correlation_state_power(combined, 4)
            );
        }
    }

    #[test]
    fn q29_structural_invariants_match_exhaustive_binary_oracle() {
        let form = q29_binary_profile_form().unwrap();
        assert_eq!(form.diagonal, 0xfe);
        assert!(form.mixed_upper.iter().all(|&row| row == 0));
        for coefficients in 0_u32..256 {
            let profile = correlation_state_power(coefficients, 1);
            let nonzero_parity = (1..8).fold(0_u32, |parity, coordinate| {
                parity ^ ((profile >> coordinate) & 1)
            });
            assert_eq!(form.evaluate(u64::from(coefficients)), nonzero_parity as u8);
        }
    }

    #[test]
    fn q29_weighted_profile_identity_matches_row_sum() {
        let mut random = 0xb426_f793_18cd_50ae_u64;
        for _ in 0..65_536 {
            let coefficients = next_random(&mut random) as u32;
            let profile = correlation_state_power(coefficients, 4);
            let mut row_sum = coefficients & 15;
            for coordinate in 1..8 {
                row_sum += 4 * ((coefficients >> (4 * coordinate)) & 15);
            }
            assert_eq!(
                q29_profile_structural_invariants(profile)[0],
                autocorrelation_total_from_row_sum(u64::from(row_sum), 4).unwrap()
            );
        }
    }

    #[test]
    fn two_adic_fibre_addition_matches_direct_packed_addition() {
        let mut random = 0x104d_e873_91b2_c5a7_u64;
        for _ in 0..8_192 {
            let left = next_random(&mut random) as u32;
            let right = next_random(&mut random) as u32;
            let (left_low, left_lift) = split_mod16_coefficient_state(left);
            let (right_low, right_lift) = split_mod16_coefficient_state(right);
            let (sum_low, carry) = add_mod8_low_states(left_low, right_low);
            let sum_lift = left_lift ^ right_lift ^ carry;
            let mut reconstructed = 0_u32;
            for coordinate in 0..8 {
                let low = (sum_low >> (3 * coordinate)) & 7;
                let high = u32::from((sum_lift >> coordinate) & 1);
                reconstructed |= (low | (high << 3)) << (4 * coordinate);
            }
            assert_eq!(reconstructed, add_states_power(left, right, 4));
        }
    }

    #[test]
    fn xor_sumset_bitset_matches_pairwise_oracle() {
        let mut left = [0_u64; 4];
        let mut right = [0_u64; 4];
        for value in [0_u8, 3, 64, 129, 255] {
            left[usize::from(value >> 6)] |= 1_u64 << (value & 63);
        }
        for value in [1_u8, 7, 65, 200] {
            right[usize::from(value >> 6)] |= 1_u64 << (value & 63);
        }
        let mut actual = [0_u64; 4];
        xor_sumset_256_into(&mut actual, &left, &right, 91);
        let mut expected = [0_u64; 4];
        for left_value in [0_u8, 3, 64, 129, 255] {
            for right_value in [1_u8, 7, 65, 200] {
                let value = left_value ^ right_value ^ 91;
                expected[usize::from(value >> 6)] |= 1_u64 << (value & 63);
            }
        }
        assert_eq!(actual, expected);
    }

    #[test]
    fn xor_sumset_hot_kernel_allocates_nothing() {
        let left = [0x8040_2010_0804_0201_u64; 4];
        let right = [0x0102_0408_1020_4080_u64; 4];
        let mut output = [0_u64; 4];
        let (_, allocations) = tracked_allocations(|| {
            for carry in 0_u8..=255 {
                output.fill(0);
                xor_sumset_256_into(&mut output, &left, &right, carry);
                std::hint::black_box(output);
            }
        });
        assert_eq!(allocations, 0);
    }

    #[test]
    fn additive_affine_analyzer_accepts_coset_and_rejects_puncture() {
        let base = 0x1234_5678;
        let mut profiles = Vec::with_capacity(256);
        for first in 0..16 {
            for second in 0..16 {
                profiles.push(add_states_power(base, first | (second << 4), 4));
            }
        }
        let affine = analyze_additive_affine_image(&profiles).unwrap();
        assert!(affine.is_affine);
        assert_eq!(affine.generator_count, 2);
        profiles.pop();
        let punctured = analyze_additive_affine_image(&profiles).unwrap();
        assert!(!punctured.is_affine);
    }

    #[test]
    fn q29_mutation_kernel_allocates_nothing() {
        let witness = G41JointQuotientWitness {
            root_id: 3_759_256,
            masks: [24, 50, 21, 14],
            digits: [2_217_246, 1_958_432, 1_958_307, 1_972_636],
        };
        let kernel = Q29Kernel::<0, true> {
            inventory: compile_inventory().unwrap(),
            restarts: 2,
            mutations: 1_024,
            seed: None,
        };
        let mut worker = Q29Worker;
        let (_, allocations) = tracked_allocations(|| {
            for ordinal in 0..8 {
                std::hint::black_box(
                    kernel
                        .evaluate(&mut worker, RootOrdinal(ordinal), &witness)
                        .unwrap(),
                );
            }
        });
        assert_eq!(allocations, 0);
    }

    #[test]
    fn all_digit_kernel_binds_digits_and_skips_root_scope_without_allocation() {
        let witness = G41JointQuotientWitness {
            root_id: 3_759_256,
            masks: [24, 50, 21, 14],
            digits: [2_217_246, 1_958_432, 1_958_307, 1_972_636],
        };
        let kernel = Q29Kernel::<2, false> {
            inventory: compile_inventory().unwrap(),
            restarts: 1,
            mutations: 8,
            seed: None,
        };
        let mut worker = Q29Worker;
        let (report, allocations) = tracked_allocations(|| {
            kernel
                .evaluate(&mut worker, RootOrdinal(1_000_000), &witness)
                .unwrap()
        });
        assert_eq!(allocations, 0);
        assert_eq!(report.best_selection.unwrap().digits, witness.digits);
        assert_eq!(report.nonzero_residual_sum_roots, 0);
        assert_eq!(report.nonzero_residual_sum_scope, [0; 12]);
        assert_eq!(report.residual_motif_count, 0);
    }

    #[test]
    fn zero_slot_two_adic_prefix_is_the_complete_fixed_small_part() {
        let witness = G41JointQuotientWitness {
            root_id: 3_759_256,
            masks: [24, 50, 21, 14],
            digits: [2_217_246, 1_958_432, 1_958_307, 1_972_636],
        };
        let inventory = compile_inventory().unwrap();
        let mut workspace = LiftFibreWorkspace::new();
        let (fibres, _, _) =
            compile_block_two_adic_fibres(&witness, &inventory, 0, 0, &mut workspace).unwrap();
        assert_eq!(fibres.len(), 1);
        assert_eq!(fibres[0].cardinality(), 1);
        let mut expected = 0_u32;
        for slot in 0..SLOTS {
            if witness.masks[0] & (1 << slot) != 0 {
                expected = add_states_power(
                    expected,
                    orbit_coefficient_state_power(&inventory.small[slot], 4).unwrap(),
                    4,
                );
            }
        }
        let (low, lift) = split_mod16_coefficient_state(expected);
        assert_eq!(fibres[0].low_state, low);
        assert_ne!(
            fibres[0].lift_bits[usize::from(lift >> 6)] & (1_u64 << (lift & 63)),
            0
        );
    }

    #[test]
    fn joint_sampler_rejects_unbounded_budget_before_compilation() {
        assert_eq!(
            scout_g41_q29_two_adic_joint_with_samples(0, (1 << 24) + 1),
            Err(G41Q29EvolveError::StateBudget)
        );
    }

    #[test]
    fn three_distinct_block_join_is_exact_and_allocation_free() {
        let base_blocks = [ResidualTuple([100_u32; 7]); 4];
        let base_total = ResidualTuple([400_u32; 7]);
        let moves = [
            [Q29SingleMove {
                defects: [141; 7],
                block: 0,
                ..Q29SingleMove::default()
            }],
            [Q29SingleMove {
                defects: [141; 7],
                block: 1,
                ..Q29SingleMove::default()
            }],
            [Q29SingleMove {
                defects: [141; 7],
                block: 2,
                ..Q29SingleMove::default()
            }],
        ];
        let (_, allocations) = tracked_allocations(|| {
            for _ in 0..10_000 {
                let result = scan_three_move_lists(
                    &base_total,
                    &base_blocks,
                    [0, 1, 2],
                    [&moves[0], &moves[1], &moves[2]],
                );
                assert_eq!(result, (0, 1, Some([0, 0, 0])));
            }
        });
        assert_eq!(allocations, 0);
    }

    #[test]
    fn four_block_pair_join_is_exact_and_allocation_free() {
        let moves = [
            [Q29SingleMove {
                defects: [130; 7],
                block: 0,
                ..Q29SingleMove::default()
            }],
            [Q29SingleMove {
                defects: [130; 7],
                block: 1,
                ..Q29SingleMove::default()
            }],
            [Q29SingleMove {
                defects: [130; 7],
                block: 2,
                ..Q29SingleMove::default()
            }],
            [Q29SingleMove {
                defects: [133; 7],
                block: 3,
                ..Q29SingleMove::default()
            }],
        ];
        let mut workspace = [Q29PairDefect::default(); 4];
        let (result, allocations) = tracked_allocations(|| {
            find_four_move_hit([&moves[0], &moves[1], &moves[2], &moves[3]], &mut workspace)
        });
        assert_eq!(allocations, 0);
        assert_eq!(result, (Some([0, 0, 0, 0]), 1, 1));
    }

    #[test]
    fn recomputed_double_plus_two_single_join_is_allocation_free() {
        let doubles = [Q29DoubleMove {
            defects: [200; 7],
            ..Q29DoubleMove::default()
        }];
        let first = [Q29SingleMove {
            defects: [150; 7],
            ..Q29SingleMove::default()
        }];
        let second = [Q29SingleMove {
            defects: [100; 7],
            ..Q29SingleMove::default()
        }];
        let omitted = ResidualTuple([73; 7]);
        let mut workspace = [Q29PairDefect::default(); 4];
        let (result, allocations) = tracked_allocations(|| {
            find_double_two_single_hit(&doubles, &first, &second, &omitted, &mut workspace)
        });
        assert_eq!(allocations, 0);
        assert_eq!(result, (Some((0, 0, 0)), 1, 1));
    }

    #[test]
    fn two_recomputed_double_join_is_allocation_free() {
        let first = [Q29DoubleMove {
            defects: [200; 7],
            ..Q29DoubleMove::default()
        }];
        let second = [Q29DoubleMove {
            defects: [150; 7],
            ..Q29DoubleMove::default()
        }];
        let fixed = [ResidualTuple([100; 7]), ResidualTuple([73; 7])];
        let mut workspace = [Q29DoubleDefectKey::default(); 4];
        let (result, allocations) = tracked_allocations(|| {
            find_two_double_hit(&first, &second, [&fixed[0], &fixed[1]], &mut workspace)
        });
        assert_eq!(allocations, 0);
        assert_eq!(result, (Some((0, 0)), 1, 1));
    }

    #[test]
    fn recomputed_double_and_three_single_join_is_allocation_free() {
        let doubles = [Q29DoubleMove {
            defects: [200; 7],
            ..Q29DoubleMove::default()
        }];
        let remaining = [Q29SingleMove {
            defects: [100; 7],
            ..Q29SingleMove::default()
        }];
        let first = [Q29SingleMove {
            defects: [100; 7],
            ..Q29SingleMove::default()
        }];
        let second = [Q29SingleMove {
            defects: [123; 7],
            ..Q29SingleMove::default()
        }];
        let mut workspace = [Q29PairDefect::default(); 4];
        let (result, allocations) = tracked_allocations(|| {
            find_double_single_two_single_hit(&doubles, &remaining, &first, &second, &mut workspace)
        });
        assert_eq!(allocations, 0);
        assert_eq!(result, (Some((0, 0, 0, 0)), 1, 1));
    }

    #[test]
    fn two_double_single_fixed_join_is_allocation_free() {
        let first = [Q29DoubleMove {
            defects: [200; 7],
            ..Q29DoubleMove::default()
        }];
        let second = [Q29DoubleMove {
            defects: [150; 7],
            ..Q29DoubleMove::default()
        }];
        let single = [Q29SingleMove {
            defects: [100; 7],
            ..Q29SingleMove::default()
        }];
        let fixed = ResidualTuple([73; 7]);
        let mut workspace = [Q29DoubleDefectKey::default(); 4];
        let (result, allocations) = tracked_allocations(|| {
            find_two_double_single_hit(&first, &second, &single, &fixed, &mut workspace)
        });
        assert_eq!(allocations, 0);
        assert_eq!(result, (Some((0, 0, 0)), 1, 1));
    }

    #[test]
    fn recomputed_triple_other_join_is_allocation_free() {
        let triples = [Q29TripleMove {
            defects: [300; 7],
            ..Q29TripleMove::default()
        }];
        let mut records = [Q29OtherDefectKey {
            values: [123; 7],
            first: 7,
            second: 9,
            _pad: [0; 14],
        }];
        let (result, allocations) =
            tracked_allocations(|| find_triple_other_hit(&triples, [100; 7], &mut records, 1));
        assert_eq!(allocations, 0);
        assert_eq!(result, (Some((0, 7, 9)), 1));
    }

    #[test]
    fn batched_same_block_recomputation_loop_allocates_nothing() {
        let witness = G41JointQuotientWitness {
            root_id: 3_759_256,
            masks: [24, 50, 21, 14],
            digits: [2_217_246, 1_958_432, 1_958_307, 1_972_636],
        };
        let inventory = compile_inventory().unwrap();
        let mut random = 17;
        let seed = G41Q29Selection {
            root_id: witness.root_id,
            digits: witness.digits,
            orbit_masks: initialize_selection(&witness, &inventory, &mut random),
        };
        let (_, allocations) = tracked_allocations(|| {
            std::hint::black_box(
                evolve_seeded_batch_const::<4>(&witness, &inventory, seed, 1, 128).unwrap(),
            );
        });
        assert_eq!(allocations, 0);
    }

    #[test]
    fn q174_sparse_swap_matches_full_recomputation() {
        let witness = G41JointQuotientWitness {
            root_id: 3_759_256,
            masks: [24, 50, 21, 14],
            digits: [2_217_246, 1_958_432, 1_958_307, 1_972_636],
        };
        let inventory = compile_inventory().unwrap();
        let mut random = 41;
        let mut selection = initialize_selection(&witness, &inventory, &mut random);
        let mut coefficients = block_q174_coefficients(&witness, &inventory, &selection, 0);
        let mut defects = block_q174_defects(&coefficients);
        for _ in 0..512 {
            let mut slot = next_random(&mut random) as usize % SLOTS;
            while selection[slot] == 0
                || selection[slot].count_ones() == u32::from(inventory.large_len[slot])
            {
                slot = (slot + 1) % SLOTS;
            }
            let old_mask = selection[slot];
            let removed = (0..inventory.large_len[slot])
                .find(|&orbit| old_mask & (1 << orbit) != 0)
                .unwrap();
            let added = (0..inventory.large_len[slot])
                .find(|&orbit| old_mask & (1 << orbit) == 0)
                .unwrap();
            let removed_orbit = &inventory.large[slot][usize::from(removed)];
            let added_orbit = &inventory.large[slot][usize::from(added)];
            let sparse = q174_swap_defects(&coefficients, &defects, removed_orbit, added_orbit);
            subtract_orbit_q174(&mut coefficients, removed_orbit);
            add_orbit_q174(&mut coefficients, added_orbit);
            assert_eq!(sparse, block_q174_defects(&coefficients));
            selection[slot] ^= (1 << removed) | (1 << added);
            defects = sparse;
        }
    }

    #[test]
    fn q174_sparse_swap_allocates_nothing() {
        let inventory = compile_inventory().unwrap();
        let coefficients = [1_u8; 174];
        let defects = block_q174_defects(&coefficients);
        let (_, allocations) = tracked_allocations(|| {
            for _ in 0..1_024 {
                std::hint::black_box(q174_swap_defects(
                    &coefficients,
                    &defects,
                    &inventory.large[0][0],
                    &inventory.large[0][1],
                ));
            }
        });
        assert_eq!(allocations, 0);
    }
}
