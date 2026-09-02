//! Discovery-only q0--q4 lift scout modulo 7^3 for g53.
//!
//! For `B=e+7k`, subtracting the binary autocorrelation and dividing by
//! seven leaves a signature modulo 49.  Unlike the earlier mod-49 layer this
//! retains the quadratic `7 C(k)` term.  Hits are constructive and replayed;
//! bounded misses have no coverage authority.

use std::collections::BTreeMap;

use serde::Serialize;
use thiserror::Error;

use crate::g53_mod7_reduction::{compile_g53_mod7_assignments, G53Mod7Error};

const ORDER: usize = 18;
const SLOTS: usize = 10;
const ACTIVE: usize = 5;
const RADIX: u32 = 49;
const INTERIOR_ASSIGNMENTS: u32 = 390_625;
const DOMAIN_BUDGET: usize = 600_000;
const PROBE_BUDGET_PER_ROOT: u32 = 1_000_000;
const TARGETS: [i32; ACTIVE] = [15_603, 15_080, 15_080, 15_080, 15_080];

#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq)]
pub struct G53Mod343ScoutReport {
    pub modulus: u16,
    pub active_shifts: u8,
    pub roots: u32,
    pub constructive_hits: u32,
    pub bounded_misses: u32,
    pub probes: u64,
    pub special_mask_hits: [(u16, u16); 10],
}

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct DomainEntry {
    signature: u32,
    witness: u32,
}

const _: () = assert!(std::mem::size_of::<DomainEntry>() == 8);

