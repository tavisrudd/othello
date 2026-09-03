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
  or contributor documents. Commit subjects on private main are therefore not rewritten.
- **Scope of C1058 includes the promotion track and documentation.** The pending promotions
  (C1054 hall_core, C1055 margin lift, C1056 arithmetic kernels, C1057 proof scaffolding) land in
  the new core repository, not the monorepo copy, once the split base is tagged; and each new
  repository gets its own `AGENTS.md` plus a `CLAUDE.md` symlink to it, a README, and the routed
  documents it owns (PERFORMANCE.md and the perf playbook extract in `ergodis-contrib`; the
  kernel registry and campaign docs in `ergodis-private`).
- **Monorepo after the move.** Cites the external repositories at tagged commits; no vendored
  copy. Companion names as proposed unless the executing review finds `ergodis-evidence` and
  `ergodis-contrib` better merged.

## Decisions originally raised

1. Names and visibility of the companions (`ergodis-evidence`, `ergodis-private`, `ergodis-contrib`
   as proposed, or fewer).
2. Whether commit subjects carrying `C<id>` task IDs are acceptable in the public history or should
   be rewritten to plain subjects during the replay.
3. Whether the monorepo keeps a read-only vendored copy of the core for paper builds, or the paper
   cites the external repository only.
