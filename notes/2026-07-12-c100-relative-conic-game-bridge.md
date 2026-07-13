# C100 — relative-conic sealing bridge and odd-plane review

**Date:** 2026-07-12
**Status:** REPORTED — exact game localization, q=9 terminal P, q=11 seeded P, and consumer review complete

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
- `win_parametrizedHoles_iff` / `isP_parametrizedHoles_iff`: the full cap game above a relatively
  complete seed has exactly the value of any injectively parametrized hole game; and
- `legalExtensions_sdiff_holes_eq_uncovered`: off-hole legal moves are exactly the defect
  theory's uncovered required locus.

The first four declarations are domain-legality theorems. The parametrized theorem is the separate
value bridge; it changes no reachability claim. The focused modules build, and all new declarations
audit to `[propext, Classical.choice, Quot.sound]` with no `sorry`, `native_decide`, `admit`, or
custom axiom.

## Potential odd-plane consumers

| Item | Evidence now | Review target |
|---|---|---|
| Persistent conic sealing | Lean-proved for every finite coordinate field and every prescribed hole set | Expose the exact residual conic game after a seed and connect it to the existing involution-union graph API. |
| `q=9` six-arc | `Q9Terminal.complete`, `legalExtensions_eq_empty`, and `isP` prove ordinary completeness and the actual terminal cap-game value | No tested four-point subconfiguration has the two-ply reply closure needed to descend into the six-point orbit. |
| `q=11` six-arc | `Q11Residual.seed_isP` proves the actual seeded projective-cap position is P, via exact localization to the icosahedral independent-set game | No tested four-point subconfiguration has the two-ply reply closure needed to descend into the six-point orbit. |
| Defect/uncovered bounds | `legalExtensions_sdiff_holes_eq_uncovered` identifies the exact game set counted by the defect theory | Does not sharpen C80: `uncovered_bound` is a static inequality with the uncovered count on its slack side and supplies neither a monotone live-conic drain nor a reply/value bound. |
| Asymptotic sealing scale | Lean proves `rhoC(q) ≥ sqrt(2q)+3/2−8/sqrt(2q)` | Use as a guardrail: an intruder-only complete-outside-conic seal is not a bounded-size mechanism. A containment, descent, or exchange lemma is still required for (ON). |

## Review verdict

The relative-conic package contributes two exact boundary evaluators and a reusable static-to-game
localization theorem. It does not close (ON): direct projective-orbit probing found zero two-ply
closures for every four-subset of either six-point witness, and the q=11 seed is not itself on a
conic. The defect identity exactly counts current off-hole moves but gives no C80 minimax descent.
These negative conclusions are scoped to the tested lever; they do not assert an impossibility.

The q=11 theorem package is `RelativeConicArcs.Q11Residual`: `all_seed_legal`,
`adj_iff_icosahedron`, `icosahedronEdges_card`, `degree_five`, residual `isP`, exact continuation
validity `continuation_rawArc_iff`, and actual projective `seed_isP`. The proof applies the generic
conflict-graph mirror engine rather than evaluating the full game tree. Its strict axiom profile is
`[propext, Classical.choice, Quot.sound]`.

The bridge does not close the active size-3 to size-4 escape lemma or its stronger on-conic form.
