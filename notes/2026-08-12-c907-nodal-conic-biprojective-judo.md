# C907 nodal conic biprojective judo

**Lane:** `clebsch`

**Status:** theorem-grade positive calibration for the universal carrier gate.
The smooth conic bundle which realizes the non-square-zero nodal Clifford
radical has a second presentation as a projective-line bundle over `P^2`.
Consequently its actual operation-framed primitive-sixth packet is empty,
conditional only on the projective-bundle axiom already required by C907.
Thus the local Clifford node socle is killed in a genuine global example.

## Two presentations of one threefold

Let

\[
 V=\{Xu^2+Yv^2+Zw^2=0\}
 \subset P^2_{[X:Y:Z]}\times P^2_{[u:v:w]}. \tag{1}
\]

Projection to the first factor is the conic bundle with coordinate-triangle
discriminant.  At a crossing its local quadratic form is `<1,x,y>`, whose
even Clifford fibre is the exterior algebra

\[
 E=\Lambda(i,j),\qquad \operatorname{rad}(E)^2=kij\ne0. \tag{2}
\]

Now project to the second factor.  The three sections `u^2,v^2,w^2` have no
common zero, so they give a surjection

\[
 O_{P^2}^{\oplus3}\longrightarrow O_{P^2}(2). \tag{3}
\]

Let `K` be its rank-two kernel.  For each `[u:v:w]`, equation (1) is the
hyperplane of `[X:Y:Z]` annihilated by `(u^2,v^2,w^2)`, hence

\[
 V\cong P_{P^2}(K) \tag{4}
\]

up to the standard lines-versus-quotients convention.  In particular `V` is
a smooth projective `P^1`-bundle over `P^2`; this also gives a second direct
proof of smoothness.

## Enriched packet consequence

Let `R_alpha(-)` be the strict operation-framed packet sought in C907 and
assume its required projective-bundle formula

\[
 R_\alpha(P_S(E))\cong
 \bigoplus_{j=0}^{r-1}T^jR_\alpha(S) \tag{5}
\]

for a rank-`r` bundle.  For `alpha=1/6`, points, curves, and surfaces have
empty primitive-sixth packet.  Applying (5) to (4) gives

\[
 R_{1/6}(V)=0,\qquad \ell_{1/6}(V)=0. \tag{6}
\]

Therefore the nonzero element `ij` in (2) has zero image under any strict
Clifford-to-Stokes realization compatible with the alternative
projective-bundle presentation.  Raw Clifford radical length is not merely
insufficient to prove the carrier bound: in this example it strictly
overestimates the actual enriched packet.

## What generalizes and what does not

The mechanism gives the correct target for singular-point excision.  The
node composite is supported where two discriminant branches meet, but a
global operation-frame relation can force its image to vanish even when the
local order retains it.  Any proposed realization must therefore quotient by
presentation relations before reading Rees length.

The special equation (1) is linear in `[X:Y:Z]`; a general conic bundle over
a surface has no second projective-bundle presentation.  Thus (6) does not
prove the universal conic-bundle branch.  It is, however, a compulsory
regression: a construction sending `ij` nontrivially for (1) cannot be the
presentation-independent C907 invariant.

There is a plausible general route.  Standardize a nodal conic bundle by
base blowups and elementary transformations, and prove that the induced
threefold modifications decompose into point/curve packets plus smooth-
discriminant Clifford pieces.  Strict blowup biproducts would kill the former,
while the latter have square-zero reduced radical.  What is missing is an
exact operation-framed comparison for those elementary transformations; it
cannot be replaced by the local Clifford order alone.

## EJ/TT and mystery ledger

- **EJ:** swap the two projective factors.  The sharp local countermodel is a
  globally trivial carrier by a second Mori presentation.
- **TT:** carrier length must be invariant under alternative presentations;
  local ramified orders are admission data, not the invariant itself.
- **Settled:** the explicit nodal Clifford socle has zero actual enriched
  image under the required projective-bundle axiom.
- **Open:** prove the same point-sector killing for arbitrary conic-bundle
  nodes via elementary transformations and strict blowup/Gamma compatibility.
