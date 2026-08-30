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
use sha2::{Digest, Sha256};
use std::io::{self, Read, Write};
#[cfg(feature = "parallel")]
use std::sync::atomic::{AtomicU16, Ordering};
use thiserror::Error;

const MAX_COORDINATES: usize = 256;
const MAX_CHECKS: usize = 128;
const MAX_LOGICALS: usize = 64;
const SUPPORT_WORDS: usize = MAX_COORDINATES / 64;
const SYNDROME_WORDS: usize = MAX_CHECKS / 64;
const WIDE_SUPPORT_WORDS: usize = 5;
const EXTRA_WIDE_SUPPORT_WORDS: usize = 6;
const LARGE_SUPPORT_WORDS: usize = 13;
const HUGE_SUPPORT_WORDS: usize = 24;
const COLOSSAL_SUPPORT_WORDS: usize = 28;
const WIDE_SYNDROME_WORDS: usize = 3;
const LARGE_SYNDROME_WORDS: usize = 6;
const HUGE_SYNDROME_WORDS: usize = 11;
const COLOSSAL_SYNDROME_WORDS: usize = 13;
const HUGE_LOGICAL_WORDS: usize = 4;
const FOUR_COMPLETION_BLOOM_BITS: usize = 1 << 27;
const ARTIFACT_MAGIC: &[u8; 8] = b"ERGOCSS1";
const ARTIFACT_VERSION: u16 = 1;
const WIDE_ARTIFACT_MAGIC: &[u8; 8] = b"ERGOCSW1";
const WIDE_ARTIFACT_VERSION: u16 = 1;
const EXTRA_WIDE_ARTIFACT_MAGIC: &[u8; 8] = b"ERGOCSX1";
const EXTRA_WIDE_ARTIFACT_VERSION: u16 = 1;
const LARGE_ARTIFACT_MAGIC: &[u8; 8] = b"ERGOCSL1";
const LARGE_ARTIFACT_VERSION: u16 = 2;
const HUGE_ARTIFACT_MAGIC: &[u8; 8] = b"ERGOCSH1";
const HUGE_ARTIFACT_VERSION: u16 = 1;
const COLOSSAL_ARTIFACT_MAGIC: &[u8; 8] = b"ERGOCSC1";
const COLOSSAL_ARTIFACT_VERSION: u16 = 1;
const MAX_ARTIFACT_BLOOM_WORDS: usize = FOUR_COMPLETION_BLOOM_BITS / 64;

fn wide_artifact_identity<const SUPPORT_WORDS: usize, const CHECK_WORDS: usize>(
) -> (&'static [u8; 8], u16) {
    match (SUPPORT_WORDS, CHECK_WORDS) {
        (WIDE_SUPPORT_WORDS, WIDE_SYNDROME_WORDS) => (WIDE_ARTIFACT_MAGIC, WIDE_ARTIFACT_VERSION),
        (EXTRA_WIDE_SUPPORT_WORDS, WIDE_SYNDROME_WORDS) => {
            (EXTRA_WIDE_ARTIFACT_MAGIC, EXTRA_WIDE_ARTIFACT_VERSION)
        }
        (LARGE_SUPPORT_WORDS, LARGE_SYNDROME_WORDS) => {
            (LARGE_ARTIFACT_MAGIC, LARGE_ARTIFACT_VERSION)
        }
        (HUGE_SUPPORT_WORDS, HUGE_SYNDROME_WORDS) => (HUGE_ARTIFACT_MAGIC, HUGE_ARTIFACT_VERSION),
        (COLOSSAL_SUPPORT_WORDS, COLOSSAL_SYNDROME_WORDS) => {
            (COLOSSAL_ARTIFACT_MAGIC, COLOSSAL_ARTIFACT_VERSION)
        }
        _ => unreachable!("unsupported fixed support width"),
    }
}

#[derive(Debug, Clone, PartialEq, Eq, Error)]
pub enum CssDistanceError {
    #[error("CSS distance search currently supports at most 256 coordinates")]
    TooManyCoordinates,
    #[error("CSS distance search currently supports at most 128 physical checks")]
    TooManyChecks,
    #[error("CSS distance search exceeds this backend's logical-observation limit")]
    TooManyLogicals,
    #[error("physical and logical matrices have different coordinate counts")]
    CoordinateMismatch,
    #[error("the bounded search requires at least one coordinate and one logical observation")]
    EmptyProblem,
    #[error("anchor {anchor} is outside the coordinate range")]
    AnchorOutOfRange { anchor: u16 },
    #[error("maximum weight must be positive and no greater than the coordinate count")]
    InvalidMaximumWeight,
    #[error("parallel bound-pulse interval must be zero or a power of two")]
    InvalidPulseInterval,
    #[error("incumbent support is empty, repeated, or outside the coordinate range")]
    InvalidIncumbentSupport,
    #[error("incumbent support does not have zero physical syndrome")]
    IncumbentPhysicalSyndrome,
    #[error("incumbent support has zero logical observation")]
    IncumbentLogicalObservation,
}

