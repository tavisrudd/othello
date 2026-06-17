//! `BurrStore` -- the BuRR-as-primary, log-structured transposition store for the
//! [`Burr`](crate::queens::Burr) solver (Chunk 4, "BuRR live").
//!
//! The flat [`QueensTt`] holds at most `2^bits` keys at 64 bits/slot and *evicts*
//! once full -- at n=16 it fits ~27% of the ~7.9 B distinct set, so ~26% of
//! expansions are pure capacity re-search (the bottleneck reframe). This store
//! replaces it with a **log-structured** layout: a mutable memtable (one
//! [`QueensTt`]) absorbs `put`s; when it fills past a threshold it is **frozen** into
//! an immutable BuRR `segment` (~`1.1*(1+fp_bits)` bits/key, *no eviction*).
//!
//! # Append-only segments (no recompaction)
//!
//! Each freeze builds **one new segment from only the just-frozen buffer** and
//! *appends* it to the segment table. Prior segments are never read, copied, or
//! rebuilt -- so a freeze is **linear** in the buffer (not the whole frozen set), and
//! resident memory is the live segments themselves (~`6 b/key`, no duplicate), not the
//! `2x` peak an earlier "rebuild one compacted segment from a retained pair set"
//! design paid (that retained pairs at 16 b/key *and* re-materialised the entire
//! archive every freeze -- quadratic CPU and an OOM at n=16). A query walks the
//! published segments after the Bloom admits it (a key lives in exactly one segment).
//!
//! # Bounded memory (pre-allocated, never OOMs)
//!
//! Full n=16 retention does not fit this box's RAM, so the store is **capped**: a
//! freeze that would push resident segment bytes past `cap_limit` (or fill the
//! pre-allocated segment table) latches `frozen_full` and *stops freezing*. The active
//! memtable then behaves as an ordinary evicting TT -- re-expansion climbs gracefully
//! past `1.0x` instead of the process growing without bound. Every large allocation
//! (the two memtables, the Bloom, the segment-pointer table) is made **once at
//! construction**; the only per-freeze allocations are the new segment and a transient
//! per-buffer build scratch, both bounded by the buffer size and freed promptly off the
//! search's hot path.
//!
//! # The levers that make it fast (each a measured cost center)
//!
//! 1. **Two fixed memtables + an atomic epoch** (no `ArcSwap` on the hot path -- that
//!    was ~15% of cycles). Writes go to `bufs[active]`; a freeze flips `active` to the
//!    other (already-cleared) buffer with no stall, and a background thread builds the
//!    old one's segment and then clears it for reuse. The old buffer stays queryable
//!    during the build, so the hot set is never wiped. A `get` is one relaxed load +
//!    an index, not a hazard-pointer dance.
//! 2. **A Bloom prefilter** over all frozen keys. Every expanded node starts with a
//!    `get` that misses; the Bloom rejects a genuine miss in one cache-line read, so
//!    the segment walk runs only on a hit (or a Bloom false positive).
//! 3. **A pre-allocated segment table.** Segment `i < seg_count` is a published,
//!    immortal [`ShardedArchive`] read lock-free via a raw pointer (the Arc behind it
//!    is held for the whole run in `seg_hold`, so the deref is always valid). The
//!    freeze builds each shard on a **dedicated build pool** (off the search's rayon
//!    workers).
//!
//! # Why this is correct regardless of the freeze race
//!
//! A position's archive identity `(slot_index, fingerprint)` is a deterministic
//! function of its canonical key and the (fixed) memtable `len`
//! ([`QueensTt::archive_key`]). The store only ever answers **the right value or
//! `None`**: a tier miss re-expands (sound, deterministic verdict); the only
//! wrong-value source is a [`burr::Archive`] false positive, bounded by `fp_bits`. So
//! even a racy freeze costs at most re-expansion -- never a wrong answer. (A key that
//! races into two segments is stored with the same value in both, so the walk is still
//! correct.)
//!
//! # Knobs (resolved once at construction)
//!
//! - `QUEENS_BURR_MEM_BITS` -- each memtable's size `2^bits` (default: the CLI `bits`).
//! - `QUEENS_BURR_FREEZE_AT` -- freeze when this many slots are filled (default 75%).
//! - `QUEENS_BURR_CAP_GB` -- resident segment-bytes ceiling (default 12 GB). Past it
//!   the store stops freezing and the memtable evicts. Size it to leave room for the
//!   two memtables + Bloom + a few GB of transient freeze scratch within physical RAM.
//! - `QUEENS_BURR_FP` -- archive fingerprint bits (default 44; FP rate `~2^-fp`).
//! - `QUEENS_BURR_LOAD` -- per-layer ribbon load factor (default 0.90).
//! - `QUEENS_BURR_SHARDS` -- segment shards = build parallelism (default 32).
//! - `QUEENS_BURR_BUILD_THREADS` -- dedicated build-pool threads (default 8). Reserve
//!   cores for it with `RAYON_NUM_THREADS = cores - build_threads` (freeze off-core).
//! - `QUEENS_BURR_BLOOM_GB` -- prefilter size (default `0.2 * cap` ≈ 10 bits/key at the
//!   default fp; `0` disables). Sized so a genuine miss is rejected in one line even at
//!   the cap; too small and it saturates and every miss walks all segments.

