# C225: Lean queue completion notification

**Lane**: `build-sys`
**Date**: 2026-07-16
**Status**: QUEUED — ADR revised after adversarial review and supervisor survey

## Goal

Make a queued Lean run observable from submission through success, failure, refusal, interruption,
or abnormal death, and return one bounded completion event to an agent harness without spending
model turns on `sleep`/`status` polling.

## Scope and ownership

Owned implementation paths:

- `lean/scripts/lean-build-queue.py` and its focused tests
- a narrow systemd submission/inspection adapter under `lean/scripts/`, if the implementation gate
  confirms that a wrapper is preferable to a documented command
- narrow operator guidance in `lean/AGENTS.md`
- this handoff, the C225 supervisor survey, and the C225 queue row

Do not change Lake package boundaries, shared-tree ownership rules, resource profiles, target
semantics, or another lane's running queue. Real Lean validation remains subject to the build-sys
quiet-window gate.

## Problem statement

`lean-build-queue.py run --detach` currently spawns a second Python process and returns before that
worker has acquired the build-owner lock. The worker creates `status.json` only after lock
acquisition. A worker waiting for the lock, failing during initialization, or dying before status
creation therefore has no durable queue record. Repeated `sleep 30; ... status RUN_DIR` calls spend
model turns without distinguishing queued, dead, or slow.

A successful detached launch proves only that `Popen` returned a PID. It does not prove that the
worker adopted the run, owns the build tree, or started Lake. Repairing this entirely inside the
Python script would require recreating supervisor features: a launcher/worker readiness protocol,
single-writer transfer, PID-reuse-safe liveness, abnormal-death accounting, reattachment, and
completion signaling.

## Available-tool survey

| Candidate | Useful existing contract | Fit |
|---|---|---|
| systemd user transient service | manager-owned process/cgroup, `--wait` with propagated exit status, D-Bus lifecycle signals, `Result`/`ExecMainStatus`, journal, CPU/memory/OOM properties | Best fit; systemd 258.7, active user manager, and lingering are present on this host |
| Task Spooler (`tsp`) | per-user queue, durable job ID in the server, `tsp -w ID`, saved output, `TS_ONFINISH` | Plausible fallback, but not installed; weaker resource/process isolation and adds another daemon/socket state model |
| Slurm or another batch scheduler | mature queue, dependencies, accounting, wait APIs | Excessive for one workstation and not installed |
| tmux/setsid/nohup | survives terminal loss | No authoritative exit/status/reattach notification contract |
| custom Python supervisor | can preserve the current CLI | Duplicates lifecycle machinery already supplied by the user service manager |

The implementation gate must confirm the exact installed systemd behavior and checked-in command
surface. It must not silently fall back to a home-grown detached worker when the user manager is
unavailable.

Current host capability and supervisor comparisons are recorded outside this live handoff in
[`../../2026-07-16-c225-supervisor-survey.md`](../../2026-07-16-c225-supervisor-survey.md).

## ADR: systemd owns lifecycle; the queue owns Lean semantics

**Status:** Proposed, revised after adversarial review

### Context

There are three separate authorities:

1. systemd knows whether the OS process/cgroup was created, is alive, and how it exited;
2. `lean-build-queue.py` knows whether the run is waiting for the build lock, checking quiet state,
   building a target, or running the aggregate gate;
3. the harness owns its private completion callback and conversation lifecycle.

No one layer should impersonate another. In particular, a repository process cannot directly wake
an arbitrary model turn, and an active systemd service does not imply that Lake has started.

### Decision

#### 1. Replace Python `--detach` with a systemd user transient service

The adapter first creates a restrictive, non-reused run directory and atomically writes immutable
`submission.json` with format, run ID, UUID-derived unit name, absolute Lean root/run directory,
bounded argv/digest, submission time, and origin attribution:

```text
user=tavis, harness=codex|claude|manual, session_id=<native harness session>,
work_lane=<explicit lane alias>, task_id=<allocated C###>
```

The Codex adapter records `CODEX_THREAD_ID`; the Claude adapter must pass Claude's native session ID
explicitly rather than relying on prompt or PID inference. `work_lane` is the selected ownership
lane, not a value inferred from Git. Codex/Claude submissions require an allocated task matching
`C[0-9]+`. Manual non-task probes use `task_id=null`, are visibly marked `manual`, and may not be
presented as lane work. Manual submission requires an explicit stable session token.

