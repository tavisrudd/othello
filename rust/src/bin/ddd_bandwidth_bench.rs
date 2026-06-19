// The doc comment below uses an indented list style that clippy flags; the
// indentation is intentional for visual alignment in the module doc.
#![allow(clippy::doc_overindented_list_items)]
//! DDD bandwidth prototype — grounds the grouped-frontier / retrograde-wave napkin
//! math in measured hardware behaviour on THIS box (Ryzen AI 9 HX 370, znver5).
//!
//! The slice analysis (handoff `2026-06-18-iso-window.md`) concluded: popcount slices
//! can't be cache-resident past W8, so the only regime left for the kernel/compression
//! idea is **retrograde DP over popcount waves**, whose claimed win is converting the
//! DFS TT's *random-probe latency* into *sequential-stream bandwidth*. That claim is a
//! hardware ratio napkin math can't settle. This bench measures it directly:
//!
//!   1. seq_read     — pure sequential read BW (the streaming ceiling).
//!   2. seq_copy     — read+write streaming BW (a retrograde wave's read-old/write-new).
//!   3. rand_gather  — INDEPENDENT random reads, the DFS TT regime at saturated MLP
//!                     (handoff: 24 workers already saturate the memory controllers).
//!   4. chase        — DEPENDENT pointer-chase, the single-probe latency floor (~ns/op).
//!   5. radix        — scatter into P partitions: the REAL DDD join primitive (a sort/
//!                     join pass is sequential-read + P-way semi-random write), NOT a
//!                     clean stream. This is the real middle the wave actually lives in.
//!   6. w9_direct    — join-free dense wave: enumerate labelled 9-vertex graph rows,
//!                     compute each child W8 address arithmetically, and pack the result
//!                     bit sequentially. Samples the 2^36-row build and extrapolates it.
//!
//! Then it converts every regime to the decision currency: wall-time to process the
//! n=16 pc=9 slice (~1.08e9 keys; a retrograde wave touches ~20e9 parent->child edges).
//!
//! Build (znver5, faithful — NEVER bare cargo):
//!   RUSTFLAGS="-C target-cpu=znver5 -C link-arg=-fuse-ld=mold" \
//!     cargo build --release --bin ddd_bandwidth_bench
//! Run:  ddd_bandwidth_bench [table_GiB=4] [threads=all] [P=1024]
//!   env BENCH_ONLY=<seq_read|seq_copy|rand_gather|chase|radix|w9_direct>
//!   env W9_SAMPLES=<graphs>  (default 2^24; sampled, then extrapolated to all 2^36)
//!   env BENCH_HUGE=0  (disable MADV_HUGEPAGE on the table; default on)

use std::sync::atomic::{AtomicU64, Ordering};
use std::time::Instant;

// dense.rs is #[path]-included here for W8 lookups. Some items (W9_K, w9_masks,
// W9_MASKS, get9) are used by the lib/queens bin but not this bench.
#[allow(dead_code)]
#[path = "../queens/dense.rs"]
mod dense;

const GIB: usize = 1 << 30;

// ---- raw mmap-backed u64 table (page-aligned => MADV_HUGEPAGE is legal, unlike a Vec) ----
struct Table {
    ptr: *mut u64,
    len: usize,
    bytes: usize,
}
// SAFETY: writes are partitioned via chunks_mut (one &mut, disjoint sub-slices); reads
// hand out shared &[u64]. No overlapping &mut is ever formed across threads.
unsafe impl Send for Table {}
unsafe impl Sync for Table {}

