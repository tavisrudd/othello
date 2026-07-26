# C644 q=19 uncovered-arc residue

**Lane:** `relconic`

**Date:** 2026-07-25

**Status:** COMPLETE POSITIVE.  THE SOLE UNCOVERED-ARC RESIDUE IN THE C637
Q=19 EXTENSION SEARCH IS A PAIR OF REGULAR ORBITS OF A PROJECTIVE
HEISENBERG GROUP \(C_3^2\).  THE TWO ORBITS LIE ON DISTINCT CUBICS IN ONE
COMMON SEMI-INVARIANT PENCIL.  THEIR CHORD DIRECTIONS EXPLAIN THE ASYMMETRIC
SECANT AVOIDANCE, AND THE NINE NEAREST CONICS FORM ONE GROUP ORBIT.  LEAN
KERNEL-CHECKS THE COMPACT MATRIX, ORBIT, CUBIC, AND REPRESENTATIVE CONIC
IDENTITIES.  EXHAUSTIVE UNIQUENESS AND THE FULL PROFILE REMAIN EXTERNAL.
No paper file was edited.

## The pair

Write \(A\) for the selected nine-arc and \(U\) for its ordinary uncovered
nine-arc:
\[
\begin{split}
A=\{&(0,0,1),(0,1,0),(1,0,0),(1,1,1),(1,2,3),\\
 &(1,3,11),(1,4,9),(1,13,7),(1,14,15)\},
\end{split}
\]
\[
\begin{split}
U=\{&(1,6,10),(1,6,18),(1,10,4),(1,11,16),(1,15,2),\\
 &(1,15,18),(1,16,6),(1,16,10),(1,18,4)\}.
\end{split}
\]
C643 found this as the sole tested extension whose ordinary uncovered locus
is an arc.  That uniqueness statement remains part of the external C637/C643
parent-extension classification.

## Projective Heisenberg symmetry

Over \(\mathbf F_{19}\), let
\[
g=\begin{pmatrix}0&0&1\\3&0&0\\0&11&0\end{pmatrix},\qquad
h=\begin{pmatrix}1&7&1\\2&7&3\\3&7&11\end{pmatrix}.
\]
Direct calculation gives
\[
g^3=14I,\qquad h^3=15I,\qquad gh=11hg,
\]
with
\[
11^2+11+1=0,\qquad 11\ne1.
\]
Thus the projective classes of \(g\) and \(h\) are independent commuting
elements of order three.  They generate \(C_3^2\) in
\(\operatorname{PGL}_3(\mathbf F_{19})\).  Both \(A\) and \(U\) are regular
nine-point orbits of this group.

The external frame-transporter calculation finds
\[
|\operatorname{Aut}(A)|=|\operatorname{Aut}(U)|
=|\operatorname{Aut}(A,U)|=9.
\]
Thus the displayed subgroup is the full projective stabilizer of each object
and of the ordered pair.  There is no projectivity taking \(A\) to \(U\).
The exact stabilizer upper bound and inequivalence are external finite
calculations; Lean checks the displayed subgroup and both orbit identities.

The nontrivial scalar commutator is the standard projective Heisenberg
signature.  In particular, this mechanism needs a primitive cube root in the
ground field.  It is unavailable over fields of order \(2\) modulo \(3\) and
naturally appears at the nine-point \(3^2\)-orbit scale.

## Common cubic pencil

Use the monomial order
\[
(X^3,Y^3,Z^3,X^2Y,X^2Z,Y^2X,Y^2Z,Z^2X,Z^2Y,XYZ).
\]
The unique cubic through \(A\) has coefficient vector
\[
F_A=(0,0,0,1,2,1,13,7,7,7),
\]
and the unique cubic through \(U\) has coefficient vector
\[
F_U=(1,16,15,3,6,3,1,2,2,1).
\]
Both transform by the same character:
\[
F_\bullet(gv)=14F_\bullet(v),\qquad
F_\bullet(hv)=15F_\bullet(v).
\]
Consequently the pencil
\[
\{\lambda F_A+\mu F_U:[\lambda:\mu]\in\mathbf P^1(\mathbf F_{19})\}
\]
is stabilized termwise by the projective \(C_3^2\).  This is a twisted
Heisenberg-invariant, or Hesse-type, cubic pencil.  It is the conceptual
carrier of the exceptional pair.

