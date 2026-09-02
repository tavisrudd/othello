//! Discovery-only exact q29 anneal seeded from a directly replayed mod18 shell.
//!
//! Swaps preserve all four row sums, coefficient bounds, and total energy.
//! The affected same-block PAF is always recomputed from the swapped row.
//! Guided workers may leave the mod18 shell, but score that loss explicitly;
//! no intermediate state has proof or negative-coverage authority.

use serde::Serialize;

const BLOCKS: usize = 4;
const ORDER: usize = 29;
const SHIFTS: usize = 15;

#[repr(C, align(64))]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct Q29AnnealState {
    rows: [[i8; ORDER]; BLOCKS],
    block_paf: [[i32; SHIFTS]; BLOCKS],
    combined_paf: [i32; SHIFTS],
    score: u64,
    _pad: [u8; 24],
}

const _: () = assert!(core::mem::size_of::<Q29AnnealState>() == 448);
const _: () = assert!(core::mem::align_of::<Q29AnnealState>() == 64);

#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq)]
pub struct Q29AnnealReport {
    pub seed: u64,
    pub mutations: u64,
    pub accepted: u64,
    /// Squared residual in y-coordinates, with targets `(505,-18)`.
    pub best_score_y: u64,
    /// The same squared residual in outer x=2y coordinates.
    pub best_score_x: u64,
    pub best_mod18_score_y: u64,
    pub exact_hit: bool,
    pub guided: bool,
    pub combined_paf: [i32; SHIFTS],
    pub rows: [[i8; ORDER]; BLOCKS],
    pub provenance: &'static str,
}

/// Structural level of a directly replayed mod-18 q29 shell.
///
/// If `C_s = -18 + 18 k_s`, row sums `(1,0,0,0)` imply
/// `sum_s C_s = 1`; symmetry and `C_0 = 505` then give
/// `sum_{s=1}^{14} k_s = 0`. Consequently the y-coordinate score is
/// `648 * level`, and level zero is an exact q29 solution.
#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
pub struct Q29Mod18ShellLevel {
    pub level: u64,
    pub exact_score_y: u64,
    pub exact_score_x: u64,
}

#[must_use]
pub fn q29_mod18_shell_level(rows: &[[i8; ORDER]; BLOCKS]) -> Option<Q29Mod18ShellLevel> {
    for (block, row) in rows.iter().enumerate() {
        let sum = row.iter().fold(0_i32, |acc, &value| acc + i32::from(value));
        if sum != i32::from(block == 0) {
            return None;
        }
    }
    let state = Q29AnnealState::from_rows(*rows);
    if state.combined_paf[0] != 505 || !is_mod18_shell(&state.combined_paf) {
        return None;
    }
    let mut k_sum = 0_i32;
    let mut square_sum = 0_u64;
    for &correlation in &state.combined_paf[1..] {
        let k = (correlation + 18) / 18;
        k_sum += k;
        square_sum += u64::from(k.unsigned_abs()).pow(2);
    }
    if k_sum != 0 || square_sum & 1 != 0 {
        return None;
    }
    let exact_score_y = 324 * square_sum;
    debug_assert_eq!(exact_score_y, state.score);
    Some(Q29Mod18ShellLevel {
        level: square_sum / 2,
        exact_score_y,
        exact_score_x: 16 * exact_score_y,
    })
}

impl Q29AnnealState {
    fn from_rows(rows: [[i8; ORDER]; BLOCKS]) -> Self {
        let mut state = Self {
            rows,
            block_paf: [[0; SHIFTS]; BLOCKS],
            combined_paf: [0; SHIFTS],
            score: 0,
            _pad: [0; 24],
        };
        for block in 0..BLOCKS {
            state.block_paf[block] = block_paf(&state.rows[block]);
            for shift in 0..SHIFTS {
                state.combined_paf[shift] += state.block_paf[block][shift];
            }
        }
        state.score = exact_score(&state.combined_paf);
        state
    }
}

