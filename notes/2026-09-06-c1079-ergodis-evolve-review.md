# C1079 — autonomous Ergodis convergence and delivery plan

**Lane**: `ergodis`
**Date**: 2026-09-06
**Status**: COMPLETE — review and recommended plan delivered; implementation remains downstream.
This is a recommended architecture and staged
implementation plan, not a source migration, release, IP allocation, or claim of shipping readiness.

## Recommendation

Consolidate around a portable, core-owned campaign engine that discovers candidates, chooses
experiments, refines its representations from counterexamples, validates theorem/parameter
instances, compiles admitted quotients, and measures their actual effect on solving. Keep native
sockets, browser workers, persistence backends, and industry packages as adapters around those
same semantics. Reuse the existing engines and languages; connect them through explicit contracts.

Make industry packages hybrid: source/IR for extensible logic and target-specific executable
kernels for specialized work. A package may carry a native library and a WASM kernel variant,
with one logical capability identity and separately identified target artifacts. Keep QEC-specific
knowledge separable; shared discovery, compiler, control, and validation workflows belong in core.
Ship recipient-run native/browser black boxes first, then hosted access using the same packages
and campaign semantics. Both delivery modes are required. Opaque/precompiled IR is a packaging choice, not automatically
obfuscation or evidence of independent replay. An attractive demo is a milestone,
not evidence that autonomous theorem discovery or all-platform support is complete.

The highest-value first implementation slice is a **portable candidate/parameter/admission contract
connecting an existing proposer to an independently checked bounded reduction and a real solver
consumer**. Recover the C1032 browser baseline alongside it. Starting with obfuscation or a large
plugin loader would leave the central discovery-to-solve gap intact.

## Evidence and limits

The reviewed source snapshots are core `6cc96680c0c3251d094afb9b7b09bf6d1cfc8ce4`, private
`74b7ca9243b143edeb5af58f69f1a55cc7f4a710`, and C1032 branch
`codex/c1032-ergodis-wasm` at `d5a39e5f43e29ca8965dd45dc174b92265fccb65`. The prototype lives in
`/home/tavis/src/othello-worktrees/c1032-ergodis-wasm/papers/complete-repair-ports/ergodis/wasm/`.

| Evidence memo | Coverage |
|---|---|
| `2026-09-06-c1079-core-inventory.md` | Current core evolve, control, proof-status and provenance machinery |
| `2026-09-06-c1079-private-inventory.md` | Private/C1016 extraction, replay, proof rules, and documented campaign behavior |
| `2026-09-06-c1079-research-inventory.md` | Earlier research, especially C985 architecture and spikes |
| `2026-09-06-c1079-roadmap-inventory.md` | Promotion survey, existing evaluation objectives, queued benchmark gates |
| `2026-09-06-c1079-wasm-capability-audit.md` | Recovered C1032 prototype, historical test evidence, current portability limits |
| `2026-09-06-c1079-promotion-ip-analysis.md` | Reusable/private candidates and QEC asset/dependency inventory |
| `2026-09-06-c1079-runtime-ir-analysis.md` | Existing languages/IR, native module seams, host-independent workflow proposals |
| `2026-09-06-c1079-build-test-docs-audit.md` | Actual manifest/export/CI/test controls and proposed discipline |

These are bounded source/document audits by the parent and user-requested Terra sub-agents.
No source changes, new build, browser run, benchmark, loader, or migration was performed.
Historical measurements/tests remain attributed to their reports; current portability is not
claimed from an old successful build. New architectural recommendations below are explicitly
proposals. No present solver unsoundness exploit was established by this review.

## What exists and what needs convergence

