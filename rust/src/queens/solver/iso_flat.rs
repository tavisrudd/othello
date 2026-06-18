//! `IsoFlat` -- [`Fused`](super::Fused)'s selective single graph-iso key (the merge of
//! [`IsoBurr`](super::IsoBurr) at [`Incremental`](super::Incremental)'s nodes/sec) over a
//! **flat lockless [`QueensTt`]** instead of the log-structured [`BurrStore`].
//!
//! `fused` is eviction-free by *freezing* solved entries into immutable BuRR segments, but
//! a miss then walks the whole segment cascade -- so throughput decays from the ~30 M/s
//! memtable regime out of the gate to ~10 M/s once the cascade builds. A flat table never
//! decays: a miss is one O(1) probe forever (the TT probe is ~1% of cycles -- the search is
//! per-node compute-bound, not memory-bound). So iso-flat sustains the fast regime.
//!
//! Same per-node kernel as `fused`/`burr`/`incremental`: the 8 dihedral orientations of the
//! available mask carried down the DFS (`child_orient`, ~62 cyc/move, no re-fold) and a
//! **single** selective key -- the cheap L1-resident tiny graph-iso canon for small
//! fragmented graphs (`popcount <= iso_max_avail`, the transposition-rich deep nodes; the WL
//! canon above the tiny table), else the incremental D4 `lex_min8`, in disjoint tagged
//! namespaces. `iso_max_avail` dials the throughput/merge/fit trilemma: low (≤7, tiny-table
//! only -- the default) avoids all live WL → fast; raising it merges more at WL cost. Sound
//! because the key choice is a pure function of the position (its available popcount) and
//! transpositions are strictly intra-ply.
//!
//! The flat table normally evicts at n=16; the selective merge keeps the resident set
//! smaller than D4, trading some merge for the cheap key. The full-merge (pure-iso, fits-but-
//! WL-bound) end is reachable by raising `iso_max_avail`, but is not the throughput default.

use super::graph::small_canon_table;
use super::incremental::{build_att, child_orient, lex_min8, orient_of};
use super::*;
use rayon::prelude::*;
use std::cell::RefCell;
use std::mem::MaybeUninit;
use std::sync::atomic::{AtomicU32, AtomicU64, Ordering};
use std::sync::OnceLock;

const ORACLE_FLUSH: u64 = 1 << 14;

#[derive(Default)]
struct OracleAcc {
    attempts: u64,
    hits: u64,
    comp_hits: u64,
    comp_misses: u64,
}

thread_local! {
    static ORACLE_ACC: RefCell<OracleAcc> = const { RefCell::new(OracleAcc {
        attempts: 0,
        hits: 0,
        comp_hits: 0,
        comp_misses: 0,
    }) };
}

#[inline(always)]
fn avail_has(avail: Bits, sq: u32) -> bool {
    debug_assert!((sq as usize) < MAXV);
    let word = (sq >> 6) as usize;
    let bit = sq & 63;
    // SAFETY: every caller feeds squares from `q.order` or a filtered subsequence of it.
    // `q.order` is built from board squares (`< n*n <= MAXV`), so the word index is in range.
    unsafe { (*avail.0.get_unchecked(word) & (1u64 << bit)) != 0 }
}

#[inline(always)]
fn att_for(att: &[[Bits; 8]], sq: u32) -> &[Bits; 8] {
    debug_assert!((sq as usize) < att.len());
    // SAFETY: `sq` is drawn from `q.order` or its filtered subsequences, and `att` has one
    // entry per board square.
    unsafe { att.get_unchecked(sq as usize) }
}

#[inline(always)]
fn att0(att: &[[Bits; 8]], sq: u32) -> Bits {
    att_for(att, sq)[0]
}

