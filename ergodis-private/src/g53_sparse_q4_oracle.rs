//! Independent oracle for the private g53 sparse q0--q4 census.
//!
//! This intentionally does not use the theorem-driven DFS or its sorted pair
//! join.  It scans every base-five block word, filters by direct row and q0
//! energy arithmetic, canonicalizes with a `BTreeSet`, and joins roots with a
//! presized `HashSet`.  Agreement can therefore authorize the exact negative
//! census without treating the optimized compiler as its own oracle.

use std::collections::{BTreeSet, HashSet};

use ergodis::root_execution::{reduce_roots, RootKernel, RootOrdinal};
use serde::Serialize;
use thiserror::Error;

use crate::g53_mod7_reduction::{compile_g53_mod7_assignments, G53Mod7Error};
use crate::g53_sparse_defect::compile_g53_sparse_defect_profiles;

const ORDER: usize = 18;
const SLOTS: usize = 10;
const ACTIVE: usize = 4;
const BASE_FIVE_WORDS: u32 = 9_765_625;
const DEFECT_TARGET: u8 = 34;
const HASH_BUDGET: usize = 131_072;

#[derive(Clone, Copy, Debug, Hash, PartialEq, Eq, PartialOrd, Ord)]
struct OracleKey {
    energy: u8,
    paf: [u16; ACTIVE],
}

#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq)]
pub struct G53SparseQ4OracleReport {
    pub threads: u16,
    pub roots: u32,
    pub hits: u32,
    pub misses: u32,
    pub right_keys: u64,
    pub left_probes: u64,
}

#[derive(Clone, Debug, Error, PartialEq, Eq)]
pub enum G53SparseQ4OracleError {
    #[error("oracle block profile disagrees with the optimized compiler")]
    ProfileMismatch,
    #[error("oracle hash workspace exceeded its explicit budget")]
    HashBudget,
    #[error("oracle arithmetic failed")]
    Arithmetic,
    #[error("parallel root executor rejected the oracle campaign")]
    ParallelExecution,
    #[error(transparent)]
    Mod7(#[from] G53Mod7Error),
}

fn direct_profile_set(
    mask: u16,
    row_target: u16,
) -> Result<Box<[OracleKey]>, G53SparseQ4OracleError> {
    let mut profiles = BTreeSet::new();
    let mut word = [0_u16; ORDER];
    for packed in 0..BASE_FIVE_WORDS {
        let mut code = packed;
        let mut row = 0_u16;
        let mut excess = 0_i32;
        for slot in 0..SLOTS {
            let digit = (code % 5) as u16;
            code /= 5;
            let base = (mask >> slot) & 1;
            let value = base + 7 * digit;
            let multiplicity = if slot == 0 || slot == 9 { 1 } else { 2 };
            row += multiplicity * value;
            let signed = 2 * i32::from(value) - 29;
            excess += i32::from(multiplicity) * (signed * signed - 1);
            word[slot] = value;
            if slot != 0 && slot != 9 {
                word[ORDER - slot] = value;
            }
        }
        if row != row_target || excess < 0 || excess % 56 != 0 {
            continue;
        }
        let energy = excess / 56;
        if energy > i32::from(DEFECT_TARGET) {
            continue;
        }
        let energy = energy as u8;
        let paf = std::array::from_fn(|offset| {
            let shift = offset + 1;
            let total = (0..ORDER)
                .map(|position| u32::from(word[position] * word[(position + shift) % ORDER]))
                .sum::<u32>();
            u16::try_from(total).expect("g53 quotient PAF fits u16")
        });
        profiles.insert(OracleKey { energy, paf });
    }
    Ok(profiles.into_iter().collect::<Vec<_>>().into_boxed_slice())
}

struct OracleKernel {
    special: [Option<Box<[OracleKey]>>; 1 << SLOTS],
    zero: [Option<Box<[OracleKey]>>; 1 << SLOTS],
}

struct OracleWorker {
    right: HashSet<OracleKey>,
}

impl OracleKernel {
    fn compile(assignments: &[[u16; 4]]) -> Result<Self, G53SparseQ4OracleError> {
        let mut special = std::array::from_fn(|_| None);
        let mut zero = std::array::from_fn(|_| None);
        for assignment in assignments {
            for (block, &mask) in assignment.iter().enumerate() {
                let cache = if block == 0 { &mut special } else { &mut zero };
                if cache[usize::from(mask)].is_none() {
                    let row_target = if block == 0 { 260 } else { 261 };
                    let oracle = direct_profile_set(mask, row_target)?;
                    let optimized = compile_g53_sparse_defect_profiles(mask, row_target)
                        .map_err(|_| G53SparseQ4OracleError::ProfileMismatch)?;
                    let optimized_keys = optimized
                        .iter()
                        .map(|profile| OracleKey {
                            energy: profile.defect_energy,
                            paf: profile.paf,
                        })
                        .collect::<BTreeSet<_>>();
                    if oracle.as_ref() != optimized_keys.iter().copied().collect::<Vec<_>>() {
                        return Err(G53SparseQ4OracleError::ProfileMismatch);
                    }
                    cache[usize::from(mask)] = Some(oracle);
                }
            }
        }
        Ok(Self { special, zero })
    }
}

impl RootKernel for OracleKernel {
    type Root = [u16; 4];
    type Worker = OracleWorker;
    type Output = Result<G53SparseQ4OracleReport, G53SparseQ4OracleError>;

