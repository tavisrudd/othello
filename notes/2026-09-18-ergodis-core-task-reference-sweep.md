# Ergodis core: othello-bookkeeping reference sweep (2026-09-18)

Read-only audit of `~/src/ergodis` for references to the private othello research
monorepo's bookkeeping (task IDs, notes paths, agent/model names, home paths) inside
tracked files. No edits, builds, or commits were made in that repository.

## Scope

- `git -C ~/src/ergodis ls-files | wc -l` → 682 tracked files.
- Per-top-level-directory counts: `git ls-files | awk -F/ '{print $1}' | sort | uniq -c`.
- All searches used `git -C ~/src/ergodis grep -n -I -E '<pattern>' -- <pathspec>`,
  scoped per top-level directory, tracked files only (no build trees, no `.git`).

Top-level directories (file counts): `src` 113, `evidence` 109, `crates` 95, `python` 88,
`scripts` 61, `wasm` 54, `examples` 49, `tests` 38, `docs` 27, `benches` 16, `staging` 4,
`docs-private` 3, `hooks` 2, plus 14 root files (`EXPORTS.md`, `.publicignore`,
`.public-lint-allow`, `.publication-profile`, `CLAUDE.md`, etc.).

## Class 1 — task IDs (`\bC[0-9]{3,4}\b`)

Command: `git grep -c -I -E '\bC[0-9]{3,4}\b' -- <dir>`, then bounded listings.

| Directory | Hits |
|-----------|-----:|
| crates    |   33 |
| tests     |   10 |
| all other |    0 |
| **Total** | **43** |

Representative lines:

```
crates/rules/src/demand.rs:90:   C1192, so a program the evaluator accepted before makes the same choice now.
crates/rules/src/demand.rs:108:  reaches. C1203 re-measured the crossover on the current kernel and found
crates/rules/src/demand.rs:1628: // so this is the `arity + 5` it was before C1193 split the former
crates/verify/src/datalog.rs:91: /// Until C1192 a universe above `2^30` was refused at admission, which capped
crates/rules/tests/demand_sparse.rs:278: evaluated rather than refused, which is the ceiling C1192 removed. Before
tests/publication-guards.sh:117: printf '# Contributor guide\n\nPrivate process, task C4242.\n' >"$PRIV/AGENTS.md"
```

All 10 `tests/` hits are in `tests/publication-guards.sh` only — synthetic fixture text
(`C4242`, `C1234`) that the guard-test suite writes into a throwaway private/staging repo
to verify the lint catches exactly this shape. Not violations (see false positives).

All 33 `crates/` hits are real task-ID references (`C1191`–`C1203`) in Rustdoc/`//` comments
in `crates/rules/src/demand.rs` (18), `crates/rules/tests/{allocation,demand_nary,
demand_prepared,demand_sparse,workspace_commit}.rs` (9), and `crates/verify/src/datalog.rs`
(2, plus 1 more not shown above), narrating which numbered task set or changed each
constant/behavior.

## Class 2 — othello notes paths / lane vocabulary

Patterns: `notes/20[0-9]{2}-[0-9]{2}-[0-9]{2}`, `notes/handoffs/`, `codex-task-queue`,
`discovery-track`, `othello`.

| Directory | Hits |
|-----------|-----:|
| crates    |    4 |
| scripts   |    6 |
| tests     |    1 |
| all other |    0 |
| **Total** | **11** |

Representative lines:

```
crates/rules/src/demand.rs:129: told; see `notes/2026-09-18-c1203-growing-index-crossover-report.md`.
crates/rules/src/demand.rs:156: `notes/2026-09-18-c1202-probe-count-index-rule-report.md`.
crates/rules/src/demand.rs:172: `notes/2026-09-18-c1202-probe-count-index-rule-report.md`.
crates/rules/src/demand.rs:2017: that held it. See `notes/2026-09-18-c1202-probe-count-index-rule-report.md`.
scripts/export-public.sh:156: s{(?:~|/home/[^/\s]+)/src/othello/papers/complete-repair-ports/ergodis/}{}g;
scripts/public-lint.sh:247: grep -oE 'othello|ergodis-private|ergodis-dev|ergodis-contrib|notes/|/home/' || true)
tests/publication-guards.sh:308: printf 'built under /home/tavis/src/othello\n' >"$PRIV/docs/paths.md"
```

The 4 `crates/rules/src/demand.rs` hits are the worst finding in this audit: exact
filenames of othello-repo notes reports (`notes/2026-09-18-c1203-growing-index-crossover-
report.md`, `notes/2026-09-18-c1202-probe-count-index-rule-report.md`) are named directly
in Rustdoc comments as "see" references, in a file that ships publicly (see Export
Exposure). The 6 `scripts/` hits and the 1 `tests/` hit are the lint/rewrite tooling's own
pattern lists and a guard-test fixture — not violations (see false positives).