/// Filter `pmoves` (the parent node's available squares, already in `q.order`) down to the
/// squares still set in `avail`, written compactly into `buf` and returned as a slice. This
/// replaces the per-node scan over all `n²` squares with a scan over the parent's
/// (monotonically shrinking) move list. It preserves the `q.order` subsequence, so the move
/// order — and therefore the searched node set — is byte-identical. `buf` is left uninit (no
/// `n²`-wide zero-init, which would cost more than the scan it removes).
#[inline]
fn filter_moves<'a>(
    buf: &'a mut [MaybeUninit<u32>; MAXV],
    pmoves: &[u32],
    avail: Bits,
) -> &'a [u32] {
    let mut nc = 0usize;
    for &sq in pmoves {
        if avail_has(avail, sq) {
            // SAFETY: `pmoves` is a `q.order` subsequence and therefore has at most MAXV
            // entries; `nc` only counts entries accepted from that slice.
            unsafe { buf.get_unchecked_mut(nc).write(sq) };
            nc += 1;
        }
    }
    // SAFETY: the loop initialised exactly `buf[..nc]` via `write`; `MaybeUninit<u32>` is
    // layout-identical to `u32` and `u32` has no invalid bit patterns, so reading that
    // prefix back as `&[u32]` (bounded by the returned `'a` borrow of `buf`) is sound.
    unsafe { std::slice::from_raw_parts(buf.as_ptr() as *const u32, nc) }
}

/// Resolve a `u32` env knob once at construction (never per node). Used for the
/// leaf-oracle prototype thresholds.
fn env_u32(name: &str, default: u32) -> u32 {
    std::env::var(name)
        .ok()
        .and_then(|s| s.parse().ok())
        .unwrap_or(default)
}

/// Tag a complete component iso key into a namespace disjoint from the position keys
/// ([`graph_bits`]/[`d4_bits`]) so the flat TT can memoise per-component **nimbers**
/// (stored in the `val` byte, `< 16`) alongside the win/loss position entries without
/// aliasing (collisions only at the table's ~2⁻⁵⁵ fingerprint rate, like any TT entry).
#[inline]
fn comp_nimber_bits(h: u64) -> Bits {
    Bits([
        h,
        mix64(h ^ 0x4E49_4D42_4552_0001),
        0x4E49_4D42_4552_4E49,
        0x4E49_4D42_0000_0000,
    ])
}

/// **IsoFlat** -- the A3 DFS-resident kernel + flat lockless TT + single selective iso/D4 key.
pub struct IsoFlat {
    tt: QueensTt,
    att: OnceLock<Box<[[Bits; 8]]>>,
    tiny_canon: &'static [u64],
    par_depth: u32,
    par_min_avail: Option<u32>,
    iso_max_avail: u32,
    eff_min_avail: AtomicU32,
    root_done: AtomicU64,
    root_total: AtomicU64,
    // Lever-B leaf-oracle prototype (QUEENS_NIMBER_ORACLE=1): when a node's available
    // graph fully decomposes into connected components each ≤ `nimber_k`, resolve it by
    // decompose → per-component nimber (memoised) → XOR → win iff ≠0, with NO recursion.
    // Because max-component is monotone non-increasing down the tree, this prunes the
    // whole all-small region below its frontier (G1: ~42% of distinct nodes at ≤7, n=14).
    nimber_oracle: bool,
    nimber_k: u32,
    nimber_pc: u32,
    tiny8_direct: bool,
    oracle_attempts: AtomicU64,
    oracle_hits: AtomicU64,
    oracle_comp_hits: AtomicU64,
    oracle_comp_misses: AtomicU64,
}

impl IsoFlat {
    pub fn new(bits: u32) -> Self {
        Self::from_tt(QueensTt::new(bits))
    }

    /// As [`IsoFlat::new`], but counting the distinct (tagged iso/D4) keys visited
    /// (`--distinct`). The HyperLogLog folded in at each `get` is lock-free, so it works
    /// under root parallelism.
    pub fn new_counting(bits: u32, hll_p: u32) -> Self {
        Self::from_tt(QueensTt::new_counting(bits, hll_p, false))
    }

    fn from_tt(tt: QueensTt) -> Self {
        IsoFlat {
            tt,
            att: OnceLock::new(),
            tiny_canon: small_canon_table(),
            par_depth: par_depth(),
            par_min_avail: par_min_avail_override(),
            iso_max_avail: iso_flat_key_max_avail(),
            eff_min_avail: AtomicU32::new(u32::MAX),
            root_done: AtomicU64::new(0),
            root_total: AtomicU64::new(0),
            nimber_oracle: std::env::var("QUEENS_NIMBER_ORACLE").as_deref() == Ok("1"),
            nimber_k: env_u32("QUEENS_NIMBER_K", 7).min(7),
            nimber_pc: env_u32("QUEENS_NIMBER_PC", 28),
            tiny8_direct: std::env::var("QUEENS_TINY8").as_deref() == Ok("1"),
            oracle_attempts: AtomicU64::new(0),
            oracle_hits: AtomicU64::new(0),
            oracle_comp_hits: AtomicU64::new(0),
            oracle_comp_misses: AtomicU64::new(0),
        }
    }

