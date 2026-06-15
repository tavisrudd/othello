//! Drive a self-play game with a chosen engine, printing each turn. Port of
//! `play.py`.

use crate::core::{winner, Board, Move};
use crate::display::{format_board, format_score, move_name, player_name, BLACK_DOT_FG, RESET};
use crate::game::{best_by_side, Depth, Engine};

pub fn play_game(mut board: Board, engine: &mut dyn Engine, depth: Depth) -> Board {
    let mut last_move: Option<Move> = None;
    let mut turn = 1;

    while !board.is_terminal() {
        println!();
        println!("turn {turn}: {} to move", player_name(board.to_move));
        println!("{}", format_board(&board, true, last_move));

        let scored = engine.scores(&board, depth).expect("non-terminal");
        for &(mv, score) in &scored {
            let text = format_score(score);
            let text = if score > 0 {
                format!("{BLACK_DOT_FG}{text}{RESET}") // black-favouring
            } else {
                text
            };
            println!("{:>4} {text}", move_name(mv));
        }

        let best = best_by_side(&board, &scored);
        println!("best: {}", move_name(best));

        board = board.make_move(best).expect("best move is legal");
        last_move = Some(best);
        turn += 1;
    }

    println!();
    println!("terminal");
    println!("{}", format_board(&board, false, last_move));
    println!("black: {}", board.black.count_ones());
    println!("white: {}", board.white.count_ones());
    match winner(&board) {
        None => println!("winner: draw"),
        Some(p) => println!("winner: {}", player_name(p)),
    }
    board
}
