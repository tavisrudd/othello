# C1130 — JS/WASM interface, capability and workflow parity review

**PRIVATE — contributor context only. Do not ship, export or publish.**
**Lane**: `ergodis`. Reviewed: 2026-09-09.
**Status**: review and implementation plan; full parity remains open.
Source baseline: core `6cf56db`, private `3b0eb1f`. This pass changes documentation
and a browser feature probe, not runtime contracts, algorithms or release settings.

## Conclusion and binding direction

JS + WASM should provide the existing native mathematical capabilities and practical
workflows, with appropriate browser host mechanisms. Target differences may affect
performance, resources and persistence guarantees; they must not silently change the
question, discard evidence, substitute smaller inputs or invent an exact result.

The principal gap is a fragmented host API, alongside missing family bindings.
The portable CampaignSession is still a finite GF(2) restriction pilot on native
and WASM. The module ABI executes additional real native/WASM families, but those
operations are not integrated into the shared campaign/history service. No new
universal matrix schema or replacement solver framework is proposed.

The existing execution-contract proposal and campaign-integration review remain
the semantic baseline. This report supersedes their implementation ordering and
old delivered-status summaries, not their preservation or performance obligations.
One canonical engine/build pipeline remains required. Private packages stay private;
public hosts can load their compiled target payloads without private source.

## Paired native and JS convergence

Native is the mathematical capability reference, not an already unified host API.
`ergodis/src/control/mod.rs` declares `ergodis-control-experimental-v0`; the
native typed CLI/library surfaces and `crates/runtime/src/service.rs` are separate
entry points. Private application module operations add another cold lifecycle.
A callable native kernel therefore does not establish shared campaign recording,
checkpointing, capability negotiation or replay support.

Resolve this fragmentation in the same C1130 phases on both hosts. Define each
family's operation, immutable input/query identity, result, admission, verification
and record semantics once. Implement thin native and JS adapters to those semantics,
and gate them with the same positive and negative transcripts. Generate wire types
where appropriate; share codecs rather than copying family knowledge into clients.
This is a proposed migration direction, not a new stable ABI declared by this review.

Keep typed native plans/workspaces and specialized kernel dispatch. Serialization,
package resolution and record assembly belong at cold boundaries; neither JSON nor
WASM becomes mandatory inside native search. Legacy CLI/control adapters remain
until their replacement passes equivalent workflows and native performance gates.
Do not maintain separate browser-first and native-later roadmaps. Every phase must
identify both adapters, their shared semantic owner and any explicit host limitation.

## Evidence and inventory scope

The machine-readable working matrix is in the private repository:
`analysis/interface-review/capability-matrix.json`. It names source anchors, status,
gap kind and implementation phase. “Not found in reviewed bindings” does not mean
“cannot compile to WASM.” A library export, target build, callable binding and
cross-target tested workflow are four distinct observations.

Reviewed sources include native CLI dispatch and core exports; canonical WASM
exports; runtime service/record/bundle/repository boundaries; public session,
bundle, repository and module clients/workers; private module descriptors and
application/race adapters; and current build/serve entry points. The native
operation review of September 8 supplies additional frontend semantics.

This is not a completed census of every core/private algorithm or private research
entry point. Remaining libraries, field combinations and specialized kernels are
explicit inventory debt, not implicitly supported rows. C1130 cannot close until
that denominator is enumerated and each operation has evidence.

