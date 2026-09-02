//! Sparse cyclic Gram-square predicates for the g41 q58 anti profiles.
//!
//! If four cyclic sequences have total autocorrelation `523 delta_0`, then
//! for every signed cyclic mask `w` each block convolution norm is
//! nonnegative and at most `523 ||w||^2`. Candidate masks may be evolved and
//! ordered heuristically; authority comes only from this square identity.

use serde::Serialize;
use thiserror::Error;

use crate::g41_q29_evolve::Q29_COSETS;
use crate::g41_q58_exact_tablebase::G41Q58AntiProfile;

pub const MAX_GRAM_SUPPORT: usize = 6;

/// Cold, canonical source for a dense cyclic Gram-square predicate.  Search
/// may propose these weights by any heuristic; compilation below derives the
/// complete hot semantics using integer arithmetic.
#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q58DenseGramWitnessSource {
    pub weights: [i16; 29],
}

/// Hot semantic projection of a dense cyclic Gram witness.
#[repr(C)]
#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq, PartialOrd, Ord)]
pub struct G41Q58DenseGramPredicate {
    pub norm_square: u32,
    pub residual_coefficients: [i32; 7],
}

const _: () = assert!(
    std::mem::size_of::<G41Q58DenseGramPredicate>() == 32
        && std::mem::align_of::<G41Q58DenseGramPredicate>() == 4
);

#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq, PartialOrd, Ord)]
pub struct G41Q58GramMask {
    pub arity: u8,
    pub positions: [u8; MAX_GRAM_SUPPORT],
    pub signs: [i8; MAX_GRAM_SUPPORT],
    pub residual_coefficients: [i8; 7],
}

#[derive(Clone, Debug, Error, PartialEq, Eq)]
pub enum G41Q58GramMaskError {
    #[error("g41 q58 Gram mask shape is invalid")]
    Shape,
    #[error("g41 q58 Gram mask shift orbit is missing")]
    Orbit,
    #[error("g41 q58 dense Gram witness exceeds its arithmetic carrier")]
    Arithmetic,
}

/// Discovery-only Fourier proposal family.  The floating-point trigonometry
/// has no proof authority: every returned source must pass through
/// [`G41Q58DenseGramWitnessSource::compile`], whose integer convolution
/// identity supplies the complete predicate semantics.
pub fn propose_q29_fourier_gram_witnesses(scales: &[i16]) -> Vec<G41Q58DenseGramWitnessSource> {
    let mut sources = Vec::with_capacity(7 * scales.len() * 2);
    for coset in Q29_COSETS {
        let frequency = coset[0] as f64;
        for &scale in scales {
            for sine in [false, true] {
                let weights = std::array::from_fn(|residue| {
                    let angle = std::f64::consts::TAU * frequency * residue as f64 / 29.0;
                    let value = if sine { angle.sin() } else { angle.cos() };
                    (f64::from(scale) * value).round() as i16
                });
                sources.push(G41Q58DenseGramWitnessSource { weights });
            }
        }
    }
    sources
}

impl G41Q58DenseGramWitnessSource {
    /// Seal an explicit integer vector into its exact quotient-autocorrelation
    /// semantics.  This does not trust a feature name or a numerical Fourier
    /// interpretation.
    pub fn compile(self) -> Result<G41Q58DenseGramPredicate, G41Q58GramMaskError> {
        let norm_square: u32 = self
            .weights
            .iter()
            .try_fold(0_i64, |sum, &weight| {
                sum.checked_add(i64::from(weight) * i64::from(weight))
            })
            .ok_or(G41Q58GramMaskError::Arithmetic)?
            .try_into()
            .map_err(|_| G41Q58GramMaskError::Arithmetic)?;
        if norm_square == 0 {
            return Err(G41Q58GramMaskError::Shape);
        }
        let mut coefficients = [0_i64; 7];
        for first in 0..29 {
            for second in first + 1..29 {
                let shift = second - first;
                let coordinate = coordinate_of_shift(shift).ok_or(G41Q58GramMaskError::Orbit)?;
                coefficients[coordinate] = coefficients[coordinate]
                    .checked_add(i64::from(self.weights[first]) * i64::from(self.weights[second]))
                    .ok_or(G41Q58GramMaskError::Arithmetic)?;
            }
        }
        let mut residual_coefficients = [0_i32; 7];
        for coordinate in 0..7 {
            residual_coefficients[coordinate] = coefficients[coordinate]
                .try_into()
                .map_err(|_| G41Q58GramMaskError::Arithmetic)?;
        }
        Ok(G41Q58DenseGramPredicate {
            norm_square,
            residual_coefficients,
        })
    }
}

impl G41Q58DenseGramPredicate {
    #[inline(always)]
    pub fn terminal_from_terms(self, energy: u16, residuals: [i16; 7]) -> i64 {
        let mut value = i64::from(self.norm_square) * i64::from(energy);
        for (coefficient, residual) in self.residual_coefficients.into_iter().zip(residuals) {
            value += 2 * i64::from(coefficient) * i64::from(residual);
        }
        value
    }

