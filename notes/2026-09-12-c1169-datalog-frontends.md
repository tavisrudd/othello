# C1169 — Datalog frontend study

**Lane**: `ergodis`
**Date**: 2026-09-12
**Status**: IN PROGRESS.

Study source parsing, syntax trees, diagnostics and frontend separability in
Nemo, Ascent and Crepe. Datafrog and Differential Dataflow supply backend
machinery, outside this study. Ergodis retains semantic admission/lowering,
rules handling, joins and execution under its performance discipline.

User preference: own the parser if the admitted grammar is straightforward.
Evaluate foreign frontends primarily for useful grammar/diagnostic patterns;
do not assume an external parser dependency is the desired result.

Acceptance: source-linked assessment of extraction costs and supported syntax,
a recommendation with an explicit language boundary, and a scoped future
implementation gate. This study does not install dependencies, implement a
language, select a foreign evaluator or claim measured parser performance.
