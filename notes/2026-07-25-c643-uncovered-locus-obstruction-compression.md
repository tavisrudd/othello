# C643 uncovered-locus obstruction compression

**Lane:** `relconic`

**Date:** 2026-07-25

**Status:** COMPLETE POSITIVE.  THE EXHAUSTIVE LOWER-BOUND CHECKS FOR
\(q=13,17,19\) REDUCE TO AN ELEMENTARY CONIC OBSTRUCTION IN EVERY CASE EXCEPT
ONE NINE-ARC AT \(q=19\), WHICH HAS A SIX-POINT CONIC-EVALUATION CERTIFICATE.
The generic reduction is kernel-checked.  The finite classifications and the
exceptional six-point data remain external certificates.  No paper file was
edited.

## Human mechanism

Let \(U(A)\) be the ordinary uncovered locus of an arc \(A\).  If \(A\) is
complete outside a nonsingular conic \(C\), then
\[
U(A)\subseteq C.
\]
This gives two immediate obstructions:

1. \(U(A)\) cannot contain three collinear points;
2. \(|U(A)|\le q+1\).

Indeed, a line meets a nonsingular conic in at most two points, and a
nonsingular conic over \(\mathbf F_q\) has \(q+1\) points.  Thus the earlier
full-rank condition on the Veronese evaluations is stronger than needed for
almost every rejected candidate.

`RelativeConicArcs.OrdinaryUncoveredObstruction` proves the mechanism without
a finite certificate.  In particular,
`Conic.completeOutside_ordinaryUncovered_arc` and
`Conic.completeOutside_ordinaryUncovered_card_le` show that completeness
outside any nonsingular conic forces the ordinary uncovered locus to be an arc
of cardinality at most `Fintype.card K + 1`.

## Compressed finite classification

The C637 projective classifier was replayed with exact secant multiplicities
and uncovered-locus tests.

| \(q\) | rejected size | tested objects | elementary obstruction |
|---:|---:|---:|---|
| 13 | 7 | 80 projective classes | all 80 uncovered loci contain a collinear triple |
| 17 | 8 | 5,441 projective classes | all have \(20\le |U(A)|\le39\), hence \(|U(A)|>q+1=18\) |
| 19 | 9 | 1,053,996 legal extensions | 1,053,995 uncovered loci contain a collinear triple; one exception is treated below |

The q=13 conclusion has a second implementation.  It checks all 53,960 legal
seven-arcs containing the standard frame, without projective
canonicalization, and finds a collinear triple in every uncovered locus.
Their uncovered sizes range from 14 through 23.  The 1,680 frame-marked cases
with the borderline size \(q+1=14\) have respectively 17 or 22 uncovered
collinear triples, 840 cases of each type.  Thus the borderline failure is not
a single fragile incidence.

For q=13 the 80 projective classes have uncovered sizes 14 through 23.  For
q=19 the extension counts by uncovered size range from 9 through 39; the
unique size-nine case is the only uncovered arc.  These are extension counts,
not deduplicated nine-arc class counts, exactly as in C637's exhaustive
parent-extension reduction.

## The unique q=19 residue

The exceptional tested nine-arc is
\[
\begin{split}
\{&(0,0,1),(0,1,0),(1,0,0),(1,1,1),(1,2,3),\\
  &(1,3,11),(1,4,9),(1,13,7),(1,14,15)\}.
\end{split}
\]
Its ordinary uncovered locus is the nine-arc
\[
\begin{split}
\{&(1,6,10),(1,6,18),(1,10,4),(1,11,16),(1,15,2),\\
  &(1,15,18),(1,16,6),(1,16,10),(1,18,4)\}.
\end{split}
\]
The first five displayed uncovered points determine the nonsingular conic
with coefficient vector
\[
(7,9,16,10,2,1)
\]
in the monomial order
\((X^2,Y^2,Z^2,XY,XZ,YZ)\).  Its value at the sixth point
\((1,15,18)\) is \(15\ne0\) modulo 19.  Hence no conic contains the uncovered
locus.  The independent replay also checks that this conic has 20 projective
points, exactly three of the nine uncovered points miss it, and exactly one
selected point lies on it.  The last fact is a second, unnecessary failure of
the relative-conic criterion.

Thus the q=19 residue needs only six explicit points and one quadratic
evaluation, rather than a rank computation over its whole uncovered locus.

## Secant-multiplicity identity

