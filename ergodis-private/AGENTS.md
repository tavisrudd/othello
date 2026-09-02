Read all of `../AGENTS.md` in a dedicated command before doing anything.

This package is the mandatory home for Ergodis work that is domain-specific,
task-specific, experimental, private, or not yet demonstrably reusable. It may
depend on the public core under `papers/complete-repair-ports/ergodis`; the
public core must never depend on this package or expose its adapters, fixtures,
campaign names, or research process.

Do not export, publish, synchronize, package, or add this directory to a public
release manifest. This `AGENTS.md` is itself private and must not be exported or
copied into any public tree.

Before extracting or editing a reusable public-core component, stop and read
the public core's `AGENTS.md` and private `PERFORMANCE.md` completely. Promote
only the domain-neutral kernel, contract, tests, and documentation; keep the
research adapter and private fixtures here.

## Crate tiers and the no-new-binary rule

The workspace rooted at this directory has three tiers.

- **Tier 0** is the public core under `papers/complete-repair-ports/ergodis`. It
  holds general algorithms only and never depends on anything here.
- **Tier 1** is the `ergodis-private` root package: a **library only**, with no
  `[[bin]]` target and no `src/bin` file. It holds reusable private machinery —
  Hall core, proof synthesis, evolve adapters, feature DAG, quotient and PAF
  proofs, campaign RPC and controller adapters, and the lifted arithmetic,
  GF(2), CSS, and PRS helpers. No task ID appears in a module or feature name.
  Anything copied into a second task module moves here in the same commit.
- **Tier 2** is `tasks/*`: one crate per lane, each with exactly one binary and
  one subcommand per task. Task IDs appear only as module names and subcommand
  documentation. `tasks/gem-hunt` owns the gem-mining searches; `tasks/tools`
  owns the lane-neutral operator tools.

**No new `src/bin` file anywhere in the workspace.** A new task adds a
subcommand to its lane's tier-2 binary; flags shared by several subcommands
belong in one common `clap` struct in tier 1 rather than being copied. Each subcommand module exposes a `clap::Args` struct
and a `pub fn run(args) -> anyhow::Result<()>`; the tier-2 `main.rs` contains
nothing but the command tree and its dispatch.

## Build artifacts

This workspace builds into one shared out-of-tree target directory,
`~/.cache/ergodis/target/ergodis-private`, declared by `.cargo/config.toml` and
inherited by every member; never create a per-experiment target directory.
A/B baselines are retained executables from
`../papers/complete-repair-ports/ergodis/scripts/retain-bin.sh`, not preserved
build trees. Hash proof blobs into their evidence file, then compress or delete
them, and run `cache-gc.sh` at task close.

Private solve adapters follow the same zero-allocation, iterative-search,
Tiger-style hot-record, contention-free parallelism, and single-/parallel A/B
counter discipline as the public core. Read the core `PERFORMANCE.md` in full
before changing or benchmarking any private solve hot path.
