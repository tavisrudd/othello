# C958 type-I1 coboundary divisor test

## Result

The residual rank-two descent cocycle is not a coboundary represented by a
Laurent monomial in the sixteen standard Cox forms.  This is a restriction on
one ansatz, not a nonexistence result for rational coboundaries.

The test first fixes an action convention which was easy to reverse.  The
marked-plane action on functions is contragredient to the recorded action on
the quotient cocharacter lattice.  With the direct convention the augmented
linear system has ranks `(31,32)` and is inconsistent.  With the dual
convention both ranks are `31`; its rational solution space is one-dimensional.

Write its parameter as `tau0`.  Two exponents in the first coordinate are

```text
E1: 1/2 - tau0
E2: 1/2 + 2 tau0.
```

If the first is integral, `tau0` is congruent to `1/2` modulo the integers,
and the second is then congruent to `3/2`.  Hence the solution lattice has no
integral point.  This parity witness proves the asserted Cox-monomial
obstruction without a search bound.

## Inputs and replay

The replay pins the exceptional-section action and the normalized Cox cocycle
by SHA-256.  It reconstructs the sixteen permutation divisors, the Picard-class
matrix, both action conventions, and the full rational linear systems.

```bash
uv run --with sympy==1.14.0 python3 \
  notes/2026-08-25-c958-type-i1-coboundary-divisor-test.py \
  --check notes/2026-08-25-c958-type-i1-coboundary-divisor-test.json
```

The adjacent `.sha256` file binds the script and retained certificate.

## Consequence for C958

Do not spend further time seeking a single Cox-monomial translation.  A
general rational Hilbert--90 coboundary remains possible, but the constructive
route should use the full stable-permutation resolution
`Pic(Sbar) + P5 = P11`.  That resolution is designed to replace this residual
torus by a permutation torus and should yield orbitwise ground-field
coordinates without an index-three or half-integral character defect.