    #[inline(always)]
    pub fn terminal(self, profile: G41Q58AntiProfile) -> i64 {
        self.terminal_from_terms(
            profile.energy(),
            std::array::from_fn(|coordinate| profile.residual(coordinate).unwrap()),
        )
    }

    #[inline(always)]
    pub fn permits(self, profile: G41Q58AntiProfile) -> bool {
        let terminal = self.terminal(profile);
        debug_assert!(terminal >= 0);
        terminal <= i64::from(self.norm_square) * 523
    }
}

impl G41Q58GramMask {
    #[inline(always)]
    pub fn terminal_from_terms(self, energy: u16, residuals: [i16; 7]) -> i32 {
        let mut value = i32::from(self.arity) * i32::from(energy);
        for coordinate in 0..7 {
            value += 2
                * i32::from(self.residual_coefficients[coordinate])
                * i32::from(residuals[coordinate]);
        }
        value
    }

    #[inline(always)]
    pub fn terminal(self, profile: G41Q58AntiProfile) -> i32 {
        self.terminal_from_terms(
            profile.energy(),
            std::array::from_fn(|coordinate| profile.residual(coordinate).unwrap()),
        )
    }

    #[inline(always)]
    pub fn permits(self, profile: G41Q58AntiProfile) -> bool {
        let terminal = self.terminal(profile);
        debug_assert!(terminal >= 0);
        terminal <= i32::from(self.arity) * 523
    }
}

fn coordinate_of_shift(shift: usize) -> Option<usize> {
    (0..7).find(|&coordinate| Q29_COSETS[coordinate].contains(&(shift % 29)))
}

fn push_mask(
    masks: &mut Vec<G41Q58GramMask>,
    arity: usize,
    positions: [u8; MAX_GRAM_SUPPORT],
    signs: [i8; MAX_GRAM_SUPPORT],
) -> Result<(), G41Q58GramMaskError> {
    if !(3..=MAX_GRAM_SUPPORT).contains(&arity)
        || positions[0] != 0
        || signs[0] != 1
        || (0..arity).any(|index| signs[index].unsigned_abs() != 1)
    {
        return Err(G41Q58GramMaskError::Shape);
    }
    let mut residual_coefficients = [0_i8; 7];
    for first in 0..arity {
        for next in first + 1..arity {
            let shift = (usize::from(positions[next]) + 29 - usize::from(positions[first])) % 29;
            let coordinate = coordinate_of_shift(shift).ok_or(G41Q58GramMaskError::Orbit)?;
            residual_coefficients[coordinate] += signs[first] * signs[next];
        }
    }
    masks.push(G41Q58GramMask {
        arity: arity as u8,
        positions,
        signs,
        residual_coefficients,
    });
    Ok(())
}

