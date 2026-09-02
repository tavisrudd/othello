//! Exact distinct-block local repair for evolved q18 near misses.
//!
//! One transfer may be applied in each block.  Block autocorrelation deltas
//! compose additively across distinct blocks; same-block multi-move deltas do
//! not, and are deliberately outside this kernel's stated domain.

use crate::q18_pair_split::{
    verify_q18_gs_reduction, Q18Coefficients, Q18DivisorProjection, Q18PairSplit,
};

const BLOCKS: usize = 4;
const ORDER: usize = 18;
const SHIFTS: usize = 10;
const MOVES: usize = 1 + ORDER * (ORDER - 1);
const PAIRS: usize = MOVES * MOVES;
const TARGET: [i32; SHIFTS] = [1_976, -116, -116, -116, -116, -116, -116, -116, -116, -116];

#[repr(C, align(64))]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct MoveRecord {
    delta: [i32; SHIFTS],
    from: u8,
    to: u8,
    _padding: [u8; 22],
}

const _: () = assert!(std::mem::size_of::<MoveRecord>() == 64);
const _: () = assert!(std::mem::align_of::<MoveRecord>() == 64);

const NO_MOVE: MoveRecord = MoveRecord {
    delta: [0; SHIFTS],
    from: u8::MAX,
    to: u8::MAX,
    _padding: [0; 22],
};

#[repr(C, align(64))]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct PairRecord {
    delta: [i32; SHIFTS],
    first: u16,
    second: u16,
    _padding: [u8; 20],
}

const _: () = assert!(std::mem::size_of::<PairRecord>() == 64);
const _: () = assert!(std::mem::align_of::<PairRecord>() == 64);

const EMPTY_PAIR: PairRecord = PairRecord {
    delta: [0; SHIFTS],
    first: 0,
    second: 0,
    _padding: [0; 20],
};

pub struct Q18LocalRepairWorkspace {
    left_pairs: Box<[PairRecord]>,
}

impl Q18LocalRepairWorkspace {
    #[must_use]
    pub fn new() -> Self {
        vec![EMPTY_PAIR; PAIRS].into_boxed_slice().into()
    }
}

impl From<Box<[PairRecord]>> for Q18LocalRepairWorkspace {
    fn from(left_pairs: Box<[PairRecord]>) -> Self {
        Self { left_pairs }
    }
}

impl Default for Q18LocalRepairWorkspace {
    fn default() -> Self {
        Self::new()
    }
}

/// Search every combination containing at most one transfer per block.
///
/// The six-megabyte pair workspace is allocated by the constructor.  The
/// repair kernel itself allocates nothing and directly replays any hit.
pub fn repair_q18_across_distinct_blocks(
    base: &Q18Coefficients,
    workspace: &mut Q18LocalRepairWorkspace,
) -> Option<Q18Coefficients> {
    let mut moves = [[NO_MOVE; MOVES]; BLOCKS];
    let mut move_counts = [0_usize; BLOCKS];
    for block in 0..BLOCKS {
        move_counts[block] = compile_moves(&base.blocks[block], &mut moves[block]);
    }

    let base_paf = combined_paf(base);
    let needed: [i32; SHIFTS] = std::array::from_fn(|shift| TARGET[shift] - base_paf[shift]);
    let mut pair_count = 0_usize;
    for first in 0..move_counts[0] {
        for second in 0..move_counts[1] {
            workspace.left_pairs[pair_count] = PairRecord {
                delta: std::array::from_fn(|shift| {
                    moves[0][first].delta[shift] + moves[1][second].delta[shift]
                }),
                first: first as u16,
                second: second as u16,
                _padding: [0; 20],
            };
            pair_count += 1;
        }
    }
    workspace.left_pairs[..pair_count].sort_unstable_by_key(|pair| pair.delta);

    for third in 0..move_counts[2] {
        for fourth in 0..move_counts[3] {
            let wanted = std::array::from_fn(|shift| {
                needed[shift] - moves[2][third].delta[shift] - moves[3][fourth].delta[shift]
            });
            if let Ok(slot) =
                workspace.left_pairs[..pair_count].binary_search_by_key(&wanted, |pair| pair.delta)
            {
                let pair = workspace.left_pairs[slot];
                let selected = [
                    usize::from(pair.first),
                    usize::from(pair.second),
                    third,
                    fourth,
                ];
                let mut candidate = *base;
                for block in 0..BLOCKS {
                    apply_move(&mut candidate.blocks[block], moves[block][selected[block]]);
                }
                let mut split = Q18PairSplit::ZERO;
                let mut projection = Q18DivisorProjection::ZERO;
                if verify_q18_gs_reduction(&candidate, &mut split, &mut projection).is_ok() {
                    return Some(candidate);
                }
            }
        }
    }
    None
}

