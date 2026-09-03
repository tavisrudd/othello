# Ergodis repository split plan (proposal, 2026-09-02)

**Lane**: `complete-ports` — task **C1058** (approved 2026-09-02)

## Goal

Move the Ergodis core out of `papers/complete-repair-ports/ergodis` into the existing standalone
repository `~/src/ergodis` (GitHub `tavisrudd/ergodis`), replaying sanitized commits on top of its
history, and move the parts kept separate or private into companion repositories under
`~/src/ergodis-*`. The monorepo stops being the authority for Ergodis code; it keeps only what the
paper and the research notes need.

## Current state

- `~/src/ergodis` last received an export on 2026-08-28. Since then the monorepo copy has 338 new
  files or directories and about a dozen modified sources (scheduler, zdd, transfer, span,
  projective, orbit, observational, tests). The standalone tree is clean with no local changes.
- The private workspace `ergodis-private/` (library plus `tasks/tools`, `tasks/gem-hunt`,
  `tasks/hadamard-2092`) depends on the core by relative path in four `Cargo.toml` files.
- Fourteen evidence checker scripts and one evidence file inside the core itself contain the
  monorepo path `papers/complete-repair-ports/ergodis`; these are the sanitization targets,
  together with `AGENTS.md`, `PERFORMANCE.md`, `evidence/`, and `proptest-regressions/`, which
  the crate's `exclude` list already marks as non-shipping.
- Two agents (C1049 dominance pruning in a worktree, C1054 hall_core promotion) are still editing
  core sources; the split waits for both to land.

## Target layout

| Repository                 | Contents                                                                                   | Visibility        |
|----------------------------|--------------------------------------------------------------------------------------------|-------------------|
| `~/src/ergodis`            | Core crate: `src/`, `tests/`, `examples/`, `benches/`, `scripts/` (sanitized), `docs/`, README, OPTIMIZATION, BENCHMARKS, LICENSE, `.cargo/config.toml`. | Public, AGPL + commercial |
| `~/src/ergodis-evidence`   | `evidence/`, `proptest-regressions/`, raw benchmark samples, checker scripts that need the monorepo layout, `SHA256SUMS`. Referenced from BENCHMARKS by relative URL. | Public or private per file; default private until reviewed |
| `~/src/ergodis-private`    | The `ergodis-private` workspace as is (tier-1 library, three task crates, `performance/`, `docs/CAMPAIGNS.md`, private evidence), with `ergodis = { git = ... }` or a path to a sibling checkout. | Private |
| `~/src/ergodis-contrib`    | `AGENTS.md`, `PERFORMANCE.md`, the perf playbook extract, kernel registry, retain-bin and cache-gc tooling. Contributor-only documents that must not ship in the crate. | Private |

Everything under `ergodis-private` that the trade-secret list (chat, 2026-09-02) names stays in
`ergodis-private`: theorem archive and banked reductions, evolve admission and grammars, campaign
infrastructure, task crates, the absorption list.

## Method

1. **Freeze.** Land C1049 and C1054, run the core gates, tag the monorepo commit as
   `ergodis-split-base`.
2. **Sanitized history replay into `~/src/ergodis`.** Extract the subdirectory history since the
   last export commit with `git filter-repo --subdirectory-filter` on a throwaway clone (never on
   the monorepo), apply a path filter that drops the excluded files and a text filter that rewrites
   the monorepo path in scripts to a repository-relative path, then replay the resulting commits
   onto `~/src/ergodis` main as ordinary forward commits (rebase of the filtered branch onto the
   existing head; no history rewrite of what is already there). Task IDs in commit subjects stay;
   they are harmless provenance. A final review diff between the filtered tree and the monorepo
   tree, minus the excluded set, must be empty.
3. **Companion repositories.** `~/src/ergodis-private` is created by the same subdirectory filter
   over `ergodis-private/` with full history; `~/src/ergodis-evidence` and `~/src/ergodis-contrib`
   are created as fresh repositories from the current tree (their history is in the monorepo and
   does not need replaying).
4. **Rewire.** `ergodis-private` Cargo manifests point at `../ergodis` (sibling checkout) with a
   documented `[patch]` for a git source; the shared target dirs stay at `~/.cache/ergodis/target/`.
   The Lean, Python, and paper artifacts in the monorepo that cite core evidence get a one-line
   pointer to the evidence repository and its commit.
5. **Monorepo after the move.** `papers/complete-repair-ports/ergodis` and `ergodis-private/` are
   removed in one commit that records the split commits' hashes in each new repository; the paper's
   reproducibility appendix cites `tavisrudd/ergodis` at the tagged commit. Nothing is pushed by the
   agent; pushing the public repository is Tavis's action.
6. **Validation.** Each new repository builds and passes its gates standalone from a fresh clone;
   `ergodis-private` tests pass against the sibling core; the BENCHMARKS replay commands resolve;
   `cache-gc.sh` and `retain-bin.sh` still find their roots.

## Decisions taken (Tavis, 2026-09-02)

- **Branch model for the public core.** `~/src/ergodis` keeps a private `main` that receives the
  replayed history with task IDs intact. The GitHub public repository receives squashed and
  filtered merges from that private main (one squash per release or milestone, filtered through the
  exclude list and the path sanitizer), so public history never carries task IDs, private paths,
  or contributor documents. Commit subjects on private main are therefore not rewritten, and **no task ID may appear in any
  published commit on the public branch**, in subject, body, or content.
