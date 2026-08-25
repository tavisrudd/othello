# C958 type-I1 torsor coupling

## Result

The type-`I1` universal-torsor coboundary and the rational norm-torus chart
have now been coupled.  They give a `K`-birational straight-line map

```text
S x P2  <->  Z/T3,
```

where `S` is the generic quartic del Pezzo surface, `Z` is its projective Cox
model, and `T3` is the saturated rank-three subtorus used in C956.  Both
composites are explicit on a stated dense open.

This closes the second ground-field gate identified in the residual-torus
report.  The remaining type-`I1` task is not torsor descent: it is an explicit
ground-field tangent-section map `Z/T3 <-> P4`, followed by the already
understood generic-fibre passage to the cubic product.

## Forward map

Let `f_D(z,u,v)` be the standard marked-plane Cox section and let `h_D` be
the evaluation of the certified six-coordinate coboundary on the divisor
class of the Cox generator `D`.  Use the neutral `E3` lift of the residual
torus action.  Its weights are

```text
E1:(1,0), E2:(0,1), E3,E4,E5:(0,0),
Lij:(-1 if 1 occurs, -1 if 2 occurs), Q:(-1,-1).
```

For residual coordinates `(r1,r2)`, put

```text
q_D = f_D h_D^(-1) r1^a_D r2^b_D.
```

The coboundary identity makes the resulting `T3`-orbit Galois invariant.
Thus this split-coordinate SLP defines a map over `K`.

The residual torus is the norm-one torus with conjugates
`t1 t2 t3=1`.  Dualizing the certified cocharacter change of basis gives

```text
r1=t3,   r2=1/t1;
t1=1/r2, t2=r2/r1, t3=r1.
```

Composing these formulas with the certified `P2 <-> R^1_E(Gm)` chart gives
the two stabilizing parameters over the ground field, without choosing roots
in the final map.

## Inverse map

The marked-plane point is recovered projectively by

```text
U=q_E2 q_E3 q_L23,
V=q_E1 q_E3 q_L13,
W=q_E1 q_E2 q_L12.
```

Each monomial has Picard class `H` and residual weight zero.  After the
forward substitution they become the common factor `h_H^(-1)` times
`(u,v,1)`.  Hence they recover the surface point.

At that recovered point, reevaluate the coboundary SLP and put

```text
r1=(q_E1/q_E3)(h_E1/h_E3),
r2=(q_E2/q_E3)(h_E2/h_E3).
```

These recover the residual torus coordinates exactly.  The inverse norm-torus
chart then recovers the two projective parameters.  This proves both
composites without expanding the coboundary.

## Replay and scope

```bash
uv run --with sympy==1.14.0 python3 \
  notes/2026-08-25-c958-type-i1-torsor-coupling.py \
  --check notes/2026-08-25-c958-type-i1-torsor-coupling.json
```

The adjacent `.sha256` file binds the generator and certificate.  The replay
pins the coboundary, residual-lattice, and norm-chart certificates; checks
the character conversion, every residual Cox weight, the three degree-`H`
inverse monomials, and the residual-coordinate inverse.

The dense open excludes the coboundary denominators and Hilbert--90 seed
zeros, the irrelevant Cox locus, the norm-chart exceptional factors, and the
two exceptional-coordinate denominators.  The certificate does not yet give
the tangent quotient `Z/T3 <-> P4`, the resulting cubic-product maps, or the
type-`I3` analogue.

