# C225: Lean queue completion notification

**Lane**: `build-sys`
**Date**: 2026-07-16
**Status**: REPORTED 2026-07-18 — implementation steps 1–11, the hermetic matrix, and operator
guidance all landed, and the managed path was exercised end-to-end against real Lean work on the
C151 target. The supervision contract is what that run proved: submission, InvocationID acceptance,
adoption, lock ordering, phase publication, terminal reconciliation, attribution, and exact cleanup.
The Lean outcome it returned was a canonical `failed`/1 naming C151 `decide` errors, so a *green*
managed compile remains unobserved; gate 16's success path is closed by decision rather than by
evidence, and anyone citing this work should say the bridge was proven, not that a target built.

## Goal

Make a queued Lean run observable from submission through success, failure, refusal, interruption,
or abnormal death, and return one bounded completion event to an agent harness without spending
model turns on `sleep`/`status` polling.

## Scope and ownership

Owned implementation paths:

- `lean/scripts/lean-build-queue.py` and its focused tests
- the adjacent `lean/scripts/lean-build-systemd.py` adapter, capability probe, and focused tests
- narrow operator guidance in `lean/AGENTS.md`
- this handoff, the C225 supervisor survey, and the C225 queue row

Rollout constraint (user direction, 2026-07-16): other agents are using the legacy Python queue.
Do not edit, stop, or change the launch contract beneath those users. Build and exercise the C225
path as adjacent, explicitly selected tooling with separate managed run directories. Keep the
legacy path available during migration; removal or in-place convergence requires a later confirmed
quiescent window and explicit rollout decision.

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

**Status:** Accepted 2026-07-18, revised after adversarial review

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
user=<effective account>, harness=codex|claude|manual, session_id=<native harness session>,
work_lane=<explicit lane alias>, task_id=<caller-attested C###>
```

The Codex adapter records `CODEX_THREAD_ID`; the Claude adapter must pass Claude's native session ID
explicitly rather than relying on prompt or PID inference. `work_lane` is the selected ownership
lane, not a value inferred from Git. Codex/Claude submissions require a caller-attested task matching
`C[0-9]+`. This is attribution, not registry authorization: the adapter does not parse the task
queue or prove that the task is allocated or lane-pegged. Repository agent rules remain responsible
for allocation and lane correctness. Manual non-task probes use `task_id=null`, are visibly marked
`manual`, and may not be presented as lane work. Manual submission requires an explicit stable
session token.

Scope identifiers have symmetric CLI/environment inputs:

| Field | CLI | Environment |
|---|---|---|
| harness | `--harness codex|claude|manual` | `OTHELLO_HARNESS` |
| native session | `--session-id ID` | `OTHELLO_SESSION_ID` |
| work lane | `--lane ALIAS` | `OTHELLO_LANE` |
| C task | `--task-id C###` | `OTHELLO_TASK_ID` |

Resolution is per field: an explicit CLI option wins, then a nonempty `OTHELLO_*` value, then a
documented native-harness value only for fields the harness actually supplies (`CODEX_THREAD_ID`
may fill session ID and identifies Codex). Conflicting lower-precedence values are retained in a
bounded diagnostic but never silently override the winner. Values are normalized and validated
once, then the resolved origin object is written to immutable `submission.json`; downstream code
does not resolve the environment again.

Agent submissions fail before systemd submission if session, lane, or C-task remains missing or
invalid. They never infer lane/task from Git state, the current handoff, prompt text, or a previous
run. The OS account is resolved from the effective UID, is not caller-controlled, and must own both
the configured state root and new run directory. `tavis` is the expected value on this host, not a
hard-coded queue-tool requirement.

For set-once use, launch the Codex/Claude session with `OTHELLO_LANE` and `OTHELLO_TASK_ID` in its
parent environment; the harness supplies its native session ID. Exporting variables inside one
short-lived agent shell command cannot mutate the parent agent environment and therefore does not
persist to later tool calls. A future session-scope command/file would be a separate explicit
source with defined precedence, not an implicit fallback added to this ADR.

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

