# C1061 probe 14: design ADR for the generic dynamic decision layer

**Lane**: `complete-ports`
**Date**: 2026-09-03
**Artifact**: `~/src/ergodis-private/docs/adr/0001-generic-dynamic-decision-layer.md`
(ergodis-private `17e753f`; establishes `docs/adr/`)
**Status**: **proposed, for Tavis; no migration decided**

Eight elements, each with its measuring probe, implementing modules, generic vs domain-specific
split, and core vs private recommendation. Recommended for the core: the `OpenProblem` trait with
law tests and semirings, the retained tree, the event-class taxonomy, and the certificate chain
(named the cheapest first step, fully generic, already following core certificate conventions).
Domain-bound elements stay private; the transducer endpoint stays labelled an accelerator with a
fail-closed path. Five measured rules of thumb stated with evidence; nineteen negatives listed in
one section; consolidation debt found while surveying: the retained tree exists four times, the
tropical offset/residual split four times, the induce-a-finite-table idea twice. Ten open
questions; question 1 (does the trait survive both a matrix summary and a function summary) is the
gate on any extraction. Shared-target-directory worktree hazard recorded as ADR section 7.
