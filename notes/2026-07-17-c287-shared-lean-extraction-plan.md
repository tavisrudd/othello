# C287 shared Lean fresh-history extraction plan

**Lane**: `build-sys`
**Status**: IN PROGRESS; first-tag rewrite and trust facts pending; later-paper intake refreshed,
with source export deferred until AME--LU C602
**Local root**: `~/src/lean/`

## Outcome and boundary

Create a separately maintained, fresh-history Lean source repository at
`~/src/lean/finitegeom`, intended for `github.com/tavisrudd/finitegeom`, and separately maintained
certificate packages for heavyweight generated closures. The first packages are staged at
`~/src/lean/finitegeom-q16-certificates` and
`~/src/lean/finitegeom-q25-certificates`; the ProjectiveCap Q11 and Q13 data are staged separately
at `~/src/lean/finitegeom-projective-cap-q11-certificates` and
`~/src/lean/finitegeom-projective-cap-q13-certificates`. These are state exports, not publications,
forks, subtrees, or history-filtered copies of the private monorepo, and they are not per-paper Lean
bundles. Each paper records exact repository commit pins, exact public target lists, public proof
ledger entries, and artifact provenance.

The shared repository evolves through reviewed, incrementally tagged commits. The first tag is the
exact closure of the human-scale terminals cited by the first manuscript; later tags add the
hyperbolic-quadric result, the `FiniteGeom` umbrella, and further paper-facing closures only when an
explicit public claim contract requires them. C287 owns manifests, extraction, builds, axiom audits, clean-checkout
validation, and artifact portability. C270 owns public repository identity, metadata,
release/DOI/OEIS coordination, and any eventual user-authorized remote action. C287 does not create
remotes, publish, or push; C270 does not copy sources or run builds.

## Current local state — 2026-07-25

The following `main`-branch Git workspaces exist:

- `~/src/lean/finitegeom`
- `~/src/lean/finitegeom-q16-certificates`
- `~/src/lean/finitegeom-q25-certificates`
- `~/src/lean/finitegeom-projective-cap-q11-certificates`
- `~/src/lean/finitegeom-projective-cap-q13-certificates`

Each has no commit and no remote. Exactly `.gitignore`, `flake.nix`, `flake.lock`, and
`lean-toolchain` are staged. The toolchain matches the private source tree at
`leanprover/lean4:v4.32.0-rc1`; the lockfiles pin nixpkgs
`e2587caef70cea85dd97d7daab492899902dbf5d`. All five pass
`nix flake check --no-build`. The flakes currently expose development shells only: no Lean source,
Lake configuration, package dependency, build target, or flake check has been exported.

No Lean or Lake command was run for this staging, and no active private-tree Lean run was inspected,
stopped, restarted, or otherwise interrupted. Do not create an initial commit until the reviewed
source manifest and public rewrites for that workspace are staged together.

Certificate payload gates remain open:

- C318 must define the Q25 trust surface.
- C319 must decide verified canonicalizer versus reduction plus reproducible computation before the
  Q25 payload shape is frozen.
- C324 must complete clean pinned-toolchain regeneration before C287 copies frozen artifacts.
- The Q16 generated families are currently recorded as `legacy-unverified` in
  `lean/trust/PORTFOLIO.md`; staging a workspace does not promote that trust status.
- ProjectiveCap Q11/Q13 need exact generator, checker, terminal, and gate classification before
  their manifests are admitted.

The next safe work while private-tree Lean runs remain active is read-only manifest design and
dependency classification. Source export, regeneration, elaboration, and builds wait for their
documented gates and a confirmed quiet build-owner window.

The candidate first-tag contract is now content-addressed in
`notes/2026-07-23-finitegeom-first-tag-source-inventory.json` and analyzed in
`notes/2026-07-23-c287-first-tag-source-contract.md`. Its four declared roots resolve to 26 Lean
files and 8,954 code lines, with 18 external imports all supplied by Mathlib and no heavyweight
certificate-family source. The first whole-closure referee pass showed that the earlier seven-file
workflow-residue scan was too narrow. At least 17 modules need source-owner prose work, two public
path/name families need API decisions, and the closure still needs a semantic scholarly-public
docstring review before export. The failed gate is recorded in
`notes/2026-07-24-c287-first-tag-referee-review.md`; the source-owner dispatch contract and
deletion-first API recommendations are in
`notes/2026-07-24-c287-source-owner-rewrite-packet.md`.
The user approved recommendations A1 and B1 on 2026-07-24. C553 in the `cap` lane owns the
17-module source rewrite, deletion of the two wrapper modules, consumer migration, and semantic
docstring pass; C287 resumes with regenerated inventory and trust-spine audits after that commit.

