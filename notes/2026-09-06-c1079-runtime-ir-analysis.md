# C1079 runtime / IR extension analysis

**Lane:** `ergodis`
**Date:** 2026-09-06
**Scope:** read-only core review at `~/src/ergodis`, revision `6cc96680c0c3251d094afb9b7b09bf6d1cfc8ce4`. This assesses adaptation seams for the requested hybrid extension model. It does not audit the separately owned C1032 WASM prototype or implement a loader, JIT, or source extension.

## Existing seams

| Component | Implemented behavior | Extension limit / seam |
|---|---|---|
| Text / JSON plans | Bounded text parses to `ExpressionPlanSpec`, then lowers to `PlanSpec` bytecode (`src/control/text.rs:1-110`; `src/control/vm.rs:300-580`). It supports scalar integer/Boolean expressions, explicit field names, optional mask scope, `Diagnostic`/`Ordering`, and predicate/score output. | Ready source-to-IR route for evolved steering/ordering predicates. It is not a theorem or parameter language, and cannot authorize a quotient/prune. |
| Plan VM/compiler | Closed `PlanOp` scalar opcode set (`src/control/vm.rs:670-735`); compiler validates schema, fields, stack types/depth and hashes the plan (`:941-1135`); evaluation is allocation-free per row (`:1035+`, `:1467-1545`). | Retain as the canonical IR for bounded scalar policy. It has no kernel-call opcode, module dependency, typed blob/shape value, or theorem/parameter payload. |
| Feature DAG | Canonical hash-consed typed integer terms with degree/cost bounds and snapshots (`src/feature_dag.rs:1-113,1001-1095`); supported nodes lower to plan bytecode (`src/control/vm.rs:586-668`). Diagnostic transition artifacts explicitly carry no proof authority (`src/feature_dag.rs:91-175`). | Strong representation for generated scalar features/replayable source-to-feature compilation. External semantics and theorem structure need another typed layer, not field-name overloading. |
| Discovery/evaluation | `theorem_search` has bounded evolution, finite-corpus falsification, Pareto sound-rule archive, failure cores, replay prioritization (`src/theorem_search.rs:1-310,620-1220`). Daemon evolution handles predicate `PlanSpec` over frozen `FeatureBatch` (`src/control/mod.rs:1404-1745`; `src/control/evolution.rs:1981+`). | Retain candidate/evidence loop. Finite false-positive tests do not validate a reduction or parameter instance outside the corpus. |
| Claim/provenance | Candidate/FiniteCertified/Proved status and a forward-verifiable composition DAG (`src/semantic_theorems.rs:1-345`; `src/provenance.rs:1-315`). | Evidence bookkeeping, not a scoped theorem registry/admission path. `IndependentCheck::new` accepts any nonzero caller checker ID and `u32` digest (`semantic_theorems.rs:130-150`); `record_proved` records it (`:235-252`) without running a checker. Loader registration or serialized `Proved` must never admit a reduction. The 32-bit digest is not a portable cryptographic artifact identity. |
| Control/proposer | Bounded nonce/run-bound Unix protocol, create-only artifacts, typed request-schema identities (`CONTROL_PROTOCOL.md:1-51,151-317`; `src/control/proposal_request_schema.rs:1-110`); cold proposer roles/cost selection and persistent sessions (`src/control/proposal_policy.rs:577-700`; `src/control/proposal_session.rs:1-180`). | Reuse for host-independent logical operations, budgets, and steering. `ProposalRole` is not proof-generating versus heuristic run mode or a module registry. |
| Persistence | New campaign writes private manifest, create-only ledger/evidence and proposal state (`src/control/mod.rs:210-385`). `DESIGN.md:53-76` says durable evolution checkpoint/resume and live snapshot ingestion are accepted, not implemented. | Module/source/IR identities need durable snapshots before restart can reproduce extension-dependent decisions. |

`Cargo.toml:1-45` has no dynamic-loader dependency or module ABI, and a targeted source search found no current `dlopen`, `cdylib`, or plugin registration. The core therefore does not yet load native or WASM modules.

## Proposed hybrid boundary

Use the existing text/JSON → `PlanSpec` compiler as the initial source-to-IR path for industry-authored or evolved bounded scalar policies and generated features. Keep canonical `PlanSpec`/compiled-plan hash as executable identity. Successful lowering is never theorem validation.

For theorem candidates, quotient construction, and parameters, add a separate canonical **theorem package payload** referring to feature-DAG roots and plan IR. It should hold theorem-schema ID/version, typed parameter schema and canonical instantiation, applicability/scope, source/IR/compiler identities, parents and origin event, validation-artifact references, and requested capability. Exact admission must name a checker/version and strong input/artifact digests, then execute/replay that checker in a core-owned path. This supplements `ClaimLedger`; it cannot infer authority from its status label.

**Recommended native seam.** A versioned C-ABI manifest plus one cold-path registration entry point should declare module ID/version/content digest, target, host-ABI range, named capabilities, parameter/shape constraints, bounded workspace need, determinism/replay contract, and whether each capability is proposal-only, validator, compiler specialization, or exact kernel. At startup/campaign boundary the host validates manifest/digest/dependencies, resolves pointers, compiles/binds plans, allocates workspace, then freezes a compact host-owned kernel table. Loading establishes availability only, never theorem validity, confidentiality, or reuse permission.

