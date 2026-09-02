//! Small dual-inequality synthesis for the private g53 sparse profile sets.
//!
//! For a weight vector `w`, each block profile has a scalar score.  If the
//! target score lies outside the sum of the four independently attained score
//! intervals, that modular root is impossible.  The resulting certificate is
//! a short structural separating inequality, not a transcript of pair probes.

use serde::Serialize;
use thiserror::Error;

use crate::g53_mod7_reduction::{compile_g53_mod7_assignments, G53Mod7Error};
use crate::g53_sparse_defect::{
    compile_g53_sparse_defect_profiles, G53SparseDefectError, G53SparseDefectProfile,
};

const SLOTS: usize = 10;
const ROOTS: usize = 2_496;
const ROOT_WORDS: usize = ROOTS.div_ceil(64);
const MAX_RADIUS: i8 = 5;
const CANDIDATE_BUDGET: usize = 200_000;
const CERTIFICATE_BUDGET: usize = 64;
const TARGET: [i64; 5] = [34, 15_080, 15_080, 15_080, 15_080];
const MODULI: [u8; 18] = [
    2, 3, 4, 5, 7, 8, 9, 11, 13, 16, 17, 19, 23, 29, 31, 37, 49, 64,
];

#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq)]
pub struct G53DualInequality {
    pub coefficients: [i8; 5],
    pub roots_excluded: u16,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G53SparseDualReport {
    pub radius: i8,
    pub candidates: u32,
    pub roots: u16,
    pub roots_covered: u16,
    pub roots_uncovered: u16,
    pub certificate: Box<[G53DualInequality]>,
}

#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq)]
pub struct G53ModularDualInequality {
    pub modulus: u8,
    pub coefficients: [i8; 5],
    pub roots_excluded: u16,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G53SparseModularDualReport {
    pub radius: i8,
    pub candidates_tested: u32,
    pub candidates_with_coverage: u32,
    pub roots: u16,
    pub roots_covered: u16,
    pub roots_uncovered: u16,
    pub certificate: Box<[G53ModularDualInequality]>,
}

#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq)]
pub struct G53CoordinateProjection {
    pub modulus: u8,
    pub coordinate_mask: u8,
    pub roots_excluded: u16,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G53CoordinateProjectionReport {
    pub candidates_tested: u16,
    pub candidates_with_coverage: u16,
    pub roots: u16,
    pub roots_covered: u16,
    pub roots_uncovered: u16,
    pub certificate: Box<[G53CoordinateProjection]>,
}

#[derive(Clone, Debug, Error, PartialEq, Eq)]
pub enum G53SparseDualError {
    #[error("dual search radius or candidate budget is invalid")]
    CandidateBudget,
    #[error("dual arithmetic overflowed")]
    Arithmetic,
    #[error("dual certificate exceeded its explicit bound")]
    CertificateBudget,
    #[error(transparent)]
    Profiles(#[from] G53SparseDefectError),
    #[error(transparent)]
    Mod7(#[from] G53Mod7Error),
}

struct ProfileDomains {
    special: [Option<Box<[G53SparseDefectProfile]>>; 1 << SLOTS],
    zero: [Option<Box<[G53SparseDefectProfile]>>; 1 << SLOTS],
}

impl ProfileDomains {
    fn compile(assignments: &[[u16; 4]]) -> Result<Self, G53SparseDualError> {
        let mut special = std::array::from_fn(|_| None);
        let mut zero = std::array::from_fn(|_| None);
        for assignment in assignments {
            for (block, &mask) in assignment.iter().enumerate() {
                let cache = if block == 0 { &mut special } else { &mut zero };
                if cache[usize::from(mask)].is_none() {
                    cache[usize::from(mask)] = Some(compile_g53_sparse_defect_profiles(
                        mask,
                        if block == 0 { 260 } else { 261 },
                    )?);
                }
            }
        }
        Ok(Self { special, zero })
    }

    fn get(&self, block: usize, mask: u16) -> &[G53SparseDefectProfile] {
        let cache = if block == 0 {
            &self.special
        } else {
            &self.zero
        };
        cache[usize::from(mask)]
            .as_deref()
            .expect("every dual domain was compiled")
    }
}

fn profile_score(
    coefficients: [i8; 5],
    profile: &G53SparseDefectProfile,
) -> Result<i64, G53SparseDualError> {
    let values = [
        i64::from(profile.defect_energy),
        i64::from(profile.paf[0]),
        i64::from(profile.paf[1]),
        i64::from(profile.paf[2]),
        i64::from(profile.paf[3]),
    ];
    coefficients
        .iter()
        .zip(values)
        .try_fold(0_i64, |total, (&coefficient, value)| {
            total
                .checked_add(i64::from(coefficient) * value)
                .ok_or(G53SparseDualError::Arithmetic)
        })
}

fn normalize(mut coefficients: [i8; 5]) -> Option<[i8; 5]> {
    let first = coefficients.iter().copied().find(|&value| value != 0)?;
    if first < 0 {
        for value in &mut coefficients {
            *value = -*value;
        }
    }
    let gcd = coefficients
        .iter()
        .copied()
        .map(i8::unsigned_abs)
        .filter(|&value| value != 0)
        .reduce(gcd_u8)
        .unwrap_or(1);
    for value in &mut coefficients {
        *value /= gcd as i8;
    }
    Some(coefficients)
}

const fn gcd_u8(mut left: u8, mut right: u8) -> u8 {
    while right != 0 {
        let remainder = left % right;
        left = right;
        right = remainder;
    }
    left
}

fn candidate_weights(radius: i8) -> Result<Box<[[i8; 5]]>, G53SparseDualError> {
    if !(1..=MAX_RADIUS).contains(&radius) {
        return Err(G53SparseDualError::CandidateBudget);
    }
    let radix = usize::from((2 * radius + 1) as u8);
    let count = radix.pow(5);
    if count > CANDIDATE_BUDGET {
        return Err(G53SparseDualError::CandidateBudget);
    }
    let mut output = Vec::with_capacity(count / 2);
    for mut code in 0..count {
        let mut coefficients = [0_i8; 5];
        for coefficient in &mut coefficients {
            *coefficient = (code % radix) as i8 - radius;
            code /= radix;
        }
        let Some(coefficients) = normalize(coefficients) else {
            continue;
        };
        output.push(coefficients);
    }
    output.sort_unstable();
    output.dedup();
    Ok(output.into_boxed_slice())
}

pub fn synthesize_g53_sparse_dual(radius: i8) -> Result<G53SparseDualReport, G53SparseDualError> {
    let assignments = compile_g53_mod7_assignments()?;
    if assignments.len() != ROOTS {
        return Err(G53SparseDualError::Arithmetic);
    }
    let domains = ProfileDomains::compile(&assignments)?;
    let weights = candidate_weights(radius)?;
    let coverage_cells = weights
        .len()
        .checked_mul(ROOT_WORDS)
        .ok_or(G53SparseDualError::CandidateBudget)?;
    let mut coverage = vec![0_u64; coverage_cells];
    let mut counts = vec![0_u16; weights.len()];

    for (candidate, &coefficients) in weights.iter().enumerate() {
        let target_score = coefficients
            .iter()
            .zip(TARGET)
            .map(|(&coefficient, value)| i64::from(coefficient) * value)
            .sum::<i64>();
        let mut special_extrema = [None; 1 << SLOTS];
        let mut zero_extrema = [None; 1 << SLOTS];
        for assignment in assignments.iter() {
            for (block, &mask) in assignment.iter().enumerate() {
                let extrema = if block == 0 {
                    &mut special_extrema
                } else {
                    &mut zero_extrema
                };
                if extrema[usize::from(mask)].is_none() {
                    let mut minimum = i64::MAX;
                    let mut maximum = i64::MIN;
                    for profile in domains.get(block, mask) {
                        let score = profile_score(coefficients, profile)?;
                        minimum = minimum.min(score);
                        maximum = maximum.max(score);
                    }
                    extrema[usize::from(mask)] = Some((minimum, maximum));
                }
            }
        }
        for (root, assignment) in assignments.iter().enumerate() {
            let mut minimum = 0_i64;
            let mut maximum = 0_i64;
            for (block, &mask) in assignment.iter().enumerate() {
                let extrema = if block == 0 {
                    special_extrema[usize::from(mask)]
                } else {
                    zero_extrema[usize::from(mask)]
                }
                .ok_or(G53SparseDualError::Arithmetic)?;
                minimum += extrema.0;
                maximum += extrema.1;
            }
            if target_score < minimum || target_score > maximum {
                coverage[candidate * ROOT_WORDS + root / 64] |= 1_u64 << (root % 64);
                counts[candidate] += 1;
            }
        }
    }

    let mut uncovered = [u64::MAX; ROOT_WORDS];
    if ROOTS % 64 != 0 {
        uncovered[ROOT_WORDS - 1] &= (1_u64 << (ROOTS % 64)) - 1;
    }
    let mut certificate = Vec::with_capacity(CERTIFICATE_BUDGET);
    while uncovered.iter().any(|&word| word != 0) {
        let mut best = None;
        let mut best_gain = 0_u32;
        for candidate in 0..weights.len() {
            let gain = (0..ROOT_WORDS)
                .map(|word| {
                    (coverage[candidate * ROOT_WORDS + word] & uncovered[word]).count_ones()
                })
                .sum::<u32>();
            if gain > best_gain {
                best = Some(candidate);
                best_gain = gain;
            }
        }
        let Some(best) = best else {
            break;
        };
        if certificate.len() == CERTIFICATE_BUDGET {
            return Err(G53SparseDualError::CertificateBudget);
        }
        for word in 0..ROOT_WORDS {
            uncovered[word] &= !coverage[best * ROOT_WORDS + word];
        }
        certificate.push(G53DualInequality {
            coefficients: weights[best],
            roots_excluded: counts[best],
        });
    }
    let roots_uncovered = uncovered.iter().map(|word| word.count_ones()).sum::<u32>() as u16;
    Ok(G53SparseDualReport {
        radius,
        candidates: weights.len() as u32,
        roots: ROOTS as u16,
        roots_covered: ROOTS as u16 - roots_uncovered,
        roots_uncovered,
        certificate: certificate.into_boxed_slice(),
    })
}

fn cyclic_sumset(mut left: u64, right: u64, modulus: u8) -> u64 {
    let full = if modulus == 64 {
        u64::MAX
    } else {
        (1_u64 << modulus) - 1
    };
    let mut output = 0_u64;
    while left != 0 {
        let first = left.trailing_zeros() as u8;
        left &= left - 1;
        let rotated = if first == 0 {
            right
        } else if modulus == 64 {
            right.rotate_left(u32::from(first))
        } else {
            ((right << first) | (right >> (modulus - first))) & full
        };
        output |= rotated;
        if output == full {
            break;
        }
    }
    output
}

fn encode_projection(values: [i64; 5], coordinate_mask: u8, modulus: u8) -> u8 {
    let mut code = 0_u8;
    let mut place = 1_u8;
    for (coordinate, value) in values.into_iter().enumerate() {
        if coordinate_mask & (1 << coordinate) != 0 {
            code += value.rem_euclid(i64::from(modulus)) as u8 * place;
            place *= modulus;
        }
    }
    code
}

fn projected_sumset(mut left: u64, right: u64, coordinate_count: u8, modulus: u8) -> u64 {
    let states = u32::from(modulus).pow(u32::from(coordinate_count)) as u8;
    let full = if states == 64 {
        u64::MAX
    } else {
        (1_u64 << states) - 1
    };
    let mut output = 0_u64;
    while left != 0 {
        let first_encoded = left.trailing_zeros() as u8;
        left &= left - 1;
        let mut remaining = right;
        while remaining != 0 {
            let mut first = first_encoded;
            let mut second = remaining.trailing_zeros() as u8;
            remaining &= remaining - 1;
            let mut sum = 0_u8;
            let mut place = 1_u8;
            for _ in 0..coordinate_count {
                sum += ((first % modulus + second % modulus) % modulus) * place;
                first /= modulus;
                second /= modulus;
                place *= modulus;
            }
            output |= 1_u64 << sum;
        }
        if output == full {
            break;
        }
    }
    output
}

pub fn synthesize_g53_coordinate_projections(
) -> Result<G53CoordinateProjectionReport, G53SparseDualError> {
    let assignments = compile_g53_mod7_assignments()?;
    if assignments.len() != ROOTS {
        return Err(G53SparseDualError::Arithmetic);
    }
    let domains = ProfileDomains::compile(&assignments)?;
    let mut retained = Vec::<G53CoordinateProjection>::new();
    let mut coverage = Vec::<u64>::new();
    let mut candidates_tested = 0_u16;
    for coordinate_mask in 1_u8..1 << 5 {
        let coordinate_count = coordinate_mask.count_ones() as u8;
        if !(2..=3).contains(&coordinate_count) {
            continue;
        }
        for modulus in 2_u8..=8 {
            if u32::from(modulus).pow(u32::from(coordinate_count)) > 64 {
                continue;
            }
            candidates_tested += 1;
            let mut special_sets = [0_u64; 1 << SLOTS];
            let mut zero_sets = [0_u64; 1 << SLOTS];
            for assignment in assignments.iter() {
                for (block, &mask) in assignment.iter().enumerate() {
                    let sets = if block == 0 {
                        &mut special_sets
                    } else {
                        &mut zero_sets
                    };
                    if sets[usize::from(mask)] != 0 {
                        continue;
                    }
                    for profile in domains.get(block, mask) {
                        let values = [
                            i64::from(profile.defect_energy),
                            i64::from(profile.paf[0]),
                            i64::from(profile.paf[1]),
                            i64::from(profile.paf[2]),
                            i64::from(profile.paf[3]),
                        ];
                        let code = encode_projection(values, coordinate_mask, modulus);
                        sets[usize::from(mask)] |= 1_u64 << code;
                    }
                }
            }
            let target = encode_projection(TARGET, coordinate_mask, modulus);
            let begin = coverage.len();
            coverage.resize(begin + ROOT_WORDS, 0);
            let mut count = 0_u16;
            for (root, assignment) in assignments.iter().enumerate() {
                let first = projected_sumset(
                    special_sets[usize::from(assignment[0])],
                    zero_sets[usize::from(assignment[1])],
                    coordinate_count,
                    modulus,
                );
                let second = projected_sumset(
                    zero_sets[usize::from(assignment[2])],
                    zero_sets[usize::from(assignment[3])],
                    coordinate_count,
                    modulus,
                );
                let attainable = projected_sumset(first, second, coordinate_count, modulus);
                if attainable & (1_u64 << target) == 0 {
                    coverage[begin + root / 64] |= 1_u64 << (root % 64);
                    count += 1;
                }
            }
            if count == 0 {
                coverage.truncate(begin);
            } else {
                retained.push(G53CoordinateProjection {
                    modulus,
                    coordinate_mask,
                    roots_excluded: count,
                });
            }
        }
    }
    let mut uncovered = [u64::MAX; ROOT_WORDS];
    if ROOTS % 64 != 0 {
        uncovered[ROOT_WORDS - 1] &= (1_u64 << (ROOTS % 64)) - 1;
    }
    let mut certificate = Vec::with_capacity(CERTIFICATE_BUDGET);
    while uncovered.iter().any(|&word| word != 0) {
        let mut best = None;
        let mut best_gain = 0_u32;
        for candidate in 0..retained.len() {
            let gain = (0..ROOT_WORDS)
                .map(|word| {
                    (coverage[candidate * ROOT_WORDS + word] & uncovered[word]).count_ones()
                })
                .sum::<u32>();
            if gain > best_gain {
                best = Some(candidate);
                best_gain = gain;
            }
        }
        let Some(best) = best else {
            break;
        };
        if certificate.len() == CERTIFICATE_BUDGET {
            return Err(G53SparseDualError::CertificateBudget);
        }
        for word in 0..ROOT_WORDS {
            uncovered[word] &= !coverage[best * ROOT_WORDS + word];
        }
        certificate.push(retained[best]);
    }
    let roots_uncovered = uncovered.iter().map(|word| word.count_ones()).sum::<u32>() as u16;
    Ok(G53CoordinateProjectionReport {
        candidates_tested,
        candidates_with_coverage: retained.len() as u16,
        roots: ROOTS as u16,
        roots_covered: ROOTS as u16 - roots_uncovered,
        roots_uncovered,
        certificate: certificate.into_boxed_slice(),
    })
}

pub fn synthesize_g53_sparse_modular_dual(
    radius: i8,
) -> Result<G53SparseModularDualReport, G53SparseDualError> {
    let assignments = compile_g53_mod7_assignments()?;
    if assignments.len() != ROOTS {
        return Err(G53SparseDualError::Arithmetic);
    }
    let domains = ProfileDomains::compile(&assignments)?;
    let weights = candidate_weights(radius)?;
    let mut retained = Vec::<G53ModularDualInequality>::new();
    let mut coverage = Vec::<u64>::new();
    let mut candidates_tested = 0_u32;
    for &coefficients in weights.iter() {
        let target_score = coefficients
            .iter()
            .zip(TARGET)
            .map(|(&coefficient, value)| i64::from(coefficient) * value)
            .sum::<i64>();
        for &modulus in &MODULI {
            candidates_tested += 1;
            let mut special_sets = [0_u64; 1 << SLOTS];
            let mut zero_sets = [0_u64; 1 << SLOTS];
            for assignment in assignments.iter() {
                for (block, &mask) in assignment.iter().enumerate() {
                    let sets = if block == 0 {
                        &mut special_sets
                    } else {
                        &mut zero_sets
                    };
                    if sets[usize::from(mask)] != 0 {
                        continue;
                    }
                    let mut residues = 0_u64;
                    for profile in domains.get(block, mask) {
                        let score = profile_score(coefficients, profile)?;
                        let residue = score.rem_euclid(i64::from(modulus)) as u8;
                        residues |= 1_u64 << residue;
                    }
                    sets[usize::from(mask)] = residues;
                }
            }
            let target_residue = target_score.rem_euclid(i64::from(modulus)) as u8;
            let begin = coverage.len();
            coverage.resize(begin + ROOT_WORDS, 0);
            let mut count = 0_u16;
            for (root, assignment) in assignments.iter().enumerate() {
                let first = cyclic_sumset(
                    special_sets[usize::from(assignment[0])],
                    zero_sets[usize::from(assignment[1])],
                    modulus,
                );
                let second = cyclic_sumset(
                    zero_sets[usize::from(assignment[2])],
                    zero_sets[usize::from(assignment[3])],
                    modulus,
                );
                let attainable = cyclic_sumset(first, second, modulus);
                if attainable & (1_u64 << target_residue) == 0 {
                    coverage[begin + root / 64] |= 1_u64 << (root % 64);
                    count += 1;
                }
            }
            if count == 0 {
                coverage.truncate(begin);
            } else {
                retained.push(G53ModularDualInequality {
                    modulus,
                    coefficients,
                    roots_excluded: count,
                });
            }
        }
    }
    let mut uncovered = [u64::MAX; ROOT_WORDS];
    if ROOTS % 64 != 0 {
        uncovered[ROOT_WORDS - 1] &= (1_u64 << (ROOTS % 64)) - 1;
    }
    let mut certificate = Vec::with_capacity(CERTIFICATE_BUDGET);
    while uncovered.iter().any(|&word| word != 0) {
        let mut best = None;
        let mut best_gain = 0_u32;
        for candidate in 0..retained.len() {
            let gain = (0..ROOT_WORDS)
                .map(|word| {
                    (coverage[candidate * ROOT_WORDS + word] & uncovered[word]).count_ones()
                })
                .sum::<u32>();
            if gain > best_gain {
                best = Some(candidate);
                best_gain = gain;
            }
        }
        let Some(best) = best else {
            break;
        };
        if certificate.len() == CERTIFICATE_BUDGET {
            return Err(G53SparseDualError::CertificateBudget);
        }
        for word in 0..ROOT_WORDS {
            uncovered[word] &= !coverage[best * ROOT_WORDS + word];
        }
        certificate.push(retained[best]);
    }
    let roots_uncovered = uncovered.iter().map(|word| word.count_ones()).sum::<u32>() as u16;
    Ok(G53SparseModularDualReport {
        radius,
        candidates_tested,
        candidates_with_coverage: retained.len() as u32,
        roots: ROOTS as u16,
        roots_covered: ROOTS as u16 - roots_uncovered,
        roots_uncovered,
        certificate: certificate.into_boxed_slice(),
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn weights_are_primitive_and_sign_canonical() {
        let weights = candidate_weights(2).unwrap();
        assert!(!weights.is_empty());
        assert!(weights.windows(2).all(|pair| pair[0] < pair[1]));
        for weight in weights.iter() {
            assert!(weight.iter().copied().find(|&value| value != 0).unwrap() > 0);
            assert_eq!(
                weight
                    .iter()
                    .copied()
                    .map(i8::unsigned_abs)
                    .filter(|&value| value != 0)
                    .reduce(gcd_u8),
                Some(1)
            );
        }
    }

    #[test]
    fn cyclic_sumset_matches_direct_residue_addition() {
        let left = (1 << 1) | (1 << 4);
        let right = (1 << 2) | (1 << 6);
        assert_eq!(
            cyclic_sumset(left, right, 7),
            (1 << 0) | (1 << 3) | (1 << 6)
        );
    }

    #[test]
    fn projected_sumset_matches_two_coordinate_addition() {
        let left = (1 << 1) | (1 << 5);
        let right = 1 << 7;
        assert_eq!(projected_sumset(left, right, 2, 3), (1 << 0) | (1 << 8));
    }
}
