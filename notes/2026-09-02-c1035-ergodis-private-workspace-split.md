# C1035 — ergodis-private as a library-only tier-1 crate, and the `ergodis-tools` task crate

**Date**: 2026-09-02
**Lane**: `complete-ports`
**Scope**: `ergodis-private/` and `notes/`. The public core under
`papers/complete-repair-ports/ergodis` was not modified.

## Goal

Step 2 of `notes/2026-09-02-ergodis-private-crate-consolidation-proposal.md`: make the workspace
root package `ergodis-private` a library-only tier-1 crate, and move its six named `[[bin]]`
utilities into a new tier-2 workspace member `ergodis-private/tasks/tools` exposing a single
`ergodis-tools` binary with one subcommand per tool. Flag names, defaults, and output stay
byte-identical so every committed replay command survives. The dead `c1018-*` Cargo features are
removed from the root package.

The other auto-discovered `src/bin/*.rs` files are untouched; they belong to C1036.

## Layout

```
ergodis-private/
  Cargo.toml                  [workspace] members = [".", "tasks/gem-hunt", "tasks/tools"]
                              root package: library only, no [[bin]], no c1018-* features
  src/alignment_control.rs    now a tier-1 library module (`pub mod alignment_control;`)
  tasks/tools/
    Cargo.toml                package `ergodis-tools`, bin `ergodis-tools`
    src/main.rs               clap command tree and dispatch only
    src/projective_grid_scout.rs
    src/alignment_controlled.rs
    src/hall_certify.rs
    src/q25_pair_repair.rs
    src/q16_quadratic.rs
    src/q19_marked_polar.rs
```

Each module exposes a `#[derive(clap::Args)]` struct and `pub fn run(args) -> Result<()>`;
`q19_marked_polar` takes no arguments, so its entry point is `pub fn run()`.

All six files were moved with `git mv`, so history follows.

### `alignment_control` promoted to the library

`src/bin/alignment_controlled.rs` reached its controller adapter through
`#[path = "../alignment_control.rs"] mod alignment_control;`. A relative `#[path]` include cannot
cross the crate boundary cleanly, and the adapter is exactly the reusable private machinery tier 1
is for, so `src/alignment_control.rs` is now `pub mod alignment_control;` in the `ergodis-private`
library and the moved tool imports it as `ergodis_private::alignment_control::…`. The file's
contents are unchanged apart from the clippy repair recorded below. It was the only `#[path]`
consumer of that file.

## Old command → new command

| Old binary                | Old command                                  | New command                                             |
|---------------------------|----------------------------------------------|---------------------------------------------------------|
| `projective-grid-scout`   | `projective-grid-scout --q Q --states N …`   | `ergodis-tools projective-grid-scout --q Q --states N …`|
| `alignment-controlled`    | `alignment-controlled --run-dir D …`         | `ergodis-tools alignment-controlled --run-dir D …`      |
| `hall-certify`            | `hall-certify --input F --output F`          | `ergodis-tools hall-certify --input F --output F`       |
| `q25-pair-repair`         | `q25-pair-repair --threads T …`              | `ergodis-tools q25-pair-repair --threads T …`           |
| `q16-quadratic`           | `q16-quadratic --levels F --threads T …`     | `ergodis-tools q16-quadratic --levels F --threads T …`  |
| `q19-marked-polar`        | `q19-marked-polar`                           | `ergodis-tools q19-marked-polar`                        |

Every long flag, default, `requires`, and `conflicts_with` relation is carried over unchanged; the
only edit to each file is the `Parser` → `Args` derive swap and turning `main` into `run`.

## The two dead C1018 Cargo features

`c1018-sparse-action` and `c1018-lane-action` were declared on the root package but gated nothing
there: `rg -l 'c1018' ergodis-private/src -g '*.rs'` returns only doc-comment provenance lines in
`arith.rs`, `css_codes.rs`, `prs.rs`, `gf2_linalg.rs`, and one comment in `src/bin/certiis.rs`, and
no root source file contains a `cfg(feature = "c1018-…")`. The live copies moved to
`tasks/gem-hunt` under C1034. Both declarations are removed from the root `Cargo.toml`; the
`tasks/gem-hunt` declarations, which do gate code, are untouched.

