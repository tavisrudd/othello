# C815 arithmetic and rigidity continuation

## Result

This continuation closes four algebraic or finite-linear-algebra pieces of the
remaining Paper III surface without claiming the geometric identifications they
are designed to receive.

1. `RelativeConicArcs.ClebschSteinChart` instantiates the trace-split quadratic
   algebra at the normalized chart and proves
   `5 J0 = (4 sqrtFive sigmaThree)^2`.
2. `RelativeConicArcs.GoldenResidueAlgebra` constructs the rational golden
   residue field, its square root of five, and the involutive deck automorphism.
3. `RelativeConicArcs.SpinorSquareClass` supplies the definition-level square
   class and reflection-product API, including the exchanger class of two.
4. `RelativeConicArcs.ClebschWeightedJacobian` kernel-checks the displayed
   eight-by-five reduced Jacobian and proves that its kernel is exactly the
   scaling line.  Its final theorem isolates the fixed-vector-detection input
   needed for the full twenty-by-fifteen promotion.

The corresponding commits are `137e7a3b6`, `a82a1ee5a`, `1352a57be`, and
`0a843d6cc`.  The reusable trace-split foundation on which the first item rests
is commit `281d08b9a`.

## Validation

Every source was checked with the prescribed guarded elaborator and serialized
build queue.  The successful build-queue runs were:

- `20260826-073910-a4e41d74` for `ClebschSteinChart`;
- `20260826-095735-c1cd6cb2` for `GoldenResidueAlgebra`;
- `20260826-103347-4a4f3376` for `SpinorSquareClass`;
- `20260826-070648-225dbcf5` for `ClebschWeightedJacobian`.

No source contains `sorry`, `admit`, `native_decide`, or a raised heartbeat
limit.

## Exact remaining boundary

- HARM-1 still needs the theorem identifying `normalizedMean` with normalized
  surface integration.  The planned proof factors Lebesgue measure into radial
  and unit-sphere parts and derives the monomial moments from one-dimensional
  Gaussian moments.
- ARITH-1 still needs the geometric identification of the normalized incidence
  algebra with the chart model.  The `5 J0` algebra and split comparison are no
  longer part of that gap.
- ARITH-2 still needs the geometric complete-fibre identification.  The golden
  residue algebra and spinor square-class calculation are no longer part of
  that gap.
- ORIENT-1 still needs the marked geometric comparison for the normalized
  two-component pullback.
- The weighted Jacobian still needs the concrete alternating-group
  fixed-detection instantiation promoting the reduced kernel to the full
  Jacobian.
- Only after those sources are attached and the aggregate Paper III gates are
  frozen may C815 emit `sparse_shadow_export.json`; C968's Paper III adapter
  remains downstream of that authority boundary.

## `ej` + `tt` closeout

The cheap extra value is a cleaner separation between normalized models and
geometric existence.  The new algebra modules force all scalar, deck-sign, and
square-class consequences once a geometric comparison is supplied, so the
remaining interfaces should carry that comparison as an explicit field rather
than silently identifying two constructions by notation.  This makes the final
gate audit able to distinguish a proved transport consequence from the still
missing existence theorem.

The canonical square root in `GoldenResidueAlgebra` also gives the eventual
Paper III export a choice-free arithmetic representative: after the geometric
fibre comparison is proved, the adapter need not accept an arbitrary root or a
floating normalization.  That is a downstream benefit, not permission to emit
the export before the comparison and aggregate gates close.

## Mystery ledger

- **Why the chart coefficient is eighty:** settled; it is the forced product
  `4^2 * 5`, and the chart module proves the exact square identity.
- **Whether the golden residue involution really supplies the deck sign:**
  settled algebraically; it sends the golden root to its conjugate and negates
  the canonical square root of five.  Identifying this automorphism with the
  geometric deck transformation remains the ARITH-2 comparison gap.
- **Whether the spinor witness was only an ad hoc computation:** settled; it is
  now a theorem in a general quotient-by-squares API.
- **Whether the reduced Jacobian has an unnoticed extra kernel direction:**
  settled; its kernel is exactly the scaling line.  The genuine remaining gap
  is representation-theoretic promotion, not matrix rank.