| Surface | Current observation | Main remaining work |
|---|---|---|
| Labelled composition | JS `solveCompositionJson` rejects field_order != 2; native dispatch supports primes 2/3/5/7/11/13 and GF(4). | Retained compilation, full native field/shape/target/lifting contract; remove arbitrary binding restriction. |
| CampaignSession | Shared finite pilot: revisions, bounded retries, checkpoints and restore. | Make campaign orchestration consume general execution operations while retaining pilot compatibility. |
| LRC/QEC/resource scheduling | Actual loaded native/WASM providers; query reuse, Fit/Optimize and typed family readouts. | Durable application runs, optional readout conditions, updates and lifecycle integration. |
| CSS distance / Hadamard | Existing kernels; active checked reductions, progress, proof replay and learned-only runs. | Broader native sharding/artifact/campaign workflows and durable knowledge; descriptors/checkpoints remain limited. |
| Ceph / GPU examples | Lowered helper/resource problems run in WASM. | General native source compilation, reliability, placement and witness-lifting contracts are not established by those demos. |
| Transfer/towers and vector-span repair | Native typed operations are broader than the GF(2) pilot. | Bind their actual field/source/query/result contracts; do not invent GF(256) byte recovery. |
| Repair DAG, Hall, QC-LDPC, BP-OSD and other libraries | Broader native functionality; no complete operation-level browser coverage found. | Finish inventory, prioritize and port existing operations with their verifiers. |
| Bundle/repository | Portable records, bounded browser IndexedDB and native filesystem hosts exist. | Application traces into portable records; larger stores, execution recovery and retention semantics. |
| Parallel/ISA variants | Browser worker concurrency exists; native optimized paths remain. | SIMD/parallel execution mapping and platform probes; feature compilation is not runtime thread-pool support. |

## JS interface review

### Preserve these working boundaries

- `CampaignSessionClient` has an explicit ready handshake, generation/request
  correlation, single-flight admission, frame bounds, deadlines and revision
  tracking. Timeout destroys the worker to avoid ambiguous replay. Reuse its
  semantics where applicable, rather than weakening it to match a demo client.
- Bundle inspection is separate from activation. Bundle/repository workers are
  disposed after bounded work. Browser publication waits for transaction commit
  and uses CAS; a successful request is not confused with a committed write.
- Module manifests bind schema, target and payload hash. Inspection does not load
  executables. Providers validate handles, byte capacities and output contracts;
  traps invalidate instances. Keep these checks when improving loading/caching.
- Application model replacement prepares a replacement before swapping it in.
  Plans and owned execution workspaces are already separate. Retain specialized
  typed native calls and coarse module boundaries.
- CSS ordinary repeats reuse compiled plans but reset solver/discovery state.
  Learned-only repeats recheck explicitly retained proposals with discovery off.
  Compilation reuse, answer reuse and learned-rule reuse must stay distinct.

### Concrete gaps, ordered by urgency

| ID | Source observation | Required correction / acceptance |
|---|---|---|
| JS01 | `Application.run()` captures query/session diagnostics after `await solve()`. | Freeze model/query/plan/package/run identity at entry; test an edit or session replacement during pending work. Source-level race risk; not an exploit demonstrated here. |
| JS02 | `ModuleSession.rpc` has no deadline, messageerror handling, pending cap, safe-ID exhaustion policy or response generation validation. postMessage failure can leave its pending entry. | Bounded correlated requests, explicit failure cleanup and backpressure; reject stale/malformed frames; failure-injection tests. |
| JS03 | Session/bundle clients are single-flight; module requests queue implicitly; a blocking campaign Execute cannot receive Cancel mid-call. | One documented operation model; distinguish cancellation requested, cancellation acknowledged, hard termination and checkpoint recovery. Advertise cooperative support per executor. |
| JS04 | Module operation IDs and family codecs are manually duplicated; bare Error strings flatten typed provider status. | Generate/share cold schemas and TS declarations; preserve invalid, stale, capacity, unsupported, busy, trap, budget stop and mathematical infeasibility separately. |
| JS05 | Descriptors offer readout lists and coarse updates/checkpoints booleans. CSS/Hadamard “updates” include reduction admission, not arbitrary model edits. | Describe operation-specific model/query/update/admission capabilities, limits and evidence scope. Availability never replaces actual admission. |
| JS06 | Application runs and race JSON are outside RunSpec/RunRecord; host handles appear in result diagnostics. | Portable primary-operation records with typed subordinate plot/verification work; handles never become durable identity or replay authority. |
| JS07 | Root-relative worker/module URLs and server-injected crypto fallback couple module clients to the demo server. | Configurable package/worker/asset resolvers, explicit host environment checks and a DOM-independent JS boundary. Package real-browser tests without serve.py rewriting imports. |
| JS08 | Current module manifest/host supports no imports. There is no required-engine-feature negotiation or byte/operation catalog. | Versioned capabilities and resource negotiation before activation; imports remain denied unless explicitly modeled and supported. Do not silently widen the experimental ABI. |
| JS09 | JSON, copied byte buffers and worker round trips are mixed across entry points; limits are fixed at several different layers. | Keep JS-facing typed objects with validated binary bulk payloads; exact wide integers; bounded batches/transfers and negotiated per-operation resources. Profile copies before replacing them. |
| JS10 | Timing/cache policy was implemented in several runners; provider/module warmup differs from problem compilation. | Share timing definitions and cache lifecycle tests. Record clock scope and source/package/schema cache keys; expose cold/reused compilation and actual verification durations. |

