//! Exact minimum nonzero weight for small-rank binary linear codes.
//!
//! The compiler canonicalizes a generator matrix over GF(2). Search walks the
//! nonzero row span in reflected Gray-code order: each candidate differs by one
//! basis row, so the hot loop is one packed XOR pass plus POPCNT. Caller-owned
//! workspace keeps the loop allocation-free.

use crate::{Matrix, MatrixError};
use serde::Serialize;
use thiserror::Error;

#[derive(Clone, Debug, PartialEq, Eq, Error)]
pub enum BinaryLinearCodeError {
    #[error(transparent)]
    Matrix(#[from] MatrixError),
    #[error("binary linear-code enumeration supports rank at most 63")]
    RankTooLarge,
    #[error("binary linear-code coordinates must fit in a 16-bit support index")]
    CoordinateCountTooLarge,
}

#[derive(Clone, Debug)]
pub struct CompiledBinaryLinearCode {
    basis_words: Box<[u64]>,
    systematic_bases: Box<[u64]>,
    coordinate_count: u16,
    rank: u8,
    word_count: u16,
    information_set_count: u16,
    systematic_row_upper_bound: u16,
}

#[derive(Clone, Debug)]
pub struct BinaryLinearCodeWorkspace {
    current: Box<[u64]>,
    best: Box<[u64]>,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq, Serialize)]
#[serde(rename_all = "kebab-case")]
pub enum BinaryLinearAlgorithm {
    Gray,
    BrouwerZimmermann,
}

#[derive(Clone, Debug, PartialEq, Eq, Serialize)]
pub struct BinaryLinearWeightResult {
    pub weight: Option<u16>,
    pub support: Box<[u16]>,
    pub candidates: u64,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq, Serialize)]
pub struct BinaryLinearWeightSummary {
    pub weight: Option<u16>,
    pub candidates: u64,
}

impl CompiledBinaryLinearCode {
    pub fn compile(generator: &Matrix) -> Result<Self, BinaryLinearCodeError> {
        let basis = generator.canonical_row_basis::<2>()?;
        if basis.rows() > 63 {
            return Err(BinaryLinearCodeError::RankTooLarge);
        }
        if basis.cols() > usize::from(u16::MAX) {
            return Err(BinaryLinearCodeError::CoordinateCountTooLarge);
        }
        let word_count = basis.cols().div_ceil(64);
        let mut basis_words = vec![0u64; basis.rows().saturating_mul(word_count)];
        for row in 0..basis.rows() {
            for (coordinate, &entry) in basis.row(row).iter().enumerate() {
                if entry != 0 {
                    basis_words[row * word_count + coordinate / 64] |= 1u64 << (coordinate % 64);
                }
            }
        }
        let systematic_bases = if basis.rows() >= 24 {
            compile_disjoint_systematic_bases(&basis_words, basis.rows(), word_count, basis.cols())
        } else {
            Vec::new()
        };
        let information_set_count = if basis.rows() == 0 {
            0
        } else {
            systematic_bases.len() / (basis.rows() * word_count)
        };
        let systematic_row_upper_bound = systematic_bases
            .chunks_exact(word_count)
            .map(packed_weight)
            .min()
            .unwrap_or(u16::MAX);
        Ok(Self {
            basis_words: basis_words.into_boxed_slice(),
            systematic_bases: systematic_bases.into_boxed_slice(),
            coordinate_count: basis.cols() as u16,
            rank: basis.rows() as u8,
            word_count: word_count as u16,
            information_set_count: information_set_count as u16,
            systematic_row_upper_bound,
        })
    }

    #[inline]
    pub const fn coordinate_count(&self) -> usize {
        self.coordinate_count as usize
    }

    #[inline]
    pub const fn rank(&self) -> usize {
        self.rank as usize
    }

    #[inline]
    pub const fn information_set_count(&self) -> usize {
        self.information_set_count as usize
    }

