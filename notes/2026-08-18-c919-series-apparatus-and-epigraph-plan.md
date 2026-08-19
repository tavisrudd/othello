# C919 — De-brand the paper fronts and move the programme to a post-conclusion coda: plan

**Lane:** `clebsch` · **Date:** 2026-08-18 · **State:** plan agreed, execution not
started. No manuscript edited.

The author's implementation packet, preserved verbatim at
`2026-08-18-c919-author-implementation-packet.md`, is the governing
specification and supersedes this note's first revision. The earlier draft
recommended keeping the verse on Paper V's title page, proposed three candidate
rewrites of the verse, and named the new block "The series"; all three are
superseded. The superseded reasoning is recoverable from
`git log -p -- notes/2026-08-18-c919-series-apparatus-and-epigraph-plan.md`.

**Precedence.** The packet governs except where this plan records a later author
decision. Three such decisions exist: the poem text in §3 below (lines II, III,
and IV differ from the packet), the programme-map labels for Papers I and III in
§4, and the coda placement in Papers II and III in §2. Where they differ, this
plan wins; everywhere else the packet is controlling and this plan only
elaborates it.

## Decisions now fixed

1. Every paper is de-branded on page 1: no series banner, no Roman series number,
   no poem. This includes Paper V.
2. Every paper gains an unnumbered post-conclusion coda headed
   `\section*{Clebsch: Rigidity from Sparse Shadows}`, containing the poem, then
   the programme map, then the explanatory prose, then any other series material
   moved out of the old interlude.
3. The poem's wording is fixed by the block in §3 below and is not open for
   redrafting.
4. C919 edits all five papers in one pass; Paper III is not handed to C816.
5. Paper II gains the conclusion it currently lacks.
6. The sentence-level move/merge/cut test and its per-paper outcomes, agreed
   before the packet arrived, stand unchanged; the packet adopts them as
   requirements.

## 1. What is on the page today

### The banner

All five papers carry an identical page-1 banner built the same way: after
`\begin{document}`, inside a `\begingroup ... \endgroup`, `\@title` is redefined
to prepend `\large\textsc{Clebsch: Rigidity from Sparse Shadows --- }\textbf{N}`
above the real title, which is preserved as `\clebschmaintitle`.

| paper | file | banner lines |
|---|---|---|
| I   | `clebsch_rigidity.tex`                  | 41–44 |
| II  | `clebsch_factorization.tex`             | 37–39 |
| III | `clebsch_passages.tex`                  | 32–34 |
| IV  | `passant_code_q13.tex`                  | 39–42 |
| V   | `chordal_conference_reconstruction.tex` | 49–51 |

Two facts that make removal cheap and safe. The series name never appears in
`\title{...}` itself, only in the banner group, so deleting the group leaves each
paper's standalone title intact. And although all five load `hyperref`, none sets
`pdftitle` and `pdfinfo` reports no Title field on the built PDFs, so there is no
series remnant in PDF metadata to clean up. No `\markboth`, `fancyhdr`, or
running-head series label exists either.

One wrinkle: Paper IV's banner group also carries `\par\vspace*{12mm}\noindent`,
which is page-1 spacing rather than branding. Preserve or retune that spacing
when the banner goes, or Paper IV's title will sit higher than the other four.

### The poem

The five-clause verse survives only in Paper I. Commit `b19233879` (2026-08-11),
under C904's series-framing pass, removed it from Papers II–V; C918's card has the
full provenance.

### The map

`fig:series-map` exists only in Papers I and V. The two copies are independent
TikZ blocks differing in exactly two ways: the highlighted (`active`) node is the
owning paper, and the lower right node reads "marked conic plane and polarity" in
Paper I versus "marked conic plane and an `F_8`-orbit" in Paper V, whose caption
adds "Only their residual Frobenius-orbit profiles are compared." Papers II, III,
and IV gain the figure rather than move it.

Paper III's `fig:source-shadow-return` is its own route figure and stays in its
introduction.

### The interludes

Every paper has a `\noindent\textbf{Reconstruction perspective.}` paragraph
preceded by `\Needspace{27\baselineskip}` (18 in Paper V).

| paper | interlude line | conclusion | appendices |
|---|---|---|---|
| I   | 109 | §Conclusion, line 2007 | none |
| II  |  97 | **none — to be written** | yes, from line 2078 |
| III |  27 of `sections/01-introduction.tex` | `sections/09-conclusion.tex` | yes |
| IV  |  92 | §Conclusion, line 1051 | none |
| V   | 178 | §Conclusion, line 1555 | none |

