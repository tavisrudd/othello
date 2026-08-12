# C907 Fano complete-intersection support bound

**Lane:** `clebsch`

**Status:** theorem-grade for the ambient small-even quantum connection.

Let `V` be a smooth Fano complete-intersection threefold of multidegree
`(d_1,...,d_k)` in `P^(k+3)`, with every `d_j>=2`, and put

\[
 r=k+4-\sum_jd_j>0
\]

for its Fano index.  Its ambient period is

\[
 \Phi(s)=\sum_{n\ge0}
 \frac{\prod_j(d_jn)!}{(n!)^{k+4}}s^n.
\]

After cancelling one factor of `theta` for each equation, the scalar operator
has the form

\[
 \theta^4-C s
 \prod_{j=1}^k\prod_{m=1}^{d_j-1}
  \left(\theta+\frac m{d_j}\right),
 \tag{1}
\]

with `C=\prod_jd_j^{d_j}`, where `s=q/z^r`.  Put
`t=s^(1/r)=q^(1/r)/z`.  Its zero-exponential branches at `s=infinity` are

\[
 \left\{s^{-m/d_j}:1\le m<d_j\right\}_{j=1}^k,
\]

so their scalar `z` residues are `r m/d_j`.  Passing from the scalar period
to the framed threefold connection shifts all residues by `-3/2`, hence by
`-1/2` modulo integers.  Concretely, in Cai-compatible notation

\[
 z^2\partial_zS=(K+zG)S,\qquad G|_{H^{2j}}=\frac32-j,
\]

whereas Cai's connection grading `mu` has eigenvalue `j-3/2`, so `G=-mu`.
The cyclic companion
lift of a scalar solution is, up to constant basis rescaling,
`z^(j-3/2) theta^j Phi`; therefore a branch `Phi~s^(-a)` has framed residue
`ra-3/2`.  This reproduces Cai's cubic residues and fixes the convention
without an extra comparison hypothesis.  A primitive-sixth residue can
therefore occur only when

\[
 \frac{rm}{d_j}-\frac12=\pm\frac16\pmod{\mathbf Z}.
\]

For index one, the mirror coordinate replaces `h` by `h+cq` (with
`c=product_j d_j!`).  This changes `K` only by the scalar `cq Id`, hence changes
an irregular exponential but not these framed residues.

The remaining `r` branches are irregular.  The ansatz
`e^(lambda t)t^alpha` gives the universal scalar power

\[
 \alpha=-\frac32.
\]

Indeed, if `p=sum_j(d_j-1)=4-r`, comparison of the next coefficient gives

\[
 \alpha=\frac{p(p-1)/2+r\sum_{j,m}m/d_j-6}{r}
 =-\frac32.
\]

Since `t=q^(1/r)/z`, this scalar power has `z`-residue `3/2`; after the
framed shift its residue is zero.  Thus the irregular branches contribute no
primitive-sixth eigenvalue.

The Fano inequality is

\[
 \sum_jd_j\le k+3.
\]

The ordinary Fano complete-intersection threefolds are

\[
 \mathbf P^3,\ Q_3,\ V_3,\ V_{2,2},\ V_4,\ V_{2,3},\ V_{2,2,2}.
\]

Applying the congruence above gives respectively zero, zero, one, zero, zero,
one, and zero primitive pairs.  Equivalently, enumerate by index: `r=1` gives
`(4),(2,3),(2,2,2)` and only `(2,3)` contributes; `r=2` gives `(3),(2,2)`
and only the cubic contributes; `r=3` gives the quadric; and `r=4` gives
`P^3`.  Consequently the ambient small-even connection satisfies

\[
 \nu_6(V)\le2.
\]

Thus no ordinary smooth Fano complete-intersection threefold has enough
primitive-sixth support to realize the length-two carrier extension, which
requires `nu_6>=4`.  The `(2,3)` intersection is the extremal positive case
with equality; the cubic hypersurface is the other basic equality case.

By Lefschetz, every even cohomology group of a smooth complete-intersection
threefold is ambient; its primitive cohomology is in odd middle degree.
Therefore (1) is the full small-even connection.  Promotion to the full
operation-framed carrier object and any odd-sector enhancement remain part of
the definition gate.

## Source boundary

- Coates--Givental, arXiv:math/0110142, Theorem 2: quantum Lefschetz.
- Hu, arXiv:1501.03683, Theorem 2.1 and (33): index-one mirror coordinate.
- Cai, arXiv:2608.01577, Section 3: cubic framed-connection convention and
  primitive-sixth calibration.

## EJ/TT closeout

- **EJ:** the branch count is stronger than a database scan: it excludes the
  entire ordinary Fano complete-intersection class from length two at once.
- **TT:** `nu_6>=4` is now the cheap admission test.  Do not compute a Rees
  extension for a candidate that fails it; passing it is necessary, not
  sufficient.

## Mystery ledger

- **Settled:** ordinary Fano complete intersections
  cannot furnish a length-two ambient-even carrier.
- **Open search:** weighted complete intersections, non-complete-intersection
  Fanos, and Mori-fibre threefolds with `nu_6>=4`.
