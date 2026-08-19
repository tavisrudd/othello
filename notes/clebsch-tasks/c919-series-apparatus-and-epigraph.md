# C919 — De-brand the paper fronts and move the programme to a post-conclusion coda

**Lane:** `clebsch`
**Papers:** I (`clebsch-rigidity`), II (`clebsch-factorization`),
III (`clebsch-passages`), IV (`q13-passant-code`), V
(`chordal-conference-reconstruction`) — all five in one pass.
**State:** plan agreed, execution not started. No manuscript edited.

## Goal

Let each paper present itself first as an independent research article and carry
the *Clebsch: Rigidity from Sparse Shadows* programme as connective tissue after
its mathematical conclusion. Page 1 of every paper loses the series banner, the
Roman series number, and the poem; every paper gains an unnumbered coda headed
`\section*{Clebsch: Rigidity from Sparse Shadows}` holding the poem, the
programme map, and the series prose; and each "Reconstruction perspective"
interlude is redistributed sentence by sentence between introduction, coda, and
the cutting-room floor.

## Governing documents

- Author's implementation packet, verbatim:
  `../2026-08-18-c919-author-implementation-packet.md`. This is the
  specification; the plan below elaborates it and does not override it.
- Plan and per-paper decisions:
  `../2026-08-18-c919-series-apparatus-and-epigraph-plan.md`.

## Fixed decisions

1. No banner, no Roman number, no poem on page 1 of any of the five.
2. Coda in all five, immediately after the conclusion, and before `\appendix` in
   Papers II and III, which have appendices.
3. Poem wording is fixed by the packet; five real lines with subordinate Roman
   numerals, whole-line emphasis for the owning paper, no phrase-level bolding.
4. Map renamed "Programme map", current paper's box highlighted, I–III separated
   from IV by whitespace, and the duplicated Paper I and Paper III labels
   replaced by `deep-hole conference source` and `golden-descent conference
   source`. Paper II keeps "chordal companion".
5. All five papers in one pass; Paper III is not handed to C816.
6. Paper II gains the conclusion it currently lacks.
7. The sentence-level move/merge/cut test and its per-paper outcomes stand; the
   packet adopts them as requirements.

8. The poem carries three author amendments to the packet's text: line II is
   **"beneath it, paired chords turn true"**, line III is **"through many masks,
   the golden thread holds"**, and line IV is **"from bare, whispered words, a
   plane rises"**. Only lines I and V are packet-original. The plan's poem block
   is authoritative; do not restore the packet's wording for any line. Paper IV's
   coda prose must name its minimum words plainly, so the exact term stands
   beside the poem.
9. Removing the banner creates no metadata divergence: every paper's
   `.zenodo.json` already carries a bare title with no series label. A forward
   Paper V release will therefore correct that paper's stale Zenodo record title
   automatically, closing an open item from C918.

No author decisions remain open. Execution can start.

## Origin

Follows C918, which traced the poem's removal to commit `b19233879` under C904's
2026-08-11 series-framing pass.
