# Axis–twisted-cubic formalization: strict-gate adversarial review

**Date:** 2026-07-12
**Verdict:** PASS for the finite uniform seed-and-lift theorem, with the outer-family asymptotic
corollary explicitly conditional on two prose/literature inputs.

## Statement adequacy

- The code is the actual row space of the displayed axis–twisted-cubic generator, not an abstract
  object carrying the desired parameters.
- Repair hypergraphs are the complete bounded-radius hypergraphs derived from actual dual-word
  supports.  The proofs do not substitute a selected repair family.
- The q=9 table is exact: `(nu,tau)=(4,7),(6,12),(7,13)`.  The corresponding repair counts
  `28`, `36+8`, and `36+12`, and the `120`/`84` small-circuit support inventory, are now separate
  kernel-checked theorems rather than script-only diagnostics.
- The lift is an actual concatenated submodule.  Its base-field dimension and minimum-distance
  bound are proved, and the complete repair hypergraph is proved equal to the embedded inner
  hypergraph block by block.  Matching and transversal values therefore transfer exactly.
- The paper-facing `[19N,4K,>=8D]_9` theorem exposes `finrank_F O = 4K` and
  `D <= symbolMinDist O` as hypotheses; it does not infer extension-field dimensions silently.

## Trust audit

- Repository scan of `lean/FiniteGeom` and `lean/RepairCodes`: no project `axiom`, `sorry`,
  `admit`, `native_decide`, `unsafe`, or `implemented_by` declaration in the proof chain.
- Closed q=9 checks use kernel `decide`; in particular the rainbow matching is reduced to the
  small `Fin 8`/`Fin 4` incidence skeleton rather than evaluated by native code.
- `#print axioms` on the parameters, exact repair classification, q=9 row/count table,
  `120`/`84` inventory, concatenated parameters, exact hypergraph transfer, locality, and ratio
  reports only `propext`, `Classical.choice`, and `Quot.sound`.

## Adversarial findings closed during the review

1. The full `[19,4,8]_9` seed has global dual distance **three**, not four, because any three axis
   points form a circuit and an axis coordinate has two-helper repairs.  The formal theorem now
   states the exact value.  The transfer proof was generalized to its real sharp condition
   `r+1 < 2*d(I^perp)`; radius three remains valid because `4 < 6`.
2. The q=9 edge counts and `120`/`84` inventory were still only in the replay script.  They are
   now kernel-checked in `Q9Uniform` and `Q9CircuitInventory`.
3. The PGL orbit derivation was labelled simply “proved” in the research ledger despite not being
   part of the Lean chain.  It is now labelled computational/context-only, and the formal
   construction directly defines the axis it uses.
4. A conventional extension-field outer dual-distance statement had been allowed to blur into the
   coordinate-free outer hypothesis.  The finite theorem now advertises exactly the functional-dual
   gate it proves from; the trace bridge and asymptotically good outer-family existence are named as
   external inputs.
5. The outer gate could appear vacuous.  `hasFunctionalDualDistanceAtLeast_top` supplies an explicit
   nonvacuity witness, while useful positive-rate outer families remain the external mathematical
   input described above.

## Remaining genuine math work

No unresolved mathematics remains in the finite axis–twisted-cubic seed, its uniform repair
formulas, the q=9 exact table, or the conditional finite lift theorem.  Two inputs remain before an
unconditional formal asymptotic family theorem can be claimed:

1. formalize the trace-duality bridge from a suitable `GF(9^4)`-linear outer code to
   `HasFunctionalDualDistanceAtLeast`;
2. formalize or quarantine with exact citations an asymptotically good outer family with the
   required primal and dual relative-distance bounds.

The PGL-orbit provenance is optional contextual formalization and is not a blocker for any code or
repair result.