## Class 3 — home paths / agent-model names / date-as-provenance

### 3a. Absolute home / cache paths (`/home/tavis`, `~/src/`, `~/\.cache`)

| Directory     | Hits |
|---------------|-----:|
| docs-private  |   16 |
| tests         |    5 |
| scripts       |    3 |
| root files    |    3 |
| all other     |    0 |
| **Total**     | **27** |

All sampled hits are legitimate ergodis process vocabulary describing its own
private/staging/evidence repo layout (`~/src/ergodis`, `~/src/ergodis-public`,
`~/src/ergodis-evidence*`, `~/.cache/ergodis/target/ergodis`) in `docs-private/README.md`
(excluded from export), `AGENTS.md` (excluded), `.cargo/config.toml` (excluded via
`.publicignore`'s `.cargo/` rule... actually matched via top-level `.cargo/config.toml`,
covered by the bulk-artifacts `.cargo/` line), `.publication-profile` (excluded), and
`scripts/configure-remotes.sh` / `scripts/dominance-retained-ab.sh` (guard tooling,
excluded). `tests/publication-guards.sh` hits (5) are fixtures simulating the leak the
guard should catch, including one literal `/home/tavis/src/othello` string used as test
input. No othello-repo home-path leak was found outside that one deliberate test fixture.

### 3b. Agent/model names (`Opus|Sonnet|Claude|Codex|sub-agent|subagent`)

| Directory     | Hits |
|---------------|-----:|
| docs-private  |    1 |
| all other     |    0 |
| **Total**     | **1** |

```
docs-private/README.md:125: Agents export and stop. Publication is Tavis's action, and the Claude Code
```

`docs-private/` is excluded from every public export by `.publicignore`, and the sentence
is about the export workflow's own actor, not an othello attribution leak. No hits in any
shipped source.

### 3c. Date-as-provenance in `.rs` comments (`20[0-9]{2}-[0-9]{2}-[0-9]{2}`)

| Directory | Hits |
|-----------|-----:|
| crates    |    6 |
| all other |    0 |
| **Total** | **6** |

4 of the 6 are the same `notes/2026-09-18-...md` filenames already counted in Class 2.
The other 2 are new:

```
crates/rules/tests/allocation.rs:310: four times the fact count changes nothing. Measured 2026-09-16: 19 at
crates/rules/tests/allocation.rs:328: Measured 2026-09-16: 578, 1,094 and 2,122 against the prepared path's
```

Dated measurement-episode narration in a shipped test file, without a task ID but with
the same "measured on this date" provenance shape the rule flags.

### Filenames

`git ls-files | grep -iE 'c[0-9]{3,4}'` → no matches. No file name encodes a task ID.

## Class 4 — process notes in source comments (judgment-based)

New scope added mid-audit: Ergodis comments/docstrings should read like PostgreSQL's
(mechanism, invariants, caller obligations, timeless design rationale), not narrate
measurement episodes, variant history, or audits. Patterns are inherently noisy (words
like "report", "rejected", "receipt", "repair" are also ordinary API/domain vocabulary
in this codebase), so counts below are raw pattern hits on comment lines only
(`^\s*(///|//!|//)` for `.rs`, `^\s*#` for `.py`/`.sh`), followed by sampled,
judgment-based true-positive estimates. Treat every count in this section as an upper
bound requiring human judgment, not a violation count.

Pattern (case-insensitive, comment lines only):
`measured|against the control|A/B|A/A|regression of [0-9]|kept by measurement|first
landing|was tried|rejected|reverted|instructive negative|used to |previously|no
longer|audit|review found|repair|Fermi|report|receipt`

### Raw comment-line hits per top-level directory

| Directory        | Raw hits |
|-------------------|--------:|
| crates             |      88 |
| src                |       9 |
| scripts+hooks+tests |      2 |
| python             |       0 |
| wasm/examples/benches/docs |  0 |
| **Total**          |  **99** |

### Per-file breakdown and sampled true-positive judgment

