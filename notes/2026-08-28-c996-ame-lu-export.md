# C996 — Export repaired 34-page AME-LU paper

**Lane:** `ame-lu`
**Status:** in progress
**Scope:** one-way export of committed Paper I authority to its existing
standalone repository; update summary mirror only if authority is stale; no
push, tag, deposit, upload, or submission

## Objective

Export the C993--C995 compressed and cold-refereed 34-page version of
*Robust Local-Unitary Rigidity of Stabilizer AME States* from immutable
monorepo authority to `/home/tavis/src/math-papers/ame-lu`, verify exact
content and the full standalone release gate, and leave downstream worktrees
clean.

## Gates

1. Authority and standalone worktrees are audited before synchronization.
2. Export is one-way and history-preserving through the repository exporter.
3. Standalone content matches the committed authority export exactly.
4. `make release-check` passes in the standalone checkout.
5. No remote, deposit, tag, upload, or submission action.
