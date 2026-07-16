# Lean workspace instructions

These instructions apply under `lean/`. `CLAUDE.md` is a symlink to this file, so Codex and Claude
receive identical guidance.

## Before acting

- For a nontrivial Lean proof, first load the named-expert umbrella and relevant dossier named by
  the parent guide. Discussion or document review alone does not trigger that context.
- Treat every other lane's sources, generated files, build tree, and running process as owned state.
  Never edit, build, stop, clean, or regenerate a foreign closure.
- Never run two heavyweight Lake builds in the shared tree. CPU affinity does not isolate memory or
  artifacts, and Lake's configuration lock does not serialize builds.

## Supported entry points

Do not hand-compose `taskset`/`LEAN_NUM_THREADS`/`choom`/Nix/Lake commands.

Single-file elaboration:

```sh
lean/scripts/guarded-lean RelativeConicArcs/Module.lean
```

It defaults to cores `20-23`, one thread, `choom=1000`, and automatically runs through
`~/.claude/bin/run-quiet`. See `guarded-lean --help` for exceptional overrides.

Unattended builds:

```sh
lean/scripts/lean-build-queue.py plan --profile q25-two-witness --threads 2
lean/scripts/lean-build-queue.py run Target.One Target.Two \
  --profile q25-two-witness --threads 2 \
  --serial-first Heavy.Shared.Checker \
  --aggregate Final.Aggregator --cores 20-21
lean/scripts/lean-build-queue.py status ~/.cache/othello-lean-build/run-<id>
```

The runner automatically:

- acquires the shared build-owner lock before checking quiet state;
- validates the measured resource profile and thread cap;
- reads RAM, mount, and tmpfs usage silently—never print `ps`, `df`, or memory tables into context;
- refuses memory-backed run state and unsafe RAM/tmpfs budgets;
- builds `--serial-first` dependencies with one thread;
- sends every real Lake build through `run-quiet`, with logs under disk-backed run state;
- probes each target with `lake build --no-build`, skips trace-current targets, and fails fast;
- records atomic status, per-target GNU-time telemetry, source/toolchain state, and a final trace-only
  aggregate gate.

Resource measurements live in `lean/scripts/lean-build-profiles.json`. Unknown work uses the
strictly serial `single` profile. Add or raise a profile only from a representative GNU `time -v`
measurement and the reserve formula; never derive a cap from `nproc` or another target family.
`choom=1000` remains the default. Use `500` only when the user explicitly prioritizes this build and
has coordinated other jobs to remain sacrificial.

Artifact backup:

```sh
lean/scripts/lean-build-queue.py pack ~/lean-backups/<name>.tgz
```

`pack` takes the same ownership lock, refuses active foreign Lean work, refuses overwrite and
memory-backed destinations, and runs `lake pack` through `run-quiet`.

## Staleness, restart, and recovery

- Content traces and exact-target `lake build --no-build` are authoritative. Mtimes and existing
  oleans are not.
- Never use `--old` for a validation gate. A single-file elaboration against a last-built foreign
  dependency is only a smoke test and must be labeled as such.
- Before restarting a large build, stop only its verified owning process, choose sentinels explicitly
  printed as `Built`, and use:

```sh
lean/scripts/lean-restart-guard.py checkpoint /home/<checkpoint> <sentinels...>
lean/scripts/lean-restart-guard.py audit-log /home/<checkpoint> <restart-log>
lean/scripts/lean-restart-guard.py verify /home/<checkpoint>
```

- The restart guard hashes `.olean`, `.olean.hash`, `.ilean.hash`, and `.trace`; it is not a backup.
  Pair uncertain work with the guarded `pack` command.
- Never use `/tmp` for build trees, caches, checkpoints, packs, or large logs. `/tmp` is tmpfs on
  this host and counts against RAM.

## Proof-engineering invariants

- Finite-certificate sharding must cross module boundaries. Splitting cases or tactics inside one
  module does not bound elaborator memory. Use a definitions-only base, bounded leaf modules, and a
  light aggregator; land leaves before probing the aggregator.
- If `decide`/`norm_num` is blocked by an opaque finite operation, introduce one reducible table
  evaluator and prove a symbolic bridge instead of unfolding the operation in every case.
- Freeze narrow generated checker/schema cores for a certificate generation. Put transport,
  convenience, and paper-facing theorems downstream so prose/API growth does not invalidate leaves.
- In a focused target, a dependency finishes before its consumer; wide builds can still co-schedule
  unrelated siblings. Use the profile's serial-first boundary rather than assuming all workers have
  the same peak.

## Failure and ownership discipline

- Do not poll a healthy build. Read the runner's atomic `status` only when needed; it distinguishes
  running, success, failure, interruption, and abandoned/OOM state without trusting PIDs.
- Never run broad `ps`, `pgrep`, or `df` commands manually. The wrappers perform silent narrow
  checks. If sandbox PID visibility leaves foreign ownership uncertain, stop and ask the owner/user;
  do not infer permission from an empty process result.
- Low available memory without a recorded failure is pressure, not authorization to intervene.
  Repeated exit 137 from your own queue means the profile is wrong: stop only the owned queue, lower
  the cap, and restart from trace-current targets. Never kill an individual worker.
- Never `lake clean` while any lane may use the shared tree. Never opportunistically rebuild a
  foreign dirty or stale dependency.
