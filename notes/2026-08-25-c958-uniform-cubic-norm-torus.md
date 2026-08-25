# C958 uniform cubic norm-torus chart and type-I3 residual factor

**Lane:** `cubic-threefolds`

## Result

The residual rank-two torus for type `I3` is now identified integrally, not
only declared rational by the classification of two-dimensional tori.  The
full order-24 type-`I3` group acts on the quotient cocharacter lattice through
an order-six image; its order-four kernel acts trivially.  A displayed
unimodular change of basis identifies that image with the permutation action
on

```text
ker(Z^3 -> Z).
```

For the cubic algebra in Tschinkel--Zhang Proposition 5.2 this gives

```text
E3 = K[rho]/(rho^3-a^2*rho+a^3+beta),
T0/T3 = R^1_{E3/K}(Gm).
```

The discriminant is checked directly as

```text
-23*a^6-54*a^3*beta-27*beta^2.
```

Thus the type-`I3` residual factor is the same integral norm-one-torus class
as the type-`I1` factor; it is not a new torus-parametrization problem.

## Uniform chart

The retained generator proves one formula over the universal depressed cubic
algebra

```text
E = K[rho]/(rho^3+p*rho+q).
```

For `x` of norm one, set

```text
(Z,h) = (x+x^-1+1-Tr(x), N(x-1)).
```

Then `(Z,h)` lies on

```text
e2(Z)+h*Tr(Z)+h^2=0,
```

and the inverse is `x=1+h/Z`.  This quadric contains the ground point
`[p:0:1:-p]`; projection from that point gives explicit mutually inverse maps
with `P2`.  The generator verifies the quadric equation, the projection
composite, both norm-torus composites, and the distinguished norm-one point
`1+(p/q)rho` symbolically over `Q(p,q)`.

The two C958 cases are now substitutions in the same certificate:

```text
type I1: p=-3*a^2, q=-beta
type I3: p=-a^2,   q=a^3+beta.
```

A common certified open is

```text
q*(4*p^3+27*q^2)*polar*h*N(Z) != 0.
```

## Paper and reuse boundary

This removes the only abstract Voskresenskii step for the residual factors of
the two explicit cubic families and supplies a compact constructive lemma that
can replace it after the final maps pass.  The formulas belong in a short
lemma or appendix; their expanded coordinates belong in the JSON artifact.

The same chart is reusable by C963 as a stable-rationality interface and by
C965 whenever an automated lattice calculation returns an `S3` augmentation
quotient.  It also applies after restriction to the smaller Galois types.

This bundle does **not** certify the type-`I3` universal-torsor coboundary,
the ground tangent coordinates, the substitution into either cubic
function field, or the final composites.

## Replay

From the repository root:

```text
uv run --with sympy==1.14.0 python3 \
  notes/2026-08-25-c958-type-i3-residual-norm-torus.py \
  --check notes/2026-08-25-c958-type-i3-residual-norm-torus.json
uv run --with sympy==1.14.0 python3 \
  notes/2026-08-25-c958-cubic-norm-torus-parametrization.py \
  --check notes/2026-08-25-c958-cubic-norm-torus-parametrization.json
sha256sum -c notes/2026-08-25-c958-uniform-cubic-norm-torus.sha256
```

The lattice calculation is reconstructed from C956's transcribed type-`I3`
matrices.  The cubic equation is checked against Tschinkel--Zhang,
arXiv:2608.20029v1, cached PDF SHA-256
`be1dedd42662eae0c9d83d08d7379cdd78974000f0be048db50680833a5d01e6`.

Artifact sizes are 4,178 bytes for the residual-lattice generator, 1,269 for
its JSON certificate, 5,984 for the uniform-chart generator, and 2,534 for
its JSON certificate.  There is not yet a second algebra implementation of
the universal symbolic identities; the two specializations are independently
checked again when composed with the family maps, and no broader independent
claim is made here.

## Mystery ledger

| feature | status | evidence or remaining gate |
|---|---|---|
| Is the type-`I3` residual torus a different birational case? | settled | its cocharacter lattice is unimodularly the same `S3` augmentation lattice |
| Does the extra order-four splitting-field kernel affect it? | settled | the exact residual image has order six and kernel order four |
| Can one formula cover both explicit cubic families? | settled | the universal depressed-cubic certificate specializes to both |
| Can the paper replace the abstract rank-two classification step now? | not yet | wait for the torsor coupling and final localized composites |

**Vibe:** a clean reuse win: type `I3` inherits the compact norm-torus chart
instead of opening a second elimination problem.
