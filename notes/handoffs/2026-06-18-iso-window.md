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
**Current record: 2m15s** (user run 2026-06-19, `target/release/queens solve 16 iso-window`, 5.03 B nodes
≈ 37 M/s, flat TT 17.18 GB @ 87.8 % full, 1:1 affinity pin). Note the wall is node-count-noisy (±~18 %);
5.03 B is the low end of the range so part of the 2m15s is a low-node draw — **M/s remains the trustworthy
A/B metric, not wall.**

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
- [~] Segmented TT: (4) set-associative band buckets — **investigated, parked on branch
  `queens-tt-assoc-buckets` (76c2b7e), NOT on main.** Break-even with seg at n=16 (not a win
  yet); the node win (−~7%) cancels a memory/CPI residual (+~7% cycles/node). Full arc + revive
  plan in the "Set-associative band buckets" handoff note below. Revive for the *oversubscribed*
  regime (small-TT / n=18), gate on load factor.
- [~] Grouped-frontier `k=9..12` (lever 2) — **scoped + Phase-0/1 measured**, see
  [proposal](../proposal-2026-06-18-grouped-frontier-ddd.md). Reframe: dedup **connected
  components** (Sprague-Grundy XOR), not whole graphs. Phase-1: cap 7→12 = **−74% nodes** but
  **6.6× wall** (cutoff-free nimber recursion). Parked on branch `queens-component-nimber`
  (abf38ee). Gated-B dropped (no cheap reuse proxy). Revival = dense nimber-≤8 table. See note below.
- [x] **Dense nimber-≤8 pre-check measured** (`count --comps` extended): leaf-resolver framing is
  **dead** (~0.4–0.8% incremental over W8 — maxc≤8 ⇒ pc≤8 already); coverage lives at maxc 9–12
  (dense-infeasible).
- [x] **Salvage de-risked → also DEAD** (component-nimber size histogram, branch `queens-nimber-derisk`
  `b6c6b01`): cap-12 wall tracks the MISS count (99.8% sizes 9–12); a ≤8 table removes 0.2% of it. cap-8
  (fully ≤8-table-able) is already 1.59× and adds 0.8% over W8. **Cost-zeroing via dense nimber tables is
  finished** — Sprague-Grundy nimbers are cutoff-free and the value-bearing components are 9–12. Fork
  collapses to per-unit-cost reduction (n=16) / n=18 enablers. See note below.
- [x] **Measurement #0 (deep-node cost disambiguation) DONE** (2026-06-19--1): Zen5 topdown verdict =
  **co-dominant (a) memory ≈35% + (b) frontend/i-cache ≈35%; (c) recursion/RAS measured-DEAD** (return-
  mispredict 0.003%). Reroutes the queue — see the dated note + rewritten QUEUED NEXT WORK #0/#1/#1b.
- [x] **SMT A/B DONE** (2026-06-19--1): the 44.8 i-cache MPKI is BOTH — ~16 intrinsic body-footprint + ~28
  SMT-L1i-thrash; SMT a weak deal (+46% 2nd-thread) but keep it (aggregate wins wall). Body-shrink justified.
- [x] **(b) lever #1 — PROVE_LOSS collapse SHIPPED** (2026-06-19--1): vestigial const generic that doubled
  the hot body → removed → **i-cache MPKI −74% (44.7→11.8)**, CPI −0.8%, value-preserving, gate-clean.
  Modest throughput (frontend-latency was SMT-hidden) but free + de-risks the SMT question. See the result
  table in the measurement-#0 note.
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

### Set-associative band buckets (lever 4) — parked on branch, break-even at n=16 (2026-06-18)

**Session**: 2026-06-18--5 — `mi`. **Branch: `queens-tt-assoc-buckets` (76c2b7e), NOT merged to main.**
Do **not** revert (user's call); revive in the oversubscribed regime.

**What it is.** `QUEENS_TT_ASSOC=1` (requires `QUEENS_TT_SEGMENT=1`): each band probe maps to an 8-way
**cache-line bucket** (`M_SEG_ASSOC`) instead of one slot, so a collision only evicts when all 8 ways
are full — fewer conflict misses → fewer re-expansions. Flat/seg paths stay byte-identical (`const MODE`).

**The arc (every step measured/profiled — a clean "fix one bottleneck, expose the next" story):**
- **Rough scalar:** n=16 **29.8 M/s** vs seg **34.5** (−14%). But **−8% nodes** — the conflict-eviction
  reduction works; assoc does *less* work, just pays too much per node.
- **Pressure sweep** (n=14, TT size 18→26 bits): node win is the textbook associativity curve —
  −2.9%/−4.7%/−6.3%/**−7.3%**/−2.6%, peaking at **moderate-high load** (seg fill ~74–99%). **n=16/17 GB
  (fill 88–91%) sits in the sweet spot.** Gate knob = **load factor**.
- **Profile (rough):** the slowdown is **100% instruction count** — instr/node **1886 vs seg 1620**
  (+16%), branch/node +28%, but **CPI flat** (1.078 vs 1.097) and dTLB/brmiss flat. Frontend-bound →
  SIMD-able.
- **AVX-512 SIMD scan** (`get_assoc_avx512`/`probe_assoc_avx512`: one `__m512i` load + `cmpeq`/`test`
  masks): **31.1 M/s**. Residual = the put's *blocking* vector load (seg's put is a blind store).
- **Amortised get+put** (`probe_assoc` returns hit **and** the put-target slot in one scan; `store_slot`
  is a bare store): **33.0 M/s**. Reprofile: instr/node **1641 ≈ seg 1614** and branch/node *below* seg —
  the instruction overhead is **gone**. But CPI rose to **1.160 vs seg 1.099** (+5.6%), driven by **+25%
  L1-misses** (the wider 100%-full bucket working set + 512-bit line loads). **The bottleneck shifted
  from frontend to memory.**

**Net at n=16/17 GB: a wash.** cycles/node assoc 1903 vs seg 1774 (+7.3%) ≈ cancels the −7% node win.
A/B mean 33.0 vs seg 35.4 — lands slightly behind within the ±18% node-count noise. **Not a win yet,
not a loss.** The −14% rough gap is closed to break-even.

**Why park, not ship:** at n=16/17 GB eviction isn't binding (re-exp ~1.0–1.15×), so the node win is
small and the memory residual eats it. assoc's home turf is the **oversubscribed** regime — small TT or
**n=18** — where re-exp is high, the node win is large (−7%+), and seg's eviction is worst.

**Revive plan (for n=18 / small-TT):** (a) gate assoc on **load factor** (auto-on above ~50–70% fill,
off below — keeps seg the n=16 default); (b) attack the memory residual — try **4-way** (half-line,
256-bit load, smaller working set) vs 8-way, and check whether the amortised blind-put's *stale
get-time slot* under 24-thread churn is eroding retention (the node win was −7% in the reprofile run but
−2% in the A/B mean — measure cleanly). Gate as ever: `solve 12 iso-flat --distinct` = 1,060,823,
`iso_window_agrees` with `QUEENS_TT_SEGMENT=1 QUEENS_TT_ASSOC=1` under znver5.

**Method banked:** "nothing new ever works" — the rough first cut was −14%; profiling (instr/node + CPI,
node-count-independent on n=16) localised it to instructions, SIMD+amortisation removed them, and the
residual is now memory. Each cheapening was measured, not assumed. Code: `tt.rs` (`probe_assoc`/
`store_slot`/`*_avx512`/`bucket_base`, `TT_ASSOC_WAYS=8`), `iso_flat.rs` (`M_SEG_ASSOC`, the `wins_inc`
amortised get/put, `par_tt_*` assoc arms).

