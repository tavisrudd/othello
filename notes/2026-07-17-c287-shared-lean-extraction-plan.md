# C287 shared Lean fresh-history extraction plan

**Lane**: `build-sys`
**Status**: QUEUED; planning complete, execution not authorized
**Requested destination**: `~/src/papers/lean`

## Outcome and boundary

Create one separately maintained, fresh-history Lean repository shared by all public paper
repositories. It is not a publication, fork, subtree, or history-filtered copy of the private
monorepo, and it is not a per-paper Lean bundle. Each paper records only a shared-repository commit
pin, exact public target list, public proof ledger, and artifact provenance.

The export unit is the reviewed union of paper-facing import closures. It is never the private
`lean/` directory. For `complete-ports`, the initial logical requests are `RepairCodes` and
`RepairPorts.FunctionalCost`; C287 must replace those names with exact public module closures and
aggregate gates before any source is copied.

## Preconditions

1. Select the `build-sys` lane and read its live handoff, then read `lean/AGENTS.md` before any Lean
   edit, generator, build, staleness probe, process intervention, or export operation.
2. Resolve the shared repository's public host/remote, visibility, and license. The paper decision
   `tavisrudd/complete-ports` plus MIT does not implicitly decide the shared Lean repository's
   identity or license.
3. Confirm that `~/src/papers/lean` is new and empty. Do not initialize Git, copy files, or attach a
   remote during planning.
4. Coordinate with the existing public-`FiniteGeom` extraction work and the build-system owner.
   Do not duplicate or bypass an already reviewed public module boundary.

## Execution phases

### 1. Freeze the source contract

- Collect each paper's declared logical Lean targets and compute their exact reverse-complete
  source closures with the build-system-owned import tooling.
- Review the union plus explicit infrastructure additions: `lean-toolchain`, Lake configuration,
  guarded public build wrappers, license, README, target manifest, and proof/provenance schema.
- Classify every candidate as exact source copy, public rewrite, generated metadata, or exclusion.
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

- Give each paper a reviewed shared-Lean commit pin, exact target list, public proof ledger entry,
  and artifact provenance checksum.
- Keep all Lean sources and compiled artifacts out of individual paper repositories.
- Release a paper only after its pinned commit and target gates pass independently in the public
  layout.

## Completion evidence

C287 closes only with a reviewed source manifest, fresh-history source commit, exact public gate
map, clean-checkout validation, axiom audit, artifact pack manifest, independent restore/no-build
check, and a documented failure boundary. Planning this sequence does not authorize repository
creation, copying, building, packing, publication, or push.

