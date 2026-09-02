//! Exact cyclic quotient autocorrelation defects.
//!
//! If a length-`N` supplementary family has total row weight `K` and every
//! nonzero periodic autocorrelation sum equals `lambda`, then for every
//! divisor `D | N` the quotient coefficient vectors satisfy
//! `sum_b (A_b(0) - A_b(t)) = K - lambda` for every nonzero `t in Z/D`.
//! This is a partition of the original shifts by residue modulo `D`, not a
//! heuristic or certificate lookup.

use thiserror::Error;

use crate::feature_synthesis::FeatureOrigin;

#[derive(Clone, Debug, Error, PartialEq, Eq)]
pub enum CyclicQuotientDefectError {
    #[error("cyclic quotient dimensions or binary word semantics are invalid")]
    SemanticMismatch,
    #[error("cyclic quotient arithmetic exceeded its checked carrier")]
    ArithmeticOverflow,
}

#[repr(transparent)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct QuotientCoefficients<const D: usize>([u16; D]);

#[derive(Clone, Copy, Debug, serde::Serialize, PartialEq, Eq)]
pub struct CyclicQuotientObstruction {
    pub modulus: u16,
    pub mismatches: u16,
    pub l1_residual: u64,
    pub maximum_absolute_residual: u32,
    pub candidates_tested: u16,
    pub origin: FeatureOrigin,
    pub blindness_level: u8,
}

impl<const D: usize> QuotientCoefficients<D> {
    pub fn compile<const N: usize>(word: &[u8; N]) -> Result<Self, CyclicQuotientDefectError> {
        if D < 2 || N == 0 || !N.is_multiple_of(D) || word.iter().any(|&value| value > 1) {
            return Err(CyclicQuotientDefectError::SemanticMismatch);
        }
        let mut coefficients = [0_u16; D];
        for (position, &value) in word.iter().enumerate() {
            coefficients[position % D] = coefficients[position % D]
                .checked_add(u16::from(value))
                .ok_or(CyclicQuotientDefectError::ArithmeticOverflow)?;
        }
        Ok(Self(coefficients))
    }

    pub fn values(&self) -> &[u16; D] {
        &self.0
    }

    pub fn defects_into(&self, output: &mut [i32; D]) -> Result<(), CyclicQuotientDefectError> {
        let zero = self.0.iter().try_fold(0_u32, |sum, &value| {
            sum.checked_add(u32::from(value) * u32::from(value))
                .ok_or(CyclicQuotientDefectError::ArithmeticOverflow)
        })?;
        output[0] = 0;
        for shift in 1..D {
            let shifted = (0..D).try_fold(0_u32, |sum, residue| {
                sum.checked_add(
                    u32::from(self.0[residue]) * u32::from(self.0[(residue + shift) % D]),
                )
                .ok_or(CyclicQuotientDefectError::ArithmeticOverflow)
            })?;
            output[shift] = i32::try_from(zero)
                .map_err(|_| CyclicQuotientDefectError::ArithmeticOverflow)?
                - i32::try_from(shifted)
                    .map_err(|_| CyclicQuotientDefectError::ArithmeticOverflow)?;
        }
        Ok(())
    }
}

pub fn supplementary_quotient_residual<const D: usize>(
    blocks: &[QuotientCoefficients<D>],
    total_row_weight: u32,
    nonzero_paf_target: u32,
) -> Result<u64, CyclicQuotientDefectError> {
    let target = i64::from(total_row_weight) - i64::from(nonzero_paf_target);
    let mut totals = [0_i64; D];
    let mut defects = [0_i32; D];
    for block in blocks {
        block.defects_into(&mut defects)?;
        for shift in 1..D {
            totals[shift] = totals[shift]
                .checked_add(i64::from(defects[shift]))
                .ok_or(CyclicQuotientDefectError::ArithmeticOverflow)?;
        }
    }
    totals[1..].iter().try_fold(0_u64, |sum, &value| {
        sum.checked_add(value.abs_diff(target))
            .ok_or(CyclicQuotientDefectError::ArithmeticOverflow)
    })
}

