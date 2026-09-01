# C1028 — Chain-ring instrument test: Ergodis against `PHG(2, Z4)` and `Z4`-linear codes

**Lane**: `gem-mining` — see CLAUDE.md § Lane routing.
**Date**: 2026-08-31
**Task**: C1028, first target of the instrument-test slate
(`notes/2026-08-31-ergodis-instrument-test-targets.md` §2 target 1).
**Status**: COMPLETE. Verification gate passed with a correction to the slate; calibration
reproduced every published cell; five core gaps specified against concrete inputs; independent
replay agrees.

**The instrument is the deliverable.** This task points Ergodis at arcs and linear codes over the
two finite chain rings of order 4 — the integers modulo 4, written `Z4`, and the truncated
polynomial ring `S2 = F2[u]/(u^2)` — precisely because that world sits outside the core's
assumptions. The Ergodis core is read-only throughout; the work is a self-contained private driver
that calls the core's kernels as they stand, records exactly where they break, and computes a
checkable ring-side result of its own.

---

## 1. Verification gate on ground truth — done first, and it corrected the slate

The slate flagged every table claim as recall-level and mandated a verification gate before
calibration. The gate was run before any computation. Result: **the slate's expectation of open
cells in the order-4 arc table is wrong — that table is complete** — and the calibration target
had to be re-chosen accordingly.

### 1.1 What is actually published

Source, read at full text (not abstract-only):

- **Honold, Kiermaier, Landjev, "New Results on Arcs in Projective Hjelmslev Planes over Small
  Chain Rings", arXiv:2409.02099v1**, 53 pages.
  Local blob `~/.cache/ergodis/c1028/lit/2409.02099.pdf`,
  `sha256 = e000b315c711d754a7940f090ceab9e48d03e3457f172388450dda182ff6cdbd`,
  fetched 2026-08-31 from `https://arxiv.org/pdf/2409.02099v1`.
- **Kiermaier, Kohnert, "New arcs in projective Hjelmslev planes over Galois rings"**,
  `https://www.mathe2.uni-bayreuth.de/axel/phg07.pdf`, read at full text.

Definitions as published (arXiv:2409.02099, §2): for a finite chain ring `R` of length 2 with
residue field of order `q`, a **projective `(k,n)`-arc** in the projective Hjelmslev plane
`PHG(2,R)` is a *set* `K` of `k` points with `|K ∩ L| <= n` for every line `L`. The quantity
`m_n(R)` is the largest `k` for which a projective `(k,n)`-arc exists, for
`n` in `{0, 1, ..., q^2 + q}`.

**Table 3 of arXiv:2409.02099, "The numbers `m_n(R)` for chain rings of order 4"** — every entry
carries the exactness marker, i.e. the whole column is a settled value, not a bound:

| `n` | `m_n(Z4)` | `m_n(S2)` |
|-----|-----------|-----------|
| 0   | 0         | 0         |
| 1   | 1         | 1         |
| 2   | 7         | 6         |
| 3   | 10        | 10        |
| 4   | 16        | 16        |
| 5   | 22        | 22        |
| 6   | 28        | 28        |

Two independent statements inside the same source corroborate the two most informative cells, so
the table read does not rest on the extracted table layout alone:

- `m_2(Z4) = 7`: "an illustrative example is provided by the hyperovals in `PHG(2, Z4)` which
  correspond to the optimal non-linear binary `(14, 2^6, 6)`-codes" (arXiv:2409.02099, §1). A
  maximal 2-arc of size 7 gives a `Z4`-linear code of length 7, whose Gray image has length 14 and
  `4^3 = 2^6` words. Kiermaier–Kohnert state the same fact in their abstract: "the expurgated
  Nordstrom-Robinson code, a nonlinear binary `[14, 6, 6]`-code which has higher minimum distance
  than any linear binary `[14, 6]`-code, can be constructed from a maximal 2-arc in the projective
  Hjelmslev plane over `Z4`".
- `m_3(Z4) = m_3(S2) = 10`: "Remark 8. In the cases `q = 2, 3` the exact value of `m_3(R)` is
  known: For `q = 2` the values are `m_3(Z4) = m_3(S2) = 10`" (arXiv:2409.02099).

### 1.2 The finding that changes the plan

