# C907 — coniveau principal-symbol repair

Date: 2026-08-13

Status: exact conditional stable-irrationality telescope and exact analytic
endpoint nonvanishing.
It repairs the point-Gamma collision by replacing support annihilation with a
coherent codimension-two principal symbol. The only remaining theorem is a
rank-framed sectorial Gamma/Orlov blow-up comparison.  The principal symbol
turns out to be precisely its rank functional, so the same conditional theorem
works for every stabilization, not only \(m=2\).

## 1. Why annihilation was the wrong target

The Gamma-framed point on a cubic threefold has nonzero coefficient on both
primitive-sixth formal lines. Therefore no realization can simultaneously

1. identify the total primitive-sixth packet with the ordinary Gamma central
   connection;
2. make the full diagonal \(K_0\)-action objectwise tensor action; and
3. annihilate every coefficient supported in dimension at most two.

Indeed the point kernel sends the Gamma unit to the nonzero Gamma point.
This is an incompatibility theorem, not merely a missing construction.

The support-square proof asked for too much. It needs to distinguish
codimension two from codimension at least three after applying \(N^2\); it
does not intrinsically need the latter contribution to vanish as a vector.

## 2. Coherent symbol datum

Let \(Y\) be a smooth projective fivefold equipped with a morphism
\(f:Y\to\mathbf P^2\), put \(L=f^*\mathcal O(1)\), and let
\(P_6(Y)\) be its formal primitive-sixth packet. A **coherent coniveau-two
lift** consists of a sectorially normalized linear lift

\[
 \ell_Y:P_6(Y)\longrightarrow\mathcal S_\Gamma(Y)
\]

to the full Gamma-framed flat-solution space, together with the principal
symbol

\[
 \sigma_2(Y,f)=
 \operatorname{gr}_{\mathrm{coniv}}^2
 \left((1-\tau_L)^2\ell_Y(P_6(Y))\right).
 \tag{1}
\]

Here coniveau is retained on the full Gamma lattice before formal-primary
projection. Fix one admissible phase throughout the framed comparison. The
required strictness statement is only:

- changes of normalization allowed within that fixed phase alter (1) only by
  coniveau at least three;
- it is block additive under the actual Gamma/Orlov blow-up comparison; and
- projection formula identifies its leading support with intersection by a
  general base point.

No intrinsic point or surface packet is set equal to zero.

## 3. Exact endpoint rank

For a cubic threefold \(X\), use the rational numerical Kuznetsov basis

\[
 v_1=10\mathcal O-5\mathcal O(H)+\mathcal O(2H),
 \qquad
 v_2=41\mathcal O-15\mathcal O(H)+\mathcal O(3H).
\]

The numerical Serre operator is

\[
 S=\begin{pmatrix}5&21\\-1&-4\end{pmatrix},
 \qquad S^2-S+1=0.
\]

For \(\lambda^2-\lambda+1=0\), an eigenvector is

\[
 e_\lambda=-(4+\lambda)v_1+v_2.
\]

Since \(\operatorname{rk}(v_1)=6\) and
\(\operatorname{rk}(v_2)=27\),

\[
 \operatorname{rk}(e_\lambda)=3-6\lambda\ne0,
 \qquad
 \prod_{\lambda^2-\lambda+1=0}(3-6\lambda)=27.
 \tag{2}
\]

If the coherent Gamma lift of the formal branch is normalized by this
residual eigenline, then on \(X\times\mathbf P^2\)

\[
 \operatorname{gr}_{\mathrm{coniv}}^2
 N^2(e_\lambda\otimes1)
 =(3-6\lambda)[X\times\{q\}]\ne0.
 \tag{3}
\]

The norm \(27\) in (2) gives an integral nonvanishing calibration independent
of the choice of primitive-sixth root.

The equality between the numerical residual-Serre eigenline and the
Gamma-normalized formal QDM branch is not supplied by the numerical
calculation.  Nevertheless, the weaker conclusion needed below follows
analytically from the exact point period.

