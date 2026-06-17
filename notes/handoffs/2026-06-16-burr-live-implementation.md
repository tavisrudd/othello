# Burr-live (Chunk 4) — BuRR-as-primary LSM store: implementation session

**Date**: 2026-06-16
**Mode**: intent-based (`mi`) — user authorized architectural calls; "keep working until
faster-than-incremental + >7.5 M/s n=16, then ratchet 8–9 → 12 M/s, profiling constraints."
**References**: [proposal](../proposal-2026-06-16-burr-live-cascade.md) (the design fork);
[memory roadmap](2026-06-15-queens-memory-roadmap.md); [inner-loop handoff](2026-06-16-queens-inner-loop-rewrite.md)
(the `incremental` kernel this reuses). Code: `rust/src/queens/store.rs` (the store),
`rust/src/queens/solver/burr.rs` (the solver), `rust/src/burr.rs` (the BuRR archive).

## What landed (commits `8edc10a`, `05debb5`)

A new **`burr` solver** = `incremental`'s A3 node kernel (8 dihedral orientations, `lex_min8`
≡ `pos_key`) over a **log-structured BuRR store** (`BurrStore`) that replaces the flat evicting
`QueensTt`. Decision (user): aim straight for BuRR, **live** (not just freeze/archive), and
**bypass the `cascade` multi-tier design** — the store *is* the table.

**The store, and the lever behind each piece (each a measured cost center, in order found):**
1. **Two fixed hugepage memtables + an atomic epoch index** (`bufs: [QueensTt;2]`, `active:
   AtomicU8`). Freeze = flip `active` to the other (pre-cleared) buffer, no stall; the old buffer
   stays queryable during its background build, so the hot set is never wiped. *Replaced an
   `ArcSwap` double-buffer that profiled at ~15% of cycles* — the epoch load is one relaxed read.
2. **A cache-line-blocked Bloom prefilter** (hugepage-backed, `QUEENS_BURR_BLOOM_GB`, default 1).
   Every expanded node's `get` misses; the Bloom rejects a genuine miss in one cache-line read,
   so a miss is O(1) instead of O(segments). `prefetch()` also warms the Bloom line.
3. **A single compacted segment (K=1)** — `ShardedArchive`, rebuilt each freeze from retained
   per-shard `(archive_key,val)` pairs, on a **dedicated build pool** (`QUEENS_BURR_BUILD_THREADS`,
   default 8) off the search's rayon workers. A transposition hit is one sharded probe regardless
   of run length. Read on the hot path via a raw `AtomicPtr` + keep-last-2 grace ring (relaxed
   load, not the `ArcSwap` hazard dance, which re-profiled at ~14% when it was the segment).
4. **`hash128` deduped**: `get` hashed the key twice on a miss (memtable probe + archive key) —
   now once via `QueensTt::{get,put,archive_key,prefetch}_hashed`.

**Correct by construction:** a position's archive identity `(slot_index, fingerprint)` is a
deterministic function of its canonical key + the fixed memtable `len`, so a freeze never changes
identity; the store returns **the right value or `None`** (a tier miss just re-expands), the only
wrong-value source being a bounded archive FP. So even a racy freeze costs re-expansion, never a
wrong answer — which is why no stop-the-world barrier is needed.

**Gates (all green):** `solver_lineage_agrees` (n≤9); `solve 12 burr --distinct` second / **1,060,823
exact** / 1.01×; `solve 14` second / ~49.3M; a **forced-freeze LSM stress test**
(`burr_lsm_survives_frequent_freezes`, tiny threshold → thousands of freeze→compact→clear cycles,
verdict holds). `make clippy`/`fmt` clean.

## Measurements (n=16 short runs, `QUEENS_BENCH_SECS`)

**Heavy thermal caveat:** this box throttles ~2× under a sustained benching marathon — a
thermal-fair interleaved A/B late in the session showed *incremental itself* at 6–7 M/s (vs its
cold ~14). So absolute numbers below are cold-box unless noted; trust **ratios from interleaved
A/B**, not isolated runs (CLAUDE.md).

- **Pre-freeze phase ≈ 12–13 M/s cold** (active memtable only, ≈ `incremental`'s rate — the store
  wrapper overhead is small once ArcSwap is gone).
- **Segment phase ≈ 8–9 M/s cold** (mem_bits=28): the drag is the per-miss Bloom access + the
  ribbon probe on frozen-hits.
