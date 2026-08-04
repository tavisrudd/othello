# Adversarial review: the `build` front door in the Lean build queue (2026-08-04)

**Lane**: `build-sys` tooling (reviewed from a `clebsch` session; no files outside this note were
edited, and no Lean, Lake, or real-target build was run).

**Subject**: commit `01ca39f5`, "Add a build front door that needs no prior lock check" —
`lean/scripts/lean-build-queue.py` (`build`, `await`, `lock`, `settled_state`,
`first_error_lines`, `render_envelope`, `wait_for_terminal`),
`lean/scripts/test_lean_build_queue.py` (six new tests), `lean/AGENTS.md`.

**Method**: read `lean/AGENTS.md`, the full diff, and the whole of `lean-build-queue.py`; verified
the log-glob shapes against the real run directory
`~/.cache/othello-lean-build/run-20260804-181556-19a40b95`; ran the hermetic suite (30 tests, all
pass, 22.7s); and ran three additional hermetic probes built on the suite's own fixture (invalid
target, expired lock wait, live foreign Lean process) to settle the failure modes below by
observation rather than by reading. Every probe used the fixture's stub `lake`/`nix`/`pgrep`; none
touched the real Lean tree.

---

## BLOCKER 1 — a build that dies before writing `status.json` is reported as "still running", with exit 0

`lean/scripts/lean-build-queue.py:1298-1303` (`command_build`) and `:1101-1120` (`settled_state`).

`settled_state` returns `(None, None)` whenever `status.json` is absent, and `wait_for_terminal`
treats that as "not settled yet". But `command_run` creates `status.json` only at line 619 — after
target-name validation, after the resource-profile check, after the disk-backed/tmpfs check, and
after `acquire_lock` returns. Every refusal before that point leaves the run directory with a
`launcher.log` and no `status.json` at all, and `build` cannot distinguish it from a healthy
long-running build.

Observed, hermetically:

- `build "Not A Module" --foreground 6` → 6.1s wall, **exit 0**, stdout is
  `state: still running after 6s` plus a `resume:` command. `launcher.log` contains
  `lean-build-queue: invalid module name: 'Not A Module'`. No `status.json` was ever created.
- `build Fix.Alpha --lock-wait 2 --foreground 6` against a held lock → identical outcome: the
  child gave up on the lock after 2s, and `build` still reported "still running after 6s" and
  exited 0.

With the shipped defaults this means a typo'd module name burns the full `--foreground` 600s,
prints a resume command, and returns success. An agent that then runs the handed-back `await`
blocks for its full `--timeout` (default 3600s) and exits 124, because `command_await` accepts a
run directory that has only `detached.json` (line 1228) and `settled_state` never settles. The
front door's entire promise — "never has to discover a failure later" — inverts into a 70-minute
silent failure that reports success.

`lean-build-systemd.py:1232` already models exactly this case as a distinct state
(`"failed-before-status" if status is None else "abandoned"`); the new code does not.

**Fix**: in `command_build`, do not rely on the child's status file alone. Either (a) keep the
launcher PID from `detached.json` and treat "launcher exited **and** no `status.json`" as a
terminal `failed-before-status`, or (b) have `settled_state` return that state when `detached.json`
exists, its `launcher_pid` is gone, and `status.json` is absent. Map it to a new `EXIT_INVALID=125`
(matching `lean-build-systemd.py:28`), and print `launcher.log`'s error lines — `first_error_lines`
already falls back to `launcher.log` and would have surfaced the real message. `command_await`
needs the same treatment; it currently waits an hour on a corpse.

## BLOCKER 2 — `--lock-wait` is forwarded to `--wait-quiet-seconds`, so the default makes a build squat on the shared lock for an hour waiting for a foreign `lean` process

`lean/scripts/lean-build-queue.py:1257-1258` forwards `--lock-wait` (default 3600, line 1527) into
`run --wait-quiet-seconds`. That single option feeds **two** different waits:

- `command_run:583-589` — `acquire_lock(..., wait_seconds=args.wait_quiet_seconds)`, i.e. how long
  to queue behind another *build owner*. This is the intended semantic.
