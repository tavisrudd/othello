# C1130 — Private module loading and execution spike

**PRIVATE — contributor design and evidence plan. Do not ship or publish.**
**Lane**: `ergodis`. Date: 2026-09-08.
**Status**: designed; not implemented or benchmarked. Experimental ABI only.

## Question and decision

Can an unchanged public Ergodis host load separately compiled private providers,
prepare reusable plans and execute real workloads on native and WASM, while
preserving semantic contracts and native performance?

Test a coarse provider boundary around preparation and whole execution batches.
Public core owns the contract; hosts own loading; providers own family admission,
specialized compiled data and mutable workspaces. Campaign orchestration consumes
these operations. The spike tests this proposal; it does not freeze an ABI or
migrate existing native entry points. C1130 remains the owning umbrella task.

## Bounded scope

Two private providers, two target bindings, one generic recipient harness:

| Provider | Existing implementation | Discriminating workload |
|---|---|---|
| LRC budget queries | `ergodis-private/src/parametric_lrc_contract.rs` and `src/parametric_lrc.rs` | Compile nine capacities plus demand once; repeatedly admit budget top-ups; count, threshold and mode/load witness readouts. Cheap queries expose boundary overhead. |
| QEC decoding | `ergodis-private/src/tiger_blossom.rs` and existing semantic/production fixtures | Prepare a real graph/profile and workspaces once; decode repeated packed syndromes; preserve weight, observable, defect, overflow and optional class-cost availability semantics. |

Use actual existing production workload inputs, pinning source revision, generator,
parameters, input bytes and hashes before measurement. Small exhaustive fixtures
remain correctness oracles; they are not the performance demonstration. Include a
working set large enough to expose transfer/memory costs, within a preflighted
resource budget. Do not substitute the console's six-detector projection for QEC.

Core labelled composition remains the third-family abstraction gate in C1130;
this spike concentrates on the independent private-package requirement. It does
not claim whole-engine WASM parity. No console redesign, package marketplace,
hot unloading, universal checkpoint format, solver rewrite or forced conversion
to OpenProblem. Prepared IR is a supported architectural path but implementing a
second IR execution backend is outside this experiment.

## Experimental package and lifecycle

One manifest describes logical capability/schema versions and separate native
and WASM payloads. Each payload binds its digest, target/CPU or WASM requirements,
experimental ABI version, imports, dependencies and operation capabilities.
No private Rust type names or source paths are required for discovery.

Inspecting a manifest does not load a native library or instantiate WASM: either
can execute initialization code. Explicit activation resolves the selected local
payload, validates bytes/compatibility/imports, loads it, and checks its returned
descriptor against the manifest before registration. Registration grants no
mathematical or verification authority. Dependency resolution is deterministic;
the spike does not download code automatically.

Logical lifecycle (these are concepts, not a frozen list of wire exports):

```text
inspect manifest -> activate provider -> discover supported operations
model + compilation specification -> admit/prepare -> immutable plan handle
plan + capacity limits -> create workspace
plan + workspace + query batch + requested readout -> results
release workspace -> release plan -> release provider
```

Keep family payloads typed and versioned under the common envelope. A plan binds
model and compilation identities; a workspace binds its provider instance, plan,
generation and capacity. Use provider-local generational handles, not serialized
Rust objects or host pointers as portable identities. A workspace has one owner
while executing. Plans remain alive while dependent workspaces exist. Failed
replacement does not destroy the previous usable plan. Busy/stale/wrong-kind or
cross-instance handles reject deterministically at the cold boundary.

LRC query admission checks top-up arithmetic before execution; invalid queries
do not partially mutate the plan. QEC validates detector widths and batch/output
capacities before decoding. Initial batches are admitted as a whole; per-shot
mathematical outcomes remain distinct from batch admission errors. Unsupported
readouts reject explicitly. Requesting class costs must not silently return a
minimum-weight answer with invented confidence. Source/model changes require
preparation again unless a separately supported update contract exists.

