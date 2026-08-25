# C958 specialized quintic tangent inverse

## Result

At the exact split specialization

```text
(a,b)=(2,3), tangent z=(1,3,7), E3=1,
```

the remaining four-parameter tangent map has a compact rational inverse of
total degree five as a candidate with strong independent evidence.  With

```text
y_i=rho_i/rho_0,  1 <= i <= 4,
```

the retained formulas are

```text
E1=N1(y)/D(y), E2=N2(y)/D(y),
E4=N4(y)/D(y), E5=N5(y)/D(y).
```

The four numerator quintics have respectively `75,69,55,63` nonzero terms;
the common denominator has `55`.  After one common integral normalization,
all coefficients have at most twenty-five decimal digits.  The formulas are
stored sparsely in the adjacent JSON certificate.

This materially narrows the type-`I1` tangent frontier: the inverse is not an
unstructured elimination output, but a unique common-denominator quintic at a
cold smooth specialization.

## Exact and independent checks

The primary replay first works modulo `1000003` in the complete affine
monomial spaces.  Degrees one through four have zero interpolation kernel for
each exceptional coordinate.  At degree five each kernel is one-dimensional,
and the four formulas pass one hundred fresh modular holdouts.  Thus no
degree-at-most-four inverse exists in those full searched spaces modulo the
chosen prime.

The unique supports are then lifted over the rationals.  Exact nullspaces on
independent rational samples produce the displayed integer coefficients; all
four formulas pass thirty further exact rational holdouts and their
denominators agree exactly.

An independent stdlib checker, which imports neither SymPy nor the generator,
reconstructs the slice and tangent maps from the retained matrices.  Over the
different prime `1000033` it checks two hundred points of each composite:

```text
E -> y -> E,  y -> E -> y.
```

A second independent implementation in Rust removes sampling from the first
of those composites.  It clears the Cramer and Cox denominators structurally,
constructs the five tangent coordinates as sparse four-variable polynomials,
homogenizes the retained quintics, and checks every coefficient of
`N_j(rho)-E_j D(rho)`.  Over `1000033` all four residual polynomials vanish;
the cleared common denominator is nonzero and has `124666` terms.  The release
replay takes about sixteen seconds on the development host.

Primary replay:

```bash
uv run --with sympy==1.14.0 python3 \
  notes/2026-08-25-c958-type-i1-tangent-inverse-search.py \
  --check notes/2026-08-25-c958-type-i1-tangent-inverse.json
```

Independent replay:

```bash
python3 notes/2026-08-25-c958-type-i1-tangent-inverse-check.py \
  notes/2026-08-25-c958-type-i1-tangent-inverse.json
sha256sum -c notes/2026-08-25-c958-type-i1-tangent-inverse.sha256
```

Exact finite-field polynomial replay:

```bash
cargo run --release --manifest-path rust/Cargo.toml \
  --example c958_tangent_polynomial_check -- \
  notes/2026-08-25-c958-type-i1-tangent-inverse.json
```

## Trust boundary

No characteristic-zero rational-function identity is claimed yet.  Two exact
symbolic approaches were tried with explicit cutoffs: general expression
expansion remained CPU-bound after twenty minutes, while two FLINT sparse
denominator-clearing layouts reached `4.8 GB` and `3.4 GB` before completion
and were stopped.  Their unfinished scripts and outputs are not retained.

Accordingly, this bundle certifies the exact coefficient construction,
minimal-degree modular obstruction, rational holdouts, and independent
two-sided finite-field checks.  It also certifies the full forward-then-inverse
polynomial identity over the independent prime `1000033`, rather than merely
at sampled points.  It does **not** certify a symbolic characteristic-zero
composite, uniform formulas over `Q(a,b)`, a ground-field map `Z/T3 <-> P4`,
the cubic-product maps, or type `I3`.

## EJ + TT closeout

The unexpected structural gain is the common denominator.  Four unrelated
rational interpolants would use 242 denominator terms; the actual inverse
uses one 55-term quintic.  The numerator term counts also mirror the four
exceptional directions rather than becoming dense in all 126 monomials.
This is evidence that the quintics arise from a single projective inverse map,
not four accidental affine fits.

The highest-EV exact verification is now ideal reduction rather than expanded
substitution.  Introduce the three linear slice equations and the four graph
equations `rho_i-y_i rho_0`; reduce `D E_j-N_j` in the localized coordinate
ring, using the Cramer determinant and `rho_0 D` as explicit denominators.
That keeps the equations sparse and should certify both composites without
forming the giant cleared numerator.  Once it passes at the generic
`Q(a,b)` level, specialize `(a,b)=(A(z)^2,B(z)^2)` and conjugate through the
ground orbit-trace basis.

## Mystery ledger

| feature | status | evidence gap or owner |
|---|---|---|
| Why is the inverse degree exactly five? | established at one modular specialization, unexplained geometrically | a divisor-class or inverse-linear-system calculation should predict the quintic degree uniformly |
| Why do all four coordinates share a 55-term denominator? | exact in the rational lift | identify the denominator as the exceptional or Jacobian divisor of the tangent chart |
| Are the displayed rational formulas identities in characteristic zero? | open exact gate | the exact polynomial identity now holds modulo `1000033`, but localized ideal reduction over the integers or rationals is still required |
| Do the quintics persist over `Q(a,b)`? | open, next | reconstruct or derive the uniform coefficient functions, then prove both composites |
| Does this complete `Z/T3 <-> P4` or `X_1 x P2`? | no | ground descent, uniformity, and final function-field composition remain |

**Vibe:** substantial and honest progress: the inverse shape and exact
coefficients are exposed, but the characteristic-zero identity and generic
ground map remain gated.
