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
| Core checker/fact-count documentation | Committed `61116a3` | Main reviewed all four documentation diffs; fmt, Clippy and 85/85 test groups passed; manifest regenerated |
| Private documentation and byte-preserving cleanup | Pending | Same canonical bytes, fingerprints and parity digest; layout assertions; required A/B/profile and differential |
| Stage sequencing | Pending | Reject stale/failed/unadmitted stages, recover safely, no allocation; matched stage A/B |
| Parity v2 and additive bench policy | Pending | Updated producer/consumers, new digest, native/WASM agreement, driver parity A/B |

## Decisions and limits

The cleanup Fermi is zero change in retired instructions/work/bytes: the literal retains
the same 32-byte stride and two u32 positions, each initializer assigns the same values,
and the canonical writer emits the former word zero for aggregates. The named chain
buffer remains 64 entries. ThinLTO can nevertheless change generated code; profiles and
matched A/B, including a separate cache-event run, are required before accepting that claim.

Main-agent review caught and corrected two proposed-documentation issues before acceptance:
`count` accepts arbitrary values, unlike the integer-only `min`/`max`/`sum`; and
construction record checking is replay through shared builder machinery, not an independent
implementation. The adjacent reference helper's stale "drop the group" description was also
corrected to whole-program refusal. No behavior was changed for these corrections.

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

## Core documentation validation

Core `61116a3` changes comments only in contract derivation, verify derivation/ranked and
rules demand, plus regenerated SHA256SUMS. Public check methods retain the source identity
requirement and explicitly name shared trust. The prepared fact count now names
`Admitted::facts.len()`; wire count includes duplicate and absent source entries.

Commands under the pinned core Nix shell, with `choom -n 1000` and twelve build jobs:
`cargo fmt --check`; `cargo clippy --all-targets --all-features -- -D warnings`;
`cargo test --all-features`; `python3 python/generate_evidence.py --write`.
All reported exit zero; 85 test-result groups, 1,037 tests passed, zero failed, three ignored.
The core Python-parity tests compare committed Python-origin fixtures; no live Python
process was claimed. Private Rel reference/differential coverage is a separate pending gate.
Counts were summed from the saved post-revision log without another suite rerun.
One redundant suite rerun occurred in the implementation subagent; it contributes no
additional acceptance evidence. No core hot-loop/performance change is claimed.

Read-only recomputation uses the package's complete identity preimage: domain and declared
source bytes, plus the verifier's rule ID and little-endian rule version prefix. Main
review caught an initial calculation that omitted that prefix; the corrected values below
use `ergodis/necessary-coordinate` and version 1 as a little-endian u32. Source identities/canonical program
bytes are separate from these implementation identities:

| Package | Before `61116a3` | After `61116a3` |
|---|---|---|
| contract | `b383135c5563a039650a3d911306ebf0ed8a29876e72ccb3fe1895e2b01163e4` | `dae904ed8764ec9a61d36a226677b2bcd33011f0503ed6fe894c88a12e6d7d49` |
| verify | `381ac03f7575081a05fcb02dfa80dec9282052101f4b1b7394365e5c613cc839` | `efa1074500b1bb7436245d04e921fda1ddb16f72b265336d2a154b76f905924a` |

The main agent independently reproduced all four corrected values with shell concatenation
of the identity preimages through `git show` and `sha256sum`, separately checking the rule
constants at both revisions. No compiled probe or rebuild was needed.