    pub fn workspace(&self) -> BinaryLinearCodeWorkspace {
        BinaryLinearCodeWorkspace {
            current: vec![0; self.word_count as usize].into_boxed_slice(),
            best: vec![0; self.word_count as usize].into_boxed_slice(),
        }
    }

    pub fn minimum_nonzero_weight(&self) -> BinaryLinearWeightResult {
        self.minimum_nonzero_weight_with(&mut self.workspace())
    }

    /// Enumerate the row span exactly with no allocation in the Gray-code loop.
    pub fn minimum_nonzero_weight_with(
        &self,
        workspace: &mut BinaryLinearCodeWorkspace,
    ) -> BinaryLinearWeightResult {
        let summary = self.minimum_nonzero_weight_auto_scan(workspace);
        let Some(best_weight) = summary.weight else {
            return BinaryLinearWeightResult {
                weight: None,
                support: Box::default(),
                candidates: summary.candidates,
            };
        };
        let mut support = Vec::with_capacity(best_weight as usize);
        for coordinate in 0..self.coordinate_count() {
            if workspace.best[coordinate / 64] & (1u64 << (coordinate % 64)) != 0 {
                support.push(coordinate as u16);
            }
        }
        BinaryLinearWeightResult {
            weight: Some(best_weight),
            support: support.into_boxed_slice(),
            candidates: summary.candidates,
        }
    }

    /// Run only the allocation-free Gray-code scan, retaining the best packed
    /// support in `workspace` for optional later materialization.
    pub fn minimum_nonzero_weight_gray_scan(
        &self,
        workspace: &mut BinaryLinearCodeWorkspace,
    ) -> BinaryLinearWeightSummary {
        self.minimum_nonzero_weight_scan(workspace)
    }

    /// Select the measured Gray/Brouwer--Zimmermann crossover once per solve.
    pub fn minimum_nonzero_weight_auto_scan(
        &self,
        workspace: &mut BinaryLinearCodeWorkspace,
    ) -> BinaryLinearWeightSummary {
        if self.recommended_algorithm() == BinaryLinearAlgorithm::BrouwerZimmermann {
            self.minimum_nonzero_weight_brouwer_zimmermann_scan(workspace)
        } else {
            self.minimum_nonzero_weight_scan(workspace)
        }
    }

    /// Exhaustively enumerate the row span in reflected Gray-code order.
    pub fn minimum_nonzero_weight_scan(
        &self,
        workspace: &mut BinaryLinearCodeWorkspace,
    ) -> BinaryLinearWeightSummary {
        gray_scan_kernel(self, workspace)
    }

    pub fn recommended_algorithm(&self) -> BinaryLinearAlgorithm {
        let gray_candidates = (1u64 << self.rank) - 1;
        let bz_candidates = estimated_bz_candidates(
            self.rank as usize,
            self.information_set_count as usize,
            self.systematic_row_upper_bound,
        );
        // Fixed-weight mask order can toggle more than one basis row per
        // candidate.  Require a conservative 8x candidate advantage before
        // selecting it over the one-toggle Gray walk.
        if self.rank >= 24
            && self.information_set_count >= 2
            && bz_candidates.saturating_mul(8) < gray_candidates
        {
            BinaryLinearAlgorithm::BrouwerZimmermann
        } else {
            BinaryLinearAlgorithm::Gray
        }
    }

    /// Brouwer--Zimmermann enumeration over disjoint systematic information
    /// sets.  Fixed-weight masks are advanced by integer arithmetic; only rows
    /// in the mask delta are XORed, and the solve loop allocates nothing.
    pub fn minimum_nonzero_weight_brouwer_zimmermann_scan(
        &self,
        workspace: &mut BinaryLinearCodeWorkspace,
    ) -> BinaryLinearWeightSummary {
        brouwer_zimmermann_scan_kernel(self, workspace)
    }
}

