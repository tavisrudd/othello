# Export and mirror conventions: papers and Lean

This guide is the routed reference for moving validated work out of the
monorepo into its public downstream trees. Read it completely before touching
any repository under `~/src/lean/` or `~/src/math-papers/`, before any
companion export, certificate-package re-pin, or standalone paper
synchronization.

## Edit authorities and tree roles

Shared-library and paper editing happens in the monorepo:

- **Shared Lean sources:** `~/src/othello/lean/` is the authority for the
  human-scale library and semantic APIs consumed by certificate packages.
  Follow `lean/AGENTS.md` for every edit, build, or generator run.
- **Paper sources:** `~/src/othello/papers/<paper>/` is the only tree where
  manuscript, verification-script, and manifest edits happen.

Certificate-only source is the narrow exception.  Once a certificate package
has passed a byte-for-byte provenance migration, its repository under
`~/src/lean/finitegeom-*` is the authority for its generated leaves,
package-private checker composition, aggregate certificate gate, and generator.
Those files must not also exist in the monorepo or `finitegeom`.  The package
depends one-way on a pinned `finitegeom` commit and exposes only its audited
terminal gate; shared definitions and reusable reductions remain monorepo-owned.

Everything else downstream is a tooled export target, written only by the guarded
tools named below and only as ordinary forward commits:

- `~/src/lean/finitegeom` — the canonical exported Lean base library. Its
  content changes only by adopting a companion-export delta.
- `~/src/lean/finitegeom-*` — certificate/companion packages depending on the
  base by public Git URL and pinned revision. Package-private certificate
  sources change in their owning repository; base pins, copied shared gates,
  axiom audits, and seals change only by the re-pin sequence below.
- `~/src/math-papers/<paper-repo>` — standalone paper mirrors with
  independent histories. Their content changes only by
  `papers/scripts/export-paper-repos.py sync`.

Do not create ad hoc clones, worktrees, scratch checkouts, or candidate trees
inside `~/src/lean/` or `~/src/math-papers/`. Exporter candidate trees belong
in disk-backed cache directories (for example
`~/.cache/othello-lean-build/companion-export/`), and stray copies of these
repositories anywhere else are not authorities for anything. Never push any of
these repositories; publishing is the author's decision. Synchronization of
shared sources and papers is one-way, monorepo to downstream: edit and validate
here first, then export. Certificate-package authority is also one-way:
package-private sources never flow back into the monorepo or base. A mirror is
never merged back.

## Paper export to `~/src/math-papers/`

Tool: `papers/scripts/export-paper-repos.py` (plan / audit / materialize /
sync / verify). Registry: `papers/repositories.toml` maps each paper root to
its repository name, exclusions, rewrites, and disposition;
`lean/trust/papers.toml` supplies paper identities.

Properties that shape the workflow:

- Every subcommand reads from an **immutable committed tree**
  (`--source-ref`, typically `HEAD`), never the worktree. Commit the
  authority first, including rebuilt PDFs.
- `materialize` writes a new repository only into an absent path; `sync`
  refreshes an existing **clean** mirror and refuses path deletions and
  README/Zenodo metadata loss unless explicitly acknowledged.
- `plan` and `audit` scan the exported blobs for private-repository coupling:
  task/lane IDs in file names or content, internal process files, private
  paths. **`sync` and `materialize` hard-refuse while any finding is
  unresolved.** The fix is renaming or cleaning the offending files in the
  authority (a coordinated change across manifests, verifiers, README, and
  manuscript prose), not masking the scan.
- `verify` checks a mirror's tracked tree against its export manifest.

Sequence for an ordinary refresh:

```sh
cd ~/src/othello
python3 papers/scripts/export-paper-repos.py plan  --source-ref HEAD
python3 papers/scripts/export-paper-repos.py audit --source-ref HEAD --repository <name>
python3 papers/scripts/export-paper-repos.py sync  --source-ref HEAD \
  --repository <name> --root ~/src/math-papers/<name>
```

After a sync, replay the paper's own release gate inside the mirror (its
verification README gives the command; supply the pinned Lean package
checkout where required) and require agreement with the authority's release
identity before the result is called synchronized. Agreement means the
recorded hashes match, including the canonical release-surface hash, not
merely that the mirror's gate passes.

Two refusals have no tool-side workaround and must be resolved deliberately:

- **Renames read as deletions.** `sync` refuses to remove tracked mirror
  paths, and a rename in the authority leaves the old names orphaned
  downstream. Reconcile them in the mirror with an explicit `git rm` commit
  made *before* the sync, so the removal is separately reviewable in the
  mirror's history rather than buried inside a content refresh. Never delete
  mirror files as a side effect of a sync, and never add exclusions or
  rewrites to `papers/repositories.toml` to make a refusal disappear.
