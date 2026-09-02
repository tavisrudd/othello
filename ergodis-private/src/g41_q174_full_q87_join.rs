//! Exact full-q87 endgame join over lifted q174 target fibres.

use serde::Serialize;
use thiserror::Error;

use crate::g41_q174_joint::{g41_q174_q87_defect_vector, G41Q174JointError};

const TARGET: u16 = 523;
const COORDINATES: usize = 43;

#[derive(Clone, Debug, Error, PartialEq, Eq)]
pub enum G41Q174FullQ87JoinError {
    #[error("full q87 join semantics are invalid")]
    SemanticMismatch,
    #[error("full q87 pair workspace needs {entries} entries, above budget {budget}")]
    PairBudget { entries: u64, budget: u64 },
    #[error(transparent)]
    Extractor(#[from] G41Q174JointError),
}

#[derive(Clone, Copy)]
struct StateVector {
    state: u128,
    defects: [u16; COORDINATES],
}

pub struct G41Q174Q87ScopeContext {
    vectors: [Vec<StateVector>; 4],
}

impl G41Q174Q87ScopeContext {
    pub fn compile(states: [&[u128]; 4]) -> Result<Self, G41Q174FullQ87JoinError> {
        Ok(Self {
            vectors: [
                compile_vectors(states[0])?,
                compile_vectors(states[1])?,
                compile_vectors(states[2])?,
                compile_vectors(states[3])?,
            ],
        })
    }

