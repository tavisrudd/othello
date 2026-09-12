# C1151 — category theory for Ergodis, capability-first second pass

**Lane**: `ergodis`
**Date**: 2026-09-12
**Status**: IN PROGRESS (started 2026-09-12)
**Predecessor**: `2026-09-12-c1150-category-theory-for-ergodis.md`

## Why a second pass

C1150 was run with a literature-audit posture and an over-narrowed brief ("no gradient and
no network"). Tavis's framing: the goal is improving what Ergodis can do, not novelty or
academic priority. Gradient search and small simple neural networks are in scope; only
methods that depend on deep/large nets are out. GPU acceleration (WebGPU / Rust GPU bindings) is available for larger Evolve structure searches, so GPU-specific cost models are in scope. Prior art is a template
to absorb, never a gate.

## Scope

Two dossier halves, continued by the same two subs that hold the C1150 context:

- Part A (`2026-09-12-c1151-part-a-gradient-priors-capability.md`): gradient-shaped
  material dropped by C1150 (optics/Para formulations of Lagrangian and LP duality,
  continuous relaxations as bound sources, reverse-derivative categories, small learned
  heuristics as proposal or branching scorers), Markov categories for Evolve's proposal
  distributions, and algorithm-depth reads of C1150 part A rows 1–4 including what
  pyncd/tsncd implement for negative information.
- Part B (`2026-09-12-c1151-part-b-galois-quotients-implementations.md`): Galois
  connections and abstract interpretation for bounds and admission; bisimulation and
  partition refinement as the algorithmic content of contextual quotients; symmetry
  (orbits, lex-leader, orbital branching, canonical augmentation) for C1016 and Evolve;
  Lawvere theories for the FeatureDag algebra and polynomial functors for campaigns; and
  algorithm-depth reads of C1150 part B rows 1–5 with their reference implementations
  (egg/egglog, VeriPB, OpenFst, Catlab).

Both parts: every source carries a read-depth field; PDFs go to the shared cache; each
absorption row carries the six C1150 fields plus a "needs gradient / needs small NN /
neither" column; anything set aside on the first pass as standard ground is named and
assessed on capability alone.

## Deliverable

A merged capability ranking appended here, superseding the C1150 ranking where they
disagree, with the implementation slices to allocate.

## Report

Not started.