use super::*;
use crate::burr::{fastrange, Archive, ShardedArchive};
use rayon::prelude::*;
use std::sync::atomic::{AtomicBool, AtomicPtr, AtomicU64, AtomicU8, AtomicUsize, Ordering};
use std::sync::{Arc, Mutex};

/// Archive value width: win/loss is one bit (matches the CLI `freeze`'s
/// `ARCHIVE_VAL_BITS`). A nimber store would widen this.
const VAL_BITS: u32 = 1;

/// Bits set per key in the [`Bloom`] prefilter (cache-line-blocked double hashing).
const BLOOM_K: u32 = 8;

/// Pre-allocated capacity of the segment-pointer table. The byte `cap_limit` is the
/// real bound (≈ 20-30 segments at the default cap and an n=16 freeze size); this is a
/// generous backstop so the table never reallocates and a freeze that would exceed it
/// simply latches `frozen_full` like the byte cap.
const MAX_SEGMENTS: usize = 8192;

/// A cache-line-**blocked** Bloom filter over the frozen `archive_key`s: the prefilter
/// that keeps a genuine miss O(1). Absent ⇒ skip the segment; no false negatives, so a
/// false positive is only a wasted probe, never a wrong answer.
struct Bloom {
    words: Box<[AtomicU64]>,
    blocks: u64,
}

impl Bloom {
    fn new(bytes: usize) -> Self {
        let blocks = (bytes / 64).max(1) as u64;
        // Hugepage-backed, presized once: the prefilter is read on every node miss and is
        // multi-GB, so 4 KB pages would thrash the TLB. `zeroed_huge_atomics` advises
        // `MADV_HUGEPAGE` and commits lazily (the words zero-fill on first touch).
        Bloom {
            words: crate::queens::tt::zeroed_huge_atomics((blocks * 8) as usize),
            blocks,
        }
    }

    #[inline]
    fn locate(&self, ak: u64) -> (usize, [u32; BLOOM_K as usize]) {
        // One `mix64`, no division: `fastrange` maps the hash uniformly to a block with
        // a multiply-high (~3 cyc) instead of `% self.blocks` (~20-40 cyc integer div),
        // and the 8 in-block bit positions are derived from the *same* hash via a
        // multiply-seeded rotate/xor chain (Kirsch-Mitzenmacher double hashing -- a full
        // second `mix64` is unnecessary for a prefilter and preserves the FP rate). This
        // is the per-check hot path of every node's miss *and* the per-segment-Bloom walk.
        let h = mix64(ak);
        let base = fastrange(h, self.blocks) as usize * 8;
        let mut x = h.wrapping_mul(0x2545_F491_4F6C_DD1D);
        let mut bits = [0u32; BLOOM_K as usize];
        for b in bits.iter_mut() {
            *b = (x & 511) as u32;
            x = x.rotate_right(9) ^ h;
        }
        (base, bits)
    }

    #[inline]
    fn insert(&self, ak: u64) {
        let (base, bits) = self.locate(ak);
        for &b in &bits {
            self.words[base + (b >> 6) as usize].fetch_or(1u64 << (b & 63), Ordering::Relaxed);
        }
    }

