# C919 — Series apparatus relocation and epigraph rewrite: plan

**Lane:** `clebsch` · **Date:** 2026-08-18 · **State:** proposal only, no manuscript
edited.

Author instruction: restore the series epigraph to every paper; move the epigraph
and the series-map figure out of the front of Papers I–IV; collect every
cross-paper sentence from the "Reconstruction perspective" interludes into that
same block; merge each interlude's genuinely local content into its introduction;
and tighten the epigraph, especially the second and third clauses. Paper V keeps
its current arrangement.

## 1. What is on the page today

The epigraph is the five-clause verse below, one clause per paper, with each
paper bolding its own clause:

> From deep holes, a cubic **takes shape**; its companion **finds its bearings**,
> the carrier **stands fixed while their shadows move**; **from minimum words, the
> plane returns**, and **the scattered shadows gather home**.

It survives only in Paper I. Commit `b19233879` (2026-08-11), under C904's
series-framing pass, removed it from Papers II–V to stop the five papers reading
as installments; see C918's card for the full provenance.

The series-map figure `fig:series-map` exists only in Papers I and V. The two
copies are independent TikZ blocks that differ in exactly two ways: the
highlighted (`active`) node is the owning paper, and the lower right node reads
"marked conic plane and polarity" in Paper I versus "marked conic plane and an
`F_8`-orbit" in Paper V, whose caption adds "Only their residual Frobenius-orbit
profiles are compared." Papers II, III, and IV have no series map at all, so
three papers would gain a figure rather than move one.

Paper III has its own `fig:source-shadow-return` route figure in its
introduction. That is local content and stays where it is.

Every paper has a `\noindent\textbf{Reconstruction perspective.}` paragraph
preceded by `\Needspace{27\baselineskip}` (18 in Paper V), placed a page or two
in:

| paper | file | line | conclusion? | appendices? |
|---|---|---|---|---|
| I     | `clebsch_rigidity.tex`                   | 109 | yes (§Conclusion) | no  |
| II    | `clebsch_factorization.tex`              |  97 | **no**            | yes |
| III   | `sections/01-introduction.tex`           |  27 | yes (`09-conclusion`) | yes |
| IV    | `passant_code_q13.tex`                   |  92 | yes (§Conclusion) | no  |
| V     | `chordal_conference_reconstruction.tex`  | 178 | yes (§Conclusion) | no  |

## 2. Where the block should go: recommendation

**Take option (a), after the conclusion, refined to a single uniform rule: the
series block is the last item of the main body — immediately after the
conclusion where one exists, and immediately before `\appendix` where appendices
follow.** For Papers I and IV that is the last section before the bibliography;
for Paper III it sits between the conclusion and `\appendix`; for Paper II,
which has no conclusion, it follows the last main section.

The decisive fact is that almost nothing in the bodies needs the map early.
Counting citations to sibling numbered papers outside the perspective blocks:
Paper III has none, Paper IV has none, Paper II has exactly one and it is at line
2596, deep in an appendix, and Paper I has one (Paper IV, at line 279) inside its
own introduction. Paper I's other four sibling citations are to its computational
companion, which is not a numbered series paper and is not series apparatus. So
the usual argument for option (b) — that a reader meets cross-references before
the map explains them — has essentially no instances to protect. Option (b) would
move the interruption from page 2 to page 4 without removing it; option (a)
removes it.

The cost of (a) is that the verse stops being an epigraph in the literal sense
and becomes an envoi. That is the right trade here: Paper V, the capstone whose
clause is the closing one, keeps it as true front matter, and the other four
carry it as a closing coda. The asymmetry is deliberate and matches C904's
finding that entry-point branding belongs to one paper rather than all five.

Formatting: make it `\section*{The series}`, unnumbered, so it does not inflate
the numbered skeleton — the same treatment the AI-assistance disclosure already
gets. Order inside the block: the connective sentences, then the figure, then the
verse last, so the verse closes the paper.

Open question for the author: Paper II is the only one of the five with no
conclusion, which is why it is also the only one where the rule above lands the
block against a technical section rather than a summary. Giving Paper II a short
conclusion would fix that, but it is a separate improvement and is not bundled
into this plan.

