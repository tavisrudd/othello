# C879 — finitegeom paper-boundary extraction plan and red-team

**Lane:** `build-sys` · **Date:** 2026-08-06 · **Status:** planned; the AME--LU and MDS--CSS
entries of this plan and of `2026-08-06-c879-module-name-mapping.json` carry open corrections from
`2026-08-06-c879-ame-lu-mds-css-mapping-audit.md`

## Objective

Progressively separate the shared `finitegeom` Lean repository into reviewer-friendly
paper packages without breaking shared mathematics, trust boundaries, certificate
provenance, or the current monorepo authority.

## Starting boundary

C879 starts only after the C864 export-completion plan reaches its endpoint. C864 is
already establishing the useful substrate: tracked area configurations, idempotent
area exports, source manifests, external certificate-package pins, standalone
finitegeom validation, and clean paper release surfaces. C879 must consume those
artifacts rather than re-inventing a second ownership map or repeating the export
completion pass.

The C864 phase-1 stale-build-residue sweep is not itself a C879 prerequisite to
repeat. The relevant handoff is the final C864 state: all adopted areas are exported
from tracked configurations, their deltas are empty, certificate boundaries are
green, and the affected paper interfaces have clean release evidence.

## Proposed architecture

Use explicit paper and shared source roots:

```text
finitegeom/
  Shared/
    Projective/  FiniteFields/  Coding/  Incidence/  Certificates/  PRS/
  Papers/
    arcs_complete_outside_conic/  beyond4_prs/  ame_lu/
    clebsch-rigidity/  clebsch-passages/
    q13-passant-code/  mds_css_transversal_groups/
    complete-repair-ports/  equivariant-robust-completion/
```

The directory names above are exact paper/repository aliases and are intentionally
lowercase with underscores or hyphens. They are not Lean module names. The Lean
namespaces need a personal, ecosystem-unique top level: bare `Paper.*` and
`FiniteGeom.*` are too generic. Use the explicit project brand
`TavisRuddFiniteGeom`. Lean module components should use the usual PascalCase
convention, for example:

```text
TavisRuddFiniteGeom.Papers.Beyond4PRS.*
TavisRuddFiniteGeom.Papers.ArcsCompleteOutsideConic.*
TavisRuddFiniteGeom.Papers.AMELU.*
TavisRuddFiniteGeom.Shared.Projective.*
```

During the first split, preserve the existing `RelativeConicArcs.*` module names
behind package-specific source roots; do not force filesystem aliases into Lean
names. Namespace migration to the PascalCase names above is a later, separate
chunk. The import direction is one-way: papers may import shared APIs;
shared APIs may not import papers. A genuine cross-paper result, such as the PRS
balanced quantum extension consuming AME--LU results, must use an explicit adapter
and declared paper dependency.

## Paper-facing and shared module/gate naming standard

This standard applies to both exported shared libraries and paper-facing exported
closures: modules imported by a paper or shared public interface, exported through a public API,
named by a trust manifest, or required to reproduce a paper claim. It does not rename
unrelated internal development modules. Internal names change only when the module is
promoted into one of these public closures.

Use mathematical subject names for ordinary shared and paper-facing modules and reserve
infrastructure words for actual infrastructure. This follows the Lean/mathlib norm of
UpperCamelCase file names, snake_case propositions, and lowerCamelCase data/functions.
The paper's textbook section or review history is not a module taxonomy.

Use these shapes:

```text
Shared/<domain>/
  Definitions.lean
  <MathematicalSubject>.lean
TavisRuddFiniteGeom.lean
Verification/
  AxiomAudit.lean
  DependencyGraph.json

Papers/<full-paper-alias>/
  PaperInterface.lean
  <MathematicalSubject>.lean
  Verification/
    AxiomAudit.lean
    DependencyGraph.json
```

Rules:

- ordinary files name the mathematical object, interface, or theorem family;
- `PaperInterface.lean` is the reviewer-facing Lean entry point: readable definitions,
  theorem statements, and the paper-facing public imports;
- `Verification/` contains machine-facing audits, dependency graphs, and replay
  metadata; `AxiomAudit.lean` audits the `PaperInterface` closure and is not a second
  mathematical proof;
- `Gate` remains an operational build/export term in manifests and tooling, not a
  reviewer-facing module naming convention;
- an additional Lean aggregate is allowed only when it names a real mathematical or
  certificate boundary, such as `QuantumExtension.lean` or `Certificate.lean`;
- reserve `Trust` for manifests, reports, and external trust facts, not Lean module
  names;
