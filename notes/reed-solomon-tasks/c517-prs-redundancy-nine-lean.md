# C517 — Lean formalization of the PRS redundancy-nine theorem

**Lane:** `reed-solomon` · **Date queued:** 2026-07-23 · **Gate:** after C516

## Objective

Formalize C516's final theorem and its load-bearing proof in Lean, preserving the exact field,
characteristic, nondegeneracy, and exceptional-stratum hypotheses proved on paper.

The formalization must cover:

1. the divided-power first-polar contractions and ordered forbidden-marker semantics used at
   redundancy nine;
2. the binary-quartic carrier and the residual-quadratic determinant/discriminant identities;
3. the diagonal, collision, squarefreeness, and exceptional-stratum exclusions;
4. the finite-field rational-point implication from C516's geometric theorem;
5. the resulting PRS deep-syndrome and orbit statement, with no theorem-boundary strengthening.

## Entry gate

- C516 is complete and its theorem statement, dependency graph, and exceptional hypotheses are
  frozen.
- Before any Lean edit, generator, build, or process intervention, read `lean/AGENTS.md` in full
  and follow its shared-library and build-safety protocol.
- Choose module boundaries only after auditing the relevant existing Lean APIs; do not encode the
  paper's coordinate conventions as a competing foundational hierarchy.

## Acceptance gate

- Zero new axioms, `sorry`, or hidden native-decide trust.
- The public theorem statement matches C516 clause for clause.
- Load-bearing symbolic identities are kernel-checked; any finite certificate has an explicit
  generator/checker boundary compliant with the nested Lean guide.
- Scoped build, terminal axiom audit, and dependency/path audit pass.
- The handoff records exact proved coverage and any paper clauses intentionally left outside the
  formal theorem.

## Deliverable

Task report: `notes/2026-07-23-c517-prs-redundancy-nine-lean.md`.
