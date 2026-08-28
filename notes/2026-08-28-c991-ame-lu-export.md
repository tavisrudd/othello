# C991 — AME-LU standalone and summary export

**Lane:** `ame-lu`
**Status:** in progress
**Scope:** export committed Paper I authority and any required portfolio-summary update; no push, deposit, or submission

## Objective

Synchronize the 37-page C990 revision of *Robust Local-Unitary Rigidity of
Stabilizer AME States* from the committed monorepo authority to its existing
standalone repository, verify the exported tree and paper release gate, and
refresh the public portfolio summary if its Paper I description or PDF is
stale.

## Gates

1. Authority plan and repository audit pass from immutable `HEAD`.
2. Standalone mirror is clean before synchronization and receives only an
   ordinary forward commit.
3. Mirror verification and the paper-local release gate pass.
4. Summary authority is updated first if needed, then copied one-way to its
   clean mirror and committed there.
5. No remote push, deposit, tag, upload, or submission.

