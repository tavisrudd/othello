# Per-ply distinct distribution — the ply-windowing de-risk

**Date**: 2026-06-17
**Created by**: 2026-06-17--3 (`26d18a84-a65c-480a-a941-cd01a638a803`)
**Purpose**: Measure distinct positions **per ply** (queen count) to size the ply-windowing /
external-DDD route (Lead L2 / lever #11) before committing to a new solver.

---

## Context

The n=16 search is TT/DRAM-bound. This session we observed the live solve runs **~30 M/s out
of the gate** (memtable-only — the `seg_count==0` short-circuit skips the segment walk) and
**settles to ~10 M/s** once freezes start and every miss walks all segments + Blooms (then
worse once the cap evicts). That 3× gap is the motivation for **ply-windowing** (roadmap
[Lead L2 / #11], `notes/handoffs/2026-06-15-queens-memory-roadmap.md:301,472`).

The structural fact: **transpositions are strictly intra-ply** — every move places exactly
one queen, so two positions can only transpose if they have the same queen count. Therefore a
ply-k query can only hit ply-k entries. Two payoffs if the store is windowed by ply:
1. A query touches only the **adjacent** ply's layer (one archive lookup) instead of walking
   every segment → per-node cost falls back toward the 30 M/s regime.
2. **Known membership** (you only ever query keys that exist in a fully-solved layer) lets the
   BuRR archive drop its fingerprint → **value-only ~1.1 bit/key** (`roadmap.md:352-355`) vs
   ~7 B/key → layers are tiny → whole n=16 fits RAM, no eviction, re-exp → 1.0×.

**The load-bearing unknown is the per-ply distinct distribution** — specifically the peak ply.
It decides: (a) does a value-only per-ply layer fit RAM, (b) does *two adjacent layers* fit
(the working set of a layered solve), and (c) does the peak-ply **construction/dedup working
set** fit RAM (→ in-RAM layered solver) or need **external-memory DDD** (disk; Korf 2008,
Zhou–Hansen). This task measures it. **No solver change** — measurement + analysis only.

## Scope

- **In:** instrument distinct-by-ply at n=12 (exact) and n=14 (HLL); extrapolate n=16;
  compute the RAM footprints; recommend the route.
- **Out:** building the layered/DDD solver; the value-only archive; any hot-path change. This
  is the de-risk that *precedes* that work.

## Work Items

1. **Add a per-ply distinct tally.** The existing count path
   (`bin/queens.rs:1727` `roots_report`; `count.rs` HLL + optional exact map) measures
   distinct **per root**, not per ply. Add a per-ply accumulator: tag each distinct position
   by its **placed-queen popcount** (the ply/depth) and fold into **one HLL per ply** (and an
   exact set per ply at n=12). Likely a new `count --by-ply` mode. Validate: the n=12 per-ply
   exact counts must **sum to 1,060,823**.

2. **Run n=12 (exact) and n=14 (HLL)** and record the per-ply distinct curve. Extrapolate the
   n=16 curve (the per-ply growth ratio across n=12→14 should project the n=16 peak; cross-check
   the total against the known ~9.2B central HLL estimate / ~2.7B iso-merged).

3. **Compute footprints + recommend.** For the peak ply (and n=16 extrapolation): (a) value-only
   layer at ~1.1 bit/key, (b) two adjacent layers resident, (c) the peak-ply construction/dedup
   working set (keys × slot during the layer build — this is the number that forces external
   DDD if it exceeds RAM). Recommend **in-RAM layered** vs **external-memory DDD**, and note the
   design fork: full layered/retrograde restructure vs a lighter **ply-bucketed DFS store**
   (separate memtable+segments per ply so a query walks only same-ply segments).

## Codebase Reference

| What | Where |
|------|------|
| Count tool to extend | `rust/src/bin/queens.rs:1727` (`roots_report`) |
| HLL / exact set | `rust/src/queens/count.rs` (`Hll`, `Counter`) |
| Ply-windowing design + value-only density | `notes/handoffs/2026-06-15-queens-memory-roadmap.md:301, 472, 352-355, 645-656` |
| iso merge factor (affects iso-keyed peak) | roadmap `#7`: ~3.4× fewer distinct |

## Principles / Constraints

- Read-only/instrumentation; verdict and total distinct are unaffected — the n=12 exact-sum
  check is the correctness guard.
- Measure on the **iso key path** too if the windowed route targets iso-burr (the shared
  population, hence per-ply sizes, differs from D4).
- Run in tmux session `queens`; timing (if any) only from tmpfs or Zen5-pin.

## Delegation

- **Can delegate to sub-agent?** Yes.
- **Model**: Opus — analysis-heavy (extrapolation, footprint sizing, the route recommendation).
- **Notes**: the deliverable is the per-ply curve + the peak-layer footprint + a
  route recommendation (in-RAM layered vs external DDD), feeding the ply-windowing design.
