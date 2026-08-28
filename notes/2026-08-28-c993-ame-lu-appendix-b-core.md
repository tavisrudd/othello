# C993 — Compress AME-LU Appendix B to its structural core

**Lane:** `ame-lu`
**Status:** complete
**Scope:** Paper I authority and synchronized abstract/README surfaces if
needed; no Lean, mirror, push, deposit, or submission action

## Objective

Retain Appendix B's genuinely explanatory two-uniform core—local-generator
isometry, discreteness of projective product symmetries, and local quadratic
stability—while removing the independent higher-uniformity radius study,
ceiling and Reed--Muller examples, second comparison figure, redundant compact
branch-selection corollary, and tangential two-unitary application.

## Gates

1. No main-text theorem, proof, hypothesis, constant, or cross-reference loses
   a dependency.
2. The retained appendix remains self-contained and explains exactly what
   extends beyond stabilizer states.
3. Introduction, conclusion, figure references, and verification boundary
   accurately describe the reduced appendix.
4. Warning-free build, rendered transition inspection, page-count comparison,
   and focused accessibility/mathematical review.

## Result

Appendix B now contains only the stabilizer-independent structural core:

- the local-generator isometry from pairwise maximal mixing;
- finiteness of the projective product-unitary symmetry group for every
  two-uniform pure state;
- the exact local quadratic stability estimate and its Fisher-metric
  interpretation; and
- a direct comparison explaining why this infinitesimal result neither
  identifies the finite group nor replaces the main cleaning theorem's
  explicit entry radius and branch selection.

Removed were the `k`-uniform Taylor hierarchy, certified-radius growth and
ceiling, Reed--Muller obstruction family, the redundant compactness-based
branch-selection corollary, the optional sharper-constant paragraph in
Section 6, the two-unitary application, and the second comparison figure.
The remaining defect-landscape figure was moved from Appendix B into Section
6, where its cleaning threshold is proved.  Current theorem, novelty, trust,
metadata, and section-map surfaces were synchronized; the retired statements
remain recoverable from git history.

The main exact and quantitative theorems, their hypotheses, constants, and
generality are unchanged.  `make check`, `make release-check`, warning and
undefined-reference scans, `git diff --check`, and rendered transition review
all pass.  The release gate verifies 18 public artifacts and the pinned
83-artifact formal companion.  A cold reader returned `GO` at confidence
0.90; its sole nonblocking float-placement note was repaired by fixing Figure
3 at its Section 6 call site.  The paper is 34 pages, down from 38, and the
PDF SHA-256 is
`2bbb76fee28ee4762ad65fd19a3f7eabcdea8ed18dbb6b7937850db0186324d1`.
