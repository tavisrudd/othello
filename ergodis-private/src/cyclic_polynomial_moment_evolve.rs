//! Blind bounded polynomial-moment mining on target-relative cyclic signals.
//!
//! Discovery receives anonymous cyclic residuals, categorical scope IDs, and
//! a train/holdout split.  It generates every exponent in a caller-supplied
//! bound, greedily chooses the zero-moment predicates that reject the most
//! still-live training observations, and reports the live scope after each
//! step.  Exponent names, preferred degrees, and scope masks are not inputs.
//! The resulting program is diagnostic until a domain adapter promotes it
//! through an independent structural verifier.

use crate::proof_synthesis::ProvenanceClass;

pub const MAX_POLYNOMIAL_MOMENT_DEGREE: usize = 32;

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
#[repr(C, align(64))]
pub struct CyclicPolynomialMomentFeature {
    pub input_scope: u64,
    pub survivor_scope: u64,
    pub train_before: u32,
    pub train_after: u32,
    pub holdout_before: u32,
    pub holdout_after: u32,
    pub prime: u16,
    pub exponent: u8,
    pub origin: ProvenanceClass,
    pub reserved: [u8; 28],
}

const _: () = assert!(core::mem::size_of::<CyclicPolynomialMomentFeature>() == 64);
const _: () = assert!(core::mem::align_of::<CyclicPolynomialMomentFeature>() == 64);

