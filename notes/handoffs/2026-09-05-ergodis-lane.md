# Ergodis compiled exact-optimization engine

**Lane**: `ergodis`

**Purpose:** routing only. Closed dispositions, measurements, proof summaries, and correction
trails belong in the dated task reports and in the archive companion,
[`2026-09-05-ergodis-lane-archive.md`](2026-09-05-ergodis-lane-archive.md).

**Date**: 2026-09-05
**Mode**: intent-based.
**Status**: ACTIVE. Split out of `complete-ports` on 2026-09-05. C1016 (order-2092 Hadamard
reduction), C1061 (compiled dynamic decision engines / Tiger decoder), and C1062 (structural causal
models as a context language) are in progress; C1062 is ready to close on Tavis's call. C1017 (core
performance-contract remediation) and C985 (optimization-facing paper) are in progress. The
benchmark, evolve-capability, tooling, and visualization tasks (C1031-C1033, C1040-C1048, C1052)
are queued or in progress per their own rows.

**Discovery companion**: [ergodis discovery track](../ergodis-discovery-track.md).

**Architecture context**: for architecture, shared API/schema, execution, model/query
or portability work, read `notes/ergodis-architecture-context.md` after this handoff.
It is private, not-to-ship contributor guidance and routes to prior ADRs, current
abstractions and terminology. Narrow UI/admin work does not require the full history.


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

### C1130 — full WASM feature completeness (in progress)

User requirement: WASM is a full Ergodis execution target, not a restricted subset.
Close bindings, portability and host-adapter gaps across existing core/private
capabilities; keep shared contracts and native optimized execution intact.
Consolidate consumers on one canonical feature-complete WASM build; audit and
retire divergent active demo build paths after migration. The task card indexes
the Sunday/Monday architecture and implementation notes already loaded.
Mandatory inventory, cross-target conformance and native performance gates:
`notes/2026-09-08-c1130-wasm-feature-completeness.md`.
Initial concrete contract: `notes/2026-09-08-c1130-execution-contract-proposal.md`.
Private loading/execution spike: `notes/2026-09-08-c1130-private-module-loading-spike.md`.
Loading spike complete: core `5542688`, private `29a2fd8`/`2e90fa4`, contributor
`9e49744`; source-isolated native and actual browser LRC/QEC gates, provider-side
allocation audit, retained boundary counters and revised stripped-package loading
pass. ABI remains experimental; full native performance acceptance remains open.
Next: refine shareable immutable-plan / owned executor-workspace semantics, then
third-family composition and CampaignSession/console integration. Private `5da6805`
adds Tavis Rudd notices, verified in stripped native/WASM packages. Results:
`notes/2026-09-08-c1130-module-loading-results.md`.
Private `5e22031` runs full supplied QEC and LRC queries in the application
workspace (8769 and 8770), with retained plans and explicit snapshot/runnable
contexts. Main campaign runtime/console integration remains open. Report:
`notes/2026-09-08-c1130-application-wasm-workspace.md`.
Private `5b327eb` adds exact native/WASM capacity design and editable recovery
inputs with a two-axis map; native performance gates pass. Report:
`notes/2026-09-08-c1130-capacity-design.md`. Private `ec3185c` adds native/WASM
resource scheduling, draggable capacities/targets, hover previews with click pins,
and QEC double-click parity. Browser and native gates pass; accepted LRC/QEC
payloads remain unchanged. FT10 is still inspect-only; default scheduling executes
GPU checkpoint batches. Next: CampaignSession/composition integration and the
private glossary reconciliation. Report:
`notes/2026-09-08-c1130-scheduling-and-direct-inputs.md`.
Private `6d81ee2` / core `f9faafd` add Fit target and Optimize capacity, including
reductions for scheduling and recovery. Exact native/WASM and bounded-search
status gates pass; retained forward native performance remains within noise.
Report: `notes/2026-09-08-c1130-fit-and-optimize-capacity.md`.
Private glossary reconciliation and campaign-boundary review are complete:
`notes/2026-09-08-c1130-campaign-integration-review.md`. Next: record application
queries/results through existing portable run records with snapshot-only reopening,
then attach the execution boundary to campaign control. Labelled composition is
still unbound; three application modules do not close that original family gate.
User-prioritized web expansion now supplies 60/600-repair and 24/72-job workloads,
plus a live 81-point WASM capacity surface with weighted CPU/GPU objectives and
partial stop. Browser/independent scheduling gates pass; native payloads unchanged.
Report: `notes/2026-09-08-c1130-larger-workloads-live-surfaces.md`.
Evolve now runs a real bounded WASM capacity-reduction comparison at ports
8769/8770 `/evolve`, bound to `0.0.0.0` on user request. The private demo
HTTP adapter now supplies missing SHA-256/randomUUID APIs for LAN Safari;
forced-missing-API browser workflow and Worker hash checks pass. Core `b5e2210` exposes
the shared ranked proposal driver; private `2046e91` adds independently checked
resource bounds and measured baseline/comparison traces. The 72-job grid removes
78/289 configurations (42 seed, 36 evolved), leaving 211 forward solves. These
are capacity configurations, not internal solver states; timings vary. Browser,
checker oracle, receipt replay and core gates pass. Campaign integration and
broader reduction families remain open. Report:
`notes/2026-09-08-c1130-wasm-evolve-reductions.md`.
Preserve public-core loading of separately compiled/obfuscated private packages;
canonical WASM engine plus extensions, not a mandatory private assembly build.
Start with a concrete contract over composition, compiled LRC queries and QEC;
extract the smallest shared interface, bind canonical WASM, then expand to full
parity. A private glossary reconciliation follows initial integration and is
refreshed at closeout; these context/terminology docs must not ship.
Read both contributor performance documents in full on resume. Recovery/QEC/
scheduling browser execution is part of this scope; the current lab restrictions
are temporary implementation gaps, not intended WASM capability boundaries.

