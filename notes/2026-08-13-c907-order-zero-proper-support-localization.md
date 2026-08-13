# C907 order-zero proper-support localization theorem

**Lane:** `clebsch`

**Status:** theorem-grade structural assembly, conditional on the direct
proper exterior strict-model and nearby-cycle/direct-image comparison
hypotheses stated below.  The value vanishing
cycles of the toric codimension-two pilot are supported on the four residual
Morse sections.  Consequently its intrinsic value-localized
compact-support thimble group has rank four.  The directed `P^3` Seifert form
and the full Stokes/Gamma identification remain separate transport gates.

## The theorem

Let `G_orig` be the original graph over a sufficiently small parameter disk
and a closed value disk `Omega subset C^*` containing the four residual values
and no other bounded critical values.  Let `X_0` be its coarse Cartier closure
and put

\[
 \mathcal K=R(p,L)_!\mathbf Z[1/6]_{G_{\rm orig}} .
 \tag{1}
\]

Choose a proper compactification over the parameter/value base and write
`R\bar a_*j_!` for the resulting intrinsic `!`-pushforward complex.  Assume
the proper-pushforward/nearby-cycle comparison and define the nearby value
object

\[
 K_0=\psi_\delta R\bar a_*j_!\mathbf Z[1/6]
 \simeq R L_{0!}\psi_\delta(j_!\mathbf Z[1/6])
 \quad\text{on }\Omega .
 \tag{1a}
\]

Here `L_0` is the value map on the central nearby-cycle space inside the
chosen compactification; the right side is independent of that choice by
proper modification descent.

Assume that the supported pair-of-pants fan maps to the fixed marked
projective/`y` ambient, that its relative regularization gives a direct proper
strict closure

\[
 \pi_{\rm ext}:E\longrightarrow X_0,
 \tag{2}
\]

and that `E` is the strict closure of `G_orig`.  Let
`pi_rat:R -> X_0` be the proper strict closure of the simultaneous projective
ratio graph.  Then the iterated value-cycle support on the total
compactification satisfies

\[
 \operatorname{Supp}\!\left(
 \psi_\delta\phi_{L-u}(j_!\mathbf Z[1/6])
 \right)
 \subseteq \mathscr C,
 \tag{3}
\]

where

\[
 \mathscr C=
 \{Z=W=0,\ y_1=y_2=y_3=a,\ a^4=Q,\ L=4a\}
 \tag{4}
\]

is the union of four reduced nondegenerate sections.  Assume their four values
`4a` are distinct, lie in the interior of `Omega`, and there is no singular
value on `partial Omega` or on the interiors of a chosen nonbraiding path
star from a regular boundary value `u_0`.  Assume further that (1a) identifies
the value vanishing cycles of `K_0` with the four normalized rank-one Morse
groups in (4).  Then the nearby relative compact-support complex

\[
 \mathsf R(K_0;u_0)=
 \operatorname{Cone}\!\left(
 R\Gamma(\Omega,K_0)\longrightarrow i_0^*K_0
 \right)[-1]
 \tag{5}
\]

therefore has one free group of rank four in thimble degree five and no other
reduced relative groups.  A nonbraiding path star labels its four generators
by the sections (4).

## Structural proof

The proof has four independent pieces.

1. **Correct open support.**  On the generic-parameter `g/1` subfan the six
   graph weights are `(0,0,0,0,0,-beta-gamma)`.  It is wall-free and
   unimodular.  Relative toric resolution preserves it, so (2) is an
   isomorphism on the original open, including `U=0` and `V=0`.  Hence
   `R pi_ext* j_E! A = j_0! A`.
2. **Exterior bad image.**  The exact full-initial theorem and the 72-mask
   replay give 70 logarithmic residue-character fields with unit `L`
   derivative and two empty `L=0` faces.  On a unimodular direct chart these
   fields are regular, parameter-relative, and tangent to every actual
   boundary divisor.  Horizontal and noncompact faces have free `L`.
   Therefore
   
   \[
    \pi_{\rm ext}(B_{\rm ext})\subset T_{11}.
    \tag{6}
   \]
3. **Protected whole fibre.**  Every point of the full proper ratio fibre over
   `T_11 minus C` lies in the bounded residual chart or one of the two finite
   imbalanced charts.  In the latter, the retained interior coordinates `v`
   and `w` have unit `L` derivative tangent to the actual divisor `rh=0`; in
   the bounded chart the only critical locus is (4).  Thus
   
   \[
    \pi_{\rm rat}(B_{\rm rat})\cap T_{11}\subset\mathscr C.
    \tag{7}
   \]
4. **Proper-support intersection.**  Proper modification descent and proper
   pushforward for vanishing cycles imply that the downstairs support is
   contained in the intersection of the two proper bad images.  Equations
   (6)--(7) give (3).  Pushing (3) to the value disk and using the assumed
   proper nearby-cycle/direct-image comparison identifies the value-cycle
   support of `K_0` with the four sections.  Algebraic constructibility and
   the local holomorphic Morse lemma identify the four normalized local
   attachment groups.  Cutting
   the value disk along a path star filters (5) by those four free rank-one
   groups.  Its locally constant part contributes zero because restriction
   from a contractible tree to `u_0` is an isomorphism.

No common marked toroidal fan or common Whitney collar enters this argument.
The two compactifications are allowed to fail on different coarse loci; only
the intersection of their proper bad images matters.

## What this does not prove

Rank and support do not determine the directed Seifert form.  Verdier duality
sends `Ra_!` to `Ra_*`, so the missing comparison must transport relative
Poincare--Verdier duality, Picard--Lefschetz `can/var`, local orientations,
and the ordered nonbraiding path star.  Thom--Sebastiani computes the central
form as the `P^3` form once that package is transported.

Nor does the theorem identify the four localized thimbles with Iritani's
global satellite/Orlov summand as a full directed Stokes/Gamma object.  The
point-class shear is invisible to the coarsened `N`-adic Rees associated
graded, but it changes ordinary directed Stokes flags.

## EJ/TT and mystery ledger

- **EJ:** the common-fan obstruction disappears after passing from chartwise
  critical sets to the intrinsic proper-support complex.  Two imperfect
  models suffice because their bad images miss one another off the core.
- **TT:** support and rank are one theorem; directed pairing is a second.
  Keeping the relative cone and `can/var` package explicit prevents those
  logically different claims from being conflated.
- **Settled:** exact exterior bad image, whole protected ratio fibre,
  two-model bad-image separation, four-section support, and the resulting
  rank-four nearby thimble group, subject to the direct proper
  exterior-model and nearby-cycle/direct-image hypotheses.
- **Open:** serialize those direct proper-model inputs in the fixed ambient;
  transport relative duality, `can/var`, orientations, and labels; then prove
  the integral residual Orlov/Rees comparison.  No additional support-mask or
  common-collar enumeration is called for.
