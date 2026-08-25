# C958 generic quintic identity

**Lane:** `cubic-threefolds`

## Result

The reconstructed quintic inverse over `Q(a,b)` now satisfies the full
denominator-cleared forward--inverse identity.  This is an exact polynomial
identity over `Z`, not a finite-field or sampled claim.

The four residuals have parameter bidegree at most `(69,88)`.  The injective
Kronecker substitution

```text
a=t^89, b=t
```

therefore gives univariate degree at most `69*89+88=6229`.  For each of
fourteen distinct primes near `2^63`, the primary checker proves that all four
residual polynomials vanish at every `t=0,...,6229`.  Hence each encoded
residual is zero modulo every listed prime.

The exact forward coordinates have term counts

```text
32757, 30815, 32757, 36700, 37638.
```

Their exact `L1` norms give rigorous residual coefficient bounds by repeated
triangle and product inequalities.  The largest bound has 265 decimal digits.
The product of the fourteen deterministically primality-checked moduli has 266
digits and exceeds twice every residual bound by a factor of eight.  A
coefficient divisible by all fourteen primes must therefore be zero over `Z`.

Together with the retained nonzero common denominator, this proves the generic
split birational inverse represented by
`2026-08-25-c958-generic-polynomial.json`.

## Proof certificate

The certificate separates the proof into four checkable claims.

1. `generic-identity-check.py --integer --rho-only` constructs the five exact
   forward coordinates and records their term counts and `L1` norms.
2. `generic-identity-bound.py` derives the bidegree and coefficient bounds,
   proves primality with the deterministic 64-bit Miller--Rabin bases, and
   checks that the modulus product exceeds twice the coefficient bound.
3. `generic-identity-grid-check.py` performs exact `nmod_mpoly` arithmetic for
   all 6,230 Kronecker values at one prime.  The replay wrapper ran all fourteen
   primes: 87,220 parameter values and 348,880 target residual checks.
4. `generic-identity-certificate-check.py`, using only the Python standard
   library, independently recomputes the height bound, primality, modulus
   product, Kronecker injectivity, grid size, hashes, and transcript coverage.

The complete grid replay took 6,520.129 seconds with fourteen workers.  The
canonical transcript uses a repository-relative checker path; this normalizes
the run-specific absolute path in the original process output without changing
the checker hash or any arithmetic result.

## Replay

From the repository root:

```text
uv run --with python-flint python3 \
  notes/2026-08-25-c958-generic-identity-check.py \
  --integer --rho-only \
  --write-rho-summary notes/2026-08-25-c958-generic-rho-summary.json \
  notes/2026-08-25-c958-generic-forward.json \
  notes/2026-08-25-c958-generic-polynomial.json

python3 notes/2026-08-25-c958-generic-identity-bound.py \
  notes/2026-08-25-c958-generic-forward.json \
  notes/2026-08-25-c958-generic-polynomial.json \
  notes/2026-08-25-c958-generic-rho-summary.json \
  --write notes/2026-08-25-c958-generic-identity-bound.json

uv run --with python-flint python3 \
  notes/2026-08-25-c958-generic-identity-replay.py --workers 14 \
  --write notes/2026-08-25-c958-generic-identity-replay.json \
  notes/2026-08-25-c958-generic-forward.json \
  notes/2026-08-25-c958-generic-polynomial.json \
  notes/2026-08-25-c958-generic-identity-bound.json

python3 notes/2026-08-25-c958-generic-identity-certificate-check.py \
  notes/2026-08-25-c958-generic-forward.json \
  notes/2026-08-25-c958-generic-polynomial.json \
  notes/2026-08-25-c958-generic-rho-summary.json \
  notes/2026-08-25-c958-generic-identity-bound.json \
  notes/2026-08-25-c958-generic-identity-replay.json
```

Expected final output:

```text
certified_primes=14 grid_size=6230 coefficient_bound_digits=265
conclusion=exact_generic_identity_over_Z
```

Artifact sizes are 9,369 bytes for the general identity constructor, 521 for
the exact forward summary, 8,908 and 3,244 for the bound generator and output,
6,424 for the grid checker, 4,126 and 3,178 for the replay wrapper and
transcript, and 4,387 for the independent audit.

## Trust and composition boundary

The coefficientwise grid arithmetic uses python-flint's compiled FLINT
implementation.  The stdlib audit is independent of FLINT for the proof
bounds, primality, injectivity, and transcript accounting, but it does not
repeat the 348,880 polynomial residual computations in a second algebra
implementation.  Independently, the earlier stdlib checker evaluates all 482
reconstructed coefficient functions at an unused prime and 130 fresh parameter
points; that check validates the reconstructed input rather than the grid
execution.

This certificate proves the generic **split** tangent inverse.  It does not
turn the fixed split tangent witness into a ground-field tangent section, does
not certify `Z/T3 <-> P4` over the family function field, and does not supply
the final maps for `X_1 x P2` or `X_3 x P2`.  Those descent and composition
gates remain mandatory.

## Mystery ledger

| feature | status | evidence or remaining gate |
|---|---|---|
| Are the reconstructed 482 coefficient functions an exact inverse? | settled | exhaustive Kronecker grids plus coefficient-height lifting prove all four residuals over `Z` |
| Is the proof merely probabilistic? | no | the grid size exceeds the encoded degree and the modulus product exceeds twice the exact coefficient bound |
| Is there an independent full polynomial implementation? | no | stdlib independently audits the proof envelope and fresh-prime reconstruction, while FLINT performs the exhaustive residual arithmetic |
| Does this finish the ground type-I1 map? | no | the certified witness and coordinates are still split; ground tangent descent and final cubic composites remain |

**Vibe:** the generic formula has crossed from reconstructed candidate to exact
split theorem; the remaining frontier is arithmetic descent, not interpolation.