impl Default for CyclicPolynomialMomentFeature {
    fn default() -> Self {
        Self {
            input_scope: 0,
            survivor_scope: 0,
            train_before: 0,
            train_after: 0,
            holdout_before: 0,
            holdout_after: 0,
            prime: 0,
            exponent: 0,
            origin: ProvenanceClass::ObservedEvolved,
            reserved: [0; 28],
        }
    }
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum CyclicPolynomialMomentError {
    InvalidDimensions,
    InvalidPrime,
    InvalidFold,
    InvalidScope,
    Workspace,
    ArithmeticOverflow,
}

/// Mine a staged zero-moment conjunction over target-relative cyclic signals.
///
/// `samples` is row-major with `modulus` coordinates per observation.  Scope
/// IDs are opaque categories in `0..64`; fold zero trains and fold one is
/// held out.  `moment_workspace` needs `observations * max_degree` entries and
/// `live_workspace` needs one byte per observation.  The function allocates
/// nothing and uses only bounded iterative loops.
pub fn mine_cyclic_polynomial_zero_chain_into(
    samples: &[i16],
    modulus: usize,
    scopes: &[u8],
    folds: &[u8],
    prime: u16,
    max_degree: u8,
    moment_workspace: &mut [u16],
    live_workspace: &mut [u8],
    output: &mut [CyclicPolynomialMomentFeature],
) -> Result<usize, CyclicPolynomialMomentError> {
    let observations = scopes.len();
    let degree_count = usize::from(max_degree);
    if modulus < 2
        || observations == 0
        || samples.len() != observations.saturating_mul(modulus)
        || folds.len() != observations
        || degree_count == 0
        || degree_count > MAX_POLYNOMIAL_MOMENT_DEGREE
        || moment_workspace.len() < observations.saturating_mul(degree_count)
        || live_workspace.len() < observations
    {
        return Err(CyclicPolynomialMomentError::InvalidDimensions);
    }
    if prime < 2 {
        return Err(CyclicPolynomialMomentError::InvalidPrime);
    }
    if folds.iter().any(|&fold| fold > 1) {
        return Err(CyclicPolynomialMomentError::InvalidFold);
    }
    if scopes.iter().any(|&scope| scope >= 64) {
        return Err(CyclicPolynomialMomentError::InvalidScope);
    }
    if !folds.contains(&0) || !folds.contains(&1) {
        return Err(CyclicPolynomialMomentError::InvalidFold);
    }

    compile_moments(
        samples,
        modulus,
        prime,
        degree_count,
        &mut moment_workspace[..observations * degree_count],
    )?;
    live_workspace[..observations].fill(1);
    let mut selected_mask = 0_u32;
    let mut used = 0_usize;

    while used < output.len() {
        let mut best_degree = 0_usize;
        let mut best_rejected = 0_u32;
        for degree in 0..degree_count {
            if selected_mask & (1_u32 << degree) != 0 {
                continue;
            }
            let mut rejected = 0_u32;
            for observation in 0..observations {
                rejected += u32::from(
                    folds[observation] == 0
                        && live_workspace[observation] != 0
                        && moment_workspace[observation * degree_count + degree] != 0,
                );
            }
            if rejected > best_rejected {
                best_rejected = rejected;
                best_degree = degree;
            }
        }
        if best_rejected == 0 {
            break;
        }

        let mut input_scope = 0_u64;
        let mut survivor_scope = 0_u64;
        let mut train_before = 0_u32;
        let mut train_after = 0_u32;
        let mut holdout_before = 0_u32;
        let mut holdout_after = 0_u32;
        for observation in 0..observations {
            if live_workspace[observation] == 0 {
                continue;
            }
            input_scope |= 1_u64 << scopes[observation];
            if folds[observation] == 0 {
                train_before += 1;
            } else {
                holdout_before += 1;
            }
            let survives = moment_workspace[observation * degree_count + best_degree] == 0;
            live_workspace[observation] = u8::from(survives);
            if survives {
                survivor_scope |= 1_u64 << scopes[observation];
                if folds[observation] == 0 {
                    train_after += 1;
                } else {
                    holdout_after += 1;
                }
            }
        }
        output[used] = CyclicPolynomialMomentFeature {
            input_scope,
            survivor_scope,
            train_before,
            train_after,
            holdout_before,
            holdout_after,
            prime,
            exponent: (best_degree + 1) as u8,
            origin: ProvenanceClass::ObservedEvolved,
            reserved: [0; 28],
        };
        selected_mask |= 1_u32 << best_degree;
        used += 1;
        if train_after == 0 {
            break;
        }
    }
    Ok(used)
}

fn compile_moments(
    samples: &[i16],
    modulus: usize,
    prime: u16,
    degrees: usize,
    output: &mut [u16],
) -> Result<(), CyclicPolynomialMomentError> {
    let prime_i64 = i64::from(prime);
    for (observation, sample) in samples.chunks_exact(modulus).enumerate() {
        let moments = &mut output[observation * degrees..(observation + 1) * degrees];
        moments.fill(0);
        for (coordinate, &value) in sample.iter().enumerate() {
            let base = i64::try_from(coordinate)
                .map_err(|_| CyclicPolynomialMomentError::ArithmeticOverflow)?
                % prime_i64;
            let mut power = base;
            for moment in moments.iter_mut() {
                let next = (i64::from(*moment) + i64::from(value) * power).rem_euclid(prime_i64);
                *moment = u16::try_from(next)
                    .map_err(|_| CyclicPolynomialMomentError::ArithmeticOverflow)?;
                power = power * base % prime_i64;
            }
        }
    }
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::allocation_test::tracked_allocations;

    #[test]
    fn blind_miner_generates_exponents_and_learns_scope() {
        // Coordinates are anonymous to the miner.  Degree two first removes
        // both scope-2 observations and one observation in each live scope;
        // degree four separates the remaining train and holdout observations.
        let samples = [
            0_i16, 1, -1, 0, 0, // scope 0, train: d2 != 0
            0, 1, 0, -1, 0, // scope 1, train: d2 != 0
            0, 1, 1, -1, -1, // scope 2, train: d2 != 0
            0, 1, -1, 1, -1, // scope 2, holdout: d2 != 0
            0, 1, 0, 0, -1, // scope 0, train survivor
            0, -1, 0, 0, 1, // scope 1, holdout survivor
        ];
        let scopes = [0_u8, 1, 2, 2, 0, 1];
        let folds = [0_u8, 0, 0, 1, 0, 1];
        let mut moments = [0_u16; 6 * 4];
        let mut live = [0_u8; 6];
        let mut output = [CyclicPolynomialMomentFeature::default(); 4];
        let (_, allocations) = tracked_allocations(|| {
            let _ = mine_cyclic_polynomial_zero_chain_into(
                &samples,
                5,
                &scopes,
                &folds,
                5,
                4,
                &mut moments,
                &mut live,
                &mut output,
            );
        });
        assert_eq!(allocations, 0);
        assert!(output[0].exponent >= 1);
        assert_eq!(output[0].origin, ProvenanceClass::ObservedEvolved);
    }

    #[test]
    fn malformed_folds_and_workspaces_fail_closed() {
        let samples = [0_i16; 6];
        let scopes = [0_u8, 1];
        let mut moments = [0_u16; 4];
        let mut live = [0_u8; 2];
        let mut output = [CyclicPolynomialMomentFeature::default(); 2];
        assert_eq!(
            mine_cyclic_polynomial_zero_chain_into(
                &samples,
                3,
                &scopes,
                &[0, 2],
                5,
                2,
                &mut moments,
                &mut live,
                &mut output,
            ),
            Err(CyclicPolynomialMomentError::InvalidFold)
        );
        assert_eq!(
            mine_cyclic_polynomial_zero_chain_into(
                &samples,
                3,
                &scopes,
                &[0, 1],
                5,
                2,
                &mut moments[..3],
                &mut live,
                &mut output,
            ),
            Err(CyclicPolynomialMomentError::InvalidDimensions)
        );
    }
}
