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
| pair counting | `PairExtensionData.sum_card_sub_le_legalCount`, `PairExtensionData.mul_sub_le_legalCount`, `PairExtensionData.exists_legal_of_nonempty_of_lt` | Exact distinct-forbidden-support subtraction, heterogeneous/common-upper-bound forms, and the positive-surplus existence criterion. |
| exact collision accounting | `card_visible_eq_support_add_collisionRedundancy`, `card_legal_add_orbits_eq_candidates_add_invisible_add_redundancy`, `sum_card_legal_add_carriers_mul_orbits_eq_sum_candidates_add_invisible_add_redundancy` | Subtraction-free decomposition of an orbit charge into invisible mass, distinct support, and collision redundancy, linewise and in aggregate. |
| capped collision moments | `choose_two_le_two_mul_pred_of_le_four`, `two_mul_choose_two_le_three_mul_of_le_four`, `choose_two_succ_le_two_mul_of_le_three`, `sum_choose_chargeMultiplicity_le_two_mul_collisionRedundancy` | Elementary finite inequalities used to pass between first/second moments and redundancy when fibers have size at most four. |
| geometric input reduction | `quadraticCandidate_card_of_two_fibers`, `emptyLine_card_of_complement`, `forbidden_card_le_of_injOn` | The three quadratic wrapper fields reduce respectively to a two-to-one mate map, an occupied/empty partition, and an injective obstruction-orbit charging map. |
| exact quadratic line counts | `card_occupiedFixedLines`, `card_emptyFixedLines`, `choose_fixedArcPoints_le_star` | For an invariant arc, fixed lines are partitioned exactly into occupied and empty lines, with natural subtraction proved nontruncating. |
| exact quadratic obstruction count | `card_nonfixedSecantOrbits`, `card_forbiddenCandidates_le_baer`, `mem_forbiddenCandidates_iff_exists_covered` | Nonfixed secants have two-element conjugation orbits; every forbidden candidate injects into an orbit, and forbidden support is exactly endpoint secant coverage. No reverse surjectivity from all orbits on every carrier is asserted. |
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
  end-to-end arc-extension theorem `exists_quadratic_pair_extension`;
- `RelativeConicArcs.QuadraticCollision`: visible charge support equals `forbiddenCandidates`, the
  exact carrier balance holds linewise and in aggregate, and the aggregate invisible-capacity
  hypothesis yields a genuine arc extension.
- `RelativeConicArcs.Q25PairResult`: `f2_pair_extension` proves that every Frobenius-invariant
  eight-arc in `PG(2,25)` with exactly two fixed selected points admits a fresh conjugate-pair
  extension, with each of the two new points explicitly outside the old arc. Its reduction
  includes a concrete `GF(25)/GF(5)` model, proved fixed-pair and
  stabilizer normalizations, exact three-orbit decomposition, a kernel-reduced determinant slice,
  and semantic transport back to the paper-facing projective point model.

## Exact quadratic wrapper

All three fields of `QuadraticBaerPairExtensionData` are discharged in coordinates. The final
theorem does not stop at an abstract legal-count predicate: `arc_union_candidate_of_not_mem_forbidden`
proves semantic adequacy, and `exists_quadratic_pair_extension` returns a nonfixed point `p` such
that adjoining `{p, frobeniusPoint p}` preserves the arc property. Its hypotheses are exactly the
paper's nonempty-empty-line and positive-candidate-surplus inequalities.

The following ingredients are classical infrastructure and are **not** recorded as discoveries:
completion/correction distance as a transversal number; minimal-edge clutter reduction; weighted
and prescribed-set hitting-set forms; disjoint-secants/point-index evaluation; blocker and
obstruction-persistence principles; Hilbert-90 normalization; identification of the fixed locus
with `PG(2,s)`; standard projective point/line counts; arc line-incidence double counting; and
two-element orbit counting for a fixed-point-free involution. Formalization establishes trust and
reuse; it does not establish novelty. The exact assembled quadratic-Frobenius orbit-extension
criterion is the principal plausibly unrecorded result, subject to the residual specialist priority
search documented in the
[`novelty audit`](../../../notes/2026-07-13-baer-completion-adversarial-novelty-review.md).

## Citation-backed, not formalized here

- exact completion radii for conics, hyperovals, maximal arcs, elliptic quadrics, generalized-
  quadrangle ovoids, and line spreads of `PG(3,q)`; no `q+1` claim is made here for arbitrary
  `(n-1)`-spreads of `PG(2n-1,q)`;
- the ceiling/square-root presentation of the denominator-free quadratic saturation theorem.

The exact charge-profile decomposition into invisible orbit counts and collision multiplicities is
kernel-checked. The exceptional order-five profile `(f,e)=(2,3)` is also kernel-checked by
`Q25PairResult.f2_pair_extension`; the external census and its observed minimum of 32 remain
provenance only and are not used by that theorem. `QuadraticInvisible.lean` now kernel-checks the
geometric rephrasing of invisibility as the secant-orbit center lying on the carrier, its aggregate
center-incidence double count, and the generic `s+3-f-e` empty-carrier bound for every cross-pair
orbit of an `(f,e)` profile. The proof derives `e≥2`, excludes the two participating mate lines,
and injects all remaining occupied center-lines into `f+(e-2)` charges. Its local `GF(5)`
specialization supplies the two-empty-carrier consequence used by the `(4,2)` proof, and
`Q25ProfileFour.profile_four_pair_extension` gives the
certificate-free semantic extension theorem. `Q25ProfileZero` kernel-checks the endpoint-index
bridge and second-moment partition for `(f,e)=(0,4)`, obtaining at least five legal pairs and a
fresh semantic extension. `Q25AllProfiles.pair_extension` combines this with the checked
`f=2,4,6,8` cases into the uniform order-five theorem.

## Audit result

The new lane and its `RelativeConicArcs` consumers contain no `sorry`, `admit`, `native_decide`,
custom `axiom`, or `unsafe` declaration. Printed headline axiom profiles use only accepted Mathlib
foundations: `propext`, `Classical.choice`, and `Quot.sound`.

For the Q25 slice specifically, a source-level completeness audit found exactly 46,056 rows
`6≤b<c≤309`, with no gaps or duplicates: 39,012 checked non-arc witnesses and 7,044 checked legal
extensions. All 1,639 leaves and 303 row aggregates are imported exactly once. The formal
exhaustiveness claim is the built Lean declaration `Q25PairCertificate.allRows`; the source counts are an
audit aid, not a substitute for that theorem. Both `indexed_f2_pair_extension` and
`f2_pair_extension` print exactly the accepted axiom profile above.

Validation command:

```text
choom -n 1000 -- nix develop --command lake build \
  FiniteGeom.BaerCompletion.CollisionProfile \
  RelativeConicArcs.BaerArithmetic \
  RelativeConicArcs.QuadraticCollision \
  RelativeConicArcs.Q25PairResult
```