## Parity

Baseline: the six binaries built at the current `HEAD` (`d381623f1`) in release profile **before**
any file was moved, then copied out of `ergodis-private/target/release`. `git stash` was not used.
New side: `ergodis-private/target/release/ergodis-tools`, release profile.

Flag surface first: for all five tools that take flags, the full set of long options, defaults, and
help text extracted from `--help` is identical between the old binary and the new subcommand.

| Case                      | Old command                                                                                    | New command                                                                                                | Digest (SHA-256)                                                   | Verdict |
|---------------------------|------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------|---------|
| marked-polar census       | `q19-marked-polar`                                                                              | `ergodis-tools q19-marked-polar`                                                                              | `4d071db1556d6ef135693cb95a5e7bb6199c187595bd1a684bbd1170a29a97ca` (stdout) | equal   |
| projective grid scout     | `projective-grid-scout --q 7 --states 10000 --threads 1`                                        | `ergodis-tools projective-grid-scout --q 7 --states 10000 --threads 1`                                        | `272eeeb18ea59088361dbf620ed6bc88518bc467e9d8114373db17b3ade30a35` (JSON, `elapsed_seconds` dropped) | equal   |
| Hall certificate, C80 q11 | `hall-certify --input evidence/c80-q11-ancestral-secant-hall-graph.json --output F`             | `ergodis-tools hall-certify --input evidence/c80-q11-ancestral-secant-hall-graph.json --output F`             | `23d3830e4b0b0f47c5407462e4580be60d8e1c5101baa9ce0ae5cc10f53e4e1b` (certificate JSON) | equal   |
| alignment baseline solve  | `alignment-controlled --run-dir D --points 8 --budget 6 --baseline`                             | `ergodis-tools alignment-controlled --run-dir D --points 8 --budget 6 --baseline`                             | `dea18d9c61c8ccae9a81b91a29628751bdeb2e52b21a0919bd79e3a9d353bde8` (stdout) | equal   |
| Q25 stabilizer synthesis  | `q25-pair-repair --threads 12 --synthesize-stabilizer --stabilizer-log F`                       | `ergodis-tools q25-pair-repair --threads 12 --synthesize-stabilizer --stabilizer-log F`                       | `f8e2a71b45fe86a042ab9350f594b2a9c948b36a5cc3ead6c69a42a3daeb1989` (trial log); `ea5f9a4d9a4f8434b47bba0a12636a2df17dd3a95ab63110b8da8e465eae49c1` (stdout, `*_seconds` dropped) | equal   |
| Q16 theorem synthesis     | `q16-quadratic --levels LEVELS --threads 8 --synthesize --theorem-log F`                        | `ergodis-tools q16-quadratic --levels LEVELS --threads 8 --synthesize --theorem-log F`                        | `dfb4164d01f24c2f7fb5f1bd437d9519c4eddc1f513976678cec96f2dadf1b47` (theorem log); `98a1f9fdcd542878a29e58e1966ecbf0729b465e181bfbfcf56fc31023ddea55` (stdout, `*_seconds` dropped) | equal   |

Three of the six digests are not merely old/new agreement but reproduce a **committed** expectation:

- the Hall certificate equals `ergodis-private/evidence/c80-q11-ancestral-secant-hall-certificate.json`
  byte for byte;
- the Q25 stabilizer trial log equals `ergodis-private/evidence/q25-stabilizer-trials-v1.sha256`,
  the digest recorded in `notes/2026-08-30-c985-ergodis-portfolio-method-inventory.md`;
- the Q16 theorem log equals the digest recorded in the same note. `LEVELS` there is
  `git show 8226c99c4:lean/RelativeConicArcs/Q16CertificateLevels.lean`, staged to a file rather
  than piped on stdin so both sides read identical bytes.

