# C1058 — fresh-clone validation of the split repositories (2026-09-02)
**Lane**: `complete-ports`.

Four sibling clones made with `git clone --no-local` from the local sources into
`/home/tavis/.cache/ergodis/fresh-validate/`. Every cargo command ran with
`CARGO_TARGET_DIR=/home/tavis/.cache/ergodis/target/fresh-validate-<repo>`. Command output was
captured under `/home/tavis/.cache/ergodis/fresh-validate/logs/` (kept; the clones themselves were
deleted afterwards). Nothing in the source repositories was modified.

## 1. `ergodis` (public core)

`cargo build --release` — exit 0:

```
    Finished `release` profile [optimized] target(s) in 48.38s
```

`cargo test --all-features` — exit 0, all suites green; final result lines:

```
test result: ok. 8 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 0.03s
test result: ok. 26 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 0.24s
test result: ok. 3 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 0.03s
test result: ok. 10 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 0.02s
test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 0.00s
test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 0.03s
test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 0.01s
test result: ok. 4 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 0.62s
```

`python3 python/test_algorithms.py` — exit 0, final line `OK`. No extra Python dependency was
needed; the Nix-provided `python3` sufficed for all three Python checks (no `uv run --with` fallback
was required).

`python3 python/generate_evidence.py --check` — **exit 1, FAIL**:

```
  File ".../python/generate_evidence.py", line 855, in checksum_manifest
    payload = (ROOT / relative).read_bytes()
FileNotFoundError: [Errno 2] No such file or directory:
'/home/tavis/.cache/ergodis/fresh-validate/ergodis/python/analyze_c997_support_orbits.py'
```

This is a genuine split defect, not a clone artifact: the file does not exist in `~/src/ergodis`
either. It now lives only in `ergodis-private/python/analyze_c997_support_orbits.py`, while the core
repository still lists it in two places that a downstream user hits immediately:

- `python/generate_evidence.py:159` — `"python/analyze_c997_support_orbits.py",` in the checksum
  manifest list.
- `SHA256SUMS:70` — `289ff1816772281cd84cb808c5a09b9c610a9d19319cfadbff44aa7466d58701  python/analyze_c997_support_orbits.py`

Fix: drop both entries from the core repository (or move the script back into core if it is meant to
be public), then regenerate `SHA256SUMS`.

`python3 python/generate_fixtures.py --check` — exit 0, no output (silent success).

`tests/publication-guards.sh` (run with
`ERGODIS_SCRATCH=/home/tavis/.cache/ergodis/fresh-validate/scratch`) — exit 0:

```
ok    install-hooks.sh configures the fresh clone
ok    core.hooksPath is set in the fresh clone
ok    the fresh clone's hook refuses a push to the public URL

passed: 44  failed: 0
```

Note on that script's header: it defaults `scratch_base` to a hardcoded agent-session scratchpad
path (`/tmp/claude-1000/.../785e0ee5-.../scratchpad`) when `ERGODIS_SCRATCH` is unset. That path
will not exist for a downstream user; the script does `mkdir -p` so it still works, but a better
default would be `${TMPDIR:-/tmp}`.

Hooks: `git config core.hooksPath` is **unset** in the fresh clone (empty output, exit 1), and
`scripts/install-hooks.sh` sets it — line 18 is `git config core.hooksPath hooks`, after checking a
tracked `hooks/` directory exists and chmod-ing its contents. The publication-guard suite exercises
this end to end and its three hook fixtures pass.

## 2. `ergodis-private`

`cargo build --workspace --all-targets --all-features` — exit 0:

```
    Finished `dev` profile [unoptimized + debuginfo] target(s) in 44.69s
```

The build resolved the sibling core clone through the `path = "../ergodis"` /
`path = "../../../ergodis"` manifest entries with no manual intervention, which is the property the
sibling layout is meant to deliver.

`cargo test --workspace --all-features` — exit 0, 628 tests passed and none failed across eight test
binaries. The main library suite dominates the runtime at roughly fourteen minutes:

```
test result: ok. 577 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 824.62s
test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 0.02s
test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 0.00s
...
test result: ok. 4 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 0.00s
test result: ok. 0 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 0.00s
```

`cargo metadata --format-version 1`, with every `manifest_path` inspected — clean:

```
outside/othello paths: none
```

Of 69 resolved packages, 64 are crates.io registry checkouts and the remaining 5 are local: the
`ergodis-private` workspace root, its members under
`/home/tavis/.cache/ergodis/fresh-validate/ergodis-private/tasks/`, and the sibling core clone at
`/home/tavis/.cache/ergodis/fresh-validate/ergodis`. No manifest path contains `othello`, and none
resolves outside the validate directory or the cargo registry.

## 3. `ergodis-evidence`

