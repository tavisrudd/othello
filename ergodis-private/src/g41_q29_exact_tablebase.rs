//! Exact q29 block-profile tablebases beneath a common g41 quotient interface.

use serde::Serialize;
use sha2::{Digest, Sha256};
use thiserror::Error;

use crate::g41_q29_evolve::{
    compile_inventory, digit_counts, FineInventory, FineOrbit, G41Q29EvolveError, Q29_COSETS,
};

const SLOTS: usize = 6;
const COEFFICIENT_RADIX_BITS: u32 = 5;
const COEFFICIENT_MASK: u64 = (1 << COEFFICIENT_RADIX_BITS) - 1;
const MAX_COEFFICIENT: u8 = 18;
const DEFECT_TARGET: u32 = 523;
const LARGE_ORBITS: [u8; 6] = [7, 7, 14, 14, 14, 14];
const DIGIT_SHIFTS: [u32; 6] = [0, 3, 6, 10, 14, 18];
const MAX_PROFILE_PREIMAGES: usize = 4096;

#[repr(C)]
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq, PartialOrd, Ord, Serialize)]
pub struct G41Q29ExactProfile {
    low: u64,
    high: u64,
}

const _: () = assert!(
    std::mem::size_of::<G41Q29ExactProfile>() == 16
        && std::mem::align_of::<G41Q29ExactProfile>() == 8
);

impl G41Q29ExactProfile {
    pub(crate) fn from_coordinates(values: [u16; 7]) -> Self {
        Self {
            low: u64::from(values[0])
                | (u64::from(values[1]) << 14)
                | (u64::from(values[2]) << 28)
                | (u64::from(values[3]) << 42),
            high: u64::from(values[4])
                | (u64::from(values[5]) << 14)
                | (u64::from(values[6]) << 28),
        }
    }

    pub fn coordinate(self, index: usize) -> u16 {
        if index < 4 {
            ((self.low >> (14 * index)) & 0x3fff) as u16
        } else {
            ((self.high >> (14 * (index - 4))) & 0x3fff) as u16
        }
    }

    pub(crate) fn packed_words(self) -> [u64; 2] {
        [self.low, self.high]
    }

    pub(crate) fn from_packed_words(words: [u64; 2]) -> Self {
        Self {
            low: words[0],
            high: words[1],
        }
    }
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q29ExactBlockReport {
    pub requested_mask: u8,
    pub requested_digits: u32,
    pub mask: u8,
    pub digits: u32,
    pub complement_canonicalized: bool,
    pub digit_counts: [u8; 6],
    pub slot_contribution_states: [u32; 6],
    pub coefficient_states_after_slot: [u32; 6],
    pub exact_coefficient_states: u32,
    pub exact_correlation_profiles: u32,
    pub profile_digest: [u8; 32],
    pub profiles_exceeding_defect_budget: u32,
    pub workspace_bytes: u64,
    pub provenance: &'static str,
}

pub struct G41Q29ExactBlockTablebase {
    pub report: G41Q29ExactBlockReport,
    pub profiles: Box<[G41Q29ExactProfile]>,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q29CoefficientImageReport {
    pub requested_mask: u8,
    pub requested_digits: u32,
    pub mask: u8,
    pub digits: u32,
    pub complement_canonicalized: bool,
    pub digit_counts: [u8; 6],
    pub slot_contribution_states: [u32; 6],
    pub coefficient_states_after_slot: [u32; 6],
    pub exact_coefficient_states: u32,
    pub workspace_bytes: u64,
    pub provenance: &'static str,
}

struct G41Q29CoefficientImage {
    report: G41Q29CoefficientImageReport,
    states: Vec<u64>,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q29RowSupersetReport {
    pub row_sum: u16,
    pub exact_coefficient_vectors: u64,
    pub exact_correlation_profiles: u32,
    pub profile_digest: [u8; 32],
    pub profiles_exceeding_defect_budget: u64,
    pub workspace_bytes: u64,
    pub provenance: &'static str,
}

pub struct G41Q29RowSupersetTablebase {
    pub report: G41Q29RowSupersetReport,
    pub profiles: Box<[G41Q29ExactProfile]>,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q29FixedZeroDefectFibreReport {
    pub row_sum: u16,
    pub zero_coefficient: u8,
    pub coefficient_vectors: u64,
    pub admissible_coefficient_vectors: u32,
    pub exact_correlation_profiles: u32,
    pub singleton_fibres: u32,
    pub complement_pair_fibres: u32,
    pub maximum_fibre: u8,
    pub profile_digest: [u8; 32],
    pub workspace_bytes: u64,
    pub provenance: &'static str,
}

pub struct G41Q29FixedZeroDefectTablebase {
    pub report: G41Q29FixedZeroDefectFibreReport,
    entries: Box<[ProfileState]>,
}

#[derive(Clone, Copy, Debug, Default, Serialize, PartialEq, Eq)]
pub struct G41Q29ProfileCoefficientFibre {
    pub coefficient_values: [[u8; 8]; 2],
    pub len: u8,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q29OrbitSignatureReport {
    pub small_states: [u64; 6],
    pub large_states: [[u64; 14]; 6],
    pub large_len: [u8; 6],
    pub provenance: &'static str,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q29AggregateBlockReport {
    pub signature: [u8; 4],
    pub row_sum: u16,
    pub group_contribution_states: [u32; 3],
    pub coefficient_states_after_group: [u32; 3],
    pub exact_coefficient_states: u32,
    pub exact_correlation_profiles: u32,
    pub profile_digest: [u8; 32],
    pub profiles_exceeding_defect_budget: u32,
    pub workspace_bytes: u64,
    pub provenance: &'static str,
}

pub struct G41Q29AggregateBlockTablebase {
    pub report: G41Q29AggregateBlockReport,
    pub profiles: Box<[G41Q29ExactProfile]>,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q29BlockProfileLiftReport {
    pub mask: u8,
    pub digits: u32,
    pub target_profile: [u16; 7],
    pub coefficient_values: [u8; 8],
    pub orbit_masks: [u16; 6],
    pub coefficient_states_examined: u32,
    pub coefficient_preimages: u32,
    pub decomposition_fibres: u64,
    pub decomposition_states: u32,
    pub decomposition_workspace_bytes: u64,
    pub provenance: &'static str,
}

#[derive(Clone, Debug, Error, PartialEq, Eq)]
pub enum G41Q29ExactTablebaseError {
    #[error("g41 q29 exact coefficient tablebase exceeded its fixed workspace")]
    StateBudget,
    #[error("g41 q29 exact coefficient tablebase semantic invariant failed")]
    SemanticMismatch,
    #[error(transparent)]
    Evolve(#[from] G41Q29EvolveError),
}

#[derive(Clone, Copy, Default)]
struct LocalSlotChoice {
    values: [u8; 6],
    code: u16,
}

struct LocalSlotChoices {
    values: [LocalSlotChoice; 324],
    len: u16,
}

pub struct G41Q29DirectLiftWorkspace {
    digits: u32,
    counts: [u8; 6],
    inventory: FineInventory,
    state_count: usize,
    predecessors: Vec<u16>,
    predecessor_touched: Vec<u32>,
    current: Vec<u32>,
    next: Vec<u32>,
    current_counts: Vec<u64>,
    next_counts: Vec<u64>,
}

/// Sealed reusable result of the mask-independent large-orbit decomposition.
#[repr(C)]
pub struct G41Q29CoefficientDecomposition {
    digits: u32,
    nonzero_coefficients: [u8; 7],
    orbit_masks: [u16; 6],
    decomposition_fibres: u64,
    decomposition_states: u32,
    decomposition_workspace_bytes: u64,
}

const _: () = assert!(
    std::mem::size_of::<G41Q29CoefficientDecomposition>() == 48
        && std::mem::align_of::<G41Q29CoefficientDecomposition>() == 8
);

impl G41Q29DirectLiftWorkspace {
    pub fn new(digits: u32) -> Result<Self, G41Q29ExactTablebaseError> {
        const MAX_DECOMPOSITION_STATES: usize = 8 * 8 * 15 * 15 * 15 * 15;
        let inventory = compile_inventory()?;
        let counts = digit_counts(digits);
        if (0..SLOTS).any(|slot| counts[slot] > inventory.large_len[slot]) {
            return Err(G41Q29ExactTablebaseError::SemanticMismatch);
        }
        let state_count = counts
            .map(|count| usize::from(count) + 1)
            .into_iter()
            .try_fold(1_usize, usize::checked_mul)
            .ok_or(G41Q29ExactTablebaseError::StateBudget)?;
        if state_count == 0 || state_count > MAX_DECOMPOSITION_STATES {
            return Err(G41Q29ExactTablebaseError::StateBudget);
        }
        Ok(Self {
            digits,
            counts,
            inventory,
            state_count,
            predecessors: vec![u16::MAX; 8 * state_count],
            predecessor_touched: Vec::with_capacity(8 * state_count),
            current: Vec::with_capacity(state_count),
            next: Vec::with_capacity(state_count),
            current_counts: vec![0_u64; state_count],
            next_counts: vec![0_u64; state_count],
        })
    }

