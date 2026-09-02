//! Deeper per-mask mod-49 saturation scout for q5--q7.

use std::collections::BTreeMap;
use std::sync::OnceLock;

use serde::Serialize;
use thiserror::Error;

use crate::g53_mod7_reduction::{compile_g53_mod7_assignments, G53Mod7Error};

const ORDER: usize = 18;
const SLOTS: usize = 10;
const MAX_SHIFTS: usize = 7;
const INTERIOR_ASSIGNMENTS: u32 = 390_625;
const MAX_SIGNATURES: usize = 7_usize.pow(MAX_SHIFTS as u32);
const MAX_SIGNATURE_WORDS: usize = MAX_SIGNATURES.div_ceil(64);
const TARGETS: [i32; MAX_SHIFTS] = [15_603, 15_080, 15_080, 15_080, 15_080, 15_080, 15_080];
const PAIR_CACHE_BUDGET: usize = 2_496;
const FOUR_SUM_BUDGET_PER_ROOT: u64 = 10_000_000;
const POWERS: [u32; SLOTS] = [
    1, 5, 25, 125, 625, 3_125, 15_625, 78_125, 390_625, 1_953_125,
];

#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq)]
pub struct G53Mod49HighSaturation {
    pub active_shifts: u8,
    pub signatures: u32,
    pub special_masks: u16,
    pub zero_masks: u16,
    pub full_special_masks: u16,
    pub full_zero_masks: u16,
    pub minimum_special_signatures: u32,
    pub minimum_zero_signatures: u32,
    pub maximum_special_signatures: u32,
    pub maximum_zero_signatures: u32,
}

#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq)]
pub struct G53Mod49HighJoinCount {
    pub active_shifts: u8,
    pub mod7_roots: u32,
    pub block_saturated_roots: u32,
    pub pair_saturated_roots: u32,
    pub explicit_target_hits: u32,
    pub rejected_roots: u32,
    pub inconclusive_roots: u32,
}

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct G53Mod49Q7Lift {
    pub scale_one_masks: [u16; 4],
    pub scale_seven_digits: [u32; 4],
}

const _: () = assert!(std::mem::size_of::<G53Mod49Q7Lift>() == 24);

impl G53Mod49Q7Lift {
    #[must_use]
    pub fn scale_seven_count(self, block: usize, slot: usize) -> u8 {
        ((self.scale_seven_digits[block] / POWERS[slot]) % 5) as u8
    }
}