## Native and WASM bindings

Native: load a `cdylib` through one versioned C entry returning a size/versioned
function table. Exchange fixed-width fields, validated byte spans and handles.
Specify ownership, alignment, lifetime and error behavior; each allocator frees
its own allocations. No Rust layout, trait-object or unwind ABI crosses the
boundary. Resolve the selected entry before repeated execution. A provider owns
the complete specialized loop and retains existing native ISA/profile choices.
The native in-process provider is trusted executable code, not a sandbox.

WASM: instantiate an ordinary module with its own linear memory in the existing
canonical host's Worker flow. Use explicit buffer allocation/release, validated
offset/length pairs and handles. Upload reusable model data once; reuse prepared
workspace and I/O capacity. Refresh host memory views after possible memory growth.
No growth, JS/import callback or registry lookup occurs per solver state/shot.
JS performs coarse dispatch and transfers; the provider owns the batch loop.
Core host and provider must use the same lifecycle: no family-specific bypass
through a bespoke JavaScript solver path.

Measure model upload, each query upload and result download separately; do not
describe separate memories as zero-copy. Native retains its own efficient data
layout. Do not share core's allocator or depend on wasm-bindgen internal layouts.
An extension may contain monomorphized kernel helpers; it must not embed a second
CampaignSession runtime or competing canonical engine.

Compare a WIT/component binding only after the plain-module path works: one
provider, identical workload/kernel and lifecycle, bounded to one integration
attempt. Record tooling and generated glue, capabilities, copy behavior, payload
size and cold/warm costs. If blocked, retain a precise failure and leave the
component decision open; do not expand this into a tooling project. No migration
to components or shared-memory dynamic linking is implied by the spike.

## Experiments and acceptance gates

1. **Independent recipient.** Build the generic public host without a dependency
   on private sources. Transfer only permitted package artifacts and input data
   into an isolated recipient environment with no private checkout/source mount.
   Execute both providers on native and actual browser WASM. Build a second
   compatible provider revision and load it using the exact same host bytes.
   Record host, provider, input and toolchain hashes and dependency manifests.
   Inspect recipient payloads for source paths, debug/source maps, symbols,
   diagnostics and accidentally embedded private material. Stripping/obfuscation
   is a producer step, not a claim that executable algorithms cannot be recovered.

2. **Semantic reuse and parity.** Run the same corpus through direct native APIs,
   loaded native providers and loaded WASM providers. Repeated LRC queries must
   reuse one plan; independently replay returned modes/loads and compare counts
   and threshold decisions. For QEC compare existing native results and bounded
   exact-oracle fixtures, including overflow and unavailable class costs. Pin
   tie behavior where promised; otherwise validate witness feasibility and equal
   objective rather than demanding identical representatives. Preserve work
   counts, or explain differences before accepting results. No new independent
   optimality/certificate claim follows from successful loading or parity.

3. **Failure and lifetime behavior.** Exercise corrupt digest, wrong ABI/schema/
   target, unavailable imports/features, insufficient capacity, malformed lengths,
   stale/cross-provider handles, release order and failed plan replacement. Check
   output bounds, leak-free repeated create/release and memory-view refresh.
   Snapshot inspection must work with missing executable payloads and perform zero
   provider activation. A WASM trap invalidates the affected instance/handles;
   native memory faults are not promised recoverable. If execution has no safe
   cancellation point, Worker termination reports interruption and invalidates its
   handles; it does not fabricate a resumable checkpoint. Keep unrelated sessions
   outside that Worker termination scope or document the actual affected scope.

