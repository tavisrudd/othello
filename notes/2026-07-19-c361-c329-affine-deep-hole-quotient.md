# C361: affine deep-hole quotient and complete C329 enumerator

**Lane:** `crowns`

**Date:** 2026-07-19

**Verdict:** `BOUNDED STOP; EXACT SECANT CORRESPONDENCES, NO FINITE INTRINSIC COUNT`

## Signed decision

C348's affine quotient admits a clean symbolic reduction, but it does not collapse to a closed
formula or a finite intrinsic stratification.  For each intrinsic normal form
`[rho;{a,b}]`, affine secant coverage is the union of ten explicitly rational correspondences:
four within-layer absolute-trace gates, one seed--seed correspondence with generic fiber quintic,
one repair--repair correspondence with generic fiber quadratic, and four seed--repair
correspondences with generic fiber octic.  The sources are rational and their main components are
geometrically irreducible and generically separable.  The obstruction is arithmetic rather than a
missing geometric component: an affine hole is a base point at which all six cross-layer fiber
polynomials are rootless and all four trace gates fail.

Thus the requested exact value `M(rho,a,b)` is equivalent to a joint factorization-type count for
four parameter-dependent octics, one quintic, and one quadratic over a three-dimensional intrinsic
base.  Neither the secant equations nor C348's pinned literature supplies that joint Frobenius
distribution.  Writing it as a sum over all `Q^3` quotient representatives is mechanically exact
but fails C361's explicit stop rule.  No complete extended enumerator or exact total one-/two-column
extension count follows beyond C348's already exact infinity subcomplex.

This is the task's bounded `STOP`, not an asymptotic nonexistence claim.  It identifies the minimal
missing theorem and leaves C348 as the publication endpoint.

## Exact quotient correspondence

Write every layer as

```text
L(c,k)={P(c omega+t,k):t in F},
P(x,k)=[1:x:x^2+k],
```

with the four pairs

```text
(c,k)=(0,a),(0,b),(1,0),(rho,0).
```

Let `[1:u:v]` be affine and use C348's orbit coordinates

```text
xi=u^Q+u in F,                 eta=v+u^2 in E.
```

For a secant between `L(c,k)` and `L(c',k')`, simultaneous translation by the first
`F`-parameter leaves `(xi,eta)` fixed.  Put

```text
d=c+c',        K=k+k',        p=r+d omega,
tau=xi+c,      z=x+tau omega,  x,r in F.
```

When `p!=0`, direct substitution on the line through the two layer points gives the complete
coverage correspondence

```text
eta = z^2 + (p+K/p)z + k.                              (1)
```

Conversely every `x,r` in (1) is a point on such a secant, so there is no closure or
algebraic-extension relaxation in this criterion.  If `d=0`, `r=0`, and the layers are distinct,
the secant is vertical; it contributes exactly the plane `xi=c`.  This is the seed--seed vertical
component.  For a repeated layer, `r=0` is excluded because the two endpoints coincide.

Equation (1) derives all ten types directly in `(xi,eta)`.  It also explains C330's seven families:
at infinity the line parameter `z` disappears and only the direction `p+K/p` remains; the four
repeated-layer types all give `F^*`.

## Four closed within-layer gates

Write `eta=eta_0+eta_1 omega` and `k=k_0+k_1 omega`.  For a repeated layer put
`tau=xi+c`.  If `tau!=0`, (1) determines

```text
r=(eta_1+k_1+tau^2)/tau.                               (2)
```

Coverage by a within-layer secant holds exactly when

```text
r!=0  and  Tr_F/F2((eta_0+k_0+tau^2)/r^2)=0.           (3)
```

Indeed the remaining equation is

```text
x^2+r x+(eta_0+k_0+tau^2)=0.
```

If `tau=0`, coverage holds exactly when `eta_1=k_1`: for `Q>=4`, one can choose
`x,r in F`, `r!=0`, for every base coordinate.  Therefore the four same-layer contributions are
genuine closed trace gates.  The adjacent checker verifies (2)--(3) against direct enumeration for
all `393,216` layer/quotient pairs in the three C348 fixtures.

## Cross-layer elimination and degrees

For `d!=0`, write `K=K_0+K_1 omega` and set

```text
n  =r^2+d r+d^2,
M_0=r n+K_0(r+d)+K_1 d,
M_1=d n+K_0 d+K_1 r.
```

Then `p+K/p=(M_0+M_1 omega)/n`.  Put

```text
C=eta_1+tau^2+k_1,
D=eta_0+tau^2+k_0,
X=C n+tau(M_0+M_1).
```

Off the explicit exceptional divisor `M_1=0`, eliminating `x` gives

```text
P(r)=D n M_1^2+n X^2+M_0 X M_1+tau M_1^3=0.           (4)
```

The original two coordinate equations handle the at most two exceptional `r` values; clearing
denominators in (4) is not allowed to create roots there.  The four seed--repair types have
`d in {1,rho}` and `K in {a,b}`.  Their generic polynomial (4) has degree eight.  Its degree drops
on explicit intrinsic divisors such as `tau in {0,d}` and on coefficient-cancellation loci, but
those drops do not decide root existence on the remaining open stratum.

