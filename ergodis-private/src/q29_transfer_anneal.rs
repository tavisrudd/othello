//! Discovery-only q29 transfer anneal from an arbitrary bounded root.
//!
//! A move subtracts one from one coefficient and adds one to another
//! coefficient in the same row.  It therefore preserves every row sum while
//! crossing magnitude-inventory strata.  Discovery misses have no authority;
//! an exact hit is reported only after independent direct replay.

use serde::Serialize;

const BLOCKS: usize = 4;
const ORDER: usize = 29;
const SHIFTS: usize = 15;
const COEFFICIENT_BOUND: i8 = 9;

/// The per-mutation scalar state is exactly one cache line.  Coefficients and
/// per-block correlations live in the caller-owned fixed workspace below.
#[repr(C, align(64))]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct Q29TransferHot {
    score: u64,
    combined_paf: [i16; SHIFTS],
    _pad: [u8; 26],
}

const _: () = assert!(core::mem::size_of::<Q29TransferHot>() == 64);
const _: () = assert!(core::mem::align_of::<Q29TransferHot>() == 64);

#[repr(C, align(64))]
#[derive(Clone, Copy)]
struct Q29TransferWorkspace {
    rows: [[i8; ORDER]; BLOCKS],
    best_rows: [[i8; ORDER]; BLOCKS],
    block_paf: [[i16; SHIFTS]; BLOCKS],
    hot: Q29TransferHot,
}

const _: () = assert!(core::mem::size_of::<Q29TransferWorkspace>() == 448);
const _: () = assert!(core::mem::align_of::<Q29TransferWorkspace>() == 64);

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Q29TransferError {
    CoefficientOutOfRange,
    WrongRowSum,
}

#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq)]
pub struct Q29TransferReport {
    pub seed: u64,
    pub mutations_requested: u64,
    pub mutations_completed: u64,
    pub accepted: u64,
    pub initial_score_y: u64,
    pub best_score_y: u64,
    pub best_score_x: u64,
    pub exact_hit: bool,
    pub combined_paf: [i16; SHIFTS],
    pub rows: [[i8; ORDER]; BLOCKS],
    pub provenance: &'static str,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Q29Replay {
    pub score_y: u64,
    pub combined_paf: [i16; SHIFTS],
    pub exact: bool,
}

/// Directly validate and rescore a q29 y-coordinate candidate.
pub fn replay_q29_y(rows: &[[i8; ORDER]; BLOCKS]) -> Result<Q29Replay, Q29TransferError> {
    validate_rows(rows)?;
    let mut combined = [0_i16; SHIFTS];
    for row in rows {
        let paf = direct_block_paf(row);
        for shift in 0..SHIFTS {
            combined[shift] += paf[shift];
        }
    }
    let score_y = exact_score(&combined);
    Ok(Q29Replay {
        score_y,
        combined_paf: combined,
        exact: score_y == 0 && combined[0] == 505 && combined[1..].iter().all(|&x| x == -18),
    })
}

