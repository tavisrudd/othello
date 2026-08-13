# C907 — opposite attack on m=2 rationality

Date: 2026-08-13

Status: adversarial construction audit. No rationality or irrationality
theorem is claimed here. The purpose is to isolate what a positive proof that
\(X\times\mathbf P^2\) is rational would actually have to do.

## 1. Target and current external boundary

For a smooth complex cubic threefold \(X\),

\[
 X\times\mathbf P^2\text{ rational}
 \quad\Longleftrightarrow\quad
 \mathbf C(X)(u,v)\cong\mathbf C(t_1,\ldots,t_5).
\]

This is a stable-rationality assertion, not merely stable unirationality.
Engel--de Gaay Fortman--Schreieder now prove stable irrationality for a very
general cubic threefold by nonalgebraicity of the minimal curve class on its
intermediate Jacobian. That theorem does not include every smooth cubic.
Special cubic threefolds with universally trivial \(CH_0\), including the
special family used elsewhere in this programme, remain legitimate targets
for the opposite construction.

## 2. Projection from a line does not split after stabilization

Choose coordinates \([x_0:x_1:x_2:u:v]\) with a line
\(\ell=\{x_0=x_1=x_2=0\}\subset X\). Write

\[
 F=u^2L_0(x)+uvL_1(x)+v^2L_2(x)
   +uQ_0(x)+vQ_1(x)+C(x).
\]

Projection from \(\ell\) resolves to a conic bundle over
\(\mathbf P^2_x\). Over \(a\in\mathbf P^2\), its conic is

\[
 L_0(a)u^2+L_1(a)uv+L_2(a)v^2
 +w(Q_0(a)u+Q_1(a)v)+C(a)w^2=0.
\]

The determinant of the associated symmetric matrix is a plane quintic.
Over \(K=\mathbf C(\mathbf P^2_x)\), the generic conic is represented by a
quaternion Clifford class \(\alpha\in\operatorname{Br}K[2]\). Adding the
independent stabilizing variables gives the same conic over \(K(s,t)\).
The map

\[
 \operatorname{Br}K\longrightarrow\operatorname{Br}K(s,t)
\]

is injective. Therefore \(\alpha\) splits over \(K(s,t)\) if and only if it
already split over \(K\). The product factor cannot supply a rational section
of the projection conic bundle merely by being appended independently.

This eliminates the naive positive construction, not every mixed birational
map.

There is also an exact norm-form compression. Put

\[
 A=L_0,\quad B=L_1,\quad C=L_2,\quad
 D=Q_0,\quad E=Q_1,\quad G=C_3,
\]

where \(C_3\) denotes the cubic coefficient previously written \(C\), and
write \(\delta=B^2-4AC\), \(\Delta=\det M\). Completing the square first in
\(u\) and then in \(v\) gives, on \(w=1\),

\[
 U^2-\delta V^2=\frac{16A\Delta}{\delta}.
\]

The identity behind the right side is

\[
 \delta(4AG-D^2)+(2AE-BD)^2=-16A\Delta.
\]

Thus the rational quadratic cover \(K(\sqrt\delta)/K\) chooses a point and
splits the conic, while the descent coefficient still carries the quintic
discriminant \(\Delta\). This separates the favorable part of the opposite
route from its actual obstruction in one formula.

### Fermat benchmark

For the Fermat cubic, take the line
\(x_0=-x_1\), \(x_2=-x_3\), \(x_4=0\), and write

\[
 (x_0,x_1,x_2,x_3,x_4)=(u,a-u,v,b-v,c).
\]

Then

\[
 F=3au^2-3a^2u+a^3+3bv^2-3b^2v+b^3+c^3.
\]

With \(U=2u-a\), \(V=2v-b\), the conic bundle becomes

\[
 3aU^2+3bV^2+a^3+b^3+4c^3=0,
\]

and its two discriminants factor exactly as

\[
 \delta=-36ab,
 \qquad
 \Delta=\frac94ab(a^3+b^3+4c^3).
\]

This is the smallest explicit positive test. The point-choosing cover has
reducible branch, and the quintic descent divisor compresses to two lines
plus a plane cubic. No rational parametrization follows from the
factorization, but any genuine two-variable cancellation should be visible
here before it can be expected for the full special locus.

## 3. Degree-two unirationality remains degree two

Projection from a point gives, after writing

\[
 F(x_0,x)=x_0^2\ell(x)+x_0q(x)+c(x),
\]

the residual quadratic equation

\[
 \ell(a)\lambda^2+q(a)\lambda+c(a)=0,
 \qquad \Delta=q(a)^2-4\ell(a)c(a).
\]

Equivalently, a standard degree-two unirational parametrization gives a
quadratic field extension

\[
 \mathbf C(\mathbf P^3)=\mathbf C(X)(\sqrt d).
\]

