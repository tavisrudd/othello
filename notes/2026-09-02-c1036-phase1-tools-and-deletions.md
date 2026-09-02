# C1036 phase one — twelve lane-neutral bins into `ergodis-tools`, and 48 deletions

**Date**: 2026-09-02
**Lane**: `complete-ports`
**Scope**: `ergodis-private/` and `notes/`. The public core under
`papers/complete-repair-ports/ergodis` was not modified. The 43 Hadamard-sector LIVE bins are
untouched; they are phase two.

Triage authority: `notes/2026-09-02-c1036-hadamard-bin-triage.md`. Pattern and parity method:
`notes/2026-09-02-c1035-ergodis-private-workspace-split.md`.

## What changed

`ergodis-private/src/bin` held 103 auto-discovered binaries. Twelve lane-neutral LIVE drivers moved
with `git mv` into `ergodis-private/tasks/tools` as subcommands of the existing `ergodis-tools`
binary; ten DEAD and 38 BANKED bins were removed with `git rm`. Forty-three files remain in
`src/bin`, exactly the Hadamard-2092 set the triage assigns to phase two.

No file needed a library promotion. Only `css_bp_osd_spike.rs` carried a `#[path]` include — the
public core's `test_alloc.rs`, used from its `#[cfg(test)]` module — and it needed one more `../`
because the file now sits two directories deeper. No moved bin declared a bin-private module over a
`src/*.rs` file, so nothing became a new `pub mod` in tier 1.

Each moved file's only edits are the `clap::Parser` → `clap::Args` derive swap, `fn main` →
`pub fn run`, and the clippy repairs recorded below. Every flag, default, `requires`,
`conflicts_with`, and `ValueEnum` is carried over unchanged.

## Old command → new command

The four CSS-distance drivers are grouped under `ergodis-tools css`; `certiis` (assignment-problem
infeasibility) and `campaign_rpc` (campaign control plane) are not CSS work and stay flat, as do the
campaign, routing, and Hall tools.

| Old binary | Old command | New command |
|---|---|---|
| `certdist` | `certdist <job> …` | `ergodis-tools css certdist <job> …` |
| `qdist_to_ergodis` | `qdist_to_ergodis --stem S --direction D …` | `ergodis-tools css qdist-to-ergodis --stem S --direction D …` |
| `css_bp_osd_spike` | `css_bp_osd_spike --input F …` | `ergodis-tools css bp-osd-spike --input F …` |
| `c985_extension_field_elimination_bench` | `c985_extension_field_elimination_bench BACKEND DEG ROWS COLS SEED REPS` | `ergodis-tools css extension-field-elimination-bench BACKEND DEG ROWS COLS SEED REPS` |
| `certiis` | `certiis <command> …` | `ergodis-tools certiis <command> …` |
| `campaign_rpc` | `campaign_rpc --run-dir D --op OP …` | `ergodis-tools campaign-rpc --run-dir D --op OP …` |
| `alignment_root_corpus` | `alignment_root_corpus --points P --budget B …` | `ergodis-tools alignment-root-corpus --points P --budget B …` |
| `routing_policy_audit` | `routing_policy_audit --report R R … --output F` | `ergodis-tools routing-policy-audit --report R R … --output F` |
| `target_strategy_audit` | `target_strategy_audit --data D --seeds S …` | `ergodis-tools target-strategy-audit --data D --seeds S …` |
| `semantic_affine_census` | `semantic_affine_census [--labelled-tsv F] [--output F]` | `ergodis-tools semantic-affine-census [--labelled-tsv F] [--output F]` |
| `semantic_rank_census` | `semantic_rank_census [--output F] …` | `ergodis-tools semantic-rank-census [--output F] …` |
| `c80_hall_rematch` | `c80_hall_rematch --q Q --states N …` | `ergodis-tools c80-hall-rematch --q Q --states N …` |

`certdist`'s six jobs (`plan`, `run`, `status`, `combine`, `verify`, `help`) and `certiis`'s six
commands keep their own names one level further down.

