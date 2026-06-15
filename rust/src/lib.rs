//! Pure-Rust 8x8 Othello: game core plus interchangeable AI engines.
//!
//! A parallel implementation of the Python `othello` package: the same
//! bitboard rules, black-centred search, and engine ladder (`minimax`,
//! `alphabeta`, `ordered`, and `strong` -- the equivalent of `cython-strong`:
//! PVS + iterative deepening + an open-addressing transposition table).
//!
//! ```
//! use othello::{init_early_game, make_engine};
//! let mut engine = make_engine("strong").unwrap();
//! let board = init_early_game();
//! let best = engine.best_move(&board, Some(8)).unwrap();
//! assert!(best != 0);
//! ```

pub mod cli;
pub mod core;
pub mod display;
pub mod engines;
pub mod eval;
pub mod fixtures;
pub mod game;
pub mod play;
pub mod search;
pub mod simd;
pub mod tt;

pub use core::{
    flips_for_move, format_move, format_square, legal_moves, move_to_square, parse_board,
    parse_move, parse_square_name, square_to_move, winner, Board, Move, Moves, Player, Score,
    Square, BLACK, FULL, MAX_SCORE, MIN_SCORE, PASS, WHITE,
};
pub use display::{format_board, format_score, move_name, player_name};
pub use engines::{make_engine, AlphaBeta, Minimax, Strong, ENGINE_NAMES};
pub use eval::{heuristic, utility};
pub use fixtures::{
    init_early_game, init_near_terminal_game_black_win, init_near_terminal_game_either_can_win,
    init_near_terminal_game_white_win, start, START_NAMES,
};
pub use game::{best_by_side, child_depth, iter_moves, Depth, Engine, MoveScores};
pub use play::{play_game, record_game, render_recorded, RecordedGame};
pub use tt::TranspositionTable;
