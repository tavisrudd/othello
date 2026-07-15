# C190 — Clebsch results consumed by gem mining

**Date**: 2026-07-15
**Lane**: `gem-mining` — see CLAUDE.md § Lane routing.
**Status**: **REPORTED — ROUTING COMPLETE**

## Verdict

The Clebsch lane has completed the finite work that overlapped two queued gem-mining tasks. Gem
mining must consume those results rather than reproduce them:

- **C160's finite calculation is superseded by Clebsch C187.** The standard frame in
  `PG(2,5)` has uncovered locus exactly the nonsingular conic
  `X^2+Y^2+Z^2+XY+XZ+YZ=0`, and the general `4 <= k <= 7` result places it beside the Clebsch
  hexagon as the only smaller conic-filling case in that range. C160 remains open only for the
  q=5 folklore/priority check: Edge §19, the complete-quadrangle/projective-frame literature, and
  `[4,1,4]_5` covering-radius tables. That residual decides attribution and framing, not truth.
- **C159 starts from Clebsch C184's complete q=11 six-arc table.** C184 has already computed,
  exactly, the degree-one through degree-six evaluation ranks and nullities for all fifteen
  six-arc projective classes,
  exhaustively tested exact loci through degree five, and exhausted the first nonzero degree-six
  kernel of C12. C159 must import that table as its q=11 seed rather than rerun the census. Its new
  work begins with the missing q<=11 cells, uniform cross-q normalization, and literature checks
  for any new exact loci.

These are ownership seams, not an expansion of C155. The hexad note keeps its current theorem
spine; at most it may cite the q=5 sibling in one sentence after C160 settles priority.

## Inputs and ownership

| Result | Owning lane/task | Gem-mining use |
|---|---|---|
| complete q11 six-arc low-degree rank/nullity table; exact loci C02/C04/C12/C15 | `clebsch` C184 | immutable seed data for C159; cite, do not recompute |
| q5 invariant conic and `4 <= k <= 7` conic-filling classification | `clebsch` C187 | closes C160 computation; leaves priority search |
| q5 literature and coding-table attribution | `gem-mining` C160 | still open |
| cross-q U-atlas beyond the completed q11 cell | `gem-mining` C159 | still open |
| hexad theorem and note | `gem-mining` C147/C155 | scope unchanged |

Primary reports:

- [C184 low-degree uncovered loci](2026-07-15-c184-low-degree-uncovered-loci.md)
- [C187 general k-arc conic filling](2026-07-15-c187-general-k-arc-conic-filling.md)
- [C153--C160 rationale](2026-07-14-c153-c160-queue-rationale.md)

## C159 import contract

C159 should preserve the C184 boundaries exactly:

1. Import all fifteen q11 six-arc rows and their degree-one through degree-six ranks/nullities.
2. Treat the exact-locus claims as exhaustive only through degree five, plus C12's
   six-dimensional minimum-degree-six kernel.
3. Do not infer that the other, larger degree-six kernels have no exact forms; they were not
   exhausted.
4. Retain C184's clean q11 headline: Clebsch is the unique class whose uncovered locus is
   contained in a cubic. The exact minimum-degree companions are the C02 smooth quartic, C04
   nodal quintic, C12 smooth sextic witness, and C15 conic.
5. Reuse the tracked C184 checker and table as provenance. A cross-q atlas may wrap or export its
   results, but must not silently fork its class labels or regenerate a competing q11 truth table.

## C160 residual

C160 is now a literature task. It should answer:

- whether the q5 frame/conic equality is explicitly stated in the complete-quadrangle,
  projective-frame, or Edge literature;
- whether the equivalent `[4,1,4]_5` covering-radius/deep-hole description appears in coding
  tables; and
- what terminology is safest: the four vertices of a complete quadrangle, or a projective frame.

Until that check lands, the q5 equality is verified but its novelty is unclaimed.

## Non-implication for the BSW conjecture

C187 does **not** advance the Blokhuis--Seress--Wilbrink exterior-set conjecture. Its
conic-filling condition says that the joins of the selected arc miss every point of one conic and
cover every point off it. Merely being an exterior set says that those joins are exterior to the
fixed conic, hence miss that conic; it does not require them to cover all off-conic points. The
BSW problem is also restricted to exterior points, whereas C187 classifies conic-filling arcs
without making that the universal organizing hypothesis. The implications point in the wrong
direction for C187 to strengthen BSW.

Consequently, the unread BSW originals remain a priority/attribution gate for the Clebsch
covering statement, and C187 supplies no new range, bound, or classification for their conjecture.

## Closeout

- C190: complete.
- C159: still queued, now seeded by C184.
- C160: finite computation closed by C187; literature/priority residue still queued.
- C155 and the BSW status: unchanged.
