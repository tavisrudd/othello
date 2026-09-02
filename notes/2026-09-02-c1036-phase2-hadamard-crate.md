# C1036 phase two — the 43 Hadamard-2092 bins into one `hadamard` binary

**Date**: 2026-09-02
**Lane**: `complete-ports`
**Scope**: `ergodis-private/` and `notes/`. The public core under
`papers/complete-repair-ports/ergodis` was not modified, and neither was
`papers/complete-repair-ports/ergodis/{docs,scripts,evidence,BENCHMARKS.md}`, which C1038 owns.

Triage authority: `notes/2026-09-02-c1036-hadamard-bin-triage.md`. Pattern and parity method:
`notes/2026-09-02-c1036-phase1-tools-and-deletions.md` and
`notes/2026-09-02-c1035-ergodis-private-workspace-split.md`.

`ergodis-private/src/bin` held 43 auto-discovered binaries after phase one, exactly the
Hadamard-2092 LIVE set the triage assigns to phase two. All 43 moved with `git mv` into the new
tier-2 crate `ergodis-private/tasks/hadamard-2092` as subcommands of one binary, `hadamard`.
`ergodis-private/src/bin` is now gone, so the whole workspace satisfies the no-new-binary rule:
tier 1 is a library only, and every driver is a subcommand of its lane's tier-2 binary.

## Baselines

All 43 binaries built in the `release` profile at `HEAD` = `5cc2ad53c` **before** any file moved,
and were retained with `papers/complete-repair-ports/ergodis/scripts/retain-bin.sh` as
`~/.cache/ergodis/bin/<bin>-5cc2ad53c` with `.sha256` sidecars and `MANIFEST.tsv` rows. No bin
failed to build, so no baseline was skipped. The working tree carried three untracked C1038 files
at the time, so `MANIFEST.tsv` records these baselines as `dirty`; none of the three is a Rust
source file reachable from this workspace's dependency graph
(`notes/2026-09-02-c1038-negative-control-benchmark-tier.md`,
`papers/complete-repair-ports/ergodis/docs/ergodis-shape-classifier.md`,
`papers/complete-repair-ports/ergodis/examples/negative_control_tier.rs` — the last is an
`examples/` target of the public core, not a library or binary input).

## Crate and subcommand tree

New workspace member `ergodis-private/tasks/hadamard-2092` (package `hadamard-2092`, binary
`hadamard`), added to `ergodis-private/Cargo.toml`'s `members` list. It depends on `anyhow`,
`clap`, `ergodis` (public core, `control-plane` + `parallel`), `ergodis-private` (tier 1), `serde`,
`serde_json`, and `sha2` — the union of what the 43 files already imported, and no more.

`src/main.rs` holds only the command tree and its dispatch. Every module exposes
`pub struct Arguments` (a `clap::Args` derive, empty where the binary took no arguments) and
`pub fn run(arguments: Arguments) -> anyhow::Result<()>`. Sector directories carry a `mod.rs` whose
only content is `pub mod` declarations and a one-line doc comment.

```
hadamard g41 quotient-proof | digit-cache | digit-witnesses | z18-projection
hadamard g41 q174 joint | joint-join | full-q87-join | energy-theorem
                        | flip-proof | target-fibres | target-fibre-replay | q87-replay
hadamard g41 q29  block-specs | matched-pair-cache | cache-audit | cycle-proof
                        | campaign | hit-lift | hit-replay | work-model
hadamard g41 q87  energy | exact-energy
hadamard g53      search | q4-proof | q4-oracle
hadamard g91      defect-proof
hadamard g133     q2-proof | shift-proof | cycle-mod11-proof | evolve-adapter
hadamard q18      energy-corpus | local-repair | q29-bridge | unassumed-evolve
hadamard order6   margin-evolve | q29-repair
hadamard evolve   banked-rules {emit,audit} | banked-semantics {emit,audit}
                        | raw-features | blind-holdout
hadamard proof    perf
```

This is the triage report's proposed tree with three name resolutions the triage left open:

1. The triage wrote `hadamard evolve banked-rules {emit,audit}` without saying how the two files
   should be laid out. They are flat files `src/evolve/banked_rules_{emit,audit}.rs` and
   `src/evolve/banked_semantics_{emit,audit}.rs` under a two-level `clap` group, rather than a
   third directory level.
2. `raw_feature_evolve_adapter` and `blind_raw_holdout_harness` become
   `src/evolve/raw_features.rs` and `src/evolve/blind_holdout.rs`, matching the triage's
   `raw-features` and `blind-holdout` command names.
