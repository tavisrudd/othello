# C958 type-I1 rational splitting cover

**Lane:** `cubic-threefolds`

## Result

The splitting field of the generic type-`I_1` quartic del Pezzo surface in
Tschinkel--Zhang Proposition 5.1 is a rational function field.  More
precisely, after adjoining one parameter `z`, all of their radicals become
rational functions of `a,z`, and the original parameter `beta` is the
degree-twelve invariant

```text
beta = 2 a^3
       (z^4-18z^2+9)
       (z^4-12z^3-18z^2+36z+9)
       (z^4+12z^3-18z^2-36z+9)
       /(z^2+3)^6.
```

The root `r` of `x^3-3a^2x-beta`, its conjugate difference `d`, and the two
quadratic radicals are

```text
r  = 2a(z^4-18z^2+9)/(z^2+3)^2,
d  = -24az(z^2-3)/(z^2+3)^2,
e1 = 36a^2z(z-3)(z-1)(z+1)(z+3)/(z^2+3)^3,
e2 = 2a^2(z^2-3)(z^2-6z-3)(z^2+6z-3)/(z^2+3)^3.
```

Conversely, with `m=d/(r-2a)`, one recovers

```text
z = m + 18a^2(m^2-1)/(e1(m^2+3)).
```

Thus these formulas identify the splitting field with `Q(a,z)`, not merely
with a subfield of it.

## Galois action and quotient

The three generators act on the rational line by

```text
sigma(z) = -(z+3)/(z-1),
tau(z)   = 3/z,
iota(z)  = -3/z.
```

The exact replay generates twelve distinct Möbius transformations, verifies
the `C2 x S3` relations, and checks that every transformation fixes `beta`.
The numerator and denominator of `beta(z)` are coprime of degree twelve.
Consequently

```text
Q(a,z) / Q(a,beta)
```

is the generic degree-twelve Galois cover with this group, and `beta` is a
coordinate on its rational quotient.  The transformations reproduce exactly
the actions on `r,d,e1` used in the type-`I_1` calculation.

This is stronger computational input than a radical presentation.  Descent
can now be performed by invariant theory for an explicit finite subgroup of
`PGL2`, and specializations can be evaluated without constructing a cubic
splitting field or choosing three roots separately.

## Exceptional curves

Substitution into the preceding C958 bundle rationalizes all sixteen
exceptional-line graphs over `Q(a,z)`.  Their 64 coefficient formulas shrink
from 6016 to 2916 serialized characters; the longest shrinks from 170 to 69.
For example, the singleton `E1` becomes

```text
A = -a(z^2-3)(z^4+54z^2+9)/(z^2+3)^3,
B = -(z^2-3)/(z^2+3),
C = 2az(5z^4-18z^2+45)/(z^2+3)^3,
D = -2z/(z^2+3).
```

The new generator rechecks every cubic substitution and the full Galois
action after rationalization; it does not merely rewrite retained strings.

## Consequence for C958

The highest-value next step is now the split contraction in `Q(a,z)`, not
abstract Hilbert 90.  The five singleton lines are compact rational graphs.
A common reducible twisted cubic and each of the three coordinate twisted
cubics determine a quadric through six known lines; their three quadric
equations give the blowdown map to the marked plane.  Once computed, the
Möbius action can descend that map and expose the remaining Cox scalar factors
directly.

The degree-twelve quotient formula may also have independent value as an
explicit generic splitting cover for the type-`I_1` series.  No novelty claim
is made here; promotion would require a bounded literature audit and a proof
written independently of the symbolic replay.

## Replay and trust boundary

From the repository root:

```text
uv run --with sympy==1.14.0 python3 \
  notes/2026-08-24-c958-type-i1-rational-splitting-cover.py \
  --check notes/2026-08-24-c958-type-i1-rational-splitting-cover.json
sha256sum -c notes/2026-08-24-c958-type-i1-rational-splitting-cover.sha256
```

The generator pins the SHA-256 of the exceptional-section certificate.  It
checks both directions of the field change, all radical identities, the full
Möbius group, invariance and degree of the quotient map, every rationalized
line, and the generator action on every coefficient.  These are exact SymPy
computations.  There is not yet a second independent algebra implementation;
the final C958 map certificate must supply one or state a stronger reason for
the remaining trust boundary.

The bundle does not certify the singleton contraction, Cox scalar
normalization, a ground-field quotient section, or maps for the cubic product.

Files:

- generator: 7134 bytes, SHA-256
  `240eb80a20521a4fb1ccb85e5d95e7e9764a350199617bec24503a4ff70071f1`;
- certificate: 7602 bytes, SHA-256
  `1b2d5a2a53baee1acae52e7ad566f3daacd3e72f79ad7b2bc24e0766129adefa`.

**Vibe:** excellent; the degree-twelve radical tower collapses to one rational
parameter with a small Möbius action, and the explicit formulas get shorter.

## Mystery ledger

| feature | status | evidence gap or owner |
|---|---|---|
| Why is the full splitting field rational? | settled algebraically | the two successive quadratic expressions combine into the conic `n^2-m^2=3`, parametrized by `z=n+m` |
| Is `beta` the full invariant rather than a proper subinvariant? | settled | the Möbius group and the rational map both have degree twelve |
| Does this simplify the exceptional curves materially? | settled | total formula size falls by more than half and every formula has at most 69 characters |
| Does the quotient formula occur already in the literature? | open, not task-critical | bounded novelty audit only if promoted beyond the C958 artifact |
| Do the quadric blowdown formulas stay comparably small? | open, next | solve the three six-line interpolation problems in `Q(a,z)` |
| Can the Möbius model descend the final quotient without a Cox normalization? | open | test after the contraction exposes the plane and line-bundle scalars |