    #[inline]
    fn maybe_contains(&self, ak: u64) -> bool {
        let (base, bits) = self.locate(ak);
        bits.iter().all(|&b| {
            self.words[base + (b >> 6) as usize].load(Ordering::Relaxed) & (1u64 << (b & 63)) != 0
        })
    }

    /// Warm the cache line `maybe_contains(ak)` will read (the whole 512-bit block is
    /// one line), so the demand check overlaps its DRAM round-trip with search work.
    #[inline]
    fn prefetch(&self, ak: u64) {
        let base = fastrange(mix64(ak), self.blocks) as usize * 8;
        let ptr = self.words[base].as_ptr();
        #[cfg(target_arch = "x86_64")]
        unsafe {
            // SAFETY: warms a valid in-allocation pointer; no architectural effect.
            std::arch::x86_64::_mm_prefetch::<{ std::arch::x86_64::_MM_HINT_T0 }>(ptr as *const i8);
        }
        #[cfg(not(target_arch = "x86_64"))]
        let _ = ptr;
    }
}

/// One frozen segment: an immutable BuRR archive plus a membership Bloom over exactly
/// its keys. The append-only walk consults `bloom` before probing `archive`, so a
/// frozen-tier hit touches ~one segment's ribbon instead of every segment's (the walk
/// cost that grows with segment count). The Bloom has **no false negatives**, so skipping
/// a segment it rejects can never miss a real hit -- a Bloom false positive only costs one
/// wasted (`None`-returning) probe, never a wrong answer.
struct Segment {
    archive: ShardedArchive,
    bloom: Bloom,
}

/// State shared between the search threads and the background freeze thread.
struct Shared {
    /// The two memtables. Writes go to `bufs[active]`; the other is empty (between
    /// freezes) or being frozen + cleared (during one). Fixed allocations -- never
    /// freed, so the hot path indexes them with a plain epoch load, no `Arc`.
    bufs: [QueensTt; 2],
    /// Index (0/1) of the buffer writes currently target.
    active: AtomicU8,
    /// Pre-allocated segment-pointer table (raw pointers into the Arcs held in
    /// `seg_hold`). Append-only: index `i < seg_count` is a published, immortal segment,
    /// read lock-free on the hot path (load `seg_count`, walk). The freeze stores the
    /// pointer (Release) before bumping `seg_count` (Release); a reader loads `seg_count`
    /// (Acquire) then derefs -- so it never sees an unpublished slot.
    segs: Box<[AtomicPtr<Segment>]>,
    seg_count: AtomicUsize,
    /// Owns the segment Arcs for the whole run (never dropped ⇒ hot-path raw derefs stay
    /// valid). `with_capacity(MAX_SEGMENTS)`, so a freeze's `push` never reallocates.
    seg_hold: Mutex<Vec<Arc<Segment>>>,
    /// Bits per key in each per-segment membership Bloom (resolved once). Wider = lower
    /// false-positive rate (fewer wasted probes) at more memory.
    seg_bloom_bits: u64,
    /// Prefilter over all frozen keys. `None` disables it.
    bloom: Option<Bloom>,
    freeze_at: u64,
    fp_bits: u32,
    load: f64,
    shards: usize,
    /// Hard ceiling on resident segment bytes. A freeze that would cross it (or fill the
    /// segment table) latches `frozen_full` and stops -- the memtable then evicts and
    /// re-expansion climbs, instead of the store growing past RAM (the OOM before this).
    cap_limit: u64,
    max_segments: usize,
    /// Latched once the frozen tier is capped: no more flips/freezes; the active memtable
    /// becomes an evicting cache.
    frozen_full: AtomicBool,
    /// Resident bytes across all published segments (the cap is checked against this).
    frozen_bytes: AtomicU64,
    /// A dedicated pool the segment build runs on, so it does not contend the search's
    /// global rayon pool. Reserve cores with `RAYON_NUM_THREADS = cores - build_threads`.
    build_pool: rayon::ThreadPool,
    /// Approximate occupied count in the active buffer since the last freeze.
    fill: AtomicU64,
    /// True while a freeze is in flight: the *other* buffer holds queryable data and the
    /// next freeze must wait. Doubles as the cheap "probe the other buffer?" gate.
    freezing: AtomicBool,
    nodes: AtomicU64,
    counter: Option<Counter>,
    freezes: AtomicU64,
    frozen_keys: AtomicU64,
    building: AtomicU64,
}

