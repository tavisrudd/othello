# C682 — all-degree golden Weyl descent for the paired \(E_8\) towers

**Lane:** `clebsch`

**Status:** complete; explicit rational all-degree operator upgrade of the
degree-ten golden/\(E_8\) bridge.

## The all-degree operator

The degree-ten conference identity extends to an explicit Weyl operator on
the full pair of Galois-conjugate binary-icosahedral towers.

Write \(s=\sqrt5\).  The axis Klein dodecic from the preceding bridge splits
over \(\mathbf Q(s)\) as
\[
F_{\rm ax}=F_0+sF_1,
\]
where the nonzero coefficients, indexed by the exponent of \(v\), are
\[
\begin{array}{c|rrrrrrr}
j&0&2&4&6&8&10&12\\ \hline
[u^{12-j}v^j]F_0&-5&44&165&-88&165&44&-5\\
[u^{12-j}v^j]F_1&-2&22&66&-44&66&22&-2.
\end{array}
\]
For every \(n\ge0\), put
\[
\Delta_{r,n}=(\,\cdot\,,F_r)_3:
\operatorname{Sym}^n\longrightarrow\operatorname{Sym}^{n+6}
\qquad(r=0,1).
\]
Restriction of scalars from \(\mathbf Q(s)\) to \(\mathbf Q\) gives
\[
\boxed{
\widehat\Delta_n=
\begin{pmatrix}
\Delta_{0,n}&5\Delta_{1,n}\\
\Delta_{1,n}&\Delta_{0,n}
\end{pmatrix}.
}
\]
Multiplication by \(s\) is
\[
J_n=
\begin{pmatrix}
0&5I_{n+1}\\
I_{n+1}&0
\end{pmatrix},
\qquad J_n^2=5I.
\]
Direct block multiplication gives the all-degree intertwining identity
\[
\boxed{\quad
J_{n+6}\widehat\Delta_n=\widehat\Delta_nJ_n.
\quad}
\]
This is a symbolic identity for every \(n\), not a pattern inferred from
finite computation.

## Fischer adjoints and returns