impl Table {
    fn new(len: usize, huge: bool) -> Table {
        let bytes = len * 8;
        // SAFETY: standard anonymous mmap; checked against MAP_FAILED; freed in Drop.
        let ptr = unsafe {
            let p = libc::mmap(
                std::ptr::null_mut(),
                bytes,
                libc::PROT_READ | libc::PROT_WRITE,
                libc::MAP_PRIVATE | libc::MAP_ANONYMOUS,
                -1,
                0,
            );
            assert!(p != libc::MAP_FAILED, "mmap failed for {bytes} bytes");
            if huge {
                libc::madvise(p, bytes, libc::MADV_HUGEPAGE);
            }
            p as *mut u64
        };
        Table { ptr, len, bytes }
    }
    #[inline]
    fn s(&self) -> &[u64] {
        // SAFETY: shared view; only called when no &mut to this table is live.
        unsafe { std::slice::from_raw_parts(self.ptr, self.len) }
    }
    // bench scaffolding: Table owns a raw mmap buffer; sm() hands out one &mut that the
    // caller immediately splits into disjoint chunks via chunks_mut — no aliasing occurs.
    #[allow(clippy::mut_from_ref)]
    #[inline]
    fn sm(&self) -> &mut [u64] {
        // SAFETY: caller forms exactly ONE &mut for the whole buffer, then splits it with
        // chunks_mut into disjoint sub-slices. Only called when nothing else borrows it.
        unsafe { std::slice::from_raw_parts_mut(self.ptr, self.len) }
    }
}
impl Drop for Table {
    fn drop(&mut self) {
        unsafe { libc::munmap(self.ptr as *mut libc::c_void, self.bytes) };
    }
}

#[inline(always)]
fn xs(s: &mut u64) -> u64 {
    let mut x = *s;
    x ^= x << 13;
    x ^= x >> 7;
    x ^= x << 17;
    *s = x;
    x
}

fn gbps(bytes: usize, secs: f64) -> f64 {
    (bytes as f64) / secs / 1e9
}

/// Read-only fan-out: each worker gets a shared slice and (start,end). XOR-reduces returns.
fn par_read<F>(len: usize, threads: usize, f: F) -> u64
where
    F: Fn(usize, usize, usize) -> u64 + Sync,
{
    if threads <= 1 {
        return f(0, 0, len);
    }
    let acc = AtomicU64::new(0);
    let chunk = len.div_ceil(threads);
    std::thread::scope(|sc| {
        for t in 0..threads {
            let start = (t * chunk).min(len);
            let end = (start + chunk).min(len);
            let (acc, f) = (&acc, &f);
            sc.spawn(move || acc.fetch_xor(f(t, start, end), Ordering::Relaxed));
        }
    });
    acc.load(Ordering::Relaxed)
}

/// Write fan-out: ONE &mut split via chunks_mut into disjoint pieces (sound). f(base, chunk).
fn par_write<F>(t: &Table, threads: usize, f: F)
where
    F: Fn(usize, &mut [u64]) + Sync,
{
    let chunk = t.len.div_ceil(threads).max(1);
    let full = t.sm();
    std::thread::scope(|sc| {
        for (ci, c) in full.chunks_mut(chunk).enumerate() {
            let f = &f;
            let base = ci * chunk;
            sc.spawn(move || f(base, c));
        }
    });
}

fn bench_seq_read(a: &Table, threads: usize) -> (f64, u64) {
    let s = a.s();
    let t0 = Instant::now();
    let sink = par_read(a.len, threads, |_, lo, hi| {
        let mut acc = 0u64;
        for &v in &s[lo..hi] {
            acc = acc.wrapping_add(v);
        }
        acc
    });
    let secs = t0.elapsed().as_secs_f64();
    std::hint::black_box(sink); // prevent DCE of the sum loop in the 1-thread path
    (gbps(a.bytes, secs), sink)
}

fn bench_seq_copy(a: &Table, b: &Table, threads: usize) -> f64 {
    let src = a.s();
    let t0 = Instant::now();
    par_write(b, threads, |base, dst| {
        let n = dst.len();
        dst.copy_from_slice(&src[base..base + n]);
    });
    // logical traffic = read BYTES + write BYTES (write also triggers RFO => true DRAM
    // traffic ~3x; we report the logical 2x).
    gbps(2 * a.bytes, t0.elapsed().as_secs_f64())
}

