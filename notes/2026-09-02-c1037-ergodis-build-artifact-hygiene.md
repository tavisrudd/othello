# C1037 — Ergodis build-artifact hygiene

Lane: `complete-ports`. Date: 2026-09-02. Status: implemented, uncommitted, awaiting review.

## Problem

Every A/B and validation run had been building its baseline into a fresh target
directory. `~/.cache/ergodis` held 379 top-level entries totalling ~32 GB
(including 82 `*target*` directories and 30 DRAT files), and four in-tree target
directories existed as well: `papers/complete-repair-ports/ergodis/target`
(17 GB), `ergodis-private/target` (7.1 GB), `rust/target`, `sparse-shadow/target`.
`PERFORMANCE.md` required A/B "against the retained binary" but never said how a
binary was retained, so preserving a whole build tree was the only available
reading.

## What changed

### Shared out-of-tree target directories

- `papers/complete-repair-ports/ergodis/.cargo/config.toml` sets
  `build.target-dir = /home/tavis/.cache/ergodis/target/ergodis`.
- `ergodis-private/.cargo/config.toml` sets
  `build.target-dir = /home/tavis/.cache/ergodis/target/ergodis-private`.
  Workspace members inherit it: cargo reads configuration from the invocation
  directory upward, and every member is under the workspace root.
- `papers/complete-repair-ports/ergodis/Cargo.toml` adds `.cargo/` to the
  package `exclude` list so the configuration never ships in a package. No
  release manifest or standalone-synchronization allowlist for this crate exists
  in the repository, so `exclude` is the only exporter that needed the entry.

### Shared shell helper

`papers/complete-repair-ports/ergodis/scripts/lib.sh` (new, sourced not
executed) provides:

- `ergodis_cache_root` — honours `ERGODIS_CACHE_ROOT`, defaults to
  `/home/tavis/.cache/ergodis`.
- `ergodis_target_dir <crate-dir>` — honours `CARGO_TARGET_DIR`, else parses
  `build.target-dir` from the nearest ancestor `.cargo/config.toml`, else falls
  back to `<crate-dir>/target`.
- `ergodis_profile_dir <profile>` — maps `dev`/`debug` to `debug`, otherwise the
  profile name.
- `ergodis_bin <crate-dir> <profile> <bin>` — echoes the executable path;
  `<bin>` may be `examples/<name>`.

Scripts that hardcoded an in-tree path now source `lib.sh` and call
`ergodis_bin`:

| script | what was hardcoded |
|---------------------------|--------------------------------------------|
| `application-readme-ab.sh` | `$root/target/release/bench_kernels` (twice) |
| `control-event-ab.sh` | `target/release/alignment-controlled`, `target/release/ergodisctl` defaults |
| `vlsat2-prefix-ab.sh` | `target/release/examples/vlsat_clique_certificate` (twice) |
| `vlsat2-full-coverage.sh` | `target/release/examples/vlsat_clique_certificate` (twice) |

`contextual-memory-ab.sh` and `observational-memory-ab.sh` mention
`target/release/deps/...` only in their usage text, where the argument is a
criterion bench binary the caller supplies; their usage strings now name the
shared out-of-tree directory instead.

Remaining `target/release` hits in these trees point outside the two crates and
were left alone: `bench-shuffle-product-control.sh`,
`check-layered-audit-evidence.sh` (`~/.cache/ergodis/nix-target`),
`mata-official-ab.sh`, `z3-weighted-suite.sh` (`$cache_root/rust-target`),
`observational-boa-ab.sh`, `observational-wide-boa-ab.sh` (the external `boa`
checkout), and `ergodis-private/python/c1029_replay.sh`, which deliberately
builds a throwaway single-file workspace under its own `${WORK}` directory.

### `retain-bin.sh`

`papers/complete-repair-ports/ergodis/scripts/retain-bin.sh <crate-dir> <bin> [--profile P] [--features F]`

Builds into the shared target directory, then copies the executable to
`~/.cache/ergodis/bin/<bin>-<git-short-sha>[-<profile>][-<features>]`, writes a
`.sha256` sidecar, and appends one row to `~/.cache/ergodis/bin/MANIFEST.tsv` with timestamp, path, sha256, git rev, dirty flag, rustc
version, profile, and features. The profile suffix is omitted for `release` and
the features suffix for an empty feature set, so the common case is
`<bin>-<sha>`.

Idempotence: an existing retained file with the same hash is reported and the
script exits 0; an existing file with a different hash is refused with both
hashes printed, since the same revision producing a different executable means
the baseline needs a distinct name.

The dirty flag is computed repo-wide rather than scoped to the crate directory:
a build depends on every path its dependency graph reaches, so a clean crate
directory is not a clean baseline. (The first trial run recorded `clean` for
`ergodis-tools` under the crate-scoped check while `ergodis` recorded `dirty`;
the check was corrected and both entries re-created.)

