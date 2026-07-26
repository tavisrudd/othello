# C637 exact secant--quadratic-hull pilots

**Lane:** `relconic`

**Date:** 2026-07-25

**Status:** COMPLETE POSITIVE.  THE THREE BOUNDED OPEN VALUES ARE
\[
\rho_{\mathcal C}(13)=8,\qquad
\rho_{\mathcal C}(17)=9,\qquad
\rho_{\mathcal C}(19)=10.
\]
No paper file was edited.

## Question and reduction

For an arc \(A\subseteq\operatorname{PG}(2,q)\), let \(U(A)\) be the
ordinary-uncovered locus: the points outside \(A\) which lie on no secant of
\(A\).  The arc is complete outside some nonsingular conic if and only if
there is a nonsingular quadratic form which vanishes on \(U(A)\) and nowhere
on \(A\).

C628 proves, for the three sizes relevant here, that this is equivalent to
\[
\operatorname{rank}\nu_2(U(A))<6,\qquad
U(A)\text{ is an arc},\qquad
A\cap\operatorname{Hull}_2(U(A))=\varnothing.
\]
Thus an exact projective arc classification followed by six-column quadratic
rank is lossless.  In particular, full rank alone rejects a candidate.

## Exhaustive lower-bound certificates

Every arc of size at least four contains a projective frame.  The enumerator
maps every ordered frame to
\[
(1,0,0),\ (0,1,0),\ (0,0,1),\ (1,1,1)
\]
and takes the lexicographically least image over all ordered frames.  Starting
from this standard frame, it augments by every legal projective point and
deduplicates by that canonical form.  Induction on the size therefore gives
one representative of every projective arc class.

The exact results are:

| \(q\) | rejected size \(k\) | projective classes at \(k\) | tested candidates | quadratic ranks |
|---:|---:|---:|---:|---:|
| 13 | 7 | 80 | 80 classes | all 80 have rank 6 |
| 17 | 8 | 5,441 | 5,441 classes | all 5,441 have rank 6 |
| 19 | 9 | reached from 20,361 eight-arc classes | 1,053,996 legal extensions | all 1,053,996 have rank 6 |

For \(q=19\), testing all legal extensions of all canonical eight-arc
representatives is exhaustive even though the nine-arcs are not
deduplicated: deleting one point from any nine-arc produces an eight-arc,
and projective transport identifies that parent with one of the enumerated
representatives.

Consequently no arc of the rejected size can be complete outside a
nonsingular conic.  Together with the pre-existing integer lower bounds this
gives
\[
\rho_{\mathcal C}(13)\ge8,\qquad
\rho_{\mathcal C}(17)\ge9,\qquad
\rho_{\mathcal C}(19)\ge10.
\]

The \(q=13\) negative result has a deliberately independent check which does
not use projective canonicalization.  It examines all 53,960 legal
seven-arcs containing the fixed standard frame; every one again has
quadratic rank six.  Since every seven-arc is projectively equivalent to one
containing that frame, this is a second exhaustive proof of the first row.

## Attaining witnesses

Coordinates below are normalized projective representatives.  Quadratic
coefficient vectors use the monomial order
\[
(X^2,Y^2,Z^2,XY,XZ,YZ).
\]

For \(q=13\), the eight-arc
\[
\begin{split}
\{&(0,0,1),(0,1,0),(1,0,0),(1,1,1),\\
  &(1,2,3),(1,3,2),(1,4,5),(1,5,4)\}
\end{split}
\]
has six ordinary-uncovered points and is complete outside the nonsingular
conic with coefficient vector
\[
(6,5,5,6,6,1).
\]

For \(q=17\), the nine-arc
\[
\begin{split}
\{&(0,0,1),(0,1,0),(1,0,0),(1,1,1),(1,2,3),\\
  &(1,3,2),(1,4,5),(1,9,8),(1,16,11)\}
\end{split}
\]
has five ordinary-uncovered points and is complete outside the nonsingular
conic with coefficient vector
\[
(8,5,6,10,7,1).
\]

