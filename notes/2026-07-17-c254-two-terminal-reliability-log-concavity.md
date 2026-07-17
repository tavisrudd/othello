# C254 — two-terminal reliability coefficient log-concavity

**Lane:** `rp-next`

**Date:** 2026-07-17

**Status:** COMPLETE — an exact 14-helper-edge two-terminal series--parallel multigraph violates
ordinary log-concavity.  In fact the witness belongs to an infinite counterexample family.  This
refutes C245's representable pointed-profile LC conjecture.

## Decision

For a two-terminal graph `G=(V,E;s,t)`, put

```text
a_k(G) = #{S subset E : |S|=k and (V,S) contains an s--t path},
A_G(z) = sum_k a_k(G) z^k.
```

Add a distinguished edge `x=st` and take the cycle matroid of `G+x`.  Then

```text
x in cl(S)  iff  S contains an s--t path,
```

so this is exactly C245's pointed profile.  The polynomial is also the standard `N`-form
coefficient sequence of two-terminal reliability,

```text
R_G(p) = sum_k a_k(G) p^k (1-p)^(|E|-k).
```

The counterexample below is graphic, hence regular and representable over every field.  The added
target edge is neither a loop nor a coloop.

## Exact composition laws

Let `G` and `H` have disjoint edge sets of sizes `m` and `n`.  Direct conditioning on the two
component states gives

```text
A_(G series H)(z) = A_G(z) A_H(z),                                      (1)

A_(G parallel H)(z)
  = A_G(z)(1+z)^n + A_H(z)(1+z)^m - A_G(z)A_H(z)                         (2)
  = (1+z)^(m+n) - ((1+z)^m-A_G(z))((1+z)^n-A_H(z)).
```

Equation (1) is ordinary coefficient convolution, so the standard convolution theorem preserves
LC sequences with interval support.  Equation (2) subtracts a convolution of failure profiles
from the binomial row; it does not preserve LC, even when both inputs are themselves TTSP and LC.

## Infinite TTSP counterexample family

For an integer `q>=3`, let `G_q` be the parallel composition of these branches:

1. a path of two edges; and
2. a series chain of four stages, each stage consisting of `q` parallel edges.

This is a two-terminal series--parallel multigraph with `2+4q` helper edges.  A `q`-edge parallel
bundle has success polynomial

```text
B_q(z) = (1+z)^q - 1.
```

Using (1)--(2), the whole graph has

```text
A_(G_q)(z) = z^2(1+z)^(4q) + (1+2z) B_q(z)^4.                            (3)
```

Since `B_q(z)^4` starts with `q^4 z^4`, (3) gives

```text
a_2 = 1,
a_3 = 4q,
a_4 = binom(4q,2) + q^4.
```

Therefore the LC inequality at index three fails exactly when

```text
a_2 a_4 - a_3^2
  = q^4 - 8q^2 - 2q
  = q(q^3 - 8q - 2) > 0.                                                  (4)
```

The last expression is positive at `q=3` and strictly increasing thereafter.  Thus every `q>=3`
is a counterexample.

The smallest member, `q=3`, has 14 helper edges and profile

```text
(0, 0, 1, 12, 147, 706, 1737, 2628, 2679, 1926, 993, 364, 91, 14, 1).
```

Already at index three,

```text
12^2 = 144 < 147 = 1 * 147.
```

Adding the target edge `x` produces a 15-element regular pointed matroid, so this directly falsifies
the conjecture retained by C245.  Parallel helper edges are load-bearing: C245's complete
loops/parallels sweep ended at total ground size nine, while its 15-element sweep was simple.

## Exhaustive boundary and independent replay

The certificate recursively enumerates every coefficient profile generated from one edge by
series and parallel composition.  It quotients networks by the pair `(edge count, A_G)`, which is
coarser than graph isomorphism but exact for this search: (1)--(2) show that all future compositions
depend only on that pair.  Thus retaining one expression per profile loses no possible coefficient
counterexample.

The exact profile counts are:

| helper edges | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 |
|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| distinct profiles | 1 | 2 | 4 | 10 | 24 | 64 | 174 | 496 | 1,444 | 4,306 | 13,068 | 40,302 | 125,806 | 396,758 |

All profiles through 13 edges pass LC.  At 14 edges exactly one distinct profile fails, the `q=3`
profile above.  Separately, the certificate builds the explicit multigraph and checks all `2^14`
edge subsets by graph reachability; this reproduces the recurrence-derived profile exactly.

This establishes minimality by helper-edge count among TTSP coefficient profiles.  It does not
claim minimality among arbitrary graphic pointed matroids or among simple two-terminal graphs.

## Literature boundary

Brown--DeGagne use exactly the size-graded `s--t` pathset coefficients `N_i` above in their study of
two-terminal reliability roots ([DOI 10.1002/net.22004](https://doi.org/10.1002/net.22004)).
Brown--Colbourn's classic log-concavity paper studies all-terminal reliability and related matroidal
sequences, rather than this pointed `s--t` pathset profile
([DOI 10.1006/aama.1994.1004](https://doi.org/10.1006/aama.1994.1004)).  The series law uses the
classical preservation of log-concavity under convolution; a modern source and extension is
Johnson--Goldschmidt ([DOI 10.1051/ps:2006008](https://doi.org/10.1051/ps:2006008)).

The focused search found no source asserting ordinary LC for all two-terminal series--parallel
`N_i` sequences.  That is a search boundary, not a novelty certification.  The mathematical claim
needed here is independent of that boundary: (3)--(4) are an exact counterexample family.

## Reproducibility

[`2026-07-17-c254-two-terminal-reliability-log-concavity.py`](2026-07-17-c254-two-terminal-reliability-log-concavity.py)
performs the complete TTSP profile sweep through 14 edges, checks every LC inequality with integers,
constructs the explicit `q=3` graph, and independently enumerates all its edge subsets.  Its exact
output is
[`2026-07-17-c254-two-terminal-reliability-log-concavity.json`](2026-07-17-c254-two-terminal-reliability-log-concavity.json).

Run from `rust/`:

```bash
python3 ../notes/2026-07-17-c254-two-terminal-reliability-log-concavity.py
```

## Disposition

C254 passes its success gate by exact counterexample, not by census enlargement.  Delete the
representable pointed-profile LC conjecture from the live agenda.  Retain (1) as the positive series
composition island and (2)--(4) as the sharp reason parallel composition kills the proposed closure.
Do not reopen ULC or a bespoke Hodge proof.
