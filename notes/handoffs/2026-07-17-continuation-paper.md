# Continuation-graph rigidity paper

**Lane**: `continuation`

**Date**: 2026-07-17

Discovery companion: `notes/2026-07-19-continuation-discovery-track.md`.

## Goal

Bring `papers/continuation-graph-rigidity` (recovering the arc / plane from a k-cap's abstract
continuation graph) to the arcs/clebsch release bar as an **N1-only** paper per ruling D3 and the
ship-order #7 gate: LaTeX+PDF manuscript, full-trust Lean, provenance section, adversarial and
cold-prose review, and a cleared novelty audit. N1 is the headline (four-point-frame continuation
graph has exactly its ambient semilinear automorphisms, q ≥ 13, Thm 7.4). N2 (full-complex
reconstruction, Thm 8.4) is demoted to a remarks subsection out of the abstract and contributions
until the paywalled Metsch / Drake–Sané read clears.

## Current status

- Theorem package: `notes/2026-07-10-continuation-graph-rigidity-upgrades.md`, all main theorems
  `[PROVED]` with full written proofs. Extremal quantities m(k), r(k) are `[OPEN]`.
- Prior-art audit: `notes/2026-07-11-continuation-rigidity-audit-scope.md` — **N1 SURVIVES**
  (Bruno–Mella / cross-ratio-graph prior art points the other way); **N2 SOFTEN** (collides with the
  complement / pseudo-complement embedding genre — Batten, Drake–Sané, Beutelspacher–Metsch — but the
  arc-recovery chain survives).
- Manuscript: C272 is complete. The N1-only working draft is
  `papers/continuation-graph-rigidity/continuation_graph_rigidity.tex`; it contains the complete
  `q>=13` proof, keeps N2 in scope remarks only, states `m(k),r(k)` as open, and records the exact
  small-order boundary. See `notes/2026-07-17-c272-continuation-n1-manuscript.md`.
- Lean: `ContinuationRigidity` is a planned Phase 3 library, **not yet built**.
- Planning rulings: `papers/papers-planning.md` ship-order entry #7 (gate: no manuscript; hardest
  formalization; collaborator route if it stalls) and ruling D3 (N1 only; N2 to remarks).

## Open frontiers

- **N2 residual diligence (C271):** the N2 SOFTEN verdict is gated on a MathSciNet/zbMATH
  forward-citation run (auth-gated) plus full texts of Drake–Sané and Metsch (LNM 1490), currently
  paywalled/unread. Closing it may reopen N2 for the abstract, but D3 holds until then.
- **Manuscript maturation:** C272 supplies the N1 draft. PDF compilation, bibliography refinement,
  cold-prose review, and integration with C273's eventual formal statement remain release work.
- **Lean not built (C273):** the Phase 3 `ContinuationRigidity` library is planned only.
- **Extremal m(k), r(k) `[OPEN]`:** genuine research, not a release gap. No C task allocated; a
  sharpening result is out of scope for the N1 release and stays a stated open frontier.

## Next steps

- **C271** — N2-gate literature closure: obtain full texts of Drake–Sané and Metsch LNM 1490, run
  the MathSciNet/zbMATH forward-citation check, and update
  `notes/2026-07-11-continuation-rigidity-audit-scope.md` with the outcome (implements the audit's
  recorded residual diligence; does not re-decide N1 SURVIVES).
- **C273** — `ContinuationRigidity` Lean library per the Phase 3 plan; do not re-decide the plan.
  The recorded collaborator route is the fallback if formalization stalls (per the #7 gate).

## Crowns consumer contract

- `continuation` owns C271--C273, the N1 statement, graph convention, stable `q>=13` range,
  exceptional boundary, manuscript, and Lean implementation.
- General C295 reconstruction consumes the committed C272 N1 package and manuscript read-only and
  must not widen C272 or C273. C273 formalization is not a prerequisite to specify C295's intrinsic recovery
  predicates.
- The bounded q=11 Clebsch matching-decomposition pilot lies below N1's field range and may proceed
  independently in `crowns` once its queue gate is recorded. It is not evidence for the general
  `q>=13` theorem by itself.
- Any C295 result proposed for this manuscript returns to the continuation owner for integration;
  crowns agents do not edit the paper or this handoff.

## Collaborator route

The #7 gate records a collaborator route as the fallback if the (hardest-in-the-portfolio)
formalization stalls. It is the recorded escape hatch, not a first move.
