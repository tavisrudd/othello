# C900 sealed design/generalist final rereview

Date: 2026-08-09

Manuscript reviewed: `papers/arcs_complete_outside_conic/arcs_complete_outside_conic.tex`

## Verdict

**MINOR**

The theorem hierarchy, scopes, matching-design conventions, counts, leave
argument, realization parameters, and the external two-class input are coherent.
I found no actionable proof or convention defect in the requested scope.  One
pinpoint citation used for the classical moments should be corrected before a
GO verdict.

## Actionable finding

1. **Ball page range does not support the two displayed moment equations.**
   In the introduction and immediately after Proposition `prop:moments`, the
   manuscript cites Ball, pp. 29--30, for the classical first and second
   secant-index moments.  Ball p. 29 introduces the point-index counts (c_i),
   but the three explicit equations, including the first and second point-index
   sums corresponding to the displayed proposition, occur on p. 34 of the
   published article (equations (1)--(3)).  Change both occurrences of
   `\cite[pp.~29--30]{Ball1997}` to a pinpoint that includes p. 34, preferably
   `\cite[p.~34]{Ball1997}` for the equations (or cite pp. 29 and 34 if the
   definitional convention is also intended).  Hirschfeld Chapter 9 and the
   manuscript's self-contained proof keep this non-load-bearing, hence MINOR.

## Checks passed

- The abstract and introduction expose the correct hierarchy: the arbitrary
  prescribed-hole identity is primary; equality/stability and the conic
  specialization follow from it; the finite exact values have their distinct
  trust boundaries stated.  The novelty sentence correctly says that the
  identity is a factored local remainder extracted from the two classical
  moments, not a third incidence equation.
- All relevant (k)-scopes are consistent: the defect identity starts at
  (k\ge3); matching rigidity and graph stability start at (k\ge4); the
  parity equality spectra start at even (k\ge6) and odd (k\ge7).  The
  (m=2) graph-stability case is vacuous but valid.
- The moment identities and prescribed-hole split are correct.  The equality
  cases are exactly (r\in\{1,m\}) off the hole and
  (r\in\{0,m\}) on it.  The quantitative point bounds, edge bound, and
  deletion/vertex-cover bound follow with the stated constants.
- `MATCH(k,m,1)` uses Alspach--Heinrich's convention: blocks are (m)-edge
  matchings of (K_k), and every pair of independent edges occurs once.
  Simplicity follows automatically at \(\lambda=1\).  At equality the counts
  are correct:
  \[
    |Z|=3\binom{k}{4}/\binom m2
      =(k-1)(k-3)\quad(k\text{ even}),\qquad
      k(k-2)\quad(k\text{ odd}),
  \]
  and each secant contains respectively (k-3) or (k-2) maximum-index
  concurrence points.
- The nonexistence-gap leave argument is correct.  Leave degrees are divisible
  by (m-1); a one-block leave has \(\binom m2\) edges and therefore is a
  (K_m) on (m) pairwise-disjoint secants, so it can be completed by one
  maximum matching.
- The dual star--matching realization has the stated incidence structure.
  For the ten-point design, (E(K_{10})) gives 45 points, the 63 perfect
  matchings are lines of size 5, every point is on 7 lines, and an anti-flag
  has exactly 3 connecting lines.  Thus `pg(5,7,3)` is correct in Reichard--
  Woldar's (line size, point degree, alpha) convention and `pg(4,6,3)` is
  correct in the standard \((s,t,\alpha)\) convention.
- The regular-hyperoval design is defined unambiguously as the isomorphism
  class of the 63 concurrence matchings of the regular hyperoval in
  \(\mathrm{PG}(2,8)\).  Alspach--Heinrich Theorem 1.2 supplies the hyperoval
  construction, and their opening classification paragraph explicitly reports
  Mathon's result that precisely two nonisomorphic `MATCH(10,5,1)` designs
  exist.
- External two-class completeness is not passed off as paper-local: the text
  explicitly names it as an external input, cites Mathon's primary 1981 paper,
  and uses Reichard--Woldar only to report/reconstruct the two models and their
  automorphism distinction.  This is an adequate primary-source attribution.
- Alspach--Heinrich Theorem 3.1 supports nonexistence of
  `MATCH(7,3,1)`.  Their definition permits repetitions, as the manuscript
  says.  The six-point normalization and characteristic-two/F4 conclusion are
  internally complete.  The ten-point classification cleanly separates the
  external abstract two-class census from the manuscript's realization
  certificates.
- Ball Theorem 3.1 does support the claimed classical leading
  \(\sqrt{2q}\) scale for ordinary complete arcs.  Alabdullah--Hirschfeld is
  applicable as a recent explicit lower-bound comparison for complete
  \((k,n)\)-arcs, including ordinary arcs at (n=2).
- The additive lower-bound derivation is valid on its stated full range.  The
  first-moment reduction gives (k\ge\sqrt{2q}); the (k\ge s+2) branch is
  immediate; and the polynomial estimate yields the displayed
  (3/2-8/\sqrt{2q}) correction without an unstated parity assumption.
- The conclusion accurately preserves the result hierarchy and does not
  overstate the asymptotic reach of the conic-incidence term.

## Evidence boundary

This was a sealed rereview of the current manuscript sections named in the
task.  No dossier, prior review/synthesis/audit/handoff, trust manifest, Git
history/diff, Lean execution, or classifier was consulted.  External checks
used the cited Ball and Alabdullah--Hirschfeld originals, the journal-hosted
Alspach--Heinrich original, the cited Mathon primary bibliographic record, and
the cited Reichard--Woldar account.