The slate's §2 target 1 said to "pick, at the verification gate, the smallest open cell in the
`PHG(2, Z4)` arc table". **There is no open cell in that table.** For chain rings of order 4 every
value of `m_n` is settled and published. The open cells in the maintained tables live at
`|R| = 16` (Table 5) and `|R| = 25` (Table 6). Reported as a gate finding rather than worked
around: the calibration point chosen instead is the *whole* order-4 column, reproduced
exhaustively from scratch for both rings, which is a stronger instrument test than one cell
because the two rings have the same cardinality, the same plane order, the same point and line
counts, and differ in exactly one table entry (`m_2`: 7 versus 6). A pipeline that cannot tell
`Z4` from `F2[u]/(u^2)` cannot produce that column, and a pipeline built on field arithmetic
cannot tell them apart at all.

---

## 2. What was computed

All of it in one private driver, `ergodis-private/src/bin/c1028_chain_ring.rs`, with local chain-ring
arithmetic. Whole run: 0.34 seconds.

### 2.1 The planes, built and measured rather than assumed

For each ring the driver enumerates the free rank-one submodules of `R^3` (the points) and the free
rank-two submodules (the lines), and measures the incidence structure instead of asserting it:

| Measured quantity                                    | `Z4`        | `S2`        |
|------------------------------------------------------|-------------|-------------|
| points                                               | 28          | 28          |
| lines                                                | 28          | 28          |
| points per line (distinct sizes)                     | 6           | 6           |
| lines per point (distinct degrees)                   | 6           | 6           |
| point pairs joined by exactly one line               | 336         | 336         |
| point pairs joined by exactly two lines              | 42          | 42          |
| neighbour classes / class sizes                      | 7 / 4       | 7 / 4       |
| `|GL(3,R)|`, brute force over all `4^9` matrices     | 86016       | 86016       |
| `|GL(3,R)|` from the generator closure               | 86016       | 86016       |

The 42 point pairs joined by *two* lines are the whole Hjelmslev degeneracy in one number: in a
projective plane that count is zero. The driver checks that "joined by more than one line" is
exactly the same relation as "equal after reduction modulo the radical", so the neighbour classes
are confirmed to be the fibres of the residue map onto `PG(2,2)`, not merely assumed to be. The two
independent computations of `|GL(3,R)| = 86016` (a determinant-is-a-unit filter over all `4^9`
matrices, and the breadth-first closure of six elementary transvections plus one unit dilation)
agree, which certifies the generating set actually used for the symmetry reduction.

### 2.2 The arc census — the whole published order-four column, reproduced from scratch

Exhaustive search over the 28 points, in two passes: determine `m_n(R)`, then enumerate every
maximum arc. Each maximum-arc set is then classified up to `GL(3,R)` using the Ergodis core's own
orbit compiler (see §4), and each orbit partition is independently replayed by the core's verifier.

`Z4`:

| `n` | `m_n(Z4)` | published | maximum arcs | orbits | orbit sizes                                | certificate |
|-----|-----------|-----------|--------------|--------|--------------------------------------------|-------------|
| 0   | 0         | 0         | 1            | 1      | 1                                          | verified    |
| 1   | 1         | 1         | 28           | 1      | 28                                         | verified    |
| 2   | **7**     | **7**     | 256          | 1      | 256                                        | verified    |
| 3   | 10        | 10        | 34272        | 8      | 1344, 3584, 7168, 7168, 10752, 3584, 448, 224 | verified |
| 4   | 16        | 16        | 2135         | 3      | 1792, 336, 7                               | verified    |
| 5   | 22        | 22        | 28           | 1      | 28                                         | verified    |
| 6   | 28        | 28        | 1            | 1      | 1                                          | verified    |

`S2 = F2[u]/(u^2)`:

| `n` | `m_n(S2)` | published | maximum arcs | orbits | orbit sizes                                | certificate |
|-----|-----------|-----------|--------------|--------|--------------------------------------------|-------------|
| 0   | 0         | 0         | 1            | 1      | 1                                          | verified    |
| 1   | 1         | 1         | 28           | 1      | 28                                         | verified    |
| 2   | **6**     | **6**     | 2016         | 2      | 1792, 224                                  | verified    |
| 3   | 10        | 10        | 34272        | 8      | 1344, 3584, 7168, 7168, 10752, 3584, 448, 224 | verified |
| 4   | 16        | 16        | 2135         | 3      | 1792, 336, 7                               | verified    |
| 5   | 22        | 22        | 28           | 1      | 28                                         | verified    |
| 6   | 28        | 28        | 1            | 1      | 1                                          | verified    |

