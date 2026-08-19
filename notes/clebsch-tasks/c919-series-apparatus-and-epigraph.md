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

8. Poem line IV keeps "from bare words, a plane rises" unless the author accepts
   a replacement; "bare" is a deliberate poetic loosening of "minimum", not a
   slip.
9. Removing the banner creates no metadata divergence: every paper's
   `.zenodo.json` already carries a bare title with no series label.

## Open question for the author

One only. Line IV of the poem: the author invited a truer and equally short
replacement for "minimum". The plan proposes **"from lightest words, a plane
rises"**, on the grounds that a codeword's *weight* is its number of nonzero
positions, so Paper IV's minimum words are its minimum-weight words and
"lightest" is the exact plain-English rendering rather than a loosening.
Alternatives offered: "least words" and "sparse words". Keep "bare words" if all
three are declined.

## Origin

Follows C918, which traced the poem's removal to commit `b19233879` under C904's
2026-08-11 series-framing pass.
