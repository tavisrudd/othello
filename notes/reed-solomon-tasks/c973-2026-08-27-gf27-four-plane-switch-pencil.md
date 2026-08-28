# C973 — GF(27) four-plane switch pencil

**Lane:** reed-solomon
**Date:** 2026-08-27
**Status:** universal switch nonsingularity proved; quartic split/collision gate open
**Scope:** mathematics only; no manuscript, software, Lean, or certificate edit

## 1. Four planes through the removed line

Let \(K=\mathbf F_{27}\) and fix an affine \(\mathbf F_3\)-line with monic
locator

\[
                         R(t)=t^3+pt+q.                 \tag{1}
\]

Its direction is \(\ker(t^3+pt)\), and its quotient image is the
two-dimensional \(\mathbf F_3\)-space \(W=\operatorname {im}(t^3+pt)\).
The four affine planes through this line are indexed by the four directions
\([u]\in\mathbf P(W)\).  With \(\kappa=u^2\), their locators are

\[
 P_\kappa(t)=\prod_{c\in\mathbf F_3}(R(t)-cu)
             =R(t)^3-\kappa R(t)=R(t)(R(t)^2-\kappa).   \tag{2}
\]

Thus a 39-plane inventory is locally one four-point pencil.  If

\[
       \prod_{w\in W}(T-w)=T^9+aT^3+bT,                 \tag{3}
\]

then the four pencil parameters are exactly the roots of

\[
       \prod_{[u]\in\mathbf P(W)}(X-u^2)=X^4+aX+b.       \tag{4}
\]

Indeed, substituting \(X=T^2\) in the product over the eight nonzero elements
of \(W\) proves (4).

The incidence factorization is equally rigid:

\[
 \prod_{\kappa}P_\kappa(t)=R(t)^3(t^{27}-t),
 \qquad
 \prod_{\kappa}\frac{P_\kappa(t)}{R(t)}
                         =\frac{t^{27}-t}{R(t)}.         \tag{5}
\]

The six points of each plane outside the common line are disjoint across the
four values of \(\kappa\) and together partition the 24 affine points outside
the line.  Formula (5) is the polynomial form of that partition.

## 2. Switch data are low-degree in the pencil parameter

Choose two distinct points \(x_1,x_2\) on the common line, put
\(R_0=(t-x_1)(t-x_2)\), and retain the other seven roots of \(P_\kappa\).
Expanding (2) gives

\[
 P_\kappa(t)=t^9+(p^3-\kappa)t^3-\kappa pt+(q^3-\kappa q).             \tag{6}
\]

Hence in the notation of the universal two-point switch,

\[
 \gamma^6=p^3-\kappa,\qquad
 \gamma^8=-\kappa p,\qquad C=q^3-\kappa q.              \tag{7}
\]

For a syndrome \(z=(z_2,\ldots,z_8)\), set

\[
 F_i=z_2(x_i^6+p^3)+z_3x_i^5+z_4x_i^4+z_5x_i^3
       +z_6x_i^2+z_7x_i+z_8.                            \tag{8}
\]

Then the quotient scalars and plane residual are affine in \(\kappa\):

\[
 \phi_i(\kappa)=F_i-z_2\kappa,
 \quad \mathcal Z(\kappa)=z_3(p^3-\kappa),
 \quad \mathcal R(\kappa)=z_4p^3-\kappa(pz_2+z_4).       \tag{9}
\]

The switch determinant is therefore the explicit quadratic

\[
\begin{aligned}
\mathcal D(\kappa)
={}&(x_1-x_2)(F_1-z_2\kappa)(F_2-z_2\kappa)\\
   &+z_3(p^3-\kappa)(F_2-F_1).                          \tag{10}
\end{aligned}
\]

If \(z_2\ne0\), its leading coefficient is
\((x_1-x_2)z_2^2\ne0\).  Consequently, for every removed pair on the line,
at most two of the four containing planes have singular switch matrix.  At
least two planes give a unique replacement quadratic.  This is stronger on
the dense \(z_2\ne0\) stratum than the earlier fixed-plane theorem, which
varied the pair to obtain one nonsingular matrix.

The pencil also absorbs the boundary.  Equation (10) is identically zero as
a polynomial in \(\kappa\) exactly when

\[
 z_2=0,qquad z_3(F_2-F_1)=0,qquad F_1F_2=0.            \tag{10a}
\]

