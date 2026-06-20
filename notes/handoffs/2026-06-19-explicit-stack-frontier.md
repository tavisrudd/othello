# Explicit-stack `wins_inc` → ABDADA / frontier work-stealing

**Date**: 2026-06-19
**Session**: 2026-06-19--6 (`2bbbb8da-5981-4a0c-a5eb-3ad05ddafe19`)
**Mode**: intent-based (`mi`)
**References**:
- Umbrella: [iso-window](2026-06-18-iso-window.md) — n=16 **SOLVED (second)**; this thread continues its
  **parallelism-deficit** lever (session --5: the giant-root tail is 51% core util / ~half the wall,
  transposition-bound + OR-spine-width-limited; **only ABDADA in-flight markers or grouped-frontier DDD
  can crack it** — both need a materialized frontier a recursive DFS can't provide).
- Commits (main): `f124bc5` (canonical A/B harness + CLAUDE.md lessons), `3f10919` (the explicit-stack
  code), `8fb23dd` (micro-opt → parity).

## Context

The deep search was a recursion. This session converted it to an **explicit-stack loop** ("unwind the
recursion into loops") to (a) test whether the per-node control-flow/unwind cost is real, and (b) build
the **materialized-frontier shape** that the parallelism-deficit levers require. The user's framing was
exact: *"the recursion→loop conversion isn't the win — it's the key that unlocks the win."*

**Throughput verdict (measured): recursion→loop is a wash, not a win** — confirming the iso-window
finding that RAS/return-mispredict is measured-dead (0.003%), so removing call frames buys ~nothing:

| variant | flag | n=16 cyc/node vs recursive control | verdict |
|---------|------|------------------------------------|---------|
| `solve_local` → iterative (≤7 band) | `QUEENS_UNROLL` | wash (~3428 both) | reach too small (band-entry misses) |
| `wins_inc` peel-the-get (probe child inline) | `QUEENS_PEEL` | wash / +0.2% | call frame around a hit is RAS-free |
| `wins_inc` → **full explicit stack** | `QUEENS_ITER` | **+4.3%** raw → **parity after micro-opt** | the shape we keep |

All three are **gated OFF by default; production byte-identical** (n=14 deterministic 12,896,443 both
ways; iso-flat n=12 `--distinct` 1,060,823 / 1.25×; lineage + clippy green). The raw explicit-stack
+4.3% was the materialized-frame memory traffic (`orient[8]` push/pop) exceeding the removed call
overhead; an Opus micro-opt sub-agent **closed it to parity** by hoisting the top frame's hot fields
(`avail`/`mi`/`nmoves`/`moves_start`) into registers across the inner child loop + `get_unchecked` arena
indexing (perf showed a 26.8% `child0` stack spill/reload that vanished). So the shape is now
**throughput-neutral infrastructure** — no regression to justify carrying it.

## What the shape unlocks (the reason it exists)

A recursive DFS hides the search frontier in the opaque native call stack. The explicit `IncFrame` stack
**materializes the frontier as inspectable/reorderable/splittable data**, which enables (in priority order):

1. **ABDADA in-flight markers** — mark a node "being expanded" in the TT (busy bit); a worker about to
   push a frame for a node already in-flight elsewhere **defers** it (jumps to another pending frame)
   instead of re-expanding. Hits the *exact* measured re-expansion band (pc 13–21). Recursion can't
   defer-and-resume an arbitrary node; the frame stack can reorder/skip the pending set.
2. **Frontier work-stealing** — the frame stack is splittable at *any* frame, so an idle worker steals a
   frame-range from the busy giant-root worker → parallelises the serial OR-spine tail (the "2-root
   plateau"). Recursion only splits at root moves.
3. **Grouped-frontier DDD** — materialise the pc 13–21 frontier, bucket by graph signature, solve each
   unique boundary graph once (dedup by sort, bandwidth-bound). The n=18 enabler / path below ~1m40s.
4. **MLP-batched probes** — hold K frames "probed-not-expanded" → K TT gets in flight → overlap the
   ~165-cyc exposed DRAM latency (only half-hidden today by one-ahead prefetch).
5. **Checkpoint/resume + best-first move reordering** — the frame stack is serializable (n=16-to-
   completion / n=18 needs checkpointing); per-frame pending-move reordering cuts nodes.

## NEXT SESSION — build ABDADA / frontier work-stealing on `wins_inc_iter`

The target is the giant-root tail (51% util, ~half the n=16 wall). Two levers, both on the explicit stack:

- **ABDADA in-flight markers (start here — most surgical, hits the measured re-expansion set).** Add a
  per-slot "in-flight" state to the TT (a reserved value or a sidecar bit). On `wins_inc_iter` push: if
  the child's slot is already marked in-flight by another worker, **defer** it (move it to the back of the
  node's pending moves and try a sibling first; only block/re-probe if all siblings are exhausted). On
  pop/put: clear the marker. Measure re-expansion (`--distinct` re-exp at n=14, node count at n=16) and the
  tail core-util (`/proc/stat` sampler aligned to `QUEENS_ROOT_TIMING`, see iso-window session --5 method).
  Gate: must keep the n=14 verdict and not *increase* re-expansion (the whole point is to cut it).
- **Frontier work-stealing (bigger).** Let an idle rayon worker steal a contiguous frame-range (a sub-
  frontier) from a busy worker's `INC_STACK`. Needs the arena to be shareable/splittable (today it's
  thread-local) — design decision: per-worker deque with steal, or a shared frontier pool. This is the
  structural fix for the OR-spine width limit.

**Channel-Fermi first** (per CLAUDE.md): the tail idle pool is ~501 core-s → naive ceiling ~21s (~20% of
wall). ABDADA's prize is bounded by the re-expansion it removes (measure the re-exp at pc 13–21 first with
the existing `--distinct`/`count --comps` tooling before building).

## Codebase Reference

| What | Where |
|------|-------|
| `wins_inc_iter` (explicit-stack deep solve), `IncFrame`, `INC_STACK` arena | `src/queens/solver/iso_flat.rs` |
| recursive control `wins_inc` (the A/B baseline; production default) | `src/queens/solver/iso_flat.rs` |
| dispatch: `_ if !ORACLE && self.iter_inc => wins_inc_iter` | `par_wins_inc` (M_NORMAL arm) |
| flags `iter_inc`/`unroll` (read once in `from_tt_with_window`) | `IsoFlat` struct + ctor |
| iterative ≤7 band `solve_local_iter` (the `QUEENS_UNROLL` twin) | `src/queens/solver/iso_flat.rs` |
| TT (where an in-flight marker would live) | `src/queens/tt.rs` |
| root-timing / tail-util method (`QUEENS_ROOT_TIMING` + `/proc/stat` sampler) | iso-window session --5 note |

## Build / test / validate

Per CLAUDE.md. Gate: `solver_lineage_agrees` + iso-flat n=12 `--distinct` = **1,060,823 / 1.25×** + n=14
≈29.16M/1.02×; clippy `-D warnings`. **A/B = `scripts/queens-ab.sh 16 QUEENS_ITER ./target/release/queens`**
(the committed harness — 12 GB TT memory-safe, cyc/node, `BEGIN/END` markers, `QUEENS_AB_DONE` completion).
Fast proxy = single-thread n=14 interleaved (deterministic). **Never `tmux send-keys C-c` into a busy pane**
(SIGINTs the solve); **never run 17 GB-TT solves back-to-back** (OOM-kills the 2nd run).

## Progress

- [x] `solve_local_iter` (`QUEENS_UNROLL`) — wash at n=16, gated, committed (`3f10919`)
- [x] `wins_inc` peel-the-get (`QUEENS_PEEL`) — wash, then superseded/removed in favour of the full stack
- [x] `wins_inc_iter` full explicit stack (`QUEENS_ITER`) — +4.3% raw, gated off, committed (`3f10919`)
- [x] Opus micro-opt of `wins_inc_iter` — **closed +4.3% → parity** (register-hoist + `get_unchecked`)
- [x] Canonical A/B harness committed (`f124bc5`, `rust/scripts/queens-ab.sh`) + CLAUDE.md lessons
- [x] Micro-opt committed (`8fb23dd`) — n=16 A/B parity (off 2994.8 / on 2994.0), gate green
- [x] **ABDADA in-flight markers on `wins_inc_iter` — BUILT, gated off, correctness-validated
      (`773ba8d`); n=16 A/B = wash-at-default / LOSS-paired-with-finer-split (structural negative,
      see session --7 note).** The deferral can't crack the giant-root tail (the re-expansion is in
      *large* pc 13-21 nodes; a deferrer can't profitably wait for one).
- [x] **Frontier work-stealing on `wins_inc_iter` — BUILT + exhaustively tuned, measured a structural
      NEGATIVE** (`fb6b972`, `be4dc57`, `ce46f41`). rayon-scope publish of even-frame children to idle
      cores (ABDADA markers coordinate; deferral resolves to a stealer's hit). Best tuned config
      (`QUEENS_STEAL_DELAY=50` / `WIDTH=2` / `MIN_PC=35` / `MAX=24`) is **+8.7% nodes / +13.3% wall** in a
      4-round interleaved n=16 A/B (default 17 GB TT). 5th parallelization approach to fail; the tail is
      transposition-saturated. Gated off (zero prod cost). See the 2026-06-19--7/8 note.
- [~] **PIVOT (in progress, 2026-06-20--9): characterize the tail, then attack the WORK (not the schedule)** —
      DDD / getK / **MLP**, not parallelization. Macro re-anchor done (see the 2026-06-20--9 note): under W12
      the tail is **ONE giant root = 94% of wall**; TMA is co-dominant **memory 30% + frontend 31%**; the
      DRAM-probe bucket has a **not-yet-tried** lever (MLP-batched probes on `wins_inc_iter`). Lever choice =
      user steer.
- [x] **A'' Phase-0a — threaded sorted-stream microbench (`tt.rs::mlp_bench::mlp_probe_threads_sweep`),
      GREEN (2026-06-20--10).** The single-thread 5.7× sorted-stream ceiling **survives contention**: sorted
      aggregate scales 1→4 cores (275→764 M/s), the over-today multiplier holds ~5× through 4 cores, and the
      memory subsystem **saturates at ~780 M/s with ~4–8 streaming cores** (the new measured probe-throughput
      cap). Leverage is highest with FEW consumer cores (5× @4, eroding to ~2.8× @8 oversubscribed) — exactly
      Approach B's shape. ~4 sorted-consumer cores out-probe the whole current ~14-core random tail. Gated
      `#[ignore]` test, no production change; clippy/fmt green. See the 2026-06-20--10 note.
- [x] **A'' Phase-1 — Approach A (ETC + sorted-batch, `QUEENS_WAVE`/`M_WAVE` in `wins_inc`), BUILT +
      measured: real −17.4% node cut, but per-node critical-path overhead makes it a WALL LOSS (2026-06-20--10).**
      Enhanced transposition cutoff: each OR node ETC-probes its recurse-arm children (sorted by slot, all
      prefetches up front = MLP batch) *before* expanding any; a TT-proven-loss / empty child wins the node →
      cut, skipping the miss-siblings' expansion. Gated off, control byte-identical, verdict-correct (lineage
      n≤9==naive under `QUEENS_WAVE=1`; n=8/10/12 verdicts; clippy/fmt). **n=16 A/B (12 GB TT, 3 interleaved):
      nodes −17.4% (robust −13…−20%) but cycles +4.9% / wall +9.2% / cyc/node +27%.** The cut is real and large;
      the gather/key-rebuild/double-cold-probe on the hot path costs more than it saves. **⇒ realize the cut OFF
      the critical path (Approach B idle-core prep), not per-node.** See the 2026-06-20--10 Phase-1 note.
- [x] **A'' Phase-1b — FUSED M_WAVE (Opus micro-opt sub-agent): the cut is now a total-cycle WIN at n=16
      (2026-06-20--10).** Fused the ETC pre-pass with the descent — each recurse child's key built ONCE (gather
      stores the descriptor; the descent reuses it, no `lex_min8`/`d4_bits`/`hash128` rebuild) and the sort
      dropped (Fermi-below-bar at ~3–12-child batches). Killed the double key-build (perf: the unfused version
      was +69% L1-dcache-miss). **n=16 A/B (6 interleaved rounds): nodes −16%, total cycles −4.1% (ON wins 5/6),
      wall negative** — flips the unfused +4.9% cyc/+9.2% wall to a win. Gates green + parent-re-verified
      (control byte-identical; lineage/verdicts/clippy/fmt). TT-sweep verdict-correct + graceful to a 2 GB TT.
      Gated off; now a **defaults-on candidate**. See the 2026-06-20--10 Phase-1b note.

