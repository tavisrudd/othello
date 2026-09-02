//! Exact q4 fibres above the private g53 q0--q3 sparse profile equations.
//!
//! This is theorem-mining output: it computes every q4 value attainable after
//! the zero-shift and first three nonzero quotient equations are exact.  The
//! fibre hashes are diagnostic only; all counts and extrema come from the
//! complete bounded profile join.

use std::collections::BTreeMap;

use serde::{Deserialize, Serialize};
use thiserror::Error;

use crate::g53_mod7_reduction::{compile_g53_mod7_assignments, G53Mod7Error};
use crate::g53_sparse_defect::{
    compile_g53_sparse_defect_profiles, G53SparseDefectError, G53SparseDefectProfile,
};

const SLOTS: usize = 10;
const DEFECT_TARGET: u8 = 34;
const PAF_TARGET: u16 = 15_080;
const PAIR_BUDGET: usize = 3_000_000;
const Q4_WORDS: usize = 1 << 10;

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct PrefixPair {
    prefix: [u16; 3],
    q4: u16,
    first: u16,
    second: u16,
    energy: u8,
    reserved: [u8; 3],
}

const _: () = assert!(std::mem::size_of::<PrefixPair>() == 16);

#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq)]
pub struct G53Q4FibreRoot {
    pub masks: [u16; 4],
    pub attainable_q4_values: u16,
    pub minimum_q4: Option<u16>,
    pub maximum_q4: Option<u16>,
    pub nearest_residual: Option<i16>,
    pub exact_prefix_pairings: u64,
    pub fibre_hash: u64,
}

#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq)]
pub struct G53Q4FibreClass {
    pub fibre_hash: u64,
    pub roots: u16,
    pub attainable_q4_values: u16,
    pub minimum_q4: Option<u16>,
    pub maximum_q4: Option<u16>,
    pub nearest_residual: Option<i16>,
    pub q4_values: [u16; 8],
}

#[derive(Clone, Copy, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub struct G53Q4SpecialMaskClass {
    pub special_mask: u16,
    pub roots: u16,
    pub attainable_q4_values: u16,
    pub q4_values: [u16; 8],
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G53Q4FibreReport {
    pub roots: u16,
    pub roots_with_exact_prefix: u16,
    pub roots_with_exact_q4: u16,
    pub fibre_classes: Box<[G53Q4FibreClass]>,
    pub special_mask_classes: Box<[G53Q4SpecialMaskClass]>,
    pub root_reports: Box<[G53Q4FibreRoot]>,
}

