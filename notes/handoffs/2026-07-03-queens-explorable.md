# Queens explorable — interactive viz companion (Approach C) — Implementation

**Date**: 2026-07-03
**Session**: 2026-07-03--1 (`3687af49-6338-44b5-91da-933ad4ba1086`)
**References**: [proposal](../proposal-2026-07-02-interactive-viz.md) (Approach C accepted);
report design tokens in `notes/queens-report-intro-edit.html` (CSS custom props ~line 18,
`el`/`add` + `COL` ~line 1672); Rust engine ported from `rust/src/queens/geom.rs`,
`solver/naive.rs`, `solver/memo.rs::wins_keyed`, `solver/nimber.rs::grundy`.

## Context

Interactive single-file companion page for the report + n=18 paper:
`notes/queens-explorable.html`. Scene-based; a real JS port of the solver
(rules, attack masks, D4 canon, memoized α-β negamax with the static forcing
order, mex/Grundy, mirror strategy) drives the interactions. Approach C =
standalone first, report retrofit later; widgets are palette-parameterized and
take their stage element so the report can graft them into its figure slots.

Validation: `notes/queens-explorable-test.mjs` extracts the `queens-core` and
`queens-data` script blocks straight out of the HTML (single source of truth)
and cross-checks against the Rust solver. Run:

```
node --max-old-space-size=512 notes/queens-explorable-test.mjs
```

**All checks pass (2026-07-03).** The gates:

- verdicts n=1..10 = sign of A344227; nimbers G(1..9) = A344227
- node counts vs Rust `symmetry` solver: **exact at n=6/7/8 (27/54/625)**;
  n=9/10 js counts 853/94,083 vs rust 858/94,760 — js ≤ rust within 1% is the
  gate (the Rust fixed-size TT re-expands a few evicted entries; the exact JS
  Map never does). Exactness at n≤8 proves the move-order + recursion port.
- naive (memo-less) vs memo agree n≤7; mirror-line legality/parity odd n;
  canon invariance under all 8 transforms (200 random masks)
- **n=18 PV validated**: `I9 K8 G10 J11 H3 M7 N16 E4 P6 D12 O13 F2 R5 L17 A14`
  is legal, 15 plies, ends board-dead; **I9 deletes 68 of 324** (matches the
  "record 68-square deletion"); deletion schedule
  `324 → 256 → 200 → 156 → 110 → 88 → 63 → 44 → 32 → 23 → 14 → 9 → 5 → 3 → 1 → 0`
  (so scene 6 derives the schedule from the PV — nothing extra hard-coded).
- square convention (from `rust/src/bin/queens.rs:503`):
  `name = colLetter('A'+sq%n) + (sq/n + 1)`; rank 1 drawn at the bottom.

## Key Architecture Decisions

- **Single source of truth in the HTML**: the Node harness regex-extracts the
  `<script id="queens-core">` / `<script id="queens-data">` blocks. Never copy
  the engine into a second file.
- **Masks are BigInts** (bit s = square s = r·n + c); memo `Map` keyed by
  BigInt available-mask. The memo holds BOTH the canonical key and raw-alias
  entries (any available-mask names the same game value as its canonical
  image, so mixing is sound); `nodes` counts canonical misses only —
  comparable to Rust.
- **Hot paths run in 32-bit Number words**, not per-bit BigInt ops: `canon`
  scatters bits through word arrays and assembles a BigInt only for a winning
  transform (returns the input object when already canonical, preserving
  `canon(m) === m`); the search recurses on the available mask with
  `keep[sq] = board & ~attack[sq]` and per-square membership tested in words.
- **Per-board-size core evaluation** (scene 1 `engineFor`): each n gets a
  fresh `new Function(coreText)()` evaluation so V8's BigInt type feedback
  stays monomorphic — mixing sizes through one set of functions measured ~3×
  slower at n=10 (5.6s vs 1.9s). CSP-blocked eval falls back to the shared
  core (correct, slower).
