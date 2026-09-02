//! Exact joint q58/q87 profile census through the common q174 refinement.

use serde::Serialize;
use sha2::{Digest, Sha256};
use thiserror::Error;

use crate::feature_synthesis::ResidualTuple;
use crate::g41_q29_evolve::{
    compile_inventory, digit_counts, FineInventory, FineOrbit, G41Q29EvolveError, Q29_COSETS,
};

const MODULUS: usize = 174;
const CLASSES: usize = 46;
const Q58_MODULUS: usize = 58;
const Q58_CLASSES: usize = 16;
const Q87_MODULUS: usize = 87;
const TARGET_Q87_DEFECT: u16 = 523;
pub const G41_Q174_Q87_DEFECT_SHIFTS: [usize; 3] = [4, 6, 33];
pub const G41_Q174_Q87_SCOPED_DEFECTS: usize = G41_Q174_Q87_DEFECT_SHIFTS.len();
const SLOTS: usize = 6;
const COORDINATES: usize = 8;
const LANE_BITS: u32 = 2;
const STATE_BITS: u32 = (CLASSES as u32) * LANE_BITS;
const STATE_MASK: u128 = (1_u128 << STATE_BITS) - 1;
const MAX_SIDE_STATES: usize = 1 << 24;

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
struct KeyedState {
    key: u64,
    state_low: u64,
    state_high: u64,
    q58_state: u64,
    q87_low: u64,
    q87_high: u64,
}

const _: () = assert!(std::mem::size_of::<KeyedState>() == 48);

impl KeyedState {
    #[inline(always)]
    fn new(key: u64, state: u128, q58_state: u64, q87_state: u128) -> Self {
        Self {
            key,
            state_low: state as u64,
            state_high: (state >> 64) as u64,
            q58_state,
            q87_low: q87_state as u64,
            q87_high: (q87_state >> 64) as u64,
        }
    }

    #[inline(always)]
    fn state(self) -> u128 {
        u128::from(self.state_low) | (u128::from(self.state_high) << 64)
    }

    #[inline(always)]
    fn q87_state(self) -> u128 {
        u128::from(self.q87_low) | (u128::from(self.q87_high) << 64)
    }
}

#[repr(C)]
#[derive(Clone, Copy)]
struct HotState {
    state_low: u64,
    state_high: u64,
    q58_state: u64,
    q87_low: u64,
    q87_high: u64,
}

const _: () = assert!(std::mem::size_of::<HotState>() == 40);

impl HotState {
    fn new(state: u128, q58_state: u64, q87_state: u128) -> Self {
        Self {
            state_low: state as u64,
            state_high: (state >> 64) as u64,
            q58_state,
            q87_low: q87_state as u64,
            q87_high: (q87_state >> 64) as u64,
        }
    }

    #[inline(always)]
    fn state(self) -> u128 {
        u128::from(self.state_low) | (u128::from(self.state_high) << 64)
    }

    #[inline(always)]
    fn q87_state(self) -> u128 {
        u128::from(self.q87_low) | (u128::from(self.q87_high) << 64)
    }
}