- `command_run:626` and `:740` — `wait_for_quiet(pgrep, args.wait_quiet_seconds, ...)`, called
  **once per target and once before the aggregate gate**, *while already holding the build-owner
  lock*, and blocking until `pgrep -x lake.orig` and `pgrep -x lean` both come back empty
  (`BUSY_COMMANDS`, line 53). Its `waited` counter resets on every call, so an N-target build can
  wait N+1 separate hours.

The consequence on a shared machine is worse than a semantic mismatch. `run`'s own default is 0 —
refuse immediately and *release the lock*. Under `build`, the same situation becomes: acquire the
lock, then idle for up to an hour holding it, then refuse. Every other lane's `build` queues behind
that idle hour. And `pgrep -x lean` matches a Lean **language server** as readily as a build, so an
editor left open on this host is enough to trigger it.

Observed, hermetically: with the fixture `pgrep` reporting a live `lean`, `build ... --foreground
20` sat for the full 20s with `status.json` still `"state": "running"`, having taken the lock, and
handed back a resume command with exit 0. With `--lock-wait 2` the same run refused at ~2s.

**Fix**: separate the two waits. Add `run --wait-lock-seconds` (or pass the quiet wait explicitly)
so `build --lock-wait N` sets only `acquire_lock`'s deadline, and give the quiet wait its own,
much smaller `build` option defaulting to something on the order of 60-120s. A wait that is held
across the shared lock must never default to an hour.

## MAJOR 3 — a `refused` run is reported as `abandoned`, with a false explanatory note and the wrong exit code

`lean/scripts/lean-build-queue.py:1091` (`TERMINAL_STATES`), `:1093-1099` (`STATE_EXIT_CODES`),
`:1111-1120` (`settled_state`).

`command_run:766-769` writes `status.finish("refused", error.code)` for every `Refused` raised
after the status file exists — a live foreign Lean build, a failed `pgrep`, a cache-restore
refusal. `"refused"` is not in `TERMINAL_STATES` and not in `STATE_EXIT_CODES`, so `settled_state`
falls through to the lock check, finds the lock released (`command_run:770-771`), and returns
`"abandoned"` with the note *"no live owner holds the lock; the run died without a terminal
status"* — which is false; the run wrote a terminal status. `STATE_EXIT_CODES.get` misses, so
`command_build`/`command_await` return `EXIT_BUILD_FAILED` (1)... except `"abandoned"` *is* in the
map, so the actual return is 126.

Observed, hermetically: `state: abandoned`, that note verbatim, **exit 126**, on a run whose
`status.json` says `"state": "refused"`. `command_status` on the same directory prints
`state: refused`. Two commands, same run, contradictory answers — and 126 tells the reader "OOM
kill or SIGKILL" when the truth was "a foreign Lean process was live".

The surfaced error line was correct (`! lean-build-queue: a foreign Lean build is live (lean)…`),
which is the only reason this is not a blocker.

**Fix**: `TERMINAL_STATES = {"success", "failed", "refused", "interrupted"}` and add
`"refused": EXIT_REFUSED` to `STATE_EXIT_CODES`.

## MAJOR 4 — Ctrl-C on `build` prints a traceback, orphans a running build that still holds the lock, and exits 130

`command_build` (line 1241) never installs signal handlers; `signal.signal(SIGINT/SIGTERM,
_handle_signal)` lives only inside `command_run` (`:579-580`). So the module-global `_interrupted`
is never set in a `build`/`await` process, and `_sleep` (`:304-309`) — whose only interrupt path is
that flag — cannot raise `Interrupted`. `main()` (`:1563-1570`) catches `Refused` and nothing else.

A Ctrl-C therefore raises `KeyboardInterrupt` inside `time.sleep`, prints a Python traceback, and
exits 130 (verified). Three problems, in ascending order:

1. A traceback is exactly the unbounded, alarming output the guide's diagnostic discipline exists
   to prevent.
2. 130 collides with `STATE_EXIT_CODES["interrupted"]`, so "I cancelled my wait" and "the build was
   interrupted" are indistinguishable to any caller keying on the exit code.
3. Worst: the detached build keeps running and keeps the build-owner lock, and nothing is printed —
   not the run directory, not a resume command. A user who Ctrl-Cs `build` has every reason to
   believe the tree is now free. It is not. That is precisely the misapprehension the lock exists
   to prevent, and the same applies to a SIGTERM'd `build`.

