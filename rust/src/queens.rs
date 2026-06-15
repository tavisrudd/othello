//! The adversarial **Non-Attacking Queens** game (Noon & Van Brummelen, 2006).
//!
//! Two players alternately place a queen on an `n×n` board so that no two queens
//! attack each other (no shared row, column, or diagonal). A player who cannot
//! move loses -- equivalently, the player who places the queen that leaves every
//! remaining square attacked wins. It is a *combinatorial* game: perfect
//! information, no chance, normal play (last to move wins).
//!
//! The game is **impartial** -- a queen is colourless, so the set of legal moves
//! depends only on the position, not on whose turn it is. The position itself is
//! captured entirely by the **blocked mask** (squares occupied or attacked):
//! placing a queen on square `s` always adds the same `attack(s)`, so any two
//! move orders reaching the same blocked mask are identical for all future play.
//! That collapses the game to a negamax over a single `u64`, with transpositions
//! merged by memoising on the mask. Bit `r*n + c` is the square at row `r`,
//! column `c` (`0`-indexed); boards up to `8×8` fit in 64 bits.

use std::collections::HashMap;

/// Perfect-play value of a position: whether the player to move wins, and the
/// number of further plies the game lasts under optimal play (win as fast as
/// possible, lose as slowly as possible -- a genuine adversary).
#[derive(Clone, Copy, PartialEq, Eq, Debug)]
pub struct Outcome {
    pub win: bool,
    pub plies: u32,
}

/// An `n×n` Non-Attacking Queens game: board geometry + per-square attack masks.
pub struct Queens {
    pub n: u32,
    board: u64,       // the n*n playable squares
    attack: Vec<u64>, // attack[s] = s plus its row/col/diagonals (self-blocking)
}

impl Queens {
    /// Build the geometry for an `n×n` board (`1 <= n <= 8`).
    pub fn new(n: u32) -> Self {
        assert!(
            (1..=8).contains(&n),
            "board side must be 1..=8 (fits in u64)"
        );
        let mut board = 0u64;
        for r in 0..n {
            for c in 0..n {
                board |= 1u64 << (r * n + c);
            }
        }
        let mut attack = vec![0u64; (n * n) as usize];
        for r in 0..n {
            for c in 0..n {
                let mut mask = 0u64;
                for rr in 0..n {
                    for cc in 0..n {
                        // share a row, column, or either diagonal (includes self)
                        if rr == r
                            || cc == c
                            || rr as i32 - cc as i32 == r as i32 - c as i32
                            || rr + cc == r + c
                        {
                            mask |= 1u64 << (rr * n + cc);
                        }
                    }
                }
                attack[(r * n + c) as usize] = mask;
            }
        }
        Queens { n, board, attack }
    }

    /// Square index from `(row, col)`, both `0`-indexed.
    #[inline]
    pub fn square(&self, row: u32, col: u32) -> u32 {
        row * self.n + col
    }

    /// The squares still available to place a queen on, given the blocked mask.
    #[inline]
    pub fn available(&self, blocked: u64) -> u64 {
        self.board & !blocked
    }

    /// The squares a queen on `sq` attacks (and occupies) -- what placing it adds
    /// to the blocked mask.
    #[inline]
    pub fn attack_of(&self, sq: u32) -> u64 {
        self.attack[sq as usize]
    }

    /// Place a queen on `sq`, returning the new blocked mask.
    #[inline]
    pub fn place(&self, blocked: u64, sq: u32) -> u64 {
        blocked | self.attack[sq as usize]
    }

    /// Perfect-play value of the position with this `blocked` mask, memoised.
    pub fn solve(&self, blocked: u64, memo: &mut HashMap<u64, Outcome>) -> Outcome {
        if let Some(&o) = memo.get(&blocked) {
            return o;
        }
        let mut avail = self.available(blocked);
        if avail == 0 {
            return Outcome {
                win: false,
                plies: 0,
            }; // to-move cannot move -> loses
        }
        let mut best: Option<Outcome> = None;
        while avail != 0 {
            let bit = avail & avail.wrapping_neg();
            avail ^= bit;
            let sq = bit.trailing_zeros();
            let child = self.solve(blocked | self.attack[sq as usize], memo);
            // Our move wins iff it hands the opponent a lost position.
            let mine = Outcome {
                win: !child.win,
                plies: child.plies + 1,
            };
            best = Some(match best {
                None => mine,
                Some(b) => better(b, mine),
            });
        }
        let out = best.unwrap();
        memo.insert(blocked, out);
        out
    }