/// The BuRR-as-primary log-structured store. See the module docs.
pub struct BurrStore {
    inner: Arc<Shared>,
}

fn mem_bits_for(bits: u32) -> u32 {
    std::env::var("QUEENS_BURR_MEM_BITS")
        .ok()
        .and_then(|s| s.parse().ok())
        .unwrap_or(bits)
        .max(1)
}

fn freeze_at_for(mem_slots: u64) -> u64 {
    std::env::var("QUEENS_BURR_FREEZE_AT")
        .ok()
        .and_then(|s| s.parse().ok())
        .unwrap_or((mem_slots as f64 * 0.75) as u64)
        .max(1)
}

fn fp_bits_env() -> u32 {
    std::env::var("QUEENS_BURR_FP")
        .ok()
        .and_then(|s| s.parse().ok())
        .unwrap_or(44)
}

fn load_env() -> f64 {
    std::env::var("QUEENS_BURR_LOAD")
        .ok()
        .and_then(|s| s.parse().ok())
        .filter(|&l: &f64| (0.1..1.0).contains(&l))
        .unwrap_or(0.90)
}

fn shards_env() -> usize {
    std::env::var("QUEENS_BURR_SHARDS")
        .ok()
        .and_then(|s| s.parse().ok())
        .unwrap_or(32usize)
        .max(1)
}

fn build_threads_env() -> usize {
    std::env::var("QUEENS_BURR_BUILD_THREADS")
        .ok()
        .and_then(|s| s.parse().ok())
        .unwrap_or(8usize)
        .max(1)
}

fn cap_bytes_env() -> u64 {
    let gb = std::env::var("QUEENS_BURR_CAP_GB")
        .ok()
        .and_then(|s| s.parse::<f64>().ok())
        .unwrap_or(12.0);
    (gb * 1e9) as u64
}

/// Bits per key in each per-segment membership Bloom (default 8 ≈ 1 byte/key, a few %
/// false-positive rate -- fine for routing the walk to the right segment).
fn seg_bloom_bits_env() -> u64 {
    std::env::var("QUEENS_BURR_SEG_BLOOM_BITS")
        .ok()
        .and_then(|s| s.parse().ok())
        .unwrap_or(8u64)
        .max(1)
}

/// Default the prefilter to ~`0.2 * cap` bytes (≈ 10 bits per frozen key at the default
/// fp width and ribbon density), so a genuine miss is still rejected in one cache-line
/// read at the cap. `QUEENS_BURR_BLOOM_GB` overrides; `0` disables.
fn bloom_bytes_env(cap: u64) -> usize {
    match std::env::var("QUEENS_BURR_BLOOM_GB")
        .ok()
        .and_then(|s| s.parse::<f64>().ok())
    {
        Some(gb) => (gb * 1e9) as usize,
        None => (cap as f64 * 0.2) as usize,
    }
}

impl BurrStore {
    fn build(bits: u32, freeze_at: Option<u64>, counter: Option<Counter>) -> Self {
        let mb = mem_bits_for(bits);
        let mem_slots = QueensTt::new(mb).capacity().0;
        let shards = shards_env();
        let cap = cap_bytes_env();
        BurrStore {
            inner: Arc::new(Shared {
                bufs: [QueensTt::new(mb), QueensTt::new(mb)],
                active: AtomicU8::new(0),
                segs: (0..MAX_SEGMENTS)
                    .map(|_| AtomicPtr::new(std::ptr::null_mut()))
                    .collect::<Vec<_>>()
                    .into_boxed_slice(),
                seg_count: AtomicUsize::new(0),
                seg_hold: Mutex::new(Vec::with_capacity(MAX_SEGMENTS)),
                seg_bloom_bits: seg_bloom_bits_env(),
                bloom: {
                    let b = bloom_bytes_env(cap);
                    (b > 0).then(|| Bloom::new(b))
                },
                freeze_at: freeze_at.unwrap_or_else(|| freeze_at_for(mem_slots)),
                fp_bits: fp_bits_env(),
                load: load_env(),
                shards,
                cap_limit: cap,
                max_segments: MAX_SEGMENTS,
                frozen_full: AtomicBool::new(false),
                frozen_bytes: AtomicU64::new(0),
                build_pool: rayon::ThreadPoolBuilder::new()
                    .num_threads(build_threads_env())
                    .thread_name(|i| format!("burr-build-{i}"))
                    .build()
                    .expect("build pool"),
                fill: AtomicU64::new(0),
                freezing: AtomicBool::new(false),
                nodes: AtomicU64::new(0),
                counter,
                freezes: AtomicU64::new(0),
                frozen_keys: AtomicU64::new(0),
                building: AtomicU64::new(0),
            }),
        }
    }

