# C705 — Coble cubic/sextic mixed-Jacobian gate

**Date:** 2026-07-30  
**Status:** exact positive restriction, negative ambient sister gate  
**Scope:** the Coble cubic/sextic and its \(\tau^\pm\) fixed-space restrictions

## Verdict

The Coble pair is an **elder parent with inherited shadows**, not another
ambient sister of the C705 type.

The ambient obstruction is exact and occurs at criterion 3.  At a smooth
rational Burkhardt parameter the Hessian of the Coble cubic is generically
nonsingular on the cubic.  A separate reconstruction of its dual Coble
sextic over \(\mathbf F_{101}\) gives a dual point at which both Hessians are
nonsingular.  Consequently the raw mixed differential
\[
 \operatorname{Hess}(C_6)(\nabla C_3(x))\,
 \operatorname{Hess}(C_3)(x)
\]
has rank \(9\), not corank one.

The Segre--Igusa relation is nevertheless recovered exactly on the
\(\tau^+\) fixed space:
\[
 \gamma_+^{\mathsf T}\operatorname{Hess}(C_3)(\gamma_+y)\gamma_+
 =\operatorname{Hess}(S)(y).
\]
This is the literal chain rule for \(S=C_3\circ\gamma_+\), and Nguyen's
fixed-space theorem identifies the corresponding polar restriction with
the Segre-to-Igusa map.  Thus C705 is a special linear-section shadow of the
Coble duality, but its corank-one adjugate mechanism is created by the
restriction and normalization; it is not inherited from a corank-one
ambient Coble mixed Jacobian.

The \(\tau^-\) restriction supplies a second inherited shadow: its quadratic
map has the Weddle quartic as Jacobian determinant, and on that quartic the
Jacobian has generic corank one and rank-one adjugate.  This is structurally
close to C705, but it is a restricted ramification construction rather than
a new independent exceptional sister.

## Exact source equations

Index the nine Schrödinger coordinates by
\((i,j)\in\mathbf F_3^2\).  In Nguyen's normalization the Coble cubic is
\[
\begin{aligned}
G_\alpha(X)={}&\frac{\alpha_0}{3}\sum_bX_b^3\\
 &+2\alpha_1\sum_{\text{horizontal lines}}\prod_{b\in\ell}X_b
 +2\alpha_2\sum_{\text{vertical lines}}\prod_{b\in\ell}X_b\\
 &+2\alpha_3\sum_{\text{slope }1\text{ lines}}\prod_{b\in\ell}X_b
 +2\alpha_4\sum_{\text{slope }-1\text{ lines}}\prod_{b\in\ell}X_b .
\end{aligned}
\]
The coefficient point lies on the Burkhardt quartic
\[
 B(\alpha)=
 \alpha_0^4+8\alpha_0\sum_{i=1}^4\alpha_i^3
 +48\alpha_1\alpha_2\alpha_3\alpha_4=0.
\]
The computation uses the smooth rational point
\[
 \alpha=(6,17,1,-7,-19),
\]
for which
\[
 \nabla B=(-17440,48000,108672,-8448,46272).
\]

Nguyen does not print a comparably short polynomial for the Coble sextic.
The usable exact definitions are:

1. the branch divisor of \(SU_C(3)\to |3\Theta|\);
2. the projective dual of \(G_\alpha=0\); and
3. in the finite-field certificate, the unique degree-six relation found
   in the 43-dimensional Heisenberg-invariant orbit-sum space.

For the third description, an exponent vector
\(e=(e_b)_{b\in\mathbf F_3^2}\), \(\sum e_b=6\), is admissible when
\[
 \sum_b e_b b=0\quad\text{in }\mathbf F_3^2.
\]
Translations of \(\mathbf F_3^2\) give 43 orbits.  The certificate records
the 43 coefficients of
\[
 H_\alpha(Y)=\sum_Oc_O\sum_{e\in O}Y^e
\]
over \(\mathbf F_{101}\).  Sixty exact interpolation points
\((x,\nabla(3G_\alpha)(x))\), with \(G_\alpha(x)=0\), give evaluation rank
42, hence a one-dimensional relation inside this frozen invariant space;
forty separately held-out points vanish on the reconstructed relation.

## Ambient rank obstruction

There is already a characteristic-zero witness on the cubic:
\[
 x=(2,-2,-2,-4,2,2,-3,-1,-3),\qquad G_\alpha(x)=0,
\]
and
\[
 \det\operatorname{Hess}(G_\alpha)(x)
 =-309382232474386432\ne0.
\]
This proves that the Coble-cubic polar differential is generically full
rank along \(G_\alpha=0\).  The distinction between \(G_\alpha\) and the
cleared polynomial \(3G_\alpha\) is load-bearing:
\[
 \det\operatorname{Hess}(3G_\alpha)=
 3^9\det\operatorname{Hess}(G_\alpha).
\]