/// Blindly search the divisor lattice for the least mixed quotient that
/// rejects the supplied authenticated words. The caller supplies raw binary
/// words and SDS parameters; no modulus or shift is seeded. The bounded hot
/// candidate loop is iterative and allocation-free.
pub fn mine_cyclic_quotient_obstruction<const N: usize, const B: usize>(
    words: &[[u8; N]; B],
    total_row_weight: u32,
    nonzero_paf_target: u32,
    maximum_modulus: usize,
    blindness_level: u8,
) -> Result<Option<CyclicQuotientObstruction>, CyclicQuotientDefectError> {
    if N < 3
        || B == 0
        || maximum_modulus < 2
        || maximum_modulus > N
        || words.iter().flatten().any(|&value| value > 1)
    {
        return Err(CyclicQuotientDefectError::SemanticMismatch);
    }
    let target = i64::from(total_row_weight) - i64::from(nonzero_paf_target);
    let mut candidates_tested = 0_u16;
    let mut coefficients = [[0_u16; N]; B];
    for modulus in 2..=maximum_modulus {
        if !N.is_multiple_of(modulus) {
            continue;
        }
        candidates_tested = candidates_tested
            .checked_add(1)
            .ok_or(CyclicQuotientDefectError::ArithmeticOverflow)?;
        for block in 0..B {
            coefficients[block][..modulus].fill(0);
            for (position, &value) in words[block].iter().enumerate() {
                coefficients[block][position % modulus] += u16::from(value);
            }
        }
        let mut mismatches = 0_u16;
        let mut l1_residual = 0_u64;
        let mut maximum_absolute_residual = 0_u32;
        for shift in 1..modulus {
            let mut total = 0_i64;
            for block in 0..B {
                let zero: u32 = coefficients[block][..modulus]
                    .iter()
                    .map(|&value| u32::from(value) * u32::from(value))
                    .sum();
                let shifted: u32 = (0..modulus)
                    .map(|residue| {
                        u32::from(coefficients[block][residue])
                            * u32::from(coefficients[block][(residue + shift) % modulus])
                    })
                    .sum();
                total += i64::from(zero) - i64::from(shifted);
            }
            let residual = total.abs_diff(target);
            if residual != 0 {
                mismatches += 1;
                l1_residual = l1_residual
                    .checked_add(residual)
                    .ok_or(CyclicQuotientDefectError::ArithmeticOverflow)?;
                maximum_absolute_residual = maximum_absolute_residual.max(
                    u32::try_from(residual)
                        .map_err(|_| CyclicQuotientDefectError::ArithmeticOverflow)?,
                );
            }
        }
        if mismatches != 0 {
            return Ok(Some(CyclicQuotientObstruction {
                modulus: modulus as u16,
                mismatches,
                l1_residual,
                maximum_absolute_residual,
                candidates_tested,
                origin: FeatureOrigin::Evolved,
                blindness_level,
            }));
        }
    }
    Ok(None)
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::allocation_test::tracked_allocations;

    fn direct_paf<const N: usize>(word: &[u8; N], shift: usize) -> u32 {
        (0..N)
            .map(|position| u32::from(word[position] * word[(position + shift) % N]))
            .sum()
    }

    #[test]
    fn quotient_defects_match_independent_shift_partition() {
        const N: usize = 30;
        const D: usize = 10;
        let word: [u8; N] =
            std::array::from_fn(|position| u8::from(matches!(position % 11, 0 | 1 | 4 | 6 | 9)));
        let quotient = QuotientCoefficients::<D>::compile(&word).unwrap();
        let mut defects = [0_i32; D];
        quotient.defects_into(&mut defects).unwrap();
        let zero: u32 = (0..N)
            .filter(|&position| position % D == 0)
            .map(|shift| direct_paf(&word, shift))
            .sum();
        for residue in 1..D {
            let shifted: u32 = (0..N)
                .filter(|&shift| shift % D == residue)
                .map(|shift| direct_paf(&word, shift))
                .sum();
            assert_eq!(defects[residue], zero as i32 - shifted as i32);
        }
    }

    #[test]
    fn hot_quotient_compile_and_defect_are_allocation_free() {
        let word: [u8; 30] = std::array::from_fn(|position| u8::from(position % 3 == 0));
        let mut output = [0_i32; 10];
        let (result, allocations) = tracked_allocations(|| {
            QuotientCoefficients::<10>::compile(&word)
                .unwrap()
                .defects_into(&mut output)
        });
        result.unwrap();
        assert_eq!(allocations, 0);
    }

    #[test]
    fn malformed_carrier_and_nonbinary_words_fail_closed() {
        assert_eq!(
            QuotientCoefficients::<4>::compile(&[0_u8; 10]).unwrap_err(),
            CyclicQuotientDefectError::SemanticMismatch
        );
        let mut word = [0_u8; 12];
        word[3] = 2;
        assert_eq!(
            QuotientCoefficients::<4>::compile(&word).unwrap_err(),
            CyclicQuotientDefectError::SemanticMismatch
        );
    }

    #[test]
    fn cyclic_difference_set_is_accepted_and_forged_row_is_rejected() {
        let singer = QuotientCoefficients::<7>::compile(&[1, 1, 0, 1, 0, 0, 0]).unwrap();
        assert_eq!(supplementary_quotient_residual(&[singer], 3, 1).unwrap(), 0);
        let forged = QuotientCoefficients::<7>::compile(&[1, 1, 1, 0, 0, 0, 0]).unwrap();
        assert_ne!(supplementary_quotient_residual(&[forged], 3, 1).unwrap(), 0);
    }

    #[test]
    fn blind_divisor_ladder_discovers_an_obstruction_without_seeded_modulus() {
        let words = [[1_u8, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0]];
        let (candidate, allocations) =
            tracked_allocations(|| mine_cyclic_quotient_obstruction(&words, 7, 2, 18, 2));
        let candidate = candidate.unwrap().unwrap();
        assert!(18_usize.is_multiple_of(usize::from(candidate.modulus)));
        assert!(candidate.l1_residual > 0);
        assert_eq!(candidate.origin, FeatureOrigin::Evolved);
        assert_eq!(allocations, 0);
    }
}
