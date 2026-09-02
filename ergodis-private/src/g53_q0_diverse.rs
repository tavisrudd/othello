//! Bounded diverse exact-q0 seed compiler for the private g53 search.
//!
//! The canonical q0 compiler intentionally retains one witness for each
//! `(row_sum, energy)` DP state.  That is ideal for proving existence, but it
//! makes a poor discovery sampler: many nominally different four-block seeds
//! inherit the same block word.  This module separately enumerates exact-row
//! words, retains a small deterministic hash sample in every energy fibre,
//! and builds a bounded bank of exact-q0 seeds.  The bank has discovery
//! provenance only; every seed is replayed from its digits before admission.

use std::sync::OnceLock;

use thiserror::Error;

use crate::g53_mod7_reduction::{compile_g53_mod7_assignments, G53Mod7Error, G53Mod7Q0Lift};

const SLOTS: usize = 10;
const INTERIOR_ASSIGNMENTS: u32 = 390_625;
const Q0_TARGET: u32 = 15_603;
const QUOTIENT_TARGETS: [i32; 10] = [
    15_603, 15_080, 15_080, 15_080, 15_080, 15_080, 15_080, 15_080, 15_080, 15_080,
];
const RAW_LIFT_BUDGET: usize = 600_000;
const ENERGY_FIBRE_SAMPLE: usize = 8;
const ENERGY_WITNESS_BUDGET: usize = 8_192;
const ENERGY_TUPLE_BUDGET: usize = 65_536;
const LIFTS_PER_ASSIGNMENT: usize = 64;
const POWERS: [u32; SLOTS] = [
    1, 5, 25, 125, 625, 3_125, 15_625, 78_125, 390_625, 1_953_125,
];

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct RankedWitness {
    rank: u64,
    digits: u32,
    energy: u16,
    reserved: u16,
}

const _: () = assert!(std::mem::size_of::<RankedWitness>() == 16);

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct EnergyWitness {
    digits: u32,
    energy: u16,
    reserved: u16,
}

const _: () = assert!(std::mem::size_of::<EnergyWitness>() == 8);

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct EnergyGroup {
    begin: u16,
    length: u8,
    reserved: u8,
    energy: u16,
    padding: u16,
}

const _: () = assert!(std::mem::size_of::<EnergyGroup>() == 8);

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
struct PairGroup {
    energy: u16,
    first: u8,
    second: u8,
}

const _: () = assert!(std::mem::size_of::<PairGroup>() == 4);

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct EnergyTuple {
    group: [u8; 4],
}