Independently, the reconstructed dual sextic has a paired
\(\mathbf F_{101}\)-point with
\[
 \det\operatorname{Hess}(3G_\alpha)=72,\qquad
 \det\operatorname{Hess}(H_\alpha)=78.
\]
Their mixed product determinant is \(72\cdot78=61\pmod{101}\), so the
mixed Jacobian has rank \(9\).  This finite-field calculation is an exact
witness for nonvanishing of the relevant universal determinant; it is not
a characteristic-zero formula for every coefficient of \(H_\alpha\).

This is the first failed sister condition.  Lower compounds cannot repair a
full-rank matrix into the C705 corank-one pattern.  One must first restrict
to a fixed space or a ramification divisor.

There is also a coordinate-free explanation.  Write
\(A=\operatorname{Hess}(C_3)_x\), \(B=\operatorname{Hess}(C_6)_y\), and
\(y=\nabla C_3(x)\).  Projective duality gives, on the cone over \(C_3\),
\[
 \nabla C_6(\nabla C_3(x))=\lambda(x)x,\qquad \deg\lambda=9.
\]
Differentiation in an affine tangent direction \(v\) gives
\[
 BA(v)=\lambda v+d\lambda(v)x.
\]
Thus on the eight-dimensional affine tangent space
\[
 BA-\lambda I=x\otimes d\lambda,\qquad
 \det(BA|_{T_xC_3})=10\lambda^8.
\]
The radial line has eigenvalue \(10\lambda\), while the seven-dimensional
projective tangent quotient has eigenvalue \(\lambda\).  The natural mixed
operator is a scalar projective isomorphism with a rank-one radial
deviation—not a corank-one map.

The final `ej` pass found a stronger finite-field identity.  All 100 paired
samples satisfy
\[
 \nabla H_\alpha(\nabla(3G_\alpha)(x))=\lambda(x)x.
\]
For all 97 samples having nonzero source Hessian determinant,
\[
 \frac{\lambda(x)}
 {\det\operatorname{Hess}(3G_\alpha)(x)}=45\quad\text{in }\mathbf F_{101}.
\]
At the frozen mixed witness, direct restriction to
\(\ker(\nabla(3G_\alpha)(x))\) verifies that
\[
 \operatorname{Hess}(H_\alpha)\operatorname{Hess}(3G_\alpha)
 -\lambda I
\]
has rank one and image exactly \(\mathbf F_{101}x\).  This is an exact
finite-field candidate for
\(\lambda=c\det\operatorname{Hess}(C_3)\), with \(c\) depending on the
normalization of the dual sextic; it is not yet promoted to a
characteristic-zero theorem.  The tempting global extension is false:
at five deterministic off-cubic points the ratios
\[
 \frac{H_\alpha(\nabla(3G_\alpha))}
 {(3G_\alpha)\det\operatorname{Hess}(3G_\alpha)}
\]
are \(72,25,99,88,54\), not a constant.

## The \(\tau^+\) Segre--Igusa restriction

The plus inclusion is
\[
\gamma_+(y_0,\ldots,y_4)=
(y_0,y_1,y_1,y_2,y_3,y_4,y_2,y_4,y_3).
\]
Nguyen proves that \(S=G_\alpha\circ\gamma_+\) cuts out the Segre cubic and
that the global Coble polar map restricts to its small polar map.  The exact
Hessian block is therefore the compressed block
\[
\gamma_+^{\mathsf T}\operatorname{Hess}(G_\alpha)\gamma_+,
\]
not an unweighted principal \(5\times5\) submatrix.  With this intrinsic
inclusion/dual-projection convention it is **exactly**
\(\operatorname{Hess}(S)\), with no scalar.

On the dual side Nguyen's scheme-theoretic fixed-space formula is
\[
 C_6\cap\mathbf P^4_+=I_4+2V_0.
\]
Thus the Igusa quartic is accompanied by the double fixed hyperplane.  This
is the precise restriction/fixed-factor phenomenon anticipated by the C705
\(B_3\) normalization, but only at slice level: the factor here is
\(V_0^2\) on one fixed \(\mathbf P^4\), not an identified copy of the global
\(E_6\) divisor \(B_3\).

Bolognesi--Brivio, Proposition 6.8, gives the necessary boundary on this
statement.  A general Igusa fiber in their Coble-sextic fibration maps to a
Segre cubic only after a canonical projection from a distinguished linear
subsystem.  The \(\tau^+\) fixed \(\mathbf P^4\) above is therefore the
literal polar restriction; the general-fiber construction is a projected
relative version, not the same linear section.