| Component | Current evidence | Recommendation |
|---|---|---|
| Generic evolution | `theorem_search.rs:302,467,1486` supplies a runner-neutral driver and streaming evolution, archives and failure cores | Retain as shared discovery primitives; adapt daemon/spikes to common candidate/event contracts without immediately rewriting both loops |
| Native campaign | `control/evolution.rs:1981` and `control/mod.rs:1404–1745` own bounded low-priority frozen-batch evolution | Retain proposer, niche, replay and budget mechanisms; move campaign semantics behind a portable host interface |
| Source/IR | `control/text.rs`, `control/vm.rs:300–580`, `feature_dag.rs`; text/expression → PlanSpec, typed feature DAG → plan | Reuse scalar policy IR and DAG semantics; extract filesystem-free parsing/lowering/evaluation; add typed theorem/parameter/quotient payloads rather than overloading a field name |
| Proof-status bookkeeping | `semantic_theorems.rs:133–145,227–245`, `provenance.rs` | Retain DAG and status records as bookkeeping; add real checker execution, exact subject/scope binding, and admission decisions |
| Private proof synthesis | `proof_synthesis.rs:220–262,291–321,386–480` binds extractors and replays registered derivations | Promote reusable extractor/derivation/replay contracts; retain selected private rules, recipes, and theorem implementations |
| Typed private recipes/features | `semantic_plan.rs`, feature synthesis/evolve modules and C1016 corpora | Fold reusable operations into core IR/compiler/discovery mechanisms; private names, corpora, policies and theorem selections remain package data/code |
| CEGAR-shaped spike | `tasks/hadamard-2092/src/evolve/theorem_gap.rs:604–639` retains direct-model refutations | Reuse counterexample/admission plumbing; preserve planted-family scope and distinguish it from general abstraction-refinement proof |
| WASM | C1032 exports only bounded GF(2) `solveCompositionJson` in a Web Worker | Forward-port the small adapter to current core and validate it; do not merge the old monorepo tree wholesale or label native evolve browser-ready |
| Runtime industry modules | No native dynamic loader, cross-target industry package contract, or IR kernel import system in inspected implementation | New work at a common package boundary; keep native and WASM loaders target-specific |

Private work is not automatically secret business knowledge: generic synthesis and workflow code
belongs in core even when C1016 produced it. Conversely, promoting an interface is not permission
to copy the private theorem catalogue, training fixtures, tuned policy, or evidence into core.

## Intent reconciliation and priority-ranked findings

**P0 — disclosure/ownership decisions must precede external export or asset allocation.** QEC assets span
core CSS/BP-OSD support and private Tiger/DEM/window/predecoder work (promotion/IP memo). Current
location does not establish what has been publicly disclosed or who owns it. Map the release
history and asset dependencies before classifying any item as an exclusive private asset.
Generic core contract work can proceed with explicit unknown/withheld asset metadata. This is a
release/allocation gate, not a reason to block internal cleanup or a finding of prior disclosure.

**P1 — proof admission is not supplied by proof-status bookkeeping.** Public
`IndependentCheck::new(checker_id, digest)` accepts any nonzero caller ID; `record_proved` records
that attestation. It does not execute an independent checker. The `u32` subject/digest is not a
portable cryptographic artifact identity. This is source-reproducible API behavior, not an exploit
of a known consumer. Never let module registration, a decoded `Proved` label, or corpus perfection
authorize an exact reduction. Preserve status records but bind admissions to actual checker runs.

**P1 — mode, origin, and validation are inconsistently expressed.** Private `ProvenanceClass`
contains `ProvedStructural`, `ExactComputational`, `ObservedEvolved`, `HeuristicSearch`, and
`DirectWitness` (`proof_synthesis.rs:299–305`). Core proposal role and VM plan role are separate
again; `PlanRole` only admits diagnostic/ordering (`control/vm.rs:320–323`). No inspected
end-to-end run contract expresses the user’s independent dimensions. Keep existing fail-closed
pruning guards during migration; do not rename `ObservedEvolved` to an authority level.

**P1 — the autonomous loop is partly implemented, not integrated through quotient admission.**
Current daemon evolution exists; claims that it is wholly future work are stale. Current
`DESIGN.md:53–76` still identifies live snapshot ingestion and durable evolution checkpoint/resume
as unfinished. Existing per-corpus perfection and cost proxies do not demonstrate autonomous
selection of admitted quotients by measured end-to-end value.

**P1 — WASM and deployable modules are separate delivery gaps.** The C1032 slice has historical
browser/parity evidence; current core did not retain its adapter. Neither it nor core provides
the requested industry loader. Restoring one export does not port the Unix/fs/thread-dependent
control plane. Current WASM compilation and compatibility still need fresh validation.

**P2 — terminology can incorrectly narrow ambition or overstate guarantees.** Earlier C985
proposal/admission architecture already specifies unattended proposers (`:98–103,229–235`).
Frozen-corpus descriptions describe an implemented arm, not a repudiation of autonomy. Likewise,
a generic ClaimStatus enum is compatible with rejecting a generic `verified=true` admission bit.
Suggested document corrections after architecture approval: qualify implementation status by
revision; state mode-specific permissible use; distinguish source/provenance, evidence status,
and admission; replace diagnostic-only product framing with the broader goal while retaining the
current implementation limitation. Do not attribute correctness to model authorship.

## Proposed portable campaign architecture