**Fix**: install a handler in `command_build`/`command_await` (or catch `KeyboardInterrupt` in
`main`) that prints one line — the run directory, the resume `await` command, and an explicit "the
build is still running and still owns the lock" — then exits with a code distinct from 130
(EXIT_TIMED_OUT/124 fits: a caller-side abandonment that mutates nothing).

## MAJOR 5 — the run directory is recovered by scraping the child's stdout

`lean/scripts/lean-build-queue.py:1285-1296`.

`build` re-invokes itself with `capture_output=True` and then hunts `launch.stdout` for a line
starting `run dir:`, keeping the last match. Every one of the failure modes is silent:

- The format string lives in `command_detached_run:831` (`f"run dir:      {run_dir}"`, padded, note
  the alignment differs from `command_run:620`). Any reformat, or a rename of the label, and
  `run_dir` is `None` → `fail(...)` → exit 2 with a message assembled from empty strings.
- If the child prints nothing but exits 0, the same silent path.
- If the child creates the directory and then fails (`command_detached_run:797` mkdir, `:807`
  Popen), the directory exists but is unreachable to the parent.
- Nothing validates that the scraped path is the one `build` asked for.

This is unnecessary. `build` already accepts `--run-dir` and forwards it (`:1275-1276`); it can
generate the path itself (the same `stamp`/`uuid4` idiom used at `:786-789`), always pass it
explicitly, and then never parse stdout at all. Failing that, read `detached.json`'s `run_dir` key,
which is a documented format-versioned record rather than a display string.

**Fix**: always pass an explicit `--run-dir` and drop the stdout parse.

## MAJOR 6 — the queueing test's central assertion is vacuous

`lean/scripts/test_lean_build_queue.py`, `test_build_queues_behind_an_owner_instead_of_refusing`.

`time.sleep(2); self.assertIsNone(child.poll(), "must wait for the owner rather than refuse")`
cannot fail for the reason its message states. `build`'s child is `run --detach`, which returns
immediately; the *grandchild* is what blocks in `acquire_lock`. The parent `build` is therefore
sitting in `wait_for_terminal` for its full `--foreground` window (600s here) no matter what the
grandchild is doing — including the case where the grandchild died instantly, which is exactly
BLOCKER 1. The assertion would hold with the queueing behaviour entirely removed.

The `assertIn("queueing behind run foreign-run", stdout)` check is likewise weak: that line comes
from the parent's pre-spawn `lock_holder` read at `:1277-1282`, which is informational and would
print whether or not the child ever queued. The only real evidence in this test is the terminal
`state: success` after the lock is released.

It also omits the check the corresponding refusal test does perform: nothing asserts that no build
ran *while* the lock was held. The fixture already records every `lake` invocation in
`$FAKE_LAKE_STATE/lake-calls.log`.

**Fix**: while still holding the lock, assert `lake-calls.log` contains no `nobuild=0` entry (or
does not exist), and drop or re-target the `poll()` assertion.

## MINOR 7 — `first_error_lines` returns the *last* errors under the real `run-quiet`, and the fixture cannot catch it

`lean/scripts/lean-build-queue.py:1131-1157`.

The glob depth is **correct** — verified against the real directory: `logs/<target>.log` exists,
and `logs/<target>.quiet/<run-id>/<timestamped-command-slug>/stdout.log` matches
`f"{failed}.quiet/*/*/stdout.log"` exactly (checked with `Path.glob`, one hit). The suspected
depth bug is not present.

The ordering is wrong instead. `logs/<target>.log` is checked first, and the loop returns as soon
as *any* candidate yields a match (`if found: return found`, line 1155). Under the real `run-quiet`
that file is not a build log — it is the wrapper's summary, which ends with
`--- stderr (last 10) ---` and `--- stdout (last 5) ---` **tail** previews (confirmed in the real
run directory). On a failing build those tail lines are where Lake's closing `error:` lines land,
so the function named `first_error_lines` will return the last errors and never open the full
`stdout.log` that holds the first one. For a Lean failure the first error is the one that matters;
the rest are usually cascade.