4. **Native performance.** Retain the pre-change direct control first. Compare
   direct typed execution, the same wrapper through a statically linked C ABI,
   and actual dynamically loaded execution. The middle arm separates wrapper/
   batching cost from dynamic loading and codegen effects. Retain executables and
   exact loaded libraries with hashes; a retained host alone is insufficient.
   Measure query batches of 1, 16, 256 and 4096 where admitted, amortizing compilation
   equally. Include one native worker and a bounded parallel configuration with
   separate presized workspaces and result storage per worker. Preserve existing
   directly callable native fast paths throughout.

5. **WASM lifecycle cost.** Separate fresh Worker/module startup, package validation,
   WASM compilation/instantiation, model preparation/upload, query transfer,
   warm batch execution and result transfer/readout. Compare host-issued batches
   with a provider-local repeated-execution control using identical kernels and
   inputs; identify which boundary each measurement includes. These are test
   controls using the provider, not an additional browser engine. Record peak
   memory, duplicate resident data, payload sizes and first-result latency.

The performance model is `load + prepare + transfers + calls * boundary_cost +
kernel_work`. For tiny LRC queries, batching should amortize the call; for QEC,
retained workspace should prevent allocation and repeated model transfer. These
are hypotheses, not measured outcomes. Record break-even reuse/batch counts.

Native acceptance follows the full contributor performance contract: zero
allocations in repeated real solve loops after setup (instrument provider
allocators too), retained interleaved A/B profiles/counters for instructions,
cycles, branches, misses and relevant cache events, single/parallel work and
result parity, peak memory and contention checks where applicable. Instrumented
builds are separate from timing builds. Noisy results are inconclusive; do not
invent a percentage tolerance or accept native slowdown for portability. Report
startup cost separately from warm throughput and disclose unbatched penalties.
Run correctness and the current core/private validation gates before performance
claims. Unexpected hot-code/layout changes require the full before/after gate.

## Execution order, ownership and stop conditions

Stage A: pin real fixtures and direct controls; build the smallest experimental
contract and LRC provider; pass independent native/WASM loading and reuse.
Stage B: add QEC through that same contract; run semantic, lifetime, resource and
failure gates. If it requires family switches in the public host, revise the
contract rather than adding those switches.
Stage C: measure all binding arms, run the bounded component comparison, inspect
recipient artifacts, and write the adoption/revision verdict. Stop at a reviewable
result; do not automatically freeze the ABI or migrate production callers.

Experimental adapters, fixtures, harnesses and reports remain private. Reuse the
existing tier-2 tools command for native driving; create no new binary/src/bin.
Provider payloads are library artifacts. Reuse the configured shared target
directories, Nix toolchain, retained artifacts and ZFS cache; respect worker/OOM
limits. A minimal demonstrably reusable host contract can be promoted to core
without private identifiers/dependencies; its conformance fixtures must be public
and generic. All design/context notes stay in private monorepo notes.

The private crate currently enables native control-plane/parallel dependencies;
resolve target gating or a minimal library extraction explicitly before WASM
builds. Do not duplicate private algorithm source or embed the whole native host
to make a payload compile. An unexpectedly broad dependency refactor is a reported
blocker to this stage, not permission to expand the spike silently.

Deliver source/build drivers, exact replay commands and hashed fixture/artifact
manifests, a three-path parity matrix, allocation/counter/transfer measurements,
negative controls, and a short decision report. Classify each proposed guarantee
as demonstrated, failed or untested. A successful spike supports adoption of this
boundary; failures identify whether to change batching, ownership, ABI/tooling or
dependency factoring. C1130's full inventory, composition integration, canonical
consumer migration and later private glossary reconciliation remain required.

## References

Local authorities: `2026-09-08-c1130-execution-contract-proposal.md`,
`2026-09-07-c1084-portable-control-architecture.md`,
`2026-09-07-c1091-core-semantic-contracts.md`,
`2026-09-08-c1130-native-host-review.md`, and both contributor performance docs.
Binding candidates: [Rust linkage](https://doc.rust-lang.org/reference/linkage.html)
and [Jco component transpilation](https://bytecodealliance.github.io/jco/transpiling.html).
