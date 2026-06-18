# iso-window — dense W8 table + huge-page TT, pushing n=16 toward the floor

**Date**: 2026-06-18
**Session**: 2026-06-18--3 (`138f26c4-12cc-40fd-a333-4d208da94279`)
**Mode**: intent-based (`mi`)
**References**:
- Closed predecessor: [iso-flat solver](done/2026-06-17-iso-flat-solver.md) — the kernel iso-window builds on.
- Design/direction (Codex, session `codex:019edb21`): folded into the "Codex's windowed-dataflow design" section below (his standalone note has been deleted).
- [Theoretical floor](../2026-06-16-queens-theoretical-floor.md) — compute floor ~45–60s; we're at 2m44s (~3× over).
- Umbrella roadmap: [n=16 memory roadmap](2026-06-15-queens-memory-roadmap.md).

## Context

`iso-window` = `iso-flat`'s DFS-resident kernel + a **complete dense W8 table**: at `popcount == 8`
the available 8-vertex Node-Kayles subgame's win/loss is isomorphism-invariant, so it's resolved by
a single raw 28-bit labelled-edge-code lookup instead of probing the 13–17 GB flat TT — and its whole
≤7 subtree is **never re-expanded**. Over a **huge-page-collapsed** flat TT this **solves n=16 in
2m44s (SECOND player), under the 3-minute goal**, vs iso-flat's 3m33s. It is now the default solver.

**The reversal that mattered.** The predecessor handoff concluded "~36 M/s floor, sub-50 unreachable,
n=16 ~3m41s is the wall." **All wrong** — measured on a memory-degraded box (zram swap full, ZFS ARC
eating ~13 GB → 17 GB TT OOM'd → capped runs), it dismissed W8 on one confounded capped run, and never
tried forcing huge pages. Clean box + W8 + `MADV_COLLAPSE` → 2m44s. New CLAUDE.md rule: **never claim
"the floor" — that's the user's call; reason through/around walls.**

## Key architecture decisions

- **W8 is a *complete, eviction-free* table** (`src/queens/dense.rs`, W0..W8, 32 MiB bitset). Complete
  ⇒ always a hit, no fingerprint, no eviction, TLB-friendly (16 huge pages). The win over iso-flat is
  *less repeated work*: iso-flat evicts pc==8 entries from the 17 GB TT and re-expands their ≤7
  subtrees repeatedly (the ~28% node gap: 5.1 B vs 7.1 B). W8 was a *net loss* on the capped/degraded
  box — the lesson is that its payoff only shows with the real 17 GB table and a cheap lookup.
- **`const WINDOW: bool` monomorphisation** of `wins_inc`/`par_wins_inc`: plain iso-flat has **zero**
  dead pc==8 branch (hot-path rule); iso-window's pc==8 → one-pass `w8_get` (build the 28-bit code
  straight from the 8 attack rows — no `adj[]`→`projected_code` double-build, which is what made
  Codex's `dense_window_get` a wash). The negative W9 per-entry cache was dropped from the live path.
- **`MADV_COLLAPSE` default-on for ≥4 GB tables** (`tt.rs::zeroed_huge_atomics`): plain THP only reaches
  ~73% 2M on a randomly-faulted 17 GB table; prefault (`MADV_POPULATE_WRITE`) + collapse → 100% 2M.
  `QUEENS_TT_COLLAPSE` overrides (`0`=off, else=on).

## What landed (branch `queens-iso-local-memo`, ff'd to `main`)

- `1f53937` backup of Codex's experiment · `2457646` the win/new default · `e9f65ec` Opus-review doc fixes.

## Measured results (clean box, full 17 GB TT; single runs, node counts vary ±~5%)

| run | wall | nodes |
|--------------------------|--------|--------|
| **iso-window + collapse**| **2m44s** | 5.12 B |
| iso-window               | 2m53s  | 5.20 B |
| iso-flat                 | 3m29s  | 6.12 B |
| iso-flat + collapse      | 3m44s  | 7.16 B |

- **TT-size sweep (8/12/17 GB, all 100% 2M):** *warm* M/s rises as the table shrinks — 8 GB **42.7**,
  12 GB 40.4, 17 GB 37.7 — so TLB-residency is a real **~13% per-node** win, but a smaller table loses
  it back to eviction → wall ~flat. **Capacity is not the binding constraint; per-probe latency is.**