/// Search one exact same-block two-transfer move plus at most one transfer in
/// a different block.  The two-transfer delta is always recomputed from the
/// modified block; it is never formed by the unsound same-block additive join.
pub fn repair_q18_one_double_one_single(base: &Q18Coefficients) -> Option<Q18Coefficients> {
    let base_paf = combined_paf(base);
    let needed: [i32; SHIFTS] = std::array::from_fn(|shift| TARGET[shift] - base_paf[shift]);
    let mut moves = [[NO_MOVE; MOVES]; BLOCKS];
    let mut move_counts = [0_usize; BLOCKS];
    for block in 0..BLOCKS {
        move_counts[block] = compile_moves(&base.blocks[block], &mut moves[block]);
    }

    for double_block in 0..BLOCKS {
        let baseline = block_paf(&base.blocks[double_block]);
        for single_block in 0..BLOCKS {
            if single_block == double_block {
                continue;
            }
            moves[single_block][..move_counts[single_block]]
                .sort_unstable_by_key(|movement| movement.delta);
            for first in 0..move_counts[double_block] {
                let mut once = base.blocks[double_block];
                apply_move(&mut once, moves[double_block][first]);
                for second in 0..move_counts[double_block] {
                    let movement = moves[double_block][second];
                    if movement.from != u8::MAX
                        && (once[usize::from(movement.from)] == -29
                            || once[usize::from(movement.to)] == 29)
                    {
                        continue;
                    }
                    let mut twice = once;
                    apply_move(&mut twice, movement);
                    let after = block_paf(&twice);
                    let wanted: [i32; SHIFTS] = std::array::from_fn(|shift| {
                        needed[shift] - (after[shift] - baseline[shift])
                    });
                    if let Ok(single) = moves[single_block][..move_counts[single_block]]
                        .binary_search_by_key(&wanted, |candidate| candidate.delta)
                    {
                        let mut candidate = *base;
                        apply_move(
                            &mut candidate.blocks[double_block],
                            moves[double_block][first],
                        );
                        apply_move(&mut candidate.blocks[double_block], movement);
                        apply_move(
                            &mut candidate.blocks[single_block],
                            moves[single_block][single],
                        );
                        let mut split = Q18PairSplit::ZERO;
                        let mut projection = Q18DivisorProjection::ZERO;
                        if verify_q18_gs_reduction(&candidate, &mut split, &mut projection).is_ok()
                        {
                            return Some(candidate);
                        }
                    }
                }
            }
        }
    }
    None
}

/// Search two transfers in each of two distinct blocks.
///
/// Each same-block double delta is recomputed from the twice-modified word;
/// only the resulting deltas from distinct blocks are joined additively.
pub fn repair_q18_two_doubles(
    base: &Q18Coefficients,
    workspace: &mut Q18LocalRepairWorkspace,
) -> Option<Q18Coefficients> {
    let base_paf = combined_paf(base);
    let needed: [i32; SHIFTS] = std::array::from_fn(|shift| TARGET[shift] - base_paf[shift]);
    let mut moves = [[NO_MOVE; MOVES]; BLOCKS];
    let mut move_counts = [0_usize; BLOCKS];
    for block in 0..BLOCKS {
        move_counts[block] = compile_moves(&base.blocks[block], &mut moves[block]);
    }

    for left_block in 0..BLOCKS {
        let left_count = compile_double_moves(
            &base.blocks[left_block],
            &moves[left_block],
            move_counts[left_block],
            &mut workspace.left_pairs,
        );
        workspace.left_pairs[..left_count].sort_unstable_by_key(|pair| pair.delta);
        for right_block in left_block + 1..BLOCKS {
            let baseline = block_paf(&base.blocks[right_block]);
            for first in 0..move_counts[right_block] {
                let mut once = base.blocks[right_block];
                apply_move(&mut once, moves[right_block][first]);
                for second in 0..move_counts[right_block] {
                    let second_move = moves[right_block][second];
                    if !move_is_valid(&once, second_move) {
                        continue;
                    }
                    let mut twice = once;
                    apply_move(&mut twice, second_move);
                    let after = block_paf(&twice);
                    let wanted: [i32; SHIFTS] = std::array::from_fn(|shift| {
                        needed[shift] - (after[shift] - baseline[shift])
                    });
                    if let Ok(slot) = workspace.left_pairs[..left_count]
                        .binary_search_by_key(&wanted, |pair| pair.delta)
                    {
                        let pair = workspace.left_pairs[slot];
                        let mut candidate = *base;
                        apply_move(
                            &mut candidate.blocks[left_block],
                            moves[left_block][usize::from(pair.first)],
                        );
                        apply_move(
                            &mut candidate.blocks[left_block],
                            moves[left_block][usize::from(pair.second)],
                        );
                        apply_move(
                            &mut candidate.blocks[right_block],
                            moves[right_block][first],
                        );
                        apply_move(&mut candidate.blocks[right_block], second_move);
                        let mut split = Q18PairSplit::ZERO;
                        let mut projection = Q18DivisorProjection::ZERO;
                        if verify_q18_gs_reduction(&candidate, &mut split, &mut projection).is_ok()
                        {
                            return Some(candidate);
                        }
                    }
                }
            }
        }
    }
    None
}