## Handoff Notes

### A'' Phase-1b — FUSED M_WAVE flips the cut to a total-cycle WIN (Opus micro-opt) (2026-06-20--10)

**Session**: 2026-06-20 (`mi`). User: "opus sub-agent to profile + micro-optimize the hell out of it." An Opus
sub-agent profiled and rebuilt the M_WAVE body; the parent independently re-validated every gate + reviewed the
working-tree diff. (Mid-run **collision**: the parent launched its own confirming n=16 A/B + a broad
`pkill -f "queens solve"` while the agent's bench was live — killed the agent's solve. Both stopped, agent
re-ran clean, box recovered. **Lesson re-banked: one driver on the `queens` box at a time; never
`pkill -f "queens solve"` while a sub-agent may be benching.**)

**Profile (the +27% cyc/node diagnosed):** the unfused M_WAVE ran a *separate* ETC pre-pass and then **fell
through to the unchanged descent**, so every no-cut node processed each recurse child **twice** — child0
recompute + full key rebuild (`child_orient`→`lex_min8`→`d4_bits`→`hash128`) AND a double cold TT probe. `perf
stat` n=14 signature: cycles ~flat but **L1-dcache-load-misses +69%** (211M→357M) — the duplicate key-build
memory traffic taxing all ~1.73 B nodes to save the 366 M cut. (`perf record` was one inlined blob; diagnosed
from code structure + the cache-miss delta.)

