# C432 — centralizer closure classifies the frozen coherent fusions

**Lane:** `crowns`

**Date:** 2026-07-23

**Verdict:** `THEOREM; PORTABLE TWO-FOURIER-CLOSURE CRITERION; q=5/9/11 LATTICES
REPRODUCED WITHOUT SET-PARTITION ENUMERATION; ej CLOSES q=19 AND FINDS A DUAL RANK-SIX PAIR`

## Result

Let `A` be a commutative association scheme of rank `r`, with first and second eigenmatrices
`P,Q` in compatible adjacency/idempotent order, so `PQ=QP=|X|I`.  For a partition `pi` of the
adjacency indices with `{0}` singleton, let

```text
C(pi) = span{1_B : B is a block of pi}.
```

For any invertible matrix `M`, define `R_M(pi)` by putting two row indices in the same block
exactly when their row sums over every `pi`-block agree.  Equivalently,

```text
M C(pi) <= C(R_M(pi)).
```

Define

```text
T(pi) = R_Q(R_P(pi)).
```

Then:

1. `T(pi)` refines `pi`;
2. `T` is monotone in the refinement order;
3. iterating `T` stabilizes after at most `r-|pi|` strict rounds; and
4. `pi` is the relation partition of a coherent fusion if and only if it is a fixed point of
   `T`.  At a fixed point, `rho=R_P(pi)` is the dual partition and
   `P C(pi)=C(rho)`.

Thus `cl(pi)=T^infinity(pi)` is an intrinsic coherent-fusion closure operator.  It is the
representation-algebra form of the centralizer criterion: the orbital centralizer algebra of the
underlying permutation action has adjacency-coordinate algebra `C(pi)`, Fourier transport sends it
into the primitive-idempotent coordinate algebra, and a coherent subalgebra is exactly a
two-Fourier fixed point.  No orbit labels, stabilizer names, or field-specific multiplication
rules enter the theorem.

There is also a complete output-sensitive lattice search.  Begin with
`{0} | {1,...,r-1}`.  For every discovered fixed partition, split one block in every possible
binary way (the covers in the partition lattice), close each cover under `cl`, and repeat only for
new fixed points.  Every coherent fusion appears: if an undiscovered fixed partition refines a
discovered one, a cover lying below it closes to a strictly intermediate fixed partition still
lying below it.  This contradicts minimality unless the search advances toward the target.

This replaces traversal of all `Bell(r-1)` partitions by closure of covers of the fusion lattice
actually found.  Its exact probe bound is

```text
sum over discovered pi of
  sum over blocks B of pi with |B|>=2 of (2^(|B|-1)-1),
```

before deduplication.  The theorem is portable; the bound is output-sensitive but remains
exponential in a large unresolved block, so it is not an all-field fusion classification.

## Frozen C400 controls and the q=19 ej upgrade

The checker consumes only C400's exact eigenmatrix certificate, verifies its SHA-256, checks
`P^2=q^3 I`, and runs the closure search.  It finds:

| `q` | rank | cover probes | C400 Bell candidates | coherent-fusion ranks |
|---:|---:|---:|---:|:---|
| 5 | 4 | 3 | 5 | `2,4` |
| 9 | 6 | 17 | 52 | `2,4,6` |
| 11 | 8 | 71 | 877 | `2,4,6,8` |
| 19 | 14 | 4,183 | not attempted | `2,4,6,6,14` |

The actual proper blocks are exactly:

```text
q=9, rank 4:
  {0} | {1,5} | {2} | {3,4}

q=11, rank 4:
  {0} | {1,4,5} | {2,3,6} | {7}

q=11, rank 6:
  {0} | {1,7} | {2} | {3,4} | {5} | {6}.

q=19, dual rank-6 pair:
  A = {0} | {1,7} | {2,10,11} | {3,8} | {4,9,12,13} | {5,6}
  B = {0} | {1,10} | {2,6,11} | {3,9} | {4,8} | {5,7,12,13}.
```

All q=5/9/11 fusions are self-dual in the frozen ordering.  The q=19 ej pass gives the first sharp
counterpoint: `A` and `B` are distinct coherent fusions and Fourier dual to one another.  Its
rank-four orthogonal fusion and the endpoints remain self-dual.  At q=19 the search probes all
4,095 bottom covers and only 88 covers of discovered proper fusions; `3` covers close to the
orthogonal rank-four fusion, `15` to each member of the dual rank-six pair, and `4,150` to the
discrete scheme.  Every closure takes at most three strict rounds.

## Proof

Write `rho=R_P(pi)`.  By definition,

```text
P C(pi) <= C(rho).
```

Applying the same construction to `Q` gives

```text
Q C(rho) <= C(T(pi)).
```

Since `QP=|X|I`, these inclusions imply `C(pi)<=C(T(pi))`; inclusion of partition-coordinate
algebras is exactly refinement, proving item 1.  Monotonicity follows because refining a column
partition can only refine the row-signature partition.  Every strict application therefore raises
the number of blocks, proving termination.