3. `multiplier_z18_projection` is a shared projection driver used by several sectors' derivations,
   not a g41-specific one; the triage put it under `hadamard g41 z18-projection` and this pass kept
   it there rather than inventing a top-level `shared` group.

## Old command → new command

Every flag, default, `requires`, `conflicts_with`, `value_enum`, and positional order is carried
over unchanged. Where a binary parsed positional `std::env::args()` by hand, the same values are
now `clap` positionals in the same order. Where a binary hand-parsed a `--name=value` form,
`clap` now also accepts the space-separated `--name value` spelling; that is a superset of the old
surface, not a change to it.

| Old binary | New command |
|---|---|
| `g41_quotient_filter_proof` | `hadamard g41 quotient-proof` |
| `g41_joint_digit_cache` | `hadamard g41 digit-cache` |
| `g41_joint_digit_witnesses` | `hadamard g41 digit-witnesses` |
| `multiplier_z18_projection` | `hadamard g41 z18-projection` |
| `g41_q174_joint` | `hadamard g41 q174 joint` |
| `g41_q174_joint_join` | `hadamard g41 q174 joint-join` |
| `g41_q174_full_q87_join` | `hadamard g41 q174 full-q87-join` |
| `g41_q174_energy_theorem` | `hadamard g41 q174 energy-theorem` |
| `g41_q174_flip_proof` | `hadamard g41 q174 flip-proof` |
| `g41_q174_target_fibres` | `hadamard g41 q174 target-fibres` |
| `g41_q174_target_fibre_replay` | `hadamard g41 q174 target-fibre-replay` |
| `g41_q174_q87_replay` | `hadamard g41 q174 q87-replay` |
| `g41_q29_block_spec_census` | `hadamard g41 q29 block-specs` |
| `g41_q29_matched_pair_cache` | `hadamard g41 q29 matched-pair-cache` |
| `g41_q29_pair_target_cache_audit` | `hadamard g41 q29 cache-audit` |
| `g41_q29_pair_target_cycle_proof` | `hadamard g41 q29 cycle-proof` |
| `g41_q29_profile_campaign` | `hadamard g41 q29 campaign` |
| `g41_q29_profile_hit_lift` | `hadamard g41 q29 hit-lift` |
| `g41_q29_profile_hit_replay` | `hadamard g41 q29 hit-replay` |
| `g41_q29_direct_lift_work_model` | `hadamard g41 q29 work-model` |
| `g41_q87_energy` | `hadamard g41 q87 energy` |
| `g41_q87_exact_energy` | `hadamard g41 q87 exact-energy` |
| `g53_search` | `hadamard g53 search` |
| `g53_sparse_q4_proof` | `hadamard g53 q4-proof` |
| `g53_sparse_q4_oracle` | `hadamard g53 q4-oracle` |
| `g91_defect_obstruction` | `hadamard g91 defect-proof` |
| `g133_exact_q2_proof` | `hadamard g133 q2-proof` |
| `g133_exact_shift_proof` | `hadamard g133 shift-proof` |
| `g133_cycle_mod11_proof` | `hadamard g133 cycle-mod11-proof` |
| `g133_evolve_adapter` | `hadamard g133 evolve-adapter` |
| `q18_energy_corpus` | `hadamard q18 energy-corpus` |
| `q18_local_repair` | `hadamard q18 local-repair` |
| `q18_q29_binary_bridge` | `hadamard q18 q29-bridge` |
| `q18_unassumed_evolve` | `hadamard q18 unassumed-evolve` |
| `order6_margin_evolve` | `hadamard order6 margin-evolve` |
| `order6_q29_exact_repair` | `hadamard order6 q29-repair` |
| `banked_rule_evolve_adapter` | `hadamard evolve banked-rules emit` |
| `banked_rule_evolve_audit` | `hadamard evolve banked-rules audit` |
| `banked_semantic_evolve_adapter` | `hadamard evolve banked-semantics emit` |
| `banked_semantic_evolve_audit` | `hadamard evolve banked-semantics audit` |
| `raw_feature_evolve_adapter` | `hadamard evolve raw-features` |
| `blind_raw_holdout_harness` | `hadamard evolve blind-holdout` |
| `proof_synthesis_perf` | `hadamard proof perf` |

### Argument-surface changes that are not pure renames

Ten of the 43 read `std::env::args()` positionally rather than through `clap`.

