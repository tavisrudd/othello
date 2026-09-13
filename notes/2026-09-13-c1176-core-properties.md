# C1176 — remaining core property tests

**Lane**: `ergodis`
**Date**: 2026-09-13
**Worktree**: `~/.cache/ergodis/worktrees/c1176-props`, branch `task/c1176-properties`, based on `main` at `b63c6dc`.

Six property tests from `notes/2026-09-12-c1171-rule-programme-review.md` (PROP-TEST 7, 8, 12, 13,
14, 15), each in its own new file, each its own commit.

## Status

All six property tests are written, passing, and committed, one file per commit, plus a
seventh commit refreshing the checksum manifest. No property was found false and no test
is being withheld.

Branch `task/c1176-properties`, in order:

| Commit    | Contents                                                      |
|-----------|---------------------------------------------------------------|
| `b8a1585` | `crates/rules/tests/grammar_properties.rs` (PROP-TEST 7)      |
| `b11a9d1` | `crates/rules/tests/provider_properties.rs` (PROP-TEST 8)     |
| `46664f1` | `crates/runtime/tests/lineage_properties.rs` (PROP-TEST 12, 13) |
| `fdd20e7` | `tests/allocation_surface_properties.rs` + root `Cargo.toml` (PROP-TEST 14) |
| `fc7fc9c` | `crates/verify/tests/finite_lowering_properties.rs` + `crates/verify/Cargo.toml` + `Cargo.lock` (PROP-TEST 15) |
| `c44c691` | `SHA256SUMS` refresh                                          |

## Tests

### PROP-TEST 7 — `parse_rules_is_total_and_idempotent`

- File: `crates/rules/tests/grammar_properties.rs`. Commit `b8a1585`.
- Target: `ergodis_verify::rule_contract::parse_rules`.
- Generator: a four-way union — `any::<String>()`; near-Datalog fragment soup
  (identifiers, unsigned decimals, `( ) , :- . - :`, whitespace and multi-byte UTF-8
  concatenated 0..24 deep); well-formed rule lists with arbitrary padding, leading-zero
  constants and 1-2 body atoms; and those same well-formed sources with one fragment
  spliced in at a random character boundary.
- Invariant: `parse_rules` never panics; when it returns `Ok(rules)`, re-parsing
  `render(&rules)` yields the same rules and `render` of those is a fixed point.
- Oracle: idempotence of `render ∘ parse` — the test's own renderer, the same one the
  existing `rule_grammar_round_trips` uses, but here fed rules recovered from malformed
  and padded text rather than from an already admitted program.
- Cases: 512. Measured acceptance on a sample run: 166 of 512 sources parsed (46 empty
  rule lists, 120 with 1-3 rules), so the round-trip half is not vacuous. The first
  generator draft — arbitrary strings and fragment soup only — accepted **zero** of 512,
  which is why the well-formed and corrupted arms were added.
- Runtime: 0.13 s.
- Gates: `cargo fmt --check` (exit 0), `cargo clippy --all-targets -p ergodis-rules --
  -D warnings` (exit 0), `cargo test -p ergodis-rules --test grammar_properties`
  (1 passed).

### PROP-TEST 8 — `provider_abi_is_total_and_respects_its_output_bound`

- File: `crates/rules/tests/provider_properties.rs`. Commit `b11a9d1`.
- Target: `ergodis_rules::provider::{ergodis_create, ergodis_invoke, ergodis_destroy}`
  driven natively through the raw C ABI (the only existing driver is the Python
  `native_abi.py` harness, which runs one scripted valid session).
- Generator: a random nonzero nonce plus 1..14 calls, each an operation code (weighted
  over the five valid codes plus `any::<u32>()`), a handle (the operation's canonical
  live handle, null, latest or arbitrary live plan/workspace, a released handle, a live
  handle with its nonce bit flipped, or a raw `u64`), a payload (canonical for the
  operation, empty, a full admitted program, a bare selector prefix `1..=5`, a replay of
  the certificate or support certificate this session produced, or 0..48 random bytes)
  and an output capacity in `0..=4096`.
- Invariant: every call returns one of the six declared statuses; `written <= capacity`;
  `written == 0` on every non-`OK` status; and the `catch_unwind` guard at
  `provider.rs:202` never fires.
- Oracle: none — totality plus the write bound is the property. The `catch_unwind` half
  is observed by a global panic hook that counts panics only while a thread-local flag is
  armed around each `ergodis_invoke` call, so a caught panic is visible from outside even
  though the ABI converts it to `INVALID`.
