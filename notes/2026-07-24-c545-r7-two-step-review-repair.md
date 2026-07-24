# C545 R7 two-step review repair

**Lane:** `reed-solomon`  
**Date:** 2026-07-24  
**Status:** repaired in source; cold confirmation required

## Result

The retained R5--R7 manuscript now answers the second correctness review without
using a new finite certificate.

- The threshold function is printed as
  \[
  \mathcal H_\kappa(g,\delta)
   =1+\left\lfloor
      \left(g+\sqrt{g^2+\delta-\kappa}\right)^2
     \right\rfloor .
  \]
  Thus \(\mathcal H_1(1,19)=29\), and the manuscript also checks
  \(30-2\sqrt{29}>19\).
- The R6 lower fixed-gcd equality \(\lambda_0=r\) is cut out by
  degree-at-most-five evaluation-row minors and is contained in the existing
  degree-six pointed-collision divisor.
- The R7 trivial-gcd branch now contains a complete second-marker package.
  Its outer unavailable scheme has degree at most
  \[
  1+3+4+6+2=16:
  \]
  old-marker equality, lower secant, cyclic/wild carrier, self-collision, and
  fixed-old-marker gcd.  Outside it, the bottom pencil is handled either by
  the pointed linear-gcd graph with deletion at most \(12\), or by the
  geometrically integral \(S_3\) curve with
  \((g,\delta,\kappa)=(1,25,1)\).  The latter gives the binding first
  prime-power threshold \(37\).
- The R7 exact-gcd-one case \(x=r\) is identified with the marked
  self-collision divisor instead of being discarded as a genericity
  assumption.
- The manuscript defines \(E_f\) and \(\tau_5(f)\), states and derives the R7
  persistent count, prints one canonical representative per R7 orbit-size
  block with the full-list locator, and states the three empty prime-power
  intervals.

Both manuscript drivers build without final LaTeX warnings.  The current
canonical and IEEE review builds have 28 and 22 pages.

## EJ + TT closeout

The closeout audit separated the two parameter levels explicitly.  Every
second-marker failure is now in the degree-16 outer scheme; every remaining
failure on the bottom curve is in the stated graph or \(S_3\) deletion.  The
fixed-old-marker minor locus cannot be the whole parameter line: otherwise
every member of the original trivial-gcd net would vanish at the old marker.
This closes the only potentially hidden contained case introduced by the
repair.

The numerical cutoff has slack at the outer level:
\(16<q+1\) already far below \(q=37\).  The binding condition is the bottom
\(S_3\) point count \(q+1-2\sqrt q>25\), so the repair does not raise the
geometric threshold or open a new finite-field interval.

## Mystery ledger

| Feature | Status | Evidence or remaining gate |
|---|---|---|
| Why the review obtained \(29.718\) for \(\mathcal H_1(1,19)\) | settled | That is the unfloored real expression.  The theorem uses one plus its floor, equal to \(29\); the revised display and direct \(q=29\) inequality remove the ambiguity. |
| Whether the R7 second step meets a cyclic pencil with no split witness | settled | The cyclic/wild pullback is an outer second-marker exclusion of degree at most four. |
| Whether a lower fixed factor can equal an old or new marker | settled | Equality with the new marker is in the pointed collision divisor; equality with the old marker is the nonzero degree-at-most-two evaluation-minor locus. |
| Whether the repaired R7 proof is independently referee-clear | open | A cold reader must confirm the printed two-step package without using this report or the source report.  This is the active C545 review gate. |
| External certificate and release packaging | separately owned | No certificate, replay, manifest, or release identifier was changed in this repair. |

