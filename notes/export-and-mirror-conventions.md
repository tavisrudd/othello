# Export and mirror conventions: papers and Lean

This guide is the routed reference for moving validated work out of the
monorepo into its public downstream trees. Read it completely before touching
any repository under `~/src/lean/` or `~/src/math-papers/`, before any
area export, certificate-package migration, paper-bridge re-pin, or standalone paper
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
Those files must not also exist in the monorepo or `finitegeom`. Every heavyweight
certificate package imports Mathlib only, owns the frozen local model needed to state
its terminal, and exposes an audited mathematical certificate aggregate. A cheap
paper bridge imports both the certificate and the human finitegeom API, proves their
compatibility, and transports the terminal. Neither finitegeom nor a certificate
package imports the other. Shared definitions and reusable reductions remain
monorepo-owned.

Everything else downstream is a tooled export target, written only by the guarded
tools named below and only as ordinary forward commits:

- `~/src/lean/finitegeom` — the finitegeom repository, holding the exported
  shared Lean library. Its content changes only by adopting an area-export delta.
- `~/src/lean/finitegeom-*` — Mathlib-only certificate packages and cheap paper
  bridges. Package-private certificate sources change in their owning repository;
  paper bridges pin the certificate and finitegeom revisions they compare.
- `~/src/math-papers/<paper-repo>` — standalone paper mirrors with
  independent histories. Their content changes only by
  `papers/scripts/export-paper-repos.py sync`.

Before the first export of a new paper, add its `.zenodo.json` to the
authoritative paper root and include it in the committed source tree used by
the exporter.  This is a mandatory part of first-export preparation, even when
no Zenodo deposit has yet been created.

A public Lean repository README is solely for external reviewers: mathematical
scope, trust boundary, verification command, citation, and license. It does not
describe synchronization, internal repository roles, publication gates, or DOI
version workflow, and it does not call a repository a “mirror” or an “authority.”

Do not create ad hoc clones, worktrees, scratch checkouts, or candidate trees
inside `~/src/lean/` or `~/src/math-papers/`. Exporter candidate trees belong
in disk-backed cache directories (for example
`~/.cache/othello-lean-build/area-export/`), and stray copies of these
repositories anywhere else are not authorities for anything. Never push any of
these repositories; publishing is the author's decision. Synchronization of
shared sources and papers is one-way, monorepo to downstream: edit and validate
here first, then export. Certificate-package authority is also one-way:
package-private sources never flow back into the monorepo or finitegeom. A mirror is
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
  it downstream. Keep every pin that describes the paper's formal artifacts
  in the authority for this reason.

## The portfolio summary

`papers/summary/` is the authority for the public portfolio summary published at
`~/src/math-papers/math-papers-summary`. Edit it there and nowhere else; the
mirror is downstream like any other.

It is **not** carried by `export-paper-repos.py`. The registry requires every
repository to claim at least one paper id from `lean/trust/papers.toml`, with
the id's registered directory equal to the repository source, and the summary is
not a paper. Until the exporter grows a non-paper repository kind, refresh the
mirror by copying the authority tree over it and committing there — one way,
authority first, never the reverse. Do not give the summary a borrowed paper id
to get it past the check: that would make a real paper's identity name a
directory it does not live in.

Because no tool checks it, the summary is the one surface where a claim can
drift out of agreement with the paper it describes without anything failing.
The rule that keeps it honest is in `literature-audit-conventions.md`
\S "Novelty text has one home": every novelty or priority sentence here quotes a
ledger row rather than restating it.

## Lean export for a paper: finitegeom, certificate package, release chain

This is the full chain that takes a validated Lean change from the authority
tree to a paper's pinned public formal artifact. Stop at any guarded refusal;
never hand-compose a replacement step.

### 1. Validate in the authority

Edit under `lean/RelativeConicArcs/...`, elaborate through the guarded entry
points, rebuild the owning aggregate gate, and refresh the tracked axiom
audit from the gate elaboration's standard output, all per `lean/AGENTS.md`.

### 2. Extract the trust fact

The area exporter consumes a generated fact for the export gate:

```sh
python3 lean/scripts/lean-trust-extract.py plan --area <area>
python3 lean/scripts/lean-trust-extract.py run --unit <Gate.Module>
```

Extraction needs a quiet Lean worktree (foreign modified paths block it) and
the owning build window. Commit the generated
`lean/trust/facts/<gate>.json` — the exporter reads the registry
(`lean/trust/areas/*.toml`) and the fact from the source **commit**, not the
worktree.

### 3. Area-export onto finitegeom

```sh
python3 lean/scripts/lean-area-export.py \
  --config lean/trust/export/<area>.toml \
  --source-commit <othello-commit> --finitegeom-commit <finitegeom-commit> plan
python3 lean/scripts/lean-area-export.py ... run --workdir <disk-backed-dir>
```

`run` materializes the candidate twice, requires byte-identical repeats, and
verifies module identity, manifest completeness, and terminal/axiom-audit
agreement. Re-exporting an area finitegeom already adopted is supported: the
configured README bullet is inserted only when it is absent, so a README that
needs no other change simply drops out of the delta. The forward-delta gate enforces **containment**: every changed
path must be planned, while planned files whose bytes finitegeom already
carries are reported as unchanged rather than refused. Copy the printed delta
into `~/src/lean/finitegeom` with no hand edits, validate the export gate
there through the guarded runner (`--lean-root`/`--root` select the finitegeom
package), and adopt it as one ordinary forward commit. Publishing that
finitegeom revision is the author's decision. Paper bridges resolve finitegeom from
the public remote; certificate packages do not resolve it.

### 4. Re-pin the paper bridge

In the paper-bridge checkout, after the finitegeom revision is published:

1. Update the bridge's finitegeom pin. Do not change the frozen certificate pin
   unless certificate source deliberately changed and its replacement artifact was
   sealed.
2. Rebuild only the cheap compatibility and paper-interface targets through the
   guarded queue, requiring the exact certificate cache and forbidding source fallback.
3. Refresh the bridge's axiom audit and release identity.

A finitegeom, paper, prose, manifest, or release change never rebuilds or reseals a
certificate package. A certificate cold build is a separately approved operation
after its full source, generated-prose, namespace, and dependency audit.

### 5. Run the paper's release chain

In the paper root, per its `verification/README.md`:

1. Update the manuscript's pin block (package commit, finitegeom commit, gate
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
