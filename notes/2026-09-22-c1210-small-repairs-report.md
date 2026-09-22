# C1210 — Datalog/Rel small repairs

**Lane**: `ergodis`
**Date**: 2026-09-22
**Status**: IN PROGRESS. No implementation milestone accepted yet.

## Scope and coordination

Tavis requested cleanup first, with the main agent coordinating and reviewing Terra/Sol
subagents. Three commit boundaries: documentation/byte-preserving cleanup (core/private
separately), stage-sequencing repair, and record updates. The task does not implement the
later builder, schema/provenance, domain or ABI work.

Initial core revision: `c73ed85`; initial private revision: `bfd79c9`. Scoped source trees
were clean on entry. A fresh private tools control was retained before any source edit:
`ergodis-tools-bfd79c9`, measured SHA-256
`c0fe7a8fb22a9327da683d0f85481409691befe1436fba6ac2509e948e0e24d2`.
Recipe: the dev `retain-bin.sh` on private `tasks/tools`, binary `ergodis-tools`, default
release profile under the core pinned Nix shell. Core dependency revision was `c73ed85`.
The previous C1209 control predates C1205 a and is not assumed matched to today's tree.

Core documentation and private cleanup have separate owners. The sequencing analysis is
read-only until cleanup lands. Builds share one scheduled slot; all use the pinned toolchain,
shared target directories, at most twelve workers, and the required OOM preference.
The main agent reviews diffs, gates and receipt interpretation before commits are accepted.

## Acceptance ledger

| Milestone | Status | Required evidence |
|---|---|---|
| Core checker/fact-count documentation | Pending | Accurate shared-trust statement; fmt, Clippy, tests, regenerated manifest |
| Private documentation and byte-preserving cleanup | Pending | Same canonical bytes, fingerprints and parity digest; layout assertions; required A/B/profile and differential |
| Stage sequencing | Pending | Reject stale/failed/unadmitted stages, recover safely, no allocation; matched stage A/B |
| Parity v2 and additive bench policy | Pending | Updated producer/consumers, new digest, native/WASM agreement, driver parity A/B |

## Decisions and limits

- A generation check establishes workspace-stage freshness, not the identity of arbitrary
  source bytes supplied by a caller. The remaining source-byte precondition must stay explicit.
- Review selected a smaller implementation than the originally proposed counter: a private
  Empty/Parsed/Admitted state. Scanning invalidates before any error; successful compact parse
  and admission advance state; lowering requires Admitted. There is no numeric wrap. Diagnostic
  recovery stays outside the documented compact-parse admission boundary. Failed lowering
  preserves admission for retry. This is still a plan pending implementation and tests.
- Source implementation hashes may move even on documentation edits. No historical receipt
  is re-pinned as if its measurement had been repeated.
- No cache deletion, publication, unrelated comment sweep or Lean operation is authorized here.

## Closeout

Pending implementation, review and validation. Incidental discoveries, retained artifacts and
any unresolved evidence gaps will be recorded before task closure.