## The \(\tau^-\) Weddle--Kummer restriction

The minus inclusion is
\[
\gamma_-(z_0,z_1,z_2,z_3)=
(0,z_0,-z_0,z_1,z_2,z_3,-z_1,-z_3,-z_2).
\]
After omitting the dependent plus coordinate, the restricted polar map
\(\mathbf P^3_-\dashrightarrow\mathbf P^3\) is given by
\[
\begin{aligned}
Q_0={}&\alpha_0z_0^2-2\alpha_2z_2z_3
       -2\alpha_3z_1z_3-2\alpha_4z_1z_2,\\
Q_1={}&\alpha_0z_1^2+2\alpha_1z_2z_3
       +2\alpha_3z_0z_3-2\alpha_4z_0z_2,\\
Q_2={}&\alpha_0z_2^2+2\alpha_1z_1z_3
       -2\alpha_2z_0z_3+2\alpha_4z_0z_1,\\
Q_3={}&\alpha_0z_3^2+2\alpha_1z_1z_2
       +2\alpha_2z_0z_2-2\alpha_3z_0z_1.
\end{aligned}
\]
Therefore
\[
 W_\alpha(z)=\det\!\left(\frac{\partial Q_i}{\partial z_j}\right)
\]
is an exact quartic equation for the ramification surface.  For the frozen
rational \(\alpha\),
\[
\begin{aligned}
W_\alpha/768={}&566z_0^3z_1-44z_0^3z_2+241z_0^3z_3
-250z_0z_1^3-545z_0z_1z_2z_3\\
&-250z_0z_2^3-250z_0z_3^3+44z_1^3z_2+241z_1^3z_3\\
&+566z_1z_2^3-566z_1z_3^3-241z_2^3z_3-44z_2z_3^3.
\end{aligned}
\]
SymPy factors the primitive quartic as one irreducible degree-four factor
over \(\mathbf Q\).  Independently, reduction modulo \(11\) gives one
nonconstant quartic factor of multiplicity one, a compact Gauss-lemma
certificate.  The Jacobian is invertible at a generic witness and has rank
\(3\) at \(z=(0,0,0,1)\); there its adjugate is nonzero of rank one and is
annihilated on both sides by the Jacobian.

Nguyen identifies this ramification surface as the Weddle quartic and the
branch surface as the associated Kummer quartic.  Hence the rank-one
adjugate is real but inherited.  If
\(\operatorname{adj}(dQ)=r\ell^{\mathsf T}\), then \(r\) is the right-kernel
fold direction in the Weddle source, while \(\ell\) is the left-kernel
Kummer conormal in the target.  Only the latter is a polar factor.  Unlike
C705, the two factors are not two exceptional polar carriers.

The symmetric Burkhardt point \((2,2,2,2,-1)\) is useful as a sanity check
but not as the generic Weddle witness: its quartic determinant factors as
degrees \(1+1+2\).  This negative is revealing—it detects a special
high-symmetry locus that the full-rank ambient Hessian alone does not
exclude.  No decomposability conclusion is asserted from this factorization
alone.

## Reproduction

Primary standard-library computation:

```sh
cd /home/tavis/src/othello/rust
python3 ../notes/2026-07-30-c705-coble-mixed-jacobian.py --check
```

Independent characteristic-zero SymPy replay:

```sh
cd /home/tavis/src/othello/rust
nix-shell -p python3 python3Packages.sympy --run \
  'python3 ../notes/2026-07-30-c705-coble-mixed-jacobian-replay.py'
```

Independent mod-\(11\) irreducibility certificate:

```sh
cd /home/tavis/src/othello/rust
nix-shell -p singular --run \
  'Singular -q ../notes/2026-07-30-c705-coble-weddle-mod11.sing'
```

The primary computation fixes \(\mathbf F_{101}\), the rational parameter
\(\alpha\), deterministic SHA-256-derived sample coordinates, the
43-dimensional orbit basis, and all normalization conventions.  It checks
the reconstructed sextic relation, both Hessian determinants, the mixed
rank, the plus compression, and the minus rank witnesses.  The replay does
not import the primary script: it rebuilds \(G_\alpha\) over \(\mathbf Q\),
checks the exact Hessian determinant, proves the plus compression
symbolically, derives the four minus quadrics, checks irreducibility of the
Weddle determinant, and verifies the rank-one adjugate.

The finite sample does not by itself prove a presentation theorem for the
full characteristic-zero Coble sextic.  Its role is the bounded exact
mixed-rank obstruction, backed by the literature theorem that the dual is a
Heisenberg-invariant sextic.