    pub fn new(bits: u32) -> Self {
        Self::build(bits, None, None)
    }

    pub fn new_counting(bits: u32, hll_p: u32) -> Self {
        Self::build(
            bits,
            None,
            Some(Counter {
                hll: Hll::new(hll_p),
                exact: None,
            }),
        )
    }

    /// A store with an explicit freeze threshold -- forces frequent freezes in tests.
    pub fn with_freeze_at(bits: u32, freeze_at: u64) -> Self {
        Self::build(bits, Some(freeze_at), None)
    }

    /// The stored value for `key`: active memtable, then (only during a freeze) the
    /// buffer being frozen, then -- only if the prefilter admits it -- the published
    /// segments (walked; a key lives in exactly one). Feeds the distinct counter once.
    #[inline]
    pub fn get(&self, key: Bits) -> Option<u8> {
        let s = &self.inner;
        if let Some(c) = &s.counter {
            c.feed(key);
        }
        // One `hash128` for the whole query: the active probe, the other-buffer probe,
        // and the archive key all reuse it (was hashed twice per miss).
        let (route, fp) = QueensTt::hash128(key);
        let i = s.active.load(Ordering::Relaxed) as usize;
        if let Some(v) = s.bufs[i].get_hashed(route, fp) {
            return Some(v);
        }
        // The other buffer holds queryable data only while a freeze is in flight.
        if s.freezing.load(Ordering::Acquire) {
            if let Some(v) = s.bufs[i ^ 1].get_hashed(route, fp) {
                return Some(v);
            }
        }
        // No frozen segments yet ⇒ the two buffer probes were exhaustive; skip the
        // archive-key derive *and* the (multi-GB, random-access) shared Bloom entirely.
        // Before the first freeze every expanded node is a miss, so this removes one cold
        // DRAM access from every node of the whole pre-freeze phase. Sound: `seg_count` is
        // monotonic (append-only), and a racing freeze publishing after this load only
        // costs a re-expansion (the store's miss-re-expands invariant), never a wrong value.
        let count = s.seg_count.load(Ordering::Acquire);
        if count == 0 {
            return None;
        }
        let ak = s.bufs[i].archive_key_hashed(route, fp);
        if let Some(bloom) = &s.bloom {
            if !bloom.maybe_contains(ak) {
                return None;
            }
        }
        // Walk the published segments. The shared Bloom already rejected genuine misses,
        // so this runs on a real hit or a shared-Bloom false positive. Each segment's own
        // Bloom skips it unless it (maybe) holds the key, so a hit probes ~one ribbon
        // rather than every segment's -- the append-only walk stays ~O(1) in segment count.
        for slot in &s.segs[..count] {
            let p = slot.load(Ordering::Acquire);
            // SAFETY: slot `i < seg_count` was published (Release) only after its segment
            // Arc was pushed into `seg_hold`, which holds it for the whole run -- so the
            // pointee is never dropped and this deref is valid.
            let seg = unsafe { &*p };
            if seg.bloom.maybe_contains(ak) {
                if let Some(v) = seg.archive.get(ak) {
                    return Some(v as u8);
                }
            }
        }
        None
    }

    #[inline]
    pub fn put(&self, key: Bits, val: u8) {
        let s = &self.inner;
        if let Some(c) = &s.counter {
            c.record(key, val);
        }
        let (route, fp) = QueensTt::hash128(key);
        let i = s.active.load(Ordering::Relaxed) as usize;
        s.bufs[i].put_hashed(route, fp, val);
        if s.fill.fetch_add(1, Ordering::Relaxed) + 1 >= s.freeze_at {
            self.maybe_freeze();
        }
    }

