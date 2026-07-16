# C225 supervisor survey

**Date:** 2026-07-16
**Lane:** `build-sys`
**Task:** C225

## Design provenance

- User: `tavis`
- Harness: `codex`
- Session ID: `019f6c8b-d2a1-7f60-965a-0b68b1237d7e`
- Work lane: `build-sys`

## Question

Can an existing local supervisor supply durable process ownership and event-driven completion so
`lean-build-queue.py` does not grow its own launcher/worker protocol?

## Host findings

- systemd 258.7 is installed.
- The user manager is active and user lingering is enabled, so user services survive logout.
- `systemd-run --user --wait --service-type=exec` propagated a successful child's exit as 0 and a
  failing child's exit 7 as 7.
- Killing only the waiting `systemd-run` client left its transient service active; the service
  completed independently and then unloaded after success.
- A failed transient service launched without `--collect` remained inspectable with
  `ActiveState=failed`, `Result=exit-code`, `ExecMainCode=1`, and `ExecMainStatus=9` until an explicit
  `reset-failed`.
- `systemd-notify` and `busctl` are installed. Task Spooler (`tsp`/`ts`) and `nq` are not installed.
- The manager API does not expose a user-manager `InvocationID`. Its D-Bus unique owner can be
  resolved to a Unix PID, so boot ID plus a race-checked owner/PID/process-start tuple can identify
  the manager incarnation. Individual service units do expose `InvocationID`.
- `KillMode=mixed` sends TERM only to the main process, then sends the final kill signal to remaining
  cgroup processes after the main process exits or `TimeoutStopSec` expires. This better matches a
  Python supervisor that must forward, reap, unlock, and publish before it exits.
- The checked-in non-Lean capability fixture now confirms the exact C225 surface with
  `KillMode=mixed`, `SendSIGKILL=yes`, and `TimeoutStopSec=120s`: exit 0 and exit 7 propagate as 0
  and 7; SIGKILL returns 255 from `systemd-run` while retained properties report `Result=signal`,
  `ExecMainCode=2`, and `ExecMainStatus=9`; killing the waiter leaves its service active until
  independent completion.
- A `Type=exec` missing executable returns client code 1 with a bounded diagnostic and is immediately
  unloaded on this host. Recovery cannot infer that failure from a later missing-unit observation;
  the live adapter must capture it. Successful services likewise garbage-collect normally.
- NixOS coreutils applets are multicall symlinks. The adapter must pass an absolute executable path
  without resolving away the symlink spelling, because doing so changes `argv[0]` and applet
  dispatch (observed with `sleep`).

These were harmless non-Lean probes using `true`, `sleep 2`, and explicit shell exit codes. Probe
units were allowed to unload or were reset after inspection.

The reproducible fixture is `lean/scripts/lean-build-systemd-probe.py`. It emits one bounded JSON
object, uses only UUID-scoped `othello-lean-c225-probe-*` units, and stops/resets only each exact
fixture unit in `finally`.

## Tool comparison

### systemd user transient services

The installed `systemd-run` contract supplies manager-owned service processes, cgroups, synchronous
`--wait`, propagated child exit status, `Type=exec`, working-directory/environment controls, and
resource properties. The manager D-Bus exposes `PropertiesChanged`, unit lifecycle signals,
`Result`, and `ExecMainStatus`. This directly covers the lifecycle layer C225 otherwise would have
to implement.

Primary references:

- [systemd-run manual](https://www.freedesktop.org/software/systemd/man/latest/systemd-run.html)
- [systemd service properties](https://www.freedesktop.org/software/systemd/man/latest/systemd.service.html)
- [systemd process-killing behavior](https://www.freedesktop.org/software/systemd/man/latest/systemd.kill.html)
- [systemd manager D-Bus API](https://www.freedesktop.org/software/systemd/man/latest/org.freedesktop.systemd1.html)

### Task Spooler

Task Spooler has an attractive small-batch interface: `tsp -w ID` waits for a named job,
`TS_ONFINISH` invokes a program on job completion, and the server retains output and exit status.
It is terminal-independent and simpler than a general batch scheduler.

It is not installed on this host, would introduce another per-user daemon/socket and saved-list
contract, and provides less process/cgroup/resource isolation than the already-active systemd user
manager. It remains the leading portability alternative if the project later targets hosts without
systemd.

Primary references:

- [Task Spooler upstream](https://github.com/justanhduc/task-spooler)
- [Task Spooler manual](https://manpages.debian.org/testing/task-spooler/tsp.1.en.html)

### Other mechanisms

`tmux`, `setsid`, and `nohup` preserve a process but do not provide a complete outcome/reattachment
contract. Slurm would provide that contract but is uninstalled and disproportionate for one build
host. A custom Python supervisor is possible but duplicates systemd's process ownership, exit
accounting, event stream, and abnormal-death handling.

## Disposition

Use a systemd user transient service as the proposed lifecycle owner. Keep
`lean-build-queue.py run` foreground and single-writer for Lean-specific lock/phase/result status.
Retain Task Spooler as a documented alternative, not a new dependency. Do not treat any supervisor
as a direct model-notification API: the harness must keep one event-driven waiter alive and perform
its own callback when the supervised job terminates.

Origin scope is resolved before submission from matching CLI options or `OTHELLO_HARNESS`,
`OTHELLO_SESSION_ID`, `OTHELLO_LANE`, and `OTHELLO_TASK_ID`, with CLI taking precedence. Codex may
derive its session field from `CODEX_THREAD_ID`. Environment values must be present in the parent
agent process to serve as session defaults; an `export` in a child tool shell is not persistent.
