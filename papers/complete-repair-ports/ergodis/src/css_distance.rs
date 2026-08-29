//! Exact bounded CSS-distance search over connected support representatives.
//!
//! A support in the kernel of the physical-check matrix decomposes into
//! connected components in the graph joining coordinates that occur in a
//! common check.  Every component is itself in the kernel.  Consequently, if
//! the support has a nonzero logical observation, at least one connected
//! component has a nonzero observation and no greater weight.  The search
//! below therefore enumerates only connected supports.

use crate::matrix::Matrix;
use serde::Serialize;
use thiserror::Error;

const MAX_COORDINATES: usize = 256;
const MAX_CHECKS: usize = 128;
const MAX_LOGICALS: usize = 64;
const SUPPORT_WORDS: usize = MAX_COORDINATES / 64;
const SYNDROME_WORDS: usize = MAX_CHECKS / 64;
const FOUR_COMPLETION_BLOOM_BITS: usize = 1 << 27;

#[derive(Debug, Clone, PartialEq, Eq, Error)]
pub enum CssDistanceError {
    #[error("CSS distance search currently supports at most 256 coordinates")]
    TooManyCoordinates,
    #[error("CSS distance search currently supports at most 128 physical checks")]
    TooManyChecks,
    #[error("CSS distance search currently supports at most 64 logical observations")]
    TooManyLogicals,
    #[error("physical and logical matrices have different coordinate counts")]
    CoordinateMismatch,
    #[error("the bounded search requires at least one coordinate and one logical observation")]
    EmptyProblem,
    #[error("anchor {anchor} is outside the coordinate range")]
    AnchorOutOfRange { anchor: u16 },
    #[error("maximum weight must be positive and no greater than the coordinate count")]
    InvalidMaximumWeight,
    #[error("incumbent support is empty, repeated, or outside the coordinate range")]
    InvalidIncumbentSupport,
    #[error("incumbent support does not have zero physical syndrome")]
    IncumbentPhysicalSyndrome,
    #[error("incumbent support has zero logical observation")]
    IncumbentLogicalObservation,
}

#[repr(C)]
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
struct PackedSupport {
    words: [u64; SUPPORT_WORDS],
}

const _: () = assert!(std::mem::size_of::<PackedSupport>() == 32);
const _: () = assert!(std::mem::align_of::<PackedSupport>() == 8);

impl PackedSupport {
    #[inline]
    fn singleton(index: usize) -> Self {
        let mut result = Self::default();
        result.insert(index);
        result
    }

    #[inline]
    fn insert(&mut self, index: usize) {
        self.words[index / 64] |= 1u64 << (index % 64);
    }

    #[inline]
    fn remove(&mut self, index: usize) {
        self.words[index / 64] &= !(1u64 << (index % 64));
    }

    #[inline]
    fn contains(&self, index: usize) -> bool {
        self.words[index / 64] & (1u64 << (index % 64)) != 0
    }

    #[inline]
    fn union_assign(&mut self, right: Self) {
        for (left, right) in self.words.iter_mut().zip(right.words) {
            *left |= right;
        }
    }

    #[inline]
    fn difference_assign(&mut self, right: Self) {
        for (left, right) in self.words.iter_mut().zip(right.words) {
            *left &= !right;
        }
    }

    #[inline]
    fn pop_lowest(&mut self) -> Option<usize> {
        for (word_index, word) in self.words.iter_mut().enumerate() {
            if *word != 0 {
                let bit = word.trailing_zeros() as usize;
                *word &= *word - 1;
                return Some(64 * word_index + bit);
            }
        }
        None
    }
}

#[repr(C)]
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
struct PackedSyndrome {
    words: [u64; SYNDROME_WORDS],
}

const _: () = assert!(std::mem::size_of::<PackedSyndrome>() == 16);
const _: () = assert!(std::mem::align_of::<PackedSyndrome>() == 8);

impl PackedSyndrome {
    #[inline]
    fn toggle(&mut self, right: Self) {
        self.words[0] ^= right.words[0];
        self.words[1] ^= right.words[1];
    }

