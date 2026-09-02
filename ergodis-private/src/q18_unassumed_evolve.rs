//! Discovery-only evolution of unrestricted q18 compressed GS roots.
//!
//! This search assumes no multiplier or reflection.  Any hit is replayed by
//! the direct q18 verifier before it is reported; a miss has no proof role.

use serde::Serialize;

use crate::q18_pair_split::{
    verify_q18_gs_reduction, Q18Coefficients, Q18DivisorProjection, Q18PairSplit,
};

const BLOCKS: usize = 4;
const ORDER: usize = 18;
const INDEPENDENT_SHIFTS: usize = 10;
const LATE_WINDOW: usize = 8_192;
const TABU_WINDOW: usize = 32;
const REHEAT_INTERVAL: u64 = 1 << 20;
const KICK_MOVES: usize = 8;
const TARGET: [i32; INDEPENDENT_SHIFTS] =
    [1_976, -116, -116, -116, -116, -116, -116, -116, -116, -116];

#[repr(C, align(64))]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Q18EvolveState {
    pub coefficients: Q18Coefficients,
    block_paf: [[i32; INDEPENDENT_SHIFTS]; BLOCKS],
    combined_paf: [i32; INDEPENDENT_SHIFTS],
    score: u64,
    _padding: [u8; 8],
}

const _: () = assert!(std::mem::size_of::<Q18EvolveState>() == 384);
const _: () = assert!(std::mem::align_of::<Q18EvolveState>() == 64);

#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq)]
pub struct Q18EvolveReport {
    pub seed: u64,
    pub mutations: u64,
    pub accepted: u64,
    pub best_score: u64,
    pub exact_hit: bool,
    pub best_combined_paf: [i32; INDEPENDENT_SHIFTS],
    pub best_coefficients: [[i8; ORDER]; BLOCKS],
    pub provenance: &'static str,
}

impl Q18EvolveState {
    #[must_use]
    pub fn seeded(mut seed: u64) -> Self {
        let mut coefficients = Q18Coefficients {
            blocks: [[-1; ORDER]; BLOCKS],
        };
        for block in 0..BLOCKS {
            let positives = if block == 0 { 10 } else { 9 };
            let mut permutation = std::array::from_fn::<_, ORDER, _>(|index| index as u8);
            for tail in (1..ORDER).rev() {
                let swap = (next_random(&mut seed) as usize) % (tail + 1);
                permutation.swap(tail, swap);
            }
            for &point in &permutation[..positives] {
                coefficients.blocks[block][usize::from(point)] = 1;
            }
        }
        Self::from_coefficients(coefficients)
    }

    #[must_use]
    pub fn from_coefficients(coefficients: Q18Coefficients) -> Self {
        let mut state = Self {
            coefficients,
            block_paf: [[0; INDEPENDENT_SHIFTS]; BLOCKS],
            combined_paf: [0; INDEPENDENT_SHIFTS],
            score: 0,
            _padding: [0; 8],
        };
        for block in 0..BLOCKS {
            state.block_paf[block] = block_paf(&state.coefficients.blocks[block]);
            for shift in 0..INDEPENDENT_SHIFTS {
                state.combined_paf[shift] += state.block_paf[block][shift];
            }
        }
        state.score = score(&state.combined_paf);
        state
    }

    #[must_use]
    pub const fn score(&self) -> u64 {
        self.score
    }
}

/// Run one bounded allocation-free mutation stream.
#[must_use]
pub fn evolve_q18_unassumed(seed: u64, mutations: u64) -> Q18EvolveReport {
    let mut random = seed;
    let mut state = Q18EvolveState::seeded(next_random(&mut random));
    let mut best = state.coefficients;
    let mut best_score = state.score;
    let mut accepted = 0_u64;

    for mutation in 0..mutations {
        let phase = mutation & 0xffff;
        let block = (next_random(&mut random) as usize) & 3;
        let first = (next_random(&mut random) as usize) % ORDER;
        let mut second = (next_random(&mut random) as usize) % (ORDER - 1);
        if second >= first {
            second += 1;
        }
        let direction = if next_random(&mut random) & 1 == 0 {
            2_i8
        } else {
            -2_i8
        };
        let first_value = state.coefficients.blocks[block][first];
        let second_value = state.coefficients.blocks[block][second];
        if !(-29..=29).contains(&(first_value + direction))
            || !(-29..=29).contains(&(second_value - direction))
        {
            continue;
        }

        let old_block = state.block_paf[block];
        let old_score = state.score;
        state.coefficients.blocks[block][first] += direction;
        state.coefficients.blocks[block][second] -= direction;
        let new_block = block_paf(&state.coefficients.blocks[block]);
        for shift in 0..INDEPENDENT_SHIFTS {
            state.combined_paf[shift] += new_block[shift] - old_block[shift];
        }
        let new_score = score(&state.combined_paf);
        let worse = new_score.saturating_sub(old_score);
        let temperature = 8_192_u64.saturating_sub(phase >> 3).max(8);
        let accept = new_score <= old_score
            || next_random(&mut random) % temperature.saturating_add(worse) < temperature;
        if accept {
            state.block_paf[block] = new_block;
            state.score = new_score;
            accepted += 1;
            if new_score < best_score {
                best_score = new_score;
                best = state.coefficients;
                if best_score == 0 {
                    break;
                }
            }
        } else {
            state.coefficients.blocks[block][first] = first_value;
            state.coefficients.blocks[block][second] = second_value;
            for shift in 0..INDEPENDENT_SHIFTS {
                state.combined_paf[shift] -= new_block[shift] - old_block[shift];
            }
        }
    }

    let best_state = Q18EvolveState::from_coefficients(best);
    let exact_hit = if best_score == 0 {
        let mut split = Q18PairSplit::ZERO;
        let mut projection = Q18DivisorProjection::ZERO;
        verify_q18_gs_reduction(&best, &mut split, &mut projection).is_ok()
    } else {
        false
    };
    Q18EvolveReport {
        seed,
        mutations,
        accepted,
        best_score,
        exact_hit,
        best_combined_paf: best_state.combined_paf,
        best_coefficients: best.blocks,
        provenance:
            "ObservedEvolved; misses have no pruning authority; exact hits directly replayed",
    }
}