## 3. What moves, what merges, what is cut

The test applied to each sentence: **does it say something about this paper's own
mathematics, or does it say where this paper sits relative to the others?** The
first stays in the introduction, the second moves to the series block.

### Paper I

Moves to the series block: "The later papers study other shadows of related
sources; none is used in the proofs here." and the figure pointer; plus the
separate end-of-introduction block at lines 279–284, "Paper IV gives the
structural and reproducible account of that `q=13` consequence" together with
"The remaining cross-paper architecture is recorded in Figure 1; none of those
companion constructions is used in the present proof."

Merges into the introduction: "The motivating question is not specific to the
Clebsch configuration: when can a sparse invariant determine the object that
produced it?" — this is the series thesis but it is also Paper I's own
motivation, and as the entry point Paper I should keep it. Also "The
order-eleven Clebsch code is the rigid exceptional answer, while the chord-defect
identity and conic-filling bounds are field-uniform", which is a scope statement
the introduction currently lacks.

Cut as duplication: "Here the invariant is the maximum-distance syndrome locus
and the source is a projective MDS code" repeats the opening paragraph's "the
retained datum is the projective locus of maximum-distance syndromes of a
redundancy-three MDS code."

Stays put: the computational-companion sentence at lines 274–278. That companion
is Paper I's own, not a numbered sibling.

### Paper II

Moves: "The classification and reconstruction are standalone; no companion
construction is used here."

Merges: "The classification ranges over every odd prime power" and "The
Clebsch-related `H_3/F_11` case is one exceptional output, not an input." The
second carries the paper's sharpest framing claim and should sit in the
introduction proper.

Cut as duplication: "It determines when the affine quotient configuration
recovers the missing pairing and when its first odd tensor orients the recovered
sheets" restates both the preceding paragraph and the following one.

### Paper III

Moves: "Paper V later compares the conference shadow with a chordal companion
after an additional marking; it supplies no hypothesis here."

Merges: the whole three-question roadmap — arithmetic, marked, independent — plus
"The Clebsch and icosahedral models are the meeting point of the first two
questions." This is a genuine roadmap of Paper III's own structure and is the
strongest of the five interludes; it should simply become part of the
introduction with the `\textbf{Reconstruction perspective.}` label removed.

### Paper IV

Moves: "The theorem is logically independent of the other Clebsch papers; its
place in the programme is methodological", and "A different sparse shadow —
minimum-word pairs rather than syndrome or cubic data — again determines a much
richer source structure."

Merges: "Starting from the minimum-support hypergraph, we ask for the least arity
of support data needed to reconstruct the geometry erased by row reduction", and
"At `q=13`, unary data are constant while weighted pair data recover the marked
conic plane and polarity, so the exact arity is two." The exact-arity sentence is
the sharpest statement in Paper IV's opening and is currently stranded in the
interlude.

Rephrase on merge: "This is a standalone fixed-field inverse problem" is half
local scope and half independence disclaimer; keep "fixed-field inverse problem"
in the introduction and let "standalone" go to the series block.

### Paper V

No change to placement. Its perspective paragraph is entirely connective and is
already the series section in all but name; the epigraph returns to its title
page.

## 4. Epigraph proposals

### What is wrong with the current verse

Two clauses open with a pronoun that has no antecedent: "**its** companion" and
"**their** shadows". Since each paper bolds its own clause and readers meet that
clause in isolation, a clause that cannot stand alone fails at its one job. That
alone condemns clause two.

Clause three, "the carrier stands fixed while their shadows move", states Paper
V's theorem, not Paper III's. One fixed carrier under two distinct shadows is
exactly the common-carrier result of Paper V; Paper III's content is that a
chosen sign is transported intact through conference, operator, and harmonic
realizations. The clause both misdescribes III and spends V's punchline early.

A third problem the author did not raise: clause five, "the scattered shadows
gather home", suggests the shadows merge, and Paper V explicitly proves they do
not — its own summary says the result "rules out a tempting literal
identification of the two invariant cubic lines while recovering the marked
equivalence that replaces it", leaving a residual `C_2`-torsor. The closing
clause should carry that residue.

