//! The adversarial **Non-Attacking Queens** game (Noon & Van Brummelen, 2006).
//!
//! Two players alternately place a queen on an `n×n` board so that no two queens
//! attack each other (no shared row, column, or diagonal). A player who cannot
//! move loses -- equivalently, the player who places the queen that leaves every
//! remaining square attacked wins. It is a *combinatorial* game: perfect
//! information, no chance, normal play (last to move wins). Formally it is
//! **Node Kayles on the n-queens graph** (deciding the winner is PSPACE-complete,
//! Schaefer 1978), and its Sprague-Grundy value is OEIS A344227.
//!
//! The game is **impartial** -- a queen is colourless, so the legal moves depend
//! only on the position, captured entirely by the **blocked mask** (squares
//! occupied or attacked): placing a queen on `s` always adds the same `attack(s)`,
//! so move orders reaching the same mask are identical for all future play.
//!
//! **Odd boards need no search.** The first player wins by a pairing strategy:
//! take the centre, then answer every reply with its 180° rotation (see
//! `Solver::first_player_wins`). Only *even* boards are searched.
//!
//! ## Solver lineage (mirrors the Othello engine ladder)
//!
//! [`Queens`] is pure geometry; the search is a ladder of [`Solver`]s, each step
//! adding one idea, all computing the *same* win/loss so the simpler ones are
//! kept as ground truth (cross-checked in the tests):
//!
//! | solver       | adds                                                        |
//! |--------------|-------------------------------------------------------------|
//! | [`Naive`]    | plain negamax win/loss with an α-β cutoff, no memo (truth)  |
//! | [`Memo`]     | a fixed-size transposition table keyed on the raw mask      |
//! | [`Symmetry`] | + dihedral (8-fold) canonical keys, merging symmetric states|
//! | [`Parallel`] | + rayon root parallelism (Young-Brothers-Wait) + odd O(1)   |
//!
//! Bit `r*n + c` is the square at row `r`, column `c` (`0`-indexed). The bitset is
//! `WORDS` × 64 bits, so boards up to `16×16` (256 bits) fit.

use std::collections::HashSet;
use std::sync::atomic::{AtomicU64, Ordering};
use std::sync::Mutex;

use rayon::prelude::*;

/// 64-bit words backing the board bitset. 4 words = 256 bits ⇒ up to `n = 16`.
const WORDS: usize = 4;
/// Largest board side the bitset can hold (`n*n <= WORDS*64`).
pub const MAX_N: u32 = 16;

/// A fixed-width board bitset (`WORDS*64` bits). `Ord`/`Hash` are the derived
/// lexicographic order on the words -- a total order, all we need to pick a
/// canonical representative and to key the memo table.
#[derive(Clone, Copy, PartialEq, Eq, Hash, PartialOrd, Ord, Default, Debug)]
pub struct Bits([u64; WORDS]);

impl Bits {
    const ZERO: Bits = Bits([0; WORDS]);

    /// An empty bitset (no bits set).
    #[inline]
    pub fn empty() -> Bits {
        Bits::ZERO
    }
    /// Set bit `i`.
    #[inline]
    pub fn set(&mut self, i: u32) {
        self.0[(i / 64) as usize] |= 1u64 << (i % 64);
    }
    /// Is bit `i` set?
    #[inline]
    pub fn get(self, i: u32) -> bool {
        self.0[(i / 64) as usize] & (1u64 << (i % 64)) != 0
    }
    #[inline]
    fn or(self, o: Bits) -> Bits {
        let mut r = self.0;
        for (rk, &ok) in r.iter_mut().zip(o.0.iter()) {
            *rk |= ok;
        }
        Bits(r)
    }
    #[inline]
    fn popcount(self) -> u32 {
        self.0.iter().map(|w| w.count_ones()).sum()
    }
    /// Call `f` with each set bit index (ascending).
    #[inline]
    fn each<F: FnMut(u32)>(self, mut f: F) {
        for (k, &w) in self.0.iter().enumerate() {
            let mut w = w;
            while w != 0 {
                let b = w.trailing_zeros();
                f(k as u32 * 64 + b);
                w &= w - 1;
            }
        }
    }
}

