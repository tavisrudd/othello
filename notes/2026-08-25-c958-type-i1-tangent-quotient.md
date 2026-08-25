# C958 type-I1 tangent-quotient infrastructure

## Result

The ground-coordinate and first inverse stages of the type-`I1` tangent
quotient are now explicit and certified.

First, the normalized strict Cox descent datum gives monomial semilinear
matrices

```text
delta_g(x)_i = c_g(i) g(x_{p_g(i)})
```

for all twelve elements of `C2 x S3`.  The orbit trace

```text
H[row,p_g(row)] += c_g(row) g(z)
```

is a `16 x 16` ground-coordinate matrix.  Its columns are fixed by the
semilinear action, and its determinant is nonzero at `z=2`.  Thus `H` is
invertible on a stated dense open and supplies an explicit ground basis of
the descended Cox representation.  No abstract choice of trace coordinates
remains.

Second, in the split Cox chart with `E3=1`, the three certified tangent-section
equations are linear in the three marked-plane coordinates `(z1,z2,z3)`.
Writing their coefficient matrix as `M(E)`, the inverse is the compact SLP

```text
(z1,z2,z3)^t = adj(M(E)) b(E) / det(M(E)),
```

with free parameters `(E1,E2,E4,E5)`.  Exact specialization at
`(a,b,E1,E2,E4,E5)=(2,3,2,3,5,7)` gives

```text
det(M) = -81442315118799347328000,
```

so the determinant is not the zero rational function.

This is a genuine partial stage, not the completed quotient.  The remaining
type-`I1` gate is the rational inverse from five ground tangent-projection
coordinates to the four exceptional parameters.  Once that inversion is
written as a shared SLP, the displayed Cramer step recovers the plane
coordinates and the existing Cox, coboundary, and norm-torus recipes complete
the two composites.

## Descent correction

A tempting shortcut was ruled out.  Acting on the fixed ground Cox lift by a
nontrivial point of the residual norm-one torus produces a Galois-invariant
`T3`-orbit, not a second ground point of the projective Cox model.  It therefore
cannot be used as the orbit-test point in a literal ground tangent section.
This is exactly the distinction made in the torsor-coupling certificate and
prevents an invalid descent claim.

## Dense open and replay

The ground basis excludes the input Cox-descent denominators and `det(H)=0`.
The split inverse additionally excludes `E1 E2 E3 E4 E5 det(M)=0` and the
usual Cox irrelevant locus.  The final tangent inverse will add its own four-
parameter denominator locus.

Primary replay:

```bash
uv run --with sympy==1.14.0 python3 \
  notes/2026-08-25-c958-type-i1-tangent-quotient.py \
  --check notes/2026-08-25-c958-type-i1-tangent-quotient.json
```

Independent stdlib replay:

```bash
python3 notes/2026-08-25-c958-type-i1-tangent-quotient-check.py \
  notes/2026-08-25-c958-type-i1-tangent-quotient.json
sha256sum -c notes/2026-08-25-c958-type-i1-tangent-quotient.sha256
```

The independent checker recomputes both exact determinants from the retained
`16 x 16` and `3 x 3` rational matrices, checks the rank and hashes, and pins
all four upstream certificates.  It does not import SymPy.

## EJ + TT closeout

The first orbit-trace attempt used `z^11`, the obvious normal-basis seed for a
degree-twelve cover.  The bounded closeout sweep found that `z` itself already
has full rank: the exact ranks for `1,z,...,z^11` are

```text
10,16,16,16,16,16,16,16,16,16,16,16.
```

Replacing `z^11` by `z` materially shortens every ground-coordinate formula.
The rank-ten constant trace also explains the failure of an unweighted orbit
average: two ground directions are lost inside the `12+4` coordinate-orbit
decomposition.

The highest-EV next move is not a general Gröbner basis.  Retain the Cramer
solution for `(z1,z2,z3)`, substitute it into four affine ratios of the five
ground tangent coordinates, and search for a low-degree inverse in the four
exceptional variables.  Exact specialization can determine the candidate
degree before interpolation over the function field.

## Mystery ledger

| feature | status | evidence gap or owner |
|---|---|---|
| Why does the constant orbit trace have rank ten? | partly settled | it loses two directions across the `12+4` coordinate orbits; a representation-theoretic decomposition would explain the exact two-dimensional defect but is not needed for the map |
| How small can the trace seed be? | settled | `z` has rank sixteen and is minimal among the tested monomials |
| Is the split section inverse triangular? | settled | all three equations have total degree one in `(z1,z2,z3)` and `det(M)` has an exact nonzero witness |
| What remains of the tangent inverse? | open, exact | invert four affine ground tangent ratios in `(E1,E2,E4,E5)` and check both composites; this is the next C958 frontier |
| Does this bundle give `Z/T3 <-> P4` or maps for `X_1 x P2`? | no | neither is claimed until the four-parameter inverse and function-field composition are certified |

**Vibe:** strong infrastructure win; descent coordinates and half of the
inverse are explicit, but the actual ground `P4` birational map remains open.
