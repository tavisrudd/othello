# C1059 — Ergodis publication guard tooling (2026-09-02)

**Lane**: `complete-ports`. Target repositories: `~/src/ergodis` (private) and
`~/src/ergodis-public` (local staging clone). Plan: `2026-09-02-ergodis-repo-split-plan.md`.

Nothing was pushed. No network operation succeeded or was required.

## Topology as built

Tavis's mid-task decision replaced the original "private repository holds the public remote"
design: the private repository is now not connected to GitHub at all.

```
~/src/ergodis            private. Branches main (private) + public (snapshots).
                         Only remote: staging = /home/tavis/src/ergodis-public
      |  scripts/export-public.sh          build the filtered snapshot commit
      |  scripts/publish-to-staging.sh     push refs/heads/public:refs/heads/main
      v
~/src/ergodis-public     staging clone. Branch main. origin = the GitHub URL,
      |                  pushurl parked at no-push://ergodis-public between publishes.
      |  .publish/publish.sh               validate like a downstream user, then push
      v
GitHub tavisrudd/ergodis
```

This is the paper-export discipline with git as the exporter: validate the authority, forward
commit the extracted copy, then validate the standalone copy before it goes out. The snapshot
commit is the artifact, `EXPORTS.md` is the manifest, and the staging clone is the standalone copy
that must build and test from scratch.

`~/src/ergodis` now has **no GitHub remote**: `configure-remotes.sh` removed `origin`
(`git@github.com:tavisrudd/ergodis.git`) after the staging remote existed. That URL is recorded in
`docs-private/README.md`, deliberately outside git configuration.

`~/src/ergodis-public` was created by the documented **local fallback**, not by cloning GitHub:
`git clone` of the public URL failed in this environment (no credentials in the agent session), so
`configure-remotes.sh` cloned `~/src/ergodis --branch public`, renamed the branch to `main`, and
set `origin` to the GitHub URL with the parked pushurl. Its content is identical to the published
GitHub `main` (`9ed76b3`), so the fallback is not a divergence, but the first real publish should
be preceded by one `git fetch origin` from a session with credentials to confirm that.

## What was built

All paths relative to `~/src/ergodis` unless stated.

| Path | Role |
|---|---|
| `scripts/public-lint.sh` | The whole rule set. `<tree-ish\|dir> [--message FILE] [--allow FILE]`. |
| `scripts/export-public.sh` | `<private-rev> <message-file> <tag>` — filtered snapshot commit on `public`. |
| `scripts/publish-to-staging.sh` | `<tag>` — the private repository's only push, to a local path. |
| `scripts/configure-remotes.sh` | `[staging-path]` — builds both repositories and prints the resulting config. |
| `scripts/install-hooks.sh` | `core.hooksPath = hooks`. |
| `hooks/pre-push`, `hooks/pre-commit` | Independent enforcement. |
| `staging/publish.sh`, `staging/validate-release.sh` | Templates installed untracked as `.publish/` in the staging clone. |
| `.publicignore`, `.public-lint-allow` | Export exclusion set (with a documented work-in-progress hold section); token allowlist. |
| `docs-private/RELEASE-CHECKLIST.md`, `docs-private/README.md` | Release-grade gate; private guard overview. |
| `.claude/settings.json` | Deny `Bash(git push*)`, `Bash(gh repo *)`, `Bash(gh release *)`, `Bash(gh api *)`. |
| `.github/workflows/public-lint.yml` | The only process artifact on the published branch. |
| `tests/publication-guards.sh` | Fixture tests. |

Everything except the workflow is in `.publicignore`, so the guard tooling never ships.

### Lint rules

`task-id` (`\bC[0-9]{2,4}\b`, allowlisted tokens exempt, currently `C99`/`C11`/`C17`),
`private-path` (`othello`, `ergodis-private`, `ergodis-contrib`, `notes/`, `/home/`),
`process-doc`, `oversize` (1 MiB, `PUBLIC_LINT_MAX_BYTES`). Every hit is printed as
`path:line: rule: text` and any hit is fatal. With `--message FILE` the task-id and private-path
rules also run on the commit message.

`process-doc` matches **paths only**, never content. That is deliberate: the public CI workflow has
to name `AGENTS.md`, `CLAUDE.md`, and the rest in order to check for them, and a content rule would
make the workflow flag itself. The private path fragments and the size cap are not in the workflow;
only the two rules that are safe to state in public are vendored there.

### Export semantics

