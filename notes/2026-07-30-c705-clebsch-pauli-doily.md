# C705 — Clebsch orientation and the two-qubit Pauli doily

**Date:** 2026-07-30

**Lane:** `clebsch`

**Status:** exact incidence dictionary and sign comparison complete; ordinary
contextuality-cocycle crown is negative, with an equivariant-lift successor.

## Outcome

There is an exact \(S_6\)-equivariant identification of the C705
\(15/10/6\) configuration with the two-qubit Pauli doily:

\[
\begin{array}{c|c}
\text{Clebsch--Segre--Igusa object}&\text{Pauli-doily object}\\ \hline
15\text{ duads}&15\text{ nonidentity Pauli observables}\\
15\text{ synthemes / Segre planes / Igusa lines}
 &15\text{ maximal commuting contexts}\\
10\text{ complementary }3+3\text{ partitions / Segre nodes}
 &10\text{ Mermin grids}\\
6\text{ axes / odd theta characteristics}
 &6\text{ ovoids}.
\end{array}
\]

The sign comparison is positive at the level of the standard Mermin
obstruction but negative as a Clebsch-specific invariant.  Every one of the
ten grids has product \(-1\) for both the Pauli context signs and the
Pfaffian/Clebsch context signs.  However, the two line-sign systems differ
by rephasing the fifteen point observables.  More sharply, the conference
factor in the Clebsch sign is itself exactly such a point rephasing.
Therefore the ordinary contextuality class sees the Pfaffian/symplectic
extension, not the special golden conference operator \(C\) or
\(K=*\Lambda^3C\).

This is a useful negative: the \(15/10/6\) quantum dictionary is real, but a
claim that the Clebsch orientation creates a new Mermin cocycle is false.
The nearest surviving question is equivariant.  Although the Clebsch
cochain is gauge-trivial after forgetting symmetry, it may define a
nontrivial \(S_6\)- or Clifford-equivariant lift, central extension, or
distinguished \(A_5\) phase convention.  C706 owns that sharper gate.

## Explicit dictionary

Write a vector of \(\mathbf F_2^4\) as \((x,z)\), with symplectic form
\[
 B((x,z),(y,t))=x\mathbin{\cdot}t+z\mathbin{\cdot}y.
\]
The six odd genus-two theta characteristics are the pairs
\((a_i,b_i)\in\mathbf F_2^2\times\mathbf F_2^2\) satisfying
\(a_i\cdot b_i=1\).  Label them lexicographically.  The duad
\(\{i,j\}\) maps to
\[
 v_{ij}=(b_i+b_j,\ a_i+a_j),
\]
because the difference of the two quadratic refinements is
\(B(v_{ij},-)\).  The fifteen duads map bijectively to the fifteen nonzero
vectors.

Two duads are disjoint exactly when their vectors are symplectically
orthogonal.  Hence a syntheme
\[
 \{\{i,j\},\{k,l\},\{m,n\}\}
\]
maps to the three nonzero vectors of a maximal isotropic plane, or
equivalently a maximal commuting Pauli context.  Exhausting all \(720\)
permutations of the six odd characteristics produces \(720\) distinct
symplectic maps, giving the concrete isomorphism
\[
 S_6\cong\operatorname{Sp}_4(\mathbf F_2).
\]

For an unordered partition \(Q\sqcup Q^c\) with \(|Q|=3\), the nine crossing
duads are the points of a grid and its six crossing synthemes are its
contexts.  This gives the ten Mermin grids.  For each \(i\), the five duads
containing \(i\) are pairwise nonorthogonal and form an ovoid.  This gives
the six ovoids.

## Exact sign theorem

Use the Hermitian Pauli section
\[
 P(x,z)=i^{x\cdot z}X^xZ^z.
\]
For a syntheme \(M\), let \(\mu(M)\in\{\pm1\}\) be defined by
\[
 \prod_{\{i,j\}\in M}P(v_{ij})=\mu(M)I.
\]
Let \(\epsilon(M)\) be the Pfaffian sign of the ordered matching, and define
the Clebsch sign
\[
 \lambda_C(M)=\epsilon(M)\prod_{\{i,j\}\in M}C_{ij}.
\]
The exact calculation gives a point-sign function
\(\eta:\binom{[6]}2\to\{\pm1\}\) such that
\[
 \lambda_C(M)=\mu(M)\prod_{\{i,j\}\in M}\eta_{ij}
\]
for all fifteen contexts.  The binary point-line incidence matrix has rank
\(10\), and the certificate records one explicit solution \(\eta\).

