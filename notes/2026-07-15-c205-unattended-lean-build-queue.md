# C205 — unattended Lean build queue

**Lane**: `build-sys`
**Date:** 2026-07-15
**Status:** REPORTED — runner and tests landed; extended by C162 resource/quiet preflight

> **C162 extension (2026-07-15):** the committed statement below that the runner “does not measure
> or infer a safe N” has been deliberately superseded. The runner now enforces versioned measured
> profiles, RAM/tmpfs/mount preflight, serial-first heavy dependencies, literal `run-quiet` capture,
> and guarded `lake pack`. The first real lightweight build remains deferred.

## Objective

Generalize the successful `/tmp/c151-run-remaining.sh` pattern into a durable repository tool that
runs an explicit sequence of Lean targets without repeated agent polling. The runner belongs under
`lean/scripts/` and must remain an orchestration tool: it may not infer authority to kill, clean, or
rebuild work owned by another lane.

## Deliverables

- `lean/scripts/lean-build-queue.py` — `run`, `plan`, `pack`, and `status`;
- `lean/scripts/lean-build-profiles.json` — versioned measured resource profiles;
- `lean/scripts/test_lean_build_queue.py` — hermetic orchestration/preflight tests.

## What the seed got wrong

`/tmp/c151-run-remaining.sh` checked `ps` for a quiet tree and then launched. Nothing was held
between the check and the launch, so two runners could both observe a quiet tree and both start —
exactly the double-booked-RAM case the sizing rule cannot survive. The runner closes this between
participating runners by acquiring one build-owner lock **before** the quiet check and holding it
for the whole run.

The seed's other properties are preserved: sequential explicit targets, one log per target, `choom`
containment, GNU `time -v` telemetry, fail-fast, and a final `--no-build` replay.

## Design

**Ownership lock.** `flock(LOCK_EX|LOCK_NB)` on a per-Lean-root file, default
`~/.cache/othello-lean-build/locks/<slug>.lock`, held as an open file description for the process
lifetime. The kernel releases it on exit — including an OOM kill — so a dead run never wedges the
queue. The holder writes its `run_id`/`pid` into the file, so a refusal names the current owner.

The lock binds participating runners only. It is not a claim on foreign builds: the `pgrep -x
lake.orig` / `pgrep -x lean` quiet check remains a second line of defense, and it runs before every
target, not just at launch. Default is to **refuse** a busy tree; `--wait-quiet-seconds N` queues
behind it instead. The runner waits foreign builds out and never signals them.

**Liveness without PID trust.** `status` decides `running` vs `abandoned` from the lock, not from a
PID: if `status.json` says `running` but no live owner holds the lock with a matching `run_id`, the
run died without writing a terminal status (SIGKILL/OOM) and is reported `abandoned`. This is
filesystem-based, so it survives an agent sandbox whose PID namespace hides host processes — the
condition that makes `pgrep`/`kill -0` liveness checks unreliable here.

**States.** `running` / `success` / `failed` / `interrupted` / `abandoned` — an interrupt is
distinguishable from a build failure, and neither can be mistaken for success. Every state write is
a temp-file + `fsync` + `os.replace`, so a reader never sees a torn state.

**Resumption** needs no bookkeeping: `lake build --no-build <target>` before each target skips
whatever is already trace-current, so re-running the same queue after an interrupt is cheap and
safe. Content traces are the staleness authority, never mtimes or a bare olean.

## Operator use

Launch it in the background and walk away — do not poll Lake:

```
lean/scripts/lean-build-queue.py run \
  RelativeConicArcs.Q25ExactMinimumRows.C_0772 \
  RelativeConicArcs.Q25ExactMinimumRows.C_1002 \
  --aggregate RelativeConicArcs.Q25ExactMinimumRows.All \
  --cores 20-23 --threads 1
```

It prints its run dir immediately; read it back cheaply at any time with:

```
lean/scripts/lean-build-queue.py status ~/.cache/othello-lean-build/run-<id>
lean/scripts/lean-build-queue.py status ~/.cache/othello-lean-build/run-<id> --json
```

`--threads` is `LEAN_NUM_THREADS`, exported into the build shell and bounded by `--profile`.
`plan` validates the same profile without starting Lake. The runner silently accounts for RAM,
current tmpfs use, and mount type, and refuses an unsafe or unmeasured parallel setting. `--cores`
remains scheduling separation only. `--choom-adjust` defaults to `1000`; `500` remains an explicit
session-level priority decision.

