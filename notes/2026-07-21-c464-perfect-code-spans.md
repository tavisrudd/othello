# C464 — perfect-code spans of the cross-sheet QR designs

**Lane:** `crowns`

**Date:** 2026-07-21

**Verdict:** `GREEN — THE DISJOINTNESS SPANS ARE THE PERFECT BINARY [7,4,3] HAMMING AND TERNARY [11,6,5] GOLAY PARAMETER CODES; BOTH COMPLEMENTARY SPANS AND ALL C450 RANK GATES PASS`

## Result

Starting from the C452 translation-labeled circulant cross-disjointness matrices, exact
prime-field row reduction and exhaustive enumeration of every coefficient tuple give:

| `q` | field | relation | rank | minimum distance | complete nonzero weight distribution |
|---:|:---:|:---|---:|---:|:---|
| 7 | `F_2` | disjoint | 4 | 3 | `7 z^3 + 7 z^4 + z^7` |
| 7 | `F_2` | shared edge | 3 | 4 | `7 z^4` |
| 11 | `F_3` | disjoint | 6 | 5 | `132 z^5 + 132 z^6 + 330 z^8 + 110 z^9 + 24 z^11` |
| 11 | `F_3` | shared edge | 5 | 6 | `132 z^6 + 110 z^9` |

Each distribution also has one word of weight zero and zero words at every unlisted weight.  The
certificate records every weight from 0 through the code length rather than only the nonzero
terms displayed above.  Enumeration covers all `2^4=16`, `2^3=8`, `3^6=729`, and `3^5=243`
codewords, respectively.

The two disjointness spans attain the exact sphere-packing equalities

```text
q=7:   2^4 (1 + 7)             = 16 * 8   = 128    = 2^7,
q=11:  3^6 (1 + 11*2 + 55*4)  = 729 * 243 = 177147 = 3^11.
```

Thus the computed cyclic incidence spans have the perfect binary `[7,4,3]` Hamming and perfect
ternary `[11,6,5]` Golay parameter profiles.  This is a finite computation, not an invocation of a
classification or uniqueness theorem.  For completeness, the shared-edge spans do not attain the
corresponding packing equalities: their left sides are `64` and `59049`.  Direct dot-product
checks plus the complementary dimensions show, at each prime, that the shared-edge span is exactly
the dual of the disjointness span.

The exact MacWilliams transform provides a second, coefficient-by-coefficient check of each dual
pair.  In both directions and at both primes, transforming the complete recorded distribution
reproduces every coefficient of its complementary distribution.

## Minimum-word coverage by the incidence rows

| `q` | relation | distinct nonzero scalar multiples of rows | all minimum words | fraction | exhausts? |
|---:|:---|---:|---:|:---:|:---:|
| 7 | disjoint | 7 | 7 | `1` | yes |
| 7 | shared edge | 7 | 7 | `1` | yes |
| 11 | disjoint | 22 | 132 | `1/6` | no |
| 11 | shared edge | 22 | 132 | `1/6` | no |

These counts are computed from literal row vectors and every nonzero field scalar, then compared
against the exhaustively enumerated minimum-weight words.  Thus at `q=7` the geometry supplies the
entire minimum-word system on each side.  At `q=11` it supplies a distinguished 22-word subset on
each side; no orbit or equivariance assertion about those subsets is made here.

Passing from scalar-paired words to supports sharpens the `q=11` row to an exact `11+55=66`
census: there are 66 minimum-word supports, the eleven frozen incidence rows supply eleven of
them, and 55 remain.  The equality `55=C(11,2)` and its match with C450's disjoint
relation-support size are exact numerical coincidences recorded as a mystery below, not a proved
equivariant identification.

## Extra-juice dual-coset structure

At both primes the dual code is not merely orthogonal to the perfect code: it is contained in it
with codimension one, and the all-one word splits the quotient:

```text
C_7  = C_7^perp direct-sum <1> over F_2,
C_11 = C_11^perp direct-sum <1> over F_3.
```

For `q=7` the nonzero coset has enumerator `7z^3+z^7`.  For `q=11`, each nonzero all-one coset has
enumerator `66z^5+165z^8+12z^11`.  Hence the two cosets account separately for the 132 minimum
words and split the 24 full-support words as `12+12`.  The primary generator and independent
replay verify the literal subcode inclusion, the all-one representative, every coset word, and
the union equality.

## Explicit binary Hamming equivalence

The row-reduced generator obtained from the `q=7` disjointness incidence matrix is

```text
G = [1 0 0 0 1 1 0]
    [0 1 0 0 0 1 1]
    [0 0 1 0 1 1 1]
    [0 0 0 1 1 0 1].
```

Exhaustion of all 7-coordinate permutations finds the lexicographically first equivalence
`pi=(0,1,3,2,6,4,5)` in new-to-old zero-based convention.  With

