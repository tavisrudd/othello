//! Exact-row mod-28 refinement of the g53 quotient roots.
//!
//! The affine coordinates `B=e+7k` retain `k mod 4` modulo 28.  For each
//! fixed scale-one mask this module enumerates all base-five lifts satisfying
//! the exact row equation, compiles their four autocorrelation digits into a
//! 256-bit set, and combines four blocks in `Z/4Z`.  The representation is a
//! compact structural predicate, not a large certificate.

use serde::Serialize;
use thiserror::Error;

use crate::g53_mod7_reduction::{compile_g53_mod7_assignments, G53Mod7Error};

const ORDER: usize = 18;
const SLOTS: usize = 10;
const SHIFTS: usize = 4;
const INTERIOR_ASSIGNMENTS: u32 = 390_625;
const TARGETS: [i32; SHIFTS] = [15_603, 15_080, 15_080, 15_080];

type SignatureSet = [u64; 4];

#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq)]
pub struct G53Mod28PrefixCount {
    pub active_shifts: u8,
    pub mod7_roots: u32,
    pub surviving_roots: u32,
}

#[derive(Clone, Debug, Error, PartialEq, Eq)]
pub enum G53Mod28Error {
    #[error("semantic mismatch")]
    SemanticMismatch,
    #[error(transparent)]
    Mod7(#[from] G53Mod7Error),
}

fn set_insert(set: &mut SignatureSet, code: u8) {
    set[usize::from(code >> 6)] |= 1_u64 << (code & 63);
}

fn set_contains(set: &SignatureSet, code: u8) -> bool {
    set[usize::from(code >> 6)] & (1_u64 << (code & 63)) != 0
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

fn compile_signatures(mask: u16, row_target: u16) -> Result<SignatureSet, G53Mod28Error> {
    let e = symmetric_binary_word(mask);
    let binary_weight = e.iter().copied().map(u16::from).sum::<u16>();
    let residual = row_target
        .checked_sub(binary_weight)
        .ok_or(G53Mod28Error::SemanticMismatch)?;
    if residual % 7 != 0 {
        return Err(G53Mod28Error::SemanticMismatch);
    }
    let k_weight = residual / 7;
    let base_paf: [u16; SHIFTS] = std::array::from_fn(|shift| autocorrelation(&e, shift));
    let mut signatures = [0_u64; 4];
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
            let mut signature = 0_u8;
            for shift in 0..SHIFTS {
                let difference =
                    i32::from(autocorrelation(&word, shift)) - i32::from(base_paf[shift]);
                if difference.rem_euclid(7) != 0 {
                    return Err(G53Mod28Error::SemanticMismatch);
                }
                signature |= (difference.div_euclid(7).rem_euclid(4) as u8) << (2 * shift);
            }
            set_insert(&mut signatures, signature);
        }
    }
    Ok(signatures)
}

fn project(set: SignatureSet, active: usize) -> SignatureSet {
    let mut output = [0_u64; 4];
    let mask = (1_u16 << (2 * active)) - 1;
    for code in 0_u16..256 {
        if set_contains(&set, code as u8) {
            set_insert(&mut output, (code & mask) as u8);
        }
    }
    output
}

fn add_codes(left: u8, right: u8, active: usize) -> u8 {
    let mut output = 0_u8;
    for shift in 0..active {
        let digit = (((left >> (2 * shift)) & 3) + ((right >> (2 * shift)) & 3)) & 3;
        output |= digit << (2 * shift);
    }
    output
}

fn sumset(left: SignatureSet, right: SignatureSet, active: usize) -> SignatureSet {
    let limit = 1_u16 << (2 * active);
    let mut output = [0_u64; 4];
    for first in 0..limit {
        if !set_contains(&left, first as u8) {
            continue;
        }
        for second in 0..limit {
            if set_contains(&right, second as u8) {
                set_insert(&mut output, add_codes(first as u8, second as u8, active));
            }
        }
    }
    output
}

pub fn compile_g53_mod28_prefix_counts() -> Result<[G53Mod28PrefixCount; SHIFTS], G53Mod28Error> {
    let assignments = compile_g53_mod7_assignments()?;
    let mut special_compiled = [false; 1 << SLOTS];
    let mut zero_compiled = [false; 1 << SLOTS];
    let mut special = [[0_u64; 4]; 1 << SLOTS];
    let mut zero = [[0_u64; 4]; 1 << SLOTS];
    for assignment in assignments.iter() {
        let first = usize::from(assignment[0]);
        if !special_compiled[first] {
            special[first] = compile_signatures(assignment[0], 260)?;
            special_compiled[first] = true;
        }
        for &mask in &assignment[1..] {
            let index = usize::from(mask);
            if !zero_compiled[index] {
                zero[index] = compile_signatures(mask, 261)?;
                zero_compiled[index] = true;
            }
        }
    }
    let mut output = [G53Mod28PrefixCount {
        active_shifts: 0,
        mod7_roots: assignments.len() as u32,
        surviving_roots: 0,
    }; SHIFTS];
    for active in 1..=SHIFTS {
        let mut surviving = 0_u32;
        for assignment in assignments.iter() {
            let mut base_total = [0_i32; SHIFTS];
            let mut reachable = [0_u64; 4];
            set_insert(&mut reachable, 0);
            for (block, &mask) in assignment.iter().enumerate() {
                let e = symmetric_binary_word(mask);
                for shift in 0..active {
                    base_total[shift] += i32::from(autocorrelation(&e, shift));
                }
                let block_set = if block == 0 {
                    special[usize::from(mask)]
                } else {
                    zero[usize::from(mask)]
                };
                reachable = sumset(reachable, project(block_set, active), active);
            }
            let mut target = 0_u8;
            for shift in 0..active {
                let difference = TARGETS[shift] - base_total[shift];
                if difference.rem_euclid(7) != 0 {
                    return Err(G53Mod28Error::SemanticMismatch);
                }
                target |= (difference.div_euclid(7).rem_euclid(4) as u8) << (2 * shift);
            }
            if set_contains(&reachable, target) {
                surviving += 1;
            }
        }
        output[active - 1] = G53Mod28PrefixCount {
            active_shifts: active as u8,
            mod7_roots: assignments.len() as u32,
            surviving_roots: surviving,
        };
    }
    Ok(output)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn exact_row_signature_compiler_is_nonempty() {
        let signatures = compile_signatures(58, 260).unwrap();
        assert!(signatures.iter().any(|&word| word != 0));
    }

    #[test]
    fn base_four_code_addition_matches_digitwise_arithmetic() {
        for left in 0_u8..64 {
            for right in 0_u8..64 {
                let sum = add_codes(left, right, 3);
                for shift in 0..3 {
                    assert_eq!(
                        (sum >> (2 * shift)) & 3,
                        (((left >> (2 * shift)) & 3) + ((right >> (2 * shift)) & 3)) & 3
                    );
                }
            }
        }
    }
}
