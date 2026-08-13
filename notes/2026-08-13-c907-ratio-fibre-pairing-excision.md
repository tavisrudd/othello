# C907 ratio-fibre pairing excision

**Lane:** `clebsch`

**Status:** theorem-grade strengthening of the ratio-fibre support result and
exact conditional pairing-excision criterion.  The simultaneous ratio fibre
is controlled not merely away from the four coarse Morse points: over each
such point every lift except its unique bounded critical lift is
value-locally acyclic.  This alone does **not** concentrate the whole
compact/ordinary diagram.  Pairing excision additionally requires a
self-dual pair of cones after proper pushdown and the full tame residual
Lefschetz pair, not merely the four Morse germs.

## Strengthened whole-fibre lemma

Let

\[
 \pi_{\rm rat}:R\longrightarrow X_0
\]

be the reduced strict closure of the same original open graph in the
simultaneous projective ratio graph, as in the proper-support fibrewise
table.  Over

\[
 T_{11}=\{\delta=0, B=C=1, y\in T_y,
                 L\in\overline\Omega\},
\]

every point of every proper fibre has one of the same three statuses:

1. `Z,W` are finite, hence the point lies in the bounded residual chart;
2. `Z` has a pole but `h=delta Z` and `v=ZW` are finite, hence it lies in the
   finite `Z`-imbalanced chart; or
3. the symmetric finite `W`-imbalanced chart contains it.

The proof is the strict-closure curve-selection and valuation trichotomy
already used over `T_11 minus C`.  It never uses noncriticality of the coarse
point to obtain the three-chart cover.  The excluded alternatives are still
impossible: an `L` pole contradicts the bounded value window, and an exterior
marked-line limit contradicts `B=C=1`.

The two imbalanced charts are value-locally acyclic as actual-boundary pairs:
their retained interior coordinates `v,w` have unit `L` derivative tangent to
the divisor `rh=0`.  In the bounded chart the central function is exactly

\[
 g_0=f_Q(y)+ZW.
 \tag{1}
\]

Its logarithmic/ordinary critical equations are

\[
 Z=W=0,qquad y_1=y_2=y_3=a,qquad a^4=Q.
 \tag{2}
\]

Thus, even over a coarse point of the four-point set `C`, every proper-ratio
lift other than the unique point (2) has a tangent value-product
neighbourhood.  Compactness of the fibre and closedness of constructible
support give, after shrinking about `C`,

\[
 \operatorname{Supp}\bigl(
   \psi_\delta\phi_{L-u}(j_{R!}A)\bigr)
 \cap\pi_{\rm rat}^{-1}(T_{11})
 \subseteq \widetilde{\mathscr C},
 \tag{3}
\]

where `A=Z[1/6]` and `tilde C` consists of the four bounded lifts (2).  This
strengthens the earlier bad-image statement, which needed only the image
inclusion over `T_11 minus C`.

## Pairing-diagram localization criterion

Let `b=(delta,L):R -> Delta x Omega`, and choose a `delta`-saturated residual
Lefschetz domain `i:N -> R`.  Let `K_!` and `K_*` denote the intrinsic compact
and ordinary direct-image objects of the original open graph, and set

\[
 K_{N,!}=Rb_*i_!i^*j_{R!}A,
 \qquad
 K_{N,*}=Rb_*Ri_*i^*Rj_{R*}A.
 \tag{4}
\]

Compact extension and ordinary restriction point in opposite directions:

\[
 K_{N,!}\longrightarrow K_!\longrightarrow K_*
 \longrightarrow K_{N,*}.
 \tag{5}
\]

Thus the pairing object is an excision **zigzag**, not a same-direction map of
two arrows.  Put

\[
 C_!=\operatorname{Cone}(K_{N,!}\to K_!),
 \qquad
 C_*=\operatorname{Cone}(K_*\to K_{N,*}).
 \tag{6}
\]

The sharp additional hypothesis is that, for every `u` in the value disk,

\[
 \psi_\delta\phi_{L-u}C_!=0,
 \qquad
 \psi_\delta\phi_{L-u}C_*=0,
 \tag{7}
\]

compatibly with the natural `! -> *` map and `can/var`.  These are assertions
after proper pushdown to the intrinsic value object.  Formula (3) on `R` and
the exterior bad-image theorem on a different model do not by themselves
prove (7): `R` may retain exterior complexes which cancel only after proper
pushforward.

The two cone vanishings need not be proved separately.  If `N` is chosen as
an oriented controlled pair and the open is a smooth oriented complex
manifold, Verdier duality

\[
 D(j_{R!}A)\simeq Rj_{R*}A[2n](n)
 \tag{8}
\]

identifies the ordinary cone with the shifted dual of the compact cone.
Alternatively it is enough that the two cones form a locally constant
constructible **diagram** over the full cut path star: the value-disk relative
functor then kills that diagram.  Naturality of the zigzag and of `can/var`
conjugates the global pairing package to the residual one.

The strengthened whole-fibre result proves the required local-isomorphism
near the four critical lifts and removes every imbalanced contribution.  The
remaining unproved part of (7) is tube-wall/exterior acyclicity for the
intrinsic pushed-down zigzag, with its duality compatibility.

## Central computation and transport

The second sharp additional hypothesis is that nearby cycles of the residual
zigzag give the **full oriented tame Lefschetz pair** of `f_Q+ZW` on
`(C^*)^3 x C^2` over the entire chosen path star.  This includes its
compact/ordinary boundary map and regular-fibre attachments.  Equality of the
interior formula (1), or a disjoint union of four Milnor balls, is not enough:
the off-diagonal entries live in those attachments.

Under this full-pair identification and (7), orient the transverse `ZW`
thimble to have self-Seifert value `+1`.  The even Thom--Sebastiani suspension
preserves the standard directed `P^3` matrix

\[
 \begin{pmatrix}
 1&4&10&20\\
 0&1&4&10\\
 0&0&1&4\\
 0&0&0&1
 \end{pmatrix}.
 \tag{9}
\]

The four values remain distinct after shrinking the parameter disk.  A fixed
nonbraiding path star and the intrinsic pairing transport then carry (9) to
every sufficiently small nonzero parameter.  This is a sufficient theorem,
not yet a discharged C907 hypothesis.

## Boundary of the result

When the two extra hypotheses hold, the conclusion is the internal order-zero
directed Stokes theorem for the four residual thimbles.  Even then it does not
identify those thimbles with the individual integral Orlov--Gamma basis,
prove hyperplane equivariance, remove the point-class flag ambiguity, or
construct the strict positive-order Rees biproduct.

## EJ/TT and mystery ledger

- **EJ:** the proper-ratio trichotomy controls the *entire* Morse fibre too;
  the only lift where the value derivative can fail is the bounded
  `Z=W=0` lift.  The pairing upgrade is exactly one self-dual pushed-down
  excision zigzag, not another boundary atlas.
- **TT:** concentration must be proved upstairs on the same proper ratio
  model.  Downstairs support alone would permit a derived-cancelling
  exceptional complex and would not justify pairing excision.
- **Settled:** whole-ratio-fibre concentration, including over the four Morse
  coarse points; and the necessary-and-sufficient pairing-excision zigzag.
- **Open:** prove the pushed-down self-dual cone condition and identify the
  full tame residual pair; then prove the integral hyperplane-equivariant
  localized-to-Orlov/Gamma comparison and strict positive-order blow-up
  biproduct.  Universally, exclude `J_3` for centers outside the
  `nu_6<=2` portfolio.