The `about` strings that had been `#[command(about = …)]` on the six binaries that carried one are
now the doc comments of their `Command` variants, so `--help` still prints them. The
`c985_extension_field_elimination_bench` driver parsed six positional `std::env::args` by hand; it
now declares the same six positionals as a `clap::Args` struct in the same order, and its generic
kernel was renamed `run` → `bench` to free the module's entry-point name.

`ergodis-private/tasks/tools/Cargo.toml` gains one dependency, `sha2 = "0.10"`, which four of the
moved tools use for input and certificate digests.

## Deleted bins

The last commit containing these files is the parent of the phase-one commit; the reviewer fills in
that hash here: `________`.

Before deleting, one bounded fixed-string search for all 48 names over
`ergodis-private/{scripts,tests,docs}` (`*.sh *.py *.rs *.md`) and `ergodis-private/evidence`
(`*.sh`) returned no hits, so nothing under those trees invokes any of them and none was kept back.
Name matches elsewhere under `src/` are library modules that share a bin's name and survive the
deletion; no retained bin uses a `#[path]` include at all.

### DEAD (10)

| Bin | Reason from the triage |
|---|---|
| `g41_q174_source_projection_index` | superseded by the batch driver, unreferenced |
| `g41_q29_direct_reset_bench` | superseded micro-benchmark, no counter claim depends on it |
| `g41_q29_profile_shard` | the exact tablebase replaced sharded search |
| `g41_q87_energy_handoff_bench` | superseded micro-benchmark, unreferenced |
| `g53_mod14_scout` | superseded scalar-modulus scout |
| `g53_mod28_scout` | superseded scalar-modulus scout |
| `order6_crt_residual_perf` | superseded perf harness, no committed counter claim |
| `binary_orbit_quadratic_bench` | unreferenced micro-benchmark |
| `c985_structured_set_ab` | unreferenced A/B probe |
| `z2k_subgroup_bench` | unreferenced micro-benchmark |

### BANKED (38)

Corpus and census stages whose results are already numbers in a committed report, superseded
projection and shard stages, discovery-only evolve drivers whose retained leads are written up, and
rejected controls.

| Bin | Reason from the triage |
|---|---|
| `project_reachable_feature_support` | generic projection helper, result inside the feature-DAG report |
| `g41_joint_multiplicity` | multiplicity audit is a number in the C1016 report |
| `g41_q174_degree_fibre` | intermediate fibre census folded into the q174 joint tables |
| `g41_q174_evolve` | self-declared discovery-only; leads are in the report |
| `g41_q174_fibre_structure` | descriptive census superseded by the grouped join |
| `g41_q174_flip_corpus` | corpus stage; flip result banked in the q29 lift theorem |
| `g41_q174_partition_corpus` | corpus stage |
| `g41_q174_q87_energy_bound_probe` | superseded by the exact energy theorem |
| `g41_q174_q87_interactions` | enumeration folded into the full q87 join |
| `g41_q174_q87_scope_corpus` | corpus stage |
| `g41_q174_q87_scope_evolve` | discovery-only |
| `g41_q174_source_feasibility` | feasibility pass consumed by the joint tables |
| `g41_q174_source_projection_batch` | superseded projection stage; its caches are committed |
| `g41_q29_aggregate_pair_graph` | replaced by the signature census |
| `g41_q29_degree_obstruction_corpus` | corpus stage |
| `g41_q29_multiset_corpus` | corpus stage |
| `g41_q29_pair_target_corpus` | corpus stage |
| `g41_q29_profile_hit_interface` | sealed cache replaced the enumeration |
| `g41_q29_profile_hit_membership` | absorbed into the lift driver |
| `g41_q29_profile_multiset` | census result is a report number |
| `g41_q29_profile_participation` | shard-era diagnostic |
| `g41_q29_q58_behavior_edge_census` | primitive q58 join rejected on performance |
| `g41_q29_signature_census` | signature counts are a report table |
| `g41_q29_signature_class_corpus` | corpus stage |
| `g41_q29_source_pair_graph` | superseded by the matched pair cache |
| `g41_q29_target_cache_participation` | shard-era diagnostic |
| `g41_q87_behavior_edge_census` | behavior census banked in the report |
| `g41_q87_behavior_evolve_corpus` | corpus stage |
| `g41_q87_behavior_profile_census` | census result is a report table |
| `g41_q87_evolve_corpus` | corpus stage |
| `g41_q87_reachability_corpus` | corpus stage |
| `g41_q87_spec_behavior_census` | census result is a report table |
| `g53_mod343_scout` | fast-falsified control |
| `g53_mod49_high_scout` | retained rejected control |
| `lp333_orbit_lock` | one-shot replay whose result is in the audit note |
| `q18_basin_escape` | exact shell replaced the search |
| `order6_word_bound` | the bound is a report number |
| `c985_binary_projective_bench` | measurement is inside the C985 report |