/// An `n×n` Non-Attacking Queens game: board geometry, per-square attack masks,
/// a forcing static move order, and the board's 8 symmetry permutations. This is
/// pure geometry -- the search lives in the [`Solver`] implementations.
pub struct Queens {
    pub n: u32,
    board: Bits,
    attack: Vec<Bits>,  // attack[s] = s plus its row/col/diagonals (self-blocking)
    order: Vec<u32>,    // squares by descending attack degree (forcing moves first)
    sym: Vec<Vec<u32>>, // sym[t][s] = image of square s under symmetry t (t=0 identity)
}

/// The 8 symmetries of the square applied to `(row, col)` on an `n×n` board.
#[inline]
fn symmetry(t: usize, r: u32, c: u32, n: u32) -> (u32, u32) {
    let (m1, m2) = (n - 1 - r, n - 1 - c);
    match t {
        0 => (r, c),   // identity
        1 => (c, m1),  // rotate 90°
        2 => (m1, m2), // rotate 180°
        3 => (m2, r),  // rotate 270°
        4 => (r, m2),  // flip horizontally
        5 => (m1, c),  // flip vertically
        6 => (c, r),   // transpose (main diagonal)
        _ => (m2, m1), // anti-transpose
    }
}

impl Queens {
    /// Build the geometry for an `n×n` board (`1 <= n <= MAX_N`).
    pub fn new(n: u32) -> Self {
        assert!(
            (1..=MAX_N).contains(&n),
            "board side must be 1..={MAX_N} (n*n must fit in {} bits)",
            WORDS * 64
        );
        let mut board = Bits::ZERO;
        for s in 0..n * n {
            board.set(s);
        }
        let mut attack = vec![Bits::ZERO; (n * n) as usize];
        for r in 0..n {
            for c in 0..n {
                let mut mask = Bits::ZERO;
                for rr in 0..n {
                    for cc in 0..n {
                        // share a row, column, or either diagonal (includes self)
                        if rr == r
                            || cc == c
                            || rr as i32 - cc as i32 == r as i32 - c as i32
                            || rr + cc == r + c
                        {
                            mask.set(rr * n + cc);
                        }
                    }
                }
                attack[(r * n + c) as usize] = mask;
            }
        }
        // Forcing move order: most-blocking squares first ⇒ winning moves (which
        // tend to slam the board shut) surface early, so the α-β cutoff fires.
        let mut order: Vec<u32> = (0..n * n).collect();
        order.sort_by_key(|&s| std::cmp::Reverse(attack[s as usize].popcount()));
        // Symmetry permutations on square indices.
        let sym: Vec<Vec<u32>> = (0..8)
            .map(|t| {
                (0..n * n)
                    .map(|s| {
                        let (r2, c2) = symmetry(t, s / n, s % n, n);
                        r2 * n + c2
                    })
                    .collect()
            })
            .collect();
        Queens {
            n,
            board,
            attack,
            order,
            sym,
        }
    }

    /// Square index from `(row, col)`, both `0`-indexed.
    #[inline]
    pub fn square(&self, row: u32, col: u32) -> u32 {
        row * self.n + col
    }

    /// Is `sq` available (on the board and not yet blocked)?
    #[inline]
    pub fn is_available(&self, blocked: Bits, sq: u32) -> bool {
        self.board.get(sq) && !blocked.get(sq)
    }

    /// Are there no legal moves left for this blocked mask?
    #[inline]
    pub fn no_moves(&self, blocked: Bits) -> bool {
        self.board.or(blocked) == blocked // board ⊆ blocked ⇒ nothing available
    }

    /// Place a queen on `sq`, returning the new blocked mask.
    #[inline]
    pub fn place(&self, blocked: Bits, sq: u32) -> Bits {
        blocked.or(self.attack[sq as usize])
    }

    /// Does the board have a centre square (odd side)?
    #[inline]
    pub fn is_odd(&self) -> bool {
        self.n % 2 == 1
    }

    /// The centre square -- only odd boards have one.
    #[inline]
    pub fn center(&self) -> Option<u32> {
        self.is_odd()
            .then(|| self.square((self.n - 1) / 2, (self.n - 1) / 2))
    }

    /// The 180° rotation of `sq` (point reflection through the board centre).
    #[inline]
    pub fn mirror(&self, sq: u32) -> u32 {
        self.sym[2][sq as usize]
    }

