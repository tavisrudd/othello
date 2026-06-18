//! `IsoFlat` -- the sustained-throughput graph-iso solver: a **single** graph-iso
//! key per node (the full ~3.4× merge of [`IsoBurr`](super::IsoBurr)) over a **flat
//! lockless [`QueensTt`]** instead of the log-structured [`BurrStore`].
//!
//! The motivation is throughput *sustained over the whole run*. The BuRR store is
//! eviction-free by *freezing* solved entries into immutable segments, but a TT miss
//! then has to walk every frozen segment (+ its Bloom) -- so the rate decays from the
//! ~30 M/s memtable-only regime out of the gate to ~10 M/s once the segment cascade
//! builds (and worse once the byte cap evicts). A flat table never decays: a miss is
//! one O(1) probe forever.
//!
//! Flat tables normally evict at n=16 (the ~7.2B D4-distinct set overflows any RAM
//! table → ~1.36× re-expansion). The graph-iso key removes that: it merges every
//! isomorphic available-graph (sound -- the game is impartial Node Kayles on the
//! available graph, history-free, exact win/loss values → no graph-history hazard),
//! shrinking n=16 to ~2.1B distinct, which **fits** a flat ~2^31-slot table at load
//! ≈ 1.0. So iso-flat is eviction-free by *fitting* (not freezing): no segments, no
//! decay, the complete solved set resident. That is burr's eviction-freeness with the
//! memtable's sustained probe speed, plus iso's smaller node count.
//!
//! **One key per node, and it is *pure* iso** (unlike [`Fused`](super::Fused), which
//! keys small graphs by iso and large graphs by D4 in a mixed namespace). Pure iso
//! gives the *full* merge -- the thing that makes the set fit -- and, using only the
//! `graph_bits` namespace, never mixes with D4 keys, so it sidesteps the n=16
//! sentinel-bit collision that selective mixing has to guard. It also drops the
//! 8-orientation `child_orient`/`lex_min8` machinery the D4 key needs: iso-flat carries
//! just the `available` mask and updates it per move (`avail.and_not(attack[sq])`).
//!
//! The open cost is the per-node graph key (WL canon for larger graphs, the L1-resident
//! tiny table for `popcount <= 7`). That is the lever `iso_key_bench` targets; the
//! search structure here is independent of it.

use super::*;
use crate::queens::graph::CompSet;
use rayon::prelude::*;
use std::cell::RefCell;
use std::sync::atomic::{AtomicU32, AtomicU64, Ordering};

thread_local! {
    /// Per-thread, depth-indexed arena of component decompositions for the incremental
    /// carry (graph-key analog of the D4 kernel's 8-orientation carry). A sequential
    /// subtree runs single-threaded with proper stack nesting, so depth `d` owns slot `d`
    /// with no aliasing across rayon workers (each has its own). Game depth ≤ n, so this is
    /// a handful of slots; grown on demand.
    static CARRY: RefCell<Vec<Box<CompSet>>> = const { RefCell::new(Vec::new()) };
}

/// **IsoFlat** -- single pure-iso key over the flat lockless [`QueensTt`].
pub struct IsoFlat {
    tt: QueensTt,
    par_depth: u32,
    par_min_avail: Option<u32>,
    eff_min_avail: AtomicU32,
    root_done: AtomicU64,
    root_total: AtomicU64,
}

impl IsoFlat {
    pub fn new(bits: u32) -> Self {
        Self::from_tt(QueensTt::new(bits))
    }

    /// As [`IsoFlat::new`], but counting the distinct iso keys visited (`--distinct`).
    /// The HyperLogLog folded in at each `get` is lock-free, so it works under root
    /// parallelism; an exact set would serialise the workers, so `--distinct` reports
    /// the HLL estimate (the exact iso count is available via the sequential `count`).
    pub fn new_counting(bits: u32, hll_p: u32) -> Self {
        Self::from_tt(QueensTt::new_counting(bits, hll_p, false))
    }

    fn from_tt(tt: QueensTt) -> Self {
        IsoFlat {
            tt,
            par_depth: par_depth(),
            par_min_avail: par_min_avail_override(),
            eff_min_avail: AtomicU32::new(u32::MAX),
            root_done: AtomicU64::new(0),
            root_total: AtomicU64::new(0),
        }
    }

    /// The single graph-isomorphism key for an `available` mask, tagged into the
    /// `graph_bits` namespace. Small graphs (`popcount <= 7`) take the exact, L1-resident
    /// tiny canon table; larger graphs take the WL canon (`iso_key_fast`). Both yield the
    /// same iso-canonical class, so this is one sound key per node -- no D4 second probe.
    #[inline]
    fn node_key(&self, q: &Queens, avail: Bits) -> Bits {
        let h = if avail.popcount() <= 7 {
            q.iso_key_tiny_table(avail)
        } else {
            q.iso_key_fast(avail)
        };
        graph_bits(h)
    }

    /// Sequential cutoff search entry: borrows the per-thread carry arena, fresh-decomposes
    /// `avail` into level 0, then runs the carrying recursion. `key` is the node's iso key
    /// (already in hand from the caller; `iso_decompose` rebuilds the byte-identical value
    /// as a side effect of filling level 0's decomposition).
    fn wins_seq(&self, q: &Queens, avail: Bits, key: Bits) -> bool {
        CARRY.with(|cell| {
            let mut arena = cell.borrow_mut();
            Self::ensure_level(&mut arena, 0);
            q.iso_decompose(avail, &mut arena[0]);
            self.wins_carry(q, avail, &mut arena, 0, key)
        })
    }

