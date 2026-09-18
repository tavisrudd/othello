# Ergodis private + dev: task-reference and process-narration sweep (2026-09-18)

Read-only audit of `~/src/ergodis-private` and `~/src/ergodis-dev` for the same violation
classes as the sibling core-repo sweep (`notes/2026-09-18-ergodis-core-task-reference-sweep.md`),
whose structure and method this report reuses. No edits, stages, commits, builds, or deletes
were made in either repository. Both repositories are private with no public remote.

## Scope and commands

- `git -C ~/src/ergodis-private ls-files | wc -l` -> 2100 tracked files.
  `git -C ~/src/ergodis-dev ls-files | wc -l` -> 9 tracked files.
- Source pathspec (both repos): `*.rs *.py *.sh *.toml *.nix Makefile */Makefile`, matched
  repo-wide with `git grep -c/-n -I -E '<pattern>' -- <pathspec>` (never a bare directory
  pathspec combined with an extension pathspec in the same call — that unions rather than
  intersects; a directory-scoped search used `<dir>/*.ext <dir>/**/*.ext` pairs per extension).
- Counts first via `git grep -c ... | awk -F: '{s+=$2} END{print s}'`, then bounded listings
  (`| cut -c1-160`, `| head -n <=40`).
- Class 4 (process narration) restricted to comment lines only: `^\s*(///|//!|//)` for `.rs`,
  `^\s*#` for `.py`/`.sh`.
- Checked for pre-commit hooks / lint: `ls .git/hooks/`, and a search for `*lint*`,
  `.publicignore`, `.pre-commit*` at each repo root.

### ergodis-private top-level source-file counts (source extensions only, per directory)

| Directory | rs+py+sh+toml+nix+Makefile files |
|-----------|----:|
| src         | 226 |
| analysis    | 168 |
| tasks       | 148 |
| python      |  52 |
| tests       |  43 |
| packages    |  30 |
| scripts     |  25 |
| experiments |   8 |
| evidence    |   7 |
| benchmarks  |   5 |
| controls    |   3 |
| performance |   2 |
| examples    |   1 |
| root        |   1 (Cargo.toml) |

`ergodis-dev` has 4 source files, all under `scripts/` (`cache-gc.sh`, `lib.sh`,
`retain-bin.sh`, `test-cache-gc.sh`); the other 5 tracked files are contributor documents
(`AGENTS.md`, `CLAUDE.md`, `PERFORMANCE.md`, `README.md`, `performance-playbook.md`).

## ergodis-private: Class 1 — task IDs (`\bC[0-9]{3,4}\b`)

| Area                                  | Hits |
|----------------------------------------|----:|
| tasks/ (task crates)                    | 108 |
| src/ (core algorithms, non-rel)         |  46 |
| python/                                 |  30 |
| scripts/                                |  21 |
| tests/                                  |  17 |
| analysis/ (measurement scripts)         |  13 |
| examples/                               |   8 |
| root (Cargo.toml)                       |   1 |
| Rel frontend/lowering (`src/rel_*`)     |   0 |
| packages/, controls/, experiments/, benchmarks/, performance/, lean/ | 0 |
| **Total**                                | **244** |

Representative lines:

```
tasks/tools/src/main.rs:100:    /// C1062 probe 1: causal lowering cost model, towers, and separators.
examples/closure_ballpark.rs:13://! relation (C1192); and `triangle`, `path3` and `path4`, whose bodies are
src/tiger_blossom_graph.rs:137:/// unchanged from C1192, and `blocks<N>`
scripts/tiger_blossom_ab.py:<n>: (6 hits, task-ID-tagged cohort names)
python/run_gurobi.py: (5 hits)
tasks/tools/src/actual_cause_report.rs:1://! C1062 probe 2: best intervention over the monoid action ...
```

Two **source filenames** themselves embed a task ID (a stronger violation shape than a
comment mention — the ID is load-bearing in the identifier):
`scripts/c1070-probe9-ironmask-ni.sh`, `python/c1062_design_oracle.py`.

## ergodis-private: Class 1b — "probe N" shadow task-ID vocabulary (new finding, not in the given patterns)

Not part of the audited pattern list, but functionally identical to a task ID: `\bprobe
[0-9]+\b` (case-insensitive) is used pervasively as an informal numbered reference to a
specific investigation, often standing in for or alongside a C-number.

