# Ergodis compiled exact-optimization engine

**Lane**: `ergodis`

**Purpose:** current routing only. Closed dispositions, measurements, proof summaries and
correction trails live in dated reports and the append-only
[`2026-09-05-ergodis-lane-archive.md`](2026-09-05-ergodis-lane-archive.md).

**Date**: 2026-09-14
**Mode**: intent-based.
**Status**: ACTIVE. Immediate engineering frontier is C1170 (owned Rel-rich frontend); the
rule-contract programme C1172–C1177 and the Datalog evaluation tasks C1179/C1182–C1186 are closed. C1143, C1130, C1016,
C1017, C1061 and C985 remain in progress. C1062 and C1070 await Tavis's close call.

**Discovery companion**: [ergodis discovery track](../ergodis-discovery-track.md).

**Architecture context**: for architecture, shared API/schema, execution, model/query or
portability work, read `notes/ergodis-architecture-context.md` after this handoff. It is private,
not-to-ship contributor guidance. Narrow UI/admin work does not require the full context.

**Performance context (required)**: `~/src/ergodis-dev/PERFORMANCE.md` is the always-on rules
layer for any Ergodis Rust edit. Before a hot-path edit, benchmark, A/B, profiling or
measurement-stage task, also read `~/src/ergodis-dev/performance-playbook.md` in full (contract
detail plus the A/B, event-set, profiling, cold-start and reporting method on this host), and
restate its binding items in every sub-agent prompt.

## Identity and boundaries

- **Ergodis software**: private `main` of `~/src/ergodis`, with sibling checkouts
  `~/src/ergodis-private`, `~/src/ergodis-evidence` and `~/src/ergodis-dev`, each governed by
  its own `AGENTS.md`. The software left this monorepo at tag `ergodis-split-base` (`aa49d68c3`).
- C1175 validates the regenerated 472-row filtered export manifest and a lint-clean filtered
  tree. Nothing has been published to GitHub. Evidence-publication, paper-deposit,
  copyright/contact, product-scope and public-CI decisions remain with Tavis.
- The [`complete-ports`](2026-07-17-complete-ports-paper.md) lane owns the motivating *Exact
  Compositional Transfer of Bounded Linear Recovery* manuscript. This lane owns the private
  engine, its performance contract, benchmarks, capabilities, tooling and C985 paper.

## Immediate frontiers

### C1170 — owned Rel-rich frontend (in progress)

Contract: `../2026-09-12-c1170-owned-rel-frontend.md`; source study:
`../2026-09-12-c1169-datalog-frontends.md`; measurements, cost model and bounded recovery:
`../2026-09-13-c1170-frontend-measurements.md` (private `99281a2` … `f820daf`); Pratt-loop A/B
(16-byte frame, operand/infix fast path: ASCII parse instructions 0.788 of control, scanner now
56 % of the stage): `../2026-09-13-c1170-pratt-loop-ab.md` (private `2efeccb` … `b5416b0`).
Keyword lookup and reserved-word gap: `../2026-09-14-c1170-keyword-lookup.md` (private
`2840757` … `fcd7d1a`): reserved words are now exactly the reference keyword table plus `_`,
with `doc`/`value`/`type`/`declare` contextual at item start; the packed keyword compare is a
measured wash against a clean-checkout control (the profiler share was call-entry skid), kept
as the explicit form. The native/WASM parity gate carries 151 cases; it is a finite parity
gate, not a grammar oracle or complete syntax/admission claim. Instruction counts are the
decision metric on this shared box; cycle ratios are reported only with intervals.
Cold start and scanner attribution: `../2026-09-14-c1170-prepare-touch-scan-attribution.md`
(private `c526b3f` … `9f1e57e`): the `prepare-touch` and scan-only stages exist; a fresh
workspace costs 1,536 minor faults / 1.13 ms under bench limits (kernel time, invisible to the
user-only instruction metric); `lexer::scan` is attributed by two agreeing methods and
punctuation dispatch, not identifiers, is about half the scanner. Two measurement caveats now
bind: the six-event `perf stat` set multiplexes and must not be used for small operations, and
the shared toolchain moved to rustc 1.95.0, so every retained control predating 2026-09-14 is
toolchain-mismatched.
Punctuation fast path: `../2026-09-14-c1170-punctuation-fast-path.md` (private `6ed6ff9` …
`cfe4893`, kept shape `598426f`): against a rustc 1.95.0 control at `9f1e57e`, ASCII parse stage
0.8010 (19.9 % removed), faster on every cohort in the byte variant, scalar variant exactly 1.0000;
the first-byte compound index with slice `starts_with` was an instructive negative (libc `memcmp`
in the loop). Lane protocol change: A/B with
`instructions,cycles,branches,branch-misses,page-faults,minor-faults` (non-multiplexing, A/A null
two parts per million); cache events in a separate run. The parser is now the majority of the
ASCII parse stage (48 %); the token store (23 instructions per 16-byte record as five stores) is
the largest identified scanner component.