The correct rational trace pairing is the Fischer pairing tensored with
\[
\begin{pmatrix}1&0\\0&5\end{pmatrix}.
\]
It makes \(J\) self-adjoint.  With respect to this pairing,
\[
\widehat\Delta_n^\dagger=
\begin{pmatrix}
\Delta_{0,n}^\dagger&5\Delta_{1,n}^\dagger\\
\Delta_{1,n}^\dagger&\Delta_{0,n}^\dagger
\end{pmatrix}.
\]
Therefore
\[
J_n\widehat\Delta_n^\dagger
=\widehat\Delta_n^\dagger J_{n+6}
\]
and
\[
\boxed{\quad
[J_n,\widehat\Delta_n^\dagger\widehat\Delta_n]=0.
\quad}
\]
The same coefficientwise restriction-of-scalars rule applies to every
polynomial Weyl expression in the transvectants and invariant
multiplications.  This is the requested finite all-degree presentation of
the paired natural-\(\mathbf2\)/natural-\(\mathbf2'\) affine-\(E_8\)
package.

The exact checker rebuilds the matrices in every degree \(0\le n\le24\)
and in degrees \(30,40,60\).  Those runs check the implementation and
matrix shapes; the unrestricted theorem is the displayed \(2\times2\)
block identity.

## Degree ten and the integral conference lattice

On the conjugate three-dimensional McKay pair in degree \(10\), \(J\) is
the \(6\times6\) companion matrix
\[
J_3=
\begin{pmatrix}
0&5I_3\\
I_3&0
\end{pmatrix}.
\]
Let \(C\) be the Clebsch six-axis conference matrix from the preceding
bridge.  Choose \(e_0,e_1,e_2\) in its standard axis lattice and put
\[
P=(e_0,e_1,e_2,Ce_0,Ce_1,Ce_2).
\]
Explicitly,
\[
P=
\begin{pmatrix}
1&0&0&0&1&1\\
0&1&0&1&0&-1\\
0&0&1&1&-1&0\\
0&0&0&1&-1&1\\
0&0&0&-1&-1&1\\
0&0&0&-1&-1&-1
\end{pmatrix}.
\]
Since \(C^2=5I\),
\[
\boxed{\quad CP=PJ_3.\quad}
\]
Moreover,
\[
\det P=4.
\]
The reduction of \(P\) modulo \(2\) has rank \(4\).  Hence its Smith
invariants are
\[
(1,1,1,1,2,2),
\]
and
\[
\boxed{\quad\operatorname{coker}P\cong(\mathbf Z/2)^2.\quad}
\]
Two quotient coordinates are
\[
x_3+x_4,\qquad x_3+x_5.
\]
They annihilate the comparison sublattice modulo \(2\), and direct
calculation gives
\[
C|_{\operatorname{coker}P}=I_2.
\]
Thus the index-four defect is two independent parity directions, not one
\(\mathbf Z/4\) direction or a residual nonsemisimple golden module.
Golden multiplication has collapsed to the scalar
\(\sqrt5=1\) on the quotient.

Thus the universal paired-tower companion and the Clebsch conference
operator are conjugate over \(\mathbf Z[1/2]\), and the displayed comparison
embeds an index-four companion sublattice in the signed-axis lattice.

They are not conjugate by \(\operatorname{GL}_6(\mathbf Z)\).  Modulo \(2\),
\[
\operatorname{rank}(C-I)=1,\qquad
\operatorname{rank}(J_3-I)=3.
\]
The different Jordan ranks forbid integral conjugacy.  This turns the
previous conductor-at-\(2\) comparison into an explicit lattice theorem:
the rational all-degree golden descent specializes to the Clebsch operator,
but its naive free companion lattice misses the natural six-axis lattice by
index \(4\).

Prime \(5\) behaves differently.  There \(C\) and \(J_3\) both have rank
\(3\) and square zero, while \(P\) remains invertible.  Thus \(5\) is the
ramification prime of the golden quadratic algebra itself; only \(2\) is a
defect of the comparison lattice.

## Interpretation

The complete bridge is now
\[
\begin{array}{c}
\text{paired natural-}\mathbf2/\mathbf2'\text{ Klein towers}\\
\downarrow\ \text{restriction of scalars}\\
(\widehat\Delta,J),\quad J^2=5,\quad[J,\widehat\Delta^\dagger\widehat\Delta]=0\\
\downarrow\ \text{degree }10\\
C^2=5I\\
\downarrow\ c_{ijk}=C_{ij}C_{jk}C_{ki}\\
\text{Clebsch orientation cubic}.
\end{array}
\]
The \(E_8\) connection is therefore functorial across every degree.  Degree
\(10\) is special only because it is the first balanced slice on which the
descended golden operator is visible as the six-axis conference matrix.

## Mystery ledger

- **Does the degree-ten bridge extend to all degrees?** Settled.  The
  restriction-of-scalars block formula gives a single Weyl presentation for
  every \(n\).
- **Does the Fischer adjoint survive descent?** Settled.  The trace form
  \(\operatorname{diag}(1,5)\) makes \(J\) self-adjoint and preserves the
  golden block shape.
- **Is the degree-ten identification merely rational?** Settled sharply.
  The explicit comparison matrix has determinant \(4\); it is integral but
  not unimodular.
- **Why must prime \(2\) remain exceptional?** Settled at the lattice level.
  The ranks of \(C-I\) and \(J_3-I\) modulo \(2\) are \(1\) and \(3\), so
  no integral change of basis can remove the defect.
- **Why is the comparison index exactly \(4\), rather than only a power of
  \(2\)?** Settled arithmetically: \(P\) has mod-\(2\) nullity \(2\), so
  together with \(\det P=4\) its Smith quotient is exactly
  \((\mathbf Z/2)^2\).  The quotient coordinates are two axis-parity
  differences, and \(C\) acts trivially on them.
- **Does prime \(5\) create another lattice mismatch?** Settled negatively.
  The comparison is invertible modulo \(5\); both golden operators simply
  specialize to the same rank-three square-zero endomorphism.
- **Are the local Gram returns a standard preprojective/spherical
  affine-\(E_8\) corner presentation?** Still open and independent of the
  golden descent.  The present result supplies the missing Galois/Weyl
  operator, not that categorical identification.

## Reproduction and trust boundary

From `/home/tavis/src/othello`, run

```bash
python notes/2026-07-30-c682-golden-e8-weyl-descent.py --write
python notes/2026-07-30-c682-golden-e8-weyl-descent-replay.py
```

The recorded run used Python 3.13.12 and only the standard library.  The
primary checker pins and loads:

- `2026-07-28-c682-klein-e8-operator-algebra.py`, the exact rational
  transvectant/Fischer implementation; and
- `2026-07-30-c682-golden-e8-descent.json`, the frozen degree-ten conference
  certificate.

It reconstructs \(F_0,F_1\), all selected exact Weyl matrices, weighted
adjoints, return commutators, the integral comparison matrix, determinant,
and mod-\(2\) ranks.  The replay independently rebuilds representative
degrees and the lattice comparison without importing the new primary
checker.  The unrestricted all-degree claim rests on the displayed formal
block multiplication, while the finite runs check its implementation.

`2026-07-30-c682-golden-e8-weyl-descent.sha256` records hashes and byte
counts for this evidence bundle.
