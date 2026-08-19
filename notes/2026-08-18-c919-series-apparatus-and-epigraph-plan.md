# C919 — De-brand the paper fronts and move the programme to a post-conclusion coda: plan

**Lane:** `clebsch` · **Original date:** 2026-08-18 · **Revised:** 2026-08-19 · **State:** plan agreed, execution not
started. No manuscript edited.

The author's implementation packet, preserved verbatim at
`2026-08-18-c919-author-implementation-packet.md`, is the governing
specification and supersedes this note's first revision. The earlier draft
recommended keeping the verse on Paper V's title page, proposed three candidate
rewrites of the verse, and named the new block "The series"; all three are
superseded. The superseded reasoning is recoverable from
`git log -p -- notes/2026-08-18-c919-series-apparatus-and-epigraph-plan.md`.

**Precedence.** The packet governs except where this plan records a later author
decision or a source-state correction. The authoritative differences are: the
poem text in §3; the programme-map labels, target, and caption in §4; the coda
placement in Papers II and III in §2; and the Paper-II source reconciliation in
§0 and §5. Where they differ, this plan wins; everywhere else the packet is
controlling and this plan only elaborates it.

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
5. Paper II's existing conclusion is preserved. Do not draft, replace, or add a
   second conclusion under C919.
6. The sentence-level move/merge/cut test and its per-paper outcomes, agreed
   before the packet arrived, stand unchanged; the packet adopts them as
   requirements.
7. Wherever this plan supplies exact replacement/coda prose, use it as the
   default text. Do not ask a downstream drafting agent to synthesize prose that
   has already been settled here.

## 0. Preflight: reconcile the checkout with current source

This plan was first prepared against a stale Paper-II source state. A public
source check on 2026-08-19 found that current `main` already contains a substantial
`\section*{Conclusion}` immediately before `\appendix` in
`clebsch_factorization.tex`. It closes on the two surviving balanced matching
orbits, the sharp perfect-matching boundary, recovery of the unordered sheets,
the cubic orientation, and the Macaulay inverse system.

Before editing, confirm that the implementation checkout contains that conclusion.
If it does not, synchronize/reconcile the checkout with the current source rather
than inventing a new conclusion as part of C919. C919 is a presentation and
series-apparatus refactor, not the vehicle for independently recreating missing
mathematical prose.

Line numbers in this note are therefore advisory. Match passages by content and
labels when the current checkout has moved.

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
| II  |  97 | `\section*{Conclusion}`, immediately before `\appendix` | yes |
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

With Paper II's existing conclusion preserved, the resulting order is uniform:
last main section → Conclusion → coda → (appendices, where present) →
AI-assistance disclosure → references.

Formatting per the packet: unnumbered `\section*`, no ornamental border, no
oversized numerals, no color, no icons, no poem-to-box connector arrows, no second
legend. The linkage is carried by repetition of I–V, matching emphasis,
adjacency, and layout.

Within every coda, use this exact order:

1. `\section*{Clebsch: Rigidity from Sparse Shadows}`
2. five-line poem with the owning line emphasized;
3. programme map with the owning box emphasized;
4. the standard logical-independence sentence from §4;
5. the paper-specific coda prose fixed in §5/§6.

Do not insert explanatory prose between the poem and the map.

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
  already do; use the same style in all five.
- **Cluster separation.** Increase vertical whitespace between the Paper III and
  Paper IV nodes so I--III read as the upper cubic-shadow cluster feeding Paper V
  and IV reads as the independent lower branch. Whitespace only -- no enclosing
  boxes or cluster labels.
- **Paper V as hinge.** A slightly stronger border on the V node is acceptable if
  the TikZ makes it clean; do not over-style.
- **Upper-node labels -- decided.** Replace the mixed/duplicated
  "conference companion" / "chordal companion" vocabulary with parallel labels
  naming the cubic shadows:
  - Paper I: `deep-hole conference cubic`
  - Paper II: `matching-quotient chordal cubic`
  - Paper III: `golden-descent conference cubic`
  - Paper V: `marked cubic correspondence`

  This is preferable to calling I and III "conference sources": in the logic of
  Paper V, the cubic objects are the visible shadows and the six-axis object is
  the common carrier/source recovered from them. The new labels also reserve
  "companion" for places where Paper V uses it technically.