If \(z_2=0\) but \(z_3\ne0\), the polynomial $F(x)$ in (8) has degree at
most five and is nonzero.  Choose a pair not consisting of two of its zeros.
Then (10) is a nonzero polynomial of degree at most one, so at least three of
the four planes are nonsingular.  If \(z_2=z_3=0\), the nonzero syndrome
makes $F$ a nonzero polynomial of degree at most four.  Choose any two of
its at least 23 nonzero values.  Equation (10) is then the nonzero constant
$(x_1-x_2)F_1F_2$, so all four planes are nonsingular.

Thus every nonzero carrier syndrome admits a removed affine-line pair for
which at least two of the four containing planes have nonsingular switch
matrix.  This proves universal matrix nonsingularity without the earlier
degree-six coset-fibre argument.

By Cramer's rule, the two switch coefficients have numerators of degree at
most two in \(\kappa\) and common denominator (10).  After clearing the
square denominator, the discriminant of the replacement quadratic is a
polynomial

\[
                              \Delta_z(\kappa)           \tag{11}
\]

of degree at most four.  Thus dense splitting has compressed to the four
values satisfying (4), and their product is the resultant

\[
 \prod_{\kappa^4+a\kappa+b=0}\Delta_z(\kappa)
       =\operatorname {Res}_X(X^4+aX+b,\Delta_z(X)).     \tag{12}
\]

Equation (12) is the exact quartic norm gate suggested by the earlier
denominator-free discriminant.  It contains no plane enumeration.

More explicitly, write \(d=x_1-x_2\).  Cramer's rule gives

\[
\begin{aligned}
n_1&=\phi_2(\mathcal Zx_2-\mathcal R)+\mathcal Z^2,\\
n_2&=\phi_1(\mathcal R-\mathcal Zx_1)-\mathcal Z^2,
\qquad c_i=n_i/\mathcal D.                              \tag{13}
\end{aligned}
\]

Since
\[
 S= (t-x_1)(t-x_2)+c_1(t-x_2)+c_2(t-x_1),
\]
direct expansion in characteristic three gives the exact cleared
discriminant

\[
 \Delta_z
 =d^2\mathcal D^2+(n_1+n_2)^2+d(n_1-n_2)\mathcal D.      \tag{14}
\]

It has the two useful norm forms

\[
\begin{aligned}
\Delta_z
 &=(n_1+n_2+d\mathcal D)^2-d\mathcal Dn_1\\
 &=(n_1+n_2-d\mathcal D)^2+d\mathcal Dn_2.               \tag{15}
\end{aligned}
\]

Equations (13)--(15) prove the degree-four assertion directly.  They also
expose two rational sections of the discriminant cover: \(n_1=0\) or
\(n_2=0\) makes the discriminant a square because the replacement quadratic
retains \(x_1\) or \(x_2\), respectively.  These are **not collision
divisors**.  The points \(x_1,x_2\) were removed from the plane before the
switch, so retaining either one is admissible.  A character argument must
discard only a repeated root or a root among the seven roots of \(Q\).

## 3. Genuine collision bookkeeping also respects the pencil

Let \(x_3=-x_1-x_2\) be the retained third point of the common affine line.
Of the three common-line values, only the retained point gives a collision:

\[
                 S_\kappa(x_3)=0
 \quad\Longleftrightarrow\quad
                 n_1-n_2+d\mathcal D=0.                              \tag{16}
\]

The equation in (16) makes (14) a square, as it must: a quadratic with one
known affine root splits completely.  The same is true of the admissible
sections \(n_1=0\) and \(n_2=0\), but those sections retain a deleted point
rather than collide with \(Q\).  The retained third point occurs in all four
planes.  The
other retained six-point sets are pairwise disjoint and partition the
complement of the line by (5).  For a fixed affine point \(r\), the cleared
value of the replacement quadratic \(S_\kappa(r)\) has degree at most two in
\(\kappa\).  Hence a collision with a fixed point can occur for at most two
pencil values unless that evaluation polynomial vanishes identically.

This degree statement alone is not enough: the six off-line retained points
change with \(\kappa\), and an identically vanishing collision requires a
separate exclusion.  Formula (5), rather than seven unrelated collision
tests in each plane, is the correct starting point for that exclusion.
In particular, every genuine collision is already on the
square-discriminant locus.  The final lemma must prove the existence of a
nonzero square point whose two roots avoid the seven roots of \(Q\), not
merely the existence of a square value of (14).  It must not subtract the
two admissible sections \(n_1n_2=0\).

### The rational sections are one-point switches

There is a useful direct form of those two sections.  Return for a moment to
an arbitrary affine plane

\[
 P(t)=t^9+At^3+Bt+C
\]

and put

\[
 \mathcal Z=z_3A,\qquad \mathcal R=z_2B+z_4A,
 \qquad
 \phi(x)=z_2(x^6+A)+z_3x^5+z_4x^4+z_5x^3
               +z_6x^2+z_7x+z_8.                    \tag{16a}
\]