#[derive(Clone, Debug, Error, PartialEq, Eq)]
pub enum G53SparsePrefixError {
    #[error("prefix workspace exceeded its explicit bound")]
    StateBudget,
    #[error("prefix arithmetic or semantics failed")]
    SemanticMismatch,
    #[error(transparent)]
    Profiles(#[from] G53SparseDefectError),
    #[error(transparent)]
    Mod7(#[from] G53Mod7Error),
}

fn fibre_hash(bits: &[u64; Q4_WORDS]) -> u64 {
    let mut hash = 0xcbf2_9ce4_8422_2325_u64;
    for &word in bits {
        hash ^= word;
        hash = hash.wrapping_mul(0x100_0000_01b3);
    }
    hash
}

pub fn census_g53_q4_fibres() -> Result<G53Q4FibreReport, G53SparsePrefixError> {
    let assignments = compile_g53_mod7_assignments()?;
    let mut special: [Option<Box<[G53SparseDefectProfile]>>; 1 << SLOTS] =
        std::array::from_fn(|_| None);
    let mut zero: [Option<Box<[G53SparseDefectProfile]>>; 1 << SLOTS] =
        std::array::from_fn(|_| None);
    for assignment in assignments.iter() {
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
    let mut right = Vec::<PrefixPair>::with_capacity(PAIR_BUDGET);
    let mut bits = [0_u64; Q4_WORDS];
    let mut roots = Vec::with_capacity(assignments.len());
    let mut classes = BTreeMap::<u64, (G53Q4FibreClass, Box<[u64]>)>::new();
    let mut roots_with_exact_q4 = 0_u16;
    let mut roots_with_exact_prefix = 0_u16;
    for assignment in assignments.iter() {
        let domains: [&[G53SparseDefectProfile]; 4] = std::array::from_fn(|block| {
            let cache = if block == 0 { &special } else { &zero };
            cache[usize::from(assignment[block])]
                .as_deref()
                .expect("every prefix domain is compiled")
        });
        if domains[2]
            .len()
            .checked_mul(domains[3].len())
            .ok_or(G53SparsePrefixError::StateBudget)?
            > PAIR_BUDGET
        {
            return Err(G53SparsePrefixError::StateBudget);
        }
        right.clear();
        for (third_index, third) in domains[2].iter().enumerate() {
            for (fourth_index, fourth) in domains[3].iter().enumerate() {
                let Some(energy) = third.defect_energy.checked_add(fourth.defect_energy) else {
                    return Err(G53SparsePrefixError::SemanticMismatch);
                };
                if energy > DEFECT_TARGET {
                    continue;
                }
                let mut prefix = [0_u16; 3];
                for shift in 0..3 {
                    prefix[shift] = third.paf[shift]
                        .checked_add(fourth.paf[shift])
                        .ok_or(G53SparsePrefixError::SemanticMismatch)?;
                }
                if prefix.iter().any(|&value| value > PAF_TARGET) {
                    continue;
                }
                right.push(PrefixPair {
                    prefix,
                    q4: third.paf[3]
                        .checked_add(fourth.paf[3])
                        .ok_or(G53SparsePrefixError::SemanticMismatch)?,
                    first: u16::try_from(third_index)
                        .map_err(|_| G53SparsePrefixError::StateBudget)?,
                    second: u16::try_from(fourth_index)
                        .map_err(|_| G53SparsePrefixError::StateBudget)?,
                    energy,
                    reserved: [0; 3],
                });
            }
        }
        right.sort_unstable_by_key(|pair| (pair.energy, pair.prefix));
        bits.fill(0);
        let mut pairings = 0_u64;
        for first in domains[0] {
            for second in domains[1] {
                let Some(left_energy) = first.defect_energy.checked_add(second.defect_energy)
                else {
                    return Err(G53SparsePrefixError::SemanticMismatch);
                };
                let Some(energy) = DEFECT_TARGET.checked_sub(left_energy) else {
                    continue;
                };
                let mut prefix = [0_u16; 3];
                let mut possible = true;
                for shift in 0..3 {
                    let left = u32::from(first.paf[shift]) + u32::from(second.paf[shift]);
                    let Some(required) = u32::from(PAF_TARGET).checked_sub(left) else {
                        possible = false;
                        break;
                    };
                    prefix[shift] = u16::try_from(required)
                        .map_err(|_| G53SparsePrefixError::SemanticMismatch)?;
                }
                if !possible {
                    continue;
                }
                let key = (energy, prefix);
                let begin = right.partition_point(|pair| (pair.energy, pair.prefix) < key);
                let end = right.partition_point(|pair| (pair.energy, pair.prefix) <= key);
                for pair in &right[begin..end] {
                    pairings += 1;
                    let q4 =
                        u32::from(first.paf[3]) + u32::from(second.paf[3]) + u32::from(pair.q4);
                    if q4 >= (Q4_WORDS * 64) as u32 {
                        return Err(G53SparsePrefixError::StateBudget);
                    }
                    bits[q4 as usize / 64] |= 1_u64 << (q4 % 64);
                }
            }
        }
        let attainable = bits.iter().map(|word| word.count_ones()).sum::<u32>();
        if attainable > u32::from(u16::MAX) {
            return Err(G53SparsePrefixError::SemanticMismatch);
        }
        if attainable != 0 {
            roots_with_exact_prefix += 1;
        }
        let minimum = bits
            .iter()
            .enumerate()
            .find(|(_, word)| **word != 0)
            .map(|(word, bits)| word * 64 + bits.trailing_zeros() as usize)
            .map(|value| value as u16);
        let maximum = bits
            .iter()
            .enumerate()
            .rev()
            .find(|(_, word)| **word != 0)
            .map(|(word, bits)| word * 64 + (63 - bits.leading_zeros() as usize))
            .map(|value| value as u16);
        let mut nearest_residual = None::<i32>;
        let mut q4_values = [0_u16; 8];
        let mut q4_value_count = 0_usize;
        for (word_index, &word) in bits.iter().enumerate() {
            let mut remaining = word;
            while remaining != 0 {
                let bit = remaining.trailing_zeros() as usize;
                remaining &= remaining - 1;
                let value = (word_index * 64 + bit) as i32;
                if q4_value_count == q4_values.len() {
                    return Err(G53SparsePrefixError::StateBudget);
                }
                q4_values[q4_value_count] = value as u16;
                q4_value_count += 1;
                let residual = value - i32::from(PAF_TARGET);
                if nearest_residual.is_none_or(|nearest| residual.abs() < nearest.abs()) {
                    nearest_residual = Some(residual);
                }
            }
        }
        if bits[usize::from(PAF_TARGET) / 64] & (1_u64 << (PAF_TARGET % 64)) != 0 {
            roots_with_exact_q4 += 1;
        }
        let hash = fibre_hash(&bits);
        let root = G53Q4FibreRoot {
            masks: *assignment,
            attainable_q4_values: attainable as u16,
            minimum_q4: minimum,
            maximum_q4: maximum,
            nearest_residual: nearest_residual
                .map(i16::try_from)
                .transpose()
                .map_err(|_| G53SparsePrefixError::SemanticMismatch)?,
            exact_prefix_pairings: pairings,
            fibre_hash: hash,
        };
        if let Some((class, canonical_bits)) = classes.get_mut(&hash) {
            if canonical_bits.as_ref() != bits {
                return Err(G53SparsePrefixError::SemanticMismatch);
            }
            class.roots += 1;
        } else {
            classes.insert(
                hash,
                (
                    G53Q4FibreClass {
                        fibre_hash: hash,
                        roots: 1,
                        attainable_q4_values: root.attainable_q4_values,
                        minimum_q4: root.minimum_q4,
                        maximum_q4: root.maximum_q4,
                        nearest_residual: root.nearest_residual,
                        q4_values,
                    },
                    bits.to_vec().into_boxed_slice(),
                ),
            );
        }
        roots.push(root);
    }
    let class_by_hash = classes
        .iter()
        .map(|(&hash, (class, _))| (hash, *class))
        .collect::<BTreeMap<_, _>>();
    let mut special = BTreeMap::<u16, (u64, u16)>::new();
    for root in &roots {
        let entry = special.entry(root.masks[0]).or_insert((root.fibre_hash, 0));
        if entry.0 != root.fibre_hash {
            return Err(G53SparsePrefixError::SemanticMismatch);
        }
        entry.1 += 1;
    }
    let special_mask_classes = special
        .into_iter()
        .map(|(special_mask, (hash, root_count))| {
            let class = class_by_hash
                .get(&hash)
                .ok_or(G53SparsePrefixError::SemanticMismatch)?;
            Ok(G53Q4SpecialMaskClass {
                special_mask,
                roots: root_count,
                attainable_q4_values: class.attainable_q4_values,
                q4_values: class.q4_values,
            })
        })
        .collect::<Result<Vec<_>, G53SparsePrefixError>>()?
        .into_boxed_slice();
    Ok(G53Q4FibreReport {
        roots: roots.len() as u16,
        roots_with_exact_prefix,
        roots_with_exact_q4,
        fibre_classes: classes
            .into_values()
            .map(|(class, _)| class)
            .collect::<Vec<_>>()
            .into_boxed_slice(),
        special_mask_classes,
        root_reports: roots.into_boxed_slice(),
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn fibre_hash_distinguishes_single_bit_mutation() {
        let zero = [0_u64; Q4_WORDS];
        let mut one = zero;
        one[7] = 1 << 3;
        assert_ne!(fibre_hash(&zero), fibre_hash(&one));
    }
}
