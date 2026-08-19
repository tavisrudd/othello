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
2. Coda in all five, immediately after the conclusion; before `\appendix` in
   Papers II and III, which have appendices.
3. Poem wording is fixed by the packet; five real lines with subordinate Roman
   numerals, whole-line emphasis for the owning paper, no phrase-level bolding.
4. Map renamed "Programme map", current paper's box highlighted, I–III separated
   from IV by whitespace, Paper I and Paper III labels made distinguishable.
5. All five papers in one pass; Paper III is not handed to C816.
6. Paper II gains the conclusion it currently lacks.
7. The sentence-level move/merge/cut test and its per-paper outcomes stand; the
   packet adopts them as requirements.

## Open questions for the author

1. Poem line IV reads "from bare words, a plane rises", where Paper IV's subject
   is its *minimum* words — the paper's central technical term and the object in
   its title. Intended, or a slip for "minimum words"?
2. Coda placement in Papers II and III: after the conclusion and before
   `\appendix` (recommended), or after the appendices immediately before the
   references?
3. Paper I and Paper III map labels: `deep-hole conference companion` and
   `golden conference companion` (recommended, both adjectives verbatim from
   those papers' titles), or the paper-native pair `deep-hole conference source`
   and `golden-descent conference source`, which avoids reusing Paper V's
   technical sense of "companion"?
4. Removing the Roman numeral changes each paper's first-page identity while the
   deposited Zenodo titles and the `papers/summary/` table keep the series label.
   Restate the deposit titles at the next release, or let them diverge?

## Origin

Follows C918, which traced the poem's removal to commit `b19233879` under C904's
2026-08-11 series-framing pass.