Let \(A_{1/3},A_{2/3}\) be the leading-one algebraic formal solutions of the
cubic hypergeometric equation in one fixed lateral sector.  The Gamma point
solution has expansion

\[
 s(\mathcal O_p)
 =C_{1/3}A_{1/3}+C_{2/3}A_{2/3}
  +\{\text{exponential components}\},
\]

where

\[
 C_{1/3}=\frac{\Gamma(1/3)}{\Gamma(2/3)^4}\ne0,
 \qquad
 C_{2/3}=\frac{\Gamma(-1/3)}{\Gamma(1/3)^4}\ne0.
 \tag{4}
\]

The scalar equation is a cyclic realization of the rank-four connection, so
its sectorial connection coefficients are the coefficients of the
corresponding vector flat sections, up to nonzero branch normalizations.  The
flat pairing pairs the two inverse formal-monodromy lines
nondegenerately and pairs them with no exponential formal component.  Let
\(B_a\) be a sectorial sum of \(A_a\), and write
\(B_a=s(E_a)\) under the complexified Gamma-integral isomorphism.  Pairing the
displayed expansion with the dual algebraic branch, and then relabelling the
two branches, shows

\[
 [s(\mathcal O_p),B_a)\ne0.
\]

Iritani's integral pairing identifies this with
\(\chi(\mathcal O_p,E_a)\).  On a smooth threefold,

\[
 \chi(\mathcal O_p,E_a)=-\operatorname{rk}(E_a),
\]

so both sectorial algebraic branch lifts have nonzero rank.  The Barnes
coefficients do not determine the integer normalization of that rank: they
prove its nonvanishing, which is all the telescope uses.  Formula (2) remains
an exact categorical normalization target; its norm \(27\) is not needed for
the obstruction.

The projected point collision does not contradict (3). Projection to the
formal primary line identifies the asymptotic coefficient of many different
Gamma flat sections. Equation (3) instead follows the specified lift
\(e_\lambda\) through \(N^2\) before projection; a point section is an
incoherent alternative preimage of its formal coefficient.

## 4. Source and factorization symbols

Let \(W\to\mathbf P^5\) resolve the graph and base ideal of a rational map
\(\mathbf P^5\dashrightarrow\mathbf P^2\). The ambient \(\mathbf P^5\)
packet is empty. Every remaining Orlov generator is supported on an
exceptional divisor \(E\). After multiplying by the base-point Koszul class,
its support is

\[
 E\cap f^{-1}(q),
\]

which has dimension at most two. Hence every coherent contribution to
\(N^2\ell_W(P_6(W))\) has coniveau at least three, and

\[
 \sigma_2(W,f)=0.
 \tag{5}
\]

The same dimension count covers every nontrivial center in a relative weak
factorization of fivefolds over \(\mathbf P^2\). A center \(Z\) has dimension
at most three. If it dominates the base, then

\[
 \dim Z_q+\dim\mathbf P^{\operatorname{codim}Z-1}
 = (\dim Z-2)+(4-\dim Z)=2.
\]

If it does not dominate, a general \(q\) avoids it. Thus every added Orlov
packet has zero codimension-two symbol.

## 5. The symbol is only rank

For every \(E\in K^0(Y)\otimes\mathbf C\), the codimension-two term of the
Koszul square is

\[
 \operatorname{gr}_{\mathrm{coniv}}^2((1-L)^2E)
 =\operatorname{rk}(E)[f^{-1}(q)].
 \tag{6}
\]

Twisting by the harmless line-bundle factor which changes
\((1-L)^2\) to \((1-L^{-1})^2\) does not change this leading cycle.  Thus the
whole coniveau-two construction is the rank functional on the coherently
lifted primitive-sixth sector.  In an Orlov blow-up decomposition, pullback
preserves rank and every exceptional component is pushed forward from the
exceptional divisor, hence has ambient rank zero.  Arbitrary mixing inside
the exceptional block is therefore invisible.  The only comparison datum
needed is that the fixed-phase primitive sector is carried to the pullback
sector plus the actual exceptional Orlov subgroup, modulo rank-zero terms.

## 6. Conditional rank-framed theorem

