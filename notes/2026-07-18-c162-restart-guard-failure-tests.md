# C162 — restart-guard failure tests, and two ways the guard could have passed wrongly

**Lane**: `build-sys`
**Date**: 2026-07-18
**Status**: hermetic failure suite landed and green; the real checkpoint→restart→audit→verify cycle
remains open and needs a quiet Lean window.

C162 stream 3 asked for "complete hermetic failure tests and a lightweight real
checkpoint→restart→audit→verify cycle" for `lean/scripts/lean-restart-guard.py`. The hermetic half
is delivered. Writing it exposed two paths on which the guard reported success without checking what
it claimed to check; both are fixed here.

## Why the failure modes are the specification

The guard exists to answer one question before a large build is restarted: are the sentinels I
validated still current and byte-identical? A restart decision is made on that answer, and the
expensive mistake is not a false alarm — it is a pass that should have been a refusal, because the
resumed build then proceeds on artifacts nobody actually checked. So the suite is organized around
refusals: a flipped byte, a deleted artifact, an artifact map that does not cover what was
checkpointed, a checkpoint recorded against a different Lean root, an escape out of the build
library, and a resumed log that rebuilt a sentinel must each exit 2 with a diagnostic.

The suite is fully hermetic. It redirects `LEAN_ROOT` and `BUILD_LIB` at a throwaway tree and stubs
both subprocess boundaries (`pgrep`, `lake build --no-build`), so it reads no real Lean tree, stats
no real build output, and never builds. It runs in well under a second.

## The two defects the tests exposed

**A checkpoint could verify vacuously.** `verify_data` accepted any `dict` as a sentinel's artifact
map, including an empty one. A checkpoint whose artifact map had been emptied — by truncation or a
hand edit — passed verification and printed `verified 1 current, byte-identical sentinels` while
hashing nothing at all. The same hole applied per-entry: deleting just the `.trace` entry silently
narrowed verification to the remaining three artifacts. Verification now refuses an empty map and
refuses a sentinel that does not record all of `REQUIRED_SUFFIXES`, so a checkpoint cannot quietly
verify less than it was created with.

**`audit-log` parsed checkpoints without validation.** It read `data["sentinels"]` behind a bare
`assert isinstance(..., list)` and then indexed `item["module"]` on every dict. A sentinel entry
lacking a `module` key raised `KeyError` — an unhandled traceback rather than the exit-2 diagnostic
every other path produces — and the bare `assert` is stripped under `python3 -O`, leaving a
non-list `sentinels` field to fail as an ordinary iteration error. Both commands now go through one
`sentinel_modules` validator, so no command trusts a checkpoint shape another one rejects.

Neither defect can be triggered by a checkpoint the tool itself wrote. Both are reachable from a
truncated, partially written, or hand-edited checkpoint file, which is exactly the state a restart
after an interruption is likely to encounter.

## What the suite pins

Beyond the two regressions, the cases worth naming are the ones where a plausible implementation
differs from the correct one:

- **Every artifact kind is hashed.** A guard that hashed only the `.olean` would pass three of the
  four tamper cases; each suffix is tampered with independently.
- **Ambiguity in the live-Lake interlock refuses.** `pgrep` exit 0 refuses and exit 1 permits, but
  exit ≥2 and a missing `pgrep` also refuse — a failed probe is not evidence that Lake is stopped.
- **A refused checkpoint leaves nothing behind.** The currency probe runs before any directory is
  created, so a stale sentinel cannot leave a checkpoint directory that a later `verify` would read.
- **Module names cannot address the host.** Traversal and shell-metacharacter names are refused
  before reaching `joinpath`.
- **Escapes are resolved, not just spelled.** Both a `../`-relative artifact path and a symlink
  planted inside the build library that points outside it are refused.
- **The rebuild marker is anchored.** `Built Demo.Mod` must not match inside `Built Demo.Modular`;
  a substring match would report a rebuild that never happened and block a valid restart.
- **`audit-log` needs no stopped Lake.** Reading a log mutates nothing, so it stays usable while a
  build runs — the one command that deliberately does not take the interlock.

## What this establishes and what it does not

It establishes that the guard's refusal paths behave as specified against fabricated tree and
checkpoint states, and that the two defects above are closed.

It does **not** establish that the guard works against real Lake output. Every test stubs
`lake build --no-build`, so the suite says nothing about Lake's actual exit codes, its trace
semantics, or what a real interrupted build leaves on disk. The `Built <module>` marker is asserted
against the format as written in the tool, not against captured Lake output. Closing stream 3 needs
the lightweight real cycle on disposable state in a confirmed quiet window; the tests are a
precondition for trusting that run's result, not a substitute for it.

## Replay

Working directory `/home/tavis/src/othello/lean`:

```text
python3 scripts/test_lean_restart_guard.py     # 48 hermetic tests, no Lean tree, no build
```

## Artifacts

| Path | SHA-256 | Bytes |
|---|---|---|
| `lean/scripts/lean-restart-guard.py` | `cf8b7c67ede832c6469c2f1764b4475ccc238603b732489ed1c813c74f979ad7` | 9466 |
| `lean/scripts/test_lean_restart_guard.py` | `0287df3d1275269817987216b57d3d6dea2a3e5af89fb93c7611cf011ef78f9a` | 21033 |

## Cross-checks

The load-bearing computation is hash comparison over the four artifact kinds, so it is checked by
mutation rather than by asserting the tool's own output: each artifact is tampered with in turn and
restored, and the suite asserts both that every single-byte change is caught and that the restored
tree verifies again.

The independent check is that the suite discriminates: it was run against the pre-fix guard, taken
from commit `29b55d38`, in a throwaway directory that leaves the worktree untouched.
Against that version exactly the three regression tests fail — `test_an_emptied_artifact_map_
cannot_verify_vacuously`, `test_a_dropped_artifact_entry_cannot_verify_vacuously`, and
`test_malformed_checkpoint_is_refused_not_crashed` (one `KeyError` and three refusal subtests) —
and the other tests pass. So the suite is not merely restating the new implementation: it fails on
the defective code and passes on the corrected code, and the tests that are not about the fix are
unaffected by it.

```text
cd "$(mktemp -d)" && git -C /home/tavis/src/othello show \
  29b55d38:lean/scripts/lean-restart-guard.py > lean-restart-guard.py &&
cp /home/tavis/src/othello/lean/scripts/test_lean_restart_guard.py . &&
python3 test_lean_restart_guard.py     # expect FAILED (failures=5, errors=1)
```