- **Scope of C1058 includes the promotion track and documentation.** The pending promotions
  (C1054 hall_core, C1055 margin lift, C1056 arithmetic kernels, C1057 proof scaffolding) land in
  the new core repository, not the monorepo copy, once the split base is tagged; and each new
  repository gets its own `AGENTS.md` plus a `CLAUDE.md` symlink to it, a README, and the routed
  documents it owns (PERFORMANCE.md and the perf playbook extract in `ergodis-contrib`; the
  kernel registry and campaign docs in `ergodis-private`).
- **Monorepo after the move.** Cites the external repositories at tagged commits; no vendored
  copy. Companion names as proposed unless the executing review finds `ergodis-evidence` and
  `ergodis-contrib` better merged.

## Public/private branching model

One repository, `~/src/ergodis`, two long-lived branches and two remotes.

| Branch   | Role                                                                 | Remote                                  |
|----------|----------------------------------------------------------------------|-----------------------------------------|
| `main`   | Private. Full replayed history, task IDs, contributor docs, evidence pointers. | `private` (a private GitHub repo or none; never the public one) |
| `public` | Published. Each commit is a filtered snapshot of `main` at an export point, parented on the previous public commit. | `public` = `git@github.com:tavisrudd/ergodis.git`, pushed as its `main` |

**Export is a snapshot, not a merge.** `scripts/export-public.sh <private-rev> <message-file>`:

1. Materializes `filter(tree(private-rev))` in a scratch worktree: drops every path in the exclude
   set (`AGENTS.md`, `CLAUDE.md`, `PERFORMANCE.md`, `evidence/`, `proptest-regressions/`,
   `.cargo/`, `EXPORTS.md`, `scripts/export-public.sh` and every other process, workflow,
   handoff, checklist, or agent-facing document — all process is private and never ships —
   plus anything listed in `.publicignore`), rewrites the monorepo path in
   scripts to repository-relative, and replaces evidence references with the evidence
   repository's tagged URL.
2. Runs the public lint on the filtered tree and refuses to continue on any hit: task-ID
   tokens (`\bC[0-9]{2,4}\b` in text files, with an allowlist file for legitimate identifiers
   such as chemical or code names), private path fragments (`othello`, `ergodis-private`,
   `notes/`, `/home/`), contributor-doc names, and any file larger than a stated cap.
3. Creates the public commit with `git commit-tree <filtered-tree> -p <previous public>` using the
   supplied message file (release notes written for readers, never task IDs; the lint runs on the
   message too), advances `public`, and tags it `v<semver>`.
4. Appends one line to the private-only `EXPORTS.md`: date, private revision, public commit,
   tag. This is the only record linking the two histories and it never leaves `main`.

Because every public commit is a full filtered snapshot, the public history is a clean linear
sequence of release-sized commits, `git diff` between two public commits equals the filtered
diff of the private range, and nothing needs rebasing. Squash semantics come for free.

**Guards against leaking `main`** (delivered by C1059 before any export; versioned hooks under `hooks/` installed through `core.hooksPath`, with fixture tests):

- The `public` remote is configured with a single push refspec
  `refs/heads/public:refs/heads/main` and `remote.public.pushurl` only; `git push public main`
  is refused by the refspec, and a `pre-push` hook additionally rejects any push to the public
  URL whose ref is not `public` or whose tip does not pass the public lint.
- `main` has no upstream on the public remote; `push.default = nothing` in the repo config so a
  bare `git push` fails until a remote and ref are named.
- The lint also runs in CI on the public repository as a minimal workflow that fails on any
  task-ID token or process document; the workflow file itself carries no process detail beyond
  invoking the lint, and the lint's rule list lives in the private tree.
- The public remote's `pushurl` is parked at a non-routable `no-push://` URL; only
  `scripts/publish.sh` swaps in the real URL for one push, and only with `ERGODIS_PUBLISH=1`
  set and a tip that is a lint-clean, tagged, `EXPORTS.md`-recorded `public` commit.
- Companion repositories have no public remote at all.
- Claude Code project settings in every Ergodis directory deny `git push` and `gh repo`
  mutations, so agents cannot publish even by mistake; GitHub branch protection on the public
  `main` requires the CI lint.
- Agents never push; export produces the commit and stops. Pushing is Tavis's action.

**Only polished, release-grade material is published.** An export is a release, not a sync:
it happens when the code and its documentation are in a state Tavis would put a version number
on. Before `export-public.sh` runs, a release checklist (private) must pass: README, OPTIMIZATION,
and BENCHMARKS read as finished documents with no working notes, TODOs, or in-progress sections;
every public benchmark row has its replay command and evidence tag resolving; the crate builds
and its gates pass from a fresh clone of the filtered tree; the changelog entry is written for
readers; and the lint is clean. Anything not ready is excluded from that export by
`.publicignore` rather than published rough. Work-in-progress kernels, draft docs, and
exploratory examples stay on `main` until they reach that bar.

**Working on the private side.** Ordinary work lands on `main` with task IDs in commit subjects
as today. Public-facing documentation is written without task IDs from the start (evidence and
report names use dates and topics, not IDs) so the lint stays quiet; where an existing document
cites an ID, the sanitizer rewrites it to the dated report title before export.

**Companion repositories** follow the same pattern only if they are ever published;
`ergodis-private` and `ergodis-contrib` have a single `main` and only a private remote.

## Decisions originally raised

1. Names and visibility of the companions (`ergodis-evidence`, `ergodis-private`, `ergodis-contrib`
   as proposed, or fewer).
2. Whether commit subjects carrying `C<id>` task IDs are acceptable in the public history or should
   be rewritten to plain subjects during the replay.
3. Whether the monorepo keeps a read-only vendored copy of the core for paper builds, or the paper
   cites the external repository only.
