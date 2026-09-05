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
- **Ergodis software**: private `main` of `~/src/ergodis`, with sibling checkouts
  `~/src/ergodis-private`, `~/src/ergodis-evidence`, `~/src/ergodis-contrib`, each with its own
  `AGENTS.md`. It left this monorepo at tag `ergodis-split-base` (`aa49d68c3`) under C1058. Public
  export is gated on the release checklist; the filtered tree still has 67 lint findings.
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

### C1016 — order-2092 Hadamard reduction and search (private, `~/src/ergodis-private`)

Fourteen exact private reductions are banked with independent replay; the `g53` multiplier shard is
exactly empty, `g=91` is closed structurally, and `g41`/`g133` quotient-only pruning is exhausted.
The unrestricted `Z/523` route now runs a full-neighbourhood tabu step: it closes the order-six
`q29` margin shell (twelve distinct exact shell states) but plateaus on the `q174` view, and that
plateau is settled as search depth rather than arithmetic — no congruence constrains the deviation
at any modulus with prime factors below a million, and the plateau sits roughly 130 bits (±60) into
a 400-bit descent. The exhaustive two-transfer census over all twelve banked plateau states is
empty, which also closes group-scoped search.

**Next**: score the carrier `Z/522` rung above an exact `q174` hit — nothing scores it yet and it
has 174 free correlation classes of its own — and price a return to the plain `Z/523` spin shard
against it. Latest reports:
[paired transfer and the two-opt census](../2026-09-05-c1016-paired-transfer-and-the-two-opt-census.md),
[adversarial status review](../2026-09-05-c1016-adversarial-status-review.md). Concurrent public-core
edits remain foreign; do not absorb them into C1016. Provenance rules stand: proved structural and
exact computational reductions grant negative coverage, observed/evolved and heuristic predicates
never do. Every resume first reads `../ergodis-contrib/PERFORMANCE.md` and the shared playbook.

### C1017 — whole-core Ergodis performance-contract remediation (`~/src/ergodis`)

Allocation-counted hot loops, iterative traversal, complete Tiger layouts, contention-free worker
ownership, one-/parallel-mode counter A/B gates, and the public/private source partition. The
kernel-registry gate passes after the split repointed its evidence paths, and the filtered export
tree lints clean. One inherited item from C1062: the deferred-verification artifact carries no
unverified marker. Report:
[C1017 core remediation](../2026-08-30-c1017-ergodis-core-performance-contract-remediation.md).

### C1061 — compiled dynamic decision engines and the Tiger decoder

Probes through C1068 are closed. The default arm is `LEVEL_ROUTED`; on stim-generated weighted
circuit-level detector error models Tiger is ahead of PyMatching in 27 of 33 operating cells in
instructions and 30 in cycles, with zero weight and zero prediction disagreements on all 33. Log:
[`2026-09-03-c1061-exploration-log.md`](../2026-09-03-c1061-exploration-log.md), one companion
report per probe.

**Open successors**: a third code family to test the mean-degree crossover rule; the queue-struct
borrow split, the only remaining lever on the touch loop; the same certificate read for the
predecoder path; compile-time splitting of the non-observable stabilizer component; and the latency
tail beyond the ninety-ninth percentile.

**Waiting on Tavis**: routing the unspecialized graph path; the C1066 queue-discipline tradeoff
(compiling clearing/scanning from the graph's largest edge weight returns about half of what C1065
cost the published phenomenological grid and costs the weighted grid at most 0.4 per cent); and the
harness's PyMatching working-set asymmetry, which runs in Tiger's favour in cycles.

Surface-family numbers taken before 2026-09-04 are invalid — `RotatedSurfaceCode::new` had a
distance-one defect — and repetition numbers are untouched. Census and traffic runs need
`--features tiger-traffic`.

### C1062 — structural causal models as a context language

Probes 0–8 are done and every one of them now has its independent adversarial review (probes 1a, 1,
2, 3, 4, 6, 7 and 8 dated 2026-09-05, probe 5 on 2026-09-04). The closeout recommends dropping the
gated end-to-end demonstration, probe 9, so the task is ready to close on Tavis's call. The two
items worth an allocated successor are the compositional counterfactual crossover — probe 7's
reduction under probe 4's query — and whether the certificate can be emitted without compiling the
carrier at all. Brief `2026-09-04-c1062-ergodis-causal-brief.md`, routing log
`2026-09-04-c1062-exploration-log.md`, verdict `2026-09-05-c1062-closeout-synthesis.md`.

### C985 — Ergodis exact algebraic optimization paper

In progress as the optimization-facing sequel; it does not block C325 or C953. The 37-page
manuscript and README run on the corrected eight-workload benchmark protocol. The exact-distance
programme has closed `[[784,24,24]]`, `[[1496,194,20]]`, and `[[1496,198,16]]`, and the current gate
is an algebraically deduplicated weight-six discovery sweep with direct-sum rejection, seeking a
Pareto survivor with `k d^2 / n > 19.2`. Latest reports:
[completion compression and wide search](../2026-08-30-c985-completion-compression-and-wide-search.md),
[private adapters and parallel roots](../2026-08-30-c985-ergodis-private-adapters-and-parallel-roots.md).

### Ergodis workspace rules

`ergodis-private` is a library-only Cargo workspace root with three task crates (`tasks/tools`,
`tasks/gem-hunt`, `tasks/hadamard-2092`); no `src/bin` anywhere. Builds go to
`~/.cache/ergodis/target/`, A/B baselines are retained executables via `retain-bin.sh`, and
`cache-gc.sh` runs at task close. The C1016 cache under `~/.cache/ergodis/c1016/` is absent on this
host, so cold end-to-end `g41` replays need it regenerated first.

## Lane ownership

C277 created this paper-preparation lane and moved exactly C274--C276 into it. All C111--C224
theorem/formalization work remains pegged to `repaircodes`; `RepairCodes` and `RepairPorts` Lean
names are unchanged. Future manuscript, clean-export, citation, and paper-release tasks use
`[complete-ports]`.