The theorem-level audit in `notes/2026-07-23-c287-first-tag-theorem-ledger.md` shows that the adopted
human manuscript terminals need 26 files / 8,954 code lines; the advertised but uncited
hyperbolic-quadric result adds one file; and the `FiniteGeom` umbrella contributes a completely
disjoint 24-file component with no first-release terminal declaration. Reviewer-facing policy
selects the 26-file boundary and defers both additions. The ledger also records the missing final
sum-free terminal and the still-unverified external Q11/Q13 assembly terminals.
C270 must align the older public-planning wording with this reviewer-scale boundary before release;
C287 does not edit that lane's metadata or perform the public action.

The existing C326 trust spine now owns the machine-readable gate and terminal contract:
`lean/trust/areas/finitegeom_first_tag.toml` declares the exact 26 modules, four extraction units,
seven terminals, and expected standard axiom sets. `lean/trust/FIRST_TAG.md` is the public prose
manifest. The area-filtered audit has exactly four `facts-missing` findings and no structural
finding; extraction planning resolves all units but refuses the current seven-foreign-path
worktree. Report: `notes/2026-07-24-c287-first-tag-trust-spine.md`.

Each tag's export unit is the reviewed union of the paper-facing import closures admitted by that
tag. It is never the private `lean/` directory. The repository may grow only by a new reviewed
manifest and green aggregate closure. For `complete-ports`, the logical requests are `RepairCodes`
and `RepairPorts.FunctionalCost`; C287 must replace those names with exact public module closures
and aggregate gates before those sources are copied.

Later paper-bound intake now has three locally ready source-owner boundaries and one remaining
paper gate:

- arcs: `RelativeConicArcs.Gates.Relconic`, with thirteen audited terminals;
- PRS: the C545 R5--R7 six-gate contract, exactly fifteen project-owned files and 53 ordered audit
  targets;
- Clebsch Paper I: the current nineteen-row manifest, 24 unique Lean terminals, and
  `RelativeConicArcs.Gates.ClebschRigidityTrust`, pinned by the manifest to finitegeom commit
  `6d4766d1ea5e9a36f1a507e549c223416a6b506f`;
- AME--LU: C601 is complete, while C612, C613, and the final C602 whole-closure audit remain.

The older intake assumptions are superseded: C544's 103-terminal PRS scope is not the adopted
paper closure; the older Clebsch `bf4fb39a...` pin is not the current manifest pin; and C570's
six-party AME--LU aggregate is not the final all-`m >= 2` manuscript boundary. Exact roots,
exclusions, and evidence boundaries are recorded in
`notes/2026-07-24-c287-new-paper-export-intake.md`.

Per the 2026-07-25 user gate, no source export occurs before AME--LU C602 freezes its aggregate.
The three ready closures retain their exact root ledger, but provisional manifests are deferred to
avoid recomputation. C553 remains an independent precondition and may land before C602. Once both
are complete, inventory regeneration, whole-closure review, fresh-history copy, builds, axiom
extraction, and clean replay form one coordinated execution wave. These later closures do not
enlarge the frozen 26-file first tag; each enters through a separate incremental tag contract, and
shared files are deduplicated by content rather than by a portfolio umbrella.

### Token-efficient execution route

The authoritative low-context route is
`notes/2026-07-25-c287-token-efficient-execution.md`. It uses exactly three lane sessions:
C612--C613--C602 continuously in `ame-lu`, C553 in `cap`, then one coordinated C287 extraction in
`build-sys`. The extraction computes one content-addressed union, reviews each unique source hash
once, preserves separate paper manifests and gates, and validates all aggregates in one quiet
build-owner window. It explicitly defers provisional pre-C602 manifests, C581, companion-paper
closures, and certificate packages not required by an adopted paper contract.

Heavyweight generated certificate trees are not members of the `finitegeom` source union. Each
such family has an explicit package boundary, depends one-way on a pinned `finitegeom` commit, and
owns its generators, schemas, generated leaves, terminal theorems, trust manifest, and
reproducibility metadata. `finitegeom` never imports a certificate package; a paper-facing
aggregate that needs certificates pins and imports both packages above that one-way boundary.
There is no universal certificate umbrella. A paper export declares only the certificate packages
used by its adopted theorem set; an unused package must be absent from its flake inputs, lock graph,
source fetches, build closure, and validation targets.

## Reviewer-facing size gate

The 2026-07-23 `tokei ../lean/` baseline is 13,198 Lean files and 1,858,312 Lean code lines. Q16,
Q25, and `ProjectiveCap/CertData` account for nearly all of that scale. Excluding those generated
families leaves 438 Lean files and 63,861 code lines across the entire current Lean portfolio. The
first-tag `FiniteGeom` + ProjectiveCap + CapGame upper bound, excluding `ProjectiveCap/CertData`, is
74 Lean files and 17,688 code lines before exact closure reduction.

- The first `finitegeom` tag must remain at most 100 Lean files and 25,000 Lean code lines.
- The initial reviewed union of currently planned human-scale closures must remain at most 500 Lean
  files and 75,000 Lean code lines.
- A generated or certificate family exceeding 100 files or 10,000 code lines is external by
  default. Keeping one in `finitegeom` requires an explicit reviewed exception.
