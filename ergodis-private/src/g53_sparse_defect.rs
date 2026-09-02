//! Sparse exact-q0 profile compiler for the private g53 search.
//!
//! The proved zero-shift defect equation has total defect energy 34.  This
//! compiler uses that theorem as a coordinate change: each reciprocal slot is
//! stored as a displacement from the `k=2` background and branches only while
//! its exact energy can still fit the global budget.  It is iterative,
//! explicitly bounded, and retains one direct-replay witness per profile.

use serde::Serialize;
use thiserror::Error;

use crate::g53_mod7_reduction::{compile_g53_mod7_assignments, G53Mod7Error};
use ergodis::root_execution::{reduce_roots, RootKernel, RootOrdinal};

const ORDER: usize = 18;
const SLOTS: usize = 10;
const ACTIVE_NONZERO_SHIFTS: usize = 4;
const DEFECT_ENERGY_TARGET: u8 = 34;
const PROFILE_BUDGET: usize = 2_000_000;
const PAIR_BUDGET: usize = 3_000_000;
const CHOICES: [i8; 5] = [-2, -1, 0, 1, 2];
const MULTIPLICITIES: [i16; SLOTS] = [1, 2, 2, 2, 2, 2, 2, 2, 2, 1];
const POWERS: [u32; SLOTS] = [
    1, 5, 25, 125, 625, 3_125, 15_625, 78_125, 390_625, 1_953_125,
];

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct G53SparseDefectProfile {
    pub paf: [u16; ACTIVE_NONZERO_SHIFTS],
    pub digits: u32,
    pub defect_energy: u8,
    pub defect_entries: u8,
    reserved: [u8; 2],
}

const _: () = assert!(std::mem::size_of::<G53SparseDefectProfile>() == 16);

#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq)]
pub struct G53SparseDefectCount {
    pub mask: u16,
    pub row_target: u16,
    pub distinct_profiles: u32,
    pub maximum_independent_defects: u8,
}

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct PairProfile {
    paf: [u16; ACTIVE_NONZERO_SHIFTS],
    first: u16,
    second: u16,
    defect_energy: u8,
    reserved: [u8; 3],
}

const _: () = assert!(std::mem::size_of::<PairProfile>() == 16);

