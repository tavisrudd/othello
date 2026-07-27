# C684 — standalone paper-repository extraction

**Lane:** `build-sys`
**Status:** active; contract and inventory implementation started

## Objective

Export each adopted manuscript directory from the private Othello research repository into a
deterministic, self-contained local repository at
`~/src/math-papers/<paper-reponame>`, suitable for an eventual one-to-one remote at
`github.com/tavisrudd/<paper-reponame>`.

The private monorepo remains the development source of truth during C684. The extracted repositories
are reproducible release mirrors. C684 does not delete or replace `papers/` paths, introduce
submodules, or create a bidirectional synchronization problem.

## Authority and boundaries

C684 owns:

- the paper-repository mapping and export policy;
- a deterministic exporter and its hermetic tests;
- tracked-file inventory, path transformation, symlink handling, and internal-reference checks;
- local repository construction under `~/src/math-papers/`;
- clean-room manuscript, bibliography, checker, and packaging validation;
- provenance manifests tying each exported repository to an exact Othello commit; and
- bounded reports for every constructed local repository.

C684 consumes but does not own:

- the shared Lean repositories and certificate packages produced by C287/build-sys;
- paper-specific mathematical, prose, bibliography, and verification decisions owned by manuscript
  lanes;
- author affiliation, contact, journal, arXiv, DOI, license, and publication metadata; and
- GitHub repository creation, pushes, releases, or other public actions.

Build-sys supplies Lean dependencies independently. C684 must not copy private-monorepo Lean trees
into paper repositories or infer Lean closures from manuscript prose. A paper repository may carry
tracked Nix/lock configuration and references to released build-sys packages when their owning
contract is ready, but Lean source/package publication is outside this task.

Remote creation and push remain explicit user-authorized release actions. The mapping to
`tavisrudd/<paper-reponame>` is a naming contract, not permission to contact GitHub.

## Adopted repository boundaries

Repository boundaries follow physical manuscript roots, not one row per TeX entry point. The paper
registry currently has thirteen manuscript rows but eleven adopted physical roots because
`beyond4_prs` and `clebsch-rigidity` each contain two manuscript variants.

| Source root | Repository name | Manuscript treatment |
|---|---|---|
| `papers/ame_lu` | `ame-lu` | active candidate |
| `papers/arcs_complete_outside_conic` | `arcs-complete-outside-conic` | waits for the arcs/Q16 release boundary |
| `papers/beyond4_prs` | `beyond4-prs` | preprint and submission variant stay together |
| `papers/clebsch-factorization` | `clebsch-factorization` | active Clebsch Paper II |
| `papers/clebsch-hexagon-code` | `clebsch-hexagon-code` | preserved fallback; export only as an explicitly marked archive |
| `papers/clebsch-passages` | `clebsch-passages` | active Clebsch Paper III; first pilot |
| `papers/clebsch-rigidity` | `clebsch-rigidity` | core paper and computational companion stay together |
| `papers/complete-repair-ports` | `complete-repair-ports` | active candidate |
| `papers/continuation-graph-rigidity` | `continuation-graph-rigidity` | active candidate; external symlinks require disposition |
| `papers/dihedral-schreier-node-kayles` | `dihedral-schreier-node-kayles` | active candidate; external symlinks require disposition |
| `papers/equivariant-robust-completion` | `equivariant-robust-completion` | active candidate |

Staging/library views `baer-equivariant-extension` and `completion-core-rigidity` are not paper
repositories. `nofil-finite-geometry-outcomes` is deferred until its manuscript is registered.
`expert-profiles`, `oeis-submissions`, and `non-formal-bloggy` are outside C684.

The machine-readable mapping will live in `papers/repositories.toml`. It must name every included
paper-registry ID, its source root, destination name, entry points, disposition, and any explicit
extra-file or symlink rule. The exporter refuses:

- a registered active paper root with no repository mapping;
- a mapping whose source root or main entry point disagrees with `lean/trust/papers.toml`;
- duplicate, case-fold-colliding, or Unicode-normalization-colliding destination names;
- a physical root split accidentally across multiple repositories; or
- an unregistered manuscript silently admitted through a broad directory copy.

## Export content policy

The exporter starts from Git's tracked-file set at an exact source commit. It never recursively
copies the live working directory. This excludes untracked caches and makes a dirty worktree
incapable of changing exported bytes.

Default included content under an adopted paper root:

- TeX sources, sections, bibliography sources, figures, and checked-in style assets;
- paper-local `Makefile`, README, verification/checker scripts, compact certificates, and manifest
  files;
- tracked final PDFs only when the repository mapping explicitly adopts them; and
- paper-local evidence required by a stated replay command.