Since a field is relatively algebraically closed in a purely transcendental
extension, nonsquare \(d\) remains nonsquare in \(\mathbf C(X)(s,t)\). Thus
the construction only produces a degree-two rational cover

\[
 \mathbf P^5\dashrightarrow X\times\mathbf P^2.
\]

Secant and tangent identities manipulate the conjugate pair but do not select
one residual root rationally. Again, this is stable unirationality rather than
stable rationality.

## 4. The quotient formulation gives a positive lead

The same degree-two map writes \(X\) birationally as \(R/\langle\tau\rangle\)
for a rational threefold \(R\) and a birational involution \(\tau\). There is
an especially concrete description from the chosen line. The residual conic
meets \(\ell\) in the roots of

\[
 L_0(a)u^2+L_1(a)uv+L_2(a)v^2.
\]

Let \(S\to\mathbf P^2_a\) choose one root. For a general line, its branch
equation \(L_1^2-4L_0L_2=0\) is a smooth conic, so \(S\) is a rational
quadric surface. The
base-changed conic bundle has the tautological chosen root as a section and
is rational. Birationally,

\[
 R=\operatorname{Bl}_\ell X\times_{\mathbf P^2}S
   \sim \mathbf P(T_X|_\ell),
\]

and \(X=R/\langle\tau\rangle\), where \(\tau\) is descent along
\(S/\mathbf P^2\). Equivalently, in the line-tangent construction one may
take

\[
 R=\mathbf P(T_X|_\ell),
\]

a rational \(\mathbf P^2\)-bundle over \(\ell\cong\mathbf P^1\). Over a
general \(x\in X\), the two preimages correspond to the two intersection
points of the residual conic with \(\ell\).

The ramification divisor is the restriction of the original conic bundle to
the branch conic of \(S\to\mathbf P^2\). It is a conic bundle over
\(\mathbf P^1\), hence is rational over \(\mathbf C\) by Tsen's theorem.
Thus the most elementary stable-linearization obstruction—the birational type
of a divisorial fixed component—does not fire.

For a general line, the branch conic \(B\) meets the plane-quintic
discriminant \(\Delta\) transversely in ten points. The fixed divisor \(D\)
is therefore a smooth rational conic-bundle surface with ten reducible
fibres. Its exact calibration is

\[
 K_D^2=8-10=-2,
 \qquad
 N_{D/R}\cong \pi_D^*\mathcal O_{\mathbf P^1}(2),
\]

and \(\tau\) acts by \(-1\) on this normal line. The square of the normal
bundle is the pullback of
\(N_{B/\mathbf P^2}=\mathcal O_{\mathbf P^1}(4)\), as required for a double
cover ramified along \(D\).

Although \(D\) is rational, its conic-bundle marking retains the quintic.
The restricted determinant is a section of
\(\mathcal O_B(5)\cong\mathcal O_{\mathbf P^1}(10)\). Taking its square root
defines the discriminant double cover

\[
 C_B\longrightarrow B\cong\mathbf P^1
\]

branched at the ten points \(B\cap\Delta\); hence \(g(C_B)=4\). This is not
the relative component scheme of the singular conics, which exists only over
the ten-point discriminant. It is the hyperelliptic orientation cover of the
marked determinant. It is the first plausible finer equivariant marker missed
by the bare birational type of the fixed divisor, but is not yet proved to
survive equivariant stabilization.

The positive problem is therefore sharpened to

\[
 \text{is }(R\times\mathbf P^2,\tau\times1)
 \text{ stably linearizable enough that its quotient is rational?}
\]

No such linearization has been constructed. A diagonal action on a faithful
two-dimensional representation is nevertheless a legitimate route: the
no-name lemma identifies its invariant field with a purely transcendental
extension of \(\mathbf C(X)\). Thus linearizing that diagonal action would
indeed prove stable rationality with at most two added variables. What is not
legitimate is to replace the trivial product action by a diagonal action
without this invariant-field comparison.

There is a new exact negative corollary on the very-general locus. If this
involution were stably linearizable after any representation factor, its
linear quotient would be rational, while the no-name lemma would identify
that quotient birationally with \(X\) times a projective-space factor.
Engel--de Gaay Fortman--Schreieder's stable-irrationality theorem therefore
implies:

> For a very general smooth cubic threefold, the rational tangent-cover
> involution \(\tau\) is not stably linearizable after any finite-dimensional
> representation factor, even though its divisorial fixed component is
> rational.

Thus ordinary fixed-divisor birational type misses a genuine stable
equivariant obstruction. For a universally \(CH_0\)-trivial special cubic,
this corollary does not apply; that is exactly where a positive
two-variable linearization could still exist.

## 5. Codimension-three Cayley trick

The number two also appears naturally in a codimension-three incidence
construction. Let \(F\) be the cubic equation of
\(X\subset\mathbf P^4\), choose two further cubic forms \(G_0,G_1\), and
define the incidence hypersurface

