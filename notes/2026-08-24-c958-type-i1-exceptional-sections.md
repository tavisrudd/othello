# C958 type-I1 exceptional sections

**Lane:** `cubic-threefolds`

## Result

The sixteen exceptional curves of the Proposition 5.1 quartic del Pezzo
generic fibre now have exact formulas over its splitting field.  This supplies
the previously missing geometric change from Tschinkel--Zhang's conic-bundle
coordinates to the odd-subset marking used by the C956 Cox quotient.

Write

```text
c(x) = x^3 - 3 a^2 x - beta,
r^3 - 3 a^2 r - beta = 0,
d^2 = 3(4 a^2-r^2),
v^2 = 3a(2a^3-beta).
```

Then the splitting field has the twelve-term basis

```text
r^i d^j v^k,     0 <= i < 3,  0 <= j,k < 2.
```

Put

```text
u  = -3(r^2-a^2)d,
e2 = vu/[9(2a^3-beta)].
```

The certificate verifies

```text
u^2  = 27(2a^3+beta)(2a^3-beta),
e2^2 = a(2a^3+beta).
```

Thus the `C3`-fixed quartic subfield has basis `1,u,v,uv`, agreeing with
`K(sqrt(discriminant(c)),e1)`.

On the cubic surface, a line skew to the distinguished line has a unique graph

```text
Y1 = A Y3 + B Y4,       Y2 = C Y3 + D Y4.
```

At each of the five singular conic fibres, choose one of its two components.
Solving the first four resulting linear conditions and imposing the fifth
gives a line exactly when the number of plus choices is odd.  Hence there are
sixteen lines.  The script gives all four coefficients for every line; the 64
formulas use 6016 serialized characters in total, with no formula longer than
170 characters.  Substitution verifies that every graph lies on the generic
cubic surface and that the sixteen graphs are pairwise distinct.

After contracting the distinguished line, these sixteen lines are precisely
the exceptional curves of the quartic del Pezzo surface.  A plus set `I` is
labelled by the standard odd-subset dictionary

```text
{i}                         Ei
{1,2,3,4,5} minus {i,j}    Lij
{1,2,3,4,5}                Q.
```

The formulas are equivariant, not merely set-theoretic.  The exact field
automorphisms

```text
sigma: r -> (-r+d)/2, d -> (-3r-d)/2, v -> v,
tau:   r -> r,        d -> -d,          v -> v,
iota:  r -> r,        d -> d,           v -> -v
```

satisfy the `C2 x S3` relations and send every displayed graph to the graph
prescribed by the odd-subset `W(D5)` action.  This realizes the abstract type
calculation of Proposition 5.1 by explicit exceptional curves.

## Consequence for C958

The missing descent bridge is now localized sharply.  We no longer need to
guess a Galois-equivariant change from the given cubic surface to the marked
exceptional-curve configuration: it is explicit in the certificate.  What
remains is to choose compatible scalar generators for the sixteen divisor
lines in the Cox ring, or equivalently to trivialize their fibres at one
rational universal-torsor point.  Only that scalar normalization separates
the present curve marking from a ground-field Cox embedding.

The formulas also give a constructive route to the split blowdown: the five
singleton curves `E1,...,E5` are explicit and can be contracted to recover the
marked plane.  Computing that contraction is the next algebraic step.  It can
either produce the Cox scalars directly or show that the conic-section model
is a smaller route to the ground-field quotient.

## Replay and trust boundary

From the repository root:

```text
uv run --with sympy==1.14.0 python3 \
  notes/2026-08-24-c958-type-i1-exceptional-sections.py \
  --check notes/2026-08-24-c958-type-i1-exceptional-sections.json
sha256sum -c notes/2026-08-24-c958-type-i1-exceptional-sections.sha256
```

The generator checks the quotient-field basis from the leading monomials,
the field automorphism relations, all five component conditions, every cubic
substitution, pairwise distinctness, and the full generator action on all
sixteen lines.  These are exact SymPy computations over `Q(a,beta)`.  A second
independent algebra implementation has not yet been written; this intermediate
bundle therefore does not serve as the final C958 composite-map certificate.

The bundle does not certify incidence numbers, the contraction to the marked
plane, scalar-normalized Cox generators, a ground-field tangent quotient, or
maps for a cubic product.

Files:

- generator: 9617 bytes, SHA-256
  `3d14534e067dd8d955ff468543862af2ed509c70ad5936588b47a672fd42e62b`;
- certificate: 11511 bytes, SHA-256
  `cb7ad6fbd78b44f692d28c057c6d591ffcca87e6f0973a50ad23d002c17fab24`.

**Vibe:** the abstract descent obstruction has become an explicit and
manageable configuration problem; no radical expansion blowup occurred.

## Mystery ledger

| feature | status | evidence gap or owner |
|---|---|---|
| Why are exactly the odd sign choices lines? | settled | exact fifth-condition reduction leaves precisely the sixteen odd subsets |
| Does the odd-subset marking agree with the type-`I_1` Galois action? | settled | all three generators are checked on every coefficient quadruple |
| Is the quartic fixed field the expected biquadratic field? | settled | `u` and `v` give the two independent quadratic characters and the checked four-term basis |
| Can the five singleton lines be contracted in compact formulas? | open, next | compute the three-dimensional linear system of the plane class from their explicit ideals |
| Does the curve-level normalization remove the Cox scalar cocycle? | open | the divisor sections still require a compatible fibre trivialization at a rational point |
| Is a direct conic-section quotient smaller than the Cox tangent quotient? | open, alternate | compare formula growth after the singleton contraction |