Default excluded content, even when present in the live directory:

- `.pyc`, `__pycache__`, LaTeX intermediates, editor files, caches, and temporary output;
- private review conversations, grading artifacts, lane handoffs, task queues, and discovery logs;
- credentials, submission tokens, local absolute paths, and machine-specific state;
- monorepo-wide planning/index documents; and
- Lean sources or certificate packages owned by C287.

Tracked generated files are not excluded merely because they are generated. Their inclusion must be
declared, and their provenance/replay status must be preserved. The export manifest distinguishes
source, generated evidence, frozen artifact, and release-output roles.

## Symlinks and external references

No symlink crosses a repository boundary in an exported repository.

For every tracked source symlink:

1. resolve it against the immutable source commit;
2. require an explicit mapping disposition;
3. either materialize the exact target bytes at a declared destination or exclude it;
4. record source path, target path, target blob hash, destination path, and disposition; and
5. reject broken, absolute, escaping, chained-unreviewed, or undeclared links.

The initial inventory found two external symlinks in continuation and five in dihedral. They point
into private `notes/`; none is exported automatically.

Text validation scans exported text for unresolved monorepo coupling, including:

- `../papers-index.md`, `../papers-planning.md`, `../../notes/`, and private handoff paths;
- `/home/tavis`, workspace-specific cache paths, and `file://` links;
- internal C-task routing presented as a public dependency;
- references to private Lean paths instead of released build-sys package identities; and
- links whose target is absent from the exported tracked-file set.

Findings fail the candidate unless the mapping carries a narrowly reviewed allow rule with a public
explanation. The exporter does not silently rewrite mathematical prose. Mechanical README/build
path rewrites must be explicit and covered by fixtures.

## Destination layout and provenance

Paper contents are flattened from `papers/<source-root>/` to the new repository root. Each candidate
adds a small extraction-owned layer:

- `.gitignore` for build products;
- `PROVENANCE.md`, naming the exact Othello source commit and export command;
- `export-manifest.json`, the canonical byte-level inventory and validation contract; and
- only where absent and approved, a standalone build wrapper whose behavior is tested against the
  paper's existing build.

The canonical manifest records:

- schema version, repository name, source commit, exporter commit, and source registry hash;
- adopted paper IDs, source root, main entry points, and source title hashes;
- every destination path, mode, byte count, SHA-256, source path, source blob ID, and content role;
- every exclusion and symlink disposition;
- expected PDF names, hashes, and page counts when frozen;
- exact manuscript/checker validation commands and their required inputs;
- external build-sys package identities when supplied; and
- clean-room validation results tied to the exact candidate commit.

Manifests are canonical JSON with sorted paths and a terminal newline. Two exports from the same
source commit and mapping must be byte-identical before Git metadata.

## Construction state machine

Each repository advances through durable states:

1. **mapped** — registry agreement and unique destination identity pass;
2. **inventoried** — tracked source blobs, exclusions, links, and external references are frozen;
3. **materialized** — candidate tree written to a new empty directory;
4. **source-validated** — manifest completeness, hashes, path safety, and internal-reference gates
   pass;
5. **paper-validated** — all declared paper/checker commands pass in isolation;
6. **clean-room-validated** — a separate checkout of the exact candidate commit passes without
   access to Othello;
7. **local-ready** — local `main` points at the validated candidate and the report records its hash;
8. **remote-ready** — publication metadata and any build-sys package references are finalized; and
9. **published** — only after explicit user authorization creates/pushes the mapped GitHub remote.

Failed candidates do not advance `main`. Corrections are reconstructed from the frozen input
manifest so failed output does not become an ancestor of a release state.

Existing nonempty destination directories are never overwritten. C684 must either prove that a
directory is its own prior resumable candidate with matching checkpoint metadata or stop.

## Validation gates

### Exporter tests

- paper-registry and repository-mapping agreement;
- deterministic tracked-file inventory from a fixed Git tree;
- dirty-worktree independence;
- path traversal, absolute path, symlink escape, duplicate, case-fold, and Unicode collision
  refusal;
- exclusion of untracked/build debris;
- source blob and destination SHA verification;
- multi-main repositories;
- missing main source and unmapped registered-root refusal;
- internal-reference detection and explicit narrow allow rules;
- deterministic manifest and second-export byte identity; and
- refusal to overwrite a nonempty or foreign destination.

### Per-repository clean-room gate

