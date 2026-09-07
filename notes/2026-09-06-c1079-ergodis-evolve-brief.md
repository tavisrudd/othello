# C1079 — ergodis-evolve review and synthesis plan

**Lane**: `ergodis`
**Status**: QUEUED; scope clarified by Tavis on 2026-09-06.

## Authoritative product intent

Build a powerful autonomous system that discovers structure in a large search/solve space,
identifies applicable theorems and their parameters, and selects effective quotients/reductions
of that space. A Unix-socket control interface permits steering; autonomy is the ultimate goal.
AlphaEvolve, CEGAR, and related systems are inspirations, not a prescription to copy one design.
This explicit user direction takes precedence over conflicting inherited descriptions of evolve.
The socket is a control surface for the autonomous system, not its defining limitation.

## Review scope

Bring together the version in the Ergodis core (`~/src/ergodis`), the private implementation and
experiments (`~/src/ergodis-private`, largely C1016), and spikes extending either. Locate the
relevant spikes through the owning checkout guides and narrow source/document references;
read each checkout’s `AGENTS.md` before reviewing it. Preserve ongoing task ownership.

Inventory implemented capabilities, experimental capabilities, stated intentions, and measured
results separately, with exact source/revision provenance. Trace conflicting descriptions to
their evidence and judge them against the authoritative intent above; do not infer correctness
from which model authored a document. Identify stale or contradictory guidance and propose
specific corrections. Review correctness, exactness/certificate boundaries, integration risks,
and meaningful test/evidence gaps as inputs to synthesis.

## Required deliverables

1. A map of core, private/C1016, and spike capabilities: what each contributes, overlaps,
   contradictions, missing pieces, and what can be retained or combined.
2. A coherent proposed architecture for autonomous structure discovery, theorem/parameter
   selection, quotient construction, validation/refutation, evaluation, and continued search.
   Explain how feedback and reusable discoveries improve subsequent attempts. Assess the
   relevance of AlphaEvolve, CEGAR, and related designs using primary sources when researched.
3. A clear relationship between autonomous operation and Unix-socket steering: inspect the
   existing protocol, then specify necessary control, observation, and persistence behavior.
4. Explicit evidence boundaries: distinguish conjectured/evolved candidates from established
   exact reductions; explain how candidates earn admission and how counterexamples refine
   them. Preserve C1016’s rule that heuristic predicates do not grant negative coverage.
5. Define what “best” and “optimally quotient” mean operationally: objective, compilation and
   discovery cost, solve/search savings, resource budgets, and any tradeoffs. Separate empirical
   selection from any mathematically proved optimality guarantee; do not silently promise the
   latter or impose an unapproved single metric.
6. A recommended staged convergence plan with concrete retain/adapt/retire decisions,
   dependencies, acceptance gates, representative workloads and controls, and the highest-value
   first implementation step. Include severity-ranked review findings with file/line evidence
   and targeted reproduction checks where applicable.

## Boundary and acceptance

This task produces a review and concrete, reviewable synthesis plan, not an implementation merge
or architecture migration. Present consequential architecture choices for Tavis’s decision after
completing the evidence and recommendation. Do not narrow the product into a manual controller,
a fixed theorem catalogue, or a single C1016 search heuristic without explicit justification and
approval. Do not expand into unrelated engine remediation or manuscript work.

Acceptance: one evidence-backed account reconciles the existing implementations and intentions,
recommends the best autonomous-system direction, identifies unresolved choices honestly, and
provides an executable sequence of scoped follow-up work. Allocate follow-ups only when warranted
through the normal task-ID process. Planned report:
`notes/2026-09-06-c1079-ergodis-evolve-review.md`.