`Type=exec` makes failed `execve` distinguishable from a successfully started worker to the live
waiting client. On the supported host, that start failure returns client code 1 with a bounded
diagnostic and the transient unit is immediately unloaded, so it supplies no retained
`InvocationID` for later recovery. `--wait`
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
All three adapter records are set-once. A publisher writes and fsyncs a same-directory temporary,
installs it with a no-replace primitive, then fsyncs the directory. If the final path already exists,
the adapter validates the existing bounded regular file against immutable identity and expected
content; byte-identical or canonically identical content is idempotent, while any conflict is a hard
error and suppresses notification. No adapter overwrites `submission.json`, `accepted.json`, or
`completion.json`. The queue worker is the sole writer of `status.json`.

Do not use `--collect` initially. Services that start and then fail or terminate abnormally should
remain inspectable until the result has been captured; successful units may unload normally after
the queue has atomically recorded success. A `Type=exec` start failure is the measured exception:
the live client must capture it before returning because this manager unloads it immediately.
Cleanup/reset of retained failed transient units happens only after outcome capture.

The first implementation must retain the queue's measured `taskset`, thread, `choom`, and quiet-log
behavior. Moving those controls to systemd properties is a separate measured decision.
`KillMode=mixed`, `SendSIGKILL=yes`, and `TimeoutStopSec=120s` are part of the proposed C225 contract.
On stop, only Python receives TERM initially, so it can forward to and reap its child, release the
lock, and publish interruption status. After Python exits, or after 120 seconds, systemd sends KILL
to remaining cgroup processes. The shutdown fixture must validate this ordering before the ADR is
accepted; changing the timeout requires an explicit design amendment rather than inheriting a host
default.

#### 2. Adopt the adapter-owned run directory and keep one status writer

The adapter exclusively creates the managed run directory; the foreground worker never recreates it
or silently substitutes another path. Before writing anything, the worker uses `lstat` and
descriptor-relative checks to verify that the state root, run directory, and `submission.json` are
non-symlink objects owned by its effective UID, have the required restrictive modes, and reside at
the absolute paths passed by the adapter. It parses bounded `submission.json`, recomputes its digest,
and requires matching run ID, unit, argv, effective account, and the run-ID/submission-digest
environment nonces. Any mismatch exits before `status.json`, lock acquisition, or Lake invocation.

After successful adoption, the worker creates format-2 `status.json` before attempting the
build-owner lock. Python is its sole writer for the worker lifetime. Standalone legacy foreground
mode may retain its separate directory-creation contract but cannot claim C225 managed provenance.

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
If `execve` itself fails, only a live adapter that captured the `Type=exec` client failure may use
that effective state. A later recovery observer with no retained unit reports `unknown`.
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

Delivery semantics are not globally exactly-once. C225 defines `terminal_revision=1` in immutable
submission metadata; set-once completion has no correction or overwrite path. Every adapter derives
the same callback event ID, `lean-queue:<run-id>:terminal:1`, from immutable input rather than local
observation time. A future correction protocol must allocate a new explicit terminal revision and
is outside C225. A live adapter emits at most once; recovery after a harness crash is at-least-once
and consumers deduplicate by event ID. Callback failure never changes queue state.

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

- We introduce an adjacent systemd-managed path without changing the legacy Python detach contract
  beneath active users. Migration/deprecation is a later quiescent rollout decision.
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
   records a fully matched InvocationID before successful-unit GC without a resubmit race. The
   effective account owns the configured state root; `tavis` is a host expectation, not a fixture
   constant. Task/lane are visibly caller-attested rather than registry-verified.
3. Table-driven origin tests cover CLI-over-environment precedence, native Codex session fallback,
   explicit task/lane overrides for a session switch, empty/invalid/conflicting values, and refusal
   when required agent scope remains unresolved.
