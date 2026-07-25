# C615: projective automorphism group packaging

**Lane:** `ame-lu`

**Status:** complete

## Goal

Upgrade the fixed-party and party-permuted product-unitary automorphism
carriers from quotient types and topological spaces to explicit groups and
topological groups. Identify independent scalar phases as normal subgroups,
form the quotient groups, package projectivization and the finite signature
detectors as structured maps, and retain the established finiteness and
identity-component conclusions.

## Delivered

`RelativeConicArcs.AMELU.ProductUnitaryAutomorphismGroup` supplies the
complete group layer.

- Tensor-product local actions compose coordinatewise. The fixed-party
  automorphism carrier is a group under coordinatewise matrix multiplication,
  with conjugate transpose as inverse.
- Displayed party permutations use the proved semidirect-product law
  \[
    (\sigma,U)(\tau,V)
      =(\sigma\tau,\ i\mapsto U_iV_{\sigma^{-1}i}).
  \]
  Its inverse and action-composition laws are proved with the manuscript's
  existing party-action orientation.
- Independent unit-modulus scalar matrices form a central subgroup of the
  fixed-party group and a normal subgroup of the party-permuted group. The
  latter conjugation reindexes the phase tuple by the party permutation.
- Both scalar quotients are explicit quotient groups. Their quotient
  projections
  `genericProductUnitaryContinuousProjectivization` and
  `genericPermutedProductUnitaryContinuousProjectivization` are continuous
  group homomorphisms.
- The inherited matrix topologies make both automorphism groups topological
  groups. The finite exact Clifford-signature detectors are packaged as
  continuous maps.
- Surjections from C612's coordinatewise scalar quotients transfer its
  finiteness results to
  `projectiveGenericProductUnitaryAutomorphismGroup_finite` and
  `projectiveGenericPermutedProductUnitaryAutomorphismGroup_finite`.
  C612's identity-component theorems remain statements about the same
  topological carriers and therefore apply unchanged.

The aggregate gate imports the new module. Its axiom audit names both new
finiteness terminals and both continuous projectivization homomorphisms.
The theorem map and formal-statement adequacy table now cite the quotient
group declarations rather than the earlier carrier-only quotients.

## Validation

Warning-free guarded elaboration passed for
`RelativeConicArcs.AMELU.ProductUnitaryAutomorphismGroup`.

The measured single-thread queue
`/home/tavis/.cache/othello-lean-build/run-20260725-203614-489c728f`
built the group module, `RelativeConicArcs.Gates.AMELUAggregate`, and
`RelativeConicArcs.Gates.AMELUAggregateAxioms`. The final trace-only
aggregate gate passed. The four new audited terminals depend only on
`propext`, `Classical.choice`, and `Quot.sound`.

## Closeout pass

The explicit extra-juice and Terence-Tao-style closeout checked whether the
group law exposed an additional structural statement at negligible cost.
It did: the fixed-party phase torus is central, whereas adjoining party
permutations makes it generally noncentral but still normal, with conjugation
given exactly by coordinate reindexing. Both facts are formalized.

The pass also checked whether new finite-order calculations or a
semidirect-product classification of the projective quotient followed for
free. They do not: general MDS codes supply no canonical finite image beyond
the faithful projective Clifford coordinates. Exact orders and the GRS
semidirect product require the encoder and logical-action inputs owned by
C613.

## Mystery ledger

- **Settled:** the party-moving multiplication orientation is forced by
  `genericPermuteState`; the right local family is reindexed by
  \(\sigma^{-1}\), and the formal action-composition theorem verifies it.
- **Settled:** the scalar subgroup changes from central to merely normal
  after party permutations because conjugation permutes its coordinates.
- **Settled:** quotient-group finiteness needs no new counting theorem. A
  proved surjection from the already finite coordinatewise scalar quotient
  transfers the existing result.
- **Owned by C613:** exact projective group orders and the
  \(\mathbb F_q^2\rtimes\mathrm{SL}_2(q)\) description require the
  code-specific encoder and logical-action bridges.

No genuine mystery remains within the C615 statement.
