//! Per-mask saturation scout for the g53 mod-49 quotient refinement.
//!
//! Exact row lifts are projected to `(C(B)-C(e))/7 mod 7` for q0--q3.  A
//! full 2,401-element signature set proves that the mask contributes no
//! mod-49 restriction at this prefix, avoiding an unnecessary four-block
//! join.  Counts are exact computational discovery evidence only.

use serde::Serialize;
use thiserror::Error;

use crate::g53_mod7_reduction::{compile_g53_mod7_assignments, G53Mod7Error};

const ORDER: usize = 18;
const SLOTS: usize = 10;
const SHIFTS: usize = 4;
const INTERIOR_ASSIGNMENTS: u32 = 390_625;
const TARGETS: [i32; SHIFTS] = [15_603, 15_080, 15_080, 15_080];
const SIGNATURES: usize = 7_usize.pow(SHIFTS as u32);
const SIGNATURE_WORDS: usize = SIGNATURES.div_ceil(64);

type SignatureSet = [u64; SIGNATURE_WORDS];

#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq)]
pub struct G53Mod49Saturation {
    pub special_masks: u16,
    pub zero_masks: u16,
    pub full_special_masks: u16,
    pub full_zero_masks: u16,
    pub minimum_special_signatures: u16,
    pub minimum_zero_signatures: u16,
}

#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq)]
pub struct G53Mod49JoinCount {
    pub mod7_roots: u32,
    pub trivially_saturated_roots: u32,
    pub explicitly_joined_roots: u32,
    pub surviving_roots: u32,
}

#[derive(Clone, Debug, Error, PartialEq, Eq)]
pub enum G53Mod49Error {
    #[error("semantic mismatch")]
    SemanticMismatch,
    #[error(transparent)]
    Mod7(#[from] G53Mod7Error),
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

fn compile_signatures(mask: u16, row_target: u16) -> Result<SignatureSet, G53Mod49Error> {
    let e = symmetric_binary_word(mask);
    let binary_weight = e.iter().copied().map(u16::from).sum::<u16>();
    let residual = row_target
        .checked_sub(binary_weight)
        .ok_or(G53Mod49Error::SemanticMismatch)?;
    if residual % 7 != 0 {
        return Err(G53Mod49Error::SemanticMismatch);
    }
    let k_weight = residual / 7;
    let base_paf: [u16; SHIFTS] = std::array::from_fn(|shift| autocorrelation(&e, shift));
    let mut signatures = [0_u64; SIGNATURE_WORDS];
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
            for shift in 0..SHIFTS {
                let difference =
                    i32::from(autocorrelation(&word, shift)) - i32::from(base_paf[shift]);
                if difference.rem_euclid(7) != 0 {
                    return Err(G53Mod49Error::SemanticMismatch);
                }
                signature += difference.div_euclid(7).rem_euclid(7) as usize * place;
                place *= 7;
            }
            signatures[signature >> 6] |= 1_u64 << (signature & 63);
        }
    }
    Ok(signatures)
}

fn cardinality(set: &SignatureSet) -> u16 {
    set.iter().map(|word| word.count_ones() as u16).sum()
}

fn set_contains(set: &SignatureSet, code: usize) -> bool {
    set[code >> 6] & (1_u64 << (code & 63)) != 0
}

fn full_set() -> SignatureSet {
    let mut set = [u64::MAX; SIGNATURE_WORDS];
    set[SIGNATURE_WORDS - 1] = (1_u64 << (SIGNATURES & 63)) - 1;
    set
}

fn add_codes(mut left: usize, mut right: usize) -> usize {
    let mut output = 0_usize;
    let mut place = 1_usize;
    for _ in 0..SHIFTS {
        output += ((left % 7 + right % 7) % 7) * place;
        left /= 7;
        right /= 7;
        place *= 7;
    }
    output
}

fn sumset(left: &SignatureSet, right: &SignatureSet) -> SignatureSet {
    if cardinality(left) as usize == SIGNATURES || cardinality(right) as usize == SIGNATURES {
        return full_set();
    }
    let mut output = [0_u64; SIGNATURE_WORDS];
    for first in 0..SIGNATURES {
        if !set_contains(left, first) {
            continue;
        }
        for second in 0..SIGNATURES {
            if set_contains(right, second) {
                let code = add_codes(first, second);
                output[code >> 6] |= 1_u64 << (code & 63);
            }
        }
    }
    output
}

