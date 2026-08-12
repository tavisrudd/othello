# C907 Fano complete-intersection support bound

**Lane:** `clebsch`

**Status:** structural candidate pending a cold convention audit.

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

with a nonzero integer `C`, where `s=q/z^r`.  Put
`t=s^(1/r)=q^(1/r)/z`.  Its zero-exponential branches at `s=infinity` are

\[
 \left\{s^{-m/d_j}:1\le m<d_j\right\}_{j=1}^k,
\]

so their scalar `z` residues are `r m/d_j`.  Passing from the scalar period
to the framed threefold connection shifts all residues by `-1/2` modulo
integers.  A primitive-sixth residue can therefore occur only when

\[
 \frac{rm}{d_j}-\frac12=\pm\frac16\pmod{\mathbf Z}.
\]

The remaining `r` branches are irregular.  The ansatz
`e^(lambda t)t^alpha` gives the universal scalar power

\[
 \alpha=-\frac32.
\]

Indeed, if `p=sum_j(d_j-1)=4-r`, comparison of the next coefficient gives

\[
 \alpha=rac{p(p-1)/2+r\sum_{j,m}m/d_j-6}{r}
 =-\frac32.
\]

After the framed shift their residue is integral, so they contribute no
primitive-sixth eigenvalue.

The Fano inequality is

\[
 \sum_jd_j\le k+3.
\]

The ordinary Fano complete-intersection threefolds are

\[
 \mathbf P^3,\ Q_3,\ V_3,\ V_{2,2},\ V_{2,3},\ V_{2,2,2}.
\]

Applying the congruence above gives respectively zero, zero, one, zero, one,
and zero primitive pairs.  The same restriction follows directly from the
Fano inequality.  Since every `d_j>=2`, two cubic factors would give

\[
 \sum_jd_j\ge3+3+2(k-2)=2k+2>k+3
\]

for `k>=2`, and a divisible-by-three degree greater than three is excluded.
Hence at most one cubic factor occurs.  Consequently the ambient small-even
connection satisfies

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

## Mystery ledger

- **Candidate settled structurally:** ordinary Fano complete intersections
  cannot furnish a length-two ambient-even carrier.
- **Open audit:** scalar-to-framed convention.
- **Open search:** weighted complete intersections, non-complete-intersection
  Fanos, and Mori-fibre threefolds with `nu_6>=4`.