- Cases: 192 (so ~1,500 generated calls per run). A scripted `PREPARE` + `WORKSPACE`
  prologue precedes the generated calls; without it the generator essentially never
  assembled a live workspace and every `EXECUTE` returned `STALE`. Measured coverage on a
  sample run: all five valid operation codes reach `OK`, and all six statuses
  (`OK`, `INVALID`, `STALE`, `CAPACITY`, `UNSUPPORTED`, `BUSY`) occur, including 42
  successful `EXECUTE` calls split across the solve (selector 1) and verify (selector 2)
  paths.
- Runtime: 0.10 s.
- Gates: `cargo fmt --check` (exit 0), `cargo clippy --all-targets -p ergodis-rules --
  -D warnings` (exit 0), `cargo test -p ergodis-rules --test provider_properties`
  (1 passed).

### PROP-TEST 12 — `fork_depth_matches_breadth_first_search`
### PROP-TEST 13 — `origin_toggle_round_trips_and_consumes_exactly_two_revisions`

- File: `crates/runtime/tests/lineage_properties.rs` (both properties). Commit `46664f1`.
- Target: `ergodis_runtime::lineage::LineageReadout::{new, readout, set_origin, sequence,
  verify_readout}`.
- Generator: two to eight runs. Run zero is always a root; each later run is a fresh root
  (probability 0.15) or a fork from an arbitrary boundary record of an arbitrary earlier
  run, and every run carries zero to four chained updates. Run identities are built from a
  fixed scrambled byte table so that the sorted identity order the readout reports differs
  from the creation order at every run count — that is what exercises the readout's index
  mapping and the `n²` value offset in `lineage.rs:186`. Multiple roots mean genuinely
  unreachable runs occur.
- Invariant (12): `readout().depths[i].forks` equals the breadth-first minimum fork-edge
  distance from the origin, `None` exactly for unreachable runs, and `depths[i].run` is the
  i-th run identity in sorted order. `verify_readout` accepts the readout.
- Invariant (13): two rejected calls (a stale expected sequence, and a run outside the
  catalogue) leave `sequence()` and the depths untouched; adding a non-origin run as an
  origin zeroes its own depth and never worsens another; removing it again restores the
  depths exactly; and `sequence()` is 2 at the end, one per accepted call.
- Oracle: a breadth-first search over the fork edges written directly in the test (12);
  the readout captured before the toggle (13).
- Cases: 96 and 64. Measured spread on a sample run of the depth property: zero to seven
  unreachable runs per catalogue and maximum depths from 0 to 3.
- Runtime: 0.06 s for both.
- Gates: `cargo fmt --check` (exit 0), `cargo clippy --all-targets -p ergodis-runtime --
  -D warnings` (exit 0), `cargo test -p ergodis-runtime --test lineage_properties`
  (2 passed).

### PROP-TEST 14 — `parallel_and_serial_surfaces_are_identical_at_every_split`

- File: `tests/allocation_surface_properties.rs`. Commit `fdd20e7`.
- Target: `AllocationSurface::advance_build_parallel` against `advance_build`, and the same
  pair on `CountSurface`.
- Feature gate: the parallel kernel is behind the root crate's `parallel` feature. The test
  target is declared in the root `Cargo.toml` with `required-features = ["parallel"]`
  rather than `#![cfg(feature = "parallel")]`, so a run without the feature skips the
  target visibly instead of compiling an empty binary.
- Generator: maxima drawn from four regimes — both axes in `0..=24` (well under one tile);
  first axis `0..=3` with the second in `{0, 1, 3, 7, 63, 1023, 8191}` (row width an exact
  divisor of, or equal to, the 8,192-cell tile); first axis `0..=2` with the second in
  `5000..=9000` (width straddling the tile boundary mid-row); and a collapsed first axis
  against a second in `{8190, 8191, 8192, 9000, 16383}`. One to eight options per family
  over two resources with loads in `0..=10`, and the family count clamped to
  `100_000 / cells` in `1..=32` so every case costs about the same. The advancement
  schedule is one to ten per-call layer budgets in `0..=5`, zeros included, followed by
  `usize::MAX` on both kernels.
- Invariant: `completed_jobs()` and `transitions()` agree after every split, and once both
  are built, `query` returns the same optimum and the same full per-family choice vector at
  every capacity in the surface.
- Oracle: the serial kernel.
- Deviation from the specification, and why: the spec names `previous` and `choices` as the
  compared state, but both are private fields of `AllocationSurface` and there is no
  accessor, so an integration test cannot read them. The closest faithful observation
  through the public surface is used instead — the transition and job counters at each
  split, plus the fully queried surface (value and choice vector at every capacity) once
  built, which reads `previous` and `choices` indirectly. Exposing the fields would be a
  library API change and was out of scope.