    pub fn bytes(&self) -> u64 {
        ((self.predecessors.capacity() * std::mem::size_of::<u16>()
            + self.predecessor_touched.capacity() * std::mem::size_of::<u32>()
            + (self.current.capacity() + self.next.capacity()) * std::mem::size_of::<u32>())
            + (self.current_counts.capacity() + self.next_counts.capacity())
                * std::mem::size_of::<u64>()) as u64
    }
}

impl LocalSlotChoices {
    fn as_slice(&self) -> &[LocalSlotChoice] {
        &self.values[..usize::from(self.len)]
    }
}

fn encode_slot_counts(values: [u8; 6], radices: [u32; 6]) -> u32 {
    let mut key = 0_u32;
    let mut stride = 1_u32;
    for slot in 0..6 {
        key += u32::from(values[slot]) * stride;
        stride *= radices[slot];
    }
    key
}

fn decode_slot_counts(mut key: u32, radices: [u32; 6]) -> [u8; 6] {
    std::array::from_fn(|slot| {
        let value = (key % radices[slot]) as u8;
        key /= radices[slot];
        value
    })
}

fn local_slot_choices(target: u8) -> LocalSlotChoices {
    let mut output = LocalSlotChoices {
        values: [LocalSlotChoice::default(); 324],
        len: 0,
    };
    for first in 0_u8..=1 {
        for second in 0_u8..=1 {
            for third in 0_u8..=2 {
                for fourth in 0_u8..=2 {
                    for fifth in 0_u8..=2 {
                        for sixth in 0_u8..=2 {
                            let values = [first, second, third, fourth, fifth, sixth];
                            if first + second + third + fourth + 3 * fifth + 3 * sixth != target {
                                continue;
                            }
                            let code = values
                                .iter()
                                .enumerate()
                                .map(|(slot, &value)| u16::from(value) << (2 * slot))
                                .fold(0_u16, |left, right| left | right);
                            output.values[usize::from(output.len)] =
                                LocalSlotChoice { values, code };
                            output.len += 1;
                        }
                    }
                }
            }
        }
    }
    output
}

type SlotReconstruction = ([u16; 6], u64, u32, u64);

fn try_reconstruct_slot_masks_with_workspace<const SPARSE_RESET: bool>(
    target_state: u64,
    workspace: &mut G41Q29DirectLiftWorkspace,
) -> Result<Option<SlotReconstruction>, G41Q29ExactTablebaseError> {
    let workspace_bytes = workspace.bytes();
    let inventory = &workspace.inventory;
    let counts = workspace.counts;
    let radices = counts.map(|count| u32::from(count) + 1);
    let state_count = workspace.state_count;
    if SPARSE_RESET {
        for &index in &workspace.predecessor_touched {
            workspace.predecessors[index as usize] = u16::MAX;
        }
        for &state in &workspace.current {
            workspace.current_counts[state as usize] = 0;
        }
        for &state in &workspace.next {
            workspace.next_counts[state as usize] = 0;
        }
    } else {
        workspace.predecessors.fill(u16::MAX);
        workspace.current_counts.fill(0);
        workspace.next_counts.fill(0);
    }
    workspace.predecessor_touched.clear();
    workspace.current.clear();
    workspace.next.clear();
    let predecessors = &mut workspace.predecessors;
    let predecessor_touched = &mut workspace.predecessor_touched;
    let current = &mut workspace.current;
    let next = &mut workspace.next;
    let current_counts = &mut workspace.current_counts;
    let next_counts = &mut workspace.next_counts;
    current.push(0_u32);
    current_counts[0] = 1;
    let mut decomposition_states = 1_u32;
    for coordinate in 0..7 {
        if SPARSE_RESET {
            for &state in next.iter() {
                next_counts[state as usize] = 0;
            }
        } else {
            next_counts.fill(0);
        }
        next.clear();
        let target = coefficient(target_state, coordinate + 1);
        let choices = local_slot_choices(target);
        for &state in current.iter() {
            let used = decode_slot_counts(state, radices);
            for choice in choices.as_slice() {
                if (0..6).any(|slot| used[slot] + choice.values[slot] > counts[slot]) {
                    continue;
                }
                let combined = std::array::from_fn(|slot| used[slot] + choice.values[slot]);
                let key = encode_slot_counts(combined, radices);
                next_counts[key as usize] = next_counts[key as usize]
                    .checked_add(current_counts[state as usize])
                    .ok_or(G41Q29ExactTablebaseError::StateBudget)?;
                let predecessor_index = (coordinate + 1) * state_count + key as usize;
                let predecessor = &mut predecessors[predecessor_index];
                if *predecessor == u16::MAX {
                    *predecessor = choice.code;
                    if SPARSE_RESET {
                        predecessor_touched.push(predecessor_index as u32);
                    }
                    next.push(key);
                    decomposition_states = decomposition_states
                        .checked_add(1)
                        .ok_or(G41Q29ExactTablebaseError::StateBudget)?;
                }
            }
        }
        std::mem::swap(current, next);
        std::mem::swap(current_counts, next_counts);
        if current.is_empty() {
            return Ok(None);
        }
    }
    let final_key = encode_slot_counts(counts, radices);
    if predecessors[7 * state_count + final_key as usize] == u16::MAX {
        return Ok(None);
    }
    let decomposition_fibres = current_counts[final_key as usize];
    if decomposition_fibres == 0 {
        return Err(G41Q29ExactTablebaseError::SemanticMismatch);
    }
    let mut per_slot = [[0_u8; 7]; 6];
    let mut used = counts;
    for depth in (1..=7).rev() {
        let key = encode_slot_counts(used, radices);
        let code = predecessors[depth * state_count + key as usize];
        if code == u16::MAX {
            return Err(G41Q29ExactTablebaseError::SemanticMismatch);
        }
        for slot in 0..6 {
            let value = ((code >> (2 * slot)) & 3) as u8;
            per_slot[slot][depth - 1] = value;
            used[slot] = used[slot]
                .checked_sub(value)
                .ok_or(G41Q29ExactTablebaseError::SemanticMismatch)?;
        }
    }
    if used != [0; 6] {
        return Err(G41Q29ExactTablebaseError::SemanticMismatch);
    }

    let scales = [1_u8, 1, 1, 1, 3, 3];
    let mut masks = [0_u16; 6];
    for slot in 0..6 {
        for class in 0..7 {
            let mut needed = per_slot[slot][class];
            for orbit in 0..inventory.large_len[slot] {
                let state = orbit_state(&inventory.large[slot][orbit as usize])?;
                let matches = coefficient(state, class + 1) == scales[slot]
                    && (1..8).all(|coordinate| {
                        coordinate == class + 1 || coefficient(state, coordinate) == 0
                    });
                if matches && needed != 0 {
                    masks[slot] |= 1_u16 << orbit;
                    needed -= 1;
                }
            }
            if needed != 0 {
                return Err(G41Q29ExactTablebaseError::SemanticMismatch);
            }
        }
        if masks[slot].count_ones() != u32::from(counts[slot]) {
            return Err(G41Q29ExactTablebaseError::SemanticMismatch);
        }
    }
    Ok(Some((
        masks,
        decomposition_fibres,
        decomposition_states,
        workspace_bytes,
    )))
}

fn try_reconstruct_slot_masks(
    counts: [u8; 6],
    target_state: u64,
) -> Result<Option<SlotReconstruction>, G41Q29ExactTablebaseError> {
    let mut workspace = G41Q29DirectLiftWorkspace::new(pack_digit_counts(counts))?;
    try_reconstruct_slot_masks_with_workspace::<true>(target_state, &mut workspace)
}

fn reconstruct_slot_masks(
    counts: [u8; 6],
    target_state: u64,
) -> Result<SlotReconstruction, G41Q29ExactTablebaseError> {
    try_reconstruct_slot_masks(counts, target_state)?
        .ok_or(G41Q29ExactTablebaseError::SemanticMismatch)
}

struct PackedStateWorkspace<const CAPACITY: usize> {
    keys: Box<[u64]>,
    occupied: Box<[u8]>,
    touched: Vec<u32>,
}

struct ExactProfileWorkspace<const CAPACITY: usize> {
    keys: Box<[G41Q29ExactProfile]>,
    occupied: Box<[u8]>,
    touched: Vec<u32>,
}

impl<const CAPACITY: usize> ExactProfileWorkspace<CAPACITY> {
    const MAX_STATES: usize = 3 * CAPACITY / 4;

    fn new() -> Self {
        assert!(CAPACITY.is_power_of_two());
        Self {
            keys: vec![G41Q29ExactProfile::default(); CAPACITY].into_boxed_slice(),
            occupied: vec![0; CAPACITY].into_boxed_slice(),
            touched: Vec::with_capacity(Self::MAX_STATES),
        }
    }

    #[inline(always)]
    fn insert(&mut self, key: G41Q29ExactProfile) -> Result<bool, G41Q29ExactTablebaseError> {
        let mut hash = key.low ^ key.high.rotate_left(23);
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
                    return Err(G41Q29ExactTablebaseError::StateBudget);
                }
                self.occupied[slot] = 1;
                self.keys[slot] = key;
                self.touched.push(slot as u32);
                return Ok(true);
            }
            slot = (slot + 1) & (CAPACITY - 1);
        }
    }

