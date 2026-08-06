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

The first physical split must not also rename namespaces. Initially preserve existing
module names behind package-specific source roots, for example:

```text
Papers/PRS/RelativeConicArcs/PRSFoundation.lean
Papers/Arcs/RelativeConicArcs/...
Shared/RelativeConicArcs/...
```

The `Paper.*` and `FiniteGeom.*` namespace cleanup is a later, package-local change.
This prevents a directory move from becoming an immediate repository-wide import
rewrite and rebuild.

Each paper should own a small manifest declaring its roots, source closure, shared
dependencies, generated inputs, certificate packages, axiom expectations, and exact
replay command. The central trust portfolio should be generated from these manifests,
not serve as the primary ownership map.

## Staged execution and bounded validation

1. Freeze the current finitegeom commit, paper roots, source closures, reverse
   closures, certificate pins, and axiom facts. Refuse the operation if foreign Lean
   work or dirty certificate artifacts are present.
2. Generate the ownership graph without running Lean. Classify every module as
   paper-specific, shared, generated, certificate-owned, compatibility shim, or
   legacy. Record exact shared modules and extractable modules per paper.
3. Add per-paper manifests and a read-only import-firewall checker while leaving all
   Lean source in place. Reject shared-to-paper imports, undeclared paper-to-paper
   imports, undeclared generated inputs, and roots outside the manifest closure.
4. Create paper directories and package-specific source roots while retaining the
   existing module names and one Lake project. Do not combine this step with a
   namespace rewrite.
5. Extract one small human-scale leaf as a pilot, preferably
   `complete-repair-ports`, rather than arcs, AME--LU, PRS, or a certificate-heavy
   closure. Retain shared modules centrally and use temporary compatibility shims
   where necessary.
6. Validate the pilot from a clean package-local source tree: build only its gate and
   audit through the guarded build queue, run its checker, compare declarations and
   axioms, and run the source/manifest audits. Do not run a repository-wide build.
7. For every later change, compute the exact reverse-import closure before building.
   A paper-private move rebuilds only that paper; a shared API change rebuilds every
   affected paper gate; manifest-only changes require no Lean build.
8. Extract the remaining leaf papers in dependency order: complete ports,
   equivariant completion, q13 after its certificate package is sealed, MDS/CSS after
   the AME--LU API is frozen, Clebsch passages, then Clebsch rigidity/hexagon code.
   Extract PRS-specific modules after its shared interfaces are stable.
9. Freeze the arcs and AME--LU shared APIs last. They are shared-heavy foundations;
   moving them earlier would repeatedly reopen downstream closures.
10. Only after each monorepo package passes an independent clean replay, split the
    shared libraries and paper source into separately pinned Lake packages. Perform
    namespace cleanup one package at a time after the package boundary is green.

### Build-wait discipline

- Do not run a full-project Lean build for layout, manifest, or graph changes.
- Use exact gate and reverse-closure targets through `lean-build-queue.py`; never
  invoke Lake directly or substitute a portfolio-wide target.
- Keep one heavyweight build at a time and reuse trace-current shared artifacts.
- Use detached guarded queue runs only for genuinely long, already-bounded gates.
- After a failure, inspect the first diagnostic and change the target or source before
  retrying; never repeat an unchanged failed build.
- Keep generated certificates downstream and opt-in; do not pull them into every
  paper build.

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
- A simultaneous path move and namespace rewrite can turn a small leaf extraction
  into a repository-wide rebuild. Preserve module names in the first split and defer
  namespace cleanup.
- A full repository build can hide whether the changed paper closure is actually
  bounded. Require the exact affected-gate list before every validation build.
- Starting with arcs or AME--LU would repeatedly disturb shared foundations. Use a
  small leaf pilot and freeze upstream public APIs before downstream extraction.

## First acceptance gate

Before moving source, commit an ownership/import manifest, generated reverse-
dependency report, and import-firewall checker. The report must identify the exact
shared modules that remain required by each paper, the exact paper-specific modules
safe to extract, and the exact gate targets affected by a change. No source deletion,
namespace rewrite, or repository split is authorized by this plan alone.

## Scope boundary

This is a design and sequencing record. It does not authorize builds, certificate
regeneration, mirror writes, repository extraction, deletion, or changes to package
boundaries.
