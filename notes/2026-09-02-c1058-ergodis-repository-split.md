# C1058 — Ergodis repository split (2026-09-02)

**Lane**: `complete-ports`. Plan: `2026-09-02-ergodis-repo-split-plan.md`. Guards: C1059
(`2026-09-02-c1059-publication-guard-tooling.md`).

Nothing was pushed. No repository under `~/src/ergodis*` has a GitHub remote except the
pre-existing staging clone `~/src/ergodis-public`, whose push URL stays parked.

## Split base

Monorepo commit `aa49d68c3` (C1049/C1054/C1060 landed; core gates `cargo fmt --check`,
`clippy -D warnings`, `cargo test --all-features` pass there) is tagged `ergodis-split-base`.

## Result: four sibling repositories

| Repository               | Created from                                                                 | Tip after split |
|--------------------------|------------------------------------------------------------------------------|-----------------|
| `~/src/ergodis`          | private `main` = C1059 tip `fa2b2a7` + sync commit + replayed history        | `681d7c4`       |
| `~/src/ergodis-private`  | full subdirectory history of `ergodis-private/` (281 commits) + rewire      | `c51a22a`       |
| `~/src/ergodis-evidence` | fresh; `evidence/`, `proptest-regressions/`, `SHA256SUMS` from core `37601a1` | `09b6168`       |
| `~/src/ergodis-contrib`  | fresh; `PERFORMANCE.md`, playbook extract, retain-bin/cache-gc/lib tooling   | `c6ee2a4`       |

Each has `AGENTS.md`, a `CLAUDE.md -> AGENTS.md` symlink, a README, unsigned commits, and no
remote (`ergodis` keeps only `staging`, a local path).

## Method as executed

1. **Extraction.** A `--no-local` clone of the monorepo was reduced with
   `git filter-repo --subdirectory-filter papers/complete-repair-ports/ergodis` (512 commits),
   then a second pass dropped `AGENTS.md`, `PERFORMANCE.md`, `scripts/retain-bin.sh`,
   `scripts/cache-gc.sh`, `scripts/test-cache-gc.sh` from history and rewrote the monorepo path
   (`papers/complete-repair-ports/ergodis`, with `~/src/othello` and `/home/<user>/src/othello`
   prefixes) to repository-relative in every blob except JSON/JSONL, so evidence bytes are
   untouched and `SHA256SUMS` stays valid. The image of the 2026-08-28 base `033f927ea` is the
   filtered base.
2. **Sync commit.** The 2026-08-28 export in `~/src/ergodis` was a curated 84-file public
   surface, not the full tree, so the first new commit on private `main` adopts the full filtered
   base tree plus the sixteen C1059 guard files (`19f6f24`). The replayed range then applies on an
   identical base.
3. **Graft with guard injection.** The filtered base was `git replace --graft`ed onto the sync
   commit and `git filter-repo --refs sync..tip` made it permanent, with a commit callback that
   adds the sixteen guard blobs to every replayed commit so the guards never leave the tree. The
   one commit that became a no-op (the base itself) was pruned. Result: 378 commits, both merge
   commits preserved, subjects untouched (task IDs stay on private `main` by decision).
4. **Exactness check.** `diff -r` between the replayed tip and the monorepo core tree at
   `aa49d68c3` minus the five dropped paths, with the same path rewrite applied outside
   `evidence/`, is empty apart from the guard files. `~/src/ergodis` `main` was fast-forwarded to
   the result (`37601a1`), then received the new `AGENTS.md`/`CLAUDE.md` and the `Cargo.toml`
   `exclude` of `CLAUDE.md` (`681d7c4`). Core gates pass on `main`.
5. **Private workspace.** `git filter-repo --subdirectory-filter ergodis-private` on a second
   clone (281 commits, no content rewrite); cloned to `~/src/ergodis-private`; one rewire commit
   points the six Cargo manifests, the notebook path helper (`ERGODIS_CORE_ROOT` override), the
   `test_alloc` include, the kernel registry (`ergodis/src/...`), and the documents at the sibling
   checkouts. `cargo build --workspace --all-targets --all-features` passes against `../ergodis`.
6. **Companions.** `ergodis-evidence` and `ergodis-contrib` are fresh repositories from the
   current tree; `cache-gc.sh` now locates siblings from its own path with `ERGODIS_ROOT` and
   `ERGODIS_NOTES_DIR` overrides.

## Decisions taken during execution

