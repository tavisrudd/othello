# C907 direct proper exterior model

**Lane:** `clebsch`

**Status:** theorem-grade construction from the landed supported-fan and
actual-open results.  The exterior compactification is a direct proper model
over the fixed coarse Cartier closure, not merely a diagonal correspondence.
This removes the construction hypothesis from the logarithmic exterior
bad-image theorem.

## Construction

Let `Sigma_mark` be the product of the two marked-line tripod fans, the fixed
projective `y` fan, the parameter ray, and the zero `L` fan.  Its toroidal
ambient maps to the fixed marked projective/`y` ambient containing the coarse
Cartier closure `X_0`.  The supported graph complex `Sigma_trop` was built by
intersecting `Sigma_mark` with the pairwise equality walls of the six graph
weights and retaining exactly the nonsingleton masks.  Hence every cone of
`Sigma_trop` lies in a cone of `Sigma_mark`; after any relative regular
subdivision there is a toric morphism

\[
 P_{\widetilde\Sigma}\longrightarrow P_{\Sigma_{\rm mark}}.
 \tag{1}
\]

Let `E` be the reduced strict closure of the original graph in
`P_tildeSigma`.  The very-affine and original marked graphs have the same
schematic generic closure because `UV` is a non-zero-divisor; thus `E` is
also the strict tropical closure whose full initials were certified by the
filtered-Koszul theorem.  Restricting (1) gives the direct map

\[
 \pi_{\rm ext}:E\longrightarrow X_0.
 \tag{2}
\]

There is no choice of diagonal correspondence in (2): both strict closures
are images of the same graph under one ambient toroidal morphism.

## Properness

The fan is supported exactly on the relative tropicalization of the graph.
The tropical compactification theorem, equivalently its valuative criterion,
makes `E` proper over the parameter/value base `R x S`; every bounded-value
valuation has its initial in the supported complex.  The coarse closure `X_0`
is separated over that base.  Therefore (2) is proper: its graph is closed in
`E x_B X_0`, and projection from the base change of the proper `E -> B` is
proper.

This argument does not require the ambient toric variety
`P_tildeSigma` itself to be complete.  Completing it afterward only embeds
the already proper closed `E` into a larger ambient and adds no orbit to the
tropical pair.

## Identity on the actual open

Let `Sigma_open` be the compact-`y`, parameter-unit `g/1` subfan.  Its six
weights are

\[
 (0,0,0,0,0,-\beta-\gamma),
 \tag{3}
\]

so it is wall-free and unimodular.  Choose the regularization relative to
`Sigma_open`.  The toric map (1) is then an isomorphism on all its affine
charts, including the retained `U=0` and `V=0` loci.  Hence

\[
 \pi_{\rm ext}^{-1}(G_{\rm orig})\simeq G_{\rm orig},
 \qquad
 R\pi_{\rm ext*}j_{E!}A\simeq j_{0!}A.
 \tag{4}
\]

Combining (2)--(4) with the 70 logarithmic unit fields, the two `L=0`
exclusions, and the free-`L` faces proves unconditionally for this chosen
model

\[
 \pi_{\rm ext}(B_{\rm ext})\subset T_{11}.
 \tag{5}
\]

## Scope

The direct proper model supplies exactly the morphism and sheaf identity used
by multi-model proper-support descent.  It does not claim fixed-value
smoothness from total schönness: equation (5) still uses the separate
logarithmic tangent certificate.  Nor does it create a common fan with the
protected ratio model.

## EJ/TT and mystery ledger

- **EJ:** properness of the strict graph closure over the base plus
  separatedness of `X_0` promotes the ambient fan map to the required proper
  direct map; no compact ambient fan or diagonal closure is needed.
- **TT:** the fan does two logically distinct jobs: support exactness gives
  properness, while relative preservation of `Sigma_open` gives the `j_!`
  identity.
- **Settled:** existence, properness, directness, and actual-open identity of
  the exterior model, hence the exterior bad-image inclusion.
- **Open:** proper nearby-cycle/direct-image comparison and intrinsic pairing
  transport to the residual Orlov/Rees object; no direct-model mystery
  remains.