    #[inline]
    pub fn bump(&self) {
        self.inner.nodes.fetch_add(1, Ordering::Relaxed);
    }

    #[inline]
    pub fn prefetch(&self, key: Bits) {
        let s = &self.inner;
        let (route, fp) = QueensTt::hash128(key);
        let i = s.active.load(Ordering::Relaxed) as usize;
        s.bufs[i].prefetch_hashed(route);
        // Also warm the prefilter line the upcoming `get` miss will read -- but only once
        // there are segments to walk (matches `get`'s seg_count==0 short-circuit; no point
        // warming the Bloom for a phase that never reads it).
        if s.seg_count.load(Ordering::Acquire) > 0 {
            if let Some(bloom) = &s.bloom {
                bloom.prefetch(s.bufs[i].archive_key_hashed(route, fp));
            }
        }
    }

    #[cold]
    fn maybe_freeze(&self) {
        let s = &self.inner;
        if s.frozen_full.load(Ordering::Relaxed) {
            // Frozen tier capped: stop growing. Reset fill so we only re-enter once per
            // `freeze_at` puts; the active memtable now evicts (re-exp climbs gracefully).
            s.fill.store(0, Ordering::Relaxed);
            return;
        }
        if s.freezing.swap(true, Ordering::Acquire) {
            return; // a freeze is already in flight
        }
        if s.fill.load(Ordering::Relaxed) < s.freeze_at {
            s.freezing.store(false, Ordering::Release);
            return;
        }
        // Crossing the byte cap (or the segment table) latches `frozen_full`: no flip,
        // no freeze -- the store stops growing here.
        if s.frozen_bytes.load(Ordering::Relaxed) >= s.cap_limit
            || s.seg_count.load(Ordering::Relaxed) >= s.max_segments
        {
            s.frozen_full.store(true, Ordering::Relaxed);
            s.fill.store(0, Ordering::Relaxed);
            s.freezing.store(false, Ordering::Release);
            return;
        }
        // Flip writes to the other (already-cleared) buffer; freeze the old one.
        let old = s.active.load(Ordering::Relaxed) as usize;
        s.active.store((old ^ 1) as u8, Ordering::Release);
        s.fill.store(0, Ordering::Relaxed);
        let inner = Arc::clone(&self.inner);
        std::thread::spawn(move || inner.freeze_buffer(old));
    }

    // -- Solver-facing reporting --

    pub fn nodes(&self) -> u64 {
        self.inner.nodes.load(Ordering::Relaxed)
    }

    pub fn report(&self) -> Option<CountReport> {
        self.inner.counter.as_ref().map(|c| CountReport {
            estimate: c.hll.estimate(),
            exact: c.exact.as_ref().map(|m| m.lock().unwrap().len() as u64),
            registers: c.hll.registers.len() as u64,
        })
    }

    pub fn working_set(&self) -> Option<Vec<(Bits, u8)>> {
        let map = self.inner.counter.as_ref()?.exact.as_ref()?.lock().unwrap();
        Some(map.iter().map(|(&k, &v)| (k, v)).collect())
    }

    pub fn cap_bytes(&self) -> u64 {
        let s = &self.inner;
        let mem = s.bufs[0].capacity().1 + s.bufs[1].capacity().1;
        let seg = s.frozen_bytes.load(Ordering::Relaxed);
        let bloom = s.bloom.as_ref().map_or(0, |b| b.words.len() as u64 * 8);
        mem + seg + bloom
    }