Some issues already have defensive UI behavior, but a reusable JS API must enforce
its own contracts without depending on a particular button being disabled.

## Intended workflow contract (proposal, not a newly adopted public API)

The logical sequence is discover capability/package → inspect/load source → admit
model/query → compile/reuse plan → create/reset owned execution → run/advance →
read answer/witness/evidence → verify → record/save → inspect/reopen/replay/fork.
Updates and learned-rule admission are separately supported operations. A family
may provide a direct or one-shot execution path; it need not materialize a tree.

A thin JS facade should expose the same logical operation identities as native,
with typed family schemas. It should provide promises and bounded progress events,
AbortSignal with declared semantics, explicit disposal and dependency resolution.
The exact method names/package layout remain a concrete P0 design deliverable;
this review does not authorize a second runtime or foundational crate.

Every result needs frozen model/query/representation/package identities, an
operation outcome, typed mathematical answer, completion/budget/overflow status,
actual readout, evidence references and timing scope. Full-width counters remain
exact strings or BigInt with explicit codecs; `Number` is for range-checked
values or display approximations, never proof/accounting authority.

A saved run opens as data. Explicit activation resolves the exact dependencies,
creates an execution context and records new physical work. A displayed certificate
must state its checked claim: witness feasibility, a quotient preservation claim,
a source automorphism and optimality are different claims. No universal “verified”
boolean can substitute for that scope.

## Native workflow equivalence

| Native workflow | Browser/JS equivalent and limit |
|---|---|
| Compile once; query many targets/shots/budgets | Source/schema/package-bound plan handles; fresh/reset workspace; two or more query fixtures and invalid reuse tests. |
| Update accepted model | Revisioned update with preservation contract or explicit recompile-required; failed replacement keeps the prior plan. |
| Controlled long solve; promote reduction | Cooperative bounded advance and checked safe-point admission; independent Evolve worker/controller. No inner JS callbacks or busy polling. |
| Stop/resume/checkpoint | Capability-specific portable checkpoint or source-based replay; hard worker termination is not a resumable checkpoint. |
| Save/load/list/fork/replay | Existing portable records and browser repository adapters; missing packages remain inspectable. Crash/retry work is accounted explicitly. |
| Native specialized parallel search | Coarse browser worker decomposition first; separately tested shared-memory pool if beneficial. Same exact semantics, potentially different ordering/witness tie choices. |
| Native filesystem/daemon/socket | Browser storage, file exchange and host messaging equivalents; no promise that Unix durability/locking or background execution guarantees are identical. |
| Private native library | Same logical package backed by independently identified WASM payload; no private source exposure or native-library-in-browser claim. |

Parity requires exact objective/feasibility and valid evidence. Byte-identical
witnesses/work counts are required when the protocol promises deterministic order;
otherwise compare declared tie/equivalence semantics and explain work differences.
Never relax an existing deterministic contract just to make a port pass.

## Revised implementation plan