### C1111–C1113 — reconstruction-driven representation discovery

C1111/C1112 have a bounded spike on private branch `spike/continuation-reconstruction`
at `~/.cache/ergodis/worktrees/continuation/ergodis-private`, with a sibling core worktree
pinned at `67d929b`. Main-checkout code is untouched. All run/log/temp data use ZFS-backed
`~/.cache/ergodis/continuation-spike/`; Cargo uses its shared configured target.
The existing proposer learns and repairs a trace selector; partition certificates pass on
q=13,17,19, with triangle joint-legality failure and frame/Clebsch marking ambiguity controls.
This is a bounded representation/admission pilot, not autonomous field-coordinate discovery.
The frozen selector now also passes q=16,23,25,27. A q=16-trained incidence-query
dispatch gives 1.108x warm-query improvement on a held-out q=27 Python mix; the modeled
first-batch ratio is only 1.008. C1113 remains gated on native end-to-end benefit.
Benchmark review selects scheduler W2/W3/L2 for checked grouping/grading discovery;
Ceph's existing reliability/scheduling readouts are the second reuse target.
Next: bounded scheduler discovery against the current compiler, then matched native
measurements preserving exact admission and the performance contract. Transfer remains gated.
Latest private commit `20237c9`; report:
`notes/2026-09-07-c1112-extension-fields-and-incidence-dispatch.md`.
Reports: `notes/2026-09-07-c1111-reconstruction-contract-corpus.md` and
`notes/2026-09-07-c1112-autonomous-representation-discovery.md`.
Acceptance criteria: `notes/2026-09-07-continuation-ergodis-reconstruction-plan.md`.

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

**Certificate authority caveat:** C1097 demonstrates a sibling-forgery acceptance in the legacy
generic root-only checker and audits the same gap in the specialized checker. These paths must
not supply independent evidence authority. C1098 removed the old API names and gated first-party
benchmark consumers behind explicit legacy replay; see the reports below.

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