The fixture's `run-quiet` stub prints only `exit=%s dir=%s` with no tail preview, so in the tests
`<target>.log` never matches and the function falls through to the quiet `stdout.log` — the tests
pass by exercising a code path that real logs will not take.

**Fix**: put the quiet `stdout.log`/`stderr.log` globs ahead of `<target>.log` in `candidates`, and
teach the stub to emit a tail preview so the fixture matches the real wrapper's shape.

## MINOR 8 — aggregate-gate and cache failures surface no errors at all

`lean/scripts/lean-build-queue.py:1133-1137`. Targets beginning with `<` are excluded, which covers
the two sentinel `failed_target` values the runner actually writes: `"<aggregate>"`
(`command_run:756`) and `"<mathlib cache get>"` (`:683`). Neither
`logs/aggregate-no-build.log` nor `logs/mathlib-cache-get.log` is ever a candidate. A stale-trace
aggregate-gate failure is a routine outcome, and it is the one the envelope explains least. In the
`build` path the `launcher.log` fallback partly rescues it, since the detached child's stderr tail
lands there; an `await` on a foreground-started run gets nothing.

**Fix**: map the two sentinels to their known log paths instead of skipping them.

## MINOR 9 — silently dropped `run` options, and `--run-arg` as the escape hatch

`lean/scripts/lean-build-queue.py:1250-1281` forwards only `--profile`, `--threads`,
`--wait-quiet-seconds`, `--detach`, `--cores`, `--lean-root`, `--aggregate`, `--lock-file`,
`--run-dir`. Not forwarded, and not mentioned in the help text: `--serial-first` (the guide's own
recommended shape for a heavy shared dependency), `--cache-mode` (including `require`, which the
guide names for a clean replay), `--choom-adjust`, `--tail-lines`, `--heartbeat-seconds`,
`--poll-seconds`, `--profile-file`, and the binary overrides. `--serial-first` and `--cache-mode`
are the two a real caller will reach for.

`--run-arg` is `action="append"` taking one argv token each, so a flag with a value needs two
separate occurrences (`--run-arg=--cache-mode --run-arg=require`). Nothing documents that; the help
string says only "the ordinary front door needs none". A caller who writes
`--run-arg "--cache-mode require"` gets an argparse error from the child, surfaced through the
BLOCKER-1 path as "still running". Promote `--serial-first` and `--cache-mode` to real `build`
options and document the pair form.

## MINOR 10 — `settled_state` and `command_status` duplicate the abandoned rule and already disagree

`:1111-1120` versus `:1315-1323`. `command_status` promotes only when `state == "running"`;
`settled_state` promotes whenever the state is not in its three-element terminal set. That is the
mechanism of MAJOR 3, and it will drift again the next time a state is added. The lock-ordering
itself is sound: `command_run` writes the terminal status (`:759`, `:764`, `:768`) before the
`finally: lock.close()` at `:770-771`, so there is no window in which a genuinely terminal run is
seen as abandoned. The remaining false-positive path is a readable `status.json` with an unreadable
or missing `manifest.json` — `lock_holder(Path(""))` returns `None` and the run is declared
abandoned immediately.

**Fix**: extract one `classify(status, manifest)` helper and call it from both.

## MINOR 11 — the "read-only" query briefly takes the exclusive lock, now on a 2-second loop

`lock_holder` (`:1000-1023`) probes with `fcntl.LOCK_EX | LOCK_NB` and, when the lock is free,
holds it for the microseconds until `LOCK_UN`. That is pre-existing, but `settled_state` now calls
it every `poll_seconds` (2s, hard-coded at `:1182`) for the entire life of every `build` and
`await`. A real `acquire_lock` retrying on its 60s cadence can now, with small probability, land in
that window and wait another 60 seconds. Probe with `LOCK_SH`, or at minimum note that `await`'s
"never mutates" claim covers the run directory and not the shared lock's advisory state.

## MINOR 12 — the new tests can leave a detached grandchild behind

