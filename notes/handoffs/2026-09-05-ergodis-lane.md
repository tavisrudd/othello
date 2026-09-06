# Ergodis compiled exact-optimization engine

**Lane**: `ergodis`

**Purpose:** routing only. Closed dispositions, measurements, proof summaries, and correction
trails belong in the dated task reports and in the archive companion,
[`2026-09-05-ergodis-lane-archive.md`](2026-09-05-ergodis-lane-archive.md).

**Date**: 2026-09-05
**Status**: ACTIVE. Split out of `complete-ports` on 2026-09-05. C1016 (order-2092 Hadamard
reduction), C1061 (compiled dynamic decision engines / Tiger decoder), and C1062 (structural causal
models as a context language) are in progress; C1062 is ready to close on Tavis's call. C1017 (core
performance-contract remediation) and C985 (optimization-facing paper) are in progress. The
benchmark, evolve-capability, tooling, and visualization tasks (C1031-C1033, C1040-C1048, C1052)
are queued or in progress per their own rows.

**Discovery companion**: [ergodis discovery track](../ergodis-discovery-track.md).

## Identity and locations

- **Ergodis software**: private `main` of `~/src/ergodis`, with sibling checkouts
  `~/src/ergodis-private`, `~/src/ergodis-evidence`, `~/src/ergodis-contrib`, each with its own
  `AGENTS.md`. It left this monorepo at tag `ergodis-split-base` (`aa49d68c3`) under C1058. Public
  export is gated on the release checklist; the filtered tree still has 67 lint findings.
- **Motivating manuscript**: the [`complete-ports`](2026-07-17-complete-ports-paper.md) lane owns
  the *Exact Compositional Transfer of Bounded Linear Recovery* manuscript that originally motivated
  this engine; that lane keeps its own manuscript route.

## Goal

Ergodis is the private compiled exact-optimization / contextual-quotient engine (`~/src/ergodis` and
its sibling checkouts) plus its benchmark, capability, tooling, and paper work. This lane owns the
engine, its performance contract, its benchmark and evidence programme, its exploratory probes, and
the C985 optimization-facing paper.

## Active frontiers

### C1016 — order-2092 Hadamard reduction and search (private, `~/src/ergodis-private`)

The frontier, the closed dispositions, the routing to every dated sub-report, and the open-move
order all live in the task card,
[C1016 order-2092 reduction and search](../2026-08-30-c1016-ergodis-hadamard-quotient-synthesis.md),
with its append-only companion
[archive](../2026-08-30-c1016-ergodis-hadamard-quotient-synthesis-archive.md). Read the card on
resume; it is the current-state map for this task.

**Next**: the card's open moves, in its order — widen or replace the margin-fibre move set against
the control gate the card names, then replicate the per-shell sweep on the tail shells; a return to
the plain `Z/523` spin shard is still the standing alternative. Concurrent public-core edits remain foreign; do not absorb them into C1016.
Provenance rules stand: proved structural and exact computational reductions grant negative
coverage, observed/evolved and heuristic predicates never do. Every resume first reads
`../ergodis-contrib/PERFORMANCE.md` and the shared playbook.

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

C1069 closed the predecoder half of that read: the predecoder has no per-shot certificate, its
audited-sound margin commits nothing, and the claims that had outrun it — the pipeline's equality
test, the clean-ball skip on the surface tiers, the sparse/dense order, the audit's scope — are
corrected with a test each. Report:
[C1069 predecoder certificate read](../2026-09-05-c1069-predecoder-certificate-read.md).

**Open successors**: a third code family to test the mean-degree crossover rule; the queue-struct
borrow split, the only remaining lever on the touch loop; compile-time splitting of the
non-observable stabilizer component; and the latency tail beyond the ninety-ninth percentile.

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

### C1070 — exact compositional leakage analysis for hierarchical linear encodings

All probes done and reviewed; ready to close on Tavis's call. Nine probes closed (1, 5, 3, 2, 0, 6,
8, 9; probes 4 and 7 not run), each with a dated report, generator, certificate, and independent
cross-check. Verdicts, the product claim, the ship order, open successors, and the consolidated
mystery ledger are in the
[closeout synthesis](../2026-09-06-c1070-closeout-synthesis.md); the brief is
`../2026-09-06-c1070-ergodis-compositional-leakage-brief.md`. Product framing: prior art informs,
never gates. **Waiting on Tavis**: close C1070; whether to allocate successors for the uniform-cost
chain theorem, the schema migration, and probes 4 and 7; whether a paper is carved out. Foreign
issue seen in passing: the `fabric_routing` retained-tree-versus-Dijkstra test fails at `de53b6c` in
`ergodis-private`, a module owned by another lane; an Opus fix is in review.

### C1072-C1074 — finite-geometry absorption targets from the relconic discovery track

Queued, not started. Three leads logged on 2026-09-06 in
[`2026-07-16-relconic-discovery-track.md`](../2026-07-16-relconic-discovery-track.md), routed here as
Ergodis instance families rather than relconic manuscript work; no manuscript edit in any of them.
C1072 compiles the equality case of the `PG(3,q)` secant-local coverage bound as a symmetric exact
cover over closed block partitions of `E(K_k)`. C1073 compiles minimum ordinary completion of a
conic-complete arc as independent domination on a union of chord-involution matchings. C1074 turns
the Farr–Lisoněk free-pair cap constructions into a test-cap corpus for the concentration condition
in the `n ≥ 4` programme. Each row carries its own provenance pointer; read the discovery-track
entry before starting.

### C985 — Ergodis exact algebraic optimization paper

In progress as the optimization-facing sequel to the `complete-ports` lane's manuscript; it does not
block that lane's C325 or C953. The 37-page manuscript and README run on the corrected
eight-workload benchmark protocol. The exact-distance programme has closed `[[784,24,24]]`,
`[[1496,194,20]]`, and `[[1496,198,16]]`, and the current gate is an algebraically deduplicated
weight-six discovery sweep with direct-sum rejection, seeking a Pareto survivor with
`k d^2 / n > 19.2`. Latest reports:
[completion compression and wide search](../2026-08-30-c985-completion-compression-and-wide-search.md),
[private adapters and parallel roots](../2026-08-30-c985-ergodis-private-adapters-and-parallel-roots.md).

## Ergodis workspace rules

`ergodis-private` is a library-only Cargo workspace root with three task crates (`tasks/tools`,
`tasks/gem-hunt`, `tasks/hadamard-2092`); no `src/bin` anywhere. Builds go to
`~/.cache/ergodis/target/`, A/B baselines are retained executables via `retain-bin.sh`, and
`cache-gc.sh` runs at task close. The C1016 cache under `~/.cache/ergodis/c1016/` is absent on this
host, so cold end-to-end `g41` replays need it regenerated first.

## Lane ownership

This lane was split out of `complete-ports` on 2026-09-05 and owns C985, C1016, C1017,
C1031-C1033, C1040-C1048, C1052, C1061, C1062, C1070, C1072-C1074. Future Ergodis engine, benchmark, tooling,
capability, and Ergodis-paper tasks use `[ergodis]`. The bounded-recovery manuscript work (C325,
C953, C955, C964) stays on `[complete-ports]`.