    fn create_worker(&self) -> Self::Worker {
        OracleWorker {
            right: HashSet::with_capacity(HASH_BUDGET),
        }
    }

    fn evaluate(
        &self,
        worker: &mut Self::Worker,
        _ordinal: RootOrdinal,
        assignment: &Self::Root,
    ) -> Self::Output {
        let domains: [&[OracleKey]; 4] = std::array::from_fn(|block| {
            let cache = if block == 0 {
                &self.special
            } else {
                &self.zero
            };
            cache[usize::from(assignment[block])]
                .as_deref()
                .expect("oracle compiled every root mask")
        });
        worker.right.clear();
        for third in domains[2] {
            for fourth in domains[3] {
                let Some(energy) = third.energy.checked_add(fourth.energy) else {
                    return Err(G53SparseQ4OracleError::Arithmetic);
                };
                if energy > DEFECT_TARGET {
                    continue;
                }
                let mut paf = [0_u16; ACTIVE];
                for shift in 0..ACTIVE {
                    paf[shift] = third.paf[shift]
                        .checked_add(fourth.paf[shift])
                        .ok_or(G53SparseQ4OracleError::Arithmetic)?;
                }
                if paf.iter().any(|&value| value > 15_080) {
                    continue;
                }
                if worker.right.len() == HASH_BUDGET {
                    return Err(G53SparseQ4OracleError::HashBudget);
                }
                worker.right.insert(OracleKey { energy, paf });
            }
        }
        let right_keys = worker.right.len() as u64;
        let mut probes = 0_u64;
        let mut hit = false;
        'left: for first in domains[0] {
            for second in domains[1] {
                probes += 1;
                let Some(left_energy) = first.energy.checked_add(second.energy) else {
                    return Err(G53SparseQ4OracleError::Arithmetic);
                };
                let Some(energy) = DEFECT_TARGET.checked_sub(left_energy) else {
                    continue;
                };
                let mut paf = [0_u16; ACTIVE];
                let mut possible = true;
                for shift in 0..ACTIVE {
                    let left = u32::from(first.paf[shift]) + u32::from(second.paf[shift]);
                    let Some(required) = 15_080_u32.checked_sub(left) else {
                        possible = false;
                        break;
                    };
                    paf[shift] =
                        u16::try_from(required).map_err(|_| G53SparseQ4OracleError::Arithmetic)?;
                }
                if possible && worker.right.contains(&OracleKey { energy, paf }) {
                    hit = true;
                    break 'left;
                }
            }
        }
        Ok(G53SparseQ4OracleReport {
            threads: 0,
            roots: 1,
            hits: u32::from(hit),
            misses: u32::from(!hit),
            right_keys,
            left_probes: probes,
        })
    }
}

fn merge(
    left: Result<G53SparseQ4OracleReport, G53SparseQ4OracleError>,
    right: Result<G53SparseQ4OracleReport, G53SparseQ4OracleError>,
) -> Result<G53SparseQ4OracleReport, G53SparseQ4OracleError> {
    let mut left = left?;
    let right = right?;
    left.roots += right.roots;
    left.hits += right.hits;
    left.misses += right.misses;
    left.right_keys += right.right_keys;
    left.left_probes += right.left_probes;
    Ok(left)
}

pub fn verify_g53_sparse_q4_census(
    threads: usize,
) -> Result<G53SparseQ4OracleReport, G53SparseQ4OracleError> {
    let assignments = compile_g53_mod7_assignments()?;
    let kernel = OracleKernel::compile(&assignments)?;
    let mut report = reduce_roots(
        &kernel,
        &assignments,
        threads,
        || {
            Ok(G53SparseQ4OracleReport {
                threads: 0,
                roots: 0,
                hits: 0,
                misses: 0,
                right_keys: 0,
                left_probes: 0,
            })
        },
        merge,
    )
    .map_err(|_| G53SparseQ4OracleError::ParallelExecution)??;
    report.threads =
        u16::try_from(threads).map_err(|_| G53SparseQ4OracleError::ParallelExecution)?;
    Ok(report)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn exhaustive_block_oracle_matches_sparse_compiler() {
        let oracle = direct_profile_set(58, 260).unwrap();
        let optimized = compile_g53_sparse_defect_profiles(58, 260).unwrap();
        let optimized = optimized
            .iter()
            .map(|profile| OracleKey {
                energy: profile.defect_energy,
                paf: profile.paf,
            })
            .collect::<BTreeSet<_>>();
        assert_eq!(
            oracle.as_ref(),
            optimized.iter().copied().collect::<Vec<_>>()
        );
    }
}