#[multiversion::multiversion(
    targets("x86_64+avx+avx2+bmi1+bmi2+lzcnt+popcnt"),
    dispatcher = "indirect"
)]
fn gray_scan_kernel(
    compiled: &CompiledBinaryLinearCode,
    workspace: &mut BinaryLinearCodeWorkspace,
) -> BinaryLinearWeightSummary {
    let word_count = compiled.word_count as usize;
    assert_eq!(workspace.current.len(), word_count);
    assert_eq!(workspace.best.len(), word_count);
    workspace.current.fill(0);
    workspace.best.fill(0);
    if compiled.rank == 0 {
        return BinaryLinearWeightSummary {
            weight: None,
            candidates: 0,
        };
    }
    let candidate_count = (1u64 << compiled.rank) - 1;
    let mut best_weight = compiled.coordinate_count.saturating_add(1);
    let mut candidates = 0u64;
    for step in 1..=candidate_count {
        let changed_row = step.trailing_zeros() as usize;
        let basis = &compiled.basis_words[changed_row * word_count..(changed_row + 1) * word_count];
        let mut weight = 0u16;
        for (word, &toggle) in workspace.current.iter_mut().zip(basis) {
            *word ^= toggle;
            weight += word.count_ones() as u16;
        }
        candidates += 1;
        if weight < best_weight {
            best_weight = weight;
            workspace.best.copy_from_slice(&workspace.current);
            if weight == 1 {
                break;
            }
        }
    }
    BinaryLinearWeightSummary {
        weight: Some(best_weight),
        candidates,
    }
}

#[multiversion::multiversion(
    targets("x86_64+avx+avx2+bmi1+bmi2+lzcnt+popcnt"),
    dispatcher = "indirect"
)]
fn brouwer_zimmermann_scan_kernel(
    compiled: &CompiledBinaryLinearCode,
    workspace: &mut BinaryLinearCodeWorkspace,
) -> BinaryLinearWeightSummary {
    let word_count = compiled.word_count as usize;
    let rank = compiled.rank as usize;
    let information_sets = compiled.information_set_count as usize;
    assert_eq!(workspace.current.len(), word_count);
    assert_eq!(workspace.best.len(), word_count);
    workspace.current.fill(0);
    workspace.best.fill(0);
    if rank == 0 {
        return BinaryLinearWeightSummary {
            weight: None,
            candidates: 0,
        };
    }
    if information_sets == 0 {
        return compiled.minimum_nonzero_weight_scan(workspace);
    }

    let words_per_basis = rank * word_count;
    let mut best_weight = compiled.coordinate_count.saturating_add(1);
    let mut candidates = 0u64;
    for information_set in 0..information_sets {
        let basis_start = information_set * words_per_basis;
        for row in 0..rank {
            let row_start = basis_start + row * word_count;
            let candidate = &compiled.systematic_bases[row_start..row_start + word_count];
            let weight = packed_weight(candidate);
            candidates += 1;
            if weight < best_weight {
                best_weight = weight;
                workspace.best.copy_from_slice(candidate);
            }
        }
    }
    if best_weight == 1 || (information_sets as u16).saturating_mul(2) >= best_weight {
        return BinaryLinearWeightSummary {
            weight: Some(best_weight),
            candidates,
        };
    }

    let limit = 1u64 << rank;
    for level in 2..=rank {
        for information_set in 0..information_sets {
            workspace.current.fill(0);
            let basis_start = information_set * words_per_basis;
            let basis = &compiled.systematic_bases[basis_start..basis_start + words_per_basis];
            let mut previous = 0u64;
            let mut combination = (1u64 << level) - 1;
            while combination < limit {
                let mut changed = combination ^ previous;
                while changed != 0 {
                    let row = changed.trailing_zeros() as usize;
                    changed &= changed - 1;
                    let row_start = row * word_count;
                    for (word, &toggle) in workspace
                        .current
                        .iter_mut()
                        .zip(&basis[row_start..row_start + word_count])
                    {
                        *word ^= toggle;
                    }
                }
                let weight = packed_weight(&workspace.current);
                candidates += 1;
                if weight < best_weight {
                    best_weight = weight;
                    workspace.best.copy_from_slice(&workspace.current);
                }
                previous = combination;
                combination = next_same_weight(combination);
            }
        }
        let unseen_lower_bound =
            (information_sets as u16).saturating_mul((level as u16).saturating_add(1));
        if unseen_lower_bound >= best_weight {
            break;
        }
    }
    BinaryLinearWeightSummary {
        weight: Some(best_weight),
        candidates,
    }
}

