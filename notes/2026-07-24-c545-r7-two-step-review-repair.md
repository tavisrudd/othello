# C545 R7 two-step review repair

**Lane:** `reed-solomon`  
**Date:** 2026-07-24  
**Status:** repaired and independently confirmed

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

Both manuscript drivers build without final LaTeX warnings.  After the
editorial closure, the canonical and IEEE review builds have 29 and 22 pages.

The next independent review confirmed the displayed floor byte-for-byte,
recomputed the degree-\(16\) two-marker package and its fixed-factor
exclusion, checked the marker--gcd equivalence, and independently reproduced
sample \(E_f\) and \(\tau_5\) entries.  It therefore closes the cold-review
gate.  Its six residual editorial findings are also repaired in source:
the R6 deletion bound is nineteen; the \(q=8\) R7 profile explicitly removes
the central nucleus singleton; Proposition 6.10 cites both lower exclusions;
its lower-net variable is no longer overloaded; the quadratic-gcd
catalecticant clause is explicit; and the R7 \(x=r\) branch is controlled by
the degree-at-most-six evaluation minors inside the marked
self-collision divisor.  A final referee check caught one remaining
presentation defect inside Proposition 6.10: its conclusion
\(\lambda_0\notin\{x,s\}\) was still bare.  The invocation now points
locally to both preceding ingredients---the fixed-\(x\) minors and the
pointed self-collision exclusion for \(s\).

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

## Editorial truth table

| Review condition | Printed resolution | Budget or census effect |
|---|---|---|
| R6 marked deletion is \(13+6\) | Proposition 6.4(iii) says nineteen | none; threshold remains \(29\) |
| The \(q=8\) R7 profile omits one known orbit | The theorem says the central nucleus singleton is removed before printing the additional profile | none; census total is unchanged |
| R7 uses the lower secant and cyclic/wild exclusions | Proposition 6.10 cites Propositions 6.3 and 6.4/6.5 at the two uses | none |
| The lower-net letter collides with the ambient syndrome \(f\) | Proposition 6.10 uses \(h\) for the lower syndrome and \(g\) for a member | none |
| A contraction has quadratic gcd | The rank-at-most-two three-row catalecticant clause points to the transverse degree-three and contained alternatives | none |
| The R7 exact-gcd-one root equals the first marker \(r\) | Degree-at-most-six evaluation minors place the branch inside the existing degree-eight marked self-collision divisor | no new deletion term |
| The Proposition 6.10 lower gcd equals \(x\) or \(s\) | The invocation now cites the fixed-\(x\) minors immediately above and Proposition 6.4's pointed self-collision exclusion for \(s\) | no new deletion term |

## Mystery ledger

| Feature | Status | Evidence or remaining gate |
|---|---|---|
| Why the review obtained \(29.718\) for \(\mathcal H_1(1,19)\) | settled | That is the unfloored real expression.  The theorem uses one plus its floor, equal to \(29\); the revised display and direct \(q=29\) inequality remove the ambiguity. |
| Whether the R7 second step meets a cyclic pencil with no split witness | settled | The cyclic/wild pullback is an outer second-marker exclusion of degree at most four. |
| Whether a lower fixed factor can equal an old or new marker | settled | Equality with the new marker is in the pointed collision divisor; equality with the old marker is the nonzero degree-at-most-two evaluation-minor locus. |
| Whether the repaired R7 proof is independently referee-clear | settled | The next reader reconstructed the degree-\(16\) package and independently checked the fixed-factor exclusion, marker--gcd equivalence, threshold arithmetic, and sample census invariants. |
| External certificate and release packaging | separately owned | No certificate, replay, manifest, or release identifier was changed in this repair. |
