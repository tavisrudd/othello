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

use super::graph::{small_canon_table, tiny_key_from_adj, TINY_TABLE_SLOTS};
use super::incremental::{build_att, child_orient, lex_min8, orient_of};
use super::*;
use rayon::prelude::*;
use std::cell::RefCell;
use std::mem::MaybeUninit;
use std::sync::atomic::{AtomicU32, AtomicU64, AtomicU8, Ordering};
use std::sync::OnceLock;
use std::time::Instant;

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

/// Histogram slot count: one per available-popcount, `0..=256` (the n=16 board has
/// `16*16 = 256` squares). Indexed by `avail.popcount()`.
const MAXPC: usize = 257;

/// Production-window measurement mode for [`wins_inc`](IsoFlat::wins_inc), a `const MODE`
/// monomorphisation (resolved once per subtree handoff, never per node). The two measurement
/// modes are mutually exclusive and both only apply to the `!ORACLE && !COUNT && WINDOW`
/// combo, so folding them into one `u8` keeps the generic count down vs two bools.
const M_NORMAL: u8 = 0; // plain solve / flat TT (the A/B control — byte-identical hot path)
const M_HIST: u8 = 1; // tally flat-TT puts by popcount (`QUEENS_PC_HIST=1`)
const M_SEG: u8 = 2; // route by per-popcount band (`QUEENS_TT_SEGMENT=1`)
const M_PROF: u8 = 3; // stratified profiler: rdtsc-time the TT get/put per pc (`QUEENS_PROF=1`)

/// `rdtsc` time-stamp counter read (`constant_tsc`/`nonstop_tsc` on this box, so it tracks
/// wall cycles). Used only on the `M_PROF` measurement path to stratify TT get/put latency
/// by popcount; never on the production hot path.
#[inline(always)]
fn rdtsc() -> u64 {
    // SAFETY: `_rdtsc` is unconditionally available on x86_64 and has no preconditions.
    unsafe { core::arch::x86_64::_rdtsc() }
}

/// Per-worker, non-atomic stratified profile accumulator for `QUEENS_PROF` — TT get/put cycle
/// totals and counts by available-popcount. Merged into [`IsoFlat::prof`] at drain (the
/// parallel twin of [`PC_HIST_ACC`]). Zero cost off the `M_PROF` monomorphisation.
struct ProfAcc {
    get_cyc: [u64; MAXPC],
    get_n: [u64; MAXPC],
    put_cyc: [u64; MAXPC],
    nodes: [u64; MAXPC],
}

thread_local! {
    /// Per-worker, **non-atomic** per-popcount flat-TT put tally for the
    /// `QUEENS_PC_HIST` segmented-TT sizing measurement. Each `wins_inc` expansion
    /// (one flat-TT put, always `pc >= 9` in production iso-window) bumps a plain
    /// integer here; merged into the shared [`IsoFlat::pc_hist`] at drain. Empty cost
    /// on the production (`HIST = false`) path — the bump is monomorphised away.
    static PC_HIST_ACC: RefCell<[u64; MAXPC]> = const { RefCell::new([0u64; MAXPC]) };
}

thread_local! {
    /// Per-worker stratified TT-latency profile (`QUEENS_PROF`); merged into the shared
    /// [`IsoFlat::prof`] at drain. Empty cost off the `M_PROF` path.
    static PROF_ACC: RefCell<ProfAcc> = const {
        RefCell::new(ProfAcc {
            get_cyc: [0; MAXPC],
            get_n: [0; MAXPC],
            put_cyc: [0; MAXPC],
            nodes: [0; MAXPC],
        })
    };
}

/// Compact representation of an in-band (`popcount ≤ 7`) available graph: once a node
/// drops into the iso band the whole subtree below it is a pure ≤7-vertex graph game
/// (Node Kayles), so it is built **once** at band entry and the search carries it down
/// instead of touching the 256-bit board again. Vertices are labelled `0..k0` in
/// q.order (the move order [`wins_tiny`](IsoFlat::wins_tiny) used), so the searched node
/// set stays byte-identical.
///
/// - `closed[i]` = the local vertices removed by playing `i` (its neighbours **and**
///   itself — `attack[v]` is self-blocking): the child's alive set is `alive & !closed[i]`.
/// - `adj[i]` = `closed[i]` minus the self bit: the edges, for the relabelling-invariant
///   tiny-canon edge code ([`tiny_key_from_adj`]).
///
/// Plain `[u8; 8]` data, one cache line, passed by `&` — the per-node board ops
/// (`and_not`/`popcount`/`each` over four `u64`s) and the per-child attack-row loads of
/// the old tail collapse to single-byte ops on `alive`.
struct TinyGraph {
    adj: [u8; MAXV_TINY],
    closed: [u8; MAXV_TINY],
}

/// Local-vertex capacity for [`TinyGraph`] — the tiny-canon band tops out at 7, padded
/// to 8 for a clean stride (matches `SMALL_WORK_MAX` in `graph.rs`).
const MAXV_TINY: usize = 8;

#[inline(always)]
fn avail_has8(avail: Bits, sq: u8) -> bool {
    let sq = sq as u32;
    let word = (sq >> 6) as usize;
    let bit = sq & 63;
    // SAFETY: every caller feeds byte-compressed copies of `q.order`.
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
fn att_for8(att: &[[Bits; 8]], sq: u8) -> &[Bits; 8] {
    // SAFETY: `sq` is a byte-compressed board square from `q.order`.
    unsafe { att.get_unchecked(sq as usize) }
}

#[inline(always)]
fn att08(att: &[[Bits; 8]], sq: u8) -> Bits {
    att_for8(att, sq)[0]
}

/// The `k`-vertex (`k ≤ 8`) labelled upper-triangular edge code of the `alive` sub-graph of a
/// dense block, in the exact bit order [`dense::DenseW8`] is built with (pairs `(x,y)`, `x<y`,
/// ascending). `closed[v]` carries `v`'s neighbours (self-blocking), and `verts[x] ≠ verts[y]`,
/// so `(closed[verts[x]] >> verts[y]) & 1` is the edge bit. Lets the block resolve any ≤8
/// descendant by one complete-table lookup instead of recomputing it.
#[inline]
fn dense_block_code(closed: &[u16; 13], alive: u16, k: usize) -> usize {
    let mut verts = [0usize; 8];
    let mut n = 0usize;
    let mut rem = alive;
    while rem != 0 {
        verts[n] = rem.trailing_zeros() as usize;
        rem &= rem - 1;
        n += 1;
    }
    let mut code = 0usize;
    let mut bit = 0usize;
    for x in 0..k {
        for &vy in verts.iter().take(k).skip(x + 1) {
            code |= (((closed[verts[x]] >> vy) & 1) as usize) << bit;
            bit += 1;
        }
    }
    code
}

/// Filter `pmoves` (the parent node's available squares, already in `q.order`) down to the
/// squares still set in `avail`, written compactly into `buf` and returned as a slice. This
/// replaces the per-node scan over all `n²` squares with a scan over the parent's
/// (monotonically shrinking) move list. It preserves the `q.order` subsequence, so the move
/// order — and therefore the searched node set — is byte-identical. `buf` is left uninit (no
/// `n²`-wide zero-init, which would cost more than the scan it removes).
#[inline]
fn filter_moves<'a>(buf: &'a mut [MaybeUninit<u8>; MAXV], pmoves: &[u8], avail: Bits) -> &'a [u8] {
    let mut nc = 0usize;
    for &sq in pmoves {
        // Branchless compaction: write `sq` unconditionally, then advance the count only if
        // it survives the filter — an unavailable `sq` is simply overwritten next iteration.
        // `avail_has8` is ~50/50 down the tree, so the old `if`-guarded write was a coin-flip
        // branch the predictor missed every other node; this trades it for one always-taken
        // L1 store (much cheaper than the misprediction). Output is byte-identical.
        // SAFETY: `pmoves` is a `q.order` subsequence (≤ MAXV entries) and `nc` never exceeds
        // the count of survivors so far, so `buf[nc]` is always in bounds.
        unsafe { buf.get_unchecked_mut(nc).write(sq) };
        nc += avail_has8(avail, sq) as usize;
    }
    // SAFETY: the loop initialised exactly `buf[..nc]` via `write`; `MaybeUninit<u8>` is
    // layout-identical to `u8` and `u8` has no invalid bit patterns, so reading that
    // prefix back as `&[u8]` (bounded by the returned `'a` borrow of `buf`) is sound.
    unsafe { std::slice::from_raw_parts(buf.as_ptr() as *const u8, nc) }
}

/// Resolve a `u32` env knob once at construction (never per node). Used for the
/// leaf-oracle prototype thresholds.
fn env_u32(name: &str, default: u32) -> u32 {
    std::env::var(name)
        .ok()
        .and_then(|s| s.parse().ok())
        .unwrap_or(default)
}

