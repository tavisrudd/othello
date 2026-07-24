# C287 shared Lean fresh-history extraction plan

**Lane**: `build-sys`
**Status**: QUEUED; planning complete, execution not authorized
**Requested destination**: `~/src/papers/lean`

## Outcome and boundary

Create a separately maintained, fresh-history Lean source repository at
`~/src/lean/finitegeom`, intended for `github.com/tavisrudd/finitegeom`, and separately maintained
certificate packages for heavyweight generated closures. The first packages are staged at
`~/src/lean/finitegeom-q16-certificates` and
`~/src/lean/finitegeom-q25-certificates`. These are state exports, not publications, forks,
subtrees, or history-filtered copies of the private monorepo, and they are not per-paper Lean
bundles. Each paper records exact repository commit pins, exact public target lists, public proof
ledger entries, and artifact provenance.

The shared repository evolves through reviewed, incrementally tagged commits. The first tag is the
exact `FiniteGeom` + mirror closure required by the first release set; later tags add the exact
closures of further papers. C287 owns manifests, extraction, builds, axiom audits, clean-checkout
validation, and artifact portability. C270 owns public repository identity, metadata,
release/DOI/OEIS coordination, and any eventual user-authorized remote action. C287 does not create
remotes, publish, or push; C270 does not copy sources or run builds.

Each tag's export unit is the reviewed union of the paper-facing import closures admitted by that
tag. It is never the private `lean/` directory. The repository may grow only by a new reviewed
manifest and green aggregate closure. For `complete-ports`, the logical requests are `RepairCodes`
and `RepairPorts.FunctionalCost`; C287 must replace those names with exact public module closures
and aggregate gates before those sources are copied.

Heavyweight generated certificate trees are not members of the `finitegeom` source union. Each
such family has an explicit package boundary, depends one-way on a pinned `finitegeom` commit, and
owns its generators, schemas, generated leaves, terminal theorems, trust manifest, and
reproducibility metadata. `finitegeom` never imports a certificate package; a paper-facing
aggregate that needs certificates pins and imports both packages above that one-way boundary.

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

### 2. Stage the fresh source tree

- Export only the reviewed manifest into the new disk-backed destination; do not broadly copy the
  private tree.
- Author public README, target/gate map, proof ledger, and provenance documentation without private
  C-task references or host paths.
- Compare the complete staged regular-file set with the manifest and scan staged bytes for private
  paths, credentials, internal hostnames, and monorepo-only references.
- Initialize fresh Git history only after the source set and rewrites pass review. Attaching a
  remote and pushing remain separate user-authorized actions.

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
