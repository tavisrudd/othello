# C538 — universal R9 slice and rational-base proof

**Lane:** `reed-solomon` · **Date:** 2026-07-23 · **Status:** proved

## Result

The characteristic-seven binary-quartic carrier in redundancy nine has a
geometrically integral residual-quadratic slice for every nonzero geometric
quartic.  Over a finite field, every rational carrier quartic has a rational
four-root base once \(q>102\); the first relevant characteristic-seven field
is \(q=343\).  Together with the separate \(q=7\) and \(q=49\) closures, this
removes the R9 slice/base-selection gate.

The proof is not six unrelated calculations.  It constructs one universal
good-base open, proves that its projection onto quartic moduli is
surjective, and interprets the finite polynomial identity as a principal-
open cover of the one-dimensional squarefree atlas.

An adversarial audit also found and corrected a deletion-degree error in
the earlier report: divisors on the moving-root line must be pulled back to
the residual double cover.  The safe point-deletion total is \(32\), not
\(22\).  This does not change the theorem range.

## 1. Universal residual cover

Let
\[
 \mathcal H=\mathbf P(\operatorname{Sym}^4E),\qquad
 \mathcal B=\operatorname{Conf}_4(\mathbf P^1).
\]
For \(h=(a_0,\ldots,a_4)\) and an ordered base
\(\mathbf r=(r_1,\ldots,r_4)\), put
\[
 R_{\mathbf r}(t)=\prod_i(t-r_i),\qquad
 P_{\mathbf r,x}(t)=R_{\mathbf r}(t)(t-x).
\]
The two consecutive Hankel equations for a residual quadratic
\(t^2-st+u\) have determinant and Cramer numerators
\[
 D=H_0H_2-H_1^2,\quad
 N_s=H_{-1}H_2-H_0H_1,\quad
 N_u=H_{-1}H_1-H_0^2.
\]
Their branch covariant is
\[
 K_{h,\mathbf r}(x)=N_s^2-4DN_u.
\]
Thus \(\mathcal H\times\mathcal B\) carries the universal residual double
cover
\[
 y^2=K_{h,\mathbf r}(x).
\]
After square factors are removed, \(K\) has degree at most four in \(x\);
a nonconstant separable squarefree part therefore gives a geometrically
integral normalization of genus at most one.

Define \(\mathcal U\subset\mathcal H\times\mathcal B\) to be the locus
where this happens.  Subdiscriminants of \(K\) show that \(\mathcal U\) is
open.  The whole geometric problem is now the transparent projection
statement
\[
 \mathcal U\longrightarrow\mathcal H
\quad\text{is surjective away from }0.                    \tag{1}
\]
This formulation also exposes why one successful specialization is
insufficient: it proves only that \(\mathcal U\) is nonempty, not that every
quartic fiber meets it.

## 2. Why the test sections cover quartic moduli

The geometric quotient of nonzero binary quartics has one
one-dimensional squarefree stratum.  The standard even normal-form atlas is
\[
 h_L=[1,0,L,0,1].
\]
It is many-to-one under the residual anharmonic action, so an individual
base choice need not descend to coarse moduli.  This causes no ambiguity:
the diagonal \(\operatorname{PGL}_2\) action transports \(h_L\) and its
four-point base together.

Restrict the universal base family to the six fixed four-point test
sections recorded in `papers/beyond4_prs/supplement/R9-SLICE-DATA.md`.
Let \(\Delta_i(L)\) be the discriminant of the resulting branch quartic.
The exact identity
\[
 \sum_{i=1}^6 b_i(L)\Delta_i(L)=1
 \quad\text{in }\mathbf F_7[L]                            \tag{2}
\]
says precisely that the principal opens \(D(\Delta_i)\) cover the
normal-form line.  It is an open-cover certificate, not six sampled
values.  The printed witness in fact uses only
\(\Delta_1,\Delta_2,\Delta_6\); the other three are independent regression
controls.

The boundary has root partitions
\[
 4,\quad3+1,\quad2+2,\quad2+1+1.
\]
There are at most three distinct support points, so triple transitivity of
\(\operatorname{PGL}_2\) leaves one geometric orbit per partition.  The
four representatives have reduced branch discriminants
\[
 3,\quad3,\quad1,\quad5
\]
in \(\mathbf F_7\).  Hence every boundary orbit also meets
\(\mathcal U\).  This proves (1) and explains why the normal forms are
exhaustive.

## 3. Rational base selection as divisor avoidance