- **Leniency preserved.** `order6_margin_evolve` (four positionals), `q18_unassumed_evolve` (two),
  and `q18_energy_corpus` (`samples`, `seed`) used
  `.and_then(|value| value.parse().ok()).unwrap_or(DEFAULT)`, so a malformed argument silently fell
  back to the default. Those positionals are declared `Option<String>` and the original expression
  is applied verbatim to the field, rather than being tightened into a typed `clap` positional that
  would reject the same input.
- **Error text on a missing or malformed required argument changes.** Where the original used
  `.context("usage: …")?` or `.expect("usage: …")`, the value is now a required `clap` positional,
  so `clap`'s usage error replaces the old `anyhow` context or panic message. This affects
  `g133_exact_shift_proof`, `order6_q29_exact_repair`, `q18_local_repair`, `q18_q29_binary_bridge`,
  and the `g41_q174_*` drivers that took positional artifact paths. Success paths are unaffected.
- **Doc gap closed.** The triage noted that only ten of the 103 original files carried a `//!` doc
  comment and only six a `#[command(about = …)]`. Every one of the 43 subcommands now carries a
  one-line `about` on its `Command` variant, so `hadamard <sector> --help` lists them. Where no
  `//!` or `about` existed, the text is a description reconstructed from the tier-1 library modules
  that driver calls, and is marked as such here rather than presented as lifted documentation.

## Parity

Controls: the 43 retained release executables `~/.cache/ergodis/bin/<bin>-5cc2ad53c`. New side:
`~/.cache/ergodis/target/ergodis-private/release/hadamard`, release profile, built after the lint
actions above; every case below was run against that final binary.

**No committed replay case exists for any of the 43.** A bounded search for `--bin <name>` over
`notes/`, `ergodis-private/evidence`, and `ergodis-private/docs` returns no line naming any of them,
and the triage report's committed-replay table lists only lane-neutral phase-one tools. Every case
below is therefore constructed: the cheapest invocation that exercises the driver's own argument
handling and its first call into the library, with thread counts held at or below four to respect
the twelve-worker cap and to keep each side inside the five-minute budget. Each side ran under
`timeout 300`; nothing was run at an estimated cost above ten minutes.

**Flag surface first.** For the thirteen drivers that already used `clap`, the complete set of long
options extracted from `--help` is identical between the retained binary and the new subcommand,
including all 22 flags of `g53 search` with their `requires` relations. The other thirty binaries
had no `--help` at all — they parsed `std::env::args()` positionally and ignored `--help`, running
the computation instead — so for those the argument surface is established by the per-file
declarations recorded above rather than by a help comparison.

**Normalization before hashing.** Wall-clock and hardware-counter fields are dropped, since they are
measurements rather than results: JSON keys ending in `_seconds`, `_micros`, `_microseconds`,
`_nanos`, `_ns`, `_millis`, `_elapsed`, `_wall`, `_duration`, `_instructions`, `_cycles`,
`_per_operation`, `_rss`, and `_throughput`, plus the `structural verification: … in N s` line.
Scratch output paths are normalized to one name where a report embeds its own output path. For the
three panicking cases the panic's source location and the process id are normalized as well —
`src/bin/q18_local_repair.rs:22:63` necessarily becomes
`tasks/hadamard-2092/src/q18/local_repair.rs:27:63`, which is a file-location artifact of the move
and not a behaviour difference; with those two fields normalized the panic text, the message, and
the exit status match exactly.