4. Managed-run adoption tests cover missing/replaced/symlinked/wrong-owner/wrong-mode directories,
   submission digest and environment-nonce mismatch, and path substitution. Every mismatch exits
   before status, lock acquisition, or Lake; the worker never recreates the adapter-owned directory.
5. Concurrent adapters prove no-clobber publication of submission/acceptance/completion records,
   idempotent identical reads, hard failure on conflicting content, and the identical event ID
   `lean-queue:<run-id>:terminal:1` for every valid observer.
6. Status exists in `queued/waiting-for-lock` before a held owner lock is released; no Lake command
   is invoked during that phase.
7. Lock timeout records `refused`/2; build and aggregate failures record `failed`/1; SIGTERM records
   the signal and the documented interrupted code.
8. With `KillMode=mixed` and `TimeoutStopSec=120s`, stop with a live child proves TERM reaches Python
   first, Python forwards/reaps, releases the lock, and records interruption before exit; escalation
   leaves no cgroup descendant. Forced worker/cgroup death and failure before status creation yield
   bounded external effective states without mutating canonical disk state.
9. Notification occurs only after service exit/lock release, uses a stable event ID, and is at most
   once per live adapter invocation. Two adapters may emit the same ID and are deduplicable.
10. A harness fixture owns one blocking wait and consumes one bounded completion envelope; it uses no
   `sleep`, repeated `status`, process-table polling, or live-log capture. Private harness delivery
   beyond that adapter contract is not claimed as a repository test.
11. Inspection handles already-complete, malformed, oversized, missing, format-1, and manager-
   unavailable cases without following untrusted paths or blocking on non-regular files.
12. Successful-unit GC, exact failed-unit capture/reset, cleanup failure, InvocationID mismatch,
   missing-manager evidence, and the D-Bus subscribe/read boundary all have focused fixtures.
13. JSON creation/replacement is visibility-atomic and directory-fsynced where process-crash
   durability is claimed; run directories/files use restrictive permissions.
14. Per-run status and the capped queue list expose full machine-readable and abbreviated human
    session/lane/C-task attribution, including concurrent jobs from Codex and Claude fixtures.
15. Operator guidance distinguishes submitted, queued, lock-owned, child-spawned, and completed.
16. After the non-Lean fixtures pass, one disposable lightweight target exercises the real
    systemd-run→queued/running→terminal bridge in a confirmed quiet window.

## Implementation order

1. Build a tiny non-Lean systemd probe covering exit propagation, signal, failed exec, unit naming,
   result inspection, and cleanup; record the exact supported command/property set.
2. Implement and table-test CLI/environment/native origin resolution.
3. Implement restrictive origin/manager/submission identity and the absolute-argv transient-service
   adapter, including the concurrent InvocationID handshake.
4. Implement strict adoption of the adapter-owned run directory, then create format-2 status before
   lock acquisition and publish phases as the sole status writer; move terminal publication after
   lock release.
5. Add bounded completion capture, exact failed-unit cleanup, and the primary `--wait` bridge.
6. Implement D-Bus reattachment only after its subscribe/ref/snapshot algorithm passes race tests.
7. Add systemd-path guidance without changing legacy `--detach` during the parallel rollout. After
   migration and a confirmed quiescent window, make an explicit keep/deprecate/converge decision;
   do not silently redirect legacy invocations.
8. Add the bounded provenance-aware active/recent queue listing.
9. Add failure, legacy, malformed-state, duplicate-reader, and manager-unavailable tests.
10. Document the live harness bridge and stable event-ID/deduplication contract.
11. Run the lightweight real gate only after confirming shared-tree ownership.