Every one of the fourteen published cells is reproduced. The classification data (arc counts and
orbit decompositions) goes beyond the published values, which give only `m_n`.

Each orbit also carries its representative's **line spectrum** `(a_0, ..., a_6)`, where `a_i` counts
the lines meeting the arc in `i` points; the spectrum is a `GL(3,R)`-invariant, so the two rings'
orbit lists can be compared as labelled objects and not merely by size. The orbits below are listed
in the canonical spectrum-then-size order the driver emits.

Three structural facts fall out, all checkable consequences rather than decoration.

**The hyperoval of `PHG(2,Z4)` is unique up to the ring-linear group and is a transversal of the
neighbour classes.** One orbit of 256 arcs, so its stabilizer in `PGL(3,Z4)` has order
`43008 / 256 = 168`, which is `|GL(3,F2)|` — the hyperoval's symmetry group is the residue plane's
full collineation group, lifted. Its spectrum is `(7, 0, 21, 0, 0, 0, 0)`: no tangent line at all,
which is what makes it a hyperoval, and 21 secants, which is exactly `C(7,2)`. Since every secant
accounts for one point pair and there are 21 of each, no two of the seven points are neighbours, so
the arc meets each of the seven neighbour classes exactly once. That was confirmed directly: the
class profile of a maximum 2-arc is `(1,1,1,1,1,1,1)` for `Z4`, and `(0,1,1,1,1,1,1)` for `S2`,
which misses a class. The `Z4` hyperoval is a lift of the whole residue plane `PG(2,2)`, one point
above each of its seven points, and the stabilizer order is then forced.

**`S2` splits its maximum 2-arcs into two genuinely different families.** Orbit of 1792 with
spectrum `(7, 6, 15, 0, 0, 0, 0)` — six tangent lines — and orbit of 224 with spectrum
`(10, 0, 18, 0, 0, 0, 0)`, tangent-free like the `Z4` hyperoval but with 18 secants against only
`C(6,2) = 15` point pairs, so three of its pairs are neighbouring pairs lying on two common lines
each.

**The orbit of size 7 among the maximum `(16,4)`-arcs is identified explicitly.** It consists of the
seven sets obtained by deleting, from all 28 points, the three neighbour classes lying over a line
of `PG(2,2)`; all seven such 16-sets were checked to meet every line in at most 4 points. Its
spectrum `(4, 0, 0, 0, 24, 0, 0)` says the same thing: 4 lines missed entirely, 24 lines met in the
maximum 4 points, nothing in between.

### 2.3 Codes and the Gray-map cross-check

The Gray map sends `0 -> 00`, `1 -> 01`, `2 -> 11`, `3 -> 10` and is an isometry from the
homogeneous weight on the ring (which for `Z4` is the Lee weight) to the Hamming weight on binary
words of twice the length. Taking the columns of a generator matrix to be the points of a maximal
2-arc:

| Quantity                        | `Z4` hyperoval      | `S2` maximal 2-arc |
|---------------------------------|---------------------|--------------------|
| ring length                     | 7                   | 6                  |
| codewords                       | 64                  | 64                 |
| minimum homogeneous (Lee) weight| 6                   | 4                  |
| minimum Hamming weight over `R` | 4                   | 3                  |
| Gray image                      | `(14, 2^6, 6)`      | `(12, 2^6, 4)`     |
| Gray image is `F2`-linear       | **no**              | **yes**            |

The `Z4` row is the published landmark exactly: "the hyperovals in `PHG(2, Z4)` correspond to the
optimal non-linear binary `(14, 2^6, 6)`-codes", the expurgated Nordstrom–Robinson code.

The `S2` row explains *why* the two rings' tables differ at `n = 2`, and this is the mechanism, not
a restatement. `S2` has characteristic 2, so its Gray map is `F2`-linear and every Gray image it
produces is a linear binary code; and a `(14, 2^6, 6)` binary code cannot be linear, since
Kiermaier–Kohnert state that the expurgated Nordstrom–Robinson code "has higher minimum distance
than any linear binary `[14, 6]`-code". So `S2` cannot reach 7 and `Z4` can. The
instrument had to distinguish two rings of the same cardinality with the same residue field and
identical plane parameters, and the distinguishing feature is a carry.

