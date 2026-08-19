# C919 — De-brand the paper fronts and move the programme to a post-conclusion coda

**Lane:** `clebsch`
**Papers:** I (`clebsch-rigidity`), II (`clebsch-factorization`),
III (`clebsch-passages`), IV (`q13-passant-code`), V
(`chordal-conference-reconstruction`) — all five in one pass.
**State:** complete, reported 2026-08-19. All five manuscripts edited, rebuilt
warning-free, and forward-committed to their standalone repositories. The
refactor landed in `1142b4bad`; an independent cold read
(`../2026-08-19-c919-cold-read.md`) then drove seam repairs, the removal of
series numbers from the running text in favour of titles and citations, and an
authorized follow-up pass on the codas. Completion report:
`../2026-08-19-c919-series-apparatus-completion.md`.

## Goal

Let each paper present itself first as an independent research article and carry
the *Clebsch: Rigidity from Sparse Shadows* programme as connective tissue after
its mathematical conclusion. Page 1 of every paper loses the series banner, the
Roman series number, and the poem; every paper gains an unnumbered coda headed
`\section*{Clebsch: Rigidity from Sparse Shadows}` holding the poem, the
programme map, and the series prose; and each "Reconstruction perspective"
interlude is redistributed sentence by sentence between introduction, coda, and
the cutting-room floor.

This is a presentation and structure refactor. Do not change mathematical
claims, theorem statements, proofs, notation, or bibliography content except
where prose is explicitly being moved or a redundant sentence explicitly cut.

## Governing documents and precedence

- **Author's implementation packet, verbatim:**
  `../2026-08-18-c919-author-implementation-packet.md`. This is the
  specification.
- **Plan and per-paper decisions:**
  `../2026-08-18-c919-series-apparatus-and-epigraph-plan.md`. Read it in full
  before editing; it holds the file-and-line map of what is on the page today,
  the sentence-by-sentence disposition of all five interludes, and the gates.

The packet governs **except** where the plan records a later author decision or a
source-state correction. The authoritative differences are the poem text (plan
§3); the programme-map labels, target, and caption (§4); the coda placement in
Papers II and III (§2); and the Paper II source reconciliation (§0 and §5). Where
they differ, the plan wins. Do not "correct" any of them back to the packet.

Two further standing rules from the plan. Wherever it supplies exact replacement
or coda prose, use that text as the default rather than synthesizing new prose.
And its line numbers are advisory: run the §0 preflight and match passages by
content and label, since the checkout may have moved.

## The poem

Final text, identical in all five papers, set as five real lines with small
light Roman numerals as a subordinate leading column:

```text
I    From deep holes, a form arises;
II   beneath it, paired chords turn true;
III  through many veils, the golden thread runs;
IV   from bare, whispered words, a plane rises;
V    beneath one form, two shadows, a hidden twist between.
```

Lines II, III, and IV are author amendments to the packet's text; only I and V
are packet-original. Each paper emphasizes its whole line, and its matching map
box, with one restrained mechanism used consistently across all five — no
phrase-level bolding, and the poem must still read naturally when the emphasis
is ignored. Do not let the typesetting wrap a line; the line lengths carry the
poem's shape.

## Fixed decisions

1. No banner, no Roman series number, no poem on page 1 of any of the five.
2. Coda in all five, immediately after the conclusion, and before `\appendix` in
   Papers II and III, which have appendices.
3. Coda contents in this exact order: the `\section*` heading, the five-line poem
   with the owning line emphasized, the programme map with the owning box
   emphasized, the standard logical-independence sentence from plan §4, then the
   paper-specific coda prose fixed in plan §5 and §6. No prose between poem and
   map.
4. Map renamed "Programme map", the current paper's box highlighted, Papers I–III
   separated from Paper IV by whitespace, and the duplicated labels replaced by
   the four settled in plan §4 and shipped: `deep-hole conference cubic`,
   `matching-quotient chordal cubic`, `golden-descent conference cubic`, and
   `marked cubic correspondence`. An earlier revision of this card named
   "conference source" labels and kept "chordal companion" for Paper II; those
   were superseded before implementation and never used.
5. All five papers in one pass; Paper III is not handed to C816.
6. Paper II's existing conclusion is preserved. It is a `\section*{Conclusion}`
   sitting immediately before `\appendix` in `clebsch_factorization.tex`; an
   earlier revision of this card wrongly reported it as missing, because the
   search that established the section list matched only unstarred `\section{`.
   Do not draft, replace, or add a second conclusion under C919.
7. Paper V's conclusion is split: its own results stay, and the programme-level
   material moves to its coda.
8. The sentence-level move/merge/cut test and its per-paper outcomes stand; the
   packet adopts them as requirements. The test is: does the sentence describe
   this paper's mathematics, or where this paper sits? Per-sentence dispositions
   are in the plan.
9. Paper IV's coda prose must name its minimum words plainly, so the exact term
   stands beside the poem's "bare, whispered words".
10. Removing the banner creates no metadata divergence: every paper's
    `.zenodo.json` already carries a bare title with no series label. A forward
    Paper V release will therefore correct that paper's stale Zenodo record title
    automatically, closing an open item from C918.

## Acceptance gates

- **Preflight first.** Run plan §0: confirm the checkout matches current source,
  above all Paper II's existing conclusion, and treat every line number in the
  plan as advisory, matching by content and label instead.
- **No statement-identity hash moves.** Each paper's
  `extract_statement_identity.py` hashes only theorem-like environments by label,
  so a presentation refactor must leave every hash fixed. A moved hash means a
  theorem was touched by accident.
- **Clean rebuild of all five.** `check_manuscript_build.py` fails on any LaTeX
  warning. Retune or drop the `\Needspace` glue that is tuned for the interludes'
  current position, and preserve Paper IV's `\vspace*{12mm}` page-1 spacing,
  which lives inside its banner group but is spacing rather than branding.
- **No stale references.** `Figure~\ref{fig:series-map}` is forward referenced
  from the introductions of Papers I and V today; those sentences move with the
  figure, so no forward reference should survive. Check that the coda's
  unnumbered heading produces no misleading PDF bookmark or contents entry.
- **Path scope.** C919 owns the five paper roots' manuscript sources and
  `papers/style-guide.md`, which gains a rule recording the front-matter
  convention adopted here. The `~/src/math-papers/` repositories are downstream:
  validate the monorepo authority first, then forward-commit each copy per
  `notes/export-and-mirror-conventions.md`.
- **Completion report**, per the packet: a per-paper summary of what moved and
  what was cut, the wording decision taken for the Paper I and Paper III map
  labels, any place where the source structure prevented the requested layout,
  and the list of the five rebuilt PDFs for review.

## Origin

Follows C918, which traced the poem's removal to commit `b19233879` under C904's
2026-08-11 series-framing pass.