#[derive(Clone, Debug, Error, PartialEq, Eq)]
pub enum G53Q0DiverseError {
    #[error("invalid affine row constraint")]
    InvalidRow,
    #[error("bounded diverse-q0 compiler exceeded its state budget")]
    StateBudget,
    #[error("arithmetic overflow")]
    ArithmeticOverflow,
    #[error("compiled seed failed direct row/q0 replay")]
    SemanticMismatch,
    #[error(transparent)]
    Mod7(#[from] G53Mod7Error),
}

#[derive(Clone, Debug)]
struct MaskFibres {
    witnesses: Box<[EnergyWitness]>,
    groups: Box<[EnergyGroup]>,
}

pub fn compile_g53_diverse_q0_lifts() -> Result<Box<[G53Mod7Q0Lift]>, G53Q0DiverseError> {
    let assignments = compile_g53_mod7_assignments()?;
    let mut special: [Option<MaskFibres>; 1 << SLOTS] = std::array::from_fn(|_| None);
    let mut zero: [Option<MaskFibres>; 1 << SLOTS] = std::array::from_fn(|_| None);
    for assignment in assignments.iter() {
        for (block, &mask) in assignment.iter().enumerate() {
            let cache = if block == 0 { &mut special } else { &mut zero };
            if cache[usize::from(mask)].is_none() {
                cache[usize::from(mask)] = Some(compile_mask_fibres(
                    mask,
                    if block == 0 { 260 } else { 261 },
                )?);
            }
        }
    }

    let capacity = assignments
        .len()
        .checked_mul(LIFTS_PER_ASSIGNMENT)
        .ok_or(G53Q0DiverseError::ArithmeticOverflow)?;
    let mut lifts = Vec::with_capacity(capacity);
    let mut right_pairs = Vec::<PairGroup>::with_capacity(4_096);
    let mut tuples = Vec::<EnergyTuple>::with_capacity(4_096);
    for assignment in assignments.iter() {
        let fibres: [&MaskFibres; 4] = std::array::from_fn(|block| {
            let cache = if block == 0 { &special } else { &zero };
            cache[usize::from(assignment[block])]
                .as_ref()
                .expect("all used masks were compiled above")
        });
        if fibres
            .iter()
            .any(|fibre| fibre.groups.len() > usize::from(u8::MAX) + 1)
        {
            return Err(G53Q0DiverseError::StateBudget);
        }
        right_pairs.clear();
        for (third, third_group) in fibres[2].groups.iter().enumerate() {
            for (fourth, fourth_group) in fibres[3].groups.iter().enumerate() {
                let energy = third_group
                    .energy
                    .checked_add(fourth_group.energy)
                    .ok_or(G53Q0DiverseError::ArithmeticOverflow)?;
                if u32::from(energy) <= Q0_TARGET {
                    right_pairs.push(PairGroup {
                        energy,
                        first: third as u8,
                        second: fourth as u8,
                    });
                }
            }
        }
        right_pairs.sort_unstable();
        tuples.clear();
        for (first, first_group) in fibres[0].groups.iter().enumerate() {
            for (second, second_group) in fibres[1].groups.iter().enumerate() {
                let left = u32::from(first_group.energy) + u32::from(second_group.energy);
                let Some(required) = Q0_TARGET.checked_sub(left) else {
                    continue;
                };
                let required =
                    u16::try_from(required).map_err(|_| G53Q0DiverseError::ArithmeticOverflow)?;
                let begin = right_pairs.partition_point(|pair| pair.energy < required);
                let end = right_pairs.partition_point(|pair| pair.energy <= required);
                for pair in &right_pairs[begin..end] {
                    if tuples.len() == ENERGY_TUPLE_BUDGET {
                        return Err(G53Q0DiverseError::StateBudget);
                    }
                    tuples.push(EnergyTuple {
                        group: [first as u8, second as u8, pair.first, pair.second],
                    });
                }
            }
        }
        if tuples.is_empty() {
            return Err(G53Q0DiverseError::SemanticMismatch);
        }
        let assignment_begin = lifts.len();
        let mut nonce = 0_u64;
        while lifts.len() - assignment_begin < LIFTS_PER_ASSIGNMENT {
            let tuple_index = mix64(mask_key(*assignment) ^ nonce) as usize % tuples.len();
            let tuple = tuples[tuple_index];
            let mut digits = [0_u32; 4];
            for block in 0..4 {
                let group = fibres[block].groups[usize::from(tuple.group[block])];
                let witness_index = mix64(
                    mask_key(*assignment) ^ nonce.rotate_left((block * 11) as u32) ^ (block as u64),
                ) as usize
                    % usize::from(group.length);
                digits[block] =
                    fibres[block].witnesses[usize::from(group.begin) + witness_index].digits;
            }
            let lift = G53Mod7Q0Lift {
                scale_one_masks: *assignment,
                scale_seven_digits: digits,
            };
            if verify_lift(lift) && !lifts[assignment_begin..].iter().any(|prior| *prior == lift) {
                lifts.push(lift);
            }
            nonce = nonce
                .checked_add(1)
                .ok_or(G53Q0DiverseError::ArithmeticOverflow)?;
            if nonce > 16_384 {
                return Err(G53Q0DiverseError::StateBudget);
            }
        }
    }
    if lifts.len() != capacity {
        return Err(G53Q0DiverseError::SemanticMismatch);
    }
    Ok(lifts.into_boxed_slice())
}

pub fn cached_g53_diverse_q0_lifts() -> Result<&'static [G53Mod7Q0Lift], G53Q0DiverseError> {
    static LIFTS: OnceLock<Result<Box<[G53Mod7Q0Lift]>, G53Q0DiverseError>> = OnceLock::new();
    match LIFTS.get_or_init(compile_g53_diverse_q0_lifts) {
        Ok(lifts) => Ok(lifts),
        Err(error) => Err(error.clone()),
    }
}

pub fn compile_g53_q0_mod49_q7_sample() -> Result<Box<[G53Mod7Q0Lift]>, G53Q0DiverseError> {
    let lifts = compile_g53_diverse_q0_lifts()?;
    let mut intersection = Vec::with_capacity(256);
    for &lift in lifts.iter() {
        let residuals = g53_q0_lift_quotient_residuals(lift)?;
        if residuals[0] != 0 {
            return Err(G53Q0DiverseError::SemanticMismatch);
        }
        if residuals[..7].iter().all(|value| value.rem_euclid(49) == 0) {
            intersection.push(lift);
        }
    }
    if intersection.is_empty() {
        return Err(G53Q0DiverseError::SemanticMismatch);
    }
    intersection.shrink_to_fit();
    Ok(intersection.into_boxed_slice())
}

