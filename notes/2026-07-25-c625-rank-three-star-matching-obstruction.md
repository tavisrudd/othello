# C625: polarity-stabilizer obstruction to the rank-three equality candidate

**Lane:** `relconic`

**Date:** 2026-07-25

**Status:** complete.  The sole non-hyperoval characteristic-two zero-defect
candidate \((q,k)=(4096,92)\) is impossible.  Conic polarity turns the 92 arc
points into distinct involutions stabilizing the same 91-point subset of the
conic.  The 46 tangent pairs force 46 distinct root groups of order at least
four in that stabilizer.  The characteristic-two subgroup classification of
\(\operatorname{PGL}_2(4096)\), followed by the two-orbit calculation for the
only surviving subfield group \(\operatorname{PGL}_2(64)\), contradicts the
cardinality 91.

## Result

Let \(\mathcal C\) be a nonsingular conic in
\(\operatorname{PG}(2,4096)\), and let \(A\) be a 92-arc disjoint from
\(\mathcal C\).  There is no zero-defect \(\mathcal C\)-complete pair
\((A,\mathcal C)\).

Equivalently, the rank-three star--matching realization forced by zero defect
at this parameter cannot be compatible with the prescribed conic and its
forced secant-type split.  The theorem does not claim that the naked abstract
\(\operatorname{MATCH}(92,46,1)\) design has no rank-three realization after
the conic data are discarded.

Combined with the arithmetic classification already recorded in the cold-read
frontier, this closes the even characteristic-two equality spectrum:
for even \(k\ge 6\), zero relative defect can occur only at the hyperoval
scale \(k=q+2\).  At that scale the existing geometric criterion remains
exact: a hyperoval disjoint from the prescribed nonsingular conic gives a
zero-defect pair.

## Input forced at \((4096,92)\)

Put \(m=46\), let \(N\) be the nucleus of \(\mathcal C\), and set
\[
 E=\{y\in\mathcal C:r(y)=46\}.
\]
The completed equality and parity calculations give
\[
 |E|=91,\qquad r(N)=46,
\]
and the arc secants split relative to \(\mathcal C\) as
\[
 (T,B,X)=(46,2070,2070),
\]
where \(T,B,X\) count tangent, bisecant, and external secants.  In
particular the 46 tangent secants form a perfect matching on \(A\).  Each
arc point lies on the unique tangent through it, and the arc condition
allows at most two arc points on that line.

There is also a useful equivalent hyperfocused formulation.  For every edge
\(\{P,Q\}\subset A\), the 89 maximum centres on \(PQ\) resolve the secants of
\(A\setminus\{P,Q\}\) into 89 perfect matchings.  Thus every two-point
deletion is a hyperfocused 90-arc on the deleted secant.  This is a genuine
rank-three consequence, but by itself it does not supply the obstruction
below; the decisive extra datum is the common prescribed conic.

## The conic involution lemma

Work over a perfect field \(K\) of characteristic two and normalize
\[
 \mathcal C:\ XZ=Y^2,\qquad
 c(t)=(t^2,t,1),\qquad c(\infty)=(1,0,0),
\]
with nucleus \(N=(0,1,0)\).

For \(P=(a,b,c)\notin\mathcal C\cup\{N\}\), the pencil through \(P\)
induces the projective involution
\[
 \sigma_P(t)=\frac{bt+a}{ct+b},
 \qquad
 M_P=\begin{pmatrix}b&a\\c&b\end{pmatrix}.
\]
Indeed, for distinct finite \(t,u\),
\[
 \det(P,c(t),c(u))
 =(t+u)\bigl(a+b(t+u)+ctu\bigr),
\]
and \(M_P^2=(b^2+ac)I\).  Since \(P\notin\mathcal C\), the scalar
\(b^2+ac\) is nonzero, so \(\sigma_P\) is a nonidentity involution.
The assignment \(P\mapsto\sigma_P\) is injective because the projective
matrix recovers \((a,b,c)\).

