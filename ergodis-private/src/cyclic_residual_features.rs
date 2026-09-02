//! Generic discovery of cyclic residual quotients and scoped sparse motifs.
//!
//! The miner receives anonymous residual vectors.  It searches unit actions
//! preserving every sample, chooses the strongest nontrivial orbit quotient,
//! and compresses each sample to a signed support mask.  Domain adapters need
//! only expose raw vectors; they do not name cosets or construct masks.

use serde::{Deserialize, Serialize};
use thiserror::Error;

pub const MAX_CYCLIC_MODULUS: usize = 64;

#[derive(Clone, Copy, Debug, Default, Deserialize, Serialize, PartialEq, Eq)]
#[repr(C)]
pub struct CyclicInvariantAction {
    pub multiplier: u16,
    pub orbit_count: u8,
    pub maximum_orbit: u8,
    pub fixed_points: u8,
    pub reserved: [u8; 3],
}

const _: () = assert!(std::mem::size_of::<CyclicInvariantAction>() == 8);

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
#[repr(C)]
pub struct CyclicResidualMotif {
    pub support_mask: u64,
    pub positive_mask: u64,
    pub negative_mask: u64,
    pub l1: u32,
    pub l2: u32,
    pub signed_sum: i32,
    pub orbit_count: u8,
    pub reserved: [u8; 3],
    pub values: [i32; MAX_CYCLIC_MODULUS],
}

const _: () = assert!(std::mem::size_of::<CyclicResidualMotif>() == 296);

#[derive(Clone, Copy, Debug, Default, Deserialize, Serialize, PartialEq, Eq)]
#[repr(C)]
pub struct CyclicDirichletPredicate {
    pub target: u64,
    pub shift: u8,
    pub reserved: [u8; 7],
}

const _: () = assert!(std::mem::size_of::<CyclicDirichletPredicate>() == 16);

#[derive(Clone, Debug, Error, PartialEq, Eq)]
pub enum CyclicResidualError {
    #[error("cyclic residual dimensions are invalid")]
    InvalidDimensions,
    #[error("caller workspace is too small")]
    Workspace,
    #[error("no nontrivial invariant unit action was found")]
    NoInvariantAction,
    #[error("residual vector is not invariant under the selected action")]
    NotInvariant,
    #[error("residual feature arithmetic overflowed")]
    ArithmeticOverflow,
}

/// Emit the cyclic Dirichlet energies
/// `E_s = 1/2 sum_r (x_r - x_{r+s})^2` for every shift.  These are exactly
/// `A_0-A_s` for the cyclic autocorrelation of `x`, but the squared-difference
/// form exposes nonnegativity and complement/translation invariance directly.
/// The kernel is iterative and allocation-free over caller storage.
pub fn cyclic_dirichlet_energies_into(
    sample: &[i32],
    output: &mut [u64],
) -> Result<(), CyclicResidualError> {
    let modulus = sample.len();
    if modulus < 3 || modulus > MAX_CYCLIC_MODULUS || output.len() != modulus {
        return Err(CyclicResidualError::InvalidDimensions);
    }
    for shift in 0..modulus {
        let mut doubled = 0_u64;
        for coordinate in 0..modulus {
            let difference =
                i64::from(sample[coordinate]) - i64::from(sample[(coordinate + shift) % modulus]);
            let square = difference
                .checked_mul(difference)
                .ok_or(CyclicResidualError::ArithmeticOverflow)?;
            doubled = doubled
                .checked_add(
                    u64::try_from(square).map_err(|_| CyclicResidualError::ArithmeticOverflow)?,
                )
                .ok_or(CyclicResidualError::ArithmeticOverflow)?;
        }
        if doubled & 1 != 0 {
            return Err(CyclicResidualError::ArithmeticOverflow);
        }
        output[shift] = doubled / 2;
    }
    Ok(())
}