Assume \(\mathcal Z\ne0\), set \(y=\mathcal R/\mathcal Z\), and remove one
root \(x\) of \(P\).  Then

\[
       g(t)=(t-y)\frac{P(t)}{t-x}                     \tag{16b}
\]

satisfies both Hankel equations if and only if

\[
       (x-y)\phi(x)+\mathcal Z=0,
\quad\text{equivalently}\quad
       \phi(x)(\mathcal Zx-\mathcal R)+\mathcal Z^2=0. \tag{16c}
\]

Indeed, the quotient column is
\((x\phi(x)+\mathcal Z,\phi(x))\), and the residual of \(P\) is
\((\mathcal R,\mathcal Z)\).  The second equation forces the coefficient
\(x-y=-\mathcal Z/\phi(x)\); the first then says exactly
\(y=\mathcal R/\mathcal Z\).  If \(y\notin P\), (16b) is already a split
squarefree nine-point locator.  In the two-point notation this is precisely
\(n_1=0\) or \(n_2=0\).

For a fixed plane direction the three parallel planes have the same
\(A,B,\mathcal R,\mathcal Z\), hence the same incoming point \(y\), and
(16c) is one polynomial of degree at most seven on all of \(K\).  The point
\(y\) lies in exactly one parallel plane and never solves (16c), since its
left side is \(\mathcal Z^2\).  Thus any root of (16c) outside the plane
containing \(y\) closes the syndrome by a one-point switch.  Root existence
or escape from that plane is not automatic; this is a clean first branch,
not a universal proof.

## 4. Red-team boundary and next identity

### The Tao-style global incidence ledger

Let \(\mathcal B\) be the set of triples consisting of an affine
\(\mathbf F_3\)-line, an unordered pair on that line, and one of the four
containing planes.  Then

\[
                  |\mathcal B|=117\cdot3\cdot4=1404.     \tag{17}
\]

The pencil bounds give a uniform global supply of nonsingular switches.

1. If \(z_2\ne0\), every one of the 351 removed pairs has at least two
   nonsingular containing planes, so \(|\mathcal B_{\rm ns}|\ge702\).
2. If \(z_2=0\) and \(z_3\ne0\), the polynomial \(F\) has at most five
   zeros.  At most \({5\choose2}=10\) pairs consist of two zeros; every other
   pair has at least three nonsingular planes.  Hence
   \(|\mathcal B_{\rm ns}|\ge(351-10)3=1023\).
3. If \(z_2=z_3=0\), \(F\) has at most four zeros.  At least
   \({23\choose2}=253\) pairs have two nonzero values, and all four
   containing planes are nonsingular.  Hence
   \(|\mathcal B_{\rm ns}|\ge1012\).

For a nonsingular candidate \(b\), let \(\chi(\Delta_b)\) be the quadratic
character of (14), extended by \(\chi(0)=0\).  If \(Z_\Delta\) is the number
of zero discriminants, the number of distinct split replacement quadratics
before collision removal is exactly

\[
 N_{\rm split}
 =\frac{|\mathcal B_{\rm ns}|
          +\sum_{b\in\mathcal B_{\rm ns}}\chi(\Delta_b)-Z_\Delta}{2}.
                                                                    \tag{18}
\]

Thus the remaining theorem should be attacked globally: prove that (18)
exceeds the number of candidates on the **genuine** collision divisor.  The quartic
resultant (12) is the four-point local norm in each fibre of this incidence
sum.  An average or energy inequality over all 117 lines can succeed even
when no single pencil has a forced square by parity alone.

Proved here:

1. the four-plane factorization (2)--(5);
2. affine dependence (9) and the quadratic determinant (10);
3. universal switch-matrix nonsingularity, with at least two containing
   planes for a suitable removed pair; and
4. the explicit degree-at-most-four discriminant/norm forms (13)--(15), the
   resultant gate (12), and the one-point rational-section lemma
   (16a)--(16c).

Not proved here: that one of the nonsingular pencil values gives a nonzero
square discriminant, or that its roots avoid the corresponding retained
seven-point set.  Four nonsquare discriminants have square product, so a
square resultant by itself proves nothing.  The next useful identity must
show either that (12) is a nonsquare in every no-collision case, forcing a
mixture of characters, or that the four replacement quadratics satisfy a
reciprocity relation incompatible with four nonsplit values.

This is a genuine compression of the universal switch, not GF(27) closure.
The former fixed-direction nonsingularity lemma is now redundant: the sole
remaining assertion is that some nonsingular pencil value has a split,
distinct replacement pair avoiding its seven retained points.