| Command | Case | Compared | Digest (SHA-256, normalized) | Verdict |
|---|---|---|---|---|
| `g41 z18-projection` | no arguments | stdout | `50353c2cfb45cbedb5ffd1ea93da8c1f01980a34fd1fd44a75c015925e0caf40` | equal |
| `g41 quotient-proof` | no arguments (full sealed q0-q9 proof) | stdout | `e1ac1b2fa5847eb1c92170c496cb5688e26a4b02d9f82f908f13dd4d3e78fb14` | equal |
| `g41 q174 flip-proof` | no arguments | stdout | `30fbe706f11c92a16fa83e39db32fbfbf9126a9aefd7a017111ec14c166929bb` | equal |
| `g41 q174 joint` | `0 5` | stdout | `81ac955b6b60ea9ffea728686a793dec7829ef6f4948d4d222b35846dc545a3d` | equal |
| `g41 q174 joint-join` | `--maximum-layer-entries=1000 --maximum-matches=1` | stdout+stderr, exit 1 both sides | `47f48caca63938e7468d9e102ce8538f9e3fbf8195639d64a974750d3257515b` | equal (matched failure) |
| `g41 q174 target-fibres` | `5` | stdout | `ff1cb78f54ff7a57f5014f5b486e90c13be65901492909bffad6997551a51c6f` | equal |
| `g41 q174 q87-replay` | `0 0 0 0` | stdout | `e5eb01dc3d4cd03ed7d51d446d1047d6ffb7dc24aa7de3829b6397f2a67fe868` | equal |
| `g41 q174 full-q87-join` | absent artifact path | stderr, exit 1 both sides | `1fdf822310db107ffa50d38e4b355bd31e4e605993eb5242b2ec5eda25a327a4` | equal (matched failure) |
| `g41 q174 target-fibre-replay` | absent artifact path, block `0` | stderr, exit 1 both sides | `31608247893a6052cf610e6f17e0efa70427c0b67c4f2dc57f7934bf9e856d5c` | equal (matched failure) |
| `g41 q29 hit-replay` | no arguments (sealed selection replay) | stdout | `ba8517a694f3b8490723c7596cf58ac1888dae8f892ac8e281487bf5f301066d` | equal |
| `g41 q29 hit-lift` | no arguments (registered defaults) | stdout | `9334f52618fbb6b7c47f395c6b53c7422b89ffaf2dbe0efd3292b7369f1ef800` | equal |
| `g41 q29 campaign` | `--threads 4 --shard-start 0 --shard-end 1` | stdout | `d4f90f79fc2a53e23d9563c0844e37295adb3147614e4f7a46c0d17ce36f405b` | equal |
| `g41 q29 block-specs` | absent cache | stderr, exit 1 both sides | `1fdf822310db107ffa50d38e4b355bd31e4e605993eb5242b2ec5eda25a327a4` | equal (matched failure) |
| `g41 q29 cache-audit` | absent cache | stderr, exit 1 both sides | `1fdf822310db107ffa50d38e4b355bd31e4e605993eb5242b2ec5eda25a327a4` | equal (matched failure) |
| `g41 q29 cycle-proof` | absent scopes file | stderr, exit 1 both sides | `1fdf822310db107ffa50d38e4b355bd31e4e605993eb5242b2ec5eda25a327a4` | equal (matched failure) |
| `g41 q29 work-model` | absent cache and participation, `--threads 4` | stderr, exit 1 both sides | `1fdf822310db107ffa50d38e4b355bd31e4e605993eb5242b2ec5eda25a327a4` | equal (matched failure) |
| `g41 q29 matched-pair-cache` | absent target cache, `--threads 4` | stderr, exit 1 both sides | `96e9afa292bf9c61aa787c8d16fa7e4f0d58dfe625bfd00e95ce5ee9887bd28f` | equal (matched failure) |
| `g41 q87 energy` | no arguments | stdout | `637109b571e006a5f5a471a53c892a49f43019517d7fad9d3bdaa2dca4e7c46c` | equal |
| `g41 q87 exact-energy` | `0` | stdout | `b139bf0c7f46aa655a3a8dfd6be1130fcba7893dbfa8712cf4a8ffc42156af85` | equal |
| `g53 search` | `--threads 1 --iterations-per-thread 1000 --seed 1` | stdout | `91518231bd417f902dc4072d484f0f156d8e78eb9d84726c5e3901a950babae9` | equal |
| `g53 q4-proof` | `--threads 4` (full sealed proof) | stdout | `5ed63571ed027a65b3eadd3f5cc06dcce66537540c11c26063880ad5728564c9` | equal |
| `g53 q4-oracle` | `--threads 4` (independent oracle) | stdout | `02e307a825a336d95b22fef98f531b0571d1c56e93b230781d2db860cae407a6` | equal |
| `g91 defect-proof` | no arguments | stdout | `61ef9a6268d8e6433c68a4379e3d9c28a2729fc25ba4aae758c7c0ac758c9839` | equal |
| `g133 q2-proof` | no arguments (sealed exact q2 proof) | stdout | `5848841b1c1decc6c4120539614f1c2c1df4b99a1432b3443559f2fb3d9d7f8e` | equal |
| `g133 shift-proof` | `6` (sealed exact q6 extractor proof) | stdout | `d41fc3077d84e87688c9833b5ff2e97823b2e5c1e465ad73ba25d3b90e024be6` | equal |
| `g133 cycle-mod11-proof` | no arguments | stdout | `73bccc4fe4812424c22d188550b829d79544928203ac099260b95774843aaea5` | equal |
| `g133 evolve-adapter` | `--shift 6 --output F` | stdout | `69a388e9841421a9cc68d5e33146d8803c2e266c0fd46ea4a6c9b448ad334fa9` | equal |
| `g133 evolve-adapter` | same run | the written campaign file | `ed993b4515f10a0ab4c8824676a7df7687a0a26473f12f96ba16d262ee2d2a47` | equal |
| `q18 energy-corpus` | `gate 100 0` | stdout | `147e507cdb10bfa769993018552cdec734a40d400612b7e8d484cbe50f2e160b` | equal |
| `q18 unassumed-evolve` | `1 1000` | stdout | `58246c1734d67df2bd2e8cb36fe5b45695df02ced12a80e6109f1677c02199d5` | equal |
| `q18 local-repair` | absent input | stderr panic, exit 101 both sides | `fc71d7e55d362bdca16c3bbcdccc92d3553e65be8f21fd232e7cb171a48ace2d` | equal (matched failure, panic location normalized) |
| `q18 q29-bridge` | two absent inputs | stderr panic, exit 101 both sides | `dc2d84a4c91ba8b9337b47f039dae8a2418ce2631521641571999f4afe9e3946` | equal (matched failure, panic location normalized) |
| `order6 margin-evolve` | `1 1000 none 1000` | stdout | `52a5499df3ec4a1f4556222c4918b225403553d5ccb611336ee181a921b3ba39` | equal |
| `order6 q29-repair` | absent evolve output | stderr panic, exit 101 both sides | `65242d1a2e524b49b1dbdfa5349637d7a14c4fa35b5c660e547e93aa19568a75` | equal (matched failure, panic location normalized) |
| `evolve banked-rules emit` | `--reduction subgroup-energy --output F` | stdout | `fc2e9232860c23732a9de25ef729323fbea2c6dafa1af313bd203e4199d62ea8` | equal |
| `evolve banked-rules emit` | same run | the written corpus file | `c68d59d5572acbd2b43386d05d87af4f0c9ad928e30dc6192009c2c5960b8770` | equal |
| `evolve banked-rules audit` | absent data directory, fresh run root per side | stderr, exit 1 both sides | `812a3823fbfe2ed20058a7e646cb11204135ca59da9040c18fd36ffad69fbb02` | equal (matched failure) |
| `evolve banked-semantics emit` | `--output-dir D` | stdout | `81a077a0ff79b23b98d5e445dc3c32bc864e99d9c0fa04452fd6bb39535da290` | equal |
| `evolve banked-semantics emit` | same run | every written corpus file, concatenated in sorted order | `4b46840412e2763140129dd75ceaa74bc3c598df532f6bc2b344e4e9e936c218` | equal |
| `evolve banked-semantics audit` | absent data directory | stderr, exit 1 both sides | `26bac6b82f7707ff1784ee709e9f8e08cd55d05c81c40c81d376c58528c966df` | equal (matched failure) |
| `evolve raw-features` | `--output-dir D` | stdout | `1a97257e93c69c2428a63815b9e4dbe3125f01b92c2fbabedf1c4d4b867586c4` | equal |
| `evolve raw-features` | same run | every written corpus file, concatenated in sorted order | `22727bbf1e6d5a46b1977fc9623a4b4a1e41708d33ee4d031d6bb5ba95f89205` | equal |
| `evolve blind-holdout` | absent data directory | stderr, exit 1 both sides | `62ffa71a1aa424e239a72d84c7b598c4133b58d8718fc394ab4573bbe535589a` | equal (matched failure) |
| `proof perf` | `--adapter g91 --kernel derive --iterations 1000` | stdout | `24a5d3e8be6faad31cdd1d0efa0faf216da45c72bfd7e06482b1057e1aa56217` | equal |
| `proof perf` | `--adapter g53-sparse --kernel replay --iterations 1000` | stdout | `24a5d3e8be6faad31cdd1d0efa0faf216da45c72bfd7e06482b1057e1aa56217` | equal |