fn bench_rand_gather(a: &Table, threads: usize, ops: usize) -> (f64, f64, u64) {
    let s = a.s();
    let mask = (a.len - 1) as u64; // a.len is power of two
    let per = ops / threads.max(1);
    let t0 = Instant::now();
    let sink = par_read(a.len, threads, |tid, _, _| {
        let mut seed =
            0x9E37_79B9_7F4A_7C15u64 ^ ((tid as u64).wrapping_mul(0xD1B5_4A32_D192_ED03));
        let mut acc = 0u64;
        for _ in 0..per {
            let idx = (xs(&mut seed) & mask) as usize;
            acc = acc.wrapping_add(unsafe { *s.get_unchecked(idx) });
        }
        acc
    });
    let secs = t0.elapsed().as_secs_f64();
    std::hint::black_box(sink); // prevent DCE of the gather in the 1-thread path
    let total = (per * threads) as f64;
    let mops = total / secs / 1e6;
    let line = gbps((per * threads) * 64, secs); // 64B cache line actually fetched/probe
    (mops, line, sink)
}

/// Dependent pointer chase: idx = perm[idx]. Serialized => measures raw access latency.
fn bench_chase(perm: &Table, steps: usize) -> f64 {
    let s = perm.s();
    let mut idx = 0usize;
    let t0 = Instant::now();
    for _ in 0..steps {
        idx = s[idx] as usize;
    }
    let secs = t0.elapsed().as_secs_f64();
    std::hint::black_box(idx);
    secs / steps as f64 * 1e9 // ns/access
}

/// Radix partition: sequential read of `a`, scatter each element into one of P
/// thread-local output streams keyed by high bits. Models a sort/join pass — the real
/// DDD primitive. Each thread is independent (own input slice + own P buffers).
fn bench_radix(a: &Table, threads: usize, p: usize) -> f64 {
    let s = a.s();
    let shift = 64 - (p.trailing_zeros() as usize); // top log2(P) bits select partition
    let t0 = Instant::now();
    let sink = par_read(a.len, threads, |_, lo, hi| {
        let n = hi - lo;
        let cap = (n / p) * 3 / 2 + 16; // uniform keys => ~n/P each, +50% slack
        let mut bufs: Vec<Vec<u64>> = (0..p).map(|_| Vec::with_capacity(cap)).collect();
        for &v in &s[lo..hi] {
            let part = (v >> shift) as usize & (p - 1);
            bufs[part].push(v);
        }
        let mut acc = 0u64; // consume so scatter isn't DCE'd
        for b in &bufs {
            if let Some(&last) = b.last() {
                acc ^= last ^ (b.len() as u64);
            }
        }
        acc
    });
    std::hint::black_box(sink);
    gbps(2 * a.bytes, t0.elapsed().as_secs_f64()) // read + write
}

const W9_VERTS: usize = 9;
const W9_EDGES: usize = W9_VERTS * (W9_VERTS - 1) / 2;
const W9_ROWS: u64 = 1u64 << W9_EDGES;

#[inline(always)]
fn w9_adj(code: u64) -> [u16; W9_VERTS] {
    let mut adj = [0u16; W9_VERTS];
    let mut bit = 0usize;
    for i in 0..W9_VERTS {
        for j in (i + 1)..W9_VERTS {
            let edge = ((code >> bit) & 1) as u16;
            adj[i] |= edge << j;
            adj[j] |= edge << i;
            bit += 1;
        }
    }
    adj
}

#[inline(always)]
fn project9(adj: &[u16; W9_VERTS], alive: u16) -> (usize, usize) {
    let mut verts = [0usize; W9_VERTS];
    let mut n = 0usize;
    let mut rem = alive;
    while rem != 0 {
        let v = rem.trailing_zeros() as usize;
        rem &= rem - 1;
        verts[n] = v;
        n += 1;
    }
    let mut code = 0usize;
    let mut bit = 0usize;
    for x in 0..n {
        for y in (x + 1)..n {
            code |= (((adj[verts[x]] >> verts[y]) & 1) as usize) << bit;
            bit += 1;
        }
    }
    (n, code)
}

#[inline(always)]
fn w9_wins(code: u64, w8: &dense::DenseW8) -> bool {
    let adj = w9_adj(code);
    let full = (1u16 << W9_VERTS) - 1;
    for i in 0..W9_VERTS {
        let child = full & !((1u16 << i) | adj[i]);
        let (k, child_code) = project9(&adj, child);
        if !w8.get(k, child_code) {
            return true;
        }
    }
    false
}