Step 1 passed on 2026-07-16 via
`lean/scripts/lean-build-systemd-probe.py`, without invoking Lean or the legacy queue. The measured
surface is systemd 258.7 with `--user --wait --quiet --service-type=exec`, absolute executable argv,
disabled environment expansion, explicit unit/description/working-directory/environment, and
`KillMode=mixed`, `SendSIGKILL=yes`, `TimeoutStopSec=120s`. Exit 0 and exit 7 propagate unchanged;
SIGKILL produces client code 255 plus retained `Result=signal`, `ExecMainCode=2`,
`ExecMainStatus=9`; failed exec produces client code 1 and no retained unit; killing only the
waiting client leaves the service active through independent completion. Successful services are
garbage-collected. Exact failed units are reset in fixture cleanup. On NixOS, absolute executable
paths must preserve multicall symlink spellings rather than resolving them and changing `argv[0]`.

Step 2 passed via the adjacent `lean-build-systemd.py` surface and 12 hermetic table/CLI tests.
Resolution is CLI over nonempty `OTHELLO_*` environment over native Codex identity; conflicting
lower-precedence values are retained in a bounded diagnostic. Codex native fallback both identifies
the harness and supplies `CODEX_THREAD_ID`; Claude never adopts that value. Agent origins require a
validated session, lane, and caller-attested `C###`. Manual probes require a stable session and
reject lane/task claims. The effective account comes only from the effective UID. This increment
does not submit systemd units, invoke Lean, or touch legacy run directories.

Step 3a landed the pre-launch identity substrate with 20 passing hermetic tests and a green
read-only query against the real user manager. It race-checks
owner→PID→`/proc` start ticks→owner, binds that tuple and a UUID-derived run/unit identity into a
bounded canonical `submission.json`, requires absolute bounded worker argv, creates state/run
directories at mode 0700 and records at 0600, fsyncs records and directories, and publishes via a
same-directory temporary plus no-replace hard-link installation. Eight concurrent identical
publishers converge on one digest; conflicts, symlinks, wrong modes, wrong owners, and UUID reuse
fail closed. No service submission or Lean invocation exists yet. Step 3b is the concurrent
`systemd-run --wait` plus D-Bus InvocationID acceptance handshake.

Step 3b now passes 25 default tests plus an opt-in real user-manager fixture. The adapter opens one
persistent `libsystemd` user-bus connection and calls `Subscribe` before spawning the blocking
`systemd-run --wait` client. Once the UUID unit appears it takes `RefUnit` on that same connection,
rereads a confirmed snapshot, and matches the unchanged manager generation, `Id`, `Transient`,
nonzero `InvocationID`, working directory, complete D-Bus-decoded `ExecStart` argv, run-ID nonce,
and submission-digest nonce before set-once publication of deterministic `accepted.json`. The
connection releases the exact reference after the waiter exits. The harmless live fixture used a
one-second `sleep`, observed exit 0, and cleaned its exact UUID unit; it never invoked Lean or the
legacy queue. Nix Python cannot discover `libsystemd` through `find_library`, so the supported host
fallback is the stable `/run/current-system/sw/lib/libsystemd.so.0` closure symlink. Step 3 is now
complete; step 4 remains strict managed-worker adoption and pre-lock format-2 status.

Step 4a adds the separate `lean-build-systemd-worker.py` without editing or importing execution
semantics from the active legacy runner. Nine default tests plus a real transient-service fixture
pass. Before any status or lock activity, adoption verifies non-symlink state/run directories and
`submission.json`, effective-UID ownership, exact 0700/0600 modes, bounded parse/digest, run/unit
derivation, absolute run and Lean-root paths, actual working directory, complete worker argv and
argv digest, effective account, and both environment nonces. Missing, replaced, symlinked,
wrong-mode, wrong-owner, path-substituted, nonce-mismatched, and preexisting-status cases all fail
without creating or overwriting status. After adoption the sole worker writer atomically publishes
format-2 `queued/initializing` and `queued/waiting-for-lock`. The live non-Lean fixture held its exact
fixture lock, observed that queued state while the service remained alive, released the lock, then
observed terminal success only after unlock; a timeout fixture records `refused`/2. This proves the
ordering substrate only. Step 4b must integrate the measured resource/quiet/build/aggregate
semantics into the new worker while leaving legacy users undisturbed.