- **Freeze is fast + off-core**: a 136M-key freeze builds in a few s on the dedicated pool; the
  earlier 70s freezes were a single-threaded partition (per-entry mutex + 8 atomics) — fixed to a
  single-pass shard partition + parallel build.
- **Reserving cores (`RAYON_NUM_THREADS=16`+8 build) is WORSE** (7.2 vs 8.3): the search is
  memory-latency-bound and wants all 24 cores; the brief freeze oversubscription beats permanently
  surrendering 8 search cores. So "freeze off-core" = the dedicated build pool (already off the
  search's rayon pool), **not** core reservation.

## The reframe that matters for "12 M/s" and "beat incremental"

**Burr's throughput is intrinsically ≤ `incremental`'s peak** — it adds per-node work (Bloom +
archive-key + segment probe) on top of the memtable probe. Its pre-segment ceiling (~12–13 cold)
≈ incremental; the segment phase can only approach, not exceed it. So **raw M/s is the wrong
yardstick for burr's value** — burr wins on **wall-clock at full-n16 scale by doing FEWER nodes**
(holding more of the set eviction-free → lower re-expansion than incremental's 1.36×). A 20–90s
window never saturates incremental's TT, so short-run throughput inherently favors incremental.

**The memory wall caps the re-exp win at fp=44:** the D4 full set at fp_bits=44 is **50 bits/key**,
so 7.9B distinct ⇒ ~50 GB of segment — does **not** fit the 26 GB box. Burr at fp=44 can hold
~2.4B keys (~15 GB) ≈ incremental's 2.1B → only a *marginal* re-exp win at full n=16. **The real
capacity win needs the iso-merge (proposal Approach B): 7.9B/3.4 ≈ 2.33B iso-classes fit ~15 GB at
fp=44 → re-exp → ~1.0×.** That requires the iso key at freeze (batch, fine) and on a live miss
(the measured-negative cost — but paid only on the cold-tail miss, and the freeze can iso-merge for
free). This is the next frontier, not more throughput micro-opts.

## Iso-merge (Approach B) investigation — START HERE next session

User picked the **iso-merge pivot** (option 2): make the segment hold iso-classes (3.4× fewer keys
→ fits RAM at fp=44 → re-exp → ~1.0×; the real wall-clock win over incremental). Before building,
I ran the Fermi probe. **Findings (decisive, resolve the open question first):**

- **The 3.4× merge is REAL** — authoritative `queens count 12 --iso`: 1,060,729 D4-distinct →
  **309,830 iso-classes = 3.42×**, *win/loss-consistent (SAFE key)* for both `iso_key_ir` (1-WL +
  individualisation) and `iso_key_canon` (IR canon). 1-WL alone has 0.8% unsafe (mixed) classes —
  **use `iso_key_ir`/`iso_key_canon`, not bare `iso_key`/`iso_key_fast`**, or a wrong merge flips a
  verdict. `count 14 --iso` times out (sequential + 49M exact set) — use n=12 for the factor, or
  give it minutes.
- **But live iso is net-SLOWER**: interleaved n=14 `solve parallel --distinct`, D4 vs `QUEENS_KEY=fast`
  vs `=canon`: D4 6.5/9.4s, fast 7.7/10.0s (~19% slower), canon 8.7/10.4s (~34% slower). So the
  per-node graph-key cost ≈ cancels the 3.4× merge — the roadmap's "wash/negative", now reproduced.
  *(Caveat: that probe's `--distinct` HLL is fed the D4 key, so it does NOT show the merged node
  count — capture `solver.nodes()` to see the real expansion reduction; wall-clock is the honest
  signal and it's negative.)*

**The crux for burr-iso:** the win needs iso-keying to reduce *expansions*; that means iso-key on
every memtable **miss**, and misses ≈ 74% of nodes (most are first-visits), so "iso only on a miss"
≈ "iso per node" — the measured-negative regime. Burr's D4 memtable gives **no intra-epoch merge**
either (isomorphic positions in one epoch stay separate until frozen). So plain burr-iso is likely
net-negative, same as flat-TT-iso.

**The levers that could flip it — the next session's decision tree:**

0. **★ Micro-optimise the iso key down to the instruction level (the headline lever — do this
   hardest).** The whole deficit is ~19% (n=14) — i.e. the iso key only has to get a little cheaper
   for the 3.42× merge to win outright. This is exactly the win the D4-canon rewrite already banked
   (574 → 62 cyc via `canon_bench` + ILP/SWAR/branchless work — see the
   [inner-loop handoff](2026-06-16-queens-inner-loop-rewrite.md)). Apply the same discipline to the
   graph key:
   - **Build an `iso_key_bench`** (mirror `src/bin/canon_bench.rs`): a stream of realistic deep
     `available` masks → cyc/key for `iso_key_fast`/`iso_key_ir`, the instruction-level regression
     harness. Gate every change on it.
   - **Profile + attack the hot path** (`src/queens/graph.rs`: `iso_key_fast_in::<HIST>`, the graph
     build from the available mask, the 1-WL colour-refinement rounds, the individualisation, the
     final canonical hash). Likely cost centres: per-vertex adjacency build (popcount/bit-scan over
     the queen-attack graph), the WL multiset hashing each round, the sort/canonicalise. Push to the
     instruction level — branchless refinement, SWAR/AVX over the colour vectors, fewer WL rounds if
     they don't change the partition, incremental colour carry down the DFS (the D4-canon trick:
     placing a queen removes one vertex — can the colouring be updated, not recomputed?), a
     `tiny_comp_key` fast path for the many small components (#18), monomorphise the `HIST` toggle.
   - Target: iso key within ~1.3× of the D4 incremental key's ~62 cyc. At that point 3.42× merge ÷
     ~1.3× cost ≈ **~2.6× net** — a decisive win, and it makes burr-iso fit RAM (re-exp → ~1.0×).
   - **`etc.`**: also instruction-level the burr miss-path around it (the iso-archive-key derive, the
     iso-Bloom probe) so the per-miss iso cost is minimal end-to-end.
1. **Selective keying** (`QUEENS_KEY_MAX=k`): iso-key only *small* available-graphs (deep nodes —
   cheap to key, high transposition value); big shallow graphs stay D4. Captures most of the merge
   at a fraction of the cost; composes with (0). **Fix the n=16 sentinel-bit-255 collision first**
   (`graph_bits`, `solver/mod.rs` — n=16 uses all 256 bits so the graph-key/D4 namespaces overlap).
2. **Merge growth at n=16**: 3.42× at n=12 may be larger at n=16 (richer graphs), tipping the
   balance. Can't cheaply measure (`count --iso 16` is infeasible) — extrapolate from n=12/14, or a
   partial-n16 fixture.

**Cheapest decisive next probe (do FIRST, before the build):** rerun the n=14 D4-vs-iso A/B
capturing **`nodes`** (not just distinct) for the real expansion-reduction factor; build
`iso_key_bench` and drive the iso key down at the instruction level (0); sweep `QUEENS_KEY_MAX`
(with the sentinel fix) (1). If a config beats D4 wall-clock at n=14 → build burr-iso (iso
`iso_key_ir` segment + D4 memtable + position retention for freeze-time keying — the memtable stores
only fingerprints, so the freeze needs a per-epoch position log, ~32 B/entry, transient; the
retained compaction pairs stay 8 B iso-archive-keys). If nothing beats D4 even after (0) → iso-merge
is a documented negative for n≤16; pivot to tiered compaction below.

## Other next steps

1. **Cool-box clean measurement** — the session's late numbers are ~2× thermally throttled. Re-run
   the interleaved A/B + a longer burr bench cold to pin the real sustained rate; the hash-dedup +
   bloom-prefetch (commit `05debb5`) are unmeasured-clean.
2. **Tiered compaction** (the sustained-throughput lever if iso is dead) — the single-segment
   rebuild is O(total) per freeze, so rebuilds grow and dip the rate (the 270M-key rebuild dropped
   instantaneous to ~5). Bound it: a few L0 segments + occasional base merge (K small, amortized).
   Retain pairs already partition by shard; for the full run, spill them to the zpool (also the
   n=18 external-memory primitive).
3. **Validate at scale** — a longer (ask-first) n=16 run comparing burr vs incremental on
   *wall-clock + re-exp*, not M/s. Burr's checkpoint/resume isn't wired (`tt()` returns None) —
   needed before a multi-hour run.

## Knobs (all resolved once at construction)

`QUEENS_BURR_MEM_BITS` (each memtable 2^bits, default = CLI bits), `_FREEZE_AT` (default 75% of a
memtable), `_FP` (default 44), `_LOAD` (0.90), `_SHARDS` (32), `_BUILD_THREADS` (8), `_BLOOM_GB`
(1.0; 0 disables). Bench: `QUEENS_BENCH_SECS=N` prints throughput + stats every N s to stderr even
when the bar is off (redirected runs).
