# C706 human proofs — the equivariant Clifford boundary

**Lane:** clebsch

**Date:** 2026-07-31

**Companion to:** notes/2026-07-30-c706-equivariant-clifford-lift.md

## Strategy

One cochain equation models every lift.  We solve it along
\[
 A_5\subset S_5\subset S_6
\]
and keep three questions separate: whether the Pauli-valued extension
splits, whether the conference marking changes the splitting class, and
whether a scalar projective multiplier remains.  The answers occur at
three different levels of this chain.

## One finite model

Let \(V=\mathbf F_2^4\) label Hermitian two-qubit Paulis.  A symplectic
map \(g\) lifts modulo scalar phase by a function \(q_g:V\to\mathbf F_2\)
such that
\[
 q_g(u+v)+q_g(u)+q_g(v)
 =\frac{c(gu,gv)-c(u,v)}2 .
\tag{1}
\]
The right side is the polarization forced by Pauli multiplication.
Solutions exist and form an affine space over \(V^\vee\), hence there are
\(16\); changing by a linear form is Pauli conjugation.  Composition is
\[
 (g,q_g)(h,q_h)=(gh,q_h+q_g\circ h).
\tag{2}
\]
All extension, splitting, and conjugacy assertions below are consequences
of these two formulas.

## Full \(S_6\): the obstruction

Use the five adjacent Coxeter generators of \(S_6\).  Choosing a lift of
each introduces \(5\cdot4=20\) binary linear-phase variables.  Substitute
(2) into
\[
 s_i^2=1,\quad (s_is_j)^2=1\ (|i-j|>1),\quad
 (s_is_{i+1})^3=1.
\]
The resulting affine linear system has coefficient rank \(15\) and
augmented rank \(16\).  More transparently, five of its equations have
left sides whose XOR is zero and right sides whose XOR is one.  Therefore
no lifts satisfy the Coxeter presentation.  This proves that
\[
 1\to V\to\operatorname{Cliff}_2/U(1)\to S_6\to1
\]
does not split, so its class in \(H^2(S_6,V)\) is nonzero.

The calculation is a proof over \(\mathbf F_2\), not a search through
unitary matrices: equation (1) has already reduced every possible lift to
the twenty variables, and the five-row XOR is a contradiction certificate.

## Golden \(A_5\): splitting and the conference class

Take generators \(a,b\) with \(a^5=b^2=(ab)^3=1\).  Their possible lifts
have eight phase variables.  Equations (1)--(2) turn the three relations
into a consistent rank-two system, leaving \(2^6=64\) splittings.
Pauli conjugation is free on them and has orbit size \(16\), so there are
four complement classes.  Equivalently,
\[
 H^1(A_5,V)\cong\mathbf F_2^2
\]
on the splitting torsor.

Let \(c(v_{ij})\) be the negative-edge indicator of the conference matrix.
For a switching symmetry \(g\),
\[
 C_{g(i)g(j)}=s_i(g)s_j(g)C_{ij}.
\]
The edge function defined by \(s_i(g)s_j(g)\) is linear under the
odd-theta/Pauli dictionary.  Hence
\[
 \ell_g=c+c\circ g
\]
is a linear Pauli correction for every golden \(g\), and the switching
law immediately gives the cocycle equation.  Conversely, solving the
linearity conditions recovers exactly the \(60\) golden elements; thus
Clifford compatibility itself detects \(A_5\).

The cocycle is not a coboundary.  If it were, \(c\) would differ from a
linear form by an \(A_5\)-invariant function on the fifteen nonzero
vectors.  Transitivity makes the latter constant, but the conference edge
table is not affine-linear.  Therefore
\[
 [\ell]\ne0\in H^1(A_5,V).
\]
This is the surviving Clebsch phase invariant.

## The exact \(S_5\) boundary

Adjoin an orientation-reversing conference symmetry \(t\).  After the
individual order relations, there are \(512\) possible generator
assignments.  Applying the remaining presentation relations through (2)
leaves \(32\) complements; the other \(480\) assignments generate the
whole preimage \(V\rtimes S_5\).  The \(32\) complements form two free
Pauli orbits, so \(H^1(S_5,V)\cong\mathbf F_2\).

Restriction to \(A_5\) reaches exactly two of its four classes.  The base
class extends and the conference-twisted class does not.  Thus:

* the Clifford \(H^2\)-obstruction vanishes already on \(S_5\);
* the distinguished conference \(H^1\)-class is lost at
  \(A_5\subset S_5\);
* the full Clifford extension first becomes nonsplit at
  \(S_5\subset S_6\).

This two-stage filtration is the mechanism behind the apparently
different positive and negative results.

## Six charts and failure to glue

The conference \(S_5\) is self-normalizing, so its conjugacy orbit has
\(720/120=6\) members.  Two distinct point stabilizers in the degree-six
action intersect in a point-pair stabilizer of order \(24\), hence in an
\(S_4\).  Conjugacy makes the extension split on all six charts.

If compatible complements existed on their overlaps, the Coxeter
generators could be taken from these local complements.  Every square,
commutation, and braid relation among adjacent transpositions is supported
on at most four letters and hence lies in one chart or a chart overlap.
Compatibility would therefore make the chosen lifts satisfy the full
Coxeter presentation and produce a global \(S_6\) complement.  The
five-row contradiction forbids this.
Therefore the global class is exactly a gluing obstruction invisible on
each chart.

Under one fixed \(S_5\), the chart six-set decomposes as \(1+5\), whereas
the golden polarity six-pack is transitive with stabilizer \(F_{20}\).
Orbit structure alone rules out an equivariant direct identification.
The only possible bridge is the exceptional outer exchange later proved
in C708.

## Scalar phase

Exact Gaussian-rational intertwiners initially satisfy
\[
 U_a^5=iI,\qquad U_b^2=I,\qquad(U_aU_b)^3=iI.
\]
Replacing \((U_a,U_b)\) by \((-iU_a,-U_b)\) makes every relation equal to
\(I\).  Hence no scalar projective multiplier remains.  The nonzero class
is Pauli-valued and belongs to the conference marking; it is neither a
Mermin contextuality class nor a Schur multiplier nor the field
\(\mathbf Q(\sqrt5)\).

The finite enumerations exhaust affine solution spaces already reduced by
(1)--(2); the five-row contradiction, conference cocycle, and subgroup
chain carry the proof.
