# DihedralSchreier formalization

This library is a checked reduction layer for
`notes/2026-07-12-dihedral-schreier-node-kayles-submission.md`.

Formalized without `sorry` or `native_decide`:

- `FixedDeleted.lean`: involution triples, pair-product deletion, the simple Schreier
  graph, its live vertex set, and the resulting `NodeKayles.win` position;
- `KleinFour.lean`: deletion-as-nontrivial-stabilizer, injectivity of the live orbit map,
  and completeness of each orbit under the full nonidentity generating set (the abstract
  `V₄ → K₄` core);
- `KleinFourBridge.lean`: agreement between pair-product deletion and nontrivial-
  stabilizer deletion for a realized `V₄` triple, a checked enumeration showing that the
  three unordered products in the concrete `V₄` are exactly its nonidentity elements,
  and the resulting live-orbit injectivity bridge;
- `Modular.lean`: the three actions on `ZMod (2*n)`, their involution and pair-product
  identities, both deletion congruences from equation (7.2), and invariance of deletion
  under the central half-turn.
- `ConicCoordinates.lean`: the chord equation for `c(t)=[t²:t:1]` and the checked
  projection formula `t ↦ (bt-a)/(ct-b)` away from its pole.
- `Burnside.lean`: Proposition 11.1 and Corollary 11.2. The target `(ℕ₀, ⊕)` is
  `GrundyXor` (naturals under XOR, a 2-torsion abelian group). With `A(G)`'s additive
  group modelled as `FreeAbelianGroup ι` (free on the transitive types, as the paper
  states) and the template table `t_K = 𝒢(R(G,K,T))`, `Φ_T = FreeAbelianGroup.lift t` is
  the unique homomorphism `A(G) → (ℕ₀, ⊕)`; it is additive under disjoint union, vanishes
  on `2·A(G)`, and descends to `A(G) ⧸ 2·A(G)` (the mod-two Burnside group `A(G) ⊗ F₂`).
  Corollary 11.2 bulk cancellation falls out. `phi_add_realized` grounds the abstract
  `⊕` in the certified component-XOR fact `NodeKayles.grundy_sum`.
- `Density.lean`: the finite-algebra core of Theorem 12.1. `candidate_coprime` proves
  `gcd(q,8n)=1` for `q = 2nh±1`; `candidate_distinct` proves the four `h mod 4` give four
  distinct residue classes mod `8n` (period `8n`); the `card_P_*`/`card_compl_*` lemmas
  encode Corollary 9.1's "exactly two of four" for each triple type; and
  `candidate_primes_infinite` / `P_and_N_primes_infinite` deliver Dirichlet's theorem
  (mathlib) for each class, so P and N positions each occur over infinitely many primes.

This certifies the reduction plumbing and the Burnside-homomorphism reformulation, but not
the paper's remaining Grundy-value or orbit-count conclusions, nor the *quantitative*
prime-density value. In particular, not yet claimed as formalized:

- the projective-geometric projection/tangent bridge of Lemma 2.1;
- the quotient-path and ladder graph isomorphisms of Theorem 7.2;
- Brown et al.'s ladder, pendant-ladder, and prism Grundy evaluations;
- the `V₄` split-count formula and every template nimber;
- the finite-field orbit counts;
- the numerical density value `1/2` of Theorem 12.1: mathlib provides Dirichlet's theorem
  (infinitude in each reduced residue class) but not the equidistribution / `1/φ`-density
  statement, so only the reachable infinitude form of Theorem 12.1 is certified here.

Validation:

```text
choom -n 1000 -- nix develop --command lake build DihedralSchreier
```

Audited headline declarations depend only on `[propext, Classical.choice, Quot.sound]`.