The record also captures a user-manager generation tuple: host boot ID, D-Bus unique owner of
`org.freedesktop.systemd1`, that owner's Unix PID, and `/proc/<pid>/stat` start ticks. The adapter
reads owner→PID→start ticks→owner and accepts the tuple only if both owner reads match. This
distinguishes a user-manager restart within one host boot; the manager API does not expose a manager
`InvocationID` analogous to a service unit's `InvocationID`.

The adapter then runs
`lean-build-queue.py run` as a foreground, single-writer worker inside that uniquely named transient
user service. The primary harness path uses the equivalent of:

```text
systemd-run --user --wait --quiet --service-type=exec --expand-environment=no \
  --unit=othello-lean-<run-id> \
  --description='Othello Lean [<lane>/<C###>] <harness>:<short-session>' \
  --working-directory=<lean-root> \
  --setenv=OTHELLO_LEAN_RUN_ID=<run-id> \
  --setenv=OTHELLO_LEAN_SUBMISSION_SHA256=<submission-digest> \
  --property=KillMode=mixed \
  --property=SendSIGKILL=yes \
  --property=TimeoutStopSec=120s \
  <absolute-python> <absolute-lean-build-queue.py> run ... --run-dir <absolute-run-dir>
```

`Type=exec` makes failed `execve` distinguishable from a successfully started worker. `--wait`
blocks in systemd's event loop until the service deactivates and propagates the service exit status.
The manager, not the harness terminal, remains the worker's parent and cgroup owner. If the harness
or its `systemd-run` client disappears, the service continues while the same user manager remains
alive. `Type=exec` does not prove Python initialization or status creation.

The UUID suffix is independent of filesystem paths and is never reused. Before spawning the blocking
`systemd-run --wait` client, the adapter connects and subscribes to the user manager. While that
client remains blocked, the adapter observes the exact unit, takes a D-Bus reference, and reads a
confirmed snapshot. It writes `accepted.json` only when all of these match the immutable submission:

- the user-manager generation tuple is unchanged;
- unit `Id` is the reserved UUID-derived service name and `Transient=yes`;
- service `InvocationID` is nonzero;
- `WorkingDirectory` and the complete absolute `ExecStart` argv match;
- the run-ID and submission-digest environment nonces match.

This records the unit `InvocationID` during the wait, before successful-unit garbage collection can
erase it. The authoritative identity is `(manager generation, run_id, unit, InvocationID)`. A loaded
name collision is an error. If the client or adapter loses the acceptance result, recovery queries
the reserved name and adopts it only after the same property checks; it never blindly resubmits.
The human-readable unit description is display-only and is never identity or authorization
evidence.

Acceptance metadata is written separately to `accepted.json`; `submission.json` is never rewritten.
The adapter is the sole writer of `submission.json`, `accepted.json`, and `completion.json`; the
queue worker is the sole writer of `status.json`.

Do not use `--collect` initially. Failed/abnormally terminated units should remain inspectable until
the result has been captured; successful units may unload normally after the queue has atomically
recorded success. Cleanup/reset of failed transient units happens only after outcome capture.

The first implementation must retain the queue's measured `taskset`, thread, `choom`, and quiet-log
behavior. Moving those controls to systemd properties is a separate measured decision.
`KillMode=mixed`, `SendSIGKILL=yes`, and `TimeoutStopSec=120s` are part of the proposed C225 contract.
On stop, only Python receives TERM initially, so it can forward to and reap its child, release the
lock, and publish interruption status. After Python exits, or after 120 seconds, systemd sends KILL
to remaining cgroup processes. The shutdown fixture must validate this ordering before the ADR is
accepted; changing the timeout requires an explicit design amendment rather than inheriting a host
default.

#### 2. Keep one Python status writer and create status before lock acquisition

The foreground queue worker creates format-2 `status.json` immediately after validating and creating
its disk-backed run directory, before attempting the build-owner lock. There is no launcher/worker
ownership transfer: Python is the sole status writer for its entire lifetime.

Canonical nonterminal states are `queued` and `running`; canonical terminal states are `success`,
`failed`, `refused`, and `interrupted`. `phase` is one of `initializing`, `waiting-for-lock`,
`quiet-preflight`, `building`, `aggregate-gate`, or `finished`.

`running` means the queue owns the build lock. `phase=building` or `aggregate-gate` means the
corresponding child command was successfully spawned, not that compilation has made progress.
Outcome calculation is separated from publication: reap the child, retain the outcome locally,
release and close the build-owner lock, atomically commit terminal status, then return. Death before
lock release or between release and terminal publication leaves nonterminal canonical state plus a
failed/abnormal systemd result. The systemd service exit is the final evidence that the process
group and its resources are gone.