#[derive(Clone, Debug, Error, PartialEq, Eq)]
pub enum G53Mod49HighError {
    #[error("invalid active prefix")]
    InvalidPrefix,
    #[error("semantic mismatch")]
    SemanticMismatch,
    #[error("bounded join budget exhausted")]
    JoinBudget,
    #[error(transparent)]
    Mod7(#[from] G53Mod7Error),
}

struct WitnessDomain {
    digits: Box<[u32]>,
    q0_energy: Box<[u16]>,
    cardinality: u32,
}

fn symmetric_binary_word(mask: u16) -> [u8; ORDER] {
    let mut word = [0_u8; ORDER];
    word[0] = (mask & 1) as u8;
    word[9] = ((mask >> 9) & 1) as u8;
    for slot in 1..9 {
        let value = ((mask >> slot) & 1) as u8;
        word[slot] = value;
        word[ORDER - slot] = value;
    }
    word
}

fn autocorrelation(word: &[u8; ORDER], shift: usize) -> u16 {
    (0..ORDER)
        .map(|position| u16::from(word[position]) * u16::from(word[(position + shift) % ORDER]))
        .sum()
}

fn compile_signature_set(
    mask: u16,
    row_target: u16,
    active: usize,
) -> Result<Box<[u64]>, G53Mod49HighError> {
    if !(5..=MAX_SHIFTS).contains(&active) {
        return Err(G53Mod49HighError::InvalidPrefix);
    }
    let signatures = 7_usize.pow(active as u32);
    let words = signatures.div_ceil(64);
    if words > MAX_SIGNATURE_WORDS {
        return Err(G53Mod49HighError::InvalidPrefix);
    }
    let mut seen = vec![0_u64; words];
    let e = symmetric_binary_word(mask);
    let binary_weight = e.iter().copied().map(u16::from).sum::<u16>();
    let residual = row_target
        .checked_sub(binary_weight)
        .ok_or(G53Mod49HighError::SemanticMismatch)?;
    if residual % 7 != 0 {
        return Err(G53Mod49HighError::SemanticMismatch);
    }
    let k_weight = residual / 7;
    let base_paf: [u16; MAX_SHIFTS] = std::array::from_fn(|shift| autocorrelation(&e, shift));
    let mut digits = [0_u8; 8];
    let mut word = [0_u8; ORDER];
    for interior_code in 0..INTERIOR_ASSIGNMENTS {
        let mut code = interior_code;
        let mut interior_sum = 0_u16;
        for digit in &mut digits {
            *digit = (code % 5) as u8;
            code /= 5;
            interior_sum += u16::from(*digit);
        }
        let Some(endpoint_sum) = k_weight.checked_sub(2 * interior_sum) else {
            continue;
        };
        if endpoint_sum > 8 {
            continue;
        }
        for first in endpoint_sum.saturating_sub(4)..=endpoint_sum.min(4) {
            let ninth = endpoint_sum - first;
            word[0] = e[0] + 7 * first as u8;
            word[9] = e[9] + 7 * ninth as u8;
            for slot in 1..9 {
                let value = e[slot] + 7 * digits[slot - 1];
                word[slot] = value;
                word[ORDER - slot] = value;
            }
            let mut signature = 0_usize;
            let mut place = 1_usize;
            for shift in 0..active {
                let difference =
                    i32::from(autocorrelation(&word, shift)) - i32::from(base_paf[shift]);
                if difference.rem_euclid(7) != 0 {
                    return Err(G53Mod49HighError::SemanticMismatch);
                }
                signature += difference.div_euclid(7).rem_euclid(7) as usize * place;
                place *= 7;
            }
            seen[signature >> 6] |= 1_u64 << (signature & 63);
        }
    }
    Ok(seen.into_boxed_slice())
}

fn compile_q7_witness_domain(
    mask: u16,
    row_target: u16,
) -> Result<WitnessDomain, G53Mod49HighError> {
    let active = MAX_SHIFTS;
    let signatures = MAX_SIGNATURES;
    let mut witnesses = vec![u32::MAX; signatures];
    let mut q0_energy = vec![u16::MAX; signatures];
    let e = symmetric_binary_word(mask);
    let binary_weight = e.iter().copied().map(u16::from).sum::<u16>();
    let residual = row_target
        .checked_sub(binary_weight)
        .ok_or(G53Mod49HighError::SemanticMismatch)?;
    if residual % 7 != 0 {
        return Err(G53Mod49HighError::SemanticMismatch);
    }
    let k_weight = residual / 7;
    let base_paf: [u16; MAX_SHIFTS] = std::array::from_fn(|shift| autocorrelation(&e, shift));
    let mut digits = [0_u8; 8];
    let mut word = [0_u8; ORDER];
    let mut cardinality = 0_u32;
    for interior_code in 0..INTERIOR_ASSIGNMENTS {
        let mut code = interior_code;
        let mut interior_sum = 0_u16;
        for digit in &mut digits {
            *digit = (code % 5) as u8;
            code /= 5;
            interior_sum += u16::from(*digit);
        }
        let Some(endpoint_sum) = k_weight.checked_sub(2 * interior_sum) else {
            continue;
        };
        if endpoint_sum > 8 {
            continue;
        }
        for first in endpoint_sum.saturating_sub(4)..=endpoint_sum.min(4) {
            let ninth = endpoint_sum - first;
            word[0] = e[0] + 7 * first as u8;
            word[9] = e[9] + 7 * ninth as u8;
            for slot in 1..9 {
                let value = e[slot] + 7 * digits[slot - 1];
                word[slot] = value;
                word[ORDER - slot] = value;
            }
            let mut signature = 0_usize;
            let mut place = 1_usize;
            for shift in 0..active {
                let difference =
                    i32::from(autocorrelation(&word, shift)) - i32::from(base_paf[shift]);
                if difference.rem_euclid(7) != 0 {
                    return Err(G53Mod49HighError::SemanticMismatch);
                }
                signature += difference.div_euclid(7).rem_euclid(7) as usize * place;
                place *= 7;
            }
            if witnesses[signature] == u32::MAX {
                witnesses[signature] =
                    interior_code * 5 + u32::from(first) + u32::from(ninth) * POWERS[9];
                q0_energy[signature] = autocorrelation(&word, 0);
                cardinality += 1;
            }
        }
    }
    Ok(WitnessDomain {
        digits: witnesses.into_boxed_slice(),
        q0_energy: q0_energy.into_boxed_slice(),
        cardinality,
    })
}

fn cardinality(set: &[u64]) -> u32 {
    set.iter().map(|word| word.count_ones()).sum()
}

pub fn compile_g53_mod49_high_saturation(
    active: u8,
) -> Result<G53Mod49HighSaturation, G53Mod49HighError> {
    let active = usize::from(active);
    if !(5..=MAX_SHIFTS).contains(&active) {
        return Err(G53Mod49HighError::InvalidPrefix);
    }
    let assignments = compile_g53_mod7_assignments()?;
    let mut special_used = [false; 1 << SLOTS];
    let mut zero_used = [false; 1 << SLOTS];
    for assignment in assignments.iter() {
        special_used[usize::from(assignment[0])] = true;
        for &mask in &assignment[1..] {
            zero_used[usize::from(mask)] = true;
        }
    }
    let signatures = 7_usize.pow(active as u32);
    let mut output = G53Mod49HighSaturation {
        active_shifts: active as u8,
        signatures: signatures as u32,
        special_masks: 0,
        zero_masks: 0,
        full_special_masks: 0,
        full_zero_masks: 0,
        minimum_special_signatures: signatures as u32,
        minimum_zero_signatures: signatures as u32,
        maximum_special_signatures: 0,
        maximum_zero_signatures: 0,
    };
    for (special, used, row_target) in
        [(true, &special_used, 260_u16), (false, &zero_used, 261_u16)]
    {
        for (mask, &present) in used.iter().enumerate() {
            if !present {
                continue;
            }
            let count = cardinality(&compile_signature_set(mask as u16, row_target, active)?);
            if special {
                output.special_masks += 1;
                output.minimum_special_signatures = output.minimum_special_signatures.min(count);
                output.maximum_special_signatures = output.maximum_special_signatures.max(count);
                output.full_special_masks += u16::from(count as usize == signatures);
            } else {
                output.zero_masks += 1;
                output.minimum_zero_signatures = output.minimum_zero_signatures.min(count);
                output.maximum_zero_signatures = output.maximum_zero_signatures.max(count);
                output.full_zero_masks += u16::from(count as usize == signatures);
            }
        }
    }
    Ok(output)
}

fn set_contains(set: &[u64], code: usize) -> bool {
    set[code >> 6] & (1_u64 << (code & 63)) != 0
}

fn set_insert(set: &mut [u64], code: usize) -> bool {
    let word = &mut set[code >> 6];
    let bit = 1_u64 << (code & 63);
    let fresh = *word & bit == 0;
    *word |= bit;
    fresh
}

fn add_codes(mut left: usize, mut right: usize, active: usize) -> usize {
    let mut output = 0_usize;
    let mut place = 1_usize;
    for _ in 0..active {
        output += ((left % 7 + right % 7) % 7) * place;
        left /= 7;
        right /= 7;
        place *= 7;
    }
    output
}

fn subtract_codes(mut target: usize, mut value: usize, active: usize) -> usize {
    let mut output = 0_usize;
    let mut place = 1_usize;
    for _ in 0..active {
        output += ((target % 7 + 7 - value % 7) % 7) * place;
        target /= 7;
        value /= 7;
        place *= 7;
    }
    output
}

fn sumset(left: &[u64], right: &[u64], active: usize) -> (Box<[u64]>, bool) {
    let signatures = 7_usize.pow(active as u32);
    let mut output = vec![0_u64; signatures.div_ceil(64)];
    let mut count = 0_usize;
    for first in 0..signatures {
        if !set_contains(left, first) {
            continue;
        }
        for second in 0..signatures {
            if set_contains(right, second) {
                count += usize::from(set_insert(&mut output, add_codes(first, second, active)));
                if count == signatures {
                    return (output.into_boxed_slice(), true);
                }
            }
        }
    }
    (output.into_boxed_slice(), false)
}

fn bounded_four_sum_hit(
    sets: [&[u64]; 4],
    sizes: [u32; 4],
    target: usize,
    active: usize,
) -> Option<bool> {
    let signatures = 7_usize.pow(active as u32);
    let mut order = [0_usize, 1, 2, 3];
    order.sort_unstable_by_key(|&index| sizes[index]);
    let [first, second, third, fourth] = order;
    let mut probes = 0_u64;
    for first_code in 0..signatures {
        if !set_contains(sets[first], first_code) {
            continue;
        }
        for second_code in 0..signatures {
            if !set_contains(sets[second], second_code) {
                continue;
            }
            let first_two = add_codes(first_code, second_code, active);
            for third_code in 0..signatures {
                if !set_contains(sets[third], third_code) {
                    continue;
                }
                probes += 1;
                if probes > FOUR_SUM_BUDGET_PER_ROOT {
                    return None;
                }
                let first_three = add_codes(first_two, third_code, active);
                let remaining = subtract_codes(target, first_three, active);
                if set_contains(sets[fourth], remaining) {
                    return Some(true);
                }
            }
        }
    }
    Some(false)
}

pub fn count_g53_mod49_high_join(active: u8) -> Result<G53Mod49HighJoinCount, G53Mod49HighError> {
    let active = usize::from(active);
    if !(5..=MAX_SHIFTS).contains(&active) {
        return Err(G53Mod49HighError::InvalidPrefix);
    }
    let assignments = compile_g53_mod7_assignments()?;
    let signatures = 7_usize.pow(active as u32);
    let mut special: [Option<Box<[u64]>>; 1 << SLOTS] = std::array::from_fn(|_| None);
    let mut zero: [Option<Box<[u64]>>; 1 << SLOTS] = std::array::from_fn(|_| None);
    for assignment in assignments.iter() {
        let first = usize::from(assignment[0]);
        if special[first].is_none() {
            special[first] = Some(compile_signature_set(assignment[0], 260, active)?);
        }
        for &mask in &assignment[1..] {
            let index = usize::from(mask);
            if zero[index].is_none() {
                zero[index] = Some(compile_signature_set(mask, 261, active)?);
            }
        }
    }
    let mut block_saturated = 0_u32;
    let mut pair_saturated = 0_u32;
    let mut explicit_hits = 0_u32;
    let mut rejected = 0_u32;
    let mut inconclusive = 0_u32;
    let mut pair_cache = BTreeMap::<(u8, u16, u8, u16), (Box<[u64]>, bool)>::new();
    for assignment in assignments.iter() {
        let sets: [&[u64]; 4] = [
            special[usize::from(assignment[0])]
                .as_deref()
                .ok_or(G53Mod49HighError::SemanticMismatch)?,
            zero[usize::from(assignment[1])]
                .as_deref()
                .ok_or(G53Mod49HighError::SemanticMismatch)?,
            zero[usize::from(assignment[2])]
                .as_deref()
                .ok_or(G53Mod49HighError::SemanticMismatch)?,
            zero[usize::from(assignment[3])]
                .as_deref()
                .ok_or(G53Mod49HighError::SemanticMismatch)?,
        ];
        let sizes = sets.map(cardinality);
        if sizes.iter().any(|&size| size as usize == signatures) {
            block_saturated += 1;
            continue;
        }
        let mut base_total = [0_i32; MAX_SHIFTS];
        for &mask in assignment {
            let e = symmetric_binary_word(mask);
            for shift in 0..active {
                base_total[shift] += i32::from(autocorrelation(&e, shift));
            }
        }
        let mut target = 0_usize;
        let mut place = 1_usize;
        for shift in 0..active {
            let difference = TARGETS[shift] - base_total[shift];
            if difference.rem_euclid(7) != 0 {
                return Err(G53Mod49HighError::SemanticMismatch);
            }
            target += difference.div_euclid(7).rem_euclid(7) as usize * place;
            place *= 7;
        }
        if active == 7 {
            match bounded_four_sum_hit(sets, sizes, target, active) {
                Some(true) => explicit_hits += 1,
                Some(false) => rejected += 1,
                None => inconclusive += 1,
            }
            continue;
        }
        let pairings = [(0, 1, 2, 3), (0, 2, 1, 3), (0, 3, 1, 2)];
        let &(first, second, third, fourth) = pairings
            .iter()
            .min_by_key(|&&(left, right, _, _)| u64::from(sizes[left]) * u64::from(sizes[right]))
            .ok_or(G53Mod49HighError::SemanticMismatch)?;
        let mut first_key = (u8::from(first != 0), assignment[first]);
        let mut second_key = (u8::from(second != 0), assignment[second]);
        if second_key < first_key {
            std::mem::swap(&mut first_key, &mut second_key);
        }
        let key = (first_key.0, first_key.1, second_key.0, second_key.1);
        if !pair_cache.contains_key(&key) {
            if pair_cache.len() == PAIR_CACHE_BUDGET {
                return Err(G53Mod49HighError::SemanticMismatch);
            }
            pair_cache.insert(key, sumset(sets[first], sets[second], active));
        }
        let (pair, full) = pair_cache
            .get(&key)
            .ok_or(G53Mod49HighError::SemanticMismatch)?;
        if *full {
            pair_saturated += 1;
            continue;
        }
        let mut hit = false;
        'search: for third_code in 0..signatures {
            if !set_contains(sets[third], third_code) {
                continue;
            }
            for fourth_code in 0..signatures {
                if !set_contains(sets[fourth], fourth_code) {
                    continue;
                }
                let remaining =
                    subtract_codes(target, add_codes(third_code, fourth_code, active), active);
                if set_contains(pair, remaining) {
                    hit = true;
                    break 'search;
                }
            }
        }
        if hit {
            explicit_hits += 1;
        } else {
            rejected += 1;
        }
    }
    Ok(G53Mod49HighJoinCount {
        active_shifts: active as u8,
        mod7_roots: assignments.len() as u32,
        block_saturated_roots: block_saturated,
        pair_saturated_roots: pair_saturated,
        explicit_target_hits: explicit_hits,
        rejected_roots: rejected,
        inconclusive_roots: inconclusive,
    })
}