pub fn count_g53_mod49_joined_roots() -> Result<G53Mod49JoinCount, G53Mod49Error> {
    let assignments = compile_g53_mod7_assignments()?;
    let mut special_compiled = [false; 1 << SLOTS];
    let mut zero_compiled = [false; 1 << SLOTS];
    let mut special = [[0_u64; SIGNATURE_WORDS]; 1 << SLOTS];
    let mut zero = [[0_u64; SIGNATURE_WORDS]; 1 << SLOTS];
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
    let mut trivially_saturated = 0_u32;
    let mut explicitly_joined = 0_u32;
    let mut surviving = 0_u32;
    for assignment in assignments.iter() {
        let sets = [
            &special[usize::from(assignment[0])],
            &zero[usize::from(assignment[1])],
            &zero[usize::from(assignment[2])],
            &zero[usize::from(assignment[3])],
        ];
        if sets
            .iter()
            .any(|set| cardinality(set) as usize == SIGNATURES)
        {
            trivially_saturated += 1;
            surviving += 1;
            continue;
        }
        explicitly_joined += 1;
        let left = sumset(sets[0], sets[1]);
        let right = sumset(sets[2], sets[3]);
        let reachable = sumset(&left, &right);
        let mut base_total = [0_i32; SHIFTS];
        for &mask in assignment {
            let e = symmetric_binary_word(mask);
            for shift in 0..SHIFTS {
                base_total[shift] += i32::from(autocorrelation(&e, shift));
            }
        }
        let mut target = 0_usize;
        let mut place = 1_usize;
        for shift in 0..SHIFTS {
            let difference = TARGETS[shift] - base_total[shift];
            if difference.rem_euclid(7) != 0 {
                return Err(G53Mod49Error::SemanticMismatch);
            }
            target += difference.div_euclid(7).rem_euclid(7) as usize * place;
            place *= 7;
        }
        surviving += u32::from(set_contains(&reachable, target));
    }
    Ok(G53Mod49JoinCount {
        mod7_roots: assignments.len() as u32,
        trivially_saturated_roots: trivially_saturated,
        explicitly_joined_roots: explicitly_joined,
        surviving_roots: surviving,
    })
}

pub fn compile_g53_mod49_saturation() -> Result<G53Mod49Saturation, G53Mod49Error> {
    let assignments = compile_g53_mod7_assignments()?;
    let mut special_used = [false; 1 << SLOTS];
    let mut zero_used = [false; 1 << SLOTS];
    for assignment in assignments.iter() {
        special_used[usize::from(assignment[0])] = true;
        for &mask in &assignment[1..] {
            zero_used[usize::from(mask)] = true;
        }
    }
    let mut output = G53Mod49Saturation {
        special_masks: 0,
        zero_masks: 0,
        full_special_masks: 0,
        full_zero_masks: 0,
        minimum_special_signatures: SIGNATURES as u16,
        minimum_zero_signatures: SIGNATURES as u16,
    };
    for (special, used, row_target) in
        [(true, &special_used, 260_u16), (false, &zero_used, 261_u16)]
    {
        for (mask, &present) in used.iter().enumerate() {
            if !present {
                continue;
            }
            let count = cardinality(&compile_signatures(mask as u16, row_target)?);
            if special {
                output.special_masks += 1;
                output.minimum_special_signatures = output.minimum_special_signatures.min(count);
                output.full_special_masks += u16::from(count as usize == SIGNATURES);
            } else {
                output.zero_masks += 1;
                output.minimum_zero_signatures = output.minimum_zero_signatures.min(count);
                output.full_zero_masks += u16::from(count as usize == SIGNATURES);
            }
        }
    }
    Ok(output)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn signature_carrier_has_exact_bounded_shape() {
        assert_eq!(SIGNATURES, 2_401);
        assert_eq!(SIGNATURE_WORDS, 38);
        let signatures = compile_signatures(58, 260).unwrap();
        assert!(cardinality(&signatures) > 0);
        assert!(cardinality(&signatures) as usize <= SIGNATURES);
    }
}
