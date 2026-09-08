# C1130 — Concrete shared execution contract proposal

**PRIVATE — contributor context only. Do not ship, export or publish.**
**Lane**: `ergodis`. Date: 2026-09-08.
**Status**: initial contract proposal; no API migration or kernel changes yet.

## Decision to review

Expose the existing mathematical implementations through cold family adapters
with one host lifecycle and versioned operation envelope. Keep CampaignSession's
current reduction-family semantics compatible. Add the general execution surface
alongside it, then make campaign orchestration a consumer of that surface.
Do not extend the existing GF(2) Problem with unrelated optional fields.

Use one private WASM composition root to assemble core and private capabilities.
Core exports only domain-neutral library/binding support; private assembly depends
inward on core, runtime, verifier and private domain modules. Migrate all browser
consumers to its generated package, retiring the existing core-owned demo package
as an active product build after conformance passes. Preserve its tests and history.
This changes assembly ownership, not mathematical implementations. The decision
requires review before moving crates or changing active build paths.

This is how one feature-complete assembled WASM product can respect the existing
prohibition on core depending on private code. Source modules and optional future
extension payloads do not imply separate competing Ergodis engines. There is no
new public distribution or private-source export in this task.

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
The assembly registers private families; core must not enumerate their names or
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

1. Finalize this contract against the three family fixtures and review assembly
   ownership. Inventory current public modules and exposed commands separately;
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
