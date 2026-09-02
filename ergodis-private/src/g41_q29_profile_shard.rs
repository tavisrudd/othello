//! Exact low-memory shards for g41 q29 four-profile joins.

use serde::Serialize;
use thiserror::Error;

use crate::g41_q29_exact_tablebase::G41Q29ExactProfile;
use crate::g41_q29_profile_descent::G41Q29ProfileJoinCandidate;

const BLOCKS: usize = 4;
const COORDINATES: usize = 7;
const TARGET: u16 = 523;
const PROJECTION_RADIX: usize = TARGET as usize + 1;
const PROJECTION_KEYS: usize = PROJECTION_RADIX * PROJECTION_RADIX;

#[derive(Clone, Debug, Error, PartialEq, Eq)]
pub enum G41Q29ProfileShardError {
    #[error("profile shard coordinate or index is outside its sealed bound")]
    SemanticMismatch,
    #[error("profile shard exceeded its explicit pair workspace")]
    StateBudget,
}

pub struct G41Q29ProjectionIndex {
    offsets: Box<[u32]>,
    indices: Box<[u32]>,
}

/// Exact full-key index over a sealed pair-target table.
///
/// Slots retain source-table indices, not fingerprints. Every candidate hit is
/// resolved against all seven coordinates before it can affect participation.
pub struct G41Q29PairTargetIndex<'a> {
    targets: &'a [G41Q29PairTarget],
    slots: Box<[u32]>,
    mask: usize,
    bloom: Box<[u64]>,
    bloom_mask: usize,
}

pub struct G41Q29ProfileShardWorkspace {
    left_keys: Vec<u64>,
    capacity: usize,
}

#[repr(C)]
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq, PartialOrd, Ord)]
struct ProfilePairRecord {
    key: u64,
    first: u32,
    second: u32,
}

const _: () = assert!(std::mem::size_of::<ProfilePairRecord>() == 16);

pub struct G41Q29ProfileParticipationWorkspace {
    left_pairs: Vec<ProfilePairRecord>,
    right_pairs: Vec<ProfilePairRecord>,
    capacity: usize,
}

pub struct G41Q29PairTargetWorkspace {
    tagged_keys: Vec<u64>,
    capacity: usize,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q29ProfileShardReport {
    pub projection_coordinates: [u8; 2],
    pub left_projection_sum: [u16; 2],
    pub right_projection_sum: [u16; 2],
    pub left_pairs_generated: u64,
    pub distinct_left_keys: u64,
    pub right_pairs_probed: u64,
    pub workspace_capacity: u64,
    pub workspace_bytes: u64,
    pub hit: Option<G41Q29ProfileJoinCandidate>,
    pub provenance: &'static str,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q29ProfileShardProbeReport {
    pub right_profiles: u32,
    pub right_pairs_probed: u64,
    pub exact_profile_quartets: u128,
    pub sample_hit: Option<G41Q29ProfileJoinCandidate>,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q29ProfileShardDualReport {
    pub projection_coordinates: [u8; 2],
    pub left_projection_sum: [u16; 2],
    pub right_projection_sum: [u16; 2],
    pub left_pairs_generated: u64,
    pub left_key_entries: u64,
    pub probes: [G41Q29ProfileShardProbeReport; 2],
    pub workspace_capacity: u64,
    pub workspace_bytes: u64,
    pub provenance: &'static str,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q29PairTargetReport {
    pub b1_distinct_targets: u64,
    pub b5_distinct_targets: u64,
    pub union_distinct_targets: u64,
    pub workspace_capacity: u64,
    pub workspace_bytes: u64,
    pub provenance: &'static str,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q29TargetCacheParticipationReport {
    pub pair_records_examined: [u64; 3],
    pub matching_pair_records: [u64; 3],
    pub target_index_bytes: u64,
    pub provenance: &'static str,
}

#[repr(C)]
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq, PartialOrd, Ord, Serialize)]
pub struct G41Q29PairTarget {
    pub coordinates: [u16; COORDINATES],
    pub archetype_bits: u8,
    pub _pad: u8,
}

const _: () = assert!(std::mem::size_of::<G41Q29PairTarget>() == 16);

impl G41Q29ProfileShardWorkspace {
    pub fn new(capacity: usize) -> Result<Self, G41Q29ProfileShardError> {
        if capacity == 0 || capacity > u32::MAX as usize {
            return Err(G41Q29ProfileShardError::StateBudget);
        }
        Ok(Self {
            left_keys: Vec::with_capacity(capacity),
            capacity,
        })
    }

    pub fn bytes(&self) -> u64 {
        (self.capacity * std::mem::size_of::<u64>()) as u64
    }
}

impl G41Q29ProfileParticipationWorkspace {
    pub fn new(capacity: usize) -> Result<Self, G41Q29ProfileShardError> {
        if capacity == 0 || capacity > u32::MAX as usize {
            return Err(G41Q29ProfileShardError::StateBudget);
        }
        Ok(Self {
            left_pairs: Vec::with_capacity(capacity),
            right_pairs: Vec::with_capacity(capacity),
            capacity,
        })
    }

    pub fn new_streaming(capacity: usize) -> Result<Self, G41Q29ProfileShardError> {
        if capacity == 0 || capacity > u32::MAX as usize {
            return Err(G41Q29ProfileShardError::StateBudget);
        }
        Ok(Self {
            left_pairs: Vec::with_capacity(capacity),
            right_pairs: Vec::new(),
            capacity,
        })
    }

    pub fn bytes(&self) -> u64 {
        ((self.left_pairs.capacity() + self.right_pairs.capacity())
            * std::mem::size_of::<ProfilePairRecord>()) as u64
    }
}

#[inline(always)]
fn mark_profile(bits: &mut [u64], index: u32) -> Result<(), G41Q29ProfileShardError> {
    let index = index as usize;
    let Some(word) = bits.get_mut(index / 64) else {
        return Err(G41Q29ProfileShardError::SemanticMismatch);
    };
    *word |= 1_u64 << (index % 64);
    Ok(())
}

impl G41Q29PairTargetWorkspace {
    pub fn new(capacity: usize) -> Result<Self, G41Q29ProfileShardError> {
        if capacity == 0 || capacity > u32::MAX as usize {
            return Err(G41Q29ProfileShardError::StateBudget);
        }
        Ok(Self {
            tagged_keys: Vec::with_capacity(capacity),
            capacity,
        })
    }

    pub fn bytes(&self) -> u64 {
        (self.capacity * std::mem::size_of::<u64>()) as u64
    }