    pub fn search(
        &self,
        shifts: &[u8],
        maximum_pair_entries: usize,
    ) -> Result<G41Q174FullQ87JoinReport, G41Q174FullQ87JoinError> {
        if maximum_pair_entries == 0
            || shifts.is_empty()
            || shifts.iter().any(|&shift| !(1..=43).contains(&shift))
            || !shifts.windows(2).all(|pair| pair[0] < pair[1])
        {
            return Err(G41Q174FullQ87JoinError::SemanticMismatch);
        }
        let mut coordinates = [0_usize; COORDINATES];
        for (index, &shift) in shifts.iter().enumerate() {
            coordinates[index] = usize::from(shift - 1);
        }
        join_vectors(
            [
                &self.vectors[0],
                &self.vectors[1],
                &self.vectors[2],
                &self.vectors[3],
            ],
            maximum_pair_entries,
            &coordinates[..shifts.len()],
        )
    }
}

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
struct PairEntry {
    defects: [u16; COORDINATES],
    first: u16,
    second: u16,
}

const _: () = assert!(std::mem::size_of::<PairEntry>() == 90);

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q174FullQ87JoinReport {
    pub shifts: Vec<u8>,
    pub fibre_sizes: [u32; 4],
    pub right_pairs_visited: u64,
    pub right_pairs_retained: u64,
    pub left_pairs_visited: u64,
    pub maximum_pair_entries: u64,
    pub workspace_bytes: u64,
    pub first_states: Option<[u128; 4]>,
    pub complete: bool,
    pub provenance: &'static str,
}

fn compile_vectors(states: &[u128]) -> Result<Vec<StateVector>, G41Q174FullQ87JoinError> {
    if states.len() > u16::MAX as usize || !states.windows(2).all(|pair| pair[0] < pair[1]) {
        return Err(G41Q174FullQ87JoinError::SemanticMismatch);
    }
    states
        .iter()
        .map(|&state| {
            Ok(StateVector {
                state,
                defects: g41_q174_q87_defect_vector(state)?,
            })
        })
        .collect()
}

#[inline(always)]
fn sum_defects(
    first: &[u16; COORDINATES],
    second: &[u16; COORDINATES],
    coordinates: &[usize],
) -> Option<[u16; COORDINATES]> {
    let mut sum = [0_u16; COORDINATES];
    for &coordinate in coordinates {
        sum[coordinate] = first[coordinate] + second[coordinate];
        if sum[coordinate] > TARGET {
            return None;
        }
    }
    Some(sum)
}

fn join_vectors(
    vectors: [&[StateVector]; 4],
    maximum_pair_entries: usize,
    coordinates: &[usize],
) -> Result<G41Q174FullQ87JoinReport, G41Q174FullQ87JoinError> {
    let raw_right = vectors[1].len() as u64 * vectors[3].len() as u64;
    if raw_right > maximum_pair_entries as u64 {
        return Err(G41Q174FullQ87JoinError::PairBudget {
            entries: raw_right,
            budget: maximum_pair_entries as u64,
        });
    }
    let mut right = Vec::with_capacity(maximum_pair_entries);
    fill_right_pairs(vectors[1], vectors[3], coordinates, &mut right);
    right.sort_unstable();
    let retained = right.len() as u64;
    let mut left_pairs_visited = 0_u64;
    for left in vectors[0] {
        for second in vectors[2] {
            left_pairs_visited += 1;
            let Some(defects) = sum_defects(&left.defects, &second.defects, coordinates) else {
                continue;
            };
            let mut target = [0_u16; COORDINATES];
            for &coordinate in coordinates {
                target[coordinate] = TARGET - defects[coordinate];
            }
            let position = right.partition_point(|entry| entry.defects < target);
            if position < right.len() && right[position].defects == target {
                let matched = right[position];
                return Ok(G41Q174FullQ87JoinReport {
                    shifts: coordinates.iter().map(|&index| index as u8 + 1).collect(),
                    fibre_sizes: vectors.map(|set| set.len() as u32),
                    right_pairs_visited: raw_right,
                    right_pairs_retained: retained,
                    left_pairs_visited,
                    maximum_pair_entries: maximum_pair_entries as u64,
                    workspace_bytes: maximum_pair_entries as u64
                        * std::mem::size_of::<PairEntry>() as u64,
                    first_states: Some([
                        left.state,
                        vectors[1][usize::from(matched.first)].state,
                        second.state,
                        vectors[3][usize::from(matched.second)].state,
                    ]),
                    complete: false,
                    provenance: "exact q87 lift join over four exhaustively enumerated q174 target fibres; the explicitly reported shift scope is extracted directly and compared in one collision-free fixed-width key; no profile-representative assumption is reused",
                });
            }
        }
    }
    Ok(G41Q174FullQ87JoinReport {
        shifts: coordinates.iter().map(|&index| index as u8 + 1).collect(),
        fibre_sizes: vectors.map(|set| set.len() as u32),
        right_pairs_visited: raw_right,
        right_pairs_retained: retained,
        left_pairs_visited,
        maximum_pair_entries: maximum_pair_entries as u64,
        workspace_bytes: maximum_pair_entries as u64
            * std::mem::size_of::<PairEntry>() as u64,
        first_states: None,
        complete: true,
        provenance: "exact q87 lift join over four exhaustively enumerated q174 target fibres; the explicitly reported shift scope is extracted directly and compared in one collision-free fixed-width key; no profile-representative assumption is reused",
    })
}

fn fill_right_pairs(
    first: &[StateVector],
    second: &[StateVector],
    coordinates: &[usize],
    right: &mut Vec<PairEntry>,
) {
    right.clear();
    for (first_id, left) in first.iter().enumerate() {
        for (second_id, right_vector) in second.iter().enumerate() {
            if let Some(defects) = sum_defects(&left.defects, &right_vector.defects, coordinates) {
                right.push(PairEntry {
                    defects,
                    first: first_id as u16,
                    second: second_id as u16,
                });
            }
        }
    }
}

pub fn search_g41_q174_full_q87_join(
    states: [&[u128]; 4],
    maximum_pair_entries: usize,
) -> Result<G41Q174FullQ87JoinReport, G41Q174FullQ87JoinError> {
    if maximum_pair_entries == 0 {
        return Err(G41Q174FullQ87JoinError::SemanticMismatch);
    }
    let vectors = [
        compile_vectors(states[0])?,
        compile_vectors(states[1])?,
        compile_vectors(states[2])?,
        compile_vectors(states[3])?,
    ];
    let coordinates: [usize; COORDINATES] = std::array::from_fn(|index| index);
    join_vectors(
        [&vectors[0], &vectors[1], &vectors[2], &vectors[3]],
        maximum_pair_entries,
        &coordinates,
    )
}

pub fn search_g41_q174_scoped_q87_join(
    states: [&[u128]; 4],
    shifts: &[u8],
    maximum_pair_entries: usize,
) -> Result<G41Q174FullQ87JoinReport, G41Q174FullQ87JoinError> {
    G41Q174Q87ScopeContext::compile(states)?.search(shifts, maximum_pair_entries)
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::allocation_test::tracked_allocations;

    #[test]
    fn full_q87_pair_kernel_allocates_nothing_after_presizing() {
        let vectors = [
            [StateVector {
                state: 1,
                defects: [100; COORDINATES],
            }],
            [StateVector {
                state: 2,
                defects: [120; COORDINATES],
            }],
            [StateVector {
                state: 3,
                defects: [123; COORDINATES],
            }],
            [StateVector {
                state: 4,
                defects: [180; COORDINATES],
            }],
        ];
        let coordinates: [usize; COORDINATES] = std::array::from_fn(|index| index);
        let mut scratch = Vec::with_capacity(8);
        let (_, allocations) = tracked_allocations(|| {
            fill_right_pairs(&vectors[1], &vectors[3], &coordinates, &mut scratch)
        });
        assert_eq!(allocations, 0);
        let report = join_vectors(
            [&vectors[0], &vectors[1], &vectors[2], &vectors[3]],
            8,
            &coordinates,
        )
        .unwrap();
        assert_eq!(report.first_states, Some([1, 2, 3, 4]));
        let scoped = join_vectors(
            [&vectors[0], &vectors[1], &vectors[2], &vectors[3]],
            8,
            &[7],
        )
        .unwrap();
        assert_eq!(scoped.shifts, vec![8]);
        assert_eq!(scoped.first_states, Some([1, 2, 3, 4]));
    }
}
