# C100 — relative-conic sealing bridge and odd-plane review

**Date:** 2026-07-12
**Status:** ACTIVE — semantic bridge proved; game consumers under review

## Goal

Determine which results from the `RelativeConicArcs` spinoff materially help the uniform odd-order
projective-plane cap-game proof. Keep static containment, exact finite computations, and game-value
claims in separate trust tiers.

## Landed bridge

`RelativeConicArcs.ProjectiveBridge` now proves:

- `projectiveCap_subset_union_of_completeOutside`: if `A` is complete outside `H`, every projective
  cap `S` containing `A` satisfies `S ⊆ A ∪ H`;
- `move_mem_holes_of_completeOutside`: every legal move from any such continuation `S` lies in `H`;
- `legalExtensions_subset_holes_of_completeOutside`: the full legal-extension finset is contained
  in `H`, persistently after arbitrary legal hole moves; and
- `legalExtensions_subset_holes`: the seed-position specialization.

This is a domain-legality theorem, not a P/N or reachability theorem. The isolated module builds;
all four declarations audit to `[propext, Classical.choice, Quot.sound]` and use no `sorry`,
`native_decide`, `admit`, or custom axiom.

## Potential odd-plane consumers

| Item | Evidence now | Review target |
|---|---|---|
| Persistent conic sealing | Lean-proved for every finite coordinate field and every prescribed hole set | Expose the exact residual conic game after a seed and connect it to the existing involution-union graph API. |
| `q=9` six-arc | Frozen verifier shows every conic point covered, so the witness is an ordinary complete arc with empty residual | Add a small Lean terminal-P theorem; then test whether any frame/grid descent reaches its orbit. Existence alone does not prove the root outcome. |
| `q=11` six-arc | Exact coordinate reconstruction gives 12 live conic vertices, the icosahedral graph, and Grundy zero; antipodal symmetry supplies the conceptual P proof | Formalize the residual graph isomorphism and antipodal P theorem; compare its `A5` orbit with the polyhedral catalogue and depleted-order structures. |
| Defect/uncovered bounds | Lean-proved for arbitrary holes | Test whether `uncovered_bound` or `scaledDefect` strengthens C80's live-conic/live-edge minimax potential or supplies a descent measure. |
| Asymptotic sealing scale | Lean proves `rhoC(q) ≥ sqrt(2q)+3/2−8/sqrt(2q)` | Use as a guardrail: an intruder-only complete-outside-conic seal is not a bounded-size mechanism. A containment, descent, or exchange lemma is still required for (ON). |

## Open review order

1. Formalize the `q=11` residual as the icosahedral graph and prove it P by the antipodal mirror.
2. Add the `q=9` ordinary-complete/terminal-P corollary.
3. Search the odd-plane exact corpus for containment or two-ply descent into these sealed P objects;
   do not infer reachability from their existence.
4. Translate the generic uncovered/defect inequalities into the variables of C80's drain ledger and
   retain them only if they sharpen a minimax, not merely a static coverage count.

The bridge does not close the active size-3 to size-4 escape lemma or its stronger on-conic form.
