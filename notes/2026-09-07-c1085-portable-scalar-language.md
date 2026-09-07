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
