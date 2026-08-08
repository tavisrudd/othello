# C882 — does a split-free redundancy-five direction give a one-column MDS extension?

**Lane:** `reed-solomon`

**Status:** queued; allocated 2026-08-07.  **Potentially release-blocking for the
balanced \(q=8\) quantum corollary.**

**Origin:** Krishna Kaipa persona re-read of the Version 2 draft, 2026-08-07, item 5.
Raised while the reviewer was checking the twisted-cubic literature repairs; it is
independent of those repairs and was not introduced by them.

## The objection

Two manuscript sentences assert the extension consequence:

- `sections/03-dictionary.tex:110` — a split-free direction is an uncovered point of the
  normal rational curve "and hence gives a one-column MDS extension whenever the stated
  hypotheses hold";
- `sections/04-redundancy-five.tex` — "A projective deep-hole direction gives a
  one-column MDS extension", feeding the corollary that the \(1116\) deep directions of
  \(\PRS_{\F_8}(4)\) give \(1116\) one-column \([10,5,6]_8\) MDS extensions and hence the
  \(\operatorname{AME}(10,8)\) and \([[9,1,5]]_8\) consequences.

The reviewer's claim: for projective Reed--Solomon codes of length \(q+1\), once the
covering radius equals \(n-k-1=q-k\), the equivalence between deep holes and one-digit
MDS extensions breaks down.  Kaipa states this boundary explicitly, and Dür's
equivalence then reads: covering radius \(q-k\) is equivalent to the relevant normal
rational curve being **complete**, that is, to there being **no** one-digit MDS extension
of the dual.  Proposition `prop:r5-radius` proves exactly that radius situation
(\(\rho(\PRS(q-4))=4\) for \(q\geq7\)), so on the reviewer's reading the manuscript
derives the extension consequence from the very hypothesis that forbids it.

If that reading is right the corollary needs a fundamental correction, not rewording, and
the cross-paper AME/local-unitary consequences imported by the companion paper inherit it.

## What must be checked, in order

1. Read Kaipa 2017 (`arXiv:1612.05447`, DOI `10.1109/TIT.2017.2706677`) Section IV and
   Proposition 4 at full text and quote the exact boundary statement, including which
   code, which length, and which radius it applies to.  The manuscript already cites this
   passage for the radius gate, so the same passage is on both sides of the question.
2. Read Dür 1994 (`10.1016/0012-365X(94)90256-9`) for the completeness--covering-radius
   equivalence in its own terms rather than through the secondary statement.  The paper's
   own audit currently records Dür at abstract/metadata only, with the consumed form
   checked secondarily inside Kaipa; that is not enough to settle this.
3. Decide which of three outcomes holds: the extension sentences are correct as stated
   under a hypothesis the manuscript does satisfy; they are correct for a different
   extension notion than the one Kaipa rules out (for instance extension of the code
   rather than of its dual, or a column added to a different generator matrix); or they
   are wrong.
4. If wrong, determine what survives of the \(q=8\) corollary.  The exact count of
   \(1116\) split-free directions is certificate-backed and independent of the extension
   reading; what is at stake is the passage from those directions to MDS extensions and
   from there to the quantum consequences.
5. Propagate to `RuddAMELU2026`, which imports the row, and to the balanced-quantum Lean
   closure `RelativeConicArcs.Gates.PRSBalancedQuantumExtension`, whose structure fields
   state the extension semantics.

## Boundary

Do not weaken `prop:r5-radius`; it is the covering-radius input and is separately proved.
The question is only whether the deep-hole to MDS-extension step is licensed at this
radius.  Version 1 is published and carries the same corollary, so a negative outcome
raises an erratum question that belongs to the user.
