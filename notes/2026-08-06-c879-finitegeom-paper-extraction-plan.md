# C879 — finitegeom paper-boundary extraction plan and red-team

**Lane:** `build-sys` · **Date:** 2026-08-06 · **Status:** Q11 self-contained
certificate migration in progress; the C891 module mapping is stale and must be
regenerated from the current tree before it can authorize any paper move

## Objective

Progressively separate the shared `finitegeom` Lean repository into reviewer-friendly
paper packages without breaking shared mathematics, trust boundaries, certificate
provenance, or the current monorepo authority.

The primary build invariant is stronger than source ownership: ordinary edits to
human-scale shared or paper Lean must never schedule a rebuild of the frozen q11,
q16, or other heavyweight certificate leaves.  A heavyweight certificate rebuild is
allowed only when a reviewed change to the minimal stable certificate API makes the
existing artifact genuinely incompatible, after an exact reverse-dependency report,
an explicit user decision, and a measured rebuild plan.  A missing cache, changed
paper pin, finitegeom release, or unrelated source edit is a refusal, not permission
to rebuild a certificate package.

## Starting boundary

C879 execution starts only after the C864 export-completion plan reaches its endpoint.
The C891 metadata refresh does not waive that dependency.  As of its snapshot the
tree has sixteen paper-registry records, fourteen standalone-repository records, and
twelve tracked Lean export areas.  C864 is establishing the useful substrate: tracked area configurations, idempotent
area exports, source manifests, external certificate-package pins, standalone
finitegeom validation, and clean paper release surfaces. C879 must consume those
artifacts rather than re-inventing a second ownership map or repeating the export
completion pass.

The C864 phase-1 stale-build-residue sweep is not itself a C879 prerequisite to
repeat. The relevant handoff is the final C864 state: all adopted areas are exported
from tracked configurations, their deltas are empty, certificate boundaries are
green, and the affected paper interfaces have clean release evidence.
An endpoint that encodes q11/q16 importing finitegeom is not a completed C864
endpoint for C879 purposes; C879.0 must reject and repair that dependency direction
before accepting the baseline.

## Proposed architecture

Before any paper split, establish and enforce this package DAG:

```text
finitegeom  --imports-->  q11-certificates
finitegeom  --imports-->  q16-certificates

q11-certificates  --imports-->  Mathlib only
q16-certificates  --imports-->  Mathlib only
every other heavyweight certificate package  --imports-->  Mathlib only
```

The first two finitegeom edges are opt-in adapter edges, not imports of the
ordinary human library roots.  No default finitegeom target, shared human module,
or paper-independent interface may import a certificate adapter.  A paper interface
imports an adapter only when one of its claims uses that certificate.  Thus editing
finitegeom human source is upstream of no heavyweight certificate target even though
the Lake package can resolve the frozen certificate dependency.

Each certificate package owns the frozen local types, operations, coordinate data, and
predicates needed to state its terminals.  It imports no project-owned foundation,
`finitegeom`, paper package, or other certificate package.  A cheap downstream adapter
proves the local model equivalent to the human API and transports the certificate
terminal into the paper-facing statement.  A hash, version assertion, or unproved type
comparison is insufficient: compatibility is a Lean equality/equivalence plus theorem
transport.  Human and paper-level aggregates live in `finitegeom` downstream of the
adapter.  Consequently no project-owned source change can invalidate a heavyweight
certificate artifact.

For Q11 the current declaration-level seam is:

```text
q11-certificates:
  a private frozen coordinate model, Q11BrianchonPetersen,
  and the Q11A5PointOrbits certificate family
finitegeom:
  the proved local-model compatibility adapter, Q11Coding semantic synthesis,
  decoder/rigidity/orientation layers,
  and the paper-facing Clebsch aggregate
```

`Q11BrianchonPetersen` is a strict-kernel Q11 certificate, not foundation.  Its
current import by the orbit package is evidence that it belongs in the Q11 package.
The package's present Clebsch-wide gate is not a certificate-only gate: it imports
finitegeom human modules and must be split.  The Q11 package exposes only its orbit and
Brianchon terminals; the Clebsch paper aggregate remains downstream in finitegeom.