`export-public.sh` archives `tree(<private-rev>)` into a scratch worktree under the session
scratchpad, deletes every `.publicignore` path, rewrites the monorepo path
`papers/complete-repair-ports/ergodis` (including `~/src/othello/...` and `/home/<user>/src/othello/...`
prefixes) to repository-relative, rewrites `evidence/` references to `$ERGODIS_EVIDENCE_BASE_URL`
(default `https://evidence.invalid/ergodis-evidence`, documented in the script header), lints the
tree and the message, then `git commit-tree <tree> -p <public tip>`, `update-ref`, `tag`, and
appends `date<TAB>private-rev<TAB>public-commit<TAB>tag` to `EXPORTS.md` on `main` as its own commit.

The evidence rewrite is confined to Markdown. A first pass over the whole tree rewrote
`python/generate_evidence.py` into writing to a URL, which would have shipped a broken generator; a
reader following a documentation link needs the companion URL, but a script that regenerates
evidence must keep its relative directory. That is now the documented split.

## Exact refusals tested

`tests/publication-guards.sh` builds a synthetic private repository carrying the real guard scripts,
a staging clone built by the real `configure-remotes.sh`, and a local bare repository standing in for
GitHub. Verbatim result of the final run:

```
== lint rules
ok    lint accepts a clean tree
ok    lint refuses a task identifier
ok    lint allows an allowlisted token
ok    lint refuses a process document
ok    lint refuses a private path fragment
ok    lint refuses an oversize file
ok    lint refuses a task identifier in the commit message
== export
ok    export refuses a tree with a task identifier
ok    export refuses a tree with a private path
ok    export refuses a message carrying a task identifier
ok    export refuses a dirty worktree
ok    export refuses a revision that is not an ancestor of main
ok    clean export succeeds
ok    the public commit is linear on the previous public tip
ok    the public tree equals the filtered private tree
ok    the export rewrote the monorepo path and the evidence reference
ok    the export is recorded in EXPORTS.md
ok    export refuses an existing tag
== remotes and hooks
ok    configure-remotes builds both repositories
ok    the private repository has only the staging remote
ok    single push refspec, push.default=nothing, no upstream for main
ok    a bare push does not carry main to staging
ok    pushing main to staging is refused
ok    pushing main by explicit refspec is refused by the hook
ok    pushing to the public URL is refused by the hook
ok    pushing to any non-local URL is refused by the hook
== publish to staging
ok    second export succeeds
ok    publish-to-staging refuses without ERGODIS_PUBLISH=1
ok    publish-to-staging refuses an unrecorded tag
ok    publish-to-staging refuses a tag missing from EXPORTS.md
ok    publish-to-staging succeeds with ERGODIS_PUBLISH=1
ok    staging main is the exported snapshot
ok    staging received only the public snapshot
== staging publish
ok    staging publish refuses without ERGODIS_PUBLISH=1
ok    staging publish refuses a tag that is not present
ok    staging publish refuses a broken BENCHMARKS replay command
ok    staging publish refuses a lint-dirty tree
ok    staging publish succeeds against the local bare repository
ok    the bare repository received the snapshot
ok    the staging pushurl is parked again after the publish
== fresh clone
ok    a fresh clone starts without hooks configured
ok    install-hooks.sh configures the fresh clone
ok    core.hooksPath is set in the fresh clone
ok    the fresh clone's hook refuses a push to the public URL

passed: 44  failed: 0
```

The "public tree equals the filtered private tree" check is a full `diff -r` between the exported
tree and an independently filtered copy of the private tree, so it is an exact tree equality, not a
spot check. `cargo build --release` runs for real in the staging publish success case; only
`cargo test --all-features` is skipped there (`ERGODIS_VALIDATE_SKIP_TESTS=1`) to keep the fixture
fast, and the test path is exercised by the code being the same call.

All scripts are `set -euo pipefail` and shellcheck-clean at warning severity and above
(`shellcheck -S warning -x`). The remaining informational findings are all SC2292, the
`[ ]` versus `[[ ]]` style preference, which is left as is for POSIX-shaped hook code.

## Dry run against the real repository

A throwaway clone of `~/src/ergodis` exported its current `main` cleanly: the lint passed on the
filtered tree and on the message, and the dropped set was exactly the `.publicignore` list —
`.claude/`, `.public-lint-allow`, `.publicignore`, `EXPORTS.md`, `docs-private/`, `evidence/`,
`hooks/`, `proptest-regressions/`, the six guard scripts, `staging/`, and
`tests/publication-guards.sh`. `.github/workflows/public-lint.yml` survived the filter and did not
trip the lint. The throwaway clone was deleted; no tag or export commit exists in the real
repository.

