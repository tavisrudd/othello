//! Cross-level q29 profile table augmented by necessary q58 shift-29 energy
//! fibres.  The q29 image and q58 lane extractor remain independently sealed;
//! this adapter joins them without trusting presentation fields.

use serde::Serialize;
use sha2::{Digest, Sha256};
use thiserror::Error;

use crate::g41_q29_exact_tablebase::{
    canonical_g41_q29_block_spec, visit_g41_q29_exact_block_states, G41Q29CoefficientImageReport,
    G41Q29ExactProfile, G41Q29ExactTablebaseError,
};
use crate::g41_q58_exact_tablebase::{
    compile_g41_q58_lane_support, G41Q58ExactTablebaseError, Q58_ANTI_ENERGY_WORDS,
};
use crate::predicate_cover::{
    synthesize_predicate_cover, PredicateCoverBudget, PredicateCoverError, PredicateCoverReport,
};

const PROFILE_CAPACITY: usize = 1 << 22;
const ENERGY_PATTERN_CAPACITY: usize = 1 << 16;
const EXACT_LINEAR_WORDS: usize = 25;
const PAIR_LINEAR_WORDS: usize = 50;

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord, Serialize)]
pub struct G41Q29Q58EnergyProfile {
    pub profile: G41Q29ExactProfile,
    pub energy_class: u16,
    #[serde(skip)]
    _pad: [u8; 6],
}

const _: () = assert!(
    std::mem::size_of::<G41Q29Q58EnergyProfile>() == 24
        && std::mem::align_of::<G41Q29Q58EnergyProfile>() == 8
);

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
struct ProfileEnergyRecord {
    profile: G41Q29ExactProfile,
    q58_energy_support: [u64; Q58_ANTI_ENERGY_WORDS],
}

const _: () = assert!(
    std::mem::size_of::<ProfileEnergyRecord>() == 88
        && std::mem::align_of::<ProfileEnergyRecord>() == 8
);

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q29Q58EnergyReport {
    pub coefficient_image: G41Q29CoefficientImageReport,
    pub profiles_exceeding_defect_budget: u32,
    pub energy_profiles: u32,
    pub energy_memberships: u64,
    pub energy_profile_counts: Vec<u32>,
    pub distinct_energy_supports: u32,
    pub largest_energy_support_class: u32,
    pub energy_support_classes: Vec<G41Q29Q58EnergySupportClass>,
    pub minimum_energy: u16,
    pub maximum_energy: u16,
    pub profile_digest: [u8; 32],
    pub workspace_bytes: u64,
    pub provenance: &'static str,
}

#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq, PartialOrd, Ord)]
pub struct G41Q29Q58EnergySupportClass {
    pub support: [u64; Q58_ANTI_ENERGY_WORDS],
    pub profiles: u32,
    pub q29_defect_value_masks: [[u64; Q58_ANTI_ENERGY_WORDS]; 7],
}