    #[inline]
    fn is_zero(&self) -> bool {
        self.words[0] == 0 && self.words[1] == 0
    }

    #[inline]
    fn weight(&self) -> u32 {
        self.words[0].count_ones() + self.words[1].count_ones()
    }

    #[inline]
    fn key(&self) -> u128 {
        u128::from(self.words[0]) | (u128::from(self.words[1]) << 64)
    }
}

#[repr(C)]
#[derive(Clone, Copy, Debug, Default)]
struct PackedColumn {
    syndrome: PackedSyndrome,
    logical: u64,
}

const _: () = assert!(std::mem::size_of::<PackedColumn>() == 24);
const _: () = assert!(std::mem::align_of::<PackedColumn>() == 8);

#[repr(C)]
#[derive(Clone, Debug)]
struct CompletionBloom {
    words: Box<[u64]>,
    bit_mask: u64,
}

impl CompletionBloom {
    fn new(item_count: usize) -> Self {
        let bit_count = item_count
            .saturating_mul(8)
            .next_power_of_two()
            .clamp(64, FOUR_COMPLETION_BLOOM_BITS);
        Self {
            words: vec![0; bit_count / 64].into_boxed_slice(),
            bit_mask: bit_count as u64 - 1,
        }
    }

    #[inline]
    fn mix(mut value: u64) -> u64 {
        value ^= value >> 30;
        value = value.wrapping_mul(0xbf58_476d_1ce4_e5b9);
        value ^= value >> 27;
        value = value.wrapping_mul(0x94d0_49bb_1331_11eb);
        value ^ (value >> 31)
    }

    #[inline]
    fn hashes(&self, key: u128) -> [usize; 3] {
        let low = key as u64;
        let high = (key >> 64) as u64;
        let first = self.first_hash(key) as u64;
        let second = Self::mix(high ^ low.rotate_left(41)) | 1;
        [
            (first & self.bit_mask) as usize,
            (first.wrapping_add(second) & self.bit_mask) as usize,
            (first.wrapping_add(second.wrapping_mul(2)) & self.bit_mask) as usize,
        ]
    }

    #[inline]
    fn first_hash(&self, key: u128) -> usize {
        let low = key as u64;
        let high = (key >> 64) as u64;
        let product = (low ^ high.rotate_left(17)).wrapping_mul(0x9e37_79b9_7f4a_7c15);
        ((product ^ (product >> 32)) & self.bit_mask) as usize
    }

    #[inline]
    fn insert_one(&mut self, key: u128) {
        let bit = self.first_hash(key);
        self.words[bit / 64] |= 1u64 << (bit % 64);
    }

    #[inline]
    fn insert_three(&mut self, key: u128) {
        for bit in self.hashes(key) {
            self.words[bit / 64] |= 1u64 << (bit % 64);
        }
    }

    #[inline]
    fn contains_one(&self, key: u128) -> bool {
        let bit = self.first_hash(key);
        self.words[bit / 64] & (1u64 << (bit % 64)) != 0
    }

    #[inline]
    fn contains_three(&self, key: u128) -> bool {
        self.hashes(key)
            .into_iter()
            .all(|bit| self.words[bit / 64] & (1u64 << (bit % 64)) != 0)
    }
}

#[derive(Clone, Debug)]
pub struct CompiledCssDistance {
    columns: Box<[PackedColumn]>,
    neighbors: Box<[PackedSupport]>,
    short_completion_syndromes: [Box<[u128]>; 2],
    three_completion_bloom: CompletionBloom,
    four_completion_bloom: CompletionBloom,
    coordinate_count: u16,
    check_count: u16,
    logical_count: u8,
    maximum_column_check_weight: u8,
    kernel_weights_even: bool,
}

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq, Serialize)]
pub struct ConnectedSearchStats {
    pub candidates: u64,
    pub connected_supports: u64,
    pub exclusive_extensions: u64,
    pub syndrome_bound_prunes: u64,
    pub four_completion_prunes: u64,
    pub kernel_supports: u64,
    pub nontrivial_supports: u64,
    pub maximum_depth: u16,
}