#[must_use]
pub fn anneal_q29_from_mod18<const GUIDED: bool>(
    rows: &[[i8; ORDER]; BLOCKS],
    seed: u64,
    mutations: u64,
) -> Q29AnnealReport {
    let mut random = seed;
    let mut state = Q29AnnealState::from_rows(*rows);
    let mut best = state;
    let mut best_mod18 = if is_mod18_shell(&state.combined_paf) {
        state
    } else {
        let mut missing = state;
        missing.score = u64::MAX;
        missing
    };
    let mut accepted = 0_u64;
    for mutation in 0..mutations {
        let block = (next_random(&mut random) as usize) & 3;
        let first = (next_random(&mut random) as usize) % ORDER;
        let mut second = (next_random(&mut random) as usize) % (ORDER - 1);
        if second >= first {
            second += 1;
        }
        if state.rows[block][first] == state.rows[block][second] {
            continue;
        }
        let old_block = state.block_paf[block];
        let old_exact = state.score;
        let old_objective = objective::<GUIDED>(&state.combined_paf);
        state.rows[block].swap(first, second);
        let new_block = block_paf(&state.rows[block]);
        for shift in 0..SHIFTS {
            state.combined_paf[shift] += new_block[shift] - old_block[shift];
        }
        let new_exact = exact_score(&state.combined_paf);
        let new_objective = objective::<GUIDED>(&state.combined_paf);
        let phase = mutation & 0x3ffff;
        let temperature = 131_072_u64.saturating_sub(phase >> 1).max(16);
        let worse = new_objective.saturating_sub(old_objective);
        let accept = new_objective <= old_objective
            || next_random(&mut random) % temperature.saturating_add(worse) < temperature;
        if accept {
            state.block_paf[block] = new_block;
            state.score = new_exact;
            accepted += 1;
            if new_exact < best.score {
                best = state;
                if best.score == 0 {
                    break;
                }
            }
            if new_exact < best_mod18.score && is_mod18_shell(&state.combined_paf) {
                best_mod18 = state;
            }
        } else {
            state.rows[block].swap(first, second);
            state.score = old_exact;
            for shift in 0..SHIFTS {
                state.combined_paf[shift] -= new_block[shift] - old_block[shift];
            }
        }
    }
    let exact_hit = best.score == 0 && direct_exact_replay(&best.rows);
    Q29AnnealReport {
        seed,
        mutations,
        accepted,
        best_score_y: best.score,
        best_score_x: 16 * best.score,
        best_mod18_score_y: best_mod18.score,
        exact_hit,
        guided: GUIDED,
        combined_paf: best.combined_paf,
        rows: best.rows,
        provenance: "HeuristicSearch; scores labeled y for targets (505,-18), x=16*y for outer x=2y; seed directly replayed mod18; mutations may leave shell; exact hits directly replayed",
    }
}

#[inline(always)]
fn block_paf(row: &[i8; ORDER]) -> [i32; SHIFTS] {
    let mut output = [0_i32; SHIFTS];
    for shift in 0..SHIFTS {
        for point in 0..ORDER {
            output[shift] += i32::from(row[point]) * i32::from(row[(point + shift) % ORDER]);
        }
    }
    output
}

#[inline(always)]
fn exact_score(paf: &[i32; SHIFTS]) -> u64 {
    let mut score = u64::from((paf[0] - 505).unsigned_abs()).pow(2);
    for &value in &paf[1..] {
        score += u64::from((value + 18).unsigned_abs()).pow(2);
    }
    score
}

#[inline(always)]
fn objective<const GUIDED: bool>(paf: &[i32; SHIFTS]) -> u64 {
    let exact = exact_score(paf);
    if !GUIDED {
        return exact;
    }
    let mut modular = 0_u64;
    for (shift, &value) in paf.iter().enumerate() {
        let target = i32::from(shift == 0);
        let residue = (value - target).rem_euclid(18);
        let distance = residue.min(18 - residue);
        modular += u64::from(distance.unsigned_abs()).pow(2);
    }
    exact + 256 * modular
}

#[inline(always)]
fn is_mod18_shell(paf: &[i32; SHIFTS]) -> bool {
    paf.iter()
        .enumerate()
        .all(|(shift, &value)| value.rem_euclid(18) == i32::from(shift == 0))
}

fn direct_exact_replay(rows: &[[i8; ORDER]; BLOCKS]) -> bool {
    for block in 0..BLOCKS {
        let sum = rows[block]
            .iter()
            .map(|&value| i32::from(value))
            .sum::<i32>();
        if sum != i32::from(block == 0) {
            return false;
        }
    }
    let state = Q29AnnealState::from_rows(*rows);
    state.combined_paf[0] == 505 && state.combined_paf[1..].iter().all(|&value| value == -18)
}

#[inline(always)]
fn next_random(state: &mut u64) -> u64 {
    *state ^= *state << 13;
    *state ^= *state >> 7;
    *state ^= *state << 17;
    *state
}

#[must_use]
pub fn retained_mod18_seed_16114() -> [[i8; ORDER]; BLOCKS] {
    tests_seed()
}