`sha256sum -c --ignore-missing SHA256SUMS` — **exit 1, one FAILED**:

```
README.md: FAILED
sha256sum: WARNING: 1 computed checksum did NOT match
```

40 entries reported `OK`. The single failure is a filename collision rather than data corruption:
`SHA256SUMS` is the core repository's manifest, whose `README.md` line refers to the *core*
`README.md`. The evidence repository ships its own, different `README.md` at the same relative path,
so `--ignore-missing` cannot skip it and the hash mismatches. Every actual evidence artifact
verified. Fix: give the evidence repository its own `SHA256SUMS` covering only evidence paths, or
drop the top-level `README.md` line from the shared manifest.

`diff -rq evidence ../ergodis/evidence` — exit 0, no output. `diff -rq proptest-regressions
../ergodis/proptest-regressions` — exit 0, no output. Both directories are byte-identical to the
core clone's copies, as intended.

## 4. `ergodis-contrib`

`bash scripts/test-cache-gc.sh` — exit 0 (its header confirms it builds a throwaway cache root under
`mktemp -d` and never touches the real cache):

```
cache-gc self-test: ok
```

`shellcheck -S warning -x scripts/*.sh` — shellcheck is available; **exit 1, one finding**:

```
In scripts/lib.sh line 1:
# Shared helpers for Ergodis benchmark, evidence, and A/B scripts.
^-- SC2148 (error): Tips depend on target shell and yours is unknown. Add a shebang or a 'shell' directive.
```

That is the only error- or warning-level finding across all of `scripts/*.sh`. `lib.sh` is a sourced
helper file, so it does not need to be executable, but adding `# shellcheck shell=bash` as its first
line silences the finding and lets shellcheck analyze it properly.

## 5. Clone hygiene (all four)

Each clone has exactly one remote, `origin`, pointing at its local source path
(`/home/tavis/src/ergodis`, `/home/tavis/src/ergodis-private`, `/home/tavis/src/ergodis-evidence`,
`/home/tavis/src/ergodis-contrib`) for both fetch and push. `git log --format=%G? -3` returned `N`
for every listed commit in every repository — all unsigned, as expected. `ergodis-evidence` and
`ergodis-contrib` have a single commit each, so `-3` printed one `N`. Every clone contains
`CLAUDE.md -> AGENTS.md` as a symlink, and each symlink resolves.

## 6. Residual monorepo path strings

`rg -l -g '!evidence/' -g '!*.patch' -g '!target'` for `complete-repair-ports/ergodis` and
`src/othello` found matches in only two files, both in the core repository, and both are intentional
rather than stale leaks:

- `ergodis/scripts/export-public.sh` lines 103-106 — the perl substitution rules that *strip* those
  paths during export. The strings must be present for the scrubber to work.
- `ergodis/tests/publication-guards.sh` lines 166, 188, 215 — fixture text that deliberately plants
  the monorepo paths into a synthetic private repository so the guard can be observed removing them.

`ergodis-private`, `ergodis-evidence`, and `ergodis-contrib` contain neither string anywhere outside
the excluded paths.

## Pass/fail summary

| # | Repository         | Check                                                  | Result |
|---|--------------------|--------------------------------------------------------|--------|
| 1 | `ergodis`          | `cargo build --release`                                 | pass   |
| 1 | `ergodis`          | `cargo test --all-features`                             | pass   |
| 1 | `ergodis`          | `python/test_algorithms.py`                             | pass   |
| 1 | `ergodis`          | `python/generate_evidence.py --check`                   | FAIL   |
| 1 | `ergodis`          | `python/generate_fixtures.py --check`                   | pass   |
| 1 | `ergodis`          | `tests/publication-guards.sh` (44 passed, 0 failed)     | pass   |
| 1 | `ergodis`          | `core.hooksPath` unset in clone, set by install-hooks   | pass   |
| 2 | `ergodis-private`  | `cargo build --workspace --all-targets --all-features`  | pass   |
| 2 | `ergodis-private`  | `cargo test --workspace --all-features`                 | pass    |
| 2 | `ergodis-private`  | no Cargo path outside the validate directory            | pass    |
| 3 | `ergodis-evidence` | `sha256sum -c --ignore-missing SHA256SUMS` (40 OK, 1 FAILED) | FAIL |
| 3 | `ergodis-evidence` | `diff -rq evidence`, `diff -rq proptest-regressions`    | pass   |
| 4 | `ergodis-contrib`  | `scripts/test-cache-gc.sh`                              | pass   |
| 4 | `ergodis-contrib`  | `shellcheck -S warning -x scripts/*.sh`                 | FAIL   |
| 5 | all four           | single `origin` remote, unsigned commits, `CLAUDE.md` symlink | pass |
| 6 | all four           | no stale `src/othello` / `complete-repair-ports/ergodis` references | pass |