    /// The optimal move (square) and its value, or `None` if no move exists.
    pub fn best_move(
        &self,
        blocked: u64,
        memo: &mut HashMap<u64, Outcome>,
    ) -> Option<(u32, Outcome)> {
        let mut avail = self.available(blocked);
        if avail == 0 {
            return None;
        }
        let mut best: Option<(u32, Outcome)> = None;
        while avail != 0 {
            let bit = avail & avail.wrapping_neg();
            avail ^= bit;
            let sq = bit.trailing_zeros();
            let child = self.solve(blocked | self.attack[sq as usize], memo);
            let mine = Outcome {
                win: !child.win,
                plies: child.plies + 1,
            };
            best = Some(match best {
                None => (sq, mine),
                Some((bs, bo)) => {
                    if better(bo, mine) == mine && mine != bo {
                        (sq, mine)
                    } else {
                        (bs, bo)
                    }
                }
            });
        }
        best
    }

    /// The full principal variation from the empty board: the optimal line both
    /// sides play, as a list of squares.
    pub fn principal_variation(&self) -> Vec<u32> {
        let mut memo = HashMap::new();
        let mut blocked = 0u64;
        let mut line = Vec::new();
        while let Some((sq, _)) = self.best_move(blocked, &mut memo) {
            line.push(sq);
            blocked = self.place(blocked, sq);
        }
        line
    }
}

/// Pick the better of two outcomes *for the side to move*: prefer a win; among
/// wins take the fastest (fewest plies); among losses take the slowest.
#[inline]
fn better(a: Outcome, b: Outcome) -> Outcome {
    match (a.win, b.win) {
        (true, false) => a,
        (false, true) => b,
        (true, true) => {
            if b.plies < a.plies {
                b
            } else {
                a
            }
        }
        (false, false) => {
            if b.plies > a.plies {
                b
            } else {
                a
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    /// On tiny boards the first move already attacks the whole board, so the
    /// first player wins in a single ply.
    #[test]
    fn small_boards_first_player_wins_in_one() {
        for n in 1..=3 {
            let q = Queens::new(n);
            let mut memo = HashMap::new();
            let o = q.solve(0, &mut memo);
            assert!(o.win, "n={n}: first player should win");
            assert_eq!(o.plies, 1, "n={n}: a single placement clears the board");
        }
    }

    /// A queen attacks its whole row, column, and both diagonals.
    #[test]
    fn attack_mask_covers_lines() {
        let q = Queens::new(8);
        let d4 = q.square(3, 3);
        let a = q.attack_of(d4);
        assert_ne!(a & (1 << q.square(3, 7)), 0, "same row");
        assert_ne!(a & (1 << q.square(0, 3)), 0, "same column");
        assert_ne!(a & (1 << q.square(0, 0)), 0, "main diagonal");
        assert_ne!(a & (1 << q.square(6, 0)), 0, "anti-diagonal");
        assert_eq!(a & (1 << q.square(1, 0)), 0, "a knight's move away is safe");
    }

    /// The solver agrees with itself: the PV length matches the root value's
    /// ply count, and each move in the PV is legal when played.
    #[test]
    fn pv_is_consistent_with_root_value() {
        for n in 1..=8 {
            let q = Queens::new(n);
            let mut memo = HashMap::new();
            let root = q.solve(0, &mut memo);
            let pv = q.principal_variation();
            assert_eq!(
                pv.len() as u32,
                root.plies,
                "n={n}: PV length == root plies"
            );
            // The winner is the side that made the last move iff plies is odd.
            assert_eq!(root.win, pv.len() % 2 == 1, "n={n}: parity of the win");
            // Replay: each move must be on an available square.
            let mut blocked = 0u64;
            for &sq in &pv {
                assert_ne!(q.available(blocked) & (1 << sq), 0, "n={n}: legal move");
                blocked = q.place(blocked, sq);
            }
            assert_eq!(q.available(blocked), 0, "n={n}: board fully blocked at end");
        }
    }
}