    #[inline]
    fn att(&self, q: &Queens) -> &[[Bits; 8]] {
        self.att.get_or_init(|| build_att(q))
    }

    /// The single canonical key for a node from its 8 orientations: the tiny-table graph-iso
    /// key (tagged) when the available graph is small enough to merge cheaply, else the
    /// incremental D4 key (tagged into a disjoint namespace). One key per node.
    #[inline]
    fn node_key(&self, q: &Queens, orient: &[Bits; 8]) -> Bits {
        let avail = orient[0];
        let pc = avail.popcount();
        if pc <= self.iso_max_avail {
            let h = if pc <= 7 {
                q.iso_key_tiny_table_pc(avail, pc, self.tiny_canon)
            } else if pc == 8 && self.tiny8_direct {
                q.iso_key8_direct(avail)
            } else {
                q.iso_key_fast(avail)
            };
            graph_bits(h)
        } else {
            d4_bits(lex_min8(orient))
        }
    }

    /// The iso-band key from `avail` alone (no orientations), given its already-computed
    /// popcount `pc ≤ iso_max_avail`: the cheap tiny-table iso key for `pc ≤ 7`, the WL fast
    /// key above. The [`wins_tiny`](Self::wins_tiny) tail never needs the 8 D4 orientations,
    /// so this skips `node_key`'s `lex_min8`/`child_orient` machinery entirely.
    #[inline]
    fn iso_node_key(&self, q: &Queens, avail: Bits, pc: u32) -> Bits {
        let h = if pc <= 7 {
            q.iso_key_tiny_table_pc(avail, pc, self.tiny_canon)
        } else if pc == 8 && self.tiny8_direct {
            q.iso_key8_direct(avail)
        } else {
            q.iso_key_fast(avail)
        };
        graph_bits(h)
    }

    /// Lever-B leaf oracle: if `avail` decomposes into connected components each
    /// `≤ nimber_k`, return its exact win/loss via the Sprague-Grundy nimber (XOR of the
    /// per-component nimbers, `win ⇔ ≠0`) with no recursion; else `None` (a big component
    /// remains → fall through to the normal search). Sound: impartial normal-play, the
    /// components are independent games (a queen in one component only removes squares of
    /// that component), so the position nimber is their nim-sum.
    #[inline]
    fn try_oracle_nimber(&self, q: &Queens, avail: Bits) -> Option<u8> {
        self.oracle_attempt();
        let mut x = 0u8;
        let mut rem = avail;
        while let Some(start) = rem.lowest() {
            let comp = q.component(start, avail);
            if comp.popcount() > self.nimber_k {
                return None;
            }
            rem = rem.and_not(comp);
            x ^= self.comp_nimber(q, comp);
        }
        self.oracle_hit();
        Some(x)
    }

    /// Nimber of a single **connected** component (`≤ nimber_k ≤ 7` ⇒ `iso_key_tiny_table`
    /// is the cheap *complete* iso key), memoised in the flat TT under a disjoint
    /// nimber-tagged namespace. Recurses through the component's children (each strictly
    /// smaller ⇒ stays in-band) via the nim-sum of *their* components.
    fn comp_nimber(&self, q: &Queens, comp: Bits) -> u8 {
        let key = comp_nimber_bits(q.iso_key_tiny_table_in(comp, self.tiny_canon));
        let (route, fp) = QueensTt::hash128(key);
        if let Some(v) = self.tt.get_hashed(route, fp) {
            self.oracle_comp_hit();
            return v;
        }
        self.oracle_comp_miss();
        let mut seen = 0u64; // bitset of child nimbers (all < n ≤ 16 < 64)
        let mut rem = comp;
        while let Some(sq) = rem.lowest() {
            rem = rem.and_not(single(sq));
            // place a queen on sq: remove sq + every square it attacks (q.attack[sq]
            // includes sq), leaving a (possibly disconnected) smaller sub-position.
            let child = comp.and_not(q.attack[sq as usize]);
            seen |= 1u64 << self.position_nimber(q, child);
        }
        let mex = (!seen).trailing_zeros() as u8;
        self.tt.put_hashed(route, fp, mex);
        mex
    }