A second, independent `Z4` landmark was replayed without using the geometry at all. The driver
searches all 64 monic cubics over each ring for those dividing `x^7 - 1`, builds the extended cyclic
code of length 8 whose coordinates sum to zero, and reports its parameters:

| Ring | monic cubic divisors of `x^7 - 1`                     | words | min. homogeneous weight | Gray image      | linear |
|------|-------------------------------------------------------|-------|-------------------------|-----------------|--------|
| `Z4` | `x^3 + 2x^2 + x + 3`, `x^3 + 3x^2 + 2x + 3`           | 256   | 6                       | `(16, 256, 6)`  | no     |
| `S2` | `x^3 + x^2 + 1`, `x^3 + x + 1`                        | 256   | 4                       | `(16, 256, 4)`  | yes    |

The `Z4` entry is the octacode, and its Gray image is the Nordstrom–Robinson code `(16, 256, 6)`.
The two divisors are the Hensel lifts of `x^3 + x + 1` and `x^3 + x^2 + 1`; over `S2` the "lift" is
the reduction itself, and the code degrades to the linear `(16, 256, 4)`.

---

## 3. Gap specification — where the Ergodis core breaks on chain-ring input

Every entry below is a call into the core as it stands, with the measured result. Nothing here was
patched or worked around; the driver reimplements ring arithmetic locally, which is the expected
outcome and is itself the specification of what is missing.

### 3.1 `field::Prime`, `matrix::Matrix` — no applicable entry point

