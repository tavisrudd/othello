//! Structural whole-fibre census between q29 coefficients and q174 states.
//!
//! A q29 large-orbit decomposition is a capacitated six-by-seven degree
//! matrix.  Rows 0--3 have unit weight and capacities 1,1,2,2 per column;
//! rows 4--5 have weight three and capacity two.  A capacity-two cell whose
//! value is one has two distinct q174 orientations.  This module counts the
//! degree matrices and their orientation assignments without selecting an
//! arbitrary source preimage.

use serde::Serialize;
use sha2::{Digest, Sha256};
use thiserror::Error;

use crate::g41_q29_evolve::digit_counts;

const ROWS: usize = 6;
const COLUMNS: usize = 7;
const MAX_LOCAL_CHOICES: usize = 324;
const CAPACITIES: [u8; ROWS] = [1, 1, 2, 2, 2, 2];
const WEIGHTS: [u8; ROWS] = [1, 1, 1, 1, 3, 3];
const EXTRACTOR: &str = "c1016.g41.q174.degree-fibre";
const EXTRACTOR_VERSION: u16 = 1;

#[derive(Clone, Debug, Error, PartialEq, Eq)]
pub enum G41Q174DegreeFibreError {
    #[error("q174 degree-fibre semantic binding failed")]
    SemanticMismatch,
    #[error("q174 degree-fibre arithmetic or workspace bound was exceeded")]
    ResourceBound,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q174DegreeFibreReport {
    pub digits: u32,
    pub q29_coefficients: [u8; 8],
    pub degree_matrices: u64,
    pub oriented_decompositions_upper_bound: u128,
    pub maximum_orientation_bits: u8,
    pub states_after_column: [u32; COLUMNS],
    pub workspace_bytes: u64,
    pub extractor: &'static str,
    pub extractor_version: u16,
    pub semantic_commitment: [u8; 32],
    pub provenance: &'static str,
}

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
struct CountState {
    matrices: u64,
    oriented: u128,
    maximum_orientation_bits: u8,
}

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
struct LocalChoice {
    counts: [u8; ROWS],
    orientation_bits: u8,
}

/// Presized workspace for repeated coefficient fibres sharing one digit row.
///
/// Construction allocates; `census` performs no allocation.
pub struct G41Q174DegreeFibreWorkspace {
    digits: u32,
    target_counts: [u8; ROWS],
    radices: [u32; ROWS],
    state_count: usize,
    current_values: Box<[CountState]>,
    next_values: Box<[CountState]>,
    current: Vec<u32>,
    next: Vec<u32>,
}

impl G41Q174DegreeFibreWorkspace {
    pub fn new(digits: u32) -> Result<Self, G41Q174DegreeFibreError> {
        let target_counts = digit_counts(digits);
        if target_counts
            .iter()
            .zip(CAPACITIES)
            .any(|(&count, capacity)| count > COLUMNS as u8 * capacity)
        {
            return Err(G41Q174DegreeFibreError::SemanticMismatch);
        }
        let radices = target_counts.map(|count| u32::from(count) + 1);
        let state_count = radices
            .iter()
            .try_fold(1_usize, |product, &radix| {
                product.checked_mul(radix as usize)
            })
            .ok_or(G41Q174DegreeFibreError::ResourceBound)?;
        let bytes = state_count
            .checked_mul(2 * std::mem::size_of::<CountState>() + 2 * std::mem::size_of::<u32>())
            .ok_or(G41Q174DegreeFibreError::ResourceBound)?;
        if bytes > 2 * 1024 * 1024 * 1024_usize {
            return Err(G41Q174DegreeFibreError::ResourceBound);
        }
        Ok(Self {
            digits,
            target_counts,
            radices,
            state_count,
            current_values: vec![CountState::default(); state_count].into_boxed_slice(),
            next_values: vec![CountState::default(); state_count].into_boxed_slice(),
            current: Vec::with_capacity(state_count),
            next: Vec::with_capacity(state_count),
        })
    }

    pub fn workspace_bytes(&self) -> u64 {
        (self.state_count
            * (2 * std::mem::size_of::<CountState>() + 2 * std::mem::size_of::<u32>()))
            as u64
    }

