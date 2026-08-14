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
plus blowup model.  It remains pure-boundary and rank-zero, and in fact every
primary multi-leg evaluation shadow vanishes by dimension.  The displayed
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

### Exact infinity connection coefficients

The scalar shadow already passes a stronger analytic test than its local
exponents suggest.  Put `s=4q/27`.  The standard Barnes residue formula for
`_3F_2` gives, on a fixed non-Stokes branch at infinity,

\[
 F(s)=C_{1/2}(-s)^{-1/2}
      +(-s)^{-1}\bigl(A_1\log(-s)+B_1\bigr)
      +O(|s|^{-3/2}\log|s|),                                   \tag{14}
\]

where `B_1` depends on the logarithm convention, but the two load-bearing
coefficients are canonical and nonzero:

\[
 \boxed{C_{1/2}=-\frac{\pi}{6\sqrt3},
        \qquad A_1=-\frac49.}                                  \tag{15}
\]

For the simple exponent `a_3=1/2`, the Barnes coefficient is

\[
 \frac{\Gamma(1/3)\Gamma(2/3)\Gamma(1/2)^2}
      {\Gamma(-1/6)\Gamma(1/6)}
 =-\frac{\pi}{6\sqrt3}.                                       \tag{16}
\]

For the repeated exponent `a_1=a_2=1`, first replace one copy by
`1+epsilon`.  The two simple residues have opposite `1/epsilon` poles;
expanding `(-s)^{-1-epsilon}` makes their finite sum logarithmic.  Its
coefficient is

\[
 \frac{\Gamma(1/3)\Gamma(2/3)\Gamma(-1/2)}
      {\Gamma(1/2)\Gamma(-2/3)\Gamma(-1/3)}
 =-\frac49.                                                     \tag{17}
\]

Thus the neutral tower has both a nonzero half-integral infinity branch and
a nonzero logarithmic **integer-exponent** branch.  Neither
formal-monodromy separation nor vanishing of the scalar connection
coefficient into the unipotent branch eliminates this model.  It remains
rank zero only because its geometric output marking is boundary-supported.
The analytic coefficient and the output rank are genuinely different
shadows.

## 3. Meaning for C907

This example passes two geometric necessary tests and two calibration tests:

1. it has the uniquely forced mixed `ker(c_1)` slope;
2. the positive and negative boundary curves meet, so the incidence path is
   real;
3. its descendant/equivariant neutral calibration has a nonconstant
   regular-singular connection rather than a finite polynomial tail; and
4. its Barnes connection formula has a nonzero logarithmic integer-exponent
   branch by (14)--(17).

It fails the entire **primary moment** test.  Every map in class `n delta`
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

More generally,

\[
 \operatorname{vdim}_\mathbf C\overline M_{0,k}(X_+,n\delta)=2+k,
 \qquad \dim C^k=k.
\]

The total evaluation pushforward therefore vanishes for every `k`, since its
virtual dimension exceeds the dimension of its image by two.  The `_3F_2`
series can survive only after descendant/equivariant calibration; by itself
it is not any primary state read by the ambient rank functional.  This is the
fixed-curve case of
`2026-08-14-c907-neutral-slice-gamma-kernel.md`, Section 5.

The infinity calculation makes the distinction sharp: the model already has
a nonzero analytic coefficient in an ambient-primary-looking branch.  What
it lacks is not scalar continuation but a nonzero common-open/rank marking
of that branch.

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
- **AA:** cone/incidence, scalar continuation, and an integer-exponent
  connection coefficient still do not close Gold.  The next legitimate
  calculation is the signed punctual/output-rank marking of the complete
  two-wall residue block, not another scalar connection coefficient.

## Replay

`2026-08-13-c907-minimal-neutral-toric-shadow.py` checks the charge sums,
factorial recurrence, and the coefficient recurrence of (11) using only the
Python standard library.
