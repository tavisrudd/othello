# C827: Post-integration Milnor--Serre copy edit

**Lane:** `golden`

**Status:** active

## Objective

Give the integrated Golden quantum-statistics manuscript a final
Milnor--Serre exposition and sentence-level copy-edit pass without changing
its mathematical claims, hypotheses, trust boundaries, or operational scope.

## Editorial tests

1. The abstract names the object, principal theorem, mechanism, and boundary
   without becoming a result inventory.
2. The introduction reveals the theorem chain before literature and
   implementation detail.
3. Each section opening and paragraph has one identifiable job.
4. Proofs expose the causal mechanism at the genuine bottleneck and compress
   routine algebra.
5. Notation has one role per symbol; discipline-specific terms receive one
   concise translation at first use.
6. Repetition, workflow language, defensive prose, stacked abstractions, and
   canned transitions are removed.
7. The mathematical, literature, verification, and experimental boundaries
   remain unchanged.

## Gates

- theorem/section-opening audit;
- paragraph-job and notation audit;
- claim-preservation diff review;
- complete paper-local `make check`;
- strict warning scan and affected-page visual inspection;
- clean extracted-package check;
- updated submission hashes and a dated editorial report.