```mermaid
flowchart TD
  P[Industry packages: source IR and target kernels] --> R[Core capability registry]
  C[Campaign contract and immutable problem version] --> D[Core discovery and experiment scheduler]
  R --> D
  D --> F[Candidate and parameter lineage]
  F --> E[Bounded evaluation and refutation]
  E -->|counterexamples or collisions| D
  E --> A[Scoped checker execution and role admission]
  A --> Q[Quotient and execution-plan compiler]
  Q --> S[Native or WASM solver kernel]
  S -->|work quality and new observations| D
  A --> L[Semantic evidence store]
  S --> M[Conditional performance store]
  L --> D
  M --> D
  U[Native Unix socket] --> H[Host command adapter]
  B[Browser Worker messages] --> H
  A2[Hosted API] --> H
  H --> C
```

Core owns portable campaign contracts and state-transition semantics; native daemon and Worker
adapters may remain distinct while consumers migrate. Host services supply clocks, durable storage,
bounded scheduling/cancellation, and transport. Native uses the existing Unix-socket protocol and
watcher; browser uses Worker messages and an explicit persistence adapter; hosted access invokes
the same logical operations. Socket path, host clock, or native pointer is not semantic identity.
For native delivery, recommend one shipped `ergodis` executable with run/evolve/serve/control/
replay/package subcommands over the same library; existing helper binaries remain compatibility
drivers until migration. One executable may run in client or daemon roles without requiring a
second separately shipped core binary. WASM retains its embedding adapter.
Expose start/pause/cancel/checkpoint/status, budgets, proposer/target hints, package capabilities,
mode, evidence and approved disclosure views. Steering issues versioned commands; it does not
mutate a frozen problem or rewrite historical lineage.

The autonomous cycle is bounded but recurrent: select unsolved regions/observational collisions;
propose features, theorems, parameter instances, partitions or decompositions; falsify cheaply;
request stronger evidence for promising candidates; compile admitted plans; race against controls;
retain semantic discoveries and conditional performance results; choose the next experiment.
Stop on solved objective, exhausted budget, or explicit pause—not merely one completed population.
The baseline remains an eligible policy; no improvement is a valid result.

From AlphaEvolve, retain the evaluated candidate population and feedback-driven proposal portfolio;
from CEGAR/CEGIS, retain refutation-driven refinement and explicit abstraction/synthesis obligations.
Do not call mutation with a few failing examples a proved CEGAR loop. Candidate-language expansion,
new theorem shapes, and new parameterizations remain possible through typed capabilities and
proposers; a fixed initial catalogue is a bootstrap, not the product limit. External code or LLM
proposals remain untrusted producers and cannot rewrite their own verifier to gain authority.

## Contracts that must be independent

| Record | Proposed contents / invariant |
|---|---|
| Run contract | Goal, proof-generating or heuristic mode, authoritative problem/domain, budget, package set, admitted capabilities, coverage and termination semantics |
| Candidate origin | Human/imported/generated/evolved/composed origin events, exact parent versions, generating operator/proposer/config/input IDs; origin is immutable history |
| Theorem and parameter records | Distinct IDs for theorem statement/schema, parameter schema, each instantiation, scope/side conditions; an evolved parameter is not hidden inside a theorem name |
| Validation evidence | Checked statement/domain, checker implementation/version, allowed host/profile, execution/input/artifact digests, determinism/resource outcome, assumptions, result, independent replay route; finite coverage names the full finite domain |
| Admission decision | Particular capability/role + problem version + parameter instance + obligations + checker evidence; availability or status alone never implies admission |
| Compilation record | Source/language/options/compiler/IR IDs, resolved kernel identities, target and workspace requirements; exact artifact digest separate from source semantic identity |
| Confidentiality/use record | Asset/industry association, allowed consumers/disclosure view and explicit decisions; separate from origin, truth status and proposed legal owner |
| Performance record | Build/target/hardware/input distribution/protocol/budget, work/quality/cost, censoring and paired controls; a performance prior can expire without deleting a counterexample |

Use strong content digests for portable records; retain small local IDs for efficient in-memory
DAGs. A hash provides identity, not truth or ownership. Reuse existing ancestry and evidence rather
than erasing it during schema migration. Legacy artifacts get explicit legacy/unknown fields;
unknown provenance cannot be silently upgraded by filling invented origin data.

**Mode transitions:** changing a run mode creates a new run epoch/branch with an explicit coverage
ledger. Heuristic restrictions may find valid witnesses, which can be checked independently, but
cannot establish absence/optimality over discarded regions. Entering proof-generating mode must
revalidate each effective reduction and cover excluded regions or restart from a complete frontier;
toggling a flag cannot repair prior omissions. Proof-generating runs may use heuristic ordering or
proposal selection when all claimed coverage/reduction obligations still hold. A finite exhaustive
check can be sufficient proof for its entire declared finite problem; generalization beyond it
needs its own evidence. Private or evolved origin never disqualifies an otherwise checked theorem.

