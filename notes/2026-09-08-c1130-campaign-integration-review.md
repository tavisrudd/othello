# C1130 — Campaign integration boundary and private glossary reconciliation

Current paired native/JS capability inventory and implementation ordering:
`2026-09-09-c1130-js-wasm-parity-review.md`. Resolve host fragmentation together;
preserve typed native execution. This is private, not-to-ship context.

**PRIVATE — contributor context only. Do not ship, export or publish.**
**Lane**: `ergodis`. Date: 2026-09-08.
**Status**: source review and private terminology pass complete; integration below
is a reviewable implementation sequence, not a claim of delivered campaign support.
No Rust/JS, provider payload, canonical WASM artifact or live preview changed.

## Finding

The recovery, QEC and scheduling modules share a real native/WASM loading ABI.
They do not yet share CampaignSession's operation/history service. Wrapping their
answers in the finite GF(2) CampaignSpec would falsify the model and checking
semantics. The already approved direction remains: a mathematical executor below
orchestration, family-specific admission, cold lifecycle/recording above kernels.

The third application module is resource scheduling. It does **not** close the
original labelled-composition/LRC/QEC extraction gate: composition still needs
field presentations, independently shaped source/target spaces and lifting.
Full WASM parity and full CampaignSession integration remain open.

## Current source boundary

Paths are relative to sibling checkouts under `~/src/`.

| Source | Observed behavior | Consequence |
|---|---|---|
| `ergodis/crates/runtime/src/service.rs` | Request Create/Apply/Snapshot/Checkpoint/Restore owns concrete CampaignSpec and campaign commands. Its RunReport encodes finite restriction results. | This is a family-specific service, not an extensible executor hidden behind another frontend. Retain compatibility. |
| `ergodis/wasm/www/module-worker.js` | Serializes inspect/load/call/close; canonical core initialization; provider handles checked by host generation. | Shared loading exists, but no campaign identity, revision history or result recording is attached. |
| `ergodis-private/analysis/campaign-console/mockups/application-client.js` | ModuleSession prepares a provider plan/workspace; Application.run returns family/query/answer and source/payload/handle diagnostics. | Useful result binding exists, but no RunId, portable RunSpec, RunRecord or repository publication. |
| Same file, recovery methods | A Run can issue primary readouts, witness validation, parity frontier and capacity-map queries over temporary models. | Recording only the last call would lose the primary question; recording every plot sample as a user run would distort history/accounting. |
| Same file, applyPendingCapacities | Prepares a new session first, swaps only on success. | Preserve atomic replacement and query-only plan reuse during integration. |
| `ergodis-private/analysis/campaign-console/mockups/live-client.js` | Separate application.run and CampaignSessionClient.apply branches; per-page events and result JSON. | Current UI unifies interaction, not runtime semantics or durable history. |
| `ergodis/crates/runtime/src/run_record.rs` | RunSpec already binds Model, Query, Representation, Semantics and Package ContentRefs. RunRecord has typed start/update/fork linkage. | Reuse these neutral records; do not create a parallel JSON history format and call it RunBundle. |

## Smallest next integration slice

Start with **recorded application runs**, then attach generic execution operations
to campaign control. This is the concrete decomposition of the existing proposal,
not adoption of a new public ABI or a rewrite of CampaignSession.

1. At Run entry, freeze accepted model bytes, query/readout/objective, semantic
   interpretation, compilation recipe and exact package/schema/revision/digest.
   Assign a host-generated UUIDv7 RunId. Capture these before any await; mutable
   UI state or a subsequent session replacement must not relabel an older answer.
2. Encode those as existing portable RunSpec content references. Representation
   bytes describe how to prepare the representation, not a live pointer/handle.
   Record the exact provider payload identity and compatibility separately from
   logical capability identity. Store the model source required for replay or
   explicitly report it missing under the disclosure policy.
3. Record a primary operation outcome and typed family answer. Record subordinate
   plot/witness-check work as such, with its own query/model binding; do not count
   it as an independent user run or claim complete campaign budget accounting.
   Provider status, bounded-search completion, overflow, incumbent feasibility
   and independently checked claims remain separate fields.