The Q11 compatibility spike is green: the final stable-named Mathlib-only local model
elaborated in 5.94 seconds at 1.03 GB peak RSS, and the downstream adapter elaborated
in 61.80 seconds at 3.34 GB.  The adapter proved equality of the actual witness and canonical
point tables and transported a certificate theorem; no heavyweight Q11 target was
scheduled.  This establishes the mechanism, not the full Q11 ownership manifest.

`lean/scripts/lean-certificate-dependency-firewall.py` is the executable package
edge policy.  Its Q11 check is green after the self-contained rewrite.  Its portfolio
scan intentionally remains red for the projective-cap Q11, Q13, Q16, and Q25
certificate packages until each receives the same local-model/adapter migration.

The Q16 ownership seam is not its current repository boundary.  The generated level,
step-kernel, leaf, and rejection checks belong in the self-contained certificate
package behind a local `Idx`/field model.  `Q16Reduction`, `Q16Result`, and the
paper-wide `ArcsCompleteOutsideConic` gate are human downstream modules and remain in
finitegeom; the adapter transports the generated rejection terminal into that layer.

The other current reverse edges are bounded.  The projective-cap Q11 and Q13 packages
reach only `ProjectiveCap.CertCheck` and `ProjectiveCap.PlaneOutcome`; their generated
checks get a local statement model and the outcome transport moves downstream.  Q25
reaches six human modules (`Certificate`, `FiniteFields`, `Moments`, `Nucleus`,
`ProjectiveBridge`, and `PlaneTransitivity`); its 9,531-file payload must be separated
from those six adapters without regenerating or renaming the leaves.

Use explicit paper and shared source roots:

```text
finitegeom/
  Shared/
    Projective/  FiniteFields/  Coding/  Incidence/  Certificates/  PRS/
  Papers/
    arcs_complete_outside_conic/  beyond4_prs/  ame_lu/
    clebsch-rigidity/  clebsch-passages/  clebsch-factorization/
    q13-passant-code/  mds_css_transversal_groups/
    complete-repair-ports/  equivariant-robust-completion/
    continuation-graph-rigidity/  dihedral-schreier-node-kayles/
    golden-operator/  golden-quantum-statistics/
```

The directory names above are exact paper/repository aliases and are intentionally
lowercase with underscores or hyphens. They are not Lean module names.  Existing
public namespaces remain unchanged.  A genuinely new public module family uses the
ecosystem-unique top level `TavisRuddFiniteGeom`, rather than bare `Paper.*` or
`FiniteGeom.*`. Lean module components use the usual PascalCase convention, for example:

```text
TavisRuddFiniteGeom.Papers.Beyond4PRS.*
TavisRuddFiniteGeom.Papers.ArcsCompleteOutsideConic.*
TavisRuddFiniteGeom.Papers.AMELU.*
TavisRuddFiniteGeom.Shared.Projective.*
```

During the split, preserve the existing `RelativeConicArcs.*` module names behind
package-specific source roots.  Namespace migration is not an extraction deliverable:
it invalidates downstream artifacts without improving isolation.  Consider it only
later for an already isolated human package with a demonstrated benefit and no
heavyweight reverse dependency. The import direction is one-way: papers may import shared APIs;
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

The q11 and q16 certificate repositories are frozen exceptions to the naming
migration: their existing module, gate, and audit names are not renamed.  They are
not exceptions to the dependency firewall.  Each imports Mathlib only and owns its
frozen local statement model, while finitegeom imports its terminal through a proved
compatibility adapter.  The separately versioned certificate source and compiled
cache remain byte-compatible until an explicitly approved certificate change requires
a new artifact.

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

The C891 snapshot below is retained only as a stale planning snapshot.  Its module
counts and immutable-tree assumption are not execution inputs; regenerate them from
the current trust facts and export manifests before use.  Export closures are never
ownership proofs:

| Export area | Gate | Project-owned closure |
|---|---|---:|
| `ame_lu` | `AMELUAggregate` | 67 |
| `arcs_complete_outside_conic` | `ArcsCompleteOutsideConic` | 72 |
| `arcs_complete_outside_conic_additions` | `ArcsCompleteOutsideConicAdditions` | 31 |
| `clebsch_factorization` | `ClebschArithmeticGluing` | 31 |
| `clebsch_passages` | `ClebschPassages` | 19 |
| `clebsch_rigidity` | `ClebschRigidityTrust` | 94 |
| `clebsch_six_arc_concurrence` | `SixArcConcurrenceSpine` | 26 |
| `clebsch_support_cubic_orientation` | `SupportOrientationSpine` | 21 |
| `complete_ports` | `CompletePorts` | 31 |
| `golden_quantum_statistics` | `GoldenQuantumStatistics` | 9 |
| `mds_css_transversal_groups` | `MDSCSSTransversalGeometry` | 66 |
| `prs_beyond_redundancy_four` | `PRSBeyondRedundancyFour` | 16 |

The trust-declared `AMELUTwoUniformRigidity` gate is additional: its current closure
has nine project-owned modules, including C890's
`RelativeIntertwinerDecomposition`, but it still has no tracked export configuration.
It is classified as an AME--LU Paper I quantitative-core closure, not as a future
paper or unclassified work.  The wider `AMELUAggregate` remains a pre-split export
whose closure exceeds the current Paper I manuscript surface.

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

No namespace cleanup is implied by the physical split.  Preserving public module names
prevents a directory move from becoming an import rewrite and rebuild.

Each registered paper should own or explicitly alias a small manifest declaring its roots, source closure, shared
dependencies, generated inputs, certificate packages, axiom expectations, and exact
replay command.  Secondary entry points such as the beyond-four submission manuscript
and the Clebsch computational companion alias their parent formal surface rather than
creating duplicate Lean packages.  Papers with no current Lean export area are recorded
as such rather than omitted.  The central trust portfolio should be generated from
these manifests, not serve as the primary ownership map.

## Staged execution and bounded validation

0. Regenerate the actual module and package maps from the current trees.  Record the
   actual package DAG and compare it with the required certificate DAG
   above.  Refuse every source move while q11 or q16 requires `finitegeom`, while a
   heavy leaf remains in finitegeom, or while finitegeom lacks an exact frozen package
   pin and adapter.  Add the dependency-direction checker and adversarial fixtures
   before changing a package boundary.
1. Record the C864 endpoint: finitegeom commit, twelve area configurations, area
   source manifests, certificate pins, standalone-build result, paper roots, and
   release-fact hashes. Refuse the operation if that endpoint is dirty, non-idempotent,
   or missing its standalone validation.
2. Derive the first ownership graph from the union of the trust-area gate
   declarations, tracked export configurations, paper registry, repository registry,
   and import closures, without running Lean.  A trust-declared gate without an export
   configuration receives an explicit disposition; it is never silently invisible.
   Compute area intersections and reverse consumers;
   classify only the residual modules as paper-specific. Treat an area manifest as
   an export boundary, not as automatic proof of declaration-level ownership.
3. Review overlap modules at declaration level, including `open` namespaces,
   re-exports, generated sources, and certificate schemas. Promote only mathematically
   reusable APIs into `Shared`; keep paper-specific theorem statements and evidence
   out of shared libraries.
4. Add per-paper manifests and a read-only import-firewall checker while leaving all
   Lean source in place. Reject shared-to-paper imports, undeclared paper-to-paper
   imports, undeclared generated inputs, and roots outside the manifest closure.  If a
   module is also exported by another area, reject any replacement that drops a
   declaration used outside the active closure even when the replacement's bytes and
   imports are locally consistent.