#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq)]
pub struct G53SparseQ4Witness {
    pub masks: [u16; 4],
    pub digits: [u32; 4],
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G53SparseQ4Report {
    pub threads: u16,
    pub roots_examined: u32,
    pub constructive_hits: u32,
    pub exhaustive_misses: u32,
    pub right_pair_states: u64,
    pub left_pair_probes: u64,
    pub first_witness_root: Option<u32>,
    pub first_witness: Option<G53SparseQ4Witness>,
}

#[derive(Clone, Debug, Error, PartialEq, Eq)]
pub enum G53SparseDefectError {
    #[error("invalid affine row constraint")]
    InvalidRow,
    #[error("sparse profile budget exceeded")]
    ProfileBudget,
    #[error("defect arithmetic or direct replay failed")]
    SemanticMismatch,
    #[error(transparent)]
    Mod7(#[from] G53Mod7Error),
    #[error("parallel root executor rejected the bounded campaign")]
    ParallelExecution,
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

fn paf(word: &[u16; ORDER], shift: usize) -> u16 {
    let total = (0..ORDER)
        .map(|position| u32::from(word[position] * word[(position + shift) % ORDER]))
        .sum::<u32>();
    u16::try_from(total).expect("g53 quotient PAF fits u16")
}

fn defect_energy(base: u16, digit: u16, multiplicity: i16) -> Option<u8> {
    let coefficient = i32::from(base + 7 * digit);
    let signed = 2 * coefficient - 29;
    let excess = signed.checked_mul(signed)?.checked_sub(1)?;
    if excess < 0 || excess % 56 != 0 {
        return None;
    }
    u8::try_from((excess / 56) * i32::from(multiplicity)).ok()
}

fn decode_word(mask: u16, digits: u32) -> [u16; ORDER] {
    let base = binary_word(mask);
    let mut code = digits;
    let mut word = [0_u16; ORDER];
    for slot in 0..SLOTS {
        let digit = (code % 5) as u16;
        code /= 5;
        let value = base[slot] + 7 * digit;
        word[slot] = value;
        if slot != 0 && slot != 9 {
            word[ORDER - slot] = value;
        }
    }
    word
}

pub fn compile_g53_sparse_defect_profiles(
    mask: u16,
    row_target: u16,
) -> Result<Box<[G53SparseDefectProfile]>, G53SparseDefectError> {
    if mask >= 1 << SLOTS {
        return Err(G53SparseDefectError::InvalidRow);
    }
    let base = binary_word(mask);
    let binary_weight = base.iter().copied().sum::<u16>();
    let baseline = 252_u16
        .checked_add(binary_weight)
        .ok_or(G53SparseDefectError::InvalidRow)?;
    let row_difference = i32::from(row_target) - i32::from(baseline);
    if row_difference % 7 != 0 {
        return Err(G53SparseDefectError::InvalidRow);
    }
    let target_displacement =
        i16::try_from(row_difference / 7).map_err(|_| G53SparseDefectError::InvalidRow)?;

    let mut remaining_weight = [0_i16; SLOTS + 1];
    for slot in (0..SLOTS).rev() {
        remaining_weight[slot] = remaining_weight[slot + 1] + MULTIPLICITIES[slot];
    }
    let mut next_choice = [0_u8; SLOTS];
    let mut digits = [2_u8; SLOTS];
    let mut row_prefix = [0_i16; SLOTS + 1];
    let mut energy_prefix = [0_u8; SLOTS + 1];
    let mut entries_prefix = [0_u8; SLOTS + 1];
    let mut depth = 0_usize;
    let mut profiles = Vec::with_capacity(65_536);
    let mut raw = 0_u32;

    loop {
        if depth == SLOTS {
            if row_prefix[depth] == target_displacement {
                if profiles.len() == PROFILE_BUDGET {
                    return Err(G53SparseDefectError::ProfileBudget);
                }
                raw = raw
                    .checked_add(1)
                    .ok_or(G53SparseDefectError::SemanticMismatch)?;
                let packed = digits
                    .iter()
                    .enumerate()
                    .map(|(slot, &digit)| u32::from(digit) * POWERS[slot])
                    .sum::<u32>();
                let word = decode_word(mask, packed);
                if word.iter().copied().sum::<u16>() != row_target {
                    return Err(G53SparseDefectError::SemanticMismatch);
                }
                profiles.push(G53SparseDefectProfile {
                    paf: std::array::from_fn(|offset| paf(&word, offset + 1)),
                    digits: packed,
                    defect_energy: energy_prefix[depth],
                    defect_entries: entries_prefix[depth],
                    reserved: [0; 2],
                });
            }
            depth -= 1;
            continue;
        }
        if usize::from(next_choice[depth]) == CHOICES.len() {
            next_choice[depth] = 0;
            if depth == 0 {
                break;
            }
            depth -= 1;
            continue;
        }
        let displacement = CHOICES[usize::from(next_choice[depth])];
        next_choice[depth] += 1;
        let digit = u16::try_from(i16::from(displacement) + 2)
            .map_err(|_| G53SparseDefectError::SemanticMismatch)?;
        let energy = defect_energy(base[depth], digit, MULTIPLICITIES[depth])
            .ok_or(G53SparseDefectError::SemanticMismatch)?;
        let next_energy = energy_prefix[depth]
            .checked_add(energy)
            .ok_or(G53SparseDefectError::SemanticMismatch)?;
        if next_energy > DEFECT_ENERGY_TARGET {
            continue;
        }
        let next_row = row_prefix[depth] + i16::from(displacement) * MULTIPLICITIES[depth];
        let remaining = remaining_weight[depth + 1];
        if target_displacement < next_row - 2 * remaining
            || target_displacement > next_row + 2 * remaining
        {
            continue;
        }
        digits[depth] = digit as u8;
        row_prefix[depth + 1] = next_row;
        energy_prefix[depth + 1] = next_energy;
        entries_prefix[depth + 1] = entries_prefix[depth]
            .checked_add(if displacement == 0 {
                0
            } else {
                MULTIPLICITIES[depth] as u8
            })
            .ok_or(G53SparseDefectError::SemanticMismatch)?;
        depth += 1;
    }

    profiles.sort_unstable_by_key(|profile| (profile.defect_energy, profile.paf));
    profiles.dedup_by_key(|profile| (profile.defect_energy, profile.paf));
    profiles.shrink_to_fit();
    debug_assert!(raw >= profiles.len() as u32);
    Ok(profiles.into_boxed_slice())
}

pub fn census_g53_sparse_defect_profiles(
    masks: &[(u16, u16)],
) -> Result<Box<[G53SparseDefectCount]>, G53SparseDefectError> {
    let mut output = Vec::with_capacity(masks.len());
    for &(mask, row_target) in masks {
        let profiles = compile_g53_sparse_defect_profiles(mask, row_target)?;
        let maximum_independent_defects = profiles
            .iter()
            .map(|profile| profile.defect_entries)
            .max()
            .unwrap_or(0);
        output.push(G53SparseDefectCount {
            mask,
            row_target,
            distinct_profiles: profiles.len() as u32,
            maximum_independent_defects,
        });
    }
    Ok(output.into_boxed_slice())
}

fn replay_sparse_q4_witness(witness: G53SparseQ4Witness) -> Result<(), G53SparseDefectError> {
    let row_targets = [260_u16, 261, 261, 261];
    let words: [[u16; ORDER]; 4] =
        std::array::from_fn(|block| decode_word(witness.masks[block], witness.digits[block]));
    for block in 0..4 {
        if words[block].iter().copied().sum::<u16>() != row_targets[block] {
            return Err(G53SparseDefectError::SemanticMismatch);
        }
    }
    let targets = [15_603_u32, 15_080, 15_080, 15_080, 15_080];
    for shift in 0..=ACTIVE_NONZERO_SHIFTS {
        let total = words
            .iter()
            .map(|word| u32::from(paf(word, shift)))
            .sum::<u32>();
        if total != targets[shift] {
            return Err(G53SparseDefectError::SemanticMismatch);
        }
    }
    Ok(())
}

struct SparseQ4Kernel {
    special: [Option<Box<[G53SparseDefectProfile]>>; 1 << SLOTS],
    zero: [Option<Box<[G53SparseDefectProfile]>>; 1 << SLOTS],
}

struct SparseQ4Worker {
    right_pairs: Vec<PairProfile>,
}

impl SparseQ4Kernel {
    fn compile(assignments: &[[u16; 4]]) -> Result<Self, G53SparseDefectError> {
        let mut special = std::array::from_fn(|_| None);
        let mut zero = std::array::from_fn(|_| None);
        for assignment in assignments {
            for (block, &mask) in assignment.iter().enumerate() {
                let cache = if block == 0 { &mut special } else { &mut zero };
                if cache[usize::from(mask)].is_none() {
                    let profiles = compile_g53_sparse_defect_profiles(
                        mask,
                        if block == 0 { 260 } else { 261 },
                    )?;
                    if profiles.len() > usize::from(u16::MAX) {
                        return Err(G53SparseDefectError::ProfileBudget);
                    }
                    cache[usize::from(mask)] = Some(profiles);
                }
            }
        }
        Ok(Self { special, zero })
    }

    fn evaluate_root(
        &self,
        worker: &mut SparseQ4Worker,
        ordinal: RootOrdinal,
        assignment: &[u16; 4],
    ) -> Result<G53SparseQ4Report, G53SparseDefectError> {
        for (block, &mask) in assignment.iter().enumerate() {
            let cache = if block == 0 {
                &self.special
            } else {
                &self.zero
            };
            if cache[usize::from(mask)].is_none() {
                return Err(G53SparseDefectError::SemanticMismatch);
            }
        }
        let domains: [&[G53SparseDefectProfile]; 4] = std::array::from_fn(|block| {
            let cache = if block == 0 {
                &self.special
            } else {
                &self.zero
            };
            cache[usize::from(assignment[block])]
                .as_deref()
                .expect("every root domain is compiled above")
        });
        let right_capacity = domains[2]
            .len()
            .checked_mul(domains[3].len())
            .ok_or(G53SparseDefectError::ProfileBudget)?;
        if right_capacity > PAIR_BUDGET {
            return Err(G53SparseDefectError::ProfileBudget);
        }
        worker.right_pairs.clear();
        for (third_index, third) in domains[2].iter().enumerate() {
            for (fourth_index, fourth) in domains[3].iter().enumerate() {
                let Some(defect_energy) = third.defect_energy.checked_add(fourth.defect_energy)
                else {
                    return Err(G53SparseDefectError::SemanticMismatch);
                };
                if defect_energy > DEFECT_ENERGY_TARGET {
                    continue;
                }
                let mut paf = [0_u16; ACTIVE_NONZERO_SHIFTS];
                for shift in 0..ACTIVE_NONZERO_SHIFTS {
                    paf[shift] = third.paf[shift]
                        .checked_add(fourth.paf[shift])
                        .ok_or(G53SparseDefectError::SemanticMismatch)?;
                }
                if paf.iter().any(|&value| value > 15_080) {
                    continue;
                }
                worker.right_pairs.push(PairProfile {
                    paf,
                    first: u16::try_from(third_index)
                        .map_err(|_| G53SparseDefectError::ProfileBudget)?,
                    second: u16::try_from(fourth_index)
                        .map_err(|_| G53SparseDefectError::ProfileBudget)?,
                    defect_energy,
                    reserved: [0; 3],
                });
            }
        }
        let right_pair_states = worker.right_pairs.len() as u64;
        worker
            .right_pairs
            .sort_unstable_by_key(|pair| (pair.defect_energy, pair.paf));
        let mut witness = None;
        let mut left_pair_probes = 0_u64;
        'left: for first in domains[0] {
            for second in domains[1] {
                left_pair_probes += 1;
                let Some(left_energy) = first.defect_energy.checked_add(second.defect_energy)
                else {
                    return Err(G53SparseDefectError::SemanticMismatch);
                };
                let Some(required_energy) = DEFECT_ENERGY_TARGET.checked_sub(left_energy) else {
                    continue;
                };
                let mut required_paf = [0_u16; ACTIVE_NONZERO_SHIFTS];
                let mut possible = true;
                for shift in 0..ACTIVE_NONZERO_SHIFTS {
                    let left = u32::from(first.paf[shift]) + u32::from(second.paf[shift]);
                    let Some(required) = 15_080_u32.checked_sub(left) else {
                        possible = false;
                        break;
                    };
                    required_paf[shift] = u16::try_from(required)
                        .map_err(|_| G53SparseDefectError::SemanticMismatch)?;
                }
                if !possible {
                    continue;
                }
                let required = (required_energy, required_paf);
                if let Ok(index) = worker
                    .right_pairs
                    .binary_search_by_key(&required, |pair| (pair.defect_energy, pair.paf))
                {
                    let right = worker.right_pairs[index];
                    let candidate = G53SparseQ4Witness {
                        masks: *assignment,
                        digits: [
                            first.digits,
                            second.digits,
                            domains[2][usize::from(right.first)].digits,
                            domains[3][usize::from(right.second)].digits,
                        ],
                    };
                    replay_sparse_q4_witness(candidate)?;
                    witness = Some(candidate);
                    break 'left;
                }
            }
        }
        Ok(G53SparseQ4Report {
            threads: 0,
            roots_examined: 1,
            constructive_hits: u32::from(witness.is_some()),
            exhaustive_misses: u32::from(witness.is_none()),
            right_pair_states,
            left_pair_probes,
            first_witness_root: witness.map(|_| ordinal.0),
            first_witness: witness,
        })
    }
}

impl RootKernel for SparseQ4Kernel {
    type Root = [u16; 4];
    type Worker = SparseQ4Worker;
    type Output = Result<G53SparseQ4Report, G53SparseDefectError>;