    /// Nimber of a possibly-disconnected in-band sub-position = nim-sum of its components'
    /// nimbers. Only ever called on children of an in-band component (so every component
    /// is `≤ nimber_k`; no size re-check needed).
    fn position_nimber(&self, q: &Queens, mask: Bits) -> u8 {
        let mut x = 0u8;
        let mut rem = mask;
        while let Some(start) = rem.lowest() {
            let comp = q.component(start, mask);
            rem = rem.and_not(comp);
            x ^= self.comp_nimber(q, comp);
        }
        x
    }

    #[inline]
    fn oracle_attempt(&self) {
        ORACLE_ACC.with(|cell| {
            let mut a = cell.borrow_mut();
            a.attempts += 1;
            if a.attempts + a.hits + a.comp_hits + a.comp_misses >= ORACLE_FLUSH {
                self.flush_oracle_acc(&mut a);
            }
        });
    }

    #[inline]
    fn oracle_hit(&self) {
        ORACLE_ACC.with(|cell| {
            let mut a = cell.borrow_mut();
            a.hits += 1;
            if a.attempts + a.hits + a.comp_hits + a.comp_misses >= ORACLE_FLUSH {
                self.flush_oracle_acc(&mut a);
            }
        });
    }

    #[inline]
    fn oracle_comp_hit(&self) {
        ORACLE_ACC.with(|cell| {
            let mut a = cell.borrow_mut();
            a.comp_hits += 1;
            if a.attempts + a.hits + a.comp_hits + a.comp_misses >= ORACLE_FLUSH {
                self.flush_oracle_acc(&mut a);
            }
        });
    }

    #[inline]
    fn oracle_comp_miss(&self) {
        ORACLE_ACC.with(|cell| {
            let mut a = cell.borrow_mut();
            a.comp_misses += 1;
            if a.attempts + a.hits + a.comp_hits + a.comp_misses >= ORACLE_FLUSH {
                self.flush_oracle_acc(&mut a);
            }
        });
    }

    fn flush_oracle_acc(&self, a: &mut OracleAcc) {
        if a.attempts != 0 {
            self.oracle_attempts
                .fetch_add(a.attempts, Ordering::Relaxed);
            a.attempts = 0;
        }
        if a.hits != 0 {
            self.oracle_hits.fetch_add(a.hits, Ordering::Relaxed);
            a.hits = 0;
        }
        if a.comp_hits != 0 {
            self.oracle_comp_hits
                .fetch_add(a.comp_hits, Ordering::Relaxed);
            a.comp_hits = 0;
        }
        if a.comp_misses != 0 {
            self.oracle_comp_misses
                .fetch_add(a.comp_misses, Ordering::Relaxed);
            a.comp_misses = 0;
        }
    }

    fn drain_oracle_local(&self) {
        ORACLE_ACC.with(|cell| self.flush_oracle_acc(&mut cell.borrow_mut()));
    }

    fn drain_oracle_all(&self) {
        rayon::broadcast(|_| ORACLE_ACC.with(|cell| self.flush_oracle_acc(&mut cell.borrow_mut())));
        self.drain_oracle_local();
    }

