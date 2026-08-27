# C975 — Beyond Four coding-theory upgrade

**Lane:** `reed-solomon` · **Status:** active

**Current checkpoint:** theorem-driven spine and framing proposed in
`c975-2026-08-26-paper-spine-and-framing.md`; manuscript edits await review
of that architecture.

## Objective

Make *Projective Reed--Solomon deep holes beyond redundancy four* as strong
and broadly relevant to modern coding theory as the proved results permit.
The paper should lead with its arbitrary-redundancy structural theorem and
the resulting distance-partition/code-extension statements, not with the
chronology of the redundancy-five through redundancy-ten calculations.
Because the integrated theorem allows arbitrary nonzero multipliers and
supports obtained by deleting prescribed points of the projective line, the
title and opening should name generalized and extended Reed--Solomon codes;
full-support PRS is the extended boundary case, not the boundary of the
paper's relevance.

## Required integration

1. Replace the stagewise lower-package hypothesis and repeated finite-level
   escape prose by the C973 simultaneous-marker theorem, deterministic
   selector, exact threshold, and witness-abundance statement.
2. Present cofinite-support GRS codes as a theorem-level consequence, with
   the exact distance-`r` and distance-`r-1` shells and their counts.
3. State the one-column extension dictionary
   `d(ker[H_S|f])=d_S(f)+1`; classify the large-characteristic columns as
   MDS, NMDS, or Singleton defect at least two.
4. Add the configuration-free tangent, conjugate-secant, and incident-split-
   secant minimum-support aggregates and propagate them to complete family-
   aggregate NMDS weight enumerators.
5. Retain R5--R10 exact classifications as model cases, finite boundary data,
   and evidence for the general geometry; do not let them obscure the main
   theorem.
6. Keep all novelty language within the claim-specific C973 preaudit.  The
   classical affine deep shell, generic circuit identity, subset-sum formulas,
   and one-parameter NMDS recurrence are inputs or reframings, not novelty
   claims.

## Editorial target

Strengthen by replacement and compression.  The preferred result is no page
growth, or a net reduction, while moving the cofinite-GRS and NMDS consequences
into the introduction and main theorem hierarchy.  The target reader is a
coding theorist who may not already care about the internal polar-recursion
programme.

## Inputs

* `c973-2026-08-26-paper-successor-map.md`
* `c973-2026-08-26-simultaneous-marker-theorem.md`
* `c973-2026-08-26-deterministic-selector.md`
* `c973-2026-08-26-one-carry-module-theorem.md`
* `c973-2026-08-26-digit-stripping-exact-sequence.md`
* `c973-2026-08-26-cofinite-grs-transfer.md`
* `c973-2026-08-26-cofinite-grs-literature-preaudit.md`
* `c973-2026-08-26-cofinite-grs-tao-pass.md`
* `c973-2026-08-26-family-wise-minimum-support-count.md`

## Scope

Authoritative manuscript, supplement, bibliography, verification maps,
software-facing theorem documentation, release manifests, generated PDFs, and
the reed-solomon handoff are in scope.  Standalone mirror synchronization is
deferred until the authoritative tree passes every local gate; it then follows
the export-and-mirror conventions and requires no publication or push.

## Gates

* theorem/hypothesis audit against the C973 reports;
* citation and novelty audit at every promoted coding claim;
* canonical and TIT builds with warning/page/layout inspection;
* claim/dependency/evidence/verification-map synchronization;
* quick and full available release verification in proportion to runtime;
* hostile mathematical read, coding-theory read, `ej`, `tt`, and mystery
  ledger closeout;
* explicit commits at coherent validated checkpoints.