| Area   | Hits |
|--------|----:|
| src/   | 123 |
| tasks/ |  98 |
| all other | 0 |
| **Total** | **221** |

Concentrated in `src/leakage.rs` (20), `tasks/tools/src/summary_cache_bench.rs` (24),
`tasks/tools/src/main.rs` (20, overlapping with its Class-1 C1062 hits), and spread across
~40 other files (`leakage_structure_report.rs`, `leakage_design.rs`, `summary_cache.rs`,
`margin_certificate.rs`, `leakage_structure.rs`, `predecoder_pipeline.rs`, `causal_fixtures.rs`,
etc.). Sampled lines confirm the pattern is a numbered-investigation reference, not a
coincidental use of the English word "probe":

```
src/leakage.rs:184:    /// Probe 3: Pareto antichains, when the units carry vector costs.
src/leakage.rs:191:    /// Probe 6: transcript state, with the mask-reuse alarms.
src/margin_certificate.rs:4://! Probe 29's certificate intersects the optimal-action set over every crossing
src/summary_cache.rs:4://! Probe 5 left two redirects. First, its leaf memo was keyed on the raw
```

This is the single largest un-audited leak surface found: 221 raw hits functioning exactly
as Class-1 task references but invisible to a `\bC[0-9]{3,4}\b` scan.

## ergodis-private: Class 2 — othello notes paths / lane vocabulary

Pattern: `notes/20YY-MM-DD`, `notes/handoffs`, `codex-task-queue`, `discovery-track`,
`\bothello\b` (word-bounded; the generic English word "handoff" was tested separately and
excluded — see false positives).

| Area                              | Hits |
|-------------------------------------|----:|
| src/ (of which 14 are `notes/20..md` citations, 6 are `handoff` false positives already excluded) | 20 |
| scripts/ (`../othello/lean/...` cross-repo paths)  | 12 |
| tasks/                               |  7 |
| python/ (`notes/20..json` source-file references)  |  5 |
| evidence/                            |  3 |
| analysis/                            |  2 |
| all other                            |  0 |
| **Total**                            | **49** |

Split by sub-pattern: `notes/20YY-MM-DD` citations = 34, bare/path `othello` = 15
(`discovery-track`/`codex-task-queue`/`notes/handoffs` = 0).

Representative lines:

```
src/actual_cause.rs:103:    /// certify.  Recorded in `notes/2026-09-05-c1062-probe3-review.md`
src/causal.rs:232:        // `notes/2026-09-05-c1062-probe1-review.md`.
evidence/certdist/scripts/certdist-build-shim-Cargo.toml:14:path = "/home/tavis/src/othello/ergodis-private/src/bin/certdist.rs"
scripts/privacy_lean_evidence.py:21:    "../othello/lean/WeightedRules/FiniteTableImport.lean",
tasks/tools/src/leakage_structure_report.rs:31:    default_value = "../othello/notes/data/2026-09-06-c1070-probe5"
```

`src/actual_cause.rs`, `src/causal.rs`, `src/causal_counterfactual.rs`, `src/causal_fixtures.rs`,
`src/causal_sequential.rs`, and their `tasks/tools/src/causal_*_report.rs` counterparts cite
exact othello-repo report filenames (`notes/2026-09-05-c1062-probe{1,3,4,8}-review.md`,
`notes/2026-09-05-c1062-probe3-wide-domain-and-amortization.md`) repeatedly as "see"/"recorded
in" references — the same worst-case leak shape the core sweep found concentrated in one file
(`crates/rules/src/demand.rs`), but here spread across at least 8 files.

`evidence/certdist/scripts/certdist-build-shim-Cargo.toml` is the most severe single hit: it
is not just a comment, it is a live Cargo path dependency —
`path = "/home/tavis/src/othello/ergodis-private/src/bin/certdist.rs"` — meaning a **build
file** hard-depends on an absolute path inside the othello monorepo.

## ergodis-private: Class 3

### 3a. Home / cache paths (`/home/tavis`, `~/src/`, `~/.cache`)

| Area       | Hits |
|------------|----:|
| analysis/  |    7 |
| python/    |    6 |
| evidence/  |    3 |
| tasks/     |    2 |
| .cargo/    |    1 |
| all other  |    0 |
| **Total**  | **19** |

