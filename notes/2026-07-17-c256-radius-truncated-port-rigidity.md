# C256 radius-truncated port rigidity

**Lane:** `rp-next`
**Status:** COMPLETE — theorem gate passed. Rank bounds give a checkable truncated-reconstruction
criterion, and the Fano/non-Fano pair gives a reciprocal characteristic-sensitive repeated-row
gap that is invisible at radius two and appears at radius three. This is a compact local
proposition, not an asymptotic MSP separation.

## Decision

Retain the rank-cutoff proposition and the seven-point transition as a sharp bounded companion to
C248. At radius two, the Fano and non-Fano ports collapse to the same three-pair access function,
which has one row per helper over every field. At radius three, the ports become full: the Fano
version needs at least seven rows in odd characteristic and the non-Fano version needs at least
seven rows in characteristic two, versus six native rows.

Do not promote an atlas paper or revive C248's asymptotic lifting route. The separation is exact and
field-sensitive but additive-one on a fixed seven-element object. The exhaustive atlas explains
where the transition occurs; it supplies no growing lower-bound object.

## Radius-cutoff reconstruction theorem

For a represented matroid `M` with target `x`, write

```text
P_r(M,x) = min {C-{x} : C is a circuit of M, x in C, |C|-1 <= r}.
```

Its upward closure is the radius-`r` repair function. The full port is `P(M,x)` with no cutoff.

> **Proposition (rank-cutoff port rigidity).** Let `M` be a connected rank-`rho` matroid on
> `{x} union V`. If `r >= rho`, then `P_r(M,x)=P(M,x)`, so `P_r(M,x)` uniquely determines `M`.
> If `M` is representable over `K` but not over `F`, and `n=|V|`, then the radius-`r` access
> function has MSP size exactly `n` over `K` and at least `n+1` over `F`.

Every circuit `C` has `|C|-1=rank(C)<=rho`, proving that the cutoff loses nothing. Lehman's port
reconstruction theorem then makes the connected matroid unique. Connectedness makes every helper
label relevant, so any MSP needs at least one row per label. The native scalar representation has
exactly `n` rows. If an `F`-MSP also had `n` rows, it would have exactly one row per label; adjoining
the target vector would give an `F`-represented connected matroid with the same full port and hence
would represent `M`, a contradiction.

The slightly sharper certificate is also useful: it is enough to verify directly that every
target circuit has at most `r+1` elements. Rank at most `r` is a representation-independent,
easy-to-check sufficient condition, not a necessary one.

## The seven-point radius transition

Use six helper labels `0,...,5`. Both the pointed Fano and pointed non-Fano representations have

```text
P_2 = {{0,1}, {2,3}, {4,5}}.
```

This truncated port is field-neutral. Over any field take target `e_0` and, for `i=1,2,3`, give
the corresponding pair the columns `e_i` and `e_0-e_i`. A set spans `e_0` exactly when it contains
one complete pair. Thus `P_2` has a six-row, one-row-per-label MSP over `GF(2)`, `GF(3)`, and
`GF(4)` (indeed over every field).

At radius three, rank-cutoff reconstruction applies because both matroids have rank three.

- The Fano full port has the three pairs and four triple minterms. It is representable exactly in
  characteristic two. Its MSP size is six in characteristic two and at least seven in odd
  characteristic.
- The non-Fano full port has the same three pairs and five triple minterms. It is representable
  exactly in odd characteristic. Its MSP size is six in odd characteristic and at least seven in
  characteristic two.

Therefore the support-level radius-two functions are identical and admit ideal scalar
implementations on both sides, while the radius-three functions split and force a repeated label
over the wrong characteristic. This is the requested strict operational gap: the extra local
circuit layer changes minimum row cost even though the cheaper repair layer does not.

No exact claim is made that the wrong-characteristic optimum is seven; the proved statement is the
strict lower bound `>=7`, which is enough to force repetition.

## Exact atlas

The verifier enumerates every connected pointed restriction of `PG(2,q)` having one fixed target
and six distinct helpers for `q=2,3,4`. Projective transitivity makes fixing the target exhaustive
for this scope. It computes every target circuit, canonicalizes the radius-two, radius-three,
radius-four, and full clutters under all helper permutations, and groups full pointed-matroid types
by truncated-port type.

| field | labeled restrictions | full pointed types | `P_2` types | ambiguous `P_2` types | largest `P_2` fiber | `P_3=P_4=full` |
| --- | ---: | ---: | ---: | ---: | ---: | --- |
| `GF(2)` | 1 | 1 | 1 | 0 | 1 | yes |
| `GF(3)` | 924 | 9 | 5 | 3 | 3 | yes |
| `GF(4)` | 38,760 | 25 | 8 | 5 | 6 | yes |

The radius-two atlas is genuinely nonrigid: over `GF(4)`, one truncated type can hide six distinct
full pointed matroids. Radius three removes every collision because all objects in the atlas have
rank three. The census independently finds the Fano full port over `GF(2)` and `GF(4)` but not
`GF(3)`, and the non-Fano full port over `GF(3)` but neither characteristic-two field.

The scope is deliberately finite and exact: simple rank-three representations on seven elements.
It does not enumerate parallel rows, larger ranks, or arbitrary MSPs. The row lower bound does not
depend on that atlas limitation; it follows from reconstruction and the one-row barrier.

The executable verifier and machine-readable certificate are
[`2026-07-17-c256-radius-truncated-port-rigidity.py`](2026-07-17-c256-radius-truncated-port-rigidity.py)
and
[`2026-07-17-c256-radius-truncated-port-rigidity.json`](2026-07-17-c256-radius-truncated-port-rigidity.json).

## Literature boundary

The full-port reconstruction input is classical: Martí-Farré, Padró, and Vázquez restate Lehman's
theorem that a connected matroid is uniquely determined by any port
([EJC 15 (2008), N27](https://www.combinatorics.org/ojs/index.php/eljc/article/view/v15i1n27),
cache SHA-256 `59138f289babf3a327410ee98e36c1848f4f4c540c3e907e688441326f346ca2`). The
rank-cutoff proposition is the immediate bounded-radius condition under which that full theorem
becomes available; it is not a new reconstruction theory for arbitrary truncated ports.

Bounded-size minimal qualified sets already form a mature secret-sharing subject. Kim, Kwon, and
Lee study linear schemes for constant-uniform hypergraph access structures
([arXiv:2106.14833](https://arxiv.org/abs/2106.14833)); their construction problem does not identify
the nested matroid-port radius at which a connected realization becomes rigid. Likewise,
Beimel--Weinreb's field separations for MSPs are superpolynomial and use growing objects
([SIAM J. Comput. 36 (2006)](https://doi.org/10.1137/S0097539704444038)). The present seven-point
gap is a local mechanism and should not be advertised as competing with those complexity results.

A focused search found no prior theorem phrased as this radius-filtered Fano/non-Fano transition.
That is only a boundary assessment, not a priority claim. The safe contribution is the compact
repair-port specialization, exact certificate, and operational interpretation.

## Disposition

C256 passes both of its alternative gates:

1. `rank(M)<=r` is a checkable sufficient truncated-reconstruction criterion; and
2. the Fano/non-Fano transition gives a strict field-sensitive repeated-row gap.

Use the result as a short proposition/example after C248's full-port one-row barrier. Do not spin
out a separate atlas, secret-sharing, or asymptotic field-separation paper.