/// Print the per-root wall schedule captured by `QUEENS_ROOT_TIMING` (each root's [start, end]
/// interval in seconds since the solve began), sorted by completion. The summary answers the
/// tail question directly: **SOLO for last X s** = how long the final root ran with the others
/// finished (the single-threaded tail), and **longest = Y% of total wall** = whether one root
/// dominates (size-ordering won't help; deep parallelism would balloon) or several are
/// comparable (size-ordering shortens the tail for free).
fn print_root_timing(n: u32, moves: &[u32], starts: &[AtomicU64], ends: &[AtomicU64]) {
    let secs = |a: &AtomicU64| a.load(Ordering::Relaxed) as f64 / 1e6;
    // (idx, square, start_s, end_s)
    let mut rows: Vec<(usize, u32, f64, f64)> = (0..starts.len())
        .map(|i| (i, moves[i], secs(&starts[i]), secs(&ends[i])))
        .collect();
    if rows.is_empty() {
        return;
    }
    let total = rows.iter().map(|r| r.3).fold(0.0_f64, f64::max);
    rows.sort_by(|a, b| a.3.total_cmp(&b.3));
    println!(
        "\n[root-timing] n={n}: {} roots, total wall {total:.1}s (sorted by end)",
        rows.len()
    );
    println!(
        "  {:>3} {:>4} {:>9} {:>9} {:>9}",
        "idx", "sq", "start", "end", "dur"
    );
    for &(i, sq, s, e) in &rows {
        println!("  {i:>3} {sq:>4} {s:>8.1}s {e:>8.1}s {:>8.1}s", e - s);
    }
    let last = rows[rows.len() - 1];
    // The final root ran alone from the next-latest end until its own end.
    let solo = if rows.len() >= 2 {
        last.3 - rows[rows.len() - 2].3
    } else {
        total
    };
    let mut durs: Vec<f64> = rows.iter().map(|r| r.3 - r.2).collect();
    durs.sort_by(|a, b| b.total_cmp(a));
    let top: Vec<String> = durs.iter().take(3).map(|d| format!("{d:.1}s")).collect();
    println!(
        "  tail root idx {} (sq {}): ran {:.1}s, ended {:.1}s — SOLO for last {solo:.1}s ({:.0}% of wall)",
        last.0,
        last.1,
        last.3 - last.2,
        last.3,
        100.0 * solo / total,
    );
    println!(
        "  longest 3 root durations: [{}] — longest = {:.0}% of total wall",
        top.join(", "),
        100.0 * durs[0] / total,
    );
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
    name: &'static str,
    tt: QueensTt,
    att: OnceLock<Box<[[Bits; 8]]>>,
    order8: OnceLock<Box<[u8]>>,
    /// `order_rank[sq]` = `sq`'s position in `q.order` (descending attack degree). Built
    /// once; lets the iso-band entry relabel a child's vertices into q.order with a tiny
    /// insertion sort instead of rescanning the parent's (long) move list.
    order_rank: OnceLock<Box<[u8]>>,
    /// Complete, eviction-free ≤7 win/loss table, keyed by the **labelled** dense index
    /// [`Queens::tiny_table_index`] (`OFF[k] + edge_code`) — `0` = unknown, `1` = loss,
    /// `2` = win. One byte per labelled code (~2 MB direct, no fingerprint, no collision), so
    /// a band entry is a single direct indexed load with no canon-table lookup and no flat-TT
    /// DRAM probe. Keying by the labelled (not canonical) code skips the 16 MB canon table —
    /// the win/loss is iso-invariant, so every labelling stores the same value; the slight
    /// merge loss is recomputed cheaply in the L1 [`solve_local`](Self::solve_local) memo.
    /// (A smaller L2 *hash* table was tried — it collides above ~512 K reached codes, and the
    /// collision recomputes inflate the node count and *slow* completion, so the collision-
    /// free direct table wins.) Shared lock-free: a position's value is fixed.
    tiny_tt: Box<[AtomicU8]>,
    /// Complete dense W8 labelled win/loss table (32 MiB, opt-in via the `iso-window`
    /// solver). At `popcount == 8` the whole subgame is an 8-vertex Node-Kayles graph whose
    /// value is iso-invariant, so it is looked up by the raw 28-bit labelled edge code — one
    /// TLB-friendly indexed bit load, instead of a `child_orient`/`lex_min8` D4 key + a
    /// scattered probe into the 13–17 GB flat TT (and, on a miss, expanding the whole pc==8
    /// subtree). `None` for plain `iso-flat`.
    dense8: Option<DenseW8>,
    /// Dense low-popcount **ceiling K** for the `iso-dense` solver: every pc==k node with
    /// `9 ≤ k ≤ dense_k` is resolved directly from the complete W0..W8 tables by the W_K
    /// evaluator (`W_K(G) = ∃v · ¬W_{K-1}(G∖N[v])`, one BMI2-projected child sweep, no flat-TT
    /// probe and no subtree expansion), exactly as W8 already does pc==8. `8` = off (the
    /// `iso-flat`/`iso-window` control). Set by `new_dense` (default 9, `QUEENS_DENSE_K`
    /// override, clamped 9..=11). Read **once at the root** to pick the `const DK` search
    /// instantiation — never a run-constant branch in the deep loop or a TT probe.
    dense_k: u32,
    tiny_canon: &'static [u64],
    par_depth: u32,
    par_min_avail: Option<u32>,
    /// `QUEENS_ROOT_TIMING=1`: record each root's wall [start, end] interval (µs since the
    /// solve began) and print the schedule post-solve. Diagnoses whether the single-threaded
    /// tail is **one dominant root** (one long interval running solo at the end → deep
    /// parallelism needed, balloons) or **several comparable roots** (→ size-ordering shortens
    /// the tail for free). Cold: two timestamps per root (≤ root_total times), zero hot-path cost.
    root_timing: bool,
    iso_max_avail: u32,
    /// `QUEENS_BLOCK_K` (default 8 = off): dense-block boundary. When `> 8`, a node dropping to
    /// `8 < pc ≤ block_k` is solved as one **local block** — the flat-TT boundary entry is merged
    /// once by its D4 key, then the whole subtree below is solved in a thread-private L1 memo over
    /// the `u16` alive mask (no per-descendant flat-TT probe), exactly as the pc≤7 band already
    /// does. Measurement prototype for the dense-blocks lever; resolved once here, never per node.
    block_k: u32,
    eff_min_avail: AtomicU32,
    root_done: AtomicU64,
    root_total: AtomicU64,
    // Lever-B leaf-oracle prototype (QUEENS_NIMBER_ORACLE=1): when a node's available
    // graph fully decomposes into connected components each ≤ `nimber_k`, resolve it by
    // decompose → per-component nimber (memoised) → XOR → win iff ≠0, with NO recursion.
    // Because max-component is monotone non-increasing down the tree, this prunes the
    // whole all-small region below its frontier (G1: ~42% of distinct nodes at ≤7, n=14).
    nimber_oracle: bool,
    counting: bool,
    /// `QUEENS_PC_HIST=1`: tally flat-TT puts by available-popcount into [`pc_hist`](Self::pc_hist)
    /// for segmented-TT band sizing (resolved once here, never per node — the hot loop is
    /// monomorphised on `const MODE = M_HIST`, selected from this at the per-subtree handoff).
    hist: bool,
    /// `QUEENS_TT_SEGMENT=1` (mirrors [`QueensTt::is_segmented`]): route flat-TT probes by
    /// per-popcount band. Resolved once; selects `const MODE = M_SEG` at the subtree handoff,
    /// so the deep hot path is fully monomorphised (the flat control stays byte-identical).
    segment: bool,
    /// Shared per-popcount flat-TT put histogram (one [`AtomicU64`] per popcount), merged
    /// from each worker's thread-local [`PC_HIST_ACC`] at drain. Only populated when `hist`.
    pc_hist: Box<[AtomicU64]>,
    /// `QUEENS_PROF=1`: stratified TT-latency profiler. Selects `const MODE = M_PROF` at the
    /// subtree handoff; `wins_inc` then `rdtsc`-times each flat-TT get/put and bins the cycles
    /// by popcount. Production (`M_NORMAL`) compiles all of it away.
    prof: bool,
    /// Shared profile accumulator (`4 * MAXPC` [`AtomicU64`]: get-cyc / get-n / put-cyc / nodes,
    /// laid out `metric * MAXPC + pc`), merged from each worker's [`PROF_ACC`] at drain.
    prof_data: Box<[AtomicU64]>,
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

    pub fn new_window(bits: u32) -> Self {
        Self::from_tt_with_window(QueensTt::new(bits), true)
    }

    /// The `iso-dense` solver: `iso-window`'s kernel plus the dense low-popcount layer forced
    /// **on** by construction — every pc==9 node is resolved directly from the complete W0..W8
    /// tables (one BMI2-projected child sweep, no flat-TT probe and no subtree expansion),
    /// exactly as W8 already does pc==8. This is the next step in the iso-flat → iso-window →
    /// iso-dense lineage; `iso-window` stays the dense-off control. The dense ceiling K
    /// defaults to **12** — the measured economic optimum of the W_K crossover (per-node eval
    /// cost vs saved probes): each layer 9→10→11→12 keeps cutting ~16–18% more nodes and
    /// lowers the wall (deterministic n=14 nodes 22.5M→18.8M→15.7M→12.9M; n=16 mean wall
    /// ~2m26s→2m00s→1m53s→1m41s). W9..W11 keep the labelled code in a `u64`; W12's 66-bit code
    /// runs on the `u128` two-word `pext` path. `QUEENS_DENSE_K` (9..=12) overrides for
    /// re-sweeping; `getK` resolves every `9 ≤ pc ≤ K` directly from the complete W0..W8 tables.
    pub fn new_dense(bits: u32) -> Self {
        let mut s = Self::from_tt_with_window(QueensTt::new(bits), true);
        s.name = "iso-dense";
        // Dense layer on by construction (not the iso-window env gate). The ceiling is read
        // once here, threaded as `dense_k`, and resolved to a `const DK` at the root dispatch.
        s.dense_k = env_u32("QUEENS_DENSE_K", 12).clamp(9, 12);
        s
    }

    /// As [`IsoFlat::new`], but counting the distinct (tagged iso/D4) keys visited
    /// (`--distinct`). The HyperLogLog folded in at each `get` is lock-free, so it works
    /// under root parallelism.
    pub fn new_counting(bits: u32, hll_p: u32) -> Self {
        Self::from_tt(QueensTt::new_counting(bits, hll_p, false))
    }

    fn from_tt(tt: QueensTt) -> Self {
        Self::from_tt_with_window(tt, false)
    }

    fn from_tt_with_window(tt: QueensTt, window: bool) -> Self {
        let counting = tt.is_counting();
        let segment = tt.is_segmented();
        IsoFlat {
            name: if window { "iso-window" } else { "iso-flat" },
            tt,
            att: OnceLock::new(),
            order8: OnceLock::new(),
            order_rank: OnceLock::new(),
            tiny_tt: (0..TINY_TABLE_SLOTS).map(|_| AtomicU8::new(0)).collect(),
            dense8: window.then(DenseW8::build),
            // The dense low-popcount layer is exclusive to `iso-dense` (set by `new_dense`);
            // `iso-flat`/`iso-window` keep the ceiling at 8 so they run identically to before.
            dense_k: 8,
            tiny_canon: small_canon_table(),
            par_depth: par_depth(),
            par_min_avail: par_min_avail_override(),
            root_timing: std::env::var("QUEENS_ROOT_TIMING").as_deref() == Ok("1"),
            iso_max_avail: iso_flat_key_max_avail(),
            // Default 8 = off (pc≤7 band + W8 unchanged); clamp ≤12 for the [i8;4096] L1 memo.
            block_k: env_u32("QUEENS_BLOCK_K", 8).clamp(8, 12),
            eff_min_avail: AtomicU32::new(u32::MAX),
            root_done: AtomicU64::new(0),
            root_total: AtomicU64::new(0),
            nimber_oracle: std::env::var("QUEENS_NIMBER_ORACLE").as_deref() == Ok("1"),
            counting,
            hist: std::env::var("QUEENS_PC_HIST").as_deref() == Ok("1"),
            // Mirror the table's segmentation (it resolved `QUEENS_TT_SEGMENT` at startup), so
            // the subtree-handoff dispatch can pick `MODE = M_SEG` once and monomorphise.
            segment,
            pc_hist: (0..MAXPC).map(|_| AtomicU64::new(0)).collect(),
            prof: std::env::var("QUEENS_PROF").as_deref() == Ok("1"),
            prof_data: (0..4 * MAXPC).map(|_| AtomicU64::new(0)).collect(),
            nimber_k: env_u32("QUEENS_NIMBER_K", 7).min(7),
            nimber_pc: env_u32("QUEENS_NIMBER_PC", 28),
            tiny8_direct: std::env::var("QUEENS_TINY8").as_deref() == Ok("1"),
            oracle_attempts: AtomicU64::new(0),
            oracle_hits: AtomicU64::new(0),
            oracle_comp_hits: AtomicU64::new(0),
            oracle_comp_misses: AtomicU64::new(0),
        }
    }

    /// Resolve a `popcount == 8` node from the complete dense W8 table. The 8-vertex
    /// available graph's Node-Kayles value is relabelling-invariant, so build the raw 28-bit
    /// upper-triangular edge code **directly** from the 8 attack rows (one pass, no
    /// intermediate `adj`/`closed` arrays, no canonicalisation) and index the bitset. The
    /// table is complete, so this always returns a value — there is never a flat-TT probe or
    /// a subtree expansion here. Only reached from the `WINDOW` instantiation, where
    /// `dense8` is always `Some`.
    #[inline]
    fn w8_get(&self, att: &[[Bits; 8]], avail: Bits) -> bool {
        // SAFETY: the WINDOW const generic at the (only) call site guarantees `dense8` is
        // `Some` (set by `from_tt_with_window(.., true)`). Drops a None-branch + panic target
        // from the hot body — the i-cache shave of the banked PROVE_LOSS win.
        let dense8 = unsafe { self.dense8.as_ref().unwrap_unchecked() };
        debug_assert_eq!(avail.popcount(), 8);
        let mut verts = [0u8; 8];
        let mut n = 0usize;
        avail.each(|v| {
            // SAFETY: wK_get is dispatched only at pc==K, so `avail` yields exactly K squares
            // ⇒ n < K. Drops a per-square bounds-check panic block from every wK_get hot body.
            unsafe { *verts.get_unchecked_mut(n) = v as u8 };
            n += 1;
        });
        debug_assert_eq!(n, 8);
        let mut code = 0usize;
        let mut bit = 0u32;
        for i in 0..8 {
            let row = att08(att, verts[i]);
            for &vj in verts.iter().take(8).skip(i + 1) {
                code |= (row.get(vj as u32) as usize) << bit;
                bit += 1;
            }
        }
        dense8.get(8, code)
    }

    /// Resolve a 9-vertex graph directly from W0..W8. Building the labelled edge
    /// code is the only board-geometry work; [`DenseW8::get9`] uses BMI2 projection
    /// for every child and performs no TT access or W9 allocation.
    #[inline]
    fn w9_get(&self, att: &[[Bits; 8]], avail: Bits) -> bool {
        // SAFETY: the DK≥9 const generic at the (only) call site guarantees `dense8` is `Some`.
        let dense8 = unsafe { self.dense8.as_ref().unwrap_unchecked() };
        debug_assert_eq!(avail.popcount(), 9);
        let mut verts = [0u8; 9];
        let mut n = 0usize;
        avail.each(|v| {
            // SAFETY: wK_get is dispatched only at pc==K, so `avail` yields exactly K squares
            // ⇒ n < K. Drops a per-square bounds-check panic block from every wK_get hot body.
            unsafe { *verts.get_unchecked_mut(n) = v as u8 };
            n += 1;
        });
        debug_assert_eq!(n, 9);
        let mut code = 0u64;
        let mut bit = 0u32;
        for i in 0..9 {
            let row = att08(att, verts[i]);
            for &vj in verts.iter().take(9).skip(i + 1) {
                code |= (row.get(vj as u32) as u64) << bit;
                bit += 1;
            }
        }
        dense8.get9(code)
    }

    /// Resolve a 10-vertex graph directly from W0..W8 (the W10 layer). Twin of
    /// [`w9_get`](Self::w9_get): build the 45-bit labelled edge code from the 10 attack rows,
    /// then [`DenseW8::get10`] sweeps every child (nested one ply into W9, else a W≤8 lookup).
    #[inline]
    fn w10_get(&self, att: &[[Bits; 8]], avail: Bits) -> bool {
        // SAFETY: the DK≥10 const generic at the (only) call site guarantees `dense8` is `Some`.
        let dense8 = unsafe { self.dense8.as_ref().unwrap_unchecked() };
        debug_assert_eq!(avail.popcount(), 10);
        let mut verts = [0u8; 10];
        let mut n = 0usize;
        avail.each(|v| {
            // SAFETY: wK_get is dispatched only at pc==K, so `avail` yields exactly K squares
            // ⇒ n < K. Drops a per-square bounds-check panic block from every wK_get hot body.
            unsafe { *verts.get_unchecked_mut(n) = v as u8 };
            n += 1;
        });
        debug_assert_eq!(n, 10);
        let mut code = 0u64;
        let mut bit = 0u32;
        for i in 0..10 {
            let row = att08(att, verts[i]);
            for &vj in verts.iter().take(10).skip(i + 1) {
                code |= (row.get(vj as u32) as u64) << bit;
                bit += 1;
            }
        }
        dense8.get10(code)
    }

    /// Resolve an 11-vertex graph directly from W0..W8 (the W11 layer). Twin of
    /// [`w9_get`](Self::w9_get) over the 55-bit labelled edge code; [`DenseW8::get11`] nests
    /// one ply into W10/W9 (else a W≤8 lookup) per child.
    #[inline]
    fn w11_get(&self, att: &[[Bits; 8]], avail: Bits) -> bool {
        // SAFETY: the DK≥11 const generic at the (only) call site guarantees `dense8` is `Some`.
        let dense8 = unsafe { self.dense8.as_ref().unwrap_unchecked() };
        debug_assert_eq!(avail.popcount(), 11);
        let mut verts = [0u8; 11];
        let mut n = 0usize;
        avail.each(|v| {
            // SAFETY: wK_get is dispatched only at pc==K, so `avail` yields exactly K squares
            // ⇒ n < K. Drops a per-square bounds-check panic block from every wK_get hot body.
            unsafe { *verts.get_unchecked_mut(n) = v as u8 };
            n += 1;
        });
        debug_assert_eq!(n, 11);
        let mut code = 0u64;
        let mut bit = 0u32;
        for i in 0..11 {
            let row = att08(att, verts[i]);
            for &vj in verts.iter().take(11).skip(i + 1) {
                code |= (row.get(vj as u32) as u64) << bit;
                bit += 1;
            }
        }
        dense8.get11(code)
    }

    /// Resolve a 12-vertex graph directly from W0..W8 (the W12 layer, the first past the
    /// `u64` code ceiling). Twin of [`w9_get`](Self::w9_get) but the 66-bit labelled code is
    /// a `u128`; [`DenseW8::get12`] nests one ply into W11/W10/W9 (else a W≤8 lookup) per child.
    #[inline]
    fn w12_get(&self, att: &[[Bits; 8]], avail: Bits) -> bool {
        // SAFETY: the DK≥12 const generic at the (only) call site guarantees `dense8` is `Some`.
        let dense8 = unsafe { self.dense8.as_ref().unwrap_unchecked() };
        debug_assert_eq!(avail.popcount(), 12);
        let mut verts = [0u8; 12];
        let mut n = 0usize;
        avail.each(|v| {
            // SAFETY: dispatched only at pc==12 ⇒ exactly 12 squares ⇒ n < 12.
            unsafe { *verts.get_unchecked_mut(n) = v as u8 };
            n += 1;
        });
        debug_assert_eq!(n, 12);
        let mut code = 0u128;
        let mut bit = 0u32;
        for i in 0..12 {
            let row = att08(att, verts[i]);
            for &vj in verts.iter().take(12).skip(i + 1) {
                code |= (row.get(vj as u32) as u128) << bit;
                bit += 1;
            }
        }
        dense8.get12(code)
    }

    #[inline]
    fn att(&self, q: &Queens) -> &[[Bits; 8]] {
        self.att.get_or_init(|| build_att(q))
    }

    #[inline]
    fn order8(&self, q: &Queens) -> &[u8] {
        self.order8.get_or_init(|| {
            q.order
                .iter()
                .map(|&sq| {
                    debug_assert!(sq < 256);
                    sq as u8
                })
                .collect::<Vec<_>>()
                .into_boxed_slice()
        })
    }

    #[inline]
    fn order_rank(&self, q: &Queens) -> &[u8] {
        self.order_rank.get_or_init(|| {
            let mut rank = vec![0u8; (q.n * q.n) as usize].into_boxed_slice();
            for (r, &sq) in q.order.iter().enumerate() {
                rank[sq as usize] = r as u8;
            }
            rank
        })
    }

    #[inline]
    fn tt_get_key<const COUNT: bool>(&self, key: Bits) -> Option<u8> {
        if COUNT {
            self.tt.get(key)
        } else {
            let (route, fp) = QueensTt::hash128(key);
            self.tt.get_hashed(route, fp)
        }
    }

    #[inline]
    fn tt_put_key<const COUNT: bool>(&self, key: Bits, val: u8) {
        if COUNT {
            self.tt.put(key, val);
        } else {
            let (route, fp) = QueensTt::hash128(key);
            self.tt.put_hashed(route, fp, val);
        }
    }

    #[inline]
    fn tt_get_h<const COUNT: bool>(&self, key: Bits, route: u64, fp: u64) -> Option<u8> {
        if COUNT {
            self.tt.get_h(key, route, fp)
        } else {
            self.tt.get_hashed(route, fp)
        }
    }

    #[inline]
    fn tt_put_h<const COUNT: bool>(&self, key: Bits, route: u64, fp: u64, val: u8) {
        if COUNT {
            self.tt.put_h(key, route, fp, val);
        } else {
            self.tt.put_hashed(route, fp, val);
        }
    }

    /// [`wins_inc`](Self::wins_inc) flat-TT lookup, dispatched on the `const MODE`: `M_SEG`
    /// routes by per-popcount band ([`QueensTt::get_seg_hashed`], `pc` = the node's available
    /// popcount); `M_HIST`/`M_NORMAL` use the flat probe (identical to the control). The branch
    /// is on a `const`, so each instantiation compiles to exactly one path — no per-node test.
    #[inline]
    fn mtt_get<const COUNT: bool, const MODE: u8>(
        &self,
        key: Bits,
        route: u64,
        fp: u64,
        pc: u32,
    ) -> Option<u8> {
        if MODE == M_SEG {
            self.tt.get_seg_hashed(route, fp, pc)
        } else {
            self.tt_get_h::<COUNT>(key, route, fp)
        }
    }

    /// [`wins_inc`](Self::wins_inc) flat-TT store, MODE-dispatched (twin of [`mtt_get`](Self::mtt_get)).
    #[inline]
    fn mtt_put<const COUNT: bool, const MODE: u8>(
        &self,
        key: Bits,
        route: u64,
        fp: u64,
        pc: u32,
        val: u8,
    ) {
        if MODE == M_SEG {
            self.tt.put_seg_hashed(route, fp, pc, val);
        } else {
            self.tt_put_h::<COUNT>(key, route, fp, val);
        }
    }

    /// Prefetch the slot a child key will land in, MODE-dispatched: `M_SEG` prefetches its
    /// band slot (`pc` = the child's popcount); otherwise the flat slot.
    #[inline]
    fn mtt_prefetch<const MODE: u8>(&self, route: u64, pc: u32) {
        if MODE == M_SEG {
            self.tt.prefetch_seg_hashed(route, pc);
        } else {
            self.tt.prefetch_h(route);
        }
    }

    /// [`par_wins_inc`](Self::par_wins_inc) split-node lookup. Only the *few* shallow split
    /// nodes reach this (never the deep hot path), so the segmentation choice is a cheap
    /// resolved-once runtime branch on `self.segment` rather than another `const` to thread.
    #[inline]
    fn par_tt_get<const COUNT: bool>(&self, key: Bits, pc: u32) -> Option<u8> {
        if self.segment {
            let (route, fp) = QueensTt::hash128(key);
            self.tt.get_seg_hashed(route, fp, pc)
        } else {
            self.tt_get_key::<COUNT>(key)
        }
    }

    /// [`par_wins_inc`](Self::par_wins_inc) split-node store (twin of [`par_tt_get`](Self::par_tt_get)).
    #[inline]
    fn par_tt_put<const COUNT: bool>(&self, key: Bits, pc: u32, val: u8) {
        if self.segment {
            let (route, fp) = QueensTt::hash128(key);
            self.tt.put_seg_hashed(route, fp, pc, val);
        } else {
            self.tt_put_key::<COUNT>(key, val);
        }
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

    /// Tally one flat-TT put at available-popcount `pc` into this worker's thread-local
    /// histogram (`QUEENS_PC_HIST` measurement only — reached solely from the `HIST = true`
    /// monomorphisation of [`wins_inc`](Self::wins_inc), so the production path has no bump).
    #[inline]
    fn hist_bump(&self, pc: u32) {
        PC_HIST_ACC.with(|cell| cell.borrow_mut()[pc as usize] += 1);
    }

    /// Merge this worker's thread-local put histogram into the shared [`pc_hist`](Self::pc_hist)
    /// and clear it (so a later solve in this process starts fresh).
    fn drain_hist_local(&self) {
        PC_HIST_ACC.with(|cell| {
            let mut a = cell.borrow_mut();
            for (i, v) in a.iter_mut().enumerate() {
                if *v != 0 {
                    self.pc_hist[i].fetch_add(*v, Ordering::Relaxed);
                    *v = 0;
                }
            }
        });
    }

    /// Merge every rayon worker's put histogram into the shared total (the parallel twin of
    /// [`drain_hist_local`](Self::drain_hist_local)).
    fn drain_hist_all(&self) {
        rayon::broadcast(|_| self.drain_hist_local());
        self.drain_hist_local();
    }

    /// Merge this worker's thread-local profile ([`PROF_ACC`]) into the shared [`prof`](Self::prof_data)
    /// totals and clear it. Layout: `prof_data[metric * MAXPC + pc]`, metric ∈ {get-cyc, get-n,
    /// put-cyc, nodes}.
    fn drain_prof_local(&self) {
        PROF_ACC.with(|cell| {
            let mut a = cell.borrow_mut();
            for pc in 0..MAXPC {
                if a.get_n[pc] == 0 && a.nodes[pc] == 0 {
                    continue;
                }
                self.prof_data[pc].fetch_add(a.get_cyc[pc], Ordering::Relaxed);
                self.prof_data[MAXPC + pc].fetch_add(a.get_n[pc], Ordering::Relaxed);
                self.prof_data[2 * MAXPC + pc].fetch_add(a.put_cyc[pc], Ordering::Relaxed);
                self.prof_data[3 * MAXPC + pc].fetch_add(a.nodes[pc], Ordering::Relaxed);
                a.get_cyc[pc] = 0;
                a.get_n[pc] = 0;
                a.put_cyc[pc] = 0;
                a.nodes[pc] = 0;
            }
        });
    }

    /// Merge every rayon worker's profile into the shared total (parallel twin of
    /// [`drain_prof_local`](Self::drain_prof_local)).
    fn drain_prof_all(&self) {
        rayon::broadcast(|_| self.drain_prof_local());
        self.drain_prof_local();
    }

    /// Sequential cutoff search (the [`Fused::wins_inc`](super::Fused) twin over the flat TT).
    /// `(route, fp)` are `key`'s precomputed hash halves (hash-carry): each child key is
    /// hashed once at creation and the halves are reused for its prefetch, lookup, and store.
    // Flat args (key + carried hash + move list) are deliberate on this hot recursive path —
    // bundling them into a context struct would add a per-node pointer-chase.
    #[allow(clippy::too_many_arguments)]
    // NB: the former `PROVE_LOSS` const generic was removed — it selected between two
    // behaviourally identical arms (pure OR-search, break on first child-loss; it was
    // vestigial YBWC even/odd-parity bookkeeping that does not affect the sequential node
    // set). Carrying it monomorphised the deep hot recursion into *two* full copies of this
    // body, doubling its L1i footprint in the measured frontend-bound region. One body now.
    fn wins_inc<
        const ORACLE: bool,
        const COUNT: bool,
        const WINDOW: bool,
        const DK: u32,
        const MODE: u8,
    >(
        &self,
        q: &Queens,
        att: &[[Bits; 8]],
        orient: &[Bits; 8],
        key: Bits,
        route: u64,
        fp: u64,
        pmoves: &[u8],
        nodes: &mut u64,
    ) -> bool {
        let avail = orient[0];
        // The node's own available-popcount, needed *before* the probe in `M_SEG` (it picks
        // the band) and for the `M_HIST` tally. `M_NORMAL` never reads it (popcount compiled
        // out). Same value drives the entry-get, the exit-put, and the histogram bump.
        let node_pc = if MODE == M_NORMAL {
            0
        } else {
            avail.popcount()
        };
        let got = if MODE == M_PROF {
            // rdtsc-time the flat-TT get and bin the cycles by this node's popcount — the get
            // *is* the random DRAM probe, so its latency by pc is the memory cost distribution.
            let t = rdtsc();
            let g = self.mtt_get::<COUNT, MODE>(key, route, fp, node_pc);
            let dt = rdtsc().wrapping_sub(t);
            PROF_ACC.with(|c| {
                let mut a = c.borrow_mut();
                a.get_cyc[node_pc as usize] += dt;
                a.get_n[node_pc as usize] += 1;
            });
            g
        } else {
            self.mtt_get::<COUNT, MODE>(key, route, fp, node_pc)
        };
        if let Some(w) = got {
            return w != 0;
        }
        if ORACLE && avail.popcount() <= self.nimber_pc {
            if let Some(nim) = self.try_oracle_nimber(q, avail) {
                let w = nim != 0;
                self.tt_put_h::<COUNT>(key, route, fp, w as u8);
                return w;
            }
        }
        self.tt.bump_local(nodes);
        // Segmented-TT sizing measurement: every node reaching here does exactly one flat-TT
        // put below, so tallying its popcount is the per-pc put histogram (gated to the
        // `M_HIST` monomorphisation — production never executes this).
        if MODE == M_HIST {
            self.hist_bump(node_pc);
        }
        let mut result = false;
        // Compact the available moves once (branchless), then iterate with no per-square
        // availability branch. Children inherit `moves` (the
        // availability-filtered `q.order` subsequence): a child re-filters by *its* avail,
        // and child-avail ⊆ avail, so filtering `moves` vs `pmoves` yields the identical
        // child move list ⇒ byte-identical node set, and the child scans a shorter list.
        let mut buf = [MaybeUninit::<u8>::uninit(); MAXV];
        let moves = filter_moves(&mut buf, pmoves, avail);
        for &sq in moves {
            let a = att_for8(att, sq);
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
            // Dense W_K ceiling: every `9 ≤ pc ≤ DK` child is resolved directly from W0..W8
            // (no flat-TT probe, no subtree expansion). `DK` is `const`, so each arm const-folds
            // away for the instantiations below it — `DK == 8` (iso-flat/iso-window) compiles all
            // three out, identical to before.
            let lost = if DK >= 12 && pc == 12 {
                !self.w12_get(att, child0)
            } else if DK >= 11 && pc == 11 {
                !self.w11_get(att, child0)
            } else if DK >= 10 && pc == 10 {
                !self.w10_get(att, child0)
            } else if DK >= 9 && pc == 9 {
                !self.w9_get(att, child0)
            } else if WINDOW && !ORACLE && !COUNT && pc == 8 {
                !self.w8_get(att, child0)
            } else if !ORACLE && pc <= 7 {
                !self.band_entry::<COUNT>(q, att, child0, pc, nodes)
            } else if !ORACLE && !COUNT && (9..=self.block_k).contains(&pc) {
                // Dense-block boundary (QUEENS_BLOCK_K > 8): pc in 9..=block_k. Same D4 key as the
                // non-block arm below (boundary-entry merging identical), then a local L1 subtree
                // solve — no per-descendant flat-TT probe. pc==8 stays W8 (iso-window) / D4
                // (iso-flat); default block_k == 8 ⇒ the range is empty ⇒ never taken.
                let child = child_orient(orient, a, child0);
                let ckey = d4_bits(lex_min8(&child));
                let (cr, cf) = QueensTt::hash128(ckey);
                self.tt.prefetch_h(cr);
                !self.block_entry(q, att, child0, ckey, cr, cf, nodes)
            } else if pc <= self.iso_max_avail {
                let ckey = self.iso_node_key(q, child0, pc);
                let (cr, cf) = QueensTt::hash128(ckey);
                self.tt.prefetch_h(cr);
                !self.wins_tiny::<ORACLE, COUNT, true>(q, att, child0, ckey, cr, cf, moves, nodes)
            } else {
                let child = child_orient(orient, a, child0);
                let ckey = d4_bits(lex_min8(&child));
                let (cr, cf) = QueensTt::hash128(ckey);
                self.mtt_prefetch::<MODE>(cr, pc);
                !self.wins_inc::<ORACLE, COUNT, WINDOW, DK, MODE>(
                    q, att, &child, ckey, cr, cf, moves, nodes,
                )
            };
            if lost {
                result = true;
                break;
            }
        }
        if MODE == M_PROF {
            let t = rdtsc();
            self.mtt_put::<COUNT, MODE>(key, route, fp, node_pc, result as u8);
            let dt = rdtsc().wrapping_sub(t);
            PROF_ACC.with(|c| {
                let mut a = c.borrow_mut();
                a.put_cyc[node_pc as usize] += dt;
                a.nodes[node_pc as usize] += 1;
            });
        } else {
            self.mtt_put::<COUNT, MODE>(key, route, fp, node_pc, result as u8);
        }
        result
    }

    /// Orientation-free tail of [`wins_inc`](Self::wins_inc) for the iso band
    /// (`avail.popcount() ≤ iso_max_avail`). Available-popcount only shrinks down the tree,
    /// so every descendant is in-band too: carry just the `avail` mask (one `and_not` per
    /// move via `att[sq][0]`, no `child_orient`/`lex_min8`) and key by the iso key. Same
    /// keys, same search order, same TT as `wins_inc` ⇒ byte-identical node set; it only
    /// drops the dead 8-orientation bookkeeping in the highest-node-count region.
    #[allow(clippy::too_many_arguments)]
    fn wins_tiny<const ORACLE: bool, const COUNT: bool, const PROVE_LOSS: bool>(
        &self,
        q: &Queens,
        att: &[[Bits; 8]],
        avail: Bits,
        key: Bits,
        route: u64,
        fp: u64,
        pmoves: &[u8],
        nodes: &mut u64,
    ) -> bool {
        if let Some(w) = self.tt_get_h::<COUNT>(key, route, fp) {
            return w != 0;
        }
        if ORACLE && avail.popcount() <= self.nimber_pc {
            if let Some(nim) = self.try_oracle_nimber(q, avail) {
                let w = nim != 0;
                self.tt_put_h::<COUNT>(key, route, fp, w as u8);
                return w;
            }
        }
        self.tt.bump_local(nodes);
        let mut result = false;
        if PROVE_LOSS {
            let mut buf = [MaybeUninit::<u8>::uninit(); MAXV];
            let moves = filter_moves(&mut buf, pmoves, avail);
            for &sq in moves {
                let child0 = avail.and_not(att08(att, sq));
                if child0 == Bits::ZERO {
                    result = true;
                    break;
                }
                let ckey = self.iso_node_key(q, child0, child0.popcount());
                let (cr, cf) = QueensTt::hash128(ckey);
                self.tt.prefetch_h(cr);
                if !self
                    .wins_tiny::<ORACLE, COUNT, false>(q, att, child0, ckey, cr, cf, moves, nodes)
                {
                    result = true;
                    break;
                }
            }
            self.tt_put_h::<COUNT>(key, route, fp, result as u8);
            return result;
        }
        for &sq in pmoves {
            if !avail_has8(avail, sq) {
                continue;
            }
            let child0 = avail.and_not(att08(att, sq));
            if child0 == Bits::ZERO {
                result = true;
                break;
            }
            let ckey = self.iso_node_key(q, child0, child0.popcount());
            let (cr, cf) = QueensTt::hash128(ckey);
            self.tt.prefetch_h(cr);
            if !self.wins_tiny::<ORACLE, COUNT, true>(q, att, child0, ckey, cr, cf, pmoves, nodes) {
                result = true;
                break;
            }
        }
        self.tt_put_h::<COUNT>(key, route, fp, result as u8);
        result
    }

    /// The carried-adjacency key of an in-band child (`alive` over a [`TinyGraph`]) plus
    /// its precomputed `(route, fp)`. Byte-identical to `iso_node_key`'s tiny-table key
    /// (see [`tiny_key_from_adj`]) but with no board scan / attack-row load.
    #[inline]
    fn graph_key(&self, g: &TinyGraph, alive: u8) -> (Bits, u64, u64) {
        let key = graph_bits(tiny_key_from_adj(&g.adj, alive, self.tiny_canon));
        let (route, fp) = QueensTt::hash128(key);
        (key, route, fp)
    }

    /// Resolve a ≤7 band child `child0` (popcount `pc`): production (`!COUNT`) keys it by the
    /// canon-free labelled index — **no `iso_node_key`, no 16 MB canon-table probe**; the
    /// `--distinct` (`COUNT`) build keeps the canonical flat-TT key so the HLL still sees it.
    #[inline]
    fn band_entry<const COUNT: bool>(
        &self,
        q: &Queens,
        att: &[[Bits; 8]],
        child0: Bits,
        pc: u32,
        nodes: &mut u64,
    ) -> bool {
        if COUNT {
            let ckey = self.iso_node_key(q, child0, pc);
            let (cr, cf) = QueensTt::hash128(ckey);
            self.tt.prefetch_h(cr);
            self.enter_graph::<true>(q, att, child0, pc, ckey, cr, cf, nodes)
        } else {
            self.enter_graph::<false>(q, att, child0, pc, Bits::ZERO, 0, 0, nodes)
        }
    }

    /// Band entry: a node `child0` has just dropped to `popcount ≤ 7`. Build its
    /// [`TinyGraph`] once — the only place the board is read in the whole iso tail — then
    /// hand the subtree to the orientation-free graph game. Vertices are relabelled
    /// `0..k0` in **q.order** (extracted from `child0`, sorted by
    /// [`order_rank`](Self::order_rank)) so the move order — and the searched node set —
    /// match the old `wins_tiny` tail byte-for-byte. `key/route/fp` are the entry node's
    /// already-computed tiny key (reused so the entry probe isn't recomputed).
    #[inline]
    #[allow(clippy::too_many_arguments)]
    fn enter_graph<const COUNT: bool>(
        &self,
        q: &Queens,
        att: &[[Bits; 8]],
        child0: Bits,
        pc: u32,
        key: Bits,
        route: u64,
        fp: u64,
        nodes: &mut u64,
    ) -> bool {
        // Production: the band-entry win/loss lives in the complete ≤7 table keyed by the
        // *labelled* dense index — one direct byte load, no canon-table lookup, no DRAM.
        let tidx = if COUNT {
            0
        } else {
            q.tiny_table_index(child0, pc)
        };
        if COUNT {
            // `--distinct`: keep the band in the flat TT so the HLL counts every position.
            if let Some(w) = self.tt_get_h::<COUNT>(key, route, fp) {
                return w != 0;
            }
        } else if let Some(w) = self.tiny_get(tidx) {
            return w;
        }
        let rank = self.order_rank(q);
        let mut verts = [0u8; MAXV_TINY];
        let mut k0 = 0usize;
        child0.each(|v| {
            let v = v as u8;
            let r = rank[v as usize];
            let mut j = k0;
            while j > 0 && rank[verts[j - 1] as usize] > r {
                verts[j] = verts[j - 1];
                j -= 1;
            }
            verts[j] = v;
            k0 += 1;
        });
        // closed[i] = the local vertices in attack[verts[i]] (self included — the mask is
        // self-blocking); adj[i] drops the self bit for the edge code.
        let mut g = TinyGraph {
            adj: [0; MAXV_TINY],
            closed: [0; MAXV_TINY],
        };
        for i in 0..k0 {
            let row = att08(att, verts[i]);
            let mut c = 0u8;
            for (j, &vj) in verts.iter().enumerate().take(k0) {
                c |= (row.get(vj as u32) as u8) << j;
            }
            g.closed[i] = c;
            g.adj[i] = c & !(1u8 << i);
        }
        let alive = ((1u16 << k0) - 1) as u8;
        if COUNT {
            // `--distinct`: keep descendants in the flat TT so the HLL counts them.
            self.tt.bump_local(nodes);
            return self.expand_graph::<COUNT>(&g, alive, key, route, fp, nodes);
        }
        // Production: solve the whole ≤7 subtree in a thread-private 128-byte stack memo
        // (indexed by the alive bitmask) — pure L1, no flat-TT probe, no DRAM, no
        // cross-CCX coherence — then store the band-entry value in the complete ≤7 table.
        // Descendant transpositions across *different* entries are recomputed (cheap, L1)
        // rather than shared through DRAM.
        let mut memo = [-1i8; 128];
        let won = self.solve_local(&g, alive, &mut memo, nodes);
        self.tiny_put(tidx, won);
        won
    }

    /// Probe the complete ≤7 [`tiny_tt`](Self::tiny_tt) at the labelled dense `idx`
    /// ([`Queens::tiny_table_index`]) — one direct indexed byte load (no canon, no fp).
    #[inline]
    fn tiny_get(&self, idx: usize) -> Option<bool> {
        // SAFETY: `idx` comes from `tiny_table_index`, which returns `< TINY_TABLE_SLOTS`.
        match unsafe { self.tiny_tt.get_unchecked(idx) }.load(Ordering::Relaxed) {
            0 => None,
            v => Some(v == 2),
        }
    }

    /// Store `won` at the labelled dense `idx` in the ≤7 [`tiny_tt`](Self::tiny_tt).
    #[inline]
    fn tiny_put(&self, idx: usize, won: bool) {
        // SAFETY: as `tiny_get` — `idx < TINY_TABLE_SLOTS == tiny_tt.len()`.
        unsafe { self.tiny_tt.get_unchecked(idx) }.store(1 + won as u8, Ordering::Relaxed);
    }

    /// Solve an in-band node against a **local** `memo` (indexed by the alive bitmask over
    /// the entry [`TinyGraph`]). Pure L1/register work: playing vertex `i` leaves
    /// `alive & !closed[i]`; an empty child wins outright, otherwise recurse and cut on the
    /// first child that loses. No board op, no key, no TT — the iso band off the memory path.
    fn solve_local(&self, g: &TinyGraph, alive: u8, memo: &mut [i8; 128], nodes: &mut u64) -> bool {
        let m = memo[alive as usize];
        if m >= 0 {
            return m != 0;
        }
        self.tt.bump_local(nodes);
        let mut result = false;
        let mut rem = alive;
        while rem != 0 {
            let i = rem.trailing_zeros() as usize;
            rem &= rem - 1;
            let child = alive & !g.closed[i];
            if child == 0 || !self.solve_local(g, child, memo, nodes) {
                result = true;
                break;
            }
        }
        memo[alive as usize] = result as i8;
        result
    }

    /// Widened [`solve_local`] for a dense block at `8 < pc ≤ block_k`: the win/loss DP over the
    /// `u16` alive mask of a ≤12-vertex graph in a thread-private memo (no flat-TT probe below the
    /// boundary). Same recurrence as `solve_local`, just `u16`. Every visited state bumps the node
    /// counter so the block's descendant recompute is visible in the re-expansion measurement.
    ///
    /// **W8-base** (when `dense8` is `Some` — iso-window): any descendant with `popcount ≤ 8` is
    /// resolved by a single lookup into the *complete, shared* dense W0..W8 tables instead of being
    /// recomputed locally. Since the ≤8 subtree is the bulk of the nodes and the dense tables merge
    /// it across all boundaries (zero recompute), this collapses the block's re-expansion to just the
    /// thin pc 9..block_k shell — the variant that avoids the cross-boundary re-expansion.
    fn solve_block_wide(
        &self,
        closed: &[u16; 13],
        alive: u16,
        memo: &mut [i8],
        nodes: &mut u64,
    ) -> bool {
        let m = memo[alive as usize];
        if m >= 0 {
            return m != 0;
        }
        // W8-base: ≤8 vertices ⇒ one complete-table lookup (shared, no recompute, not a search node).
        let k = alive.count_ones() as usize;
        if k <= 8 {
            if let Some(d8) = &self.dense8 {
                let won = d8.get(k, dense_block_code(closed, alive, k));
                memo[alive as usize] = won as i8;
                return won;
            }
        }
        self.tt.bump_local(nodes);
        let mut result = false;
        let mut rem = alive;
        while rem != 0 {
            let i = rem.trailing_zeros() as usize;
            rem &= rem - 1;
            let child = alive & !closed[i];
            if child == 0 || !self.solve_block_wide(closed, child, memo, nodes) {
                result = true;
                break;
            }
        }
        memo[alive as usize] = result as i8;
        result
    }

    /// Dense-block boundary entry (`QUEENS_BLOCK_K > 8`, measurement prototype). A node has just
    /// dropped to `8 < pc ≤ block_k`. Merge the boundary value once via the flat TT under the
    /// **same D4 `key`** the non-block path would use (so boundary-entry merging is identical and
    /// the re-expansion delta is *purely* the descendant recompute), then on a miss solve the whole
    /// subtree in a thread-private `[i8;4096]` L1 memo over the ≤12-vertex graph from `child0` —
    /// no further flat-TT probe below the boundary, exactly as the pc≤7 band's `solve_local` does.
    #[allow(clippy::too_many_arguments)]
    fn block_entry(
        &self,
        q: &Queens,
        att: &[[Bits; 8]],
        child0: Bits,
        key: Bits,
        route: u64,
        fp: u64,
        nodes: &mut u64,
    ) -> bool {
        if let Some(w) = self.tt_get_h::<false>(key, route, fp) {
            return w != 0;
        }
        // Extract the ≤12 live vertices in q.order rank order (matches the band/non-block move
        // order, so the node set is identical modulo the local-vs-global memo merge).
        let rank = self.order_rank(q);
        let mut verts = [0u8; 13];
        let mut k0 = 0usize;
        child0.each(|v| {
            let v = v as u8;
            let r = rank[v as usize];
            let mut j = k0;
            while j > 0 && rank[verts[j - 1] as usize] > r {
                verts[j] = verts[j - 1];
                j -= 1;
            }
            verts[j] = v;
            k0 += 1;
        });
        // closed[i] = live vertices in attack[verts[i]] (self-blocking), over u16 — as enter_graph.
        let mut closed = [0u16; 13];
        for i in 0..k0 {
            let row = att08(att, verts[i]);
            let mut c = 0u16;
            for (j, &vj) in verts.iter().enumerate().take(k0) {
                c |= (row.get(vj as u32) as u16) << j;
            }
            closed[i] = c;
        }
        let alive = ((1u32 << k0) - 1) as u16;
        let mut memo = [-1i8; 4096];
        let won = self.solve_block_wide(&closed, alive, &mut memo, nodes);
        self.tt_put_h::<false>(key, route, fp, won as u8);
        won
    }

    /// In-band recursion: probe the flat TT, else expand. The descendant twin of
    /// [`enter_graph`](Self::enter_graph) — same graph `g`, only `alive` shrinks.
    #[inline]
    fn wins_graph<const COUNT: bool>(
        &self,
        g: &TinyGraph,
        alive: u8,
        key: Bits,
        route: u64,
        fp: u64,
        nodes: &mut u64,
    ) -> bool {
        if let Some(w) = self.tt_get_h::<COUNT>(key, route, fp) {
            return w != 0;
        }
        self.tt.bump_local(nodes);
        self.expand_graph::<COUNT>(g, alive, key, route, fp, nodes)
    }

    /// Expand an in-band node (TT miss already counted): play each alive vertex in q.order
    /// label order; playing `i` leaves `alive & !closed[i]`. An empty child wins outright
    /// (opponent has no move), otherwise recurse and cut on the first child that loses.
    /// One unified path replaces `wins_tiny`'s prove-win/prove-loss split — the `alive`
    /// bitmask *is* the compacted move list, so there is nothing left to filter.
    #[inline]
    fn expand_graph<const COUNT: bool>(
        &self,
        g: &TinyGraph,
        alive: u8,
        key: Bits,
        route: u64,
        fp: u64,
        nodes: &mut u64,
    ) -> bool {
        // Gather all children and their keys first, issuing every TT prefetch up front, so
        // the probes in the resolve loop below overlap (memory-level parallelism) instead
        // of each stalling on DRAM in turn — the search is TT-latency-bound, and a node's
        // children are independent until the first cutoff. `child == 0` is an immediate win
        // (opponent left no move); it carries a zero key and is resolved in q.order so the
        // cutoff — and the searched node set — stay byte-identical.
        let mut kids: [(u8, Bits, u64, u64); MAXV_TINY] = [(0, Bits::ZERO, 0, 0); MAXV_TINY];
        let mut nk = 0usize;
        let mut rem = alive;
        while rem != 0 {
            let i = rem.trailing_zeros() as usize;
            rem &= rem - 1;
            let child = alive & !g.closed[i];
            if child != 0 {
                let (ckey, cr, cf) = self.graph_key(g, child);
                self.tt.prefetch_h(cr);
                kids[nk] = (child, ckey, cr, cf);
            }
            nk += 1;
        }
        let mut result = false;
        for &(child, ckey, cr, cf) in &kids[..nk] {
            let lost = child == 0 || !self.wins_graph::<COUNT>(g, child, ckey, cr, cf, nodes);
            if lost {
                result = true;
                break;
            }
        }
        self.tt_put_h::<COUNT>(key, route, fp, result as u8);
        result
    }

    /// Recursive parity-aware parallel cutoff search (the [`Fused::par_wins_inc`] twin). Even
    /// (prove-a-loss) plies fan all children across rayon (no α-β cutoff to lose ⇒ zero
    /// speculation); odd (prove-a-win) plies stay sequential. Below `par_depth` a node still
    /// splits while large (`> min_avail`, the #20 tail fix), else drops to [`wins_inc`].
    fn par_wins_inc<const ORACLE: bool, const COUNT: bool, const WINDOW: bool, const DK: u32>(
        &self,
        q: &Queens,
        att: &[[Bits; 8]],
        orient: &[Bits; 8],
        key: Bits,
        depth: u32,
        min_avail: u32,
    ) -> bool {
        let avail = orient[0];
        // Split nodes are few and shallow (never the deep hot path), so segmentation here is a
        // resolved-once `self.segment` runtime branch in `par_tt_get`/`par_tt_put` rather than
        // another `const` threaded through the recursion. `pc` is this node's popcount (only
        // read in the segmented branch — computed always here, but this is not the hot path).
        let pc = avail.popcount();
        if let Some(w) = self.par_tt_get::<COUNT>(key, pc) {
            return w != 0;
        }
        if depth >= self.par_depth && avail.popcount() <= min_avail {
            let (route, fp) = QueensTt::hash128(key);
            // Hand the sequential subtree the full move order as its parent list; `wins_inc`
            // filters it to `avail` once, then the list shrinks incrementally below.
            let mut nodes = 0;
            // The production-window measurement modes (`QUEENS_PC_HIST` / `QUEENS_TT_SEGMENT`)
            // pick their `MODE` monomorphisation **here, once per subtree handoff** (never per
            // node), so the deep `wins_inc` recursion is fully monomorphised. The `WINDOW &&
            // !ORACLE && !COUNT` guard is const, so `M_HIST`/`M_SEG` are only instantiated for
            // the production-window combo (the guard const-folds to `M_NORMAL` elsewhere, and
            // DCE drops the dead arms — no instantiation blow-up).
            let mode = if WINDOW && !ORACLE && !COUNT {
                if self.prof {
                    M_PROF
                } else if self.segment {
                    M_SEG
                } else if self.hist {
                    M_HIST
                } else {
                    M_NORMAL
                }
            } else {
                M_NORMAL
            };
            let order8 = self.order8(q);
            let won = match mode {
                M_SEG => self.wins_inc::<ORACLE, COUNT, WINDOW, DK, M_SEG>(
                    q, att, orient, key, route, fp, order8, &mut nodes,
                ),
                M_HIST => self.wins_inc::<ORACLE, COUNT, WINDOW, DK, M_HIST>(
                    q, att, orient, key, route, fp, order8, &mut nodes,
                ),
                M_PROF => self.wins_inc::<ORACLE, COUNT, WINDOW, DK, M_PROF>(
                    q, att, orient, key, route, fp, order8, &mut nodes,
                ),
                _ => self.wins_inc::<ORACLE, COUNT, WINDOW, DK, M_NORMAL>(
                    q, att, orient, key, route, fp, order8, &mut nodes,
                ),
            };
            self.tt.flush_local_nodes(&mut nodes);
            return won;
        }
        self.tt.bump();
        let mut moves: [u8; MAXV] = [0; MAXV];
        let mut nc = 0usize;
        for &sq in self.order8(q) {
            if !avail_has8(avail, sq) {
                continue;
            }
            if avail.and_not(att08(att, sq)) == Bits::ZERO {
                self.par_tt_put::<COUNT>(key, pc, 1);
                return true;
            }
            moves[nc] = sq;
            nc += 1;
        }
        let kids = &moves[..nc];
        let recurse = |&sq: &u8| {
            let a = att_for8(att, sq);
            let child0 = avail.and_not(a[0]);
            let child = child_orient(orient, a, child0);
            let ckey = self.node_key(q, &child);
            !self.par_wins_inc::<ORACLE, COUNT, WINDOW, DK>(
                q,
                att,
                &child,
                ckey,
                depth + 1,
                min_avail,
            )
        };
        let won = if depth.is_multiple_of(2) {
            kids.par_iter().any(recurse)
        } else {
            kids.iter().any(recurse)
        };
        self.par_tt_put::<COUNT>(key, pc, won as u8);
        won
    }
}

impl Solver for IsoFlat {
    fn name(&self) -> &'static str {
        self.name
    }
    fn wins(&self, q: &Queens, blocked: Bits) -> bool {
        let att = self.att(q);
        let orient = orient_of(q, q.board.and_not(blocked));
        let key = self.node_key(q, &orient);
        let (route, fp) = QueensTt::hash128(key);
        let mut nodes = 0;
        // WINDOW only matters on the production (`!ORACLE && !COUNT`) path, and the dense
        // ceiling `DK` is resolved once here from `dense_k` (the single runtime decision per
        // solve, never per node). The oracle/counting arms fix `WINDOW=false, DK=8`.
        let won = match (self.nimber_oracle, self.counting) {
            (true, true) => self.wins_inc::<true, true, false, 8, M_NORMAL>(
                q,
                att,
                &orient,
                key,
                route,
                fp,
                self.order8(q),
                &mut nodes,
            ),
            (true, false) => self.wins_inc::<true, false, false, 8, M_NORMAL>(
                q,
                att,
                &orient,
                key,
                route,
                fp,
                self.order8(q),
                &mut nodes,
            ),
            (false, true) => self.wins_inc::<false, true, false, 8, M_NORMAL>(
                q,
                att,
                &orient,
                key,
                route,
                fp,
                self.order8(q),
                &mut nodes,
            ),
            (false, false) => match (self.dense8.is_some(), self.dense_k) {
                (true, 12) => self.wins_inc::<false, false, true, 12, M_NORMAL>(
                    q,
                    att,
                    &orient,
                    key,
                    route,
                    fp,
                    self.order8(q),
                    &mut nodes,
                ),
                (true, 11) => self.wins_inc::<false, false, true, 11, M_NORMAL>(
                    q,
                    att,
                    &orient,
                    key,
                    route,
                    fp,
                    self.order8(q),
                    &mut nodes,
                ),
                (true, 10) => self.wins_inc::<false, false, true, 10, M_NORMAL>(
                    q,
                    att,
                    &orient,
                    key,
                    route,
                    fp,
                    self.order8(q),
                    &mut nodes,
                ),
                (true, 9) => self.wins_inc::<false, false, true, 9, M_NORMAL>(
                    q,
                    att,
                    &orient,
                    key,
                    route,
                    fp,
                    self.order8(q),
                    &mut nodes,
                ),
                // iso-window: W8 dense table but no W9+ ceiling.
                (true, _) => self.wins_inc::<false, false, true, 8, M_NORMAL>(
                    q,
                    att,
                    &orient,
                    key,
                    route,
                    fp,
                    self.order8(q),
                    &mut nodes,
                ),
                // iso-flat: no dense layer at all.
                (false, _) => self.wins_inc::<false, false, false, 8, M_NORMAL>(
                    q,
                    att,
                    &orient,
                    key,
                    route,
                    fp,
                    self.order8(q),
                    &mut nodes,
                ),
            },
        };
        self.tt.flush_local_nodes(&mut nodes);
        self.tt.drain_local(); // sequential path: only this thread accumulated
        self.drain_oracle_local();
        self.drain_hist_local();
        self.drain_prof_local();
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
        // Per-root wall intervals (µs since t0): the `QUEENS_ROOT_TIMING=1` diagnostic. Cold and
        // allocated **only when enabled**, so a normal `iso-flat`/`iso-window`/`iso-dense` run is
        // unchanged. The closure stamps `start` on entry and `end` on exit; `t0` is read ≤ 2× per
        // root, never per node. `idx` is unused when timing is off (zero-cost).
        let timing = self.root_timing;
        let (starts, ends): (Vec<AtomicU64>, Vec<AtomicU64>) = if timing {
            (
                (0..pending.len()).map(|_| AtomicU64::new(0)).collect(),
                (0..pending.len()).map(|_| AtomicU64::new(0)).collect(),
            )
        } else {
            (Vec::new(), Vec::new())
        };
        let t0 = Instant::now();
        let resolve = |idx: usize, co: &[Bits; 8], ckey: Bits| {
            if timing {
                starts[idx].store(t0.elapsed().as_micros() as u64, Ordering::Relaxed);
            }
            // The dense ceiling `dense_k` (and the WINDOW flag) is read **once here**, per root,
            // to select the `const DK` monomorphisation — never in the deep `wins_inc` loop or a
            // TT probe. The oracle/counting arms fix `WINDOW=false, DK=8`.
            let wins =
                match (self.nimber_oracle, self.counting) {
                    (true, true) => {
                        !self.par_wins_inc::<true, true, false, 8>(q, att, co, ckey, 1, min_avail)
                    }
                    (true, false) => {
                        !self.par_wins_inc::<true, false, false, 8>(q, att, co, ckey, 1, min_avail)
                    }
                    (false, true) => {
                        !self.par_wins_inc::<false, true, false, 8>(q, att, co, ckey, 1, min_avail)
                    }
                    (false, false) => match (self.dense8.is_some(), self.dense_k) {
                        (true, 12) => !self
                            .par_wins_inc::<false, false, true, 12>(q, att, co, ckey, 1, min_avail),
                        (true, 11) => !self
                            .par_wins_inc::<false, false, true, 11>(q, att, co, ckey, 1, min_avail),
                        (true, 10) => !self
                            .par_wins_inc::<false, false, true, 10>(q, att, co, ckey, 1, min_avail),
                        (true, 9) => !self
                            .par_wins_inc::<false, false, true, 9>(q, att, co, ckey, 1, min_avail),
                        // iso-window: W8 dense table, no W9+ ceiling.
                        (true, _) => !self
                            .par_wins_inc::<false, false, true, 8>(q, att, co, ckey, 1, min_avail),
                        // iso-flat: no dense layer.
                        (false, _) => !self
                            .par_wins_inc::<false, false, false, 8>(q, att, co, ckey, 1, min_avail),
                    },
                };
            self.root_done.fetch_add(1, Ordering::Relaxed);
            if timing {
                ends[idx].store(t0.elapsed().as_micros() as u64, Ordering::Relaxed);
            }
            wins
        };
        let (first, rest) = pending.split_first().unwrap();
        // Root 0 is the sequential elder-brother (warms the TT); roots 1.. fan via rayon.
        let won = resolve(0, &first.0, first.1)
            || rest
                .par_iter()
                .enumerate()
                .any(|(i, (co, ckey))| resolve(i + 1, co, *ckey));
        if timing {
            print_root_timing(q.n, &moves, &starts, &ends);
        }
        self.tt.drain_all(); // fold every worker's tail tally into the shared totals
        self.drain_oracle_all();
        self.drain_hist_all();
        self.drain_prof_all();
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
    fn pc_hist(&self) -> Option<Vec<u64>> {
        self.hist.then(|| {
            self.pc_hist
                .iter()
                .map(|a| a.load(Ordering::Relaxed))
                .collect()
        })
    }
    fn prof_data(&self) -> Option<Vec<u64>> {
        self.prof.then(|| {
            self.prof_data
                .iter()
                .map(|a| a.load(Ordering::Relaxed))
                .collect()
        })
    }
    fn per_worker_nodes(&self) -> Option<Vec<u64>> {
        Some(self.tt.per_worker_nodes())
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
        let dense = self
            .dense8
            .as_ref()
            .map(|d| format!(", W8 {:.0} MB", d.bytes() as f64 / (1 << 20) as f64))
            .unwrap_or_default();
        format!(
            "{} rayon workers, {done}/{total} root moves, par-depth {}/min-avail {ma}, iso<= {}{dense} · {}",
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