Format 2 is a superset of format 1: retain targets, results, current/failed target, timestamps,
telemetry, and bounded diagnostic paths. Replace the misleading transition-only `heartbeat_utc`
meaning with `updated_utc`; systemd supplies liveness, so no competing heartbeat writer is needed.

#### 3. Treat abnormal death as external evidence, not a forged canonical state

SIGKILL, OOM, interpreter crash, or an unwritable status path may leave canonical status nonterminal
or absent. Readers never rewrite that record. They report an `effective_state` derived from
systemd's `ActiveState`, `SubState`, `Result`, `ExecMainCode`, and `ExecMainStatus` for the exact
bound invocation.

`effective_state=abandoned` is reader-derived and must include its evidence. It is never claimed as
a worker-written terminal state and has no fabricated queue exit code or finish time. If unit
identity or manager access is unavailable, the effective state is `unknown`, not dead.

If `execve` succeeds but Python exits before status creation, the canonical state is null and the
bound service evidence yields `effective_state=failed-before-status`; `queue_exit_code` is null.
Service exit 2 is not called a queue refusal unless a matching canonical `refused` record exists.
Worker/cgroup OOM is external evidence; child-only OOM is an ordinary child failure observed by
Python.

This removes custom PID/start-tick/pidfd logic from the normal path. Absence of a unit is not proof
of abandonment: user-manager restart, reboot, runtime-directory loss, administrative cleanup, and
successful unit garbage collection can remove that evidence. A nonterminal disk record plus missing
or inaccessible manager evidence is `unknown` unless separate positive evidence establishes more.

#### 4. Use one blocking completion bridge, not agent polling

The primary bridge retains the single `systemd-run --wait` command inside one unified-exec
orchestration cell. A successful transient unit normally garbage-collects as it becomes inactive,
so the adapter treats the captured `systemd-run` exit plus matching terminal status as success
evidence; post-exit service properties are nullable. It never parses human `systemd-run` prose or
assumes a later `systemctl show` will find a successful unit.

The adapter first atomically persists one bounded `completion.json` envelope, then invokes the
harness-local callback once for that adapter invocation. Failed units are reset only by exact unit
name after durable capture. Cleanup failure is diagnostic and cannot change the captured outcome.
A recovery sweep may reset only C225-prefixed failed units with matching immutable submission
records older than a stated retention threshold; broad `reset-failed` is forbidden.

Delivery semantics are not globally exactly-once. The callback event ID is stable, for example
`lean-queue:<run-id>:terminal:<revision>`. A live adapter emits at most once; recovery after a
harness crash is at-least-once and consumers deduplicate by event ID. Callback failure never changes
queue state.

An arbitrary detached shell process cannot call the private harness `notify(...)` API. systemd
solves process supervision and wakeable waiting; the live orchestration cell performs the final
harness injection. If that cell is lost, the systemd result plus disk status are the recovery path.

#### 5. Define a bounded inspection envelope

Whether implemented as a new `inspect`/`await` subcommand or a small adjacent adapter, machine output
is exactly one bounded JSON object on stdout; diagnostics go to stderr. It contains:

```text
format, run_id, unit, origin, canonical_state, effective_state, phase,
queue_exit_code, service_result, service_exit_code, event_id, reason
```

`origin` contains the full `user`, `harness`, `session_id`, `work_lane`, and `task_id` copied from
the validated immutable submission. Human `status` output prints `lane/C### harness:short-session`
near the run ID. A bounded queue-list command shows active and recent rows with:

```text
run_id  effective_state  phase  lane  task  harness  session  unit
```

Full machine JSON retains the complete session ID; the human table abbreviates it unambiguously and
offers an exact-run JSON query. Listing scans only the managed state root, caps rows, rejects unsafe
entries, and never uses a broad process-table query. Successful-run retention for the recent view
comes from disk completion records, not systemd unit retention.

Normal codes remain 0 success, 1 build/internal failure, 2 refusal, and 130 interruption. Adapter
codes reserve 124 for caller timeout, 125 for invalid/unreadable state, and 126 for externally
observed abandonment. Timeout uses monotonic time, performs a final state read, and never signals,
kills, resets, or mutates the unit or queue.

The preferred launch path needs no repository-level polling: `systemd-run --wait` already waits on
manager events. Reattachment is not claimed until a D-Bus adapter implements this order: connect;
`Subscribe`; `RefUnit` for the exact name if present; read a confirmed property/InvocationID
snapshot; process `PropertiesChanged`/`UnitRemoved`; reread after every wake; durably capture; then
unref/unsubscribe. `UnitRemoved` alone proves no outcome. A unit already garbage-collected before
attachment can be resolved by matching terminal disk status; missing unit plus nonterminal status
is `unknown`. Timeout unrefs/unsubscribes without stopping or resetting the service.

