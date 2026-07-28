# C682 graded gauge to the standard \(E_8\) three-node factorization

## Verdict

The principal \(3\)-by-\(3\) blocks selected by the primitive third Klein
transvectant are explicitly graded-gauge equivalent to the unprimed
three-node factorization in Curto--Morrison's \(E_8\) table.

Write
\[
g(Y,Z)=Y^3+Z^5,\qquad
Y=-\frac h{12},\qquad Z=F.
\]
Then
\[
g\left(-\frac h{12},F\right)
=\frac{1728F^5-h^3}{1728}
=\frac{t^2}{1728}.
\]
Thus the comparison is rational: it needs no root of \(1728\).

Let \(A,B\) be C682's left-to-right and right-to-left principal multiplier
matrices.  Let
\[
J=\begin{pmatrix}0&0&1\\0&1&0\\1&0&0\end{pmatrix},\qquad
L=\operatorname{diag}(1,-10,-2),\qquad
R=\operatorname{diag}\left(-\frac1{120},-\frac1{240},\frac1{240}\right).
\]
For the unprimed matrices \(\phi_3,\psi_3\) on page 26 of
Curto--Morrison, evaluated at \(Y=-h/12,\ Z=F\), exact multiplication gives
\[
LJAJR=\psi_3,
\qquad
R^{-1}JBJL^{-1}=-172800\,\phi_3.
\]
Equivalently, with
\[
P=LJ,\qquad Q=R^{-1}J,
\]
one has
\[
PAQ^{-1}=\psi_3,\qquad
Q\left(\frac{B}{172800}\right)P^{-1}=-\phi_3.
\]
Since the table's sign convention is
\[
\phi_3\psi_3=\psi_3\phi_3=-gI_3,
\]
the pair \((A,B/172800)\) is gauge equivalent to the sign-corrected standard
factorization \((\psi_3,-\phi_3)\) of \(g\).  Without normalizing the
potential, \((A,B)\) is gauge equivalent to the base-changed,
unit-rescaled standard pair
\[
(\psi_3,-172800\phi_3)
\]
of
\[
172800g=100t^2.
\]

This closes the explicit-equivalence gate left open by the quick literature
audit.  It does not close the source-deep priority audit for invariant
differential operators.

## The two matrices

C682's matrices are
\[
A=
\begin{pmatrix}
-10h&120F&0\\
0&2h&12F\\
240F^3&0&10h
\end{pmatrix},
\quad
B=
\begin{pmatrix}
10h^2&-600Fh&720F^2\\
1440F^4&-50h^2&60Fh\\
-240F^3h&14400F^4&-10h^2
\end{pmatrix}.
\]
They satisfy
\[
AB=BA=100(1728F^5-h^3)I_3=172800gI_3.
\]

The standard unprimed three-node pair is
\[
\phi_3=
\begin{pmatrix}
-Y^2&-Z^4&-YZ^3\\
-YZ&Y^2&-Z^4\\
-Z^2&YZ&Y^2
\end{pmatrix},
\qquad
\psi_3=
\begin{pmatrix}
Y&0&Z^3\\
Z&-Y&0\\
0&Z&-Y
\end{pmatrix}.
\]
The anti-identity \(J\) first reverses both C682 bases.  The remaining
comparison is diagonal.  The six nonzero entries of \(JAJ\) give the six
scalar equations solved by \(L\) and \(R\); their bipartite support is a
connected six-cycle, so this diagonal gauge is unique up to the expected
common basis scalar.

The transformed reverse block is then forced by the factorization identity,
but the certificate also checks all nine entries directly:
\[
R^{-1}JBJL^{-1}
=-172800\,
\phi_3\left(-\frac h{12},F\right).
\]

## Grading

Give \(F,h\) weights \(12,20\).  In C682's order, the two free-module bases
have degrees
\[
E=(2,10,18),\qquad O=(12,20,28).
\]
Both \(A:E\to O\) and \(B:O\to E\) are homogeneous of degree \(30\), and the
potential has degree \(60\).

After applying \(J\), the standard basis degrees are
\[
E_{\mathrm{std}}=(18,10,2),\qquad
O_{\mathrm{std}}=(28,20,12).
\]
Every nonzero entry of \(\psi_3:E_{\mathrm{std}}\to O_{\mathrm{std}}\) and
\(\phi_3:O_{\mathrm{std}}\to E_{\mathrm{std}}\) again has map degree \(30\).
The diagonal matrices \(L,R\) have degree zero.  The displayed equivalence is
therefore graded, not merely an ungraded similarity.

