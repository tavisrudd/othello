//! Terminal rendering for boards, moves, and scores (ANSI colour), port of
//! `display.py`.

use crate::core::{format_move, format_square, Board, Move, Player, Score, BLACK, PASS};

pub const RESET: &str = "\x1b[0m";
pub const BLACK_DOT_FG: &str = "\x1b[38;5;240m"; // dark grey: black pieces & the word "black"
const WHITE_DOT_FG: &str = "\x1b[38;5;255m"; // bright white: white pieces & the word "white"

/// Green `\u{2022}` marking a legal move (turn-independent), matching
/// `display.py`'s `LEGAL_DOT`; replaces the old per-cell rank/file coordinates.
const LEGAL_DOT: &str = "\x1b[38;5;46m\u{2022}\x1b[0m ";

const EMPTY_CELL: &str = "\x1b[2;38;5;240m\u{00b7}\x1b[0m ";
const BLACK_MARK: &str = "\x1b[38;5;240m\u{2b24}\x1b[0m ";
const WHITE_MARK: &str = "\x1b[38;5;255m\u{2b24}\x1b[0m ";
const BLACK_LAST_MARK: &str = "\x1b[48;5;52m\x1b[38;5;240m\u{2b24}\x1b[0m ";
const WHITE_LAST_MARK: &str = "\x1b[48;5;52m\x1b[38;5;255m\u{2b24}\x1b[0m ";

pub fn format_board(board: &Board, show_valid_moves: bool, last_move: Option<Move>) -> String {
    let actions = if show_valid_moves { board.actions() } else { 0 };
    let last = match last_move {
        Some(m) if m != PASS => Some(m),
        _ => None,
    };

    let mut out = String::new();
    for r in (0..8u32).rev() {
        let mut row: Vec<String> = Vec::with_capacity(8);
        for c in 0..8u32 {
            let sq = r * 8 + c;
            let bit = 1u64 << sq;
            let cell = if last.is_some_and(|m| m & bit != 0) {
                if board.black & bit != 0 {
                    BLACK_LAST_MARK.to_string()
                } else if board.white & bit != 0 {
                    WHITE_LAST_MARK.to_string()
                } else {
                    format!("\x1b[103m{:<2}\x1b[0m", format_square(sq))
                }
            } else if board.black & bit != 0 {
                BLACK_MARK.to_string()
            } else if board.white & bit != 0 {
                WHITE_MARK.to_string()
            } else if actions & bit != 0 {
                LEGAL_DOT.to_string()
            } else {
                EMPTY_CELL.to_string()
            };
            row.push(cell);
        }
        out.push_str(&format!("{:>2}  {}\n", r + 1, row.join(" ")));
    }
    let files: Vec<String> = "ABCDEFGH".chars().map(|f| format!("{f:<2}")).collect();
    out.push_str(&format!("    {}", files.join(" ")));
    out
}

/// The side's name, coloured to match its pieces (black = dark grey 240, white =
/// 255), so "black to move" / "winner: white" read in the piece colours.
pub fn player_name(player: Player) -> String {
    if player == BLACK {
        format!("{BLACK_DOT_FG}black{RESET}")
    } else {
        format!("{WHITE_DOT_FG}white{RESET}")
    }
}

pub fn move_name(mv: Move) -> String {
    if mv == PASS {
        "PASS".to_string()
    } else {
        format_move(mv)
    }
}

pub fn format_score(score: Score) -> String {
    // Black-centred margin: B:+6 = black ahead by 6, W:-4 = white ahead by 4.
    if score > 0 {
        format!("B:{score:+}")
    } else if score < 0 {
        format!("W:{score:+}")
    } else {
        "T:0".to_string()
    }
}