Use fixed-width scalars, opaque handles, caller-owned buffers, explicit capacity/error conventions, and no Rust structs/ownership/panics across that ABI. The Rust Reference says the Rust ABI has no stability guarantees and foreign items are unchecked imports: https://doc.rust-lang.org/reference/items/external-blocks.html. The host must reject unwind across ABI and validate returned ranges. This is no fault boundary: in-process modules can still crash/corrupt the host or observe memory the host exposes.

**Performance-safe option.** Native kernels load and resolve only before a run. The host selects one kernel at a measured coarse batch/root/solve-entry boundary, then the module owns its complete hot loop over host-controlled presized workspace and compact range-indexed data. There is no per-node ABI, JS/import, or module lookup; control can select a replacement only at a safe transition between such entries. The module hot loop cannot allocate, I/O, lock, parse, or dynamically dispatch. It receives the same allocation/parity/single-and-parallel A/B gates as a core kernel. Proposal, validator, and compiler-specialization capabilities stay cold and may have richer boundaries. This follows PERFORMANCE.md’s hot-loop/control rules.

## Proposed source-to-IR lifecycle

1. Package source with language ID/version, canonical source digest, declared feature/theorem dependencies, compiler options, and resource limits. For plan-language source, reuse current lexer/parser/lowerer and schema.
2. Compile in controller/compiler layer with byte/token/node/depth/op/feature-DAG bounds; emit structured diagnostics without copying secret source into public logs/status. Current limits are a starting point (`src/control/text.rs:1-110`, `src/control/vm.rs:409-580`).
3. Bind output IR, module manifests, parameter instance, presentation and run config into one immutable compilation record. Source mutation, compiler/options change, module replacement, or parameter mutation creates a new identity.
4. Reuse compiled cache only after dependency/applicability identities match. Reuse validation evidence only under checker-specific proof of preservation; ancestry alone is insufficient.
5. Heuristic mode may use unvalidated IR for exploration/order/probes. Proof-generating mode requires core-owned validation of the claimed reduction and coverage scope. Preserve shared lineage but separate mode-specific results and coverage claims.

This extends existing lowering without implying arbitrary Rust compilation, general JIT, or hot replacement of active solver code.

## Host and transport matrix

| Capability | Native host proposal | WASM-host proposal | Evidence state |
|---|---|---|---|
| Source-to-IR policy/feature | Existing source → PlanSpec/FeatureDag; cache canonical IR. | Same canonical schemas/semantic fixtures; compile in WASM only if prototype limits permit. | Core semantics exist; C1032 owner must establish prototype support. |
| Specialized kernel | Target-specific `.so`/equivalent via proposed C ABI. | Target-specific WASM artifact or host import with same logical manifest; never the `.so`. | Rust supports target-specific `wasm_import_module` declarations; this is not native-library loading (Rust Reference, same URL). No core/WASM loader found. |
| Steering | Existing protocol as logical command schema; Unix socket local transport. | Same schema over actual prototype host transport; browser needs embedding-provided transport. | Unix path must not become theorem/package identity. |
| Replay | Record target triple, module manifest/digest, ABI, IR/compiler IDs, inputs/checker artifacts. | Record WASM target/runtime/import identity plus equivalent fixtures. | Cross-target parity is an obligation, not matching package name. |
| Restart | Restore only digest-bound package records and re-resolve exactly; reject drift. | Same plus target/runtime/import checks. | Evolve checkpoint/resume not implemented. |

The browser/standalone-WASM host, loader, imports, memory limits, and source/IR support are deliberately unverified here to avoid duplicating C1032’s audit. Merge that evidence before selecting a WASM executable-artifact mechanism.

## Recommended convergence

1. **Core contract:** specify/test theorem-package payload, source/IR identity, explicit `SearchMode`, origin/derivation, validation scope, and core-owned admission replay. Gate: `Proved` sidecar/module registration alone cannot admit a reduction.
2. **IR adaptation:** bind PlanSpec/FeatureDag to the payload; only then add a bounded kernel-call declaration with concrete shape/parameter/replay semantics. Gate: existing semantics retain parity and canonical invariants unless an explicit schema version changes; generated source has bounded canonical diagnostics/lowering.
3. **Cold native pilot:** one QEC-private package, core usable without module, startup-only load, C-ABI manifest, digest-bound replay. Gate: mismatches fail closed; no loader lookup in hot loop; kernels meet existing performance gates.
4. **WASM parity pilot:** use C1032’s actual artifact mechanism for the same logical manifest/capability and shared semantic/replay fixtures. Gate: unsupported capability explicit, no silent remote fallback/weaker validation.
5. **Persistence/delivery:** snapshot package/IR/module/config identities and disclosure views; then recipient-run and hosted black-box bundles with dependency manifest and log/evidence redaction checks. Opaque artifacts reduce exposure but do not promise unrecoverability or independently replayable proof when validators/inputs are withheld.

## Open decisions

- C ABI is the conservative interoperability boundary; signing, sandboxing, out-of-process validators, unload/replacement, and WASM mechanism remain decisions.
- The current claim ledger does not by itself give trusted checker registration, artifact-strength identity, theorem scope, or solver admission; those must remain explicit contracts.