#[inline(always)]
fn packed_weight(words: &[u64]) -> u16 {
    words.iter().map(|word| word.count_ones() as u16).sum()
}

#[inline(always)]
fn next_same_weight(value: u64) -> u64 {
    let lowest = value & value.wrapping_neg();
    let ripple = value.wrapping_add(lowest);
    (((ripple ^ value) >> 2) >> lowest.trailing_zeros()) | ripple
}

fn estimated_bz_candidates(rank: usize, information_sets: usize, upper_bound: u16) -> u64 {
    if rank == 0 || information_sets == 0 || upper_bound == u16::MAX {
        return u64::MAX;
    }
    let maximum_level = usize::from(upper_bound.saturating_sub(1))
        .checked_div(information_sets)
        .unwrap_or(0)
        .max(1)
        .min(rank);
    let mut combinations = 0u64;
    for level in 1..=maximum_level {
        combinations = combinations.saturating_add(binomial_saturating(rank, level));
    }
    combinations.saturating_mul(information_sets as u64)
}

fn binomial_saturating(n: usize, k: usize) -> u64 {
    let k = k.min(n - k);
    let mut value = 1u128;
    for index in 0..k {
        value = value * (n - index) as u128 / (index + 1) as u128;
    }
    value.min(u128::from(u64::MAX)) as u64
}

fn compile_disjoint_systematic_bases(
    canonical: &[u64],
    rank: usize,
    word_count: usize,
    coordinate_count: usize,
) -> Vec<u64> {
    const MAX_SYSTEMATIC_WORDS: usize = 1 << 20;

    let mut used = vec![false; coordinate_count];
    let mut compiled = Vec::new();
    loop {
        if compiled
            .len()
            .saturating_add(rank.saturating_mul(word_count))
            > MAX_SYSTEMATIC_WORDS
        {
            break;
        }
        let mut basis = canonical.to_vec();
        let mut pivots = Vec::with_capacity(rank);
        for pivot_row in 0..rank {
            let found = (0..coordinate_count).find_map(|coordinate| {
                if used[coordinate] {
                    return None;
                }
                (pivot_row..rank)
                    .find(|&row| packed_bit(&basis, row, word_count, coordinate))
                    .map(|row| (row, coordinate))
            });
            let Some((found_row, pivot_coordinate)) = found else {
                break;
            };
            if found_row != pivot_row {
                for word in 0..word_count {
                    basis.swap(found_row * word_count + word, pivot_row * word_count + word);
                }
            }
            for row in 0..rank {
                if row == pivot_row || !packed_bit(&basis, row, word_count, pivot_coordinate) {
                    continue;
                }
                for word in 0..word_count {
                    let pivot = basis[pivot_row * word_count + word];
                    basis[row * word_count + word] ^= pivot;
                }
            }
            pivots.push(pivot_coordinate);
        }
        if pivots.len() != rank {
            break;
        }
        for pivot in pivots {
            used[pivot] = true;
        }
        compiled.extend_from_slice(&basis);
    }
    compiled
}

#[inline(always)]
fn packed_bit(words: &[u64], row: usize, word_count: usize, coordinate: usize) -> bool {
    words[row * word_count + coordinate / 64] & (1u64 << (coordinate % 64)) != 0
}

#[cfg(test)]
mod tests {
    use super::*;

    fn force_brouwer_zimmermann(
        mut compiled: CompiledBinaryLinearCode,
    ) -> CompiledBinaryLinearCode {
        let rank = compiled.rank();
        let word_count = compiled.word_count as usize;
        let systematic_bases = compile_disjoint_systematic_bases(
            &compiled.basis_words,
            rank,
            word_count,
            compiled.coordinate_count(),
        );
        compiled.information_set_count = (systematic_bases.len() / (rank * word_count)) as u16;
        compiled.systematic_row_upper_bound = systematic_bases
            .chunks_exact(word_count)
            .map(packed_weight)
            .min()
            .unwrap_or(u16::MAX);
        compiled.systematic_bases = systematic_bases.into_boxed_slice();
        compiled
    }