    /// Sequential cutoff search (the [`Fused::wins_inc`](super::Fused) twin over the flat TT).
    /// `(route, fp)` are `key`'s precomputed hash halves (hash-carry): each child key is
    /// hashed once at creation and the halves are reused for its prefetch, lookup, and store.
    // Flat args (key + carried hash + move list) are deliberate on this hot recursive path —
    // bundling them into a context struct would add a per-node pointer-chase.
    #[allow(clippy::too_many_arguments)]
    fn wins_inc<const ORACLE: bool, const PROVE_LOSS: bool>(
        &self,
        q: &Queens,
        att: &[[Bits; 8]],
        orient: &[Bits; 8],
        key: Bits,
        route: u64,
        fp: u64,
        pmoves: &[u32],
        nodes: &mut u64,
    ) -> bool {
        if let Some(w) = self.tt.get_h(key, route, fp) {
            return w != 0;
        }
        let avail = orient[0];
        if ORACLE && avail.popcount() <= self.nimber_pc {
            if let Some(nim) = self.try_oracle_nimber(q, avail) {
                let w = nim != 0;
                self.tt.put_h(key, route, fp, w as u8);
                return w;
            }
        }
        self.tt.bump_local(nodes);
        let mut result = false;
        if PROVE_LOSS {
            let mut buf = [MaybeUninit::<u32>::uninit(); MAXV];
            let moves = filter_moves(&mut buf, pmoves, avail);
            for &sq in moves {
                let a = att_for(att, sq);
                let child0 = avail.and_not(a[0]);
                if child0 == Bits::ZERO {
                    result = true;
                    break;
                }
                // available-popcount is monotone non-increasing down the tree, so once a child
                // enters the iso band it stays there: route it to the orientation-free `wins_tiny`
                // (no `child_orient`, no `lex_min8`) — the deepest, highest-node-count region.
                // Children inherit this node's `moves` as their parent list (a `q.order` subseq).
                let pc = child0.popcount();
                let lost = if pc <= self.iso_max_avail {
                    let ckey = self.iso_node_key(q, child0, pc);
                    let (cr, cf) = QueensTt::hash128(ckey);
                    self.tt.prefetch_h(cr);
                    !self.wins_tiny::<ORACLE, false>(q, att, child0, ckey, cr, cf, moves, nodes)
                } else {
                    let child = child_orient(orient, a, child0);
                    let ckey = d4_bits(lex_min8(&child));
                    let (cr, cf) = QueensTt::hash128(ckey);
                    self.tt.prefetch_h(cr);
                    !self.wins_inc::<ORACLE, false>(q, att, &child, ckey, cr, cf, moves, nodes)
                };
                if lost {
                    result = true;
                    break;
                }
            }
            self.tt.put_h(key, route, fp, result as u8);
            return result;
        }
        for &sq in pmoves {
            if !avail_has(avail, sq) {
                continue;
            }
            let a = att_for(att, sq);
            let child0 = avail.and_not(a[0]);
            if child0 == Bits::ZERO {
                result = true;
                break;
            }
            // available-popcount is monotone non-increasing down the tree, so once a child
            // enters the iso band it stays there: route it to the orientation-free `wins_tiny`
            // (no `child_orient`, no `lex_min8`) — the deepest, highest-node-count region.
            // Children inherit this node's `moves` as their parent list (a `q.order` subseq).
            let pc = child0.popcount();
            let lost = if pc <= self.iso_max_avail {
                let ckey = self.iso_node_key(q, child0, pc);
                let (cr, cf) = QueensTt::hash128(ckey);
                self.tt.prefetch_h(cr);
                !self.wins_tiny::<ORACLE, true>(q, att, child0, ckey, cr, cf, pmoves, nodes)
            } else {
                let child = child_orient(orient, a, child0);
                let ckey = d4_bits(lex_min8(&child));
                let (cr, cf) = QueensTt::hash128(ckey);
                self.tt.prefetch_h(cr);
                !self.wins_inc::<ORACLE, true>(q, att, &child, ckey, cr, cf, pmoves, nodes)
            };
            if lost {
                result = true;
                break;
            }
        }
        self.tt.put_h(key, route, fp, result as u8);
        result
    }

