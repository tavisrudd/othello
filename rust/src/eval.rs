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

// --------------------------------------------------------------------------- //
// "Plus" evaluation -- a stronger horizon estimate for the `strong+` engine.
//
// Adds the classic Othello positional terms the base eval omits: a penalty for
// sitting on an X- or C-square next to an *empty* corner (it hands the corner to
// the opponent) and a penalty for frontier discs (adjacent to an empty square,
// hence flippable). Same corners / mobility / discs base. These CHANGE the value
// (stronger play), so `strong+` is a distinct engine; `strong` is untouched.
// --------------------------------------------------------------------------- //

const NOT_A: u64 = 0xFEFE_FEFE_FEFE_FEFE;
const NOT_H: u64 = 0x7F7F_7F7F_7F7F_7F7F;

// (corner bit, its X-square bit, its two C-square bits) for the four corners.
const CORNER_DANGER: [(u64, u64, u64); 4] = [
    (1 << 0, 1 << 9, (1 << 1) | (1 << 8)),     // A1 -> B2 ; B1,A2
    (1 << 7, 1 << 14, (1 << 6) | (1 << 15)),   // H1 -> G2 ; G1,H2
    (1 << 56, 1 << 49, (1 << 57) | (1 << 48)), // A8 -> B7 ; B8,A7
    (1 << 63, 1 << 54, (1 << 62) | (1 << 55)), // H8 -> G7 ; G8,H7
];

const X_PENALTY: i32 = 15;
const C_PENALTY: i32 = 6;
const FRONTIER_PENALTY: i32 = 2;

/// `(x_squares, c_squares)` owned by `discs` that sit next to an *empty* corner.
#[inline]
fn corner_danger(discs: u64, empty: u64) -> (i32, i32) {
    let mut x = 0;
    let mut c = 0;
    let mut i = 0;
    while i < 4 {
        let (corner, xsq, csq) = CORNER_DANGER[i];
        if corner & empty != 0 {
            x += (discs & xsq).count_ones() as i32;
            c += (discs & csq).count_ones() as i32;
        }
        i += 1;
    }
    (x, c)
}

/// Discs of `discs` adjacent (8-way) to an empty square — flippable, hence weak.
#[inline]
fn frontier(discs: u64, empty: u64) -> i32 {
    let h = ((empty & NOT_A) >> 1) | ((empty & NOT_H) << 1);
    let spread = empty | h;
    let halo = h | (spread << 8) | (spread >> 8); // all 8 neighbours of every empty
    (discs & halo).count_ones() as i32
}

#[inline]
pub fn heuristic_plus_black(black: u64, white: u64) -> i32 {
    let empty = !(black | white);
    let corner = (black & CORNERS).count_ones() as i32 - (white & CORNERS).count_ones() as i32;
    let mobility = legal_moves(black, white).count_ones() as i32
        - legal_moves(white, black).count_ones() as i32;
    let disc = black.count_ones() as i32 - white.count_ones() as i32;

    let (bx, bc) = corner_danger(black, empty);
    let (wx, wc) = corner_danger(white, empty);
    let frontier_diff = frontier(black, empty) - frontier(white, empty);

    CORNER_WEIGHT * corner + MOBILITY_WEIGHT * mobility + DISC_WEIGHT * disc
        - X_PENALTY * (bx - wx)
        - C_PENALTY * (bc - wc)
        - FRONTIER_PENALTY * frontier_diff
}
