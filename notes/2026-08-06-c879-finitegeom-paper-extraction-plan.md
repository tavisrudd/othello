# C879 — finitegeom paper-boundary extraction plan and red-team

**Lane:** `build-sys` · **Date:** 2026-08-06 · **Status:** Q11 and Q16 are
self-contained, sealed, and restorable; their cheap paper compatibility bridges
are proved against the pinned finitegeom revision. The live human-area module
mapping must be refreshed whenever the paper or repository registries change;
paper-package integration follows that exact-current replay.

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
tree has seventeen paper-registry records, fifteen standalone-repository records, and
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
q11-certificates  --imports-->  Mathlib only
q16-certificates  --imports-->  Mathlib only
every other heavyweight certificate package  --imports-->  Mathlib only

Clebsch paper bridge  --imports-->  finitegeom + q11-certificates
Arcs paper bridge     --imports-->  finitegeom + q16-certificates
```

The paper bridges are separate cheap packages.  The finitegeom package does not
resolve, import, or pin a heavyweight certificate package.  A bridge imports a
certificate only when the corresponding paper claim uses it.  Editing finitegeom
therefore cannot schedule, resolve, or invalidate a certificate target.

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
  TavisRuddFiniteGeom.Certificates.Q11.Model,
  TavisRuddFiniteGeom.Certificates.Q11.BrianchonPetersen,
  and TavisRuddFiniteGeom.Certificates.Q11.PointOrbits.*
Clebsch paper bridge:
  the proved local-model compatibility adapter and theorem transport
finitegeom:
  Q11Coding semantic synthesis, decoder/rigidity/orientation layers,
  and the human Clebsch API
```

The Brianchon--Petersen module is a strict-kernel Q11 certificate, not foundation.  Its
current import by the orbit package is evidence that it belongs in the Q11 package.
The package's present Clebsch-wide gate is not a certificate-only gate: it imports
finitegeom human modules and must be split.  The Q11 package exposes only its orbit and
Brianchon terminals; the Clebsch paper aggregate remains downstream in finitegeom.

The Q11 compatibility bridge is green. It proves equality of the certificate and
human witness tables and canonical point enumerations, then exposes the frozen
two-generator terminal at the paper boundary. No heavyweight Q11 target is scheduled.

The completed bridge boundary is recorded in `lean/trust/paper-bridges.toml`.
The Clebsch bridge identifies the six witness vectors and all 133 normalized
projective representatives; the Arcs bridge gives a ring equivalence between the
two four-bit `GF(16)` implementations and identifies all 273 normalized projective
representatives. Both expose the corresponding frozen certificate terminal under
the paper namespace. `lean/scripts/lean-paper-bridge-audit.py` requires the exact
finitegeom and certificate commits, exact imports, clean dependency checkouts,
matching cache archives, and no finitegeom-to-certificate dependency.

`lean/scripts/lean-certificate-dependency-firewall.py` is the executable package
edge policy. Its Q11/Q16 checks are green after the self-contained rewrites. The
projective-cap Q11 and Q13 certificates are Mathlib-only and sealed. The separate q13
passant-code certificate remains paper-resident and imports the monorepo; it requires a
distinct Mathlib-only extraction and paper bridge. Q25 was retired because no adopted
paper or formal companion consumed it. The portfolio scan stays red only for a package
whose external fact, downstream adapter, or legacy-family removal is incomplete.

The Q16 seam is now established. The generated level, step-kernel, leaf, and rejection
checks are in the self-contained certificate package behind its local `Idx`/field
model. `Q16Reduction`, `Q16Result`, and the paper-wide human interface remain in
finitegeom; the separate Arcs paper bridge transports the generated rejection terminal
into that layer without a finitegeom-to-certificate edge.

The migrated reverse edges were bounded. The projective-cap Q11 and Q13 migration inputs
reached only `ProjectiveCap.CertCheck` and `ProjectiveCap.PlaneOutcome`; their generated
checks now use duplicated Mathlib-only local models, and outcome transport is downstream.
The q13 passant-code package has a different boundary: its paper-local `PassantCodeQ13`
certificate currently imports the monorepo `NodeKayles` library. Its extraction must first
classify the minimal semantic model and checker needed for its published finite terminals;
the existing projective-cap Q13 package is not an interchangeable substitute.

