# C1130 — Concrete shared execution contract proposal

Current paired native/JS capability inventory and implementation ordering:
`2026-09-09-c1130-js-wasm-parity-review.md`. Resolve host fragmentation together;
preserve typed native execution. This is private, not-to-ship context.

**PRIVATE — contributor context only. Do not ship, export or publish.**
**Lane**: `ergodis`. Date: 2026-09-08.
**Status**: initial proposal tested by an experimental independent-module host;
no production API migration or kernel changes. Loading/conformance and bounded
cost/distribution results: `2026-09-08-c1130-module-loading-results.md`.
Shared immutable-plan/worker ownership requires refinement before ABI adoption.

## Decision to review

Expose the existing mathematical implementations through cold family adapters
with one host lifecycle and versioned operation envelope. Keep CampaignSession's
current reduction-family semantics compatible. Add the general execution surface
alongside it, then make campaign orchestration a consumer of that surface.
Do not extend the existing GF(2) Problem with unrelated optional fields.

Keep one canonical public-core-capable Ergodis WASM engine/host and expose the
versioned extension boundary required by C1079/C1084/C1091. Private domain
implementations are independently compiled packages, usable by that host without
private source or a private rebuild of core. A mandatory private assembly crate
is not the solution: it would fail the already stated recipient-use requirement.

Public core owns generic registration, language/compiler and execution contracts;
host adapters own module discovery/instantiation. Private packages provide opaque
identities/manifests and native libraries, WASM executable payloads or prepared IR
as applicable. The same logical package/capability identity binds separately
identified target implementations. Core builds/tests without any private package;
generic conformance uses public fixtures and private package tests remain private.

One canonical WASM Ergodis engine does not mean statically baking every industry
implementation into one module. Additional executable extension payloads are
packages loaded by that same engine, not competing demo-specific engines. All
browser consumers must use the canonical engine and extension mechanism.

C1084's Extensions and public/private boundary and C1079's runtime/IR analysis
already state this requirement. User reaffirmed it on 2026-09-08; there is no
pending permission question about replacing it with private assembly ownership.
Concrete ABI mechanics still need a bounded design grounded in actual consumers.
The private experiment is specified in
`2026-09-08-c1130-private-module-loading-spike.md`: real LRC/QEC providers,
source-free recipient loading, native/WASM parity and retained performance gates.
It tests candidate bindings without freezing the production ABI.

## Compiled/private package boundary

- Manifest: opaque package/capability identity, logical schema/IR version,
  target payload digest, ABI version, required imports/dependencies, operation
  entries, resource requirements and evidence/replay interpretation.
- Native payload: versioned coarse C ABI, fixed-width scalars and buffer/handle
  ownership, no Rust layout/ownership/unwind assumptions. Bind before execution;
  a module owns its specialized hot loop.
- WASM payload: explicit module imports/exports and buffer/handle ABI. Separate
  memory/ownership is accounted for at coarse calls; no per-state JS/import
  dispatch and no assumption a native .so can execute in the browser.
- Prepared source/IR: same validated frontend and semantic contracts. Source-
  withheld packages may use compiled/opaque IR; opaque scalar PlanSpec alone
  does not implement an arbitrary new kernel or establish a theorem.
- Private producer pipeline: strip/obfuscate chosen recipient artifacts and
  inspect the assembled payload, symbols, diagnostics, source maps, embedded
  paths, manifests and example data for unintended source disclosure. Preserve
  full build/replay provenance privately. Obfuscation is not an assurance that
  recipient-controlled code cannot be reverse engineered.
- Admission: registration establishes availability, not mathematical authority.
  Bind model/query/claim and checker requirements explicitly. Historical receipts
  never become local opaque admission by decoding or module loading.
- Required package gate: build the core host without private source, then load a
  compiled private package through the same generic contract and run actual
  native/WASM fixtures. Reject wrong ABI/schema/target, missing imports, corrupt
  payloads and stale handles; preserve native hot-path performance.

## Three concrete family mappings

| Contract | Labelled composition | Fixed LRC budget family | QEC decoding |
|---|---|---|---|
| Model | Exact field presentation, shaped inner label/cost table and outer blocks | Existing immutable RepairModel: nine capacities and demand count | Validated decoding graph/profile with weights and logical-observable interpretation |
| Compile | CompositionTable::compose_field<F>, preserving native sequential/parallel choice | RepairPlan::compile → existing LrcTransfer | Construct exact KernelSpec and presized Tiger Workspace; choose kernel/profile cold |
| Query | Target matrix, independently shaped from inner labels | Budget top-up, checked for overflow by admit_budget | Packed syndrome with exact detector length; minimum-weight correction or separately supported class-cost readout |
| Reuse | Several targets reuse one compiled table | Count/threshold/witness share a compiled model and admitted budget query | Many shots reuse the same model/workspace; a changed graph invalidates that binding |
| Result | Reachability, cost, lifted local labels and optional compilation/work metrics | Repaired count, threshold decision or mode/load witness | Weight, observable parity, defect count and explicit overflow; gap output has a separate availability condition |
| Stronger claim | Witness feasibility is not an independent optimality certificate | Existing adapter explicitly asserts no independent optimality certificate | Minimum weight is not logical maximum likelihood; overflow forbids an exact-optimum claim |
| Update | New target is a query; changed blocks/costs require a new compilation unless a separately admitted update exists | Top-up is a query; model changes require new model/plan or the separately checked fleet event contract | New syndrome is a query; graph/model edits require recompilation or an explicit supported update contract |

Native implementation anchors: core src/bin/ergodis.rs:571,623; core
src/composition.rs:279,550; private src/parametric_lrc_contract.rs;
private src/tiger_blossom.rs:174,194,250,367; private
 tests/semantic_contract_qec.rs. Input/output names here describe semantics;
