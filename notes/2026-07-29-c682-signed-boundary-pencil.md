# C682 signed symmetrizable boundary pencil

Date: 2026-07-29

## Theorem

Let
\[
W(q)=\frac{N(q)}{D(q)}
\]
be the reduced trivial-module boundary witness from the plateau-entry
calculation, with \(\deg N=15\), \(\deg D=3\), and
\[
D(q)=\frac12(10q+17)(10q+22)(10q+27).
\]
Write \(\operatorname{Bez}(P,Q)\) for the coefficient matrix of
\[
\frac{P(x)Q(y)-P(y)Q(x)}{x-y}
\]
in the monomial basis, and let \(C_P\) be multiplication by \(x\) in
\(\mathbf Q[x]/(P)\).

The boundary denominator canonically symmetrizes the numerator companion:
\[
B_D=\operatorname{Bez}(N,D),\qquad
B_DC_N^{\mathsf T}=C_NB_D.
\]
Equivalently,
\[
\boxed{\quad
\mathcal L_D(s)=sB_D-C_NB_D
\quad}
\]
is a symmetric rational matrix pencil.  It is regular because
\(\gcd(N,D)=1\), and
\[
\frac{\det\mathcal L_D(s)}{\det B_D}
 =\det(sI-C_N)
 =\frac{N(s)}{\operatorname{lc}(N)}.
\]
Exact congruence reduction gives
\[
\operatorname{In}(B_D)=(8,7,0).
\]
Thus the boundary transfer is intrinsically signed: the indefinite
signature is not an artifact of partial fractions or floating-point root
plots.  It is the basis-independent signature of the Bezout form attached
to the reduced boundary pair \((N,D)\).

## Intrinsic Sturm count

