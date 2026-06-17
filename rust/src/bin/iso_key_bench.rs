//! Instruction-level cyc/key regression bench for the graph-isomorphism (iso) keys
//! (`src/queens/graph.rs`) -- the headline lever for the burr-iso capacity win
//! (`notes/handoffs/2026-06-16-burr-live-implementation.md`, lever 0). The 3.42×
//! iso-merge fits the n=16 working set in RAM (re-exp → ~1.0×), but live iso-keying
//! is ~19% net-slower than the D4 incremental key at n=14: the per-node graph-key
//! cost ≈ cancels the merge. Close that gap and burr-iso wins outright. This is the
//! `canon_bench` analog for the iso key: drive its cyc/key down with the bench as the
//! gate, the way the D4 canon went 574 → 62 cyc.
//!
//! Unlike `canon_bench` (which replicates geometry to test *replacement* kernels
//! against an independent ground truth), the thing under test here IS the library
//! code, so the bench calls straight into the real `Queens::iso_key_*` over a realistic
//! corpus from `Queens::iso_corpus` (a deep DFS deduped on the D4 canon, exactly the
//! live search's TT key). Keys measured:
//!
//! * **fast** — `iso_key_fast`: the allocation-free production-candidate live key
//!   (component-decompose, `tiny_comp_key` for k≤4, cached WL+cert for k>4).
//! * **fast_nc** — `iso_key_fast_nocache`: same, component cache bypassed. The live
//!   n=16 search thrashes the cache, so this recompute cost is the live-representative
//!   per-key number and the gate the optimisation drives down (a cache-warmed `reps`
//!   loop hits on every repeat and hides every `comp_canon_full` change).
//! * **ir** — `iso_key_ir`: 1-WL + individualisation invariant (the freeze-safe key).
//! * **canon** — `iso_key_canon`: the exact individualisation-refinement canon (slow;
//!   the gate's ground truth for the merge partition).
//! * **components** — `iso_key_components`: the allocating per-component baseline.
//!
//! Gate (printed before timing is meaningful): over a strided sample, `iso_key_fast`
//! must induce the **same partition** as the exact `iso_key_canon` (bijection between
//! the two key sets) — a broken optimisation that over-merges or over-splits fails it.
//! The merge factor (D4 classes ÷ iso classes) is reported over the full corpus.
//!
//! Build via `make release` (znver5 + mold). cyc/key authoritative under perf:
//!   taskset -c 0-3 perf stat -e cycles target/release/iso_key_bench 16 2000000 8 perf:fast
//!   (divide the cycle count by the printed `keys`; subtract perf:empty for loop overhead)
//! Wall-clock cross-check + the full table: `target/release/iso_key_bench [n] [cap] [reps]`.

use othello::queens::{Bits, Queens};
use std::alloc::{GlobalAlloc, Layout, System};
use std::hint::black_box;
use std::sync::atomic::{AtomicUsize, Ordering};
use std::time::Instant;

// Counting allocator: proves the live key path does ZERO heap allocation per call
// (the user's "no allocs when building keys" gate). The per-thread IsoScratch +
// component cache allocate ONCE lazily on first use; every key after that must be
// alloc-free. We snapshot the counters after a warm-up call, then audit a measured
// run. Relaxed counters off the hot path -- this is a measurement bin.
static ALLOCS: AtomicUsize = AtomicUsize::new(0);
static ALLOC_BYTES: AtomicUsize = AtomicUsize::new(0);

struct Counting;
unsafe impl GlobalAlloc for Counting {
    unsafe fn alloc(&self, l: Layout) -> *mut u8 {
        ALLOCS.fetch_add(1, Ordering::Relaxed);
        ALLOC_BYTES.fetch_add(l.size(), Ordering::Relaxed);
        System.alloc(l)
    }
    unsafe fn dealloc(&self, p: *mut u8, l: Layout) {
        System.dealloc(p, l)
    }
    unsafe fn realloc(&self, p: *mut u8, l: Layout, new: usize) -> *mut u8 {
        ALLOCS.fetch_add(1, Ordering::Relaxed);
        ALLOC_BYTES.fetch_add(new, Ordering::Relaxed);
        System.realloc(p, l, new)
    }
}

#[global_allocator]
static GLOBAL: Counting = Counting;

/// Distinct-value count of a key stream (sort + dedup).
fn distinct_count(xs: impl Iterator<Item = u64>) -> usize {
    let mut v: Vec<u64> = xs.collect();
    v.sort_unstable();
    v.dedup();
    v.len()
}

