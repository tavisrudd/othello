# C798 — fixed-line Chow rigidity

**Lane:** `clebsch`

**Status:** complete

## Goal

Turn C797's sharp counterexample into the Paper II priority-judo theorem.
The quadratic trade does not reconstruct the matching embedding; instead it
recovers an abstract homogeneous sheet module with a finite affine ambiguity
fibre.  Classify that fibre and prove that the matching configuration is the
unique point where it meets the secant-product Chow locus.

## Target theorem

For the exceptional stabilizers
\[
(q,K)=(7,S_4),\qquad(11,A_5),
\]
let \(A=\epsilon^{-1}(1)\) be the affine conic-quotient module and let
\(v\in A\) be the matching point.  Prove:

1. \(A^K\) is an affine line over \(\mathbf F_q\);
2. its \(q\) rational points give \(q\) distinct full-group placements of
   \(G/K\), all with the same unique two-valued quadratic-trade profile;
3. exactly one placement lies in the secant-product Chow locus; and
4. determine the lowest-degree intrinsic covariant that selects that point,
   or prove that complete reducibility is the sharp faithful refinement.

This classifies what the collided general Gorenstein mechanism and the failed
trade-only reconstruction both leave unresolved: the embedding ambiguity of
the exceptional homogeneous configuration.

## Alternative attacks

- **Fixed-space attack:** compute \(F^K\) and the affine extension class,
  then identify \(A^K\) without orbit enumeration.
- **Chow-intersection attack:** restrict the secant-product factorization
  equations to \(A^K\) and compute their gcd or resultant in the line
  parameter.
- **Covariant attack:** restrict the signed cubic and higher moments to the
  line and find the first projective invariant whose distinguished root is the
  matching placement.
- **Incidence attack:** reconstruct endpoint pairing from the completely
  reducible lift and prove uniqueness from the squarefree conic restriction.

## First gates

1. Reconstruct the \(q=11\) affine action from the complete matching image,
   verify it from two independent affine bases, and solve the \(A_5\)-fixed
   equations directly rather than enumerating \(11^{15}\) points.
2. Check orbit sizes, Schur-square ranks, trade profiles, matching-image
   intersection, and projective signed cubics on every fixed-line point.
3. Combine the \(q=7\) and \(q=11\) results into a human fixed-space and
   Chow-intersection proof; stop at the exact first obstruction if the pattern
   fails.

## Acceptance

A positive result gives a human ambiguity-classification theorem and the
unique Chow intersection for both exceptional fields, with an atomic exact
bundle and bounded novelty audit.  A negative result gives the first exact
failure, its structural cause, and the nearest faithful observable.  Complete
with `ej`+`tt`, a mystery ledger, handoff/queue lifecycle, and no manuscript
placement before a separate gate.

## Closeout

Completed by notes/2026-08-02-c798-fixed-line-chow-rigidity.md. The human
theorem proves an affine fixed line, a unique secant-product Chow point, and
\(q-2\) nonmatching exact-trade orbits without enumeration. The exact
\(q=11\) census is retained only as a non-load-bearing boundary cross-check.
Complete reducibility is the sharp faithful refinement. C801 owns the queued
Lean update after statement freeze.

## Ownership

C798 owns its task card, queue row, dated report and exact bundle, Clebsch
handoff updates, and any later explicitly admitted Paper II placement.  It
does not alter C749 or C750.