    /// The first available square in forcing order (for the losing side, or to
    /// drive the symmetry line).
    #[inline]
    pub fn first_available(&self, blocked: Bits) -> Option<u32> {
        self.order
            .iter()
            .copied()
            .find(|&s| self.is_available(blocked, s))
    }

    /// The canonical (lexicographically smallest) image of `blocked` under the
    /// board's 8 symmetries -- the memo key, so symmetric positions share.
    fn canon(&self, blocked: Bits) -> Bits {
        let mut best = blocked;
        for t in 1..8 {
            let perm = &self.sym[t];
            let mut img = Bits::ZERO;
            blocked.each(|s| img.set(perm[s as usize]));
            if img < best {
                best = img;
            }
        }
        best
    }

    /// The symmetry-distinct first moves from the empty board: one representative
    /// per orbit of the board's 8 symmetries. Cuts the root branching ~8×.
    pub fn distinct_first_moves(&self) -> Vec<u32> {
        let mut seen = HashSet::new();
        let mut out = Vec::new();
        for &sq in &self.order {
            if self.board.get(sq) && seen.insert(self.canon(self.place(Bits::ZERO, sq))) {
                out.push(sq);
            }
        }
        out
    }

    /// An optimal move for the side to move and whether it wins, using `solver`:
    /// a winning move if one exists, else the first available move (all lose).
    /// `None` if no move exists.
    pub fn best_move(&self, blocked: Bits, solver: &dyn Solver) -> Option<(u32, bool)> {
        let mut first = None;
        for &sq in &self.order {
            if !self.is_available(blocked, sq) {
                continue;
            }
            first.get_or_insert(sq);
            if !solver.wins(self, self.place(blocked, sq)) {
                return Some((sq, true)); // a winning move
            }
        }
        first.map(|sq| (sq, false)) // losing: any legal move
    }

    /// An optimal line from the empty board. Odd boards take the O(1) centre +
    /// mirror line; even boards are driven by `solver`'s winning moves.
    pub fn principal_variation(&self, solver: &dyn Solver) -> Vec<u32> {
        if self.is_odd() {
            return self.mirror_line();
        }
        let mut blocked = Bits::ZERO;
        let mut line = Vec::new();
        while let Some((sq, _)) = self.best_move(blocked, solver) {
            line.push(sq);
            blocked = self.place(blocked, sq);
        }
        line
    }

    /// The first player's winning line on an odd board, with no search: centre,
    /// then mirror each (here arbitrary) reply by the losing side. The mirror is
    /// always legal (see `Solver::first_player_wins`), so this terminates with the
    /// second player stuck and the first player having made the last move.
    pub fn mirror_line(&self) -> Vec<u32> {
        let mut blocked = Bits::ZERO;
        let mut line = Vec::new();
        let c = self.center().expect("odd board has a centre");
        line.push(c);
        blocked = self.place(blocked, c);
        while let Some(s) = self.first_available(blocked) {
            line.push(s); // losing side: any legal reply
            blocked = self.place(blocked, s);
            let m = self.mirror(s); // first player's pairing response
            debug_assert!(self.is_available(blocked, m), "mirror must stay legal");
            line.push(m);
            blocked = self.place(blocked, m);
        }
        line
    }
}

// --------------------------------------------------------------------------- //
// Solver lineage
// --------------------------------------------------------------------------- //

/// A win/loss solver for the Non-Attacking Queens game. Implementors compute
/// `wins` (the value for the player to move); the rest is provided.
pub trait Solver: Sync {
    /// The solver's name (for the CLI / reporting).
    fn name(&self) -> &'static str;

    /// Does the player to move win from `blocked` under perfect play?
    fn wins(&self, q: &Queens, blocked: Bits) -> bool;

    /// Does the first player win the empty board? The default is a plain
    /// `wins(empty)`; [`Parallel`] overrides it with the odd-board O(1) theorem
    /// and root parallelism.
    fn first_player_wins(&self, q: &Queens) -> bool {
        self.wins(q, Bits::empty())
    }

    /// Nodes searched (TT misses), for reporting. `0` if not tracked.
    fn nodes(&self) -> u64 {
        0
    }

    /// Transposition-table byte footprint (the memory cap). `0` if none.
    fn cap_bytes(&self) -> u64 {
        0
    }
}