`Prime::<4>::validate()` returns `FieldError::InvalidModulus` ("the modulus must be prime and lie in
2..=251"), so `Matrix::new::<4>(1, 1, vec![2])` fails at construction. Routing the ring data through
the binary entry point instead — `Matrix::new::<2>(1, 2, vec![2, 3])` — fails with
`MatrixError::UnreducedEntry`.

**Verdict: clean failure.** This is the best of the five outcomes: a caller who wants `Z4` and asks
for it by modulus is told no, loudly, at the door.

**What a ring-capable layer must provide.** A `ChainRing` trait alongside `FiniteField`, carrying
`add`, `neg`, `mul`, a unit predicate, unit inversion, the residue field's order `q`, the nilpotency
index, and a generator of the maximal ideal. Every one of those is needed by the driver, and none of
them is expressible through `FiniteField`, whose `inverse` is total on nonzero elements.

### 3.2 `field::SmallField` / `field::Gf4` — silent semantic substitution

`SmallField::new(2, 2)` succeeds and yields `GF(4)`, and it is the *only* arithmetic of order four
the core offers. It accepts exactly the element encoding `0..4` that both chain rings use, so ring
data flows into it without any type error. The tables diverge as follows (of 16 cells each):

| Ring | addition cells differing from `GF(4)` | multiplication cells differing from `GF(4)` |
|------|---------------------------------------|---------------------------------------------|
| `Z4` | 4 (`1+1`, `1+3`, `3+1`, `3+3`)        | 4 (`2*2`, `2*3`, `3*2`, `3*3`)              |
| `S2` | 0 — identical                          | 4 (`2*2`, `2*3`, `3*2`, `3*3`)              |

Witnesses: `GF(4)` says `2*2 = 3` where `Z4` says `0` and `S2` says `0`; `GF(4)` says `3*3 = 2`
where both rings say `1`. The static `Gf4` and the runtime `SmallField::new(2, 2)` were checked to
agree with each other on all 32 cells, so this is a property of the core's model of order four, not
of one implementation.

**Verdict: the dangerous case.** `GF(4)` agrees with each ring on 12 of 16 products, and agrees with
`S2` on addition *exactly*. A caller who substitutes it gets plausible output from every downstream
kernel.

**What a ring-capable layer must provide.** Order alone must stop identifying an algebra. Order 4
admits three commutative unital rings that matter here (`GF(4)`, `Z4`, `F2[u]/(u^2)`), and a
constructor keyed on `(characteristic, degree)` cannot name the last two.

### 3.3 `matrix::canonical_row_basis`, `matrix::row_space_contains` — silently wrong answers

All 256 two-by-two matrices with entries in `0..4` were run through both the true row module over
each ring and `Matrix::canonical_row_basis_with(GF(4))`:

| Ring | matrices tested | row-module size mismatches | membership tests | membership disagreements | reference Howell mismatches |
|------|-----------------|----------------------------|------------------|--------------------------|-----------------------------|
| `Z4` | 256             | 117                        | 4096             | 1098                     | 0                           |
| `S2` | 256             | 117                        | 4096             | 1098                     | 0                           |

Smallest witness, identical for both rings: for `[[2,0],[0,0]]` the row module has 2 elements
(`{(0,0), (2,0)}`), while the `GF(4)` elimination reports rank 1 and therefore a row space of 4.
`row_space_contains_field::<Gf4>` accordingly answers "yes" for the vector `(1,0)`, which is not in
the module over either ring. The kernel never errors: it returns a confident wrong answer on 27% of
the membership queries.

The root cause is one line of `canonicalize_rows_in_place_field`: it selects a pivot by
`data[row * cols + col] != 0` and then calls `F::inverse` on it. Over a ring, "nonzero" and
"invertible" are different predicates, and there is no third branch for a pivot in the radical.

**What a ring-capable layer must provide.** The Howell form. The driver carries a reference
implementation (`howell_basis`) that derives the canonical basis from the enumerated module — valid
only at the tiny sizes used here, and included precisely so the contract is checkable: on all 512
test matrices, the row module generated by the reference Howell basis has exactly the true
cardinality. A production kernel needs the standard column-sweep with two pivot branches (unit
pivot, normalize and eliminate; radical pivot, normalize to the ideal generator) plus the
annihilator rows that make the form canonical, and the module invariants should come from the Smith
form. `null_space`, `row_space_contains`, and everything layered on `canonical_row_basis` inherit
the same fix.

### 3.4 `projective::ProjectiveIndex` — wrong object, silently

Feeding the 64 vectors of `R^3` to `ProjectiveIndex::new(SmallField::new(2,2), 2)`, i.e. to the
indexer for `PG(2,4)`:

| Measurement                                              | Value |
|----------------------------------------------------------|-------|
| `point_count()` reported for `PG(2,4)`                   | 21    |
| true point count of `PHG(2,R)`                           | 28    |
| non-unimodular nonzero vectors accepted as points        | 7     |
| unimodular vectors rejected                              | 0     |
| field classes merging two or more distinct ring points   | 14    |
| ring points whose two representatives get different indices | 21 |

Three separate failures in one kernel. It admits 7 phantom points — vectors such as `(2,0,0)` whose
coordinates all lie in the radical, which generate non-free submodules and are not points of the
Hjelmslev plane at all, but which `GF(4)` happily normalizes because 2 is invertible there. It
merges genuinely distinct Hjelmslev points into 14 of its classes. And it splits 21 of the 28
Hjelmslev points, giving the two associates `v` and `3v` of the same point different indices.

The mechanism is the normalization in `ProjectiveIndex::index`: it takes the first *nonzero*
coordinate and inverts it. Over a chain ring the pivot must be the first *unit* coordinate, and a
vector with no unit coordinate is not a point. The documented invariant — "every nonzero vector has
exactly `q-1` associates" — is false here: the unit group has order 2 while `|R| - 1 = 3`, and the
non-units form an orbit structure of their own.

**What a ring-capable layer must provide.** Unimodularity as an admission test; normalization by
the first unit coordinate; a point count of `q^{2(m-1)}(q^2+q+1)` rather than `(q^{d+1}-1)/(q-1)`;
and, above the indexer, the neighbour relation as a first-class structure, since two distinct points
no longer determine a unique line (measured here: 42 of the 378 point pairs lie on two common
lines).

### 3.5 `linear_code::CompiledBinaryLinearCode` — silently wrong via the nearest available path

The core's only minimum-distance kernel takes a `GF(2)` generator matrix and enumerates the row span
in Gray-code order, scoring by `count_ones`. There are two obstructions and the driver measured
both.

Hamming weight is hardcoded. `CompiledBinaryLinearCode` scores by `popcount`; so does
`css_distance`, where the weight is a trait method returning `count_ones` over packed words in every
implementation. Neither Lee nor homogeneous weight is expressible, and the homogeneous weight is not
a function of the support, so no relabelling of coordinates recovers it.

Linearity is assumed. The Gray image of a `Z4`-linear code is generally not `F2`-linear, so it has
no generator matrix at all. Taking the only path that type-checks — computing the `F2`-span of the
Gray image and asking the core for its minimum weight — gives:

| Measurement                                   | Value |
|-----------------------------------------------|-------|
| Gray image of the hyperoval code: words        | 64    |
| its true minimum Hamming distance              | 6     |
| dimension of its `F2`-span                     | 9     |
| words in that span                             | 512   |
| minimum weight the core reports for the span   | 4     |

The core answers 4 where the truth is 6, having silently replaced a 64-word non-linear code with a
512-word linear one.

**What a ring-capable layer must provide.** A weight function as a parameter rather than a constant
— a table `R -> u32` covering Hamming, Lee, and homogeneous uniformly — and a minimum-distance path
that enumerates a module `{aG : a in R^k}` rather than a `GF(2)` row span. A `Z4` code of type
`4^{k1} 2^{k2}` has `4^{k1} 2^{k2}` codewords, which the current `1 << rank` enumerator cannot
express. The CSS engine inherits the same weight abstraction.

---

## 4. Where the core held

Recording this is as useful as recording the breaks; the slate predicted it, and the prediction was
correct.

**`group_action` transferred unchanged and did real work.** The maximum-arc classification was not
done by hand. For each `n`, the driver indexes the maximum arcs, induces the permutation action of
the seven `GL(3,R)` generators on that index set, and hands it to the core's
`ExplicitPermutationAction` / `compile_permutation_orbits` / `verify_permutation_orbits` pipeline.
It ran on point sets from 1 up to 34272 arcs, produced the orbit decompositions in the tables above,
and **every orbit certificate replayed successfully under the core's independent verifier**. The
group is a ring-linear group acting on a Hjelmslev plane; the core neither knew nor needed to know.
The reason it survives is structural: `FinitePermutationAction` is stated over an abstract indexed
set with an abstract generator table, and never touches the algebra underneath. That abstraction
boundary is drawn in the right place, and it is the model the algebraic kernels do not follow.

**One usability limit worth naming, not a break.** The orbit compiler is indexed by `u32`, so
classifying objects means the caller must first materialize and index them. That was fine here
(34272 arcs) and would not be for a census whose object count exceeds `u32`. There is no
canonical-augmentation or orderly-generation layer that would let orbits be computed without
enumerating the whole set first — which matches the slate's §1 inventory, and is a search-layer gap
rather than a ring gap.

**The census and certificate discipline transferred unchanged**, exactly as predicted: exhaustive
search with a bound, symmetry reduction, replayable certificate, compact evidence file. None of it
needed a ring-aware idea.

**A false expectation corrected.** The slate listed only `matrix.rs`, `ProjectiveIndex`, and the
distance kernels as breaking. It did not anticipate §3.2 — that the core would *accept* order-four
ring data through `SmallField::new(2, 2)` and compute confidently with the wrong multiplication
table. That is the most dangerous of the five findings, because it is the only one where nothing at
any layer signals a problem.

---

## 5. Evidence bundle and replay

Per `notes/research-reproducibility-conventions.md`.

| Role                       | Path                                                            | SHA-256 |
|----------------------------|-----------------------------------------------------------------|---------|
| driver (generator)         | `ergodis-private/src/bin/c1028_chain_ring.rs`                   | `381a28f81ec7c6a764f7a4f40ea8b7c72a3cfccbb0033d8a5df06d855c10120d` |
| independent replay         | `ergodis-private/python/check_c1028_chain_ring.py`              | `f1782b4608ab514ffe7e74157526a0e7824514c1d688832ef7ca33ed6968281e` |
| compact certificate        | `ergodis-private/evidence/c1028-chain-ring-instrument-test.json`| `2119001b3e31fe4a85b5c5c9a2533b196000633fffade197955462f999ab8d3e` |
| ground-truth blob (uncommitted) | `~/.cache/ergodis/c1028/lit/2409.02099.pdf`                | `e000b315c711d754a7940f090ceab9e48d03e3457f172388450dda182ff6cdbd` |

The certificate hash is also recorded in `ergodis-private/evidence/SHA256SUMS`. The certificate is
byte-for-byte reproducible: two consecutive runs of the driver produced the identical hash above.
The bulk report at `~/.cache/ergodis/c1028/c1028-chain-ring-report.json` is not hashed here because
it embeds wall-clock timings and so is not reproducible byte-for-byte; every claim in this document
is carried by the certificate, which excludes timings.

**Exact replay command.** `ergodis-private`'s library does not currently compile — an untracked
`src/g133_sparse_defect.rs` from a concurrent session is declared by `src/lib.rs` — so the driver is
built out of tree against the read-only Ergodis core. The build crate is generated, not committed:

```sh
mkdir -p ~/.cache/ergodis/c1028/build
cat > ~/.cache/ergodis/c1028/build/Cargo.toml <<'TOML'
[package]
name = "c1028-build"
version = "0.0.0"
edition = "2021"
publish = false

[[bin]]
name = "c1028_chain_ring"
path = "<repo>/ergodis-private/src/bin/c1028_chain_ring.rs"

[dependencies]
anyhow = "1"
ergodis = { path = "<repo>/papers/complete-repair-ports/ergodis" }
serde = { version = "1", features = ["derive"] }
serde_json = "1"

[workspace]
TOML
cd ~/.cache/ergodis/c1028/build
CARGO_TARGET_DIR=~/.cache/ergodis/c1028/target cargo build --release
~/.cache/ergodis/c1028/target/release/c1028_chain_ring \
  --out ~/.cache/ergodis/c1028 \
  --cert <repo>/ergodis-private/evidence/c1028-chain-ring-instrument-test.json
```

Once `ergodis-private` builds again, autobins picks the driver up and
`cargo run --release --bin c1028_chain_ring` is equivalent; no `Cargo.toml` edit is needed.

**Independent replay.** `python3 ergodis-private/python/check_c1028_chain_ring.py` — exit status 0
and "all published cells reproduced". It is independent in construction as well as implementation:
it builds the lines of `PHG(2,R)` as spans of pairs of non-neighbouring points and separately as
kernels of unimodular linear forms, and checks the two line sets are equal, whereas the Rust driver
uses only the dual construction. It agrees with the driver on the plane parameters (28 points, 28
lines, 6 points per line, 7 neighbour classes of size 4), on `m_2 = 7` for `Z4` with 256 maximum
arcs and `m_2 = 6` for `S2` with 2016, on `m_3 = 10` with 34272 maximum arcs for both rings, on the
`(14, 64, 6)` non-linear and `(12, 64, 4)` linear Gray images, and on the octacode's
`(16, 256, 6)` Nordstrom–Robinson Gray image. It does not replay `n = 4, 5, 6`, which are Rust-only.

**Cross-checks internal to the run.** `|GL(3,R)| = 86016` computed twice by different methods;
every orbit partition replayed by the core's own `verify_permutation_orbits`; the neighbour relation
derived twice (as multiple-join and as residue fibre) and checked equal; the reference Howell basis
checked to regenerate the exact row module on all 512 test matrices; the octacode found by search
over all monic cubics rather than by asserting a remembered generator polynomial.

**Negative results and their searched domain.** The claim "there is no open cell in the order-four
arc table" has domain: Table 3 of arXiv:2409.02099v1, read at full text, covering `m_n(R)` for
`|R| = 4` and all `n` in `0..=6`, every entry carrying the exact-value marker. Stop condition: the
table is complete over its full declared domain, so no further search was performed for that
cardinality. Open cells at `|R| = 16` and `|R| = 25` were not investigated. No claim of novelty is
made for anything in §2: `m_n` for `|R| = 4` is published, and the arc counts and orbit
decompositions were not searched for in the literature, so they are reported as reproduced or
derived, never as new.

---

## 6. Closeout: extra juice, the Tao pass, and the mystery ledger

### 6.1 Cheap upgrades taken during the run

- The census was extended from the published `m_n` to the full count of maximum arcs and their
  orbit decomposition under `GL(3,R)`, at no extra cost, because the second search pass had to run
  anyway to feed the orbit compiler. That turned the calibration into a use of a core kernel on ring
  data, which is the more valuable half.
- The size-7 orbit of maximum `(16,4)`-arcs was identified structurally (complements of the three
  neighbour classes over a line of `PG(2,2)`) rather than left as an unexplained orbit size.
- Per-orbit line spectra were added to the driver after the first run, which is what turned mystery
  ledger items 1 and 2 from bare counts into labelled comparisons; and the neighbour-class profile
  of the maximum 2-arcs was computed, which supplied the mechanism for the `Z4` hyperoval's
  uniqueness and its stabilizer order.
- The octacode is found by exhaustive search over monic cubics dividing `x^7 - 1` instead of being
  hardcoded, which removes a recall dependency from the calibration.
- Both rings are run through everything, so the discriminating cell is a computed contrast rather
  than a single reproduced number.

### 6.2 What the Tao pass asks that the plan did not

The question worth taking from the sharper reading is *why* the instrument's failures cluster where
they do. They cluster on one predicate. Every algebraic break in §3 — the pivot selection in
`canonicalize_rows_in_place_field`, the normalization in `ProjectiveIndex::index`, the totality of
`FiniteField::inverse` on nonzero elements — is the same conflation of "nonzero" with "invertible".
The kernels that survived (§4) are exactly the ones that never form that predicate. That is a
sharper specification than a list of five broken functions: a ring-capable Ergodis is reached by
splitting one predicate everywhere it occurs, and the audit for it is mechanical.

A second observation the plan did not anticipate: the natural test object for a ring layer is not a
single ring but a *pair* of rings of the same order. Every parameter the core can see —
cardinality, residue field, plane order, point count, line count — is equal for `Z4` and `S2`, and
they differ in exactly one arc-table cell. Any future ring kernel should be regression-tested
against both, because a bug that reproduces `Z4` alone will very likely also "reproduce" `S2`.

### 6.3 Mystery ledger

1. **`Z4` and `S2` have matching maximum-arc orbits at every `n >= 3`, orbit for orbit, and differ
   only at `n = 2`.** The `ej` pass strengthened this from a coincidence of counts to a coincidence
   of labelled invariants: the driver now emits each orbit's line spectrum, and at `n = 3, 4, 5` the
   two rings agree on the orbit count, on the multiset of orbit sizes, *and* on the spectrum of every
   orbit, in the same canonical order. At `n = 3` that is eight orbits with sizes
   10752, 7168, 7168, 3584, 3584, 1344, 448, 224 and eight matching spectra; at `n = 4`, three
   orbits with sizes 1792, 336, 7 and matching spectra; at `n = 5` a single orbit of 28. The planes
   are certainly not isomorphic — `m_2` is 7 versus 6, which settles that. **Still open, and now
   sharper.** The remaining evidence gap is whether an explicit bijection realizes the match: is
   there a map, defined on arcs of size at least 3 but not extending to the plane, carrying each
   `Z4` orbit to the `S2` orbit with the same spectrum? Owning successor: a follow-up in this lane,
   still cheap — both orbit lists are enumerated and the pairing is already pinned down by the
   spectra.
2. **Why `S2` splits its maximum 2-arcs into two orbits while `Z4` has one.** **Substantially
   settled by the `ej` pass.** The `Z4` hyperoval's uniqueness now has a mechanism: it is the
   transversal of the seven neighbour classes, so it is a lift of `PG(2,2)` and its stabilizer is
   forced to be the full lifted `GL(3,2)` of order 168. The `S2` split is now described rather than
   merely counted — the 1792-orbit has six tangent lines, the 224-orbit is tangent-free with three
   neighbouring point pairs — but not explained. Remaining evidence gap: the stabilizer structure of
   each `S2` orbit representative (the 224-orbit's stabilizer has order 192), which was not
   computed.
3. **The 27% membership-disagreement rate in §3.3 is a measurement, not a bound.** It is specific to
   two-by-two matrices with uniformly drawn entries and says nothing about how often the failure
   would bite in practice. **Deliberately left open**: the number's job is to show the kernel answers
   rather than errors, and it does that.
4. **No mystery in the calibration itself.** All fourteen published cells, both Gray-map landmarks,
   and both independent group-order computations agreed on the first run, with no discrepancy to
   chase. Stated plainly rather than dressed up: the instrument test found no error in the published
   tables and no error in its own arithmetic.

### 6.4 Vibe check

Good, and cleanly so. The gate corrected the slate's premise before any compute was spent, the
calibration reproduced every published cell in under a second, and all five predicted-or-discovered
breaks are backed by a concrete input and a measured wrong answer rather than an argument. The one
genuinely uncomfortable finding is §3.2: the core will accept `Z4` data as `GF(4)` and compute
through to the end without a single signal.

