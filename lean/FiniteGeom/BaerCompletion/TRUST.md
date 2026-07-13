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
| exact quadratic line counts | `card_occupiedFixedLines`, `card_emptyFixedLines`, `choose_fixedArcPoints_le_star` | For an invariant arc, fixed lines are partitioned exactly into occupied and empty lines, with natural subtraction proved nontruncating. |
| exact quadratic obstruction count | `card_nonfixedSecantOrbits`, `card_forbiddenCandidates_le_baer`, `mem_forbiddenCandidates_iff_exists_covered` | Nonfixed secants have two-element conjugation orbits; their intersections charge all and only secant-covered candidates. |
| coordinate pair extension | `coordinateQuadraticExtensionData`, `exists_quadratic_pair_extension` | The exact quadratic wrapper is instantiated, and positive surplus produces a conjugate pair whose union with the old set is an arc. |
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
  extension has degree two; Hilbert 90 identifies its fixed projective locus with the embedded
  `PG(2,F)`; fixed points and lines number `s²+s+1`, each fixed line contains `s+1` fixed and
  `s²-s` nonfixed points, and the latter form exactly `(s²-s)/2` conjugate pairs;
- `RelativeConicArcs.QuadraticPairExtension`: the coordinate construction automatically discharges
  `candidate_count` in the exact quadratic wrapper;
- `RelativeConicArcs.QuadraticLineCounting`: exact occupied/empty fixed-line counts, including the
  inequality needed to interpret natural subtraction as ordinary subtraction;
- `RelativeConicArcs.QuadraticForbidden`: exact nonfixed-secant orbit count, injective charging of
  forbidden candidates, semantic identification of forbiddenness with secant coverage, and the
  end-to-end arc-extension theorem `exists_quadratic_pair_extension`.

## Exact quadratic wrapper

All three fields of `QuadraticBaerPairExtensionData` are discharged in coordinates. The final
theorem does not stop at an abstract legal-count predicate: `arc_union_candidate_of_not_mem_forbidden`
proves semantic adequacy, and `exists_quadratic_pair_extension` returns a nonfixed point `p` such
that adjoining `{p, frobeniusPoint p}` preserves the arc property. Its hypotheses are exactly the
paper's nonempty-empty-line and positive-candidate-surplus inequalities.

The following ingredients are classical infrastructure and are **not** recorded as discoveries:
Hilbert-90 normalization, identification of the fixed locus with `PG(2,s)`, standard projective
point/line counts, arc line-incidence double counting, and two-element orbit counting for a
fixed-point-free involution. Formalization establishes trust in their use; it does not establish
novelty.

## Citation-backed, not formalized here

- exact completion radii for conics, hyperovals, maximal arcs, elliptic quadrics, generalized-
  quadrangle ovoids, and spreads;
- the ceiling/square-root presentation of the denominator-free quadratic saturation theorem.

## Audit result

The new lane and its `RelativeConicArcs` consumers contain no `sorry`, `admit`, `native_decide`,
custom `axiom`, or `unsafe` declaration. Printed headline axiom profiles use only accepted Mathlib
foundations: `propext`, `Classical.choice`, and `Quot.sound`.

Validation command:

```text
choom -n 1000 -- nix develop --command lake build \
  RelativeConicArcs.QuadraticLineCounting \
  RelativeConicArcs.QuadraticPairExtension \
  RelativeConicArcs.QuadraticForbidden
```
