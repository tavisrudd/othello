# C907 Cartier weighted-CI rank-four theorem

**Lane:** `clebsch`

**Status:** theorem-grade for the stated smooth weighted-CI class.

## Theorem

Let

\[
 X=X_{d_1,\ldots,d_c}\subset W=\mathbf P(w_0,\ldots,w_{c+3})
\]

be a quasismooth, strongly well-formed weighted complete-intersection
threefold with smooth coarse space.  Assume `Pic(X)=Z[H]`, where `H=O_X(1)`
is primitive, and that every defining degree is a Cartier multiple of the
ambient coarse index:

\[
 L=\operatorname{lcm}(w_i)\mid d_j\quad(1\le j\le c).
\tag{C}
\]

If `X` is Fano of index `r=sum_iw_i-sum_jd_j>0`, its full small-even quantum
D-module is cyclic rank four.  After the standard index-one normalization it
has reduced scalar operator

\[
 \theta^4-C s\prod_{a\in A}(\theta+a),\qquad s=q/z^r,
 \tag{1}
\]

where `C!=0`, `|A|=4-r`, and `A` is invariant as a multiset under
`a mapsto1-a`.  Therefore

\[
 \nu_6(X)\le2.
\]

## Proof

### Inertia avoidance

The stack `X` has trivial inertia.  Otherwise take a point with nontrivial
cyclic stabilizer and its smooth three-dimensional quasismooth chart `U`.
Since the coarse space is smooth, Chevalley--Shephard--Todd makes the
effective stabilizer action on `U` a pseudoreflection action.  Its fixed
divisor is contained in `X intersect Sing(W_coarse)`.  This contradicts
strong well-formedness, which makes that intersection codimension at least
two.  (A trivial effective action would put all of `U` in the same locus.)

For `m>1`, let `n_m` be the number of weights divisible by `m`.  The
corresponding inertia stratum is `P_m=P(w_i:m|w_i)`.  By (C), each defining
equation restricts to a section on `P_m`.  If `n_m>c`, `c` positive-degree
homogeneous equations on `P^(n_m-1)` have a common zero.  This would meet the
inertia stratum, so `n_m<=c` for every `m>1`.

### Factorial reduction

The untwisted small period is

\[
 \Phi(s)=\sum_{n\ge0}
 \frac{\prod_j(d_jn)!}{\prod_i(w_in)!}s^n.
\]

At a reduced fraction with denominator `m>1`, every numerator degree is a
multiple of `m` by (C), so its factorial occurs `c` times; the denominator
factor occurs `n_m` times.  Since `n_m<=c`, all fractional denominator
factors cancel.  If `F_N={1/N,\ldots,(N-1)/N}`, the surviving numerator
multiset is

\[
 A=\left(\bigsqcup_jF_{d_j}\right)\setminus
   \left(\bigsqcup_iF_{w_i}\right),
 \qquad |A|=\sum_j(d_j-1)-\sum_i(w_i-1)=4-r.
\]

Each `F_N` is symmetric under `a mapsto1-a`, so `A` is too.  The `c+4`
denominator factors `(n+1)` and `c` numerator factors leave `(n+1)^4`, which
gives (1).

### QDM identification

Condition (C) says each `O_W(d_j)` is pulled back from the coarse space; its
positivity makes the bundle `E=direct sum_jO_W(d_j)` convex.  Coates--Corti--
Iritani--Tseng Theorem 25 applies to the transverse zero locus, and Corollary
28 identifies the normalized hypergeometric `I`-function with `J_X`, because
`c1(TW)-c1(E)=rH` is ample.  This is the requisite orbifold
quantum-Lefschetz statement; unqualified orbifold quantum Lefschetz is false.

Inertia avoidance makes this the ordinary, rather than Chen--Ruan, QDM.
The Picard and Poincare hypotheses give
`H^even(X)=span(1,H,H^2,H^3)`.  The four classical leading terms of the
cohomology-valued `I`-function identify the cyclic rank-four module above
with the full small-even QDM.  The rank-four hypergeometric support bound
then gives `nu_6<=2`.

## Exact boundary

The argument requires all degrees to be Cartier multiples, not merely that
the WCI be quasismooth.  If a defining line bundle is not pulled back from
the coarse space, convex orbifold quantum Lefschetz does not apply; indeed
positive-orbifold quantum Lefschetz can fail.  Positive-dimensional inertia
strata outside (C), nonprimitive `H`, residual target inertia, odd quantum
sectors, and the operation-framed carrier length remain uncontrolled.

The nonquasismooth `(3,6)` false positive violates (C): in
`P(1,1,1,1,2,4)`, degree `3` is not a multiple of `L=4`.

## Source boundary

- T. Coates, A. Corti, H. Iritani, H.-H. Tseng, *Some Applications of the
  Mirror Theorem for Toric Stacks*, arXiv:1401.2611, §5, Theorem 25 and
  Corollary 28: convex toric-stack complete intersections and normalized
  `I/J` comparison.  Convexity is exactly positivity plus pullback from the
  coarse space (p. 18).  Cached SHA-256:
  `b871262deb24cad73babec42cd98809392329d4ce4bc3f19d653a17782cbcebd`.
- T. Coates et al., arXiv:1202.2754: positive orbifold quantum Lefschetz can
  fail without the convex/pullback hypothesis.
- J. Cai, arXiv:2608.01577, §§2--3: framed threefold residue convention.

## Mystery ledger

- **Settled:** a broad convex weighted-CI class has exactly the rank-four
  QDM and `nu_6<=2` needed to rule out a length-two carrier.
- **Open:** non-Cartier degrees, where the source theorem and factorial
  cancellation both genuinely fail.