/// Search one exact same-block double transfer plus at most one transfer in
/// each of two other blocks.
///
/// The double delta is recomputed from the actually twice-modified word.  The
/// only additive join is between three distinct blocks.
pub fn repair_q18_one_double_two_singles(
    base: &Q18Coefficients,
    workspace: &mut Q18LocalRepairWorkspace,
) -> Option<Q18Coefficients> {
    let base_paf = combined_paf(base);
    let needed: [i32; SHIFTS] = std::array::from_fn(|shift| TARGET[shift] - base_paf[shift]);
    let mut moves = [[NO_MOVE; MOVES]; BLOCKS];
    let mut move_counts = [0_usize; BLOCKS];
    for block in 0..BLOCKS {
        move_counts[block] = compile_moves(&base.blocks[block], &mut moves[block]);
    }

    for double_block in 0..BLOCKS {
        let baseline = block_paf(&base.blocks[double_block]);
        for omitted_block in 0..BLOCKS {
            if omitted_block == double_block {
                continue;
            }
            let mut singles = [usize::MAX; 2];
            let mut single_count = 0_usize;
            for block in 0..BLOCKS {
                if block != double_block && block != omitted_block {
                    singles[single_count] = block;
                    single_count += 1;
                }
            }
            let left_block = singles[0];
            let right_block = singles[1];
            let mut pair_count = 0_usize;
            for left in 0..move_counts[left_block] {
                for right in 0..move_counts[right_block] {
                    workspace.left_pairs[pair_count] = PairRecord {
                        delta: std::array::from_fn(|shift| {
                            moves[left_block][left].delta[shift]
                                + moves[right_block][right].delta[shift]
                        }),
                        first: left as u16,
                        second: right as u16,
                        _padding: [0; 20],
                    };
                    pair_count += 1;
                }
            }
            workspace.left_pairs[..pair_count].sort_unstable_by_key(|pair| pair.delta);

            for first in 0..move_counts[double_block] {
                let mut once = base.blocks[double_block];
                apply_move(&mut once, moves[double_block][first]);
                for second in 0..move_counts[double_block] {
                    let second_move = moves[double_block][second];
                    if !move_is_valid(&once, second_move) {
                        continue;
                    }
                    let mut twice = once;
                    apply_move(&mut twice, second_move);
                    let after = block_paf(&twice);
                    let wanted: [i32; SHIFTS] = std::array::from_fn(|shift| {
                        needed[shift] - (after[shift] - baseline[shift])
                    });
                    if let Ok(slot) = workspace.left_pairs[..pair_count]
                        .binary_search_by_key(&wanted, |pair| pair.delta)
                    {
                        let pair = workspace.left_pairs[slot];
                        let mut candidate = *base;
                        apply_move(
                            &mut candidate.blocks[double_block],
                            moves[double_block][first],
                        );
                        apply_move(&mut candidate.blocks[double_block], second_move);
                        apply_move(
                            &mut candidate.blocks[left_block],
                            moves[left_block][usize::from(pair.first)],
                        );
                        apply_move(
                            &mut candidate.blocks[right_block],
                            moves[right_block][usize::from(pair.second)],
                        );
                        let mut split = Q18PairSplit::ZERO;
                        let mut projection = Q18DivisorProjection::ZERO;
                        if verify_q18_gs_reduction(&candidate, &mut split, &mut projection).is_ok()
                        {
                            return Some(candidate);
                        }
                    }
                }
            }
        }
    }
    None
}

fn compile_double_moves(
    coefficients: &[i8; ORDER],
    moves: &[MoveRecord; MOVES],
    move_count: usize,
    output: &mut [PairRecord],
) -> usize {
    let baseline = block_paf(coefficients);
    let mut count = 0_usize;
    for first in 0..move_count {
        let mut once = *coefficients;
        apply_move(&mut once, moves[first]);
        for second in 0..move_count {
            if !move_is_valid(&once, moves[second]) {
                continue;
            }
            let mut twice = once;
            apply_move(&mut twice, moves[second]);
            let after = block_paf(&twice);
            output[count] = PairRecord {
                delta: std::array::from_fn(|shift| after[shift] - baseline[shift]),
                first: first as u16,
                second: second as u16,
                _padding: [0; 20],
            };
            count += 1;
        }
    }
    count
}