The twenty rational pencil members have projective point-count distribution
\[
0^3,\qquad18^{12},\qquad27^4,\qquad57^1.
\]
The two displayed members each have 18 rational points, and their common
base locus has no \(\mathbf F_{19}\)-rational point.  The uniqueness of each
cubic, the pencil point counts, and the rational-base-locus statement are
external exact calculations.  Lean checks membership of the two orbits and
the four symbolic semi-invariance identities.

## Chord-direction mechanism

Label both regular orbits by \(C_3^2\), using one base point and the powers of
\(g,h\).  The 36 unordered chords of \(U\) split into four direction classes
of nine chords each.

- The directions \((0,1),(1,0),(1,1)\) each have all nine chords passing
  through one point of \(A\).
- The direction \((1,2)\) has all nine chords disjoint from \(A\).

For a chord with endpoint labels \(x,y\), put \(z=-x-y\), the third point on
their affine \(C_3^2\)-line.  In the three hitting directions the label of
the point of \(A\) is respectively
\[
z+(1,1),\qquad z+(1,0),\qquad z.
\]
Every point of \(A\) therefore lies on exactly three \(U\)-secants.
Conversely, every point of \(U\) lies on no \(A\)-secant by construction.
The pair is not symmetric and \(A\cup U\) is not an 18-arc.

The complete line-type profile, where a type \((i,j)\) means \(i\) points of
\(A\) and \(j\) points of \(U\), is
\[
\begin{array}{c|rrrrrrr}
(i,j)&(0,0)&(0,1)&(0,2)&(1,0)&(1,1)&(1,2)&(2,0)\\
\hline
\#&147&81&9&54&27&27&36.
\end{array}
\]
This accounts for all 381 projective lines.  The asymmetric four-direction
split is the direct human explanation for how \(U\) remains an arc while
being exactly the uncovered locus of \(A\).

## All 126 five-subset conics

Every five-subset of the nine-arc \(U\) determines a nonsingular conic.
Among the 126 subsets there are 81 distinct conics:

- 72 conics contain exactly five points of \(U\), each arising from one
  five-subset;
- 9 conics contain six points of \(U\), each arising from its six
  five-subsets.

The full profile is
\[
\begin{array}{c|c|c|c|c|r}
|C\cap U|&|C\cap A|&A_{\rm int}&A_{\rm ext}&
\text{distinct conics}&\text{five-subsets}\\
\hline
5&0&3&6&9&9\\
5&0&4&5&9&9\\
5&0&5&4&45&45\\
5&1&4&4&9&9\\
6&1&3&5&9&54
\end{array}
\]
No conic contains seven points of \(U\) or two points of \(A\).

The nine closest conics, those containing six points of \(U\), form one
\(C_3^2\)-orbit indexed by their unique point of \(A\).  Relative to that
point's group label, the three omitted \(U\)-labels are always
\[
\{(1,0),(2,0),(2,2)\}.
\]
The tangent to each conic at its unique point of \(A\) contains no other
point of \(A\) and no point of \(U\).  Thus polarity does not create a
separate organizing symmetry; it is subordinate to the Heisenberg orbit.

One representative is
\[
Q=X^2+4Y^2+5Z^2+15XY+3XZ+11YZ.
\]
It contains six displayed points of \(U\) and the selected point
\((1,3,11)\), but
\[
Q(1,15,18)=13\ne0.
\]
Lean kernel-checks these evaluations.

## Field-uniform verdict

The hoped-for unconditional statement

> every minimum-size rejected candidate has an uncovered collinear triple

is false: this pair is an exact counterexample.

The calculation suggests a corrected dichotomy in which a nine-point
uncovered arc may survive only through a projective Heisenberg orbit pair or
a related cubic-pencil torsor.  The present finite data do not prove that
dichotomy.  What is proved here is narrower:

1. the unique q=19 survivor in the external classification has the exact
   Heisenberg mechanism above;
2. the mechanism requires a primitive cube root and nine-point orbit scale;
3. scalar repeated-coverage moments cannot detect it, because the decisive
   information is the four-direction chord action.