#[derive(Clone, Debug, PartialEq, Eq, Serialize)]
pub struct BoundedCssDistanceResult {
    /// The minimum found weight, or `None` when no admissible support exists at
    /// or below the requested maximum.
    pub distance: Option<u16>,
    pub witness: Box<[u16]>,
    pub searched_maximum_weight: u16,
    pub stats: ConnectedSearchStats,
}

impl CompiledCssDistance {
    pub fn compile(physical: &Matrix, logical: &Matrix) -> Result<Self, CssDistanceError> {
        let coordinate_count = physical.cols();
        if coordinate_count > MAX_COORDINATES {
            return Err(CssDistanceError::TooManyCoordinates);
        }
        if physical.rows() > MAX_CHECKS {
            return Err(CssDistanceError::TooManyChecks);
        }
        if logical.rows() > MAX_LOGICALS {
            return Err(CssDistanceError::TooManyLogicals);
        }
        if logical.cols() != coordinate_count {
            return Err(CssDistanceError::CoordinateMismatch);
        }
        if coordinate_count == 0 || logical.rows() == 0 {
            return Err(CssDistanceError::EmptyProblem);
        }

        let mut columns = vec![PackedColumn::default(); coordinate_count];
        let mut neighbors = vec![PackedSupport::default(); coordinate_count];
        let mut maximum_column_check_weight = 0u8;
        let mut kernel_weights_even = true;
        for check in 0..physical.rows() {
            let row = physical.row(check);
            let mut support = PackedSupport::default();
            for (coordinate, &entry) in row.iter().enumerate() {
                if entry != 0 {
                    support.insert(coordinate);
                    columns[coordinate].syndrome.words[check / 64] |= 1u64 << (check % 64);
                }
            }
            for (coordinate, &entry) in row.iter().enumerate() {
                if entry != 0 {
                    neighbors[coordinate].union_assign(support);
                }
            }
        }
        for logical_row in 0..logical.rows() {
            for (coordinate, &entry) in logical.row(logical_row).iter().enumerate() {
                if entry != 0 {
                    columns[coordinate].logical |= 1u64 << logical_row;
                }
            }
        }
        for (coordinate, column) in columns.iter().enumerate() {
            neighbors[coordinate].remove(coordinate);
            maximum_column_check_weight = maximum_column_check_weight.max(
                u8::try_from(column.syndrome.weight()).expect("check count is bounded by 128"),
            );
            kernel_weights_even &= column.syndrome.weight() & 1 == 1;
        }
        let mut short_completion_syndromes = [Vec::new(), Vec::new(), Vec::new()];
        short_completion_syndromes[0].reserve(columns.len());
        short_completion_syndromes[1].reserve(
            columns
                .len()
                .saturating_mul(columns.len().saturating_sub(1))
                / 2,
        );
        short_completion_syndromes[2].reserve(
            columns
                .len()
                .saturating_mul(columns.len().saturating_sub(1))
                .saturating_mul(columns.len().saturating_sub(2))
                / 6,
        );
        for left in 0..columns.len() {
            let left_key = columns[left].syndrome.key();
            short_completion_syndromes[0].push(left_key);
            for middle in left + 1..columns.len() {
                let pair_key = left_key ^ columns[middle].syndrome.key();
                short_completion_syndromes[1].push(pair_key);
                for right in columns.iter().skip(middle + 1) {
                    short_completion_syndromes[2].push(pair_key ^ right.syndrome.key());
                }
            }
        }
        for syndromes in &mut short_completion_syndromes {
            syndromes.sort_unstable();
            syndromes.dedup();
        }
        let short_count = short_completion_syndromes
            .iter()
            .map(Vec::len)
            .sum::<usize>();
        let mut three_completion_bloom = CompletionBloom::new(short_count);
        for syndromes in &short_completion_syndromes {
            for &syndrome in syndromes {
                three_completion_bloom.insert_three(syndrome);
            }
        }
        let quadruple_count = columns
            .len()
            .saturating_mul(columns.len().saturating_sub(1))
            .saturating_mul(columns.len().saturating_sub(2))
            .saturating_mul(columns.len().saturating_sub(3))
            / 24;
        let mut four_completion_bloom = CompletionBloom::new(quadruple_count);
        for syndromes in &short_completion_syndromes {
            for &syndrome in syndromes {
                four_completion_bloom.insert_one(syndrome);
            }
        }
        for first in 0..columns.len() {
            let first_key = columns[first].syndrome.key();
            for second in first + 1..columns.len() {
                let pair_key = first_key ^ columns[second].syndrome.key();
                for third in second + 1..columns.len() {
                    let triple_key = pair_key ^ columns[third].syndrome.key();
                    for fourth in columns.iter().skip(third + 1) {
                        four_completion_bloom.insert_one(triple_key ^ fourth.syndrome.key());
                    }
                }
            }
        }
        let [one_completion, two_completion, _three_completion] = short_completion_syndromes;
        let short_completion_syndromes = [
            one_completion.into_boxed_slice(),
            two_completion.into_boxed_slice(),
        ];

        Ok(Self {
            columns: columns.into_boxed_slice(),
            neighbors: neighbors.into_boxed_slice(),
            short_completion_syndromes,
            three_completion_bloom,
            four_completion_bloom,
            coordinate_count: coordinate_count as u16,
            check_count: physical.rows() as u16,
            logical_count: logical.rows() as u8,
            maximum_column_check_weight,
            kernel_weights_even,
        })
    }