/// Continue from a retained near miss with bounded late acceptance and tabu.
///
/// This is discovery-only.  The late-score ring, tabu ring, and all candidate
/// state are fixed-size stack data.  Every proposal changes one block, whose
/// PAF is recomputed from the actually modified word before acceptance.  An
/// exact hit is accepted only after the independent q18 reduction replay.
#[must_use]
pub fn evolve_q18_basin_escape(
    base: &Q18Coefficients,
    seed: u64,
    mutations: u64,
) -> Q18EvolveReport {
    let mut random = seed;
    let mut state = Q18EvolveState::from_coefficients(*base);
    let mut best = state.coefficients;
    let mut best_score = state.score;
    state = kicked_state(best, &mut random);
    let initial_ceiling = state.score.saturating_add(4_096);
    let mut late_scores = [initial_ceiling; LATE_WINDOW];
    let mut tabu = [u16::MAX; TABU_WINDOW];
    let mut tabu_cursor = 0_usize;
    let mut accepted = 0_u64;
    let mut last_improvement = 0_u64;

    for mutation in 0..mutations {
        if mutation.saturating_sub(last_improvement) == REHEAT_INTERVAL {
            state = kicked_state(best, &mut random);
            let ceiling = state.score.saturating_add(4_096);
            late_scores.fill(ceiling);
            tabu.fill(u16::MAX);
            last_improvement = mutation;
        }

        let block = (next_random(&mut random) as usize) & 3;
        let first = (next_random(&mut random) as usize) % ORDER;
        let mut second = (next_random(&mut random) as usize) % (ORDER - 1);
        if second >= first {
            second += 1;
        }
        let direction = if next_random(&mut random) & 1 == 0 {
            2_i8
        } else {
            -2_i8
        };
        let first_value = state.coefficients.blocks[block][first];
        let second_value = state.coefficients.blocks[block][second];
        if !(-29..=29).contains(&(first_value + direction))
            || !(-29..=29).contains(&(second_value - direction))
        {
            continue;
        }

        let move_code = encode_move(block, first, second, direction);
        let reverse_code = encode_move(block, first, second, -direction);
        let old_block = state.block_paf[block];
        let old_score = state.score;
        state.coefficients.blocks[block][first] += direction;
        state.coefficients.blocks[block][second] -= direction;
        let new_block = block_paf(&state.coefficients.blocks[block]);
        for shift in 0..INDEPENDENT_SHIFTS {
            state.combined_paf[shift] += new_block[shift] - old_block[shift];
        }
        let new_score = score(&state.combined_paf);
        let late_slot = mutation as usize & (LATE_WINDOW - 1);
        let is_tabu = tabu.contains(&move_code);
        let accept = new_score < best_score
            || (!is_tabu && (new_score <= old_score || new_score <= late_scores[late_slot]));
        if accept {
            state.block_paf[block] = new_block;
            state.score = new_score;
            late_scores[late_slot] = new_score;
            tabu[tabu_cursor] = reverse_code;
            tabu_cursor = (tabu_cursor + 1) & (TABU_WINDOW - 1);
            accepted += 1;
            if new_score < best_score {
                best_score = new_score;
                best = state.coefficients;
                last_improvement = mutation;
                if best_score == 0 {
                    break;
                }
            }
        } else {
            state.coefficients.blocks[block][first] = first_value;
            state.coefficients.blocks[block][second] = second_value;
            for shift in 0..INDEPENDENT_SHIFTS {
                state.combined_paf[shift] -= new_block[shift] - old_block[shift];
            }
            late_scores[late_slot] = old_score;
        }
    }

    report_from_best(seed, mutations, accepted, best_score, best)
}

