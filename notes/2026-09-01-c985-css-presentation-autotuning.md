# C985 equivalent CSS check-presentation autotuning

**Lane:** `complete-ports`

**Status:** accepted optional compiler optimization; target-depth speed depends on instance and depth

**Date:** 2026-09-01

## Result

Ergodis can now compile and persist deterministic equivalent presentations of
a CSS physical-check row space, and `css_distance_native` can optionally select
one presentation from a bounded seed bank by an exact shallow probe. The seed
is part of the compiled artifact identity and evidence schema. The default
unseeded compilation path remains the default and passes saved-binary 1T/12T
no-regression controls.

On the official QDistSAT LP1768 instance, sixteen candidates select seed 2 for
X and seed 14 for Z at exact radius 14. On radius-20 shard zero of 32:

| Direction | Default candidates | Selected candidates | Work ratio | Instruction ratio | Cycle ratio | Cycle t | Wall ratio | Wall t |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| X, seed 2 | 4,280,955,058 | 3,576,297,029 | 1.19704x | 1.17084x | 1.06729x | 39.75 | 1.06741x | 1.01 |
| Z, seed 14 | 4,268,847,189 | 3,742,874,647 | 1.14053x | 1.13069x | 1.01342x | 1.62 | 1.03901x | 1.46 |

Ratios are default/selected, so values above one favour the selected
presentation. Exact work and instructions improve in both directions. X has a
clear cycle reduction; its wall result remains unresolved because only three
long pairs were retained. Z's cycle and wall points remain unresolved after
five pairs. Branch misses increase by about 12.3% on X and 13.2% on Z, which
explains why state reduction does not translate proportionally into timing.
The accepted claim is therefore deterministic state/instruction reduction plus
an X cycle reduction, not a universal wall-time multiplier.

## Exactness argument

Let the supplied physical-check matrix have row space `R`. Replacing its rows
by any independent basis of `R` preserves exactly the kernel:

```text
H x = 0  <=>  r x = 0 for every r in R  <=>  H' x = 0.
```

The logical observation rows and coordinate action are unchanged. Therefore
the accepted supports, logical witnesses, exact distance verdict, and witness
replay are invariant. The chosen basis and its static order may nevertheless
change fail-first branching and greedy packing, so candidate count and
per-candidate cost may change.

Seeded compilation is deterministic. It permutes the original sparse checks
with a fixed SplitMix-derived ordering before extracting the independent basis,
then applies the same conflict ordering and compiler as the default path. The
seed changes presentation only; it grants no new pruning theorem or proof
authority.

## Implementation

Commit `29fbb4dbf` adds `compile_with_check_presentation_seed` to every wide
CSS backend and `--check-presentation-seed` to `css_distance_native`. The
selected seed is exposed by the compiled object, serialized in its artifact,
and checked during artifact load. Artifact readers accept exactly the current
and immediately preceding schema versions; malformed seed tags and trailing or
incompatible data fail closed. Shard ledgers include the presentation seed and
reject mixed-presentation coverage.

Commit `bb7e5d646` adds `--check-presentation-probes N` and optional
`--check-presentation-probe-weight`. It evaluates the unseeded presentation and
seeds `0..N-1`, chooses the deterministic minimum exact candidate count, and
retains only the current best plus the candidate being tested. The default
probe radius is `min(15, maximum_weight)`. Exact distance and searched-radius
results must agree across every candidate. Ties retain the earlier candidate,
with the default presentation first.

Autotuning is deliberately forbidden inside a shard invocation. The intended
protocol is compile/autotune once, persist the selected artifact, then load that
same source-bound artifact in every deterministic shard. Seconds-scale solves
omit the option.

## Autotune controls

The retained X run evaluates the default plus seeds 0--15 at radius 14 and
selects seed 2 with 97,959,978 candidates versus 109,046,916 default. Its full
preparation took 35.486 seconds on the then-loaded host. Artifact replay returns
the same seed, searched radius, null distance, and 97,959,978 candidates.

The retained Z run selects seed 14 with 101,025,270 candidates. Its full
preparation took 16.941 seconds on the quiet host. These preparation times are
not compared as a performance claim: compilation and sixteen probe searches
are paid once and amortized over a long solve or shard campaign.

A separate source-current RSS control measures 30,552 KiB for default X
compile-plus-radius-14 search and 55,696 KiB for the sixteen-probe autotuner.
The 25,144 KiB increment is one additional colossal compiled candidate plus
probe workspace; candidates are compiled one at a time, so residency is
bounded by the retained best and current challenger rather than all seventeen
presentations. The selected artifact itself is an ordinary single-presentation
cache and carries no autotuning bank.

The selected seeds differ by direction, rejecting a global hard-coded seed.
No LP1768-specific seed or problem identity appears in the compiler or CLI.

## Default-path no-regression gate

The retained control is commit `ce182fe0b`, immediately before the seeded
presentation implementation. Its all-feature release executable has SHA-256
`9795414370131a4c2e4cb8ced3046d8059371b02fde40a9cd5e6c08ed44b7a83`.
The current all-feature release executable, containing commits `29fbb4dbf` and
`bb7e5d646`, has SHA-256
`e94c8e6120f623161154a2f842f6b329437f56da949a4c286cbe301fbfb22f97`.

