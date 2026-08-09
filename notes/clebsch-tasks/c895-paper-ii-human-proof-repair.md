# C895 — Paper II modular human-proof repair

**Lane:** `clebsch`

**Status:** active; R0 is frozen; the universal R1 theorem is false at `q=9`;
the extension-field detector replacements are now proved by low root degree,
the `T(2q)` Steinberg filtration, and a discriminant-times-digitwise-Cartan
embedding for `L(q-7)`; the prime-field Fischer decomposition has a targeted
tilting proof; arbitrary-`p'` descent is replaced by Faber's direct tame
subgroup classification; specialist challenges and manuscript integration
remain

## Objective

Repair the existing non-C894 proof of Paper II's all-field matching-orbit
classification at referee depth while keeping the main exposition concise.
The human proof must establish, without Lean or finite certificates as a
substitute:

1. the actual finite-group Hom basis in the Lucas-socle calculation,
   including carries, finite-torus aliases, and exhaustiveness in the full
   target;
2. the opposite-outer-parity Hom vanishing for every detecting module,
   with a complete Steinberg-source argument and all divided-power relations;
3. descent for arbitrary `p'` matching stabilizers through both
   `PSL_2(q_0)` and square-subfield `PGL_2(q_0)` branches; and
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

## Exposition boundary

Follow `papers/style-guide.md` as a two-track architecture.  The main body
gets one causal roadmap, exact modular propositions, and the short
classification proof.  A self-contained technical appendix gets the Lucas
matrix, carry/alias analysis, divided powers, Steinberg calculation,
two-digit model example, and subgroup descent.  The main body may grow by at
most two net pages; target 48--50 pages overall and trigger a compression
review at 52.

C894, saturated-exterior geometry, the postclassification Paley carrier,
one-factorizations, survivor stabilizers, and the fields 7 and 11 may not
enter the preclassification repair.

## Work order

1. Freeze the exact preclassification interface and its forbidden outputs.
2. Write an explicit coefficient-matrix memo and prove or refute its Lucas
   factorization as an actual finite-group Hom theorem.
3. Compute the full algebraic-group Hom space with Steinberg source.  If it
   is nonzero, stop and replace the detector or redesign the
   extension-field branch.
4. Complete the remaining parity detectors and isolate the accepted
   contraction lemma.
5. Prove the arbitrary-`p'` Dickson descent corollary.
6. Integrate only after steps 2--5 survive specialist challenge reads.
7. Run finite-Hom, outer-parity, subgroup, and final context-free cold reads;
   then refresh trust prose, PDF, and release surfaces.

## Acceptance gate

- A modular-representation reader reconstructs the Hom basis and finds no
  extra alias/carry kernel or lower Steinberg subquotient map.
- A group theorist starts with an arbitrary `p'` stabilizer in a
  square-subfield branch and reaches one stated detector row with no hidden
  maximality assumption.
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
