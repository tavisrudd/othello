# Burr-live (Chunk 4) — BuRR-as-primary LSM store: implementation session

**Date**: 2026-06-16
**Mode**: intent-based (`mi`) — user authorized architectural calls; "keep working until
faster-than-incremental + >7.5 M/s n=16, then ratchet 8–9 → 12 M/s, profiling constraints."
**References**: [proposal](../proposal-2026-06-16-burr-live-cascade.md) (the design fork);
[memory roadmap](2026-06-15-queens-memory-roadmap.md); [inner-loop handoff](2026-06-16-queens-inner-loop-rewrite.md)
(the `incremental` kernel this reuses). Code: `rust/src/queens/store.rs` (the store),
`rust/src/queens/solver/burr.rs` (the solver), `rust/src/burr.rs` (the BuRR archive).

## Handoff Note — session `2026-06-17--1` (`c90de881-4087-4226-957c-50062a2b74c1`): **`fused` solver + bloom-skip; the sub-20min push** (commit `a058057`)

**Goal this session:** a solver that breaks the n=16 **20-minute** barrier (iso-burr is 29m23s).
**Mode:** intent-based (`mi`), user authorized arch calls.

> **⚠ RUN CONVENTION (user instruction — persists across all future sessions).** Launch every
> queens run/bench **in the tmux session `queens` as a NEW window** (window name your choice) so the
> user can watch it live — **never** in a detached background sub-shell. **Keep the session's first
> window (`bash`, window 1) always alive — never close or kill it.** Create the session if absent:
> `tmux new-session -d -s queens` (this makes window 1). Launch a run with
> `tmux new-window -t queens -n <name> "<cmd> 2>&1 | tee /tmp/<name>.log"` and read progress from the
> tee'd log (or `tmux capture-pane -t queens:<name> -p`). The queens binary catches SIGTERM, so to
> stop a run use `pkill -9 -f "queens solve"` (plain `timeout` won't kill it; use `timeout -s KILL`).

**The lede:** built **`fused`** — `incremental`'s A3 kernel + BuRR store + **ONE key per node**
(tiny-table iso for `avail<=iso_max`, else incremental D4), vs iso-burr's d4-then-iso **double
probe**. Committed, all gates green, n=16 verdict **correct** (second player, matches Jenrich).

**BUT fused is ~30% SLOWER than iso-burr at n=16 (the headline negative).** Full run at iso-burr's
exact config (`MEM_BITS=26 CAP=14 KEY_MAX=6`): **38m26s / 8.79B nodes** vs iso-burr **29m23s /
4.32B**. fused does **2.0× the nodes** — re-exp ~2.0× vs iso-burr's 1.15×. The pre-cap A/B (fused
4.04/4.38 vs iso-burr 3.51/3.35 M/s) was real but **misleading**: it never reached the eviction
regime. **Root cause (my design error): iso-burr's double-keying is not just an iso-recompute
cache — it is 2-way EVICTION REDUNDANCY.** A small (deep, heavily-reused) position has two entries
in the evicting memtable (d4 + iso) and survives eviction if *either* slot survives; fused's single
key has one chance → higher post-cap eviction → ~2× re-exp on exactly the recurring-endgame
positions that matter most. So **fused's single-key trades post-cap resilience for pre-cap probe
speed, and at n=16-cap-bound that trade is net-NEGATIVE.** fused wins only when the cap does NOT
bind (n=14, or n=16 post-merge / with enough RAM). **Disposition: keep iso-burr as the cap-bound
n=16 default; fused is the no-cap-regime solver. The binding constraint is the CAP (storage) — the
real <20-min lever is removing it (merge → fewer keys → fits RAM → no eviction → fused wins).**

**What landed (commit `a058057`):**
- **`fused` solver** (`rust/src/queens/solver/fused.rs`, wired in `solver/mod.rs`, `queens/mod.rs`,
  `bin/queens.rs`; in `SOLVER_NAMES`, `make_solver`, `--list-engines`, `--distinct`). Single
  `node_key()` threaded through the recursion like `burr`. Added to `solver_lineage_agrees`.
- **Bloom-skip when `seg_count==0`** (`store.rs` `get`/`prefetch`) — every *pre-freeze* node was
  paying a cold multi-GB shared-Bloom probe for nothing. Fused freeze-free **+18% at T=12**. Helps
  burr/iso-burr too. Sound (seg_count monotonic; racing freeze only re-expands).