## 2. Coda placement

The packet asks for the coda after the paper's mathematical conclusion and before
the bibliography, and its checklist reads Conclusion → coda → references. That
holds exactly for Papers I, IV, and V, which have no appendices.

Papers II and III have appendices, so the two readings diverge there. **Decided
by the author: place the coda immediately after the conclusion and before
`\appendix` in both.** Conclusion-to-coda adjacency is the stronger of the two
signals the checklist cares about, and it keeps the reader's exit from the
mathematics in the same place in all five papers. The rejected alternative —
coda after the appendices, immediately before the references — would bury the map
behind thirty-odd pages of appendix in Paper II.

With Paper II's new conclusion written, the resulting order is uniform:
last main section → Conclusion → coda → (appendices, where present) →
AI-assistance disclosure → references.

Formatting per the packet: unnumbered `\section*`, no ornamental border, no
oversized numerals, no color, no icons, no poem-to-box connector arrows, no second
legend. The linkage is carried by repetition of I–V, matching emphasis,
adjacency, and layout.

## 3. The poem

Final wording, used identically in all five papers, set as five real lines with
small light Roman numerals in a subordinate leading column:

```text
I    From deep holes, a form arises;
II   beneath it, paired chords turn true;
III  through many veils, the golden thread runs;
IV   from bare, whispered words, a plane rises;
V    beneath one form, two shadows, a hidden twist between.
```

Each paper emphasizes its whole line, and the matching map box, with one
restrained mechanism used consistently across all five. No bolding of isolated
phrases inside lines: the full-line-to-paper correspondence is now the device,
and the poem must still read naturally when the emphasis is ignored.

Note that this arrangement answers the objection raised against the old verse.
Two of the old clauses opened with a pronoun that had no antecedent, which was
fatal when a bolded fragment had to stand alone. The numeral column and the
whole-line emphasis make each line's owner explicit, so "beneath it" in line II
and "beneath one form" in line V now read correctly as continuations of a poem
rather than as fragments claiming to stand alone. Line V also fixes the
substantive error in the old closing clause: "the scattered shadows gather home"
implied a coalescence that Paper V explicitly rules out, whereas "two shadows, a
hidden twist between" carries the residual `C_2`-torsor.

**Three author amendments to the packet's poem text.** Lines II, III, and IV
below differ from the packet; only lines I and V are packet-original. The text
above is authoritative, and an implementer must not "correct" any line back to
the packet.

**Line II — settled.** "beneath it, paired chords turn true", replacing the
packet's "beneath it, paired chords find their bearing". To true something is to
bring it into exact alignment, which is a closer image for Paper II than a
bearing: what the first surviving odd tensor restores is the orientation of the
recovered sheets, a determinate choice rather than a direction of travel.

**Line III — settled.** "through many veils, the golden thread runs", replacing
the packet's "through changing guises, the golden source persists". The line is
built on one coherent image: a veil and a thread are both fabric, and a thread
runs through veils. It also matches Paper III's own relation, which is transport
— a chosen sign is carried *through* the conference, operator, and harmonic
realizations, and Paper III's cubic has four exact operator descriptions
(triangle holonomy, middle-exterior diagonal, commutator Pfaffian, oriented
cross-golden determinant). A veil is seen through rather than worn, which is the
right relation for a realization the source remains visible in. The substitution
of "thread" for "source" removes the programme's own term from the line; the
source-and-shadow spine survives in line V, where "one form" carries the source
role against "two shadows".

**Line IV — settled.** "from bare, whispered words, a plane rises", replacing the
packet's "from bare words".

**Shape.** With the three amendments the line lengths run roughly 8, 7, 9, 10,
13 syllables, so the poem builds to its longest line at Paper V rather than
peaking in the middle. Preserve this when setting the five lines; do not let the
typesetting wrap any line, which would destroy the shape. The small Roman
numerals required by the packet stay as a subordinate leading column.

The line keeps the noun "words", which is the one word in it that preserves the
coding-theory reading — a codeword is a word — and pairs "bare" with "whispered"
so the line carries both the sparseness and the faintness of what survives. Paper
IV's minimum words have weight twelve in a length-78 code, so the object named is
few nonzero positions rather than brevity; any wording built on shortness would
misstate the mathematics, since every codeword in the code has the same length.