/// **Naive** -- plain negamax win/loss with the α-β cutoff and *no* memo. The
/// ground truth: slowest, but the reference every other solver is checked against.
#[derive(Default)]
pub struct Naive {
    nodes: AtomicU64,
}

impl Naive {
    pub fn new() -> Self {
        Naive::default()
    }
}

impl Solver for Naive {
    fn name(&self) -> &'static str {
        "naive"
    }
    fn wins(&self, q: &Queens, blocked: Bits) -> bool {
        self.nodes.fetch_add(1, Ordering::Relaxed);
        let mut result = false;
        for &sq in &q.order {
            if q.is_available(blocked, sq) && !self.wins(q, q.place(blocked, sq)) {
                result = true;
                break;
            }
        }
        result
    }
    fn nodes(&self) -> u64 {
        self.nodes.load(Ordering::Relaxed)
    }
}

/// **Memo** (`canon=false`) / **Symmetry** (`canon=true`) -- the cutoff search
/// backed by a fixed-size transposition table. With `canon` the key is the
/// position's dihedral-canonical image, so all 8 symmetric states share an entry.
pub struct Tt {
    tt: QueensTt,
    canon: bool,
}

impl Tt {
    pub fn new(bits: u32, canon: bool) -> Self {
        Tt {
            tt: QueensTt::new(bits),
            canon,
        }
    }
}

impl Solver for Tt {
    fn name(&self) -> &'static str {
        if self.canon {
            "symmetry"
        } else {
            "memo"
        }
    }
    fn wins(&self, q: &Queens, blocked: Bits) -> bool {
        let key = if self.canon {
            q.canon(blocked)
        } else {
            blocked
        };
        if let Some(w) = self.tt.get(key) {
            return w != 0;
        }
        self.tt.bump();
        let mut result = false;
        for &sq in &q.order {
            if q.is_available(blocked, sq) && !self.wins(q, q.place(blocked, sq)) {
                result = true;
                break;
            }
        }
        self.tt.put(key, result as u8);
        result
    }
    fn nodes(&self) -> u64 {
        self.tt.nodes()
    }
    fn cap_bytes(&self) -> u64 {
        self.tt.capacity().1
    }
}

/// **Parallel** -- the production solver. Sequential search is [`Tt`] with
/// canonical keys; `first_player_wins` adds the odd-board O(1) theorem and rayon
/// root parallelism with a Young-Brothers-Wait guard.
pub struct Parallel {
    inner: Tt,
}

impl Parallel {
    pub fn new(bits: u32) -> Self {
        Parallel {
            inner: Tt::new(bits, true),
        }
    }
}

impl Solver for Parallel {
    fn name(&self) -> &'static str {
        "parallel"
    }
    fn wins(&self, q: &Queens, blocked: Bits) -> bool {
        self.inner.wins(q, blocked)
    }
    /// Odd boards are a theorem, not a search: the first player takes the centre,
    /// then mirrors every reply by 180° rotation. The centre attacks all four
    /// lines through it, so a legal reply `s` is off those lines -- exactly the
    /// condition for `s` not to attack its mirror `s'` -- and by symmetry `s'` is
    /// free, so the first player always has the pairing response and the second
    /// player runs out first. (Impartial normal-play ⇒ Sprague-Grundy N-position.)
    ///
    /// Even boards search. A Young-Brothers-Wait guard searches the best-ordered
    /// first move sequentially -- returning at once if it wins (no speculation) --
    /// and only then fans the siblings across rayon workers sharing the table,
    /// where `any` short-circuits on the first winning one. A naïve
    /// `par_iter().any()` over *all* first moves regresses first-player wins
    /// badly (~40× on 13×13) by speculatively searching whole losing subtrees the
    /// cutoff would skip; the guard keeps the cutoff while still parallelising the
    /// must-refute-everything case of a second-player win.
    fn first_player_wins(&self, q: &Queens) -> bool {
        if q.is_odd() {
            return true; // centre + 180° mirror strategy
        }
        match q.distinct_first_moves().split_first() {
            None => false,
            Some((&first, rest)) => {
                if !self.wins(q, q.place(Bits::ZERO, first)) {
                    return true; // best move already wins -- no speculation
                }
                rest.par_iter()
                    .any(|&sq| !self.wins(q, q.place(Bits::ZERO, sq)))
            }
        }
    }
    fn nodes(&self) -> u64 {
        self.inner.nodes()
    }
    fn cap_bytes(&self) -> u64 {
        self.inner.cap_bytes()
    }
}