Every sealed proof replay in the set reproduces exactly: the g41 exact q0-q9 quotient filter proof,
the g53 sparse q4 proof and its independent oracle, the g91 defect-obstruction proof, and all three
g133 proofs (exact q2, the exact q6 shift extractor, and the cycle-mod-11 identity). Those are the
replays the C1016 handoff still relies on, and they are the expensive end of this table — the g41
quotient proof and the g133 shift proof each run for minutes per side.

### The one genuine difference

`g41 q174 energy-theorem` on an absent witness cache prints a different **error string** on the two
sides, and only there:

```
old:  Error: Os { code: 2, kind: NotFound, message: "No such file or directory" }
new:  Error: No such file or directory (os error 2)
```

Both exit 1 at the same point with the same underlying `io::Error`. The cause is spec-directed: this
was the one driver returning `Result<(), Box<dyn std::error::Error>>`, whose `main` printed the
error's `Debug` form, and it now returns `anyhow::Result<()>` like every other module, whose `main`
prints the `Display` form. No success path is affected and no computation changed. Making the two
byte-identical would mean keeping `Box<dyn Error>` in one module out of 43, which is not worth the
inconsistency; it is recorded here instead.

### Two cases exceeded the budget

`g41 digit-witnesses` and `g41 digit-cache` both drive
`enumerate_g41_joint_digit_witnesses`, the enumeration behind the 47.6 MB joint digit-witness cache.
Both sides ran for the full 300 seconds and were killed, so neither produced output to compare and
neither produced an artifact. They are recorded as **not behaviour-compared**, not as parity. Their
`clap` flag surfaces are identical (both are in the thirteen checked above), their bodies are
unchanged apart from the derive swap and the `main` → `run` rename, and the enumeration itself lives
in the tier-1 library, which did not change. A real parity run for these two needs either a longer
budget or the sealed C1016 cache, which is absent on this host.

