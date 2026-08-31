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
}

#[derive(Clone, Debug)]
pub struct CompiledBinaryLinearCode {
    basis_words: Box<[u64]>,
    coordinate_count: u16,
    rank: u8,
    word_count: u16,
}

#[derive(Clone, Debug)]
pub struct BinaryLinearCodeWorkspace {
    current: Box<[u64]>,
    best: Box<[u64]>,
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
        let word_count = basis.cols().div_ceil(64);
        let mut basis_words = vec![0u64; basis.rows().saturating_mul(word_count)];
        for row in 0..basis.rows() {
            for (coordinate, &entry) in basis.row(row).iter().enumerate() {
                if entry != 0 {
                    basis_words[row * word_count + coordinate / 64] |= 1u64 << (coordinate % 64);
                }
            }
        }
        Ok(Self {
            basis_words: basis_words.into_boxed_slice(),
            coordinate_count: basis.cols() as u16,
            rank: basis.rows() as u8,
            word_count: word_count as u16,
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
        let summary = self.minimum_nonzero_weight_scan(workspace);
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
    pub fn minimum_nonzero_weight_scan(
        &self,
        workspace: &mut BinaryLinearCodeWorkspace,
    ) -> BinaryLinearWeightSummary {
        let word_count = self.word_count as usize;
        assert_eq!(workspace.current.len(), word_count);
        assert_eq!(workspace.best.len(), word_count);
        workspace.current.fill(0);
        workspace.best.fill(0);
        if self.rank == 0 {
            return BinaryLinearWeightSummary {
                weight: None,
                candidates: 0,
            };
        }
        let candidate_count = (1u64 << self.rank) - 1;
        let mut best_weight = self.coordinate_count.saturating_add(1);
        let mut candidates = 0u64;
        for step in 1..=candidate_count {
            let changed_row = step.trailing_zeros() as usize;
            let basis = &self.basis_words[changed_row * word_count..(changed_row + 1) * word_count];
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
}

#[cfg(test)]
mod tests {
    use super::*;

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
}