For every \(3+3\) partition, each of its nine points occurs twice among its
six contexts.  Point rephasings therefore cancel, and
\[
 \prod_{M\text{ in the grid}}\lambda_C(M)
 =
 \prod_{M\text{ in the grid}}\mu(M)
 =
 \prod_{M\text{ in the grid}}\epsilon(M)
 =-1.
\]
The last equality is checked for all ten grids and also follows directly
from the six Pfaffian signs of the perfect matchings of \(K_{3,3}\).

## Why the Clebsch contribution disappears

The conference factor has the form
\[
 \lambda_C(M)/\epsilon(M)=\prod_{\{i,j\}\in M}C_{ij}.
\]
It is therefore literally the point rephasing
\(P(v_{ij})\mapsto C_{ij}P(v_{ij})\).  Switching the six representatives,
\(C_{ij}\mapsto s_iC_{ij}s_j\), multiplies every context sign by the same
factor \(\prod_i s_i\), which is again gauge-trivial.

The same issue appears one level up.  The diagonal of C704's operator is
\[
 K_{SS}/4=C_{ij}C_{jk}C_{ki}
\qquad(S=\{i,j,k\}).
\]
Thus its twenty triangle signs are the coboundary of the edge cochain
\((C_{ij})\) on the complete \(5\)-simplex.  The phases of the corresponding
three pairwise anticommuting Pauli observables are also a triangle
coboundary: their product around every tetrahedron is \(+1\).  Ordinary
cohomology consequently cannot distinguish them.

The negative is exact only for unrestricted point gauge.  It does not
settle whether an equivariant gauge exists, whether the signed outer action
lifts to the two-qubit Clifford group with the same central extension, or
whether the \(A_5\) stabilizer of \(C\) selects a distinguished metaplectic
phase.  Those are the falsifiers in C706.

## Literature boundary

No novelty or priority verdict is made.  Zero sources were read at full
text for this bounded positioning pass.

- Planat--Saniga, *On the Pauli graphs of N-qudits*,
  arXiv:quant-ph/0701211 — `abstract/metadata only`, arXiv abstract retrieved
  on 2026-07-30.  It identifies the two-qubit Pauli graph with the generalized
  quadrangle of order two and its grids and ovoids with Mermin squares and
  five mutually noncommuting observables.
- Okay--Chung--Ipek, *Mermin polytopes in quantum computation and
  foundations*, arXiv:2210.10186 — `abstract/metadata only`, arXiv abstract
  retrieved on 2026-07-30.  It treats context-sign functions up to the
  parity distinction in the Mermin scenario.
- Muller--Saniga--Giorgetti--De Boutray--Holweck, *Multi-qubit doilies:
  enumeration for all ranks and classification for ranks four and five*,
  arXiv:2206.03599 — `abstract/metadata only`, arXiv abstract retrieved on
  2026-07-30.  It confirms the established use of signed doilies in
  operator contextuality.

Four metadata searches screened titles and abstracts for
`two-qubit Pauli doily duads synthemes Mermin grids ovoids S6 Sp(4,2)`,
`conference matrix Mermin square contextuality Pfaffian signs`,
`Clebsch cubic Pauli contextuality doily`, and
`Clebsch conference matrix contextuality`.  They located the standard
doily/contextuality literature but no visible Clebsch, conference-matrix,
or compound-operator comparison.  This is not a full-text absence audit;
zbMATH, MathSciNet, citation graphs, and the full texts of the three sources
remain uncovered.

## Reproducibility

Primary exact generator:

```sh
cd /home/tavis/src/othello
python3 notes/2026-07-30-c705-clebsch-pauli-doily.py --check
```

Independent direct \(4\times4\) matrix replay:

```sh
cd /home/tavis/src/othello
python3 notes/2026-07-30-c705-clebsch-pauli-doily-replay.py
```

The primary generator uses only the Python standard library.  It checks the
complete \(15\)-point/\(15\)-context incidence dictionary, all \(720\)
induced symplectic maps, all ten grids, all six ovoids, both fifteen-entry
context-sign vectors, one exact gauge solution, all twenty triangle phases,
all fifteen tetrahedron relations, and all \(2^6\) conference switchings.
The replay independently multiplies explicit \(4\times4\) complex Pauli
matrices and rechecks the ten grid parities and conference rephasing
identity.  It does not test the still-open equivariant Clifford lift.

Hashes and byte counts are recorded in
`notes/2026-07-30-c705-clebsch-pauli-doily.sha256`.