    /// Orientation-free tail of [`wins_inc`](Self::wins_inc) for the iso band
    /// (`avail.popcount() ≤ iso_max_avail`). Available-popcount only shrinks down the tree,
    /// so every descendant is in-band too: carry just the `avail` mask (one `and_not` per
    /// move via `att[sq][0]`, no `child_orient`/`lex_min8`) and key by the iso key. Same
    /// keys, same search order, same TT as `wins_inc` ⇒ byte-identical node set; it only
    /// drops the dead 8-orientation bookkeeping in the highest-node-count region.
    #[allow(clippy::too_many_arguments)]
    fn wins_tiny<const ORACLE: bool, const PROVE_LOSS: bool>(
        &self,
        q: &Queens,
        att: &[[Bits; 8]],
        avail: Bits,
        key: Bits,
        route: u64,
        fp: u64,
        pmoves: &[u32],
        nodes: &mut u64,
    ) -> bool {
        if let Some(w) = self.tt.get_h(key, route, fp) {
            return w != 0;
        }
        if ORACLE && avail.popcount() <= self.nimber_pc {
            if let Some(nim) = self.try_oracle_nimber(q, avail) {
                let w = nim != 0;
                self.tt.put_h(key, route, fp, w as u8);
                return w;
            }
        }
        self.tt.bump_local(nodes);
        let mut result = false;
        if PROVE_LOSS {
            let mut buf = [MaybeUninit::<u32>::uninit(); MAXV];
            let moves = filter_moves(&mut buf, pmoves, avail);
            for &sq in moves {
                let child0 = avail.and_not(att0(att, sq));
                if child0 == Bits::ZERO {
                    result = true;
                    break;
                }
                let ckey = self.iso_node_key(q, child0, child0.popcount());
                let (cr, cf) = QueensTt::hash128(ckey);
                self.tt.prefetch_h(cr);
                if !self.wins_tiny::<ORACLE, false>(q, att, child0, ckey, cr, cf, moves, nodes) {
                    result = true;
                    break;
                }
            }
            self.tt.put_h(key, route, fp, result as u8);
            return result;
        }
        for &sq in pmoves {
            if !avail_has(avail, sq) {
                continue;
            }
            let child0 = avail.and_not(att0(att, sq));
            if child0 == Bits::ZERO {
                result = true;
                break;
            }
            let ckey = self.iso_node_key(q, child0, child0.popcount());
            let (cr, cf) = QueensTt::hash128(ckey);
            self.tt.prefetch_h(cr);
            if !self.wins_tiny::<ORACLE, true>(q, att, child0, ckey, cr, cf, pmoves, nodes) {
                result = true;
                break;
            }
        }
        self.tt.put_h(key, route, fp, result as u8);
        result
    }

    /// Recursive parity-aware parallel cutoff search (the [`Fused::par_wins_inc`] twin). Even
    /// (prove-a-loss) plies fan all children across rayon (no α-β cutoff to lose ⇒ zero
    /// speculation); odd (prove-a-win) plies stay sequential. Below `par_depth` a node still
    /// splits while large (`> min_avail`, the #20 tail fix), else drops to [`wins_inc`].
    fn par_wins_inc<const ORACLE: bool>(
        &self,
        q: &Queens,
        att: &[[Bits; 8]],
        orient: &[Bits; 8],
        key: Bits,
        depth: u32,
        min_avail: u32,
    ) -> bool {
        if let Some(w) = self.tt.get(key) {
            return w != 0;
        }
        let avail = orient[0];
        if depth >= self.par_depth && avail.popcount() <= min_avail {
            let (route, fp) = QueensTt::hash128(key);
            // Hand the sequential subtree the full move order as its parent list; `wins_inc`
            // filters it to `avail` once, then the list shrinks incrementally below.
            let mut nodes = 0;
            let won = if depth.is_multiple_of(2) {
                self.wins_inc::<ORACLE, true>(q, att, orient, key, route, fp, &q.order, &mut nodes)
            } else {
                self.wins_inc::<ORACLE, false>(q, att, orient, key, route, fp, &q.order, &mut nodes)
            };
            self.tt.flush_local_nodes(&mut nodes);
            return won;
        }
        self.tt.bump();
        let mut moves: [u32; MAXV] = [0; MAXV];
        let mut nc = 0usize;
        for &sq in &q.order {
            if !avail_has(avail, sq) {
                continue;
            }
            if avail.and_not(att0(att, sq)) == Bits::ZERO {
                self.tt.put(key, 1);
                return true;
            }
            moves[nc] = sq;
            nc += 1;
        }
        let kids = &moves[..nc];
        let recurse = |&sq: &u32| {
            let a = att_for(att, sq);
            let child0 = avail.and_not(a[0]);
            let child = child_orient(orient, a, child0);
            let ckey = self.node_key(q, &child);
            !self.par_wins_inc::<ORACLE>(q, att, &child, ckey, depth + 1, min_avail)
        };
        let won = if depth.is_multiple_of(2) {
            kids.par_iter().any(recurse)
        } else {
            kids.iter().any(recurse)
        };
        self.tt.put(key, won as u8);
        won
    }
}