#[derive(Debug, Error)]
pub enum CssDistanceArtifactError {
    #[error(transparent)]
    Io(#[from] io::Error),
    #[error("compiled CSS artifact has an invalid magic or version")]
    Format,
    #[error("compiled CSS artifact does not match the supplied matrices")]
    SourceMismatch,
    #[error("compiled CSS artifact has invalid dimensions or section lengths")]
    Shape,
    #[error("compiled CSS artifact payload checksum failed")]
    Checksum,
    #[error("compiled CSS artifact contains trailing bytes")]
    TrailingBytes,
    #[error(transparent)]
    Problem(#[from] CssDistanceError),
}

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct PackedSupport<const WORDS: usize = SUPPORT_WORDS> {
    words: [u64; WORDS],
}

impl<const WORDS: usize> Default for PackedSupport<WORDS> {
    #[inline]
    fn default() -> Self {
        Self { words: [0; WORDS] }
    }
}

const _: () = assert!(std::mem::size_of::<PackedSupport>() == 32);
const _: () = assert!(std::mem::align_of::<PackedSupport>() == 8);

impl<const WORDS: usize> PackedSupport<WORDS> {
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
    fn is_empty(&self) -> bool {
        self.words.iter().all(|&word| word == 0)
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
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct PackedSyndrome<const WORDS: usize = SYNDROME_WORDS> {
    words: [u64; WORDS],
}

impl<const WORDS: usize> Default for PackedSyndrome<WORDS> {
    #[inline]
    fn default() -> Self {
        Self { words: [0; WORDS] }
    }
}

const _: () = assert!(std::mem::size_of::<PackedSyndrome>() == 16);
const _: () = assert!(std::mem::align_of::<PackedSyndrome>() == 8);

impl PackedSyndrome<2> {
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

trait WideSyndrome: Copy + Default {
    fn toggle(&mut self, right: Self);
    fn is_zero(&self) -> bool;
    fn weight(&self) -> u32;
    fn difference_assign(&mut self, right: Self);
    fn union_assign(&mut self, right: Self);
    fn pop_lowest(&mut self) -> Option<usize>;
}

impl WideSyndrome for PackedSyndrome<3> {
    #[inline]
    fn toggle(&mut self, right: Self) {
        self.words[0] ^= right.words[0];
        self.words[1] ^= right.words[1];
        self.words[2] ^= right.words[2];
    }

    #[inline]
    fn is_zero(&self) -> bool {
        self.words[0] == 0 && self.words[1] == 0 && self.words[2] == 0
    }

    #[inline]
    fn weight(&self) -> u32 {
        self.words[0].count_ones() + self.words[1].count_ones() + self.words[2].count_ones()
    }

    #[inline]
    fn difference_assign(&mut self, right: Self) {
        self.words[0] &= !right.words[0];
        self.words[1] &= !right.words[1];
        self.words[2] &= !right.words[2];
    }

    #[inline]
    fn union_assign(&mut self, right: Self) {
        self.words[0] |= right.words[0];
        self.words[1] |= right.words[1];
        self.words[2] |= right.words[2];
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

impl WideSyndrome for PackedSyndrome<6> {
    #[inline]
    fn toggle(&mut self, right: Self) {
        for (left, right) in self.words.iter_mut().zip(right.words) {
            *left ^= right;
        }
    }

    #[inline]
    fn is_zero(&self) -> bool {
        self.words.iter().all(|&word| word == 0)
    }

    #[inline]
    fn weight(&self) -> u32 {
        self.words.iter().map(|word| word.count_ones()).sum()
    }

    #[inline]
    fn difference_assign(&mut self, right: Self) {
        for (left, right) in self.words.iter_mut().zip(right.words) {
            *left &= !right;
        }
    }

    #[inline]
    fn union_assign(&mut self, right: Self) {
        for (left, right) in self.words.iter_mut().zip(right.words) {
            *left |= right;
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

impl WideSyndrome for PackedSyndrome<11> {
    #[inline]
    fn toggle(&mut self, right: Self) {
        for (left, right) in self.words.iter_mut().zip(right.words) {
            *left ^= right;
        }
    }

    #[inline]
    fn is_zero(&self) -> bool {
        self.words.iter().all(|&word| word == 0)
    }

    #[inline]
    fn weight(&self) -> u32 {
        self.words.iter().map(|word| word.count_ones()).sum()
    }

    #[inline]
    fn difference_assign(&mut self, right: Self) {
        for (left, right) in self.words.iter_mut().zip(right.words) {
            *left &= !right;
        }
    }

    #[inline]
    fn union_assign(&mut self, right: Self) {
        for (left, right) in self.words.iter_mut().zip(right.words) {
            *left |= right;
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

impl WideSyndrome for PackedSyndrome<13> {
    #[inline]
    fn toggle(&mut self, right: Self) {
        for (left, right) in self.words.iter_mut().zip(right.words) {
            *left ^= right;
        }
    }

    #[inline]
    fn is_zero(&self) -> bool {
        self.words.iter().all(|&word| word == 0)
    }

    #[inline]
    fn weight(&self) -> u32 {
        self.words.iter().map(|word| word.count_ones()).sum()
    }

    #[inline]
    fn difference_assign(&mut self, right: Self) {
        for (left, right) in self.words.iter_mut().zip(right.words) {
            *left &= !right;
        }
    }

    #[inline]
    fn union_assign(&mut self, right: Self) {
        for (left, right) in self.words.iter_mut().zip(right.words) {
            *left |= right;
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

#[inline]
fn wide_syndrome_key<const WORDS: usize>(syndrome: PackedSyndrome<WORDS>) -> u128 {
    if WORDS == WIDE_SYNDROME_WORDS {
        let residual = syndrome.words[2];
        let low = syndrome.words[0] ^ residual.rotate_left(46);
        let high = syndrome.words[1] ^ residual.rotate_left(11);
        return u128::from(low) | (u128::from(high) << 64);
    }
    let mut low = syndrome.words[0];
    let mut high = syndrome.words[1];
    for (index, &residual) in syndrome.words[2..].iter().enumerate() {
        low ^= residual.rotate_left(((46 + 17 * index) & 63) as u32);
        high ^= residual.rotate_left(((11 + 29 * index) & 63) as u32);
    }
    u128::from(low) | (u128::from(high) << 64)
}

#[repr(C)]
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
struct PackedColumn<const CHECK_WORDS: usize = SYNDROME_WORDS> {
    syndrome: PackedSyndrome<CHECK_WORDS>,
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

    fn universal() -> Self {
        Self {
            words: vec![u64::MAX].into_boxed_slice(),
            bit_mask: 63,
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

fn compile_completion_filters<const WORDS: usize>(
    columns: &[PackedColumn<WORDS>],
    key: fn(PackedSyndrome<WORDS>) -> u128,
) -> ([Box<[u128]>; 2], CompletionBloom, CompletionBloom) {
    let mut short = [Vec::new(), Vec::new(), Vec::new()];
    short[0].reserve(columns.len());
    short[1].reserve(
        columns
            .len()
            .saturating_mul(columns.len().saturating_sub(1))
            / 2,
    );
    short[2].reserve(
        columns
            .len()
            .saturating_mul(columns.len().saturating_sub(1))
            .saturating_mul(columns.len().saturating_sub(2))
            / 6,
    );
    for left in 0..columns.len() {
        let left_key = key(columns[left].syndrome);
        short[0].push(left_key);
        for middle in left + 1..columns.len() {
            let pair_key = left_key ^ key(columns[middle].syndrome);
            short[1].push(pair_key);
            for right in columns.iter().skip(middle + 1) {
                short[2].push(pair_key ^ key(right.syndrome));
            }
        }
    }
    for syndromes in &mut short {
        syndromes.sort_unstable();
        syndromes.dedup();
    }
    let mut three_completion_bloom = CompletionBloom::new(short.iter().map(Vec::len).sum());
    for syndromes in &short {
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
    for syndromes in &short {
        for &syndrome in syndromes {
            four_completion_bloom.insert_one(syndrome);
        }
    }
    for first in 0..columns.len() {
        let first_key = key(columns[first].syndrome);
        for second in first + 1..columns.len() {
            let pair_key = first_key ^ key(columns[second].syndrome);
            for third in second + 1..columns.len() {
                let triple_key = pair_key ^ key(columns[third].syndrome);
                for fourth in columns.iter().skip(third + 1) {
                    four_completion_bloom.insert_one(triple_key ^ key(fourth.syndrome));
                }
            }
        }
    }
    let [one, two, _three] = short;
    (
        [one.into_boxed_slice(), two.into_boxed_slice()],
        three_completion_bloom,
        four_completion_bloom,
    )
}

/// Memory-bounded completion filters for large codes.  Triple keys stream
/// directly into the Bloom filter instead of materializing O(n^3) u128s;
/// the optional four-completion rejection is conservatively disabled.
fn compile_large_completion_filters<const WORDS: usize>(
    columns: &[PackedColumn<WORDS>],
    key: fn(PackedSyndrome<WORDS>) -> u128,
) -> ([Box<[u128]>; 2], CompletionBloom, CompletionBloom) {
    let pair_count = columns
        .len()
        .saturating_mul(columns.len().saturating_sub(1))
        / 2;
    let triple_count = pair_count.saturating_mul(columns.len().saturating_sub(2)) / 3;
    let mut one = Vec::with_capacity(columns.len());
    let mut two = Vec::with_capacity(pair_count);
    let mut three_completion_bloom = CompletionBloom::new(
        columns
            .len()
            .saturating_add(pair_count)
            .saturating_add(triple_count),
    );
    for left in 0..columns.len() {
        let left_key = key(columns[left].syndrome);
        one.push(left_key);
        three_completion_bloom.insert_three(left_key);
        for middle in left + 1..columns.len() {
            let pair_key = left_key ^ key(columns[middle].syndrome);
            two.push(pair_key);
            three_completion_bloom.insert_three(pair_key);
            for right in columns.iter().skip(middle + 1) {
                three_completion_bloom.insert_three(pair_key ^ key(right.syndrome));
            }
        }
    }
    one.sort_unstable();
    one.dedup();
    two.sort_unstable();
    two.dedup();
    (
        [one.into_boxed_slice(), two.into_boxed_slice()],
        three_completion_bloom,
        CompletionBloom::universal(),
    )
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
    source_sha256: [u8; 32],
    artifact_payload_blake3: Option<[u8; 32]>,
}

struct CompiledStructure {
    columns: Box<[PackedColumn]>,
    neighbors: Box<[PackedSupport]>,
    maximum_column_check_weight: u8,
    kernel_weights_even: bool,
}

struct WideCompiledStructure<
    const SUPPORT_WORDS: usize,
    const CHECK_WORDS: usize,
    const LOGICAL_WORDS: usize,
> {
    columns: Box<[PackedColumn<CHECK_WORDS>]>,
    extra_logical_columns: Box<[u64]>,
    neighbors: Box<[PackedSupport<SUPPORT_WORDS>]>,
    check_count: u16,
    maximum_column_check_weight: u8,
    kernel_weights_even: bool,
    check_conflicts: Box<[AlignedConflict<CHECK_WORDS>]>,
    check_neighbors: Box<[PackedSupport<SUPPORT_WORDS>]>,
}

#[repr(C, align(32))]
#[derive(Clone, Copy, Debug, Default)]
struct AlignedConflict<const CHECK_WORDS: usize> {
    syndrome: PackedSyndrome<CHECK_WORDS>,
    _padding: u64,
}

const _: () = assert!(std::mem::size_of::<AlignedConflict<WIDE_SYNDROME_WORDS>>() == 32);

/// Precompiled exact state for CSS instances up to 320 coordinates and rank 192.
#[derive(Clone, Debug)]
pub struct CompiledWideCssDistanceImpl<
    const SUPPORT_WORDS: usize,
    const CHECK_WORDS: usize,
    const LOGICAL_WORDS: usize = 1,
> {
    columns: Box<[PackedColumn<CHECK_WORDS>]>,
    extra_logical_columns: Box<[u64]>,
    neighbors: Box<[PackedSupport<SUPPORT_WORDS>]>,
    coordinate_count: u16,
    check_count: u16,
    logical_count: u8,
    maximum_column_check_weight: u8,
    kernel_weights_even: bool,
    short_completion_syndromes: [Box<[u128]>; 2],
    three_completion_bloom: CompletionBloom,
    four_completion_bloom: CompletionBloom,
    check_conflicts: Box<[AlignedConflict<CHECK_WORDS>]>,
    check_neighbors: Box<[PackedSupport<SUPPORT_WORDS>]>,
    source_sha256: [u8; 32],
    artifact_payload_blake3: Option<[u8; 32]>,
}

pub type CompiledWideCssDistance =
    CompiledWideCssDistanceImpl<WIDE_SUPPORT_WORDS, WIDE_SYNDROME_WORDS, 1>;
pub type CompiledExtraWideCssDistance =
    CompiledWideCssDistanceImpl<EXTRA_WIDE_SUPPORT_WORDS, WIDE_SYNDROME_WORDS, 1>;
#[cfg(feature = "large-css")]
pub type CompiledLargeCssDistance =
    CompiledWideCssDistanceImpl<LARGE_SUPPORT_WORDS, LARGE_SYNDROME_WORDS, 1>;
#[cfg(feature = "large-css")]
pub type CompiledHugeCssDistance =
    CompiledWideCssDistanceImpl<HUGE_SUPPORT_WORDS, HUGE_SYNDROME_WORDS, HUGE_LOGICAL_WORDS>;
#[cfg(feature = "large-css")]
pub type CompiledColossalCssDistance = CompiledWideCssDistanceImpl<
    COLOSSAL_SUPPORT_WORDS,
    COLOSSAL_SYNDROME_WORDS,
    HUGE_LOGICAL_WORDS,
>;

/// Select original rows forming a basis, preserving sparse presentation rows.
fn independent_row_indices(matrix: &Matrix) -> Vec<usize> {
    let word_count = matrix.cols().div_ceil(64);
    let mut pivots: Vec<(usize, Box<[u64]>)> = Vec::with_capacity(matrix.rows());
    let mut indices = Vec::with_capacity(matrix.rows());
    for row_index in 0..matrix.rows() {
        let mut words = vec![0u64; word_count];
        for (column, &entry) in matrix.row(row_index).iter().enumerate() {
            if entry != 0 {
                words[column / 64] |= 1u64 << (column % 64);
            }
        }
        for &(pivot, ref basis) in &pivots {
            if words[pivot / 64] & (1u64 << (pivot % 64)) != 0 {
                for (left, &right) in words.iter_mut().zip(basis.iter()) {
                    *left ^= right;
                }
            }
        }
        let Some(pivot) = words
            .iter()
            .rposition(|&word| word != 0)
            .map(|word| word * 64 + (63 - words[word].leading_zeros() as usize))
        else {
            continue;
        };
        let insertion = pivots.partition_point(|&(existing, _)| existing > pivot);
        pivots.insert(insertion, (pivot, words.into_boxed_slice()));
        indices.push(row_index);
    }
    indices
}

fn compile_wide_structure<
    const SUPPORT_WORDS: usize,
    const CHECK_WORDS: usize,
    const LOGICAL_WORDS: usize,
>(
    physical: &Matrix,
    logical: &Matrix,
) -> Result<WideCompiledStructure<SUPPORT_WORDS, CHECK_WORDS, LOGICAL_WORDS>, CssDistanceError>
where
    PackedSyndrome<CHECK_WORDS>: WideSyndrome,
{
    let maximum_wide_coordinates = SUPPORT_WORDS * 64;
    let maximum_wide_checks = CHECK_WORDS * 64;
    let coordinate_count = physical.cols();
    if coordinate_count > maximum_wide_coordinates {
        return Err(CssDistanceError::TooManyCoordinates);
    }
    if logical.rows() > 64 * LOGICAL_WORDS || logical.rows() > usize::from(u8::MAX) {
        return Err(CssDistanceError::TooManyLogicals);
    }
    if logical.cols() != coordinate_count {
        return Err(CssDistanceError::CoordinateMismatch);
    }
    if coordinate_count == 0 || logical.rows() == 0 {
        return Err(CssDistanceError::EmptyProblem);
    }
    let basis = independent_row_indices(physical);
    if basis.len() > maximum_wide_checks {
        return Err(CssDistanceError::TooManyChecks);
    }
    let mut basis_positions = vec![u16::MAX; physical.rows()];
    for (position, &row) in basis.iter().enumerate() {
        basis_positions[row] = position as u16;
    }
    let mut columns = vec![PackedColumn::<CHECK_WORDS>::default(); coordinate_count];
    let mut extra_logical_columns =
        vec![0u64; coordinate_count.saturating_mul(LOGICAL_WORDS.saturating_sub(1))];
    let mut neighbors = vec![PackedSupport::<SUPPORT_WORDS>::default(); coordinate_count];
    for (check, &basis_position) in basis_positions.iter().enumerate() {
        let row = physical.row(check);
        let mut row_support = PackedSupport::<SUPPORT_WORDS>::default();
        for (coordinate, &entry) in row.iter().enumerate() {
            if entry != 0 {
                row_support.insert(coordinate);
                let position = basis_position;
                if position != u16::MAX {
                    let position = usize::from(position);
                    columns[coordinate].syndrome.words[position / 64] |= 1u64 << (position % 64);
                }
            }
        }
        for (coordinate, &entry) in row.iter().enumerate() {
            if entry != 0 {
                neighbors[coordinate].union_assign(row_support);
            }
        }
    }
    for logical_row in 0..logical.rows() {
        for (coordinate, &entry) in logical.row(logical_row).iter().enumerate() {
            if entry != 0 {
                if logical_row < 64 {
                    columns[coordinate].logical |= 1u64 << logical_row;
                } else {
                    let word = logical_row / 64 - 1;
                    extra_logical_columns[coordinate * LOGICAL_WORDS.saturating_sub(1) + word] |=
                        1u64 << (logical_row % 64);
                }
            }
        }
    }
    let presented_row_sum_is_all_ones = (0..coordinate_count).all(|coordinate| {
        (0..physical.rows()).fold(0u8, |parity, row| {
            parity ^ (physical.row(row)[coordinate] & 1)
        }) == 1
    });
    let mut maximum_column_check_weight = 0u8;
    let mut basis_row_sum_is_all_ones = true;
    for (coordinate, column) in columns.iter().enumerate() {
        neighbors[coordinate].remove(coordinate);
        maximum_column_check_weight = maximum_column_check_weight
            .max(u8::try_from(column.syndrome.weight()).expect("wide check count is bounded"));
        basis_row_sum_is_all_ones &= column.syndrome.weight() & 1 == 1;
    }
    let mut check_conflicts = vec![AlignedConflict::<CHECK_WORDS>::default(); basis.len()];
    let mut check_neighbors = vec![PackedSupport::<SUPPORT_WORDS>::default(); basis.len()];
    for (coordinate, column) in columns.iter().enumerate() {
        let mut checks = column.syndrome;
        while let Some(check) = checks.pop_lowest() {
            check_conflicts[check]
                .syndrome
                .union_assign(column.syndrome);
            check_neighbors[check].insert(coordinate);
        }
    }
    Ok(WideCompiledStructure {
        columns: columns.into_boxed_slice(),
        extra_logical_columns: extra_logical_columns.into_boxed_slice(),
        neighbors: neighbors.into_boxed_slice(),
        check_count: basis.len() as u16,
        maximum_column_check_weight,
        kernel_weights_even: presented_row_sum_is_all_ones || basis_row_sum_is_all_ones,
        check_conflicts: check_conflicts.into_boxed_slice(),
        check_neighbors: check_neighbors.into_boxed_slice(),
    })
}

#[allow(private_bounds)]
impl<const SUPPORT_WORDS: usize, const CHECK_WORDS: usize, const LOGICAL_WORDS: usize>
    CompiledWideCssDistanceImpl<SUPPORT_WORDS, CHECK_WORDS, LOGICAL_WORDS>
where
    PackedSyndrome<CHECK_WORDS>: WideSyndrome,
{
    pub fn compile(physical: &Matrix, logical: &Matrix) -> Result<Self, CssDistanceError> {
        let structure =
            compile_wide_structure::<SUPPORT_WORDS, CHECK_WORDS, LOGICAL_WORDS>(physical, logical)?;
        let (short_completion_syndromes, three_completion_bloom, four_completion_bloom) =
            if CHECK_WORDS > WIDE_SYNDROME_WORDS {
                compile_large_completion_filters(&structure.columns, wide_syndrome_key)
            } else {
                compile_completion_filters(&structure.columns, wide_syndrome_key)
            };
        Ok(Self {
            columns: structure.columns,
            extra_logical_columns: structure.extra_logical_columns,
            neighbors: structure.neighbors,
            coordinate_count: physical.cols() as u16,
            check_count: structure.check_count,
            logical_count: logical.rows() as u8,
            maximum_column_check_weight: structure.maximum_column_check_weight,
            kernel_weights_even: structure.kernel_weights_even,
            short_completion_syndromes,
            three_completion_bloom,
            four_completion_bloom,
            check_conflicts: structure.check_conflicts,
            check_neighbors: structure.check_neighbors,
            source_sha256: CompiledCssDistance::source_sha256(physical, logical),
            artifact_payload_blake3: None,
        })
    }

    /// Persist the expensive projected completion filters for a wide instance.
    pub fn write_artifact<W: Write>(&self, mut writer: W) -> Result<(), CssDistanceArtifactError> {
        let (magic, version) = wide_artifact_identity::<SUPPORT_WORDS, CHECK_WORDS>();
        writer.write_all(magic)?;
        let mut writer = HashingWriter {
            inner: writer,
            hasher: blake3::Hasher::new(),
        };
        write_u16(&mut writer, version)?;
        writer.bytes(&self.source_sha256)?;
        write_u16(&mut writer, self.coordinate_count)?;
        write_u16(&mut writer, self.check_count)?;
        writer.bytes(&[
            self.logical_count,
            self.maximum_column_check_weight,
            u8::from(self.kernel_weights_even),
            0,
        ])?;
        for syndromes in &self.short_completion_syndromes {
            write_len(&mut writer, syndromes.len())?;
            for &syndrome in syndromes.iter() {
                writer.bytes(&syndrome.to_le_bytes())?;
            }
        }
        for bloom in [&self.three_completion_bloom, &self.four_completion_bloom] {
            write_len(&mut writer, bloom.words.len())?;
            write_u64_slice(&mut writer, &bloom.words)?;
        }
        let mut writer = writer.finish()?;
        writer.flush()?;
        Ok(())
    }

    /// Load source-bound wide filters and independently rebuild sparse search state.
    pub fn read_artifact<R: Read>(
        physical: &Matrix,
        logical: &Matrix,
        mut reader: R,
    ) -> Result<Self, CssDistanceArtifactError> {
        let (expected_magic, expected_version) =
            wide_artifact_identity::<SUPPORT_WORDS, CHECK_WORDS>();
        let mut magic = [0u8; 8];
        reader.read_exact(&mut magic)?;
        if &magic != expected_magic {
            return Err(CssDistanceArtifactError::Format);
        }
        let mut reader = HashingReader {
            inner: reader,
            hasher: blake3::Hasher::new(),
        };
        if read_u16(&mut reader)? != expected_version {
            return Err(CssDistanceArtifactError::Format);
        }
        let mut source_sha256 = [0u8; 32];
        reader.bytes(&mut source_sha256)?;
        if source_sha256 != CompiledCssDistance::source_sha256(physical, logical) {
            return Err(CssDistanceArtifactError::SourceMismatch);
        }
        let coordinate_count = read_u16(&mut reader)?;
        let check_count = read_u16(&mut reader)?;
        let mut flags = [0u8; 4];
        reader.bytes(&mut flags)?;
        let logical_count = flags[0];
        let maximum_column_check_weight = flags[1];
        let kernel_weights_even = match flags[2] {
            0 => false,
            1 => true,
            _ => return Err(CssDistanceArtifactError::Shape),
        };
        if flags[3] != 0
            || usize::from(coordinate_count) != physical.cols()
            || usize::from(logical_count) != logical.rows()
        {
            return Err(CssDistanceArtifactError::Shape);
        }
        let maximum_pairs = physical
            .cols()
            .saturating_mul(physical.cols().saturating_sub(1))
            / 2;
        let one_completion = read_syndromes(&mut reader, physical.cols())?;
        let two_completion = read_syndromes(&mut reader, maximum_pairs)?;
        let three_completion_bloom = read_bloom(&mut reader)?;
        let four_completion_bloom = read_bloom(&mut reader)?;
        let artifact_payload_blake3 = reader.finish()?;
        if !strictly_sorted(&one_completion) || !strictly_sorted(&two_completion) {
            return Err(CssDistanceArtifactError::Shape);
        }
        let structure =
            compile_wide_structure::<SUPPORT_WORDS, CHECK_WORDS, LOGICAL_WORDS>(physical, logical)?;
        if check_count != structure.check_count
            || maximum_column_check_weight != structure.maximum_column_check_weight
            || kernel_weights_even != structure.kernel_weights_even
        {
            return Err(CssDistanceArtifactError::Shape);
        }
        Ok(Self {
            columns: structure.columns,
            extra_logical_columns: structure.extra_logical_columns,
            neighbors: structure.neighbors,
            coordinate_count,
            check_count,
            logical_count,
            maximum_column_check_weight,
            kernel_weights_even,
            short_completion_syndromes: [one_completion, two_completion],
            three_completion_bloom,
            four_completion_bloom,
            check_conflicts: structure.check_conflicts,
            check_neighbors: structure.check_neighbors,
            source_sha256,
            artifact_payload_blake3: Some(artifact_payload_blake3),
        })
    }

    #[inline]
    pub fn artifact_payload_blake3(&self) -> Option<[u8; 32]> {
        self.artifact_payload_blake3
    }

    /// Test all logical observations without widening the per-candidate hot state.
    /// Observations above the first word are consulted only at zero-syndrome leaves.
    #[inline]
    fn logical_is_nonzero(&self, support: PackedSupport<SUPPORT_WORDS>, first_word: u64) -> bool {
        if first_word != 0 {
            return true;
        }
        let extra_words = LOGICAL_WORDS.saturating_sub(1);
        for word in 0..extra_words {
            let mut value = 0u64;
            let mut remaining = support;
            while let Some(coordinate) = remaining.pop_lowest() {
                value ^= self.extra_logical_columns[coordinate * extra_words + word];
            }
            if value != 0 {
                return true;
            }
        }
        false
    }

    #[inline]
    fn syndrome_degree_bound_exceeds(
        &self,
        syndrome: PackedSyndrome<CHECK_WORDS>,
        budget: u16,
    ) -> bool {
        let degree = u32::from(self.maximum_column_check_weight);
        if degree == 0 {
            return !syndrome.is_zero() && budget != u16::MAX;
        }
        syndrome.weight() > u32::from(budget) * degree
    }

    /// Test whether greedy packing finds more disjoint neighborhoods than the budget.
    #[inline]
    fn syndrome_packing_exceeds(
        &self,
        mut syndrome: PackedSyndrome<CHECK_WORDS>,
        budget: u16,
    ) -> bool {
        let mut remaining = budget;
        while let Some(check) = syndrome.pop_lowest() {
            if remaining == 0 {
                return true;
            }
            remaining -= 1;
            syndrome.difference_assign(self.check_conflicts[check].syndrome);
        }
        false
    }

    /// Test the cheap degree bound before paying for greedy conflict packing.
    #[inline]
    fn completion_lower_bound_exceeds(
        &self,
        syndrome: PackedSyndrome<CHECK_WORDS>,
        budget: u16,
    ) -> bool {
        self.syndrome_degree_bound_exceeds(syndrome, budget)
            || self.syndrome_packing_exceeds(syndrome, budget)
    }

    #[inline]
    fn syndrome_branch_options(
        &self,
        mut syndrome: PackedSyndrome<CHECK_WORDS>,
        support: PackedSupport<SUPPORT_WORDS>,
        forbidden: PackedSupport<SUPPORT_WORDS>,
    ) -> PackedSupport<SUPPORT_WORDS> {
        let Some(check) = syndrome.pop_lowest() else {
            return PackedSupport::<SUPPORT_WORDS>::default();
        };
        let mut options = self.check_neighbors[check];
        options.difference_assign(support);
        options.difference_assign(forbidden);
        options
    }

    /// Exact fail-first search branching on a currently unsatisfied check.
    pub fn search_bounded_syndrome_driven(
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
        let frame_count = usize::from(searched_maximum_weight.max(1));
        let mut supports = vec![PackedSupport::<SUPPORT_WORDS>::default(); frame_count];
        let mut forbidden = vec![PackedSupport::<SUPPORT_WORDS>::default(); frame_count];
        let mut options = vec![PackedSupport::<SUPPORT_WORDS>::default(); frame_count];
        let mut rejected = vec![PackedSupport::<SUPPORT_WORDS>::default(); frame_count];
        let mut syndromes = vec![PackedSyndrome::<CHECK_WORDS>::default(); frame_count];
        let mut logicals = vec![0u64; frame_count];
        let mut best_weight = searched_maximum_weight.saturating_add(1);
        let mut best_support = PackedSupport::<SUPPORT_WORDS>::default();
        let mut stats = ConnectedSearchStats::default();
        for &anchor in anchors {
            let root = usize::from(anchor);
            supports[0] = PackedSupport::<SUPPORT_WORDS>::singleton(root);
            forbidden[0] = PackedSupport::<SUPPORT_WORDS>::default();
            syndromes[0] = self.columns[root].syndrome;
            logicals[0] = self.columns[root].logical;
            stats.connected_supports += 1;
            stats.maximum_depth = stats.maximum_depth.max(1);
            if syndromes[0].is_zero() {
                stats.kernel_supports += 1;
                if self.logical_is_nonzero(supports[0], logicals[0]) {
                    stats.nontrivial_supports += 1;
                    best_weight = 1;
                    best_support = supports[0];
                }
                continue;
            }
            options[0] = self.syndrome_branch_options(syndromes[0], supports[0], forbidden[0]);
            rejected[0] = PackedSupport::<SUPPORT_WORDS>::default();
            let mut depth = 0usize;
            loop {
                let Some(added) = options[depth].pop_lowest() else {
                    if depth == 0 {
                        break;
                    }
                    depth -= 1;
                    continue;
                };
                stats.candidates += 1;
                let prior_rejected = rejected[depth];
                rejected[depth].insert(added);
                let child_depth = depth + 1;
                let child_weight = (child_depth + 1) as u16;
                let mut child_support = supports[depth];
                child_support.insert(added);
                let mut child_forbidden = forbidden[depth];
                child_forbidden.union_assign(prior_rejected);
                let mut child_syndrome = syndromes[depth];
                child_syndrome.toggle(self.columns[added].syndrome);
                let child_logical = logicals[depth] ^ self.columns[added].logical;
                stats.connected_supports += 1;
                stats.maximum_depth = stats.maximum_depth.max(child_weight);
                if child_syndrome.is_zero() {
                    stats.kernel_supports += 1;
                    if self.logical_is_nonzero(child_support, child_logical) {
                        stats.nontrivial_supports += 1;
                        if child_weight < best_weight {
                            best_weight = child_weight;
                            best_support = child_support;
                        }
                    }
                    continue;
                }
                let improvement_budget = best_weight.saturating_sub(child_weight + 1);
                if child_weight >= searched_maximum_weight
                    || self.completion_lower_bound_exceeds(child_syndrome, improvement_budget)
                {
                    stats.syndrome_bound_prunes += 1;
                    continue;
                }
                let four_completion_reject =
                    improvement_budget == 4 && !self.may_have_four_completion(child_syndrome);
                if (improvement_budget <= 3
                    && !self.has_short_completion(child_syndrome, improvement_budget))
                    || four_completion_reject
                {
                    stats.syndrome_bound_prunes += 1;
                    stats.four_completion_prunes += u64::from(four_completion_reject);
                    continue;
                }
                let child_options =
                    self.syndrome_branch_options(child_syndrome, child_support, child_forbidden);
                if child_options.is_empty() {
                    stats.syndrome_bound_prunes += 1;
                    continue;
                }
                supports[child_depth] = child_support;
                forbidden[child_depth] = child_forbidden;
                syndromes[child_depth] = child_syndrome;
                logicals[child_depth] = child_logical;
                options[child_depth] = child_options;
                rejected[child_depth] = PackedSupport::<SUPPORT_WORDS>::default();
                stats.exclusive_extensions += 1;
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
}

#[cfg(feature = "parallel")]
#[inline(always)]
fn search_syndrome_branch_partition_impl<
    const SUPPORT_WORDS: usize,
    const CHECK_WORDS: usize,
    const LOGICAL_WORDS: usize,
>(
    compiled: &CompiledWideCssDistanceImpl<SUPPORT_WORDS, CHECK_WORDS, LOGICAL_WORDS>,
    branches: &[WideRootBranch<SUPPORT_WORDS, CHECK_WORDS>],
    searched_maximum_weight: u16,
    mailboxes: &[BoundMailbox],
    pulse_interval: u64,
) -> CachePaddedWideBranchResult<SUPPORT_WORDS>
where
    PackedSyndrome<CHECK_WORDS>: WideSyndrome,
{
    let mut workspace = WideBranchWorkspace::<SUPPORT_WORDS, CHECK_WORDS>::new(usize::from(
        searched_maximum_weight,
    ));
    let worker_index = rayon::current_thread_index().unwrap_or(0) % mailboxes.len();
    let mailbox = &mailboxes[worker_index];
    let mut pruning_bound = mailbox.0.load(Ordering::Relaxed);
    let mut best_weight = searched_maximum_weight.saturating_add(1);
    let mut best_support = PackedSupport::<SUPPORT_WORDS>::default();
    let mut stats = ConnectedSearchStats::default();
    for branch in branches {
        poll_bound(mailbox, &mut pruning_bound, &mut stats);
        let improvement_budget = pruning_bound.saturating_sub(branch.weight + 1);
        if branch.weight >= searched_maximum_weight
            || compiled.completion_lower_bound_exceeds(branch.syndrome, improvement_budget)
        {
            stats.syndrome_bound_prunes += 1;
            continue;
        }
        let branch_options =
            compiled.syndrome_branch_options(branch.syndrome, branch.support, branch.forbidden);
        if branch_options.is_empty() {
            stats.syndrome_bound_prunes += 1;
            continue;
        }
        let branch_depth = usize::from(branch.weight - 1);
        workspace.frames[branch_depth] = WideBranchFrame {
            support: branch.support,
            forbidden: branch.forbidden,
            options: branch_options,
            rejected: PackedSupport::<SUPPORT_WORDS>::default(),
            syndrome: branch.syndrome,
            logical: branch.logical,
        };
        stats.exclusive_extensions += 1;
        let mut depth = branch_depth;
        loop {
            let frame = &mut workspace.frames[depth];
            let Some(added) = frame.options.pop_lowest() else {
                if depth == branch_depth {
                    break;
                }
                depth -= 1;
                continue;
            };
            stats.candidates += 1;
            if pulse_interval != 0 && stats.candidates & (pulse_interval - 1) == 0 {
                poll_bound(mailbox, &mut pruning_bound, &mut stats);
            }
            frame.rejected.insert(added);
            let child_depth = depth + 1;
            let child_weight = (child_depth + 1) as u16;
            let mut child_syndrome = frame.syndrome;
            child_syndrome.toggle(compiled.columns[added].syndrome);
            let child_logical = frame.logical ^ compiled.columns[added].logical;
            stats.maximum_depth = stats.maximum_depth.max(child_weight);
            if child_syndrome.is_zero() {
                stats.kernel_supports += 1;
                let mut child_support = frame.support;
                child_support.insert(added);
                if compiled.logical_is_nonzero(child_support, child_logical) {
                    stats.nontrivial_supports += 1;
                    if child_weight < best_weight {
                        best_weight = child_weight;
                        best_support = child_support;
                        pruning_bound = pruning_bound.min(child_weight);
                        stats.bound_improvements_published +=
                            u64::from(publish_bound(mailboxes, child_weight));
                    }
                }
                continue;
            }
            let improvement_budget = pruning_bound.saturating_sub(child_weight + 1);
            if child_weight >= searched_maximum_weight
                || compiled.completion_lower_bound_exceeds(child_syndrome, improvement_budget)
            {
                stats.syndrome_bound_prunes += 1;
                continue;
            }
            let four_completion_reject =
                improvement_budget == 4 && !compiled.may_have_four_completion(child_syndrome);
            if (improvement_budget <= 3
                && !compiled.has_short_completion(child_syndrome, improvement_budget))
                || four_completion_reject
            {
                stats.syndrome_bound_prunes += 1;
                stats.four_completion_prunes += u64::from(four_completion_reject);
                continue;
            }
            let mut child_support = frame.support;
            child_support.insert(added);
            let mut child_forbidden = frame.forbidden;
            // `added` is already in `child_support`, so retaining it in the
            // forbidden set leaves every descendant option set unchanged.
            child_forbidden.union_assign(frame.rejected);
            let child_options =
                compiled.syndrome_branch_options(child_syndrome, child_support, child_forbidden);
            if child_options.is_empty() {
                stats.syndrome_bound_prunes += 1;
                continue;
            }
            workspace.frames[child_depth] = WideBranchFrame {
                support: child_support,
                forbidden: child_forbidden,
                options: child_options,
                rejected: PackedSupport::<SUPPORT_WORDS>::default(),
                syndrome: child_syndrome,
                logical: child_logical,
            };
            stats.exclusive_extensions += 1;
            depth = child_depth;
        }
    }
    stats.connected_supports = stats.candidates;
    CachePaddedWideBranchResult {
        best_weight,
        best_support,
        stats,
    }
}

#[cfg(feature = "parallel")]
trait WidePartitionKernel<const SUPPORT_WORDS: usize, const CHECK_WORDS: usize> {
    fn search_partition(
        &self,
        branches: &[WideRootBranch<SUPPORT_WORDS, CHECK_WORDS>],
        searched_maximum_weight: u16,
        mailboxes: &[BoundMailbox],
        pulse_interval: u64,
    ) -> CachePaddedWideBranchResult<SUPPORT_WORDS>;
}

#[cfg(feature = "parallel")]
#[multiversion::multiversion(
    targets("x86_64+avx+avx2+bmi1+bmi2+lzcnt+popcnt"),
    dispatcher = "indirect"
)]
fn search_syndrome_branch_partition_wide(
    compiled: &CompiledWideCssDistance,
    branches: &[WideRootBranch<WIDE_SUPPORT_WORDS, WIDE_SYNDROME_WORDS>],
    searched_maximum_weight: u16,
    mailboxes: &[BoundMailbox],
    pulse_interval: u64,
) -> CachePaddedWideBranchResult<WIDE_SUPPORT_WORDS> {
    search_syndrome_branch_partition_impl(
        compiled,
        branches,
        searched_maximum_weight,
        mailboxes,
        pulse_interval,
    )
}

#[cfg(feature = "parallel")]
#[multiversion::multiversion(
    targets("x86_64+avx+avx2+bmi1+bmi2+lzcnt+popcnt"),
    dispatcher = "indirect"
)]
fn search_syndrome_branch_partition_extra_wide(
    compiled: &CompiledExtraWideCssDistance,
    branches: &[WideRootBranch<EXTRA_WIDE_SUPPORT_WORDS, WIDE_SYNDROME_WORDS>],
    searched_maximum_weight: u16,
    mailboxes: &[BoundMailbox],
    pulse_interval: u64,
) -> CachePaddedWideBranchResult<EXTRA_WIDE_SUPPORT_WORDS> {
    search_syndrome_branch_partition_impl(
        compiled,
        branches,
        searched_maximum_weight,
        mailboxes,
        pulse_interval,
    )
}

#[cfg(feature = "parallel")]
#[cfg(feature = "large-css")]
#[multiversion::multiversion(
    targets("x86_64+avx+avx2+bmi1+bmi2+lzcnt+popcnt"),
    dispatcher = "indirect"
)]
fn search_syndrome_branch_partition_large(
    compiled: &CompiledLargeCssDistance,
    branches: &[WideRootBranch<LARGE_SUPPORT_WORDS, LARGE_SYNDROME_WORDS>],
    searched_maximum_weight: u16,
    mailboxes: &[BoundMailbox],
    pulse_interval: u64,
) -> CachePaddedWideBranchResult<LARGE_SUPPORT_WORDS> {
    search_syndrome_branch_partition_impl(
        compiled,
        branches,
        searched_maximum_weight,
        mailboxes,
        pulse_interval,
    )
}

#[cfg(feature = "parallel")]
#[cfg(feature = "large-css")]
#[multiversion::multiversion(
    targets("x86_64+avx+avx2+bmi1+bmi2+lzcnt+popcnt"),
    dispatcher = "indirect"
)]
fn search_syndrome_branch_partition_huge(
    compiled: &CompiledHugeCssDistance,
    branches: &[WideRootBranch<HUGE_SUPPORT_WORDS, HUGE_SYNDROME_WORDS>],
    searched_maximum_weight: u16,
    mailboxes: &[BoundMailbox],
    pulse_interval: u64,
) -> CachePaddedWideBranchResult<HUGE_SUPPORT_WORDS> {
    search_syndrome_branch_partition_impl(
        compiled,
        branches,
        searched_maximum_weight,
        mailboxes,
        pulse_interval,
    )
}

#[cfg(feature = "parallel")]
#[cfg(feature = "large-css")]
#[multiversion::multiversion(
    targets("x86_64+avx+avx2+bmi1+bmi2+lzcnt+popcnt"),
    dispatcher = "indirect"
)]
fn search_syndrome_branch_partition_colossal(
    compiled: &CompiledColossalCssDistance,
    branches: &[WideRootBranch<COLOSSAL_SUPPORT_WORDS, COLOSSAL_SYNDROME_WORDS>],
    searched_maximum_weight: u16,
    mailboxes: &[BoundMailbox],
    pulse_interval: u64,
) -> CachePaddedWideBranchResult<COLOSSAL_SUPPORT_WORDS> {
    search_syndrome_branch_partition_impl(
        compiled,
        branches,
        searched_maximum_weight,
        mailboxes,
        pulse_interval,
    )
}

#[cfg(feature = "parallel")]
impl WidePartitionKernel<WIDE_SUPPORT_WORDS, WIDE_SYNDROME_WORDS> for CompiledWideCssDistance {
    #[inline]
    fn search_partition(
        &self,
        branches: &[WideRootBranch<WIDE_SUPPORT_WORDS, WIDE_SYNDROME_WORDS>],
        searched_maximum_weight: u16,
        mailboxes: &[BoundMailbox],
        pulse_interval: u64,
    ) -> CachePaddedWideBranchResult<WIDE_SUPPORT_WORDS> {
        search_syndrome_branch_partition_wide(
            self,
            branches,
            searched_maximum_weight,
            mailboxes,
            pulse_interval,
        )
    }
}

#[cfg(feature = "parallel")]
impl WidePartitionKernel<EXTRA_WIDE_SUPPORT_WORDS, WIDE_SYNDROME_WORDS>
    for CompiledExtraWideCssDistance
{
    #[inline]
    fn search_partition(
        &self,
        branches: &[WideRootBranch<EXTRA_WIDE_SUPPORT_WORDS, WIDE_SYNDROME_WORDS>],
        searched_maximum_weight: u16,
        mailboxes: &[BoundMailbox],
        pulse_interval: u64,
    ) -> CachePaddedWideBranchResult<EXTRA_WIDE_SUPPORT_WORDS> {
        search_syndrome_branch_partition_extra_wide(
            self,
            branches,
            searched_maximum_weight,
            mailboxes,
            pulse_interval,
        )
    }
}

#[cfg(feature = "parallel")]
#[cfg(feature = "large-css")]
impl WidePartitionKernel<LARGE_SUPPORT_WORDS, LARGE_SYNDROME_WORDS> for CompiledLargeCssDistance {
    #[inline]
    fn search_partition(
        &self,
        branches: &[WideRootBranch<LARGE_SUPPORT_WORDS, LARGE_SYNDROME_WORDS>],
        searched_maximum_weight: u16,
        mailboxes: &[BoundMailbox],
        pulse_interval: u64,
    ) -> CachePaddedWideBranchResult<LARGE_SUPPORT_WORDS> {
        search_syndrome_branch_partition_large(
            self,
            branches,
            searched_maximum_weight,
            mailboxes,
            pulse_interval,
        )
    }
}

#[cfg(feature = "parallel")]
#[cfg(feature = "large-css")]
impl WidePartitionKernel<HUGE_SUPPORT_WORDS, HUGE_SYNDROME_WORDS> for CompiledHugeCssDistance {
    #[inline]
    fn search_partition(
        &self,
        branches: &[WideRootBranch<HUGE_SUPPORT_WORDS, HUGE_SYNDROME_WORDS>],
        searched_maximum_weight: u16,
        mailboxes: &[BoundMailbox],
        pulse_interval: u64,
    ) -> CachePaddedWideBranchResult<HUGE_SUPPORT_WORDS> {
        search_syndrome_branch_partition_huge(
            self,
            branches,
            searched_maximum_weight,
            mailboxes,
            pulse_interval,
        )
    }
}

#[cfg(feature = "parallel")]
#[cfg(feature = "large-css")]
impl WidePartitionKernel<COLOSSAL_SUPPORT_WORDS, COLOSSAL_SYNDROME_WORDS>
    for CompiledColossalCssDistance
{
    #[inline]
    fn search_partition(
        &self,
        branches: &[WideRootBranch<COLOSSAL_SUPPORT_WORDS, COLOSSAL_SYNDROME_WORDS>],
        searched_maximum_weight: u16,
        mailboxes: &[BoundMailbox],
        pulse_interval: u64,
    ) -> CachePaddedWideBranchResult<COLOSSAL_SUPPORT_WORDS> {
        search_syndrome_branch_partition_colossal(
            self,
            branches,
            searched_maximum_weight,
            mailboxes,
            pulse_interval,
        )
    }
}

#[allow(private_bounds)]
impl<const SUPPORT_WORDS: usize, const CHECK_WORDS: usize, const LOGICAL_WORDS: usize>
    CompiledWideCssDistanceImpl<SUPPORT_WORDS, CHECK_WORDS, LOGICAL_WORDS>
where
    PackedSyndrome<CHECK_WORDS>: WideSyndrome,
{
    #[cfg(feature = "parallel")]
    fn search_syndrome_anchor_parallel(
        &self,
        anchor: u16,
        searched_maximum_weight: u16,
        initial_bound: u16,
        pulse_interval: u64,
    ) -> CachePaddedWideBranchResult<SUPPORT_WORDS>
    where
        Self: WidePartitionKernel<SUPPORT_WORDS, CHECK_WORDS>,
    {
        use rayon::prelude::*;

        let root = usize::from(anchor);
        let root_support = PackedSupport::<SUPPORT_WORDS>::singleton(root);
        let mut branches = vec![WideRootBranch {
            support: root_support,
            syndrome: self.columns[root].syndrome,
            logical: self.columns[root].logical,
            forbidden: PackedSupport::<SUPPORT_WORDS>::default(),
            weight: 1,
        }];
        let target_branches = rayon::current_num_threads().saturating_mul(4);
        let mut prefix_stats = ConnectedSearchStats::default();
        let mut prefix_best_weight = searched_maximum_weight.saturating_add(1);
        let mut prefix_best_support = PackedSupport::<SUPPORT_WORDS>::default();
        let mut active_bound = initial_bound;
        while branches.len() < target_branches {
            let mut next = Vec::with_capacity(branches.len().saturating_mul(5));
            for branch in branches {
                let mut branch_options =
                    self.syndrome_branch_options(branch.syndrome, branch.support, branch.forbidden);
                let mut rejected = PackedSupport::<SUPPORT_WORDS>::default();
                while let Some(added) = branch_options.pop_lowest() {
                    let mut child_support = branch.support;
                    child_support.insert(added);
                    let mut child_forbidden = branch.forbidden;
                    child_forbidden.union_assign(rejected);
                    rejected.insert(added);
                    let mut child_syndrome = branch.syndrome;
                    child_syndrome.toggle(self.columns[added].syndrome);
                    let child_logical = branch.logical ^ self.columns[added].logical;
                    let child_weight = branch.weight + 1;
                    prefix_stats.candidates += 1;
                    prefix_stats.connected_supports += 1;
                    prefix_stats.maximum_depth = prefix_stats.maximum_depth.max(child_weight);
                    if child_syndrome.is_zero() {
                        prefix_stats.kernel_supports += 1;
                        if self.logical_is_nonzero(child_support, child_logical) {
                            prefix_stats.nontrivial_supports += 1;
                            if child_weight < prefix_best_weight {
                                prefix_best_weight = child_weight;
                                prefix_best_support = child_support;
                                active_bound = active_bound.min(child_weight);
                            }
                        }
                        continue;
                    }
                    let improvement_budget = active_bound.saturating_sub(child_weight + 1);
                    if child_weight >= searched_maximum_weight
                        || self.completion_lower_bound_exceeds(child_syndrome, improvement_budget)
                    {
                        prefix_stats.syndrome_bound_prunes += 1;
                        continue;
                    }
                    let four_completion_reject =
                        improvement_budget == 4 && !self.may_have_four_completion(child_syndrome);
                    if (improvement_budget <= 3
                        && !self.has_short_completion(child_syndrome, improvement_budget))
                        || four_completion_reject
                    {
                        prefix_stats.syndrome_bound_prunes += 1;
                        prefix_stats.four_completion_prunes += u64::from(four_completion_reject);
                        continue;
                    }
                    next.push(WideRootBranch {
                        support: child_support,
                        syndrome: child_syndrome,
                        logical: child_logical,
                        forbidden: child_forbidden,
                        weight: child_weight,
                    });
                }
            }
            if next.is_empty() {
                branches = next;
                break;
            }
            branches = next;
        }
        if branches.is_empty() {
            return CachePaddedWideBranchResult {
                best_weight: prefix_best_weight,
                best_support: prefix_best_support,
                stats: prefix_stats,
            };
        }
        let thread_count = rayon::current_num_threads();
        let desired_partitions = if thread_count == 1 {
            1
        } else {
            thread_count.saturating_mul(16)
        };
        let partition_count = desired_partitions.min(branches.len());
        let partition_capacity = branches.len().div_ceil(partition_count);
        let mut partitions = (0..partition_count)
            .map(|_| Vec::with_capacity(partition_capacity))
            .collect::<Vec<_>>();
        for (index, branch) in branches.into_iter().enumerate() {
            partitions[index % partition_count].push(branch);
        }
        let mailboxes = (0..rayon::current_num_threads())
            .map(|_| BoundMailbox(AtomicU16::new(active_bound)))
            .collect::<Vec<_>>();
        let partials = partitions
            .par_iter()
            .map(|partition| {
                self.search_partition(
                    partition,
                    searched_maximum_weight,
                    &mailboxes,
                    pulse_interval,
                )
            })
            .collect::<Vec<_>>();
        let mut combined = CachePaddedWideBranchResult {
            best_weight: prefix_best_weight,
            best_support: prefix_best_support,
            stats: prefix_stats,
        };
        for partial in partials {
            merge_search_stats(&mut combined.stats, partial.stats);
            if partial.best_weight < combined.best_weight {
                combined.best_weight = partial.best_weight;
                combined.best_support = partial.best_support;
            }
        }
        combined
    }

    #[cfg(feature = "parallel")]
    fn search_bounded_syndrome_parallel_pulsed_impl(
        &self,
        anchors: &[u16],
        maximum_weight: u16,
        pulse_interval: u64,
    ) -> Result<BoundedCssDistanceResult, CssDistanceError>
    where
        Self: WidePartitionKernel<SUPPORT_WORDS, CHECK_WORDS>,
    {
        if pulse_interval != 0 && !pulse_interval.is_power_of_two() {
            return Err(CssDistanceError::InvalidPulseInterval);
        }
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
        let mut best_weight = searched_maximum_weight.saturating_add(1);
        let mut best_support = PackedSupport::<SUPPORT_WORDS>::default();
        let mut stats = ConnectedSearchStats::default();
        for &anchor in anchors {
            let root = usize::from(anchor);
            let syndrome = self.columns[root].syndrome;
            let logical = self.columns[root].logical;
            stats.connected_supports += 1;
            stats.maximum_depth = stats.maximum_depth.max(1);
            if syndrome.is_zero() {
                stats.kernel_supports += 1;
                if self.logical_is_nonzero(PackedSupport::<SUPPORT_WORDS>::singleton(root), logical)
                {
                    stats.nontrivial_supports += 1;
                    best_weight = 1;
                    best_support = PackedSupport::<SUPPORT_WORDS>::singleton(root);
                }
                continue;
            }
            let partial = self.search_syndrome_anchor_parallel(
                anchor,
                searched_maximum_weight,
                best_weight,
                pulse_interval,
            );
            merge_search_stats(&mut stats, partial.stats);
            if partial.best_weight < best_weight {
                best_weight = partial.best_weight;
                best_support = partial.best_support;
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

    #[inline]
    fn has_short_completion(&self, syndrome: PackedSyndrome<CHECK_WORDS>, additions: u16) -> bool {
        if syndrome.is_zero() {
            return true;
        }
        let key = wide_syndrome_key(syndrome);
        if additions >= 3 {
            return self.three_completion_bloom.contains_three(key);
        }
        self.short_completion_syndromes
            .iter()
            .take(usize::from(additions))
            .any(|syndromes| syndromes.binary_search(&key).is_ok())
    }

    #[inline]
    fn may_have_four_completion(&self, syndrome: PackedSyndrome<CHECK_WORDS>) -> bool {
        syndrome.is_zero()
            || self
                .four_completion_bloom
                .contains_one(wide_syndrome_key(syndrome))
    }

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
        let mut supports = vec![PackedSupport::<SUPPORT_WORDS>::default(); frame_count];
        let mut boundaries = vec![PackedSupport::<SUPPORT_WORDS>::default(); frame_count];
        let mut candidates = vec![PackedSupport::<SUPPORT_WORDS>::default(); frame_count];
        let mut syndromes = vec![PackedSyndrome::<CHECK_WORDS>::default(); frame_count];
        let mut logicals = vec![0u64; frame_count];
        let mut best_weight = searched_maximum_weight.saturating_add(1);
        let mut best_support = PackedSupport::<SUPPORT_WORDS>::default();
        let mut stats = ConnectedSearchStats::default();
        for &anchor in anchors {
            let root = usize::from(anchor);
            supports[0] = PackedSupport::<SUPPORT_WORDS>::singleton(root);
            boundaries[0] = self.neighbors[root];
            candidates[0] = boundaries[0];
            syndromes[0] = self.columns[root].syndrome;
            logicals[0] = self.columns[root].logical;
            stats.connected_supports += 1;
            stats.maximum_depth = stats.maximum_depth.max(1);
            if syndromes[0].is_zero() {
                stats.kernel_supports += 1;
                if self.logical_is_nonzero(supports[0], logicals[0]) {
                    stats.nontrivial_supports += 1;
                    best_weight = 1;
                    best_support = supports[0];
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
                    if self.logical_is_nonzero(child_support, child_logical) {
                        stats.nontrivial_supports += 1;
                        if child_weight < best_weight {
                            best_weight = child_weight;
                            best_support = child_support;
                        }
                    }
                }
                let improvement_budget = best_weight.saturating_sub(child_weight + 1);
                if child_weight >= searched_maximum_weight
                    || self.completion_lower_bound_exceeds(child_syndrome, improvement_budget)
                {
                    stats.syndrome_bound_prunes += 1;
                    continue;
                }
                let four_completion_reject =
                    improvement_budget == 4 && !self.may_have_four_completion(child_syndrome);
                if (improvement_budget <= 3
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
    pub fn maximum_column_check_weight(&self) -> u8 {
        self.maximum_column_check_weight
    }

    #[inline]
    pub fn kernel_weights_even(&self) -> bool {
        self.kernel_weights_even
    }

    #[inline]
    pub fn packed_storage_bytes(&self) -> usize {
        self.columns.len() * std::mem::size_of::<PackedColumn<CHECK_WORDS>>()
            + self.extra_logical_columns.len() * std::mem::size_of::<u64>()
            + self.neighbors.len() * std::mem::size_of::<PackedSupport<SUPPORT_WORDS>>()
    }
}

#[cfg(feature = "parallel")]
impl CompiledWideCssDistanceImpl<WIDE_SUPPORT_WORDS, WIDE_SYNDROME_WORDS> {
    pub fn search_bounded_syndrome_parallel_pulsed(
        &self,
        anchors: &[u16],
        maximum_weight: u16,
        pulse_interval: u64,
    ) -> Result<BoundedCssDistanceResult, CssDistanceError> {
        self.search_bounded_syndrome_parallel_pulsed_impl(anchors, maximum_weight, pulse_interval)
    }
}

#[cfg(feature = "parallel")]
impl CompiledWideCssDistanceImpl<EXTRA_WIDE_SUPPORT_WORDS, WIDE_SYNDROME_WORDS> {
    pub fn search_bounded_syndrome_parallel_pulsed(
        &self,
        anchors: &[u16],
        maximum_weight: u16,
        pulse_interval: u64,
    ) -> Result<BoundedCssDistanceResult, CssDistanceError> {
        self.search_bounded_syndrome_parallel_pulsed_impl(anchors, maximum_weight, pulse_interval)
    }
}

#[cfg(feature = "parallel")]
#[cfg(feature = "large-css")]
impl CompiledWideCssDistanceImpl<LARGE_SUPPORT_WORDS, LARGE_SYNDROME_WORDS, 1> {
    pub fn search_bounded_syndrome_parallel_pulsed(
        &self,
        anchors: &[u16],
        maximum_weight: u16,
        pulse_interval: u64,
    ) -> Result<BoundedCssDistanceResult, CssDistanceError> {
        self.search_bounded_syndrome_parallel_pulsed_impl(anchors, maximum_weight, pulse_interval)
    }
}

#[cfg(feature = "parallel")]
#[cfg(feature = "large-css")]
impl CompiledWideCssDistanceImpl<HUGE_SUPPORT_WORDS, HUGE_SYNDROME_WORDS, HUGE_LOGICAL_WORDS> {
    pub fn search_bounded_syndrome_parallel_pulsed(
        &self,
        anchors: &[u16],
        maximum_weight: u16,
        pulse_interval: u64,
    ) -> Result<BoundedCssDistanceResult, CssDistanceError> {
        self.search_bounded_syndrome_parallel_pulsed_impl(anchors, maximum_weight, pulse_interval)
    }
}

#[cfg(feature = "parallel")]
#[cfg(feature = "large-css")]
impl
    CompiledWideCssDistanceImpl<COLOSSAL_SUPPORT_WORDS, COLOSSAL_SYNDROME_WORDS, HUGE_LOGICAL_WORDS>
{
    pub fn search_bounded_syndrome_parallel_pulsed(
        &self,
        anchors: &[u16],
        maximum_weight: u16,
        pulse_interval: u64,
    ) -> Result<BoundedCssDistanceResult, CssDistanceError> {
        self.search_bounded_syndrome_parallel_pulsed_impl(anchors, maximum_weight, pulse_interval)
    }
}

struct HashingWriter<W> {
    inner: W,
    hasher: blake3::Hasher,
}

impl<W: Write> HashingWriter<W> {
    fn bytes(&mut self, bytes: &[u8]) -> io::Result<()> {
        self.inner.write_all(bytes)?;
        self.hasher.update(bytes);
        Ok(())
    }

    fn finish(mut self) -> io::Result<W> {
        let digest = self.hasher.finalize();
        self.inner.write_all(digest.as_bytes())?;
        Ok(self.inner)
    }
}

struct HashingReader<R> {
    inner: R,
    hasher: blake3::Hasher,
}

impl<R: Read> HashingReader<R> {
    fn bytes(&mut self, bytes: &mut [u8]) -> io::Result<()> {
        self.inner.read_exact(bytes)?;
        self.hasher.update(&*bytes);
        Ok(())
    }

    fn finish(mut self) -> Result<[u8; 32], CssDistanceArtifactError> {
        let actual = *self.hasher.finalize().as_bytes();
        let mut expected = [0u8; 32];
        self.inner.read_exact(&mut expected)?;
        if actual != expected {
            return Err(CssDistanceArtifactError::Checksum);
        }
        let mut trailing = [0u8; 1];
        if self.inner.read(&mut trailing)? != 0 {
            return Err(CssDistanceArtifactError::TrailingBytes);
        }
        Ok(actual)
    }
}

fn write_u16<W: Write>(writer: &mut HashingWriter<W>, value: u16) -> io::Result<()> {
    writer.bytes(&value.to_le_bytes())
}

fn write_u64<W: Write>(writer: &mut HashingWriter<W>, value: u64) -> io::Result<()> {
    writer.bytes(&value.to_le_bytes())
}

fn write_len<W: Write>(writer: &mut HashingWriter<W>, length: usize) -> io::Result<()> {
    let length = u32::try_from(length)
        .map_err(|_| io::Error::new(io::ErrorKind::InvalidInput, "artifact section too large"))?;
    writer.bytes(&length.to_le_bytes())
}

fn write_u64_slice<W: Write>(writer: &mut HashingWriter<W>, values: &[u64]) -> io::Result<()> {
    if cfg!(target_endian = "little") {
        return writer.bytes(bytemuck::cast_slice(values));
    }
    for &value in values {
        write_u64(writer, value)?;
    }
    Ok(())
}

fn read_u16<R: Read>(reader: &mut HashingReader<R>) -> io::Result<u16> {
    let mut bytes = [0u8; 2];
    reader.bytes(&mut bytes)?;
    Ok(u16::from_le_bytes(bytes))
}

fn read_u32<R: Read>(reader: &mut HashingReader<R>) -> io::Result<u32> {
    let mut bytes = [0u8; 4];
    reader.bytes(&mut bytes)?;
    Ok(u32::from_le_bytes(bytes))
}

fn read_u64<R: Read>(reader: &mut HashingReader<R>) -> io::Result<u64> {
    let mut bytes = [0u8; 8];
    reader.bytes(&mut bytes)?;
    Ok(u64::from_le_bytes(bytes))
}

fn read_len<R: Read>(
    reader: &mut HashingReader<R>,
    maximum: usize,
) -> Result<usize, CssDistanceArtifactError> {
    let length = read_u32(reader)? as usize;
    if length > maximum {
        return Err(CssDistanceArtifactError::Shape);
    }
    Ok(length)
}

fn read_syndromes<R: Read>(
    reader: &mut HashingReader<R>,
    maximum: usize,
) -> Result<Box<[u128]>, CssDistanceArtifactError> {
    let length = read_len(reader, maximum)?;
    let mut values = vec![0u128; length];
    for value in &mut values {
        let mut bytes = [0u8; 16];
        reader.bytes(&mut bytes)?;
        *value = u128::from_le_bytes(bytes);
    }
    Ok(values.into_boxed_slice())
}

fn read_bloom<R: Read>(
    reader: &mut HashingReader<R>,
) -> Result<CompletionBloom, CssDistanceArtifactError> {
    let length = read_len(reader, MAX_ARTIFACT_BLOOM_WORDS)?;
    if length == 0 || !length.is_power_of_two() {
        return Err(CssDistanceArtifactError::Shape);
    }
    let mut words = vec![0u64; length];
    if cfg!(target_endian = "little") {
        reader.bytes(bytemuck::cast_slice_mut(&mut words))?;
    } else {
        for word in &mut words {
            *word = read_u64(reader)?;
        }
    }
    Ok(CompletionBloom {
        words: words.into_boxed_slice(),
        bit_mask: (length * 64 - 1) as u64,
    })
}

fn strictly_sorted(values: &[u128]) -> bool {
    values.windows(2).all(|pair| pair[0] < pair[1])
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
    pub bound_improvements_published: u64,
    pub bound_pulses_observed: u64,
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

#[cfg(feature = "parallel")]
#[derive(Clone, Copy)]
struct RootBranch {
    root: u16,
    added: u16,
    remaining_root_candidates: PackedSupport,
}

#[cfg(feature = "parallel")]
#[repr(C, align(128))]
struct CachePaddedBranchResult {
    best_weight: u16,
    best_support: PackedSupport,
    stats: ConnectedSearchStats,
}

#[cfg(feature = "parallel")]
const _: () = assert!(std::mem::align_of::<CachePaddedBranchResult>() == 128);

#[cfg(feature = "parallel")]
#[repr(C, align(128))]
struct BoundMailbox(AtomicU16);

#[cfg(feature = "parallel")]
const _: () = assert!(std::mem::align_of::<BoundMailbox>() == 128);

#[cfg(feature = "parallel")]
struct BranchWorkspace {
    supports: Vec<PackedSupport>,
    boundaries: Vec<PackedSupport>,
    candidates: Vec<PackedSupport>,
    syndromes: Vec<PackedSyndrome>,
    logicals: Vec<u64>,
}

#[cfg(feature = "parallel")]
#[derive(Clone, Copy)]
struct WideRootBranch<const SUPPORT_WORDS: usize, const CHECK_WORDS: usize> {
    support: PackedSupport<SUPPORT_WORDS>,
    syndrome: PackedSyndrome<CHECK_WORDS>,
    logical: u64,
    forbidden: PackedSupport<SUPPORT_WORDS>,
    weight: u16,
}

#[cfg(feature = "parallel")]
#[repr(C, align(128))]
struct CachePaddedWideBranchResult<const SUPPORT_WORDS: usize> {
    best_weight: u16,
    best_support: PackedSupport<SUPPORT_WORDS>,
    stats: ConnectedSearchStats,
}

#[cfg(feature = "parallel")]
const _: () =
    assert!(std::mem::align_of::<CachePaddedWideBranchResult<WIDE_SUPPORT_WORDS>>() == 128);

#[cfg(feature = "parallel")]
#[derive(Clone, Copy, Default)]
struct WideBranchFrame<const SUPPORT_WORDS: usize, const CHECK_WORDS: usize> {
    support: PackedSupport<SUPPORT_WORDS>,
    forbidden: PackedSupport<SUPPORT_WORDS>,
    options: PackedSupport<SUPPORT_WORDS>,
    rejected: PackedSupport<SUPPORT_WORDS>,
    syndrome: PackedSyndrome<CHECK_WORDS>,
    logical: u64,
}

#[cfg(feature = "parallel")]
struct WideBranchWorkspace<const SUPPORT_WORDS: usize, const CHECK_WORDS: usize> {
    frames: Vec<WideBranchFrame<SUPPORT_WORDS, CHECK_WORDS>>,
}

#[cfg(feature = "parallel")]
impl<const SUPPORT_WORDS: usize, const CHECK_WORDS: usize>
    WideBranchWorkspace<SUPPORT_WORDS, CHECK_WORDS>
{
    fn new(frame_count: usize) -> Self {
        Self {
            frames: vec![WideBranchFrame::default(); frame_count],
        }
    }
}

#[cfg(feature = "parallel")]
impl BranchWorkspace {
    fn new(frame_count: usize) -> Self {
        Self {
            supports: vec![PackedSupport::default(); frame_count],
            boundaries: vec![PackedSupport::default(); frame_count],
            candidates: vec![PackedSupport::default(); frame_count],
            syndromes: vec![PackedSyndrome::<2>::default(); frame_count],
            logicals: vec![0; frame_count],
        }
    }
}

#[cfg(feature = "parallel")]
fn merge_search_stats(left: &mut ConnectedSearchStats, right: ConnectedSearchStats) {
    left.candidates += right.candidates;
    left.connected_supports += right.connected_supports;
    left.exclusive_extensions += right.exclusive_extensions;
    left.syndrome_bound_prunes += right.syndrome_bound_prunes;
    left.four_completion_prunes += right.four_completion_prunes;
    left.kernel_supports += right.kernel_supports;
    left.nontrivial_supports += right.nontrivial_supports;
    left.maximum_depth = left.maximum_depth.max(right.maximum_depth);
    left.bound_improvements_published += right.bound_improvements_published;
    left.bound_pulses_observed += right.bound_pulses_observed;
}

#[cfg(feature = "parallel")]
fn publish_bound(mailboxes: &[BoundMailbox], bound: u16) -> bool {
    let mut improved = false;
    for mailbox in mailboxes {
        improved |= mailbox.0.fetch_min(bound, Ordering::Relaxed) > bound;
    }
    improved
}

#[cfg(feature = "parallel")]
fn poll_bound(mailbox: &BoundMailbox, pruning_bound: &mut u16, stats: &mut ConnectedSearchStats) {
    let received = mailbox.0.load(Ordering::Relaxed);
    if received < *pruning_bound {
        *pruning_bound = received;
        stats.bound_pulses_observed += 1;
    }
}

impl CompiledCssDistance {
    fn source_sha256(physical: &Matrix, logical: &Matrix) -> [u8; 32] {
        let mut hasher = Sha256::new();
        hasher.update(b"ergodis-css-distance-source-v1\0");
        for dimension in [
            physical.rows(),
            physical.cols(),
            logical.rows(),
            logical.cols(),
        ] {
            hasher.update((dimension as u64).to_le_bytes());
        }
        hasher.update(physical.as_slice());
        hasher.update(logical.as_slice());
        hasher.finalize().into()
    }

    fn compile_structure(
        physical: &Matrix,
        logical: &Matrix,
    ) -> Result<CompiledStructure, CssDistanceError> {
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

        let mut columns = vec![PackedColumn::<2>::default(); coordinate_count];
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
        Ok(CompiledStructure {
            columns: columns.into_boxed_slice(),
            neighbors: neighbors.into_boxed_slice(),
            maximum_column_check_weight,
            kernel_weights_even,
        })
    }

    pub fn compile(physical: &Matrix, logical: &Matrix) -> Result<Self, CssDistanceError> {
        let coordinate_count = physical.cols();
        let structure = Self::compile_structure(physical, logical)?;
        let columns = structure.columns;
        let neighbors = structure.neighbors;
        let maximum_column_check_weight = structure.maximum_column_check_weight;
        let kernel_weights_even = structure.kernel_weights_even;
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
            columns,
            neighbors,
            short_completion_syndromes,
            three_completion_bloom,
            four_completion_bloom,
            coordinate_count: coordinate_count as u16,
            check_count: physical.rows() as u16,
            logical_count: logical.rows() as u8,
            maximum_column_check_weight,
            kernel_weights_even,
            source_sha256: Self::source_sha256(physical, logical),
            artifact_payload_blake3: None,
        })
    }

    /// Write the expensive completion filters as a versioned, checksummed cache artifact.
    pub fn write_artifact<W: Write>(&self, mut writer: W) -> Result<(), CssDistanceArtifactError> {
        writer.write_all(ARTIFACT_MAGIC)?;
        let mut writer = HashingWriter {
            inner: writer,
            hasher: blake3::Hasher::new(),
        };
        write_u16(&mut writer, ARTIFACT_VERSION)?;
        writer.bytes(&self.source_sha256)?;
        write_u16(&mut writer, self.coordinate_count)?;
        write_u16(&mut writer, self.check_count)?;
        writer.bytes(&[
            self.logical_count,
            self.maximum_column_check_weight,
            u8::from(self.kernel_weights_even),
            0,
        ])?;
        write_len(&mut writer, self.columns.len())?;
        for column in &self.columns {
            write_u64(&mut writer, column.syndrome.words[0])?;
            write_u64(&mut writer, column.syndrome.words[1])?;
            write_u64(&mut writer, column.logical)?;
        }
        write_len(&mut writer, self.neighbors.len())?;
        for support in &self.neighbors {
            for word in support.words {
                write_u64(&mut writer, word)?;
            }
        }
        for syndromes in &self.short_completion_syndromes {
            write_len(&mut writer, syndromes.len())?;
            for &syndrome in syndromes.iter() {
                writer.bytes(&syndrome.to_le_bytes())?;
            }
        }
        for bloom in [&self.three_completion_bloom, &self.four_completion_bloom] {
            write_len(&mut writer, bloom.words.len())?;
            write_u64_slice(&mut writer, &bloom.words)?;
        }
        let mut writer = writer.finish()?;
        writer.flush()?;
        Ok(())
    }

    /// Load a compiled cache only when it is bound to exactly these source matrices.
    pub fn read_artifact<R: Read>(
        physical: &Matrix,
        logical: &Matrix,
        mut reader: R,
    ) -> Result<Self, CssDistanceArtifactError> {
        let mut magic = [0u8; 8];
        reader.read_exact(&mut magic)?;
        if &magic != ARTIFACT_MAGIC {
            return Err(CssDistanceArtifactError::Format);
        }
        let mut reader = HashingReader {
            inner: reader,
            hasher: blake3::Hasher::new(),
        };
        if read_u16(&mut reader)? != ARTIFACT_VERSION {
            return Err(CssDistanceArtifactError::Format);
        }
        let mut source_sha256 = [0u8; 32];
        reader.bytes(&mut source_sha256)?;
        if source_sha256 != Self::source_sha256(physical, logical) {
            return Err(CssDistanceArtifactError::SourceMismatch);
        }
        let coordinate_count = read_u16(&mut reader)?;
        let check_count = read_u16(&mut reader)?;
        let mut flags = [0u8; 4];
        reader.bytes(&mut flags)?;
        let logical_count = flags[0];
        let maximum_column_check_weight = flags[1];
        let kernel_weights_even = match flags[2] {
            0 => false,
            1 => true,
            _ => return Err(CssDistanceArtifactError::Shape),
        };
        if flags[3] != 0
            || usize::from(coordinate_count) != physical.cols()
            || usize::from(check_count) != physical.rows()
            || usize::from(logical_count) != logical.rows()
        {
            return Err(CssDistanceArtifactError::Shape);
        }

        let column_len = read_len(&mut reader, MAX_COORDINATES)?;
        if column_len != usize::from(coordinate_count) {
            return Err(CssDistanceArtifactError::Shape);
        }
        let mut columns = vec![PackedColumn::<2>::default(); column_len];
        for column in &mut columns {
            column.syndrome.words[0] = read_u64(&mut reader)?;
            column.syndrome.words[1] = read_u64(&mut reader)?;
            column.logical = read_u64(&mut reader)?;
        }
        let neighbor_len = read_len(&mut reader, MAX_COORDINATES)?;
        if neighbor_len != column_len {
            return Err(CssDistanceArtifactError::Shape);
        }
        let mut neighbors = vec![PackedSupport::default(); neighbor_len];
        for support in &mut neighbors {
            for word in &mut support.words {
                *word = read_u64(&mut reader)?;
            }
        }
        let maximum_pairs = column_len.saturating_mul(column_len.saturating_sub(1)) / 2;
        let one_completion = read_syndromes(&mut reader, column_len)?;
        let two_completion = read_syndromes(&mut reader, maximum_pairs)?;
        let three_completion_bloom = read_bloom(&mut reader)?;
        let four_completion_bloom = read_bloom(&mut reader)?;
        let artifact_payload_blake3 = reader.finish()?;

        if !strictly_sorted(&one_completion) || !strictly_sorted(&two_completion) {
            return Err(CssDistanceArtifactError::Shape);
        }
        let expected = Self::compile_structure(physical, logical)?;
        if columns.as_slice() != expected.columns.as_ref()
            || neighbors.as_slice() != expected.neighbors.as_ref()
            || maximum_column_check_weight != expected.maximum_column_check_weight
            || kernel_weights_even != expected.kernel_weights_even
        {
            return Err(CssDistanceArtifactError::Shape);
        }
        Ok(Self {
            columns: columns.into_boxed_slice(),
            neighbors: neighbors.into_boxed_slice(),
            short_completion_syndromes: [one_completion, two_completion],
            three_completion_bloom,
            four_completion_bloom,
            coordinate_count,
            check_count,
            logical_count,
            maximum_column_check_weight,
            kernel_weights_even,
            source_sha256,
            artifact_payload_blake3: Some(artifact_payload_blake3),
        })
    }

    /// Payload checksum of a successfully loaded artifact.
    #[inline]
    pub fn artifact_payload_blake3(&self) -> Option<[u8; 32]> {
        self.artifact_payload_blake3
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
        let mut syndromes = vec![PackedSyndrome::<2>::default(); frame_count];
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

    #[cfg(feature = "parallel")]
    fn search_root_branch_partition(
        &self,
        branches: &[RootBranch],
        searched_maximum_weight: u16,
        mailboxes: &[BoundMailbox],
        pulse_interval: u64,
    ) -> CachePaddedBranchResult {
        let mut workspace = BranchWorkspace::new(usize::from(searched_maximum_weight));
        let mut best_weight = searched_maximum_weight.saturating_add(1);
        let worker_index = rayon::current_thread_index().unwrap_or(0) % mailboxes.len();
        let mailbox = &mailboxes[worker_index];
        let mut pruning_bound = best_weight;
        let mut best_support = PackedSupport::default();
        let mut stats = ConnectedSearchStats::default();

        for branch in branches {
            poll_bound(mailbox, &mut pruning_bound, &mut stats);
            let root = usize::from(branch.root);
            let added = usize::from(branch.added);
            workspace.supports[0] = PackedSupport::singleton(root);
            workspace.boundaries[0] = self.neighbors[root];
            workspace.candidates[0] = branch.remaining_root_candidates;
            workspace.syndromes[0] = self.columns[root].syndrome;
            workspace.logicals[0] = self.columns[root].logical;

            stats.candidates += 1;
            let mut child_support = workspace.supports[0];
            child_support.insert(added);
            stats.connected_supports += 1;
            stats.maximum_depth = stats.maximum_depth.max(2);
            let mut child_syndrome = workspace.syndromes[0];
            child_syndrome.toggle(self.columns[added].syndrome);
            let child_logical = workspace.logicals[0] ^ self.columns[added].logical;
            if child_syndrome.is_zero() {
                stats.kernel_supports += 1;
                if child_logical != 0 {
                    stats.nontrivial_supports += 1;
                    if best_weight > 2 {
                        best_weight = 2;
                        best_support = child_support;
                        pruning_bound = pruning_bound.min(2);
                        stats.bound_improvements_published +=
                            u64::from(publish_bound(mailboxes, 2));
                    }
                }
            }
            let improvement_budget = pruning_bound.saturating_sub(3);
            let cheap_bound = self.syndrome_completion_lower_bound(child_syndrome);
            let four_completion_reject =
                improvement_budget == 4 && !self.may_have_four_completion(child_syndrome);
            if searched_maximum_weight <= 2
                || cheap_bound > improvement_budget
                || (improvement_budget <= 3
                    && !self.has_short_completion(child_syndrome, improvement_budget))
                || four_completion_reject
            {
                stats.syndrome_bound_prunes += 1;
                stats.four_completion_prunes += u64::from(four_completion_reject);
                continue;
            }

            workspace.supports[1] = child_support;
            workspace.syndromes[1] = child_syndrome;
            workspace.logicals[1] = child_logical;
            let mut exclusive = self.neighbors[added];
            exclusive.difference_assign(workspace.boundaries[0]);
            exclusive.difference_assign(child_support);
            let mut child_boundary = workspace.boundaries[0];
            child_boundary.union_assign(self.neighbors[added]);
            child_boundary.difference_assign(child_support);
            workspace.boundaries[1] = child_boundary;
            let mut child_candidates = workspace.candidates[0];
            child_candidates.union_assign(exclusive);
            stats.exclusive_extensions += 1;
            workspace.candidates[1] = child_candidates;
            let mut depth = 1usize;

            loop {
                let Some(added) = workspace.candidates[depth].pop_lowest() else {
                    if depth == 1 {
                        break;
                    }
                    depth -= 1;
                    continue;
                };
                stats.candidates += 1;
                if pulse_interval != 0 && stats.candidates & (pulse_interval - 1) == 0 {
                    poll_bound(mailbox, &mut pruning_bound, &mut stats);
                }
                let child_depth = depth + 1;
                let child_weight = (child_depth + 1) as u16;
                let mut child_support = workspace.supports[depth];
                child_support.insert(added);
                stats.connected_supports += 1;
                stats.maximum_depth = stats.maximum_depth.max(child_weight);
                let mut child_syndrome = workspace.syndromes[depth];
                child_syndrome.toggle(self.columns[added].syndrome);
                let child_logical = workspace.logicals[depth] ^ self.columns[added].logical;
                if child_syndrome.is_zero() {
                    stats.kernel_supports += 1;
                    if child_logical != 0 {
                        stats.nontrivial_supports += 1;
                        if child_weight < best_weight {
                            best_weight = child_weight;
                            best_support = child_support;
                            pruning_bound = pruning_bound.min(child_weight);
                            stats.bound_improvements_published +=
                                u64::from(publish_bound(mailboxes, child_weight));
                        }
                    }
                }
                let improvement_budget = pruning_bound.saturating_sub(child_weight + 1);
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

                workspace.supports[child_depth] = child_support;
                workspace.syndromes[child_depth] = child_syndrome;
                workspace.logicals[child_depth] = child_logical;
                let mut exclusive = self.neighbors[added];
                exclusive.difference_assign(workspace.boundaries[depth]);
                exclusive.difference_assign(child_support);
                let mut child_boundary = workspace.boundaries[depth];
                child_boundary.union_assign(self.neighbors[added]);
                child_boundary.difference_assign(child_support);
                workspace.boundaries[child_depth] = child_boundary;
                let mut child_candidates = workspace.candidates[depth];
                child_candidates.union_assign(exclusive);
                stats.exclusive_extensions += 1;
                workspace.candidates[child_depth] = child_candidates;
                depth = child_depth;
            }
        }

        CachePaddedBranchResult {
            best_weight,
            best_support,
            stats,
        }
    }

    #[cfg(feature = "parallel")]
    fn search_bounded_root_parallel(
        &self,
        anchors: &[u16],
        searched_maximum_weight: u16,
        pulse_interval: u64,
    ) -> BoundedCssDistanceResult {
        use rayon::prelude::*;

        let mut best_weight = searched_maximum_weight.saturating_add(1);
        let mut best_support = PackedSupport::default();
        let mut stats = ConnectedSearchStats::default();
        let mut branches =
            Vec::with_capacity(anchors.len().saturating_mul(self.coordinate_count()));
        for &anchor in anchors {
            let root = usize::from(anchor);
            let support = PackedSupport::singleton(root);
            let syndrome = self.columns[root].syndrome;
            let logical = self.columns[root].logical;
            stats.connected_supports += 1;
            stats.maximum_depth = stats.maximum_depth.max(1);
            if syndrome.is_zero() {
                stats.kernel_supports += 1;
                if logical != 0 {
                    stats.nontrivial_supports += 1;
                    if best_weight > 1 {
                        best_weight = 1;
                        best_support = support;
                    }
                }
            }
            let mut remaining = self.neighbors[root];
            while let Some(added) = remaining.pop_lowest() {
                branches.push(RootBranch {
                    root: anchor,
                    added: added as u16,
                    remaining_root_candidates: remaining,
                });
            }
        }
        if best_weight == 1 || branches.is_empty() {
            return self.finish_packed_search(
                best_weight,
                best_support,
                searched_maximum_weight,
                stats,
            );
        }
        let partition_count = rayon::current_num_threads().min(branches.len());
        let partition_capacity = branches.len().div_ceil(partition_count);
        let mut partitions = (0..partition_count)
            .map(|_| Vec::with_capacity(partition_capacity))
            .collect::<Vec<_>>();
        for (index, branch) in branches.into_iter().enumerate() {
            partitions[index % partition_count].push(branch);
        }
        let mailboxes = (0..rayon::current_num_threads())
            .map(|_| BoundMailbox(AtomicU16::new(searched_maximum_weight.saturating_add(1))))
            .collect::<Vec<_>>();
        let partials = partitions
            .par_iter()
            .map(|partition| {
                self.search_root_branch_partition(
                    partition,
                    searched_maximum_weight,
                    &mailboxes,
                    pulse_interval,
                )
            })
            .collect::<Vec<_>>();
        for partial in partials {
            merge_search_stats(&mut stats, partial.stats);
            if partial.best_weight < best_weight {
                best_weight = partial.best_weight;
                best_support = partial.best_support;
            }
        }
        self.finish_packed_search(best_weight, best_support, searched_maximum_weight, stats)
    }

    #[cfg(feature = "parallel")]
    fn finish_packed_search(
        &self,
        best_weight: u16,
        best_support: PackedSupport,
        searched_maximum_weight: u16,
        stats: ConnectedSearchStats,
    ) -> BoundedCssDistanceResult {
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
        BoundedCssDistanceResult {
            distance: (best_weight <= searched_maximum_weight).then_some(best_weight),
            witness,
            searched_maximum_weight,
            stats,
        }
    }

    /// Search static anchor partitions with a 16384-candidate bound-pulse interval.
    #[cfg(feature = "parallel")]
    pub fn search_bounded_parallel(
        &self,
        anchors: &[u16],
        maximum_weight: u16,
    ) -> Result<BoundedCssDistanceResult, CssDistanceError> {
        self.search_bounded_parallel_pulsed(anchors, maximum_weight, 16384)
    }

    /// Iterative exact search with cache-line-separated bound pulses.
    ///
    /// Each worker polls only its own mailbox. A verified improvement performs a
    /// rare monotone broadcast; stale reads can add work but cannot affect exactness.
    /// Zero disables mid-branch polling. Nonzero intervals must be powers of two.
    #[cfg(feature = "parallel")]
    pub fn search_bounded_parallel_pulsed(
        &self,
        anchors: &[u16],
        maximum_weight: u16,
        pulse_interval: u64,
    ) -> Result<BoundedCssDistanceResult, CssDistanceError> {
        if pulse_interval != 0 && !pulse_interval.is_power_of_two() {
            return Err(CssDistanceError::InvalidPulseInterval);
        }
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
        let step = if self.kernel_weights_even { 2 } else { 1 };
        let mut cumulative_stats = ConnectedSearchStats::default();
        let mut limit = step;
        while limit <= searched_maximum_weight {
            let mut result =
                self.search_bounded_parallel_single_pulsed(anchors, limit, pulse_interval)?;
            merge_search_stats(&mut cumulative_stats, result.stats);
            if result.distance.is_some() {
                result.searched_maximum_weight = searched_maximum_weight;
                result.stats = cumulative_stats;
                return Ok(result);
            }
            limit += step;
        }
        Ok(BoundedCssDistanceResult {
            distance: None,
            witness: Box::default(),
            searched_maximum_weight,
            stats: cumulative_stats,
        })
    }

    #[cfg(feature = "parallel")]
    fn search_bounded_parallel_single_pulsed(
        &self,
        anchors: &[u16],
        maximum_weight: u16,
        pulse_interval: u64,
    ) -> Result<BoundedCssDistanceResult, CssDistanceError> {
        if pulse_interval != 0 && !pulse_interval.is_power_of_two() {
            return Err(CssDistanceError::InvalidPulseInterval);
        }
        if anchors.is_empty() {
            return self.search_bounded(anchors, maximum_weight);
        }
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
        if searched_maximum_weight < 2 {
            return self.search_bounded(anchors, maximum_weight);
        }
        let mut combined = BoundedCssDistanceResult {
            distance: None,
            witness: Box::default(),
            searched_maximum_weight,
            stats: ConnectedSearchStats::default(),
        };
        let mut active_maximum = searched_maximum_weight;
        for &anchor in anchors {
            let partial =
                self.search_bounded_root_parallel(&[anchor], active_maximum, pulse_interval);
            merge_search_stats(&mut combined.stats, partial.stats);
            let improves = match (partial.distance, combined.distance) {
                (Some(partial), Some(current)) => partial < current,
                (Some(_), None) => true,
                _ => false,
            };
            if improves {
                combined.distance = partial.distance;
                combined.witness = partial.witness;
                let distance = combined.distance.expect("improving result has a distance");
                active_maximum = distance.saturating_sub(1);
                if self.kernel_weights_even && active_maximum & 1 == 1 {
                    active_maximum -= 1;
                }
                if active_maximum == 0 {
                    break;
                }
            }
        }
        Ok(combined)
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
        let mut support: PackedSupport = PackedSupport::default();
        let mut syndrome = PackedSyndrome::<2>::default();
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

    /// Parallel counterpart of [`Self::certify_incumbent`].
    #[cfg(feature = "parallel")]
    pub fn certify_incumbent_parallel(
        &self,
        anchors: &[u16],
        incumbent: &[u16],
    ) -> Result<BoundedCssDistanceResult, CssDistanceError> {
        self.certify_incumbent_parallel_pulsed(anchors, incumbent, 16384)
    }

    /// Parallel incumbent certification with a configurable bound-pulse interval.
    #[cfg(feature = "parallel")]
    pub fn certify_incumbent_parallel_pulsed(
        &self,
        anchors: &[u16],
        incumbent: &[u16],
        pulse_interval: u64,
    ) -> Result<BoundedCssDistanceResult, CssDistanceError> {
        let replay = self.certify_incumbent(&[], incumbent)?;
        if incumbent.len() == 1 {
            return Ok(replay);
        }
        let mut result = self.search_bounded_parallel_single_pulsed(
            anchors,
            incumbent.len() as u16 - 1,
            pulse_interval,
        )?;
        if result.distance.is_none() {
            result.distance = replay.distance;
            result.witness = replay.witness;
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
                let expected = brute_force(&physical, &logical, 4);
                assert_eq!(result.distance, expected);
                let wide = CompiledWideCssDistance::compile(&physical, &logical).unwrap();
                let driven = wide
                    .search_bounded_syndrome_driven(&[0, 1, 2, 3], 4)
                    .unwrap();
                assert_eq!(driven.distance, expected);
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

    fn artifact_problem() -> (Matrix, Matrix) {
        (
            Matrix::new::<2>(2, 5, vec![1, 1, 0, 0, 0, 0, 1, 1, 1, 0]).unwrap(),
            Matrix::new::<2>(1, 5, vec![1, 0, 1, 0, 1]).unwrap(),
        )
    }

    #[test]
    fn compiled_artifact_round_trips_exact_search() {
        let (physical, logical) = artifact_problem();
        let compiled = CompiledCssDistance::compile(&physical, &logical).unwrap();
        let mut artifact = Vec::new();
        compiled.write_artifact(&mut artifact).unwrap();
        let loaded = CompiledCssDistance::read_artifact(&physical, &logical, &*artifact).unwrap();
        assert_eq!(
            loaded.search_bounded(&[0, 1, 2, 3, 4], 5).unwrap(),
            compiled.search_bounded(&[0, 1, 2, 3, 4], 5).unwrap()
        );
    }

    #[test]
    fn compiled_artifact_rejects_another_source() {
        let (physical, logical) = artifact_problem();
        let compiled = CompiledCssDistance::compile(&physical, &logical).unwrap();
        let mut artifact = Vec::new();
        compiled.write_artifact(&mut artifact).unwrap();
        let other_logical = Matrix::new::<2>(1, 5, vec![0, 0, 1, 0, 1]).unwrap();
        assert!(matches!(
            CompiledCssDistance::read_artifact(&physical, &other_logical, &*artifact),
            Err(CssDistanceArtifactError::SourceMismatch)
        ));
    }

    #[test]
    fn compiled_artifact_rejects_corruption_and_trailing_bytes() {
        let (physical, logical) = artifact_problem();
        let compiled = CompiledCssDistance::compile(&physical, &logical).unwrap();
        let mut artifact = Vec::new();
        compiled.write_artifact(&mut artifact).unwrap();
        let middle = artifact.len() / 2;
        artifact[middle] ^= 1;
        assert!(CompiledCssDistance::read_artifact(&physical, &logical, &*artifact).is_err());

        let mut artifact = Vec::new();
        compiled.write_artifact(&mut artifact).unwrap();
        artifact.push(0);
        assert!(matches!(
            CompiledCssDistance::read_artifact(&physical, &logical, &*artifact),
            Err(CssDistanceArtifactError::TrailingBytes)
        ));
    }

    #[test]
    fn wide_compiler_separates_presented_connectivity_from_syndrome_rank() {
        let columns = 288;
        let rows = 144;
        let mut physical_data = vec![0u8; rows * columns];
        for row in 0..rows {
            let pattern = row & 1;
            physical_data[row * columns + pattern] = 1;
            physical_data[row * columns + 2 + pattern] = 1;
        }
        let physical = Matrix::new::<2>(rows, columns, physical_data).unwrap();
        let mut logical_data = vec![0u8; columns];
        logical_data[0] = 1;
        let logical = Matrix::new::<2>(1, columns, logical_data).unwrap();
        assert_eq!(independent_row_indices(&physical).len(), 2);
        let compiled = compile_wide_structure::<WIDE_SUPPORT_WORDS, WIDE_SYNDROME_WORDS, 1>(
            &physical, &logical,
        )
        .unwrap();
        assert_eq!(compiled.columns.len(), 288);
        assert_eq!(compiled.check_count, 2);
        assert_eq!(compiled.maximum_column_check_weight, 1);
        assert!(!compiled.kernel_weights_even);
        assert_eq!(
            compiled.columns.len() * std::mem::size_of::<PackedColumn<WIDE_SYNDROME_WORDS>>()
                + compiled.neighbors.len()
                    * std::mem::size_of::<PackedSupport<WIDE_SUPPORT_WORDS>>(),
            columns
                * (std::mem::size_of::<PackedColumn<WIDE_SYNDROME_WORDS>>()
                    + std::mem::size_of::<PackedSupport<WIDE_SUPPORT_WORDS>>())
        );
    }

    #[test]
    fn wide_compiler_reaches_the_official_bb288_shape() {
        let ell = 12;
        let m = 12;
        let block = ell * m;
        let mut data = vec![0u8; block * 2 * block];
        for row_r in 0..ell {
            for row_s in 0..m {
                let row = row_r * m + row_s;
                let coordinates = [
                    ((row_r + 3) % ell) * m + row_s,
                    row_r * m + (row_s + 2) % m,
                    row_r * m + (row_s + 7) % m,
                    block + row_r * m + (row_s + 3) % m,
                    block + ((row_r + 1) % ell) * m + row_s,
                    block + ((row_r + 2) % ell) * m + row_s,
                ];
                for coordinate in coordinates {
                    data[row * 2 * block + coordinate] ^= 1;
                }
            }
        }
        let physical = Matrix::new::<2>(block, 2 * block, data).unwrap();
        let logical = Matrix::new::<2>(1, 2 * block, vec![0; 2 * block]).unwrap();
        let compiled = compile_wide_structure::<WIDE_SUPPORT_WORDS, WIDE_SYNDROME_WORDS, 1>(
            &physical, &logical,
        )
        .unwrap();
        assert_eq!(compiled.columns.len(), 288);
        assert_eq!(compiled.check_count, 138);
    }

    #[test]
    fn extra_wide_compiler_reaches_the_official_bb360_shape() {
        let columns = 360;
        let rows = 180;
        let mut physical_data = vec![0u8; rows * columns];
        for row in 0..rows {
            physical_data[row * columns + row] = 1;
            physical_data[row * columns + (row + 1) % rows] = 1;
            physical_data[row * columns + rows + row] = 1;
        }
        let physical = Matrix::new::<2>(rows, columns, physical_data).unwrap();
        let mut logical_data = vec![0u8; columns];
        logical_data[0] = 1;
        let logical = Matrix::new::<2>(1, columns, logical_data).unwrap();
        let compiled = CompiledExtraWideCssDistance::compile(&physical, &logical).unwrap();
        assert_eq!(compiled.coordinate_count(), columns);
        assert_eq!(compiled.check_count(), rows);
    }

    #[cfg(feature = "large-css")]
    #[test]
    fn large_compiler_reaches_the_official_bb756_shape() {
        let ell = 21;
        let m = 18;
        let block = ell * m;
        let columns = 2 * block;
        let mut data = vec![0u8; block * columns];
        for x in 0..ell {
            for y in 0..m {
                let row = x * m + y;
                let coordinates = [
                    ((x + 3) % ell) * m + y,
                    x * m + (y + 10) % m,
                    x * m + (y + 17) % m,
                    block + x * m + (y + 5) % m,
                    block + ((x + 3) % ell) * m + y,
                    block + ((x + 19) % ell) * m + y,
                ];
                for coordinate in coordinates {
                    data[row * columns + coordinate] ^= 1;
                }
            }
        }
        let physical = Matrix::new::<2>(block, columns, data).unwrap();
        let logical = Matrix::new::<2>(1, columns, vec![0; columns]).unwrap();
        let compiled = compile_wide_structure::<LARGE_SUPPORT_WORDS, LARGE_SYNDROME_WORDS, 1>(
            &physical, &logical,
        )
        .unwrap();
        assert_eq!(compiled.columns.len(), 756);
        assert_eq!(compiled.check_count, 370);
        assert_eq!(compiled.maximum_column_check_weight, 3);
        assert!(compiled.kernel_weights_even);
    }

    #[cfg(feature = "large-css")]
    #[test]
    fn large_compiler_reaches_the_official_bb784_shape() {
        let ell = 28;
        let m = 14;
        let block = ell * m;
        let columns = 2 * block;
        let mut data = vec![0u8; block * columns];
        for x in 0..ell {
            for y in 0..m {
                let row = x * m + y;
                let coordinates = [
                    ((x + 26) % ell) * m + y,
                    x * m + (y + 6) % m,
                    x * m + (y + 8) % m,
                    block + x * m + (y + 7) % m,
                    block + ((x + 9) % ell) * m + y,
                    block + ((x + 20) % ell) * m + y,
                ];
                for coordinate in coordinates {
                    data[row * columns + coordinate] ^= 1;
                }
            }
        }
        let physical = Matrix::new::<2>(block, columns, data).unwrap();
        let logical = Matrix::new::<2>(1, columns, vec![0; columns]).unwrap();
        let compiled = compile_wide_structure::<LARGE_SUPPORT_WORDS, LARGE_SYNDROME_WORDS, 1>(
            &physical, &logical,
        )
        .unwrap();
        assert_eq!(compiled.columns.len(), 784);
        assert_eq!(compiled.check_count, 380);
        assert_eq!(compiled.maximum_column_check_weight, 3);
        assert!(compiled.kernel_weights_even);
    }

    #[cfg(feature = "large-css")]
    #[test]
    fn large_search_checks_logicals_above_the_first_word() {
        let physical = Matrix::new::<2>(1, 1, vec![0]).unwrap();
        let mut logical_data = vec![0; 194];
        logical_data[193] = 1;
        let logical = Matrix::new::<2>(194, 1, logical_data).unwrap();
        let compiled = CompiledHugeCssDistance::compile(&physical, &logical).unwrap();
        let result = compiled.search_bounded_syndrome_driven(&[0], 1).unwrap();
        assert_eq!(result.distance, Some(1));
        assert_eq!(&*result.witness, &[0]);
    }

    #[test]
    fn wide_search_matches_compact_search_on_overlap_domain() {
        let (physical, logical) = artifact_problem();
        let compact = CompiledCssDistance::compile(&physical, &logical).unwrap();
        let wide = CompiledWideCssDistance::compile(&physical, &logical).unwrap();
        let anchors = [0, 1, 2, 3, 4];
        assert_eq!(
            wide.search_bounded(&anchors, 5).unwrap(),
            compact.search_bounded(&anchors, 5).unwrap()
        );
        let driven = wide.search_bounded_syndrome_driven(&anchors, 5).unwrap();
        assert_eq!(driven.distance, Some(1));
        assert_eq!(&*driven.witness, &[4]);
        let mut artifact = Vec::new();
        wide.write_artifact(&mut artifact).unwrap();
        let loaded =
            CompiledWideCssDistance::read_artifact(&physical, &logical, &*artifact).unwrap();
        assert!(loaded.artifact_payload_blake3().is_some());
        assert_eq!(
            loaded
                .search_bounded_syndrome_driven(&anchors, 5)
                .unwrap()
                .distance,
            driven.distance
        );
        #[cfg(feature = "parallel")]
        {
            let pool = rayon::ThreadPoolBuilder::new()
                .num_threads(3)
                .build()
                .unwrap();
            let parallel = pool
                .install(|| wide.search_bounded_syndrome_parallel_pulsed(&anchors, 5, 1))
                .unwrap();
            assert_eq!(parallel.distance, driven.distance);
            assert_eq!(parallel.witness, driven.witness);
        }
    }

    #[cfg(feature = "parallel")]
    #[test]
    fn static_parallel_anchor_partitions_match_sequential_answers() {
        let (physical, logical) = artifact_problem();
        let compiled = CompiledCssDistance::compile(&physical, &logical).unwrap();
        let anchors = [0, 1, 2, 3, 4];
        let pool = rayon::ThreadPoolBuilder::new()
            .num_threads(3)
            .build()
            .unwrap();
        let parallel = pool
            .install(|| compiled.search_bounded_parallel(&anchors, 5))
            .unwrap();
        let sequential = compiled.search_bounded(&anchors, 5).unwrap();
        assert_eq!(parallel.distance, sequential.distance);
        assert_eq!(parallel.witness, sequential.witness);

        let absent_logical = Matrix::new::<2>(1, 5, vec![0, 0, 0, 0, 0]).unwrap();
        let absent = CompiledCssDistance::compile(&physical, &absent_logical).unwrap();
        let parallel = pool
            .install(|| absent.search_bounded_parallel(&anchors, 5))
            .unwrap();
        let sequential = absent.search_bounded(&anchors, 5).unwrap();
        assert_eq!(parallel.distance, sequential.distance);
        assert_eq!(parallel.witness, sequential.witness);

        let wide_pool = rayon::ThreadPoolBuilder::new()
            .num_threads(8)
            .build()
            .unwrap();
        let root_partitioned = wide_pool
            .install(|| absent.search_bounded_parallel(&anchors, 5))
            .unwrap();
        assert_eq!(root_partitioned.distance, sequential.distance);
        assert_eq!(root_partitioned.witness, sequential.witness);
        let root_partitioned = wide_pool
            .install(|| compiled.search_bounded_parallel(&anchors, 5))
            .unwrap();
        assert_eq!(root_partitioned.distance, Some(1));
        assert_eq!(&*root_partitioned.witness, &[4]);

        assert!(matches!(
            wide_pool.install(|| compiled.search_bounded_parallel_pulsed(&anchors, 5, 3)),
            Err(CssDistanceError::InvalidPulseInterval)
        ));

        let physical = Matrix::new::<2>(1, 8, vec![1; 8]).unwrap();
        let logical = Matrix::new::<2>(1, 8, vec![1, 0, 1, 1, 1, 1, 1, 1]).unwrap();
        let pulsed = CompiledCssDistance::compile(&physical, &logical).unwrap();
        let answer = wide_pool
            .install(|| pulsed.search_bounded_parallel_pulsed(&[0], 4, 1))
            .unwrap();
        assert_eq!(answer.distance, Some(2));
        assert_eq!(&*answer.witness, &[0, 1]);
        assert!(answer.stats.bound_improvements_published >= 1);
    }
}