    #[inline]
    pub fn coordinate_count(&self) -> usize {
        self.coordinate_count as usize
    }

    #[inline]
    pub fn check_count(&self) -> usize {
        self.check_count as usize
    }

    #[inline]
    pub fn logical_count(&self) -> usize {
        self.logical_count as usize
    }

    #[inline]
    fn syndrome_completion_lower_bound(&self, syndrome: PackedSyndrome) -> u16 {
        let degree = u32::from(self.maximum_column_check_weight);
        if degree == 0 {
            return u16::from(!syndrome.is_zero()) * u16::MAX;
        }
        syndrome.weight().div_ceil(degree) as u16
    }

    #[inline]
    fn has_short_completion(&self, syndrome: PackedSyndrome, additions: u16) -> bool {
        if syndrome.is_zero() {
            return true;
        }
        let key = syndrome.key();
        if additions >= 3 {
            return self.three_completion_bloom.contains_three(key);
        }
        self.short_completion_syndromes
            .iter()
            .take(usize::from(additions))
            .any(|syndromes| syndromes.binary_search(&key).is_ok())
    }

    #[inline]
    fn may_have_four_completion(&self, syndrome: PackedSyndrome) -> bool {
        syndrome.is_zero() || self.four_completion_bloom.contains_one(syndrome.key())
    }

