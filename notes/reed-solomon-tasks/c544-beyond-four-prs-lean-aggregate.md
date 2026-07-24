# C544 — aggregate Lean and trust gate for the beyond-four PRS paper

**Lane:** `reed-solomon` · **Status:** queued after C540--C543

## Objective

Close the merged paper's formal-verification boundary by aggregating C539--C543 with the existing
redundancy-nine C517 terminal and reconciling every manuscript claim with its exact proof route.

## Acceptance gate

- One paper-facing import closure reaches every adopted Lean terminal and no unadopted theorem.
- Exact-target builds and the aggregate trace-only gate pass through the guarded shared-library
  protocol.
- The complete transitive closure receives the referee-facing prose/name/path review required by
  `lean/AGENTS.md`.
- A tracked axiom audit reports only standard Lean/mathlib axioms plus any explicitly disclosed
  external hypotheses represented in theorem statements; no project-local axiom or hidden native
  oracle remains.
- `papers/beyond4_prs/` contains a declaration-level proof map, reproducibility map, and trust
  statement agreeing with the manuscript and formal sources.
- Any theorem not fully formalized is labelled at its precise mixed-verification boundary rather
  than silently promoted.

Before any Lean operation, read `lean/AGENTS.md` completely.