/// Blindly mine exact `E_shift == target` predicates from labelled anonymous
/// cyclic vectors.  Neither a shift nor a target is supplied: candidates are
/// seeded from the first positive sample and checked against every row.
pub fn mine_cyclic_dirichlet_equalities_into(
    samples: &[i32],
    modulus: usize,
    labels: &[u8],
    feature_workspace: &mut [u64],
    output: &mut [CyclicDirichletPredicate],
) -> Result<usize, CyclicResidualError> {
    if modulus < 3
        || modulus > MAX_CYCLIC_MODULUS
        || labels.is_empty()
        || samples.len() != labels.len() * modulus
        || feature_workspace.len() < modulus
        || labels.iter().any(|&label| label > 1)
    {
        return Err(CyclicResidualError::InvalidDimensions);
    }
    let positive = labels
        .iter()
        .position(|&label| label == 1)
        .ok_or(CyclicResidualError::InvalidDimensions)?;
    if labels.iter().all(|&label| label == 1) {
        return Err(CyclicResidualError::InvalidDimensions);
    }
    cyclic_dirichlet_energies_into(
        &samples[positive * modulus..(positive + 1) * modulus],
        &mut feature_workspace[..modulus],
    )?;
    let positive_features: [u64; MAX_CYCLIC_MODULUS] = std::array::from_fn(|index| {
        if index < modulus {
            feature_workspace[index]
        } else {
            0
        }
    });
    let mut used = 0_usize;
    for shift in 1..modulus {
        let target = positive_features[shift];
        let mut exact = true;
        for (sample, &label) in samples.chunks_exact(modulus).zip(labels) {
            cyclic_dirichlet_energies_into(sample, &mut feature_workspace[..modulus])?;
            if u8::from(feature_workspace[shift] == target) != label {
                exact = false;
                break;
            }
        }
        if exact {
            let slot = output.get_mut(used).ok_or(CyclicResidualError::Workspace)?;
            *slot = CyclicDirichletPredicate {
                target,
                shift: shift as u8,
                reserved: [0; 7],
            };
            used += 1;
        }
    }
    Ok(used)
}

#[inline(always)]
const fn gcd(mut left: usize, mut right: usize) -> usize {
    while right != 0 {
        let remainder = left % right;
        left = right;
        right = remainder;
    }
    left
}

fn action_shape(modulus: usize, multiplier: usize) -> (u8, u8, u8) {
    let mut unseen = if modulus == 64 {
        u64::MAX
    } else {
        (1_u64 << modulus) - 1
    };
    let mut orbits = 0_u8;
    let mut maximum = 0_u8;
    let mut fixed = 0_u8;
    while unseen != 0 {
        let start = unseen.trailing_zeros() as usize;
        let mut point = start;
        let mut length = 0_u8;
        loop {
            unseen &= !(1_u64 << point);
            length += 1;
            point = point * multiplier % modulus;
            if point == start {
                break;
            }
        }
        orbits += 1;
        maximum = maximum.max(length);
        fixed += u8::from(length == 1);
    }
    (orbits, maximum, fixed)
}

/// Search every unit multiplier and retain the actions preserving every raw
/// sample.  The kernel is iterative and allocation-free over caller storage.
pub fn mine_cyclic_invariant_actions_into(
    samples: &[i32],
    modulus: usize,
    output: &mut [CyclicInvariantAction],
) -> Result<usize, CyclicResidualError> {
    if modulus < 3
        || modulus > MAX_CYCLIC_MODULUS
        || samples.is_empty()
        || !samples.len().is_multiple_of(modulus)
    {
        return Err(CyclicResidualError::InvalidDimensions);
    }
    let mut used = 0_usize;
    for multiplier in 2..modulus {
        if gcd(multiplier, modulus) != 1 {
            continue;
        }
        let invariant = samples.chunks_exact(modulus).all(|sample| {
            (0..modulus)
                .all(|coordinate| sample[coordinate] == sample[coordinate * multiplier % modulus])
        });
        if !invariant {
            continue;
        }
        let slot = output.get_mut(used).ok_or(CyclicResidualError::Workspace)?;
        let (orbit_count, maximum_orbit, fixed_points) = action_shape(modulus, multiplier);
        *slot = CyclicInvariantAction {
            multiplier: multiplier as u16,
            orbit_count,
            maximum_orbit,
            fixed_points,
            reserved: [0; 3],
        };
        used += 1;
    }
    output[..used].sort_unstable_by_key(|action| {
        (
            action.orbit_count,
            std::cmp::Reverse(action.maximum_orbit),
            action.multiplier,
        )
    });
    if used == 0 {
        return Err(CyclicResidualError::NoInvariantAction);
    }
    Ok(used)
}

