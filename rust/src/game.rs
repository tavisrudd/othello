//! The generic game interface the engines consume, port of `game.py`.
//!
//! Defines `Depth`, move iteration, the black-centred move-choice rule, and the
//! `Engine` trait every search implements.

use crate::core::{Board, Move, Moves, Score, BLACK, PASS};

/// Remaining plies to search; `None` = search to terminal.
pub type Depth = Option<i32>;
pub type MoveScores = Vec<(Move, Score)>;

/// LSB-first move iteration (matches `core.iter_moves` / the native search).
pub fn iter_moves(mut moves: Moves) -> Vec<Move> {
    let mut out = Vec::with_capacity(moves.count_ones() as usize);
    while moves != 0 {
        let m = moves & moves.wrapping_neg();
        out.push(m);
        moves ^= m;
    }
    out
}

#[inline]
pub fn child_depth(depth: Depth) -> Depth {
    depth.map(|d| d - 1)
}

/// Scores are black-centred: BLACK maximises, WHITE minimises. Returns the
/// *first* move achieving the extreme (matching Python `max`/`min`, which keep
/// the earliest on ties) so self-play is deterministic.
pub fn best_by_side(board: &Board, scores: &[(Move, Score)]) -> Move {
    let mut best = scores[0];
    for &(m, s) in &scores[1..] {
        let better = if board.to_move == BLACK {
            s > best.1
        } else {
            s < best.1
        };
        if better {
            best = (m, s);
        }
    }
    best.0
}

/// An AI that scores the legal moves of a state (black-centred).
///
/// Concrete engines implement `name`, `default_depth`, `value`, and (optionally)
/// `reset`; `scores` and `best_move` are provided and call back into `value`,
/// exactly as the Python `Engine`/`_NativeEngine` do.
pub trait Engine {
    fn name(&self) -> &'static str;
    fn default_depth(&self) -> Depth;

    /// Black-centred value of `board` searched to `depth`.
    fn value(&mut self, board: &Board, depth: Depth) -> Score;

    /// Drop any cached search state. Override if the engine caches.
    fn reset(&mut self) {}

    /// Per-move black-centred scores; errors on a terminal state. Each root
    /// child is searched independently (full window), so every score is exact.
    fn scores(&mut self, board: &Board, depth: Depth) -> Result<MoveScores, String> {
        if board.is_terminal() {
            return Err(format!("{}: no scores for a terminal state", self.name()));
        }
        let child = child_depth(depth);
        let moves = board.actions();
        let mut out = MoveScores::new();
        if moves == 0 {
            // forced pass (non-terminal): one child
            let nb = board.make_move_unchecked(PASS);
            out.push((PASS, self.value(&nb, child)));
        } else {
            let mut mm = moves;
            while mm != 0 {
                let m = mm & mm.wrapping_neg();
                mm ^= m;
                let nb = board.make_move_unchecked(m);
                out.push((m, self.value(&nb, child)));
            }
        }
        Ok(out)
    }

    fn best_move(&mut self, board: &Board, depth: Depth) -> Result<Move, String> {
        if board.is_terminal() {
            return Err(format!("{}: no move from terminal state", self.name()));
        }
        let scored = self.scores(board, depth)?;
        Ok(best_by_side(board, &scored))
    }
}