## Parity

Baselines: all twelve binaries built in release profile from `HEAD` **before** any file was moved,
retained with `papers/complete-repair-ports/ergodis/scripts/retain-bin.sh` as
`~/.cache/ergodis/bin/<bin>-425918b4a` with `.sha256` sidecars and `MANIFEST.tsv` rows. Two foreign
C1037 commits landed on `main` during this task (`5aa10ed38`, `62f2cd6d7`); they touch only
`papers/complete-repair-ports/ergodis/scripts`, the summary figures, and a `notes/` file, so the
retained executables remain valid controls for these twelve tools. New side:
`~/.cache/ergodis/target/ergodis-private/release/ergodis-tools`, release profile, built after the
clippy repairs below.

**Flag surface first.** For all eleven tools that take flags, the complete set of long options
extracted from `--help` is identical between the retained binary and the new subcommand, including
each of `certdist`'s six jobs and each of `certiis`'s six commands checked separately.

**Behaviour.** Wall-clock fields are dropped before hashing: `structural verification: … in N s`,
`"*_ns"`, `"*_micros"`, `"*_seconds"`, `"*_microseconds"`, and the derived `rank_replay_speedup`.
Where a report embeds its own output path, the two runs' distinct output paths are normalized to one
name. No case exceeded five minutes; the longest was the `certdist verify` replay at a few seconds.