they do not freeze wire names or fabricate capabilities the implementations lack.

The same compiled object can serve several queries, and one model can have several
plans. A session owns handles and resources; it does not supply algebraic truth.
OpenProblem supplies retained composition where applicable. Tiger decoding need
not implement a retained-tree trait merely to participate in this lifecycle.

## Host lifecycle and operation shape

Proposed logical operations (versioned names subject to the glossary pass):

```text
DescribeCapabilities
LoadModel(family, schema, source) -> ModelRef
Compile(ModelRef, plan_spec, resource_limits) -> PlanRef
Query(PlanRef, query_schema, query, readout, budget) -> ResultRecord
ApplyUpdate(PlanRef, expected_revision, event_schema, event) -> Updated | RecompileRequired
Release(handle)
```

A family may omit ApplyUpdate or a readout; discovery reports availability,
while actual invocation performs query/model admission. A successful catalog
lookup is not admission. Unsupported optional operations are not fake no-ops.
Compilation strategies may include direct execution; not every kernel must build
a tree or materialize a carrier. Compile describes preparation needed by that
family, not mandatory expensive preprocessing.

Envelope fields: protocol version, host generation, request identity,
operation/family/schema identity, expected object revision, resource envelope,
and typed family payload. Reuse the runtime's retry/revision conventions rather
than creating a second contradictory retry model. Semantic identities separately
bind model, query and representation. Host-local handles include generation and
kind and cannot be replayed as portable artifacts or admission capabilities.
Use fixed-width validated lengths and decimal-string full-width integer counters
at JS boundaries. Do not dump native structs into wire payloads.

Native Rust adapters call typed family operations directly. Wire payload decoding
and dynamic family lookup happen only at cold entry. A registry entry holds
operation/schema metadata and coarse adapter calls, not per-state callbacks.
The host registers loaded package families; core must not enumerate their names or
import their Rust types. Do not add a framework or foundational crate until a
concrete dependency requires it; prefer narrow modules in existing layers.

Model and plan ownership are separate from prepared mutable worker workspace.
A live workspace has one owner during execution; immutable compiled model data
can be reused safely. Release rejects busy ownership and stale generations.
Failed imports/compilation leave the previous accepted plan usable. Query-only
changes do not silently destroy a valuable compilation as the current lab does.

## Answers, checks and persistence

Use operation outcomes independently from mathematical answers:

- Operation: completed, unsupported, rejected input/query, budget exhausted,
  interrupted or internal failure, with family-specific diagnostics.
- Answer: typed family result, actual readout and claim scope, model/query/plan
  bindings, optional witness/evidence references and explicit coverage/overflow.

An unreachable composition target is a completed mathematical answer. QEC class
costs being unavailable does not make the minimum-weight correction a class-cost
answer. LRC overflow is rejected query admission, not saturation into a different
budget. Preserve these cases in native/WASM fixtures.

Input validation, mathematical claim checking, execution and result verification
are separate operations. Family-specific opaque admission remains owned by the
relevant checker/adapter. Do not require every family to manufacture a coordinate
restriction for the pilot's Check→Execute workflow. Do not turn serialized flags,
module registration or a successful solve into proof authority.

Reuse portable RunSpec/RunRecord/bundle/repository contracts for recorded inputs,
queries, outcomes and references. A saved model/plan manifest can support viewing
without allocating execution workspace. Reopening is read-only. Explicit prepare/
replay resolves dependencies and performs computation under a separate physical
recovery budget. Persist source and compilation specifications first; do not
promise portable hot-memory checkpoints. Mid-solve continuation remains capability-
specific, with explicit version/target compatibility and interruption semantics.

## Native performance preservation

Do not replace specialized native call paths with wire dispatch or portable
fallbacks. Capture retained native baseline artifacts before any implementation
change that can affect code generation. No new field-kind checks, registry lookup,
JS crossings, serialization, owned containers or host context in hot loops.
Maintain field/kernel monomorphization, native layouts, release profiles and
compile-time assertions. Keep workspace allocation outside execution.

The OpenProblem ADR's historical min-plus leaf-fusion cost is a concrete warning:
a generic wrapper must preserve fused leaf evaluation rather than assume static
dispatch alone makes the whole operation free. Existing compilation allocation
and bounded control safe points need precise classification; no blanket claim
that inherited code already meets every current performance rule.

Accept adapter-only changes through semantic/ownership/shape and full existing
gates. Any hot code/record/codegen change additionally requires zero-allocation
regressions, before/after profiles and retained interleaved hardware-counter A/B
in single and parallel modes, with work/memory/contention effects explained.
Do not declare native performance preserved merely because no source loop moved.

## First implementation and acceptance slices

1. Finalize this contract against the three family fixtures and validate compiled-package
   compatibility. Inventory current public modules and exposed commands separately;
   module presence is not capability coverage.
2. Extract/bind retained labelled composition first: legacy native JSON remains
   compatible, primes/GF4 and rectangular shapes preserved, two targets reuse one
   table, stale/wrong-family handles reject. Reuse native algorithm bodies.
3. Bind the existing LRC plan and Tiger profile using the same lifecycle, preserving
   private ownership. Test queries, unsupported readouts, overflow and failed
   replacement without fabricating independent certificates.
4. Run real browser/Worker/WASM conformance on all three and migrate the recovery
   view to actual model/query/results. Then do the private glossary pass required
   by C1130; expand to every remaining inventoried family.

This proposal completes only the initial contract deliverable. C1130 remains in
progress until the full capability inventory/closure, canonical build migration,
conformance, native performance and private glossary gates pass.