Wall-clock fields (`elapsed_seconds` in the scout's JSON, `*_seconds=` in the Q25 and Q16 stdout
lines) are dropped before hashing; everything else matches byte for byte. No case exceeded five
minutes; the two heaviest ran in about one second each.

The `projective-grid-scout` replay recorded in
`notes/2026-08-30-c985-ergodis-private-adapters-and-parallel-roots.md` goes through
`ergodis-private/scripts/benchmark_projective_grid_parallel.sh <binary> 7 10000 24`, a timing
harness whose output is wall clock only. The same `q = 7`, 10,000-root cell was run directly at one
thread instead, which is the deterministic part of that evidence.

## Clippy fixes

Before this task the workspace gate failed on eight lints in the `ergodis-private` library plus one
in `src/alignment_control.rs`. All nine sites are inside `#[cfg(test)]` modules or are plain fixture
constants; none is in a solve hot loop, so no counter A/B is owed. The library and
`ergodis-tools` now pass. Four sites are rewritten and five are silenced with a targeted `#[allow]`
plus a one-line reason, because the flagged spelling carries information the "fix" would erase.

| Site                                        | Lint                          | Action                                                                                       |
|---------------------------------------------|-------------------------------|-----------------------------------------------------------------------------------------------|
| `src/cyclic_residual_relation_evolve.rs:287`| `manual_contains`             | Rewritten to `contains(&…)`. Same predicate, in a test assertion.                              |
| `src/proof_synthesis.rs:831`                | `zero_repeat_side_effects`    | `[[0_i8; 4]; 0]` rewritten as the typed empty array `let mut too_small: [[i8; 4]; 0] = [];`.   |
| `src/q29_exact_anneal.rs`                   | `items_after_test_module`     | The three retained-seed functions after `mod tests` are relocated verbatim to before it.       |
| `src/alignment_control.rs`                  | `items_after_test_module`     | Resolved by the module promotion: the lint fired on the bin's `#[path]` copy, and the library target is clean. |
| `src/cyclic_residual_features.rs:386`       | `unusual_byte_groupings`      | `#[allow]`: the hex digit groups spell the task and sector the fixture seed belongs to.        |
| `src/g41_q29_evolve.rs:5078`, `:5117`       | `unusual_byte_groupings`      | `#[allow]`, same reason.                                                                       |
| `src/g53_search.rs:2968`                    | `inconsistent_digit_grouping` | `#[allow]`: `53_49_2092` spells the g53 sector, the residue, and the order.                    |
| `src/g41_q29_shard_census.rs:263`           | `identity_op`                 | `#[allow]`: the index is written as `row * stride + column` on an 8 x 8 grid.                  |

## Performance rules that applied, and how they were checked

The six moved tools are operator drivers: argument parsing, file I/O, JSON serialization, and calls
into the library. No Ergodis solve kernel moved, and no line inside any solve loop changed.

- **A move must not add allocation, dynamic dispatch, or indirection in a hot path.** Each file's
  only edits are the `clap::Parser` → `clap::Args` derive swap and `fn main` → `pub fn run`. The
  body of every tool, and therefore every call it makes into the library or the public core, is
  unchanged. The one added indirection is the `main.rs` dispatch `match`, which executes once per
  process before any search begins.
- **No run-constant branch inside a loop.** Nothing new is branched on; the subcommand is resolved
  once at startup, as the binary name was before.
- **Worker ownership and contention-free parallelism.** The three parallel tools
  (`projective-grid-scout`, `q25-pair-repair`, `q16-quadratic`) keep their `--threads` plumbing and
  their per-worker scratch exactly as written. `alignment-controlled` keeps its auxiliary-watcher
  structure; promoting `alignment_control` to a library module changes where the file is declared,
  not what it compiles to — it is still a plain module in a crate the tool links statically.
- **Exact result and certificate parity.** Established by the parity table above, including three
  committed-digest reproductions.
- **Counter A/B evidence.** Not collected and not required: no hot-loop instruction, branch, or
  layout change was made.

`ergodis-private/performance/kernel-registry-v1.json` names no kernel in any moved file, so no
registry entry changed.

## Gate results

