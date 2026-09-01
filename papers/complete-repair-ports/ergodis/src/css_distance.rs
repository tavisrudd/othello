//! Exact bounded CSS-distance search over connected support representatives.
//!
//! A support in the kernel of the physical-check matrix decomposes into
//! connected components in the graph joining coordinates that occur in a
//! common check.  Every component is itself in the kernel.  Consequently, if
//! the support has a nonzero logical observation, at least one connected
//! component has a nonzero observation and no greater weight.  The search
//! below therefore enumerates only connected supports.

use crate::group_action::{
    compile_permutation_orbits, ExplicitPermutationAction, ExplicitPermutationError,
    FinitePermutationAction, OrbitCompileError, OrbitPartition,
};
use crate::matrix::{Matrix, MatrixError};
#[cfg(all(test, feature = "parallel"))]
use crate::test_alloc::{measure_allocations, HotLoopAllocationGuard};
use serde::Serialize;
use sha2::{Digest, Sha256};
use std::io::{self, Read, Write};
#[cfg(all(feature = "parallel", target_os = "linux"))]
use std::os::fd::{AsRawFd, FromRawFd, OwnedFd};
#[cfg(feature = "parallel")]
use std::sync::atomic::{AtomicBool, AtomicU16, Ordering};
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
#[cfg(feature = "large-css")]
const HUGE_LOGICAL_WORDS: usize = 4;
const FOUR_COMPLETION_BLOOM_BITS: usize = 1 << 27;
const MAX_ENUMERATED_FOUR_COMPLETIONS: usize = 10_000_000;
const MAX_ENUMERATED_THREE_COMPLETIONS: usize = 100_000_000;
const SYNDROME_PACKING_ADMISSION_MARGIN: u32 = 6;
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

#[inline]
fn wide_artifact_version_is_supported<const SUPPORT_WORDS: usize, const CHECK_WORDS: usize>(
    version: u16,
) -> bool {
    let (_, current) = wide_artifact_identity::<SUPPORT_WORDS, CHECK_WORDS>();
    version == current
        || (SUPPORT_WORDS == LARGE_SUPPORT_WORDS
            && CHECK_WORDS == LARGE_SYNDROME_WORDS
            && version == 1)
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
    #[error("CSS search shard count must be in 1..=4096 and index must be below count")]
    InvalidSearchShard,
    #[error("incumbent support is empty, repeated, or outside the coordinate range")]
    InvalidIncumbentSupport,
    #[error("incumbent support does not have zero physical syndrome")]
    IncumbentPhysicalSyndrome,
    #[error("incumbent support has zero logical observation")]
    IncumbentLogicalObservation,
    #[error("computed kernel-parity functional failed direct column validation")]
    InvalidKernelParityFunctional,
}