- collapse on iso-window: ~5% wall (2m53→2m44) with near-identical node counts ⇒ a *clean* TLB win,
  not node-count noise.

## Codex's windowed-dataflow design (`codex:019edb21`) — folded from his now-deleted note

Codex built the W8 scaffold and a design note (`rust/notes/2026-06-18-queens-windowed-dataflow.md`,
since deleted — its content lives here). The full design and his measurements:

**Diagnosis.** iso-flat's late n=16 wall is the flat TT: throughput starts strong, then falls as the
17 GB table fills and evicts (`wins_inc` + `band_entry` hot). A bigger TT isn't viable (zram). The
instructive negative: a dense `k=8` local DP solved *per parent entry* cut TT fill but was slower —
not the kernel, but **redoing the same dense windows too many times**.

**Target dataflow shape:** `pump frontier → group/window → dense local solve → merge boundary values
→ repeat`. Keep the flat TT as the coarse global table for *large* positions; once a subtree crosses a
small-window boundary, stop issuing a random global probe per descendant and move into an
**implicit-keyed dense representation** — value keyed by *row position* in a dense table, not a 55-bit
fingerprint in a random slot. (Matches the SoA/cold-sidecar note: splitting the live random slot is
bad, but implicit keying is good *when membership is known by construction*.)

**Layer 1 — complete labelled W8 (built, in `dense.rs`).** All labelled 8-vertex Node-Kayles graphs:
`8*7/2 = 28` edges → `2^28` rows, a 32 MiB value bitset, one indexed bit lookup, no fingerprint/open-
addressing. Built bottom-up by vertex count: `W0[0]=loss; Wk[code] = ∃ move i s.t. W_child[project(code,
alive_after_i)] == loss`. Runtime: extract the 8 live vertices, build the 28-bit code, return `W8[code]`.
Microbench (`dense_window_bench`): **W7** (2.1 M graphs) ~0.02s; **W8** (268 M graphs, 32 MiB) ~2.0s —
practical as a startup pre-pass. **W9 is not** — `2^36` rows = 8 GiB as one labelled bitset.

**Layer 2 — frontier-specific `k=9..12` (the open work).** Full labelled tables stop being sane past
k=8, so use frontier chunks: during DFS, pump positions at a chosen boundary ply/popcount into chunk
queues; bucket by a cheap local graph signature (edge-code / canonical bucket); build a dense local row
space only for reachable states in that chunk; solve with linear passes over compact arrays; **publish
only boundary values** back to the shared TT / parent queue. Tolerates recompute *inside* a chunk but
prevents the expensive kind — the same boundary graph rediscovered independently by many parents.
Sketch layout: `WindowChunk { keys: Box<[u64]>, closed: Box<[u16]>, value: Box<[u64]>, index }`; hot
pass linear in dependency order `value[row] = any child row is loss`.

**SIMD direction:** start scalar + contiguous; vectorize only *after* the row space is dense (build
child masks for several rows at once; gather child bytes and OR inverted loss lanes; 64 row-states per
word for bitset values). Do **not** start with SIMD in the recursive DFS.

**Negatives Codex measured — TREAT AS SUGGESTIVE, NOT SETTLED.** ⚠️ Every one of these was on a
**non-znver5 build** (Codex used `cargo build --release`, not `make release`) **and** the
**degraded/capped box** — the exact two confounders that produced the bogus "floor." One of them, the
W8-at-pc==8 "wash," **already flipped to the session's win** once it was rebuilt znver5 with a cheap
`w8_get` on a clean box. So re-verify any of these on a clean znver5 box before trusting them:
- per-entry dense DP per parent → "recompute too high";
- W8-only at pc==8 via the slow `dense_window_get` → "wash" (FLIPPED to the win this session);
- per-entry pc==9 eval over W8 → "wrong granularity";
- W9 direct-mapped cache → 128 MiB ~52% hit (3/36 roots), 512 MiB ~66% hit at 1m02s (2/36, ~16 M/s).

**The throughline that probably survives** (a design insight, less sensitive to the build): `k=9..12`
wants to be grouped/windowed and solved once per chunk, not recomputed per parent. Our segmented-TT
step above is the lighter, DFS-preserving cousin; full grouped-frontier DDD is the heavier follow-on.

## NEXT (active) — segmented TT variant: capture the ~13% TLB win *without* shrinking