**Mutation and composition:** changing source, parameters, scope, checker, kernel semantics, or
compiler creates a new identity. Reuse evidence only through a checker-specific preservation
argument or fresh replay. Composition carries the premises’ scopes, side conditions and disclosure
restrictions; neither weakest-premise status alone nor a DAG edge establishes applicability.

## Choosing quotients and incorporating the spikes

Correctness, requested role, resource bounds and permitted use are admission constraints, not
terms traded against speed. Among eligible candidates retain a frontier over discovery and
validation cost, compile/load cost, states/transitions removed, kernel evaluation cost, memory,
reuse horizon, and downstream composability. In heuristic mode also price witness quality and
success probability under a declared budget; heuristic scores cannot become proof-mode exclusions.

Measure total task cost: proposal + validation + compile/load + solve + required replay. An
amortized view may divide reusable setup by an explicit expected reuse count; also report the
cold single-use result. Use identical root/stratum inputs, budgets and output obligations for
paired races; keep timeouts censored. Report no-win and clean-miss controls. “Optimal quotient”
means best observed admissible choice under this objective unless a bounded exhaustive comparison
or theorem establishes optimality over a stated candidate family.

Fold the following into the core workflow, preserving narrow evidence:

- C985 exact falsification, outcome-class/niche archives, hard-example replay, typed proposer
  sessions and resource policies: already present; join them before adding a new scheduler.
- C985 scope-as-genome, paired root races, separate semantic/performance stores, and snapshot/WAL
  design (`2026-08-30-c985-ergodis-adaptive-search-learning-adr.md:63–235`): finish the missing
  integration, using immutable presentation transitions and persisted restart state.
- Private registered extraction/Horn replay and typed semantic recipes: extract reusable contracts
  and feed the existing DAG/IR; selected proof rules and tuned recipes remain private modules.
- Generic relational/symmetric/feature synthesis and contextual scope/projection machinery:
  port or adapt genuinely missing reusable operations after comparing core equivalents; retain
  private training corpora and theorem choices. Do not require a wholesale private directory move.
- The theorem-gap spike: use its bounded direct-model counterexample/admission story as the first
  discovery-to-solver acceptance fixture. C1039’s planted result is a controlled demonstration,
  not general blind-discovery evidence. C1045/C1046 already own transfer/composition evaluations.
- C1016 quotient ladders and the zero-cost-witness memo: use them to validate parameter binding,
  scoped exclusion, downstream-aware selection and cold validation. Keep specialized static
  adapters fast; replacements first require exact verdict/witness/certificate parity and replay,
  then measured generic-path performance under the existing contract.

Retire duplicated persistence formats and manual replay drivers only after consumers migrate and
replay passes. Retain the old drivers as controls meanwhile. No new generic engine should coexist
indefinitely with an equivalent older one merely because a spike has a different vocabulary.

## Hybrid packages and host execution

Recommend a versioned logical manifest: package/capability IDs, dependency and core/IR version
ranges, source/IR and target artifact digests, role/shape/parameter contracts, workspace bounds,
checker dependencies, available host profiles, and disclosure/use metadata. A package may contain
source for runtime compilation, prepared IR for distribution, and one or more kernel artifacts.
A semantic identity survives target lowering; each target implementation still needs its own
identity, compatibility checks and required parity evidence.

**Source/IR:** start with current text/PlanDocument/FeatureDag lowering for scalar policy and
features. Add typed structural payloads for theorem schemas, parameter domains, exact reductions
and quotient plans. Do not pretend PlanSpec’s scalar opcode set already represents those.
Extract pure lowering/evaluation from filesystem/control dependencies. Runtime compilation is
cold, resource-bounded, and reproducible; demo builds may prepare opaque IR in advance. Generated
source and private imports remain in internal records, not automatically in user-facing diagnostics.

**Native kernels:** recommend a small versioned C ABI with cold registration, fixed-width
metadata, opaque handles, explicit buffer ownership/capacity/error rules and no Rust-owned
containers or unwinding across the boundary. Load and resolve before campaign execution; pin a
module while compiled plans refer to it. Defer live unload/replacement. Invoke a coarse batch,
root or solver entry so the specialized kernel owns its hot loop; do not add a loader/trait/FFI
lookup per state. Control updates occur only at measured safe points. Dynamic libraries are a
packaging boundary, not an isolation boundary; exact consumers must name their trusted checker
and kernel obligations. Untrusted proposal execution can use a separate process/host capability.