| Tool | Case | Compared artifact | Digest (SHA-256, normalized) | Verdict |
|---|---|---|---|---|
| `certdist` | `verify --certificate evidence/certdist/certificates/r1elite01-x-certificate.json --input ~/.cache/ergodis/c1018/qldpc/r1elite01-x.json` | stdout | `07742262951586c89a4af9cf604ac446303748f6f4c78641463d51581760d937` | equal |
| `certiis` | `selftest` | stdout | `dd46c8fd5e3e208097eae9b3d9331bf20151d9742b277f7f70cd6f529d78d481` | equal |
| `qdist_to_ergodis` | `--stem toy --direction x --maximum-weight 4 --upstream-revision <40 hex> --discover-symmetry --out F` on a constructed `[[4,2,2]]` stem | output JSON | `b20afd9cf0b0e10bed612434e6f97132d7fad6b90c4ea9db03e8621fecba2111` | equal (byte-identical, no normalization) |
| `css_bp_osd_spike` | `--input r1elite01-x.json --threads 4 --method exhaustive --osd-order 10 --iteration-candidates 1,8,64,300 --target-weight 24 --evidence F` | stdout and the evidence JSONL (identical content) | `5bb63b55ece2f7be5dd341682f014b2a24731865525fb3d399cadfd8712b12ad` | equal |
| `c985_extension_field_elimination_bench` | `table 5 8 9 12345 1000` | stdout JSON | `5ee81da98488681790fb01b6428a67773ae861e84a186447ca76501e6dc7191f` | equal |
| `c985_extension_field_elimination_bench` | `binary 5 8 9 12345 1000` | stdout JSON | `e9501d8dbba5f6f68956e1f7684b10b53931846596cefb15a6249eab1a36b7b9` | equal |
| `campaign_rpc` | `--run-dir <empty dir> --op status` | stderr, exit 1 both sides | `af6a8923d9e190f38f71e11323393d2e430f36379b6b901edeb8dda0412e6803` | equal (matched failure) |
| `alignment_root_corpus` | `--points 8 --budget 6 --output F --report F` | corpus JSONL | `e0e0e32353702f3bd525a02f3a759bc26cb32d3eb227980184c52f5287dee04d` | equal |
| `alignment_root_corpus` | same run | report JSON, output path normalized | `a166a2b8352673e137112ae19a7ac5fa1c3631f3f133488b7efe6a58b95bb015` | equal |
| `routing_policy_audit` | the committed replay: `--report evidence/alignment-root-cost-routing-report.json evidence/alignment-root-cost-routing-heldout-report.json --package-root . --minimum-reports 2 --output F` | policy JSON | `c2a35c6565e4de85386be0b971b90fb3d146f69bc66260b7db69eb70635bd313` | equal |
| `routing_policy_audit` | same run | stdout | `2ca9a5dab2f13517250d14f790de5679f0bb2c4045af948b027e3c32ad148cd2` | equal |
| `target_strategy_audit` | the committed replay from `evidence/alignment-root-cost-routing-README.md` | stderr, exit 1 both sides | `77c9a0e44773c9068a3284e60e01b31d15439e1286f4cd3a16242004b0616fb9` | equal (matched failure) |
| `semantic_affine_census` | no arguments | stdout JSON | `10147cd37b66ecd741737734a77955c32452df0e98dfad0339088ec53ce66efb` | equal |
| `semantic_rank_census` | no arguments | stdout JSON | `7b22d7b37fa086e1d9d57de03b2558e70241ace95dc316c16c3e39402e1ee8a0` | equal |
| `c80_hall_rematch` | the committed q=13 replay: `--q 13 --states 300 --seed 98508030 --deterministic --threads 12 --summary F` | summary JSON | `c0fd862095e9d970b635cb67e6c735e5863c881120469e9243fc71e70df02d18` | equal (byte-identical) |

Two cases are matched failures rather than matched successes. `target_strategy_audit` and
`campaign_rpc` both require a live campaign daemon and manifest, which this pass did not stand up;
old and new produce the same exit code and the same error text at the same point
(`campaign did not become ready within ten seconds`, `cannot read campaign manifest`). Their flag
surfaces are identical and their bodies are unchanged, so this is parity of everything reachable
without a daemon, and a daemon-backed replay is the residual gap.

Two constructed cases replace an unavailable committed one. `qdist_to_ergodis` and
`css_bp_osd_spike` are recorded against QDistSAT LP-714 and LP-1768 inputs that need an external
`QDistSAT` checkout and a `WORK_ROOT` that no longer exists on this host. `qdist_to_ergodis` was
therefore run on a constructed `[[4,2,2]]` stem with the committed flag set, and `css_bp_osd_spike`
on the committed flag set against an existing Ergodis CSS input,
`~/.cache/ergodis/c1018/qldpc/r1elite01-x.json`. The
`c985_extension_field_elimination_bench` case is likewise constructed: no note carries a literal
argument vector for it, and its own assertion caps the fixture at 8 rows by 9 columns.

The `c80_hall_rematch` q=13 case reproduces old and new byte for byte, but neither equals the
committed `evidence/c80-hall-rematch-q13-300.json`: the committed file is
`"schema": "c80-hall-rematch/v1"` recorded at 16 threads, and the code at `HEAD` emits
`c80-hall-rematch/v2`. That drift predates this task — see "Foreign issues".

## Rewritten replay lines