| File                                                | Raw | Est. true positives | Basis |
|------------------------------------------------------|----:|---------------------:|-------|
| `crates/rules/src/demand.rs`                          |  41 | ~35–38               | Dense, genuine process narration: "C1192 set this ... measured", "re-measured the crossover", "measured rather than reasoned", benchmark-cohort names (`mutual:blocks:4096`, `triangle:blocks:4096`) used as provenance. Worst file by far. |
| `crates/rules/tests/demand_sparse.rs`                 |   7 | ~6                   | "Fermi predicted", "measured crossover", "measured faster", "measured the build" — explicit measurement-episode narration. |
| `crates/rules/src/pages.rs`                           |   5 | ~3                   | "Measured on the demand...", "comparison arm the change is measured against", "chunk headers used to scatter" (variant history). "measured rather than assumed" is borderline design-rationale phrasing. |
| `crates/runtime/tests/lineage_properties.rs`          |   5 | 0                    | All "reported"/"rejected" are ordinary API-behavior description (what the readout returns, what the call rejects), not process narration. |
| `crates/runtime/src/repository.rs`                    |   5 | 0                    | "receipt" is a domain object name (request receipt), "reports" is a getter description. Domain vocabulary, not audit narration. |
| `crates/rules/tests/allocation.rs`                    |   3 | 2                    | Contains the two dated "Measured 2026-09-16: ..." lines from Class 3c. |
| `crates/rules/tests/{boolean,contracts,contract_properties,demand,demand_nary,density_control,properties,provider_properties,support,support/density,workspace_commit}.rs` | 1–2 each (13 total) | ~3 | Mostly "rejected" as validation semantics (false positive). True positives: `density_control.rs:49` ("an A/B between them"), `support/density.rs:116` ("the A/B control for the sparse evaluator"), `workspace_commit.rs:45` ("the measured lane (`cycle` at the `blocks`...)" — benchmark-cohort-as-provenance). |
| `crates/verify/*.rs` (5 files)                        |   6 | 0                    | All "rejected"/"reporting"/"used to" are ordinary verifier semantics description, not history. |
| `crates/runtime/{bundle_workflow,campaign,repository_journal,run_bundle,service}.rs` | 6 | 0 | Domain vocabulary ("report", "receipt", "rejected") describing runtime types/behavior. |
| `crates/runtime/tests/update_properties.rs`           |   2 | 0                    | "rejected request" (API semantics), "measured replay" reads as a named domain concept, not an episode. |
| `crates/rules/examples/{lean_boundary_fixtures,replay_profile}.rs` | 2 | 0 | "rejected"/"measured" describe what the example does, not history. |
| `src/arithmetic/{mod,subgroup,two_adic}.rs`           |   5 | 1                    | Mostly "reports" as a return-value description (false positive). `two_adic.rs:186` ("...47% more cycles, measured.") is a bare unprovenanced performance claim — borderline true positive. |
| `src/bin/{ergodis,ergodisctl}.rs`                     |   4 | 0                    | "Repair"/"Report" are product feature names / CLI verbs (domain vocabulary), not process narration. |
| `src/control/evolution.rs`                            |   2 | 1                    | `evolution.rs:3882` ("the old false-positive-first gate rejected...") narrates a superseded design — true positive (variant history). |
| `hooks/pre-push`                                      |   2 | 0                    | "rejected outright" is push-guard semantics, not process narration. |

**Estimated total true positives across Class 4: roughly 50–53 of 99 raw hits**, concentrated
almost entirely in three files: `crates/rules/src/demand.rs` (~35–38),
`crates/rules/tests/demand_sparse.rs` (~6), and scattered singles elsewhere. The remaining
~46–49 hits are false positives from "report"/"rejected"/"receipt"/"repair" used as ordinary
Rust-API and domain vocabulary — the same words the codebase uses for its own runtime
semantics (a request is "rejected", a value is "reported", a "receipt" is a stored
artifact type). This class needs a human/second pass on the demand.rs and demand_sparse.rs
concentration before any rewrite; do not treat the raw 99 as a violation count.

## Export exposure

`.publicignore` excludes (from every public export): `AGENTS.md`, `CLAUDE.md`,
`PERFORMANCE.md`, `EXPORTS.md`, `RELEASE-CHECKLIST.md`, `docs-private/`, `hooks/`,
`staging/`, `.claude/`, the lint config files themselves, all guard-tooling scripts
(`scripts/public-lint.sh`, `export-public.sh`, `publish.sh`, `publish-to-staging.sh`,
`install-hooks.sh`, `configure-remotes.sh`, `publication-profile.sh`), `tests/publication-
guards.sh`, `evidence/`, `proptest-regressions/`, `.cargo/`.

**`crates/` is not excluded** — it ships in the public export as-is. This means every
Class 1/2/3c hit in `crates/rules/src/demand.rs`, `crates/rules/tests/*.rs`, and
`crates/verify/src/datalog.rs` is currently sitting in code that would be exported to the
public repository. `src/` is likewise not excluded, so the two marginal Class 4 hits in
`src/arithmetic/two_adic.rs` and `src/control/evolution.rs` also ship.

## Existing lint coverage and gaps

