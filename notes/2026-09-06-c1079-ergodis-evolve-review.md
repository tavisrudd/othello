# C1079 — ergodis-evolve evidence collection and reconciliation

**Lane**: `ergodis`
**Date**: 2026-09-06
**Status**: evidence-collection pass complete; full review and convergence plan remain open.

## Main finding

The existing work contains much of the intended vocabulary and several substantial mechanisms.
The immediate synthesis problem is integration and precise contracts, not inventing autonomy from
scratch. C985 already describes autonomous built-in proposers, external proposers, feedback,
role-specific admission, source-bound artifacts, and compiled consumers. Current core has a
daemon-owned evolution worker and newer generic proof-status machinery; private/C1016 contributes
registered proof replay, concrete reductions, and admission/control experiments. The collected
evidence does not establish a single integrated autonomous theorem/parameter-to-quotient system.

This is a read-only collection by three user-requested Terra sub-agents, reconciled by the parent.
No builds, tests, benchmarks, new literature retrieval, source edits, or architecture migration
were performed. Historical measurements remain attributed report claims. Absence findings are
bounded to inspected surfaces and are not proofs of repository-wide absence.

## Evidence map

| Collection | Snapshot/scope | Detailed record |
|---|---|---|
| Core implementation and documentation | Core `6cc96680c0c3251d094afb9b7b09bf6d1cfc8ce4`; inspected paths reported clean | `2026-09-06-c1079-core-inventory.md` |
| Private/C1016 implementation and campaign documentation | Private `74b7ca9243b1`; inspected paths reported clean; socket behavior here is documentation-derived | `2026-09-06-c1079-private-inventory.md` |
| Prior research, especially C985 | Dated research reports with source/line pointers; historical proposals distinguished from current source | `2026-09-06-c1079-research-inventory.md` |
| Promotion survey and existing benchmark gates | September 2 survey/roadmap and bounded task-row queries | `2026-09-06-c1079-roadmap-inventory.md` |

The source anchor for autonomy is
`2026-09-01-c985-evolve-proposal-admission-architecture.md:98–101,232`; its admission pipeline
is at lines 9–32. The current product requirements remain the user-approved
`2026-09-06-c1079-ergodis-evolve-brief.md`.

## Reconciled findings

1. **Fixed-corpus evolution describes an implemented arm, not the ultimate product boundary.**
   Current core evolves bounded plans over frozen feature batches; its daemon worker lives at
   `ergodis/src/control/mod.rs:1404–1745`. Older C985 reports saying daemon-owned evolution is
   future work must be dated rather than repeated as current absence. Broader autonomous intent
   already appears in the C985 architecture. The user’s clarification governs any remaining
   ambiguity about scope.
2. **Search mode, origin, and validation are not uniformly separated.** Core has partial
   candidate ancestry (`ergodis/src/control/evolution.rs:91–110`) and independent-check statuses
   (`ergodis/src/semantic_theorems.rs:24–35`). Private `ProvenanceClass` mixes origin-like and
   validation-like labels (`ergodis-private/src/proof_synthesis.rs:291–310`). This is a concrete
   terminology/data-model mismatch with the user’s three independent dimensions; it is not by
   itself a demonstrated unsoundness bug. Per-proposal role is also not a run-wide mode.
3. **Proof plumbing exists but is not an integrated evolve admission path.** Core
   `ClaimStatus`/`ClaimLedger`, provenance DAGs, and private registered-extractor transcripts are
   useful evidence. A status enum does not contradict the C985 rejection of an unqualified
   `verified=true` admission bit: proof scope, role, parameters, and application obligations still
   matter. The collected core inspection found no evolution-to-ClaimLedger bridge.
4. **Unix-socket steering and bounded feedback are substantial existing foundations.** Core
   dispatches evolution/profile/proposal operations and protects search workers from control I/O.
   Private campaign docs describe epoch-bound safe-point activation. Their presence does not
   establish durable autonomous campaign recovery or theorem/parameter lifecycle integration.
5. **Quotient quality has several existing objectives but no demonstrated common end-to-end
   selection loop in this collection.** Existing pieces include frozen-corpus correctness/cost,
   private quotient controls, operational probation, and the promotion survey’s downstream-aware
   Pareto frontier. C1040/C1041/C1045/C1046 are existing benchmark successors; avoid allocating
   duplicates or presenting their queued capabilities as completed.

## Ownership direction added after collection

Tavis clarified that reusable evolve machinery, abstractions, and workflows belong in core,
while selected heuristics and theorems may remain private trade secrets. The inventories describe
current locations and older promotion rules; those locations are not the target architecture.
Reassess reusable private proof/evolve/control components for core ownership, with optional
private knowledge implementations consuming domain-neutral core contracts. Confidentiality is
independent of mode/provenance/validation. No source move or public disclosure was performed.
The brief records this direction for the forthcoming convergence plan.

## Next synthesis work

Use these inventories to construct a concrete cross-repository capability/admission map, then
recommend the staged convergence plan requested in the brief. Prioritize:

- mapping existing candidate ancestry, parameter bindings, scope and evidence into the independent
  dimensions without discarding working machinery;
- identifying the actual seams among proposers, counterexamples, theorem/parameter validation,
  compiled quotients, measured solve feedback, persistence, and socket control;
- checking end-to-end examples and the exact limits of existing tests before labelling any missing
  integration a correctness defect;
- making retain/adapt/retire recommendations and evaluating unresolved architecture choices before
  requesting a decision or starting implementation.

The collection pass has not selected a new architecture or completed C1079. No incidental
mathematical discovery arose; no discovery-track entry is warranted.