If \(r(x)\) is the number of secants of \(A\) through an off-arc point, put
\[
R(A)=\sum_{x\notin A}\max(r(x)-1,0).
\]
Inclusion-exclusion at each point gives the exact identity
\[
|U(A)|=
q^2+q+1-|A|-\binom{|A|}{2}(q-1)+R(A).
\]
The recorded ranges of \(R(A)\) are \(90\)--\(99\), \(169\)--\(188\), and
\(285\)--\(315\) for the three searches.  These reproduce every uncovered
size in the output.  They do not by themselves give a field-uniform proof:
bounding repeated coverage sharply enough still requires rank-three
information about multiple secant concurrence.

## Trust boundary

Lean kernel-checks:

- ordinary uncovered points are contained in the prescribed hole set;
- cardinality and arc-structure descend along that containment;
- the standard Veronese conic is an arc;
- projective images defining arbitrary nonsingular conics are arcs;
- consequently completeness outside a nonsingular conic forces
  \(U(A)\) to be an arc of size at most \(q+1\).

The dedicated gate is
`RelativeConicArcs.Gates.OrdinaryUncoveredObstruction`.  Its seven terminals
use only `propext`, `Classical.choice`, and `Quot.sound`.

The following remain external:

- coverage of all 80 q=13 and 5,441 q=17 projective classes;
- coverage of all 1,053,996 q=19 parent extensions;
- the finite predicates assigning a collinear triple, an oversized uncovered
  locus, or the exceptional six-point evaluation to each tested object.

Accordingly Lean still proves only the C637 upper bounds.  The exact
equalities
\(\rho_{\mathcal C}(13)=8\),
\(\rho_{\mathcal C}(17)=9\), and
\(\rho_{\mathcal C}(19)=10\)
retain an external finite-classification dependency.  The same split is
recorded in `lean/RelativeConicArcs/TRUST.md`.

## Reproducibility

Compile the signature extractor from the repository root with

```text
g++ -O3 -std=c++20 -Wall -Wextra -Werror \
  -Wno-array-bounds -Wno-stringop-overread \
  notes/2026-07-25-c643-obstruction-signatures.cpp \
  -o /home/tavis/.cache/othello-c643/obstruction-signatures
```

Then run

```text
/home/tavis/.cache/othello-c643/obstruction-signatures \
  13 7 notes/2026-07-25-c643-q13.json
/home/tavis/.cache/othello-c643/obstruction-signatures \
  17 8 notes/2026-07-25-c643-q17.json
/home/tavis/.cache/othello-c643/obstruction-signatures \
  19 9 notes/2026-07-25-c643-q19.json --extensions
python3 notes/2026-07-25-c643-q13-frame-check.py \
  notes/2026-07-25-c643-q13-frame-check.json
python3 notes/2026-07-25-c643-q19-exception-check.py \
  notes/2026-07-25-c643-q19.json \
  notes/2026-07-25-c643-q19-exception-check.json
```

The C++ program includes the frozen C637 enumerator in the same translation
unit and adds only signature extraction.  The q=13 replay uses the independent
Python frame-marked enumeration.  The q=19 Python replay independently
reconstructs the exceptional arc's uncovered locus and checks its six-point
conic obstruction.  SHA-256 hashes are in
`notes/2026-07-25-c643.sha256`.

## `ej` + `tt` closeout

The cheap compression pass removes quadratic rank from 1,059,516 of the
1,059,517 tested projective classes or parent extensions.  The remaining
q=19 case has two explicit failures: its sixth uncovered point misses the
five-point conic, and that conic also contains one selected point.

The data expose the next conceptual target.  A field-uniform theorem would
need to force an uncovered collinear triple from the secant-concurrency
arrangement, or classify the rare case in which the uncovered locus remains
an arc.  The raw repeated-coverage identity alone is too weak; the missing
input must constrain rich concurrence geometrically.

## Mystery ledger

- **Settled:** full Veronese rank was not the operative obstruction for the
  q=13 and q=17 classifications, nor for 1,053,995 of the q=19 extensions.
  Collinearity or cardinality gives the human mechanism.
- **Settled:** the sole q=19 uncovered-arc residue has a six-point
  conic-evaluation certificate, independently replayed.
- **Settled:** the generic conic-containment, arc, and cardinality implications
  are kernel-proved; the trust ledger does not attribute the finite
  classifications to Lean.
- **Open:** no field-uniform theorem forces the observed uncovered collinear
  triples.  The exact evidence gap is a rank-three bound on rich
  secant-concurrence compression, beyond the scalar repeated-coverage moments.
- **Open:** the projective geometry of the unique q=19 residue is unexplained.
  Its nine uncovered points are an arc, but three miss the conic through the
  first five and one selected point lies on that conic.