**Browser WASM:** restore the C1032 adapter against current core, then add the portable compiler
and campaign step API in a Worker. Use the same package manifest with WASM kernel variants,
explicit imports/exports, bounded memory/buffers and coarse calls. Recommend an ordinary module
instantiation/host-binding pilot before committing to a component-model or toolchain-specific
side-module architecture. The browser cannot use the native Unix socket path as its transport.
A missing kernel variant returns an explicit capability error; no silent cloud fallback or weaker
validation. Keep browser parallelism a later measured gate; the first parity target is sequential.

**Host-independent workflows:** a cooperative bounded-step engine can run in the native daemon
or a browser Worker. Input snapshots, cancellation/checkpoint safe points and deterministic event
ordering must not depend on native threads. Storage adapters preserve the same logical records;
concrete filesystem WAL and browser persistence are different implementations. Hosted delivery
wraps these operations in authenticated remote access, with separate resource and data policies.

## Industry IP and QEC separation

Keep general compiler/discovery/replay interfaces in core. The leading private QEC package nucleus
is DEM parsing and model adapters, TigerBlossom/specialized decoder kernels, syndrome/window and
predecoder policies, tuned parameters, fixtures, benchmark generators and private evidence. Core
already has CSS and BP/OSD machinery; classify those explicitly rather than pretending the whole
industry implementation is presently isolated or private.

Produce an asset/import/disclosure map before movement: current repository/revision, upstream
provenance, publication history, core dependencies, intended package, proposed permitted use and
unresolved ownership questions. A carve-out acceptance gate is independent build/test/deployment
against a versioned core SDK, with no dependency on unrelated private industry packages, plus
explicit core access/licensing questions for business/legal decision. Do not infer patentability,
inventorship, ownership or derivative-work status from repository paths or generated ancestry.

The current core manifest declares `license = "AGPL-3.0-only"` (`ergodis/Cargo.toml:8`).
Before local or hosted black-box release, resolve the intended licensing route and rights to
license every included dependency/contribution with appropriate legal review. A `.so`/WASM/IR
boundary does not by itself answer those questions. This review neither changes the license nor
concludes that a particular proprietary combination is permitted or forbidden. The authoritative
license text/FAQ is a starting reference, not a substitute for that project-specific decision:
https://www.gnu.org/licenses/agpl-3.0.dbk and https://www.gnu.org/licenses/gpl-faq.en.html.

Track cross-industry input use conservatively in internal lineage. Candidate archives, learned
policies, parameter recipes, theorem compositions and generated source can carry private inputs
across packages. Record those inputs and require an explicit reuse/disclosure decision when a
boundary is crossed; changing a truth status or compiling to IR must not remove the association.
Technical policy is not an automatic legal conclusion. A module can be available locally while
its source, parameters or proof details are excluded from a particular demo view.

## Shippable and hosted black-box demos

| Delivery | Concrete proposed bundle | Acceptance boundary |
|---|---|---|
| Recipient-native | One core binary + approved native kernel libraries + opaque/precompiled IR + compatibility/asset manifest | Runs on declared clean target with hosted access disabled; rejects mismatched dependencies; meaningful results and documented limitations |
| Recipient-browser | Static app/Worker + current core WASM + approved WASM kernels/opaque IR + manifest | Locally deployable HTTP-served bundle, documented browser targets, current parity/smoke evidence, no mandatory remote solve; hosting files is not hosted computation |
| Hosted | Same package/capability identities in managed workers behind a bounded authenticated API | Remote job isolation/resource limits, explicit data retention and approved output view; parity with the corresponding local semantic cases |

For both kernel and IR paths: minimize exported symbols, remove debug/source-path/source-map and
unneeded string/metadata payloads, ship only required assets, and avoid plaintext theorem source
or private training data unless explicitly chosen. Evaluate additional obfuscation against actual
artifact inspection, performance and reproducibility; do not start with bespoke encryption or
claim embedded keys make recipient-controlled execution secret. Record residual recoverability.

Apply disclosure views at the source of output: socket/status API, browser messages, source/IR
inspection, logs/errors, temporary files/caches, candidate archives and proof/replay exports.
Keep vendor-side build/source provenance separate from the minimized recipient package; do not
ship a supposedly hidden full-source audit log alongside obfuscated code. Recipient-generated
lineage records retain required IDs and evidence without injecting withheld build-time source.
Record that recipient-generated runtime data remains inspectable on that host. A recipient view
may expose a checked witness, aggregate
metrics and public checker while withholding internal search recipes; whether that is possible
must be tested for each capability. If evidence needed for independent replay is withheld, label
the result accordingly. Black-box packaging must not counterfeit a public proof claim.