### Grouped-frontier scoped + component-nimber measured-negative (2026-06-18--5)

**Session**: 2026-06-18--5 (`6ce66d48-a531-4220-b0b1-270ac723c3eb`) — `mi`.
**Commits (main)**: `c40fd04` (assoc doc) · `fe29fdc` (DDD proposal + Phase 0) · `1a34ad6` (Phase 1
measured). **Branches (off main, do NOT revert)**: `queens-tt-assoc-buckets` (76c2b7e),
`queens-component-nimber` (abf38ee).

**Completed this session:**
- Lever 4 (set-assoc buckets): full SIMD+amortise arc → break-even with seg at n=16; parked (note above).
- Lever 2 (grouped-frontier): scoped ([proposal](../proposal-2026-06-18-grouped-frontier-ddd.md)) +
  Phase 0 (coverage) + Phase 1 (cost). **Verdict: node lever is huge (−74% at cap-12) but
  wall-bound** by the cutoff-free nimber recursion (6.6× at n=14; cap-7 already net-negative).
  Gated-B dropped (Spearman of every cheap per-root reuse proxy ≤0.54 < 0.7).

**The triangulated throughline (3 independent angles now agree):** at n=16/17 GB the wall is
**per-node cost**, and every node-count lever has a big node win that the per-unit cost eats —
set-assoc (−7% nodes, +7% cycles/node), component-nimber (−74% nodes, +6.6× wall), graph-iso win/loss
key (banked −2.2×). **n=16/17 GB is per-unit-cost-bound, not coverage- or capacity-bound.**

