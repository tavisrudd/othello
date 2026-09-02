//! Exact q58 refinement beneath one g41 q29 coefficient vector.
//!
//! Multiplication by 41 has sixteen residue orbits on `Z/58`, so an invariant
//! quotient coefficient vector fits in sixteen four-bit lanes. Conditioning
//! every intermediate state on the target q29 projection folds all allocation
//! decompositions and binary orientations into a bounded iterative DP.

use serde::Serialize;
use sha2::{Digest, Sha256};
use thiserror::Error;

use crate::feature_synthesis::ResidualTuple;
use crate::g41_q29_evolve::{
    compile_inventory, digit_counts, FineInventory, FineOrbit, Q29_COSETS,
};

const SLOTS: usize = 6;
const MODULUS: usize = 58;
const CLASSES: usize = 16;
const PROFILE_COORDINATES: usize = CLASSES - 1;
const LANE_BITS: u32 = 4;
const LANE_MASK: u64 = 0xf;
const MAX_COEFFICIENT: u8 = 9;
const MAX_WEIGHTED_ENERGY: usize = 523 * (MODULUS - 1);
const ENERGY_WORDS: usize = (MAX_WEIGHTED_ENERGY + 1).div_ceil(64);
pub const Q58_ANTI_ENERGY_WORDS: usize = (523_usize + 1).div_ceil(64);
const Q29_SHARD_COORDINATES: usize = 4;