**Next:** retain a control at `598426f`, then the token-store single-16-byte-write A/B
(establish pool alignment first); then the remaining
syntax gaps by manifest family (caret entity references, interpolation, Unicode boundary
conformance) and first semantic admission checks. Ergodis retains lowering, rules, joins and
execution; no external evaluator or backend is adopted. Tree-sitter and executable reference
semantics remain deferred.

### Datalog evaluation — C1179, C1182 and C1183 closed

C1179 (`../2026-09-13-c1179-datalog-closure-ballpark.md`) found the grounded rules path capped
at N≈24 by the grounding budget. C1182 (`../2026-09-13-c1182-demand-driven-datalog.md`) added
the demand-driven semi-naive evaluator (`Demand`, core `crates/rules/src/demand.rs`), admission
without grounding and the derivation-certificate checker (core `crates/verify`), and a matched
single-core comparison with Soufflé 2.5 through the private harness and
`analysis/datalog-comparison/`. C1183 (`../2026-09-13-c1183-ranked-certificate.md`) added the
ranked-relation certificate (relation plus one byte per tuple, searching checker, core
`crates/verify/src/ranked.rs`) and measured representation cost. C1184
(`../2026-09-13-c1184-direct-checker.md`) rebuilt both checkers and the shared closed-world pass
on direct-addressed stores (core `crates/verify/src/datalog_store.rs`): trace checking is now at
the order of evaluation on closure, ranked checking 3–9× evaluation. C1186
(`../2026-09-13-c1186-presence-bitmap.md`) added the presence bitmap: large sparse rows 1.2–1.7×
faster again (worst row, sparse same generation, now 4.3× evaluation for the trace checker and
7.7× for the ranked one), checker-only peak RSS measured. The checker profile is now bucket
enumeration and unification, not membership. C1185
(`../2026-09-13-c1185-certificate-size-exploration.md`) profiled generation and measured eight
candidate encodings: ranks as runs are a free strict win on the existing format; a binary
round-block form reaches 0.25–1.06 bytes per derived tuple; no core format changed. C1188 (queued) removes the runtime-length tuple `memmove` from the demand derivation loop
(discovery track, 2026-09-13; about a fifth of dense-closure evaluation). Unallocated
successors, in the order C1185 rates them: implement rank runs and the round-block certificate in core with its checker; a key-indexed rank
structure for the ranked checker's fully bound probes; bodies with more than two atoms; a
bit-parallel closure kernel for dense inputs.

### Rule-contract programme — closed

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

- C1177: sparse-frame dispatch asserted and property-tested, native 10^5–10^6-detector
  measurement (sparse frame 6–41× faster; external 60M→12M still unattributed), construction-time
  `parallel_workers`, single `Table` enum without `unreachable!`, count-axis parallelism measured
  and left serial, Domain parallel=serial and privacy property tests
  (`../2026-09-13-c1177-private-kernels.md`, private `051f734`).

