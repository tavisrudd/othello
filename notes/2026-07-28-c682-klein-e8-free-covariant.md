# C682 Klein \(E_8\) free-covariant Weyl presentation

## Verdict

The first-failure bottleneck extends to a finite all-weight presentation on
the complete \(3\)-covariant block.  Put
\[
F=\Phi_{12},\qquad
h=\frac{(F,F)_2}{242},\qquad
t=\frac{(F,(F,F)_2)_1}{4840}.
\]
Then
\[
t^2=1728F^5-h^3,
\]
and the \(3\)-covariant module is free of rank six over
\(R=\mathbf Q[F,h]\), with generator degrees
\[
2,\ 10,\ 12,\ 18,\ 20,\ 28.
\]

In the primitive basis below, every coefficient of the raw third
transvectant \(\Delta=(\,\cdot\,,F)_3\) is divisible by exactly
\[
132=12\cdot11.
\]
Consequently
\[
\mathcal D=\frac1{132}\Delta
\]
is a primitive integral \(6\)-by-\(6\) matrix differential operator of order
three over \(R\).  It is off diagonal for the split
\[
\{g_2,g_{10},g_{18}\}\ \sqcup\
\{g_{12},g_{20},g_{28}\},
\]
and every one of the eighteen directed cross-block entries is nonzero.
The complete normal-ordered presentation has \(103\) terms and is recorded
exactly in the adjacent JSON certificate.

This closes the requested finite presentation for the \(3\)-block.  It does
not yet present the other eight binary-icosahedral covariant blocks.

## Primitive free basis

It is enough to display the \(q=X^2\) component of each equivariant copy of
the three-dimensional module.  With subscripts denoting ordinary partial
derivatives, use
\[
\begin{array}{c|c|c}
\text{generator}&\text{degree}&q=X^2\text{ component}\\ \hline
g_2&2&X^2\\
g_{10}&10&F_{YY}/110\\
g_{12}&12&(X^2,F)_1/2\\
g_{18}&18&h_{YY}/380\\
g_{20}&20&(X^2,h)_1/40\\
g_{28}&28&t_{YY}/870.
\end{array}
\]
The divisors \(1,110,2,380,40,870\) are exactly the contents of the six
raw covariants.  The Molien numerator
\[
t^2+t^{10}+t^{12}+t^{18}+t^{20}+t^{28}
\]
over \((1-t^{12})(1-t^{20})\) proves that these six copies are a homogeneous
free basis over \(\mathbf Q[F,h]\).

On coefficient-free generators the primitive operator has the sparse
ground-state action
\[
\begin{aligned}
\mathcal Dg_2&=0,&
\mathcal Dg_{10}&=0,\\
\mathcal Dg_{12}&=550g_{18},&
\mathcal Dg_{18}&=2160F g_{12},\\
\mathcal Dg_{20}&=17100F^2g_2,&
\mathcal Dg_{28}&=-3960Fh\,g_2+444600F^2g_{10}.
\end{aligned}
\]
The derivatives of an arbitrary coefficient in \(R\) supply the remaining
normal-ordered terms.

## The degree-\(22\) Koszul row

The former \(0,2,1\) bottleneck is the first jet of one matrix row:
\[
\mathcal D(hg_2)=-100g_{28},\qquad
\mathcal D(Fg_{10})=100g_{28}.
\]
Hence
\[
hg_2+Fg_{10}
\]
is the dark line and
\[
Fg_{10}-hg_2
\]
is the bright line, mapping to \(200g_{28}\).  In other words, the
degree-\(22\) obstruction is the Koszul syzygy of \((F,h)\), and the first
jet of the row landing in \(g_{28}\) is
\[
100(-\partial_h,\partial_F).
\]
This recovers the earlier \(5/11\) graph after undoing the primitive
generator contents, but explains it without a coordinate accident.

## Principal symbol and the Klein branch

Let \(\xi,\eta\) be the cotangent variables dual to \(F,h\).  All \(45\)
third-order terms share the single scalar cubic
\[
p(F,h;\xi,\eta)
=2F\xi^3+5h\xi^2\eta-8000F^3\eta^3.
\]
After factoring out \(p\), the principal symbol is off diagonal.  With
source rows \((g_2,g_{10},g_{18})\) and target columns
\((g_{12},g_{20},g_{28})\), the left-to-right multiplier matrix is
\[
A=
\begin{pmatrix}
-10h&120F&0\\
0&2h&12F\\
240F^3&0&10h
\end{pmatrix}.
\]
With source rows \((g_{12},g_{20},g_{28})\) and target columns
\((g_2,g_{10},g_{18})\), the reverse matrix is
\[
B=
\begin{pmatrix}
10h^2&-600Fh&720F^2\\
1440F^4&-50h^2&60Fh\\
-240F^3h&14400F^4&-10h^2
\end{pmatrix}.
\]
Their determinants are
\[
\det A=-200(h^3-1728F^5),\qquad
\det B=5000(h^3-1728F^5)^2.
\]
Therefore
\[
\det\sigma_3(\mathcal D)
=10^6p^6(h^3-1728F^5)^3
=-10^6p^6t^6.
\]

