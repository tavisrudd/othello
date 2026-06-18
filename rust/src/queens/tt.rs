//! The lockless transposition table, its checkpoint image format, the BuRR
//! freeze stream, and the df-pn proof-number table.

use super::*;
use std::cell::RefCell;
use std::collections::HashMap;
use std::io::{self, Read, Write};
use std::sync::atomic::{AtomicU64, Ordering};
use std::sync::Mutex;

/// Flush a worker's thread-local tally into the shared atomics ≈ once a second (at the
/// ~M-node/s rates here). Per-node the search touches only thread-local memory -- no
/// cross-CCX atomic on the shared `nodes` counter, which on this 2-CCX box bounces over the
/// Infinity Fabric and measured a ~2× throughput drag every node (mirror of the BurrStore
/// fix, `store.rs`). The shared counters are exact again after a [`QueensTt::drain_all`].
const FLUSH_NODES: u64 = 1 << 18;

/// Per-worker, **non-atomic** accumulators for the hot-loop node counter and the distinct
/// estimator. Each rayon worker owns one (thread-local), incremented with plain integer ops
/// per node; flushed to the shared atomic + HLL once every [`FLUSH_NODES`] nodes and drained
/// at search end.
struct Acc {
    nodes: u64,
    /// Thread-local HLL registers (`2^p` bytes), lazily sized to the shared estimator on
    /// first feed and merged by max at flush; empty when this table isn't counting.
    hll: Vec<u8>,
}