#[derive(Clone, Debug, Error, PartialEq, Eq)]
pub enum G41Q174JointError {
    #[error("g41 q174 joint semantics are invalid")]
    SemanticMismatch,
    #[error("g41 q174 joint side {side} stage {stage} retained more than {states} states")]
    StateBudget { side: u8, stage: u8, states: u64 },
    #[error("g41 q174 joint profile budget was exceeded")]
    ProfileBudget,
    #[error(transparent)]
    Evolve(#[from] G41Q29EvolveError),
}

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
pub struct G41Q174JointProfile {
    pub q58_energy: u16,
    pub q58_residuals: ResidualTuple<i16, 7>,
    pub q87_energy: u16,
    pub q87_defects: [u16; G41_Q174_Q87_SCOPED_DEFECTS],
}

impl Default for G41Q174JointProfile {
    fn default() -> Self {
        Self {
            q58_energy: 0,
            q58_residuals: ResidualTuple::from_array([0; 7]),
            q87_energy: 0,
            q87_defects: [0; G41_Q174_Q87_SCOPED_DEFECTS],
        }
    }
}

const _: () = assert!(std::mem::size_of::<G41Q174JointProfile>() == 24);

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q174JointReport {
    pub mask: u8,
    pub digits: u32,
    pub q29_coefficients: [u8; COORDINATES],
    pub q87_defect_shifts: [usize; G41_Q174_Q87_SCOPED_DEFECTS],
    pub orbit_classes: u8,
    pub slot_states: [u32; SLOTS],
    pub left_slots: [u8; 3],
    pub right_slots: [u8; 3],
    pub partition_attempts: Vec<G41Q174PartitionAttempt>,
    pub left_states: u32,
    pub right_states: u32,
    pub pairs_visited: u64,
    pub q87_energy_pair_survivors: u64,
    pub exact_q58_coefficient_states: u32,
    pub q58_profile_pair_survivors: u64,
    pub exact_joint_profiles: u32,
    pub joint_profile_digest: [u8; 32],
    pub workspace_bytes: u64,
    pub provenance: &'static str,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q174PartitionAttempt {
    pub left_slots: [u8; 3],
    pub right_slots: [u8; 3],
    pub maximum_raw_product: u64,
    pub left_states: Option<u32>,
    pub right_states: Option<u32>,
    pub failed_side: Option<u8>,
    pub failed_stage: Option<u8>,
    pub failure_states: Option<u64>,
}

pub struct G41Q174JointTablebase {
    pub report: G41Q174JointReport,
    pub profiles: Box<[G41Q174JointProfile]>,
    representative_states: Box<[u128]>,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q174AllocationWitnessReport {
    pub mask: u8,
    pub digits: u32,
    pub target_state: u128,
    pub q58_class_coefficients: [u8; Q58_CLASSES],
    pub left_slots: [u8; 3],
    pub right_slots: [u8; 3],
    pub orbit_masks: Option<[u16; SLOTS]>,
    pub provenance: &'static str,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q174Q87ReplayReport {
    pub combined_nonzero_defects: Vec<u16>,
    pub all_nonzero_defects_equal_523: bool,
    pub provenance: &'static str,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q174TargetFibreReport {
    pub target_profiles: u16,
    pub states_by_target: Vec<Box<[u128]>>,
    pub pairs_visited: u64,
    pub q87_target_pairs: u64,
    pub matching_pairs: u64,
    pub unique_states: u64,
    pub maximum_states: u64,
    pub workspace_bytes: u64,
    pub provenance: &'static str,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
struct TargetState {
    target: u8,
    state_high: u64,
    state_low: u64,
}

const _: () = assert!(std::mem::size_of::<TargetState>() == 24);

impl TargetState {
    #[inline(always)]
    fn new(target: usize, state: u128) -> Self {
        Self {
            target: target as u8,
            state_high: (state >> 64) as u64,
            state_low: state as u64,
        }
    }

    #[inline(always)]
    fn state(self) -> u128 {
        u128::from(self.state_low) | (u128::from(self.state_high) << 64)
    }
}

pub fn replay_g41_q174_q87_defects(
    states: [u128; 4],
) -> Result<G41Q174Q87ReplayReport, G41Q174JointError> {
    if states.into_iter().any(|state| state & !STATE_MASK != 0) {
        return Err(G41Q174JointError::SemanticMismatch);
    }
    let layout = compile_layout()?;
    let defects: [[u16; 43]; 4] = std::array::from_fn(|block| {
        q87_defect_vector(&layout, states[block]).expect("packed state was validated")
    });
    let combined_nonzero_defects: [u16; 43] =
        std::array::from_fn(|shift| defects.iter().map(|block| block[shift]).sum::<u16>());
    Ok(G41Q174Q87ReplayReport {
        all_nonzero_defects_equal_523: combined_nonzero_defects
            .into_iter()
            .all(|defect| defect == 523),
        combined_nonzero_defects: combined_nonzero_defects.to_vec(),
        provenance: "independent direct q87 coefficient expansion from four packed q174 states followed by all 43 conjugacy-reduced nonzero cyclic correlations; no scoped feature extractor is reused",
    })
}

fn q87_defect_vector(layout: &Layout, state: u128) -> Result<[u16; 43], G41Q174JointError> {
    let coefficients: [i32; Q87_MODULUS] = std::array::from_fn(|residue| {
        i32::from(residue_coefficient(layout, state, residue))
            + i32::from(residue_coefficient(layout, state, residue + Q87_MODULUS))
    });
    let zero: i32 = coefficients.iter().map(|value| value * value).sum();
    let mut defects = [0_u16; 43];
    for shift in 1..=43 {
        let correlation: i32 = (0..Q87_MODULUS)
            .map(|residue| coefficients[residue] * coefficients[(residue + shift) % Q87_MODULUS])
            .sum();
        defects[shift - 1] = (zero - correlation)
            .try_into()
            .map_err(|_| G41Q174JointError::SemanticMismatch)?;
    }
    Ok(defects)
}

pub fn g41_q174_q87_defect_vector(state: u128) -> Result<[u16; 43], G41Q174JointError> {
    if state & !STATE_MASK != 0 {
        return Err(G41Q174JointError::SemanticMismatch);
    }
    q87_defect_vector(&compile_layout()?, state)
}

pub fn compile_g41_q174_target_fibres(
    mask: u8,
    digits: u32,
    q29_coefficients: [u8; COORDINATES],
    targets: &[G41Q174JointProfile],
    maximum_states: usize,
) -> Result<G41Q174TargetFibreReport, G41Q174JointError> {
    type Q58Cache = Q58ProfileCache<{ 1 << 20 }>;
    if targets.is_empty()
        || targets.len() > u8::MAX as usize
        || maximum_states == 0
        || mask >= 64
        || q29_coefficients.iter().any(|&value| value > 18)
        || !targets.windows(2).all(|pair| pair[0] < pair[1])
    {
        return Err(G41Q174JointError::SemanticMismatch);
    }
    let layout = compile_layout()?;
    let q58_layout = compile_q58_layout()?;
    let q87_layout = compile_q87_layout()?;
    let inventory = compile_inventory()?;
    let counts = digit_counts(digits);
    if (0..SLOTS).any(|slot| counts[slot] > inventory.large_len[slot]) {
        return Err(G41Q174JointError::SemanticMismatch);
    }
    let contributions = [
        slot_states(&layout, &inventory, 0, mask, counts[0])?,
        slot_states(&layout, &inventory, 1, mask, counts[1])?,
        slot_states(&layout, &inventory, 2, mask, counts[2])?,
        slot_states(&layout, &inventory, 3, mask, counts[3])?,
        slot_states(&layout, &inventory, 4, mask, counts[4])?,
        slot_states(&layout, &inventory, 5, mask, counts[5])?,
    ];
    let cardinalities = contributions.each_ref().map(|values| values.len() as u32);
    let (_left_slots, _right_slots, left, right, _partition_attempts) = compile_partitioned_sides(
        &layout,
        contributions.each_ref().map(|values| values.as_slice()),
        cardinalities,
        q29_coefficients,
        6,
    )?;
    let mut hot_left = Vec::with_capacity(left.len());
    for state in left {
        hot_left.push(HotState::new(
            state,
            q58_state(&layout, &q58_layout, state),
            q87_state(&layout, state),
        ));
    }
    let mut keyed_right = Vec::with_capacity(right.len());
    for state in right {
        let key = pack_projection(projection(&layout, state))
            .ok_or(G41Q174JointError::SemanticMismatch)?;
        keyed_right.push(KeyedState::new(
            key,
            state,
            q58_state(&layout, &q58_layout, state),
            q87_state(&layout, state),
        ));
    }
    keyed_right.sort_unstable();
    let q29_defects = quotient_defects(q29_coefficients);
    let mut q87_targets: Vec<(u16, [u16; G41_Q174_Q87_SCOPED_DEFECTS])> = targets
        .iter()
        .map(|target| (target.q87_energy, target.q87_defects))
        .collect();
    q87_targets.sort_unstable();
    q87_targets.dedup();
    let mut q58_cache = Q58Cache::new();
    let mut states = Vec::with_capacity(maximum_states);
    let mut pairs_visited = 0_u64;
    let mut q87_target_pairs = 0_u64;
    let mut matching_pairs = 0_u64;
    for &left_state in &hot_left {
        let Some(key) = complement_key(&layout, left_state.state(), q29_coefficients) else {
            continue;
        };
        let start = keyed_right.partition_point(|entry| entry.key < key);
        let end = keyed_right.partition_point(|entry| entry.key <= key);
        for &entry in &keyed_right[start..end] {
            pairs_visited += 1;
            let combined_q87 = add_states(left_state.q87_state(), entry.q87_state());
            let q87_energy = q87_energy(combined_q87);
            if q87_energy > TARGET_Q87_DEFECT {
                continue;
            }
            let Some(q87_defects) = q87_defects(&q87_layout, combined_q87) else {
                continue;
            };
            if q87_targets
                .binary_search(&(q87_energy, q87_defects))
                .is_err()
            {
                continue;
            }
            q87_target_pairs += 1;
            let q58_state = left_state.q58_state + entry.q58_state;
            let Some(q58_terms) = q58_cache.get_or_compile(q58_state, &q58_layout, q29_defects)?
            else {
                continue;
            };
            let profile = G41Q174JointProfile {
                q58_energy: q58_terms.energy,
                q58_residuals: q58_terms.residuals,
                q87_energy,
                q87_defects,
            };
            let Ok(target) = targets.binary_search(&profile) else {
                continue;
            };
            matching_pairs += 1;
            if states.len() == states.capacity() {
                return Err(G41Q174JointError::ProfileBudget);
            }
            states.push(TargetState::new(
                target,
                add_states(left_state.state(), entry.state() & STATE_MASK),
            ));
        }
    }
    states.sort_unstable();
    states.dedup();
    let unique_states = states.len() as u64;
    let mut states_by_target: Vec<Vec<u128>> = (0..targets.len()).map(|_| Vec::new()).collect();
    for state in states {
        states_by_target[usize::from(state.target)].push(state.state());
    }
    Ok(G41Q174TargetFibreReport {
        target_profiles: targets.len() as u16,
        states_by_target: states_by_target
            .into_iter()
            .map(Vec::into_boxed_slice)
            .collect(),
        pairs_visited,
        q87_target_pairs,
        matching_pairs,
        unique_states,
        maximum_states: maximum_states as u64,
        workspace_bytes: contributions
            .iter()
            .map(|values| values.capacity() as u64 * std::mem::size_of::<u128>() as u64)
            .sum::<u64>()
            + hot_left.capacity() as u64 * std::mem::size_of::<HotState>() as u64
            + keyed_right.capacity() as u64 * std::mem::size_of::<KeyedState>() as u64
            + Q58Cache::bytes()
            + maximum_states as u64 * std::mem::size_of::<TargetState>() as u64,
        provenance: "exact bounded target-fibre lift; the canonical six-slot q174 MITM is replayed once, a precompiled exact target-q87 key rejects irrelevant pairs before q58 extraction, and all packed q174 states matching one of the sorted full target profiles are retained and deduplicated; absence is authoritative only for these bound target profiles",
    })
}

impl G41Q174JointTablebase {
    pub fn representative_state(&self, profile: usize) -> Option<u128> {
        self.representative_states.get(profile).copied()
    }
}

#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
struct SlotChoice {
    state: u128,
    orbit_mask: u16,
}

struct Layout {
    class_of: [u8; MODULUS],
    representatives: [u8; CLASSES],
}

struct Q58Layout {
    class_of: [u8; Q58_MODULUS],
    representatives: [u8; Q58_CLASSES],
}

struct Q87Layout {
    lane_weights: [u8; 24],
    terms: [[Q87Term; Q87_MODULUS]; G41_Q174_Q87_SCOPED_DEFECTS],
    term_lengths: [u8; G41_Q174_Q87_SCOPED_DEFECTS],
}

#[derive(Clone, Copy, Debug, Default)]
struct Q87Term {
    first: u8,
    second: u8,
    weight: u8,
}

fn compile_layout() -> Result<Layout, G41Q174JointError> {
    let mut class_of = [u8::MAX; MODULUS];
    let mut representatives = [0_u8; CLASSES];
    let mut classes = 0_usize;
    for residue in 0..MODULUS {
        if class_of[residue] != u8::MAX {
            continue;
        }
        if classes == CLASSES {
            return Err(G41Q174JointError::SemanticMismatch);
        }
        representatives[classes] = residue as u8;
        let mut point = residue;
        loop {
            if class_of[point] != u8::MAX && class_of[point] != classes as u8 {
                return Err(G41Q174JointError::SemanticMismatch);
            }
            class_of[point] = classes as u8;
            point = point * 41 % MODULUS;
            if point == residue {
                break;
            }
        }
        classes += 1;
    }
    if classes != CLASSES {
        return Err(G41Q174JointError::SemanticMismatch);
    }
    Ok(Layout {
        class_of,
        representatives,
    })
}

fn compile_q58_layout() -> Result<Q58Layout, G41Q174JointError> {
    let mut class_of = [u8::MAX; Q58_MODULUS];
    let mut representatives = [0_u8; Q58_CLASSES];
    let mut classes = 0_usize;
    for residue in 0..Q58_MODULUS {
        if class_of[residue] != u8::MAX {
            continue;
        }
        if classes == Q58_CLASSES {
            return Err(G41Q174JointError::SemanticMismatch);
        }
        representatives[classes] = residue as u8;
        let mut point = residue;
        loop {
            class_of[point] = classes as u8;
            point = point * 41 % Q58_MODULUS;
            if point == residue {
                break;
            }
        }
        classes += 1;
    }
    if classes != Q58_CLASSES {
        return Err(G41Q174JointError::SemanticMismatch);
    }
    Ok(Q58Layout {
        class_of,
        representatives,
    })
}

fn compile_q87_layout() -> Result<Q87Layout, G41Q174JointError> {
    let mut scoped_classes = G41_Q174_Q87_DEFECT_SHIFTS.map(canonical_q87_shift_class);
    scoped_classes.sort_unstable();
    if scoped_classes.windows(2).any(|pair| pair[0] == pair[1]) {
        return Err(G41Q174JointError::SemanticMismatch);
    }
    let mut lane_of = [u8::MAX; Q87_MODULUS];
    for coordinate in 0..COORDINATES {
        let residue = if coordinate == 0 {
            0
        } else {
            Q29_COSETS[coordinate - 1][0]
        };
        for lift in 0..3 {
            let lane = (3 * coordinate + lift) as u8;
            let representative = residue + 29 * lift;
            if lane_of[representative] != u8::MAX {
                continue;
            }
            let mut point = representative;
            loop {
                if lane_of[point] != u8::MAX && lane_of[point] != lane {
                    return Err(G41Q174JointError::SemanticMismatch);
                }
                lane_of[point] = lane;
                point = point * 41 % Q87_MODULUS;
                if point == representative {
                    break;
                }
            }
        }
    }
    if lane_of.iter().any(|&lane| lane == u8::MAX) {
        return Err(G41Q174JointError::SemanticMismatch);
    }
    let mut lane_weights = [0_u8; 24];
    for &lane in &lane_of {
        lane_weights[usize::from(lane)] += 1;
    }
    let mut terms = [[Q87Term::default(); Q87_MODULUS]; G41_Q174_Q87_SCOPED_DEFECTS];
    let mut term_lengths = [0_u8; G41_Q174_Q87_SCOPED_DEFECTS];
    for (coordinate, &shift) in G41_Q174_Q87_DEFECT_SHIFTS.iter().enumerate() {
        let mut weights = [[0_u8; 24]; 24];
        for residue in 0..Q87_MODULUS {
            let first = usize::from(lane_of[residue]);
            let second = usize::from(lane_of[(residue + shift) % Q87_MODULUS]);
            let (first, second) = if first <= second {
                (first, second)
            } else {
                (second, first)
            };
            weights[first][second] += 1;
        }
        for first in 0..24 {
            for second in first..24 {
                if weights[first][second] != 0 {
                    let index = usize::from(term_lengths[coordinate]);
                    terms[coordinate][index] = Q87Term {
                        first: first as u8,
                        second: second as u8,
                        weight: weights[first][second],
                    };
                    term_lengths[coordinate] += 1;
                }
            }
        }
    }
    Ok(Q87Layout {
        lane_weights,
        terms,
        term_lengths,
    })
}

fn canonical_q87_shift_class(shift: usize) -> usize {
    let mut point = shift;
    let mut minimum = shift.min(Q87_MODULUS - shift);
    loop {
        point = point * 41 % Q87_MODULUS;
        minimum = minimum.min(point.min(Q87_MODULUS - point));
        if point == shift {
            return minimum;
        }
    }
}

#[inline(always)]
const fn coefficient(state: u128, class: usize) -> u8 {
    ((state >> (LANE_BITS * class as u32)) & 3) as u8
}

#[inline(always)]
fn add_states(left: u128, right: u128) -> u128 {
    left + right
}

#[inline(always)]
fn state_complement(state: u128, target: u128) -> Option<u128> {
    let mut complement = 0_u128;
    for class in 0..CLASSES {
        let value = coefficient(target, class).checked_sub(coefficient(state, class))?;
        complement |= u128::from(value) << (LANE_BITS * class as u32);
    }
    Some(complement)
}

#[inline(always)]
fn state_sum_within(first: u128, second: u128, target: u128) -> Option<u128> {
    let mut sum = 0_u128;
    for class in 0..CLASSES {
        let value = coefficient(first, class) + coefficient(second, class);
        if value > coefficient(target, class) {
            return None;
        }
        sum |= u128::from(value) << (LANE_BITS * class as u32);
    }
    Some(sum)
}

fn orbit_state(layout: &Layout, orbit: &FineOrbit) -> Result<u128, G41Q174JointError> {
    let mut state = 0_u128;
    for class in 0..CLASSES {
        let representative = usize::from(layout.representatives[class]);
        let value = orbit.points[..usize::from(orbit.len)]
            .iter()
            .filter(|&&point| usize::from(point) % MODULUS == representative)
            .count() as u8;
        if value > 3 {
            return Err(G41Q174JointError::SemanticMismatch);
        }
        for residue in 0..MODULUS {
            if usize::from(layout.class_of[residue]) == class
                && orbit.points[..usize::from(orbit.len)]
                    .iter()
                    .filter(|&&point| usize::from(point) % MODULUS == residue)
                    .count() as u8
                    != value
            {
                return Err(G41Q174JointError::SemanticMismatch);
            }
        }
        state |= u128::from(value) << (LANE_BITS * class as u32);
    }
    Ok(state)
}

#[inline(always)]
fn residue_coefficient(layout: &Layout, state: u128, residue: usize) -> u8 {
    coefficient(state, usize::from(layout.class_of[residue]))
}

fn projection(layout: &Layout, state: u128) -> [u8; COORDINATES] {
    std::array::from_fn(|coordinate| {
        let residue = if coordinate == 0 {
            0
        } else {
            Q29_COSETS[coordinate - 1][0]
        };
        (0..6)
            .map(|lift| residue_coefficient(layout, state, residue + 29 * lift))
            .sum()
    })
}

#[inline(always)]
fn projection_within(layout: &Layout, state: u128, target: [u8; COORDINATES]) -> bool {
    projection(layout, state)
        .into_iter()
        .zip(target)
        .all(|(value, target)| value <= target)
}

fn pack_projection(values: [u8; COORDINATES]) -> Option<u64> {
    let mut packed = 0_u64;
    for value in values {
        if value > 31 {
            return None;
        }
        packed = (packed << 5) | u64::from(value);
    }
    Some(packed)
}

fn complement_key(layout: &Layout, state: u128, target: [u8; COORDINATES]) -> Option<u64> {
    let values = projection(layout, state);
    let mut complement = [0_u8; COORDINATES];
    for coordinate in 0..COORDINATES {
        complement[coordinate] = target[coordinate].checked_sub(values[coordinate])?;
    }
    pack_projection(complement)
}

fn slot_states(
    layout: &Layout,
    inventory: &FineInventory,
    slot: usize,
    mask: u8,
    count: u8,
) -> Result<Vec<u128>, G41Q174JointError> {
    let initial = if mask & (1 << slot) != 0 {
        orbit_state(layout, &inventory.small[slot])?
    } else {
        0
    };
    let length = inventory.large_len[slot];
    let mut large_states = [0_u128; 14];
    for orbit in 0..length {
        large_states[usize::from(orbit)] =
            orbit_state(layout, &inventory.large[slot][usize::from(orbit)])?;
    }
    let mut states = Vec::with_capacity(1_usize << length);
    for subset in 0_u16..1_u16 << length {
        if subset.count_ones() != u32::from(count) {
            continue;
        }
        let mut state = initial;
        for orbit in 0..length {
            if subset & (1 << orbit) != 0 {
                state = add_states(state, large_states[usize::from(orbit)]);
            }
        }
        states.push(state);
    }
    states.sort_unstable();
    states.dedup();
    Ok(states)
}

fn slot_choices(
    layout: &Layout,
    inventory: &FineInventory,
    slot: usize,
    mask: u8,
    count: u8,
) -> Result<Vec<SlotChoice>, G41Q174JointError> {
    let initial = if mask & (1 << slot) != 0 {
        orbit_state(layout, &inventory.small[slot])?
    } else {
        0
    };
    let length = inventory.large_len[slot];
    let mut large_states = [0_u128; 14];
    for orbit in 0..length {
        large_states[usize::from(orbit)] =
            orbit_state(layout, &inventory.large[slot][usize::from(orbit)])?;
    }
    let mut choices = Vec::with_capacity(1_usize << length);
    for subset in 0_u16..1_u16 << length {
        if subset.count_ones() != u32::from(count) {
            continue;
        }
        let mut state = initial;
        for orbit in 0..length {
            if subset & (1 << orbit) != 0 {
                state = add_states(state, large_states[usize::from(orbit)]);
            }
        }
        choices.push(SlotChoice {
            state,
            orbit_mask: subset,
        });
    }
    choices.sort_unstable();
    choices.dedup_by_key(|choice| choice.state);
    Ok(choices)
}

fn compile_partitioned_sides(
    layout: &Layout,
    contributions: [&[u128]; SLOTS],
    cardinalities: [u32; SLOTS],
    target: [u8; COORDINATES],
    side_base: u8,
) -> Result<
    (
        [usize; 3],
        [usize; 3],
        Vec<u128>,
        Vec<u128>,
        Vec<G41Q174PartitionAttempt>,
    ),
    G41Q174JointError,
> {
    compile_partitioned_sides_with_limit(
        layout,
        contributions,
        cardinalities,
        target,
        side_base,
        MAX_SIDE_STATES,
    )
}

fn compile_partitioned_sides_with_limit(
    layout: &Layout,
    contributions: [&[u128]; SLOTS],
    cardinalities: [u32; SLOTS],
    target: [u8; COORDINATES],
    side_base: u8,
    maximum_states: usize,
) -> Result<
    (
        [usize; 3],
        [usize; 3],
        Vec<u128>,
        Vec<u128>,
        Vec<G41Q174PartitionAttempt>,
    ),
    G41Q174JointError,
> {
    let mut candidates = [([0_usize; 3], [0_usize; 3], u128::MAX); 10];
    let mut candidate = 0_usize;
    for second in 1..SLOTS - 1 {
        for third in second + 1..SLOTS {
            let mut left = [0, second, third];
            let mut right = [0_usize; 3];
            let mut cursor = 0;
            for slot in 0..SLOTS {
                if !left.contains(&slot) {
                    right[cursor] = slot;
                    cursor += 1;
                }
            }
            left.sort_unstable_by_key(|&slot| cardinalities[slot]);
            right.sort_unstable_by_key(|&slot| cardinalities[slot]);
            let score = [left, right]
                .map(|slots| {
                    slots
                        .into_iter()
                        .map(|slot| u128::from(cardinalities[slot]))
                        .product::<u128>()
                })
                .into_iter()
                .max()
                .unwrap_or(u128::MAX);
            candidates[candidate] = (left, right, score);
            candidate += 1;
        }
    }
    candidates.sort_unstable_by_key(|&(left, right, score)| (score, left, right));
    let mut last_budget = None;
    let mut attempts = Vec::with_capacity(candidates.len());
    for (left_slots, right_slots, score) in candidates {
        let maximum_raw_product = score
            .try_into()
            .map_err(|_| G41Q174JointError::StateBudget {
                side: side_base,
                stage: 0,
                states: u64::MAX,
            })?;
        let left = match compile_side(
            layout,
            left_slots.map(|slot| contributions[slot]),
            target,
            side_base,
            maximum_states,
        ) {
            Ok(states) => states,
            Err(
                error @ G41Q174JointError::StateBudget {
                    side,
                    stage,
                    states,
                },
            ) => {
                attempts.push(G41Q174PartitionAttempt {
                    left_slots: left_slots.map(|slot| slot as u8),
                    right_slots: right_slots.map(|slot| slot as u8),
                    maximum_raw_product,
                    left_states: None,
                    right_states: None,
                    failed_side: Some(side),
                    failed_stage: Some(stage),
                    failure_states: Some(states),
                });
                last_budget = Some(error);
                continue;
            }
            Err(error) => return Err(error),
        };
        let right = match compile_side(
            layout,
            right_slots.map(|slot| contributions[slot]),
            target,
            side_base + 1,
            maximum_states,
        ) {
            Ok(states) => states,
            Err(
                error @ G41Q174JointError::StateBudget {
                    side,
                    stage,
                    states,
                },
            ) => {
                attempts.push(G41Q174PartitionAttempt {
                    left_slots: left_slots.map(|slot| slot as u8),
                    right_slots: right_slots.map(|slot| slot as u8),
                    maximum_raw_product,
                    left_states: Some(left.len() as u32),
                    right_states: None,
                    failed_side: Some(side),
                    failed_stage: Some(stage),
                    failure_states: Some(states),
                });
                last_budget = Some(error);
                continue;
            }
            Err(error) => return Err(error),
        };
        attempts.push(G41Q174PartitionAttempt {
            left_slots: left_slots.map(|slot| slot as u8),
            right_slots: right_slots.map(|slot| slot as u8),
            maximum_raw_product,
            left_states: Some(left.len() as u32),
            right_states: Some(right.len() as u32),
            failed_side: None,
            failed_stage: None,
            failure_states: None,
        });
        return Ok((left_slots, right_slots, left, right, attempts));
    }
    Err(last_budget.unwrap_or(G41Q174JointError::SemanticMismatch))
}

fn compile_side(
    layout: &Layout,
    slots: [&[u128]; 3],
    target: [u8; COORDINATES],
    side: u8,
    maximum_states: usize,
) -> Result<Vec<u128>, G41Q174JointError> {
    let mut current = vec![0_u128];
    for (stage, contributions) in slots.into_iter().enumerate() {
        let raw = current
            .len()
            .checked_mul(contributions.len())
            .unwrap_or(usize::MAX);
        let mut next = Vec::with_capacity(raw.min(maximum_states));
        for &left in &current {
            for &right in contributions {
                let state = add_states(left, right);
                if projection_within(layout, state, target) {
                    if next.len() == maximum_states {
                        return Err(G41Q174JointError::StateBudget {
                            side,
                            stage: stage as u8,
                            states: maximum_states as u64 + 1,
                        });
                    }
                    next.push(state);
                }
            }
        }
        next.sort_unstable();
        next.dedup();
        current = next;
    }
    Ok(current)
}

fn quotient_defects(q29: [u8; COORDINATES]) -> [i32; 7] {
    let mut values = [0_i32; 29];
    values[0] = i32::from(q29[0]);
    for (coordinate, coset) in Q29_COSETS.iter().enumerate() {
        for &residue in coset {
            values[residue] = i32::from(q29[coordinate + 1]);
        }
    }
    let zero: i32 = values.iter().map(|&value| value * value).sum();
    std::array::from_fn(|coordinate| {
        let shift = Q29_COSETS[coordinate][0];
        zero - (0..29)
            .map(|residue| values[residue] * values[(residue + shift) % 29])
            .sum::<i32>()
    })
}

#[cfg(test)]
fn q58_coefficients(layout: &Layout, state: u128) -> [i32; 58] {
    std::array::from_fn(|residue| {
        (0..3)
            .map(|lift| i32::from(residue_coefficient(layout, state, residue + 58 * lift)))
            .sum()
    })
}

#[cfg(test)]
fn q87_coefficients(layout: &Layout, state: u128) -> [i32; 87] {
    std::array::from_fn(|residue| {
        i32::from(residue_coefficient(layout, state, residue))
            + i32::from(residue_coefficient(layout, state, residue + 87))
    })
}

#[inline(always)]
fn q58_lane(state: u64, class: usize) -> i32 {
    ((state >> (4 * class)) & 15) as i32
}

#[inline(always)]
fn q58_state(layout: &Layout, q58_layout: &Q58Layout, state: u128) -> u64 {
    let mut packed = 0_u64;
    for class in 0..Q58_CLASSES {
        let residue = usize::from(q58_layout.representatives[class]);
        let value: u8 = (0..3)
            .map(|lift| residue_coefficient(layout, state, residue + 58 * lift))
            .sum();
        packed |= u64::from(value) << (4 * class);
    }
    packed
}

fn q87_state(layout: &Layout, state: u128) -> u128 {
    let mut packed = 0_u128;
    for coordinate in 0..COORDINATES {
        let residue = if coordinate == 0 {
            0
        } else {
            Q29_COSETS[coordinate - 1][0]
        };
        for lift in 0..3 {
            let value = residue_coefficient(layout, state, residue + 29 * lift)
                + residue_coefficient(layout, state, residue + 29 * lift + 87);
            packed |= u128::from(value) << (3 * (3 * coordinate + lift));
        }
    }
    packed
}

#[inline(always)]
fn q87_energy(state: u128) -> u16 {
    let mut energy = 0_i32;
    for coordinate in 0..COORDINATES {
        let values: [i32; 3] =
            std::array::from_fn(|lift| ((state >> (3 * (3 * coordinate + lift))) & 7) as i32);
        let [a, b, c] = values;
        let local = a * a + b * b + c * c - a * b - b * c - c * a;
        energy += if coordinate == 0 { local } else { 4 * local };
    }
    energy as u16
}

#[inline(always)]
fn q87_defects(layout: &Q87Layout, state: u128) -> Option<[u16; G41_Q174_Q87_SCOPED_DEFECTS]> {
    let values: [i32; 24] = std::array::from_fn(|lane| ((state >> (3 * lane)) & 7) as i32);
    let zero: i32 = values
        .iter()
        .zip(layout.lane_weights)
        .map(|(&value, weight)| i32::from(weight) * value * value)
        .sum();
    let mut defects = [0_u16; G41_Q174_Q87_SCOPED_DEFECTS];
    for coordinate in 0..G41_Q174_Q87_SCOPED_DEFECTS {
        let correlation: i32 = layout.terms[coordinate]
            [..usize::from(layout.term_lengths[coordinate])]
            .iter()
            .map(|term| {
                i32::from(term.weight)
                    * values[usize::from(term.first)]
                    * values[usize::from(term.second)]
            })
            .sum();
        defects[coordinate] = (zero - correlation).try_into().ok()?;
        if defects[coordinate] > 523 {
            return None;
        }
    }
    Some(defects)
}

fn q58_profile(
    layout: &Q58Layout,
    state: u64,
    q29_defects: [i32; 7],
) -> Option<(u16, ResidualTuple<i16, 7>)> {
    let difference: [i32; 29] = std::array::from_fn(|residue| {
        let first = q58_lane(state, usize::from(layout.class_of[residue]));
        let second = q58_lane(state, usize::from(layout.class_of[residue + 29]));
        if residue & 1 == 0 {
            first - second
        } else {
            second - first
        }
    });
    let q58_energy: i32 = difference.iter().map(|&value| value * value).sum();
    if q58_energy > 523 {
        return None;
    }
    let mut residuals = [0_i16; 7];
    for coordinate in 0..7 {
        let shift = Q29_COSETS[coordinate][0];
        let residual: i32 = (0..29)
            .map(|residue| difference[residue] * difference[(residue + shift) % 29])
            .sum();
        let first = q29_defects[coordinate] + q58_energy - residual;
        let second = q29_defects[coordinate] + q58_energy + residual;
        if first & 1 != 0
            || second & 1 != 0
            || !(0..=1046).contains(&first)
            || !(0..=1046).contains(&second)
        {
            return None;
        }
        let Ok(residual) = residual.try_into() else {
            return None;
        };
        residuals[coordinate] = residual;
    }
    Some((q58_energy as u16, ResidualTuple::from_array(residuals)))
}

struct ProfileWorkspace<const CAPACITY: usize> {
    keys: Box<[G41Q174JointProfile]>,
    states: Box<[u128]>,
    occupied: Box<[u8]>,
    touched: Vec<u32>,
}

#[derive(Clone, Copy, Debug)]
struct Q58Terms {
    energy: u16,
    residuals: ResidualTuple<i16, 7>,
}

impl Default for Q58Terms {
    fn default() -> Self {
        Self {
            energy: 0,
            residuals: ResidualTuple::from_array([0; 7]),
        }
    }
}

struct Q58ProfileCache<const CAPACITY: usize> {
    keys: Box<[u64]>,
    values: Box<[Q58Terms]>,
    status: Box<[u8]>,
    touched: Vec<u32>,
}

impl<const CAPACITY: usize> Q58ProfileCache<CAPACITY> {
    fn new() -> Self {
        assert!(CAPACITY.is_power_of_two());
        Self {
            keys: vec![0_u64; CAPACITY].into_boxed_slice(),
            values: vec![Q58Terms::default(); CAPACITY].into_boxed_slice(),
            status: vec![0_u8; CAPACITY].into_boxed_slice(),
            touched: Vec::with_capacity(3 * CAPACITY / 4),
        }
    }

    #[inline(always)]
    fn get_or_compile(
        &mut self,
        state: u64,
        layout: &Q58Layout,
        q29_defects: [i32; 7],
    ) -> Result<Option<Q58Terms>, G41Q174JointError> {
        let mut hash = state;
        hash ^= hash >> 30;
        hash = hash.wrapping_mul(0xbf58_476d_1ce4_e5b9);
        hash ^= hash >> 27;
        let mut slot = hash as usize & (CAPACITY - 1);
        loop {
            if self.status[slot] == 0 {
                if self.touched.len() == 3 * CAPACITY / 4 {
                    return Err(G41Q174JointError::ProfileBudget);
                }
                self.keys[slot] = state;
                self.touched.push(slot as u32);
                if let Some((energy, residuals)) = q58_profile(layout, state, q29_defects) {
                    self.values[slot] = Q58Terms { energy, residuals };
                    self.status[slot] = 2;
                    return Ok(Some(self.values[slot]));
                }
                self.status[slot] = 1;
                return Ok(None);
            }
            if self.keys[slot] == state {
                return Ok((self.status[slot] == 2).then_some(self.values[slot]));
            }
            slot = (slot + 1) & (CAPACITY - 1);
        }
    }

    const fn bytes() -> u64 {
        (CAPACITY
            * (std::mem::size_of::<u64>()
                + std::mem::size_of::<Q58Terms>()
                + std::mem::size_of::<u8>())
            + 3 * CAPACITY / 4 * std::mem::size_of::<u32>()) as u64
    }

    fn len(&self) -> usize {
        self.touched.len()
    }
}

impl<const CAPACITY: usize> ProfileWorkspace<CAPACITY> {
    fn new() -> Self {
        assert!(CAPACITY.is_power_of_two());
        Self {
            keys: vec![G41Q174JointProfile::default(); CAPACITY].into_boxed_slice(),
            states: vec![0_u128; CAPACITY].into_boxed_slice(),
            occupied: vec![0_u8; CAPACITY].into_boxed_slice(),
            touched: Vec::with_capacity(3 * CAPACITY / 4),
        }
    }

    #[inline(always)]
    fn insert(
        &mut self,
        profile: G41Q174JointProfile,
        state: u128,
    ) -> Result<(), G41Q174JointError> {
        let mut hash = u64::from(profile.q58_energy) ^ (u64::from(profile.q87_energy) << 32);
        for residual in profile.q58_residuals.as_array() {
            hash ^= (*residual as u16 as u64)
                .wrapping_add(hash << 6)
                .wrapping_add(hash >> 2);
        }
        for defect in profile.q87_defects {
            hash ^= u64::from(defect)
                .wrapping_add(hash << 6)
                .wrapping_add(hash >> 2);
        }
        let mut slot = hash as usize & (CAPACITY - 1);
        loop {
            if self.occupied[slot] == 0 {
                if self.touched.len() == 3 * CAPACITY / 4 {
                    return Err(G41Q174JointError::ProfileBudget);
                }
                self.occupied[slot] = 1;
                self.keys[slot] = profile;
                self.states[slot] = state;
                self.touched.push(slot as u32);
                return Ok(());
            }
            if self.keys[slot] == profile {
                self.states[slot] = self.states[slot].min(state);
                return Ok(());
            }
            slot = (slot + 1) & (CAPACITY - 1);
        }
    }

    fn into_sorted_outputs(mut self) -> (Box<[G41Q174JointProfile]>, Box<[u128]>) {
        let keys = &self.keys;
        let states = &self.states;
        self.touched.sort_unstable_by_key(|&slot| {
            let index = slot as usize;
            (keys[index], states[index])
        });
        let mut profiles = Vec::with_capacity(self.touched.len());
        let mut representative_states = Vec::with_capacity(self.touched.len());
        for slot in self.touched {
            let index = slot as usize;
            profiles.push(self.keys[index]);
            representative_states.push(self.states[index]);
        }
        (
            profiles.into_boxed_slice(),
            representative_states.into_boxed_slice(),
        )
    }

    const fn bytes() -> u64 {
        (CAPACITY
            * (std::mem::size_of::<G41Q174JointProfile>()
                + std::mem::size_of::<u128>()
                + std::mem::size_of::<u8>())
            + 3 * CAPACITY / 4 * std::mem::size_of::<u32>()) as u64
    }
}

fn reconstruct_side(
    slots: [usize; 3],
    choices: &[Vec<SlotChoice>; SLOTS],
    target: u128,
) -> Option<[u16; SLOTS]> {
    let mut orbit_masks = [0_u16; SLOTS];
    for first in &choices[slots[0]] {
        for second in &choices[slots[1]] {
            let Some(partial) = state_sum_within(first.state, second.state, target) else {
                continue;
            };
            let Some(required) = state_complement(partial, target) else {
                continue;
            };
            let Ok(position) =
                choices[slots[2]].binary_search_by_key(&required, |choice| choice.state)
            else {
                continue;
            };
            orbit_masks[slots[0]] = first.orbit_mask;
            orbit_masks[slots[1]] = second.orbit_mask;
            orbit_masks[slots[2]] = choices[slots[2]][position].orbit_mask;
            return Some(orbit_masks);
        }
    }
    None
}

pub fn find_g41_q174_allocation_witness(
    mask: u8,
    digits: u32,
    target_state: u128,
) -> Result<G41Q174AllocationWitnessReport, G41Q174JointError> {
    if mask >= 64 || target_state & !STATE_MASK != 0 {
        return Err(G41Q174JointError::SemanticMismatch);
    }
    let layout = compile_layout()?;
    let q58_layout = compile_q58_layout()?;
    let inventory = compile_inventory()?;
    let counts = digit_counts(digits);
    if (0..SLOTS).any(|slot| counts[slot] > inventory.large_len[slot]) {
        return Err(G41Q174JointError::SemanticMismatch);
    }
    let choices = [
        slot_choices(&layout, &inventory, 0, mask, counts[0])?,
        slot_choices(&layout, &inventory, 1, mask, counts[1])?,
        slot_choices(&layout, &inventory, 2, mask, counts[2])?,
        slot_choices(&layout, &inventory, 3, mask, counts[3])?,
        slot_choices(&layout, &inventory, 4, mask, counts[4])?,
        slot_choices(&layout, &inventory, 5, mask, counts[5])?,
    ];
    let cardinalities = choices.each_ref().map(|values| values.len() as u32);
    let states: [Vec<u128>; SLOTS] =
        std::array::from_fn(|slot| choices[slot].iter().map(|choice| choice.state).collect());
    let target_projection = projection(&layout, target_state);
    let (left_slots, right_slots, left_states, right_states, _partition_attempts) =
        compile_partitioned_sides(
            &layout,
            states.each_ref().map(|values| values.as_slice()),
            cardinalities,
            target_projection,
            4,
        )?;
    let mut orbit_masks = None;
    for left_state in left_states {
        let Some(required) = state_complement(left_state, target_state) else {
            continue;
        };
        if right_states.binary_search(&required).is_err() {
            continue;
        }
        let Some(mut left_masks) = reconstruct_side(left_slots, &choices, left_state) else {
            return Err(G41Q174JointError::SemanticMismatch);
        };
        let Some(right_masks) = reconstruct_side(right_slots, &choices, required) else {
            return Err(G41Q174JointError::SemanticMismatch);
        };
        for slot in right_slots {
            left_masks[slot] = right_masks[slot];
        }
        orbit_masks = Some(left_masks);
        break;
    }
    Ok(G41Q174AllocationWitnessReport {
        mask,
        digits,
        target_state,
        q58_class_coefficients: {
            let packed = q58_state(&layout, &q58_layout, target_state);
            std::array::from_fn(|class| q58_lane(packed, class) as u8)
        },
        left_slots: left_slots.map(|slot| slot as u8),
        right_slots: right_slots.map(|slot| slot as u8),
        orbit_masks,
        provenance: "independent bounded q174 target-state reconstruction; exact lane complement joins two iterative three-slot images, then two presorted two-plus-one slot joins recover canonical fine-orbit masks; no profile representative is treated as an original-space witness without this replay",
    })
}

pub fn compile_g41_q174_joint_tablebase(
    mask: u8,
    digits: u32,
    q29_coefficients: [u8; COORDINATES],
) -> Result<G41Q174JointTablebase, G41Q174JointError> {
    // Block two exceeds the 3/4 load bounds of both 2^22 and 2^23 tables
    // once the four scoped q87 coordinates are retained. Keep the hot table
    // fixed and fail-closed, but size it for the measured all-block interface.
    type Profiles = ProfileWorkspace<{ 1 << 24 }>;
    type Q58Cache = Q58ProfileCache<{ 1 << 20 }>;
    if mask >= 64 || q29_coefficients.iter().any(|&value| value > 18) {
        return Err(G41Q174JointError::SemanticMismatch);
    }
    let layout = compile_layout()?;
    let q58_layout = compile_q58_layout()?;
    let q87_layout = compile_q87_layout()?;
    let inventory = compile_inventory()?;
    let counts = digit_counts(digits);
    if (0..SLOTS).any(|slot| counts[slot] > inventory.large_len[slot]) {
        return Err(G41Q174JointError::SemanticMismatch);
    }
    let contributions = [
        slot_states(&layout, &inventory, 0, mask, counts[0])?,
        slot_states(&layout, &inventory, 1, mask, counts[1])?,
        slot_states(&layout, &inventory, 2, mask, counts[2])?,
        slot_states(&layout, &inventory, 3, mask, counts[3])?,
        slot_states(&layout, &inventory, 4, mask, counts[4])?,
        slot_states(&layout, &inventory, 5, mask, counts[5])?,
    ];
    let slot_counts = contributions.each_ref().map(|states| states.len() as u32);
    let (left_slots, right_slots, left, right, partition_attempts) = compile_partitioned_sides(
        &layout,
        contributions.each_ref().map(|values| values.as_slice()),
        slot_counts,
        q29_coefficients,
        0,
    )?;
    let mut hot_left = Vec::with_capacity(left.len());
    for state in left {
        hot_left.push(HotState::new(
            state,
            q58_state(&layout, &q58_layout, state),
            q87_state(&layout, state),
        ));
    }
    let mut keyed_right = Vec::with_capacity(right.len());
    for state in right {
        let key = pack_projection(projection(&layout, state))
            .ok_or(G41Q174JointError::SemanticMismatch)?;
        keyed_right.push(KeyedState::new(
            key,
            state,
            q58_state(&layout, &q58_layout, state),
            q87_state(&layout, state),
        ));
    }
    keyed_right.sort_unstable();
    let q29_defects = quotient_defects(q29_coefficients);
    let mut q58_cache = Q58Cache::new();
    let mut workspace = Profiles::new();
    let mut pairs_visited = 0_u64;
    let mut q87_energy_pair_survivors = 0_u64;
    let mut q58_profile_pair_survivors = 0_u64;
    for &left_state in &hot_left {
        let Some(key) = complement_key(&layout, left_state.state(), q29_coefficients) else {
            continue;
        };
        let start = keyed_right.partition_point(|entry| entry.key < key);
        let end = keyed_right.partition_point(|entry| entry.key <= key);
        for &entry in &keyed_right[start..end] {
            pairs_visited = pairs_visited
                .checked_add(1)
                .ok_or(G41Q174JointError::ProfileBudget)?;
            let combined_q87 = add_states(left_state.q87_state(), entry.q87_state());
            let q87_energy = q87_energy(combined_q87);
            if q87_energy > 523 {
                continue;
            }
            let Some(q87_defects) = q87_defects(&q87_layout, combined_q87) else {
                continue;
            };
            q87_energy_pair_survivors += 1;
            let q58_state = left_state.q58_state + entry.q58_state;
            let Some(q58_terms) = q58_cache.get_or_compile(q58_state, &q58_layout, q29_defects)?
            else {
                continue;
            };
            q58_profile_pair_survivors = q58_profile_pair_survivors
                .checked_add(1)
                .ok_or(G41Q174JointError::ProfileBudget)?;
            let state = add_states(left_state.state(), entry.state() & STATE_MASK);
            workspace.insert(
                G41Q174JointProfile {
                    q58_energy: q58_terms.energy,
                    q58_residuals: q58_terms.residuals,
                    q87_energy,
                    q87_defects,
                },
                state,
            )?;
        }
    }
    let exact_q58_coefficient_states = q58_cache.len() as u32;
    let (profiles, representative_states) = workspace.into_sorted_outputs();
    let mut hasher = Sha256::new();
    for (&profile, &state) in profiles.iter().zip(representative_states.iter()) {
        hasher.update(profile.q58_energy.to_le_bytes());
        for residual in profile.q58_residuals.as_array() {
            hasher.update(residual.to_le_bytes());
        }
        hasher.update(profile.q87_energy.to_le_bytes());
        for defect in profile.q87_defects {
            hasher.update(defect.to_le_bytes());
        }
        hasher.update(state.to_le_bytes());
    }
    Ok(G41Q174JointTablebase {
        report: G41Q174JointReport {
            mask,
            digits,
            q29_coefficients,
            q87_defect_shifts: G41_Q174_Q87_DEFECT_SHIFTS,
            orbit_classes: CLASSES as u8,
            slot_states: slot_counts,
            left_slots: left_slots.map(|slot| slot as u8),
            right_slots: right_slots.map(|slot| slot as u8),
            partition_attempts,
            left_states: hot_left.len() as u32,
            right_states: keyed_right.len() as u32,
            pairs_visited,
            q87_energy_pair_survivors,
            exact_q58_coefficient_states,
            q58_profile_pair_survivors,
            exact_joint_profiles: profiles.len() as u32,
            joint_profile_digest: hasher.finalize().into(),
            workspace_bytes: contributions
                .iter()
                .map(|states| states.capacity() as u64 * std::mem::size_of::<u128>() as u64)
                .sum::<u64>()
                + hot_left.capacity() as u64 * std::mem::size_of::<HotState>() as u64
                + keyed_right.capacity() as u64 * std::mem::size_of::<KeyedState>() as u64
                + Q58Cache::bytes()
                + Profiles::bytes()
                + profiles.len() as u64 * std::mem::size_of::<G41Q174JointProfile>() as u64
                + representative_states.len() as u64 * std::mem::size_of::<u128>() as u64,
            provenance: "exact common-refinement q174 census; 46 multiplier-orbit lanes of two bits encode all q58/q87 correlations; a bounded deterministic search over all ten three-plus-three slot partitions joins the exact q29 projection and fails closed if every partition exceeds its state budget; a fixed memo table computes q58 anti-profile once per packed q58 coefficient state, then every pair is folded directly into the broad theorem key consisting of q58 anti-profile, q87 energy, and exact q87 defect coordinates at distinct multiplier-class representatives 4,6,33; redundant shift 10 is removed and evolved shift 1 is deliberately deferred to the bounded target-fibre endgame; both fixed hash stages allocate nothing hot; the table stores one representative state only for discovery and makes no claim that it represents all full-length preimages",
        },
        profiles,
        representative_states,
    })
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::allocation_test::tracked_allocations;

    #[test]
    fn q174_multiplier_partition_has_the_expected_orbits() {
        let layout = compile_layout().unwrap();
        assert_eq!(layout.representatives[0], 0);
        assert!(layout
            .class_of
            .iter()
            .all(|&class| usize::from(class) < CLASSES));
        for residue in 0..MODULUS {
            assert_eq!(
                layout.class_of[residue],
                layout.class_of[residue * 41 % MODULUS]
            );
        }
        let mut scoped_classes = G41_Q174_Q87_DEFECT_SHIFTS.map(canonical_q87_shift_class);
        scoped_classes.sort_unstable();
        assert!(scoped_classes.windows(2).all(|pair| pair[0] < pair[1]));
        assert_eq!(canonical_q87_shift_class(4), canonical_q87_shift_class(10));
    }

    #[test]
    fn all_disjoint_fine_orbits_fill_every_q174_residue_exactly_three_times() {
        let layout = compile_layout().unwrap();
        let inventory = compile_inventory().unwrap();
        let mut state = 0_u128;
        for slot in 0..SLOTS {
            state = add_states(state, orbit_state(&layout, &inventory.small[slot]).unwrap());
            for orbit in &inventory.large[slot][..usize::from(inventory.large_len[slot])] {
                state = add_states(state, orbit_state(&layout, orbit).unwrap());
            }
        }
        assert!((0..CLASSES).all(|class| coefficient(state, class) == 3));
    }

    #[test]
    fn partition_search_recovers_when_the_first_balanced_partition_exceeds_budget() {
        let layout = compile_layout().unwrap();
        let independent = [
            [0_u128, 1_u128],
            [0_u128, 1_u128 << 2],
            [0_u128, 1_u128 << 4],
        ];
        let contributions = [
            independent[0].as_slice(),
            independent[1].as_slice(),
            independent[2].as_slice(),
            independent[0].as_slice(),
            independent[1].as_slice(),
            independent[2].as_slice(),
        ];
        assert!(matches!(
            compile_side(
                &layout,
                [contributions[0], contributions[1], contributions[2]],
                [1; 8],
                0,
                6
            ),
            Err(G41Q174JointError::StateBudget { .. })
        ));
        let (left_slots, right_slots, left, right, attempts) =
            compile_partitioned_sides_with_limit(
                &layout,
                contributions,
                [2; SLOTS],
                [1; COORDINATES],
                0,
                6,
            )
            .unwrap();
        assert_eq!(left_slots, [0, 1, 3]);
        assert_eq!(right_slots, [2, 4, 5]);
        assert_eq!(left.len(), 4);
        assert_eq!(right.len(), 4);
        assert_eq!(attempts.len(), 2);
        assert_eq!(attempts[0].failed_stage, Some(2));
        assert!(attempts[1].failed_stage.is_none());
    }

    #[test]
    fn q174_state_projects_to_direct_q29_q58_and_q87_orbit_counts() {
        let layout = compile_layout().unwrap();
        let inventory = compile_inventory().unwrap();
        let orbit = &inventory.large[4][3];
        let state = orbit_state(&layout, orbit).unwrap();
        let direct29: [u8; 29] = std::array::from_fn(|residue| {
            orbit.points[..usize::from(orbit.len)]
                .iter()
                .filter(|&&point| usize::from(point) % 29 == residue)
                .count() as u8
        });
        let direct58: [i32; 58] = std::array::from_fn(|residue| {
            orbit.points[..usize::from(orbit.len)]
                .iter()
                .filter(|&&point| usize::from(point) % 58 == residue)
                .count() as i32
        });
        let direct87: [i32; 87] = std::array::from_fn(|residue| {
            orbit.points[..usize::from(orbit.len)]
                .iter()
                .filter(|&&point| usize::from(point) % 87 == residue)
                .count() as i32
        });
        assert_eq!(q58_coefficients(&layout, state), direct58);
        assert_eq!(q87_coefficients(&layout, state), direct87);
        let q87_layout = compile_q87_layout().unwrap();
        let scoped = q87_defects(&q87_layout, q87_state(&layout, state)).unwrap();
        let zero: i32 = direct87.iter().map(|&value| value * value).sum();
        let direct_scoped: [u16; G41_Q174_Q87_SCOPED_DEFECTS] =
            G41_Q174_Q87_DEFECT_SHIFTS.map(|shift| {
                (zero
                    - (0..Q87_MODULUS)
                        .map(|residue| {
                            direct87[residue] * direct87[(residue + shift) % Q87_MODULUS]
                        })
                        .sum::<i32>()) as u16
            });
        assert_eq!(scoped, direct_scoped);
        let replay = replay_g41_q174_q87_defects([state; 4]).unwrap();
        for (index, &defect) in replay.combined_nonzero_defects.iter().enumerate() {
            let shift = index + 1;
            let direct = zero
                - (0..Q87_MODULUS)
                    .map(|residue| direct87[residue] * direct87[(residue + shift) % Q87_MODULUS])
                    .sum::<i32>();
            assert_eq!(i32::from(defect), 4 * direct);
        }
        assert_eq!(
            replay_g41_q174_q87_defects([1_u128 << STATE_BITS; 4]),
            Err(G41Q174JointError::SemanticMismatch)
        );
        let q58_layout = compile_q58_layout().unwrap();
        let packed_q58 = q58_state(&layout, &q58_layout, state);
        for class in 0..Q58_CLASSES {
            assert_eq!(
                q58_lane(packed_q58, class),
                direct58[usize::from(q58_layout.representatives[class])]
            );
        }
        let projected = projection(&layout, state);
        assert_eq!(projected[0], direct29[0]);
        for coordinate in 1..COORDINATES {
            assert!(Q29_COSETS[coordinate - 1]
                .iter()
                .all(|&residue| direct29[residue] == projected[coordinate]));
        }
    }

    #[test]
    fn joint_profile_hash_insertion_allocates_nothing_hot() {
        let mut workspace = ProfileWorkspace::<16>::new();
        let (_, allocations) = tracked_allocations(|| {
            for energy in 0..8_u16 {
                workspace
                    .insert(
                        G41Q174JointProfile {
                            q58_energy: energy,
                            q58_residuals: ResidualTuple::from_array([energy as i16; 7]),
                            q87_energy: 2 * energy,
                            q87_defects: [energy; G41_Q174_Q87_SCOPED_DEFECTS],
                        },
                        u128::from(energy),
                    )
                    .unwrap();
            }
        });
        assert_eq!(allocations, 0);
    }

    #[test]
    fn q58_profile_cache_allocates_nothing_hot() {
        let layout = compile_q58_layout().unwrap();
        let mut workspace = Q58ProfileCache::<16>::new();
        let (_, allocations) = tracked_allocations(|| {
            for state in 0..8_u64 {
                let _ = workspace.get_or_compile(state, &layout, [0; 7]).unwrap();
            }
        });
        assert_eq!(allocations, 0);
    }

    #[test]
    fn q174_allocation_witness_reconstructs_a_small_direct_target() {
        let layout = compile_layout().unwrap();
        let inventory = compile_inventory().unwrap();
        let target = orbit_state(&layout, &inventory.large[0][0]).unwrap();
        let report = find_g41_q174_allocation_witness(0, 1, target).unwrap();
        assert_eq!(report.orbit_masks, Some([1, 0, 0, 0, 0, 0]));
    }
}