All phases belong to C1130; these are milestones, not newly allocated task IDs.
Each phase covers native and JS together; a browser binding alone cannot close it.

**P0 — Interface hardening and durable capability matrix.** Freeze the result
identity boundary, request/error/disposal model and operation descriptors against
current families on both hosts. Inventory native control/CLI/runtime fragmentation
as well as missing browser bindings. Enumerate remaining operations and exact limits. Add
negative host tests and schema/type generation proposal. Gate: stale, duplicate,
malformed, oversized, trapped and timed-out requests have explicit outcomes with
no mislabeled result or dangling pending operation.

**P1 — One end-to-end portable application workflow.** Record a loaded LRC run
using existing RunSpec/RunRecord/RunBundle, reopen without execution, explicitly
run again, verify named claims and fork. Apply the same boundary to QEC/scheduling
and CSS/Hadamard. Gate: shared native/browser transcript corpus plus edit-during-
run, failed replacement, missing dependency, interruption and restart cases.

**P2 — Retained labelled composition and fields.** Expose native field dispatch,
rectangular shapes, multiple targets per compilation and lifting through the same
cold lifecycle. Preserve existing GF(2) clients. Gate: primes/GF(4), unreachable and
invalid targets, wrong field presentation, overflow/resource bounds and parity.
This is the original contrasting-family abstraction gate; scheduling did not close it.

**P3 — Remaining native family workflows.** Use the inventory to bind represented
transfer/towers, vector repair/MDS/Ceph frontends, DAG/Hall/QC-LDPC and remaining
library/private operations. Each row needs both a source-to-answer browser example
and native/browser negative/verification cases. Large data must fail explicitly or
use a supported bounded/streaming workflow, never a hidden smaller projection.

**P4 — WASM performance alternatives.** Run the SIMD/build/caching experiments in
`ergodis-private/analysis/interface-review/wasm-performance-plan.md` alongside P0–P3.
Do not treat slow scalar execution as the desired long-term port when exact SIMD
is available. Conversely, speedups do not close missing mathematical operations.
Shared-memory thread work requires its own host/ABI and deployment gates.

**P5 — Durable knowledge, continuation and broader storage.** Source-bound learned
artifacts, portable admission/rechecking, optional execution checkpoints and browser
persistence/recovery. Query results, compiled code, mathematical plans, learned rules
and cursors have separate validity/lifetime rules. Gate corruption, wrong-version,
missing-source, stale-epoch, quota and crash cases, with explicit additional work.

**P6 — Consolidation and closure.** A packageable JS entry, generated types,
capability/catalog documentation and native/browser conformance for every inventoried
operation. Canonical engine/payload digests and required features recorded. Test
Chromium, Firefox and real Safari/iPhone; no user-agent assumption substitutes for
execution. Retire divergent active frontends only after replacements pass.

## Validation and open limits of this review

Source-path/matrix/schema checks and actual Chromium feature probes accompany this
report. Previously executed CSS cold/repeat/learned-only, repair, Hadamard, capacity
and certificate gates are context, not a newly rerun whole-native parity suite.
No Rust hot loop, native layout, payload or production ABI changed here. Existing
performance rules remain: retained native before/after single/parallel profiles,
exact work/results, allocation and hardware-counter gates for affected kernels.

The probe reached the loopback demo in Chromium 148: SIMD128, relaxed SIMD,
bulk-memory and atomics validated and executed their tiny functions. The page was
not cross-origin isolated and JS SharedArrayBuffer was absent. This is engine
feature evidence, not measured Ergodis SIMD acceleration or a working thread pool.
An attempted old LAN address reached a browser error page; that result was rejected
and is not used as deployment evidence. Safari/iPhone and Firefox remain untested.

Next implementation is P0's shared frozen operation/result identity and bounded
request lifecycle, with paired native and JS adapters validated against the same
repeated-query and edit-during-run transcripts,
then P1's portable LRC save/reopen/replay workflow. Full capability parity stays open.
