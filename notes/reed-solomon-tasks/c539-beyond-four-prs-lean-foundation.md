# C539 — shared Lean foundation for the beyond-four PRS paper

**Lane:** `reed-solomon` · **Status:** queued after C538 theorem-adoption freeze

## Objective

Build the common paper-facing Lean interface for projective Reed--Solomon deepness, Hankel kernels,
split squarefree kernel members, divided-power contractions, persistent families, and explicit
synthesis hypotheses.  Produce the exact formal-coverage ledger that C540--C544 consume.

## Work and acceptance

- Audit the existing `RelativeConicArcs` APIs and C517 closure before choosing module boundaries.
- Formalize the common syndrome/deepness-to-Hankel-kernel dictionary at the maximal reusable
  strength supported by the proved paper statements.
- Reuse the existing redundancy-nine contraction API rather than creating a competing hierarchy.
- State visible structures for external covering-radius, component, rational-point, and orbit
  exhaustion inputs; do not encode them as project-local axioms.
- Land a scholarly-public import gate, scoped build, exact axiom audit, and theorem coverage matrix.
- Use no task IDs, workflow prose, internal notes, or novelty claims in Lean sources.

Before any Lean operation, read `lean/AGENTS.md` completely.

## Owned paths

- new stable PRS foundation modules and gates under `lean/RelativeConicArcs/`
- `notes/2026-07-23-c539-beyond-four-prs-lean-foundation.md`
- the paper formalization ledger and `reed-solomon` handoff

