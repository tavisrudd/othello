//! `BurrStore` -- the BuRR-as-primary, log-structured transposition store for the
//! [`Burr`](crate::queens::Burr) solver (Chunk 4, "BuRR live").
//!
//! The flat [`QueensTt`] holds at most `2^bits` keys at 64 bits/slot and *evicts*
//! once full -- at n=16 it fits ~27% of the ~7.9 B distinct set, so ~26% of
//! expansions are pure capacity re-search (the bottleneck reframe). This store
//! replaces it with a **log-structured** layout: a mutable memtable (one
//! [`QueensTt`]) absorbs `put`s; when it fills past a threshold it is **frozen** into
//! the immutable BuRR `segment` (~`1.1*(1+fp_bits)` bits/key, *no eviction*).
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
//!    `get` that misses; the Bloom rejects a genuine miss in one cache-line read.
//! 3. **A single compacted segment (K = 1).** A transposition hit into a frozen key is
//!    one sharded probe regardless of run length: the freeze retains `(archive_key,
//!    value)` pairs (partitioned by shard) and rebuilds the one [`ShardedArchive`] on a
//!    **dedicated build pool** (off the search's rayon workers).
//!
//! # Why this is correct regardless of the freeze race
//!
//! A position's archive identity `(slot_index, fingerprint)` is a deterministic
//! function of its canonical key and the (fixed) memtable `len`
//! ([`QueensTt::archive_key`]). The store only ever answers **the right value or
//! `None`**: a tier miss re-expands (sound, deterministic verdict); the only
//! wrong-value source is a [`burr::Archive`] false positive, bounded by `fp_bits`. So
//! even a racy freeze costs at most re-expansion -- never a wrong answer.
//!
//! # Knobs (resolved once at construction)
//!
//! - `QUEENS_BURR_MEM_BITS` -- each memtable's size `2^bits` (default: the CLI `bits`).
//! - `QUEENS_BURR_FREEZE_AT` -- freeze when this many slots are filled (default 75%).
//! - `QUEENS_BURR_FP` -- archive fingerprint bits (default 44; FP rate `~2^-fp`).
//! - `QUEENS_BURR_LOAD` -- per-layer ribbon load factor (default 0.90).
//! - `QUEENS_BURR_SHARDS` -- segment shards = build parallelism (default 32).
//! - `QUEENS_BURR_BUILD_THREADS` -- dedicated build-pool threads (default 8). Reserve
//!   cores for it with `RAYON_NUM_THREADS = cores - build_threads` (freeze off-core).
//! - `QUEENS_BURR_BLOOM_GB` -- prefilter size (default 1.0 GB; `0` disables).

use super::*;
use crate::burr::{Archive, ShardedArchive};
use rayon::prelude::*;
use std::sync::atomic::{AtomicBool, AtomicPtr, AtomicU64, AtomicU8, Ordering};
use std::sync::{Arc, Mutex};

/// Archive value width: win/loss is one bit (matches the CLI `freeze`'s
/// `ARCHIVE_VAL_BITS`). A nimber store would widen this.
const VAL_BITS: u32 = 1;

