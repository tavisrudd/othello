# C958 type-I1 norm-one-torus parametrization

**Lane:** `cubic-threefolds`

## Result

The residual type-`I_1` torus now has explicit forward and inverse rational
maps over the ground field.  For

```text
E = K[rho]/(rho^3-3a^2 rho-beta),
T = R^1_{E/K}(Gm),
```

the certificate gives a birational map `P2 -> T` and its inverse.  The total
printed formula sizes are small: 188 characters for the plane-to-quadric
stage, 391 for the quadric-to-torus stage, and 271 for the inverse map to the
plane.

This closes the first of the two ground-field gates left by the residual-
torus calculation.  The remaining type-`I_1` gate is to couple this chart to
the equivariant universal-torsor trivialization of the quartic del Pezzo
surface.

## The norm cubic and its quadric model

Write `x=x0+x1 rho+x2 rho^2`.  The torus is the affine cubic `N(x)=1`, with
the norm polynomial printed in the certificate.

Over a splitting field, let `t1,t2,t3` be the three conjugates of `x`; then
the projective closure is

```text
t1 t2 t3 = w^3.
```

Its three singular points at infinity are the coordinate points.  Together
with the rational point `(1,1,1,1)`, they form a projective frame.  Put

```text
yi = ti-w  (i=1,2,3),     y4=w,
```

and apply the standard Cremona transformation based at that frame.  After
removing the common exceptional factor, the cubic becomes the quadric

```text
z1 z2 + z1 z3 + z2 z3 + h(z1+z2+z3) + h^2 = 0.
```

The construction descends without choosing the three roots.  If `Z` is the
element of `E` whose conjugates are `z1,z2,z3`, the quadric is

```text
e2(Z) + h Tr(Z) + h^2 = 0.
```

In the basis `1,rho,rho^2`, this is

```text
9a^4 z2^2 + 6a^2 h z2 + 12a^2 z0 z2
-3a^2 z1^2 -3 beta z1 z2 + h^2 +3h z0 +3z0^2 = 0.
```

The two maps between the norm cubic and this quadric are especially short:

```text
x |-> (Z,h) = (x+x^{-1}+1-Tr(x), N(x-1)),
(Z,h) |-> x = 1+h Z^{-1}.
```

The generator verifies the cleared-denominator identities

```text
Q(Z,h) = (N(x)-1)N(x-1)
```

for the first map and

```text
N(1+h/Z)-1 = h Q(Z,h)/N(Z)
```

for the second.  It also verifies both composites exactly.  Over the
splitting field these identities are immediate from

```text
zi=(tj-1)(tk-1),     h=(t1-1)(t2-1)(t3-1).
```

## Parametrizing the quadric

The norm-one point `x=rho^3/beta` maps to the ground-field point

```text
P = [-3a^2 : 0 : 1 : 3a^2]
```

on the quadric.  Project from `P` to the plane `z2=0`.  For plane coordinates
`[u:v:w]`, put

```text
q = [u:v:0:w],
B(P,q) = 3(a^2u+a^2w-beta v).
```

The second intersection of the line through `P` and `q` with the quadric is

```text
Q(q)P-B(P,q)q.
```

The certificate expands its four coordinates and proves that they satisfy
the quadric equation.  Projection back is

```text
[z0:z1:z2:h] |-> [z0+3a^2z2 : z1 : h-3a^2z2],
```

and the replay checks that its composite with the displayed map is
`-B(P,q)[u:v:w]`.  Thus projection is birational on `B(P,q) != 0`.

Composing projection with `x=1+h/Z` gives the promised map `P2 -> T`.  The
inverse is obtained by applying `(Z,h)=(x+x^{-1}+1-Tr(x),N(x-1))` and then
the displayed projection.  A convenient common dense open is

```text
B(P,q) h N(Z) != 0.
```

## Why the ratio construction had degree three

The seven tempting split functions `1` and `ti/tj` do not give a faithful
anticanonical model of this torus.  The ratios generate the `A2` root
sublattice, which has index three in the character lattice of the norm-one
torus.  Hence that map factors through a degree-three isogeny.  Exact
specialized elimination gave degree three after saturation, as the lattice
calculation predicts.  The Cremona construction above works on the norm
cubic itself and avoids this index-three loss.

## Replay and trust boundary

From the repository root:

```text
uv run --with sympy==1.14.0 python3 \
  notes/2026-08-25-c958-type-i1-norm-torus-parametrization.py \
  --check notes/2026-08-25-c958-type-i1-norm-torus-parametrization.json
sha256sum -c notes/2026-08-25-c958-type-i1-norm-torus-parametrization.sha256
```

The generator reconstructs multiplication in `E`, derives the norm and
quadric equations, checks the rational point and plane projection, and
proves both cleared-denominator composite identities symbolically.  The JSON
retains every coordinate of the forward and inverse maps.

The computation uses one SymPy implementation.  It does not yet certify the
equivariant universal-torsor translation or the final maps for the cubic
threefold.  Voskresenskii's general rationality theorem for two-dimensional
tori is DOI `10.1070/IM1967v001n03ABEH000580`; the formulas here give the
specialized constructive argument needed by C958.

## Mystery ledger

| feature | status | evidence gap or owner |
|---|---|---|
| Is the residual norm-one torus rational over `K`? | settled constructively | explicit maps and both composites |
| Does the parametrization descend without roots or radicals? | settled | every coefficient lies in `Q(a,beta)` |
| Why did the conjugate-ratio model have degree three? | settled | it uses the index-three root sublattice |
| How is the torus chart coupled to the surface? | open, next | compute the equivariant universal-torsor translation |
| Are the final maps for `X_1 x P2` available? | open | compose after the torsor coupling is certified |
