//! Exact bounded q0--q3 block-profile compiler for the g53 quotient search.
//!
//! This is discovery infrastructure, not proof authority. It enumerates every
//! symmetric base-five lift of a fixed mod-seven root with the exact row sum,
//! then canonicalizes the resulting four integer autocorrelations. A later
//! independent join/replay layer may promote consequences of this census.

use serde::Serialize;
use thiserror::Error;

use crate::g53_mod7_reduction::{compile_g53_mod7_assignments, G53Mod7Error};

const ORDER: usize = 18;
const SLOTS: usize = 10;
const ACTIVE_SHIFTS: usize = 4;
const INTERIOR_ASSIGNMENTS: u32 = 390_625;
const PROFILE_BUDGET: usize = 2_000_000;
const POWERS: [u32; SLOTS] = [
    1, 5, 25, 125, 625, 3_125, 15_625, 78_125, 390_625, 1_953_125,
];

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
pub struct G53Q4Profile {
    pub paf: [u16; ACTIVE_SHIFTS],
    pub digits: u32,
    reserved: u32,
}

const _: () = assert!(std::mem::size_of::<G53Q4Profile>() == 16);
const _: () = assert!(std::mem::align_of::<G53Q4Profile>() == 4);

#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq)]
pub struct G53Q4ProfileCount {
    pub special_block: bool,
    pub mask: u16,
    pub raw_lifts: u32,
    pub distinct_profiles: u32,
}