fn find_q7_codes(
    domains: [&WitnessDomain; 4],
    target: usize,
    require_exact_q0: bool,
) -> Result<[usize; 4], G53Mod49HighError> {
    let mut order = [0_usize, 1, 2, 3];
    order.sort_unstable_by_key(|&index| domains[index].cardinality);
    let [first, second, third, fourth] = order;
    let mut probes = 0_u64;
    for first_code in 0..MAX_SIGNATURES {
        if domains[first].digits[first_code] == u32::MAX {
            continue;
        }
        for second_code in 0..MAX_SIGNATURES {
            if domains[second].digits[second_code] == u32::MAX {
                continue;
            }
            let first_two = add_codes(first_code, second_code, MAX_SHIFTS);
            for third_code in 0..MAX_SIGNATURES {
                if domains[third].digits[third_code] == u32::MAX {
                    continue;
                }
                probes += 1;
                if probes > FOUR_SUM_BUDGET_PER_ROOT {
                    return Err(G53Mod49HighError::JoinBudget);
                }
                let first_three = add_codes(first_two, third_code, MAX_SHIFTS);
                let fourth_code = subtract_codes(target, first_three, MAX_SHIFTS);
                if domains[fourth].digits[fourth_code] != u32::MAX {
                    if require_exact_q0 {
                        let energy = u32::from(domains[first].q0_energy[first_code])
                            + u32::from(domains[second].q0_energy[second_code])
                            + u32::from(domains[third].q0_energy[third_code])
                            + u32::from(domains[fourth].q0_energy[fourth_code]);
                        if energy != TARGETS[0] as u32 {
                            continue;
                        }
                    }
                    let mut codes = [0_usize; 4];
                    codes[first] = first_code;
                    codes[second] = second_code;
                    codes[third] = third_code;
                    codes[fourth] = fourth_code;
                    return Ok(codes);
                }
            }
        }
    }
    Err(G53Mod49HighError::SemanticMismatch)
}

