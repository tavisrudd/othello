//! Structural mod-14 refinement of the g53 mod-seven quotient roots.
//!
//! With `B=e+7k`, reducing modulo 14 retains only the parity of `k`.  The
//! symmetric row equation fixes the endpoint parity, and four autocorrelation
//! residues become a four-bit affine signature.  This module exhausts that
//! 1,024-state parity lift and combines blocks by XOR; it stores no large
//! certificate and claims only a necessary reduction.

use serde::Serialize;
use thiserror::Error;

use crate::g53_mod7_reduction::{compile_g53_mod7_assignments, G53Mod7Error};

const ORDER: usize = 18;
const SLOTS: usize = 10;
const SHIFTS: usize = 4;
const TARGETS: [i32; SHIFTS] = [15_603, 15_080, 15_080, 15_080];

#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq)]
pub struct G53Mod14PrefixCount {
    pub active_shifts: u8,
    pub mod7_roots: u32,
    pub surviving_roots: u32,
}

#[derive(Clone, Debug, Error, PartialEq, Eq)]
pub enum G53Mod14Error {
    #[error("invalid prefix")]
    InvalidPrefix,
    #[error("semantic mismatch")]
    SemanticMismatch,
    #[error(transparent)]
    Mod7(#[from] G53Mod7Error),
}

fn symmetric_word(mask: u16, scale: u8) -> [u8; ORDER] {
    let mut word = [0_u8; ORDER];
    word[0] = ((mask & 1) as u8) * scale;
    word[9] = (((mask >> 9) & 1) as u8) * scale;
    for slot in 1..9 {
        let value = (((mask >> slot) & 1) as u8) * scale;
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

fn toggle_signatures(mask: u16, row_target: u16, active: usize) -> u16 {
    let e = symmetric_word(mask, 1);
    let binary_weight = e.iter().copied().map(u16::from).sum::<u16>();
    let k_weight = (row_target - binary_weight) / 7;
    let endpoint_parity = (k_weight & 1) as u16;
    let mut signatures = 0_u16;
    for parity_mask in 0_u16..1 << SLOTS {
        if ((parity_mask & 1) ^ ((parity_mask >> 9) & 1)) != endpoint_parity {
            continue;
        }
        let parity = symmetric_word(parity_mask, 1);
        let mut word = [0_u8; ORDER];
        for position in 0..ORDER {
            word[position] = e[position] + 7 * parity[position];
        }
        let mut signature = 0_u8;
        for shift in 0..active {
            let base = autocorrelation(&e, shift);
            let lifted = autocorrelation(&word, shift);
            let difference = lifted.wrapping_sub(base) % 14;
            debug_assert_eq!(difference % 7, 0);
            signature |= ((difference / 7) as u8) << shift;
        }
        signatures |= 1_u16 << signature;
    }
    signatures
}

fn xor_closure(left: u16, right: u16, active: usize) -> u16 {
    let limit = 1_usize << active;
    let mut output = 0_u16;
    for first in 0..limit {
        if left & (1_u16 << first) == 0 {
            continue;
        }
        for second in 0..limit {
            if right & (1_u16 << second) != 0 {
                output |= 1_u16 << (first ^ second);
            }
        }
    }
    output
}

pub fn count_g53_mod14_prefix(active: u8) -> Result<G53Mod14PrefixCount, G53Mod14Error> {
    let active = usize::from(active);
    if active == 0 || active > SHIFTS {
        return Err(G53Mod14Error::InvalidPrefix);
    }
    let assignments = compile_g53_mod7_assignments()?;
    let mut surviving = 0_u32;
    for assignment in assignments.iter() {
        let mut base_total = [0_i32; SHIFTS];
        let mut reachable = 1_u16;
        for (block, &mask) in assignment.iter().enumerate() {
            let e = symmetric_word(mask, 1);
            for shift in 0..active {
                base_total[shift] += i32::from(autocorrelation(&e, shift));
            }
            let block_signatures =
                toggle_signatures(mask, if block == 0 { 260 } else { 261 }, active);
            reachable = xor_closure(reachable, block_signatures, active);
        }
        let mut target_signature = 0_u8;
        for shift in 0..active {
            let difference = TARGETS[shift] - base_total[shift];
            if difference.rem_euclid(7) != 0 {
                return Err(G53Mod14Error::SemanticMismatch);
            }
            target_signature |= ((difference.div_euclid(7).rem_euclid(2)) as u8) << shift;
        }
        if reachable & (1_u16 << target_signature) != 0 {
            surviving += 1;
        }
    }
    Ok(G53Mod14PrefixCount {
        active_shifts: active as u8,
        mod7_roots: assignments.len() as u32,
        surviving_roots: surviving,
    })
}

pub fn compile_g53_mod14_prefix_counts() -> Result<[G53Mod14PrefixCount; SHIFTS], G53Mod14Error> {
    Ok(std::array::from_fn(|index| {
        count_g53_mod14_prefix((index + 1) as u8).expect("fixed valid prefixes")
    }))
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn odd_shift_parity_is_even_for_every_symmetric_binary_word() {
        for mask in 0_u16..1 << SLOTS {
            let word = symmetric_word(mask, 1);
            assert_eq!(autocorrelation(&word, 1) & 1, 0);
            assert_eq!(autocorrelation(&word, 3) & 1, 0);
        }
    }

    #[test]
    fn even_shift_parity_matches_the_two_reflection_fixed_points() {
        for mask in 0_u16..1 << SLOTS {
            let word = symmetric_word(mask, 1);
            assert_eq!(autocorrelation(&word, 2) & 1, u16::from(word[1] ^ word[8]));
        }
    }

    #[test]
    fn invalid_prefixes_fail_closed() {
        assert_eq!(
            count_g53_mod14_prefix(0).unwrap_err(),
            G53Mod14Error::InvalidPrefix
        );
        assert_eq!(
            count_g53_mod14_prefix(5).unwrap_err(),
            G53Mod14Error::InvalidPrefix
        );
    }
}