Almost all are legitimate self-references to ergodis's own build cache
(`~/.cache/ergodis/...`, `~/src/ergodis-private`) or path-leak-detection markers in
`analysis/module-loading/{distribution-audit,refresh-provider}.py` (these scripts intentionally
embed the string `/home/tavis` to *check for* its leakage into build artifacts — a legitimate
domain use, not a violation). The two real violations are the same
`evidence/certdist/scripts/certdist-build-shim-Cargo.toml` lines already flagged in Class 2
(a comment and a live `path =` dependency naming `/home/tavis/src/othello/...`).

### 3b. Agent/model names (`Opus|Sonnet|Claude|Codex|sub-agent|subagent`)

Zero hits anywhere in `ergodis-private` source.

### 3c. Dates as provenance in comments

| Language        | Hits (comment lines only) |
|------------------|----:|
| `.rs`             |  49 |
| `.py`/`.sh`       |   1 |
| **Total**         | **50** |

35 of the 50 are the same `notes/2026-...md` filename citations already counted in Class 2.
The remaining ~15 are dated design-decision or measurement-episode narration without a
`notes/` filename attached, concentrated in the Rel frontend/lowering area:

```
src/rel_frontend/lower.rs:598:/// The default is [`BodyPolicy::Nary`] since 2026-09-17, by Tavis's decision on
src/rel_frontend/lower/build.rs:1701:    // its end. Until 2026-09-15 the top level was probed first here, so a
tests/rel_lowering.rs:271:/// The audit of 2026-09-15 recorded that admission cannot distinguish the
tests/rel_reference_eval.rs:433:/// The five further programs the 2026-09-15 milestone (a) audit devised and ran
tasks/gem-hunt/src/prs_census.rs:37://! element-labelling hazard of the 2026-08-30 report cannot recur.
```

`src/rel_frontend/lower.rs:598` and `:613` name a specific person ("by Tavis's decision") as
provenance for a default value — this is both a dated and an attributed-to-a-person process
note, a shape not explicitly listed in the audited pattern but squarely inside the rule's
intent (no process narration in source).

### Filenames

`git ls-files | grep -iE 'c[0-9]{3,4}'` (source extensions only) -> 2 hits, both already noted
under Class 1 (`scripts/c1070-probe9-ironmask-ni.sh`, `python/c1062_design_oracle.py`).

## ergodis-private: Class 4 — process narration in comments (judgment-based)

Same pattern as the core sweep:
`measured|against the control|A/B|A/A|regression of [0-9]|kept by measurement|first
landing|was tried|rejected|reverted|instructive negative|used to |previously|no
longer|audit|review found|repair|Fermi|report|receipt`, comment lines only.

### Raw hits by area

| Area                                    | Raw hits |
|-------------------------------------------|-----:|
| tasks/ (task crates)                       |  703 |
| src/ (core algorithms)                     |  498 |
| tests/                                     |   50 |
| analysis/ (measurement scripts)            |   29 |
| examples/                                  |    9 |
| packages/                                  |    7 |
| scripts/                                   |    3 |
| python/                                    |    1 |
| all other                                  |    0 |
| **Total**                                  | **1300** |