**Load-bearing findings (measured this session):**
1. **The "half the store" win is a n=12 artifact.** At n=12 fused fill = 489,927 vs iso-burr
   1,039,505 (½). At **n=16 it's ≈ equal** (~1.83B keys both) — because with `KEY_MAX=6` the vast
   majority of n=16 nodes are *large* (avail>6), keyed d4 in **both** solvers; only the avail≤6 tail
   double-keys. So fused's edge at n=16 is **nodes/sec + fewer segments, NOT capacity.**
2. **STORAGE / re-exp is the binding constraint at n=16.** The ~3.8B-key set doesn't fit RAM at
   ~60 bits/key → store caps at 14GB (holds ~48%) → re-exp dominates wall-clock. *Neither* fused
   nor iso-burr fits it eviction-free in 26GB at fp=44. To fit (re-exp→1.0) needs **~34 bits/key**.
3. **`MEM_BITS=27` is a TRAP** — two full runs at `MEM_BITS=27/28` blew re-exp to ~2.0× (vs
   iso-burr's 1.15× at `MEM_BITS=26`) and ran ~40min+. Cause not fully isolated (bigger memtable
   *should* help, not hurt — likely a cap-timing or RSS/zram interaction); **use `MEM_BITS=26`**.
   The matched-config A/B proves fused *itself* is fine; the blowup was config, not the solver.