`scripts/public-lint.sh` already implements a `task-id` rule
(`\bC[0-9]{2,4}\b`, case-insensitive, wider than this audit's `{3,4}`) and a `private-path`
rule (`othello|ergodis-private|ergodis-dev|ergodis-contrib|notes/|/home/`), both content
rules that scan every text file, plus a path-only `process-doc` rule and an `oversize`/
`generated` rule. `.public-lint-allow` exempts specific tokens (`C99`, `C11`, `C17`) and
path-scoped private-path markers.

**Enforcement gap (by design, not a bug):** `hooks/pre-commit` only runs the content
rules (task-id, private-path) when `HEAD`'s branch is `public`; on `main` (the working
branch this audit ran against) it runs only the path-based `generated`-artifact check.
The content lint is deferred to `scripts/export-public.sh` and
`scripts/publish-to-staging.sh`, both of which do invoke `public-lint.sh` on the tree
being exported/staged and would `die`/refuse on any of it.

**Practical consequence:** the 43 Class 1 + 11 Class 2 + 2 Class 3c hits in `crates/` are
real, currently un-flagged content on `main` that **would currently fail
`export-public.sh`'s lint gate** the next time an export is attempted, because `crates/`
is not in `.publicignore` and none of these tokens (`C1192`...`C1203`, the two
`notes/2026-09-18-*.md` filenames, `2026-09-16`) are in `.public-lint-allow`. The lint is
not blind to this class — it would catch it at export time — but nothing has forced that
gate yet on `main`, so the comments have accumulated.

**Class 4 (process-notes-in-comments) has no lint coverage at all.** `public-lint.sh`'s
task-id and private-path rules do not match "measured", "Fermi", "A/B", "used to", etc.,
so the whole class is currently unenforced at any commit or export stage, on any branch.

## Probable false positives (not counted as violations above)

- `tests/publication-guards.sh` (10 Class-1, 1 Class-2, 5 Class-3a hits): synthetic fixture
  strings (`C4242`, `C1234`, `/home/tavis/src/ergodis-private`, `/home/tavis/src/othello`,
  `~/src/ergodis-public`) that the guard test suite writes into throwaway repos specifically
  to verify `public-lint.sh` catches this shape. The file itself is excluded from export.
- `scripts/public-lint.sh`, `scripts/export-public.sh` (Class 2, 7 hits): the guard's own
  pattern lists and monorepo-path-rewrite regex — necessarily contain the literal strings
  `othello` and `notes/` to detect and rewrite them. Excluded from export.
- `docs-private/README.md`, `AGENTS.md`, `.cargo/config.toml`, `.publication-profile`,
  `scripts/configure-remotes.sh`, `scripts/dominance-retained-ab.sh` (Class 3a, 24 hits):
  legitimate references to ergodis's own private/staging/evidence repo paths and build
  cache, not othello-repo paths. All excluded from export except
  `scripts/dominance-retained-ab.sh` (a benchmark script referencing its own
  `~/.cache/ergodis/bin`, unrelated to othello).
- `docs-private/README.md:125` (Class 3b, 1 hit): "the Claude Code Agents export and stop"
  describes the export workflow's actor, not attribution inside a comment.
- Class 4: the majority of "rejected"/"reported"/"receipt"/"repair" hits across
  `crates/verify/*`, `crates/runtime/*`, `src/bin/*`, `hooks/pre-push` — ordinary Rust-API
  and domain vocabulary (validation rejection, return-value reporting, a "receipt" domain
  type, "repair" as the product's own subject matter), not process narration.
- No hex/colour/hash-string or vendored-text false positives were found for Classes 1–3;
  the task-ID pattern's word-boundary anchoring didn't pick up any such collisions in this
  sweep.

## Surprising findings

1. `crates/rules/src/demand.rs` directly cites two othello-repo report filenames by full
   path (`notes/2026-09-18-c1203-growing-index-crossover-report.md`,
   `notes/2026-09-18-c1202-probe-count-index-rule-report.md`) as "see" references in
   Rustdoc — a strictly worse leak shape than a bare task ID, since it hands a reader the
   exact private-repo path, dated the same day as this audit's own C1203/C1202 work.
2. The public-lint content rule is real, thorough, and already covers Classes 1–3
   (with a wider task-id pattern than this audit used), but is deliberately not run on
   `main`'s ordinary commits by design — so `main` can and did accumulate 45+ tokens that
   would currently fail export, sitting undetected until an export/publish run.
3. Class 4 (process-notes-in-comments) is almost entirely concentrated in one file,
   `crates/rules/src/demand.rs`, which is also the worst offender for Classes 1–3. That
   file's doc comments read as a first-person account of the C1191–C1203 task sequence
   rather than as timeless design rationale, and it ships publicly today.
4. No leaks at all were found in `python/`, `wasm/`, `examples/`, `benches/`, `docs/`, or
   `src/` (with two marginal Class-4 exceptions) — the leak surface is narrow and
   concentrated, not diffuse.
