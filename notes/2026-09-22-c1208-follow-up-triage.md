# C1208 — follow-up triage after C1209

**Lane**: `ergodis`
**Date**: 2026-09-22
**Status**: COMPLETE — Tavis approved the remaining recommendations and allocations on
2026-09-22, requesting small, low-risk cleanup first. C1210–C1218 are allocated below.

This is a document-level follow-up, not a fresh code verification or build. Authorities:
`2026-09-21-c1208-c1204-findings-triage-report.md` (full disposition table), its
`2026-09-21-c1208-step2-code-verification.md` ledger (in particular items 3, 6, 7/13, 9,
11/12), and `2026-09-21-c1209-contract-crate-split-report.md` (Identities; Audit and repairs).
The original disposition table remains authoritative except for the updates below.

## What changed

1. The contract split is completed as C1209, including the twelve audit repairs recorded
   in its final report. Do not allocate it again. Producer-facing admission and certificate
   types now belong to `ergodis-contract`; checkers remain in `ergodis-verify`.
2. C1209 records separate contract and checker identities, and its binary-composition
   verification record carries both. The proposed Datalog format task must specify both
   identities' roles. A checker identity alone no longer identifies admission code.
   An identity supplied in a certificate does not establish that verification ran:
   distinguish producer metadata from a verification record emitted after checking.
   Recommend retaining this distinction explicitly in the format task's acceptance criteria.
3. Recommend executing the stage-sequencing repair first, in its own commit, ahead of
   the design memo. The memo remains the highest-value architecture prerequisite for
   C1194, but the verified silent wrong-answer path is a small correctness repair.
   Tavis's subsequent cleanup-first direction refines this: documentation and byte-preserving
   cleanup first, then the sequencing repair as the first behavioral change and its own commit.

## Remaining decisions, using Fable's chat numbering

| Decision | Recommendation |
|---|---|
| 1 — C1194 precursor | Approve the design memo; defer weighted Demand versus a second kernel until the memo supplies the comparison. |
| 2 — domain ceiling | Approve arity-dependent admission before C1195 fixes sizes. Require exact boundary tests for both admission doors and the private dictionary. |
| 3 — join order | Approve core ownership; document the lowering order as a chain-shape hint. |
| 4 — format change | Approve a distinct Datalog schema and explicit contract/checker provenance, accounting for C1209 as above, before C1195 freezes artifacts. |
| 5 — contract split | Completed as C1209; no decision or allocation remains. |
| 6 — instrumentation | Approve the feature boundary as part of the Demand/API task. |
| 7 — record formats | Approve parity v2 for positional counters and additive bench `body_policy`. |
| 8 — repair order | Approve the stage-sequencing repair first and separately committed. |

WASM targeting and an ABI reaching private modules remain decided. The number of Rel
providers remains an ABI design question; the previous interpretation is not approval
of a particular provider decomposition.

## Allocation and acceptance refinements

- Remove the completed split from the allocation list. Tavis approved the nine other
  proposed task scopes; their allocated owners are listed below.
- For the domain task, distinguish domain cardinality from the largest representable
  value. The ledger's u32 domain field does not by itself establish support for all
  2^32 distinct values. Also preserve the valid arity-four endpoint whose tuple count
  is 2^64 although its largest packed key fits u64; a naive checked-power rejection
  would regress it. These are acceptance requirements, not newly verified defects.
- For stage sequencing, test initial/unadmitted use, failed admission, reparse after
  successful admission, and recovery after refusal. Specify invalidation and counter
  wrap behavior; a counter comparison alone is not a complete validity contract.
- The original recommendation was to settle format before C1205 a. During allocation,
  C1205 a was recorded complete and audited (core a92050a/c73ed85); C1213 instead migrates
  that delivered byte interface before C1195 freezes artifacts. Do not redo C1205 a.
- Record the ABI dependency honestly: core needs C1205 milestone a; the private provider
  also needs an explicit module-boundary decision. Scoping that boundary can precede
  the later mechanical Rel crate extraction.

## Operational note

The first handoff read exceeded the output bound and was truncated; a subsequent
batched read also exceeded the aggregate display budget. Both command-shaping failures
were corrected with bounded source ranges. No build, code edit, ID reservation or
architecture approval occurred in the initial follow-up. The later allocation pass below
records Tavis's explicit approval and reserves the nine IDs.

## Approved allocations and execution order

Reservation: C1210–C1218, committed in `5d1c9648a` before any queue row used them.
All cards are `notes/2026-09-22-c<id>-<slug>.md` with the slugs in this table.

| Owner | Original proposal | Card slug | Execution constraint |
|---|---|---|---|
| C1210 | small-repairs bundle | small-repairs | First: documentation/byte-preserving cleanup; sequencing repair separately; record formats last. |
| C1211 | alloc-1 | min-plus-design | Next, a design memo before C1194 implementation; actual evaluator choice remains Tavis's decision. |
| C1212 | alloc-5 | arity-domain-ceiling | Prefer after C1206 establishes refusal payloads; before C1195 sizes cohorts. |
| C1213 | alloc-4 | datalog-schema-provenance | Migrate the completed C1205 a interface before C1195 freezes artifacts; coordinate C1196. |
| C1214 | alloc-2 | checker-tests-independence | C1205 a is complete: tests can follow C1210; independent completeness is a later milestone. |
| C1215 | alloc-3 | demand-api-cleanup | After C1205 a; feature/API changes are not the initial low-risk cleanup. |
| C1216 | alloc-8 | datalog-rel-module-abi | Core after C1205 a/C1213; private boundary scoped first, preferably extracted by C1218. |
| C1217 | alloc-6 | relational-support-proof | After C1211's statement, consistent with checker/construction contracts. |
| C1218 | alloc-7 | rel-crate-boundary | After C1205 c; scope early for the private ABI, extract later. |

Recommended working sequence (priority is not an extra hard dependency):

1. C1210: documentation and byte-preserving cleanup; sequencing fix; record updates.
2. C1214 a: test-only checker mutation suite using the completed C1205 a byte door.
   Then C1211 read-only design memo.
3. C1206 structured refusals, C1212 domain ceiling, C1213 schema/provenance migration,
   C1215 API cleanup, then C1205 b/c evidence chain and one backend. C1214's tests follow
   the deliberate C1213 format changes.
4. C1218 Rel extraction, C1216 complete module ABI, C1214 b independent completeness,
   and C1217 formal support argument. Core ABI work can start earlier after its prerequisites.

C1194 can proceed once Tavis accepts C1211's design; it need not wait for all of step 4.
C1195's Boolean rows need C1212/C1213/C1206; its min-plus rows additionally need C1194.
C1196 needs C1205 a/C1213, and its ABI portability acceptance needs C1216.
C1207's broader diagnostics design remains separately queued. C1205 b's existing choice
between an independent construction rebuild and replay remains open; this allocation
does not silently decide it.

No incidental research observation arose during allocation, so no discovery entry was added.
C1208 is archived and removed from the live queue; next task is C1210.

Concurrent-update note: commit `05fd986b4` recorded C1205 a's completion and included the
already-written C1210–C1218 queue rows/C1208 removal while this allocation was underway.
The archive row had already been written and verified; this closeout commit carries it and
the cards. No history was rewritten to regroup those changes. C1205's committed progress
is preserved; only task-owned dependency notes are changed here.