/// Run one deterministic, allocation-free transfer anneal.
pub fn anneal_q29_transfers(
    rows: &[[i8; ORDER]; BLOCKS],
    seed: u64,
    mutations: u64,
) -> Result<Q29TransferReport, Q29TransferError> {
    let initial = replay_q29_y(rows)?;
    let mut workspace = Q29TransferWorkspace::from_rows(*rows, initial);
    let initial_score_y = initial.score_y;
    let mut best_score = initial.score_y;
    let mut best_paf = initial.combined_paf;
    let mut random = seed.max(1);
    let mut accepted = 0_u64;
    let mut completed = 0_u64;

    for mutation in 0..mutations {
        completed = mutation + 1;
        let block = (next_random(&mut random) as usize) & 3;
        let donor = (next_random(&mut random) as usize) % ORDER;
        let mut recipient = (next_random(&mut random) as usize) % (ORDER - 1);
        if recipient >= donor {
            recipient += 1;
        }
        if workspace.rows[block][donor] <= -COEFFICIENT_BOUND
            || workspace.rows[block][recipient] >= COEFFICIENT_BOUND
        {
            continue;
        }

        let old_score = workspace.hot.score;
        apply_transfer(&mut workspace, block, donor, recipient);
        let new_score = workspace.hot.score;
        let phase = mutation & 0x3ffff;
        let temperature = 4_096_u64.saturating_sub(phase >> 6).max(4);
        let worse = new_score.saturating_sub(old_score);
        let accept = new_score <= old_score
            || next_random(&mut random) % temperature.saturating_add(worse) < temperature;
        if accept {
            accepted += 1;
            if new_score < best_score {
                best_score = new_score;
                best_paf = workspace.hot.combined_paf;
                workspace.best_rows = workspace.rows;
                if best_score == 0 {
                    break;
                }
            }
        } else {
            apply_transfer(&mut workspace, block, recipient, donor);
            debug_assert_eq!(workspace.hot.score, old_score);
        }
    }

    let replay = replay_q29_y(&workspace.best_rows)?;
    debug_assert_eq!(replay.score_y, best_score);
    debug_assert_eq!(replay.combined_paf, best_paf);
    let exact_hit = best_score == 0 && replay.exact;
    Ok(Q29TransferReport {
        seed,
        mutations_requested: mutations,
        mutations_completed: completed,
        accepted,
        initial_score_y,
        best_score_y: best_score,
        best_score_x: 16 * best_score,
        exact_hit,
        combined_paf: best_paf,
        rows: workspace.best_rows,
        provenance: "HeuristicSearch; arbitrary bounded q29 y root; within-row unit transfers preserve row sums; exact energy plus fourteen PAF coordinates scored; exact hits direct-replayed; misses have no negative authority",
    })
}

impl Q29TransferWorkspace {
    fn from_rows(rows: [[i8; ORDER]; BLOCKS], replay: Q29Replay) -> Self {
        let mut block_paf = [[0_i16; SHIFTS]; BLOCKS];
        for block in 0..BLOCKS {
            block_paf[block] = direct_block_paf(&rows[block]);
        }
        Self {
            rows,
            best_rows: rows,
            block_paf,
            hot: Q29TransferHot {
                score: replay.score_y,
                combined_paf: replay.combined_paf,
                _pad: [0; 26],
            },
        }
    }
}

#[inline(always)]
fn apply_transfer(
    workspace: &mut Q29TransferWorkspace,
    block: usize,
    donor: usize,
    recipient: usize,
) {
    debug_assert_ne!(donor, recipient);
    let row = &mut workspace.rows[block];
    let old_donor = row[donor];
    let old_recipient = row[recipient];
    row[donor] -= 1;
    row[recipient] += 1;

    for shift in 0..SHIFTS {
        let predecessor = |point: usize| (point + ORDER - shift) % ORDER;
        let candidates = [donor, recipient, predecessor(donor), predecessor(recipient)];
        let mut delta = 0_i16;
        for slot in 0..candidates.len() {
            let point = candidates[slot];
            if candidates[..slot].contains(&point) {
                continue;
            }
            let successor = (point + shift) % ORDER;
            let before = |index: usize| {
                if index == donor {
                    old_donor
                } else if index == recipient {
                    old_recipient
                } else {
                    row[index]
                }
            };
            delta += row[point] as i16 * row[successor] as i16
                - before(point) as i16 * before(successor) as i16;
        }
        workspace.block_paf[block][shift] += delta;
        workspace.hot.combined_paf[shift] += delta;
    }
    workspace.hot.score = exact_score(&workspace.hot.combined_paf);
}

fn validate_rows(rows: &[[i8; ORDER]; BLOCKS]) -> Result<(), Q29TransferError> {
    for (block, row) in rows.iter().enumerate() {
        if row
            .iter()
            .any(|&value| !(-COEFFICIENT_BOUND..=COEFFICIENT_BOUND).contains(&value))
        {
            return Err(Q29TransferError::CoefficientOutOfRange);
        }
        let sum = row.iter().fold(0_i32, |acc, &value| acc + i32::from(value));
        if sum != i32::from(block == 0) {
            return Err(Q29TransferError::WrongRowSum);
        }
    }
    Ok(())
}

#[inline(always)]
fn direct_block_paf(row: &[i8; ORDER]) -> [i16; SHIFTS] {
    let mut paf = [0_i16; SHIFTS];
    for shift in 0..SHIFTS {
        for point in 0..ORDER {
            paf[shift] += row[point] as i16 * row[(point + shift) % ORDER] as i16;
        }
    }
    paf
}