All twelve probes done and reviewed (1, 5, 3, 2, 0, 6, 8, 9, 7, 10, 4); ready to close on Tavis's
call. Probe 10 refuted the uniform-cost chain conjecture (it is Wei's chain condition) and corrected
probe 2's measurement; probe 4 refuted labelled duality; probe 7 built the design front, each with a dated report, generator, certificate, and independent
cross-check. Verdicts, the product claim, the ship order, open successors, and the consolidated
mystery ledger are in the
[closeout synthesis](../2026-09-06-c1070-closeout-synthesis.md); the brief is
`../2026-09-06-c1070-ergodis-compositional-leakage-brief.md`. Product framing: prior art informs,
never gates. **Waiting on Tavis**: close C1070; the schema migration, a certified incremental mode, and any
paper carve-out are separate calls. Foreign
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

### Evolve convergence — next implementation slice

C1079's convergence plan is complete: `notes/2026-09-06-c1079-ergodis-evolve-review.md`.
C1080's portable admission pilot and current-core browser recovery are complete:
`notes/2026-09-07-c1080-admission-pilot.md` (core `5247f6d`, `95d16b9`).

C1081's language inventory, finite reduction semantics and native/WASM conformance slice are
complete: `notes/2026-09-07-c1081-language-semantics.md` (core `55c5d8c`).

C1082's scalar operation semantics and FeatureDag lowering conformance are complete:
`notes/2026-09-07-c1082-scalar-semantics.md` (core `ac6b3ad`). The public compiler now validates
field-schema bounds before u16 lowering; native evaluator/layouts are unchanged.

C1083's bounded portable campaign transition model and checkpoint replay are complete:
`notes/2026-09-07-c1083-campaign-transitions.md` (core `6269cd1`). Latest outcome, current evidence
and prior run coverage remain separate; Cancel/Resume preserves completed evidence and budgets.

C1084's portable control/session architecture and staged migration plan are complete:
`notes/2026-09-07-c1084-portable-control-architecture.md`. Shared native/browser service; attachable
frontends; durable history independent of processes; explicit view/verify/replay/resume/fork
workflows, host/repository/compilation-unit boundaries; native64 performance gates unchanged. This is a design, not a claim of implemented hosts or platform support.

C1085's portable scalar/text/codec extraction is complete: core `57af8b4`, report
`notes/2026-09-07-c1085-portable-scalar-language.md`. Native compatibility retained; default scalar
and bounded byte-reader tests pass; native/WASM layout assertions remain exact. Public terminology
authority: core `docs/glossary.md`. C1084 includes run metadata/notes, forkable history and the
separate orchestration bounded context above the mathematical engine.

**C1086 complete**: independent finite verification crate and cold solver-admission bridge,
core `08221f2`; `notes/2026-09-07-c1086-independent-verification.md`. Native, standalone verifier,
Python and browser/WASM gates pass; no verifier dependency on solver or host machinery. Old checker
receipts intentionally require fresh verification rather than exact replay under the new checker.

**C1087 complete**: portable `ergodis-runtime` owns Campaign and bounded synchronous session control,
core `75c1021`; `notes/2026-09-07-c1087-portable-campaign-runtime.md`. Existing campaign semantics
preserved; explicit retry/revision/generation rules and JS-safe counters; native/Python and actual
WASM campaign corpus gates pass. Legacy native daemon/Python clients remain separate APIs.

**C1088 complete**: interactive browser Worker/client campaign demo, core `ea1f563`;
`notes/2026-09-07-c1088-browser-campaign-control.md`. Create/propose/check/execute/cancel/resume,
status and opaque checkpoint file exchange pass real Chromium UI/Worker/WASM tests; provenance,
verification and coverage remain separate. WASM binary unchanged; no in-flight cancellation claim.

**C1091 complete**: verbatim September 4–5 brainstorm archives and core semantic-contract synthesis:
`notes/2026-09-07-c1091-core-semantic-contracts.md`. Historical performance/novelty/product claims
remain unverified source material. Quotients, representative catalogs, event semantics and policy
contracts are distinct; autonomous Evolve is broader than quotient minimization.

**C1092 complete**: query/design specialization motivation and six private executable semantic
contract tests across privacy, causal and QEC; private `4841e23`, report
`notes/2026-09-07-c1092-query-specialization-corpus.md`. Scoped tests, clippy and formatting pass.
Recovered C1061 incremental/witness/certificate/top-k history. Existing LRC events distinguish
parametric changes from rebase. Generic DeltaRun batching has numeric/same-leaf preconditions that
must be enforced before external promotion; see the report's explicit saturation counterexample.

**C1093 complete**: cold `RepairModel`/`RepairPlan`/borrowed `BudgetQuery` adapter around existing
parametric LRC; one compilation serves count/threshold/witness readouts with checked top-ups.
11 scoped contract tests, clippy and formatting pass. OpenProblem/generic-certificate audit and
source-vs-commitment clarification: `notes/2026-09-07-c1093-dynamic-query-admission.md`.
No hot kernels changed; the DeltaRun saturation limitation is now executable regression evidence.

**C1094 complete**: core `CompositionShape` and private fallible retained-tree construction,
core `b74a369`, private `4add0bc`; `notes/2026-09-07-c1094-core-composition-admission.md`.
Full core fmt/clippy/tests, private constructor tests, Python parity and WASM release check pass.
The boundary validates geometry/inline storage only; algebra, query and evidence admission remain
separate. Original hot loops/layouts and native construction paths unchanged.

**C1095 complete**: additional observable admission on validated finite quotients, core `8fe20fa`;
`notes/2026-09-07-c1095-observable-admission.md`. Multiple readouts reuse a compilation; finer
readouts return a concrete distinguishing pair. Full native gates, Python parity and WASM release
check pass. This is state-readout admission on supplied contexts, not domain/policy evidence.

**C1096 complete**: private event-to-leaf admission, private `b6307ed`;
`notes/2026-09-07-c1096-leaf-update-admission.md`. Opaque checked transitions reject forged after/
summary claims and changed source/schema before mutation; unrelated-leaf updates remain valid.
13 scoped tests, formatting and clippy pass. Same-kernel summary evaluation is not independent proof.

**C1097 complete**: independent fixed min-plus/SHA256Digest summary-transition checker,
core `46f7d1c`, private `9c1a620`; `notes/2026-09-07-c1097-independent-summary-transitions.md`.
Retains authenticated snapshot summaries/digests: O(N) memory, O(log N) updates. The executed
sibling-forgery regression is accepted by the legacy generic checker and rejected by the new one.
Legacy generic/specialized authority claims are corrected; C1098 confines their algorithms to
explicit historical replay and migrates the supported consumer.
Native full gates, private interoperability/mutation tests, Python and WASM compilation pass.

**C1098 complete**: private `83ebffa`; `notes/2026-09-07-c1098-certificate-authority-migration.md`.
Removed old verifier API names; legacy algorithms are explicitly named replay and benchmark
consumers require opt-in with false authority. New `matrix-verified-chain` uses the independent
checker with summary-transition-only authority. 50 scoped tests and CLI smoke pass; library and
CLI integration clippy pass. Whole-tool clippy remains blocked by an unrelated unchanged lint in
`tasks/tools/src/leakage_dual_tower.rs:116`; no suppression or foreign fix applied.

**C1100 complete**: core `174999c`, private `cc56b87`;
`notes/2026-09-07-c1100-domain-bound-transitions.md`. Domain-bound LRC events use the independent
checker’s admitted-leaf API; rejection preserves domain and verifier state. Core owns wire parsing.
Full native, 16 private tests, Python and WASM gates pass. Summary aliases are intentional: this
checks consistency with the supplied source interpretation, not unique source/event identity or
independent domain optimality. Existing solver loops and hot layouts unchanged.

**C1101 complete**: core `e4e7424`, private `dd3f19d`;
`notes/2026-09-07-c1101-portable-run-records.md`. Portable RunId uses host-supplied UUIDv7, distinct
from content hashes. Immutable spec/record codecs bind sources/events and explicit fork parents;
new forks get fresh IDs. Six runtime and eight private tests, full native gates, Python and WASM
compilation pass. This is structural/content/link admission, not repository publication or
mathematical authority. No clock/RNG/filesystem or solver hot-path change.

**C1103 complete**: core `c8da541`, private `fd0f03f`;
`notes/2026-09-07-c1103-offline-run-bundles.md`. Bounded portable bundles expose manifests, records,
borrowed payloads and explicit missing dependencies. Included content/parent checks and duplicate
history rejection pass seven bundle tests; the private LRC fixture resolves actual snapshot/delta
bytes before explicit verification. Full native, eight private tests, Python and WASM compilation
pass. Opening data implies no solver execution, publisher authentication or mathematical authority.

**C1105 complete**: core `d5e5504`; `notes/2026-09-07-c1105-offline-browser-inspection.md`.
Offline browser/client inspection exposes manifest, identities, lineage, declared modes and
missing dependencies through the portable WASM parser. Bounded single-use Workers; no campaign
or implicit verification. Real Chromium complete/partial/corrupt/oversize cases, full native,
Python and release WASM gates pass.

**C1106 complete**: core `feab0c6`; `notes/2026-09-07-c1106-offline-verification-forks.md`.
Explicit min-plus snapshot checking with summary-only coverage and fresh-UUIDv7 child downloads;
chosen-spec forks preserve original parent records and carry no child evidence. Unknown/missing
evidence remains inspectable. Four portable workflow tests, full native, Python, release WASM and
actual Chromium verification/fork gates pass. No source interpretation or execution authority.

**C1107 complete**: core `75b646b`; `notes/2026-09-07-c1107-repository-contract.md`.
Portable repository transactions, head CAS, writer fences, attempts, conservative reservations,
versioned sidecars and coherent analytical snapshots informed by C1033. Bounded volatile reference,
ten conformance tests, full native, Python and release WASM gates pass. No persistent adapter or
actual execution recovery is implemented.

**C1114 complete**: core `96a81b5`; browser IndexedDB persistence, portable bounded replay,
save/reopen/verify/fork UI and actual Chromium crash/restart gates pass.
Report: `notes/2026-09-07-c1114-browser-repository.md`.

**C1115 complete**: core `248b678`, docs `8848e3f`; separate native Unix filesystem host
shares the same portable replay semantics. Cross-process ownership and five publication-step
SIGKILL gates pass on ZFS; full native/Python/release WASM gates pass.
Report: `notes/2026-09-07-c1115-native-repository.md`.

**C1121 complete**: core `b219db3`; example-first saved-run demo, first-save setup,
clear evidence/save actions and expandable technical details. Desktop/mobile and browser
process-restart gates pass. Report: `notes/2026-09-07-c1121-demo-usability.md`.

**C1122 complete**: core `67d929b`; first-visit introduction explains the optimizer via
an interactive lamp problem and actual WASM optimum, followed by guided safe/unsafe
shortcut checking and a rendered counterexample. Former controls remain advanced tools.
Full native/Python and browser semantic/UI/recovery gates pass. Report:
`notes/2026-09-07-c1122-first-visit-demo.md`.

**C1123 complete**: private `c835284`, `2820c67`; coherent native repository projection
into DuckDB/Jupyter heads, update/fork lineage, attempts and exact u64 accounting.
Scoped native/CLI/SQL gates pass; inherited whole-tool Clippy lint remains.
Report: `notes/2026-09-07-c1123-repository-analysis.md`.

**C1033 saved-run notebook slice complete**: private `81af202`; exact accounting,
update/fork ancestry, run selection and bounded SVG rendering pass executed notebook
and Chromium output checks. Report: `notes/2026-09-07-c1033-saved-run-notebook.md`.

**C1124 complete**: real-workload campaign console recovered against current native
Ergodis; private `10a465b`, `9d75d53`, `de4f4fd`. Reader, VM differential and static/live
browser gates pass on an order-2092 corpus (19,997 candidates, 178 behavior classes).
Report: `notes/2026-09-07-c1124-real-campaign-console.md`.

**Demo direction (user instruction)**: operator console like the supplied older campaign
artifact, with real problems; no infographic or toy-example default. Private entry:
`make -C analysis/campaign-console demo`. Review preview: `http://127.0.0.1:8767/`;
process location/ownership is recorded in the report. C1124 covers the candidate-lineage
console formerly listed as C1033's next step; saved run ancestry is a separate view.

**C1125 complete**: private `bd0acc4`; workspace uses current portable bundle,
IndexedDB repository and WASM campaign clients. Actual browser workflow gates pass.
Campaign reduction/cascade precedes lineage; counters/provenance stay visible below
the fold, with a short header. User rejects collapse-to-simplify clicks.
Report: `notes/2026-09-07-c1125-portable-console.md`.
WASM accepts user GF(2) CampaignSpec/checkpoints; native corpus evolution and opaque
RunBundle-to-execution conversion remain unsupported. Allocate their bridge only
as an explicit implementation slice; never imply a bundle is executable by opening it.

**C1126 complete**: working Campaigns/Library navigation, real native campaign and
browser-session listing, inspector beside candidate analysis, compact historical
compilation with stage selection. Desktop/narrow browser workflow gates pass.
Report: `notes/2026-09-07-c1126-campaign-information-architecture.md`.
Preview remains `http://127.0.0.1:8767/`; this is the concrete IA review surface.

**C1129 complete**: private `daf812d`; loaded domain workspace with explicit
snapshot/runnable contexts and staged Create session → Run → Review actions.
Real Worker/WASM executes a bounded QEC projection; CampaignSpec/checkpoint loading
and portable bundle inspection pass browser gates. Scheduling/recovery remain
snapshot-only. Secondary step/file controls sit below the visualization.
Review: `http://127.0.0.1:8769/#qec`; report:
`notes/2026-09-08-c1129-runnable-domain-lab.md`.
Next UI slice (unallocated): integrate loaded domain/session interaction into the
main campaign workspace; broader QEC/recovery adapters require their own contracts.

**Next gate**: select and allocate a second real application demonstration (recovery/helper
costs or QEC decoding) to show another engine capability. Browser analytical export
and larger-store pagination also require their own slices.
Browser/native bounded persistence pilots are complete; automatic execution recovery, larger
stores and additional platform/retention guarantees need separately allocated slices and gates.
Closed scope and gates: `notes/2026-09-07-ergodis-offline-workflow-successors.md`.
Keep domain verification explicit; preserve native64 performance and solver/control separation.
Other algebras/backends and compact sibling proofs need their own admission/performance gates.
C1032 and module schemas remain open; these slices do not close or duplicate their broader scope.

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
C1031-C1033, C1040-C1048, C1052, C1061, C1062, C1070, C1072-C1074, C1079, C1080, C1081, C1082, C1083, C1084, C1085. Future Ergodis engine, benchmark, tooling,
capability, and Ergodis-paper tasks use `[ergodis]`. C1086's independent verifier is complete. The bounded-recovery manuscript work (C325,
C953, C955, C964) stays on `[complete-ports]`.