pub struct G41Q29Q58EnergyTablebase {
    pub report: G41Q29Q58EnergyReport,
    pub profiles: Box<[G41Q29Q58EnergyProfile]>,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q29Q58FourBlockEnergyReport {
    pub energy_support_classes: [u32; 4],
    pub class_quadruples: u32,
    pub compatible_class_quadruples: u32,
    pub raw_profile_quadruples: u128,
    pub compatible_profile_quadruples: u128,
    pub defect_marginal_compatible_class_quadruples: u32,
    pub defect_marginal_compatible_profile_quadruples: u128,
    pub defect_scope_cover: PredicateCoverReport,
    pub provenance: &'static str,
}

#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq, PartialOrd, Ord)]
pub struct G41Q29Q58ScopedLinearCandidate {
    pub first_coordinate: u8,
    pub second_coordinate: u8,
    pub second_sign: i8,
    pub modulus: u8,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q29Q58ScopedLinearReport {
    pub candidates: u16,
    pub energy_compatible_class_quadruples: u32,
    pub all_candidate_compatible_class_quadruples: u32,
    pub all_candidate_compatible_profile_quadruples: u128,
    pub refined_exact_candidates: u8,
    pub refined_exact_compatible_class_quadruples: u32,
    pub refined_exact_compatible_profile_quadruples: u128,
    pub selected_candidates: Vec<G41Q29Q58ScopedLinearCandidate>,
    pub cover: PredicateCoverReport,
    pub support_bytes: u64,
    pub provenance: &'static str,
}

#[derive(Clone, Debug, Error, PartialEq, Eq)]
pub enum G41Q29Q58EnergyError {
    #[error(transparent)]
    Q29(#[from] G41Q29ExactTablebaseError),
    #[error(transparent)]
    Q58(#[from] G41Q58ExactTablebaseError),
    #[error("g41 q29/q58 energy adapter exceeded its fixed profile budget")]
    ProfileBudget,
    #[error("g41 q29/q58 energy adapter semantic binding failed")]
    SemanticMismatch,
    #[error(transparent)]
    Cover(#[from] PredicateCoverError),
}

struct ProfileEnergyWorkspace<const CAPACITY: usize> {
    keys: Box<[[u64; 2]]>,
    energies: Box<[[u64; Q58_ANTI_ENERGY_WORDS]]>,
    occupied: Box<[u8]>,
    touched: Vec<u32>,
}

struct EnergyPatternWorkspace<const CAPACITY: usize> {
    keys: Box<[[u64; Q58_ANTI_ENERGY_WORDS]]>,
    counts: Box<[u32]>,
    occupied: Box<[u8]>,
    touched: Vec<u32>,
}

impl<const CAPACITY: usize> EnergyPatternWorkspace<CAPACITY> {
    const MAX_PATTERNS: usize = 3 * CAPACITY / 4;

    fn new() -> Self {
        assert!(CAPACITY.is_power_of_two() && CAPACITY <= u32::MAX as usize);
        Self {
            keys: vec![[0; Q58_ANTI_ENERGY_WORDS]; CAPACITY].into_boxed_slice(),
            counts: vec![0; CAPACITY].into_boxed_slice(),
            occupied: vec![0; CAPACITY].into_boxed_slice(),
            touched: Vec::with_capacity(Self::MAX_PATTERNS),
        }
    }

    fn insert(&mut self, key: [u64; Q58_ANTI_ENERGY_WORDS]) -> Result<u32, G41Q29Q58EnergyError> {
        let mut hash = 0x9e37_79b9_7f4a_7c15_u64;
        for word in key {
            hash ^= word.wrapping_add(hash << 6).wrapping_add(hash >> 2);
        }
        let mut slot = hash as usize & (CAPACITY - 1);
        loop {
            if self.occupied[slot] == 0 {
                if self.touched.len() == Self::MAX_PATTERNS {
                    return Err(G41Q29Q58EnergyError::ProfileBudget);
                }
                self.occupied[slot] = 1;
                self.keys[slot] = key;
                self.counts[slot] = 1;
                self.touched.push(slot as u32);
                return Ok(1);
            }
            if self.keys[slot] == key {
                self.counts[slot] = self.counts[slot]
                    .checked_add(1)
                    .ok_or(G41Q29Q58EnergyError::ProfileBudget)?;
                return Ok(self.counts[slot]);
            }
            slot = (slot + 1) & (CAPACITY - 1);
        }
    }

    fn classes(&self) -> Vec<G41Q29Q58EnergySupportClass> {
        let mut classes = Vec::with_capacity(self.touched.len());
        for &slot in &self.touched {
            let slot = slot as usize;
            classes.push(G41Q29Q58EnergySupportClass {
                support: self.keys[slot],
                profiles: self.counts[slot],
                q29_defect_value_masks: [[0; Q58_ANTI_ENERGY_WORDS]; 7],
            });
        }
        classes.sort_unstable();
        classes
    }

    const fn bytes() -> u64 {
        (CAPACITY
            * (std::mem::size_of::<[u64; Q58_ANTI_ENERGY_WORDS]>()
                + std::mem::size_of::<u32>()
                + std::mem::size_of::<u8>())
            + Self::MAX_PATTERNS * std::mem::size_of::<u32>()) as u64
    }
}

impl<const CAPACITY: usize> ProfileEnergyWorkspace<CAPACITY> {
    const MAX_PROFILES: usize = 3 * CAPACITY / 4;

    fn new() -> Self {
        assert!(CAPACITY.is_power_of_two() && CAPACITY <= u32::MAX as usize);
        Self {
            keys: vec![[0; 2]; CAPACITY].into_boxed_slice(),
            energies: vec![[0; Q58_ANTI_ENERGY_WORDS]; CAPACITY].into_boxed_slice(),
            occupied: vec![0; CAPACITY].into_boxed_slice(),
            touched: Vec::with_capacity(Self::MAX_PROFILES),
        }
    }

    #[inline(always)]
    fn insert(
        &mut self,
        profile: G41Q29ExactProfile,
        energy: [u64; Q58_ANTI_ENERGY_WORDS],
    ) -> Result<(), G41Q29Q58EnergyError> {
        if energy.iter().all(|&word| word == 0) {
            return Err(G41Q29Q58EnergyError::SemanticMismatch);
        }
        let key = profile.packed_words();
        let mut hash = key[0] ^ key[1].rotate_left(29);
        hash ^= hash >> 30;
        hash = hash.wrapping_mul(0xbf58_476d_1ce4_e5b9);
        hash ^= hash >> 27;
        hash = hash.wrapping_mul(0x94d0_49bb_1331_11eb);
        hash ^= hash >> 31;
        let mut slot = hash as usize & (CAPACITY - 1);
        loop {
            if self.occupied[slot] == 0 {
                if self.touched.len() == Self::MAX_PROFILES {
                    return Err(G41Q29Q58EnergyError::ProfileBudget);
                }
                self.occupied[slot] = 1;
                self.keys[slot] = key;
                self.energies[slot] = energy;
                self.touched.push(slot as u32);
                return Ok(());
            }
            if self.keys[slot] == key {
                for (target, source) in self.energies[slot].iter_mut().zip(energy) {
                    *target |= source;
                }
                return Ok(());
            }
            slot = (slot + 1) & (CAPACITY - 1);
        }
    }

    fn records(&self) -> Vec<ProfileEnergyRecord> {
        let mut records = Vec::with_capacity(self.touched.len());
        for &slot in &self.touched {
            let slot = slot as usize;
            records.push(ProfileEnergyRecord {
                profile: G41Q29ExactProfile::from_packed_words(self.keys[slot]),
                q58_energy_support: self.energies[slot],
            });
        }
        records
    }

    const fn bytes() -> u64 {
        (CAPACITY
            * (std::mem::size_of::<[u64; 2]>()
                + std::mem::size_of::<[u64; Q58_ANTI_ENERGY_WORDS]>()
                + std::mem::size_of::<u8>())
            + Self::MAX_PROFILES * std::mem::size_of::<u32>()) as u64
    }
}

fn convolve_energy_supports(
    left: [u64; Q58_ANTI_ENERGY_WORDS],
    right: [u64; Q58_ANTI_ENERGY_WORDS],
) -> [u64; Q58_ANTI_ENERGY_WORDS] {
    let mut output = [0_u64; Q58_ANTI_ENERGY_WORDS];
    for (word_index, &word) in right.iter().enumerate() {
        let mut values = word;
        while values != 0 {
            let bit = values.trailing_zeros() as usize;
            values &= values - 1;
            let shift = 64 * word_index + bit;
            if shift > 523 {
                continue;
            }
            let word_shift = shift / 64;
            let bit_shift = shift % 64;
            for source in 0..Q58_ANTI_ENERGY_WORDS - word_shift {
                output[source + word_shift] |= left[source] << bit_shift;
                if bit_shift != 0 && source + word_shift + 1 < Q58_ANTI_ENERGY_WORDS {
                    output[source + word_shift + 1] |= left[source] >> (64 - bit_shift);
                }
            }
        }
    }
    output[Q58_ANTI_ENERGY_WORDS - 1] &= (1_u64 << (524 % 64)) - 1;
    output
}

fn supports_target_523(
    left: [u64; Q58_ANTI_ENERGY_WORDS],
    right: [u64; Q58_ANTI_ENERGY_WORDS],
) -> bool {
    for energy in 0..=523 {
        if left[energy / 64] & (1_u64 << (energy % 64)) != 0 {
            let complement = 523 - energy;
            if right[complement / 64] & (1_u64 << (complement % 64)) != 0 {
                return true;
            }
        }
    }
    false
}

#[inline(always)]
fn cyclic_sumset(left: u32, right: u32, modulus: usize) -> u32 {
    let mut output = 0_u32;
    let mut left_values = left;
    while left_values != 0 {
        let first = left_values.trailing_zeros() as usize;
        left_values &= left_values - 1;
        let mut right_values = right;
        while right_values != 0 {
            let second = right_values.trailing_zeros() as usize;
            right_values &= right_values - 1;
            output |= 1_u32 << ((first + second) % modulus);
        }
    }
    output
}

fn convolve_exact_linear(
    left: [u64; EXACT_LINEAR_WORDS],
    right: [u64; EXACT_LINEAR_WORDS],
) -> [u64; PAIR_LINEAR_WORDS] {
    let mut output = [0_u64; PAIR_LINEAR_WORDS];
    for (left_word, &left_bits) in left.iter().enumerate() {
        let mut left_values = left_bits;
        while left_values != 0 {
            let left_bit = left_values.trailing_zeros() as usize;
            left_values &= left_values - 1;
            let left_value = 64 * left_word + left_bit;
            for (right_word, &right_bits) in right.iter().enumerate() {
                let mut right_values = right_bits;
                while right_values != 0 {
                    let right_bit = right_values.trailing_zeros() as usize;
                    right_values &= right_values - 1;
                    let sum = left_value + 64 * right_word + right_bit;
                    if sum < PAIR_LINEAR_WORDS * 64 {
                        output[sum / 64] |= 1_u64 << (sum % 64);
                    }
                }
            }
        }
    }
    output
}

fn exact_pair_supports_target(
    left: &[u64; PAIR_LINEAR_WORDS],
    right: &[u64; PAIR_LINEAR_WORDS],
    target: usize,
) -> bool {
    for value in 0..=target {
        if left[value / 64] & (1_u64 << (value % 64)) != 0 {
            let complement = target - value;
            if right[complement / 64] & (1_u64 << (complement % 64)) != 0 {
                return true;
            }
        }
    }
    false
}

fn scoped_linear_candidates() -> Vec<G41Q29Q58ScopedLinearCandidate> {
    const MODULI: [u8; 8] = [3, 4, 5, 7, 8, 11, 13, 16];
    let mut candidates = Vec::with_capacity(7 * 6 / 2 * 2 * MODULI.len());
    for first in 0..7_u8 {
        for second in first + 1..7 {
            for second_sign in [-1, 1] {
                for modulus in MODULI {
                    candidates.push(G41Q29Q58ScopedLinearCandidate {
                        first_coordinate: first,
                        second_coordinate: second,
                        second_sign,
                        modulus,
                    });
                }
            }
        }
    }
    candidates
}

fn scoped_interval_candidates() -> Vec<G41Q29Q58ScopedLinearCandidate> {
    let mut candidates = Vec::with_capacity(7 * 6 / 2 * 2);
    for first in 0..7_u8 {
        for second in first + 1..7 {
            for second_sign in [-1, 1] {
                candidates.push(G41Q29Q58ScopedLinearCandidate {
                    first_coordinate: first,
                    second_coordinate: second,
                    second_sign,
                    modulus: 0,
                });
            }
        }
    }
    candidates
}

pub fn evolve_g41_q29_q58_scoped_linear_forms(
    tables: [&G41Q29Q58EnergyTablebase; 4],
) -> Result<G41Q29Q58ScopedLinearReport, G41Q29Q58EnergyError> {
    let modular_candidates = scoped_linear_candidates();
    let interval_candidates = scoped_interval_candidates();
    let mut candidates = modular_candidates.clone();
    candidates.extend_from_slice(&interval_candidates);
    let class_counts: [usize; 4] =
        std::array::from_fn(|block| tables[block].report.energy_support_classes.len());
    if class_counts
        .iter()
        .any(|&count| count == 0 || count > u16::MAX as usize)
    {
        return Err(G41Q29Q58EnergyError::SemanticMismatch);
    }
    let mut supports: [Vec<u32>; 4] =
        std::array::from_fn(|block| vec![0; class_counts[block] * modular_candidates.len()]);
    let mut intervals: [Vec<[i16; 2]>; 4] = std::array::from_fn(|block| {
        vec![[i16::MAX, i16::MIN]; class_counts[block] * interval_candidates.len()]
    });
    for block in 0..4 {
        for record in tables[block].profiles.iter() {
            let class = usize::from(record.energy_class);
            if class >= class_counts[block] {
                return Err(G41Q29Q58EnergyError::SemanticMismatch);
            }
            let values: [i32; 7] =
                std::array::from_fn(|coordinate| i32::from(record.profile.coordinate(coordinate)));
            for (candidate_index, candidate) in modular_candidates.iter().enumerate() {
                let modulus = i32::from(candidate.modulus);
                let value = (values[usize::from(candidate.first_coordinate)]
                    + i32::from(candidate.second_sign)
                        * values[usize::from(candidate.second_coordinate)])
                .rem_euclid(modulus) as usize;
                supports[block][class * modular_candidates.len() + candidate_index] |=
                    1_u32 << value;
            }
            for (candidate_index, candidate) in interval_candidates.iter().enumerate() {
                let value = values[usize::from(candidate.first_coordinate)]
                    + i32::from(candidate.second_sign)
                        * values[usize::from(candidate.second_coordinate)];
                let value: i16 = value
                    .try_into()
                    .map_err(|_| G41Q29Q58EnergyError::SemanticMismatch)?;
                let bounds =
                    &mut intervals[block][class * interval_candidates.len() + candidate_index];
                bounds[0] = bounds[0].min(value);
                bounds[1] = bounds[1].max(value);
            }
        }
    }
    let classes: [&[G41Q29Q58EnergySupportClass]; 4] =
        std::array::from_fn(|block| tables[block].report.energy_support_classes.as_slice());
    let mut observations = Vec::<[u16; 4]>::with_capacity(400);
    for first in 0..class_counts[0] {
        for third in 0..class_counts[2] {
            let left =
                convolve_energy_supports(classes[0][first].support, classes[2][third].support);
            for second in 0..class_counts[1] {
                for fourth in 0..class_counts[3] {
                    let right = convolve_energy_supports(
                        classes[1][second].support,
                        classes[3][fourth].support,
                    );
                    if supports_target_523(left, right) {
                        observations.push([
                            first as u16,
                            second as u16,
                            third as u16,
                            fourth as u16,
                        ]);
                    }
                }
            }
        }
    }
    let rejects = |candidate_index: usize, observation_index: usize| {
        let classes = observations[observation_index].map(usize::from);
        if candidate_index >= modular_candidates.len() {
            let interval_index = candidate_index - modular_candidates.len();
            let candidate = interval_candidates[interval_index];
            let target = 523 + i32::from(candidate.second_sign) * 523;
            let mut minimum = 0_i32;
            let mut maximum = 0_i32;
            for block in 0..4 {
                let bounds =
                    intervals[block][classes[block] * interval_candidates.len() + interval_index];
                minimum += i32::from(bounds[0]);
                maximum += i32::from(bounds[1]);
            }
            return target < minimum || target > maximum;
        }
        let candidate = modular_candidates[candidate_index];
        let modulus = usize::from(candidate.modulus);
        let left = cyclic_sumset(
            supports[0][classes[0] * modular_candidates.len() + candidate_index],
            supports[2][classes[2] * modular_candidates.len() + candidate_index],
            modulus,
        );
        let right = cyclic_sumset(
            supports[1][classes[1] * modular_candidates.len() + candidate_index],
            supports[3][classes[3] * modular_candidates.len() + candidate_index],
            modulus,
        );
        let total = cyclic_sumset(left, right, modulus);
        let target = ((523_i32 + i32::from(candidate.second_sign) * 523)
            .rem_euclid(i32::from(candidate.modulus))) as usize;
        total & (1_u32 << target) == 0
    };
    let rejected_observations: Vec<usize> = (0..observations.len())
        .filter(|&observation| {
            (0..candidates.len()).any(|candidate| rejects(candidate, observation))
        })
        .collect();
    let cover = synthesize_predicate_cover(
        candidates.len(),
        rejected_observations.len(),
        PredicateCoverBudget {
            maximum_candidates: candidates.len(),
            maximum_observations: 400,
            maximum_selected: 32,
        },
        |candidate, observation| rejects(candidate, rejected_observations[observation]),
    )?;
    if cover.finally_uncovered != 0 {
        return Err(G41Q29Q58EnergyError::SemanticMismatch);
    }
    let refined_candidates: Vec<G41Q29Q58ScopedLinearCandidate> = cover
        .selected_indices
        .iter()
        .filter_map(|&index| {
            let index = index as usize;
            (index >= modular_candidates.len()).then(|| candidates[index])
        })
        .collect();
    if refined_candidates.len() > u8::MAX as usize {
        return Err(G41Q29Q58EnergyError::SemanticMismatch);
    }
    let mut exact_supports: [Vec<[u64; EXACT_LINEAR_WORDS]>; 4] = std::array::from_fn(|block| {
        vec![[0; EXACT_LINEAR_WORDS]; class_counts[block] * refined_candidates.len()]
    });
    for block in 0..4 {
        for record in tables[block].profiles.iter() {
            let class = usize::from(record.energy_class);
            for (candidate_index, candidate) in refined_candidates.iter().enumerate() {
                let value = i32::from(
                    record
                        .profile
                        .coordinate(usize::from(candidate.first_coordinate)),
                ) + i32::from(candidate.second_sign)
                    * i32::from(
                        record
                            .profile
                            .coordinate(usize::from(candidate.second_coordinate)),
                    );
                let encoded = value + 523;
                if !(0..(EXACT_LINEAR_WORDS * 64) as i32).contains(&encoded) {
                    return Err(G41Q29Q58EnergyError::SemanticMismatch);
                }
                let encoded = encoded as usize;
                exact_supports[block][class * refined_candidates.len() + candidate_index]
                    [encoded / 64] |= 1_u64 << (encoded % 64);
            }
        }
    }
    let mut exact_left_pairs = vec![
        [0_u64; PAIR_LINEAR_WORDS];
        refined_candidates.len() * class_counts[0] * class_counts[2]
    ];
    let mut exact_right_pairs = vec![
        [0_u64; PAIR_LINEAR_WORDS];
        refined_candidates.len() * class_counts[1] * class_counts[3]
    ];
    for candidate in 0..refined_candidates.len() {
        for first in 0..class_counts[0] {
            for third in 0..class_counts[2] {
                exact_left_pairs[(candidate * class_counts[0] + first) * class_counts[2] + third] =
                    convolve_exact_linear(
                        exact_supports[0][first * refined_candidates.len() + candidate],
                        exact_supports[2][third * refined_candidates.len() + candidate],
                    );
            }
        }
        for second in 0..class_counts[1] {
            for fourth in 0..class_counts[3] {
                exact_right_pairs
                    [(candidate * class_counts[1] + second) * class_counts[3] + fourth] =
                    convolve_exact_linear(
                        exact_supports[1][second * refined_candidates.len() + candidate],
                        exact_supports[3][fourth * refined_candidates.len() + candidate],
                    );
            }
        }
    }
    let mut compatible_profile_quadruples = 0_u128;
    let mut refined_exact_compatible_class_quadruples = 0_u32;
    let mut refined_exact_compatible_profile_quadruples = 0_u128;
    for (observation, &class_ids) in observations.iter().enumerate() {
        if (0..candidates.len()).any(|candidate| rejects(candidate, observation)) {
            continue;
        }
        let profiles = class_ids
            .into_iter()
            .enumerate()
            .try_fold(1_u128, |product, (block, class)| {
                product.checked_mul(u128::from(classes[block][usize::from(class)].profiles))
            })
            .ok_or(G41Q29Q58EnergyError::ProfileBudget)?;
        compatible_profile_quadruples = compatible_profile_quadruples
            .checked_add(profiles)
            .ok_or(G41Q29Q58EnergyError::ProfileBudget)?;
        let class_ids = class_ids.map(usize::from);
        let exact_compatible = refined_candidates
            .iter()
            .enumerate()
            .all(|(candidate, feature)| {
                let target = (523 + i32::from(feature.second_sign) * 523 + 4 * 523) as usize;
                let left = &exact_left_pairs
                    [(candidate * class_counts[0] + class_ids[0]) * class_counts[2] + class_ids[2]];
                let right = &exact_right_pairs
                    [(candidate * class_counts[1] + class_ids[1]) * class_counts[3] + class_ids[3]];
                exact_pair_supports_target(left, right, target)
            });
        if exact_compatible {
            refined_exact_compatible_class_quadruples += 1;
            refined_exact_compatible_profile_quadruples =
                refined_exact_compatible_profile_quadruples
                    .checked_add(profiles)
                    .ok_or(G41Q29Q58EnergyError::ProfileBudget)?;
        }
    }
    let selected_candidates = cover
        .selected_indices
        .iter()
        .map(|&index| candidates[index as usize])
        .collect();
    Ok(G41Q29Q58ScopedLinearReport {
        candidates: candidates.len() as u16,
        energy_compatible_class_quadruples: observations.len() as u32,
        all_candidate_compatible_class_quadruples: (observations.len()
            - rejected_observations.len()) as u32,
        all_candidate_compatible_profile_quadruples: compatible_profile_quadruples,
        refined_exact_candidates: refined_candidates.len() as u8,
        refined_exact_compatible_class_quadruples,
        refined_exact_compatible_profile_quadruples,
        selected_candidates,
        cover,
        support_bytes: supports
            .iter()
            .map(|support| support.capacity() as u64 * std::mem::size_of::<u32>() as u64)
            .sum::<u64>()
            + intervals
                .iter()
                .map(|bounds| {
                    bounds.capacity() as u64 * std::mem::size_of::<[i16; 2]>() as u64
                })
                .sum::<u64>()
            + exact_supports
                .iter()
                .map(|support| {
                    support.capacity() as u64
                        * std::mem::size_of::<[u64; EXACT_LINEAR_WORDS]>() as u64
                })
                .sum::<u64>()
            + (exact_left_pairs.capacity() + exact_right_pairs.capacity()) as u64
                * std::mem::size_of::<[u64; PAIR_LINEAR_WORDS]>() as u64,
        provenance: "discovery enumerates anonymous two-coordinate sum/difference forms over eight small moduli plus exact integer intervals inside learned q58-energy classes, then automatically promotes only cover-selected intervals to exact value supports; every class support is recomputed from compact q29 profiles, the full candidate union is exact necessary-only authority, and generic greedy cover supplies only a replayed hot ordering",
    })
}

pub fn analyze_g41_q29_q58_four_block_energy(
    classes: [&[G41Q29Q58EnergySupportClass]; 4],
) -> Result<G41Q29Q58FourBlockEnergyReport, G41Q29Q58EnergyError> {
    let profile_counts: [u128; 4] = std::array::from_fn(|block| {
        classes[block]
            .iter()
            .map(|class| u128::from(class.profiles))
            .sum()
    });
    let raw_profile_quadruples = profile_counts
        .into_iter()
        .try_fold(1_u128, |product, count| product.checked_mul(count))
        .ok_or(G41Q29Q58EnergyError::ProfileBudget)?;
    let mut class_quadruples = 0_u32;
    let mut compatible_class_quadruples = 0_u32;
    let mut compatible_profile_quadruples = 0_u128;
    let mut defect_marginal_compatible_class_quadruples = 0_u32;
    let mut defect_marginal_compatible_profile_quadruples = 0_u128;
    let mut defect_rejection_observations = Vec::<[bool; 7]>::with_capacity(400);
    for first in classes[0] {
        for third in classes[2] {
            let left = convolve_energy_supports(first.support, third.support);
            for second in classes[1] {
                for fourth in classes[3] {
                    class_quadruples += 1;
                    let right = convolve_energy_supports(second.support, fourth.support);
                    if supports_target_523(left, right) {
                        compatible_class_quadruples += 1;
                        let profiles = [
                            first.profiles,
                            second.profiles,
                            third.profiles,
                            fourth.profiles,
                        ]
                        .into_iter()
                        .try_fold(1_u128, |product, count| {
                            product.checked_mul(u128::from(count))
                        })
                        .ok_or(G41Q29Q58EnergyError::ProfileBudget)?;
                        compatible_profile_quadruples = compatible_profile_quadruples
                            .checked_add(profiles)
                            .ok_or(G41Q29Q58EnergyError::ProfileBudget)?;
                        let coordinate_compatibility = std::array::from_fn(|coordinate| {
                            let left = convolve_energy_supports(
                                first.q29_defect_value_masks[coordinate],
                                third.q29_defect_value_masks[coordinate],
                            );
                            let right = convolve_energy_supports(
                                second.q29_defect_value_masks[coordinate],
                                fourth.q29_defect_value_masks[coordinate],
                            );
                            supports_target_523(left, right)
                        });
                        let defects_compatible =
                            coordinate_compatibility.iter().all(|&value| value);
                        if defects_compatible {
                            defect_marginal_compatible_class_quadruples += 1;
                            defect_marginal_compatible_profile_quadruples =
                                defect_marginal_compatible_profile_quadruples
                                    .checked_add(profiles)
                                    .ok_or(G41Q29Q58EnergyError::ProfileBudget)?;
                        } else {
                            defect_rejection_observations.push(coordinate_compatibility);
                        }
                    }
                }
            }
        }
    }
    let defect_scope_cover = synthesize_predicate_cover(
        7,
        defect_rejection_observations.len(),
        PredicateCoverBudget {
            maximum_candidates: 7,
            maximum_observations: 400,
            maximum_selected: 7,
        },
        |coordinate, observation| !defect_rejection_observations[observation][coordinate],
    )?;
    Ok(G41Q29Q58FourBlockEnergyReport {
        energy_support_classes: std::array::from_fn(|block| classes[block].len() as u32),
        class_quadruples,
        compatible_class_quadruples,
        raw_profile_quadruples,
        compatible_profile_quadruples,
        defect_marginal_compatible_class_quadruples,
        defect_marginal_compatible_profile_quadruples,
        defect_scope_cover,
        provenance: "exact class-level join of four necessary q58 shift-29 energy fibres followed by seven energy-class-scoped exact q29 defect-value sumsets; each coordinate and energy must sum to 523, while cross-coordinate profile compatibility is deliberately forgotten; a generic blind greedy cover learns a diagnostic coordinate scope but grants no authority, and original fine PAF remains the positive authority",
    })
}

pub fn compile_g41_q29_q58_energy_tablebase(
    requested_mask: u8,
    requested_digits: u32,
) -> Result<G41Q29Q58EnergyTablebase, G41Q29Q58EnergyError> {
    let (mask, digits, _) = canonical_g41_q29_block_spec(requested_mask, requested_digits)?;
    let lane_support = compile_g41_q58_lane_support(mask, digits)?;
    let mut workspace = ProfileEnergyWorkspace::<PROFILE_CAPACITY>::new();
    let mut profiles_exceeding_defect_budget = 0_u32;
    let coefficient_image = visit_g41_q29_exact_block_states(
        requested_mask,
        requested_digits,
        |coefficients, profile| {
            if let Some(profile) = profile {
                workspace.insert(profile, lane_support.q58_anti_energy_support(coefficients))?;
            } else {
                profiles_exceeding_defect_budget = profiles_exceeding_defect_budget
                    .checked_add(1)
                    .ok_or(G41Q29Q58EnergyError::ProfileBudget)?;
            }
            Ok::<_, G41Q29Q58EnergyError>(())
        },
    )?;
    let mut records = workspace.records();
    records.sort_unstable();
    let mut hasher = Sha256::new();
    let mut energy_memberships = 0_u64;
    let mut energy_profile_counts = vec![0_u32; 524];
    let mut energy_patterns = EnergyPatternWorkspace::<ENERGY_PATTERN_CAPACITY>::new();
    let mut largest_energy_support_class = 0_u32;
    let mut minimum_energy = u16::MAX;
    let mut maximum_energy = 0_u16;
    for record in &records {
        largest_energy_support_class =
            largest_energy_support_class.max(energy_patterns.insert(record.q58_energy_support)?);
        for (word_index, &word) in record.q58_energy_support.iter().enumerate() {
            energy_memberships += u64::from(word.count_ones());
            if word == 0 {
                continue;
            }
            minimum_energy =
                minimum_energy.min((64 * word_index + word.trailing_zeros() as usize) as u16);
            maximum_energy = maximum_energy
                .max((64 * word_index + (u64::BITS - 1 - word.leading_zeros()) as usize) as u16);
            let mut values = word;
            while values != 0 {
                let bit = values.trailing_zeros() as usize;
                values &= values - 1;
                let energy = 64 * word_index + bit;
                if energy < 524 {
                    energy_profile_counts[energy] = energy_profile_counts[energy]
                        .checked_add(1)
                        .ok_or(G41Q29Q58EnergyError::ProfileBudget)?;
                }
            }
        }
        for word in record.profile.packed_words() {
            hasher.update(word.to_le_bytes());
        }
        for word in record.q58_energy_support {
            hasher.update(word.to_le_bytes());
        }
    }
    if records.is_empty() {
        minimum_energy = 0;
    }
    let workspace_bytes = coefficient_image.workspace_bytes
        + ProfileEnergyWorkspace::<PROFILE_CAPACITY>::bytes()
        + EnergyPatternWorkspace::<ENERGY_PATTERN_CAPACITY>::bytes()
        + (records.capacity() * std::mem::size_of::<ProfileEnergyRecord>()) as u64;
    let mut energy_support_classes = energy_patterns.classes();
    let mut profiles = Vec::with_capacity(records.len());
    for record in &records {
        let class = energy_support_classes
            .binary_search_by_key(&record.q58_energy_support, |class| class.support)
            .map_err(|_| G41Q29Q58EnergyError::SemanticMismatch)?;
        for coordinate in 0..7 {
            let value = usize::from(record.profile.coordinate(coordinate));
            if value > 523 {
                return Err(G41Q29Q58EnergyError::SemanticMismatch);
            }
            energy_support_classes[class].q29_defect_value_masks[coordinate][value / 64] |=
                1_u64 << (value % 64);
        }
        profiles.push(G41Q29Q58EnergyProfile {
            profile: record.profile,
            energy_class: class as u16,
            _pad: [0; 6],
        });
    }
    let workspace_bytes = workspace_bytes
        + (profiles.capacity() * std::mem::size_of::<G41Q29Q58EnergyProfile>()) as u64;
    Ok(G41Q29Q58EnergyTablebase {
        report: G41Q29Q58EnergyReport {
            coefficient_image,
            profiles_exceeding_defect_budget,
            energy_profiles: profiles.len() as u32,
            energy_memberships,
            energy_profile_counts,
            distinct_energy_supports: energy_patterns.touched.len() as u32,
            largest_energy_support_class,
            energy_support_classes,
            minimum_energy,
            maximum_energy,
            profile_digest: hasher.finalize().into(),
            workspace_bytes,
            provenance: "typed composition of the exact q29 coefficient/profile extractor with the exact eight-pair q58 marginal lane image; every retained bit follows from E=d0^2+4 sum(dj^2), cross-coordinate allocation correlations are forgotten, and no four-block exclusion is authorized without an exact energy/profile join",
        },
        profiles: profiles.into_boxed_slice(),
    })
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::allocation_test::tracked_allocations;

    #[test]
    fn profile_workspace_unions_energy_fibres_and_allocates_nothing_hot() {
        let mut workspace = ProfileEnergyWorkspace::<256>::new();
        let first = G41Q29ExactProfile::from_coordinates([1, 2, 3, 4, 5, 6, 7]);
        let second = G41Q29ExactProfile::from_coordinates([7, 6, 5, 4, 3, 2, 1]);
        let mut energy_a = [0_u64; Q58_ANTI_ENERGY_WORDS];
        energy_a[0] = 1 << 3;
        let mut energy_b = [0_u64; Q58_ANTI_ENERGY_WORDS];
        energy_b[1] = 1 << 5;
        let (result, allocations) = tracked_allocations(|| {
            workspace.insert(first, energy_a)?;
            workspace.insert(first, energy_b)?;
            workspace.insert(second, energy_a)?;
            Ok::<_, G41Q29Q58EnergyError>(())
        });
        result.unwrap();
        assert_eq!(allocations, 0);
        let mut records = workspace.records();
        records.sort_unstable();
        assert_eq!(records.len(), 2);
        let union = records
            .iter()
            .find(|record| record.profile == first)
            .unwrap();
        assert_eq!(union.q58_energy_support[0], 1 << 3);
        assert_eq!(union.q58_energy_support[1], 1 << 5);
    }

    #[test]
    fn profile_workspace_rejects_empty_semantics() {
        let mut workspace = ProfileEnergyWorkspace::<16>::new();
        let profile = G41Q29ExactProfile::from_coordinates([0; 7]);
        assert_eq!(
            workspace.insert(profile, [0; Q58_ANTI_ENERGY_WORDS]),
            Err(G41Q29Q58EnergyError::SemanticMismatch)
        );
    }

    #[test]
    fn energy_pattern_workspace_counts_exact_shapes_without_allocating_hot() {
        let mut workspace = EnergyPatternWorkspace::<16>::new();
        let mut first = [0_u64; Q58_ANTI_ENERGY_WORDS];
        first[0] = 1;
        let mut second = first;
        second[1] = 2;
        let (counts, allocations) = tracked_allocations(|| {
            Ok::<_, G41Q29Q58EnergyError>([
                workspace.insert(first)?,
                workspace.insert(second)?,
                workspace.insert(first)?,
            ])
        });
        assert_eq!(counts.unwrap(), [1, 1, 2]);
        assert_eq!(workspace.touched.len(), 2);
        assert_eq!(
            workspace
                .classes()
                .iter()
                .map(|class| class.profiles)
                .sum::<u32>(),
            3
        );
        assert_eq!(allocations, 0);
    }

    #[test]
    fn four_block_energy_join_counts_exact_class_products() {
        fn class(energy: usize, profiles: u32) -> G41Q29Q58EnergySupportClass {
            let mut support = [0_u64; Q58_ANTI_ENERGY_WORDS];
            support[energy / 64] = 1_u64 << (energy % 64);
            G41Q29Q58EnergySupportClass {
                support,
                profiles,
                q29_defect_value_masks: [support; 7],
            }
        }
        let blocks = [
            [class(100, 2)],
            [class(100, 3)],
            [class(100, 5)],
            [class(223, 7)],
        ];
        let report =
            analyze_g41_q29_q58_four_block_energy([&blocks[0], &blocks[1], &blocks[2], &blocks[3]])
                .unwrap();
        assert_eq!(report.class_quadruples, 1);
        assert_eq!(report.compatible_class_quadruples, 1);
        assert_eq!(report.raw_profile_quadruples, 210);
        assert_eq!(report.compatible_profile_quadruples, 210);
        assert_eq!(report.defect_marginal_compatible_class_quadruples, 1);
        assert_eq!(report.defect_marginal_compatible_profile_quadruples, 210);
        let mut defect_impossible = class(223, 7);
        let defect_mask = class(224, 1).support;
        defect_impossible.q29_defect_value_masks = [defect_mask; 7];
        let defect_impossible = [defect_impossible];
        let report = analyze_g41_q29_q58_four_block_energy([
            &blocks[0],
            &blocks[1],
            &blocks[2],
            &defect_impossible,
        ])
        .unwrap();
        assert_eq!(report.compatible_class_quadruples, 1);
        assert_eq!(report.defect_marginal_compatible_class_quadruples, 0);
        assert_eq!(report.defect_scope_cover.selected_indices.as_ref(), &[0]);
        assert_eq!(report.defect_scope_cover.finally_uncovered, 0);
        let impossible = [class(224, 7)];
        let report = analyze_g41_q29_q58_four_block_energy([
            &blocks[0],
            &blocks[1],
            &blocks[2],
            &impossible,
        ])
        .unwrap();
        assert_eq!(report.compatible_class_quadruples, 0);
        assert_eq!(report.compatible_profile_quadruples, 0);
        assert_eq!(report.defect_marginal_compatible_class_quadruples, 0);
    }

    #[test]
    fn scoped_linear_grammar_and_cyclic_sumset_are_complete_and_stable() {
        let candidates = scoped_linear_candidates();
        assert_eq!(candidates.len(), 336);
        let mut unique = candidates.clone();
        unique.sort_unstable();
        unique.dedup();
        assert_eq!(unique.len(), candidates.len());
        let intervals = scoped_interval_candidates();
        assert_eq!(intervals.len(), 42);
        assert!(intervals.iter().all(|candidate| candidate.modulus == 0));
        let left = (1_u32 << 1) | (1 << 3);
        let right = (1_u32 << 2) | (1 << 4);
        assert_eq!(
            cyclic_sumset(left, right, 5),
            (1 << 0) | (1 << 2) | (1 << 3)
        );
        let mut exact_left = [0_u64; EXACT_LINEAR_WORDS];
        exact_left[0] = (1 << 1) | (1 << 3);
        let mut exact_right = [0_u64; EXACT_LINEAR_WORDS];
        exact_right[0] = 1 << 2;
        let pair = convolve_exact_linear(exact_left, exact_right);
        assert!(exact_pair_supports_target(&pair, &pair, 6));
        assert!(!exact_pair_supports_target(&pair, &pair, 7));
    }
}
