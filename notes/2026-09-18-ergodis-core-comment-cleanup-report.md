# Ergodis core: comment and docstring professionalization (2026-09-18)

Rewrite of every comment, docstring, test name and message string in `~/src/ergodis`
that carried research-process bookkeeping, plus a lint that refuses its return.
Comment, docstring, test-name and string-literal text only; no behaviour change,
proved by disassembly.

## Scope

- Repository: `~/src/ergodis` (core, private `main`), commits `d56f748..2cd3370`.
  No edits in `ergodis-private`, `ergodis-dev`, or the othello monorepo except this
  report.
- Standard applied: a comment states what the code does, the invariant it maintains,
  what the caller must guarantee, the algorithm, and design rationale as a timeless
  property of the code. Removed: task identifiers, private notes paths, measurement
  history, variant history, audit mentions, dates as provenance, benchmark cohort
  names as provenance, private-repository references.
- Read in full: the task-reference sweep inventory, `AGENTS.md`,
  `../ergodis-dev/PERFORMANCE.md`, `crates/rules/src/demand.rs`,
  `crates/rules/src/pages.rs`, `crates/verify/src/datalog.rs`, and every other file
  edited below; plus bounded pattern sweeps over all tracked `*.rs`, `*.py`, `*.sh`,
  `*.toml`, `*.md`, `*.mjs`.
- The inventory's sampled class-4 estimate (roughly 50 true positives, concentrated in
  `demand.rs`) held, but it understated the reach: seven further files under `src/`
  carried measurement or variant narration that its comment-line pattern missed
  (`applications.rs`, `hall.rs`, `linear_code.rs`, `scheduler_dominance.rs`,
  `ordered_resource.rs`, `control/mod.rs`, `arithmetic/{subgroup,xor_sumset}.rs`),
  and two Python benchmark drivers carried a task identifier inside a marker string.

## Per-file counts by violation class

Counts are comment lines removed or rewritten, by the class that made them
violations. A line carrying two classes is counted under the dominant one.

| File                                        | Task ID / notes path | Measurement history | Variant history | Cohort / date as provenance | Private-repo reference | Lines removed outright |
|---------------------------------------------|---------------------:|--------------------:|----------------:|----------------------------:|-----------------------:|-----------------------:|
| `crates/rules/src/demand.rs`                 |                   15 |                  48 |              21 |                           7 |                      1 |                     62 |
| `crates/rules/src/pages.rs`                  |                    0 |                   9 |               4 |                           0 |                      0 |                      7 |
| `crates/rules/tests/demand_sparse.rs`        |                    5 |                  11 |               4 |                           0 |                      0 |                      6 |
| `crates/rules/tests/demand_nary.rs`          |                    4 |                   2 |               5 |                           0 |                      0 |                      3 |
| `crates/rules/tests/allocation.rs`           |                    1 |                   4 |               2 |                           2 |                      0 |                      2 |
| `crates/rules/tests/workspace_commit.rs`     |                    1 |                   0 |               0 |                           4 |                      0 |                      2 |
| `crates/rules/tests/demand_prepared.rs`      |                    1 |                   0 |               2 |                           0 |                      0 |                      1 |
| `crates/rules/tests/density_control.rs`      |                    0 |                   2 |               0 |                           0 |                      0 |                      0 |
| `crates/rules/tests/support/density.rs`      |                    0 |                   1 |               0 |                           0 |                      0 |                      0 |
| `crates/verify/src/datalog.rs`               |                    3 |                   0 |              10 |                           0 |                      0 |                      3 |
| `src/applications.rs`                        |                    0 |                   6 |               7 |                           1 |                      1 |                      5 |
| `src/hall.rs`                                |                    0 |                  10 |               4 |                           0 |                      0 |                      4 |
| `src/scheduler_dominance.rs`                 |                    0 |                   2 |               2 |                           1 |                      0 |                      1 |
| `src/arithmetic/two_adic.rs`                 |                    0 |                   2 |               0 |                           0 |                      0 |                      0 |
| `src/arithmetic/subgroup.rs`                 |                    0 |                   0 |               1 |                           0 |                      1 |                      1 |
| `src/arithmetic/xor_sumset.rs`               |                    0 |                   0 |               1 |                           0 |                      0 |                      0 |
| `src/control/evolution.rs`                   |                    0 |                   0 |               2 |                           0 |                      0 |                      0 |
| `src/control/mod.rs`                         |                    0 |                   0 |               1 |                           0 |                      0 |                      0 |
| `src/linear_code.rs`                         |                    0 |                   1 |               0 |                           0 |                      0 |                      0 |
| `src/ordered_resource.rs`                    |                    0 |                   0 |               2 |                           0 |                      0 |                      0 |
| `tests/evidence_manifest.rs`                 |                    0 |                   0 |               5 |                           0 |                      0 |                      1 |
| `python/run_application_counted_type_ab.py`  |                    1 |                   0 |               0 |                           0 |                      0 |                      0 |
| `python/run_repair_dag_contended_ab.py`      |                    1 |                   0 |               0 |                           0 |                      0 |                      0 |