The degree lists also identify the factorization with the unprimed
three-node in the table.  No interchange with the second \(3''\)-node is
being hidden by an abstract McKay correspondence.

## Arithmetic consequence

Every denominator in the base change and gauge is supported on
\(\{2,3,5\}\).  Hence the equivalence is defined over
\[
\mathbf Z[1/30][F,h].
\]
In particular it survives reduction modulo \(11\); indeed
\[
12\equiv1,\qquad172800\equiv1\pmod {11}.
\]
Thus the factorization-level comparison itself has no prime-\(11\)
obstruction.  The still-open mod-\(11\) issue belongs to the primitive
operator and the base change of the six-generator covariant lattice, not to
the finite matrix factorization.

No assertion is made at \(2,3,5\), where this gauge is not invertible.

## Proof and evidence

The proof is the displayed matrix multiplication plus the grading check.
The exact standard-library certificate:

1. reconstructs \(A,B,\phi_3,\psi_3\) over \(\mathbf Q[F,h]\);
2. checks the rational base change and both potential identities;
3. checks the two compatible gauge identities entry by entry; and
4. audits all thirty nonzero entries for weighted homogeneity.

An independently written replay evaluates the four matrix identities at all
\[
101^2+103^2=20810
\]
points over \(\mathbf F_{101}\) and \(\mathbf F_{103}\).

From `rust/`, run

```text
python3 ../notes/2026-07-28-c682-klein-e8-graded-gauge.py --check
python3 ../notes/2026-07-28-c682-klein-e8-graded-gauge-replay.py
(cd ../notes && sha256sum -c 2026-07-28-c682-klein-e8-graded-gauge.sha256)
```

The standard matrices were transcribed from Carina Curto and David R.
Morrison, *Threefold Flops via Matrix Factorization*, Appendix, page 26,
cached as `arXiv:math/0611014`; the checked PDF SHA-256 is
`83ff3bb97c3523f649a390f7391ec6e8df977846067453ddbf018196a5c05425`.
The source is read here only for the displayed table and its
\(g(Y,Z)=Y^3+Z^5\) convention.  Historical priority remains attributed
through their account to Gonzalez-Sprinberg--Verdier.

The adjacent canonical JSON records every matrix, grading, base change, and
gauge entry.  The byte counts are \(10483\) for the generator, \(3315\) for
the independent replay, and \(7849\) for the JSON certificate.  The checksum
manifest records hashes for those three files and this report.

## `ej` + `tt` closeout

The cheap structural upgrade is that the rational comparison is already
defined over \(\mathbf Z[1/30]\).  The prime \(11\) in the primitive
transvectant content \(132=12\cdot11\) is therefore not an \(E_8\)
factorization obstruction.  This cleanly separates two arithmetic layers
that the previous report left entangled.

The `tt` upgrade is uniqueness at the sparse-symbol level.  Reversal is
forced by the unique cubic \(F^3\) entry, and the connected six-cycle support
then determines the diagonal gauge up to one scalar.  The transvectant has
not merely landed somewhere in the classical isomorphism class: its sparse
principal symbol selects the tabulated gauge essentially uniquely.

The highest-value next move is now the source-deep invariant-differential
operator audit, paired with the mod-\(11\) divided-power comparison to C651.
The former determines novelty; the latter tests whether the factorization
gauge actually controls the finite matching cubic.

## Mystery ledger

- **Settled:** the C682 blocks are the unprimed standard \(E_8\) three-node,
  after the rational base change \(Y=-h/12,\ Z=F\).
- **Settled:** the exact compatible gauges are
  \(P=LJ\) and \(Q=R^{-1}J\).
- **Settled:** the comparison is graded of map degree \(30\) and is defined
  over \(\mathbf Z[1/30]\).
- **Settled:** the factorization gauge survives modulo \(11\); prime \(11\)
  enters only at the operator/lattice layer.
- **Settled:** within the forced support reversal, the diagonal gauge is
  unique up to common scalar.
- **Open:** whether the full third-transvectant Weyl operator is already
  present in the invariant-differential-operator literature.
- **Open arithmetically:** whether a divided-power model of the full operator,
  not only its principal factorization, recovers C651's mod-\(11\) map.
- **Open uniformly:** whether the other eight McKay blocks carry the same
  scalar cotangent cubic and their corresponding standard \(E_8\)
  factorizations.

C682 remains open; the user retains stopping authority.