Step 4b completes the managed execution semantics without changing the legacy CLI or its running
processes. During the parallel rollout, the new worker loads the checked-in legacy module as a
read-only compatibility core for its measured resource calculation, quiet checks, command argv,
telemetry parsing, and toolchain attribution; managed adoption, status, locking order, child phase
transitions, outcomes, and terminal publication remain in the new worker. Thirteen default worker
tests pass: resource/profile enforcement, CPU/thread/choom/run-quiet argv, serial-first execution,
trace-current skip, build success/failure, aggregate success/failure, foreign-busy refusal, and
post-terminal lock reacquisition, alongside the adoption suite. `running` is published only after
the owner lock is held; `building` and `aggregate-gate` only after their child successfully spawns.
Every outcome is retained locally, the lock is explicitly unlocked and closed, and only then is
format-2 terminal status published. No real Lean target has run; the eventual lightweight target
remains behind the confirmed quiet-window acceptance gate. Step 5 is bounded completion capture,
exact failed-unit cleanup, and the primary wait bridge.

Step 5 now durably reconciles queue and service exit inside the primary blocking bridge. After
`systemd-run --wait` returns, while the exact unit reference is still held, the adapter rereads the
bound invocation and strict bounded format-2 status, rejects run/format/InvocationID or terminal
exit conflicts, and derives canonical/effective state for terminal success/failure/refusal/
interruption, failed-before-status, nonterminal abnormal abandonment, or unknown. It installs one
deterministic `completion.json` before invoking the injected harness callback; the event ID is
always `lean-queue:<run-id>:terminal:1`. Callback or cleanup failure is bounded diagnostic output
and cannot rewrite the captured outcome. Only after durable capture and callback does a failed
service receive exact-name `reset-failed`; there is no broad cleanup. Twenty-eight adapter tests
and fourteen worker tests pass. Real transient fixtures prove both success and refusal: each emits
one callback and retains byte-identical completion, while refusal captures canonical `refused`/2
and `Result=exit-code` before its exact failed unit is reset and garbage-collected. A raw successful
sleep with no queue record honestly completes as `unknown`/125. No real Lean target ran.

Step 6 adds the adjacent `await RUN_DIR [--timeout]` reattachment path and completes the subscribed
algorithm for a lost primary waiter. One persistent user-bus lease installs bounded
`PropertiesChanged` and `UnitRemoved` matches before inspection, references the exact loaded unit,
rereads the confirmed InvocationID snapshot, and rereads service plus canonical disk state after
every D-Bus wake. It durably publishes and delivers only a reconciled terminal envelope; timeout,
manager-generation loss, and a missing unit with nonterminal state remain non-mutating `unknown`
observations. An existing completion is identity-validated and redelivered with the same event ID
for recovery deduplication. Thirty-seven default adapter tests cover terminal capture,
successful-unit GC, UnitRemoved with nonterminal state, zero-timeout behavior, failed-before-status,
manager restart, InvocationID mismatch, malformed status identity, and recovery redelivery. Two
opt-in live fixtures pass against the real user manager, including a referenced transient unit that
wakes through sd-bus without sleep or status polling. No real Lean target or legacy queue ran. Step
7 is adjacent CLI/operator rollout guidance without redirecting legacy `--detach`.