- Every tag records `tokei` file/code/comment/blank counts and the delta from the preceding tag.
  Exceeding a budget stops the export for repartitioning or explicit user approval.

## Preconditions

1. Select the `build-sys` lane and read its live handoff, then read `lean/AGENTS.md` before any Lean
   edit, generator, build, staleness probe, process intervention, or export operation.
2. The approved main identity is `github.com/tavisrudd/finitegeom`, with the local workspace at
   `~/src/lean/finitegeom`; resolve its visibility and license before publication. The paper
   decision `tavisrudd/complete-ports` plus MIT does not implicitly decide the shared Lean
   repository's license.
3. Confirm that every local destination under `~/src/lean/` is new and empty before its first
   export. Do not attach a remote during planning.
4. Coordinate with C270 and the build-system owner. C270 supplies the approved public identity and
   release metadata; it does not define or copy the source closure. Do not duplicate or bypass an
   already reviewed public module boundary.

## Execution phases

### 1. Freeze the first-tag source contract

- Collect the first release set's declared logical Lean targets and compute their exact
  reverse-complete source closures with the build-system-owned import tooling. Record deferred
  paper closures explicitly; do not include them merely because the repository will eventually
  need them.
- Review the union plus explicit infrastructure additions: `lean-toolchain`, Lake configuration,
  guarded public build wrappers, license, README, target manifest, and proof/provenance schema.
- Classify every candidate as exact source copy, public rewrite, generated metadata, or exclusion.
  Classify heavyweight generated closures as external certificate-package inputs, never as main
  repository copies.
  Fail on symlinks, path traversal, missing inputs, duplicate destinations, private paths, or
  undeclared files.
- Record canonical source paths, destination paths, SHA-256 hashes, and byte counts in a tracked
  manifest. Private handoffs, notes, caches, logs, credentials, and build products are excluded.
- Record `tokei` counts for the reviewed main closure and each external certificate family; fail the
  main export when the reviewer-facing size gate is exceeded.

### 2. Stage the fresh source tree

- Export only the reviewed manifest into the new disk-backed destination; do not broadly copy the
  private tree.
- Author public README, target/gate map, proof ledger, and provenance documentation without private
  C-task references or host paths.
- Compare the complete staged regular-file set with the manifest and scan staged bytes for private
  paths, credentials, internal hostnames, and monorepo-only references.
- The empty workspaces may remain Git-initialized, but create each root commit only after its source
  set and rewrites pass review. Attaching a remote and pushing remain separate user-authorized
  actions.

### 3. Validate public sources

- Build the exact public aggregate gates through the unattended build queue under the shared
  build-owner lock and prescribed resource controls.
- Run the lane-required exact-target freshness confirmations and axiom audits for every exported
  paper-facing terminal.
- Verify that a clean checkout of the fresh source commit can reproduce the declared gates without
  access to private paths or undeclared inputs.

### 4. Prove artifact portability

- Freeze the validated source commit, toolchain, Lake configuration, and target list.
- Create any compiled artifact only with the guarded `lean-build-queue.py pack` path into a new
  disk-backed destination. Never copy `.lake`, raw build trees, or selected `.olean` files.
- Record the pack SHA-256, byte count, producing command, source/config/toolchain hashes, and exact
  target gates outside Git or as a release artifact.
- Restore into a separate disk-backed clean checkout, then require content traces and exact-target
  `lake build --no-build` confirmation. If identity or restore semantics fail, discard cache reuse
  and schedule a guarded rebuild.

### 5. Bind papers to the shared repository

- Give each paper reviewed pins for `finitegeom` and every required certificate package, an exact
  target list, public proof ledger entries, and artifact provenance checksums.
- Give every paper export directory its own tracked `flake.nix` and `flake.lock`. Its development
  shell and verification entry point must resolve the exact pinned `finitegeom`, certificate
  package, Lean toolchain, and system dependencies without machine-local paths.
- Check the flake input and lock graphs against the paper's adopted theorem manifest. Reject an
  undeclared or unused certificate package rather than accepting the reproducibility cost of a
  portfolio-wide aggregate.
- Keep all Lean sources and compiled artifacts out of individual paper repositories.
- Release a paper only after its pinned commit and target gates pass independently in the public
  layout.

### 6. Add later paper closures

- Start from the last validated public tag and a new reviewed closure manifest.
- Add only the newly admitted exact sources and required public rewrites; re-run the full aggregate
  clean-checkout and axiom gates for the enlarged repository.
- Mint a new tag only after portability passes. Existing paper repositories keep their old exact
  pins unless they deliberately adopt the new tag and repeat their public gates.

## Completion evidence

C287 closes only with reviewed source and external-package manifests, fresh-history source commits,
an exact public gate map, per-paper locked Nix environments, clean-checkout validation, axiom
audits, artifact pack manifests, independent restore/no-build checks, and a documented failure
boundary. The user authorized local workspace creation and fresh-state export under `~/src/lean/`;
builds, packing, remotes, publication, and push remain separately gated.