## Promoted library modules

None. No file among the 43 used a `#[path]` include, and only two declared a module at all
(`g53_search.rs` and `blind_raw_holdout_harness.rs`, each a `#[cfg(test)] mod tests`). Nothing was
shared between two subcommands that was not already a `pub` item of the tier-1 library, so no
library code changed.

## Lint allowances

`cargo clippy -p hadamard-2092 --all-targets -- -D warnings` reported six lints after the move.
Two are semantics-preserving rewrites; four are targeted `#[allow]`s with a one-line reason,
because the flagged spelling carries information the mechanical fix erases and each sits in or
beside a scan loop. No loop body changed shape.

| Site | Lint | Action |
|---|---|---|
| `evolve/blind_holdout.rs` | `items_after_test_module` | Rewritten: the whole `#[cfg(test)] mod tests` block moved verbatim from mid-file to the end of the file. Nothing else moved and `use super::{…}` still resolves. This was one of the two clippy failures C1036 phase one recorded as a phase-two backlog item. |
| `evolve/blind_holdout.rs`, `generic_constant_conjunction` | `type_complexity` | Rewritten: a `type FieldConstants = Vec<(usize, i64)>;` alias beside the existing `SparseClause` alias, used in the return type. No behaviour change; the function is a corpus-side proposer, not a solve loop. |
| `g41/q29/matched_pair_cache.rs`, `quartet_counts`, `for archetype in 0..2` | `needless_range_loop` | `#[allow]`: the index is the B archetype number and drives both `1 << archetype` and `counts[archetype]`. This was the other phase-one backlog item. |
| `g41/q29/matched_pair_cache.rs`, worker shard loop, `for side in 0..3` | `needless_range_loop` | `#[allow]`: the index is the pair-side channel shared by the worker tally and the shard counts. |
| `g41/q29/matched_pair_cache.rs`, merge loop, `for side in 0..3` | `needless_range_loop` | `#[allow]`: the index is the pair-side channel shared by the merged tally and each worker tally. |
| `g41/q29/block_specs.rs:152`, `for block in 0..4` | `needless_range_loop` | `#[allow]`: the index is the block position, shared with the witness mask and digit arrays. |

Both known phase-one clippy failures are therefore resolved: `blind_raw_holdout_harness.rs` by two
semantics-preserving rewrites outside any solve loop, and `g41_q29_matched_pair_cache.rs` by three
targeted allowances rather than a loop rewrite, which is the C1036 phase-one precedent for
`c80_hall_rematch`.

One rename was forced rather than chosen: `g41/q29/campaign.rs` already had a generic
`fn run<FIRST, SECOND>` dispatch helper, which collided with the module's required `run` entry
point. It is now `run_projection`, with all eight dispatch arms updated. This mirrors the
`c985_extension_field_elimination_bench` `run` → `bench` rename in phase one.

## Performance rules that applied, and how checked

The 43 drivers are exactly that: argument parsing, artifact I/O, JSON serialization, and calls
into the tier-1 `ergodis-private` library or the public core. No Ergodis solve kernel moved — every
search, join, proof-synthesis, and evolve kernel these files exercise lives in the library, and no
library file changed.

