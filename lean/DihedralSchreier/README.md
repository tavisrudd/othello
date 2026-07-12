# DihedralSchreier formalization

This library is the checked finite-combinatorial spine of
`notes/2026-07-12-dihedral-schreier-node-kayles-submission.md`.

Formalized without `sorry`:

- `FixedDeleted.lean`: involution triples, pair-product deletion, the simple Schreier
  graph, its live vertex set, and the resulting `NodeKayles.win` position;
- `KleinFour.lean`: deletion-as-nontrivial-stabilizer, injectivity of the live orbit map,
  and completeness of each orbit under the full nonidentity generating set (the abstract
  `V₄ → K₄` core);
- `Modular.lean`: the three actions on `ZMod (2*n)`, their involution and pair-product
  identities, both deletion congruences from equation (7.2), and invariance of deletion
  under the central half-turn.

Not yet claimed as formalized:

- the projective-geometric projection/tangent bridge of Lemma 2.1;
- the quotient-path and ladder graph isomorphisms of Theorem 7.1;
- Brown et al.'s ladder, pendant-ladder, and prism Grundy evaluations;
- the finite-field orbit counts and the analytic prime-density theorem.

Validation:

```text
choom -n 1000 -- nix develop --command lake build DihedralSchreier
```