#[derive(Clone, Debug, Error, PartialEq, Eq)]
pub enum G53Q4ProfileError {
    #[error("invalid affine row constraint")]
    InvalidRow,
    #[error("profile budget exceeded")]
    ProfileBudget,
    #[error("arithmetic overflow")]
    ArithmeticOverflow,
    #[error(transparent)]
    Mod7(#[from] G53Mod7Error),
}

fn symmetric_binary_weight(mask: u16) -> u16 {
    let endpoints = (mask & 1).count_ones() + ((mask >> 9) & 1).count_ones();
    let interior = ((mask >> 1) & 0xff).count_ones();
    endpoints as u16 + 2 * interior as u16
}

pub fn compile_g53_q4_profiles(
    mask: u16,
    row_target: u16,
) -> Result<Box<[G53Q4Profile]>, G53Q4ProfileError> {
    if mask >= 1 << SLOTS {
        return Err(G53Q4ProfileError::InvalidRow);
    }
    let binary_weight = symmetric_binary_weight(mask);
    let residual = row_target
        .checked_sub(binary_weight)
        .ok_or(G53Q4ProfileError::InvalidRow)?;
    if residual % 7 != 0 {
        return Err(G53Q4ProfileError::InvalidRow);
    }
    let k_weight = residual / 7;
    let mut profiles = Vec::with_capacity(PROFILE_BUDGET);
    let mut interior_digits = [0_u8; 8];
    let mut word = [0_u16; ORDER];
    for interior_code in 0..INTERIOR_ASSIGNMENTS {
        let mut code = interior_code;
        let mut interior_sum = 0_u16;
        let mut packed = 0_u32;
        for (offset, digit) in interior_digits.iter_mut().enumerate() {
            *digit = (code % 5) as u8;
            code /= 5;
            interior_sum += u16::from(*digit);
            packed += u32::from(*digit) * POWERS[offset + 1];
        }
        let Some(endpoint_sum) = k_weight.checked_sub(2 * interior_sum) else {
            continue;
        };
        if endpoint_sum > 8 {
            continue;
        }
        let first_min = endpoint_sum.saturating_sub(4);
        let first_max = endpoint_sum.min(4);
        for first in first_min..=first_max {
            if profiles.len() == PROFILE_BUDGET {
                return Err(G53Q4ProfileError::ProfileBudget);
            }
            let ninth = endpoint_sum - first;
            word[0] = (mask & 1) + 7 * first;
            word[9] = ((mask >> 9) & 1) + 7 * ninth;
            for slot in 1..9 {
                let value = ((mask >> slot) & 1) + 7 * u16::from(interior_digits[slot - 1]);
                word[slot] = value;
                word[ORDER - slot] = value;
            }
            let mut paf = [0_u16; ACTIVE_SHIFTS];
            for shift in 0..ACTIVE_SHIFTS {
                let mut value = 0_u32;
                for position in 0..ORDER {
                    value = value
                        .checked_add(u32::from(word[position] * word[(position + shift) % ORDER]))
                        .ok_or(G53Q4ProfileError::ArithmeticOverflow)?;
                }
                paf[shift] =
                    u16::try_from(value).map_err(|_| G53Q4ProfileError::ArithmeticOverflow)?;
            }
            profiles.push(G53Q4Profile {
                paf,
                digits: packed + u32::from(first) + u32::from(ninth) * POWERS[9],
                reserved: 0,
            });
        }
    }
    profiles.sort_unstable_by_key(|profile| profile.paf);
    profiles.dedup_by_key(|profile| profile.paf);
    profiles.shrink_to_fit();
    Ok(profiles.into_boxed_slice())
}

pub fn compile_g53_q4_profile_counts(
    max_masks_per_kind: usize,
) -> Result<Box<[G53Q4ProfileCount]>, G53Q4ProfileError> {
    let assignments = compile_g53_mod7_assignments()?;
    let mut special = [false; 1 << SLOTS];
    let mut zero = [false; 1 << SLOTS];
    for assignment in assignments.iter() {
        special[usize::from(assignment[0])] = true;
        for &mask in &assignment[1..] {
            zero[usize::from(mask)] = true;
        }
    }
    let mut counts = Vec::with_capacity(2 * max_masks_per_kind);
    for (special_block, used, row_target) in [(true, special, 260_u16), (false, zero, 261_u16)] {
        let mut compiled = 0_usize;
        for (mask, &is_used) in used.iter().enumerate() {
            if !is_used || compiled == max_masks_per_kind {
                continue;
            }
            let profiles = compile_g53_q4_profiles(mask as u16, row_target)?;
            counts.push(G53Q4ProfileCount {
                special_block,
                mask: mask as u16,
                raw_lifts: count_row_lifts(mask as u16, row_target)?,
                distinct_profiles: profiles.len() as u32,
            });
            compiled += 1;
        }
    }
    Ok(counts.into_boxed_slice())
}

fn count_row_lifts(mask: u16, row_target: u16) -> Result<u32, G53Q4ProfileError> {
    let binary_weight = symmetric_binary_weight(mask);
    let residual = row_target
        .checked_sub(binary_weight)
        .ok_or(G53Q4ProfileError::InvalidRow)?;
    if residual % 7 != 0 {
        return Err(G53Q4ProfileError::InvalidRow);
    }
    let k_weight = residual / 7;
    let mut count = 0_u32;
    for interior_code in 0..INTERIOR_ASSIGNMENTS {
        let mut code = interior_code;
        let mut interior_sum = 0_u16;
        for _ in 0..8 {
            interior_sum += (code % 5) as u16;
            code /= 5;
        }
        let Some(endpoint_sum) = k_weight.checked_sub(2 * interior_sum) else {
            continue;
        };
        if endpoint_sum <= 8 {
            count += u32::from(endpoint_sum.min(4) - endpoint_sum.saturating_sub(4) + 1);
        }
    }
    Ok(count)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn profile_records_have_tiger_layout_and_direct_bounds() {
        let profiles = compile_g53_q4_profiles(58, 260).unwrap();
        assert!(!profiles.is_empty());
        assert!(profiles.windows(2).all(|pair| pair[0].paf < pair[1].paf));
        for profile in profiles.iter().take(1_000) {
            assert!(profile.paf.iter().all(|&value| value <= 15_603));
        }
    }

    #[test]
    fn invalid_affine_rows_fail_closed() {
        assert_eq!(
            compile_g53_q4_profiles(58, 259).unwrap_err(),
            G53Q4ProfileError::InvalidRow
        );
        assert_eq!(
            compile_g53_q4_profiles(1 << 10, 260).unwrap_err(),
            G53Q4ProfileError::InvalidRow
        );
    }
}
