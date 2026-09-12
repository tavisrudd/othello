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

The post-recovery human gate passes trace-current. The next isolated bridge
attempt safely reached Lean, then exposed a namespace search-path collision:
finitegeom now has its own `TavisRuddFiniteGeom` artifact directory, which hid
the certificate package's `TavisRuddFiniteGeom.Certificates.Q11.PointOrbits`
artifact. Its sealed file was present. The exported verifier now prepends the
certificate artifact root to Lake's existing Lean search path and executes the
same Lean compatibility module. No source, theorem, or certificate changes.
The final bridge pin is `b9d0cb5445241726c242777eec366a5842ed4222`, exported
from `5cbe69b57`. The paper's sealed-contract check and regression fixture
follow the exact new invocation; all 29 paper tests pass.

Reordering alone was insufficient because the certificate cache also retains
an obsolete `RelativeConicArcs` directory. The final implementation composes a
temporary import directory of symlinks to only the artifacts owned by the two
sealed source manifests. This merges shared namespaces module by module,
rejects duplicate ownership, preserves both caches, and cleans up after Lean
exits. The regression fixture places mutually shadowing stale artifacts in
both packages and checks correct module selection and cache preservation.
The final bridge is `6f0b927b0546f3256a0d60c4318810d479864530`, exported
from `ab749fc00`; exporter/audit/paper tests pass (15 / 8 / 29).

One export attempt correctly refused because its newly adopted bridge pin was
not committed in the registry. The shell then accidentally retried the old
verifier, reproducing the same harmless namespace error. The registry was
committed before the subsequent successful export; dependent command batches
now stop on the first error. A regeneration command also used the repository
root instead of the paper root and failed without writing; it was corrected.

The repaired bridge passes its guarded verification at
`verify-20260912-211222-793d2a56` (about three minutes). The temporary artifact
view resolves both package namespaces and Lean elaborates the unchanged
`TavisRuddFiniteGeom.Papers.ClebschRigidity.CertificateCompatibility` module.
The source snapshot is recovered and the frozen certificate was never rebuilt.

The shared export conventions now require the lock preflight for explicit
local-source replay and explain how to detach a stale dependency symlink before
a guarded lock update. Existing exports of other bridges are not silently
changed; they must adopt the hardened template before that replay mode.

Recovery scope: the snapshot restores the exact current committed source tree
and its September 2 artifact cache. The new Paper I receipt proves its complete
human closure is trace-current. This does not claim that every ignored cache
entry produced after September 2 elsewhere in finitegeom was recovered.
