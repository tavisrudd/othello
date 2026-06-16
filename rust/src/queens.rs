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

use std::collections::{HashMap, HashSet};
use std::io::{self, Read, Write};
use std::sync::atomic::{AtomicU16, AtomicU32, AtomicU64, AtomicU8, Ordering};
use std::sync::Mutex;

use rayon::prelude::*;

/// 64-bit words backing the board bitset. 4 words = 256 bits ⇒ up to `n = 16`.
const WORDS: usize = 4;
/// Largest board side the bitset can hold (`n*n <= WORDS*64`).
pub const MAX_N: u32 = 16;
/// Largest vertex count of an available-graph (one per square) -- sizes the
/// preallocated graph-key scratch buffers.
const MAXV: usize = (MAX_N * MAX_N) as usize;
/// Largest connected component the graph key resolves by direct degree-sequence
/// lookup instead of WL refinement (#18). For connected graphs on at most four
/// vertices the sorted degree sequence is a complete isomorphism invariant.
const TINY_MAX: usize = 4;
/// Sentinel "vertex" the padded WL neighbour lists fill unused slots with (#17).
/// It indexes a reserved scratch cell whose mixed colour is held at 0, so a padding
/// slot contributes nothing to the colour fold -- the fixed-stride loop stays
/// value-identical to the variable-trip one. One past the real square range
/// (squares are `0..MAXV`), so it never collides with a real vertex.
const DUMMY_VERT: usize = MAXV;

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
    fn and(self, o: Bits) -> Bits {
        let mut r = self.0;
        for (rk, &ok) in r.iter_mut().zip(o.0.iter()) {
            *rk &= ok;
        }
        Bits(r)
    }
    #[inline]
    fn popcount(self) -> u32 {
        self.0.iter().map(|w| w.count_ones()).sum()
    }
    /// The lowest set bit index, or `None` if empty.
    #[inline]
    fn lowest(self) -> Option<u32> {
        self.0
            .iter()
            .enumerate()
            .find(|(_, &w)| w != 0)
            .map(|(k, &w)| k as u32 * 64 + w.trailing_zeros())
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

/// A bitset with exactly bit `i` set.
#[inline]
fn single(i: u32) -> Bits {
    let mut b = Bits::ZERO;
    b.set(i);
    b
}

/// A 64-bit avalanche mix (the SplitMix64 finaliser) for the WL colour hashes in
/// [`Queens::iso_key`]. Cold path (measurement only).
#[inline]
fn mix64(mut x: u64) -> u64 {
    x ^= x >> 30;
    x = x.wrapping_mul(0xBF58_476D_1CE4_E5B9);
    x ^= x >> 27;
    x = x.wrapping_mul(0x94D0_49BB_1331_11EB);
    x ^ (x >> 31)
}

/// Refine `colour` (indexed by square, seeded by the caller) by 1-WL colour
/// refinement until the partition stabilises (≤ |V| rounds): each vertex's next
/// colour mixes its own with the commutative fold of its neighbours' (so neighbour
/// order cannot matter). Returns the stable colouring. Cold measurement path.
fn wl_refine(verts: &[u32], nbrs: &[Bits], mut colour: Vec<u64>) -> Vec<u64> {
    let distinct = |c: &[u64]| {
        let mut v: Vec<u64> = verts.iter().map(|&s| c[s as usize]).collect();
        v.sort_unstable();
        v.dedup();
        v.len()
    };
    let mut prev = 0usize;
    for _ in 0..verts.len() {
        let mut next = colour.clone();
        for (&s, nb) in verts.iter().zip(nbrs) {
            let mut h = colour[s as usize].wrapping_mul(0x100_0000_01B3);
            nb.each(|t| h = h.wrapping_add(mix64(colour[t as usize])));
            next[s as usize] = mix64(h);
        }
        colour = next;
        let classes = distinct(&colour);
        if classes == prev {
            break; // partition stable -- further rounds cannot refine
        }
        prev = classes;
    }
    colour
}

/// Hash the sorted multiset of vertex colours into one order-independent value.
fn hash_colours(verts: &[u32], colour: &[u64]) -> u64 {
    let mut c: Vec<u64> = verts.iter().map(|&s| colour[s as usize]).collect();
    c.sort_unstable();
    c.iter().fold(0x2545_F491_4F6C_DD1D, |h, &x| {
        mix64(h ^ x).wrapping_mul(0x9E37_79B9_7F4A_7C15)
    })
}

/// Per-thread preallocated scratch for the allocation-free graph key
/// ([`Queens::iso_key_fast`]). Reused across every node on a rayon worker; every cell
/// is written before it is read (only the touched prefixes are read), so it needs no
/// per-call zeroing -- **zero heap allocation in the hot loop**. Boxed so the buffers
/// live on the heap once per thread, not on every call's stack.
struct IsoScratch {
    col: [u64; MAXV],            // current colour per *local* vertex (lcol[0..k])
    nxt: [u64; MAXV],            // next-round colour per local vertex
    base: [u64; MAXV],           // degree-seeded local colour (restored before each individualise)
    sort: [u64; MAXV],           // scratch for class-count / colour-multiset sorts
    sigs: [u64; MAXV],           // per-vertex individualisation signatures
    comp_keys: [u64; MAXV],      // per-component canonical keys
    mc: [u64; MAXV + 1],         // mix64(lcol) per local vertex, hoisted once/round; [MAXV]=0 dummy
    verts: [u8; MAXV],           // local vertex -> square index
    loc: [u16; MAXV],            // square index -> local vertex (inverse of verts)
    order: [u8; MAXV],           // canonical *local* vertex order for the certificate
    nbr_pad: [u16; MAXV * MAXV], // fixed-stride neighbour *local* indices, DUMMY_VERT-padded (#17)
}

impl IsoScratch {
    fn new() -> Box<Self> {
        Box::new(IsoScratch {
            col: [0; MAXV],
            nxt: [0; MAXV],
            base: [0; MAXV],
            sort: [0; MAXV],
            sigs: [0; MAXV],
            comp_keys: [0; MAXV],
            mc: [0; MAXV + 1],
            verts: [0; MAXV],
            loc: [0; MAXV],
            order: [0; MAXV],
            nbr_pad: [0; MAXV * MAXV],
        })
    }
}

thread_local! {
    static ISO_SCRATCH: std::cell::RefCell<Box<IsoScratch>> =
        std::cell::RefCell::new(IsoScratch::new());
}

/// Log2 of the per-thread component-canon cache size (#19). 2^22 slots * 16 B = 64 MB
/// per worker -- the same flat fingerprint-slot shape as the main TT. Tuned at n=16: 2^20
/// is capacity-bound (2^22 is +3.7%), 2^23 ties 2^22; 64 MB/thread (~1.5 GB across 24
/// workers) fits comfortably under the n=16 TT budget.
const COMP_CACHE_BITS: u32 = 22;

/// Per-thread direct-mapped cache amortising [`Queens::comp_canon`] setup+WL (#19).
/// `comp_canon` is a pure function of `(component square-set, board geometry)`, and the
/// same component recurs across many nodes (the graph key is recomputed every node,
/// before the TT probe), so caching its canon skips the whole bit-scan + CSR build + WL
/// when a component repeats. Fingerprint-guarded like the TT: a slot collision with a
/// different component is a fingerprint mismatch (recompute), a same-fingerprint hit on a
/// different component is ~2^-64 (negligible; the search is already probabilistic at the
/// 55-bit TT slot and cross-checked vs Jenrich). The fingerprint folds in the board side
/// `n`, so entries never carry across different-`n` solves in one process.
struct CompCache {
    fp: Box<[u64]>,  // per-slot fingerprint (0 = empty)
    val: Box<[u64]>, // per-slot cached canon
}

impl CompCache {
    fn new() -> Self {
        let n = 1usize << COMP_CACHE_BITS;
        CompCache {
            fp: vec![0u64; n].into_boxed_slice(),
            val: vec![0u64; n].into_boxed_slice(),
        }
    }
    /// Slot index and (nonzero) fingerprint for component `comp` on an `n`-board.
    #[inline]
    fn probe(comp: Bits, n: u32) -> (usize, u64) {
        let w = comp.0;
        let mut h = 0x9E37_79B9_7F4A_7C15u64 ^ n as u64;
        h = mix64(h ^ w[0]);
        h = mix64(h ^ w[1]);
        h = mix64(h ^ w[2]);
        h = mix64(h ^ w[3]);
        let slot = (mix64(h) >> (64 - COMP_CACHE_BITS)) as usize;
        (slot, h | 1) // fingerprint forced nonzero so 0 stays the empty marker
    }
}

thread_local! {
    static COMP_CACHE: std::cell::RefCell<CompCache> =
        std::cell::RefCell::new(CompCache::new());
}

/// 1-WL refine `col` (square-indexed) to stability over the `k` component vertices.
/// `nbr_pad` is the fixed-stride neighbour table: row `i` holds vertex `i`'s neighbour
/// squares in `nbr_pad[i*stride .. i*stride+deg]`, the rest padded with [`DUMMY_VERT`].
/// All preallocated; no allocation (#17).
///
/// Two TMA-driven shapes vs the old variable-trip CSR walk, both value-identical:
/// - **`mix64` hoisted out of the per-edge loop** into `mcol` -- computed once per
///   vertex per round (`k` calls) instead of once per incident edge (`2|E|` calls).
/// - **fixed-trip inner loop** (`0..stride` every vertex) -- the loop-exit branch is
///   perfectly predicted, where the per-vertex variable trip mispredicted on exit.
///
/// `mc[DUMMY_VERT]` is held at 0, so padding slots add nothing: the accumulated `h`
/// is bit-identical to summing `mix64(lcol[t])` over the real neighbours only.
///
/// Colours are **compact local** (`lcol[0..k]`, vertex `i`'s colour), so the per-round
/// `mc[i] = mix64(lcol[i])` map is a contiguous load→mix→store with no gather/scatter --
/// LLVM auto-vectorises it to AVX-512 `vpmullq`/`vpsrlq`/`vpxorq` (8× u64) on znver5
/// (#17b). The fold's only gather (`mc[neighbour-local]`) hits a small `k`-element array.
fn wl_refine_in(
    k: usize,
    stride: usize,
    nbr_pad: &[u16],
    lcol: &mut [u64],
    nlcol: &mut [u64],
    mc: &mut [u64],
    sort: &mut [u64],
) {
    let mut prev = 0usize;
    mc[DUMMY_VERT] = 0; // padding contributes nothing; never overwritten below
    for _ in 0..k {
        for i in 0..k {
            mc[i] = mix64(lcol[i]); // contiguous map -> AVX-512 vectorised
        }
        for i in 0..k {
            let mut h = lcol[i].wrapping_mul(0x100_0000_01B3);
            let base = i * stride;
            for s in 0..stride {
                h = h.wrapping_add(mc[nbr_pad[base + s] as usize]);
            }
            nlcol[i] = mix64(h);
        }
        lcol[..k].copy_from_slice(&nlcol[..k]);
        let c = classes_in(k, lcol, sort);
        if c == prev {
            break;
        }
        prev = c;
    }
}

/// The number of distinct colours among the `k` (local) vertices (uses `sort`).
fn classes_in(k: usize, lcol: &[u64], sort: &mut [u64]) -> usize {
    sort[..k].copy_from_slice(&lcol[..k]);
    let s = &mut sort[..k];
    s.sort_unstable();
    let mut c = 0usize;
    let mut last = 0u64;
    for (i, &x) in s.iter().enumerate() {
        if i == 0 || x != last {
            c += 1;
            last = x;
        }
    }
    c
}

/// Hash the sorted colour multiset of the `k` (local) vertices (uses `sort`).
fn hash_colours_in(k: usize, lcol: &[u64], sort: &mut [u64]) -> u64 {
    sort[..k].copy_from_slice(&lcol[..k]);
    let s = &mut sort[..k];
    s.sort_unstable();
    s.iter().fold(0x2545_F491_4F6C_DD1D, |h, &x| {
        mix64(h ^ x).wrapping_mul(0x9E37_79B9_7F4A_7C15)
    })
}

/// Hash the adjacency of a discrete-coloured component in canonical (colour) order --
/// a complete certificate. `order` holds *local* indices sorted by colour; `verts` maps
/// each back to its square for the adjacency test. Uses preallocated `order`.
fn cert_hash_in(
    attack: &[Bits],
    comp: Bits,
    k: usize,
    verts: &[u8],
    lcol: &[u64],
    order: &mut [u8],
) -> u64 {
    for (i, o) in order[..k].iter_mut().enumerate() {
        *o = i as u8; // local indices 0..k (discrete colouring ⇒ k <= MAXV)
    }
    order[..k].sort_unstable_by_key(|&li| lcol[li as usize]);
    let mut h = 0x0CA7_F00D_u64;
    for ii in 0..k {
        let vi = verts[order[ii] as usize]; // square
        let nbr = attack[vi as usize].and(comp);
        for jj in 0..k {
            let vj = verts[order[jj] as usize]; // square
            if vi != vj && nbr.get(vj as u32) {
                h = mix64(h ^ (jj as u64 + 1)).wrapping_mul(0x9E37_79B9_7F4A_7C15);
            }
        }
        h = mix64(h ^ 0xFFFF); // row separator
    }
    h
}

/// Direct canonical key of a *tiny* connected component (`k <= TINY_MAX`), bypassing
/// CSR construction + WL refinement + certificate hashing (#18). For a connected graph
/// on at most four vertices the **sorted degree sequence is a complete isomorphism
/// invariant** -- the 1 / 1 / 2 / 6 connected graphs on 1..=4 vertices each carry a
/// distinct sorted degree sequence -- so we map straight from `(k, sorted degrees)` to a
/// constant. Deep in the search the available-graph fragments into overwhelmingly such
/// components (the isolated vertex and the edge dominate), and `comp_canon` was
/// recomputing their canon millions of times. The key shares the 64-bit space of the
/// full certificate hash; a collision with a `k >= 5` key is a ~2^-64 event (the search
/// already keys through a 55-bit slot fingerprint and is cross-checked vs Jenrich).
#[inline]
fn tiny_comp_key(attack: &[Bits], comp: Bits, k: usize, verts: &[u8]) -> u64 {
    let mut deg = [0u8; TINY_MAX];
    for i in 0..k {
        // attack[v] includes v itself, so the self-bit is one of the set bits.
        deg[i] = (attack[verts[i] as usize].and(comp).popcount() - 1) as u8;
    }
    deg[..k].sort_unstable();
    // Pack (k, sorted degree sequence) -- each degree is < k <= 4, so fits a byte --
    // into one integer and avalanche it. Distinct sorted degree sequence (and distinct
    // k) ⇒ distinct packed value ⇒ distinct key; the invariant is complete here.
    let mut packed = k as u64;
    for &d in &deg[..k] {
        packed = (packed << 8) | d as u64;
    }
    mix64(packed ^ 0x7111_C0DE_7111_C0DE)
}

/// Individualisation-refinement canonical certificate (see [`Queens::iso_key_canon`]).
/// `nbr_sq` is the square-indexed neighbour lookup; `coloring` is the current vertex
/// colouring (by square); `depth` gives each individualisation level a distinct tag so
/// nested individualisations cannot collide. Returns the canonical adjacency rows, or
/// `None` if the shared `budget` is exhausted.
fn canon_cert(
    verts: &[u32],
    nbrs: &[Bits],
    nbr_sq: &[Bits],
    coloring: Vec<u64>,
    budget: &mut i64,
    depth: u32,
) -> Option<Vec<Bits>> {
    *budget -= 1;
    if *budget < 0 {
        return None;
    }
    let coloring = wl_refine(verts, nbrs, coloring);
    // The target cell: the non-singleton colour class with the smallest colour value
    // (a canonical choice -- the same relative class in isomorphic graphs).
    let mut groups: HashMap<u64, Vec<u32>> = HashMap::new();
    for &s in verts {
        groups.entry(coloring[s as usize]).or_default().push(s);
    }
    let target = groups
        .iter()
        .filter(|(_, vs)| vs.len() > 1)
        .min_by_key(|(&c, _)| c)
        .map(|(_, vs)| vs.clone());
    match target {
        None => {
            // Discrete colouring ⇒ canonical vertex order ⇒ adjacency certificate.
            let mut order = verts.to_vec();
            order.sort_unstable_by_key(|&s| coloring[s as usize]);
            let cert: Vec<Bits> = order
                .iter()
                .map(|&vi| {
                    let mut row = Bits::ZERO;
                    for (j, &vj) in order.iter().enumerate() {
                        if nbr_sq[vi as usize].get(vj) {
                            row.set(j as u32);
                        }
                    }
                    row
                })
                .collect();
            Some(cert)
        }
        Some(cell) => {
            // Branch: individualise each cell vertex apart, recurse, keep the min cert.
            let tag = 0xF1F2_F3F4_0000_0000u64 ^ depth as u64;
            let mut best: Option<Vec<Bits>> = None;
            for &w in &cell {
                let mut c2 = coloring.clone();
                c2[w as usize] = tag;
                let cert = canon_cert(verts, nbrs, nbr_sq, c2, budget, depth + 1)?;
                if best.as_ref().is_none_or(|b| cert < *b) {
                    best = Some(cert);
                }
            }
            best
        }
    }
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

    /// **#9 free-involution loss certificate.** True if `available` (a canonical
    /// available-mask, as stored in the TT) proves the mover *loses* with no search:
    /// it is **180°-symmetric** (`available == rot180(available)`) **and** no set
    /// square lies on a centre diagonal (`r == c` or `r + c == n-1`). Then the
    /// responder mirrors every move by 180° rotation: a square attacks its own 180°
    /// image *only* when it is on a centre diagonal (shares the row/col only through
    /// the centre, which exists for odd n alone; shares a diagonal exactly on
    /// `r==c`/`r+c==n-1`), so off-diagonal the mirror stays available and the pairing
    /// strategy carries to the end ⇒ second player (responder) wins. Both conditions
    /// are invariant under the 8 board symmetries (rot180 is central in D4; the
    /// symmetries permute the two centre diagonals among themselves), so the test is
    /// exact on the *canonical* key. (Measurement: `count --psym`; lever #9.)
    pub fn is_free_involution_loss(&self, available: Bits) -> bool {
        // 180°-symmetric under sym[2].
        let mut rot = Bits::ZERO;
        available.each(|s| rot.set(self.sym[2][s as usize]));
        if rot != available {
            return false;
        }
        // No set square on either centre diagonal.
        let mut on_diag = false;
        available.each(|s| {
            let (r, c) = (s / self.n, s % self.n);
            on_diag |= r == c || r + c == self.n - 1;
        });
        !on_diag
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

    /// A Weisfeiler–Leman (1-WL / colour-refinement) **invariant** of the
    /// *available-graph* of `mask`: vertices are the available squares, edges are
    /// attacking pairs (the game from here is Node Kayles on this graph, so any two
    /// positions with isomorphic available-graphs have identical game values and
    /// subtrees). Isomorphic graphs share this value, so counting distinct `iso_key`s
    /// over the working set MEASURES how many positions would merge under graph-
    /// isomorphism canonicalisation -- beyond the 8 board symmetries [`canon`] folds
    /// (the queen graph's automorphisms include D4 but small residual graphs often
    /// coincide up to iso without being board-symmetric, e.g. k mutually-non-attacking
    /// squares = k isolated vertices wherever they sit).
    ///
    /// It is an *invariant*, not a canonical form: non-isomorphic graphs can collide
    /// (1-WL failures -- and these queen available-graphs are WL-hard), so it
    /// over-counts merges. Measurement tool only (`count --iso`), not a TT key. See
    /// [`Queens::iso_key_ir`] for the stronger individualisation-refinement variant.
    pub fn iso_key(&self, mask: Bits) -> u64 {
        let (verts, nbrs, base) = self.avail_graph(mask);
        if verts.is_empty() {
            return 0;
        }
        hash_colours(&verts, &wl_refine(&verts, &nbrs, base))
    }

    /// A **stronger** available-graph invariant: 1-WL augmented by *individualisation*
    /// (the core of nauty/bliss). 1-WL alone is too weak on these regular/symmetric
    /// graphs, so when its colouring is non-discrete we individualise each vertex in
    /// turn (tag it apart, re-refine to stability) and combine the resulting per-vertex
    /// colour signatures into one order-independent invariant. Breaking the regularity
    /// 1-WL chokes on, this distinguishes far more non-isomorphic graphs -- so its
    /// distinct count is a much tighter (still conservative) estimate of the true
    /// graph-isomorphism class count. Still an invariant, not a full canonical form;
    /// O(|V|) refinements per non-discrete graph (cold measurement path only).
    pub fn iso_key_ir(&self, mask: Bits) -> u64 {
        let (verts, nbrs, base) = self.avail_graph(mask);
        if verts.is_empty() {
            return 0;
        }
        let stable = wl_refine(&verts, &nbrs, base.clone());
        // Already discrete ⇒ 1-WL pins every vertex, individualisation adds nothing.
        let distinct = {
            let mut c: Vec<u64> = verts.iter().map(|&s| stable[s as usize]).collect();
            c.sort_unstable();
            c.dedup();
            c.len()
        };
        if distinct == verts.len() {
            return hash_colours(&verts, &stable);
        }
        // Individualise each vertex with the same distinguished tag, refine, and fold
        // the per-vertex signatures (sorted ⇒ vertex order cannot matter).
        let mut sigs: Vec<u64> = verts
            .iter()
            .map(|&v| {
                let mut init = base.clone();
                init[v as usize] = 0xD15C_0DED_1111_2222; // tag distinct from any degree
                hash_colours(&verts, &wl_refine(&verts, &nbrs, init))
            })
            .collect();
        sigs.sort_unstable();
        sigs.iter().fold(0xABCD_1234_5678_9ABC, |h, &c| {
            mix64(h ^ c).wrapping_mul(0x9E37_79B9_7F4A_7C15)
        })
    }

    /// A **true canonical form** of the available-graph (individualisation-refinement,
    /// nauty-style): refine; if the colouring is discrete, read off the adjacency in
    /// the colour-induced vertex order as a certificate; else branch on each vertex of
    /// the first non-singleton (smallest-colour) cell, individualising it apart, and
    /// take the lexicographically **minimum** certificate over the branches. Two graphs
    /// get the same certificate **iff** isomorphic — so distinct `iso_key_canon`s over
    /// the working set is the *exact* graph-isomorphism class count (the safe merge),
    /// and a correct canon can never make a win/loss-mixed class.
    ///
    /// Symmetric graphs branch widely, so a node budget caps the search; a capped graph
    /// falls back to the (sound, weaker) [`iso_key_ir`] invariant — which may over-merge
    /// and so surface as a mixed class, flagging that this graph wasn't fully canonised.
    pub fn iso_key_canon(&self, mask: Bits) -> u64 {
        let (verts, nbrs, base) = self.avail_graph(mask);
        if verts.is_empty() {
            return 0;
        }
        // Square-indexed neighbour lookup, for adjacency tests when serialising.
        let mut nbr_sq = vec![Bits::ZERO; (self.n * self.n) as usize];
        for (&s, &nb) in verts.iter().zip(&nbrs) {
            nbr_sq[s as usize] = nb;
        }
        let mut budget: i64 = 200_000;
        match canon_cert(&verts, &nbrs, &nbr_sq, base, &mut budget, 0) {
            Some(cert) => cert.iter().flat_map(|r| r.0).fold(0x0CA7_F00D_u64, |h, x| {
                mix64(h ^ x).wrapping_mul(0x9E37_79B9_7F4A_7C15)
            }),
            None => self.iso_key_ir(mask), // budget exhausted: fall back to the invariant
        }
    }

    /// An **allocation-free** graph-isomorphism key (the production-candidate live key):
    /// component-decompose `mask` and canonicalise each component using only the
    /// per-thread preallocated [`IsoScratch`] buffers -- no `Vec`/`HashMap`, no heap
    /// allocation, no per-call zeroing (every buffer cell is written before it is read).
    /// Same merge as [`iso_key_canon`] (validated equal on n ≤ 14), far cheaper.
    pub fn iso_key_fast(&self, mask: Bits) -> u64 {
        ISO_SCRATCH.with(|s| {
            let mut g = s.borrow_mut();
            // Production: the `HIST = false` instantiation emits *no* component-size
            // tally at all -- not a per-component branch but a compile-time-eliminated
            // path -- so the hot loop's I-cache footprint is unchanged. The gate is a
            // const generic resolved at the call site, the way the project keeps
            // measurement toggles out of latency-bound loops (see the env-var rule in
            // CLAUDE.md). The measurement entry instantiates `HIST = true` instead.
            self.iso_key_fast_in::<false>(mask, &mut g, &mut [])
        })
    }

    /// Measurement entry for `count --comps`: run the *same* graph-key decomposition the
    /// live key runs, but with the connected-component-size tally monomorphised in
    /// (`HIST = true`). Each available-graph's component sizes are accumulated into
    /// `hist` (bucket `i` = components with `i` vertices; the final bucket catches the
    /// tail). Cold analysis only -- never reached from the search.
    pub fn tally_components(&self, mask: Bits, hist: &mut [u64]) {
        ISO_SCRATCH.with(|s| {
            let mut g = s.borrow_mut();
            self.iso_key_fast_in::<true>(mask, &mut g, hist);
        });
    }

    /// `HIST` selects, at monomorphisation time, whether to tally component sizes into
    /// `hist` -- `false` for the search's live key (the tally vanishes), `true` for the
    /// `count --comps` measurement. Keeping it a const generic (rather than a runtime
    /// flag) is the project rule for hot-path toggles: the disabled branch never enters
    /// the instruction stream, so it cannot pollute L1i or the frontend the graph key is
    /// already bound by.
    fn iso_key_fast_in<const HIST: bool>(
        &self,
        mask: Bits,
        s: &mut IsoScratch,
        hist: &mut [u64],
    ) -> u64 {
        let mut remaining = mask;
        let mut nc = 0usize;
        while let Some(start) = remaining.lowest() {
            let comp = self.component(start, mask);
            remaining = remaining.and_not(comp);
            if HIST {
                let k = comp.popcount() as usize;
                hist[k.min(hist.len() - 1)] += 1;
            }
            let ck = self.comp_canon(comp, s);
            s.comp_keys[nc] = ck;
            nc += 1;
        }
        if nc == 0 {
            return 0;
        }
        let keys = &mut s.comp_keys[..nc];
        keys.sort_unstable();
        keys.iter().fold(0x515E_AF00_D515_E5A1, |h, &k| {
            mix64(h ^ k).wrapping_mul(0x9E37_79B9_7F4A_7C15)
        })
    }

    /// Canonical key of one connected component, scratch-only. 1-WL refine; if discrete,
    /// hash the adjacency certificate in canonical order (a complete canon); else fall
    /// back to the validated-equivalent individualisation invariant. Components are small
    /// (the graph fragments deep), so the fallback stays cheap.
    fn comp_canon(&self, comp: Bits, s: &mut IsoScratch) -> u64 {
        let mut k = 0usize;
        comp.each(|v| {
            s.verts[k] = v as u8;
            k += 1;
        });
        // Tiny components -- the deep majority -- resolve by sorted degree sequence
        // alone (a complete invariant for k <= 4), skipping all WL work (#18).
        if k <= TINY_MAX {
            return tiny_comp_key(&self.attack, comp, k, &s.verts);
        }
        // #19: amortise the full canon (a pure function of `comp`) across recurring
        // components via the per-thread cache. Probe; on a fingerprint hit return it,
        // else compute and store. The borrow is dropped around `comp_canon_full` so the
        // (recursive-free) compute never holds the cache lock.
        let (slot, fp) = CompCache::probe(comp, self.n);
        if let Some(v) = COMP_CACHE.with(|c| {
            let c = c.borrow();
            (c.fp[slot] == fp).then(|| c.val[slot])
        }) {
            return v;
        }
        let v = self.comp_canon_full(comp, k, s);
        COMP_CACHE.with(|c| {
            let mut c = c.borrow_mut();
            c.fp[slot] = fp;
            c.val[slot] = v;
        });
        v
    }

    /// The full Weisfeiler-Leman canon of a component whose vertices are already in
    /// `s.verts[..k]` -- 1-WL refine, then the adjacency certificate if discrete, else
    /// the individualisation invariant. Used for `k > TINY_MAX` (tiny components take
    /// the [`tiny_comp_key`] shortcut). Kept as a named entry so the test corpus can
    /// cross-check the shortcut against it on small components too.
    fn comp_canon_full(&self, comp: Bits, k: usize, s: &mut IsoScratch) -> u64 {
        // Stride = the component's max degree (one branchless popcount per vertex, no
        // bit-scan), so every padded neighbour row is the same fixed length.
        let mut stride = 0usize;
        for i in 0..k {
            let deg = self.attack[s.verts[i] as usize].and(comp).popcount() as usize - 1;
            if deg > stride {
                stride = deg;
            }
        }
        // Invert verts so neighbour squares map to compact local indices 0..k.
        for i in 0..k {
            s.loc[s.verts[i] as usize] = i as u16;
        }
        // Build the fixed-stride neighbour table once (one bit-scan per vertex, not per
        // round): real neighbours as *local* indices, then DUMMY_VERT padding. Seed the
        // compact colour `lcol[i] = base[i]` by degree.
        for i in 0..k {
            let v = s.verts[i] as usize;
            let base = i * stride;
            let mut p = base;
            self.attack[v].and(comp).each(|t| {
                if t != v as u32 {
                    s.nbr_pad[p] = s.loc[t as usize];
                    p += 1;
                }
            });
            for q in p..base + stride {
                s.nbr_pad[q] = DUMMY_VERT as u16;
            }
            s.base[i] = ((p - base) as u64) | 0x9E37_79B9_0000_0000;
            s.col[i] = s.base[i];
        }
        wl_refine_in(
            k,
            stride,
            &s.nbr_pad,
            &mut s.col,
            &mut s.nxt,
            &mut s.mc,
            &mut s.sort,
        );
        if classes_in(k, &s.col, &mut s.sort) == k {
            return cert_hash_in(&self.attack, comp, k, &s.verts, &s.col, &mut s.order);
        }
        // Non-discrete: individualise each vertex, refine, combine the signatures.
        for i in 0..k {
            s.col[..k].copy_from_slice(&s.base[..k]);
            s.col[i] = 0xD15C_0DED_1111_2222;
            wl_refine_in(
                k,
                stride,
                &s.nbr_pad,
                &mut s.col,
                &mut s.nxt,
                &mut s.mc,
                &mut s.sort,
            );
            s.sigs[i] = hash_colours_in(k, &s.col, &mut s.sort);
        }
        let sigs = &mut s.sigs[..k];
        sigs.sort_unstable();
        sigs.iter().fold(0xABCD_1234_5678_9ABC, |h, &x| {
            mix64(h ^ x).wrapping_mul(0x9E37_79B9_7F4A_7C15)
        })
    }

    /// The connected component of the available-graph containing `start` (flood-fill
    /// over attacking edges within `mask`).
    fn component(&self, start: u32, mask: Bits) -> Bits {
        let mut comp = single(start);
        let mut frontier = comp;
        loop {
            let mut next = Bits::ZERO;
            frontier.each(|v| next = next.or(self.attack[v as usize]));
            next = next.and(mask).and_not(comp);
            if next == Bits::ZERO {
                break;
            }
            comp = comp.or(next);
            frontier = next;
        }
        comp
    }

    /// A **cheaper** graph-isomorphism key: split the available-graph into connected
    /// components and canonicalise each independently, then combine the sorted multiset
    /// of component keys. Sound and complete (two graphs are isomorphic iff their
    /// components match up to iso), and far cheaper on the deep, *fragmented* graphs
    /// that dominate the search -- a whole-graph [`iso_key_canon`] over k isolated
    /// vertices blows its individualisation budget, whereas here each tiny component
    /// canonises instantly. Gives the **same merge** as `iso_key_canon`, faster.
    pub fn iso_key_components(&self, mask: Bits) -> u64 {
        let mut remaining = mask;
        let mut keys: Vec<u64> = Vec::new();
        while let Some(start) = remaining.lowest() {
            let comp = self.component(start, mask);
            remaining = remaining.and_not(comp);
            keys.push(self.iso_key_canon(comp));
        }
        if keys.is_empty() {
            return 0;
        }
        keys.sort_unstable();
        keys.iter().fold(0x515E_AF00_D515_E5A1, |h, &k| {
            mix64(h ^ k).wrapping_mul(0x9E37_79B9_7F4A_7C15)
        })
    }

    /// The available-graph of `mask`: its vertices (set squares), each vertex's
    /// neighbour mask (attacking available squares), and the degree-seeded initial
    /// 1-WL colours indexed by square. Shared by [`iso_key`] and [`iso_key_ir`].
    fn avail_graph(&self, mask: Bits) -> (Vec<u32>, Vec<Bits>, Vec<u64>) {
        let mut verts: Vec<u32> = Vec::new();
        mask.each(|s| verts.push(s));
        let nbrs: Vec<Bits> = verts
            .iter()
            .map(|&s| self.attack[s as usize].and(mask).and_not(single(s)))
            .collect();
        let mut base = vec![0u64; (self.n * self.n) as usize];
        for (&s, nb) in verts.iter().zip(&nbrs) {
            base[s as usize] = nb.popcount() as u64 | 0x9E37_79B9_0000_0000;
        }
        (verts, nbrs, base)
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

    /// An optimal line from the empty board, given the known root verdict
    /// `root_wins` (does the first player win?). Odd boards take the O(1) centre +
    /// mirror line and ignore `root_wins`.
    ///
    /// For even boards the optimal line's value **strictly alternates** down the
    /// plies: a *loss* node (player to move loses) has *every* child winning, so any
    /// move is optimal and the child is a win; a *win* node has a move to a *losing*
    /// child, and that child is a loss for the next mover. So we thread the value
    /// from `root_wins` and **never search a loss ply** -- we take the first legal
    /// move with no search -- while a win ply searches (`best_move`'s α-β cutoff over
    /// the warm TT) for a move to a losing child. This avoids re-confirming the
    /// verdict by re-searching every root subtree single-core (the post-solve PV
    /// grind, backlog #21): for a second-player win the root is a loss, so the whole
    /// 36-subtree root re-search is replaced by one `first_available`.
    pub fn principal_variation(&self, solver: &dyn Solver, root_wins: bool) -> Vec<u32> {
        if self.is_odd() {
            return self.mirror_line();
        }
        let mut blocked = Bits::ZERO;
        let mut line = Vec::new();
        let mut node_wins = root_wins; // value for the player to move at this ply
        loop {
            let next = if node_wins {
                // Win node: a move to a losing child exists. `best_move` returns it
                // first, stopping at the first child the cutoff proves a loss.
                match self.best_move(blocked, solver) {
                    Some((sq, won)) => {
                        debug_assert!(won, "win-node PV ply must have a winning move");
                        Some(sq)
                    }
                    None => None,
                }
            } else {
                // Loss node: every move loses, so the first legal one is optimal --
                // no search. (Exactly the square a loss `best_move` would return.)
                self.first_available(blocked)
            };
            match next {
                Some(sq) => {
                    line.push(sq);
                    blocked = self.place(blocked, sq);
                    node_wins = !node_wins; // value strictly alternates down the line
                }
                None => break,
            }
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

    /// Per-node branching / cutoff tally, if built with [`Tt::with_branching`]
    /// (`count --branching`). `None` for an ordinary solve.
    fn branching_stats(&self) -> Option<BranchingStats> {
        None
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

    /// The exact working set (canonical key, win/loss value), for cold post-search
    /// analysis (`count --iso`). `None` unless an exact distinct set was kept.
    fn working_set(&self) -> Option<Vec<(Bits, u8)>> {
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

    /// The transposition table, if this solver has one -- so a checkpoint can dump
    /// it mid-search (`QueensTt::dump_image`). `None` for tableless solvers (`naive`).
    fn tt(&self) -> Option<&QueensTt> {
        None
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
/// Per-node branching/cutoff tally for the `count --branching` measurement. Lives on
/// [`Tt`] but is only ever touched on the `wins_keyed_in::<true>` monomorphisation
/// (selected once at the root by `branching`); production (`::<false>`) never emits a
/// reference to it, so it is zero-cost. Single-threaded (the branching measurement uses
/// the sequential solver), so the atomics never contend -- they are atomics only because
/// [`Solver`] is `Sync`.
#[derive(Default)]
struct Tally {
    /// Total `node_key` (canon) calls = expanded edges. `edges / distinct` = b̄, the
    /// per-distinct-node canonicalisation multiplier the theoretical floor turns on.
    edges: AtomicU64,
    /// Nodes that found a winning move (returned `true` after expansion).
    win_nodes: AtomicU64,
    /// Nodes that refuted every move (returned `false`): the prove-a-loss nodes, which
    /// have no cutoff to lose and are *required* by the proof DAG.
    loss_nodes: AtomicU64,
    /// Σ over win nodes of the available moves tried before the cutoff fired (1 = the
    /// first available move won). Mean cutoff = `win_tried_sum / win_nodes`.
    win_tried_sum: AtomicU64,
    /// Histogram of the cutoff position at win nodes: index k = cut on the (k+1)-th
    /// available move; index 7 = 8th-or-later. The move-ordering-quality shape.
    win_cut: [AtomicU64; 8],
}

/// A snapshot of [`Tally`] for reporting (see [`Solver::branching_stats`]).
pub struct BranchingStats {
    pub edges: u64,
    pub win_nodes: u64,
    pub loss_nodes: u64,
    pub win_tried_sum: u64,
    pub win_cut: [u64; 8],
}

pub struct Tt {
    tt: QueensTt,
    canon: bool,
    key: KeyMode,
    max_avail: u32,
    /// Selects the counting monomorphisation at the root (`count --branching`); off in
    /// production. Resolved once at construction, never read per node.
    branching: bool,
    tally: Tally,
}

/// Which canonical key the search uses per node. `D4` is the production key
/// (`pos_key`, the dihedral-canonical `available` mask). `GraphIr`/`GraphCanon` are
/// the **graph-isomorphism** keys (session-6 lever #7) -- they merge ~3.4× more
/// positions (every isomorphic available-graph), but cost ~µs/node vs `pos_key`'s
/// ~ns, so this is a measurement/spike toggle (`QUEENS_KEY=ir|canon`), not yet the
/// default. Only meaningful for the canonical solvers (`canon == true`).
#[derive(Clone, Copy, PartialEq)]
enum KeyMode {
    D4,
    GraphIr,
    GraphCanon,
    GraphComp,
    GraphFast,
}

/// Resolve the key mode once at construction (never per node -- an env read in the
/// hot loop serialises the rayon workers). `QUEENS_KEY=ir|canon|comp` opts into a
/// graph-isomorphism key; anything else keeps the production D4 key.
fn key_mode() -> KeyMode {
    match std::env::var("QUEENS_KEY").as_deref() {
        Ok("ir") => KeyMode::GraphIr,
        Ok("canon") => KeyMode::GraphCanon,
        Ok("comp") => KeyMode::GraphComp,
        Ok("fast") => KeyMode::GraphFast,
        _ => KeyMode::D4,
    }
}

/// Pack a 64-bit graph-isomorphism key into the table's 256-bit key slot, tagged with
/// a sentinel bit (255) that no real `available` mask sets for n ≤ 15 -- so graph keys
/// and D4 masks occupy disjoint key spaces and never collide when **selective** keying
/// mixes them. (n=16 uses all 256 bits; a wider namespace would be needed there.)
#[inline]
fn graph_bits(h: u64) -> Bits {
    Bits([h, 0, 0, 1u64 << 63])
}

/// Resolve the selective-keying threshold once: with `QUEENS_KEY_MAX=k`, only positions
/// whose available-graph has ≤ k vertices use the (costly) graph key; larger graphs fall
/// back to the cheap D4 key. Safe because transpositions are strictly intra-ply, and the
/// choice is a pure function of the position (its available popcount). Default: no limit.
fn key_max_avail() -> u32 {
    std::env::var("QUEENS_KEY_MAX")
        .ok()
        .and_then(|s| s.parse().ok())
        .unwrap_or(u32::MAX)
}

/// Plies from the root that [`Parallel`] fans across rayon (resolved once at startup,
/// never per node). `QUEENS_PAR_DEPTH` overrides; default `3`. Below this depth the
/// search recurses sequentially (full α-β cutoff). Higher exposes more parallelism --
/// keeping the dominant root-0 ("elder brother") subtree off a single core at n=16,
/// where that subtree is the entire feasible runtime -- at the cost of some speculation
/// at the OR (prove-a-win) levels; the AND (prove-a-loss) levels, the bulk of a
/// second-player win, parallelise with no speculation.
fn par_depth() -> u32 {
    std::env::var("QUEENS_PAR_DEPTH")
        .ok()
        .and_then(|s| s.parse().ok())
        .unwrap_or(3)
        .max(1)
}

/// `QUEENS_PAR_MIN_AVAIL` override (resolved once at construction). `None` ⇒ auto by
/// board size (see [`min_avail_for`]). The size split keeps a *big* deep prove-a-loss
/// node fanning so an idle core can steal a straggler -- the #20 tail fix; available
/// count is a cheap proxy for subtree size (it shrinks with depth).
fn par_min_avail_override() -> Option<u32> {
    std::env::var("QUEENS_PAR_MIN_AVAIL")
        .ok()
        .and_then(|s| s.parse().ok())
}

/// The size-split threshold for board `n`: a node below [`par_depth`] keeps splitting
/// while its available count stays above this, else it goes sequential. The auto
/// default is **on only for n ≥ 15** (`96`) and **off below** (`u32::MAX`): the fixed
/// `par_depth` schedule is already well-tuned on the short small-board searches (where
/// extra splitting is pure overhead -- it regresses n=14 ~3%), and only the n=16 tail
/// -- few roots left, all parallelism intra-root, sequential stragglers draining cores
/// -- needs the deeper split. Rayon pays the split cost only on an actual steal, so at
/// n=16 it is ~free while saturated and pays off precisely at the tail. `over` (the env
/// override) wins when set; set it huge (≥ n²) to force the pure fixed-`par_depth` form.
fn min_avail_for(over: Option<u32>, n: u32) -> u32 {
    over.unwrap_or(if n >= 15 { 96 } else { u32::MAX })
}

impl Tt {
    pub fn new(bits: u32, canon: bool) -> Self {
        Tt {
            tt: QueensTt::new(bits),
            canon,
            key: key_mode(),
            max_avail: key_max_avail(),
            branching: false,
            tally: Tally::default(),
        }
    }

    /// Wrap an already-built table (e.g. a reloaded checkpoint image) so a search
    /// resumes warm. The key mode / selective-keying threshold are resolved from the
    /// environment as in [`Tt::new`]; the caller must use the *same* `QUEENS_KEY` the
    /// dump was produced under, or stored keys won't match.
    pub fn from_tt(tt: QueensTt, canon: bool) -> Self {
        Tt {
            tt,
            canon,
            key: key_mode(),
            max_avail: key_max_avail(),
            branching: false,
            tally: Tally::default(),
        }
    }

    /// As [`Tt::new`], but the table also folds every position it is queried for
    /// into a HyperLogLog (and, with `exact`, a hash set) so the search reports
    /// the number of *distinct* positions it visited -- its true working set.
    pub fn new_counting(bits: u32, canon: bool, hll_p: u32, exact: bool) -> Self {
        Tt {
            tt: QueensTt::new_counting(bits, hll_p, exact),
            canon,
            key: key_mode(),
            max_avail: key_max_avail(),
            branching: false,
            tally: Tally::default(),
        }
    }

    /// Enable the `count --branching` tally: the next `wins`/`first_player_wins` selects
    /// the counting monomorphisation (`wins_keyed_in::<true>`) at the root. Build-time
    /// only -- resolved once here, never per node. Use the **sequential** solver (this
    /// is on [`Tt`]); the measurement is single-threaded by construction.
    pub fn with_branching(mut self) -> Self {
        self.branching = true;
        self
    }

    /// The transposition key for the position with this `blocked` mask, per the
    /// configured [`KeyMode`]. The graph keys canonicalise the *available-graph* up
    /// to isomorphism (merging far more than the 8 board symmetries).
    #[inline]
    fn node_key(&self, q: &Queens, blocked: Bits) -> Bits {
        if !self.canon {
            return blocked; // memo: raw mask
        }
        if self.key == KeyMode::D4 {
            return q.pos_key(blocked);
        }
        // Selective keying: only graph-key positions whose available-graph is small
        // enough to be cheap (and where the iso-merge is densest); larger graphs keep
        // the cheap D4 key. Strictly intra-ply transpositions ⇒ no merges are lost.
        let available = q.board.and_not(blocked);
        if available.popcount() > self.max_avail {
            return q.pos_key(blocked);
        }
        match self.key {
            KeyMode::GraphIr => graph_bits(q.iso_key_ir(available)),
            KeyMode::GraphCanon => graph_bits(q.iso_key_canon(available)),
            KeyMode::GraphComp => graph_bits(q.iso_key_components(available)),
            KeyMode::GraphFast => graph_bits(q.iso_key_fast(available)),
            KeyMode::D4 => unreachable!(),
        }
    }

    /// The cutoff search with `blocked`'s canonical key already in hand. The caller
    /// prefetched the matching slot before recursing, so this entry `get` -- the
    /// first thing every node does -- is typically warm (Session 5, L1 cluster).
    fn wins_keyed(&self, q: &Queens, blocked: Bits, key: Bits) -> bool {
        self.wins_keyed_in::<false>(q, blocked, key)
    }

    /// The cutoff search, monomorphised on `COUNT`. Production is `::<false>` -- the
    /// `COUNT` blocks are compile-time eliminated, so the [`Tally`] is never referenced
    /// and the hot path is byte-identical to before. `::<true>` (selected once at the
    /// root by `branching`) tallies b̄ (canons per node) and the win-node cutoff
    /// distribution for `count --branching`. The const threads down the recursion so the
    /// single runtime decision happens once, at the top -- per the hot-path-toggle rule.
    fn wins_keyed_in<const COUNT: bool>(&self, q: &Queens, blocked: Bits, key: Bits) -> bool {
        if let Some(w) = self.tt.get(key) {
            return w != 0;
        }
        self.tt.bump();
        let mut result = false;
        let mut tried = 0u32;
        for &sq in &q.order {
            if !q.is_available(blocked, sq) {
                continue;
            }
            tried += 1;
            let child = q.place(blocked, sq);
            // Terminal-child fast path: the opponent then cannot move, so we win at
            // once -- skip the recursive probe. Every terminal canonicalises to the
            // same `ZERO` key (`pos_key` folds `available`; empty ⇒ `Bits::ZERO`), so
            // the elided probes would all hammer one hot atomic slot. (Raw-key `memo`
            // keys each terminal by its own `blocked`, so for it `--distinct` drops
            // every terminal, not one key.) A terminal *is* a winning move, so it counts
            // toward the cutoff position (`tried`) but pays no `node_key` (no canon).
            if q.no_moves(child) {
                result = true;
                break;
            }
            let ckey = self.node_key(q, child);
            if COUNT {
                self.tally.edges.fetch_add(1, Ordering::Relaxed);
            }
            // Prefetch the child's slot now; its recursion will probe it first thing.
            self.tt.prefetch(ckey);
            if !self.wins_keyed_in::<COUNT>(q, child, ckey) {
                result = true;
                break;
            }
        }
        if COUNT {
            if result {
                self.tally.win_nodes.fetch_add(1, Ordering::Relaxed);
                self.tally
                    .win_tried_sum
                    .fetch_add(tried as u64, Ordering::Relaxed);
                self.tally.win_cut[(tried as usize - 1).min(7)].fetch_add(1, Ordering::Relaxed);
            } else {
                self.tally.loss_nodes.fetch_add(1, Ordering::Relaxed);
            }
        }
        self.tt.put(key, result as u8);
        result
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
        let key = self.node_key(q, blocked);
        // The single runtime decision: select the counting or production monomorphisation
        // once, at the root; the const threads down the recursion (no per-node branch).
        if self.branching {
            self.wins_keyed_in::<true>(q, blocked, key)
        } else {
            self.wins_keyed_in::<false>(q, blocked, key)
        }
    }
    fn nodes(&self) -> u64 {
        self.tt.nodes()
    }
    fn branching_stats(&self) -> Option<BranchingStats> {
        self.branching.then(|| BranchingStats {
            edges: self.tally.edges.load(Ordering::Relaxed),
            win_nodes: self.tally.win_nodes.load(Ordering::Relaxed),
            loss_nodes: self.tally.loss_nodes.load(Ordering::Relaxed),
            win_tried_sum: self.tally.win_tried_sum.load(Ordering::Relaxed),
            win_cut: std::array::from_fn(|i| self.tally.win_cut[i].load(Ordering::Relaxed)),
        })
    }
    fn cap_bytes(&self) -> u64 {
        self.tt.capacity().1
    }
    fn report(&self) -> Option<CountReport> {
        self.tt.report()
    }
    fn working_set(&self) -> Option<Vec<(Bits, u8)>> {
        self.tt.working_set()
    }
    fn stats(&self) -> String {
        self.tt.summary()
    }
    fn tt(&self) -> Option<&QueensTt> {
        Some(&self.tt)
    }
}

/// **Parallel** -- the production solver. Sequential search is [`Tt`] with
/// canonical keys; `first_player_wins` adds the odd-board O(1) theorem and rayon
/// root parallelism with a Young-Brothers-Wait guard.
pub struct Parallel {
    inner: Tt,
    /// Plies from the root searched in parallel (see [`par_depth`]); below this a
    /// node may *still* split if it is large (see `par_min_avail`), else it drops to
    /// the sequential cutoff search.
    par_depth: u32,
    /// `QUEENS_PAR_MIN_AVAIL` override (`None` = auto by board size); the size-based
    /// split that divides the deep stragglers so idle cores can steal them (#20). See
    /// [`min_avail_for`].
    par_min_avail: Option<u32>,
    /// The effective size-split threshold for the current solve (set at
    /// `first_player_wins` from the board size), captured for the stats line.
    eff_min_avail: AtomicU32,
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
            par_depth: par_depth(),
            par_min_avail: par_min_avail_override(),
            eff_min_avail: AtomicU32::new(u32::MAX),
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
            par_depth: par_depth(),
            par_min_avail: par_min_avail_override(),
            eff_min_avail: AtomicU32::new(u32::MAX),
            root_done: AtomicU64::new(0),
            root_total: AtomicU64::new(0),
        }
    }

    /// Wrap a reloaded checkpoint table for a warm resume (see [`Tt::from_tt`]).
    /// Re-running `first_player_wins` fast-forwards already-solved root subtrees
    /// (instant TT hits) and continues the unsolved ones -- the TT *is* the progress.
    pub fn from_tt(tt: QueensTt) -> Self {
        Parallel {
            inner: Tt::from_tt(tt, true),
            par_depth: par_depth(),
            par_min_avail: par_min_avail_override(),
            eff_min_avail: AtomicU32::new(u32::MAX),
            root_done: AtomicU64::new(0),
            root_total: AtomicU64::new(0),
        }
    }

    /// Recursive parallel cutoff search of `blocked` (canonical key in hand). For the
    /// top [`par_depth`](Self::par_depth) plies it fans children across rayon; below
    /// that it drops to the sequential [`Tt::wins_keyed`]. Parity is the trick: for a
    /// second-player win the tree alternates "prove-a-loss" nodes (every child must be
    /// searched -- no α-β cutoff to lose) with "prove-a-win" nodes (one winner suffices
    /// -- cutoff). The root (refute every first move) is prove-a-loss, so the EVEN plies
    /// below it are too: fan those for free; keep the ODD (prove-a-win) plies sequential
    /// so their cutoff survives (elder child first, which well-ordered usually cuts at
    /// once). This keeps the dominant root-0 subtree off a single core at n=16 while
    /// confining speculation to mis-ordered OR nodes.
    fn par_wins(&self, q: &Queens, blocked: Bits, key: Bits, depth: u32, min_avail: u32) -> bool {
        if let Some(w) = self.inner.tt.get(key) {
            return w != 0;
        }
        // Drop to the sequential cutoff search once we are both below the `par_depth`
        // floor *and* the subtree is small (available count ≤ `min_avail`). Big deep
        // nodes keep splitting so an idle core can steal a straggler -- the #20 tail
        // fix -- with rayon paying the split cost only on an actual steal.
        if depth >= self.par_depth && q.board.and_not(blocked).popcount() <= min_avail {
            return self.inner.wins_keyed(q, blocked, key);
        }
        self.inner.tt.bump();
        // Gather children; a terminal child means the opponent cannot move, so this
        // node wins at once (the [`Tt::wins_keyed`] terminal fast path).
        let mut children: [Bits; MAXV] = [Bits::ZERO; MAXV];
        let mut nc = 0usize;
        for &sq in &q.order {
            if !q.is_available(blocked, sq) {
                continue;
            }
            let child = q.place(blocked, sq);
            if q.no_moves(child) {
                self.inner.tt.put(key, 1);
                return true;
            }
            children[nc] = child;
            nc += 1;
        }
        let kids = &children[..nc];
        let won = if depth.is_multiple_of(2) {
            // Even / prove-a-loss: no α-β cutoff to lose, so fan *all* children at once
            // (no elder-first lead -- that would grind one huge child single-core, the
            // n=16 failure mode). `any` still short-circuits if some child unexpectedly
            // wins (a mis-parity node), but for a true prove-a-loss node all are searched.
            kids.par_iter().any(|&child| {
                let ckey = self.inner.node_key(q, child);
                !self.par_wins(q, child, ckey, depth + 1, min_avail)
            })
        } else {
            // Odd / prove-a-win: keep the α-β cutoff -- sequential, recursing into the
            // parallel even children below.
            let mut w = false;
            for &child in kids {
                let ckey = self.inner.node_key(q, child);
                if !self.par_wins(q, child, ckey, depth + 1, min_avail) {
                    w = true;
                    break;
                }
            }
            w
        };
        self.inner.tt.put(key, won as u8);
        won
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
        // Resolve the size-split threshold once for this solve (auto by board size,
        // env-overridable) -- never per node -- and thread it through the recursion.
        let min_avail = min_avail_for(self.par_min_avail, q.n);
        self.eff_min_avail.store(min_avail, Ordering::Relaxed);
        let moves = q.distinct_first_moves();
        self.root_total.store(moves.len() as u64, Ordering::Relaxed);
        self.root_done.store(0, Ordering::Relaxed);
        match moves.split_first() {
            None => false,
            Some((&first, rest)) => {
                // Elder brother (root move 0): search its subtree *in parallel* (not on a
                // single core), so the dominant first move uses all workers from the start
                // -- the n=16 fix -- while still warming the shared TT before the younger
                // brothers fan out.
                let fc = q.place(Bits::ZERO, first);
                let wins = !self.par_wins(q, fc, self.inner.node_key(q, fc), 1, min_avail);
                self.root_done.fetch_add(1, Ordering::Relaxed);
                if wins {
                    return true; // best move already wins -- no speculation
                }
                rest.par_iter().any(|&sq| {
                    let c = q.place(Bits::ZERO, sq);
                    let wins = !self.par_wins(q, c, self.inner.node_key(q, c), 1, min_avail);
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
    fn working_set(&self) -> Option<Vec<(Bits, u8)>> {
        self.inner.working_set()
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
        let ma = self.eff_min_avail.load(Ordering::Relaxed);
        let ma = if ma == u32::MAX {
            "off".to_string()
        } else {
            ma.to_string()
        };
        format!(
            "{} rayon workers, {done}/{total} root moves, par-depth {}/min-avail {ma} · {}",
            rayon::current_num_threads(),
            self.par_depth,
            self.inner.stats(),
        )
    }
    fn tt(&self) -> Option<&QueensTt> {
        Some(&self.inner.tt)
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
/// HyperLogLog of every looked-up key (the distinct estimate) and, optionally, an
/// exact key→value map (small boards only). The map is populated at `put` -- where
/// the win/loss value is known and exact -- not by peeking the lossy fingerprint TT,
/// whose index collisions would return stale values and pollute the `--iso`
/// win/loss-consistency check.
struct Counter {
    hll: Hll,
    exact: Option<Mutex<HashMap<Bits, u8>>>,
}

impl Counter {
    /// Fold a looked-up key into the HyperLogLog (distinct working-set estimate).
    #[inline]
    fn feed(&self, key: Bits) {
        self.hll.add(key);
    }
    /// Record a solved key's exact value (called from `put`).
    #[inline]
    fn record(&self, key: Bits, val: u8) {
        if let Some(map) = &self.exact {
            map.lock().unwrap().insert(key, val);
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

/// A fixed-size, **lockless** open-addressing transposition table keyed by a board
/// mask -> a `u8` value (win/loss as 0/1, or a Sprague-Grundy nimber). Memory is
/// capped at `2^bits` slots; a fingerprint mismatch is a miss, so eviction only
/// costs recompute (and a foreign same-slot+same-fingerprint hit is a ~`2^-55`
/// wrong, cross-checked vs the known verdict).
///
/// Each slot is a single [`Slot`] = one `u64`, so the table is a flat
/// `Box<[AtomicU64]>` shared lock-free across rayon workers: `get`/`put` are a
/// `Relaxed` `load`/`store`. No mutex, no sharding (Session 5, lead L1). This is
/// safe by construction -- an `AtomicU64` `load` cannot tear, and the value stored
/// for a key is deterministic (a position's win/loss or nimber is fixed), so even
/// a concurrent write for the *same* key stores the *same* value; a write for a
/// *different* key is rejected by the fingerprint. That removes a lock/unlock and
/// the mutex cache-line bounce from every node, attacking the DRAM-latency wall
/// and the mutex contention in the ~18x parallel ceiling. (Hyatt's XOR-key trick
/// is unnecessary: the 55-bit fingerprint already self-validates identity.)
pub struct QueensTt {
    slots: Box<[AtomicU64]>,
    /// Slot count (any value, not just a power of two -- see [`QueensTt::index`]).
    len: u64,
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

/// 1024 shards for [`PnTt`] (still mutex-sharded; `pn` is a tiny-board experiment,
/// not under memory pressure). [`QueensTt`] is lockless and unsharded.
const SHARD_BITS: u32 = 10;

/// Allocate `size` zeroed [`AtomicU64`] slots backed by transparent huge pages
/// (Session 5, L1 cluster). The table is probed at random, so a multi-GB table on
/// 4 KB pages thrashes the TLB on every node; `MADV_HUGEPAGE` cuts that hard. We
/// allocate via `vec![0u64; _]` -- the allocator's `alloc_zeroed`, so the OS hands
/// back lazily-zeroed pages (a 17 GB table does not commit until probed) -- then
/// reinterpret the buffer as `AtomicU64`.
fn zeroed_huge_atomics(size: usize) -> Box<[AtomicU64]> {
    let mut v: Vec<u64> = vec![0u64; size];
    #[cfg(target_os = "linux")]
    unsafe {
        // SAFETY: `madvise` over the live allocation; `MADV_HUGEPAGE` is advisory
        // and only changes page backing, never contents. A failure (e.g. THP off)
        // is a harmless no-op, so the result is ignored.
        libc::madvise(
            v.as_mut_ptr().cast::<libc::c_void>(),
            std::mem::size_of_val(v.as_slice()),
            libc::MADV_HUGEPAGE,
        );
    }
    let (ptr, len, cap) = (v.as_mut_ptr(), v.len(), v.capacity());
    std::mem::forget(v);
    // SAFETY: `AtomicU64` has the same size, alignment, and representation as `u64`
    // (std guarantee), and we take sole ownership of the same `(ptr, len, cap)`
    // allocation exactly once; `len == cap`, so `into_boxed_slice` cannot realloc.
    unsafe { Vec::from_raw_parts(ptr.cast::<AtomicU64>(), len, cap) }.into_boxed_slice()
}

/// Resolve the `QUEENS_TT_SLOTS` exact-slot-count override once (at table
/// construction, never per node). `Some(n)` clamps to at least 2 slots; `None` keeps
/// the `2^bits` default. Lets a run fill all RAM via `fastrange` sizing (Chunk 2b).
fn tt_slots_override() -> Option<usize> {
    std::env::var("QUEENS_TT_SLOTS")
        .ok()
        .and_then(|s| s.parse::<usize>().ok())
        .map(|n| n.max(2))
}

// --------------------------------------------------------------------------- //
// Dumpable / reloadable image (checkpoint + resume; proposal 2026-06-15)
// --------------------------------------------------------------------------- //

/// Magic for a [`QueensTt`] image file. Bumped only if the wire layout changes.
const TT_MAGIC: [u8; 8] = *b"QNSTT\0\0\0";
/// `Slot` layout version (`{used:1, val:8, fp:55}` + `fastrange` routing). Bump on
/// any change to `Slot` packing or the `index` function.
const TT_FORMAT_VERSION: u32 = 1;
/// [`QueensTt::hash128`] seeds/constants version. Bump if either hash half changes
/// (a stale fingerprint would silently mis-route).
const TT_HASH_ID: u32 = 1;
/// `canon`/`pos_key` version. Bump if the canonical key changes (every stored key
/// would then refer to a different position).
const TT_CANON_ID: u32 = 1;
/// Arch/endianness tag: raw little-endian `u64` slots. `1` = x86_64-LE.
const TT_ARCH_X86_64_LE: u8 = 1;
/// Fixed header size in bytes (the rest is the raw slot image).
const TT_HEADER_LEN: usize = 64;

/// The on-disk header of a dumped [`QueensTt`]. The fixed fields tag the *exact*
/// slot layout, hash, canonicalisation, and arch a reload depends on -- a mismatch
/// is a hard error (`io::ErrorKind::InvalidData`), never a silently-voided hit.
///
/// `len` is the slot **count**, not `bits`: routing is `fastrange(route, len)`
/// (see [`QueensTt::index`]), so a table of a different size re-routes every entry
/// and the stored fingerprint -- an independent hash half, not the key -- cannot be
/// recomputed. **An image only reloads into a table of the same `len`.** `epoch` is
/// reserved for delta checkpoints (proposal Phase 2); `fill` is reporting only.
pub struct TtHeader {
    pub n: u8,
    pub len: u64,
    pub fill: u64,
    pub epoch: u32,
}

impl TtHeader {
    fn to_bytes(&self) -> [u8; TT_HEADER_LEN] {
        let mut b = [0u8; TT_HEADER_LEN];
        b[0..8].copy_from_slice(&TT_MAGIC);
        b[8..12].copy_from_slice(&TT_FORMAT_VERSION.to_le_bytes());
        b[12..16].copy_from_slice(&TT_HASH_ID.to_le_bytes());
        b[16..20].copy_from_slice(&TT_CANON_ID.to_le_bytes());
        b[20..24].copy_from_slice(&self.epoch.to_le_bytes());
        b[24..32].copy_from_slice(&self.len.to_le_bytes());
        b[32..40].copy_from_slice(&self.fill.to_le_bytes());
        b[40] = self.n;
        b[41] = TT_ARCH_X86_64_LE;
        // b[42..64] reserved (zero)
        b
    }

    /// Validate and parse a header, hard-erroring on any tag mismatch so a stale or
    /// foreign dump is rejected rather than quietly producing wrong hits.
    fn parse(b: &[u8]) -> io::Result<TtHeader> {
        let bad = |m: String| io::Error::new(io::ErrorKind::InvalidData, m);
        if b.len() < TT_HEADER_LEN {
            return Err(bad("truncated TT header".into()));
        }
        if b[0..8] != TT_MAGIC {
            return Err(bad("not a queens TT image (bad magic)".into()));
        }
        let u32_at = |o: usize| u32::from_le_bytes(b[o..o + 4].try_into().unwrap());
        let check = |got: u32, want: u32, what: &str| {
            (got == want)
                .then_some(())
                .ok_or_else(|| bad(format!("{what} mismatch: image {got}, this build {want}")))
        };
        check(u32_at(8), TT_FORMAT_VERSION, "format_version")?;
        check(u32_at(12), TT_HASH_ID, "hash_id")?;
        check(u32_at(16), TT_CANON_ID, "canon_id")?;
        if b[41] != TT_ARCH_X86_64_LE {
            return Err(bad(format!(
                "arch mismatch: image {}, expected x86_64-LE",
                b[41]
            )));
        }
        Ok(TtHeader {
            epoch: u32_at(20),
            len: u64::from_le_bytes(b[24..32].try_into().unwrap()),
            fill: u64::from_le_bytes(b[32..40].try_into().unwrap()),
            n: b[40],
        })
    }
}

/// Slots transferred per read/write block (`BLOCK * 8` bytes ≈ 512 KB) -- amortises
/// per-call overhead over the streamed image without a large buffer.
const TT_IO_BLOCK: usize = 1 << 16;

impl QueensTt {
    /// A lockless table of `2^bits` slots (each 8 bytes; see [`Slot`]). `bits` is the
    /// memory cap knob. `QUEENS_TT_SLOTS` overrides with an exact slot **count** (any
    /// value, not just a power of two) -- resolved once here, never per node -- so a run
    /// can fill *all* available RAM rather than the next power of two below it (Chunk 2b;
    /// at 8 B/slot the 2^31 = 17 GB → 2^32 = 34 GB gap straddles a 26 GB box's sweet
    /// spot). Indexing is Lemire `fastrange` ([`QueensTt::index`]), which maps a hash to
    /// `[0, len)` for any `len`.
    pub fn new(bits: u32) -> Self {
        let size = tt_slots_override().unwrap_or_else(|| 1usize << bits.max(1));
        QueensTt {
            slots: zeroed_huge_atomics(size),
            len: size as u64,
            nodes: AtomicU64::new(0),
            counter: None,
        }
    }

    /// Lemire's `fastrange`: map a 64-bit hash uniformly into `[0, len)` with a single
    /// widening multiply + shift -- the power-of-two-free replacement for `hash & mask`,
    /// so the table can be sized to any slot count (Chunk 2b). The extra multiply is
    /// negligible against the random-probe DRAM latency the search is bound by.
    #[inline]
    fn index(&self, route: u64) -> usize {
        ((route as u128).wrapping_mul(self.len as u128) >> 64) as usize
    }

    /// A table that also counts the distinct positions it is queried for: every
    /// `get` folds the (canonical) key into a HyperLogLog of precision `hll_p`,
    /// and (when `exact`) into a hash set for an exact ground truth on small
    /// boards. Used by the `count` CLI mode to size the table's true working set.
    pub fn new_counting(bits: u32, hll_p: u32, exact: bool) -> Self {
        let mut tt = Self::new(bits);
        tt.counter = Some(Counter {
            hll: Hll::new(hll_p),
            exact: exact.then(|| Mutex::new(HashMap::new())),
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

    /// The exact working set as (canonical key, win/loss value) pairs, if an exact
    /// map was kept (`count --exact`). Values are the exact ones recorded at `put`,
    /// not peeked from the lossy TT. Cold post-search analysis only (`--iso`).
    pub fn working_set(&self) -> Option<Vec<(Bits, u8)>> {
        let map = self.counter.as_ref()?.exact.as_ref()?.lock().unwrap();
        Some(map.iter().map(|(&k, &v)| (k, v)).collect())
    }

    /// Total slot capacity and its byte footprint, for reporting the cap.
    pub fn capacity(&self) -> (u64, u64) {
        let slots = self.slots.len() as u64;
        (slots, slots * std::mem::size_of::<AtomicU64>() as u64)
    }

    /// Occupied slots, by a one-time scan (post-solve; cheap relative to the
    /// search). Combined with [`capacity`](Self::capacity) it gives the load
    /// factor, and `nodes > fill` reveals how much eviction forced re-expansion.
    pub fn fill(&self) -> u64 {
        self.slots
            .iter()
            .filter(|s| Slot(s.load(Ordering::Relaxed)).used())
            .count() as u64
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
        let raw = self.slots[self.index(route)].load(Ordering::Relaxed);
        let s = Slot(raw);
        (s.used() && s.fp() == (fp & Slot::fp_mask())).then(|| s.val())
    }

    /// Store `val` for `key` (replace-always on collision).
    #[inline]
    pub fn put(&self, key: Bits, val: u8) {
        let (route, fp) = Self::hash128(key);
        self.slots[self.index(route)].store(Slot::pack(fp, val).0, Ordering::Relaxed);
        // Record the exact value for the post-search `--iso` analysis (cold; only
        // when an exact map is kept). Here the value is known and eviction-proof.
        if let Some(c) = &self.counter {
            c.record(key, val);
        }
    }

    /// Prefetch the slot `key` will land in, so the demand `get` that follows finds
    /// it warm -- overlapping the random-probe DRAM round-trip with the work in
    /// between (Session 5, L1 cluster). x86_64 only; a no-op elsewhere.
    #[inline]
    pub fn prefetch(&self, key: Bits) {
        let idx = self.index(Self::hash128(key).0);
        let ptr = self.slots[idx].as_ptr();
        #[cfg(target_arch = "x86_64")]
        unsafe {
            // SAFETY: `_mm_prefetch` only warms the cache for a valid pointer into
            // our live allocation; it has no architectural effect and cannot fault.
            std::arch::x86_64::_mm_prefetch::<{ std::arch::x86_64::_MM_HINT_T0 }>(ptr as *const i8);
        }
        #[cfg(not(target_arch = "x86_64"))]
        let _ = ptr;
    }

    /// Stream this table as a raw image (`header || little-endian slot u64s`) to
    /// `w` (proposal Approach A). Each slot is read with a single relaxed atomic
    /// load, so a *live* dump under concurrent writers is a valid partial memo --
    /// each `u64` is never torn and every stored value is a final verdict, so the
    /// snapshot is sound to reload (good-enough-live; it only misses in-flight
    /// `put`s). `n` tags the board the image belongs to. The empty slots are zero,
    /// so the stream compresses well -- wrap `w` in a zstd encoder at the call site.
    pub fn dump_image<W: Write>(&self, w: &mut W, n: u8) -> io::Result<()> {
        let header = TtHeader {
            n,
            len: self.len,
            fill: 0, // reporting-only; a full pre-scan every checkpoint isn't worth it
            epoch: 0,
        };
        w.write_all(&header.to_bytes())?;
        let mut buf = Vec::with_capacity(TT_IO_BLOCK * 8);
        for chunk in self.slots.chunks(TT_IO_BLOCK) {
            buf.clear();
            for slot in chunk {
                buf.extend_from_slice(&slot.load(Ordering::Relaxed).to_le_bytes());
            }
            w.write_all(&buf)?;
        }
        Ok(())
    }

    /// Reload a raw image written by [`dump_image`](Self::dump_image) into a fresh
    /// table, hard-erroring if the header's format/hash/canon/arch tags or `n` don't
    /// match this build (a mismatch would silently void every hit). The table is
    /// sized to the image's `len` -- routing is `fastrange(route, len)`, so it cannot
    /// be re-keyed into a different size. `counter` is `None`; attach one with
    /// [`attach_counter`](Self::attach_counter) for a `--distinct` resume.
    pub fn load_image<R: Read>(r: &mut R, expected_n: u8) -> io::Result<QueensTt> {
        let mut hbuf = [0u8; TT_HEADER_LEN];
        r.read_exact(&mut hbuf)?;
        let header = TtHeader::parse(&hbuf)?;
        if header.n != expected_n {
            return Err(io::Error::new(
                io::ErrorKind::InvalidData,
                format!(
                    "image is for n={}, but this run is n={expected_n}",
                    header.n
                ),
            ));
        }
        let size = header.len as usize;
        let slots = zeroed_huge_atomics(size);
        let mut buf = vec![0u8; TT_IO_BLOCK * 8];
        let mut i = 0usize;
        while i < size {
            let take = TT_IO_BLOCK.min(size - i);
            let bytes = &mut buf[..take * 8];
            r.read_exact(bytes)?;
            for (j, slot) in slots[i..i + take].iter().enumerate() {
                let word = u64::from_le_bytes(bytes[j * 8..j * 8 + 8].try_into().unwrap());
                slot.store(word, Ordering::Relaxed);
            }
            i += take;
        }
        Ok(QueensTt {
            slots,
            len: header.len,
            nodes: AtomicU64::new(0),
            counter: None,
        })
    }

    /// Attach distinct-position instrumentation to an already-built table (e.g. a
    /// reloaded image), so a `--resume` run can still report its working set. See
    /// [`new_counting`](Self::new_counting).
    pub fn attach_counter(&mut self, hll_p: u32, exact: bool) {
        self.counter = Some(Counter {
            hll: Hll::new(hll_p),
            exact: exact.then(|| Mutex::new(HashMap::new())),
        });
    }

    /// The BuRR archive key a live `key` resolves to in *this* table (Chunk 4).
    /// A frozen [`burr::Archive`](crate::burr::Archive) is keyed by the slot
    /// identity `(index, fingerprint)` recovered from a dump (see
    /// [`archive_key_of`]); querying it during search recomputes that pair from the
    /// position's canonical `key`. The archive **must** be frozen from a dump of a
    /// table with the same `len` -- the slot index is `fastrange(route, len)`, so a
    /// different size re-routes every key.
    #[inline]
    pub fn archive_key(&self, key: Bits) -> u64 {
        let (route, fp) = Self::hash128(key);
        archive_key_of(self.index(route) as u64, fp & Slot::fp_mask())
    }
}

/// Derive the BuRR archive key for a TT slot identity `(slot_index, fingerprint)`.
///
/// The dumped TT image stores only a 55-bit fingerprint per slot, not the position
/// key, so an archived entry is identified by the same pair the live table resolves
/// a position to: its slot **index** and its stored **fingerprint**. Two positions
/// sharing both already collide in the live TT (the accepted ~`2^-55` event), so
/// keying the archive on this pair reproduces the table's resolution exactly -- no
/// new merge loss. The query path recomputes the pair via [`QueensTt::archive_key`].
#[inline]
pub fn archive_key_of(slot_index: u64, fingerprint: u64) -> u64 {
    // Fold both halves through the mixer so neither dominates the low bits the
    // ribbon's start/coeff hashes consume.
    mix64(mix64(slot_index) ^ fingerprint.wrapping_mul(0xC2B2_AE3D_27D4_EB4F))
}

/// Stream a dumped [`QueensTt`] image, invoking `f(archive_key, val)` for each
/// occupied slot -- the freeze source for a BuRR [`burr::Archive`](crate::burr::Archive).
/// Validates the header (the same hard format/hash/canon/arch/`n` checks as
/// [`QueensTt::load_image`]) and returns it. Reads block by block, so it never
/// materialises the whole table -- a 17 GB n=16 dump streams in ~512 KB chunks,
/// which is what lets the freeze run on a box too small to also hold the table.
pub fn for_each_image_entry<R: Read, F: FnMut(u64, u8)>(
    r: &mut R,
    expected_n: u8,
    mut f: F,
) -> io::Result<TtHeader> {
    let mut hbuf = [0u8; TT_HEADER_LEN];
    r.read_exact(&mut hbuf)?;
    let header = TtHeader::parse(&hbuf)?;
    if header.n != expected_n {
        return Err(io::Error::new(
            io::ErrorKind::InvalidData,
            format!(
                "image is for n={}, but this run is n={expected_n}",
                header.n
            ),
        ));
    }
    let size = header.len as usize;
    let mut buf = vec![0u8; TT_IO_BLOCK * 8];
    let mut idx = 0usize;
    while idx < size {
        let take = TT_IO_BLOCK.min(size - idx);
        let bytes = &mut buf[..take * 8];
        r.read_exact(bytes)?;
        for (j, word8) in bytes.chunks_exact(8).enumerate() {
            let s = Slot(u64::from_le_bytes(word8.try_into().unwrap()));
            if s.used() {
                f(archive_key_of((idx + j) as u64, s.fp()), s.val());
            }
        }
        idx += take;
    }
    Ok(header)
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
                q.principal_variation(&s, true).len(),
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
            let pv = q.principal_variation(&s, true); // mirror_line (root_wins ignored when odd)
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
            let pv = q.principal_variation(&s, first_wins);
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

    /// A dumped TT image reloads into the same verdict and resumes *warm*: the
    /// fresh solver re-confirms the result almost entirely from cached hits, and a
    /// header for the wrong board is a hard error, not a silent mis-load.
    #[test]
    fn tt_image_round_trips_and_warms() {
        let q = Queens::new(10);
        // Cold solve, populating the table.
        let cold = Tt::new(16, true);
        let v1 = cold.first_player_wins(&q);
        let cold_nodes = cold.nodes();
        assert!(cold_nodes > 1000, "n=10 searches a real number of nodes");

        // Dump the warm table to an in-memory image and reload it.
        let mut img = Vec::new();
        cold.tt().unwrap().dump_image(&mut img, q.n as u8).unwrap();
        let reloaded = QueensTt::load_image(&mut img.as_slice(), q.n as u8).unwrap();

        // A fresh solver around the reloaded table re-confirms the verdict from the
        // root cache hit -- the warm-resume property (the TT *is* the progress).
        let warm = Tt::from_tt(reloaded, true);
        let v2 = warm.first_player_wins(&q);
        assert_eq!(v1, v2, "reloaded table yields the same verdict");
        assert!(
            warm.nodes() < cold_nodes / 100,
            "warm resume re-searches almost nothing: {} vs cold {cold_nodes}",
            warm.nodes(),
        );

        // The image is rejected for a different board, not silently mis-keyed.
        let reject = |r: io::Result<QueensTt>, what: &str| match r {
            Err(e) => assert_eq!(e.kind(), io::ErrorKind::InvalidData, "{what}"),
            Ok(_) => panic!("{what}: must be rejected"),
        };
        reject(
            QueensTt::load_image(&mut img.as_slice(), q.n as u8 + 2),
            "wrong-n image",
        );
        // ...and rubbish bytes fail the magic check.
        reject(
            QueensTt::load_image(&mut [0u8; TT_HEADER_LEN].as_slice(), q.n as u8),
            "bad magic",
        );
    }

    /// The #9 free-involution loss certificate fires exactly on 180°-symmetric,
    /// off-centre-diagonal masks, and (cross-checked at scale by `count --psym`,
    /// which finds zero false fires) only on genuine losses.
    #[test]
    fn free_involution_certificate_conditions() {
        let q = Queens::new(4);
        let m = |squares: &[(u32, u32)]| {
            let mut b = Bits::ZERO;
            for &(r, c) in squares {
                b.set(q.square(r, c));
            }
            b
        };
        // 180°-symmetric (each square's rot180 partner present) and off both centre
        // diagonals (r≠c and r+c≠3) ⇒ fires.
        assert!(
            q.is_free_involution_loss(m(&[(0, 1), (3, 2)])),
            "symmetric + off-diagonal must fire"
        );
        // Symmetric but on the main diagonal (0,0)↔(3,3) ⇒ a square attacks its own
        // image, mirror strategy breaks ⇒ must NOT fire.
        assert!(
            !q.is_free_involution_loss(m(&[(0, 0), (3, 3)])),
            "on-diagonal must not fire"
        );
        // Not 180°-symmetric ⇒ must not fire.
        assert!(
            !q.is_free_involution_loss(m(&[(0, 1)])),
            "asymmetric must not fire"
        );
        // The empty board is symmetric but every diagonal square is present ⇒ off by
        // the diagonal condition (the certificate must not call the start a loss).
        assert!(
            !q.is_free_involution_loss(q.board),
            "full board must not fire"
        );
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

    /// The tiny-component shortcut (#18) must induce exactly the same isomorphism
    /// partition as the full WL+IR canon on every small connected component drawn from
    /// a real queen graph: isomorphic components share a key under both keys, and the
    /// two never disagree about whether two components are isomorphic. This is what
    /// keeps the graph-key merge -- and so the distinct working set -- unchanged.
    #[test]
    fn tiny_component_key_matches_full_canon() {
        let q = Queens::new(6);
        let sq: Vec<u32> = (0..q.n * q.n).collect();

        // Enumerate every connected induced subgraph of size 1..=TINY_MAX.
        let mut comps: Vec<(Bits, usize)> = Vec::new();
        for &a in &sq {
            comps.push((single(a), 1));
        }
        for i in 0..sq.len() {
            for j in i + 1..sq.len() {
                let c = single(sq[i]).or(single(sq[j]));
                if q.component(sq[i], c).popcount() == 2 {
                    comps.push((c, 2));
                }
            }
        }
        for i in 0..sq.len() {
            for j in i + 1..sq.len() {
                for l in j + 1..sq.len() {
                    let c = single(sq[i]).or(single(sq[j])).or(single(sq[l]));
                    if q.component(sq[i], c).popcount() == 3 {
                        comps.push((c, 3));
                    }
                }
            }
        }
        for i in 0..sq.len() {
            for j in i + 1..sq.len() {
                for l in j + 1..sq.len() {
                    for m in l + 1..sq.len() {
                        let c = single(sq[i])
                            .or(single(sq[j]))
                            .or(single(sq[l]))
                            .or(single(sq[m]));
                        if q.component(sq[i], c).popcount() == 4 {
                            comps.push((c, 4));
                        }
                    }
                }
            }
        }

        // For the two keys to define the same partition, tiny->full and full->tiny must
        // both be single-valued (a bijection between the value sets actually seen).
        let mut scratch = *IsoScratch::new();
        let mut tiny_to_full: HashMap<u64, u64> = HashMap::new();
        let mut full_to_tiny: HashMap<u64, u64> = HashMap::new();
        let mut counts = [0usize; TINY_MAX + 1];
        for (comp, k) in comps {
            let mut kk = 0usize;
            comp.each(|v| {
                scratch.verts[kk] = v as u8;
                kk += 1;
            });
            assert_eq!(kk, k);
            let tiny = tiny_comp_key(&q.attack, comp, k, &scratch.verts);
            let full = q.comp_canon_full(comp, k, &mut scratch);
            if let Some(&f) = tiny_to_full.get(&tiny) {
                assert_eq!(f, full, "tiny key collides two full classes (over-merge)");
            } else {
                tiny_to_full.insert(tiny, full);
            }
            if let Some(&t) = full_to_tiny.get(&full) {
                assert_eq!(t, tiny, "full key splits into two tiny keys (over-split)");
            } else {
                full_to_tiny.insert(full, tiny);
            }
            counts[k] += 1;
        }
        for (k, &c) in counts.iter().enumerate().skip(1) {
            assert!(c > 0, "corpus saw no size-{k} components");
        }
    }
}
