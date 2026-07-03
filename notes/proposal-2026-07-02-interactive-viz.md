# Proposal: Interactive companion visualization for the Queens report/paper

## Status

Accepted (Approach C) — Phase 1 landed 2026-07-03: `notes/queens-explorable.html`
(queens-core engine + Scenes 1–2) validated by `notes/queens-explorable-test.mjs`.
See handoff `notes/handoffs/2026-07-03-queens-explorable.md`.

## Problem

The project has two written artifacts — the narrative HTML report
(`notes/queens-report-intro-edit.html`) and the formal paper
(`notes/queens-n18-paper.md`) — but no interactive piece. Everything a reader
can touch today is static:

- The report's figures are JS-*generated* SVG but static once rendered: no
  animation, no user input, no playable game. The concepts that most reward
  interaction (place a queen and watch the attack set delete squares; watch
  α-β + TT + ordering prune a live tree; step through the n=18 PV) are
  explained only in prose and frozen pictures.
- The report is scoped to the June-21 / n=16 story. The headline results that
  came after — **n=18 first-player win via I9**, the 15-ply PV, the killer
  stack and the 13.43s record, the nimber extension G(14..16) and the broken
  even→0 oscillation, the Lean-checked leaf evaluator — have no visual home at
  all.
- The paper is markdown destined for a PDF-ish venue; it cannot carry
  interactivity itself and needs a linkable supplement.

The ask: a beautiful, fun, interactive HTML+JS visualization of (a) the game
itself and (b) the solver's tricks, to accompany the report/paper.

## Context

**What exists (from the report survey):**

- The report already has a coherent dark design system (CSS custom props:
  `--bg #0f1419`, accents `#4cc2ff` blue / `#ffb454` orange / `#7ee787` green
  = win / `#ff7b9c` pink = loss; 920px column; MathJax; `.keyidea` /
  `.intuition` card conventions) duplicated in JS as a `COL` palette object,
  plus an `el`/`add` SVG-builder helper and a **Plain-English / Engineer
  dual-view toggle** (global + per-section, localStorage-persisted). All ten
  figures are drawn with this machinery. A companion piece that reuses these
  tokens will read as part of the same publication.
- The ten existing figures cover: attack/available board, growth chart, D4
  eight-orientations, 256→36 roots fold, board→conflict-graph, annotated
  pruning tree, W9→pext→W8 resolver, TT-writes-by-popcount bands, wall-clock
  lineage chart, transposition convergence.

**What the engine port costs (from the code survey):** the whole game is one
`blocked` bitmask; `attack[sq]` is a four-clause row/col/diag test
(`geom.rs:46-64`); a move is `blocked | attack[sq]`; loss = no available
square. D4 canon = lex-min over 8 permuted masks (`geom.rs:19-32`, `172-183`).
The memo-less ground truth is `solver/naive.rs` (the recursion is ~10 lines);
the memoized layer is `memo.rs:144-192`; the reference Grundy/mex engine is
`nimber.rs:32-47`. A from-scratch JS port of rules + attack masks + D4 canon +
memoized negamax + mex is small (on the order of a hundred lines) and **n≤10
solves live in the browser in well under a second** (n=8 memo+symmetry ≈ 626
nodes; n=10 a few ×10⁴). Odd n is O(1) by the mirror strategy — itself a great
demo.

**Machine-readable data available to hard-code:** the 15-ply n=18 PV
`I9 K8 G10 J11 H3 M7 N16 E4 P6 D12 O13 F2 R5 L17 A14` with its per-move
deletion schedule (256→200→156→…→1→0), both n=18 node counts
(258.3B / 114.3B), the n=16 leaderboard (3360s → 13.43s), the nimber sequence
A344227 + G(14)=0, G(15)=1, G(16)=0, the TT-bands histogram, and the
distinct-position growth series. `solve --to-file` JSON does **not** contain
the PV — the PV lives in the n18 umbrella handoff as text; the viz hard-codes
it as a data block.

**Prior art in `notes/`:** no prior proposal covers visualization; this is new
ground.

---

## Approach A: Retrofit — upgrade the report's figures in place

### Architecture

Work inside `queens-report-intro-edit.html`. Replace/augment the ten static
SVG figures with interactive versions using the existing `el`/`add` helper:
the §1 board becomes clickable (place queens, watch deletions), the §4 D4
figure gets a drag-to-place canonical-key explorer, the §7 pruning tree
animates, and new figures are appended for the post-June-21 material (PV
player, nimber chart). The playable-game and search-visualizer scenes are
inserted as new sections.

### Trade-offs

**Strengths:**
- One artifact; readers are already there; design consistency is automatic.
- The dual-view (layman/engineer) convention extends naturally to captions.
- No duplicated explanations — interactivity lands next to the prose that
  motivates it.

