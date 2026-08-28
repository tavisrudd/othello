# C990 — AME-LU conservative appendix compression

**Lane:** `ame-lu`
**Status:** in progress
**Scope:** Paper I only; no Lean, mirror, export, push, deposit, or submission changes

## Objective

Compress Appendix B of *Robust Local-Unitary Rigidity of Stabilizer AME
States* while preserving every substantive theorem and keeping the proofs
easy to referee.  Prefer the Lean-backed two-uniform core, remove duplicated
group bookkeeping and extended commentary, and compress the manuscript-only
`k`-uniform chain structurally rather than deleting its conclusions.

## Acceptance gates

1. No surviving hypothesis, constant, quantifier, or conclusion changes.
2. Appendix B retains the local-generator identity, discreteness, local
   stability, `k`-uniform stability/radius/ceiling, and exact-branch
   decomposition results.
3. `make check` is warning-free and affected pages render cleanly.
4. Resumed cold mathematical and exposition readers identify no essential
   omission or hidden proof gap; accepted findings are repaired.
5. Paper-local theorem, verification, formalization, README, and ownership
   surfaces remain synchronized.

## Working baseline

- authority commit: `db68f6eb9`
- PDF: 39 A4 pages
- SHA-256: `b7fa88d3efd4eb78a7bd9126987031c8c17fca1aba052e23d09f6b8e9b85b7b7`

## Compression pass

Appendix B is reduced from roughly nine rendered pages to seven while
retaining all twelve named lemmas, theorems, propositions, and corollaries.
The pass:

- shortens the product-Lie and local-generator proofs without changing their
  statements;
- condenses the literature, non-Clifford counterexample, Fisher-metric, and
  exact-sequence discussions;
- preserves the full `k`-uniform moment theorem, radius corollary, linear
  ceiling, Reed--Muller obstruction, and both explanatory figures; and
- compresses the compactness argument for exact branch selection.

The warning-free build is 37 A4 pages. Cold mathematical and exposition
reads are pending.
