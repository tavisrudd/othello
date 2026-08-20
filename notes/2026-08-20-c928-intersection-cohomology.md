# C928: intersection cohomology of the cubic-threefold theta divisor

**Date:** 2026-08-20

**Status:** corollary proved; integral statement isolated in degree three,
full decomposition stated over `Q`

## Setup

Let `Theta` be the theta divisor of the intermediate Jacobian of a smooth
cubic threefold.  It has one ordinary triple point at the origin.  Let

\[
b:M=\operatorname{Bl}_0\Theta\longrightarrow\Theta
\]

be the resolution, with exceptional divisor the cubic threefold `X`, and
put `U=Theta minus {0}=M minus X`.

## Integral middle-degree theorem

For middle perversity with integral coefficients,

\[
IH^3(\Theta,\mathbf Z)\cong H^3(U,\mathbf Z)
\cong H^3(M,\mathbf Z).
\tag{1}
\]

Under this identification the ordinary-to-intersection-cohomology map fits
into the exact sequence

\[
0\longrightarrow H^3(\Theta,\mathbf Z)
\longrightarrow IH^3(\Theta,\mathbf Z)
\longrightarrow H^3(X,\mathbf Z)
\longrightarrow0.
\tag{2}
\]

Consequently `IH^3(Theta,Z)` is torsion-free of rank 130 and carries exactly
the lattice computed structurally in C928:

\[
IH^3(\Theta,\mathbf Z)
\cong
\left\{(\sigma,\gamma)\in
\operatorname{Sat}\oplus H^3(X,\mathbf Z):
[\sigma]=\rho(\bar\gamma)\right\}.
\tag{3}
\]

The ordinary group is

\[
H^3(\Theta,\mathbf Z)\cong\bigwedge^3\Lambda
\]

of rank 120.  Thus the ten new integral directions are intrinsic
intersection-cohomology classes of the singular theta divisor, not an
artifact of choosing the blow-up.

### Proof

For an isolated singularity in a complex fourfold, the Deligne sheaf for
middle perversity agrees in cohomological degrees below four with the
cohomology of the smooth locus.  Hence

\[
IH^k(\Theta,\mathbf Z)\cong H^k(U,\mathbf Z),\qquad k<4.
\]

The Mayer--Vietoris calculation for
`M=nu(X) union U` in the C908 adjudication note proves
`H^3(M,Z)->H^3(U,Z)` is an isomorphism: the link is the circle bundle of
`O_X(-1)`, `H^2(L,Z)=0`, and
`H^3(X,Z)->H^3(L,Z)` is an isomorphism.  This proves (1).

The pair sequence for `(Theta,U)`, weak Lefschetz
`H^3(Theta,Z)=wedge^3 Lambda`, and surjectivity of the link restriction give
(2).  Substituting the structural C928 description of `H^3(M,Z)` gives (3).

No integral decomposition theorem is used.

## Rational decomposition theorem

Over `Q`, the complete contribution of the exceptional fibre is

\[
Rb_*\mathbf Q_M[4]
\cong
IC_\Theta
\oplus\mathbf Q_0[2]
\oplus\mathbf Q_0
\oplus\mathbf Q_0[-2].
\tag{4}
\]

Equivalently,

\[
H^k(M,\mathbf Q)
\cong IH^k(\Theta,\mathbf Q)
\oplus
\begin{cases}
\mathbf Q,&k=2,4,6,\\
0,&\text{otherwise}.
\end{cases}
\tag{5}
\]

### Stalk calculation

The rational cohomology of the exceptional cubic threefold is

\[
H^k(X,\mathbf Q)=
\begin{cases}
\mathbf Q,&k=0,2,4,6,\\
\mathbf Q^{10},&k=3,\\
0,&\text{otherwise}.
\end{cases}
\]

The link `L` is the unit-circle bundle of `O_X(-1)`.  Since cup product by
the hyperplane class is an isomorphism over `Q` in the algebraic degrees,
its Gysin sequence gives

\[
H^k(L,\mathbf Q)=
\begin{cases}
\mathbf Q,&k=0,7,\\
\mathbf Q^{10},&k=3,4,\\
0,&\text{otherwise}.
\end{cases}
\tag{6}
\]

For the inclusion `j:U -> Theta`, normality and the isolated singularity
give

\[
IC_\Theta=\tau_{\le-1}Rj_*\mathbf Q_U[4].
\]

Thus the stalk of `IC_Theta` at the origin has `Q` in perverse-complex
degree `-4`, `Q^10` in degree `-1`, and zero otherwise.  Proper base change
gives the stalk of `Rb_*Q_M[4]` as `H^(i+4)(X,Q)` in degree `i`.  The
difference consists of one copy of `Q` in degrees `-2,0,2`.  The projective
decomposition theorem splits these point-supported summands and yields (4).
Taking hypercohomology gives (5).

## Coefficient boundary

Equation (1) is integral and is the paper's arithmetic corollary.  Equations
(4)--(5) are asserted over `Q`.  The paper will not infer an integral direct-
sum decomposition from the rational decomposition theorem.  Integral groups
in other degrees can be computed from the link and pair sequences, but they
are not needed for the lattice theorem and require separate attention to the
factor-three Euler map `H^2(X,Z)->H^4(X,Z)`.

## Consequences for presentation

1. The title and abstract may state that the paper computes the integral
   middle intersection cohomology of `Theta`, not only the cohomology of a
   chosen resolution.
2. The rank-ten correction has a geometric interpretation: it is the middle
   cohomology of the exceptional cubic entering through the link.
3. The three rational skyscraper summands are algebraic and separate from
   the rank-ten odd correction.

## Mystery ledger

| question | status | evidence or gate |
|---|---|---|
| Is the rank-130 lattice intrinsic to `Theta`? | settled | integral identification (1) |
| Where do its ten extra directions come from? | settled | exact sequence (2), quotient `H^3(X,Z)` |
| What does the resolution add rationally outside middle degree? | settled | three point summands in degrees 2, 4, 6 |
| Does the rational splitting hold integrally? | not claimed | decomposition theorem used only over `Q`; integral Euler map has a factor three |