**Consequent requirement.** Because "whispered" pulls "words" toward natural
language, Paper IV's coda prose must name its minimum words plainly, so the exact
term stands beside the poem in the paper's own voice. This is a requirement of the
chosen wording, not an optional nicety.

## 4. Programme map changes

- **Rename.** Caption language becomes "Programme map", not "Series map",
  because the map records relations among independent papers rather than a proof
  dependency chain.
- **Highlighting.** The current paper's box is the shaded box, as Papers I and V
  already do; the same style in all five.
- **Cluster separation.** Increase vertical whitespace between the Paper III and
  Paper IV nodes so I–III read as the upper cluster feeding Paper V and IV reads
  as the independent lower branch. Whitespace only — no enclosing boxes or
  cluster labels.
- **Paper V as hinge.** A slightly stronger border on the V node is acceptable if
  the TikZ makes it clean; do not over-style.
- **Distinguish I from III — decided.** Both currently read "conference
  companion", which makes them look duplicated. Use `deep-hole conference
  source` for Paper I and `golden-descent conference source` for Paper III.
  Every word is already in use: "conference source" is Paper III's own phrase
  from its introduction, "deep-hole" and "golden descent" are verbatim from the
  two papers' titles, and Paper I uses "conference matrix" and "conference
  identity" in its body. This also stops the map borrowing "companion", which
  Paper V gives a precise technical sense — the chordal companion of the
  conference cubic. Paper II's node keeps "chordal companion", where that sense
  is the correct one.
- **Targets.** Do not homogenize the Paper I and Paper V lower-right node texts
  if the mathematical targets genuinely differ; reconcile only if they do not.
- **Independence sentence.** Add, in the coda prose rather than the caption: the
  five papers are logically independent, and the map records reconstruction
  correspondences and thematic relations, not proof dependencies.

If the TikZ ends up copied five times, consider centralizing it with a
highlighting parameter, provided that does not destabilize the builds.

## 5. The interludes, sentence by sentence

The test: **does the sentence describe this paper's mathematics, or where this
paper sits?** Local mathematics, motivation, and roadmap merge into the ordinary
introduction; series placement and cross-paper comparison move to the coda;
sentences that merely restate the paragraph above them are cut. The
"Reconstruction perspective." label goes once its contents are redistributed.

### Paper I

Moves to the coda: "The later papers study other shadows of related sources; none
is used in the proofs here", the figure pointer, and the separate
end-of-introduction block at lines 279–284 — "Paper IV gives the structural and
reproducible account of that `q=13` consequence" together with "The remaining
cross-paper architecture is recorded in Figure 1; none of those companion
constructions is used in the present proof."

Merges into the introduction: "The motivating question is not specific to the
Clebsch configuration: when can a sparse invariant determine the object that
produced it?" — the series thesis, but also Paper I's own motivation, and Paper I
is where it reads as local. Also "The order-eleven Clebsch code is the rigid
exceptional answer, while the chord-defect identity and conic-filling bounds are
field-uniform", a scope statement the introduction currently lacks.

Cut as duplication: "Here the invariant is the maximum-distance syndrome locus
and the source is a projective MDS code" repeats the opening paragraph's "the
retained datum is the projective locus of maximum-distance syndromes of a
redundancy-three MDS code."

Stays put: the computational-companion sentences at lines 274–278. That companion
is Paper I's own and is not a numbered series paper.

### Paper II

Moves to the coda: "The classification and reconstruction are standalone; no
companion construction is used here."

Merges into the introduction: "The classification ranges over every odd prime
power", and "The Clebsch-related `H_3/F_11` case is one exceptional output, not an
input", which carries the paper's sharpest framing claim.

Cut as duplication: "It determines when the affine quotient configuration recovers
the missing pairing and when its first odd tensor orients the recovered sheets"
restates both the preceding paragraph and the following one.

**New conclusion.** Paper II is the only one of the five without a conclusion, and
the author has asked for one. It should close on the paper's own results: the
two-valued strength-two trade classification and its exactly two surviving orbits,
the sharpness of the restriction to perfect matchings, recovery of the two
complementary sheets without a self-association or Gorenstein premise, and the
first odd tensor restoring the orientation. Draft it from the abstract and the
existing §4 material rather than from any cross-paper text; no series content
belongs in it.

### Paper III

Moves to the coda: "Paper V later compares the conference shadow with a chordal
companion after an additional marking; it supplies no hypothesis here."

Merges into the introduction: the whole three-question roadmap — arithmetic,
marked, independent — plus "The Clebsch and icosahedral models are the meeting
point of the first two questions." This is a genuine roadmap of Paper III's own
structure and the strongest of the five interludes; it stays where it is with the
label removed and the prose integrated into the ordinary flow.

### Paper IV

Moves to the coda: "The theorem is logically independent of the other Clebsch
papers; its place in the programme is methodological", and "A different sparse
shadow — minimum-word pairs rather than syndrome or cubic data — again determines
a much richer source structure."

Merges into the introduction: "Starting from the minimum-support hypergraph, we
ask for the least arity of support data needed to reconstruct the geometry erased
by row reduction", and the exact-arity sentence, "At `q=13`, unary data are
constant while weighted pair data recover the marked conic plane and polarity, so
the exact arity is two." The exact-arity sentence is one of the strongest lines in
the opening and must land in the introduction, not the coda.

Rephrase on merge: "This is a standalone fixed-field inverse problem" is half
local scope and half independence disclaimer. Keep "fixed-field inverse problem"
in the introduction and let "standalone" go to the coda.

### Paper V

Its interlude is entirely series placement and moves to the coda whole.

## 6. Paper V: split the conclusion from the programme wrap

Paper V's current conclusion (lines 1555–1576) is almost all programme-level. It
opens "The scattered shadows gather on one carrier, but not by becoming equal",
walks through Papers I–III, and its second paragraph is the information-loss
principle spanning the upper branch and Paper IV. Split it:

**Stays in the conclusion**, as Paper V's own result: the marked correspondence,
the selected-line correspondence being an equivalence with the bare correspondence
exactly its `C_2`-quotient, the complete information-loss statement with its
scalar and outer sharpness, and the nonidentification of the two invariant cubic
lines.

**Moves to the coda**: the "scattered shadows" opening sentence, the walk through
Papers I–III, the broader information-loss principle, the `C_2` versus `C_3`
comparison with the Paper IV branch, and "Distinct shadows need not become
isomorphic in order to encode equivalent source data."

The "gather on one carrier, but not by becoming equal" sentence carries the right
corrective idea and should be preserved in the coda. It must not return to the
poem in any form: line V is deliberately worded to avoid implying coalescence.

## 7. Execution gates

- **Statement-identity hashes must not move.** Each paper's
  `extract_statement_identity.py` hashes only theorem-like environments
  (`theorem`, `proposition`, `lemma`, `corollary`) by label, so a presentation
  refactor must leave every hash fixed. Treat "no statement hash moved" as an
  acceptance gate; a moved hash means a theorem was touched by accident. Paper
  II's new conclusion must contain no theorem-like environment, or this gate will
  fire legitimately and need an explicit manifest update.
- **Build gates are strict.** `check_manuscript_build.py` fails on any LaTeX
  warning in each root, so all five need clean rebuilds. Drop or retune the
  `\Needspace` glue, which is tuned for the interludes' current position, and
  check the page breaks around Conclusion → coda → references.
- **Dangling references.** `Figure~\ref{fig:series-map}` is currently forward
  referenced from the introductions of Papers I and V. Those sentences move with
  the figure, so no forward reference should survive; verify none does, and check
  that the coda's unnumbered heading does not produce a misleading PDF bookmark or
  table-of-contents entry.
- **Release consequences.** Papers I, II, and III have public GitHub and DOI
  releases and Paper IV a manuscript-only pre-release, so none of this is visible
  publicly without forward releases. Paper V is already due one for the stale
  Zenodo record recorded in C918.
- **Public identity — no action needed.** All five `.zenodo.json` files in
  `~/src/math-papers/` already carry bare titles with no series label, so
  removing the banner introduces no divergence between the PDFs and the deposit
  metadata; the deposits were never branded. The `papers/summary/` table keeps
  its series labels, which is what the packet intends by holding programme
  identity at repository and README level. One consequence worth carrying to
  C918: because the deposit title is taken from `.zenodo.json` at release time,
  a forward Paper V release will correct the live Zenodo record's stale title
  automatically, with no manual metadata edit.
- **Style guide.** `papers/style-guide.md` has no rule about series front matter.
  Add one recording the convention adopted here so the next paper in the series
  does not reinvent it.

## 8. Reporting required on completion

Per the packet: a per-paper summary of what moved and what was cut; the wording
decision taken for the distinct Paper I and Paper III map labels; any place where
the source structure prevented the requested layout; and the list of the five
rebuilt PDFs for review.