- exact tracked tree equals `export-manifest.json`;
- all declared main TeX sources exist;
- standalone PDF build succeeds with warning policy appropriate to the paper;
- expected PDF page count and, when frozen, hash match;
- paper-local verification scripts and compact certificate replays pass;
- bibliography and cross-reference checks pass;
- no broken links, private paths, undeclared generated evidence, or secrets;
- README commands work from repository root; and
- a clean checkout of the candidate commit repeats the declared gate.

Lean and certificate-package builds are not rerun by C684. When build-sys supplies a released
package contract, C684 validates only that the paper repository pins and names that contract
correctly.

## Execution order

### Phase A — contract and safe inventory

1. Add `papers/repositories.toml`.
2. Implement read-only `plan` and `audit` commands.
3. Add hermetic fixtures and adversarial failure tests.
4. Produce a bounded portfolio inventory without writing destination repositories.

Acceptance: all adopted boundaries are explicit; the tool detects the known multi-main roots,
external symlinks, tracked/untracked distinction, and internal references without broad copying.

### Phase B — pilot on Clebsch Passages

1. Freeze an exact Othello source commit.
2. Export `clebsch-passages` twice into disposable disk-backed directories.
3. Prove byte identity.
4. Build and run its paper-local release checks in a clean checkout.
5. Construct `~/src/math-papers/clebsch-passages` only after the disposable candidate passes.

The pilot excludes Lean because C287 records this paper as having no Lean root. It must not invent a
placeholder formal package.

### Phase C — ordinary repositories

Proceed one repository at a time: Clebsch Factorization, Clebsch Rigidity, AME--LU, Beyond4 PRS,
Complete Repair Ports, Equivariant Robust Completion, Continuation, and Dihedral. Resolve external
notes/symlinks through explicit dispositions before those last two materialize.

Each repository gets its own commit and report. A failure in one does not block already validated
local repositories.

### Phase D — arcs and certificate-dependent release

Do not materialize the final arcs repository until the arcs manuscript boundary and Q16
certificate/build-sys package identities are frozen. C684 consumes those identities; it does not
wait idly to develop the exporter or validate other repositories.

### Phase E — fallback and remote readiness

Export `clebsch-hexagon-code` only after adding an archive/fallback notice that cannot be mistaken
for the active Clebsch publication. Audit all local repository names and provenance records against
the intended `tavisrudd/*` mapping. Stop before remote creation or push unless the user explicitly
authorizes it.

## Fresh-session route

Start with:

```text
go C684 build-sys extract standalone paper repositories
```

Then:

1. read the root `AGENTS.md`;
2. read the exact C684 queue row and the build-sys handoff;
3. read this report in full;
4. inspect only `papers/repositories.toml`, the exporter, and the current phase's fixture/report;
5. do not load manuscript lane handoffs unless a concrete mapping mismatch requires owner context;
6. do not run Lean or touch C287 destinations;
7. preserve foreign work and use exact pathspecs;
8. commit each validated phase or repository independently; and
9. resume from the first unproved state recorded under **Current state**, not from the beginning.

## Current state

- C684 allocated and pegged to `build-sys`.
- The repository boundary and validation contract are frozen in this report.
- `papers/repositories.toml` now maps all thirteen registered manuscript rows into eleven physical
  repository boundaries. The two dual-main roots remain intact, arcs is marked gated, and the
  integrated Clebsch paper is marked archive.
- `papers/scripts/export-paper-repos.py plan` reads the registry, mapping, and manuscript blobs from
  one immutable Git commit. It validates IDs, roots, main sources, destination identities, and
  symlink dispositions without reading live manuscript bytes or writing destinations.
- The exporter now also has a read-only `audit` command and an active-only `materialize` command.
  Materialization refuses existing destinations, unresolved private references, gated/archive
  repositories, undeclared symlinks, generated-name collisions, and missing destination parents.
  It writes source blobs by Git object ID, canonical provenance and export manifests, fixed modes,
  and a paper-specific build-output ignore list.
- Fourteen hermetic adversarial tests pass. They cover immutable-commit/dirty-worktree separation,
  deterministic selection and materialization, missing mappings, destination collisions, unsafe
  paths, undeclared and stale symlink dispositions, private-reference detection, overwrite refusal,
  private-reference materialization refusal, and manifest verification against tampering and extra
  files, plus monorepo-root command detection, exact-count rewrite drift, internal task-ID
  detection, preservation of the public Clebsch class labels `C01`--`C15`, and process-file
  detection by path.
- The first plan at source commit `c12727722a325f6d8a93b0bb5b17001b63da229f` found exactly seven
  explicitly excluded external symlinks: two in continuation and five in dihedral. It found no
  undeclared symlink.
