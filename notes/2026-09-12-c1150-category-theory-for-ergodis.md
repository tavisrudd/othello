# C1150 — category theory for the Ergodis core and Evolve

**Lane**: `ergodis`
**Date**: 2026-09-12
**Status**: IN PROGRESS (started 2026-09-12)

## Goal

A literature study, not an engine change. Determine where category-theoretic
structure gives Ergodis (the compiled exact-optimization / contextual-quotient
core) and Ergodis Evolve (autonomous structure discovery, admission and repair)
a concrete lever for optimization, regularization, structure learning and
exploration, and rank the candidates as absorption targets with a stated
evidence gate for each.

## Primary source

- Vincent Abbott, arXiv:2604.07242 (read first, in full), then every other
  recent Abbott paper and coauthored work (categorical deep learning, string
  diagrams / neural circuit diagrams, functorial compilation of models to
  hardware). Record for each: the categorical structure used, what it buys, and
  whether the same structure appears in an Ergodis object (plans, quotients,
  representative catalogs, certificates, campaigns, repair schedules, feature
  DAG lowering, admission checks).

## Broad sweep (each theme gets its own section in the report)

1. **Compiler design**: categorical semantics of compilation and lowering;
   functorial/optics-based IR passes; equational rewriting and e-graphs seen
   categorically; how this maps onto Ergodis plan compilation and FeatureDag
   lowering.
2. **Search priors, non-neural**: categorical / compositional inductive biases
   (the cats4ai programme, geometric and categorical deep learning) reinterpreted
   for exact search, proposal distributions, and Evolve's discovery ordering.
3. **Solvers**: categorical formulations of constraint satisfaction, exact
   cover, MIP/SAT propagation, dynamic programming and min-plus algebra;
   compositional solving (open games, decorated cospans, sheaf-theoretic CSP
   and cohomological obstructions).
4. **Optimization and regularization**: categorical descriptions of gradient
   and non-gradient optimization (lenses/optics, parametric categories,
   reverse derivative categories), and what a categorical regularizer means
   for a discrete exact engine.
5. **Normalization and evolution**: canonical forms and quotients as
   coequalizers/colimits, rewriting to normal form, categorical accounts of
   evolutionary and genetic operators, and structure-preserving mutation for
   Evolve.
6. **Adjacent**: applied category theory for scientific computing and
   verification (categorical certificates, proof-relevant checking), since
   Ergodis certificates and independent verification are a natural fit.

## Deliverables

- Reading dossier at this path: one subsection per source with citation,
  verified claim summary, and the Ergodis object it touches.
- A ranked absorption table: candidate structure, Ergodis object, expected
  benefit, cheapest experiment, and evidence gate (measured, not argued).
- Incidental leads go to `notes/ergodis-discovery-track.md` with provenance.
- Follow `notes/literature-audit-conventions.md` for search recording and use
  the shared literature cache before fetching.

## Constraints

- No edits under `~/src/ergodis*`; product framing per the lane rule: prior
  art informs, never gates.
- No neural-network methods as deliverables; categorical structure only.

## Report

Not started.
