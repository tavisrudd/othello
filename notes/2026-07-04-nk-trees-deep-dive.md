# Node-Kayles on trees — deep-dive (the boundedness gate FAILS here)

**Date:** 2026-07-04
**Scope:** the first "go deep" run on what was ranked the #1 quick-win target. **Verdict: the
bounded-state DP route to poly-time is CLOSED** — caterpillar/spider nimbers *and* the tree-DP
sufficient statistic are both UNBOUNDED. L3 false-twin compression is validated and sound but does
not tame the obstruction, so trees is **not** a quick poly-time win; it stays genuinely open
(consistent with Bodlaender–Kratsch, arXiv:2003.11775) and now points toward a *hardness* result.
Companion to [open-problem-targets](2026-07-04-node-kayles-open-problem-targets.md). All runs
single-core under an 800 MB cap.

## Confirmed (solid)

- **Solver validated three ways.** Node-Kayles on paths reproduces OEIS **A002187** (Dawson's chess,
  octal .137) exactly for 103 terms across three independent solvers (path DP, tree-AHU, bitmask).
  Disambiguation the run caught: **A002186 = ordinary Kayles (octal .77), NOT ours.** Stars match
  the hand derivation `G(K_{1,k}) = 1` (k odd) `/ 2` (k even). 300 random caterpillars: three-way
  agreement, 0 mismatches.
- **L3 false-twin parity compression — VALIDATED, 0 failures in 2807 tests** (stars 7/7; random
  trees + planted false-twin leaf bundle 1400/1400; random general graphs + planted false-twin
  class 1400/1400). L3 is sound exactly as stated. **But it does not settle the complexity** (see
  the crux). Generalization to identical *pendant-subtree* pairs FAILS uniform period-2: the
  multiplicity sequence is eventually period-2 but the preperiod is pendant-dependent (leg-length
  ℓ=4 → preperiod 2). Leaves are the clean case; L3 stands for leaves/false-twins only.
- **Closed forms for uniform caterpillar families (empirical, 40+ terms):** path (0 leaves) =
  A002187 (bounded, max 9); **comb (1 leaf/vertex, corona P_s∘K₁): G = s mod 2** (period 2);
  **double comb (2 leaves/vertex): period 4, [2,1,3,0] by s mod 4**; uniform-leg spiders: period-2
  in leg count (consistent with arXiv:2512.24221 Thm 2.1).

## The crux — UNBOUNDED

- **Caterpillar nimbers are unbounded.** Exhaustive max over all caterpillars (full {0,1,2}^s
  decoration enumeration) vs spine length s: **2,3,3,4,5,7,8,9,11,11,12,13** for s=1..12 — ~linear
  growth, passing the path ceiling (9) at s=9. Every *fixed* decoration family is periodic/bounded;
  the unboundedness is a 2-D/aperiodic phenomenon needing increasingly irregular decorations — the
  same shape as the 3×N-grid obstruction.
- **Spider nimbers are unbounded** too; the argmax always uses *distinct* leg lengths, which behave
  like distinct Nim-heaps (the driving mechanism).
- **The tree-DP sufficient statistic grows EXPONENTIALLY.** Rooting the tree, each subtree interacts
  through its root, so a DP must summarize a subtree by a context-equivalence class.
  - The natural 2-integer summary `(G(T), G(T−root))` is provably insufficient — explicit collision
    (14 (A,B) pairs vs 47 classes at size ≤7).
  - Context-equivalence class count of rooted subtrees of size s: **1,1,2,4,8,16,~33 for s=1..7
    ≈ 2^(s−2)** (lower bounds, robust across context batteries); at s=7 the 48 rooted trees barely
    merge (≥33 classes). The summary carries ≥~(s−2) bits — not bounded.

**Verdict.** The "bounded/constant-state DP ⇒ poly-time" route is CLOSED; the 3×N-style
unboundedness recurs *over the L3-reduced alphabet*, corroborating why tree Node-Kayles is open.
**Precise scope:** this rules out a bounded/constant-state DP, NOT poly-time outright — a poly-time
algorithm, if one exists, must carry a super-constant but poly-size summary closed under
child→parent combination.

## Reranking consequence

Trees was ranked the "cleanest quick win" on the premise that L3 was the exact missing tool. That
premise is half-right: **L3 is validated and sound, but it does not settle the complexity** — the
unboundedness survives compression. Two paths forward:

1. **Pivot to hardness.** The exponential context-class growth is structural evidence toward a
   hardness result (the parameterized scout noted the Grundy-Coloring analogue is W[1]-hard by
   treewidth). A reduction encoding the context-classes could settle the complexity the other way.
2. **Bank the crumbs.** The comb (`s mod 2`) and double-comb (period-4 `[2,1,3,0]`) closed forms and
   the validated L3 are small OEIS/writeup results on their own.

This is the **first of the three boundedness faces to be measured — and it FAILED.** It raises the
prior that the unifying gate fails in general. The two boundedness questions that still decide the
expensive prizes: (a) whether the single 1-parameter sequence `G(3×n)` stays bounded (distinct from
the 2-D caterpillar family — each fixed 1-parameter caterpillar family *was* bounded, so `G(3×n)`
could still be bounded); (b) whether the n=18 exception book stays bounded.

## Caveats

- Caterpillar values for spine >6 are from the AHU solver alone (bitmask cross-check reached ≤16
  vertices); three-way agreement to 103 path terms + stars + L3 + 300-caterpillar cross-check give
  high confidence, but the largest caterpillars aren't independently bitmask-verified.
- Context-class counts are lower bounds (finite battery); the ~2^(s−2) trend is robust, the exact
  formula is not proven (33 not 32 at s=7 was battery-dependent).
- comb/double-comb closed forms are empirical (40 terms + recurrence sketch), not proven here.
- Did not exhaustively check the literature for a prior explicit all-caterpillar/spider
  unboundedness proof (fetched paper content covers only bounded 1-parameter families).

## Scripts

Reusable engine + validated lemma copied here; experiment scripts remain in the scratchpad dir.
- `2026-07-04-nk-core.py` — three solvers (bitmask general-graph; tree-AHU with global canonical
  memo; path DP) + graph builders.
- `2026-07-04-nk-l3.py` — L3 compression + validation harness.
