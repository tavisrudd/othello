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

## Checklist, closed

1. **Kaipa 2017, Section IV and Proposition 4, at full text.**  Done; his statement of
   Dur's theorem is quoted above.  Cache key `arXiv:1612.05447`.
2. **Dur 1994 in its own terms.**  Done.  The user supplied the paper on 2026-08-07; cache
   key `10.1016/0012-365X(94)90256-9`, SHA-256
   `b28e0b84b00255aadf38d6f6b8d2204a76228f5acc0eacb73066cd40401ed9b1`, 7 pages.  His
   abstract and Theorem 2.4 give the equivalence directly, and his Theorem 2.2 attaches
   \((q+2)\)-arcs to vectors at distance \(d-1\), the radius that does not occur here.
   The access block recorded earlier is cleared.
3. **Which outcome holds.**  The third: the extension sentences are wrong, by one column.
   The diagnosis is above.
4. **What survives.**  The \(1116\) count, as a deep-hole count; the orbit and balance
   structure as statements about syndrome orbits; and, in place of the false claim, the
   true statement that no one-column MDS extension exists at any redundancy classified
   here.  The corollary is not recoverable: a \([10,5,6]_8\) MDS code would be a
   \(10\)-arc in \(PG(4,8)\), where the maximum is nine, and the extension correspondence
   needs \(\rho=r\), which does not hold at any redundancy in the paper's range.
5. **Propagation.**  Done.  The Lean closure carries an explicit coverage restriction
   naming Dur and Kaipa; neither `RuddAMELU2026` nor the MDS--CSS transversal-groups paper
   cites the beyond-four paper or instantiates the row, so no companion edit was needed or
   made.

## Remaining

**Decisions taken 2026-08-07.**  The correction is published as a GitHub release rather
than a prose erratum, and **Version 2 supersedes Version 1** — there is no separate
corrected Version 1 artifact.  Version 1 has a DOI but was never distributed further, so
there is no citing readership to notify.

What follows from that:

- **Nothing to export yet.**  The correction already lives in the Version 2 draft, so this
  task produces no artifact of its own.  The publication step rides with the Version 2
  release and inherits its readiness gates; it is not independently actionable.
- **The retraction must not be buried in the revision.**  Version 2 differs from Version 1
  in spine, length, and level coverage, so a reader diffing the two sees a new paper rather
  than a withdrawal.  The release note below therefore leads with the withdrawal and states
  it as a correction of record, before describing anything new.
- **Version 1 stays intact.**  Tag `v0.1.0`, commit
  `0d3cea228b852c45f048c3446604ee2146219144`, Zenodo version DOI
  `10.5281/zenodo.21682216` under concept DOI `10.5281/zenodo.21682069`.  The Version 2
  release is a forward commit and a new tag under the same concept DOI; it never replaces
  `v0.1.0` or its Zenodo record.
- Synchronization runs one way out of this repository, and
  `notes/export-and-mirror-conventions.md` must be read in full before anything writes to
  the paper repository, through the guarded export entry point only.

## Draft release note for the superseding Version 2

> **This version supersedes v0.1.0 and corrects a defect in it.  Please read the correction
> before the new material.**
>
> **Correction of record.**  Version 1 inferred a one-column MDS extension from a split-free
> syndrome direction.  That step is wrong.  Extending the dual code by one column requires a
> syndrome outside the span of every `r-1` parity-check columns, whereas split-freeness
> places it outside the span of only `r-2`.  The two conditions differ by one column, and at
> the covering radius the paper itself proves, the stronger one is unattainable: by Dur's
> theorem (Discrete Mathematics 126 (1994), 99--105, Theorem 2.4) covering radius `r-1` is
> *equivalent* to completeness of the normal rational curve's arc in `PG(r-1,q)`, so no
> extending point exists.  Independently, the `[10,5,6]_8` code named in Version 1 would be a
> ten-point arc in `PG(4,8)`, where the maximum is nine.
>
> **Withdrawn:** the 1116 one-column `[10,5,6]_8` MDS extensions, the minimum-support
> `AME(10,8)` stabilizer states, and the associated `[[9,1,5]]_8` quantum MDS codes.  The
> error was in the direction of one implication, not in any computation.
>
> **Unaffected by the correction:** the count of 1116 split-free directions at `q=8`, which
> is certificate-backed and stands as a deep-hole count; the redundancy-five, six and seven
> classifications; the covering-radius results; and the geometric content.  The companion
> papers never depended on the withdrawn corollary.
>
> **New in this version.**  [Version 2 summary goes here at release time: the recursive
> carrier theorem, the exact redundancy-five split-witness count and its Chebotarev
> splitting law, the fixed-level classifications through redundancy ten, and the
> twisted-cubic line-orbit attributions.]