const fn w9_masks() -> ([u64; W9_VERTS], [u64; 1 << W9_VERTS]) {
    let mut incident = [0u64; W9_VERTS];
    let mut induced = [0u64; 1 << W9_VERTS];
    let mut bit = 0usize;
    let mut i = 0usize;
    while i < W9_VERTS {
        let mut j = i + 1;
        while j < W9_VERTS {
            let edge = 1u64 << bit;
            incident[i] |= edge;
            incident[j] |= edge;
            let mut alive = 0usize;
            while alive < (1 << W9_VERTS) {
                if (alive & (1 << i)) != 0 && (alive & (1 << j)) != 0 {
                    induced[alive] |= edge;
                }
                alive += 1;
            }
            bit += 1;
            j += 1;
        }
        i += 1;
    }
    (incident, induced)
}

const W9_MASKS: ([u64; W9_VERTS], [u64; 1 << W9_VERTS]) = w9_masks();

#[inline(always)]
fn w9_wins_pext(code: u64, w8: &dense::DenseW8) -> bool {
    use std::arch::x86_64::_pext_u64;

    let mut adj = [0u16; W9_VERTS];
    for (i, row) in adj.iter_mut().enumerate() {
        // Incident edge bits are extracted in the global (a,b) edge order, which
        // is neighbour order for a fixed vertex. Insert the missing self bit.
        let packed = unsafe { _pext_u64(code, W9_MASKS.0[i]) } as u16;
        let below = (1u16 << i) - 1;
        *row = (packed & below) | ((packed & !below) << 1);
    }
    let full = (1u16 << W9_VERTS) - 1;
    // i is used both arithmetically (1u16 << i) and as an index into adj, so an
    // iterator over adj alone would lose i — the range loop is intentional.
    #[allow(clippy::needless_range_loop)]
    for i in 0..W9_VERTS {
        let child = full & !((1u16 << i) | adj[i]);
        let child_code = unsafe { _pext_u64(code, W9_MASKS.1[child as usize]) } as usize;
        if !w8.get(child.count_ones() as usize, child_code) {
            return true;
        }
    }
    false
}

/// Sample a complete W9 construction without materialising its 8 GiB output. Each
/// worker visits short sequential row runs from stratified locations in the 36-bit
/// universe; that preserves the locality available to a real direct-address build
/// without biasing the sample toward sparse low edge codes.
fn bench_w9_direct<const PEXT: bool>(threads: usize, samples: usize) -> (f64, f64, f64, u64) {
    const RUN: usize = 4096;
    let build0 = Instant::now();
    let w8 = dense::DenseW8::build();
    let w8_secs = build0.elapsed().as_secs_f64();
    if PEXT {
        for code in (0..10_000u64).map(|x| x.wrapping_mul(0x9E37_79B9) & (W9_ROWS - 1)) {
            assert_eq!(w9_wins(code, &w8), w9_wins_pext(code, &w8));
        }
    }
    let sink = AtomicU64::new(0);
    let chunk = samples.div_ceil(threads.max(1));
    let t0 = Instant::now();
    std::thread::scope(|sc| {
        for tid in 0..threads.max(1) {
            let lo = tid * chunk;
            let hi = (lo + chunk).min(samples);
            let sink = &sink;
            let w8 = &w8;
            sc.spawn(move || {
                let mut packed = 0u64;
                let mut at = lo;
                while at < hi {
                    let block = at / RUN;
                    let offset = at % RUN;
                    let mut seed = block as u64 ^ 0xD1B5_4A32_D192_ED03;
                    let base = (xs(&mut seed) % (W9_ROWS / RUN as u64)) * RUN as u64;
                    let take = (RUN - offset).min(hi - at);
                    for j in 0..take {
                        let code = base + (offset + j) as u64;
                        let won = if PEXT {
                            w9_wins_pext(code, w8)
                        } else {
                            w9_wins(code, w8)
                        };
                        packed = packed.rotate_left(1) ^ (won as u64);
                    }
                    at += take;
                }
                sink.fetch_xor(packed, Ordering::Relaxed);
            });
        }
    });
    let secs = t0.elapsed().as_secs_f64();
    let mgraphs = samples as f64 / secs / 1e6;
    let full_secs = W9_ROWS as f64 / (mgraphs * 1e6);
    (w8_secs, mgraphs, full_secs, sink.load(Ordering::Relaxed))
}