impl Solver for IsoFlat {
    fn name(&self) -> &'static str {
        "iso-flat"
    }
    fn wins(&self, q: &Queens, blocked: Bits) -> bool {
        let att = self.att(q);
        let orient = orient_of(q, q.board.and_not(blocked));
        let key = self.node_key(q, &orient);
        let (route, fp) = QueensTt::hash128(key);
        let mut nodes = 0;
        let won = if self.nimber_oracle {
            self.wins_inc::<true, false>(q, att, &orient, key, route, fp, &q.order, &mut nodes)
        } else {
            self.wins_inc::<false, false>(q, att, &orient, key, route, fp, &q.order, &mut nodes)
        };
        self.tt.flush_local_nodes(&mut nodes);
        self.tt.drain_local(); // sequential path: only this thread accumulated
        self.drain_oracle_local();
        won
    }
    fn first_player_wins(&self, q: &Queens) -> bool {
        if q.is_odd() {
            return true; // centre + 180° mirror strategy
        }
        let att = self.att(q);
        let min_avail = min_avail_for(self.par_min_avail, q.n);
        self.eff_min_avail.store(min_avail, Ordering::Relaxed);
        let moves = q.distinct_first_moves();
        self.root_total.store(moves.len() as u64, Ordering::Relaxed);
        self.root_done.store(0, Ordering::Relaxed);
        let root = orient_of(q, q.board);
        let mut pending: Vec<([Bits; 8], Bits)> = Vec::with_capacity(moves.len());
        for &sq in &moves {
            let a = att_for(att, sq);
            let co = child_orient(&root, a, q.board.and_not(a[0]));
            let ckey = self.node_key(q, &co);
            pending.push((co, ckey));
        }
        let resolve = |co: &[Bits; 8], ckey: Bits| {
            let wins = if self.nimber_oracle {
                !self.par_wins_inc::<true>(q, att, co, ckey, 1, min_avail)
            } else {
                !self.par_wins_inc::<false>(q, att, co, ckey, 1, min_avail)
            };
            self.root_done.fetch_add(1, Ordering::Relaxed);
            wins
        };
        let (first, rest) = pending.split_first().unwrap();
        let won =
            resolve(&first.0, first.1) || rest.par_iter().any(|(co, ckey)| resolve(co, *ckey));
        self.tt.drain_all(); // fold every worker's tail tally into the shared totals
        self.drain_oracle_all();
        won
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
    fn working_set(&self) -> Option<Vec<(Bits, u8)>> {
        self.tt.working_set()
    }
    fn root_progress(&self) -> Option<(u64, u64)> {
        let total = self.root_total.load(Ordering::Relaxed);
        (total > 0).then(|| (self.root_done.load(Ordering::Relaxed).min(total), total))
    }
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
        let oracle = if self.nimber_oracle {
            let attempts = self.oracle_attempts.load(Ordering::Relaxed);
            let hits = self.oracle_hits.load(Ordering::Relaxed);
            let comp_hits = self.oracle_comp_hits.load(Ordering::Relaxed);
            let comp_misses = self.oracle_comp_misses.load(Ordering::Relaxed);
            let hit_pct = if attempts > 0 {
                100.0 * hits as f64 / attempts as f64
            } else {
                0.0
            };
            format!(
                ", oracle {hits}/{attempts} ({hit_pct:.1}%) · comp-cache {comp_hits}/{comp_misses}"
            )
        } else {
            String::new()
        };
        format!(
            "{} rayon workers, {done}/{total} root moves, par-depth {}/min-avail {ma}, iso<= {} · {}",
            rayon::current_num_threads(),
            self.par_depth,
            self.iso_max_avail,
            self.tt.summary() + &oracle,
        )
    }
    // No `tt()` for now: a flat QueensTt could checkpoint, but its image header (TT_CANON_ID)
    // does not yet distinguish a selective iso/D4-keyed table from a plain D4 one, so a
    // cross-mode `--resume` would mis-key. A key-mode header tag is the follow-up.
}