- **Lower target -- decided.** Use one common two-line Paper-IV target in all five
  maps:
  ```text
  marked conic plane and polarity
  with an F_8-marking
  ```
  Typeset `F_8` mathematically. This keeps both levels that the current two map
  copies split: pair data recover the marked conic plane and polarity, while the
  recovered binary relation algebra carries the residual `F_8` marking.
- **Caption -- use this wording in all five papers:**

  > **Programme map.** The upper double arrows are Paper V's marked transports
  > and returns between the chordal and conference shadows; the right arrow is
  > its common-carrier reconstruction. The lower solid arrow is Paper IV's
  > independent minimum-word reconstruction. Only the residual \(C_2\)- and
  > Frobenius-orbit markings are compared across the two branches.

  Adapt only TeX syntax (`Paper~V`, `\F_8`, etc.), not the prose.
- **Independence sentence -- use this wording immediately after the figure:**

  > The five papers are logically independent; the map records reconstruction
  > correspondences and thematic relations, not proof dependencies.

If the TikZ ends up copied five times, centralize it with a current-paper
highlighting parameter if that can be done without destabilizing the builds.
The poem and map should remain adjacent; put the independence sentence and
paper-specific coda prose after the map.

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


**Coda prose -- use this as the paper-specific paragraph after the standard
independence sentence:**

> The sparse datum here is the maximum-distance syndrome locus. It recovers the
> Clebsch code together with its conic, polarity, and golden orientation; the
> later papers study other shadows of related sources, but none is used in the
> proofs here. The order-eleven Clebsch code is the rigid exceptional answer,
> while the chord-defect identity and conic-filling bounds are field-uniform.

### Paper II

Moves to the coda: "The classification and reconstruction are standalone; no
companion construction is used here."

Merges into the introduction: "The classification ranges over every odd prime
power", and "The Clebsch-related `H_3/F_11` case is one exceptional output, not an
input", which carries the paper's sharpest framing claim.

Cut as duplication: "It determines when the affine quotient configuration
recovers the missing pairing and when its first odd tensor orients the recovered
sheets" restates both the preceding paragraph and the following one.

**Conclusion -- preserve, do not draft.** Current `main` already has a
`\section*{Conclusion}` immediately before `\appendix`. It is Paper-II-local and
already closes on exactly the right material: the two surviving balanced matching
orbits \(B_3/\F_7\) and \(H_3/\F_{11}\), the sharp matching-carrier boundary, the
two-valued quadratic trade and recovery of the unordered sheets, the first signed
tensor moment being cubic and restoring orientation, and the Macaulay inverse
system/Gorenstein interpretation. Do not redraft, shorten, or replace it under
C919. Insert the programme coda immediately after it.

**Coda prose -- use this as the paper-specific paragraph after the standard
independence sentence:**

> The classification here ranges over every odd prime power. The Clebsch-related
> \(H_3/\F_{11}\) case is an exceptional output, not an input, and no companion
> construction is used in the proof. On the two surviving matching orbits,
> quadratic data recover the unordered sheets and the first surviving signed
> cubic restores their orientation.

### Paper III

Moves to the coda: "Paper V later compares the conference shadow with a chordal
companion after an additional marking; it supplies no hypothesis here."

Merges into the introduction: the whole three-question roadmap — arithmetic,
marked, independent — plus "The Clebsch and icosahedral models are the meeting
point of the first two questions." This is a genuine roadmap of Paper III's own
structure and the strongest of the five interludes; it stays where it is with the
label removed and the prose integrated into the ordinary flow.


**Coda prose -- use this as the paper-specific paragraph after the standard
independence sentence:**

> This paper follows a marked conference source through its arithmetic, operator,
> and harmonic realizations. Paper V later compares the resulting conference
> shadow with a chordal shadow after an additional marking; that comparison
> supplies no hypothesis here.

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


**Coda prose -- use these two paragraphs after the standard independence
sentence.** The first paragraph is required by the word "words" in poem line IV,
so that a coding theorist sees the literal referent beside the poetic line:

> Here the sparse shadow is literal: the \(364\) minimum words of the binary
> conic code are the starting data. Unary support data are constant, while
> weighted pair concurrences recover the marked conic plane and its polarity, so
> the exact reconstruction arity is two.
>
> The theorem is logically independent of the other Clebsch papers; its place in
> the programme is methodological.