pub fn g53_mod49_q7_lift_residuals(
    lift: G53Mod49Q7Lift,
) -> Result<[i32; MAX_SHIFTS], G53Mod49HighError> {
    let mut total = [0_u32; MAX_SHIFTS];
    for block in 0..4 {
        let mut word = [0_u8; ORDER];
        let mask = lift.scale_one_masks[block];
        word[0] = (mask & 1) as u8 + 7 * lift.scale_seven_count(block, 0);
        word[9] = ((mask >> 9) & 1) as u8 + 7 * lift.scale_seven_count(block, 9);
        for slot in 1..9 {
            let value = ((mask >> slot) & 1) as u8 + 7 * lift.scale_seven_count(block, slot);
            word[slot] = value;
            word[ORDER - slot] = value;
        }
        let row = word.iter().copied().map(u16::from).sum::<u16>();
        if row != if block == 0 { 260 } else { 261 } {
            return Err(G53Mod49HighError::SemanticMismatch);
        }
        for shift in 0..MAX_SHIFTS {
            total[shift] += u32::from(autocorrelation(&word, shift));
        }
    }
    let mut residuals = [0_i32; MAX_SHIFTS];
    for shift in 0..MAX_SHIFTS {
        residuals[shift] = i32::try_from(total[shift])
            .map_err(|_| G53Mod49HighError::SemanticMismatch)?
            - TARGETS[shift];
        if residuals[shift].rem_euclid(49) != 0 {
            return Err(G53Mod49HighError::SemanticMismatch);
        }
    }
    Ok(residuals)
}