For every \(P\in A\), the involution \(\sigma_P\) stabilizes \(E\).
To see this, take \(y\in E\).  The 46 arc secants through \(y\) form a
perfect matching, so \(Py\) contains a second arc point \(Q\).  If
\(y'\) is the other intersection of \(PQ\) with \(\mathcal C\), then
\(y'=\sigma_P(y)\).  The secant \(PQ\) gives \(r(y')\ge1\), while zero
defect on the hole gives \(r(y')\in\{0,46\}\).  Hence \(y'\in E\).

Thus
\[
 G=\operatorname{Stab}_{\operatorname{PGL}_2(K)}(E)
\]
contains the 92 distinct involutions \(\sigma_P\), \(P\in A\).

## Root-group amplification

Every nonidentity involution of \(\operatorname{PGL}_2(K)\) in
characteristic two has one fixed point on \(\mathcal C\).  For
\(\sigma_P\), it is the contact point of the unique conic tangent through
\(P\).

The 46 tangent secants of \(A\) therefore give 46 distinct points
\(t\in\mathcal C\), each supporting two distinct involutions of \(G\).
After moving \(t\) to infinity, all involutions fixing \(t\) are
translations \(x\mapsto x+\gamma\).  The two coming from the tangent pair
generate a four-group, whose third nonidentity element is another
involution fixing \(t\).  Consequently
\[
 \left|\left\{
 t\in\mathcal C:
 |G\cap U_t|\ge4
 \right\}\right|\ge46,
\]
where \(U_t\) is the characteristic-two root group fixing \(t\).

This amplification is the step missed by the earlier binary-residue and
quadratic/Arf gates: the 46 tangent pairs do not merely give a parity word;
they force 46 distinct noncyclic 2-local subgroups inside one global
conic stabilizer.

## Subgroup classification and the final contradiction

Apply the characteristic-two classification of finite \(2\)-irregular
subgroups of \(\operatorname{PGL}_2(K)\).

- A \(2\)-semi-elementary subgroup has a unique fixed point on the
  projective line, so it cannot support the displayed 46 root groups.
- A dihedral subgroup in characteristic two has Sylow 2-subgroups of order
  two, so it cannot contain even one of the displayed four-groups.
- The remaining possibility is a conjugate of
  \(\operatorname{PSL}_2(Q)=\operatorname{PGL}_2(Q)\) for a subfield
  \(\mathbf F_Q\subseteq K\).  The \(A_5\) case is the instance \(Q=4\).

For a subfield group, the fixed points of all its involutions lie on its
conjugate \(\mathbf P^1(\mathbf F_Q)\), which has \(Q+1\) points.  Hence
\[
 Q+1\ge46.
\]
With \(K=\mathbf F_{2^{12}}\), the subfield condition leaves only
\[
 Q=64\quad\text{or}\quad Q=4096.
\]

The full group at \(Q=4096\) is transitive on the 4097 conic points, so it
cannot stabilize a 91-point proper subset.  For \(Q=64\), the action on
\(\mathbf P^1(\mathbf F_{4096})\) has exactly two orbits:
\[
 \mathbf P^1(\mathbf F_{64})\quad\text{of size }65,
 \qquad
 \mathbf P^1(\mathbf F_{4096})\setminus
 \mathbf P^1(\mathbf F_{64})\quad\text{of size }4032.
\]
For completeness, an element outside the subline has degree two over
\(\mathbf F_{64}\); its stabilizer is the nonsplit torus of order 65, so
its orbit has size
\[
 \frac{|\operatorname{PGL}_2(64)|}{65}
 =64\cdot63=4032.
\]
Every invariant subset therefore has size \(0,65,4032\), or \(4097\),
never 91.  This contradicts \(|E|=91\).

## Literature boundary

The load-bearing group classification is Xander Faber, *Finite
\(p\)-Irregular Subgroups of \(\operatorname{PGL}(2,k)\)*,
arXiv:1112.1999 (2011), especially the definitions and Theorems A--B in
Section 2.  Read depth: partial, exact theorem statements and their
characteristic-two cases.  Cached key `arXiv:1112.1999`, SHA-256
`2c32c6ec0cef4f6a5d92fba5cf899e67d16c2413ccbb517df1c03be5ab3f1e00`.
The theorem gives both the list of \(2\)-irregular types and the subfield
condition used above.  The orbit calculation and the conic-involution
lemma are proved directly here.

The hyperfocused terminology is background already audited in C593 through
Giulietti--Montanucci, *On Hyperfocused Arcs in
\(\operatorname{PG}(2,q)\)*, arXiv:math/0601488.  No classification theorem
from that paper is used here.  No novelty or priority claim is made for the
polarity-stabilizer argument.

## Validation

The proof is analytic.  Its independently checkable gates are:

1. the prior exact equality data
   \(|E|=91\) and \((T,B,X)=(46,2070,2070)\);
2. the displayed determinant factorization and matrix square;
3. injectivity of \(P\mapsto[M_P]\);
4. zero-defect closure of \(E\) under every \(\sigma_P\);
5. the four-group generated by the two involutions on each tangent pair;
6. Faber's finite-subgroup classification; and
7. the \(65+4032\) orbit decomposition of the quadratic subfield action.

No finite census, heuristic search, or untracked computational artifact is
part of the theorem.

## `ej` + `tt` closeout

The cheap upgrade is the full even characteristic-two corollary: the
Ramanujan--Nagell arithmetic reduction from C593 had left only the
hyperoval scale and \((4096,92)\); the present theorem removes the latter.
This is stronger than merely classifying one matching design because it
closes the complete zero-defect equality branch relevant to the paper.

The Tao-style stress test asks where the proof genuinely uses the prescribed
conic.  It uses it twice and indispensably: to place all 92 involutions in one
\(\operatorname{PGL}_2\), and to make the same 91-point set \(E\) invariant
under all of them.  The argument therefore does not silently claim
nonrealizability of the naked star--matching design.  Conversely, it is
insensitive to the closed resolution, binary-residue, tangent-spectrum, and
quadratic/Arf gates, so it is a genuinely new global invariant rather than a
repackaging of C556, C593, or C596.

## Mystery ledger

- **The \((4096,92)\) equality candidate:** settled negatively by the
  polarity-stabilizer and subfield-orbit contradiction.
- **Even characteristic-two zero defect:** settled completely at the
  parameter level; only the hyperoval scale remains.
- **Why the local residues failed:** settled conceptually.  Two involutions
  on each tangent pair amplify to a root four-group only after all local data
  are placed in the common global conic stabilizer.
- **Naked rank-three \(\operatorname{MATCH}(92,46,1)\) realizability:** open
  and outside the theorem's scope.  No evidence gap remains for the
  prescribed-conic equality branch.
- **Manuscript integration:** not performed because C625's routed scope owns
  the research report and handoff, not a new manuscript edit.  A later
  paper-edit task may promote the compact corollary and proof.