**NEXT SESSION — the two ways out (user's steer: "target these well, or zero the cost"):**
1. **Zero the cost** (preferred — removes the wall instead of dodging it):
   - **Dense nimber-≤8 table** = W8 but storing the 4-bit Grundy value (~128 MiB over 2^28 labelled
     8-graphs, pre-pass). Turns multi-component resolution into *decompose → dense lookup → XOR*, **no
     recursion** → kills the lever-2 cost killer. **First measure** its *incremental* value over
     iso-window (only the multi-component, all-comps-≤8, whole-pc>8 fraction is new — single-component
     ≤8 is already done by W8/tiny). Cheap pre-check: extend `count --comps` to tally *that* fraction.
   - For lever 4: a cheaper bucket (4-way / 256-bit) to shrink the memory residual that ate the win.
2. **Target well** (gate to where the win survives the cost):
   - Both levers win in the **oversubscribed** regime (small-TT / n=18: high re-exp, big node win,
     worst eviction). Gate **on load factor** (assoc) / **on a per-position fragmentation signal**
     (component oracle). Caveat from this session: cheap *per-root* proxies are flat (ρ≤0.54) — a
     useful gate must be **per-position** (largest-component size, fill level), not per-root.
   - The clean experiment: re-A/B both levers at a deliberately small TT / extrapolate to n=18, where
     the node win is largest and the per-unit cost is repaid.
3. Else: the roadmap's capacity levers (**BuRR archive**, **1 GB hugepages**) — but note this session
   showed n=16 is *not* capacity-bound, so weight these below the cost-zeroing work.

Method banked: Channel-Fermi caught Phase-0's coverage-looks-great / Phase-1 cost-kills-it gap — always
napkin the *per-unit cost*, not just the count. `count --comps`/`--roots` size these levers with **no
solver change** — use them before building.

### Dense nimber-≤8 pre-check MEASURED — the leaf-resolver framing is dead, but a salvage (2026-06-18--6)

**Session**: 2026-06-18--6 (`c46f7fdd-d044-4bd9-a7cf-7bdd31a3037f`) — `mi`. Ran the cheap pre-check the
"zero the cost" path called for: extended `count --comps` to tally the **incremental** coverage a dense
nimber-≤K table buys *over iso-window* (new pub `Queens::component_profile` + `comps_dense_nimber_coverage`
in `comps_report`). iso-window's W8 already leaf-resolves **every pc≤8** position, so the table's only NEW
contribution is the **multi-component, pc>8, all-comps-≤K** region.

| metric (share of the pc>8 region iso-window *recurses* on) | n=12  | n=14  |
|------------------------------------------------------------|-------|-------|
| nimber-**≤8** new leaves (pc>8 ∧ maxc≤8)                    | 0.47% | 0.81% |
| nimber-≤10 new leaves (pc>8 ∧ maxc≤10)                     | 44.8% | 37.5% |
| nimber-≤12 new leaves (pc>8 ∧ maxc≤12)                     | 62.5% | 61.0% |

(Absolute: n=14 = 49.76 M D4-distinct; pc>8 = 45.5%; the new ≤8 region = 0.37% of distinct, **98%
2-component**. Both runs second-player, gate-clean.)

**Verdict — the dense nimber-≤8 table as a *main-search leaf-resolver* is dead (~0.4–0.8%).** Reason: a
position with maxc≤8 almost always has total pc≤8 too (it's one small component, or a couple of tiny ones),
which W8 *already* resolves in one lookup. The genuinely-new case (pc>8 with **all** components ≤8 ⇒
multi-component) is vanishingly rare — the queen graph fragments *late*, so while pc>8 the available graph
is still dominated by **one big component**. The recursing region is single-big-component, not
many-tiny-component.

**Where the coverage actually is: maxc 9–12 (37–61% of the recursing region) — and a dense *labelled*
table can't reach it** (≤10 = 2⁴⁵ codes ≈ 4 TB; ≤12 = 2⁶⁶). So "dense nimber table" and "the coverage
that matters" are disjoint. This kills option-1 *as written*.

**The salvage (the one way the dense ≤8 Grundy table earns its keep) — combine the two parked levers.**
Use the dense ≤8 Grundy table NOT in the main search but as the **base case of the cap-12 component-nimber
oracle** (branch `queens-component-nimber`). Phase-1's 6.6× wall is the *cutoff-free mex recursion* (no
α-β: every child must be evaluated). That recursion is exponential and bottoms out in ≤8 components; a
dense ≤8 Grundy table (128 MiB, W8-style one-time build) makes every ≤8 node in it a single lookup,
collapsing the bulk of the recursion's nodes. Channel-Fermi: if "≤8 free" cuts the cap-12 nimber recursion
from 6.6× toward ~1×, the −74%-node lever flips net-positive and becomes the sub-2m44s path. **Untested —
needs the build+measure; multi-session; decide with user.** The existing oracle bottoms at the ≤7 *tiny*
table (iso-keyed, memoised) — already cheap for ≤7 — so the increment to test is specifically the dense
**≤8 Grundy** base case (Grundy-valued, not W8's win/loss) shortcutting the 8–12 layer.

**Instrumentation landed** (cold-only, gate-clean, lineage + n=12 distinct 1,060,823/1.24× hold): rerun any
n via `queens count <n> --comps` → new "dense nimber-≤K coverage" block. `component_profile` is a single
fused decomposition pass (pc + maxc + ncomp).

**NEXT — user's steer needed (genuine fork):** (a) build the dense ≤8 **Grundy** base case for the cap-12
oracle and re-measure the 6.6× — the only live "zero the cost" path; or (b) drop cost-zeroing and go
"target well" (oversubscribed / n=18 regime, gate on a per-position fragmentation signal); or (c) capacity
levers (BuRR / 1 GB hugepages, weighted low — n=16 is not capacity-bound).

### The salvage was DE-RISKED and is also DEAD — cost-zeroing via dense nimber tables is finished (2026-06-18--6 cont.)

Rather than build the dense ≤8 Grundy table blind, I ran the cheap de-risk the salvage called for: a
per-component-size histogram of `comp_nimber` **invocations** (TT-probes) and **MISS-computations**
(cutoff-free expansions) under the ported cap-12 oracle (branch `queens-nimber-derisk`, `b6c6b01`, off
main — adds `COMP_NIMBER_MAX=12` + WL key for 8..12 + the histogram; `QUEENS_NIMBER_ORACLE=1
QUEENS_NIMBER_K=<k>`). **n=14 iso-flat, single runs, all second-player:**

| cap  | wall  | vs base | invocations | MISS-computations | ≤8 inv share | ≤8 miss share |
|------|-------|---------|-------------|-------------------|--------------|---------------|
| base | 1.80s | 1.00×   | —           | 0                 | —            | —             |
| 7    | 1.98s | 1.10×   | 1.10 M      | 1,217             | 100%         | 100%          |
| 8    | 2.86s | 1.59×   | 7.77 M      | 13,492            | 100%         | 100%          |
| 10   | 3.97s | 2.21×   | 32.8 M      | 1,244,246         | 74.1%        | 1.1%          |
| 12   | 5.62s | 3.12×   | 103.7 M     | 5,963,747         | 84.0%        | 0.2%          |

(The Phase-1 "6.6×" was vs a different/iso-window baseline; vs iso-flat here it's 3.12× — same verdict,
net-negative, monotone in cap.)

**Why the dense ≤8 Grundy base case can't save it — the wall tracks the MISS count, which is 99.8%
sizes 9–12 at cap-12, and a ≤8 table touches none of those.** The ≤8 components are a *tiny bounded set*
(cap-8 = only 13 K distinct misses — there are ~11 K connected 8-graphs total), computed once and then
re-looked-up (the 84% ≤8 *invocation* share is re-hits, the cheap part). The value-bearing caps (≥10) are
dominated by **millions of distinct 9–12 components**, each needing its own cutoff-free mex expansion — the
expensive part — and those nimbers can't be tabulated cheaply (too many distinct; computing them *is* the
cost). A dense ≤8 table removes 0.2% of cap-12's misses and only cheapens the inner ≤8 *probes* of each
9–12 expansion; even a generous probe-latency model leaves cap-12 net-negative (~2×). And cap-8 — the one
cap a ≤8 table fully serves — adds only **0.8%** coverage over iso-window's W8 (the earlier pre-check), so
even a break-even cap-8 is worthless.

**Fundamental reason (the throughline):** decomposition needs **nimbers** (for the XOR composition of
independent games), and nimbers are **cutoff-free** (no α-β — the whole point of a P-position is you must
refute every move). The value-bearing components are 9–12, and their nimbers are exactly what can't be
cheaply precomputed. Decomposition trades cheap α-β win/loss for expensive nimbers precisely where it would
help. **No dense table fixes this** — it's Sprague-Grundy, not an implementation gap. Cost-zeroing via
component decomposition is **measured-dead from three angles: coverage (0.8%), miss-count (99.8% at 9–12),
and wall (monotone net-negative).**

**Scope of this verdict (what it does NOT kill):** only the component-**nimber/oracle** (cost-zeroing,
resolve-without-recursion) lever is dead. The separate component-**merge-key** (capacity: key positions by
their component-multiset to merge more transpositions → fit RAM → re-exp 1.0) is a *different* lever and was
NOT measured here — though note iso-window's `iso_key_fast` ALREADY folds per-component canon keys, so much
of that merge is likely already captured. Treat the older burr-state note's "component table = the <20min
lever" as the capacity merge-key in the RAM-bound burr regime — untested-and-partly-superseded-by-iso-window,
not confirmed.

**So the fork collapses to (b)/(c).** Cost-zeroing (a) is closed. n=16 is per-unit-cost-bound, and the
remaining real levers are:
- **Per-unit-cost reduction** in the *main* search — the micro-opt / segmented / set-assoc family that
  already delivered +16% this session. This is where the next n=16 win lives (revisit lever 4 set-assoc,
  PGO, frontend/L1i shaves). Decomposition is not it.
- **n=18 enablers** (decompose, BuRR, 1 GB hugepages) — but note the de-risk shows component-nimber's
  *cost* scales with the distinct-component count, which grows with n too; it is unlikely to flip even at
  n=18. Weight set-assoc (real −7% node win, memory-residual-bound) above it for the oversubscribed regime.

---

## Session 2026-06-18--6 → 2026-06-19: per-node micro-opt sweep + the throughput thesis

**Session**: `c46f7fdd-d044-4bd9-a7cf-7bdd31a3037f` — `mi`. Continues after the component-nimber
de-risk (above). User steer: "micro-opt the hell out of it" + 7 parallel research sub-agents +
the throughput observation below. **Commits (main)**: `5816c14` (branchless tiny_edge_code — the
one win) · `30a9d58` (filter_bench microbench + measured-negative note). Earlier in the same
session: `39f184f`/`6a299e3` (nimber cost-zeroing dead, documented above).

### PART A — THE DATA (facts; measured, low interpretation)

**Profiling (n=16 iso-window, the champion; full 16 GB TT; perf on this znver5 box):**
- `perf stat` (90s partial): IPC **0.90 / CPI 1.13**, **frontend-idle 27% of cycles**, branch-miss
  **10.1% of branches** (~15% of cycles), **L1d-load-miss 1.0%**, 40.9 M/s. (Note: LLC-miss /
  memory-bound topdown were NOT measured — the DRAM/probe cost is uncharacterised.)
- `perf record` cycles by symbol: `wins_inc` ~50%, `band_entry` ~20%, `w8_get` ~6%.
- `perf record` branch-misses by symbol: `band_entry` ~50%, `wins_inc` ~20%, `w8_get` ~7%.
- `perf annotate band_entry`: `tiny_edge_code` `code |= edge_bit(...)` **31%**, vert-extraction
  (`verts[n]=v`/`while w`/`n+=1`) **~32%**, `tiny_get` atomic_load **8%**, attack-row load 7.7%.
  `solve_local` is **<2%** of cycles (did not make the ≥2% symbol list).
- `perf annotate wins_inc`: move-availability (`avail_has8`/`filter_moves`: `sq>>6` 23.8%,
  `nc+=avail_has8` 20.1%, loop 3.8%) **~52%**; **`child0==Bits::ZERO` raw_eq 20.5%**; `lex_min8`
  (`for cand in o[1..]` 15.5% + `if cand<best` 7.3%) **~23%**.
- **Structural fact:** `iso_flat_key_max_avail()` defaults to **7**, so the WL `comp_canon`/`wl_refine`
  graph key is **dead in production**. The live per-node path is: `lex_min8` D4 key for pc≥9
  (`wins_inc`), `band_entry`→`enter_graph`→`solve_local` for pc≤7, `w8_get` for pc==8.

**Micro-opt scorecard — every change A/B'd interleaved on n=16 iso-window** (CPI/branch-miss are
node-count-independent; M/s is the throughput; value-preserving changes also compare M/s directly):

| change | CPI | branch-miss% | M/s | other | verdict |
|--------|-----|--------------|-----|-------|---------|
| branchless `tiny_edge_code` | 1.129→1.101 (−2.5%) | ~flat | ~flat | value-preserving | **SHIPPED** `5816c14` |
| SIMD-gather `lex_min8` | 1.110→1.275 (+15%) | — | 41.0→37.4 (−9%) | instr −12% | reverted |
| `pc==0` reorder (drop `child0==ZERO` raw_eq) | 1.107→1.116 (+0.8%) | flat | 41.3→41.0 | — | reverted (wash) |
| drop `tiny_tt` (always `solve_local`) | — | — | n14 wall +22% | re-exp 1.25→6.73× | reverted (loss) |
| BITALG move-filter (`vpshufbitqmb`+`vpcompressb`, thr 16) | 1.106→1.167 (+5.5%) | 10.19→9.87 (−3%) | 41.9→42.2 (+0.7%) | — | reverted (wash) |
| pext edge-code (`tiny_table_index`) | 1.108→1.072 (−3%) | 10.15→8.66 (−15%) | 42.05→33.94 (**−19%**) | instr +~20% | reverted (loss) |