- **A move must not add allocation, dynamic dispatch, or indirection in a hot path.** Each file's
  edits are the `clap::Parser` → `clap::Args` derive swap, the `main` → `run` rename, the
  positional-argument declarations described above, the `run_projection` rename in
  `g41/q29/campaign.rs`, and the six lint actions. Every body — and therefore every call each
  driver makes into the library — is otherwise unchanged. The one added indirection is the
  `main.rs` dispatch `match`, two or three levels deep, executed once per process before any
  search begins.
- **No run-constant branch inside a loop.** The subcommand is resolved once at startup, exactly as
  the binary name was before.
- **Worker ownership and contention-free parallelism.** The parallel drivers — `g53 search`,
  `g53 q4-proof`, `g53 q4-oracle`, `g41 q29 matched-pair-cache`, `g41 q29 campaign`,
  `g41 q29 work-model`, `q18 unassumed-evolve`, `order6 margin-evolve` — keep their `--threads` (or
  positional thread-count) plumbing and per-worker scratch exactly as written, including
  `order6 margin-evolve`'s `assert!((1..=18).contains(&threads))`.
- **Exact result and certificate parity.** Established by the parity table below.
- **Counter A/B evidence.** Not collected and not required: no hot-loop instruction, branch, or
  layout change was made. The four `needless_range_loop` sites were left as written precisely so
  that no loop body changed shape.
- **Build artifacts.** No target directory was created. Every build went to the shared
  `~/.cache/ergodis/target/ergodis-private` declared by the workspace `.cargo/config.toml`, and the
  controls are retained executables under `~/.cache/ergodis/bin/`, not preserved build trees.

`ergodis-private/performance/kernel-registry-v1.json` names no kernel in any moved file, so no
registry entry changed.

## Gate results

Run from `ergodis-private/` through `~/.claude/bin/run-quiet`.

- `cargo check --workspace --all-targets`: exit 0, 10.71 s. Output verbatim:

  ```
      Checking ergodis v0.1.0 (/home/tavis/src/othello/papers/complete-repair-ports/ergodis)
      Checking ergodis-private v0.0.0 (/home/tavis/src/othello/ergodis-private)
      Checking gem-hunt v0.0.0 (/home/tavis/src/othello/ergodis-private/tasks/gem-hunt)
      Checking hadamard-2092 v0.0.0 (/home/tavis/src/othello/ergodis-private/tasks/hadamard-2092)
      Checking ergodis-tools v0.0.0 (/home/tavis/src/othello/ergodis-private/tasks/tools)
      Finished `dev` profile [unoptimized + debuginfo] target(s) in 10.71s
  ```

- `cargo fmt --all --check`: exit 0, no output.

- `cargo clippy --workspace --all-targets -- -D warnings`: exit 0, 9.10 s — **fully clean for the
  first time since the workspace split**. Output verbatim:

  ```
      Checking ergodis-private v0.0.0 (/home/tavis/src/othello/ergodis-private)
      Checking gem-hunt v0.0.0 (/home/tavis/src/othello/ergodis-private/tasks/gem-hunt)
      Checking hadamard-2092 v0.0.0 (/home/tavis/src/othello/ergodis-private/tasks/hadamard-2092)
      Checking ergodis-tools v0.0.0 (/home/tavis/src/othello/ergodis-private/tasks/tools)
      Finished `dev` profile [unoptimized + debuginfo] target(s) in 9.10s
  ```

- `cargo test --workspace`: exit 0, 13 min 51 s. Across every test binary in the workspace,
  617 passed, 0 failed, 0 ignored, 0 filtered out; no target reported `FAILED` and nothing panicked.
  The `ergodis-private` library suite alone reports

  ```
  test result: ok. 566 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 717.04s
  ```

  unchanged from C1036 phase one, since no library code changed. The new `hadamard` binary target
  contributes its own suite,

  ```
  Running unittests src/main.rs (…/debug/deps/hadamard-ecd82e246f554b94)
  test result: ok. 13 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 89.77s
  ```

  which is the two `#[cfg(test)] mod tests` blocks that travelled with `g53/search.rs` and
  `evolve/blind_holdout.rs`. They ran before as per-binary test targets and run now as modules of
  the one binary; the workspace total is unchanged at 617, the same as phase one.

`ls ergodis-private/src/bin` is empty and the directory has been removed; `ergodis-private` is again
a library-only tier-1 package with no `[[bin]]` target and no `src/bin`, as
`ergodis-private/AGENTS.md` requires.