For either \(P=N\) or \(P=D\), put
\[
H_P=\operatorname{Bez}(P,P'),\qquad
\mathcal H_P(s)=sH_P-C_PH_P.
\]
The exact forms have inertias
\[
\operatorname{In}(H_N)=(15,0,0),\qquad
\operatorname{In}(H_D)=(3,0,0).
\]
This proves, by the Hermite--Bezout criterion, that both reduced
polynomials are squarefree and totally real.  Since \(C_P\) is
self-adjoint for the positive form \(H_P\), the spectral theorem gives the
counting rule
\[
\#\{\rho:P(\rho)=0,\ a<\rho<b\}
 =
n_+\!\left(\mathcal H_P(b)\right)
 -
n_+\!\left(\mathcal H_P(a)\right).
\]
This is an inertia calculation on the canonical companion pencil; it does
not use the previously recorded polynomial remainder Sturm chain.

For the numerator, exact rational \(LDL^{\mathsf T}\) congruence gives
\[
\begin{array}{c|ccccc}
s&-3&-2&-1&0&1\\ \hline
\operatorname{In}\mathcal H_N(s)
 &(0,15,0)&(1,14,0)&(14,1,0)&(14,1,0)&(15,0,0).
\end{array}
\]
Therefore the four consecutive chamber counts are
\[
\boxed{1,\ 13,\ 0,\ 1}.
\]
Suppressing the empty chamber \((-1,0)\) recovers the earlier
\(1|13|1\) distribution in
\((-3,-2),(-2,-1),(0,1)\).

For the denominator,
\[
\begin{array}{c|ccccc}
s&-3&-2&-1&0&1\\ \hline
\operatorname{In}\mathcal H_D(s)
 &(0,3,0)&(2,1,0)&(3,0,0)&(3,0,0)&(3,0,0),
\end{array}
\]
so the corresponding pole counts are
\[
\boxed{2,\ 1,\ 0,\ 0}.
\]
In particular, the chamber counts and the sharp wall are now consequences
of signatures.  At \(s=0\), the numerator pencil has positive index \(14\);
at \(s=1\), it has positive index \(15\).  Hence exactly one zero lies in
\((0,1)\), while all fifteen lie below \(1\).  The real nonvanishing ray
\(q\ge1\) is sharp.

## What the construction explains

The earlier residue signs \(-,+,-\) ruled out a positive scalar Weyl
interpretation.  The Bezout construction identifies the replacement
without fitting an orthogonal-polynomial family: the same numerator
companion has

- an indefinite boundary symmetrizer
  \(\operatorname{Bez}(N,D)\) of signature \(8+7\), encoding the signed
  transfer; and
- a positive Hermite symmetrizer
  \(\operatorname{Bez}(N,N')\), whose spectral flow counts the walls.

Both are canonical covariants of the reduced scalar boundary data.  A
change of polynomial basis acts by congruence and leaves every stated
signature unchanged.  This is the intrinsic content missing from the
coefficient-sign and scalar Sturm proofs.

The construction is deliberately scalar.  It does not yet produce the
block Bezout or block-Jacobi pencils required for the \(2,3,3'\) Kostant
modules.

## Reproducibility

The atomic evidence bundle is:

- `2026-07-29-c682-signed-boundary-pencil.py`;
- `2026-07-29-c682-signed-boundary-pencil.json`;
- `2026-07-29-c682-signed-boundary-pencil-replay.py`.

From `rust/`, run

```text
python3 ../notes/2026-07-29-c682-signed-boundary-pencil.py --check
python3 ../notes/2026-07-29-c682-signed-boundary-pencil-replay.py
```

The primary checker reconstructs the two Bezout symmetrizers from the
tracked reduced numerator and denominator, verifies exact symmetry and
coprimality, and computes all inertias by pivoted rational congruence.  The
replay constructs the Bezout matrices from the coefficient recurrence
\(A_{i+1,j}=B_{i,j}-B_{i+1,j-1}\) and obtains the endpoint inertias by an
independent unpivoted exact \(LDL^{\mathsf T}\) elimination; it also
replays the \(8+7\) boundary signature.  The existing scalar Sturm
certificate remains a third, polynomial-remainder cross-check.

The load-bearing input is
`2026-07-29-c682-plateau-controllability.json`, 5327 bytes, SHA-256
`59c395f29b20ede03b389f99e85b6933dafe4da923eaa091f4a0f81c0188e540`.

| file | bytes | SHA-256 |
|---|---:|---|
| `2026-07-29-c682-signed-boundary-pencil.py` | 10588 | `edf94547da2f1d340648fb4375b8b5beab280599fec6f6d9f1df56a578e26471` |
| `2026-07-29-c682-signed-boundary-pencil.json` | 3042 | `65e43dde0fe4f0e86c5ecebd1f34481860836d114abf70c7ace587e1af71d6f8` |
| `2026-07-29-c682-signed-boundary-pencil-replay.py` | 5125 | `234f5394de6190817cfb6f7f1719186b185a98b3416a4bc4690e622c9f6db162` |

## `ej` + `tt` closeout

The cheap upgrade is stronger than a Jacobi fit.  No choice of approximate
roots, weights, or named orthogonal-polynomial family is needed: Bezout
functoriality manufactures both relevant symmetrizers directly from
\((N,D)\).

The signed form and the Sturm form should not be conflated.
\(\operatorname{Bez}(N,D)\) explains why the boundary transfer is
indefinite, whereas \(\operatorname{Bez}(N,N')\) is positive and counts
zeros.  Trying to extract unsigned chamber counts from the signed form
alone computes a Cauchy index and loses pairs of oppositely oriented
crossings.  The two-form package is therefore essential, not redundant.

The module-uniform target is now sharper.  For \(2,3,3'\), first construct
the matrix-valued reduced boundary pair and its block Bezout symmetrizer;
then seek a positive block Hermite form.  Positivity would simultaneously
prove total reality of the controlling determinant and turn every
nonvanishing chamber into a finite inertia table.

## Mystery ledger

- **Settled:** the scalar boundary witness has a canonical signed
  symmetrizable pencil.
- **Settled:** its signed metric has exact inertia \((8,7,0)\), explaining
  intrinsically why a positive Weyl model is impossible.
- **Settled:** the numerator and denominator chamber counts follow from
  exact Hermite-pencil inertia, independently of the earlier scalar Sturm
  remainder chain.
- **Settled:** the missing chamber \((-1,0)\) contains no numerator zero or
  denominator pole; the full consecutive distributions are
  \(1|13|0|1\) and \(2|1|0|0\).
- **Settled by `ej`:** one companion operator carries both the indefinite
  boundary form and the positive Sturm form.
- **Settled by `tt`:** the signed form alone gives oriented Cauchy data,
  not unsigned root counts; the positive Hermite form is the necessary
  second half of the intrinsic construction.
- **Still open:** construct and prove positivity/nondegeneracy of the
  corresponding block forms for the \(2,3,3'\) modules.

No all-module controllability or all-weight full-corner theorem is claimed.