This raw total is dominated by two words that are overwhelmingly **domain vocabulary, not
process narration, in this codebase specifically**: "repair" (locally-repairable/LRC codes,
QEC decoders, tree-repair paths — the product's own subject matter) and "report" (the tool's
own computed output struct, or a `*_report.rs` binary's name). A 35-line stratified sample
across `tasks/` and `src/` found roughly 3-4 true positives per 35 "report"/"repair" hits
(~10%), all of the true-positive shape "see the report"/"the probe report" (a bare allusion
to an external write-up with no filename) rather than the word itself:

```
src/hierarchical_leakage.rs:28://! module by construction; see the probe report for what a mask layer would
tasks/gem-hunt/src/parametric_cert.rs:8://! (see the report) because the `ergodis-private` library does not
tasks/gem-hunt/src/prs_stratum.rs:5://! no rank deficiency to exploit (see the report's Part 1).
tests/predecoder_certificate_probes.rs:6://! ignored so the numbers in the C1069 report can be reproduced:
```

Excluding "report"/"repair", the higher-signal words narrow the field sharply:

| Area                                    | High-signal hits (excl. report/repair) |
|-------------------------------------------|-----:|
| src/                                       |  220 |
| tasks/                                     |  175 |
| tests/                                     |   33 |
| analysis/                                  |   19 |
| examples/                                  |    8 |
| packages/                                  |    7 |
| scripts/                                   |    1 |
| **Total**                                  | **463** |

### Per-file breakdown and sampled true-positive judgment (top offenders)

| File                                             | Raw (high-signal) | Est. true positives | Basis |
|----------------------------------------------------|----:|---:|-------|
| `tasks/tools/src/main.rs`                            | 55 | ~55 | Every registered CLI subcommand's doc comment is a bare `C1062 probe N: ...` task/investigation description — this text also becomes the tool's `--help` output (violation class 3, "help/error strings"). |
| `tasks/tools/src/summary_cache_bench.rs`              | 28 | ~26 | Dense: "Measures the probe 6 acceleration", "Probe 2 re-measurement: ...", repeated per benchmark arm. |
| `src/tiger_blossom_graph.rs`                          | 21 | ~15 | "Measured, not derived, and fitted on crossover sweeps"; reports specific measured crossover values ("eight or ten", "fourteen or sixteen") in doc comments rather than stating the invariant the values encode. |
| `src/leakage.rs`                                      | 21 | ~20 | Every "Probe N" hit here doubles as the file's organizing structure — sections are literally named by probe number. |
| `src/sparse_margin_predecoder.rs`                     | 17 |  ~7 | 4 explicit probe/date references are true positives (`probe 30's ... metric closure`); the remaining "audit" hits are the module's own algorithm step (`audit the margin certificate with the matching oracle`) — domain vocabulary, false positive. |
| `examples/closure_ballpark.rs`                        | 15 | ~14 | Cites C1179/C1192/C1193/C1201/C1202/C1170 and narrates "confound the A/B against the retained control" — this file ships as a runnable `cargo run --example`, so its narration is the most exposed of any file sampled. |
| `src/tiger_blossom_sparse.rs`                         | 14 | ~10 | Same measured-crossover-calibration narration style as `tiger_blossom_graph.rs`. |
| `src/causal_fixtures.rs`                              | 13 | ~11 | Repeated `notes/2026-09-05-c1062-probe4-review.md` / `probe3-wide-domain...` citations. |
| `tests/rel_lowering.rs`                               | 12 | ~10 | "The audit of 2026-09-15 recorded that admission cannot distinguish..."; dated milestone narration. |
| `tasks/tools/src/rel_frontend_bench.rs`                | 12 | ~10 | "since 2026-09-17. A receipt taken before that date replays under..." — dated + "receipt" narration. |
| `src/rel_frontend/lower.rs`                            | 11 | ~8  | "since 2026-09-17, by Tavis's decision" (dated + person-attributed default); "Until 2026-09-15 the top level was probed first here" (variant history). |
| `tasks/tools/src/leakage_structure_report.rs`         |  9 |  ~8 | "C1070 probe 2: is the t-symbol leakage profile obtainable..."; "Probe 5's six committed reports under `notes/data/2026-09-06-c1070-probe5/`". |
| `src/summary_cache.rs`                                |  9 |  ~8 | "Probe 5 left two redirects"; "probe 2 had separately measured that...". |
| `src/predecoder_pipeline.rs`                          |  9 |  ~8 | "The local-commit contract (probe 29)"; "the margin certificate (probe 30) proves"; "probe 31's oracle stopped at surface distance 3". |
| `tasks/tools/src/incremental_certificate_bench.rs`    |  7 |  ~6 | "measured emit/verify region"; "Commitment backends available for the A/B." |
| `src/rel_frontend/lexer.rs`                            |  7 |  ~6 | Cites specific receipt filenames: `` receipt `performance-v1-keyword-2840757.json` ``. |
| `src/margin_certificate.rs`                            |  7 |  ~6 | "Probe 29's certificate intersects..."; "The measured consequence was a step". |
| `src/leakage_design.rs`                                |  7 |  ~6 | "C1070 probe 7: legitimate versus illegitimate recoverability..."; "everywhere in C1070". |
| `src/causal.rs`                                        |  7 |  ~6 | `notes/2026-09-05-c1062-probe1-review.md` citations; "This is the plan's third correctness gate for probe 1". |
| `src/causal_design.rs`                                 |  7 |  ~6 | "the overcount can be measured rather than asserted"; "probe 2's `best_intervention`". |
| `tasks/tools/src/closed_form_audit.rs` / `family_audit.rs` (not in top 20 by count, flagged for contrast) | 48 / 19 | ~3 / ~1 | Mostly false positive: "audit" is the tool's own name/purpose ("Hostile audit of the closed-form replacement..."), a legitimate verification-tool description, not process narration — analogous to core sweep's `crates/verify/*.rs` "rejected"/"reported" false positives. |

**Estimated total true positives across Class 4 in `ergodis-private`: roughly 230-260 of the
463 high-signal raw hits**, overwhelmingly probe-N / C-number / dated-decision narration
rather than the audited pattern's "measured"/"A-B"/"audit" vocabulary in isolation — i.e. the
real signal in this repo is Class 1b (probe-N) co-occurring with Class 4 words, not Class 4
alone. Excluding "report"/"repair", true positives concentrate in `src/` (task-algorithm
modules named after their originating probe: `leakage*.rs`, `causal*.rs`, `margin_certificate.rs`,
`summary_cache.rs`, `predecoder_pipeline.rs`, `tiger_blossom_*.rs`) and their `tasks/tools/src/`
CLI counterparts, plus the Rel frontend/lowering files below.

### Area: Rel frontend and lowering (`src/rel_frontend/**`, `src/rel_lowering.rs`, `src/rel_stratified.rs`)

| Class            | Hits |
|-------------------|----:|
| Class 1 (C-ids)                    | 0 (none directly; `analysis/rel-frontend/*.rs` is a separate, non-shipped analysis dir, see below) |
| Class 1b (probe-N)                 | 0 |
| Class 2/3c (notes/dates, comments) | `src/rel_frontend/lower.rs` (1 dated decision + 1 variant-history), `src/rel_frontend/lower/build.rs` (1 variant-history), `analysis/rel-frontend/token-store-probe.rs` (1 `notes/2026-09-14-c1170...` citation) |
| Class 4 high-signal                | `lower.rs` 11, `lexer.rs` 7, `admit.rs` (has `C1170, 2026-09-14` inline), `lower/passes.rs` 1, `lower/build.rs` 2 |

This area is smaller than `src/`'s causal/leakage/tiger-blossom modules but shows the same
pattern in miniature: dated, person-attributed design decisions ("by Tavis's decision") and
"receipt `<hash>.json`" citations sit in the same doc comments as the algorithm's actual
contract.

### Area: task crates under `tasks/`

`tasks/tools/` (79 files) is the worst concentration in the whole repo: it is a CLI binary
whose subcommand registry (`main.rs`) and most `*_report.rs`/`*_bench.rs` files are literally
task deliverables — each doc comment identifies which numbered probe or C-number the tool was
built to answer. `tasks/hadamard-2092/` (57 files) and `tasks/gem-hunt/` (12 files) contribute
far fewer hits (Class 1: 1 hit in `tasks/hadamard-2092/src/main.rs`; two "see the report"
allusions in `gem-hunt`).

### Area: measurement scripts (`analysis/**.py`, `analysis/**.sh`, `scripts/**`)

| Class      | analysis/ | scripts/ |
|------------|----:|----:|
| Class 1     |  13 |  21 |
| Class 2     |   2 |  12 |
| Class 3a    |   7 |   0 |
| Class 4 (high-signal) | 19 |  1 |

`scripts/`'s Class 2 hits are entirely the `../othello/lean/...` cross-repo path list in
`scripts/privacy_lean_evidence.py`, `scripts/benchmark_incremental_lean.py`, and
`scripts/check_privacy_lean.sh` — these locate the othello monorepo's Lean proofs from a
sibling checkout and are functionally load-bearing, not accidental narration, but they are
still a literal "~/src/othello"-shaped path allusion under the audited rule.

### Area: tests

| Class      | Hits |
|------------|----:|
| Class 1     | 17 |
| Class 2     |  0 |
| Class 3c    |  0 (beyond Class-4 overlap) |
| Class 4 (high-signal) | 33 |

`tests/rel_lowering.rs` and `tests/rel_reference_eval.rs` carry most of the Class 4 weight
(dated "2026-09-15 audit/milestone" narration); `tests/predecoder_certificate_probes.rs`
explicitly names "the C1069 report" in a test doc comment.

## ergodis-private: data and documents (not violations)

Per the scope notes, `analysis/**` and `evidence/**` data/evidence outputs and dated Markdown
reports are not source and are not counted as violations. One-line counts of non-source
extensions (`.json .jsonl .tsv .csv .md .log .txt .html .report .gz`) per top-level directory:

| Directory   | Data/doc files |
|-------------|----:|
| analysis    | 671 |
| evidence    | 374 |
| benchmarks  |  83 |
| examples    |  25 |
| packages    |   9 |
| docs        |   5 |
| performance |   2 |
| experiments |   2 |
| controls    |   2 |
| tests       |   1 |
| root (README/CLAUDE/AGENTS.md) | 3 |

### File names embedding a task ID (data/document files, not source)

| Directory                     | Files |
|---------------------------------|----:|
| analysis/datalog-comparison      | 122 |
| analysis/external-benchmarks      | 68 |
| benchmarks/tiger-blossom          | 48 |
| analysis/rel-frontend              | 10 |
| analysis/campaign-console            | 1 |
| evidence (`evidence/c1062-design-tables.json`) | 1 |

Sample: `analysis/datalog-comparison/ab-2026-09-16-c1192-cache-cycle.json`,
`benchmarks/tiger-blossom/2026-09-04-c1063-6b6999a-vs-pymatching-eighteen-cells.log`. This is
expected and legitimate for dated A/B receipts and campaign artifacts; flagged here only per
the scope note so the owner can decide on a naming convention if wanted.

## ergodis-dev

All 4 source files (`scripts/cache-gc.sh`, `scripts/lib.sh`, `scripts/retain-bin.sh`,
`scripts/test-cache-gc.sh`) were checked against every class:

| Class                                | Hits |
|----------------------------------------|----:|
| 1 (task IDs)                             | 0 |
| 1b (probe-N)                             | 0 |
| 2 (notes/othello)                        | 0 |
| 3a (home paths)                          | 1 — `scripts/lib.sh:10`, a default `ERGODIS_CACHE_ROOT=/home/tavis/.cache/ergodis` value; self-referencing build-cache default, false positive (same shape as the core sweep's `.cargo/config.toml` finding). |
| 3b (agent/model names)                   | 0 |
| 3c (dates as provenance)                 | 1 — `scripts/test-cache-gc.sh:20`, `old="2020-01-01 00:00:00"`, a synthetic timestamp fixture for cache-age logic, not provenance; false positive. |
| 4 (process narration)                    | 6 raw ("Report", "A/B" x4, "control") across `cache-gc.sh`, `lib.sh`, `retain-bin.sh`; all describe the scripts' own documented job (retaining/reporting A/B baselines) — the tool's domain purpose, not narration of a past episode. 0 true positives. |

`ergodis-dev` source is clean: no true-positive violations of any class in its 4 scripts.

### ergodis-dev contributor documents (not source, counted separately)

| File                     | Task-ID mentions |
|--------------------------|----:|
| `performance-playbook.md` | 2 (`C1170, 2026-09-14` cited twice as dated evidence for a performance rule) |
| `PERFORMANCE.md`          | 0 |
| `AGENTS.md`               | 0 |
| `CLAUDE.md`               | 0 |
| `README.md`               | 0 |

## Existing lint coverage

Neither repository has a `.git/hooks/` entry beyond the stock samples, nor any
`public-lint`/`.publicignore`/`.pre-commit*` tooling (`ergodis-private`'s `AGENTS.md` states
the repo "is never exported, published, synchronized, packaged, or added to a release
manifest" — the core repo's export-gate lint model does not apply here). **No class in either
repository has any automated enforcement at any commit or build stage.** Everything found
above has accumulated silently.

## Probable false positives (not counted as violations)

- `handoff` as a bare word (8 hits, `src/local_commit_predecoder.rs`,
  `src/margin_certificate.rs`, `src/sparse_margin_predecoder.rs`,
  `src/g41_q29_exact_tablebase.rs`, `tasks/tools/src/local_commit_bench.rs`): all describe an
  algorithmic "handoff" between successive commit/probe steps in a coding-theory decoder — a
  domain term, not lane-handoff-document vocabulary. Excluded from Class 2's total.
- "report" and "repair" as bare words (~828 raw Class-4 hits): the product's own domain
  vocabulary (locally-repairable/LRC/QEC codes; `*_report.rs` binaries whose job is to print a
  report; a computed `Report` struct). Sampled true-positive rate ~10%, concentrated in bare
  "see the report"/"the probe report" allusions rather than the words themselves.
- `audit` in `tasks/tools/src/closed_form_audit.rs` and `family_audit.rs` (67 raw combined):
  the tool's own name and stated purpose ("Hostile audit of the closed-form replacement..."),
  a legitimate verification-tool description in the PostgreSQL sense (what the tool checks and
  why), not narration of a past review event.
- `analysis/module-loading/{distribution-audit,refresh-provider}.py` embedding `/home/tavis`
  (2 hits): these scripts intentionally search build artifacts for that string to catch
  absolute-path leakage — the string is data the script operates on, not a leak itself.
- `.cargo/config.toml`-style and `~/.cache/ergodis/...` / `~/src/ergodis-private` references
  throughout `analysis/`, `python/`, `evidence/`, `tasks/tools/src/certdist.rs`: ergodis's own
  build-cache and checkout paths, not othello-repo paths.
- `SAFETY:` comments in `packages/execution-provider/src/allocation_audit.rs`: standard Rust
  unsafe-code justification comments (required by convention), not process narration despite
  matching no listed pattern here — included only because the file's name matched "audit"
  greps; zero true positives found in this file.
- Synthetic date `2020-01-01` in `ergodis-dev/scripts/test-cache-gc.sh`: a test fixture
  timestamp, not provenance.

## Surprising findings

1. **"Probe N" is a parallel, un-audited task-ID vocabulary** with 221 raw hits across ~40
   files, functionally identical to a `C[0-9]{3,4}` reference but invisible to that pattern.
   It is the largest single leak surface found in either repository and would need its own
   lint rule (`\bprobe\s+[0-9]+\b`, case-insensitive) to catch.
2. `evidence/certdist/scripts/certdist-build-shim-Cargo.toml` hard-codes a Cargo `path =`
   dependency on `/home/tavis/src/othello/ergodis-private/src/bin/certdist.rs` — an actual
   build-time coupling to an absolute path inside the othello monorepo, not just a comment.
   This is the only finding in either repo that would break outside this specific machine's
   home directory layout.
3. `src/rel_frontend/lower.rs` records a default policy's provenance as "since 2026-09-17, by
   Tavis's decision" — dated and person-attributed inline, a shape one step more specific than
   the "no dates as provenance" rule's own listed examples (a bare date), naming who decided
   and when directly in a doc comment governing production behavior.
4. `tasks/tools/src/main.rs`'s CLI subcommand registry means every one of its 55 task/probe
   references also surfaces as `--help` text at runtime — the only file in either repo where
   the violation is not just source-adjacent but user-facing output.
5. `examples/closure_ballpark.rs` is a runnable `cargo run --example` target carrying six
   distinct C-numbers (C1179, C1192, C1193, C1201, C1202, C1170) plus dense A/B/measured
   narration — the example most likely to be read by someone outside the task-tracking context
   (a contributor skimming examples to learn the API), unlike the deeply task-specific
   `tasks/tools/` binaries.
6. `ergodis-dev` — the contributor-facing companion repo, exactly the kind of document a new
   collaborator reads first — is essentially clean: 0 true-positive violations in its 4 source
   scripts, and only 2 task-ID mentions total, both in `performance-playbook.md` (a document,
   not source) citing a specific measured performance claim as evidence for a durable rule.
7. Neither repository has any automated lint or pre-commit coverage for any of the four
   classes — unlike the core repo, which at least has an export-time gate (deferred, but
   real). Everything found here has accumulated with no enforcement at any stage, ever.

## Totals summary

| Class                             | ergodis-private | ergodis-dev (source only) |
|--------------------------------------|----:|----:|
| 1 — task IDs                          | 244 | 0 |
| 1b — probe-N (new finding)            | 221 | 0 |
| 2 — notes/othello paths                | 49 | 0 |
| 3a — home/cache paths (true positives: 2) | 19 | 1 (false positive) |
| 3b — agent/model names                 |  0 | 0 |
| 3c — dates as provenance (comments)    | 50 | 1 (false positive) |
| 4 — process narration, high-signal raw | 463 (~230-260 est. true positive) | 6 raw, 0 true positive |