`2026-07-30-c705-coble-mixed-jacobian.sha256` records the load-bearing
hashes.  Byte counts in manifest order are
\(16434,3782,2610,1198,15672\).

## Literature boundary

Three sources were consulted.  The formula and restriction statements were
checked against Quang Minh
Nguyen, *Vector bundles, dualities, and classical geometry on a curve of
genus two*, arXiv:math/0702724, especially §§2.1, 2.2, 3.3, and
4.1--4.4.  Cached PDF SHA-256:
`93e0fb99b62a6b5f9c2229791b98b785e2946942e5946935ad7c4282311ab90b`.

Nguyen supplies the ambient duality, the cubic equation, the fixed-space
maps, \(C_6|_{\mathbf P^4_+}=I_4+2V_0\), and the Weddle--Kummer
identification.  The explicit ambient mixed-rank obstruction and its
comparison with the C705 sister criterion are C705 computations, not claims
attributed to Nguyen.

Read-depth markers:

- Nguyen, arXiv:math/0702724 — **partial**, cached full text read at formula level in
  §§2.1, 2.2, 3.3, and 4.1--4.4.
- Dolgachev--Lehavi, *On isogenous principally polarized abelian surfaces*,
  arXiv:0710.1298 — **partial**, §4.1 read at formula level for the Burkhardt equation
  and Schrödinger-coordinate Coble model; cached SHA-256
  `0dcfa76fdac989d5ede8025a7251ebf96a77a3d4c02b20b932dc6b51f716fd1e`.
- Bolognesi--Brivio, *Modular subvarieties and birational geometry of
  \(SU_C(r)\)*, arXiv:1002.4382 — **partial**, §6.1 through Proposition 6.8
  read at theorem/proof-context level
  for the birational Igusa-quartic fibration of the Coble sextic; cached
  SHA-256
  `21d0dde5e71cf2cfcb58442722d35c2a9c8853b7f60b2dc6be02d285021959b1`.

## Explicit closeout passes

- **ej1:** reconstructed the dual sextic in the smallest Heisenberg orbit
  space and upgraded the one-sided Hessian test to a paired rank-nine mixed
  witness; the final cheap pass also found the constant
  \(\lambda/\det\operatorname{Hess}(C_3)=45\) on 97 exact samples.
- **tt1:** replaced a coordinate principal-block question by the intrinsic
  compression \(\gamma_+^{\mathsf T}H\gamma_+\), which proves exact equality
  with \(\operatorname{Hess}(S)\) by functoriality.
- **ej2:** mined the negative ambient gate into the \(\tau^-\) restriction,
  producing the explicit Weddle determinant and its rank-one adjugate.
- **tt2:** separated the two adjugate factors: the left factor is the Kummer
  conormal, while the right factor is only the fold direction.  This closes
  the taxonomy as elder parent/inherited shadow rather than weakening the
  sister criterion.

## Mystery ledger

- **Settled:** the ambient Coble mixed Jacobian is not generically
  corank one; one paired exact witness has rank \(9\).
- **Settled negative:** the on-cubic proportionality does not extend to a
  simple global identity \(C_6(\nabla C_3)=cC_3\det\operatorname{Hess}(C_3)\);
  five off-cubic ratios are pairwise nonconstant.
- **Settled:** the intrinsic \(\tau^+\) block is exactly
  \(\operatorname{Hess}(S)\); a raw principal submatrix is the wrong
  functorial convention.
- **Settled:** the Weddle quartic carries a corank-one/rank-one-adjugate
  shadow, but only after \(\tau^-\) restriction.
- **Settled:** the highly symmetric Burkhardt parameter is unsuitable for a
  generic Weddle claim because its determinant factors.
- **Open, parameter-specific:** the primitive Weddle quartic splits into
  four linear factors modulo \(7\), while it is irreducible modulo \(11\).
  No structural bad-prime claim is made; explaining this reduction belongs
  to a future arithmetic analysis of this particular Burkhardt parameter.
- **Open:** match the \(\tau^+\) double hyperplane \(2V_0\) directly to the
  \(B_3\) factor in the Naruki first-jet model.  The present evidence shows
  the same fixed-factor shape but not an equality of divisor markings.
- **Open:** derive a compact characteristic-zero 43-orbit coefficient
  formula for the dual sextic as a rational function of \(\alpha\).  It is
  unnecessary for the rank obstruction but would make the elder-parent
  diagram completely explicit.
- **Open:** lift the finite-field identity
  \(\lambda=45\det\operatorname{Hess}(3G_\alpha)\) on \(C_3\) to a
  characteristic-zero conormal identity and determine its normalization
  scalar intrinsically.
