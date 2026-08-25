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

This is now an exact generic split inverse.  The denominator-cleared identity
certificate proves all four residuals over `Z` by an injective Kronecker grid
at fourteen primes and a coefficient-height lift; see
`2026-08-25-c958-generic-identity.md`.  The large scratch grids and modular formula
files remain reproducible inputs rather than promoted certificates.  The two
load-bearing degree certificates are retained as
`2026-08-25-c958-generic-degree-a.json` and
`2026-08-25-c958-generic-degree-b.json`; both regenerate byte for byte.

## Reproducibility boundary

From the repository root, the degree boxes replay as follows:

```text
uv run --with python-flint --with sympy==1.14.0 python3 \
  notes/2026-08-25-c958-generic-degree-probe.py \
  /tmp/c958-line-{2..33}-17.json --training 16 --axis a --exclude-a 17 \
  --write /tmp/c958-degree-a-replay.json
cmp /tmp/c958-degree-a-replay.json \
  notes/2026-08-25-c958-generic-degree-a.json

uv run --with python-flint --with sympy==1.14.0 python3 \
  notes/2026-08-25-c958-generic-degree-probe.py \
  /tmp/c958-line-37-{2..33}.json --training 16 --axis b --exclude-a 7 \
  --write /tmp/c958-degree-b-replay.json
cmp /tmp/c958-degree-b-replay.json \
  notes/2026-08-25-c958-generic-degree-b.json
```

The excluded values are the two visibly degenerate line specializations; the
remaining 31 points give sixteen training values and fifteen holdouts.  Each
degree certificate is 53,337 bytes.  The retained rational certificate is
3,490,587 bytes, the consolidated polynomial certificate 1,889,955 bytes,
and the forward data 32,876 bytes.  Their generators/checkers are respectively
5,361 bytes (`generic-rational-reconstruct.py`), 2,372 bytes
(`generic-rational-check.py`), 3,893 bytes (`generic-consolidate.py`), and
4,575 bytes (`generic-forward.py`).

The fresh-prime checker is independent stdlib arithmetic: it does not import
the SymPy/python-flint reconstruction implementation.  It validates the
candidate, not the pending characteristic-zero identity.  The modular grids
are intentionally regenerable scratch data; the degree boxes, reconstructed
formula, consolidated formula, and forward data are the compact load-bearing
outputs retained in the repository.

## Paper and composition boundary

The paper can be upgraded from “inverse tangent elimination remains” to an
exact uniform split statement: the quintic inverse over `Q(a,b)` is fully
reconstructed, compressed to one common denominator, and proved by the
denominator-cleared characteristic-zero identity certificate.  The expanded
formula belongs in the ancillary JSON artifact, not the main proof.

This still does not certify the ground substitution
`(a,b)=(A(z)^2,B(z)^2)`, a ground tangent witness, either final cubic
function-field composite, or type `I3` descent.  The next highest-value action
is to transport the exact split inverse through the strict Cox descent and
verify the resulting localized ground composites.

## EJ + TT closeout

The surprising feature is not merely that degree five persists, but that all
482 coefficient functions fit small one-variable degree boxes while their
heights reach beyond `1e20`, then collapse to seven denominators and one
bidegree-`(6,7)` common multiple.  Expanded symbolic elimination was therefore
the wrong representation; modular sampling, per-coefficient rational
functions, CRT, denominator consolidation, and bounded sparse identity
checking form the reusable path.  The geometric explanation of the quintic
degree and stable support remains open.

**Vibe:** the generic split inverse is now a compact exact theorem; the
remaining boundary is ground-field descent and composition, not missing
formula data.