    #[inline(always)]
    fn encode(&self, counts: [u8; ROWS]) -> u32 {
        let mut key = 0_u32;
        let mut stride = 1_u32;
        for row in 0..ROWS {
            key += u32::from(counts[row]) * stride;
            stride *= self.radices[row];
        }
        key
    }

    #[inline(always)]
    fn decode(&self, mut key: u32) -> [u8; ROWS] {
        std::array::from_fn(|row| {
            let value = (key % self.radices[row]) as u8;
            key /= self.radices[row];
            value
        })
    }

    fn clear_touched(&mut self) {
        for &key in &self.current {
            self.current_values[key as usize] = CountState::default();
        }
        for &key in &self.next {
            self.next_values[key as usize] = CountState::default();
        }
        self.current.clear();
        self.next.clear();
    }

    pub fn census(
        &mut self,
        q29_coefficients: [u8; 8],
    ) -> Result<G41Q174DegreeFibreReport, G41Q174DegreeFibreError> {
        if q29_coefficients.iter().any(|&value| value > 18) {
            return Err(G41Q174DegreeFibreError::SemanticMismatch);
        }
        self.clear_touched();
        self.current.push(0);
        self.current_values[0] = CountState {
            matrices: 1,
            oriented: 1,
            maximum_orientation_bits: 0,
        };
        let mut states_after_column = [0_u32; COLUMNS];
        let mut local = [LocalChoice::default(); MAX_LOCAL_CHOICES];
        for column in 0..COLUMNS {
            for &key in &self.next {
                self.next_values[key as usize] = CountState::default();
            }
            self.next.clear();
            let local_len = compile_local_choices(q29_coefficients[column + 1], &mut local);
            for &key in &self.current {
                let used = self.decode(key);
                let source = self.current_values[key as usize];
                for choice in &local[..local_len] {
                    let mut combined = [0_u8; ROWS];
                    let mut within = true;
                    for row in 0..ROWS {
                        combined[row] = used[row] + choice.counts[row];
                        within &= combined[row] <= self.target_counts[row];
                    }
                    if !within {
                        continue;
                    }
                    let next_key = self.encode(combined);
                    let destination = &mut self.next_values[next_key as usize];
                    if destination.matrices == 0 {
                        self.next.push(next_key);
                    }
                    destination.matrices = destination
                        .matrices
                        .checked_add(source.matrices)
                        .ok_or(G41Q174DegreeFibreError::ResourceBound)?;
                    let oriented = source
                        .oriented
                        .checked_shl(u32::from(choice.orientation_bits))
                        .ok_or(G41Q174DegreeFibreError::ResourceBound)?;
                    destination.oriented = destination
                        .oriented
                        .checked_add(oriented)
                        .ok_or(G41Q174DegreeFibreError::ResourceBound)?;
                    destination.maximum_orientation_bits = destination
                        .maximum_orientation_bits
                        .max(source.maximum_orientation_bits + choice.orientation_bits);
                }
            }
            for &key in &self.current {
                self.current_values[key as usize] = CountState::default();
            }
            std::mem::swap(&mut self.current, &mut self.next);
            std::mem::swap(&mut self.current_values, &mut self.next_values);
            states_after_column[column] = self.current.len() as u32;
        }
        let final_key = self.encode(self.target_counts);
        let result = self.current_values[final_key as usize];
        let semantic_commitment = semantic_commitment(self.digits, q29_coefficients);
        Ok(G41Q174DegreeFibreReport {
            digits: self.digits,
            q29_coefficients,
            degree_matrices: result.matrices,
            oriented_decompositions_upper_bound: result.oriented,
            maximum_orientation_bits: result.maximum_orientation_bits,
            states_after_column,
            workspace_bytes: self.workspace_bytes(),
            extractor: EXTRACTOR,
            extractor_version: EXTRACTOR_VERSION,
            semantic_commitment,
            provenance: "sealed structural whole-fibre census: iterative capacitated six-by-seven degree-matrix DP counts every q29 decomposition class, while each half-filled capacity-two cell contributes its two exact q174 orientations; the orientation total is a safe upper bound because distinct source orientations may coalesce in the packed q174 quotient; no representative preimage authorizes exclusion",
        })
    }
}

fn compile_local_choices(target: u8, output: &mut [LocalChoice; MAX_LOCAL_CHOICES]) -> usize {
    let mut used = 0_usize;
    for first in 0..=CAPACITIES[0] {
        for second in 0..=CAPACITIES[1] {
            for third in 0..=CAPACITIES[2] {
                for fourth in 0..=CAPACITIES[3] {
                    for fifth in 0..=CAPACITIES[4] {
                        for sixth in 0..=CAPACITIES[5] {
                            let counts = [first, second, third, fourth, fifth, sixth];
                            let weighted =
                                (0..ROWS).map(|row| counts[row] * WEIGHTS[row]).sum::<u8>();
                            if weighted != target {
                                continue;
                            }
                            let orientation_bits = (2..ROWS)
                                .filter(|&row| CAPACITIES[row] == 2 && counts[row] == 1)
                                .count() as u8;
                            output[used] = LocalChoice {
                                counts,
                                orientation_bits,
                            };
                            used += 1;
                        }
                    }
                }
            }
        }
    }
    used
}

fn semantic_commitment(digits: u32, coefficients: [u8; 8]) -> [u8; 32] {
    let mut digest = Sha256::new();
    digest.update(EXTRACTOR.as_bytes());
    digest.update(EXTRACTOR_VERSION.to_le_bytes());
    digest.update(CAPACITIES);
    digest.update(WEIGHTS);
    digest.update((ROWS as u16).to_le_bytes());
    digest.update((COLUMNS as u16).to_le_bytes());
    digest.update(digits.to_le_bytes());
    digest.update(coefficients);
    digest.finalize().into()
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::allocation_test::tracked_allocations;
    use crate::g41_q29_exact_tablebase::g41_q29_degree_sequence_decomposition_feasible;

    fn pack_counts(counts: [u8; ROWS]) -> u32 {
        let shifts = [0, 3, 6, 10, 14, 18];
        (0..ROWS).fold(0_u32, |packed, slot| {
            packed | (u32::from(counts[slot]) << shifts[slot])
        })
    }

    #[test]
    fn local_choice_table_is_independently_exhaustive() {
        let mut output = [LocalChoice::default(); MAX_LOCAL_CHOICES];
        for target in 0..=18 {
            let length = compile_local_choices(target, &mut output);
            let direct = (0_u16..324)
                .filter(|&code| {
                    let mut code = code;
                    let mut weighted = 0_u8;
                    for row in 0..ROWS {
                        let radix = u16::from(CAPACITIES[row]) + 1;
                        weighted += (code % radix) as u8 * WEIGHTS[row];
                        code /= radix;
                    }
                    weighted == target
                })
                .count();
            assert_eq!(length, direct);
            assert!(output[..length].iter().all(|choice| {
                (0..ROWS)
                    .map(|row| choice.counts[row] * WEIGHTS[row])
                    .sum::<u8>()
                    == target
            }));
        }
    }

    #[test]
    fn census_agrees_with_structural_feasibility() {
        let digits = pack_counts([3, 2, 5, 7, 6, 4]);
        let coefficients = [0, 8, 10, 10, 9, 8, 10, 8];
        let mut workspace = G41Q174DegreeFibreWorkspace::new(digits).unwrap();
        let report = workspace.census(coefficients).unwrap();
        assert_eq!(
            report.degree_matrices != 0,
            g41_q29_degree_sequence_decomposition_feasible(digits, coefficients).unwrap()
        );
        assert!(report.oriented_decompositions_upper_bound >= u128::from(report.degree_matrices));
        assert!(report.maximum_orientation_bits <= 28);
    }

    #[test]
    fn repeated_census_allocates_nothing() {
        let digits = pack_counts([1, 1, 2, 2, 2, 2]);
        let mut workspace = G41Q174DegreeFibreWorkspace::new(digits).unwrap();
        let coefficients = [0, 4, 4, 4, 4, 4, 4, 4];
        workspace.census(coefficients).unwrap();
        let (_, allocations) = tracked_allocations(|| workspace.census(coefficients).unwrap());
        assert_eq!(allocations, 0);
    }

    #[test]
    fn semantic_commitment_binds_inputs() {
        let first = semantic_commitment(1, [0; 8]);
        assert_ne!(first, semantic_commitment(2, [0; 8]));
        assert_ne!(first, semantic_commitment(1, [0, 1, 0, 0, 0, 0, 0, 0]));
    }
}