fn kicked_state(best: Q18Coefficients, random: &mut u64) -> Q18EvolveState {
    let mut kicked = best;
    let mut applied = 0_usize;
    for _ in 0..(KICK_MOVES * 8) {
        let block = (next_random(random) as usize) & 3;
        let first = (next_random(random) as usize) % ORDER;
        let mut second = (next_random(random) as usize) % (ORDER - 1);
        if second >= first {
            second += 1;
        }
        let direction = if next_random(random) & 1 == 0 {
            2_i8
        } else {
            -2_i8
        };
        if (-29..=29).contains(&(kicked.blocks[block][first] + direction))
            && (-29..=29).contains(&(kicked.blocks[block][second] - direction))
        {
            kicked.blocks[block][first] += direction;
            kicked.blocks[block][second] -= direction;
            applied += 1;
            if applied == KICK_MOVES {
                break;
            }
        }
    }
    Q18EvolveState::from_coefficients(kicked)
}

#[inline(always)]
fn encode_move(block: usize, first: usize, second: usize, direction: i8) -> u16 {
    (((block * ORDER + first) * ORDER + second) * 2 + usize::from(direction > 0)) as u16
}

fn report_from_best(
    seed: u64,
    mutations: u64,
    accepted: u64,
    best_score: u64,
    best: Q18Coefficients,
) -> Q18EvolveReport {
    let best_state = Q18EvolveState::from_coefficients(best);
    let exact_hit = if best_score == 0 {
        let mut split = Q18PairSplit::ZERO;
        let mut projection = Q18DivisorProjection::ZERO;
        verify_q18_gs_reduction(&best, &mut split, &mut projection).is_ok()
    } else {
        false
    };
    Q18EvolveReport {
        seed,
        mutations,
        accepted,
        best_score,
        exact_hit,
        best_combined_paf: best_state.combined_paf,
        best_coefficients: best.blocks,
        provenance:
            "ObservedEvolvedBasinEscape; misses have no pruning authority; exact hits directly replayed",
    }
}

#[inline(always)]
fn block_paf(coefficients: &[i8; ORDER]) -> [i32; INDEPENDENT_SHIFTS] {
    let mut output = [0_i32; INDEPENDENT_SHIFTS];
    for shift in 0..INDEPENDENT_SHIFTS {
        for point in 0..ORDER {
            output[shift] +=
                i32::from(coefficients[point]) * i32::from(coefficients[(point + shift) % ORDER]);
        }
    }
    output
}

#[inline(always)]
fn score(paf: &[i32; INDEPENDENT_SHIFTS]) -> u64 {
    let mut total = 0_u64;
    for shift in 0..INDEPENDENT_SHIFTS {
        total += u64::from((paf[shift] - TARGET[shift]).unsigned_abs()).pow(2);
    }
    total
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

    #[test]
    fn incremental_mutation_stream_preserves_rows_and_report_score() {
        let report = evolve_q18_unassumed(0x1234_5678_9abc_def0, 10_000);
        let state = Q18EvolveState::from_coefficients(Q18Coefficients {
            blocks: report.best_coefficients,
        });
        assert_eq!(state.score(), report.best_score);
        assert_eq!(
            report.best_coefficients[0]
                .iter()
                .map(|&x| i32::from(x))
                .sum::<i32>(),
            2
        );
        for block in 1..BLOCKS {
            assert_eq!(
                report.best_coefficients[block]
                    .iter()
                    .map(|&x| i32::from(x))
                    .sum::<i32>(),
                0
            );
        }
    }

    #[test]
    fn mutation_loop_allocates_nothing() {
        let (_, allocations) = tracked_allocations(|| {
            let report = evolve_q18_unassumed(0xfedc_ba98_7654_3210, 100_000);
            assert!(report.best_score > 0 || report.exact_hit);
        });
        assert_eq!(allocations, 0);
    }

    #[test]
    fn basin_escape_preserves_retained_score_and_rows() {
        let base = Q18EvolveState::seeded(0x1020_3040_5060_7080).coefficients;
        let report = evolve_q18_basin_escape(&base, 0xa5a5_5a5a_d3c3_b4b4, 20_000);
        let replay = Q18EvolveState::from_coefficients(Q18Coefficients {
            blocks: report.best_coefficients,
        });
        assert_eq!(replay.score(), report.best_score);
        assert!(report.best_score <= Q18EvolveState::from_coefficients(base).score());
        assert_eq!(
            report.best_coefficients[0]
                .iter()
                .map(|&x| i32::from(x))
                .sum::<i32>(),
            2
        );
        for block in 1..BLOCKS {
            assert_eq!(
                report.best_coefficients[block]
                    .iter()
                    .map(|&x| i32::from(x))
                    .sum::<i32>(),
                0
            );
        }
    }

    #[test]
    fn basin_escape_loop_allocates_nothing() {
        let base = Q18EvolveState::seeded(0x0123_4567_89ab_cdef).coefficients;
        let (_, allocations) = tracked_allocations(|| {
            let report = evolve_q18_basin_escape(&base, 0x55aa_33cc_77ee_11ff, 100_000);
            assert!(report.best_score > 0 || report.exact_hit);
        });
        assert_eq!(allocations, 0);
    }
}
