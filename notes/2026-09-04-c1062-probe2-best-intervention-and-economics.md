# C1062 probe 2: best intervention over the monoid action, and the economics that follow

**Lane**: `complete-ports`
**Task**: C1062, probe 2
**Plan**: `2026-09-04-c1062-exploration-log.md`
**Inputs**: probe 1a for the cost model, probe 1 for the lowering and its class oracle, probe 3 for
the actual-cause layer that feeds this one a minimal contingency.
**Code**: `ergodis-private`, `src/best_intervention.rs` and `tasks/tools/src/best_intervention_report.rs`
**Replay**: (filled in after the run)
**Verdict**: (filled in after the run)

## Predeclarations, entered before any measurement

These are fixed before the code that measures them was written, per the lane's rule that a
measurement probe predeclares its shape verdicts and carries at least one predicted loss.

### The two thresholds

1. **Timing.** The compiled arm must beat a **memoized** re-solve on the enumeration query. Both
   arms answer the same workload of `best_intervention` queries over sampled exogenous contexts.
   The compiled arm pays one compile, then one Dijkstra over the quotient per distinct class; the
   memoized arm pays one full enumeration per distinct context, then a hash lookup. The number that
   decides it is the **break-even query count**: the workload length at which the compiled arm's
   cumulative time drops below the memoized arm's. Predeclared pass: break-even is reached within
   the number of distinct contexts, that is, before the memoized table is even full.
2. **Compression.** Residual compression above the orbit baseline, `orbits / classes`, must exceed
   **1.5x** on at least one family whose declared automorphism group is trivial. Relevance pruning
   and symmetry are free; only the residue counts.

### Predicted verdicts per family

| Family | Shape reading | Prediction |
|---|---|---|
| `reliability-3of8` | C1, C2 (failed-count summary), C3, C4, C5 (full symmetric group) | **loss**: classes are the failed-count strata, so orbits equal classes and residual compression is exactly 1.0 |
| `weighted-threshold-8` | C1, C2, C3, C4; **not** C5 — distinct Fibonacci weights admit no symmetry | **win**: orbits are singletons by construction, so every merge is intervention-driven |
| `distractor` | C1, C2, C3 | **loss**: relevance pruning explains all of it; residual after pruning is 1.0 |
| `identity` | C1, C3; **fails C2** — observing every variable leaves no sufficient summary | **loss**: classes equal contexts, the compile buys nothing |
| `wide-conjunction` | C1, C2, C3, C4 | **partial**: the arity tower refines past one, so some but not all of the collapse survives the orbit baseline |
| `restricted-vocabulary` | C1, C2, C3, C4 — eight components of which only three may be touched | **win**: the realistic repair vocabulary is the shape where unpinned contexts have room to merge, so residual above 1.5 |
| `weighted-threshold-10` | the timing family, ten distinct weights | **win** on time: the compiled arm's cumulative cost crosses below the memoized re-solve within the distinct-context count |
| `response-function` | correctness carry from probe 1, not an economics row | no prediction |

Every candidate symmetry offered to a family is **verified exhaustively** and only the verified ones
enter its orbit baseline, so a family cannot be made to look intervention-compressed by declaring a
thin group.

A predicted loss that loses is a pass. A predicted loss that wins is a finding about the shape
classifier, not a success for this probe.

## (Sections below are filled in after the run.)