Proposed drafting rule: **every clause names its own subject**, so any single
bolded clause is a complete statement about its paper.

### Proposal A — minimal repair

Keeps clauses one, four, and five; replaces only the two the author named.

> From deep holes, a cubic takes shape; the forgotten pairing comes back
> oriented; a chosen sheet keeps its sign through every shadow; from minimum
> words, the plane returns; and the scattered shadows gather home.

Accurate: Paper II's quadratic trade recovers the factorization and its first odd
covariant restores the orientation, so "comes back oriented" carries both results
in one beat. Paper III transports a chosen sign through every realization, and
"shadow" is the series' word for realization. Smallest possible change; leaves
the clause-five overclaim in place.

### Proposal B — uniform "from X" spine

Every clause names its sparse shadow first, echoing the series title
*Rigidity from Sparse Shadows*.

> From deep holes, a cubic takes shape; from a forgotten pairing, the sheets
> return oriented; from one marked sheet, a source that holds through every
> shadow; from minimum words, the plane and its polarity; and from two shadows,
> one carrier and a single residual sign.

Strongest parallelism, and each bolded clause is unmistakably its own paper. The
third and fifth clauses are verbless, which reads as deliberate compression
rather than error inside this structure. Fixes the clause-five overclaim.

### Proposal C — shortest, verb-led

> Deep holes shape a cubic; a quadratic trade orients the recovered sheets; a
> marked sheet fixes the source; minimum words rebuild the plane; two shadows
> meet on one carrier, up to a sign.

The tightest of the three and the closest to the style guide's "make every word
tell". Its cost is that "shadow" survives only in the last clause, so the verse
stops echoing the series title.

### Mix-and-match slots

Clause II: "the forgotten pairing comes back oriented" · "a quadratic trade
recovers the pairing and a cubic orients it" · "from a forgotten pairing, the
sheets return oriented".

Clause III: "a chosen sheet keeps its sign through every shadow" · "the chosen
sign survives every shadow" · "a marked sheet fixes the source".

Clause V: "and the scattered shadows gather home" (current, overclaims) · "and
two shadows name one carrier, up to a sign" · "and the scattered shadows meet on
one carrier".

Recommendation: Proposal B, or Proposal A with the clause-five replacement if the
author wants the existing wording of clauses one and four untouched.

## 5. Execution notes and gates

- **One shared figure.** Give all five papers textually identical TikZ apart from
  which node carries the `active` style and the one caption clause that differs.
  Papers II, III, and IV gain the figure. Reconcile the lower right node text
  between the Paper I and Paper V wordings before copying, and add a check that
  the five copies stay in step.
- **Statement-identity hashes should not move.** Each paper's
  `extract_statement_identity.py` hashes only theorem-like environments
  (`theorem`, `proposition`, `lemma`, `corollary`) by label, so a pure prose and
  figure relocation must leave every hash fixed. Treat "no statement hash moved"
  as an acceptance gate; if one moves, a theorem was touched by accident.
- **Build gates are strict.** `check_manuscript_build.py` fails on any LaTeX
  warning in each root, so every paper needs a clean rebuild after the move.
  Retune or drop the `\Needspace` glue, which is tuned for the current position.
- **Dangling references.** `Figure~\ref{fig:series-map}` is currently forward
  referenced from the introductions of Papers I and V. The sentences carrying
  those references move with the figure, so no forward reference should remain;
  verify none does.
- **Release consequences.** Papers I, II, and III have public GitHub and DOI
  releases, and Paper IV a manuscript-only pre-release, so none of this is
  publicly visible without forward releases. Paper V is already due one for the
  stale Zenodo record recorded in C918, so its epigraph restoration rides along
  free.
- **Lane sequencing.** Manuscript promotion for Paper III is currently
  authorized under C816 and C824 on the deterministic Paper III route. C919
  touching Paper III's introduction risks colliding with that route. The
  alternative is for C919 to do Papers I, II, IV, and V and hand Paper III's
  share to C816. Author's call; a single uniform pass is cheaper and less likely
  to leave the five papers out of step.
- **Style guide.** The guide has no rule about series front matter. Add one
  recording the convention chosen here, so the next paper in the series does not
  reinvent the placement.