- replace status/history suffixes such as `Human`, `Additions`, `Aggregate`, and
  `Axioms` with mathematical names or precise verification filenames;
- use `Core`, `Foundation`, `Extensions`, or `Examples` only when they describe the
  actual API layer;
- keep generated leaves in their owning certificate package and name their mathematical
  partition, not a build order or task number.

The q11 and q16 certificate repositories are frozen exceptions to this migration:
their existing module, gate, and audit names are not renamed. The finitegeom-side
public adapter, pin, manifest, and paper interface may follow this standard, but the
separately versioned certificate source remains byte-compatible with its current API.

Thus the eventual PRS public surface would be:

```text
TavisRuddFiniteGeom.Papers.Beyond4PRS.PaperInterface
TavisRuddFiniteGeom.Papers.Beyond4PRS.Verification.AxiomAudit
TavisRuddFiniteGeom.Papers.Beyond4PRS.QuantumExtension
```

For the PRS pilot, the registered geometric gate is the boundary, not the whole
`RelativeConicArcs.PRS*` namespace. Its current closure is 16 project-owned Lean
modules, with the aggregate audit adding one. The balanced quantum gate is a separate
52-module project-owned closure (53 with its audit), including 37 AME--LU modules;
it is not part of the geometric pilot. The R8, R9, and characteristic-two/Lucas gates
and their audits are currently outside the registered R5--R7 paper closure, even though
their source modules reuse the PRS foundation. Those source modules therefore belong
to a central `Shared.PRS` family until their own paper or research-package boundaries
are declared.

The first source split preserves existing module names. This naming cleanup is a later
one-paper-facing-family chunk with its own reverse-closure and synchronization; it does
not trigger a repository-wide rename. Shared-library families use the same rule and
may expose their own `PaperInterface` only when they genuinely have a reviewer-facing
public surface. Existing q11 and q16 certificate repositories remain byte-compatible
exceptions and are not renamed.

The first physical split must not also rename namespaces. Initially preserve existing
module names behind package-specific source roots, for example:

```text
Papers/beyond4_prs/RelativeConicArcs/PRSFoundation.lean
Papers/arcs_complete_outside_conic/RelativeConicArcs/...
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

1. Record the C864 endpoint: finitegeom commit, eleven area configurations, area
   source manifests, certificate pins, standalone-build result, paper roots, and
   release-fact hashes. Refuse the operation if that endpoint is dirty, non-idempotent,
   or missing its standalone validation.
2. Derive the first ownership graph directly from the C864 area manifests and import
   closures, without running Lean. Compute area intersections and reverse consumers;
   classify only the residual modules as paper-specific. Treat an area manifest as
   an export boundary, not as automatic proof of declaration-level ownership.
3. Review overlap modules at declaration level, including `open` namespaces,
   re-exports, generated sources, and certificate schemas. Promote only mathematically
   reusable APIs into `Shared`; keep paper-specific theorem statements and evidence
   out of shared libraries.
4. Add per-paper manifests and a read-only import-firewall checker while leaving all
   Lean source in place. Reject shared-to-paper imports, undeclared paper-to-paper
   imports, undeclared generated inputs, and roots outside the manifest closure.
5. Create paper directories and package-specific source roots while retaining the
   existing module names and one Lake project. Do not combine this step with a
   namespace rewrite.
6. Extract one already C864-validated, human-scale paper interface as the pilot. Use the
   main beyond-four PRS geometric interface first: its registered aggregate is a small
   16-module project-owned closure. Do not infer that every `RelativeConicArcs.PRS*`
   module belongs to this paper: the PRS foundation, contraction, polar-induction, and
   R6/R7 modules are also consumed by the unadopted R8/R9/Lucas branches. Keep that
   PRS-family infrastructure centrally until those consumers are classified. Keep the
   balanced quantum extension and its AME--LU adapter as a separate later chunk; do not
   combine that cross-paper branch with the PRS pilot. Retain shared modules centrally
   and use temporary compatibility shims where necessary.
7. Validate the pilot from a clean package-local source tree: use the existing area
   manifest and standalone-build gate, build only the `PaperInterface` and audit through
   the guarded queue, run its checker, compare declarations and axioms, and run the
   source/manifest audits. Do not run a repository-wide build.
8. For every later change, compute the exact reverse-import closure before building.
   A paper-private move rebuilds only that paper; a shared API change rebuilds every
   affected paper interface; manifest-only changes require no Lean build.
9. Extract the remaining leaf papers in dependency order: complete ports,
   equivariant completion, q13 after its certificate package is sealed, Clebsch
   passages, MDS/CSS after the AME--LU API is frozen, then Clebsch rigidity/hexagon
   code. Extract the PRS balanced adapter only after AME--LU's public API is frozen.
10. Freeze the arcs and AME--LU shared APIs last. They are shared-heavy foundations;
   moving them earlier would repeatedly reopen downstream closures.
11. Only after each monorepo package passes an independent clean replay, split the
    shared libraries and paper source into separately pinned Lake packages. Perform
    namespace cleanup one package at a time after the package boundary is green.

## Sub-30-minute chunk protocol

Every chunk is independently shippable. A chunk has exactly one small objective, one
bounded validation envelope, one explicit commit, and a clean stopping state. The
working tree must be clean after the commit; no chunk leaves an untracked report,
generated file, source move, or half-applied manifest.

### Synchronization invariant

Every chunk that changes Lean source includes downstream synchronization before it is
complete. The authoritative order is:

```text
monorepo authority
  → finitegeom export/package
  → every affected standalone paper repository