#[derive(Debug, Error)]
pub enum CssAnchorOrbitError {
    #[error("CSS symmetry matrices or generator tables have incompatible shapes")]
    Shape,
    #[error("a coordinate generator does not preserve the CSS search predicate")]
    NotAutomorphism,
    #[error("the proposed anchors are not exactly one representative per coordinate orbit")]
    NotTransversal,
    #[error(transparent)]
    Matrix(#[from] MatrixError),
    #[error(transparent)]
    Orbit(#[from] OrbitCompileError<ExplicitPermutationError>),
    #[error(transparent)]
    Action(#[from] ExplicitPermutationError),
}

/// Independently checkable coordinate-orbit reduction for CSS search anchors.
#[derive(Clone, Debug)]
pub struct CssAnchorOrbitCertificate {
    partition: OrbitPartition,
    anchors: Box<[u16]>,
    minimum_orbit_size: u32,
    maximum_orbit_size: u32,
}

impl CssAnchorOrbitCertificate {
    pub fn partition(&self) -> &OrbitPartition {
        &self.partition
    }

    pub fn anchors(&self) -> &[u16] {
        &self.anchors
    }

    pub fn minimum_orbit_size(&self) -> u32 {
        self.minimum_orbit_size
    }

    pub fn maximum_orbit_size(&self) -> u32 {
        self.maximum_orbit_size
    }
}

/// Verify that coordinate generators preserve the CSS search predicate and
/// that `anchors` contains exactly one point from every resulting orbit.
///
/// Preserving both `rowspan(physical)` and
/// `rowspan(physical) + rowspan(logical)` preserves, respectively, the
/// zero-syndrome condition and whether a zero-syndrome support has a nonzero
/// logical observation. No freeness or uniform-orbit assumption is needed.
pub fn verify_css_anchor_transversal(
    physical: &Matrix,
    logical: &Matrix,
    generator_images: impl Into<Box<[u32]>>,
    anchors: &[u16],
) -> Result<CssAnchorOrbitCertificate, CssAnchorOrbitError> {
    let coordinates = physical.cols();
    if coordinates == 0
        || logical.cols() != coordinates
        || logical.rows() == 0
        || physical.as_slice().iter().any(|&entry| entry > 1)
        || logical.as_slice().iter().any(|&entry| entry > 1)
    {
        return Err(CssAnchorOrbitError::Shape);
    }
    let action = ExplicitPermutationAction::new(coordinates, generator_images)?;
    let partition = compile_permutation_orbits(&action)?;
    let physical_basis = physical.canonical_row_basis::<2>()?;
    let combined = joined_binary_rows(physical, logical)?;
    let combined_basis = combined.canonical_row_basis::<2>()?;
    for generator in 0..action.generator_count() {
        let images = action.images(generator).ok_or(CssAnchorOrbitError::Shape)?;
        let permuted_physical = permute_binary_columns(physical, images)?;
        if permuted_physical.canonical_row_basis::<2>()? != physical_basis {
            return Err(CssAnchorOrbitError::NotAutomorphism);
        }
        let permuted_combined = permute_binary_columns(&combined, images)?;
        if permuted_combined.canonical_row_basis::<2>()? != combined_basis {
            return Err(CssAnchorOrbitError::NotAutomorphism);
        }
    }

    let mut seen = vec![false; partition.representatives().len()];
    for &anchor in anchors {
        let Some(orbit) = partition.orbit(u32::from(anchor)) else {
            return Err(CssAnchorOrbitError::NotTransversal);
        };
        let slot = &mut seen[orbit as usize];
        if *slot {
            return Err(CssAnchorOrbitError::NotTransversal);
        }
        *slot = true;
    }
    if seen.iter().any(|&covered| !covered) {
        return Err(CssAnchorOrbitError::NotTransversal);
    }
    let mut orbit_sizes = vec![0_u32; seen.len()];
    for point in 0..coordinates as u32 {
        orbit_sizes[partition.orbit(point).ok_or(CssAnchorOrbitError::Shape)? as usize] += 1;
    }
    Ok(CssAnchorOrbitCertificate {
        partition,
        anchors: anchors.to_vec().into_boxed_slice(),
        minimum_orbit_size: orbit_sizes.iter().copied().min().unwrap_or(0),
        maximum_orbit_size: orbit_sizes.iter().copied().max().unwrap_or(0),
    })
}

fn joined_binary_rows(left: &Matrix, right: &Matrix) -> Result<Matrix, MatrixError> {
    if left.cols() != right.cols() {
        return Err(MatrixError::Shape);
    }
    let mut data = Vec::with_capacity(left.as_slice().len() + right.as_slice().len());
    data.extend_from_slice(left.as_slice());
    data.extend_from_slice(right.as_slice());
    Matrix::new::<2>(left.rows() + right.rows(), left.cols(), data)
}

fn permute_binary_columns(matrix: &Matrix, images: &[u32]) -> Result<Matrix, MatrixError> {
    if matrix.cols() != images.len() {
        return Err(MatrixError::Shape);
    }
    let mut data = vec![0_u8; matrix.as_slice().len()];
    for row in 0..matrix.rows() {
        for (source, &target) in images.iter().enumerate() {
            let target = target as usize;
            if target >= matrix.cols() {
                return Err(MatrixError::Shape);
            }
            data[row * matrix.cols() + target] = matrix.row(row)[source];
        }
    }
    Matrix::new::<2>(matrix.rows(), matrix.cols(), data)
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

#[inline]
fn packed_dot_parity<const WORDS: usize>(
    left: PackedSyndrome<WORDS>,
    right: PackedSyndrome<WORDS>,
) -> u32 {
    left.words
        .iter()
        .zip(right.words)
        .fold(0_u64, |parity, (&left, right)| parity ^ (left & right))
        .count_ones()
        & 1
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
    hash_step_mask: u64,
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
            hash_step_mask: u64::MAX,
        }
    }

    fn new_adaptive(item_count: usize) -> Self {
        let mut bloom = Self::new(item_count);
        let bit_count = bloom.words.len() * 64;
        if bit_count < item_count.saturating_mul(3) {
            bloom.hash_step_mask = 0;
        }
        bloom
    }

    fn universal() -> Self {
        Self {
            words: vec![u64::MAX].into_boxed_slice(),
            bit_mask: 63,
            hash_step_mask: u64::MAX,
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
        let second = (Self::mix(high ^ low.rotate_left(41)) | 1) & self.hash_step_mask;
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

    #[inline]
    fn uses_one_hash(&self) -> bool {
        self.hash_step_mask == 0
    }
}

fn compile_completion_filters<const WORDS: usize>(
    columns: &[PackedColumn<WORDS>],
    key: fn(PackedSyndrome<WORDS>) -> u128,
) -> ([Box<[u128]>; 2], CompletionBloom, CompletionBloom) {
    let (one, keys) = prepare_completion_keys(columns, key, 4);
    let mut short = [Vec::new(), Vec::new(), Vec::new()];
    short[0] = one;
    short[1].reserve(keys.len().saturating_mul(keys.len().saturating_sub(1)) / 2);
    short[2].reserve(
        keys.len()
            .saturating_mul(keys.len().saturating_sub(1))
            .saturating_mul(keys.len().saturating_sub(2))
            / 6,
    );
    for left in 0..keys.len() {
        let left_key = keys[left];
        for middle in left + 1..keys.len() {
            let pair_key = left_key ^ keys[middle];
            short[1].push(pair_key);
            for &right_key in keys.iter().skip(middle + 1) {
                short[2].push(pair_key ^ right_key);
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
    let quadruple_count = distinct_quadruple_count(keys.len());
    let mut four_completion_bloom = CompletionBloom::new(quadruple_count);
    for syndromes in &short {
        for &syndrome in syndromes {
            four_completion_bloom.insert_one(syndrome);
        }
    }
    for first in 0..keys.len() {
        let first_key = keys[first];
        for second in first + 1..keys.len() {
            let pair_key = first_key ^ keys[second];
            for third in second + 1..keys.len() {
                let triple_key = pair_key ^ keys[third];
                for &fourth_key in keys.iter().skip(third + 1) {
                    four_completion_bloom.insert_one(triple_key ^ fourth_key);
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

fn distinct_quadruple_count(item_count: usize) -> usize {
    item_count
        .saturating_mul(item_count.saturating_sub(1))
        .saturating_mul(item_count.saturating_sub(2))
        .saturating_mul(item_count.saturating_sub(3))
        / 24
}

/// Replace equal projected column keys by at most the number that any retained
/// completion filter can consume.  For subsets of size at most `maximum`, this
/// preserves the exact set of possible XOR keys while bounding multiplicity.
fn prepare_completion_keys<const WORDS: usize>(
    columns: &[PackedColumn<WORDS>],
    key: fn(PackedSyndrome<WORDS>) -> u128,
    maximum: usize,
) -> (Vec<u128>, Vec<u128>) {
    let mut sorted = Vec::with_capacity(columns.len());
    sorted.extend(columns.iter().map(|column| key(column.syndrome)));
    sorted.sort_unstable();
    let mut unique = Vec::with_capacity(sorted.len());
    let mut capped = Vec::with_capacity(sorted.len());
    let mut start = 0usize;
    while start < sorted.len() {
        let value = sorted[start];
        let mut end = start + 1;
        while end < sorted.len() && sorted[end] == value {
            end += 1;
        }
        unique.push(value);
        capped.extend(std::iter::repeat_n(value, (end - start).min(maximum)));
        start = end;
    }
    (unique, capped)
}

fn populate_three_completion_bloom<const THREE_HASHES: bool>(
    one: &[u128],
    two: &[u128],
    keys: &[u128],
    bloom: &mut CompletionBloom,
) {
    for &key in one.iter().chain(two) {
        if THREE_HASHES {
            bloom.insert_three(key);
        } else {
            bloom.insert_one(key);
        }
    }
    for (left, &left_key) in keys.iter().enumerate() {
        for (middle, &middle_key) in keys.iter().enumerate().skip(left + 1) {
            let pair_key = left_key ^ middle_key;
            for &right_key in keys.iter().skip(middle + 1) {
                let key = pair_key ^ right_key;
                if THREE_HASHES {
                    bloom.insert_three(key);
                } else {
                    bloom.insert_one(key);
                }
            }
        }
    }
}

/// Memory-bounded completion filters for large codes.  Triple keys stream
/// directly into the Bloom filter instead of materializing O(n^3) u128s;
/// the optional four-completion rejection is conservatively disabled.
fn compile_large_completion_filters<const WORDS: usize>(
    columns: &[PackedColumn<WORDS>],
    key: fn(PackedSyndrome<WORDS>) -> u128,
) -> ([Box<[u128]>; 2], CompletionBloom, CompletionBloom) {
    let (one, keys) = prepare_completion_keys(columns, key, 3);
    let pair_count = keys.len().saturating_mul(keys.len().saturating_sub(1)) / 2;
    let triple_count = pair_count.saturating_mul(keys.len().saturating_sub(2)) / 3;
    let mut two = Vec::with_capacity(pair_count);
    for (left, &left_key) in keys.iter().enumerate() {
        for &middle_key in keys.iter().skip(left + 1) {
            let pair_key = left_key ^ middle_key;
            two.push(pair_key);
        }
    }
    two.sort_unstable();
    two.dedup();
    let three_completion_bloom = if triple_count <= MAX_ENUMERATED_THREE_COMPLETIONS {
        let mut bloom = CompletionBloom::new_adaptive(
            one.len()
                .saturating_add(pair_count)
                .saturating_add(triple_count),
        );
        if bloom.uses_one_hash() {
            populate_three_completion_bloom::<false>(&one, &two, &keys, &mut bloom);
        } else {
            populate_three_completion_bloom::<true>(&one, &two, &keys, &mut bloom);
        }
        bloom
    } else {
        CompletionBloom::universal()
    };
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
    kernel_parity_functional: PackedSyndrome<CHECK_WORDS>,
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
    kernel_parity_functional: PackedSyndrome<CHECK_WORDS>,
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

/// Recover a check-row functional whose value on every coordinate column is
/// one.  Such a functional exists exactly when every kernel word has even
/// Hamming weight.
fn binary_all_ones_functional<const WORDS: usize>(
    matrix: &Matrix,
    rows: &[usize],
    output_position: impl Fn(usize, usize) -> usize,
) -> Option<PackedSyndrome<WORDS>> {
    let support_words = matrix.cols().div_ceil(64);
    let mut pivots: Vec<(usize, Box<[u64]>, PackedSyndrome<WORDS>)> =
        Vec::with_capacity(rows.len());
    for (position, &row_index) in rows.iter().enumerate() {
        let mut words = vec![0_u64; support_words];
        for (coordinate, &entry) in matrix.row(row_index).iter().enumerate() {
            words[coordinate / 64] |= u64::from(entry & 1) << (coordinate % 64);
        }
        let mut label = PackedSyndrome::<WORDS>::default();
        let label_bit = output_position(position, row_index);
        if label_bit >= WORDS * 64 {
            return None;
        }
        label.words[label_bit / 64] |= 1_u64 << (label_bit % 64);
        for &(pivot, ref basis, basis_label) in &pivots {
            if words[pivot / 64] & (1_u64 << (pivot % 64)) != 0 {
                for (left, &right) in words.iter_mut().zip(basis.iter()) {
                    *left ^= right;
                }
                for (left, right) in label.words.iter_mut().zip(basis_label.words) {
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
        let insertion = pivots.partition_point(|&(existing, _, _)| existing > pivot);
        pivots.insert(insertion, (pivot, words.into_boxed_slice(), label));
    }

    let mut target = vec![u64::MAX; support_words];
    if let Some(last) = target.last_mut() {
        let remainder = matrix.cols() % 64;
        if remainder != 0 {
            *last = (1_u64 << remainder) - 1;
        }
    }
    let mut functional = PackedSyndrome::<WORDS>::default();
    for &(pivot, ref basis, basis_label) in &pivots {
        if target[pivot / 64] & (1_u64 << (pivot % 64)) != 0 {
            for (left, &right) in target.iter_mut().zip(basis.iter()) {
                *left ^= right;
            }
            for (left, right) in functional.words.iter_mut().zip(basis_label.words) {
                *left ^= right;
            }
        }
    }
    target.iter().all(|&word| word == 0).then_some(functional)
}

fn validates_all_ones_functional<const WORDS: usize>(
    functional: PackedSyndrome<WORDS>,
    columns: &[PackedColumn<WORDS>],
) -> bool {
    columns
        .iter()
        .all(|column| packed_dot_parity(functional, column.syndrome) == 1)
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
    let kernel_parity_functional =
        binary_all_ones_functional::<CHECK_WORDS>(physical, &basis, |position, _| position);
    if kernel_parity_functional
        .is_some_and(|functional| !validates_all_ones_functional(functional, &columns))
    {
        return Err(CssDistanceError::InvalidKernelParityFunctional);
    }
    let mut maximum_column_check_weight = 0u8;
    for (coordinate, column) in columns.iter().enumerate() {
        neighbors[coordinate].remove(coordinate);
        maximum_column_check_weight = maximum_column_check_weight
            .max(u8::try_from(column.syndrome.weight()).expect("wide check count is bounded"));
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
        kernel_weights_even: kernel_parity_functional.is_some(),
        kernel_parity_functional: kernel_parity_functional.unwrap_or_default(),
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
            if CHECK_WORDS > WIDE_SYNDROME_WORDS
                || distinct_quadruple_count(structure.columns.len())
                    > MAX_ENUMERATED_FOUR_COMPLETIONS
            {
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
            kernel_parity_functional: structure.kernel_parity_functional,
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
            u8::from(self.three_completion_bloom.uses_one_hash()),
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
        let (expected_magic, _) = wide_artifact_identity::<SUPPORT_WORDS, CHECK_WORDS>();
        let mut magic = [0u8; 8];
        reader.read_exact(&mut magic)?;
        if &magic != expected_magic {
            return Err(CssDistanceArtifactError::Format);
        }
        let mut reader = HashingReader {
            inner: reader,
            hasher: blake3::Hasher::new(),
        };
        let version = read_u16(&mut reader)?;
        if !wide_artifact_version_is_supported::<SUPPORT_WORDS, CHECK_WORDS>(version) {
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
        let three_uses_one_hash = match flags[3] {
            0 => false,
            1 => true,
            _ => return Err(CssDistanceArtifactError::Shape),
        };
        if usize::from(coordinate_count) != physical.cols()
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
        let mut three_completion_bloom = read_bloom(&mut reader)?;
        if three_uses_one_hash {
            three_completion_bloom.hash_step_mask = 0;
        }
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
            kernel_parity_functional: structure.kernel_parity_functional,
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

    /// Test whether greedy packing finds more disjoint neighborhoods than the budget.
    #[inline(always)]
    fn syndrome_packing_exceeds(
        &self,
        mut syndrome: PackedSyndrome<CHECK_WORDS>,
        maximum_permitted_lower_bound: u32,
    ) -> bool {
        let mut lower_bound = 0_u32;
        for word_index in 0..CHECK_WORDS {
            while syndrome.words[word_index] != 0 {
                let bit = syndrome.words[word_index].trailing_zeros() as usize;
                lower_bound += 1;
                if lower_bound > maximum_permitted_lower_bound {
                    return true;
                }
                let conflicts = self.check_conflicts[64 * word_index + bit].syndrome;
                debug_assert_ne!(conflicts.words[word_index] & (1_u64 << bit), 0);
                syndrome.difference_assign(conflicts);
            }
        }
        false
    }

    /// Test the cheap degree bound before paying for greedy conflict packing.
    #[inline(always)]
    fn completion_lower_bound_exceeds(
        &self,
        syndrome: PackedSyndrome<CHECK_WORDS>,
        budget: u16,
    ) -> bool {
        let syndrome_weight = syndrome.weight();
        let required_parity = packed_dot_parity(syndrome, self.kernel_parity_functional);
        let parity_adjustment =
            u32::from(self.kernel_weights_even) & ((u32::from(budget) ^ required_parity) & 1);
        // Only `(budget, parity_adjustment) == (0, 1)` wraps.  Returning a very
        // loose optional bound in that terminal case can add work but cannot
        // reject a valid completion; spelling it explicitly also keeps
        // overflow-checked campaign builds from panicking.
        let maximum_permitted_lower_bound = u32::from(budget).wrapping_sub(parity_adjustment);
        let degree = u32::from(self.maximum_column_check_weight);
        if degree == 0 {
            return syndrome_weight != 0 && budget != u16::MAX;
        }
        let degree_lower_bound = syndrome_weight.div_ceil(degree);
        if degree_lower_bound > maximum_permitted_lower_bound {
            return true;
        }
        // Packing only strengthens the degree bound, so omitting it far from
        // the cutoff can add work but can never prune a valid completion.
        degree_lower_bound.saturating_add(SYNDROME_PACKING_ADMISSION_MARGIN)
            > maximum_permitted_lower_bound
            && self.syndrome_packing_exceeds(syndrome, maximum_permitted_lower_bound)
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
    const PULSE: bool,
>(
    compiled: &CompiledWideCssDistanceImpl<SUPPORT_WORDS, CHECK_WORDS, LOGICAL_WORDS>,
    branches: &[WideRootBranch<SUPPORT_WORDS, CHECK_WORDS>],
    workspace: &mut WideBranchWorkspace<SUPPORT_WORDS, CHECK_WORDS>,
    searched_maximum_weight: u16,
    mailboxes: &[BoundMailbox],
    pulse_interval: u64,
) -> CachePaddedWideBranchResult<SUPPORT_WORDS>
where
    PackedSyndrome<CHECK_WORDS>: WideSyndrome,
{
    let worker_index = rayon::current_thread_index().unwrap_or(0) % mailboxes.len();
    let mailbox = &mailboxes[worker_index];
    let mut pruning_bound = mailbox.inbound_bound.load(Ordering::Relaxed);
    let mut best_weight = searched_maximum_weight.saturating_add(1);
    let mut best_support = PackedSupport::<SUPPORT_WORDS>::default();
    let mut stats = ConnectedSearchStats::default();
    for branch in branches {
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
            if PULSE && stats.candidates & (pulse_interval - 1) == 0 {
                check_bound_pulse(mailbox, &mut pruning_bound, &mut stats);
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
                        if child_weight < pruning_bound {
                            pruning_bound = child_weight;
                            publish_bound(mailbox, child_weight);
                            stats.bound_improvements_published += 1;
                        }
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
    stats.bound_pulses_observed &= BOUND_PULSE_COUNT_MASK;
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
        workspace: &mut WideBranchWorkspace<SUPPORT_WORDS, CHECK_WORDS>,
        searched_maximum_weight: u16,
        mailboxes: &[BoundMailbox],
        pulse_interval: u64,
    ) -> CachePaddedWideBranchResult<SUPPORT_WORDS>;

    fn search_partition_unpulsed(
        &self,
        branches: &[WideRootBranch<SUPPORT_WORDS, CHECK_WORDS>],
        workspace: &mut WideBranchWorkspace<SUPPORT_WORDS, CHECK_WORDS>,
        searched_maximum_weight: u16,
        mailboxes: &[BoundMailbox],
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
    workspace: &mut WideBranchWorkspace<WIDE_SUPPORT_WORDS, WIDE_SYNDROME_WORDS>,
    searched_maximum_weight: u16,
    mailboxes: &[BoundMailbox],
    pulse_interval: u64,
) -> CachePaddedWideBranchResult<WIDE_SUPPORT_WORDS> {
    search_syndrome_branch_partition_impl::<WIDE_SUPPORT_WORDS, WIDE_SYNDROME_WORDS, 1, true>(
        compiled,
        branches,
        workspace,
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
    workspace: &mut WideBranchWorkspace<EXTRA_WIDE_SUPPORT_WORDS, WIDE_SYNDROME_WORDS>,
    searched_maximum_weight: u16,
    mailboxes: &[BoundMailbox],
    pulse_interval: u64,
) -> CachePaddedWideBranchResult<EXTRA_WIDE_SUPPORT_WORDS> {
    search_syndrome_branch_partition_impl::<EXTRA_WIDE_SUPPORT_WORDS, WIDE_SYNDROME_WORDS, 1, true>(
        compiled,
        branches,
        workspace,
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
    workspace: &mut WideBranchWorkspace<LARGE_SUPPORT_WORDS, LARGE_SYNDROME_WORDS>,
    searched_maximum_weight: u16,
    mailboxes: &[BoundMailbox],
    pulse_interval: u64,
) -> CachePaddedWideBranchResult<LARGE_SUPPORT_WORDS> {
    search_syndrome_branch_partition_impl::<LARGE_SUPPORT_WORDS, LARGE_SYNDROME_WORDS, 1, true>(
        compiled,
        branches,
        workspace,
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
    workspace: &mut WideBranchWorkspace<HUGE_SUPPORT_WORDS, HUGE_SYNDROME_WORDS>,
    searched_maximum_weight: u16,
    mailboxes: &[BoundMailbox],
    pulse_interval: u64,
) -> CachePaddedWideBranchResult<HUGE_SUPPORT_WORDS> {
    search_syndrome_branch_partition_impl::<
        HUGE_SUPPORT_WORDS,
        HUGE_SYNDROME_WORDS,
        HUGE_LOGICAL_WORDS,
        true,
    >(
        compiled,
        branches,
        workspace,
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
    workspace: &mut WideBranchWorkspace<COLOSSAL_SUPPORT_WORDS, COLOSSAL_SYNDROME_WORDS>,
    searched_maximum_weight: u16,
    mailboxes: &[BoundMailbox],
    pulse_interval: u64,
) -> CachePaddedWideBranchResult<COLOSSAL_SUPPORT_WORDS> {
    search_syndrome_branch_partition_impl::<
        COLOSSAL_SUPPORT_WORDS,
        COLOSSAL_SYNDROME_WORDS,
        HUGE_LOGICAL_WORDS,
        true,
    >(
        compiled,
        branches,
        workspace,
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
fn search_syndrome_branch_partition_wide_unpulsed(
    compiled: &CompiledWideCssDistance,
    branches: &[WideRootBranch<WIDE_SUPPORT_WORDS, WIDE_SYNDROME_WORDS>],
    workspace: &mut WideBranchWorkspace<WIDE_SUPPORT_WORDS, WIDE_SYNDROME_WORDS>,
    searched_maximum_weight: u16,
    mailboxes: &[BoundMailbox],
) -> CachePaddedWideBranchResult<WIDE_SUPPORT_WORDS> {
    search_syndrome_branch_partition_impl::<WIDE_SUPPORT_WORDS, WIDE_SYNDROME_WORDS, 1, false>(
        compiled,
        branches,
        workspace,
        searched_maximum_weight,
        mailboxes,
        0,
    )
}

#[cfg(feature = "parallel")]
#[multiversion::multiversion(
    targets("x86_64+avx+avx2+bmi1+bmi2+lzcnt+popcnt"),
    dispatcher = "indirect"
)]
fn search_syndrome_branch_partition_extra_wide_unpulsed(
    compiled: &CompiledExtraWideCssDistance,
    branches: &[WideRootBranch<EXTRA_WIDE_SUPPORT_WORDS, WIDE_SYNDROME_WORDS>],
    workspace: &mut WideBranchWorkspace<EXTRA_WIDE_SUPPORT_WORDS, WIDE_SYNDROME_WORDS>,
    searched_maximum_weight: u16,
    mailboxes: &[BoundMailbox],
) -> CachePaddedWideBranchResult<EXTRA_WIDE_SUPPORT_WORDS> {
    search_syndrome_branch_partition_impl::<EXTRA_WIDE_SUPPORT_WORDS, WIDE_SYNDROME_WORDS, 1, false>(
        compiled,
        branches,
        workspace,
        searched_maximum_weight,
        mailboxes,
        0,
    )
}

#[cfg(feature = "parallel")]
#[cfg(feature = "large-css")]
#[multiversion::multiversion(
    targets("x86_64+avx+avx2+bmi1+bmi2+lzcnt+popcnt"),
    dispatcher = "indirect"
)]
fn search_syndrome_branch_partition_large_unpulsed(
    compiled: &CompiledLargeCssDistance,
    branches: &[WideRootBranch<LARGE_SUPPORT_WORDS, LARGE_SYNDROME_WORDS>],
    workspace: &mut WideBranchWorkspace<LARGE_SUPPORT_WORDS, LARGE_SYNDROME_WORDS>,
    searched_maximum_weight: u16,
    mailboxes: &[BoundMailbox],
) -> CachePaddedWideBranchResult<LARGE_SUPPORT_WORDS> {
    search_syndrome_branch_partition_impl::<LARGE_SUPPORT_WORDS, LARGE_SYNDROME_WORDS, 1, false>(
        compiled,
        branches,
        workspace,
        searched_maximum_weight,
        mailboxes,
        0,
    )
}

#[cfg(feature = "parallel")]
#[cfg(feature = "large-css")]
#[multiversion::multiversion(
    targets("x86_64+avx+avx2+bmi1+bmi2+lzcnt+popcnt"),
    dispatcher = "indirect"
)]
fn search_syndrome_branch_partition_huge_unpulsed(
    compiled: &CompiledHugeCssDistance,
    branches: &[WideRootBranch<HUGE_SUPPORT_WORDS, HUGE_SYNDROME_WORDS>],
    workspace: &mut WideBranchWorkspace<HUGE_SUPPORT_WORDS, HUGE_SYNDROME_WORDS>,
    searched_maximum_weight: u16,
    mailboxes: &[BoundMailbox],
) -> CachePaddedWideBranchResult<HUGE_SUPPORT_WORDS> {
    search_syndrome_branch_partition_impl::<
        HUGE_SUPPORT_WORDS,
        HUGE_SYNDROME_WORDS,
        HUGE_LOGICAL_WORDS,
        false,
    >(
        compiled,
        branches,
        workspace,
        searched_maximum_weight,
        mailboxes,
        0,
    )
}

#[cfg(feature = "parallel")]
#[cfg(feature = "large-css")]
#[multiversion::multiversion(
    targets("x86_64+avx+avx2+bmi1+bmi2+lzcnt+popcnt"),
    dispatcher = "indirect"
)]
fn search_syndrome_branch_partition_colossal_unpulsed(
    compiled: &CompiledColossalCssDistance,
    branches: &[WideRootBranch<COLOSSAL_SUPPORT_WORDS, COLOSSAL_SYNDROME_WORDS>],
    workspace: &mut WideBranchWorkspace<COLOSSAL_SUPPORT_WORDS, COLOSSAL_SYNDROME_WORDS>,
    searched_maximum_weight: u16,
    mailboxes: &[BoundMailbox],
) -> CachePaddedWideBranchResult<COLOSSAL_SUPPORT_WORDS> {
    search_syndrome_branch_partition_impl::<
        COLOSSAL_SUPPORT_WORDS,
        COLOSSAL_SYNDROME_WORDS,
        HUGE_LOGICAL_WORDS,
        false,
    >(
        compiled,
        branches,
        workspace,
        searched_maximum_weight,
        mailboxes,
        0,
    )
}

#[cfg(feature = "parallel")]
impl WidePartitionKernel<WIDE_SUPPORT_WORDS, WIDE_SYNDROME_WORDS> for CompiledWideCssDistance {
    #[inline]
    fn search_partition(
        &self,
        branches: &[WideRootBranch<WIDE_SUPPORT_WORDS, WIDE_SYNDROME_WORDS>],
        workspace: &mut WideBranchWorkspace<WIDE_SUPPORT_WORDS, WIDE_SYNDROME_WORDS>,
        searched_maximum_weight: u16,
        mailboxes: &[BoundMailbox],
        pulse_interval: u64,
    ) -> CachePaddedWideBranchResult<WIDE_SUPPORT_WORDS> {
        search_syndrome_branch_partition_wide(
            self,
            branches,
            workspace,
            searched_maximum_weight,
            mailboxes,
            pulse_interval,
        )
    }

    #[inline]
    fn search_partition_unpulsed(
        &self,
        branches: &[WideRootBranch<WIDE_SUPPORT_WORDS, WIDE_SYNDROME_WORDS>],
        workspace: &mut WideBranchWorkspace<WIDE_SUPPORT_WORDS, WIDE_SYNDROME_WORDS>,
        searched_maximum_weight: u16,
        mailboxes: &[BoundMailbox],
    ) -> CachePaddedWideBranchResult<WIDE_SUPPORT_WORDS> {
        search_syndrome_branch_partition_wide_unpulsed(
            self,
            branches,
            workspace,
            searched_maximum_weight,
            mailboxes,
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
        workspace: &mut WideBranchWorkspace<EXTRA_WIDE_SUPPORT_WORDS, WIDE_SYNDROME_WORDS>,
        searched_maximum_weight: u16,
        mailboxes: &[BoundMailbox],
        pulse_interval: u64,
    ) -> CachePaddedWideBranchResult<EXTRA_WIDE_SUPPORT_WORDS> {
        search_syndrome_branch_partition_extra_wide(
            self,
            branches,
            workspace,
            searched_maximum_weight,
            mailboxes,
            pulse_interval,
        )
    }

    #[inline]
    fn search_partition_unpulsed(
        &self,
        branches: &[WideRootBranch<EXTRA_WIDE_SUPPORT_WORDS, WIDE_SYNDROME_WORDS>],
        workspace: &mut WideBranchWorkspace<EXTRA_WIDE_SUPPORT_WORDS, WIDE_SYNDROME_WORDS>,
        searched_maximum_weight: u16,
        mailboxes: &[BoundMailbox],
    ) -> CachePaddedWideBranchResult<EXTRA_WIDE_SUPPORT_WORDS> {
        search_syndrome_branch_partition_extra_wide_unpulsed(
            self,
            branches,
            workspace,
            searched_maximum_weight,
            mailboxes,
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
        workspace: &mut WideBranchWorkspace<LARGE_SUPPORT_WORDS, LARGE_SYNDROME_WORDS>,
        searched_maximum_weight: u16,
        mailboxes: &[BoundMailbox],
        pulse_interval: u64,
    ) -> CachePaddedWideBranchResult<LARGE_SUPPORT_WORDS> {
        search_syndrome_branch_partition_large(
            self,
            branches,
            workspace,
            searched_maximum_weight,
            mailboxes,
            pulse_interval,
        )
    }

    #[inline]
    fn search_partition_unpulsed(
        &self,
        branches: &[WideRootBranch<LARGE_SUPPORT_WORDS, LARGE_SYNDROME_WORDS>],
        workspace: &mut WideBranchWorkspace<LARGE_SUPPORT_WORDS, LARGE_SYNDROME_WORDS>,
        searched_maximum_weight: u16,
        mailboxes: &[BoundMailbox],
    ) -> CachePaddedWideBranchResult<LARGE_SUPPORT_WORDS> {
        search_syndrome_branch_partition_large_unpulsed(
            self,
            branches,
            workspace,
            searched_maximum_weight,
            mailboxes,
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
        workspace: &mut WideBranchWorkspace<HUGE_SUPPORT_WORDS, HUGE_SYNDROME_WORDS>,
        searched_maximum_weight: u16,
        mailboxes: &[BoundMailbox],
        pulse_interval: u64,
    ) -> CachePaddedWideBranchResult<HUGE_SUPPORT_WORDS> {
        search_syndrome_branch_partition_huge(
            self,
            branches,
            workspace,
            searched_maximum_weight,
            mailboxes,
            pulse_interval,
        )
    }

    #[inline]
    fn search_partition_unpulsed(
        &self,
        branches: &[WideRootBranch<HUGE_SUPPORT_WORDS, HUGE_SYNDROME_WORDS>],
        workspace: &mut WideBranchWorkspace<HUGE_SUPPORT_WORDS, HUGE_SYNDROME_WORDS>,
        searched_maximum_weight: u16,
        mailboxes: &[BoundMailbox],
    ) -> CachePaddedWideBranchResult<HUGE_SUPPORT_WORDS> {
        search_syndrome_branch_partition_huge_unpulsed(
            self,
            branches,
            workspace,
            searched_maximum_weight,
            mailboxes,
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
        workspace: &mut WideBranchWorkspace<COLOSSAL_SUPPORT_WORDS, COLOSSAL_SYNDROME_WORDS>,
        searched_maximum_weight: u16,
        mailboxes: &[BoundMailbox],
        pulse_interval: u64,
    ) -> CachePaddedWideBranchResult<COLOSSAL_SUPPORT_WORDS> {
        search_syndrome_branch_partition_colossal(
            self,
            branches,
            workspace,
            searched_maximum_weight,
            mailboxes,
            pulse_interval,
        )
    }

    #[inline]
    fn search_partition_unpulsed(
        &self,
        branches: &[WideRootBranch<COLOSSAL_SUPPORT_WORDS, COLOSSAL_SYNDROME_WORDS>],
        workspace: &mut WideBranchWorkspace<COLOSSAL_SUPPORT_WORDS, COLOSSAL_SYNDROME_WORDS>,
        searched_maximum_weight: u16,
        mailboxes: &[BoundMailbox],
    ) -> CachePaddedWideBranchResult<COLOSSAL_SUPPORT_WORDS> {
        search_syndrome_branch_partition_colossal_unpulsed(
            self,
            branches,
            workspace,
            searched_maximum_weight,
            mailboxes,
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
        shard: Option<CssSearchShard>,
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
        let target_branches = shard.map_or_else(
            || rayon::current_num_threads().saturating_mul(4),
            |shard| usize::try_from(shard.count()).unwrap().saturating_mul(16),
        );
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
        if let Some(shard) = shard {
            let count = usize::try_from(shard.count()).unwrap();
            let index = usize::try_from(shard.index()).unwrap();
            branches = branches
                .into_iter()
                .enumerate()
                .filter_map(|(branch_index, branch)| {
                    (branch_index % count == index).then_some(branch)
                })
                .collect();
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
        let mut workspaces = (0..partition_count)
            .map(|_| {
                WideBranchWorkspace::<SUPPORT_WORDS, CHECK_WORDS>::new(usize::from(
                    searched_maximum_weight,
                ))
            })
            .collect::<Vec<_>>();
        let mut partials = (0..partition_count)
            .map(|_| CachePaddedWideBranchResult {
                best_weight: searched_maximum_weight.saturating_add(1),
                best_support: PackedSupport::default(),
                stats: ConnectedSearchStats::default(),
            })
            .collect::<Vec<_>>();
        let events = (pulse_interval != 0 && thread_count > 1)
            .then(|| BoundControllerEvents::new(thread_count))
            .flatten();
        let worker_pulse_interval = if events.is_some() { pulse_interval } else { 0 };
        let mailboxes = (0..thread_count)
            .map(|worker| {
                BoundMailbox::new(
                    active_bound,
                    events
                        .as_ref()
                        .map_or(-1, |events| events.worker_fd(worker)),
                )
            })
            .collect::<Vec<_>>();
        #[cfg(test)]
        let allocation_measurement = crate::test_alloc::current_measurement();
        let mut search = || {
            partitions
                .par_iter()
                .zip(workspaces.par_iter_mut())
                .zip(partials.par_iter_mut())
                .for_each(|((partition, workspace), result)| {
                    #[cfg(test)]
                    let _allocation_guard =
                        HotLoopAllocationGuard::enter_for(allocation_measurement);
                    if worker_pulse_interval == 0 {
                        *result = self.search_partition_unpulsed(
                            partition,
                            workspace,
                            searched_maximum_weight,
                            &mailboxes,
                        );
                    } else {
                        *result = self.search_partition(
                            partition,
                            workspace,
                            searched_maximum_weight,
                            &mailboxes,
                            worker_pulse_interval,
                        );
                    }
                });
        };
        match &events {
            Some(events) => with_bound_controller(&mailboxes, events, search),
            None => search(),
        };
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
        shard: Option<CssSearchShard>,
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
                shard,
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

    fn checked_incumbent_result(
        &self,
        incumbent: &[u16],
    ) -> Result<BoundedCssDistanceResult, CssDistanceError> {
        if incumbent.is_empty() || incumbent.len() > self.coordinate_count() {
            return Err(CssDistanceError::InvalidIncumbentSupport);
        }
        let mut support = PackedSupport::<SUPPORT_WORDS>::default();
        let mut syndrome = PackedSyndrome::<CHECK_WORDS>::default();
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
        if !self.logical_is_nonzero(support, logical) {
            return Err(CssDistanceError::IncumbentLogicalObservation);
        }
        Ok(BoundedCssDistanceResult {
            distance: Some(incumbent.len() as u16),
            witness: incumbent.to_vec().into_boxed_slice(),
            searched_maximum_weight: 0,
            stats: ConnectedSearchStats::default(),
        })
    }

    /// Replay an incumbent and close every strictly smaller weight.
    pub fn certify_incumbent_syndrome_driven(
        &self,
        anchors: &[u16],
        incumbent: &[u16],
    ) -> Result<BoundedCssDistanceResult, CssDistanceError> {
        let replay = self.checked_incumbent_result(incumbent)?;
        if incumbent.len() == 1 {
            return Ok(replay);
        }
        let mut result =
            self.search_bounded_syndrome_driven(anchors, incumbent.len() as u16 - 1)?;
        if result.distance.is_none() {
            result.distance = replay.distance;
            result.witness = replay.witness;
        }
        Ok(result)
    }

    #[cfg(feature = "parallel")]
    fn certify_incumbent_parallel_pulsed_impl(
        &self,
        anchors: &[u16],
        incumbent: &[u16],
        pulse_interval: u64,
    ) -> Result<BoundedCssDistanceResult, CssDistanceError>
    where
        Self: WidePartitionKernel<SUPPORT_WORDS, CHECK_WORDS>,
    {
        let replay = self.checked_incumbent_result(incumbent)?;
        if incumbent.len() == 1 {
            return Ok(replay);
        }
        let mut result = self.search_bounded_syndrome_parallel_pulsed_impl(
            anchors,
            incumbent.len() as u16 - 1,
            pulse_interval,
            None,
        )?;
        if result.distance.is_none() {
            result.distance = replay.distance;
            result.witness = replay.witness;
        }
        Ok(result)
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
        self.search_bounded_syndrome_parallel_pulsed_impl(
            anchors,
            maximum_weight,
            pulse_interval,
            None,
        )
    }

    pub fn search_bounded_syndrome_parallel_pulsed_shard(
        &self,
        anchors: &[u16],
        maximum_weight: u16,
        pulse_interval: u64,
        shard: CssSearchShard,
    ) -> Result<BoundedCssDistanceResult, CssDistanceError> {
        self.search_bounded_syndrome_parallel_pulsed_impl(
            anchors,
            maximum_weight,
            pulse_interval,
            Some(shard),
        )
    }

    pub fn certify_incumbent_parallel_pulsed(
        &self,
        anchors: &[u16],
        incumbent: &[u16],
        pulse_interval: u64,
    ) -> Result<BoundedCssDistanceResult, CssDistanceError> {
        self.certify_incumbent_parallel_pulsed_impl(anchors, incumbent, pulse_interval)
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
        self.search_bounded_syndrome_parallel_pulsed_impl(
            anchors,
            maximum_weight,
            pulse_interval,
            None,
        )
    }

    pub fn search_bounded_syndrome_parallel_pulsed_shard(
        &self,
        anchors: &[u16],
        maximum_weight: u16,
        pulse_interval: u64,
        shard: CssSearchShard,
    ) -> Result<BoundedCssDistanceResult, CssDistanceError> {
        self.search_bounded_syndrome_parallel_pulsed_impl(
            anchors,
            maximum_weight,
            pulse_interval,
            Some(shard),
        )
    }

    pub fn certify_incumbent_parallel_pulsed(
        &self,
        anchors: &[u16],
        incumbent: &[u16],
        pulse_interval: u64,
    ) -> Result<BoundedCssDistanceResult, CssDistanceError> {
        self.certify_incumbent_parallel_pulsed_impl(anchors, incumbent, pulse_interval)
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
        self.search_bounded_syndrome_parallel_pulsed_impl(
            anchors,
            maximum_weight,
            pulse_interval,
            None,
        )
    }

    pub fn search_bounded_syndrome_parallel_pulsed_shard(
        &self,
        anchors: &[u16],
        maximum_weight: u16,
        pulse_interval: u64,
        shard: CssSearchShard,
    ) -> Result<BoundedCssDistanceResult, CssDistanceError> {
        self.search_bounded_syndrome_parallel_pulsed_impl(
            anchors,
            maximum_weight,
            pulse_interval,
            Some(shard),
        )
    }

    pub fn certify_incumbent_parallel_pulsed(
        &self,
        anchors: &[u16],
        incumbent: &[u16],
        pulse_interval: u64,
    ) -> Result<BoundedCssDistanceResult, CssDistanceError> {
        self.certify_incumbent_parallel_pulsed_impl(anchors, incumbent, pulse_interval)
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
        self.search_bounded_syndrome_parallel_pulsed_impl(
            anchors,
            maximum_weight,
            pulse_interval,
            None,
        )
    }

    pub fn search_bounded_syndrome_parallel_pulsed_shard(
        &self,
        anchors: &[u16],
        maximum_weight: u16,
        pulse_interval: u64,
        shard: CssSearchShard,
    ) -> Result<BoundedCssDistanceResult, CssDistanceError> {
        self.search_bounded_syndrome_parallel_pulsed_impl(
            anchors,
            maximum_weight,
            pulse_interval,
            Some(shard),
        )
    }

    pub fn certify_incumbent_parallel_pulsed(
        &self,
        anchors: &[u16],
        incumbent: &[u16],
        pulse_interval: u64,
    ) -> Result<BoundedCssDistanceResult, CssDistanceError> {
        self.certify_incumbent_parallel_pulsed_impl(anchors, incumbent, pulse_interval)
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
        self.search_bounded_syndrome_parallel_pulsed_impl(
            anchors,
            maximum_weight,
            pulse_interval,
            None,
        )
    }

    pub fn search_bounded_syndrome_parallel_pulsed_shard(
        &self,
        anchors: &[u16],
        maximum_weight: u16,
        pulse_interval: u64,
        shard: CssSearchShard,
    ) -> Result<BoundedCssDistanceResult, CssDistanceError> {
        self.search_bounded_syndrome_parallel_pulsed_impl(
            anchors,
            maximum_weight,
            pulse_interval,
            Some(shard),
        )
    }

    pub fn certify_incumbent_parallel_pulsed(
        &self,
        anchors: &[u16],
        incumbent: &[u16],
        pulse_interval: u64,
    ) -> Result<BoundedCssDistanceResult, CssDistanceError> {
        self.certify_incumbent_parallel_pulsed_impl(anchors, incumbent, pulse_interval)
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
        hash_step_mask: u64::MAX,
    })
}

fn strictly_sorted(values: &[u128]) -> bool {
    values.windows(2).all(|pair| pair[0] < pair[1])
}

#[repr(C)]
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

const _: () = assert!(std::mem::size_of::<ConnectedSearchStats>() == 80);
const _: () = assert!(std::mem::align_of::<ConnectedSearchStats>() == 8);

#[derive(Clone, Debug, PartialEq, Eq, Serialize)]
pub struct BoundedCssDistanceResult {
    /// The minimum found weight, or `None` when no admissible support exists at
    /// or below the requested maximum.
    pub distance: Option<u16>,
    pub witness: Box<[u16]>,
    pub searched_maximum_weight: u16,
    pub stats: ConnectedSearchStats,
}

/// One deterministic member of a complete prefix partition of a CSS search.
///
/// Running every index in `0..count` with identical source, radius, anchors,
/// and build semantics covers the unsharded search exactly. A single shard's
/// result is partial and must not be reported as a global distance result.
#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq, Serialize)]
pub struct CssSearchShard {
    index: u32,
    count: u32,
}

const _: () = assert!(std::mem::size_of::<CssSearchShard>() == 8);
const _: () = assert!(std::mem::align_of::<CssSearchShard>() == 4);

impl CssSearchShard {
    pub fn new(index: u32, count: u32) -> Result<Self, CssDistanceError> {
        if count == 0 || count > 4096 || index >= count {
            return Err(CssDistanceError::InvalidSearchShard);
        }
        Ok(Self { index, count })
    }

    #[inline]
    pub const fn index(self) -> u32 {
        self.index
    }

    #[inline]
    pub const fn count(self) -> u32 {
        self.count
    }
}

#[cfg(feature = "parallel")]
#[repr(C)]
#[derive(Clone, Copy)]
struct RootBranch {
    root: u16,
    added: u16,
    remaining_root_candidates: PackedSupport,
}

#[cfg(feature = "parallel")]
const _: () = assert!(std::mem::size_of::<RootBranch>() == 40);
#[cfg(feature = "parallel")]
const _: () = assert!(std::mem::align_of::<RootBranch>() == 8);

#[cfg(feature = "parallel")]
#[repr(C, align(128))]
struct CachePaddedBranchResult {
    best_weight: u16,
    best_support: PackedSupport,
    stats: ConnectedSearchStats,
}

#[cfg(feature = "parallel")]
const _: () = assert!(
    std::mem::size_of::<CachePaddedBranchResult>() == 128
        && std::mem::align_of::<CachePaddedBranchResult>() == 128
);

#[cfg(feature = "parallel")]
#[repr(C, align(128))]
struct BoundMailbox {
    notify_fd: i32,
    published_bound: AtomicU16,
    _publication_pad: [u8; 122],
    inbound_bound: AtomicU16,
    inbound_pulse: AtomicBool,
    _inbound_pad: [u8; 125],
}

#[cfg(feature = "parallel")]
const _: () = assert!(
    std::mem::size_of::<BoundMailbox>() == 256 && std::mem::align_of::<BoundMailbox>() == 128
);

#[cfg(feature = "parallel")]
impl BoundMailbox {
    fn new(bound: u16, notify_fd: i32) -> Self {
        Self {
            notify_fd,
            published_bound: AtomicU16::new(bound),
            _publication_pad: [0; 122],
            inbound_bound: AtomicU16::new(bound),
            inbound_pulse: AtomicBool::new(false),
            _inbound_pad: [0; 125],
        }
    }
}

#[cfg(all(feature = "parallel", target_os = "linux"))]
struct BoundControllerEvents {
    worker: Box<[OwnedFd]>,
    stop: OwnedFd,
}

#[cfg(all(feature = "parallel", not(target_os = "linux")))]
struct BoundControllerEvents;

#[cfg(all(feature = "parallel", target_os = "linux"))]
impl BoundControllerEvents {
    fn new(worker_count: usize) -> Option<Self> {
        fn event_fd() -> Option<OwnedFd> {
            // SAFETY: `eventfd` returns a new owned descriptor on success. It
            // is immediately wrapped exactly once and closed by `OwnedFd`.
            let fd = unsafe { libc::eventfd(0, libc::EFD_CLOEXEC | libc::EFD_NONBLOCK) };
            (fd >= 0).then(|| {
                // SAFETY: the successful `eventfd` result is uniquely owned.
                unsafe { OwnedFd::from_raw_fd(fd) }
            })
        }

        let mut worker = Vec::with_capacity(worker_count);
        for _ in 0..worker_count {
            worker.push(event_fd()?);
        }
        Some(Self {
            worker: worker.into_boxed_slice(),
            stop: event_fd()?,
        })
    }

    fn worker_fd(&self, worker: usize) -> i32 {
        self.worker[worker].as_raw_fd()
    }
}

#[cfg(all(feature = "parallel", not(target_os = "linux")))]
impl BoundControllerEvents {
    fn new(_worker_count: usize) -> Option<Self> {
        None
    }

    fn worker_fd(&self, _worker: usize) -> i32 {
        -1
    }
}

#[cfg(all(feature = "parallel", target_os = "linux"))]
fn signal_bound_event(fd: i32) {
    let value = 1_u64;
    // SAFETY: `fd` is a live eventfd owned by the enclosing controller event
    // set, and `value` supplies exactly the required eight readable bytes.
    let _ = unsafe {
        libc::write(
            fd,
            (&raw const value).cast::<libc::c_void>(),
            std::mem::size_of::<u64>(),
        )
    };
}

#[cfg(all(feature = "parallel", not(target_os = "linux")))]
fn signal_bound_event(_fd: i32) {}

#[cfg(all(feature = "parallel", target_os = "linux"))]
fn drain_bound_event(fd: i32) {
    let mut value = 0_u64;
    // SAFETY: `fd` is a live eventfd and `value` supplies eight writable bytes.
    let _ = unsafe {
        libc::read(
            fd,
            (&raw mut value).cast::<libc::c_void>(),
            std::mem::size_of::<u64>(),
        )
    };
}

#[cfg(feature = "parallel")]
fn fan_out_published_bound(mailboxes: &[BoundMailbox], broadcast_bound: &mut u16) -> bool {
    let mut next_bound = *broadcast_bound;
    for mailbox in mailboxes {
        next_bound = next_bound.min(mailbox.published_bound.load(Ordering::Acquire));
    }
    if next_bound >= *broadcast_bound {
        return false;
    }
    *broadcast_bound = next_bound;
    for mailbox in mailboxes {
        mailbox.inbound_bound.store(next_bound, Ordering::Relaxed);
        let pulse = mailbox.inbound_pulse.load(Ordering::Relaxed);
        mailbox.inbound_pulse.store(!pulse, Ordering::Release);
    }
    true
}

#[cfg(all(feature = "parallel", target_os = "linux"))]
fn run_bound_controller(
    mailboxes: &[BoundMailbox],
    events: &BoundControllerEvents,
    ready: &std::sync::Barrier,
) {
    // `search` is commonly entered through a pinned Rayon worker, and Linux
    // threads inherit their creator's affinity. The controller is not a
    // worker: restore the process leader's allowed mask so its rare fan-out
    // does not steal cycles from one pinned solver.
    let mut process_affinity = unsafe { std::mem::zeroed::<libc::cpu_set_t>() };
    // SAFETY: both affinity calls receive a correctly sized live `cpu_set_t`.
    // Failure is performance-only; leaving inherited affinity preserves exact
    // semantics and the controller remains event-blocked between publications.
    unsafe {
        if libc::sched_getaffinity(
            libc::getpid(),
            std::mem::size_of::<libc::cpu_set_t>(),
            std::ptr::addr_of_mut!(process_affinity),
        ) == 0
        {
            let _ = libc::sched_setaffinity(
                0,
                std::mem::size_of::<libc::cpu_set_t>(),
                std::ptr::addr_of!(process_affinity),
            );
        }
    }
    let mut poll_fds = events
        .worker
        .iter()
        .chain(std::iter::once(&events.stop))
        .map(|fd| libc::pollfd {
            fd: fd.as_raw_fd(),
            events: libc::POLLIN,
            revents: 0,
        })
        .collect::<Vec<_>>();
    let stop_index = poll_fds.len() - 1;
    let mut broadcast_bound = mailboxes[0].inbound_bound.load(Ordering::Relaxed);
    ready.wait();
    loop {
        // SAFETY: `poll_fds` is a valid mutable array for the entire blocking
        // call. The controller, not a search worker, owns this wait loop.
        let ready = unsafe { libc::poll(poll_fds.as_mut_ptr(), poll_fds.len() as _, -1) };
        if ready < 0 {
            if io::Error::last_os_error().kind() == io::ErrorKind::Interrupted {
                continue;
            }
            return;
        }
        if poll_fds[stop_index].revents & libc::POLLIN != 0 {
            drain_bound_event(poll_fds[stop_index].fd);
            return;
        }
        let mut publication = false;
        for poll_fd in &mut poll_fds[..stop_index] {
            if poll_fd.revents & libc::POLLIN != 0 {
                drain_bound_event(poll_fd.fd);
                publication = true;
            }
            poll_fd.revents = 0;
        }
        if !publication {
            continue;
        }
        fan_out_published_bound(mailboxes, &mut broadcast_bound);
    }
}

#[cfg(all(feature = "parallel", target_os = "linux"))]
fn with_bound_controller<R>(
    mailboxes: &[BoundMailbox],
    events: &BoundControllerEvents,
    search: impl FnOnce() -> R,
) -> R {
    struct StopOnDrop<'a>(&'a BoundControllerEvents);
    impl Drop for StopOnDrop<'_> {
        fn drop(&mut self) {
            signal_bound_event(self.0.stop.as_raw_fd());
        }
    }

    let ready = std::sync::Barrier::new(2);
    std::thread::scope(|scope| {
        let controller = scope.spawn(|| run_bound_controller(mailboxes, events, &ready));
        ready.wait();
        let stop = StopOnDrop(events);
        let result = search();
        drop(stop);
        controller.join().expect("bound controller panicked");
        result
    })
}

#[cfg(all(feature = "parallel", not(target_os = "linux")))]
fn with_bound_controller<R>(
    _mailboxes: &[BoundMailbox],
    _events: &BoundControllerEvents,
    search: impl FnOnce() -> R,
) -> R {
    search()
}

#[cfg(feature = "parallel")]
struct BranchWorkspace {
    supports: Vec<PackedSupport>,
    boundaries: Vec<PackedSupport>,
    candidates: Vec<PackedSupport>,
    syndromes: Vec<PackedSyndrome>,
    logicals: Vec<u64>,
}

#[cfg(feature = "parallel")]
#[repr(C)]
#[derive(Clone, Copy)]
struct WideRootBranch<const SUPPORT_WORDS: usize, const CHECK_WORDS: usize> {
    support: PackedSupport<SUPPORT_WORDS>,
    syndrome: PackedSyndrome<CHECK_WORDS>,
    logical: u64,
    forbidden: PackedSupport<SUPPORT_WORDS>,
    weight: u16,
}

#[cfg(feature = "parallel")]
const _: () = assert!(
    std::mem::size_of::<WideRootBranch<WIDE_SUPPORT_WORDS, WIDE_SYNDROME_WORDS>>() == 120
        && std::mem::align_of::<WideRootBranch<WIDE_SUPPORT_WORDS, WIDE_SYNDROME_WORDS>>() == 8
        && std::mem::size_of::<WideRootBranch<EXTRA_WIDE_SUPPORT_WORDS, WIDE_SYNDROME_WORDS>>()
            == 136
        && std::mem::size_of::<WideRootBranch<LARGE_SUPPORT_WORDS, LARGE_SYNDROME_WORDS>>() == 272
        && std::mem::size_of::<WideRootBranch<HUGE_SUPPORT_WORDS, HUGE_SYNDROME_WORDS>>() == 488
        && std::mem::size_of::<WideRootBranch<COLOSSAL_SUPPORT_WORDS, COLOSSAL_SYNDROME_WORDS>>()
            == 568
);

#[cfg(feature = "parallel")]
#[repr(C, align(128))]
struct CachePaddedWideBranchResult<const SUPPORT_WORDS: usize> {
    best_weight: u16,
    best_support: PackedSupport<SUPPORT_WORDS>,
    stats: ConnectedSearchStats,
}

#[cfg(feature = "parallel")]
const _: () = assert!(
    std::mem::size_of::<CachePaddedWideBranchResult<WIDE_SUPPORT_WORDS>>() == 128
        && std::mem::size_of::<CachePaddedWideBranchResult<EXTRA_WIDE_SUPPORT_WORDS>>() == 256
        && std::mem::size_of::<CachePaddedWideBranchResult<LARGE_SUPPORT_WORDS>>() == 256
        && std::mem::size_of::<CachePaddedWideBranchResult<HUGE_SUPPORT_WORDS>>() == 384
        && std::mem::size_of::<CachePaddedWideBranchResult<COLOSSAL_SUPPORT_WORDS>>() == 384
        && std::mem::align_of::<CachePaddedWideBranchResult<WIDE_SUPPORT_WORDS>>() == 128
);

#[cfg(feature = "parallel")]
#[repr(C)]
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
const _: () = assert!(
    std::mem::size_of::<WideBranchFrame<WIDE_SUPPORT_WORDS, WIDE_SYNDROME_WORDS>>() == 192
        && std::mem::align_of::<WideBranchFrame<WIDE_SUPPORT_WORDS, WIDE_SYNDROME_WORDS>>() == 8
        && std::mem::size_of::<WideBranchFrame<EXTRA_WIDE_SUPPORT_WORDS, WIDE_SYNDROME_WORDS>>()
            == 224
        && std::mem::size_of::<WideBranchFrame<LARGE_SUPPORT_WORDS, LARGE_SYNDROME_WORDS>>() == 472
        && std::mem::size_of::<WideBranchFrame<HUGE_SUPPORT_WORDS, HUGE_SYNDROME_WORDS>>() == 864
        && std::mem::size_of::<WideBranchFrame<COLOSSAL_SUPPORT_WORDS, COLOSSAL_SYNDROME_WORDS>>()
            == 1008
);

#[cfg(feature = "parallel")]
struct WideBranchWorkspace<const SUPPORT_WORDS: usize, const CHECK_WORDS: usize> {
    frames: Box<[WideBranchFrame<SUPPORT_WORDS, CHECK_WORDS>]>,
}

#[cfg(feature = "parallel")]
impl<const SUPPORT_WORDS: usize, const CHECK_WORDS: usize>
    WideBranchWorkspace<SUPPORT_WORDS, CHECK_WORDS>
{
    fn new(frame_count: usize) -> Self {
        Self {
            frames: vec![WideBranchFrame::default(); frame_count].into_boxed_slice(),
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
const BOUND_PULSE_OBSERVED_BIT: u64 = 1 << 63;
#[cfg(feature = "parallel")]
const BOUND_PULSE_COUNT_MASK: u64 = BOUND_PULSE_OBSERVED_BIT - 1;

#[cfg(feature = "parallel")]
#[cold]
#[inline(never)]
fn publish_bound(mailbox: &BoundMailbox, bound: u16) {
    // The search worker writes only its publication line. The blocking
    // controller reduces publications and owns every inbound line.
    mailbox.published_bound.store(bound, Ordering::Release);
    if mailbox.notify_fd >= 0 {
        signal_bound_event(mailbox.notify_fd);
    }
}

#[cfg(feature = "parallel")]
#[inline(always)]
fn check_bound_pulse(
    mailbox: &BoundMailbox,
    pruning_bound: &mut u16,
    stats: &mut ConnectedSearchStats,
) {
    let pulse = mailbox.inbound_pulse.load(Ordering::Relaxed);
    let observed = stats.bound_pulses_observed & BOUND_PULSE_OBSERVED_BIT != 0;
    if pulse == observed {
        return;
    }
    stats.bound_pulses_observed ^= BOUND_PULSE_OBSERVED_BIT;
    // The guarded Boolean load stays relaxed on the overwhelmingly common
    // path. Only a changed pulse pays the acquire fence for its bound payload.
    std::sync::atomic::fence(Ordering::Acquire);
    let received = mailbox.inbound_bound.load(Ordering::Relaxed);
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
        let presented_rows = (0..physical.rows()).collect::<Vec<_>>();
        let kernel_parity_functional =
            binary_all_ones_functional::<2>(physical, &presented_rows, |_, row| row);
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
        if kernel_parity_functional
            .is_some_and(|functional| !validates_all_ones_functional(functional, &columns))
        {
            return Err(CssDistanceError::InvalidKernelParityFunctional);
        }
        let kernel_weights_even = kernel_parity_functional.is_some();
        for (coordinate, column) in columns.iter().enumerate() {
            neighbors[coordinate].remove(coordinate);
            maximum_column_check_weight = maximum_column_check_weight.max(
                u8::try_from(column.syndrome.weight()).expect("check count is bounded by 128"),
            );
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
    fn search_root_branch_partition<const PULSE: bool>(
        &self,
        branches: &[RootBranch],
        workspace: &mut BranchWorkspace,
        searched_maximum_weight: u16,
        mailboxes: &[BoundMailbox],
        pulse_interval: u64,
    ) -> CachePaddedBranchResult {
        let mut best_weight = searched_maximum_weight.saturating_add(1);
        let worker_index = rayon::current_thread_index().unwrap_or(0) % mailboxes.len();
        let mailbox = &mailboxes[worker_index];
        let mut pruning_bound = mailbox.inbound_bound.load(Ordering::Relaxed);
        let mut best_support = PackedSupport::default();
        let mut stats = ConnectedSearchStats::default();

        for branch in branches {
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
                        if 2 < pruning_bound {
                            pruning_bound = 2;
                            publish_bound(mailbox, 2);
                            stats.bound_improvements_published += 1;
                        }
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
                if PULSE && stats.candidates & (pulse_interval - 1) == 0 {
                    check_bound_pulse(mailbox, &mut pruning_bound, &mut stats);
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
                            if child_weight < pruning_bound {
                                pruning_bound = child_weight;
                                publish_bound(mailbox, child_weight);
                                stats.bound_improvements_published += 1;
                            }
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

        stats.bound_pulses_observed &= BOUND_PULSE_COUNT_MASK;
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
        shard: Option<CssSearchShard>,
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
        if let Some(shard) = shard {
            let count = usize::try_from(shard.count()).unwrap();
            let index = usize::try_from(shard.index()).unwrap();
            branches = branches
                .into_iter()
                .enumerate()
                .filter_map(|(branch_index, branch)| {
                    (branch_index % count == index).then_some(branch)
                })
                .collect();
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
        let mut workspaces = (0..partition_count)
            .map(|_| BranchWorkspace::new(usize::from(searched_maximum_weight)))
            .collect::<Vec<_>>();
        let mut partials = (0..partition_count)
            .map(|_| CachePaddedBranchResult {
                best_weight: searched_maximum_weight.saturating_add(1),
                best_support: PackedSupport::default(),
                stats: ConnectedSearchStats::default(),
            })
            .collect::<Vec<_>>();
        let thread_count = rayon::current_num_threads();
        let events = (pulse_interval != 0 && thread_count > 1)
            .then(|| BoundControllerEvents::new(thread_count))
            .flatten();
        let worker_pulse_interval = if events.is_some() { pulse_interval } else { 0 };
        let mailboxes = (0..thread_count)
            .map(|worker| {
                BoundMailbox::new(
                    searched_maximum_weight.saturating_add(1),
                    events
                        .as_ref()
                        .map_or(-1, |events| events.worker_fd(worker)),
                )
            })
            .collect::<Vec<_>>();
        #[cfg(test)]
        let allocation_measurement = crate::test_alloc::current_measurement();
        let mut search = || {
            partitions
                .par_iter()
                .zip(workspaces.par_iter_mut())
                .zip(partials.par_iter_mut())
                .for_each(|((partition, workspace), result)| {
                    #[cfg(test)]
                    let _allocation_guard =
                        HotLoopAllocationGuard::enter_for(allocation_measurement);
                    if worker_pulse_interval == 0 {
                        *result = self.search_root_branch_partition::<false>(
                            partition,
                            workspace,
                            searched_maximum_weight,
                            &mailboxes,
                            0,
                        );
                    } else {
                        *result = self.search_root_branch_partition::<true>(
                            partition,
                            workspace,
                            searched_maximum_weight,
                            &mailboxes,
                            worker_pulse_interval,
                        );
                    }
                });
        };
        match &events {
            Some(events) => with_bound_controller(&mailboxes, events, search),
            None => search(),
        };
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
        self.search_bounded_parallel_pulsed_impl(anchors, maximum_weight, pulse_interval, None)
    }

    /// Search one deterministic member of a complete prefix partition.
    ///
    /// A shard is a partial result. Run every index in `0..shard.count()`
    /// with identical inputs and take the best witness (or require every shard
    /// to exhaust) before making a global claim.
    #[cfg(feature = "parallel")]
    pub fn search_bounded_parallel_pulsed_shard(
        &self,
        anchors: &[u16],
        maximum_weight: u16,
        pulse_interval: u64,
        shard: CssSearchShard,
    ) -> Result<BoundedCssDistanceResult, CssDistanceError> {
        self.search_bounded_parallel_pulsed_impl(
            anchors,
            maximum_weight,
            pulse_interval,
            Some(shard),
        )
    }

    #[cfg(feature = "parallel")]
    fn search_bounded_parallel_pulsed_impl(
        &self,
        anchors: &[u16],
        maximum_weight: u16,
        pulse_interval: u64,
        shard: Option<CssSearchShard>,
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
                self.search_bounded_parallel_single_pulsed(anchors, limit, pulse_interval, shard)?;
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
        shard: Option<CssSearchShard>,
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
                self.search_bounded_root_parallel(&[anchor], active_maximum, pulse_interval, shard);
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
            None,
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

    #[test]
    fn css_anchor_orbits_verify_predicate_and_transversal() {
        let physical = Matrix::new::<2>(1, 4, vec![1, 1, 1, 1]).unwrap();
        let logical = Matrix::new::<2>(1, 4, vec![1, 0, 1, 0]).unwrap();
        let certificate =
            verify_css_anchor_transversal(&physical, &logical, vec![1, 2, 3, 0], &[2]).unwrap();
        assert_eq!(certificate.anchors(), &[2]);
        assert_eq!(certificate.partition().representatives(), &[0]);
        assert_eq!(certificate.minimum_orbit_size(), 4);
        assert_eq!(certificate.maximum_orbit_size(), 4);

        assert!(matches!(
            verify_css_anchor_transversal(&physical, &logical, vec![1, 0, 3, 2], &[0]),
            Err(CssAnchorOrbitError::NotTransversal)
        ));
        assert!(
            verify_css_anchor_transversal(&physical, &logical, vec![1, 0, 3, 2], &[0, 2]).is_ok()
        );
    }

    #[test]
    fn css_anchor_orbits_reject_non_symmetries_and_non_permutations() {
        let physical = Matrix::new::<2>(1, 4, vec![1, 1, 1, 1]).unwrap();
        let asymmetric_logical = Matrix::new::<2>(1, 4, vec![1, 1, 0, 0]).unwrap();
        assert!(matches!(
            verify_css_anchor_transversal(&physical, &asymmetric_logical, vec![1, 2, 3, 0], &[0]),
            Err(CssAnchorOrbitError::NotAutomorphism)
        ));
        let logical = Matrix::new::<2>(1, 4, vec![1, 0, 1, 0]).unwrap();
        assert!(matches!(
            verify_css_anchor_transversal(&physical, &logical, vec![0, 0, 2, 3], &[0, 2, 3]),
            Err(CssAnchorOrbitError::Orbit(
                OrbitCompileError::NotPermutation { .. }
            ))
        ));
    }

    fn subset_xors(keys: &[u128], size: usize) -> Vec<u128> {
        let mut output = Vec::new();
        for mask in 0_usize..1_usize << keys.len() {
            if mask.count_ones() as usize == size {
                output.push(
                    keys.iter()
                        .enumerate()
                        .filter(|(index, _)| mask & (1_usize << index) != 0)
                        .fold(0, |value, (_, &key)| value ^ key),
                );
            }
        }
        output.sort_unstable();
        output.dedup();
        output
    }

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
    fn verified_orbit_anchor_finds_planted_minimum_at_every_position() {
        let coordinates = 8;
        let physical = Matrix::new::<2>(1, coordinates, vec![1; coordinates]).unwrap();
        let logical = Matrix::new::<2>(
            1,
            coordinates,
            (0..coordinates)
                .map(|index| (index & 1) as u8)
                .collect::<Vec<_>>(),
        )
        .unwrap();
        let cycle = (0..coordinates)
            .map(|index| ((index + 1) % coordinates) as u32)
            .collect::<Box<[_]>>();
        let compiled = CompiledCssDistance::compile(&physical, &logical).unwrap();
        let reference = compiled
            .search_bounded(&(0..coordinates as u16).collect::<Vec<_>>(), 2)
            .unwrap();
        assert_eq!(reference.distance, Some(2));
        for anchor in 0..coordinates as u16 {
            let certificate =
                verify_css_anchor_transversal(&physical, &logical, cycle.clone(), &[anchor])
                    .unwrap();
            assert_eq!(certificate.anchors(), &[anchor]);
            let answer = compiled.search_bounded(&[anchor], 2).unwrap();
            assert_eq!(answer.distance, reference.distance);
            assert!(answer.witness.contains(&anchor));
        }
    }

    #[test]
    fn syndrome_and_budget_are_not_a_complete_transposition_key() {
        let physical = Matrix::new::<2>(1, 3, vec![1, 1, 1]).unwrap();
        let logical = Matrix::new::<2>(1, 3, vec![0, 1, 0]).unwrap();
        let compiled = CompiledWideCssDistance::compile(&physical, &logical).unwrap();

        let left_support = PackedSupport::singleton(0);
        let right_support = PackedSupport::singleton(1);
        let syndrome = compiled.columns[0].syndrome;
        assert_eq!(syndrome, compiled.columns[1].syndrome);

        let left_options =
            compiled.syndrome_branch_options(syndrome, left_support, PackedSupport::default());
        let right_options =
            compiled.syndrome_branch_options(syndrome, right_support, PackedSupport::default());
        assert_ne!(left_options, right_options);

        let common_completion = compiled.columns[2];
        let mut completed_syndrome = syndrome;
        completed_syndrome.toggle(common_completion.syndrome);
        assert!(completed_syndrome.is_zero());
        let left_logical = compiled.columns[0].logical ^ common_completion.logical;
        let right_logical = compiled.columns[1].logical ^ common_completion.logical;
        let mut left_completed = left_support;
        left_completed.insert(2);
        let mut right_completed = right_support;
        right_completed.insert(2);
        assert!(!compiled.logical_is_nonzero(left_completed, left_logical));
        assert!(compiled.logical_is_nonzero(right_completed, right_logical));
    }

    #[cfg(feature = "parallel")]
    #[test]
    fn randomized_small_serial_parallel_and_sharded_searches_match_brute_force() {
        fn next(seed: &mut u64) -> u64 {
            *seed = seed
                .wrapping_mul(6_364_136_223_846_793_005)
                .wrapping_add(1_442_695_040_888_963_407);
            *seed
        }

        let pool = rayon::ThreadPoolBuilder::new()
            .num_threads(3)
            .build()
            .unwrap();
        let mut seed = 0xc985_1027_5eed_u64;
        for case in 0..64 {
            let coordinates = 5 + case % 4;
            let physical_rows = 1 + (next(&mut seed) as usize % 4);
            let logical_rows = 1 + (next(&mut seed) as usize % 3);
            let physical = Matrix::new::<2>(
                physical_rows,
                coordinates,
                (0..physical_rows * coordinates)
                    .map(|_| (next(&mut seed) >> 63) as u8)
                    .collect::<Vec<_>>(),
            )
            .unwrap();
            let mut logical_data = (0..logical_rows * coordinates)
                .map(|_| (next(&mut seed) >> 63) as u8)
                .collect::<Vec<_>>();
            for row in 0..logical_rows {
                if logical_data[row * coordinates..(row + 1) * coordinates]
                    .iter()
                    .all(|&entry| entry == 0)
                {
                    logical_data[row * coordinates + row % coordinates] = 1;
                }
            }
            let logical = Matrix::new::<2>(logical_rows, coordinates, logical_data).unwrap();
            let anchors = (0..coordinates as u16).collect::<Vec<_>>();
            let expected = brute_force(&physical, &logical, coordinates as u16);
            let compact = CompiledCssDistance::compile(&physical, &logical).unwrap();
            let wide = CompiledWideCssDistance::compile(&physical, &logical).unwrap();
            assert_eq!(
                compact
                    .search_bounded(&anchors, coordinates as u16)
                    .unwrap()
                    .distance,
                expected
            );
            assert_eq!(
                wide.search_bounded_syndrome_driven(&anchors, coordinates as u16)
                    .unwrap()
                    .distance,
                expected
            );
            let compact_parallel = pool
                .install(|| compact.search_bounded_parallel_pulsed(&anchors, coordinates as u16, 0))
                .unwrap();
            let wide_parallel = pool
                .install(|| {
                    wide.search_bounded_syndrome_parallel_pulsed(&anchors, coordinates as u16, 0)
                })
                .unwrap();
            assert_eq!(compact_parallel.distance, expected);
            assert_eq!(wide_parallel.distance, expected);

            let compact_shards = (0..3)
                .filter_map(|index| {
                    pool.install(|| {
                        compact.search_bounded_parallel_pulsed_shard(
                            &anchors,
                            coordinates as u16,
                            0,
                            CssSearchShard::new(index, 3).unwrap(),
                        )
                    })
                    .unwrap()
                    .distance
                })
                .min();
            let wide_shards = (0..3)
                .filter_map(|index| {
                    pool.install(|| {
                        wide.search_bounded_syndrome_parallel_pulsed_shard(
                            &anchors,
                            coordinates as u16,
                            0,
                            CssSearchShard::new(index, 3).unwrap(),
                        )
                    })
                    .unwrap()
                    .distance
                })
                .min();
            assert_eq!(compact_shards, expected);
            assert_eq!(wide_shards, expected);
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

    #[test]
    fn syndrome_driven_incumbent_closes_strictly_smaller_weights() {
        let physical = Matrix::new::<2>(1, 2, vec![1, 1]).unwrap();
        let logical = Matrix::new::<2>(1, 2, vec![1, 0]).unwrap();
        let compiled = CompiledWideCssDistance::compile(&physical, &logical).unwrap();
        let answer = compiled
            .certify_incumbent_syndrome_driven(&[0, 1], &[0, 1])
            .unwrap();
        assert_eq!(answer.distance, Some(2));
        assert_eq!(&*answer.witness, &[0, 1]);
        assert_eq!(answer.searched_maximum_weight, 0);
        assert!(matches!(
            compiled.certify_incumbent_syndrome_driven(&[0, 1], &[0]),
            Err(CssDistanceError::IncumbentPhysicalSyndrome)
        ));
    }

    #[test]
    fn arbitrary_rowspace_functional_certifies_kernel_parity() {
        let physical = Matrix::new::<2>(
            3,
            5,
            vec![
                1, 1, 0, 0, 0, // first two rows sum to all ones
                0, 0, 1, 1, 1, // while the sum of all three does not
                1, 0, 1, 0, 0,
            ],
        )
        .unwrap();
        let logical = Matrix::new::<2>(1, 5, vec![1, 0, 0, 0, 0]).unwrap();
        let compiled = CompiledWideCssDistance::compile(&physical, &logical).unwrap();
        assert!(compiled.kernel_weights_even());
        assert!(!compiled.completion_lower_bound_exceeds(compiled.columns[0].syndrome, 0));

        for support in 0_u64..1 << 5 {
            let mut syndrome = PackedSyndrome::<3>::default();
            for coordinate in 0..5 {
                if support & (1_u64 << coordinate) != 0 {
                    syndrome.toggle(compiled.columns[coordinate].syndrome);
                }
            }
            assert_eq!(
                packed_dot_parity(syndrome, compiled.kernel_parity_functional),
                support.count_ones() & 1
            );
        }
    }

    #[test]
    fn multiplicity_capping_preserves_all_retained_completion_keys() {
        let keys = [1_u128, 1, 1, 1, 2, 2, 4];
        let columns = keys
            .iter()
            .map(|&key| PackedColumn::<3> {
                syndrome: PackedSyndrome {
                    words: [key as u64, 0, 0],
                },
                logical: 0,
            })
            .collect::<Vec<_>>();
        let (unique, capped_three) = prepare_completion_keys(&columns, wide_syndrome_key, 3);
        assert_eq!(unique, vec![1, 2, 4]);
        assert_eq!(capped_three, vec![1, 1, 1, 2, 2, 4]);

        let expected = (1..=4)
            .map(|size| subset_xors(&keys, size))
            .collect::<Vec<_>>();
        let (short, triple_bloom, _) =
            compile_large_completion_filters(&columns, wide_syndrome_key);
        assert_eq!(short[0].as_ref(), expected[0]);
        assert_eq!(short[1].as_ref(), expected[1]);
        for value in expected.iter().take(3).flatten() {
            assert!(triple_bloom.contains_three(*value));
        }

        let (full_short, full_triple_bloom, four_bloom) =
            compile_completion_filters(&columns, wide_syndrome_key);
        assert_eq!(full_short[0].as_ref(), expected[0]);
        assert_eq!(full_short[1].as_ref(), expected[1]);
        for value in expected.iter().take(3).flatten() {
            assert!(full_triple_bloom.contains_three(*value));
        }
        for &value in &expected[3] {
            assert!(four_bloom.contains_one(value));
        }
    }

    #[test]
    fn saturated_triple_filter_is_replaced_by_universal_filter() {
        let columns = (0_u64..846)
            .map(|key| PackedColumn::<3> {
                syndrome: PackedSyndrome { words: [key, 0, 0] },
                logical: 0,
            })
            .collect::<Vec<_>>();
        let (short, triple_bloom, _) =
            compile_large_completion_filters(&columns, wide_syndrome_key);
        assert_eq!(short[0].len(), columns.len());
        assert_eq!(triple_bloom.words.as_ref(), &[u64::MAX]);
        assert_eq!(triple_bloom.bit_mask, 63);
    }

    #[test]
    fn adaptive_high_load_bloom_uses_matching_single_hash() {
        let mut bloom = CompletionBloom::new_adaptive(60_000_000);
        assert!(bloom.uses_one_hash());
        for key in [0_u128, 1, u128::MAX, 0x1234_5678_9abc_def0] {
            bloom.insert_one(key);
            assert!(bloom.contains_three(key));
        }
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
    fn large_artifact_reader_accepts_width_only_version_one_artifacts() {
        let (physical, logical) = artifact_problem();
        let compiled = CompiledLargeCssDistance::compile(&physical, &logical).unwrap();
        let mut artifact = Vec::new();
        compiled.write_artifact(&mut artifact).unwrap();
        artifact[8..10].copy_from_slice(&1u16.to_le_bytes());
        let payload_end = artifact.len() - 32;
        let checksum = blake3::hash(&artifact[8..payload_end]);
        artifact[payload_end..].copy_from_slice(checksum.as_bytes());

        let loaded =
            CompiledLargeCssDistance::read_artifact(&physical, &logical, &*artifact).unwrap();
        assert_eq!(loaded.coordinate_count(), physical.cols());
        assert_eq!(loaded.check_count(), compiled.check_count());
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
        let mut one_hash_wide = wide.clone();
        one_hash_wide.three_completion_bloom.hash_step_mask = 0;
        let mut one_hash_artifact = Vec::new();
        one_hash_wide
            .write_artifact(&mut one_hash_artifact)
            .unwrap();
        let one_hash_loaded =
            CompiledWideCssDistance::read_artifact(&physical, &logical, &*one_hash_artifact)
                .unwrap();
        assert!(one_hash_loaded.three_completion_bloom.uses_one_hash());
        assert_eq!(
            one_hash_loaded
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

    #[cfg(feature = "parallel")]
    #[test]
    fn parallel_css_partition_loops_allocate_nothing_across_workers() {
        let physical = Matrix::new::<2>(1, 8, vec![1; 8]).unwrap();
        let logical = Matrix::new::<2>(1, 8, vec![1, 0, 1, 1, 1, 1, 1, 1]).unwrap();
        let anchors = [0, 1, 2, 3, 4, 5, 6, 7];
        let compact = CompiledCssDistance::compile(&physical, &logical).unwrap();
        let wide = CompiledWideCssDistance::compile(&physical, &logical).unwrap();
        let pool = rayon::ThreadPoolBuilder::new()
            .num_threads(3)
            .build()
            .unwrap();

        let ((compact_result, wide_result), events) = measure_allocations(|| {
            let measurement = crate::test_alloc::current_measurement();
            let compact_result = pool
                .install(|| {
                    measurement.scope(|| compact.search_bounded_parallel_pulsed(&anchors, 4, 0))
                })
                .unwrap();
            let wide_result = pool
                .install(|| {
                    measurement
                        .scope(|| wide.search_bounded_syndrome_parallel_pulsed(&anchors, 4, 0))
                })
                .unwrap();
            (compact_result, wide_result)
        });
        assert_eq!(compact_result.distance, wide_result.distance);
        assert_eq!(events, Default::default());
    }

    #[cfg(feature = "parallel")]
    #[test]
    fn deterministic_search_shards_cover_compact_and_wide_searches() {
        assert!(CssSearchShard::new(0, 0).is_err());
        assert!(CssSearchShard::new(3, 3).is_err());
        assert!(CssSearchShard::new(0, 4097).is_err());

        let (physical, logical) = artifact_problem();
        let anchors = [0, 1, 2, 3, 4];
        let pool = rayon::ThreadPoolBuilder::new()
            .num_threads(3)
            .build()
            .unwrap();
        let compact = CompiledCssDistance::compile(&physical, &logical).unwrap();
        let compact_reference = pool
            .install(|| compact.search_bounded_parallel_pulsed(&anchors, 5, 0))
            .unwrap();
        let compact_shard_best = (0..3)
            .filter_map(|index| {
                pool.install(|| {
                    compact.search_bounded_parallel_pulsed_shard(
                        &anchors,
                        5,
                        0,
                        CssSearchShard::new(index, 3).unwrap(),
                    )
                })
                .unwrap()
                .distance
            })
            .min();
        assert_eq!(compact_shard_best, compact_reference.distance);

        let wide = CompiledWideCssDistance::compile(&physical, &logical).unwrap();
        let wide_reference = pool
            .install(|| wide.search_bounded_syndrome_parallel_pulsed(&anchors, 5, 0))
            .unwrap();
        let wide_shard_best = (0..3)
            .filter_map(|index| {
                pool.install(|| {
                    wide.search_bounded_syndrome_parallel_pulsed_shard(
                        &anchors,
                        5,
                        0,
                        CssSearchShard::new(index, 3).unwrap(),
                    )
                })
                .unwrap()
                .distance
            })
            .min();
        assert_eq!(wide_shard_best, wide_reference.distance);
    }

    #[cfg(feature = "parallel")]
    #[test]
    fn controller_bound_fanout_is_monotone_and_coalescence_safe() {
        let mailboxes = [BoundMailbox::new(20, -1), BoundMailbox::new(20, -1)];
        let receiver = &mailboxes[1];
        let mut broadcast_bound = 20;
        let mut pruning_bound = 20;
        let mut stats = ConnectedSearchStats::default();

        check_bound_pulse(receiver, &mut pruning_bound, &mut stats);
        assert_eq!(pruning_bound, 20);
        assert_eq!(stats.bound_pulses_observed & BOUND_PULSE_COUNT_MASK, 0);

        publish_bound(&mailboxes[0], 17);
        assert!(fan_out_published_bound(&mailboxes, &mut broadcast_bound));
        check_bound_pulse(receiver, &mut pruning_bound, &mut stats);
        assert_eq!(pruning_bound, 17);
        assert_eq!(receiver.inbound_bound.load(Ordering::Relaxed), 17);
        assert_eq!(stats.bound_pulses_observed & BOUND_PULSE_COUNT_MASK, 1);

        // Two controller fanouts may toggle the Boolean back before a worker
        // checks. Missing that notification is deliberately one-sided: the
        // worker keeps a valid looser bound and only performs extra work.
        publish_bound(&mailboxes[0], 15);
        assert!(fan_out_published_bound(&mailboxes, &mut broadcast_bound));
        publish_bound(&mailboxes[0], 13);
        assert!(fan_out_published_bound(&mailboxes, &mut broadcast_bound));
        check_bound_pulse(receiver, &mut pruning_bound, &mut stats);
        assert_eq!(pruning_bound, 17);
        assert_eq!(stats.bound_pulses_observed & BOUND_PULSE_COUNT_MASK, 1);

        // A later controller pulse exposes the newest monotone payload.
        publish_bound(&mailboxes[0], 11);
        assert!(fan_out_published_bound(&mailboxes, &mut broadcast_bound));
        check_bound_pulse(receiver, &mut pruning_bound, &mut stats);
        assert_eq!(pruning_bound, 11);
        assert_eq!(receiver.inbound_bound.load(Ordering::Relaxed), 11);
        assert_eq!(stats.bound_pulses_observed & BOUND_PULSE_COUNT_MASK, 2);
    }
}