#[derive(Clone, Debug, Error, PartialEq, Eq)]
pub enum G53Mod343Error {
    #[error("invalid affine row")]
    InvalidRow,
    #[error("signature domain exceeded its bound")]
    StateBudget,
    #[error("semantic mismatch")]
    SemanticMismatch,
    #[error(transparent)]
    Mod7(#[from] G53Mod7Error),
}

fn binary_word(mask: u16) -> [u16; ORDER] {
    let mut word = [0_u16; ORDER];
    word[0] = mask & 1;
    word[9] = (mask >> 9) & 1;
    for slot in 1..9 {
        word[slot] = (mask >> slot) & 1;
        word[ORDER - slot] = word[slot];
    }
    word
}

fn paf(word: &[u16; ORDER], shift: usize) -> i32 {
    (0..ORDER)
        .map(|position| i32::from(word[position] * word[(position + shift) % ORDER]))
        .sum()
}

fn compile_domain(mask: u16, row_target: u16) -> Result<Box<[DomainEntry]>, G53Mod343Error> {
    let base = binary_word(mask);
    let base_paf: [i32; ACTIVE] = std::array::from_fn(|shift| paf(&base, shift));
    let binary_weight = base.iter().copied().sum::<u16>();
    let residual = row_target
        .checked_sub(binary_weight)
        .ok_or(G53Mod343Error::InvalidRow)?;
    if residual % 7 != 0 {
        return Err(G53Mod343Error::InvalidRow);
    }
    let k_weight = residual / 7;
    let mut signatures = Vec::with_capacity(DOMAIN_BUDGET);
    let mut interior = [0_u8; 8];
    let mut word = [0_u16; ORDER];
    for interior_code in 0..INTERIOR_ASSIGNMENTS {
        let mut code = interior_code;
        let mut interior_sum = 0_u16;
        for digit in &mut interior {
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
            if signatures.len() == DOMAIN_BUDGET {
                return Err(G53Mod343Error::StateBudget);
            }
            let ninth = endpoint_sum - first;
            word[0] = base[0] + 7 * first;
            word[9] = base[9] + 7 * ninth;
            for slot in 1..9 {
                word[slot] = base[slot] + 7 * u16::from(interior[slot - 1]);
                word[ORDER - slot] = word[slot];
            }
            let mut signature = 0_u32;
            let mut place = 1_u32;
            for shift in 0..ACTIVE {
                let difference = paf(&word, shift) - base_paf[shift];
                if difference.rem_euclid(7) != 0 {
                    return Err(G53Mod343Error::SemanticMismatch);
                }
                signature += difference.div_euclid(7).rem_euclid(49) as u32 * place;
                place *= RADIX;
            }
            signatures.push(DomainEntry {
                signature,
                witness: interior_code | (u32::from(first) << 19),
            });
        }
    }
    signatures.sort_unstable_by_key(|entry| (entry.signature, entry.witness));
    signatures.dedup_by_key(|entry| entry.signature);
    signatures.shrink_to_fit();
    Ok(signatures.into_boxed_slice())
}

fn decode_entry(
    mask: u16,
    row_target: u16,
    entry: DomainEntry,
) -> Result<[u16; ORDER], G53Mod343Error> {
    let base = binary_word(mask);
    let binary_weight = base.iter().copied().sum::<u16>();
    let residual = row_target
        .checked_sub(binary_weight)
        .ok_or(G53Mod343Error::InvalidRow)?;
    if residual % 7 != 0 {
        return Err(G53Mod343Error::InvalidRow);
    }
    let mut interior_code = entry.witness & ((1 << 19) - 1);
    let first = (entry.witness >> 19) as u16;
    let mut interior = [0_u16; 8];
    let mut interior_sum = 0_u16;
    for digit in &mut interior {
        *digit = (interior_code % 5) as u16;
        interior_code /= 5;
        interior_sum += *digit;
    }
    let endpoint_sum = residual
        .checked_div(7)
        .and_then(|weight| weight.checked_sub(2 * interior_sum))
        .ok_or(G53Mod343Error::SemanticMismatch)?;
    let ninth = endpoint_sum
        .checked_sub(first)
        .ok_or(G53Mod343Error::SemanticMismatch)?;
    if first > 4 || ninth > 4 || interior_code != 0 {
        return Err(G53Mod343Error::SemanticMismatch);
    }
    let mut word = [0_u16; ORDER];
    word[0] = base[0] + 7 * first;
    word[9] = base[9] + 7 * ninth;
    for slot in 1..9 {
        word[slot] = base[slot] + 7 * interior[slot - 1];
        word[ORDER - slot] = word[slot];
    }
    Ok(word)
}

fn replay_mod343_hit(
    assignment: &[u16; 4],
    entries: [DomainEntry; 4],
) -> Result<(), G53Mod343Error> {
    let row_targets = [260_u16, 261, 261, 261];
    let mut words = [[0_u16; ORDER]; 4];
    for block in 0..4 {
        words[block] = decode_entry(assignment[block], row_targets[block], entries[block])?;
        if words[block].iter().copied().sum::<u16>() != row_targets[block] {
            return Err(G53Mod343Error::SemanticMismatch);
        }
        for position in 0..ORDER {
            if words[block][position] % 7 != binary_word(assignment[block])[position] {
                return Err(G53Mod343Error::SemanticMismatch);
            }
        }
    }
    for shift in 0..ACTIVE {
        let total = words.iter().map(|word| paf(word, shift)).sum::<i32>();
        if (total - TARGETS[shift]).rem_euclid(343) != 0 {
            return Err(G53Mod343Error::SemanticMismatch);
        }
    }
    Ok(())
}

fn add_codes(mut left: u32, mut right: u32) -> u32 {
    let mut output = 0_u32;
    let mut place = 1_u32;
    for _ in 0..ACTIVE {
        output += ((left % RADIX + right % RADIX) % RADIX) * place;
        left /= RADIX;
        right /= RADIX;
        place *= RADIX;
    }
    output
}

fn subtract_codes(mut target: u32, mut value: u32) -> u32 {
    let mut output = 0_u32;
    let mut place = 1_u32;
    for _ in 0..ACTIVE {
        output += ((target % RADIX + RADIX - value % RADIX) % RADIX) * place;
        target /= RADIX;
        value /= RADIX;
        place *= RADIX;
    }
    output
}

fn mix64(mut value: u64) -> u64 {
    value = (value ^ (value >> 30)).wrapping_mul(0xbf58_476d_1ce4_e5b9);
    value = (value ^ (value >> 27)).wrapping_mul(0x94d0_49bb_1331_11eb);
    value ^ (value >> 31)
}

pub fn scout_g53_mod343_q4() -> Result<G53Mod343ScoutReport, G53Mod343Error> {
    let assignments = compile_g53_mod7_assignments()?;
    let mut special: [Option<Box<[DomainEntry]>>; 1 << SLOTS] = std::array::from_fn(|_| None);
    let mut zero: [Option<Box<[DomainEntry]>>; 1 << SLOTS] = std::array::from_fn(|_| None);
    for assignment in assignments.iter() {
        let first = usize::from(assignment[0]);
        if special[first].is_none() {
            special[first] = Some(compile_domain(assignment[0], 260)?);
        }
        for &mask in &assignment[1..] {
            let index = usize::from(mask);
            if zero[index].is_none() {
                zero[index] = Some(compile_domain(mask, 261)?);
            }
        }
    }
    let mut hits = 0_u32;
    let mut misses = 0_u32;
    let mut probes_total = 0_u64;
    let mut by_special = BTreeMap::<u16, u16>::new();
    for assignment in assignments.iter() {
        by_special.entry(assignment[0]).or_default();
    }
    for assignment in assignments.iter() {
        let domains: [&[DomainEntry]; 4] = [
            special[usize::from(assignment[0])]
                .as_deref()
                .ok_or(G53Mod343Error::SemanticMismatch)?,
            zero[usize::from(assignment[1])]
                .as_deref()
                .ok_or(G53Mod343Error::SemanticMismatch)?,
            zero[usize::from(assignment[2])]
                .as_deref()
                .ok_or(G53Mod343Error::SemanticMismatch)?,
            zero[usize::from(assignment[3])]
                .as_deref()
                .ok_or(G53Mod343Error::SemanticMismatch)?,
        ];
        let mut base_total = [0_i32; ACTIVE];
        for &mask in assignment {
            let base = binary_word(mask);
            for shift in 0..ACTIVE {
                base_total[shift] += paf(&base, shift);
            }
        }
        let mut target = 0_u32;
        let mut place = 1_u32;
        for shift in 0..ACTIVE {
            let difference = TARGETS[shift] - base_total[shift];
            if difference.rem_euclid(7) != 0 {
                return Err(G53Mod343Error::SemanticMismatch);
            }
            target += difference.div_euclid(7).rem_euclid(49) as u32 * place;
            place *= RADIX;
        }
        let seed = u64::from(assignment[0])
            | (u64::from(assignment[1]) << 10)
            | (u64::from(assignment[2]) << 20)
            | (u64::from(assignment[3]) << 30);
        let mut hit = false;
        for probe in 0..PROBE_BUDGET_PER_ROOT {
            let first = domains[0]
                [mix64(seed ^ u64::from(probe).wrapping_mul(3)) as usize % domains[0].len()];
            let second = domains[1]
                [mix64(seed ^ u64::from(probe).wrapping_mul(5)) as usize % domains[1].len()];
            let third = domains[2]
                [mix64(seed ^ u64::from(probe).wrapping_mul(7)) as usize % domains[2].len()];
            let required = subtract_codes(
                target,
                add_codes(
                    add_codes(first.signature, second.signature),
                    third.signature,
                ),
            );
            probes_total += 1;
            if let Ok(index) = domains[3].binary_search_by_key(&required, |entry| entry.signature) {
                replay_mod343_hit(assignment, [first, second, third, domains[3][index]])?;
                hit = true;
                break;
            }
        }
        if hit {
            hits += 1;
            *by_special.entry(assignment[0]).or_default() += 1;
        } else {
            misses += 1;
        }
    }
    let mut special_mask_hits = [(0_u16, 0_u16); 10];
    for (slot, (&mask, &count)) in by_special.iter().enumerate() {
        special_mask_hits[slot] = (mask, count);
    }
    Ok(G53Mod343ScoutReport {
        modulus: 343,
        active_shifts: ACTIVE as u8,
        roots: assignments.len() as u32,
        constructive_hits: hits,
        bounded_misses: misses,
        probes: probes_total,
        special_mask_hits,
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn packed_base49_arithmetic_is_digitwise() {
        for left in [0, 1, 48, 49, 49 * 49 + 7] {
            for right in [0, 2, 48, 50, 48 * 49 * 49] {
                let sum = add_codes(left, right);
                assert_eq!(subtract_codes(sum, right), left);
            }
        }
    }

    #[test]
    fn compiled_domain_representatives_replay_rows_and_signatures() {
        let mask = 58;
        let entries = compile_domain(mask, 260).unwrap();
        for &entry in entries.iter().step_by((entries.len() / 97).max(1)) {
            let word = decode_entry(mask, 260, entry).unwrap();
            assert_eq!(word.iter().copied().sum::<u16>(), 260);
            let base = binary_word(mask);
            let mut signature = 0_u32;
            let mut place = 1_u32;
            for shift in 0..ACTIVE {
                let difference = paf(&word, shift) - paf(&base, shift);
                signature += difference.div_euclid(7).rem_euclid(49) as u32 * place;
                place *= RADIX;
            }
            assert_eq!(signature, entry.signature);
        }
    }
}