A field-uniform theorem must therefore either exclude projective
\(C_3^2\)-orbit pairs by hypothesis or classify them as an explicit
exceptional branch.  Treating the observed q=19 pair as evidence for a
universal classification would exceed the certificate.

## Formal and external trust boundary

`RelativeConicArcs.NinePointHeisenbergPair` kernel-checks:

- both matrix-cube identities and the primitive cube-root commutator;
- preservation of \(A\) and \(U\) by both generators;
- realization of both nine-point lists as full displayed Heisenberg orbits;
- vanishing of \(F_A\) and \(F_U\) on their respective lists;
- the four symbolic cubic semi-invariance identities;
- the representative six-point conic evaluations.

The dedicated gate has eighteen terminals.  Every terminal has axiom
boundary exactly
`[propext, Classical.choice, Quot.sound]`.

The following remain external:

- C637/C643 coverage of all q=19 parent extensions and selection of this
  pair as the sole uncovered-arc residue;
- exact maximality of the order-nine stabilizer and inequivalence of the two
  orbits;
- uniqueness of the two cubics, all pencil point counts, the four chord
  direction profile, and the complete 126-subset conic census.

Thus the formal result explains the fixed residue but does not change the
external trust status of
\(\rho_{\mathcal C}(19)=10\).  The same boundary is recorded in
`lean/RelativeConicArcs/TRUST.md`.

## Reproducibility

Run from the repository root:

```text
python3 notes/2026-07-25-c644-q19-residue-profile.py \
  notes/2026-07-25-c643-q19.json \
  notes/2026-07-25-c644-q19-residue-profile.json
sha256sum -c notes/2026-07-25-c644.sha256
```

The script reconstructs all projective points and lines, all 126 five-subset
conics, all frame-induced projectivities stabilizing either orbit, the
secant multiplicities, the \(C_3^2\) labels and chord directions, and the
cubic pencil.  It uses exact integer arithmetic modulo 19 and no randomized
step.

The exact Lean target is
`RelativeConicArcs.Gates.NinePointHeisenbergPair`.  The successful build used
the repository's single-thread guarded queue; the gate peak was 1,809,228 KiB
and the source peak was 2,420,444 KiB.

## `ej` + `tt` closeout

The complete conic profile settles the polarity question: the nine nearest
conics are one Heisenberg orbit, and their tangent data add no independent
symmetry.  The cubic calculation exposes more structure than the original
six-point certificate: both nine-point sets are fibers of one common
semi-invariant pencil, while the chord directions record the asymmetric
coverage map.

The strongest next question is no longer “why does the rank become six?”
It is:

> Can every large uncovered arc paired with a small covering arc be reduced
> either to a collinear-triple obstruction or to a projective Heisenberg
> torsor?

That question is field-uniform and mechanism-level, but the current q=19
classification supplies only one exceptional instance.  A responsible next
step is to develop the abstract \(C_3^2\)-orbit chord calculus before
asserting a dichotomy.

## Mystery ledger

- **Settled:** the q=19 residue is not generic.  Its full projective
  stabilizer is \(C_3^2\), acting regularly on both \(A\) and \(U\).
- **Settled:** the 126 five-subset conics collapse to 81 conics in five
  exact profile types; the nine six-point conics are one group orbit.
- **Settled:** conic polarity is subordinate.  The tangent at the unique
  selected point on each closest conic avoids both point sets.
- **Settled:** the asymmetric uncovered-locus mechanism is the four-direction
  \(U\)-chord action: three directions hit \(A\), one does not, whereas every
  \(A\)-chord avoids \(U\).
- **Settled:** the matrix, orbit, cubic-character, and representative conic
  core is kernel-checked without importing exhaustive uniqueness.
- **Open:** no theorem classifies all projective Heisenberg orbit pairs over
  arbitrary finite fields or determines exactly when one orbit is the
  uncovered locus of another.
- **Open:** the proposed collinearity-or-Heisenberg dichotomy has evidence
  from one exceptional projective class only.  Its exact gate is an abstract
  orbit/chord calculation followed by a search for non-Heisenberg survivors,
  not a larger unstructured census.
