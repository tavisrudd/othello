# Trust manifest — BaerCompletion

This manifest states exactly what the completion/extension proof lane kernel-checks and what remains
a geometric input. The associated paper draft is
`notes/2026-07-12-riffing-on-applications/paper-baer-equivariant-robust-completion.md`.

## Unconditional kernel-checked results

| Layer | Principal declarations | Meaning |
|---|---|---|
| hereditary completion | `insertion_indep_iff_no_surviving_trace`, `insertionDistance_eq_transversalNumber` | Semantic insertion cost equals obstruction transversal number for every finite hereditary independence system. |
| clutter reduction | `isTransversal_minimalEdges_iff`, `transversalNumber_minimalEdges` | Removing nonminimal dependent traces preserves all transversals and `τ`. |
| weighted completion | `weightedInsertionDistance_eq_weightedTransversalCostWithin` | Arbitrary nonnegative vertex deletion costs give exactly the corresponding weighted transversal problem. |
| multi-insertion | `multiInsertionDistance_eq_transversalNumber`, `multiInsertionDistance_singleton` | Simultaneous insertion of an arbitrary independent finite set has exact obstruction-transversal distance and strictly extends the singleton theorem. |
| weighted multi-insertion | `weightedMultiInsertionDistance_eq_weightedTransversalCostWithin` | The weighted and simultaneous-insertion generalizations compose without additional hypotheses. |
| secant mechanism | `transversalNumber_eq_card_of_pairwise_disjoint`, `insertionDistance_eq_secantCount` | A generating family of disjoint minimal traces computes insertion distance by edge count. |
| involutive incidence | `lineTrace_conj`, `invariant_pair_fixed_or_conjugate`, `conjugate_lineTraces_disjoint` | Conjugation transports traces; fixed two-traces are fixed points or a conjugate pair; conjugate-line traces through an external unique intersection are disjoint. |
| pair counting | `PairExtensionData.sum_card_sub_le_legalCount`, `PairExtensionData.mul_sub_le_legalCount`, `PairExtensionData.exists_legal_of_nonempty_of_lt` | Heterogeneous and uniform surviving-candidate bounds and the positive-surplus existence criterion. |
| geometric input reduction | `quadraticCandidate_card_of_two_fibers`, `emptyLine_card_of_complement`, `forbidden_card_le_of_injOn` | The three quadratic wrapper fields reduce respectively to a two-to-one mate map, an occupied/empty partition, and an injective obstruction-orbit charging map. |
| orbit saturation | `four_mul_splitProduct_le_square`, `orbitSaturation_quadratic_bound_of_split` | Denominator-free quadratic saturation bound. |
| robustness | `not_insertion_indep_of_card_lt_tau`, `not_insertion_indep_of_obstructions_persist`, `not_insertion_indep_of_card_lt_secantCount` | Below-`τ` deletion cannot unblock a point; persistence of old obstructions suffices under perturbation. |
| completion core | `completionCore_sdiff_eq`, `completionCore_delete_difference_eq_intersection` | Uniqueness below facet separation and a sharp alternative-facet witness. |

Concrete abstract-projective-plane consumers are in:

- `RelativeConicArcs.CompletionDistance`: `arcInsertionDistance_eq_pointIndex` and
  `arcGlobalInsertionDistance_eq_min_pointIndex`;
- `RelativeConicArcs.BaerIncidence`: projective-plane conjugate-trace disjointness and fixed-secant
  classification;
- `RelativeConicArcs.BaerArithmetic`: `M=fe+e(e-1)`, the eight-arc `M≤12` bound, candidate surplus
  for `s≥7`, and the occupied-line completed-square identity.
- `RelativeConicArcs.ProjectiveConjugation`: every field automorphism acts on coordinate points and
  dual lines, preserves orthogonality incidence, and an involutive automorphism supplies
  `InvolutiveIncidence`;
- `RelativeConicArcs.QuadraticFrobenius`: relative Frobenius has order two when the finite-field
  extension has degree two, yielding the concrete `PG(2,E)` incidence involution.

## Conditional quadratic wrapper

The coordinate Frobenius involution itself is now kernel-checked. `QuadraticBaerPairExtensionData`
still requires three explicit fields:

1. `emptyLine_count`;
2. `candidate_count`;
3. `forbidden_bound`.

`quadraticBaer_pairExtension_lowerBound` and `quadraticBaer_exists_pair` are kernel-checked
consequences of those fields. They do **not** prove the three fields for the coordinate Frobenius
construction. More precisely, the remaining fixed-locus and incidence
work must construct the two-to-one mate map, complement partition, and injective charging map
identified in `OrbitCounting.lean`. The manuscript may discharge them by elementary prose
geometry with citations; it must not call the exact pair-extension data Lean-formalized until a
concrete `QuadraticBaerPairExtensionData` instance lands.

## Citation-backed, not formalized here

- exact completion radii for conics, hyperovals, maximal arcs, elliptic quadrics, generalized-
  quadrangle ovoids, and spreads;
- fixed-locus characterization of quadratic Frobenius as the embedded subfield projective plane;
- the ceiling/square-root presentation of the denominator-free quadratic saturation theorem.

## Audit result

The new lane and its `RelativeConicArcs` consumers contain no `sorry`, `admit`, `native_decide`,
custom `axiom`, or `unsafe` declaration. Printed headline axiom profiles use only accepted Mathlib
foundations: `propext`, `Classical.choice`, and `Quot.sound`.

Validation command:

```text
choom -n 1000 -- nix develop --command lake build FiniteGeom RelativeConicArcs
```