## Signing

Nothing created in this task is signed. The global git configuration has `commit.gpgsign=true` and
`tag.gpgsign=true`, and one pinentry prompt did fire, from `export-public.sh`'s `EXPORTS.md` commit
during an early fixture run before signing was pinned off; that commit failed to be created, so no
signed object resulted. All eight commits on `~/src/ergodis` `main` report `N` under
`git log --format='%G?'`, and no tags exist in either repository. Signing is now pinned off in three
places: `-c commit.gpgsign=false` and `-c tag.gpgSign=false` on the commit and tag calls inside
`export-public.sh`, local `commit.gpgsign=false`/`tag.gpgSign=false` set by `configure-remotes.sh` in
both repositories, and the same two keys set in every fixture repository the tests create.

## Commit hashes on `main` (`~/src/ergodis`)

| Commit | Subject |
|---|---|
| `9ed76b3` | (pre-existing tip; `public` branch created here) |
| `888aa10` | Add the public lint and the export exclusion set |
| `68e5705` | Add the filtered public snapshot exporter |
| `2556d2c` | Add the staging topology, its publish path, and hook installation |
| `af96e0f` | Add versioned pre-push and pre-commit guards |
| `984c14f` | Add the release checklist, guard overview, agent deny rules, and public CI lint |
| `f385f12` | Add fixture tests for every publication refusal |
| `fa2b2a7` | Speed up the lint, confine the evidence rewrite to prose, and never sign |

`public` is at `9ed76b3`, identical to the published GitHub `main`, and has not moved.

## Remaining gaps

1. **GitHub branch protection is not set and cannot be set from here.** In the web UI: open
   `https://github.com/tavisrudd/ergodis` → **Settings** → **Branches** → **Add branch ruleset**
   (or **Add classic branch protection rule**). Name it `main`, target branch `main`, and enable:
   **Require status checks to pass before merging** with the check `public-lint` selected (it
   appears in the list after the workflow has run once, so push the first export before adding the
   rule, or type the name into the search box); **Require branches to be up to date before
   merging**; **Block force pushes**; **Restrict deletions**. Leave "Require a pull request before
   merging" off, since publication is a direct push of a snapshot commit. Under **Bypass list**,
   add nobody — including yourself — so a mistaken local push is rejected rather than waved through.
2. **The published tree fails today's size cap.** The current GitHub `main` carries
   `evidence/benchmarks.json` at 1,406,105 bytes, over the 1 MiB cap. That is why the staging
   checkout does not pass the lint as it stands. The first export removes `evidence/` from the
   public branch entirely, which resolves it, but it means the first published snapshot is a
   visible deletion of the evidence directory. Land `~/src/ergodis-evidence` (part of the C1058
   split) and set `ERGODIS_EVIDENCE_BASE_URL` to its tag before that export, or the Markdown links
   will point at the `evidence.invalid` placeholder.
3. **`BENCHMARKS.md` replay resolution is only checked for scripts, `--example`, and `--bench`
   targets.** A replay line that names a binary or a `cargo run --bin` target is not validated.
   Extend `validate-release.sh` if such lines appear.
4. **No fetch from GitHub has been done.** The staging clone was built locally, so it has no
   `refs/remotes/origin/*`. Run `git -C ~/src/ergodis-public fetch origin` once from a session with
   credentials and confirm `origin/main` equals the local `main` before the first publish.
5. **The `pre-commit` hook only fires on the `public` branch**, which is normally never checked out
   (export builds commits with `commit-tree`). It is a backstop for a manual public commit, not a
   routine gate.
6. **`.publicignore` has no glob support** — entries are exact paths or directory prefixes. That is
   sufficient for the current exclusion set and keeps the filter auditable; add globbing only if a
   real case needs it.

## Vibe check

Good. Every refusal in the task specification is implemented and demonstrated by a passing fixture,
the private repository no longer knows the GitHub URL, and a real dry-run export of the current tree
is lint-clean with exactly the intended files dropped. The one genuine surprise — the evidence
rewrite silently corrupting the evidence generator — was caught by inspecting the dry run rather
than by a test, which is worth remembering: the tree-equality test compares against an
independently filtered copy and so cannot notice a rewrite that is wrong but consistent.
