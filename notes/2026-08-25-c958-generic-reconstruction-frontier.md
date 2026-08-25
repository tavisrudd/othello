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

For each of eight primes

```text
1000003, 1000033, 1000037, 1000039, 1000081, 1000099, 1000117, 1000121,
```

the modular sampler and rational-function reconstructor recover all 482
coefficient functions with unique nullspaces and validate them on every
retained parameter sample.  The first four passes use 300 points; the final
four use 130 points, still exceeding the largest 105-unknown reconstruction
system.  Across the dense coefficient boxes there are `39492` scalar slots.
Chinese remaindering and safe rational reconstruction now resolve all
`39492`; the largest numerator is `9851473895740557824159` and the largest
denominator is `22621076349294196199160`.

The retained rational certificate passes an independent stdlib holdout at
the unused prime `1000133`: 130 new parameter points and all `62660`
coefficient evaluations agree.  The 482 rational functions have only seven
distinct denominators.  Their exact least common multiple has bidegree
`(6,7)`, and clearing it gives a single polynomial projective inverse whose
integer coefficients have at most 26 digits.

This is a complete and independently checked generic candidate, but not yet
a characteristic-zero identity.  The large scratch grids and modular formula
files remain reproducible inputs rather than promoted certificates.  A
denominator-cleared generic identity check is still mandatory before the map
enters the paper.

## Paper and composition boundary

The paper can already be upgraded from “inverse tangent elimination remains”
to: explicit quintic inverse formulas are proved at two independent smooth
specializations, and the uniform candidate over `Q(a,b)` is fully reconstructed,
compressed to one common denominator, and validated on a fresh prime.  It
cannot yet claim that uniform map until the generic identity proof passes.

Consequently the ground substitution `(a,b)=(A(z)^2,B(z)^2)`, final cubic
function-field composites, and type `I3` remain open.  The next highest-value
action is the exact generic denominator-cleared identity, using the retained
degree and coefficient-height bounds rather than an unbounded expansion.

## EJ + TT closeout

The surprising feature is not merely that degree five persists, but that all
482 coefficient functions fit small one-variable degree boxes while their
heights reach beyond `1e20`, then collapse to seven denominators and one
bidegree-`(6,7)` common multiple.  Expanded symbolic elimination was therefore
the wrong representation; modular sampling, per-coefficient rational
functions, CRT, denominator consolidation, and bounded sparse identity
checking form the reusable path.  The geometric explanation of the quintic
degree and stable support remains open.

**Vibe:** the generic inverse is now a complete, compact candidate and one
exact identity short of a theorem; the boundary is verification, not missing
formula data.
