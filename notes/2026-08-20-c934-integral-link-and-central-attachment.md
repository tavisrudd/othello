# C934: the integral link and the central decomposition attachment

**Date:** 2026-08-20

**Status:** positive first theorem gate. The local three-primary defect is
structural and its global boundary class is killed by a geometric Fano lift.
The full all-degree global group table and the outer perverse extensions remain
open in C934.

## Setup

Let

\[
 \sigma:M=\operatorname{Bl}_0\Theta\longrightarrow\Theta,
 \qquad U=\Theta\setminus\{0\}=M\setminus X,
\]

where `X` is the exceptional cubic threefold, and let `K` be the link.  The
link is the unit circle bundle of `O_X(-1)`.  Write `h` for the hyperplane
class, `ell` for the line class, and `tau=p^*ell` in `H^4(K,Z)`.

## 1. Complete integral link calculation

The circle-bundle Gysin sequence and

\[
 h^2=3\ell,\qquad h\ell=[\mathrm{pt}]
\]

give

\[
 H^k(K,\mathbf Z)=
 \begin{cases}
  \mathbf Z,&k=0,7,\\
  H^3(X,\mathbf Z)\cong\mathbf Z^{10},&k=3,\\
  \mathbf Z^{10}\oplus\mathbf Z/3,&k=4,\\
  0,&\text{otherwise}.
 \end{cases}
\]

More precisely,

\[
 0\longrightarrow\langle\tau\rangle\cong\mathbf Z/3
 \longrightarrow H^4(K,\mathbf Z)
 \xrightarrow{p_*}H^3(X,\mathbf Z)\longrightarrow0,
\tag{1}
\]

and `H^3(X) -> H^3(K)` is `p^*` and is an isomorphism.  The free
degree-three and degree-four parts pair unimodularly: for
`a in H^3(X)` and a lift `b-tilde in H^4(K)` of `b in H^3(X)`,

\[
 \int_Kp^*a\smile\widetilde b=\int_Xa\smile b.
\]

The torsion generator `tau` annihilates integral products.  Thus the only
coefficient defect in the link is the explicitly located order-three class.

## 2. The derived attachment is a costalk-to-stalk map

Put

\[
 \mathcal K=R\sigma_*\mathbf Z_M[4].
\]

Proper base change, tubular excision, and the Thom isomorphism give

\[
 i^*\mathcal K\simeq R\Gamma(X,\mathbf Z)[4],\qquad
 i^!\mathcal K\simeq R\Gamma(X,\mathbf Z)[2].
\tag{2}
\]

Under these identifications, the attaching map
`i^! K -> i^* K` is cup product with `-h`.  On cohomology its nonzero
algebraic blocks are

\[
 H^0(X)\xrightarrow{\sim}H^2(X),\qquad
 H^2(X)\xrightarrow{\,-3\,}H^4(X),\qquad
 H^4(X)\xrightarrow{\sim}H^6(X).
\tag{3}
\]

The cone of (3) is `R Gamma(K,Z)[4]`, exactly the Gysin triangle.  Hence the
factor three is not a detached two-term skyscraper complex.  It is the
attaching morphism from the costalk of the resolution complex to its stalk.
After inverting three all three displayed blocks are unimodular, which is the
local reason the rational decomposition splits.

## 3. Central perverse zig-zag

Let `P = pH^0(K)`.  Its restriction to `U` is `Z_U[4]`.  In the
MacPherson--Vilonen description for the two-stratum space, the central
costalk and stalk are

\[
 A=H^0(i^!P)=H^2(X,\mathbf Z)=\mathbf Z,
 \qquad
 B=H^0(i^*P)=H^4(X,\mathbf Z)=\mathbf Z.
\]

The relevant exact zig-zag is

\[
 H^3(K,\mathbf Z)\longrightarrow
 \mathbf Z\xrightarrow{-3}\mathbf Z
 \longrightarrow H^4(K,\mathbf Z),
\tag{4}
\]

where the first arrow is zero and the last sends `1` to `tau`.  Exactness is
the degree-three/four segment of the pair sequence of the disk bundle:
`H^3(X) -> H^3(K)` is an isomorphism, and
`H^2(X) -> H^4(X)` is multiplication by `-3`.

Over `Q`, the middle arrow in (4) is an isomorphism, so this central perverse
object splits as `IC_Theta` plus the central point summand recorded by
Kraemer.  Over `Z`, (4) is the precise obstruction to that splitting.  Any
integral derived theorem must record this zig-zag or an equivalent attaching
class; an additive cohomology table is insufficient.

## 4. The local `Z/3` dies globally, and why

