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

If several elaborations need the same exceptional overrides, set them once for the current agent
session instead of repeating environment assignments on every call:

```sh
lean/scripts/guarded-lean --session-set \
  LEAN_GUARD_CPUSET=20-21 LEAN_GUARD_THREADS=2 LEAN_GUARD_PROFILE=q25-two-witness
lean/scripts/guarded-lean RelativeConicArcs/First.lean
lean/scripts/guarded-lean RelativeConicArcs/Second.lean
lean/scripts/guarded-lean --session-clear
```

The wrapper keys the disk-backed settings by `CODEX_THREAD_ID`/the available Claude session ID, so
concurrent agent sessions do not share overrides. An explicit environment variable on one invocation
wins over the saved value. Do not create a shared cross-session environment file.

Unattended builds:

```sh
lean/scripts/lean-build-queue.py plan --profile q25-two-witness --threads 2
lean/scripts/lean-build-queue.py run Target.One Target.Two \
  --profile q25-two-witness --threads 2 \
  --serial-first Heavy.Shared.Checker \
  --aggregate Final.Aggregator --cores 20-21
lean/scripts/lean-build-queue.py status ~/.cache/othello-lean-build/run-<id>
```

For a long gate, add `--detach`. The command returns the generated run directory immediately; the
detached queue process remains the watcher, and its atomic `status.json` records success, failure,
interruption, or abandonment without agent polling:

```sh
lean/scripts/lean-build-queue.py run Target.One Target.Two \
  --profile single --threads 1 --cores 20-23 --detach
```

C225 also provides an adjacent, explicitly selected systemd-managed path. It does not replace or
redirect the legacy command above during the parallel rollout. Supply the current harness session,
lane, and caller-attested C-task either with the documented `OTHELLO_*` parent-session environment
or explicit options. The command blocks in one event-driven wait and prints exactly one bounded
completion envelope:

```sh
lean/scripts/lean-build-systemd.py run Target.One Target.Two \
  --profile single --threads 1 --cores 20-23 \
  --harness codex --session-id "$CODEX_THREAD_ID" --lane build-sys --task-id C225
```

If the primary waiting client is lost, reattach to its immutable run directory without stopping or
resubmitting the service:

```sh
lean/scripts/lean-build-systemd.py await \
  ~/.cache/othello-lean-build-systemd/run-<uuid> --timeout 3600
```

Exit 124 is a non-mutating caller timeout, 125 means state or supervisor evidence is insufficient,
and 126 is externally observed abandonment. Consumers deduplicate recovery delivery by the stable
`event_id`. The managed path uses the same build-owner lock and measured worker controls as the
legacy path, but keeps separate managed run directories. Do not run a real Lean target through it
until the build-sys quiet-window gate is confirmed.

Interpret managed status narrowly: `queued/waiting-for-lock` means the worker exists but does not
own the tree; `running/quiet-preflight` means it owns the lock; `running/building` or
`running/aggregate-gate` means the named child was spawned; only a terminal completion envelope
after service exit establishes released resources and the recorded outcome.

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
- Do not stream or re-request a large Lean failure. `guarded-lean` already logs through `run-quiet`;
  inspect only the first error and a small neighborhood. More than 10,000 reported original tokens
  means the diagnostic shape failed and must be narrowed before another elaboration.
- Never run broad `ps`, `pgrep`, or `df` commands manually. The wrappers perform silent narrow
  checks. If sandbox PID visibility leaves foreign ownership uncertain, stop and ask the owner/user;
  do not infer permission from an empty process result.
- Low available memory without a recorded failure is pressure, not authorization to intervene.
  Repeated exit 137 from your own queue means the profile is wrong: stop only the owned queue, lower
  the cap, and restart from trace-current targets. Never kill an individual worker.
- Never `lake clean` while any lane may use the shared tree. Never opportunistically rebuild a
  foreign dirty or stale dependency.