    pub fn append_targets<const FIRST: usize, const SECOND: usize>(
        &self,
        left_projection_sum: [u16; 2],
        output: &mut Vec<G41Q29PairTarget>,
        output_capacity: usize,
    ) -> Result<(), G41Q29ProfileShardError> {
        if FIRST >= COORDINATES
            || SECOND >= COORDINATES
            || FIRST == SECOND
            || left_projection_sum.iter().any(|&value| value > TARGET)
            || output.capacity() < output_capacity
        {
            return Err(G41Q29ProfileShardError::SemanticMismatch);
        }
        let mut cursor = 0_usize;
        while cursor < self.tagged_keys.len() {
            let key = self.tagged_keys[cursor] >> 1;
            let mut archetype_bits = 0_u8;
            while cursor < self.tagged_keys.len() && self.tagged_keys[cursor] >> 1 == key {
                archetype_bits |= 1_u8 << ((self.tagged_keys[cursor] & 1) as u32);
                cursor += 1;
            }
            if output.len() == output_capacity {
                return Err(G41Q29ProfileShardError::StateBudget);
            }
            let mut shift = 0_u32;
            let mut coordinates = [0_u16; COORDINATES];
            coordinates[FIRST] = left_projection_sum[0];
            coordinates[SECOND] = left_projection_sum[1];
            for (coordinate, value) in coordinates.iter_mut().enumerate() {
                if coordinate == FIRST || coordinate == SECOND {
                    continue;
                }
                *value = ((key >> shift) & 0x3ff) as u16;
                shift += 10;
            }
            output.push(G41Q29PairTarget {
                coordinates,
                archetype_bits,
                _pad: 0,
            });
        }
        Ok(())
    }
}

#[inline(always)]
fn projection_key<const FIRST: usize, const SECOND: usize>(profile: G41Q29ExactProfile) -> usize {
    usize::from(profile.coordinate(FIRST)) * PROJECTION_RADIX
        + usize::from(profile.coordinate(SECOND))
}

pub fn compile_g41_q29_projection_index<const FIRST: usize, const SECOND: usize>(
    profiles: &[G41Q29ExactProfile],
) -> Result<G41Q29ProjectionIndex, G41Q29ProfileShardError> {
    if FIRST >= COORDINATES
        || SECOND >= COORDINATES
        || FIRST == SECOND
        || profiles.len() > u32::MAX as usize
    {
        return Err(G41Q29ProfileShardError::SemanticMismatch);
    }
    let mut offsets = vec![0_u32; PROJECTION_KEYS + 1];
    for &profile in profiles {
        let key = projection_key::<FIRST, SECOND>(profile);
        offsets[key + 1] = offsets[key + 1]
            .checked_add(1)
            .ok_or(G41Q29ProfileShardError::StateBudget)?;
    }
    for key in 0..PROJECTION_KEYS {
        offsets[key + 1] = offsets[key + 1]
            .checked_add(offsets[key])
            .ok_or(G41Q29ProfileShardError::StateBudget)?;
    }
    let mut cursors = offsets[..PROJECTION_KEYS].to_vec();
    let mut indices = vec![0_u32; profiles.len()];
    for (index, &profile) in profiles.iter().enumerate() {
        let key = projection_key::<FIRST, SECOND>(profile);
        let slot = cursors[key] as usize;
        indices[slot] = index as u32;
        cursors[key] += 1;
    }
    Ok(G41Q29ProjectionIndex {
        offsets: offsets.into_boxed_slice(),
        indices: indices.into_boxed_slice(),
    })
}

impl G41Q29ProjectionIndex {
    #[inline(always)]
    fn range(&self, first: u16, second: u16) -> &[u32] {
        let key = usize::from(first) * PROJECTION_RADIX + usize::from(second);
        &self.indices[self.offsets[key] as usize..self.offsets[key + 1] as usize]
    }
}

#[inline(always)]
fn target_hash(coordinates: [u16; COORDINATES]) -> u64 {
    let mut hash = 0x9e37_79b9_7f4a_7c15_u64;
    for value in coordinates {
        hash ^= u64::from(value).wrapping_add(0x9e37_79b9);
        hash = hash.rotate_left(17).wrapping_mul(0xbf58_476d_1ce4_e5b9);
    }
    hash ^ (hash >> 31)
}

impl<'a> G41Q29PairTargetIndex<'a> {
    pub fn compile(targets: &'a [G41Q29PairTarget]) -> Result<Self, G41Q29ProfileShardError> {
        if targets.is_empty()
            || targets.len() > (1 << 24)
            || targets.iter().any(|target| {
                target.coordinates.iter().any(|&value| value > TARGET)
                    || !matches!(target.archetype_bits, 1..=3)
                    || target._pad != 0
            })
            || targets.windows(2).any(|pair| pair[0] >= pair[1])
        {
            return Err(G41Q29ProfileShardError::SemanticMismatch);
        }
        let capacity = targets
            .len()
            .checked_add(targets.len() / 2)
            .and_then(|value| value.checked_add(1))
            .and_then(usize::checked_next_power_of_two)
            .ok_or(G41Q29ProfileShardError::StateBudget)?;
        let mut slots = vec![u32::MAX; capacity].into_boxed_slice();
        let mask = capacity - 1;
        let bloom_bits = targets
            .len()
            .checked_mul(12)
            .and_then(usize::checked_next_power_of_two)
            .ok_or(G41Q29ProfileShardError::StateBudget)?
            .max(64);
        let mut bloom = vec![0_u64; bloom_bits / 64].into_boxed_slice();
        let bloom_mask = bloom_bits - 1;
        for (index, target) in targets.iter().enumerate() {
            let hash = target_hash(target.coordinates);
            let first_bit = hash as usize & bloom_mask;
            let second_bit = (hash >> 32) as usize & bloom_mask;
            bloom[first_bit / 64] |= 1_u64 << (first_bit % 64);
            bloom[second_bit / 64] |= 1_u64 << (second_bit % 64);
            let mut slot = hash as usize & mask;
            loop {
                if slots[slot] == u32::MAX {
                    slots[slot] = index as u32;
                    break;
                }
                slot = (slot + 1) & mask;
            }
        }
        Ok(Self {
            targets,
            slots,
            mask,
            bloom,
            bloom_mask,
        })
    }

    pub fn bytes(&self) -> u64 {
        (self.slots.len() * std::mem::size_of::<u32>()
            + self.bloom.len() * std::mem::size_of::<u64>()) as u64
    }

    #[inline(always)]
    pub fn archetype_bits(&self, coordinates: [u16; COORDINATES]) -> Option<u8> {
        let hash = target_hash(coordinates);
        let first_bit = hash as usize & self.bloom_mask;
        let second_bit = (hash >> 32) as usize & self.bloom_mask;
        if self.bloom[first_bit / 64] & (1_u64 << (first_bit % 64)) == 0
            || self.bloom[second_bit / 64] & (1_u64 << (second_bit % 64)) == 0
        {
            return None;
        }
        let mut slot = hash as usize & self.mask;
        loop {
            let index = self.slots[slot];
            if index == u32::MAX {
                return None;
            }
            let target = self.targets[index as usize];
            if target.coordinates == coordinates {
                return Some(target.archetype_bits);
            }
            slot = (slot + 1) & self.mask;
        }
    }
}

#[inline(always)]
fn pack_remaining_sum<const FIRST: usize, const SECOND: usize>(
    left: G41Q29ExactProfile,
    right: G41Q29ExactProfile,
) -> Option<u64> {
    let mut packed = 0_u64;
    let mut shift = 0_u32;
    for coordinate in 0..COORDINATES {
        if coordinate == FIRST || coordinate == SECOND {
            continue;
        }
        let sum = left.coordinate(coordinate) + right.coordinate(coordinate);
        if sum > TARGET {
            return None;
        }
        packed |= u64::from(sum) << shift;
        shift += 10;
    }
    Some(packed)
}