- The same plan reported sixteen monorepo-coupled text-reference hits: AME--LU 1, arcs 4,
  continuation 2, dihedral 4, and equivariant robust completion 5. These are inventory findings,
  not silently rewritten content.
- The portfolio audit fails on those sixteen findings, while a selected
  `audit --repository clebsch-passages` passes with zero findings.
- The Clebsch Passages pilot was materialized twice from source commit
  `ee5fd51be81e66b36f7ba417d67528b56b2649ae` into separate disk-backed disposable directories;
  both 29-file trees were byte-identical. A pristine candidate was committed as disposable commit
  `0f575510f6a5e26bf8b52d4e4c4aef6b6e199327`, cloned separately, and validated without access to
  Othello. `make -B` and `python3 verification/verify_release.py` passed all release checks; the
  clean checkout remained Git-clean after the build.
- Main PDFs are excluded from source exports by default and ignored at their exact derived paths.
  Two successful XeLaTeX builds from the same source produced 111073-byte and 111072-byte PDFs, so
  a built PDF cannot yet serve as a byte-reproducible tracked source artifact. PDFs remain separate
  release outputs; page/warning/release gates still passed.
- The pilot export manifest SHA-256 is
  `634dc6b8ddb12f9cd4b183fde591510a4d7147e62b0f9ca8f0f2b64658be2ab7`.
- Manifest/tree verification now checks every declared file's path, size, SHA-256, and mode, plus
  the exact uncommitted tree or Git-tracked file set. It refuses missing, tampered, duplicate, or
  extra tracked paths.
- Clebsch Passages is promoted to `~/src/math-papers/clebsch-passages` from exact Othello source
  commit `773366a5492dfc6ca7a94a45fed4563da168519f`. Its clean local `main` commit is
  `6c927fab9685a4ed8994323a002dbeaa9343b90f`; it has no remote. The final export-manifest SHA-256 is
  `eddf04e365252c1790b56b94d80e395a9dd6b44ff98f2d23135ba1099ddadfcd`.
- A separate clone of that exact local commit passed manifest verification, `make -B`, all aggregate
  release checks, and the warning-free build gate. The source repository remains clean because the
  rebuilt PDF and LaTeX products are exact-path ignored release outputs.
- A stronger audit added after that promotion detects flattened-repository commands of the form
  `papers/<name>/...`. It found eight such references in Clebsch Passages'
  `verification/README.md`; the first local commit therefore remains a superseded candidate rather
  than the release-ready state.
- Exact-count, path-specific rewrites now transform those eight commands and refuse source drift.
  Corrected source commit `777a32a2255a0e010cf43b6755f99d6c049eb000` produces audit-clean
  disposable candidate `895a43ce3c7d0709cb9fd8ca4d02c3af36734428`, with export-manifest SHA-256
  `404e53306b95da33e6a065dccccc9661e84b9cea6d241f12ae33636ae70c26b9`. A separate clean clone
  again passed `make -B`, every aggregate release check, and the warning-free gate.
- The strengthened portfolio audit now treats task-like identifiers (`C80` and above), private
  process phrases, and named review/ledger/plan files as export blockers. At source snapshot
  `cb9408a1`, it reports 760 findings: 624 task-ID references, 102 monorepo-root commands, 17
  internal process files, 10 private-note links, 4 paper-index links, 2 private-handoff references,
  and 1 internal-process phrase. The live TeX contamination is confined to 39 task-ID occurrences
  in `dihedral_schreier_node_kayles.tex`; `C01`--`C15` in the Clebsch manuscripts are mathematical
  class labels and are deliberately not findings.
- At that snapshot, `clebsch-hexagon-code` and `clebsch-passages` have zero findings.
  `clebsch-factorization` has only 94 flattening rewrites to make in paper-root replay commands.
  Every other mapped root needs a repository-specific content disposition; broad allow rules are
  forbidden.
- The Node Kayles task-ID findings are rendered, because the manuscript sets
  `\draftnotestrue`. They include a documented incomplete even-\(h\) classification and missing
  polyhedral integration, not merely editorial reminders. The repository is therefore gated until
  those mathematical issues are repaired and the phase-note mechanism can be removed honestly.
- Replacing `~/src/math-papers/clebsch-passages` with that fresh-history corrected candidate is
  intentionally paused for explicit history-replacement approval. No remote exists, and the
  validated corrected candidate is preserved under the disk-backed C684 cache.
- Next implementation step after that approval: replace the superseded local candidate, verify its
  exact commit, then resolve the expanded scoped reference findings repository by repository rather
  than adding a broad exception. No GitHub remote has been created.
- Arcs/Q16 readiness gates only Phase D, not Phases A–C.