**Fix (`src/queens/solver/iso_flat.rs`, M_WAVE body only; control DCEs to byte-identical):** "proper Approach A"
— a **fused** ETC+descent. One gather builds each recurse child's descriptor (`ckey`/`cr`/`cf`) into a
`WAVE_CAP`-bounded stack SoA (no alloc); the ETC probes that batch (cut on proven-loss/empty); on no cut the
**descent reuses the stored descriptors** (only the cheap `child_orient` recomputed; the recursion's own warm
entry-probe kept for freshness ⇒ no extra re-expansion). **Sort dropped** (doesn't pay at the ~3–12-child tail
batch widths; the fused ETC is now the only batch probe). Isolated n=14: fuse +4.9%→+0.8% total cyc; drop-sort
→ break-even.

**MEASURED — total-cycle WIN at n=16** (iso-dense, 12 GB TT; **total cycles** is the right metric for a
node-count lever — cyc/node rises +22% *by design* and is misleading):

| A/B (3-round mean) | nodes off→on | total cycles off→on | wall off→on |
|--------------------|--------------|---------------------|-------------|
| #1 | 2086.3M → 1745.5M (−16.3%) | 6093.3G → **5833.8G (−4.3%)** | 106.8s → 105.0s (−1.7%) |
| #2 | 2046.7M → 1718.8M (−16.0%) | 5994.2G → **5762.0G (−3.9%)** | 106.3s → 102.4s (−3.7%) |
| **6-round** | **−16.1%** | **≈ −4.1%** (ON wins 5/6, 1 tie) | **≈ −2.7%** |

vs unfused Phase-1a +4.9% cyc / +9.2% wall — a ~9-pt cycle swing. **TT-size sweep** (WAVE on, single runs):
verdict SECOND + graceful (no cliff) from 12 GB (67% fill) to **2 GB (99.9% fill)** — the cut is robust under
heavy eviction.

**Gates (parent-re-verified on the final tree):** `make test` (control) pass; `QUEENS_WAVE=1` lineage n≤9 ==
naive pass; verdicts n=8 first / 10,12,14,16 second; n=14 cut 12.96M→11.76M (−9.2%); clippy `-D warnings` + fmt
clean; control byte-identical (whole body behind `if MODE == M_WAVE`). Code-review notes: gather/descent
`wi`-lockstep is sound (same `pc > recurse_min` predicate, rebuild past `WAVE_CAP`); every early return is a
proven win (gate-safe); `wk` is a dead store on the production `!COUNT` path (harmless nit).

**Status:** M_WAVE stays **gated off** (handoff convention) but is now a **measured net win ⇒ defaults-on
candidate** (user call). Residual slack = the warm entry re-probe of ETC-miss children (~60 cyc); removing it
needs an entry-probe/body split of `wins_inc` (risks byte-identity + doubles hot L1i — agent judged not worth
it). **NEXT:** decide promote-to-default vs keep-opt-in; the fused per-node ETC is now a clean substrate for
**Approach B** (idle-core prep moves the gather/probe off the critical path — where the remaining ~16% cut
should beat the −4% the critical-path version captures). **Also queued for triage:**
[Node-Kayles lit-search lever backlog](../handoffs/2026-06-20-node-kayles-lit-levers.md) — modular/twin
reduction (top bet, attacks the same pc 13–18 region), TDS scheduling, K-set DP, setrograde/generalized-TT,
per-root PN subsolver; gate on the cheap module-prevalence probe.

### A'' Phase-1 (Approach A / ETC) — real −17.4% node cut, but critical-path overhead = wall LOSS ⇒ go to B (2026-06-20--10)

**Session**: 2026-06-20 (`mi`, resumed from `go`). User: (a)/(b) fork → "yc". Built Phase-1 = the proposal's
**Approach A** in its minimum-viable form: an **ETC (enhanced transposition cutoff) + sorted-batch** pre-pass,
gated `QUEENS_WAVE=1` → `const MODE = M_WAVE` in `wins_inc` (resolved once per subtree handoff; off = byte-
identical `M_NORMAL`). Every node here is an OR node (a *losing* child = a winning move ⇒ node wins); the
pre-pass gathers the node's recurse-arm children (`pc > DK.max(block_k).max(iso_max_avail)` — the ones the
`else` arm would flat-TT-probe and expand), **sorts them by target slot** (monotone in the route hash), issues
**all prefetches up front then probes the batch** (full MLP overlap = the per-node sorted wave), and on a
TT-proven-loss / empty child **cuts** (puts win, returns) — skipping every miss-sibling expansion the move-
ordered descent would have done first. Read-only + verdict-preserving (the cut is only ever an *earlier* return
of the same verdict); changes only which children expand ⇒ gate-safe on iso-dense (no `--distinct`). `WAVE_CAP=32`
bounds the per-node batch (deep-tail fan-out is a handful; stack-safe in the recursive `wins_inc`). Segmentation
is default-off, so the A/B is apples-to-apples on the flat path.

**Correctness (gates green):** `make test` (control); lineage n≤9 == `naive` under `QUEENS_WAVE=1` (exercises
`iso-dense`/`iso-window`, both WINDOW=true → M_WAVE); n=8 first / n=10,12 second under wave; clippy `-D warnings`
+ fmt clean. (M_WAVE *changes* node count by design, so it is **not** gated on the exact `--distinct` — verdict
is the invariant.)

**MEASURED — the ETC cut is real and large, but Approach A is a WALL LOSS on the critical path:**

| metric (n=16, iso-dense, 12 GB TT) | control (off) | M_WAVE (on) | Δ |
|------------------------------------|---------------|-------------|-----|
| nodes (3-round mean)               | 2,099.9 M     | 1,733.6 M   | **−17.4%** (rounds −19.9/−13.0/−19.3) |
| total cycles (perf)                | 6,176.5 G     | 6,480.5 G   | **+4.9%** (rounds +0.9/+10.3/+3.8) |
| wall                               | 120.1 s       | 131.1 s     | **+9.2%** (rounds +8.5/+14.7/+4.6) |
| cyc/node                           | 2,941         | 3,738       | **+27.1%** |

(n=14 warm proxy: −9.5% nodes / +13% wall — same shape, smaller cut, confirming the cut isn't purely eviction-
driven.) The −17.4% node cut is **robust and bigger at n=16 than n=14** (more transpositions/eviction ⇒ more
TT-loss children to cut ahead of). But the pre-pass adds **+27% cyc/node** — the gather loop recomputes `child0`
for every move + rebuilds keys (`child_orient`/`lex_min8`/`hash128`) for every recurse child, and on a no-cut
node those children are then **re-probed (cold) by the normal recursion** = a double cold probe. The cut saves
366 M nodes; the overhead taxes all 1.73 B ⇒ net +4.9% cycles / +9.2% wall.