`demand.rs` shrank by 62 comment lines net; the file's whole diff is 323 changed
lines against no code change at all.

## Examples, and the judgment in each

### 1. A constant that recorded which run fitted it (`DIRECT_STATIC_PROBES`)

Before:

> A static index is built once at preparation and never rebuilt, so C1192 priced only
> its probe and gave it no rule at all: the counting-sorted bucket beat a binary search
> over the distinct keys at every density that measurement reached … C1201 shipped a
> density — key space per row — and then measured that a density is a **proxy**:
> `mutual:blocks:4096` and `triangle:blocks:4096` have the same key space … C1201
> fitted this ratio at 23 from the one crossover it located and bracketed it between
> 18.2 and 273 by those two cohorts … See
> `notes/2026-09-18-c1202-probe-count-index-rule-report.md`.

After: the same paragraph states that the direct shape's build is proportional to the
key space (one `u32` per key, 64 MiB at the ceiling) while its saving is proportional
to the bucket lookups, that this constant is the ratio at which they cross in keys per
lookup, why the quantity must be lookups rather than a density (two programs agreeing
on key space and rows can want opposite shapes), and what a wrong value costs in each
direction. Every number that was a fitted result is gone; every number that is a
property of the representation stayed.

### 2. A constant whose rationale survived intact (`RESET_FILL_BYTES_PER_ROW`)

The old text gave seven measured structures, two named cohorts, instruction ratios and
resident-set figures in kibibytes. One sentence in it was a mechanism and not a result —
a table whose bytes are within this factor of its rows has already had most of its pages
committed by those rows — so that sentence became the whole rationale, with the failure
modes in both directions added. The eight lines of figures were deleted.

### 3. A comment deleted outright

`MAX_DIRECT_KEYS` carried "It carries the value the refusal `MAX_INDEX_KEYS` carried
before C1192, so a program the evaluator accepted before makes the same choice now."
Once the task identifier and the reference to a removed constant are gone, nothing
technical is left: the sentence's only content was that the value had not changed. It
was deleted, and the surviving clause ("a policy ceiling, not a refusal") was completed
to say what happens above the ceiling.

### 4. Measurement narration replaced by the mechanism it was evidence for