/// Compile the complete translation-normalized signed-mask grammar through
/// the requested support. The loops are explicit and iterative; masks with
/// identical quadratic terminals are deduplicated canonically.
pub fn compile_complete_g41_q58_gram_masks(
    maximum_arity: u8,
) -> Result<Vec<G41Q58GramMask>, G41Q58GramMaskError> {
    if !(3..=MAX_GRAM_SUPPORT as u8).contains(&maximum_arity) {
        return Err(G41Q58GramMaskError::Shape);
    }
    let mut masks = Vec::with_capacity(if maximum_arity == 6 {
        3_500_000
    } else {
        500_000
    });
    for second in 1..29 {
        for third in second + 1..29 {
            for second_sign in [-1_i8, 1] {
                for third_sign in [-1_i8, 1] {
                    push_mask(
                        &mut masks,
                        3,
                        [0, second as u8, third as u8, 0, 0, 0],
                        [1, second_sign, third_sign, 0, 0, 0],
                    )?;
                    if maximum_arity >= 4 {
                        for fourth in third + 1..29 {
                            for fourth_sign in [-1_i8, 1] {
                                push_mask(
                                    &mut masks,
                                    4,
                                    [0, second as u8, third as u8, fourth as u8, 0, 0],
                                    [1, second_sign, third_sign, fourth_sign, 0, 0],
                                )?;
                                if maximum_arity >= 5 {
                                    for fifth in fourth + 1..29 {
                                        for fifth_sign in [-1_i8, 1] {
                                            push_mask(
                                                &mut masks,
                                                5,
                                                [
                                                    0,
                                                    second as u8,
                                                    third as u8,
                                                    fourth as u8,
                                                    fifth as u8,
                                                    0,
                                                ],
                                                [
                                                    1,
                                                    second_sign,
                                                    third_sign,
                                                    fourth_sign,
                                                    fifth_sign,
                                                    0,
                                                ],
                                            )?;
                                            if maximum_arity >= 6 {
                                                for sixth in fifth + 1..29 {
                                                    for sixth_sign in [-1_i8, 1] {
                                                        push_mask(
                                                            &mut masks,
                                                            6,
                                                            [
                                                                0,
                                                                second as u8,
                                                                third as u8,
                                                                fourth as u8,
                                                                fifth as u8,
                                                                sixth as u8,
                                                            ],
                                                            [
                                                                1,
                                                                second_sign,
                                                                third_sign,
                                                                fourth_sign,
                                                                fifth_sign,
                                                                sixth_sign,
                                                            ],
                                                        )?;
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
            }
        }
    }
    masks.sort_unstable_by_key(|mask| (mask.arity, mask.residual_coefficients));
    masks.dedup_by_key(|mask| (mask.arity, mask.residual_coefficients));
    Ok(masks)
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::allocation_test::tracked_allocations;

    fn direct_terms(values: [i16; 8]) -> (u16, [i16; 7], [i16; 29]) {
        let mut sequence = [0_i16; 29];
        sequence[0] = values[0];
        for coordinate in 0..7 {
            for &residue in &Q29_COSETS[coordinate] {
                sequence[residue] = values[coordinate + 1];
            }
        }
        let energy: i32 = sequence
            .iter()
            .map(|&value| i32::from(value) * i32::from(value))
            .sum();
        let residuals = std::array::from_fn(|coordinate| {
            let shift = Q29_COSETS[coordinate][0];
            (0..29)
                .map(|residue| {
                    i32::from(sequence[residue]) * i32::from(sequence[(residue + shift) % 29])
                })
                .sum::<i32>() as i16
        });
        (energy as u16, residuals, sequence)
    }

    #[test]
    fn complete_mask_counts_are_stable() {
        assert_eq!(compile_complete_g41_q58_gram_masks(3).unwrap().len(), 119);
        assert_eq!(
            compile_complete_g41_q58_gram_masks(6).unwrap().len(),
            42_358
        );
    }

    #[test]
    fn every_size_three_terminal_matches_direct_cyclic_convolution() {
        let masks = compile_complete_g41_q58_gram_masks(3).unwrap();
        let (energy, residuals, sequence) = direct_terms([2, -1, 3, 0, -2, 1, 2, -3]);
        for mask in masks {
            let direct: i32 = (0..29)
                .map(|residue| {
                    let sum: i32 = (0..usize::from(mask.arity))
                        .map(|term| {
                            i32::from(mask.signs[term])
                                * i32::from(
                                    sequence[(residue + usize::from(mask.positions[term])) % 29],
                                )
                        })
                        .sum();
                    sum * sum
                })
                .sum();
            assert_eq!(mask.terminal_from_terms(energy, residuals), direct);
        }
    }

    #[test]
    fn promoted_mask_hot_loop_allocates_nothing() {
        let masks = compile_complete_g41_q58_gram_masks(3).unwrap();
        let (energy, residuals, _) = direct_terms([2, -1, 3, 0, -2, 1, 2, -3]);
        let (_, allocations) = tracked_allocations(|| {
            for &mask in &masks {
                assert!(mask.terminal_from_terms(energy, residuals) >= 0);
            }
        });
        assert_eq!(allocations, 0);
    }

    #[test]
    fn dense_witness_terminal_matches_direct_cyclic_convolution() {
        let source = G41Q58DenseGramWitnessSource {
            weights: std::array::from_fn(|index| (index as i16 % 7) - 3),
        };
        let predicate = source.compile().unwrap();
        let (energy, residuals, sequence) = direct_terms([2, -1, 3, 0, -2, 1, 2, -3]);
        let direct: i64 = (0..29)
            .map(|residue| {
                let sum: i64 = (0..29)
                    .map(|term| {
                        i64::from(source.weights[term]) * i64::from(sequence[(residue + term) % 29])
                    })
                    .sum();
                sum * sum
            })
            .sum();
        assert_eq!(predicate.terminal_from_terms(energy, residuals), direct);
    }

    #[test]
    fn dense_witness_compilation_fails_closed_at_boundaries() {
        assert_eq!(
            G41Q58DenseGramWitnessSource { weights: [0; 29] }.compile(),
            Err(G41Q58GramMaskError::Shape)
        );
        assert_eq!(
            G41Q58DenseGramWitnessSource {
                weights: [i16::MAX; 29],
            }
            .compile(),
            Err(G41Q58GramMaskError::Arithmetic)
        );
    }

    #[test]
    fn dense_witness_hot_loop_allocates_nothing() {
        let predicate = G41Q58DenseGramWitnessSource {
            weights: std::array::from_fn(|index| (index as i16 % 5) - 2),
        }
        .compile()
        .unwrap();
        let (energy, residuals, _) = direct_terms([2, -1, 3, 0, -2, 1, 2, -3]);
        let (_, allocations) = tracked_allocations(|| {
            for _ in 0..1_024 {
                assert!(predicate.terminal_from_terms(energy, residuals) >= 0);
            }
        });
        assert_eq!(allocations, 0);
    }

    #[test]
    fn fourier_proposals_are_discovery_only_sources_with_exact_compilations() {
        let first = propose_q29_fourier_gram_witnesses(&[2, 3]);
        let second = propose_q29_fourier_gram_witnesses(&[2, 3]);
        assert_eq!(first, second);
        assert_eq!(first.len(), 28);
        assert!(first.into_iter().all(|source| source.compile().is_ok()));
    }
}
