# C214: exact weighted-functional transfer

**Date:** 2026-07-16
**Lane:** `repaircodes`
**Status:** PAPER-PROMOTED; weighted implication kernel-checked; closed-form converse, Singer
example, and enumerator identity have manuscript proofs with explicit ledger boundaries

## Verdict

C214 passes the bounded manuscript-promotion gate, after one substantive correction to the
roadmap formula.

- The exact global obstruction is the minimum weight of a concatenated dual word meeting at least
  two blocks. In full generality it has separate zero-functional, singleton-functional, and
  multisupport-functional terms.
- The exact nonembedded-witness threshold is always
  `min(2*d(I^perp), d_lambda(O))`. If every outer coordinate projection is onto the symbol space,
  singleton functional-dual words are impossible and this threshold equals the multiblock one.
- The completed `[20,4,9]_9` seed admits a natural strict example: an
  `[5,4,2]_{6561}` generalized single-parity-check outer code has functional support distance five
  but weighted functional distance at least six. Hence radius-four transfer is exact although the
  old distance-six support gate fails.
- The fiber-enumerator identity is correct but is structural prior art, not a novelty locus.
- Nonsymmetric AG outer families give a Pareto continuum around the self-dual point, but do not
  strictly dominate it. The present paper keeps the certified self-dual asymptotic headline; a
  general optimized achievable region belongs to C216.

## Exact obstruction

Let `Phi_I(w)(v)=<w,e(v)>`, so `ker(Phi_I)=I^perp`, and let

```text
lambda_I(beta) = min { wt(w) : Phi_I(w)=beta },
Lambda_I(beta_tuple) = sum_j lambda_I(beta_j).
```

Write `delta_mb(O,I)` for the minimum weight of a word in `(O o I)^perp` meeting at least two
inner blocks. With infinity for an empty minimum and at least two available blocks,

```text
delta_mb(O,I) = min {
  2*d(I^perp),
  min_{beta != 0, |supp beta|=1} (d(I^perp) + Lambda_I(beta)),
  min_{|supp beta|>=2} Lambda_I(beta)
}.
```

The cases are exhaustive:

1. `beta=0`: two nonzero zero-fiber blocks cost exactly `2*d(I^perp)`;
2. `|supp beta|=1`: the functional representative occupies one block and a nonzero inner-dual
   word is required in a second block;
3. `|supp beta|>=2`: independently minimizing each fiber already produces a multiblock word.

Every dual word of weight at most `r+1` meets at most one block if and only if
`r+1 < delta_mb(O,I)`. This word-level confinement is not by itself equivalent to repair-hypergraph
equality: a one-block word can induce a nonzero functional and need not be inner-dual, and distinct
witnesses can share one support.

Let `delta_emb(O,I)` be the minimum weight of a dual word that is not the zero extension of one
inner-dual block. Then

```text
delta_emb(O,I) = min(2*d(I^perp), d_lambda(O)).
```

The strict inequality `r+1 < delta_emb(O,I)` is equivalent to confinement of every bounded dual
word to one embedded inner-dual block and implies complete repair-hypergraph equality. No converse
from equality of support sets is claimed.

If each projection `O -> V` is onto, a functional-dual tuple supported at one coordinate must
vanish, because its sole functional annihilates all of `V`. Therefore

```text
delta_mb(O,I) = delta_emb(O,I) = min(2*d(I^perp), d_lambda(O)),
d_lambda(O) = min_{0 != beta in O^(perp_fun)} Lambda_I(beta).
```

The original roadmap omitted the singleton caveat. It was corrected rather than hidden inside a
nonstandard definition of `d_lambda`.

For a target `(j,x)`, minimize over dual words with `w_j(x) != 0` that are not zero extensions of
an inner-dual word in block `j`. This gives an exact target-conditioned bad-witness threshold and
can be sharper than the global minimum. Falling below it implies literal hypergraph equality at
that coordinate; the reverse implication can fail when an embedded and a nonembedded witness have
the same support.

## Strict natural example

Take the completed q=9 seed `I`, with parameters `[20,4,9]_9` and `d(I^perp)=3`, and identify its
four-dimensional message space with `L=GF(9^4)`. The twenty coordinate evaluations of an encoder
`e:L -> I` give a set `S` of twenty distinct projective functionals in
`PG(L^*) = PG(3,9)`.

The Singer group `L^*/GF(9)^*` acts regularly on the 820 projective points. Hence

```text
sum_g |S intersect gS| = |S|^2 = 400 < 820.
```

Some multiplier `a` therefore satisfies `S intersect aS = empty`. Define