### `cache-gc.sh`

`papers/complete-repair-ports/ergodis/scripts/cache-gc.sh [--apply]`

Lists every top-level entry of `~/.cache/ergodis` other than the shared
`target/` and `bin/` directories, with size, age in days, name, and either the
`evidence/*.json` files naming it (up to three, from
`papers/complete-repair-ports/ergodis/evidence` and
`ergodis-private/evidence`, searched recursively) or `UNREFERENCED`. The
default is a dry run. `--apply` runs one `rm -rf -- <exact path>` per
unreferenced entry; there is no glob anywhere in the deletion path.

## Dry-run summary

Full table: `notes/2026-09-02-c1037-cache-gc-dry-run.txt` (produced without
`--apply`; nothing was deleted).

- 379 top-level entries examined, excluding the shared `target/` and `bin/`.
- 373 UNREFERENCED, totalling approximately 31.3 GiB reclaimable.
- 4 referenced entries retained: `certdist` (270 MB), `c1018` (108 MB), `c985`
  (104 MB), `bb756` (28 MB).
- Largest unreferenced entries: `css-native-target` (3.8 GB),
  `target-c985-zeta-validation` (1.2 GB), `target-c985-reversal-validation`
  (1.2 GB).

## Documentation

- `PERFORMANCE.md`, timing-claims list: the line "compare saved binaries when
  diagnosing small deltas" is replaced by the retained-executable rule, which
  names `scripts/retain-bin.sh`, requires the retained name and its SHA-256 in
  the evidence file, and forbids rebuilding the baseline for a small-delta
  diagnosis.
- `PERFORMANCE.md`, new "Build artifacts" section before "Hardware
  specialization": one shared out-of-tree target directory per crate and never a
  per-experiment one; baselines are retained executables; proof blobs are hashed
  into their evidence file and then compressed or deleted; `cache-gc.sh` runs at
  task close.
- `ergodis-private/AGENTS.md`: a short "Build artifacts" section next to the
  crate-tier section carrying the same three rules.

## Validation

- `cargo check --workspace --all-targets` in `ergodis-private`: clean, 17.50 s.
- `cargo check --all-targets` in the ergodis crate: clean, 10.73 s.
- Both shared directories exist afterwards:
  `/home/tavis/.cache/ergodis/target/ergodis` and `.../ergodis-private`.
- No new in-tree `target/` appeared; the two pre-existing in-tree target
  directories have modification times predating these runs, and
  `tasks/gem-hunt/target` and `tasks/tools/target` do not exist.
- `retain-bin.sh` run on both requested binaries, manifest rows:

  ```
  /home/tavis/.cache/ergodis/bin/ergodis-tools-0ead330cb  dirty  release
  /home/tavis/.cache/ergodis/bin/ergodis-0ead330cb        dirty  release
  ```

  with SHA-256 `ea3d0092df364e019ee51b8e25306b6bc3d20f14bd39c1377bdbad13cafa82ac`
  and `4d61f2b5b2e3f58781f7c626254328a705a96d635435f0b33f1d2f083be5479a`
  respectively. Re-running on `ergodis` reported the existing copy and exited 0.
- `bash -n` passes on `lib.sh` and every edited or new script;
  `retain-bin.sh --help`, `cache-gc.sh --help`, and the `control-event-ab.sh`
  argument guard all print usage.
- `ergodis_bin` resolves the expected paths for the `release`, `campaign`, and
  `dev` profiles in both crates.

## Left for the reviewer to approve

1. Deleting the four in-tree target directories, none of which is written any
   more: `papers/complete-repair-ports/ergodis/target` (17 GB),
   `ergodis-private/target` (7.1 GB), `rust/target`, `sparse-shadow/target`.
   The last two belong to other lanes.
2. Running `cache-gc.sh --apply` to remove the 373 unreferenced cache entries
   (~31.3 GiB). Confirm first that the four referenced entries and any in-flight
   campaign directory are what the evidence corpus expects.
3. Whether the 30 DRAT files should be hashed into their evidence files and
   compressed rather than deleted outright; the new policy text says hash then
   compress or delete, but this pass did not touch any of them.

## Foreign issues

- `rust/target` and `sparse-shadow/target` are outside this lane; they are
  reported, not touched, and neither tree received a `.cargo/config.toml`.
- `ergodis-private/src/bin/certdist.rs` exists despite the no-new-`src/bin` rule
  in `ergodis-private/AGENTS.md`. Not touched.
- `ergodis-private/scripts/__pycache__` is present in the working tree.
- `ergodis-private/src/bin/c1018_plane12_hyperoval.rs` was already untracked
  before this task and remains so.

## Nothing committed

All changes are left in the working tree. No `git add`, commit, push, reset,
checkout, restore, or stash was run.