- **Mirror-only files drift.** Anything tracked downstream but absent from
  the authority blocks every future sync and silently rots — a pin manifest
  left only in a mirror will keep naming superseded commits. The fix is to
  move the file into the authority so the exporter carries it, not to delete
  it downstream. Keep every pin that describes the paper's formal companions
  in the authority for this reason.

## Lean export for a paper: base library, certificate package, release chain

This is the full chain that takes a validated Lean change from the authority
tree to a paper's pinned public formal artifact. Stop at any guarded refusal;
never hand-compose a replacement step.

### 1. Validate in the authority

Edit under `lean/RelativeConicArcs/...`, elaborate through the guarded entry
points, rebuild the owning aggregate gate, and refresh the tracked axiom
audit from the gate elaboration's standard output, all per `lean/AGENTS.md`.

### 2. Extract the trust fact

The companion exporter consumes a generated fact for the export gate:

```sh
python3 lean/scripts/lean-trust-extract.py plan --area <area>
python3 lean/scripts/lean-trust-extract.py run --unit <Gate.Module>
```

Extraction needs a quiet Lean worktree (foreign modified paths block it) and
the owning build window. Commit the generated
`lean/trust/facts/<gate>.json` — the exporter reads the registry
(`lean/trust/areas/*.toml`) and the fact from the source **commit**, not the
worktree.

### 3. Companion-export onto the base library

```sh
python3 lean/scripts/lean-companion-export.py \
  --config lean/trust/export/<area>.toml \
  --source-commit <othello-commit> --base-commit <finitegeom-commit> plan
python3 lean/scripts/lean-companion-export.py ... run --workdir <disk-backed-dir>
```

`run` materializes the candidate twice, requires byte-identical repeats, and
verifies module identity, manifest completeness, and terminal/axiom-audit
agreement. Re-exporting an area the base already adopted is supported: the
configured README bullet is inserted only when it is absent, so a README that
needs no other change simply drops out of the delta. The forward-delta gate enforces **containment**: every changed
path must be planned, while planned files whose bytes the base already
carries are reported as unchanged rather than refused. Copy the printed delta
into `~/src/lean/finitegeom` with no hand edits, validate the export gate
there through the guarded runner (`--lean-root`/`--root` select the base
package), and adopt it as one ordinary forward commit. Publishing that base
revision is the author's decision, and every downstream package resolves the
base from the public remote — nothing below can run until the base commit is
on `origin/main`.

### 4. Re-pin the certificate package

In the package checkout (for example
`~/src/lean/finitegeom-clebsch-q11-certificates`), after the base is
published:

1. Update the base revision in `lakefile.toml` (`rev`) and
   `lake-manifest.json` (`rev` **and** `inputRev`), plus any README pin.
2. Copy the authority's aggregate gate module in byte-identically.
3. Rebuild the gate through the guarded queue against the package root:
   `lean/scripts/lean-build-queue.py run <Gate> --lean-root <package> ...`.
4. Refresh the tracked axiom audit. The convention is a byte-identical copy
   of the authority gate elaboration's standard output; corroborate it
   against the package build's own log (stripping Lake's `info:` prefixes
   must reproduce the audit exactly).
5. Reseal `MANIFEST.json` in two commits so `source_commit` is
   self-consistent: first commit every source change, then regenerate the
   manifest — dependency commit, per-module digests, generator digest,
   `source_commit` naming the sources commit — and seal it as a second
   commit that touches only `MANIFEST.json`.

### 5. Run the paper's release chain

In the paper root, per its `verification/README.md`:

1. Update the manuscript's pin block (package commit, base commit, gate
   digest) and the pinned commits in `verification/build_trust_manifest.py`.
2. Regenerate the statement identity and the trust manifest (set
   `CLEBSCH_LEAN_ROOT`-style variables to the package checkout as the README
   directs).
3. **Refresh the tracked PDFs** through the paper's own manuscript checker in
   update mode (for Paper I,
   `nix develop --command python3 verification/check_manuscript_build.py --update`)
   and visually inspect the changed pages. Do not build by hand: that checker
   pins `SOURCE_DATE_EPOCH` to make the build byte-reproducible and then
   requires the tracked PDF to equal a fresh build exactly, so a hand build
   without the pinned epoch is rejected. That equality is what detects a stale
   tracked PDF — a paper whose gate lacks it will certify a manuscript edit
   whose PDF was never rebuilt.
4. Commit the clean release surface, run the aggregate release verifier with
   `--update-output`, rerun the trust-manifest builder to record the new
   certificate hash, commit, and finish with the clean-source release run.

### 6. Synchronize the standalone paper mirror

Only after the authority chain is green, export with
`export-paper-repos.py sync` as above and replay the release gate in the
mirror.