fn verify_q7_lift(lift: G53Mod49Q7Lift) -> Result<(), G53Mod49HighError> {
    g53_mod49_q7_lift_residuals(lift)?;
    Ok(())
}

fn compile_g53_mod49_q7_lifts_inner(
    require_exact_q0: bool,
) -> Result<Box<[G53Mod49Q7Lift]>, G53Mod49HighError> {
    let assignments = compile_g53_mod7_assignments()?;
    let mut special: [Option<WitnessDomain>; 1 << SLOTS] = std::array::from_fn(|_| None);
    let mut zero: [Option<WitnessDomain>; 1 << SLOTS] = std::array::from_fn(|_| None);
    for assignment in assignments.iter() {
        let first = usize::from(assignment[0]);
        if special[first].is_none() {
            special[first] = Some(compile_q7_witness_domain(assignment[0], 260)?);
        }
        for &mask in &assignment[1..] {
            let index = usize::from(mask);
            if zero[index].is_none() {
                zero[index] = Some(compile_q7_witness_domain(mask, 261)?);
            }
        }
    }
    let mut lifts = Vec::with_capacity(assignments.len());
    for assignment in assignments.iter() {
        let domains = [
            special[usize::from(assignment[0])]
                .as_ref()
                .ok_or(G53Mod49HighError::SemanticMismatch)?,
            zero[usize::from(assignment[1])]
                .as_ref()
                .ok_or(G53Mod49HighError::SemanticMismatch)?,
            zero[usize::from(assignment[2])]
                .as_ref()
                .ok_or(G53Mod49HighError::SemanticMismatch)?,
            zero[usize::from(assignment[3])]
                .as_ref()
                .ok_or(G53Mod49HighError::SemanticMismatch)?,
        ];
        let mut base_total = [0_i32; MAX_SHIFTS];
        for &mask in assignment {
            let e = symmetric_binary_word(mask);
            for shift in 0..MAX_SHIFTS {
                base_total[shift] += i32::from(autocorrelation(&e, shift));
            }
        }
        let mut target = 0_usize;
        let mut place = 1_usize;
        for shift in 0..MAX_SHIFTS {
            let difference = TARGETS[shift] - base_total[shift];
            if difference.rem_euclid(7) != 0 {
                return Err(G53Mod49HighError::SemanticMismatch);
            }
            target += difference.div_euclid(7).rem_euclid(7) as usize * place;
            place *= 7;
        }
        let codes = find_q7_codes(domains, target, require_exact_q0)?;
        let lift = G53Mod49Q7Lift {
            scale_one_masks: *assignment,
            scale_seven_digits: std::array::from_fn(|block| domains[block].digits[codes[block]]),
        };
        verify_q7_lift(lift)?;
        if require_exact_q0 && g53_mod49_q7_lift_residuals(lift)?[0] != 0 {
            return Err(G53Mod49HighError::SemanticMismatch);
        }
        lifts.push(lift);
    }
    Ok(lifts.into_boxed_slice())
}

