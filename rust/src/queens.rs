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
//! That collapses the game to a negamax over a bitset, with transpositions merged
//! by memoising on the mask.
//!
//! **Odd boards need no search at all.** The first player wins by a pairing
//! strategy: take the centre, then answer every reply with its 180° rotation
//! (see `first_player_wins`). So only *even* boards are searched, and the levers
//! below make those tractable:
//!
//! * **win/loss with α-β cutoff** -- the value is just win or lose, so as soon as
//!   one move is found that hands the opponent a *lost* position, the node is a
//!   win and the rest of its moves are skipped (a forcing move-order finds those
//!   fast). At most `n` non-attacking queens fit (one per row), so the tree is at
//!   most `n` plies deep -- branching, not depth, is the cost.
//! * **dihedral symmetry** -- the board has the square's 8 symmetries, so every
//!   position is memoised under the lexicographically smallest of its 8 images,
//!   merging symmetric subtrees (~8× fewer states).
//!
//! Bit `r*n + c` is the square at row `r`, column `c` (`0`-indexed). The bitset is
//! `WORDS` × 64 bits, so boards up to `16×16` (256 bits) fit (tractability,
//! however, runs out well before that -- see the README).
//!
//! Two more levers (the same ones that scaled the Othello engine) make the larger
//! even boards reachable:
//!
//! * **a fixed-size transposition table** (`QueensTt`) instead of an unbounded
//!   map -- a flat, sharded, open-addressing array, full-key compare so a
//!   collision is a miss (recompute), never a wrong answer. Memory is a hard cap
//!   (`2^bits` slots), not something that grows with the search; eviction only
//!   costs recompute.
//! * **root parallelism** -- the distinct (symmetry-reduced) first moves are
//!   searched across rayon workers sharing the table; `any` keeps the cutoff (a
//!   single winning first move proves the first player wins).

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
/// a forcing static move order, and the board's 8 symmetry permutations.
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

    /// Does the player to move win from `blocked` (perfect play)? Win/loss is
    /// exact, so the first move handing the opponent a loss proves a win (cutoff).
    /// Shares the transposition table `tt` -- safe to call from many threads.
    pub fn wins(&self, blocked: Bits, tt: &QueensTt) -> bool {
        let key = self.canon(blocked);
        if let Some(w) = tt.get(key) {
            return w;
        }
        tt.nodes.fetch_add(1, Ordering::Relaxed);
        let mut result = false; // no move ⇒ lose
        for &sq in &self.order {
            if self.board.get(sq) && !blocked.get(sq) && !self.wins(self.place(blocked, sq), tt) {
                result = true; // this move hands the opponent a lost position
                break;
            }
        }
        tt.put(key, result);
        result
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

    /// Does the first player win the empty board?
    ///
    /// **Odd boards are a theorem, not a search.** The game is impartial under
    /// normal play, so each position is an N- or P-position (Sprague-Grundy). For
    /// an odd board the first player wins by a strategy-stealing pairing: take the
    /// centre, then answer every reply `s` with its 180° rotation `s'`. The centre
    /// attacks all four lines through it, so a legal `s` is off those lines --
    /// which is exactly the condition for `s` not to attack `s'` -- and by
    /// symmetry `s'` is free. The first player always has the mirror response, so
    /// the second player runs out first. This collapses an O(huge) search to O(1)
    /// (15×15 is ~7 minutes of search; here it is instant -- see `mirror_line`).
    ///
    /// **Even boards have no centre and need search**, with a Young-Brothers-Wait
    /// guard: search the best-ordered first move sequentially, returning at once
    /// if it wins (no speculation); only if it loses do the siblings fan out
    /// across rayon workers sharing `tt`, where `any` short-circuits on the first
    /// winning one. A naïve `par_iter().any()` over *all* first moves regresses
    /// first-player wins badly (~40× on 13×13) by speculatively searching whole
    /// losing subtrees the cutoff would skip; the guard keeps the cutoff while
    /// still parallelising the must-refute-everything case of a second-player win.
    pub fn first_player_wins(&self, tt: &QueensTt) -> bool {
        if self.is_odd() {
            return true; // centre + 180° mirror strategy (see above)
        }
        match self.distinct_first_moves().split_first() {
            None => false,
            Some((&first, rest)) => {
                if !self.wins(self.place(Bits::ZERO, first), tt) {
                    return true; // best move already wins -- no speculation
                }
                rest.par_iter()
                    .any(|&sq| !self.wins(self.place(Bits::ZERO, sq), tt))
            }
        }
    }

    /// An optimal move and whether it wins: a winning move if one exists, else
    /// the first available move (all of which lose). `None` if no move exists.
    pub fn best_move(&self, blocked: Bits, tt: &QueensTt) -> Option<(u32, bool)> {
        let mut first = None;
        for &sq in &self.order {
            if !self.board.get(sq) || blocked.get(sq) {
                continue;
            }
            first.get_or_insert(sq);
            if !self.wins(self.place(blocked, sq), tt) {
                return Some((sq, true)); // a winning move
            }
        }
        first.map(|sq| (sq, false)) // losing: any legal move
    }

    /// An optimal line from the empty board (reusing `tt`): the winner plays a
    /// winning move each turn, the loser any legal move. Odd boards take the O(1)
    /// `mirror_line`; even boards are search-driven.
    pub fn principal_variation(&self, tt: &QueensTt) -> Vec<u32> {
        if self.is_odd() {
            return self.mirror_line();
        }
        let mut blocked = Bits::ZERO;
        let mut line = Vec::new();
        while let Some((sq, _)) = self.best_move(blocked, tt) {
            line.push(sq);
            blocked = self.place(blocked, sq);
        }
        line
    }

    /// The first player's winning line on an odd board, with no search: centre,
    /// then mirror each (here arbitrary) reply by the losing side. The mirror is
    /// always legal (see `first_player_wins`), so this terminates with the second
    /// player stuck and the first player having made the last move.
    fn mirror_line(&self) -> Vec<u32> {
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

/// A fixed-size, sharded, open-addressing transposition table keyed by canonical
/// blocked mask -> win/loss. Memory is capped at `2^bits` slots (a collision is a
/// miss, so eviction only costs recompute, never correctness). Sharded so rayon
/// workers can share it; each get/put briefly locks one shard.
pub struct QueensTt {
    shards: Vec<Mutex<Box<[Slot]>>>,
    shard_mask: u64,
    slot_mask: u64,
    nodes: AtomicU64,
}

#[derive(Clone, Copy)]
struct Slot {
    key: [u64; WORDS],
    flag: u8, // 0 = empty, 1 = loss, 2 = win
}

impl Default for Slot {
    fn default() -> Self {
        Slot {
            key: [0; WORDS],
            flag: 0,
        }
    }
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

    #[inline]
    fn get(&self, key: Bits) -> Option<bool> {
        let h = Self::hash(key);
        let idx = ((h >> 32) & self.slot_mask) as usize;
        let s = self.shards[(h & self.shard_mask) as usize].lock().unwrap()[idx];
        (s.flag != 0 && s.key == key.0).then_some(s.flag == 2)
    }

    #[inline]
    fn put(&self, key: Bits, win: bool) {
        let h = Self::hash(key);
        let idx = ((h >> 32) & self.slot_mask) as usize;
        self.shards[(h & self.shard_mask) as usize].lock().unwrap()[idx] = Slot {
            key: key.0,
            flag: if win { 2 } else { 1 },
        };
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::collections::HashMap;

    /// On tiny boards the first move already attacks the whole board, so the
    /// first player wins in a single ply.
    #[test]
    fn small_boards_first_player_wins_in_one() {
        for n in 1..=3 {
            let q = Queens::new(n);
            let tt = QueensTt::new(14);
            assert!(q.wins(Bits::ZERO, &tt), "n={n}: first player should win");
            assert_eq!(
                q.principal_variation(&tt).len(),
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

    /// Odd boards are first-player wins by the centre + 180°-mirror strategy --
    /// proven O(1), and the produced line is legal, complete, and odd-length.
    #[test]
    fn odd_boards_win_by_the_mirror_strategy() {
        for n in (1..=15).step_by(2) {
            let q = Queens::new(n);
            assert!(
                q.first_player_wins(&QueensTt::new(14)),
                "n={n}: odd ⇒ first wins"
            );
            let pv = q.principal_variation(&QueensTt::new(14)); // mirror_line
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
        // The O(1) verdict agrees with the full search on the small odd boards.
        for n in [1u32, 3, 5, 7, 9] {
            assert!(
                Queens::new(n).wins(Bits::ZERO, &QueensTt::new(16)),
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
            let tt = QueensTt::new(16);
            let first_wins = q.wins(Bits::ZERO, &tt);
            let pv = q.principal_variation(&tt);
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

    /// A plain solver that memoises on the raw mask (no symmetry) -- the
    /// ground truth the symmetry reduction must agree with.
    fn wins_nosym(q: &Queens, blocked: Bits, memo: &mut HashMap<Bits, bool>) -> bool {
        if let Some(&w) = memo.get(&blocked) {
            return w;
        }
        let mut result = false;
        for sq in 0..q.n * q.n {
            if q.is_available(blocked, sq) && !wins_nosym(q, q.place(blocked, sq), memo) {
                result = true;
                break;
            }
        }
        memo.insert(blocked, result);
        result
    }

    /// Symmetry canonicalisation and root parallelism must not change the
    /// verdict: both agree with the raw-mask solver on every board small enough
    /// to brute-force.
    #[test]
    fn symmetry_and_parallel_preserve_the_verdict() {
        for n in 1..=9 {
            let q = Queens::new(n);
            let seq = q.wins(Bits::empty(), &QueensTt::new(18));
            let par = q.first_player_wins(&QueensTt::new(18));
            let raw = wins_nosym(&q, Bits::empty(), &mut HashMap::new());
            assert_eq!(seq, raw, "n={n}: symmetry reduction changed the result");
            assert_eq!(par, raw, "n={n}: root parallelism changed the result");
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