**Weaknesses:**
- The report's narrative is scoped to n=16 / June 21 and is **mid-edit**
  (`intro-edit` working copy); grafting the n=18 arc means rewriting its
  story, not just adding figures — large churn risk to a hand-crafted 229 KB
  document.
- A playable game and a scene-driven PV walkthrough don't fit a linear
  long-read; they fight the document's rhythm.
- The paper still has nothing to link to as a self-contained supplement — a
  reviewer/arXiv reader would be pointed at a personal-narrative report.

---

## Approach B: Standalone explorable companion page

### Architecture

A new single-file, dependency-free `notes/queens-explorable.html` (working
title: *"The Queens Game — play it, then see inside the solver"*), built on
the report's design tokens but with its own scene-based structure. Linked
prominently from both the report and the paper ("interactive supplement").

Layout: a sticky scene nav + full-width interactive stage per scene, prose
kept deliberately short (the report/paper carry the depth; every scene links
back to the section it illustrates).

```
queens-explorable.html
├── <style>   report tokens + scene/stage components
├── <script>  queens-core   — Bits-as-BigInt, attack tables, place/avail,
│             D4 canon (8 transforms + lex-min), memoized negamax with
│             child-popcount ordering, mex/grundy, PV extraction,
│             odd-n mirror strategy
├── <script>  data blocks   — n=18 PV + deletion schedule, leaderboard,
│             nimber sequence, growth + bands series (hard-coded)
└── <script>  scenes        — each scene = init(stageEl) + teardown,
              SVG via the report's el/add pattern
```

**Scene inventory** (the "fun" budget — priorities set here, trimmed in
implementation):

| #  | Scene                       | Interaction                                                                                                                                                    | Priority |
|----|-----------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------|----------|
| 1  | **Play the game**           | n = 4..10 selector; hover previews the attack cross; click places a queen; play vs the in-browser *perfect* solver; live "who wins from here" oracle; undo/reset | must     |
| 2  | Odd boards are free         | Computer takes center then visibly mirrors every reply by 180°; the invariant highlighted each ply                                                              | must     |
| 3  | Symmetry (D4)               | Place queens; the 8 orientations render live; lex-min canonical highlighted; running "positions merged" counter                                                  | must     |
| 4  | Board ⇄ graph (Node Kayles) | Morph animation between board squares and conflict-graph vertices; a move = vertex + neighborhood deletion, shown in both views at once                          | must     |
| 5  | Search X-ray                | Small-n live search rendered as a growing tree: α-β cutoffs, TT hits, D4 merges flash; **toggle static vs dynamic move ordering and watch the real node counter change** | must |
| 6  | The n=18 showcase           | 18×18 board; I9's record 68-square deletion; step/auto-play the 15-ply PV with the 256→0 deletion-schedule bar; the τ point-reflection geometry (G10 = τ(K8)); two-run cross-validation card | must |
| 7  | Sprague–Grundy playground   | Split a position into components; per-component nimbers, XOR, mex calculator; the heap-sum trick (board + Nim-heap(k), ascending k until first LOSS) as a schematic | should |
| 8  | W_K / getK walkthrough      | Interactive version of the report's w9 figure: click a vertex, watch the induced-subgraph code projection (the pext idea) and the W8 bit lookup                  | should   |
| 9  | Nimber sequence chart       | A344227 + our G(14..16); the even→0 oscillation and its break at n=18; G(17)/G(18) as open cells                                                                 | should   |
| 10 | Speedup timeline            | Animated leaderboard 56 min → 13.43 s (log scale); each bar expands to a one-line trick + link into the report section                                          | should   |
| 11 | TT / memory story           | Bands histogram + slot layout (fingerprint/value) as an interactive probe demo                                                                                   | could    |

Engine notes: `Bits` = one `BigInt` (n≤10 needs ≤100 bits); memo = `Map`
keyed on canonical-mask string; the solver runs synchronously (n≤10 is
instant). n=12 live solve (~1M canonical positions) is a stretch goal behind a
Web Worker + progress bar, not a dependency. Charts (scenes 9–10) follow the
dataviz skill at build time.

### Trade-offs

**Strengths:**
- Covers the full arc **including everything post-June-21** without touching
  the report's in-flight edit.
- Self-contained single file: works from `file://`, GitHub Pages, or as arXiv
  supplementary material; no build step, no CDN, CSP-safe.
- Creative freedom for the playful pieces (playable game, PV theater) that a
  linear report can't host.
- The paper gets a proper "interactive supplement" link.

**Weaknesses:**
- A second artifact to keep in sync as results move (G(17)/G(18) pending).
- Some conceptual overlap with the report's figures (D4, graph view) —
  mitigated by linking rather than re-explaining.