/// CLI solver names, simplest → most sophisticated.
pub const SOLVER_NAMES: [&str; 4] = ["naive", "memo", "symmetry", "parallel"];

/// Build a solver by name with a `2^bits`-slot table (ignored by `naive`).
pub fn make_solver(name: &str, bits: u32) -> Option<Box<dyn Solver>> {
    match name {
        "naive" => Some(Box::new(Naive::new())),
        "memo" => Some(Box::new(Tt::new(bits, false))),
        "symmetry" => Some(Box::new(Tt::new(bits, true))),
        "parallel" => Some(Box::new(Parallel::new(bits))),
        _ => None,
    }
}

// --------------------------------------------------------------------------- //
// Transposition table
// --------------------------------------------------------------------------- //

/// A fixed-size, sharded, open-addressing transposition table keyed by a board
/// mask -> a `u8` value (win/loss as 0/1, or a Sprague-Grundy nimber). Memory is
/// capped at `2^bits` slots (a collision is a miss, so eviction only costs
/// recompute, never correctness). Sharded so rayon workers can share it; each
/// get/put briefly locks one shard.
pub struct QueensTt {
    shards: Vec<Mutex<Box<[Slot]>>>,
    shard_mask: u64,
    slot_mask: u64,
    nodes: AtomicU64,
}

#[derive(Clone, Copy, Default)]
struct Slot {
    key: [u64; WORDS],
    val: u8,
    used: u8,
}

/// 1024 shards: enough that rayon workers rarely collide on the same lock.
const SHARD_BITS: u32 = 10;

impl QueensTt {
    /// A table of `2^bits` slots total (each ~40 bytes). `bits` is the memory
    /// cap knob; clamped so there is at least one slot per shard.
    pub fn new(bits: u32) -> Self {
        let bits = bits.max(SHARD_BITS);
        let shards = 1usize << SHARD_BITS;
        let per = 1usize << (bits - SHARD_BITS);
        QueensTt {
            shards: (0..shards)
                .map(|_| Mutex::new(vec![Slot::default(); per].into_boxed_slice()))
                .collect(),
            shard_mask: shards as u64 - 1,
            slot_mask: per as u64 - 1,
            nodes: AtomicU64::new(0),
        }
    }

    /// Total slot capacity and its byte footprint, for reporting the cap.
    pub fn capacity(&self) -> (u64, u64) {
        let slots = (self.shard_mask + 1) * (self.slot_mask + 1);
        (slots, slots * std::mem::size_of::<Slot>() as u64)
    }

    /// Nodes actually searched (TT misses) -- the work done, since hits are free.
    pub fn nodes(&self) -> u64 {
        self.nodes.load(Ordering::Relaxed)
    }

    /// Count one searched node (a TT miss about to be expanded).
    #[inline]
    pub fn bump(&self) {
        self.nodes.fetch_add(1, Ordering::Relaxed);
    }

    #[inline]
    fn hash(key: Bits) -> u64 {
        // Mix the words; low bits pick the shard, high bits the slot (disjoint).
        let mut h = 0u64;
        for &w in &key.0 {
            h = (h ^ w).wrapping_mul(0x9E37_79B9_7F4A_7C15);
            h ^= h >> 29;
        }
        h
    }

    /// The stored value for `key`, if present.
    #[inline]
    pub fn get(&self, key: Bits) -> Option<u8> {
        let h = Self::hash(key);
        let idx = ((h >> 32) & self.slot_mask) as usize;
        let s = self.shards[(h & self.shard_mask) as usize].lock().unwrap()[idx];
        (s.used != 0 && s.key == key.0).then_some(s.val)
    }