    pub fn summary(&self) -> String {
        let s = &self.inner;
        let (mem_slots, mem_bytes) = s.bufs[0].capacity();
        let frozen = s.frozen_keys.load(Ordering::Relaxed);
        let seg_bytes = s.frozen_bytes.load(Ordering::Relaxed);
        let bpk = if frozen > 0 {
            seg_bytes as f64 * 8.0 / frozen as f64
        } else {
            0.0
        };
        let building = s.building.load(Ordering::Relaxed);
        format!(
            "burr LSM: 2x mem {:.2} GB ({} slots, fill {}), {} segments / {} keys / {:.2} GB ({:.1} b/key), {} freezes{}{}, fp {}",
            mem_bytes as f64 / 1e9,
            mem_slots,
            s.fill.load(Ordering::Relaxed),
            s.seg_count.load(Ordering::Relaxed),
            frozen,
            seg_bytes as f64 / 1e9,
            bpk,
            s.freezes.load(Ordering::Relaxed),
            if building > 0 {
                format!(" (building {building})")
            } else {
                String::new()
            },
            if s.frozen_full.load(Ordering::Relaxed) {
                " (cap reached, memtable evicting)"
            } else {
                ""
            },
            s.fp_bits,
        )
    }
}

impl Shared {
    /// Background: build a **new** segment from the frozen-out buffer `old`, append it to
    /// the segment table, then clear the buffer for reuse. Runs on its own thread; the
    /// search keeps going on the fresh active buffer, and `bufs[old]` stays queryable (the
    /// `freezing` gate) until its keys are in the published segment -- so the hot set is
    /// never wiped. Prior segments are untouched (append-only -- no recompaction).
    fn freeze_buffer(&self, old: usize) {
        // Partition this buffer's entries by shard (transient -- freed at the end of the
        // freeze). The hot search path never touches these; they are freezer-local.
        let per_shard = self.freeze_at as usize / self.shards + 64;
        let mut shard_pairs: Vec<Vec<(u64, u64)>> = (0..self.shards)
            .map(|_| Vec::with_capacity(per_shard))
            .collect();
        // Per-segment membership Bloom, sized to the freeze threshold (lazily committed,
        // so a partial buffer only touches `added` worth of lines). Built here from the
        // same archive-key scan that feeds the shared prefilter.
        let seg_bloom = Bloom::new((self.freeze_at * self.seg_bloom_bits / 8).max(64) as usize);
        let mut added = 0u64;
        self.bufs[old].for_each_entry(|ak, val| {
            if let Some(bloom) = &self.bloom {
                bloom.insert(ak);
            }
            seg_bloom.insert(ak);
            shard_pairs[ShardedArchive::shard_of(self.shards, ak)].push((ak, val as u64));
            added += 1;
        });
        if added > 0 {
            self.building.store(added, Ordering::Relaxed);
            // Build each shard's archive on the dedicated pool. `into_par_iter` consumes
            // the per-shard vecs so each one frees as soon as its archive is built,
            // keeping the transient build scratch bounded to the in-flight shards.
            let subs: Vec<Archive> = self.build_pool.install(|| {
                shard_pairs
                    .into_par_iter()
                    .map(|g| Archive::build(&g, VAL_BITS, self.fp_bits, self.load))
                    .collect()
            });
            let archive = ShardedArchive::from_shards(subs);
            // Cap accounts for the segment ribbon *and* its membership Bloom.
            let bytes = archive.bits() / 8 + seg_bloom.words.len() as u64 * 8;
            let seg = Arc::new(Segment {
                archive,
                bloom: seg_bloom,
            });
            let raw = Arc::as_ptr(&seg) as *mut Segment;
            // Publish: hold the Arc alive for the whole run, store the pointer, then bump
            // the count (so a reader that sees the new count also sees the pointer).
            {
                let mut hold = self.seg_hold.lock().unwrap();
                let idx = self.seg_count.load(Ordering::Relaxed);
                hold.push(seg); // with_capacity(MAX_SEGMENTS) ⇒ never reallocates
                self.segs[idx].store(raw, Ordering::Release);
                self.seg_count.store(idx + 1, Ordering::Release);
            }
            self.frozen_bytes.fetch_add(bytes, Ordering::Relaxed);
            self.frozen_keys.fetch_add(added, Ordering::Relaxed);
            self.freezes.fetch_add(1, Ordering::Relaxed);
            self.building.store(0, Ordering::Relaxed);
        }
        // The segment now answers for these keys; clear the buffer for reuse and let the
        // next freeze proceed. (Clearing is racy with late writes to `old` -- those are
        // simply re-expanded, never wrong.)
        self.bufs[old].clear();
        self.freezing.store(false, Ordering::Release);
    }
}