\[
 H=\left\{(x,[a:b:c])\in\mathbf P^4\times\mathbf P^2:
 aG_0(x)+bG_1(x)+cF(x)=0\right\}.
\]

Projection to \(\mathbf P^4\) has generic fibre \(\mathbf P^1\), so \(H\) is
rational. Over the codimension-three complete intersection

\[
 Z=\{G_0=G_1=F=0\}\subset\mathbf P^4
\]

the fibre jumps to \(\mathbf P^2\). Thus \(Z\times\mathbf P^2\) occurs
exactly as the maximal rank-jump stratum inside a rational fivefold.

For a general choice, however, \(Z\) is a curve, not the cubic threefold
itself. Requiring all three cubic equations to vanish on the hypersurface
\(X\) forces all of them to be scalar multiples of \(F\), so the incidence
equation acquires a common factor and ceases to be the clean rational
hypersurface above. Consequently the Cayley trick explains why two
stabilizing parameters are geometrically natural, but it does not yet
birationally extract \(X\times\mathbf P^2\).

## 6. AA / EJ / TT

- **AA:** the opposite theorem survives only in the universal-\(CH_0\)-trivial
  special locus. It is already false for a very general cubic. Independent
  variables cannot split either the conic Clifford class or the quadratic
  discriminant, so a successful map must entangle the new coordinates with
  the cubic.
- **EJ:** the rational ramification surface is the first genuinely favorable
  datum. It moves the positive route from blind stable cancellation to one
  concrete equivariant problem: two-variable stable linearization of the
  tangent-cover involution. More intrinsically, the rational cover \(S\)
  trivializes the conic by choosing one intersection point, so the whole
  problem is descent of one tautological section. The codimension-three
  incidence model is the second favorable datum and makes the number two
  structural.
- **EJ theorem:** on the very-general locus, the same construction gives a
  rational involution with rational divisorial fixed locus which is provably
  not stably linearizable. This is an equivariant reformulation of the new
  stable-irrationality theorem and a calibrated target for a finer invariant.
- **EJ marker:** the rational fixed divisor has ten marked singular fibres
  and a canonical genus-four determinant cover. The quintic therefore survives
  fixed-divisor rationality as marked descent data.
- **TT:** a degree-two parametrization is not a birational parametrization;
  a rational fixed divisor is not stable linearizability; an incidence
  fivefold containing \(X\times\mathbf P^2\)-shaped fibres is not a
  birational model of that product. Each confusion would falsely prove a
  long-open special-case theorem.

## 7. Updated odds after the opposite attack

For every smooth cubic, the classical positive route is now below five
percent because the theorem is known false very generally. For a special
universally \(CH_0\)-trivial cubic, this audit assigns roughly fifteen percent
to an actual rationality construction through stable linearization or a
refined Cayley trick, and roughly eighty-five percent that the same analysis
instead produces a new equivariant or rank-jump obstruction useful to the
negative \(m=2\) programme.

The next exact calculation is the resolved fixed-locus and normal-character
data of the involution on \(\mathbf P(T_X|_\ell)\), followed by the rank-jump
exceptional divisor in the Cayley model. Those are the first places where a
two-variable cancellation could be proved or decisively fail.

## Mystery ledger

- **Settled by AA:** independent stabilizing variables do not split the
  conic Brauer class or either quadratic cover; raw secant and tangent maps
  remain degree two.
- **Settled by EJ:** the point-choosing cover is a rational quadric surface,
  its ramification surface is rational, and the very-general involution is
  nevertheless not stably linearizable. For a general line the fixed surface
  has \(K^2=-2\), sign normal character, ten singular fibres, and a genus-four
  determinant cover. The Fermat norm equation and both discriminant
  factorizations are explicit.
- **Open:** whether the Fermat descent cocycle becomes linear after two
  representation variables. The evidence gap is an explicit equivariant
  resolution and its normal-character symbols.
- **Open:** whether the genus-four determinant cover is invariant under the
  allowed equivariant stabilizations. Bare fixed-field and fixed-divisor
  birational invariants forget it.
- **Open:** whether the Cayley rank-jump exceptional divisor admits a second
  contraction whose generic fibre trades the complete-intersection curve for
  the cubic product. The present incidence model alone does not.
- **Unexplained:** the same number two is selected independently by stable
  linearization and by the codimension-three incidence fibre \(\mathbf P^2\).
  No map relating the two mechanisms is known.

## Sources

- Philip Engel, Olivier de Gaay Fortman, and Stefan Schreieder, *Matroids
  and the integral Hodge conjecture for abelian varieties*,
  arXiv:2507.15704v3, Theorem 1.3 and its cubic-threefold corollary.
- Claire Voisin, *On the universal \(CH_0\) group of cubic hypersurfaces*,
  arXiv:1407.7261v2, Theorems 1.6 and 1.7.
- C. H. Clemens and P. A. Griffiths, *The intermediate Jacobian of the cubic
  threefold*, Annals of Mathematics 95 (1972), 281–356.