/// Compress one residual vector by the learned cyclic action and infer the
/// exact signed support scope.  Orbit ordering is canonical by least member.
pub fn extract_cyclic_residual_motif(
    residual: &[i32],
    modulus: usize,
    action: CyclicInvariantAction,
) -> Result<CyclicResidualMotif, CyclicResidualError> {
    if modulus < 3 || modulus > MAX_CYCLIC_MODULUS || residual.len() != modulus {
        return Err(CyclicResidualError::InvalidDimensions);
    }
    let multiplier = usize::from(action.multiplier);
    if multiplier >= modulus || gcd(multiplier, modulus) != 1 {
        return Err(CyclicResidualError::NotInvariant);
    }
    let mut motif = CyclicResidualMotif {
        support_mask: 0,
        positive_mask: 0,
        negative_mask: 0,
        l1: 0,
        l2: 0,
        signed_sum: 0,
        orbit_count: 0,
        reserved: [0; 3],
        values: [0; MAX_CYCLIC_MODULUS],
    };
    let mut unseen = if modulus == 64 {
        u64::MAX
    } else {
        (1_u64 << modulus) - 1
    };
    while unseen != 0 {
        let start = unseen.trailing_zeros() as usize;
        let value = residual[start];
        let mut point = start;
        loop {
            if residual[point] != value {
                return Err(CyclicResidualError::NotInvariant);
            }
            unseen &= !(1_u64 << point);
            point = point * multiplier % modulus;
            if point == start {
                break;
            }
        }
        let orbit = usize::from(motif.orbit_count);
        motif.values[orbit] = value;
        if value != 0 {
            motif.support_mask |= 1_u64 << orbit;
            if value > 0 {
                motif.positive_mask |= 1_u64 << orbit;
            } else {
                motif.negative_mask |= 1_u64 << orbit;
            }
        }
        motif.l1 = motif
            .l1
            .checked_add(value.unsigned_abs())
            .ok_or(CyclicResidualError::ArithmeticOverflow)?;
        let square = i64::from(value) * i64::from(value);
        motif.l2 = motif
            .l2
            .checked_add(
                u32::try_from(square).map_err(|_| CyclicResidualError::ArithmeticOverflow)?,
            )
            .ok_or(CyclicResidualError::ArithmeticOverflow)?;
        motif.signed_sum = motif
            .signed_sum
            .checked_add(value)
            .ok_or(CyclicResidualError::ArithmeticOverflow)?;
        motif.orbit_count += 1;
    }
    if motif.orbit_count != action.orbit_count {
        return Err(CyclicResidualError::NotInvariant);
    }
    Ok(motif)
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::allocation_test::tracked_allocations;

    #[test]
    fn hidden_action_and_sparse_scope_are_recovered_without_labels() {
        const MODULUS: usize = 29;
        const HIDDEN_MULTIPLIER: usize = 12;
        let mut sample = [0_i32; MODULUS];
        for (seed, value) in [(1_usize, -1_i32), (6, 1)] {
            let mut point = seed;
            loop {
                sample[point] = value;
                point = point * HIDDEN_MULTIPLIER % MODULUS;
                if point == seed {
                    break;
                }
            }
        }
        let mut actions = [CyclicInvariantAction::default(); MAX_CYCLIC_MODULUS];
        let (_, allocations) = tracked_allocations(|| {
            let used = mine_cyclic_invariant_actions_into(&sample, MODULUS, &mut actions).unwrap();
            let action = actions[..used]
                .iter()
                .copied()
                .find(|action| usize::from(action.multiplier) == HIDDEN_MULTIPLIER)
                .unwrap();
            let motif = extract_cyclic_residual_motif(&sample, MODULUS, action).unwrap();
            assert_eq!(motif.orbit_count, 8);
            assert_eq!(motif.support_mask.count_ones(), 2);
            assert_eq!(motif.positive_mask.count_ones(), 1);
            assert_eq!(motif.negative_mask.count_ones(), 1);
            assert_eq!(motif.l1, 2);
            assert_eq!(motif.l2, 2);
            assert_eq!(motif.signed_sum, 0);
        });
        assert_eq!(allocations, 0);
    }

    #[test]
    fn learned_action_rejects_a_forged_orbit_value() {
        let mut residual = [0_i32; 29];
        residual[1] = 1;
        let action = CyclicInvariantAction {
            multiplier: 12,
            orbit_count: 8,
            maximum_orbit: 4,
            fixed_points: 1,
            reserved: [0; 3],
        };
        assert_eq!(
            extract_cyclic_residual_motif(&residual, 29, action),
            Err(CyclicResidualError::NotInvariant)
        );
    }

    #[test]
    fn dirichlet_features_recover_autocorrelation_defects_and_complement_scope() {
        let mut sample = [0_i32; 29];
        // The digit groups spell the task and sector this fixture seed belongs to.
        #[allow(clippy::unusual_byte_groupings)]
        let mut state = 0xc1016_29_41_defec7_u64;
        for value in &mut sample {
            state = state
                .wrapping_mul(6_364_136_223_846_793_005)
                .wrapping_add(1);
            *value = (state % 19) as i32;
        }
        let complement = sample.map(|value| 18 - value);
        let mut energies = [0_u64; 29];
        let mut complement_energies = [0_u64; 29];
        let (_, allocations) = tracked_allocations(|| {
            cyclic_dirichlet_energies_into(&sample, &mut energies).unwrap();
            cyclic_dirichlet_energies_into(&complement, &mut complement_energies).unwrap();
        });
        assert_eq!(allocations, 0);
        assert_eq!(energies, complement_energies);
        let zero = sample
            .iter()
            .map(|&value| i64::from(value) * i64::from(value))
            .sum::<i64>();
        for shift in 0..29 {
            let correlation = (0..29)
                .map(|coordinate| {
                    i64::from(sample[coordinate]) * i64::from(sample[(coordinate + shift) % 29])
                })
                .sum::<i64>();
            assert_eq!(energies[shift], (zero - correlation) as u64);
        }
    }

    #[test]
    fn blind_dirichlet_miner_recovers_hidden_shift_on_holdout() {
        const MODULUS: usize = 7;
        const HIDDEN_SHIFT: usize = 2;
        let base = [0_i32, 1, 0, 2, 1, 0, 1];
        let mut samples = [0_i32; 8 * MODULUS];
        let labels = [1_u8, 1, 1, 1, 0, 0, 0, 0];
        for row in 0..4 {
            for coordinate in 0..MODULUS {
                samples[row * MODULUS + coordinate] = base[(coordinate + row) % MODULUS];
            }
        }
        for row in 4..8 {
            for coordinate in 0..MODULUS {
                samples[row * MODULUS + coordinate] = base[(coordinate + row) % MODULUS];
            }
            samples[row * MODULUS + (2 * row + 1) % MODULUS] += row as i32;
        }
        let mut workspace = [0_u64; MAX_CYCLIC_MODULUS];
        let mut predicates = [CyclicDirichletPredicate::default(); MAX_CYCLIC_MODULUS];
        let (used, allocations) = tracked_allocations(|| {
            mine_cyclic_dirichlet_equalities_into(
                &samples,
                MODULUS,
                &labels,
                &mut workspace,
                &mut predicates,
            )
            .unwrap()
        });
        assert_eq!(allocations, 0);
        let predicate = predicates[..used]
            .iter()
            .find(|predicate| usize::from(predicate.shift) == HIDDEN_SHIFT)
            .unwrap();

        let holdout_positive = base.map(|value| 18 - value);
        cyclic_dirichlet_energies_into(&holdout_positive, &mut workspace[..MODULUS]).unwrap();
        assert_eq!(workspace[HIDDEN_SHIFT], predicate.target);
        let mut holdout_negative = holdout_positive;
        holdout_negative[3] += 5;
        cyclic_dirichlet_energies_into(&holdout_negative, &mut workspace[..MODULUS]).unwrap();
        assert_ne!(workspace[HIDDEN_SHIFT], predicate.target);
    }
}
