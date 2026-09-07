# Ergodis compiled exact-optimization engine — archive

**Lane**: `ergodis`

This is the append-only historical companion to
[`2026-09-05-ergodis-lane.md`](2026-09-05-ergodis-lane.md). Measurements, certificates, replay
commands, probe narratives, and correction trails live in the linked dated reports; this file
records dispositions that no longer belong in the live router.

## Pre-split history (before 2026-09-05)

The lane was split out of `complete-ports` on 2026-09-05. Every Ergodis disposition recorded before
that date stays where it was written, in the
[complete-ports archive](2026-07-17-complete-ports-paper-archive.md) — which holds the
Ergodis/decoder exploration narrative through 2026-09-05 — and in the dated reports under `notes/`
that it links. Nothing was copied forward. The live frontiers for C1016, C1017, C1061, C1062, and
C985 moved verbatim into the new handoff and are not archived here.

## Archived from the live handoff

No entries yet.

## 2026-09-06 — C1079 review and convergence plan

Completed the user-directed synthesis of core/private evolve, C985/C1016 research, and the
recovered C1032 browser prototype. Report: `notes/2026-09-06-c1079-ergodis-evolve-review.md`;
its evidence table routes the eight supporting inventories/analyses. The plan separates search
mode, origin, scoped validation and disclosure; recommends core workflow consolidation, hybrid
native/IR industry extensions and QEC separation, native/WASM and recipient-run/hosted demos,
and concrete build/test/docs gates. Static/adversarial review only; no source migration, build,
benchmark, release, or IP allocation. Next implementation allocation awaits the recommended
architecture/scope decision. No incidental mathematical discovery arose.

## 2026-09-07 — C1080 complete

Portable finite admission/discovery pilot and current-core browser recovery committed as
`5247f6d` and `95d16b9`. Native gates, eight-case adapter Python parity, wasm release build and
Chromium Worker smoke passed; 64-bit layouts remain unchanged with exact guards. Scope, replay
and remaining campaign/IR/module gates: `../2026-09-07-c1080-admission-pilot.md`.

## 2026-09-07 — C1081 complete

Language inventory, finite executable semantics, portable reduction documents and native/WASM
conformance committed in core `55c5d8c`. All native and browser gates passed, including 12 shared
reduction cases and 3 Worker rejection cases. Contract distinguishes restriction from quotient
and declared origins from evidence. Report: `../2026-09-07-c1081-language-semantics.md`.

## 2026-09-07 — C1082 complete

Scalar operation specification, independent checked-integer reference and DAG-lowering
conformance committed as core `ac6b3ad`. All native gates passed. Cold compiler field-schema
validation prevents u16 truncation and ambiguous names; evaluator and layouts unchanged.
Report: `../2026-09-07-c1082-scalar-semantics.md`.

## 2026-09-07 — C1083 complete

Portable campaign transitions and checked command-log replay committed as core `6269cd1`.
Ten independent model sequences, seven adversarial tests and full native/Python/WASM regressions
passed. Native hot loops/layouts unchanged. Report:
`../2026-09-07-c1083-campaign-transitions.md`.

## 2026-09-07 — C1084 portable control architecture

Completed planning-only source audit and architecture in `../2026-09-07-c1084-portable-control-architecture.md` at core `6269cd1`. Two Terra reviews. User-directed browser/local+remote session model, notebook/kernel analogy, deep module boundaries, staged crate layout, durable repository contracts, private native/WASM/IR extensions and performance gates. Advance portable language extraction and shared runtime facade before autonomous-driver host wiring. No runtime changes or new platform support claims.

### C1084 follow-up — history independent of live processes

Extended the architecture with one daemon per workspace, durable campaign/run/artifact identities, offline history viewing, distinct attach/verify/replay/resume/fork operations, activation fencing and crash reconciliation. Existing Campaign Resume remains a gate operation; historical activation and mid-solve continuation are explicitly different capabilities. Documentation only; implementation order and performance gates unchanged.

## 2026-09-07 — C1085 portable scalar language

Core `57af8b4` extracts scalar/text semantics and a bounded stream decoder from native control;
compatibility reexports remain. Exact native64/wasm32 CompiledPredicate size+alignment guards,
default scalar conformance and full native/Python/browser regression gates pass. Public glossary
now owns domain terminology. C1084 expanded with metadata/annotations, forkable run history and
separate orchestration bounded context. Report: `../2026-09-07-c1085-portable-scalar-language.md`.
Next: portable runtime/workflow ownership and shared client contract, without control dependencies
in solvers or kernels. Metadata persistence remains planned, not claimed as implemented.

## 2026-09-07 — C1086 independent verification

Core `08221f2` moves bounded GF(2) restriction checking into solver-independent `ergodis-verify`.
Core admission consumes opaque scoped tokens; mode and provenance stay outside verification.
Problem/candidate identities remain stable; old checker receipts require fresh checking. Workspace,
standalone verifier, independent Python and WASM/browser gates pass; native profiles and hot
layouts remain unchanged. C1084 plan and public glossary now distinguish verification ownership.
Report: `../2026-09-07-c1086-independent-verification.md`. Next: portable runtime/workflow
extraction and bounded client/session contract. No incidental discovery entry.

## 2026-09-07 — C1087 portable campaign runtime

Core `75c1021` moves finite Campaign workflow/tests into `ergodis-runtime`, with a narrow cold
core compile boundary and no reverse dependency. The bounded synchronous SessionService adds
coordinated request IDs, generation/revision checks, retained-response retries and explicit resync.
Native/Python and actual WASM/Chromium campaign corpus gates pass. Thin CampaignSession binding
exists; Worker control UI, legacy native/Python adapters and durable repositories remain future work.
Report: `../2026-09-07-c1087-portable-campaign-runtime.md`. Next: interactive Worker/client demo,
then durable run records, annotations and fork history. No hot-loop/layout change or speed claim.

## 2026-09-07 — C1088 browser campaign control

Core `ea1f563` adds campaign.html with a dedicated WASM Worker and bounded single-flight client.
Real Chromium UI tests cover checked/heuristic workflows, cancellation gates, accepted provenance,
opaque checkpoint export/import and failed-import preservation. Native/Python gates pass; WASM
binary hash is unchanged. No in-flight cancellation, durable repository or module loader claim.
Report: `../2026-09-07-c1088-browser-campaign-control.md`. Next: durable run/artifact records,
metadata, annotations and portable repository/history contract, then storage adapters.
