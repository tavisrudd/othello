//! Position evaluation (kept out of the game core), port of `ai/evaluation.py`.
//!
//! `utility` is the exact terminal disc differential (black-centred); `heuristic`
//! is the depth-limited horizon estimate. The native search inlines the same
//! `heuristic_black` formula, so every engine agrees value-for-value.

use crate::core::{legal_moves, Board, Player, Score, BLACK};

pub const CORNERS: u64 = 0x8100_0000_0000_0081; // A1, H1, A8, H8
pub const CORNER_WEIGHT: i32 = 25;
pub const MOBILITY_WEIGHT: i32 = 5;
pub const DISC_WEIGHT: i32 = 1;

#[inline]
pub fn utility(board: &Board, player: Player) -> Score {
    let diff = board.black.count_ones() as i32 - board.white.count_ones() as i32;
    if player == BLACK {
        diff
    } else {
        -diff
    }
}

/// Black-centred positional estimate: `25*corners + 5*mobility + 1*discs`.
/// Shared by `heuristic` and the native search so the values match exactly.
#[inline]
pub fn heuristic_black(black: u64, white: u64) -> i32 {
    let corner = (black & CORNERS).count_ones() as i32 - (white & CORNERS).count_ones() as i32;
    let mobility = legal_moves(black, white).count_ones() as i32
        - legal_moves(white, black).count_ones() as i32;
    let disc = black.count_ones() as i32 - white.count_ones() as i32;
    CORNER_WEIGHT * corner + MOBILITY_WEIGHT * mobility + DISC_WEIGHT * disc
}

#[inline]
pub fn heuristic(board: &Board, player: Player) -> Score {
    let score = heuristic_black(board.black, board.white);
    if player == BLACK {
        score
    } else {
        -score
    }
}