The demo should show a baseline, autonomous proposals/refutations, an admitted scoped improvement,
measured solve work and a checked result, plus steering and restart. It must also show a negative
control where evolve cannot improve or cannot certify a candidate. A planted generic fixture is
honest first evidence; a separately approved QEC example establishes industry relevance later.

## Broader core/private consolidation

The split should be maintained by dependency and capability contracts, not by whether a module
happened to originate in a research task. The broader audit is bounded to manifests, module
exports, selected implementations and existing promotion reports; same-named modules are leads,
not proof of interchangeable semantics.

| Layer | Proposed stable home | Concrete current cleanup |
|---|---|---|
| Generic arithmetic, matrix/field, masks and margin helpers | Core | Compare private `two_adic_autocorrelation`, `z2k_subgroup`, `bitset_sumset`, `binary_margin_lift` with current core `arithmetic`/margin APIs; migrate callers where parity holds before retiring old code |
| Claim/provenance and predicate cover | Core contracts and reusable implementation | Core and private both expose `semantic_theorems`/`predicate_cover`; reconcile differing authority/serialization contracts instead of selecting a copy by name |
| Compiler/representation/discovery | Core portable modules | Compare `hall_core` vs `hall`, generic `repr_grammar`/`semantic_sets`, scope/projection and feature producers; promote missing reusable operations behind the existing compiler/DAG vocabulary |
| Campaign/runtime/transport | Core workflows; host-specific adapters | Extract Unix/filesystem-dependent glue from pure source/IR/discovery semantics; migrate helper binaries to the single shipping CLI without rewriting proven kernels |
| Industry implementations | Explicit private packages consuming core | QEC decoder kernels/model adapters, private theorem catalogues/tuned heuristics and data remain separate; a reusable but deliberately withheld implementation needs an explicit decision, not accidental placement |
| Task research | Private Tier-2 task drivers and private fixtures | Keep C1016 campaigns and problem-specific rule registrations out of generic workflows; migrate only generic dependencies upward |
| Evidence and contributor tooling | Evidence with producing package; shared schemas/tooling in core/contrib as appropriate | Preserve one-way evidence export, private oracle data and retained-baseline tooling; migrate path references atomically with code and replay evidence |

Recommended cleanup sequence: (1) create a small module ownership/dependency map; (2) resolve
obvious overlapping generic APIs with caller and differential checks; (3) extract portable
compiler/campaign contracts; (4) migrate generic proof/synthesis seams; (5) package industry
payloads. Each coherent change gets its own scoped validation and forward commit. No omnibus
rename, no wholesale historical branch merge, and no private source deletion before caller,
fixture and replay migration. Existing performance remediation remains coordinated with C1017.

Maintain an explicit exception for intentionally withheld kernel/theorem implementations behind
core interfaces. “Generic interface belongs in core” does not decide public disclosure of every
optimized implementation. Core source location and filtered public release remain separate.

## Build, test, and documentation discipline

The audit finds useful existing controls: private task tiers, feature separation, shared target
directories, export/lint refusal fixtures, independent parity tests, allocation tests, retained
A/B tooling, and a strict existing `performance/check_kernel_registry.py`. Reuse them. The
inspected public CI runs confidentiality lint; broader build/test/evidence requirements are
primarily guide/checklist driven. This is an enforcement gap, not evidence that those checks
currently fail. No proposed gate may silently weaken the existing mandatory core/private rules.

Recommend named Make/script targets using the pinned Nix/toolchain setup; names below are a
proposed interface, not commands claimed to exist today:

| Gate / owner | When | Required scope and failure behavior |
|---|---|---|
| `check-core` / core | Core change and integration/release | Required fmt/clippy/all-feature tests plus bounded independent Python exact differential corpus, CLI/RPC/source-IR tests and publication guards; fail clearly on missing oracle/toolchain, no silent skip |
| `check-private` / private workspace | Private change or paired core update | Workspace/tier rules, fmt/clippy/tests, affected exact/replay/allocation fixtures against a recorded core revision; no private fixture dependency in core-only tests |
| `check-targets` / host adapters | Feature/target/ABI changes; release | Core default-feature native check separately from all-features; restored WASM sequential target+browser smoke/parity; package compatibility, wrong-target/missing-capability and exact cross-target tests; unsupported targets labelled, not green by omission |
| `check-integration` / paired workspace | Core API/compiler/schema changes | Recorded core/private/contrib and package revisions, manifests/lockfiles/toolchain; compile affected private consumers and replay migrated artifacts. Private main remains path-dependent for development; release manifests bind exact revisions/hashes |
| `check-kernel` / C1017-compatible tooling | Changed registered hot paths, layouts, communication or performance claims | Reuse strict registry checker; allocation-free/iterative/layout tests, exact replay, retained interleaved native A/B in single/parallel modes, memory/contention evidence. Missing evidence blocks performance acceptance; docs-only edits do not rerun benchmarks |
| `check-docs` / component owners | API/feature/protocol/docs changes; release | Checked support matrix and command/link/schema references; private examples stay private; implemented/proposed/deprecated marked with evidence revision; public commands execute from filtered tree; source/API docs and migration notes match behavior |
| `check-release` / release owner | Any native/browser/hosted demo or public snapshot candidate | Invoke applicable gates on the actual assembled artifact, not only development checkout; export refusal fixtures, asset/dependency/license/disclosure manifest, evidence-tag resolution, clean install/start, local no-remote-solve test, approved observability and explicit replay limits |

