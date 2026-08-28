# C991 — AME-LU standalone and summary export

**Lane:** `ame-lu`
**Status:** complete
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

## Result

The first immutable sync from authority commit `6456404ae` correctly exposed
a stale paper release manifest. The standalone manuscript build passed, but
`make release-check` refused until the manifest was refreshed. The manifest
was regenerated and reviewed in the monorepo authority, where the full release
gate then passed, and committed at `91cb66efd` before a second guarded sync.

Final Paper I export:

- standalone: `/home/tavis/src/math-papers/ame-lu`;
- forward commits: `296a835` (manuscript) and `667a2d0` (release identity);
- exporter content SHA-256:
  `f07fe6401fa51854c8f01f849ffa9f82bb4699a9989d14fb9aa093b630b300ec`;
- PDF SHA-256:
  `6be97fa496cf0236b2cf7516a3bddcfbd47e1d29a31e1e4a7cead473dd661247`;
- release public-tree SHA-256:
  `48e8af4f703d7e81691f1618fa42e3a36fa35c863c869b8f33fbb5a525eadd1a`;
- exporter verification: 29 tracked files, exact content match;
- mirror `make release-check`: passed; the 83-artifact formal companion is
  recorded by its pinned tree hash and correctly absent from the paper-only
  checkout.

The portfolio summary was stale in two places: its short result description
and quoted abstract omitted the intrinsic endomorphism algebra and the
four-/six-party nonscalar theorem. The authority summary now matches the paper
at commit `52727e858`; it was copied one-way to the clean summary repository
and committed there as `d1cceee`.

Both downstream repositories are clean. Nothing was pushed, deposited,
tagged, uploaded, or submitted.