### Q13 passant-code execution boundary

The paper-local package contains 214 Lean modules. Fifty-four mention the human
`RelativeConicArcs` model, and eight import a human semantic module or gate directly.
The package therefore cannot be externalized by a namespace rewrite. Its target is a new
Mathlib-only `finitegeom-q13-passant-code-certificates` package with a local finite model
for the 78 indexed internal points, 78 passant rows, binary incidence vectors, the relation
matrices, and the fixed finite transport data. The package retains only finite checker/data
theorems and its strongest finite terminals. The human q13 geometry, code semantics,
projective-action theorems, and every theorem that translates indexed data into those
objects remain in finitegeom under `TavisRuddFiniteGeom.Papers.Q13PassantCode`.

Execution is deliberately one-way: first freeze and hash the current 214-module input;
then mechanically rebase the finite-only closure on the local model and make all residual
human references a hard failure. Next prove a cheap bridge from the local indexed model to
the human q13 semantics and transport the finite terminals. Only after the bridge is green
may the paper release verifier replace its direct `lean-certificates/` dependency. The
heavy package then builds once, seals its fact and pack, and is not rebuilt for later paper,
finitegeom, or bridge changes.

The former human and gate namespaces have now been moved to
`TavisRuddFiniteGeom.Papers.Q13PassantCode`; no Lean source remains under
`RelativeConicArcs.PassantCodeQ13`.  The extracted candidate freezes 224 input modules
(the 214 paper modules and ten finite-semantic modules), adds a local code kernel, and
renders 223 certificate modules under `TavisRuddFiniteGeom.Certificates.Q13PassantCode`.
Its static source-lock and forbidden-import checks pass.  The package aggregate has been
guardedly built, sealed, and packed at package commit `c808d7fca5fba9c17ac1f502d7d14115a9b10791`.
The certificate source boundary is now frozen.  The next operation is to export the remapped
human namespace into finitegeom, prove the downstream compatibility bridge, and switch the paper
to the bridge; none of those operations rebuilds the certificate package.

Their final certificate namespaces are
`TavisRuddFiniteGeom.Certificates.ProjectiveCap.Q11.*`,
`TavisRuddFiniteGeom.Certificates.ProjectiveCap.Q13.*`. The local statement models live
under the same branded certificate families. The downstream adapters prove type equivalences
and theorem transport into `TavisRuddFiniteGeom.Shared.Projective.*` or the owning
paper interface; the certificate packages import neither those shared modules nor a
separate project foundation. Legacy `ProjectiveCap.*`, `RelativeConicArcs.*`, and
`FiniteGeom.*` module paths are migration inputs, not final compatibility APIs.

Do not satisfy this boundary by copying the current project foundation into a
certificate package. `ProjectiveCap.CertCheck` currently closes over thirteen
project modules and `ProjectiveCap.PlaneOutcome` over nineteen; the latter includes
the cap game, affine-chart, parity, intrusion, and plane-transitivity layers. The
certificate-local extraction is only the data types, Boolean checker, and checker
soundness needed to state and validate the generated books. The plane-outcome and
game transport theorems belong exclusively in the downstream adapter.
Q11 and Q13 each own a byte-identical copy of that small stable kernel rather than
depending on a new certificate-foundation package; this deliberate duplication keeps
either frozen certificate independently restorable and prevents changes in one from
invalidating the other.

For both projective-cap packages the final local modules are `Model`, `Checker`, the
generated data family, and a certificate-only `Assembly`. The assembly boundary is
immediately before `TransportWitness`: anchored-class selection, class validity, and
the size-three classification remain certificate-local; transport witnesses,
odd-escape game statements, and projective initial-position theorems move downstream.
The frozen generated Lean is the migration input because the original q11/q13 `.cert`
inputs are not tracked and the q13 generator does not reproduce the current payload.
A hash-guarded transformer therefore performs this namespace-only migration; neither
package claims regeneration from the unavailable historical certificate input. Every
high-memory Q13 class is a separate guarded queue target: `LEAN_NUM_THREADS` and CPU
affinity do not themselves prevent Lake from overlapping sibling module processes.

Use explicit paper and shared source roots under the ecosystem namespace:

```text
finitegeom/
  TavisRuddFiniteGeom/
    Shared/
      Projective/  FiniteFields/  Coding/  Incidence/  Certificates/  PRS/
    Papers/
      ArcsCompleteOutsideConic/  Beyond4PRS/  AMELU/
      ClebschRigidity/  ClebschPassages/  ClebschFactorization/
      Q13PassantCode/  MDSCSSTransversalGroups/
      CompleteRepairPorts/  EquivariantRobustCompletion/
      ContinuationGraphRigidity/  DihedralSchreierNodeKayles/
      GoldenOperator/  GoldenQuantumStatistics/
```

Repository directories retain their exact lowercase paper aliases, but Lean source
paths and namespaces use PascalCase components under the ecosystem-unique top level
`TavisRuddFiniteGeom`, rather than bare `Paper.*`, `FiniteGeom.*`, or
`RelativeConicArcs.*`. The reorganization retires the legacy `RelativeConicArcs`
module and declaration namespace in bounded, reverse-closure-checked moves; it does
not preserve that namespace as the final public API. For example:

```text
TavisRuddFiniteGeom.Papers.Beyond4PRS.*
TavisRuddFiniteGeom.Papers.ArcsCompleteOutsideConic.*
TavisRuddFiniteGeom.Papers.AMELU.*
TavisRuddFiniteGeom.Shared.Projective.*
```

Heavyweight certificate packages are the deliberate exception to compatibility
preservation: their one-time cache migration retires every legacy module path and
declaration namespace.  All Q11 certificate source, generated leaves, terminals, and
verification modules use `TavisRuddFiniteGeom.Certificates.Q11.*`; Q16 uses
`TavisRuddFiniteGeom.Certificates.Q16.*`.  No `RelativeConicArcs` path, import,
namespace, declaration, generator output, manifest entry, or documented public name
may remain in either sealed package.  Compatibility aliases, when temporarily needed,
belong only in the cheap downstream paper bridge and must not be imported or exported
by a certificate package.

For human packages, the import direction is one-way: papers may import shared APIs;
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

The Q11 and Q16 repositories become frozen only after this migration.  Their complete
public surfaces use `TavisRuddFiniteGeom.Certificates.Q11.*` and
`TavisRuddFiniteGeom.Certificates.Q16.*`; mathematical certificate aggregates and
`Verification/AxiomAudit` replace operational gate names.  Each imports Mathlib only
and owns its local statement model.  A separate paper bridge proves compatibility and
transports its terminal into the human theorem.  After sealing, the certificate source
and compiled cache remain unchanged until an explicitly approved certificate-source
change requires a new artifact.

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

Do not create new paper or shared packages under legacy module paths. Each bounded
human-source family moves directly to its final `TavisRuddFiniteGeom.Papers.*` or
`TavisRuddFiniteGeom.Shared.*` source path and namespace, with its complete reverse
closure and downstream synchronization in the same chunk. This avoids institutionalizing
an intermediate `RelativeConicArcs` API and avoids building a newly extracted package
twice. It does not authorize a repository-wide rename: each family still has its own
declaration review and exact affected-interface gate. Shared families expose a
`PaperInterface` only when they genuinely have a reviewer-facing public surface.
Q11 and Q16 remain the strictest case: their complete branded namespace migrations
precede their single expensive rebuilds, and no later human-layer edit can reach them.

Final source roots therefore look like:

```text
TavisRuddFiniteGeom/Papers/Beyond4PRS/PRSFoundation.lean
TavisRuddFiniteGeom/Papers/ArcsCompleteOutsideConic/...
TavisRuddFiniteGeom/Shared/...
```

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
   heavy leaf remains in finitegeom, or while the corresponding cheap paper bridge
   lacks an exact frozen certificate pin and proved adapter.  Add the
   dependency-direction checker and adversarial fixtures
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
5. Establish the self-contained, fully branded Q11 local model, mathematical
   certificate aggregate, verification audit, and downstream compatibility adapter;
   remove every legacy path and name; then perform its one-time
   explicitly approved cache migration.  Prove that a disposable finitegeom human
   edit schedules zero Q11 targets before beginning any paper split.  Repeat for Q16
   only after completing the same namespace, prose, generator, manifest, and
   dependency audit.
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
    shared libraries and paper source into separately pinned Lake packages. Move each
    bounded family directly to its final `TavisRuddFiniteGeom` public module names;
    Q11/Q16 certificate namespace cleanup is already complete at this point.

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
  → cheap paper bridge pins the certificate and exported finitegeom revisions
  → affected paper pin and release metadata