`tearDown` is `shutil.rmtree(self.tmp)` only. The three `build` tests spawn a detached run process
that nothing tracks. On the happy path `build` outlives it; on an assertion failure or a
`subprocess.run(timeout=…)` expiry, only the direct `build` child is killed and the detached
grandchild survives `rmtree`, holding a now-unlinked lock file and possibly a `sleep 30` stub. It
cannot reach the real Lean tree (every tool is a stub and the lock file is per-test), so this is
containment hygiene rather than a cross-lane hazard. Record each `build` run directory and, in
`tearDown`, terminate the `launcher_pid` recorded in its `detached.json`.

The other five new tests behave as their names claim, with two caveats:
`test_build_hands_back_one_resume_command_when_it_outlasts_the_window` uses `--foreground 0`, so it
exercises the zero-timeout shortcut in `wait_for_terminal` rather than a build that genuinely
outlasts a window — and it is indistinguishable from BLOCKER 1's output; and
`test_await_timeout_is_non_mutating_and_resumable` asserts exit 130 after a **SIGTERM**, which is
right for "the run recorded `interrupted`" but reads oddly against the shell convention that 130 is
SIGINT and 143 is SIGTERM. `test_build_reports_the_outcome_without_a_second_command`,
`test_build_surfaces_the_first_error_without_opening_a_log`, and
`test_lock_names_the_owner_and_is_free_afterwards` prove what they claim.

**Suite result**: `python3 scripts/test_lean_build_queue.py` → 30 tests, OK, 22.7s.

## NIT 13 — `build_argv`'s passthrough reconstruction is a latent breakage

`test_lean_build_queue.py`, `build_argv`. It slices `run_argv` at `3 + len(targets)` and then walks
the remainder assuming strict flag/value pairs. Add one `store_true` flag to `run_argv`, or reorder
it so a skipped flag is no longer at an even offset, and the loop either raises `IndexError` or
silently pairs a flag with the next flag. `--profile` is also emitted twice (once explicitly, once
through the passthrough) and survives only because argparse takes the last. Build the passthrough
from an explicit dict of fixture overrides instead of by slicing another helper's output.

## NIT 14 — smaller items

- `resume:` (`:1302`) prints the resolved absolute script path, whereas `AGENTS.md` documents the
  repo-relative form; and the test recovers the path with `line.split("await", 1)[1]`, which breaks
  if the checkout path ever contains `await`.
- `command_build`'s launch-failure path (`:1294-1296`) writes `launch.stderr` and then repeats it
  inside the `fail` message.
- `queueing behind run …` is printed from a read taken before the spawn; by the time the child
  runs, the owner may be gone. Harmless, and consistent with the documented non-reservation
  caveat, but the line is stated as fact.
- `command_lock` returns `EXIT_REFUSED` (2) when the lock is held. Defensible, but a command
  documented as "informational" returning nonzero under `set -e` deserves a documented contract.

---

## E. Documentation

`lean/AGENTS.md:45-77` and the module docstring (`lean-build-queue.py:8-14`).

- **"Its exit code is the build's: 0 success, 1 build failure, 130 interrupted, 126 abandoned"** is
  incomplete in the way that matters most. Exit 0 *also* means "handed off, still running"
  (`:1303`) — the two outcomes a caller most needs to distinguish share a code. Exit 2 (the
  `fail()` path when the child cannot be started, plus `lock` on a held lock) is undocumented, and
  126 is currently reachable for a plain refusal (MAJOR 3). Document 0-with-`resume:` explicitly,
  or better, give the handoff its own code.
- **"prints … on failure, the first errors, so a caller never opens a log"** overstates on two
  counts: aggregate-gate and cache-restore failures surface nothing target-specific (MINOR 8), and
  what is printed is the last errors rather than the first under the real wrapper (MINOR 7).
- **"Do not ask whether the lock is free before calling it — that question is what this command
  exists to remove"** is well supported for lock *contention*: `build` genuinely queues. It is not
  yet supported end to end, because the same call can (BLOCKER 2) hold the lock for an hour waiting
  on an unrelated `lean` process, and can (BLOCKER 1) report success for a build that never
  started. The sentence should stand only after those are fixed.
- The `await` paragraph is accurate: exit 124 is non-mutating and resumable, and the command is
  read-only with respect to the run directory (verified: it opens only `status.json`,
  `manifest.json`, `detached.json`, and log files for reading).
- The `lock` paragraph is accurate and appropriately emphatic about not building check-then-act on
  it.