- **Do NOT benchmark the engine under `node:vm`** — the contextified sandbox
  routes every global lookup through a C++ interceptor
  (`ContextifyContext::PropertyGetterCallback` was 84% of ticks); the harness
  evaluates via `new Function` in the main realm instead.
- n=10 root solve is ~2–6s (box was fully loaded by the n≥17 nimber run; a
  user's idle browser should sit at the low end). n≤9 is instant. The n=12
  Web-Worker live solve stays a stretch goal.

## Chunks (proposal phases)

1. **DONE — core + Scene 1 (playable game) + Scene 2 (odd-n mirror)**.
2. **Concept scenes**: D4 explorer (8 orientations fold live, canonical
   highlighted, merged counter), board⇄graph morph (Node Kayles view).
   `Queens.sym` / `canon` and the `makeBoard` widget give the pieces.
3. **Showcase**: n=18 PV theater (step/auto-play, deletion-schedule bar
   derived live, τ point-reflection G10 = τ(K8) geometry, two-run
   cross-validation card: 258.3B / 114.3B in `QueensData.n18`); nimber chart
   (A344227 + G(14..16)=0,1,0, **explicit OPEN cells for G(17)/G(18)** — G(17)
   run in flight 2026-07-03); speedup timeline. **Load the `dataviz` skill
   before the two charts.** Leaderboard data is NOT yet in `QueensData` — pull
   final numbers from the report/CLAUDE.md when building scene 10.
4. **Solver internals**: search X-ray (instrument `Solver.winsAvail` with a
   rate-limited event log feeding a schematic tree; static vs dynamic ordering
   A/B with live node counter), getK/W_K walkthrough, Grundy playground
   (`Grundy` class is already in core, validated).
5. **Polish + optional report retrofit**: mobile, no-JS fallbacks (CSS
   skeleton exists: `.no-js .stage::before`), wire links from report + paper,
   graft board/D4/pruning-tree widgets into report figure slots.

## Codebase Reference

| What | Where |
|-------------------------------------|-----------------------------------------------------|
| The page (core + data + scenes) | `notes/queens-explorable.html` |
| Validation harness | `notes/queens-explorable-test.mjs` |
| Engine port source of truth | `rust/src/queens/geom.rs`, `solver/memo.rs:134-200` |
| Square-name convention | `rust/src/bin/queens.rs:503` |
| Report tokens / SVG helper / COL | `notes/queens-report-intro-edit.html` ~18, ~1672 |
| n=18 PV + node counts | `QueensData.n18` in the page; n18 umbrella handoff |

## Delegation Strategy

- Scenes 3–4 chunks (PV theater, charts, X-ray): **can delegate** to Opus
  sub-agents one scene at a time — isolated widgets with a validated core;
  main context reviews + runs the harness. Charts require the dataviz skill.
- Core engine changes: **keep in main context** — every change must re-run
  the harness gates (node counts are the regression tripwire).
- **Box constraint while long runs are in flight** (25h+ n≥17 nimber run,
  2026-07): do NOT launch the Rust binary (TT alloc), no `make`/mold builds,
  no browsers; Node with `--max-old-space-size=512` only.

## Workflow Instructions

Read this file first; check Progress; after work, update Progress + add a
dated Handoff Note with session id. The engine gate = the harness passing;
any scene addition should keep the page dependency-free and single-file.

## Progress

- [x] Phase 1: queens-core engine + harness (53 checks) + Scene 1 (play vs
      perfect solver, oracle, undo/reset, hover attack preview) + Scene 2
      (centre + 180° mirror demo with pair links)
- [x] Scene 3 (user-requested, 2026-07-03): search-space stats + scaling —
      live naive-vs-memo measurement n=1..10 with StatsSolver counters, log
      chart with Rust milestones, KPI tiles, table view (harness now 72 checks)
- [x] Scene 4 (user-requested, 2026-07-03): tactic contributions — pre-canned
      ablation ladder (bare α–β → +ordering → +memo → +symmetry, plus a
      remove-the-cutoff reference; n selector 4..10) + the n=16 production
      lineage small-multiples (wall + nodes, 12 tactics, tooltips + table).
      ALL ladder cells re-derived by the harness (n=10 under QUEENS_TEST_SLOW,
      verified green this session; 81 fast / 82 slow checks). New core exports:
      `naiveCountUnordered`, `RawMemoSolver`. Notable data: at n=10 ordering
      alone is only ×1.23 (loss board — every root move must be refuted) vs
      ×38.6 at n=8; G(10)=0 confirmed live (552,611 full-mex nodes).
- [ ] Phase 2: D4 explorer, board⇄graph morph
- [ ] Phase 3: n=18 PV theater, nimber chart (open G17/G18 cells), speedup
      timeline (needs leaderboard data block + dataviz skill)
- [ ] Phase 4: search X-ray (ordering A/B), getK walkthrough, Grundy playground
- [ ] Phase 5: polish, no-JS/mobile, wire links from report + paper, optional
      report retrofit
- [ ] In-browser visual pass (BLOCKED this session: no browsers while the
      long run holds the box) — verify scenes render/interact, then tune

## Handoff Notes

### Phase 1 Handoff (2026-07-03)

**Session**: 2026-07-03--1 (`3687af49-6338-44b5-91da-933ad4ba1086`)
**Completed**: page skeleton on the report's design tokens (dark palette,
topbar/hero/scene cards, planned-scenes stub, no-JS fallback), full engine
port (Queens geometry, D4 canon, memo+symmetry α-β solver, best-move, Grundy,
mirror line, square names), 53-check validation harness, Scenes 1–2 wired.
**Files created/modified**: `notes/queens-explorable.html`,
`notes/queens-explorable-test.mjs`, proposal Status updated.
**Deviations from plan**: proposal's "n≤10 well under a second" was wrong for
BigInt JS — n=10 is seconds, mitigated (see decisions); harness compares node
counts as js ≤ rust within 1% rather than exact at n=9/10 (Rust TT eviction
re-expansion, exact at n≤8).
### Scene 3 Handoff (2026-07-03, same session)

