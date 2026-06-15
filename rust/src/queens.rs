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
use std::sync::atomic::{AtomicU16, AtomicU32, AtomicU64, AtomicU8, Ordering};
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
    fn and_not(self, o: Bits) -> Bits {
        let mut r = self.0;
        for (rk, &ok) in r.iter_mut().zip(o.0.iter()) {
            *rk &= !ok;
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

    /// The canonical (lexicographically smallest) image of `mask` under the
    /// board's 8 symmetries.
    fn canon(&self, mask: Bits) -> Bits {
        let mut best = mask;
        for t in 1..8 {
            let perm = &self.sym[t];
            let mut img = Bits::ZERO;
            mask.each(|s| img.set(perm[s as usize]));
            if img < best {
                best = img;
            }
        }
        best
    }

    /// The canonical transposition key for the position with this `blocked` mask.
    ///
    /// We canonicalise the **available** squares (`board & !blocked`), not
    /// `blocked` itself. Available is a pure function of `blocked`, so this merges
    /// the *identical* equivalence classes (same transpositions, same symmetry
    /// folding) -- but for the deep majority of nodes most squares are blocked, so
    /// `available` has far fewer set bits than `blocked` and `canon` does
    /// proportionally less work. Pure speedup, no change to which states share.
    #[inline]
    fn pos_key(&self, blocked: Bits) -> Bits {
        self.canon(self.board.and_not(blocked))
    }

    /// The symmetry-distinct first moves from the empty board: one representative
    /// per orbit of the board's 8 symmetries. Cuts the root branching ~8×.
    pub fn distinct_first_moves(&self) -> Vec<u32> {
        let mut seen = HashSet::new();
        let mut out = Vec::new();
        for &sq in &self.order {
            if self.board.get(sq) && seen.insert(self.pos_key(self.place(Bits::ZERO, sq))) {
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

    /// Distinct-position measurement, if this solver was built with counting
    /// enabled (see [`Tt::new_counting`]). `None` for an ordinary solve.
    fn report(&self) -> Option<CountReport> {
        None
    }

    /// Root-move progress as `(resolved, total)` for a live indicator, or `None`
    /// if the solver does not track it. Only meaningful mid-`first_player_wins`.
    fn root_progress(&self) -> Option<(u64, u64)> {
        None
    }

    /// Extra, approach-specific stats for the solve summary -- e.g. table fill
    /// for the memo solvers, the Sprague-Grundy value for `nimber`, the root
    /// proof/disproof numbers for `pn`. Empty by default (e.g. tableless `naive`).
    fn stats(&self) -> String {
        String::new()
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

    /// As [`Tt::new`], but the table also folds every position it is queried for
    /// into a HyperLogLog (and, with `exact`, a hash set) so the search reports
    /// the number of *distinct* positions it visited -- its true working set.
    pub fn new_counting(bits: u32, canon: bool, hll_p: u32, exact: bool) -> Self {
        Tt {
            tt: QueensTt::new_counting(bits, hll_p, exact),
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
            q.pos_key(blocked)
        } else {
            blocked
        };
        if let Some(w) = self.tt.get(key) {
            return w != 0;
        }
        self.tt.bump();
        let mut result = false;
        for &sq in &q.order {
            if !q.is_available(blocked, sq) {
                continue;
            }
            let child = q.place(blocked, sq);
            // Terminal-child fast path: if this move leaves the opponent with no
            // reply, the opponent loses and we win at once -- skip the recursive
            // `wins(child)`. For the canonical solvers (`symmetry`/`parallel`) every
            // terminal shares one key (`pos_key` folds `available`, empty ⇒
            // `Bits::ZERO`), so the elided lookups would otherwise all funnel through
            // one hot TT shard. (Raw-key `memo` keys terminals by their own `blocked`
            // mask instead, so for it `--distinct` drops every terminal, not one key.)
            if q.no_moves(child) || !self.wins(q, child) {
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
    fn report(&self) -> Option<CountReport> {
        self.tt.report()
    }
    fn stats(&self) -> String {
        self.tt.summary()
    }
}

/// **Parallel** -- the production solver. Sequential search is [`Tt`] with
/// canonical keys; `first_player_wins` adds the odd-board O(1) theorem and rayon
/// root parallelism with a Young-Brothers-Wait guard.
pub struct Parallel {
    inner: Tt,
    /// Root moves resolved / to resolve (for a progress indicator). A
    /// second-player win must refute *every* distinct first move, so `done`
    /// climbs to `total`; a first-player win short-circuits earlier.
    root_done: AtomicU64,
    root_total: AtomicU64,
}

impl Parallel {
    pub fn new(bits: u32) -> Self {
        Parallel {
            inner: Tt::new(bits, true),
            root_done: AtomicU64::new(0),
            root_total: AtomicU64::new(0),
        }
    }

    /// As [`Parallel::new`], but counting the distinct positions visited (see
    /// [`Tt::new_counting`]). The HyperLogLog is lock-free, so it works under the
    /// root parallelism; the `exact` hash set is not (it would serialise every
    /// worker), so counting `exact` requires the sequential [`Tt`] solver instead.
    pub fn new_counting(bits: u32, hll_p: u32) -> Self {
        Parallel {
            inner: Tt::new_counting(bits, true, hll_p, false),
            root_done: AtomicU64::new(0),
            root_total: AtomicU64::new(0),
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
        let moves = q.distinct_first_moves();
        self.root_total.store(moves.len() as u64, Ordering::Relaxed);
        self.root_done.store(0, Ordering::Relaxed);
        match moves.split_first() {
            None => false,
            Some((&first, rest)) => {
                let wins = !self.wins(q, q.place(Bits::ZERO, first));
                self.root_done.fetch_add(1, Ordering::Relaxed);
                if wins {
                    return true; // best move already wins -- no speculation
                }
                rest.par_iter().any(|&sq| {
                    let wins = !self.wins(q, q.place(Bits::ZERO, sq));
                    self.root_done.fetch_add(1, Ordering::Relaxed);
                    wins
                })
            }
        }
    }
    fn nodes(&self) -> u64 {
        self.inner.nodes()
    }
    fn cap_bytes(&self) -> u64 {
        self.inner.cap_bytes()
    }
    fn report(&self) -> Option<CountReport> {
        self.inner.report()
    }
    fn root_progress(&self) -> Option<(u64, u64)> {
        let total = self.root_total.load(Ordering::Relaxed);
        (total > 0).then(|| (self.root_done.load(Ordering::Relaxed).min(total), total))
    }
    /// Root parallelism is this solver's whole point, so report the worker count
    /// and root-move fan-out alongside the shared table's fill.
    fn stats(&self) -> String {
        let (done, total) = (
            self.root_done.load(Ordering::Relaxed),
            self.root_total.load(Ordering::Relaxed),
        );
        format!(
            "{} rayon workers, {done}/{total} root moves · {}",
            rayon::current_num_threads(),
            self.inner.stats(),
        )
    }
}

/// **Nimber** -- computes the full Sprague-Grundy value (not just win/loss) by
/// `mex` over the children's nimbers. Because `mex` needs the whole child set,
/// there is **no α-β cutoff**, so this is strictly more work than the win/loss
/// solvers; it earns its keep by yielding the exact game value (OEIS A344227) and
/// the machinery a future Grundy-decomposition / df-pn solver would build on. As
/// a [`Solver`] it reports `wins = (nimber != 0)`.
pub struct Nimber {
    tt: QueensTt,
    /// The nimber of the empty board once `wins` computes it (`u16::MAX` until
    /// then), so the solve summary can report the actual Sprague-Grundy value.
    root: AtomicU16,
}

impl Nimber {
    pub fn new(bits: u32) -> Self {
        Nimber {
            tt: QueensTt::new(bits),
            root: AtomicU16::new(u16::MAX),
        }
    }

    /// The Sprague-Grundy value (nimber) of the position. `0` is a P-position
    /// (loss for the player to move); any non-zero value is an N-position (win).
    /// Sequential: `mex` needs every child, so there is no cutoff.
    pub fn grundy(&self, q: &Queens, blocked: Bits) -> u8 {
        let key = q.pos_key(blocked);
        if let Some(v) = self.tt.get(key) {
            return v;
        }
        self.tt.bump();
        let mut seen = 0u64; // bitset of child nimbers (all are < n <= 16 < 64)
        for &sq in &q.order {
            if q.is_available(blocked, sq) {
                seen |= 1u64 << self.grundy(q, q.place(blocked, sq));
            }
        }
        let mex = (!seen).trailing_zeros() as u8; // smallest value not in `seen`
        self.tt.put(key, mex);
        mex
    }

    /// As `grundy`, but the top `par_levels` levels fan their children across
    /// rayon workers (sharing the table). Since `mex` has no cutoff, every child
    /// must be computed regardless, so this is pure speedup with no speculative
    /// waste -- unlike the win/loss search it needs no Young-Brothers-Wait guard.
    fn grundy_par(&self, q: &Queens, blocked: Bits, par_levels: u32) -> u8 {
        if par_levels == 0 {
            return self.grundy(q, blocked);
        }
        let key = q.pos_key(blocked);
        if let Some(v) = self.tt.get(key) {
            return v;
        }
        self.tt.bump();
        let kids: Vec<Bits> = q
            .order
            .iter()
            .filter(|&&sq| q.is_available(blocked, sq))
            .map(|&sq| q.place(blocked, sq))
            .collect();
        let seen = kids
            .par_iter()
            .map(|&c| 1u64 << self.grundy_par(q, c, par_levels - 1))
            .reduce(|| 0u64, |a, b| a | b);
        let mex = (!seen).trailing_zeros() as u8;
        self.tt.put(key, mex);
        mex
    }

    /// The nimber of the empty board, root-parallel. The root `mex` is over the
    /// children's nimbers, and symmetric first moves have equal nimbers, so the
    /// dihedral-distinct representatives suffice; they are independent subtrees,
    /// computed across rayon workers (and one level deeper, for load balance).
    pub fn nimber(&self, q: &Queens) -> u8 {
        let seen = q
            .distinct_first_moves()
            .par_iter()
            .map(|&sq| 1u64 << self.grundy_par(q, q.place(Bits::empty(), sq), PAR_LEVELS))
            .reduce(|| 0u64, |a, b| a | b);
        (!seen).trailing_zeros() as u8
    }
}

/// Levels below each root child that also fan out in parallel. The root itself
/// fans over the distinct first moves, so the top `1 + PAR_LEVELS` levels are
/// parallel; deeper nodes run sequentially under the shared table.
const PAR_LEVELS: u32 = 1;

impl Solver for Nimber {
    fn name(&self) -> &'static str {
        "nimber"
    }
    fn wins(&self, q: &Queens, blocked: Bits) -> bool {
        let g = self.grundy(q, blocked);
        if blocked == Bits::empty() {
            self.root.store(g as u16, Ordering::Relaxed); // capture the root nimber
        }
        g != 0
    }
    fn nodes(&self) -> u64 {
        self.tt.nodes()
    }
    fn cap_bytes(&self) -> u64 {
        self.tt.capacity().1
    }
    /// The Sprague-Grundy value is this solver's reason for being -- report it.
    fn stats(&self) -> String {
        let root = self.root.load(Ordering::Relaxed);
        let nimber = if root == u16::MAX {
            "nimber n/a".to_string()
        } else {
            format!("nimber *{root}")
        };
        format!(
            "{nimber} (full Sprague-Grundy, no cutoff) · {}",
            self.tt.summary()
        )
    }
}

/// **Pn** -- depth-first proof-number search (Nagai's df-pn). Instead of a fixed
/// move order it always descends the *most-proving* line, guided by proof and
/// disproof numbers, so it focuses effort on the narrowest path to a verdict --
/// the published state of the art for boolean games (Allis 1994; Nagai 2002).
/// Negamax form on the win/loss tree: a node's proof `φ = min` over children of
/// their disproof `δ`, and `δ = Σ` of their `φ`; a terminal (mover stuck) is a
/// proven loss (`φ = ∞, δ = 0`). The table stores `(φ, δ)` per canonical position.
///
/// **Instructive negative for *this* game.** Verdicts are correct, but plain
/// df-pn hits the well-known df-pn + transposition (graph-history-interaction)
/// pathology: the Non-Attacking Queens game is extraordinarily transposition-
/// dense, so positions solved via one path get re-expanded under reset thresholds
/// when reached via another, and the search explodes past tiny boards (n=8 is
/// fine; n≥9 is impractical). The straightforward `parallel` α-β + TT + symmetry
/// solver dominates it here. Making df-pn competitive needs *careful* DAG-aware
/// proof-number search (Kishimoto on df-pn+transpositions; Čížek-Balko-Schmid
/// 2026) -- kept here as a documented, correct-but-not-competitive experiment.
pub struct Pn {
    tt: PnTt,
    /// The root's `(φ, δ)` once `wins` solves it, so the summary can report the
    /// proof/disproof numbers (`φ=0` ⇒ proven win, `δ=0` ⇒ proven loss).
    root_phi: AtomicU32,
    root_delta: AtomicU32,
}

/// Proof/disproof "infinity" -- a finite sentinel so the arithmetic saturates.
const PN_INF: u32 = u32::MAX;

impl Pn {
    pub fn new(bits: u32) -> Self {
        Pn {
            tt: PnTt::new(bits),
            root_phi: AtomicU32::new(PN_INF),
            root_delta: AtomicU32::new(PN_INF),
        }
    }

    /// The `(φ, δ)` for a *non-terminal* child given its precomputed canonical
    /// `key`: the table entry if present, else a unit leaf `(1, 1)`. Terminal
    /// children never reach here -- `mid` proves the node and returns the moment it
    /// collects one (a terminal child means the opponent cannot move), so this need
    /// not test `no_moves` or canonicalise a key for them.
    #[inline]
    fn child_pd(&self, key: Bits) -> (u32, u32) {
        self.tt.get(key).unwrap_or((1, 1))
    }

    /// df-pn `mid`: expand `blocked` until its `φ ≥ th_phi` or `δ ≥ th_delta`,
    /// always recursing into the child with the smallest disproof number.
    fn mid(&self, q: &Queens, blocked: Bits, th_phi: u32, th_delta: u32) {
        let key = q.pos_key(blocked);
        // Standard df-pn entry check: if the stored numbers already meet the
        // thresholds (in particular a solved node, φ=0/δ=∞ or φ=∞/δ=0), return at
        // once. Without this, a subtree solved via one path is re-expanded every
        // time it recurs through another -- fatal on a transposition-dense game.
        if let Some((phi, delta)) = self.tt.get(key) {
            if phi >= th_phi || delta >= th_delta {
                return;
            }
        }
        self.tt.bump();
        // Collect each non-terminal child with its canonical key *once*. The df-pn
        // loop below revisits this list every time the thresholds tighten, and a
        // child's key is a fixed function of the child, so caching it avoids
        // re-running `canon` (an 8-fold symmetry fold) on every pass. A *terminal*
        // child is decisive on sight -- the opponent then cannot move, so this node
        // is proven (φ=0, δ=∞); return before keying that child or any later one
        // (and before the loop), which also keeps terminals out of `kids` entirely.
        let mut kids: Vec<(Bits, Bits)> =
            Vec::with_capacity(q.board.and_not(blocked).popcount() as usize);
        for &sq in &q.order {
            if q.is_available(blocked, sq) {
                let child = q.place(blocked, sq);
                if q.no_moves(child) {
                    self.tt.put(key, 0, PN_INF); // terminal child ⇒ this node is won
                    return;
                }
                kids.push((child, q.pos_key(child)));
            }
        }
        if kids.is_empty() {
            self.tt.put(key, PN_INF, 0); // terminal node: mover here cannot move ⇒ loses
            return;
        }
        loop {
            // φ(n) = min_c δ(c); δ(n) = Σ_c φ(c). Track the two smallest δ(c).
            let mut phi_n = PN_INF;
            let mut delta_n = 0u32;
            let (mut best, mut best_phi, mut delta1, mut delta2) = (0usize, 1u32, PN_INF, PN_INF);
            let mut proven = false;
            for (i, &(_, ckey)) in kids.iter().enumerate() {
                let (cphi, cdelta) = self.child_pd(ckey);
                if cdelta == 0 {
                    // A non-terminal child the table already proves losing (its mover
                    // loses ⇒ δ(c)=0, φ(c)=∞) proves this node outright: φ(n)=min δ=0,
                    // δ(n)=Σ φ saturates to ∞. No need to scan the remaining children.
                    proven = true;
                    break;
                }
                delta_n = delta_n.saturating_add(cphi);
                if cdelta < phi_n {
                    phi_n = cdelta;
                }
                if cdelta < delta1 {
                    delta2 = delta1;
                    delta1 = cdelta;
                    best = i;
                    best_phi = cphi;
                } else if cdelta < delta2 {
                    delta2 = cdelta;
                }
            }
            if proven {
                self.tt.put(key, 0, PN_INF);
                return;
            }
            if phi_n >= th_phi || delta_n >= th_delta {
                self.tt.put(key, phi_n, delta_n);
                return;
            }
            // Thresholds for the most-proving child (Nagai df-pn).
            let th_phi_c = if th_delta == PN_INF {
                PN_INF
            } else {
                (th_delta - delta_n).saturating_add(best_phi)
            };
            let th_delta_c = th_phi.min(delta2.saturating_add(1));
            self.mid(q, kids[best].0, th_phi_c, th_delta_c);
        }
    }
}

impl Solver for Pn {
    fn name(&self) -> &'static str {
        "pn"
    }
    fn wins(&self, q: &Queens, blocked: Bits) -> bool {
        self.mid(q, blocked, PN_INF, PN_INF); // solve fully
        let pd = self.tt.get(q.pos_key(blocked));
        if blocked == Bits::empty() {
            if let Some((phi, delta)) = pd {
                self.root_phi.store(phi, Ordering::Relaxed);
                self.root_delta.store(delta, Ordering::Relaxed);
            }
        }
        // Solved ⇒ φ = 0 (proven win) or φ = ∞ (disproven ⇒ loss).
        pd.map(|(p, _)| p == 0).unwrap_or(false)
    }
    fn nodes(&self) -> u64 {
        self.tt.nodes()
    }
    fn cap_bytes(&self) -> u64 {
        self.tt.capacity().1
    }
    /// Proof and disproof numbers are df-pn's currency -- report the root's.
    fn stats(&self) -> String {
        let pf = |x: u32| {
            if x == PN_INF {
                "∞".to_string()
            } else {
                x.to_string()
            }
        };
        format!(
            "root proof φ={} disproof δ={} · {}",
            pf(self.root_phi.load(Ordering::Relaxed)),
            pf(self.root_delta.load(Ordering::Relaxed)),
            self.tt.summary(),
        )
    }
}

/// CLI solver names, simplest → most sophisticated (`nimber` computes the full
/// Sprague-Grundy value; `pn` is df-pn proof-number search).
pub const SOLVER_NAMES: [&str; 6] = ["naive", "memo", "symmetry", "parallel", "nimber", "pn"];

/// Build a solver by name with a `2^bits`-slot table (ignored by `naive`).
pub fn make_solver(name: &str, bits: u32) -> Option<Box<dyn Solver>> {
    match name {
        "naive" => Some(Box::new(Naive::new())),
        "memo" => Some(Box::new(Tt::new(bits, false))),
        "symmetry" => Some(Box::new(Tt::new(bits, true))),
        "parallel" => Some(Box::new(Parallel::new(bits))),
        "nimber" => Some(Box::new(Nimber::new(bits))),
        "pn" => Some(Box::new(Pn::new(bits))),
        _ => None,
    }
}

// --------------------------------------------------------------------------- //
// Distinct-position instrumentation (Chunk 1: measure before picking an encoding)
// --------------------------------------------------------------------------- //

/// The result of a distinct-position measurement (see [`Tt::new_counting`]).
#[derive(Clone, Copy, Debug)]
pub struct CountReport {
    /// HyperLogLog estimate of the distinct positions the search visited.
    pub estimate: f64,
    /// Exact distinct count, if a hash set was kept (`--exact`, small boards).
    pub exact: Option<u64>,
    /// HyperLogLog register count (`2^p`), for reporting the estimator's error.
    pub registers: u64,
}

/// The instrumentation a counting [`QueensTt`] folds each visited key into: a
/// HyperLogLog (always) and an exact hash set (optional, small boards only).
struct Counter {
    hll: Hll,
    exact: Option<Mutex<HashSet<Bits>>>,
}

impl Counter {
    #[inline]
    fn feed(&self, key: Bits) {
        self.hll.add(key);
        if let Some(set) = &self.exact {
            set.lock().unwrap().insert(key);
        }
    }
}

/// A dense **HyperLogLog** (Flajolet, Fusy, Gandouet & Meunier, 2007) cardinality
/// estimator over 64-bit key hashes. Lock-free under the parallel solver: each of
/// the `2^p` registers is an [`AtomicU8`] updated with `fetch_max`. State is `2^p`
/// bytes (p=16 ⇒ 64 KB) for a standard error of ≈ `1.04/√(2^p)` (p=16 ⇒ ~0.4%) --
/// ample to size a transposition table. Pure instrumentation: never affects the
/// search result.
pub struct Hll {
    p: u32,
    registers: Vec<AtomicU8>,
}

impl Hll {
    /// A HyperLogLog with `2^p` registers. `p` in `4..=18` is sensible.
    pub fn new(p: u32) -> Self {
        Hll {
            p,
            registers: (0..1u64 << p).map(|_| AtomicU8::new(0)).collect(),
        }
    }

    /// Fold a board key in, hashed with a mixer independent of [`QueensTt::hash128`]
    /// (so the estimate is not coupled to the table's slot mapping).
    #[inline]
    pub fn add(&self, key: Bits) {
        let h = Self::hash(key);
        let idx = (h >> (64 - self.p)) as usize; // top p bits index the register
                                                 // ρ = 1 + (leading zeros of the remaining 64-p bits); the sentinel bit at
                                                 // position p-1 caps ρ at 64-p+1 when those bits are all zero.
        let rho = ((h << self.p) | (1u64 << (self.p - 1))).leading_zeros() as u8 + 1;
        self.registers[idx].fetch_max(rho, Ordering::Relaxed);
    }

    /// The estimated number of distinct keys folded in, with the standard
    /// small-range (linear-counting) correction; the large-range correction is
    /// unnecessary with a 64-bit hash.
    pub fn estimate(&self) -> f64 {
        let m = self.registers.len() as f64;
        let alpha = 0.7213 / (1.0 + 1.079 / m); // valid for p >= 7; we use p >= 14
        let mut sum = 0.0f64;
        let mut zeros = 0u64;
        for r in &self.registers {
            let v = r.load(Ordering::Relaxed);
            sum += 1.0 / (1u64 << v) as f64; // 2^-v
            zeros += (v == 0) as u64;
        }
        let raw = alpha * m * m / sum;
        if raw <= 2.5 * m && zeros > 0 {
            m * (m / zeros as f64).ln() // linear counting for small cardinalities
        } else {
            raw
        }
    }

    /// A high-avalanche 64-bit hash of the key (FNV-1a mix + splitmix64 finalizer),
    /// deliberately distinct from [`QueensTt::hash128`] so estimator accuracy does
    /// not depend on the table's hashing.
    #[inline]
    fn hash(key: Bits) -> u64 {
        let mut h = 0xcbf2_9ce4_8422_2325u64; // FNV-1a offset basis
        for &w in &key.0 {
            h ^= w;
            h = h.wrapping_mul(0x0000_0100_0000_01b3); // FNV-1a prime
        }
        h ^= h >> 30;
        h = h.wrapping_mul(0xbf58_476d_1ce4_e5b9);
        h ^= h >> 27;
        h = h.wrapping_mul(0x94d0_49bb_1331_11eb);
        h ^= h >> 31;
        h
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
    /// Optional distinct-position instrumentation (Chunk 1). `None` for an
    /// ordinary solve, so the production path pays only a predictable null check.
    counter: Option<Counter>,
}

/// A compact 8-byte transposition slot (Chunk 2): one `u64` packing a used flag
/// (bit 0), the 8-bit value (bits 1..9 -- the win/loss bit for the search, or a
/// small Sprague-Grundy nimber for [`Nimber`]), and a 55-bit fingerprint of the
/// canonical key (bits 9..64).
///
/// We store a *fingerprint* of the key, not the full 256-bit key. The slot index
/// already pins ~`bits` bits of the routing hash, and the fingerprint comes from
/// an *independent* 64-bit hash half (see [`QueensTt::hash128`]), so a wrong "hit"
/// -- a different key landing in the same slot *and* matching the fingerprint --
/// has probability ~`2^-55` per colliding probe: negligible even across a
/// Jenrich-scale (~`10^11`) search, and the final verdict is cross-checked against
/// the known result. This shrinks the slot 40 B -> 8 B (5x more entries per byte
/// of RAM) -- the Chunk-2 dynamic-tier win -- while keeping the canonical
/// `available`-mask key, so every transposition still merges exactly as before (no
/// lost merges, unlike re-keying on the queen set). The old strict "collision =
/// miss, never wrong" weakens to "wrong with vanishing probability"; a fingerprint
/// *mismatch* is still just a miss that re-searches.
#[derive(Clone, Copy, Default)]
struct Slot(u64);

impl Slot {
    /// Fingerprint width: `64 - 1 (used) - 8 (val)` bits.
    const FP_BITS: u32 = 55;
    const FP_SHIFT: u32 = 9;
    const VAL_SHIFT: u32 = 1;

    #[inline]
    const fn fp_mask() -> u64 {
        (1u64 << Self::FP_BITS) - 1
    }
    /// Pack `val` and the low `FP_BITS` of `fp` into an occupied slot.
    #[inline]
    fn pack(fp: u64, val: u8) -> Slot {
        Slot(1 | ((val as u64) << Self::VAL_SHIFT) | ((fp & Self::fp_mask()) << Self::FP_SHIFT))
    }
    #[inline]
    fn used(self) -> bool {
        self.0 & 1 != 0
    }
    #[inline]
    fn val(self) -> u8 {
        (self.0 >> Self::VAL_SHIFT) as u8
    }
    #[inline]
    fn fp(self) -> u64 {
        self.0 >> Self::FP_SHIFT
    }
}

/// 1024 shards: enough that rayon workers rarely collide on the same lock.
const SHARD_BITS: u32 = 10;

impl QueensTt {
    /// A table of `2^bits` slots total (each 8 bytes; see [`Slot`]). `bits` is the
    /// memory cap knob; clamped so there is at least one slot per shard.
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
            counter: None,
        }
    }

    /// A table that also counts the distinct positions it is queried for: every
    /// `get` folds the (canonical) key into a HyperLogLog of precision `hll_p`,
    /// and (when `exact`) into a hash set for an exact ground truth on small
    /// boards. Used by the `count` CLI mode to size the table's true working set.
    pub fn new_counting(bits: u32, hll_p: u32, exact: bool) -> Self {
        let mut tt = Self::new(bits);
        tt.counter = Some(Counter {
            hll: Hll::new(hll_p),
            exact: exact.then(|| Mutex::new(HashSet::new())),
        });
        tt
    }

    /// The distinct-position measurement, if this table was built with counting.
    pub fn report(&self) -> Option<CountReport> {
        self.counter.as_ref().map(|c| CountReport {
            estimate: c.hll.estimate(),
            exact: c.exact.as_ref().map(|s| s.lock().unwrap().len() as u64),
            registers: c.hll.registers.len() as u64,
        })
    }

    /// Total slot capacity and its byte footprint, for reporting the cap.
    pub fn capacity(&self) -> (u64, u64) {
        let slots = (self.shard_mask + 1) * (self.slot_mask + 1);
        (slots, slots * std::mem::size_of::<Slot>() as u64)
    }

    /// Occupied slots, by a one-time scan (post-solve; cheap relative to the
    /// search). Combined with [`capacity`](Self::capacity) it gives the load
    /// factor, and `nodes > fill` reveals how much eviction forced re-expansion.
    pub fn fill(&self) -> u64 {
        self.shards
            .iter()
            .map(|s| s.lock().unwrap().iter().filter(|slot| slot.used()).count() as u64)
            .sum()
    }

    /// A "TT {GB}, {load}% full" fragment for the solve summary.
    pub fn summary(&self) -> String {
        let (slots, bytes) = self.capacity();
        let load = self.fill() as f64 / slots as f64 * 100.0;
        format!("TT {:.2} GB, {load:.1}% full", bytes as f64 / 1e9)
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

    /// A 128-bit hash of the key as two independent `u64` halves: `route` drives
    /// the shard (low bits) and slot index (high bits, disjoint); `fp` is the
    /// fingerprint stored in the slot. The halves use different seeds and mixing
    /// constants so the fingerprint actually discriminates keys that share a slot
    /// (rather than re-deriving bits the index already pinned). `route` reproduces
    /// the legacy hash exactly, preserving the routing distribution.
    #[inline]
    fn hash128(key: Bits) -> (u64, u64) {
        let mut route = 0u64;
        let mut fp = 0x2545_F491_4F6C_DD1Du64;
        for &w in &key.0 {
            route = (route ^ w).wrapping_mul(0x9E37_79B9_7F4A_7C15);
            route ^= route >> 29;
            fp = (fp ^ w).wrapping_mul(0xFF51_AFD7_ED55_8CCD);
            fp ^= fp >> 32;
        }
        (route, fp)
    }

    /// The stored value for `key`, if a slot's fingerprint matches.
    #[inline]
    pub fn get(&self, key: Bits) -> Option<u8> {
        // Counting hook: every node the search enters is looked up here exactly
        // once, so folding the key in on each `get` measures the distinct set of
        // positions visited -- the table's working set -- deduplicated by the
        // estimator regardless of transposition revisits or eviction.
        if let Some(c) = &self.counter {
            c.feed(key);
        }
        let (route, fp) = Self::hash128(key);
        let idx = ((route >> 32) & self.slot_mask) as usize;
        let s = self.shards[(route & self.shard_mask) as usize]
            .lock()
            .unwrap()[idx];
        (s.used() && s.fp() == (fp & Slot::fp_mask())).then(|| s.val())
    }

    /// Store `val` for `key` (replace-always on collision).
    #[inline]
    pub fn put(&self, key: Bits, val: u8) {
        let (route, fp) = Self::hash128(key);
        let idx = ((route >> 32) & self.slot_mask) as usize;
        self.shards[(route & self.shard_mask) as usize]
            .lock()
            .unwrap()[idx] = Slot::pack(fp, val);
    }
}

/// The proof-number table for [`Pn`]: a fixed-size sharded open-addressing table
/// keyed by canonical mask -> `(proof, disproof)` numbers. Same structure and
/// guarantees as [`QueensTt`] (collision = miss = re-expand, never wrong).
pub struct PnTt {
    shards: Vec<Mutex<Box<[PnSlot]>>>,
    shard_mask: u64,
    slot_mask: u64,
    nodes: AtomicU64,
}

#[derive(Clone, Copy, Default)]
struct PnSlot {
    key: [u64; WORDS],
    phi: u32,
    delta: u32,
    used: u8,
}

impl PnTt {
    pub fn new(bits: u32) -> Self {
        let bits = bits.max(SHARD_BITS);
        let shards = 1usize << SHARD_BITS;
        let per = 1usize << (bits - SHARD_BITS);
        PnTt {
            shards: (0..shards)
                .map(|_| Mutex::new(vec![PnSlot::default(); per].into_boxed_slice()))
                .collect(),
            shard_mask: shards as u64 - 1,
            slot_mask: per as u64 - 1,
            nodes: AtomicU64::new(0),
        }
    }

    pub fn capacity(&self) -> (u64, u64) {
        let slots = (self.shard_mask + 1) * (self.slot_mask + 1);
        (slots, slots * std::mem::size_of::<PnSlot>() as u64)
    }

    /// Occupied slots, by a one-time scan -- see [`QueensTt::fill`].
    pub fn fill(&self) -> u64 {
        self.shards
            .iter()
            .map(|s| {
                s.lock()
                    .unwrap()
                    .iter()
                    .filter(|slot| slot.used != 0)
                    .count() as u64
            })
            .sum()
    }

    /// A "TT {GB}, {load}% full" fragment for the solve summary.
    pub fn summary(&self) -> String {
        let (slots, bytes) = self.capacity();
        let load = self.fill() as f64 / slots as f64 * 100.0;
        format!("TT {:.2} GB, {load:.1}% full", bytes as f64 / 1e9)
    }

    pub fn nodes(&self) -> u64 {
        self.nodes.load(Ordering::Relaxed)
    }

    #[inline]
    fn bump(&self) {
        self.nodes.fetch_add(1, Ordering::Relaxed);
    }

    #[inline]
    fn get(&self, key: Bits) -> Option<(u32, u32)> {
        let h = QueensTt::hash128(key).0; // PnTt keeps the full key, so it needs only the routing half
        let idx = ((h >> 32) & self.slot_mask) as usize;
        let s = self.shards[(h & self.shard_mask) as usize].lock().unwrap()[idx];
        (s.used != 0 && s.key == key.0).then_some((s.phi, s.delta))
    }

    #[inline]
    fn put(&self, key: Bits, phi: u32, delta: u32) {
        let h = QueensTt::hash128(key).0;
        let idx = ((h >> 32) & self.slot_mask) as usize;
        self.shards[(h & self.shard_mask) as usize].lock().unwrap()[idx] = PnSlot {
            key: key.0,
            phi,
            delta,
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
            assert_eq!(
                Nimber::new(16).first_player_wins(&q),
                truth,
                "nimber!=0 n={n}"
            );
        }
        // df-pn is correct but hits the transposition (graph-history) pathology
        // on this game, so it is only practical for tiny boards -- validate those.
        for n in 1..=6 {
            let q = Queens::new(n);
            assert_eq!(
                Pn::new(16).first_player_wins(&q),
                Naive::new().first_player_wins(&q),
                "pn n={n}"
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

    /// The Sprague-Grundy nimbers match OEIS A344227, and `nimber != 0` agrees
    /// with the win/loss ground truth (`Naive`).
    #[test]
    fn nimbers_match_oeis_a344227() {
        // A344227 for n = 0..=13; we only solve n >= 1.
        const A344227: [u8; 14] = [0, 1, 1, 2, 1, 3, 1, 2, 3, 1, 0, 1, 0, 1];
        for n in 1..=9u32 {
            let q = Queens::new(n);
            let g = Nimber::new(16).nimber(&q);
            assert_eq!(
                g, A344227[n as usize],
                "n={n}: nimber must match OEIS A344227"
            );
            assert_eq!(
                g != 0,
                Naive::new().first_player_wins(&q),
                "n={n}: nimber!=0 must agree with win/loss"
            );
        }
    }

    /// The HyperLogLog estimates a known cardinality within its error budget,
    /// and folding a key in repeatedly does not inflate the estimate (dedup).
    #[test]
    fn hll_estimates_a_known_cardinality() {
        let hll = Hll::new(14); // 16384 registers ⇒ ~0.8% standard error
        let truth = 200_000u64;
        for i in 0..truth {
            let mut b = Bits::ZERO;
            b.0[0] = i.wrapping_mul(0x9E37_79B9_7F4A_7C15);
            b.0[1] = i; // distinct i ⇒ distinct key
            hll.add(b);
            hll.add(b); // re-fold: must be idempotent
        }
        let est = hll.estimate();
        let rel = (est - truth as f64).abs() / truth as f64;
        assert!(
            rel < 0.03,
            "HLL estimate {est:.0} off by {:.2}% from {truth} (>3%)",
            rel * 100.0
        );
    }

    /// Enabling the counting hook must not change the search verdict, and the
    /// HyperLogLog estimate must track the exact distinct-position count.
    #[test]
    fn counting_preserves_verdict_and_tracks_exact() {
        for n in [4u32, 6, 8] {
            let q = Queens::new(n);
            let truth = Naive::new().first_player_wins(&q);
            let s = Tt::new_counting(16, true, 14, true);
            assert_eq!(
                s.first_player_wins(&q),
                truth,
                "n={n}: counting must not change the verdict"
            );
            let rep = s.report().expect("counting enabled");
            let exact = rep.exact.expect("exact set kept");
            assert!(exact > 0, "n={n}: the search visited some positions");
            let rel = (rep.estimate - exact as f64).abs() / exact as f64;
            assert!(
                rel < 0.10,
                "n={n}: HLL {:.0} vs exact {exact} off by {:.1}%",
                rep.estimate,
                rel * 100.0
            );
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

    /// The Chunk-2 compact slot stays 8 bytes, and a stored value round-trips
    /// through the fingerprint: `put` then `get` returns it, and a key never
    /// inserted misses. Guards against accidental slot bloat or a broken
    /// fingerprint (a real false hit at this tiny load is a ~`2^-55` event).
    #[test]
    fn fingerprint_slot_is_compact_and_round_trips() {
        assert_eq!(
            std::mem::size_of::<Slot>(),
            8,
            "compact slot must stay 8 bytes"
        );
        let tt = QueensTt::new(16); // 65_536 slots: a handful of keys ⇒ no eviction
        let q = Queens::new(12);
        // A monotonically shrinking chain of legal placements: each `blocked` has
        // strictly fewer available squares, so the canonical keys are all distinct.
        let mut stored = Vec::new();
        let mut blocked = Bits::ZERO;
        for (i, &sq) in q.order.iter().enumerate() {
            if q.is_available(blocked, sq) {
                blocked = q.place(blocked, sq);
                let (key, val) = (q.pos_key(blocked), (i % 17) as u8); // nimber-sized
                tt.put(key, val);
                stored.push((key, val));
            }
        }
        assert!(
            stored.len() >= 4,
            "the chain should store several positions"
        );
        for &(key, val) in &stored {
            assert_eq!(tt.get(key), Some(val), "stored value must round-trip");
        }
        assert_eq!(
            tt.get(q.pos_key(Bits::ZERO)),
            None,
            "a key never inserted must miss"
        );
    }
}
