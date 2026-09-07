# C1079 — ergodis-evolve review and synthesis plan

**Lane**: `ergodis`
**Status**: IN PROGRESS; evidence collection authorized on 2026-09-06 using Terra sub-agents.

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
Recover existing repo-local notes and previous research reports, especially C985, before
proposing new mechanisms or terminology. Tavis explicitly requested Terra sub-agents for this
evidence collection.

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

## Search mode, provenance, and validation are distinct

Explicit user clarification: distinguish the search’s mode (proof-generating or heuristic) from
where its theorems and parameters came from as evolve generates and evolves them. The synthesis
must define these dimensions separately in its proposed data model, runtime policy, artifacts,
and Unix-socket observations/control:

- **Search mode** specifies the run’s obligations and permissible conclusions. Proof-generating
  search must discharge the obligations needed for its claimed reductions and coverage. Heuristic
  search may explore with unvalidated candidates but cannot turn their pruning into proved
  negative coverage. State what mode changes mean for accumulated results and coverage.
- **Provenance** records origin and derivation for theorem candidates and parameter candidates
  individually: imported or human-supplied, generated, evolved, or composed; exact parent
  versions, generation/mutation steps, and relevant run/input/configuration identifiers. Preserve
  lineage through validation and reuse rather than replacing origin with a trust label.
- **Validation status and scope** record what has actually been established, with supporting
  evidence, assumptions, applicability domain, and parameter side conditions. Distinguish an
  established theorem from an unproved generated conjecture, and a theorem’s proof from the
  validity of a particular parameter instantiation. Mutations require explicit revalidation or
  justified evidence reuse; descendants do not automatically inherit their parents’ guarantees.

These dimensions must not be conflated: an evolved candidate can become validated and usable in
proof-generating search; a hand-written or imported candidate is not automatically established.
Heuristic search can use proved theorems, and heuristic candidate selection can support a
proof-generating run when all soundness obligations for the resulting claims are discharged.
Assess concrete examples of these combinations in the existing implementations and identify
where current terminology, admission rules, or artifacts collapse the distinctions.

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