The user's chosen direction. New variant, **keep the flat TT as the A/B control**. Make the DFS
working set spatially/TLB-local in the full 17 GB table (no eviction cost):

1. **Measure the popcount distribution** of iso-window's flat-TT working set (pc≥9) — load-bearing:
   bad band sizing over-evicts → regression. Add a gated per-pc put histogram; read off one n=16 run.
2. **`index(route, pc) = band_base[pc] + fastrange(route, band_size[pc])`** behind `QUEENS_TT_SEGMENT`,
   bands sized from (1). **Pure function of the key ⇒ transposition-safe** (same key → same band → same
   slot — this is NOT the CCX-sharding negative, which sharded by *worker* and lost cross-worker
   merges; key-derived segmentation loses nothing but load balance). Thread `pc` through
   `tt_get_h`/`tt_put_h`/`prefetch_h` → `index`. Flat mode ignores `pc` (control stays identical).
3. **A/B** iso-window segmented vs flat: warm M/s (does it approach the 8 GB run's ~42 M/s?) + completion.
4. Refinements if it pays: cache-line set-associative buckets with a band-aware line index; prefetch
   the band arena on entry. Sibling/child co-location (Codex's "key by parent") is harder — defer.

## Then (bigger levers, multi-session)

- **Grouped-frontier `k=9..12` DDD** (Codex's pump/group/merge): solve each unique boundary graph once,
  dedup by sort (streaming/bandwidth-bound, not latency-bound). The floor note's L2 lever; breaks
  DFS-residence (composability caveat). The real path below ~2m44s, and the n=18 enabler.
- **BuRR archive** (roadmap Chunk-4): eviction-free static value-only ~1.1 bit/key — sound *because*
  windowing makes membership known by construction (ties to the segmented/windowed work above).
- **1 GB hugepages** for the TT (zero TT TLB miss) — needs boot-time reservation (root), not runtime.

## Codebase reference

| What | Where |
|------|------|
| iso-window solver / W8 hook / `w8_get` / `WINDOW` dispatch | `src/queens/solver/iso_flat.rs` |
| dense W0..W8 tables (`DenseW8`, `get`, build) | `src/queens/dense.rs` |
| flat TT, `index(route)`, `zeroed_huge_atomics` + collapse | `src/queens/tt.rs` |
| W8 microbench | `src/bin/dense_window_bench.rs` |
| CLI default solver = `iso-window` | `src/bin/queens.rs` (Solve args) |
| component/popcount analysis scaffold | `comps_report` in `src/bin/queens.rs` (~2202) |

## Deferred review nits (fold into the segmented-TT pass)

- `w8_get` uses a per-pc==8-node `Option::expect` — thread `&DenseW8` in, or `unwrap_unchecked` + SAFETY.
- `dense::MAX_DENSE_K = 9` is vestigial (W9 removed) — could be 8.
- `dense_window_bench.rs` duplicates the `dense.rs` DP (independent cross-check; maintenance fork).

## ⚠️ Box hygiene (REQUIRED for the 17 GB regime — why the prior "floor" was bogus)

Before any real n=16 run, get ≥~20 GB free so the 17 GB TT fits without spilling: **swap/zram off**,
**ZFS ARC capped low** (`zfs_arc_max`≈2 GB), **drop caches + compact** (`echo 3 >…/drop_caches;
echo 1 >…/compact_memory`), and **clear `/tmp`** (it's tmpfs = RAM; stale `*.perf.data` ate 11 GB).
Bench only from this clean state; otherwise the TT OOMs/spills and every number is degraded.

## Build / test / validate

Per CLAUDE.md. Gate: `solver_lineage_agrees` + `solve 12 iso-flat --distinct` (exact **1,060,823**) +
`solve 14 iso-flat --distinct` (second, re-exp ≈1.0×). **Name `iso-flat` explicitly** for `--distinct`
(default is now iso-window, which has no distinct counter). TT/key changes must hold both.

## Progress

- [x] iso-window + collapse = n=16 2m44s, new default (committed, ff'd to main)
- [x] Opus review (no ff-blockers), doc fixes
- [x] Segmented TT: (1a) per-pc put histogram instrumentation (`QUEENS_PC_HIST=1`), gated, validated on n=14
- [x] Segmented TT: (2) `QUEENS_TT_SEGMENT` index variant + band-file mechanism, flat TT kept for A/B (validated n=12/14: correct verdict, zero node penalty)
- [x] Segmented TT: (1b)+(3) n=16 pass — distribution captured (`/tmp/bands16.txt`), A/B = **+5% throughput** (see below)
- [x] Profile-guided micro-opt **round 1: branchless move-availability filter** — **−34% branch-misses, −9.4% CPI (~−10% cycles)**, gate-safe (see below). Bigger than the seg lever.
- [x] **Combined ship A/B (n=16, micro-opt binary, interleaved):** seg+branchless **34.3 M/s** vs flat+branchless 33.3 vs original-flat 29.6 ⇒ **micro-opt +12.5%, seg +3% on top, combined ~+16% throughput.**
- [ ] Profile-guided micro-opt round 2: largely diminishing — post-round-1 the remaining branch-misses are inherent (`solve_local` cutoff is data-dependent) or already-tuned (`lex_min8`). `enter_graph` sort network is the one reducible item left but it's a small fraction of `band_entry` (which `solve_local` dominates). Revisit only if chasing the last few %.
- [ ] Segmented TT: (4) set-associative band buckets + arena-prefetch — smaller headroom (dTLB only ~2–8% of cycles)
- [ ] Deferred nits folded in

## Combined ship A/B — seg + branchless on n=16 (~+16% throughput)

Interleaved n=16 runs on the round-1 (branchless-filter) binary, weights from `/tmp/bands16.txt`:

| config            | nodes              | wall          | M/s  |
|-------------------|--------------------|---------------|------|
| flat + branchless | 5.56 B / 5.37 B    | 2m44s / 2m44s | 33.3 |
| seg  + branchless | 5.49 B / 5.48 B    | 2m37s / 2m43s | 34.3 |

vs this session's original-flat baseline 29.6 M/s ⇒ **branchless +12.5%, segment +3% on top, combined
~+16% throughput.** The wall (~2m40–2m44s) matches the old "2m44s" headline, but at **+9–12% more
nodes in the same time** — the parallel node-count noise (±~18%) hides the gain in wall-clock; **M/s
is the only trustworthy n=16 A/B metric.** Branchless is the load-bearing lever; segment compresses to ~3%
when stacked (its dTLB win partly overlaps the branchless cycle savings).

## Profile-guided micro-opt — round 1: branchless move filter (~10% cycles)

**Profiling method that worked (record for next time):** n=16 perf stat shows IPC ≈ 0.79 and
**branch-misses ≈ 24% of cycles** — the dominant stall, far above dTLB (~2–8%). To localise,
**must profile n=16, not n=14** — at n=14 a `perf record` is swamped by the one-time
`small_canon_table` build (the `OnceLock` smallsort), which is amortised to nothing at n=16. The
n=16 *search* branch-misses are diffuse across `wins_inc`/`band_entry`/`w8_get` (inherent game-
tree branching) — **but** the move-availability check `avail_has8` (in `filter_moves` and the
prove-win loop) is a ~50/50 coin-flip branch hit at every node, a large mispredict source.

**Fix:** branchless `filter_moves` (write `sq` unconditionally, `nc += avail as usize`), and
route the prove-win loop through `filter_moves` too (children inherit the filtered `moves` — a
shorter `q.order` subseq, byte-identical node set since child-avail ⊆ avail). Both gate-safe.

**Measured (n=16 flat, single runs, CPI is node-count-independent so robust):** branch-misses
143.5 B → 95.2 B (**−34%**), CPI 1.267 → 1.148 (**−9.4%**), cycles 10.81 T → 9.60 T, wall
205 s → 183 s. The branch-misses were **not** latency-hidden — removing them sped the search.
Gate held: n=12 exact 1,060,823 / 1.25×, n=14 1.02×, lineage agrees.

**Method for future micro-opt rounds:** compare **CPI and branch-miss-rate (per instruction)**
from n=16 perf stat — node-count-independent, so one run each resolves a real change that
wall-clock can't (±18% node noise). Localise with `perf record` on **n=16** (not n=14).

## Segmented-TT A/B — (3) n=16 result: +5% throughput (confirmed-positive, modest)

Clean-box n=16, iso-window, 3 interleaved rounds each (flat = no env; seg =
`QUEENS_TT_SEGMENT=1 QUEENS_TT_BANDS=/tmp/bands16.txt`, weights from the n=16 hist run):

| metric            | FLAT (mean of 3)     | SEG (mean of 3)      | Δ        |
|-------------------|----------------------|----------------------|----------|
| throughput (M/s)  | 29.6 (28.2/31.3/29.3)| **31.1** (30.5/31.9/30.8) | **+5.0%** |
| wall              | 3m11s                | 3m04s                | −3.7%    |
| nodes             | 5.61 B               | 5.70 B               | +1.6%    |

**Methodology finding (load-bearing for all future n=16 A/B): compare M/s, not wall.** The
n=16 **node count is the noisy variable** — parallel `par_iter().any()` cutoff timing swings it
±~18% (flat alone: 5.01–5.92 B), which dwarfs the effect in wall-clock. Throughput normalises
it and is what segmentation targets (per-node latency). SEG's node count was *higher* than
FLAT's yet it was faster ⇒ the win is per-node latency, not fewer nodes (and confirms again
that segmentation loses no merges). The +5% is directionally consistent (all 3 seg ≥ 30.4
M/s; 2 of 3 flat < 30) but **not airtight at n=3** (one flat run hit 31.3). ~5% of the ~13%
warm-window ceiling captured — gap is cold-start dilution (whole-run M/s) + band-lookup cost;
(4) chases the rest.

## Segmented-TT band sizing — (1) the put histogram

`QUEENS_PC_HIST=1` on the production iso-window path tallies every flat-TT put by
available-popcount into a gated per-pc histogram (`const MODE = M_HIST` monomorphisation in
`wins_inc`, selected once per subtree handoff in `par_wins_inc` — production `M_NORMAL`
pays nothing; the bump is compiled out). Printed post-solve as a pc / count / %% / cum-%%
table; `QUEENS_PC_HIST_OUT=<path>` also dumps the raw per-pc counts (one per line, pc = line
index) as the band-weight file the seg run consumes. All puts land at **pc ≥ 9** (pc≤8 is the
W8 / ≤7 tables), so the histogram **is** the flat-TT working set the segmented bands index.

**n=14 distribution** (`QUEENS_PC_HIST=1 queens solve 14 iso-window`, 22.9 M puts of 27.6 M
nodes — the ~4.7 M gap is ≤8-band expansions counted in `nodes` but not flat puts):

| pc band   | share of puts | cum   |
|-----------|---------------|-------|
| 9–12      | ~61%          | 61%   |
| 9–16      | ~82%          | 82%   |
| 9–22      | ~96%          | 96%   |
| ≥ 50      | < 0.03%       | —     |

Sharp hump: peak at pc=9 (21.6%), monotone decay to pc≈16, a faint secondary bump at
pc 18–21 (~3% each) and a tiny one at pc 38–43, then negligible tail. **Implication for
band sizing:** weight bands heavily toward pc 9–22; the high-pc tail needs only token
bands. n=14 is the *shape* proxy; (1b) reads the real n=16 weights (range extends higher,
shape expected similar). Re-run any time: `QUEENS_PC_HIST=1 queens solve <n> iso-window`.

## Segmented-TT band index — (2) `QUEENS_TT_SEGMENT`

`index_seg(route, pc) = band_base[pc] + fastrange(route, band_size[pc])` (`tt.rs`): route a
key into a per-popcount band of the **same** flat table, so the DFS working set at a given
depth shares a small, TLB-resident slice — no shrink, no eviction change. **Transposition-safe
by construction:** `pc` is a pure function of the key (its available popcount), so the same
key always lands in the same band → same slot → every merge preserved (not the CCX-sharding
negative, which sharded by *worker*). Bands sized ∝ the put distribution so each carries a
comparable load factor; weights from `QUEENS_TT_BANDS=<path>` (the `QUEENS_PC_HIST_OUT` file)
or the embedded n=14 fallback. `Σ band_size == len`; every band ≥ 64 slots (floor).

- **Flat is the byte-identical A/B control.** `wins_inc` monomorphises on `const MODE`:
  `M_NORMAL`/`M_HIST` use the flat `index`; only `M_SEG` calls `index_seg`. The hot path is
  resolved once at the `par_wins_inc` subtree handoff — no per-node branch, no atomics, no env,
  no alloc, no syscall added (all band/flag/file work is at construction).
- **Validated n=12/14:** correct verdict (second), and with the run's own weights **zero
  node-count penalty** (n=14 seg 27.589 M vs flat 27.596 M). n=14 is validation-only; **n=16 is
  the perf metric** (expect n=14 to be a wash or slight regression — fine).
- **The one-pass n=16 A/B** (no rebuild): `QUEENS_PC_HIST=1 QUEENS_PC_HIST_OUT=/tmp/bands16.txt
  solve 16` to capture weights, then `QUEENS_TT_SEGMENT=1 QUEENS_TT_BANDS=/tmp/bands16.txt
  solve 16` vs a clean flat `solve 16` for warm-M/s + wall. (Skip the hist run's overhead in the
  flat control timing — time a separate clean flat run.)

## Handoff Notes

### iso-window stand-up (2026-06-18)

**Session**: 2026-06-18--3 (`138f26c4-12cc-40fd-a333-4d208da94279`)
**Completed**: iso-window + huge-page collapse as the new n=16 default (2m44s, under goal); clean-box
A/B + TT-size sweep; Opus review; closed the iso-flat handoff; this new handoff.
**Files modified**: `src/queens/solver/iso_flat.rs`, `src/queens/dense.rs`, `src/queens/tt.rs`,
`src/bin/queens.rs`, `src/bin/dense_window_bench.rs` (clippy), `Makefile` (PGO set), `CLAUDE.md`,
`src/queens/store.rs` (comment).
**Instructions for next agent**: start the segmented TT at step (1) above. Verify the box is clean
(§ box hygiene) before any n=16 timing — that single factor is what made the prior session's "floor"
conclusion wrong. Keep the flat TT path byte-identical as the A/B control. Don't re-run Codex's
measured negatives (§ what Codex did).

### Segmented A/B landed + a profiling micro-opt round (2026-06-18)

**Session**: 2026-06-18--4 (`820b0263-4ae0-4080-a0ce-f7c7be3ffd8b`) — `mi`
**Completed**:
- Segmented TT end-to-end: (1) gated per-pc put histogram (`QUEENS_PC_HIST`/`QUEENS_PC_HIST_OUT`),
  (2) `QUEENS_TT_SEGMENT` band index + band-file loader (`QUEENS_TT_BANDS`), (3) n=16 A/B = **+5%**
  throughput. Flat kept byte-identical as control. Gate held.
- Profiling round: n=16 perf stat showed branch-misses ~24% of cycles (not dTLB). **Branchless
  move-availability filter** → −34% branch-misses, −9.4% CPI, **+12.5%**. Combined seg+branchless
  **≈ +16% throughput** (29.6 → 34.3 M/s). Round-2 micro-opts = diminishing (inherent/tuned branches).
- Fixed stale CLAUDE.md n=14 gate text (iso-flat distinct ≈29.2M, was the D4 49.3M).
- Built an HTML report (`notes/queens-report.html`, dual-view, diagrams incl. root-symmetry +
  search-tree-pruning, 14-micro-opt section, methodology/war-stories) + `notes/perf-methodology-warstories.md`.
**Files modified**: `src/queens/tt.rs`, `src/queens/solver/iso_flat.rs`, `src/queens/solver/mod.rs`,
`src/bin/queens.rs`, `CLAUDE.md`, this handoff, `notes/queens-report.html`, `notes/perf-methodology-warstories.md`.
Commits: `43c490e` (histogram) · `c029e3d` (segment) · `59e0f56` (branchless) · `0bb9711` (ship A/B) + doc commits.
**NEXT SESSION — back to the MACRO segmented story, not micro-opts** (user's steer). The lever order:
1. **Segmented step (4): set-associative band buckets + arena prefetch** — cache-line-aligned buckets
   with a band-aware line index; prefetch the band arena on subtree entry. Pushes past the +5% (dTLB
   is only ~2–8% of cycles, so bound the upside first — Channel Fermi).
2. **Grouped-frontier `k=9..12` DDD** (Codex's pump→group→dense-solve→merge) — the real path below
   ~2m44s and the n=18 enabler; breaks DFS-residence (composability caveat).
3. **BuRR archive** (Chunk-4, eviction-free value-only) and **1 GB hugepages** (boot-time reservation).
Profiling method banked: compare **CPI / branch-miss-rate** (node-count-independent) on **n=16**; the
wall hides wins under ±18% parallel node-count noise. `bands16.txt` weights regenerate via
`QUEENS_PC_HIST=1 QUEENS_PC_HIST_OUT=<f> solve 16 iso-window`.