```

The source change is prepared and validated first, then propagated with the guarded
export/mirror workflow. A paper repository is affected when its declared Lean closure,
shared-library pin, gate, trust fact, or source manifest changes. A shared-library
change therefore synchronizes every paper in its reverse-import closure; a
paper-private change synchronizes that paper at minimum.

No chunk may finish with a green monorepo and stale finitegeom or paper source. The
chunk report records every resulting repository and commit, the exact export/mirror
command, source-manifest or pin comparisons, and clean replay results. If propagation
fails, the chunk remains incomplete and no later Lean change begins.

Generated certificate payload is not copied into papers. Its owning package is
re-pinned and its compact trust fact is propagated through the declared boundary.
Source authority remains the monorepo; standalone paper repositories are synchronized
downstream and are never edited as alternate authorities.

The working budget is 25 minutes, leaving five minutes for inspection and commit. A
chunk that would require a longer Lean gate is not a 30-minute chunk: split the source
change at a module/API boundary, or leave the source unchanged and ship the preceding
metadata/checker chunk. Do not hide a multi-hour build inside a small administrative
step. Detached queue execution is allowed only after the affected closure has already
been reduced and the chunk's source state is otherwise complete.

Each chunk report records:

```text
objective:
changed paths:
validation command(s):
validation result:
commit:
next safe chunk:
```

### Chunk sequence

| Chunk | Single objective | Validation and shippable state |
|---|---|---|
| C879.0 | Record the completed C864 endpoint and exact input revisions. | Read-only manifest/hash checks; commit the baseline record. |
| C879.1 | Define the paper/shared manifest schema. | Parser/unit tests only; commit schema and fixtures. |
| C879.2 | Generate area-overlap and reverse-consumer data from C864 manifests. | Deterministic regeneration and hash check; commit script and compact output. |
| C879.3 | Add the import-firewall checker in report-only mode. | Checker tests against real and adversarial fixtures; commit checker. |
| C879.4 | Convert the checker to enforcement for shared-to-paper and undeclared paper-to-paper imports. | Existing tree passes; adversarial cases fail as intended; commit policy. |
| C879.5 | Create the `beyond4_prs` paper directory/package scaffold without moving Lean. | Manifest, source listing, and clean-tree checks; commit scaffold. |
| C879.6 | Register the exact beyond-four PRS geometric closure and its exclusions, excluding the balanced quantum branch and the unadopted R8/R9/Lucas branches. | Source audit, closure diff, and empty export delta; commit metadata only. |
| C879.7 | Validate the beyond-four PRS `PaperInterface` and its axiom audit. | Guarded exact-target build and paper checker; commit the validation record. |
| C879.8 | Move one paper-facing PRS interface/wrapper family behind the preserved module names, without moving PRS-family infrastructure. | Exact reverse-closure check, smallest affected `PaperInterface`, guarded downstream export, and affected-paper replay; commit only when every tree is synchronized. |
| C879.9 | Move the next paper-facing wrapper family, or stop if the reverse closure exceeds the budget. | Repeat C879.8; no shared PRS-family move is permitted in this chunk. |
| C879.10 | Extract one genuinely shared API family identified by overlap review. | Declaration-level review, affected-interface list, bounded shared build target, downstream exports, and all affected-paper replays; commit only when synchronized. |
| C879.11 | Add the first explicit paper adapter for a real cross-paper dependency. | Adapter-only build target, import-firewall check, axiom audit, downstream pin updates, and affected-paper replay. |
| C879.12+ | Repeat the paper-private/shared-family cycle for the next paper. | Each row is a separate synchronized commit set and must leave every affected package buildable. |

Chunks C879.0--C879.6 should not require a Lean elaboration. C879.7 and later may
elaborate Lean, but only the exact affected `PaperInterface` or named mathematical
aggregate is allowed. If C879.7 cannot fit the
budget with the available cache, the pilot is too large; choose a smaller human-scale
area before moving source.

### Runtime review

These are planning estimates, not recorded measurements. They assume the C864 endpoint
has restored the required caches and that no unrelated Lean process owns the build
slot. The first real gate run must record GNU-time telemetry; estimates do not authorize
raising a worker cap or bypassing the queue.

| Chunk | Lean/source scope | Expected wall time | Review |
|---|---|---:|---|
| C879.0 | No Lean; endpoint hashes and manifests only | 2–5 min | Safe. |
| C879.1 | No Lean; manifest parser and fixtures | 5–15 min | Safe. |
| C879.2 | No Lean; deterministic area-overlap generator | 5–15 min | Safe. |
| C879.3 | No Lean; report-only firewall tests | 5–15 min | Safe. |
| C879.4 | No Lean; enforcement tests and real-tree scan | 5–20 min | Safe. |
| C879.5 | No Lean; PRS directory/package scaffold | 5–15 min | Safe. |
| C879.6 | No elaboration; byte-preserving area materialization and source audit | 5–20 min | Safe if the export has no delta. |
| C879.7 | Main PRS `PaperInterface` plus `Verification/AxiomAudit`; 16-module main closure and 17-module audited closure | 2–10 min warm; 10–25 min cold | Safe only with restored dependencies and an exact target. |
| C879.8 | One paper-facing wrapper family, initially 1–4 modules, plus its exact `PaperInterface` | 2–10 min | Safe after the family and target are named; PRS infrastructure remains shared. |
| C879.9 | Next paper-facing wrapper family, same limit | 2–10 min | Safe only if the reverse closure remains bounded. |
| C879.10 | One shared API family plus every reverse-dependent paper interface | 5–25 min warm; unbounded cold | Conditional; split if more than one heavy paper interface is affected. |
| C879.11 | PRS balanced adapter, importing AME--LU and PRS interfaces | 5–25 min warm; potentially hours cold | Not guaranteed sub-30-minute; first ship its manifest/API-only change, then measure the exact adapter gate. |
| C879.12+ | One named family at a time | Must be measured per family | Never instantiate as a bulk migration. |

The PRS pilot must therefore use explicit families rather than “one family” as an
open-ended unit: foundation/contraction, R5, polar/R6--R7, stable-components, and
covering-radius interfaces. A family is eligible only when its source list and affected
`PaperInterface`/aggregate target fit the small-closure bound.

The 25-minute budget applies to the complete chunk, including synchronization and
commit. If a clean package replay, downstream export, or affected-paper check exceeds
that budget, stop with the source unchanged and split the chunk or record the measured
long gate as a separately scheduled operation. It is not acceptable to call a long
build “background work” while declaring the chunk shipped.

The first chunk after any source move is never a namespace cleanup. Namespace changes
are separate chunks with their own reverse-closure calculation and exact target. The first
package extraction is likewise separate from namespace cleanup and shared-library
movement.

For C879.8 and later, “commit” means a synchronized commit set, not merely a commit in
the monorepo. The repositories may have different commit IDs, but all must identify
the same authoritative source revision and pass the applicable source audit before the
chunk is closed.

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
- Do not rerun C864's eleven-area export/idempotence pass unless an area manifest or
  its source commit changes; C879 consumes its committed result.

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
- C864 area boundaries are not automatically paper ownership boundaries. A module
  may be exported in several areas or may declare into another namespace. Require
  overlap review before moving it into `Shared` or a paper directory.
- Re-exporting a C864 area does not prove its candidate package builds standalone.
  Keep the standalone finitegeom gate as a prerequisite for every extracted package.

## First acceptance gate

Before moving source, record the C864 endpoint and commit an ownership/import
manifest derived from its area manifests, a generated reverse-dependency report, and
an import-firewall checker. The report must identify the exact shared modules that
remain required by each paper, the exact paper-specific modules safe to extract, and
the exact gate targets affected by a change. No source deletion, namespace rewrite,
or repository split is authorized by this plan alone.

## Scope boundary

This is a design and sequencing record. It does not authorize builds, certificate
regeneration, mirror writes, repository extraction, deletion, or changes to package
boundaries.
