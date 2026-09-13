# Ergodis compiled exact-optimization engine

**Lane**: `ergodis`

**Purpose:** current routing only. Closed dispositions, measurements, proof summaries and
correction trails live in dated reports and the append-only
[`2026-09-05-ergodis-lane-archive.md`](2026-09-05-ergodis-lane-archive.md).

**Date**: 2026-09-13
**Mode**: intent-based.
**Status**: ACTIVE. Immediate engineering frontiers are C1170 (owned Rel-rich frontend) and
C1177 (private rule kernels/performance). C1143, C1130, C1016,
C1017, C1061 and C985 remain in progress. C1062 and C1070 await Tavis's close call.

**Discovery companion**: [ergodis discovery track](../ergodis-discovery-track.md).

**Architecture context**: for architecture, shared API/schema, execution, model/query or
portability work, read `notes/ergodis-architecture-context.md` after this handoff. It is private,
not-to-ship contributor guidance. Narrow UI/admin work does not require the full context.

## Identity and boundaries

- **Ergodis software**: private `main` of `~/src/ergodis`, with sibling checkouts
  `~/src/ergodis-private`, `~/src/ergodis-evidence` and `~/src/ergodis-contrib`, each governed by
  its own `AGENTS.md`. The software left this monorepo at tag `ergodis-split-base` (`aa49d68c3`).
- C1175 validates the regenerated 472-row filtered export manifest and a lint-clean filtered
  tree. Nothing has been published to GitHub. Evidence-publication, paper-deposit,
  copyright/contact, product-scope and public-CI decisions remain with Tavis.
- The [`complete-ports`](2026-07-17-complete-ports-paper.md) lane owns the motivating *Exact
  Compositional Transfer of Bounded Linear Recovery* manuscript. This lane owns the private
  engine, its performance contract, benchmarks, capabilities, tooling and C985 paper.

## Immediate frontiers

### C1170 — owned Rel-rich frontend (in progress)

Current contract and measurements: `../2026-09-12-c1170-owned-rel-frontend.md`; source study:
`../2026-09-12-c1169-datalog-frontends.md`. Private `a644dad` establishes finite native/WASM
parity on 142 cases / 325,403 canonical bytes, including the reviewed lexer repairs. This is a
finite parity gate, not a grammar oracle or complete syntax/admission claim.

**Next:** retain interleaved parser-performance measurements, then close recovery and remaining
syntax/admission gaps. Ergodis retains lowering, rules, joins and execution; no external evaluator
or backend is adopted. Tree-sitter and executable reference semantics remain deferred.

### Rule-contract programme — C1177 queued

Programme and sequencing: `../2026-09-12-ergodis-rule-contract-programme.md`; audit:
`../2026-09-12-c1171-rule-programme-review.md`.

- C1172: guarded Lean axiom audit and `WeightedRules` root target, with the documented
  separate/default-target caveat (`../2026-09-13-c1172-lean-audit-gate.md`, core `801e732`).
- C1173: one-pass support-witness least-fixedness certificates versus replay, including raw scalar
  and cyclic-program coverage (`../2026-09-13-c1173-support-certificate.md`, core `eead07b`).
- C1174: generic ordered-inflationary convergence with min-plus and Boolean instantiations
  (`../2026-09-13-c1174-generic-carrier.md`, core `c351eb9`).
- C1175: filtered-export manifest/lint, evidence lint, remote/tag/binary checks and pinned Rust
  toolchain (`../2026-09-13-c1175-release-hygiene.md`, core `b63c6dc`).
- C1176: `certificate.rounds` settled as a claimed bound admitted up to `min(N, M+1)`,
  symmetry invariance checked in verification, algebra laws gated, incremental grounding
  rebind, dense negative control where the frontier loses, fifteen review properties
  (`../2026-09-13-c1176-contract-semantics.md`, `../2026-09-13-c1176-core-properties.md`,
  core `2074025`). Open decisions for Tavis are in the report: identity/ownership
  redesign for per-update cost, evaluator policy, and the `Invariance` ABI code.

**C1177 next:** private kernels, sparse frames, large-detector behavior and parallelism. It is
not started. Earlier C1154–C1168 increments and exact boundaries are indexed by the
programme report; do not reproduce their history here.
Foreign issues seen during C1176: the shared Cargo target directory produced a stale-rlib
build failure under concurrent checkouts, and the worktree `~/.cache/ergodis/worktrees/c1176-props`
holds regenerated tracked `__pycache__` files that were left in place.

### C1149 — public-release readiness

Gap assessment and six-phase plan: `../2026-09-11-c1149-ergodis-public-release-review.md`.
Evidence remediation and the first filtered preview snapshot are complete; nothing has been pushed.
Tavis owns phase-0 publication/product decisions; phases 1–5 remain unallocated.

### C1143 — BB circuit-distance external benchmark (in progress)

Programme/protocol: `../2026-09-11-ergodis-external-benchmark-programme.md`; initial gate:
`../2026-09-11-c1143-bb-circuit-input-gate.md`; private current evidence:
`analysis/external-benchmarks/2026-09-11-coordinate-retraction.md` and adjacent reports.
Sparse/indexed native search, checked coordinate retractions and an independently replayed
weight-six witness are retained. This is exhaustive replay, not a succinct or formally verified
proof. No Gurobi timing exists under the restricted local licence, and no completed comparator
exclusion is claimed.

**Next:** matched proof-mode comparison, declared deeper hold-outs, deterministic subtree
parallelism, cost-aware provider/Evolve integration and matched published comparisons. C1144–C1147
remain later external workloads. C1148 certificate interoperability is queued; it does not imply
universal VIPR compatibility.