> **Theorem.** Assume that, in one fixed admissible phase, the Gamma-integral
> primitive-sixth sector is product-compatible and every smooth blow-up
> comparison carries it to the pullback sector plus the Gamma images of the
> actual exceptional Orlov components, modulo ambient rank-zero terms.  Then
> \(X\times\mathbf P^m\) is irrational for every smooth cubic threefold
> \(X\) and every \(m\ge0\).

Proof.  On a cubic, the two primitive-sixth sectorial Gamma lifts have
nonzero rank by Section 3.  In the standard projective-space Gamma basis, the
sectorial lifts are the Beilinson line-bundle classes and therefore have rank
one.  Product compatibility consequently gives nonzero-rank
primitive-sixth lifts on \(X\times\mathbf P^m\).  Under a blow-up, the
pullback summand has the same rank functional and all exceptional Orlov
summands have ambient rank zero.  Hence nonvanishing of the rank functional
on the primitive-sixth sector is invariant along weak factorization.
Projective space has empty primitive-sixth sector, a contradiction to
rationality. \(\square\)

For \(m=2\), (6) recovers exactly the source/center coniveau telescope in
Section 4.  The rank form shows that the center-dimension count was more than
was necessary once genuine Orlov support is available.  The theorem does not
require a localizing primitive-sixth coefficient system, vanishing of point or
surface packets, a Jordan decomposition, a carrier theorem, or cancellation
of lower-support extensions.

## 7. Exact remaining gate

The danger is comparison ambiguity. Changing the admissible phase can add
exponential solutions to a zero-exponential branch; if such a change has
nonzero rank, multiplication by the base-point class changes the
codimension-two symbol. The theorem therefore keeps the phase as framing and
asks the blow-up comparisons to preserve it. Even at fixed phase, their
allowed triangular normalization gauges must have \(N^2\)-image in coniveau
at least three. It is not enough to know the formal primary quotient or the
Gamma lattice separately.

The endpoint nonzero-rank clause is now closed.  The sole load-bearing
analytic statement is:

> the fixed-phase blow-up comparison preserves the rank functional on the
> primitive-sixth sector, with every center contribution identified modulo
> rank zero with its exceptional Orlov image, naturally under products.

Full Stokes/Orlov/Gamma compatibility implies this statement, but the formal
QDM decomposition alone does not: its exceptional components can have
nonzero lower-order ambient \(H^0\) corrections in the formal exceptional
parameter, and arrow-specific leading terms do not telescope through weak
factorization.  Iritani proves the general formal decomposition and pairing
compatibility, while explicitly presenting the analytic Stokes/Orlov lift as
an expectation outside the proved toric cases.  The rank-framed statement is
strictly weaker than that full conjecture and is consistent with the nonzero
point central charge.

There is an exact near-miss.  In Iritani's initial-condition formula (5.44),
the ambient top class restricts to zero on every proper center.  Therefore at
\(Q=\widetilde\tau=0\) the formal comparison sends the distinguished point
solution to

\[
 s_{\mathrm{pt}}^Y\oplus0.
 \tag{7}
\]

Connection reconstruction preserves a formally normalized version of (7).
What it does not identify is that formal normalization with the
large-radius Gamma point section after sectorial continuation.  Their
difference can be Stokes-small at the exceptional cusp yet have a nonzero
constant pairing with the dual center branch.  Thus the entire missing
theorem can be recorded as one scalar for each primitive-sixth branch:

\[
 [s_{\mathrm{pt}}^{\operatorname{Bl}_Z Y},
   s_{\mathrm{exc},a})=0.
 \tag{8}
\]

Equation (8), naturally under products and composition, is equivalent to
ambient rank zero for that exceptional branch.  This pinpoints why the
proved formal decomposition is tantalizingly close but does not already
prove the theorem.

