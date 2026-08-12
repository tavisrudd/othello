# C909 — DVR symmetric ideal lattices: exact rank-one criterion

Date: 2026-08-11

Status: bounded local algebra for arbitrary-depth finite-etale graph NS; no manuscript, PDF, mirror, Lean, or commit change

## Exact theorem

Let `O` be a DVR with uniformizer `pi`, including a dyadic unramified DVR. On a free module with basis `e_1,...,e_n`, fix nonnegative integers `a_i` and symmetric integers `e_ij=e_ji`. Let

\[
 L(a,e)=\{A=A^t:A_{ii}\in\pi^{a_i}O,\ A_{ij}\in\pi^{e_{ij}}O\ (i<j)\}.
\tag{1}
\]

An admissible rank-one form is `c vv^t∈L(a,e)`, with `c` and the coordinates
of `v` allowed in the fraction field and only the resulting matrix required
to be integral. Equivalently, their valuations may be arbitrary integers.

> **DVR rank-one criterion.** The `O`-span of admissible rank-one forms equals `L(a,e)` if and only if
> \[
> e_{ij}\geq\left\lceil\frac{a_i+a_j}{2}\right\rceil\quad(i\ne j).
> \tag{2}
> \]

This is exact for arbitrary `n`, unit coefficients, and `p=2`.

## Proof

For an admissible `R=c vv^t`, the diagonal entries give

\[
 \nu(c)+2\nu(v_i)\geq a_i,\qquad \nu(c)+2\nu(v_j)\geq a_j.
\tag{3}
\]

Hence `2ν(R_ij)>=a_i+a_j`, proving `ν(R_ij)>=ceil((a_i+a_j)/2)`. This only uses coordinates `i,j`, so extra coordinates in `v` cannot evade it, and sums cannot lower that valuation. If (2) fails, the valid cross generator `pi^{e_ij}(e_ie_j^t+e_je_i^t)` is absent from the rank-one span.

Conversely, `pi^{a_i}e_ie_i^t` are rank-one diagonal generators. Fix `i<j`, let `e=e_ij`, and suppose (2). Choose `x>=a_i`, `y>=a_j`, `x+y=2e`; they have the same parity. Put

\[
 t=\min(x,y),\qquad r=(x-t)/2,\qquad s=(y-t)/2.
\tag{4}
\]

Then

\[
 R=\pi^t(\pi^re_i+\pi^se_j)(\pi^re_i+\pi^se_j)^t
\tag{5}
\]

is admissible, has diagonal valuations `x,y`, and cross coefficient exactly `pi^e`. Thus

\[
 \pi^e(e_ie_j^t+e_je_i^t)=R-\pi^xe_ie_i^t-\pi^ye_je_j^t.
\tag{6}
\]

Units multiply this identity. It produces all off-diagonal ideal generators. No step divides by two.

## Finite-etale graph consequence

For a split finite-etale graph presentation, full rank-one generation reduces exactly to checking (2) for its complete symmetric coefficient NS lattice.

For the common denominator `P=pi^aI`, distinct scalar etale eigenblocks have diagonal depth `a` and cross depth `2a`, hence pass (2), recovering the equal-depth full PD result.

For proposed varying denominators `P=diag(pi^{a_i})`, the condition

\[
 P^{-1}(AT^t-TA)P^{-1}\ \text{integral}
\tag{7}
\]

forces `e_ij>=a_i+a_j` at distinct scalar residual eigenvalues. If the exact alternating-form calculation also gives both `P^{-1}A` and `AP^{-1}` integral, then the exact ideal is `e_ij=a_i+a_j`. This is safely above (2). For equal residual eigenvalues the commutator gives no valuation and the first integrality condition controls `e_ij`; finite etaleness alone does not determine it. The universal unequal-depth graph theorem is therefore conditional on this remaining normalization calculation.

Unit blocks are `a_i=0`; a unit/scaled cross term must have `e_ij>=ceil(a_j/2)`. The distinct-eigenvalue formula supplies the stronger value `a_j`.

## Square-zero and PD corollary

In the non-CM elliptic-power dictionary, every admissible rank-one coefficient `c vv^t` is an actual NS class whose pullback is a decomposable alternating two-form. It squares to zero, and isogeny pullback injectivity on torsion-free integral cohomology proves square-zero on the quotient.

When (2) holds for the complete NS lattice, every divisor is an integral sum `D=sum R_l` of square-zero divisor classes. Then

\[
 D^{[k]}=D^k/k!=\sum_{|I|=k}\prod_{l\in I}R_l
\tag{8}
\]

is an ordinary integral product. Therefore

\[
 \operatorname{PD}\langle\operatorname{NS}\rangle^k=\operatorname{im}(\operatorname{Sym}^k\operatorname{NS}\to H^{2k})
\tag{9}
\]

in every degree, provided the prescribed NS/product lattices commute with the finite unramified base change used to split the etale algebra. This is cohomological, not Chow.

## Mystery ledger

* **Settled:** (2) is the exact multi-coordinate-resistant rank-one test.
* **Settled:** it is valid dyadically and with all unit factors.
* **Open:** derive the complete unequal-depth graph NS lattice in one fixed polarization convention, especially same-eigenvalue cross ideals.