4. **Amdahl / core usage** (T=24 thread-scaling, freeze-free): fused scales to ~3.1× over T=1
   (~15–19 cores busy); incremental ~4.4× (~19.6 busy) — the BuRR path uses cores worse. BUT
   **finer work-stealing backfires**: lowering `min_avail` 96→24 raises cores-busy (18.8→22.4) and
   *lowers* throughput (5.76→4.64 M/s) — extra cores burn split/steal overhead. Default
   `par_depth=3/min_avail=96` is throughput-optimal. **The idle cores are genuine serial fraction
   (the move-0 subtree's parity-limited internal parallelism) — don't force them; give them aux
   work (see Lever B below).**

**The <20-min lever stack (decided with user; next session):**

- **★ Lever A — edge-code small-component table (the dual-purpose lever).** Make the per-component
  iso canon an **O(1) array lookup** by extending the eager `small_canon_table` (edge_code→canon,
  currently `SMALL_CANON_MAX=7` in `graph.rs`) to **k≤8** (2^28 codes; **bit-pack to value width →
  1 bit win/loss = 33MB, or 4-bit nimber = 134MB** — the "2GB" fear was a u64 strawman). `edge_code`
  is a *complete* index (full labelled graph, no merge hazard); the wall is the universe
  2^(k choose 2), not the values. This replaces WL for k=5–8 components (the ~6800-cyc cost that put
  iso ~2.2× underwater — iso-key handoff lever #1) → cheap **full-iso** merge live → ~2.2B keys →
  **fits RAM at fp=36 → re-exp→1.0** → fused's per-node speed wins outright (likely <20, maybe well
  under). *Dual-purpose: cheaper key (speed) AND fewer keys (fits RAM, kills re-exp).* For k≥9 the
  dense universe is infeasible (2^36) → store only *realized* queen-component structures sparsely
  via MPH / BuRR-value-only on a cheap-complete key for the realized subset.
- **Lever B — background bottom-up nimber DB (uses the idle cores; the Amdahl reframe).** Same
  edge-code table but holding **nimbers**, built bottom-up (retrograde by component size) on the
  structurally-idle cores. Hot loop resolves a fragmented position by decompose→lookup→**XOR**→win
  iff ≠0, *no recursion*. Merges by **value** (below the iso floor — two non-isomorphic components
  with equal nimber collapse; roadmap #8, floor-doc §1). Bottom-up build is **embarrassingly
  parallel** → directly attacks the parity-limited top-down Amdahl ceiling.
- **GATE both on `count --comps`** (already exists): what fraction of deep nodes decompose into
  components ≤8? If most carry one big component, the table rarely hits (the roadmap's "#8
  decomposition dead" is the *full* graph; deep fragmentation is the open, measurable question —
  handoff hint: "70.6% of components are k≥5"). The COMP_CACHE's low hit rate (+3.7%) is NOT a
  blocker — it keys on *square-set*; `edge_code`/structure keying is the fix it itself called "the
  prize."

**Storage / Elias-Fano analysis (user asked):** for the *archive*, EF/encoding ≈ **1.1–1.2×** over
BuRR-with-fp (you still pay ~fp bits for absence-detection when membership is unknown) — marginal,
**not the lever**. fp tuning 44→36 ≈ 1.2× (safety-floored at fp≥36 for ~4.3B probes; n=16's Jenrich
cross-check catches a flip, n=18 can't). The order-of-magnitude levers are **more merge** (~1.7×,
fits the set — Lever A) and **drop the fingerprint via known membership** (ply-windowed DDD →
fp→0 → ~1.1 bits/key, **~50×** — roadmap/SoA §Q1.3, the n=18 path). **EF's genuine home is the n=18
external-memory DDD per-ply sorted key streams** (monotone sets + successor queries).

**Banked also (commit `2d783f1`):** bloom per-check cost cut — `locate()` now does **one
`mix64` + Lemire fastrange** (multiply-high) instead of 2×`mix64` + an integer division
(`h % blocks`, the dominant ~20-40 cyc per-check cost), with the 8 in-block positions from a
multiply-seeded rotate/xor chain (Kirsch-Mitzenmacher, FP-preserving). Helps every miss-path
bloom *and* the O(seg_count) per-segment-bloom hit-walk. Gates green; n=16 sanity burst no FP
regression. `fastrange` is now `pub(crate)` in `burr.rs`.

**Lever #3 (segment directory) is REVERSED — do NOT build it.** A collision-light `hash(ak)→seg_id`
directory needs ~7 GB (vs the ~2.6 GB of per-seg blooms it replaces) → net +4.8 GB; but RAM is the
binding constraint (cap → re-exp). A RAM-neutral directory (load ~1.4) → catastrophic missed-hit
re-exp; a usable one shrinks the cap → *more* re-exp. So it trades away the binding resource. The
RAM-free hit-walk speedup is the per-seg-bloom *prefetch* (lever #2), but that's a per-node
sideshow vs re-exp.

**Next steps (re-exp is the binding constraint; attack it, not per-node speed):**
1. **Cheap/free:** A/B `QUEENS_BURR_FP=36` (ribbon ~60→~50 b/key → ~1.2× more keys fit → ~1.2× lower
   re-exp; safe under the n=16 Jenrich cross-check).
2. **★ The real <20-min lever — Lever A (component table):** `count --comps` fragmentation gate
   first (what fraction of deep nodes decompose into components ≤8?); if it passes, extend
   `small_canon_table` to k≤8 (bit-packed: 1-bit win/loss = 33 MB, 4-bit nimber = 134 MB), switch to
   component-decompose keying for **full-iso merge** → ~2.2B keys → fits RAM at fp=36 → **no cap →
   re-exp 1.0** → then fused's single-key (no redundancy needed when nothing evicts) wins outright.
3. **Lever B (background nimber DB)** once A lands — value-merge below iso, on the idle cores.
4. **Disposition:** iso-burr stays the cap-bound n=16 default (its double-key eviction redundancy);
   fused is the no-cap-regime solver. **Do NOT** fire `MEM_BITS≥27` runs. **Runs go in tmux session
   `queens`** (new window per run; keep window 1 `bash` live) so they're monitorable.

## Handoff Note — session `2026-06-16--9`: **n=16 SOLVED, freeze OOM fixed** (commit `64d86db`)

**The lede:** iso-burr now **solves n=16 — second player wins** (matches Jenrich), in
**29m23s** (4.32 B nodes, ~2.5 M/s steady), with **no OOM**. The freeze OOM that killed
the 3rd root is gone.

**Root cause (the OOM):** the store rebuilt **one compacted segment from a retained
per-shard pair set on every freeze** — holding 16 b/key forever *and* re-materialising the
whole archive each freeze (quadratic CPU, >2× peak). At n=16 on this 26 GB box it blew up.
This was the handoff's own "Other next steps → Tiered compaction" item; it is now done.

**Fix (3 changes, all in `store.rs`):**
1. **Append-only segments (no recompaction).** Each freeze builds **one** segment from just
   the frozen buffer and appends it to a **pre-allocated** `AtomicPtr<Segment>` table (Arcs
   held for the whole run in a `with_capacity(MAX_SEGMENTS=8192)` Vec → hot-path raw deref
   always valid). Prior segments never read/copied/rebuilt → freeze is **linear**, resident =
   live segments (~6 b/key, no duplicate). Removed `pairs` retention + the `seg_live`
   grace-ring + the single `seg_ptr`.
2. **Hard byte cap** (`QUEENS_BURR_CAP_GB`, default 12). A freeze that would cross it (or fill
   the table) latches `frozen_full` and **stops** — the active memtable then evicts (re-exp
   climbs gracefully) instead of growing past RAM. Every large alloc is made once at
   construction.
3. **Per-segment membership Blooms** (`QUEENS_BURR_SEG_BLOOM_BITS`, default 8). The walk checks
   a segment's own Bloom before probing its ribbon, so a frozen hit touches ~one segment
   instead of all K. A Bloom has no false negatives ⇒ never misses a real hit (worst case: one
   wasted probe). **~1.45–1.7× faster** than the no-bloom walk at n=16 (2.4–2.6 vs 1.66 M/s
   instantaneous at 22 segments); flattened the throughput-vs-segment-count decline.

**n=16 numbers** (`QUEENS_KEY_MAX=6 QUEENS_BURR_MEM_BITS=26 QUEENS_BURR_CAP_GB=14`, iso-burr
`--distinct`):

| metric            | value                                                        |
|-------------------|--------------------------------------------------------------|
| verdict           | second player wins (PV legal, 12 moves) — matches Jenrich     |
| nodes / time      | 4,323,721,735 in 29m23s (~2.5 M/s; faster than incremental)   |
| distinct          | ≈3.78 B (iso-merge ~2.1× under D4's ~7.9 B)                   |
| re-expansion      | 1.15× (12.7% recomputed) — well under the flat-TT's 1.36×     |
| store at end      | 52 segments / 1.83 B keys / 14.03 GB frozen (61.5 b/key)      |
| memory            | RSS plateaued 17.5 GB, VmSwap 0 — cap held, no zram swapping  |

**Validation (all pass):** `solver_lineage_agrees`, `burr_lsm_survives_frequent_freezes`,
n=12 exact 1,060,823 (burr + iso-burr), n=14 second-player win (both), forced-freeze +
cap-latch hold the verdict; clippy/fmt clean.

**Review finding (handled, not actionable):** the `d4_bits`/`graph_bits` namespaces are
disjoint by construction (word[3]=0 for graph keys vs `0xD400…` for D4); the 256→192
`d4_bits` fold adds collisions only at ~2⁻⁶⁴, far below the accepted `fp_bits=44` archive
false-positive floor — so the earlier "n=16 sentinel-bit-255 collision" worry is moot.

**Next steps:**
1. **Memory margin.** `CAP=14` + the *separate* shared Bloom (`0.2·cap` ≈ 2.8 GB) peaked at
   RSS 17.5 GB / ~2 GB headroom — tight on 26 GB with zram already engaged. The in-code
   default `CAP=12` is safer; size `CAP_GB + BLOOM_GB + 2·memtable` against free RAM, and
   consider folding the shared-Bloom bytes into the cap accounting so one knob bounds total.
2. **Lower re-exp** = a bigger cap (more RAM / distributed / external segments) holds more of
   the 3.78 B set; at 14 GB it held ~48% → 1.15×. The append-only segments are the dump/load
   + distributed-aggregate primitive.
3. **Throughput:** the per-seg-bloom walk is still O(K) bloom-line reads per hit (52 segments
   at n=16). Prefetch the seg-bloom lines or bound segment count if it matters. iso-key
   instruction cost (`iso_key_bench`, the other handoff) is the orthogonal lever.
4. **Checkpoint/resume** still unwired for burr — the immutable segments already serialize
   (`write_to`/`read_from`), so dumping segments + the memtable would make a multi-hour / n=18
   run resumable.

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

> **Update (session 2026-06-16--7):** lever 0 (instruction-level iso key) was executed and
> reframed — see [iso-key-optimization handoff](2026-06-16-iso-key-optimization.md). TL;DR:
> the merge IS realized live (3.44×), but iso is ~2.2× *slower* than production at n=16 (the
> key is WL graph-canon, ~100× the D4 key, not "19% to close"). Banked a correct 1.25× cut +
> `iso_key_bench`; target-cell IR is a documented negative. Remaining levers
> (automorphism-pruning / precompute / selective keying) are multi-session — **decide
> direction with the user first.** The text below is the original (pre-execution) framing.

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
memtable), `_FP` (default 44), `_LOAD` (0.90), `_SHARDS` (32), `_BUILD_THREADS` (8). **New in
`64d86db`:** `_CAP_GB` (resident segment-bytes ceiling, default 12 — past it the store stops
freezing and the memtable evicts), `_SEG_BLOOM_BITS` (per-segment membership Bloom, default 8 ≈
1 byte/key). `_BLOOM_GB` (shared prefilter) now **defaults to `0.2·cap`** (≈10 bits/key at the
default fp; was a flat 1.0) so it doesn't saturate at the cap; `0` disables. Bench:
`QUEENS_BENCH_SECS=N` prints throughput + stats every N s to stderr even when the bar is off
(redirected runs).