The toric \(\operatorname{Bl}_{\mathbf P^3}\mathbf P^5\) pilot is useful for
phase and Orlov normalization but is vacuous for this invariant: both its
base and center have empty primitive-sixth sector.  The first nonvacuous
regression is the codimension-two blow-up
\(\operatorname{Bl}_X\mathbf P^5\), with \(X\subset\mathbf P^4\subset
\mathbf P^5\) cubic.  Its primitive-sixth packet comes entirely from the
center, so the rank-framed theorem predicts that every one of its sectorial
Gamma lifts has ambient rank exactly zero.  One nonzero rank kills the
theorem.

That first regression now passes exactly.  The blow-up is the incidence
hypersurface in
\(\mathbf P_{\mathbf P^5}(\mathcal O(-1)\oplus\mathcal O(-3))\).  Quantum
Lefschetz gives point-period coefficients

\[
 \frac{(k+3d)!}{(d!)^6k!(k+2d)!},
\]

and each fixed-\(d\) exceptional slice is

\[
 \frac{(3d)!}{(d!)^6(2d)!}
 e^R{}_1F_1(-d;2d+1;-R).
\]

The second factor is a degree-\(d\) polynomial.  Thus the algebraic center
connection coefficient is exactly \(1/\Gamma(-d)=0\) in every degree, so the
cubic exceptional packet has zero point pairing and ambient rank.  The same
Kummer zero holds for every smooth codimension-two complete intersection
\((a,b)\subset\mathbf P^n\), with coefficient \(1/\Gamma(-ad)\).  See
`2026-08-13-c907-ci-blowup-point-purity.md`.

This does not close arbitrary centers: weak factorization provides smooth
centers normally crossing a boundary, not necessarily boundary strata with
split normal bundle.

## AA / EJ / TT and mystery ledger

- **AA:** support annihilation is closed as inconsistent with Gamma tensor
  action. The replacement is not another quotient; it is the rank functional
  on a fixed-phase Gamma lift before projection.
- **EJ:** the codimension-two symbol is exactly rank times the general fibre.
  Exceptional Orlov terms have rank zero, so the mechanism immediately
  upgrades from \(m=2\) to a conditional all-\(m\) obstruction.
- **TT:** the formal coefficient of a point can equal the formal coefficient
  of a rank-nonzero lift. Coniveau only distinguishes them before formal
  projection and only when the lift is followed coherently.  The exact
  invariant is the restriction of rank to the sector, not an individual
  normalized eigenvector.  The toric \(\mathbf P^3\)-center pilot is
  primitive-sixth-vacuous; the cubic-center blow-up is the first honest test.
- **Settled:** analytic nonzero rank of both cubic branches, categorical norm
  \(27\) as a calibration target, source and center dimension counts,
  logical sufficiency of the rank-framed theorem, and exact point purity for
  the first nonvacuous cubic-center blow-up and all split
  complete-intersection pilots.
- **Open:** fixed-phase rank compatibility of the general blow-up comparison
  and product naturality for arbitrary centers with nonsplit normal bundle.
  Standard weak factorization does not force the split case.

## Sources

- Hiroshi Iritani, *Gamma classes and quantum cohomology*,
  arXiv:2307.15938, equations (1.6)--(1.7), for the Gamma lattice and Euler
  pairing.  Cached PDF SHA-256:
  `462f2e0d6eff6315d9fcc2e0db78f95f14558d532d118e31b74f2270c2e0ab8a`.
- Hiroshi Iritani, *Quantum cohomology of blowups*, arXiv:2307.13555,
  Theorem 5.18 and Remark 1.5, for the proved formal decomposition and the
  stated analytic Stokes/Orlov expectation.  Cached PDF SHA-256:
  `c16f56b283863322df04dadaeb0780889abd67a664f56a74fea39bc7ba8a934b`.
- Sergey Galkin, Vasily Golyshev, and Hiroshi Iritani, *Gamma classes and
  quantum cohomology of Fano manifolds: Gamma conjectures*, arXiv:1404.6407,
  for Gamma Conjecture II for projective spaces and the Beilinson
  line-bundle sectorial basis: https://arxiv.org/abs/1404.6407.
- `2026-08-13-c907-point-gamma-primary-nonvanishing.md` for the Barnes
  coefficients in (4) and their exact sources.
