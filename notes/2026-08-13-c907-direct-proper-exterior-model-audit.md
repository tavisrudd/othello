# C907 audit: direct proper exterior model

**Lane:** `clebsch`

**Verdict:** **PASS.**  The last direct-exterior-model hypothesis is a theorem
from the landed supported-fan, relative tropical compactification, and
actual-open inputs.  Two short lemmas must be kept explicit: fan refinement
only supplies the ambient toric map, while reduced strict-closure density
supplies its factorization through `X_0`; and properness comes from equality
with the relative tropicalization, not from a map into a proper ambient.

## 1. The direct map is a closure factorization

Put `B=Spec(R) x S`, with `S=G_m,L`, and let `G_va` be the very-affine graph
with `U,V` inverted.  The landed full-initial replay identifies

\[
 |\widetilde\Sigma|=|\Sigma_{\rm trop}|
 =\operatorname{Trop}_B(G_{\rm va}). \tag{1}
\]

The regularization is a subdivision, so it does not change the support in
(1).  Every cone of this fan lies in a cone of the fixed marked/product fan.
This gives an ambient toric morphism

\[
 q:P_{\widetilde\Sigma}\longrightarrow \mathcal A_{\rm mark}, \tag{2}
\]

which agrees with the identity on the common graph torus.  It is important
not to replace the next step by the phrase "hence maps to `X_0`".  Let

\[
 E=\overline{G_{\rm va}}^{\rm red}\subset P_{\widetilde\Sigma},
 \qquad
 X_0=\overline{G_{\rm orig}}^{\rm red}\subset\mathcal A_{\rm mark}. \tag{3}
\]

The `UV` non-zero-divisor argument identifies the two strict generic
closures, so `G_va` is dense in `E` and its image is the common dense graph
in `X_0`.  For every local equation `f` of `X_0`, `q^*f` vanishes on this
dense open of the reduced scheme `E`; hence `q^*f=0` on `E`.  Thus (2)
restricts uniquely to

\[
 \pi_{\rm ext}:E\longrightarrow X_0. \tag{4}
\]

This is a genuine direct morphism.  It is not the diagonal strict-closure
correspondence used as a fallback in the earlier proper-support audit.

## 2. Properness has the required relative form

The relative tropical compactification theorem applies to (1): the closure
of `G_va` in the toric scheme for a fan whose support contains its relative
tropicalization is proper over `B`.  Therefore

\[
 E\longrightarrow B\quad\text{is proper}. \tag{5}
\]

The word *relative* matters.  A valuation over `B` has `v(L)=0`, because it
maps to `S`; the horizontal `t=0` and vertical `t>0` directions are both in
the supported replay.  Directions with `v(L)\ne0` leave the value torus and
are not required for (5).  Restricting later to a closed analytic/algebraic
value disk is a base change of (5).

Since `X_0` is a Cartier closure in the fixed multihomogeneous projective
ambient, it is separated over `B`.  The graph of (4) is consequently closed
in `E x_B X_0`.  The second projection is a base change of (5), hence proper,
and its restriction to that closed graph is proper.  This proves

\[
 \pi_{\rm ext}:E\to X_0\quad\text{is proper}. \tag{6}
\]

No completeness of `P_tildeSigma` is needed.  A completion may be taken
afterward, but it neither proves nor changes (5).  Conversely, merely mapping
a nonproper closure into a proper marked ambient would not prove (6).

## 3. Actual-open identity

On the parameter-unit compact-`y` `g/1` subfan the six weights are

\[
 (0,0,0,0,0,-\beta-\gamma). \tag{7}
\]

It is wall-free and unimodular.  The relative regularization preserves all
of its cones, so (2) is an isomorphism on the corresponding affine charts.
They contain the entirety of the original open graph, including the retained
translated divisors `U=0` and `V=0`.  Taking strict closures in an ambient
isomorphism gives

\[
 \pi_{\rm ext}^{-1}(G_{\rm orig})\simeq G_{\rm orig}. \tag{8}
\]

Equations (6) and (8) make `pi_ext` a proper modification of the actual
extension-by-zero open.  Thus, for `j_E:G_orig->E` and `j_0:G_orig->X_0`,

\[
 R\pi_{\rm ext*}j_{E!}A\simeq j_{0!}A. \tag{9}
\]

This removes the direct-model hypothesis from the exterior bad-image and
proper-support arguments.  It does not import any fixed-value submersivity
claim from total schönness; that remains exactly the separate logarithmic
tangent/control certificate.

## Exact scope check

The argument uses the following landed inputs and nothing stronger:

1. full-initial support completeness, including the horizontal directions,
   so that (1) is the relative tropicalization rather than a mask skeleton;
2. the `UV` density/strict-closure comparison;
3. relative regularization preserving the `g/1` subfan; and
4. separatedness of the fixed Cartier closure.

If item 1 were only a list of support masks, or if `E` were not reduced with
the stated dense graph, the conclusion would be conditional.  The current
relative-schön and actual-open records supply exactly these facts.  No common
fan with the ratio model, completion fan, diagonal correspondence, or
fixed-value Fitting computation is needed here.

## EJ/TT and mystery ledger

- **EJ:** tropical support gives properness over the uncompactified value
  torus; strict-closure density gives the direct coarse map.  These are
  complementary, not interchangeable, mechanisms.
- **TT:** the actual `j_!` open is protected by the relative untouched
  `g/1` subfan, not by equality over the smaller `U,V`-Laurent torus.
- **Settled:** directness, properness, and actual-open identity of the
  exterior modification.
- **Open:** only the downstream nearby-cycle/direct-image and pairing/Rees
  transport gates; there is no remaining exterior-model construction gate.
