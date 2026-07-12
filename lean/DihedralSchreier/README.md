# DihedralSchreier formalization

This library is a checked reduction layer for
`notes/2026-07-12-dihedral-schreier-node-kayles-submission.md`.

Formalized without `sorry`:

- `FixedDeleted.lean`: involution triples, pair-product deletion, the simple Schreier
  graph, its live vertex set, and the resulting `NodeKayles.win` position;
- `KleinFour.lean`: deletion-as-nontrivial-stabilizer, injectivity of the live orbit map,
  and completeness of each orbit under the full nonidentity generating set (the abstract
  `V₄ → K₄` core);
- `KleinFourBridge.lean`: agreement between pair-product deletion and nontrivial-
  stabilizer deletion for a realized `V₄` triple, and the resulting live-orbit
  injectivity bridge;
- `Modular.lean`: the three actions on `ZMod (2*n)`, their involution and pair-product
  identities, both deletion congruences from equation (7.2), and invariance of deletion
  under the central half-turn.
- `ConicCoordinates.lean`: the chord equation for `c(t)=[t²:t:1]` and the checked
  projection formula `t ↦ (bt-a)/(ct-b)` away from its pole.

This certifies the reduction plumbing, not the paper's Grundy-value, orbit-count, or
density conclusions. In particular, not yet claimed as formalized:

- the projective-geometric projection/tangent bridge of Lemma 2.1;
- the quotient-path and ladder graph isomorphisms of Theorem 7.2;
- Brown et al.'s ladder, pendant-ladder, and prism Grundy evaluations;
- the `V₄` split-count formula and every template nimber;
- the finite-field orbit counts and the analytic prime-density theorem.

Validation:

```text
choom -n 1000 -- nix develop --command lake build DihedralSchreier
```