- **`evidence/` and `proptest-regressions/` stay on private `main`** and `ergodis-evidence` is a
  one-way export copy, rather than moving them out of the core. Moving them would have broken
  `python/generate_evidence.py --check` (the paper's canonical replay), the `SHA256SUMS`
  manifest, the checker scripts' defaults, and `cache-gc.sh`'s reference scan, and would have
  discarded the evidence history that pairs each benchmark row with the commit that produced it.
  `.publicignore` already drops both directories from every public export, so the public
  boundary is unchanged.
- The two companion repositories were kept separate as proposed: `ergodis-evidence` may be
  published per file; `ergodis-contrib` never is.
- `SHA256SUMS` stays in the core (it hashes core files as well as evidence); the evidence copy
  carries the same file for `sha256sum -c --ignore-missing`.

## Monorepo after the move

One commit removes `papers/complete-repair-ports/ergodis` and `ergodis-private` from the index,
drops the two `.gitignore` lines and the two `papers/repositories.toml` excludes, removes
`verification/check_ergodis_public.py` and its call from `verify_release.py`, trims the 92
`ergodis/` rows from the paper's distribution manifest, and points the paper README, the
verification README, the two `\texttt{ergodis/...}` references in
`sections/03a-exact-recovery-optimization.tex`, and the portfolio summary at
`https://github.com/tavisrudd/ergodis`. The paper's release verifier was rerun with
`--update-pdf` (result recorded below).

The standalone paper repository `~/src/math-papers/compositional-recovery` still tracks an
`ergodis/` tree from the last sync. The next `export-paper-repos.py sync` will refuse those
deletions; per `notes/export-and-mirror-conventions.md` they need an explicit `git rm -r ergodis`
commit in that repository before the sync. That is C953's step, not this task's.

## Promotions (C1055–C1057)

Landed in the new core on branches merged into `main` with `--no-ff` (`21ecf36`, `4ccc9a7`,
`aa34dd2`; branch tips `ae50268`, `4760457`, `5fcf8fc`); core gates rerun green on `aa34dd2`.
See the three task reports
`2026-09-02-c1055-binary-margin-lift-promotion.md`,
`2026-09-02-c1056-arithmetic-kernels-promotion.md`,
`2026-09-02-c1057-proof-scaffolding-promotion.md`.

## Validation

Fresh-clone validation of all four repositories (sixteen checks):
`2026-09-02-c1058-fresh-clone-validation.md`. Thirteen passed outright; the three failures were
repaired and committed afterwards:

- `python/generate_evidence.py --check` failed on missing files: six `c997` analyzers moved to
  `ergodis-private` on 2026-08-30 but stayed in the hashed-path list, so the paper's canonical
  replay was already broken in the monorepo. Entries removed and `SHA256SUMS` rewritten
  (`ergodis` `fbd3ba0`; `--check` now passes).
- `ergodis-evidence` carried the core's shared manifest, whose `README.md` line named the core
  README. It now has its own complete manifest over the copied files (`8260e94`).
- `scripts/lib.sh` in `ergodis-contrib` lacked a shell directive for shellcheck (`20bcd37`).

Final tips: `ergodis` `fbd3ba0` (core gates green after the three merges), `ergodis-private`
`c51a22a` (workspace build and all tests green against the sibling core), `ergodis-evidence`
`8260e94`, `ergodis-contrib` `20bcd37`. The paper release verifier passes after the monorepo
edits (37 pages, warning-free, 28 claims, 4 Lean terminals; PDF refreshed).

## Open items and successors

- **Public lint on the filtered private tree: 67 findings** (43 task-identifier tokens, 24
  private-path fragments) across about thirty files, led by `src/scheduler.rs`,
  `examples/negative_control_tier.rs`, `src/hall.rs`, and the `c1050`/`c1060`-named examples
  and Python drivers. That is the pre-release cleanup the release checklist already demands and
  the reason no export was attempted here.
- `scripts/export-public.sh` defaults `ERGODIS_SCRATCH` to a session-specific scratchpad path
  from the C1059 session; set `ERGODIS_SCRATCH` or change the default before the first export.
- GitHub branch protection, the first `git fetch origin` in the staging clone, and the first
  public export remain Tavis's actions (C1059 gaps 1, 2, 4).
- Evidence refresh into `ergodis-evidence` is manual (procedure in its `AGENTS.md`); a script
  and a tag-matching rule can follow once the first release is cut.
- `notes/queens-othello-perf-playbook.md` now has a copy in `ergodis-contrib`; edits to the
  shared playbook that matter to Ergodis must be forwarded there.
