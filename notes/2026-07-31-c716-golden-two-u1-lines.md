# C716 — Golden two-\(U(1)\) anomaly lines

**Lane:** `golden`

**Date:** 2026-07-31

## Verdict

The two-\(U(1)\), six-Weyl anomaly problem is exactly the line problem on
the Segre cubic, and the Golden lift makes its six chiral components almost
tautological.  Fix five path controls and move the sixth.  Every frozen C707
cubic is multi-affine, so

\[
 Z(x+\lambda e_i)=Z(x)+\lambda\,\partial_iZ(x)
\]

is an exact line, not a higher-degree curve.  For generic fixed controls it
is chiral.  Fixing the other five points modulo \(\operatorname{PGL}_2\)
gives \(M_{0,5}\); its compactification is the split degree-five del Pezzo
surface.  The six choices of the moving path are therefore precisely the six
chiral Fano components.  A fixed collision of two paths gives one of the
fifteen vectorlike Segre planes and hence one of the fifteen nonchiral plane
components.

This supplies a stronger control statement than the requested pointwise
inverse.  A generic anomaly vector has exactly six compatible chiral
second-factor directions, and they are the six single-wire Golden responses
\(\partial_iZ\).  Every direction is itself a one-\(U(1)\) anomaly vector and
satisfies both mixed anomalies with \(Z\).

The abstract Fano classification and del Pezzo geometry are classical.  The
new return is the exact C707 marking, the one-knob operator realization, and
the polarized Majorana identities

\[
 \sum_T\det A_T(x)\operatorname{Pf}A_T(y)=0,
 \qquad
 \sum_T\operatorname{Pf}A_T(x)\det A_T(y)=0,
\]

for Golden controls synthesizing the two charge directions, where
\(A_T(x)=[D_x,C_T]\).

## 1. Line criterion

Let \(k\) have characteristic zero and let \(q,r\in k^6\) be linearly
independent.  Put \(z(s,t)=sq+tr\).  The projective line
\(\mathbf P\langle q,r\rangle\) lies on the Segre cubic if and only if

\[
\begin{aligned}
 &\sum_iq_i=\sum_ir_i=0,\\
 &\sum_iq_i^3=\sum_ir_i^3=0,\\
 &\sum_iq_i^2r_i=\sum_iq_ir_i^2=0.
\end{aligned}
\]

Indeed, the linear equation gives the first row, while

\[
 \sum_i(sq_i+tr_i)^3
 =s^3\sum_iq_i^3+3s^2t\sum_iq_i^2r_i
  +3st^2\sum_iq_ir_i^2+t^3\sum_ir_i^3.
\]

The four cubic coefficients vanish independently.  These are exactly the
two individual cubic anomalies and the \(U(1)_q^2U(1)_r\) and
\(U(1)_qU(1)_r^2\) mixed anomalies; the two linear equations are the two
mixed gravitational anomalies.

## 2. Structural theorem

### Theorem 1 (Golden Fano synthesis)

Let \(Z=(Z_0,\ldots,Z_5)\) be the six C707-marked Golden cubics.

1. For every path label \(i\), the family
   \(\lambda\mapsto[Z(x+\lambda e_i)]\) is a projective line or a point on
   the Segre cubic.  If the other five path points are distinct and generic,
   it is a chiral line.  The closure of all such lines is one split
   degree-five del Pezzo component \(\mathcal D_i\).
2. The six \(\mathcal D_i\) are the six chiral components of the Fano
   variety.  A path permutation \(\sigma\) sends
   \(\mathcal D_i\) to \(\mathcal D_{\sigma(i)}\), while acting on the six
   amplitude coordinates through the exceptional outer automorphism.
3. For every path pair \(\{i,j\}\), the collision \(x_i=x_j\) maps into the
   C715-marked vectorlike plane whose three opposite charge pairs are the
   syntheme attached to \(\{i,j\}\).  Lines in that plane form one plane
   component of the Fano variety.  These are all fifteen nonchiral
   components.
4. On a generic chiral line in \(\mathcal D_i\), the five intersections with
   vectorlike planes occur exactly when the moving control meets one of the
   five fixed controls.  Consequently the unordered five wall values,
   modulo projectivity, are the \(M_{0,5}\) coordinate of the line.
5. Through a generic smooth nonvectorlike point \([Z(x)]\) pass exactly the
   six chiral lines with directions \([\partial_iZ(x)]\), one from each
   \(\mathcal D_i\).

#### Proof

Each monomial of each \(Z_T\) uses three distinct path variables.  Hence
\(Z_T\) has degree at most one in each \(x_i\), proving the displayed affine
line formula.  The Segre identities hold for every control, so coefficient
comparison proves all six anomaly equations for
\((Z(x),\partial_iZ(x))\).

Fixing five ordered points on \(\mathbf P^1\) modulo
\(\operatorname{PGL}_2\) gives \(M_{0,5}\), of dimension two.  Moving the
sixth gives a line on the quotient.  On the locus of six distinct points no
pair-collision equation holds identically, so the generic line is not in a
vectorlike plane.  Its closure is therefore contained in a chiral Fano
component.  The imported classification says there are six irreducible
chiral components, each a split degree-five del Pezzo surface.  The six
two-dimensional moving-point families are permuted transitively, so they are
exactly those components; their compactified fixed-five moduli is the usual
\(\overline M_{0,5}\) model of that del Pezzo surface.

