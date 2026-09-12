# Paper I release continuation

**Date:** 2026-09-12 · **Owners:** C855 release repair; C943 final mirror

## Verified corrections to the previous diagnosis

The current finitegeom revision `f7b974379b91cff98b6399312bf2030d9c2d6f1e`
has zero mismatches in `TARGET_MANIFEST.json`. The handoff's four-path reseal
blocker was stale. All 96 project modules in the import closure of
`RelativeConicArcs.Gates.ClebschRigidityTrust` are byte-identical to the
previous paper pin `b871c10b4a91200a0913644d39b9f0ce44f655ca`.

The fresh guarded run is
`/home/tavis/.cache/othello-lean-build/run-20260912-204719-eee6128e`.
Its clean-current source identity and aggregate gate pass; the trace-current
replay supplies 161 axiom reports. It completed in about forty seconds without
rebuilding the Q11 certificate. A missing old receipt did not imply a cold build.

The bridge was re-pinned in the authority registry, then exported by
`lean/scripts/lean-paper-bridge-export.py` from `e2e8cf03b` as the ordinary
forward commit `b525f04b52c44a0315ac80f569761d133b8b48a2`. The certificate pin,
pack digest, and Lean source are unchanged. The paper now names both current
formal roots.

## Verification runner repair

The aggregate runner previously invoked the bridge's Nix verification app
without the host build-owner guard. The optional `--lean-build-queue` argument
now routes the same contract, explicit roots, and exact sealed pack through the
existing guarded `verify` entry point. Public standalone verification retains
its existing contract. No evidence check was removed or relaxed.

The verification tests pass (29 tests), including the guarded command routing.
An obsolete test expected a thirteen-page companion; its existing deterministic
checker and actual PDF require fourteen. Both PDFs rebuild with zero warnings
at 29 and 14 pages, with no PDF byte changes.

## Release and mirror

The first aggregate replay passed its first 26 checks, including all exact
computational replays and the human-gate axiom audit. The final bridge check
failed because its ignored `lake-manifest.json` still pinned finitegeom at
`b871c10`. Lake attempted to replace the source symlink while refreshing that
stale lock and refused. This is local dependency-lock drift, not a failed Lean
proof. The old symlink was unlinked without touching its target, and the
existing guarded `update-lock finitegeom` entry point refreshes the lock.
The bridge is retried separately before another aggregate replay.

## Mystery ledger / ej + tt

The cheap closeout lesson is to validate blockers against executable current
state: both the supposed base drift and the assumption that a lost receipt
requires a cold build were false here. No new mathematical mystery arose.
C855's broader theorem-completeness and scholarly-closure audit remains open;
this maintenance release does not claim that every manuscript assertion is
formalized. C943 has no mathematical or terminology question left open.

## Command hygiene

The first combined context read exceeded the workspace's output bound and was
truncated. It was replaced by bounded reads of the required documents. One test
edit used a repository-relative path from the paper directory and failed before
writing; it was corrected with the proper root and all tests passed.

## Recovery and prevention

The failed Lake dependency materialization had followed the finitegeom symlink
and recursively emptied its target, including `.git` and build artifacts,
before refusing to replace the symlink. This was a destructive side effect of
the existing exported verifier, triggered by this continuation's replay.

Recovery copied the complete finitegeom checkout from the read-only filesystem
snapshot `/home/.zfs/snapshot/2026-09-02--21-30/tavis/src/lean/finitegeom/`.
That snapshot has exactly the current `f7b9743` head and includes its build
artifacts. The restored tracked tree is clean. The certificate repository and
its sealed artifacts survived unchanged. A fresh guarded revalidation uses
`run-20260912-210207-525e11fd`.

The bridge exporter now validates both direct dependency revisions and every
Git dependency symlink against the lock before installing source links or
invoking Lake. A stale lock fails without touching the source; a regression
test verifies preservation of a sentinel behind the symlink. Exporter and
audit suites pass (14 and 8 tests). The repaired bridge is `d557f99a`, exported
from authority `4c55fd9a6`; the final paper pin names that revision.