Earlier C1154–C1168 increments and exact boundaries are indexed by the programme report; do not
reproduce their history here. Open programme follow-ups need allocation: the C1176 decisions for
Tavis (identity/ownership redesign, evaluator policy, `Invariance` ABI code) and, only if count-axis
parallelism is ever wanted, a merge-free core tile kernel (discovery track, 2026-09-13).
Foreign issues: private workspace Clippy was repaired under C1170 (2026-09-13); `cargo fmt
--check` still reports pre-existing drift in eight untouched files (formatting them is a
separate decision); the shared Cargo target directory produced a stale-rlib build failure under
concurrent checkouts during C1176; the worktree `~/.cache/ergodis/worktrees/c1176-props` holds
regenerated tracked `__pycache__` files.

### C1149 — public-release readiness

C1187 public-audience documentation cleanup is complete (core `5f537e6`), including
public contributor guidance in `docs/dev/` and the Python flake entry point:
`../2026-09-13-c1187-public-documentation.md`. No export or push was made.

Gap assessment and six-phase plan: `../2026-09-11-c1149-ergodis-public-release-review.md`.
Evidence remediation is complete. Both repositories hold a matched, validated snapshot at
`v0.1.0-preview3`: the crate (core `86b07c7`, public root `5dd74c0`) and the evidence repository
(evidence `581cc79`, public `036f593`), with the crate's benchmark prose linking into the evidence
snapshot at that tag. Each published branch is a single root commit, so neither history carries
anything earlier; the crate's earlier snapshots and preview tags were deleted on 2026-09-13 because
the first shipped tracked bytecode with local paths, and `EXPORTS.md` records the discard. That class
is now refused on the path alone by the publication lint's `generated` rule and by `hooks/pre-commit`
on every branch (core `14768a6`). Nothing has been pushed; both staging pushurls remain parked.
First phase-1 packaging pass is done (core `a7d033a`, `f8b4114`): every cited evidence file is named
in full rather than by brace or wildcard shorthand, and the twelve families no document named are
now documented in `BENCHMARKS.md` — the gross `[[144,12,12]]` searches with their Gurobi controls,
the rule-frontier A/B with the negative control where the frontier loses, the L2 dominance A/B, the
rank-envelope probe, the six-application no-regression record, and one structured CNF instance with
its selection manifest. Nothing was dropped. Staging holds the matched `v0.1.0-preview4` pair from
that work — crate (core `564ad08`, public `b464490`) and evidence (evidence `6d3fce7`, public
`d90fe31`), both validated, all 83 evidence URLs resolving. That pair is now stale: on Tavis's call
core `d407310` removed the compiled-rule-replay section and its five evidence files, and a wider
curation of `BENCHMARKS.md` to a few benchmarks of public interest is pending Tavis's choice of
sections. **Do not cut a snapshot until that lands.** Two items it must carry: the evidence
repository still tracks the five deleted files, because the refresh never deletes, so they need an
explicit `git rm` there first; and `2026-09-12-recursive-runtime-transcript.json` is uncited again.
Also open: the Gurobi licence blocker is stale — both families reproduce locally, so the
private-tier import can be fixed and that evidence regenerated (report has the numbers and the
shape decision it needs). Open for Tavis: phase-0 publication/product decisions; remaining phase-1
through phase-5 work is unallocated.

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
invariant-preserving repair schedules. Before resuming, read `ergodis-dev/PERFORMANCE.md` and
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

C1178 framing complete: `../2026-09-13-c1178-ergodis-framing.md` leads with a spectrum from
Evolve discovery to optional static specialized kernels; ranked alternatives, drafts,
source register and paper-evidence gaps are retained there. On paper resume, C985 should
resolve the precise integrated contribution and coupling evidence before a novelty claim;
the separate optimization manuscript's location remains unconfirmed. No public prose changed.

## Additional routed work

- C1180 categorical lift–fold–lower and general equivalent-representation recognition are
  queued, including checked semantic reuse and C1139 AME frames as a workload-gated candidate;
  C1181 cross-domain pilot and
  resumed Evolve are gated on its memo and Tavis's architecture choice. Queue audit, contracts
  and gates: `../2026-09-13-c1180-c1181-categorical-structure-folding.md`. Reuse C1155's
  existing quotient/normalization results and C1162's lowering checker; coordinate C1157
  plan rewriting and C1156 proposal policy without treating either as the complete loop.
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
