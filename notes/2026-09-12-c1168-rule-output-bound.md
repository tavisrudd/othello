# C1168 — rule-output-sensitive convergence

**Lane**: `ergodis`
**Date**: 2026-09-12
**Status**: IN PROGRESS.

Prove fixedness within `min N (M + 1)` for the existing bounded min-plus program,
where N counts scalar coordinates and M counts distinct rule outputs. The first
round loads facts; every later improvement must occur at a rule output. Preserve
the universal sharp N theorem, certificate schema and existing runtime behavior.

Add the tighter semantic certificate and a conversion of a checked incremental
result using that bound. Validate zero coordinates, no-rule programs, the sharp
chain family and the existing relational distance programs. Rebuild affected
owned Lean gates and audit the new terminals. Earlier paired measurements remain
pinned to their recorded source revision; no new timing claim is inferred.