#[inline(always)]
fn complement_remaining_key(key: u64) -> u64 {
    let mut complement = 0_u64;
    for coordinate in 0..COORDINATES - 2 {
        let value = ((key >> (10 * coordinate)) & 0x3ff) as u16;
        complement |= u64::from(TARGET - value) << (10 * coordinate);
    }
    complement
}

#[inline(always)]
fn pair_sum_coordinates(
    first: G41Q29ExactProfile,
    second: G41Q29ExactProfile,
) -> Option<[u16; COORDINATES]> {
    let mut coordinates = [0_u16; COORDINATES];
    for coordinate in 0..COORDINATES {
        let value = first.coordinate(coordinate) + second.coordinate(coordinate);
        if value > TARGET {
            return None;
        }
        coordinates[coordinate] = value;
    }
    Some(coordinates)
}

fn replay_candidate(
    sets: [&[G41Q29ExactProfile]; BLOCKS],
    indices: [u32; BLOCKS],
) -> Option<G41Q29ProfileJoinCandidate> {
    let sums: [u16; COORDINATES] = std::array::from_fn(|coordinate| {
        (0..BLOCKS)
            .map(|block| sets[block][indices[block] as usize].coordinate(coordinate))
            .sum()
    });
    (sums == [TARGET; COORDINATES]).then_some(G41Q29ProfileJoinCandidate {
        indices,
        residual: 0,
        sums,
        _pad: [0; 30],
    })
}

fn recover_left_pair<const FIRST: usize, const SECOND: usize>(
    sets: [&[G41Q29ExactProfile]; 2],
    indices: [&G41Q29ProjectionIndex; 2],
    left_projection_sum: [u16; 2],
    needed: u64,
) -> Option<[u32; 2]> {
    for first_value in 0..=left_projection_sum[0] {
        for second_value in 0..=left_projection_sum[1] {
            for &first_index in indices[0].range(first_value, second_value) {
                for &second_index in indices[1].range(
                    left_projection_sum[0] - first_value,
                    left_projection_sum[1] - second_value,
                ) {
                    if pack_remaining_sum::<FIRST, SECOND>(
                        sets[0][first_index as usize],
                        sets[1][second_index as usize],
                    ) == Some(needed)
                    {
                        return Some([first_index, second_index]);
                    }
                }
            }
        }
    }
    None
}

fn probe_counted_right<const FIRST: usize, const SECOND: usize>(
    left_sets: [&[G41Q29ExactProfile]; 2],
    left_indices: [&G41Q29ProjectionIndex; 2],
    right: &[G41Q29ExactProfile],
    right_index: &G41Q29ProjectionIndex,
    left_projection_sum: [u16; 2],
    workspace: &G41Q29ProfileShardWorkspace,
) -> Result<G41Q29ProfileShardProbeReport, G41Q29ProfileShardError> {
    let right_projection_sum = [
        TARGET - left_projection_sum[0],
        TARGET - left_projection_sum[1],
    ];
    let mut right_pairs_probed = 0_u64;
    let mut exact_profile_quartets = 0_u128;
    let mut sample_hit = None;
    for first_value in 0..=right_projection_sum[0] {
        for second_value in 0..=right_projection_sum[1] {
            let first_range = right_index.range(first_value, second_value);
            let second_range = right_index.range(
                right_projection_sum[0] - first_value,
                right_projection_sum[1] - second_value,
            );
            for &first_index in first_range {
                for &second_index in second_range {
                    let Some(key) = pack_remaining_sum::<FIRST, SECOND>(
                        right[first_index as usize],
                        right[second_index as usize],
                    ) else {
                        continue;
                    };
                    right_pairs_probed += 1;
                    let needed = complement_remaining_key(key);
                    let Ok(position) = workspace.left_keys.binary_search(&needed) else {
                        continue;
                    };
                    let mut start = position;
                    while start != 0 && workspace.left_keys[start - 1] == needed {
                        start -= 1;
                    }
                    let mut end = position + 1;
                    while end != workspace.left_keys.len() && workspace.left_keys[end] == needed {
                        end += 1;
                    }
                    exact_profile_quartets = exact_profile_quartets
                        .checked_add((end - start) as u128)
                        .ok_or(G41Q29ProfileShardError::StateBudget)?;
                    if sample_hit.is_none() {
                        let Some([left_first, left_second]) = recover_left_pair::<FIRST, SECOND>(
                            left_sets,
                            left_indices,
                            left_projection_sum,
                            needed,
                        ) else {
                            return Err(G41Q29ProfileShardError::SemanticMismatch);
                        };
                        let sets = [left_sets[0], right, left_sets[1], right];
                        sample_hit = replay_candidate(
                            sets,
                            [left_first, first_index, left_second, second_index],
                        );
                        if sample_hit.is_none() {
                            return Err(G41Q29ProfileShardError::SemanticMismatch);
                        }
                    }
                }
            }
        }
    }
    Ok(G41Q29ProfileShardProbeReport {
        right_profiles: right.len() as u32,
        right_pairs_probed,
        exact_profile_quartets,
        sample_hit,
    })
}

pub fn count_g41_q29_profile_shard_dual<const FIRST: usize, const SECOND: usize>(
    left_sets: [&[G41Q29ExactProfile]; 2],
    right_sets: [&[G41Q29ExactProfile]; 2],
    left_indices: [&G41Q29ProjectionIndex; 2],
    right_indices: [&G41Q29ProjectionIndex; 2],
    left_projection_sum: [u16; 2],
    workspace: &mut G41Q29ProfileShardWorkspace,
) -> Result<G41Q29ProfileShardDualReport, G41Q29ProfileShardError> {
    if FIRST >= COORDINATES
        || SECOND >= COORDINATES
        || FIRST == SECOND
        || left_projection_sum.iter().any(|&value| value > TARGET)
        || left_sets
            .iter()
            .any(|profiles| profiles.len() > u32::MAX as usize)
        || right_sets
            .iter()
            .any(|profiles| profiles.len() > u32::MAX as usize)
    {
        return Err(G41Q29ProfileShardError::SemanticMismatch);
    }
    workspace.left_keys.clear();
    let mut left_pairs_generated = 0_u64;
    for first_value in 0..=left_projection_sum[0] {
        for second_value in 0..=left_projection_sum[1] {
            let first_range = left_indices[0].range(first_value, second_value);
            let second_range = left_indices[1].range(
                left_projection_sum[0] - first_value,
                left_projection_sum[1] - second_value,
            );
            for &first_index in first_range {
                for &second_index in second_range {
                    let Some(key) = pack_remaining_sum::<FIRST, SECOND>(
                        left_sets[0][first_index as usize],
                        left_sets[1][second_index as usize],
                    ) else {
                        continue;
                    };
                    if workspace.left_keys.len() == workspace.capacity {
                        workspace.left_keys.clear();
                        return Err(G41Q29ProfileShardError::StateBudget);
                    }
                    workspace.left_keys.push(key);
                    left_pairs_generated += 1;
                }
            }
        }
    }
    workspace.left_keys.sort_unstable();
    let probes = [
        probe_counted_right::<FIRST, SECOND>(
            left_sets,
            left_indices,
            right_sets[0],
            right_indices[0],
            left_projection_sum,
            workspace,
        )?,
        probe_counted_right::<FIRST, SECOND>(
            left_sets,
            left_indices,
            right_sets[1],
            right_indices[1],
            left_projection_sum,
            workspace,
        )?,
    ];
    Ok(G41Q29ProfileShardDualReport {
        projection_coordinates: [FIRST as u8, SECOND as u8],
        left_projection_sum,
        right_projection_sum: [
            TARGET - left_projection_sum[0],
            TARGET - left_projection_sum[1],
        ],
        left_pairs_generated,
        left_key_entries: workspace.left_keys.len() as u64,
        probes,
        workspace_capacity: workspace.capacity as u64,
        workspace_bytes: workspace.bytes(),
        provenance: "exact dual-archetype q29 profile shard; A+C keys retain multiplicity and are sorted once, both B+B sides stream through the same table, exact quartet multiplicity is counted, and one source-index tuple per nonempty archetype is independently replayed",
    })
}

