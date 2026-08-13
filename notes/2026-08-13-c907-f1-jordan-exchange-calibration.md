# C907 `F_1` Jordan exchange calibration

**Lane:** `clebsch`

**Status:** exact positive operation-frame calibration for the minimal Silver
packet.  The first nontrivial blowup/projective-bundle exchange preserves the
endpoint Jordan operator:

\[
 J_2\otimes J_2\cong J_3\oplus J_1.
\]

Geometrically this is the equality between the two descriptions of
`X x F_1`, where `F_1=Bl_p P^2`.  It does not construct the universal quantum
operator, but it proves that the proposed endpoint `J_3` and strict blowup
rule pass a genuine presentation-change test at operator level, not merely on
associated grades.

## Geometry of the exchange

Let `X` be a smooth cubic threefold and let `p in P^2`.  There is a canonical
product blowup identity

\[
 \operatorname{Bl}_{X\times\{p\}}(X\times\mathbf P^2)
 \cong X\times\operatorname{Bl}_p\mathbf P^2
 =X\times\mathbb F_1.
 \tag{1}
\]

The center has codimension two.  The Hirzebruch surface has its other
presentation

\[
 \mathbb F_1\cong
 \mathbf P_{\mathbf P^1}(\mathcal O\oplus\mathcal O(1)).
 \tag{2}
\]

Thus the same smooth fivefold is obtained either by:

1. blowing up the endpoint `X x P^2` in one cubic center `X`; or
2. taking a `P^1`-bundle over `X x P^1`.

Any operation-framed Jordan assignment must make these two calculations
isomorphic.

## Exact Jordan identity

Let `K=Q(zeta_6)` and write

\[
 J_2=K e_0\oplus K e_1,qquad Ne_0=e_1,quad Ne_1=0.
 \tag{3}
\]

On `J_2 tensor J_2` use the Thom--Sebastiani/projective-product operator

\[
 N=N_1\otimes1+1\otimes N_2.
 \tag{4}
\]

Put `e_ij=e_i tensor e_j`.  Then

\[
 \begin{aligned}
 Ne_{00}&=e_{10}+e_{01},\\
 N(e_{10}+e_{01})&=2e_{11},\\
 Ne_{11}&=0,\\
 N(e_{10}-e_{01})&=0.
 \end{aligned}
 \tag{5}
\]

Since `2` is invertible in `K`,

\[
 K\{e_{00},e_{10}+e_{01},2e_{11}\}\cong J_3,
 \qquad
 K\{e_{10}-e_{01}\}\cong J_1,
 \tag{6}
\]

and the two subspaces are complementary.  Therefore

\[
 \boxed{J_2\otimes J_2\cong J_3\oplus J_1.}
 \tag{7}
\]

This is the smallest Clebsch--Gordan rule for nilpotent Jordan blocks.  It is
an equality of `K[N]`-modules, not just equality of dimensions or filtered
Hilbert polynomials.

## Comparison of the two geometric ledgers

Normalize the cubic packet of `X` as `J_1`.

The projective endpoint calibration gives

\[
 \mathscr J_6(X\times\mathbf P^2)=J_3.
 \tag{8}
\]

Applying the desired codimension-two blowup rule to (1) gives

\[
 \mathscr J_6(X\times\mathbb F_1)
 \cong J_3\oplus T J_1.
 \tag{9}
\]

After forgetting the harmless Tate label, this is `J_3 direct-sum J_1`.

On the projective-bundle side, first

\[
 \mathscr J_6(X\times\mathbf P^1)=J_2,
 \tag{10}
\]

and (2), with the relative projective operator, gives

\[
 \mathscr J_6(X\times\mathbb F_1)
 \cong J_2\otimes J_2.
 \tag{11}
\]

Equation (7) identifies (9) and (11) exactly.  The extra `J_1` is the
primitive anti-diagonal vector `e_10-e_01`; the endpoint `J_3` is the
symmetric chain beginning at `e_00`.

## Structural consequence

This calculation does three useful things.

1. It gives the endpoint `J_3` a basis-free tensor origin: it is the highest
   Jordan summand in the product of two projective-line strings.
2. It shows that a codimension-two center summand need not glue into the
   endpoint in this elementary exchange; the exact tensor operator splits it
   as the additional `J_1` required by the blowup formula.
3. It supplies the first operator-level exchange regression for any proposed
   quantum construction of `N`.  A construction which gives `J_4`, `J_2^2`,
   or `J_1^4` on `X x F_1` is incompatible with the simultaneous blowup and
   projective-bundle formulas.

The identity is conditional geometric evidence, not the universal strict
blowup theorem.  It assumes that projective bundles act by the additive
nilpotent tensor rule (4), and it tests a product center where the two
presentations are explicit.  Arbitrary same-spectrum ambient--center
extensions still require the recursive `Ext^1_(K[N])` vanishing theorem.

## General Jordan tensor calibration

In characteristic zero, the standard nilpotent tensor rule satisfies

\[
 J_a\otimes J_b
 \cong
 \bigoplus_{k=1}^{\min(a,b)}J_{a+b-2k+1}.
 \tag{12}
\]

It is the Clebsch--Gordan decomposition for the raising operator on
`Sym^(a-1)(K^2) tensor Sym^(b-1)(K^2)`.  Formula (7) is its first case.
Consequently iterated projective bundles have a canonical, computable Jordan
signature richer than their Tate polynomial.  These signatures provide a
family of operator-level exchange tests for the future intrinsic assignment.

No use of (12) is needed for the proof of (7); equations (5)--(6) are a
complete direct verification.

## EJ/TT and mystery ledger

- **EJ:** the blowup of the endpoint at a product point-center is the same
  variety as a double `P^1`-bundle.  Its two operation ledgers meet in the
  elementary identity `J_2 tensor J_2=J_3+J_1`.
- **TT:** matching Tate polynomials would see only four grades/copies.  The
  exact operator decomposition distinguishes the permitted
  `J_3+J_1` from `J_4`, `J_2^2`, and `J_1^4`.
- **Settled:** endpoint compatibility with the first nontrivial
  blowup/projective exchange and its explicit `K[N]` intertwiner.
- **Open:** construct this tensor operator from the quantum operation frame,
  extend the identity to arbitrary centers, and kill the recursive extension
  classes in the strict blowup theorem.
