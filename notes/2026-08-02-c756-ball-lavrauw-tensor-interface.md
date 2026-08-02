# C756 — Ball--Lavrauw tangent-tensor interface

**Lane**: clebsch · **Date**: 2026-08-02 · **Scope**: saturated-internal
bounded interface test

## Verdict

The Ball--Lavrauw tangent tensor does **not** globalize the distinguished kernel
line of the C756 angle matrix.  In the planar specialization it is an order-two
tensor whose two slots record one tangent polynomial and one evaluation point.  It
couples the pairwise tangent values by Segre reciprocity, but the first angle moment
is a product/cofactor over all other arc points.  Passing from the former to the
latter requires exactly the arc-dependent cofactor construction still missing in
C756; the tensor supplies neither a lower-degree section nor a nullity-one theorem.

The precise failed slot is the second Veronese slot.  It interpolates the separate
base-point tangent polynomials, while the desired coefficient lives in the
$t$-fold product of the conjugate-fibre evaluations indexed by the remaining arc
points.  Thus this route meets the dossier's stop condition.  Do not open a general
arc-tensor survey or the adjugate/compound calculation on its strength.

## 1. Parameter dictionary

Write $K=|A|=(q+3)/2$ for the saturated-internal arc size and

\[
 t=q+2-K=(q+1)/2,
\]

so Ball--Lavrauw's planar convention is exactly the C756 tangent degree and
$K=t+1$.  Their tangent form $f_{P_i}$ is C756's canonically scaled

\[
 T_i(Q)=\frac{f_Q(z_i)^t-f_Q(z_i^q)^t}{z_i^q-z_i},
\]

because the $t$ combinatorial tangents to $A$ at the internal point $P_i$
are precisely the $t$ secants of the fixed conic through $P_i$.

The degree-$t$ Veronese images of the $t+1$ arc points are linearly
independent.  Indeed, for each $P_i$, choose for every $j\ne i$ a line through
$P_j$ missing $P_i$; their product is a degree-$t$ form vanishing at every
other arc point but not at $P_i$.  Hence the whole arc is a $t$-socle.

Consequently Theorem 14 of *Planar arcs*, equivalently the planar case of Theorem
1 of *Arcs and tensors*, gives a biform $F(X,Y)$ of bidegree $(t,t)$ with

\[
 F(X,P_i)=T_i(X) \qquad(P_i\in A),
\]

and $F(X,Y)=(-1)^{t+1}F(Y,X)$ modulo the degree-$t$ vanishing spaces.
On the Veronese span this is simply a bilinear form with matrix
$T_i(P_j)$; because the Veronese points are a basis, multilinearity creates no
additional relation among three or more rows.

## 2. The exact information loss

Put $w_{ij}=f_j(z_i)$ and $\delta_i=z_i^q-z_i$.  Pairwise tangent evaluation gives

\[
 T_i(P_j)=\frac{2w_{ij}^{t}}{\delta_i},
 \qquad
 T_i(P_j)^2=\frac{4N(w_{ij})}{\delta_i^2}.
\]

Thus the tensor records the signed square root of the norm/resultant datum already
used by sign coherence.  The angle entry instead is the conjugate-fibre phase

\[
 \alpha_{ij}=\frac{w_{ij}}{w_{ij}^q}
              =\frac{w_{ij}^2}{N(w_{ij})}.
\]

The first middle coefficient of the cleared angle binomial is

\[
 C_i=\sum_{j\ne i} w_{ij}
              \prod_{\substack{r\ne i\\r\ne j}}w_{ir}^q,
 \qquad C_i=0.
\]

This is a cofactor across all $t$ neighbours of $P_i$, not a specialization
or contraction of the order-two tensor.  Differentiating the first slot of $F$
only takes jets of the already separate polynomial $T_i$.  Differentiating or
extending the second slot is noncanonical modulo $\Phi_t$.  Either operation can
recover pairwise fibre data after choices and division, but summing the phases still
requires the same $A$-dependent $t$-fold cofactor.  No intrinsic section of degree
below $q+3$, and no tensor-rank implication forcing angle-matrix nullity one, results.

