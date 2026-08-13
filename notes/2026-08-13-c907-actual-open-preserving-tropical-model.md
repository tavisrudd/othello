# C907 actual-open-preserving tropical model

**Lane:** `clebsch`

**Status:** theorem-grade repair of the open-set issue in the proper-support
route.  The intrinsic tropical construction begins from the smaller Laurent
graph with `U,V` invertible, whereas the C907 open graph retains the translated
divisors `U=0` and `V=0`.  The supported fan has no wall on the compact-
`y`, generic-parameter `g/1` subfan, and that subfan is already regular.
Therefore toric desingularization can be chosen relative to it.  The resulting
exterior model is an isomorphism over the full original open graph, not merely
over the smaller Laurent torus.

## The open subfan

Use the marked coordinates

\[
 B+U=1,\qquad C+V=1,
 \tag{1}
\]

and the six support weights

\[
 0, p_1, p_2, p_3, -p+r_B+r_C, 2t-s_B-s_C.
 \tag{2}
\]

The original open graph has `y_i`, `B`, and `C` invertible and finite, but it
retains `U=0` and `V=0`.  Its generic-parameter tropical directions therefore
have

\[
 t=0,qquad p_i=0,qquad r_B=r_C=0,
 \tag{3}
\]

and each marked-line type is `g` or `1`.  Put
`beta=s_B>=0`, `gamma=s_C>=0`; positivity means that the corresponding
translated divisor is approached.  On this entire subfan (2) becomes

\[
 0,0,0,0,0,-\beta-\gamma.
 \tag{4}
\]

Thus:

- at `(g,g)` all six terms tie at the zero cone;
- if at least one type is `1`, the first five terms tie and the product term
  simply drops; and
- no graph wall cuts the interior of any `g/1` cone.

The relevant cones are the zero/ray products in the two tripod fans.  They are
coordinate cones and hence unimodular.  Call their union `Sigma_open`.

## Relative regularization

Let `Sigma_trop` be the supported graph complex and include `Sigma_open` as
the subfan just described.  A regular subdivision of `Sigma_trop` can be
chosen **relative to** `Sigma_open`: first leave every cone of this already
regular subfan unchanged, then perform the usual simplicial and determinant-
decreasing stellar subdivisions only on cones not belonging to it.  Faces of
preserved cones remain preserved.  This is the standard relative form of
toric desingularization; termination uses the same decreasing determinant
multiset as the absolute construction.

Let `E -> X_0` be the strict tropical closure mapped to the coarse marked
Cartier closure.  Over the smaller Laurent graph it is an isomorphism by
construction.  Along `U=0` or `V=0` with (3), its toric ambient map is also an
isomorphism because the corresponding cones of `Sigma_open` were not
subdivided.  The pair-of-pants closure itself is the marked projective line,
so it introduces no further modification of a lone translated point.
Consequently

\[
 \boxed{E^{-1}(G_{\rm orig})\simeq G_{\rm orig}.}
 \tag{5}
\]

Here `G_orig` is the original open graph which includes the translated
divisors.  In particular, if `j_E:G_orig -> E` and `j_0:G_orig -> X_0`, then

\[
 R\pi_{\rm ext*}j_{E!}A\simeq j_{0!}A.
 \tag{6}
\]

This is the exact hypothesis needed by proper-support descent.  Merely proving
that the two closures have the same dense smaller Laurent open would not have
been enough: a blowup of a translated divisor inside `G_orig` could contribute
higher cohomology on its proper fibre.

## Scope

The theorem does not prove fixed-value control on the exterior boundary.  It
does ensure that the direct exterior map used for that proof computes the
correct extension-by-zero object.  Every nontrivial support subdivision lies
over an actual parameter or compactification boundary, where proper-support
analysis is allowed to use the exterior model.

## EJ/TT and mystery ledger

- **EJ:** the universal support weights themselves show that the dangerous
  translated-open locus is wall-free; no extra atlas computation is needed.
- **TT:** equality of strict closures is weaker than equality of opens for
  `j_!`.  Preserve the regular `g/1` subfan so the proper model is genuinely
  an isomorphism over the sheaf's open support.
- **Settled:** actual-open preservation for an appropriate regular supported
  fan and hence the first proper-support identity for the exterior model.
- **Open:** fixed-value local acyclicity on its actual exterior boundary, then
  the two-model bad-image descent and labelled thimble comparison.