If \(x_i=x_j\), the three matching brackets containing \([ij]\) vanish.
The frozen C715 dictionary turns them into the three opposite-pair equations
of one charge syntheme, proving the plane statement.  The classical
classification supplies completeness.

Along a moving-point line, collision with a fixed point occurs at its five
fixed values.  Conversely, a generic collision on the line must involve the
only moving point, proving the wall statement.  Finally the six constructed
lines through a generic point belong to six distinct components.  The C715
inverse fibre is one labelled \(\operatorname{PGL}_2\)-orbit, so a line in
\(\mathcal D_i\) through that point must fix the same other five points.
There is therefore exactly one such line in each component and no others.
\(\square\)

### Exact component marking

In the labels of Gripaios--Nguyen's Richmond model and the frozen C707 path
labels, the exact comparison is

\[
 D_0\leftrightarrow\mathcal D_4,\quad
 D_1\leftrightarrow\mathcal D_1,\quad
 D_2\leftrightarrow\mathcal D_0,\quad
 D_3\leftrightarrow\mathcal D_2,\quad
 D_4\leftrightarrow\mathcal D_3,\quad
 D_5\leftrightarrow\mathcal D_5.
\]

The certificate substitutes generic representatives from their equations
(4.15) and (4.19) into the C715 inverse and detects the unique omitted path
for which all five-point cross-ratios are constant.

The five adjacent path transpositions act on the amplitude labels as triple
transpositions, with one common oriented minus sign.  The certificate records
all five permutations.  Thus the component action is the ordinary action on
the unique moving control wire, while the amplitude action is the outer
action on protocols.

## 3. Exact synthesized families

### Chiral component

Take

\[
 x(\lambda)=
 \left(0,-\frac12,-1,-\frac37,\lambda,-\frac35\right).
\]

Then

\[
 70Z(x(\lambda))=
 \left(
 15+29\lambda,\ 9+11\lambda,\ 3+13\lambda,
 -15-25\lambda,\ -9-23\lambda,\ -3-5\lambda
 \right).
\]

At \(\lambda=1/2\), the primitive charge vector is

\[
 (59,29,19,-55,-41,-11).
\]

It has no zero entry and no opposite pair, so the line is not contained in
any vectorlike plane and represents \(\mathcal D_4\).  Permuting the path
controls produces an exact rational family on each \(\mathcal D_i\).  All six
families remain physical contractive controls for \(|\lambda|\le1\).

### Nonchiral component

Take the persistent collision

\[
 x(\lambda)=\left(0,0,-1,-\frac12,\frac12,\lambda\right).
\]

Then

\[
 4Z(x(\lambda))=
 (-1-5\lambda,\ 1+5\lambda,\ 1-3\lambda,
  -1+3\lambda,\ 1-\lambda,\ -1+\lambda).
\]

Thus the full line obeys
\(z_0+z_1=z_2+z_3=z_4+z_5=0\).  At
\(\lambda=1/2\) its primitive charge vector is
\((7,-7,1,-1,-1,1)\), up to common sign.  Path permutations give one exact
line in every one of the fifteen collision-marked plane components.  The
certificate lists all fifteen path-pair/charge-syntheme correspondences and
all 21 exact control families.

## 4. Degree of the control lift

There is no nonlinear obstruction.  Let
\(z(t)=q+tr\) be any rational line on the Segre cubic.  In any valid C715
inverse chart its normalized six path points are

\[
 \left(\infty,0,1,
 \frac{L_1(t)}{L_2(t)},
 \frac{L_3(t)}{L_4(t)},
 \frac{L_5(t)}{L_6(t)}\right),
\]

where every \(L_j\) is linear, because every matching form is linear in
\(z\).  A fixed rational projectivity makes all six controls finite without
raising their rational degree.  Thus every rational Segre line has a
coordinatewise fractional-linear Golden lift.  Another inverse chart covers
the finitely many denominator failures.

Rational degree one is minimal for a nonconstant line: degree zero controls
give a constant six-point moduli class and hence a constant amplitude point.
On the dense part of every chiral component the stronger single-wire form
above is affine-linear after choosing the moving control itself as parameter.
The displayed nonchiral representative is affine-linear as well.  No claim
is needed that every boundary presentation remains affine-linear in one
fixed inverse chart; fractional-linear degree one is the global atlas
verdict.

## 5. Determinant and Pfaffian identities

Put

\[
 A_T(x)=[D_x,C_T].
\]

The frozen C707 normalization is

\[
 \operatorname{Pf}A_T(x)=4Z_T(x),\qquad
 \det A_T(x)=16Z_T(x)^2.
\]

Let controls \(x,y\) synthesize the two charge directions of one Segre line,
up to nonzero common scales.  The two mixed anomaly equations are equivalent
to

