# Bounded recovery structures paper preparation

**Lane**: `complete-ports`

**Purpose:** routing only. Closed dispositions, measurements, proof summaries, and correction
trails belong in the dated task reports and in the archive companion,
[`2026-07-17-complete-ports-paper-archive.md`](2026-07-17-complete-ports-paper-archive.md).

**Date**: 2026-09-05
**Status**: ACTIVE. The 40-page manuscript passes its 31-claim, four-Lean-terminal, and
84-file Ergodis public-surface gates. The remaining paper route is C325 then C953, with C955 after.
No push and no deposit.

**Discovery companion**: [complete-ports discovery track](../complete-ports-discovery-track.md).

## Identity and locations

- **Theorem source lane**: archived [`repaircodes`](done/2026-07-13-projective-completion-repaircodes.md).
- **Private paper**: [`complete-repair-ports`](../../papers/complete-repair-ports/README.md).
- **Canonical identity**: `complete-ports` — *Exact Compositional Transfer of Bounded Linear
  Recovery*. Approved license MIT.
- **Standalone paper repository**: `tavisrudd/compositional-recovery` at
  `~/src/math-papers/compositional-recovery`, local commit `80c600f` (40-page revised manuscript,
  verified, unpushed). The authority has since dropped `ergodis/`, so the next sync needs a prior
  `git rm -r ergodis` commit there.
- **Ergodis engine**: the engine, its benchmark programme, and the C985 optimization sequel live in
  the [`ergodis`](2026-09-05-ergodis-lane.md) lane.
- **Expert dossier** (read before nontrivial proof development or formalization):
  [`papers/expert-profiles/05-complete-repair-ports.md`](../../papers/expert-profiles/05-complete-repair-ports.md).

## Goal

Produce one short theorem-led complete-ports manuscript whose main proof spine consists of complete
human proofs and whose formal coverage is stated claim by claim. Computations, finite tables,
certificates, and replay machinery may support appendices but may not carry a body theorem. Public
release remains a separate fresh-history operation that never publishes the private monorepo or its
history.

## Main-proof admission rule

A result enters the body proof spine only when it has:

1. an exact stable paper statement;
2. a complete human proof exposing the mathematical mechanism;
3. an explicit formal-coverage classification;
4. exact attribution of every imported mathematical input; and
5. no computation or certificate in its logical dependency chain.

Only the associated-pair exact sequence is currently Lean-complete. Every stronger theorem is
marked absent from the paper-local Lean package and is supported by its human proof and cited
classical inputs.

## Current paper spine

Title: *Exact Compositional Transfer of Bounded Linear Recovery*.

1. recovery sets, normalized recovery equations, and stochastic repair as distinct forgetful layers;
2. the associated nested code pair and its exact sequence;
3. relative generalized Hamming weights as the exact minimum helper costs for recovering subspaces
   of each dimension;
4. exact ungated finite arbitrary-rank transfer from target-normalized joint coset-support costs
   and the complete outer functional dual;
5. the RGHW outer-distance criterion and the pointed weighted formula as specializations of that
   exact optimization;
6. the rank-one escape cost as the exact bottleneck for simultaneous bounded transfer across all
   recoverable target dimensions;
7. the best-target GHW identity, cooperative-locality min--max corollary, and MDS rigidity;
8. positive-density realization and bounded service-rate-region transfer;
9. reliability and coefficient-presentation separations beyond the RGHW hierarchy;
10. the projective simplex code as the principal non-MDS application; and
11. compact formal-verification and reproducibility appendices.

Use only established coding-theory terminology. “Associated nested code pair” is a literal
description of $K_P\subseteq D_P$, not a coined term. Research and referee reports must contain
factual findings and result ordering only; no percentiles, venue-prestige judgments, or
overall-quality grades that could bias later cold reads.

## Scope

In: the shortening--puncturing pair of the inner dual and its RGHW interpretation, exact ungated
finite rank-stratified transfer through joint prescribed-coset support optimization, the
outer-distance RGHW and pointed weighted specializations, exact repeated-concatenation composition
of the labelled costs, best-target GHW and cooperative-locality consequences, the symmetric MDS
staircase and rigidity, positive-density and service-rate transfer, reliability and
coefficient-presentation separations, the projective-simplex family, and the C984 finite higher-rank
quotient.

Out: extended EXIT, deletion--contraction, secondary geometries, vector bandwidth, generic
coefficient optimization, BGS packing, and the C980 probe census, rank-stratified algorithms,
Pareto, fixed-batch packing, and multi-target state algebras.

## Publication boundary

Every paper is a fresh-history allowlisted export. Never publish, fork, history-filter, or broadly
copy the private monorepo. This paper's formal companion is the paper-owned Lean 4 project, built
against a pinned Mathlib revision and listed in its exact 37-file distribution manifest; monorepo
trust files and local `lean/AGENTS.md` norms are excluded. The shared Lean monorepo remains
separately owned. Never copy raw build trees or selected `.olean` files.

Publication, push, and deposit remain gated on C325 and C953; the approved repository metadata does
not authorize any of those external actions. Shared-Lean extraction is planned under
[C287](../2026-07-17-c287-shared-lean-extraction-plan.md), remains build-system-owned, and is
neither evidence for nor a release dependency of the paper-local companion. C220 remains omitted,
and the prior monolithic draft and its cold reads are inputs, not acceptance of the modular
hierarchy.

## Active frontiers

### Paper route

1. **C325** — appendix-only consolidated executable verifier reproducing every retained finite
   appendix table from a versioned manifest, with independent replay and per-claim evidence routes.
2. **C953** — aggregate referee/export gate after C325: theorem, human-proof, Lean adequacy, axiom,
   terminology, literature, computation-independence, rendered-manuscript, and hostile referee
   audits, then the draft-readiness verdict.
3. **C955** — coefficient-presentation spectrum, after C953.

## Lane ownership

C277 created this paper-preparation lane and moved exactly C274--C276 into it. All C111--C224
theorem/formalization work remains pegged to `repaircodes`; `RepairCodes` and `RepairPorts` Lean
names are unchanged. Future manuscript, clean-export, citation, and paper-release tasks use
`[complete-ports]`. On 2026-09-05 the Ergodis engine/benchmark/tooling tasks (C985, C1016, C1017,
C1031-C1033, C1040-C1048, C1052, C1061, C1062) were re-pegged to the `ergodis` lane; this lane keeps
the manuscript route C325, C953, C955 and C964.