## Rewritten replay lines

None were needed. A bounded search for `--bin <name>` and for `release/<name>` executable paths
across `notes/`, `ergodis-private/evidence`, and `ergodis-private/docs` returns no line naming any
of the 43 moved binaries; the `--bin` lines that do exist name phase-one tools
(`certdist`, `certiis`, `qdist_to_ergodis`, `css_bp_osd_spike`, `c80_hall_rematch`,
`semantic_affine_census`, `semantic_rank_census`, `c985_extension_field_elimination_bench`), C1018
and C985 binaries outside this workspace, or three `g53_*` names that were already absent from the
tree before this task. A separate filename-level search over `ergodis-private/{evidence,docs}` for
every moved bin's name returns no file at all. Consequently no `SHA256SUMS` covers a rewritten
script and none needed refreshing. This matches the triage report, whose committed-replay table
lists only lane-neutral phase-one tools.

## Skipped, and why

1. **No behaviour parity for `g41 digit-witnesses` and `g41 digit-cache`.** Both sides ran the full
   300-second budget without finishing the joint digit-witness enumeration. Recorded above as
   not-compared, with flag-surface parity only.
2. **No sealed-artifact replay anywhere.** `~/.cache/ergodis/c1016/` does not exist on this host, so
   every driver that consumes the sealed digit-witness cache, the q29 pair-target cache, a q174
   target-fibre artifact, a q18 or order-6 evolve output, or a banked-campaign data directory was
   exercised on a matched failure instead: identical exit status and identical error text at the
   same point, which is parity of everything reachable without those inputs. Twelve of the 45 cases
   are matched failures for this reason.
3. **No replay-line rewrites and no `SHA256SUMS` refresh.** Nothing under
   `ergodis-private/{evidence,docs}` names any of the 43 binaries, so step five of the task was a
   verified no-op rather than skipped work. Dated notes under `notes/` were not edited.
4. **No counter A/B.** No hot-loop instruction, branch, or layout change was made, so the
   `PERFORMANCE.md` counter requirement does not attach. See the performance section.
5. **The one error-string difference in `g41 q174 energy-theorem` was accepted rather than
   repaired**, for the reason given in the parity section.

## Foreign issues noticed

- `~/.cache/ergodis/` holds around sixty `target-c985-*` per-experiment target directories
  alongside the sanctioned shared `target/`. Both `ergodis-private/AGENTS.md` and the public core's
  `PERFORMANCE.md` forbid a per-experiment or per-A/B target directory, and forbid keeping one as a
  baseline. They are C985 artifacts, not C1036's, and this task did not touch them; they are the
  obvious first candidates for `cache-gc.sh`.
- No `~/.cache/ergodis/c1016/` directory exists on this host, so the sealed C1016 inputs several of
  these drivers consume — the 47.6 MB joint digit-witness cache, the q29 pair-target cache, the
  q174 target-fibre artifacts, the q18 and order-6 evolve outputs — are absent. That is why the
  parity table below carries so many matched failures. It also means the C1016 replay chain cannot
  currently be re-run end to end from a cold cache on this machine.
- The clippy backlog C1036 phase one handed to phase two is now cleared, so
  `cargo clippy --workspace --all-targets -- -D warnings` is green across the whole
  `ergodis-private` workspace for the first time since the split.
- Three untracked C1038 files were present in the working tree throughout
  (`notes/2026-09-02-c1038-negative-control-benchmark-tier.md`,
  `papers/complete-repair-ports/ergodis/docs/ergodis-shape-classifier.md`,
  `papers/complete-repair-ports/ergodis/examples/negative_control_tier.rs`). They are foreign work
  and were not touched, staged, or committed.

## Working tree

Nothing is committed, as the task requires. The 43 `git mv`s are staged; the file edits are in the
working tree. Changed and new paths:

- 43 staged renames from `ergodis-private/src/bin/*.rs` into
  `ergodis-private/tasks/hadamard-2092/src/<sector>/`, each with working-tree edits;
- new `ergodis-private/tasks/hadamard-2092/Cargo.toml`, `src/main.rs`, and eleven `mod.rs` files;
- modified `ergodis-private/Cargo.toml` (one added workspace member) and `ergodis-private/Cargo.lock`
  (the new member);
- this note under `notes/`.

`ergodis-private/src/bin/` is gone. Everything changed is inside `ergodis-private/` or `notes/`. The
three untracked C1038 files listed under foreign issues are not staged and were not touched.