`Demand::join`'s witness write carried "Measured at **1.066 to 1.117 times the
instructions** of the retained control on the six two-atom cohorts, with A/A nulls
inside two parts per million." The mechanism the measurement established is that a
run-time index prevents the premise array from being promoted out of memory, so the
innermost function grows two indexed stack stores per candidate. That is now what the
comment says. The same treatment was applied to `run_nary`'s `#[inline(never)]`
("grows that function from 7,872 instructions to 12,855 and costs every two-atom cohort
3.9 per cent") and to the probe counter's const-generic gate ("0.067 to 2.554 per cent
… across the eighteen-cohort set").

### 5. A private-repository reference inside a shipped docstring

`Demand::evaluate_counted_into` cited `../ergodis-dev/PERFORMANCE.md`'s third invariant
and an othello notes report. The invariant itself — a run-constant decision is made
once, outside the loop — is now stated as the reason without naming the document, which
is also the only way the sentence survives the lint's private-path rule.

### 6. Domain vocabulary that was left alone

`crates/verify` and `crates/runtime` use "rejected", "reported", "receipt" and "report"
for what the code does: a request is rejected, a value is reported, a `Receipt` is a
stored type. None of that was touched. In `demand.rs`, two loose uses of "receipt"
("for a report, a receipt or a CLI") were changed to "report" because that file has no
receipt type and the word was research vocabulary there.

### 7. A test comment whose numbers are a property of the test

`pages.rs`'s drop test said "Measured over this loop: the shipped `Drop` moves `VmSize`
by 0 KiB and releasing `ptr` moves it by 51,381,008 KiB." The magnitudes are what
justifies the test's slack, so they stayed — as the deterministic property they are
("about fifty gibibytes over this loop, against eight of slack") rather than as a
recorded run.

### 8. A benchmark-cohort name used to size a test

`workspace_commit.rs` justified its wide-key program as "the shape of the largest table
in the measured lane (`cycle` at the `blocks` density, whose chain head is 64 MiB over
131,072 rows)". The cohort name is provenance; the regime is the point. It now names the
regime: a table so large against its rows that a linear fill would commit the whole of
it and the walk commits nothing.

### 9. Two assertion messages

`workspace_commit.rs` asserted with "the cohort must reserve enough for the ratio to mean
something" and "the cohort's index must be direct-addressed". These are test failure
messages, not user-visible error strings; "cohort" is benchmark vocabulary and both now
say "this program" / "the program's".

### 10. A task identifier inside a functional string

`python/run_application_counted_type_ab.py` and `python/run_repair_dag_contended_ab.py`
passed `"C1050RUSAGE %M"` to `/usr/bin/time` and matched the same prefix when parsing
stderr. The marker is written and matched in the same file and appears nowhere else in
the repository (checked), so renaming it to `ERGODISRUSAGE` leaves both scripts
behaving identically. This is the one string change that is not prose.

## Where I stated less because I was not certain of the mechanism

- `estimate_probes`'s weakness paragraph previously asserted that no cohort in a
  particular measured set was decided by the growing-delta overestimate. I could not
  restate that as a property of the code, so the comment now gives only the direction of
  the bias and notes that `MAX_DIRECT_KEYS` bounds what a wrong choice there can cost.
- `two_adic.rs`'s `lift_autocorrelation` said routing through the run-time-length sibling
  "costs about 40% more instructions and 47% more cycles, measured". The mechanism I can
  state with confidence is that the sibling hides the trip count from the compiler, so
  the loop keeps a run-time trip count and a bounds check; I did not attempt to
  attribute the split between the two effects.
- `hall.rs`'s `SPARSE_DENSITY_DIVISOR` had both a traffic model (dense row `right / 8`
  bytes against CSR `4 * degree`) and an interleaved measurement agreeing with it. I kept
  the model, which derives the constant exactly, and dropped the measurement and its
  percentage margins rather than converting them into claims I cannot derive.
- `hall.rs`'s deficiency-sweep outlining previously quantified the cost of inlining at
  four percent. The comment now states only that inlining enlarges the loop every solve
  runs for the sake of a body most inputs never enter.

## Test rename

`src/hall.rs`: `the_automatic_selector_follows_the_measured_traffic_crossover` →
`the_automatic_selector_follows_the_traffic_crossover`. The name is referenced nowhere
else (checked with a repository-wide grep for the old name).

## String changes

No user-visible error string was changed. Two test assertion messages in
`crates/rules/tests/workspace_commit.rs` lost the word "cohort" (example 9), and the two
Python benchmark drivers' internal `/usr/bin/time` marker was renamed (example 10).

## No behaviour change: the disassembly comparison

Method. Before the first edit, with both trees clean (`ergodis` at `d56f748`,
`ergodis-private` at `1500dc2`), the evaluation harness was built and retained:

```
~/src/ergodis-dev/scripts/retain-bin.sh ~/src/ergodis-private closure_ballpark \
    --example --label closure_ballpark-pre
-> ~/.cache/ergodis/bin/closure_ballpark-pre-1500dc2
   sha256 2c3350fca17478d5af6f0ca4c184304e36fd41e073db5d23b9919713af5cc938
```

After the last commit, with the same private tree, the same build was retained as
`closure_ballpark-post-1500dc2`, sha256
`7b1e82438fd38adc6c7f747a288d9d579b7fd0586a47b193a61baa6ae938f154`. Both were
disassembled and normalized:

```
objdump -d --no-show-raw-insn -j .text <binary> \
  | sed -E 's/^[0-9a-f]+ //; s/\b[0-9a-f]{6,}\b/ADDR/g; s/<([^+>]*)(\+0x[0-9a-f]+)?>/<\1>/g'
```

Result. The two normalized disassemblies are **identical over the whole `.text`
section**, 197,853 instruction lines including 6,544 lines in `ergodis_rules::demand`
symbols — stronger than the required demand-scoped comparison. Section digests agree
for `.text`, `.rodata` and `.eh_frame` and differ only for `.data.rel.ro`: 183 differing
bytes out of 20,488, isolated single bytes at a stride of 24, which is the layout of
`core::panic::Location` (file pointer, length, line, column). That is the expected and
acceptable difference — panic-location line numbers moved because comment lines moved —
and `.rodata` being identical confirms that no panic file-name string changed.

## Gate outcomes

