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
- [ ] **Frontier work-stealing (shareable/splittable arena) — NOW THE LEAD.** The ABDADA marker infra
      *is* the substrate (it flags which nodes are in-flight = stealable); the fix for ABDADA's
      fallback-re-expansion is to **steal the deferred subtree from its in-flight owner** instead of
      re-expanding it. Heavy (thread-local arena → shareable). See session --7 note.

## Handoff Notes

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
