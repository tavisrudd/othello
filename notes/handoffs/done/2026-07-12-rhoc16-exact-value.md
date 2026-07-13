# Handoff: exact value of rho_C(16)

**Date:** 2026-07-12
**Status:** COMPLETE
**Task:** C101 [REPORTED 2026-07-12]

## Outcome

The finite gap is closed:

```text
rho_C(16) = 9.
```

There are no eight-point arcs in `PG(2,16)` complete outside a nonsingular conic, and the
previously checked nine-point example supplies the matching upper bound. Session history,
negative controls, and the post-formalization extension queue are in
[`2026-07-12-rhoc16-exact-value-archive.md`](2026-07-12-rhoc16-exact-value-archive.md).

## Landed proof map

| Result | Artifact | Status |
|---|---|---|
| exact projective class enumeration through size eight | `papers/arcs_complete_outside_conic/search_rhoc16.cpp` | reproducible generator |
| semantic finite-field, projective-map, augmentation, and rejection kernel | `lean/RelativeConicArcs/Q16Classification.lean`, `Q16StepKernel.lean` | Lean-proved |
| checked transition books and leaf certificates | `lean/RelativeConicArcs/Q16Certificate{Levels,Data}*`, `Q16LeafData*` | Lean-proved |
| arbitrary eight-cap reduction through retained linear projectivities | `lean/RelativeConicArcs/Q16Reduction.lean` | Lean-proved |
| normalized eight-class quadratic avoidance, including singular quadrics | `lean/RelativeConicArcs/Q16QuadraticAvoidance.lean` | Lean-proved |
| no relative-complete eight-arc over `GF(16)` | `RelativeConicArcs.no_completeOutside_GF16_card_eight` | Lean-proved |
| exact value | `RelativeConicArcs.rhoC_GF16`, `RelativeConicArcs.Examples.rhoC_GF16` | Lean-proved |

The checked class counts at sizes five through eight are `4, 61, 454, 2633`, obtained from
`182, 532, 5155, 21495` legal extensions. Of the 2633 leaves, 2630 have full quadratic evaluation
rank on their ordinarily uncovered locus. The remaining three classes (89, 90, and 2631) have a
one-dimensional quadratic kernel whose form is checked to meet the arc. The total of 2633
ordinary classes independently reproduces Al-Seraji--Al-Ogali (2018); the new computational
content is the uncovered-quadratic `2630+3` refinement and its relative-conic consequence. The
bounded literature comparison is recorded in
[`2026-07-13-rhoc16-novelty-check.md`](../../2026-07-13-rhoc16-novelty-check.md).

## Trust boundary and validation

- The generator supplies data only. Lean checks every retained projective map, complete
  augmentation book, leaf member list, secant calculation, rank rejection, and forced-hit
  rejection against semantic definitions.
- The global proof starts from an arbitrary eight-cap and an arbitrary nonsingular conic;
  normalization and conic transport use explicit invertible linear maps.
- No solver assertion, orbit label, frozen hash, or generated class label is trusted as a theorem.
- The focused generated targets and final result registry build sequentially under the repository's
  OOM-safe procedure.
- Forbidden-token and axiom audits pass; the headline theorems use only
  `[propext, Classical.choice, Quot.sound]`.
- Three adversarial negative controls were exercised: corrupting a leaf member, corrupting a
  transition scalar, and omitting the final parent book caused respectively the local leaf,
  transition, and aggregate coverage proofs to fail.
- The frozen report reproduces byte-for-byte from the committed generator, and the updated paper
  PDF, proof audit, trust manifest, README, and paper result index agree on the exact value.

## Stronger algebraic content and follow-up

The leaf argument rules out every quadratic zero set disjoint from an eight-arc, including
singular quadrics; nonsingularity is needed only for the stated `rho_C` application. More generally,
evaluation-rank certificates apply to exceptional loci drawn from any linear system of forms; the
generic Lean lemma does not require finite-dimensionality. The targeted novelty/literature
comparison of the `2630+3` split and the general certificate pattern is recorded in the companion
archive and the linked novelty note.

For the odd-order projective-cap game, this is usable as static pruning when a candidate terminal
position is claimed to be conic-sealed. It supplies neither a legal reply nor a minimax descent, so
it does not by itself close C80 or C84; that limitation is recorded in the projective-cap handoff.