For \(q=19\), the ten-arc
\[
\begin{split}
\{&(0,1,8),(1,1,0),(1,3,14),(1,9,0),(1,9,12),\\
  &(1,11,11),(1,13,9),(1,16,1),(1,16,12),(1,18,7)\}
\end{split}
\]
is a complete arc in the whole plane: its ordinary-uncovered locus is empty.
It is disjoint, for example, from the nonsingular conic
\[
X^2+YZ=0.
\]
These witnesses give the reverse inequalities and hence the three exact
values.

The independent witness verifier reconstructs the ordinary-uncovered locus
from scratch, checks every arc triple, solves the quadratic kernel, and
checks that the exhibited zero locus has \(q+1\) points with no collinear
triple and avoids the selected arc.  It returns respectively uncovered sizes
\(6,5,0\), quadratic nullities \(1,1,6\), and `verified`.

## Reproducibility

The projective classifier and rank checker are
`notes/2026-07-25-c637-secant-hull-coupling.cpp`.  It was compiled with
GCC 14.3.0 by

```text
g++ -O3 -std=c++20 -Wall -Wextra -Werror \
  -Wno-array-bounds -Wno-stringop-overread \
  notes/2026-07-25-c637-secant-hull-coupling.cpp \
  -o /home/tavis/.cache/othello-c637/secant-hull-coupling
```

The two disabled GCC diagnostics are optimizer false positives in copying a
fixed-size `std::array`; arithmetic and bounds remain checked by the source.
The exact commands producing the lower-bound outputs were

```text
/home/tavis/.cache/othello-c637/secant-hull-coupling \
  13 7 notes/2026-07-25-c637-q13.json
/home/tavis/.cache/othello-c637/secant-hull-coupling \
  17 8 notes/2026-07-25-c637-q17.json
/home/tavis/.cache/othello-c637/secant-hull-coupling \
  19 9 notes/2026-07-25-c637-q19-k9.json --extension-witness
```

The positive extension outputs, deterministic fixed-conic search, independent
frame check, and independent witness replay are in the accompanying
`c637-*` JSON and source files listed by the SHA-256 manifest
`notes/2026-07-25-c637.sha256`.

The trust boundary is finite-field integer arithmetic modulo the declared
prime, exhaustive loop coverage, projective-frame canonicalization, and the
C++ compiler/runtime.  The \(q=13\) lower bound and all three upper witnesses
have independent Python replays.  The \(q=17\) class reduction and \(q=19\)
extension reduction do not have a second implementation; their compact
canonical outputs, full sources, hashes, and exact commands are retained for
replay.

## `ej` + `tt` closeout

The cheap extra step was decisive: after full quadratic rank excluded
\(7,8,9\), testing the next sizes found witnesses \(8,9,10\).  The three
witnesses occupy all three C628 strata.  At \(q=13\), six uncovered points
have a unique avoiding conic; at \(q=17\), five uncovered points determine
their unique avoiding conic; at \(q=19\), the witness is already complete in
the whole plane, so its quadratic kernel has dimension six.  The mechanism
does not merely repeat one template across the three fields.

The strongest surprise is the \(q=19\) extra jump.  All 1,053,996 tested
nine-arc extensions have full quadratic rank, whereas a ten-arc with no
ordinary-uncovered point appears quickly.  Thus the final obstruction is a
sharp coverage transition, not selected-point incidence with a rank-five
hull or an all-singular quadratic kernel.

## Mystery ledger

- **Settled:** the bounded C628 pilots have exact values
  \((8,9,10)\) at \(q=(13,17,19)\).
- **Settled:** every minimum-size candidate previously left open is rejected
  by the first C628 alternative, full quadratic rank.  No hull-incidence or
  singular-kernel ambiguity survives in these cases.
- **Settled:** explicit witnesses attain the next size in all three fields,
  with independent direct verification.
- **Open:** there is no field-uniform theorem explaining why all 80,
  5,441, and 1,053,996 respective candidates have full quadratic rank.  The
  present conclusion is exact but finite; a structural secant--Veronese
  coupling theorem remains a genuine unallocated research question.
- **Open:** the abrupt \(q=19\) transition from universal rank six at size
  nine to an empty uncovered locus at size ten has no conceptual
  classification here.  It does not affect the exact value.