/// Bits set per key in the [`Bloom`] prefilter (cache-line-blocked double hashing).
const BLOOM_K: u32 = 8;

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
        let h1 = mix64(ak);
        let mut x = mix64(ak ^ 0x9E37_79B9_7F4A_7C15);
        let base = (h1 % self.blocks) as usize * 8;
        let mut bits = [0u32; BLOOM_K as usize];
        for b in bits.iter_mut() {
            *b = (x & 511) as u32;
            x = x.rotate_right(9) ^ h1;
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
        let base = (mix64(ak) % self.blocks) as usize * 8;
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

/// State shared between the search threads and the background freeze thread.
struct Shared {
    /// The two memtables. Writes go to `bufs[active]`; the other is empty (between
    /// freezes) or being frozen + cleared (during one). Fixed allocations -- never
    /// freed, so the hot path indexes them with a plain epoch load, no `Arc`.
    bufs: [QueensTt; 2],
    /// Index (0/1) of the buffer writes currently target.
    active: AtomicU8,
    /// The single compacted segment (rebuilt each freeze ⇒ a hit is one sharded probe),
    /// read on the hot path via a raw pointer (a relaxed load, not the `ArcSwap`
    /// hazard-pointer dance that profiled at ~14%). `null` until the first freeze.
    seg_ptr: AtomicPtr<ShardedArchive>,
    /// Keeps the last two published segments alive so a hot-path `&*seg_ptr` is valid:
    /// reads take ~µs, republishes are seconds apart, so a reader can never deref a
    /// dropped segment. The freezer pushes the new one and drops all but the last two.
    seg_live: Mutex<Vec<Arc<ShardedArchive>>>,
    /// All frozen `(archive_key, value)` pairs, partitioned by shard so the segment can
    /// be rebuilt in parallel with no gather copy. Touched only by the (serialized)
    /// freezer, never the hot path.
    pairs: Vec<Mutex<Vec<(u64, u64)>>>,
    /// Prefilter over all frozen keys. `None` disables it.
    bloom: Option<Bloom>,
    freeze_at: u64,
    fp_bits: u32,
    load: f64,
    shards: usize,
    /// A dedicated pool the segment rebuild runs on, so it does not contend the search's
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

fn bloom_bytes_env() -> usize {
    let gb = std::env::var("QUEENS_BURR_BLOOM_GB")
        .ok()
        .and_then(|s| s.parse::<f64>().ok())
        .unwrap_or(1.0);
    (gb * 1e9) as usize
}

impl BurrStore {
    fn build(bits: u32, freeze_at: Option<u64>, counter: Option<Counter>) -> Self {
        let mb = mem_bits_for(bits);
        let mem_slots = QueensTt::new(mb).capacity().0;
        let shards = shards_env();
        BurrStore {
            inner: Arc::new(Shared {
                bufs: [QueensTt::new(mb), QueensTt::new(mb)],
                active: AtomicU8::new(0),
                seg_ptr: AtomicPtr::new(std::ptr::null_mut()),
                seg_live: Mutex::new(Vec::new()),
                pairs: (0..shards).map(|_| Mutex::new(Vec::new())).collect(),
                bloom: {
                    let b = bloom_bytes_env();
                    (b > 0).then(|| Bloom::new(b))
                },
                freeze_at: freeze_at.unwrap_or_else(|| freeze_at_for(mem_slots)),
                fp_bits: fp_bits_env(),
                load: load_env(),
                shards,
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
    /// buffer being frozen, then -- only if the prefilter admits it -- the compacted
    /// segment. Feeds the distinct counter once per query.
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
        let ak = s.bufs[i].archive_key_hashed(route, fp);
        if let Some(bloom) = &s.bloom {
            if !bloom.maybe_contains(ak) {
                return None;
            }
        }
        let p = s.seg_ptr.load(Ordering::Acquire);
        if !p.is_null() {
            // SAFETY: `p` points into an `Arc<ShardedArchive>` kept in `seg_live` (the
            // last two published segments). A get's load→deref takes ~µs while segments
            // are republished seconds apart, so the Arc behind `p` cannot drop mid-deref.
            let seg = unsafe { &*p };
            if let Some(v) = seg.get(ak) {
                return Some(v as u8);
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
        s.fill.fetch_add(1, Ordering::Relaxed);
        if s.fill.load(Ordering::Relaxed) >= s.freeze_at {
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
        // Also warm the prefilter line the upcoming `get` miss will read.
        if let Some(bloom) = &s.bloom {
            bloom.prefetch(s.bufs[i].archive_key_hashed(route, fp));
        }
    }

    #[cold]
    fn maybe_freeze(&self) {
        let s = &self.inner;
        if s.freezing.swap(true, Ordering::Acquire) {
            return; // a freeze is already in flight
        }
        if s.fill.load(Ordering::Relaxed) < s.freeze_at {
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
        let seg = s
            .seg_live
            .lock()
            .unwrap()
            .last()
            .map_or(0, |a| a.bits() / 8);
        let bloom = s.bloom.as_ref().map_or(0, |b| b.words.len() as u64 * 8);
        mem + seg + bloom
    }

    pub fn summary(&self) -> String {
        let s = &self.inner;
        let (mem_slots, mem_bytes) = s.bufs[0].capacity();
        let frozen = s.frozen_keys.load(Ordering::Relaxed);
        let seg_bits = s.seg_live.lock().unwrap().last().map_or(0, |a| a.bits());
        let bpk = if frozen > 0 {
            seg_bits as f64 / frozen as f64
        } else {
            0.0
        };
        let building = s.building.load(Ordering::Relaxed);
        format!(
            "burr LSM: 2x mem {:.2} GB ({} slots, fill {}), segment {} keys / {:.2} GB ({:.1} b/key), {} freezes{}, fp {}",
            mem_bytes as f64 / 1e9,
            mem_slots,
            s.fill.load(Ordering::Relaxed),
            frozen,
            seg_bits as f64 / 8.0 / 1e9,
            bpk,
            s.freezes.load(Ordering::Relaxed),
            if building > 0 {
                format!(" (rebuilding {building})")
            } else {
                String::new()
            },
            s.fp_bits,
        )
    }
}

impl Shared {
    /// Background: fold the frozen-out buffer `old` into the compacted segment, then
    /// clear it for reuse. Runs on its own thread; the search keeps going on the fresh
    /// active buffer, and `bufs[old]` stays queryable (the `freezing` gate) until its
    /// keys are in the published segment -- so the hot set is never wiped.
    fn freeze_buffer(&self, old: usize) {
        // Phase 1 (single pass, no locks/atomics): partition the buffer's entries by shard.
        // Presize each bucket to the expected per-shard fill so the scan never reallocs.
        let cap = self.freeze_at as usize / self.shards + 64;
        let mut buckets: Vec<Vec<(u64, u64)>> =
            (0..self.shards).map(|_| Vec::with_capacity(cap)).collect();
        self.bufs[old].for_each_entry(|ak, val| {
            buckets[ShardedArchive::shard_of(self.shards, ak)].push((ak, val as u64));
        });
        let added: u64 = buckets.iter().map(|b| b.len() as u64).sum();
        if added > 0 {
            self.building.store(added, Ordering::Relaxed);
            // Phase 2 (parallel, dedicated pool): per shard set the prefilter bits, fold
            // the new keys into the retained set, and rebuild that shard's archive.
            let subs: Vec<Archive> = self.build_pool.install(|| {
                (0..self.shards)
                    .into_par_iter()
                    .map(|sh| {
                        if let Some(bloom) = &self.bloom {
                            for &(ak, _) in &buckets[sh] {
                                bloom.insert(ak);
                            }
                        }
                        let mut g = self.pairs[sh].lock().unwrap();
                        g.extend_from_slice(&buckets[sh]);
                        Archive::build(&g, VAL_BITS, self.fp_bits, self.load)
                    })
                    .collect()
            });
            let total: u64 = self
                .pairs
                .iter()
                .map(|m| m.lock().unwrap().len() as u64)
                .sum();
            // Publish the new segment via the raw pointer; keep it (and the prior one)
            // alive for the grace window, drop anything older.
            let arch = Arc::new(ShardedArchive::from_shards(subs));
            let raw = Arc::as_ptr(&arch) as *mut ShardedArchive;
            {
                let mut live = self.seg_live.lock().unwrap();
                live.push(arch);
                self.seg_ptr.store(raw, Ordering::Release);
                while live.len() > 2 {
                    live.remove(0);
                }
            }
            self.freezes.fetch_add(1, Ordering::Relaxed);
            self.frozen_keys.store(total, Ordering::Relaxed);
            self.building.store(0, Ordering::Relaxed);
        }
        // The segment now answers for these keys; clear the buffer for reuse and let the
        // next freeze proceed. (Clearing is racy with late writes to `old` -- those are
        // simply re-expanded, never wrong.)
        self.bufs[old].clear();
        self.freezing.store(false, Ordering::Release);
    }
}
