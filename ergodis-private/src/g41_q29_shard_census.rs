//! Exact two-coordinate pair-shard workload census using 2D NTT convolution.

use serde::Serialize;
use thiserror::Error;

use crate::g41_q29_exact_tablebase::G41Q29ExactProfile;

const TARGET: usize = 523;
const NTT_SIDE: usize = 2048;
const CELLS: usize = NTT_SIDE * NTT_SIDE;
const PRIME_FIRST: u32 = 998_244_353;
const PRIME_SECOND: u32 = 1_004_535_809;
const PRIMITIVE_ROOT: u32 = 3;

#[derive(Clone, Debug, Error, PartialEq, Eq)]
pub enum G41Q29ShardCensusError {
    #[error("q29 shard census semantics are invalid")]
    SemanticMismatch,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q29PairShardCensusReport {
    pub coordinates: [u8; 2],
    pub first_profiles: u32,
    pub second_profiles: u32,
    pub relevant_pairs: u64,
    pub nonempty_shards: u32,
    pub maximum_shard_pairs: u64,
    pub maximum_shard_sum: [u16; 2],
    pub shards_above_budget: u32,
    pub pair_budget: u64,
    pub workspace_bytes: u64,
    pub provenance: &'static str,
}

#[inline(always)]
fn multiply(left: u32, right: u32, modulus: u32) -> u32 {
    (u64::from(left) * u64::from(right) % u64::from(modulus)) as u32
}

fn power(mut base: u32, mut exponent: u64, modulus: u32) -> u32 {
    let mut output = 1_u32;
    while exponent != 0 {
        if exponent & 1 != 0 {
            output = multiply(output, base, modulus);
        }
        base = multiply(base, base, modulus);
        exponent >>= 1;
    }
    output
}

fn ntt_strided(
    values: &mut [u32],
    start: usize,
    stride: usize,
    length: usize,
    invert: bool,
    modulus: u32,
) {
    let mut target = 0_usize;
    for source in 1..length {
        let mut bit = length >> 1;
        while target & bit != 0 {
            target ^= bit;
            bit >>= 1;
        }
        target ^= bit;
        if source < target {
            values.swap(start + source * stride, start + target * stride);
        }
    }
    let mut width = 2_usize;
    while width <= length {
        let mut root = power(
            PRIMITIVE_ROOT,
            u64::from(modulus - 1) / width as u64,
            modulus,
        );
        if invert {
            root = power(root, u64::from(modulus - 2), modulus);
        }
        for offset in (0..length).step_by(width) {
            let mut twiddle = 1_u32;
            for index in 0..width / 2 {
                let first = start + (offset + index) * stride;
                let second = start + (offset + index + width / 2) * stride;
                let left = values[first];
                let right = multiply(values[second], twiddle, modulus);
                values[first] = if left >= modulus - right {
                    left - (modulus - right)
                } else {
                    left + right
                };
                values[second] = if left >= right {
                    left - right
                } else {
                    left + (modulus - right)
                };
                twiddle = multiply(twiddle, root, modulus);
            }
        }
        width <<= 1;
    }
    if invert {
        let inverse = power(length as u32, u64::from(modulus - 2), modulus);
        for index in 0..length {
            let slot = start + index * stride;
            values[slot] = multiply(values[slot], inverse, modulus);
        }
    }
}

fn ntt_2d(values: &mut [u32], side: usize, invert: bool, modulus: u32) {
    for row in 0..side {
        ntt_strided(values, row * side, 1, side, invert, modulus);
    }
    for column in 0..side {
        ntt_strided(values, column, side, side, invert, modulus);
    }
}

fn convolution_mod(
    first: &[G41Q29ExactProfile],
    second: &[G41Q29ExactProfile],
    coordinates: [usize; 2],
    modulus: u32,
) -> Box<[u32]> {
    let mut left = vec![0_u32; CELLS].into_boxed_slice();
    let mut right = vec![0_u32; CELLS].into_boxed_slice();
    for profile in first {
        let row = usize::from(profile.coordinate(coordinates[0]));
        let column = usize::from(profile.coordinate(coordinates[1]));
        let slot = row * NTT_SIDE + column;
        left[slot] = if left[slot] + 1 == modulus {
            0
        } else {
            left[slot] + 1
        };
    }
    for profile in second {
        let row = usize::from(profile.coordinate(coordinates[0]));
        let column = usize::from(profile.coordinate(coordinates[1]));
        let slot = row * NTT_SIDE + column;
        right[slot] = if right[slot] + 1 == modulus {
            0
        } else {
            right[slot] + 1
        };
    }
    ntt_2d(&mut left, NTT_SIDE, false, modulus);
    ntt_2d(&mut right, NTT_SIDE, false, modulus);
    for index in 0..CELLS {
        left[index] = multiply(left[index], right[index], modulus);
    }
    drop(right);
    ntt_2d(&mut left, NTT_SIDE, true, modulus);
    left
}

fn exact_low_quadrant(
    first: &[G41Q29ExactProfile],
    second: &[G41Q29ExactProfile],
    coordinates: [usize; 2],
) -> Box<[u64]> {
    let first_residue = convolution_mod(first, second, coordinates, PRIME_FIRST);
    let second_residue = convolution_mod(first, second, coordinates, PRIME_SECOND);
    let inverse = power(
        PRIME_FIRST % PRIME_SECOND,
        u64::from(PRIME_SECOND - 2),
        PRIME_SECOND,
    );
    let mut output = vec![0_u64; (TARGET + 1) * (TARGET + 1)].into_boxed_slice();
    for row in 0..=TARGET {
        for column in 0..=TARGET {
            let source = row * NTT_SIDE + column;
            let first = first_residue[source];
            let second = second_residue[source];
            let delta = if second >= first {
                second - first
            } else {
                second + (PRIME_SECOND - first)
            };
            let factor = multiply(delta, inverse, PRIME_SECOND);
            output[row * (TARGET + 1) + column] =
                u64::from(first) + u64::from(PRIME_FIRST) * u64::from(factor);
        }
    }
    output
}

pub fn census_g41_q29_pair_shards(
    first: &[G41Q29ExactProfile],
    second: &[G41Q29ExactProfile],
    coordinates: [usize; 2],
    pair_budget: u64,
) -> Result<G41Q29PairShardCensusReport, G41Q29ShardCensusError> {
    if first.len() > u32::MAX as usize
        || second.len() > u32::MAX as usize
        || coordinates[0] >= 7
        || coordinates[1] >= 7
        || coordinates[0] == coordinates[1]
        || pair_budget == 0
        || (first.len() as u128) * (second.len() as u128)
            >= u128::from(PRIME_FIRST) * u128::from(PRIME_SECOND)
    {
        return Err(G41Q29ShardCensusError::SemanticMismatch);
    }
    let counts = exact_low_quadrant(first, second, coordinates);
    let mut relevant_pairs = 0_u64;
    let mut nonempty_shards = 0_u32;
    let mut maximum_shard_pairs = 0_u64;
    let mut maximum_shard_sum = [0_u16; 2];
    let mut shards_above_budget = 0_u32;
    for (index, &count) in counts.iter().enumerate() {
        relevant_pairs = relevant_pairs
            .checked_add(count)
            .ok_or(G41Q29ShardCensusError::SemanticMismatch)?;
        nonempty_shards += u32::from(count != 0);
        if count > maximum_shard_pairs {
            maximum_shard_pairs = count;
            maximum_shard_sum = [(index / (TARGET + 1)) as u16, (index % (TARGET + 1)) as u16];
        }
        shards_above_budget += u32::from(count > pair_budget);
    }
    Ok(G41Q29PairShardCensusReport {
        coordinates: coordinates.map(|coordinate| coordinate as u8),
        first_profiles: first.len() as u32,
        second_profiles: second.len() as u32,
        relevant_pairs,
        nonempty_shards,
        maximum_shard_pairs,
        maximum_shard_sum,
        shards_above_budget,
        pair_budget,
        workspace_bytes: (3 * CELLS * std::mem::size_of::<u32>()
            + (TARGET + 1) * (TARGET + 1) * std::mem::size_of::<u64>())
            as u64,
        provenance: "exact two-prime 2D NTT convolution of the selected q29 profile coordinates; CRT modulus exceeds every possible profile-pair count, zero padding prevents cyclic aliasing, and the low 524x524 quadrant gives every raw pair-shard cardinality without generating pair keys",
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn strided_ntt_round_trips_small_rows_and_columns() {
        for modulus in [PRIME_FIRST, PRIME_SECOND] {
            let mut values: Vec<u32> = (0..64).map(|value| value % modulus).collect();
            let original = values.clone();
            ntt_2d(&mut values, 8, false, modulus);
            ntt_2d(&mut values, 8, true, modulus);
            assert_eq!(values, original);
        }
    }

    #[test]
    fn small_cyclic_convolution_matches_direct_oracle() {
        for modulus in [PRIME_FIRST, PRIME_SECOND] {
            let mut left = vec![0_u32; 64];
            let mut right = vec![0_u32; 64];
            left[1 * 8 + 2] = 3;
            left[4 * 8 + 7] = 5;
            right[2 * 8 + 3] = 7;
            right[6 * 8 + 4] = 11;
            ntt_2d(&mut left, 8, false, modulus);
            ntt_2d(&mut right, 8, false, modulus);
            for index in 0..64 {
                left[index] = multiply(left[index], right[index], modulus);
            }
            ntt_2d(&mut left, 8, true, modulus);
            let mut direct = vec![0_u32; 64];
            for (first_row, first_column, first_value) in [(1, 2, 3), (4, 7, 5)] {
                for (second_row, second_column, second_value) in [(2, 3, 7), (6, 4, 11)] {
                    let row = (first_row + second_row) % 8;
                    let column = (first_column + second_column) % 8;
                    direct[row * 8 + column] += first_value * second_value;
                }
            }
            assert_eq!(left, direct);
        }
    }
}