Step 7 exposes the primary bridge as the adjacent `lean-build-systemd.py run` command. It resolves
the explicit harness/session/lane/C-task origin, reserves one UUID identity, creates the immutable
submission, assembles the complete strict-worker argv with the measured resource and quiet-check
options, and uses the same legacy build-owner lock while retaining a separate managed state root.
The command blocks for and prints one bounded completion envelope; `await RUN_DIR` remains the
recovery path. Thirty-nine default adapter tests pass, including CLI assembly, shared-lock
selection, origin binding, module validation before state creation, and the Step 6 recovery suite.
Operator guidance now documents explicit selection, phase meanings, stable event-ID deduplication,
and timeout/unknown/abandonment codes while leaving `lean-build-queue.py --detach` unchanged. No
real Lean target ran. Step 8 is the bounded provenance-aware active/recent queue listing.

Step 8 adds `lean-build-systemd.py list`, a read-only active/recent view capped at 100 rows (20 by
default). The default table shows run ID, effective state, phase, lane, task, harness, an
unambiguous abbreviated session, and exact unit; `--json` retains the complete session and
effective account, while `--run-id ... --json` is the exact-run query. Completed rows come from
validated immutable completion records; nonterminal accepted rows consult only their exact bound
InvocationID and manager generation. Missing manager evidence yields `unknown`, not a forged death.
Unsafe/malformed directories and records are skipped with bounded diagnostics, and the command
never mutates queue/supervisor state or searches the process table. Forty-four default adapter tests
pass, including active/completed attribution, exact filtering, row caps, manager loss, unsafe-entry
rejection, session abbreviation, and both CLI output modes. No real Lean target ran. Step 9 is the
remaining failure, legacy, malformed-state, duplicate-reader, and manager-unavailable fixture
coverage from the acceptance matrix.

Steps 9 and 10 close the remaining hermetic inspection matrix and operator contract. The adapter
suite now has 46 passing default tests: malformed and oversized managed records are rejected,
completed failures resolve without live-manager access, manager loss stays `unknown`, and existing
completion redelivery preserves the stable event ID for duplicate-reader deduplication. The
unchanged 17-test legacy queue suite also passes, including lock-backed live/abandoned format-1
status behavior. `lean/AGENTS.md` documents the blocking bridge, recovery delivery, phase evidence,
stable event IDs, the human active/recent table, and the full exact-run JSON query. Both suites are
fully stubbed/hermetic and no real Lean target ran.

Step 11 carried real Lean targets through the managed bridge for the first time, on the C151 target
`RelativeConicArcs.Q25ResidualEquality` with the `single` profile, one thread, and cores `20-23`. The
first submission failed at the `lake build --no-build` probe with `lake: not found` and exit `127`:
the transient unit starts from the user manager's environment, and the shared
`nix develop --command bash -lc` argv then rebuilt `PATH` from `/etc/profile` and discarded the
devshell. An agent shell exports `__NIXOS_SET_ENVIRONMENT_DONE`, so the legacy path never observed
this. The adapter now sets that baseline on the unit and the acceptance handshake rejects a unit
lacking it; the completion envelope also carries `failed_target` and a derived `reason`. The rerun
elaborated for `53 s` and returned a canonical `failed`/1 naming
`RelativeConicArcs.Q25ResidualMinimumOrbits` `decide` failures, which are a C151 proof matter and not
a supervision defect. Both runs delivered exactly one bounded envelope with correct
`claude`/`alt-orbit-repair`/`C151` attribution, reset their exact failed unit, and used no polling.
Submission, InvocationID acceptance, adoption, lock ordering, phase publication, terminal
reconciliation, and cleanup are therefore exercised against real Lean work; a successful managed Lean
outcome still awaits a target that compiles.

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
and queue view carries user, native harness session ID, work lane, and caller-attested C-task.

The implementation-readiness review resolved the remaining ownership ambiguities: the adapter alone
creates the managed directory and the worker strictly adopts it; adapter records are set-once and
no-clobber across competing observers; terminal revision 1 fixes the deduplication ID; task/lane are
caller-attested attribution rather than registry proof; and effective-UID/state-root ownership
replaces a hard-coded username. With those constraints, the ADR is ready for implementation while
remaining `Proposed` until its acceptance gates pass.