/// Distinct-pair count (for the partition-bijection gate).
fn distinct_pairs(xs: impl Iterator<Item = (u64, u64)>) -> usize {
    let mut v: Vec<(u64, u64)> = xs.collect();
    v.sort_unstable();
    v.dedup();
    v.len()
}

/// Time `keyfn` over the corpus, `reps` passes, black_box the accumulator and input.
fn time_keys(corpus: &[Bits], reps: usize, keyfn: impl Fn(Bits) -> u64) -> (u128, u64) {
    let t = Instant::now();
    let mut acc: u64 = 0;
    for _ in 0..reps {
        for &m in corpus {
            acc = acc.wrapping_add(keyfn(black_box(m)));
        }
    }
    black_box(acc);
    (t.elapsed().as_nanos(), acc)
}

fn main() {
    let args: Vec<String> = std::env::args().collect();
    // Usage: iso_key_bench [n] [cap] [reps] [mode]
    //   n    = board side (default 16 — the target layout)
    //   cap  = max corpus masks / D4-distinct positions (default 2_000_000)
    //   reps = timing passes over corpus (default 8)
    //   mode = "bench" (default, full table) | "verify" (gate only)
    //          | "perf:fast" | "perf:ir" | "perf:canon" | "perf:components"
    //          | "perf:empty" (loop+black_box overhead, subtract from each impl)
    //          | "perf:build" (corpus build only — the cycle floor to subtract)
    let n: u32 = args.get(1).and_then(|s| s.parse().ok()).unwrap_or(16);
    let cap: usize = args
        .get(2)
        .and_then(|s| s.parse().ok())
        .unwrap_or(2_000_000);
    let reps: usize = args.get(3).and_then(|s| s.parse().ok()).unwrap_or(8);
    let mode = args.get(4).map(String::as_str).unwrap_or("bench");

    eprintln!("building corpus (n={n}, cap={cap}) ...");
    let q = Queens::new(n);
    let corpus = q.iso_corpus(cap);
    let popsum: u64 = corpus.iter().map(|m| m.popcount() as u64).sum();
    eprintln!(
        "corpus: {} distinct D4 positions (raw available masks), mean popcount {:.2}",
        corpus.len(),
        popsum as f64 / corpus.len().max(1) as f64
    );
    // Popcount histogram (deep-heavy shape sanity).
    let mut hist = vec![0u64; (n * n + 1) as usize];
    for m in &corpus {
        hist[m.popcount() as usize] += 1;
    }
    eprint!("popcount buckets: ");
    for (p, &c) in hist.iter().enumerate() {
        if c > 0 {
            eprint!("{p}:{c} ");
        }
    }
    eprintln!();

    // --- cost-by-graph-size: bucket masks by available popcount and time the key per
    // bucket. Shows whether the cost blows up on big (shallow) graphs -- the case for
    // selective keying (iso-key only small graphs, D4 the rest). ---
    if mode == "buckets" {
        // Bucket bounds on available popcount (capped at 48 -- beyond that a single key
        // is catastrophic, seconds+, which is itself the finding: see the note below).
        let bounds = [4u32, 8, 12, 16, 20, 24, 32, 48];
        println!("\n=== iso_key_fast_nocache cost by available popcount ===");
        println!(
            "{:<12} {:>10} {:>14} {:>14}",
            "popcount", "masks", "ns/key", "rel-to-<=4"
        );
        let mut base = 0f64;
        let mut lo = 0u32;
        for &hi in &bounds {
            let bucket: Vec<Bits> = corpus
                .iter()
                .copied()
                .filter(|m| {
                    let p = m.popcount();
                    p > lo && p <= hi
                })
                .collect();
            if !bucket.is_empty() {
                // Time-boxed, checking the clock after EVERY call so one expensive key
                // cannot stall the bucket -- auto-adapts to per-key cost (cheap small
                // graphs need millions of calls; big graphs a handful).
                let t = Instant::now();
                let mut calls = 0u64;
                let mut acc = 0u64;
                'b: loop {
                    for &m in &bucket {
                        acc = acc.wrapping_add(q.iso_key_fast_nocache(black_box(m)));
                        calls += 1;
                        if t.elapsed().as_millis() >= 50 {
                            break 'b;
                        }
                    }
                }
                black_box(acc);
                let per = t.elapsed().as_nanos() as f64 / calls as f64;
                if lo == 0 {
                    base = per;
                }
                println!(
                    "{:<12} {:>10} {:>14.1} {:>13.1}x",
                    format!("{}-{}", lo + 1, hi),
                    bucket.len(),
                    per,
                    per / base.max(1.0)
                );
            }
            lo = hi;
        }
        // A near-root mask (largest popcount <= 64, to stay bounded): one key, wall-timed,
        // to show the catastrophic tail the live search pays on shallow nodes. The true
        // root (popcount 256) is worse still -- not timed here (it can run seconds+).
        if let Some(big) = corpus
            .iter()
            .copied()
            .filter(|m| m.popcount() <= 64)
            .max_by_key(|m| m.popcount())
        {
            let t = Instant::now();
            black_box(q.iso_key_fast_nocache(big));
            println!(
                "\nlargest mask popcount {} : {:.1} µs for ONE key (the shallow-node tail; root@256 is worse)",
                big.popcount(),
                t.elapsed().as_nanos() as f64 / 1000.0
            );
        }
        return;
    }

    // --- perf-stat single-impl modes: just run the timed loop, nothing else. ---
    let keys = corpus.len() * reps;
    match mode {
        "perf:build" => {
            // Build only (black_box so it isn't elided): subtract from each impl.
            black_box(&corpus);
            eprintln!("build-only (subtract this cycle count) keys=0");
            return;
        }
        "perf:empty" => {
            let (_, acc) = time_keys(&corpus, reps, |m| m.popcount() as u64);
            eprintln!("empty acc={acc} keys={keys}");
            return;
        }
        "perf:fast" => {
            let (_, acc) = time_keys(&corpus, reps, |m| q.iso_key_fast(m));
            eprintln!("fast acc={acc} keys={keys}");
            return;
        }
        "perf:fast_nc" => {
            // Cache bypassed: the live-representative per-key cost (the optimisation gate).
            let (_, acc) = time_keys(&corpus, reps, |m| q.iso_key_fast_nocache(m));
            eprintln!("fast_nc acc={acc} keys={keys}");
            return;
        }
        "perf:ir" => {
            let (_, acc) = time_keys(&corpus, reps, |m| q.iso_key_ir(m));
            eprintln!("ir acc={acc} keys={keys}");
            return;
        }
        "perf:canon" => {
            let (_, acc) = time_keys(&corpus, reps, |m| q.iso_key_canon(m));
            eprintln!("canon acc={acc} keys={keys}");
            return;
        }
        "perf:components" => {
            let (_, acc) = time_keys(&corpus, reps, |m| q.iso_key_components(m));
            eprintln!("components acc={acc} keys={keys}");
            return;
        }
        _ => {}
    }

    // --- correctness gate: iso_key_fast must induce the SAME partition as the exact
    // iso_key_canon over a strided sample (canon is slow, so don't run it over the
    // full corpus). A bijection between the two key sets ⇒ fast over/under-merges
    // nothing relative to the ground-truth graph-iso classes. ---
    println!("\n=== CORRECTNESS GATE (iso_key_fast partition == iso_key_canon partition) ===");
    let sample_cap = corpus.len().min(100_000);
    let stride = (corpus.len() / sample_cap.max(1)).max(1);
    let sample: Vec<Bits> = corpus.iter().copied().step_by(stride).collect();
    let pairs: Vec<(u64, u64)> = sample
        .iter()
        .map(|&m| (q.iso_key_canon(m), q.iso_key_fast(m)))
        .collect();
    let d_canon = distinct_count(pairs.iter().map(|&(c, _)| c));
    let d_fast = distinct_count(pairs.iter().map(|&(_, f)| f));
    let d_pairs = distinct_pairs(pairs.iter().copied());
    let bijection = d_fast == d_canon && d_pairs == d_canon;
    println!(
        "sample {:>8}: canon classes = {:>8}   fast classes = {:>8}   pairs = {:>8}   bijection = {}",
        sample.len(),
        d_canon,
        d_fast,
        d_pairs,
        bijection
    );

    // Merge factor over the FULL corpus (D4 classes ÷ iso classes): the capacity win
    // burr-iso banks. Uses only iso_key_fast (cheap), the gated-correct live key.
    let iso_classes = distinct_count(corpus.iter().map(|&m| q.iso_key_fast(m)));
    println!(
        "merge factor (full corpus): {} D4 classes / {} iso classes = {:.3}×",
        corpus.len(),
        iso_classes,
        corpus.len() as f64 / iso_classes.max(1) as f64
    );

    if !bijection {
        println!("\niso_key_fast is NOT the same partition as iso_key_canon — timing is meaningless. Fix the key.");
        return;
    }

    // --- alloc audit: the live key must do ZERO heap allocation per call. Warm the
    // thread-local scratch/cache with one call, then count allocs over a measured run.
    black_box(q.iso_key_fast(corpus[0]));
    black_box(q.iso_key_fast_nocache(corpus[0]));
    let audit_n = corpus.len().min(200_000);
    let a0 = ALLOCS.load(Ordering::Relaxed);
    let b0 = ALLOC_BYTES.load(Ordering::Relaxed);
    let mut acc = 0u64;
    for &m in &corpus[..audit_n] {
        acc = acc.wrapping_add(q.iso_key_fast(black_box(m)));
        acc = acc.wrapping_add(q.iso_key_fast_nocache(black_box(m)));
    }
    black_box(acc);
    let da = ALLOCS.load(Ordering::Relaxed) - a0;
    let db = ALLOC_BYTES.load(Ordering::Relaxed) - b0;
    println!("\n=== ALLOC AUDIT (iso_key_fast + nocache, {audit_n} masks each, post-warmup) ===");
    println!(
        "allocations = {da}   bytes = {db}   {}",
        if da == 0 {
            "✓ zero-alloc key path"
        } else {
            "✗ ALLOCATES — fix it"
        }
    );

    // --- component-size distribution: where the WL cost concentrates. k<=4 take the
    // cheap tiny_comp_key; k>=5 pay full WL refinement (comp_canon_full). ---
    let mut chist = vec![0u64; (n * n + 1) as usize];
    for &m in &corpus {
        q.tally_components(m, &mut chist);
    }
    let total_comps: u64 = chist.iter().sum();
    let tiny: u64 = chist[..=4.min(chist.len() - 1)].iter().sum();
    println!("\n=== COMPONENT SIZES over corpus (k = component vertex count) ===");
    print!("k:count  ");
    for (k, &c) in chist.iter().enumerate() {
        if c > 0 && k <= 20 {
            print!("{k}:{c} ");
        }
    }
    println!(
        "\ntiny (k<=4, tiny_comp_key) = {:.1}%   WL (k>=5, comp_canon_full) = {:.1}% of {} comps",
        100.0 * tiny as f64 / total_comps.max(1) as f64,
        100.0 * (total_comps - tiny) as f64 / total_comps.max(1) as f64,
        total_comps
    );

    if mode == "verify" {
        println!("\nverify mode: gate done, skipping timing.");
        return;
    }

    // --- timing (wall-clock ns/key; perf stat gives the authoritative cyc/key) ---
    println!("\n=== TIMING ({} masks × {} reps) ===", corpus.len(), reps);
    let n_key = (corpus.len() * reps) as f64;
    let (ns_fast, _) = time_keys(&corpus, reps, |m| q.iso_key_fast(m));
    let (ns_fast_nc, _) = time_keys(&corpus, reps, |m| q.iso_key_fast_nocache(m));
    let (ns_ir, _) = time_keys(&corpus, reps, |m| q.iso_key_ir(m));
    let (ns_comp, _) = time_keys(&corpus, reps, |m| q.iso_key_components(m));
    // canon is the slow ground truth — time it over the sample only, scaled per-key.
    let (ns_canon_s, _) = time_keys(&sample, reps, |m| q.iso_key_canon(m));
    let canon_per = ns_canon_s as f64 / (sample.len() * reps) as f64;

    let per = |ns: u128| ns as f64 / n_key;
    println!("{:<12} {:>12} {:>12}", "impl", "ns/key", "rel-fast");
    let fast_ns = per(ns_fast);
    println!("{:<12} {:>12.2} {:>11.2}x", "fast", fast_ns, 1.0);
    println!(
        "{:<12} {:>12.2} {:>11.2}x  (cache off — live regime)",
        "fast_nc",
        per(ns_fast_nc),
        per(ns_fast_nc) / fast_ns
    );
    println!(
        "{:<12} {:>12.2} {:>11.2}x",
        "ir",
        per(ns_ir),
        per(ns_ir) / fast_ns
    );
    println!(
        "{:<12} {:>12.2} {:>11.2}x",
        "components",
        per(ns_comp),
        per(ns_comp) / fast_ns
    );
    println!(
        "{:<12} {:>12.2} {:>11.2}x  (sampled)",
        "canon",
        canon_per,
        canon_per / fast_ns
    );
    println!(
        "\n(ns/key is a cross-check. For cyc/key run under `perf stat -e cycles` with mode\n \
         perf:fast | perf:fast_nc | perf:ir | perf:canon | perf:components, then divide\n \
         cycles by the printed `keys` ({keys}); subtract perf:empty (build+loop overhead).\n \
         fast_nc (cache off) is the live-regime cost the optimisation must drive down.)"
    );
}