### Paper V

Its interlude is entirely series placement and moves to the coda whole.

Use the exact standalone conclusion and programme-wrap prose in §6 below; do not ask the implementer to synthesize either from bullet points.

## 6. Paper V: split the conclusion from the programme wrap

Paper V's current conclusion is mostly programme-level: it opens "The scattered
shadows gather on one carrier, but not by becoming equal", walks through
Papers I--III, and then states the information-loss principle spanning the upper
branch and Paper IV. Split those functions cleanly.

### 6.1 Standalone Paper-V conclusion

Replace the current conclusion prose with the following two paragraphs, preserving
the existing `\section{Conclusion}` heading and label:

> The chordal and conference cubics are geometrically distinct, but after a
> chordal line is selected they recover the same marked six-axis carrier. The
> singular quartic of the chordal cubic recovers the constant double cover
> \(A_5/C_5\to A_5/D_{10}\), and the normalized outer difference gives mutually
> inverse reconstruction between a normalized chordal generator and an oriented
> conference generator. Forgetting the selected chordal line is exactly the free
> \(C_2\)-quotient. Thus the result identifies the source information retained by
> the two cubic shadows without identifying the two invariant cubic lines
> themselves.
>
> The recovered six-set also controls the integral normalization. The rank-five
> augmentation and rank-six root--weight lattices remain distinct, while their
> common binary heart carries the \(\F_4\)-structure on which conference reversal
> is Frobenius. Together these results determine both the common marked carrier
> and the precise residual ambiguity left by the reconstruction.

This is the mathematical conclusion of Paper V. It may mention the chordal and
conference objects, but it should not walk the reader through Papers I--IV as a
series.

### 6.2 Programme coda prose for Paper V

After the poem, programme map, and standard independence sentence, use:

> The scattered shadows gather on one carrier, but not by becoming equal.
> Papers I and III reach the conference shadow from deep-hole and golden-descent
> data; Paper II reaches the chordal shadow from matching-quotient data. Paper V
> shows that these distinct cubic shadows recover the same marked six-axis
> carrier, with a residual \(C_2\)-torsor when the selected chordal line is
> forgotten.
>
> Paper IV forms an independent branch. There the sparse data are minimum-word
> pairs rather than cubic data, and weighted pair concurrences recover a marked
> conic plane and polarity. Its residual marking is governed instead by
> Frobenius on the \(\F_8\)-commutant. The two branches therefore illustrate the
> same information-loss principle without sharing a geometric carrier:
> reconstruction can recover the source while leaving a small, rigid residual
> marking.
>
> Distinct shadows need not become isomorphic in order to encode equivalent
> source data; what matters is whether the ambiguity left after reconstruction
> can itself be isolated and rigidified.

The first sentence is intentionally retained from the existing conclusion because
"but not by becoming equal" states the corrective point cleanly. It must not
return to the poem: line V's "two shadows, a hidden twist between" is the settled
poetic formulation.

## 7. Execution gates

- **Statement-identity hashes must not move.** Each paper's
  `extract_statement_identity.py` hashes only theorem-like environments
  (`theorem`, `proposition`, `lemma`, `corollary`) by label, so a presentation
  refactor must leave every hash fixed. Treat "no statement hash moved" as an
  acceptance gate; a moved hash means a theorem was touched by accident. No new
  theorem-like environment is required anywhere in C919.
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
  Add the following convention (adjust Markdown punctuation only if the style
  guide has a fixed house format):

  > **Programme papers.** Papers belonging to a thematic programme must retain
  > standalone title-page identity: do not place programme banners, ordinal
  > paper numbers, programme epigraphs, or programme maps in the front matter.
  > Local mathematical motivation and roadmaps belong in the introduction;
  > cross-paper placement belongs in an unnumbered coda after the mathematical
  > conclusion. Programme numbering may appear in that coda, its programme map,
  > and repository-level metadata.

## 8. Reporting required on completion

Per the packet: a per-paper summary of what moved and what was cut; confirmation
that the settled upper-node map labels and common lower target were used; any
place where the source structure prevented the requested layout; and the list of
the five rebuilt PDFs for review. Also report the Paper-II preflight result:
whether the checkout already contained the current conclusion or had to be
reconciled before C919 edits began.
