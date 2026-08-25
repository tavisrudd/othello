# C965 -- automated Galois descent

**Lane:** cubic-threefolds

**Status:** queued after C963; C958 and C963 are frozen predecessors

## Goal

Extract the constructive descent mechanism proved in the level-two cubic work
into a reusable, proof-producing algorithm:

```text
finite Galois action on Cox/Picard data
  -> integral stable-permutation resolution
  -> monomial obstruction or rational Hilbert--90 coboundary
  -> norm-torus chart
  -> certified ground-field rational maps.
```

The target is a mathematically delimited descent engine for supplied geometric
and lattice data, not a general rationality or Galois-cohomology oracle.

## Predecessor gate

- C958 has accepted type-`I_1` and type-`I_3` maps over `Q`, with exact descent
  certificates and named Cox, Picard, norm-torus, and tangent interfaces.
- C963 has frozen the straight-line-program and localized inverse-certificate
  formats and demonstrated exact round trips on both cubic families.

## Deliverables

1. Define exact input data for a finite Galois group acting on Cox coordinates,
   divisor classes, relations, and the relevant torus character lattice.
   Validate group laws, equivariance, saturation, and field-of-definition data.
2. Given an integral permutation or stable-permutation resolution, verify its
   unimodularity and exactness and derive the induced cocycle coordinates. A
   bounded resolution search may be included, but failure to find one is not a
   mathematical nonexistence certificate.
3. Decide the monomial-coboundary equations over the integral character lattice.
   Emit an exact coboundary when one exists, or a parity/index/denominator
   obstruction certificate when it does not.
4. For a supplied stable-permutation resolution, construct the rational
   coboundary by orbitwise Hilbert--90 sums, record its nonvanishing open, and
   certify every cocycle identity independently.
5. Recognize the residual torus type represented by the input lattice and
   consume a certified rational chart when available. The first supported case
   is the cubic norm-one torus from C958; broader chart synthesis requires its
   own theorem rather than a lookup-table claim of generality.
6. Compose the coboundary, torus chart, and quotient maps into ground-field
   straight-line programs using C963's certificate format. Verify both
   composites on explicit localized rings.
7. Produce diagnostic outcomes that distinguish monomial descent, rational
   stable-permutation descent, missing resolution/chart data, and a proved
   obstruction to the selected ansatz.
8. State operation and bit-complexity bounds conditional on explicit input
   encodings, finite-group enumeration, and supplied resolution/chart sizes.
   Do not convert bounded search exhaustion into a general decidability claim.

## Acceptance gate

- The engine reproduces both accepted C958 descents from frozen inputs without
  handwritten family-specific algebra in its generic core.
- Every successful result includes independently checkable group, lattice,
  cocycle, localization, and inverse-map certificates.
- The type-`I_1` monomial parity obstruction and subsequent rational
  coboundary are both recovered, demonstrating that the diagnostics distinguish
  failure of an ansatz from failure of descent.
- Corrupted actions, non-unimodular resolutions, zero Hilbert--90 sums, bad
  localization data, and false inverse claims are rejected.
- Claims of support beyond the two cubic families name the exact additional
  theorem and test fixture; finite-field or cryptographic applicability is out
  of scope without a separate good-reduction result.

## First action after C963

Freeze the smallest common input shared by the type-`I_1` and type-`I_3`
certificates, then prove on paper that each proposed diagnostic is invariant
under change of Cox marking and common character translation before writing a
generic implementation.