fn move_is_valid(coefficients: &[i8; ORDER], movement: MoveRecord) -> bool {
    movement.from == u8::MAX
        || (coefficients[usize::from(movement.from)] != -29
            && coefficients[usize::from(movement.to)] != 29)
}

fn compile_moves(coefficients: &[i8; ORDER], output: &mut [MoveRecord; MOVES]) -> usize {
    output[0] = NO_MOVE;
    let baseline = block_paf(coefficients);
    let mut count = 1_usize;
    for from in 0..ORDER {
        for to in 0..ORDER {
            if from == to || coefficients[from] == -29 || coefficients[to] == 29 {
                continue;
            }
            let mut changed = *coefficients;
            changed[from] -= 2;
            changed[to] += 2;
            let after = block_paf(&changed);
            output[count] = MoveRecord {
                delta: std::array::from_fn(|shift| after[shift] - baseline[shift]),
                from: from as u8,
                to: to as u8,
                _padding: [0; 22],
            };
            count += 1;
        }
    }
    count
}

fn apply_move(coefficients: &mut [i8; ORDER], movement: MoveRecord) {
    if movement.from != u8::MAX {
        coefficients[usize::from(movement.from)] -= 2;
        coefficients[usize::from(movement.to)] += 2;
    }
}

fn block_paf(coefficients: &[i8; ORDER]) -> [i32; SHIFTS] {
    std::array::from_fn(|shift| {
        (0..ORDER)
            .map(|point| {
                i32::from(coefficients[point]) * i32::from(coefficients[(point + shift) % ORDER])
            })
            .sum()
    })
}

fn combined_paf(coefficients: &Q18Coefficients) -> [i32; SHIFTS] {
    let mut output = [0_i32; SHIFTS];
    for block in &coefficients.blocks {
        let paf = block_paf(block);
        for shift in 0..SHIFTS {
            output[shift] += paf[shift];
        }
    }
    output
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::allocation_test::tracked_allocations;

    #[test]
    fn compiled_move_deltas_match_direct_recomputation() {
        let base = Q18Coefficients {
            blocks: std::array::from_fn(|block| {
                std::array::from_fn(|point| 2 * ((3 * point + block) % 15) as i8 - 13)
            }),
        };
        let mut moves = [NO_MOVE; MOVES];
        let count = compile_moves(&base.blocks[0], &mut moves);
        let before = block_paf(&base.blocks[0]);
        for &movement in &moves[..count] {
            let mut changed = base.blocks[0];
            apply_move(&mut changed, movement);
            let after = block_paf(&changed);
            assert_eq!(
                movement.delta,
                std::array::from_fn(|shift| after[shift] - before[shift])
            );
        }
    }

    #[test]
    fn repair_kernel_allocates_nothing() {
        let base = Q18Coefficients {
            blocks: [[-1; ORDER]; BLOCKS],
        };
        let mut workspace = Q18LocalRepairWorkspace::new();
        let (_, allocations) = tracked_allocations(|| {
            let _ = repair_q18_across_distinct_blocks(&base, &mut workspace);
        });
        assert_eq!(allocations, 0);
    }

    #[test]
    fn same_block_double_kernel_allocates_nothing() {
        let base = Q18Coefficients {
            blocks: [[-1; ORDER]; BLOCKS],
        };
        let (_, allocations) = tracked_allocations(|| {
            let _ = repair_q18_one_double_one_single(&base);
        });
        assert_eq!(allocations, 0);
    }

    #[test]
    fn two_double_join_allocates_nothing() {
        let base = Q18Coefficients {
            blocks: [[-1; ORDER]; BLOCKS],
        };
        let mut workspace = Q18LocalRepairWorkspace::new();
        let (_, allocations) = tracked_allocations(|| {
            let _ = repair_q18_two_doubles(&base, &mut workspace);
        });
        assert_eq!(allocations, 0);
    }

    #[test]
    fn double_plus_two_singles_join_allocates_nothing() {
        let base = Q18Coefficients {
            blocks: [[-1; ORDER]; BLOCKS],
        };
        let mut workspace = Q18LocalRepairWorkspace::new();
        let (_, allocations) = tracked_allocations(|| {
            let _ = repair_q18_one_double_two_singles(&base, &mut workspace);
        });
        assert_eq!(allocations, 0);
    }
}
