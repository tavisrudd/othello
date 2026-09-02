//! Discovery-only common-quotient search over the 768 sealed g41 roots.
//!
//! The exact per-shift filters are necessary but use separate witnesses.  This
//! kernel searches for one four-block assignment satisfying all representative
//! quotient equations simultaneously.  A hit is replayed at all ten quotient
//! shifts; a miss has no coverage or certificate authority.

use ergodis::root_execution::{reduce_roots, RootKernel, RootOrdinal};
use serde::Serialize;
use thiserror::Error;

use crate::g41_defect_scout::{census_g41_quotient_filter, G41DefectScoutError};

const QUOTIENT: usize = 18;
const SLOTS: usize = 6;
const MAX_DOMAIN_PROFILES: usize = 8_192;
// Exact cold compilation payload: 2^27 u64 states = 1 GiB.
const MAX_TOTAL_PAIR_STATES: u64 = 1 << 27;
const RESIDUE_HASH_SLOTS: usize = 1 << 23;
const MAX_PAIR_STATES: usize = 3 * RESIDUE_HASH_SLOTS / 4;
const EMPTY_RESIDUE_STATE: u64 = u64::MAX;
const MAX_FULL_PAIR_RECORDS: usize = 1 << 25;
const MAX_DIGIT_WITNESSES_PER_ROOT: usize = 1 << 12;
const SCALES: [u16; SLOTS] = [4, 4, 2, 2, 2, 2];
const RADICES: [u8; SLOTS] = [8, 8, 15, 15, 15, 15];
const SHIFTS_PACK: [u8; SLOTS] = [0, 3, 6, 10, 14, 18];
const SLOT_RESIDUES: [&[usize]; SLOTS] = [
    &[0],
    &[9],
    &[6, 12],
    &[3, 15],
    &[2, 4, 8, 10, 14, 16],
    &[1, 5, 7, 11, 13, 17],
];
const ACTIVE_SHIFTS: [usize; 5] = [1, 2, 3, 6, 9];

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct FullProfile {
    digits: u32,
    paf: [u16; 5],
    energy: u8,
    reserved: u8,
}

const _: () =
    assert!(std::mem::size_of::<FullProfile>() == 16 && std::mem::align_of::<FullProfile>() == 4);

const EMPTY_PROFILE: FullProfile = FullProfile {
    digits: 0,
    paf: [0; 5],
    energy: 0,
    reserved: 0,
};

#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq)]
pub struct G41JointQuotientWitness {
    pub root_id: u32,
    pub masks: [u8; 4],
    pub digits: [u32; 4],
}