```text
O_a = { (u1,...,u5) in L^5 : u1 + a*u2 + u3 + u4 + u5 = 0 }.
```

This is an `L`-linear generalized single-parity-check MDS code `[5,4,2]_{6561}`, monomially
equivalent to the ordinary SPC code. Under the trace pairing its nonzero functional-dual tuples
are indexed by `c != 0` and have coefficient classes

```text
([c], [ca], [c], [c], [c]).
```

A functional has inner realization cost one exactly when its projective class lies in `S`.
Disjointness of `S` and `aS` forces one of the first two costs to be at least two, while every
other nonzero cost is at least one. Thus `d_lambda(O_a)>=6`, even though every nonzero functional
dual word has support exactly five. Since `2*d(I^perp)=6`, the exact multiblock threshold is six
and radius-four transfer follows from `5<6`.

This example is finite and coefficient-selected, but it is not a boundary toy: the inner code is
the paper's flagship completed geometry and the outer code is a classical MDS SPC code. No claim
is made that the MDS code or Singer action is new.

## Fiber enumerator

The block-functional map partitions the concatenated dual into products of fibers:

```text
W_(O o I)^perp(z)
  = sum_{beta in O^(perp_fun)} product_j W_beta_j(z),
W_gamma(z)
  = sum_{w : Phi_I(w)=gamma} z^wt(w).
```

Replacing the one variable by coordinate variables gives the full support-refined identity. It
therefore determines bounded support multiplicities, pointed target data, and projective
functional fibers when scalar symmetry is quotiented explicitly. The minimum exponent in each
fiber is `lambda_I`.

This identity is not promoted as new. Chen--Ling--Xing give the classical direct-sum description
of a concatenated dual in [IEEE TIT 47 (2001), Theorem 2.3](https://doi.org/10.1109/18.930941),
recalled explicitly in [IEEE TIT 51 (2005), Theorem 2.1](https://doi.org/10.1109/TIT.2005.851760).
The latter primary source was read from the persistent cache at SHA-256
`e566d78ab3a82d08ea4fc0441b98a85677dda41ee727a91b365c13b907733f0f`.
Coset weight distributions are classical, and the displayed identity is their blockwise product
over the outer-dual index set. The candidate contribution is the use of the exact witness threshold
as a sufficient complete-incidence transfer gate.

## Asymptotic outer-family disposition

The constant repair gate does not require self-duality. On an optimal tower over `GF(6561)`, the
standard AG evaluation-code calculation gives outer points with

```text
R_outer + delta_outer >= 79/80,
delta_outer_dual > 0
```

through the interior range `1/80 < R_outer < 79/80`. Concatenation with the completed seed gives
the Pareto line

```text
R_concat = R_outer/5,
delta_concat >= (9/20)*(79/80 - R_outer).
```

The current self-dual choice is the point `R_outer=1/2`, hence
`(R_concat,delta_concat)=(1/10,351/1600)` in the strict-limit convention. Moving left improves
distance and loses rate; moving right improves rate and loses distance. Thus nonsymmetric AG
codes improve either coordinate but do not Pareto-dominate the self-dual point. Their dual
distance is eventually linear, so this continuum already satisfies the old constant support gate;
it is not a payoff specific to weighted transfer.

Accordingly the manuscript retains the self-dual family as its compact certified asymptotic
headline. A formal general AG frontier, random-code comparison, or optimization over inner ports
would change the paper's dependency and theorem shape; C216 owns that stand-alone realization
program.

## Formal and validation boundary

`lean/RepairCodes/WeightedTransfer.lean` adds:

- `HasWeightedFunctionalDualDistanceAtLeast`;
- monotonicity and implication from ordinary functional support distance;
- `concatenatedDualWord_transfer_weighted`; and
- `repairHypergraph_concatenatedCode_eq_embed_weighted`.

The formal predicate quantifies over every representative of every nonzero functional-dual fiber,
so it is equivalent to the `d_lambda` lower bound over finite fields without relying on an opaque
minimum choice. Focused guarded elaboration passes. The exact three-case converse, Singer average,
and polynomial enumerator identity are presently manuscript proofs and are marked `MANUSCRIPT` in
the proof ledger; the paper does not misreport them as Lean declarations.

## Publication disposition

The manuscript transfer section is recentered on the exact weighted obstruction. The previous
support-distance theorem remains as a clean corollary, the strict Singer/SPC example demonstrates
real additional reach, and the enumerator is included with an explicit prior-art boundary. The
asymptotic headline remains unchanged. Broader weighted-dual algorithms, optimized outer regions,
and general port realization pass to the `repairports` lane beginning at C215/C216.