- Its own (thin) narrative frame still has to be written.

---

## Approach C: Shared-core hybrid — standalone first, retrofit second

### Architecture

Build Approach B, but structure the code so the report can consume it later:
`queens-core` (engine) and each scene's widget are written as
self-registering, palette-parameterized functions. Phase-final: graft two or
three widgets (clickable §1 board, D4 explorer, animated pruning tree) into
the report's existing figure slots as progressive enhancement — the static
SVG remains the no-JS fallback, matching the report's `.no-js` convention.

### Trade-offs

**Strengths:**
- All of B's strengths, plus the report's best figures eventually become
  live — one engine, two homes, no forked logic.
- The retrofit is optional and incremental; the report edit stays unblocked.

**Weaknesses:**
- Slightly more discipline up front (widgets must not assume the explorable's
  page chrome).
- The retrofit step still touches the 229 KB report file eventually — churn
  deferred, not eliminated.

---

## Approach comparison

| Criterion                                | A: Retrofit report        | B: Standalone explorable | C: Hybrid (B then graft)  |
|------------------------------------------|---------------------------|--------------------------|---------------------------|
| Covers n=18 / killers / nimbers / Lean   | Only via major rewrite    | Yes, natively            | Yes, natively             |
| Risk to the in-flight report edit        | High                      | None                     | None now, low later       |
| Paper gets a linkable supplement         | Weak (narrative report)   | Yes                      | Yes                       |
| Playable game / scene-driven pieces fit  | Poorly (linear long-read) | Naturally                | Naturally                 |
| Design consistency with report           | Automatic                 | By reusing tokens        | By reusing tokens         |
| Duplicate explanation risk               | None                      | Some (link back instead) | Some                      |
| Long-term: report figures become live    | Immediately               | Never                    | Eventually, cheaply       |
| Up-front structural cost                 | Low per figure            | Low                      | Slightly higher (widgets) |

---

## Open questions

1. **Hosting/distribution** — repo file only, GitHub Pages, or bundled as
   arXiv ancillary file with the paper? (Single-file design keeps all three
   open.)
2. **Dual-view toggle** — carry the Plain-English/Engineer convention into the
   explorable's captions, or keep one register and rely on links into the
   report for depth?
3. **Live-solver ceiling** — ship n≤10 (guaranteed instant) or invest in the
   n=12 Web-Worker stretch?
4. **Search X-ray fidelity** — schematic tree (deterministic, replayable) vs
   instrumenting the real JS search (live but visually noisy)? Likely: real
   search feeding a rate-limited event log into a schematic renderer.
5. **Nimber pendings** — G(17) is in flight; design the sequence chart with
   explicit "open" cells so the file doesn't go stale.
6. Whether the paper's §5.4 PV-geometry discussion (embedded 17×17 sub-board,
   L-border) earns its own scene or folds into scene 6.

## Recommendation

**Approach C** — build the standalone explorable with a shared, reusable core,
and treat the report retrofit as an optional final phase.

Justification:

1. The report is mid-edit and scoped to the n=16 story; the headline material
   the viz most wants (I9, the PV, the nimber break) lives only in the paper.
   A standalone piece delivers it without destabilizing either document.
2. The paper needs a linkable, self-contained interactive supplement; only
   B/C provide one.
3. The engine port is confirmed cheap and fast (n≤10 perfect play is instant
   in-browser), so the playable-game centerpiece — the single most "fun"
   element — is low-risk; structuring it as a reusable widget costs little
   extra and buys the report's figures a future upgrade path.
4. Reusing the report's design tokens + SVG-builder pattern makes the two
   pages read as one publication with near-zero design invention.

### Implementation phases

1. **Core + centerpiece (validates everything):** `queens-core` JS engine
   (rules, attack tables, D4 canon, memoized negamax + ordering, mex, PV,
   mirror strategy) with a small test harness cross-checked against the Rust
   solver's known values (n≤10 verdicts, n=8 node counts, A344227 nimbers);
   Scene 1 (playable game) + Scene 2 (odd-n mirror) on the report's design
   tokens.
2. **Concept scenes:** D4 explorer (3), board⇄graph morph (4).
3. **The showcase:** n=18 PV theater + I9 geometry (6); nimber-sequence and
   speedup charts (9, 10) — load the dataviz skill before building these.
4. **Solver internals:** Search X-ray with the ordering A/B toggle (5); getK
   walkthrough (8); Grundy playground (7).
5. **Polish + optional retrofit:** mobile/no-JS fallbacks, links wired into
   report + paper; graft the clickable board / D4 / pruning-tree widgets into
   the report's figure slots (the deferred Approach-A slice).