#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq)]
pub struct G41JointResidualWitness {
    pub root_id: u32,
    pub masks: [u8; 4],
    pub digits: [u32; 4],
    pub residual: [i32; 6],
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41JointQuotientSearchReport {
    pub threads: u16,
    pub roots_examined: u32,
    pub restarts_per_root: u32,
    pub sweeps_per_restart: u16,
    pub profile_evaluations: u64,
    pub constructive_quotient_hits: u32,
    pub best_residual: u64,
    pub best_residual_witness: Option<G41JointResidualWitness>,
    pub first_witness_root: Option<u32>,
    pub first_witness: Option<G41JointQuotientWitness>,
    pub provenance: &'static str,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41JointModulusReport {
    pub modulus: u8,
    pub input_roots: u32,
    pub survivors: u32,
    pub exclusions: u32,
    pub pair_domains_compiled: u16,
    pub minimum_pair_states: u32,
    pub maximum_pair_states: u32,
    pub total_pair_states: u64,
    pub surviving_root_ids: Box<[u32]>,
    pub provenance: &'static str,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41JointProjectionReport {
    pub coordinate_mask: u8,
    pub input_roots: u32,
    pub survivors: u32,
    pub exclusions: u32,
    pub pair_domains_compiled: u16,
    pub minimum_pair_states: u32,
    pub maximum_pair_states: u32,
    pub total_pair_states: u64,
    pub surviving_root_ids: Box<[u32]>,
    pub provenance: &'static str,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41JointRootwiseProjectionReport {
    pub threads: u16,
    pub coordinate_mask: u8,
    pub roots_examined: u32,
    pub survivors: u32,
    pub exclusions: u32,
    pub pair_compilations: u32,
    pub surviving_root_ids: Box<[u32]>,
    pub provenance: &'static str,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41JointFullMitmReport {
    pub roots_examined: u32,
    pub survivors: u32,
    pub exclusions: u32,
    pub left_pair_fibres: u16,
    pub left_pair_candidates: u64,
    pub distinct_left_pair_states: u64,
    pub right_pair_candidates: u64,
    pub triple_prefilter_hits: u64,
    pub full_common_hits: u32,
    pub surviving_root_ids: Box<[u32]>,
    pub witnesses: Box<[G41JointQuotientWitness]>,
    pub provenance: &'static str,
}

#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq)]
pub struct G41JointRootMultiplicity {
    pub root_id: u32,
    pub quotient_profile_quadruples: u64,
    pub raw_digit_quadruples: u128,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41JointMultiplicityReport {
    pub roots_examined: u32,
    pub left_pair_fibres: u16,
    pub left_pair_candidates: u64,
    pub distinct_left_pair_states: u64,
    pub right_pair_candidates: u64,
    pub quotient_profile_quadruples: u128,
    pub raw_digit_quadruples: u128,
    pub minimum_root_profile_quadruples: u64,
    pub maximum_root_profile_quadruples: u64,
    pub minimum_root_digit_quadruples: u128,
    pub maximum_root_digit_quadruples: u128,
    pub roots: Box<[G41JointRootMultiplicity]>,
    pub provenance: &'static str,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41JointDigitWitnessReport {
    pub roots_examined: u32,
    pub digit_witnesses: u64,
    pub minimum_root_witnesses: u32,
    pub maximum_root_witnesses: u32,
    pub root_offsets: Box<[u32]>,
    pub witnesses: Box<[G41JointQuotientWitness]>,
    pub provenance: &'static str,
}

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
struct ProjectionState {
    values: [u16; 4],
}

const _: () = assert!(
    std::mem::size_of::<ProjectionState>() == 8 && std::mem::align_of::<ProjectionState>() == 2
);

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
struct FullPairState {
    low: u64,
    high: u64,
}

const _: () = assert!(
    std::mem::size_of::<FullPairState>() == 16 && std::mem::align_of::<FullPairState>() == 8
);

#[repr(C)]
#[derive(Clone, Copy)]
struct WeightedFullProfile {
    profile: FullProfile,
    multiplicity: u16,
    _pad: [u8; 14],
}

const _: () = assert!(
    std::mem::size_of::<WeightedFullProfile>() == 32
        && std::mem::align_of::<WeightedFullProfile>() == 4
);

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
struct WeightedPairState {
    state: FullPairState,
    raw_digit_pairs: u64,
    profile_pairs: u32,
    _pad: u32,
}

const _: () = assert!(
    std::mem::size_of::<WeightedPairState>() == 32
        && std::mem::align_of::<WeightedPairState>() == 8
);

#[repr(C)]
#[derive(Clone, Copy)]
struct RawPairRecord {
    state: FullPairState,
    digits: [u32; 2],
    _pad: [u8; 8],
}

const _: () = assert!(
    std::mem::size_of::<RawPairRecord>() == 32 && std::mem::align_of::<RawPairRecord>() == 8
);

#[derive(Clone, Debug, Error, PartialEq, Eq)]
pub enum G41JointQuotientSearchError {
    #[error("g41 joint quotient profile budget exceeded")]
    StateBudget,
    #[error("g41 joint quotient semantics or direct replay failed")]
    SemanticMismatch,
    #[error("parallel root executor rejected the bounded campaign")]
    ParallelExecution,
    #[error(transparent)]
    Filter(#[from] G41DefectScoutError),
}

fn decode_word(mask: u8, packed: u32) -> [u16; QUOTIENT] {
    let mut word = [0_u16; QUOTIENT];
    for (slot, residues) in SLOT_RESIDUES.iter().enumerate() {
        let bits = if slot < 2 { 3 } else { 4 };
        let digit = ((packed >> SHIFTS_PACK[slot]) & ((1 << bits) - 1)) as u16;
        let value = u16::from((mask >> slot) & 1) + SCALES[slot] * digit;
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

fn packed_digits_from_code(mut code: u32) -> u32 {
    let mut packed = 0_u32;
    for slot in 0..SLOTS {
        let radix = u32::from(RADICES[slot]);
        packed |= (code % radix) << SHIFTS_PACK[slot];
        code /= radix;
    }
    packed
}

fn profile_from_packed(mask: u8, row_target: u16, packed: u32) -> Option<FullProfile> {
    let word = decode_word(mask, packed);
    if word.iter().copied().sum::<u16>() != row_target {
        return None;
    }
    let signed = word
        .iter()
        .map(|&value| {
            let signed = 2 * i32::from(value) - 29;
            signed * signed
        })
        .sum::<i32>();
    let excess = signed - 34;
    if excess < 0 || excess % 8 != 0 || excess / 8 > 230 {
        return None;
    }
    Some(FullProfile {
        digits: packed,
        paf: std::array::from_fn(|index| paf(&word, ACTIVE_SHIFTS[index]) as u16),
        energy: (excess / 8) as u8,
        reserved: 0,
    })
}

fn compile_raw_domain(
    mask: u8,
    row_target: u16,
) -> Result<Vec<FullProfile>, G41JointQuotientSearchError> {
    const RAW_ASSIGNMENTS: u32 = 8 * 8 * 15 * 15 * 15 * 15;
    let mut profiles = Vec::with_capacity(MAX_DOMAIN_PROFILES);
    for code in 0..RAW_ASSIGNMENTS {
        let Some(profile) = profile_from_packed(mask, row_target, packed_digits_from_code(code))
        else {
            continue;
        };
        if profiles.len() == MAX_DOMAIN_PROFILES {
            return Err(G41JointQuotientSearchError::StateBudget);
        }
        profiles.push(profile);
    }
    profiles.sort_unstable_by_key(|profile| (profile.energy, profile.paf));
    if profiles.is_empty() {
        return Err(G41JointQuotientSearchError::SemanticMismatch);
    }
    Ok(profiles)
}

fn compile_domain(
    mask: u8,
    row_target: u16,
) -> Result<Box<[FullProfile]>, G41JointQuotientSearchError> {
    let mut profiles = compile_raw_domain(mask, row_target)?;
    profiles.dedup_by_key(|profile| (profile.energy, profile.paf));
    Ok(profiles.into_boxed_slice())
}

fn compile_weighted_domain(
    mask: u8,
    row_target: u16,
) -> Result<Box<[WeightedFullProfile]>, G41JointQuotientSearchError> {
    let raw_profiles = compile_raw_domain(mask, row_target)?;
    let mut profiles = Vec::<WeightedFullProfile>::with_capacity(raw_profiles.len());
    for profile in raw_profiles {
        if let Some(last) = profiles.last_mut() {
            if last.profile.energy == profile.energy && last.profile.paf == profile.paf {
                last.multiplicity = last
                    .multiplicity
                    .checked_add(1)
                    .ok_or(G41JointQuotientSearchError::StateBudget)?;
                continue;
            }
        }
        profiles.push(WeightedFullProfile {
            profile,
            multiplicity: 1,
            _pad: [0; 14],
        });
    }
    if profiles.is_empty() {
        return Err(G41JointQuotientSearchError::SemanticMismatch);
    }
    Ok(profiles.into_boxed_slice())
}

fn residual(profiles: &[FullProfile; 4]) -> u64 {
    let energy = profiles
        .iter()
        .map(|profile| u32::from(profile.energy))
        .sum::<u32>();
    let mut score = u64::from(energy.abs_diff(230)) * 64;
    for shift in 0..5 {
        let value = profiles
            .iter()
            .map(|profile| u32::from(profile.paf[shift]))
            .sum::<u32>();
        score += u64::from(value.abs_diff(15_080));
    }
    score
}

fn residual_vector(profiles: &[FullProfile; 4]) -> [i32; 6] {
    let energy = profiles
        .iter()
        .map(|profile| i32::from(profile.energy))
        .sum::<i32>()
        - 230;
    let paf: [i32; 5] = std::array::from_fn(|shift| {
        profiles
            .iter()
            .map(|profile| i32::from(profile.paf[shift]))
            .sum::<i32>()
            - 15_080
    });
    [energy, paf[0], paf[1], paf[2], paf[3], paf[4]]
}

fn next_random(state: &mut u64) -> u64 {
    let mut value = *state;
    value ^= value << 13;
    value ^= value >> 7;
    value ^= value << 17;
    *state = value;
    value
}

fn residue_state(profile: &FullProfile, modulus: u8) -> u64 {
    let modulus = u64::from(modulus);
    let mut factor = 1_u64;
    let mut state = u64::from(profile.energy) % modulus;
    for shift in 0..5 {
        factor *= modulus;
        state += (u64::from(profile.paf[shift]) % modulus) * factor;
    }
    state
}

fn add_residue_states(mut left: u64, mut right: u64, modulus: u8) -> u64 {
    let modulus = u64::from(modulus);
    let mut factor = 1_u64;
    let mut output = 0_u64;
    for _ in 0..6 {
        output += ((left % modulus + right % modulus) % modulus) * factor;
        left /= modulus;
        right /= modulus;
        factor *= modulus;
    }
    output
}

fn complement_residue_state(mut value: u64, modulus: u8) -> u64 {
    let modulus = u64::from(modulus);
    let mut factor = 1_u64;
    let mut output = 0_u64;
    for coordinate in 0..6 {
        let target = if coordinate == 0 { 230 } else { 15_080 } % modulus;
        output += ((target + modulus - value % modulus) % modulus) * factor;
        value /= modulus;
        factor *= modulus;
    }
    output
}

fn compile_residue_domain(profiles: &[FullProfile], modulus: u8) -> Box<[u64]> {
    let mut states = Vec::with_capacity(MAX_DOMAIN_PROFILES);
    for profile in profiles {
        states.push(residue_state(profile, modulus));
    }
    states.sort_unstable();
    states.dedup();
    states.into_boxed_slice()
}

struct ResidueWorkspace {
    keys: Box<[u64]>,
    touched: Vec<u32>,
}

impl ResidueWorkspace {
    fn new(modulus: u8) -> Result<Self, G41JointQuotientSearchError> {
        if !(2..=64).contains(&modulus) {
            return Err(G41JointQuotientSearchError::StateBudget);
        }
        Ok(Self {
            keys: vec![EMPTY_RESIDUE_STATE; RESIDUE_HASH_SLOTS].into_boxed_slice(),
            touched: Vec::with_capacity(MAX_PAIR_STATES),
        })
    }

    fn insert(
        &mut self,
        state: u64,
        state_limit: usize,
    ) -> Result<bool, G41JointQuotientSearchError> {
        let mut slot =
            (state.wrapping_mul(0x9e37_79b9_7f4a_7c15) as usize) & (RESIDUE_HASH_SLOTS - 1);
        loop {
            let key = self.keys[slot];
            if key == state {
                return Ok(false);
            }
            if key == EMPTY_RESIDUE_STATE {
                if self.touched.len() == state_limit || self.touched.len() == MAX_PAIR_STATES {
                    return Err(G41JointQuotientSearchError::StateBudget);
                }
                self.keys[slot] = state;
                self.touched.push(slot as u32);
                return Ok(true);
            }
            slot = (slot + 1) & (RESIDUE_HASH_SLOTS - 1);
        }
    }

    fn reset(&mut self) {
        for &slot in &self.touched {
            self.keys[slot as usize] = EMPTY_RESIDUE_STATE;
        }
        self.touched.clear();
    }

    fn contains(&self, state: u64) -> bool {
        let mut slot =
            (state.wrapping_mul(0x9e37_79b9_7f4a_7c15) as usize) & (RESIDUE_HASH_SLOTS - 1);
        loop {
            let key = self.keys[slot];
            if key == state {
                return true;
            }
            if key == EMPTY_RESIDUE_STATE {
                return false;
            }
            slot = (slot + 1) & (RESIDUE_HASH_SLOTS - 1);
        }
    }
}

fn compile_residue_pair(
    first: &[u64],
    second: &[u64],
    modulus: u8,
    workspace: &mut ResidueWorkspace,
    state_limit: usize,
) -> Result<Box<[u64]>, G41JointQuotientSearchError> {
    let product = first
        .len()
        .checked_mul(second.len())
        .ok_or(G41JointQuotientSearchError::StateBudget)?;
    let state_limit = state_limit.min(MAX_PAIR_STATES);
    let mut states = Vec::with_capacity(product.min(state_limit));
    for &left in first {
        for &right in second {
            let state = add_residue_states(left, right, modulus);
            let inserted = match workspace.insert(state, state_limit) {
                Ok(inserted) => inserted,
                Err(error) => {
                    workspace.reset();
                    return Err(error);
                }
            };
            if inserted {
                states.push(state);
            }
        }
    }
    workspace.reset();
    states.sort_unstable();
    Ok(states.into_boxed_slice())
}

fn profile_coordinate(profile: &FullProfile, coordinate: usize) -> u16 {
    if coordinate == 0 {
        u16::from(profile.energy)
    } else {
        profile.paf[coordinate - 1]
    }
}

fn coordinate_target(coordinate: usize) -> u16 {
    if coordinate == 0 {
        230
    } else {
        15_080
    }
}

fn projection_coordinates(mask: u8) -> Result<([u8; 4], usize), G41JointQuotientSearchError> {
    if mask == 0 || mask & !0x3f != 0 || mask.count_ones() > 4 {
        return Err(G41JointQuotientSearchError::StateBudget);
    }
    let mut coordinates = [0_u8; 4];
    let mut count = 0;
    for coordinate in 0_u8..6 {
        if mask & (1 << coordinate) != 0 {
            coordinates[count] = coordinate;
            count += 1;
        }
    }
    Ok((coordinates, count))
}

fn compile_projection_domain(
    profiles: &[FullProfile],
    coordinates: &[u8; 4],
    count: usize,
) -> Box<[ProjectionState]> {
    let mut states = Vec::with_capacity(profiles.len());
    for profile in profiles {
        let mut state = ProjectionState { values: [0; 4] };
        for index in 0..count {
            state.values[index] = profile_coordinate(profile, usize::from(coordinates[index]));
        }
        states.push(state);
    }
    states.sort_unstable();
    states.dedup();
    states.into_boxed_slice()
}

fn encode_projection(values: &[u16; 4], coordinates: &[u8; 4], count: usize) -> u64 {
    let mut factor = 1_u64;
    let mut encoded = 0_u64;
    for index in 0..count {
        encoded += u64::from(values[index]) * factor;
        factor *= u64::from(coordinate_target(usize::from(coordinates[index]))) + 1;
    }
    encoded
}

fn complement_projection(mut encoded: u64, coordinates: &[u8; 4], count: usize) -> u64 {
    let mut complement = [0_u16; 4];
    for index in 0..count {
        let target = coordinate_target(usize::from(coordinates[index]));
        let radix = u64::from(target) + 1;
        complement[index] = target - (encoded % radix) as u16;
        encoded /= radix;
    }
    encode_projection(&complement, coordinates, count)
}

fn full_pair_state(left: &FullProfile, right: &FullProfile) -> Option<FullPairState> {
    let energy = u16::from(left.energy) + u16::from(right.energy);
    if energy > 230 {
        return None;
    }
    let mut paf = [0_u16; 5];
    for index in 0..5 {
        let value = u32::from(left.paf[index]) + u32::from(right.paf[index]);
        if value > 15_080 {
            return None;
        }
        paf[index] = value as u16;
    }
    Some(FullPairState {
        low: u64::from(energy)
            | (u64::from(paf[0]) << 8)
            | (u64::from(paf[1]) << 22)
            | (u64::from(paf[2]) << 36)
            | (u64::from(paf[3]) << 50),
        high: u64::from(paf[4]),
    })
}

fn full_pair_coordinate(state: FullPairState, coordinate: usize) -> u16 {
    match coordinate {
        0 => (state.low & 0xff) as u16,
        1 => ((state.low >> 8) & 0x3fff) as u16,
        2 => ((state.low >> 22) & 0x3fff) as u16,
        3 => ((state.low >> 36) & 0x3fff) as u16,
        4 => ((state.low >> 50) & 0x3fff) as u16,
        5 => (state.high & 0x3fff) as u16,
        _ => unreachable!("fixed six-coordinate profile"),
    }
}

fn complement_full_pair_state(left: &FullProfile, right: &FullProfile) -> Option<FullPairState> {
    let sum = full_pair_state(left, right)?;
    let energy = 230 - full_pair_coordinate(sum, 0);
    let paf: [u16; 5] = std::array::from_fn(|index| 15_080 - full_pair_coordinate(sum, index + 1));
    Some(FullPairState {
        low: u64::from(energy)
            | (u64::from(paf[0]) << 8)
            | (u64::from(paf[1]) << 22)
            | (u64::from(paf[2]) << 36)
            | (u64::from(paf[3]) << 50),
        high: u64::from(paf[4]),
    })
}

fn triple_projection_key(state: FullPairState) -> u64 {
    let values = [
        full_pair_coordinate(state, 2),
        full_pair_coordinate(state, 3),
        full_pair_coordinate(state, 4),
        0,
    ];
    encode_projection(&values, &[2, 3, 4, 0], 3)
}

fn complement_triple_projection_key(left: &FullProfile, right: &FullProfile) -> Option<u64> {
    let mut values = [0_u16; 4];
    for (output, coordinate) in values.iter_mut().zip([2_usize, 3, 4]) {
        let sum = u32::from(profile_coordinate(left, coordinate))
            + u32::from(profile_coordinate(right, coordinate));
        if sum > 15_080 {
            return None;
        }
        *output = (15_080 - sum) as u16;
    }
    Some(encode_projection(&values, &[2, 3, 4, 0], 3))
}

fn compile_projection_pair(
    first: &[ProjectionState],
    second: &[ProjectionState],
    coordinates: &[u8; 4],
    count: usize,
    workspace: &mut ResidueWorkspace,
    state_limit: usize,
) -> Result<Box<[u64]>, G41JointQuotientSearchError> {
    let product = first
        .len()
        .checked_mul(second.len())
        .ok_or(G41JointQuotientSearchError::StateBudget)?;
    let state_limit = state_limit.min(MAX_PAIR_STATES);
    let mut states = Vec::with_capacity(product.min(state_limit));
    for left in first {
        for right in second {
            let mut sum = [0_u16; 4];
            let mut admissible = true;
            for index in 0..count {
                let value = u32::from(left.values[index]) + u32::from(right.values[index]);
                if value > u32::from(coordinate_target(usize::from(coordinates[index]))) {
                    admissible = false;
                    break;
                }
                sum[index] = value as u16;
            }
            if !admissible {
                continue;
            }
            let state = encode_projection(&sum, coordinates, count);
            let inserted = match workspace.insert(state, state_limit) {
                Ok(inserted) => inserted,
                Err(error) => {
                    workspace.reset();
                    return Err(error);
                }
            };
            if inserted {
                states.push(state);
            }
        }
    }
    workspace.reset();
    states.sort_unstable();
    Ok(states.into_boxed_slice())
}

fn compile_projection_pair_into(
    first: &[ProjectionState],
    second: &[ProjectionState],
    coordinates: &[u8; 4],
    count: usize,
    workspace: &mut ResidueWorkspace,
    states: &mut Vec<u64>,
) -> Result<(), G41JointQuotientSearchError> {
    states.clear();
    for left in first {
        for right in second {
            let mut sum = [0_u16; 4];
            let mut admissible = true;
            for index in 0..count {
                let value = u32::from(left.values[index]) + u32::from(right.values[index]);
                if value > u32::from(coordinate_target(usize::from(coordinates[index]))) {
                    admissible = false;
                    break;
                }
                sum[index] = value as u16;
            }
            if !admissible {
                continue;
            }
            let state = encode_projection(&sum, coordinates, count);
            let inserted = match workspace.insert(state, states.capacity()) {
                Ok(inserted) => inserted,
                Err(error) => {
                    workspace.reset();
                    return Err(error);
                }
            };
            if inserted {
                states.push(state);
            }
        }
    }
    workspace.reset();
    states.sort_unstable();
    Ok(())
}

struct ProjectionRootKernel {
    projected: [Option<Box<[ProjectionState]>>; 1 << SLOTS],
    coordinates: [u8; 4],
    count: usize,
}

struct ProjectionRootWorker {
    workspace: ResidueWorkspace,
    left: Vec<u64>,
    right: Vec<u64>,
}

#[repr(C)]
struct ProjectionRootAccumulator {
    survivor_bits: [u64; 12],
    roots_examined: u32,
    survivors: u32,
    pair_compilations: u32,
    reserved: u32,
}

const _: () = assert!(
    std::mem::size_of::<ProjectionRootAccumulator>() == 112
        && std::mem::align_of::<ProjectionRootAccumulator>() == 8
);

impl RootKernel for ProjectionRootKernel {
    type Root = [u8; 4];
    type Worker = ProjectionRootWorker;
    type Output = Result<ProjectionRootAccumulator, G41JointQuotientSearchError>;

    fn create_worker(&self) -> Self::Worker {
        ProjectionRootWorker {
            workspace: ResidueWorkspace::new(2).expect("fixed projection workspace"),
            left: Vec::with_capacity(MAX_PAIR_STATES),
            right: Vec::with_capacity(MAX_PAIR_STATES),
        }
    }

    fn evaluate(
        &self,
        worker: &mut Self::Worker,
        ordinal: RootOrdinal,
        root: &Self::Root,
    ) -> Self::Output {
        if ordinal.0 >= 768 {
            return Err(G41JointQuotientSearchError::StateBudget);
        }
        compile_projection_pair_into(
            self.projected[usize::from(root[0])]
                .as_deref()
                .ok_or(G41JointQuotientSearchError::SemanticMismatch)?,
            self.projected[usize::from(root[1])]
                .as_deref()
                .ok_or(G41JointQuotientSearchError::SemanticMismatch)?,
            &self.coordinates,
            self.count,
            &mut worker.workspace,
            &mut worker.left,
        )?;
        compile_projection_pair_into(
            self.projected[usize::from(root[2])]
                .as_deref()
                .ok_or(G41JointQuotientSearchError::SemanticMismatch)?,
            self.projected[usize::from(root[3])]
                .as_deref()
                .ok_or(G41JointQuotientSearchError::SemanticMismatch)?,
            &self.coordinates,
            self.count,
            &mut worker.workspace,
            &mut worker.right,
        )?;
        let compatible = worker.left.iter().any(|&state| {
            worker
                .right
                .binary_search(&complement_projection(state, &self.coordinates, self.count))
                .is_ok()
        });
        let mut output = ProjectionRootAccumulator {
            survivor_bits: [0; 12],
            roots_examined: 1,
            survivors: u32::from(compatible),
            pair_compilations: 2,
            reserved: 0,
        };
        if compatible {
            output.survivor_bits[ordinal.0 as usize / 64] |= 1_u64 << (ordinal.0 % 64);
        }
        Ok(output)
    }
}

fn merge_projection_root_accumulators(
    left: Result<ProjectionRootAccumulator, G41JointQuotientSearchError>,
    right: Result<ProjectionRootAccumulator, G41JointQuotientSearchError>,
) -> Result<ProjectionRootAccumulator, G41JointQuotientSearchError> {
    let mut left = left?;
    let right = right?;
    for index in 0..left.survivor_bits.len() {
        left.survivor_bits[index] |= right.survivor_bits[index];
    }
    left.roots_examined = left
        .roots_examined
        .checked_add(right.roots_examined)
        .ok_or(G41JointQuotientSearchError::StateBudget)?;
    left.survivors = left
        .survivors
        .checked_add(right.survivors)
        .ok_or(G41JointQuotientSearchError::StateBudget)?;
    left.pair_compilations = left
        .pair_compilations
        .checked_add(right.pair_compilations)
        .ok_or(G41JointQuotientSearchError::StateBudget)?;
    Ok(left)
}

pub(crate) fn replay_witness(
    witness: &G41JointQuotientWitness,
) -> Result<(), G41JointQuotientSearchError> {
    let targets = [260_u16, 261, 261, 261];
    let words: [[u16; QUOTIENT]; 4] =
        std::array::from_fn(|block| decode_word(witness.masks[block], witness.digits[block]));
    for block in 0..4 {
        if words[block].iter().copied().sum::<u16>() != targets[block] {
            return Err(G41JointQuotientSearchError::SemanticMismatch);
        }
    }
    for shift in 0..10 {
        let target = if shift == 0 { 15_603 } else { 15_080 };
        if words.iter().map(|word| paf(word, shift)).sum::<u32>() != target {
            return Err(G41JointQuotientSearchError::SemanticMismatch);
        }
    }
    Ok(())
}

struct JointKernel {
    domains: [Option<Box<[FullProfile]>>; 1 << SLOTS],
    restarts: u32,
    sweeps: u16,
}

struct JointWorker;

impl JointKernel {
    fn evaluate_root(
        &self,
        ordinal: RootOrdinal,
        masks: &[u8; 4],
    ) -> Result<G41JointQuotientSearchReport, G41JointQuotientSearchError> {
        let domains: [&[FullProfile]; 4] = std::array::from_fn(|block| {
            self.domains[usize::from(masks[block])]
                .as_deref()
                .expect("root domains are compiled")
        });
        let mut random = 0x9e37_79b9_7f4a_7c15_u64 ^ u64::from(ordinal.0);
        let mut selected = [EMPTY_PROFILE; 4];
        let mut best_profiles = [EMPTY_PROFILE; 4];
        let mut best = u64::MAX;
        let mut evaluations = 0_u64;
        let root_id = u32::from(masks[0])
            | (u32::from(masks[1]) << 6)
            | (u32::from(masks[2]) << 12)
            | (u32::from(masks[3]) << 18);
        for _ in 0..self.restarts {
            for block in 0..4 {
                let index = next_random(&mut random) as usize % domains[block].len();
                selected[block] = domains[block][index];
            }
            for _ in 0..self.sweeps {
                for block in 0..4 {
                    let mut block_best = u64::MAX;
                    let mut chosen = selected[block];
                    for &candidate in domains[block] {
                        selected[block] = candidate;
                        let score = residual(&selected);
                        evaluations = evaluations
                            .checked_add(1)
                            .ok_or(G41JointQuotientSearchError::StateBudget)?;
                        if score < block_best {
                            block_best = score;
                            chosen = candidate;
                        }
                    }
                    selected[block] = chosen;
                    if block_best < best {
                        best = block_best;
                        best_profiles = selected;
                    }
                    if best == 0 {
                        let witness = G41JointQuotientWitness {
                            root_id,
                            masks: *masks,
                            digits: std::array::from_fn(|index| selected[index].digits),
                        };
                        replay_witness(&witness)?;
                        return Ok(G41JointQuotientSearchReport {
                            threads: 0,
                            roots_examined: 1,
                            restarts_per_root: self.restarts,
                            sweeps_per_restart: self.sweeps,
                            profile_evaluations: evaluations,
                            constructive_quotient_hits: 1,
                            best_residual: 0,
                            best_residual_witness: Some(G41JointResidualWitness {
                                root_id,
                                masks: *masks,
                                digits: witness.digits,
                                residual: [0; 6],
                            }),
                            first_witness_root: Some(ordinal.0),
                            first_witness: Some(witness),
                            provenance: "discovery-only positive replay; misses have no authority",
                        });
                    }
                }
            }
        }
        Ok(G41JointQuotientSearchReport {
            threads: 0,
            roots_examined: 1,
            restarts_per_root: self.restarts,
            sweeps_per_restart: self.sweeps,
            profile_evaluations: evaluations,
            constructive_quotient_hits: 0,
            best_residual: best,
            best_residual_witness: Some(G41JointResidualWitness {
                root_id,
                masks: *masks,
                digits: std::array::from_fn(|index| best_profiles[index].digits),
                residual: residual_vector(&best_profiles),
            }),
            first_witness_root: None,
            first_witness: None,
            provenance: "discovery-only positive replay; misses have no authority",
        })
    }
}

impl RootKernel for JointKernel {
    type Root = [u8; 4];
    type Worker = JointWorker;
    type Output = Result<G41JointQuotientSearchReport, G41JointQuotientSearchError>;

    fn create_worker(&self) -> Self::Worker {
        JointWorker
    }

    fn evaluate(
        &self,
        _worker: &mut Self::Worker,
        ordinal: RootOrdinal,
        root: &Self::Root,
    ) -> Self::Output {
        self.evaluate_root(ordinal, root)
    }
}

fn merge_reports(
    left: Result<G41JointQuotientSearchReport, G41JointQuotientSearchError>,
    right: Result<G41JointQuotientSearchReport, G41JointQuotientSearchError>,
) -> Result<G41JointQuotientSearchReport, G41JointQuotientSearchError> {
    let mut left = left?;
    let right = right?;
    left.roots_examined = left
        .roots_examined
        .checked_add(right.roots_examined)
        .ok_or(G41JointQuotientSearchError::StateBudget)?;
    left.profile_evaluations = left
        .profile_evaluations
        .checked_add(right.profile_evaluations)
        .ok_or(G41JointQuotientSearchError::StateBudget)?;
    left.constructive_quotient_hits = left
        .constructive_quotient_hits
        .checked_add(right.constructive_quotient_hits)
        .ok_or(G41JointQuotientSearchError::StateBudget)?;
    if right.best_residual < left.best_residual {
        left.best_residual = right.best_residual;
        left.best_residual_witness = right.best_residual_witness;
    }
    if witness_root_precedes(left.first_witness_root, right.first_witness_root) {
        left.first_witness_root = right.first_witness_root;
        left.first_witness = right.first_witness;
    }
    Ok(left)
}

#[inline]
fn witness_root_precedes(left: Option<u32>, right: Option<u32>) -> bool {
    right.is_some() && (left.is_none() || right < left)
}

fn compile_campaign(
) -> Result<(Vec<[u8; 4]>, [Option<Box<[FullProfile]>>; 1 << SLOTS]), G41JointQuotientSearchError> {
    let filter = census_g41_quotient_filter()?;
    let mut roots = Vec::<[u8; 4]>::with_capacity(768);
    for &root in filter.surviving_root_ids.iter() {
        if roots.len() == roots.capacity() {
            return Err(G41JointQuotientSearchError::StateBudget);
        }
        roots.push(std::array::from_fn(|block| {
            ((root >> (6 * block)) & 63) as u8
        }));
    }
    let mut required = [false; 1 << SLOTS];
    for root in &roots {
        for &mask in root {
            required[usize::from(mask)] = true;
        }
    }
    let mut domains: [Option<Box<[FullProfile]>>; 1 << SLOTS] = std::array::from_fn(|_| None);
    for mask in 0_u8..1 << SLOTS {
        if required[usize::from(mask)] {
            let row_target = if (mask & 3).count_ones() & 1 == 0 {
                260
            } else {
                261
            };
            domains[usize::from(mask)] = Some(compile_domain(mask, row_target)?);
        }
    }
    Ok((roots, domains))
}

fn compile_weighted_campaign() -> Result<
    (
        Vec<[u8; 4]>,
        [Option<Box<[WeightedFullProfile]>>; 1 << SLOTS],
    ),
    G41JointQuotientSearchError,
> {
    let filter = census_g41_quotient_filter()?;
    let mut roots = Vec::<[u8; 4]>::with_capacity(768);
    for &root in filter.surviving_root_ids.iter() {
        if roots.len() == roots.capacity() {
            return Err(G41JointQuotientSearchError::StateBudget);
        }
        roots.push(std::array::from_fn(|block| {
            ((root >> (6 * block)) & 63) as u8
        }));
    }
    let mut required = [false; 1 << SLOTS];
    for root in &roots {
        for &mask in root {
            required[usize::from(mask)] = true;
        }
    }
    let mut domains: [Option<Box<[WeightedFullProfile]>>; 1 << SLOTS] =
        std::array::from_fn(|_| None);
    for mask in 0_u8..1 << SLOTS {
        if required[usize::from(mask)] {
            let row_target = if (mask & 3).count_ones() & 1 == 0 {
                260
            } else {
                261
            };
            domains[usize::from(mask)] = Some(compile_weighted_domain(mask, row_target)?);
        }
    }
    Ok((roots, domains))
}

fn compile_raw_campaign(
) -> Result<(Vec<[u8; 4]>, [Option<Box<[FullProfile]>>; 1 << SLOTS]), G41JointQuotientSearchError> {
    let filter = census_g41_quotient_filter()?;
    let mut roots = Vec::<[u8; 4]>::with_capacity(768);
    for &root in filter.surviving_root_ids.iter() {
        if roots.len() == roots.capacity() {
            return Err(G41JointQuotientSearchError::StateBudget);
        }
        roots.push(std::array::from_fn(|block| {
            ((root >> (6 * block)) & 63) as u8
        }));
    }
    let mut required = [false; 1 << SLOTS];
    for root in &roots {
        for &mask in root {
            required[usize::from(mask)] = true;
        }
    }
    let mut domains: [Option<Box<[FullProfile]>>; 1 << SLOTS] = std::array::from_fn(|_| None);
    for mask in 0_u8..1 << SLOTS {
        if required[usize::from(mask)] {
            let row_target = if (mask & 3).count_ones() & 1 == 0 {
                260
            } else {
                261
            };
            domains[usize::from(mask)] =
                Some(compile_raw_domain(mask, row_target)?.into_boxed_slice());
        }
    }
    Ok((roots, domains))
}

pub fn search_g41_joint_quotient(
    threads: usize,
    restarts: u32,
    sweeps: u16,
) -> Result<G41JointQuotientSearchReport, G41JointQuotientSearchError> {
    if threads == 0 || threads > 64 || restarts == 0 || sweeps == 0 {
        return Err(G41JointQuotientSearchError::StateBudget);
    }
    let (roots, domains) = compile_campaign()?;
    let kernel = JointKernel {
        domains,
        restarts,
        sweeps,
    };
    let mut report = reduce_roots(
        &kernel,
        &roots,
        threads,
        || {
            Ok(G41JointQuotientSearchReport {
                threads: 0,
                roots_examined: 0,
                restarts_per_root: restarts,
                sweeps_per_restart: sweeps,
                profile_evaluations: 0,
                constructive_quotient_hits: 0,
                best_residual: u64::MAX,
                best_residual_witness: None,
                first_witness_root: None,
                first_witness: None,
                provenance: "discovery-only positive replay; misses have no authority",
            })
        },
        merge_reports,
    )
    .map_err(|_| G41JointQuotientSearchError::ParallelExecution)??;
    report.threads =
        u16::try_from(threads).map_err(|_| G41JointQuotientSearchError::StateBudget)?;
    Ok(report)
}

fn census_compiled_modulus(
    roots: &[[u8; 4]],
    domains: &[Option<Box<[FullProfile]>>; 1 << SLOTS],
    modulus: u8,
) -> Result<G41JointModulusReport, G41JointQuotientSearchError> {
    let mut workspace = ResidueWorkspace::new(modulus)?;
    let mut residue_domains: [Option<Box<[u64]>>; 1 << SLOTS] = std::array::from_fn(|_| None);
    for mask in 0..1 << SLOTS {
        if let Some(domain) = domains[mask].as_deref() {
            residue_domains[mask] = Some(compile_residue_domain(domain, modulus));
        }
    }
    let mut required_pairs = [false; 1 << (2 * SLOTS)];
    for root in roots {
        required_pairs[usize::from(root[0]) * (1 << SLOTS) + usize::from(root[1])] = true;
        required_pairs[usize::from(root[2]) * (1 << SLOTS) + usize::from(root[3])] = true;
    }
    let mut pair_domains: [Option<Box<[u64]>>; 1 << (2 * SLOTS)] = std::array::from_fn(|_| None);
    let mut compiled = 0_u16;
    let mut minimum = u32::MAX;
    let mut maximum = 0_u32;
    let mut total = 0_u64;
    for first in 0..1 << SLOTS {
        for second in 0..1 << SLOTS {
            let index = first * (1 << SLOTS) + second;
            if !required_pairs[index] {
                continue;
            }
            let pair = compile_residue_pair(
                residue_domains[first]
                    .as_deref()
                    .ok_or(G41JointQuotientSearchError::SemanticMismatch)?,
                residue_domains[second]
                    .as_deref()
                    .ok_or(G41JointQuotientSearchError::SemanticMismatch)?,
                modulus,
                &mut workspace,
                usize::try_from(MAX_TOTAL_PAIR_STATES - total)
                    .map_err(|_| G41JointQuotientSearchError::StateBudget)?,
            )?;
            let count =
                u32::try_from(pair.len()).map_err(|_| G41JointQuotientSearchError::StateBudget)?;
            minimum = minimum.min(count);
            maximum = maximum.max(count);
            let next_total = total
                .checked_add(u64::from(count))
                .ok_or(G41JointQuotientSearchError::StateBudget)?;
            if next_total > MAX_TOTAL_PAIR_STATES {
                return Err(G41JointQuotientSearchError::StateBudget);
            }
            total = next_total;
            pair_domains[index] = Some(pair);
            compiled = compiled
                .checked_add(1)
                .ok_or(G41JointQuotientSearchError::StateBudget)?;
        }
    }
    let mut survivors = Vec::<u32>::with_capacity(roots.len());
    for root in roots {
        let left = pair_domains[usize::from(root[0]) * (1 << SLOTS) + usize::from(root[1])]
            .as_deref()
            .ok_or(G41JointQuotientSearchError::SemanticMismatch)?;
        let right = pair_domains[usize::from(root[2]) * (1 << SLOTS) + usize::from(root[3])]
            .as_deref()
            .ok_or(G41JointQuotientSearchError::SemanticMismatch)?;
        let compatible = left.iter().any(|&state| {
            right
                .binary_search(&complement_residue_state(state, modulus))
                .is_ok()
        });
        if compatible {
            survivors.push(
                u32::from(root[0])
                    | (u32::from(root[1]) << 6)
                    | (u32::from(root[2]) << 12)
                    | (u32::from(root[3]) << 18),
            );
        }
    }
    Ok(G41JointModulusReport {
        modulus,
        input_roots: roots.len() as u32,
        survivors: survivors.len() as u32,
        exclusions: (roots.len() - survivors.len()) as u32,
        pair_domains_compiled: compiled,
        minimum_pair_states: minimum,
        maximum_pair_states: maximum,
        total_pair_states: total,
        surviving_root_ids: survivors.into_boxed_slice(),
        provenance: "exact necessary joint congruence; survivors have no common-witness authority",
    })
}

fn census_compiled_projection(
    roots: &[[u8; 4]],
    domains: &[Option<Box<[FullProfile]>>; 1 << SLOTS],
    coordinate_mask: u8,
) -> Result<G41JointProjectionReport, G41JointQuotientSearchError> {
    let (coordinates, count) = projection_coordinates(coordinate_mask)?;
    let mut workspace = ResidueWorkspace::new(2)?;
    let mut projected: [Option<Box<[ProjectionState]>>; 1 << SLOTS] = std::array::from_fn(|_| None);
    for mask in 0..1 << SLOTS {
        if let Some(domain) = domains[mask].as_deref() {
            projected[mask] = Some(compile_projection_domain(domain, &coordinates, count));
        }
    }
    let mut required_pairs = [false; 1 << (2 * SLOTS)];
    for root in roots {
        required_pairs[usize::from(root[0]) * (1 << SLOTS) + usize::from(root[1])] = true;
        required_pairs[usize::from(root[2]) * (1 << SLOTS) + usize::from(root[3])] = true;
    }
    let mut pair_domains: [Option<Box<[u64]>>; 1 << (2 * SLOTS)] = std::array::from_fn(|_| None);
    let mut compiled = 0_u16;
    let mut minimum = u32::MAX;
    let mut maximum = 0_u32;
    let mut total = 0_u64;
    for first in 0..1 << SLOTS {
        for second in 0..1 << SLOTS {
            let index = first * (1 << SLOTS) + second;
            if !required_pairs[index] {
                continue;
            }
            let pair = compile_projection_pair(
                projected[first]
                    .as_deref()
                    .ok_or(G41JointQuotientSearchError::SemanticMismatch)?,
                projected[second]
                    .as_deref()
                    .ok_or(G41JointQuotientSearchError::SemanticMismatch)?,
                &coordinates,
                count,
                &mut workspace,
                usize::try_from(MAX_TOTAL_PAIR_STATES - total)
                    .map_err(|_| G41JointQuotientSearchError::StateBudget)?,
            )?;
            let pair_count =
                u32::try_from(pair.len()).map_err(|_| G41JointQuotientSearchError::StateBudget)?;
            minimum = minimum.min(pair_count);
            maximum = maximum.max(pair_count);
            total = total
                .checked_add(u64::from(pair_count))
                .ok_or(G41JointQuotientSearchError::StateBudget)?;
            pair_domains[index] = Some(pair);
            compiled = compiled
                .checked_add(1)
                .ok_or(G41JointQuotientSearchError::StateBudget)?;
        }
    }
    let mut survivors = Vec::<u32>::with_capacity(roots.len());
    for root in roots {
        let left = pair_domains[usize::from(root[0]) * (1 << SLOTS) + usize::from(root[1])]
            .as_deref()
            .ok_or(G41JointQuotientSearchError::SemanticMismatch)?;
        let right = pair_domains[usize::from(root[2]) * (1 << SLOTS) + usize::from(root[3])]
            .as_deref()
            .ok_or(G41JointQuotientSearchError::SemanticMismatch)?;
        if left.iter().any(|&state| {
            right
                .binary_search(&complement_projection(state, &coordinates, count))
                .is_ok()
        }) {
            survivors.push(
                u32::from(root[0])
                    | (u32::from(root[1]) << 6)
                    | (u32::from(root[2]) << 12)
                    | (u32::from(root[3]) << 18),
            );
        }
    }
    Ok(G41JointProjectionReport {
        coordinate_mask,
        input_roots: roots.len() as u32,
        survivors: survivors.len() as u32,
        exclusions: (roots.len() - survivors.len()) as u32,
        pair_domains_compiled: compiled,
        minimum_pair_states: minimum,
        maximum_pair_states: maximum,
        total_pair_states: total,
        surviving_root_ids: survivors.into_boxed_slice(),
        provenance: "exact necessary joint coordinate projection; survivors have no full common-witness authority",
    })
}

pub fn census_g41_joint_projections(
    coordinate_masks: &[u8],
) -> Result<Box<[G41JointProjectionReport]>, G41JointQuotientSearchError> {
    if coordinate_masks.is_empty() || coordinate_masks.len() > 16 {
        return Err(G41JointQuotientSearchError::StateBudget);
    }
    let (roots, domains) = compile_campaign()?;
    let mut reports = Vec::with_capacity(coordinate_masks.len());
    for &coordinate_mask in coordinate_masks {
        reports.push(census_compiled_projection(
            &roots,
            &domains,
            coordinate_mask,
        )?);
    }
    Ok(reports.into_boxed_slice())
}

pub fn census_g41_joint_projection_rootwise(
    coordinate_mask: u8,
    threads: usize,
) -> Result<G41JointRootwiseProjectionReport, G41JointQuotientSearchError> {
    if threads == 0 || threads > 8 {
        return Err(G41JointQuotientSearchError::StateBudget);
    }
    let (roots, domains) = compile_campaign()?;
    let (coordinates, count) = projection_coordinates(coordinate_mask)?;
    let mut projected: [Option<Box<[ProjectionState]>>; 1 << SLOTS] = std::array::from_fn(|_| None);
    for mask in 0..1 << SLOTS {
        if let Some(domain) = domains[mask].as_deref() {
            projected[mask] = Some(compile_projection_domain(domain, &coordinates, count));
        }
    }
    let kernel = ProjectionRootKernel {
        projected,
        coordinates,
        count,
    };
    let accumulator = reduce_roots(
        &kernel,
        &roots,
        threads,
        || {
            Ok(ProjectionRootAccumulator {
                survivor_bits: [0; 12],
                roots_examined: 0,
                survivors: 0,
                pair_compilations: 0,
                reserved: 0,
            })
        },
        merge_projection_root_accumulators,
    )
    .map_err(|_| G41JointQuotientSearchError::ParallelExecution)??;
    let mut survivors = Vec::with_capacity(accumulator.survivors as usize);
    for (ordinal, &root) in roots.iter().enumerate() {
        if accumulator.survivor_bits[ordinal / 64] & (1_u64 << (ordinal % 64)) != 0 {
            survivors.push(
                u32::from(root[0])
                    | (u32::from(root[1]) << 6)
                    | (u32::from(root[2]) << 12)
                    | (u32::from(root[3]) << 18),
            );
        }
    }
    Ok(G41JointRootwiseProjectionReport {
        threads: threads as u16,
        coordinate_mask,
        roots_examined: accumulator.roots_examined,
        survivors: accumulator.survivors,
        exclusions: accumulator.roots_examined - accumulator.survivors,
        pair_compilations: accumulator.pair_compilations,
        surviving_root_ids: survivors.into_boxed_slice(),
        provenance: "exact root-scoped joint coordinate projection; survivors have no full common-witness authority",
    })
}

pub fn census_g41_joint_full_mitm() -> Result<G41JointFullMitmReport, G41JointQuotientSearchError> {
    let (roots, domains) = compile_campaign()?;
    let mut workspace = ResidueWorkspace::new(2)?;
    let mut left_states = Vec::<FullPairState>::with_capacity(MAX_FULL_PAIR_RECORDS);
    let mut seen_left = [false; 1 << (2 * SLOTS)];
    let mut survivor_bits = [0_u64; 12];
    let mut root_witnesses = vec![None; roots.len()];
    let mut left_pair_fibres = 0_u16;
    let mut left_pair_candidates = 0_u64;
    let mut distinct_left_pair_states = 0_u64;
    let mut right_pair_candidates = 0_u64;
    let mut triple_prefilter_hits = 0_u64;
    let mut full_common_hits = 0_u32;
    for root in &roots {
        let left_index = usize::from(root[0]) * (1 << SLOTS) + usize::from(root[1]);
        if seen_left[left_index] {
            continue;
        }
        seen_left[left_index] = true;
        left_pair_fibres += 1;
        let first = domains[usize::from(root[0])]
            .as_deref()
            .ok_or(G41JointQuotientSearchError::SemanticMismatch)?;
        let second = domains[usize::from(root[1])]
            .as_deref()
            .ok_or(G41JointQuotientSearchError::SemanticMismatch)?;
        left_pair_candidates += (first.len() * second.len()) as u64;
        left_states.clear();
        for left in first {
            for right in second {
                if let Some(state) = full_pair_state(left, right) {
                    if left_states.len() == left_states.capacity() {
                        return Err(G41JointQuotientSearchError::StateBudget);
                    }
                    left_states.push(state);
                }
            }
        }
        left_states.sort_unstable();
        left_states.dedup();
        distinct_left_pair_states += left_states.len() as u64;
        for &state in &left_states {
            if let Err(error) = workspace.insert(triple_projection_key(state), MAX_PAIR_STATES) {
                workspace.reset();
                return Err(error);
            }
        }
        for (ordinal, candidate_root) in roots.iter().enumerate() {
            if candidate_root[0] != root[0] || candidate_root[1] != root[1] {
                continue;
            }
            let third = domains[usize::from(candidate_root[2])]
                .as_deref()
                .ok_or(G41JointQuotientSearchError::SemanticMismatch)?;
            let fourth = domains[usize::from(candidate_root[3])]
                .as_deref()
                .ok_or(G41JointQuotientSearchError::SemanticMismatch)?;
            'right_pairs: for right_third in third {
                for right_fourth in fourth {
                    right_pair_candidates += 1;
                    let Some(triple_key) =
                        complement_triple_projection_key(right_third, right_fourth)
                    else {
                        continue;
                    };
                    if !workspace.contains(triple_key) {
                        continue;
                    }
                    triple_prefilter_hits += 1;
                    let Some(complement) = complement_full_pair_state(right_third, right_fourth)
                    else {
                        continue;
                    };
                    if left_states.binary_search(&complement).is_err() {
                        continue;
                    }
                    let mut left_witness = None;
                    'left_witness: for witness_first in first {
                        for witness_second in second {
                            if full_pair_state(witness_first, witness_second) == Some(complement) {
                                left_witness = Some((*witness_first, *witness_second));
                                break 'left_witness;
                            }
                        }
                    }
                    let (witness_first, witness_second) =
                        left_witness.ok_or(G41JointQuotientSearchError::SemanticMismatch)?;
                    let root_id = u32::from(candidate_root[0])
                        | (u32::from(candidate_root[1]) << 6)
                        | (u32::from(candidate_root[2]) << 12)
                        | (u32::from(candidate_root[3]) << 18);
                    let witness = G41JointQuotientWitness {
                        root_id,
                        masks: *candidate_root,
                        digits: [
                            witness_first.digits,
                            witness_second.digits,
                            right_third.digits,
                            right_fourth.digits,
                        ],
                    };
                    replay_witness(&witness)?;
                    root_witnesses[ordinal] = Some(witness);
                    survivor_bits[ordinal / 64] |= 1_u64 << (ordinal % 64);
                    full_common_hits += 1;
                    break 'right_pairs;
                }
            }
        }
        workspace.reset();
    }
    let mut survivors = Vec::with_capacity(full_common_hits as usize);
    let mut witnesses = Vec::with_capacity(full_common_hits as usize);
    for (ordinal, &root) in roots.iter().enumerate() {
        if survivor_bits[ordinal / 64] & (1_u64 << (ordinal % 64)) != 0 {
            survivors.push(
                u32::from(root[0])
                    | (u32::from(root[1]) << 6)
                    | (u32::from(root[2]) << 12)
                    | (u32::from(root[3]) << 18),
            );
            witnesses.push(
                root_witnesses[ordinal].ok_or(G41JointQuotientSearchError::SemanticMismatch)?,
            );
        }
    }
    Ok(G41JointFullMitmReport {
        roots_examined: roots.len() as u32,
        survivors: survivors.len() as u32,
        exclusions: (roots.len() - survivors.len()) as u32,
        left_pair_fibres,
        left_pair_candidates,
        distinct_left_pair_states,
        right_pair_candidates,
        triple_prefilter_hits,
        full_common_hits,
        surviving_root_ids: survivors.into_boxed_slice(),
        witnesses: witnesses.into_boxed_slice(),
        provenance: "exact constructive full-quotient MITM; every positive directly replays all ten quotient equations; no exclusions claimed",
    })
}

fn aggregate_weighted_pair_states(
    first: &[WeightedFullProfile],
    second: &[WeightedFullProfile],
) -> Result<Vec<WeightedPairState>, G41JointQuotientSearchError> {
    let pair_capacity = first
        .len()
        .checked_mul(second.len())
        .ok_or(G41JointQuotientSearchError::StateBudget)?;
    let mut states =
        Vec::<WeightedPairState>::with_capacity(pair_capacity.min(MAX_FULL_PAIR_RECORDS));
    for left in first {
        for right in second {
            let Some(state) = full_pair_state(&left.profile, &right.profile) else {
                continue;
            };
            if states.len() == states.capacity() {
                return Err(G41JointQuotientSearchError::StateBudget);
            }
            states.push(WeightedPairState {
                state,
                raw_digit_pairs: u64::from(left.multiplicity) * u64::from(right.multiplicity),
                profile_pairs: 1,
                _pad: 0,
            });
        }
    }
    states.sort_unstable_by_key(|record| record.state);
    let mut write = 0_usize;
    for read in 0..states.len() {
        let record = states[read];
        if write != 0 && states[write - 1].state == record.state {
            states[write - 1].raw_digit_pairs = states[write - 1]
                .raw_digit_pairs
                .checked_add(record.raw_digit_pairs)
                .ok_or(G41JointQuotientSearchError::StateBudget)?;
            states[write - 1].profile_pairs = states[write - 1]
                .profile_pairs
                .checked_add(record.profile_pairs)
                .ok_or(G41JointQuotientSearchError::StateBudget)?;
        } else {
            states[write] = record;
            write += 1;
        }
    }
    states.truncate(write);
    Ok(states)
}

pub fn census_g41_joint_multiplicity(
) -> Result<G41JointMultiplicityReport, G41JointQuotientSearchError> {
    let (roots, domains) = compile_weighted_campaign()?;
    let mut seen_left = [false; 1 << (2 * SLOTS)];
    let mut root_counts = vec![None; roots.len()];
    let mut left_pair_fibres = 0_u16;
    let mut left_pair_candidates = 0_u64;
    let mut distinct_left_pair_states = 0_u64;
    let mut right_pair_candidates = 0_u64;
    for root in &roots {
        let left_index = usize::from(root[0]) * (1 << SLOTS) + usize::from(root[1]);
        if seen_left[left_index] {
            continue;
        }
        seen_left[left_index] = true;
        left_pair_fibres = left_pair_fibres
            .checked_add(1)
            .ok_or(G41JointQuotientSearchError::StateBudget)?;
        let first = domains[usize::from(root[0])]
            .as_deref()
            .ok_or(G41JointQuotientSearchError::SemanticMismatch)?;
        let second = domains[usize::from(root[1])]
            .as_deref()
            .ok_or(G41JointQuotientSearchError::SemanticMismatch)?;
        left_pair_candidates = left_pair_candidates
            .checked_add((first.len() * second.len()) as u64)
            .ok_or(G41JointQuotientSearchError::StateBudget)?;
        let left_states = aggregate_weighted_pair_states(first, second)?;
        distinct_left_pair_states = distinct_left_pair_states
            .checked_add(left_states.len() as u64)
            .ok_or(G41JointQuotientSearchError::StateBudget)?;
        for (ordinal, candidate_root) in roots.iter().enumerate() {
            if candidate_root[0] != root[0] || candidate_root[1] != root[1] {
                continue;
            }
            let third = domains[usize::from(candidate_root[2])]
                .as_deref()
                .ok_or(G41JointQuotientSearchError::SemanticMismatch)?;
            let fourth = domains[usize::from(candidate_root[3])]
                .as_deref()
                .ok_or(G41JointQuotientSearchError::SemanticMismatch)?;
            let mut profile_quadruples = 0_u64;
            let mut digit_quadruples = 0_u128;
            for right_third in third {
                for right_fourth in fourth {
                    right_pair_candidates = right_pair_candidates
                        .checked_add(1)
                        .ok_or(G41JointQuotientSearchError::StateBudget)?;
                    let Some(complement) =
                        complement_full_pair_state(&right_third.profile, &right_fourth.profile)
                    else {
                        continue;
                    };
                    let Ok(index) =
                        left_states.binary_search_by_key(&complement, |entry| entry.state)
                    else {
                        continue;
                    };
                    let left = left_states[index];
                    profile_quadruples = profile_quadruples
                        .checked_add(u64::from(left.profile_pairs))
                        .ok_or(G41JointQuotientSearchError::StateBudget)?;
                    let right_multiplicity = u128::from(right_third.multiplicity)
                        * u128::from(right_fourth.multiplicity);
                    digit_quadruples = digit_quadruples
                        .checked_add(u128::from(left.raw_digit_pairs) * right_multiplicity)
                        .ok_or(G41JointQuotientSearchError::StateBudget)?;
                }
            }
            if profile_quadruples == 0 || digit_quadruples == 0 {
                return Err(G41JointQuotientSearchError::SemanticMismatch);
            }
            let root_id = u32::from(candidate_root[0])
                | (u32::from(candidate_root[1]) << 6)
                | (u32::from(candidate_root[2]) << 12)
                | (u32::from(candidate_root[3]) << 18);
            root_counts[ordinal] = Some(G41JointRootMultiplicity {
                root_id,
                quotient_profile_quadruples: profile_quadruples,
                raw_digit_quadruples: digit_quadruples,
            });
        }
    }
    let mut counts = Vec::with_capacity(roots.len());
    let mut quotient_profile_quadruples = 0_u128;
    let mut raw_digit_quadruples = 0_u128;
    let mut minimum_root_profile_quadruples = u64::MAX;
    let mut maximum_root_profile_quadruples = 0_u64;
    let mut minimum_root_digit_quadruples = u128::MAX;
    let mut maximum_root_digit_quadruples = 0_u128;
    for count in root_counts {
        let count = count.ok_or(G41JointQuotientSearchError::SemanticMismatch)?;
        quotient_profile_quadruples = quotient_profile_quadruples
            .checked_add(u128::from(count.quotient_profile_quadruples))
            .ok_or(G41JointQuotientSearchError::StateBudget)?;
        raw_digit_quadruples = raw_digit_quadruples
            .checked_add(count.raw_digit_quadruples)
            .ok_or(G41JointQuotientSearchError::StateBudget)?;
        minimum_root_profile_quadruples =
            minimum_root_profile_quadruples.min(count.quotient_profile_quadruples);
        maximum_root_profile_quadruples =
            maximum_root_profile_quadruples.max(count.quotient_profile_quadruples);
        minimum_root_digit_quadruples =
            minimum_root_digit_quadruples.min(count.raw_digit_quadruples);
        maximum_root_digit_quadruples =
            maximum_root_digit_quadruples.max(count.raw_digit_quadruples);
        counts.push(count);
    }
    Ok(G41JointMultiplicityReport {
        roots_examined: roots.len() as u32,
        left_pair_fibres,
        left_pair_candidates,
        distinct_left_pair_states,
        right_pair_candidates,
        quotient_profile_quadruples,
        raw_digit_quadruples,
        minimum_root_profile_quadruples,
        maximum_root_profile_quadruples,
        minimum_root_digit_quadruples,
        maximum_root_digit_quadruples,
        roots: counts.into_boxed_slice(),
        provenance: "exact weighted common-quotient census; raw digit multiplicities are retained rather than choosing one arbitrary preimage; no fine-orbit feasibility or exclusion authority",
    })
}

fn compile_raw_pair_records(
    first: &[FullProfile],
    second: &[FullProfile],
) -> Result<Vec<RawPairRecord>, G41JointQuotientSearchError> {
    let pair_capacity = first
        .len()
        .checked_mul(second.len())
        .ok_or(G41JointQuotientSearchError::StateBudget)?;
    let mut records = Vec::<RawPairRecord>::with_capacity(pair_capacity.min(MAX_FULL_PAIR_RECORDS));
    for left in first {
        for right in second {
            let Some(state) = full_pair_state(left, right) else {
                continue;
            };
            if records.len() == records.capacity() {
                return Err(G41JointQuotientSearchError::StateBudget);
            }
            records.push(RawPairRecord {
                state,
                digits: [left.digits, right.digits],
                _pad: [0; 8],
            });
        }
    }
    records.sort_unstable_by_key(|record| record.state);
    Ok(records)
}

pub fn enumerate_g41_joint_digit_witnesses(
) -> Result<G41JointDigitWitnessReport, G41JointQuotientSearchError> {
    const EMPTY_WITNESS: G41JointQuotientWitness = G41JointQuotientWitness {
        root_id: 0,
        masks: [0; 4],
        digits: [0; 4],
    };
    let (roots, domains) = compile_raw_campaign()?;
    let witness_slots = roots
        .len()
        .checked_mul(MAX_DIGIT_WITNESSES_PER_ROOT)
        .ok_or(G41JointQuotientSearchError::StateBudget)?;
    let mut root_witnesses = vec![EMPTY_WITNESS; witness_slots];
    let mut root_counts = vec![0_u32; roots.len()];
    let mut seen_left = [false; 1 << (2 * SLOTS)];
    for root in &roots {
        let left_index = usize::from(root[0]) * (1 << SLOTS) + usize::from(root[1]);
        if seen_left[left_index] {
            continue;
        }
        seen_left[left_index] = true;
        let first = domains[usize::from(root[0])]
            .as_deref()
            .ok_or(G41JointQuotientSearchError::SemanticMismatch)?;
        let second = domains[usize::from(root[1])]
            .as_deref()
            .ok_or(G41JointQuotientSearchError::SemanticMismatch)?;
        let left_records = compile_raw_pair_records(first, second)?;
        for (ordinal, candidate_root) in roots.iter().enumerate() {
            if candidate_root[0] != root[0] || candidate_root[1] != root[1] {
                continue;
            }
            let third = domains[usize::from(candidate_root[2])]
                .as_deref()
                .ok_or(G41JointQuotientSearchError::SemanticMismatch)?;
            let fourth = domains[usize::from(candidate_root[3])]
                .as_deref()
                .ok_or(G41JointQuotientSearchError::SemanticMismatch)?;
            let root_id = u32::from(candidate_root[0])
                | (u32::from(candidate_root[1]) << 6)
                | (u32::from(candidate_root[2]) << 12)
                | (u32::from(candidate_root[3]) << 18);
            for right_third in third {
                for right_fourth in fourth {
                    let Some(complement) = complement_full_pair_state(right_third, right_fourth)
                    else {
                        continue;
                    };
                    let first_match =
                        left_records.partition_point(|record| record.state < complement);
                    let after_match =
                        left_records.partition_point(|record| record.state <= complement);
                    for left in &left_records[first_match..after_match] {
                        let count = root_counts[ordinal] as usize;
                        if count == MAX_DIGIT_WITNESSES_PER_ROOT {
                            return Err(G41JointQuotientSearchError::StateBudget);
                        }
                        let witness = G41JointQuotientWitness {
                            root_id,
                            masks: *candidate_root,
                            digits: [
                                left.digits[0],
                                left.digits[1],
                                right_third.digits,
                                right_fourth.digits,
                            ],
                        };
                        replay_witness(&witness)?;
                        root_witnesses[ordinal * MAX_DIGIT_WITNESSES_PER_ROOT + count] = witness;
                        root_counts[ordinal] += 1;
                    }
                }
            }
            if root_counts[ordinal] == 0 {
                return Err(G41JointQuotientSearchError::SemanticMismatch);
            }
        }
    }
    let total = root_counts
        .iter()
        .map(|&count| u64::from(count))
        .sum::<u64>();
    let mut witnesses = Vec::with_capacity(total as usize);
    let mut root_offsets = Vec::with_capacity(roots.len() + 1);
    let mut minimum_root_witnesses = u32::MAX;
    let mut maximum_root_witnesses = 0_u32;
    for (ordinal, &count) in root_counts.iter().enumerate() {
        root_offsets.push(witnesses.len() as u32);
        minimum_root_witnesses = minimum_root_witnesses.min(count);
        maximum_root_witnesses = maximum_root_witnesses.max(count);
        let start = ordinal * MAX_DIGIT_WITNESSES_PER_ROOT;
        witnesses.extend_from_slice(&root_witnesses[start..start + count as usize]);
    }
    root_offsets.push(witnesses.len() as u32);
    Ok(G41JointDigitWitnessReport {
        roots_examined: roots.len() as u32,
        digit_witnesses: total,
        minimum_root_witnesses,
        maximum_root_witnesses,
        root_offsets: root_offsets.into_boxed_slice(),
        witnesses: witnesses.into_boxed_slice(),
        provenance: "exact direct enumeration of every raw digit preimage satisfying all ten common quotient equations; each witness is replayed directly; no fine-orbit feasibility or exclusion authority",
    })
}

pub fn verify_g41_joint_full_mitm_report(
    report: &G41JointFullMitmReport,
) -> Result<(), G41JointQuotientSearchError> {
    if report.roots_examined != 768
        || report.survivors != 768
        || report.exclusions != 0
        || report.full_common_hits != 768
        || report.surviving_root_ids.len() != 768
        || report.witnesses.len() != 768
    {
        return Err(G41JointQuotientSearchError::SemanticMismatch);
    }
    for index in 0..768 {
        let witness = report.witnesses[index];
        if witness.root_id != report.surviving_root_ids[index]
            || witness.masks
                != std::array::from_fn(|block| ((witness.root_id >> (6 * block)) & 63) as u8)
        {
            return Err(G41JointQuotientSearchError::SemanticMismatch);
        }
        replay_witness(&witness)?;
    }
    Ok(())
}

pub fn census_g41_joint_moduli(
    moduli: &[u8],
) -> Result<Box<[G41JointModulusReport]>, G41JointQuotientSearchError> {
    if moduli.is_empty() || moduli.len() > 16 {
        return Err(G41JointQuotientSearchError::StateBudget);
    }
    let (roots, domains) = compile_campaign()?;
    let mut reports = Vec::with_capacity(moduli.len());
    for &modulus in moduli {
        reports.push(census_compiled_modulus(&roots, &domains, modulus)?);
    }
    Ok(reports.into_boxed_slice())
}

pub fn census_g41_joint_modulus(
    modulus: u8,
) -> Result<G41JointModulusReport, G41JointQuotientSearchError> {
    let (roots, domains) = compile_campaign()?;
    census_compiled_modulus(&roots, &domains, modulus)
}

pub fn census_g41_joint_mod8() -> Result<G41JointModulusReport, G41JointQuotientSearchError> {
    census_g41_joint_modulus(8)
}

pub fn census_g41_joint_mod16() -> Result<G41JointModulusReport, G41JointQuotientSearchError> {
    census_g41_joint_modulus(16)
}

pub fn census_g41_joint_mod32() -> Result<G41JointModulusReport, G41JointQuotientSearchError> {
    census_g41_joint_modulus(32)
}

pub fn census_g41_joint_mod64() -> Result<G41JointModulusReport, G41JointQuotientSearchError> {
    census_g41_joint_modulus(64)
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::collections::{BTreeMap, BTreeSet};

    #[test]
    fn full_profile_layout_and_one_domain_replay() {
        let profiles = compile_domain(20, 260).unwrap();
        assert!(!profiles.is_empty());
        for profile in profiles.iter().take(32) {
            let word = decode_word(20, profile.digits);
            assert_eq!(word.iter().copied().sum::<u16>(), 260);
            for (index, &shift) in ACTIVE_SHIFTS.iter().enumerate() {
                assert_eq!(u32::from(profile.paf[index]), paf(&word, shift));
            }
        }
    }

    #[test]
    fn weighted_domain_retains_every_raw_digit_preimage() {
        let unique = compile_domain(20, 260).unwrap();
        let weighted = compile_weighted_domain(20, 260).unwrap();
        assert_eq!(weighted.len(), unique.len());
        for (weighted, unique) in weighted.iter().zip(unique.iter()) {
            assert_eq!(weighted.profile.energy, unique.energy);
            assert_eq!(weighted.profile.paf, unique.paf);
            assert_ne!(weighted.multiplicity, 0);
        }

        let mut direct_count = 0_u32;
        const RAW_ASSIGNMENTS: u32 = 8 * 8 * 15 * 15 * 15 * 15;
        for mut code in 0..RAW_ASSIGNMENTS {
            let mut packed = 0_u32;
            for slot in 0..SLOTS {
                let radix = u32::from(RADICES[slot]);
                let digit = code % radix;
                code /= radix;
                packed |= digit << SHIFTS_PACK[slot];
            }
            let word = decode_word(20, packed);
            if word.iter().copied().sum::<u16>() != 260 {
                continue;
            }
            let signed = word
                .iter()
                .map(|&value| {
                    let signed = 2 * i32::from(value) - 29;
                    signed * signed
                })
                .sum::<i32>();
            let excess = signed - 34;
            if excess >= 0 && excess % 8 == 0 && excess / 8 <= 230 {
                direct_count += 1;
            }
        }
        assert_eq!(
            weighted
                .iter()
                .map(|profile| u32::from(profile.multiplicity))
                .sum::<u32>(),
            direct_count
        );
    }

    #[test]
    fn weighted_pair_join_matches_independent_map_oracle() {
        let profile = |value: u8, multiplicity: u16| WeightedFullProfile {
            profile: FullProfile {
                digits: u32::from(value),
                paf: [u16::from(value); 5],
                energy: value,
                reserved: 0,
            },
            multiplicity,
            _pad: [0; 14],
        };
        let first = [profile(10, 2), profile(20, 3)];
        let second = [profile(20, 5), profile(10, 7)];
        let actual = aggregate_weighted_pair_states(&first, &second).unwrap();
        let mut expected = BTreeMap::<FullPairState, (u64, u32)>::new();
        for left in &first {
            for right in &second {
                let state = full_pair_state(&left.profile, &right.profile).unwrap();
                let entry = expected.entry(state).or_default();
                entry.0 += u64::from(left.multiplicity) * u64::from(right.multiplicity);
                entry.1 += 1;
            }
        }
        assert_eq!(actual.len(), expected.len());
        for (actual, (state, (raw_digit_pairs, profile_pairs))) in
            actual.iter().zip(expected.into_iter())
        {
            assert_eq!(actual.state, state);
            assert_eq!(actual.raw_digit_pairs, raw_digit_pairs);
            assert_eq!(actual.profile_pairs, profile_pairs);
        }
    }

    #[test]
    fn residue_arithmetic_matches_coordinate_oracle() {
        let profile = FullProfile {
            digits: 0,
            paf: [15_079, 12_345, 7_777, 65_535, 42],
            energy: 229,
            reserved: 0,
        };
        for modulus in [3_u8, 5, 7, 8, 13, 16, 32, 64] {
            let state = residue_state(&profile, modulus);
            let complement = complement_residue_state(state, modulus);
            let sum = add_residue_states(state, complement, modulus);
            let mut value = sum;
            for coordinate in 0..6 {
                let target = if coordinate == 0 { 230 } else { 15_080 };
                assert_eq!(value % u64::from(modulus), target % u64::from(modulus));
                value /= u64::from(modulus);
            }
            assert_eq!(value, 0);
        }
    }

    #[test]
    fn projection_pair_matches_independent_small_oracle() {
        let coordinates = [2_u8, 3, 4, 0];
        let first = [
            ProjectionState {
                values: [10, 20, 30, 0],
            },
            ProjectionState {
                values: [11, 21, 31, 0],
            },
            ProjectionState {
                values: [15_080, 0, 0, 0],
            },
        ];
        let second = [
            ProjectionState {
                values: [3, 5, 7, 0],
            },
            ProjectionState {
                values: [1, 2, 3, 0],
            },
        ];
        let mut workspace = ResidueWorkspace::new(2).unwrap();
        let actual =
            compile_projection_pair(&first, &second, &coordinates, 3, &mut workspace, 64).unwrap();
        let mut expected = BTreeSet::new();
        for left in first {
            for right in second {
                let sums = [
                    u32::from(left.values[0]) + u32::from(right.values[0]),
                    u32::from(left.values[1]) + u32::from(right.values[1]),
                    u32::from(left.values[2]) + u32::from(right.values[2]),
                ];
                if sums.iter().any(|&value| value > 15_080) {
                    continue;
                }
                let encoded = u64::from(sums[0])
                    + u64::from(sums[1]) * 15_081
                    + u64::from(sums[2]) * 15_081 * 15_081;
                expected.insert(encoded);
            }
        }
        assert_eq!(actual.len(), expected.len());
        for (&actual_state, expected_state) in actual.iter().zip(expected) {
            assert_eq!(actual_state, expected_state);
        }
        assert!(workspace.touched.is_empty());
    }

    #[test]
    fn full_pair_packing_and_complement_match_direct_sums() {
        let left = FullProfile {
            digits: 1,
            paf: [100, 200, 300, 400, 500],
            energy: 60,
            reserved: 0,
        };
        let right = FullProfile {
            digits: 2,
            paf: [7, 11, 13, 17, 19],
            energy: 23,
            reserved: 0,
        };
        let sum = full_pair_state(&left, &right).unwrap();
        assert_eq!(full_pair_coordinate(sum, 0), 83);
        assert_eq!(
            std::array::from_fn::<_, 5, _>(|index| full_pair_coordinate(sum, index + 1)),
            [107, 211, 313, 417, 519]
        );
        let complement = complement_full_pair_state(&left, &right).unwrap();
        assert_eq!(full_pair_coordinate(complement, 0), 147);
        assert_eq!(
            std::array::from_fn::<_, 5, _>(|index| { full_pair_coordinate(complement, index + 1) }),
            [14_973, 14_869, 14_767, 14_663, 14_561]
        );
    }

    #[test]
    fn full_mitm_verifier_rejects_malformed_coverage() {
        let report = G41JointFullMitmReport {
            roots_examined: 768,
            survivors: 768,
            exclusions: 0,
            left_pair_fibres: 40,
            left_pair_candidates: 0,
            distinct_left_pair_states: 0,
            right_pair_candidates: 0,
            triple_prefilter_hits: 0,
            full_common_hits: 768,
            surviving_root_ids: Box::new([]),
            witnesses: Box::new([]),
            provenance: "forged",
        };
        assert_eq!(
            verify_g41_joint_full_mitm_report(&report),
            Err(G41JointQuotientSearchError::SemanticMismatch)
        );
    }

    #[test]
    fn witness_merge_treats_none_as_the_identity() {
        assert!(witness_root_precedes(None, Some(7)));
        assert!(!witness_root_precedes(Some(7), None));
        assert!(witness_root_precedes(Some(9), Some(7)));
        assert!(!witness_root_precedes(Some(7), Some(9)));
    }
}
