# C247 tract/foundation audit

**Lane:** `rp-next`
**Status:** COMPLETE — exact dictionary, positioning-only kill. Tracts and foundations organize the
support/coefficient/valuation layers cleanly, but on the cubic and harmonic flagships they yield no
repair capability or preservation theorem beyond what follows automatically from the underlying
matroid or what C217 already proved by elementary gauge theory.

## Decision

Do not allocate a tract/foundation unification paper. Use the language briefly for positioning:

```text
field circuit system  --push forward to Krasner-->  support matroid / repair hypergraph
        |
        +--quotient by circuit and coordinate scaling--> foundation point
        |
        +--non-Archimedean valuation--> valuated matroid
```

The first arrow forgets exactly the coefficient information that complete scalar repair ports
forget. The middle quotient is the abstract home of the **complete** realizable circuit-incidence
gauge class; C217's invariants on a selected circuit collection are restrictions of this data. The
last arrow concerns coefficient valuations, not helper cardinalities, erasure weights,
Horn arrival times, or separator support costs. In particular, it is trivial on the finite fields
used by both flagships.

## Exact dictionary

Let `F` be a tract and `mathcal M` a weak or strong `F`-matroid on `E`. Its projective
`F`-circuits are coefficient vectors modulo a nonzero circuit scalar. Their supports are in
bijection with the circuits of an ordinary underlying matroid `M`. Equivalently, `M` is the
push-forward of `mathcal M` along the unique tract morphism

```text
F -> K,       0 |-> 0,       F^x |-> 1,
```

where `K` is the Krasner hyperfield. This is precisely the passage from a coefficient-labelled
repair system to its complete support port.

For a field `k` and fixed underlying matroid `M`, the coefficient dictionary is also exact:

> **Foundation/gauge dictionary.** The realizable complete circuit-coefficient systems of `M`,
> modulo an independent nonzero scalar on every circuit and an independent nonzero scalar on every
> coordinate, are naturally in bijection with
> `Hom(F_M,k)`, where `F_M` is the foundation of `M`.

Indeed, projective circuit vectors determine the `k`-matroid representation, circuit scalars remove
the choice of representative, and coordinate scalars are exactly rescaling equivalence. The
foundation represents the functor of rescaling classes. Thus C217's spanning-tree normalization
gives elementary coordinates on the restriction of a realizable foundation point to the selected
circuit-incidence graph; this restriction need not determine the full point. Its cycle holonomies
are redundant until the Plücker/foundation relations are imposed.

On a non-Archimedean field, pushing forward along a valuation `k -> T` sends circuit coefficients
to a valuated matroid. This is a genuine third layer, but it does **not** identify the operational
weights currently used in repair ports. Those are external weights on helpers or causal costs on
rules. Moreover every valuation of a finite field into an ordered abelian value group is trivial:
the finite multiplicative group has torsion, while an ordered abelian group is torsion-free.

## Automatic repair-shadow theorem

For a target `e` and radius `r`, write

```text
R_r(M,e) = { C - {e} : C is a circuit of M, e in C, |C|-1 <= r }.
```

> **Repair-shadow preservation.** If `f : F -> F'` is a tract morphism, then
> `R_r(underlying(mathcal M),e) = R_r(underlying(f_* mathcal M),e)` for every target and radius.

A tract morphism sends units to units, so it preserves the support of every circuit vector; the
push-forward circuit theorem then gives the same projective circuit supports. Consequently it also
preserves every invariant already defined solely from these supports: complete and truncated repair
ports, bounded sequential Horn closure and stopping cores, repair-support reliability/EXIT
polynomials, blocker and service-region hypergraphs, and C241's support-cost profiles when the
external helper costs are held fixed.

This theorem is useful vocabulary but fails C247's promotion gate: it is an immediate repair
specialization of standard tract functoriality, not a new preservation mechanism.

## Flagship audit

### Completed cubic--axis family

The Krasner shadow is exactly the circuit system used in C236. Hence the theorem that sequential
radius-three closure equals full matroid closure is constant across every coefficient realization
of that fixed support matroid. Foundations add no strength to its proof.

The coefficient lift does recover C217 exactly. On an axis restriction with support matroid
`U(2,4)`, Baker--Lorscheid identify rescaling classes over `k` with `k - {0,1}`. C217's four-cycle
holonomy is the corresponding projective cross-ratio. Its checked `GF(9)` values `2` and `3` give
different foundation points (even different anharmonic orbits after allowing point permutations),
although their radius-two repair supports are identical. This is a strict **coefficient-label**
distinction, not a new repair-capability distinction, and C217 already proves and replicates it.

### Quartic--nucleus harmonic family

The complete small-circuit list `{N} union B`, with `B` harmonic, is again the Krasner shadow. The
nucleus gate, harmonic Steiner system, inert rank-five seed, full-span recovery, reliability rows,
and service-region bottleneck all depend on those supports. They therefore remain unchanged across
rescaling classes of the same represented matroid.

The foundation can ask over which pastures this fixed support matroid is representable and can
parameterize its coefficient realizations. It does not derive the characteristic-three nucleus
classification while the ground set itself varies with `q`, and no audited harmonic result
distinguishes two support-identical foundation points operationally. Its coefficient valuation is
again trivial over `GF(3^h)`.

## Literature boundary

The load-bearing sources were read in full from the persistent cache:

- Matthew Baker and Nathan Bowler, *Matroids over partial hyperstructures*,
  [arXiv:1709.09707](https://arxiv.org/abs/1709.09707), cache SHA-256
  `1cfb6425b66d0c3f0ea5480c77c8263db937a68b2c86f60bf33640d2c10153e0`. Definition 3.8 makes
  ordinary circuits the supports of tract circuits; Lemma 3.39 and Corollary 3.41 give push-forward
  functoriality; the introduction identifies valuation push-forward with tropicalization.
- Matthew Baker and Oliver Lorscheid, *Foundations of matroids I: Matroids without large uniform
  minors*, [arXiv:2008.00014](https://arxiv.org/abs/2008.00014), cache SHA-256
  `c949c0a06dd217ef283140adfd798392c87c83a8037a536db260766deb706da7`. Theorem 4.2 represents
  rescaling classes by `Hom(F_M,-)`; universal cross-ratios generate `F_M`; Corollary 4.13 gives the
  exact `U(2,4)` field parameterization used above.

These sources already own the generic support/coefficient/valuation unification. The repair-port
specialization is accurate positioning, but a separate novelty claim would be renaming.

## Verification and disposition

The existing independent flagship checks were replayed successfully:

- C217: 240 small circuits, connected incidence graph, all 581 fundamental holonomies gauge
  invariant, and all 3,024 ordered axis quadruples matched the cross-ratio formula;
- C236: the cubic closure theorem replayed at q=3 and q=9, while the harmonic witness remained
  radius-four inert with closure size 5 and full matroid span size 11.

C247 therefore closes at its kill gate. The exact dictionary should be cited in a background or
positioning paragraph, with the automatic repair-shadow proposition included only if useful for
exposition. Do not promote foundation computation, a tract-valued port API, or a valuation layer
without a future operational observable that distinguishes foundation points or genuinely uses
nontrivial coefficient valuations.