fn main() {
    let args: Vec<String> = std::env::args().collect();
    let table_gib: usize = args.get(1).and_then(|s| s.parse().ok()).unwrap_or(4);
    let threads: usize = args.get(2).and_then(|s| s.parse().ok()).unwrap_or_else(|| {
        std::thread::available_parallelism()
            .map(|n| n.get())
            .unwrap_or(8)
    });
    let p: usize = args.get(3).and_then(|s| s.parse().ok()).unwrap_or(1024);
    assert!(p.is_power_of_two(), "P must be power of two");
    assert!(
        table_gib.is_power_of_two(),
        "table_GiB must be power of two (pow2 mask)"
    );
    let only = std::env::var("BENCH_ONLY").ok();
    let huge = std::env::var("BENCH_HUGE")
        .map(|v| v != "0")
        .unwrap_or(true);

    let n = table_gib * GIB / 8; // u64 elements, power of two
    let ops = 2 * n; // ~ pc=9 slice probe count when table=4 GiB (n=536M -> ops=1.07e9)

    let run = |name: &str| only.as_deref().map(|o| o == name).unwrap_or(true);

    if run("w9_direct") {
        let samples = std::env::var("W9_SAMPLES")
            .ok()
            .and_then(|v| v.parse().ok())
            .unwrap_or(1usize << 24);
        assert!(samples > 0, "W9_SAMPLES must be positive");
        let (build_secs, mgraphs, full_secs, sink) = bench_w9_direct::<false>(threads, samples);
        let (_, pext_mgraphs, pext_full_secs, pext_sink) =
            bench_w9_direct::<true>(threads, samples);
        println!("\n=== join-free direct-address W9 wave ===");
        println!(
            "  W8 base          : {:>7.2} s   ({:.1} MiB)",
            build_secs,
            dense::DenseW8::build().bytes() as f64 / (1 << 20) as f64
        );
        println!("  sampled rows     : {samples:>12}   ({mgraphs:.2} Mgraph/s)");
        println!("  sampled pext     : {samples:>12}   ({pext_mgraphs:.2} Mgraph/s)");
        println!(
            "  full W9 estimate : {:>7.1} s   (2^36 rows, 8.0 GiB packed output)",
            full_secs
        );
        println!("  full W9 pext est : {:>7.1} s", pext_full_secs);
        std::hint::black_box(sink);
        std::hint::black_box(pext_sink);
        if only.as_deref() == Some("w9_direct") {
            return;
        }
    }

    eprintln!(
        "config: table={table_gib} GiB ({n} u64), threads={threads}, P={p}, huge={huge}, ops={ops}"
    );

    let a = Table::new(n, huge);
    {
        let t0 = Instant::now();
        par_write(&a, threads, |base, c| {
            for (k, slot) in c.iter_mut().enumerate() {
                *slot = ((base + k) as u64).wrapping_mul(0x9E37_79B9_7F4A_7C15);
            }
        });
        eprintln!("faulted table in {:.2}s", t0.elapsed().as_secs_f64());
    }

    println!(
        "\n{:<12} {:>4} {:>10} {:>12} {:>12}",
        "regime", "thr", "GB/s", "Mops/s", "ns/op"
    );
    println!("{}", "-".repeat(54));

    let (mut g_seq_copy, mut g_rand_mops, mut g_rand_line, mut g_radix) = (0.0, 0.0, 0.0, 0.0);
    let thr_set: &[usize] = if threads == 1 { &[1] } else { &[1, threads] };

    for &thr in thr_set {
        if run("seq_read") {
            let (gb, _) = bench_seq_read(&a, thr);
            println!(
                "{:<12} {:>4} {:>10.1} {:>12} {:>12}",
                "seq_read", thr, gb, "-", "-"
            );
        }
        if run("rand_gather") {
            let (mops, line, _) = bench_rand_gather(&a, thr, ops);
            println!(
                "{:<12} {:>4} {:>10.1} {:>12.1} {:>12.2}",
                "rand_gather",
                thr,
                line,
                mops,
                1e3 / mops
            );
            if thr == threads {
                (g_rand_mops, g_rand_line) = (mops, line);
            }
        }
        if run("radix") && thr == threads {
            // sweep partition fan-out: small P = cheap/pass but more passes; large P =
            // fewer passes but TLB/cache thrash on the write side. Best P steelmans DDD.
            for &pp in &[64usize, 256, 1024, 4096] {
                let gb = bench_radix(&a, thr, pp);
                let lbl = format!("radix P={pp}");
                println!(
                    "{:<12} {:>4} {:>10.1} {:>12} {:>12}",
                    lbl, thr, gb, "-", "-"
                );
                if gb > g_radix {
                    g_radix = gb;
                }
            }
        }
    }

    if run("seq_copy") {
        let b = Table::new(n, huge);
        par_write(&b, threads, |_, c| c.fill(0));
        for &thr in thr_set {
            let gb = bench_seq_copy(&a, &b, thr);
            println!(
                "{:<12} {:>4} {:>10.1} {:>12} {:>12}",
                "seq_copy", thr, gb, "-", "-"
            );
            if thr == threads {
                g_seq_copy = gb;
            }
        }
    }

    if run("chase") {
        let pn = (GIB / 8).min(n); // 1 GiB perm; latency is size-insensitive past LLC
        let perm = Table::new(pn, huge);
        {
            let m = perm.sm(); // single-threaded init: one &mut, no aliasing
            for (i, slot) in m.iter_mut().enumerate() {
                *slot = i as u64;
            }
            let mut seed = 0x1234_5678_9ABC_DEF0u64;
            for i in (1..pn).rev() {
                let j = (xs(&mut seed) % (i as u64 + 1)) as usize;
                m.swap(i, j);
            }
        }
        let steps = 50_000_000usize.min(pn * 4);
        let ns = bench_chase(&perm, steps);
        println!(
            "{:<12} {:>4} {:>10} {:>12} {:>12.2}",
            "chase", 1, "-", "-", ns
        );
    }

    if only.is_none() {
        const PC9_KEYS: f64 = 1.08e9; // 21.6% of ~5e9 working set
        const EDGES: f64 = 20.0e9; // ~ pc=9 keys * ~18 child probes (retrograde wave)
        const B_EDGE: f64 = 16.0; // (key, parent-ref) per edge
        println!("\n=== implied wall-time for the n=16 pc=9 slice ===");
        println!(
            "  (pc=9 ~{:.2e} keys; retrograde wave ~{:.0e} parent->child edges)",
            PC9_KEYS, EDGES
        );
        if g_rand_mops > 0.0 {
            let dfs = EDGES / (g_rand_mops * 1e6);
            println!(
                "  DFS random-probe  : {:>7.2} s   ({:.0} Mprobe/s, {:.1} GB/s line)",
                dfs, g_rand_mops, g_rand_line
            );
        }
        if g_radix > 0.0 {
            for passes in [2.0f64, 4.0] {
                let secs = passes * (EDGES * B_EDGE * 2.0) / (g_radix * 1e9);
                println!(
                    "  DDD radix x{:.0} pass : {:>7.2} s   ({:.1} GB/s scatter)",
                    passes, secs, g_radix
                );
            }
        }
        if g_seq_copy > 0.0 {
            let secs = (EDGES * B_EDGE * 2.0) / (g_seq_copy * 1e9);
            println!(
                "  DDD ideal stream  : {:>7.2} s   ({:.1} GB/s, 1 seq pass — optimistic floor)",
                secs, g_seq_copy
            );
        }
        println!(
            "\nverdict input: DDD wins iff (radix passes x scatter BW) beats the random-probe"
        );
        println!("wall AND the no-DFS-cutoff penalty (evaluate all reachable, not just visited)");
        println!("doesn't eat it.");
    }
}
