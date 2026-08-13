# C907 hyperplane-orbit theorem for the residual Gamma marking

**Lane:** clebsch

**Status:** theorem-grade integral algebra for the marked toric-pilot target.
Once the four localized residual thimbles are identified with a
semiorthonormal Euler basis which is a cyclic orbit for the integral
hyperplane action, their Gram matrix is forced to be the Beilinson
\(\mathbf P^3\) matrix.  However, the remaining point-class centralizer
shear preserves the hyperplane orbit and that entire Gram matrix.  It is
therefore invisible to the localized Stokes/Euler pairing and changes only
the individual Gamma/central-connection marking.

This does not construct the missing satellite-to-localized comparison.  It
sharpens its role: that comparison is needed to fix one integral vector, not
to prove the Beilinson Gram once the hyperplane-orbit hypothesis is available.

## 1. Exact hypotheses

Let \(\Lambda\) be a free rank-four integral lattice with a bilinear Euler
form \(\chi\), and let \(H\in\operatorname{Aut}(\Lambda)\) be an isometry:

\[
 \chi(Hx,Hy)=\chi(x,y). \tag{1}
\]

Suppose \(v\in\Lambda\) has cyclic hyperplane orbit

\[
 e_i=H^iv\quad(0\leq i\leq3), \tag{2}
\]

which is an integral basis, and that

\[
 (H-1)^4=0. \tag{3}
\]

The cyclic-basis condition makes the degree-four relation in (3) the
relevant hyperplane relation, rather than a lower-rank quotient.  Finally
suppose this ordered orbit is semiorthonormal:

\[
 \chi(e_i,e_i)=1,\qquad \chi(e_i,e_j)=0\quad(i>j). \tag{4}
\]

These are exactly the finite algebraic data carried by the ordered
Beilinson orbit \(\mathcal O,\mathcal O(1),\mathcal O(2),\mathcal O(3)\).
They are stronger than merely having four critical points cyclically
permuted by a loop: the hyperplane action is an infinite unipotent orbit, and
the fourth successor is constrained by (3).

## 2. The Gram matrix is forced

Write

\[
 a=\chi(e_0,e_1),\qquad b=\chi(e_0,e_2),\qquad
 c=\chi(e_0,e_3). \tag{5}
\]

By (1), all entries above the diagonal depend only on the difference of
indices.  Applying (3) to \(e_0\) gives

\[
 e_4=-e_0+4e_1-6e_2+4e_3. \tag{6}
\]

Now (1), (4), and (6) successively give

\[
 \begin{aligned}
 a
 &=\chi(e_2,e_3)
  =\chi(e_3,e_4)=4,\\
 b
 &=\chi(e_1,e_3)
  =\chi(e_2,e_4)=-6+4a=10,\\
 c
 &=\chi(e_0,e_3)
  =\chi(e_1,e_4)=4-6a+4b=20.
 \end{aligned} \tag{7}
\]

Hence

\[
 \bigl(\chi(e_i,e_j)\bigr)_{0\leq i,j\leq3}
 =
 \begin{pmatrix}
 1&4&10&20\\
 0&1&4&10\\
 0&0&1&4\\
 0&0&0&1
 \end{pmatrix}. \tag{8}
\]

Thus, after the usual directed-order convention, the Beilinson Gram is not
an additional analytic calculation.  It follows from a marked hyperplane
orbit plus semiorthonormality.  Reversing the directed order gives the
transpose convention.

## 3. The point-class shear is an integral isometry

Put

\[
 \omega=(1-H)^3e_0=e_0-3e_1+3e_2-e_3. \tag{9}
\]

Equation (3) implies \(H\omega=\omega\).  From (8),

\[
 \chi(e_i,\omega)=-1,\qquad
 \chi(\omega,e_i)=1,\qquad
 \chi(\omega,\omega)=0
 \quad(0\leq i\leq3). \tag{10}
\]

For every \(r\in\mathbf Z\), the integral automorphism

\[
 S_r=1+r(1-H)^3 \tag{11}
\]

commutes with \(H\); its inverse is \(1-r(1-H)^3\), since
\((1-H)^6=0\).  It sends the orbit to

\[
 e_i'=S_re_i=e_i+r\omega. \tag{12}
\]

Using (10) gives

\[
 \chi(e_i',e_j')
 =\chi(e_i,e_j)
 +r\chi(\omega,e_j)+r\chi(e_i,\omega)
 +r^2\chi(\omega,\omega)
 =\chi(e_i,e_j). \tag{13}
\]

Therefore \(S_r\) preserves all of (1)--(4) and the forced matrix (8).
It changes the chosen cyclic generator by the fixed vector \(r\omega\).
In the \(\mathcal O,\mathcal O(1),\ldots\) convention,
\(\omega=-[\mathcal O_p]\); after reversing the hyperplane convention it is
the usual point class.  This is exactly the residual centralizer ambiguity

\[
 1+r(1-x)^3. \tag{14}
\]

It is a genuine integral ambiguity, not a rational artifact.

## 4. Consequence for the toric pilot

The following conditional implication is now exact.

> **Hyperplane-orbit Gamma theorem.**  Suppose the four labelled
> value-localized residual thimbles are carried by an integral comparison to
> a semiorthonormal Euler basis \((e_0,e_1,e_2,e_3)\) of the residual Orlov
> block, and suppose the signed base-hyperplane continuation carries
> \(e_i\) to \(e_{i+1}\) with the relation (6).  Then their directed Stokes
> Gram is (8), up to the declared order/transposition convention.
>
> The comparison is still determined only up to the shear (11).  In
> particular, the Gram, the hyperplane orbit, formal monodromy, and the
> integral Euler pairing cannot select the individual image of \(e_0\).

The first clause is useful only after a genuine analytic comparison carries
the localized thimble pairing to the Euler pairing.  The existing residual
Morse calculation supplies the four local groups and their \(\mathbf P^3\)
pairing after Thom--Sebastiani; the global Iritani satellite block supplies
the Orlov hyperplane orbit.  Neither currently supplies the marked integral
map which makes them the same orbit.

Consequently the remaining map is precisely the six-part marked
satellite-to-localized theorem in the C907 monodromy-normalized Gamma-seed
note.  Its inverse-loop calculation must fix the value of \(r\), expected to
be zero in the monodromy-normalized seed.  No computation of the Stokes Gram
alone can do so, because (13) makes every \(r\) Gram-invisible.

## 5. Scope boundary

The theorem does not infer (2), (4), or the Euler/thimble identification from
critical values, from the number four, or from a semiorthogonal decomposition.
Those would reintroduce the marking gap already isolated by the source audit.
It says only:

- if the marked hyperplane orbit is genuinely present, its Gram is forced;
  and
- after that, a point-class shear remains unobservable to the Gram.

Thus the appropriate remaining analytic calculation is a single
monodromy-normalized central-connection coordinate, not another finite
Euler-lattice mutation or unmarked Stokes-matrix calculation.

## EJ/TT and mystery ledger

- **EJ:** the Beilinson numbers \(4,10,20\) are a three-line consequence of
  hyperplane invariance and semiorthonormality.  The analytic work should
  concentrate on the one surviving point-class coordinate.
- **TT:** an isometry centralizing the hyperplane orbit can preserve every
  Stokes/Euler entry while moving the initial Gamma vector.  A Gram match is
  necessary but cannot be a marking theorem.
- **Settled:** the exact conditional Beilinson Gram theorem and integral
  invisibility of \(1+r(1-H)^3\).
- **Open:** the integral, loop-equivariant satellite-to-localized comparison
  that evaluates \(r\).