**VERDICT — Approach A (per-node ETC, prep on the critical path) is a measured wall LOSS, BUT it proves the
removable-work thesis: −17.4% of n=16 nodes are ETC-cuttable** (TT-proven-loss children reachable before
expanding the miss-siblings). The cut value is real; the **critical-path overhead is what kills A** — exactly
the proposal's prediction ("A's weakness: sort + gather on the critical path eats the win"). **⇒ the cut must be
realized OFF the critical path = Approach B** (idle-core producer/consumer: idle tail cores gather/sort/dedup/
build-keys, the hot consumer streams the sorted batch + cuts — the +27% cyc/node prep moves to the spare cores
Phase-0a showed have bandwidth). This is the GO signal for B: the dedup/cut is proven worth ~17% of nodes.
(A "proper A" — custom gather-once child loop that stores child descriptors so the expansion reuses them, killing
the double-work — would shrink the overhead, but that build is ≈ the B substrate anyway; go straight to B.)

**Status of M_WAVE:** keep gated-off on main (control byte-identical, validated) as the **ETC substrate +
documented measurement** (the −17.4%-cuttable finding), same disposition as gated ABDADA/STEAL. Do NOT default
it on (measured loss). Do NOT revert.

**NEXT = Approach B scope decision with the user** (multi-session): idle-core gather/sort/dedup producers feeding
a streaming consumer that probes the sorted batch + cuts. Phase-0a sized the consumer (~4 cores → ~780 M/s,
out-probes the tail); Phase-1 proved the cut (~17% nodes). The remaining design = the producer/consumer SPSC +
frontier ownership + boundary-publish race (proposal Approach B / open questions).

### A'' Phase-0a — sorted-stream survives contention (GREEN); ~780 M/s cap; few-consumer design (2026-06-20--10)

**Session**: 2026-06-20 (`mi`, resumed from `go`). Built the threaded half of the
[sorted-frontier-wave proposal](../proposal-2026-06-20-sorted-frontier-wave.md)'s Phase 0:
`tt.rs::mlp_bench::mlp_probe_threads_sweep` (`#[cfg(test)]`/`#[ignore]`, not a gate). Strong-scaling test —
a fixed 20M-probe set is partitioned across `nt` threads, each owning an independently-sorted slice (matching
A'' where each producer sorts its own frontier piece), all streaming the shared 8 GiB huge-page TT; aggregate
`M/s = total probes ÷ wall`. Run: `MLP_THREADS`/`MLP_DEPTHS`/`MLP_BITS`/`MLP_N` env. (Baseline this session:
iso-dense defaults = 1,926,031,300 nodes / 1m33s.)

| threads | random d1 | random d32 | sorted d16 | sorted d32 | sorted/random (d32) |
|---------|-----------|------------|------------|------------|---------------------|
| 1       | 48.6      | 80.0       | 191.2      | 274.7      | 3.43× |
| 2       | 89.0      | 155.5      | 330.2      | 442.6      | 2.85× |
| 4       | 152.8     | 225.4      | 573.2      | **763.8**  | 3.39× |
| 8       | 266.1     | 397.9      | **786.2**  | 756.4      | 1.90× |

**VERDICT — GREEN, with a measured ceiling + a design constraint:**
1. **The sorted win survives contention.** Sorted aggregate scales cleanly 1→4 cores (275→764 M/s); the
   headline "over today's regime" multiplier (sorted-deep vs random-d1) holds **5.65× @1, ~5.0× @2–4**. The
   single-thread 5.7× was not a single-core artifact.
2. **Memory saturates at ~780 M/s with ~4–8 streaming cores** (sorted d32 plateaus 764→756 over 4→8; sorted
   d16 reaches 786 @8). New measured **hard cap on probe throughput, any scheme.**
3. **Leverage is highest with FEW consumer cores** — 5× @4, eroding to ~2.8× @8. Not sorted degrading: sorted
   is bandwidth-capped while random keeps adding latency-chains with cores. ⇒ **don't oversubscribe consumers.**

**Why it green-lights Approach B specifically:** ~4 sorted-consumer cores hit ~764 M/s, which **exceeds** what
the current ~14-core random tail produces (8-core random d16 = 381 → ~14-core ≈ 550–600 extrapolated). So a
handful of sorted-consumer cores out-probe the whole tail, freeing the rest for non-redundant prep (the thing
work-stealing couldn't do because it re-searched). **Prize bound:** pc 13–21 ≈ 2.75 B probes ÷ 780 M/s ≈ 3.5 s
if fully streamable → ~10–15% of the 93 s wall at realistic realization (matches the napkin).

**NEXT = A'' Phase-0b: size the giant root's pc-band frontier width** (extend `count`/`comps_report` —
distinct keys per pc-band slice) to confirm a window exists where sort-cost < sorted-stream saving, then
Phase-1 Approach A (`QUEENS_SORTED_WAVE`, in-DFS sorted-wave probe on `wins_inc_iter`, gated/byte-identical).

### Tail re-anchored post-W12: ONE giant root = 94% of wall; cost = memory 30% + frontend 31% (2026-06-20--9)

**Session**: 2026-06-20 (`mi`, resumed from `go`). Measure-first per the pivot — re-anchored the tail on the
**current default solver (iso-dense W12)** before picking a lever (the prior tail studies predate W12). Two
zero-code measurements (`QUEENS_ROOT_TIMING`, `perf stat -M PipelineL1,PipelineL2`), clean box (20 GB free,
swap/zram off, ARC 2 GB), full 17 GB TT, n=16.

**(1) Macro reframe — `QUEENS_ROOT_TIMING=1 solve 16 iso-dense`:** wall **97.9s**, SECOND, **2.003 B nodes**
(confirms the ~1m39s record). Root schedule:
- **tail root idx 29 (sq 1): ran 91.7s, ended 97.9s — SOLO for last 17.5s (18% of wall).**
- **longest 3 root durations [91.7s, 74.2s, 52.3s] — longest = 94% of total wall.**

So under W12 the prior **"2 dominant roots / 51% util"** sharpens to **ONE giant root = 94% of the wall**, with
a 17.5s single-root SOLO tail (core util ~14/24 late). W12 cut nodes −60% but did **not** change this macro
shape. **The scheduling prize is small + closed:** the 17.5s SOLO tail at ~14 cores ≈ 7–8% of wall if perfectly
re-parallelised — and the work-stealing A/B already proved capturing it is net-negative. **⇒ the wall lever is
the giant root's WORK, not its schedule** (confirms the pivot from a fresh angle).

**(2) Cost re-attribution post-W12 — `perf stat -M PipelineL1,PipelineL2` (perf inflated wall to 113.7s; %slots
are rate-valid):** retiring **13.6%** · bad-spec 6.7% · **backend 32.8%** (memory **29.8%** / cpu 3.0%) ·
**frontend 31.4%** (latency **22.9%** / bandwidth 8.5%) · **SMT-contention 15.3%**. **Co-dominant memory +
frontend** — consistent with pre-W12 measurement #0 (~35%/~35%); W12's win was the −60% node cut, not a
per-node rebalance. The memory bucket is **latency-bound** (iso-window TT-size sweep was wall-flat — not
capacity) and the handoff notes it is **only half-hidden by one-ahead prefetch**.