human/shared authority in the monorepo
  → finitegeom through its exporter
  → cheap paper bridge pin or compatibility update
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
| C879.0 | Regenerate the live module map and add the package-DAG firewall. | Parser/unit tests plus adversarial reverse-edge and missing-adapter fixtures; accept only the required certificate DAG. |
| C879.1 | Spike the self-contained Q11 local model and proved downstream adapter. | Build only the Mathlib-only model and cheap adapter; inspect their exact imports. |
| C879.2 | Commit the declaration-level Q11 ownership manifest and certificate-only gate design. | Exact import/use report; reject human or paper imports from the certificate package. |
| C879.3 | Move the local Q11 coordinate model and Brianchon--Petersen certificate into the Q11 package; complete the `TavisRuddFiniteGeom.Certificates.Q11` rename and whole-artifact prose audit. | Cheap source-layer elaboration only; no heavyweight fallback; static scan finds no legacy path or namespace. |
| C879.4 | Put the compatibility theorem in a separate Clebsch paper bridge and remove every certificate-to-project edge. | DAG/import firewall and dry-run affected-target regression; finitegeom resolves no Q11 package; no source build yet. |
| C879.5 | Perform the one-time explicitly approved Q11 certificate rebuild and publish its exact cache. | Measured heavy gate, trust fact, sealed manifest, cache restore replay, exporter-only finitegeom adoption. |
| C879.6 | Prove the Q11 rebuild firewall, then complete the fully audited Q16 migration and its single approved rebuild. | Disposable cheap finitegeom edit schedules zero Q11 targets; Q16 has no legacy namespace or project dependency before its build; missing caches refuse source fallback. |
| C879.7 | Validate the beyond-four PRS `PaperInterface` and its axiom audit. | Guarded exact-target build and paper checker; commit the validation record. |
| C879.8 | Move and rename one paper-facing PRS interface/wrapper family directly into its final paper namespace, without moving PRS-family infrastructure. | Exact reverse-closure check, smallest affected `PaperInterface`, guarded downstream export, and affected-paper replay; commit only when every tree is synchronized. |
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

No human-source move may leave a newly extracted family under `RelativeConicArcs`.
The namespace change is part of that family's bounded move, reverse-closure calculation,
and exact target; shared-library movement remains a separate ownership decision. The
Q11/Q16 certificate migrations apply the same final-namespace rule before their single
approved rebuilds.

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
- Each certificate package exposes `nix run .#verify` as a read-only check/build
  entry point.  Source generation is a separate `nix run .#regenerate` operation;
  verification must never invoke it or modify tracked certificate sources.
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
- A simultaneous path move and namespace rewrite can turn a small human-source
  extraction into a repository-wide rebuild. Preserve human module names in the first
  split. Q11/Q16 deliberately absorb their complete rename into the already-required
  one-time certificate rebuild.
- A full repository build can hide whether the changed paper closure is actually
  bounded. Require the exact affected-gate list before every validation build.
- Starting with arcs or AME--LU would repeatedly disturb shared foundations. Use a
  small leaf pilot and freeze upstream public APIs before downstream extraction.
- The phrase “one-way dependency” is directionally ambiguous. Every policy, manifest,
  and report must spell out `paper bridges import finitegeom plus q11/q16`,
  `finitegeom imports neither certificate package`, and `q11/q16 import Mathlib only`; the executable DAG
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

It passes against the current registries and human-source tree. Refresh the committed
mapping whenever those inputs change. The preflight rejects paper/repository/export
inventory drift, changed gate closures, missing mapped sources or roots, duplicate
target names, unresolved aliases, AME--LU coverage gaps, and Lean-tree drift from the
mapping's immutable authority commit.  Passing this preflight certifies the planning
snapshot, not declaration-level ownership or a build.

## Scope boundary

This record authorizes the complete Q11 and Q16 local-model, branded-namespace,
certificate-aggregate, verification, and paper-bridge migrations, including one
expensive guarded source build of each after its full pre-build audit. It does not
authorize publication, mirror writes, history rewrites, or any later certificate
rebuild.
