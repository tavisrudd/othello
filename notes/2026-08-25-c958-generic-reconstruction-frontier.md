# C958 generic quintic reconstruction frontier

## Result

The specialized type-`I1` quintic inverse is now independently closed at a
second cold point.  At `(a,b)=(3,5)` with tangent `z=(1,3,7)`, the complete
modular search again excludes degrees one through four, finds one quintic
relation for each exceptional coordinate, and gives the same numerator plus
denominator support sizes `130,124,110,118`.  Using all 165 retained rational
samples fixes an undersampling defect in the earlier exact lift.  The
arbitrary-precision Rust checker then proves all four denominator-cleared
residuals coefficientwise over `Z`; its cleared denominator has `113030`
terms.  Thus the quintic shape is not peculiar to `(2,3)`.

The generator is reusable across cold specializations and primes.  Its
`--modular-only` mode now goes directly to degree five with 272 training
points and twenty holdouts, while the default certificate retains the full
degree-one-through-five search and one hundred holdouts.  Every modular sample
also checks that the rational and finite-field forward maps agree.

## Generic reconstruction evidence

The 482 nonzero projective coefficient functions have stable supports.  On
independent 32-point lines, every coefficient validates as a rational function
with numerator and denominator degrees at most six in `a`, and at most six
and seven respectively in `b`.  Cartesian-grid experiments exposed real
specialization cancellations, so the retained reconstruction uses random
parameter points and an individual rectangular degree box for each
coefficient rather than asserting a false small global denominator.

For each of seven primes

```text
1000003, 1000033, 1000037, 1000039, 1000081, 1000099, 1000117,
```

the modular sampler and rational-function reconstructor recover all 482
coefficient functions with unique nullspaces and validate them on every
retained parameter sample.  The first four passes use 300 points; the final
three use 130 points, still exceeding the largest 105-unknown reconstruction
system.  Across the dense coefficient boxes there are `39492` scalar slots.
Chinese remaindering and safe rational reconstruction resolve `39456`; only
`36` remain above the seven-prime uniqueness bound of roughly `7e20`.

This is a sharply bounded generic candidate, not yet a characteristic-zero
formula.  The large scratch grids and modular formula files are intentionally
not promoted as certificates: the retained scripts reproduce them, while the
36 unresolved coefficients prevent an honest final JSON.  One or two further
primes should resolve the remaining heights; the resulting rational
coefficients must then pass fresh-prime holdouts and a symbolic or
denominator-cleared generic identity check before entering the paper.

## Paper and composition boundary

The paper can already be upgraded from “inverse tangent elimination remains”
to: explicit quintic inverse formulas are proved at two independent smooth
specializations, their support and parameter-degree profile are stable, and a
replayable generic reconstruction is complete except for 36 high-height
scalar coefficients.  It cannot yet claim a uniform map over `Q(a,b)`.

Consequently the ground substitution `(a,b)=(A(z)^2,B(z)^2)`, final cubic
function-field composites, and type `I3` remain open.  The next highest-value
action is exact and narrow: add enough CRT primes to resolve the final 36,
validate the resulting rational certificate at a fresh prime, then extend the
Rust sparse checker from four `E` variables to `(a,b,E1,E2,E4,E5)`.

## EJ + TT closeout

The surprising feature is not merely that degree five persists, but that all
482 coefficient functions fit small one-variable degree boxes while their
heights reach beyond `1e20`.  Expanded symbolic elimination was therefore the
wrong representation; modular sampling, per-coefficient rational functions,
CRT, and sparse polynomial checking form the reusable path.  The only mystery
left in this subgate is geometric: explain the quintic degree and stable
support as the inverse linear system rather than as interpolation output.

**Vibe:** the generic inverse is 36 scalars short of a candidate and one exact
identity short of a theorem; the boundary is now numerical and reproducible,
not conceptual fog.