**Lever implication (the menu, all "attack the work"):**
- **A. MLP-batched probes on the explicit-stack frontier (`wins_inc_iter`) — NOT YET TRIED; recommended to
  scope first.** Attacks the **largest single bucket (30% backend-by-memory = exposed pc≥13 DRAM-probe
  latency)** by holding K frames probed-not-expanded ⇒ K TT gets in flight ⇒ overlap the ~120 ns latency that
  prefetch only half-hides. This is unlock-list **#4** — the explicit stack was built **for** exactly this,
  and it is **immune to the transposition-saturation** that killed ABDADA/work-stealing (it is *single-worker
  latency-hiding*, not parallelization). Napkin ceiling ~10–15% wall (the exposed half of the 30%).
- **B. getK throughput recovery** (compiler-vectorize the K=10/11 code-build) — cuts the frontend (31%) getK
  compute. Ready/scoped (the getK-throughput proposal, `rust/notes/proposal-2026-06-19-getk-throughput.md`);
  smaller (~3–10% M/s), lower risk, codegen-shaping.
- **C. Grouped-frontier DDD** — dedups the pc 13–21 frontier ⇒ fewer distinct pc≥13 probes **and** fewer getK
  invocations (hits **both** buckets). The standing big lever; heavy/multi-session; the win/loss (not nimber)
  variant is the one that doesn't re-expand.

**Doc nit found:** `iso_flat.rs:379-380` `dense_k` doc says "default 9, clamped 9..=11" — stale; the code is
`env_u32("QUEENS_DENSE_K", 12).clamp(9, 13)` (default **12**, clamp 9..=13). Fix in a doc pass.

**NEXT = user steer on the lever (A MLP / B getK / C DDD).** A is the highest-ceiling not-yet-tried lever and
reuses built substrate; B is the safe ready bet; C is the big bet. (Tooling left on screen: tmux `queens`
windows `char-rt`, `char-prof`.)

### Per-pc probe economics (`QUEENS_PROF`) — probe-skip REFUTED; MLP/prefetch-warming is the lever (2026-06-20--9)

User asked three design angles (streaming/dense, idle-core prep, "any TT check not worth doing"). Ran
`QUEENS_PROF=1 solve 16 iso-dense` (per-pc TT get/put cycle profile) to ground all three. n=16, 2.007 B nodes,
3.11 B gets / 557,949 Mcyc get / 56,196 Mcyc put.

| pc band | gets | cyc/get | hit-rate (gets−nodes)/gets | share of probe cost |
|---------|------|---------|----------------------------|---------------------|
| 13      | 600 M | 176 | 39% | 19.0% |
| 14      | 431 M | 176 | 38% | 13.6% |
| 15–17   | 1.03 B | 176–177 | 36–38% | 32.7% |
| 18–21   | 687 M | ~180 | 34–35% | 22% (cum **87%**) |
| ≥40 (near-root) | ~tens of K | **50–60** (warm/cache-resident) | — | 0.4% |

**Findings:**
1. **Probe-skip ("TT check not worth doing") is REFUTED — the probes pay ~22×.** A pc==13 probe costs 176 cyc;
   its 38% hit-rate saves a ~13-`getK`-call re-expansion ≈ ~10,000 cyc (getK is real `u128` dense compute) ⇒
   expected saving 0.39×10,000 ≈ 3,900 cyc per probe vs 176 cyc. Skipping = a 22× loss. **Independently
   confirmed:** skip-and-resolve-densely *is* W13, which is measured net-negative. No band is skippable (low-pc
   memoizes expensive getK; high-pc saves huge subtrees and is warm/cheap). The put side (10% of probe cyc,
   relaxed-store writes) enables the 38% hits — also worth it.
2. **The flat 176 cyc/get at pc 13–21 IS the 30% backend-memory bucket** — cold DRAM latency that one-ahead
   prefetch is **not** hiding (the warm near-root probes run at 50–60 cyc = the achievable floor). Cross-check:
   ~8% of total cycles sit in these stalled get-windows; ×4-wide ≈ the TMA's 29.8%-of-slots backend-memory.
3. **⇒ The three angles converge: can't-skip → must-hide → MLP / idle-core prefetch-warming is THE lever** for
   the biggest bucket. Prize = drag pc 13–21 from 176 → ~60 cyc (warm floor) ⇒ upper end of the ~10–15% napkin.
   pc 13–21 = 87% of probe cost, so the batch target is well-defined.

**Decision:** build **A (MLP)**. Step 0 (discipline, before the 52%-of-cycles hot loop) = a **standalone
microbench** of probe throughput vs batch depth (1/2/4/8/16) over the real 17 GB TT with random keys — measures
the latency-overlap ceiling for both single-core MLP and the multi-core prefetch-prep pipeline, zero solver
risk. Then A1 (batched even-frame probe in `wins_inc_iter`, gated, byte-identical off). The idle-core
dense-chunk-streaming pipeline is the multi-core lift of A1 (DDD with offloaded prep) — gated on A1's measured
ceiling.

### MLP microbench — ~1.85× latency-overlap headroom; latency-hiding GREEN-LIT (2026-06-20--9)

Step-0 microbench landed (`tt.rs::mlp_bench::mlp_probe_depth_sweep`, `#[cfg(test)]` + `#[ignore]`, not a gate;
run with `cargo test --release --lib mlp_probe_depth_sweep -- --ignored --nocapture`). Single-thread random
probes into the real huge-page flat TT (8 GiB, prefaulted), software-pipelined `prefetch_hashed`-ahead by
`depth`, then `get_hashed`:

| depth (probes in flight) | ns/probe | M/s | vs depth-0 |
|--------------------------|----------|-----|-----------|
| 0 (≈today's one-ahead)   | 16.6 | 60.4 | — |
| 4                        | 12.8 | 78.0 | +29% |
| 8                        | 10.9 | 91.6 | +52% |
| 16                       | 9.3  | 107.3 | +78% |
| 32                       | 9.0  | 111.1 | +84% (plateau) |

**Verdict: the memory system is NOT saturated by one-ahead — ~1.85× single-thread probe-throughput headroom,
plateauing at ~8–16 in flight.** Latency-hiding (MLP / idle-core prefetch-warming) is a live lever, not dead.
Caveats for the in-solver translation: (a) single-thread @ boost clock here (16.6 ns ≈ 50–83 cyc) vs the
solver's 176 cyc/get (24-thread contention + all-core clock + rdtsc) — real per-probe latency is
contention-inflated, so overlap matters *more*; (b) the microbench is pure-memory (no compute between probes);
the real loop is co-dominant frontend, so realized gain < 1.85×; (c) **the overlap headroom is largest in the
tail** — the SOLO phase runs ~14 cores, leaving spare memory bandwidth exactly where the lever is needed.

**Characterization COMPLETE + self-consistent:** can't-skip (PROF 22× ROI) → must-hide (microbench 1.85×) →
no-free-locality-beyond-pc (canonicalization destroyed it; seg TT already banks the pc axis at +5%) →
manufacture locality by sorting (DDD), ideally on idle cores.

### A1 Fermi'd BELOW BAR; sorted-stream microbench = ~5.7× ceiling ⇒ A'' (sorted frontier) is the lever (2026-06-20--9)

**User: "A1 go" → "yc".** Building A1, Fermi hit a structural wall, so I measured the alternative instead of
sinking the per-node build.

**Why per-node A1 is below the bar (Fermi):** the microbench's 1.85× needs ~16 *independent* probes
back-to-back. One prove-loss node has only a handful of recurse children (~3–12), and two DFS facts cap it
further: (a) a recurse-child MISS descends its whole subtree before the next sibling is touched (can't keep
siblings in flight); (b) the TT *mutates during descent*, so you can't probe a sibling batch, cache results,
and reuse them (stale → re-expansion) — you must re-probe at use-time. The one clean per-node win that survives
is **probe-before-expand** (probe all children; a known TT-loss child wins the prove-loss node → skip the
miss-siblings' expansion = a free node cut, gate-safe on iso-dense) — but the *overlap* part is bounded to the
hit fraction at one small node (~few %), and realizing it needs cache + miss-batch state across the
suspend/resume in the 52%-of-cycles hot loop: **high risk, ~few-% reward — below the per-node-micro-opt bar.**

**The 1.85× (and more) is a FRONTIER-WAVE number — measured the sorted ceiling** (`tt.rs::mlp_bench`, extended
with a sort-by-slot pass; same 8 GiB huge-page TT, single thread):

| depth (in flight) | random M/s | **sorted M/s** | sorted/random |
|-------------------|-----------|----------------|---------------|
| 0 (≈today)        | 52.4      | 88.5           | 1.7× |
| 8                 | 83.1      | 153.1          | 1.8× |
| 16                | 92.0      | 208.5          | 2.3× |
| 32                | 99.9      | **301.3**      | **3.0×** |

**Sorting the probes by target slot before streaming them = up to 3× over random *at the same depth*, ~5.7×
over today's effective regime (random depth-0/1 ≈ 52–58 → sorted depth-32 = 301 M/s) — and it COMPOUNDS with
depth** (sequential access saturates bandwidth; random plateaus latency-bound at ~7 GB/s). Sorted ~50-slot
spacing at this density mostly hits the same open DRAM row → row-buffer hits. (Sort cost excluded — in A'' the
idle cores pay it off the critical path.)

**DECISION (data-backed): skip per-node A1; the lever is A'' = the sorted-frontier wave** — materialize a
pc-band frontier slice, **sort by slot, stream the wave** (probe back-to-back, deep pipeline → 3–5.7× probe
throughput) **+ dedup** (sorted ⇒ adjacent duplicates removed ⇒ fewer probes). This is grouped-frontier DDD
(win/loss variant), with the sort offloaded to idle cores = the user's idle-core-prep / dense-chunk-streaming
vision; **BuRR re-enters here** as the value-only ~1.1-bit/key dense backing for *frozen* (solved) plies
(sound under windowing's known membership → cache-resident, sequentially streamable). Ceilings now measured:
per-node MLP ~1.8×, **sorted frontier ~4–5.7×, ~3× better and node-count-adjacent.** Caveats for translation:
single-thread @ boost here; under 24-thread contention bandwidth is shared (but the ~14-core tail has spare);
realized < ceiling after sort + frontier-management + DFS-residence loss. **A'' is the multi-session build —
scope with the user** (the [grouped-frontier DDD proposal](../proposal-2026-06-18-grouped-frontier-ddd.md)
already covers Phase 0/1; the win/loss + sorted-stream + idle-core-sort framing is the new synthesis).

**Committed (`eabb0e6`):** doc fix (`iso_flat.rs` dense_k default 12 / clamp 9..=13) + the random+sorted
microbench (`tt.rs::mlp_bench`, `#[cfg(test)]`/`#[ignore]`); production binary byte-identical.

**A'' SCOPED:** [sorted-frontier-wave proposal](../proposal-2026-06-20-sorted-frontier-wave.md) — 3 approaches
(A: in-DFS sorted wave, single-core prep / B: idle-core producer-consumer pipeline = the user's vision / C:
ply-windowed retrograde DDD, the n=18 endgame + BuRR-frozen plies). **Recommendation: build toward B,
Phase-1-validate with A** (cheapest in-solver proof the sorted-stream win realizes before the pipeline build).
Phase 0 = size the pc-band frontier width + a 2–4-thread sorted-stream microbench (does 5.7× survive
contention?). Distinct from the parked component-nimber DDD (that dedup'd by cutoff-free nimber → 6.6× wall;
this dedups by **sort**, keeps α-β).

### Frontier work-stealing BUILT + tuned + measured NEGATIVE — parallelization route CLOSED (2026-06-19--7/8)

**Session**: `37195ab0-cc8d-4c5a-89fa-3f07ff95997a` — `mi`; user steered the whole tuning arc live.
**Commits (main)**: `773ba8d` (ABDADA, gated) · `7e3be6b` (ABDADA negative docs) · `fb6b972` (work-stealing
core, gated) · `be4dc57` (60s tail-gate + harness monitor) · `ce46f41` (steal tuning knobs + split
diagnostics + `--to-file` JSON + serde).

**What was built (all gated off; control byte-identical; `steal_agrees` test green; n=16 verdict SECOND):**
- **ABDADA in-flight markers** (`QUEENS_ABDADA`): `Slot::IN_FLIGHT=0xFF` sentinel + tri-state `Probe3`
  `get_inflight_hashed` + `mark_inflight_hashed` in `tt.rs`; `wins_inc_iter` gained `const ABDADA` + a
  two-pass deferral (`IncFrame.pass` PASS0/PASS0_DEF/PASS1).
- **Frontier work-stealing** (`QUEENS_STEAL`, implies ABDADA): `wins_inc_iter` gained `'scope`/`&rayon::Scope`
  + `const STEAL`; at an even-depth (prove-loss) frame, idle-gated, it publishes children as scope tasks
  (`scope.spawn`) so an idle worker searches them and writes the verdict to the shared TT; the busy worker
  defers them (ABDADA) and PASS1 resolves them as hits, not re-expansions. Handoff wrapped in
  `rayon::in_place_scope` (joins all stealers before returning). Gating knobs: `QUEENS_STEAL_DELAY` (50s
  watchdog arms a flag, sampled every `STEAL_CHECK_EVERY=4096` nodes via a local counter — no per-node
  atomic; the early all-roots phase pays ~nothing), `QUEENS_STEAL_WIDTH` (per-frame publish cap, def 2),
  `QUEENS_STEAL_MIN_PC` (only split a child whose avail-pc ≥ this, def 18→use 35), `QUEENS_STEAL_MAX`
  (concurrent in-flight cap, def n_threads).
- **Tooling kept:** split diagnostics (`steal_published` + per-pc histogram + `steal_fallback`), printed
  post-solve; `StealReport` (serde) + `Solver::steal_report()`; **`solve --to-file PATH`** writes the run
  as JSON (verdict/nodes/wall/TT + steal) while the TTY keeps the human text; `queens-ab.sh` now tees the
  solver summary to the pane + writes a `$STATE` monitor file + has a memory-guard so default-17 GB A/Bs
  don't OOM back-to-back.

**The measurement arc (each step the user steered; the trustworthy metric is the INTERLEAVED A/B):**
1. ABDADA at default split: **wash → small loss** (+0.76% cyc/node robust over 4 rounds; node trim flat —
   the early "−6%" was a cold-cache outlier). Nothing to defer: baseline re-exp ≈ 1.0.
2. ABDADA + finer-split (`MIN_AVAIL=48`): **LOSS** — does not remove B1's pc 13-21 re-expansion (the
   re-expansion is in *large* nodes; a deferrer can't profitably wait for one — its other work finishes
   ~when the owner does ⇒ PASS1 expands it anyway).
3. Ungated work-stealing: **2.4× slower / +55% nodes** — over-published in the early parallel phase
   (`deep_busy` reads idle before workers hand off).
4. 60s tail-gate + width-21: **+25% wall / +15% nodes** — gate fixed the catastrophe but a 21-wide publish
   burst per frame re-expands.
5. Split diagnostic (min_pc 18): **12.3M subtrees split, mean avail-pc 19.6, 9.7% fallback** — far too
   many tiny splits; the tail is overwhelmingly pc 18-21 nodes.
6. min_pc sweep (single runs, noisy): 18→12.3M, 25→541K, 35→313K, **50→1.9K, 65→1.8K** splits. **A cliff at
   pc 50** — only ~1,900 frames with pc≥50 exist after 50s (the roots have already descended past the big
   shallow frames). So "split high + early" is *not reachable* at the time idle cores appear.
7. **Definitive 4-round interleaved A/B, steal@min_pc=35 vs control, default 17 GB TT:**
   | round | control nodes/wall | steal nodes/wall |
   |-------|--------------------|------------------|
   | 1 | 2.09B / 119s | 2.34B / 132s |
   | 2 | 2.01B / 106s | 2.22B / 129s |
   | 3 | 1.95B / 103s | 2.19B / 120s |
   | 4 | 2.10B / 115s | 2.11B / 121s |
   | **mean** | **2.04B / 111s** | **2.22B / 125s** |
   **+8.7% nodes (re-expansion), +13.3% wall — a loss in every round.** The single-run "1.91B/99s" at
   min_pc=35 was a low-node fluke; interleaving cancels the ±18% common-mode node-count noise.

**VERDICT — the DFS-parallelization route to the giant-root tail is CLOSED, with evidence.** Five
independent approaches (B1 finer-split, ABDADA, ungated steal, width-21 steal, tuned steal) all add
re-expansion, because the tail is **transposition-saturated**: the work that would fill the ~51%-idle cores
is shared transpositions, so any scheme that does it concurrently re-does it (the in-flight markers can't
win every race; the few clean-disjoint big subtrees, pc≥50, are gone by 50s). We've now *built* both levers
session --5 named (ABDADA + frontier work-stealing) and measured both negative — so this is settled, not
assumed. **Not a "floor"** — the lever is *not parallelization*. The work itself must shrink (getK/W_K
node-count, per-node cost) or **de-duplicate** (grouped-frontier DDD — the only "parallelism-adjacent"
lever that doesn't re-expand, *because* it dedups). All steal/ABDADA code stays gated-off on main (zero
prod cost, substrate + instructive negative; do NOT revert).

### NEXT SESSION — characterize the tail FIRST, then attack the work (ChatGPT idea backlog)

The user wants next session to **characterize what the 2 dominant roots are doing late** before picking a
lever (we kept tuning a scheduler before fully understanding the work — measure-first). ChatGPT's ideas,
grouped; the **tail-characterization** cluster is the priority:

**A. Characterize the tail work (do these first — cheap, decisive, mostly cold tooling):**
- **Measure span, not just work** — reconstruct the actual critical path (the longest cumulative-cost
  dependent chain) of the giant root; optimize the top-N nodes *on that path*, not global averages. (Our
  steal failures are consistent with a span/critical-path limit, never directly measured.)
- **TT-hit profile by popcount AND graph shape** — the dominant cost center late may be a small set of
  graph families, not a pc layer. Extend the `QUEENS_PROF` per-pc latency profile with a graph-signature
  bucket.
- **Cross-root transposition reuse, explicitly** — count TT entries first inserted by root A and later
  consumed by root B (and vice-versa); `count --roots` (session-10) measured ~2× union reuse but not the
  directional A→B flow. Asymmetry would inform warmup ordering.
- **Reuse heat-map over iso classes / "state ROI"** — for each solved state, `(future hits avoided × avg
  probe cost) / solve cost`; find which canonical graph families dominate future lookups → the optimization
  target. Build a centrality predictor for high-reuse "hub" states.
- **Early graph-shape overlap of the two roots** — log the first N canonical fingerprints each dominant
  root visits; measure overlap *rank*, not just count.
- **Memory-traffic re-attribution after W12** — re-run the latency study; the dominant DRAM source may have
  shifted from pc layers to specific graph structures (the `--3`/`--5` hit-cost study predates this).

**B. Attack the work (the levers the characterization should point at):**
- **Grouped-frontier DDD** (the standing big lever, [proposal](../proposal-2026-06-18-grouped-frontier-ddd.md)):
  materialize the pc 13-21 frontier, bucket by graph signature, solve each unique boundary graph **once**
  (dedup by sort, bandwidth-bound). The one approach that fills cores *without* re-expansion because it
  de-duplicates instead of re-doing — directly counters the saturation we kept hitting. "Information
  propagation on a DAG: solve the most-reusable states earliest."
- **getK-C1 throughput / W_K node-count** (the queued throughput leads) — cheaper/fewer nodes on the path
  the tail grinds; the `notes/proposal-2026-06-19-getk-throughput.md` lead.
- **Synthetic frontier above W12** — not W13 as a dense layer, but a specialized exact evaluator for the
  *specific graph families* frequent enough late to justify it (ties to the TT-hit-by-graph-shape profile).
- **Warmup as a first-class phase** — optimize "useful TT entries generated/sec" not proof progress; A→B vs
  B→A seeding (asymmetric overlap); plot marginal runtime gain per warmup second to find saturation. Smarter
  than the current time-based warm-restart (targets high-*centrality* states, not just elapsed time).

**C. Parked / lower-value (measured-dead or speculative):**
- Speculative sibling expansion for dominant roots *with cancellation* (widen the OR-spine) — fact #5 says
  speculation defeats the cutoff; cancellation is the only new ingredient, but rayon has no clean cancel.
  Low EV; only if A says the spine truly is the critical path AND nothing else works.
- Per-position scheduling for the 2 dominant roots (dedicated workers / lower split thresh) — a scheduler
  lever; deprioritize until the work is characterized (we just learned scheduler-tuning is the wrong axis).

**Method banked this session:** the n=16 node count is ±18% common-mode noise — **single runs lie**
(min_pc=35 read 1.91B/99s solo but 2.22B/125s interleaved). Only the *interleaved* A/B (or node-independent
cyc/node) is trustworthy. And: **characterize the work before tuning the scheduler** — we built and tuned a
whole work-stealing harness before the split diagnostic revealed the tail is millions of pc-18-21 nodes that
fundamentally re-expand when parallelized.

### ABDADA in-flight markers BUILT + measured — structural NEGATIVE; work-stealing is the lever (2026-06-20--7)

**Session**: 2026-06-20 (`mi`). Resumed from `go`; the user steered "no gating on fermi. push forward and
expect initial small regressions. push past them." So I built the real ABDADA in-flight-deferral on
`wins_inc_iter` (skipped the side-set probe) and measured it at n=16. **Commit `773ba8d`** (gated off).

**What was built (gated `QUEENS_ABDADA=1`, off by default, control byte-identical):**
- `tt.rs`: `Slot::IN_FLIGHT` sentinel (`val=0xFF`), tri-state `Probe3` `get_inflight_hashed`,
  `mark_inflight_hashed` (relaxed-store claim). Markers only hide latency; every fallback degrades to a
  plain re-expansion and only the completing put records a (deterministic) value ⇒ verdict is
  timing-independent. **Limitation:** don't checkpoint-resume an ABDADA run — a mid-flight dump would
  capture a `0xFF` marker that the plain `get_h` reads as a win (markers are `!COUNT`-only and the
  distinct-counter path is disabled under ABDADA for the same reason).
- `iso_flat.rs`: `const ABDADA` monomorphisation of `wins_inc_iter` (resolved once per subtree handoff,
  never per node — hot-path-toggle rule); `IncFrame.pass` two-pass deferral state (PASS0 skip in-flight
  children → keep working others → PASS1 revisit: now-finished are hits, stragglers expanded by us).
- Correctness: new `abdada_agrees_on_small_even_boards` test (n=8/10/12 verdict == naive **under the real
  parallel solver**, where deferral actually fires — a single worker never re-probes its own on-stack
  markers, since available-popcount strictly shrinks down a DFS path). **All n=16 A/B runs returned SECOND**
  (correct verdict at full scale). Gate green: n=12 iso-flat `--distinct` 1,060,823/1.25× (control) and the
  `QUEENS_ITER` non-abdada path matches; n=14 second/1.02×; clippy/fmt clean.

**MEASURED — the core bet fails (structural, not a tuning regression).**

| config (n=16, iso-dense, 12 GB TT) | cyc/node | nodes | wall | verdict |
|------------------------------------|----------|-------|------|---------|
| default split, CTRL (4-round mean) | 2956.9   | 2.05 B | ~105 s | small-loss baseline |
| default split, **ABDADA** (4-round mean) | **2979.3 (+0.76%)** | 2.07 B (+0.8%) | ~107 s | **wash → +1.5% (LOSS)** |
| finer split `MIN_AVAIL=48`, FINE (B1) | ~3361 (+14%) | ~2.75 B (+34%) | 133–143 s | LOSS (re-exp, as session --5) |
| finer split, **FINE+ABDADA** | ~3412 | 2.83–3.17 B | 143–163 s | **LOSS — ABDADA does NOT remove B1's re-exp** |

- **Default split: ABDADA is a wash-to-small-loss.** cyc/node +0.76% is *robust* (every one of 4 rounds
  AB > CTRL — it's the marker-store + tri-state-probe cost); the node count is flat (+0.8%, noise). The
  one early run that showed "−12% / −6% nodes" was a **cold-cache outlier** (a CTRL `off_1` at 114.6 s vs
  the cluster's ~104 s); 4 clean rounds erased it. **There is essentially nothing to defer at default
  split** — baseline re-exp is already ~1.0 (warm-restart + the split-node `par_tt` memo prevent the
  concurrent duplicates), so the marker overhead buys nothing.
- **Finer split + ABDADA: a clear LOSS.** Finer split (B1, `MIN_AVAIL=48`) reproduces session --5: +34%
  nodes, +14% cyc/node, ~135–163 s wall. **ABDADA does not remove that re-expansion** (FINE+AB node count
  ties or *exceeds* FINE; the worst run of all was FINE+AB at 162.8 s / 3.17 B).

**WHY (the structural reason — confirms session --5 from a new angle, by building the actual mechanism):**
the giant-root-tail re-expansion is in **large pc 13-21 nodes (the bulk of the work, not a thin frontier)**.
ABDADA's deferral only saves a re-expansion if the in-flight node's *owner finishes it during the
deferrer's other-work window*. For a large balanced subtree, the deferrer's "other children" are *also*
large and finish ~when the owner does — so PASS1 still finds the node in-flight and **expands it itself
(the fallback) = the re-expansion is NOT avoided**. Deferral is a latency-hider; the deficit is a
bulk-work transposition race. Wrong tool. (It *would* help if the duplicates were small/quick — but those
aren't where the re-expansion mass is.)

**THE LEVER THIS POINTS TO — frontier work-stealing (the handoff's other named lever).** The fix for
ABDADA's fallback is exactly: instead of *re-expanding* the in-flight node independently, **steal a
sub-frontier from its in-flight owner** — split the SAME work across the two workers (no duplicate at all).
The ABDADA marker infra is the **substrate**: it already flags which nodes are in-flight ⇒ stealable, and
which owner to steal from. That converts "defer-or-re-expand" (the dead end) into "defer-or-help" (the
real parallelization of the OR-spine tail). **Heavy:** needs the per-worker `INC_STACK` arena to become
shareable/splittable (today thread-local) — a per-worker work-stealing deque or a shared frontier pool.
This is the architectural multi-session build; **decide scope with the user.**

**Status of the ABDADA code:** keep it gated-off on main (zero production cost — the `ABDADA=false`
instantiation is byte-identical, validated) as the **work-stealing substrate** + the documented negative.
Do NOT ship `QUEENS_ABDADA` as a default (it's a measured loss). Do NOT revert (substrate + instructive
negative; and the global revert-ask rule applies).

### Explicit-stack shape built + micro-opted to parity (2026-06-19--6)

**Session**: 2026-06-19--6 (`2bbbb8da-5981-4a0c-a5eb-3ad05ddafe19`) — `mi`. Resumed from `go`; the user
steered the whole session: "focus on hit costs and unrolling" → "make all tt hits / iso short-circuits
cheaper" → "unwind recursion into loops where we can" → after the peel washed, "bail and do the full
unpeel" → "keep the code, off by default on main" → "opus sub to micro-opt your unpeel."

**Completed:** the recursion→loop conversion (3 variants, all gated/byte-identical), the throughput verdict
(wash/parity — RAS-dead), the unlock analysis, the committed harness + CLAUDE.md lessons, and the Opus
micro-opt closing the explicit-stack to parity. **Commits:** `f124bc5` (harness+docs), `3f10919` (iter code).

**Instructions for next agent:** the micro-opt was landed by a sub-agent in the working tree — **validate
the gate + the n=16 A/B parity, then commit it** (Progress item) before starting ABDADA. The shape is
throughput-neutral now, so ABDADA doesn't have to "pay back" a regression — any re-expansion it removes is
net win. Start with **ABDADA in-flight markers** (most surgical), Channel-Fermi the re-expansion prize
first. `/tmp` has ~40 stale A/B scripts + ~20 binaries from prior sessions — the committed harness replaces
them; don't delete the handoff-referenced `/tmp/queens_*` binaries.
