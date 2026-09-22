# C1208 — follow-up triage after C1209

**Lane**: `ergodis`
**Date**: 2026-09-22
**Status**: recommendations for Tavis; remaining allocations still await his decisions.

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

- Remove the completed split from the allocation list. The nine other proposed task
  scopes remain candidates; allocate only after Tavis answers the pending decision list.
- For the domain task, distinguish domain cardinality from the largest representable
  value. The ledger's u32 domain field does not by itself establish support for all
  2^32 distinct values. Also preserve the valid arity-four endpoint whose tuple count
  is 2^64 although its largest packed key fits u64; a naive checked-power rejection
  would regress it. These are acceptance requirements, not newly verified defects.
- For stage sequencing, test initial/unadmitted use, failed admission, reparse after
  successful admission, and recovery after refusal. Specify invalidation and counter
  wrap behavior; a counter comparison alone is not a complete validity contract.
- Order the format task before finalizing C1205 milestone a's byte format; coordinate
  schema/provenance requirements before either task freezes artifacts. C1209 no
  longer blocks C1205.
- Record the ABI dependency honestly: core needs C1205 milestone a; the private provider
  also needs an explicit module-boundary decision. Scoping that boundary can precede
  the later mechanical Rel crate extraction.

## Operational note

The first handoff read exceeded the output bound and was truncated; a subsequent
batched read also exceeded the aggregate display budget. Both command-shaping failures
were corrected with bounded source ranges. No build, code edit, ID reservation or
architecture approval occurred in this follow-up.