    fn create_worker(&self) -> Self::Worker {
        SparseQ4Worker {
            right_pairs: Vec::with_capacity(PAIR_BUDGET),
        }
    }

    fn evaluate(
        &self,
        worker: &mut Self::Worker,
        ordinal: RootOrdinal,
        root: &Self::Root,
    ) -> Self::Output {
        self.evaluate_root(worker, ordinal, root)
    }
}

fn merge_reports(
    left: Result<G53SparseQ4Report, G53SparseDefectError>,
    right: Result<G53SparseQ4Report, G53SparseDefectError>,
) -> Result<G53SparseQ4Report, G53SparseDefectError> {
    let mut left = left?;
    let right = right?;
    left.roots_examined += right.roots_examined;
    left.constructive_hits += right.constructive_hits;
    left.exhaustive_misses += right.exhaustive_misses;
    left.right_pair_states += right.right_pair_states;
    left.left_pair_probes += right.left_pair_probes;
    if witness_root_precedes(left.first_witness_root, right.first_witness_root) {
        left.first_witness_root = right.first_witness_root;
        left.first_witness = right.first_witness;
    }
    Ok(left)
}

#[inline]
fn witness_root_precedes(left: Option<u32>, right: Option<u32>) -> bool {
    right.is_some() && (left.is_none() || right < left)
}

pub fn census_g53_sparse_q4_roots(
    max_roots: usize,
    threads: usize,
) -> Result<G53SparseQ4Report, G53SparseDefectError> {
    let assignments = compile_g53_mod7_assignments()?;
    let roots = &assignments[..max_roots.min(assignments.len())];
    let kernel = SparseQ4Kernel::compile(roots)?;
    let mut report = reduce_roots(
        &kernel,
        roots,
        threads,
        || {
            Ok(G53SparseQ4Report {
                threads: 0,
                roots_examined: 0,
                constructive_hits: 0,
                exhaustive_misses: 0,
                right_pair_states: 0,
                left_pair_probes: 0,
                first_witness_root: None,
                first_witness: None,
            })
        },
        merge_reports,
    )
    .map_err(|_| G53SparseDefectError::ParallelExecution)??;
    report.threads = u16::try_from(threads).map_err(|_| G53SparseDefectError::ParallelExecution)?;
    Ok(report)
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::allocation_test::tracked_allocations;

    #[test]
    fn sparse_profiles_have_tiger_layout_and_direct_replay() {
        let profiles = compile_g53_sparse_defect_profiles(58, 260).unwrap();
        assert!(!profiles.is_empty());
        for profile in profiles.iter().step_by((profiles.len() / 101).max(1)) {
            let word = decode_word(58, profile.digits);
            assert_eq!(word.iter().copied().sum::<u16>(), 260);
            assert_eq!(
                profile.paf,
                std::array::from_fn(|offset| paf(&word, offset + 1))
            );
        }
    }

    #[test]
    fn malformed_affine_row_fails_closed() {
        assert_eq!(
            compile_g53_sparse_defect_profiles(58, 259).unwrap_err(),
            G53SparseDefectError::InvalidRow
        );
    }

    #[test]
    fn presized_exact_root_callback_allocates_nothing() {
        let assignments = compile_g53_mod7_assignments().unwrap();
        let kernel = SparseQ4Kernel::compile(&assignments[..1]).unwrap();
        let mut worker = kernel.create_worker();
        let ((report, capacity), allocations) = tracked_allocations(|| {
            let capacity = worker.right_pairs.capacity();
            let report = kernel
                .evaluate_root(&mut worker, RootOrdinal(0), &assignments[0])
                .unwrap();
            (report, capacity)
        });
        assert_eq!(allocations, 0);
        assert_eq!(capacity, worker.right_pairs.capacity());
        assert_eq!(report.constructive_hits, 0);
        assert_eq!(report.exhaustive_misses, 1);
    }

    #[test]
    fn witness_merge_treats_none_as_the_identity() {
        assert!(witness_root_precedes(None, Some(7)));
        assert!(!witness_root_precedes(Some(7), None));
        assert!(witness_root_precedes(Some(9), Some(7)));
        assert!(!witness_root_precedes(Some(7), Some(9)));
    }
}
