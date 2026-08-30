# C985 Ergodis open-problem quotient spikes

**Lane:** `complete-ports`

**Date:** 2026-08-30

## Decision

Ergodis has a credible route to bounded open cases when a theorem turns a huge
syntactic search into a small exact continuation signature. C880 remains the
primary live test. The highest-value next external target is subgroup ID 3 in
the length-333 Legendre-pair programme for Hadamard order 668: it is one of nine
low-order common-multiplier cases left open by Ramos--Hulak--de Queiroz.

This is not a claim about unrestricted Hadamard existence. Eliminating ID 3
would close one published structured ansatz; finding an ID-3 pair would produce
a Hadamard matrix of the smallest unresolved order.

## Exact ID-3 compression quotient

For ID 3 the multiplier image modulo 37 has order three. Each entry of the
9-compression belongs to

```text
V3 = {epsilon + 6k : epsilon in {-1,1}, -6 <= k <= 6}.
```

The two compressed sequences have row sum one after independent global
negation, total squared norm 594, and combined cyclic autocorrelation `-74` at
shifts 1 through 4. The energy bound removes every value of magnitude at least
25. Thus an individual compressed sequence is observed exactly by

```text
(squared norm, PAF(1), PAF(2), PAF(3), PAF(4)).
```

`examples/legendre333_compression.rs` enumerates this relaxation iteratively.
It uses exact remaining-sum energy envelopes, one fixed-capacity record array,
and no allocation or recursion in the enumeration loop. There are exactly
17,562,843 normalized raw sequences. None has period 1 or 3 because its row
sum is one, so every cyclic orbit has size nine and the exact canonical census
is 1,951,427. Quotienting by the five-coordinate response leaves 769,834
signatures; only 4,262 signatures have a complementary signature satisfying
all compressed Legendre equations.

The relaxation is feasible. One independently replayed compressed witness is

```text
left  = [-1,-1, 1, 1,-1, 1,-1, 1, 1]
right = [-11,1,-5,-5,5,-11,5,11,11].
```

On a quiet core the complete compile/search took 0.70 seconds; during a
16-thread Gurobi diagnostic it took 1.14 seconds. Peak RSS was 47.5 MiB. These
are diagnostic timings, not publication benchmarks. The useful result is the
exact reduction from a quadratic comparison of 17.56 million sequences to
4,262 compatible signature states.

## Next lift

The compressed witness is not a length-333 Legendre pair. The next compiler
must lift only the 4,262 compatible signatures through the exact 117-orbit ID-3
model. The natural hierarchy is:

1. compile each `Z_9` column's 13 orbit signs to its exact compressed value and
   labelled internal contribution;
2. combine columns in the CRT geometry while retaining only the shift-orbit
   PAF coordinates still observable by an unfinished continuation;
3. reject direct complements as soon as a full-shift coordinate cannot reach
   `-2`;
4. stream compact survivor or exclusion evidence and replay it against direct
   length-333 arithmetic.

An exact exclusion would settle ID 3. A survivor would be strictly more
valuable than the present compression witness because it would satisfy the
complete multiplier-orbit equations and could be expanded directly.

## Target ranking

1. C880 exact `g(8)`: smallest fully compiled noncoding theorem target;
2. Hadamard-668 Legendre ID 3: strongest external open ansatz with a new exact
   quotient already measured;
3. remaining Legendre IDs 4/5/7/9/10 after the ID-3 lift is reusable;
4. `M(18)` equiangular-line exclusions, contingent on importing Seidel/Jacobi
   spectral envelopes into the integer-moment compiler;
5. restricted order-12 projective-plane symmetry classes, credible only after
   a much stronger incidence quotient; unrestricted order 12 is not a current
   Ergodis-scale target.

## Source boundary

The external status and formulas were checked against the full cached text of
Ramos, Hulak and de Queiroz, *Multiplier obstructions for Legendre pairs of
length 333*, arXiv `2607.20765v1`, SHA-256
`de396e62dc6d1cf43b9fea51d753318464bc8ed773c6b3f6cf6cb5fa681a1c70`. The paper
leaves IDs `0,1,2,3,4,5,7,9,10` open and explicitly distinguishes fixed common
multipliers from unrestricted and translation-twisted cases.