#[derive(Clone, Debug, Error, PartialEq, Eq)]
pub enum G41Q58ExactTablebaseError {
    #[error("g41 q58 exact tablebase semantic binding failed")]
    SemanticMismatch,
    #[error("g41 q58 exact tablebase exceeded its fixed state budget")]
    StateBudget,
    #[error("g41 q58 exact tablebase exceeded its fixed state budget after slot {slot} at {states} states")]
    StateBudgetAt { slot: u8, states: u32 },
    #[error(transparent)]
    Evolve(#[from] crate::g41_q29_evolve::G41Q29EvolveError),
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q58UnderQ29Report {
    pub mask: u8,
    pub digits: u32,
    pub q29_coefficients: [u8; 8],
    pub q58_split_superset_states: u64,
    pub q58_split_budget_survivors: u64,
    pub shard_q29_coordinates: [u8; Q29_SHARD_COORDINATES],
    pub projection_shards: u32,
    pub slot_contribution_states: [u32; SLOTS],
    pub state_visits_after_slot: [u64; SLOTS],
    pub maximum_states_in_shard: u32,
    pub exact_q29_projection_state_visits: u32,
    pub q58_budget_survivor_visits: u32,
    pub exact_reachable_anti_profiles: u32,
    pub reachable_anti_profile_digest: [u8; 32],
    pub first_survivor_profile: Option<[u16; PROFILE_COORDINATES]>,
    pub workspace_bytes: u64,
    pub provenance: &'static str,
}

pub struct G41Q58ReachableAntiProfileTablebase {
    pub report: G41Q58UnderQ29Report,
    pub profiles: Box<[G41Q58AntiProfile]>,
    witness_states: Box<[u64]>,
}

impl G41Q58ReachableAntiProfileTablebase {
    pub fn witness_class_coefficients(&self, profile: usize) -> Option<[u8; CLASSES]> {
        self.witness_states
            .get(profile)
            .map(|&state| std::array::from_fn(|class| coefficient(state, class)))
    }
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q58SplitSupersetReport {
    pub q29_coefficients: [u8; 8],
    pub q58_split_states: u64,
    pub q58_budget_survivors: u64,
    pub first_survivor_profile: Option<[u16; PROFILE_COORDINATES]>,
    pub provenance: &'static str,
}

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
pub struct G41Q58ExactProfile {
    lanes: [u64; 3],
}

const _: () = assert!(
    std::mem::size_of::<G41Q58ExactProfile>() == 24
        && std::mem::align_of::<G41Q58ExactProfile>() == 8
);

impl G41Q58ExactProfile {
    fn pack(values: [u16; PROFILE_COORDINATES]) -> Self {
        let mut lanes = [0_u64; 3];
        for (coordinate, &value) in values.iter().enumerate() {
            let lane = coordinate / 5;
            let shift = 10 * (coordinate % 5);
            lanes[lane] |= u64::from(value) << shift;
        }
        Self { lanes }
    }

    pub fn coordinate(self, coordinate: usize) -> Option<u16> {
        (coordinate < PROFILE_COORDINATES)
            .then(|| ((self.lanes[coordinate / 5] >> (10 * (coordinate % 5))) & 0x3ff) as u16)
    }

    /// Orbit-weighted sum of the fifteen nonzero q58 defect coordinates.
    /// Multiplication by 41 has fourteen length-four nonzero classes and the
    /// fixed class {29}; this is the terminal in `58 A(0) - |X|^2`.
    #[inline(always)]
    pub fn weighted_energy(self) -> u32 {
        let mut energy = 0_u32;
        for coordinate in 0..PROFILE_COORDINATES - 1 {
            energy += 4 * u32::from(self.coordinate(coordinate).unwrap());
        }
        energy + u32::from(self.coordinate(PROFILE_COORDINATES - 1).unwrap())
    }
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q58SplitProfileTableReport {
    pub q29_coefficients: [u8; 8],
    pub q58_split_states: u64,
    pub q58_budget_survivors: u64,
    pub exact_profiles: u32,
    pub coordinate_minima: [u16; PROFILE_COORDINATES],
    pub coordinate_maxima: [u16; PROFILE_COORDINATES],
    pub coordinate_value_masks: [[u64; 9]; PROFILE_COORDINATES],
    pub weighted_energy_values: u32,
    pub weighted_energy_minimum: u32,
    pub weighted_energy_maximum: u32,
    pub profile_digest: [u8; 32],
    pub workspace_bytes: u64,
    pub provenance: &'static str,
}

pub struct G41Q58SplitProfileTablebase {
    pub report: G41Q58SplitProfileTableReport,
    pub profiles: Box<[G41Q58ExactProfile]>,
    pub weighted_energy_mask: Box<[u64]>,
}

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
pub struct G41Q58AntiProfile {
    energy: u16,
    residuals: ResidualTuple<i16, 7>,
}

const _: () = assert!(
    std::mem::size_of::<G41Q58AntiProfile>() == 16
        && std::mem::align_of::<G41Q58AntiProfile>() == 2
);

impl G41Q58AntiProfile {
    pub const fn energy(self) -> u16 {
        self.energy
    }

    pub fn residual(self, coordinate: usize) -> Option<i16> {
        self.residuals.as_array().get(coordinate).copied()
    }

    pub fn zero_frequency_square(self) -> Option<u32> {
        let value = i32::from(self.energy)
            + 4 * self
                .residuals
                .as_array()
                .iter()
                .map(|&residual| i32::from(residual))
                .sum::<i32>();
        value.try_into().ok()
    }

    pub fn passes_pair_gram_budget(self) -> bool {
        let energy = i32::from(self.energy);
        self.residuals.as_array().iter().all(|&residual| {
            let residual = i32::from(residual);
            (0..=523).contains(&(energy - residual)) && (0..=523).contains(&(energy + residual))
        })
    }
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q58AntiProfileReport {
    pub q29_coefficients: [u8; 8],
    pub q58_split_states: u64,
    pub q58_budget_survivors: u64,
    pub pair_gram_survivors: u64,
    pub spectral_zero_survivors: u64,
    pub exact_profiles: u32,
    pub profile_digest: [u8; 32],
    pub workspace_bytes: u64,
    pub provenance: &'static str,
}

pub struct G41Q58AntiProfileTablebase {
    pub report: G41Q58AntiProfileReport,
    pub profiles: Box<[G41Q58AntiProfile]>,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q58InterfaceAntiProfileReport {
    pub mask: u8,
    pub digits: u32,
    pub q29_coefficients: [u8; 8],
    pub q58_split_states: u64,
    pub lane_support_survivors: u64,
    pub q58_budget_survivors: u64,
    pub pair_gram_survivors: u64,
    pub spectral_zero_survivors: u64,
    pub exact_profiles: u32,
    pub lane_value_masks: [u16; CLASSES],
    pub profile_digest: [u8; 32],
    pub workspace_bytes: u64,
    pub provenance: &'static str,
}

pub struct G41Q58InterfaceAntiProfileTablebase {
    pub report: G41Q58InterfaceAntiProfileReport,
    pub profiles: Box<[G41Q58AntiProfile]>,
}

/// Exact marginal image of one fine-orbit interface on the sixteen q58 lanes.
/// The masks are necessary only: they deliberately forget correlations
/// between lanes.
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct G41Q58LaneSupport {
    pub mask: u8,
    pub digits: u32,
    pub lane_value_masks: [u16; CLASSES],
    difference_masks: [[u16; 19]; 8],
    pub workspace_bytes: u64,
    pub provenance: &'static str,
}

impl G41Q58LaneSupport {
    /// Necessary shift-29 energy fibre above one exact q29 coefficient vector.
    /// The structural identity is `E = d_0^2 + 4 sum_{j=1}^7 d_j^2`, where
    /// `d_j` is the difference of the two q58 lanes above q29 coordinate `j`.
    /// Each coordinate uses its exact two-lane marginal support; the eight
    /// coordinates are then convolved while deliberately forgetting their
    /// cross-coordinate allocation correlations.
    #[inline]
    pub fn q58_anti_energy_support(
        &self,
        q29_coefficients: [u8; 8],
    ) -> [u64; Q58_ANTI_ENERGY_WORDS] {
        let mut current = [0_u64; Q58_ANTI_ENERGY_WORDS];
        current[0] = 1;
        for (coordinate, &coefficient) in q29_coefficients.iter().enumerate() {
            if coefficient > 18 {
                return [0; Q58_ANTI_ENERGY_WORDS];
            }
            let mut next = [0_u64; Q58_ANTI_ENERGY_WORDS];
            let mut differences = self.difference_masks[coordinate][usize::from(coefficient)];
            while differences != 0 {
                let difference = differences.trailing_zeros() as usize;
                differences &= differences - 1;
                let shift = if coordinate == 0 {
                    difference * difference
                } else {
                    4 * difference * difference
                };
                if shift > 523 {
                    continue;
                }
                let word_shift = shift / 64;
                let bit_shift = shift % 64;
                for source in 0..Q58_ANTI_ENERGY_WORDS - word_shift {
                    let word = current[source];
                    next[source + word_shift] |= word << bit_shift;
                    if bit_shift != 0 && source + word_shift + 1 < Q58_ANTI_ENERGY_WORDS {
                        next[source + word_shift + 1] |= word >> (64 - bit_shift);
                    }
                }
            }
            current = next;
        }
        current[Q58_ANTI_ENERGY_WORDS - 1] &= (1_u64 << (524 % 64)) - 1;
        current
    }
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct G41Q58AntiProfileWitness {
    pub q29_coefficients: [u8; 8],
    pub q58_class_coefficients: [u8; CLASSES],
    pub q58_values: [u8; MODULUS],
    pub profile: G41Q58AntiProfile,
    pub provenance: &'static str,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q58AllocationWitnessReport {
    pub mask: u8,
    pub digits: u32,
    pub target_q58_class_coefficients: [u8; CLASSES],
    pub states_after_slot: [u32; SLOTS],
    pub orbit_masks: Option<[u16; SLOTS]>,
    pub workspace_bytes: u64,
    pub provenance: &'static str,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q58OriginalReplayReport {
    pub row_weights: [u16; 4],
    pub nonzero_shift_defect_sums: Vec<u16>,
    pub all_nonzero_defects_equal_523: bool,
    pub row_digest: [u8; 32],
    pub provenance: &'static str,
}

struct Q58AntiContext {
    q29_coefficients: [u8; 8],
    quotient_defects: ResidualTuple<i32, 7>,
}

impl Q58AntiContext {
    fn compile(q29_coefficients: [u8; 8]) -> Result<Self, G41Q58ExactTablebaseError> {
        if q29_coefficients.iter().any(|&value| value > 18) {
            return Err(G41Q58ExactTablebaseError::SemanticMismatch);
        }
        let mut quotient = [0_i32; 29];
        quotient[0] = i32::from(q29_coefficients[0]);
        for (class, coset) in Q29_COSETS.iter().enumerate() {
            for &residue in coset {
                quotient[residue] = i32::from(q29_coefficients[class + 1]);
            }
        }
        let zero: i32 = quotient.iter().map(|&value| value * value).sum();
        let defects = std::array::from_fn(|coordinate| {
            let shift = Q29_COSETS[coordinate][0];
            zero - (0..29)
                .map(|residue| quotient[residue] * quotient[(residue + shift) % 29])
                .sum::<i32>()
        });
        Ok(Self {
            q29_coefficients,
            quotient_defects: ResidualTuple::from_array(defects),
        })
    }
}

#[derive(Clone, Copy)]
struct Q58Layout {
    class_of: [u8; MODULUS],
    representatives: [u8; CLASSES],
    lengths: [u8; CLASSES],
}

fn compile_layout() -> Result<Q58Layout, G41Q58ExactTablebaseError> {
    let mut class_of = [u8::MAX; MODULUS];
    let mut representatives = [0_u8; CLASSES];
    let mut lengths = [0_u8; CLASSES];
    let mut classes = 0_usize;
    for start in 0..MODULUS {
        if class_of[start] != u8::MAX {
            continue;
        }
        if classes == CLASSES {
            return Err(G41Q58ExactTablebaseError::SemanticMismatch);
        }
        representatives[classes] = start as u8;
        let mut point = start;
        loop {
            if class_of[point] != u8::MAX && class_of[point] != classes as u8 {
                return Err(G41Q58ExactTablebaseError::SemanticMismatch);
            }
            class_of[point] = classes as u8;
            lengths[classes] += 1;
            point = point * 41 % MODULUS;
            if point == start {
                break;
            }
        }
        classes += 1;
    }
    if classes != CLASSES || class_of.contains(&u8::MAX) {
        return Err(G41Q58ExactTablebaseError::SemanticMismatch);
    }
    Ok(Q58Layout {
        class_of,
        representatives,
        lengths,
    })
}

#[inline(always)]
fn coefficient(state: u64, class: usize) -> u8 {
    ((state >> (LANE_BITS * class as u32)) & LANE_MASK) as u8
}

fn pack_histogram(
    layout: &Q58Layout,
    histogram: &[u8; MODULUS],
) -> Result<u64, G41Q58ExactTablebaseError> {
    let mut state = 0_u64;
    for class in 0..CLASSES {
        let value = histogram[usize::from(layout.representatives[class])];
        if value > MAX_COEFFICIENT
            || (0..MODULUS).any(|residue| {
                usize::from(layout.class_of[residue]) == class && histogram[residue] != value
            })
        {
            return Err(G41Q58ExactTablebaseError::SemanticMismatch);
        }
        state |= u64::from(value) << (LANE_BITS * class as u32);
    }
    Ok(state)
}

fn orbit_state(layout: &Q58Layout, orbit: &FineOrbit) -> Result<u64, G41Q58ExactTablebaseError> {
    let mut histogram = [0_u8; MODULUS];
    for &point in &orbit.points[..usize::from(orbit.len)] {
        histogram[usize::from(point) % MODULUS] += 1;
    }
    pack_histogram(layout, &histogram)
}

#[inline(always)]
fn add_states(left: u64, right: u64) -> u64 {
    let sum = left + right;
    debug_assert!((0..CLASSES).all(|class| coefficient(sum, class) <= MAX_COEFFICIENT));
    sum
}

fn q29_projection(layout: &Q58Layout, state: u64) -> Result<[u8; 8], G41Q58ExactTablebaseError> {
    let values: [u8; MODULUS] =
        std::array::from_fn(|residue| coefficient(state, usize::from(layout.class_of[residue])));
    let mut q29 = [0_u8; 29];
    for residue in 0..29 {
        q29[residue] = values[residue]
            .checked_add(values[residue + 29])
            .ok_or(G41Q58ExactTablebaseError::SemanticMismatch)?;
    }
    let mut projected = [0_u8; 8];
    projected[0] = q29[0];
    for (class, coset) in Q29_COSETS.iter().enumerate() {
        let value = q29[coset[0]];
        if coset.iter().any(|&residue| q29[residue] != value) {
            return Err(G41Q58ExactTablebaseError::SemanticMismatch);
        }
        projected[class + 1] = value;
    }
    Ok(projected)
}

#[inline(always)]
fn projection_within(projected: [u8; 8], target: [u8; 8]) -> bool {
    (0..8).all(|coordinate| projected[coordinate] <= target[coordinate])
}

fn slot_contributions(
    layout: &Q58Layout,
    inventory: &FineInventory,
    slot: usize,
    count: u8,
) -> Result<Vec<u64>, G41Q58ExactTablebaseError> {
    let len = inventory.large_len[slot];
    if count > len {
        return Err(G41Q58ExactTablebaseError::SemanticMismatch);
    }
    let mut orbit_states = [0_u64; 14];
    for orbit in 0..len {
        orbit_states[usize::from(orbit)] =
            orbit_state(layout, &inventory.large[slot][usize::from(orbit)])?;
    }
    let mut output = Vec::with_capacity(1 << len);
    for selection in 0_u16..1_u16 << len {
        if selection.count_ones() != u32::from(count) {
            continue;
        }
        let mut state = 0_u64;
        for orbit in 0..len {
            if selection & (1 << orbit) != 0 {
                state = add_states(state, orbit_states[usize::from(orbit)]);
            }
        }
        output.push(state);
    }
    output.sort_unstable();
    output.dedup();
    Ok(output)
}

fn pack_class_coefficients(values: [u8; CLASSES]) -> Result<u64, G41Q58ExactTablebaseError> {
    if values.iter().any(|&value| value > MAX_COEFFICIENT) {
        return Err(G41Q58ExactTablebaseError::SemanticMismatch);
    }
    Ok(values
        .iter()
        .enumerate()
        .fold(0_u64, |state, (class, &value)| {
            state | (u64::from(value) << (LANE_BITS * class as u32))
        }))
}

#[inline(always)]
fn state_within(state: u64, target: u64) -> bool {
    (0..CLASSES).all(|class| coefficient(state, class) <= coefficient(target, class))
}

fn subtract_state(target: u64, contribution: u64) -> Option<u64> {
    let mut difference = 0_u64;
    for class in 0..CLASSES {
        let value = coefficient(target, class).checked_sub(coefficient(contribution, class))?;
        difference |= u64::from(value) << (LANE_BITS * class as u32);
    }
    Some(difference)
}

fn canonical_slot_mask_for_state(
    layout: &Q58Layout,
    inventory: &FineInventory,
    slot: usize,
    count: u8,
    target: u64,
) -> Result<Option<u16>, G41Q58ExactTablebaseError> {
    let len = inventory.large_len[slot];
    let mut orbit_states = [0_u64; 14];
    for orbit in 0..len {
        orbit_states[usize::from(orbit)] =
            orbit_state(layout, &inventory.large[slot][usize::from(orbit)])?;
    }
    for selection in 0_u16..1_u16 << len {
        if selection.count_ones() != u32::from(count) {
            continue;
        }
        let mut state = 0_u64;
        for orbit in 0..len {
            if selection & (1 << orbit) != 0 {
                state = add_states(state, orbit_states[usize::from(orbit)]);
            }
        }
        if state == target {
            return Ok(Some(selection));
        }
    }
    Ok(None)
}

struct StateWorkspace<const CAPACITY: usize> {
    keys: Box<[u64]>,
    occupied: Box<[u8]>,
    touched: Vec<u32>,
}

impl<const CAPACITY: usize> StateWorkspace<CAPACITY> {
    const MAX_STATES: usize = 3 * CAPACITY / 4;

    fn new() -> Self {
        assert!(CAPACITY.is_power_of_two());
        Self {
            keys: vec![0; CAPACITY].into_boxed_slice(),
            occupied: vec![0; CAPACITY].into_boxed_slice(),
            touched: Vec::with_capacity(Self::MAX_STATES),
        }
    }

    #[inline(always)]
    fn insert(&mut self, key: u64) -> Result<bool, G41Q58ExactTablebaseError> {
        let mut hash = key;
        hash ^= hash >> 30;
        hash = hash.wrapping_mul(0xbf58_476d_1ce4_e5b9);
        hash ^= hash >> 27;
        hash = hash.wrapping_mul(0x94d0_49bb_1331_11eb);
        hash ^= hash >> 31;
        let mut slot = hash as usize & (CAPACITY - 1);
        loop {
            if self.occupied[slot] != 0 {
                if self.keys[slot] == key {
                    return Ok(false);
                }
            } else {
                if self.touched.len() == Self::MAX_STATES {
                    return Err(G41Q58ExactTablebaseError::StateBudget);
                }
                self.occupied[slot] = 1;
                self.keys[slot] = key;
                self.touched.push(slot as u32);
                return Ok(true);
            }
            slot = (slot + 1) & (CAPACITY - 1);
        }
    }

    fn reset(&mut self) {
        for &slot in &self.touched {
            self.occupied[slot as usize] = 0;
        }
        self.touched.clear();
    }

    const fn bytes() -> u64 {
        (CAPACITY * (std::mem::size_of::<u64>() + std::mem::size_of::<u8>())
            + Self::MAX_STATES * std::mem::size_of::<u32>()) as u64
    }
}

struct AntiProfileWorkspace<const CAPACITY: usize> {
    keys: Box<[G41Q58AntiProfile]>,
    witness_states: Box<[u64]>,
    occupied: Box<[u8]>,
    touched: Vec<u32>,
}

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct ProjectedContribution {
    state: u64,
    projection: [u8; 8],
}

const _: () = assert!(std::mem::size_of::<ProjectedContribution>() == 16);

struct ProjectionSupport {
    keys: [u64; 512],
    occupied: [u8; 512],
}

impl ProjectionSupport {
    fn compile(entries: &[ProjectedContribution]) -> Result<Self, G41Q58ExactTablebaseError> {
        if entries.len() > 511 {
            return Err(G41Q58ExactTablebaseError::StateBudget);
        }
        let mut support = Self {
            keys: [0; 512],
            occupied: [0; 512],
        };
        for entry in entries {
            let key = pack_projection(entry.projection)?;
            let mut slot = projection_hash(key);
            loop {
                if support.occupied[slot] == 0 {
                    support.occupied[slot] = 1;
                    support.keys[slot] = key;
                    break;
                }
                if support.keys[slot] == key {
                    break;
                }
                slot = (slot + 1) & 511;
            }
        }
        Ok(support)
    }

    #[inline(always)]
    fn contains(&self, projection: [u8; 8]) -> bool {
        let Some(key) = pack_projection_unchecked(projection) else {
            return false;
        };
        let mut slot = projection_hash(key);
        loop {
            if self.occupied[slot] == 0 {
                return false;
            }
            if self.keys[slot] == key {
                return true;
            }
            slot = (slot + 1) & 511;
        }
    }

    const fn bytes() -> u64 {
        std::mem::size_of::<Self>() as u64
    }
}

#[inline(always)]
fn projection_hash(key: u64) -> usize {
    key.wrapping_mul(0x9e37_79b9_7f4a_7c15) as usize & 511
}

fn pack_projection(projection: [u8; 8]) -> Result<u64, G41Q58ExactTablebaseError> {
    pack_projection_unchecked(projection).ok_or(G41Q58ExactTablebaseError::SemanticMismatch)
}

#[inline(always)]
fn pack_projection_unchecked(projection: [u8; 8]) -> Option<u64> {
    let mut packed = 0_u64;
    for coordinate in projection {
        if coordinate > 31 {
            return None;
        }
        packed = (packed << 5) | u64::from(coordinate);
    }
    Some(packed)
}

fn compile_projected_contributions(
    layout: &Q58Layout,
    states: &[u64],
) -> Result<Vec<ProjectedContribution>, G41Q58ExactTablebaseError> {
    let mut projected = Vec::with_capacity(states.len());
    for &state in states {
        projected.push(ProjectedContribution {
            state,
            projection: q29_projection(layout, state)?,
        });
    }
    projected.sort_unstable_by_key(|entry| (entry.projection, entry.state));
    Ok(projected)
}

#[inline(always)]
fn projection_complement(left: [u8; 8], target: [u8; 8]) -> Option<[u8; 8]> {
    let mut complement = [0_u8; 8];
    for coordinate in 0..8 {
        complement[coordinate] = target[coordinate].checked_sub(left[coordinate])?;
    }
    Some(complement)
}

#[inline(always)]
fn projection_complement_after_two(
    first: [u8; 8],
    second: [u8; 8],
    target: [u8; 8],
) -> Option<[u8; 8]> {
    let mut complement = [0_u8; 8];
    for coordinate in 0..8 {
        complement[coordinate] = target[coordinate]
            .checked_sub(first[coordinate])?
            .checked_sub(second[coordinate])?;
    }
    Some(complement)
}

#[inline(always)]
fn projected_contribution_range(
    entries: &[ProjectedContribution],
    projection: [u8; 8],
) -> std::ops::Range<usize> {
    let start = entries.partition_point(|entry| entry.projection < projection);
    let end = entries.partition_point(|entry| entry.projection <= projection);
    start..end
}

impl<const CAPACITY: usize> AntiProfileWorkspace<CAPACITY> {
    const MAX_PROFILES: usize = 3 * CAPACITY / 4;

    fn new() -> Self {
        assert!(CAPACITY.is_power_of_two() && CAPACITY <= u32::MAX as usize);
        Self {
            keys: vec![
                G41Q58AntiProfile {
                    energy: 0,
                    residuals: ResidualTuple::from_array([0; 7]),
                };
                CAPACITY
            ]
            .into_boxed_slice(),
            witness_states: vec![0; CAPACITY].into_boxed_slice(),
            occupied: vec![0; CAPACITY].into_boxed_slice(),
            touched: Vec::with_capacity(Self::MAX_PROFILES),
        }
    }

    #[inline(always)]
    fn insert(
        &mut self,
        profile: G41Q58AntiProfile,
        witness_state: u64,
    ) -> Result<(), G41Q58ExactTablebaseError> {
        let mut hash = u64::from(profile.energy());
        for coordinate in 0..7 {
            hash ^= (profile.residual(coordinate).unwrap() as u16 as u64)
                .wrapping_add(hash << 6)
                .wrapping_add(hash >> 2);
        }
        let mut slot = hash as usize & (CAPACITY - 1);
        loop {
            if self.occupied[slot] == 0 {
                if self.touched.len() == Self::MAX_PROFILES {
                    return Err(G41Q58ExactTablebaseError::StateBudget);
                }
                self.occupied[slot] = 1;
                self.keys[slot] = profile;
                self.witness_states[slot] = witness_state;
                self.touched.push(slot as u32);
                return Ok(());
            }
            if self.keys[slot] == profile {
                self.witness_states[slot] = self.witness_states[slot].min(witness_state);
                return Ok(());
            }
            slot = (slot + 1) & (CAPACITY - 1);
        }
    }

    fn records(&self) -> Vec<(G41Q58AntiProfile, u64)> {
        let mut records = Vec::with_capacity(self.touched.len());
        for &slot in &self.touched {
            records.push((self.keys[slot as usize], self.witness_states[slot as usize]));
        }
        records
    }

    const fn bytes() -> u64 {
        (CAPACITY
            * (std::mem::size_of::<G41Q58AntiProfile>()
                + std::mem::size_of::<u64>()
                + std::mem::size_of::<u8>())
            + Self::MAX_PROFILES * std::mem::size_of::<u32>()) as u64
    }
}

#[cfg(test)]
fn q58_defects(
    layout: &Q58Layout,
    state: u64,
) -> Result<[u32; PROFILE_COORDINATES], G41Q58ExactTablebaseError> {
    let values: [u16; MODULUS] = std::array::from_fn(|residue| {
        u16::from(coefficient(state, usize::from(layout.class_of[residue])))
    });
    let zero: u32 = values
        .iter()
        .map(|&value| u32::from(value) * u32::from(value))
        .sum();
    let mut defects = [0_u32; PROFILE_COORDINATES];
    for coordinate in 0..PROFILE_COORDINATES {
        let shift = usize::from(layout.representatives[coordinate + 1]);
        let shifted: u32 = (0..MODULUS)
            .map(|residue| {
                u32::from(values[residue]) * u32::from(values[(residue + shift) % MODULUS])
            })
            .sum();
        let defect = zero
            .checked_sub(shifted)
            .ok_or(G41Q58ExactTablebaseError::SemanticMismatch)?;
        defects[coordinate] = defect;
    }
    Ok(defects)
}

fn q58_profile(
    layout: &Q58Layout,
    state: u64,
) -> Result<Option<[u16; PROFILE_COORDINATES]>, G41Q58ExactTablebaseError> {
    let values: [u16; MODULUS] = std::array::from_fn(|residue| {
        u16::from(coefficient(state, usize::from(layout.class_of[residue])))
    });
    let zero: u32 = values
        .iter()
        .map(|&value| u32::from(value) * u32::from(value))
        .sum();
    let mut profile = [0_u16; PROFILE_COORDINATES];
    for coordinate in 0..PROFILE_COORDINATES {
        let shift = usize::from(layout.representatives[coordinate + 1]);
        let shifted: u32 = (0..MODULUS)
            .map(|residue| {
                u32::from(values[residue]) * u32::from(values[(residue + shift) % MODULUS])
            })
            .sum();
        let defect = zero
            .checked_sub(shifted)
            .ok_or(G41Q58ExactTablebaseError::SemanticMismatch)?;
        if defect > 523 {
            return Ok(None);
        }
        profile[coordinate] = defect as u16;
    }
    Ok(Some(profile))
}

fn q58_anti_profile(
    layout: &Q58Layout,
    state: u64,
    context: &Q58AntiContext,
) -> Result<Option<G41Q58AntiProfile>, G41Q58ExactTablebaseError> {
    let profile = q58_anti_terms(layout, state, context)?;
    let energy = i32::from(profile.energy);
    if energy > 523 {
        return Ok(None);
    }
    for coordinate in 0..7 {
        let quotient_defect = context.quotient_defects.as_array()[coordinate];
        let residual = i32::from(profile.residuals.as_array()[coordinate]);
        let first_numerator = quotient_defect + energy - residual;
        let second_numerator = quotient_defect + energy + residual;
        if first_numerator & 1 != 0
            || second_numerator & 1 != 0
            || !(0..=2 * 523).contains(&first_numerator)
            || !(0..=2 * 523).contains(&second_numerator)
        {
            return Ok(None);
        }
    }
    Ok(Some(profile))
}

fn q58_anti_terms(
    layout: &Q58Layout,
    state: u64,
    context: &Q58AntiContext,
) -> Result<G41Q58AntiProfile, G41Q58ExactTablebaseError> {
    debug_assert_eq!(
        q29_projection(layout, state).ok(),
        Some(context.q29_coefficients)
    );
    let difference: [i32; 29] = std::array::from_fn(|residue| {
        let first = i32::from(coefficient(state, usize::from(layout.class_of[residue])));
        let second = i32::from(coefficient(
            state,
            usize::from(layout.class_of[residue + 29]),
        ));
        if residue & 1 == 0 {
            first - second
        } else {
            second - first
        }
    });
    let energy: i32 = difference.iter().map(|&value| value * value).sum();
    let mut residuals = [0_i16; 7];
    for coordinate in 0..7 {
        let shift = Q29_COSETS[coordinate][0];
        let residual: i32 = (0..29)
            .map(|residue| difference[residue] * difference[(residue + shift) % 29])
            .sum();
        residuals[coordinate] = residual
            .try_into()
            .map_err(|_| G41Q58ExactTablebaseError::SemanticMismatch)?;
    }
    Ok(G41Q58AntiProfile {
        energy: energy
            .try_into()
            .map_err(|_| G41Q58ExactTablebaseError::SemanticMismatch)?,
        residuals: ResidualTuple::from_array(residuals),
    })
}

#[cfg(test)]
fn q58_anti_terms_direct(
    layout: &Q58Layout,
    state: u64,
) -> Result<G41Q58AntiProfile, G41Q58ExactTablebaseError> {
    let difference: [i32; 29] = std::array::from_fn(|residue| {
        let first = i32::from(coefficient(state, usize::from(layout.class_of[residue])));
        let second = i32::from(coefficient(
            state,
            usize::from(layout.class_of[residue + 29]),
        ));
        if residue & 1 == 0 {
            first - second
        } else {
            second - first
        }
    });
    let energy: i32 = difference.iter().map(|&value| value * value).sum();
    let mut residuals = [0_i16; 7];
    for coordinate in 0..7 {
        let shift = Q29_COSETS[coordinate][0];
        let residual: i32 = (0..29)
            .map(|residue| difference[residue] * difference[(residue + shift) % 29])
            .sum();
        residuals[coordinate] = residual
            .try_into()
            .map_err(|_| G41Q58ExactTablebaseError::SemanticMismatch)?;
    }
    Ok(G41Q58AntiProfile {
        energy: energy
            .try_into()
            .map_err(|_| G41Q58ExactTablebaseError::SemanticMismatch)?,
        residuals: ResidualTuple::from_array(residuals),
    })
}

fn enumerate_q58_split_states(
    layout: &Q58Layout,
    q29_coefficients: [u8; 8],
    mut visit: impl FnMut(u64) -> Result<(), G41Q58ExactTablebaseError>,
) -> Result<u64, G41Q58ExactTablebaseError> {
    let residues: [usize; 8] = std::array::from_fn(|coordinate| {
        if coordinate == 0 {
            0
        } else {
            Q29_COSETS[coordinate - 1][0]
        }
    });
    let first_classes: [usize; 8] = residues.map(|residue| usize::from(layout.class_of[residue]));
    let second_classes: [usize; 8] =
        residues.map(|residue| usize::from(layout.class_of[residue + 29]));
    if (0..8).any(|coordinate| first_classes[coordinate] == second_classes[coordinate]) {
        return Err(G41Q58ExactTablebaseError::SemanticMismatch);
    }
    let expected_states = q29_coefficients.iter().try_fold(1_u64, |product, &value| {
        product.checked_mul(u64::from(value) + 1)
    });
    let Some(expected_states) = expected_states else {
        return Err(G41Q58ExactTablebaseError::StateBudget);
    };
    let mut splits = [0_u8; 8];
    let mut states = 0_u64;
    loop {
        let mut state = 0_u64;
        for coordinate in 0..8 {
            let first = splits[coordinate];
            let second = q29_coefficients[coordinate] - first;
            state |= u64::from(first) << (LANE_BITS * first_classes[coordinate] as u32);
            state |= u64::from(second) << (LANE_BITS * second_classes[coordinate] as u32);
        }
        if q29_projection(layout, state)? != q29_coefficients {
            return Err(G41Q58ExactTablebaseError::SemanticMismatch);
        }
        states += 1;
        visit(state)?;
        let mut coordinate = 0_usize;
        while coordinate < 8 && splits[coordinate] == q29_coefficients[coordinate] {
            splits[coordinate] = 0;
            coordinate += 1;
        }
        if coordinate == 8 {
            break;
        }
        splits[coordinate] += 1;
    }
    if states != expected_states {
        return Err(G41Q58ExactTablebaseError::SemanticMismatch);
    }
    Ok(states)
}

fn enumerate_q58_split_superset(
    layout: &Q58Layout,
    q29_coefficients: [u8; 8],
    mut visit: impl FnMut([u16; PROFILE_COORDINATES]) -> Result<(), G41Q58ExactTablebaseError>,
) -> Result<(u64, u64, Option<[u16; PROFILE_COORDINATES]>), G41Q58ExactTablebaseError> {
    let mut survivors = 0_u64;
    let mut first_survivor = None;
    let states = enumerate_q58_split_states(layout, q29_coefficients, |state| {
        if let Some(profile) = q58_profile(layout, state)? {
            survivors += 1;
            first_survivor.get_or_insert(profile);
            visit(profile)?;
        }
        Ok(())
    })?;
    Ok((states, survivors, first_survivor))
}

pub fn census_g41_q58_split_superset(
    q29_coefficients: [u8; 8],
) -> Result<G41Q58SplitSupersetReport, G41Q58ExactTablebaseError> {
    if q29_coefficients.iter().any(|&value| value > 18) {
        return Err(G41Q58ExactTablebaseError::SemanticMismatch);
    }
    let layout = compile_layout()?;
    let (q58_split_states, q58_budget_survivors, first_survivor_profile) =
        enumerate_q58_split_superset(&layout, q29_coefficients, |_| Ok(()))?;
    Ok(G41Q58SplitSupersetReport {
        q29_coefficients,
        q58_split_states,
        q58_budget_survivors,
        first_survivor_profile,
        provenance: "complete invariant q58 coefficient superset above one q29 vector; eight bounded parity splits are enumerated iteratively and every nonzero multiplier-orbit defect is checked against the nonnegative block budget 523",
    })
}

pub fn compile_g41_q58_split_profile_tablebase(
    q29_coefficients: [u8; 8],
) -> Result<G41Q58SplitProfileTablebase, G41Q58ExactTablebaseError> {
    const MAX_PROFILES: usize = 1 << 23;
    if q29_coefficients.iter().any(|&value| value > 18) {
        return Err(G41Q58ExactTablebaseError::SemanticMismatch);
    }
    let layout = compile_layout()?;
    let mut profiles = Vec::with_capacity(MAX_PROFILES);
    let (q58_split_states, q58_budget_survivors, _) =
        enumerate_q58_split_superset(&layout, q29_coefficients, |profile| {
            if profiles.len() == profiles.capacity() {
                return Err(G41Q58ExactTablebaseError::StateBudget);
            }
            profiles.push(G41Q58ExactProfile::pack(profile));
            Ok(())
        })?;
    profiles.sort_unstable();
    profiles.dedup();
    let mut coordinate_minima = [u16::MAX; PROFILE_COORDINATES];
    let mut coordinate_maxima = [0_u16; PROFILE_COORDINATES];
    let mut coordinate_value_masks = [[0_u64; 9]; PROFILE_COORDINATES];
    let mut weighted_energy_mask = vec![0_u64; ENERGY_WORDS];
    let mut weighted_energy_minimum = u32::MAX;
    let mut weighted_energy_maximum = 0_u32;
    for &profile in &profiles {
        for coordinate in 0..PROFILE_COORDINATES {
            let value = profile
                .coordinate(coordinate)
                .ok_or(G41Q58ExactTablebaseError::SemanticMismatch)?;
            coordinate_minima[coordinate] = coordinate_minima[coordinate].min(value);
            coordinate_maxima[coordinate] = coordinate_maxima[coordinate].max(value);
            coordinate_value_masks[coordinate][usize::from(value) / 64] |=
                1_u64 << (usize::from(value) % 64);
        }
        debug_assert_eq!(&layout.lengths[1..CLASSES - 1], &[4; CLASSES - 2]);
        debug_assert_eq!(layout.lengths[CLASSES - 1], 1);
        let weighted_energy = profile.weighted_energy();
        if weighted_energy as usize > MAX_WEIGHTED_ENERGY {
            return Err(G41Q58ExactTablebaseError::SemanticMismatch);
        }
        weighted_energy_mask[weighted_energy as usize / 64] |=
            1_u64 << (weighted_energy as usize % 64);
        weighted_energy_minimum = weighted_energy_minimum.min(weighted_energy);
        weighted_energy_maximum = weighted_energy_maximum.max(weighted_energy);
    }
    if profiles.is_empty() {
        coordinate_minima.fill(0);
        weighted_energy_minimum = 0;
    }
    let mut hasher = Sha256::new();
    for profile in &profiles {
        for lane in profile.lanes {
            hasher.update(lane.to_le_bytes());
        }
    }
    let report = G41Q58SplitProfileTableReport {
        q29_coefficients,
        q58_split_states,
        q58_budget_survivors,
        exact_profiles: profiles.len() as u32,
        coordinate_minima,
        coordinate_maxima,
        coordinate_value_masks,
        weighted_energy_values: weighted_energy_mask
            .iter()
            .map(|word| word.count_ones())
            .sum(),
        weighted_energy_minimum,
        weighted_energy_maximum,
        profile_digest: hasher.finalize().into(),
        workspace_bytes: (MAX_PROFILES * std::mem::size_of::<G41Q58ExactProfile>()
            + ENERGY_WORDS * std::mem::size_of::<u64>()) as u64,
        provenance: "exact q58 defect-profile image of the complete eight-coordinate split box above one q29 coefficient vector; fixed-cap iterative enumeration, nonnegative 523 budget filtering, 24-byte packed profiles, canonical sort/dedup, and a source-table digest",
    };
    Ok(G41Q58SplitProfileTablebase {
        report,
        profiles: profiles.into_boxed_slice(),
        weighted_energy_mask: weighted_energy_mask.into_boxed_slice(),
    })
}

pub fn compile_g41_q58_anti_profile_tablebase(
    q29_coefficients: [u8; 8],
) -> Result<G41Q58AntiProfileTablebase, G41Q58ExactTablebaseError> {
    const MAX_PROFILES: usize = 1 << 23;
    if q29_coefficients.iter().any(|&value| value > 18) {
        return Err(G41Q58ExactTablebaseError::SemanticMismatch);
    }
    let layout = compile_layout()?;
    let context = Q58AntiContext::compile(q29_coefficients)?;
    let mut profiles = Vec::with_capacity(MAX_PROFILES);
    let mut q58_budget_survivors = 0_u64;
    let mut pair_gram_survivors = 0_u64;
    let mut spectral_zero_survivors = 0_u64;
    let q58_split_states = enumerate_q58_split_states(&layout, q29_coefficients, |state| {
        if let Some(profile) = q58_anti_profile(&layout, state, &context)? {
            q58_budget_survivors += 1;
            if !profile.passes_pair_gram_budget() {
                return Ok(());
            }
            pair_gram_survivors += 1;
            let Some(zero_square) = profile.zero_frequency_square() else {
                return Err(G41Q58ExactTablebaseError::SemanticMismatch);
            };
            if zero_square > 523 {
                return Ok(());
            }
            if profiles.len() == profiles.capacity() {
                return Err(G41Q58ExactTablebaseError::StateBudget);
            }
            profiles.push(profile);
            spectral_zero_survivors += 1;
        }
        Ok(())
    })?;
    profiles.sort_unstable();
    profiles.dedup();
    let mut hasher = Sha256::new();
    for profile in &profiles {
        hasher.update(profile.energy.to_le_bytes());
        for residual in profile.residuals.as_array() {
            hasher.update(residual.to_le_bytes());
        }
    }
    Ok(G41Q58AntiProfileTablebase {
        report: G41Q58AntiProfileReport {
            q29_coefficients,
            q58_split_states,
            q58_budget_survivors,
            pair_gram_survivors,
            spectral_zero_survivors,
            exact_profiles: profiles.len() as u32,
            profile_digest: hasher.finalize().into(),
            workspace_bytes: (MAX_PROFILES * std::mem::size_of::<G41Q58AntiProfile>()) as u64,
            provenance: "exact anti-periodic q58 image above one q29 coefficient vector: each split is represented by its shift-29 energy and seven q29-orbit autocorrelations; the q58/q29 sum-difference identity independently enforces every original block budget, then fourteen two-shift Gram-square budgets and the nonnegative zero-Fourier square budget, before canonical 16-byte profile deduplication",
        },
        profiles: profiles.into_boxed_slice(),
    })
}

pub fn compile_g41_q58_lane_support(
    mask: u8,
    digits: u32,
) -> Result<G41Q58LaneSupport, G41Q58ExactTablebaseError> {
    if mask >= 64 {
        return Err(G41Q58ExactTablebaseError::SemanticMismatch);
    }
    let layout = compile_layout()?;
    let inventory = compile_inventory()?;
    let counts = digit_counts(digits);
    if (0..SLOTS).any(|slot| counts[slot] > inventory.large_len[slot]) {
        return Err(G41Q58ExactTablebaseError::SemanticMismatch);
    }
    let mut initial = 0_u64;
    for slot in 0..SLOTS {
        if mask & (1 << slot) != 0 {
            initial = add_states(initial, orbit_state(&layout, &inventory.small[slot])?);
        }
    }
    let q29_lane_pairs: [[usize; 2]; 8] = std::array::from_fn(|coordinate| {
        let residue = if coordinate == 0 {
            0
        } else {
            Q29_COSETS[coordinate - 1][0]
        };
        [
            usize::from(layout.class_of[residue]),
            usize::from(layout.class_of[residue + 29]),
        ]
    });
    let mut lane_value_masks: [u16; CLASSES] =
        std::array::from_fn(|class| 1_u16 << coefficient(initial, class));
    let mut pair_supports = [[0_u64; 4]; 8];
    for (coordinate, &[first, second]) in q29_lane_pairs.iter().enumerate() {
        let value = 16 * usize::from(coefficient(initial, first))
            + usize::from(coefficient(initial, second));
        pair_supports[coordinate][value / 64] |= 1_u64 << (value % 64);
    }
    let mut workspace_bytes = 0_u64;
    for slot in 0..SLOTS {
        let contributions = slot_contributions(&layout, &inventory, slot, counts[slot])?;
        workspace_bytes = workspace_bytes
            .max(contributions.capacity() as u64 * std::mem::size_of::<u64>() as u64);
        for class in 0..CLASSES {
            let mut contribution_values = 0_u16;
            for &state in &contributions {
                contribution_values |= 1_u16 << coefficient(state, class);
            }
            let mut combined = 0_u16;
            for left in 0_u8..u16::BITS as u8 {
                if lane_value_masks[class] & (1 << left) == 0 {
                    continue;
                }
                for right in 0..=MAX_COEFFICIENT {
                    if contribution_values & (1 << right) != 0
                        && usize::from(left + right) < u16::BITS as usize
                    {
                        combined |= 1_u16 << (left + right);
                    }
                }
            }
            lane_value_masks[class] = combined;
        }
        let mut next_pair_supports = [[0_u64; 4]; 8];
        for (coordinate, &[first, second]) in q29_lane_pairs.iter().enumerate() {
            let mut contribution_support = [0_u64; 4];
            for &state in &contributions {
                let value = 16 * usize::from(coefficient(state, first))
                    + usize::from(coefficient(state, second));
                contribution_support[value / 64] |= 1_u64 << (value % 64);
            }
            for left in 0..=16 * usize::from(MAX_COEFFICIENT) + usize::from(MAX_COEFFICIENT) {
                if pair_supports[coordinate][left / 64] & (1_u64 << (left % 64)) == 0 {
                    continue;
                }
                let left_first = left / 16;
                let left_second = left % 16;
                for right in 0..=16 * usize::from(MAX_COEFFICIENT) + usize::from(MAX_COEFFICIENT) {
                    if contribution_support[right / 64] & (1_u64 << (right % 64)) == 0 {
                        continue;
                    }
                    let first_sum = left_first + right / 16;
                    let second_sum = left_second + right % 16;
                    if first_sum <= usize::from(MAX_COEFFICIENT)
                        && second_sum <= usize::from(MAX_COEFFICIENT)
                    {
                        let value = 16 * first_sum + second_sum;
                        next_pair_supports[coordinate][value / 64] |= 1_u64 << (value % 64);
                    }
                }
            }
        }
        pair_supports = next_pair_supports;
    }
    let difference_masks = std::array::from_fn(|coordinate| {
        std::array::from_fn(|coefficient| {
            let mut differences = 0_u16;
            for left in 0_u8..=MAX_COEFFICIENT {
                for right in 0_u8..=MAX_COEFFICIENT {
                    let value = 16 * usize::from(left) + usize::from(right);
                    if pair_supports[coordinate][value / 64] & (1_u64 << (value % 64)) == 0
                        || usize::from(left + right) != coefficient
                    {
                        continue;
                    }
                    differences |= 1_u16 << left.abs_diff(right);
                }
            }
            differences
        })
    });
    Ok(G41Q58LaneSupport {
        mask,
        digits,
        lane_value_masks,
        difference_masks,
        workspace_bytes,
        provenance: "exact marginal six-slot sumsets on sixteen q58 multiplier-orbit lanes and the eight natural residue/r+29 lane pairs; correlations between distinct q29 coordinates are deliberately forgotten",
    })
}

/// Compile the complete split-box anti-profile image after exact marginal
/// q58-lane support from one concrete fine-orbit interface.  Each marginal is
/// a necessary projection of the full six-slot allocation sumset.
pub fn compile_g41_q58_interface_anti_profile_tablebase(
    mask: u8,
    digits: u32,
    q29_coefficients: [u8; 8],
) -> Result<G41Q58InterfaceAntiProfileTablebase, G41Q58ExactTablebaseError> {
    const MAX_PROFILES: usize = 1 << 23;
    if mask >= 64 || q29_coefficients.iter().any(|&value| value > 18) {
        return Err(G41Q58ExactTablebaseError::SemanticMismatch);
    }
    let layout = compile_layout()?;
    let context = Q58AntiContext::compile(q29_coefficients)?;
    let lane_support = compile_g41_q58_lane_support(mask, digits)?;
    let lane_value_masks = lane_support.lane_value_masks;
    let mut profiles = Vec::with_capacity(MAX_PROFILES);
    let mut lane_support_survivors = 0_u64;
    let mut q58_budget_survivors = 0_u64;
    let mut pair_gram_survivors = 0_u64;
    let mut spectral_zero_survivors = 0_u64;
    let q58_split_states = enumerate_q58_split_states(&layout, q29_coefficients, |state| {
        if (0..CLASSES)
            .any(|class| lane_value_masks[class] & (1_u16 << coefficient(state, class)) == 0)
        {
            return Ok(());
        }
        lane_support_survivors += 1;
        let Some(profile) = q58_anti_profile(&layout, state, &context)? else {
            return Ok(());
        };
        q58_budget_survivors += 1;
        if !profile.passes_pair_gram_budget() {
            return Ok(());
        }
        pair_gram_survivors += 1;
        if profile
            .zero_frequency_square()
            .ok_or(G41Q58ExactTablebaseError::SemanticMismatch)?
            > 523
        {
            return Ok(());
        }
        spectral_zero_survivors += 1;
        if profiles.len() == profiles.capacity() {
            return Err(G41Q58ExactTablebaseError::StateBudget);
        }
        profiles.push(profile);
        Ok(())
    })?;
    profiles.sort_unstable();
    profiles.dedup();
    let mut hasher = Sha256::new();
    for profile in &profiles {
        hasher.update(profile.energy.to_le_bytes());
        for residual in profile.residuals.as_array() {
            hasher.update(residual.to_le_bytes());
        }
    }
    Ok(G41Q58InterfaceAntiProfileTablebase {
        report: G41Q58InterfaceAntiProfileReport {
            mask,
            digits,
            q29_coefficients,
            q58_split_states,
            lane_support_survivors,
            q58_budget_survivors,
            pair_gram_survivors,
            spectral_zero_survivors,
            exact_profiles: profiles.len() as u32,
            lane_value_masks,
            profile_digest: hasher.finalize().into(),
            workspace_bytes: (MAX_PROFILES * std::mem::size_of::<G41Q58AntiProfile>()) as u64
                + lane_support.workspace_bytes,
            provenance: "complete q58 split box under one concrete interface; every lane is first checked against the exact marginal six-slot contribution sumset, then independently extracted anti profiles receive the q58, pair-Gram, and zero-frequency budgets before canonical deduplication",
        },
        profiles: profiles.into_boxed_slice(),
    })
}

/// Replay the canonical split enumeration and return the first source state
/// whose independently extracted anti profile equals `target`.
pub fn find_g41_q58_anti_profile_witness(
    q29_coefficients: [u8; 8],
    target: G41Q58AntiProfile,
) -> Result<Option<G41Q58AntiProfileWitness>, G41Q58ExactTablebaseError> {
    if q29_coefficients.iter().any(|&value| value > 18) {
        return Err(G41Q58ExactTablebaseError::SemanticMismatch);
    }
    let layout = compile_layout()?;
    let context = Q58AntiContext::compile(q29_coefficients)?;
    let mut found = None;
    enumerate_q58_split_states(&layout, q29_coefficients, |state| {
        if found.is_none() && q58_anti_profile(&layout, state, &context)? == Some(target) {
            let q58_class_coefficients = std::array::from_fn(|class| coefficient(state, class));
            let q58_values = std::array::from_fn(|residue| {
                q58_class_coefficients[usize::from(layout.class_of[residue])]
            });
            found = Some(G41Q58AntiProfileWitness {
                q29_coefficients,
                q58_class_coefficients,
                q58_values,
                profile: target,
                provenance: "canonical first preimage under complete iterative q58 split enumeration; profile independently re-extracted from the packed source state",
            });
        }
        Ok(())
    })?;
    Ok(found)
}

/// Decide whether one split-box q58 state is realized by the actual fine
/// orbits under a concrete block interface, retaining only one canonical
/// allocation witness.  Prefix states are bounded and iterative.
pub fn find_g41_q58_allocation_witness(
    mask: u8,
    digits: u32,
    target_q58_class_coefficients: [u8; CLASSES],
) -> Result<G41Q58AllocationWitnessReport, G41Q58ExactTablebaseError> {
    type Workspace = StateWorkspace<{ 1 << 24 }>;
    if mask >= 64 {
        return Err(G41Q58ExactTablebaseError::SemanticMismatch);
    }
    let layout = compile_layout()?;
    let inventory = compile_inventory()?;
    let counts = digit_counts(digits);
    if (0..SLOTS).any(|slot| counts[slot] > inventory.large_len[slot]) {
        return Err(G41Q58ExactTablebaseError::SemanticMismatch);
    }
    let target = pack_class_coefficients(target_q58_class_coefficients)?;
    let target_weight: u16 = (0..CLASSES)
        .map(|class| {
            u16::from(target_q58_class_coefficients[class]) * u16::from(layout.lengths[class])
        })
        .sum();
    let expected_weight = if (mask & 3).count_ones() & 1 == 0 {
        260
    } else {
        261
    };
    if target_weight != expected_weight {
        return Err(G41Q58ExactTablebaseError::SemanticMismatch);
    }
    let mut initial = 0_u64;
    for slot in 0..SLOTS {
        if mask & (1 << slot) != 0 {
            initial = add_states(initial, orbit_state(&layout, &inventory.small[slot])?);
        }
    }
    let mut states_after_slot = [0_u32; SLOTS];
    if !state_within(initial, target) {
        return Ok(G41Q58AllocationWitnessReport {
            mask,
            digits,
            target_q58_class_coefficients,
            states_after_slot,
            orbit_masks: None,
            workspace_bytes: 0,
            provenance: "target-bounded exact q58 allocation DP; fixed small-orbit contribution already exceeds the requested sealed coefficient state",
        });
    }
    let mut contributions = Vec::with_capacity(SLOTS);
    for slot in 0..SLOTS {
        contributions.push(slot_contributions(&layout, &inventory, slot, counts[slot])?);
    }
    let mut workspace = Workspace::new();
    let mut prefixes: Vec<Box<[u64]>> = Vec::with_capacity(SLOTS + 1);
    prefixes.push(vec![initial].into_boxed_slice());
    for slot in 0..SLOTS {
        workspace.reset();
        let mut next = Vec::with_capacity(Workspace::MAX_STATES);
        for &left in &prefixes[slot] {
            for &right in &contributions[slot] {
                let state = add_states(left, right);
                if state_within(state, target) && workspace.insert(state)? {
                    next.push(state);
                }
            }
        }
        next.sort_unstable();
        states_after_slot[slot] = next.len() as u32;
        prefixes.push(next.into_boxed_slice());
        if prefixes[slot + 1].is_empty() {
            let workspace_bytes = Workspace::bytes()
                + prefixes
                    .iter()
                    .map(|states| states.len() as u64 * std::mem::size_of::<u64>() as u64)
                    .sum::<u64>();
            return Ok(G41Q58AllocationWitnessReport {
                mask,
                digits,
                target_q58_class_coefficients,
                states_after_slot,
                orbit_masks: None,
                workspace_bytes,
                provenance: "target-bounded exact q58 allocation DP; a complete iterative prefix image became empty",
            });
        }
    }
    if prefixes[SLOTS].binary_search(&target).is_err() {
        let workspace_bytes = Workspace::bytes()
            + prefixes
                .iter()
                .map(|states| states.len() as u64 * std::mem::size_of::<u64>() as u64)
                .sum::<u64>();
        return Ok(G41Q58AllocationWitnessReport {
            mask,
            digits,
            target_q58_class_coefficients,
            states_after_slot,
            orbit_masks: None,
            workspace_bytes,
            provenance: "target-bounded exact q58 allocation DP; the requested state is absent from the complete six-slot image",
        });
    }
    let mut chosen_contributions = [0_u64; SLOTS];
    let mut remainder = target;
    for slot in (0..SLOTS).rev() {
        let mut found = None;
        for &contribution in &contributions[slot] {
            let Some(prefix) = subtract_state(remainder, contribution) else {
                continue;
            };
            if prefixes[slot].binary_search(&prefix).is_ok() {
                found = Some((prefix, contribution));
                break;
            }
        }
        let Some((prefix, contribution)) = found else {
            return Err(G41Q58ExactTablebaseError::SemanticMismatch);
        };
        chosen_contributions[slot] = contribution;
        remainder = prefix;
    }
    if remainder != initial {
        return Err(G41Q58ExactTablebaseError::SemanticMismatch);
    }
    let mut orbit_masks = [0_u16; SLOTS];
    for slot in 0..SLOTS {
        orbit_masks[slot] = canonical_slot_mask_for_state(
            &layout,
            &inventory,
            slot,
            counts[slot],
            chosen_contributions[slot],
        )?
        .ok_or(G41Q58ExactTablebaseError::SemanticMismatch)?;
    }
    let mut replayed = initial;
    for slot in 0..SLOTS {
        for orbit in 0..inventory.large_len[slot] {
            if orbit_masks[slot] & (1 << orbit) != 0 {
                replayed = add_states(
                    replayed,
                    orbit_state(&layout, &inventory.large[slot][usize::from(orbit)])?,
                );
            }
        }
    }
    if replayed != target {
        return Err(G41Q58ExactTablebaseError::SemanticMismatch);
    }
    let workspace_bytes = Workspace::bytes()
        + prefixes
            .iter()
            .map(|states| states.len() as u64 * std::mem::size_of::<u64>() as u64)
            .sum::<u64>();
    Ok(G41Q58AllocationWitnessReport {
        mask,
        digits,
        target_q58_class_coefficients,
        states_after_slot,
        orbit_masks: Some(orbit_masks),
        workspace_bytes,
        provenance: "target-bounded exact q58 allocation DP; complete six-slot prefix images, backward exact-state replay, canonical subset reconstruction, and direct packed-state replay",
    })
}

/// Reconstruct four binary rows on the original 522-point carrier and check
/// every nonzero cyclic defect directly.  No quotient profile, Gram
/// predicate, or join terminal is consulted here.
pub fn replay_g41_q58_allocations_original(
    witnesses: &[G41Q58AllocationWitnessReport; 4],
) -> Result<G41Q58OriginalReplayReport, G41Q58ExactTablebaseError> {
    const CARRIER: usize = 522;
    let inventory = compile_inventory()?;
    let layout = compile_layout()?;
    let mut rows = [[0_u8; CARRIER]; 4];
    let mut row_weights = [0_u16; 4];
    for block in 0..4 {
        let witness = &witnesses[block];
        let orbit_masks = witness
            .orbit_masks
            .ok_or(G41Q58ExactTablebaseError::SemanticMismatch)?;
        let counts = digit_counts(witness.digits);
        for slot in 0..SLOTS {
            if counts[slot] > inventory.large_len[slot]
                || orbit_masks[slot] >> inventory.large_len[slot] != 0
                || orbit_masks[slot].count_ones() != u32::from(counts[slot])
            {
                return Err(G41Q58ExactTablebaseError::SemanticMismatch);
            }
            if witness.mask & (1 << slot) != 0 {
                write_orbit(&mut rows[block], &inventory.small[slot])?;
            }
            for orbit in 0..inventory.large_len[slot] {
                if orbit_masks[slot] & (1 << orbit) != 0 {
                    write_orbit(&mut rows[block], &inventory.large[slot][usize::from(orbit)])?;
                }
            }
        }
        row_weights[block] = rows[block].iter().map(|&value| u16::from(value)).sum();
        let direct_class_coefficients: [u8; CLASSES] = std::array::from_fn(|class| {
            let representative = usize::from(layout.representatives[class]);
            (representative..CARRIER)
                .step_by(MODULUS)
                .map(|point| rows[block][point])
                .sum::<u8>()
        });
        if direct_class_coefficients != witness.target_q58_class_coefficients {
            return Err(G41Q58ExactTablebaseError::SemanticMismatch);
        }
        let expected = if (witness.mask & 3).count_ones() & 1 == 0 {
            260
        } else {
            261
        };
        if row_weights[block] != expected {
            return Err(G41Q58ExactTablebaseError::SemanticMismatch);
        }
    }
    let mut nonzero_shift_defect_sums = Vec::with_capacity(CARRIER - 1);
    for shift in 1..CARRIER {
        let mut total = 0_u16;
        for block in 0..4 {
            let overlap: u16 = (0..CARRIER)
                .map(|point| u16::from(rows[block][point] & rows[block][(point + shift) % CARRIER]))
                .sum();
            total = total
                .checked_add(row_weights[block] - overlap)
                .ok_or(G41Q58ExactTablebaseError::SemanticMismatch)?;
        }
        nonzero_shift_defect_sums.push(total);
    }
    let mut hasher = Sha256::new();
    for row in &rows {
        hasher.update(row);
    }
    Ok(G41Q58OriginalReplayReport {
        row_weights,
        all_nonzero_defects_equal_523: nonzero_shift_defect_sums
            .iter()
            .all(|&defect| defect == 523),
        nonzero_shift_defect_sums,
        row_digest: hasher.finalize().into(),
        provenance: "direct reconstruction of four binary rows from canonical fine-orbit masks, followed by independent row-weight and all-521-nonzero-shift cyclic-defect evaluation; no quotient or evolved predicate is trusted",
    })
}

fn write_orbit(row: &mut [u8; 522], orbit: &FineOrbit) -> Result<(), G41Q58ExactTablebaseError> {
    for &point in &orbit.points[..usize::from(orbit.len)] {
        let cell = row
            .get_mut(usize::from(point))
            .ok_or(G41Q58ExactTablebaseError::SemanticMismatch)?;
        if *cell != 0 {
            return Err(G41Q58ExactTablebaseError::SemanticMismatch);
        }
        *cell = 1;
    }
    Ok(())
}

pub fn census_g41_q58_under_q29_state(
    mask: u8,
    digits: u32,
    q29_coefficients: [u8; 8],
) -> Result<G41Q58UnderQ29Report, G41Q58ExactTablebaseError> {
    Ok(compile_g41_q58_reachable_anti_profile_tablebase(mask, digits, q29_coefficients)?.report)
}

pub fn compile_g41_q58_reachable_anti_profile_tablebase(
    mask: u8,
    digits: u32,
    q29_coefficients: [u8; 8],
) -> Result<G41Q58ReachableAntiProfileTablebase, G41Q58ExactTablebaseError> {
    type Workspace = StateWorkspace<{ 1 << 24 }>;
    type ProfileWorkspace = AntiProfileWorkspace<{ 1 << 20 }>;
    if mask >= 64 || q29_coefficients.iter().any(|&value| value > 18) {
        return Err(G41Q58ExactTablebaseError::SemanticMismatch);
    }
    let layout = compile_layout()?;
    let inventory = compile_inventory()?;
    let counts = digit_counts(digits);
    if (0..SLOTS).any(|slot| counts[slot] > inventory.large_len[slot]) {
        return Err(G41Q58ExactTablebaseError::SemanticMismatch);
    }
    let row_target = if (mask & 3).count_ones() & 1 == 0 {
        260_u16
    } else {
        261_u16
    };
    let projected_weight = u16::from(q29_coefficients[0])
        + 4 * q29_coefficients[1..]
            .iter()
            .map(|&value| u16::from(value))
            .sum::<u16>();
    if projected_weight != row_target {
        return Err(G41Q58ExactTablebaseError::SemanticMismatch);
    }
    let (q58_split_superset_states, q58_split_budget_survivors, _) =
        enumerate_q58_split_superset(&layout, q29_coefficients, |_| Ok(()))?;
    if q58_split_budget_survivors == 0 {
        return Ok(G41Q58ReachableAntiProfileTablebase {
            report: G41Q58UnderQ29Report {
                mask,
                digits,
                q29_coefficients,
                q58_split_superset_states,
                q58_split_budget_survivors,
                shard_q29_coordinates: [0; Q29_SHARD_COORDINATES],
                projection_shards: 0,
                slot_contribution_states: [0; SLOTS],
                state_visits_after_slot: [0; SLOTS],
                maximum_states_in_shard: 0,
                exact_q29_projection_state_visits: 0,
                q58_budget_survivor_visits: 0,
                exact_reachable_anti_profiles: 0,
                reachable_anti_profile_digest: Sha256::digest(b"").into(),
                first_survivor_profile: None,
                workspace_bytes: 0,
                provenance: "exact q58 split-box theorem beneath one sealed q29 coefficient vector; every invariant q58 coefficient vector is one of eight bounded parity splits, the complete iterative split superset has empty nonnegative defect-budget image, and no orbit-allocation DP is needed",
            },
            profiles: Box::new([]),
            witness_states: Box::new([]),
        });
    }
    let mut initial = 0_u64;
    for slot in 0..SLOTS {
        if mask & (1 << slot) != 0 {
            initial = add_states(initial, orbit_state(&layout, &inventory.small[slot])?);
        }
    }
    if !projection_within(q29_projection(&layout, initial)?, q29_coefficients) {
        return Err(G41Q58ExactTablebaseError::SemanticMismatch);
    }
    let mut coordinate_order: [usize; 8] = std::array::from_fn(|coordinate| coordinate);
    coordinate_order.sort_unstable_by_key(|&coordinate| (q29_coefficients[coordinate], coordinate));
    let shard_q29_coordinates: [usize; Q29_SHARD_COORDINATES] =
        std::array::from_fn(|index| coordinate_order[index]);
    let shard_classes: [usize; Q29_SHARD_COORDINATES] = std::array::from_fn(|index| {
        let coordinate = shard_q29_coordinates[index];
        let residue = if coordinate == 0 {
            0
        } else {
            Q29_COSETS[coordinate - 1][0]
        };
        usize::from(layout.class_of[residue])
    });
    let mut distinct_shard_classes = shard_classes;
    distinct_shard_classes.sort_unstable();
    if distinct_shard_classes
        .windows(2)
        .any(|classes| classes[0] == classes[1])
    {
        return Err(G41Q58ExactTablebaseError::SemanticMismatch);
    }
    let shard_totals = shard_q29_coordinates.map(|coordinate| q29_coefficients[coordinate]);
    let mut contributions = Vec::with_capacity(SLOTS);
    let mut slot_contribution_states = [0_u32; SLOTS];
    for slot in 0..SLOTS {
        let states = slot_contributions(&layout, &inventory, slot, counts[slot])?;
        slot_contribution_states[slot] = states.len() as u32;
        contributions.push(states);
    }
    let final_contributions = compile_projected_contributions(&layout, &contributions[SLOTS - 1])?;
    let final_projection_support = ProjectionSupport::compile(&final_contributions)?;
    let penultimate_contributions =
        compile_projected_contributions(&layout, &contributions[SLOTS - 2])?;
    let mut current = Vec::<u64>::with_capacity(Workspace::MAX_STATES);
    let mut next = Vec::<u64>::with_capacity(Workspace::MAX_STATES);
    let mut workspace = Workspace::new();
    let mut state_visits_after_slot = [0_u64; SLOTS];
    let mut maximum_states_in_shard = 0_u32;
    let mut exact_q29_projection_states = 0_u32;
    let mut q58_budget_survivors = 0_u32;
    let mut first_survivor_profile = None;
    let anti_context = Q58AntiContext::compile(q29_coefficients)?;
    let mut anti_profiles = ProfileWorkspace::new();
    current.push(initial);
    for slot in 0..SLOTS - 2 {
        next.clear();
        workspace.reset();
        for &left in &current {
            for &right in &contributions[slot] {
                let state = add_states(left, right);
                if projection_within(q29_projection(&layout, state)?, q29_coefficients) {
                    match workspace.insert(state) {
                        Ok(true) => next.push(state),
                        Ok(false) => {}
                        Err(G41Q58ExactTablebaseError::StateBudget) => {
                            return Err(G41Q58ExactTablebaseError::StateBudgetAt {
                                slot: slot as u8,
                                states: next.len() as u32,
                            });
                        }
                        Err(error) => return Err(error),
                    }
                }
            }
        }
        workspace.reset();
        std::mem::swap(&mut current, &mut next);
        state_visits_after_slot[slot] = current.len() as u64;
    }
    current.sort_unstable_by_key(|&state| shard_classes.map(|class| coefficient(state, class)));
    let prefix = current.into_boxed_slice();
    let mut current = Vec::<u64>::with_capacity(Workspace::MAX_STATES);
    for shard_first in 0..=shard_totals[0] {
        for shard_second in 0..=shard_totals[1] {
            for shard_third in 0..=shard_totals[2] {
                for shard_fourth in 0..=shard_totals[3] {
                    let shard_key = [shard_first, shard_second, shard_third, shard_fourth];
                    let start = prefix.partition_point(|&state| {
                        shard_classes.map(|class| coefficient(state, class)) < shard_key
                    });
                    let end = prefix.partition_point(|&state| {
                        shard_classes.map(|class| coefficient(state, class)) <= shard_key
                    });
                    current.clear();
                    workspace.reset();
                    for &left in &prefix[start..end] {
                        let left_projection = q29_projection(&layout, left)?;
                        for entry in &penultimate_contributions {
                            if projection_complement_after_two(
                                left_projection,
                                entry.projection,
                                q29_coefficients,
                            )
                            .is_some_and(|required| final_projection_support.contains(required))
                            {
                                let state = add_states(left, entry.state);
                                match workspace.insert(state) {
                                    Ok(true) => current.push(state),
                                    Ok(false) => {}
                                    Err(G41Q58ExactTablebaseError::StateBudget) => {
                                        return Err(G41Q58ExactTablebaseError::StateBudgetAt {
                                            slot: (SLOTS - 2) as u8,
                                            states: current.len() as u32,
                                        });
                                    }
                                    Err(error) => return Err(error),
                                }
                            }
                        }
                    }
                    workspace.reset();
                    state_visits_after_slot[SLOTS - 2] = state_visits_after_slot[SLOTS - 2]
                        .checked_add(current.len() as u64)
                        .ok_or(G41Q58ExactTablebaseError::StateBudget)?;
                    maximum_states_in_shard = maximum_states_in_shard.max(current.len() as u32);

                    next.clear();
                    for &left in &current {
                        let Some(required) =
                            projection_complement(q29_projection(&layout, left)?, q29_coefficients)
                        else {
                            continue;
                        };
                        for entry in &final_contributions
                            [projected_contribution_range(&final_contributions, required)]
                        {
                            let state = add_states(left, entry.state);
                            match workspace.insert(state) {
                                Ok(true) => next.push(state),
                                Ok(false) => {}
                                Err(G41Q58ExactTablebaseError::StateBudget) => {
                                    return Err(G41Q58ExactTablebaseError::StateBudgetAt {
                                        slot: (SLOTS - 1) as u8,
                                        states: next.len() as u32,
                                    });
                                }
                                Err(error) => return Err(error),
                            }
                        }
                    }
                    workspace.reset();
                    std::mem::swap(&mut current, &mut next);
                    state_visits_after_slot[SLOTS - 1] = state_visits_after_slot[SLOTS - 1]
                        .checked_add(current.len() as u64)
                        .ok_or(G41Q58ExactTablebaseError::StateBudget)?;
                    maximum_states_in_shard = maximum_states_in_shard.max(current.len() as u32);
                    for &state in &current {
                        if q29_projection(&layout, state)? != q29_coefficients {
                            continue;
                        }
                        exact_q29_projection_states = exact_q29_projection_states
                            .checked_add(1)
                            .ok_or(G41Q58ExactTablebaseError::StateBudget)?;
                        if let Some(profile) = q58_profile(&layout, state)? {
                            q58_budget_survivors = q58_budget_survivors
                                .checked_add(1)
                                .ok_or(G41Q58ExactTablebaseError::StateBudget)?;
                            first_survivor_profile.get_or_insert(profile);
                            let anti = q58_anti_profile(&layout, state, &anti_context)?
                                .ok_or(G41Q58ExactTablebaseError::SemanticMismatch)?;
                            anti_profiles.insert(anti, state)?;
                        }
                    }
                }
            }
        }
    }
    let mut records = anti_profiles.records();
    records.sort_unstable_by_key(|&(profile, _)| profile);
    let mut profiles = Vec::with_capacity(records.len());
    let mut witness_states = Vec::with_capacity(records.len());
    let mut hasher = Sha256::new();
    for (profile, witness_state) in records {
        hasher.update(profile.energy().to_le_bytes());
        for coordinate in 0..7 {
            hasher.update(profile.residual(coordinate).unwrap().to_le_bytes());
        }
        hasher.update(witness_state.to_le_bytes());
        profiles.push(profile);
        witness_states.push(witness_state);
    }
    Ok(G41Q58ReachableAntiProfileTablebase {
        report: G41Q58UnderQ29Report {
            mask,
            digits,
            q29_coefficients,
            q58_split_superset_states,
            q58_split_budget_survivors,
            shard_q29_coordinates: shard_q29_coordinates.map(|coordinate| coordinate as u8),
            projection_shards: shard_totals
                .into_iter()
                .try_fold(1_u32, |product, total| {
                    product.checked_mul(u32::from(total) + 1)
                })
                .ok_or(G41Q58ExactTablebaseError::StateBudget)?,
            slot_contribution_states,
            state_visits_after_slot,
            maximum_states_in_shard,
            exact_q29_projection_state_visits: exact_q29_projection_states,
            q58_budget_survivor_visits: q58_budget_survivors,
            exact_reachable_anti_profiles: profiles.len() as u32,
            reachable_anti_profile_digest: hasher.finalize().into(),
            first_survivor_profile,
            workspace_bytes: Workspace::bytes()
                + ProfileWorkspace::bytes()
                + 2 * (Workspace::MAX_STATES * std::mem::size_of::<u64>()) as u64
                + (prefix.len() * std::mem::size_of::<u64>()) as u64
                + (final_contributions.capacity()
                    * std::mem::size_of::<ProjectedContribution>()) as u64
                + (penultimate_contributions.capacity()
                    * std::mem::size_of::<ProjectedContribution>()) as u64
                + ProjectionSupport::bytes()
                + (profiles.capacity() * std::mem::size_of::<G41Q58AntiProfile>()) as u64
                + (witness_states.capacity() * std::mem::size_of::<u64>()) as u64,
            provenance: "exact q58 coefficient DP beneath one sealed q29 coefficient vector; sixteen four-bit multiplier-orbit lanes, one shared four-slot prefix sorted into disjoint exact four-coordinate ranges, presorted additive q29 projections for the final two disjoint slots, a fixed exact complement-support hash that filters the penultimate image, an exact final projection-range join, bounded iterative deduplication, the nonnegative per-block defect budget 523, and the canonical reachable anti-profile image are independently replayed from fine-orbit points; final state counts are visits because distinct prefix decompositions may converge",
        },
        profiles: profiles.into_boxed_slice(),
        witness_states: witness_states.into_boxed_slice(),
    })
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::allocation_test::tracked_allocations;
    use crate::cyclic_quotient_defects::QuotientCoefficients;

    #[test]
    fn q58_layout_and_q29_projection_match_direct_residue_counts() {
        let layout = compile_layout().unwrap();
        let inventory = compile_inventory().unwrap();
        let orbit = &inventory.large[4][3];
        let state = orbit_state(&layout, orbit).unwrap();
        let projected = q29_projection(&layout, state).unwrap();
        let mut direct = [0_u8; 29];
        for &point in &orbit.points[..usize::from(orbit.len)] {
            direct[usize::from(point) % 29] += 1;
        }
        assert_eq!(projected[0], direct[0]);
        for (class, coset) in Q29_COSETS.iter().enumerate() {
            assert_eq!(projected[class + 1], direct[coset[0]]);
        }
    }

    #[test]
    fn fixed_hash_workspace_hot_insert_and_reset_allocate_nothing() {
        let mut workspace = StateWorkspace::<256>::new();
        let (_, allocations) = tracked_allocations(|| {
            for key in 1..100 {
                assert!(workspace.insert(key).unwrap());
            }
            workspace.reset();
        });
        assert_eq!(allocations, 0);
    }

    #[test]
    fn exact_projection_complement_range_matches_direct_scan_without_allocating() {
        let entries = [
            ProjectedContribution {
                state: 10,
                projection: [0; 8],
            },
            ProjectedContribution {
                state: 20,
                projection: [1, 2, 3, 4, 5, 6, 7, 8],
            },
            ProjectedContribution {
                state: 21,
                projection: [1, 2, 3, 4, 5, 6, 7, 8],
            },
            ProjectedContribution {
                state: 30,
                projection: [2; 8],
            },
        ];
        let left = [3, 3, 3, 3, 3, 3, 3, 3];
        let target = [4, 5, 6, 7, 8, 9, 10, 11];
        let support = ProjectionSupport::compile(&entries).unwrap();
        let ((range, has_completion), allocations) = tracked_allocations(|| {
            let required = projection_complement(left, target).unwrap();
            (
                projected_contribution_range(&entries, required),
                support.contains(required),
            )
        });
        assert_eq!(range, 1..3);
        assert!(has_completion);
        assert_eq!(allocations, 0);
        assert!(support.contains(projection_complement(left, target).unwrap()));
        assert!(!projection_complement(target, left).is_some_and(|value| support.contains(value)));
        let direct: Vec<_> = entries
            .iter()
            .enumerate()
            .filter(|(_, entry)| {
                (0..8).all(|coordinate| {
                    left[coordinate] + entry.projection[coordinate] == target[coordinate]
                })
            })
            .map(|(index, _)| index)
            .collect();
        assert_eq!(direct, range.collect::<Vec<_>>());
        assert_eq!(projection_complement(target, left), None);
        assert_eq!(
            projection_complement_after_two([1; 8], [2; 8], [4; 8]),
            Some([1; 8])
        );
        assert_eq!(
            projection_complement_after_two([3; 8], [2; 8], [4; 8]),
            None
        );
    }

    #[test]
    fn anti_profile_workspace_deduplicates_without_allocating_hot() {
        let mut workspace = AntiProfileWorkspace::<256>::new();
        let first = G41Q58AntiProfile {
            energy: 17,
            residuals: ResidualTuple::from_array([1, 2, 3, 4, 5, 6, 7]),
        };
        let second = G41Q58AntiProfile {
            energy: 19,
            residuals: ResidualTuple::from_array([7, 6, 5, 4, 3, 2, 1]),
        };
        let (result, allocations) = tracked_allocations(|| {
            workspace.insert(first, 11)?;
            workspace.insert(second, 22)?;
            workspace.insert(first, 33)?;
            workspace.insert(first, 5)?;
            Ok::<_, G41Q58ExactTablebaseError>(())
        });
        result.unwrap();
        assert_eq!(workspace.touched.len(), 2);
        assert_eq!(allocations, 0);
        let mut records = workspace.records();
        records.sort_unstable_by_key(|&(profile, _)| profile);
        assert!(records.contains(&(first, 5)));
        assert!(records.contains(&(second, 22)));
    }

    #[test]
    fn original_replay_rejects_missing_fine_orbit_authority() {
        let witnesses = std::array::from_fn(|_| G41Q58AllocationWitnessReport {
            mask: 0,
            digits: 0,
            target_q58_class_coefficients: [0; CLASSES],
            states_after_slot: [0; SLOTS],
            orbit_masks: None,
            workspace_bytes: 0,
            provenance: "malformed test witness",
        });
        assert_eq!(
            replay_g41_q58_allocations_original(&witnesses),
            Err(G41Q58ExactTablebaseError::SemanticMismatch)
        );
    }

    #[test]
    fn original_replay_reconstructs_a_real_fine_allocation_before_rejecting_paf() {
        let layout = compile_layout().unwrap();
        let inventory = compile_inventory().unwrap();
        let mask = 20_u8;
        let digits = 2_215_340_u32;
        let orbit_masks = [29_u16, 109, 6_321, 134, 998, 5_663];
        assert_eq!(
            digit_counts(digits),
            orbit_masks.map(|orbits| orbits.count_ones() as u8)
        );
        let mut state = 0_u64;
        for slot in 0..SLOTS {
            if mask & (1 << slot) != 0 {
                state = add_states(state, orbit_state(&layout, &inventory.small[slot]).unwrap());
            }
            for orbit in 0..inventory.large_len[slot] {
                if orbit_masks[slot] & (1 << orbit) != 0 {
                    state = add_states(
                        state,
                        orbit_state(&layout, &inventory.large[slot][usize::from(orbit)]).unwrap(),
                    );
                }
            }
        }
        let target_q58_class_coefficients = std::array::from_fn(|class| coefficient(state, class));
        let witnesses = std::array::from_fn(|_| G41Q58AllocationWitnessReport {
            mask,
            digits,
            target_q58_class_coefficients,
            states_after_slot: [0; SLOTS],
            orbit_masks: Some(orbit_masks),
            workspace_bytes: 0,
            provenance: "direct replay test witness",
        });
        let replay = replay_g41_q58_allocations_original(&witnesses).unwrap();
        assert_eq!(replay.row_weights, [260; 4]);
        assert_eq!(replay.nonzero_shift_defect_sums.len(), 521);
        assert!(!replay.all_nonzero_defects_equal_523);
    }

    #[test]
    fn packed_q58_state_matches_direct_word_quotient_oracle() {
        let layout = compile_layout().unwrap();
        let inventory = compile_inventory().unwrap();
        let mask = 20_u8;
        let orbit_masks = [29_u16, 109, 6_321, 134, 998, 5_663];
        let mut state = 0_u64;
        let mut word = [0_u8; 522];
        for slot in 0..SLOTS {
            if mask & (1 << slot) != 0 {
                let orbit = &inventory.small[slot];
                state = add_states(state, orbit_state(&layout, orbit).unwrap());
                for &point in &orbit.points[..usize::from(orbit.len)] {
                    word[usize::from(point)] = 1;
                }
            }
            for orbit in 0..inventory.large_len[slot] {
                if orbit_masks[slot] & (1 << orbit) != 0 {
                    let orbit = &inventory.large[slot][usize::from(orbit)];
                    state = add_states(state, orbit_state(&layout, orbit).unwrap());
                    for &point in &orbit.points[..usize::from(orbit.len)] {
                        word[usize::from(point)] = 1;
                    }
                }
            }
        }
        let packed = q58_defects(&layout, state).unwrap();
        let quotient = QuotientCoefficients::<58>::compile(&word).unwrap();
        let mut direct = [0_i32; 58];
        quotient.defects_into(&mut direct).unwrap();
        for coordinate in 0..PROFILE_COORDINATES {
            assert_eq!(
                packed[coordinate],
                direct[usize::from(layout.representatives[coordinate + 1])] as u32
            );
        }
        let weighted: u32 = (0..PROFILE_COORDINATES)
            .map(|coordinate| u32::from(layout.lengths[coordinate + 1]) * packed[coordinate])
            .sum();
        let coefficients = quotient.values();
        let zero: u32 = coefficients
            .iter()
            .map(|&value| u32::from(value) * u32::from(value))
            .sum();
        let row_sum: u32 = coefficients.iter().map(|&value| u32::from(value)).sum();
        assert_eq!(weighted, MODULUS as u32 * zero - row_sum * row_sum);
    }

    #[test]
    fn anti_periodic_profile_reconstructs_all_q58_defects_directly() {
        let layout = compile_layout().unwrap();
        let inventory = compile_inventory().unwrap();
        let mask = 20_u8;
        let orbit_masks = [29_u16, 109, 6_321, 134, 998, 5_663];
        let mut state = 0_u64;
        for slot in 0..SLOTS {
            if mask & (1 << slot) != 0 {
                state = add_states(state, orbit_state(&layout, &inventory.small[slot]).unwrap());
            }
            for orbit in 0..inventory.large_len[slot] {
                if orbit_masks[slot] & (1 << orbit) != 0 {
                    state = add_states(
                        state,
                        orbit_state(&layout, &inventory.large[slot][usize::from(orbit)]).unwrap(),
                    );
                }
            }
        }
        let projected = q29_projection(&layout, state).unwrap();
        let context = Q58AntiContext::compile(projected).unwrap();
        let anti = q58_anti_terms(&layout, state, &context).unwrap();
        assert_eq!(anti, q58_anti_terms_direct(&layout, state).unwrap());
        let values: [i32; 58] = std::array::from_fn(|residue| {
            i32::from(coefficient(state, usize::from(layout.class_of[residue])))
        });
        let autocorrelation = |shift: usize| -> i32 {
            (0..58)
                .map(|residue| values[residue] * values[(residue + shift) % 58])
                .sum()
        };
        let zero = autocorrelation(0);
        assert_eq!(i32::from(anti.energy()), zero - autocorrelation(29));
        let difference: [i32; 29] = std::array::from_fn(|residue| {
            if residue & 1 == 0 {
                values[residue] - values[residue + 29]
            } else {
                values[residue + 29] - values[residue]
            }
        });
        let spectral_sum: i32 = difference.iter().sum();
        assert_eq!(
            anti.zero_frequency_square().unwrap() as i32,
            spectral_sum * spectral_sum
        );
        let mut quotient = [0_i32; 29];
        for residue in 0..29 {
            quotient[residue] = values[residue] + values[residue + 29];
        }
        let quotient_zero: i32 = quotient.iter().map(|&value| value * value).sum();
        for coordinate in 0..7 {
            let shift = Q29_COSETS[coordinate][0];
            let quotient_shift: i32 = (0..29)
                .map(|residue| quotient[residue] * quotient[(residue + shift) % 29])
                .sum();
            let quotient_defect = quotient_zero - quotient_shift;
            let residual = i32::from(anti.residual(coordinate).unwrap());
            let plus_square: i32 = (0..29)
                .map(|residue| {
                    let value = difference[residue] + difference[(residue + shift) % 29];
                    value * value
                })
                .sum();
            let minus_square: i32 = (0..29)
                .map(|residue| {
                    let value = difference[residue] - difference[(residue + shift) % 29];
                    value * value
                })
                .sum();
            assert_eq!(plus_square, 2 * (i32::from(anti.energy()) + residual));
            assert_eq!(minus_square, 2 * (i32::from(anti.energy()) - residual));
            let sign = if shift & 1 == 0 { 1 } else { -1 };
            assert_eq!(
                2 * (zero - autocorrelation(shift)),
                quotient_defect + i32::from(anti.energy()) - sign * residual
            );
            assert_eq!(
                2 * (zero - autocorrelation(shift + 29)),
                quotient_defect + i32::from(anti.energy()) + sign * residual
            );
        }
    }

    #[test]
    fn fused_seven_residual_family_matches_exhaustive_small_split_box_without_allocating() {
        let layout = compile_layout().unwrap();
        let coefficients = [1_u8; 8];
        let context = Q58AntiContext::compile(coefficients).unwrap();
        let mut states = 0_u32;
        let (result, allocations) = tracked_allocations(|| {
            enumerate_q58_split_states(&layout, coefficients, |state| {
                assert_eq!(
                    q58_anti_terms(&layout, state, &context)?,
                    q58_anti_terms_direct(&layout, state)?
                );
                states += 1;
                Ok(())
            })
        });
        assert_eq!(result.unwrap(), 256);
        assert_eq!(states, 256);
        assert_eq!(allocations, 0);
    }

    #[test]
    fn lane_support_is_deterministic_and_hot_reads_allocate_nothing() {
        let support = compile_g41_q58_lane_support(20, 2_215_340).unwrap();
        assert_eq!(
            support,
            compile_g41_q58_lane_support(20, 2_215_340).unwrap()
        );
        assert!(support.lane_value_masks.iter().all(|&mask| mask != 0));
        let (_, allocations) = tracked_allocations(|| {
            for _ in 0..10_000 {
                for &mask in &support.lane_value_masks {
                    std::hint::black_box(mask & std::hint::black_box(0x155));
                }
            }
        });
        assert_eq!(allocations, 0);
    }

    #[test]
    fn anti_energy_support_convolves_exact_difference_squares_without_allocating() {
        let mut difference_masks = [[0_u16; 19]; 8];
        for coordinate in 0..8 {
            difference_masks[coordinate][1] = 1 << 1;
        }
        let support = G41Q58LaneSupport {
            mask: 0,
            digits: 0,
            lane_value_masks: [0b11; CLASSES],
            difference_masks,
            workspace_bytes: 0,
            provenance: "unit-test direct difference support",
        };
        let expected_energy = 1 + 7 * 4;
        let fibre = support.q58_anti_energy_support([1; 8]);
        assert_eq!(fibre[expected_energy / 64], 1 << (expected_energy % 64));
        assert!(fibre
            .iter()
            .enumerate()
            .all(|(word, &bits)| word == expected_energy / 64 || bits == 0));
        assert_eq!(support.q58_anti_energy_support([19; 8]), [0; 9]);
        let (_, allocations) = tracked_allocations(|| {
            for _ in 0..10_000 {
                std::hint::black_box(support.q58_anti_energy_support(std::hint::black_box([1; 8])));
            }
        });
        assert_eq!(allocations, 0);
    }

    #[test]
    fn lane_energy_support_contains_every_direct_one_orbit_image() {
        let layout = compile_layout().unwrap();
        let inventory = compile_inventory().unwrap();
        let support = compile_g41_q58_lane_support(0, 1).unwrap();
        for orbit in &inventory.large[0][..usize::from(inventory.large_len[0])] {
            let state = orbit_state(&layout, orbit).unwrap();
            let q29 = q29_projection(&layout, state).unwrap();
            let context = Q58AntiContext::compile(q29).unwrap();
            let energy = usize::from(q58_anti_terms(&layout, state, &context).unwrap().energy());
            let fibre = support.q58_anti_energy_support(q29);
            assert_ne!(fibre[energy / 64] & (1_u64 << (energy % 64)), 0);
        }
    }
}
