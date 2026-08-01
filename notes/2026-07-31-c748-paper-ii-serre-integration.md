# C748 — Paper II Serre-style integration review

**Lane:** clebsch

**Date:** 2026-07-31

**Status:** integrated and internally red-teamed; independent-reader gate open

## Integrated causal spine

1. A two-valued quadratic trade line forces the matching orbit to split
   into its two \(\operatorname{PSL}_2(q)\)-sheets.
2. A \(p'\)-matching stabilizer makes a sheet permutation module projective
   and self-dual.  Frobenius reciprocity plus the permutation pairing puts an
   actual nontrivial self-dual simple in its socle, including when the
   principal projective cover occurs.
3. The finite-group Lucas equations give the actual socle Hom space.  One
   outer extension is absent from \(\operatorname{Sym}^2F\), including the
   unique finite first wall.
4. If the forbidden quadratic moment has zero linear part, it embeds in the
   absent parity.  If its linear part is nonzero, the exact cocycle
   \(z_i(g)(t)=i(t)c(g)\) contracts either through a retracted Fischer factor
   or through the unique adjacent-wall trace/spill pair.  Both alternatives
   contradict the moment-map splitting.
5. Hence each sheet has size \(q\).  Orbit--stabilizer and Dickson's list
   leave \(q=5,7,9,11\); block-system arguments remove \(5,9\), and the
   surviving cases are exactly \(q=7,11\).

## Modular-representation cold pass

Internal verdict: **GO, non-independent**.

The pass reconstructed the projective-socle step, the finite-group degree
bound, the determinant-normalized outer action, the partial-trace
contraction, the first-wall Clebsch--Gordan row, and every exceptional test
module.  It rejected and repaired three points:

- a retraction \(E\to S\) was replaced by the legitimate
  \(S\hookrightarrow F\twoheadrightarrow S\) contraction;
- the algebraic-group Lucas argument was extended across the sole finite
  wall, with the two compensating sign changes written explicitly; and
- one-digit nonsplitting was separated from multi-digit Lucas absence.

A later theorem-only hostile pass challenged the one-digit application once
more: the lemma states nonsplitting conditionally on the outer parity of the
unique \(S\to F\) line.  The apparent gap is resolved by the same dichotomy.
If the forbidden extension does not occur in \(F\), then \(i_\square=0\) and
the quadratic moment embeds in the absent square parity.  If
\(i_\square\ne0\), it itself spans the unique Hom line, so that line has
parity \(S^\square\) and the first-wall clause applies.  This implication is
now explicit in the manuscript.  The pass also isolated the only numerical
exception to the Borel weight-gap estimate, \((p,s,e)=(3,0,2)\); the Lucas
congruence makes its Hom line absent, so the spill branch never uses it.

The generic-wall programs remain conditional corroboration and are not used
as proof of the adjacent-wall identification.

## Context-free exposition cold pass

Internal verdict: **GO, non-independent**.

Read from the theorem backward, without the C746/C747 task reports, the text
determines the obstruction and the two survivors from its own definitions.
The single obstruction is the incompatible pair
\[
 (p-2-s)x=1,\qquad x=0,
\]
unless a Fischer retraction already detects the affine class.  The final
classification is memorable as
\[
 \text{two levels}\Rightarrow\text{two PSL sheets}
 \Rightarrow |\text{sheet}|=q
 \Rightarrow |K|=(q^2-1)/2
 \Rightarrow q=7,11.
\]

## Validation

- statement identity: 28 statements;
- trust metadata: 13 evidence bundles;
- generic first-wall primary and closed-form replay: green;
- full authoritative aggregate and existing Lean axiom allowlist: green;
- 36-page PDF build and warning scan: green;
- visual inspection of proof pages 6--10: green.

## Open acceptance gate

C748 requires two readers independent of the authoring/red-team pass: one
finite-group/modular-representation reader and one context-free exposition
reader.  No independent verdict has been supplied in this run.  Therefore
C748 is not complete, C749's proof surface is not frozen, and C750 Lean must
remain untouched.

## Mystery ledger

| feature | status | remaining gate |
|---|---|---|
| projective principal summand | settled | independent modular read |
| finite first-wall outer parity | settled in text | independent modular read |
| adjacent spill uniqueness | settled in text and corroborated | independent modular read |
| causal exposition | internally reconstructible | independent context-free read |
| human-proof freeze | open | C749 fresh-expert `GO` after C748 |
| structural Lean | deliberately unopened | C750 after the freeze |

## Vibe check

The proof is severe enough to review now: one projective-socle input, one
Lucas parity calculation, one functorial contraction, and one adjacent-wall
spill.  The remaining issue is independence of review, not a known
mathematical or release-gate failure.