- `tiny_tt` drop measured on n=14 iso-flat wall (5 rounds: base 1.73–1.78s, drop 2.10–2.19s) +
  the `--distinct` re-exp gate (iso-flat is required for `--distinct`; iso-window has no distinct counter).
- **Microbench `filter_bench.rs`** (committed): scalar vs BITALG move-filter break-even ≈ **14 moves**
  (BITALG 0.48× @len4, 0.97× @12, 1.23× @16, 2.2× @32, 4.5× @256). Flat ~3.6 ns / 64-move chunk.

**The throughput observation (user's run):**
- `/tmp/queens_drop solve 16 iso-window` (USE_TINY_TT=false drop binary): **22.6 B nodes / 53.29 s =
  424 M/s** (interrupted). Baseline (`/tmp/queens_tec_base`, tiny_tt ON) ≈ **42 M/s** (3.36 B / 90 s).
- Drop binaries identified by the n=12 `--distinct` re-exp: drop 6.72×, baseline 1.25×.
- So in ~equal wall the drop does ~10× the nodes at ~10× the rate, but its nodes are cheap L1
  `solve_local` re-solves (no TT probe, no memoisation), and it completes **slower** (the +22% wall).

**Saved binaries (this box, /tmp):** `queens_tec_base` (baseline = main `5816c14`-era), `queens_drop`
(tiny_tt OFF), `queens_bitalg`, `queens_pext`, `queens_simd` (lex_min8), `queens_pczero`. Reproduce any
A/B directly without rebuilding.

**Research (7 sub-agent proposals, `notes/proposal-2026-06-18-*.md`):** simd-dense-dataflow (Idea A
MLP-prefetch, Idea B dense-blocks pc≤12), op-fusion + op-fusion-deep (pext/GFNI edge builds, child_orient
vpandnq, filter_moves vpcompressb, hash128 dead-words, band-entry double-decomposition fusion),
recompute-vs-store (the tiny_tt drop — measured-dead here), representation-shrink (expand_graph kids-array
dead `Bits`, hash128 dead-words), parallelism-chokepoints (Amdahl ceiling ~9 s / ~5.5%; env-only
PAR_MIN_AVAIL/AFFINITY sweeps untried on iso-window), hardware-fastpaths (BITALG move-filter — measured
wash here). Untried-but-proposed: hash128 drop-constant-words, child_orient vpandnq, env parallelism sweeps,
dense-blocks (Idea B), BuRR archive.

### PART B — MY INTERPRETATIONS (⚠️ caveated — I was wrong once this session; treat as hypotheses, not facts)

**⚠️ Caveat up front: I made a real interpretation error this session.** When the user reported a 352 M/s
throughput, I claimed it was the *baseline* "starting fast and decaying as the TT fills" — a TT-fill memory
wall with ~8× headroom. **That was wrong.** The number was always the **drop binary** (cheap, non-selective
≤7 re-solves). The baseline never bursts to 352/424; the arithmetic disproves it (baseline 3.36 B/90 s).
I over-fit a narrative to one polluted number. The interpretations below are my best current reading, but
weight them accordingly and measure before building.

1. **Compute micro-opts are exhausted, for two distinct reasons by region** (confidence: medium-high — six
   measured negatives/washes back it, but see caveat #3):
   - **`wins_inc` deep (pc≥9, ~50% cycles)** is dominated by a cost *invariant to per-node compute shaves*
     — every compute opt there washed (lex_min8, BITALG-filter, pc==0). That cost is *either* the random
     TT probe (LLC→DRAM) *or* frontend/i-cache (the key/dispatch). **I have NOT disambiguated which** — see #3.
   - **`band_entry` (pc≤7, ~20%)** operates on **tiny data** (k≤4 components, short move lists), where any
     fixed-overhead wide instruction (BITALG, pext) loses to the minimal scalar loop — measured: pext −19%
     (instr +20% from 4-word overhead × tiny comps), BITALG break-even ~14 but most lists are shorter.

2. **The 424 M/s is the ≤7 L1-compute rate, NOT the whole-search floor** (confidence: high). The deep pc≥9
   nodes carry irreducible compute (D4 key, dispatch, hash) even with zero DRAM, so cache-resident they'd
   run at their frontend-bound rate — faster than 42 but well short of 424. The realistic whole-search floor
   is the floor-note's **~45–60 s** (we're at 2m44s ≈ 3× over). The 424 *does* show cheap-L1 nodes are ~10×
   faster than the baseline blend — real evidence that touching the 16 GB TT is a large per-deep-node cost.

3. **UNRESOLVED: is the deep region DRAM-bound or frontend-bound?** (confidence: low — this is the load-bearing
   open question). `perf stat` leaned **frontend** (27% fetch-idle, L1d-miss 1%, and the TT probe is
   prefetched so DRAM latency may already be largely hidden). The 424-vs-42 gap is *partly a node-mix artifact*
   (drop = cheap-heavy mix), not a clean probe-cost number. **The one clean measurement that would settle it:
   LLC-load-miss + memory-bound topdown on the deep region specifically.** Do this before betting on a
   memory lever. (My earlier "DRAM is the 3× gap" was an over-claim.)

4. **The user's thesis — "don't hit DRAM TT in the inner loop; pack it small + cache-resident" — is sound
   in direction** (my read), **but a naive shrink fails**: the working set is ~5 B distinct positions; a
   tens-of-MB cache holds ~millions of slots → eviction explosion (the TT-size sweep already measured the
   wall going *flat* on shrink — TLB win cancelled by re-expansion). So it needs a **denser representation**,
   not a smaller array. Two forms realise it: (a) **dense-blocks** — solve pc≤12 subtrees in L1 like
   `solve_local` does ≤7, *with* memoisation, removing the DRAM probe for the bulk of the deep region while
   keeping selectivity (the drop got throughput by *dropping* selectivity; this keeps it); (b) **BuRR archive**
   (~1.1 bit/key, eviction-free) packs the resident set ~50× toward cache-residency. Both are roadmap items.

5. **Recommended next step (my view):** measure #3 first (one perf run, deep-region LLC/memory-bound) to
   confirm and size the DRAM prize, *then* scope **dense-blocks (Idea B)** as the principled lever — it
   attacks both the probe and the per-node compute, so it is robust to whichever #3 turns out to be.
   `hash128` drop-constant-words is the one remaining compute opt not in the small-data trap (critical-path,
   not memory-mix), but ~5% and partly latency-hidden — low priority. Parallelism env-sweeps are ~5.5%
   ceiling, zero-risk, untried on iso-window.

### Method banked this session
- **High perf-attribution ≠ removable cost.** `child0==ZERO` raw_eq showed 20.5% of `wins_inc` but the
  pc==0 reorder was a wash — the 20.5% was the load-to-use *stall* on `child0`, not the compare. A heavier
  first-consumer (popcount) eats the same stall. Verify with an A/B; don't infer removable cost from a hot line.
- **Wide instructions lose on small data.** BITALG (short move lists) and pext (k≤4 comps) both lost their
  fixed setup to minimal scalar loops. The queens hot regions are small-data — SIMD/pext only pay on the
  rare long-list / large-component tail.
- **Identify which binary produced a number before interpreting it.** The 352/424 confusion came from not
  checking that `target/release/queens` was the drop build at the time. Tag binaries (re-exp is a free
  fingerprint: drop 6.7×, baseline 1.25×).

### Added interpretation (user, 2026-06-19): recursion / stack-unwind cost — a THIRD hypothesis

The deep-node cost has **three** candidate explanations, not two. Why the baseline's deep pc≥9 nodes are
~10× slower than the drop's cheap ≤7 nodes could be:
- **(a) TT DRAM probe** — random access into the 16 GB table (but prefetched; L1d-miss only 1%, so maybe
  largely hidden — uncharacterised at LLC/DRAM level).
- **(b) key-compute / i-cache** — `child_orient`+`lex_min8`+dispatch+hash per node (frontend-bound, 27%).
- **(c) recursion / stack machinery (user's hypothesis)** — the recursive DFS pays a call + prologue/
  epilogue + frame spill + **return-address-stack-predictor** cost per level, and `wins_inc` is a *large*
  function (the full pc==8/≤7/iso/else ladder + both PROVE_LOSS and non-prove arms), so each deep call
  re-fetches a big body → i-cache/frontend pressure that *scales with selectivity* (a selective search
  recurses deep; the drop's cheap re-solve recurses shallow over the tiny `solve_local` body). This would
  *also* present as the measured frontend-idle 27% — (b) and (c) are entangled in that number.

**Caveat (mine): (b) and (c) are not yet separated, and (a) is unmeasured.** All three are consistent with
"compute micro-opts wash" and with "424 cheap-L1 ≫ 42 deep." The disambiguating measurement is the first
queued item. **Implication if (c) dominates:** unrolling the recursion into an explicit-stack iterative
loop (and/or splitting `wins_inc` so the hot inner body is small) is the lever, independent of the TT.

## QUEUED NEXT WORK (prioritised; this work stream)

0. **[DONE 2026-06-19--1] Disambiguate the deep-node cost.** Zen5 topdown (`perf stat -M
   PipelineL1,PipelineL2`, n=16 steady-state, `-D 30000` skips warm-up) + return/icache/dram raw counters.
   **Verdict: co-dominant (a) memory ≈35% AND (b) frontend/i-cache ≈35%; (c) recursion/RAS measured-DEAD**
   (return-mispredict 0.003%). Full table in the dated note below. **This reroutes the queue:** the unroll's
   (c) justification is gone; the two real levers are *hide-the-DRAM* (a) and *shrink-the-i-cache-footprint*
   (b). Both are present in ~equal measure, so a single-barrel lever caps at ~half the deep-region stall.
1. **[PARTLY DONE — PROVE_LOSS collapse SHIPPED (i-cache MPKI −74%); remaining (b) is smaller now]**
   Shrink the `wins_inc` i-cache footprint (attacks (b)). The unroll's (c)/RAS rationale stays dead. **DONE
   this session:** collapsed the vestigial `PROVE_LOSS` const generic → one hot body instead of two →
   **i-cache MPKI 44.7→11.8 (−74%)**, CPI −0.8%, frontend −1.4 pts, value-preserving (committed). It also
   largely fixed the SMT-L1i-thrash (SMT-on now 11.8 MPKI < the old SMT-off 16). **Still open (smaller):** the
   residual ~12 MPKI / ~26% frontend-latency is now mostly *not* duplication — it's the inlined helper chain
   (`child_orient`/`lex_min8`/`hash128`) + the 4-way dispatch ladder + the rest of the call graph
   (`band_entry`→`enter_graph`→`solve_local`, `w8_get`). Next body-shrink candidates: `#[inline(never)]` on
   `lex_min8`/`child_orient` (one shared out-of-line copy vs inlined-per-site — measure, call overhead may
   cancel), or splitting `band_entry`'s tail cold. **Diminishing** — frontend-latency is only partly
   removable (much was SMT-hidden), so expect ≤1-2% each. The explicit-stack unroll survives only as the
   MLP vehicle for (a) (next item), not a (c) fix.
1b. **Hide the 35% DRAM (a) via MLP-batched TT gets** — the explicit-stack/frontier restructure from the
   prune-stall note, but now justified by **measured 35% backend-by-memory + ~1.9 DRAM fills/node**, NOT by
   (c). Batch independent child gets at the AND/prove-loss levels, prefetch the batch, overlap the DRAM
   latency the serial recursion exposes one-at-a-time. Bigger/riskier than #1; the compiler-prefetch is
   clearly under-hiding (memory is the single largest bucket). Or subsume into dense-blocks (#2), which
   removes the probe entirely for pc≤12.
2. **Dense-blocks (Idea B, pc≤12 win/loss in L1, memoised)** — converts deep nodes to cheap L1 block-solves
   *with* selectivity (the drop got throughput by dropping selectivity; this keeps it). **Attacks both
   measured costs at once** — removes the DRAM probe (a, 35%) AND collapses the deep node to the tiny
   `solve_local`-class body (b, the i-cache footprint) for the pc≤12 region. The principled both-barrels
   lever now that #0 confirms (a)+(b) co-dominate. Multi-session; scope it.
   See `notes/proposal-2026-06-18-simd-dense-dataflow.md` Idea B (gate on the distinct-reachable-boundary
   footprint pre-check first).
3. **BuRR archive (~1.1 bit/key, eviction-free)** — packs the resident set ~50× toward cache-residency
   (the user's "pack small + cache" thesis, the form that survives the eviction tension). Roadmap Chunk-4.
4. **hash128 drop-constant-words** — the one compute opt not in the small-data trap (critical-path, not
   memory-mix). ~5%, partly latency-hidden; needs `TT_HASH_ID` bump + re-exp re-validation. Low priority.
5. **Parallelism env-sweeps** (`QUEENS_PAR_MIN_AVAIL`, `QUEENS_AFFINITY=off`) — ~5.5% Amdahl ceiling,
   zero-risk, env-only; the old "#20 wash" was on the D4 solver, never re-validated on iso-window. Quick.

**Saved binaries for any A/B (this box, /tmp):** `queens_tec_base` (baseline), `queens_drop` (tiny_tt OFF,
424 M/s), `queens_bitalg`, `queens_pext`, `queens_simd`, `queens_pczero`. `filter_bench` (committed) is the
move-filter microbench harness; clone its shape for the dense-block / unroll microbenches.

### Prune-stall + TT-put batching → they converge on one structural lever (design note, 2026-06-19)

Two user questions — "structurally reduce the stall a prune costs" and "batch TT puts" — have the same root
answer: **the recursive DFS is a serial random-access-latency chain (get → stall → decide → recurse → put),
exposing one memory op at a time; an explicit-stack / frontier form lets us keep N independent ops in
flight (MLP), hiding the latency the recursion serialises.** Detail:

- **What a prune actually costs.** A TT-hit or α-β cutoff means "don't expand" — but you still paid (i) the
  **get latency** to *discover* the hit (you stall on the get before the hit/miss branch), and (ii) on
  return, the **stack unwind** (N call-frame pops + return-stack-predictor pressure). Pruning removes the
  *expansion*, not the latency — so a prune-heavy (selective) search is dominated by get-latency + unwind.
- **Lever 1 — explicit-stack unroll removes the unwind** (queue #1): a prune just pops the work-stack; no
  N-frame call/return unwind, no big-`wins_inc`-body re-fetch per level. Directly addresses cost (ii).
- **Lever 2 — the unroll *enables* batched-prefetch MLP** (the synergy): a *recursive* DFS can only
  prefetch one-ahead; an explicit work-stack lets you **push a batch of children, prefetch all their TT
  slots, then pop+process in cutoff order** — N gets in flight, their latency overlapped. Addresses cost
  (i). The clean place is the **AND / prove-loss levels** (all children needed → no cutoff to lose → the
  full batch is always consumed → zero wasted prefetch).
- **TT puts (the second question).** Puts are Relaxed *posted* stores (store-buffer-absorbed) **except** a
  deep node's put lands long after its get — the line is usually **evicted**, so the put pays a
  **Read-For-Ownership** (write-allocate fetches the line from DRAM before writing). So deep puts *do* hit
  DRAM. Batching random-slot puts does **not** avoid RFO (different lines), and non-temporal stores hurt
  (TT entries are re-read by transpositions). BUT in the iterative/frontier form, collecting a batch of
  puts and issuing them together **pipelines the RFO reads (MLP on the writes too)**, the same way batched
  gets pipeline — so put-batching is real *only as part of* the iterative restructure, not standalone. And
  **gets matter more than puts** (gets are on the critical path; puts are posted) — batch gets first.
- **Unifying structural change:** an explicit-stack DFS (or bounded frontier) that batches the independent
  memory ops at the AND levels → MLP hides the random-access latency the recursive form exposes serially.
  The unroll (queue #1) and the batched get/put MLP are the *same* restructure; do them together.

**⚠️ Gate this on measurement #0.** If the deep-node cost is **key-compute/i-cache** (frontend) rather than
**memory latency**, MLP-batching memory buys little — the lever would instead be shrinking the per-node body
/ dense-blocks. The disambiguating perf run decides whether "batch the memory ops" or "shrink the compute"
is the right structural move. Don't build the batched-MLP iterative form until #0 confirms latency, not
compute, is the prune stall.

**Refined queue #1:** *unroll the recursion to an explicit work-stack, designed from the start to batch
child TT gets (and, at AND levels, puts) for MLP* — the unroll and the batching are one change, gated on #0.

### Measurement #0 DONE — deep-node cost is co-dominant (a)memory + (b)frontend; (c)recursion DEAD (2026-06-19--1)

**Session**: `7f5286e0-b949-4298-b801-0e8a1f95807a` (2026-06-19--1) — `mi`. The gating disambiguation the
whole queue waited on. **Method:** AMD Zen5 topdown via `perf stat -M PipelineL1,PipelineL2` + a second run
of return/icache/dram raw counters, both `-D 30000` (skip the 30 s warm-up to isolate the *deep/steady*
region — the `small_canon_table` OnceLock build that swamps n≤14 is fully amortised by then), on the
production champion `target/release/queens solve 16 iso-window` (clean box, full 17 GB flat TT, 1:1 affinity
pin = production config incl. SMT). ~70 s measured window each, ~50% multiplex (fine for steady high-rate
events). Raw outputs: `/tmp/perf_run1.out` (topdown), `/tmp/perf_run2.out` (raw). Reproduce via
`/tmp/perf_deep.sh`.

**Topdown (n=16 deep steady-state, CPI 1.167 / IPC 0.857 — only 9.6 % of slots retire):**

| L1 bucket        | % slots | L2 sub-bucket                  | % slots | hypothesis      |
|------------------|---------|--------------------------------|---------|-----------------|
| backend_bound    | 37.9    | **backend_bound_by_memory**    | **35.2**| **(a) DRAM**    |
|                  |         | backend_bound_by_cpu           | 2.7     | —               |
| frontend_bound   | 34.9    | **frontend_bound_by_latency**  | **26.4**| **(b) i-cache** |
|                  |         | frontend_bound_by_bandwidth    | 8.6     | (b) decode      |
| smt_contention   | 10.2    | smt_contention                 | 10.2    | SMT-sibling     |
| retiring         | 9.6     | retiring_from_fastpath         | 9.5     | useful work     |
| bad_speculation  | 7.4     | bad_spec_from_mispredicts      | 7.3     | data-dep branch |
|                  |         | bad_spec_from_pipeline_restarts| 0.1     | —               |

**Raw counters (the discriminators):**
- **(c) recursion/RAS = DEAD.** `ex_ret_near_ret_mispred` = **620,830 of 20.08 B returns = 0.003 %**. The
  return-address-stack predictor is essentially perfect despite the deep DFS — there is **no unwind /
  return-mispredict cost to remove.** The user's (c) hypothesis and the unroll's original RAS justification
  are measured-dead. (Recursion depth never blows the RAS in a way that costs; the compiler/HW already
  handle it.)
- **(a) DRAM is real and the single largest bucket.** `ls_any_fills_from_sys.dram_io_all` = 5.39 B of 29.69 B
  total L1d fills = **18 % from DRAM ≈ 1.9 DRAM fills per node**. Cross-checks the 35.2 % backend-by-memory
  (~190 ns DRAM in a ~600 ns/core node ≈ 32 %). The compiler-issued prefetch is clearly **under-hiding** the
  TT probe — the earlier "L1d-miss only 1 %, maybe largely hidden" was wrong: a 1 % miss *rate* over billions
  of accesses is billions of exposed DRAM trips, and they land as the top topdown bucket.
- **(b) frontend is i-cache-latency-driven.** i-cache misses **191.98 B → 44.8 MPKI** (very high); the
  frontend-latency bucket (26.4 %) is 3× the decode-bandwidth bucket (8.6 %), so the frontend stalls are
  **fetch bubbles, not decode width** — the large monomorphised `wins_inc` body (+ dispatch ladder, + the
  prove-loss/non-prove duplication) blows L1i. op-cache miss 24.6 B (lower — when code is in the op-cache it
  serves; the i-cache behind it thrashes). **Open question:** how much of the 44.8 MPKI is the 24-thread SMT
  pinning (two siblings sharing one L1i per physical core — also the 10.2 % smt_contention) vs the raw body
  footprint. Cheap follow-up: A/B 12 physical-core pin vs 24 logical.
- **bad_speculation (7.4 %) is data-dependent branches, not returns.** `ex_ret_brn_misp` = 50.4 B / 448.6 B =
  **11.2 % branch-mispredict** — the game-tree cutoff/`lost`-break / `child0==ZERO` branches (irreducible
  branching of a selective search), confirmed distinct from the (dead) return mispredicts.

**Cross-check against the 424 M/s drop binary:** the drop (tiny_tt OFF, all ≤7 re-solved in L1) issues **no
deep TT probe** (kills a) and runs the **tiny `solve_local` body** (kills b) → ~10× faster. Removing exactly
the two measured costs gives the observed ~10× — independent confirmation the deep-node cost is (a)+(b), not
(c) and not some uncharacterised fourth thing.

**SMT A/B sub-measurement (settles: is the 44.8 MPKI body-footprint or SMT-L1i-thrash?).** Same mechanism
(`QUEENS_AFFINITY=off` + `taskset` + `RAYON_NUM_THREADS`), only SMT sharing differs. A = 24 threads on 24
logicals (0-23); B = 12 threads on 12 physical cores (0-11, no sibling). `/tmp/perf_smt{A,B}.out`,
`/tmp/perf_smt.sh`. (A reproduces production: frontend 35.4 %, mem 33.8 %, smt 10.3 %, MPKI 44.3 — matches
run1, validating the mechanism.)

| metric                     | A: SMT on (24t) | B: SMT off (12t) | read                                   |
|----------------------------|-----------------|------------------|----------------------------------------|
| i-cache MPKI               | 44.3            | **16.0** (−64 %) | ~28 MPKI is SMT-thrash, ~16 intrinsic  |
| frontend_bound_by_latency  | 26.9 %          | 23.0 %           | net stall barely drops (sibling hid it)|
| backend_bound_by_memory    | 33.8 %          | 36.1 %           | (a) is SMT-independent                 |
| smt_contention             | 10.3 %          | 0.0 %            | sanity: B truly has no sibling         |
| CPI                        | 1.17            | 0.94            | single-thread-per-core is much cleaner |
| M/s aggregate / per-thread | 40.9 / 1.70     | 28.0 / **2.33**  | SMT 2nd thread adds only +46 % agg     |

**Verdict:** (b) frontend is **BOTH** — an intrinsic ~16 MPKI body-footprint (the `wins_inc` body overflows
L1i even single-threaded) AND ~28 MPKI of SMT-sibling L1i-thrash on top (the sibling hides much of it, so net
frontend stall only worsens ~4 pts). **So body-shrink is doubly justified** — it cuts the intrinsic 16 MPKI
*and* shrinks the thrash footprint → better SMT scaling (recovering some of the poor +46 % 2nd-thread
return). **Keep SMT on** (40.9 > 28.0 aggregate wins wall-clock), but it's a weak deal on this frontend-bound
kernel. (a) memory is unchanged by SMT (~35 % both) — the memory lever is orthogonal.

**Concrete (b) lever identified (the production-instantiation footprint bloat):** `wins_inc`'s `PROVE_LOSS`
const flips every recursion level (line 746 → `false`, 791 → `true`), so **two near-identical full copies of
the ~90-line move-loop + 4-way dispatch body are hot simultaneously** (2× L1i). The two arms (715-756 vs
758-801) are behaviourally identical — pure OR-search, break on first child-loss; `PROVE_LOSS` is vestigial
YBWC even/odd-parity bookkeeping that doesn't affect the sequential node set. **Collapsing it halves the
hot-recursion footprint.** Value-preserving (gate: `solve 12 iso-flat --distinct` = 1,060,823 + lineage);
A/B the MPKI + frontend-latency + M/s.

**RESULT — SHIPPED (2026-06-19--1).** Collapsed `PROVE_LOSS` out of `wins_inc` (one body, not two);
`wins_tiny` (dead in production) left untouched. Gate clean: n=12 exact 1,060,823 / 1.25×, n=14 ≈29.15M /
1.02×, `solver_lineage_agrees` + `iso_window_agrees_on_small_even_boards` ok. A/B = champion
(`/tmp/queens_champion`, pre-change main `9c8a833`) vs collapse, n=16 production config, 2 interleaved
rounds, `perf stat -D 30000`:

| metric (node-count-independent) | champion | collapse | Δ                         |
|---------------------------------|----------|----------|---------------------------|
| **i-cache MPKI**                | 44.7     | **11.8** | **−74 %**                 |
| CPI                             | 1.168    | 1.159    | −0.8 % (thermal-indep ↑)  |
| frontend_bound                  | 36.0 %   | 34.6 %   | −1.4 pts                  |
| frontend_bound_by_latency       | 27.5 %   | 26.2 %   | −1.3 pts                  |
| backend_bound_by_memory         | 33.1 %   | 33.7 %   | ~flat (a is orthogonal)   |

**The PROVE_LOSS duplication WAS the dominant L1i pressure** — one body cut i-cache MPKI −74 % (collapse's
SMT-*on* 11.8 < champion's SMT-*off* 16.0, so it also largely fixes the SMT-thrash: both siblings' smaller
bodies now co-reside in the shared L1i). **But frontend-latency only dropped ~1.3 pts** — those misses were
largely SMT-hidden/overlapped, so net frontend stall (hence throughput) barely moved. M/s was **thermally
confounded** (cycles declined monotonically 4.72→4.23 e12 across the 4 sequential runs = box heating;
collapse always ran 2nd/hotter in each pair, yet round-1 collapse still +2.7 %); the trustworthy read is the
thermal-independent **CPI −0.8 % = a small real throughput-per-cycle win, no regression**. Shipped as a
value-preserving cleanup: a free ~1 % + a massive MPKI reduction that **de-risks the SMT question** — the
remaining frontend cost is now ~12 MPKI / 26 % latency, mostly *not* the duplication. **Method note:** −74 %
MPKI but only ~1 % throughput is textbook "high perf-attribution ≠ proportional removable cost" — the SMT
sibling hid most of the i-cache stall, so removing the misses freed less wall than the miss-count drop
implied. Node-count-independent CPI/MPKI (not the thermally-confounded M/s) carried the verdict, as the
perf-methodology prescribes.

**Verdict & routing.** ~70 % of pipeline slots are lost to two **co-equal, separable** costs (memory ~35 %,
frontend ~35 %); only ~10 % retires. A single-barrel lever caps at ~half. The queue is rerouted (above):
- **Cheapest justified next move = shrink the i-cache footprint** (queue #1, reframed): split/`inline(never)`
  the `wins_inc` cold arms, test the SMT-L1i-thrash theory. Value-preserving, attacks the 26.4 % directly.
- **The structural lever = hide the DRAM via MLP-batched gets** (queue #1b) and/or **dense-blocks** (#2,
  which removes *both* costs for pc≤12). The unroll survives **only** as the MLP vehicle for (a) — its (c)
  rationale is retired.
- **Do NOT** build the explicit-stack unroll to fix recursion-unwind — there is nothing there to fix.

### Session wrap (2026-06-19--1) — #0 disambiguated, SMT measured, PROVE_LOSS collapse shipped

**Session**: `7f5286e0-b949-4298-b801-0e8a1f95807a` — `mi`. Resumed from `go`. **Commits (main):**
`ae8bfae` (measurement #0 verdict) · `837e614` (PROVE_LOSS collapse + A/B + handoff). Record headline
updated to **2m15s** (user run).

**Landed:** (1) Measurement #0 — the gating disambiguation: deep-node cost = **co-dominant (a) memory ~35%
+ (b) frontend/i-cache ~35%; (c) recursion/RAS DEAD** (0.003% return-mispredict). (2) SMT A/B — (b) is
intrinsic body-footprint (~16 MPKI single-thread) + ~28 MPKI SMT-thrash; SMT a weak deal but kept. (3)
**Shipped the PROVE_LOSS collapse** — i-cache **MPKI −74%** (44.7→11.8), CPI −0.8%, value-preserving,
gate-clean. Modest throughput (frontend was SMT-hidden) but free + de-risks SMT.

**NEXT (decide with user — the two real levers, both bigger than the residual (b) micro-opts):**
1. **(a) memory ~35%** — the single largest bucket, the real fish: **MLP-batched TT gets** (explicit-stack
   frontier at AND levels, overlap the ~1.9 DRAM fills/node) and/or **dense-blocks (pc≤12)** which removes
   *both* costs for that region. Architecture-level + multi-session → **ask before building.** Gate any
   design on the floor-note footprint pre-check.
2. **residual (b) ~12 MPKI / 26% latency** — now mostly NOT duplication (it's the inlined helper chain +
   dispatch ladder + the rest of the call graph). `#[inline(never)] lex_min8/child_orient` is the next cheap
   test but **diminishing** (≤1-2%, call overhead may cancel; much of the stall is SMT-hidden).
3. Capacity levers (BuRR / 1 GB hugepages) — weighted low (n=16 is per-unit-cost-bound, not capacity-bound).

**Saved binaries (this box, /tmp):** `queens_champion` (pre-collapse main `9c8a833`), `queens_collapse`
(= new main `837e614`). Perf scripts: `/tmp/perf_deep.sh` (#0 topdown), `/tmp/perf_smt.sh` (SMT A/B),
`/tmp/perf_ab.sh` (champion-vs-collapse). **Method banked:** AMD Zen5 topdown = `perf stat -M
PipelineL1,PipelineL2` (L2 maps frontend_by_latency / backend_by_memory / bad_spec_from_mispredicts onto the
hypotheses); `ex_ret_near_ret_mispred` is the clean RAS/recursion discriminator; `-D 30000` skips warm-up to
isolate the deep region; CPI/MPKI are node-count- AND thermal-independent (M/s is confounded by both — the
4-run sequential A/B showed monotonic clock decline, so trust CPI/MPKI).

### Lever (a) scoping — dense-blocks pre-check #2 PASSES, but the cross-boundary-merge crux is the real gate (2026-06-19--1)

User picked lever (a) (memory ~35%). Scoped the **dense-blocks (Idea B)** form before any solver build, per
the proposal's prescribed pre-checks. Microbench committed: `src/bin/dense_block_bench.rs` (reachable-only
win/loss DP = `solve_local` widened u8→u16 to K≤12, over random connected graphs at 3 densities; gate-free,
no solver change). `taskset -c 0 ./target/release/dense_block_bench`.

**Pre-check #1 (memo amortization) — WEAK**, from prior data: the distinct reachable boundary-graph count at
9–12 is ~millions (session-`--6` de-risk: 5.96 M distinct cap-12 components at n=14, growing with n) → tens
of MB → not cache-resident.

**Pre-check #2 (kernel cost) — PASSES (corrects an earlier scalar napkin):**

| K  | reach/2^K   | ns/block   | **ns/reach** |
|----|-------------|------------|--------------|
| 9  | 2–4.5 %     | 90–217     | ~8.5–9.3     |
| 12 | 0.5–1.5 %   | 303–807    | ~13–16       |

- **ns/reach ≈ 10–13 ns** (L1, flat across K & density) vs the **~100 ns DRAM probe** it replaces → **~8–10×
  cheaper per node.** The full-2^K-sweep fear was wrong: **reachability pruning keeps a K=12 boundary to
  ~20–60 reachable states** (not 4096), so a whole block-solve is only ~3–8 probe-equivalents. (Memo-clear of
  the 2^K array is ~10–15 % of ns/block — version-stamping removes it, so the real kernel is even cheaper.)
- So **mechanically dense-blocks is viable** — the kernel is cheap and the reachable set is tiny.

**THE REAL CRUX (surfaced by the bench, NOT measured by it):** solving each pc≤12 boundary independently
**loses the cross-boundary transposition merging** the global 17 GB TT provides today (which is *why* re-exp
is ~1.0×). The proposal's fix — a cross-boundary memo keyed by edge-code — is exactly the millions-distinct
table = tens of MB = **back to DRAM probes** (just a smaller table). So dense-blocks trades "probe a shared
DRAM table" for "solve fresh in L1 but re-expand inter-boundary transpositions." Net win =
(L1-vs-probe saving per node) − (extra nodes from lost inter-boundary merging). **W8 escapes this only
because K=8 fits a COMPLETE 2²⁸ table (all merges captured, one build); K≥12 cannot (2⁶⁶).** This is the same
capacity-vs-cost tension the roadmap keeps hitting at pc 9–12. **Unmeasured and the actual make-or-break** —
needs a re-expansion measurement (prototype the per-boundary fresh-solve, measure node-count inflation vs the
global-TT ~1.0×) before committing the multi-session build.

**Decision point for the user (genuine fork):**
- (a-i) **Measure the cross-boundary re-expansion** for a per-boundary fresh-solve (the real dense-blocks
  gate) — a focused prototype/instrumentation, before the full build.
- (a-ii) **Pivot to MLP-batched gets** — attacks the 35 % directly (hide the ~1.9 DRAM fills/node, no
  coverage/amortization dependence), but breaks DFS-residence and only eventual-loss nodes are cleanly
  batchable; bigger restructure, upside maybe ~15 %.
- (a-iii) Accept the residual (b) micro-opts (≤1-2 % each) and bank the session's wins.
My read: dense-blocks' kernel is proven cheap, so (a-i) — the re-expansion measurement — is the highest-value
next step IF we pursue (a); it's the one unknown between here and a confident go/no-go.

### (a-i) pursued — the DECISIVE de-risk: production ALREADY runs the dense-block model at K≤7 (2026-06-19--1)

Chasing the cross-boundary-merge crux led straight to the answer in the existing code. **Production's pc≤7
path (`enter_graph`→`solve_local`, `iso_flat.rs:935`) IS the dense-block model already:** at a pc≤7
boundary it solves the *whole subtree* in a thread-private `[i8;128]` L1 memo, **"descendant transpositions
across different entries are recomputed (cheap, L1) rather than shared through DRAM"** (verbatim code
comment) — the boundary *entry* value is merged via the complete `tiny_tt` (labelled-index table, W8-style),
the descendants are recomputed locally. **And re-exp is still 1.02× at n=14** (measured this session's gate).
So the dense-blocks thesis — *recompute-in-L1 beats probe-DRAM even with descendant re-expansion* — is **not a
hypothesis; it's the shipping champion's design at K≤7.** This is the strongest possible de-risk: dense-blocks
is the same model with the boundary moved 7→12.

**What the win actually is, precisely:** today every pc 9–12 node probes the flat TT (DRAM). Dense-blocks
probes the flat TT **once at the pc≤K boundary entry** (keyed by the iso key — boundary-entry merging
preserved, NO merge lost there), then solves the entire subtree below in L1 with **zero further probes**.
It replaces ~N DRAM probes (one per pc≤K node) with 1 probe + N L1 ops. The *only* re-expansion is the
sub-boundary descendant recompute — exactly what K≤7 already accepts at 1.02×.

**The one remaining unknown:** does that descendant re-expansion grow too fast as the boundary moves 7→12
(bigger subtrees: ~20–60 reachable states/block at K=12 vs ≤128 total at K=7; and more boundaries)? The
`dense_block_bench` says each block is cheap (~10 ns/state); the question is the *total inflation* across all
boundaries. **This needs the boundary-K prototype to measure** — and that prototype IS the dense-blocks build:
`TinyGraph`/`solve_local`/`enter_graph` are `u8`/`MAXV_TINY=8`-bound, so K≤12 needs `u16` masks + a flat-TT
boundary-entry merge for pc 9–12 (the complete `tiny_tt` stops at 7; W8 handles pc==8).

**Build plan (the dense-blocks prototype, gated `QUEENS_BLOCK_K`, default 7 = current = zero prod impact):**
1. Widen `TinyGraph` to `[u16; 13]`, `solve_local`'s memo to `[i8; 1<<K]` (4 KB stack at K=12, thread-private).
2. New dispatch arm `8 < pc ≤ BLOCK_K`: probe flat TT once (iso key); on miss, `solve_local`-widened over the
   `u16` graph; store boundary value to flat TT. (pc≤7 stays `tiny_tt`, pc==8 stays W8.)
3. **Measure incrementally** K=9→10→11→12: n=14 node-count inflation (the re-expansion answer) + n=16 M/s A/B
   + CPI/MPKI/backend-by-memory (does the 35 % shrink?). Gate each K: `solve 12 iso-flat --distinct`
   1,060,823 + lineage (the boundary changes *how* a subtree solves, not *which* positions are distinct —
   validate via the distinct gate like W8 was).
4. Raise K only while M/s improves; stop when re-expansion overtakes the probe saving.

**Status: confident GO on the build** (the K≤7 precedent removes the conceptual risk). It's a hot-path,
multi-file change with gate risk → **the architecture-build green-light is the user's call** (per the
ask-before-architecture rule); the plan above is execution-ready for next session.
