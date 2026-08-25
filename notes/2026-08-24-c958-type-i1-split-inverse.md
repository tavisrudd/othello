# C958 type-I1 split inverse

**Lane:** `cubic-threefolds`

## Result

The split blowdown from the Proposition 5.1 generic cubic surface to the
marked plane now has an explicit inverse over `Q(a,z)`.  The forward map is
the triple of quadrics `q1,q2,q3` from the preceding C958 bundle.  The inverse
is a quadruple of plane cubics

```text
[F1:F2:F3:F4] : P2 --> X_eta in P3.
```

Their expanded forms use 1084, 1254, 1434, and 2006 serialized characters.
The retained coefficient representation is smaller: its forty coefficients
use 2038 characters in the stated ten-monomial order.  This is suitable for an
ancillary exact artifact; printing the expanded cubics in a main proof would
not improve readability.

## Construction

The six points blown up in the plane are

```text
[1:0:0], [0:1:0], [0:0:1], [1:1:1], [1:A^2:B^2], [1:A:B].
```

Evaluation on these points has rank six on the ten-dimensional vector space
of plane cubics, so the cubics through them form a four-dimensional space.
This is the anticanonical linear system of the blown-up plane.

An arbitrary basis of this space gives a cubic surface in `P3`, but C958 needs
the given Tschinkel--Zhang coordinates.  The alignment is determined without
sample-point interpolation.  At each of the six base points, the first
derivatives of the four cubics span the corresponding exceptional line.  The
certificate imposes that this tangent line equal the already explicit line
`E0,...,E5` in the given cubic surface.  The resulting linear system for the
projective change of frame has rank fifteen, so its solution is unique up to a
common scalar.

This construction is intrinsic to the marked six-line configuration and
avoids a large generic projective-interpolation calculation.

## Verification of the inverse

The generator performs three exact checks.

1. Substituting `[F1:F2:F3:F4]` into the displayed cubic equation gives zero
   identically as a polynomial on the plane.
2. Substituting the four cubics into `q1,q2,q3` gives a projective triple
   proportional to `[Z1:Z2:Z3]`; both cross-products vanish identically.
3. The preceding blowdown certificate proves that `[q1:q2:q3]` is the
   birational map associated with `|H|`.

Thus the cubic map is a rational right inverse of a birational map.  It is
therefore the unique inverse on function fields, so the opposite composite is
also the identity on the common dense open.  This last implication is a
birational argument, not a second expanded degree-seven reduction.

The split-field map is consequently complete in both directions:

```text
X_eta over Q(a,z)  <-->  P2 over Q(a,z).
```

## Consequence for C958

The geometry over the splitting field is no longer a gate.  C958 now has:

- the degree-twelve rational splitting cover and its Möbius action;
- all sixteen exceptional curves;
- the exact change to the marked Cox moduli;
- the forward quadratic blowdown; and
- the inverse cubic anticanonical map.

The remaining type-`I_1` problem is arithmetic: combine these split maps with
the two stabilizing variables and descend under the explicit order-twelve
Möbius group to `Q(a,beta)`.  The rationality theorem guarantees that such a
descent exists, but C958 still requires formulas, denominators, and both
ground-field composites.

## Replay and trust boundary

From the repository root:

```text
uv run --with sympy==1.14.0 python3 \
  notes/2026-08-24-c958-type-i1-split-inverse.py \
  --check notes/2026-08-24-c958-type-i1-split-inverse.json
sha256sum -c notes/2026-08-24-c958-type-i1-split-inverse.sha256
```

The generator pins the blowdown and rational-splitting inputs.  It rebuilds
the four-dimensional cubic system, checks the rank-fifteen exceptional-line
alignment, verifies that the aligned forms land on the cubic, and checks the
plane composite by exact polynomial-ring arithmetic.  The reverse composite
uses the proved birationality of the blowdown as explained above.

The exact computations use one SymPy implementation.  An independent second
checker for the forty inverse coefficients remains part of the final C958
certificate gate.  This bundle does not certify Galois descent, a stabilized
ground-field parametrization, exceptional open sets, or the type-`I_3`
series.

Files:

- generator: 8805 bytes, SHA-256
  `4c385d0f854b98614c3b250deab73834cf5affb0738cb9ca87faa424d24a3e19`;
- certificate: 8868 bytes, SHA-256
  `1bf26a4d9793743fdb2c05ce0c4536977ebc403bab34b7afe8631d980ae3e497`.

**Vibe:** the split construction is complete and compact enough for an
artifact; the only load-bearing frontier is now ground-field descent.

## Mystery ledger

| feature | status | evidence gap or owner |
|---|---|---|
| Is the inverse map genuinely the given cubic rather than an abstract cubic model? | settled | six exceptional tangent lines determine the projective alignment with rank fifteen |
| Are both split maps inverse? | settled | `q` is the proved blowdown and the exact identity `q after F = id` makes `F` its unique birational inverse |
| Are the expanded formulas suitable for print? | settled | no; the forty-coefficient artifact is materially clearer |
| Can the order-twelve descent be expressed without a large orbit sum? | open, next | use the two stabilizing variables to linearize the Möbius action and compute invariants |
| Can a second checker verify the inverse coefficients cheaply? | open | use a separate exact implementation after the descended formulas fix the final data shape |