    /// Grow the carry arena so slot `level` exists (cheap; game depth ≤ n).
    #[inline]
    fn ensure_level(arena: &mut Vec<Box<CompSet>>, level: usize) {
        while arena.len() <= level {
            arena.push(CompSet::new());
        }
    }

    /// Carrying sequential cutoff search. `arena[level]` holds `avail`'s component
    /// decomposition; each child reuses it via [`Queens::iso_carry`], re-canon-ing only the
    /// components its move disturbs. The combined key is byte-identical to a from-scratch
    /// `node_key`, so the merge (and verdict) is unchanged.
    fn wins_carry(
        &self,
        q: &Queens,
        avail: Bits,
        arena: &mut Vec<Box<CompSet>>,
        level: usize,
        key: Bits,
    ) -> bool {
        if let Some(w) = self.tt.get(key) {
            return w != 0;
        }
        self.tt.bump();
        Self::ensure_level(arena, level + 1);
        let mut result = false;
        for &sq in &q.order {
            if !avail.get(sq) {
                continue;
            }
            let att = q.attack[sq as usize];
            let child = avail.and_not(att);
            if child == Bits::ZERO {
                // The opponent has no reply → this move wins immediately.
                result = true;
                break;
            }
            let removed = avail.and(att);
            // Build the child's decomposition from this node's (carry the untouched
            // components, re-canon only the disturbed region). The split scopes the
            // parent/child borrows so `arena` is free to thread into the recursion.
            let ck = {
                let (head, tail) = arena.split_at_mut(level + 1);
                q.iso_carry(&head[level], removed, &mut tail[0])
            };
            let ckey = graph_bits(ck);
            self.tt.prefetch(ckey);
            if !self.wins_carry(q, child, arena, level + 1, ckey) {
                result = true;
                break;
            }
        }
        self.tt.put(key, result as u8);
        result
    }

    /// Recursive parity-aware parallel cutoff search -- the [`Fused::par_wins_inc`]
    /// twin. Even/prove-a-loss plies fan all children across rayon (no α-β cutoff to
    /// lose ⇒ zero speculation); odd/prove-a-win plies stay sequential so the cutoff
    /// survives. Below `par_depth` a node still splits while large (`> min_avail`, the
    /// #20 tail fix), else drops to the sequential [`wins_inc`](Self::wins_inc).
    fn par_wins_inc(&self, q: &Queens, avail: Bits, key: Bits, depth: u32, min_avail: u32) -> bool {
        if let Some(w) = self.tt.get(key) {
            return w != 0;
        }
        if depth >= self.par_depth && avail.popcount() <= min_avail {
            return self.wins_seq(q, avail, key);
        }
        self.tt.bump();
        let mut moves: [u32; MAXV] = [0; MAXV];
        let mut nc = 0usize;
        for &sq in &q.order {
            if !avail.get(sq) {
                continue;
            }
            if avail.and_not(q.attack[sq as usize]) == Bits::ZERO {
                self.tt.put(key, 1);
                return true;
            }
            moves[nc] = sq;
            nc += 1;
        }
        let kids = &moves[..nc];
        let recurse = |&sq: &u32| {
            let child = avail.and_not(q.attack[sq as usize]);
            let ckey = self.node_key(q, child);
            !self.par_wins_inc(q, child, ckey, depth + 1, min_avail)
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
        let avail = q.board.and_not(blocked);
        let key = self.node_key(q, avail);
        self.wins_seq(q, avail, key)
    }
    fn first_player_wins(&self, q: &Queens) -> bool {
        if q.is_odd() {
            return true; // centre + 180° mirror strategy (Parallel's theorem)
        }
        let min_avail = min_avail_for(self.par_min_avail, q.n);
        self.eff_min_avail.store(min_avail, Ordering::Relaxed);
        let moves = q.distinct_first_moves();
        self.root_total.store(moves.len() as u64, Ordering::Relaxed);
        self.root_done.store(0, Ordering::Relaxed);
        let mut pending: Vec<(Bits, Bits)> = Vec::with_capacity(moves.len());
        for &sq in &moves {
            let avail = q.board.and_not(q.attack[sq as usize]);
            let key = self.node_key(q, avail);
            pending.push((avail, key));
        }
        let resolve = |avail: Bits, key: Bits| {
            let wins = !self.par_wins_inc(q, avail, key, 1, min_avail);
            self.root_done.fetch_add(1, Ordering::Relaxed);
            wins
        };
        let (first, rest) = pending.split_first().unwrap();
        resolve(first.0, first.1) || rest.par_iter().any(|&(a, k)| resolve(a, k))
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
        format!(
            "{} rayon workers, {done}/{total} root moves, par-depth {}/min-avail {ma}, pure-iso · {}",
            rayon::current_num_threads(),
            self.par_depth,
            self.tt.summary(),
        )
    }
    // No `tt()` for now: a flat QueensTt *could* checkpoint, but its image header
    // (TT_CANON_ID) does not yet distinguish an iso-keyed table from a D4-keyed one, so
    // a cross-mode `--resume` would silently mis-key. Throughput is the v1 goal;
    // iso-checkpoint (a key-mode header tag) is a follow-up.
}