| Gate                                                        | Result |
|--------------------------------------------------------------|--------|
| `cargo fmt --check`                                          | clean |
| `cargo clippy --all-targets --all-features -- -D warnings`   | clean |
| `cargo test --all-features`                                  | all suites pass, no failures; includes `tests/evidence_manifest.rs`, so `SHA256SUMS` describes the tree |
| `cargo doc --no-deps --all-features`                         | 16 warnings, exactly the 16 the base commit `d56f748` emits (verified by building docs from `git archive d56f748`); every intra-doc link added targets an item already linked from the same file |
| `scripts/public-lint.sh HEAD` (full)                         | reports only process documents and `.cargo/config.toml`, all dropped by `.publicignore`; no task identifier, private path or narration in anything that ships |
| `scripts/public-lint.sh --content-only HEAD`                 | clean |
| `tests/publication-guards.sh`                                | 105 passed, 0 failed (99 before, 6 new fixtures) |
| `python3 python/generate_evidence.py --write`                | run in every commit that touched a hashed tree |

All builds ran under `nix develop ~/src/ergodis`, through `run-quiet`, with
`choom -n 1000` and at most 12 jobs.

## The lint changes

Two commits, so either can be reverted alone.

### (a) The content rules run on every branch

`scripts/public-lint.sh` gains `--content-only`: it applies the content rules
(task identifier, private path, and the new narration rule) and no path rule, skipping
every process document, every generated path, and every path the scanned tree's
`.publicignore` drops. `hooks/pre-commit` now runs it on any branch over the staged
files, materializing their bytes into a second tree and placing the index's
`.publicignore` at its root so the list the lint reads is the one the commit
establishes. On `public` the hook is unchanged: the full lint still runs.

The effect is that a file the export keeps is held to the public standard when it is
written rather than when it is published, while ordinary private work on `AGENTS.md`,
`docs-private/`, `hooks/`, `staging/`, guard tooling, `evidence/` and `.cargo/` is
untouched. Two existing guard fixtures that deliberately commit a leak into a shipped
file now pass `--no-verify`, because the guard they exercise is the export's and the
hook would otherwise refuse the commit that sets them up.

### (b) The narration rule

A fourth content rule, `process-note`, reads comment lines (`^[[:space:]]*(//|#)`) of
`*.rs`, `*.py` and `*.sh` only, and refuses these phrases, kept as one list in
`scripts/public-lint.sh`:

| Pattern                                              | Catches |
|-------------------------------------------------------|---------|
| `against the (retained )?control`                     | a measured comparison against a retained arm |
| `\bA/A\b`                                             | a null experiment |
| `the A/B control`, `an A/B between`                   | an experiment's arms, without claiming the bare token |
| `\bFermi\b`                                           | a prediction recorded as rationale |
| `instructive negative`, `first landing`               | variant history |
| `kept by measurement`                                 | a decision justified by its run |
| `measured rather than (reasoned\|assumed\|guessed)`   | the same, in this project's idiom |
| `[Mm]easured (at\|on\|in\|over) [0-9]`                | a figure with a measurement episode attached |
| `[Mm]easured 20[0-9][0-9]-`                           | a date as provenance |
| `the audit (found\|flagged\|said\|reported\|noted)`   | an audit's finding as rationale |
| `[a-z0-9]+:(blocks\|sparse)[0-9]*:[0-9]+`             | a benchmark cohort name as provenance |

False-positive handling. The list is deliberately short and literal, and the ordinary
words this codebase uses for its own subject matter are absent: "measured", "rejected",
"receipt", "report", "control" and a bare "A/B" all describe what the code does or what
a benchmark driver is for. A bare `A/B` rule was measured against the tree during
design and would have flagged about twenty legitimate lines in `python/`, `scripts/`
and `examples/*_ab.rs` whose subject *is* an A/B, so only the two narrative forms are
matched. `\bA/A\b` is matched case-sensitively, because a case-insensitive `a/a`
matches ordinary text such as "schema/algebra". The rule reads comment lines only, so
string literals and data are untouched, and `*.md` is out of scope, so `BENCHMARKS.md`
can describe its own method. One line is exempted by the marker
`public-lint: narration-ok` on that line.

Six fixtures in `tests/publication-guards.sh` cover the rule: a measurement episode in a
Rust comment and a cohort name in a Python comment are refused; the marker, a narration
phrase outside a comment, the project's domain vocabulary, and a benchmark document
describing its own method all pass.

## Final verification

Bounded queries over tracked files, run at `2cd3370`:

