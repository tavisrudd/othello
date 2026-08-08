# C882 — does a split-free redundancy-five direction give a one-column MDS extension?

**Lane:** `reed-solomon`

**Status:** corrected in Version 2 on 2026-08-07 and committed.  Version 1 erratum
remains an open user decision.

The withdrawal landed on: the dictionary's coding-consequence paragraph, the overview
status-table column header, the introduction's advertisement and its caveat on the prior
correspondence, the \(q=8\) corollary (replaced by `rem:q8-no-extension`, which states
why no extension exists), the verification section's cross-paper paragraph, ledger row
`R5-Q` (now `RETRACTED`, with a new status-vocabulary entry), the Lean statement map, the
formalization ledger, the verification map, the literature audit's companion row, and the
coverage restriction in the Lean module `PRSBalancedQuantumExtension`.  Both builds, the
verifier, the 72-artifact evidence bundle, and the balanced-quantum and aggregate Lean
gates are green.

**Companion impact: none.**  Neither the AME/local-unitary paper nor the MDS--CSS
transversal-groups paper cites the beyond-four paper or instantiates the \([10,5,6]_8\)
row; their Reed--Solomon material stays within \(n\le q+1\).  The dependency ran one way,
from this paper into their general theorems, so their results are untouched.

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

## Primary-source reading, 2026-08-07

Step 1 below is done, and it supports the objection.  Kaipa's Section IV states Dur's
theorem verbatim, from the cached full text (`arXiv:1612.05447`):

> **Theorem (Dur 1994).** The covering radius of a \([q+1,k]_q\) RS code \(C\) is
> \(q-k\) if and only if (any) RNC in \(PG(q-k)\) is a complete arc.  Equivalently
> there is no MDS extension of \(C^\perp\) by one digit.

and his introduction says directly that when the covering radius equals \(n-k-1\) rather
than \(n-k\), "the equivalence between deep holes of \(C\) and MDS extensions of
\(C^\perp\) breaks down."

Our situation sits exactly there.  At redundancy five the code has length \(n=q+1\) and
dimension \(k=q-4\), so \(n-k=5\) and \(n-k-1=4\); Proposition `prop:r5-radius` proves
\(\rho=4\), which is \(q-k\).  Dur's theorem then says the relevant normal rational curve
is a complete arc and there is **no** one-digit MDS extension of \(C^\perp\).  The
\(q=8\) corollary claims \(1116\) one-column \([10,5,6]_8\) extensions, and \(C^\perp\)
there is a \([9,5,5]_8\) code whose one-digit extension would be exactly \([10,5,6]_8\).
On its face that is the object Dur's theorem forbids.

Before concluding, rule out the one way the manuscript could still be right: that its
"relative projective one-column extension" is not an extension of \(C^\perp\) in Dur's
sense — a different ambient code, a different arc, or an extension of \(C\) rather than of
its dual.  If it is the same object, the corollary is wrong and the error is in the
direction of the implication, not in the count.

## Verdict, 2026-08-07: the extension step is wrong

Dür was obtained (user-supplied copy, cache key `10.1016/0012-365X(94)90256-9`, SHA-256
`b28e0b84b00255aadf38d6f6b8d2204a76228f5acc0eacb73066cd40401ed9b1`, 7 pages) and read at
the load-bearing statements.  His Theorem 2.4 reads:

> \(\rho(d,q)=d-2\) if and only if the arc of every normal rational curve in
> \(PG(d-2,q)\) is complete.

with `complete` defined in his §1 as not contained in an arc with one more point, and his
Theorem 2.2 attaching \((q+2)\)-arcs to vectors at distance \(d-1\) — the larger of the
two possible radii, not ours.

**The counting mismatch, stated exactly.**  For redundancy \(r\) the syndrome space is
\(PG(r-1,q)\) and the distance of a syndrome from the code is the least number of
normal-rational-curve columns whose span contains it.  Adjoining a point \(P\) to the
\((q+1)\)-arc keeps it an arc exactly when no \(r-1\) arc points together with \(P\) lie
in a hyperplane, that is exactly when \(P\) has distance at least \(r\).  So an arc
extension, equivalently a one-column MDS extension of the dual, needs a syndrome at
distance \(r\).

At \(r=5\) our split-free criterion says \(f\) lies in the span of no three columns, so a
split-free syndrome has distance at least four; Proposition `prop:r5-radius` proves
\(\rho=4\), so its distance is exactly four.  **Four is one short of five.**  A deep hole
at the covering radius is not an arc-extending point, and Dür's Theorem 2.4 says so
directly: \(\rho=d-2=r-1\) is *equivalent* to the arc being complete, so no extending
point exists at all.

The manuscript's inference conflates "uncovered by three columns" with "uncovered by
four".  The two sentences that carry it are
`sections/03-dictionary.tex:110` and the first line of the proof of the \(q=8\)
corollary in `sections/04-redundancy-five.tex`.

**Consequence.**  There are no \(1116\) one-column \([10,5,6]_8\) MDS extensions; at
\(q=8\) a \([10,5,6]_8\) MDS code would be a \(10\)-arc in \(PG(4,8)\), and the
completeness that our own radius proposition establishes forbids it.  The count of
\(1116\) split-free directions is certificate-backed and stands; what fails is the passage
from those directions to extensions, and with it the \(\operatorname{AME}(10,8)\) state
and the \([[9,1,5]]_8\) quantum MDS code drawn from each extension.