- The `build` help text should state that `--lock-wait` currently also governs the foreign-quiet
  wait, until BLOCKER 2 separates them.

---

## Verdict

**NO-GO** as the documented default entry point, pending BLOCKER 1, BLOCKER 2, and MAJOR 3. The
design is right and the surrounding machinery is used correctly, but as shipped the front door
returns exit 0 for a build that never started (verified twice hermetically) and can hold the shared
build-owner lock idle for an hour because one option drives two unrelated waits. On a machine where
every lane serializes through this lock, those are not cosmetic. All three fixes are small and
local; with them plus MAJOR 4 (interrupt handling) this becomes GO-WITH-FIXES on the rest.

Until then, `lean/AGENTS.md` should not present `build` as the ordinary path — the existing
`run --detach` plus `status` sequence remains correct.

**Categories where nothing is wrong.** The `first_error_lines` glob *depth* is correct: checked
against a real successful gate run, both `logs/<target>.log` and
`logs/<target>.quiet/*/*/stdout.log` resolve to real paths. `await`'s non-mutation of the run it
watches is real. The terminal-status-before-lock-release ordering in `command_run` is correct, so
there is no false-`abandoned` race for the states `settled_state` covers. The internal 2-second
poll of a disk file does **not** violate the guide's no-polling rule: that rule bans an *agent*
spending turns re-asking a healthy build, and a single blocking command that returns one bounded
envelope is the shape the rule is trying to produce — `acquire_lock` already polls the same way.
And the whole change respects ownership: nothing here kills, cleans, rebuilds, or inspects foreign
work, and no new process-table search was introduced.

---

## Resolution (2026-08-04, same day)

Every blocker and major is fixed; the suite is 35 tests, green.

- **BLOCKER 1** — `settled_state` now returns `failed-before-status` when a detached launcher is
  gone and no status file exists, mapped to `EXIT_INVALID` (125) and rendered with the launcher
  log's errors. Both reported failure modes are pinned by new tests: an invalid module name, and
  an exhausted lock wait.
- **BLOCKER 2** — the two waits are separated. `run` gained `--wait-lock-seconds`, defaulting to
  `--wait-quiet-seconds` so existing callers are unchanged; `build` passes `--lock-wait` (3600)
  and `--quiet-wait` (120) independently. A new test asserts that a large lock wait does not
  become a large quiet wait and that the refusing run releases the lock.
- **MAJOR 3** — `refused` added to `TERMINAL_STATES` and `STATE_EXIT_CODES`; a test asserts
  `await` reports `refused` with exit 2 and never the false abandonment note.
- **MAJOR 4** — `build` and `await` catch `KeyboardInterrupt` and print the run directory, the
  resume command, and that the build still runs and still owns the lock, exiting 124.
- **MAJOR 5** — `build` generates the run directory itself and always passes `--run-dir`; the
  stdout scrape is gone.
- **MAJOR 6** — the queueing test now asserts no build ran while the lock was held and that the
  foreign owner still held it, replacing the vacuous `poll()` assertion.
- **MINOR 7** — candidate order reversed so the full quiet log is read before the wrapper's tail
  summary, and the fixture's `run-quiet` stub now emits tail previews so the tests exercise the
  real shape. A test asserts the *first* error is returned.
- **MINOR 8** — `<aggregate>` and `<mathlib cache get>` map to their known logs.
- **MINOR 9** — `--serial-first` and `--cache-mode` promoted to real options; the `--run-arg`
  pair form is documented.
- **MINOR 10** — one `classify(status, manifest)` helper, called by both `settled_state` and
  `command_status`.
- **MINOR 12** — `tearDown` terminates any launcher recorded in a run directory's
  `detached.json`.
- **Documentation** — the exit-code list is now a table covering all seven codes, states that 0
  carries two outcomes distinguished by the `resume:` line, and warns against raising
  `--quiet-wait`.

Not taken, deliberately: MINOR 11 (`lock_holder` probing with `LOCK_EX`) is pre-existing
behaviour shared with `command_status`, and narrowing it to `LOCK_SH` belongs with the owning
lane rather than in this change. NIT 13's `build_argv` reconstruction is test-only scaffolding
and was left as is.