Pin and record compiler/target/features and dependency resolution for reproducible applications;
keep build outputs out of source trees and use existing retained-binary tooling. A changed shared
schema/core API triggers paired private integration; changing only private heuristics does not
force public CI to learn their identities. Public CI may run only tests available in the filtered
tree; private CI/local release validation retains private oracles and datasets. No credentials or
private evidence are shipped to make a public test green.

Use one maintained capability matrix as the documentation index: capability, host/feature,
source/IR/kernel support, validation scope, test/evidence pointer, status and owning module/task.
`DESIGN.md` owns architecture, API/tests current behavior, protocol docs wire contracts, and dated
research notes experimental evidence. Update them together at each implementation gate; the queue
and handoff remain routing maps. This would have made the missing post-split WASM adapter and stale
“daemon evolution future work” descriptions visible without rediscovering history.

Tests should target failure boundaries, not mirror implementations: forged status/module identity,
wrong theorem parameter/scope, unsound parent mutation, malformed/oversized IR, ABI/lifetime drift,
interrupted restore, private metadata leakage and native/WASM divergence. No-op control and
negative-performance controls remain required. New gates become mandatory alongside the feature
that implements them, not permanently failing placeholders for unsupported work.

## Staged implementation and acceptance

Stages below are recommendations, not newly allocated tasks or approval to migrate code.
Existing C1032, C1031/C1033, C1017, C1039/C1040/C1041/C1045/C1046 and C1061 ownership must be
reconciled before assigning duplicate work. C1039 is closed evidence; the other cited tasks’
current states should be read from exact queue rows at dispatch.

| Stage | Concrete output | Dependencies and acceptance |
|---|---|---|
| 0. Preserve and recover | Current source/revision map, QEC asset/import inventory, forward-port plan for C1032, maintained browser build target | No wholesale historical merge. Fresh default-core WASM check, existing eight-case semantic parity and browser smoke before claiming restored support; coordinate with C1032 |
| 1. Contracts and one admitted loop | Portable run/candidate/theorem/parameter/validation/admission records; existing proposer → direct-model check → compiled consumer | Reject forged status, wrong parameters/scope/checker, replay drift and heuristic negative-coverage upgrade. Use C1039 fixture plus a clean-miss/control; no plugin needed to prove the contract |
| 2. Portable compiler and workflow | Pure text/DAG/IR library, candidate roles, bounded campaign stepping, host services and durable semantic/performance records | Native/Worker same candidate semantics; deterministic checkpoint/restart; budget/cancel and corrupt/mismatched restore tests; live snapshots off hot path |
| 3. Package contracts and native pilot | Core-only executable and one external package with both native kernel and source/IR paths | Common manifest resolves native/WASM profiles and reports unavailable variants explicitly; ABI/dependency/resource errors, workspace ownership/lifetime tests, no hidden private core dependency; cold compile/load + warm solve accounting |
| 4. WASM package parity | Same logical package with WASM kernel variant and source/IR support in recovered Worker | Same bounded exact results, witnesses, parameter semantics and admission decisions across targets; explicit missing capability; no per-state JS bridge |
| 5. Autonomous refinement and value | Persistent refutations, scoped features, theorem/parameter mutation, quotient competition, paired feedback, reusable validated discoveries | One no-human-steering campaign runs through multiple refinements/restart; holdout failures refine rather than promote; states/compile/solve/replay/censoring controls, transfer/composition reuse existing tasks |
| 6. Recipient-run demo release candidate | Clean native package and locally deployable browser package, opaque approved payloads, disclosure views, manifest, instructions | Clean-target install/run with remote solve unavailable; native+IR+WASM capability tests, output/artifact inspection, verified result or explicit evidence limit; QEC payload selected separately |
| 7. Hosted demo and industry separation | Authenticated bounded service using same capabilities; independent QEC package build/test/deploy recipe | Same semantic fixtures and approved outputs as local; retention/resource/access tests; core SDK dependency and asset map sufficient for technical separation review |