The error is in the direction of an implication, not in any computation, and it is
independent of the twisted-cubic literature repairs.

**Surfaces carrying the claim**, to be handled together once the user decides scope: the
dictionary sentence; the \(q=8\) corollary and its proof; the abstract and introduction
wherever the quantum consequence is advertised; the claim--proof--novelty ledger row
`R5-Q`; the balanced-quantum Lean closure
`RelativeConicArcs.Gates.PRSBalancedQuantumExtension` and its axiom audit, whose structure
fields state the extension semantics; the AME/local-unitary companion paper that imports
the row; and published Version 1, which carries the same corollary.

## What must be checked, in order

1. ~~Read Kaipa 2017 Section IV and Proposition 4 at full text.~~  Done; quoted above.
   Cache key `arXiv:1612.05447`.
2. Read Dür 1994 for the equivalence in its own terms rather than through Kaipa's
   restatement.  **Access blocked**: Discrete Mathematics 126 (1994), no. 1--3, 99--105,
   DOI `10.1016/0012-365X(94)90256-9`, "On the covering radius of Reed--Solomon codes";
   OpenAlex reports it closed with no repository full text, and it predates arXiv.  Kaipa's
   verbatim restatement is strong secondary evidence, so this reading confirms rather than
   decides; it is still required before a correction is published.
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


## Which redundancies are impacted, and what recovery is available

**Impacted regime: all of them, because every radius gate in the paper lands on
\(\rho=r-1\).**  The overview table proves \(\rho=4,5,6,7,8,9\) at redundancies
\(5,\dots,10\).  Dur's Theorem 2.4 makes \(\rho=r-1\) *equivalent* to completeness of the
normal-rational-curve arc in \(PG(r-1,q)\), so at every level in the paper the arc is
complete and no one-column MDS extension of the dual exists.  The faulty inference is
therefore wrong wherever it is stated, not only at redundancy five.

**Impacted deliverables: redundancy five only.**  The inference is stated generally but
cashed in exactly once.  Surfaces:

- `sections/03-dictionary.tex:110` — the general "hence gives a one-column MDS extension"
  sentence.  Wrong at every redundancy.
- `sections/02-overview.tex:53` — the status-table column header "Deep holes/MDS
  extensions".  Misleading at every row; the rows themselves record radii and are correct.
- `sections/01-introduction.tex:128--131` — advertises the \(q=8\) quantum consequence.
- `sections/04-redundancy-five.tex` — the \(q=8\) corollary, its proof, the balance
  condition, and the sentence reading the orbit table as classifying extensions.
- Ledger row `R5-Q`; the balanced-quantum Lean closure and its axiom audit; the
  AME/local-unitary companion; published Version 1.

Everything else — the split-free classifications, the radius gates, the recursive carrier
theorem, the Lucas carriers, R6 through R10 — is untouched.  Those never use the extension
step.

**The corollary is not recoverable, and the reason is independent of us.**  A
minimum-support \(\operatorname{AME}(10,8)\) stabilizer state of this construction needs a
self-dual \([10,5,6]_8\) MDS code, equivalently a \(10\)-arc in \(PG(4,8)\).  The largest
arc in \(PG(4,8)\) has \(q+1=9\) points: the even-\(q\) exceptions to that bound are the
dimensions \(k=3\) and \(k=q-1=7\), and \(k=5\) is neither.  So the object named in the
corollary does not exist, and no re-reading of "relative projective one-column extension"
can produce it.  It also cannot be relocated: the extension correspondence needs
\(\rho=r\), which by Kaipa's Conjecture 2' happens only for \(q\) even with \(r=3\) or
\(r=q-1\); \(r=3\) is below the paper's range, and \(r=q-1\) gives no self-dual
parameters.

**What can be kept.**

1. The count.  \(1116\) is certificate-backed and is a statement about split-free
   directions and deep holes; it survives with the extension clause removed.
2. The orbit and balance structure, restated as statements about syndrome orbits rather
   than about extensions.
3. A correct sentence in place of the wrong one.  Our radius results, through Dur's
   equivalence, say the normal-rational-curve arc is complete at every redundancy in
   range, so there is *no* one-column MDS extension.  That is the true statement in the
   direction we were asserting the false one; it is not new, since it follows from the
   Seroussi--Roth input already cited, but it lets the dictionary keep a correct remark
   instead of a deletion.
4. The AME companion's general MDS-to-AME theorems are unaffected; only the \(q=8\)
   instantiation is void.  Confirm this rather than assume it.

**One live case worth recording.**  At \(q=8\) and redundancy seven, \(k=2\) and Kaipa's
exceptional row gives \(\rho=r=7\), so there the arc is incomplete and extensions do
exist.  That is exactly one of the fields the paper already flags as an open radius gap at
redundancy seven.  The extensions there are \([10,7,4]_8\), not self-dual, so they carry
no AME consequence, but it is the only place inside the paper's range where the deep-hole
to MDS-extension correspondence is alive.