    /// Exhaustively search connected supports containing one of `anchors`.
    ///
    /// This is globally sufficient when the anchors cover the coordinate
    /// orbits of a verified symmetry action preserving both the physical
    /// kernel and logical-zero subspace. Passing every coordinate is always a
    /// valid, symmetry-free control.
    pub fn search_bounded(
        &self,
        anchors: &[u16],
        maximum_weight: u16,
    ) -> Result<BoundedCssDistanceResult, CssDistanceError> {
        if maximum_weight == 0 || usize::from(maximum_weight) > self.coordinate_count() {
            return Err(CssDistanceError::InvalidMaximumWeight);
        }
        for &anchor in anchors {
            if usize::from(anchor) >= self.coordinate_count() {
                return Err(CssDistanceError::AnchorOutOfRange { anchor });
            }
        }

        let searched_maximum_weight = if self.kernel_weights_even && maximum_weight & 1 == 1 {
            maximum_weight - 1
        } else {
            maximum_weight
        };
        if searched_maximum_weight == 0 {
            return Ok(BoundedCssDistanceResult {
                distance: None,
                witness: Box::default(),
                searched_maximum_weight,
                stats: ConnectedSearchStats::default(),
            });
        }
        let frame_count = usize::from(searched_maximum_weight);
        let mut supports = vec![PackedSupport::default(); frame_count];
        let mut boundaries = vec![PackedSupport::default(); frame_count];
        let mut candidates = vec![PackedSupport::default(); frame_count];
        let mut syndromes = vec![PackedSyndrome::default(); frame_count];
        let mut logicals = vec![0u64; frame_count];
        let mut best_weight = searched_maximum_weight.saturating_add(1);
        let mut best_support = PackedSupport::default();
        let mut stats = ConnectedSearchStats::default();

        for &anchor in anchors {
            let root = usize::from(anchor);
            supports[0] = PackedSupport::singleton(root);
            boundaries[0] = self.neighbors[root];
            candidates[0] = boundaries[0];
            syndromes[0] = self.columns[root].syndrome;
            logicals[0] = self.columns[root].logical;
            stats.connected_supports += 1;
            stats.maximum_depth = stats.maximum_depth.max(1);
            if syndromes[0].is_zero() {
                stats.kernel_supports += 1;
                if logicals[0] != 0 {
                    stats.nontrivial_supports += 1;
                    if best_weight > 1 {
                        best_weight = 1;
                        best_support = supports[0];
                    }
                }
            }
            if best_weight == 1 {
                break;
            }
            let mut depth = 0usize;

            loop {
                let Some(added) = candidates[depth].pop_lowest() else {
                    if depth == 0 {
                        break;
                    }
                    depth -= 1;
                    continue;
                };
                stats.candidates += 1;
                let child_depth = depth + 1;
                let child_weight = (child_depth + 1) as u16;
                let mut child_support = supports[depth];
                child_support.insert(added);
                stats.connected_supports += 1;
                stats.maximum_depth = stats.maximum_depth.max(child_weight);
                let mut child_syndrome = syndromes[depth];
                child_syndrome.toggle(self.columns[added].syndrome);
                let child_logical = logicals[depth] ^ self.columns[added].logical;
                if child_syndrome.is_zero() {
                    stats.kernel_supports += 1;
                    if child_logical != 0 {
                        stats.nontrivial_supports += 1;
                        if child_weight < best_weight {
                            best_weight = child_weight;
                            best_support = child_support;
                        }
                    }
                }
                let improvement_budget = best_weight.saturating_sub(child_weight + 1);
                let cheap_bound = self.syndrome_completion_lower_bound(child_syndrome);
                let four_completion_reject =
                    improvement_budget == 4 && !self.may_have_four_completion(child_syndrome);
                if child_weight >= searched_maximum_weight
                    || cheap_bound > improvement_budget
                    || (improvement_budget <= 3
                        && !self.has_short_completion(child_syndrome, improvement_budget))
                    || four_completion_reject
                {
                    stats.syndrome_bound_prunes += 1;
                    stats.four_completion_prunes += u64::from(four_completion_reject);
                    continue;
                }

                supports[child_depth] = child_support;
                syndromes[child_depth] = child_syndrome;
                logicals[child_depth] = child_logical;
                let mut exclusive = self.neighbors[added];
                exclusive.difference_assign(boundaries[depth]);
                exclusive.difference_assign(child_support);
                let mut child_boundary = boundaries[depth];
                child_boundary.union_assign(self.neighbors[added]);
                child_boundary.difference_assign(child_support);
                boundaries[child_depth] = child_boundary;
                let mut child_candidates = candidates[depth];
                child_candidates.union_assign(exclusive);
                stats.exclusive_extensions += 1;
                candidates[child_depth] = child_candidates;
                depth = child_depth;
            }
        }

        let witness = if best_weight <= searched_maximum_weight {
            let mut witness = Vec::with_capacity(best_weight as usize);
            for coordinate in 0..self.coordinate_count() {
                if best_support.contains(coordinate) {
                    witness.push(coordinate as u16);
                }
            }
            witness.into_boxed_slice()
        } else {
            Box::default()
        };
        Ok(BoundedCssDistanceResult {
            distance: (best_weight <= searched_maximum_weight).then_some(best_weight),
            witness,
            searched_maximum_weight,
            stats,
        })
    }