    /// Store `val` for `key` (replace-always on collision).
    #[inline]
    pub fn put(&self, key: Bits, val: u8) {
        let h = Self::hash(key);
        let idx = ((h >> 32) & self.slot_mask) as usize;
        self.shards[(h & self.shard_mask) as usize].lock().unwrap()[idx] = Slot {
            key: key.0,
            val,
            used: 1,
        };
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
            let s = Parallel::new(14);
            assert!(s.first_player_wins(&q), "n={n}: first player should win");
            assert_eq!(
                q.principal_variation(&s).len(),
                1,
                "n={n}: one placement clears it"
            );
        }
    }

    /// A queen attacks its whole row, column, and both diagonals.
    #[test]
    fn attack_mask_covers_lines() {
        let q = Queens::new(8);
        let d4 = q.square(3, 3);
        let a = q.attack[d4 as usize];
        assert!(a.get(q.square(3, 7)), "same row");
        assert!(a.get(q.square(0, 3)), "same column");
        assert!(a.get(q.square(0, 0)), "main diagonal");
        assert!(a.get(q.square(6, 0)), "anti-diagonal");
        assert!(!a.get(q.square(1, 0)), "a knight's move away is safe");
    }

    /// The whole solver lineage computes the same win/loss: the memo, symmetry,
    /// and parallel solvers all agree with the memo-less ground-truth `Naive` on
    /// every board small enough to brute-force.
    #[test]
    fn solver_lineage_agrees() {
        for n in 1..=9 {
            let q = Queens::new(n);
            let truth = Naive::new().first_player_wins(&q);
            assert_eq!(
                Tt::new(16, false).first_player_wins(&q),
                truth,
                "memo n={n}"
            );
            assert_eq!(
                Tt::new(16, true).first_player_wins(&q),
                truth,
                "symmetry n={n}"
            );
            assert_eq!(
                Parallel::new(16).first_player_wins(&q),
                truth,
                "parallel n={n}"
            );
        }
    }

    /// Odd boards are first-player wins by the centre + 180°-mirror strategy --
    /// proven O(1), and the produced line is legal, complete, and odd-length.
    #[test]
    fn odd_boards_win_by_the_mirror_strategy() {
        for n in (1..=15).step_by(2) {
            let q = Queens::new(n);
            let s = Parallel::new(14);
            assert!(s.first_player_wins(&q), "n={n}: odd ⇒ first wins");
            let pv = q.principal_variation(&s); // mirror_line
            assert_eq!(pv.len() % 2, 1, "n={n}: first player makes the last move");
            let mut blocked = Bits::ZERO;
            for &sq in &pv {
                // is_available also guarantees no square is placed twice.
                assert!(
                    q.is_available(blocked, sq),
                    "n={n}: mirror move must be legal"
                );
                blocked = q.place(blocked, sq);
            }
            assert!(q.no_moves(blocked), "n={n}: board fully blocked at the end");
        }
        // The O(1) verdict agrees with full search on the small odd boards.
        for n in [1u32, 3, 5, 7, 9] {
            assert!(
                Naive::new().first_player_wins(&Queens::new(n)),
                "n={n}: search agrees"
            );
        }
    }

    /// The PV is a legal, complete optimal line, and the winner is whoever makes
    /// the last move (odd-length line ⇒ first player wins).
    #[test]
    fn pv_is_consistent_with_the_winner() {
        for n in 1..=8 {
            let q = Queens::new(n);
            let s = Tt::new(16, true);
            let first_wins = s.first_player_wins(&q);
            let pv = q.principal_variation(&s);
            assert_eq!(
                first_wins,
                pv.len() % 2 == 1,
                "n={n}: winner makes the last move"
            );
            let mut blocked = Bits::ZERO;
            for &sq in &pv {
                assert!(q.is_available(blocked, sq), "n={n}: PV move must be legal");
                blocked = q.place(blocked, sq);
            }
            assert!(q.no_moves(blocked), "n={n}: board fully blocked at the end");
        }
    }

    /// Canonicalisation is symmetry-invariant: a position and its rotation/
    /// reflection share a memo key (and hence a value).
    #[test]
    fn symmetric_positions_canonicalise_together() {
        let q = Queens::new(8);
        let a = q.place(Bits::ZERO, q.square(3, 3)); // a queen on d4
        for t in 0..8 {
            let mut img = Bits::ZERO;
            a.each(|s| img.set(q.sym[t][s as usize]));
            assert_eq!(
                q.canon(a),
                q.canon(img),
                "symmetry {t} must canonicalise the same"
            );
        }
    }
}