| File | Change |
|---|---|
| `evidence/certdist/scripts/run-acceptance.sh` | `BIN="$CD/shim-target/release/certdist"` replaced by `TOOLS="${ERGODIS_TOOLS:-$HOME/.cache/ergodis/target/ergodis-private/release/ergodis-tools}"`; each `"$BIN"` call site becomes `"$TOOLS" css certdist` |
| `evidence/certdist/scripts/run-headtohead.sh` | same |
| `evidence/certdist/scripts/run-regen.sh` | same |
| `evidence/certdist/scripts/run-resume.sh` | same (five call sites, including the two `setsid` launches) |
| `evidence/certdist/scripts/run-verify.sh` | same |
| `evidence/certdist/SHA256SUMS.scripts` | five script digests refreshed; the shim `Cargo.toml` and `summarize.py` rows are unchanged |
| `evidence/alignment-root-cost-routing-README.md` | three replay blocks: `cargo run --release --bin <bin> --` → `cargo run --release -p ergodis-tools -- <subcommand>` for `alignment_root_corpus`, `target_strategy_audit`, `routing_policy_audit` |
| `evidence/alignment-root-sized-routing-README.md` | two replay blocks, same rewrite |
| `evidence/c985-target-strategy-c880-README.md` | two `target_strategy_audit` replay blocks, same rewrite |

Every rewritten block also drops its `CARGO_TARGET_DIR=../rust/target-c985-private-profile` prefix.
That prefix directed the build into a per-experiment target directory, which `ergodis-private/AGENTS.md`
forbids; without it the workspace's `.cargo/config.toml` sends the build to the shared
`~/.cache/ergodis/target/ergodis-private`. All five `run-*.sh` scripts still pass `bash -n`.

`docs/CAMPAIGNS.md` names `alignment_root_corpus`, `target_strategy_audit`, and
`routing_policy_audit` in prose only; its single `--bin` line builds `ergodis-campaign` and
`ergodisctl`, which this task did not touch. Nothing there needed rewriting.

Two files name a moved binary as a **path recorded during a past measurement**, not as a replay
command, and were left alone: `evidence/semantic-rank-census-v1.json`
(`"binary": "ergodis-private/target/release/semantic_rank_census"`) and
`evidence/certdist/SHA256SUMS.binaries` (a hash of the shim-built `certdist` executable). Editing
either would falsify the record of what was measured. Dated notes under `notes/` were likewise not
edited; they get the commit-pin table.

## Clippy repairs in the moved files

`cargo clippy -p ergodis-tools --all-targets -- -D warnings` reported 15 lints after the move, all
in moved files. Four are rewrites; the rest are targeted `#[allow]`s with a one-line reason, because
the flagged spelling carries information the mechanical fix erases. None is in a solve hot loop.
Every parity case above was re-run against the rebuilt binary after these edits and still matches.

| Site | Lint | Action |
|---|---|---|
| `qdist_to_ergodis.rs`, four sites | `manual_is_multiple_of` | Rewritten to `is_multiple_of`. Equivalent on unsigned operands. |
| `css_bp_osd_spike.rs:152` | `needless_borrow` | `&prepared.code` → `prepared.code`; it was already a reference. |
| `certdist.rs:810` | `unnecessary_lazy_evaluations` | `.then(\|\| …len() as u16)` → `.then_some(…)`; the length is computed before the witness moves. |
| `certdist.rs:99` | `question_mark` | `let … else { return None }` → `?`. |
| `certdist.rs`, `core_random` and `cmd_plan` | `too_many_arguments` | `#[allow]`: one parameter per command-line flag, so the signature is the command contract. |
| `certiis.rs`, `plant_block` | `too_many_arguments` | `#[allow]`: each argument is one dimension of the planted infeasible block. |
| `c80_hall_rematch.rs`, three loops | `needless_range_loop` | `#[allow]`: the index is the pencil slope (and intercept), and it selects into two arrays at once. |
| `certiis.rs:402` | `needless_range_loop` | `#[allow]`: `task` indexes `adjacency`, `demand`, and the `degree` being filled. |
| `certiis.rs:508` | `dead_code` | `#[allow]` on `matching_micros` and `minimization_micros`: both are `#[serde(skip)]` timing fields recorded on every run and kept out of the certificate. |