thread_local! {
    static ACC: RefCell<Acc> = const { RefCell::new(Acc { nodes: 0, hll: Vec::new() }) };
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
pub(crate) struct Slot(pub(crate) u64);

impl Slot {
    /// Fingerprint width: `64 - 1 (used) - 8 (val)` bits.
    pub(crate) const FP_BITS: u32 = 55;
    const FP_SHIFT: u32 = 9;
    const VAL_SHIFT: u32 = 1;

    #[inline]
    pub(crate) const fn fp_mask() -> u64 {
        (1u64 << Self::FP_BITS) - 1
    }
    /// Pack `val` and the low `FP_BITS` of `fp` into an occupied slot.
    #[inline]
    pub(crate) fn pack(fp: u64, val: u8) -> Slot {
        Slot(1 | ((val as u64) << Self::VAL_SHIFT) | ((fp & Self::fp_mask()) << Self::FP_SHIFT))
    }
    #[inline]
    pub(crate) fn used(self) -> bool {
        self.0 & 1 != 0
    }
    #[inline]
    pub(crate) fn val(self) -> u8 {
        (self.0 >> Self::VAL_SHIFT) as u8
    }
    #[inline]
    pub(crate) fn fp(self) -> u64 {
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
pub(crate) fn zeroed_huge_atomics(size: usize) -> Box<[AtomicU64]> {
    let mut v: Vec<u64> = vec![0u64; size];
    #[cfg(target_os = "linux")]
    unsafe {
        // SAFETY: `madvise(MADV_HUGEPAGE)` is advisory -- it only changes page backing,
        // never contents. The start address MUST be page-aligned or madvise returns
        // EINVAL, and `Vec<u64>` is only 8-byte aligned (glibc returns a pointer 16
        // bytes past its mmap chunk header, e.g. `0x..010`), so we advise the
        // page-aligned interior. The kernel then huge-backs the 2 MB-aligned VAs inside
        // it; the sub-page unaligned prefix stays small-paged (negligible on a multi-GB
        // table). Before this fix the call silently EINVAL'd on *every* table, so the
        // random-access probe ran entirely on 4 KB pages -- the dTLB thrash this was
        // meant to cut. The result is still ignored: a genuine no-op (THP off) is fine.
        let base = v.as_mut_ptr() as usize;
        let bytes = std::mem::size_of_val(v.as_slice());
        let page = libc::sysconf(libc::_SC_PAGESIZE).max(1) as usize;
        let aligned = base.next_multiple_of(page);
        let off = aligned - base;
        if bytes > off {
            let len = bytes - off;
            let ptr = aligned as *mut libc::c_void;
            libc::madvise(ptr, len, libc::MADV_HUGEPAGE);
            // `MADV_HUGEPAGE` is only a hint: the kernel forms a 2 MB page lazily, and only
            // when a fully-aligned 2 MB region faults in contiguously. A multi-GB table is
            // first-touched at *random* slots, so on this box only ~70% of it ever reaches
            // THP -- the 4 KB remnant is ~half the dTLB misses on the hot probe (measured:
            // 17 GB RSS, 12 GB AnonHugePages). `MADV_COLLAPSE` (Linux 6.1+) forces a
            // synchronous collapse of the whole range into 2 MB pages now, allocating/
            // compacting as needed. Best-effort and env-gated: it commits the range up
            // front (a full n=16 solve touches almost all of it anyway) and an older kernel
            // just returns EINVAL (ignored, as MADV_HUGEPAGE's result already is).
            //
            // Default-ON for large tables (the n>=16 regime where the dTLB thrash dominates
            // — measured ~5% wall on iso-window with near-identical node counts, so a genuine
            // per-node TLB win, not noise). Small tables skip it: TLB isn't their bottleneck
            // and the up-front commit would defeat their lazy allocation. `QUEENS_TT_COLLAPSE`
            // overrides either way (`0` forces off, anything else forces on).
            let collapse = match std::env::var("QUEENS_TT_COLLAPSE").ok().as_deref() {
                Some("0") => false,
                Some(_) => true,
                None => len >= (1usize << 32), // ~4 GB+ table (n>=16); n<=14 is ~1 GB
            };
            if collapse {
                // ABI-stable advice values not yet in the `libc` crate on this toolchain
                // (include/uapi/asm-generic/mman-common.h).
                const MADV_POPULATE_WRITE: libc::c_int = 23; // Linux 5.14+
                const MADV_COLLAPSE: libc::c_int = 25; // Linux 6.1+
                                                       // MADV_COLLAPSE only merges *populated* pages, and the table is lazily
                                                       // zeroed (unpopulated) here, so prefault the whole range first. This
                                                       // commits the table up front (a full n=16 solve touches ~all of it anyway)
                                                       // and lets COLLAPSE promote the randomly-faulted 4 KB remnant — the ~27%
                                                       // that THP leaves small-paged — into 2 MB pages, cutting dTLB pressure.
                libc::madvise(ptr, len, MADV_POPULATE_WRITE);
                libc::madvise(ptr, len, MADV_COLLAPSE);
            }
        }
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
pub(crate) const TT_HEADER_LEN: usize = 64;

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
    /// Search nodes (TT misses) accumulated when the image was dumped, so a `--resume`
    /// restores the node counter and the progress reflects the *total* work, not just
    /// the post-resume continuation. Stored in the previously-reserved header bytes, so
    /// older images (which have zeroes there) simply resume from 0 -- backward-compatible.
    pub nodes: u64,
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
        b[42..50].copy_from_slice(&self.nodes.to_le_bytes());
        // b[50..64] reserved (zero)
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
            nodes: u64::from_le_bytes(b[42..50].try_into().unwrap()),
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

    /// Whether this table is carrying distinct-position instrumentation.
    #[inline]
    pub(crate) fn is_counting(&self) -> bool {
        self.counter.is_some()
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

    /// Count one searched node (a TT miss about to be expanded) in this worker's local
    /// tally; once it has accumulated [`FLUSH_NODES`] of them (≈ once a second) push the
    /// tally into the shared atomic. The per-node path touches only thread-local memory --
    /// no shared atomic, no cross-CCX coherence.
    #[inline]
    pub fn bump(&self) {
        ACC.with(|cell| {
            let mut a = cell.borrow_mut();
            a.nodes += 1;
            if a.nodes >= FLUSH_NODES {
                self.flush_acc(&mut a);
            }
        });
    }

    /// Count one searched node through a caller-owned local accumulator. This is for hot
    /// sequential recursion that can carry a `u64` down the stack and avoid the per-node
    /// thread-local `RefCell` access in [`Self::bump`]. It preserves progress reporting by
    /// flushing to the shared counter at the same cadence.
    #[inline]
    pub(crate) fn bump_local(&self, nodes: &mut u64) {
        *nodes += 1;
        if *nodes >= FLUSH_NODES {
            self.flush_local_nodes(nodes);
        }
    }

    /// Flush a caller-owned local node accumulator into the shared counter.
    #[inline]
    pub(crate) fn flush_local_nodes(&self, nodes: &mut u64) {
        if *nodes != 0 {
            self.nodes.fetch_add(*nodes, Ordering::Relaxed);
            *nodes = 0;
        }
    }

    /// Push a worker's local tally into the shared atomic + HLL and reset it. Called once
    /// per [`FLUSH_NODES`] nodes and at drain -- off the per-node path. (Caller holds the
    /// thread-local borrow.)
    fn flush_acc(&self, a: &mut Acc) {
        if a.nodes > 0 {
            self.nodes.fetch_add(a.nodes, Ordering::Relaxed);
            a.nodes = 0;
        }
        if !a.hll.is_empty() {
            if let Some(c) = &self.counter {
                c.hll.merge_from(&a.hll);
            }
        }
    }

    /// Flush every rayon worker's accumulator into the shared state and clear their local
    /// estimators, so [`nodes`](Self::nodes) and the distinct report are exact after a
    /// parallel search (the hot loop flushes only ≈ once a second). Run after a parallel
    /// `first_player_wins`. A checkpoint mid-search captures a ~1-s-stale node count unless
    /// drained first -- fine for progress.
    pub fn drain_all(&self) {
        rayon::broadcast(|_| ACC.with(|cell| self.drain_acc(&mut cell.borrow_mut())));
        ACC.with(|cell| self.drain_acc(&mut cell.borrow_mut()));
    }

    /// Drain only the calling thread's accumulator (the sequential `wins` path).
    pub fn drain_local(&self) {
        ACC.with(|cell| self.drain_acc(&mut cell.borrow_mut()));
    }

    fn drain_acc(&self, a: &mut Acc) {
        self.flush_acc(a);
        // Local registers are kept by max between flushes; clear so a later solve in this
        // process does not inherit this solve's distinct keys.
        a.hll.iter_mut().for_each(|b| *b = 0);
    }

    /// A 128-bit hash of the key as two independent `u64` halves: `route` drives
    /// the shard (low bits) and slot index (high bits, disjoint); `fp` is the
    /// fingerprint stored in the slot. The halves use different seeds and mixing
    /// constants so the fingerprint actually discriminates keys that share a slot
    /// (rather than re-deriving bits the index already pinned). `route` reproduces
    /// the legacy hash exactly, preserving the routing distribution.
    #[inline]
    pub(crate) fn hash128(key: Bits) -> (u64, u64) {
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

    /// As [`get`](Self::get)/[`put`](Self::put)/[`prefetch`](Self::prefetch)/
    /// [`archive_key`](Self::archive_key) but taking a pre-computed `(route, fp)` hash,
    /// so a caller that needs several of these for one key (the [`BurrStore`] tiers +
    /// the archive key) pays [`hash128`](Self::hash128) **once** instead of per call.
    /// These skip the distinct-counter hook (the `BurrStore` counts at its own level).
    #[inline]
    pub(crate) fn get_hashed(&self, route: u64, fp: u64) -> Option<u8> {
        let s = Slot(self.slots[self.index(route)].load(Ordering::Relaxed));
        (s.used() && s.fp() == (fp & Slot::fp_mask())).then(|| s.val())
    }
    #[inline]
    pub(crate) fn put_hashed(&self, route: u64, fp: u64, val: u8) {
        self.slots[self.index(route)].store(Slot::pack(fp, val).0, Ordering::Relaxed);
    }
    #[inline]
    pub(crate) fn archive_key_hashed(&self, route: u64, fp: u64) -> u64 {
        archive_key_of(self.index(route) as u64, fp & Slot::fp_mask())
    }
    #[inline]
    pub(crate) fn prefetch_hashed(&self, route: u64) {
        let ptr = self.slots[self.index(route)].as_ptr();
        #[cfg(target_arch = "x86_64")]
        unsafe {
            // SAFETY: as [`prefetch`](Self::prefetch) -- warms a valid in-allocation
            // pointer, no architectural effect, cannot fault.
            std::arch::x86_64::_mm_prefetch::<{ std::arch::x86_64::_MM_HINT_T0 }>(ptr as *const i8);
        }
        #[cfg(not(target_arch = "x86_64"))]
        let _ = ptr;
    }

    /// The stored value for `key`, if a slot's fingerprint matches.
    #[inline]
    pub fn get(&self, key: Bits) -> Option<u8> {
        // Counting hook: every node the search enters is looked up here exactly
        // once, so folding the key in on each `get` measures the distinct set of
        // positions visited -- the table's working set -- deduplicated by the
        // estimator regardless of transposition revisits or eviction.
        if let Some(c) = &self.counter {
            // Fold the key into this worker's *local* HLL registers (a plain byte max, no
            // atomic) -- merged into the shared estimator off the hot loop at flush/drain.
            ACC.with(|cell| {
                let mut a = cell.borrow_mut();
                if a.hll.len() != c.hll.register_count() {
                    a.hll = vec![0u8; c.hll.register_count()];
                }
                c.hll.add_local(key, &mut a.hll);
            });
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

    /// [`get`](Self::get) with the `(route, fp)` of `key` precomputed by the caller
    /// (hash-carry): the hot search hashes each key **once** when it is created and reuses
    /// the halves for the prefetch, this lookup, and the eventual [`put_h`](Self::put_h),
    /// instead of re-deriving them via `hash128` at every touch. `key` is still threaded so
    /// the counting build can fold it into the HLL (a predicted-away null check otherwise).
    #[inline]
    pub fn get_h(&self, key: Bits, route: u64, fp: u64) -> Option<u8> {
        if let Some(c) = &self.counter {
            ACC.with(|cell| {
                let mut a = cell.borrow_mut();
                if a.hll.len() != c.hll.register_count() {
                    a.hll = vec![0u8; c.hll.register_count()];
                }
                c.hll.add_local(key, &mut a.hll);
            });
        }
        let s = Slot(self.slots[self.index(route)].load(Ordering::Relaxed));
        (s.used() && s.fp() == (fp & Slot::fp_mask())).then(|| s.val())
    }

    /// [`put`](Self::put) with the `(route, fp)` of `key` precomputed (hash-carry twin of
    /// [`get_h`](Self::get_h)).
    #[inline]
    pub fn put_h(&self, key: Bits, route: u64, fp: u64, val: u8) {
        self.slots[self.index(route)].store(Slot::pack(fp, val).0, Ordering::Relaxed);
        if let Some(c) = &self.counter {
            c.record(key, val);
        }
    }

    /// [`prefetch`](Self::prefetch) with the route half precomputed (hash-carry).
    #[inline]
    pub fn prefetch_h(&self, route: u64) {
        let ptr = self.slots[self.index(route)].as_ptr();
        #[cfg(target_arch = "x86_64")]
        unsafe {
            // SAFETY: as in `prefetch` -- warms a valid pointer into the live allocation.
            std::arch::x86_64::_mm_prefetch::<{ std::arch::x86_64::_MM_HINT_T0 }>(ptr as *const i8);
        }
        #[cfg(not(target_arch = "x86_64"))]
        let _ = ptr;
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
        self.dump_image_with(w, n, |_, _| {})
    }

    /// As [`dump_image`](Self::dump_image), but invoking `progress(slots_written,
    /// total_slots)` after each block -- so a CLI can paint a checkpoint progress bar.
    /// The slot count is the natural progress metric: the compressed byte size on disk
    /// is smaller and not known until the stream finishes. The callback runs on the
    /// dumping thread between block writes, so it must be cheap (and throttle its own
    /// output).
    pub fn dump_image_with<W: Write, F: FnMut(u64, u64)>(
        &self,
        w: &mut W,
        n: u8,
        mut progress: F,
    ) -> io::Result<()> {
        let header = TtHeader {
            n,
            len: self.len,
            fill: 0, // reporting-only; a full pre-scan every checkpoint isn't worth it
            epoch: 0,
            nodes: self.nodes.load(Ordering::Relaxed), // restored on --resume
        };
        w.write_all(&header.to_bytes())?;
        let mut buf = Vec::with_capacity(TT_IO_BLOCK * 8);
        let mut written = 0u64;
        for chunk in self.slots.chunks(TT_IO_BLOCK) {
            buf.clear();
            for slot in chunk {
                buf.extend_from_slice(&slot.load(Ordering::Relaxed).to_le_bytes());
            }
            w.write_all(&buf)?;
            written += chunk.len() as u64;
            progress(written, self.len);
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
        Self::load_image_with(r, expected_n, |_, _| {})
    }

    /// As [`load_image`](Self::load_image), but invoking `progress(slots_read,
    /// total_slots)` after each block so a CLI can paint a load progress bar -- the
    /// n=16 image is multi-GB and the decompress + zeroed-huge alloc commit takes a
    /// while. The node counter is restored from the header (so a resume's progress
    /// reflects the snapshot's prior work, not a fresh 0).
    pub fn load_image_with<R: Read, F: FnMut(u64, u64)>(
        r: &mut R,
        expected_n: u8,
        mut progress: F,
    ) -> io::Result<QueensTt> {
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
            progress(i as u64, size as u64);
        }
        Ok(QueensTt {
            slots,
            len: header.len,
            nodes: AtomicU64::new(header.nodes),
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

    /// Stream this *live* table's occupied entries as `(archive_key, val)` pairs --
    /// the in-memory freeze source for a [`BurrStore`](crate::queens::BurrStore)
    /// segment (the live twin of [`for_each_image_entry`], which streams a dump).
    /// Each slot is one relaxed atomic load; a concurrent writer may be missed or
    /// included, which only costs a later re-expansion (never a wrong value), so no
    /// lock is taken. The archive key matches [`archive_key`](Self::archive_key), so a
    /// live query resolves to the same entry this freeze stored.
    #[inline]
    pub fn for_each_entry<F: FnMut(u64, u8)>(&self, mut f: F) {
        for (idx, slot) in self.slots.iter().enumerate() {
            let s = Slot(slot.load(Ordering::Relaxed));
            if s.used() {
                f(archive_key_of(idx as u64, s.fp()), s.val());
            }
        }
    }

    /// Zero every slot (relaxed stores), returning the table to empty so it can be
    /// reused as a fresh memtable after a freeze. The node counter and any distinct
    /// counter are left untouched -- they are cumulative search state, not per-memtable.
    /// A concurrent `put` racing the clear is simply lost (re-expanded later) -- sound,
    /// never wrong.
    pub fn clear(&self) {
        for slot in self.slots.iter() {
            slot.store(0, Ordering::Relaxed);
        }
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
    pub(crate) fn bump(&self) {
        self.nodes.fetch_add(1, Ordering::Relaxed);
    }

    #[inline]
    pub(crate) fn get(&self, key: Bits) -> Option<(u32, u32)> {
        let h = QueensTt::hash128(key).0; // PnTt keeps the full key, so it needs only the routing half
        let idx = ((h >> 32) & self.slot_mask) as usize;
        let s = self.shards[(h & self.shard_mask) as usize].lock().unwrap()[idx];
        (s.used != 0 && s.key == key.0).then_some((s.phi, s.delta))
    }

    #[inline]
    pub(crate) fn put(&self, key: Bits, phi: u32, delta: u32) {
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