```
git grep -c -I -E '\bC[0-9]{3,4}\b' -- '*.rs' '*.py' '*.sh' '*.toml' '*.md' '*.mjs' \
    ':!tests/publication-guards.sh'                                             -> 0 files
git grep -c -I -E 'notes/20|notes/handoffs|codex-task-queue|discovery-track|othello' \
    -- '*.rs' '*.py' '*.toml' '*.md' '*.mjs' ':!scripts/public-lint.sh' \
    ':!scripts/export-public.sh'                                                -> 0 files
git grep -c -I -E '[a-z0-9]+:(blocks|sparse)[0-9]*:[0-9]+' -- '*.rs' '*.py' '*.sh' '*.md'
                                                                                -> 1 file
git grep -c -I -E '\b(Opus|Sonnet|Claude|Codex|sub-agent|subagent)\b' \
    -- '*.rs' '*.py' '*.sh' '*.md' '*.toml' ':!docs-private' ':!AGENTS.md' ':!CLAUDE.md'
                                                                                -> 0 files
git grep -n -I -E '^\s*(///|//!|//).*20[0-9]{2}-[0-9]{2}-[0-9]{2}' -- '*.rs'    -> 0 lines
git grep -n -I -E '^\s*(//|#)' -- '*.rs' '*.py' '*.sh' ':!tests/publication-guards.sh' \
  | grep -cE '<the narration pattern list>'                                     -> 1 line
```

The two non-zero results are justified and expected:

- `tests/publication-guards.sh:265` writes `triangle:blocks:4096` into a throwaway file
  to check that the cohort-name pattern is refused. The brief names this file's fixture
  text as legitimate.
- `scripts/public-lint.sh:265` is the rule's own comment naming the vocabulary it
  refuses. Both files are process documents, so the lint skips them in every mode
  (confirmed: the full run reports them under `process-doc` and never scans their
  content).

## Commits

| Commit    | Subject |
|-----------|---------|
| `f65e325` | rules: rewrite the demand evaluator's comments to describe mechanism |
| `b34ca80` | rules, verify: state what the tests and the page reservation establish, not how they came about |
| `69c27e0` | core: replace measurement and variant narration in comments with the mechanism |
| `4375b70` | benchmarks, hall: name the resident-set marker for the project and state why the deficiency sweep is outlined |
| `a759757` | publication: run the content rules on every branch for the files that ship |
| `2cd3370` | publication: refuse process narration in source comments |
| `96aee9b` | rules: state the static and growing index rules in their own units |

Range `d56f748..96aee9b`. Each commit passed `cargo fmt --check` and compiled, and every
commit that touched a hashed tree regenerated `SHA256SUMS` in the same commit.

Review correction (`96aee9b`). `Policy::index_direct`'s docstring closed by calling
`DIRECT_INDEX_DENSITY` "the larger of the two because a static build is amortized over
the plan's evaluations and a dynamic one is not". That was wrong twice: the two
constants are in different units — key space per estimated lookup against key space per
row of capacity — so neither is larger than the other, and the amortization claim
contradicts `DIRECT_INDEX_DENSITY`'s own docstring, which states that an index over a
growing relation pays no build at preparation and trades the direct head array's
committed pages and address translation against the sparse probe. The docstring now
says only that the growing index is filled from each round's delta, builds nothing at
preparation, and is governed by `DIRECT_INDEX_DENSITY`, whose docstring states that
trade, and that the two constants are not comparable. The matching comment in
`crates/rules/tests/demand_sparse.rs` carried the same stale mechanism ("a static index
is built once and amortized over the plan's evaluations while a dynamic one is rebuilt
every evaluation") and now says that only a static index has a preparation build, which
is why its rule is in different units. Comment text only; `cargo fmt --check`,
`cargo check --all-targets --all-features`, `cargo test --all-features` and the content
lint all pass, and `SHA256SUMS` was regenerated in the same commit.

## What remains

- Nothing uncommitted and nothing foreign was found in the worktree; the tree is clean
  at `2cd3370`. An untracked, git-ignored `target/` directory sits in the repository
  root (stale local build output; the shared target directory is under `~/.cache`). It
  is not mine to remove and is excluded by `.gitignore`.
- The narration rule is conservative by construction. Classes it cannot see: a
  measurement episode written without any of the listed phrases, and narration in a
  trailing comment after code on the same line in a language whose comments it does not
  parse. Widening it would cost false positives against this codebase's own vocabulary,
  which is the one failure mode that makes a lint ignored.
- `BENCHMARKS.md`, `OPTIMIZATION.md` and `docs/` were checked for task identifiers,
  private paths and cohort provenance and are clean; their discussion of controls and
  A/B design is the legitimate subject of a benchmark document and was left alone.
- `~/.cache/ergodis/bin` now holds the two retained arms of this comparison. Nothing
  under `~/.cache/ergodis` was deleted, and `cache-gc.sh` was not run.
