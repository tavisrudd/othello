# C1216 — Datalog and private Rel module ABI with WASM gate

**Lane**: `ergodis`
**Date**: 2026-09-22
**Status**: QUEUED — allocated by Tavis from C1208.
**Authority**: `notes/2026-09-22-c1208-follow-up-triage.md` (approved allocation and order).

Approved C1208 alloc-8. WASM and an ABI reaching private modules are decided. Core work
depends on C1205 milestone a and C1213; private implementation follows an explicit module
boundary decision, preferably C1218. Core need not wait for mechanical private extraction.

## Scope

Extend the existing module boundary to the core Datalog route and private Rel frontend,
lowering and stratified driver. Reuse the canonical host/provider architecture. Specify
whether Rel is one source-to-evidence provider or several providers before implementation;
the allocation does not settle that decomposition.

## Acceptance

- Separately built private native/WASM modules load in the public host without private
  source or privately rebuilding core. Preserve the one-way dependency and native direct API.
- Exercise source preparation, evaluation, certified readout, evidence transfer and errors
  across the real ABI. Do not equate a build with complete host support.
- Gate the existing ergodis-rules wasm32 build and wasm_abi.mjs; add Datalog/Rel cases.
- Provide usable bounded demand workspace defaults for eager-commit targets. Test refusal
  and small-memory execution without relying on Unix virtual-memory overcommit.
- Native/WASM results and certificate bytes agree where contracted; checker provenance
  and structured refusals survive the boundary. C1196's ABI format-tag gate uses this work.
- Retain lifecycle/ownership tests and required conformance/performance evidence; native
  performance is not traded away for portability.

Dated report distinguishes implemented, exposed and actually tested capabilities. General
campaign integration or unrelated providers remain outside this task.

## Closeout

Write the dated task report and follow `notes/task-lifecycle-conventions.md` at completion.
Follow local repository instructions and the professional source-comment standard.