pub fn cached_g53_q0_mod49_q7_sample() -> Result<&'static [G53Mod7Q0Lift], G53Q0DiverseError> {
    static LIFTS: OnceLock<Result<Box<[G53Mod7Q0Lift]>, G53Q0DiverseError>> = OnceLock::new();
    match LIFTS.get_or_init(compile_g53_q0_mod49_q7_sample) {
        Ok(lifts) => Ok(lifts),
        Err(error) => Err(error.clone()),
    }
}

/// Direct quotient replay from the packed affine digits.  This deliberately
/// does not consult the search kernel's cached marginals.
pub fn g53_q0_lift_quotient_residuals(lift: G53Mod7Q0Lift) -> Result<[i32; 10], G53Q0DiverseError> {
    let mut total = [0_u32; 10];
    for block in 0..4 {
        let mut word = [0_u16; 18];
        for (slot, place) in POWERS.iter().enumerate() {
            let digit = (lift.scale_seven_digits[block] / place) % 5;
            let value = ((lift.scale_one_masks[block] >> slot) & 1) + 7 * digit as u16;
            word[slot] = value;
            if slot != 0 && slot != 9 {
                word[18 - slot] = value;
            }
        }
        let row = word.iter().copied().map(u32::from).sum::<u32>();
        if row != if block == 0 { 260 } else { 261 } {
            return Err(G53Q0DiverseError::SemanticMismatch);
        }
        for shift in 0..10 {
            for position in 0..18 {
                total[shift] = total[shift]
                    .checked_add(u32::from(word[position] * word[(position + shift) % 18]))
                    .ok_or(G53Q0DiverseError::ArithmeticOverflow)?;
            }
        }
    }
    let mut residuals = [0_i32; 10];
    for shift in 0..10 {
        residuals[shift] = i32::try_from(total[shift])
            .map_err(|_| G53Q0DiverseError::ArithmeticOverflow)?
            - QUOTIENT_TARGETS[shift];
    }
    Ok(residuals)
}