Fix \(h\in\mathcal H(\mathbf F_q)\).  Over
\(\mathbf F_q(\mathbf r)\), let \(d(h)\ge1\) be the number of distinct
roots of the generic \(K_{h,\mathbf r}\).  Define \(B_h(\mathbf r)\) to be
the \(d(h)\)-th subdiscriminant of \(K\), equivalently the corresponding
nonzero principal minor of its Hermite matrix.

This definition is deliberately direct.  It does not form a gcd over a
rational-function field and then refer vaguely to the numerator of the
discriminant of a quotient.  At a specialization,
\[
 B_h(\mathbf r)\ne0
\]
guarantees a nonconstant separable squarefree part.  Geometric
surjectivity proves that \(B_h\) is not the zero polynomial.

Each coefficient of \(P_{\mathbf r,x}\) is affine in \(x\), has individual
\(r_i\)-degree at most one, and total \(\mathbf r\)-degree at most four.
Consequently \(K\) has individual degree at most four and total degree at
most sixteen in the base roots.  A quartic subdiscriminant is a Hermite
minor of coefficient-degree at most six, so
\[
 \deg_{r_i}B_h\le24,\qquad \deg B_h\le96.                  \tag{3}
\]
Multiplication by the Vandermonde
\(\prod_{i<j}(r_i-r_j)\) adds total degree six.  The resulting nonzero
polynomial has total degree at most \(102\), and finite-field polynomial
avoidance produces a distinct rational ordered base whenever \(q>102\).

## 4. Correct deletion count on the normalization

The earlier total \(22\) mixed degrees on the moving-root line with point
degrees on its residual double cover.  The correct safe pullback table is
\[
\begin{array}{c|c}
\text{deleted locus}&\text{points on the normalization}\\\hline
x\text{ equals a fixed root}&8\\
D(x)=0&4\\
K(x)=0&4\\
\text{residual root equals one of four fixed roots}&8\\
\text{residual root equals }x&8.
\end{array}
\]
The branch divisor \(K=0\) is ramified and does not double; the other
moving-line divisors do.  Thus the safe total is \(32\), and
\[
 q+1-2\sqrt q>32
\]
already holds from integer \(q=45\).  The rational-base condition
\(q>102\) dominates, so no theorem threshold changes.

## 5. Evidence and trust boundary

The exact replay commands from the repository root are:

```text
python3 notes/2026-07-23-c516-prs-redundancy-nine.py \
  --output notes/2026-07-23-c516-prs-redundancy-nine.json --check
python3 notes/2026-07-23-c516-prs-redundancy-nine-replay.py
(cd notes && sha256sum -c 2026-07-23-c516-prs-redundancy-nine.sha256)
cd papers/beyond4_prs && make check
```

The generator and independent replay certify the six discriminant
polynomials, their Bézout identity, the multiple-root reduced branches,
the corrected deletion table, and the numerical degree/field bounds.  The
geometric meaning of the open cover, diagonal transport, boundary-orbit
exhaustion, and Hermite-subdiscriminant selection is the mathematical proof
in the manuscript and this report; it is not delegated to the certificate.

## Extra-juice and Tao closeout

The strongest conceptual upgrade is that the six-slice computation is
really a finite trivialization of a universal good-base open.  The data
show more than requested: three test sections already cover the squarefree
atlas.  This suggests that future residual-degree problems should search
for a small generating family of subdiscriminant sections, not enumerate
base configurations.

The Tao-style defect search found the point/base-degree confusion that
changed \(22\) to \(32\), and it replaced a noncanonical “discriminant
after gcd” with a canonical Hermite subdiscriminant.  Both repairs make the
proof more invariant and more robust in degenerating families.

No cheap reduction of the rational-base threshold follows from the present
argument.  The \(102\) bound is governed by a coarse total-degree estimate;
improving it requires multidegree or symmetry information for \(B_h\), not
another finite slice table.

## Mystery ledger

- **Settled:** the six slices are test sections whose principal opens cover
  the normal-form atlas; they are not six unexplained experiments.
- **Settled:** the four multiple-root rows exhaust the boundary because
  each partition has at most three support points.
- **Settled:** the rational-base polynomial is a canonical
  subdiscriminant/Hermite minor, with an explicit degree bound.
- **Settled:** deletion on the normalized double cover costs at most
  \(32\), not \(22\).
- **Open but not a theorem gate:** the exact minimal number of test sections
  up to the anharmonic symmetry, and whether the degree-\(102\) avoidance
  bound can be sharply reduced.  These do not affect R9.