If `T(pi)=pi`, the two displayed inclusions and invertibility give

```text
dim C(pi) <= dim C(rho) <= dim C(T(pi)) = dim C(pi).
```

Both inclusions are equalities, so `P C(pi)=C(rho)`.  This is precisely the
Bannai--Muzychuk/centralizer condition: every fused adjacency sum has constant eigenvalue on each
`rho`-block, with the same number of relation and idempotent blocks.  Hence `pi` is coherent.
Conversely, a coherent fusion has exactly those equalities, and applying `Q` returns `C(pi)`, so
`T(pi)=pi`.

For completeness of the cover search, order partitions by refinement.  Closure is extensive,
monotone, and idempotent.  If fixed `tau` strictly refines discovered fixed `pi`, choose a cover
`sigma` of `pi` with `sigma<=tau`.  Then

```text
pi < sigma <= cl(sigma) <= cl(tau)=tau.
```

Thus closing covers cannot jump past a target fixed point, and repeated closure reaches every fixed
point in the finite interval.

## Reproduction and trusted boundary

Run from `/home/tavis/src/othello`:

```bash
python3 notes/2026-07-23-c432-fusion-closure-classification.py --check
sha256sum -c notes/2026-07-23-c432-fusion-closure-classification.sha256
```

To regenerate the canonical JSON before checking:

```bash
python3 notes/2026-07-23-c432-fusion-closure-classification.py --write
```

Load-bearing input:

| artifact | bytes | SHA-256 |
|:---|---:|:---|
| C400 certificate JSON | 129,761 | `96052bf03609b8136dbba3461ae8a4c5232b97935ca4b5d6920854eeae561811` |

C432 evidence:

| artifact | bytes | SHA-256 |
|:---|---:|:---|
| checker `.py` | 9,457 | `13b2fad06727977671987acd03a49082acadc1890230a474672bf3c1c600d838` |
| certificate `.json` | 12,479 | `b154b44f8417ca4fc14f22779d3fdc27036c2b6318dacd51b2f81d83adb2495d` |

The standard-library-only checker uses exact integer and rational arithmetic.  At q=5/9/11 it
compares the closure output with C400's frozen exhaustive fusion lists.  At all four fields it
separately reconstructs the intersection numbers from `P^{-1}=P/q^3`, then verifies ordinary
product closure of every returned fused adjacency basis.  This is the independent algebra check
for the new q=19 pair; the closure proof supplies completeness without an exhaustive reference
list.

The trusted boundary is the exact C400 eigenmatrix certificate, Python integer/rational arithmetic,
and the two elementary linear-algebra lemmas above.  The computation classifies exactly
`q=5,9,11,19`.  It does not classify q=29 or larger, prove separability, identify every fusion as
an overgroup-orbit fusion, or make a novelty/priority claim.

## Claim boundary and hand-back

- C400's Bell-number stop is removed for its three bounded controls: the complete lattices now
  follow from a portable centralizer closure theorem and a 3/17/71-probe certificate.
- The user-requested ej pass goes beyond the original acceptance gate and completely classifies
  q=19 with 4,183 probes.  Besides the expected orthogonal fusion, it finds two new rank-six
  relation partitions exchanged by Fourier duality.
- The result is not a field-by-field orbit-table reformulation.  Its input is the abstract
  eigenmatrix pair, and its theorem applies to every commutative association scheme.
- The method does not by itself make q=29/59 cheap.  Their initial unresolved blocks still have
  exponential cover count, so a uniform all-field theorem needs extra representation structure
  beyond this closure operator.
- No manuscript or Lean claim is changed by C432; the clebsch owner may consume the criterion as
  the structural certificate behind C400's small-field fusion lattice.

## Mystery ledger

- **Settled by the user-requested ej pass:** q=19 is cheap enough for complete cover closure.
  Its lattice has five elements, not the expected three: two incomparable rank-six fusions form a
  Fourier-dual pair alongside the rank-four orthogonal fusion.
- **Settled negatively:** self-duality of every fusion is a q<=11 accident, not a consequence of
  `P=Q`.  At q=19, applying `R_P` exchanges the two displayed rank-six partitions.
- **Open, bounded:** one to three strict closure rounds suffice for all 4,274 probes across the four
  fields.  This is an exact certificate fact, not a general theorem about the closure operator; the
  missing evidence is a structural depth bound for `T` on this scalar-`A5` family.
- **Open mechanism:** the representation-theoretic source of the q=19 dual rank-six pair is not
  identified.  The exact next discriminator is whether either partition is an overgroup-orbit
  fusion; C432 proves coherence, not Schurity.
- **No hidden all-field claim:** q=29 and q=59 remain unclassified.  The exact gate is a
  representation-specific reduction of the first cover layer, not a larger fieldwise run.