fn compile_mask_fibres(mask: u16, row_target: u16) -> Result<MaskFibres, G53Q0DiverseError> {
    if mask >= 1 << SLOTS {
        return Err(G53Q0DiverseError::InvalidRow);
    }
    let binary_weight = symmetric_binary_weight(mask);
    let residual = row_target
        .checked_sub(binary_weight)
        .ok_or(G53Q0DiverseError::InvalidRow)?;
    if residual % 7 != 0 {
        return Err(G53Q0DiverseError::InvalidRow);
    }
    let k_weight = residual / 7;
    let mut raw = Vec::with_capacity(RAW_LIFT_BUDGET);
    for interior_code in 0..INTERIOR_ASSIGNMENTS {
        let mut code = interior_code;
        let mut interior = [0_u8; 8];
        let mut interior_sum = 0_u16;
        let mut packed = 0_u32;
        for (offset, digit) in interior.iter_mut().enumerate() {
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
        for first in endpoint_sum.saturating_sub(4)..=endpoint_sum.min(4) {
            if raw.len() == RAW_LIFT_BUDGET {
                return Err(G53Q0DiverseError::StateBudget);
            }
            let ninth = endpoint_sum - first;
            let digits = packed + u32::from(first) + u32::from(ninth) * POWERS[9];
            let energy = q0_energy(mask, digits)?;
            raw.push(RankedWitness {
                rank: mix64((u64::from(mask) << 32) | u64::from(digits)),
                digits,
                energy,
                reserved: 0,
            });
        }
    }
    raw.sort_unstable_by_key(|entry| (entry.energy, entry.rank));
    let mut witnesses = Vec::with_capacity(ENERGY_WITNESS_BUDGET);
    let mut index = 0_usize;
    while index < raw.len() {
        let energy = raw[index].energy;
        let end = raw[index..].partition_point(|entry| entry.energy == energy) + index;
        for entry in &raw[index..end.min(index + ENERGY_FIBRE_SAMPLE)] {
            if witnesses.len() == ENERGY_WITNESS_BUDGET {
                return Err(G53Q0DiverseError::StateBudget);
            }
            witnesses.push(EnergyWitness {
                digits: entry.digits,
                energy,
                reserved: 0,
            });
        }
        index = end;
    }
    let mut groups = Vec::new();
    index = 0;
    while index < witnesses.len() {
        let energy = witnesses[index].energy;
        let end = witnesses[index..].partition_point(|entry| entry.energy == energy) + index;
        groups.push(EnergyGroup {
            begin: u16::try_from(index).map_err(|_| G53Q0DiverseError::StateBudget)?,
            length: u8::try_from(end - index).map_err(|_| G53Q0DiverseError::StateBudget)?,
            reserved: 0,
            energy,
            padding: 0,
        });
        index = end;
    }
    Ok(MaskFibres {
        witnesses: witnesses.into_boxed_slice(),
        groups: groups.into_boxed_slice(),
    })
}

fn symmetric_binary_weight(mask: u16) -> u16 {
    let endpoints = (mask & 1).count_ones() + ((mask >> 9) & 1).count_ones();
    let interior = ((mask >> 1) & 0xff).count_ones();
    endpoints as u16 + 2 * interior as u16
}

fn q0_energy(mask: u16, digits: u32) -> Result<u16, G53Q0DiverseError> {
    let mut energy = 0_u32;
    for (slot, place) in POWERS.iter().enumerate() {
        let digit = (digits / place) % 5;
        let value = u32::from((mask >> slot) & 1) + 7 * digit;
        let multiplicity = if slot == 0 || slot == 9 { 1 } else { 2 };
        energy = energy
            .checked_add(multiplicity * value * value)
            .ok_or(G53Q0DiverseError::ArithmeticOverflow)?;
    }
    u16::try_from(energy).map_err(|_| G53Q0DiverseError::ArithmeticOverflow)
}

fn verify_lift(lift: G53Mod7Q0Lift) -> bool {
    let mut total_energy = 0_u32;
    for block in 0..4 {
        let target = if block == 0 { 260_u32 } else { 261_u32 };
        let mut row = 0_u32;
        for (slot, place) in POWERS.iter().enumerate() {
            let digit = (lift.scale_seven_digits[block] / place) % 5;
            let value = u32::from((lift.scale_one_masks[block] >> slot) & 1) + 7 * digit;
            let multiplicity = if slot == 0 || slot == 9 { 1 } else { 2 };
            row += multiplicity * value;
        }
        if row != target {
            return false;
        }
        let Ok(energy) = q0_energy(lift.scale_one_masks[block], lift.scale_seven_digits[block])
        else {
            return false;
        };
        total_energy += u32::from(energy);
    }
    total_energy == Q0_TARGET
}

fn mask_key(masks: [u16; 4]) -> u64 {
    u64::from(masks[0])
        | (u64::from(masks[1]) << 10)
        | (u64::from(masks[2]) << 20)
        | (u64::from(masks[3]) << 30)
}

fn mix64(mut value: u64) -> u64 {
    value = (value ^ (value >> 30)).wrapping_mul(0xbf58_476d_1ce4_e5b9);
    value = (value ^ (value >> 27)).wrapping_mul(0x94d0_49bb_1331_11eb);
    value ^ (value >> 31)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn diverse_bank_has_exact_rows_q0_and_many_witnesses_per_root() {
        let lifts = compile_g53_diverse_q0_lifts().unwrap();
        assert_eq!(lifts.len(), 2_496 * LIFTS_PER_ASSIGNMENT);
        assert!(lifts.iter().all(|&lift| verify_lift(lift)));
        for group in lifts.chunks_exact(LIFTS_PER_ASSIGNMENT).take(16) {
            assert!(group.windows(2).all(|pair| pair[0] != pair[1]));
            assert!(
                group
                    .iter()
                    .map(|lift| lift.scale_seven_digits)
                    .collect::<std::collections::BTreeSet<_>>()
                    .len()
                    >= 48
            );
        }
    }

    #[test]
    fn malformed_rows_fail_closed() {
        assert_eq!(
            compile_mask_fibres(58, 259).unwrap_err(),
            G53Q0DiverseError::InvalidRow
        );
    }

    #[test]
    fn sampled_q0_mod49_intersection_replays_directly() {
        let lifts = compile_g53_q0_mod49_q7_sample().unwrap();
        assert_eq!(lifts.len(), 118);
        for &lift in lifts.iter() {
            let residuals = g53_q0_lift_quotient_residuals(lift).unwrap();
            assert_eq!(residuals[0], 0);
            assert!(residuals[..7].iter().all(|value| value.rem_euclid(49) == 0));
        }
    }
}