For the repair--repair pair, `K=0`; (1) has slope `p`, and elimination reduces to a quadratic in
`r`.  For the seed--seed pair, `d=0`, `K_1!=0` because `a+b notin F`.  With `r!=0`, put

```text
X=C r+tau(r^2+K_0+K_1).
```

The eliminated equation is

```text
D r K_1^2+r X^2+(r^2+K_0)XK_1+tau K_1^3=0,            (5)
```

generically a quintic.  Its separate `r=0` vertical component is exactly the already stated
`xi=0` plane.

Before elimination, every main correspondence is the graph of (1) over a rational source with
coordinates `(xi,x,r)`, hence is a geometrically irreducible rational threefold.  The direct
Jacobian of `(eta_0,eta_1)` with respect to `(x,r)` is nonzero on a dense open for every one of the
three displayed classes, proving generic separability.  The exceptional divisors above are chart
or degree-drop strata inside that source, not hidden top-dimensional components.  This completes
the requested dimension, degree, separability, and component audit.

## Why this does not yield a finite intrinsic stratification

The coefficient and degree-drop divisors give a finite geometric stratification, but rootlessness
over `F` is not constant on its open strata.  On the generic open, coverage asks whether (4) or (5)
has an `F`-root; affine holes require simultaneous rootlessness for all five higher-degree fibers,
rootlessness of the repair quadratic, and failure of (3) four times.  Equivalently, one needs the
joint Frobenius classes in the compositum of their splitting covers over

```text
B={(xi,eta_0,eta_1)} subset A^3_F.
```

This is the minimal missing invariant-counting theorem.  Dimensions and discriminant strata alone
do not determine those Frobenius classes, and Hasse--Weil or Chebotarev would at best give an
estimate after proving monodromy and component data for many fiber products.  An estimate is below
C361's exit gate.  A literal exact expression

```text
M(rho,a,b)=sum_(xi,eta_0,eta_1 in F) 1[all ten gates fail]
```

is merely the forbidden `Q^3` representative sum in new notation.  The bounded derivation therefore
stops here rather than relabelling that sum as a classification or launching a larger census.

## Independent finite replay

The adjacent checker implements (1) from scratch over
`F=GF(32)` and `E=GF(1024)`.  It unions the ten quotient images and compares the result with C348's
pinned canonical output, whose counts were obtained by direct projective line incidence rather than
quotient equations.  It checks all `98,304` quotient representatives and recovers:

| intrinsic fixture `(rho;a;b)` | quotient holes `M` | affine points `QM` |
|---|---:|---:|
| `9;(27,13);(8,24)` | 4 | 128 |
| `28;(0,24);(31,25)` | 5 | 160 |
| `3;(18,5);(15,31)` | 3 | 96 |

The canonical JSON also records the ten exact hole-orbit coordinates.  This independently replays
C348's falsifier and confirms that the correspondence loses neither vertical secants nor quotient
orbits.  It does not extrapolate from `Q=32` or prove a large-field distribution.

Regenerate from `/home/tavis/src/othello` with

```text
python3 notes/2026-07-19-c361-c329-affine-deep-hole-quotient.py \
  --output notes/2026-07-19-c361-c329-affine-deep-hole-quotient.json
```

Check canonical regeneration and hashes with

```text
python3 notes/2026-07-19-c361-c329-affine-deep-hole-quotient.py --check
sha256sum -c notes/2026-07-19-c361-c329-affine-deep-hole-quotient.sha256
```

The trusted boundary is the script's independent polynomial-basis arithmetic, the quotient map
(1), Python integer/JSON support, and C348's pinned direct-incidence JSON at SHA-256
`ecc8881e02de212ed89479f8b0fa564f6db652d74a10ff65a3bf206f6a5d3eee`.  The report's elimination
identities are proof-derived; the fixtures validate conventions and exact finite counts only.
The script is 7,990 bytes with SHA-256
`57333f24fb3b1c504d26128d003241220b1a8c05ff52a63e44895a1e541ae3fc`; the canonical JSON is
2,832 bytes with SHA-256
`64934da15a66094b3dd9bc9cfadaa60abe81b67338ea01868b1c2011c1d8c47d`.  The adjacent manifest pins
both.

## Enumerator and extension boundary

C348 remains exact conditionally on

```text
h(A)=Q M(rho,a,b)+u(rho,a,b),
u(rho,a,b)=Q^2-|D(A)|,
```

with `D(A)` its seven explicit reciprocal images.  Substitution into C348's formulas gives the
complete scalar-extension enumerator once `M` is supplied, but C361 has not supplied a closed
all-field `M`.  The exact infinity extension counts remain

```text
u(A) one-column extensions and binom(u(A),2) two-column extensions,
```

with no infinity three-column extension.  Total extension counts involving affine holes and the
complete enumerator remain unclassified.  No paper-facing novelty claim is added, so the pinned
C348 literature matrix remains the correct boundary and no priority inference is drawn from this
negative reduction.

## Vibe check

Scientifically clean but disappointing as an upgrade: the quotient geometry compresses to exact
low-degree fibers and replays perfectly, yet the surviving problem is a genuine joint Frobenius
distribution rather than a missed coordinate trick.  C348 should be published for its conditional
enumerator and exact infinity-extension theorem; C361 should not be marketed as a completed affine
classification.