    /// Replay an incumbent and close every strictly smaller weight.
    pub fn certify_incumbent(
        &self,
        anchors: &[u16],
        incumbent: &[u16],
    ) -> Result<BoundedCssDistanceResult, CssDistanceError> {
        if incumbent.is_empty() || incumbent.len() > self.coordinate_count() {
            return Err(CssDistanceError::InvalidIncumbentSupport);
        }
        let mut support = PackedSupport::default();
        let mut syndrome = PackedSyndrome::default();
        let mut logical = 0u64;
        for &coordinate in incumbent {
            let coordinate = usize::from(coordinate);
            if coordinate >= self.coordinate_count() || support.contains(coordinate) {
                return Err(CssDistanceError::InvalidIncumbentSupport);
            }
            support.insert(coordinate);
            syndrome.toggle(self.columns[coordinate].syndrome);
            logical ^= self.columns[coordinate].logical;
        }
        if !syndrome.is_zero() {
            return Err(CssDistanceError::IncumbentPhysicalSyndrome);
        }
        if logical == 0 {
            return Err(CssDistanceError::IncumbentLogicalObservation);
        }
        if incumbent.len() == 1 {
            return Ok(BoundedCssDistanceResult {
                distance: Some(1),
                witness: incumbent.to_vec().into_boxed_slice(),
                searched_maximum_weight: 0,
                stats: ConnectedSearchStats::default(),
            });
        }

        let mut result = self.search_bounded(anchors, incumbent.len() as u16 - 1)?;
        if result.distance.is_none() {
            result.distance = Some(incumbent.len() as u16);
            result.witness = incumbent.to_vec().into_boxed_slice();
        }
        Ok(result)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn brute_force(physical: &Matrix, logical: &Matrix, maximum: u16) -> Option<u16> {
        let n = physical.cols();
        (1usize..1usize << n)
            .filter_map(|support| {
                let weight = support.count_ones() as u16;
                if weight > maximum {
                    return None;
                }
                let physical_zero = (0..physical.rows()).all(|row| {
                    (0..n)
                        .filter(|&column| support & (1usize << column) != 0)
                        .map(|column| physical.row(row)[column])
                        .fold(0, |left, right| left ^ right)
                        == 0
                });
                let logical_nonzero = (0..logical.rows()).any(|row| {
                    (0..n)
                        .filter(|&column| support & (1usize << column) != 0)
                        .map(|column| logical.row(row)[column])
                        .fold(0, |left, right| left ^ right)
                        != 0
                });
                (physical_zero && logical_nonzero).then_some(weight)
            })
            .min()
    }

    #[test]
    fn connected_search_matches_all_small_binary_problems() {
        for physical_bits in 0u16..1 << 8 {
            let physical_data = (0..8)
                .map(|bit| ((physical_bits >> bit) & 1) as u8)
                .collect::<Vec<_>>();
            let physical = Matrix::new::<2>(2, 4, physical_data).unwrap();
            for logical_bits in 1u8..1 << 4 {
                let logical = Matrix::new::<2>(
                    1,
                    4,
                    (0..4)
                        .map(|bit| (logical_bits >> bit) & 1)
                        .collect::<Vec<_>>(),
                )
                .unwrap();
                let compiled = CompiledCssDistance::compile(&physical, &logical).unwrap();
                let result = compiled.search_bounded(&[0, 1, 2, 3], 4).unwrap();
                assert_eq!(result.distance, brute_force(&physical, &logical, 4));
            }
        }
    }

    #[test]
    fn bounded_search_reports_a_replayable_witness() {
        let physical = Matrix::new::<2>(2, 5, vec![1, 1, 0, 0, 0, 0, 1, 1, 1, 0]).unwrap();
        let logical = Matrix::new::<2>(1, 5, vec![1, 0, 1, 0, 1]).unwrap();
        let compiled = CompiledCssDistance::compile(&physical, &logical).unwrap();
        let answer = compiled.search_bounded(&[0, 1, 2, 3, 4], 5).unwrap();
        assert_eq!(answer.distance, Some(1));
        assert_eq!(&*answer.witness, &[4]);
    }
}