    const fn bytes() -> u64 {
        (CAPACITY * (std::mem::size_of::<G41Q29ExactProfile>() + std::mem::size_of::<u8>())
            + Self::MAX_STATES * std::mem::size_of::<u32>()) as u64
    }
}

#[repr(C)]
#[derive(Clone, Copy)]
struct FourCounts {
    values: [u8; 4],
    sum: u8,
    _pad: [u8; 3],
}

const _: () = assert!(std::mem::size_of::<FourCounts>() == 8);

#[repr(C)]
#[derive(Clone, Copy)]
struct ThreeCounts {
    values: [u8; 3],
    sum: u8,
}

const _: () = assert!(std::mem::size_of::<ThreeCounts>() == 4);

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
struct ProfileState {
    profile: G41Q29ExactProfile,
    state: u64,
}

const _: () = assert!(std::mem::size_of::<ProfileState>() == 24);

impl G41Q29FixedZeroDefectTablebase {
    pub fn coefficient_fibre(
        &self,
        profile: G41Q29ExactProfile,
    ) -> Result<G41Q29ProfileCoefficientFibre, G41Q29ExactTablebaseError> {
        let start = self
            .entries
            .partition_point(|entry| entry.profile < profile);
        let end = self
            .entries
            .partition_point(|entry| entry.profile <= profile);
        let mut output = G41Q29ProfileCoefficientFibre::default();
        if end - start > output.coefficient_values.len() {
            return Err(G41Q29ExactTablebaseError::SemanticMismatch);
        }
        output.len = (end - start) as u8;
        for (target, entry) in output.coefficient_values[..usize::from(output.len)]
            .iter_mut()
            .zip(&self.entries[start..end])
        {
            *target = std::array::from_fn(|coordinate| coefficient(entry.state, coordinate));
        }
        Ok(output)
    }
}

impl<const CAPACITY: usize> PackedStateWorkspace<CAPACITY> {
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
    fn insert(&mut self, key: u64) -> Result<bool, G41Q29ExactTablebaseError> {
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
                    return Err(G41Q29ExactTablebaseError::StateBudget);
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

fn orbit_state(orbit: &FineOrbit) -> Result<u64, G41Q29ExactTablebaseError> {
    let mut values = [0_u8; 8];
    values[0] = orbit.residue_histogram[0];
    for (class, coset) in Q29_COSETS.iter().enumerate() {
        let value = orbit.residue_histogram[coset[0]];
        if coset
            .iter()
            .any(|&coordinate| orbit.residue_histogram[coordinate] != value)
        {
            return Err(G41Q29ExactTablebaseError::SemanticMismatch);
        }
        values[class + 1] = value;
    }
    pack_coefficients(values)
}

pub fn g41_q29_orbit_signature() -> Result<G41Q29OrbitSignatureReport, G41Q29ExactTablebaseError> {
    let inventory = compile_inventory()?;
    let mut small_states = [0_u64; 6];
    let mut large_states = [[0_u64; 14]; 6];
    for slot in 0..SLOTS {
        small_states[slot] = orbit_state(&inventory.small[slot])?;
        for orbit in 0..inventory.large_len[slot] {
            large_states[slot][usize::from(orbit)] =
                orbit_state(&inventory.large[slot][usize::from(orbit)])?;
        }
        large_states[slot][..usize::from(inventory.large_len[slot])].sort_unstable();
    }
    Ok(G41Q29OrbitSignatureReport {
        small_states,
        large_states,
        large_len: inventory.large_len,
        provenance: "sealed q29 coefficient-state signatures of the six fine-orbit slot families; diagnostic until a structural slot-aggregation theorem is checked",
    })
}

fn pack_coefficients(values: [u8; 8]) -> Result<u64, G41Q29ExactTablebaseError> {
    let mut state = 0_u64;
    for (coordinate, value) in values.into_iter().enumerate() {
        if value > MAX_COEFFICIENT {
            return Err(G41Q29ExactTablebaseError::SemanticMismatch);
        }
        state |= u64::from(value) << (COEFFICIENT_RADIX_BITS * coordinate as u32);
    }
    Ok(state)
}

fn coefficient(state: u64, coordinate: usize) -> u8 {
    ((state >> (COEFFICIENT_RADIX_BITS * coordinate as u32)) & COEFFICIENT_MASK) as u8
}

fn pack_digit_counts(counts: [u8; 6]) -> u32 {
    let mut packed = 0_u32;
    for slot in 0..SLOTS {
        packed |= u32::from(counts[slot]) << DIGIT_SHIFTS[slot];
    }
    packed
}

/// Tests a complete bipartite degree sequence with a uniform per-column cap
/// for each row. By max-flow/min-cut, it is enough to check the seven largest
/// column-prefix demands against `sum_i min(row_i, cap_i * prefix)`.
fn bounded_degree_sequence_feasible<const ROWS: usize>(
    mut columns: [u8; 7],
    rows: [u8; ROWS],
    caps: [u8; ROWS],
) -> bool {
    if rows.iter().zip(caps).any(|(&row, cap)| row > 7 * cap)
        || columns.iter().map(|&value| u16::from(value)).sum::<u16>()
            != rows.iter().map(|&value| u16::from(value)).sum::<u16>()
    {
        return false;
    }
    columns.sort_unstable_by(|left, right| right.cmp(left));
    let mut demand = 0_u16;
    for prefix in 1_u8..=7 {
        demand += u16::from(columns[usize::from(prefix - 1)]);
        let capacity = rows
            .iter()
            .zip(caps)
            .map(|(&row, cap)| u16::from(row.min(cap * prefix)))
            .sum::<u16>();
        if demand > capacity {
            return false;
        }
    }
    true
}

/// Structural feasibility predicate for the six-slot q29 decomposition.
///
/// This enumerates only the seven aggregate weight-three column counts. For
/// each choice, two capacitated Gale--Ryser tests decide whether the four
/// unit-weight rows and two weight-three rows exist. It allocates no memory and
/// does not construct a witness; callers must retain the constructive DP until
/// differential proof promotion is complete.
pub fn g41_q29_degree_sequence_decomposition_feasible(
    digits: u32,
    coefficient_values: [u8; 8],
) -> Result<bool, G41Q29ExactTablebaseError> {
    let counts = digit_counts(digits);
    if (0..SLOTS).any(|slot| counts[slot] > LARGE_ORBITS[slot])
        || coefficient_values
            .iter()
            .any(|&value| value > MAX_COEFFICIENT)
    {
        return Err(G41Q29ExactTablebaseError::SemanticMismatch);
    }
    let mut lower = [0_u8; 7];
    let mut widths = [0_u8; 7];
    let mut combinations = 1_u32;
    for coordinate in 0..7 {
        let coefficient = coefficient_values[coordinate + 1];
        lower[coordinate] = coefficient.saturating_sub(6).div_ceil(3);
        let upper = (coefficient / 3).min(4);
        if lower[coordinate] > upper {
            return Ok(false);
        }
        widths[coordinate] = upper - lower[coordinate] + 1;
        combinations = combinations
            .checked_mul(u32::from(widths[coordinate]))
            .ok_or(G41Q29ExactTablebaseError::StateBudget)?;
    }
    let high_total = counts[4] + counts[5];
    for mut code in 0..combinations {
        let mut high = [0_u8; 7];
        let mut unit = [0_u8; 7];
        let mut total = 0_u8;
        for coordinate in 0..7 {
            high[coordinate] = lower[coordinate] + (code % u32::from(widths[coordinate])) as u8;
            code /= u32::from(widths[coordinate]);
            total += high[coordinate];
            unit[coordinate] = coefficient_values[coordinate + 1] - 3 * high[coordinate];
        }
        if total != high_total
            || !bounded_degree_sequence_feasible(high, [counts[4], counts[5]], [2, 2])
            || !bounded_degree_sequence_feasible(
                unit,
                [counts[0], counts[1], counts[2], counts[3]],
                [1, 1, 2, 2],
            )
        {
            continue;
        }
        return Ok(true);
    }
    Ok(false)
}

pub fn complement_g41_q29_block_spec(
    mask: u8,
    digits: u32,
) -> Result<(u8, u32), G41Q29ExactTablebaseError> {
    let counts = digit_counts(digits);
    if (0..SLOTS).any(|slot| counts[slot] > LARGE_ORBITS[slot]) {
        return Err(G41Q29ExactTablebaseError::SemanticMismatch);
    }
    let complement = std::array::from_fn(|slot| LARGE_ORBITS[slot] - counts[slot]);
    Ok((mask ^ 63, pack_digit_counts(complement)))
}

/// Translate a multiplier-invariant length-522 block by 261.  This swaps the
/// three pairs of q18 source-orbit rows and fixes every q29 coefficient.
pub fn translate_261_g41_q29_block_spec(
    mask: u8,
    digits: u32,
) -> Result<(u8, u32), G41Q29ExactTablebaseError> {
    let mut counts = digit_counts(digits);
    if mask >= 64 || (0..SLOTS).any(|slot| counts[slot] > LARGE_ORBITS[slot]) {
        return Err(G41Q29ExactTablebaseError::SemanticMismatch);
    }
    for first in [0, 2, 4] {
        counts.swap(first, first + 1);
    }
    let translated_mask = ((mask & 0b01_01_01) << 1) | ((mask & 0b10_10_10) >> 1);
    Ok((translated_mask, pack_digit_counts(counts)))
}

/// Canonicalize under the existing coefficient complement and the independent
/// 261-translation.  The returned q29 coefficient/profile semantics need no
/// transport because 261 is zero modulo 29.
pub fn translation_canonical_g41_q29_block_spec(
    mask: u8,
    digits: u32,
) -> Result<(u8, u32), G41Q29ExactTablebaseError> {
    let direct = canonical_g41_q29_block_spec(mask, digits)?;
    let translated = translate_261_g41_q29_block_spec(mask, digits)?;
    let translated = canonical_g41_q29_block_spec(translated.0, translated.1)?;
    Ok((direct.0, direct.1).min((translated.0, translated.1)))
}

pub fn canonical_g41_q29_block_spec(
    mask: u8,
    digits: u32,
) -> Result<(u8, u32, bool), G41Q29ExactTablebaseError> {
    let counts = digit_counts(digits);
    if (0..SLOTS).any(|slot| counts[slot] > LARGE_ORBITS[slot]) {
        return Err(G41Q29ExactTablebaseError::SemanticMismatch);
    }
    if (mask & 3).count_ones() & 1 == 0 {
        return Ok((mask, digits, false));
    }
    let complement = complement_g41_q29_block_spec(mask, digits)?;
    if complement < (mask, digits) {
        Ok((complement.0, complement.1, true))
    } else {
        Ok((mask, digits, false))
    }
}

pub fn g41_q29_slot_aggregate_signature(
    mask: u8,
    digits: u32,
) -> Result<[u8; 4], G41Q29ExactTablebaseError> {
    let counts = digit_counts(digits);
    if (0..SLOTS).any(|slot| counts[slot] > LARGE_ORBITS[slot]) {
        return Err(G41Q29ExactTablebaseError::SemanticMismatch);
    }
    Ok([
        (mask & 1)
            + ((mask >> 1) & 1)
            + 2 * ((mask >> 2) & 1)
            + 2 * ((mask >> 3) & 1)
            + 6 * ((mask >> 4) & 1)
            + 6 * ((mask >> 5) & 1),
        counts[0] + counts[1],
        counts[2] + counts[3],
        counts[4] + counts[5],
    ])
}

#[inline(always)]
fn add_disjoint_coefficient_states(left: u64, right: u64) -> u64 {
    // Each slot contains disjoint carrier points.  Hence every final residue
    // count is at most 522 / 29 = 18, below the packed radix 32; ordinary
    // integer addition cannot carry between coordinates.
    let sum = left + right;
    debug_assert!((0..8).all(|coordinate| coefficient(sum, coordinate) <= MAX_COEFFICIENT));
    sum
}

fn slot_contributions(
    inventory: &FineInventory,
    slot: usize,
    count: u8,
) -> Result<Vec<u64>, G41Q29ExactTablebaseError> {
    let len = inventory.large_len[slot];
    if count > len {
        return Err(G41Q29ExactTablebaseError::SemanticMismatch);
    }
    let mut orbit_states = [0_u64; 14];
    for orbit in 0..len {
        orbit_states[usize::from(orbit)] = orbit_state(&inventory.large[slot][usize::from(orbit)])?;
    }
    let mut contributions = Vec::with_capacity(1 << len);
    for selection in 0_u16..1_u16 << len {
        if selection.count_ones() != u32::from(count) {
            continue;
        }
        let mut state = 0_u64;
        for orbit in 0..len {
            if selection & (1 << orbit) != 0 {
                state = add_disjoint_coefficient_states(state, orbit_states[usize::from(orbit)]);
            }
        }
        contributions.push(state);
    }
    contributions.sort_unstable();
    contributions.dedup();
    Ok(contributions)
}

fn defect_profile_values(state: u64) -> Result<[u32; 7], G41Q29ExactTablebaseError> {
    let mut coefficients = [0_u32; 29];
    coefficients[0] = u32::from(coefficient(state, 0));
    for (class, coset) in Q29_COSETS.iter().enumerate() {
        for &coordinate in coset {
            coefficients[coordinate] = u32::from(coefficient(state, class + 1));
        }
    }
    let mut values = [0_u32; 7];
    for (class, coset) in Q29_COSETS.iter().enumerate() {
        let shift = coset[0];
        let mut doubled_defect = 0_u32;
        for coordinate in 0..29 {
            let difference =
                coefficients[coordinate].abs_diff(coefficients[(coordinate + shift) % 29]);
            doubled_defect += difference * difference;
        }
        if doubled_defect & 1 != 0 {
            return Err(G41Q29ExactTablebaseError::SemanticMismatch);
        }
        values[class] = doubled_defect / 2;
    }
    Ok(values)
}

fn correlation_profile(
    state: u64,
) -> Result<Option<G41Q29ExactProfile>, G41Q29ExactTablebaseError> {
    let defects = defect_profile_values(state)?;
    if defects.iter().any(|&defect| defect > DEFECT_TARGET) {
        return Ok(None);
    }
    let values: [u16; 7] = std::array::from_fn(|index| defects[index] as u16);
    Ok(Some(G41Q29ExactProfile::from_coordinates(values)))
}

fn profile_digest(profiles: &[G41Q29ExactProfile]) -> [u8; 32] {
    let mut hasher = Sha256::new();
    for profile in profiles {
        hasher.update(profile.low.to_le_bytes());
        hasher.update(profile.high.to_le_bytes());
    }
    hasher.finalize().into()
}

fn compile_g41_q29_coefficient_image(
    requested_mask: u8,
    requested_digits: u32,
) -> Result<G41Q29CoefficientImage, G41Q29ExactTablebaseError> {
    type Workspace = PackedStateWorkspace<{ 1 << 25 }>;
    let (mask, digits, complement_canonicalized) =
        canonical_g41_q29_block_spec(requested_mask, requested_digits)?;
    let inventory = compile_inventory()?;
    let counts = digit_counts(digits);
    let mut initial = 0_u64;
    for slot in 0..SLOTS {
        if mask & (1 << slot) != 0 {
            initial =
                add_disjoint_coefficient_states(initial, orbit_state(&inventory.small[slot])?);
        }
    }
    let mut current = Vec::<u64>::with_capacity(Workspace::MAX_STATES);
    let mut next = Vec::<u64>::with_capacity(Workspace::MAX_STATES);
    let mut workspace = Workspace::new();
    current.push(initial);
    let mut slot_contribution_states = [0_u32; 6];
    let mut coefficient_states_after_slot = [0_u32; 6];
    for slot in 0..SLOTS {
        let contributions = slot_contributions(&inventory, slot, counts[slot])?;
        slot_contribution_states[slot] = contributions.len() as u32;
        next.clear();
        workspace.reset();
        for &left in &current {
            for &right in &contributions {
                let state = add_disjoint_coefficient_states(left, right);
                if workspace.insert(state)? {
                    next.push(state);
                }
            }
        }
        workspace.reset();
        std::mem::swap(&mut current, &mut next);
        if current
            .iter()
            .any(|&state| (0..8).any(|coordinate| coefficient(state, coordinate) > MAX_COEFFICIENT))
        {
            return Err(G41Q29ExactTablebaseError::SemanticMismatch);
        }
        coefficient_states_after_slot[slot] = current.len() as u32;
    }
    drop(next);
    drop(workspace);
    let row_target = if (mask & 3).count_ones() & 1 == 0 {
        260_u32
    } else {
        261_u32
    };
    if current.iter().any(|&state| {
        u32::from(coefficient(state, 0))
            + 4 * (1..8)
                .map(|coordinate| u32::from(coefficient(state, coordinate)))
                .sum::<u32>()
            != row_target
    }) {
        return Err(G41Q29ExactTablebaseError::SemanticMismatch);
    }
    Ok(G41Q29CoefficientImage {
        report: G41Q29CoefficientImageReport {
            requested_mask,
            requested_digits,
            mask,
            digits,
            complement_canonicalized,
            digit_counts: counts,
            slot_contribution_states,
            coefficient_states_after_slot,
            exact_coefficient_states: current.len() as u32,
            workspace_bytes: Workspace::bytes()
                + 2 * (Workspace::MAX_STATES * std::mem::size_of::<u64>()) as u64,
            provenance: "exact block-local q29 coefficient image under one canonical common-quotient digit interface; fixed-cap iterative DP over six fine-orbit slots",
        },
        states: current,
    })
}

/// Visit every exact canonical q29 coefficient state and its independently
/// extracted bounded defect profile.  The fixed image is compiled before the
/// callback begins, so a preallocated callback can remain allocation-free.
pub fn visit_g41_q29_exact_block_states<E>(
    requested_mask: u8,
    requested_digits: u32,
    mut visitor: impl FnMut([u8; 8], Option<G41Q29ExactProfile>) -> Result<(), E>,
) -> Result<G41Q29CoefficientImageReport, E>
where
    E: From<G41Q29ExactTablebaseError>,
{
    let image = compile_g41_q29_coefficient_image(requested_mask, requested_digits)?;
    for &state in &image.states {
        visitor(
            std::array::from_fn(|coordinate| coefficient(state, coordinate)),
            correlation_profile(state)?,
        )?;
    }
    Ok(image.report)
}

pub fn compile_g41_q29_exact_block_tablebase(
    requested_mask: u8,
    requested_digits: u32,
) -> Result<G41Q29ExactBlockTablebase, G41Q29ExactTablebaseError> {
    let image = compile_g41_q29_coefficient_image(requested_mask, requested_digits)?;
    let metadata = image.report;
    let current = image.states;
    let mut profiles = Vec::<G41Q29ExactProfile>::with_capacity(current.len());
    let mut profiles_exceeding_defect_budget = 0_u32;
    for &state in &current {
        match correlation_profile(state)? {
            Some(profile) => profiles.push(profile),
            None => {
                profiles_exceeding_defect_budget = profiles_exceeding_defect_budget
                    .checked_add(1)
                    .ok_or(G41Q29ExactTablebaseError::StateBudget)?;
            }
        }
    }
    profiles.sort_unstable();
    profiles.dedup();
    let digest = profile_digest(&profiles);
    Ok(G41Q29ExactBlockTablebase {
        report: G41Q29ExactBlockReport {
            requested_mask: metadata.requested_mask,
            requested_digits: metadata.requested_digits,
            mask: metadata.mask,
            digits: metadata.digits,
            complement_canonicalized: metadata.complement_canonicalized,
            digit_counts: metadata.digit_counts,
            slot_contribution_states: metadata.slot_contribution_states,
            coefficient_states_after_slot: metadata.coefficient_states_after_slot,
            exact_coefficient_states: current.len() as u32,
            exact_correlation_profiles: profiles.len() as u32,
            profile_digest: digest,
            profiles_exceeding_defect_budget,
            workspace_bytes: metadata.workspace_bytes,
            provenance: "exact block-local q29 coefficient image under one raw common-quotient digit interface; fixed-cap iterative DP; Cauchy makes every A0-As defect nonnegative, so any block defect above the exact four-block budget 523 is safely discarded; no root exclusion authority without an exact four-block join",
        },
        profiles: profiles.into_boxed_slice(),
    })
}

pub fn lift_all_g41_q29_exact_block_profile(
    mask: u8,
    digits: u32,
    target: G41Q29ExactProfile,
) -> Result<Box<[G41Q29BlockProfileLiftReport]>, G41Q29ExactTablebaseError> {
    type Workspace = PackedStateWorkspace<{ 1 << 25 }>;
    if mask >= 64 {
        return Err(G41Q29ExactTablebaseError::SemanticMismatch);
    }
    let inventory = compile_inventory()?;
    let counts = digit_counts(digits);
    if (0..SLOTS).any(|slot| counts[slot] > inventory.large_len[slot]) {
        return Err(G41Q29ExactTablebaseError::SemanticMismatch);
    }
    let mut initial = 0_u64;
    for slot in 0..SLOTS {
        if mask & (1 << slot) != 0 {
            initial =
                add_disjoint_coefficient_states(initial, orbit_state(&inventory.small[slot])?);
        }
    }
    let mut current = Vec::<u64>::with_capacity(Workspace::MAX_STATES);
    let mut next = Vec::<u64>::with_capacity(Workspace::MAX_STATES);
    let mut workspace = Workspace::new();
    current.push(initial);
    for slot in 0..SLOTS {
        let contributions = slot_contributions(&inventory, slot, counts[slot])?;
        next.clear();
        workspace.reset();
        for &left in &current {
            for &right in &contributions {
                let state = add_disjoint_coefficient_states(left, right);
                if workspace.insert(state)? {
                    next.push(state);
                }
            }
        }
        workspace.reset();
        std::mem::swap(&mut current, &mut next);
    }
    let mut target_states = Vec::with_capacity(16);
    let mut coefficient_states_examined = 0_u32;
    for &state in &current {
        coefficient_states_examined = coefficient_states_examined
            .checked_add(1)
            .ok_or(G41Q29ExactTablebaseError::StateBudget)?;
        if correlation_profile(state)? == Some(target) {
            if target_states.len() == MAX_PROFILE_PREIMAGES {
                return Err(G41Q29ExactTablebaseError::StateBudget);
            }
            target_states.push(state);
        }
    }
    let coefficient_preimages = target_states.len() as u32;
    let mut reports = Vec::with_capacity(target_states.len());
    for target_state in target_states {
        if coefficient(target_state, 0) != coefficient(initial, 0) {
            return Err(G41Q29ExactTablebaseError::SemanticMismatch);
        }
        let (
            orbit_masks,
            decomposition_fibres,
            decomposition_states,
            decomposition_workspace_bytes,
        ) = reconstruct_slot_masks(counts, target_state)?;
        let mut replayed = initial;
        for slot in 0..SLOTS {
            for orbit in 0..inventory.large_len[slot] {
                if orbit_masks[slot] & (1 << orbit) != 0 {
                    replayed = add_disjoint_coefficient_states(
                        replayed,
                        orbit_state(&inventory.large[slot][orbit as usize])?,
                    );
                }
            }
        }
        if replayed != target_state || correlation_profile(replayed)? != Some(target) {
            return Err(G41Q29ExactTablebaseError::SemanticMismatch);
        }
        reports.push(G41Q29BlockProfileLiftReport {
            mask,
            digits,
            target_profile: std::array::from_fn(|coordinate| target.coordinate(coordinate)),
            coefficient_values: std::array::from_fn(|coordinate| {
                coefficient(target_state, coordinate)
            }),
            orbit_masks,
            coefficient_states_examined,
            coefficient_preimages,
            decomposition_fibres,
            decomposition_states,
            decomposition_workspace_bytes,
            provenance: "exact block-profile lift through the requested six slot families; bounded iterative coefficient DP counts and returns every coefficient preimage, bounded iterative count-state DP reconstructs orbit masks, and direct coefficient/profile replay checks every result",
        });
    }
    Ok(reports.into_boxed_slice())
}

pub fn lift_g41_q29_exact_block_profile(
    mask: u8,
    digits: u32,
    target: G41Q29ExactProfile,
) -> Result<Option<G41Q29BlockProfileLiftReport>, G41Q29ExactTablebaseError> {
    Ok(lift_all_g41_q29_exact_block_profile(mask, digits, target)?
        .first()
        .cloned())
}

pub fn lift_g41_q29_exact_block_coefficients(
    mask: u8,
    digits: u32,
    coefficient_values: [u8; 8],
) -> Result<Option<G41Q29BlockProfileLiftReport>, G41Q29ExactTablebaseError> {
    let mut workspace = G41Q29DirectLiftWorkspace::new(digits)?;
    lift_g41_q29_exact_block_coefficients_with_workspace(
        mask,
        digits,
        coefficient_values,
        &mut workspace,
    )
}

pub fn lift_g41_q29_exact_block_coefficients_with_workspace(
    mask: u8,
    digits: u32,
    coefficient_values: [u8; 8],
    workspace: &mut G41Q29DirectLiftWorkspace,
) -> Result<Option<G41Q29BlockProfileLiftReport>, G41Q29ExactTablebaseError> {
    if workspace.digits != digits {
        return Err(G41Q29ExactTablebaseError::SemanticMismatch);
    }
    let Some(decomposition) = decompose_g41_q29_exact_block_coefficients_with_workspace(
        digits,
        coefficient_values,
        workspace,
    )?
    else {
        return Ok(None);
    };
    replay_g41_q29_exact_block_decomposition(
        mask,
        digits,
        coefficient_values,
        &decomposition,
        workspace,
    )
}

pub fn decompose_g41_q29_exact_block_coefficients_with_workspace(
    digits: u32,
    coefficient_values: [u8; 8],
    workspace: &mut G41Q29DirectLiftWorkspace,
) -> Result<Option<G41Q29CoefficientDecomposition>, G41Q29ExactTablebaseError> {
    decompose_g41_q29_exact_block_coefficients_with_workspace_impl::<true>(
        digits,
        coefficient_values,
        workspace,
    )
}

#[doc(hidden)]
pub fn decompose_g41_q29_exact_block_coefficients_full_reset_control(
    digits: u32,
    coefficient_values: [u8; 8],
    workspace: &mut G41Q29DirectLiftWorkspace,
) -> Result<Option<G41Q29CoefficientDecomposition>, G41Q29ExactTablebaseError> {
    decompose_g41_q29_exact_block_coefficients_with_workspace_impl::<false>(
        digits,
        coefficient_values,
        workspace,
    )
}

fn decompose_g41_q29_exact_block_coefficients_with_workspace_impl<const SPARSE_RESET: bool>(
    digits: u32,
    coefficient_values: [u8; 8],
    workspace: &mut G41Q29DirectLiftWorkspace,
) -> Result<Option<G41Q29CoefficientDecomposition>, G41Q29ExactTablebaseError> {
    if workspace.digits != digits {
        return Err(G41Q29ExactTablebaseError::SemanticMismatch);
    }
    let target_state = pack_coefficients(coefficient_values)?;
    if correlation_profile(target_state)?.is_none() {
        return Ok(None);
    }
    let counts = workspace.counts;
    if (0..SLOTS).any(|slot| counts[slot] > workspace.inventory.large_len[slot]) {
        return Err(G41Q29ExactTablebaseError::SemanticMismatch);
    }
    let Some((
        orbit_masks,
        decomposition_fibres,
        decomposition_states,
        decomposition_workspace_bytes,
    )) = try_reconstruct_slot_masks_with_workspace::<SPARSE_RESET>(target_state, workspace)?
    else {
        return Ok(None);
    };
    Ok(Some(G41Q29CoefficientDecomposition {
        digits,
        nonzero_coefficients: std::array::from_fn(|coordinate| coefficient_values[coordinate + 1]),
        orbit_masks,
        decomposition_fibres,
        decomposition_states,
        decomposition_workspace_bytes,
    }))
}

pub fn replay_g41_q29_exact_block_decomposition(
    mask: u8,
    digits: u32,
    coefficient_values: [u8; 8],
    decomposition: &G41Q29CoefficientDecomposition,
    workspace: &G41Q29DirectLiftWorkspace,
) -> Result<Option<G41Q29BlockProfileLiftReport>, G41Q29ExactTablebaseError> {
    if mask >= 64
        || workspace.digits != digits
        || decomposition.digits != digits
        || decomposition.nonzero_coefficients != coefficient_values[1..]
    {
        return Err(G41Q29ExactTablebaseError::SemanticMismatch);
    }
    let mut initial = 0_u64;
    for slot in 0..SLOTS {
        if mask & (1 << slot) != 0 {
            initial = add_disjoint_coefficient_states(
                initial,
                orbit_state(&workspace.inventory.small[slot])?,
            );
        }
    }
    let target_state = pack_coefficients(coefficient_values)?;
    let Some(target_profile) = correlation_profile(target_state)? else {
        return Ok(None);
    };
    if coefficient(target_state, 0) != coefficient(initial, 0) {
        return Ok(None);
    }
    let orbit_masks = decomposition.orbit_masks;
    let mut replayed = initial;
    for slot in 0..SLOTS {
        for orbit in 0..workspace.inventory.large_len[slot] {
            if orbit_masks[slot] & (1 << orbit) != 0 {
                replayed = add_disjoint_coefficient_states(
                    replayed,
                    orbit_state(&workspace.inventory.large[slot][orbit as usize])?,
                );
            }
        }
    }
    if replayed != target_state || correlation_profile(replayed)? != Some(target_profile) {
        return Err(G41Q29ExactTablebaseError::SemanticMismatch);
    }
    Ok(Some(G41Q29BlockProfileLiftReport {
        mask,
        digits,
        target_profile: std::array::from_fn(|coordinate| target_profile.coordinate(coordinate)),
        coefficient_values,
        orbit_masks,
        coefficient_states_examined: 1,
        coefficient_preimages: 1,
        decomposition_fibres: decomposition.decomposition_fibres,
        decomposition_states: decomposition.decomposition_states,
        decomposition_workspace_bytes: decomposition.decomposition_workspace_bytes,
        provenance: "direct exact coefficient-state handoff from the fixed-zero defect-fibre table; bounded iterative slot-count reconstruction tests source-interface membership without compiling or scanning the full block coefficient image, and direct coefficient/orbit/profile replay validates every hit",
    }))
}

fn aggregate_group_contributions(
    capacity: u8,
    total: u8,
    scale: u8,
) -> Result<Vec<u64>, G41Q29ExactTablebaseError> {
    if total > 7 * capacity || scale == 0 {
        return Err(G41Q29ExactTablebaseError::SemanticMismatch);
    }
    let radix = u32::from(capacity) + 1;
    let assignments = radix.pow(7);
    let mut contributions = Vec::with_capacity(assignments as usize);
    for mut code in 0..assignments {
        let mut values = [0_u8; 8];
        let mut sum = 0_u8;
        for coordinate in 1..8 {
            let value = (code % radix) as u8;
            code /= radix;
            values[coordinate] = value * scale;
            sum += value;
        }
        if sum == total {
            contributions.push(pack_coefficients(values)?);
        }
    }
    Ok(contributions)
}

pub fn compile_g41_q29_aggregate_block_tablebase(
    signature: [u8; 4],
) -> Result<G41Q29AggregateBlockTablebase, G41Q29ExactTablebaseError> {
    type Workspace = PackedStateWorkspace<{ 1 << 25 }>;
    if signature[0] > 18 || signature[1] > 14 || signature[2] > 28 || signature[3] > 28 {
        return Err(G41Q29ExactTablebaseError::SemanticMismatch);
    }
    let row_sum = u16::from(signature[0])
        + 4 * u16::from(signature[1])
        + 4 * u16::from(signature[2])
        + 12 * u16::from(signature[3]);
    if row_sum != 260 && row_sum != 261 {
        return Err(G41Q29ExactTablebaseError::SemanticMismatch);
    }
    let groups = [
        aggregate_group_contributions(2, signature[1], 1)?,
        aggregate_group_contributions(4, signature[2], 1)?,
        aggregate_group_contributions(4, signature[3], 3)?,
    ];
    let expected_group_sums = [signature[1], signature[2], 3 * signature[3]];
    for group in 0..3 {
        if groups[group].iter().any(|&state| {
            coefficient(state, 0) != 0
                || (1..8)
                    .map(|coordinate| coefficient(state, coordinate))
                    .sum::<u8>()
                    != expected_group_sums[group]
        }) {
            return Err(G41Q29ExactTablebaseError::SemanticMismatch);
        }
    }
    let mut initial_values = [0_u8; 8];
    initial_values[0] = signature[0];
    let initial = pack_coefficients(initial_values)?;
    let mut current = Vec::<u64>::with_capacity(Workspace::MAX_STATES);
    let mut next = Vec::<u64>::with_capacity(Workspace::MAX_STATES);
    let mut workspace = Workspace::new();
    current.push(initial);
    let mut group_contribution_states = [0_u32; 3];
    let mut coefficient_states_after_group = [0_u32; 3];
    for group in 0..3 {
        group_contribution_states[group] = groups[group].len() as u32;
        next.clear();
        workspace.reset();
        for &left in &current {
            for &right in &groups[group] {
                let state = add_disjoint_coefficient_states(left, right);
                if workspace.insert(state)? {
                    next.push(state);
                }
            }
        }
        workspace.reset();
        std::mem::swap(&mut current, &mut next);
        coefficient_states_after_group[group] = current.len() as u32;
    }
    drop(next);
    drop(workspace);
    let mut profiles = Vec::<G41Q29ExactProfile>::with_capacity(current.len());
    let mut profiles_exceeding_defect_budget = 0_u32;
    for &state in &current {
        if let Some(profile) = correlation_profile(state)? {
            profiles.push(profile);
        } else {
            profiles_exceeding_defect_budget = profiles_exceeding_defect_budget
                .checked_add(1)
                .ok_or(G41Q29ExactTablebaseError::StateBudget)?;
        }
    }
    profiles.sort_unstable();
    profiles.dedup();
    let digest = profile_digest(&profiles);
    Ok(G41Q29AggregateBlockTablebase {
        report: G41Q29AggregateBlockReport {
            signature,
            row_sum,
            group_contribution_states,
            coefficient_states_after_group,
            exact_coefficient_states: current.len() as u32,
            exact_correlation_profiles: profiles.len() as u32,
            profile_digest: digest,
            profiles_exceeding_defect_budget,
            workspace_bytes: Workspace::bytes()
                + 2 * (Workspace::MAX_STATES * std::mem::size_of::<u64>()) as u64,
            provenance: "exact q29 block superset keyed only by sealed slot-pair aggregates; the split between identical slot families is deliberately relaxed; fixed-cap iterative coefficient DP and the nonnegative 523 defect bound are exact; no root exclusion authority without a four-block join",
        },
        profiles: profiles.into_boxed_slice(),
    })
}

fn complement_coefficient_state(state: u64) -> Result<u64, G41Q29ExactTablebaseError> {
    pack_coefficients(std::array::from_fn(|coordinate| {
        MAX_COEFFICIENT - coefficient(state, coordinate)
    }))
}

pub fn compile_g41_q29_fixed_zero_defect_tablebase(
    row_sum: u16,
    zero_coefficient: u8,
) -> Result<G41Q29FixedZeroDefectTablebase, G41Q29ExactTablebaseError> {
    const MAX_ADMISSIBLE_STATES: usize = 1 << 22;
    if zero_coefficient > MAX_COEFFICIENT || (row_sum != 260 && row_sum != 261) {
        return Err(G41Q29ExactTablebaseError::SemanticMismatch);
    }
    let remainder = row_sum
        .checked_sub(u16::from(zero_coefficient))
        .ok_or(G41Q29ExactTablebaseError::SemanticMismatch)?;
    if remainder % 4 != 0 {
        return Err(G41Q29ExactTablebaseError::SemanticMismatch);
    }
    let target_sum = (remainder / 4) as u8;
    let mut right = Vec::<ThreeCounts>::with_capacity(19_usize.pow(3));
    for first in 0_u8..=MAX_COEFFICIENT {
        for second in 0_u8..=MAX_COEFFICIENT {
            for third in 0_u8..=MAX_COEFFICIENT {
                right.push(ThreeCounts {
                    values: [first, second, third],
                    sum: first + second + third,
                });
            }
        }
    }
    right.sort_unstable_by_key(|counts| counts.sum);
    let mut right_ranges = [(0_usize, 0_usize); 55];
    for sum in 0_u8..=54 {
        right_ranges[usize::from(sum)] = (
            right.partition_point(|counts| counts.sum < sum),
            right.partition_point(|counts| counts.sum <= sum),
        );
    }
    let mut entries = Vec::<ProfileState>::with_capacity(MAX_ADMISSIBLE_STATES);
    let mut coefficient_vectors = 0_u64;
    for first in 0_u8..=MAX_COEFFICIENT {
        for second in 0_u8..=MAX_COEFFICIENT {
            for third in 0_u8..=MAX_COEFFICIENT {
                for fourth in 0_u8..=MAX_COEFFICIENT {
                    let left_sum = first + second + third + fourth;
                    if left_sum > target_sum || target_sum - left_sum > 54 {
                        continue;
                    }
                    let (start, end) = right_ranges[usize::from(target_sum - left_sum)];
                    for right_counts in &right[start..end] {
                        coefficient_vectors = coefficient_vectors
                            .checked_add(1)
                            .ok_or(G41Q29ExactTablebaseError::StateBudget)?;
                        let state = pack_coefficients([
                            zero_coefficient,
                            first,
                            second,
                            third,
                            fourth,
                            right_counts.values[0],
                            right_counts.values[1],
                            right_counts.values[2],
                        ])?;
                        let Some(profile) = correlation_profile(state)? else {
                            continue;
                        };
                        if entries.len() == MAX_ADMISSIBLE_STATES {
                            return Err(G41Q29ExactTablebaseError::StateBudget);
                        }
                        entries.push(ProfileState { profile, state });
                    }
                }
            }
        }
    }
    entries.sort_unstable();
    let admissible_coefficient_vectors = entries.len() as u32;
    let mut profiles = 0_u32;
    let mut singleton_fibres = 0_u32;
    let mut complement_pair_fibres = 0_u32;
    let mut maximum_fibre = 0_u8;
    let mut digest = Sha256::new();
    let mut cursor = 0_usize;
    while cursor < entries.len() {
        let profile = entries[cursor].profile;
        let end = entries[cursor..].partition_point(|entry| entry.profile == profile) + cursor;
        let fibre = end - cursor;
        maximum_fibre = maximum_fibre.max(fibre.try_into().unwrap_or(u8::MAX));
        match fibre {
            1 => singleton_fibres += 1,
            2 if entries[cursor + 1].state
                == complement_coefficient_state(entries[cursor].state)? =>
            {
                complement_pair_fibres += 1;
            }
            _ => return Err(G41Q29ExactTablebaseError::SemanticMismatch),
        }
        let [low, high] = profile.packed_words();
        digest.update(low.to_le_bytes());
        digest.update(high.to_le_bytes());
        profiles = profiles
            .checked_add(1)
            .ok_or(G41Q29ExactTablebaseError::StateBudget)?;
        cursor = end;
    }
    if u64::from(admissible_coefficient_vectors)
        != u64::from(singleton_fibres) + 2 * u64::from(complement_pair_fibres)
    {
        return Err(G41Q29ExactTablebaseError::SemanticMismatch);
    }
    Ok(G41Q29FixedZeroDefectTablebase {
        report: G41Q29FixedZeroDefectFibreReport {
            row_sum,
            zero_coefficient,
            coefficient_vectors,
            admissible_coefficient_vectors,
            exact_correlation_profiles: profiles,
            singleton_fibres,
            complement_pair_fibres,
            maximum_fibre,
            profile_digest: digest.finalize().into(),
            workspace_bytes: (MAX_ADMISSIBLE_STATES * std::mem::size_of::<ProfileState>()) as u64
                + (right.capacity() * std::mem::size_of::<ThreeCounts>()) as u64,
            provenance: "exact bounded fixed-zero phase-retrieval audit over every seven-coordinate multiplier-invariant coefficient vector with the requested row sum; admissible vectors are sorted by all seven canonical defects, every fibre is proved singleton or the explicit coefficient complement pair, and only one profile per fibre enters the digest",
        },
        entries: entries.into_boxed_slice(),
    })
}

pub fn audit_g41_q29_fixed_zero_defect_fibres(
    row_sum: u16,
    zero_coefficient: u8,
) -> Result<G41Q29FixedZeroDefectFibreReport, G41Q29ExactTablebaseError> {
    Ok(compile_g41_q29_fixed_zero_defect_tablebase(row_sum, zero_coefficient)?.report)
}

pub fn compile_g41_q29_row_superset_tablebase(
    row_sum: u16,
) -> Result<G41Q29RowSupersetTablebase, G41Q29ExactTablebaseError> {
    type Workspace = ExactProfileWorkspace<{ 1 << 24 }>;
    if row_sum != 260 && row_sum != 261 {
        return Err(G41Q29ExactTablebaseError::SemanticMismatch);
    }
    let mut left = Vec::<FourCounts>::with_capacity(19_usize.pow(4));
    for first in 0_u8..=18 {
        for second in 0_u8..=18 {
            for third in 0_u8..=18 {
                for fourth in 0_u8..=18 {
                    left.push(FourCounts {
                        values: [first, second, third, fourth],
                        sum: first + second + third + fourth,
                        _pad: [0; 3],
                    });
                }
            }
        }
    }
    let mut right = Vec::<ThreeCounts>::with_capacity(19_usize.pow(3));
    for first in 0_u8..=18 {
        for second in 0_u8..=18 {
            for third in 0_u8..=18 {
                right.push(ThreeCounts {
                    values: [first, second, third],
                    sum: first + second + third,
                });
            }
        }
    }
    right.sort_unstable_by_key(|counts| counts.sum);
    let mut right_ranges = [(0_usize, 0_usize); 55];
    for sum in 0_u8..=54 {
        let start = right.partition_point(|counts| counts.sum < sum);
        let end = right.partition_point(|counts| counts.sum <= sum);
        right_ranges[usize::from(sum)] = (start, end);
    }

    let mut workspace = Workspace::new();
    let mut profiles = Vec::<G41Q29ExactProfile>::with_capacity(Workspace::MAX_STATES);
    let mut exact_coefficient_vectors = 0_u64;
    let mut profiles_exceeding_defect_budget = 0_u64;
    for zero in 0_u8..=18 {
        let remainder = u32::from(row_sum)
            .checked_sub(u32::from(zero))
            .ok_or(G41Q29ExactTablebaseError::SemanticMismatch)?;
        if remainder % 4 != 0 {
            continue;
        }
        let coset_sum = (remainder / 4) as u8;
        for left_counts in &left {
            if left_counts.sum > coset_sum {
                continue;
            }
            let right_sum = coset_sum - left_counts.sum;
            if right_sum > 54 {
                continue;
            }
            let (start, end) = right_ranges[usize::from(right_sum)];
            for right_counts in &right[start..end] {
                exact_coefficient_vectors = exact_coefficient_vectors
                    .checked_add(1)
                    .ok_or(G41Q29ExactTablebaseError::StateBudget)?;
                let state = pack_coefficients([
                    zero,
                    left_counts.values[0],
                    left_counts.values[1],
                    left_counts.values[2],
                    left_counts.values[3],
                    right_counts.values[0],
                    right_counts.values[1],
                    right_counts.values[2],
                ])?;
                if let Some(profile) = correlation_profile(state)? {
                    if workspace.insert(profile)? {
                        profiles.push(profile);
                    }
                } else {
                    profiles_exceeding_defect_budget = profiles_exceeding_defect_budget
                        .checked_add(1)
                        .ok_or(G41Q29ExactTablebaseError::StateBudget)?;
                }
            }
        }
    }
    profiles.sort_unstable();
    let digest = profile_digest(&profiles);
    if exact_coefficient_vectors != independent_row_coefficient_vector_count(row_sum) {
        return Err(G41Q29ExactTablebaseError::SemanticMismatch);
    }
    Ok(G41Q29RowSupersetTablebase {
        report: G41Q29RowSupersetReport {
            row_sum,
            exact_coefficient_vectors,
            exact_correlation_profiles: profiles.len() as u32,
            profile_digest: digest,
            profiles_exceeding_defect_budget,
            workspace_bytes: Workspace::bytes()
                + (Workspace::MAX_STATES * std::mem::size_of::<G41Q29ExactProfile>()) as u64
                + (left.capacity() * std::mem::size_of::<FourCounts>()) as u64
                + (right.capacity() * std::mem::size_of::<ThreeCounts>()) as u64,
            provenance: "exact row-sum-level q29 multiplier-invariant coefficient superset; bounded iterative 4+3 count join; Cauchy-defect profiles above 523 are safely discarded; quotient/fine-orbit constraints are deliberately relaxed, so emptiness may authorize exclusion only after an exact four-block profile join",
        },
        profiles: profiles.into_boxed_slice(),
    })
}

fn independent_row_coefficient_vector_count(row_sum: u16) -> u64 {
    let mut current = [0_u64; 127];
    let mut next = [0_u64; 127];
    current[0] = 1;
    for _ in 0..7 {
        next.fill(0);
        for sum in 0..=126 {
            if current[sum] == 0 {
                continue;
            }
            for value in 0..=18 {
                if sum + value <= 126 {
                    next[sum + value] += current[sum];
                }
            }
        }
        current = next;
    }
    let mut total = 0_u64;
    for zero in 0_u16..=18 {
        if row_sum >= zero && (row_sum - zero) % 4 == 0 {
            total += current[usize::from((row_sum - zero) / 4)];
        }
    }
    total
}

#[cfg(test)]
mod tests {
    use std::collections::BTreeSet;

    use super::*;
    use crate::allocation_test::tracked_allocations;

    #[test]
    fn packed_addition_matches_coordinate_oracle() {
        let left = pack_coefficients([1, 2, 3, 4, 5, 6, 7, 8]).unwrap();
        let right = pack_coefficients([8, 7, 6, 5, 4, 3, 2, 1]).unwrap();
        let sum = add_disjoint_coefficient_states(left, right);
        assert!((0..8).all(|coordinate| coefficient(sum, coordinate) == 9));
    }

    #[test]
    fn fixed_zero_inverse_lookup_returns_complement_fibre_without_allocating() {
        let first_values = [9, 8, 9, 9, 9, 9, 9, 9];
        let second_values = first_values.map(|value| 18 - value);
        let first_state = pack_coefficients(first_values).unwrap();
        let second_state = pack_coefficients(second_values).unwrap();
        let profile = correlation_profile(first_state).unwrap().unwrap();
        assert_eq!(correlation_profile(second_state).unwrap(), Some(profile));
        let mut entries = vec![
            ProfileState {
                profile,
                state: first_state,
            },
            ProfileState {
                profile,
                state: second_state,
            },
        ];
        entries.sort_unstable();
        let table = G41Q29FixedZeroDefectTablebase {
            report: G41Q29FixedZeroDefectFibreReport {
                row_sum: 261,
                zero_coefficient: 9,
                coefficient_vectors: 2,
                admissible_coefficient_vectors: 2,
                exact_correlation_profiles: 1,
                singleton_fibres: 0,
                complement_pair_fibres: 1,
                maximum_fibre: 2,
                profile_digest: [0; 32],
                workspace_bytes: 48,
                provenance: "test fixture",
            },
            entries: entries.into_boxed_slice(),
        };
        let (fibre, allocations) = tracked_allocations(|| table.coefficient_fibre(profile));
        let fibre = fibre.unwrap();
        assert_eq!(fibre.len, 2);
        assert!(fibre.coefficient_values[..2].contains(&first_values));
        assert!(fibre.coefficient_values[..2].contains(&second_values));
        assert_eq!(allocations, 0);
    }

    #[test]
    fn exact_profile_is_constant_on_multiplier_cosets() {
        let state = pack_coefficients([2, 3, 4, 5, 6, 7, 8, 9]).unwrap();
        let profile = correlation_profile(state).unwrap().unwrap();
        let mut coefficients = [0_u32; 29];
        coefficients[0] = 2;
        for (class, coset) in Q29_COSETS.iter().enumerate() {
            for &coordinate in coset {
                coefficients[coordinate] = (class + 3) as u32;
            }
        }
        for (class, coset) in Q29_COSETS.iter().enumerate() {
            let direct = (0..29)
                .map(|coordinate| {
                    coefficients[coordinate] * coefficients[(coordinate + coset[0]) % 29]
                })
                .sum::<u32>();
            let zero = coefficients.iter().map(|value| value * value).sum::<u32>();
            assert_eq!(u32::from(profile.coordinate(class)), zero - direct);
        }
    }

    #[test]
    fn complement_preserves_q29_defects_and_is_an_involution() {
        let values = [2, 3, 4, 5, 6, 7, 8, 9];
        let complement = values.map(|value| 18 - value);
        assert_eq!(
            defect_profile_values(pack_coefficients(values).unwrap()).unwrap(),
            defect_profile_values(pack_coefficients(complement).unwrap()).unwrap()
        );

        let spec = (21_u8, 2_202_981_u32);
        let once = complement_g41_q29_block_spec(spec.0, spec.1).unwrap();
        let twice = complement_g41_q29_block_spec(once.0, once.1).unwrap();
        assert_eq!(twice, spec);
        let canonical = canonical_g41_q29_block_spec(spec.0, spec.1).unwrap();
        assert_eq!((canonical.0, canonical.1), spec.min(once));
    }

    #[test]
    fn translation_261_swaps_slot_pairs_and_is_q29_invisible() {
        let spec = (0b10_01_11_u8, 2_202_981_u32);
        let once = translate_261_g41_q29_block_spec(spec.0, spec.1).unwrap();
        let twice = translate_261_g41_q29_block_spec(once.0, once.1).unwrap();
        assert_eq!(twice, spec);
        let expected_mask = 0b01_10_11;
        assert_eq!(once.0, expected_mask);
        let direct = canonical_g41_q29_block_spec(spec.0, spec.1).unwrap();
        let translated = canonical_g41_q29_block_spec(once.0, once.1).unwrap();
        assert_eq!(
            translation_canonical_g41_q29_block_spec(spec.0, spec.1).unwrap(),
            (direct.0, direct.1).min((translated.0, translated.1))
        );

        let inventory = compile_inventory().unwrap();
        for first in [0, 2, 4] {
            assert_eq!(
                orbit_state(&inventory.small[first]).unwrap(),
                orbit_state(&inventory.small[first + 1]).unwrap()
            );
            let mut left = inventory.large[first][..usize::from(inventory.large_len[first])]
                .iter()
                .map(|orbit| orbit_state(orbit).unwrap())
                .collect::<Vec<_>>();
            let mut right = inventory.large[first + 1]
                [..usize::from(inventory.large_len[first + 1])]
                .iter()
                .map(|orbit| orbit_state(orbit).unwrap())
                .collect::<Vec<_>>();
            left.sort_unstable();
            right.sort_unstable();
            assert_eq!(left, right);
        }
    }

    #[test]
    fn slot_aggregate_signature_forgets_only_identical_family_splits() {
        let first = g41_q29_slot_aggregate_signature(1, 1_959_269).unwrap();
        let second = g41_q29_slot_aggregate_signature(2, 1_956_403).unwrap();
        assert_eq!(first, [1, 9, 14, 14]);
        assert_eq!(second, first);

        let inventory = compile_inventory().unwrap();
        let counts = digit_counts(1_959_269);
        let mut relaxed = aggregate_group_contributions(2, counts[0] + counts[1], 1).unwrap();
        relaxed.sort_unstable();
        for first_mask in 0_u16..1_u16 << inventory.large_len[0] {
            if first_mask.count_ones() != u32::from(counts[0]) {
                continue;
            }
            let mut first_state = 0_u64;
            for orbit in 0..inventory.large_len[0] {
                if first_mask & (1 << orbit) != 0 {
                    first_state = add_disjoint_coefficient_states(
                        first_state,
                        orbit_state(&inventory.large[0][usize::from(orbit)]).unwrap(),
                    );
                }
            }
            for second_mask in 0_u16..1_u16 << inventory.large_len[1] {
                if second_mask.count_ones() != u32::from(counts[1]) {
                    continue;
                }
                let mut state = first_state;
                for orbit in 0..inventory.large_len[1] {
                    if second_mask & (1 << orbit) != 0 {
                        state = add_disjoint_coefficient_states(
                            state,
                            orbit_state(&inventory.large[1][usize::from(orbit)]).unwrap(),
                        );
                    }
                }
                assert!(relaxed.binary_search(&state).is_ok());
            }
        }
    }

    #[test]
    fn iterative_slot_reconstruction_replays_an_independent_selection() {
        let inventory = compile_inventory().unwrap();
        let counts = [1_u8; 6];
        let mut target = 0_u64;
        for slot in 0..6 {
            target = add_disjoint_coefficient_states(
                target,
                orbit_state(&inventory.large[slot][0]).unwrap(),
            );
        }
        let (masks, fibres, states, _) = reconstruct_slot_masks(counts, target).unwrap();
        assert!(fibres > 0);
        assert!(states > 0);
        let mut replayed = 0_u64;
        for slot in 0..6 {
            assert_eq!(masks[slot].count_ones(), 1);
            for orbit in 0..inventory.large_len[slot] {
                if masks[slot] & (1 << orbit) != 0 {
                    replayed = add_disjoint_coefficient_states(
                        replayed,
                        orbit_state(&inventory.large[slot][orbit as usize]).unwrap(),
                    );
                }
            }
        }
        assert_eq!(replayed, target);
        let values = std::array::from_fn(|coordinate| coefficient(target, coordinate));
        assert!(
            g41_q29_degree_sequence_decomposition_feasible(pack_digit_counts(counts), values)
                .unwrap()
        );
        let direct = lift_g41_q29_exact_block_coefficients(0, pack_digit_counts(counts), values)
            .unwrap()
            .unwrap();
        assert_eq!(direct.orbit_masks, masks);
        assert_eq!(direct.coefficient_values, values);
        let digits = pack_digit_counts(counts);
        let mut workspace = G41Q29DirectLiftWorkspace::new(digits).unwrap();
        let (direct_hot, allocations) = tracked_allocations(|| {
            lift_g41_q29_exact_block_coefficients_with_workspace(0, digits, values, &mut workspace)
        });
        assert_eq!(direct_hot.unwrap().unwrap().orbit_masks, masks);
        assert_eq!(allocations, 0);
        let ((replayed, wrong_mask, rebound_zero), allocations) = tracked_allocations(|| {
            let decomposition = decompose_g41_q29_exact_block_coefficients_with_workspace(
                digits,
                values,
                &mut workspace,
            )
            .unwrap()
            .unwrap();
            let replayed = replay_g41_q29_exact_block_decomposition(
                0,
                digits,
                values,
                &decomposition,
                &workspace,
            )
            .unwrap();
            let wrong_mask = replay_g41_q29_exact_block_decomposition(
                1,
                digits,
                values,
                &decomposition,
                &workspace,
            )
            .unwrap();
            let mut rebound_values = values;
            rebound_values[0] = 1;
            let rebound_zero = replay_g41_q29_exact_block_decomposition(
                1,
                digits,
                rebound_values,
                &decomposition,
                &workspace,
            )
            .unwrap();
            (replayed, wrong_mask, rebound_zero)
        });
        assert_eq!(replayed.unwrap().orbit_masks, masks);
        assert!(wrong_mask.is_none());
        assert_eq!(rebound_zero.unwrap().orbit_masks, masks);
        assert_eq!(allocations, 0);
        let mut wrong_zero = values;
        wrong_zero[0] = 1;
        assert!(
            lift_g41_q29_exact_block_coefficients(0, pack_digit_counts(counts), wrong_zero)
                .unwrap()
                .is_none()
        );
    }

    #[test]
    fn capacitated_gale_ryser_matches_exhaustive_small_matrices() {
        let mut reachable = BTreeSet::new();
        for a0 in 0_u8..=1 {
            for a1 in 0_u8..=1 {
                for a2 in 0_u8..=1 {
                    for b0 in 0_u8..=1 {
                        for b1 in 0_u8..=1 {
                            for b2 in 0_u8..=1 {
                                for c0 in 0_u8..=2 {
                                    for c1 in 0_u8..=2 {
                                        for c2 in 0_u8..=2 {
                                            for d0 in 0_u8..=2 {
                                                for d1 in 0_u8..=2 {
                                                    for d2 in 0_u8..=2 {
                                                        reachable.insert((
                                                            [
                                                                a0 + a1 + a2,
                                                                b0 + b1 + b2,
                                                                c0 + c1 + c2,
                                                                d0 + d1 + d2,
                                                            ],
                                                            [
                                                                a0 + b0 + c0 + d0,
                                                                a1 + b1 + c1 + d1,
                                                                a2 + b2 + c2 + d2,
                                                            ],
                                                        ));
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        for first in 0_u8..=3 {
            for second in 0_u8..=3 {
                for third in 0_u8..=6 {
                    for fourth in 0_u8..=6 {
                        let rows = [first, second, third, fourth];
                        for c0 in 0_u8..=6 {
                            for c1 in 0_u8..=6 {
                                for c2 in 0_u8..=6 {
                                    let columns = [c0, c1, c2];
                                    let expected = reachable.contains(&(rows, columns));
                                    let actual = bounded_degree_sequence_feasible(
                                        [c0, c1, c2, 0, 0, 0, 0],
                                        rows,
                                        [1, 1, 2, 2],
                                    );
                                    assert_eq!(
                                        actual, expected,
                                        "rows={rows:?} columns={columns:?}"
                                    );
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    #[test]
    fn degree_sequence_predicate_matches_constructive_small_decompositions() {
        for counts in [
            [1_u8, 1, 0, 0, 0, 0],
            [0_u8, 0, 1, 1, 0, 0],
            [1_u8, 0, 0, 0, 1, 0],
        ] {
            let digits = pack_digit_counts(counts);
            let target_total =
                counts[0] + counts[1] + counts[2] + counts[3] + 3 * (counts[4] + counts[5]);
            let mut workspace = G41Q29DirectLiftWorkspace::new(digits).unwrap();
            for mut code in 0_u32..5_u32.pow(7) {
                let mut coefficients = [0_u8; 8];
                for coordinate in 1..8 {
                    coefficients[coordinate] = (code % 5) as u8;
                    code /= 5;
                }
                if coefficients[1..].iter().copied().sum::<u8>() != target_total {
                    continue;
                }
                let structural =
                    g41_q29_degree_sequence_decomposition_feasible(digits, coefficients).unwrap();
                let constructive = decompose_g41_q29_exact_block_coefficients_with_workspace(
                    digits,
                    coefficients,
                    &mut workspace,
                )
                .unwrap()
                .is_some();
                assert_eq!(
                    structural, constructive,
                    "counts={counts:?} coefficients={coefficients:?}"
                );
            }
        }
    }

    #[test]
    fn packed_state_workspace_hot_insert_and_reset_allocate_nothing() {
        let mut workspace = PackedStateWorkspace::<{ 1 << 15 }>::new();
        let (_, allocations) = tracked_allocations(|| {
            for round in 0_u64..8 {
                for value in 0_u64..10_000 {
                    assert!(workspace.insert((round << 32) | value).unwrap());
                }
                workspace.reset();
            }
        });
        assert_eq!(allocations, 0);
    }
}