## One test repair the move forced

`certiis::tests::evidence_publication_is_create_only` creates a scratch directory under
`CARGO_TARGET_DIR`, falling back to the relative path `target`. This workspace sets its target
directory through `.cargo/config.toml` rather than the environment variable, so the fallback was
taken, and the relative path resolved against the test process's working directory. That was
`ergodis-private/` while the file was a root-package binary and became
`ergodis-private/tasks/tools/`, where no `target` directory exists, so the test panicked in
`create_dir`. The fallback is now the directory holding the test executable, which is inside the
shared out-of-tree target directory by construction and does not depend on the working directory.
No new target directory is created. `cargo test -p ergodis-tools` then reports
`ok. 30 passed; 0 failed`, which is C1035's 29 plus the
`c985_extension_field_elimination_bench` binary/table equivalence test that came with the move.

## Performance rules that applied, and how checked

The twelve moved tools are operator drivers: argument parsing, file and subprocess I/O, JSON
serialization, and calls into the tier-1 library or the public core. No Ergodis solve kernel moved.

- **A move must not add allocation, dynamic dispatch, or indirection in a hot path.** Each file's
  edits are the derive swap, the `main` → `run` rename, and the clippy repairs above. Every tool's
  body, and therefore every call it makes into the library or the core, is unchanged. The one added
  indirection is the `main.rs` dispatch `match` (two levels for the `css` group), which executes
  once per process before any search begins.
- **No run-constant branch inside a loop.** The subcommand is resolved once at startup, as the
  binary name was before.
- **Worker ownership and contention-free parallelism.** The parallel tools — `c80_hall_rematch`,
  `css_bp_osd_spike`, `certdist`'s built-in ordered-statistics decoder — keep their `--threads`
  plumbing and per-worker scratch exactly as written.
- **Exact result and certificate parity.** Established by the parity table, including the
  `c80_hall_rematch` and `qdist_to_ergodis` byte-identical artifacts and the `routing_policy_audit`
  committed replay.
- **Counter A/B evidence.** Not collected and not required: no hot-loop instruction, branch, or
  layout change was made. The `needless_range_loop` sites were left as written precisely so no loop
  body changed shape.
- **Build artifacts.** No target directory was created; everything built into the shared
  `~/.cache/ergodis/target/ergodis-private`, and the baselines are retained executables under
  `~/.cache/ergodis/bin/`, not preserved build trees.

`ergodis-private/performance/kernel-registry-v1.json` names no kernel in any moved file, so no
registry entry changed.

## Gate results

Run from `ergodis-private/` through `~/.claude/bin/run-quiet`.

- `cargo check --workspace --all-targets`: exit 0, 0.70 s. Output verbatim:

  ```
      Checking ergodis-tools v0.0.0 (/home/tavis/src/othello/ergodis-private/tasks/tools)
      Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.70s
  ```

- `cargo fmt --all --check`: exit 0, no output.

- `cargo clippy --workspace --all-targets -- -D warnings`: **fails**, entirely on retained
  `src/bin/*.rs` files that phase two owns. The union observed across the run is
  `src/bin/g41_q29_matched_pair_cache.rs` (three `needless_range_loop`) and
  `src/bin/blind_raw_holdout_harness.rs` (`items_after_test_module`, `type_complexity`). Clippy
  stops at the first failing crate target, so that list may not be exhaustive. The two targets this
  task owns pass:

  ```
  cargo clippy -p ergodis-tools --all-targets -- -D warnings
      Checking ergodis-tools v0.0.0 (/home/tavis/src/othello/ergodis-private/tasks/tools)
      Finished `dev` profile [unoptimized + debuginfo] target(s) in 2.19s

  cargo clippy -p ergodis-private --lib --profile test -- -D warnings
      Finished `test` profile [unoptimized + debuginfo] target(s) in 0.03s
  ```

  Three of C1035's recorded backlog files were deleted outright by this task
  (`g41_q29_target_cache_participation`, `g41_q29_q58_behavior_edge_census`,
  `g41_q87_behavior_edge_census`), and the `certdist`, `certiis`, and `css_bp_osd_spike` failures
  it recorded are now fixed in `ergodis-tools`. What remains is a two-file backlog inside the
  Hadamard set.