Run from `ergodis-private/` through `~/.claude/bin/run-quiet`.

- `cargo check --workspace --all-targets`: exit 0, 8.36 s. Output verbatim:

  ```
      Checking ergodis-private v0.0.0 (/home/tavis/src/othello/ergodis-private)
      Checking ergodis-tools v0.0.0 (/home/tavis/src/othello/ergodis-private/tasks/tools)
      Checking gem-hunt v0.0.0 (/home/tavis/src/othello/ergodis-private/tasks/gem-hunt)
      Finished `dev` profile [unoptimized + debuginfo] target(s) in 8.36s
  ```

- `cargo fmt --all --check`: exit 0, no output.

- `cargo clippy --workspace --all-targets -- -D warnings`: **fails**, entirely on
  auto-discovered `src/bin/*.rs` files this task must not edit — see "Skipped" below. The two
  targets this task owns pass:

  ```
  cargo clippy -p ergodis-private --lib --profile test -- -D warnings
      Finished `test` profile [unoptimized + debuginfo] target(s) in 0.02s

  cargo clippy -p ergodis-tools --all-targets -- -D warnings
      Checking ergodis-tools v0.0.0 (/home/tavis/src/othello/ergodis-private/tasks/tools)
      Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.26s
  ```

- `cargo test --workspace`: exit 0, 13 min 15 s. Across every test binary in the workspace,
  621 passed, 0 failed, 0 ignored, 0 filtered out; no target reported `FAILED`. The
  `ergodis-private` library suite alone reports

  ```
  test result: ok. 566 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 668.34s
  ```

  which is C1034's 561 plus the five tests that came with `alignment_control` when it became a
  library module. The workspace total is unchanged at 621, because those five tests previously ran
  inside the `alignment-controlled` bin target. `hall_certify`'s own unit test moved with its file
  and now runs under `ergodis-tools`
  (`test hall_certify::tests::serializable_certificate_matches_core ... ok`); it was the only test
  attached to any of the six moved files.

## Skipped, and why

1. **`cargo clippy --workspace --all-targets` still fails on the C1036 binaries.** The task scope
   forbids editing the auto-discovered `src/bin/*.rs` files. After this task's library fixes the
   remaining failures are in `src/bin/certdist.rs` (four), `src/bin/certiis.rs` (two),
   `src/bin/g41_q29_target_cache_participation.rs`, `src/bin/blind_raw_holdout_harness.rs` (two),
   `src/bin/g41_q29_q58_behavior_edge_census.rs` (two), `src/bin/g41_q87_behavior_edge_census.rs`,
   and `src/bin/css_bp_osd_spike.rs`. Clippy stops at the first failing crate target, so this list
   is the union observed across several scoped runs and may not be exhaustive; the whole-workspace
   gate can only close once C1036 absorbs or repairs those files.

2. **No heavier parity cell was run.** Every committed replay command found for these six tools
   completes in seconds, so the five-minute ceiling was never a constraint and no cell was
   substituted downward except the projective-grid scout, whose recorded replay is a timing
   harness rather than a deterministic certificate.

## Foreign issues noticed

- The workspace clippy gate remains red because of the `src/bin/*.rs` backlog listed above. That is
  the exact backlog C1036 exists to clear, and it is larger than the five failures C1034 recorded:
  clippy's per-target early exit hides the tail.

- `ergodis-private/scripts/benchmark_projective_grid_parallel.sh` invoked its `BINARY` argument with
  the scout's flags directly, so the move would have broken it. It is repaired in place: `BINARY` is
  now the `ergodis-tools` executable and the script supplies the `projective-grid-scout` subcommand.
  Its argument shape, flags, and tab-separated output are otherwise unchanged, and a one-round
  smoke run at `--states 200 --threads 2` produces the expected serial/parallel row.

- `notes/2026-08-31-c1030-ergodis-audit-certificates-io.md` states the root `Cargo.toml` wires 12
  `[[bin]]` targets. It wired six when this task started, and now wires none. Dated reports are not
  rewritten, so the sentence stands as a record of its date.