### C1130 — native/JS/WASM capability and workflow parity (in progress)

Current authority: `../2026-09-09-c1130-js-wasm-parity-review.md`; requirements:
`../2026-09-08-c1130-wasm-feature-completeness.md`; parameterization checkpoint:
`../2026-09-11-c1130-parameterization-checkpoint.md`. Detailed implementation and browser evidence
remain in dated reports and private `analysis/interface-review/`.

Delivered slices include shared native/WASM provider boundaries, checked active representation
admission, source-bound domain reuse, conditional family substitution, count/resource envelopes
and bounded batch readout (core `1127126`, private `5774a94`). This does not establish universal
representation switching, state conversion or cross-worker plan sharing. The generic partitioned
Hadamard join remains a native experiment pending WASM/Evolve integration; shared-memory telemetry,
broader plan contracts, Safari/Firefox coverage and complete workflow parity remain open.

**Next:** integrate the partitioned strategy with explicit cold compile-next boundaries; add a
sequential solve-time-versus-order view; continue calibrated admission, sparse envelopes/active
state conversion and certificate serialization/replay. Preserve one canonical engine, typed native
kernels and matched performance/conformance gates. Do not infer backend adoption.

### C1016 — order-2092 Hadamard reduction and search

Resume from the authoritative
[task card](../2026-08-30-c1016-ergodis-hadamard-quotient-synthesis.md) and its
[archive](../2026-08-30-c1016-ergodis-hadamard-quotient-synthesis-archive.md). Current structure map:
`../2026-09-11-c1016-inferred-repair-structure.md`; evidence gate:
`../2026-09-11-c1016-kick-retention.md`. Orders 668/716/2092 remain unsolved and the separate
strict-margin 14,800 recovery gate remains open.

**Next:** coverage-aware region proposals, cost-aware exact local representations and richer
invariant-preserving repair schedules. Before resuming, read `ergodis-contrib/PERFORMANCE.md` and
the shared performance playbook. Proved/exact reductions grant negative coverage; heuristic
predicates do not.

### C1017 — whole-core performance-contract remediation

Current report: `../2026-08-30-c1017-ergodis-core-performance-contract-remediation.md`.
Allocation-counted hot loops, iterative traversal, Tiger layouts, worker ownership and retained
single/parallel counter gates remain the contract. The filtered export is lint-clean; the inherited
deferred-verification artifact still lacks an unverified marker.

### C1061 — compiled dynamic decision engines / TigerBlossom

Current exploration log: `../2026-09-03-c1061-exploration-log.md`; certificate-authority migration:
`../2026-09-07-c1098-certificate-authority-migration.md`. Legacy generic/specialized root-only
checkers are replay paths, not independent evidence authority. Surface-family results predating the
2026-09-04 constructor correction are invalid.

**Open:** third-family crossover test, queue-struct borrow split, non-observable stabilizer
compile-time split and latency tail beyond p99. Tavis owns the unspecialized graph routing,
C1066 queue-discipline tradeoff and PyMatching working-set-asymmetry calls.

### C1062 — structural causal models as a context language

Probes 0–8 and adversarial reviews are complete; closeout recommends dropping probe 9. Awaiting
Tavis's close call. Authority: `../2026-09-05-c1062-closeout-synthesis.md`; brief:
`../2026-09-04-c1062-ergodis-causal-brief.md`. Possible successors require allocation:
compositional counterfactual crossover and certificate emission without carrier compilation.

### C1070 — compositional leakage analysis

All probes are complete and reviewed; awaiting Tavis's close call. Authority:
`../2026-09-06-c1070-closeout-synthesis.md`; brief:
`../2026-09-06-c1070-ergodis-compositional-leakage-brief.md`. Schema migration, certified
incremental mode and a paper carve-out are separate future decisions.

### C985 — exact algebraic optimization paper

In progress as the optimization-facing sequel; it does not block complete-ports. Current gate is
the algebraically deduplicated weight-six discovery sweep with direct-sum rejection, seeking a
Pareto survivor with `k d^2 / n > 19.2`. Reports:
`../2026-08-30-c985-completion-compression-and-wide-search.md` and
`../2026-08-30-c985-ergodis-private-adapters-and-parallel-roots.md`.

## Additional routed work

- C1111/C1112 reconstruction-driven representation discovery remains a bounded private spike;
  C1113 is gated on native end-to-end benefit. Reports:
  `../2026-09-07-c1111-reconstruction-contract-corpus.md`,
  `../2026-09-07-c1112-autonomous-representation-discovery.md` and
  `../2026-09-07-continuation-ergodis-reconstruction-plan.md`.
- C1072–C1074 are queued finite-geometry instance-family leads. Read their exact queue rows and the
  linked `../2026-07-16-relconic-discovery-track.md` entries only when selected.
- C1031–C1033, C1040–C1048, C1052, C1156–C1157 and remaining tooling/capability work retain their
  exact queue/task-report status; none is implicitly resumed by this map.
- Closed C1080–C1129 portable runtime, verification, repository and UI work is indexed by its dated
  task reports and summarized in the companion archive. Do not treat those delivered slices as
  universal host, mathematical-authority or execution-support claims.

## Workspace rules

`ergodis-private` is a library-only Cargo workspace with task crates under `tasks/`; no `src/bin`.
Builds use `~/.cache/ergodis/target/`, retained A/B binaries use `retain-bin.sh`, and task close uses
`cache-gc.sh`. Follow each sibling repository's `AGENTS.md` and the contributor performance guides.
Preserve the public/private source partition and never publish private paths, reports or capabilities.

The bounded-recovery manuscript tasks C325, C953, C955 and C964 remain owned by `complete-ports`.