**Session**: 2026-07-03--1 (`3687af49-6338-44b5-91da-933ad4ba1086`)
**Completed**: "How the search space grows" scene — a Run button re-solves
n=1..10 live (naive + StatsSolver + Grundy, fresh core per step), progressive
render into: KPI tiles (positions, moves explored, TT-hit split, avg cutoff
position, the growing per-+2-rows factor), a log-scale line chart (live series
+ 6 hard-coded Rust milestones as diamonds, crosshair/tooltip with keyboard
arrows, legend, table-view twin), all per the dataviz skill.
**Key facts baked in**: naive n=10 = 13,990,969 nodes (~40 s live ⇒ shipped
precomputed in `QueensData.naive10`; harness re-verifies under
`QUEENS_TEST_SLOW=1`); naive regression pins {6:154, 7:1556, 8:7612, 9:49752};
memo-vs-naive at n=10 ≈ ×149; n=8 avg win-node cutoff ≈ 2.01 tries.
**Chart palette** (validated, dataviz six checks, all-pairs CVD, dark surface
#18202a): memo #1f97d4 · naive #c98123 · milestones #cc4d75 (+ #3fae4f spare)
— darker steps of the report's hue families; the page accent tokens are TOO
LIGHT for marks (L>0.77, band is 0.48–0.67). Reuse these for future charts.
**StatsSolver** is a separate instrumented `winsAvail` copy — harness asserts
node-for-node identity with Solver; keep them in sync on any core change.

**Instructions for next agent**: the page is UNVIEWED in a browser — do the
visual pass before building more scenes if the box allows a browser by then;
engine perf conclusions from this session were measured on a fully loaded box
(24-core solver run) — re-measure before optimizing further; keep the harness
green after ANY touch to the core script block (extract-by-regex means editor
moves of the `<script id=…>` tags break extraction loudly — fine, but keep the
ids).