#[inline(always)]
fn exact_score(paf: &[i16; SHIFTS]) -> u64 {
    let mut score = u64::from((i32::from(paf[0]) - 505).unsigned_abs()).pow(2);
    for &value in &paf[1..] {
        score += u64::from((i32::from(value) + 18).unsigned_abs()).pow(2);
    }
    score
}

#[inline(always)]
fn next_random(state: &mut u64) -> u64 {
    *state ^= *state << 7;
    *state ^= *state >> 9;
    *state ^= *state << 8;
    *state
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::allocation_test::tracked_allocations;

    fn retained_outer_y6_root() -> [[i8; ORDER]; BLOCKS] {
        [
            [
                -1, -1, 1, -1, -1, -1, -1, -1, -1, 0, 0, -1, 1, 1, 1, 1, -1, 1, 1, 1, 1, 1, 0, 1,
                0, 0, -1, 0, 1,
            ],
            [
                1, 1, 0, 1, 0, 0, 1, 1, 0, 0, 0, 1, -1, 0, -1, -5, 1, 0, -1, 0, 1, 0, -1, 0, 1, -1,
                -1, 1, 1,
            ],
            [
                7, -1, -4, 0, -1, -2, -1, -2, -1, -1, -3, -1, 9, -2, -1, -4, 1, 0, 0, 0, 0, -1, 6,
                0, -1, 0, -1, 5, -1,
            ],
            [
                4, -2, 5, -1, -1, -2, -1, -5, -1, 5, -1, 0, 0, -1, 2, -1, -1, 5, 6, -1, -1, -1, -1,
                -1, -1, -1, -2, -1, 0,
            ],
        ]
    }

    #[test]
    fn retained_root_replays_at_y_score_six() {
        let replay = replay_q29_y(&retained_outer_y6_root()).unwrap();
        assert_eq!(replay.score_y, 6);
        assert!(!replay.exact);
    }

    #[test]
    fn incremental_transfers_agree_with_direct_replay() {
        let rows = retained_outer_y6_root();
        let replay = replay_q29_y(&rows).unwrap();
        let mut workspace = Q29TransferWorkspace::from_rows(rows, replay);
        let moves = [(0, 0, 9), (1, 15, 4), (2, 12, 3), (3, 18, 20)];
        for (block, donor, recipient) in moves {
            apply_transfer(&mut workspace, block, donor, recipient);
            let direct = replay_q29_y(&workspace.rows).unwrap();
            assert_eq!(workspace.hot.score, direct.score_y);
            assert_eq!(workspace.hot.combined_paf, direct.combined_paf);
        }
        for (block, donor, recipient) in moves.into_iter().rev() {
            apply_transfer(&mut workspace, block, recipient, donor);
        }
        assert_eq!(workspace.rows, rows);
        assert_eq!(workspace.hot.score, replay.score_y);
    }

    #[test]
    fn anneal_preserves_bounds_and_row_sums_and_replays_report() {
        let report = anneal_q29_transfers(&retained_outer_y6_root(), 0x1234_5678, 100_000).unwrap();
        let replay = replay_q29_y(&report.rows).unwrap();
        assert_eq!(report.best_score_y, replay.score_y);
        assert_eq!(report.combined_paf, replay.combined_paf);
        assert_eq!(report.exact_hit, replay.exact);
        assert!(report.best_score_y <= 6);
    }

    #[test]
    fn malformed_roots_fail_closed() {
        let mut rows = retained_outer_y6_root();
        rows[0][0] = 10;
        assert_eq!(
            replay_q29_y(&rows),
            Err(Q29TransferError::CoefficientOutOfRange)
        );
        let mut rows = retained_outer_y6_root();
        rows[0][0] += 1;
        assert_eq!(replay_q29_y(&rows), Err(Q29TransferError::WrongRowSum));
    }

    #[test]
    fn anneal_hot_loop_allocates_nothing() {
        let rows = retained_outer_y6_root();
        let (_, allocations) = tracked_allocations(|| {
            let report = anneal_q29_transfers(&rows, 0xfeed_face, 100_000).unwrap();
            assert!(report.best_score_y <= 6);
        });
        assert_eq!(allocations, 0);
    }
}