Thus the characteristic determinant has exactly two intrinsic components:
the cubic cotangent cone \(p=0\) and the Klein branch divisor \(t=0\).
The degree-\(22\) failure is no longer an isolated spectral event; it lies
inside a finite operator whose characteristic degeneration remembers the
binary-icosahedral invariant relation.

## Proof

The proof has four steps.

1. The affine-\(E_8\) Molien numerator gives the six free generator degrees.
   The displayed polar and Hamiltonian covariants have those degrees,
   primitive contents, and independent leading components, so they furnish
   the free basis.
2. The product rule for the third transvectant shows that, for each fixed
   degree shift, the coefficient of
   \(\mathcal D(F^ah^b g_i)\) is a polynomial of total degree at most three
   in the falling factorials
   \((a)_r(b)_s\).  Hence \(\mathcal D\) is a matrix in
   \(M_6(R\langle\partial_F,\partial_h\rangle)\) of order at most three.
3. Exact rational decomposition on \(0\le a,b\le4\) determines every
   coefficient.  Exact verification on the larger grid
   \(0\le a,b\le6\) proves the polynomial identities globally.  The common
   content is \(132\), and division gives the primitive integral operator.
4. Collecting the order-three terms yields the common cubic \(p\).
   Two exact \(3\)-by-\(3\) determinants give the displayed powers of
   \(h^3-1728F^5\); direct polynomial comparison gives
   \(t^2=1728F^5-h^3\).

The finite grids are not an extrapolation in the degree variables: order
three supplies the a priori polynomial-degree bound that makes the
interpolation exact.

## Evidence and replay

The primary generator uses exact sparse integer polynomials, rational row
reduction, a separately checked free-basis decomposition, and exact
falling-factorial interpolation.  The canonical certificate records all
\(103\) normal-ordered terms, the primitive contents, the bipartite support,
the Koszul specialization, both principal-symbol matrices, and the
characteristic determinant.

The independent replay uses the separate dense modular transvectant engine.
Modulo each of \(1000000007\) and \(1000000009\), it compares the certified
Weyl operator directly with the polynomial transvectant on all
\[
6\cdot7\cdot7=294
\]
monomial-generator inputs.  It also checks the primitive Klein relation and
the characteristic determinant at three independent cotangent points.

From `rust/`, run

```text
python3 ../notes/2026-07-28-c682-klein-e8-free-covariant.py --check
python3 ../notes/2026-07-28-c682-klein-e8-free-covariant-replay.py
(cd ../notes && sha256sum -c 2026-07-28-c682-klein-e8-free-covariant.sha256)
```

The scripts use only the Python standard library.  The exact matrices are
over characteristic zero.  Although \(\mathcal D=\Delta/132\) is integral
on this displayed lattice, no claim is made here that the six-generator
free decomposition remains exact after reduction modulo \(2,3,\) or \(11\).
The byte counts are \(30188\) and \(15046\) for the imported exact and
independent engines, \(26315\) for the primary generator, \(9677\) for the
independent replay, and \(25687\) for the JSON certificate.  The adjacent
manifest records their SHA-256 hashes together with the report hash.

## `ej` + `tt` closeout

The first cheap upgrade is the primitive content \(132=12\cdot11\).  The
degree-\(22\) map becomes the integral Koszul row
\(100(-\partial_h,\partial_F)\), giving a canonical divided operator rather
than merely observing that ordinary polars vanish modulo \(11\).

The decisive `ej` upgrade is the principal-symbol collapse.  A 103-term
matrix might have been only a finite certificate; the common cubic \(p\)
and the factorization
\[
\det\sigma_3(\mathcal D)=-10^6p^6t^6
\]
turn it into geometry.  The two sources of characteristic degeneration are
the cotangent cubic and the Klein branch, with no third component.

The `tt` question is now whether \(p\) is the cotangent expression of a
standard invariant Hamiltonian, Rankin--Cohen bracket, or radial part of the
Klein invariant differential algebra.  If so, the remaining eight McKay
blocks may share the same scalar symbol and differ only in their finite
matrix factors.  That would give a uniform invariant-Weyl presentation
rather than nine unrelated tables.

## Mystery ledger

- **Settled:** the complete \(3\)-covariant block is a rank-six free
  \(R\)-module with a \(103\)-term order-three Weyl presentation.
- **Settled:** the primitive operator is
  \(\mathcal D=(\,\cdot\,,F)_3/132\), with coefficient content one.
- **Settled:** the degree-\(22\) dark line is the Koszul syzygy
  \(hg_2+Fg_{10}\).
- **Settled:** the operator is a complete off-diagonal \(3+3\) block.
- **Settled:** its principal symbol is the common cubic \(p\) times finite
  multiplier matrices, and its determinant is \(-10^6p^6t^6\).
- **Open:** identify \(p\) intrinsically in the classical invariant
  differential algebra.
- **Open:** determine whether the other eight McKay blocks have the same
  scalar principal symbol and assemble them into a uniform theorem.
- **Open arithmetically:** determine the correct divided-power reductions of
  \(\mathcal D\) at \(2,3,11\) and compare the \(11\)-fibre with C651's
  primitive finite matching map.
- **Open spectrally:** use the finite matrix to classify every later
  commutant failure and repair without further ambient binary-form row
  reductions.

C682 remains open; the user retains stopping authority.