Low-frequency file polling is permitted only as an explicit portability fallback inside one waiter
process, never as repeated model/tool calls.

#### 6. Make the capability and security boundaries explicit

Submission preflights usable user-manager D-Bus and confirms lingering on the supported host. It
does not require `systemctl --user is-system-running` to say `running`, and it never enables linger
itself. Failure gives foreground guidance rather than silently selecting Python detach.

The adapter creates restrictive directories/files, rejects symlinks and non-regular/oversized JSON,
validates run ID/unit/InvocationID across submission, acceptance, status, and completion records,
and never executes a path read from status. It passes an argv vector rather than an interpolated
shell command.
Journald is diagnostic-only: correctness does not depend on journal persistence, permissions,
retention, parsing, or availability, and unbounded journal content never reaches the harness.

#### 7. Preserve format-1 recovery without overstating it

- Completed format-1 records return their recorded outcome and code.
- A running format-1 record with its matching legacy owner lock is reported live.
- A running format-1 record with a positively unheld lock is reported effectively abandoned.
- A legacy detached directory containing only `detached.json` is `legacy-not-ready`/unknown, never
  success or proof of a live build.
- Inaccessible or malformed lock/unit evidence is unknown, not unheld.
- Format-1 recovery has no systemd binding and remains on the legacy lock-only path.

### Consequences

- We delete or deprecate the unreliable Python detach path instead of hardening it into a supervisor.
- systemd supplies process-group ownership, exit accounting, event-driven waiting, and abnormal-exit
  evidence; Python remains focused on Lean locking, phases, logs, and target outcomes.
- The harness spends no model turns on periodic status checks.
- A host without a working user manager receives a clear refusal and a documented foreground option;
  selecting another supervisor is a separate portability decision.
- Task Spooler remains the leading alternative if portability beyond systemd becomes a requirement.

### Rejected alternatives

- **Repair Python `Popen(..., start_new_session=True)` into a supervisor:** recreates readiness,
  liveness, abnormal-exit, and reattachment protocols with more race surface.
- **Adopt Task Spooler now:** it has a good `-w`/on-finish interface, but adds an uninstalled daemon
  and does less for cgroup/resource ownership than the already-running systemd user manager.
- **Keep `sleep; status` polling:** spends model turns and still cannot establish pre-lock lifecycle.
- **Treat `detached.json` as status:** it proves only that process creation returned a PID.
- **Have the queue call Codex directly:** couples repository infrastructure to a private live turn
  and cannot guarantee delivery across harness loss.
- **Promise global exactly-once notification:** impossible without a durable outbox plus consumer
  acknowledgement; stable IDs and deduplication give honest at-least-once recovery.
- **Use desktop notifications or Codex hooks:** those notify a human about Codex lifecycle, not the
  model about arbitrary subprocess completion.

## Evidence and progress claims

| Evidence | Allowed claim |
|---|---|
| transient unit submission accepted | systemd accepted the unit |
| service `active` plus `queued/waiting-for-lock` | queue worker is alive but does not own the tree |
| canonical `running/quiet-preflight` | queue owns the lock; no Lake-start claim |
| canonical `running/building` | target child was spawned; no compile-progress claim |
| canonical `running/aggregate-gate` | aggregate probe was spawned |
| terminal queue status alone | queue recorded an outcome; service exit may still be pending |
| `systemd-run --wait` returned and envelope validated | job exited, resources were released, and bounded outcome is ready |

## Acceptance gates

1. A harmless transient-service fixture proves installed `--user --wait --service-type=exec`
   behavior and exact exit propagation for 0, nonzero, signal, failed exec, and waiter-client loss.
   Every fixture cleans its exact unit in `finally`.
2. Before submission, a restrictive immutable record binds run ID, UUID unit, absolute paths/argv,
   user/harness/session/lane/C-task origin, and the manager-generation tuple; the blocking adapter
   records a fully matched InvocationID before successful-unit GC without a resubmit race.
3. Status exists in `queued/waiting-for-lock` before a held owner lock is released; no Lake command
   is invoked during that phase.
4. Lock timeout records `refused`/2; build and aggregate failures record `failed`/1; SIGTERM records
   the signal and the documented interrupted code.