    #[test]
    fn gray_enumeration_finds_and_replays_the_minimum_word() {
        let generator = Matrix::new::<2>(
            3,
            8,
            vec![
                1, 1, 1, 1, 0, 0, 0, 0, //
                0, 0, 1, 1, 1, 1, 0, 0, //
                0, 0, 0, 0, 1, 1, 1, 1,
            ],
        )
        .unwrap();
        let compiled = CompiledBinaryLinearCode::compile(&generator).unwrap();
        let result = compiled.minimum_nonzero_weight();
        assert_eq!(compiled.rank(), 3);
        assert_eq!(result.weight, Some(4));
        assert_eq!(result.candidates, 7);
        assert_eq!(result.support.len(), 4);
    }

    #[test]
    fn rank_zero_code_has_no_nonzero_word() {
        let generator = Matrix::new::<2>(0, 9, Vec::new()).unwrap();
        let compiled = CompiledBinaryLinearCode::compile(&generator).unwrap();
        assert_eq!(compiled.minimum_nonzero_weight().weight, None);
    }

    #[test]
    fn weight_one_is_an_exact_early_stop() {
        let generator = Matrix::new::<2>(2, 4, vec![1, 0, 0, 0, 0, 1, 1, 0]).unwrap();
        let result = CompiledBinaryLinearCode::compile(&generator)
            .unwrap()
            .minimum_nonzero_weight();
        assert_eq!(result.weight, Some(1));
        assert_eq!(&*result.support, &[0]);
        assert_eq!(result.candidates, 1);
    }

    #[test]
    fn brouwer_zimmermann_matches_gray_on_deterministic_small_codes() {
        let mut seed = 0x4d59_5df4_d0f3_3173u64;
        for rank in 4..=10 {
            let coordinates = rank * 3;
            for _ in 0..12 {
                let mut data = vec![0u8; rank * coordinates];
                for row in 0..rank {
                    data[row * coordinates + row] = 1;
                    data[row * coordinates + rank + row] = 1;
                    for coordinate in 2 * rank..coordinates {
                        seed = seed
                            .wrapping_mul(6_364_136_223_846_793_005)
                            .wrapping_add(1_442_695_040_888_963_407);
                        data[row * coordinates + coordinate] = (seed >> 63) as u8;
                    }
                }
                let matrix = Matrix::new::<2>(rank, coordinates, data).unwrap();
                let compiled =
                    force_brouwer_zimmermann(CompiledBinaryLinearCode::compile(&matrix).unwrap());
                assert!(compiled.information_set_count() >= 2);
                let gray = compiled.minimum_nonzero_weight_gray_scan(&mut compiled.workspace());
                let bz = compiled
                    .minimum_nonzero_weight_brouwer_zimmermann_scan(&mut compiled.workspace());
                assert_eq!(bz.weight, gray.weight);
            }
        }
    }

    #[test]
    fn automatic_crossover_uses_information_set_lower_bound() {
        let rank = 24;
        let coordinates = rank * 2;
        let mut data = vec![0u8; rank * coordinates];
        for row in 0..rank {
            data[row * coordinates + row] = 1;
            data[row * coordinates + rank + row] = 1;
        }
        let matrix = Matrix::new::<2>(rank, coordinates, data).unwrap();
        let compiled = CompiledBinaryLinearCode::compile(&matrix).unwrap();
        assert_eq!(compiled.information_set_count(), 2);
        assert_eq!(
            compiled.recommended_algorithm(),
            BinaryLinearAlgorithm::BrouwerZimmermann
        );
        let result = compiled.minimum_nonzero_weight();
        assert_eq!(result.weight, Some(2));
        assert_eq!(result.candidates, 48);
    }
}
