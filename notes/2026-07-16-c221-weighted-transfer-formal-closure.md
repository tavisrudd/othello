# C221 weighted-transfer formal closure

**Lane:** `repaircodes`

**Status:** in progress. The structural and lower-bound cores are kernel-checked; two concrete
finite instantiations and the aggregate Lean gate remain.

## Kernel-checked scope

`lean/RepairCodes/WeightedTransferExact.lean` adds a lower-bound formulation that preserves the
manuscript's infinity convention for empty strata instead of using `Nat.sInf ∅ = 0`.

- `hasMultiblockDualDistanceAtLeast_iff_three_strata` is an exact iff partition into the
  zero-functional, singleton-functional, and multisupport-functional cases.
- `hasMultiblockDualDistanceAtLeast_of_three_terms` proves that the displayed terms
  `2 * dualDist I`, singleton reduced-fiber cost plus `dualDist I`, and multisupport reduced-fiber
  cost jointly imply the global multiblock threshold.
- `functionalWeight_ne_one_of_isCoordinateSurjective` and
  `hasMultiblockDualDistanceAtLeast_of_isCoordinateSurjective` remove the singleton stratum and
  give the qualified two-term lower-bound direction for the multiblock threshold.
- `flatten_mem_dualCode_concatenatedCode_of_functionalDual` supplies the reverse block-functional
  bridge needed for later minimum-attainment witnesses.
- `exists_disjoint_translate_of_sum_inter_lt`, `completedQ9_singer_average_lt`, and
  `five_fiber_weight_at_least_six` kernel-check the averaging implication, the strict arithmetic
  `400 < 820`, and the five nonzero fibers with a Singer-disjoint pair costing at least six.

Focused guarded elaboration passes. Every printed headline uses only Lean's standard axioms; no
`sorryAx` appears. The manuscript PDF builds cleanly with Tectonic.

## Remaining closure

1. Prove minimum attainment converts the exact strata into literal equalities with the three
   finite minima, including two available blocks and either a nontrivial inner dual or an
   infinity-safe formulation of the empty zero fiber. Separately formalize the exact
   nonembedded-witness threshold `min(2 * dualDist I, d_lambda(O))`.
2. Instantiate the regular Singer action on the completed q=9 coordinate-functional set and the
   generalized-SPC trace-dual pattern, rather than leaving those identifications in manuscript
   prose.
3. Run the focused target and aggregate `RepairCodes` build after the foreign Q25 build releases
   the shared Lean owner lock; repeat the standard-axiom scan on the built target.

The finite fiber-enumerator equivalence remains optional, and the polynomial identity remains an
honestly ledgered classical manuscript corollary.

## Cold-read correction

A standalone referee read found that the former manuscript incorrectly equated multiblock
confinement with complete repair-hypergraph equality. A one-block dual word may induce a nonzero
outer functional, and equality of support sets does not identify witnesses. The manuscript now
separates `delta_mb` from the exact nonembedded-witness threshold `delta_emb`; falling below
`delta_emb` implies hypergraph equality, with no converse claimed. The coordinate-surjective
applications remain valid because their singleton functional stratum is empty.