This failure is uniform over prime powers.  The Ball--Lavrauw construction and the
socle argument are over $\mathbb F_q$, and $t=(q+1)/2$ is nonzero in the ground
characteristic.  Frobenius and Hasse derivatives introduce no exceptional field here:
the loss occurs earlier, when the bilinear tangent-evaluation tensor forgets the
simultaneous cofactor product.

## 3. Generalized-hyperfocused check

The Blokhuis--Marino--Mazzocca hypothesis would require a set of exactly $K-1$
points outside $A$ meeting every secant of $A$.  C756's conic polarity does not
produce it.  A chord $L=P_iP_j$ is a passant of the conic, so its pole $L^\perp$
is internal and is not incident with $L$: incidence with its own polar would put the
pole on the conic.  The angle labels are points of a pencil depending on the chosen
base point and do not descend to a base-independent blocker set.  Finally, covering
all off-conic points by chords is an abundance statement, not a $K-1$-point blocking
statement.

The $q=5$ four-frame does have its three diagonal blockers, as every four-arc does,
but no canonical $K-1$-blocker construction survives for the general saturated
family.  The prime-field four-point theorem therefore cannot be invoked, and the
hyperfocused analogy is discarded.

## 4. Evidence boundary and next move

Sources consulted only at the routed interface:

- Ball--Lavrauw, *Planar arcs*, Theorem 14 and its $t$-socle construction,
  `arXiv:1705.10940`, cached SHA-256
  `e9f316f5759f310c829489471b41c84972459482236df5023fb6e1f463c55872`;
- Ball--Lavrauw, *Arcs and tensors*, Lemma 4, Theorem 1, and Definition 1,
  `arXiv:1904.12800`, cached SHA-256
  `3237c740af7e4b068f27030677887354dc1bf2605b8f1a56e883fc417bdcd2d9`;
- Blokhuis--Marino--Mazzocca, *Generalized Hyperfocused Arcs in PG(2,p)*,
  definition and main theorem, `arXiv:1304.3617`, cached SHA-256
  `e99476de7becd4a901b3235fb342fcd1869f5555e6902a5f502ec0ab8430d903`.

This is a structural negative verdict, not a novelty audit.  The next bounded expert
interface is Blokhuis's lacunary-polynomial route applied directly to $C_i=0$, first
over prime fields.  It must lower degree or force a four-point pattern without assuming
generalized hyperfocused blockers; otherwise stop it at the same interface boundary.

## 5. EJ + TT closeout

**EJ.**  The cheap strengthening is that the negative verdict is not merely a failed
formula match.  Since the $t+1$ Veronese images are independent, the Ball--Lavrauw
tensor is unrestricted bilinear interpolation on the selected arc basis apart from
the already-known reciprocity.  It therefore cannot hide an additional multibase-point
rank constraint.

**TT.**  The abstraction mismatch is order, not coordinates: the tangent tensor is
order two in the planar case, whereas the first discarded angle coefficient is an
elementary-symmetric cofactor of order $t$.  The next attack should work on that
cofactor's lacunarity directly rather than add coordinate-free packaging to the
pairwise data.

## 6. Mystery ledger

| mystery | status | exact gap |
|---|---|---|
| Does the tangent tensor couple the first angle moments across base points? | settled negatively | its planar tensor has only two Veronese slots and records pairwise tangent evaluation |
| Can tangent-tensor rank force angle-matrix nullity one? | settled negatively | the $t+1$ Veronese images are independent, so the tensor construction imposes no further row relation |
| Do tensor jets recover the missing global section? | settled negatively for this interface | jets remain rowwise; their simultaneous sum needs the original $t$-fold cofactor and no degree drop is obtained |
| Does polarity supply the generalized-hyperfocused blocker set? | settled negatively | the pole of a passant chord is not on that chord, and the pencil labels depend on the base point |
| Can the cleared coefficient $C_i$ be made lacunary over prime fields? | open | next bounded Blokhuis interface; no hyperfocused hypothesis may be assumed |
