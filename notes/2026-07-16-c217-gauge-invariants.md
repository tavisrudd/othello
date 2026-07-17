# C217 gauge invariants of overlapping repair equations

**Lane:** `repairports`
**Status:** COMPLETE. The bounded scout finds a complete circuit-incidence gauge fingerprint,
recovers projective cross-ratios on the seed's axis, and gives a strict support-identical
monomial-inequivalence example.

## Result

Let `C` range over a chosen collection of circuit supports and let `x in C`. Fix a full-support
relation

```text
sum_{x in C} a(C,x) v_x = 0.
```

The incidence coefficient changes under circuit normalization and diagonal coordinate rescaling as

```text
a(C,x) -> rho_C lambda_x^(-1) a(C,x).
```

Form the bipartite circuit--coordinate incidence graph. For a closed chain

```text
C_1, x_1, C_2, x_2, ..., C_k, x_k, C_1
```

define its multiplicative holonomy by

```text
H = product_i a(C_i,x_i) / a(C_{i+1},x_i),
```

with cyclic indices. Every `lambda_x` cancels inside one ratio and every `rho_C` cancels around the
cycle. Thus `H` survives all permitted coefficient gauges.

This family is complete, not merely a source of examples:

> **Circuit-incidence gauge theorem.** On each connected component of the incidence graph, choose a
> spanning tree. The holonomies of the fundamental cycles indexed by the non-tree edges determine
> the coefficient labeling up to independent circuit scalars and diagonal coordinate scalars. Two
> nonzero incidence labelings are gauge-equivalent if and only if these fundamental holonomies
> agree.

To prove this, normalize the coefficient on every tree edge to one, starting at a root and solving
successively for the gauge at the newly reached vertex. The normalized value on a chord is exactly
the holonomy of its fundamental cycle. Hence equality of the chord values extends the tree gauges
to every edge; necessity is the cancellation above. This is the elementary multiplicative
cohomology of the incidence graph, stated here without a novelty claim.

Operationally, this gives a linear-time gauge-equivalence test after the circuit supports have been
aligned: normalize one spanning forest and compare one field element per chord. A mismatch proves
that no rescaling of stored coordinates and no independent renormalization of repair equations can
make the two coefficient-labelled repair systems identical.

## Axis four-cycles are cross-ratios

Write the finite axis points as `A(t)=(0:1:t:0)`. For distinct `a,b,c`, their circuit relation is

```text
(b-c) A(a) + (c-a) A(b) + (a-b) A(c) = 0.
```

The circuits `C={a,b,c}` and `D={a,b,d}` share `a,b`. Their four-cycle holonomy is

```text
H(C,a,D,b)
  = [a(C,a) a(D,b)] / [a(D,a) a(C,b)]
  = [(b-c)(d-a)] / [(c-a)(b-d)].
```

The last expression is a projective cross-ratio convention. Therefore overlapping scalar repair
equations recover the projective moduli that the support hypergraph forgets.

This has a strict consequence inside the completed field-nine seed. In the repository encoding
`GF(9)=GF(3)[z]/(z^2+1)`, the ordered quadruples `(0,1,3,4)` and `(0,1,2,8)` have holonomies `2` and
`3`. Under coordinate permutations a cross-ratio may undergo the six anharmonic transforms. In
characteristic three the orbit of `2=-1` is the singleton `{2}`, whereas the orbit of `3` is
`{3,4,5,6,7,8}`. Consequently the two four-point axis restrictions are not projectively equivalent
even after permuting their points. Their row codes are therefore not monomially equivalent, while
both have the same support matroid `U(2,4)` and the same complete radius-two repair supports. The
holonomy strictly refines the support port.

The same conclusion transfers covariantly through C216: an embedded inner circuit relation remains
a dual relation in every concatenated block, so all of its circuit-incidence holonomies are copied
unchanged. Monomial changes of block coordinates alter only the gauge. Thus the positive-density
port replication theorem also replicates this coefficient fingerprint whenever coefficient labels
are retained.

## Completed q=9 replay

[`2026-07-16-c217-gauge-invariant-verifier.py`](2026-07-16-c217-gauge-invariant-verifier.py)
reuses the independent C203 circuit enumerator and nullspace solver, then performs a new gauge
replay. Its certificate is
[`2026-07-16-c217-gauge-invariant-verifier.json`](2026-07-16-c217-gauge-invariant-verifier.json).

For all 240 size-three/four circuits on 20 completed-seed coordinates, the incidence graph is
connected with 840 edges. Its cycle rank is

```text
840 - (240 + 20) + 1 = 581.
```

The verifier constructs all 581 fundamental holonomies, applies a nonconstant nonzero scale to
every circuit and every coordinate, and confirms the entire fingerprint is unchanged. On the
finite axis it checks all `9*8*7*6 = 3024` ordered distinct quadruples against the displayed
cross-ratio formula. Every value in `GF(9) \ {0,1}` occurs exactly 432 times.

## Disposition

C217 meets its promotion gate. The invariant is nontrivial, has a complete gauge-classification
theorem, recovers classical projective cross-ratios, distinguishes support-identical monomially
inequivalent repair ports, and is inherited under the C216 block replication. A larger census or a
Tutte-foundation formalization is unnecessary for this bounded scout.

The next lane task is C218's bounded rational-normal-curve nucleus scout.