#[must_use]
pub fn retained_mod18_seed_17737406() -> [[i8; ORDER]; BLOCKS] {
    [
        [
            2, 0, 2, 0, -3, -3, -3, 3, -2, -1, -5, 0, -2, 1, -5, 2, 2, 2, 1, 2, 0, 1, 1, 2, 1, 1,
            2, 0, 0,
        ],
        [
            -2, -2, -1, -1, 0, -2, 0, -1, -2, 0, -1, -2, -1, 0, -2, 0, 0, 0, 0, 0, -1, -2, 7, -1,
            0, 0, 0, 7, 7,
        ],
        [
            -1, 1, -1, -1, 1, 0, 1, 1, 1, 0, -1, -1, 1, 1, 1, -1, 1, 0, 0, 1, -1, -1, 1, 0, 0, -1,
            -1, 0, -1,
        ],
        [
            -1, 1, 1, -1, -9, 1, -1, 1, 1, -1, 1, 0, 0, 0, -1, 0, -1, 1, -1, -1, -1, 1, 1, 1, -1,
            1, -1, 1, 8,
        ],
    ]
}

fn tests_seed() -> [[i8; ORDER]; BLOCKS] {
    [
        [
            -1, -3, -1, 5, -1, 5, -2, 3, 4, 3, -2, -2, 3, 3, 1, -2, -2, -3, -1, -2, -2, -3, -1, -3,
            -2, -3, -2, 6, 6,
        ],
        [
            1, -1, 1, -1, -1, 1, 1, -1, -1, 0, 1, 0, 0, 0, 1, 0, -1, -1, 0, 1, -1, 1, 1, 1, 0, -1,
            1, -1, -1,
        ],
        [
            0, 1, -1, 1, 0, -1, -1, 0, 0, 0, 0, 0, 0, -1, 1, 0, 1, 0, 0, 0, -1, 0, 0, 0, 1, 0, 1,
            0, -1,
        ],
        [
            -8, -1, -8, 1, 1, 1, -1, 0, 1, 0, 1, 0, 0, 1, 1, 0, 1, 0, -1, 0, -1, 0, 1, -1, 1, 1, 1,
            1, 8,
        ],
    ]
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::allocation_test::tracked_allocations;

    #[test]
    fn retained_seed_is_a_mod18_shell_with_score_53784() {
        let state = Q29AnnealState::from_rows(retained_seed());
        assert!(is_mod18_shell(&state.combined_paf));
        assert_eq!(state.score, 53_784);
    }

    #[test]
    fn improved_retained_seed_is_a_mod18_shell_with_score_23976() {
        let state = Q29AnnealState::from_rows(retained_mod18_seed_17737406());
        assert!(is_mod18_shell(&state.combined_paf));
        assert_eq!(state.score, 23_976);
        assert_eq!(
            q29_mod18_shell_level(&state.rows),
            Some(Q29Mod18ShellLevel {
                level: 37,
                exact_score_y: 23_976,
                exact_score_x: 383_616,
            })
        );
    }

    #[test]
    fn shell_score_units_and_structural_gap_are_exact() {
        let rows = retained_seed();
        let shell = q29_mod18_shell_level(&rows).unwrap();
        assert_eq!(shell.level, 83);
        assert_eq!(shell.exact_score_y, 53_784);
        assert_eq!(shell.exact_score_x, 16 * shell.exact_score_y);
        assert_eq!(shell.exact_score_y, 648 * shell.level);
    }

    #[test]
    fn anneal_hot_loop_allocates_nothing() {
        let rows = retained_seed();
        let (_, allocations) = tracked_allocations(|| {
            let report = anneal_q29_from_mod18::<true>(&rows, 0x1234_5678, 100_000);
            assert!(report.best_score_y <= 53_784);
            assert_eq!(report.best_score_x, 16 * report.best_score_y);
        });
        assert_eq!(allocations, 0);
    }

    pub(crate) fn retained_seed() -> [[i8; ORDER]; BLOCKS] {
        [
            [
                -1, -3, -1, 5, -1, 5, -2, 3, 4, 3, -2, -2, 3, 3, 1, -2, -2, -3, -1, -2, -2, -3, -1,
                -3, -2, -3, -2, 6, 6,
            ],
            [
                1, -1, 1, -1, -1, 1, 1, -1, -1, 0, 1, 0, 0, 0, 1, 0, -1, -1, 0, 1, -1, 1, 1, 1, 0,
                -1, 1, -1, -1,
            ],
            [
                0, 1, -1, 1, 0, -1, -1, 0, 0, 0, 0, 0, 0, -1, 1, 0, 1, 0, 0, 0, -1, 0, 0, 0, 1, 0,
                1, 0, -1,
            ],
            [
                -8, -1, -8, 1, 1, 1, -1, 0, 1, 0, 1, 0, 0, 1, 1, 0, 1, 0, -1, 0, -1, 0, 1, -1, 1,
                1, 1, 1, 8,
            ],
        ]
    }
}