5. Establish the self-contained Q11 local model, compatibility adapter, and
   certificate-only gate, then perform its one-time
   explicitly approved cache migration.  Prove that a disposable finitegeom human
   edit schedules zero Q11 targets before beginning any paper split.  Repeat for Q16
   only as its own separately approved migration.
6. Create paper directories and package-specific source roots while retaining the
   existing module names and one Lake project. Do not combine this step with a
   namespace rewrite.
7. Extract one already C864-validated, human-scale paper interface as the pilot. Use the
   main beyond-four PRS geometric interface first: its registered aggregate is a small
   16-module project-owned closure. Do not infer that every `RelativeConicArcs.PRS*`
   module belongs to this paper: the PRS foundation, contraction, polar-induction, and
   R6/R7 modules are also consumed by the unadopted R8/R9/Lucas branches. Keep that
   PRS-family infrastructure centrally until those consumers are classified. Keep the
   balanced quantum extension and its AME--LU adapter as a separate later chunk; do not
   combine that cross-paper branch with the PRS pilot. Retain shared modules centrally
   and use temporary compatibility shims where necessary.
8. Validate the pilot from a clean package-local source tree: use the existing area
   manifest and standalone-build gate, build only the `PaperInterface` and audit through
   the guarded queue, run its checker, compare declarations and axioms, and run the
   source/manifest audits. Do not run a repository-wide build.
9. For every later change, compute the exact reverse-import closure before building.
   A paper-private move rebuilds only that paper; a shared API change rebuilds every
   affected paper interface; manifest-only changes require no Lean build.  An ordinary
   finitegeom or paper change must report zero scheduled q11/q16 certificate targets.
   Only a reviewed change inside that certificate package may invalidate a heavyweight
   artifact, and that change stops for explicit user authorization before any source build begins.
10. Freeze the declaration-level public APIs of upstream families before their
   downstream consumers: AME--LU before MDS--CSS and the PRS balanced adapter; the PRS
   family before either beyond-four entry point; shared projective/incidence/coding
   APIs before the Arcs, Clebsch, q13, and equivariant consumers.  A freeze is an API
   and ownership decision, not a physical source move.
11. Extract leaf paper surfaces after those freezes: complete ports; continuation and
    dihedral if they acquire finitegeom gates; golden quantum statistics; equivariant
    completion; q13 after its certificate package is sealed; the focused Clebsch
    surfaces; MDS--CSS; and the PRS balanced adapter.  The golden operator and the two
    exported Clebsch companion boundaries require explicit paper-ownership decisions.
    Move the shared-heavy Arcs and AME--LU source families last, after their consumers
    are green, without reopening the already frozen public APIs.
12. Only after each monorepo package passes an independent clean replay, split the
    shared libraries and paper source into separately pinned Lake packages. Preserve
    existing public module names; namespace cleanup is outside this extraction plan.

## Sub-30-minute chunk protocol

Every chunk is independently shippable. A chunk has exactly one small objective, one
bounded validation envelope, one explicit commit, and a clean stopping state. The
working tree must be clean after the commit; no chunk leaves an untracked report,
generated file, source move, or half-applied manifest.

### Synchronization invariant

Every chunk that changes Lean source includes downstream synchronization before it is
complete.  The route depends on source authority:

```text
certificate-only authority in every heavyweight package
  → sealed certificate package and cache
  → finitegeom adapter pin through its exporter and affected paper pins

human/paper authority in the monorepo
  → finitegeom through its exporter
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

Generated certificate payload is not copied into papers.  Its owning package pin and
compact trust fact are propagated through the declared boundary without rebuilding
or re-sealing that package.  A finitegeom-only or paper-only change must not re-pin a
certificate package.  Re-pinning is permitted only when the certificate source changed
deliberately; a cache miss or newer finitegeom
commit is not a re-pin trigger.
Human and shared source authority remains the monorepo, certificate-only source
authority remains its owning package, finitegeom is never edited directly, and standalone paper repositories are
synchronized downstream rather than edited as alternate authorities.

The working budget is 25 minutes, leaving five minutes for inspection and commit. A
chunk that would require a longer Lean gate is not a 30-minute chunk: split the source
change at a module/API boundary, or leave the source unchanged and ship the preceding
metadata/checker chunk. Do not hide a multi-hour build inside a small administrative
step. Detached queue execution is allowed only after the affected closure has already
been reduced and the chunk's source state is otherwise complete.

No chunk may silently fall back from a missing or stale heavyweight cache to a source
build.  Normal finitegeom and paper validation requires the exact content-addressed
q11/q16 cache and fails closed when it is absent.  A certificate cold build is its own
user-approved operation, never an incidental substep of export, synchronization, pin
refresh, or manuscript verification.

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
| C879.0 | Regenerate the live module map and add the package-DAG firewall. | Parser/unit tests plus adversarial reverse-edge and missing-adapter fixtures; the current reversed tree is reported, not accepted. |
| C879.1 | Spike the self-contained Q11 local model and proved downstream adapter. | Build only the Mathlib-only model and cheap adapter; inspect their exact imports. |
| C879.2 | Commit the declaration-level Q11 ownership manifest and certificate-only gate design. | Exact import/use report; reject human or paper imports from the certificate package. |
| C879.3 | Move the local Q11 coordinate model and `Q11BrianchonPetersen` into the Q11 package. | Cheap adapter elaboration only; no heavyweight fallback. |
| C879.4 | Rewire finitegeom to the opt-in Q11 adapter and remove every Q11-to-finitegeom edge. | DAG/import firewall and dry-run affected-target regression; no source build yet. |
| C879.5 | Perform the one-time explicitly approved Q11 certificate rebuild and publish its exact cache. | Measured heavy gate, trust fact, sealed manifest, cache restore replay, exporter-only finitegeom adoption. |
| C879.6 | Prove the Q11 rebuild firewall, then decide the separately gated Q16 migration. | Disposable cheap finitegeom edit schedules zero Q11 targets; missing cache refuses source fallback. |
| C879.7 | Validate the beyond-four PRS `PaperInterface` and its axiom audit. | Guarded exact-target build and paper checker; commit the validation record. |
| C879.8 | Move one paper-facing PRS interface/wrapper family behind the preserved module names, without moving PRS-family infrastructure. | Exact reverse-closure check, smallest affected `PaperInterface`, guarded downstream export, and affected-paper replay; commit only when every tree is synchronized. |
| C879.9 | Move the next paper-facing wrapper family, or stop if the reverse closure exceeds the budget. | Repeat C879.8; no shared PRS-family move is permitted in this chunk. |
| C879.10 | Extract one genuinely shared API family identified by overlap review. | Declaration-level review, affected-interface list, bounded shared build target, downstream exports, and all affected-paper replays; commit only when synchronized. |
| C879.11 | Add the first explicit paper adapter for a real cross-paper dependency. | Adapter-only build target, import-firewall check, axiom audit, downstream pin updates, and affected-paper replay. |
| C879.12+ | Repeat the paper-private/shared-family cycle for the next paper. | Each row is a separate synchronized commit set and must leave every affected package buildable. |

Chunks C879.0 and C879.2 require no Lean elaboration.  C879.1 and C879.3--C879.4 may
elaborate only the local model and cheap human adapter modules.  C879.5 is the explicit one-time heavy
Q11 migration and is not subject to the 30-minute chunk fiction; it records its real
resource envelope.  C879.7 and later may elaborate Lean, but only the exact affected
`PaperInterface` or named mathematical aggregate is allowed. If C879.7 cannot fit the
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
| C879.1 | Q11 local-model and adapter spike only | 2–10 min | Safe; no heavyweight target. |
| C879.2 | No Lean; declaration ownership and gate manifest | 5–15 min | Safe. |
| C879.3 | Q11 source relocation plus cheap adapter | 5–20 min before the separately gated rebuild | Conditional. |
| C879.4 | DAG firewall and affected-target dry run | 5–20 min | Must schedule zero heavy targets. |
| C879.5 | One-time Q11 certificate rebuild, seal, and exact cache | Measured separately; about 52 min from the current baseline | Explicit approval required. |
| C879.6 | Cache-required Q11 adapter regression | 5–20 min | Missing cache must refuse. |
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
- Restore heavyweight certificate artifacts only from an exact cache keyed by
  package commit, Lean toolchain, Mathlib commit, and target
  platform.  Use require-cache semantics: a cache miss fails and never falls back to
  compiling certificate source.
- Reject a build plan that schedules any q11/q16 source target after a change confined
  to finitegeom human layers, a paper package, manifests, prose, pins, or release
  metadata.  The regression gate is an exact dry-run/trace comparison with zero heavy
  targets.
- Permit a heavyweight source build only for a reviewed certificate
  source change, with explicit user authorization and a separately recorded resource
  envelope.  Never infer permission from a stale trace or completed dependency build.
- Do not rerun C864's twelve-area export/idempotence pass unless an area manifest or
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
- The phrase “one-way dependency” is directionally ambiguous and previously encoded
  the wrong edge.  Every policy, manifest, and report must spell out
  `finitegeom adapters import q11/q16` and `q11/q16 import Mathlib only`; the executable DAG
  checker, not prose, is authoritative.
- A package manager may rebuild a dependency checkout after a harmless pin refresh
  even when source bytes are unchanged.  Therefore ordinary finitegeom and paper
  workflows never refresh the internal dependency pins of frozen certificate
  packages and never permit source fallback on cache restoration.
- C864 area boundaries are not automatically paper ownership boundaries. A module
  may be exported in several areas or may declare into another namespace. Require
  overlap review before moving it into `Shared` or a paper directory.
- A trust-declared gate can be paper-facing without having an export configuration.
  Inventory trust gates and export configurations independently; the AME--LU
  two-uniform gate is the current concrete example.
- A secondary manuscript entry point is not a second Lean owner.  Alias it to the
  parent formal surface and reject divergent duplicate package maps.
- Byte-identically replacing a shared module can still delete declarations outside
  the active area's closure.  Compare declaration sets and reverse consumers before
  every replacement, including exports that appear locally unchanged.
- Re-exporting a C864 area does not prove its candidate package builds standalone.
  Keep the standalone finitegeom gate as a prerequisite for every extracted package.

## First acceptance gate

Before moving source, record the C864 endpoint and commit the required package DAG,
an executable dependency-direction check, and adversarial fixtures proving that a
q11/q16 package requiring finitegeom is rejected.  Commit an ownership/import
manifest derived from the union of trust gates, export configurations, and paper and
repository registries, a generated reverse-dependency report, and
an import-firewall checker. The report must identify the exact shared modules that
remain required by each paper, the exact paper-specific modules safe to extract, and
the exact gate targets affected by a change. No source deletion, namespace rewrite,
or repository split is authorized by this plan alone.

The gate also includes a build-plan regression: change a disposable cheap human-layer
module in a clean fixture, compute the affected targets, and require zero q11/q16
certificate source targets.  Remove or withhold the exact heavyweight cache and
require a clear refusal rather than a source build.  C879 cannot move its first paper
source until both tests pass.

The old metadata preflight is:

```text
python3 notes/scripts/c879_module_closure.py
```

It is currently expected to fail because its C891 module map is stale.  Refresh its
committed mapping from the live registries before making it an execution gate again.
After refresh it rejects paper/repository/export
inventory drift, changed gate closures, missing mapped sources or roots, duplicate
target names, unresolved aliases, AME--LU coverage gaps, and Lean-tree drift from the
mapping's immutable authority commit.  Passing this preflight certifies the planning
snapshot, not declaration-level ownership or a build.

## Scope boundary

This record authorizes the Q11 local-model/adapter boundary work explicitly requested for the
current architecture correction.  Heavy source builds, certificate regeneration,
mirror writes, Q16 migration, deletion, and publication remain separately gated.
