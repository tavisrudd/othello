# C1085 — Portable scalar language and bounded codecs

Date: 2026-09-07. Lane: ergodis. Status: in progress.
Baseline core: `6269cd1`. Implements stage 1 of C1084.

## Scope

Extract the scalar/text language and feature-batch codecs into default-feature core ownership;
retain native control compatibility and keep hot evaluators/layouts unchanged. Validate shared
semantics on native and WASM builds. Establish the domain glossary and persisted run-record metadata
contract requested alongside execution. Runtime/session hosting and actual record persistence are
subsequent slices, not claimed here.

## Ownership

Terra source agent: src/** extraction. Terra test agent: tests/** portable and codec coverage.
Parent: architecture metadata amendment, public language/glossary documentation, review and task
lifecycle. Luna: validation after source review; one build owner. Existing python/__pycache__ is
untracked generated state, not part of this task.

## Naming and persisted record design

C1084 now specifies campaign/run records and immutable artifacts with implementation/system
metadata, independent theorem/parameter provenance, attempt accounting and versioned user notes.
The public glossary (`docs/glossary.md`) supplies bounded contexts, command/event/type naming and
user-facing vocabulary. Metadata capture remains planned for repository stage; this extraction
does not claim to persist it. User explicitly authorized highest-value execution and reinforced
DDD, domain-user terminology, crate boundaries and unchanged performance discipline.

## Implementation and review

- Default `scalar` module owns typed plan/expression/text parsing and compilation, FeatureDag
  lowering and FeatureBatch evaluation. Native `control` retains reexports; `ControlError` aliases
  portable `ScalarError`. Protocol/schema strings and logical hashing are unchanged.
- `FeatureBatch::read_jsonl_from(reader, FeatureBatchReadLimits)` explicitly bounds rows, cells,
  raw total bytes and raw line bytes including delimiters, before decoding/appending. Header cell
  multiplication is checked. Native path wrapper preserves prior row/cell-only limit behavior;
  new untrusted integrations must choose finite explicit byte caps.
- Parent requested the explicit byte limits after initial extraction retained only the legacy
  row/cell checks. Parent also required portable error naming and legacy CRLF/EOF behavior.
- Source comparison from PlanSpec through the evaluator/math/hash suffix is identical after
  normalizing only ControlError→ScalarError and parent-private→crate-private visibility. No
  evaluator algorithm, hot record layout or hot-loop instrumentation changed. This is not a
  performance speedup claim or a hardware A/B measurement.
- Semantic integration tests now import scalar without control-plane. A feature-gated test
  exercises actual lowering/evaluation through the legacy control reexports. Stream tests cover
  roundtrip/evaluation, malformed data, bounds, checked dimensions, I/O and line endings.
- Glossary explicitly separates orchestration, mathematical engine, verification and repository
  contexts and uses domain-user vocabulary. Git-inspired run snapshots/branches/forks retain
  typed provenance and do not imply automatic merge or inherited admission. The architecture
  now routes campaign workflow ownership to the portable runtime in stage 2; this stage does
  not add runtime context to solver inputs or kernel records.

## Validation

Luna owns the single sequential build window. Required native/default/Python/WASM/browser gates
are in progress; completion evidence will be recorded before closing this task.

## Current limitations

The browser exports remain composition/reduction only; compiling scalar code for wasm32 is not
browser execution coverage for scalar plans. Native path compatibility intentionally retains
legacy row/cell-only limits. Serialized FeatureBatch header dimensions still use the existing
schema; this task does not introduce a new wire version. Generic runtime metadata collection,
run persistence, history DAG/fork APIs, notebook/Python modernization and moving the bounded
campaign workflow into the orchestration crate are planned successors, not delivered functions.