Both saved binaries run the default unseeded LP1768-X presentation at radius
14 with exactly 109,046,916 candidates per solve:

| Mode | Pairs | Old/current cycles | Cycle t | Old/current wall | Wall t | Old/current instructions |
|---|---:|---:|---:|---:|---:|---:|
| 1T | 9 | 1.00618x | 4.02 | 1.00791x | 3.70 | 0.999996x |
| 12T, five solves/sample | 7 | 1.01655x | 5.14 | 1.01223x | 1.85 | 1.000001x |

The implementation therefore does not tax the default search kernel. The 12T
wall point is favourable but unresolved; the cycle result and instruction
identity are the stronger gate. The optional seed changes cold compilation and
the resulting immutable table only. It adds no per-candidate branch, field, or
allocation.

## Measurement protocol

All measurements use the same imported official LP1768 JSON inputs:

- X SHA-256 `646733784118440b3b90391883e2ada204f938b9f762e647853ea234fd3819dc`;
- Z SHA-256 `bd08406a80cc0cbc38e65b10b37ee4644758631f2ced4a18a9a0baa795090d05`.

Target-depth runs use maximum weight 21, whose validated parity normalization
has effective maximum 20, shard 0 of 32, and 12 threads. Arms alternate by
round. `perf stat` records duration, task clock, cycles, instructions,
branches, branch misses, and cache misses; JSON result counters are streamed
to the TSV before temporary files are removed. The summary uses geometric
means of paired baseline/candidate ratios and a paired t score on log ratios.
The retained build host used rustc 1.93.1, the performance governor with boost
disabled, no explicit affinity or CPU isolation, and a quiet machine. Heavy
processes ran under CHOOM with at most twelve workers.

The generic retained harness is
`ergodis-private/benchmarks/css_presentation_ab.sh`; the independent summarizer
is `ergodis-private/benchmarks/summarize_paired_ab.py`. Both are commit-pinned in
`c197604f7`. Raw and summarized evidence is under
`ergodis-private/evidence/c985-lp1768-presentation-*`.

A representative replay after generating the two official inputs by the
LP1768 report's pinned importer is:

```sh
WORK_ROOT=/tmp/persistent/tavis/c985-lp1768-replay
env CARGO_TARGET_DIR=/tmp/persistent/tavis/c985-presentation-current-target \
  cargo build --release --all-features --bin css_distance_native \
  --manifest-path papers/complete-repair-ports/ergodis/Cargo.toml

CURRENT=/tmp/persistent/tavis/c985-presentation-current-target/release/css_distance_native
ergodis-private/benchmarks/css_presentation_ab.sh \
  "$CURRENT" "$WORK_ROOT/lp1768-x.json" 2 21 0 32 12 3 x-ab.tsv
ergodis-private/benchmarks/css_presentation_ab.sh \
  "$CURRENT" "$WORK_ROOT/lp1768-z.json" 14 21 0 32 12 5 z-ab.tsv
ergodis-private/benchmarks/summarize_paired_ab.py x-ab.tsv x-summary.tsv
ergodis-private/benchmarks/summarize_paired_ab.py z-ab.tsv z-summary.tsv
```

For the default-path control, build an independent detached worktree at
`ce182fe0b`, pass that executable as `BASE_BIN`, pass `none` as the seed, and
pass the current executable as the optional final `CANDIDATE_BIN`. Set
`CSS_PRESENTATION_AB_SOLVE_ROUNDS=5` for the retained 12T long control. The
harness uses create-only output and removes its exact temporary work directory
on success or interruption.

## Validation and trust boundary

The focused controls cover:

- exact default/seed result equivalence;
- seed persistence and artifact replay;
- rejection of malformed seed tags and incompatible artifacts;
- deterministic autotune selection and tie behavior;
- exact result agreement across every probed presentation;
- rejection of autotuning inside a shard invocation;
- shard-ledger rejection of mixed presentation seeds; and
- unchanged no-default-feature compilation of the CLI.

The source-current `cargo test --all-targets --all-features` gate passes. On
rustc 1.93.1, strict all-target/all-feature clippy passes after allowing only
five pre-existing `manual_is_multiple_of` lints in unrelated VM/feature/search
code; the lint does not exist in the Rust-1.87 admission environment. Four
independent summary regenerations are byte-identical to the retained summaries,
the SHA-256 manifest passes, and the retained autotune/artifact-load records
agree exactly on seed, searched radius, distance result, and candidate count.

The compiled artifact remains a cache, not a proof. Every final distance claim
still depends on the source-bound artifact checks, complete shard coverage,
exact search result, parity premise, and independent witness replay already
specified in the LP1768 report.

## Decision and next gate

Admit both manual seeded compilation and bounded shallow autotuning as optional
cold compiler features. Use the selected persisted presentation for the
LP1768 radius-22 campaign, but retain per-direction counters: fewer probe states
do not guarantee lower target-depth wall time. The next theorem-facing work is
a stronger pure syndrome lower bound; the next systems-facing reuse is to make
equivalent presentations the second typed proposer family after verified
automorphisms under the proposal/admission architecture.
