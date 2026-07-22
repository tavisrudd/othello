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

## Third-order edge model and Witt closure

The `11+55=66` support split has an exact internal mechanism.  Write the eleven frozen ternary
incidence rows as `r_0,...,r_10`.  For every unordered pair `{i,j}`, the codeword

```text
1 - r_i - r_j  in F_3^11
```

has weight five, with support

```text
complement(support(r_i) symmetric_difference support(r_j)).
```

These 55 supports are distinct and exhaust the residual minimum supports.  Thus the residual
family is canonically indexed by the edges of `K_11` relative to the frozen row ordering.  Exact
subset counting additionally proves:

- all 66 minimum supports form a Steiner `4-(11,5,1)` design (each of the 330 four-subsets occurs
  once);
- the eleven selected row supports form the C452 `2-(11,5,2)` design;
- the 55 residual supports form a `2-(11,5,10)` design; and
- every residual support meets the selected rows with intersection histogram
  `3*[size 1] + 2*[size 2] + 6*[size 3]`.

The certificate records the literal 55-entry edge-to-support bijection.  This is a combinatorial
identification, not yet a proof that the frozen `L_2(11)` action agrees with the classical Witt or
`M_11` action, nor an identification with C450's cross-sheet relation-support set.

The sharp gated theorem is now visible.  For `G=PSL_2(11)`, the counts and already-certified
stabilizer types read

```text
11 = |G:A5|,       55 = |G:A4|.
```

Thus the expected equivariant statement is that the 66 Witt blocks restrict as the disjoint union
`G/A5 + G/A4`: the selected rows are the first orbit, while the residual `K_11` edges are the
second and should identify with C450's 55-element disjoint relation-support set.  C464 proves the
underlying sets and formulas only.  The cheapest missing discriminator is one anchored support map
plus the relevant `A4` conjugacy/stabilizer check; this remains gated rather than being inferred
from matching cardinalities.

There is also a conceptual replacement for two exhaustive observations.  Once the 66 weight-five
supports are known, minimum distance allows any four-subset in at most one support, while
`66*C(5,4)=C(11,4)=330` forces every four-subset exactly once.  And once the eleven rows form the
`2-(11,5,2)` design, `1-r_i-r_j` directly forces the 55 residual blocks.  Enumeration remains in
the certificate as independent finite evidence, but is not the only explanation.

## Fourth-order projective support spectrum

Quotienting every nonzero ternary word by scalar multiplication gives an exact support census:

| weight | projective words | distinct supports | support family |
|---:|---:|---:|:--|
| 5 | 66 | 66 | the Witt blocks above |
| 6 | 66 | 66 | their complements |
| 8 | 165 | 165 | every 8-subset of the eleven coordinates |
| 9 | 55 | 55 | every 9-subset of the eleven coordinates |
| 11 | 12 | 1 | twelve projective words on full support |

Thus the apparent `165=C(11,3)` and `55=C(11,2)` coincidences are literal complete support
families, not numerology.  The twelve full-support projective words are a sharp symmetry mystery:
`12=|PSL_2(11):(11:5)|` is the degree of the natural projective-line action, but C464 does not
certify that orbit or its stabilizer.

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
C450 rank/nullity comparisons. It also records the dual-coset decompositions, all minimum-support
counts, and the 55-entry `K_11` edge model.
The projective support spectrum additionally records all support fibres at weights 5, 6, 8, 9,
and 11.

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

The load-bearing byte counts are: primary generator 20,710; independent replay 13,093; canonical
JSON 43,735; C452 input 22,113; C450 input 46,770; and C406 input 25,443.  The certificate records
the complete pinned input hashes, and the checksum manifest records complete hashes for the report,
both executables, and the JSON output.

## Mystery ledger

- **Settled by extra juice — the complementary rank drops.** The shared-edge spans are the exact
  duals and satisfy `C=C^perp direct-sum <1>`; their dimensions, enumerators, and all-one cosets now
  explain the full modular rank/nullity pattern rather than merely matching it.
- **Settled by third-order extra juice — the `11+55=66` minimum-support split.** The residual
  supports are exactly `support(1-r_i-r_j)` for the 55 row pairs, giving a canonical `K_11` edge
  bijection.  All 66 supports form the Steiner `4-(11,5,1)` design, while the selected and residual
  families are respectively `2-(11,5,2)` and `2-(11,5,10)`.
- **Open — equivariance and the other 55-set.** The edge formula does not yet prove that the frozen
  `L_2(11)` action is the classical Witt/`M_11` action or identify these 55 residual supports with
  C450's 55 cross-sheet relation-support elements.  The precise candidate is the orbit
  decomposition `G/A5 + G/A4`; it requires one anchored support map and the relevant stabilizer
  conjugacy check, precisely the pre-allocation-gated symmetry successor.
- **Partly settled — the 24 full-support words.** They are exactly twelve projective scalar pairs;
  each pair has one representative in each nonzero all-one coset.  The candidate explanation is the
  natural twelve-point orbit `G/(11:5) ~= P^1(F_11)`, but its action and stabilizer remain
  uncertified.  This belongs inside the same gated symmetry successor, not a separate task.
- **No other genuine C464 mystery remains.** Rank, distance, complete distributions, perfection,
  duality, binary equivalence, row coverage, dual-coset structure, Steiner closure, and the `K_11`
  edge formula, and the full projective support census all pass exact replay.
