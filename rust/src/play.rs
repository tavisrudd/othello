//! Drive a self-play game with a chosen engine, printing each turn. Port of
//! `play.py`.
//!
//! `play_game` renders live (the CLI). For *benchmarking* the search without
//! per-turn TTY cost skewing the timing, `record_game` plays the whole game into
//! a move arena with no I/O (instrumented with `tracing` spans), and
//! `render_recorded` replays it to a writer afterwards (flushing in batches if
//! rendering ever exceeds ~100 ms).

use std::io::Write;
use std::time::{Duration, Instant};

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

/// A finished game buffered as just its start position + move sequence (the
/// "arena"). Cheap to hold and enough to replay/render any turn.
pub struct RecordedGame {
    pub start: Board,
    pub moves: Vec<Move>,
}

impl RecordedGame {
    pub fn terminal(&self) -> Board {
        let mut b = self.start;
        for &mv in &self.moves {
            b = b.make_move_unchecked(mv);
        }
        b
    }
}

/// Play a full game with **no I/O**, buffering moves into an arena. The hot path
/// is the search only, so timing it is clean. `tracing` spans (`game`, and a
/// `search` span per move) make the per-move cost visible to a subscriber.
pub fn record_game(start: Board, engine: &mut dyn Engine, depth: Depth) -> RecordedGame {
    let _game = tracing::info_span!("game", ?depth).entered();
    let mut board = start;
    let mut moves = Vec::new();
    let mut turn = 1u32;
    while !board.is_terminal() {
        let empties = board.empty().count_ones();
        let span = tracing::info_span!("search", turn, empties);
        let best = span.in_scope(|| engine.best_move(&board, depth).expect("non-terminal"));
        board = board.make_move(best).expect("best move is legal");
        moves.push(best);
        turn += 1;
    }
    RecordedGame { start, moves }
}

/// Replay a `RecordedGame` to `out`, rendering each turn. Accumulates into a
/// String arena and flushes in batches whenever the render has run for more than
/// `batch` (so a huge game never buffers unboundedly or stalls); otherwise it is
/// a single write at the end.
pub fn render_recorded(
    game: &RecordedGame,
    out: &mut impl Write,
    batch: Duration,
) -> std::io::Result<()> {
    let _span = tracing::info_span!("render", moves = game.moves.len()).entered();
    let mut buf = String::new();
    let started = Instant::now();
    let mut board = game.start;
    let mut last: Option<Move> = None;

    for (i, &mv) in game.moves.iter().enumerate() {
        use std::fmt::Write as _;
        let _ = write!(
            buf,
            "\nturn {}: {} to move\n",
            i + 1,
            player_name(board.to_move)
        );
        let _ = writeln!(buf, "{}", format_board(&board, true, last));
        let _ = writeln!(buf, "best: {}", move_name(mv));
        board = board.make_move(mv).expect("recorded move is legal");
        last = Some(mv);
        if started.elapsed() >= batch {
            out.write_all(buf.as_bytes())?;
            buf.clear();
        }
    }

    use std::fmt::Write as _;
    let _ = write!(buf, "\nterminal\n");
    let _ = writeln!(buf, "{}", format_board(&board, false, last));
    let _ = writeln!(buf, "black: {}", board.black.count_ones());
    let _ = writeln!(buf, "white: {}", board.white.count_ones());
    match winner(&board) {
        None => buf.push_str("winner: draw\n"),
        Some(p) => {
            let _ = writeln!(buf, "winner: {}", player_name(p));
        }
    }
    out.write_all(buf.as_bytes())
}
