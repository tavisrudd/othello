# C816 gate 2 — Milnor--Serre pass over the operator section

**Task:** C816 (`clebsch` lane). Whole-section exposition pass over
`papers/clebsch-passages/sections/05-golden-operator.tex`.
**Date:** 2026-08-20.
**Constraints honoured:** only that one file edited; prose only; every
math-mode fragment byte-identical (verified, below); no theorem, proposition,
or remark body touched; no citation, label, or display added or removed; no
commit, no PDF refresh, no verification-file change.

## Verdict

The section already reads as one piece. Its architecture is sound — setup,
four shadows, operator theorem, recognition, boundary, priority, rigidity,
module form, nondegeneracy, then the two standalone subsections — and the
C816 blocks sit in it without seams: the boundary and priority paragraphs
have distinct jobs (what is open versus what is classical and what we prove),
the two dimension arguments serve different loci and are tied together by the
retained injectivity sentence, and the grown induction reads as a single
argument. The pass therefore made seven small repairs rather than a
restructuring: two stale or inconsistent direction words, one meta sentence,
one banned "it is worth recording" construction, one overloaded sentence, one
ambiguous pronoun, and one missing paragraph break. Every math fragment is
untouched, the lint and the build pass warning-free, and the paper is still
thirty-nine pages.

## Changes applied

All in `sections/05-golden-operator.tex`; grouped by kind.

**Stale or inconsistent cross-reference words (2).**

1. In the principal-minors recapitulation, "through
   \(\det C[Q]=3-2w(Q)\) *below*" now says *above*: the identity's two
   appearances (the aggregate-statistics paragraph and the faithfulness
   proof) both precede this paragraph, and nothing after it states the
   identity again.
2. The section's closing paragraph said "The cubic stage *above* retains the
   determinant-line orientation" and then "the *later* cubic shadows" two
   lines apart, about the same material. Dropped "later"; the three
   distinguished claims are unchanged.

**Meta or banned prose (2).**

3. Deleted "This exposes the complementary-minor step rather than treating it
   as formal." from the operator theorem's proof — commentary about the
   exposition, not mathematics; the two displayed complementary blocks make
   the point themselves.
4. The recapitulation opener "…is a statement about principal minors, and it
   is worth recording which ones it uses" lost its second clause (house ban
   on "it is worth noting/recording"); the next sentence records them anyway.
   Now: "…is a statement about principal minors. Those of order at most
   three trivialize the problem:".

**Sentence and paragraph discipline (3).**

5. Split the overloaded Higman--Taylor--Seidel sentence before the
   faithfulness theorem: "Equation \eqref{eq:two-graph-parity} is the
   definition of a two-graph." now stands alone, and the
   correspondence-plus-attribution material is a second sentence. One claim
   per sentence; no word of the history or the citation changed.
6. New paragraph break before "This proof is also the promised decoder." in
   the faithfulness proof — the extension to larger vertex sets and the
   decoder are different jobs and now have one paragraph each.
7. In the operator theorem's proof, "Its off-diagonal entries are the
   pair-balance identities" became "The off-diagonal entries of that equation
   are…" — the pronoun could bind to "the tight-frame argument" instead of
   the equation \(C_T^2=5I\).

## What I checked and deliberately left alone

- **The C816 hot spots.** The boundary paragraph and the new priority
  paragraph do not repeat each other: one states what the theorem leaves
  open, the other places its two halves in the literature. The rigidity
  proof's Jacobian rank and the module paragraphs' tangent dimension are
  different quantities, and the connective sentence ("the conference
  deformations the cubic equality kills are exactly the scalings") is doing
  its job. The grown exchange-spectra induction reads as one argument with
  the descent, the bottom, and the climb each in one sentence group.
- **Forward and backward references.** Every cross-reference the section
  makes was checked against its target: `sec:orientation-source` (tight-frame
  argument and displayed representative), `sec:harmonic` and
  `thm:harmonic-main` (label exists in `05-harmonic-realization.tex`),
  `sec:verification`, `tab:outer-coefficient-words`,
  `eq:two-graph-parity`, both remark labels, and the in-file theorem
  labels. All describe what their targets now say.
- **Orientation prose kept.** The bridge paragraph before the exchange
  subsection partially repeats the section opening's independence statement,
  six hundred lines later; at that distance the reminder is doing navigation
  work, and its second sentence (switching recovery versus reconstruction) is
  unique, so it stays. The "No physical or exceptional-group interpretation"
  boundary sentence is a deliberate one-time scope statement and stays.
- **Licensed negatives untouched.** The two "We have not located" paragraphs
  in the reconstruction subsection and Edit E's priority negative each carry
  their own audit-scope pointer; the repetition is the price of three
  separately licensed boundaries and was not compressed.

## Recommendations not applied (pinned statements or frozen mathematics)

1. `rem:alignment-query-count`, near its end: "So the price of the coherence
   restriction is **a** price of fixing the tests in advance" — the article
   is wrong; recommend "is **the** price of fixing the tests in advance".
   Remark bodies are pinned.
2. Same remark, a few sentences earlier: "for a new **old** vertex \(u\)"
   is self-contradictory as phrased; recommend "for a further
   already-recovered vertex \(u\)" or similar. Pinned.
3. The description of the solutions of \(A^2=\lambda I\) (involution,
   constant-diagonal rank-three projection, equal-norm tight frame) appears
   twice: in the priority paragraph and again, with the parametrization that
   the dimension count needs, in the module-form paragraph. If a future pass
   wants one occurrence, the priority paragraph's version is the one to
   shorten — but both sentences are dense with inline math, so under the
   frozen-math rule this pass left them as they are.

## Verification

- **Math-fragment multiset**: extracted every `\(...\)`, `\[...\]`,
  `equation`, `align`, `aligned`, and `array` fragment from the pre-image
  (`git show` of the section at HEAD) and from the working copy
  (`scratchpad/mathdiff.py`): **IDENTICAL multisets, 601 fragments, 419
  distinct**. No math-mode byte changed.
- **Lint**: `python3 verification/lint_tex_spacing.py clebsch_passages.tex
  sections` — `CHECK OK` (12 files).
- **Build**: `nix develop …#manuscript --command latexmk -xelatex
  -interaction=nonstopmode -halt-on-error clebsch_passages.tex` via
  `run-quiet` — exit 0, and the log contains no LaTeX warning, no undefined
  reference, and no overfull or underfull box.
- **Page count**: `Output written on clebsch_passages.xdv (39 pages)` —
  unchanged at thirty-nine.
- **Worktree**: the build regenerated `clebsch_passages.pdf` in place; since
  the PDF refresh is the coordinator's, its HEAD bytes were restored with
  `git show HEAD:… >`, and `git status` for the paper directory now shows
  exactly one modified file, `sections/05-golden-operator.tex`.