Let `F` be the Fano surface and

\[
 q:\operatorname{Bl}_\Delta(F\times F)\longrightarrow M
\]

the resolved degree-six difference map.  The clean Thom base-change identity
used by C928 holds in every degree.  Apply it to
`T=[pt] tensor 1 in H^4(F times F,Z)` and set

\[
 u_4=q_*\mu^*T\in H^4(M,\mathbf Z).
\]

Then

\[
 e^*u_4=\ell,\qquad b_*u_4=[F]=\theta^{[3]}.
\tag{5}
\]

The first identity holds because the exceptional restriction is the
universal line over the chosen point of `F`; the second is the endpoint of
the difference map, since Pontryagin product with the point class leaves
`[F]`.

Let `u_4|_U` denote the restriction.  Mayer--Vietoris compatibility and (5)
give

\[
 (u_4|_U)|_K=p^*\ell=\tau.
\tag{6}
\]

Moreover `u_4|_U` has infinite order.  If it vanished rationally, then
`u_4` would be rationally supported on the exceptional divisor; every such
class has zero pushforward to `J` because `X` is contracted to a point,
contradicting `b_*u_4=theta^[3]`.

The rational decomposition and Poincare duality on `U` force
`H^4(U,Q) -> H^4(K,Q)` to be zero.  Therefore its integral image is torsion;
(6) shows that it is exactly

\[
 \operatorname{im}\bigl(H^4(U,\mathbf Z)\to H^4(K,\mathbf Z)\bigr)
 =\langle\tau\rangle\cong\mathbf Z/3.
\tag{7}
\]

Thus the link class does **not** survive as a boundary class in degree five.
It is absorbed by an infinite-order global class supplied by one line of the
universal family.  Equivalently, the middle-perversity truncation triangle
has exact segments

\[
 IH^4(\Theta,\mathbf Z)\longrightarrow H^4(U,\mathbf Z)
 \longrightarrow\mathbf Z/3\longrightarrow0
\tag{8}
\]

and

\[
 0\longrightarrow H^4(K,\mathbf Z)/\langle\tau\rangle
 \longrightarrow IH^5(\Theta,\mathbf Z)
 \longrightarrow H^5(U,\mathbf Z)\longrightarrow0.
\tag{9}
\]

The first map in (8) has image equal to the kernel of restriction.  Establishing
the complete integral group table now reduces to proving torsion-freeness and
identifying the natural ordinary-to-intersection maps in (8)--(9), rather
than deciding the fate of the local class.

## 5. Significance and remaining gates

The positive spine is now sharper than the initial proposal:

1. the degree-three theorem has a global mod-two Lefschetz placement;
2. the central degree-four resolution complex has a local multiplication-by-
   three attachment;
3. a degree-four Fano endpoint class kills the resulting link torsion
   globally and realizes `theta^[3]` in the intermediate Jacobian.

This is a coherent two-prime theorem, not a list of Betti numbers.  Before it
can replace the frozen paper's main spine, C934 must still:

- compute the integral perverse truncations outside `pH^0` and their
  extensions, rather than importing the rational direct sum;
- prove the all-degree ordinary, resolution, and intersection groups are
  torsion-free where expected;
- identify the index-three map in degree four and all dual pairings;
- check priority against integral decomposition and parity-sheaf literature.

## Source depth

- de Cataldo--Migliorini, arXiv:math/0504554, **partial**: Sections 2.4,
  4.2, and 4.4 were read from the cached arXiv PDF; cache SHA-256
  `f02d2127019d02e87934e1bcb2e5101dc909600d8c6b702ad7401619a95f20a6`.
  The source supplies the rational fourfold perverse-piece framework; the
  integral map (3) and zig-zag (4) are the calculation above, not a claim
  attributed to that paper.
- Kraemer's rational decomposition and the C928 full-text source audit are
  reused at their recorded depth in `notes/2026-08-20-c928-priority-audit.md`.

## Mystery ledger

| question | status | evidence / next gate |
|---|---|---|
| Is the three-primary defect real? | settled | costalk-to-stalk block is multiplication by `-3` |
| Is it a detached point complex? | no | it is the attaching map (3), encoded centrally by (4) |
| Does the link's `Z/3` survive globally? | no | the class `u_4` restricts to `tau` and has nonzero Fano pushforward |
| Are all global groups torsion-free? | open | finish (8)--(9), their ordinary analogues, and duality |
| Does the whole derived image split away from the central block integrally? | open | compute outer perverse extensions and relative Lefschetz maps |
| Is the result priority-safe? | open | fresh integral-decomposition/parity literature audit |