\[
 \boxed{\sum_T\det A_T(x)\operatorname{Pf}A_T(y)=0},\qquad
 \boxed{\sum_T\operatorname{Pf}A_T(x)\det A_T(y)=0}.
\]

There are no hidden signs: the Pfaffian orientation is exactly the frozen
orientation in which \(\operatorname{Pf}A_T=4Z_T\).

For a single-wire pencil write
\(p_T(\lambda)=\operatorname{Pf}A_T(x+\lambda e_i)\).  Multi-affinity gives

\[
 p_T(\lambda)=4\bigl(Z_T(x)+\lambda\partial_iZ_T(x)\bigr),
\]

even though a generic six-by-six Pfaffian is cubic in its entries.  The
mixed identities can therefore be read without separately constructing
\(y\):

\[
 \sum_Tp_T(0)^2p_T'(0)=0,
 \qquad
 \sum_Tp_T(0)p_T'(0)^2=0.
\]

Equivalently, each rank-one diagonal control update produces a compatible
second \(U(1)\) direction.  The commutator update itself has rank at most two,
which is the operator reason the Pfaffian pencil loses its quadratic and
cubic terms.

## 6. What the operator lift adds

It does not add a twenty-second Fano component, refine the abstract del
Pezzo isomorphism class, or produce a new algebraic classification.  Its
return is operational and marked:

- a chiral component is selected by the unique moving path wire;
- its stabilizer is the \(S_5\) fixing that wire;
- its point is the projective configuration of the other five controls;
- its five vectorlike wall crossings are the five fixed control values;
- the six chiral lines through a generic charge point are the six columns of
  the Golden response matrix \(dZ\); and
- both mixed anomalies become exact coupled Majorana determinant--Pfaffian
  identities.

The moving-wire label and five wall values are natural operational
invariants, but they are marked forms of the known outer-\(S_6\) and
\(\overline M_{0,5}\) geometry, not new unmarked Fano invariants.

## 7. Attribution and physical boundary

The companion source audit records two primary sources, one read at full
text and one at the stated partial depth.  The 21-component classification,
the degree-five del Pezzo identification, the Segre quotient, and the outer
action are attributed there.  C716 makes no priority claim.

The charge pairs solve local Abelian anomaly equations.  The Golden controls
give exact finite determinant and Majorana realizations of the same
polynomials.  They do not by themselves specify gauge fields, a Lagrangian,
matter masses, or dark-sector phenomenology.

## 8. Exact evidence and replay

The atomic evidence bundle is:

- `notes/2026-07-31-c716-golden-two-u1-lines.py`;
- `notes/2026-07-31-c716-golden-two-u1-lines.json`;
- `notes/2026-07-31-c716-golden-two-u1-lines-replay.py`;
- `notes/2026-07-31-c716-golden-two-u1-lines-literature-audit.md`;
- `notes/2026-07-31-c716-golden-two-u1-lines.sha256`.

From the repository root, run

```text
python3 notes/2026-07-31-c716-golden-two-u1-lines.py --check
python3 notes/2026-07-31-c716-golden-two-u1-lines-replay.py
```

The generator reconstructs the six frozen cubics from the base conference
matrix, derives all fifteen collision synthemes, verifies all 21 exact line
families, checks the six source-to-C707 component labels by symbolic
cross-ratios, and computes the five Coxeter generators of the outer action.
The replay hard-codes the six cubic coefficient tables and the fifteen
collision synthemes, independently re-evaluates every line, and checks the
Pfaffian normalization directly from the base commutator.

The computation fixes signs, labels, witnesses, and exact polynomial
identities.  It does not prove the imported completeness or del Pezzo
classification; those are the cited structural inputs.

## 9. `ej` + `tt` closeout and mystery ledger

- **Settled by `ej`:** the del Pezzo component has a direct one-knob model.
  Its five vectorlike intersections are not mysterious incidence points;
  they are the five values at which the moving path collides with a fixed
  path.
- **Settled by `ej`:** the unordered five wall values modulo projectivity
  recover the \(M_{0,5}\) coordinate of the chiral line.  This is the
  operational form of the split degree-five del Pezzo parameter.
- **Settled by `tt`:** the classical six-lines-through-a-generic-point fact
  is exactly the six-column response theorem: choose which one of the six
  paths to move.  No solver or Grassmannian chart is required after the
  Golden inverse.
- **Settled by `tt`:** each response column \(\partial_iZ\) is itself an
  anomaly-free charge vector and satisfies both mixed anomalies with \(Z\).
  The second \(U(1)\) direction is therefore already present in the local
  control response.
- **Settled by `tt`:** the common minus sign on odd path permutations is only
  the oriented signed-outer representation.  Projectively, the six
  components carry the ordinary action on their moving-wire labels.
- **Boundary, not a mystery:** special controls may collapse a line to a
  point, make two of the six chiral directions coincide, or move into the
  nonchiral boundary.  The theorem and the six-line count are explicitly
  generic; the full special-point incidence stratification is classical and
  is not needed for the paper theorem.
- **No genuine mystery remains in the C716 component synthesis, rational
  degree, mixed Pfaffian identities, or outer marking.**
