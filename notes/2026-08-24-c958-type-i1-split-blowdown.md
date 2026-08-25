# C958 type-I1 split blowdown

**Lane:** `cubic-threefolds`

## Result

The marked blowdown of the type-`I_1` generic cubic surface to the plane is
now explicit over its rational splitting field `Q(a,z)`.  It is given by three
quadrics in `Y1,Y2,Y3,Y4`; their thirty coefficients occupy 1862 serialized
characters, with no coefficient longer than 115 characters.  The exact
coefficient vectors and monomial order are retained in the certificate.

Let `E0` be the distinguished line contracted to pass from the cubic surface
to the quartic del Pezzo surface.  On the cubic surface, use the common
reducible twisted cubic

```text
R = Q0 + L01 + Q1.
```

The last two lines are the two components `F1+` and `F1-` of the first
singular conic fibre, so their ordering is immaterial.  The three coordinate
twisted cubics are

```text
D1 = E2+E3+L23,
D2 = E1+E3+L13,
D3 = E1+E2+L12.
```

For each `i`, the certificate solves the eighteen line-incidence equations
for a quadric through `R+Di`.  Each coefficient matrix has rank nine, hence a
one-dimensional kernel.  The resulting quadrics `q1,q2,q3` are linearly
independent and have no common factor in the ambient polynomial ring.

The geometric identification does not depend on trusting elimination.  In
the blowup lattice of the cubic surface,

```text
[Di] = H,
[R]  = 5H-2(E0+E1+E2+E3+E4+E5) = -2K-H.
```

Thus `R+Di` has class `-2K`, the class cut by a quadric.  Since the checked
quadric already contains the six displayed lines, equality of divisor classes
shows that its restriction is exactly `R+Di`.  The common divisor `R` cancels
from the ratios, and

```text
[q1:q2:q3]
```

is the rational map associated with `|H|`, hence the marked blowdown to the
plane.

## The six plane points

Put

```text
A = (z-1)(z+3)(z^2-3) / [2z(z^2-6z-3)],
B = -(z-3)(z+1)(z^2-3) / [2z(z^2+6z-3)].
```

After scaling the three plane coordinates so that the fourth marked point is
`[1:1:1]`, the six contracted lines map to

```text
E1 -> [1:0:0],       E2 -> [0:1:0],
E3 -> [0:0:1],       E4 -> [1:1:1],
E5 -> [1:A^2:B^2],   E0 -> [1:A:B].
```

Every restriction of the three quadrics to each line has rank one, so the
point is constant along the line.  The replay also verifies that the six
points are pairwise distinct over the generic field.

This gives the missing change to the split Cox parameters in closed form:

```text
a_split = A^2,       b_split = B^2.
```

The distinguished sixth blowup point is the coordinatewise square root of
the fifth quartic blowup point.  This is not a numerical pattern: it is an
exact identity in `Q(a,z)`.

## Consequence for C958

The generic C956 Cox formulas can now be specialized to the actual
Proposition 5.1 surface by the explicit substitution

```text
(a_Cox,b_Cox) = (A^2,B^2).
```

There is no longer an unknown geometric change of marking.  Two steps remain
before a ground-field stabilized parametrization:

1. compute the inverse anticanonical map from the plane through the six
   displayed points and align it with the given cubic coordinates;
2. combine the split quotient map with the Möbius Galois action and the two
   stabilizing variables to descend the composite to `Q(a,beta)`.

The first is now ordinary four-dimensional linear algebra on plane cubics.
The second is an explicit invariant-field problem, not an abstract descent
existence statement.

## Replay and trust boundary

From the repository root:

```text
uv run --with sympy==1.14.0 python3 \
  notes/2026-08-24-c958-type-i1-split-blowdown.py \
  --check notes/2026-08-24-c958-type-i1-split-blowdown.json
sha256sum -c notes/2026-08-24-c958-type-i1-split-blowdown.sha256
```

The generator pins the rational-splitting certificate.  It reconstructs all
line restrictions, computes the three rational-function nullspaces, checks
their ranks, verifies every required vanishing, and independently restricts
the final quadrics to all six contracted lines.  The divisor-class argument
above identifies the resulting ratios with the plane blowdown.

The symbolic linear algebra and substitutions use one exact SymPy
implementation.  No independent second implementation has yet checked the
thirty coefficients.  The bundle does not certify the inverse anticanonical
map, Galois descent of the blowdown, a universal-torsor Cox normalization, or
maps for the stabilized cubic product.

Files:

- generator: 9031 bytes, SHA-256
  `07351ce1c8cb553015a35d49ddc00c9728fa7e7defc980cdfd035b3125c29751`;
- certificate: 4570 bytes, SHA-256
  `4e1d3dd013ea7fdf998d775386e905afb4be298b601b369fbe84347d44021fba`.

**Vibe:** excellent; the abstract marked-plane descent has become three
compact quadrics and a six-point configuration with a striking square-root
form.

## Mystery ledger

| feature | status | evidence gap or owner |
|---|---|---|
| Why do quadrics recover a degree-one plane system? | settled | each divisor is `R+Di` with classes `-2K-H` and `H`; the fixed part cancels |
| Why is the sixth point `[1:A:B]` while the fifth is `[1:A^2:B^2]`? | settled computationally, structure unexplained | exact restriction identities prove it; a conceptual conic-bundle explanation may shorten the eventual proof |
| Is the split Cox modulus change explicit? | settled | `a_split=A^2`, `b_split=B^2` |
| Can the inverse cubic map be written compactly? | open, next | compute the four-dimensional space of cubics through the six points and align its basis |
| Can the split map descend without printing radical orbit sums? | open | use the order-twelve Möbius action and two stabilization variables |