4. Use existing portable RunRecord/RunBundle/repository paths for saved data.
   Reopen into snapshot mode without loading provider executables. Explicit Run
   again resolves dependencies, prepares a fresh execution context and records
   the new run/link. Reuse existing UUIDv7/fork rules instead of synthesizing IDs
   from content hashes or host generations.
5. Attach those operations to shared campaign/session control at the cold boundary:
   generation, request identity, expected revision, bounded retained responses and
   declared recovery behavior. Reuse existing retry conventions. Do not promise
   durable exactly-once execution: a crash after computation but before publication
   can require replay, which is additional physical work.

The first slice must not turn exact but uncertified application answers into the
finite pilot's ProofGenerating receipts. RunSpec SearchMode is an evidence
obligation, not a claim that a private provider is correct. If the existing mode
vocabulary cannot express a needed obligation honestly, propose that small schema
change separately; do not silently reinterpret the enum or invent a certificate.

### Required behavior before calling the slice integrated

| Scenario | Acceptance observation |
|---|---|
| Repeated queries on one model | Same compilation reused; distinct recorded queries and results; no host handle used as portable identity. |
| Query edited while an operation is pending | Recorded input/query remain the captured values; stale output does not replace the current query's result. |
| Failed replacement model | Earlier accepted plan remains usable; rejected source is not recorded as the successful answer's source. |
| Save/reopen each application | Existing portable parser reads references/result; opening neither instantiates a provider nor runs a solver. |
| Missing/wrong provider or source | Snapshot stays inspectable; explicit activation reports the exact missing/incompatible dependency. |
| Budget-limited scheduling design | Incumbent and budget exhaustion retained; no fabricated minimum or infeasibility claim. |
| QEC overflow | Overflow survives save/reopen; no exact-optimum label appears. |
| Apply proposal | New accepted source and linked forward result; old result/source remain immutable. |
| Native/browser cross-target replay | Same family inputs/readout/answer meaning; target payload identity may differ and is recorded. |
| Duplicate request / stale revision / host restart | Existing retry conventions preserved; conflicts cannot execute twice within the admitted retry window; restart replay records additional physical work. |
| Finite GF(2) campaign regression | Existing Create/Check/Execute/checkpoint/verify/fork flows remain compatible. |

Native integration must retain typed direct entry points. Record serialization,
content hashing, provider discovery and orchestration belong outside solve loops.
Do not route native workers through JSON or WASM, add cross-worker locks, or claim
plan sharing from multiple independent provider instances. Shared immutable plan /
owned mutable workspace semantics still require their separate ABI refinement.
Any code-generation/hot-path change must pass the retained single/four-worker
allocation, exact-work, profile and interleaved-counter gates; the existing accepted
capacity-fit measurements do not validate a future controller change.

## Glossary result

`2026-09-08-ergodis-private-terminology-review.md` now maps delivered wire/code
names to semantic roles; distinguishes Fit/Optimize, capacities/loads/search
budgets, proposals/application, hover pins/optimization locks, and Run/Execute;
adds spaces/bases/transports, resource identity, valuation, query families,
preservation and answer contracts; and records stale shipping-glossary status
labels without modifying public documentation.

The source review also prevents two false completion claims: three loaded modules
are not the original composition-family gate, and a JS result envelope is not a
portable runtime record. There is no new solver or performance result in this pass.

## Validation and next action

Reviewed the live runtime service, portable record definitions, module Worker,
application execution/replacement paths and current shipping glossary against
C1091 and the C1130 execution proposal/native-interface review. The performance
contract and complete playbook were loaded. Documentation paths and diff hygiene
were checked; code tests were not rerun because no executable code changed.

Next implementation: bind one completed recovery operation into existing portable
run records and a snapshot-only reopen, with QEC/scheduling conformance using the
same boundary; then connect that boundary to campaign operations. Keep the
composition binding and full capability inventory explicitly open.