Every real Lake build is invoked through `~/.claude/bin/run-quiet`, with its log root placed under
the disk-backed run directory. `--serial-first` handles a known-heavy shared dependency with one
thread before the profiled leaf phase. `pack` uses the ownership lock and refuses overwrite or a
RAM-backed destination.

Run state and logs default under `~/.cache/othello-lean-build/`; a run dir outside `$HOME` is
refused, since `/tmp` is tmpfs and its pages count against RAM.

## Validation

`uv run python lean/scripts/test_lean_build_queue.py` → **14 tests, OK** (2026-07-15).

Hermetic by construction: `nix`, `lake`, `taskset`, `choom`, GNU `time`, and `pgrep` are all stubs,
so the suite builds no Lean, reads no host process table, and cannot disturb another lane. The stubs
assert the argv shape they are handed. Signals go only to processes the test spawned itself, by PID.

| C205 gate                              | Test                                                       |
| -------------------------------------- | ---------------------------------------------------------- |
| 1. success + already-current skipping   | `test_success_skips_current_targets_and_gates`             |
| 2. failure + fail-fast diagnostic tail  | `test_failure_stops_the_queue_and_captures_a_tail`         |
| 3. refusal under a held lock            | `test_refuses_when_another_owner_holds_the_lock`           |
| 4. interruption + restart-safe resume   | `test_interrupted_run_is_distinguishable_and_resumable`    |
| 5. atomic state, no false success       | `test_status_reports_abandoned_when_no_owner_holds_the_lock`, `test_status_reports_running_while_the_owner_holds_the_lock` |
| 6. aggregate `--no-build` gate failure  | `test_aggregate_gate_fails_when_leaves_are_insufficient`   |

Beyond the six: `test_refuses_while_a_foreign_lean_build_is_live` (and that the refusal releases the
lock while recording terminal `refused` state), `test_run_state_is_refused_outside_home`,
`test_same_basename_targets_keep_distinct_logs`, and `test_invalid_numeric_controls_are_rejected`.

Gate 1 also asserts the plumbing the seed hard-coded: a skipped target is never handed to a real
build, `--cores`/`--choom-adjust` reach the tools, telemetry is parsed back out of the log, and the
manifest records the toolchain.

The tests and hostile review caught and fixed these defects:

- the telemetry parser split on the first `:`, which mangles GNU time's real
  `Elapsed (wall clock) time (h:mm:ss or m:ss): 0:01.23` — the label embeds colons. It now splits on
  `": "`. The stub reproduces the real label format, which is what caught it.
- the quiet check called `pgrep` resolved from `PATH` with no override, so the suite's result would
  have depended on host state and would have refused to run on a busy box. `--pgrep-binary` makes it
  injectable.
- a normal foreign-build refusal escaped with `status.json` still marked `running`; refusal now
  records terminal state and exit code before releasing the lock;
- log names used only the final module component, so common targets such as two different `All`
  modules overwrote each other's evidence; log names now use the full module name; and
- zero/negative polling and resource controls admitted tight polling or invalid tool invocations;
  typed argument validators now enforce the supported ranges.

## Limitations

- **No real build has yet been exercised against the real `nix`/`lake` toolchain.** A foreign heavyweight build was
  live for this session's whole window, and the no-concurrent-Lake rule forbids a real exercise
  alongside it, even a lightweight one. The stubs pin the argv shape the seed used and every
  orchestration path, but real integration — `nix develop` entry, Lake's actual `--no-build` exit
  codes, GNU time's real output — is unproven. **First live use should be one disposable
  lightweight target in a quiet window.**
- The lock binds participating runners only. A hand-run `lake build` still races it; the quiet check
  narrows that window but cannot close it.
- The quiet check inherits the PID-namespace caveat: this session saw `pgrep -x lake.orig` report
  nothing and, minutes later, report a live build. A quiet result is not proof of an idle tree.
- No spawn/daemon mode. The caller backgrounds it (`nohup … &` or a background shell); the runner
  itself runs in the foreground and holds the lock only while alive.

The global queue row and concise `CLAUDE.md` operator pointer are synchronized. Their edits were
applied without staging or modifying foreign lane work.