5. With `KillMode=mixed` and `TimeoutStopSec=120s`, stop with a live child proves TERM reaches Python
   first, Python forwards/reaps, releases the lock, and records interruption before exit; escalation
   leaves no cgroup descendant. Forced worker/cgroup death and failure before status creation yield
   bounded external effective states without mutating canonical disk state.
6. Notification occurs only after service exit/lock release, uses a stable event ID, and is at most
   once per live adapter invocation. Two adapters may emit the same ID and are deduplicable.
7. A harness fixture owns one blocking wait and consumes one bounded completion envelope; it uses no
   `sleep`, repeated `status`, process-table polling, or live-log capture. Private harness delivery
   beyond that adapter contract is not claimed as a repository test.
8. Inspection handles already-complete, malformed, oversized, missing, format-1, and manager-
   unavailable cases without following untrusted paths or blocking on non-regular files.
9. Successful-unit GC, exact failed-unit capture/reset, cleanup failure, InvocationID mismatch,
   missing-manager evidence, and the D-Bus subscribe/read boundary all have focused fixtures.
10. JSON creation/replacement is visibility-atomic and directory-fsynced where process-crash
   durability is claimed; run directories/files use restrictive permissions.
11. Per-run status and the capped queue list expose full machine-readable and abbreviated human
    session/lane/C-task attribution, including concurrent jobs from Codex and Claude fixtures.
12. Operator guidance distinguishes submitted, queued, lock-owned, child-spawned, and completed.
13. After the non-Lean fixtures pass, one disposable lightweight target exercises the real
    systemd-run→queued/running→terminal bridge in a confirmed quiet window.

## Implementation order

1. Build a tiny non-Lean systemd probe covering exit propagation, signal, failed exec, unit naming,
   result inspection, and cleanup; record the exact supported command/property set.
2. Implement restrictive origin/manager/submission identity and the absolute-argv transient-service
   adapter, including the concurrent InvocationID handshake.
3. Refactor the Python worker to create format-2 status before lock acquisition and publish phases
   as the sole writer; move terminal publication after lock release.
4. Add bounded completion capture, exact failed-unit cleanup, and the primary `--wait` bridge.
5. Implement D-Bus reattachment only after its subscribe/ref/snapshot algorithm passes race tests.
6. Remove polling examples and deprecate Python `--detach` with an actionable foreground/systemd
   message; do not leave two competing detach contracts.
7. Add the bounded provenance-aware active/recent queue listing.
8. Add failure, legacy, malformed-state, duplicate-reader, and manager-unavailable tests.
9. Document the live harness bridge and stable event-ID/deduplication contract.
10. Run the lightweight real gate only after confirming shared-tree ownership.

## Adversarial design review

A read-only sub-agent review rejected the initial custom-supervisor ADR until it addressed ten
blockers: undefined launcher/worker writer handoff, pre-adoption death, forged durable abandonment,
PID/pidfd races, ambiguous lock evidence, incomplete wait codes, impossible global exactly-once
delivery, vague format-1 handling, uncaught internal failures, and untestable private-harness claims.

Those findings motivated the supervisor survey and the systemd-backed revision above. systemd
eliminates the writer-handoff and PID-liveness machinery from Python; the revised ADR also separates
canonical/effective state, defines bounded codes, changes notification to stable-ID deduplication,
and narrows repository tests to contracts they can actually prove. Implementation should treat the
review as a checklist, not as closed evidence: any fallback that reintroduces a detached Python
worker must be red-teamed again before acceptance.

A second adversarial pass on the systemd revision found additional blockers: invalid relative
`ExecStart`, successful-unit garbage-collection races, missing pre-submission identity, unit-name
reuse, overclaimed recovery across user-manager loss, unbounded failed-unit retention, incomplete
D-Bus attachment order, terminal-before-lock-release risk, underspecified cgroup shutdown, and
failure-before-status ambiguity. The final proposed ADR incorporates each point through absolute
argv, immutable submission/InvocationID binding, durable completion capture before exact cleanup,
explicit manager-loss limits, a normative D-Bus algorithm, lock-before-terminal ordering, and
external `failed-before-status` evidence. Task Spooler was reconsidered and remains a portability
alternative rather than the preferred tool on this host.

A final tightening pass required the InvocationID handshake to occur concurrently with the blocking
wait, expanded manager identity beyond boot ID to a race-checked D-Bus-owner/PID/start-tick tuple,
and selected `KillMode=mixed` with a pinned 120-second stop timeout so Python gets the first chance to
forward, reap, unlock, and publish. Origin attribution is also first-class: every agent submission
and queue view carries user, native harness session ID, work lane, and allocated C-task.