pub fn compile_g53_mod49_q7_lifts() -> Result<Box<[G53Mod49Q7Lift]>, G53Mod49HighError> {
    compile_g53_mod49_q7_lifts_inner(false)
}

/// Compile discovery seeds satisfying exact q0 and q1--q6 modulo 49.
/// Failure remains a bounded-search result and has no coverage authority.
pub fn compile_g53_mod49_exact_q0_q7_lifts() -> Result<Box<[G53Mod49Q7Lift]>, G53Mod49HighError> {
    compile_g53_mod49_q7_lifts_inner(true)
}

pub fn cached_g53_mod49_q7_lifts() -> Result<&'static [G53Mod49Q7Lift], G53Mod49HighError> {
    static LIFTS: OnceLock<Result<Box<[G53Mod49Q7Lift]>, G53Mod49HighError>> = OnceLock::new();
    match LIFTS.get_or_init(compile_g53_mod49_q7_lifts) {
        Ok(lifts) => Ok(lifts),
        Err(error) => Err(error.clone()),
    }
}

pub fn cached_g53_mod49_exact_q0_q7_lifts() -> Result<&'static [G53Mod49Q7Lift], G53Mod49HighError>
{
    static LIFTS: OnceLock<Result<Box<[G53Mod49Q7Lift]>, G53Mod49HighError>> = OnceLock::new();
    match LIFTS.get_or_init(compile_g53_mod49_exact_q0_q7_lifts) {
        Ok(lifts) => Ok(lifts),
        Err(error) => Err(error.clone()),
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn active_prefix_bounds_fail_closed() {
        assert_eq!(
            compile_g53_mod49_high_saturation(4).unwrap_err(),
            G53Mod49HighError::InvalidPrefix
        );
        assert_eq!(
            compile_g53_mod49_high_saturation(8).unwrap_err(),
            G53Mod49HighError::InvalidPrefix
        );
    }
}