The named build/test/docs gates and ownership map are cross-cutting acceptance work, coordinated
with existing task scopes; there is no claim that current core/private/docs are clean.
Stages 0 and contract design can proceed together; package ABI and irreversible source movement
wait for contract/ownership decisions. A first honest local demo can ship after stage 4 with its
limited autonomy labelled; the requested autonomous-system demo requires stage 5 too. Both delivery
modes remain acceptance items, not an excuse to substitute hosted execution for local delivery.

All solve-impacting implementation keeps the existing allocation-free, iterative, presized,
contention-free worker contract. Run the core’s required fmt/clippy/tests and exact differential
replay; hot changes additionally need retained interleaved hardware-counter A/B in single and
parallel modes, memory and contention evidence. Browser validation has its own semantic/resource
and browser-run gates; native performance numbers do not certify browser performance. No new
performance claim is made by this document.

## Decision register and completion boundary

Recommended choices for the user’s review: portable core workflow and typed records; preserve
existing scalar IR with structural payloads above it; versioned C ABI at coarse native kernel
entries; WASM module variants with host bindings; startup/campaign-boundary loading and no live
unload initially; QEC private package as the first industry boundary; recipient-run demos first
with hosted delivery using the same contracts. These are concrete recommendations, not implemented
architecture changes. ABI layout, exact browser mechanism and industry asset disclosure need
review at their respective gates rather than a blanket approval of every later detail.

The architecture/review task can close when its evidence and recommendations pass review. Source
migration, prototype restoration, implementation, packaging, public release and IP transactions
are downstream work. No extra task IDs are allocated merely to duplicate the existing queue.

## Sources and closeout

Primary technical references consulted on 2026-09-06 supplement the local evidence:

- Rust dynamic system libraries and their platform outputs:
  https://doc.rust-lang.org/reference/linkage.html
- Rust FFI ownership/callback/unwind considerations:
  https://doc.rust-lang.org/nomicon/ffi.html
- Bare WASM target limitations (`std::fs`, ordinary thread spawning) and distinction from WASI:
  https://doc.rust-lang.org/stable/rustc/platform-support/wasm32-unknown-unknown.html
- WebAssembly modules/imports/exports and host integration:
  https://webassembly.github.io/spec/core/intro/overview.html
- AlphaEvolve’s proposal/evaluation/population loop:
  https://deepmind.google/blog/alphaevolve-a-gemini-powered-coding-agent-for-designing-advanced-algorithms/

These inform the proposed boundaries, not a claim that a toolchain/plugin option is already
implemented. CEGAR/CEGIS lineage is grounded in the recovered C985 literature/synthesis reports;
no new novelty or prior-art absence claim is made.

**Closeout review:** the Terra adversarial pass found no remaining material issue after corrections
to transport separation, host-specific validation, exactness-before-performance, WASM-aware package
contracts, and shipped-host provenance exposure. Parent cross-checks recovered the existing strict
kernel-registry checker and corrected the proposed duplicate checker; confirmed the current
source-to-IR compiler; and inspected the caller-supplied IndependentCheck boundary and current
license declaration. Document/path/queue lifecycle validation passed; no code tests were run.

**Extra-value / ej+tt pass:** much apparent missing infrastructure is already present under a
different historical vocabulary. The cheap leverage is reusing it: core feature/plan compilation,
the strict registry validator, existing evolution drivers, and the preserved C1032 worktree.
These observations were folded into the plan rather than spawning duplicate tasks. Requiring
proof admission at a typed boundary also makes industry packaging and native/WASM parity testable
without choosing a particular private theorem catalogue first.

**Mystery ledger:** no new mathematical mystery arose. The substantive open questions are
engineering evidence gaps: current-core WASM compatibility (stage 0), end-to-end scoped admission
(stage 1), portable restart (stage 2), native/WASM package parity/performance (stages 3–4), measured
autonomous quotient value (stage 5), actual disclosure/obfuscation effectiveness and licensing
readiness (stages 6–7). None was resolved by static inspection alone. Each remains an explicit
implementation or release gate; no incidental discovery-track entry is warranted.

**Next decision:** review the recommended contracts/ownership and authorize a bounded stage-0/1
implementation pilot, coordinated with C1032/C1017. No implementation successor ID has been
allocated before that architecture/scope decision. The existing C1079 deliverable is complete.