```text
U = [1 0 0 0]       H = [0 0 0 1 1 1 1]
    [0 1 0 0]           [0 1 1 0 0 1 1]
    [0 0 0 1]           [1 0 1 0 1 0 1]
    [0 0 1 0],
```

the generator in the certificate satisfies `U G^pi = G_std` over `F_2`, where `G_std` is the
computed kernel generator of `H` and the columns of `H` are the binary vectors 1 through 7.  The
certificate contains `G`, `G^pi`, `U`, `G_std`, `H`, and the verified product as literal matrices.
The independent replay checks the matrix equation, the parity-check equation, and the exhaustive
weight distribution of the resulting standard code.

## Mandatory C450 rank gate

| `q` | field | relation | computed rank/nullity | C450 rank/nullity | result |
|---:|:---:|:---|:---:|:---:|:---:|
| 7 | `F_2` | disjoint | `4 / 3` | `4 / 3` | agree |
| 7 | `F_2` | shared edge | `3 / 4` | `3 / 4` | agree |
| 11 | `F_3` | disjoint | `6 / 5` | `6 / 5` | agree |
| 11 | `F_3` | shared edge | `5 / 6` | `5 / 6` | agree |

Every C464 rank agrees with C450's frozen modular rank, equivalently its certified nullity.  The
generator raises a `BLOCKER` before writing output if any of these equalities fails.

## Scope

No equivariance, automorphism group, code uniqueness, classification, or nonexistence statement is
certified.  In particular, this bundle does not enter the pre-allocation-gated symmetry successor
and does not enlarge the van Lint--Tietäväinen wall retained by C452.  The names “Hamming” and
“ternary Golay” here denote the explicitly computed perfect linear parameter codes; only the
binary case additionally carries the requested concrete generator-matrix equivalence.

## Certificate and reproducibility

The canonical certificate is
[`2026-07-21-c464-perfect-code-spans.json`](2026-07-21-c464-perfect-code-spans.json).  It contains
both frozen circulant incidence matrices and their complements, row-reduced generator and
parity-check matrices, every exhaustive weight count including zeros, minimum distances, exact
sphere terms and equalities, incidence-row coverage of the minimum words, both exact MacWilliams
transforms, the explicit Hamming equivalence matrices, the computed dual-span checks, and the four
C450 rank/nullity comparisons.

Run from `/home/tavis/src/othello`:

```bash
python3 notes/2026-07-21-c464-perfect-code-spans.py --check
python3 notes/2026-07-21-c464-perfect-code-spans-replay.py
sha256sum -c notes/2026-07-21-c464-perfect-code-spans.sha256
```

Intentional regeneration is the primary command without `--check`.  It verifies the frozen input
hashes, reconstructs each circulant matrix from C452's recorded difference set, forms its literal
0/1 complement, performs exact row reduction over the required prime field, and exhausts all
codewords and all binary coordinate permutations required by the equivalence.

The independent replay imports neither the primary generator nor any of its helpers.  It rebuilds
the matrices from the C452 difference sets, computes ranks by incremental prime-field basis
insertion, constructs each span directly from all incidence rows, recounts every weight, rechecks
the sphere equations and C450 ranks, verifies the dual-span statement and MacWilliams transforms,
recounts the minimum-word row coverage, and checks the recorded Hamming matrix equations.

The trusted boundary is exact integer and prime-field arithmetic plus the hash-pinned C406, C450,
and C452 certificates.  The output is deterministic and timestamp-free.

The load-bearing byte counts are: primary generator 15,378; independent replay 9,238; canonical
JSON 28,930; C452 input 22,113; C450 input 46,770; and C406 input 25,443.  The certificate records
the complete pinned input hashes, and the checksum manifest records complete hashes for the report,
both executables, and the JSON output.

## Mystery ledger

- **Settled by extra juice — the complementary rank drops.** The shared-edge spans are the exact
  duals and satisfy `C=C^perp direct-sum <1>`; their dimensions, enumerators, and all-one cosets now
  explain the full modular rank/nullity pattern rather than merely matching it.
- **Open — the `11+55=66` minimum-support split.** Exact enumeration shows 66 ternary weight-five
  supports, of which the frozen geometry selects eleven and leaves 55.  The residual 55 equals
  both `C(11,2)` and C450's disjoint relation-support count.  What is missing is an explicit
  support bijection and proof of compatibility with the frozen `L_2(11)` action; no `M_11`, Witt
  design, or equivariance claim is made.  This belongs to the task card's pre-allocation-gated
  symmetry successor, not C464.
- **Open — the 24 full-support words.** The dual-coset split explains them as 12 words in each
  nonzero all-one coset, but does not explain the 12 scalar pairs geometrically.  The same gated
  symmetry computation is the exact evidence gap.
- **No other genuine C464 mystery remains.** Rank, distance, complete distributions, perfection,
  duality, binary equivalence, row coverage, and dual-coset structure all pass exact replay.
