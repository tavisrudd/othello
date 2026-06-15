//! Starting positions for play and tests, port of `fixtures.py`.

use crate::core::{square_to_move, Board, BLACK, FULL};

fn sq(name: &str) -> u64 {
    square_to_move(name).expect("valid fixture square")
}

pub fn init_early_game() -> Board {
    let black = sq("D5") | sq("E4");
    let white = sq("D4") | sq("E5");
    Board::new(black, white, BLACK)
}

pub fn init_near_terminal_game_white_win() -> Board {
    let empty = sq("A1") | sq("E1") | sq("A2") | sq("B7") | sq("A8") | sq("B8");
    let black = sq("F1")
        | sq("E2")
        | sq("D3")
        | sq("F3")
        | sq("C4")
        | sq("F4")
        | sq("B5")
        | sq("F5")
        | sq("C6")
        | sq("C7")
        | sq("D7")
        | sq("E7")
        | sq("C8")
        | sq("D8")
        | sq("E8");
    let white = FULL ^ black ^ empty;
    Board::new(black, white, BLACK)
}

pub fn init_near_terminal_game_black_win() -> Board {
    Board::new(0x0DEF_EF23_6143_030F, 0x9010_105C_9CBC_FCE0, BLACK)
}

pub fn init_near_terminal_game_either_can_win() -> Board {
    Board::new(0x0DEF_EF23_6143_032F, 0x9010_105C_9CBC_FCC0, BLACK)
}

/// Named starts for the CLI (--start), sorted (matches Python's `sorted(STARTS)`).
pub const START_NAMES: [&str; 4] = ["black-win", "either", "early", "white-win"];

pub fn start(name: &str) -> Option<Board> {
    match name {
        "early" => Some(init_early_game()),
        "white-win" => Some(init_near_terminal_game_white_win()),
        "black-win" => Some(init_near_terminal_game_black_win()),
        "either" => Some(init_near_terminal_game_either_can_win()),
        _ => None,
    }
}