- `cargo test --workspace`: exit 0, 12 min 28 s. Across every test binary in the workspace,
  617 passed, 0 failed, 0 ignored, 0 filtered out; no target reported `FAILED`. The
  `ergodis-private` library suite alone reports

  ```
  test result: ok. 566 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 659.78s
  ```

  unchanged from C1035, since no library code changed. The workspace total falls from C1035's 621
  to 617 because four tests were deleted with their BANKED and DEAD binaries, while
  `ergodis-tools` gains the `c985_extension_field_elimination_bench` equivalence test that came with
  the move. The first run of this gate failed on one test in a moved file; see the section above.

## Skipped, and why

1. **No daemon-backed replay of `target_strategy_audit` or `campaign_rpc`.** Both need a live
   campaign; standing one up is outside this phase. Parity is established on flag surface and on a
   matched failure path.
2. **No LP-714 / LP-1768 replay.** The QDistSAT checkout and the `WORK_ROOT` those committed
   commands assume are absent on this host, so `qdist_to_ergodis` and `css_bp_osd_spike` were run on
   constructed cases with the committed flag sets instead.
3. **`evidence/certdist/scripts/certdist-build-shim-Cargo.toml` was left byte-identical**, so its
   `SHA256SUMS.scripts` row still verifies. It is now stale: its `[[bin]] path` points at
   `ergodis-private/src/bin/certdist.rs`, which no longer exists, and the source it named is now a
   subcommand module with no `main`, so the shim can no longer build. The five scripts that used its
   output no longer reference it. Whether to delete it or rewrite it as a historical note is a
   reviewer decision, not one this task should take unilaterally against a hashed evidence bundle.
4. **Dated notes under `notes/` were not rewritten.** Per the task, they get the commit-pin table
   rather than edited replay lines.

## Foreign issues noticed

- `ergodis-private/evidence/c80-hall-rematch-q13-300.json` is a `c80-hall-rematch/v1` summary, while
  the code at `HEAD` emits `c80-hall-rematch/v2` and its `threads` field differs from the recorded
  16. The committed evidence file has not been regenerated since the schema moved. Old and new
  binaries agree exactly, so this is not a C1036 regression, but the evidence bundle no longer
  reproduces from its own replay command.
- The workspace clippy gate stays red on `g41_q29_matched_pair_cache.rs` and
  `blind_raw_holdout_harness.rs`. Both are phase-two files.
- Two foreign C1037 commits (`5aa10ed38`, `62f2cd6d7`) landed on `main` mid-task, touching
  `papers/complete-repair-ports/ergodis/scripts`, the summary figures, and a `notes/` file. They do
  not affect the retained baselines.

## Working tree

Nothing is committed. `git mv` and `git rm` are staged; the file edits are in the working tree.
Changed paths are confined to `ergodis-private/` (including `Cargo.lock`, which picks up the
`sha2` dependency for `ergodis-tools`) and this note under `notes/`.

## Reviewer closeout (2026-09-02)

The moves landed in commit `adfc91f53`; the last commit containing every deleted bin is that
same commit's parent chain, i.e. the deleted files are present at `adfc91f53` and absent from
the deletion commit that follows. Deletion set re-verified against the triage table: 38 BANKED
and 10 DEAD, no LIVE bin removed. The certdist `SHA256SUMS.scripts` verifies. The stale
`c80-hall-rematch-q13-300.json` record and the unbuildable `certdist-build-shim-Cargo.toml` are
left untouched as C80 and certdist artifacts respectively.

