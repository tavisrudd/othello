# C907 — the first mixed-sign neutral toric shadow

Date: 2026-08-13

Status: exact local regression, not a Gold counterexample.  A codimension-two
toric blowup meeting the negative exceptional line of the point `(1,3)`
standard flip produces the primitive neutral charge

\[
 (3,1,1,-1,-1,-1,-2).
\]

Its scalar GKZ shadow is the regular-singular rank-three hypergeometric system

\[
 {}_3F_2\!\left(
 \begin{matrix}1,1,\tfrac12\\[2pt]\tfrac13,\tfrac23\end{matrix};
 \frac{4q}{27}\right).
\]

Thus the cone and incidence shadows in
`2026-08-13-c907-remaining-mixed-stokes-shear-gate.md` are not vacuous: a
connected unbounded neutral boundary tower exists in the smallest point-flip
plus blowup model.  It remains pure-boundary and rank-zero, and its primary
one- and two-leg evaluation shadows vanish by dimension.  The displayed
hypergeometric series is therefore a descendant/equivariant calibration
shadow, not yet a primary carrier coupling.  To threaten Gold it would still
need a relative/descendant boundary-to-ambient coupling that survives in the
small quantum connection, followed by a Stokes/window mismatch.

## 1. Local toric geometry

Take the open local model on the positive side of the point `(1,3)` flip,

\[
 X_+=\operatorname{Tot}_{\mathbf P^1}
       \bigl(\mathcal O_{\mathbf P^1}(-1)^{\oplus4}\bigr).
\]

It is the quotient of coordinates

\[
 (x_0,x_1,y_1,y_2,y_3,y_4)
\]

by the charge row

\[
 (1,1,-1,-1,-1,-1).                                               \tag{1}
\]

The zero section is the exceptional `P^1`; its line class `ell` has

\[
 c_1(X_+)\cdot\ell=-2.                                             \tag{2}
\]

Blow up the smooth toric codimension-two center

\[
 Z=\{x_0=y_1=0\}.
\]

It meets the zero section transversely at the torus-fixed point
`[0:1]`.  With `u` the exceptional Cox coordinate, a charge matrix for the
blowup is

\[
\begin{array}{c|rrrrrrr}
 &x_0&x_1&y_1&y_2&y_3&y_4&u\\ \hline
 Q_1&1&1&-1&-1&-1&-1&0\\
 Q_2&1&0& 1& 0& 0& 0&-1.
\end{array}                                                        \tag{3}
\]

Here `Q_2` is oriented so that its curve `e` is an exceptional-fibre line;
the row sum gives

\[
 c_1(e)=1.                                                        \tag{4}
\]

The strict transform of the zero-section line is `tilde ell=ell-e`, hence

\[
 c_1(\widetilde\ell)=-2-1=-3.                                    \tag{5}
\]

The forced primitive mixed-sign neutral class is therefore

\[
 \delta=\widetilde\ell+3e=\ell+2e,
 \qquad c_1(\delta)=0.                                            \tag{6}
\]

The two curves meet inside the exceptional/toroidal boundary, so multiple
covers give connected stable maps of class `n delta`.  This is precisely the
incidence escape left open by the valence/contact-budget lemma.

## 2. Neutral charge and factorial solution

Evaluating the seven toric divisors in (3) on the class `(1,2)` gives

\[
 l=(3,1,1,-1,-1,-1,-2),
 \qquad \sum_i l_i=0.                                             \tag{7}
\]

The large-radius scalar factorial solution in this chamber has coefficients

\[
 c_n=
 \frac{(n!)^3(2n)!}{(3n)!(n!)^2}
 =\frac{n!(2n)!}{(3n)!}
 =\binom{3n}{n}^{-1}.                                             \tag{8}
\]

Their ratio is

\[
 \frac{c_{n+1}}{c_n}
 =\frac{2(n+1)(2n+1)}{3(3n+1)(3n+2)}.                            \tag{9}
\]

Using the multiplication formulas for factorials, (8) is exactly

\[
 F(q)=
 {}_3F_2\!\left(
 \begin{matrix}1,1,\tfrac12\\[2pt]\tfrac13,\tfrac23\end{matrix};
 \frac{4q}{27}\right).                                           \tag{10}
\]

With `theta=q d/dq`, its reduced Picard--Fuchs operator is

\[
 \boxed{
 3\theta(3\theta-1)(3\theta-2)
 -2q(\theta+1)^2(2\theta+1).}                                    \tag{11}
\]

The full seven-coordinate GKZ operator factors as `theta^2` times (11),
with the usual noncommutative rule `theta q=q(theta+1)`.  Thus the neutral
primitive part has rank three.

At `q=0` the exponents of (11) are

\[
 0,\quad\frac13,\quad\frac23,                                    \tag{12}
\]

while at `q=infinity` the hypergeometric numerator parameters give

\[
 1,\quad1,\quad\frac12                                             \tag{13}
\]

modulo integers; the repeated exponent one produces the expected logarithmic
branch.  The finite singular point is `4q/27=1`.

## 3. Meaning for C907

This example passes two geometric necessary tests and one weaker calibration
test:

1. it has the uniquely forced mixed `ker(c_1)` slope;
2. the positive and negative boundary curves meet, so the incidence path is
   real;
3. its descendant/equivariant neutral calibration has a nonconstant
   regular-singular connection rather than a finite polynomial tail.

It fails the first **primary low-moment** test.  Every map in class `n delta`
has image in the fixed nodal boundary curve
`C=tilde ell union e`.  Hence

\[
 \operatorname{vdim}\overline M_{0,1}(X_+,n\delta)=3,
 \qquad \dim C=1,
\]

and

\[
 \operatorname{vdim}\overline M_{0,2}(X_+,n\delta)=4,
 \qquad \dim(C\times C)=2.
\]

The primary one- and two-leg evaluation pushforwards therefore vanish.  The
`_3F_2` series can survive only after descendant/equivariant calibration; by
itself it is not the low-moment state read by the ambient rank functional.

It still fails to be the dangerous object itself.  Every component of the
class `n delta` lies in the toroidal boundary, so its direct quantum output is
boundary-supported and its `K`-theory window class has rank zero.  The missing
datum is a mixed invariant coupling the one-leg state of (10) to an
off-boundary cubic carrier and producing a rank-visible ambient output.

The rank-three system (11) is therefore a bounded regression for the
numerical window-shadow comparison only after adjoining an abstract ambient
carrier leg and proving that the relevant descendant/relative state enters
the small quantum connection.  The first calculation is cheaper: compute the
primary one- and two-leg moments, which vanish here.  Any surviving refinement
must then exhibit the precise relative or descendant insertion that defeats
this dimension shadow before its two-chamber ambient row is worth computing.

## EJ / TT / AA

- **EJ:** the first genuine neutral shadow is the Calabi--Yau charge
  `(3,1,1,-1,-1,-1,-2)` and the concrete `_3F_2` equation (11).
- **TT:** the opposite chamber series has different factorial normalization;
  do not replace (8) by `binom(3n,n)` without stating the chamber.  The latter
  is an analytically related algebraic shadow, not the large-radius series
  used in (10).
- **AA:** this proves that cone/incidence elimination alone cannot close
  Gold, but also kills the model at the next primary shadow.  The next
  legitimate calculation is to decide whether a relative/descendant gluing
  state contributes to the small ambient connection; only then compute its
  window-constrained ambient row.

## Replay

`2026-08-13-c907-minimal-neutral-toric-shadow.py` checks the charge sums,
factorial recurrence, and the coefficient recurrence of (11) using only the
Python standard library.
