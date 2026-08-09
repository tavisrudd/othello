# C895 — Paper II modular human-proof repair

**Lane:** `clebsch`

**Status:** complete; the false universal theorem is removed, the targeted
linear detectors, complete outer-parity proof, Fischer contraction, Faber
exhaustion, endpoint-lift intrinsicity, load-bearing Appendix A, trust prose,
and statement map are integrated, and a fresh full-paper human-proof referee
returned PASS with no actionable defect

## Objective

Repair the existing non-C894 proof of Paper II's all-field matching-orbit
classification at referee depth while keeping the main exposition concise.
The human proof must establish, without Lean or finite certificates as a
substitute:

1. the exact detector-specific linear Hom occurrence, absence, and outer
   normalization used by the exclusion;
2. the opposite-outer-parity Hom vanishing for every detecting module,
   with a complete Steinberg-source argument and all divided-power relations;
3. exhaustive treatment of arbitrary `p'` matching stabilizers without a
   hidden maximality or subfield assumption; and
4. projective intrinsicity under rescaling endpoint lifts.

The governing plan is
`notes/2026-08-09-clebsch-paper-ii-non-c894-repair-plan.md`.

Current mathematical memos:

- `notes/2026-08-09-c895-preclassification-interface.md`;
- `notes/2026-08-09-c895-steinberg-source-hom.md`;
- `notes/2026-08-09-c895-finite-hom-matrix-specification.md`.
- `notes/2026-08-09-c895-q9-extra-hom-and-repair.md` and its exact
  script/JSON falsifier.
- `notes/2026-08-09-c895-extension-field-linear-detectors.md`.
- `notes/2026-08-09-c895-prime-field-fischer-detectors.md`.
- `notes/2026-08-09-c895-tame-subgroup-exhaustion.md`.
- `notes/2026-08-09-c895-specialist-challenge-review.md`.
- `notes/2026-08-09-c895-revised-paper-cold-referee.md`.

## Exposition boundary

Follow `papers/style-guide.md` as a two-track architecture.  The main body
gets one causal roadmap, exact modular propositions, and the short
classification proof.  A self-contained load-bearing Appendix A gets the targeted
root-degree, digitwise Cartan, divided-power, Steinberg, Fischer, and Borel
calculations.  The falsified universal matrix stays outside the paper.  The
integrated manuscript is 42 pages; 50 pages is the compression threshold.

C894, saturated-exterior geometry, the postclassification Paley carrier,
one-factorizations, survivor stabilizers, and the fields 7 and 11 may not
enter the preclassification repair.

## Work order

1. Integrated targeted theorem and detector appendix: complete.
2. Fresh context-free full-paper referee read: PASS.
3. Focused abstract/exposition read: corrected and rechecked.
4. Formal/trust completion returns to C892; release packaging remains C577.

## Acceptance gate

- A modular-representation reader reconstructs every detector-specific Hom
  statement and finds no lower Steinberg subquotient map or missed divided
  power.
- A group theorist applies Faber to an arbitrary `p'` stabilizer and reaches
  one stated detector row without a rational-conjugacy assumption.
- A fresh full-paper referee returns no major human-proof objection.
- The layered exposition preserves a complete first-pass route and a
  complete specialist proof without importing computation into the causal
  spine.

## Boundaries

This task owns Paper II human-proof notes and, after the mathematical gates
pass, authoritative Paper II manuscript/trust edits.  It does not edit Lean,
replace C892's formal-remediation scope, publish, push, or synchronize the
standalone mirror without the ordinary downstream authorization and mirror
procedure.  Reviewer dossiers and persona packets remain review-sub-agent
material only.
