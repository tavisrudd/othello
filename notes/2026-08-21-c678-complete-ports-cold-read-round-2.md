# C678 complete repair ports — cold read round 2

Date: 2026-08-21

## Protocol

Three isolated readers received only the committed manuscript PDF. They were
instructed not to inspect notes, source files, referee dossiers, Git history,
or earlier reports, and not to edit the worktree.

Initial candidate:

- commit `1f18a22139fd20417e10a2d5e6a3d22bfd80adad`;
- PDF SHA-256
  `e3d5bfda0ca64e6f3d63b183aaec9f915b235cb6d7ed08f3101ca672249a089b`.

Amended candidate:

- commit `f0d6a9d72a2dcc625427779acdb8d957b61e05de`;
- PDF SHA-256
  `a4a458ca6add2df72711f01b2212042918468110c1afe71c18a8a71e12d86261`.

## Initial verdicts

- Matroid, reliability, EXIT, and MDS lens: **GO**.
- Storage, transfer, and reproducibility lens: **MINOR**.
- Finite/projective geometry lens: **MINOR**.

No reader found a false main theorem or a structural failure. The required
minor corrections were:

1. distinguish the designated target class of density exactly `1/m` from the
   possible total density when other inner coordinate types carry isomorphic
   ports;
2. state the strict example's weighted and pointed nonembedded bounds as at
   least six, rather than assert an unattested equality;
3. make the zero-code convention `d({0}) = infinity` explicit in the coarse
   transfer criterion;
4. print the gate-fact hash and identify `verification/` as supplementary
   material distributed with the source archive;
5. derive `Z_3(q) <= q-2` from the `q/3` disjoint zero-sum triples, rather than
   from one zero-sum triple.

## Resolution and amendment review

All five corrections were made in commit
`f0d6a9d72a2dcc625427779acdb8d957b61e05de`. The two affected readers then
re-read only the amended PDF and independently verified its SHA-256.

- Storage/transfer amendment verdict: **GO**.
- Geometry amendment verdict: **GO**.
- No new correctness issue was found.

## Formal and build checks

- Manuscript `make check`: pass, 20 pages, with the warning gate clean.
- Guarded Lean build of `RepairPorts.Gates.CompletePorts`: pass.
- `lean-trust-spine.py audit --area complete_ports`: 0 error, 0 warning,
  0 info.
- Immutable formal-area plan: 36 closure modules, 60 terminals, 885232 closure
  bytes, no finitegeom prose drift.
- Deterministic standalone formal-area materialization: pass.

## Final disposition

**GO FOR EXPORT.** The approved paper artifact is the amended PDF at commit
`f0d6a9d72a2dcc625427779acdb8d957b61e05de`, with SHA-256
`a4a458ca6add2df72711f01b2212042918468110c1afe71c18a8a71e12d86261`.
