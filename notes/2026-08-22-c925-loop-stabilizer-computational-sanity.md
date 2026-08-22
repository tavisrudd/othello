# C925 loop-stabilizer computational sanity check

## Claim checked

Let a chosen source point have exact period \(n=m+1\) under one loop.  A
target point with exact period \(\ell\) has the same stabilizer in the loop
group exactly when \(\ell=n\).  If the periods differ, one of \(n,\ell\) is a
loop power whose fixedness distinguishes the two points.  For the Kummer
translation

\[
  i\longmapsto i+a\quad\text{on }\mathbf Z/n,
\]

the exact period is \(n/\gcd(n,a)\).

The Haskell check validates this finite arithmetic independently of any QDM
interpretation.  It is the executable input shape consumed by
`Comparison.TwoLayerDescentPacket.sourceSum_not_equivariantlyEquivalent_of_distinctPowerFixednessPeriods`.
Lean also proves the gcd reduction
`modulus_dvd_power_mul_iff_reducedPeriod_dvd_power`.

## Exact domain

The deterministic part checks:

- every translation charge modulo \(n\), for \(2\le n\le65\), by comparing
  the gcd formula with direct iteration (2,144 cases);
- every ordered pair of periods in \(\{1,\ldots,65\}\) (4,225 cases);
- inverse-translation invariance over the same translation domain;
- the red Kummer model \(x^n=t\), the green split model \(x^n=1\), and four
  omission/mutation tests that reject cardinality-only, return-only, and
  mixed-ledger substitutes for exact periods;
- the named stabilization indices \(m=1,2,3,4,13\).

Three fixed-seed QuickCheck properties add 27,000 generated cases.  The seed
is 925 and each generated positive integer is reduced to the interval 1,…,128.

The named Kummer tables are:

| \(m\) | \(n=m+1\) | charges with period \(n\) |
|---:|---:|---|
| 1 | 2 | 1 |
| 2 | 3 | 1, 2 |
| 3 | 4 | 1, 3 |
| 4 | 5 | 1, 2, 3, 4 |
| 13 | 14 | 1, 3, 5, 9, 11, 13 |

Thus the abstract packet \(x^{m+1}=t\) is a red correction for every checked
\(m\).  The computation does not exclude it geometrically.

## Replay

Working directory: repository root.

```sh
nix shell --impure --expr \
  'with import <nixpkgs> {}; haskellPackages.ghcWithPackages (p: [p.QuickCheck])' \
  --command sh -c \
  'runghc -Wall notes/cubic-threefolds-tasks/c925-loop-stabilizer-sanity.hs \
   | diff -u \
       notes/cubic-threefolds-tasks/c925-loop-stabilizer-sanity-output.txt -'
```

The replay used GHC 9.10.3 and QuickCheck 2.15.0.1.

## Hashes and byte counts

| artifact | bytes | SHA-256 |
|---|---:|---|
| `c925-loop-stabilizer-sanity.hs` | 5,528 | `52f0e75df18403dcf972ca21d4b939d8f7bd2b648d50e1f58df8f140781307d0` |
| `c925-loop-stabilizer-sanity-output.txt` | 1,158 | `33d07efd66d9b952d9626c380dbf9fd1f785bc007f84137ac48d52430c855a28` |

## Independent check and trust boundary

The translation periods are computed twice: by the closed gcd formula and by
direct iteration of the permutation.  Lean independently proves that unequal
natural-number periods have different divisibility fingerprints and that this
prevents an equivariant stable-ledger equivalence.  The Lean declarations are

- `exists_power_fixedness_divisibility_difference`;
- `modulus_dvd_power_mul_iff_reducedPeriod_dvd_power`;
- `sourceSum_not_equivariantlyEquivalent_of_distinctPowerFixednessPeriods`.

The Haskell execution and GHC/QuickCheck implementation remain trusted.  The
calculation does not prove that an actual QDM marked packet is finite étale,
that a displayed local exponent labels one of its primitive branches, that the
listed branches are exhaustive, or that every weak-factorization comparison
uses the same loop.  Those are the geometric source hypotheses still required
for the unconditional \(m=2\) or all-\(m\) theorem.