- Cases: 64. Measured shapes on a sample run include `cells` from 6 to 23,901, widths of
  exactly 8,192 and of 8,193, and straddling widths such as 5,775 and 7,967.
- Runtime: 0.18 s.
- Gates: `cargo fmt --check` (exit 0), `cargo clippy --all-targets -p ergodis --features
  parallel -- -D warnings` (exit 0), `cargo clippy --all-targets -p ergodis -- -D warnings`
  (exit 0, target skipped), `cargo test -p ergodis --features parallel --test
  allocation_surface_properties` (1 passed). `cargo test -p ergodis --features parallel
  --test allocation_parallel_contract --test allocation_parallel` also still passes.

### PROP-TEST 15 — `lowering_synthesis_is_complete`

- File: `crates/verify/tests/finite_lowering_properties.rs`. Commit `fc7fc9c`.
- Target: `ergodis::finite_lowering::synthesize` against
  `ergodis_verify::finite_lowering::{verify, verify_obstruction}`.
- Manifest change: `synthesize` lives in the root crate, which already depends on
  `ergodis-verify`, so the test needs `ergodis` as a **dev-dependency** of
  `ergodis-verify`. Cargo permits dev-dependency cycles and this one builds and runs
  cleanly; it binds only the verify crate's test targets, never its library.
- Generator: an event count and summary count drawn from an explicit list of eleven pairs
  (one to three events, one to four summaries), two to six sources, a lowering that is made
  surjective by forcing each summary onto one of a randomly permuted set of distinct
  sources, and a uniformly random total source transition table.
- Invariant: `synthesize` returns `Square` exactly when some summary transition table
  satisfies the square, the certificate it returns is that table, and `checked_cells`
  equals sources times events; otherwise it returns `Impossible` with an obstruction
  `verify_obstruction` accepts and which fails when its two representatives are made equal.
  In the `Square` case every single-cell perturbation of the certificate is rejected with
  `Error::Mismatch`.
- Oracle: brute-force enumeration of all `summaries^(summaries × events)` candidate tables,
  with the square condition written out directly in the test rather than delegated to
  `Model::counterexample`.
- Deviation from the specification, and why: the spec says one to three events and one to
  four summaries, but three events with four summaries needs `4^12 = 16,777,216` tables per
  case, which is not enumerable at property-test speed. That one pair is excluded; the
  largest admitted are two events with four summaries (65,536 tables) and three events with
  three summaries (19,683). Every other pair in the specified range is generated.
- Cases: 48. Measured outcome split on a sample run: 21 `Square` and 27 `Impossible`, with
  every admitted event/summary pair represented. Wherever a solution existed it was unique,
  as surjectivity forces.
- Runtime: 0.03 s.
- Gates: `cargo fmt --check` (exit 0), `cargo clippy --all-targets -p ergodis-verify --
  -D warnings` (exit 0), `cargo test -p ergodis-verify --test finite_lowering_properties`
  (1 passed). `cargo test -p ergodis-verify -p ergodis-rules -p ergodis-runtime` passes in
  full.

## Manifest and other tree-wide effects

`python/generate_evidence.py` walks `crates/`, `tests/`, `Cargo.toml` and `Cargo.lock` in
full since the previous commit on `main`, so every new test file makes `SHA256SUMS` stale
and `tests/evidence_manifest.rs` fail. The manifest was regenerated with
`python3 python/generate_evidence.py --write` in a separate final commit `c44c691`; the
only rows added are the five new test files, and the only rows changed are the three
manifest files the tests required. `evidence/results.json` was already current and is
unchanged. `cargo test -p ergodis --test evidence_manifest` passes on `c44c691`.

Consequence worth knowing: each of the five test commits taken alone fails
`evidence_manifest`, because the manifest is only refreshed at the end of the series. The
branch as a whole is clean.

Side effect, not committed: running the generator rewrote twelve tracked
`python/recovery_algorithms/__pycache__/*.pyc` files. They are left modified in the
worktree rather than restored, since restoring means a destructive git operation. They are
outside the hashed trees, so they do not affect `SHA256SUMS`.

## Not done

Nothing from the assignment was dropped. Two specifications were narrowed rather than
followed literally, both recorded above with their reasons:

1. PROP-TEST 14 compares the two kernels through `completed_jobs`, `transitions` and the
   fully queried surface instead of the private `previous` and `choices` fields, which an
   integration test cannot reach.
2. PROP-TEST 15 excludes the three-event, four-summary shape, whose brute-force oracle
   would enumerate 16.7 million tables per case.

No property turned out to be false, so there is no counterexample to record and no test is
being held back from the branch.
