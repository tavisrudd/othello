# C909 — tropical classification of rank-one symmetric ideal lattices

Date: 2026-08-11  
Status: human local classification theorem; TT/EJ crown candidate; no
manuscript, PDF, mirror, Lean, or certificate change

## Statement

Let `O` be a DVR with uniformizer `p`.  Fix integers `a_i>=0` and symmetric
integers `e_ij=e_ji>=0`.  Consider the symmetric coefficient lattice

\[
 \mathcal N(a,e)=\left\{A=A^t:
       A_{ii}\in p^{a_i}O,
       \ A_{ij}\in p^{e_{ij}}O\ (i\ne j)
                    \right\}.
 \tag{1}
\]

Let `mathcal R` be the integral span inside `mathcal N(a,e)` of the rank-one
forms `c vv^t` that themselves belong to `mathcal N(a,e)`.

> **Tropical rank-one classification.** One has
> 
> \[
>                     \mathcal R=\mathcal N(a,e)
> \tag{2}
> \]
>
> if and only if, for every pair `i!=j`,
>
> \[
>       e_{ij}\ge
>       \left\lceil\frac{a_i+a_j}{2}\right\rceil.
> \tag{3}
> \]

Thus rank-one generation is exactly the midpoint-convexity of the cross-slot
valuation relative to its two diagonal valuations.  The statement holds over
dyadic DVRs without change.

## Sufficiency

Diagonal generators `p^{a_i}e_ie_i^t` are rank one. Fix `i!=j` and put
`e=e_ij`. Choose integers `r,s>=0` and `t>=0` satisfying

\[
 t+r+s=e,
 \qquad t+2r\ge a_i,
 \qquad t+2s\ge a_j.
 \tag{4}
\]

Then the three rank-one forms

\[
 p^t(p^re_i+p^se_j)(p^re_i+p^se_j)^t,
 \quad p^{t+2r}e_ie_i^t,
 \quad p^{t+2s}e_je_j^t
\]

all lie in `mathcal N(a,e)`, and their signed difference is

\[
 p^e(e_ie_j^t+e_je_i^t).
 \tag{5}
\]

Such `r,s,t` exist exactly under (3). Put `x=a_i` and `y=2e-a_i`. The
inequality `2e>=a_i+a_j` gives `y>=a_j`, while `x+y=2e` makes `x,y` have the
same parity. Put

\[
 t=\min(x,y),\qquad r=(x-t)/2,\qquad s=(y-t)/2.
\]

Then (4) holds and `t+r+s=e`. Formula (5), together with diagonal forms,
generates every slot of (1). No division by two occurs.

## Necessity

Suppose the primitive cross generator

\[
                   p^{e_{ij}}(e_ie_j^t+e_je_i^t)
 \tag{6}
\]

is an integral sum of admissible rank-one forms `c_rv_rv_r^t`.  Project to
the principal `2 by 2` coefficient submatrix on `{i,j}`.  For each summand set

\[
 t=v_p(c_r),\quad r_i=v_p((v_r)_i),\quad r_j=v_p((v_r)_j).
\]

Admissibility of its two diagonal entries gives

\[
             t+2r_i\ge a_i,
             \qquad t+2r_j\ge a_j.
\]

Therefore its cross entry has valuation

\[
 t+r_i+r_j\ge
 \left\lceil\frac{a_i+a_j}{2}\right\rceil.
 \tag{7}
\]

Every integral sum of such entries has at least the same valuation.  It cannot
equal (6) if (3) fails.  Extra nonzero coordinates of `v_r` do not help:
projection preserves rank-one form and the two displayed diagonal
admissibility inequalities. This proves necessity.

## Divided-power consequence

In an elliptic-power coefficient realization, every rank-one divisor class
pulls back to a decomposable alternating two-form and hence squares to zero
integrally. Under (3), write any divisor `D` as an integral sum of such
square-zero classes. Then

\[
       \frac{D^k}{k!}
         =\sum_{r_1<\cdots<r_k}R_{r_1}\cdots R_{r_k}
\]

lies in the ordinary `k`-fold divisor-product image. Thus (3) is an exact
coefficient-lattice criterion for equality of the divided-power envelope and
ordinary product algebra in all degrees.

This corollary is cohomological, not Chow-theoretic. It requires actual
rank-one divisor realizations; the lattice theorem itself is purely local
linear algebra.

## Relation to finite-etale graph lattices

The stronger containment `e_ij>=max(a_i,a_j)` used in the first matrix-ideal
theorem implies (3), but is not necessary. The exact graph problem is now
reduced to computing its valuation matrix and testing tropical midpoint
convexity. Pure equal-depth finite-etale graphs have diagonal depth `a` and
cross depth `2a`, so they lie safely inside the cone.

For arbitrary-depth graph packets, compatible slotwise etale splitting would
produce such a valuation matrix. The theorem then gives both a positive test
and an exact obstruction to rank-one generation. It does not by itself prove
that failure of (3) forces a nonzero divided-power defect; cancellation by
higher-rank generators could conceivably preserve particular divided powers
even when the whole lattice is not rank-one generated.

## Mystery ledger

* **Settled:** rank-one generation of a symmetric DVR ideal lattice has the
  exact pairwise criterion (3).
* **Settled:** multiple-coordinate rank-one forms cannot evade the pairwise
  obstruction.
* **EJ:** the graph problem becomes a tropical valuation test rather than a
  degree-by-degree determinant calculation.
* **Open:** compute the exact valuation matrices of arbitrary-depth
  finite-etale graph packets and decide whether midpoint convexity is
  automatic.
* **Open:** determine whether failure of midpoint convexity yields an actual
  divided-power defect class, not merely failure of rank-one generation.
