# C879 — finitegeom paper-boundary extraction plan and red-team

**Lane:** `build-sys` · **Date:** 2026-08-06 · **Status:** planned

## Objective

Progressively separate the shared `finitegeom` Lean repository into reviewer-friendly
paper packages without breaking shared mathematics, trust boundaries, certificate
provenance, or the current monorepo authority.

## Proposed architecture

Use explicit paper and shared source roots:

```text
finitegeom/
  Shared/
    Projective/  FiniteFields/  Coding/  Incidence/  Certificates/
  Papers/
    arcs/  prs/  ame-lu/  clebsch-rigidity/  clebsch-passages/
    q13-passant-code/  mds-css-transversal/
    complete-repair-ports/  equivariant-robust-completion/
```

Namespaces should mirror the boundaries, for example `FiniteGeom.Projective.*` and
`Paper.PRS.*`. The import direction is one-way: papers may import shared APIs;
shared APIs may not import papers. A genuine cross-paper result, such as the PRS
balanced quantum extension consuming AME--LU results, must use an explicit adapter
and declared paper dependency.

Each paper should own a small manifest declaring its roots, source closure, shared
dependencies, generated inputs, certificate packages, axiom expectations, and exact
replay command. The central trust portfolio should be generated from these manifests,
not serve as the primary ownership map.

## Staged execution

1. Inventory the current import and reverse-import graph and classify every module as
   paper-specific, shared, generated, certificate-owned, or legacy.
2. Create `Papers/<alias>` directories in the monorepo while retaining one Lake
   project; update imports and namespaces in bounded closures.
3. Extract repeated mathematical foundations into named shared libraries. Reject a
   shared module without a mathematical subject, owner, public API, and multiple
   genuine consumers.
4. Add import-firewall checks: shared code cannot import papers, paper internals
   cannot be imported by another paper, and adapters are explicit.
5. Extract leaf-paper-specific modules first, retaining shared libraries centrally.
6. Freeze upstream APIs for arcs and AME--LU, which currently supply foundations to
   several developments.
7. Split the shared libraries and paper-specific source into separately pinned Lake
   packages only after each paper has an independent clean replay.

## Red-team findings and mitigations

- A generic `Shared` directory could become a new dumping ground. Require subject-
  specific namespaces and multiple consumers.
- Import graphs alone miss declarations reached through `open`, re-exports, and
  generated sources. Audit declaration-level use before relocation.
- Namespace moves can break generators, certificates, and source seals. Move one
  closure at a time and require complete regeneration and byte-identity checks.
- Cross-paper dependencies can hide inside shared modules. Shared code must contain
  no paper-specific results; use explicit adapters for cross-paper theorems.
- Repository extraction can accidentally change the authority. Keep the monorepo
  authoritative until the extracted package has passed an independent replay, then
  synchronize forward.
- Many small packages can harm reviewer usability. Split at mathematical/API
  boundaries, not at manuscript-section boundaries.
- Per-paper manifests can reproduce the complexity of the global trust registry.
  Limit them to roots, closure, shared pins, generated inputs, axioms, and replay.
- Existing `.olean` files can mask missing source after extraction. Validate from a
  clean checkout and distinguish source elaboration from stale-artifact success.

## First acceptance gate

Before moving source, commit an ownership/import manifest and generated reverse-
dependency report. The report must identify the exact shared modules that remain
required by each paper and the exact paper-specific modules safe to extract. No source
deletion or repository split is authorized by this plan alone.

## Scope boundary

This is a design and sequencing record. It does not authorize builds, certificate
regeneration, mirror writes, repository extraction, deletion, or changes to package
boundaries.