fn compile_pair_records<const FIRST: usize, const SECOND: usize>(
    sets: [&[G41Q29ExactProfile]; 2],
    indices: [&G41Q29ProjectionIndex; 2],
    projection_sum: [u16; 2],
    complement_keys: bool,
    capacity: usize,
    output: &mut Vec<ProfilePairRecord>,
) -> Result<(), G41Q29ProfileShardError> {
    output.clear();
    for first_value in 0..=projection_sum[0] {
        for second_value in 0..=projection_sum[1] {
            let first_range = indices[0].range(first_value, second_value);
            let second_range = indices[1].range(
                projection_sum[0] - first_value,
                projection_sum[1] - second_value,
            );
            for &first in first_range {
                for &second in second_range {
                    let Some(mut key) = pack_remaining_sum::<FIRST, SECOND>(
                        sets[0][first as usize],
                        sets[1][second as usize],
                    ) else {
                        continue;
                    };
                    if complement_keys {
                        key = complement_remaining_key(key);
                    }
                    if output.len() == capacity {
                        output.clear();
                        return Err(G41Q29ProfileShardError::StateBudget);
                    }
                    output.push(ProfilePairRecord { key, first, second });
                }
            }
        }
    }
    output.sort_unstable();
    Ok(())
}

enum RightParticipation<'a> {
    Shared(&'a mut [u64]),
    Split([&'a mut [u64]; 2]),
}

fn merge_pair_participation(
    left: &[ProfilePairRecord],
    right: &[ProfilePairRecord],
    left_participation: [&mut [u64]; 2],
    mut right_participation: RightParticipation<'_>,
) -> Result<u128, G41Q29ProfileShardError> {
    let mut left_cursor = 0_usize;
    let mut right_cursor = 0_usize;
    let mut quartets = 0_u128;
    while left_cursor < left.len() && right_cursor < right.len() {
        let left_key = left[left_cursor].key;
        let right_key = right[right_cursor].key;
        match left_key.cmp(&right_key) {
            std::cmp::Ordering::Less => left_cursor += 1,
            std::cmp::Ordering::Greater => right_cursor += 1,
            std::cmp::Ordering::Equal => {
                let left_end = left[left_cursor..].partition_point(|record| record.key == left_key)
                    + left_cursor;
                let right_end = right[right_cursor..]
                    .partition_point(|record| record.key == right_key)
                    + right_cursor;
                quartets = quartets
                    .checked_add(
                        (left_end - left_cursor) as u128 * (right_end - right_cursor) as u128,
                    )
                    .ok_or(G41Q29ProfileShardError::StateBudget)?;
                for record in &left[left_cursor..left_end] {
                    mark_profile(left_participation[0], record.first)?;
                    mark_profile(left_participation[1], record.second)?;
                }
                for record in &right[right_cursor..right_end] {
                    match &mut right_participation {
                        RightParticipation::Shared(bits) => {
                            mark_profile(bits, record.first)?;
                            mark_profile(bits, record.second)?;
                        }
                        RightParticipation::Split(bits) => {
                            mark_profile(bits[0], record.first)?;
                            mark_profile(bits[1], record.second)?;
                        }
                    }
                }
                left_cursor = left_end;
                right_cursor = right_end;
            }
        }
    }
    Ok(quartets)
}

/// Marks every endpoint of an exact four-profile join in one projection
/// shard. Pair tables for both sides are retained and merged by equal runs, so
/// a repeated key is expanded once rather than once per opposite-side pair.
pub fn mark_g41_q29_profile_shard_participation<const FIRST: usize, const SECOND: usize>(
    sets: [&[G41Q29ExactProfile]; 4],
    indices: [&G41Q29ProjectionIndex; 4],
    left_projection_sum: [u16; 2],
    workspace: &mut G41Q29ProfileParticipationWorkspace,
    participation: [&mut [u64]; 4],
) -> Result<u128, G41Q29ProfileShardError> {
    if FIRST >= COORDINATES
        || SECOND >= COORDINATES
        || FIRST == SECOND
        || left_projection_sum.iter().any(|&value| value > TARGET)
        || participation
            .iter()
            .zip(sets)
            .any(|(bits, profiles)| bits.len() < profiles.len().div_ceil(64))
    {
        return Err(G41Q29ProfileShardError::SemanticMismatch);
    }
    compile_pair_records::<FIRST, SECOND>(
        [sets[0], sets[1]],
        [indices[0], indices[1]],
        left_projection_sum,
        false,
        workspace.capacity,
        &mut workspace.left_pairs,
    )?;
    let right_projection_sum = [
        TARGET - left_projection_sum[0],
        TARGET - left_projection_sum[1],
    ];
    compile_pair_records::<FIRST, SECOND>(
        [sets[2], sets[3]],
        [indices[2], indices[3]],
        right_projection_sum,
        true,
        workspace.capacity,
        &mut workspace.right_pairs,
    )?;
    let [first_bits, second_bits, third_bits, fourth_bits] = participation;
    merge_pair_participation(
        &workspace.left_pairs,
        &workspace.right_pairs,
        [first_bits, second_bits],
        RightParticipation::Split([third_bits, fourth_bits]),
    )
}

/// Retains the shared left pair table and streams both one-use symmetric
/// right sides. This is the low-hit-rate production strategy: the expensive
/// A+C table is reused across archetypes, while cold B+B records are never
/// sorted or retained.
pub fn mark_g41_q29_profile_shard_participation_dual_streaming<
    const FIRST: usize,
    const SECOND: usize,
>(
    left_sets: [&[G41Q29ExactProfile]; 2],
    right_sets: [&[G41Q29ExactProfile]; 2],
    left_indices: [&G41Q29ProjectionIndex; 2],
    right_indices: [&G41Q29ProjectionIndex; 2],
    left_projection_sum: [u16; 2],
    workspace: &mut G41Q29ProfileParticipationWorkspace,
    participation: [&mut [u64]; 4],
) -> Result<[u128; 2], G41Q29ProfileShardError> {
    if FIRST >= COORDINATES
        || SECOND >= COORDINATES
        || FIRST == SECOND
        || left_projection_sum.iter().any(|&value| value > TARGET)
        || participation[0].len() < left_sets[0].len().div_ceil(64)
        || participation[1].len() < right_sets[0].len().div_ceil(64)
        || participation[2].len() < right_sets[1].len().div_ceil(64)
        || participation[3].len() < left_sets[1].len().div_ceil(64)
    {
        return Err(G41Q29ProfileShardError::SemanticMismatch);
    }
    compile_pair_records::<FIRST, SECOND>(
        left_sets,
        left_indices,
        left_projection_sum,
        false,
        workspace.capacity,
        &mut workspace.left_pairs,
    )?;
    let right_projection_sum = [
        TARGET - left_projection_sum[0],
        TARGET - left_projection_sum[1],
    ];
    let [a_bits, b1_bits, b5_bits, c_bits] = participation;
    let mut quartets = [0_u128; 2];
    for archetype in 0..2 {
        let right = right_sets[archetype];
        let index = right_indices[archetype];
        for first_value in 0..=right_projection_sum[0] {
            for second_value in 0..=right_projection_sum[1] {
                let first_range = index.range(first_value, second_value);
                let second_range = index.range(
                    right_projection_sum[0] - first_value,
                    right_projection_sum[1] - second_value,
                );
                for &first in first_range {
                    for &second in second_range {
                        let Some(key) = pack_remaining_sum::<FIRST, SECOND>(
                            right[first as usize],
                            right[second as usize],
                        ) else {
                            continue;
                        };
                        let needed = complement_remaining_key(key);
                        let start = workspace
                            .left_pairs
                            .partition_point(|record| record.key < needed);
                        let end = workspace
                            .left_pairs
                            .partition_point(|record| record.key <= needed);
                        if start == end {
                            continue;
                        }
                        quartets[archetype] = quartets[archetype]
                            .checked_add((end - start) as u128)
                            .ok_or(G41Q29ProfileShardError::StateBudget)?;
                        let right_bits = if archetype == 0 {
                            &mut *b1_bits
                        } else {
                            &mut *b5_bits
                        };
                        mark_profile(right_bits, first)?;
                        mark_profile(right_bits, second)?;
                        for record in &workspace.left_pairs[start..end] {
                            mark_profile(a_bits, record.first)?;
                            mark_profile(c_bits, record.second)?;
                        }
                    }
                }
            }
        }
    }
    Ok(quartets)
}

/// Marks participation by probing a sealed global full-coordinate target set.
///
/// This is a discovery accelerator: the target cache is checked with exact
/// seven-coordinate equality, but its independent semantic replay remains the
/// authority boundary. The hot pair loops allocate no memory.
pub fn mark_g41_q29_profile_shard_participation_from_targets<
    const FIRST: usize,
    const SECOND: usize,
>(
    left_sets: [&[G41Q29ExactProfile]; 2],
    right_sets: [&[G41Q29ExactProfile]; 2],
    left_indices: [&G41Q29ProjectionIndex; 2],
    right_indices: [&G41Q29ProjectionIndex; 2],
    left_projection_sum: [u16; 2],
    target_index: &G41Q29PairTargetIndex<'_>,
    participation: [&mut [u64]; 4],
) -> Result<G41Q29TargetCacheParticipationReport, G41Q29ProfileShardError> {
    if FIRST >= COORDINATES
        || SECOND >= COORDINATES
        || FIRST == SECOND
        || left_projection_sum.iter().any(|&value| value > TARGET)
        || participation[0].len() < left_sets[0].len().div_ceil(64)
        || participation[1].len() < right_sets[0].len().div_ceil(64)
        || participation[2].len() < right_sets[1].len().div_ceil(64)
        || participation[3].len() < left_sets[1].len().div_ceil(64)
    {
        return Err(G41Q29ProfileShardError::SemanticMismatch);
    }

    let [a_bits, b1_bits, b5_bits, c_bits] = participation;
    let mut examined = [0_u64; 3];
    let mut matching = [0_u64; 3];
    for first_value in 0..=left_projection_sum[0] {
        for second_value in 0..=left_projection_sum[1] {
            let first_range = left_indices[0].range(first_value, second_value);
            let second_range = left_indices[1].range(
                left_projection_sum[0] - first_value,
                left_projection_sum[1] - second_value,
            );
            for &first in first_range {
                for &second in second_range {
                    examined[0] += 1;
                    let Some(coordinates) = pair_sum_coordinates(
                        left_sets[0][first as usize],
                        left_sets[1][second as usize],
                    ) else {
                        continue;
                    };
                    if target_index.archetype_bits(coordinates).is_none() {
                        continue;
                    }
                    matching[0] += 1;
                    mark_profile(a_bits, first)?;
                    mark_profile(c_bits, second)?;
                }
            }
        }
    }

    let right_projection_sum = [
        TARGET - left_projection_sum[0],
        TARGET - left_projection_sum[1],
    ];
    for archetype in 0..2 {
        let right = right_sets[archetype];
        let index = right_indices[archetype];
        for first_value in 0..=right_projection_sum[0] {
            for second_value in 0..=right_projection_sum[1] {
                let first_range = index.range(first_value, second_value);
                let second_range = index.range(
                    right_projection_sum[0] - first_value,
                    right_projection_sum[1] - second_value,
                );
                for &first in first_range {
                    for &second in second_range {
                        examined[archetype + 1] += 1;
                        let Some(sum) =
                            pair_sum_coordinates(right[first as usize], right[second as usize])
                        else {
                            continue;
                        };
                        let needed = sum.map(|value| TARGET - value);
                        let Some(bits) = target_index.archetype_bits(needed) else {
                            continue;
                        };
                        if bits & (1 << archetype) == 0 {
                            continue;
                        }
                        matching[archetype + 1] += 1;
                        let right_bits = if archetype == 0 {
                            &mut *b1_bits
                        } else {
                            &mut *b5_bits
                        };
                        mark_profile(right_bits, first)?;
                        mark_profile(right_bits, second)?;
                    }
                }
            }
        }
    }
    Ok(G41Q29TargetCacheParticipationReport {
        pair_records_examined: examined,
        matching_pair_records: matching,
        target_index_bytes: target_index.bytes(),
        provenance: "discovery-only exact full-key participation scan against the sealed aggregate pair-target cache; immutable open-addressed slots store source indices and every hit compares all seven coordinates; source-profile participation requires independent census equality before promotion",
    })
}

/// Marks every aggregate profile that participates in at least one exact
/// quartet in this shard. The four bitsets are ordered A, B1, B5, C.
pub fn mark_g41_q29_profile_shard_participation_dual<const FIRST: usize, const SECOND: usize>(
    left_sets: [&[G41Q29ExactProfile]; 2],
    right_sets: [&[G41Q29ExactProfile]; 2],
    left_indices: [&G41Q29ProjectionIndex; 2],
    right_indices: [&G41Q29ProjectionIndex; 2],
    left_projection_sum: [u16; 2],
    workspace: &mut G41Q29ProfileParticipationWorkspace,
    participation: [&mut [u64]; 4],
) -> Result<[u128; 2], G41Q29ProfileShardError> {
    if FIRST >= COORDINATES
        || SECOND >= COORDINATES
        || FIRST == SECOND
        || left_projection_sum.iter().any(|&value| value > TARGET)
        || participation[0].len() < left_sets[0].len().div_ceil(64)
        || participation[1].len() < right_sets[0].len().div_ceil(64)
        || participation[2].len() < right_sets[1].len().div_ceil(64)
        || participation[3].len() < left_sets[1].len().div_ceil(64)
    {
        return Err(G41Q29ProfileShardError::SemanticMismatch);
    }
    compile_pair_records::<FIRST, SECOND>(
        left_sets,
        left_indices,
        left_projection_sum,
        false,
        workspace.capacity,
        &mut workspace.left_pairs,
    )?;
    let right_projection_sum = [
        TARGET - left_projection_sum[0],
        TARGET - left_projection_sum[1],
    ];
    let mut quartets = [0_u128; 2];
    let [a_bits, b1_bits, b5_bits, c_bits] = participation;
    for archetype in 0..2 {
        compile_pair_records::<FIRST, SECOND>(
            [right_sets[archetype], right_sets[archetype]],
            [right_indices[archetype], right_indices[archetype]],
            right_projection_sum,
            true,
            workspace.capacity,
            &mut workspace.right_pairs,
        )?;
        let right_bits = if archetype == 0 {
            &mut *b1_bits
        } else {
            &mut *b5_bits
        };
        quartets[archetype] = merge_pair_participation(
            &workspace.left_pairs,
            &workspace.right_pairs,
            [&mut *a_bits, &mut *c_bits],
            RightParticipation::Shared(right_bits),
        )?;
    }
    Ok(quartets)
}

pub fn collect_g41_q29_pair_targets_dual<const FIRST: usize, const SECOND: usize>(
    right_sets: [&[G41Q29ExactProfile]; 2],
    right_indices: [&G41Q29ProjectionIndex; 2],
    left_projection_sum: [u16; 2],
    left_workspace: &G41Q29ProfileShardWorkspace,
    target_workspace: &mut G41Q29PairTargetWorkspace,
) -> Result<G41Q29PairTargetReport, G41Q29ProfileShardError> {
    if FIRST >= COORDINATES
        || SECOND >= COORDINATES
        || FIRST == SECOND
        || left_projection_sum.iter().any(|&value| value > TARGET)
    {
        return Err(G41Q29ProfileShardError::SemanticMismatch);
    }
    target_workspace.tagged_keys.clear();
    let right_projection_sum = [
        TARGET - left_projection_sum[0],
        TARGET - left_projection_sum[1],
    ];
    for archetype in 0..2 {
        let right = right_sets[archetype];
        let index = right_indices[archetype];
        for first_value in 0..=right_projection_sum[0] {
            for second_value in 0..=right_projection_sum[1] {
                let first_range = index.range(first_value, second_value);
                let second_range = index.range(
                    right_projection_sum[0] - first_value,
                    right_projection_sum[1] - second_value,
                );
                for &first_index in first_range {
                    for &second_index in second_range {
                        let Some(key) = pack_remaining_sum::<FIRST, SECOND>(
                            right[first_index as usize],
                            right[second_index as usize],
                        ) else {
                            continue;
                        };
                        let needed = complement_remaining_key(key);
                        if left_workspace.left_keys.binary_search(&needed).is_err() {
                            continue;
                        }
                        if target_workspace.tagged_keys.len() == target_workspace.capacity {
                            target_workspace.tagged_keys.clear();
                            return Err(G41Q29ProfileShardError::StateBudget);
                        }
                        target_workspace
                            .tagged_keys
                            .push((needed << 1) | archetype as u64);
                    }
                }
            }
        }
    }
    target_workspace.tagged_keys.sort_unstable();
    target_workspace.tagged_keys.dedup();
    let mut distinct = [0_u64; 2];
    let mut union = 0_u64;
    let mut previous = None;
    for &tagged in &target_workspace.tagged_keys {
        distinct[(tagged & 1) as usize] += 1;
        let key = tagged >> 1;
        if previous != Some(key) {
            union += 1;
            previous = Some(key);
        }
    }
    Ok(G41Q29PairTargetReport {
        b1_distinct_targets: distinct[0],
        b5_distinct_targets: distinct[1],
        union_distinct_targets: union,
        workspace_capacity: target_workspace.capacity as u64,
        workspace_bytes: target_workspace.bytes(),
        provenance: "exact distinct q29 A+C pair-sum targets admitted by either B+B archetype inside one projection shard; tagged fixed-cap keys are sorted and deduplicated, and union identity includes all seven profile coordinates",
    })
}

pub fn join_g41_q29_profile_shard<const FIRST: usize, const SECOND: usize>(
    sets: [&[G41Q29ExactProfile]; BLOCKS],
    indices: [&G41Q29ProjectionIndex; 4],
    left_projection_sum: [u16; 2],
    workspace: &mut G41Q29ProfileShardWorkspace,
) -> Result<G41Q29ProfileShardReport, G41Q29ProfileShardError> {
    if FIRST >= COORDINATES
        || SECOND >= COORDINATES
        || FIRST == SECOND
        || left_projection_sum.iter().any(|&value| value > TARGET)
    {
        return Err(G41Q29ProfileShardError::SemanticMismatch);
    }
    workspace.left_keys.clear();
    let mut left_pairs_generated = 0_u64;
    for first_value in 0..=left_projection_sum[0] {
        for second_value in 0..=left_projection_sum[1] {
            let left_range = indices[0].range(first_value, second_value);
            let right_range = indices[2].range(
                left_projection_sum[0] - first_value,
                left_projection_sum[1] - second_value,
            );
            for &left_index in left_range {
                for &right_index in right_range {
                    let Some(key) = pack_remaining_sum::<FIRST, SECOND>(
                        sets[0][left_index as usize],
                        sets[2][right_index as usize],
                    ) else {
                        continue;
                    };
                    if workspace.left_keys.len() == workspace.capacity {
                        workspace.left_keys.clear();
                        return Err(G41Q29ProfileShardError::StateBudget);
                    }
                    workspace.left_keys.push(key);
                    left_pairs_generated += 1;
                }
            }
        }
    }
    workspace.left_keys.sort_unstable();
    workspace.left_keys.dedup();

    let right_projection_sum = [
        TARGET - left_projection_sum[0],
        TARGET - left_projection_sum[1],
    ];
    let mut right_pairs_probed = 0_u64;
    for first_value in 0..=right_projection_sum[0] {
        for second_value in 0..=right_projection_sum[1] {
            let first_range = indices[1].range(first_value, second_value);
            let second_range = indices[3].range(
                right_projection_sum[0] - first_value,
                right_projection_sum[1] - second_value,
            );
            for &first_index in first_range {
                for &second_index in second_range {
                    let Some(key) = pack_remaining_sum::<FIRST, SECOND>(
                        sets[1][first_index as usize],
                        sets[3][second_index as usize],
                    ) else {
                        continue;
                    };
                    right_pairs_probed += 1;
                    let needed = complement_remaining_key(key);
                    if workspace.left_keys.binary_search(&needed).is_err() {
                        continue;
                    }
                    for left_first_value in 0..=left_projection_sum[0] {
                        for left_second_value in 0..=left_projection_sum[1] {
                            for &left_index in indices[0].range(left_first_value, left_second_value)
                            {
                                for &right_index in indices[2].range(
                                    left_projection_sum[0] - left_first_value,
                                    left_projection_sum[1] - left_second_value,
                                ) {
                                    if pack_remaining_sum::<FIRST, SECOND>(
                                        sets[0][left_index as usize],
                                        sets[2][right_index as usize],
                                    ) == Some(needed)
                                    {
                                        if let Some(hit) = replay_candidate(
                                            sets,
                                            [left_index, first_index, right_index, second_index],
                                        ) {
                                            return Ok(G41Q29ProfileShardReport {
                                                projection_coordinates: [
                                                    FIRST as u8,
                                                    SECOND as u8,
                                                ],
                                                left_projection_sum,
                                                right_projection_sum,
                                                left_pairs_generated,
                                                distinct_left_keys: workspace.left_keys.len() as u64,
                                                right_pairs_probed,
                                                workspace_capacity: workspace.capacity as u64,
                                                workspace_bytes: workspace.bytes(),
                                                hit: Some(hit),
                                                provenance: "exact two-coordinate profile-sum shard; remaining five sums use a fixed u64 key, the hot join allocates zero times, and witness indices are recovered and replayed only after an exact complement hit",
                                            });
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
    Ok(G41Q29ProfileShardReport {
        projection_coordinates: [FIRST as u8, SECOND as u8],
        left_projection_sum,
        right_projection_sum,
        left_pairs_generated,
        distinct_left_keys: workspace.left_keys.len() as u64,
        right_pairs_probed,
        workspace_capacity: workspace.capacity as u64,
        workspace_bytes: workspace.bytes(),
        hit: None,
        provenance: "exact two-coordinate profile-sum shard; remaining five sums use a fixed u64 key, the hot join allocates zero times, and witness indices are recovered and replayed only after an exact complement hit",
    })
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::allocation_test::tracked_allocations;

    fn profile(values: [u16; 7]) -> G41Q29ExactProfile {
        G41Q29ExactProfile::from_coordinates(values)
    }

    #[test]
    fn exact_target_index_marks_same_participation_without_hot_allocations() {
        let a = [profile([100; 7])];
        let c = [profile([150; 7])];
        let b1 = [profile([136; 7]), profile([137; 7])];
        let b5 = [profile([100; 7])];
        let ia = compile_g41_q29_projection_index::<0, 2>(&a).unwrap();
        let ic = compile_g41_q29_projection_index::<0, 2>(&c).unwrap();
        let ib1 = compile_g41_q29_projection_index::<0, 2>(&b1).unwrap();
        let ib5 = compile_g41_q29_projection_index::<0, 2>(&b5).unwrap();
        let targets = [G41Q29PairTarget {
            coordinates: [250; 7],
            archetype_bits: 1,
            _pad: 0,
        }];
        let index = G41Q29PairTargetIndex::compile(&targets).unwrap();
        assert_eq!(index.archetype_bits([250; 7]), Some(1));
        assert_eq!(index.archetype_bits([251; 7]), None);
        let mut bits = [[0_u64; 1]; 4];
        let (report, allocations) = tracked_allocations(|| {
            let [a_bits, b1_bits, b5_bits, c_bits] = &mut bits;
            mark_g41_q29_profile_shard_participation_from_targets::<0, 2>(
                [&a, &c],
                [&b1, &b5],
                [&ia, &ic],
                [&ib1, &ib5],
                [250, 250],
                &index,
                [a_bits, b1_bits, b5_bits, c_bits],
            )
            .unwrap()
        });
        assert_eq!(allocations, 0);
        assert_eq!(report.pair_records_examined, [1, 2, 0]);
        assert_eq!(report.matching_pair_records, [1, 2, 0]);
        assert_eq!(bits, [[1], [3], [0], [1]]);
    }

    #[test]
    fn exact_target_index_replays_every_key_through_bloom_and_collisions() {
        let targets: Vec<G41Q29PairTarget> = (0_u16..1_024)
            .map(|index| G41Q29PairTarget {
                coordinates: [index / 524, index % 524, 7, 11, 13, 17, 19],
                archetype_bits: 1 + (index % 3) as u8,
                _pad: 0,
            })
            .collect();
        let index = G41Q29PairTargetIndex::compile(&targets).unwrap();
        for target in &targets {
            assert_eq!(
                index.archetype_bits(target.coordinates),
                Some(target.archetype_bits)
            );
        }
        assert_eq!(index.archetype_bits([523; 7]), None);
    }

    #[test]
    fn shard_join_matches_small_direct_hit_and_miss() {
        let a = [profile([100; 7]), profile([101; 7])];
        let b = [profile([120; 7]), profile([123; 7])];
        let c = [profile([180; 7]), profile([177; 7])];
        let sets: [&[G41Q29ExactProfile]; 4] = [&a, &b, &c, &b];
        let ia = compile_g41_q29_projection_index::<0, 1>(&a).unwrap();
        let ib = compile_g41_q29_projection_index::<0, 1>(&b).unwrap();
        let ic = compile_g41_q29_projection_index::<0, 1>(&c).unwrap();
        let mut workspace = G41Q29ProfileShardWorkspace::new(8).unwrap();
        let hit = join_g41_q29_profile_shard::<0, 1>(
            sets,
            [&ia, &ib, &ic, &ib],
            [277, 277],
            &mut workspace,
        )
        .unwrap();
        assert_eq!(hit.hit.unwrap().sums, [523; 7]);
        let miss =
            join_g41_q29_profile_shard::<0, 1>(sets, [&ia, &ib, &ic, &ib], [0, 0], &mut workspace)
                .unwrap();
        assert!(miss.hit.is_none());
    }

    #[test]
    fn compiled_shard_hot_join_does_not_allocate() {
        let a = [profile([100; 7])];
        let b = [profile([123; 7])];
        let c = [profile([177; 7])];
        let sets: [&[G41Q29ExactProfile]; 4] = [&a, &b, &c, &b];
        let ia = compile_g41_q29_projection_index::<0, 1>(&a).unwrap();
        let ib = compile_g41_q29_projection_index::<0, 1>(&b).unwrap();
        let ic = compile_g41_q29_projection_index::<0, 1>(&c).unwrap();
        let mut workspace = G41Q29ProfileShardWorkspace::new(1).unwrap();
        let (result, allocations) = tracked_allocations(|| {
            join_g41_q29_profile_shard::<0, 1>(
                sets,
                [&ia, &ib, &ic, &ib],
                [277, 277],
                &mut workspace,
            )
        });
        assert!(result.unwrap().hit.is_some());
        assert_eq!(allocations, 0);
    }

    #[test]
    fn dual_shard_count_matches_ordered_direct_product() {
        let a = [profile([100; 7]), profile([100; 7])];
        let c = [profile([180; 7])];
        let b1 = [profile([120; 7]), profile([123; 7])];
        let b5 = [profile([121; 7]), profile([122; 7])];
        let ia = compile_g41_q29_projection_index::<0, 1>(&a).unwrap();
        let ic = compile_g41_q29_projection_index::<0, 1>(&c).unwrap();
        let ib1 = compile_g41_q29_projection_index::<0, 1>(&b1).unwrap();
        let ib5 = compile_g41_q29_projection_index::<0, 1>(&b5).unwrap();
        let mut workspace = G41Q29ProfileShardWorkspace::new(2).unwrap();
        let report = count_g41_q29_profile_shard_dual::<0, 1>(
            [&a, &c],
            [&b1, &b5],
            [&ia, &ic],
            [&ib1, &ib5],
            [280, 280],
            &mut workspace,
        )
        .unwrap();
        assert_eq!(report.left_key_entries, 2);
        assert_eq!(report.probes[0].exact_profile_quartets, 4);
        assert_eq!(report.probes[1].exact_profile_quartets, 4);
        assert_eq!(report.probes[0].sample_hit.unwrap().sums, [523; 7]);
        assert_eq!(report.probes[1].sample_hit.unwrap().sums, [523; 7]);
        let mut targets = G41Q29PairTargetWorkspace::new(4).unwrap();
        let targets_report = collect_g41_q29_pair_targets_dual::<0, 1>(
            [&b1, &b5],
            [&ib1, &ib5],
            [280, 280],
            &workspace,
            &mut targets,
        )
        .unwrap();
        assert_eq!(targets_report.b1_distinct_targets, 1);
        assert_eq!(targets_report.b5_distinct_targets, 1);
        assert_eq!(targets_report.union_distinct_targets, 1);
        let mut decoded = Vec::with_capacity(1);
        targets
            .append_targets::<0, 1>([280, 280], &mut decoded, 1)
            .unwrap();
        assert_eq!(decoded[0].coordinates, [280; 7]);
        assert_eq!(decoded[0].archetype_bits, 3);
    }

    #[test]
    fn dual_shard_hot_count_does_not_allocate() {
        let a = [profile([100; 7])];
        let c = [profile([180; 7])];
        let b = [profile([120; 7]), profile([123; 7])];
        let ia = compile_g41_q29_projection_index::<0, 1>(&a).unwrap();
        let ic = compile_g41_q29_projection_index::<0, 1>(&c).unwrap();
        let ib = compile_g41_q29_projection_index::<0, 1>(&b).unwrap();
        let mut workspace = G41Q29ProfileShardWorkspace::new(1).unwrap();
        let mut targets = G41Q29PairTargetWorkspace::new(4).unwrap();
        let (result, allocations) = tracked_allocations(|| {
            let report = count_g41_q29_profile_shard_dual::<0, 1>(
                [&a, &c],
                [&b, &b],
                [&ia, &ic],
                [&ib, &ib],
                [280, 280],
                &mut workspace,
            )?;
            let targets_report = collect_g41_q29_pair_targets_dual::<0, 1>(
                [&b, &b],
                [&ib, &ib],
                [280, 280],
                &workspace,
                &mut targets,
            )?;
            Ok::<_, G41Q29ProfileShardError>((report, targets_report))
        });
        let (report, targets_report) = result.unwrap();
        assert_eq!(report.probes[0].exact_profile_quartets, 2);
        assert_eq!(targets_report.union_distinct_targets, 1);
        assert_eq!(allocations, 0);
    }

    #[test]
    fn participation_marks_every_ordered_quartet_endpoint_without_allocating() {
        let a = [profile([100; 7]), profile([100; 7])];
        let c = [profile([180; 7])];
        let b1 = [profile([120; 7]), profile([123; 7])];
        let b5 = [profile([121; 7]), profile([122; 7])];
        let ia = compile_g41_q29_projection_index::<0, 1>(&a).unwrap();
        let ic = compile_g41_q29_projection_index::<0, 1>(&c).unwrap();
        let ib1 = compile_g41_q29_projection_index::<0, 1>(&b1).unwrap();
        let ib5 = compile_g41_q29_projection_index::<0, 1>(&b5).unwrap();
        let mut workspace = G41Q29ProfileParticipationWorkspace::new(2).unwrap();
        let mut bits = [[0_u64; 1]; 4];
        let [a_bits, b1_bits, b5_bits, c_bits] = &mut bits;
        let (result, allocations) = tracked_allocations(|| {
            mark_g41_q29_profile_shard_participation_dual::<0, 1>(
                [&a, &c],
                [&b1, &b5],
                [&ia, &ic],
                [&ib1, &ib5],
                [280, 280],
                &mut workspace,
                [a_bits, b1_bits, b5_bits, c_bits],
            )
        });
        assert_eq!(result.unwrap(), [4, 4]);
        assert_eq!(bits, [[3], [3], [3], [1]]);
        assert_eq!(allocations, 0);

        let mut streaming = G41Q29ProfileParticipationWorkspace::new_streaming(2).unwrap();
        let mut streaming_bits = [[0_u64; 1]; 4];
        let [a_bits, b1_bits, b5_bits, c_bits] = &mut streaming_bits;
        let (streamed, streaming_allocations) = tracked_allocations(|| {
            mark_g41_q29_profile_shard_participation_dual_streaming::<0, 1>(
                [&a, &c],
                [&b1, &b5],
                [&ia, &ic],
                [&ib1, &ib5],
                [280, 280],
                &mut streaming,
                [a_bits, b1_bits, b5_bits, c_bits],
            )
        });
        assert_eq!(streamed.unwrap(), [4, 4]);
        assert_eq!(streaming_bits, bits);
        assert_eq!(streaming_allocations, 0);
    }

    #[test]
    fn heterogeneous_participation_merges_repeated_keys_without_allocating() {
        let first = [profile([100; 7]), profile([100; 7])];
        let second = [profile([121; 7]), profile([121; 7])];
        let third = [profile([122; 7]), profile([122; 7])];
        let fourth = [profile([180; 7])];
        let i0 = compile_g41_q29_projection_index::<0, 1>(&first).unwrap();
        let i1 = compile_g41_q29_projection_index::<0, 1>(&second).unwrap();
        let i2 = compile_g41_q29_projection_index::<0, 1>(&third).unwrap();
        let i3 = compile_g41_q29_projection_index::<0, 1>(&fourth).unwrap();
        let mut workspace = G41Q29ProfileParticipationWorkspace::new(4).unwrap();
        let mut bits = [[0_u64; 1]; 4];
        let [first_bits, second_bits, third_bits, fourth_bits] = &mut bits;
        let (result, allocations) = tracked_allocations(|| {
            mark_g41_q29_profile_shard_participation::<0, 1>(
                [&first, &second, &third, &fourth],
                [&i0, &i1, &i2, &i3],
                [221, 221],
                &mut workspace,
                [first_bits, second_bits, third_bits, fourth_bits],
            )
        });
        assert_eq!(result.unwrap(), 8);
        assert_eq!(bits, [[3], [3], [3], [1]]);
        assert_eq!(allocations, 0);
    }
}
